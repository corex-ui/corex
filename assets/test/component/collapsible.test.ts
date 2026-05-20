import { describe, expect, it } from "vitest";
import { Collapsible } from "../../components/collapsible";
import { collapsibleTree } from "../helpers/component-smoke";

describe("Collapsible", () => {
  it("render spreads trigger and content", () => {
    const el = collapsibleTree();
    const c = new Collapsible(el, { id: el.id });
    c.render();
    expect(el.querySelector('[data-part="trigger"]')).toBeTruthy();
    expect(el.querySelector('[data-part="content"]')).toBeTruthy();
    c.destroy();
  });
});
