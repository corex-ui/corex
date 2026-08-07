import { describe, expect, it } from "vitest";
import { Accordion } from "../../components/accordion";
import { accordionTree } from "../helpers/component-smoke";
import { scopeTree } from "../helpers/component-fixture";

function contentEl(host: HTMLElement) {
  return host.querySelector<HTMLElement>('[data-part="item-content"]')!;
}

describe("Accordion", () => {
  it("init and render without throwing", () => {
    const el = accordionTree();
    const c = new Accordion(el, { id: el.id });
    expect(() => {
      c.init();
      c.render();
    }).not.toThrow();
    expect(el.querySelector('[data-part="item-trigger"]')).toBeTruthy();
    c.destroy();
  });

  it("instant animation keeps Zag hidden on collapsed content", () => {
    const el = scopeTree("accordion", [
      {
        part: "root",
        children: [
          {
            part: "item",
            attrs: { "data-value": "one", id: "accordion:instant-host:item:one" },
            children: [
              { part: "item-trigger" },
              { part: "item-indicator" },
              { part: "item-content" },
            ],
          },
        ],
      },
    ]);
    el.id = "instant-host";
    el.dataset.animation = "instant";
    const c = new Accordion(el, { id: el.id, value: [] });
    c.init();
    c.render();
    const content = contentEl(el);
    expect(content.hidden || content.hasAttribute("hidden")).toBe(true);
    c.destroy();
  });

  it.each(["js", "custom"] as const)("%s animation strips hidden from content props", (mode) => {
    const el = scopeTree("accordion", [
      {
        part: "root",
        children: [
          {
            part: "item",
            attrs: { "data-value": "one", id: `accordion:${mode}:item:one` },
            children: [
              { part: "item-trigger" },
              { part: "item-indicator" },
              { part: "item-content" },
            ],
          },
        ],
      },
    ]);
    el.id = mode;
    el.dataset.animation = mode;
    const c = new Accordion(el, { id: el.id, value: [] });
    c.init();
    c.render();
    expect(contentEl(el).hasAttribute("hidden")).toBe(false);
    c.destroy();
  });
});
