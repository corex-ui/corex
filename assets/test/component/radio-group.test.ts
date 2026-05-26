import { describe, expect, it } from "vitest";
import { RadioGroup } from "../../components/radio-group";
import { el } from "../helpers/dom";
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

  it("defaultValue mount allows client value changes when simulating form field datasets", () => {
    const node = el({ formField: true, controlled: true, value: "duis" });
    const c = new RadioGroup(node, { id: "rg", defaultValue: "duis" });
    c.init();
    expect(c.api.value).toBe("duis");
    c.destroy();
  });
});
