import { describe, expect, it } from "vitest";
import { DateInput } from "../../components/date-input";
import { dateinputTree } from "../helpers/component-smoke";

describe("DateInput", () => {
  it("renders", () => {
    const el = dateinputTree();
    const c = new DateInput(el, { id: el.id } as never);
    c.render();
    expect(el.querySelector('[data-part="root"]')).toBeTruthy();
    c.destroy();
  });
});
