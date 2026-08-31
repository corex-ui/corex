import { describe, expect, it } from "vitest";
import { Popover } from "../../components/popover";
import { popoverTree } from "../helpers/component-smoke";

describe("Popover", () => {
  it("render includes trigger and positioner", () => {
    const el = popoverTree();
    const c = new Popover(el, { id: el.id });
    c.render();
    expect(el.querySelector('[data-part="trigger"]')).toBeTruthy();
    expect(el.querySelector('[data-part="positioner"]')).toBeTruthy();
    c.destroy();
  });
});
