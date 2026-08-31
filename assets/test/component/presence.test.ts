import { describe, expect, it } from "vitest";
import { Presence } from "../../components/presence";
import { presenceTree } from "../helpers/component-smoke";

describe("Presence", () => {
  it("renders", () => {
    const el = presenceTree();
    const c = new Presence(el, { id: el.id } as never);
    c.render();
    expect(el.querySelector('[data-part="root"]')).toBeTruthy();
    c.destroy();
  });
});
