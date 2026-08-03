import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import {
  Combobox,
  resolveZagComboboxTranslations,
  type ComboboxItem,
} from "../components/combobox";
import type {
  Props,
  InputValueChangeDetails,
  OpenChangeDetails,
  ValueChangeDetails,
  HighlightChangeDetails,
  SelectionDetails,
} from "@zag-js/combobox";
import {
  getString,
  getBoolean,
  getStringList,
  getDir,
  canPushEvent,
  getBooleanValue,
} from "../lib/util";
import { mountStringListBinding, readUpdatedServerStringList } from "../lib/read-props";
import { idMatches, readPayloadId, notifyChange } from "../lib/respond-to";
import { readPositioningOptions } from "../lib/positioning";
import { markUsed, setArrayValues, syncFormInput } from "../lib/phoenix-form-bridge";
import {
  firstSelectedValue,
  initCollectionItems,
  itemsMembershipKey,
  parseItemsJson,
  redirectCollectionItem,
  refreshItemsIfChanged,
} from "../lib/collection-hook";
import { createZagLiveHook } from "../lib/zag-live-hook";

type ComboboxHookState = {
  combobox?: Combobox;
  lastItemsJson?: string;
  fieldTouched?: boolean;
};

export function formatComboboxHiddenValue(el: HTMLElement, values: ReadonlyArray<string>): string {
  const list = values.map((v) => String(v));
  return list.length === 0 ? "" : getBoolean(el, "multiple") ? list.join(",") : (list[0] ?? "");
}

export function syncComboboxHiddenInputForPhoenix(
  el: HTMLElement,
  values: ReadonlyArray<string>,
  onTouched?: () => void
): void {
  const submitName = getString(el, "submitName");
  if (submitName && getBoolean(el, "multiple")) {
    setArrayValues(el, values, {
      onTouched,
      scope: "combobox",
      submitName,
      notifyLiveView: true,
    });
    return;
  }

  const hidden = el.querySelector<HTMLInputElement>(
    '[data-scope="combobox"][data-part="hidden-input"]'
  );
  if (!hidden) return;
  syncFormInput(hidden, () => formatComboboxHiddenValue(el, values), onTouched);
}

function reapplyComboboxHiddenInputUsage(el: HTMLElement): void {
  const hidden = el.querySelector<HTMLInputElement>(
    '[data-scope="combobox"][data-part="hidden-input"]'
  );
  if (hidden) markUsed(hidden);
}

export { mountStringListBinding as comboboxValueBinding };

export function selectedItemLabel(items: ReadonlyArray<unknown>): string {
  const first = items?.[0] as { label?: unknown } | undefined;
  if (!first) return "";
  return first.label != null ? String(first.label) : "";
}

export function syncVisibleInputAttribute(el: HTMLElement, value: string): void {
  const visible = el.querySelector<HTMLInputElement>('[data-scope="combobox"][data-part="input"]');
  if (visible) visible.setAttribute("value", value);
}

function zagName(el: HTMLElement): string | undefined {
  if (getString(el, "submitName")) return undefined;
  const hidden = el.querySelector<HTMLInputElement>(
    '[data-scope="combobox"][data-part="hidden-input"]'
  );
  if (hidden?.name) return undefined;
  return getString(el, "name");
}

function zagForm(el: HTMLElement): string | undefined {
  return getString(el, "form");
}

function optionalBooleanProp(el: HTMLElement, key: string): Partial<Props> {
  const value = getBooleanValue(el, key);
  if (value === undefined) return {};
  return { [key]: value } as Partial<Props>;
}

function buildComboboxProps(
  el: HTMLElement,
  pushEvent: (name: string, payload: Record<string, unknown>) => void,
  canPush: () => boolean,
  liveSocket: HookInterface<HTMLElement>["liveSocket"],
  getCombobox: () => Combobox | undefined,
  markFieldTouched: () => void
): Props {
  const redirectOn = getBoolean(el, "redirect");
  const selectionBehavior =
    getString<"clear" | "replace" | "preserve">(el, "selectionBehavior") ?? "replace";

  return {
    id: el.id,
    disabled: getBoolean(el, "disabled"),
    placeholder: getString(el, "placeholder"),
    alwaysSubmitOnEnter: getBoolean(el, "alwaysSubmitOnEnter"),
    autoFocus: getBoolean(el, "autoFocus"),
    closeOnSelect: getBoolean(el, "closeOnSelect"),
    dir: getDir(el),
    inputBehavior: getString<"autohighlight" | "autocomplete" | "none">(el, "inputBehavior"),
    loopFocus: getBoolean(el, "loopFocus"),
    multiple: redirectOn ? false : getBoolean(el, "multiple"),
    invalid: getBoolean(el, "invalid"),
    allowCustomValue: getBoolean(el, "allowCustomValue"),
    selectionBehavior,
    readOnly: getBoolean(el, "readonly"),
    required: getBoolean(el, "required"),
    name: zagName(el),
    form: zagForm(el),
    positioning: readPositioningOptions(el),
    ...resolveZagComboboxTranslations(el),
    ...optionalBooleanProp(el, "openOnClick"),
    ...optionalBooleanProp(el, "openOnChange"),
    ...optionalBooleanProp(el, "openOnKeyPress"),
    ...optionalBooleanProp(el, "composite"),
    ...optionalBooleanProp(el, "disableLayer"),
    onOpenChange: (details: OpenChangeDetails) => {
      notifyChange({
        el,
        canPushServer: canPush(),
        pushEvent,
        payload: {
          id: el.id,
          open: details.open,
          reason: details.reason,
          value: details.value,
        } as Record<string, unknown>,
        serverEventName: getString(el, "onOpenChange"),
        clientEventName: getString(el, "onOpenChangeClient"),
      });
    },
    onInputValueChange: (details: InputValueChangeDetails) => {
      syncVisibleInputAttribute(el, details.inputValue ?? "");
      if (
        getBoolean(el, "clearOnEmpty") &&
        details.reason === "input-change" &&
        !(details.inputValue ?? "")
      ) {
        getCombobox()?.api.clearValue();
      }
      notifyChange({
        el,
        canPushServer: canPush(),
        pushEvent,
        payload: {
          id: el.id,
          value: details.inputValue,
          reason: details.reason,
        } as Record<string, unknown>,
        serverEventName: getString(el, "onInputValueChange"),
        clientEventName: getString(el, "onInputValueChangeClient"),
      });
    },
    onValueChange: (details: ValueChangeDetails) => {
      if (redirectOn) {
        redirectCollectionItem(el, "combobox", firstSelectedValue(details.value), liveSocket);
      }
      syncComboboxHiddenInputForPhoenix(el, details.value, markFieldTouched);
      getCombobox()?.restoreFilteredOptions();
      syncVisibleInputAttribute(el, selectedItemLabel(details.items));
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
    onHighlightChange: (details: HighlightChangeDetails) => {
      notifyChange({
        el,
        canPushServer: canPush(),
        pushEvent,
        payload: {
          id: el.id,
          highlightedValue: details.highlightedValue,
        } as Record<string, unknown>,
        serverEventName: getString(el, "onHighlightChange"),
        clientEventName: getString(el, "onHighlightChangeClient"),
      });
    },
    onSelect: (details: SelectionDetails) => {
      notifyChange({
        el,
        canPushServer: canPush(),
        pushEvent,
        payload: {
          id: el.id,
          value: details.value,
          itemValue: details.itemValue,
        } as Record<string, unknown>,
        serverEventName: getString(el, "onSelect"),
        clientEventName: getString(el, "onSelectClient"),
      });
    },
  } as Props;
}

function comboboxMachineDomPropsForUpdate(
  el: HTMLElement,
  pushEvent: (name: string, payload: Record<string, unknown>) => void,
  canPush: () => boolean,
  liveSocket: HookInterface<HTMLElement>["liveSocket"],
  getCombobox: () => Combobox | undefined,
  markFieldTouched: () => void
): Partial<Props> {
  const rest = {
    ...buildComboboxProps(el, pushEvent, canPush, liveSocket, getCombobox, markFieldTouched),
  } as Record<string, unknown>;
  delete rest.onOpenChange;
  delete rest.onInputValueChange;
  delete rest.onValueChange;
  delete rest.onHighlightChange;
  delete rest.onSelect;
  return rest as Partial<Props>;
}

const ComboboxHook = createZagLiveHook<ComboboxHookState, Combobox>({
  key: "combobox",
  controlledKeys: ["value"],
  mount(hook, { dom, server }) {
    const el = hook.el;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);
    hook.fieldTouched = false;
    const markFieldTouched = () => {
      hook.fieldTouched = true;
    };

    const { items: allItems, hasGroups } = initCollectionItems<ComboboxItem>(el, hook);

    const defaultValues = getStringList(el, "defaultValue") ?? [];
    if (defaultValues.length > 0) {
      hook.fieldTouched = true;
      reapplyComboboxHiddenInputUsage(el);
    }

    let comboboxRef: Combobox | undefined;
    const props = {
      ...buildComboboxProps(
        el,
        pushEvent,
        canPush,
        hook.liveSocket,
        () => comboboxRef,
        markFieldTouched
      ),
      ...mountStringListBinding(el),
    } as Props;

    const combobox = new Combobox(el, props, allItems, hasGroups);
    comboboxRef = combobox;

    dom.add<CustomEvent<{ value: string[] }>>("corex:combobox:set-value", (event) => {
      combobox.api.setValue(event.detail.value);
    });

    dom.add<CustomEvent<{ open: boolean }>>("corex:combobox:set-open", (event) => {
      combobox.api.setOpen(event.detail.open);
    });

    server.add("combobox_set_value", (payload: { id?: string; value: string[] }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      combobox.api.setValue(payload.value);
    });

    server.add("combobox_set_open", (payload: { id?: string; open?: boolean }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (typeof payload.open !== "boolean") return;
      combobox.api.setOpen(payload.open);
    });

    return combobox;
  },

  update(hook, combobox) {
    const prevMembership = itemsMembershipKey(
      parseItemsJson(hook.lastItemsJson ?? hook.el.getAttribute("data-items") ?? "[]")
    );
    const itemsChanged = refreshItemsIfChanged(hook.el, hook, combobox);
    const nextMembership = itemsMembershipKey(parseItemsJson(hook.lastItemsJson ?? "[]"));
    const membershipChanged = itemsChanged && prevMembership !== nextMembership;

    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);
    const valuePatch = readUpdatedServerStringList(hook.el, hook.beforeAttrs);

    const propsApplied = combobox.updateProps(
      {
        ...comboboxMachineDomPropsForUpdate(
          hook.el,
          pushEvent,
          canPush,
          hook.liveSocket,
          () => combobox,
          () => {
            hook.fieldTouched = true;
          }
        ),
        ...(valuePatch.value !== undefined ? { value: valuePatch.value } : {}),
      } as Props,
      { force: itemsChanged }
    );

    if (combobox.api.open) {
      combobox.api.reposition();
    }

    if (!propsApplied || itemsChanged) {
      // Membership change → rebuild; metadata-only → applyItemProps + filter visibility.
      // Zag subscribe already calls render() with syncList false after updateProps.
      combobox.render({ syncList: membershipChanged });
    } else {
      combobox.applyFilterVisibility();
      combobox.applyItemProps();
    }
  },
});

export { ComboboxHook as Combobox };
