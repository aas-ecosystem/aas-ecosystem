# AAS Seed Import (Split Go Setup)

Only `raw-xml/` is committed to the repo. The `aas-seed-import` one-shot container
generates the JSON payloads at stack startup and imports them into the split
BaSyx Go repositories:

- concept descriptions -> `conceptdescriptionrepository-go`
- submodels -> `submodelrepository-go`
- shells -> `aasrepository-go`

`concept-descriptions/`, `submodels/`, and `shells/` only hold a `.gitkeep`
placeholder; the JSON files are generated in the container and never written
back to the repo.

Startup sequence inside the container:

1. `pip install basyx-python-sdk`
2. `30-convert-xml-aas-seeds.py` converts `raw-xml/` into JSON under a
   container-local `/generated` directory.
3. `20-import-aas-assets.py` imports that JSON into the repositories and
   registers the corresponding registry/discovery entries.

Notes:

- HTTP 409 (already exists) is treated as success for idempotent restarts.
- To add new seed data, drop AAS XML files into `raw-xml/` and restart the
  `aas-seed-import` service; no JSON needs to be committed.

## Re-run Import Against a Running Stack

```bash
docker compose up -d aas-seed-import
docker compose logs --since 2m aas-seed-import | tail -n 40
```

Expected result: importer ends with `Finished successfully`.
