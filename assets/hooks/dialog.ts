import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { Dialog } from "../components/dialog";
import type { OpenChangeDetails } from "@zag-js/dialog";
import type { Direction } from "@zag-js/types";

import { getString, getBoolean } from "../lib/util";

type DialogHookState = {
  dialog?: Dialog;
  handlers?: Array<CallbackRef>;
  onSetOpen?: (event: Event) => void;
};

const DialogHook: Hook<object & DialogHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & DialogHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);

    const dialog = new Dialog(el, {
      id: el.id,
      ...(getBoolean(el, "controlled")
        ? { open: getBoolean(el, "open") }
        : { defaultOpen: getBoolean(el, "defaultOpen") }),
      modal: getBoolean(el, "modal"),
      closeOnInteractOutside: getBoolean(el, "closeOnInteractOutside"),
      closeOnEscape: getBoolean(el, "closeOnEscapeKeyDown"),
      preventScroll: getBoolean(el, "preventScroll"),
      restoreFocus: getBoolean(el, "restoreFocus"),
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

    dialog.init();
    this.dialog = dialog;

    this.onSetOpen = (event: Event) => {
      const { open } = (event as CustomEvent<{ open: boolean }>).detail;
      dialog.api.setOpen(open);
    };
    el.addEventListener("phx:dialog:set-open", this.onSetOpen);

    this.handlers = [];

    this.handlers.push(
      this.handleEvent("dialog_set_open", (payload: { dialog_id?: string; open: boolean }) => {
        const targetId = payload.dialog_id;
        if (targetId && targetId !== el.id) return;
        dialog.api.setOpen(payload.open);
      })
    );

    this.handlers.push(
      this.handleEvent("dialog_open", () => {
        this.pushEvent("dialog_open_response", {
          value: dialog.api.open,
        });
      })
    );
  },

  updated(this: object & HookInterface<HTMLElement> & DialogHookState) {
    this.dialog?.updateProps({
      id: this.el.id,
      ...(getBoolean(this.el, "controlled")
        ? { open: getBoolean(this.el, "open") }
        : { defaultOpen: getBoolean(this.el, "defaultOpen") }),
      modal: getBoolean(this.el, "modal"),
      closeOnInteractOutside: getBoolean(this.el, "closeOnInteractOutside"),
      closeOnEscape: getBoolean(this.el, "closeOnEscapeKeyDown"),
      preventScroll: getBoolean(this.el, "preventScroll"),
      restoreFocus: getBoolean(this.el, "restoreFocus"),
      dir: getString<Direction>(this.el, "dir", ["ltr", "rtl"]),
    });
  },

  destroyed(this: object & HookInterface<HTMLElement> & DialogHookState) {
    if (this.onSetOpen) {
      this.el.removeEventListener("phx:dialog:set-open", this.onSetOpen);
    }

    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }

    this.dialog?.destroy();
  },
};

export { DialogHook as Dialog };
