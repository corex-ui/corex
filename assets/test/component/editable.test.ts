import { describe, expect, it } from "vitest";
import { Editable } from "../../components/editable";
import { editableTree } from "../helpers/component-smoke";

describe("Editable", () => {
  it("render includes preview and input parts", () => {
    const el = editableTree();
    const c = new Editable(el, { id: el.id, defaultValue: "Edit me" });
    c.render();
    expect(el.querySelector('[data-part="preview"]')).toBeTruthy();
    expect(el.querySelector('[data-part="input"]')).toBeTruthy();
    c.destroy();
  });
});
