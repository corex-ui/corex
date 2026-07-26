import { describe, expect, it } from "vitest";
import { Marquee } from "../../components/marquee";

function collectIds(root: ParentNode): string[] {
  return Array.from(root.querySelectorAll("[id]"))
    .map((el) => el.id)
    .filter((id) => id.length > 0);
}

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

  it("adopts live ssr-preview items as content copy 0", () => {
    const el = document.createElement("div");
    el.id = "marquee-adopt";
    el.dataset.duration = "20";
    el.innerHTML = `
      <div data-part="ssr-preview" data-orientation="horizontal">
        <div data-part="item" id="live-item-a">
          <button id="live-btn" phx-hook="Combobox" name="country">A</button>
        </div>
        <div data-part="item" id="live-item-b">B</div>
      </div>
      <template data-part="items-template">
        <div data-part="item" id="live-item-a">
          <button id="live-btn" phx-hook="Combobox" name="country">A</button>
        </div>
        <div data-part="item" id="live-item-b">B</div>
      </template>
    `;
    const liveItemA = el.querySelector("#live-item-a") as HTMLElement;
    const liveBtn = el.querySelector("#live-btn") as HTMLElement;
    const c = new Marquee(el, { id: el.id, autoFill: false });
    c.buildDom();
    c.init();

    const primary = el.querySelector<HTMLElement>('[data-part="content"][data-index="0"]');
    expect(primary).toBeTruthy();
    expect(primary!.querySelector("#live-item-a")).toBe(liveItemA);
    expect(primary!.querySelector("#live-btn")).toBe(liveBtn);
    expect(liveBtn.getAttribute("phx-hook")).toBe("Combobox");
    expect(liveBtn.getAttribute("name")).toBe("country");

    const clones = Array.from(
      el.querySelectorAll<HTMLElement>('[data-part="content"]:not([data-index="0"])')
    );
    expect(clones.length).toBeGreaterThan(0);
    for (const clone of clones) {
      expect(clone.inert).toBe(true);
      expect(clone.querySelector("#live-item-a")).toBeNull();
      expect(clone.querySelector("#live-btn")).toBeNull();
      expect(clone.querySelector("[phx-hook]")).toBeNull();
      expect(clone.querySelector("[name]")).toBeNull();
    }

    const ids = collectIds(el);
    expect(new Set(ids).size).toBe(ids.length);
    expect(ids).toContain("live-item-a");
    expect(ids).toContain("live-btn");

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
    expect(
      el.querySelectorAll(':scope > [data-scope="marquee"][data-part="root"] [data-part="content"]')
        .length
    ).toBe(c.api.contentCount);
    expect(el.hasAttribute("data-loading")).toBe(false);

    const cloneContents = el.querySelectorAll<HTMLElement>(
      '[data-part="content"]:not([data-index="0"])'
    );
    cloneContents.forEach((content) => {
      expect(content.inert).toBe(true);
    });

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
