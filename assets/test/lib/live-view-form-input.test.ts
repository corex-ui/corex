import { describe, expect, it, vi } from "vitest";
import {
  PHX_HAS_FOCUSED,
  notifyPhoenixFormChange,
  queueLiveViewFormInputSync,
  reapplyLiveViewValueInputUsage,
  syncLiveViewFormInput,
} from "../../lib/live-view-form-input";

describe("reapplyLiveViewValueInputUsage", () => {
  it("sets phx-has-focused on phxPrivate", () => {
    const input = document.createElement("input");
    reapplyLiveViewValueInputUsage(input);
    expect(
      (input as HTMLInputElement & { phxPrivate?: Record<string, boolean> }).phxPrivate
    ).toEqual({
      [PHX_HAS_FOCUSED]: true,
    });
  });
});

describe("notifyPhoenixFormChange", () => {
  it("syncs value and dispatches input and change", () => {
    const input = document.createElement("input");
    const form = document.createElement("form");
    form.appendChild(input);
    document.body.appendChild(form);

    const inputHandler = vi.fn();
    const changeHandler = vi.fn();
    input.addEventListener("input", inputHandler);
    input.addEventListener("change", changeHandler);

    notifyPhoenixFormChange(input, "eur");

    expect(input.value).toBe("eur");
    expect(
      (input as HTMLInputElement & { phxPrivate?: Record<string, boolean> }).phxPrivate?.[
        PHX_HAS_FOCUSED
      ]
    ).toBe(true);
    expect(inputHandler).toHaveBeenCalledTimes(1);
    expect(changeHandler).toHaveBeenCalledTimes(1);

    form.remove();
  });

  it("does not dispatch when value is unchanged", () => {
    const input = document.createElement("input");
    input.value = "eur";
    const changeHandler = vi.fn();
    input.addEventListener("change", changeHandler);

    notifyPhoenixFormChange(input, "eur");

    expect(changeHandler).not.toHaveBeenCalled();
  });

  it("keeps the value attribute aligned for LiveView ignore_attrs", () => {
    const input = document.createElement("input");
    input.setAttribute("value", "");
    input.value = "";

    notifyPhoenixFormChange(input, "2026-07-15", { markUsed: false });

    expect(input.value).toBe("2026-07-15");
    expect(input.getAttribute("value")).toBe("2026-07-15");
  });

  it("force dispatches when value is unchanged", () => {
    const input = document.createElement("input");
    input.value = "eur";
    const inputHandler = vi.fn();
    const changeHandler = vi.fn();
    const onTouched = vi.fn();
    input.addEventListener("input", inputHandler);
    input.addEventListener("change", changeHandler);

    notifyPhoenixFormChange(input, "eur", { force: true, onTouched });

    expect(input.value).toBe("eur");
    expect(onTouched).toHaveBeenCalledTimes(1);
    expect(inputHandler).toHaveBeenCalledTimes(1);
    expect(changeHandler).toHaveBeenCalledTimes(1);
    expect(
      (input as HTMLInputElement & { phxPrivate?: Record<string, boolean> }).phxPrivate?.[
        PHX_HAS_FOCUSED
      ]
    ).toBe(true);
  });
});

describe("syncLiveViewFormInput", () => {
  it("syncs value synchronously", () => {
    const input = document.createElement("input");
    const changeHandler = vi.fn();
    input.addEventListener("change", changeHandler);

    syncLiveViewFormInput(input, () => "eur");

    expect(input.value).toBe("eur");
    expect(changeHandler).toHaveBeenCalledTimes(1);
  });
});

describe("queueLiveViewFormInputSync", () => {
  it("syncs value synchronously without waiting a microtask", () => {
    const input = document.createElement("input");
    const form = document.createElement("form");
    form.appendChild(input);
    document.body.appendChild(form);

    const inputHandler = vi.fn();
    const changeHandler = vi.fn();
    input.addEventListener("input", inputHandler);
    input.addEventListener("change", changeHandler);

    queueLiveViewFormInputSync(input, () => "eur");

    expect(input.value).toBe("eur");
    expect(
      (input as HTMLInputElement & { phxPrivate?: Record<string, boolean> }).phxPrivate?.[
        PHX_HAS_FOCUSED
      ]
    ).toBe(true);
    expect(inputHandler).toHaveBeenCalledTimes(1);
    expect(changeHandler).toHaveBeenCalledTimes(1);

    form.remove();
  });
});
