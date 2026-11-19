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
