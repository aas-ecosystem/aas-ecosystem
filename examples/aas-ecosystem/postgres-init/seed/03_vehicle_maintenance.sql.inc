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
