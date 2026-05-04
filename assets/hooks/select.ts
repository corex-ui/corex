import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { collection } from "@zag-js/select";
import { Select } from "../components/select";
import type { Props, ValueChangeDetails } from "@zag-js/select";

import { getString, getBoolean, getStringList, canPushEvent, getDir } from "../lib/util";
import { readPositioningOptions } from "../lib/positioning";
import { performRedirect, readDomItemRedirect } from "../lib/redirect";
import { idMatches, readPayloadId, notifyChange } from "../lib/respond-to";
import { createHookHandleEventRegistry } from "../lib/hook-handlers";
import { createDomEventRegistry } from "../lib/dom-events";

type SelectItem = {
  id?: string;
  value?: string;
  label: string;
  disabled?: boolean;
  group?: string;
};

function buildCollection(items: SelectItem[], hasGroups: boolean) {
  if (hasGroups) {
    return collection({
      items,
      itemToValue: (item: SelectItem) => item.id ?? item.value ?? "",
      itemToString: (item: SelectItem) => item.label,
      isItemDisabled: (item: SelectItem) => !!item.disabled,
      groupBy: (item: SelectItem) => item.group ?? "",
    });
  }
  return collection({
    items,
    itemToValue: (item: SelectItem) => item.id ?? item.value ?? "",
    itemToString: (item: SelectItem) => item.label,
    isItemDisabled: (item: SelectItem) => !!item.disabled,
  });
}

type SelectHookState = {
  select?: Select;
  handlers?: Array<CallbackRef>;
  wasFocused?: boolean;
  lastItemsJson?: string;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
};

const SelectHook: Hook<object & SelectHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & SelectHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
    const allItems = JSON.parse(el.dataset.items || "[]") as SelectItem[];
    const hasGroups = allItems.some((item: SelectItem) => Boolean(item.group));

    const initialCollection = buildCollection(allItems, hasGroups);
    const redirectOn = getBoolean(el, "redirect");

    const selectComponent = new Select(el, {
      id: el.id,
      collection: initialCollection,
      ...(getBoolean(el, "controlled")
        ? { value: getStringList(el, "value") }
        : { defaultValue: getStringList(el, "defaultValue") }),
      disabled: getBoolean(el, "disabled"),
      closeOnSelect: getBoolean(el, "closeOnSelect"),
      dir: getDir(el),
      loopFocus: getBoolean(el, "loopFocus"),
      multiple: redirectOn ? false : getBoolean(el, "multiple"),
      invalid: getBoolean(el, "invalid"),
      name: getString(el, "name"),
      form: getString(el, "form"),
      readOnly: getBoolean(el, "readOnly"),
      required: getBoolean(el, "required"),
      deselectable: getBoolean(el, "deselectable"),
      positioning: readPositioningOptions(el),
      onValueChange: (details: ValueChangeDetails) => {
        const firstValue = details.value.length > 0 ? String(details.value[0]) : null;

        if (getBoolean(el, "redirect") && firstValue) {
          const itemEl = el.querySelector<HTMLElement>(
            `[data-scope="select"][data-part="item"][data-value="${CSS.escape(firstValue)}"]`
          );
          performRedirect(readDomItemRedirect(itemEl, firstValue), {
            liveSocket: this.liveSocket,
          });
        }

        const valueInput = el.querySelector<HTMLInputElement>(
          '[data-scope="select"][data-part="value-input"]'
        );
        if (valueInput && getBoolean(el, "controlled")) {
          valueInput.value =
            details.value.length === 0
              ? ""
              : details.value.length === 1
                ? String(details.value[0])
                : details.value.map(String).join(",");
          valueInput.dispatchEvent(new Event("input", { bubbles: true }));
          valueInput.dispatchEvent(new Event("change", { bubbles: true }));
        }

        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: {
            id: el.id,
            value: details.value,
            items: details.items,
          } as Record<string, unknown>,
          serverEventName: getString(el, "onValueChange"),
          clientEventName: getString(el, "onValueChangeClient"),
        });
      },
    } as Props);

    selectComponent.hasGroups = hasGroups;
    selectComponent.setOptions(allItems);
    selectComponent.init();

    this.select = selectComponent;
    this.handlers = [];
    this.lastItemsJson = el.dataset.items || "[]";

    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;

    domRegistry.add<CustomEvent<{ value: string[] }>>("corex:select:set-value", (event) => {
      selectComponent.api.setValue(event.detail.value);
    });

    domRegistry.add<CustomEvent<{ open: boolean }>>("corex:select:set-open", (event) => {
      selectComponent.api.setOpen(event.detail.open);
    });

    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;

    registry.add("select_set_value", (payload: { id?: string; value: string[] }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      selectComponent.api.setValue(payload.value);
    });

    registry.add("select_set_open", (payload: { id?: string; open?: boolean }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (typeof payload.open !== "boolean") return;
      selectComponent.api.setOpen(payload.open);
    });
  },

  updated(this: object & HookInterface<HTMLElement> & SelectHookState) {
    const itemsJson = this.el.dataset.items || "[]";
    const itemsUnchanged = itemsJson === this.lastItemsJson;
    const redirectOn = getBoolean(this.el, "redirect");

    const nextProps: Partial<Props> = {
      id: this.el.id,
      ...(getBoolean(this.el, "controlled")
        ? { value: getStringList(this.el, "value") }
        : { defaultValue: getStringList(this.el, "defaultValue") }),
      name: getString(this.el, "name"),
      form: getString(this.el, "form"),
      disabled: getBoolean(this.el, "disabled"),
      multiple: redirectOn ? false : getBoolean(this.el, "multiple"),
      dir: getDir(this.el),
      invalid: getBoolean(this.el, "invalid"),
      required: getBoolean(this.el, "required"),
      readOnly: getBoolean(this.el, "readOnly"),
      positioning: readPositioningOptions(this.el),
    };

    if (this.select && itemsUnchanged) {
      this.select.updateProps(nextProps);
      return;
    }

    this.lastItemsJson = itemsJson;
    const newItems = JSON.parse(itemsJson) as SelectItem[];
    const hasGroups = newItems.some((item: SelectItem) => Boolean(item.group));

    if (this.select) {
      this.select.hasGroups = hasGroups;
      this.select.setOptions(newItems);
      this.select.updateProps({
        ...nextProps,
        collection: buildCollection(newItems, hasGroups),
      } as Props);
    }
  },

  destroyed(this: object & HookInterface<HTMLElement> & SelectHookState) {
    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }

    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.select?.destroy();
  },
};

export { SelectHook as Select };
