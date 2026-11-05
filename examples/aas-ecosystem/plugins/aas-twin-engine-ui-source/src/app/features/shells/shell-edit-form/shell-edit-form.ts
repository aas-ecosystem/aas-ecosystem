import { Component, computed, input, output } from '@angular/core';
import { AbstractControl, FormControl, FormGroup, ReactiveFormsModule } from '@angular/forms';

import { ShellEditData } from '../../../core/models/shell.models';
import { FieldGroupComponent } from '../../../shared/components/field-group/field-group';
import { TextFieldComponent } from '../../../shared/components/text-field/text-field';
import {
  SHELL_CREATE_PCF_UNIT,
  SHELL_CREATE_SECTIONS,
  SHELL_EDIT_SECTIONS,
} from './shell-edit.fields';

@Component({
  selector: 'app-shell-edit-form',
  imports: [ReactiveFormsModule, FieldGroupComponent, TextFieldComponent],
  templateUrl: './shell-edit-form.html',
})
export class ShellEditFormComponent {
  readonly data = input.required<ShellEditData>();
  readonly creationMode = input(false);
  readonly saving = input(false);
  readonly submitLabel = input('Save');
  readonly save = output<ShellEditData>();
  readonly cancelled = output<void>();

  protected readonly sections = computed(() =>
    this.creationMode() ? SHELL_CREATE_SECTIONS : SHELL_EDIT_SECTIONS,
  );
  protected readonly form = computed(() => {
    const data = this.data();
    return toFormGroup(
      this.creationMode()
        ? {
            ...data,
            carbonFootprint: {
              ...data.carbonFootprint,
              referenceImpactUnitForCalculation: SHELL_CREATE_PCF_UNIT,
            },
          }
        : data,
    );
  });

  protected control(...path: string[]): FormControl<string> {
    return this.form().get(path) as FormControl<string>;
  }

  protected toValue(): ShellEditData {
    return this.form().getRawValue() as ShellEditData;
  }
}

function toFormGroup(value: object): FormGroup {
  const controls: Record<string, AbstractControl> = {};
  for (const [key, item] of Object.entries(value)) {
    controls[key] =
      item !== null && typeof item === 'object'
        ? toFormGroup(item)
        : new FormControl(String(item ?? ''), { nonNullable: true });
  }
  return new FormGroup(controls);
}
