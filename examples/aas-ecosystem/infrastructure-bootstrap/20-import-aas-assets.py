#!/usr/bin/env python3
import base64
import json
import os
import sys
import time
import urllib.error
import urllib.request
from pathlib import Path

IMPORT_PATH = Path(os.getenv("AAS_IMPORT_PATH", "/import"))
MAX_WAIT_SECONDS = int(os.getenv("IMPORT_MAX_WAIT_SECONDS", "300"))
POLL_SECONDS = float(os.getenv("IMPORT_POLL_SECONDS", "2"))
# Existing documents are left untouched unless AAS_SEED_FORCE is set, so user edits survive restarts.
FORCE_IMPORT = os.getenv("AAS_SEED_FORCE", "false").strip().lower() in ("1", "true", "yes", "on")

AAS_REGISTRY_URL = os.getenv("AAS_REGISTRY_URL", "http://aasregistry-go:8082")
SUBMODEL_REGISTRY_URL = os.getenv("SUBMODEL_REGISTRY_URL", "http://submodelregistry-go:8083")
DISCOVERY_URL = os.getenv("DISCOVERY_URL", "http://aasdiscovery-go:8081")

AAS_REGISTRY_HEALTH_URL = os.getenv("AAS_REGISTRY_HEALTH_URL", "http://aasregistry-go:8082/health")
SUBMODEL_REGISTRY_HEALTH_URL = os.getenv("SUBMODEL_REGISTRY_HEALTH_URL", "http://submodelregistry-go:8083/health")
DISCOVERY_HEALTH_URL = os.getenv("DISCOVERY_HEALTH_URL", "http://aasdiscovery-go:8081/health")

TARGETS = [
    {
        "name": "concept-descriptions",
        "dir": "concept-descriptions",
        "base_url": os.getenv("CONCEPT_DESCRIPTION_REPO_URL", "http://conceptdescriptionrepository-go:8080"),
        "resource": "concept-descriptions",
        "health_url": os.getenv("CONCEPT_DESCRIPTION_REPO_HEALTH_URL", "http://conceptdescriptionrepository-go:8080/health"),
    },
    {
        "name": "submodels",
        "dir": "submodels",
        "base_url": os.getenv("SUBMODEL_REPO_URL", "http://submodelrepository-go:8080"),
        "resource": "submodels",
        "health_url": os.getenv("SUBMODEL_REPO_HEALTH_URL", "http://submodelrepository-go:8080/health"),
    },
    {
        "name": "shells",
        "dir": "shells",
        "base_url": os.getenv("AAS_REPO_URL", "http://aasrepository-go:8080"),
        "resource": "shells",
        "health_url": os.getenv("AAS_REPO_HEALTH_URL", "http://aasrepository-go:8080/health"),
    },
]


def log(message: str) -> None:
    print(f"[aas-seed-import] {message}")


def wait_for_health(name: str, url: str) -> None:
    deadline = time.time() + MAX_WAIT_SECONDS
    while time.time() < deadline:
        try:
            with urllib.request.urlopen(url, timeout=5) as response:
                if 200 <= response.status < 300:
                    log(f"{name} is healthy: {url}")
                    return
        except Exception:
            pass
        time.sleep(POLL_SECONDS)
    raise RuntimeError(f"Timeout waiting for {name} health endpoint: {url}")


def encode_identifier(identifier: str) -> str:
    # Go repositories expect path IDs encoded as base64url.
    return base64.urlsafe_b64encode(identifier.encode("utf-8")).decode("ascii").rstrip("=")


def resource_exists(url: str) -> bool:
    try:
        with urllib.request.urlopen(url, timeout=15) as response:
            return 200 <= response.status < 300
    except urllib.error.HTTPError as error:
        if error.code == 404:
            return False
        raise RuntimeError(f"Unexpected HTTP {error.code} while checking {url}") from error


def put_json(url: str, payload: bytes) -> tuple[int, str]:
    request = urllib.request.Request(url=url, data=payload, method="PUT")
    request.add_header("Content-Type", "application/json")
    try:
        with urllib.request.urlopen(request, timeout=15) as response:
            return response.status, ""
    except urllib.error.HTTPError as error:
        body = error.read().decode("utf-8", errors="replace")
        return error.code, body


def post_json(url: str, payload: bytes) -> tuple[int, str]:
    request = urllib.request.Request(url=url, data=payload, method="POST")
    request.add_header("Content-Type", "application/json")
    try:
        with urllib.request.urlopen(request, timeout=15) as response:
            return response.status, ""
    except urllib.error.HTTPError as error:
        body = error.read().decode("utf-8", errors="replace")
        return error.code, body


def import_directory(target: dict) -> tuple[int, list[dict]]:
    directory = IMPORT_PATH / target["dir"]
    if not directory.exists():
        log(f"Skip {target['name']}: directory does not exist ({directory})")
        return 0, []

    errors = 0
    imported_documents: list[dict] = []
    json_files = sorted(directory.glob("*.json"))
    unsupported = sorted([*directory.glob("*.xml"), *directory.glob("*.aasx")])

    for file_path in unsupported:
        log(f"Skipping unsupported file format: {file_path.name} (only JSON is imported in split Go setup)")

    if not json_files:
        log(f"No JSON files found in {directory}")
        return 0, []

    for file_path in json_files:
        try:
            with file_path.open("r", encoding="utf-8") as handle:
                document = json.load(handle)
        except Exception as exc:
            log(f"ERROR parsing {file_path.name}: {exc}")
            errors += 1
            continue

        identifier = document.get("id")
        if not isinstance(identifier, str) or not identifier:
            log(f"ERROR in {file_path.name}: missing non-empty 'id' field")
            errors += 1
            continue

        encoded_id = encode_identifier(identifier)
        endpoint = f"{target['base_url'].rstrip('/')}/{target['resource']}/{encoded_id}"

        if not FORCE_IMPORT and resource_exists(endpoint):
            log(f"Skip {target['name']}: {file_path.name} already exists ({identifier})")
            continue

        payload = json.dumps(document, separators=(",", ":")).encode("utf-8")

        status, body = put_json(endpoint, payload)
        if status in (200, 201, 204, 409):
            log(f"Imported {target['name']}: {file_path.name} (HTTP {status})")
            imported_documents.append(document)
            continue

        log(f"ERROR importing {file_path.name} -> HTTP {status}: {body}")
        errors += 1

    return errors, imported_documents


def submodel_endpoint(submodel_id: str) -> str:
    encoded = encode_identifier(submodel_id)
    return f"{TARGETS[1]['base_url'].rstrip('/')}/submodels/{encoded}"


def shell_endpoint(shell_id: str) -> str:
    encoded = encode_identifier(shell_id)
    return f"{TARGETS[2]['base_url'].rstrip('/')}/shells/{encoded}"


def build_submodel_descriptor(submodel: dict) -> dict:
    descriptor: dict = {
        "id": submodel["id"],
        "endpoints": [
            {
                "interface": "SUBMODEL-3.0",
                "protocolInformation": {
                    "href": submodel_endpoint(submodel["id"]),
                    "endpointProtocol": "http",
                },
            }
        ],
    }

    for field in ("idShort", "semanticId", "displayName", "description", "administration"):
        if field in submodel:
            descriptor[field] = submodel[field]
    return descriptor


def extract_referenced_submodel_ids(shell: dict) -> list[str]:
    result: list[str] = []
    for ref in shell.get("submodels", []):
        keys = ref.get("keys") if isinstance(ref, dict) else None
        if not isinstance(keys, list) or not keys:
            continue
        last_key = keys[-1]
        if isinstance(last_key, dict):
            value = last_key.get("value")
            if isinstance(value, str) and value:
                result.append(value)
    return result


def build_shell_descriptor(shell: dict, submodels_by_id: dict[str, dict]) -> dict:
    asset_info = shell.get("assetInformation", {}) if isinstance(shell.get("assetInformation"), dict) else {}
    descriptor: dict = {
        "id": shell["id"],
        "endpoints": [
            {
                "interface": "AAS-3.0",
                "protocolInformation": {
                    "href": shell_endpoint(shell["id"]),
                    "endpointProtocol": "http",
                },
            }
        ],
        "submodelDescriptors": [],
    }

    if isinstance(shell.get("idShort"), str):
        descriptor["idShort"] = shell["idShort"]
    if isinstance(asset_info.get("assetKind"), str):
        descriptor["assetKind"] = asset_info["assetKind"]
    if isinstance(asset_info.get("assetType"), str):
        descriptor["assetType"] = asset_info["assetType"]
    if isinstance(asset_info.get("globalAssetId"), str):
        descriptor["globalAssetId"] = asset_info["globalAssetId"]

    for submodel_id in extract_referenced_submodel_ids(shell):
        submodel = submodels_by_id.get(submodel_id)
        if submodel:
            descriptor["submodelDescriptors"].append(build_submodel_descriptor(submodel))
        else:
            descriptor["submodelDescriptors"].append(
                {
                    "id": submodel_id,
                    "endpoints": [
                        {
                            "interface": "SUBMODEL-3.0",
                            "protocolInformation": {
                                "href": submodel_endpoint(submodel_id),
                                "endpointProtocol": "http",
                            },
                        }
                    ],
                }
            )

    return descriptor


def build_discovery_links(shell: dict) -> list[dict]:
    links: list[dict] = []
    asset_info = shell.get("assetInformation", {}) if isinstance(shell.get("assetInformation"), dict) else {}

    global_asset_id = asset_info.get("globalAssetId")
    if isinstance(global_asset_id, str) and global_asset_id:
        links.append({"name": "globalAssetId", "value": global_asset_id})

    specific_asset_ids = asset_info.get("specificAssetIds")
    if isinstance(specific_asset_ids, list):
        for item in specific_asset_ids:
            if not isinstance(item, dict):
                continue
            name = item.get("name")
            value = item.get("value")
            if isinstance(name, str) and name and isinstance(value, str) and value:
                links.append({"name": name, "value": value})

    # Deduplicate while preserving order.
    unique: list[dict] = []
    seen: set[tuple[str, str]] = set()
    for link in links:
        key = (link["name"], link["value"])
        if key in seen:
            continue
        seen.add(key)
        unique.append(link)

    return unique


def sync_registry_and_discovery(submodels: list[dict], shells: list[dict]) -> int:
    errors = 0
    submodels_by_id = {
        doc["id"]: doc for doc in submodels if isinstance(doc.get("id"), str) and doc.get("id")
    }

    for submodel in submodels_by_id.values():
        encoded = encode_identifier(submodel["id"])
        endpoint = f"{SUBMODEL_REGISTRY_URL.rstrip('/')}/submodel-descriptors/{encoded}"
        payload = json.dumps(build_submodel_descriptor(submodel), separators=(",", ":")).encode("utf-8")
        status, body = put_json(endpoint, payload)
        if status in (200, 201, 204, 409):
            log(f"Registered submodel descriptor: {submodel['id']} (HTTP {status})")
        else:
            log(f"ERROR registering submodel descriptor {submodel['id']} -> HTTP {status}: {body}")
            errors += 1

    for shell in shells:
        shell_id = shell.get("id")
        if not isinstance(shell_id, str) or not shell_id:
            continue

        encoded = encode_identifier(shell_id)
        endpoint = f"{AAS_REGISTRY_URL.rstrip('/')}/shell-descriptors/{encoded}"
        payload = json.dumps(build_shell_descriptor(shell, submodels_by_id), separators=(",", ":")).encode("utf-8")
        status, body = put_json(endpoint, payload)
        if status in (200, 201, 204, 409):
            log(f"Registered shell descriptor: {shell_id} (HTTP {status})")
        else:
            log(f"ERROR registering shell descriptor {shell_id} -> HTTP {status}: {body}")
            errors += 1
            continue

        links = build_discovery_links(shell)
        if not links:
            continue

        discovery_endpoint = f"{DISCOVERY_URL.rstrip('/')}/lookup/shells/{encoded}"
        discovery_payload = json.dumps(links, separators=(",", ":")).encode("utf-8")
        d_status, d_body = post_json(discovery_endpoint, discovery_payload)
        if d_status in (200, 201, 204, 409):
            log(f"Registered discovery links: {shell_id} (HTTP {d_status})")
        else:
            log(f"ERROR registering discovery links for {shell_id} -> HTTP {d_status}: {d_body}")
            errors += 1

    return errors


def main() -> int:
    log(f"Import root: {IMPORT_PATH}")
    log("Mode: force (overwrite existing documents)" if FORCE_IMPORT else "Mode: import missing documents only")
    total_errors = 0
    imported_docs: dict[str, list[dict]] = {}

    for target in TARGETS:
        wait_for_health(target["name"], target["health_url"])

    wait_for_health("aas-registry", AAS_REGISTRY_HEALTH_URL)
    wait_for_health("submodel-registry", SUBMODEL_REGISTRY_HEALTH_URL)
    wait_for_health("aas-discovery", DISCOVERY_HEALTH_URL)

    for target in TARGETS:
        errors, docs = import_directory(target)
        total_errors += errors
        imported_docs[target["name"]] = docs

    total_errors += sync_registry_and_discovery(
        imported_docs.get("submodels", []),
        imported_docs.get("shells", []),
    )

    if total_errors:
        log(f"Finished with {total_errors} error(s)")
        return 1

    log("Finished successfully")
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception as exc:
        log(f"Fatal error: {exc}")
        sys.exit(1)
