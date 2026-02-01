import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { Combobox } from "../components/combobox";
import type { Props, Placement, InputValueChangeDetails, OpenChangeDetails } from "@zag-js/combobox";
import { collection } from "@zag-js/combobox";
import type { Direction } from "@zag-js/types";

import { getString, getBoolean, getNumber, getStringList } from "../lib/util";

type ComboboxHookState = {
  combobox?: Combobox;
  handlers?: Array<CallbackRef>;
  allItems?: any[];
};

const ComboboxHook: Hook<object & ComboboxHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & ComboboxHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);

    const allItems = JSON.parse(el.dataset.collection || "[]");
    this.allItems = allItems;
    
    const hasGroups = allItems.some((item: any) => item.group !== undefined);
    
    const createCollection = (items: any[]) => {
      if (hasGroups) {
        return collection({
          items: items,
          itemToValue: (item: any) => item.id,
          itemToString: (item: any) => item.label,
          isItemDisabled: (item: any) => item.disabled,
          groupBy: (item: any) => item.group,
        });
      }
      
      return collection({
        items: items,
        itemToValue: (item: any) => item.id,
        itemToString: (item: any) => item.label,
        isItemDisabled: (item: any) => item.disabled,
      });
    };
    const props: Props = {
      id: el.id,
      ...(getBoolean(el, "controlled")
      ? { value: getStringList(el, "value") }
      : { defaultValue: getStringList(el, "defaultValue") }),
      ...(getBoolean(el, "controlled")
      ? { inputValue: getStringList(el, "value")?.[0] ?? "" }
      : { defaultInputValue: getStringList(el, "defaultValue")?.[0] ?? "" }),
      disabled: getBoolean(el, "disabled"),
      placeholder: getString(el, "placeholder"),
      collection: createCollection(allItems),
      alwaysSubmitOnEnter: getBoolean(el, "alwaysSubmitOnEnter"),
      autoFocus: getBoolean(el, "autoFocus"),
      closeOnSelect: getBoolean(el, "closeOnSelect"),
      dir: getString<Direction>(this.el, "dir", ["ltr", "rtl"]),
      inputBehavior: getString(this.el, "inputBehavior", ["autohighlight", "autocomplete", "none"]),
      loopFocus: getBoolean(el, "loopFocus"),
      multiple: getBoolean(el, "multiple"),
      invalid: getBoolean(el, "invalid"),
      ...(getBoolean(el, "controlled")
      ? { open: getBoolean(el, "open") }
      : { defaultOpen: getBoolean(el, "defaultOpen") }),
      name: getString(el, "name"),
      readOnly: getBoolean(el, "readOnly"),
      required: getBoolean(el, "required"),
      positioning: {
        hideWhenDetached: getBoolean(el, "hideWhenDetached"),
        strategy: getString(el, "strategy", ["absolute", "fixed"]),
        placement: getString<Placement>(el, "placement", ["top", "bottom", "left", "right"]),
        offset: {
          mainAxis: getNumber(el, "offsetMainAxis"),
          crossAxis: getNumber(el, "offsetCrossAxis"),
        },
        gutter: getNumber(el, "gutter"),
        shift: getNumber(el, "shift"),
        overflowPadding: getNumber(el, "overflowPadding"),
        flip: getBoolean(el, "flip"),
        slide: getBoolean(el, "slide"),
        overlap: getBoolean(el, "overlap"),
        sameWidth: getBoolean(el, "sameWidth"),
        fitViewport: getBoolean(el, "fitViewport"),
        
      },
      onOpenChange: (details: OpenChangeDetails) => {
        if (details.open && this.combobox) {
          this.combobox.updateProps({
            collection: createCollection(this.allItems || []),
          });
        }

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
        if (!this.combobox || !this.allItems) return;
          const filtered = this.allItems.filter((item: any) =>
          item.label.toLowerCase().includes(details.inputValue.toLowerCase()),
        );
        const currentItems = filtered.length > 0 ? filtered : this.allItems;
        this.combobox.updateProps({
          collection: createCollection(currentItems),
        });

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
    };

    const combobox = new Combobox(el, props);
    combobox.init();

    this.combobox = combobox;
    this.handlers = [];
  },

  updated(this: object & HookInterface<HTMLElement> & ComboboxHookState) {
    this.combobox?.updateProps({
      disabled: getBoolean(this.el, "disabled"),
      placeholder: getString(this.el, "placeholder"),
      name: getString(this.el, "name"),

      ...(getBoolean(this.el, "controlled")
      ? { value: getStringList(this.el, "value") }
      : { defaultValue: getStringList(this.el, "defaultValue") })
    });
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