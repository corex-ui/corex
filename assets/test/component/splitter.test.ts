import { describe, expect, it } from "vitest";
import { Splitter } from "../../components/splitter";
import { splitterTree } from "../helpers/component-smoke";

describe("Splitter", () => {
  it("renders", () => {
    const el = splitterTree();
    const c = new Splitter(el, {
      id: el.id,
      panels: [{ id: "a" }, { id: "b" }],
      defaultSize: [50, 50],
    });
    c.render();
    expect(el.querySelector('[data-part="root"]')).toBeTruthy();
    c.destroy();
  });
});
