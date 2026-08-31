import { describe, expect, it } from "vitest";
import { NavigationMenu } from "../../components/navigation-menu";
import { navigationmenuTree } from "../helpers/component-smoke";

describe("NavigationMenu", () => {
  it("renders", () => {
    const el = navigationmenuTree();
    const c = new NavigationMenu(el, { id: el.id } as never);
    c.render();
    expect(el.querySelector('[data-part="root"]')).toBeTruthy();
    c.destroy();
  });
});
