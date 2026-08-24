import { describe, expect, it } from "vitest";
import { Slider } from "../../components/slider";
import { sliderTree } from "../helpers/component-smoke";

describe("Slider", () => {
  it("render updates control and value text", () => {
    const el = sliderTree();
    const c = new Slider(el, { id: el.id, defaultValue: [30] });
    c.render();
    expect(el.querySelector('[data-part="control"]')).toBeTruthy();
    expect(el.querySelector('[data-part="value"]')?.textContent).toBe("30");
    c.destroy();
  });

  it("render updates range thumbs", () => {
    const el = sliderTree(2);
    const c = new Slider(el, { id: el.id, defaultValue: [20, 80] });
    c.render();
    expect(el.querySelectorAll('[data-part="thumb"]').length).toBe(2);
    expect(el.querySelector('[data-part="value"]')?.textContent).toBe("20 – 80");
    c.destroy();
  });
});
