import { describe, expect, it } from "vitest";
import { Marquee } from "../../components/marquee";

describe("Marquee", () => {
  it("buildDom clones template items and removes preview", () => {
    const el = document.createElement("div");
    el.id = "marquee-test";
    el.innerHTML = `
      <div data-part="ssr-preview">Preview</div>
      <template data-part="items-template">
        <span data-part="item">A</span>
        <span data-part="item">B</span>
      </template>
    `;
    const c = new Marquee(el, { id: el.id });
    c.buildDom();
    expect(el.querySelector('[data-part="ssr-preview"]')).toBeNull();
    expect(el.querySelector('[data-scope="marquee"][data-part="root"]')).toBeTruthy();
    c.destroy();
  });
});
