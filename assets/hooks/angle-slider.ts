import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { AngleSlider } from "../components/angle-slider";
import type { Props, ValueChangeDetails } from "@zag-js/angle-slider";
import { getString, getBoolean, getNumber } from "../lib/util";

type AngleSliderHookState = {
  angleSlider?: AngleSlider;
  handlers?: Array<CallbackRef>;
};

const AngleSliderHook: Hook<object & AngleSliderHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & AngleSliderHookState) {
    const el = this.el;
    const value = getNumber(el, "value");
    const defaultValue = getNumber(el, "defaultValue");
    const controlled = getBoolean(el, "controlled");
    const zag = new AngleSlider(el, {
      id: el.id,
      ...(controlled && value !== undefined ? { value } : { defaultValue: defaultValue ?? 0 }),
      step: getNumber(el, "step") ?? 1,
      disabled: getBoolean(el, "disabled"),
      readOnly: getBoolean(el, "readOnly"),
      invalid: getBoolean(el, "invalid"),
      name: getString(el, "name"),
      dir: getString<"ltr" | "rtl">(el, "dir", ["ltr", "rtl"]),
      onValueChange: (details: ValueChangeDetails) => {
        const hiddenInput = el.querySelector<HTMLInputElement>(
          '[data-scope="angle-slider"][data-part="hidden-input"]'
        );
        if (hiddenInput) {
          hiddenInput.value = String(details.value);
          hiddenInput.dispatchEvent(new Event("input", { bubbles: true }));
          hiddenInput.dispatchEvent(new Event("change", { bubbles: true }));
        }
        const eventName = getString(el, "onValueChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, {
            value: details.value,
            valueAsDegree: details.valueAsDegree,
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
    this.angleSlider = zag;
    this.handlers = [];
  },

  updated(this: object & HookInterface<HTMLElement> & AngleSliderHookState) {
    const value = getNumber(this.el, "value");
    const controlled = getBoolean(this.el, "controlled");
    this.angleSlider?.updateProps({
      id: this.el.id,
      ...(controlled && value !== undefined ? { value } : {}),
      step: getNumber(this.el, "step") ?? 1,
      disabled: getBoolean(this.el, "disabled"),
      readOnly: getBoolean(this.el, "readOnly"),
      invalid: getBoolean(this.el, "invalid"),
      name: getString(this.el, "name"),
    } as Partial<Props>);
  },

  destroyed(this: object & HookInterface<HTMLElement> & AngleSliderHookState) {
    if (this.handlers) {
      for (const h of this.handlers) this.removeHandleEvent(h);
    }
    this.angleSlider?.destroy();
  },
};

export { AngleSliderHook as AngleSlider };
