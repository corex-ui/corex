import {
  notifyPhoenixFormChange,
  reapplyLiveViewValueInputUsage
} from "./chunk-VMKNATWC.mjs";
import {
  associateInputWithFormIfOutside,
  getBoolean,
  getString
} from "./chunk-2GQRP3FN.mjs";

// lib/form-array-submit.ts
function isFormFieldUsed(el, userTouched = false) {
  return userTouched || getBoolean(el, "fieldUsed") === true;
}
function padValues(values, fixedLength) {
  const out = values.map((v) => String(v));
  while (out.length < fixedLength) out.push("");
  return out.slice(0, fixedLength);
}
function createArrayInput(scope, submitName, hostEl, value, empty) {
  const input = document.createElement("input");
  input.type = "hidden";
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
function syncArrayInputsInPlace(container, scope, submitName, hostEl, values, fieldTouched) {
  const existing = Array.from(
    container.querySelectorAll(`[data-scope="${scope}"][data-part="array-input"]`)
  );
  if (values.length === 0) {
    existing.forEach((node) => node.remove());
    const empty = createArrayInput(scope, fieldTouched ? submitName : void 0, hostEl, "", true);
    container.appendChild(empty);
    return empty;
  }
  const emptyNodes = existing.filter((n) => n.hasAttribute("data-empty"));
  emptyNodes.forEach((n) => n.remove());
  let valueNodes = existing.filter((n) => !n.hasAttribute("data-empty"));
  while (valueNodes.length < values.length) {
    const input = createArrayInput(scope, submitName, hostEl, "", false);
    container.appendChild(input);
    valueNodes = Array.from(
      container.querySelectorAll(
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
    input.value = values[index] ?? "";
  });
  return valueNodes[valueNodes.length - 1] ?? null;
}
function syncArrayHiddenInputsForPhoenix(el, values, options = {}) {
  const scope = options.scope ?? "tags-input";
  const submitName = options.submitName ?? getString(el, "submitName");
  if (!submitName) return;
  const fixedLength = options.fixedLength;
  const normalized = fixedLength !== void 0 ? padValues(values, fixedLength) : values.map((v) => String(v));
  const fieldTouched = isFormFieldUsed(el, options.fieldTouched === true);
  let container = el.querySelector(
    `[data-scope="${scope}"][data-part="array-inputs"]`
  );
  if (!container) {
    const root = el.querySelector(`[data-scope="${scope}"][data-part="root"]`) ?? el;
    container = document.createElement("div");
    container.setAttribute("data-scope", scope);
    container.setAttribute("data-part", "array-inputs");
    container.setAttribute("phx-update", "ignore");
    container.id = `${scope}:${el.id}:array-inputs`;
    root.prepend(container);
  }
  const notifyInput = syncArrayInputsInPlace(
    container,
    scope,
    submitName,
    el,
    normalized,
    fieldTouched
  );
  if (fieldTouched) {
    container.querySelectorAll(
      `[data-scope="${scope}"][data-part="array-input"][name="${CSS.escape(submitName)}"]`
    ).forEach((input) => reapplyLiveViewValueInputUsage(input));
  }
  const notifyLiveView = options.notifyLiveView ?? false;
  if (!notifyLiveView || !notifyInput) return;
  queueMicrotask(() => {
    options.onTouched?.();
    notifyPhoenixFormChange(notifyInput, notifyInput.value, { onTouched: void 0 });
  });
}
function bindArrayFieldSubmitIntent(hostEl, onPrepareSubmit) {
  const form = hostEl.closest("form");
  if (!form) return () => {
  };
  const handler = () => {
    onPrepareSubmit();
  };
  form.addEventListener("submit", handler, { capture: true });
  return () => form.removeEventListener("submit", handler, { capture: true });
}

export {
  isFormFieldUsed,
  syncArrayHiddenInputsForPhoenix,
  bindArrayFieldSubmitIntent
};
