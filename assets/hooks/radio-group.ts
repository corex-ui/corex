import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { RadioGroup } from "../components/radio-group";
import type { Props, ValueChangeDetails } from "@zag-js/radio-group";
import { getString, getBoolean, getDir, canPushEvent } from "../lib/util";
import { readStringControlledZagProps, readStringControlledZagUpdate } from "../lib/read-props";
import { notifyChange } from "../lib/respond-to";

type RadioGroupHookState = {
  radioGroup?: RadioGroup;
};

function valueChangePayload(el: HTMLElement, details: ValueChangeDetails): Record<string, unknown> {
  return {
    id: el.id,
    value: details.value,
  };
}

const RadioGroupHook: Hook<object & RadioGroupHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & RadioGroupHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
    const zag = new RadioGroup(el, {
      id: el.id,
      ...readStringControlledZagProps(el, "value", "defaultValue"),
      name: getString(el, "name"),
      form: getString(el, "form"),
      disabled: getBoolean(el, "disabled"),
      invalid: getBoolean(el, "invalid"),
      required: getBoolean(el, "required"),
      readOnly: getBoolean(el, "readOnly"),
      dir: getDir(el),
      orientation: getString<"horizontal" | "vertical">(el, "orientation"),
      onValueChange: (details: ValueChangeDetails) => {
        const checked = el.querySelector<HTMLInputElement>(
          '[data-scope="radio-group"][data-part="item-hidden-input"]:checked'
        );
        if (checked) {
          checked.dispatchEvent(new Event("input", { bubbles: true }));
          checked.dispatchEvent(new Event("change", { bubbles: true }));
        }
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: valueChangePayload(el, details),
          serverEventName: getString(el, "onValueChange"),
          clientEventName: getString(el, "onValueChangeClient"),
        });
      },
    } as Props);
    zag.init();
    this.radioGroup = zag;
  },

  updated(this: object & HookInterface<HTMLElement> & RadioGroupHookState) {
    this.radioGroup?.updateProps({
      id: this.el.id,
      ...readStringControlledZagUpdate(this.el, "value", "defaultValue"),
      name: getString(this.el, "name"),
      form: getString(this.el, "form"),
      disabled: getBoolean(this.el, "disabled"),
      invalid: getBoolean(this.el, "invalid"),
      required: getBoolean(this.el, "required"),
      readOnly: getBoolean(this.el, "readOnly"),
      orientation: getString<"horizontal" | "vertical">(this.el, "orientation"),
      dir: getDir(this.el),
    } as Partial<Props>);
  },

  destroyed(this: object & HookInterface<HTMLElement> & RadioGroupHookState) {
    this.radioGroup?.destroy();
  },
};

export { RadioGroupHook as RadioGroup };
