import { provideHttpClient } from '@angular/common/http';
import { HttpTestingController, provideHttpClientTesting } from '@angular/common/http/testing';
import { TestBed } from '@angular/core/testing';

import { AppConfigService } from '../config/app-config.service';
import {
  EMPTY_SHELL_EDIT_DATA,
  ProductResponse,
  ShellDescriptor,
  ShellEditData,
} from '../models/shell.models';
import { ShellService } from './shell.service';

describe('ShellService API routing', () => {
  let service: ShellService;
  let http: HttpTestingController;
  let data: ShellEditData;
  const created: ProductResponse = {
    productId: '000-001',
    idShort: 'Product',
    aasId: 'https://example.test/aas/000-001',
    globalAssetId: 'https://example.test/assets/000-001',
  };

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [provideHttpClient(), provideHttpClientTesting()],
    });
    service = TestBed.inject(ShellService);
    http = TestBed.inject(HttpTestingController);
    data = structuredClone(EMPTY_SHELL_EDIT_DATA);
    data.nameplate.name = 'Product';
    data.carbonFootprint.pcfCO2eq = '12.5';
  });

  afterEach(() => http.verify());

  it('keeps shell reads on the existing DataEngine API', () => {
    service.getShellDescriptors().subscribe((shells) => expect(shells).toEqual([]));
    const request = http.expectOne('http://localhost:8090/shell-descriptors');
    expect(request.request.method).toBe('GET');
    request.flush({ result: [] });
  });

  it('sends creates only to the plugin backend', () => {
    service.createProduct(data).subscribe((response) => expect(response).toEqual(created));
    const request = http.expectOne(
      '/designer-api/plugin-api/aas-twin-engine-ui/submodel-data/products',
    );
    expect(request.request.method).toBe('POST');
    expect(request.request.body.pcfCO2eq).toBe(12.5);
    expect(request.request.body.name).toBe('Product');
    request.flush(created);
  });

  it('sends updates only to the plugin backend and preserves the payload', () => {
    data.technicalData.length = '10';
    service.updateShellEditData('product/id', data).subscribe();
    const request = http.expectOne(
      '/designer-api/plugin-api/aas-twin-engine-ui/submodel-data/products/product%2Fid',
    );
    expect(request.request.method).toBe('PUT');
    expect(request.request.body.id).toBe('product/id');
    expect(request.request.body.length).toBe('10');
    request.flush(created);
  });

  it('sends deletes only to the plugin backend', () => {
    service.deleteShell('product/id').subscribe();
    const request = http.expectOne(
      '/designer-api/plugin-api/aas-twin-engine-ui/submodel-data/products/product%2Fid',
    );
    expect(request.request.method).toBe('DELETE');
    request.flush(null, { status: 204, statusText: 'No Content' });
  });

  it('sends data resets only to the plugin backend', () => {
    service.resetData().subscribe();
    const request = http.expectOne('/designer-api/plugin-api/aas-twin-engine-ui/submodel-data/reset');
    expect(request.request.method).toBe('POST');
    request.flush(null, { status: 204, statusText: 'No Content' });
  });

  it('uses the configured write URL independently of the read URL', async () => {
    const loading = TestBed.inject(AppConfigService).load();
    http.expectOne('config.json').flush({
      apiBaseUrl: 'https://read.example.test/',
      writeApiBaseUrl: 'https://write.example.test/',
    });
    await loading;
    expect(TestBed.inject(AppConfigService).writeApiBaseUrl).toBe('https://write.example.test');
    expect(TestBed.inject(AppConfigService).apiBaseUrl).toBe('https://read.example.test');
    service.deleteShell('000-001').subscribe();
    http
      .expectOne('https://write.example.test/submodel-data/products/000-001')
      .flush(null, { status: 204, statusText: 'No Content' });
    service.getShellDescriptors().subscribe();
    http.expectOne('https://read.example.test/shell-descriptors').flush({ result: [] });
  });

  it('surfaces backend validation errors without retrying the old API', () => {
    let message = '';
    service.createProduct(data).subscribe({ error: (error: Error) => (message = error.message) });
    http
      .expectOne('/designer-api/plugin-api/aas-twin-engine-ui/submodel-data/products')
      .flush(
        { detail: 'The product name already exists.' },
        { status: 409, statusText: 'Conflict' },
      );
    expect(message).toBe('The product name already exists.');
    http.expectNone((request) => request.url.startsWith('http://localhost:8090/submodel-data'));
  });

  it('reads shells and submodels through the AAS Suite proxy when an infrastructure is configured', async () => {
    const loading = TestBed.inject(AppConfigService).load();
    http.expectOne('config.json').flush({ infrastructureName: 'AAS.TE' });
    await loading;

    let shells: ShellDescriptor[] = [];
    service.getShellDescriptors().subscribe((result) => (shells = result));
    http
      .expectOne('/designer-api/aas-api/aasinfrastructure/getavailableinfrastructures')
      .flush([
        { id: 1, name: 'Template Repository' },
        { id: 3, name: 'AAS.TE' },
      ]);
    const page = http.expectOne('/designer-api/aas-proxy/3/aas-repo/shells?limit=1000');
    expect(page.request.headers.get('X-Infrastructure-ID')).toBe('3');
    page.flush({
      result: [
        {
          id: 'https://example.test/aas/000-001',
          idShort: 'Car',
          assetInformation: { assetKind: 'Instance', globalAssetId: 'https://example.test/assets/000-001' },
          submodels: [{ keys: [{ value: 'https://example.test/submodel/000-001/Nameplate' }] }],
        },
      ],
      paging_metadata: { cursor: 'next' },
    });
    // A repeated page ends the paging instead of looping.
    http
      .expectOne('/designer-api/aas-proxy/3/aas-repo/shells?limit=1000&cursor=next')
      .flush({ result: [{ id: 'https://example.test/aas/000-001' }], paging_metadata: { cursor: 'next' } });

    expect(shells.length).toBe(1);
    expect(shells[0].idShort).toBe('Car');
    expect(shells[0].assetKind).toBe('Instance');
    expect(shells[0].submodelDescriptors).toEqual([
      { id: 'https://example.test/submodel/000-001/Nameplate' },
    ]);

    service.getShellEditData({
      id: 'https://example.test/aas/000-001',
      submodelDescriptors: [
        { id: 'https://example.test/submodel/000-001/Nameplate' },
        { id: 'https://example.test/submodel/000-001/CarbonFootprint' },
        { id: 'https://example.test/submodel/000-001/TechnicalData' },
      ],
    }).subscribe();
    const encoded = (id: string) =>
      btoa(id).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
    for (const name of ['Nameplate', 'CarbonFootprint', 'TechnicalData']) {
      http
        .expectOne(
          `/designer-api/aas-proxy/3/sm-repo/submodels/${encoded(`https://example.test/submodel/000-001/${name}`)}`,
        )
        .flush({ submodelElements: [] });
    }
    http.expectNone((request) => request.url.startsWith('http://localhost:8090'));
  });

  it('sends empty date and number fields as null instead of empty strings', () => {
    data.nameplate.dateOfManufacture = '';
    data.technicalData.length = ' ';
    service.updateShellEditData('000-001', data).subscribe();
    const request = http.expectOne(
      '/designer-api/plugin-api/aas-twin-engine-ui/submodel-data/products/000-001',
    );
    expect(request.request.body.dateOfManufacture).toBeNull();
    expect(request.request.body.length).toBeNull();
    expect(request.request.body.publicationDate).toBeNull();
    request.flush(created);
  });
});
