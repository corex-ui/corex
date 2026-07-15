import { notifyPhoenixFormChange, reapplyLiveViewValueInputUsage } from "./live-view-form-input";
import { associateInputWithFormIfOutside, getBoolean, getString } from "./util";

export type ArraySubmitScope =
  | "tags-input"
  | "combobox"
  | "date-picker"
  | "signature-pad"
  | "pin-input";

export type SyncArrayHiddenInputsOptions = {
  onTouched?: () => void;
  scope?: ArraySubmitScope;
  submitName?: string;
  fixedLength?: number;
  notifyLiveView?: boolean;
  fieldTouched?: boolean;
};

export function isFormFieldUsed(el: HTMLElement, userTouched = false): boolean {
  return userTouched || getBoolean(el, "fieldUsed") === true;
}

function padValues(values: ReadonlyArray<string>, fixedLength: number): string[] {
  const out = values.map((v) => String(v));
  while (out.length < fixedLength) out.push("");
  return out.slice(0, fixedLength);
}

function arrayInputId(scope: ArraySubmitScope, hostId: string, index: number | "empty"): string {
  return index === "empty"
    ? `${scope}:${hostId}:array-input-empty`
    : `${scope}:${hostId}:array-input-${index}`;
}

function createArrayInput(
  scope: ArraySubmitScope,
  submitName: string | undefined,
  hostEl: HTMLElement,
  value: string,
  empty: boolean,
  index: number | "empty"
): HTMLInputElement {
  const input = document.createElement("input");
  input.type = "hidden";
  input.id = arrayInputId(scope, hostEl.id, index);
  input.setAttribute("data-scope", scope);
  input.setAttribute("data-part", "array-input");
  if (empty) input.setAttribute("data-empty", "true");
  if (submitName) {
    input.name = submitName;
    associateInputWithFormIfOutside(input, hostEl);
  }
  input.value = value;
  return input;
}

export function syncArrayInputsInPlace(
  container: HTMLElement,
  scope: ArraySubmitScope,
  submitName: string,
  hostEl: HTMLElement,
  values: ReadonlyArray<string>,
  fieldTouched: boolean
): HTMLInputElement | null {
  const existing = Array.from(
    container.querySelectorAll<HTMLInputElement>(`[data-scope="${scope}"][data-part="array-input"]`)
  );

  if (values.length === 0) {
    existing.forEach((node) => node.remove());
    const empty = createArrayInput(
      scope,
      fieldTouched ? submitName : undefined,
      hostEl,
      "",
      true,
      "empty"
    );
    container.appendChild(empty);
    return empty;
  }

  const emptyNodes = existing.filter((n) => n.hasAttribute("data-empty"));
  emptyNodes.forEach((n) => n.remove());

  let valueNodes = existing.filter((n) => !n.hasAttribute("data-empty"));

  while (valueNodes.length < values.length) {
    const input = createArrayInput(scope, submitName, hostEl, "", false, valueNodes.length);
    container.appendChild(input);
    valueNodes = Array.from(
      container.querySelectorAll<HTMLInputElement>(
        `[data-scope="${scope}"][data-part="array-input"]:not([data-empty])`
      )
    );
  }

  while (valueNodes.length > values.length) {
    const last = valueNodes[valueNodes.length - 1];
    last?.remove();
    valueNodes = valueNodes.slice(0, -1);
  }

  valueNodes.forEach((input, index) => {
    input.id = arrayInputId(scope, hostEl.id, index);
    input.value = values[index] ?? "";
  });

  return valueNodes[valueNodes.length - 1] ?? null;
}

export function syncArrayHiddenInputsForPhoenix(
  el: HTMLElement,
  values: ReadonlyArray<string>,
  options: SyncArrayHiddenInputsOptions = {}
): void {
  const scope = options.scope ?? "tags-input";
  const submitName = options.submitName ?? getString(el, "submitName");
  if (!submitName) return;

  const fixedLength = options.fixedLength;
  const normalized =
    fixedLength !== undefined ? padValues(values, fixedLength) : values.map((v) => String(v));
  const fieldTouched = isFormFieldUsed(el, options.fieldTouched === true);

  const container = el.querySelector<HTMLElement>(
    `[data-scope="${scope}"][data-part="array-inputs"]`
  );

  if (!container) return;

  const notifyInput = syncArrayInputsInPlace(
    container,
    scope,
    submitName,
    el,
    normalized,
    fieldTouched
  );

  if (fieldTouched) {
    container
      .querySelectorAll<HTMLInputElement>(
        `[data-scope="${scope}"][data-part="array-input"][name="${CSS.escape(submitName)}"]`
      )
      .forEach((input) => reapplyLiveViewValueInputUsage(input));
  }

  const notifyLiveView = options.notifyLiveView ?? false;

  if (!notifyLiveView || !notifyInput) return;

  options.onTouched?.();
  notifyPhoenixFormChange(notifyInput, notifyInput.value, {
    onTouched: undefined,
    force: true,
  });
}

export function bindArrayFieldSubmitIntent(
  hostEl: HTMLElement,
  onPrepareSubmit: () => void
): () => void {
  const form = hostEl.closest("form");
  if (!form) return () => {};

  const handler = () => {
    onPrepareSubmit();
  };

  form.addEventListener("submit", handler, { capture: true });
  return () => form.removeEventListener("submit", handler, { capture: true });
}
