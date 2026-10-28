#!/usr/bin/env sh
set -eu

MAX_ATTEMPTS="${BOOTSTRAP_MAX_ATTEMPTS:-120}"
ATTEMPT_DELAY_SECONDS="${BOOTSTRAP_ATTEMPT_DELAY_SECONDS:-5}"
LOCAL_HOSTNAME="${LOCAL_HOSTNAME:-aas-ecosystem.local}"

attempt=1
while [ "$attempt" -le "$MAX_ATTEMPTS" ]; do
  if psql -v ON_ERROR_STOP=1 \
    -h "$PGHOST" \
    -p "$PGPORT" \
    -U "$PGUSER" \
    -d "$PGDATABASE" \
    -tAc "SELECT to_regclass('public.\"AasInfrastructureSettings\"') IS NOT NULL;" | grep -q "t"; then
    echo "AasInfrastructureSettings table is available."
    break
  fi

  echo "Waiting for AasInfrastructureSettings table (attempt $attempt/$MAX_ATTEMPTS)..."
  sleep "$ATTEMPT_DELAY_SECONDS"
  attempt=$((attempt + 1))
done

if [ "$attempt" -gt "$MAX_ATTEMPTS" ]; then
  echo "AasInfrastructureSettings table did not become available in time." >&2
  exit 1
fi

# The backend seeds the initial organisation admin and the template
# infrastructure after the migrations, so wait for both rows as well.
attempt=1
while [ "$attempt" -le "$MAX_ATTEMPTS" ]; do
  if psql -v ON_ERROR_STOP=1 \
    -h "$PGHOST" \
    -p "$PGPORT" \
    -U "$PGUSER" \
    -d "$PGDATABASE" \
    -tAc "SELECT EXISTS (SELECT 1 FROM public.\"AasInfrastructureSettings\") AND EXISTS (SELECT 1 FROM public.\"BenutzerOrganisations\" WHERE \"BenutzerRollen\" LIKE '%\"ORGA_ADMIN\"%');" | grep -q "t"; then
    echo "Initial organisation admin and template infrastructure are available."
    break
  fi

  echo "Waiting for initial organisation admin and template infrastructure (attempt $attempt/$MAX_ATTEMPTS)..."
  sleep "$ATTEMPT_DELAY_SECONDS"
  attempt=$((attempt + 1))
done

if [ "$attempt" -gt "$MAX_ATTEMPTS" ]; then
  echo "Initial organisation admin or template infrastructure did not become available in time." >&2
  exit 1
fi

psql -v ON_ERROR_STOP=1 \
  -h "$PGHOST" \
  -p "$PGPORT" \
  -U "$PGUSER" \
  -d "$PGDATABASE" \
  -f /scripts/bootstrap.sql

# Resolve the __LOCAL_HOSTNAME__ placeholder before seeding, so the same
# script file works for any local hostname.
SEED_FILE="/tmp/infrastructures.seed.sql"
sed "s/__LOCAL_HOSTNAME__/$LOCAL_HOSTNAME/g" /scripts/infrastructures.seed.sql > "$SEED_FILE"

psql -v ON_ERROR_STOP=1 \
  -h "$PGHOST" \
  -p "$PGPORT" \
  -U "$PGUSER" \
  -d "$PGDATABASE" \
  -f "$SEED_FILE"

echo "Infrastructure bootstrap completed."