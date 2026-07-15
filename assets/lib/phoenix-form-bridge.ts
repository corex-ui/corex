import {
  syncArrayHiddenInputsForPhoenix,
  type SyncArrayHiddenInputsOptions,
} from "./form-array-submit";
import {
  notifyPhoenixFormChange,
  reapplyLiveViewValueInputUsage,
  syncLiveViewFormInput,
  type NotifyPhoenixFormChangeOptions,
} from "./live-view-form-input";

export {
  PHX_HAS_FOCUSED,
  notifyPhoenixFormChange,
  queueLiveViewFormInputSync,
  reapplyLiveViewValueInputUsage,
  syncLiveViewFormInput,
  type NotifyPhoenixFormChangeOptions,
} from "./live-view-form-input";

export {
  bindArrayFieldSubmitIntent,
  isFormFieldUsed,
  syncArrayHiddenInputsForPhoenix,
  type ArraySubmitScope,
  type SyncArrayHiddenInputsOptions,
} from "./form-array-submit";

export function markUsed(input: HTMLInputElement): void {
  reapplyLiveViewValueInputUsage(input);
}

export function setScalarValue(
  input: HTMLInputElement,
  value: string,
  options: NotifyPhoenixFormChangeOptions = {}
): void {
  notifyPhoenixFormChange(input, value, options);
}

export function setArrayValues(
  el: HTMLElement,
  values: ReadonlyArray<string>,
  options: SyncArrayHiddenInputsOptions = {}
): void {
  syncArrayHiddenInputsForPhoenix(el, values, options);
}

export function syncFormInput(
  input: HTMLInputElement,
  getValue: () => string,
  onTouched?: () => void
): void {
  syncLiveViewFormInput(input, getValue, onTouched);
}
