import { describe, expect, it } from "vitest";
import { Marquee } from "../../components/marquee";

describe("Marquee", () => {
  it("buildDom appends root before removing ssr-preview", () => {
    const el = document.createElement("div");
    el.id = "marquee-test";
    el.dataset.duration = "28";
    el.innerHTML = `
      <div data-part="ssr-preview" data-orientation="horizontal">
        <span data-part="item">A</span>
        <span data-part="item">B</span>
      </div>
      <template data-part="items-template">
        <span data-part="item">A</span>
        <span data-part="item">B</span>
      </template>
    `;
    const c = new Marquee(el, { id: el.id });
    c.buildDom();
    expect(el.querySelector('[data-part="ssr-preview"]')).toBeNull();
    expect(el.querySelector('[data-scope="marquee"][data-part="root"]')).toBeTruthy();
    expect(el.querySelectorAll('[data-part="content"]').length).toBe(1);
    expect(el.querySelectorAll('[data-part="item"]').length).toBe(2);
    c.destroy();
  });

  it("init syncs contentCount tracks and honors data-duration", () => {
    const el = document.createElement("div");
    el.id = "marquee-duration";
    el.dataset.duration = "28";
    el.setAttribute("data-loading", "");
    el.innerHTML = `
      <template data-part="items-template">
        <span data-part="item">A</span>
        <span data-part="item">B</span>
      </template>
    `;
    const c = new Marquee(el, { id: el.id, autoFill: false });
    c.buildDom();
    c.init();
    const root = el.querySelector<HTMLElement>('[data-scope="marquee"][data-part="root"]');
    expect(root).toBeTruthy();
    expect(root!.style.getPropertyValue("--marquee-duration")).toBe("28s");
    expect(el.querySelectorAll(':scope > [data-scope="marquee"][data-part="root"] [data-part="content"]').length).toBe(
      c.api.contentCount
    );
    expect(el.hasAttribute("data-loading")).toBe(false);
    c.destroy();
  });

  it("ensureDom rebuilds root after it is removed", () => {
    const el = document.createElement("div");
    el.id = "marquee-rebuild";
    el.dataset.duration = "20";
    el.innerHTML = `
      <template data-part="items-template">
        <span data-part="item">A</span>
      </template>
    `;
    const c = new Marquee(el, { id: el.id, autoFill: false });
    c.buildDom();
    c.init();
    el.querySelector('[data-scope="marquee"][data-part="root"]')?.remove();
    expect(el.querySelector('[data-scope="marquee"][data-part="root"]')).toBeNull();
    c.ensureDom();
    expect(el.querySelector('[data-scope="marquee"][data-part="root"]')).toBeTruthy();
    expect(el.querySelectorAll('[data-part="item"]').length).toBeGreaterThan(0);
    c.destroy();
  });
});
