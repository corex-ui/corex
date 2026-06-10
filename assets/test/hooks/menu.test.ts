import { describe, expect, it, vi, afterEach, beforeEach } from "vitest";
import type { CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import * as hookModule from "../../hooks/menu";
import {
  findImmediateParentMenuHookEl,
  menuSetOpenMatches,
  Menu as MenuHook,
} from "../../hooks/menu";
import { Menu as MenuComponent } from "../../components/menu";
import { expectHookModule } from "../helpers/expect-hook";
import { callHookDestroyed, callHookMounted, mockHookContext } from "../helpers/mock-hook";

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
});
