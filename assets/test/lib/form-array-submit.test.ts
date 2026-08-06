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

  it("clears fixed-length pin names when untouched and restores them when touched", () => {
    const { el, container } = hostWithContainer("pin-input");
    el.dataset.submitName = "admin[pin][]";

    for (let i = 0; i < 4; i += 1) {
      const input = document.createElement("input");
      input.type = "hidden";
      input.setAttribute("data-scope", "pin-input");
      input.setAttribute("data-part", "array-input");
      input.name = "admin[pin][]";
      input.value = "";
      container.appendChild(input);
    }

    syncArrayHiddenInputsForPhoenix(el, ["", "", "", ""], {
      scope: "pin-input",
      fixedLength: 4,
      notifyLiveView: false,
      fieldTouched: false,
    });

    const untouched = container.querySelectorAll<HTMLInputElement>(
      '[data-scope="pin-input"][data-part="array-input"]'
    );
    expect(untouched).toHaveLength(4);
    untouched.forEach((input) => expect(input.hasAttribute("name")).toBe(false));

    syncArrayHiddenInputsForPhoenix(el, ["1", "2", "", ""], {
      scope: "pin-input",
      fixedLength: 4,
      notifyLiveView: true,
      fieldTouched: true,
    });

    const touched = container.querySelectorAll<HTMLInputElement>(
      '[data-scope="pin-input"][data-part="array-input"]'
    );
    expect(touched).toHaveLength(4);
    touched.forEach((input) => expect(input.getAttribute("name")).toBe("admin[pin][]"));
    expect(touched[0]?.value).toBe("1");
    expect(touched[1]?.value).toBe("2");

    el.remove();
  });

  it("uses named empty sentinel when fixed-length pin is cleared after touch", () => {
    const { el, container } = hostWithContainer("pin-input");
    el.dataset.submitName = "admin[pin][]";

    syncArrayHiddenInputsForPhoenix(el, ["", "", "", ""], {
      scope: "pin-input",
      fixedLength: 4,
      notifyLiveView: true,
      fieldTouched: true,
    });

    const empty = container.querySelector<HTMLInputElement>(
      '[data-scope="pin-input"][data-part="array-input"][data-empty]'
    );
    expect(empty?.getAttribute("name")).toBe("admin[pin][]");
    expect(empty?.value).toBe("");
    expect(
      container.querySelectorAll('[data-scope="pin-input"][data-part="array-input"]')
    ).toHaveLength(1);

    el.remove();
  });
});
