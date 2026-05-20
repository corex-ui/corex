import { describe, expect, it } from "vitest";
import { Avatar } from "../../components/avatar";
import { avatarTree } from "../helpers/component-smoke";

describe("Avatar", () => {
  it("render spreads fallback props", () => {
    const el = avatarTree();
    const c = new Avatar(el, { id: el.id });
    c.render();
    expect(el.querySelector('[data-part="fallback"]')).toBeTruthy();
    c.destroy();
  });
});
