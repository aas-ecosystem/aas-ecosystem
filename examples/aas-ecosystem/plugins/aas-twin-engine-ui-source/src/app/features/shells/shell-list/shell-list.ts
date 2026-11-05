import { Component, DestroyRef, OnInit, inject, signal } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { Observable } from 'rxjs';

import {
  EMPTY_SHELL_EDIT_DATA,
  ShellDescriptor,
  ShellEditData,
} from '../../../core/models/shell.models';
import { ShellService } from '../../../core/services/shell.service';
import { ModalComponent } from '../../../shared/components/modal/modal';
import { ShellEditFormComponent } from '../shell-edit-form/shell-edit-form';
import { ShellTableComponent } from '../shell-table/shell-table';

const PROTECTED_PRODUCT_IDS: ReadonlySet<string> = new Set(['000-001', '000-002']);

// null shell means the form is creating a new product
interface FormState {
  shell: ShellDescriptor | null;
  data: ShellEditData | null;
}

@Component({
  selector: 'app-shell-list',
  imports: [ModalComponent, ShellEditFormComponent, ShellTableComponent],
  templateUrl: './shell-list.html',
})
export class ShellListComponent implements OnInit {
  private readonly shellService = inject(ShellService);
  private readonly destroyRef = inject(DestroyRef);

  protected readonly shells = signal<ShellDescriptor[]>([]);
  protected readonly loading = signal(false);
  protected readonly error = signal<string | null>(null);
  protected readonly formState = signal<FormState | null>(null);
  protected readonly saving = signal(false);
  protected readonly formError = signal<string | null>(null);
  protected readonly pendingDelete = signal<ShellDescriptor | null>(null);
  protected readonly deleting = signal(false);
  protected readonly deleteError = signal<string | null>(null);
  protected readonly resetConfirmOpen = signal(false);
  protected readonly resetting = signal(false);
  protected readonly resetError = signal<string | null>(null);

  ngOnInit(): void {
    this.loadShells();
  }

  protected loadShells(): void {
    this.loading.set(true);
    this.error.set(null);
    this.shellService
      .getShellDescriptors()
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (shells) => {
          this.shells.set(shells);
          this.loading.set(false);
        },
        error: () => {
          this.error.set('Failed to load shells. Check that the API is reachable.');
          this.loading.set(false);
        },
      });
  }

  protected openCreate(): void {
    this.formError.set(null);
    this.formState.set({ shell: null, data: structuredClone(EMPTY_SHELL_EDIT_DATA) });
  }

  protected openEdit(shell: ShellDescriptor): void {
    this.formError.set(null);
    this.formState.set({ shell, data: null });
    this.shellService
      .getShellEditData(shell)
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (data) => this.formState.set({ shell, data }),
        error: (error: unknown) => {
          this.formError.set(
            error instanceof Error ? error.message : 'Failed to load submodel data.',
          );
        },
      });
  }

  protected closeForm(): void {
    this.formState.set(null);
    this.formError.set(null);
  }

  protected openReset(): void {
    this.resetError.set(null);
    this.resetConfirmOpen.set(true);
  }

  protected cancelReset(): void {
    if (this.resetting()) {
      return;
    }

    this.resetConfirmOpen.set(false);
    this.resetError.set(null);
  }

  protected confirmReset(): void {
    this.resetting.set(true);
    this.resetError.set(null);
    this.shellService.resetData().subscribe({
      next: () => {
        this.resetting.set(false);
        this.resetConfirmOpen.set(false);
        this.loadShells();
      },
      error: (error: unknown) => {
        this.resetting.set(false);
        this.resetError.set(error instanceof Error ? error.message : 'Failed to reset data.');
      },
    });
  }

  protected submitForm(shell: ShellDescriptor | null, data: ShellEditData): void {
    const productId = shell ? this.getProductId(shell) : null;
    if (shell && !productId) {
      this.formError.set('Cannot save this product because its product ID is missing.');
      return;
    }

    this.saving.set(true);
    const request$: Observable<unknown> = productId
      ? this.shellService.updateShellEditData(productId, data)
      : this.shellService.createProduct(data);
    request$.subscribe({
      next: () => {
        this.saving.set(false);
        this.closeForm();
        this.loadShells();
      },
      error: (error: unknown) => {
        this.saving.set(false);
        this.formError.set(error instanceof Error ? error.message : 'Failed to save product.');
      },
    });
  }

  private getProductId(shell: ShellDescriptor): string | null {
    const productId = shell.productId?.trim();
    if (productId) {
      return productId;
    }

    const identifierSegments = shell.id.split('/').filter(Boolean);
    return identifierSegments[identifierSegments.length - 1] ?? null;
  }

  protected canDelete(shell: ShellDescriptor): boolean {
    const productId = this.getProductId(shell);
    return !!productId && !PROTECTED_PRODUCT_IDS.has(productId);
  }

  protected requestDeleteFromForm(shell: ShellDescriptor): void {
    if (this.saving()) {
      return;
    }

    this.closeForm();
    this.openDelete(shell);
  }

  protected openDelete(shell: ShellDescriptor): void {
    this.deleteError.set(null);
    this.pendingDelete.set(shell);
  }

  protected cancelDelete(): void {
    if (this.deleting()) {
      return;
    }

    this.pendingDelete.set(null);
    this.deleteError.set(null);
  }

  protected confirmDelete(shell: ShellDescriptor): void {
    const productId = this.getProductId(shell);
    if (!productId) {
      this.deleteError.set('Cannot delete this product because its product ID is missing.');
      return;
    }

    if (PROTECTED_PRODUCT_IDS.has(productId)) {
      this.deleteError.set('This product is protected and cannot be deleted.');
      return;
    }

    this.deleting.set(true);
    this.deleteError.set(null);
    this.shellService.deleteShell(productId).subscribe({
      next: () => {
        this.deleting.set(false);
        this.shells.update((list) => list.filter((item) => item.id !== shell.id));
        this.pendingDelete.set(null);
      },
      error: (error: unknown) => {
        this.deleting.set(false);
        this.deleteError.set(error instanceof Error ? error.message : 'Failed to delete product.');
      },
    });
  }
}
