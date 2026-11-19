-- ============================================================
-- DPP Plugin Database Initialization - Demo Data Seeding
-- ============================================================
-- This script inserts demo data only.
-- Products 000-001, 000-002 and 000-003 are three laser-cut wooden model cars
-- (sports car, off-road vehicle, pickup) of the fictional "Demo Company GmbH".
-- Each product owns separate related records: markings, images, classification,
-- carbon footprint, maintenance instructions with contacts, tools, consumables,
-- spare parts, and two VDI 2770 documents.
-- Dimensions are approximate; serial numbers, dates and CO2 values are synthetic.
-- Contact details and example.com links are fictional, not live services.
-- Files (images, logo, CE mark, PDFs, previews) are expected on https://files.aas-demo.dev/.
-- Initialization requires empty tables; this is not an existing-data migration.
-- If you do not want demo data, simply delete or rename this file.
-- ============================================================
-- Note: Runs after twinengine-schema.sql (see 20-twinengine-init.sh)

\echo 'Executing: seed/01_vehicle_assets.sql.inc - Seeding vehicle asset data...'
\i /docker-entrypoint-initdb.d/seed/01_vehicle_assets.sql.inc

\echo 'Executing: seed/02_vehicle_technical_data.sql.inc - Seeding vehicle technical data...'
\i /docker-entrypoint-initdb.d/seed/02_vehicle_technical_data.sql.inc

\echo 'Executing: seed/03_vehicle_maintenance.sql.inc - Seeding vehicle maintenance data...'
\i /docker-entrypoint-initdb.d/seed/03_vehicle_maintenance.sql.inc

\echo 'Executing: seed/04_vehicle_documentation.sql.inc - Seeding vehicle documentation...'
\i /docker-entrypoint-initdb.d/seed/04_vehicle_documentation.sql.inc

\echo 'Vehicle demo data seeding completed successfully!'
