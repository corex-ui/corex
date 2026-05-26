import { describe, expect, it } from "vitest";
import { SignaturePad } from "../../components/signature-pad";
import { signaturePadTree } from "../helpers/component-smoke";

describe("SignaturePad", () => {
  it("render includes segment and hidden input", () => {
    const el = signaturePadTree();
    const c = new SignaturePad(el, { id: el.id });
    c.render();
    expect(el.querySelector('[data-part="segment"]')).toBeTruthy();
    expect(el.querySelector('[data-part="hidden-input"]')).toBeTruthy();
    c.destroy();
  });

  it("applies dir from host data-dir to clear trigger after render", () => {
    const el = signaturePadTree();
    el.dataset.dir = "rtl";
    const clear = el.querySelector<HTMLElement>('[data-part="clear-trigger"]');
    clear?.setAttribute("dir", "ltr");
    const c = new SignaturePad(el, { id: el.id, dir: "rtl" });
    c.render();
    expect(clear?.getAttribute("dir")).toBe("rtl");
    c.destroy();
  });
});
