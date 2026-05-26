import { describe, expect, it } from "vitest";
import { AngleSlider } from "../../components/angle-slider";
import { angleSliderTree } from "../helpers/component-smoke";

describe("AngleSlider", () => {
  it("render updates control element", () => {
    const el = angleSliderTree();
    const c = new AngleSlider(el, { id: el.id, defaultValue: 45 });
    c.render();
    expect(el.querySelector('[data-part="control"]')).toBeTruthy();
    c.destroy();
  });
});
