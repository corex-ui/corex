import { describe, expect, it, vi, afterEach, beforeEach } from "vitest";
import type { CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import * as hookModule from "../../hooks/menu";
import {
  findImmediateParentMenuHookEl,
  handleMenuSelect,
  menuSetOpenMatches,
  Menu as MenuHook,
} from "../../hooks/menu";
import { mockLiveSocket } from "../helpers/mock-live-socket";
import { Menu as MenuComponent } from "../../components/menu";
import { menuTree } from "../helpers/component-smoke";
import { expectHookModule } from "../helpers/expect-hook";
import {
  callHookDestroyed,
  callHookLifecycle,
  callHookMounted,
  mockHookContext,
} from "../helpers/mock-hook";

describe("menu hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});

describe("findImmediateParentMenuHookEl", () => {
  it("returns parent menu root with data-phx-hook", () => {
    const nested = document.createElement("div");
    const parent = document.createElement("div");
    parent.setAttribute("phx-hook", "Menu");
    parent.appendChild(nested);
    expect(findImmediateParentMenuHookEl(nested)).toBe(parent);
  });

  it("returns null when no parent menu hook", () => {
    const el = document.createElement("div");
    expect(findImmediateParentMenuHookEl(el)).toBeNull();
  });
});

describe("handleMenuSelect", () => {
  afterEach(() => {
    document.body.innerHTML = "";
    vi.unstubAllGlobals();
  });

  function rowMenuHost() {
    const el = document.createElement("div");
    el.id = "menu:tickets-row-1";
    el.setAttribute("data-redirect", "");
    el.setAttribute("data-on-select", "row_menu");

    const show = document.createElement("div");
    show.dataset.scope = "menu";
    show.dataset.part = "item";
    show.dataset.value = "show:1";
    show.setAttribute("data-to", "/en/admin/tickets/1");
    show.setAttribute("data-redirect", "navigate");
    el.appendChild(show);

    const del = document.createElement("div");
    del.dataset.scope = "menu";
    del.dataset.part = "item";
    del.dataset.value = "delete:1";
    del.setAttribute("data-redirect", "false");
    el.appendChild(del);

    document.body.appendChild(el);
    return el;
  }

  it("navigates a redirect item without pushing onSelect", () => {
    const el = rowMenuHost();
    const { ctx, navigate } = mockLiveSocket(true);
    const pushEvent = vi.fn();

    expect(handleMenuSelect(el, { value: "show:1" }, ctx.liveSocket, pushEvent)).toBe(true);
    expect(navigate).toHaveBeenCalledWith("/en/admin/tickets/1");
    expect(pushEvent).not.toHaveBeenCalled();
  });

  it("pushes onSelect when the item opts out of redirect", () => {
    const el = rowMenuHost();
    const { ctx, navigate } = mockLiveSocket(true);
    const pushEvent = vi.fn();

    expect(handleMenuSelect(el, { value: "delete:1" }, ctx.liveSocket, pushEvent)).toBe(false);
    expect(navigate).not.toHaveBeenCalled();
    expect(pushEvent).toHaveBeenCalledWith("row_menu", {
      id: "menu:tickets-row-1",
      value: "delete:1",
    });
  });
});

describe("menuSetOpenMatches", () => {
  it("matches menu root id from server payload id", () => {
    expect(menuSetOpenMatches("menu:menu-api-server", { id: "menu-api-server", open: true })).toBe(
      true
    );
  });

  it("rejects other menu roots on the same page", () => {
    expect(menuSetOpenMatches("menu:menu-api", { id: "menu-api-server", open: true })).toBe(false);
    expect(menuSetOpenMatches("menu:menu-api-js", { id: "menu-api-server", open: true })).toBe(
      false
    );
  });

  it("rejects missing payload id", () => {
    expect(menuSetOpenMatches("menu:menu-api-server", { open: true })).toBe(false);
  });
});

describe("Menu hook lifecycle", () => {
  beforeEach(() => {
    vi.useFakeTimers();
  });

  afterEach(() => {
    vi.useRealTimers();
    document.body.innerHTML = "";
  });

  it("destroyed clears pending submenu wiring timer", () => {
    const renderSpy = vi.spyOn(MenuComponent.prototype, "renderSubmenuTriggers");

    const el = document.createElement("div");
    el.id = "menu:wire-test";
    el.setAttribute("phx-hook", "Menu");

    const nested = document.createElement("div");
    nested.id = "menu:wire-sub";
    nested.dataset.scope = "menu";
    nested.dataset.nested = "menu";
    el.appendChild(nested);
    document.body.appendChild(el);

    const { hook } = mockHookContext(el, {
      connected: false,
      overrides: {
        menu: undefined as MenuComponent | undefined,
        handlers: [] as CallbackRef[],
        submenuWireTimer: undefined as ReturnType<typeof setTimeout> | undefined,
      },
    });

    callHookMounted(MenuHook, hook);
    expect(hook.submenuWireTimer).toBeDefined();

    callHookDestroyed(MenuHook, hook);
    expect(hook.menu).toBeUndefined();

    vi.runAllTimers();
    expect(renderSpy).not.toHaveBeenCalled();

    renderSpy.mockRestore();
  });

  it("menu_set_open only opens the matching menu root", () => {
    const el = document.createElement("div");
    el.id = "menu:menu-api-server";
    el.setAttribute("phx-hook", "Menu");
    document.body.appendChild(el);

    const { hook } = mockHookContext(el, {
      connected: false,
      overrides: {
        menu: undefined as MenuComponent | undefined,
        handlers: [] as CallbackRef[],
      },
    });

    callHookMounted(MenuHook, hook);
    const setOpenSpy = vi.spyOn(hook.menu!.api, "setOpen");
    const setOpenHandler = hook.handleEvent.mock.calls.find(
      ([event]) => event === "menu_set_open"
    )?.[1];
    expect(setOpenHandler).toBeDefined();

    setOpenHandler!({ id: "menu-api", open: true });
    setOpenHandler!({ id: "menu-api-server", open: true });

    expect(setOpenSpy).toHaveBeenCalledTimes(1);
    expect(setOpenSpy).toHaveBeenCalledWith(true);

    callHookDestroyed(MenuHook, hook);
    setOpenSpy.mockRestore();
  });

  it("menu_open requires matching id and includes it in the response", () => {
    const el = document.createElement("div");
    el.id = "menu:menu-api-server";
    el.setAttribute("phx-hook", "Menu");
    document.body.appendChild(el);

    const { hook } = mockHookContext(el, {
      connected: false,
      overrides: {
        menu: undefined as MenuComponent | undefined,
        handlers: [] as CallbackRef[],
      },
    });

    callHookMounted(MenuHook, hook);
    const openHandler = hook.handleEvent.mock.calls.find(([event]) => event === "menu_open")?.[1];
    expect(openHandler).toBeDefined();

    openHandler!({});
    openHandler!({ id: "other-menu" });
    expect(hook.pushEvent).not.toHaveBeenCalledWith("menu_open_response", expect.anything());

    openHandler!({ id: "menu-api-server" });
    expect(hook.pushEvent).toHaveBeenCalledWith("menu_open_response", {
      id: "menu-api-server",
      open: expect.any(Boolean),
    });

    callHookDestroyed(MenuHook, hook);
  });

  it("updated re-syncs trigger aria-disabled when native disabled toggles", () => {
    const el = menuTree();
    el.id = "menu:menu-playground";
    el.setAttribute("phx-hook", "Menu");
    document.body.appendChild(el);

    const trigger = el.querySelector<HTMLElement>('[data-part="trigger"]')!;
    const { hook } = mockHookContext(el, {
      connected: false,
      overrides: {
        menu: undefined as MenuComponent | undefined,
        handlers: [] as CallbackRef[],
      },
    });

    callHookMounted(MenuHook, hook);
    expect(trigger.getAttribute("aria-disabled")).toBe("false");
    expect(trigger.getAttribute("tabindex")).toBe("0");

    trigger.setAttribute("disabled", "");
    callHookLifecycle(MenuHook, hook, "updated");
    expect(trigger.getAttribute("aria-disabled")).toBe("true");
    expect(trigger.getAttribute("tabindex")).toBe("-1");

    trigger.removeAttribute("disabled");
    callHookLifecycle(MenuHook, hook, "updated");
    expect(trigger.hasAttribute("disabled")).toBe(false);
    expect(trigger.getAttribute("aria-disabled")).toBe("false");
    expect(trigger.getAttribute("tabindex")).toBe("0");

    callHookDestroyed(MenuHook, hook);
  });
});
