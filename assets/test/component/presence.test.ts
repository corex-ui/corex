import { describe, expect, it, vi } from "vitest";
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

  it("closes when present becomes false", async () => {
    const el = presenceTree();
    document.body.appendChild(el);
    const c = new Presence(el, { present: true });
    c.init();
    const root = el.querySelector<HTMLElement>('[data-part="root"]')!;
    expect(root.hidden).toBe(false);
    c.updateProps({ present: false }, { force: true });
    expect(root.dataset.state).toBe("closed");
    await vi.waitFor(() => expect(c.api.present).toBe(false));
    expect(root.hidden).toBe(true);
    c.destroy();
    el.remove();
  });
});
