import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { Menu } from "../components/menu";
import type { SelectionDetails, OpenChangeDetails, Props } from "@zag-js/menu";

import { getString, getBoolean, getDir, canPushEvent } from "../lib/util";
import { notifyChange, readPayloadId } from "../lib/respond-to";
import { performRedirect, readDomItemRedirect } from "../lib/redirect";
import { readPositioningOptions } from "../lib/positioning";

type MenuHookState = {
  menu?: Menu;
  handlers?: Array<CallbackRef>;
  onSetOpen?: (event: Event) => void;
  onSubmenuItemClick?: (event: Event) => void;
  submenuWireTimer?: ReturnType<typeof setTimeout>;
};

export function findImmediateParentMenuHookEl(nestedEl: HTMLElement): HTMLElement | null {
  let node: HTMLElement | null = nestedEl.parentElement;
  while (node) {
    if (node.getAttribute("phx-hook") === "Menu") {
      return node;
    }
    node = node.parentElement;
  }
  return null;
}

function wireSubmenuTriggersDeep(menu: Menu): void {
  menu.renderSubmenuTriggers();
  for (const child of menu.children) {
    wireSubmenuTriggersDeep(child);
  }
}

function syncMenuPropsFromDom(menu: Menu): void {
  const hookEl = menu.el;
  menu.updateProps({
    id: hookEl.id.replace(/^menu:/, ""),
    closeOnSelect: getBoolean(hookEl, "closeOnSelect"),
    loopFocus: getBoolean(hookEl, "loopFocus"),
    typeahead: getBoolean(hookEl, "typeahead"),
    composite: getBoolean(hookEl, "composite"),
    defaultHighlightedValue: getString(hookEl, "defaultHighlightedValue"),
    dir: getDir(hookEl),
    positioning: readPositioningOptions(hookEl),
  } as Props);
  for (const child of menu.children) {
    syncMenuPropsFromDom(child);
  }
}

function destroyDescendantMenus(menu: Menu): void {
  for (const child of [...menu.children]) {
    destroyDescendantMenus(child);
    child.destroy();
  }
}

export function menuSetOpenMatches(elId: string, payload: unknown): boolean {
  const targetId = readPayloadId(payload);
  if (!targetId) return false;
  return elId === targetId || elId === `menu:${targetId}`;
}

const MenuHook: Hook<object & MenuHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & MenuHookState) {
    const el = this.el;

    if (el.hasAttribute("data-nested")) {
      return;
    }

    const pushEvent = this.pushEvent.bind(this);
    const liveSocket = this.liveSocket;

    const buildOnSelect = () => (details: SelectionDetails) => {
      if (getBoolean(el, "redirect") && details.value) {
        const itemEl = el.querySelector<HTMLElement>(
          `[data-scope="menu"][data-part="item"][data-value="${CSS.escape(details.value)}"]`
        );
        performRedirect(readDomItemRedirect(itemEl, details.value), { liveSocket });
      }

      notifyChange({
        el,
        canPushServer: canPushEvent(liveSocket),
        pushEvent,
        payload: {
          id: el.id,
          value: details.value ?? null,
        },
        serverEventName: getString(el, "onSelect"),
        clientEventName: getString(el, "onSelectClient"),
      });
    };

    const menu = new Menu(el, {
      id: el.id.replace(/^menu:/, ""),
      closeOnSelect: getBoolean(el, "closeOnSelect"),
      loopFocus: getBoolean(el, "loopFocus"),
      typeahead: getBoolean(el, "typeahead"),
      composite: getBoolean(el, "composite"),
      defaultHighlightedValue: getString(el, "defaultHighlightedValue"),
      dir: getDir(el),
      positioning: readPositioningOptions(el),
      onSelect: buildOnSelect(),
      onOpenChange: (details: OpenChangeDetails) => {
        notifyChange({
          el,
          canPushServer: canPushEvent(liveSocket),
          pushEvent,
          payload: {
            id: el.id,
            open: details.open ?? false,
          },
          serverEventName: getString(el, "onOpenChange"),
          clientEventName: getString(el, "onOpenChangeClient"),
        });
      },
    });
    menu.init();
    this.menu = menu;

    const nestedMenuElements = el.querySelectorAll<HTMLElement>(
      '[data-scope="menu"][data-nested="menu"]'
    );

    const menuByHookId = new Map<string, Menu>();
    const nestedMenuInstances: Menu[] = [];

    nestedMenuElements.forEach((nestedEl) => {
      const hookId = nestedEl.id;
      if (!hookId) return;

      const nestedMenu = new Menu(nestedEl, {
        id: hookId.replace(/^menu:/, ""),
        dir: getDir(nestedEl),
        closeOnSelect: getBoolean(nestedEl, "closeOnSelect"),
        loopFocus: getBoolean(nestedEl, "loopFocus"),
        typeahead: getBoolean(nestedEl, "typeahead"),
        composite: getBoolean(nestedEl, "composite"),
        positioning: readPositioningOptions(nestedEl),
        onSelect: buildOnSelect(),
      });

      nestedMenu.init();
      menuByHookId.set(hookId, nestedMenu);
      nestedMenuInstances.push(nestedMenu);
    });

    this.submenuWireTimer = setTimeout(() => {
      this.submenuWireTimer = undefined;
      const rootMenu = this.menu;
      if (!rootMenu) return;

      nestedMenuInstances.forEach((nestedMenu) => {
        const nestedEl = nestedMenu.el;
        const parentHookEl = findImmediateParentMenuHookEl(nestedEl);
        if (!parentHookEl) return;

        const parentMenu = parentHookEl === el ? rootMenu : menuByHookId.get(parentHookEl.id);
        if (!parentMenu) return;

        parentMenu.setChild(nestedMenu);
        nestedMenu.setParent(parentMenu);
      });

      if (rootMenu.children.length > 0) {
        wireSubmenuTriggersDeep(rootMenu);
      }
    }, 0);

    this.onSetOpen = (event: Event) => {
      const { open } = (event as CustomEvent<{ open: boolean }>).detail;
      if (menu.api.open !== open) menu.api.setOpen(open);
    };
    el.addEventListener("corex:menu:set-open", this.onSetOpen);

    this.handlers = [];

    this.handlers.push(
      this.handleEvent("menu_set_open", (payload: { open: boolean }) => {
        if (!menuSetOpenMatches(el.id, payload)) return;
        menu.api.setOpen(payload.open);
      })
    );

    this.handlers.push(
      this.handleEvent("menu_open", (payload: unknown) => {
        if (!menuSetOpenMatches(el.id, payload)) return;
        this.pushEvent("menu_open_response", {
          id: readPayloadId(payload),
          open: menu.api.open,
        });
      })
    );
  },

  updated(this: object & HookInterface<HTMLElement> & MenuHookState) {
    if (this.el.hasAttribute("data-nested")) return;
    if (!this.menu) return;

    syncMenuPropsFromDom(this.menu);

    if (this.menu.children.length > 0) {
      wireSubmenuTriggersDeep(this.menu);
    }
  },

  destroyed(this: object & HookInterface<HTMLElement> & MenuHookState) {
    if (this.el.hasAttribute("data-nested")) return;

    if (this.submenuWireTimer !== undefined) {
      clearTimeout(this.submenuWireTimer);
      this.submenuWireTimer = undefined;
    }

    if (this.onSetOpen) {
      this.el.removeEventListener("corex:menu:set-open", this.onSetOpen);
    }

    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }

    if (this.menu) {
      destroyDescendantMenus(this.menu);
      this.menu.destroy();
      this.menu = undefined;
    }
  },
};

export { MenuHook as Menu };
