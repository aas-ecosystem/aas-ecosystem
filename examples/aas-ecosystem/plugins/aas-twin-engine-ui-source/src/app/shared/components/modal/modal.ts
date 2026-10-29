import { Component, computed, input, output } from '@angular/core';

@Component({
  selector: 'app-modal',
  host: { '(document:keydown.escape)': 'closed.emit()' },
  templateUrl: './modal.html',
  styleUrl: './modal.scss',
})
export class ModalComponent {
  readonly title = input.required<string>();
  readonly size = input<'sm' | 'lg' | 'xl'>('lg');
  readonly closed = output<void>();

  protected readonly sizeClass = computed(() => `modal-${this.size()}`);

  protected onOutsideClick(event: MouseEvent): void {
    if (event.target === event.currentTarget) {
      this.closed.emit();
    }
  }
}
