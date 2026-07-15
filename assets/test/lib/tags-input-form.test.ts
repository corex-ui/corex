import { describe, expect, it } from "vitest";
import { isFormFieldUsed } from "../../lib/form-array-submit";
import {
  syncTagsArrayInputsForPhoenix,
  syncTagsInputFormForPhoenix,
} from "../../lib/tags-input-form";
import { el } from "../helpers/dom";

describe("isFormFieldUsed", () => {
  it("is true when data-field-used is set", () => {
    const root = el({ fieldUsed: true });
    expect(isFormFieldUsed(root, false)).toBe(true);
  });

  it("is true when the user touched the field in this session", () => {
    const root = el({});
    expect(isFormFieldUsed(root, true)).toBe(true);
  });
});

describe("syncTagsArrayInputsForPhoenix", () => {
  it("creates hidden inputs with submit name[] per tag", () => {
    const root = el({ submitName: "post[tags][]" });
    root.innerHTML = `
      <div data-scope="tags-input" data-part="root">
        <div data-scope="tags-input" data-part="array-inputs"></div>
      </div>
    `;

    syncTagsArrayInputsForPhoenix(root, ["alpha", "beta"]);

    const inputs = root.querySelectorAll<HTMLInputElement>(
      '[data-scope="tags-input"][data-part="array-input"]'
    );
    expect(inputs).toHaveLength(2);
    expect(inputs[0]!.name).toBe("post[tags][]");
    expect(inputs[0]!.value).toBe("alpha");
    expect(inputs[1]!.value).toBe("beta");
  });

  it("renders unnamed empty placeholder when untouched", () => {
    const root = el({ submitName: "post[tags][]" });
    root.innerHTML = `
      <div data-scope="tags-input" data-part="root">
        <div data-scope="tags-input" data-part="array-inputs"></div>
      </div>
    `;

    syncTagsArrayInputsForPhoenix(root, []);

    const input = root.querySelector<HTMLInputElement>(
      '[data-scope="tags-input"][data-part="array-input"][data-empty]'
    )!;
    expect(input.name).toBe("");
    expect(input.value).toBe("");
  });

  it("renders named empty placeholder when the field is used", () => {
    const root = el({ submitName: "post[tags][]", fieldUsed: true });
    root.innerHTML = `
      <div data-scope="tags-input" data-part="root">
        <div data-scope="tags-input" data-part="array-inputs"></div>
      </div>
    `;

    syncTagsArrayInputsForPhoenix(root, [], undefined, { fieldTouched: true });

    const input = root.querySelector<HTMLInputElement>(
      '[data-scope="tags-input"][data-part="array-input"][data-empty]'
    )!;
    expect(input.name).toBe("post[tags][]");
  });

  it("does not set form attribute when the hook is inside a form element", () => {
    const root = el({ submitName: "post[tags][]", form: "post-form" });
    root.innerHTML = `
      <div data-scope="tags-input" data-part="root">
        <div data-scope="tags-input" data-part="array-inputs"></div>
      </div>
    `;
    const form = document.createElement("form");
    form.id = "post-form";
    form.appendChild(root);
    document.body.appendChild(form);

    syncTagsArrayInputsForPhoenix(root, ["alpha"]);

    const input = root.querySelector<HTMLInputElement>(
      '[data-scope="tags-input"][data-part="array-input"]'
    )!;
    expect(input.hasAttribute("form")).toBe(false);
    form.remove();
  });

  it("does nothing without submit name", () => {
    const root = el({});
    root.innerHTML = `<div data-scope="tags-input" data-part="array-inputs"></div>`;

    syncTagsArrayInputsForPhoenix(root, ["alpha"]);

    expect(
      root.querySelectorAll('[data-scope="tags-input"][data-part="array-input"]')
    ).toHaveLength(0);
  });
});

describe("syncTagsInputFormForPhoenix", () => {
  it("delegates to array inputs sync", () => {
    const root = el({ submitName: "post[tags][]" });
    root.innerHTML = `
      <div data-scope="tags-input" data-part="root">
        <div data-scope="tags-input" data-part="array-inputs"></div>
      </div>
    `;

    syncTagsInputFormForPhoenix(root, ["alpha"]);

    const inputs = root.querySelectorAll<HTMLInputElement>(
      '[data-scope="tags-input"][data-part="array-input"]'
    );
    expect(inputs).toHaveLength(1);
    expect(inputs[0]!.value).toBe("alpha");
  });
});
