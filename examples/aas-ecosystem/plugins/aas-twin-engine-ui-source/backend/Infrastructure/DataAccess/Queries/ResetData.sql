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
    '000-001','BMW_320i','https://mm-software.com/ids/assets/000-001','https://mm-software.com/ids/aas/000-001',
    'Instance','PetrolPassengerCar','image/jpeg',
    'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?auto=format&fit=crop&w=1200&q=85',
    FALSE,'https://www.bmw.com/','320i 2.0 Petrol (E90)',
    'DEMO-BMW-320I-2010','BMW-320I-2010-DEMO','DEMO-BMW320I-2010-0001',2010,'2010-04-18',
    'E90','demo-1.0','demo-1.0','DE','BMW-MUNICH-DEMO-01',
    'Petuelring 130','Petuelring 130','80809','80809','Munich','Muenchen','DE','DE',
    'BMW AG','BMW 320i','BMW 320i','BMW 3 Series','BMW 3er','3 Series','3er',
    'https://upload.wikimedia.org/wikipedia/commons/4/44/BMW.svg','BMW-320I-E90',
    'DEMO-BMW-320I-2010',
    'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?auto=format&fit=crop&w=1200&q=85',
    'https://upload.wikimedia.org/wikipedia/commons/4/44/BMW.svg',
    'Illustrative demonstration record. Vehicle specifications are representative; serial numbers and carbon-footprint values are synthetic.',
    'Beispieldatensatz. Die Fahrzeugdaten sind repräsentativ; Seriennummern und CO2-Fussabdruckwerte sind synthetisch.',
    '2027-04-18','ISO 14067 (illustrative estimate)','Cradle-to-gate (A1-A3)',6100,'kg CO2e',1,
    '2026-10-22T00:00:00Z','2034-10-22T00:00:00Z',
    'Illustrative manufacturing footprint estimate for one vehicle; not a verified manufacturer declaration.'
),
(
    '000-002','Toyota_Corolla_16','https://mm-software.com/ids/assets/000-002','https://mm-software.com/ids/aas/000-002',
    'Instance','PetrolPassengerCar','image/jpeg',
    'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?auto=format&fit=crop&w=1200&q=85',
    FALSE,'https://www.toyota-europe.com/','Corolla 1.6 Petrol (E150)',
    'DEMO-TOYOTA-COROLLA-16-2012','TOYOTA-COROLLA-2012-DEMO','DEMO-TOYOTA-2012-0002',2012,'2012-06-12',
    'E150','demo-1.0','demo-1.0','JP','TOYOTA-TSUTSUMI-DEMO-02',
    '1 Toyota-cho','1 Toyota-cho','471-8571','471-8571','Toyota City','Toyota City','JP','JP',
    'Toyota Motor Corporation','Corolla 1.6','Corolla 1.6',
    'Corolla Sedan','Corolla Limousine','Corolla','Corolla',
    'https://upload.wikimedia.org/wikipedia/commons/9/9d/Toyota_carlogo.svg','TOYOTA-COROLLA-16-E150',
    'DEMO-TOYOTA-COROLLA-16-2012',
    'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?auto=format&fit=crop&w=1200&q=85',
    'https://upload.wikimedia.org/wikipedia/commons/9/9d/Toyota_carlogo.svg',
    'Illustrative demonstration record. Vehicle specifications are representative; serial numbers and carbon-footprint values are synthetic.',
    'Beispieldatensatz. Die Fahrzeugdaten sind repräsentativ; Seriennummern und CO2-Fussabdruckwerte sind synthetisch.',
    '2027-06-12','ISO 14067 (illustrative estimate)','Cradle-to-gate (A1-A3)',5400,'kg CO2e',1,
    '2026-10-22T00:00:00Z','2034-10-22T00:00:00Z',
    'Illustrative manufacturing footprint estimate for one vehicle; not a verified manufacturer declaration.'
);

INSERT INTO "SpecificAssetIds" ("ProductId","Name","Value") VALUES
('000-001','DemoSerialNumber','DEMO-BMW320I-2010-0001'),
('000-001','ModelYear','2010'),
('000-001','Powertrain','2.0-litre petrol'),
('000-002','DemoSerialNumber','DEMO-TOYOTA-2012-0002'),
('000-002','ModelYear','2012'),
('000-002','Powertrain','1.6-litre petrol');

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
(0,'Type approval reference - BMW 320i','DEMO-TA-BMW-320I-2010','2010-04-18','2027-04-18',
 'Synthetic BMW 320i demonstration reference; not an actual certificate.','https://www.bmw.com/'),
(0,'Type approval reference - Toyota Corolla 1.6','DEMO-TA-TOYOTA-COROLLA-2012','2012-06-12','2027-06-12',
 'Synthetic Toyota Corolla demonstration reference; not an actual certificate.','https://www.toyota-europe.com/');

INSERT INTO "AssetMarking" ("AssetId","MarkingId")
SELECT asset."Id", marking."Id"
FROM (VALUES
    ('000-001','Type approval reference - BMW 320i'),
    ('000-002','Type approval reference - Toyota Corolla 1.6')
) AS relation("ProductId","MarkingName")
JOIN "Asset" AS asset ON asset."ProductId" = relation."ProductId"
JOIN "Marking" AS marking ON marking."MarkingName" = relation."MarkingName";

INSERT INTO "ProductImage" ("Id","Index","ImageFile","ImageNote_en","ImageNote_de") VALUES
(1,0,'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?auto=format&fit=crop&w=1200&q=85',
 'Illustrative image for the BMW 320i record; not a verified photograph of this model or vehicle.',
 'Beispielbild zum BMW-320i-Datensatz; kein verifiziertes Foto dieses Modells oder Fahrzeugs.'),
(2,0,'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?auto=format&fit=crop&w=1200&q=85',
 'Illustrative image for the Toyota Corolla record; not a verified photograph of this model or vehicle.',
 'Beispielbild zum Toyota-Corolla-Datensatz; kein verifiziertes Foto dieses Modells oder Fahrzeugs.');

INSERT INTO "AssetProductImage" ("Id","AssetId","ProductImageId")
SELECT relation."ImageId", asset."Id", relation."ImageId"
FROM (VALUES ('000-001',1),('000-002',2)) AS relation("ProductId","ImageId")
JOIN "Asset" AS asset ON asset."ProductId" = relation."ProductId";

INSERT INTO "ProductClassifications" (
    "Index","ClassificationSystem","ClassificationSystemVersion","ClassificationSystemUrl",
    "ProductClassId","ProductClassCodedName","ProductClassName_en","ProductClassName_de"
) VALUES
(0,'UNSPSC','26.0601','https://www.unspsc.org','25101500','BMW-320I-PETROL',
 'Petrol passenger car - BMW 320i','Benzin-Personenwagen - BMW 320i'),
(0,'UNSPSC','26.0601','https://www.unspsc.org','25101500','TOYOTA-COROLLA-16-PETROL',
 'Petrol passenger car - Toyota Corolla 1.6','Benzin-Personenwagen - Toyota Corolla 1.6');

INSERT INTO "AssetProductClassifications" ("AssetId","ProductClassificationsId")
SELECT asset."Id", classification."Id"
FROM (VALUES
    ('000-001','BMW-320I-PETROL'),
    ('000-002','TOYOTA-COROLLA-16-PETROL')
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
(0,'BMW-320I-OIL','BMW 320i engine oil and filter service','BMW 320i Motoröl- und Filterservice',
 'Illustrative BMW 320i service schedule','Beispiel-Wartungsplan BMW 320i',
 'Example interval only; use the vehicle-specific BMW service schedule',
 'Nur Beispielintervall; fahrzeugspezifischen BMW-Wartungsplan verwenden',
 'Workshop demonstration only; follow the official BMW service and safety instructions',
 'Nur Werkstattdemonstration; offizielle BMW-Service- und Sicherheitshinweise beachten',
 15000,'km','https://www.bmw.com/',1,'Qualified automotive technician','Qualifizierte Kfz-Fachkraft',1.0,'hour'),
(1,'BMW-320I-BRAKES','BMW 320i brake inspection','BMW 320i Bremsenprüfung',
 'Illustrative BMW 320i inspection schedule','Beispiel-Prüfplan BMW 320i',
 'Example interval only; use the vehicle-specific BMW inspection requirements',
 'Nur Beispielintervall; fahrzeugspezifische BMW-Prüfvorgaben verwenden',
 'Workshop demonstration only; follow the official BMW brake inspection safety instructions',
 'Nur Werkstattdemonstration; offizielle BMW-Sicherheitshinweise zur Bremsenprüfung beachten',
 12,'months','https://www.bmw.com/',1,'Qualified automotive technician','Qualifizierte Kfz-Fachkraft',1.0,'hour'),
(0,'COROLLA-16-OIL','Toyota Corolla engine oil and filter service','Toyota Corolla Motoröl- und Filterservice',
 'Illustrative Toyota Corolla service schedule','Beispiel-Wartungsplan Toyota Corolla',
 'Example interval only; use the vehicle-specific Toyota service schedule',
 'Nur Beispielintervall; fahrzeugspezifischen Toyota-Wartungsplan verwenden',
 'Workshop demonstration only; follow the official Toyota service and safety instructions',
 'Nur Werkstattdemonstration; offizielle Toyota-Service- und Sicherheitshinweise beachten',
 10000,'km','https://www.toyota-europe.com/',1,'Qualified automotive technician','Qualifizierte Kfz-Fachkraft',1.0,'hour'),
(1,'COROLLA-16-BRAKES','Toyota Corolla brake inspection','Toyota Corolla Bremsenprüfung',
 'Illustrative Toyota Corolla inspection schedule','Beispiel-Prüfplan Toyota Corolla',
 'Example interval only; use the vehicle-specific Toyota inspection requirements',
 'Nur Beispielintervall; fahrzeugspezifische Toyota-Prüfvorgaben verwenden',
 'Workshop demonstration only; follow the official Toyota brake inspection safety instructions',
 'Nur Werkstattdemonstration; offizielle Toyota-Sicherheitshinweise zur Bremsenprüfung beachten',
 12,'months','https://www.toyota-europe.com/',1,'Qualified automotive technician','Qualifizierte Kfz-Fachkraft',1.0,'hour');

INSERT INTO "AssetMaintenanceInstruction" ("AssetId","MaintenanceInstructionId")
SELECT asset."Id", instruction."Id"
FROM (VALUES
    ('000-001','BMW-320I-OIL'),('000-001','BMW-320I-BRAKES'),
    ('000-002','COROLLA-16-OIL'),('000-002','COROLLA-16-BRAKES')
) AS relation("ProductId","MaintenanceID")
JOIN "Asset" AS asset ON asset."ProductId" = relation."ProductId"
JOIN "MaintenanceInstructionsForSpecificInterval" AS instruction
    ON instruction."MaintenanceID" = relation."MaintenanceID";

INSERT INTO "Alarm" ("Index","AlarmName_en","AlarmName_de","WarningLimitRelativeValue","WarningLimitSeverity") VALUES
(0,'BMW 320i oil service due','BMW 320i Ölservice fällig',100,'Warning'),
(0,'BMW 320i brake inspection due','BMW 320i Bremsenprüfung fällig',100,'Warning'),
(0,'Toyota Corolla oil service due','Toyota Corolla Ölservice fällig',100,'Warning'),
(0,'Toyota Corolla brake inspection due','Toyota Corolla Bremsenprüfung fällig',100,'Warning');

INSERT INTO "MaintenanceInstructionAlarm" ("MaintenanceInstructionId","AlarmId")
SELECT instruction."Id", alarm."Id"
FROM (VALUES
    ('BMW-320I-OIL','BMW 320i oil service due'),
    ('BMW-320I-BRAKES','BMW 320i brake inspection due'),
    ('COROLLA-16-OIL','Toyota Corolla oil service due'),
    ('COROLLA-16-BRAKES','Toyota Corolla brake inspection due')
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
WHERE instruction."MaintenanceID" IN ('BMW-320I-OIL','BMW-320I-BRAKES','COROLLA-16-OIL','COROLLA-16-BRAKES');

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
    ('BMW-320I-OIL','Alex','Miller'),
    ('BMW-320I-BRAKES','Sam','Taylor'),
    ('COROLLA-16-OIL','Robin','Clark'),
    ('COROLLA-16-BRAKES','Jamie','Morgan')
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
WHERE instruction."MaintenanceID" IN ('BMW-320I-OIL','BMW-320I-BRAKES','COROLLA-16-OIL','COROLLA-16-BRAKES');

-- ---------- seed/04_vehicle_documentation.sql.inc ----------
INSERT INTO "Document" ("Index") VALUES
(0),(1),(0),(1);

INSERT INTO "DocumentId" ("Index","DocumentDomainId","DocumentIdentifier","DocumentIsPrimary") VALUES
(0,'4bbdba12-9352-4fac-91ae-000000000001','BMW-320I-OWNER-GUIDE-DEMO',TRUE),
(0,'4bbdba12-9352-4fac-91ae-000000000002','BMW-320I-TECH-SHEET-DEMO',TRUE),
(0,'4bbdba12-9352-4fac-91ae-000000000003','TOYOTA-COROLLA-16-OWNER-GUIDE-DEMO',TRUE),
(0,'4bbdba12-9352-4fac-91ae-000000000004','TOYOTA-COROLLA-16-TECH-SHEET-DEMO',TRUE);

INSERT INTO "AssetDocument" ("AssetId","DocumentId")
SELECT asset."Id", relation."DocumentId"
FROM (VALUES
    ('000-001',1),('000-001',2),('000-002',3),('000-002',4)
) AS relation("ProductId","DocumentId")
JOIN "Asset" AS asset ON asset."ProductId" = relation."ProductId";

INSERT INTO "DocumentDocumentId" ("DocumentId","DocumentIdentifierId") VALUES
(1,1),(2,2),(3,3),(4,4);

INSERT INTO "DocumentClassification" ("Index","ClassId","ClassificationSystem","ClassName_en","ClassName_de") VALUES
(0,'VEHICLE-OWNER-MANUAL','DEMO','BMW 320i owner information','BMW 320i Besitzerinformationen'),
(0,'VEHICLE-TECHNICAL-SHEET','DEMO','BMW 320i technical data sheet','BMW 320i technisches Datenblatt'),
(0,'VEHICLE-OWNER-MANUAL','DEMO','Toyota Corolla owner information','Toyota Corolla Besitzerinformationen'),
(0,'VEHICLE-TECHNICAL-SHEET','DEMO','Toyota Corolla technical data sheet','Toyota Corolla technisches Datenblatt');

INSERT INTO "DocumentDocumentClassification" ("DocumentId","DocumentClassificationId") VALUES
(1,1),(2,2),(3,3),(4,4);

INSERT INTO "DocumentVersion" (
    "Index","DigitalFile","Version","StatusSetDate","StatusValue","OrganizationShortName",
    "OrganizationOfficialName","Title_en","Title_de","Subtitle_en","Subtitle_de","Description_en","Description_de",
    "KeyWords_en","KeyWords_de","PreviewFile"
) VALUES
(0,'https://www.bmw.com/','Demo 1.0','2026-10-22','Illustrative',
 'BMW','BMW AG','BMW 320i - owner guide reference (demo)','BMW 320i - Referenz zur Betriebsanleitung (Demo)',
 '2010 petrol sedan','Benzinlimousine Baujahr 2010',
 'Demonstration owner information for the BMW 320i; not an official BMW publication.',
 'Beispiel-Besitzerinformationen zum BMW 320i; keine offizielle BMW-Veröffentlichung.',
 'BMW, 320i, petrol, owner guide, demo','BMW, 320i, Benzin, Betriebsanleitung, Demo','https://www.bmw.com/'),
(0,'https://www.bmw.com/','Demo 1.0','2026-10-22','Illustrative',
 'BMW','BMW AG','BMW 320i - technical data (demo)','BMW 320i - technische Daten (Demo)',
 'E90 2.0-litre petrol engine','E90 2,0-Liter-Benzinmotor',
 'Representative BMW 320i specifications for demonstration; verify against the vehicle-specific documentation.',
 'Beispiel-Fahrzeugdaten zum BMW 320i; anhand der fahrzeugspezifischen Dokumentation prüfen.',
 'BMW, 320i, dimensions, petrol engine, demo','BMW, 320i, Abmessungen, Benzinmotor, Demo','https://www.bmw.com/'),
(0,'https://www.toyota-europe.com/','Demo 1.0','2026-10-22','Illustrative',
 'Toyota','Toyota Motor Corporation','Toyota Corolla 1.6 - owner guide reference (demo)',
 'Toyota Corolla 1.6 - Referenz zur Betriebsanleitung (Demo)',
 '2012 petrol sedan','Benzinlimousine Baujahr 2012',
 'Demonstration owner information for the Toyota Corolla 1.6; not an official Toyota publication.',
 'Beispiel-Besitzerinformationen zum Toyota Corolla 1.6; keine offizielle Toyota-Veröffentlichung.',
 'Toyota, Corolla, petrol, owner guide, demo','Toyota, Corolla, Benzin, Betriebsanleitung, Demo','https://www.toyota-europe.com/'),
(0,'https://www.toyota-europe.com/','Demo 1.0','2026-10-22','Illustrative',
 'Toyota','Toyota Motor Corporation','Toyota Corolla 1.6 - technical data (demo)',
 'Toyota Corolla 1.6 - technische Daten (Demo)',
 'E150 1.6-litre petrol engine','E150 1,6-Liter-Benzinmotor',
 'Representative Toyota Corolla 1.6 specifications for demonstration; verify against the vehicle-specific documentation.',
 'Beispiel-Fahrzeugdaten zum Toyota Corolla 1.6; anhand der fahrzeugspezifischen Dokumentation prüfen.',
 'Toyota, Corolla, dimensions, petrol engine, demo','Toyota, Corolla, Abmessungen, Benzinmotor, Demo','https://www.toyota-europe.com/');

-- Language codes may repeat, but every version owns separate language records.
INSERT INTO "Languages" ("Index","Language") VALUES
(0,'en'),(1,'de'),(0,'en'),(1,'de'),(0,'en'),(1,'de'),(0,'en'),(1,'de');

INSERT INTO "DocumentVersionLanguages" ("DocumentVersionId","LanguageId") VALUES
(1,1),(1,2),(2,3),(2,4),(3,5),(3,6),(4,7),(4,8);

INSERT INTO "DocumentDocumentVersion" ("DocumentId","DocumentVersionId") VALUES
(1,1),(2,2),(3,3),(4,4);
