import { describe, expect, it } from "vitest";
import * as hookModule from "../../hooks/listbox";
import { buildCollection } from "../../hooks/listbox";
import { mutableArray } from "../helpers/matrix";
import type { ValueLabelItem } from "../../lib/list-collection";
import { expectHookModule } from "../helpers/expect-hook";

const items: ValueLabelItem[] = [
  { label: "One", value: "1" },
  { label: "Two", value: "2", group: "g" },
];

describe("listbox hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});

describe("buildCollection", () => {
  it.each([
    [items.slice(0, 1), false, 1],
    [items, true, 2],
    [[], false, 0],
  ] as const)("%#", (list, hasGroups, size) => {
    expect(buildCollection(mutableArray(list as readonly ValueLabelItem[]), hasGroups).size).toBe(
      size
    );
  });
});
