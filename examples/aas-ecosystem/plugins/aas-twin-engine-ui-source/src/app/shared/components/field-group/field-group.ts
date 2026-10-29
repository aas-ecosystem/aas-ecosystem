import { Component, input } from '@angular/core';

@Component({
  selector: 'app-field-group',
  templateUrl: './field-group.html',
})
export class FieldGroupComponent {
  readonly legend = input.required<string>();
}
