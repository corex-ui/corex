import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { collection } from "@zag-js/select";
import { Select } from "../components/select";
import type { Props, ValueChangeDetails } from "@zag-js/select";

import { getString, getBoolean, canPushEvent, getDir } from "../lib/util";
import { readStringListControlledZagProps, readUpdatedServerStringList } from "../lib/read-props";
import { readPositioningOptions } from "../lib/positioning";
import { idMatches, readPayloadId, notifyChange } from "../lib/respond-to";
import { notifyPhoenixFormChange } from "../lib/phoenix-form-bridge";
import {
  type ValueLabelItem,
  applyItems,
  firstSelectedValue,
  initCollectionItems,
  itemValue,
  redirectCollectionItem,
  refreshItemsIfChanged,
  zagListCollectionConfig,
} from "../lib/collection-hook";
import { createZagLiveHook } from "../lib/zag-live-hook";

type SelectItem = ValueLabelItem;

function selectHiddenSelectForForm(el: HTMLElement): HTMLSelectElement | null {
  const hiddenSelect = el.querySelector<HTMLSelectElement>(
    '[data-scope="select"][data-part="hidden-select"]'
  );
  if (!hiddenSelect) return null;

  const formArrayName = getString(el, "hiddenSelectName");
  if (formArrayName) {
    hiddenSelect.name = formArrayName;
    hiddenSelect.disabled = false;
    return hiddenSelect;
  }

  if (!hiddenSelect.name) return null;
  return hiddenSelect;
}

export function formatSelectHiddenValue(el: HTMLElement, values: ReadonlyArray<string>): string {
  const list = values.map((v) => String(v));
  if (list.length === 0) return "";
  if (getBoolean(el, "multiple") && selectHiddenSelectForForm(el)) return "";
  return getBoolean(el, "multiple") ? list.join(",") : (list[0] ?? "");
}

export function syncSelectHiddenSelectForPhoenix(
  hiddenSelect: HTMLSelectElement,
  values: ReadonlyArray<string>
): void {
  const valueSet = new Set(values.map(String));

  Array.from(hiddenSelect.options).forEach((option) => {
    if (option.value === "") {
      option.selected = false;
      return;
    }

    option.selected = valueSet.has(option.value);
  });

  hiddenSelect.dispatchEvent(new Event("input", { bubbles: true }));
  hiddenSelect.dispatchEvent(new Event("change", { bubbles: true }));
}

export function syncSelectHiddenInputForPhoenix(
  el: HTMLElement,
  values: ReadonlyArray<string>
): void {
  const hiddenSelect = selectHiddenSelectForForm(el);

  if (hiddenSelect && getBoolean(el, "multiple")) {
    syncSelectHiddenSelectForPhoenix(hiddenSelect, values);
    return;
  }

  const valueInput = el.querySelector<HTMLInputElement>(
    '[data-scope="select"][data-part="value-input"]'
  );
  if (!valueInput) return;
  notifyPhoenixFormChange(valueInput, formatSelectHiddenValue(el, values));
}

export function syncControlledValueInputFromServer(
  el: HTMLElement,
  values: ReadonlyArray<string>
): void {
  if (!getBoolean(el, "controlled")) return;

  const valueInput = el.querySelector<HTMLInputElement>(
    '[data-scope="select"][data-part="value-input"]'
  );
  if (!valueInput?.name) return;

  const next = formatSelectHiddenValue(el, values);
  if (valueInput.value !== next) {
    valueInput.value = next;
  }
}

export function buildCollection(items: SelectItem[], hasGroups: boolean) {
  return collection(zagListCollectionConfig(items, hasGroups));
}

function controlledValueMatchesServer(el: HTMLElement, values: ReadonlyArray<string>): boolean {
  return formatSelectHiddenValue(el, values) === (getString(el, "value") ?? "");
}

export { controlledValueMatchesServer };

function selectLayoutProps(
  el: HTMLElement
): Omit<Props, "collection" | "value" | "defaultValue" | "onValueChange"> {
  const redirectOn = getBoolean(el, "redirect");
  return {
    id: el.id,
    disabled: getBoolean(el, "disabled"),
    closeOnSelect: getBoolean(el, "closeOnSelect"),
    dir: getDir(el),
    loopFocus: getBoolean(el, "loopFocus"),
    multiple: redirectOn ? false : getBoolean(el, "multiple"),
    invalid: getBoolean(el, "invalid"),
    name: getString(el, "name"),
    form: getString(el, "form"),
    readOnly: getBoolean(el, "readonly"),
    required: getBoolean(el, "required"),
    deselectable: getBoolean(el, "deselectable"),
    positioning: readPositioningOptions(el),
  };
}

function createSelectOnValueChange(
  getEl: () => HTMLElement,
  liveSocket: HookInterface<HTMLElement>["liveSocket"],
  pushEvent: (name: string, payload: Record<string, unknown>) => void,
  canPush: () => boolean
): (details: ValueChangeDetails) => void {
  return (details: ValueChangeDetails) => {
    const el = getEl();

    if (getBoolean(el, "controlled") && controlledValueMatchesServer(el, details.value)) {
      return;
    }

    if (getBoolean(el, "redirect")) {
      redirectCollectionItem(el, "select", firstSelectedValue(details.value), liveSocket);
    }

    syncSelectHiddenInputForPhoenix(el, details.value);

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
  };
}

function selectZagPropsBase(
  el: HTMLElement,
  onValueChange: (details: ValueChangeDetails) => void
): Omit<Props, "collection" | "value" | "defaultValue"> {
  return {
    ...selectLayoutProps(el),
    onValueChange,
  };
}

export function reapplySelectInteractiveState(el: HTMLElement): void {
  el.removeAttribute("data-loading");

  if (getBoolean(el, "disabled") || getBoolean(el, "readonly")) return;

  const trigger = el.querySelector<HTMLButtonElement>('[data-scope="select"][data-part="trigger"]');
  if (!trigger || getBoolean(trigger, "disabled")) return;

  trigger.disabled = false;
  trigger.removeAttribute("disabled");
}

type SelectHookState = {
  select?: Select;
  lastItemsJson?: string;
  onValueChange?: (details: ValueChangeDetails) => void;
};

const SelectHook = createZagLiveHook<SelectHookState, Select>({
  key: "select",
  controlledKeys: ["value"],
  mount(hook, { dom, server }) {
    const el = hook.el;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);

    const onValueChange = createSelectOnValueChange(
      () => hook.el,
      hook.liveSocket,
      pushEvent,
      canPush
    );
    hook.onValueChange = onValueChange;

    const { items: allItems, hasGroups } = initCollectionItems<SelectItem>(el, hook);
    const selectComponent = new Select(el, {
      ...selectZagPropsBase(el, onValueChange),
      collection: buildCollection(allItems, hasGroups),
      ...readStringListControlledZagProps(el, "value", "defaultValue"),
    } as Props);

    applyItems(selectComponent, allItems, hasGroups);

    dom.add<CustomEvent<{ value: string[] }>>("corex:select:set-value", (event) => {
      selectComponent.api.setValue(event.detail.value);
    });

    dom.add<CustomEvent<{ open: boolean }>>("corex:select:set-open", (event) => {
      selectComponent.api.setOpen(event.detail.open);
    });

    server.add("select_set_value", (payload: { id?: string; value: string[] }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      selectComponent.api.setValue(payload.value);
    });

    server.add("select_set_open", (payload: { id?: string; open?: boolean }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (typeof payload.open !== "boolean") return;
      selectComponent.api.setOpen(payload.open);
    });

    return selectComponent;
  },

  update(hook, select) {
    const itemsChanged = refreshItemsIfChanged(hook.el, hook, select);

    const valuePatch = readUpdatedServerStringList(hook.el, hook.beforeAttrs);

    if (valuePatch.value !== undefined) {
      syncControlledValueInputFromServer(hook.el, valuePatch.value);
    }

    // Drop selections whose items were removed from the collection (e.g. reset).
    if (itemsChanged && valuePatch.value === undefined) {
      const available = new Set(select.options.map((i) => String(itemValue(i))));
      const current = (select.api.value ?? []).map(String);
      const next = current.filter((v) => available.has(v));
      if (next.length !== current.length) {
        select.api.setValue(next);
      }
    }

    const propsApplied = select.updateProps(
      {
        ...selectLayoutProps(hook.el),
        collection: select.getCollection(),
        ...(valuePatch.value !== undefined ? { value: valuePatch.value } : {}),
      } as Props,
      { force: itemsChanged }
    );

    if (!propsApplied || itemsChanged) {
      select.render();
    }

    reapplySelectInteractiveState(hook.el);
  },
});

export { SelectHook as Select };
