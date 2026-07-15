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
  force?: boolean;
};

export function notifyPhoenixFormChange(
  input: HTMLInputElement,
  value: string,
  options: NotifyPhoenixFormChangeOptions = {}
): void {
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

export function syncLiveViewFormInput(
  input: HTMLInputElement,
  getValue: () => string,
  onTouched?: () => void
): void {
  notifyPhoenixFormChange(input, getValue(), { onTouched });
}

export function queueLiveViewFormInputSync(
  input: HTMLInputElement,
  getValue: () => string,
  onTouched?: () => void
): void {
  syncLiveViewFormInput(input, getValue, onTouched);
}
