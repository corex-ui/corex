import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { Editable } from "../components/editable";
import type { Props, ValueChangeDetails } from "@zag-js/editable";
import { getString, getBoolean, getDir } from "../lib/util";

type EditableHookState = {
  editable?: Editable;
  handlers?: Array<CallbackRef>;
};

const EditableHook: Hook<object & EditableHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & EditableHookState) {
    const el = this.el;
    const value = getString(el, "value");
    const defaultValue = getString(el, "defaultValue");
    const controlled = getBoolean(el, "controlled");
    const zag = new Editable(el, {
      id: el.id,
      ...(controlled && value !== undefined ? { value } : { defaultValue: defaultValue ?? "" }),
      disabled: getBoolean(el, "disabled"),
      readOnly: getBoolean(el, "readOnly"),
      required: getBoolean(el, "required"),
      invalid: getBoolean(el, "invalid"),
      name: getString(el, "name"),
      form: getString(el, "form"),
      dir: getDir(el),
      ...(getBoolean(el, "controlledEdit")
        ? { edit: getBoolean(el, "edit") }
        : { defaultEdit: getBoolean(el, "defaultEdit") }),
      onValueChange: (details: ValueChangeDetails) => {
        const inputEl = el.querySelector('[data-scope="editable"][data-part="input"]') as {
          value: string;
          dispatchEvent: (e: Event) => boolean;
        } | null;
        if (inputEl) {
          inputEl.value = details.value;
          inputEl.dispatchEvent(new Event("input", { bubbles: true }));
          inputEl.dispatchEvent(new Event("change", { bubbles: true }));
        }
        const eventName = getString(el, "onValueChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, { value: details.value, id: el.id });
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
    this.editable = zag;
    this.handlers = [];
  },

  updated(this: object & HookInterface<HTMLElement> & EditableHookState) {
    const value = getString(this.el, "value");
    const controlled = getBoolean(this.el, "controlled");
    this.editable?.updateProps({
      id: this.el.id,
      ...(controlled && value !== undefined ? { value } : {}),
      disabled: getBoolean(this.el, "disabled"),
      readOnly: getBoolean(this.el, "readOnly"),
      required: getBoolean(this.el, "required"),
      invalid: getBoolean(this.el, "invalid"),
      name: getString(this.el, "name"),
      form: getString(this.el, "form"),
    } as Partial<Props>);
  },

  destroyed(this: object & HookInterface<HTMLElement> & EditableHookState) {
    if (this.handlers) {
      for (const h of this.handlers) this.removeHandleEvent(h);
    }
    this.editable?.destroy();
  },
};

export { EditableHook as Editable };
