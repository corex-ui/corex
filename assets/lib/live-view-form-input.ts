export const PHX_HAS_FOCUSED = "phx-has-focused";

export function reapplyLiveViewValueInputUsage(input: HTMLInputElement) {
  const p = input as HTMLInputElement & { phxPrivate?: Record<string, boolean> };
  if (!p.phxPrivate) p.phxPrivate = {};
  p.phxPrivate[PHX_HAS_FOCUSED] = true;
}

export type NotifyPhoenixFormChangeOptions = {
  onTouched?: () => void;
  change?: boolean;
  markUsed?: boolean;
};

export function notifyPhoenixFormChange(
  input: HTMLInputElement,
  value: string,
  options: NotifyPhoenixFormChangeOptions = {}
): void {
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

export function queueLiveViewFormInputSync(
  input: HTMLInputElement,
  getValue: () => string,
  onTouched?: () => void
): void {
  queueMicrotask(() => {
    notifyPhoenixFormChange(input, getValue(), { onTouched });
  });
}
