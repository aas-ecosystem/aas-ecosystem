-- Demo assets: three laser-cut wooden model cars of the fictional "Demo Company GmbH".
-- Images: https://files.aas-demo.dev/car1.jpeg … car3.jpeg (photos of the physical models).
-- Dimensions are rounded approximate values; serial numbers, dates and CO2 values are synthetic.
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
    '000-001','Car1','https://mm-software.com/ids/assets/000-001','https://mm-software.com/ids/aas/000-001',
    'Instance','WoodenModelCar','image/jpeg',
    'https://files.aas-demo.dev/car1.jpeg',
    FALSE,'https://example.com/products/dc-sw-01','DC-SW-01',
    'DC-SW-01','DC-SW-01','DC-SW-2026-0001',2026,'2026-11-02',
    'Rev. A','n/a','n/a','DE','DC-MUSTERSTADT-01',
    'Musterstrasse 1','Musterstraße 1','12345','12345','Musterstadt','Musterstadt','DE','DE',
    'Demo Company GmbH','Wooden sports car (Car 1)','Holz-Sportwagen (Car 1)',
    'Wooden model car','Holzmodell-Auto','Demo model cars','Demo-Modellautos',
    'https://files.aas-demo.dev/demo-company-logo.png','DC-SW-01',
    'DC-SW-01',
    'https://files.aas-demo.dev/car1.jpeg',
    'https://files.aas-demo.dev/demo-company-logo.png',
    'Illustrative demonstration record for a laser-cut wooden model car. Dimensions are approximate; serial numbers and carbon-footprint values are synthetic.',
    'Beispieldatensatz für ein lasergeschnittenes Holzmodell-Auto. Maße sind Circa-Werte; Seriennummern und CO2-Werte sind synthetisch.',
    '2027-11-02','ISO 14067 (illustrative estimate)','Cradle-to-gate (A1-A3)',0.35,'piece',1,
    '2026-11-14T00:00:00Z','2034-11-14T00:00:00Z',
    'Illustrative manufacturing footprint estimate for one laser-cut wooden model car; not a verified declaration.'
),
(
    '000-002','Car2','https://mm-software.com/ids/assets/000-002','https://mm-software.com/ids/aas/000-002',
    'Instance','WoodenModelCar','image/jpeg',
    'https://files.aas-demo.dev/car2.jpeg',
    FALSE,'https://example.com/products/dc-gw-02','DC-GW-02',
    'DC-GW-02','DC-GW-02','DC-GW-2026-0002',2026,'2026-11-03',
    'Rev. A','n/a','n/a','DE','DC-MUSTERSTADT-01',
    'Musterstrasse 1','Musterstraße 1','12345','12345','Musterstadt','Musterstadt','DE','DE',
    'Demo Company GmbH','Wooden off-road vehicle (Car 2)','Holz-Geländewagen (Car 2)',
    'Wooden model car','Holzmodell-Auto','Demo model cars','Demo-Modellautos',
    'https://files.aas-demo.dev/demo-company-logo.png','DC-GW-02',
    'DC-GW-02',
    'https://files.aas-demo.dev/car2.jpeg',
    'https://files.aas-demo.dev/demo-company-logo.png',
    'Illustrative demonstration record for a laser-cut wooden model car. Dimensions are approximate; serial numbers and carbon-footprint values are synthetic.',
    'Beispieldatensatz für ein lasergeschnittenes Holzmodell-Auto. Maße sind Circa-Werte; Seriennummern und CO2-Werte sind synthetisch.',
    '2027-11-03','ISO 14067 (illustrative estimate)','Cradle-to-gate (A1-A3)',0.40,'piece',1,
    '2026-11-14T00:00:00Z','2034-11-14T00:00:00Z',
    'Illustrative manufacturing footprint estimate for one laser-cut wooden model car; not a verified declaration.'
),
(
    '000-003','Car3','https://mm-software.com/ids/assets/000-003','https://mm-software.com/ids/aas/000-003',
    'Instance','WoodenModelCar','image/jpeg',
    'https://files.aas-demo.dev/car3.jpeg',
    FALSE,'https://example.com/products/dc-pu-03','DC-PU-03',
    'DC-PU-03','DC-PU-03','DC-PU-2026-0003',2026,'2026-11-04',
    'Rev. A','n/a','n/a','DE','DC-MUSTERSTADT-01',
    'Musterstrasse 1','Musterstraße 1','12345','12345','Musterstadt','Musterstadt','DE','DE',
    'Demo Company GmbH','Wooden pickup truck (Car 3)','Holz-Pickup (Car 3)',
    'Wooden model car','Holzmodell-Auto','Demo model cars','Demo-Modellautos',
    'https://files.aas-demo.dev/demo-company-logo.png','DC-PU-03',
    'DC-PU-03',
    'https://files.aas-demo.dev/car3.jpeg',
    'https://files.aas-demo.dev/demo-company-logo.png',
    'Illustrative demonstration record for a laser-cut wooden model car. Dimensions are approximate; serial numbers and carbon-footprint values are synthetic.',
    'Beispieldatensatz für ein lasergeschnittenes Holzmodell-Auto. Maße sind Circa-Werte; Seriennummern und CO2-Werte sind synthetisch.',
    '2027-11-04','ISO 14067 (illustrative estimate)','Cradle-to-gate (A1-A3)',0.45,'piece',1,
    '2026-11-14T00:00:00Z','2034-11-14T00:00:00Z',
    'Illustrative manufacturing footprint estimate for one laser-cut wooden model car; not a verified declaration.'
);

-- Standard keys (IDTA naming) so discovery by serial number / part number works.
INSERT INTO "SpecificAssetIds" ("ProductId","Name","Value") VALUES
('000-001','serialNumber','DC-SW-2026-0001'),
('000-001','manufacturerPartId','DC-SW-01'),
('000-002','serialNumber','DC-GW-2026-0002'),
('000-002','manufacturerPartId','DC-GW-02'),
('000-003','serialNumber','DC-PU-2026-0003'),
('000-003','manufacturerPartId','DC-PU-03');
