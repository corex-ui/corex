import { describe, expect, it } from "vitest";
import { Steps } from "../../components/steps";
import { stepsTree } from "../helpers/component-smoke";

describe("Steps", () => {
  it("renders", () => {
    const el = stepsTree();
    const c = new Steps(el, { id: el.id } as never);
    c.render();
    expect(el.querySelector('[data-part="root"]')).toBeTruthy();
    expect(el.querySelector('[data-part="list"]')?.getAttribute("role")).not.toBe("tablist");
    c.destroy();
  });
});
