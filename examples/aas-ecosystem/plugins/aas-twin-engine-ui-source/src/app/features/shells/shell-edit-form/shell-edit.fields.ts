import { ShellEditData } from '../../../core/models/shell.models';
import { TextFieldType } from '../../../shared/components/text-field/text-field';

export interface FieldConfig {
  key: string;
  label: string;
  type?: TextFieldType;
  suffix?: string;
}

export const SHELL_CREATE_PCF_UNIT = 'kg';

export interface GroupConfig {
  key: string;
  title: string;
  fields: FieldConfig[];
}

export interface SectionConfig {
  key: keyof ShellEditData;
  title: string;
  groups?: GroupConfig[];
  fields: FieldConfig[];
}

export const SHELL_EDIT_SECTIONS: SectionConfig[] = [
  {
    key: 'nameplate',
    title: 'Nameplate',
    groups: [
      {
        key: 'addressInformation',
        title: 'Address Information',
        fields: [
          { key: 'street', label: 'Street' },
          { key: 'zipcode', label: 'Zipcode' },
          { key: 'cityTown', label: 'City / Town' },
          { key: 'nationalCode', label: 'National Code' },
        ],
      },
    ],
    fields: [
      { key: 'dateOfManufacture', label: 'Date of Manufacture', type: 'date' },
      { key: 'serialNumber', label: 'Serial Number' },
      { key: 'manufacturerProductType', label: 'Manufacturer Product Type' },
    ],
  },
  {
    key: 'carbonFootprint',
    title: 'Carbon Footprint',
    fields: [
      { key: 'pcfCO2eq', label: 'PCF CO2eq', type: 'number' },
      { key: 'referenceImpactUnitForCalculation', label: 'Reference Impact Unit for Calculation' },
      {
        key: 'quantityOfMeasureForCalculation',
        label: 'Quantity of Measure for Calculation',
        type: 'number',
      },
      { key: 'publicationDate', label: 'Publication Date', type: 'date' },
      { key: 'expirationDate', label: 'Expiration Date', type: 'date' },
    ],
  },
  {
    key: 'technicalData',
    title: 'Technical Data',
    fields: [
      { key: 'length', label: 'Length', type: 'number' },
      { key: 'width', label: 'Width', type: 'number' },
      { key: 'height', label: 'Height', type: 'number' },
      { key: 'manufacturerName', label: 'Manufacturer Name' },
      { key: 'manufacturerArticleNumber', label: 'Manufacturer Article Number' },
    ],
  },
];

export const SHELL_CREATE_SECTIONS: SectionConfig[] = [
  {
    key: 'nameplate',
    title: 'Nameplate',
    fields: [
      { key: 'name', label: 'Name' },
      { key: 'dateOfManufacture', label: 'Date of Manufacture', type: 'date' },
    ],
  },
  {
    key: 'carbonFootprint',
    title: 'Carbon Footprint',
    fields: [
      { key: 'pcfCO2eq', label: 'PCF CO2eq', type: 'number', suffix: SHELL_CREATE_PCF_UNIT },
    ],
  },
  {
    key: 'technicalData',
    title: 'Technical Data',
    fields: [
      { key: 'manufacturerName', label: 'Manufacturer Name' },
      { key: 'manufacturerArticleNumber', label: 'Manufacturer Article Number' },
    ],
  },
];
