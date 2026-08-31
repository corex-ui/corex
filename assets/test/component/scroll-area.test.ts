import { describe, expect, it } from "vitest";
import { ScrollArea } from "../../components/scroll-area";
import { scrollareaTree } from "../helpers/component-smoke";

describe("ScrollArea", () => {
  it("renders", () => {
    const el = scrollareaTree();
    const c = new ScrollArea(el, { id: el.id } as never);
    c.render();
    expect(el.querySelector('[data-part="root"]')).toBeTruthy();
    c.destroy();
  });
});
