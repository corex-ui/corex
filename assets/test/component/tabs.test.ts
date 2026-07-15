import { describe, expect, it } from "vitest";
import { Tabs, tabsDomIds } from "../../components/tabs";
import { tabsTree } from "../helpers/component-smoke";

describe("tabsDomIds", () => {
  it("builds predictable ids", () => {
    const ids = tabsDomIds("profile");
    expect(ids.root).toBe("tabs-profile-root");
    expect(ids.trigger("home")).toBe("tabs-profile-trigger-home");
    expect(ids.content("home")).toBe("tabs-profile-content-home");
  });
});

describe("Tabs render", () => {
  it("wires trigger and content with data-value", () => {
    const el = tabsTree();
    const c = new Tabs(el, { id: el.id, defaultValue: "home" });
    c.render();
    expect(el.querySelector<HTMLElement>('[data-part="trigger"]')?.dataset.value).toBe("home");
    c.destroy();
  });

  it("applies disabled trigger props from data-disabled on item", () => {
    const el = tabsTree();
    const list = el.querySelector<HTMLElement>('[data-part="list"]');
    const trigger = el.querySelector<HTMLElement>('[data-part="trigger"]');
    expect(list).not.toBeNull();
    expect(trigger).not.toBeNull();
    list!.appendChild(trigger!);
    trigger!.dataset.disabled = "";
    const c = new Tabs(el, { id: el.id, defaultValue: "home" });
    c.init();
    expect(trigger!.hasAttribute("disabled")).toBe(true);
    expect(trigger!.getAttribute("aria-disabled")).toBe("true");
    c.destroy();
  });
});
