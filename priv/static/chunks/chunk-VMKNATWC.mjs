// lib/live-view-form-input.ts
var PHX_HAS_FOCUSED = "phx-has-focused";
function reapplyLiveViewValueInputUsage(input) {
  const p = input;
  if (!p.phxPrivate) p.phxPrivate = {};
  p.phxPrivate[PHX_HAS_FOCUSED] = true;
}
function notifyPhoenixFormChange(input, value, options = {}) {
  if (String(input.value) !== String(value)) {
    input.value = value;
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
function queueLiveViewFormInputSync(input, getValue, onTouched) {
  queueMicrotask(() => {
    notifyPhoenixFormChange(input, getValue(), { onTouched });
  });
}

export {
  reapplyLiveViewValueInputUsage,
  notifyPhoenixFormChange,
  queueLiveViewFormInputSync
};
