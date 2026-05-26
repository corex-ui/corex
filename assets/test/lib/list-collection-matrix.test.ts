import { collection } from "@zag-js/listbox";
import { describe, expect, it } from "vitest";
import { itemValue, zagListCollectionConfig, type ValueLabelItem } from "../../lib/list-collection";

describe.each([
  [{ label: "Only" }, ""],
  [{ label: "Named", value: "id" }, "id"],
  [{ value: "raw" }, "raw"],
] as const)("itemValue", (item, expected) => {
  it(`returns ${expected || "(empty)"}`, () => {
    expect(itemValue(item as ValueLabelItem)).toBe(expected);
  });
});

describe("zagListCollectionConfig collections", () => {
  const flat = [
    { label: "A", value: "a" },
    { label: "B", value: "b" },
  ];
  const grouped = [
    { label: "A", value: "a", group: "g1" },
    { label: "B", value: "b", group: "g2" },
    { label: "C", value: "c", group: "g1" },
  ];

  it.each([
    [flat, false, 2],
    [grouped, true, 3],
  ] as const)("size with hasGroups=%s", (items, hasGroups, size) => {
    const col = collection(zagListCollectionConfig(items, hasGroups));
    expect(col.size).toBe(size);
  });

  it("groupBy assigns groups when enabled", () => {
    const config = zagListCollectionConfig(grouped, true);
    expect(config.groupBy?.(grouped[0])).toBe("g1");
    expect(config.groupBy?.(grouped[1])).toBe("g2");
  });
});
