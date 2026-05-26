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
});
