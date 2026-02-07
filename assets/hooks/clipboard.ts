import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { Clipboard } from "../components/clipboard";
import type { ValueChangeDetails } from "@zag-js/clipboard";
import type { Direction } from "@zag-js/types";

import { getString, getNumber, getBoolean } from "../lib/util";

type ClipboardHookState = {
  clipboard?: Clipboard;
  handlers?: Array<CallbackRef>;
  onCopy?: (event: Event) => void;
  onSetValue?: (event: Event) => void;
};

const ClipboardHook: Hook<object & ClipboardHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & ClipboardHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const liveSocket = this.liveSocket;

    const clipboard = new Clipboard(el, {
      id: el.id,
      timeout: getNumber(el, "timeout"),
      ...(getBoolean(el, "controlled")
      ? { value: getString(el, "value") }
      : { defaultValue: getString(el, "defaultValue") }),

      onValueChange: (details: ValueChangeDetails) => {
        const eventName = getString(el, "onValueChange");
        if (eventName && liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            id: el.id,
            value: details.value ?? null,
          });
        }
      },
      onStatusChange: (details) => {
        const eventName = getString(el, "onStatusChange");
        if (eventName && liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            id: el.id,
            copied: details.copied,
          });
        }
        const eventNameClient = getString(el, "onStatusChangeClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
              bubbles: true,
            })
          );
        }
      },
    });

    clipboard.init();
    this.clipboard = clipboard;

    this.onCopy = () => {
      clipboard.api.copy();
    };
    el.addEventListener("phx:clipboard:copy", this.onCopy);

    this.onSetValue = (event: Event) => {
      const { value } = (event as CustomEvent<{ value: string }>).detail;
      clipboard.api.setValue(value);
    };
    el.addEventListener("phx:clipboard:set-value", this.onSetValue);

    this.handlers = [];

    this.handlers.push(
      this.handleEvent("clipboard_copy", (payload: { clipboard_id?: string }) => {
        const targetId = payload.clipboard_id;
        if (targetId && targetId !== el.id) return;
        clipboard.api.copy();
      })
    );

    this.handlers.push(
      this.handleEvent("clipboard_set_value", (payload: { clipboard_id?: string; value: string }) => {
        const targetId = payload.clipboard_id;
        if (targetId && targetId !== el.id) return;
        clipboard.api.setValue(payload.value);
      })
    );

    this.handlers.push(
      this.handleEvent("clipboard_copied", () => {
        this.pushEvent("clipboard_copied_response", {
          value: clipboard.api.copied,
        });
      })
    );
  },

  updated(this: object & HookInterface<HTMLElement> & ClipboardHookState) {
    this.clipboard?.updateProps({
      id: this.el.id,
      timeout: getNumber(this.el, "timeout"),
      ...(getBoolean(this.el, "controlled")
        ? { value: getString(this.el, "value") }
        : { defaultValue: getString(this.el, "value") }),
      dir: getString<Direction>(this.el, "dir", ["ltr", "rtl"]),
    });
  },

  destroyed(this: object & HookInterface<HTMLElement> & ClipboardHookState) {
    if (this.onCopy) {
      this.el.removeEventListener("phx:clipboard:copy", this.onCopy);
    }

    if (this.onSetValue) {
      this.el.removeEventListener("phx:clipboard:set-value", this.onSetValue);
    }

    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }

    this.clipboard?.destroy();
  },
};

export { ClipboardHook as Clipboard };
