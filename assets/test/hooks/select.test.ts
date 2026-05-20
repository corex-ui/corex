import { describe, expect, it } from "vitest";
import * as hookModule from "../../hooks/select";
import { buildCollection } from "../../hooks/select";
import { mutableArray } from "../helpers/matrix";
import type { ValueLabelItem } from "../../lib/list-collection";
import { expectHookModule } from "../helpers/expect-hook";

const items: ValueLabelItem[] = [
  { label: "Alpha", value: "a" },
  { label: "Beta", value: "b" },
];

describe("select hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
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
