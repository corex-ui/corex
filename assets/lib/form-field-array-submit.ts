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
    const node = el.querySelector<HTMLElement>(`[data-scope="${scope}"][data-part="${part}"]`);
    if (!node) continue;
    node.removeAttribute("name");
    node.removeAttribute("form");
  }
}
