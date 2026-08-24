import {
  associateInputWithFormIfOutside,
  getBoolean,
  getString,
  syncInputFormAssociation
} from "./chunk-6L36XW7I.mjs";

// lib/live-view-form-input.ts
var PHX_HAS_FOCUSED = "phx-has-focused";
function reapplyLiveViewValueInputUsage(input) {
  const p = input;
  if (!p.phxPrivate) p.phxPrivate = {};
  p.phxPrivate[PHX_HAS_FOCUSED] = true;
}
function dispatchFormInputEvents(input, options = {}) {
  input.dispatchEvent(new Event("input", { bubbles: true }));
  if (options.change !== false) {
    input.dispatchEvent(new Event("change", { bubbles: true }));
  }
}
function syncCheckedHiddenInput(input, checked, options = {}) {
  input.checked = checked;
  if (options.markUsed !== false) {
    reapplyLiveViewValueInputUsage(input);
  }
  dispatchFormInputEvents(input, options);
}
function notifyPhoenixFormChange(input, value, options = {}) {
  const next = String(value);
  const unchanged = String(input.value) === next;
  if (!unchanged) {
    input.value = next;
  }
  if (input.getAttribute("value") !== next) {
    input.setAttribute("value", next);
  }
  if (unchanged && options.force !== true) {
    return;
  }
  options.onTouched?.();
  if (options.markUsed !== false) {
    reapplyLiveViewValueInputUsage(input);
  }
  if (options.dispatch === false) {
    return;
  }
  dispatchFormInputEvents(input, { change: options.change });
}
function syncLiveViewFormInput(input, getValue, onTouched) {
  notifyPhoenixFormChange(input, getValue(), { onTouched });
}

// lib/form-array-submit.ts
function isFormFieldUsed(el, userTouched = false) {
  return userTouched || getBoolean(el, "fieldUsed") === true;
}
function padValues(values, fixedLength) {
  const out = values.map((v) => String(v));
  while (out.length < fixedLength) out.push("");
  return out.slice(0, fixedLength);
}
function arrayInputId(scope, hostId, index) {
  return index === "empty" ? `${scope}:${hostId}:array-input-empty` : `${scope}:${hostId}:array-input-${index}`;
}
function createArrayInput(scope, submitName, hostEl, value, empty, index) {
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
function syncArrayInputsInPlace(container, scope, submitName, hostEl, values, fieldTouched) {
  const existing = Array.from(
    container.querySelectorAll(`[data-scope="${scope}"][data-part="array-input"]`)
  );
  if (values.length === 0) {
    existing.forEach((node) => node.remove());
    const empty = createArrayInput(
      scope,
      fieldTouched ? submitName : void 0,
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
    const input = createArrayInput(
      scope,
      fieldTouched ? submitName : void 0,
      hostEl,
      "",
      false,
      valueNodes.length
    );
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
    input.id = arrayInputId(scope, hostEl.id, index);
    input.value = values[index] ?? "";
    if (fieldTouched) {
      input.name = submitName;
      associateInputWithFormIfOutside(input, hostEl);
    } else {
      input.removeAttribute("name");
      input.removeAttribute("form");
    }
  });
  return valueNodes[valueNodes.length - 1] ?? null;
}
function syncArrayHiddenInputsForPhoenix(el, values, options = {}) {
  const scope = options.scope ?? "tags-input";
  const submitName = options.submitName ?? getString(el, "submitName");
  if (!submitName) return;
  const fixedLength = options.fixedLength;
  const padded = fixedLength !== void 0 ? padValues(values, fixedLength) : values.map((v) => String(v));
  const fieldTouched = isFormFieldUsed(el, options.fieldTouched === true);
  const allEmpty = padded.length > 0 && padded.every((v) => String(v).trim() === "");
  const normalized = fixedLength !== void 0 && fieldTouched && allEmpty ? [] : padded;
  const container = el.querySelector(
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
    container.querySelectorAll(
      `[data-scope="${scope}"][data-part="array-input"][name="${CSS.escape(submitName)}"]`
    ).forEach((input) => reapplyLiveViewValueInputUsage(input));
  }
  const notifyLiveView = options.notifyLiveView ?? false;
  if (!notifyLiveView || !notifyInput) return;
  options.onTouched?.();
  notifyPhoenixFormChange(notifyInput, notifyInput.value, {
    onTouched: void 0,
    force: true
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

// lib/checkable-form-sync.ts
function hiddenInputPropsWithoutChecked(props) {
  const rest = { ...props };
  delete rest.defaultChecked;
  delete rest.checked;
  return rest;
}
function syncCheckableHiddenInput(inputEl, hostEl, checked, spreadProps, hiddenInputProps) {
  spreadProps(inputEl, hiddenInputPropsWithoutChecked(hiddenInputProps));
  inputEl.checked = checked;
  syncInputFormAssociation(inputEl, hostEl);
}

// lib/value-form-sync.ts
function hiddenInputPropsWithoutValue(props) {
  const rest = { ...props };
  delete rest.defaultValue;
  delete rest.value;
  return rest;
}
function syncHiddenInputValue(inputEl, hostEl, value, spreadProps, hiddenProps) {
  if (Object.keys(hiddenProps).length > 0) {
    spreadProps(inputEl, hiddenInputPropsWithoutValue(hiddenProps));
  }
  inputEl.value = value;
  syncInputFormAssociation(inputEl, hostEl);
}

// lib/phoenix-form-bridge.ts
function markUsed(input) {
  reapplyLiveViewValueInputUsage(input);
}
function setScalarValue(input, value, options = {}) {
  notifyPhoenixFormChange(input, value, options);
}
function setArrayValues(el, values, options = {}) {
  syncArrayHiddenInputsForPhoenix(el, values, options);
}
function syncFormInput(input, getValue, onTouched) {
  syncLiveViewFormInput(input, getValue, onTouched);
}

export {
  syncHiddenInputValue,
  reapplyLiveViewValueInputUsage,
  dispatchFormInputEvents,
  syncCheckedHiddenInput,
  notifyPhoenixFormChange,
  isFormFieldUsed,
  bindArrayFieldSubmitIntent,
  hiddenInputPropsWithoutChecked,
  syncCheckableHiddenInput,
  markUsed,
  setScalarValue,
  setArrayValues,
  syncFormInput
};
