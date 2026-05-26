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

  it("syncs form-value hidden input from api value", () => {
    const el = editableTree();
    const hidden = document.createElement("input");
    hidden.type = "hidden";
    hidden.id = `${el.id}-value`;
    hidden.setAttribute("data-part", "form-value");
    hidden.setAttribute("data-scope", "editable");
    el.appendChild(hidden);
    const c = new Editable(el, { id: el.id, defaultValue: "Saved" });
    c.init();
    expect(hidden.value).toBe("Saved");
    c.destroy();
  });
});
