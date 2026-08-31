import { describe, expect, it, vi } from "vitest";
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

  it("start() opens content", async () => {
    stubVisualViewport();
    const el = tourTree();
    document.body.appendChild(el);
    const c = new Tour(el, {
      id: el.id,
      steps: [{ id: "start", type: "dialog", title: "Hi", description: "There" }],
    });
    c.init();
    expect(c.api.open).toBe(false);
    c.api.start();
    await vi.waitFor(() => expect(c.api.open).toBe(true));
    expect(c.api.step?.title).toBe("Hi");
    c.destroy();
    el.remove();
  });
});
