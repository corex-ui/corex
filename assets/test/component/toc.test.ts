import { describe, expect, it } from "vitest";
import { Toc } from "../../components/toc";
import { tocTree } from "../helpers/component-smoke";

describe("Toc", () => {
  it("renders", () => {
    const el = tocTree();
    const c = new Toc(el, { id: el.id } as never);
    c.render();
    expect(el.querySelector('[data-part="root"]')).toBeTruthy();
    c.destroy();
  });
});
