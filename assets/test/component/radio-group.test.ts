import { describe, expect, it } from "vitest";
import { RadioGroup } from "../../components/radio-group";
import { radioGroupTree } from "../helpers/component-smoke";

describe("RadioGroup", () => {
  it("render spreads item with data-value", () => {
    const el = radioGroupTree();
    const c = new RadioGroup(el, { id: el.id });
    c.render();
    const item = el.querySelector<HTMLElement>('[data-part="item"]');
    expect(item?.dataset.value).toBe("a");
    c.destroy();
  });
});
