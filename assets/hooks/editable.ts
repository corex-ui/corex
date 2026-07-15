import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Editable } from "../components/editable";
import type { Props, ValueChangeDetails } from "@zag-js/editable";
import { getString, getBoolean, getDir, canPushEvent } from "../lib/util";
import { mountStringBinding } from "../lib/read-props";
import { createHookHandleEventRegistry } from "../lib/hook-handlers";
import { createDomEventRegistry } from "../lib/dom-events";
import { idMatches, notifyChange, readPayloadId, readPayloadValue } from "../lib/respond-to";
import { setScalarValue, type NotifyPhoenixFormChangeOptions } from "../lib/phoenix-form-bridge";

type EditableHookState = {
  editable?: Editable;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
  fieldTouched?: boolean;
  unbindFormSubmit?: () => void;
};

export function dataDefaultValue(el: HTMLElement): string {
  return getString(el, "defaultValue") ?? "";
}

function formValueInput(el: HTMLElement): HTMLInputElement | null {
  return el.querySelector<HTMLInputElement>(`#${el.id}-value`);
}

function syncEditableFormValue(
  el: HTMLElement,
  value: string,
  options: NotifyPhoenixFormChangeOptions = {}
): void {
  const hidden = formValueInput(el);
  if (hidden) {
    setScalarValue(hidden, value, options);
    return;
  }

  const inputEl = el.querySelector('[data-scope="editable"][data-part="input"]') as {
    value: string;
    dispatchEvent: (e: Event) => boolean;
  } | null;
  if (inputEl) {
    setScalarValue(inputEl as HTMLInputElement, value, options);
  }
}

function notifyEditableValueChange(
  el: HTMLElement,
  pushEvent: (name: string, payload: Record<string, unknown>) => void,
  canPush: () => boolean,
  value: string,
  hook: EditableHookState,
  initialValue: string
): void {
  const isMountEcho = hook.fieldTouched !== true && value === initialValue;
  if (!isMountEcho) {
    hook.fieldTouched = true;
  }

  syncEditableFormValue(el, value, {
    markUsed: !isMountEcho,
  });

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

function bindFormSubmitSync(el: HTMLElement, zag: Editable): () => void {
  const form = el.closest("form");
  if (!form) return () => {};

  const onSubmit = () => {
    if (!zag.api.editing) return;

    const inputEl = el.querySelector(
      '[data-scope="editable"][data-part="input"]'
    ) as HTMLInputElement | null;

    syncEditableFormValue(el, inputEl?.value ?? zag.api.value, { markUsed: false });
  };

  form.addEventListener("submit", onSubmit, true);
  return () => form.removeEventListener("submit", onSubmit, true);
}

function zagName(el: HTMLElement): string | undefined {
  if (formValueInput(el)) return undefined;
  return getString(el, "name");
}

const EditableHook: Hook<object & HookInterface<HTMLElement> & EditableHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & EditableHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
    const placeholder = getString(el, "placeholder");
    const activationMode = getString(el, "activationMode") as "focus" | "dblclick" | undefined;
    const selectOnFocus = getBoolean(el, "selectOnFocus");

    this.fieldTouched = false;

    const valueBinding = mountStringBinding(el, "value", "defaultValue");
    const initialValue =
      "value" in valueBinding ? (valueBinding.value ?? "") : (valueBinding.defaultValue ?? "");
    const zag = new Editable(el, {
      id: el.id,
      ...("value" in valueBinding
        ? { value: valueBinding.value ?? "" }
        : { defaultValue: valueBinding.defaultValue ?? "" }),
      disabled: getBoolean(el, "disabled"),
      readOnly: getBoolean(el, "readonly"),
      required: getBoolean(el, "required"),
      invalid: getBoolean(el, "invalid"),
      name: zagName(el),
      form: formValueInput(el) ? undefined : getString(el, "form"),
      dir: getDir(el),
      ...(placeholder !== undefined ? { placeholder } : {}),
      ...(activationMode !== undefined ? { activationMode } : {}),
      ...(selectOnFocus !== undefined ? { selectOnFocus } : {}),
      defaultEdit: getBoolean(el, "defaultEdit"),
      onValueChange: (details: ValueChangeDetails) => {
        notifyEditableValueChange(el, pushEvent, canPush, details.value, this, initialValue);
      },
      onValueCommit: (details: ValueChangeDetails) => {
        notifyEditableValueChange(el, pushEvent, canPush, details.value, this, initialValue);
      },
    } as Props);
    zag.init();
    this.editable = zag;

    syncEditableFormValue(el, zag.api.value, { markUsed: false });

    this.unbindFormSubmit = bindFormSubmitSync(el, zag);

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

    this.editable?.updateProps({
      id: el.id,
      disabled: getBoolean(el, "disabled"),
      readOnly: getBoolean(el, "readonly"),
      required: getBoolean(el, "required"),
      invalid: getBoolean(el, "invalid"),
      name: zagName(el),
      form: formValueInput(el) ? undefined : getString(el, "form"),
      dir: getDir(el),
    });
  },

  destroyed(this: object & HookInterface<HTMLElement> & EditableHookState) {
    this.unbindFormSubmit?.();
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.editable?.destroy();
  },
};

export { EditableHook as Editable };
