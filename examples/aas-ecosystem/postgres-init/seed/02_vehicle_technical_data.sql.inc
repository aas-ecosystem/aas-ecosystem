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
