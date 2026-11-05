import { BrowserPlatformLocation, DOCUMENT, PlatformLocation } from '@angular/common';
import { HttpClient } from '@angular/common/http';
import { HttpTestingController, provideHttpClientTesting } from '@angular/common/http/testing';
import { ApplicationInitStatus } from '@angular/core';
import { TestBed } from '@angular/core/testing';

import { appConfig } from '../../app.config';

describe('Gateway CSRF configuration', () => {
  let http: HttpTestingController;
  let client: HttpClient;
  let document: Document;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [
        ...appConfig.providers,
        provideHttpClientTesting(),
        { provide: PlatformLocation, useClass: BrowserPlatformLocation },
      ],
    });
    http = TestBed.inject(HttpTestingController);
    client = TestBed.inject(HttpClient);
    document = TestBed.inject(DOCUMENT);
    document.cookie = 'vws-csrf-request=; Max-Age=0; Path=/';
  });

  afterEach(() => {
    document.cookie = 'vws-csrf-request=; Max-Age=0; Path=/';
    http.verify();
  });

  async function initialize(writeApiBaseUrl = '/designer-api/plugin-api/aas-twin-engine-ui') {
    http.expectOne('config.json').flush({
      apiBaseUrl: 'http://localhost:8090',
      writeApiBaseUrl,
    });
    await Promise.resolve();
    await Promise.resolve();
    if (writeApiBaseUrl.startsWith('/designer-api/')) {
      const csrf = http.expectOne('/bff/csrf');
      expect(csrf.request.method).toBe('GET');
      expect(csrf.request.headers.has('X-CSRF-TOKEN')).toBeFalse();
      csrf.flush(null, { status: 204, statusText: 'No Content' });
    } else {
      http.expectNone('/bff/csrf');
    }
    await TestBed.inject(ApplicationInitStatus).donePromise;
  }

  it('bootstraps the gateway cookie after loading hosted configuration', async () => {
    await initialize();
    expect(TestBed.inject(ApplicationInitStatus).done).toBeTrue();
  });

  it('does not request a gateway cookie for standalone backend configuration', async () => {
    await initialize('http://localhost:5085');
    http.expectNone('/bff/csrf');
    expect(TestBed.inject(HttpClient)).toBe(client);
  });

  for (const method of ['POST', 'PUT', 'PATCH', 'DELETE']) {
    it(`sends the gateway request token with same-origin ${method}`, async () => {
      await initialize();
      document.cookie = 'vws-csrf-request=test%2Btoken; Path=/';
      client
        .request(method, '/designer-api/plugin-api/aas-twin-engine-ui/submodel-data/products')
        .subscribe();
      const request = http.expectOne(
        '/designer-api/plugin-api/aas-twin-engine-ui/submodel-data/products',
      );
      expect(request.request.headers.get('X-CSRF-TOKEN')).toBe('test+token');
      request.flush({});
    });
  }

  it('does not leak the token to external read or write APIs', async () => {
    await initialize();
    document.cookie = 'vws-csrf-request=private-token; Path=/';
    client.post('https://external.example.test/products', {}).subscribe();
    const request = http.expectOne('https://external.example.test/products');
    expect(request.request.headers.has('X-CSRF-TOKEN')).toBeFalse();
    request.flush({});
  });

  it('does not attach the write token to GET requests', async () => {
    await initialize();
    document.cookie = 'vws-csrf-request=private-token; Path=/';
    client.get('/bff/csrf').subscribe();
    const request = http.expectOne('/bff/csrf');
    expect(request.request.headers.has('X-CSRF-TOKEN')).toBeFalse();
    request.flush(null, { status: 204, statusText: 'No Content' });
  });
});
