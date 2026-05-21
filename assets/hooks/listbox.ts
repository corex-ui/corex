import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Listbox } from "../components/listbox";
import type { Props, ValueChangeDetails } from "@zag-js/listbox";
import { getString, getBoolean, getDir, canPushEvent } from "../lib/util";
import { readStringListControlledZagProps } from "../lib/read-props";
import { performRedirect, readDomItemRedirect } from "../lib/redirect";
import {
  parseRespondTo,
  emitResponse,
  idMatches,
  readPayloadId,
  notifyChange,
  type RespondTo,
} from "../lib/respond-to";
import { createHookHandleEventRegistry } from "../lib/hook-handlers";
import { createDomEventRegistry } from "../lib/dom-events";
import { type ValueLabelItem, buildCollection } from "../lib/list-collection";

type ListboxItem = ValueLabelItem;

export { buildCollection };

function listboxZagPropsBase(
  el: HTMLElement,
  liveSocket: HookInterface<HTMLElement>["liveSocket"],
  pushEvent: (name: string, payload: Record<string, unknown>) => void
): Omit<Props<ListboxItem>, "collection" | "value" | "defaultValue"> {
  const redirectOn = getBoolean(el, "redirect");
  return {
    id: el.id,
    disabled: getBoolean(el, "disabled"),
    dir: getDir(el),
    orientation: getString<"horizontal" | "vertical">(el, "orientation"),
    loopFocus: getBoolean(el, "loopFocus"),
    selectionMode: redirectOn
      ? "single"
      : getString<"single" | "multiple" | "extended">(el, "selectionMode"),
    selectOnHighlight: getBoolean(el, "selectOnHighlight"),
    deselectable: getBoolean(el, "deselectable"),
    typeahead: getBoolean(el, "typeahead"),
    onValueChange: (details: ValueChangeDetails<ListboxItem>) => {
      const firstValue = details.value.length > 0 ? String(details.value[0]) : null;
      if (redirectOn && firstValue) {
        const itemEl = el.querySelector<HTMLElement>(
          `[data-scope="listbox"][data-part="item"][data-value="${CSS.escape(firstValue)}"]`
        );
        performRedirect(readDomItemRedirect(itemEl, firstValue), { liveSocket });
      }
      notifyChange({
        el,
        canPushServer: canPushEvent(liveSocket),
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
  };
}

type ListboxHookState = {
  listbox?: Listbox;
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
};

const ListboxHook: Hook<object & ListboxHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & ListboxHookState) {
    const el = this.el;
    const allItems = JSON.parse(el.dataset.items ?? "[]") as ListboxItem[];
    const hasGroups = allItems.some((item) => Boolean(item.group));
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
    const zag = new Listbox(el, {
      ...listboxZagPropsBase(el, this.liveSocket, pushEvent),
      collection: buildCollection(allItems, hasGroups),
      ...readStringListControlledZagProps(el, "value", "defaultValue"),
    } as Props<ListboxItem>);
    zag.hasGroups = hasGroups;
    zag.setOptions(allItems);
    zag.init();

    this.listbox = zag;

    const emitValue = (respondTo: RespondTo) => {
      const value = zag.api.value;
      emitResponse({
        respondTo,
        canPushServer: canPush(),
        pushEvent,
        serverEventName: "listbox_value_response",
        serverPayload: { id: el.id, value } as Record<string, unknown>,
        el,
        domEventName: "listbox-value",
        domDetail: { id: el.id, value } as Record<string, unknown>,
      });
    };

    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;

    domRegistry.add<CustomEvent<{ value: string[] }>>("corex:listbox:set-value", (event) => {
      zag.api.setValue(event.detail.value);
    });

    domRegistry.add<CustomEvent>("corex:listbox:value", (event) => {
      emitValue(parseRespondTo(event.detail));
    });

    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;

    registry.add("listbox_set_value", (payload: { id?: string; value: string[] }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.setValue(payload.value);
    });

    registry.add("listbox_value", (payload: { id?: string; respond_to?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitValue(parseRespondTo(payload));
    });
  },

  updated(this: object & HookInterface<HTMLElement> & ListboxHookState) {
    if (!this.listbox) return;

    const newItems = JSON.parse(this.el.dataset.items ?? "[]") as ListboxItem[];
    const hasGroups = newItems.some((item) => Boolean(item.group));

    this.listbox.hasGroups = hasGroups;
    this.listbox.setOptions(newItems);

    this.listbox.updateProps({
      ...listboxZagPropsBase(this.el, this.liveSocket, this.pushEvent.bind(this)),
      collection: this.listbox.getCollection(),
      ...readStringListControlledZagProps(this.el, "value", "defaultValue"),
    } as Partial<Props<ListboxItem>>);
  },

  destroyed(this: object & HookInterface<HTMLElement> & ListboxHookState) {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.listbox?.destroy();
  },
};

export { ListboxHook as Listbox };
