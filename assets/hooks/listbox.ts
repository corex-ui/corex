import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { collection } from "@zag-js/listbox";
import { Listbox } from "../components/listbox";
import type { Props, ValueChangeDetails } from "@zag-js/listbox";
import type { Direction } from "@zag-js/types";
import { getString, getBoolean, getStringList } from "../lib/util";

type ListboxItem = {
  id?: string;
  value?: string;
  label: string;
  disabled?: boolean;
  group?: string;
};

function buildCollection(items: ListboxItem[], hasGroups: boolean) {
  if (hasGroups) {
    return collection({
      items,
      itemToValue: (item) => item.id ?? item.value ?? "",
      itemToString: (item) => item.label,
      isItemDisabled: (item) => !!item.disabled,
      groupBy: (item) => item.group ?? "",
    });
  }
  return collection({
    items,
    itemToValue: (item) => item.id ?? item.value ?? "",
    itemToString: (item) => item.label,
    isItemDisabled: (item) => !!item.disabled,
  });
}

type ListboxHookState = {
  listbox?: Listbox;
  handlers?: Array<CallbackRef>;
};

const ListboxHook: Hook<object & ListboxHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & ListboxHookState) {
    const el = this.el;
    const allItems = JSON.parse(el.dataset.collection ?? "[]") as ListboxItem[];
    const hasGroups = allItems.some((item) => item.group !== undefined);
    const valueList = getStringList(el, "value");
    const defaultValueList = getStringList(el, "defaultValue");
    const controlled = getBoolean(el, "controlled");
    const zag = new Listbox(el, {
      id: el.id,
      collection: buildCollection(allItems, hasGroups),
      ...(controlled && valueList
        ? { value: valueList }
        : { defaultValue: defaultValueList ?? [] }),
      disabled: getBoolean(el, "disabled"),
      dir: getString<Direction>(el, "dir", ["ltr", "rtl"]),
      orientation: getString<"horizontal" | "vertical">(el, "orientation", [
        "horizontal",
        "vertical",
      ]),
      loopFocus: getBoolean(el, "loopFocus"),
      selectionMode: getString<"single" | "multiple" | "extended">(el, "selectionMode", [
        "single",
        "multiple",
        "extended",
      ]),
      selectOnHighlight: getBoolean(el, "selectOnHighlight"),
      deselectable: getBoolean(el, "deselectable"),
      typeahead: getBoolean(el, "typeahead"),
      onValueChange: (details: ValueChangeDetails<ListboxItem>) => {
        const eventName = getString(el, "onValueChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, {
            value: details.value,
            items: details.items,
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
    } as Props<ListboxItem>);
    zag.hasGroups = hasGroups;
    zag.setOptions(allItems);
    zag.init();

    this.listbox = zag;
    this.handlers = [];
  },

  updated(this: object & HookInterface<HTMLElement> & ListboxHookState) {
    const newItems = JSON.parse(this.el.dataset.collection ?? "[]") as ListboxItem[];
    const hasGroups = newItems.some((item) => item.group !== undefined);
    const valueList = getStringList(this.el, "value");
    const controlled = getBoolean(this.el, "controlled");

    if (this.listbox) {
      this.listbox.hasGroups = hasGroups;
      this.listbox.setOptions(newItems);
      this.listbox.updateProps({
        collection: buildCollection(newItems, hasGroups),
        id: this.el.id,
        ...(controlled && valueList ? { value: valueList } : {}),
        disabled: getBoolean(this.el, "disabled"),
        dir: getString<Direction>(this.el, "dir", ["ltr", "rtl"]),
        orientation: getString<"horizontal" | "vertical">(this.el, "orientation", [
          "horizontal",
          "vertical",
        ]),
      } as Partial<Props<ListboxItem>>);
    }
  },

  destroyed(this: object & HookInterface<HTMLElement> & ListboxHookState) {
    if (this.handlers) {
      for (const h of this.handlers) this.removeHandleEvent(h);
    }
    this.listbox?.destroy();
  },
};

export { ListboxHook as Listbox };
