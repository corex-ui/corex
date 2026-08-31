import { describe, expect, it } from "vitest";
import { CascadeSelect } from "../../components/cascade-select";
import { cascadeselectTree } from "../helpers/component-smoke";

describe("CascadeSelect", () => {
  it("renders", () => {
    const el = cascadeselectTree();
    const c = new CascadeSelect(el, {
      id: el.id,
      rootNode: { value: "root", label: "root", children: [{ value: "a", label: "A" }] },
    });
    c.render();
    expect(el.querySelector('[data-part="root"]')).toBeTruthy();
    c.destroy();
  });
});
