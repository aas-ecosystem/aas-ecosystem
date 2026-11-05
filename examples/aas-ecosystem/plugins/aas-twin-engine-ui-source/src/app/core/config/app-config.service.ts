import { HttpClient } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { firstValueFrom } from 'rxjs';

export interface AppConfig {
  apiBaseUrl: string;
  writeApiBaseUrl: string;
}

@Injectable({ providedIn: 'root' })
export class AppConfigService {
  private readonly http = inject(HttpClient);
  private config: AppConfig = {
    apiBaseUrl: 'http://localhost:8090',
    writeApiBaseUrl: '/designer-api/plugin-api/aas-twin-engine-ui',
  };

  async load(): Promise<void> {
    try {
      const config = await firstValueFrom(this.http.get<AppConfig>('config.json'));
      this.config = { ...this.config, ...config };
    } catch {
      console.warn('config.json could not be loaded, using default configuration.');
    }
  }

  get apiBaseUrl(): string {
    return this.config.apiBaseUrl.replace(/\/+$/, '');
  }

  get writeApiBaseUrl(): string {
    return this.config.writeApiBaseUrl.replace(/\/+$/, '');
  }
}
