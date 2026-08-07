import { PinInput } from "../components/pin-input";
import type { Props, ValueChangeDetails } from "@zag-js/pin-input";
import { getString, getBoolean, getNumber, getDir, canPushEvent } from "../lib/util";
import {
  getJsonStringList,
  mountStringListBinding,
  readUpdatedServerStringList,
} from "../lib/read-props";
import {
  bindArrayFieldSubmitIntent,
  setArrayValues,
  setScalarValue,
} from "../lib/phoenix-form-bridge";
import { isFormFieldUsed } from "../lib/form-array-submit";
import { createZagLiveHook } from "../lib/zag-live-hook";
import {
  notifyChange,
  emitResponse,
  idMatches,
  readPayloadId,
  parseRespondTo,
  type RespondTo,
} from "../lib/respond-to";

/** Classify pin fill state for form notify / tests. */
export function pinValueCommitKind(
  values: ReadonlyArray<string>
): "complete" | "empty" | "partial" {
  if (values.length === 0 || values.every((v) => String(v).trim() === "")) return "empty";
  if (values.every((v) => String(v).trim() !== "")) return "complete";
  return "partial";
}

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
  opts: { notifyLiveView?: boolean; fieldTouched?: boolean } = {}
): void {
  const submitName = getString(el, "submitName");
  const count = getNumber(el, "count") ?? 0;
  const fieldTouched = isFormFieldUsed(el, opts.fieldTouched === true);

  if (submitName) {
    setArrayValues(el, values, {
      onTouched,
      scope: "pin-input",
      submitName,
      fixedLength: count,
      notifyLiveView: opts.notifyLiveView,
      fieldTouched,
    });
    return;
  }

  const hiddenInput = el.querySelector<HTMLInputElement>(
    '[data-scope="pin-input"][data-part="hidden-input"]'
  );
  if (!hiddenInput) return;
  if (opts.notifyLiveView === false) {
    setScalarValue(hiddenInput, values.join(""), {
      onTouched,
      markUsed: false,
      dispatch: false,
    });
    return;
  }
  setScalarValue(hiddenInput, values.join(""), { onTouched });
}

function zagNameForForm(el: HTMLElement): string | undefined {
  if (getString(el, "submitName")) return undefined;
  return getString(el, "name");
}

function sameStringList(a: ReadonlyArray<string>, b: ReadonlyArray<string>): boolean {
  return a.length === b.length && a.every((v, i) => v === b[i]);
}

function buildMachineProps(
  el: HTMLElement,
  pushEvent: (name: string, payload: Record<string, unknown>) => void,
  canPush: () => boolean,
  initialValues: ReadonlyArray<string>,
  markFieldTouched: () => void,
  isEdited: () => boolean,
  markEdited: () => void
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
      if (!sameStringList(details.value, initialValues)) {
        markEdited();
      }
      const kind = pinValueCommitKind(details.value);

      // Local DOM always; mid-entry never phx-change.
      syncPinInputFormForPhoenix(el, details.value, undefined, {
        notifyLiveView: false,
        fieldTouched: false,
      });

      // After the user has edited, clearing all cells must notify so
      // validate_required can show "can't be blank".
      if (kind === "empty" && isEdited()) {
        markFieldTouched();
        syncPinInputFormForPhoenix(el, details.value, undefined, {
          notifyLiveView: true,
          fieldTouched: true,
        });
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
      markEdited();
      markFieldTouched();
      syncPinInputFormForPhoenix(el, details.value, undefined, {
        notifyLiveView: true,
        fieldTouched: true,
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
        serverEventName: getString(el, "onValueComplete"),
        clientEventName: getString(el, "onValueCompleteClient"),
      });
    },
  } as Props;
}

type PinInputHookState = {
  pinInput?: PinInput;
  fieldTouched?: boolean;
  hasEdited?: boolean;
  unbindSubmitIntent?: () => void;
};

const PinInputHook = createZagLiveHook<PinInputHookState, PinInput>({
  key: "pinInput",
  controlledKeys: ["value"],
  mount(hook, { dom, server }) {
    const el = hook.el;
    hook.fieldTouched = getBoolean(el, "fieldUsed") === true;
    hook.hasEdited = hook.fieldTouched === true;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);
    const count = getNumber(el, "count") ?? 0;
    const binding = padStringListBinding(el, count);
    const initialValues = "value" in binding ? binding.value : binding.defaultValue;

    const zag = new PinInput(
      el,
      buildMachineProps(
        el,
        pushEvent,
        canPush,
        initialValues,
        () => {
          hook.fieldTouched = true;
        },
        () => hook.hasEdited === true,
        () => {
          hook.hasEdited = true;
        }
      )
    );

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

    const clearAndSync = () => {
      hook.fieldTouched = true;
      hook.hasEdited = true;
      zag.api.clearValue();
      syncPinInputFormForPhoenix(el, zag.api.value, undefined, {
        notifyLiveView: true,
        fieldTouched: true,
      });
    };

    hook.unbindSubmitIntent = bindArrayFieldSubmitIntent(el, () => {
      hook.fieldTouched = true;
      hook.hasEdited = true;
      syncPinInputFormForPhoenix(el, zag.api.value, undefined, {
        notifyLiveView: false,
        fieldTouched: true,
      });
    });

    dom.add<CustomEvent<{ value: string[] }>>("corex:pin-input:set-value", (event) => {
      const v = event.detail?.value;
      if (Array.isArray(v)) zag.api.setValue(v);
    });

    dom.add<CustomEvent>("corex:pin-input:clear", () => {
      clearAndSync();
    });

    dom.add<CustomEvent>("corex:pin-input:value", (event) => {
      emitValue(parseRespondTo(event.detail));
    });

    server.add("pin_input_set_value", (payload: { id?: string; value: string[] }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (Array.isArray(payload.value)) zag.api.setValue(payload.value);
    });

    server.add("pin_input_clear", (payload: { id?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      clearAndSync();
    });

    server.add("pin_input_value", (payload: { id?: string; respond_to?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitValue(parseRespondTo(payload));
    });

    return zag;
  },

  afterInit(hook, zag) {
    syncPinInputFormForPhoenix(hook.el, zag.api.value, undefined, {
      notifyLiveView: false,
      fieldTouched: hook.fieldTouched === true,
    });
  },

  update(hook, zag) {
    const el = hook.el;

    if (getBoolean(el, "fieldUsed")) {
      hook.fieldTouched = true;
      hook.hasEdited = true;
    }

    const count = getNumber(el, "count") ?? 0;

    const valuePatch = readUpdatedServerStringList(el, hook.beforeAttrs);
    const pinFocused = el.contains(document.activeElement);

    zag.updateProps({
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
      // Don't clobber in-progress entry when a sibling field re-renders the form.
      ...(valuePatch.value !== undefined && !pinFocused
        ? { value: padToCount(valuePatch.value, count) }
        : {}),
    } as Partial<Props>);

    syncPinInputFormForPhoenix(el, zag.api.value, undefined, {
      notifyLiveView: false,
      fieldTouched: hook.fieldTouched === true,
    });
    zag.render();
  },

  destroy(hook) {
    hook.unbindSubmitIntent?.();
    hook.unbindSubmitIntent = undefined;
  },
});

export { PinInputHook as PinInput };
