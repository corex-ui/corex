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

  it("sets data-error when import fails", async () => {
    const errorSpy = vi.spyOn(console, "error").mockImplementation(() => {});
    const hook = createLazyHook(async () => {
      throw new Error("chunk failed");
    }, "TestHook");

    const el = document.createElement("div");
    el.setAttribute("data-loading", "");
    const ctx = { el } as object & HookInterface<HTMLElement>;
    await hook.mounted!.call(ctx);
    expect(el.hasAttribute("data-loading")).toBe(false);
    expect(el.hasAttribute("data-error")).toBe(true);
    errorSpy.mockRestore();
  });

  it("sets data-error when export is missing", async () => {
    const errorSpy = vi.spyOn(console, "error").mockImplementation(() => {});
    const hook = createLazyHook(async () => ({}), "MissingHook");

    const el = document.createElement("div");
    el.setAttribute("data-loading", "");
    const ctx = { el } as object & HookInterface<HTMLElement>;
    await hook.mounted!.call(ctx);
    expect(el.hasAttribute("data-error")).toBe(true);
    errorSpy.mockRestore();
  });

  it("replays updated after mount completes", async () => {
    let resolveImport!: (value: {
      TestHook: { mounted: () => void; updated: ReturnType<typeof vi.fn>; destroyed: () => void };
    }) => void;
    const updated = vi.fn();
    const importPromise = new Promise<{
      TestHook: { mounted: () => void; updated: ReturnType<typeof vi.fn>; destroyed: () => void };
    }>((resolve) => {
      resolveImport = resolve;
    });

    const hook = createLazyHook(() => importPromise, "TestHook");
    const el = document.createElement("div");
    el.setAttribute("data-loading", "");
    const ctx = { el } as object & HookInterface<HTMLElement>;

    const mountedPromise = hook.mounted!.call(ctx);
    hook.updated!.call(ctx);
    expect(updated).not.toHaveBeenCalled();

    resolveImport({
      TestHook: { mounted() {}, updated, destroyed() {} },
    });
    await mountedPromise;
    expect(updated).toHaveBeenCalled();
  });
});
