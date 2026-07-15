import { describe, expect, it, vi } from "vitest";
import {
  PHX_HAS_FOCUSED,
  notifyPhoenixFormChange,
  queueLiveViewFormInputSync,
  reapplyLiveViewValueInputUsage,
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

describe("queueLiveViewFormInputSync", () => {
  it("syncs value and dispatches input and change", async () => {
    const input = document.createElement("input");
    const form = document.createElement("form");
    form.appendChild(input);
    document.body.appendChild(form);

    const inputHandler = vi.fn();
    const changeHandler = vi.fn();
    input.addEventListener("input", inputHandler);
    input.addEventListener("change", changeHandler);

    queueLiveViewFormInputSync(input, () => "eur");
    await Promise.resolve();

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
});
