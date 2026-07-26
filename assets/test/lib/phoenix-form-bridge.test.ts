import { describe, expect, it, vi } from "vitest";
import {
  PHX_HAS_FOCUSED,
  dispatchFormInputEvents,
  hiddenInputPropsWithoutChecked,
  hiddenInputPropsWithoutValue,
  isFormFieldUsed,
  markUsed,
  setArrayValues,
  setScalarValue,
  syncCheckableHiddenInput,
  syncCheckedHiddenInput,
  syncFormInput,
  syncHiddenInputValue,
} from "../../lib/phoenix-form-bridge";

describe("phoenix-form-bridge re-exports", () => {
  it("exposes leaf form sync helpers", () => {
    expect(hiddenInputPropsWithoutChecked({ checked: true, name: "a" })).toEqual({
      name: "a",
    });
    expect(hiddenInputPropsWithoutValue({ value: "1", name: "b" })).toEqual({ name: "b" });
    expect(typeof syncCheckableHiddenInput).toBe("function");
    expect(typeof syncHiddenInputValue).toBe("function");
    expect(typeof syncCheckedHiddenInput).toBe("function");
    expect(typeof dispatchFormInputEvents).toBe("function");
    expect(typeof isFormFieldUsed).toBe("function");
    expect(PHX_HAS_FOCUSED).toBe("phx-has-focused");
  });

  it("aliases markUsed setScalarValue syncFormInput", () => {
    const input = document.createElement("input");
    const form = document.createElement("form");
    form.appendChild(input);
    document.body.appendChild(form);

    markUsed(input);
    expect(
      (input as HTMLInputElement & { phxPrivate?: Record<string, boolean> }).phxPrivate?.[
        PHX_HAS_FOCUSED
      ]
    ).toBe(true);

    const changeHandler = vi.fn();
    input.addEventListener("change", changeHandler);
    setScalarValue(input, "hello");
    expect(input.value).toBe("hello");
    expect(changeHandler).toHaveBeenCalled();

    syncFormInput(input, () => "world");
    expect(input.value).toBe("world");

    form.remove();
  });

  it("aliases setArrayValues onto a scoped host", () => {
    const host = document.createElement("div");
    host.id = "bridge-tags";
    host.dataset.submitName = "tags[]";
    const container = document.createElement("div");
    container.setAttribute("data-scope", "tags-input");
    container.setAttribute("data-part", "array-inputs");
    host.appendChild(container);
    document.body.appendChild(host);

    setArrayValues(host, ["a", "b"], {
      scope: "tags-input",
      submitName: "tags[]",
      notifyLiveView: true,
      fieldTouched: true,
    });

    expect(
      container.querySelectorAll('[data-scope="tags-input"][data-part="array-input"]')
    ).toHaveLength(2);

    host.remove();
  });
});
