import { describe, expect, it } from "vitest";
import * as hookModule from "../../hooks/select";
import {
  buildCollection,
  formatSelectHiddenValue,
  reapplySelectInteractiveState,
  syncSelectHiddenInputForPhoenix,
  syncSelectHiddenSelectForPhoenix,
} from "../../hooks/select";
import { mutableArray } from "../helpers/matrix";
import type { ValueLabelItem } from "../../lib/list-collection";
import { expectHookModule } from "../helpers/expect-hook";
import { el } from "../helpers/dom";

const items: ValueLabelItem[] = [
  { label: "Alpha", value: "a" },
  { label: "Beta", value: "b" },
];

describe("select hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});

describe("reapplySelectInteractiveState", () => {
  it("clears stale disabled on trigger when hook is enabled", () => {
    const root = el({});
    root.setAttribute("data-loading", "");
    root.innerHTML = `<button data-scope="select" data-part="trigger" disabled></button>`;

    reapplySelectInteractiveState(root);

    const trigger = root.querySelector("button")!;
    expect(root.hasAttribute("data-loading")).toBe(false);
    expect(trigger.disabled).toBe(false);
    expect(trigger.hasAttribute("disabled")).toBe(false);
  });

  it("keeps disabled trigger when hook is disabled", () => {
    const root = el({ disabled: true });
    root.innerHTML = `<button data-scope="select" data-part="trigger" data-disabled disabled></button>`;

    reapplySelectInteractiveState(root);

    const trigger = root.querySelector("button")!;
    expect(trigger.disabled).toBe(true);
  });
});

describe("buildCollection", () => {
  it("builds flat collection", () => {
    expect(buildCollection(items, false).size).toBe(2);
  });

  it("builds grouped collection", () => {
    const grouped: ValueLabelItem[] = [
      { label: "A", value: "a", group: "g1" },
      { label: "B", value: "b", group: "g2" },
    ];
    expect(buildCollection(mutableArray(grouped), true).size).toBe(2);
  });
});

describe("syncSelectHiddenInputForPhoenix", () => {
  it("syncs multiple form values to hidden select options when name[] is present", () => {
    const root = el({ multiple: true, hiddenSelectName: "post[tags][]" });
    root.innerHTML = `
      <input data-scope="select" data-part="value-input" type="text" hidden name="post[tags]" />
      <select data-scope="select" data-part="hidden-select" multiple>
        <option value=""></option>
        <option value="option1">Option 1</option>
        <option value="option2">Option 2</option>
      </select>
    `;

    syncSelectHiddenInputForPhoenix(root, ["option1", "option2"]);

    const hiddenSelect = root.querySelector<HTMLSelectElement>(
      '[data-scope="select"][data-part="hidden-select"]'
    )!;
    expect(hiddenSelect.name).toBe("post[tags][]");
    const selected = Array.from(hiddenSelect.selectedOptions).map((option) => option.value);
    expect(selected).toEqual(["option1", "option2"]);
  });

  it("syncs single select values to value-input", async () => {
    const root = el({ multiple: false });
    root.innerHTML = `<input data-scope="select" data-part="value-input" type="text" hidden name="post[status]" />`;

    syncSelectHiddenInputForPhoenix(root, ["draft"]);
    await new Promise<void>((resolve) => {
      queueMicrotask(() => resolve());
    });

    const valueInput = root.querySelector<HTMLInputElement>(
      '[data-scope="select"][data-part="value-input"]'
    )!;
    expect(valueInput.value).toBe("draft");
  });
});

describe("formatSelectHiddenValue", () => {
  it("joins multiple values with commas for legacy value-input mode", () => {
    const root = el({ multiple: true });
    expect(formatSelectHiddenValue(root, ["a", "b"])).toBe("a,b");
  });
});

describe("syncSelectHiddenSelectForPhoenix", () => {
  it("clears selection when values are empty", () => {
    const hiddenSelect = document.createElement("select");
    hiddenSelect.multiple = true;
    hiddenSelect.innerHTML = `
      <option value=""></option>
      <option value="option1">Option 1</option>
    `;
    hiddenSelect.options[1]!.selected = true;

    syncSelectHiddenSelectForPhoenix(hiddenSelect, []);

    expect(Array.from(hiddenSelect.selectedOptions)).toHaveLength(0);
  });
});
