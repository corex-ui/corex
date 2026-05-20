import { describe, expect, it } from "vitest";
import type { Props as ToggleProps } from "@zag-js/toggle";
import { Toggle } from "../../components/toggle";
import { toggleTree } from "../helpers/component-smoke";

describe("Toggle", () => {
  it("render spreads control and indicator", () => {
    const el = toggleTree();
    const c = new Toggle(el, { id: el.id } as unknown as ToggleProps);
    c.render();
    expect(el.querySelector('[data-part="control"]')).toBeTruthy();
    expect(el.querySelector('[data-part="indicator"]')).toBeTruthy();
    c.destroy();
  });
});
