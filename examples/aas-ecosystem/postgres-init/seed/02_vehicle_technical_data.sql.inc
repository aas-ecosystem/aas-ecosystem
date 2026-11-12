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
