// lib/live-view-form-input.ts
var PHX_HAS_FOCUSED = "phx-has-focused";
function reapplyLiveViewValueInputUsage(input) {
  const p = input;
  if (!p.phxPrivate) p.phxPrivate = {};
  p.phxPrivate[PHX_HAS_FOCUSED] = true;
}
function queueLiveViewFormInputSync(input, getValue, onTouched) {
  queueMicrotask(() => {
    const v = getValue();
    if (String(input.value) !== String(v)) {
      input.value = v;
    }
    onTouched?.();
    reapplyLiveViewValueInputUsage(input);
    input.dispatchEvent(new Event("input", { bubbles: true }));
    input.dispatchEvent(new Event("change", { bubbles: true }));
  });
}

export {
  reapplyLiveViewValueInputUsage,
  queueLiveViewFormInputSync
};
