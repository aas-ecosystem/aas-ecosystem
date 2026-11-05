import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { Observable, catchError, defer, forkJoin, map, throwError } from 'rxjs';

import { AppConfigService } from '../config/app-config.service';
import {
  AddressInformation,
  CarbonFootprintData,
  EMPTY_SHELL_EDIT_DATA,
  NameplateData,
  ProductRequest,
  ProductResponse,
  ProductUpdateRequest,
  ShellDescriptor,
  ShellDescriptorResponse,
  ShellEditData,
  SubmodelDescriptor,
  TechnicalDataData,
} from '../models/shell.models';

@Injectable({ providedIn: 'root' })
export class ShellService {
  private readonly http = inject(HttpClient);
  private readonly config = inject(AppConfigService);

  getShellDescriptors(): Observable<ShellDescriptor[]> {
    return this.http
      .get<ShellDescriptorResponse>(`${this.config.apiBaseUrl}/shell-descriptors`)
      .pipe(map((response) => response.result ?? []));
  }

  getShellEditData(shell: ShellDescriptor): Observable<ShellEditData> {
    return defer(() => {
      const submodels = {
        nameplate: this.findSubmodel(shell, 'nameplate'),
        carbonFootprint: this.findSubmodel(shell, 'carbonfootprint'),
        technicalData: this.findSubmodel(shell, 'technicaldata'),
      };

      return forkJoin({
        nameplate: this.getSubmodelData(submodels.nameplate),
        carbonFootprint: this.getSubmodelData(submodels.carbonFootprint),
        technicalData: this.getSubmodelData(submodels.technicalData),
      }).pipe(
        map(({ nameplate, carbonFootprint, technicalData }) => ({
          nameplate: this.toNameplateData(nameplate),
          carbonFootprint: this.toCarbonFootprintData(carbonFootprint),
          technicalData: this.toTechnicalData(technicalData),
        })),
      );
    });
  }

  createProduct(data: ShellEditData): Observable<ProductResponse> {
    return defer(() =>
      this.http.post<ProductResponse>(
        `${this.config.writeApiBaseUrl}/submodel-data/products`,
        this.toProductRequest(data),
      ),
    ).pipe(catchError((error: unknown) => this.handleWriteError(error)));
  }

  updateShellEditData(id: string, data: ShellEditData): Observable<ProductResponse> {
    return defer(() =>
      this.http.put<ProductResponse>(
        `${this.config.writeApiBaseUrl}/submodel-data/products/${encodeURIComponent(id)}`,
        this.toProductUpdateRequest(id, data),
      ),
    ).pipe(catchError((error: unknown) => this.handleWriteError(error)));
  }

  deleteShell(productId: string): Observable<void> {
    return this.http
      .delete<void>(
        `${this.config.writeApiBaseUrl}/submodel-data/products/${encodeURIComponent(productId)}`,
      )
      .pipe(catchError((error: unknown) => this.handleWriteError(error)));
  }

  resetData(): Observable<void> {
    return this.http
      .post<void>(`${this.config.writeApiBaseUrl}/submodel-data/reset`, null)
      .pipe(catchError((error: unknown) => this.handleWriteError(error)));
  }

  private handleWriteError(error: unknown): Observable<never> {
    if (error instanceof HttpErrorResponse) {
      const body = this.asRecord(error.error);
      const detail = body?.['detail'];
      if (typeof detail === 'string' && detail.trim()) {
        return throwError(() => new Error(detail));
      }
    }

    return throwError(() => error);
  }

  private toProductRequest(data: ShellEditData): ProductRequest {
    const rawPcfCO2eq = data.carbonFootprint.pcfCO2eq.trim();
    const pcfCO2eq = Number(rawPcfCO2eq);
    if (!rawPcfCO2eq || !Number.isFinite(pcfCO2eq)) {
      throw new Error('PCF CO2eq must be a valid number.');
    }

    return {
      name: data.nameplate.name,
      dateOfManufacture: data.nameplate.dateOfManufacture,
      manufacturerName: data.technicalData.manufacturerName,
      manufacturerArticleNumber: data.technicalData.manufacturerArticleNumber,
      pcfCO2eq,
      referenceImpactUnitForCalculation: data.carbonFootprint.referenceImpactUnitForCalculation,
    };
  }

  private toProductUpdateRequest(id: string, data: ShellEditData): ProductUpdateRequest {
    return {
      id,
      ...this.toProductRequest(data),
      addressInformation: { ...data.nameplate.addressInformation },
      serialNumber: data.nameplate.serialNumber,
      manufacturerProductType: data.nameplate.manufacturerProductType,
      quantityOfMeasureForCalculation: data.carbonFootprint.quantityOfMeasureForCalculation,
      publicationDate: data.carbonFootprint.publicationDate,
      expirationDate: data.carbonFootprint.expirationDate,
      length: data.technicalData.length,
      width: data.technicalData.width,
      height: data.technicalData.height,
    };
  }

  private findSubmodel(shell: ShellDescriptor, name: string): SubmodelDescriptor {
    const descriptor = shell.submodelDescriptors?.find((submodel) =>
      [submodel.idShort, submodel.id, ...(submodel.semanticId?.keys ?? []).map((key) => key.value)]
        .filter((value): value is string => Boolean(value))
        .some((value) =>
          value
            .toLowerCase()
            .replace(/[^a-z]/g, '')
            .includes(name),
        ),
    );

    if (!descriptor) {
      throw new Error(`The ${name} submodel is missing from this shell descriptor.`);
    }

    return descriptor;
  }

  private getSubmodelData(descriptor: SubmodelDescriptor): Observable<unknown> {
    const href = descriptor.endpoints?.[0]?.protocolInformation?.href;
    const id = descriptor.id;
    if (!href && !id) {
      return throwError(() => new Error('A submodel descriptor has no endpoint or identifier.'));
    }

    const url = href
      ? new URL(href, `${this.config.apiBaseUrl}/`).toString()
      : `${this.config.apiBaseUrl}/submodels/${encodeURIComponent(id!)}`;

    return this.http.get<unknown>(url);
  }

  private getElementValues(response: unknown, section: keyof ShellEditData): Map<string, string> {
    const body = this.asRecord(response);
    const result = this.asRecord(body?.['result']) ?? body;
    const elements = result?.['submodelElements'];
    if (!Array.isArray(elements)) {
      throw new Error(`The ${section} submodel response has no submodelElements array.`);
    }

    const values = new Map<string, string>();
    this.collectElementValues(elements, values);
    return values;
  }

  private toNameplateData(response: unknown): NameplateData {
    const values = this.getElementValues(response, 'nameplate');
    const addressInformation: AddressInformation = {
      street: values.get('street') ?? '',
      zipcode: values.get('zipcode') ?? '',
      cityTown: values.get('citytown') ?? '',
      nationalCode: values.get('nationalcode') ?? '',
    };

    return {
      ...EMPTY_SHELL_EDIT_DATA.nameplate,
      addressInformation,
      name:
        values.get('name') ??
        values.get('manufacturerproductdesignation') ??
        values.get('productdesignation') ??
        '',
      dateOfManufacture: values.get('dateofmanufacture') ?? '',
      serialNumber: values.get('serialnumber') ?? '',
      manufacturerProductType: values.get('manufacturerproducttype') ?? '',
    };
  }

  private toCarbonFootprintData(response: unknown): CarbonFootprintData {
    const values = this.getElementValues(response, 'carbonFootprint');

    return {
      ...EMPTY_SHELL_EDIT_DATA.carbonFootprint,
      pcfCO2eq: values.get('pcfco2eq') ?? '',
      referenceImpactUnitForCalculation: values.get('referenceimpactunitforcalculation') ?? '',
      quantityOfMeasureForCalculation: values.get('quantityofmeasureforcalculation') ?? '',
      publicationDate: this.toDateInput(values.get('publicationdate')),
      expirationDate: this.toDateInput(values.get('expirationdate')),
    };
  }

  private toTechnicalData(response: unknown): TechnicalDataData {
    const values = this.getElementValues(response, 'technicalData');

    return {
      ...EMPTY_SHELL_EDIT_DATA.technicalData,
      length: values.get('length') ?? '',
      width: values.get('width') ?? '',
      height: values.get('height') ?? '',
      manufacturerName: values.get('manufacturername') ?? '',
      manufacturerArticleNumber: values.get('manufacturerarticlenumber') ?? '',
    };
  }

  private collectElementValues(elements: unknown[], values: Map<string, string>): void {
    for (const element of elements) {
      const record = this.asRecord(element);
      if (!record) {
        continue;
      }

      const idShort = record['idShort'];
      const value = record['value'];
      if (typeof idShort === 'string') {
        const key = idShort.toLowerCase().replace(/[^a-z0-9]/g, '');
        const elementValue = this.toElementValue(value);
        if (elementValue !== undefined) {
          values.set(key, elementValue);
        }
      }

      this.collectNestedElements(value, values);
    }
  }

  private toElementValue(value: unknown): string | undefined {
    if (typeof value === 'string' || typeof value === 'number') {
      return String(value);
    }

    const languageValues = Array.isArray(value) ? value : [value];
    const englishValue = languageValues
      .map((item) => this.asRecord(item))
      .find((item) => {
        const language = item?.['language'];
        return typeof language === 'string' && language.toLowerCase().split(/[-_]/)[0] === 'en';
      });
    const text = englishValue?.['text'];
    return typeof text === 'string' ? text : undefined;
  }

  private collectNestedElements(value: unknown, values: Map<string, string>): void {
    if (Array.isArray(value)) {
      for (const item of value) {
        this.collectNestedElements(item, values);
      }
      return;
    }

    const record = this.asRecord(value);
    if (!record || ('language' in record && 'text' in record)) {
      return;
    }

    if (typeof record['idShort'] === 'string') {
      this.collectElementValues([record], values);
      return;
    }

    for (const nestedValue of Object.values(record)) {
      this.collectNestedElements(nestedValue, values);
    }
  }

  private toDateInput(value: string | undefined): string {
    return value?.split('T')[0] ?? '';
  }

  private asRecord(value: unknown): Record<string, unknown> | undefined {
    return value !== null && typeof value === 'object' && !Array.isArray(value)
      ? (value as Record<string, unknown>)
      : undefined;
  }
}
