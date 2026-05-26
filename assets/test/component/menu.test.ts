import { describe, expect, it } from "vitest";
import { Menu } from "../../components/menu";
import { menuTree } from "../helpers/component-smoke";

describe("Menu", () => {
  it("setChild and setParent link menu instances", () => {
    const parentEl = menuTree();
    parentEl.id = "menu-parent";
    const childEl = menuTree();
    childEl.id = "menu-child";
    const parent = new Menu(parentEl, { id: parentEl.id });
    const child = new Menu(childEl, { id: childEl.id });
    parent.setChild(child);
    child.setParent(parent);
    expect(parent.children).toContain(child);
    parent.destroy();
    child.destroy();
  });
});
