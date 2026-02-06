import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { Tabs } from "../components/tabs";
import type { ValueChangeDetails, FocusChangeDetails, Props } from "@zag-js/tabs";
import type { Direction, Orientation } from "@zag-js/types";

import { getString, getBoolean, getStringList } from "../lib/util";

type TabsHookState = {
  tabs?: Tabs;
  handlers?: Array<CallbackRef>;
  onSetValue?: (event: Event) => void;
  wasFocused?: string | null;
};

const TabsHook: Hook<object & TabsHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & TabsHookState) {

    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);

    const tabs = new Tabs(el, 
      {
        id: el.id,
        composite: true,
        ...(getBoolean(el, "controlled")
          ? { value: getString(el, "value") }
          : { defaultValue: getString(el, "defaultValue") }),
        orientation: getString<Orientation>(el, "orientation", ["horizontal", "vertical"]),
        dir: getString<Direction>(el, "dir", ["ltr", "rtl"]),
        onValueChange: (details: ValueChangeDetails) => {
          const eventName = getString(el, "onValueChange");
          if (eventName && this.liveSocket.main.isConnected()) {
            pushEvent(eventName, {
              id: el.id,
              value: details.value ?? null,
            });
          }
          
          const eventNameClient = getString(el, "onValueChangeClient");
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
        
        onFocusChange: (details: FocusChangeDetails) => {
          const eventName = getString(el, "onFocusChange");
          if (eventName && this.liveSocket.main.isConnected()) {
            pushEvent(eventName, {
              id: el.id,
              value: details.focusedValue ?? null,
            });
          }
  
          const eventNameClient = getString(el, "onFocusChangeClient");
          if (eventNameClient) {
            el.dispatchEvent(
              new CustomEvent(eventNameClient, {
                bubbles: true,
                detail: {
                  id: el.id,
                  value: details.focusedValue ?? null,
                },
              })
            );
          }
        },
      }
    );
    tabs.init();
    this.tabs = tabs;

    this.onSetValue = (event: Event) => {
      const { value } = (event as CustomEvent<{ value: string }>).detail;
      tabs.api.setValue(value);
    };
    el.addEventListener("phx:tabs:set-value", this.onSetValue);

    this.handlers = [];

    this.handlers.push(
      this.handleEvent(
        "tabs_set_value",
        (payload: { tabs_id?: string; value: string }) => {
          const targetId = payload.tabs_id;
          if (targetId && targetId !== el.id) return;
          tabs.api.setValue(payload.value);
        }
      )
    );

    this.handlers.push(
      this.handleEvent("tabs_value", () => {
        this.pushEvent("tabs_value_response", {
          value: tabs.api.value,
        });
      })
    );

    this.handlers.push(
      this.handleEvent("tabs_focused_value", () => {
        this.pushEvent("tabs_focused_value_response", {
          value: tabs.api.focusedValue,
        });
      })
    );
  },

  updated(this: object & HookInterface<HTMLElement> & TabsHookState) {
    this.tabs?.updateProps({
      id: this.el.id,
      ...(getBoolean(this.el, "controlled")
        ? { value: getString(this.el, "value") }
        : { defaultValue: getString(this.el, "defaultValue") }),
      orientation: getString<Orientation>(this.el, "orientation", ["horizontal", "vertical"]),
      dir: getString<Direction>(this.el, "dir", ["ltr", "rtl"])
    } as Props);

    const wasFocused = this.tabs?.api?.focusedValue;
    if (wasFocused) {
        const triggerEl = this.el.querySelector(
          `[data-scope="tabs"][data-part="list"] [data-part="trigger"][data-value="${wasFocused}"]`
        ) as HTMLElement;
        
        if (triggerEl && document.activeElement !== triggerEl) {
          triggerEl.focus();
        }
    }
  },


  
  destroyed(this: object & HookInterface<HTMLElement> & TabsHookState) {
    if (this.onSetValue) {
      this.el.removeEventListener("phx:tabs:set-value", this.onSetValue);
    }

    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }

    this.tabs?.destroy();
  },
};

export { TabsHook as Tabs };
