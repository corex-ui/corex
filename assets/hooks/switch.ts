import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { Switch } from "../components/switch";
import type { CheckedChangeDetails } from "@zag-js/switch";
import type { Direction } from "@zag-js/types";

import { getString, getBoolean } from "../lib/util";

type SwitchHookState = {
  switch?: Switch;
  handlers?: Array<CallbackRef>;
  onSetChecked?: (event: Event) => void;
};

const SwitchHook: Hook<object & SwitchHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & SwitchHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const zagSwitch = new Switch(el, {
      id: el.id,
      ...(getBoolean(el, "controlled")
        ? { checked: getBoolean(el, "checked") }
        : { defaultChecked: getBoolean(el, "defaultChecked") }),
        defaultChecked: getBoolean(el, "defaultChecked"),
      disabled: getBoolean(el, "disabled"),
      name: getString(el, "name"),
      form: getString(el, "form"),
      value: getString(el, "value"),
      dir: getString<Direction>(el, "dir", ["ltr", "rtl"]),
      invalid: getBoolean(el, "invalid"),
      required: getBoolean(el, "required"),
      readOnly: getBoolean(el, "readOnly"),
      label: getString(el, "label"),

      onCheckedChange: (details: CheckedChangeDetails) => {
        const eventName = getString(el, "onCheckedChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            checked: details.checked,
            id: el.id,
          });
        }

        const eventNameClient = getString(el, "onCheckedChangeClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
              bubbles: true,
              detail: {
                value: details,
                id: el.id,
              },
            })
          );
        }
      },
    });

    zagSwitch.init();
    this.zagSwitch = zagSwitch;

    this.onSetChecked = (event: Event) => {
      const { value } = (event as CustomEvent<{ value: boolean }>).detail;
      zagSwitch.api.setChecked(value);
    };
    el.addEventListener("phx:switch:set-checked", this.onSetChecked);

    this.handlers = [];

    this.handlers.push(
      this.handleEvent("switch_set_checked", (payload: { id?: string; value: boolean }) => {
        const targetId = payload.id;
        if (targetId && targetId !== el.id) return;
        zagSwitch.api.setChecked(payload.value);
      })
    );

    this.handlers.push(
      this.handleEvent("switch_toggle_checked", (payload: { id?: string }) => {
        const targetId = payload.id;
        if (targetId && targetId !== el.id) return;
        zagSwitch.api.toggleChecked();
      })
    );

    this.handlers.push(
      this.handleEvent("switch_checked", () => {
        this.pushEvent("switch_checked_response", {
          value: zagSwitch.api.checked,
        });
      })
    );

    this.handlers.push(
      this.handleEvent("switch_focused", () => {
        this.pushEvent("switch_focused_response", {
          value: zagSwitch.api.focused,
        });
      })
    );

    this.handlers.push(
      this.handleEvent("switch_disabled", () => {
        this.pushEvent("switch_disabled_response", {
          value: zagSwitch.api.disabled,
        });
      })
    );
  },

  updated(this: object & HookInterface<HTMLElement> & SwitchHookState) {
    this.zagSwitch?.updateProps({
      id: this.el.id,
      ...(getBoolean(this.el, "controlled")
        ? { checked: getBoolean(this.el, "checked") }
        : { defaultChecked: getBoolean(this.el, "defaultChecked") }),
      disabled: getBoolean(this.el, "disabled"),
      name: getString(this.el, "name"),
      value: getString(this.el, "value"),
      dir: getString<Direction>(this.el, "dir", ["ltr", "rtl"]),
      invalid: getBoolean(this.el, "invalid"),
      required: getBoolean(this.el, "required"),
      readOnly: getBoolean(this.el, "readOnly"),
      label: getString(this.el, "label"),
    });
  },

  destroyed(this: object & HookInterface<HTMLElement> & SwitchHookState) {
    if (this.onSetChecked) {
      this.el.removeEventListener("phx:switch:set-checked", this.onSetChecked);
    }

    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }

    this.zagSwitch?.destroy();
  },
};

export { SwitchHook as Switch };
