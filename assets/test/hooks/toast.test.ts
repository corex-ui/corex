import { describe, expect, it, afterEach, vi } from "vitest";
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

  it("DOM corex:toast:create ignores untrusted action payloads", () => {
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
      new CustomEvent("corex:toast:create", {
        detail: {
          id: "dom-toast",
          groupId,
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

  it("ignores create when groupId is missing or mismatched", async () => {
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
    const createHandler = hook.handleEvent.mock.calls.find(
      ([event]) => event === "toast-create"
    )?.[1];
    expect(createHandler).toBeDefined();

    createHandler!({ id: "t1", title: "No group" });
    createHandler!({ id: "t2", title: "Wrong group", groupId: "other" });
    expect(el.querySelector('[data-scope="toast"][data-part="title"]')).toBeNull();

    createHandler!({ id: "t3", title: "Ok", groupId });
    await vi.waitFor(() => {
      expect(el.querySelector('[data-scope="toast"][data-part="title"]')?.textContent).toBe("Ok");
    });

    document.body.removeChild(el);
    callHookDestroyed(Toast, hook);
  });

  it("corex:toast:create rejects trusted exec_js actions", async () => {
    const el = document.createElement("div");
    el.id = groupId;
    document.body.appendChild(el);

    const { hook } = mockHookContext(el, {
      connected: false,
      overrides: {
        groupId: "",
        handlers: [] as CallbackRef[],
        domListeners: [] as Array<{ el: HTMLElement; name: string; fn: EventListener }>,
        js: () => ({ exec: () => {} }),
      },
    });

    callHookMounted(Toast, hook);

    el.dispatchEvent(
      new CustomEvent("corex:toast:create", {
        detail: {
          id: "binding-toast",
          groupId,
          title: "Saved",
          description: "With action",
          type: "success",
          action: {
            label: "Same page",
            effects: [{ kind: "exec_js", encoded: "abc" }],
          },
        },
      })
    );

    await vi.waitFor(() => {
      const title = el.querySelector('[data-scope="toast"][data-part="title"]');
      expect(title?.textContent).toBe("Saved");
    });

    const action = el.querySelector<HTMLElement>(
      '[data-scope="toast"][data-part="action-trigger"]'
    );
    expect(action?.hidden).toBe(true);
    expect(action?.textContent ?? "").toBe("");

    document.body.removeChild(el);
    callHookDestroyed(Toast, hook);
  });
});
