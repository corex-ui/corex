import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { PinInput } from "../components/pin-input";
import type { Props, ValueChangeDetails } from "@zag-js/pin-input";
import { getString, getBoolean, getNumber, getDir, canPushEvent } from "../lib/util";
import { getJsonStringList, mountStringListBinding } from "../lib/read-props";
import { syncArrayHiddenInputsForPhoenix } from "../lib/form-array-submit";
import { notifyPhoenixFormChange } from "../lib/live-view-form-input";
import {
  notifyChange,
  emitResponse,
  idMatches,
  readPayloadId,
  parseRespondTo,
  type RespondTo,
} from "../lib/respond-to";
import { createHookHandleEventRegistry } from "../lib/hook-handlers";
import { createDomEventRegistry } from "../lib/dom-events";

export function parseValueWithEmpties(raw: string): string[] {
  return raw.split(",").map((v) => v.trim());
}

export function padToCount(arr: string[], count: number): string[] {
  const copy = [...arr];
  while (copy.length < count) copy.push("");
  return copy.slice(0, count);
}

export function readPinValueList(el: HTMLElement, datasetKey: string, count: number): string[] {
  const json = getJsonStringList(el, datasetKey);
  if (json !== undefined) return padToCount(json, count);

  const raw = el.dataset[datasetKey];
  if (raw === undefined || raw === "") {
    return padToCount([], count);
  }
  return padToCount(parseValueWithEmpties(raw), count);
}

export function readDefaultValueList(el: HTMLElement, count: number): string[] {
  return readPinValueList(el, "defaultValue", count);
}

function padStringListBinding(
  el: HTMLElement,
  count: number
): { value: string[] } | { defaultValue: string[] } {
  const binding = mountStringListBinding(el);
  if ("value" in binding) {
    return { value: padToCount(binding.value, count) };
  }
  return { defaultValue: padToCount(binding.defaultValue, count) };
}

export function syncPinInputFormForPhoenix(
  el: HTMLElement,
  values: ReadonlyArray<string>,
  onTouched?: () => void,
  opts: { notifyLiveView?: boolean } = {}
): void {
  const submitName = getString(el, "submitName");
  const count = getNumber(el, "count") ?? 0;

  if (submitName) {
    syncArrayHiddenInputsForPhoenix(el, values, {
      onTouched,
      scope: "pin-input",
      submitName,
      fixedLength: count,
      notifyLiveView: opts.notifyLiveView,
      fieldTouched: opts.notifyLiveView === true,
    });
    return;
  }

  const hiddenInput = el.querySelector<HTMLInputElement>(
    '[data-scope="pin-input"][data-part="hidden-input"]'
  );
  if (!hiddenInput) return;
  if (opts.notifyLiveView === false) {
    notifyPhoenixFormChange(hiddenInput, values.join(""), { onTouched, markUsed: false });
    return;
  }
  notifyPhoenixFormChange(hiddenInput, values.join(""), { onTouched });
}

function zagNameForForm(el: HTMLElement): string | undefined {
  if (getString(el, "submitName")) return undefined;
  return getString(el, "name");
}

function buildMachineProps(
  el: HTMLElement,
  pushEvent: (name: string, payload: Record<string, unknown>) => void,
  canPush: () => boolean,
  allowFormNotify?: () => boolean
): Props {
  const count = getNumber(el, "count") ?? 0;

  return {
    id: el.id,
    count,
    ...padStringListBinding(el, count),
    disabled: getBoolean(el, "disabled"),
    invalid: getBoolean(el, "invalid"),
    required: getBoolean(el, "required"),
    readOnly: getBoolean(el, "readonly"),
    mask: getBoolean(el, "mask"),
    otp: getBoolean(el, "otp"),
    blurOnComplete: getBoolean(el, "blurOnComplete"),
    selectOnFocus: getBoolean(el, "selectOnFocus"),
    name: zagNameForForm(el),
    form: getString(el, "submitName") ? undefined : getString(el, "form"),
    dir: getDir(el),
    type: getString<"alphanumeric" | "numeric" | "alphabetic">(el, "type"),
    placeholder: getString(el, "placeholder"),
    onValueChange: (details: ValueChangeDetails) => {
      syncPinInputFormForPhoenix(el, details.value, undefined, {
        notifyLiveView: allowFormNotify?.() === true,
      });
      notifyChange({
        el,
        canPushServer: canPush(),
        pushEvent: pushEvent,
        payload: {
          id: el.id,
          value: details.value,
          valueAsString: details.valueAsString,
        },
        serverEventName: getString(el, "onValueChange"),
        clientEventName: getString(el, "onValueChangeClient"),
      });
    },
    onValueComplete: (details: ValueChangeDetails) => {
      notifyChange({
        el,
        canPushServer: canPush(),
        pushEvent: pushEvent,
        payload: {
          id: el.id,
          value: details.value,
          valueAsString: details.valueAsString,
        },
        serverEventName: getString(el, "onValueComplete"),
        clientEventName: getString(el, "onValueCompleteClient"),
      });
    },
  } as Props;
}

type PinInputHookState = {
  pinInput?: PinInput;
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
  allowFormNotify?: boolean;
};

const PinInputHook: Hook<object & PinInputHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & PinInputHookState) {
    const el = this.el;
    const hook = this as object & HookInterface<HTMLElement> & PinInputHookState;
    hook.allowFormNotify = false;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
    const allowFormNotify = () => hook.allowFormNotify === true;

    const zag = new PinInput(el, buildMachineProps(el, pushEvent, canPush, allowFormNotify));
    try {
      zag.init();
      this.pinInput = zag;
    } finally {
      el.removeAttribute("data-loading");
    }

    queueMicrotask(() => {
      syncPinInputFormForPhoenix(el, zag.api.value, undefined, { notifyLiveView: false });
      hook.allowFormNotify = true;
    });

    const emitValue = (respondTo: RespondTo) => {
      const api = zag.api;
      const value = api.value;
      const valueAsString = api.valueAsString;
      emitResponse({
        respondTo,
        canPushServer: canPush(),
        pushEvent: pushEvent,
        serverEventName: "pin_input_value_response",
        serverPayload: { id: el.id, value, valueAsString } as Record<string, unknown>,
        el,
        domEventName: "pin-input-value",
        domDetail: { id: el.id, value, valueAsString } as Record<string, unknown>,
      });
    };

    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;

    domRegistry.add<CustomEvent<{ value: string[] }>>("corex:pin-input:set-value", (event) => {
      const v = event.detail?.value;
      if (Array.isArray(v)) zag.api.setValue(v);
    });

    domRegistry.add<CustomEvent>("corex:pin-input:clear", () => {
      zag.api.clearValue();
    });

    domRegistry.add<CustomEvent>("corex:pin-input:value", (event) => {
      emitValue(parseRespondTo(event.detail));
    });

    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;

    registry.add("pin_input_set_value", (payload: { id?: string; value: string[] }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (Array.isArray(payload.value)) zag.api.setValue(payload.value);
    });

    registry.add("pin_input_clear", (payload: { id?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.clearValue();
    });

    registry.add("pin_input_value", (payload: { id?: string; respond_to?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitValue(parseRespondTo(payload));
    });
  },

  updated(this: object & HookInterface<HTMLElement> & PinInputHookState) {
    const el = this.el;
    const zag = this.pinInput;
    const count = getNumber(el, "count") ?? 0;

    zag?.updateProps({
      id: el.id,
      count,
      disabled: getBoolean(el, "disabled"),
      invalid: getBoolean(el, "invalid"),
      required: getBoolean(el, "required"),
      readOnly: getBoolean(el, "readonly"),
      mask: getBoolean(el, "mask"),
      otp: getBoolean(el, "otp"),
      blurOnComplete: getBoolean(el, "blurOnComplete"),
      selectOnFocus: getBoolean(el, "selectOnFocus"),
      name: zagNameForForm(el),
      form: getString(el, "submitName") ? undefined : getString(el, "form"),
      dir: getDir(el),
      type: getString<"alphanumeric" | "numeric" | "alphabetic">(el, "type"),
      placeholder: getString(el, "placeholder"),
    } as Partial<Props>);
  },

  destroyed(this: object & HookInterface<HTMLElement> & PinInputHookState) {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.pinInput?.destroy();
  },
};

export { PinInputHook as PinInput };
