import { describe, expect, it } from "vitest";
import { Accordion } from "../../components/accordion";
import { accordionTree } from "../helpers/component-smoke";

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
});
