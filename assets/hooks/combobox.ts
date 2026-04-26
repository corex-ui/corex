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

type ComboboxHookState = {
  combobox?: Combobox;
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
};

function comboboxValueBinding(el: HTMLElement): { value: string[] } | { defaultValue: string[] } {
  const controlled = getBoolean(el, "controlled");
  if (controlled) {
    return { value: getStringList(el, "value") ?? [] };
  }
  return { defaultValue: getStringList(el, "defaultValue") ?? [] };
}

function buildComboboxProps(
  el: HTMLElement,
  pushEvent: (name: string, payload: Record<string, unknown>) => void,
  canPush: () => boolean,
  liveSocket: HookInterface<HTMLElement>["liveSocket"]
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
    name: getString(el, "name"),
    form: getString(el, "form"),
    readOnly: getBoolean(el, "readOnly"),
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
      {
        const hidden = el.querySelector<HTMLInputElement>(
          '[data-scope="combobox"][data-part="hidden-input"]'
        );
        if (hidden) {
          const list = details.value.map((v) => String(v));
          hidden.value =
            list.length === 0 ? "" : getBoolean(el, "multiple") ? list.join(",") : (list[0] ?? "");
          hidden.dispatchEvent(new Event("change", { bubbles: true }));
        }
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
  } as Props;
}

const ComboboxHook: Hook<object & ComboboxHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & ComboboxHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);

    const allItems = JSON.parse(el.getAttribute("data-items") ?? "[]");
    const hasGroups = allItems.some((item: { group?: unknown }) => Boolean(item.group));

    const props = {
      ...buildComboboxProps(el, pushEvent, canPush, this.liveSocket),
      ...comboboxValueBinding(el),
    } as Props;

    const combobox = new Combobox(el, props);
    combobox.hasGroups = hasGroups;
    combobox.setAllOptions(allItems);
    combobox.init();

    this.combobox = combobox;

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
    const newCollection = JSON.parse(this.el.getAttribute("data-items") ?? "[]");
    const hasGroups = newCollection.some((item: { group?: unknown }) => Boolean(item.group));

    if (!this.combobox) return;

    this.combobox.hasGroups = hasGroups;
    this.combobox.setAllOptions(newCollection);

    const redirectOn = getBoolean(this.el, "redirect");
    const controlled = getBoolean(this.el, "controlled");

    this.combobox.updateProps({
      collection: this.combobox.getCollection(),
      id: this.el.id,
      ...(controlled
        ? { value: getStringList(this.el, "value") ?? [] }
        : { defaultValue: getStringList(this.el, "defaultValue") ?? [] }),
      name: getString(this.el, "name"),
      form: getString(this.el, "form"),
      dir: getDir(this.el),
      disabled: getBoolean(this.el, "disabled"),
      multiple: redirectOn ? false : getBoolean(this.el, "multiple"),
      invalid: getBoolean(this.el, "invalid"),
      required: getBoolean(this.el, "required"),
      readOnly: getBoolean(this.el, "readOnly"),
      placeholder: getString(this.el, "placeholder"),
    } as Props);

    if (this.combobox.api.open) {
      this.combobox.api.reposition();
    }
  },

  destroyed(this: object & HookInterface<HTMLElement> & ComboboxHookState) {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.combobox?.destroy();
  },
};

export { ComboboxHook as Combobox };
