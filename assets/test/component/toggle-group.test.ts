import { describe, expect, it } from "vitest";
import { ToggleGroup } from "../../components/toggle-group";
import { toggleGroupTree } from "../helpers/component-smoke";

describe("ToggleGroup", () => {
  it("render spreads item parts", () => {
    const el = toggleGroupTree();
    const c = new ToggleGroup(el, { id: el.id });
    c.render();
    expect(el.querySelector('[data-part="item"]')).toBeTruthy();
    c.destroy();
  });
});
