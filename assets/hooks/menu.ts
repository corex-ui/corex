import { Menu } from "../components/menu";
import type { SelectionDetails, OpenChangeDetails, Props } from "@zag-js/menu";

import { getString, getBoolean, getDir, canPushEvent } from "../lib/util";
import { notifyChange, readPayloadId } from "../lib/respond-to";
import { redirectCollectionItem } from "../lib/collection-hook";
import { performRedirect, readDomItemRedirect, type RedirectContext } from "../lib/redirect";
import { readPositioningOptions } from "../lib/positioning";
import { createZagLiveHook } from "../lib/zag-live-hook";

type MenuHookState = {
  menu?: Menu;
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

function renderMenuTree(menu: Menu): void {
  menu.render();
  for (const child of menu.children) {
    renderMenuTree(child);
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

/**
 * Handle a Zag menu `onSelect`. Redirect items navigate away; pushing a LiveView
 * event afterwards throws once the socket is gone. Skip notify when redirect
 * succeeds so Show/Edit can `js().navigate()` while Delete still reaches the server.
 */
export function handleMenuSelect(
  el: HTMLElement,
  details: Pick<SelectionDetails, "value">,
  liveSocket: RedirectContext["liveSocket"],
  pushEvent: (name: string, payload: Record<string, unknown>) => void
): boolean {
  const redirected =
    getBoolean(el, "redirect") && details.value
      ? redirectMenuItem(el, details.value, liveSocket)
      : false;

  if (redirected) return true;

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

  return false;
}

function redirectMenuItem(
  el: HTMLElement,
  value: string,
  liveSocket: RedirectContext["liveSocket"]
): boolean {
  if (redirectCollectionItem(el, "menu", value, liveSocket)) return true;

  const itemEl = document.querySelector<HTMLElement>(
    `[id="${CSS.escape(el.id)}:content"] [data-scope="menu"][data-part="item"][data-value="${CSS.escape(value)}"]`
  );
  return performRedirect(readDomItemRedirect(itemEl, value), { liveSocket });
}

const MenuHook = createZagLiveHook<MenuHookState, Menu>({
  key: "menu",
  mount(hook, { dom, server }) {
    const el = hook.el;

    if (el.hasAttribute("data-nested")) {
      return;
    }

    const pushEvent = hook.pushEvent.bind(hook);
    const liveSocket = hook.liveSocket;

    const buildOnSelect = () => (details: SelectionDetails) => {
      handleMenuSelect(el, details, liveSocket, pushEvent);
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

    hook.submenuWireTimer = setTimeout(() => {
      hook.submenuWireTimer = undefined;
      const rootMenu = hook.menu;
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

    dom.add<CustomEvent<{ open: boolean }>>("corex:menu:set-open", (event) => {
      const { open } = event.detail;
      if (menu.api.open !== open) menu.api.setOpen(open);
    });

    server.add("menu_set_open", (payload: { open: boolean }) => {
      if (!menuSetOpenMatches(el.id, payload)) return;
      menu.api.setOpen(payload.open);
    });

    server.add("menu_open", (payload: unknown) => {
      if (!menuSetOpenMatches(el.id, payload)) return;
      hook.pushEvent("menu_open_response", {
        id: readPayloadId(payload),
        open: menu.api.open,
      });
    });

    return menu;
  },

  update(_hook, menu) {
    syncMenuPropsFromDom(menu);
    renderMenuTree(menu);

    if (menu.children.length > 0) {
      wireSubmenuTriggersDeep(menu);
    }
  },

  destroy(hook, menu) {
    if (hook.submenuWireTimer !== undefined) {
      clearTimeout(hook.submenuWireTimer);
      hook.submenuWireTimer = undefined;
    }

    destroyDescendantMenus(menu);
  },
});

export { MenuHook as Menu };
