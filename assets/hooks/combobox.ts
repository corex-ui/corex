import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { Combobox } from "../components/combobox";
import type { Props } from "@zag-js/combobox";
import * as comboboxZag from "@zag-js/combobox";

import { getString, getBoolean } from "../lib/util";

type ComboboxHookState = {
  combobox?: Combobox;
  handlers?: Array<CallbackRef>;
  allItems?: any[];
};

const ComboboxHook: Hook<object & ComboboxHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & ComboboxHookState) {
    const el = this.el;
    
    const allItems = JSON.parse(el.dataset.collection || "[]");
    this.allItems = allItems;
    
    const createCollection = (items: any[]) => {
      return comboboxZag.collection({
        items: items,
        itemToValue: (item: any) => item.code,
        itemToString: (item: any) => item.label,
      });
    };
    
    const props: Props = {
      id: el.id,
      disabled: getBoolean(el, "disabled"),
      placeholder: getString(el, "placeholder"),
      collection: createCollection(allItems),
      onOpenChange: (details) => {
        if (details.open && this.combobox) {
          this.combobox.updateProps({
            collection: createCollection(this.allItems || []),
          });
        }
      },
      onInputValueChange: (details) => {
        if (!this.combobox || !this.allItems) return;
        
        // Filter the items array
        const filtered = this.allItems.filter((item: any) =>
          item.label.toLowerCase().includes(details.inputValue.toLowerCase()),
        );
        
        // Use filtered items or all items if no matches
        const currentItems = filtered.length > 0 ? filtered : this.allItems;
        
        // Update the combobox with the new collection
        this.combobox.updateProps({
          collection: createCollection(currentItems),
        });
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