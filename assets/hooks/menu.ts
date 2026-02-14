import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { Menu } from "../components/menu";
import type { SelectionDetails, OpenChangeDetails, Props } from "@zag-js/menu";
import type { Direction } from "@zag-js/types";

import { getString, getBoolean } from "../lib/util";

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
    const getMain = () => this.liveSocket?.main;

    const menu = new Menu(el, {
      id: el.id.replace("menu:", ""),
      ...(getBoolean(el, "controlled")
        ? { open: getBoolean(el, "open") }
        : { defaultOpen: getBoolean(el, "defaultOpen") }),
      closeOnSelect: getBoolean(el, "closeOnSelect"),
      loopFocus: getBoolean(el, "loopFocus"),
      typeahead: getBoolean(el, "typeahead"),
      composite: getBoolean(el, "composite"),
      dir: getString<Direction>(el, "dir", ["ltr", "rtl"]),
      onSelect: (details: SelectionDetails) => {
        const redirect = getBoolean(el, "redirect");
        const itemEl = [
          ...el.querySelectorAll<HTMLElement>('[data-scope="menu"][data-part="item"]'),
        ].find((node) => node.getAttribute("data-value") === details.value);
        const itemRedirect = itemEl?.getAttribute("data-redirect");
        const itemNewTab = itemEl?.hasAttribute("data-new-tab");
        const main = getMain();
        const doRedirect =
          redirect && details.value && (main?.isDead ?? true) && itemRedirect !== "false";
        if (doRedirect) {
          if (itemNewTab) {
            window.open(details.value, "_blank", "noopener,noreferrer");
          } else {
            window.location.href = details.value;
          }
        }
        const eventName = getString(el, "onSelect");
        if (eventName && main && !main.isDead && main.isConnected()) {
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
      },
      onOpenChange: (details: OpenChangeDetails) => {
        const main = getMain();
        const eventName = getString(el, "onOpenChange");
        if (eventName && main && !main.isDead && main.isConnected()) {
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
          dir: getString<Direction>(nestedEl, "dir", ["ltr", "rtl"]),
          closeOnSelect: getBoolean(nestedEl, "closeOnSelect"),
          loopFocus: getBoolean(nestedEl, "loopFocus"),
          typeahead: getBoolean(nestedEl, "typeahead"),
          composite: getBoolean(nestedEl, "composite"),
          onSelect: (details: SelectionDetails) => {
            const redirect = getBoolean(el, "redirect");
            const itemEl = [
              ...el.querySelectorAll<HTMLElement>('[data-scope="menu"][data-part="item"]'),
            ].find((node) => node.getAttribute("data-value") === details.value);
            const itemRedirect = itemEl?.getAttribute("data-redirect");
            const itemNewTab = itemEl?.hasAttribute("data-new-tab");
            const main = getMain();
            const doRedirect =
              redirect && details.value && (main?.isDead ?? true) && itemRedirect !== "false";
            if (doRedirect) {
              if (itemNewTab) {
                window.open(details.value, "_blank", "noopener,noreferrer");
              } else {
                window.location.href = details.value;
              }
            }
            const eventName = getString(el, "onSelect");
            if (eventName && main && !main.isDead && main.isConnected()) {
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
          },
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
    el.addEventListener("phx:menu:set-open", this.onSetOpen);

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
      ...(getBoolean(this.el, "controlled")
        ? { open: getBoolean(this.el, "open") }
        : { defaultOpen: getBoolean(this.el, "defaultOpen") }),
      closeOnSelect: getBoolean(this.el, "closeOnSelect"),
      loopFocus: getBoolean(this.el, "loopFocus"),
      typeahead: getBoolean(this.el, "typeahead"),
      composite: getBoolean(this.el, "composite"),
      dir: getString<Direction>(this.el, "dir", ["ltr", "rtl"]),
    } as Props);
  },

  destroyed(this: object & HookInterface<HTMLElement> & MenuHookState) {
    if (this.el.hasAttribute("data-nested")) return;

    if (this.onSetOpen) {
      this.el.removeEventListener("phx:menu:set-open", this.onSetOpen);
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
