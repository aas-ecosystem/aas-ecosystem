-- ============================================================
-- DPP Plugin Database Initialization - Dummy Data Seeding
-- ============================================================
-- This script inserts sample/demo data only.
-- All 37 application tables are populated with non-null demonstration data.
-- Products 000-001 and 000-002 own separate related records, including contacts,
-- communication details, tools, consumables, and spare parts.
-- Contact details and example.invalid links are fictional, not live services.
-- Initialization requires empty tables; this is not an existing-data migration.
-- Validate using: psql -v ON_ERROR_STOP=1 -d twinengine -f tests/vehicle_seed.sql
-- If you do not want dummy data, simply delete or rename this file.
-- ============================================================
-- Note: Runs after 01_init_tables.sql (alphabetical order)

\echo 'Executing: seed/01_vehicle_assets.sql.inc - Seeding vehicle asset data...'
\i /docker-entrypoint-initdb.d/seed/01_vehicle_assets.sql.inc

\echo 'Executing: seed/02_vehicle_technical_data.sql.inc - Seeding vehicle technical data...'
\i /docker-entrypoint-initdb.d/seed/02_vehicle_technical_data.sql.inc

\echo 'Executing: seed/03_vehicle_maintenance.sql.inc - Seeding vehicle maintenance data...'
\i /docker-entrypoint-initdb.d/seed/03_vehicle_maintenance.sql.inc

\echo 'Executing: seed/04_vehicle_documentation.sql.inc - Seeding vehicle documentation...'
\i /docker-entrypoint-initdb.d/seed/04_vehicle_documentation.sql.inc

\echo 'Vehicle demo data seeding completed successfully!'
