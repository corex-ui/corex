import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { NumberInput } from "../components/number-input";
import type { Props, ValueChangeDetails } from "@zag-js/number-input";
import { getString, getBoolean, getNumber } from "../lib/util";

type NumberInputHookState = {
  numberInput?: NumberInput;
  handlers?: Array<CallbackRef>;
};

const NumberInputHook: Hook<object & NumberInputHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & NumberInputHookState) {
    const el = this.el;
    const valueStr = getString(el, "value");
    const defaultValueStr = getString(el, "defaultValue");
    const controlled = getBoolean(el, "controlled");
    const zag = new NumberInput(el, {
      id: el.id,
      ...(controlled && valueStr !== undefined
        ? { value: valueStr }
        : { defaultValue: defaultValueStr }),
      min: getNumber(el, "min"),
      max: getNumber(el, "max"),
      step: getNumber(el, "step"),
      disabled: getBoolean(el, "disabled"),
      readOnly: getBoolean(el, "readOnly"),
      invalid: getBoolean(el, "invalid"),
      required: getBoolean(el, "required"),
      allowMouseWheel: getBoolean(el, "allowMouseWheel"),
      name: getString(el, "name"),
      form: getString(el, "form"),
      onValueChange: (details: ValueChangeDetails) => {
        const inputEl = el.querySelector<HTMLInputElement>(
          '[data-scope="number-input"][data-part="input"]'
        );
        if (inputEl) {
          inputEl.value = details.value;
          inputEl.dispatchEvent(new Event("input", { bubbles: true }));
          inputEl.dispatchEvent(new Event("change", { bubbles: true }));
        }
        const eventName = getString(el, "onValueChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, {
            value: details.value,
            valueAsNumber: details.valueAsNumber,
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
    this.numberInput = zag;
    this.handlers = [];
  },

  updated(this: object & HookInterface<HTMLElement> & NumberInputHookState) {
    const valueStr = getString(this.el, "value");
    const controlled = getBoolean(this.el, "controlled");
    this.numberInput?.updateProps({
      id: this.el.id,
      ...(controlled && valueStr !== undefined ? { value: valueStr } : {}),
      min: getNumber(this.el, "min"),
      max: getNumber(this.el, "max"),
      step: getNumber(this.el, "step"),
      disabled: getBoolean(this.el, "disabled"),
      readOnly: getBoolean(this.el, "readOnly"),
      invalid: getBoolean(this.el, "invalid"),
      required: getBoolean(this.el, "required"),
      name: getString(this.el, "name"),
      form: getString(this.el, "form"),
    } as Partial<Props>);
  },

  destroyed(this: object & HookInterface<HTMLElement> & NumberInputHookState) {
    if (this.handlers) {
      for (const h of this.handlers) this.removeHandleEvent(h);
    }
    this.numberInput?.destroy();
  },
};

export { NumberInputHook as NumberInput };
