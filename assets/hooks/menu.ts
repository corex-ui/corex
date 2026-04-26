import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { Menu } from "../components/menu";
import type { SelectionDetails, OpenChangeDetails, Props } from "@zag-js/menu";

import { getString, getBoolean, getDir, canPushEvent } from "../lib/util";
import { performRedirect, readDomItemRedirect } from "../lib/redirect";
import { readPositioningOptions } from "../lib/positioning";

type MenuHookState = {
  menu?: Menu;
  handlers?: Array<CallbackRef>;
  onSetOpen?: (event: Event) => void;
  onSubmenuItemClick?: (event: Event) => void;
  nestedMenus?: Map<string, Menu>;
};

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

      const eventName = getString(el, "onSelect");
      if (eventName && canPushEvent(liveSocket)) {
        pushEvent(eventName, {
          id: el.id,
          value: details.value ?? null,
        });
      }

      const eventNameClient = getString(el, "onSelectClient");
      if (eventNameClient) {
        el.dispatchEvent(
          new CustomEvent(eventNameClient, {
            bubbles: true,
            detail: {
              id: el.id,
              value: details.value ?? null,
            },
          })
        );
      }
    };

    const menu = new Menu(el, {
      id: el.id.replace("menu:", ""),
      closeOnSelect: getBoolean(el, "closeOnSelect"),
      loopFocus: getBoolean(el, "loopFocus"),
      typeahead: getBoolean(el, "typeahead"),
      composite: getBoolean(el, "composite"),
      defaultHighlightedValue: getString(el, "defaultHighlightedValue"),
      dir: getDir(el),
      positioning: readPositioningOptions(el),
      onSelect: buildOnSelect(),
      onOpenChange: (details: OpenChangeDetails) => {
        const eventName = getString(el, "onOpenChange");
        if (eventName && canPushEvent(liveSocket)) {
          pushEvent(eventName, {
            id: el.id,
            open: details.open ?? false,
          });
        }

        const eventNameClient = getString(el, "onOpenChangeClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
              bubbles: true,
              detail: {
                id: el.id,
                open: details.open ?? false,
              },
            })
          );
        }
      },
    });
    menu.init();
    this.menu = menu;

    this.nestedMenus = new Map();
    const nestedMenuElements = el.querySelectorAll<HTMLElement>(
      '[data-scope="menu"][data-nested="menu"]'
    );

    const nestedMenuInstances: Menu[] = [];
    nestedMenuElements.forEach((nestedEl, index) => {
      const nestedId = nestedEl.id;
      if (nestedId) {
        const nestedMenuId = `${nestedId}-${index}`;
        const nestedMenu = new Menu(nestedEl, {
          id: nestedMenuId,
          dir: getDir(nestedEl),
          closeOnSelect: getBoolean(nestedEl, "closeOnSelect"),
          loopFocus: getBoolean(nestedEl, "loopFocus"),
          typeahead: getBoolean(nestedEl, "typeahead"),
          composite: getBoolean(nestedEl, "composite"),
          positioning: readPositioningOptions(nestedEl),
          onSelect: buildOnSelect(),
        });

        nestedMenu.init();
        this.nestedMenus?.set(nestedId, nestedMenu);
        nestedMenuInstances.push(nestedMenu);
      }
    });

    setTimeout(() => {
      nestedMenuInstances.forEach((nestedMenu) => {
        if (this.menu) {
          this.menu.setChild(nestedMenu);
          nestedMenu.setParent(this.menu);
        }
      });

      if (this.menu && this.menu.children.length > 0) {
        this.menu.renderSubmenuTriggers();
      }
    }, 0);

    this.onSetOpen = (event: Event) => {
      const { open } = (event as CustomEvent<{ open: boolean }>).detail;
      if (menu.api.open !== open) menu.api.setOpen(open);
    };
    el.addEventListener("corex:menu:set-open", this.onSetOpen);

    this.handlers = [];

    this.handlers.push(
      this.handleEvent("menu_set_open", (payload: { menu_id?: string; open: boolean }) => {
        const targetId = payload.menu_id;
        const matches = !targetId || el.id === targetId || el.id === `menu:${targetId}`;
        if (!matches) return;
        menu.api.setOpen(payload.open);
      })
    );

    this.handlers.push(
      this.handleEvent("menu_open", () => {
        this.pushEvent("menu_open_response", {
          open: menu.api.open,
        });
      })
    );
  },

  updated(this: object & HookInterface<HTMLElement> & MenuHookState) {
    if (this.el.hasAttribute("data-nested")) return;

    this.menu?.updateProps({
      id: this.el.id,
      closeOnSelect: getBoolean(this.el, "closeOnSelect"),
      loopFocus: getBoolean(this.el, "loopFocus"),
      typeahead: getBoolean(this.el, "typeahead"),
      composite: getBoolean(this.el, "composite"),
      defaultHighlightedValue: getString(this.el, "defaultHighlightedValue"),
      dir: getDir(this.el),
      positioning: readPositioningOptions(this.el),
    } as Props);
  },

  destroyed(this: object & HookInterface<HTMLElement> & MenuHookState) {
    if (this.el.hasAttribute("data-nested")) return;

    if (this.onSetOpen) {
      this.el.removeEventListener("corex:menu:set-open", this.onSetOpen);
    }

    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }

    if (this.nestedMenus) {
      for (const [, nestedMenu] of this.nestedMenus) {
        nestedMenu.destroy();
      }
    }

    this.menu?.destroy();
  },
};

export { MenuHook as Menu };
