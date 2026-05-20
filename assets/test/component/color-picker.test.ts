import { describe, expect, it } from "vitest";
import { ColorPicker, parse } from "../../components/color-picker";
import { colorPickerTree } from "../helpers/component-smoke";

describe("color-picker parse", () => {
  it("parses hex colors", () => {
    const value = parse("#ff0000");
    expect(value).toBeTruthy();
  });
});

describe("ColorPicker", () => {
  it("render with parsed defaultValue", () => {
    const el = colorPickerTree();
    const c = new ColorPicker(el, { id: el.id, defaultValue: parse("#00ff00") });
    expect(() => c.render()).not.toThrow();
    c.destroy();
  });
});
