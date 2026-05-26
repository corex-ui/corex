import { syncInputFormAssociation } from "./util";

export function hiddenInputPropsWithoutChecked(
  props: Record<string, unknown>
): Record<string, unknown> {
  const rest = { ...props };
  delete rest.defaultChecked;
  delete rest.checked;
  return rest;
}

export function syncCheckableHiddenInput(
  inputEl: HTMLInputElement,
  hostEl: HTMLElement,
  checked: boolean,
  spreadProps: (el: HTMLElement, props: Record<string, unknown>) => void,
  hiddenInputProps: Record<string, unknown>
): void {
  spreadProps(inputEl, hiddenInputPropsWithoutChecked(hiddenInputProps));
  inputEl.checked = checked;
  syncInputFormAssociation(inputEl, hostEl);
}
