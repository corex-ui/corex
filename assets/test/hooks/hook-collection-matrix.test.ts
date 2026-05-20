import { describe, expect, it } from "vitest";
import { mutableArray } from "../helpers/matrix";
import { buildCollection as buildListboxCollection } from "../../hooks/listbox";
import { buildCollection as buildSelectCollection } from "../../hooks/select";
import type { ValueLabelItem } from "../../lib/list-collection";

const flat = [
  { label: "Alpha", value: "a" },
  { label: "Beta", value: "b" },
  { label: "Gamma", value: "c" },
];

const grouped = [
  { label: "One", value: "1", group: "odd" },
  { label: "Two", value: "2", group: "even" },
  { label: "Three", value: "3", group: "odd" },
];

describe("listbox buildCollection matrix", () => {
  it.each([
    [flat, false, 3],
    [grouped, true, 3],
    [[], false, 0],
  ] as const)("%#", (items, hasGroups, size) => {
    expect(buildListboxCollection(mutableArray(items as readonly ValueLabelItem[]), hasGroups).size).toBe(
      size
    );
  });

  it("first item value matches", () => {
    const col = buildListboxCollection(flat, false);
    expect(col.items[0]?.value).toBe("a");
  });
});

describe("select buildCollection matrix", () => {
  it.each([
    [flat, false, 3],
    [grouped, true, 3],
  ] as const)("%#", (items, hasGroups, size) => {
    expect(buildSelectCollection(mutableArray(items as readonly ValueLabelItem[]), hasGroups).size).toBe(
      size
    );
  });
});
