import { describe, expect, it } from "vitest";
import { RatingGroup } from "../../components/rating-group";
import { ratinggroupTree } from "../helpers/component-smoke";

describe("RatingGroup", () => {
  it("renders", () => {
    const el = ratinggroupTree();
    const c = new RatingGroup(el, { id: el.id } as never);
    c.render();
    expect(el.querySelector('[data-part="root"]')).toBeTruthy();
    c.destroy();
  });
});
