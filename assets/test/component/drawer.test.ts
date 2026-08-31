import { describe, expect, it } from "vitest";
import { Drawer } from "../../components/drawer";
import { drawerTree } from "../helpers/component-smoke";

describe("Drawer", () => {
  it("render includes trigger and content", () => {
    const el = drawerTree();
    const c = new Drawer(el, { id: el.id });
    c.render();
    expect(el.querySelector('[data-part="trigger"]')).toBeTruthy();
    expect(el.querySelector('[data-part="content"]')).toBeTruthy();
    c.destroy();
  });
});
