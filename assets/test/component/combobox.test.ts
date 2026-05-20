import { describe, expect, it } from "vitest";
import { Combobox } from "../../components/combobox";
import { comboboxTree } from "../helpers/component-smoke";

describe("Combobox", () => {
  const items = [
    { label: "Alpha", value: "a" },
    { label: "Beta", value: "b" },
  ];

  it("getCollection reflects active options", () => {
    const c = new Combobox(comboboxTree(), { id: "cb" }, items, false);
    expect(c.getCollection().size).toBe(2);
  });

  it("restoreFilteredOptions resets filtered list", () => {
    const c = new Combobox(comboboxTree(), { id: "cb" }, items, false);
    c.options = [{ label: "Alpha", value: "a" }];
    c.restoreFilteredOptions();
    expect(c.options).toEqual(items);
  });

  it("setAllOptions updates backing list", () => {
    const c = new Combobox(comboboxTree(), { id: "cb" }, items, false);
    const next = [{ label: "Gamma", value: "g" }];
    c.setAllOptions(next);
    expect(c.allOptions).toEqual(next);
    expect(c.getCollection().size).toBe(1);
  });

  it("tracks hasGroups from constructor", () => {
    const grouped = [
      { label: "A", value: "a", group: "g1" },
      { label: "B", value: "b", group: "g2" },
    ];
    const c = new Combobox(comboboxTree(), { id: "cb" }, grouped, true);
    expect(c.hasGroups).toBe(true);
    expect(c.getCollection().size).toBe(2);
    c.destroy();
  });
});
