import { HttpClient } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { firstValueFrom } from 'rxjs';

export interface AppConfig {
  apiBaseUrl: string;
  writeApiBaseUrl: string;
  /**
   * Name of the TwinEngine infrastructure in the AAS Suite. When set, reads go through the
   * AAS Suite proxy (login and infrastructure rights apply) instead of directly to apiBaseUrl.
   */
  infrastructureName?: string;
  designerApiBaseUrl: string;
}

@Injectable({ providedIn: 'root' })
export class AppConfigService {
  private readonly http = inject(HttpClient);
  private config: AppConfig = {
    apiBaseUrl: 'http://localhost:8090',
    writeApiBaseUrl: '/designer-api/plugin-api/aas-twin-engine-ui',
    designerApiBaseUrl: '/designer-api',
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

  get infrastructureName(): string | null {
    return this.config.infrastructureName?.trim() || null;
  }

  get designerApiBaseUrl(): string {
    return this.config.designerApiBaseUrl.replace(/\/+$/, '');
  }
}
