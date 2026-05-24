import { describe, expect, it } from "vitest";
import * as hookModule from "../../hooks/select";
import { buildCollection, reapplySelectInteractiveState } from "../../hooks/select";
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
