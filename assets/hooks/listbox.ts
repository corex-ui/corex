import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Listbox } from "../components/listbox";
import type { Props, ValueChangeDetails } from "@zag-js/listbox";
import { getString, getBoolean, getDir, canPushEvent } from "../lib/util";
import {
  readStringListControlledZagProps,
  readStringListControlledZagUpdate,
} from "../lib/read-props";
import {
  parseRespondTo,
  idMatches,
  readPayloadId,
  notifyChange,
  createValueEmitter,
} from "../lib/respond-to";
import {
  type ValueLabelItem,
  applyItems,
  buildCollection,
  firstSelectedValue,
  initCollectionItems,
  redirectCollectionItem,
  refreshItemsIfChanged,
} from "../lib/collection-hook";

import { createZagLiveHook } from "../lib/zag-live-hook";

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
      if (redirectOn) {
        redirectCollectionItem(
          el,
          "listbox",
          firstSelectedValue(details.value),
          liveSocket
        );
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
  lastItemsJson?: string;
};

const ListboxHook = createZagLiveHook<ListboxHookState, Listbox>({
  key: "listbox",
  controlledKeys: ["value"],
  mount(hook, { dom, server }) {
    const el = hook.el;
    const { items: allItems, hasGroups } = initCollectionItems<ListboxItem>(el, hook);
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);
    const zag = new Listbox(el, {
      ...listboxZagPropsBase(el, hook.liveSocket, pushEvent),
      collection: buildCollection(allItems, hasGroups),
      ...readStringListControlledZagProps(el, "value", "defaultValue"),
    } as Props<ListboxItem>);
    applyItems(zag, allItems, hasGroups);

    const emitValue = createValueEmitter(
      { el, pushEvent, canPushServer: canPush },
      {
        getValue: () => zag.api.value,
        serverEventName: "listbox_value_response",
        domEventName: "listbox-value",
      }
    );

    dom.add<CustomEvent<{ value: string[] }>>("corex:listbox:set-value", (event) => {
      zag.api.setValue(event.detail.value);
    });

    dom.add<CustomEvent>("corex:listbox:value", (event) => {
      emitValue(parseRespondTo(event.detail));
    });

    server.add("listbox_set_value", (payload: { id?: string; value: string[] }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.setValue(payload.value);
    });

    server.add("listbox_value", (payload: { id?: string; respond_to?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitValue(parseRespondTo(payload));
    });

    return zag;
  },

  update(hook, zag) {
    const itemsChanged = refreshItemsIfChanged(hook.el, hook, zag);

    const propsApplied = zag.updateProps(
      {
        ...listboxZagPropsBase(hook.el, hook.liveSocket, hook.pushEvent.bind(hook)),
        collection: zag.getCollection(),
        ...readStringListControlledZagUpdate(hook.el, "value", "defaultValue", hook.beforeAttrs),
      } as Partial<Props<ListboxItem>>,
      { force: itemsChanged }
    );

    if (!propsApplied || itemsChanged) {
      zag.render();
    }
  },
});

export { ListboxHook as Listbox };
