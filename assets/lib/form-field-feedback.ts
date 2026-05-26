import { getBoolean } from "./util";

export function isCorexFormField(el: HTMLElement): boolean {
  return getBoolean(el, "formField");
}

export function setHostDataInvalid(el: HTMLElement, invalid: boolean): void {
  if (invalid) {
    el.setAttribute("data-invalid", "");
  } else {
    el.removeAttribute("data-invalid");
  }
}

export function setScopeErrorsVisible(el: HTMLElement, scope: string, visible: boolean): void {
  el.querySelectorAll<HTMLElement>(`[data-scope="${scope}"][data-part="error"]`).forEach((node) => {
    node.hidden = !visible;
  });
}

export function clearCorexFormFieldFeedback(el: HTMLElement, scope: string): void {
  setHostDataInvalid(el, false);
  setScopeErrorsVisible(el, scope, false);
}

export function hasCorexFormFieldValue(value: string | null | undefined): boolean {
  return value != null && value !== "";
}
