import { describe, expect, it } from "vitest";
import { HoverCard } from "../../components/hover-card";
import { hoverCardTree } from "../helpers/component-smoke";

describe("HoverCard", () => {
  it("render includes trigger and positioner", () => {
    const el = hoverCardTree();
    const c = new HoverCard(el, { id: el.id });
    c.render();
    expect(el.querySelector('[data-part="trigger"]')).toBeTruthy();
    expect(el.querySelector('[data-part="positioner"]')).toBeTruthy();
    c.destroy();
  });
});
