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
    '000-001','Car 1','https://mm-software.com/ids/assets/000-001','https://mm-software.com/ids/aas/000-001',
    'Instance','PetrolPassengerCar','image/jpeg',
    'https://files.aas-demo.dev/Car1.jpeg',
    FALSE,'https://example.invalid/products/000-001','Demo petrol car',
    'DEMO-CAR-1','DEMO-CAR-1','DEMO-CAR-1-0001',2020,'2020-04-18',
    'demo-1.0','demo-1.0','demo-1.0','DE','DEMO-FACILITY-01',
    '1 Demo Street','1 Demo Street','00000','00000','Demo Town','Demo Town','DE','DE',
    'Demo Manufacturer','Car 1','Car 1','Car 1','Car 1','Demo Cars','Demo Cars',
    NULL,'DEMO-CAR-1',
    'DEMO-CAR-1',
    'https://files.aas-demo.dev/Car1.jpeg',
    NULL,
    'Illustrative demonstration record. Vehicle specifications are representative; serial numbers and carbon-footprint values are synthetic.',
    'Beispieldatensatz. Die Fahrzeugdaten sind repräsentativ; Seriennummern und CO2-Fussabdruckwerte sind synthetisch.',
    '2027-04-18','ISO 14067 (illustrative estimate)','Cradle-to-gate (A1-A3)',6100,'kg CO2e',1,
    '2026-10-22T00:00:00Z','2034-10-22T00:00:00Z',
    'Illustrative manufacturing footprint estimate for one vehicle; not a verified manufacturer declaration.'
),
(
    '000-002','Car 2','https://mm-software.com/ids/assets/000-002','https://mm-software.com/ids/aas/000-002',
    'Instance','PetrolPassengerCar','image/jpeg',
    'https://files.aas-demo.dev/Car2.jpeg',
    FALSE,'https://example.invalid/products/000-002','Demo petrol car',
    'DEMO-CAR-2','DEMO-CAR-2','DEMO-CAR-2-0002',2020,'2020-06-12',
    'demo-1.0','demo-1.0','demo-1.0','DE','DEMO-FACILITY-02',
    '2 Demo Street','2 Demo Street','00000','00000','Demo Town','Demo Town','DE','DE',
    'Demo Manufacturer','Car 2','Car 2',
    'Car 2','Car 2','Demo Cars','Demo Cars',
    NULL,'DEMO-CAR-2',
    'DEMO-CAR-2',
    'https://files.aas-demo.dev/Car2.jpeg',
    NULL,
    'Illustrative demonstration record. Vehicle specifications are representative; serial numbers and carbon-footprint values are synthetic.',
    'Beispieldatensatz. Die Fahrzeugdaten sind repräsentativ; Seriennummern und CO2-Fussabdruckwerte sind synthetisch.',
    '2027-06-12','ISO 14067 (illustrative estimate)','Cradle-to-gate (A1-A3)',5400,'kg CO2e',1,
    '2026-10-22T00:00:00Z','2034-10-22T00:00:00Z',
    'Illustrative manufacturing footprint estimate for one vehicle; not a verified manufacturer declaration.'
);

INSERT INTO "SpecificAssetIds" ("ProductId","Name","Value") VALUES
('000-001','DemoSerialNumber','DEMO-CAR-1-0001'),
('000-001','ModelYear','2020'),
('000-001','Powertrain','petrol'),
('000-002','DemoSerialNumber','DEMO-CAR-2-0002'),
('000-002','ModelYear','2020'),
('000-002','Powertrain','petrol');

-- ---------- seed/02_vehicle_technical_data.sql.inc ----------
INSERT INTO "TechnicalPropertyArea" ("AssetId","Index","Length","Width","Height")
SELECT asset."Id", 0, dimensions."Length", dimensions."Width", dimensions."Height"
FROM "Asset" AS asset
JOIN (VALUES
    ('000-001',4531::NUMERIC,1817::NUMERIC,1421::NUMERIC),
    ('000-002',4540::NUMERIC,1760::NUMERIC,1470::NUMERIC)
) AS dimensions("ProductId","Length","Width","Height")
    ON dimensions."ProductId" = asset."ProductId";

INSERT INTO "Marking"
("Index","MarkingName","DesignationOfCertificateOrApproval","IssueDate","ExpiryDate","MarkingAdditionalText","MarkingFile")
VALUES
(0,'Demo reference - Car 1','DEMO-TA-CAR-1','2020-04-18','2027-04-18',
 'Synthetic Car 1 demonstration reference; not an actual certificate.','https://files.aas-demo.dev/sample_document.pdf'),
(0,'Demo reference - Car 2','DEMO-TA-CAR-2','2020-06-12','2027-06-12',
 'Synthetic Car 2 demonstration reference; not an actual certificate.','https://files.aas-demo.dev/sample_document.pdf');

INSERT INTO "AssetMarking" ("AssetId","MarkingId")
SELECT asset."Id", marking."Id"
FROM (VALUES
    ('000-001','Demo reference - Car 1'),
    ('000-002','Demo reference - Car 2')
) AS relation("ProductId","MarkingName")
JOIN "Asset" AS asset ON asset."ProductId" = relation."ProductId"
JOIN "Marking" AS marking ON marking."MarkingName" = relation."MarkingName";

INSERT INTO "ProductImage" ("Id","Index","ImageFile","ImageNote_en","ImageNote_de") VALUES
(1,0,'https://files.aas-demo.dev/Car1.jpeg','Illustrative image for Car 1.','Beispielbild fuer Car 1.'),
(2,0,'https://files.aas-demo.dev/Car2.jpeg','Illustrative image for Car 2.','Beispielbild fuer Car 2.');

INSERT INTO "AssetProductImage" ("Id","AssetId","ProductImageId")
SELECT relation."ImageId", asset."Id", relation."ImageId"
FROM (VALUES ('000-001',1),('000-002',2)) AS relation("ProductId","ImageId")
JOIN "Asset" AS asset ON asset."ProductId" = relation."ProductId";

INSERT INTO "ProductClassifications" (
    "Index","ClassificationSystem","ClassificationSystemVersion","ClassificationSystemUrl",
    "ProductClassId","ProductClassCodedName","ProductClassName_en","ProductClassName_de"
) VALUES
(0,'UNSPSC','26.0601','https://www.unspsc.org','25101500','CAR-1-PETROL',
 'Petrol passenger car - Car 1','Benzin-Personenwagen - Car 1'),
(0,'UNSPSC','26.0601','https://www.unspsc.org','25101500','CAR-2-PETROL',
 'Petrol passenger car - Car 2','Benzin-Personenwagen - Car 2');

INSERT INTO "AssetProductClassifications" ("AssetId","ProductClassificationsId")
SELECT asset."Id", classification."Id"
FROM (VALUES
    ('000-001','CAR-1-PETROL'),
    ('000-002','CAR-2-PETROL')
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
       'https://example.invalid/carbon-footprints/' || asset."ProductId",
       '?productId=' || asset."ProductId" || '&scope=cradle-to-gate&unit=kgCO2e&status=illustrative'
FROM "Asset" AS asset
WHERE asset."ProductId" IN ('000-001','000-002');

-- ---------- seed/03_vehicle_maintenance.sql.inc ----------
INSERT INTO "MaintenanceInstructionsForSpecificInterval" (
    "Index","MaintenanceID","NameOfMaintenance_en","NameOfMaintenance_de",
    "SourceOfMaintenanceInstructions_en","SourceOfMaintenanceInstructions_de",
    "RelatedStandardsLawsRegulations_en","RelatedStandardsLawsRegulations_de",
    "SafetyRegulationsToBeObserved_en","SafetyRegulationsToBeObserved_de",
    "MaintenanceIntervalValue","MaintenanceIntervalUnit","FlowChartOfMaintenanceSteps",
    "NumberOfRequiredTechnicians","RequiredQualification_en","RequiredQualification_de",
    "ValueTotalEstimatedWorkingTime","UnitValueTotalEstimatedWorkingTime"
) VALUES
(0,'CAR-1-OIL','Car 1 engine oil and filter service','Car 1 Motoröl- und Filterservice',
 'Illustrative Car 1 service schedule','Beispiel-Wartungsplan Car 1',
 'Example interval only; use the product-specific service schedule',
 'Nur Beispielintervall; produktspezifischen Wartungsplan verwenden',
 'Workshop demonstration only; follow the service and safety instructions',
 'Nur Werkstattdemonstration; Service- und Sicherheitshinweise beachten',
 15000,'km','https://files.aas-demo.dev/sample_document.pdf',1,'Qualified automotive technician','Qualifizierte Kfz-Fachkraft',1.0,'hour'),
(1,'CAR-1-BRAKES','Car 1 brake inspection','Car 1 Bremsenprüfung',
 'Illustrative Car 1 inspection schedule','Beispiel-Prüfplan Car 1',
 'Example interval only; use the product-specific inspection requirements',
 'Nur Beispielintervall; produktspezifische Prüfvorgaben verwenden',
 'Workshop demonstration only; follow the brake inspection safety instructions',
 'Nur Werkstattdemonstration; Sicherheitshinweise zur Bremsenprüfung beachten',
 12,'months','https://files.aas-demo.dev/sample_document.pdf',1,'Qualified automotive technician','Qualifizierte Kfz-Fachkraft',1.0,'hour'),
(0,'CAR-2-OIL','Car 2 engine oil and filter service','Car 2 Motoröl- und Filterservice',
 'Illustrative Car 2 service schedule','Beispiel-Wartungsplan Car 2',
 'Example interval only; use the product-specific service schedule',
 'Nur Beispielintervall; produktspezifischen Wartungsplan verwenden',
 'Workshop demonstration only; follow the service and safety instructions',
 'Nur Werkstattdemonstration; Service- und Sicherheitshinweise beachten',
 10000,'km','https://files.aas-demo.dev/sample_document.pdf',1,'Qualified automotive technician','Qualifizierte Kfz-Fachkraft',1.0,'hour'),
(1,'CAR-2-BRAKES','Car 2 brake inspection','Car 2 Bremsenprüfung',
 'Illustrative Car 2 inspection schedule','Beispiel-Prüfplan Car 2',
 'Example interval only; use the product-specific inspection requirements',
 'Nur Beispielintervall; produktspezifische Prüfvorgaben verwenden',
 'Workshop demonstration only; follow the brake inspection safety instructions',
 'Nur Werkstattdemonstration; Sicherheitshinweise zur Bremsenprüfung beachten',
 12,'months','https://files.aas-demo.dev/sample_document.pdf',1,'Qualified automotive technician','Qualifizierte Kfz-Fachkraft',1.0,'hour');

INSERT INTO "AssetMaintenanceInstruction" ("AssetId","MaintenanceInstructionId")
SELECT asset."Id", instruction."Id"
FROM (VALUES
    ('000-001','CAR-1-OIL'),('000-001','CAR-1-BRAKES'),
    ('000-002','CAR-2-OIL'),('000-002','CAR-2-BRAKES')
) AS relation("ProductId","MaintenanceID")
JOIN "Asset" AS asset ON asset."ProductId" = relation."ProductId"
JOIN "MaintenanceInstructionsForSpecificInterval" AS instruction
    ON instruction."MaintenanceID" = relation."MaintenanceID";

INSERT INTO "Alarm" ("Index","AlarmName_en","AlarmName_de","WarningLimitRelativeValue","WarningLimitSeverity") VALUES
(0,'Car 1 oil service due','Car 1 Ölservice fällig',100,'Warning'),
(0,'Car 1 brake inspection due','Car 1 Bremsenprüfung fällig',100,'Warning'),
(0,'Car 2 oil service due','Car 2 Ölservice fällig',100,'Warning'),
(0,'Car 2 brake inspection due','Car 2 Bremsenprüfung fällig',100,'Warning');

INSERT INTO "MaintenanceInstructionAlarm" ("MaintenanceInstructionId","AlarmId")
SELECT instruction."Id", alarm."Id"
FROM (VALUES
    ('CAR-1-OIL','Car 1 oil service due'),
    ('CAR-1-BRAKES','Car 1 brake inspection due'),
    ('CAR-2-OIL','Car 2 oil service due'),
    ('CAR-2-BRAKES','Car 2 brake inspection due')
) AS relation("MaintenanceID","AlarmName")
JOIN "MaintenanceInstructionsForSpecificInterval" AS instruction
    ON instruction."MaintenanceID" = relation."MaintenanceID"
JOIN "Alarm" AS alarm ON alarm."AlarmName_en" = relation."AlarmName";

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
       0,0,'piece',0,TRUE,step."EndOfMaintenance",
       instruction."NameOfMaintenance_en" || ' - ' || step."Name_en",
       instruction."NameOfMaintenance_de" || ' - ' || step."Name_de",
       'Workshop demonstration','Werkstattdemonstration',
       instruction."NameOfMaintenance_en" || ': ' || step."Instruction_en",
       instruction."NameOfMaintenance_de" || ': ' || step."Instruction_de",
       'Required checks are documented.','Erforderliche Prüfungen sind dokumentiert.',
       'Refer unresolved findings to the service technician.',
       'Offene Befunde an die Kfz-Fachkraft weitergeben.',
       instruction."FlowChartOfMaintenanceSteps",step."Duration",'minutes'
FROM "MaintenanceInstructionsForSpecificInterval" AS instruction
CROSS JOIN (VALUES
    (0,FALSE,'Prepare service record','Serviceprotokoll vorbereiten',
     'Record the vehicle identity and odometer reading.',
     'Fahrzeugidentität und Kilometerstand dokumentieren.',10),
    (1,FALSE,'Record inspection results','Prüfergebnisse erfassen',
     'Record the results of the work performed by a qualified technician using the official vehicle-specific procedure.',
     'Ergebnisse der nach offizieller fahrzeugspezifischer Vorgabe ausgeführten Facharbeiten dokumentieren.',40),
    (2,TRUE,'Close service record','Serviceprotokoll abschließen',
     'Document completed work and the next service due.',
     'Abgeschlossene Arbeiten und nächsten Wartungstermin dokumentieren.',10)
) AS step("Index","EndOfMaintenance","Name_en","Name_de","Instruction_en","Instruction_de","Duration")
WHERE instruction."MaintenanceID" IN ('CAR-1-OIL','CAR-1-BRAKES','CAR-2-OIL','CAR-2-BRAKES');

-- Each instruction owns a fictional contact and separate communication records.
INSERT INTO "ContactForMaintenanceAuthorization" (
    "Index","Company_en","Company_de","Department_en","Department_de",
    "Title_en","Title_de","AcademicTitle_en","AcademicTitle_de",
    "NameOfContact_en","NameOfContact_de","FirstName_en","FirstName_de",
    "MiddleNames_en","MiddleNames_de","Street_en","Street_de","Zipcode_en","Zipcode_de",
    "CityTown_en","CityTown_de","NationalCode_en","NationalCode_de","StateCounty_en","StateCounty_de",
    "FurtherDetailsOfContact_en","FurtherDetailsOfContact_de","RoleOfContactPerson"
)
SELECT 0, asset."ManufacturerProductDesignation_en" || ' Demo Workshop',
       asset."ManufacturerProductDesignation_de" || ' Demo-Werkstatt',
       instruction."NameOfMaintenance_en",instruction."NameOfMaintenance_de",
       'Mx','Mx','Not applicable','Nicht zutreffend',
       contact."LastName",contact."LastName",contact."FirstName",contact."FirstName",
       'Not applicable','Nicht zutreffend','1 Demo Street','Demo-Strasse 1','00000','00000',
       'Demo Town','Demo-Stadt','DE','DE','Demo Region','Demo-Region',
       'Fictional authorization contact for ' || instruction."MaintenanceID",
       'Fiktiver Freigabekontakt für ' || instruction."MaintenanceID",'Maintenance authorization'
FROM (VALUES
    ('CAR-1-OIL','Alex','Miller'),
    ('CAR-1-BRAKES','Sam','Taylor'),
    ('CAR-2-OIL','Robin','Clark'),
    ('CAR-2-BRAKES','Jamie','Morgan')
) AS contact("MaintenanceID","FirstName","LastName")
JOIN "MaintenanceInstructionsForSpecificInterval" instruction
    ON instruction."MaintenanceID" = contact."MaintenanceID"
JOIN "AssetMaintenanceInstruction" relation ON relation."MaintenanceInstructionId" = instruction."Id"
JOIN "Asset" asset ON asset."Id" = relation."AssetId";

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
SELECT contact."Id",lower(instruction."MaintenanceID") || '@example.invalid','Business',
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
    ('Clark','+1-202-555-0103'),('Morgan','+1-202-555-0104')
) AS number("LastName","Value") ON number."LastName" = contact."NameOfContact_en";

INSERT INTO "Fax" (
    "ContactForMaintenanceAuthorizationId","FaxNumber_en","FaxNumber_de","TypeOfFaxNumber"
)
SELECT contact."Id",number."Value",number."Value",'Business'
FROM "ContactForMaintenanceAuthorization" contact
JOIN (VALUES
    ('Miller','+1-202-555-0111'),('Taylor','+1-202-555-0112'),
    ('Clark','+1-202-555-0113'),('Morgan','+1-202-555-0114')
) AS number("LastName","Value") ON number."LastName" = contact."NameOfContact_en";

INSERT INTO "MaintenanceTool" (
    "Index","ToolID","OrderCodeToolOfManufacturer","AddressOfAdditionalLinkTool",
    "ToolName_en","ToolName_de","CompanyNameToolSupplier_en","CompanyNameToolSupplier_de",
    "ToolDescription_en","ToolDescription_de","MaxQuantityOfTool"
)
SELECT 0,'TOOL-' || asset."ProductId",'DEMO-TORQUE-WRENCH-' || asset."ProductId",
       'https://example.invalid/tools/' || asset."ProductId",
       asset."ManufacturerProductDesignation_en" || ' workshop torque wrench',
       asset."ManufacturerProductDesignation_de" || ' Werkstatt-Drehmomentschlüssel',
       asset."ManufacturerProductDesignation_en" || ' Demo Tool Supply',
       asset."ManufacturerProductDesignation_de" || ' Demo-Werkzeughandel',
       'Dedicated demonstration tool for ' || asset."ProductId",
       'Separates Beispielwerkzeug für ' || asset."ProductId",1
FROM "Asset" asset WHERE asset."ProductId" IN ('000-001','000-002');

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
SELECT 0,'CONSUMABLE-' || asset."ProductId",'litre','DEMO-ENGINE-OIL-' || asset."ProductId",
       'https://example.invalid/consumables/' || asset."ProductId",
       asset."ManufacturerProductDesignation_en" || ' engine oil',
       asset."ManufacturerProductDesignation_de" || ' Motoröl',
       asset."ManufacturerProductDesignation_en" || ' Demo Oil Supply',
       asset."ManufacturerProductDesignation_de" || ' Demo-Ölhandel',
       'Illustrative stock only; use the vehicle-specific approved oil grade and fill quantity.',
       'Nur Beispielbestand; fahrzeugspezifisch freigegebene Ölsorte und Füllmenge verwenden.',
       'Use an authorized waste-oil collection service.',
       'Über eine zugelassene Altölsammelstelle entsorgen.',5
FROM "Asset" asset WHERE asset."ProductId" IN ('000-001','000-002');

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
SELECT 0,'SPARE-' || asset."ProductId",'DEMO-OIL-FILTER-' || asset."ProductId",
       'https://example.invalid/spare-parts/' || asset."ProductId",
       asset."ManufacturerProductDesignation_en" || ' oil filter',
       asset."ManufacturerProductDesignation_de" || ' Ölfilter',
       asset."ManufacturerProductDesignation_en" || ' Demo Parts Supply',
       asset."ManufacturerProductDesignation_de" || ' Demo-Ersatzteilhandel',
       'Illustrative oil filter record; confirm vehicle-specific compatibility before use.',
       'Beispieldatensatz Ölfilter; fahrzeugspezifische Kompatibilität vor Verwendung prüfen.',
       'Dispose of used filters through an authorized workshop waste service.',
       'Gebrauchte Filter über einen zugelassenen Werkstattentsorger entsorgen.',1
FROM "Asset" asset WHERE asset."ProductId" IN ('000-001','000-002');

INSERT INTO "AssetMaintenanceSparePart" ("AssetId","MaintenanceSparePartId")
SELECT asset."Id",part."Id"
FROM "Asset" asset JOIN "MaintenanceSparePart" part ON part."SparePartID" = 'SPARE-' || asset."ProductId";

INSERT INTO "MaintenanceInstructionsForSpecificIntervalMaintenanceStep"
("MaintenanceInstructionsForSpecificIntervalId","MaintenanceStepId")
SELECT instruction."Id", step."Id"
FROM "MaintenanceInstructionsForSpecificInterval" AS instruction
JOIN "MaintenanceStep" AS step
    ON step."MaintenanceStepID" = instruction."MaintenanceID" || '-STEP-' || step."Index"
WHERE instruction."MaintenanceID" IN ('CAR-1-OIL','CAR-1-BRAKES','CAR-2-OIL','CAR-2-BRAKES');

-- ---------- seed/04_vehicle_documentation.sql.inc ----------
INSERT INTO "Document" ("Index") VALUES
(0),(1),(0),(1);

INSERT INTO "DocumentId" ("Index","DocumentDomainId","DocumentIdentifier","DocumentIsPrimary") VALUES
(0,'4bbdba12-9352-4fac-91ae-000000000001','CAR-1-OWNER-GUIDE-DEMO',TRUE),
(0,'4bbdba12-9352-4fac-91ae-000000000002','CAR-1-TECH-SHEET-DEMO',TRUE),
(0,'4bbdba12-9352-4fac-91ae-000000000003','CAR-2-OWNER-GUIDE-DEMO',TRUE),
(0,'4bbdba12-9352-4fac-91ae-000000000004','CAR-2-TECH-SHEET-DEMO',TRUE);

INSERT INTO "AssetDocument" ("AssetId","DocumentId")
SELECT asset."Id", relation."DocumentId"
FROM (VALUES
    ('000-001',1),('000-001',2),('000-002',3),('000-002',4)
) AS relation("ProductId","DocumentId")
JOIN "Asset" AS asset ON asset."ProductId" = relation."ProductId";

INSERT INTO "DocumentDocumentId" ("DocumentId","DocumentIdentifierId") VALUES
(1,1),(2,2),(3,3),(4,4);

INSERT INTO "DocumentClassification" ("Index","ClassId","ClassificationSystem","ClassName_en","ClassName_de") VALUES
(0,'VEHICLE-OWNER-MANUAL','DEMO','Car 1 owner information','Car 1 Besitzerinformationen'),
(0,'VEHICLE-TECHNICAL-SHEET','DEMO','Car 1 technical data sheet','Car 1 technisches Datenblatt'),
(0,'VEHICLE-OWNER-MANUAL','DEMO','Car 2 owner information','Car 2 Besitzerinformationen'),
(0,'VEHICLE-TECHNICAL-SHEET','DEMO','Car 2 technical data sheet','Car 2 technisches Datenblatt');

INSERT INTO "DocumentDocumentClassification" ("DocumentId","DocumentClassificationId") VALUES
(1,1),(2,2),(3,3),(4,4);

INSERT INTO "DocumentVersion" (
    "Index","DigitalFile","Version","StatusSetDate","StatusValue","OrganizationShortName",
    "OrganizationOfficialName","Title_en","Title_de","Subtitle_en","Subtitle_de","Description_en","Description_de",
    "KeyWords_en","KeyWords_de","PreviewFile"
) VALUES
(0,'https://files.aas-demo.dev/sample_document.pdf','Demo 1.0','2026-10-22','Illustrative',
 'Demo','Demo Organization','Car 1 - owner guide reference (demo)','Car 1 - Referenz zur Betriebsanleitung (Demo)',
 'Demo petrol car','Demo-Benzinfahrzeug',
 'Demonstration owner information for Car 1.',
 'Beispiel-Besitzerinformationen fuer Car 1.',
 'Car 1, owner guide, demo','Car 1, Betriebsanleitung, Demo','https://files.aas-demo.dev/sample_document.pdf'),
(0,'https://files.aas-demo.dev/sample_document.pdf','Demo 1.0','2026-10-22','Illustrative',
 'Demo','Demo Organization','Car 1 - technical data (demo)','Car 1 - technische Daten (Demo)',
 'Demo petrol vehicle','Demo-Benzinfahrzeug',
 'Representative Car 1 specifications for demonstration.',
 'Beispiel-Fahrzeugdaten fuer Car 1.',
 'Car 1, dimensions, demo','Car 1, Abmessungen, Demo','https://files.aas-demo.dev/sample_document.pdf'),
(0,'https://files.aas-demo.dev/sample_document.pdf','Demo 1.0','2026-10-22','Illustrative',
 'Demo','Demo Organization','Car 2 - owner guide reference (demo)',
 'Car 2 - Referenz zur Betriebsanleitung (Demo)',
 'Demo petrol car','Demo-Benzinfahrzeug',
 'Demonstration owner information for Car 2.',
 'Beispiel-Besitzerinformationen fuer Car 2.',
 'Car 2, owner guide, demo','Car 2, Betriebsanleitung, Demo','https://files.aas-demo.dev/sample_document.pdf'),
(0,'https://files.aas-demo.dev/sample_document.pdf','Demo 1.0','2026-10-22','Illustrative',
 'Demo','Demo Organization','Car 2 - technical data (demo)',
 'Car 2 - technische Daten (Demo)',
 'Demo petrol vehicle','Demo-Benzinfahrzeug',
 'Representative Car 2 specifications for demonstration.',
 'Beispiel-Fahrzeugdaten fuer Car 2.',
 'Car 2, dimensions, demo','Car 2, Abmessungen, Demo','https://files.aas-demo.dev/sample_document.pdf');

-- Language codes may repeat, but every version owns separate language records.
INSERT INTO "Languages" ("Index","Language") VALUES
(0,'en'),(1,'de'),(0,'en'),(1,'de'),(0,'en'),(1,'de'),(0,'en'),(1,'de');

INSERT INTO "DocumentVersionLanguages" ("DocumentVersionId","LanguageId") VALUES
(1,1),(1,2),(2,3),(2,4),(3,5),(3,6),(4,7),(4,8);

INSERT INTO "DocumentDocumentVersion" ("DocumentId","DocumentVersionId") VALUES
(1,1),(2,2),(3,3),(4,4);
