import { Routes } from '@angular/router';

export const routes: Routes = [
  { path: '', pathMatch: 'full', redirectTo: 'shells' },
  {
    path: 'shells',
    loadComponent: () =>
      import('./features/shells/shell-list/shell-list').then((m) => m.ShellListComponent),
  },
  { path: '**', redirectTo: 'shells' },
];
