import { describe, expect, it } from "vitest";
import { Tooltip } from "../../components/tooltip";
import { tooltipTree } from "../helpers/component-smoke";

describe("Tooltip", () => {
  it("render includes trigger and positioner", () => {
    const el = tooltipTree();
    const c = new Tooltip(el, { id: el.id });
    c.render();
    expect(el.querySelector('[data-part="trigger"]')).toBeTruthy();
    expect(el.querySelector('[data-part="positioner"]')).toBeTruthy();
    c.destroy();
  });

  it("preserves tabindex -1 on trigger after render", () => {
    const el = tooltipTree();
    const trigger = el.querySelector<HTMLElement>('[data-part="trigger"]');
    expect(trigger).toBeTruthy();
    trigger!.setAttribute("tabindex", "-1");
    const c = new Tooltip(el, { id: el.id });
    c.render();
    expect(trigger!.getAttribute("tabindex")).toBe("-1");
    c.destroy();
  });
});
