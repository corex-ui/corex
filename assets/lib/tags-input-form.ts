import { setArrayValues } from "./phoenix-form-bridge";

export function syncTagsArrayInputsForPhoenix(
  el: HTMLElement,
  values: ReadonlyArray<string>,
  onTouched?: () => void,
  opts: { notifyLiveView?: boolean; fieldTouched?: boolean } = {}
): void {
  setArrayValues(el, values, {
    onTouched,
    scope: "tags-input",
    notifyLiveView: opts.notifyLiveView,
    fieldTouched: opts.fieldTouched === true,
  });
}

export function syncTagsInputFormForPhoenix(
  el: HTMLElement,
  values: ReadonlyArray<string>,
  onTouched?: () => void,
  opts: { notifyLiveView?: boolean; fieldTouched?: boolean } = {}
): void {
  syncTagsArrayInputsForPhoenix(el, values, onTouched, opts);
}
