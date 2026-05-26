import { collection } from "@zag-js/listbox";
import { describe, expect, it } from "vitest";
import { itemValue, zagListCollectionConfig } from "../../lib/list-collection";

describe("itemValue", () => {
  it("returns empty string when value is missing", () => {
    expect(itemValue({ label: "One" })).toBe("");
  });

  it("returns explicit value", () => {
    expect(itemValue({ label: "One", value: "1" })).toBe("1");
  });
});

describe("zagListCollectionConfig", () => {
  const items = [
    { label: "A", value: "a", group: "g1" },
    { label: "B", value: "b", group: "g2" },
  ];

  it("includes groupBy when hasGroups is true", () => {
    const config = zagListCollectionConfig(items, true);
    expect("groupBy" in config).toBe(true);
    expect(config.groupBy!(items[0])).toBe("g1");
  });

  it("omits groupBy when hasGroups is false", () => {
    const config = zagListCollectionConfig(items, false);
    expect("groupBy" in config).toBe(false);
  });

  it("builds a Zag collection with item values", () => {
    const col = collection(zagListCollectionConfig(items, true));
    expect(col.size).toBe(2);
    expect(col.getItemValue(items[0])).toBe("a");
  });
});
