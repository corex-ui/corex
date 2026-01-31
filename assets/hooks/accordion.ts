import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { Accordion } from "../components/accordion";
import type { ValueChangeDetails, Props } from "@zag-js/accordion";
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
    const props: Props = {
      id: el.id,
      defaultValue: getStringList(el, "defaultValue"),
      value: getStringList(el, "value"),
      collapsible: getBoolean(el, "collapsible"),
      disabled: getBoolean(el, "disabled"),
      multiple: getBoolean(el, "multiple"),
      orientation: getString<Orientation>(el, "orientation", ["horizontal", "vertical"]),
      dir: getString<Direction>(el, "dir", ["ltr", "rtl"]),
      onValueChange: (details: ValueChangeDetails) => {
        const eventName = getString(el, "onValueChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            value: details.value,
            accordion_id: el.id,
          });
        }

        const eventNameClient = getString(el, "onValueChangeClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
              bubbles: true,
              detail: {
                value: details.value,
                accordion_id: el.id,
              },
            })
          );
        }
      },
    };

    const accordion = new Accordion(el, props);
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
      defaultValue: getStringList(this.el, "defaultValue"),
      value: getStringList(this.el, "value"),
      collapsible: getBoolean(this.el, "collapsible"),
      disabled: getBoolean(this.el, "disabled"),
      multiple: getBoolean(this.el, "multiple"),
      orientation: getString<Orientation>(this.el, "orientation", ["horizontal", "vertical"]),
      dir: getString<Direction>(this.el, "dir", ["ltr", "rtl"]),
    });
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
