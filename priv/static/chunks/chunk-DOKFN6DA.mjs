// lib/live-view-form-input.ts
var PHX_HAS_FOCUSED = "phx-has-focused";
function reapplyLiveViewValueInputUsage(input) {
  const p = input;
  if (!p.phxPrivate) p.phxPrivate = {};
  p.phxPrivate[PHX_HAS_FOCUSED] = true;
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
  if (options.markUsed === false) {
    return;
  }
  reapplyLiveViewValueInputUsage(input);
  input.dispatchEvent(new Event("input", { bubbles: true }));
  if (options.change !== false) {
    input.dispatchEvent(new Event("change", { bubbles: true }));
  }
}
function syncLiveViewFormInput(input, getValue, onTouched) {
  notifyPhoenixFormChange(input, getValue(), { onTouched });
}

export {
  reapplyLiveViewValueInputUsage,
  notifyPhoenixFormChange,
  syncLiveViewFormInput
};
