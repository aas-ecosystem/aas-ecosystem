#!/usr/bin/env python3
"""Convert TwinEngine AAS XML examples into split-repository JSON payloads."""

from __future__ import annotations

import hashlib
import json
import os
import re
from pathlib import Path

from basyx.aas import model
from basyx.aas.adapter import xml
from basyx.aas.adapter.json.json_serialization import AASToJsonEncoder

ROOT = Path(__file__).resolve().parents[1]
IMPORT_ROOT = ROOT / "stack-assets" / "aas-import"

# Overridable so the bootstrap container can point at its own mount/output paths
# instead of the repo checkout layout used for local manual runs.
RAW_XML_DIR = Path(os.getenv("RAW_XML_DIR", str(IMPORT_ROOT / "raw-xml")))
OUTPUT_ROOT = Path(os.getenv("OUTPUT_DIR", str(IMPORT_ROOT)))
OUT_CD_DIR = OUTPUT_ROOT / "concept-descriptions"
OUT_SM_DIR = OUTPUT_ROOT / "submodels"
OUT_AAS_DIR = OUTPUT_ROOT / "shells"


def slug(value: str) -> str:
    clean = re.sub(r"[^a-zA-Z0-9]+", "-", value).strip("-").lower()
    return clean or "item"


def stable_name(prefix: str, identifier: str, id_short: str | None) -> str:
    short = slug(id_short or "")
    digest = hashlib.sha1(identifier.encode("utf-8")).hexdigest()[:10]
    if short:
        return f"{prefix}-{short}-{digest}.json"
    return f"{prefix}-{digest}.json"


def to_json_document(obj: model.Identifiable) -> dict:
    payload = json.dumps(obj, cls=AASToJsonEncoder)
    return json.loads(payload)


def write_object(obj: model.Identifiable) -> Path:
    data = to_json_document(obj)
    obj_id = data.get("id")
    if not isinstance(obj_id, str) or not obj_id:
        raise ValueError(f"Missing id for object type {type(obj).__name__}")

    if isinstance(obj, model.ConceptDescription):
        out_dir = OUT_CD_DIR
        prefix = "cd"
    elif isinstance(obj, model.Submodel):
        out_dir = OUT_SM_DIR
        prefix = "sm"
    elif isinstance(obj, model.AssetAdministrationShell):
        out_dir = OUT_AAS_DIR
        prefix = "aas"
    else:
        raise TypeError(f"Unsupported identifiable type: {type(obj).__name__}")

    out_dir.mkdir(parents=True, exist_ok=True)
    file_name = stable_name(prefix, obj_id, data.get("idShort"))
    out_path = out_dir / file_name
    out_path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    return out_path


def clean_output_dirs() -> None:
    for directory in (OUT_CD_DIR, OUT_SM_DIR, OUT_AAS_DIR):
        directory.mkdir(parents=True, exist_ok=True)
        for path in directory.glob("*.json"):
            path.unlink()


def main() -> int:
    xml_files = sorted(RAW_XML_DIR.glob("*.xml"))
    if not xml_files:
        raise FileNotFoundError(f"No XML files found in {RAW_XML_DIR}")

    clean_output_dirs()

    total = 0
    for xml_file in xml_files:
        store = xml.read_aas_xml_file(xml_file)
        for obj in store:
            if isinstance(obj, (model.ConceptDescription, model.Submodel, model.AssetAdministrationShell)):
                write_object(obj)
                total += 1

    print(f"Converted {len(xml_files)} XML file(s) into {total} JSON object file(s).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
