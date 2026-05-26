import { describe, expect, it } from "vitest";
import { Checkbox } from "../../components/checkbox";
import { toggleInputTree } from "../helpers/component-smoke";

describe("Checkbox", () => {
  it("init renders control and hidden input", () => {
    const el = toggleInputTree("checkbox");
    const c = new Checkbox(el, { id: el.id, defaultChecked: true });
    c.init();
    expect(el.querySelector('[data-part="control"]')).toBeTruthy();
    expect(el.querySelector('[data-part="hidden-input"]')).toBeTruthy();
    c.destroy();
  });
});
