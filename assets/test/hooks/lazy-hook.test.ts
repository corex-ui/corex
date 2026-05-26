import { describe, expect, it, vi } from "vitest";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { createLazyHook } from "../../hooks/lazy-hook";

describe("createLazyHook", () => {
  it("delegates mounted to the loaded hook", async () => {
    const mounted = vi.fn();
    const hook = createLazyHook(
      async () => ({
        TestHook: { mounted, destroyed() {} },
      }),
      "TestHook"
    );

    const el = document.createElement("div");
    el.setAttribute("data-loading", "");
    const ctx = { el } as object & HookInterface<HTMLElement>;
    await hook.mounted!.call(ctx);
    expect(mounted).toHaveBeenCalled();
    expect(el.hasAttribute("data-loading")).toBe(false);
  });
});
