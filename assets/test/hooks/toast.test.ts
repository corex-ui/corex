import { describe, expect, it, vi, afterEach } from "vitest";
import { parseActionSpec } from "../../hooks/toast";
import { Toast } from "../../hooks/toast";
import { getToastStore } from "../../components/toast";
import { mockLiveSocket } from "../helpers/mock-live-socket";

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

    const exec = vi.fn();
    const { ctx } = mockLiveSocket(false);
    const hook = {
      el,
      groupId: "",
      handlers: [] as symbol[],
      domListeners: [] as Array<{ el: HTMLElement; name: string; fn: EventListener }>,
      pushEvent: vi.fn(),
      js: () => ({ exec }),
      liveSocket: ctx.liveSocket,
      handleEvent: vi.fn((_name: string, _fn: (payload: unknown) => void) => Symbol("ref")),
      removeHandleEvent: vi.fn(),
    };

    Toast.mounted.call(hook);
    expect(getToastStore(groupId)).toBeDefined();
    expect(el.dataset.toastGroup).toBe("true");

    Toast.destroyed.call(hook);
    expect(getToastStore(groupId)).toBeUndefined();
    expect(el.dataset.toastGroup).toBeUndefined();
  });
});
