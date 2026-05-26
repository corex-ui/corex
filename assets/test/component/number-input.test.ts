import { describe, expect, it } from "vitest";
import { NumberInput } from "../../components/number-input";
import { numberInputTree } from "../helpers/component-smoke";

describe("NumberInput", () => {
  it("render spreads input control", () => {
    const el = numberInputTree();
    const c = new NumberInput(el, { id: el.id });
    c.render();
    expect(el.querySelector('[data-part="input"]')).toBeTruthy();
    c.destroy();
  });
});
