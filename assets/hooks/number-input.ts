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
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
};

export function syncNumberInputValueInput(
  el: HTMLElement,
  value: string,
  notifyForm = false
): void {
  const valueInput = el.querySelector<HTMLInputElement>(
    '[data-scope="number-input"][data-part="value-input"]'
  );
  if (!valueInput) return;
  const v = value ?? "";
  const changed = valueInput.value !== v;
  if (changed) valueInput.value = v;
  syncInputFormAssociation(valueInput, el);
  if (notifyForm && (changed || v !== "")) {
    reapplyLiveViewValueInputUsage(valueInput);
    valueInput.dispatchEvent(new Event("input", { bubbles: true }));
    valueInput.dispatchEvent(new Event("change", { bubbles: true }));
  }
}

export function buildMachineProps(
  el: HTMLElement,
  pushEvent: (name: string, payload: Record<string, unknown>) => void,
  canPush: () => boolean
): Props {
  return {
    id: el.id,
    ...mountNumberBinding(el),
    min: getNumber(el, "min"),
    max: getNumber(el, "max"),
    step: getNumber(el, "step"),
    disabled: getBoolean(el, "disabled"),
    readOnly: getBoolean(el, "readonly"),
    invalid: getBoolean(el, "invalid"),
    required: getBoolean(el, "required"),
    allowMouseWheel: getBoolean(el, "allowMouseWheel"),
    dir: getDir(el),
    onValueChange: (details: ValueChangeDetails) => {
      if (details.value !== undefined) {
        syncNumberInputValueInput(el, details.value ?? "", true);
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

const NumberInputHook: Hook<object & NumberInputHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & NumberInputHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);

    const zag = new NumberInput(el, buildMachineProps(el, pushEvent, canPush));
    zag.init();
    this.numberInput = zag;
    const initial = String(zag.api.value ?? getString(el, "defaultValue") ?? "");
    syncNumberInputValueInput(el, initial, true);
    const valueInput = el.querySelector<HTMLInputElement>(
      '[data-scope="number-input"][data-part="value-input"]'
    );
    if (valueInput) {
      queueLiveViewFormInputSync(valueInput, () => initial);
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

    domRegistry.add<CustomEvent<{ value: number }>>("corex:number-input:set-value", (event) => {
      const v = event.detail?.value;
      if (typeof v === "number" && !Number.isNaN(v)) zag.api.setValue(v);
    });

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
        zag.api.setValue(payload.value);
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
    const valuePatch = readUpdatedServerNumber(el);

    const next: Partial<Props> = {
      id: el.id,
      min: getNumber(el, "min"),
      max: getNumber(el, "max"),
      step: getNumber(el, "step"),
      disabled: getBoolean(el, "disabled"),
      readOnly: getBoolean(el, "readonly"),
      invalid: getBoolean(el, "invalid"),
      required: getBoolean(el, "required"),
      allowMouseWheel: getBoolean(el, "allowMouseWheel"),
      dir: getDir(el),
    };
    Object.assign(next, valuePatch);
    zag?.updateProps(next);

    queueMicrotask(() => {
      if (zag && "value" in valuePatch) {
        syncNumberInputValueInput(el, String(valuePatch.value ?? ""), false);
      } else if (zag) {
        syncNumberInputValueInput(el, zag.api.value ?? getString(el, "defaultValue") ?? "");
      }
      const visible = el.querySelector<HTMLInputElement>(
        '[data-scope="number-input"][data-part="input"]'
      );
      if (visible) {
        if (!getBoolean(el, "readonly")) {
          visible.readOnly = false;
          visible.removeAttribute("readonly");
        }
        if (!getBoolean(el, "disabled")) {
          visible.disabled = false;
          visible.removeAttribute("disabled");
        }
      }

      const triggers = el.querySelectorAll<HTMLButtonElement>(
        '[data-scope="number-input"][data-part="increment-trigger"], [data-scope="number-input"][data-part="decrement-trigger"]'
      );
      triggers.forEach((trigger) => {
        if (trigger.hasAttribute("data-disabled")) return;
        trigger.disabled = false;
        trigger.removeAttribute("disabled");
      });
    });
  },

  destroyed(this: object & HookInterface<HTMLElement> & NumberInputHookState) {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.numberInput?.destroy();
  },
};

export { NumberInputHook as NumberInput };
