import { describe, expect, it } from "vitest";
import { collection } from "@zag-js/listbox";
import { zagListCollectionConfig, type ValueLabelItem } from "../../lib/list-collection";
import { Listbox } from "../../components/listbox";
import { listboxTree } from "../helpers/component-smoke";

describe("Listbox", () => {
  const items: ValueLabelItem[] = [
    { label: "Alpha", value: "a" },
    { label: "Beta", value: "b" },
  ];

  it("getCollection reflects options", () => {
    const c = new Listbox(listboxTree(), {
      id: "lb",
      collection: collection(zagListCollectionConfig(items, false)),
    });
    expect(c.getCollection().size).toBe(2);
  });

  it("setOptions updates collection size", () => {
    const c = new Listbox(listboxTree(), {
      id: "lb",
      collection: collection(zagListCollectionConfig(items, false)),
    });
    c.setOptions([{ label: "Solo", value: "s" }]);
    expect(c.getCollection().size).toBe(1);
  });

  it("supports grouped collection config", () => {
    const grouped: ValueLabelItem[] = [
      { label: "A", value: "a", group: "g1" },
      { label: "B", value: "b", group: "g2" },
    ];
    const c = new Listbox(listboxTree(), {
      id: "lb",
      collection: collection(zagListCollectionConfig(grouped, true)),
    });
    expect(c.getCollection().size).toBe(2);
    c.destroy();
  });
});
