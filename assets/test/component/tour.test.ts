import { describe, expect, it } from "vitest";
import { Tour } from "../../components/tour";
import { tourTree } from "../helpers/component-smoke";

function stubVisualViewport() {
  Object.defineProperty(window, "visualViewport", {
    configurable: true,
    value: {
      width: 1024,
      height: 768,
      offsetLeft: 0,
      offsetTop: 0,
      addEventListener() {},
      removeEventListener() {},
    },
  });
}

describe("Tour", () => {
  it("renders", () => {
    stubVisualViewport();
    const el = tourTree();
    const c = new Tour(el, {
      id: el.id,
      steps: [{ id: "start", type: "dialog", title: "Hi", description: "There" }],
    });
    c.render();
    expect(el.querySelector('[data-part="root"]')).toBeTruthy();
    c.destroy();
  });
});
