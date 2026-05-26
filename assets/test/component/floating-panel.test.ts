import { describe, expect, it } from "vitest";
import { FloatingPanel } from "../../components/floating-panel";
import { floatingPanelTree } from "../helpers/component-smoke";

describe("FloatingPanel", () => {
  it("render spreads trigger and content", () => {
    const el = floatingPanelTree();
    const c = new FloatingPanel(el, { id: el.id, defaultOpen: false });
    c.render();
    expect(el.querySelector('[data-part="trigger"]')).toBeTruthy();
    expect(el.querySelector('[data-part="content"]')).toBeTruthy();
    c.destroy();
  });
});
