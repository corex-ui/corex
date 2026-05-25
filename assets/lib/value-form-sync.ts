import { syncInputFormAssociation } from "./util";

export function hiddenInputPropsWithoutValue(
  props: Record<string, unknown>
): Record<string, unknown> {
  const rest = { ...props };
  delete rest.defaultValue;
  delete rest.value;
  return rest;
}

export function syncHiddenInputValue(
  inputEl: HTMLInputElement,
  hostEl: HTMLElement,
  value: string,
  spreadProps: (el: HTMLElement, props: Record<string, unknown>) => void,
  hiddenProps: Record<string, unknown>
): void {
  if (Object.keys(hiddenProps).length > 0) {
    spreadProps(inputEl, hiddenInputPropsWithoutValue(hiddenProps));
  }
  inputEl.value = value;
  syncInputFormAssociation(inputEl, hostEl);
}
