import { collection } from "@zag-js/listbox";
import { describe, expect, it, vi } from "vitest";
import {
  applyItems,
  itemValue,
  readItems,
  refreshItemsIfChanged,
  zagListCollectionConfig,
} from "../../lib/list-collection";

describe("itemValue", () => {
  it("returns empty string when value is missing", () => {
    expect(itemValue({ label: "One" })).toBe("");
  });

  it("returns explicit value", () => {
    expect(itemValue({ label: "One", value: "1" })).toBe("1");
  });
});

describe("zagListCollectionConfig", () => {
  const first = { label: "A", value: "a", group: "g1" };
  const items = [first, { label: "B", value: "b", group: "g2" }];

  it("includes groupBy when hasGroups is true", () => {
    const config = zagListCollectionConfig(items, true);
    expect("groupBy" in config).toBe(true);
    expect(config.groupBy!(first)).toBe("g1");
  });

  it("omits groupBy when hasGroups is false", () => {
    const config = zagListCollectionConfig(items, false);
    expect("groupBy" in config).toBe(false);
  });

  it("builds a Zag collection with item values", () => {
    const col = collection(zagListCollectionConfig(items, true));
    expect(col.size).toBe(2);
    expect(col.getItemValue(first)).toBe("a");
  });
});

describe("items refresh helpers", () => {
  it("reads items JSON from data-items", () => {
    const el = document.createElement("div");
    el.setAttribute(
      "data-items",
      JSON.stringify([
        { label: "A", value: "a", group: "g1" },
        { label: "B", value: "b" },
      ])
    );

    const { items, hasGroups } = readItems(el);
    expect(items).toHaveLength(2);
    expect(hasGroups).toBe(true);
  });

  it("prefers setAllOptions when both apply methods exist", () => {
    const setOptions = vi.fn();
    const setAllOptions = vi.fn();
    applyItems({ hasGroups: false, setOptions, setAllOptions }, [
      { label: "A", value: "a", group: "g" },
    ]);
    expect(setAllOptions).toHaveBeenCalledOnce();
    expect(setOptions).not.toHaveBeenCalled();
  });

  it("refreshes the host only when the items JSON changes", () => {
    const el = document.createElement("div");
    el.setAttribute("data-items", JSON.stringify([{ label: "A", value: "a" }]));
    const state = { lastItemsJson: undefined as string | undefined };
    const setOptions = vi.fn();
    const host = { hasGroups: false, setOptions };

    expect(refreshItemsIfChanged(el, state, host)).toBe(true);
    expect(setOptions).toHaveBeenCalledOnce();
    expect(refreshItemsIfChanged(el, state, host)).toBe(false);
    expect(setOptions).toHaveBeenCalledOnce();

    el.setAttribute(
      "data-items",
      JSON.stringify([
        { label: "A", value: "a" },
        { label: "B", value: "b", group: "g" },
      ])
    );
    expect(refreshItemsIfChanged(el, state, host)).toBe(true);
    expect(host.hasGroups).toBe(true);
    expect(setOptions).toHaveBeenCalledTimes(2);
  });
});
