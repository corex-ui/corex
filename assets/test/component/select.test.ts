import { describe, expect, it } from "vitest";
import { collection } from "@zag-js/select";
import { zagListCollectionConfig } from "../../lib/list-collection";
import { Select } from "../../components/select";
import { selectTree } from "../helpers/component-smoke";

describe("Select", () => {
  const items = [
    { label: "Alpha", value: "a" },
    { label: "Beta", value: "b" },
  ];

  it("getCollection uses options", () => {
    const c = new Select(selectTree(), {
      id: "sel",
      collection: collection(zagListCollectionConfig(items, false)),
    });
    expect(c.getCollection().size).toBe(2);
  });

  it("setOptions replaces items", () => {
    const c = new Select(selectTree(), {
      id: "sel",
      collection: collection(zagListCollectionConfig(items, false)),
    });
    c.setOptions([{ label: "Only", value: "o" }]);
    expect(c.getCollection().size).toBe(1);
  });

  it("applyItemProps spreads item with matching data-value", () => {
    const c = new Select(selectTree(), {
      id: "sel",
      collection: collection(zagListCollectionConfig(items, false)),
    });
    c.render();
    const item = c.el.querySelector('[data-part="item"]');
    expect(item?.hasAttribute("data-value")).toBe(true);
    c.destroy();
  });
});
