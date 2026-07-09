import { describe, expect, it } from "vitest";
import {
  Combobox,
  resolveZagComboboxTranslations,
  type ComboboxItem,
} from "../../components/combobox";
import { comboboxTree } from "../helpers/component-smoke";

function comboboxTreeWithTemplates(items: ComboboxItem[]): HTMLElement {
  const root = comboboxTree();
  const templates = document.createElement("div");
  templates.dataset.templates = "combobox";
  templates.style.display = "none";

  for (const item of items) {
    const template = document.createElement("div");
    template.dataset.scope = "combobox";
    template.dataset.part = "item";
    template.dataset.value = item.value ?? item.label;
    template.dataset.template = "true";
    templates.appendChild(template);
  }

  root.appendChild(templates);
  return root;
}

function comboboxGroupedTreeWithTemplates(items: ComboboxItem[]): HTMLElement {
  const root = comboboxTreeWithTemplates(items);
  const templates = root.querySelector<HTMLElement>('[data-templates="combobox"]')!;

  for (const groupId of [...new Set(items.map((item) => item.group).filter(Boolean))]) {
    const groupTemplate = document.createElement("div");
    groupTemplate.dataset.scope = "combobox";
    groupTemplate.dataset.part = "item-group";
    groupTemplate.dataset.id = groupId!;
    groupTemplate.dataset.template = "true";

    const ul = document.createElement("ul");
    for (const item of items.filter((entry) => entry.group === groupId)) {
      const itemTemplate = document.createElement("div");
      itemTemplate.dataset.scope = "combobox";
      itemTemplate.dataset.part = "item";
      itemTemplate.dataset.value = item.value ?? item.label;
      itemTemplate.dataset.template = "true";
      ul.appendChild(itemTemplate);
    }

    groupTemplate.appendChild(ul);
    templates.appendChild(groupTemplate);
  }

  return root;
}

describe("Combobox", () => {
  const items = [
    { label: "Alpha", value: "a" },
    { label: "Beta", value: "b" },
  ];

  it("resolveZagComboboxTranslations maps trigger and clear labels", () => {
    const el = document.createElement("div");
    el.dataset.translation = JSON.stringify({
      triggerLabel: "Open list",
      clearTriggerLabel: "Clear",
    });
    expect(resolveZagComboboxTranslations(el)).toEqual({
      translations: { triggerLabel: "Open list", clearTriggerLabel: "Clear" },
    });
  });

  it("resolveZagComboboxTranslations falls back to defaults", () => {
    const el = document.createElement("div");
    expect(resolveZagComboboxTranslations(el).translations.triggerLabel).toBe("Open options");
  });

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

  it("reuses existing flat list items on repeated render", () => {
    const root = comboboxTreeWithTemplates(items);
    const c = new Combobox(root, { id: "cb" }, items, false);
    c.init();
    c.render();

    const list = root.querySelector('[data-part="list"]');
    const firstItem = list?.querySelector('[data-part="item"]:not([data-template])');
    expect(firstItem).toBeTruthy();

    c.render();
    expect(list?.querySelector('[data-part="item"]:not([data-template])')).toBe(firstItem);

    c.destroy();
  });

  it("removes filtered-out flat list items without rebuilding survivors", () => {
    const root = comboboxTreeWithTemplates(items);
    const c = new Combobox(root, { id: "cb" }, items, false);
    c.init();
    c.render();

    const list = root.querySelector('[data-part="list"]')!;
    const alpha = list.querySelector('[data-value="a"]');
    expect(alpha).toBeTruthy();

    c.options = [{ label: "Beta", value: "b" }];
    c.render();

    expect(list.querySelector('[data-value="a"]')).toBeNull();
    expect(list.querySelector('[data-value="b"]')).toBeTruthy();

    c.destroy();
  });

  it("reuses grouped list items on repeated render", () => {
    const grouped = [
      { label: "A", value: "a", group: "g1" },
      { label: "B", value: "b", group: "g1" },
    ];
    const root = comboboxGroupedTreeWithTemplates(grouped);
    const c = new Combobox(root, { id: "cb" }, grouped, true);
    c.init();
    c.render();

    const list = root.querySelector('[data-part="list"]');
    const firstGroup = list?.querySelector('[data-part="item-group"]:not([data-template])');
    const firstItem = list?.querySelector('[data-part="item"]:not([data-template])');
    expect(firstGroup).toBeTruthy();
    expect(firstItem).toBeTruthy();

    c.render();
    expect(list?.querySelector('[data-part="item-group"]:not([data-template])')).toBe(firstGroup);
    expect(list?.querySelector('[data-part="item"]:not([data-template])')).toBe(firstItem);

    c.destroy();
  });
});
