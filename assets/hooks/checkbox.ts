import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { Checkbox } from "../components/checkbox";
import type { CheckedChangeDetails } from "@zag-js/checkbox";
import type { Direction } from "@zag-js/types";

import { getString, getBoolean } from "../lib/util";

type CheckboxHookState = {
  checkbox?: Checkbox;
  handlers?: Array<CallbackRef>;
  onSetChecked?: (event: Event) => void;
  onToggleChecked?: () => void;
  wasFocused?: boolean;
};

const CheckboxHook: Hook<object & CheckboxHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & CheckboxHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    this.wasFocused = false;
    
    const indeterminateAttr = el.getAttribute("data-indeterminate");
    const indeterminate = indeterminateAttr !== null && indeterminateAttr !== "false";
    
    const checkedValue = getBoolean(el, "checked");
    const defaultCheckedValue = getBoolean(el, "defaultChecked");
    
    let checkedProp: boolean | "indeterminate" | undefined;
    let defaultCheckedProp: boolean | "indeterminate" | undefined;
    
    if (indeterminate) {
      if (getBoolean(el, "controlled")) {
        checkedProp = "indeterminate";
      } else {
        defaultCheckedProp = "indeterminate";
      }
    } else {
      if (getBoolean(el, "controlled")) {
        checkedProp = checkedValue;
      } else {
        defaultCheckedProp = defaultCheckedValue;
      }
    }
    
    const zagCheckbox = new Checkbox(el, {
      id: el.id,
      ...(checkedProp !== undefined ? { checked: checkedProp } : {}),
      ...(defaultCheckedProp !== undefined ? { defaultChecked: defaultCheckedProp } : {}),
      disabled: getBoolean(el, "disabled"),
      name: getString(el, "name"),
      form: getString(el, "form"),
      value: getString(el, "value"),
      dir: getString<Direction>(el, "dir", ["ltr", "rtl"]),
      invalid: getBoolean(el, "invalid"),
      required: getBoolean(el, "required"),
      readOnly: getBoolean(el, "readOnly"),

      onCheckedChange: (details: CheckedChangeDetails) => {
        const eventName = getString(el, "onCheckedChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            checked: details.checked,
            id: el.id,
          });
        }

        const eventNameClient = getString(el, "onCheckedChangeClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
              bubbles: true,
              detail: {
                value: details,
                id: el.id,
              },
            })
          );
        }
      },
    });

    zagCheckbox.init();
    this.checkbox = zagCheckbox;

    this.onSetChecked = (event: Event) => {
      const { checked } = (event as CustomEvent<{ checked: boolean }>).detail;
      zagCheckbox.api.setChecked(checked);
    };
    el.addEventListener("phx:checkbox:set-checked", this.onSetChecked);

    this.onToggleChecked = () => {
      zagCheckbox.api.toggleChecked();
    };
    el.addEventListener("phx:checkbox:toggle-checked", this.onToggleChecked);

    this.handlers = [];

    this.handlers.push(
      this.handleEvent("checkbox_set_checked", (payload: { id?: string; checked: boolean }) => {
        const targetId = payload.id;
        if (targetId && targetId !== el.id) return;
        zagCheckbox.api.setChecked(payload.checked);
      })
    );

    this.handlers.push(
      this.handleEvent("checkbox_toggle_checked", (payload: { id?: string }) => {
        const targetId = payload.id;
        if (targetId && targetId !== el.id) return;
        zagCheckbox.api.toggleChecked();
      })
    );

    this.handlers.push(
      this.handleEvent("checkbox_checked", () => {
        this.pushEvent("checkbox_checked_response", {
          value: zagCheckbox.api.checked,
        });
      })
    );

    this.handlers.push(
      this.handleEvent("checkbox_focused", () => {
        this.pushEvent("checkbox_focused_response", {
          value: zagCheckbox.api.focused,
        });
      })
    );

    this.handlers.push(
      this.handleEvent("checkbox_disabled", () => {
        this.pushEvent("checkbox_disabled_response", {
          value: zagCheckbox.api.disabled,
        });
      })
    );
  },

  beforeUpdate() {
    this.wasFocused = this.checkbox?.api.focused ?? false;
  },
  updated(this: object & HookInterface<HTMLElement> & CheckboxHookState) {
 
    this.checkbox?.updateProps({
      id: this.el.id,
      ...(getBoolean(this.el, "controlled")
        ? { checked: getBoolean(this.el, "checked") }
        : { defaultChecked: getBoolean(this.el, "defaultChecked") }),
      disabled: getBoolean(this.el, "disabled"),
      name: getString(this.el, "name"),
      form: getString(this.el, "form"),
      value: getString(this.el, "value"),
      dir: getString<Direction>(this.el, "dir", ["ltr", "rtl"]),
      invalid: getBoolean(this.el, "invalid"),
      required: getBoolean(this.el, "required"),
      readOnly: getBoolean(this.el, "readOnly"),
      label: getString(this.el, "label"),
    });
    if (getBoolean(this.el, "controlled")) {
      if (this.wasFocused) {
        const hiddenInput = this.el.querySelector('[data-part="hidden-input"]') as HTMLInputElement;
        hiddenInput?.focus();
      }
    }
  },

  destroyed(this: object & HookInterface<HTMLElement> & CheckboxHookState) {
    if (this.onSetChecked) {
      this.el.removeEventListener("phx:checkbox:set-checked", this.onSetChecked);
    }

    if (this.onToggleChecked) {
      this.el.removeEventListener("phx:checkbox:toggle-checked", this.onToggleChecked);
    }

    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }

    this.checkbox?.destroy();
  },
};

export { CheckboxHook as Checkbox };
