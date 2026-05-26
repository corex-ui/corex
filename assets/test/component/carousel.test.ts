import { describe, expect, it } from "vitest";
import { Carousel } from "../../components/carousel";
import { carouselTree } from "../helpers/component-smoke";

describe("Carousel", () => {
  it("sets inert on hidden slides after render", () => {
    const el = carouselTree(2);
    const c = new Carousel(el, { id: el.id, slideCount: 2, defaultPage: 0 });
    c.init();
    const items = el.querySelectorAll('[data-part="item"]');
    expect(items.length).toBe(2);
    c.destroy();
  });

  it("re-renders triggers and control after orientation prop change", () => {
    const el = carouselTree(3);
    const c = new Carousel(el, {
      id: el.id,
      slideCount: 3,
      defaultPage: 0,
      loop: true,
      orientation: "horizontal",
    });
    c.init();

    const prev = el.querySelector<HTMLElement>('[data-part="prev-trigger"]')!;
    const next = el.querySelector<HTMLElement>('[data-part="next-trigger"]')!;
    const control = el.querySelector<HTMLElement>('[data-part="control"]')!;

    c.updateProps({ orientation: "vertical" });

    expect(control.getAttribute("data-orientation")).toBe("vertical");
    expect(prev.hasAttribute("data-disabled")).toBe(false);
    expect(next.hasAttribute("data-disabled")).toBe(false);
    expect(prev.getAttribute("disabled")).toBeNull();
    expect(next.getAttribute("disabled")).toBeNull();

    c.destroy();
  });

  it("keeps next trigger enabled at page 0 after orientation change without loop", () => {
    const el = carouselTree(3);
    const c = new Carousel(el, {
      id: el.id,
      slideCount: 3,
      defaultPage: 0,
      loop: false,
      orientation: "horizontal",
    });
    c.init();

    const next = el.querySelector<HTMLElement>('[data-part="next-trigger"]')!;

    c.updateProps({ orientation: "vertical" });

    expect(next.getAttribute("disabled")).toBeNull();
    expect(next.hasAttribute("data-disabled")).toBe(false);

    c.destroy();
  });
});
