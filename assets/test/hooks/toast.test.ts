import { describe, expect, it, afterEach } from "vitest";
import type { CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { parseActionSpec, Toast } from "../../hooks/toast";
import { getToastStore } from "../../components/toast";
import { callHookDestroyed, callHookMounted, mockHookContext } from "../helpers/mock-hook";

describe("parseActionSpec", () => {
  it("parses valid exec_js action", () => {
    expect(
      parseActionSpec({
        label: "Undo",
        effects: [{ kind: "exec_js", encoded: "abc" }],
      })
    ).toEqual({ label: "Undo", encoded: "abc" });
  });

  it("includes className when present", () => {
    expect(
      parseActionSpec({
        label: "Go",
        class: " button--sm ",
        effects: [{ kind: "exec_js", encoded: "x" }],
      })
    ).toEqual({ label: "Go", encoded: "x", className: "button--sm" });
  });

  it("returns null for invalid shape", () => {
    expect(parseActionSpec(null)).toBeNull();
    expect(parseActionSpec({ label: "" })).toBeNull();
    expect(parseActionSpec({ label: "X", effects: [] })).toBeNull();
    expect(parseActionSpec({ label: "X", effects: [{ kind: "other", encoded: "x" }] })).toBeNull();
  });
});

describe("Toast hook lifecycle", () => {
  const groupId = "toast-hook-dispose-test";

  afterEach(() => {
    document.getElementById(groupId)?.remove();
  });

  it("destroyed disposes the toast group store", () => {
    const el = document.createElement("div");
    el.id = groupId;
    document.body.appendChild(el);

    const { hook } = mockHookContext(el, {
      connected: false,
      overrides: {
        groupId: "",
        handlers: [] as CallbackRef[],
        domListeners: [] as Array<{ el: HTMLElement; name: string; fn: EventListener }>,
      },
    });

    callHookMounted(Toast, hook);
    expect(getToastStore(groupId)).toBeDefined();
    expect(el.dataset.toastGroup).toBe("true");

    callHookDestroyed(Toast, hook);
    expect(getToastStore(groupId)).toBeUndefined();
    expect(el.dataset.toastGroup).toBeUndefined();
  });
});
