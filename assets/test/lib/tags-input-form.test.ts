import { describe, expect, it } from "vitest";
import {
  syncTagsArrayInputsForPhoenix,
  syncTagsInputFormForPhoenix,
} from "../../lib/tags-input-form";
import { el } from "../helpers/dom";

describe("syncTagsArrayInputsForPhoenix", () => {
  it("creates hidden inputs with submit name[] per tag", () => {
    const root = el({ submitName: "post[tags][]" });
    root.innerHTML = `
      <div data-scope="tags-input" data-part="root">
        <div data-scope="tags-input" data-part="array-inputs" phx-update="ignore"></div>
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
        <div data-scope="tags-input" data-part="array-inputs" phx-update="ignore"></div>
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
