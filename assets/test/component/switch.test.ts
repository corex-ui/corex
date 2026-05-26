import { describe, expect, it } from "vitest";
import { Switch } from "../../components/switch";
import { toggleInputTree } from "../helpers/component-smoke";

describe("Switch", () => {
  it("init renders control and thumb", () => {
    const el = toggleInputTree("switch");
    const c = new Switch(el, { id: el.id, defaultChecked: false });
    c.init();
    expect(el.querySelector('[data-part="control"]')).toBeTruthy();
    expect(el.querySelector('[data-part="thumb"]')).toBeTruthy();
    c.destroy();
  });
});
