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

  it("drops hidden select name when value-input owns the form field", () => {
    const root = document.createElement("div");
    root.id = "sel-form";
    root.dataset.name = "user[country]";
    root.innerHTML = `
      <input data-scope="select" data-part="value-input" type="text" hidden name="user[country]" />
      <select data-scope="select" data-part="hidden-select">
        <option value=""></option>
        <option value="fra">France</option>
      </select>
      <div data-scope="select" data-part="root"></div>
    `;

    const c = new Select(root, {
      id: "sel-form",
      name: "user[country]",
      collection: collection(zagListCollectionConfig(items, false)),
    });
    c.init();

    const hiddenSelect = root.querySelector<HTMLSelectElement>(
      '[data-scope="select"][data-part="hidden-select"]'
    )!;
    expect(hiddenSelect.name).toBe("");
    expect(hiddenSelect.disabled).toBe(true);

    c.destroy();
  });

  it("does not overwrite value-input from api.value when controlled", () => {
    const root = document.createElement("div");
    root.id = "sel-controlled";
    root.dataset.controlled = "";
    root.dataset.name = "user[country]";
    root.innerHTML = `
      <input data-scope="select" data-part="value-input" type="text" hidden name="user[country]" value="fra" />
      <select data-scope="select" data-part="hidden-select">
        <option value=""></option>
        <option value="fra">France</option>
      </select>
      <div data-scope="select" data-part="root"></div>
    `;

    const c = new Select(root, {
      id: "sel-controlled",
      name: "user[country]",
      value: [],
      collection: collection(zagListCollectionConfig(items, false)),
    });
    c.init();

    const valueInput = root.querySelector<HTMLInputElement>(
      '[data-scope="select"][data-part="value-input"]'
    )!;
    expect(valueInput.value).toBe("fra");

    c.destroy();
  });
});
