import { describe, expect, it } from "vitest";
import { PasswordInput } from "../../components/password-input";
import { passwordInputTree } from "../helpers/component-smoke";

describe("PasswordInput", () => {
  it("render includes visibility trigger", () => {
    const el = passwordInputTree();
    const c = new PasswordInput(el, { id: el.id });
    c.render();
    expect(el.querySelector('[data-part="visibility-trigger"]')).toBeTruthy();
    c.destroy();
  });
});
