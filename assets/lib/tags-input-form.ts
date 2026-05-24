import { associateInputWithFormIfOutside, getString } from "./util";

export function syncTagsArrayInputsForPhoenix(
  el: HTMLElement,
  values: ReadonlyArray<string>,
  onTouched?: () => void
): void {
  const submitName = getString(el, "submitName");
  if (!submitName) return;

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

  let notifyInput: HTMLInputElement | null = null;

  if (values.length === 0) {
    const empty = document.createElement("input");
    empty.type = "hidden";
    empty.setAttribute("data-scope", "tags-input");
    empty.setAttribute("data-part", "array-input");
    empty.setAttribute("data-empty", "true");
    empty.name = submitName;
    associateInputWithFormIfOutside(empty, el);
    empty.value = "";
    container.appendChild(empty);
    notifyInput = empty;
  } else {
    values.forEach((value, index) => {
      const input = document.createElement("input");
      input.type = "hidden";
      input.setAttribute("data-scope", "tags-input");
      input.setAttribute("data-part", "array-input");
      input.name = submitName;
      associateInputWithFormIfOutside(input, el);
      input.value = String(value);
      container!.appendChild(input);
      notifyInput = input;
    });
  }

  queueMicrotask(() => {
    onTouched?.();
    if (!notifyInput) return;
    notifyInput.dispatchEvent(new Event("input", { bubbles: true }));
    notifyInput.dispatchEvent(new Event("change", { bubbles: true }));
  });
}

export function syncTagsInputFormForPhoenix(
  el: HTMLElement,
  values: ReadonlyArray<string>,
  onTouched?: () => void
): void {
  syncTagsArrayInputsForPhoenix(el, values, onTouched);
}
