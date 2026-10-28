#!/usr/bin/env bash
set -euo pipefail

DB="${TWINENGINE_POSTGRES_DB:-twinengine}"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DB" \
  -f /docker-entrypoint-initdb.d/twinengine-schema.sql

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DB" \
  -f /docker-entrypoint-initdb.d/twinengine-seed.sql
