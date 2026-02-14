import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { ToggleGroup } from "../components/toggle-group";
import type { ValueChangeDetails, Props } from "@zag-js/toggle-group";
import type { Direction, Orientation } from "@zag-js/types";

import { getString, getBoolean, getStringList } from "../lib/util";

type ToggleGroupHookState = {
  toggleGroup?: ToggleGroup;
  handlers?: Array<CallbackRef>;
  onSetValue?: (event: Event) => void;
};

const ToggleGroupHook: Hook<object & ToggleGroupHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & ToggleGroupHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const props: Props = {
      id: el.id,
      ...(getBoolean(el, "controlled")
        ? { value: getStringList(el, "value") }
        : { defaultValue: getStringList(el, "defaultValue") }),
      defaultValue: getStringList(el, "defaultValue"),
      deselectable: getBoolean(el, "deselectable"),
      loopFocus: getBoolean(el, "loopFocus"),
      rovingFocus: getBoolean(el, "rovingFocus"),
      disabled: getBoolean(el, "disabled"),
      multiple: getBoolean(el, "multiple"),
      orientation: getString<Orientation>(el, "orientation", ["horizontal", "vertical"]),
      dir: getString<Direction>(el, "dir", ["ltr", "rtl"]),
      onValueChange: (details: ValueChangeDetails) => {
        const eventName = getString(el, "onValueChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            value: details.value,
            id: el.id,
          });
        }

        const eventNameClient = getString(el, "onValueChangeClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
              bubbles: true,
              detail: {
                value: details.value,
                id: el.id,
              },
            })
          );
        }
      },
    };

    const toggleGroup = new ToggleGroup(el, props);
    toggleGroup.init();
    this.toggleGroup = toggleGroup;

    this.onSetValue = (event: Event) => {
      const { value } = (event as CustomEvent<{ value: string[] }>).detail;
      toggleGroup.api.setValue(value);
    };
    el.addEventListener("phx:toggle-group:set-value", this.onSetValue);

    this.handlers = [];

    this.handlers.push(
      this.handleEvent("toggle-group_set_value", (payload: { id?: string; value: string[] }) => {
        const targetId = payload.id;
        if (targetId && targetId !== el.id) return;
        toggleGroup.api.setValue(payload.value);
      })
    );

    this.handlers.push(
      this.handleEvent("toggle-group:value", () => {
        this.pushEvent("toggle-group:value_response", {
          value: toggleGroup.api.value,
        });
      })
    );
  },

  updated(this: object & HookInterface<HTMLElement> & ToggleGroupHookState) {
    this.toggleGroup?.updateProps({
      ...(getBoolean(this.el, "controlled")
        ? { value: getStringList(this.el, "value") }
        : { defaultValue: getStringList(this.el, "defaultValue") }),
      deselectable: getBoolean(this.el, "deselectable"),
      loopFocus: getBoolean(this.el, "loopFocus"),
      rovingFocus: getBoolean(this.el, "rovingFocus"),
      disabled: getBoolean(this.el, "disabled"),
      multiple: getBoolean(this.el, "multiple"),
      orientation: getString<Orientation>(this.el, "orientation", ["horizontal", "vertical"]),
      dir: getString<Direction>(this.el, "dir", ["ltr", "rtl"]),
    });
  },

  destroyed(this: object & HookInterface<HTMLElement> & ToggleGroupHookState) {
    if (this.onSetValue) {
      this.el.removeEventListener("phx:toggle-group:set-value", this.onSetValue);
    }

    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }

    this.toggleGroup?.destroy();
  },
};

export { ToggleGroupHook as ToggleGroup };
