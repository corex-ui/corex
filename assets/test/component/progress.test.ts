import { describe, expect, it } from "vitest";
import { Progress } from "../../components/progress";
import { progressTree } from "../helpers/component-smoke";

describe("Progress", () => {
  it("renders", () => {
    const el = progressTree();
    const c = new Progress(el, { id: el.id } as never);
    c.render();
    expect(el.querySelector('[data-part="root"]')).toBeTruthy();
    c.destroy();
  });
});
