import { describe, expect, it, vi } from "vitest";
import { syncArrayHiddenInputsForPhoenix } from "../../lib/form-array-submit";
import { PHX_HAS_FOCUSED } from "../../lib/live-view-form-input";

function hostWithContainer(scope = "tags-input") {
  const el = document.createElement("div");
  el.id = "field-1";
  el.dataset.submitName = "post[tags][]";
  const container = document.createElement("div");
  container.setAttribute("data-scope", scope);
  container.setAttribute("data-part", "array-inputs");
  el.appendChild(container);
  document.body.appendChild(el);
  return { el, container };
}

describe("syncArrayHiddenInputsForPhoenix", () => {
  it("force-notifies LiveView after writing values", () => {
    const { el, container } = hostWithContainer();
    const onTouched = vi.fn();
    const inputHandler = vi.fn();
    const changeHandler = vi.fn();
    container.addEventListener("input", inputHandler);
    container.addEventListener("change", changeHandler);

    syncArrayHiddenInputsForPhoenix(el, ["a", "b"], {
      scope: "tags-input",
      notifyLiveView: true,
      fieldTouched: true,
      onTouched,
    });

    const inputs = container.querySelectorAll<HTMLInputElement>(
      '[data-scope="tags-input"][data-part="array-input"]'
    );
    expect(inputs).toHaveLength(2);
    expect(inputs[0]?.value).toBe("a");
    expect(inputs[1]?.value).toBe("b");
    expect(onTouched).toHaveBeenCalledTimes(1);
    expect(inputHandler).toHaveBeenCalledTimes(1);
    expect(changeHandler).toHaveBeenCalledTimes(1);
    expect(
      (inputs[1] as HTMLInputElement & { phxPrivate?: Record<string, boolean> }).phxPrivate?.[
        PHX_HAS_FOCUSED
      ]
    ).toBe(true);

    el.remove();
  });

  it("omits name on empty sentinel when untouched", () => {
    const { el, container } = hostWithContainer();

    syncArrayHiddenInputsForPhoenix(el, [], {
      scope: "tags-input",
      notifyLiveView: false,
      fieldTouched: false,
    });

    const empty = container.querySelector<HTMLInputElement>(
      '[data-scope="tags-input"][data-part="array-input"][data-empty]'
    );
    expect(empty).not.toBeNull();
    expect(empty?.hasAttribute("name")).toBe(false);

    el.remove();
  });

  it("names empty sentinel when fieldTouched", () => {
    const { el, container } = hostWithContainer();

    syncArrayHiddenInputsForPhoenix(el, [], {
      scope: "tags-input",
      notifyLiveView: true,
      fieldTouched: true,
    });

    const empty = container.querySelector<HTMLInputElement>(
      '[data-scope="tags-input"][data-part="array-input"][data-empty]'
    );
    expect(empty?.getAttribute("name")).toBe("post[tags][]");

    el.remove();
  });

  it("returns early when array-inputs container is missing", () => {
    const el = document.createElement("div");
    el.id = "field-missing";
    el.dataset.submitName = "post[tags][]";
    document.body.appendChild(el);

    syncArrayHiddenInputsForPhoenix(el, ["a"], {
      scope: "tags-input",
      notifyLiveView: true,
      fieldTouched: true,
    });

    expect(el.querySelectorAll('[data-scope="tags-input"][data-part="array-input"]')).toHaveLength(
      0
    );

    el.remove();
  });
});
