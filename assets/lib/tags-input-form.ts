import { getString } from "./util";

export function syncTagsArrayInputsForPhoenix(
  el: HTMLElement,
  values: ReadonlyArray<string>,
  onTouched?: () => void
): void {
  const submitName = getString(el, "submitName");
  if (!submitName) return;

  const form = getString(el, "form");
  let container = el.querySelector<HTMLElement>(
    '[data-scope="tags-input"][data-part="array-inputs"]'
  );

  if (!container) {
    const root = el.querySelector<HTMLElement>('[data-scope="tags-input"][data-part="root"]') ?? el;
    container = document.createElement("div");
    container.setAttribute("data-scope", "tags-input");
    container.setAttribute("data-part", "array-inputs");
    container.setAttribute("phx-update", "ignore");
    container.id = `tags-input:${el.id}:array-inputs`;
    root.prepend(container);
  }

  container.replaceChildren();

  values.forEach((value) => {
    const input = document.createElement("input");
    input.type = "hidden";
    input.setAttribute("data-scope", "tags-input");
    input.setAttribute("data-part", "array-input");
    input.name = submitName;
    if (form) input.setAttribute("form", form);
    input.value = String(value);
    container!.appendChild(input);
  });

  queueMicrotask(() => {
    onTouched?.();
    container!.dispatchEvent(new Event("input", { bubbles: true }));
    container!.dispatchEvent(new Event("change", { bubbles: true }));
  });
}

export function syncTagsInputFormForPhoenix(
  el: HTMLElement,
  values: ReadonlyArray<string>,
  onTouched?: () => void
): void {
  syncTagsArrayInputsForPhoenix(el, values, onTouched);
}
