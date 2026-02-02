import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { Accordion } from "../components/accordion";
import type { ValueChangeDetails, FocusChangeDetails, Props } from "@zag-js/accordion";
import type { Direction, Orientation } from "@zag-js/types";

import { getString, getBoolean, getStringList } from "../lib/util";

type AccordionHookState = {
  accordion?: Accordion;
  handlers?: Array<CallbackRef>;
  onSetValue?: (event: Event) => void;
  wasFocused?: string | null;
};

const AccordionHook: Hook<object & AccordionHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & AccordionHookState) {

    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);

    const accordion = new Accordion(el, 
      {
        id: el.id,
        ...(getBoolean(el, "controlled")
          ? { value: getStringList(el, "value") }
          : { defaultValue: getStringList(el, "defaultValue") }),
        collapsible: getBoolean(el, "collapsible"),
        disabled: getBoolean(el, "disabled"),
        multiple: getBoolean(el, "multiple"),
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
              value: details.value ?? null,
            });
          }
  
          const eventNameClient = getString(el, "onFocusChangeClient");
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
      }
    );
    accordion.init();
    this.accordion = accordion;

    this.onSetValue = (event: Event) => {
      const { value } = (event as CustomEvent<{ value: string[] }>).detail;
      accordion.api.setValue(value);
    };
    el.addEventListener("phx:accordion:set-value", this.onSetValue);

    this.handlers = [];

    this.handlers.push(
      this.handleEvent(
        "accordion_set_value",
        (payload: { accordion_id?: string; value: string[] }) => {
          const targetId = payload.accordion_id;
          if (targetId && targetId !== el.id) return;
          accordion.api.setValue(payload.value);
        }
      )
    );

    this.handlers.push(
      this.handleEvent("accordion_value", () => {
        this.pushEvent("accordion_value_response", {
          value: accordion.api.value,
        });
      })
    );

    this.handlers.push(
      this.handleEvent("accordion_focused_value", () => {
        this.pushEvent("accordion_focused_value_response", {
          value: accordion.api.focusedValue,
        });
      })
    );
  },

  updated(this: object & HookInterface<HTMLElement> & AccordionHookState) {
    this.accordion?.updateProps({
      id: this.el.id,
      ...(getBoolean(this.el, "controlled")
        ? { value: getStringList(this.el, "value") }
        : { defaultValue: getStringList(this.el, "defaultValue") }),
      collapsible: getBoolean(this.el, "collapsible"),
      disabled: getBoolean(this.el, "disabled"),
      multiple: getBoolean(this.el, "multiple"),
      orientation: getString<Orientation>(this.el, "orientation", ["horizontal", "vertical"]),
      dir: getString<Direction>(this.el, "dir", ["ltr", "rtl"])
    } as Props);

    const wasFocused = this.accordion?.api?.focusedValue;
    if (wasFocused) {
        const triggerEl = this.el.querySelector(
          `[data-scope="accordion"][data-part="item-trigger"][id*="${wasFocused}"]`
        ) as HTMLElement;
        
        if (triggerEl && document.activeElement !== triggerEl) {
          triggerEl.focus();
        }
    }
  },


  
  destroyed(this: object & HookInterface<HTMLElement> & AccordionHookState) {
    if (this.onSetValue) {
      this.el.removeEventListener("phx:accordion:set-value", this.onSetValue);
    }

    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }

    this.accordion?.destroy();
  },
};

export { AccordionHook as Accordion };
