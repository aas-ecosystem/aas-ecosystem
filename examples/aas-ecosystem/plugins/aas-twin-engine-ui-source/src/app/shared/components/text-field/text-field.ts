import { Component, input } from '@angular/core';
import { FormControl, ReactiveFormsModule } from '@angular/forms';

export type TextFieldType = 'text' | 'number' | 'date';

let nextId = 0;

@Component({
  selector: 'app-text-field',
  imports: [ReactiveFormsModule],
  host: {
    '[class.col-12]': 'fullWidth()',
    '[class.col-md-6]': '!fullWidth()',
    '[class.col-lg-4]': '!fullWidth()',
  },
  templateUrl: './text-field.html',
})
export class TextFieldComponent {
  readonly label = input.required<string>();
  readonly control = input.required<FormControl<string>>();
  readonly type = input<TextFieldType>('text');
  readonly fullWidth = input(false);

  protected readonly id = `text-field-${nextId++}`;
}
