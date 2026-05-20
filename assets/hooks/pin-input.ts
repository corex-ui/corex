import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { PinInput } from "../components/pin-input";
import type { Props, ValueChangeDetails } from "@zag-js/pin-input";
import { getString, getBoolean, getNumber, getDir, canPushEvent } from "../lib/util";
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

function parseValueWithEmpties(raw: string): string[] {
  return raw.split(",").map((v) => v.trim());
}

function padToCount(arr: string[], count: number): string[] {
  const copy = [...arr];
  while (copy.length < count) copy.push("");
  return copy.slice(0, count);
}

function readDefaultValueList(el: HTMLElement, count: number): string[] {
  const raw = el.dataset.defaultValue;
  if (raw === undefined || raw === "") {
    return [];
  }
  return padToCount(parseValueWithEmpties(raw), count);
}

function buildMachineProps(
  el: HTMLElement,
  pushEvent: (name: string, payload: Record<string, unknown>) => void,
  canPush: () => boolean
): Props {
  const count = getNumber(el, "count");

  return {
    id: el.id,
    count,
    defaultValue: readDefaultValueList(el, count ?? 0),
    disabled: getBoolean(el, "disabled"),
    invalid: getBoolean(el, "invalid"),
    required: getBoolean(el, "required"),
    readOnly: getBoolean(el, "readonly"),
    mask: getBoolean(el, "mask"),
    otp: getBoolean(el, "otp"),
    blurOnComplete: getBoolean(el, "blurOnComplete"),
    selectOnFocus: getBoolean(el, "selectOnFocus"),
    name: getString(el, "name"),
    form: getString(el, "form"),
    dir: getDir(el),
    type: getString<"alphanumeric" | "numeric" | "alphabetic">(el, "type"),
    placeholder: getString(el, "placeholder"),
    onValueChange: (details: ValueChangeDetails) => {
      const hiddenInput = el.querySelector<HTMLInputElement>(
        '[data-scope="pin-input"][data-part="hidden-input"]'
      );
      if (hiddenInput) {
        hiddenInput.value = details.valueAsString;
        hiddenInput.dispatchEvent(new Event("input", { bubbles: true }));
        hiddenInput.dispatchEvent(new Event("change", { bubbles: true }));
      }
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
};

const PinInputHook: Hook<object & PinInputHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & PinInputHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);

    const zag = new PinInput(el, buildMachineProps(el, pushEvent, canPush));
    zag.init();
    this.pinInput = zag;

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
    const count = getNumber(el, "count");
    this.pinInput?.updateProps({
      id: el.id,
      count,
      defaultValue: readDefaultValueList(el, count ?? 0),
      disabled: getBoolean(el, "disabled"),
      invalid: getBoolean(el, "invalid"),
      required: getBoolean(el, "required"),
      readOnly: getBoolean(el, "readonly"),
      mask: getBoolean(el, "mask"),
      otp: getBoolean(el, "otp"),
      blurOnComplete: getBoolean(el, "blurOnComplete"),
      selectOnFocus: getBoolean(el, "selectOnFocus"),
      name: getString(el, "name"),
      form: getString(el, "form"),
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
