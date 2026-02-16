import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { AngleSlider } from "../components/angle-slider";
import type { Props, ValueChangeDetails } from "@zag-js/angle-slider";
import { getString, getBoolean, getNumber } from "../lib/util";

type AngleSliderHookState = {
  angleSlider?: AngleSlider;
  handlers?: Array<CallbackRef>;
  onSetValue?: (event: Event) => void;
};

const AngleSliderHook: Hook<object & AngleSliderHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & AngleSliderHookState) {
    const el = this.el;
    const value = getNumber(el, "value");
    const defaultValue = getNumber(el, "defaultValue");
    const controlled = getBoolean(el, "controlled");
    let skipNextOnValueChange = false;

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
        if (skipNextOnValueChange) {
          skipNextOnValueChange = false;
          return;
        }
        if (controlled) {
          skipNextOnValueChange = true;
          zag.api.setValue(details.value);
        } else {
          const hiddenInput = el.querySelector<HTMLInputElement>(
            '[data-scope="angle-slider"][data-part="hidden-input"]'
          );
          if (hiddenInput) {
            hiddenInput.value = String(details.value);
            hiddenInput.dispatchEvent(new Event("input", { bubbles: true }));
            hiddenInput.dispatchEvent(new Event("change", { bubbles: true }));
          }
        }
        const eventName = getString(el, "onValueChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, {
            value: details.value,
            valueAsDegree: details.valueAsDegree,
            id: el.id,
          });
        }
        const eventNameClient = getString(el, "onValueChangeClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
              bubbles: true,
              detail: { value: details, id: el.id },
            })
          );
        }
      },
      onValueChangeEnd: (details: ValueChangeDetails) => {
        if (controlled) {
          const hiddenInput = el.querySelector<HTMLInputElement>(
            '[data-scope="angle-slider"][data-part="hidden-input"]'
          );
          if (hiddenInput) {
            hiddenInput.value = String(details.value);
            hiddenInput.dispatchEvent(new Event("input", { bubbles: true }));
            hiddenInput.dispatchEvent(new Event("change", { bubbles: true }));
          }
        }
        const eventName = getString(el, "onValueChangeEnd");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, {
            value: details.value,
            valueAsDegree: details.valueAsDegree,
            id: el.id,
          });
        }
        const eventNameClient = getString(el, "onValueChangeEndClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
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

    this.onSetValue = (event: Event) => {
      const { value } = (event as CustomEvent<{ value: number }>).detail;
      zag.api.setValue(value);
    };
    el.addEventListener("phx:angle-slider:set-value", this.onSetValue);

    this.handlers.push(
      this.handleEvent(
        "angle_slider_set_value",
        (payload: { angle_slider_id?: string; value: number }) => {
          const targetId = payload.angle_slider_id;
          if (targetId) {
            const matches = el.id === targetId || el.id === `angle-slider:${targetId}`;
            if (!matches) return;
          }
          zag.api.setValue(payload.value);
        }
      )
    );

    this.handlers.push(
      this.handleEvent("angle_slider_value", () => {
        this.pushEvent("angle_slider_value_response", {
          value: zag.api.value,
          valueAsDegree: zag.api.valueAsDegree,
          dragging: zag.api.dragging,
        });
      })
    );
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
    if (this.onSetValue) {
      this.el.removeEventListener("phx:angle-slider:set-value", this.onSetValue);
    }
    if (this.handlers) {
      for (const h of this.handlers) this.removeHandleEvent(h);
    }
    this.angleSlider?.destroy();
  },
};

export { AngleSliderHook as AngleSlider };
