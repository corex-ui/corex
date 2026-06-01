import { describe, expect, it, vi, afterEach } from "vitest";
import { Menu } from "../../components/menu";
import { menuTree } from "../helpers/component-smoke";

function nestedMenuFixture() {
  const parentEl = document.createElement("div");
  parentEl.id = "menu:parent";
  parentEl.setAttribute("phx-hook", "Menu");

  const content = document.createElement("div");
  content.dataset.scope = "menu";
  content.dataset.part = "content";

  const trigger = document.createElement("div");
  trigger.dataset.scope = "menu";
  trigger.dataset.part = "item";
  trigger.dataset.value = "sub";
  trigger.dataset.nestedMenu = "child";
  content.appendChild(trigger);
  parentEl.appendChild(content);

  const childEl = document.createElement("div");
  childEl.id = "menu:child";
  childEl.setAttribute("phx-hook", "Menu");
  parentEl.appendChild(childEl);

  return { parentEl, childEl };
}

describe("Menu", () => {
  afterEach(() => {
    document.body.innerHTML = "";
  });

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

  it("renderSubmenuTriggers replaces subscriptions on repeat calls", () => {
    const { parentEl, childEl } = nestedMenuFixture();
    document.body.appendChild(parentEl);

    const parent = new Menu(parentEl, { id: "parent" });
    const child = new Menu(childEl, { id: "child" });
    parent.init();
    child.init();
    parent.setChild(child);

    const parentUnsubs: ReturnType<typeof vi.fn>[] = [];
    const childUnsubs: ReturnType<typeof vi.fn>[] = [];
    vi.spyOn(parent.machine, "subscribe").mockImplementation(() => {
      const unsub = vi.fn();
      parentUnsubs.push(unsub);
      return unsub;
    });
    vi.spyOn(child.machine, "subscribe").mockImplementation(() => {
      const unsub = vi.fn();
      childUnsubs.push(unsub);
      return unsub;
    });

    parent.renderSubmenuTriggers();
    expect(parentUnsubs).toHaveLength(1);
    expect(childUnsubs).toHaveLength(1);

    parent.renderSubmenuTriggers();
    expect(parentUnsubs[0]).toHaveBeenCalledTimes(1);
    expect(childUnsubs[0]).toHaveBeenCalledTimes(1);
    expect(parentUnsubs).toHaveLength(2);
    expect(childUnsubs).toHaveLength(2);

    parent.destroy();
    child.destroy();
  });

  it("destroy clears submenu trigger subscriptions", () => {
    const { parentEl, childEl } = nestedMenuFixture();
    document.body.appendChild(parentEl);

    const parent = new Menu(parentEl, { id: "parent" });
    const child = new Menu(childEl, { id: "child" });
    parent.init();
    child.init();
    parent.setChild(child);

    const parentUnsubs: ReturnType<typeof vi.fn>[] = [];
    vi.spyOn(parent.machine, "subscribe").mockImplementation(() => {
      const unsub = vi.fn();
      parentUnsubs.push(unsub);
      return unsub;
    });
    vi.spyOn(child.machine, "subscribe").mockImplementation(() => vi.fn());

    parent.renderSubmenuTriggers();
    parent.destroy();
    expect(parentUnsubs[0]).toHaveBeenCalledTimes(1);

    child.destroy();
  });
});
