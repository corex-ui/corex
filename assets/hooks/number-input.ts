import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { NumberInput } from "../components/number-input";
import type { Api, Props, ValueChangeDetails } from "@zag-js/number-input";
import {
  getString,
  getBoolean,
  getNumber,
  canPushEvent,
  getDir,
  syncInputFormAssociation,
} from "../lib/util";
import {
  formatDisplayValue,
  formatSubmitValue,
  mergeFormatOptions,
} from "../lib/number-input-format";
import { mountNumberBinding, readUpdatedServerNumber } from "../lib/read-props";
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
import {
  queueLiveViewFormInputSync,
  reapplyLiveViewValueInputUsage,
} from "../lib/live-view-form-input";

type NumberInputMachineState = {
  focused: boolean;
  invalid: boolean;
  empty: boolean;
  value: string;
  valueAsNumber: number;
};

export function machineState(api: Api): NumberInputMachineState {
  return {
    focused: api.focused,
    invalid: api.invalid,
    empty: api.empty,
    value: api.value,
    valueAsNumber: api.valueAsNumber,
  };
}

type NumberInputHookState = {
  numberInput?: NumberInput;
  lastServerValue?: string;
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
};

function submitValueForHost(el: HTMLElement, valueAsNumber: number): string {
  const step = getNumber(el, "step") ?? 1;
  if (!Number.isFinite(valueAsNumber) || Number.isNaN(valueAsNumber)) return "";
  return formatSubmitValue(valueAsNumber, step);
}

function canonicalDatasetValue(el: HTMLElement): string {
  return getString(el, "value") ?? getString(el, "defaultValue") ?? "";
}

function hiddenSubmitValue(el: HTMLElement, displayValue: string, valueAsNumber?: number): string {
  const step = getNumber(el, "step") ?? 1;

  if (
    valueAsNumber !== undefined &&
    Number.isFinite(valueAsNumber) &&
    !Number.isNaN(valueAsNumber)
  ) {
    return submitValueForHost(el, valueAsNumber);
  }

  const canonical = canonicalDatasetValue(el);
  if (canonical !== "") {
    return formatSubmitValue(canonical, step);
  }

  const stripped = (displayValue ?? "").replace(/,/g, "");
  if (stripped === "") return "";

  return formatSubmitValue(stripped, step);
}

export function syncNumberInputValueInput(
  el: HTMLElement,
  value: string,
  notifyForm = false,
  valueAsNumber?: number
): void {
  const valueInput = el.querySelector<HTMLInputElement>(
    '[data-scope="number-input"][data-part="value-input"]'
  );
  if (!valueInput) return;
  const v = hiddenSubmitValue(el, value, valueAsNumber);
  const changed = valueInput.value !== v;
  if (changed) valueInput.value = v;
  syncInputFormAssociation(valueInput, el);
  if (notifyForm && (changed || v !== "")) {
    reapplyLiveViewValueInputUsage(valueInput);
    valueInput.dispatchEvent(new Event("input", { bubbles: true }));
    valueInput.dispatchEvent(new Event("change", { bubbles: true }));
  }
}

function setZagValue(zag: NumberInput, value: number | string): void {
  const step = getNumber(zag.el, "step") ?? 1;

  if (typeof value === "number") {
    if (Number.isNaN(value)) return;
    zag.machine.service.send({
      type: "VALUE.SET",
      value: formatDisplayValue(value, step),
    });
    return;
  }

  const trimmed = value.trim();
  if (trimmed === "") return;

  zag.machine.service.send({ type: "VALUE.SET", value: trimmed });
}

export function buildMachineProps(
  el: HTMLElement,
  pushEvent: (name: string, payload: Record<string, unknown>) => void,
  canPush: () => boolean
): Props {
  const step = getNumber(el, "step") ?? 1;

  return {
    id: el.id,
    ...mountNumberBinding(el),
    min: getNumber(el, "min"),
    max: getNumber(el, "max"),
    step,
    formatOptions: mergeFormatOptions(step),
    disabled: getBoolean(el, "disabled"),
    readOnly: getBoolean(el, "readonly"),
    invalid: getBoolean(el, "invalid"),
    required: getBoolean(el, "required"),
    allowMouseWheel: getBoolean(el, "allowMouseWheel"),
    dir: getDir(el),
    onValueChange: (details: ValueChangeDetails) => {
      if (details.value !== undefined) {
        syncNumberInputValueInput(el, details.value ?? "", true, details.valueAsNumber);
      }
      notifyChange({
        el,
        canPushServer: canPush(),
        pushEvent,
        payload: {
          id: el.id,
          value: details.value,
          valueAsNumber: details.valueAsNumber,
        },
        serverEventName: getString(el, "onValueChange"),
        clientEventName: getString(el, "onValueChangeClient"),
      });
    },
  } as Props;
}

function numberInputPropsForUpdate(el: HTMLElement): Partial<Props> {
  const step = getNumber(el, "step") ?? 1;

  return {
    id: el.id,
    min: getNumber(el, "min"),
    max: getNumber(el, "max"),
    step,
    formatOptions: mergeFormatOptions(step),
    disabled: getBoolean(el, "disabled"),
    readOnly: getBoolean(el, "readonly"),
    invalid: getBoolean(el, "invalid"),
    required: getBoolean(el, "required"),
    allowMouseWheel: getBoolean(el, "allowMouseWheel"),
    dir: getDir(el),
  };
}

const NumberInputHook: Hook<object & NumberInputHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & NumberInputHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);

    const zag = new NumberInput(el, buildMachineProps(el, pushEvent, canPush));
    zag.init();
    this.numberInput = zag;
    this.lastServerValue = getString(el, "value") ?? getString(el, "defaultValue") ?? "";
    const initialSubmit = submitValueForHost(el, zag.api.valueAsNumber);
    syncNumberInputValueInput(el, zag.api.value ?? "", true, zag.api.valueAsNumber);
    const valueInput = el.querySelector<HTMLInputElement>(
      '[data-scope="number-input"][data-part="value-input"]'
    );
    if (valueInput) {
      queueLiveViewFormInputSync(valueInput, () => initialSubmit);
    }

    const emitState = (respondTo: RespondTo) => {
      const snapshot = machineState(zag.api);
      emitResponse({
        respondTo,
        canPushServer: canPush(),
        pushEvent,
        serverEventName: "number_input_state_response",
        serverPayload: { id: el.id, ...snapshot },
        el,
        domEventName: "number-input-state",
        domDetail: { id: el.id, ...snapshot },
      });
    };

    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;

    domRegistry.add<CustomEvent<{ value: number | string }>>(
      "corex:number-input:set-value",
      (event) => {
        const v = event.detail?.value;
        if (typeof v === "number" && !Number.isNaN(v)) setZagValue(zag, v);
        else if (typeof v === "string") setZagValue(zag, v);
      }
    );

    domRegistry.add<CustomEvent>("corex:number-input:clear-value", () => {
      zag.api.clearValue();
    });

    domRegistry.add<CustomEvent>("corex:number-input:increment", () => {
      zag.api.increment();
    });

    domRegistry.add<CustomEvent>("corex:number-input:decrement", () => {
      zag.api.decrement();
    });

    domRegistry.add<CustomEvent>("corex:number-input:set-to-min", () => {
      zag.api.setToMin();
    });

    domRegistry.add<CustomEvent>("corex:number-input:set-to-max", () => {
      zag.api.setToMax();
    });

    domRegistry.add<CustomEvent>("corex:number-input:focus", () => {
      zag.api.focus();
    });

    domRegistry.add<CustomEvent>("corex:number-input:state", (event) => {
      emitState(parseRespondTo(event.detail));
    });

    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;

    registry.add("number_input_set_value", (payload: { id?: string; value: number }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (typeof payload.value === "number" && !Number.isNaN(payload.value)) {
        setZagValue(zag, payload.value);
      }
    });

    registry.add("number_input_clear_value", (payload: { id?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.clearValue();
    });

    registry.add("number_input_increment", (payload: { id?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.increment();
    });

    registry.add("number_input_decrement", (payload: { id?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.decrement();
    });

    registry.add("number_input_set_to_min", (payload: { id?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.setToMin();
    });

    registry.add("number_input_set_to_max", (payload: { id?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.setToMax();
    });

    registry.add("number_input_focus", (payload: { id?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.focus();
    });

    registry.add("number_input_state", (payload: { id?: string; respond_to?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitState(parseRespondTo(payload));
    });
  },

  updated(this: object & HookInterface<HTMLElement> & NumberInputHookState) {
    const el = this.el;
    const zag = this.numberInput;
    if (!zag) return;

    const valuePatch = readUpdatedServerNumber(el, this.lastServerValue);
    if ("nextServerValue" in valuePatch && valuePatch.nextServerValue !== undefined) {
      this.lastServerValue = valuePatch.nextServerValue;
    }

    zag.updateProps({
      ...numberInputPropsForUpdate(el),
      ...(valuePatch.value !== undefined ? { value: valuePatch.value } : {}),
      ...(valuePatch.step !== undefined ? { step: valuePatch.step } : {}),
    } as Partial<Props>);

    queueMicrotask(() => {
      syncNumberInputValueInput(
        el,
        zag.api.value ?? getString(el, "defaultValue") ?? "",
        false,
        zag.api.valueAsNumber
      );
    });
  },

  destroyed(this: object & HookInterface<HTMLElement> & NumberInputHookState) {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.numberInput?.destroy();
  },
};

export { NumberInputHook as NumberInput };
