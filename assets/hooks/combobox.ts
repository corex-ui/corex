import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { Combobox } from "../components/combobox";
import type { Props, InputValueChangeDetails, OpenChangeDetails, ValueChangeDetails, PositioningOptions } from "@zag-js/combobox";
import type { Direction } from "@zag-js/types";

import { getString, getBoolean, getStringList } from "../lib/util";

type ComboboxHookState = {
  combobox?: Combobox;
  handlers?: Array<CallbackRef>;
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

const ComboboxHook: Hook<object & ComboboxHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & ComboboxHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);

    const allItems = JSON.parse(el.dataset.collection || "[]");
    const hasGroups = allItems.some((item: any) => item.group !== undefined);

    const props: Props = {
      id: el.id,
      ...(getBoolean(el, "controlled")
        ? { value: getStringList(el, "value") }
        : { defaultValue: getStringList(el, "defaultValue") }),
      disabled: getBoolean(el, "disabled"),
      placeholder: getString(el, "placeholder"),
      alwaysSubmitOnEnter: getBoolean(el, "alwaysSubmitOnEnter"),
      autoFocus: getBoolean(el, "autoFocus"),
      closeOnSelect: getBoolean(el, "closeOnSelect"),
      dir: getString<Direction>(el, "dir", ["ltr", "rtl"]),
      inputBehavior: getString(el, "inputBehavior", ["autohighlight", "autocomplete", "none"]),
      loopFocus: getBoolean(el, "loopFocus"),
      multiple: getBoolean(el, "multiple"),
      invalid: getBoolean(el, "invalid"),
      allowCustomValue: false,
      selectionBehavior: "replace",
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
      onOpenChange: (details: OpenChangeDetails) => {
        const eventName = getString(el, "onOpenChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            open: details.open,
            reason: details.reason,
            value: details.value,
            id: el.id,
          });
        }

        const eventNameClient = getString(el, "onOpenChangeClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
              bubbles: getBoolean(el, "bubble"),
              detail: {
                open: details.open,
                reason: details.reason,
                value: details.value,
                id: el.id,
              },
            })
          );
        }
      },
      onInputValueChange: (details: InputValueChangeDetails) => {
    
        const eventName = getString(el, "onInputValueChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            value: details.inputValue,
            reason: details.reason,
            id: el.id,
          });
        }

        const eventNameClient = getString(el, "onInputValueChangeClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
              bubbles: getBoolean(el, "bubble"),
              detail: {
                value: details.inputValue,
                reason: details.reason,
                id: el.id,
              },
            })
          );
        }
      },
      onValueChange: (details: ValueChangeDetails) => {
      
        const valueInput = el.querySelector<HTMLInputElement>(
          '[data-scope="combobox"][data-part="value-input"]'
        );
        if (valueInput) {
          const idValue = details.value.length === 0
            ? ""
            : details.value.length === 1
              ? String(details.value[0])
              : details.value.map(String).join(",");
          valueInput.value = idValue;
          
          const formId = valueInput.getAttribute("form");
          let form: HTMLFormElement | null = null;
          
          if (formId) {
            form = document.getElementById(formId) as HTMLFormElement;
          } else {
            form = valueInput.closest("form");
          }
          
          const changeEvent = new Event("change", { 
            bubbles: true, 
            cancelable: true 
          });
          valueInput.dispatchEvent(changeEvent);
          
          const inputEvent = new Event("input", { 
            bubbles: true, 
            cancelable: true 
          });
          valueInput.dispatchEvent(inputEvent);
          
           if (form && form.hasAttribute("phx-change")) {
            requestAnimationFrame(() => {
              const formElement = form.querySelector('input, select, textarea') as HTMLElement;
              if (formElement) {
                const formChangeEvent = new Event("change", { 
                  bubbles: true, 
                  cancelable: true 
                });
                formElement.dispatchEvent(formChangeEvent);
              } else {
                const formChangeEvent = new Event("change", { 
                  bubbles: true, 
                  cancelable: true 
                });
                form.dispatchEvent(formChangeEvent);
              }
            });
          }
          
        }

        const eventName = getString(el, "onValueChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
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
    };

    const combobox = new Combobox(el, props);
    combobox.hasGroups = hasGroups;
    combobox.setAllOptions(allItems);
    combobox.init();

    const initialValue = getBoolean(el, "controlled")
      ? getStringList(el, "value")
      : getStringList(el, "defaultValue");
    
    if (initialValue && initialValue.length > 0) {
      const selectedItems = allItems.filter((item: any) =>
        initialValue.includes(item.id)
      );
      if (selectedItems.length > 0) {
        const inputValue = selectedItems.map((item: any) => item.label).join(", ");
        if (combobox.api && typeof combobox.api.setInputValue === "function") {
          combobox.api.setInputValue(inputValue);
        } else {
          const inputEl = el.querySelector<HTMLInputElement>(
            '[data-scope="combobox"][data-part="input"]'
          );
          if (inputEl) {
            inputEl.value = inputValue;
          }
        }
      }
    }

    this.combobox = combobox;
    this.handlers = [];
  },

  updated(this: object & HookInterface<HTMLElement> & ComboboxHookState) {
    const newCollection = JSON.parse(this.el.dataset.collection || "[]");
    const hasGroups = newCollection.some((item: any) => item.group !== undefined);
    
    if (this.combobox) {
      this.combobox.hasGroups = hasGroups;
      this.combobox.setAllOptions(newCollection);
      this.combobox.updateProps({
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
      });
      
      const inputEl = this.el.querySelector<HTMLInputElement>(
        '[data-scope="combobox"][data-part="input"]'
      );
      if (inputEl) {
        inputEl.removeAttribute("name");
        inputEl.removeAttribute("form");
        inputEl.name = "";
      }
    }
  },

  destroyed(this: object & HookInterface<HTMLElement> & ComboboxHookState) {
    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }

    this.combobox?.destroy();
  },
};

export { ComboboxHook as Combobox };