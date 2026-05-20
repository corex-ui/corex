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
});
