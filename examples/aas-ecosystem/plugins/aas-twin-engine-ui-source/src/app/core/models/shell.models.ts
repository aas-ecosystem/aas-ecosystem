export interface ShellDescriptor {
  id: string;
  productId?: string;
  idShort?: string;
  globalAssetId?: string;
  assetKind?: string;
  assetType?: string;
  submodelDescriptors?: SubmodelDescriptor[];
}

export interface SubmodelDescriptor {
  id?: string;
  idShort?: string;
  semanticId?: {
    keys?: { value?: string }[];
  };
  endpoints?: {
    protocolInformation?: { href?: string };
  }[];
}

export interface ShellDescriptorResponse {
  result: ShellDescriptor[];
  paging_metadata?: { cursor?: string };
}

export interface AasShell {
  id: string;
  idShort?: string;
  assetInformation?: {
    assetKind?: string;
    assetType?: string;
    globalAssetId?: string;
  };
  submodels?: { keys?: { value?: string }[] }[];
}

export interface AasShellResponse {
  result?: AasShell[];
  paging_metadata?: { cursor?: string | null };
}

export interface AddressInformation {
  street: string;
  zipcode: string;
  cityTown: string;
  nationalCode: string;
}

export interface NameplateData {
  addressInformation: AddressInformation;
  name: string;
  dateOfManufacture: string;
  serialNumber: string;
  manufacturerProductType: string;
}

export interface CarbonFootprintData {
  pcfCO2eq: string;
  referenceImpactUnitForCalculation: string;
  quantityOfMeasureForCalculation: string;
  publicationDate: string;
  expirationDate: string;
}

export interface TechnicalDataData {
  length: string;
  width: string;
  height: string;
  manufacturerName: string;
  manufacturerArticleNumber: string;
}

export interface ShellEditData {
  nameplate: NameplateData;
  carbonFootprint: CarbonFootprintData;
  technicalData: TechnicalDataData;
}

export interface ProductRequest {
  name: string;
  dateOfManufacture: string | null;
  manufacturerName: string;
  manufacturerArticleNumber: string;
  pcfCO2eq: number;
  referenceImpactUnitForCalculation: string;
}

export interface ProductUpdateRequest extends ProductRequest {
  id: string;
  addressInformation: AddressInformation;
  serialNumber: string;
  manufacturerProductType: string;
  quantityOfMeasureForCalculation: string | null;
  publicationDate: string | null;
  expirationDate: string | null;
  length: string | null;
  width: string | null;
  height: string | null;
}

export interface ProductResponse {
  productId: string;
  idShort: string;
  aasId: string;
  globalAssetId: string;
}

export const EMPTY_SHELL_EDIT_DATA: ShellEditData = {
  nameplate: {
    addressInformation: { street: '', zipcode: '', cityTown: '', nationalCode: '' },
    name: '',
    dateOfManufacture: '',
    serialNumber: '',
    manufacturerProductType: '',
  },
  carbonFootprint: {
    pcfCO2eq: '',
    referenceImpactUnitForCalculation: '',
    quantityOfMeasureForCalculation: '',
    publicationDate: '',
    expirationDate: '',
  },
  technicalData: {
    length: '',
    width: '',
    height: '',
    manufacturerName: '',
    manufacturerArticleNumber: '',
  },
};
