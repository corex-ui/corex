import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Combobox } from "../components/combobox";
import type {
  Props,
  InputValueChangeDetails,
  OpenChangeDetails,
  ValueChangeDetails,
} from "@zag-js/combobox";
import { getString, getBoolean, getStringList, getDir, canPushEvent } from "../lib/util";
import { performRedirect, readDomItemRedirect } from "../lib/redirect";
import { idMatches, readPayloadId, notifyChange } from "../lib/respond-to";
import { createHookHandleEventRegistry } from "../lib/hook-handlers";
import { createDomEventRegistry } from "../lib/dom-events";
import { readPositioningOptions } from "../lib/positioning";
import {
  queueLiveViewFormInputSync,
  reapplyLiveViewValueInputUsage,
} from "../lib/live-view-form-input";

type ComboboxHookState = {
  combobox?: Combobox;
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
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
  const hidden = el.querySelector<HTMLInputElement>(
    '[data-scope="combobox"][data-part="hidden-input"]'
  );
  if (!hidden) return;
  queueLiveViewFormInputSync(hidden, () => formatComboboxHiddenValue(el, values), onTouched);
}

function reapplyComboboxHiddenInputUsage(el: HTMLElement): void {
  const hidden = el.querySelector<HTMLInputElement>(
    '[data-scope="combobox"][data-part="hidden-input"]'
  );
  if (hidden) reapplyLiveViewValueInputUsage(hidden);
}

export function comboboxValueBinding(
  el: HTMLElement
): { value: string[] } | { defaultValue: string[] } {
  const controlled = getBoolean(el, "controlled");
  if (controlled) {
    return { value: getStringList(el, "value") ?? [] };
  }
  return { defaultValue: getStringList(el, "defaultValue") ?? [] };
}

function comboboxValueBindingForUpdate(el: HTMLElement): { value?: string[] } {
  if (!getBoolean(el, "controlled")) return {};
  return { value: getStringList(el, "value") ?? [] };
}

export function selectedItemLabel(items: ReadonlyArray<unknown>): string {
  const first = items?.[0] as { label?: unknown } | undefined;
  if (!first) return "";
  return first.label != null ? String(first.label) : "";
}

export function syncVisibleInputAttribute(el: HTMLElement, value: string): void {
  const visible = el.querySelector<HTMLInputElement>('[data-scope="combobox"][data-part="input"]');
  if (visible) visible.setAttribute("value", value);
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
    allowCustomValue: false,
    selectionBehavior: "replace",
    readOnly: getBoolean(el, "readonly"),
    required: getBoolean(el, "required"),
    positioning: readPositioningOptions(el),
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
      const firstValue = details.value.length > 0 ? String(details.value[0]) : null;
      if (redirectOn && firstValue) {
        const itemEl = el.querySelector<HTMLElement>(
          `[data-scope="combobox"][data-part="item"][data-value="${CSS.escape(firstValue)}"]`
        );
        performRedirect(readDomItemRedirect(itemEl, firstValue), { liveSocket });
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
  return rest as Partial<Props>;
}

const ComboboxHook: Hook<object & ComboboxHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & ComboboxHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
    const hook = this as object & ComboboxHookState;
    hook.fieldTouched = false;
    const markFieldTouched = () => {
      hook.fieldTouched = true;
    };

    const itemsJson = el.getAttribute("data-items") ?? "[]";
    const allItems = JSON.parse(itemsJson);
    const hasGroups = allItems.some((item: { group?: unknown }) => Boolean(item.group));

    const defaultValues = getStringList(el, "defaultValue") ?? [];
    if (defaultValues.length > 0) {
      hook.fieldTouched = true;
      queueMicrotask(() => reapplyComboboxHiddenInputUsage(el));
    }

    let comboboxRef: Combobox | undefined;
    const props = {
      ...buildComboboxProps(
        el,
        pushEvent,
        canPush,
        this.liveSocket,
        () => comboboxRef,
        markFieldTouched
      ),
      ...comboboxValueBinding(el),
    } as Props;

    const combobox = new Combobox(el, props, allItems, hasGroups);
    comboboxRef = combobox;
    combobox.init();

    this.combobox = combobox;
    this.lastItemsJson = itemsJson;

    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;

    domRegistry.add<CustomEvent<{ value: string[] }>>("corex:combobox:set-value", (event) => {
      combobox.api.setValue(event.detail.value);
    });

    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;

    registry.add("combobox_set_value", (payload: { id?: string; value: string[] }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      combobox.api.setValue(payload.value);
    });
  },

  updated(this: object & HookInterface<HTMLElement> & ComboboxHookState) {
    if (!this.combobox) return;

    const newItemsJson = this.el.getAttribute("data-items") ?? "[]";
    if (newItemsJson !== this.lastItemsJson) {
      this.lastItemsJson = newItemsJson;
      const newCollection = JSON.parse(newItemsJson);
      const hasGroups = newCollection.some((item: { group?: unknown }) => Boolean(item.group));
      this.combobox.hasGroups = hasGroups;
      this.combobox.setAllOptions(newCollection);
    }

    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);

    this.combobox.updateProps({
      ...comboboxMachineDomPropsForUpdate(
        this.el,
        pushEvent,
        canPush,
        this.liveSocket,
        () => this.combobox,
        () => {
          this.fieldTouched = true;
        }
      ),
      ...comboboxValueBindingForUpdate(this.el),
    } as Props);

    if (this.combobox.api.open) {
      this.combobox.api.reposition();
    }

    if (!this.fieldTouched) return;

    queueMicrotask(() => {
      if (!this.combobox) return;
      const hidden = this.el.querySelector<HTMLInputElement>(
        '[data-scope="combobox"][data-part="hidden-input"]'
      );
      if (!hidden) return;
      const v = formatComboboxHiddenValue(this.el, this.combobox.api.value);
      if (hidden.value !== v) hidden.value = v;
      reapplyLiveViewValueInputUsage(hidden);
    });
  },

  destroyed(this: object & HookInterface<HTMLElement> & ComboboxHookState) {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.combobox?.destroy();
  },
};

export { ComboboxHook as Combobox };
