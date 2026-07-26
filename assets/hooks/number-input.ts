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
import { markUsed, syncFormInput, dispatchFormInputEvents } from "../lib/phoenix-form-bridge";
import { createZagLiveHook } from "../lib/zag-live-hook";

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
    markUsed(valueInput);
    dispatchFormInputEvents(valueInput);
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

const NumberInputHook = createZagLiveHook<NumberInputHookState, NumberInput>({
  key: "numberInput",
  controlledKeys: ["value", "defaultValue"],
  mount(hook, { dom, server }) {
    const el = hook.el;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);

    const zag = new NumberInput(el, buildMachineProps(el, pushEvent, canPush));

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

    dom.add<CustomEvent<{ value: number | string }>>("corex:number-input:set-value", (event) => {
      const v = event.detail?.value;
      if (typeof v === "number" && !Number.isNaN(v)) setZagValue(zag, v);
      else if (typeof v === "string") setZagValue(zag, v);
    });

    dom.add<CustomEvent>("corex:number-input:clear-value", () => {
      zag.api.clearValue();
    });

    dom.add<CustomEvent>("corex:number-input:increment", () => {
      zag.api.increment();
    });

    dom.add<CustomEvent>("corex:number-input:decrement", () => {
      zag.api.decrement();
    });

    dom.add<CustomEvent>("corex:number-input:set-to-min", () => {
      zag.api.setToMin();
    });

    dom.add<CustomEvent>("corex:number-input:set-to-max", () => {
      zag.api.setToMax();
    });

    dom.add<CustomEvent>("corex:number-input:focus", () => {
      zag.api.focus();
    });

    dom.add<CustomEvent>("corex:number-input:state", (event) => {
      emitState(parseRespondTo(event.detail));
    });

    server.add("number_input_set_value", (payload: { id?: string; value: number }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (typeof payload.value === "number" && !Number.isNaN(payload.value)) {
        setZagValue(zag, payload.value);
      }
    });

    server.add("number_input_clear_value", (payload: { id?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.clearValue();
    });

    server.add("number_input_increment", (payload: { id?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.increment();
    });

    server.add("number_input_decrement", (payload: { id?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.decrement();
    });

    server.add("number_input_set_to_min", (payload: { id?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.setToMin();
    });

    server.add("number_input_set_to_max", (payload: { id?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.setToMax();
    });

    server.add("number_input_focus", (payload: { id?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.focus();
    });

    server.add("number_input_state", (payload: { id?: string; respond_to?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitState(parseRespondTo(payload));
    });

    return zag;
  },

  afterInit(hook, zag) {
    const el = hook.el;
    const initialSubmit = submitValueForHost(el, zag.api.valueAsNumber);
    syncNumberInputValueInput(el, zag.api.value ?? "", true, zag.api.valueAsNumber);

    const valueInput = el.querySelector<HTMLInputElement>(
      '[data-scope="number-input"][data-part="value-input"]'
    );
    if (valueInput) {
      syncFormInput(valueInput, () => initialSubmit);
    }
  },

  update(hook, zag) {
    const el = hook.el;

    const valuePatch = readUpdatedServerNumber(el, hook.beforeAttrs);

    zag.updateProps({
      ...numberInputPropsForUpdate(el),
      ...(valuePatch.value !== undefined ? { value: valuePatch.value } : {}),
      ...(valuePatch.step !== undefined ? { step: valuePatch.step } : {}),
    } as Partial<Props>);

    syncNumberInputValueInput(
      el,
      zag.api.value ?? getString(el, "defaultValue") ?? "",
      false,
      zag.api.valueAsNumber
    );
  },
});

export { NumberInputHook as NumberInput };
