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
       'Not applicable','Nicht zutreffend','Musterstrasse 1','Musterstraße 1','12345','12345',
       'Musterstadt','Musterstadt','DE','DE','Demo Region','Demo-Region',
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
