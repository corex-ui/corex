export const PHX_HAS_FOCUSED = "phx-has-focused";

export function reapplyLiveViewValueInputUsage(input: HTMLInputElement) {
  const p = input as HTMLInputElement & { phxPrivate?: Record<string, boolean> };
  if (!p.phxPrivate) p.phxPrivate = {};
  p.phxPrivate[PHX_HAS_FOCUSED] = true;
}

export function queueLiveViewFormInputSync(
  input: HTMLInputElement,
  getValue: () => string,
  onTouched?: () => void
): void {
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
