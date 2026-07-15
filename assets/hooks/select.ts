import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { collection } from "@zag-js/select";
import { Select } from "../components/select";
import type { Props, ValueChangeDetails } from "@zag-js/select";

import { getString, getBoolean, canPushEvent, getDir, safeParseJson } from "../lib/util";
import { snapshotDataset, type DatasetSnapshot } from "../lib/controlled-attr-snapshot";
import { readStringListControlledZagProps, readUpdatedServerStringList } from "../lib/read-props";
import { readPositioningOptions } from "../lib/positioning";
import { performRedirect, readDomItemRedirect } from "../lib/redirect";
import { idMatches, readPayloadId, notifyChange } from "../lib/respond-to";
import { createHookHandleEventRegistry } from "../lib/hook-handlers";
import { createDomEventRegistry } from "../lib/dom-events";
import { notifyPhoenixFormChange } from "../lib/live-view-form-input";
import { type ValueLabelItem, zagListCollectionConfig } from "../lib/list-collection";

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

    const firstValue = details.value.length > 0 ? String(details.value[0]) : null;

    if (getBoolean(el, "redirect") && firstValue) {
      const itemEl = el.querySelector<HTMLElement>(
        `[data-scope="select"][data-part="item"][data-value="${CSS.escape(firstValue)}"]`
      );
      performRedirect(readDomItemRedirect(itemEl, firstValue), { liveSocket });
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
  handlers?: Array<CallbackRef>;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
  beforeAttrs?: DatasetSnapshot;
  lastItemsJson?: string;
  onValueChange?: (details: ValueChangeDetails) => void;
};

const SelectHook: Hook<object & SelectHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & SelectHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);

    const allItems = safeParseJson<SelectItem[]>(el.dataset.items || "[]", []);
    const hasGroups = allItems.some((item: SelectItem) => Boolean(item.group));
    const onValueChange = createSelectOnValueChange(
      () => this.el,
      this.liveSocket,
      pushEvent,
      canPush
    );
    this.onValueChange = onValueChange;

    const selectComponent = new Select(el, {
      ...selectZagPropsBase(el, onValueChange),
      collection: buildCollection(allItems, hasGroups),
      ...readStringListControlledZagProps(el, "value", "defaultValue"),
    } as Props);

    selectComponent.hasGroups = hasGroups;
    selectComponent.setOptions(allItems);
    selectComponent.init();

    this.select = selectComponent;
    this.lastItemsJson = el.dataset.items || "[]";
    this.handlers = [];
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

  beforeUpdate(this: object & HookInterface<HTMLElement> & SelectHookState) {
    this.beforeAttrs = snapshotDataset(this.el, ["value"]);
  },

  updated(this: object & HookInterface<HTMLElement> & SelectHookState) {
    if (!this.select) return;

    try {
      const newItemsJson = this.el.dataset.items || "[]";
      if (newItemsJson !== this.lastItemsJson) {
        this.lastItemsJson = newItemsJson;
        const newItems = safeParseJson<SelectItem[]>(newItemsJson, []);
        const hasGroups = newItems.some((item: SelectItem) => Boolean(item.group));
        this.select.hasGroups = hasGroups;
        this.select.setOptions(newItems);
      }

      const valuePatch = readUpdatedServerStringList(this.el, this.beforeAttrs);

      if (valuePatch.value !== undefined) {
        syncControlledValueInputFromServer(this.el, valuePatch.value);
      }

      this.select.updateProps({
        ...selectLayoutProps(this.el),
        collection: this.select.getCollection(),
        ...(valuePatch.value !== undefined ? { value: valuePatch.value } : {}),
      } as Props);

      reapplySelectInteractiveState(this.el);
    } finally {
      this.beforeAttrs = undefined;
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
