import { describe, expect, it } from "vitest";
import { Progress } from "../../components/progress";
import { progressTree } from "../helpers/component-smoke";

describe("Progress", () => {
  it("renders", () => {
    const el = progressTree();
    const c = new Progress(el, { id: el.id, value: 40 } as never);
    c.render();
    expect(el.querySelector('[data-part="root"]')).toBeTruthy();
    const root = el.querySelector<HTMLElement>('[data-part="root"]');
    expect(root?.style.getPropertyValue("--percent") || root?.getAttribute("style")).toBeTruthy();
    c.destroy();
  });
});
