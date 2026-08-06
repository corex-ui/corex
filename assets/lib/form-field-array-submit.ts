import type { ArraySubmitScope } from "./form-array-submit";
import { getString } from "./util";

export function hasArraySubmitName(el: HTMLElement): boolean {
  return getString(el, "submitName") !== undefined;
}

export function stripZagSubmitNames(
  el: HTMLElement,
  scope: ArraySubmitScope,
  parts: ReadonlyArray<"hidden-input" | "input"> = ["hidden-input"]
): void {
  if (!hasArraySubmitName(el)) return;

  for (const part of parts) {
    el.querySelectorAll<HTMLElement>(`[data-scope="${scope}"][data-part="${part}"]`).forEach(
      (node) => {
        node.removeAttribute("name");
        node.removeAttribute("form");
      }
    );
  }
}
