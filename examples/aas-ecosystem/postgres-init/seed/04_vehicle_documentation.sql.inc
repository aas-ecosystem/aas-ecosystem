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
