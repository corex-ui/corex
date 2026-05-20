import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Editable } from "../components/editable";
import type { Props, ValueChangeDetails } from "@zag-js/editable";
import { getString, getBoolean, getDir, canPushEvent } from "../lib/util";
import { createHookHandleEventRegistry } from "../lib/hook-handlers";
import { createDomEventRegistry } from "../lib/dom-events";
import { idMatches, notifyChange, readPayloadId, readPayloadValue } from "../lib/respond-to";

type EditableHookState = {
  editable?: Editable;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
};

export function dataDefaultValue(el: HTMLElement): string {
  return getString(el, "defaultValue") ?? "";
}

function notifyEditableValueChange(
  el: HTMLElement,
  pushEvent: (name: string, payload: Record<string, unknown>) => void,
  canPush: () => boolean,
  value: string
): void {
  const inputEl = el.querySelector('[data-scope="editable"][data-part="input"]') as {
    value: string;
    dispatchEvent: (e: Event) => boolean;
  } | null;
  if (inputEl) {
    inputEl.value = value;
    inputEl.dispatchEvent(new Event("input", { bubbles: true }));
    inputEl.dispatchEvent(new Event("change", { bubbles: true }));
  }
  notifyChange({
    el,
    canPushServer: canPush(),
    pushEvent,
    payload: {
      id: el.id,
      value,
    },
    serverEventName: getString(el, "onValueChange"),
    clientEventName: getString(el, "onValueChangeClient"),
  });
}

const EditableHook: Hook<object & HookInterface<HTMLElement> & EditableHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & EditableHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
    const placeholder = getString(el, "placeholder");
    const activationMode = getString(el, "activationMode") as "focus" | "dblclick" | undefined;
    const selectOnFocus = getBoolean(el, "selectOnFocus");

    const zag = new Editable(el, {
      id: el.id,
      defaultValue: dataDefaultValue(el),
      disabled: getBoolean(el, "disabled"),
      readOnly: getBoolean(el, "readonly"),
      required: getBoolean(el, "required"),
      invalid: getBoolean(el, "invalid"),
      name: getString(el, "name"),
      form: getString(el, "form"),
      dir: getDir(el),
      ...(placeholder !== undefined ? { placeholder } : {}),
      ...(activationMode !== undefined ? { activationMode } : {}),
      ...(selectOnFocus !== undefined ? { selectOnFocus } : {}),
      ...(getBoolean(el, "controlled")
        ? { edit: getBoolean(el, "edit") }
        : { defaultEdit: getBoolean(el, "defaultEdit") }),
      onValueChange: (details: ValueChangeDetails) => {
        notifyEditableValueChange(el, pushEvent, canPush, details.value);
      },
      onValueCommit: (details: ValueChangeDetails) => {
        notifyEditableValueChange(el, pushEvent, canPush, details.value);
      },
    } as Props);
    zag.init();
    this.editable = zag;

    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;

    domRegistry.add<CustomEvent<{ value?: string }>>("corex:editable:set-value", (event) => {
      const raw = event.detail?.value;
      zag.api.setValue(raw === undefined || raw === null ? "" : String(raw));
    });

    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;

    registry.add("editable_set_value", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.setValue(readPayloadValue(payload));
    });
  },

  updated(this: object & HookInterface<HTMLElement> & EditableHookState) {
    const el = this.el;
    const dv = dataDefaultValue(el);
    if (this.editable && !this.editable.api.editing && dv !== this.editable.api.value) {
      this.editable.api.setValue(dv);
    }
    this.editable?.updateProps({
      id: el.id,
      disabled: getBoolean(el, "disabled"),
      readOnly: getBoolean(el, "readonly"),
      required: getBoolean(el, "required"),
      invalid: getBoolean(el, "invalid"),
      name: getString(el, "name"),
      form: getString(el, "form"),
      dir: getDir(el),
      ...(getBoolean(el, "controlled")
        ? { edit: getBoolean(el, "edit") }
        : { defaultEdit: getBoolean(el, "defaultEdit") }),
    } as Partial<Props>);
  },

  destroyed(this: object & HookInterface<HTMLElement> & EditableHookState) {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.editable?.destroy();
  },
};

export { EditableHook as Editable };
