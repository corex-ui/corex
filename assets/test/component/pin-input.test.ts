import { describe, expect, it } from "vitest";
import { PinInput } from "../../components/pin-input";
import { pinInputTree } from "../helpers/component-smoke";

describe("PinInput", () => {
  it("render spreads pin inputs in control", () => {
    const el = pinInputTree(4);
    const c = new PinInput(el, { id: el.id, count: 4 });
    c.render();
    expect(el.querySelectorAll('[data-part="input"]').length).toBe(4);
    c.destroy();
  });
});
