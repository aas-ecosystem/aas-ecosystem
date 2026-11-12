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
