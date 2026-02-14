import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { PinInput } from "../components/pin-input";
import type { Props, ValueChangeDetails } from "@zag-js/pin-input";
import type { Direction } from "@zag-js/types";
import { getString, getBoolean, getStringList, getNumber } from "../lib/util";

type PinInputHookState = {
  pinInput?: PinInput;
  handlers?: Array<CallbackRef>;
};

const PinInputHook: Hook<object & PinInputHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & PinInputHookState) {
    const el = this.el;
    const valueList = getStringList(el, "value");
    const defaultValueList = getStringList(el, "defaultValue");
    const controlled = getBoolean(el, "controlled");
    const zag = new PinInput(el, {
      id: el.id,
      count: getNumber(el, "count") ?? 4,
      ...(controlled && valueList
        ? { value: valueList }
        : { defaultValue: defaultValueList ?? [] }),
      disabled: getBoolean(el, "disabled"),
      invalid: getBoolean(el, "invalid"),
      required: getBoolean(el, "required"),
      readOnly: getBoolean(el, "readOnly"),
      mask: getBoolean(el, "mask"),
      otp: getBoolean(el, "otp"),
      blurOnComplete: getBoolean(el, "blurOnComplete"),
      selectOnFocus: getBoolean(el, "selectOnFocus"),
      name: getString(el, "name"),
      form: getString(el, "form"),
      dir: getString<Direction>(el, "dir", ["ltr", "rtl"]),
      type: getString<"alphanumeric" | "numeric" | "alphabetic">(el, "type", [
        "alphanumeric",
        "numeric",
        "alphabetic",
      ]),
      placeholder: getString(el, "placeholder"),
      onValueChange: (details: ValueChangeDetails) => {
        const hiddenInput = el.querySelector<HTMLInputElement>(
          '[data-scope="pin-input"][data-part="hidden-input"]'
        );
        if (hiddenInput) {
          hiddenInput.value = details.valueAsString;
          hiddenInput.dispatchEvent(new Event("input", { bubbles: true }));
          hiddenInput.dispatchEvent(new Event("change", { bubbles: true }));
        }
        const eventName = getString(el, "onValueChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, {
            value: details.value,
            valueAsString: details.valueAsString,
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
      onValueComplete: (details: ValueChangeDetails) => {
        const eventName = getString(el, "onValueComplete");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, {
            value: details.value,
            valueAsString: details.valueAsString,
            id: el.id,
          });
        }
      },
    } as Props);
    zag.init();
    this.pinInput = zag;
    this.handlers = [];
  },

  updated(this: object & HookInterface<HTMLElement> & PinInputHookState) {
    const valueList = getStringList(this.el, "value");
    const controlled = getBoolean(this.el, "controlled");
    this.pinInput?.updateProps({
      id: this.el.id,
      count: getNumber(this.el, "count") ?? this.pinInput?.api.count ?? 4,
      ...(controlled && valueList ? { value: valueList } : {}),
      disabled: getBoolean(this.el, "disabled"),
      invalid: getBoolean(this.el, "invalid"),
      required: getBoolean(this.el, "required"),
      readOnly: getBoolean(this.el, "readOnly"),
      name: getString(this.el, "name"),
      form: getString(this.el, "form"),
    } as Partial<Props>);
  },

  destroyed(this: object & HookInterface<HTMLElement> & PinInputHookState) {
    if (this.handlers) {
      for (const h of this.handlers) this.removeHandleEvent(h);
    }
    this.pinInput?.destroy();
  },
};

export { PinInputHook as PinInput };
