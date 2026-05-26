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

  it("render syncs hidden input from api value", () => {
    const root = comboboxTree();
    const c = new Combobox(root, { id: "cb", defaultValue: ["b"] }, items, false);
    c.init();
    const hidden = root.querySelector<HTMLInputElement>(
      '[data-scope="combobox"][data-part="hidden-input"]'
    );
    expect(hidden?.value).toBe("b");
    c.destroy();
  });

  it("render falls back to data-default-value when api value is empty", () => {
    const root = comboboxTree();
    root.dataset.defaultValue = "a";
    const c = new Combobox(root, { id: "cb" }, items, false);
    c.init();
    const hidden = root.querySelector<HTMLInputElement>(
      '[data-scope="combobox"][data-part="hidden-input"]'
    );
    expect(hidden?.value).toBe("a");
    c.destroy();
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
