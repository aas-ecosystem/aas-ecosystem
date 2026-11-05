import {
  HttpClient,
  provideHttpClient,
  withFetch,
  withXsrfConfiguration,
} from '@angular/common/http';
import {
  ApplicationConfig,
  inject,
  provideAppInitializer,
  provideBrowserGlobalErrorListeners,
  provideZoneChangeDetection,
} from '@angular/core';
import { provideRouter } from '@angular/router';
import { firstValueFrom } from 'rxjs';

import { routes } from './app.routes';
import { AppConfigService } from './core/config/app-config.service';

export const appConfig: ApplicationConfig = {
  providers: [
    provideBrowserGlobalErrorListeners(),
    provideZoneChangeDetection({ eventCoalescing: true }),
    provideRouter(routes),
    provideHttpClient(
      withFetch(),
      withXsrfConfiguration({
        cookieName: 'vws-csrf-request',
        headerName: 'X-CSRF-TOKEN',
      }),
    ),
    provideAppInitializer(() => {
      const config = inject(AppConfigService);
      const http = inject(HttpClient);
      return config.load().then(async () => {
        if (config.writeApiBaseUrl.startsWith('/designer-api/')) {
          await firstValueFrom(http.get('/bff/csrf', { responseType: 'text' }));
        }
      });
    }),
  ],
};
