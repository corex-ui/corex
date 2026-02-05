import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { Select } from "../components/select";
import type { Props, ValueChangeDetails } from "@zag-js/select";
import type { Direction } from "@zag-js/types";
import type { PositioningOptions } from "@zag-js/popper";

import { getString, getBoolean, getStringList } from "../lib/util";

type SelectHookState = {
  select?: Select;
  handlers?: Array<CallbackRef>;
  wasFocused?: boolean;
};

function snakeToCamel(str: string): string {
  return str.replace(/_([a-z])/g, (_, letter) => letter.toUpperCase());
}

function transformPositioningOptions(obj: any): PositioningOptions {
  const result: any = {};
  for (const [key, value] of Object.entries(obj)) {
    const camelKey = snakeToCamel(key);
    result[camelKey] = value;
  }
  return result as PositioningOptions;
}

const SelectHook: Hook<object & SelectHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & SelectHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const allItems = JSON.parse(el.dataset.collection || "[]");
    const hasGroups = allItems.some((item: any) => item.group !== undefined);
    let selectComponent: Select | undefined;
    const hook = this;
    this.wasFocused = false;

    

    selectComponent = new Select(el, 
      {
        id: el.id,
        ...(getBoolean(el, "controlled")
          ? { value: getStringList(el, "value") }
          : { defaultValue: getStringList(el, "defaultValue") }),
        disabled: getBoolean(el, "disabled"),
        closeOnSelect: getBoolean(el, "closeOnSelect"),
        dir: getString<Direction>(el, "dir", ["ltr", "rtl"]),
        loopFocus: getBoolean(el, "loopFocus"),
        multiple: getBoolean(el, "multiple"),
        invalid: getBoolean(el, "invalid"),
        name: getString(el, "name"),
        form: getString(el, "form"),
        readOnly: getBoolean(el, "readOnly"),
        required: getBoolean(el, "required"),
        positioning: (() => {
          const positioningJson = el.dataset.positioning;
          if (positioningJson) {
            try {
              const parsed = JSON.parse(positioningJson);
              return transformPositioningOptions(parsed);
            } catch {
              return undefined;
            }
          }
          return undefined;
        })(),
        onValueChange: (details: ValueChangeDetails) => {
          const valueInput = el.querySelector<HTMLInputElement>(
            '[data-scope="select"][data-part="value-input"]'
          );
          if (valueInput) {
            valueInput.value =
              details.value.length === 0
                ? ""
                : details.value.length === 1
                  ? String(details.value[0])
                  : details.value.map(String).join(",");
            valueInput.dispatchEvent(new Event("input", { bubbles: true }));
            valueInput.dispatchEvent(new Event("change", { bubbles: true }));
          }

          const eventName = getString(el, "onValueChange");
          if (
            eventName &&
            !hook.liveSocket.main.isDead &&
            hook.liveSocket.main.isConnected()
          ) {
            pushEvent(eventName, {
              value: details.value,
              items: details.items,
              id: el.id,
            });
          }

          const eventNameClient = getString(el, "onValueChangeClient");
          if (eventNameClient) {
            el.dispatchEvent(
              new CustomEvent(eventNameClient, {
                bubbles: getBoolean(el, "bubble"),
                detail: {
                  value: details.value,
                  items: details.items,
                  id: el.id,
                },
              })
            );
          }
        },
      } as Props
    );
    selectComponent.hasGroups = hasGroups;
    selectComponent.setOptions(allItems);
    selectComponent.init();

    this.select = selectComponent;
    this.handlers = [];
  },

  beforeUpdate(this: object & HookInterface<HTMLElement> & SelectHookState) {
    this.wasFocused = this.select?.api?.focused ?? false;
  },

  updated(this: object & HookInterface<HTMLElement> & SelectHookState) {
    const newCollection = JSON.parse(this.el.dataset.collection || "[]");
    const hasGroups = newCollection.some((item: any) => item.group !== undefined);

    if (this.select) {
      this.select.hasGroups = hasGroups;
      this.select.setOptions(newCollection);

      this.select.updateProps({
        // id: this.el.id,
        ...(getBoolean(this.el, "controlled")
          ? { value: getStringList(this.el, "value") }
          : { defaultValue: getStringList(this.el, "defaultValue") }),
        // name: getString(this.el, "name"),
        // form: getString(this.el, "form"),
        disabled: getBoolean(this.el, "disabled"),
        multiple: getBoolean(this.el, "multiple"),
        dir: getString<Direction>(this.el, "dir", ["ltr", "rtl"]),
        invalid: getBoolean(this.el, "invalid"),
        required: getBoolean(this.el, "required"),
        readOnly: getBoolean(this.el, "readOnly"),
      } as Props);
      
      // this.select.render();

      if (getBoolean(this.el, "controlled")) {
        if (this.wasFocused) {
          const trigger = this.el.querySelector('[data-scope="select"][data-part="trigger"]') as HTMLElement;
          if (trigger && document.activeElement !== trigger) {
            trigger.focus();
          }
        }
      }
    }
  },



  destroyed(this: object & HookInterface<HTMLElement> & SelectHookState) {
    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }

    this.select?.destroy();
  },
};

export { SelectHook as Select };