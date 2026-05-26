import { describe, expect, it, vi } from "vitest";
import type { CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { createHookHandleEventRegistry } from "../../lib/hook-handlers";

describe("createHookHandleEventRegistry", () => {
  it("registers handleEvent callbacks and removes them on teardown", () => {
    const refs: symbol[] = [];
    const hook = {
      handleEvent: vi.fn((_name: string, _fn: (payload: unknown) => void) => {
        const ref = Symbol("ref");
        refs.push(ref);
        return ref as unknown as CallbackRef;
      }),
      removeHandleEvent: vi.fn(),
    };

    const registry = createHookHandleEventRegistry(hook);
    const fn = vi.fn();
    registry.add("carousel_play", fn);

    expect(hook.handleEvent).toHaveBeenCalledWith("carousel_play", fn);
    registry.teardown();
    expect(hook.removeHandleEvent).toHaveBeenCalledTimes(refs.length);
  });
});
