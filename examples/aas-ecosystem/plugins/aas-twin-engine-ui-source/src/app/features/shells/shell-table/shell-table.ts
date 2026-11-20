import { Component, input, output } from '@angular/core';

import { ShellDescriptor } from '../../../core/models/shell.models';

@Component({
  selector: 'app-shell-table',
  templateUrl: './shell-table.html',
})
export class ShellTableComponent {
  readonly shells = input.required<ShellDescriptor[]>();
  readonly showViewer = input(false);
  readonly edit = output<ShellDescriptor>();
  readonly view = output<ShellDescriptor>();
}
