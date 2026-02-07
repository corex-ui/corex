import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { Collapsible } from "../components/collapsible";
import type { OpenChangeDetails } from "@zag-js/collapsible";
import type { Direction } from "@zag-js/types";

import { getString, getBoolean } from "../lib/util";

type CollapsibleHookState = {
  collapsible?: Collapsible;
  handlers?: Array<CallbackRef>;
  onSetOpen?: (event: Event) => void;
};

const CollapsibleHook: Hook<object & CollapsibleHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & CollapsibleHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);

    const collapsible = new Collapsible(el, {
      id: el.id,
      ...(getBoolean(el, "controlled")
        ? { open: getBoolean(el, "open") }
        : { defaultOpen: getBoolean(el, "defaultOpen") }),
      disabled: getBoolean(el, "disabled"),
      dir: getString<Direction>(el, "dir", ["ltr", "rtl"]),
      onOpenChange: (details: OpenChangeDetails) => {
        const eventName = getString(el, "onOpenChange");
        if (eventName && this.liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            id: el.id,
            open: details.open,
          });
        }

        const eventNameClient = getString(el, "onOpenChangeClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
              bubbles: true,
              detail: {
                id: el.id,
                open: details.open,
              },
            })
          );
        }
      },
    });

    collapsible.init();
    this.collapsible = collapsible;

    this.onSetOpen = (event: Event) => {
      const { open } = (event as CustomEvent<{ open: boolean }>).detail;
      collapsible.api.setOpen(open);
    };
    el.addEventListener("phx:collapsible:set-open", this.onSetOpen);

    this.handlers = [];

    this.handlers.push(
      this.handleEvent("collapsible_set_open", (payload: { collapsible_id?: string; open: boolean }) => {
        const targetId = payload.collapsible_id;
        if (targetId && targetId !== el.id) return;
        collapsible.api.setOpen(payload.open);
      })
    );

    this.handlers.push(
      this.handleEvent("collapsible_open", () => {
        this.pushEvent("collapsible_open_response", {
          value: collapsible.api.open,
        });
      })
    );
  },

  updated(this: object & HookInterface<HTMLElement> & CollapsibleHookState) {
    this.collapsible?.updateProps({
      id: this.el.id,
      ...(getBoolean(this.el, "controlled")
        ? { open: getBoolean(this.el, "open") }
        : { defaultOpen: getBoolean(this.el, "defaultOpen") }),
      disabled: getBoolean(this.el, "disabled"),
      dir: getString<Direction>(this.el, "dir", ["ltr", "rtl"]),
    });
  },

  destroyed(this: object & HookInterface<HTMLElement> & CollapsibleHookState) {
    if (this.onSetOpen) {
      this.el.removeEventListener("phx:collapsible:set-open", this.onSetOpen);
    }

    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }

    this.collapsible?.destroy();
  },
};

export { CollapsibleHook as Collapsible };
