import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { RadioGroup } from "../components/radio-group";
import type { Props, ValueChangeDetails } from "@zag-js/radio-group";
import type { Direction } from "@zag-js/types";
import { getString, getBoolean } from "../lib/util";

type RadioGroupHookState = {
  radioGroup?: RadioGroup;
  handlers?: Array<CallbackRef>;
};

const RadioGroupHook: Hook<object & RadioGroupHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & RadioGroupHookState) {
    const el = this.el;
    const value = getString(el, "value");
    const defaultValue = getString(el, "defaultValue");
    const controlled = getBoolean(el, "controlled");
    const zag = new RadioGroup(el, {
      id: el.id,
      ...(controlled && value !== undefined
        ? { value: value ?? null }
        : { defaultValue: defaultValue ?? null }),
      name: getString(el, "name"),
      form: getString(el, "form"),
      disabled: getBoolean(el, "disabled"),
      invalid: getBoolean(el, "invalid"),
      required: getBoolean(el, "required"),
      readOnly: getBoolean(el, "readOnly"),
      dir: getString<Direction>(el, "dir", ["ltr", "rtl"]),
      orientation: getString<"horizontal" | "vertical">(el, "orientation", [
        "horizontal",
        "vertical",
      ]),
      onValueChange: (details: ValueChangeDetails) => {
        const eventName = getString(el, "onValueChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, {
            value: details.value,
            id: el.id,
          });
        }
        const clientName = getString(el, "onValueChangeClient");
        if (clientName) {
          el.dispatchEvent(
            new CustomEvent(clientName, {
              bubbles: true,
              detail: { value: details, id: el.id },
            })
          );
        }
      },
    } as Props);
    zag.init();
    this.radioGroup = zag;
    this.handlers = [];
  },

  updated(this: object & HookInterface<HTMLElement> & RadioGroupHookState) {
    const value = getString(this.el, "value");
    const controlled = getBoolean(this.el, "controlled");
    this.radioGroup?.updateProps({
      id: this.el.id,
      ...(controlled && value !== undefined ? { value: value ?? null } : {}),
      name: getString(this.el, "name"),
      form: getString(this.el, "form"),
      disabled: getBoolean(this.el, "disabled"),
      invalid: getBoolean(this.el, "invalid"),
      required: getBoolean(this.el, "required"),
      readOnly: getBoolean(this.el, "readOnly"),
      orientation: getString<"horizontal" | "vertical">(this.el, "orientation", [
        "horizontal",
        "vertical",
      ]),
    } as Partial<Props>);
  },

  destroyed(this: object & HookInterface<HTMLElement> & RadioGroupHookState) {
    if (this.handlers) {
      for (const h of this.handlers) this.removeHandleEvent(h);
    }
    this.radioGroup?.destroy();
  },
};

export { RadioGroupHook as RadioGroup };
