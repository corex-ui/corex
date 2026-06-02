import { describe, expect, it, afterEach } from "vitest";
import type { CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import {
  parseActionSpec,
  parseDomActionSpec,
  parseServerActionSpec,
  Toast,
} from "../../hooks/toast";
import { getToastStore } from "../../components/toast";
import { callHookDestroyed, callHookMounted, mockHookContext } from "../helpers/mock-hook";

describe("parseServerActionSpec", () => {
  it("parses valid exec_js action", () => {
    expect(
      parseServerActionSpec({
        label: "Undo",
        effects: [{ kind: "exec_js", encoded: "abc" }],
      })
    ).toEqual({ label: "Undo", encoded: "abc" });
  });

  it("includes className when present", () => {
    expect(
      parseServerActionSpec({
        label: "Go",
        class: " button--sm ",
        effects: [{ kind: "exec_js", encoded: "x" }],
      })
    ).toEqual({ label: "Go", encoded: "x", className: "button--sm" });
  });

  it("includes labelHtml when present", () => {
    expect(
      parseServerActionSpec({
        label: "<span>Open</span>",
        labelHtml: true,
        effects: [{ kind: "exec_js", encoded: "x" }],
      })
    ).toEqual({ label: "<span>Open</span>", encoded: "x", labelHtml: true });
  });

  it("returns null for invalid shape", () => {
    expect(parseServerActionSpec(null)).toBeNull();
    expect(parseServerActionSpec({ label: "" })).toBeNull();
    expect(parseServerActionSpec({ label: "X", effects: [] })).toBeNull();
    expect(
      parseServerActionSpec({ label: "X", effects: [{ kind: "other", encoded: "x" }] })
    ).toBeNull();
  });
});

describe("parseDomActionSpec", () => {
  it("rejects all action payloads including labelHtml and exec_js", () => {
    expect(parseDomActionSpec(null)).toBeNull();
    expect(
      parseDomActionSpec({
        label: "<img src=x onerror=alert(1)>",
        labelHtml: true,
        effects: [{ kind: "exec_js", encoded: "evil" }],
      })
    ).toBeNull();
    expect(
      parseDomActionSpec({
        label: "Undo",
        effects: [{ kind: "exec_js", encoded: "abc" }],
      })
    ).toBeNull();
  });
});

describe("parseActionSpec", () => {
  it("aliases parseServerActionSpec", () => {
    expect(parseActionSpec).toBe(parseServerActionSpec);
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

  it("DOM toast:create ignores untrusted action payloads", () => {
    const el = document.createElement("div");
    el.id = groupId;
    document.body.appendChild(el);

    const execJs = () => {
      throw new Error("execJs should not run");
    };

    const { hook } = mockHookContext(el, {
      connected: false,
      overrides: {
        groupId: "",
        handlers: [] as CallbackRef[],
        domListeners: [] as Array<{ el: HTMLElement; name: string; fn: EventListener }>,
        js: () => ({ exec: execJs }),
      },
    });

    callHookMounted(Toast, hook);

    el.dispatchEvent(
      new CustomEvent("toast:create", {
        detail: {
          id: "dom-toast",
          title: "Hello",
          action: {
            label: '<img src=x onerror="window.__toastDomXss=1">',
            labelHtml: true,
            effects: [{ kind: "exec_js", encoded: "evil" }],
          },
        },
      })
    );

    const action = el.querySelector<HTMLElement>(
      '[data-scope="toast"][data-part="action-trigger"]'
    );
    expect(action).toBeNull();

    document.body.removeChild(el);
    callHookDestroyed(Toast, hook);
  });
});
