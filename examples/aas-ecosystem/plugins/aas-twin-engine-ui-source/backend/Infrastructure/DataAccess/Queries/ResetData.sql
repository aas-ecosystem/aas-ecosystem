-- ============================================================
-- Reset demo data: truncate all DPP tables and re-insert the seed data.
-- Seed sections are copied verbatim from postgres-init/seed/*.sql.inc;
-- keep them in sync when the seed data changes.
-- RESTART IDENTITY is required because the seed relies on identity values starting at 1.
-- ============================================================

TRUNCATE TABLE
    "Asset",
    "SpecificAssetIds",
    "TechnicalPropertyArea",
    "Marking",
    "AssetMarking",
    "ProductImage",
    "AssetProductImage",
    "ProductClassifications",
    "AssetProductClassifications",
    "ProductOrSectorSpecificCarbonFootprint",
    "MaintenanceInstructionsForSpecificInterval",
    "AssetMaintenanceInstruction",
    "Alarm",
    "MaintenanceInstructionAlarm",
    "ContactForMaintenanceAuthorization",
    "Email",
    "Phone",
    "Fax",
    "MaintenanceInstructionContactForMaintenanceAuthorization",
    "MaintenanceStep",
    "MaintenanceInstructionsForSpecificIntervalMaintenanceStep",
    "MaintenanceTool",
    "AssetMaintenanceTool",
    "MaintenanceConsumable",
    "AssetMaintenanceConsumable",
    "MaintenanceSparePart",
    "AssetMaintenanceSparePart",
    "Document",
    "DocumentId",
    "AssetDocument",
    "DocumentDocumentId",
    "DocumentClassification",
    "DocumentDocumentClassification",
    "DocumentVersion",
    "Languages",
    "DocumentVersionLanguages",
    "DocumentDocumentVersion"
RESTART IDENTITY CASCADE;

-- ---------- seed/01_vehicle_assets.sql.inc ----------
-- Demo assets: three laser-cut wooden model cars of the fictional "Demo Company GmbH".
-- Images: https://files.aas-demo.dev/car1.jpeg … car3.jpeg (photos of the physical models).
-- Addresses: Car1/Car3 at Meta-Level Software AG (Saarbrücken), Car2 at M&M Software (St. Georgen).
-- Dimensions are rounded approximate values; serial numbers, dates and CO2 values are synthetic.
INSERT INTO "Asset" (
    "ProductId","IdShort","GlobalAssetId","AasId","AssetKind","AssetType",
    "ThumbnailContentType","ThumbnailPath","MaintenanceFreeAsset",
    "UriOfTheProduct","ManufacturerProductType","OrderCodeOfManufacturer","ProductArticleNumberOfManufacturer",
    "SerialNumber","YearOfConstruction","DateOfManufacture","HardwareVersion","FirmwareVersion","SoftwareVersion",
    "CountryOfOrigin","UniqueFacilityIdentifier",
    "AddressInformationStreet_en","AddressInformationStreet_de","AddressInformationZipcode_en",
    "AddressInformationZipcode_de","AddressInformationCityTown_en","AddressInformationCityTown_de",
    "AddressInformationNationalCode_en","AddressInformationNationalCode_de","ManufacturerName","ManufacturerProductDesignation_en",
    "ManufacturerProductDesignation_de","ManufacturerProductRoot_en","ManufacturerProductRoot_de",
    "ManufacturerProductFamily_en","ManufacturerProductFamily_de","CompanyLogo","ManufacturerArticleNumber",
    "ManufacturerOrderCode","ProductImage","ManufacturerLogo","TextStatement_en","TextStatement_de",
    "ValidDate","PcfCalculationMethod","LifeCyclePhase","PcfCO2eq","ReferenceImpactUnitForCalculation",
    "QuantityOfMeasureForCalculation","PublicationDate","ExpirationDate","ExplanatoryStatement"
) VALUES
(
    '000-001','Car1','https://mm-software.com/ids/assets/000-001','https://mm-software.com/ids/aas/000-001',
    'Instance','WoodenModelCar','image/jpeg',
    'https://files.aas-demo.dev/car1.jpeg',
    FALSE,'https://example.com/products/dc-sw-01','DC-SW-01',
    'DC-SW-01','DC-SW-01','DC-SW-2026-0001',2026,'2026-11-02',
    'Rev. A','n/a','n/a','DE','DC-SAARBRUECKEN-01',
    'Lyonerring 1','Lyonerring 1','66121','66121','Saarbrücken','Saarbrücken','DE','DE',
    'Demo Company GmbH','Wooden sports car (Car 1)','Holz-Sportwagen (Car 1)',
    'Wooden model car','Holzmodell-Auto','Demo model cars','Demo-Modellautos',
    'https://files.aas-demo.dev/demo-company-logo.png','DC-SW-01',
    'DC-SW-01',
    'https://files.aas-demo.dev/car1.jpeg',
    'https://files.aas-demo.dev/demo-company-logo.png',
    'Illustrative demonstration record for a laser-cut wooden model car. Dimensions are approximate; serial numbers and carbon-footprint values are synthetic.',
    'Beispieldatensatz für ein lasergeschnittenes Holzmodell-Auto. Maße sind Circa-Werte; Seriennummern und CO2-Werte sind synthetisch.',
    '2027-11-02','ISO 14067 (illustrative estimate)','Cradle-to-gate (A1-A3)',0.35,'piece',1,
    '2026-11-14T00:00:00Z','2034-11-14T00:00:00Z',
    'Illustrative manufacturing footprint estimate for one laser-cut wooden model car; not a verified declaration.'
),
(
    '000-002','Car2','https://mm-software.com/ids/assets/000-002','https://mm-software.com/ids/aas/000-002',
    'Instance','WoodenModelCar','image/jpeg',
    'https://files.aas-demo.dev/car2.jpeg',
    FALSE,'https://example.com/products/dc-gw-02','DC-GW-02',
    'DC-GW-02','DC-GW-02','DC-GW-2026-0002',2026,'2026-11-03',
    'Rev. A','n/a','n/a','DE','DC-STGEORGEN-01',
    'Industriestrasse 5','Industriestraße 5','78112','78112','St. Georgen','St. Georgen','DE','DE',
    'Demo Company GmbH','Wooden off-road vehicle (Car 2)','Holz-Geländewagen (Car 2)',
    'Wooden model car','Holzmodell-Auto','Demo model cars','Demo-Modellautos',
    'https://files.aas-demo.dev/demo-company-logo.png','DC-GW-02',
    'DC-GW-02',
    'https://files.aas-demo.dev/car2.jpeg',
    'https://files.aas-demo.dev/demo-company-logo.png',
    'Illustrative demonstration record for a laser-cut wooden model car. Dimensions are approximate; serial numbers and carbon-footprint values are synthetic.',
    'Beispieldatensatz für ein lasergeschnittenes Holzmodell-Auto. Maße sind Circa-Werte; Seriennummern und CO2-Werte sind synthetisch.',
    '2027-11-03','ISO 14067 (illustrative estimate)','Cradle-to-gate (A1-A3)',0.40,'piece',1,
    '2026-11-14T00:00:00Z','2034-11-14T00:00:00Z',
    'Illustrative manufacturing footprint estimate for one laser-cut wooden model car; not a verified declaration.'
),
(
    '000-003','Car3','https://mm-software.com/ids/assets/000-003','https://mm-software.com/ids/aas/000-003',
    'Instance','WoodenModelCar','image/jpeg',
    'https://files.aas-demo.dev/car3.jpeg',
    FALSE,'https://example.com/products/dc-pu-03','DC-PU-03',
    'DC-PU-03','DC-PU-03','DC-PU-2026-0003',2026,'2026-11-04',
    'Rev. A','n/a','n/a','DE','DC-SAARBRUECKEN-01',
    'Lyonerring 1','Lyonerring 1','66121','66121','Saarbrücken','Saarbrücken','DE','DE',
    'Demo Company GmbH','Wooden pickup truck (Car 3)','Holz-Pickup (Car 3)',
    'Wooden model car','Holzmodell-Auto','Demo model cars','Demo-Modellautos',
    'https://files.aas-demo.dev/demo-company-logo.png','DC-PU-03',
    'DC-PU-03',
    'https://files.aas-demo.dev/car3.jpeg',
    'https://files.aas-demo.dev/demo-company-logo.png',
    'Illustrative demonstration record for a laser-cut wooden model car. Dimensions are approximate; serial numbers and carbon-footprint values are synthetic.',
    'Beispieldatensatz für ein lasergeschnittenes Holzmodell-Auto. Maße sind Circa-Werte; Seriennummern und CO2-Werte sind synthetisch.',
    '2027-11-04','ISO 14067 (illustrative estimate)','Cradle-to-gate (A1-A3)',0.45,'piece',1,
    '2026-11-14T00:00:00Z','2034-11-14T00:00:00Z',
    'Illustrative manufacturing footprint estimate for one laser-cut wooden model car; not a verified declaration.'
);

-- Standard keys (IDTA naming) so discovery by serial number / part number works.
INSERT INTO "SpecificAssetIds" ("ProductId","Name","Value") VALUES
('000-001','serialNumber','DC-SW-2026-0001'),
('000-001','manufacturerPartId','DC-SW-01'),
('000-002','serialNumber','DC-GW-2026-0002'),
('000-002','manufacturerPartId','DC-GW-02'),
('000-003','serialNumber','DC-PU-2026-0003'),
('000-003','manufacturerPartId','DC-PU-03');

-- ---------- seed/02_vehicle_technical_data.sql.inc ----------
-- Approximate outer dimensions of the wooden models in mm (length, width, height).
INSERT INTO "TechnicalPropertyArea" ("AssetId","Index","Length","Width","Height")
SELECT asset."Id", 0, dimensions."Length", dimensions."Width", dimensions."Height"
FROM "Asset" AS asset
JOIN (VALUES
    ('000-001',190::NUMERIC,85::NUMERIC,80::NUMERIC),
    ('000-002',160::NUMERIC,80::NUMERIC,100::NUMERIC),
    ('000-003',220::NUMERIC,85::NUMERIC,90::NUMERIC)
) AS dimensions("ProductId","Length","Width","Height")
    ON dimensions."ProductId" = asset."ProductId";

-- CE demo marking with an image file (the Designer shows MarkingFile as logo).
-- DesignationOfCertificateOrApproval is unique per asset and used as join key below.
INSERT INTO "Marking"
("Index","MarkingName","DesignationOfCertificateOrApproval","IssueDate","ExpiryDate","MarkingAdditionalText","MarkingFile")
VALUES
(0,'CE','DEMO-CE-000-001','2026-11-02','2036-11-02',
 'Demo marking for an exhibition model; no EU declaration of conformity.','https://files.aas-demo.dev/ce-mark.png'),
(0,'CE','DEMO-CE-000-002','2026-11-03','2036-11-03',
 'Demo marking for an exhibition model; no EU declaration of conformity.','https://files.aas-demo.dev/ce-mark.png'),
(0,'CE','DEMO-CE-000-003','2026-11-04','2036-11-04',
 'Demo marking for an exhibition model; no EU declaration of conformity.','https://files.aas-demo.dev/ce-mark.png');

INSERT INTO "AssetMarking" ("AssetId","MarkingId")
SELECT asset."Id", marking."Id"
FROM "Asset" AS asset
JOIN "Marking" AS marking
    ON marking."DesignationOfCertificateOrApproval" = 'DEMO-CE-' || asset."ProductId"
WHERE asset."ProductId" IN ('000-001','000-002','000-003');

INSERT INTO "ProductImage" ("Id","Index","ImageFile","ImageNote_en","ImageNote_de") VALUES
(1,0,'https://files.aas-demo.dev/car1.jpeg','Wooden sports car (Car 1) with gull-wing doors and rear spoiler.','Holz-Sportwagen (Car 1) mit Flügeltüren und Heckspoiler.'),
(2,0,'https://files.aas-demo.dev/car2.jpeg','Wooden off-road vehicle (Car 2) with roof rack and bull bar.','Holz-Geländewagen (Car 2) mit Dachträger und Frontschutzbügel.'),
(3,0,'https://files.aas-demo.dev/car3.jpeg','Wooden pickup truck (Car 3) with crew cab and open cargo bed.','Holz-Pickup (Car 3) mit Doppelkabine und offener Ladefläche.');

INSERT INTO "AssetProductImage" ("Id","AssetId","ProductImageId")
SELECT relation."ImageId", asset."Id", relation."ImageId"
FROM (VALUES ('000-001',1),('000-002',2),('000-003',3)) AS relation("ProductId","ImageId")
JOIN "Asset" AS asset ON asset."ProductId" = relation."ProductId";

-- Harmonized System heading 9503: toys; reduced-size ("scale") models and similar recreational models.
INSERT INTO "ProductClassifications" (
    "Index","ClassificationSystem","ClassificationSystemVersion","ClassificationSystemUrl",
    "ProductClassId","ProductClassCodedName","ProductClassName_en","ProductClassName_de"
) VALUES
(0,'HS','2022','https://www.wcoomd.org','950300','CAR-1-WOODEN-MODEL',
 'Toys; reduced-size (scale) models - wooden model car','Spielzeug; Modelle in verkleinertem Maßstab - Holzmodell-Auto'),
(0,'HS','2022','https://www.wcoomd.org','950300','CAR-2-WOODEN-MODEL',
 'Toys; reduced-size (scale) models - wooden model car','Spielzeug; Modelle in verkleinertem Maßstab - Holzmodell-Auto'),
(0,'HS','2022','https://www.wcoomd.org','950300','CAR-3-WOODEN-MODEL',
 'Toys; reduced-size (scale) models - wooden model car','Spielzeug; Modelle in verkleinertem Maßstab - Holzmodell-Auto');

INSERT INTO "AssetProductClassifications" ("AssetId","ProductClassificationsId")
SELECT asset."Id", classification."Id"
FROM (VALUES
    ('000-001','CAR-1-WOODEN-MODEL'),
    ('000-002','CAR-2-WOODEN-MODEL'),
    ('000-003','CAR-3-WOODEN-MODEL')
) AS relation("ProductId","ProductClassCodedName")
JOIN "Asset" AS asset ON asset."ProductId" = relation."ProductId"
JOIN "ProductClassifications" AS classification
    ON classification."ProductClassCodedName" = relation."ProductClassCodedName";

INSERT INTO "ProductOrSectorSpecificCarbonFootprint" (
    "AssetId","PcfCalculationMethod","PcfRuleOperator","PcfRuleName","PcfRuleVersion",
    "PcfRuleOnlineReference","PcfApiEndpoint","PcfApiQuery"
)
SELECT asset."Id",'ISO 14067 (illustrative estimate)','GHG Protocol Product Standard',
       asset."ManufacturerProductDesignation_en" || ' manufacturing footprint estimate','Demo 1.0',
       'https://ghgprotocol.org/product-standard',
       'https://example.com/carbon-footprints/' || asset."ProductId",
       '?productId=' || asset."ProductId" || '&scope=cradle-to-gate&unit=kgCO2e&status=illustrative'
FROM "Asset" AS asset
WHERE asset."ProductId" IN ('000-001','000-002','000-003');

-- ---------- seed/03_vehicle_maintenance.sql.inc ----------
-- Maintenance for the wooden model cars: check plug-in joints (every 6 months)
-- and wheels/axles (every 12 months). Flow chart = care and maintenance PDF per car.
INSERT INTO "MaintenanceInstructionsForSpecificInterval" (
    "Index","MaintenanceID","NameOfMaintenance_en","NameOfMaintenance_de",
    "SourceOfMaintenanceInstructions_en","SourceOfMaintenanceInstructions_de",
    "RelatedStandardsLawsRegulations_en","RelatedStandardsLawsRegulations_de",
    "SafetyRegulationsToBeObserved_en","SafetyRegulationsToBeObserved_de",
    "MaintenanceIntervalValue","MaintenanceIntervalUnit","FlowChartOfMaintenanceSteps",
    "NumberOfRequiredTechnicians","RequiredQualification_en","RequiredQualification_de",
    "ValueTotalEstimatedWorkingTime","UnitValueTotalEstimatedWorkingTime"
)
SELECT kind."Index", 'CAR-' || car."No" || '-' || kind."Code",
       'Car ' || car."No" || ' ' || kind."Name_en", 'Car ' || car."No" || ' ' || kind."Name_de",
       'Care and maintenance instructions DC-CAR' || car."No" || '-MT',
       'Pflege- und Wartungshinweise DC-CAR' || car."No" || '-MT',
       'Manufacturer recommendation (demo); no statutory requirement',
       'Herstellerempfehlung (Demo); keine gesetzliche Vorgabe',
       'Small parts: keep away from children under 3 years',
       'Kleine Teile: von Kindern unter 3 Jahren fernhalten',
       kind."Interval",'months','https://files.aas-demo.dev/car' || car."No" || '-pflege.pdf',
       1,'Instructed person','Unterwiesene Person',kind."Hours",'hour'
FROM (VALUES (1),(2),(3)) AS car("No")
CROSS JOIN (VALUES
    (0,'JOINTS','plug-in joint check','Prüfung der Steckverbindungen',6,0.25),
    (1,'WHEELS','wheel and axle check','Prüfung von Rädern und Achsen',12,0.25)
) AS kind("Index","Code","Name_en","Name_de","Interval","Hours");

INSERT INTO "AssetMaintenanceInstruction" ("AssetId","MaintenanceInstructionId")
SELECT asset."Id", instruction."Id"
FROM "Asset" AS asset
JOIN "MaintenanceInstructionsForSpecificInterval" AS instruction
    ON instruction."MaintenanceID" LIKE 'CAR-' || right(asset."ProductId", 1) || '-%'
WHERE asset."ProductId" IN ('000-001','000-002','000-003');

INSERT INTO "Alarm" ("Index","AlarmName_en","AlarmName_de","WarningLimitRelativeValue","WarningLimitSeverity")
SELECT 0, instruction."NameOfMaintenance_en" || ' due', instruction."NameOfMaintenance_de" || ' fällig', 100, 'Warning'
FROM "MaintenanceInstructionsForSpecificInterval" AS instruction
ORDER BY instruction."Id";

INSERT INTO "MaintenanceInstructionAlarm" ("MaintenanceInstructionId","AlarmId")
SELECT instruction."Id", alarm."Id"
FROM "MaintenanceInstructionsForSpecificInterval" AS instruction
JOIN "Alarm" AS alarm ON alarm."AlarmName_en" = instruction."NameOfMaintenance_en" || ' due';

-- Each instruction gets its own three step records, not shared step IDs.
INSERT INTO "MaintenanceStep" (
    "Index","MaintenanceStepID","QuantityOfSparePartForMaintenanceStep",
    "QuantityOfConsumablesForMaintenanceStep","UnitForQuantityOfConsumablesForMaintenanceStep",
    "QuantityOfToolsForMaintenanceStep","DocumentationSignatureMandatory","EndOfMaintenance",
    "MaintenanceStepName_en","MaintenanceStepName_de","LocalizationDescription_en","LocalizationDescription_de",
    "InstructionMaintenanceStep_en","InstructionMaintenanceStep_de","ConditionForNextMaintenanceStep_en",
    "ConditionForNextMaintenanceStep_de","ConditionForAlternativeNextStep_en","ConditionForAlternativeNextStep_de",
    "RelatedDocumentOrFileMaintenanceStep","ValueEstimatedDurationTimeMaintenanceStep",
    "UnitEstimatedDurationTimeMaintenanceStep"
)
SELECT step."Index", instruction."MaintenanceID" || '-STEP-' || step."Index",
       0,0,'piece',0,FALSE,step."EndOfMaintenance",
       instruction."NameOfMaintenance_en" || ' - ' || step."Name_en",
       instruction."NameOfMaintenance_de" || ' - ' || step."Name_de",
       'Whole model','Gesamtes Modell',
       CASE WHEN instruction."MaintenanceID" LIKE '%-JOINTS' THEN step."Joints_en" ELSE step."Wheels_en" END,
       CASE WHEN instruction."MaintenanceID" LIKE '%-JOINTS' THEN step."Joints_de" ELSE step."Wheels_de" END,
       'No damage found or damage resolved.','Keine Schäden festgestellt oder behoben.',
       'Replace damaged parts with spare parts.',
       'Beschädigte Teile durch Ersatzteile tauschen.',
       instruction."FlowChartOfMaintenanceSteps",step."Duration",'minutes'
FROM "MaintenanceInstructionsForSpecificInterval" AS instruction
CROSS JOIN (VALUES
    (0,FALSE,'Visual inspection','Sichtprüfung',
     'Check all plug-in joints for loose parts and cracks.','Alle Steckverbindungen auf lose Teile und Risse prüfen.',
     'Check wheels for cracks and free rotation.','Räder auf Risse und Leichtgängigkeit prüfen.',5),
    (1,FALSE,'Rework','Nacharbeit',
     'Re-seat loose parts; fix with a little wood glue if needed.','Lose Teile nachstecken, bei Bedarf mit wenig Holzleim fixieren.',
     'Re-seat axles; replace damaged wheels with the spare wheel set.','Achsen nachstecken, beschädigte Räder durch Ersatzrad-Satz tauschen.',
     7),
    (2,TRUE,'Clean and document','Reinigen und dokumentieren',
     'Remove dust with a soft brush and record the inspection date.','Staub mit weichem Pinsel entfernen, Prüfdatum notieren.',
     'Remove dust with a soft brush and record the inspection date.','Staub mit weichem Pinsel entfernen, Prüfdatum notieren.',3)
) AS step("Index","EndOfMaintenance","Name_en","Name_de","Joints_en","Joints_de","Wheels_en","Wheels_de","Duration");

INSERT INTO "MaintenanceInstructionsForSpecificIntervalMaintenanceStep"
("MaintenanceInstructionsForSpecificIntervalId","MaintenanceStepId")
SELECT instruction."Id", step."Id"
FROM "MaintenanceInstructionsForSpecificInterval" AS instruction
JOIN "MaintenanceStep" AS step
    ON step."MaintenanceStepID" = instruction."MaintenanceID" || '-STEP-' || step."Index";

-- Each instruction owns a fictional contact and separate communication records.
-- Phone/fax numbers use the reserved fictional range 555-01xx, e-mail addresses example.com.
INSERT INTO "ContactForMaintenanceAuthorization" (
    "Index","Company_en","Company_de","Department_en","Department_de",
    "Title_en","Title_de","AcademicTitle_en","AcademicTitle_de",
    "NameOfContact_en","NameOfContact_de","FirstName_en","FirstName_de",
    "MiddleNames_en","MiddleNames_de","Street_en","Street_de","Zipcode_en","Zipcode_de",
    "CityTown_en","CityTown_de","NationalCode_en","NationalCode_de","StateCounty_en","StateCounty_de",
    "FurtherDetailsOfContact_en","FurtherDetailsOfContact_de","RoleOfContactPerson"
)
SELECT 0,'Demo Company GmbH','Demo Company GmbH',
       'Model service','Modellservice',
       'Mx','Mx','Not applicable','Nicht zutreffend',
       contact."LastName",contact."LastName",contact."FirstName",contact."FirstName",
       'Not applicable','Nicht zutreffend',site."Street_en",site."Street_de",site."Zipcode",site."Zipcode",
       site."City",site."City",'DE','DE',site."State_en",site."State_de",
       'Fictional authorization contact for ' || instruction."MaintenanceID",
       'Fiktiver Freigabekontakt für ' || instruction."MaintenanceID",'Maintenance authorization'
FROM (VALUES
    ('CAR-1-JOINTS','Alex','Miller'),
    ('CAR-1-WHEELS','Sam','Taylor'),
    ('CAR-2-JOINTS','Robin','Clark'),
    ('CAR-2-WHEELS','Jamie','Morgan'),
    ('CAR-3-JOINTS','Kim','Becker'),
    ('CAR-3-WHEELS','Noa','Fischer')
) AS contact("MaintenanceID","FirstName","LastName")
JOIN (VALUES
    ('CAR-1','Lyonerring 1','Lyonerring 1','66121','Saarbrücken','Saarland','Saarland'),
    ('CAR-2','Industriestrasse 5','Industriestraße 5','78112','St. Georgen','Baden-Wuerttemberg','Baden-Württemberg'),
    ('CAR-3','Lyonerring 1','Lyonerring 1','66121','Saarbrücken','Saarland','Saarland')
) AS site("CarPrefix","Street_en","Street_de","Zipcode","City","State_en","State_de")
    ON contact."MaintenanceID" LIKE site."CarPrefix" || '-%'
JOIN "MaintenanceInstructionsForSpecificInterval" instruction
    ON instruction."MaintenanceID" = contact."MaintenanceID";

INSERT INTO "MaintenanceInstructionContactForMaintenanceAuthorization"
("MaintenanceInstructionId","ContactForMaintenanceAuthorizationId")
SELECT instruction."Id", contact."Id"
FROM "MaintenanceInstructionsForSpecificInterval" instruction
JOIN "ContactForMaintenanceAuthorization" contact
    ON contact."FurtherDetailsOfContact_en" = 'Fictional authorization contact for ' || instruction."MaintenanceID";

INSERT INTO "Email" (
    "ContactForMaintenanceAuthorizationId","EmailAddress","TypeOfEmailAddress",
    "PublicKey_en","PublicKey_de","TypeOfPublicKey_en","TypeOfPublicKey_de"
)
SELECT contact."Id",lower(instruction."MaintenanceID") || '@example.com','Business',
       'Not configured for demo','Für Demo nicht konfiguriert','Not applicable','Nicht zutreffend'
FROM "MaintenanceInstructionContactForMaintenanceAuthorization" relation
JOIN "ContactForMaintenanceAuthorization" contact ON contact."Id" = relation."ContactForMaintenanceAuthorizationId"
JOIN "MaintenanceInstructionsForSpecificInterval" instruction ON instruction."Id" = relation."MaintenanceInstructionId";

INSERT INTO "Phone" (
    "ContactForMaintenanceAuthorizationId","TelephoneNumber_en","TelephoneNumber_de",
    "AvailableTime_en","AvailableTime_de","TypeOfTelephone"
)
SELECT contact."Id",number."Value",number."Value",
       'Mon-Fri 09:00-17:00 (demo)','Mo-Fr 09:00-17:00 (Demo)','Business'
FROM "ContactForMaintenanceAuthorization" contact
JOIN (VALUES
    ('Miller','+1-202-555-0101'),('Taylor','+1-202-555-0102'),
    ('Clark','+1-202-555-0103'),('Morgan','+1-202-555-0104'),
    ('Becker','+1-202-555-0105'),('Fischer','+1-202-555-0106')
) AS number("LastName","Value") ON number."LastName" = contact."NameOfContact_en";

INSERT INTO "Fax" (
    "ContactForMaintenanceAuthorizationId","FaxNumber_en","FaxNumber_de","TypeOfFaxNumber"
)
SELECT contact."Id",number."Value",number."Value",'Business'
FROM "ContactForMaintenanceAuthorization" contact
JOIN (VALUES
    ('Miller','+1-202-555-0111'),('Taylor','+1-202-555-0112'),
    ('Clark','+1-202-555-0113'),('Morgan','+1-202-555-0114'),
    ('Becker','+1-202-555-0115'),('Fischer','+1-202-555-0116')
) AS number("LastName","Value") ON number."LastName" = contact."NameOfContact_en";

INSERT INTO "MaintenanceTool" (
    "Index","ToolID","OrderCodeToolOfManufacturer","AddressOfAdditionalLinkTool",
    "ToolName_en","ToolName_de","CompanyNameToolSupplier_en","CompanyNameToolSupplier_de",
    "ToolDescription_en","ToolDescription_de","MaxQuantityOfTool"
)
SELECT 0,'TOOL-' || asset."ProductId",'DC-TWEEZERS-01',
       'https://example.com/tools/' || asset."ProductId",
       'Fine tweezers','Feine Pinzette',
       'Demo Company GmbH','Demo Company GmbH',
       'For re-seating small plug-in parts of ' || asset."ManufacturerProductDesignation_en",
       'Zum Nachstecken kleiner Steckteile von ' || asset."ManufacturerProductDesignation_de",1
FROM "Asset" asset WHERE asset."ProductId" IN ('000-001','000-002','000-003');

INSERT INTO "AssetMaintenanceTool" ("AssetId","MaintenanceToolId")
SELECT asset."Id",tool."Id"
FROM "Asset" asset JOIN "MaintenanceTool" tool ON tool."ToolID" = 'TOOL-' || asset."ProductId";

INSERT INTO "MaintenanceConsumable" (
    "Index","ConsumableID","UnitMaxQuantityOfConsumable","OrderCodeConsumableOfManufacturer",
    "AddressOfAdditionalLinkConsumable","ConsumableName_en","ConsumableName_de",
    "CompanyNameSupplierConsumable_en","CompanyNameSupplierConsumable_de",
    "ConsumableDescription_en","ConsumableDescription_de",
    "DisposalInstructionsForConsumable_en","DisposalInstructionsForConsumable_de","QuantityOfConsumable"
)
SELECT 0,'CONSUMABLE-' || asset."ProductId",'millilitre','DC-WOODGLUE-20',
       'https://example.com/consumables/' || asset."ProductId",
       'Wood glue (PVA)','Holzleim (Weißleim)',
       'Demo Company GmbH','Demo Company GmbH',
       'Water-based wood glue for fixing loose plug-in joints; use sparingly.',
       'Wasserbasierter Holzleim zum Fixieren loser Steckverbindungen; sparsam verwenden.',
       'Dispose of dried residues with household waste.',
       'Getrocknete Reste über den Hausmüll entsorgen.',20
FROM "Asset" asset WHERE asset."ProductId" IN ('000-001','000-002','000-003');

INSERT INTO "AssetMaintenanceConsumable" ("AssetId","MaintenanceConsumableId")
SELECT asset."Id",consumable."Id"
FROM "Asset" asset
JOIN "MaintenanceConsumable" consumable ON consumable."ConsumableID" = 'CONSUMABLE-' || asset."ProductId";

INSERT INTO "MaintenanceSparePart" (
    "Index","SparePartID","OrderCodeSparePartOfManufacturer","AddressOfAdditionalLinkSparePart",
    "SparePartName_en","SparePartName_de","CompanyNameSupplierSparePart_en","CompanyNameSupplierSparePart_de",
    "SparePartDescription_en","SparePartDescription_de",
    "DisposalInstructionsForSparePart_en","DisposalInstructionsForSparePart_de","QuantityOfSparePart"
)
SELECT 0,'SPARE-' || asset."ProductId",asset."ManufacturerArticleNumber" || '-WHEELS',
       'https://example.com/spare-parts/' || asset."ProductId",
       'Spare wheel set (4 wheels)','Ersatzrad-Satz (4 Räder)',
       'Demo Company GmbH','Demo Company GmbH',
       'Laser-cut replacement wheels for ' || asset."ManufacturerProductDesignation_en",
       'Lasergeschnittene Ersatzräder für ' || asset."ManufacturerProductDesignation_de",
       'Dispose of untreated wood with residual waste or wood collection.',
       'Unbehandeltes Holz über Restmüll oder Holzsammlung entsorgen.',1
FROM "Asset" asset WHERE asset."ProductId" IN ('000-001','000-002','000-003');

INSERT INTO "AssetMaintenanceSparePart" ("AssetId","MaintenanceSparePartId")
SELECT asset."Id",part."Id"
FROM "Asset" asset JOIN "MaintenanceSparePart" part ON part."SparePartID" = 'SPARE-' || asset."ProductId";

-- ---------- seed/04_vehicle_documentation.sql.inc ----------
-- Two documents per car, classified according to VDI 2770:2020:
--   02-01 technical specification (data sheet), 03-04 inspection/maintenance (care instructions).
-- Files and preview images are hosted on files.aas-demo.dev; documents are German only.
-- Runs on empty tables, so generated IDs are 1..6 in insertion order (car 1 DS, car 1 MT, car 2 DS, …).
INSERT INTO "Document" ("Index") VALUES
(0),(1),(0),(1),(0),(1);

INSERT INTO "DocumentId" ("Index","DocumentDomainId","DocumentIdentifier","DocumentIsPrimary") VALUES
(0,'4bbdba12-9352-4fac-91ae-000000000001','DC-CAR1-DS',TRUE),
(0,'4bbdba12-9352-4fac-91ae-000000000002','DC-CAR1-MT',TRUE),
(0,'4bbdba12-9352-4fac-91ae-000000000003','DC-CAR2-DS',TRUE),
(0,'4bbdba12-9352-4fac-91ae-000000000004','DC-CAR2-MT',TRUE),
(0,'4bbdba12-9352-4fac-91ae-000000000005','DC-CAR3-DS',TRUE),
(0,'4bbdba12-9352-4fac-91ae-000000000006','DC-CAR3-MT',TRUE);

INSERT INTO "AssetDocument" ("AssetId","DocumentId")
SELECT asset."Id", relation."DocumentId"
FROM (VALUES
    ('000-001',1),('000-001',2),('000-002',3),('000-002',4),('000-003',5),('000-003',6)
) AS relation("ProductId","DocumentId")
JOIN "Asset" AS asset ON asset."ProductId" = relation."ProductId";

INSERT INTO "DocumentDocumentId" ("DocumentId","DocumentIdentifierId") VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),(6,6);

INSERT INTO "DocumentClassification" ("Index","ClassId","ClassificationSystem","ClassName_en","ClassName_de") VALUES
(0,'02-01','VDI2770:2020','Technical specification','Technische Spezifikation'),
(0,'03-04','VDI2770:2020','Inspection, maintenance, testing','Inspektion, Wartung, Prüfung'),
(0,'02-01','VDI2770:2020','Technical specification','Technische Spezifikation'),
(0,'03-04','VDI2770:2020','Inspection, maintenance, testing','Inspektion, Wartung, Prüfung'),
(0,'02-01','VDI2770:2020','Technical specification','Technische Spezifikation'),
(0,'03-04','VDI2770:2020','Inspection, maintenance, testing','Inspektion, Wartung, Prüfung');

INSERT INTO "DocumentDocumentClassification" ("DocumentId","DocumentClassificationId") VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),(6,6);

INSERT INTO "DocumentVersion" (
    "Index","DigitalFile","Version","StatusSetDate","StatusValue","OrganizationShortName",
    "OrganizationOfficialName","Title_en","Title_de","Subtitle_en","Subtitle_de","Description_en","Description_de",
    "KeyWords_en","KeyWords_de","PreviewFile"
)
SELECT 0,
       'https://files.aas-demo.dev/car' || car."No" || '-' || doc."File" || '.pdf',
       '1.0','2026-11-14','Released','Demo Company','Demo Company GmbH',
       doc."Title_en",doc."Title_de",
       car."Name_en" || ' (Car ' || car."No" || ')',car."Name_de" || ' (Car ' || car."No" || ')',
       doc."Desc_en",doc."Desc_de",doc."Keys_en",doc."Keys_de",
       'https://files.aas-demo.dev/car' || car."No" || '-' || doc."File" || '-preview.png'
FROM (VALUES
    (1,'Wooden sports car','Holz-Sportwagen'),
    (2,'Wooden off-road vehicle','Holz-Geländewagen'),
    (3,'Wooden pickup truck','Holz-Pickup')
) AS car("No","Name_en","Name_de")
CROSS JOIN (VALUES
    (0,'datenblatt','Technical data sheet','Technisches Datenblatt',
     'Dimensions, material and features of the wooden model.','Abmessungen, Material und Merkmale des Holzmodells.',
     'data sheet, dimensions, plywood','Datenblatt, Abmessungen, Sperrholz'),
    (1,'pflege','Care and maintenance instructions','Pflege- und Wartungshinweise',
     'Maintenance intervals, care and disposal.','Wartungsintervalle, Pflege und Entsorgung.',
     'maintenance, care, wooden model','Wartung, Pflege, Holzmodell')
) AS doc("Order","File","Title_en","Title_de","Desc_en","Desc_de","Keys_en","Keys_de")
ORDER BY car."No", doc."Order";

INSERT INTO "Languages" ("Index","Language") VALUES
(0,'de'),(0,'de'),(0,'de'),(0,'de'),(0,'de'),(0,'de');

INSERT INTO "DocumentVersionLanguages" ("DocumentVersionId","LanguageId") VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),(6,6);

INSERT INTO "DocumentDocumentVersion" ("DocumentId","DocumentVersionId") VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),(6,6);
