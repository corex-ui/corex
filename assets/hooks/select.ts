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
          const redirect = getBoolean(el, "redirect");
          const firstValue =
            details.value.length > 0 ? String(details.value[0]) : null;
          const firstItem = details.items?.length ? details.items[0] : null;
          const itemRedirect = firstItem && typeof firstItem === "object" && firstItem !== null && "redirect" in firstItem ? (firstItem as { redirect?: boolean }).redirect : undefined;
          const itemNewTab = firstItem && typeof firstItem === "object" && firstItem !== null && "new_tab" in firstItem ? (firstItem as { new_tab?: boolean }).new_tab : undefined;
          const doRedirect = redirect && firstValue && hook.liveSocket.main.isDead && itemRedirect !== false;
          const openInNewTab = itemNewTab === true;
          if (doRedirect) {
            if (openInNewTab) {
              window.open(firstValue, "_blank", "noopener,noreferrer");
            } else {
              window.location.href = firstValue;
            }
          }
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

       

          const payload: Record<string, unknown> = {
            value: details.value,
            items: details.items,
            id: el.id,
          };

          const encodedJS = el.getAttribute("data-on-value-change-js");
          if (encodedJS) {
            let js = encodedJS;
            const indexMatches = [...js.matchAll(/__VALUE_(\d+)__/g)].map((m) => parseInt(m[1], 10));
            const uniqueIndices = [...new Set(indexMatches)].sort((a, b) => b - a);
            for (const i of uniqueIndices) {
              const val = details.value[i];
              const str = val !== undefined && val !== null ? String(val) : "";
              const escaped = JSON.stringify(str).slice(1, -1);
              js = js.split(`__VALUE_${i}__`).join(escaped);
            }
            js = js.split("__VALUE__").join(JSON.stringify(details.value));
            hook.liveSocket.execJS(el, js);
          }

          const clientEventName = getString(el, "onValueChangeClient");
          if (clientEventName) {
            el.dispatchEvent(
              new CustomEvent(clientEventName, { bubbles: true, detail: payload })
            );
          }

          const serverEventName = getString(el, "onValueChange");
          if (
            serverEventName &&
            !hook.liveSocket.main.isDead &&
            hook.liveSocket.main.isConnected()
          ) {
            this.pushEvent(serverEventName, payload);
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
        id: this.el.id,
        ...(getBoolean(this.el, "controlled")
          ? { value: getStringList(this.el, "value") }
          : { defaultValue: getStringList(this.el, "defaultValue") }),
        name: getString(this.el, "name"),
        form: getString(this.el, "form"),
        disabled: getBoolean(this.el, "disabled"),
        multiple: getBoolean(this.el, "multiple"),
        dir: getString<Direction>(this.el, "dir", ["ltr", "rtl"]),
        invalid: getBoolean(this.el, "invalid"),
        required: getBoolean(this.el, "required"),
        readOnly: getBoolean(this.el, "readOnly"),
      } as Props);
      
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