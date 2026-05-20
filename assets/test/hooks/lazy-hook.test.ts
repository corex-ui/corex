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

    const ctx = { el: document.createElement("div") } as object & HookInterface<HTMLElement>;
    await hook.mounted!.call(ctx);
    expect(mounted).toHaveBeenCalled();
  });
});
