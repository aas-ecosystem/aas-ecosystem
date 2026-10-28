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
