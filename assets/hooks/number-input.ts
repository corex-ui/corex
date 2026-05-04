import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { NumberInput } from "../components/number-input";
import type { Props, ValueChangeDetails } from "@zag-js/number-input";
import { getString, getBoolean, getNumber, canPushEvent, getDir } from "../lib/util";
import { notifyChange } from "../lib/respond-to";

type NumberInputHookState = {
  numberInput?: NumberInput;
};

const NumberInputHook: Hook<object & NumberInputHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & NumberInputHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
    const defaultValueStr = getString(el, "defaultValue");
    const zag = new NumberInput(el, {
      id: el.id,
      defaultValue: defaultValueStr,
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
      dir: getDir(el),
      onValueChange: (details: ValueChangeDetails) => {
        if (details.value !== undefined) {
          const valueInput = el.querySelector<HTMLInputElement>(
            '[data-scope="number-input"][data-part="value-input"]'
          );
          if (valueInput) {
            valueInput.value = details.value ?? "";
            valueInput.dispatchEvent(new Event("input", { bubbles: true }));
            valueInput.dispatchEvent(new Event("change", { bubbles: true }));
          }
        }
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: {
            id: el.id,
            value: details.value,
            valueAsNumber: details.valueAsNumber,
          },
          serverEventName: getString(el, "onValueChange"),
          clientEventName: getString(el, "onValueChangeClient"),
        });
      },
    } as Props);
    zag.init();
    this.numberInput = zag;
  },

  updated(this: object & HookInterface<HTMLElement> & NumberInputHookState) {
    const defaultValueStr = getString(this.el, "defaultValue");

    this.numberInput?.updateProps({
      id: this.el.id,
      defaultValue: defaultValueStr,
      min: getNumber(this.el, "min"),
      max: getNumber(this.el, "max"),
      step: getNumber(this.el, "step"),
      disabled: getBoolean(this.el, "disabled"),
      readOnly: getBoolean(this.el, "readOnly"),
      invalid: getBoolean(this.el, "invalid"),
      required: getBoolean(this.el, "required"),
      name: getString(this.el, "name"),
      form: getString(this.el, "form"),
      dir: getDir(this.el),
    } as Partial<Props>);
  },

  destroyed(this: object & HookInterface<HTMLElement> & NumberInputHookState) {
    this.numberInput?.destroy();
  },
};

export { NumberInputHook as NumberInput };
