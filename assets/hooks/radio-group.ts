import { RadioGroup } from "../components/radio-group";
import type { Props, ValueChangeDetails } from "@zag-js/radio-group";
import { getString, getBoolean, getDir, canPushEvent, syncInputFormAssociation } from "../lib/util";
import { readStringControlledZagProps, readUpdatedServerString } from "../lib/read-props";
import { createZagLiveHook } from "../lib/zag-live-hook";
import {
  idMatches,
  notifyChange,
  parseRespondTo,
  readPayloadId,
  createValueEmitter,
} from "../lib/respond-to";
import {
  clearCorexFormFieldFeedback,
  hasCorexFormFieldValue,
  isCorexFormField,
} from "../lib/form-field-feedback";
import {
  notifyPhoenixFormChange,
  reapplyLiveViewValueInputUsage,
  dispatchFormInputEvents,
} from "../lib/phoenix-form-bridge";

function syncRadioGroupValueInputForPhoenix(
  el: HTMLElement,
  value: string | null,
  options: { markUsed?: boolean } = {}
) {
  const valueInput = el.querySelector<HTMLInputElement>(
    '[data-scope="radio-group"][data-part="value-input"]'
  );
  if (!valueInput) return;
  notifyPhoenixFormChange(valueInput, value ?? "", options);
}

type RadioGroupHookState = {
  radioGroup?: RadioGroup;
};

export function valueChangePayload(
  el: HTMLElement,
  details: ValueChangeDetails
): Record<string, unknown> {
  return {
    id: el.id,
    value: details.value,
  };
}

const RadioGroupHook = createZagLiveHook<RadioGroupHookState, RadioGroup>({
  key: "radioGroup",
  controlledKeys: ["value"],
  mount(hook, { dom, server }) {
    const el = hook.el;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);
    const zag = new RadioGroup(el, {
      id: el.id,
      ...readStringControlledZagProps(el, "value", "defaultValue"),
      name: getString(el, "name"),
      form: getString(el, "form"),
      disabled: getBoolean(el, "disabled"),
      invalid: getBoolean(el, "invalid"),
      required: getBoolean(el, "required"),
      readOnly: getBoolean(el, "readonly"),
      dir: getDir(el),
      orientation: getString<"horizontal" | "vertical">(el, "orientation"),
      onValueChange: (details: ValueChangeDetails) => {
        const selected = details.value;
        el.querySelectorAll<HTMLInputElement>(
          '[data-scope="radio-group"][data-part="item-hidden-input"]'
        ).forEach((input) => {
          const on = input.value === selected;
          if (input.checked !== on) input.checked = on;
          syncInputFormAssociation(input, el);
        });
        syncRadioGroupValueInputForPhoenix(el, selected);

        if (isCorexFormField(el) && hasCorexFormFieldValue(selected)) {
          clearCorexFormFieldFeedback(el, "radio-group");
          zag.updateProps({ invalid: false } as Partial<Props>);
        }

        const valueInput = el.querySelector<HTMLInputElement>(
          '[data-scope="radio-group"][data-part="value-input"]'
        );
        if (!valueInput) {
          const checked = el.querySelector<HTMLInputElement>(
            '[data-scope="radio-group"][data-part="item-hidden-input"]:checked'
          );
          if (checked) {
            reapplyLiveViewValueInputUsage(checked);
            dispatchFormInputEvents(checked);
          }
        }
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: valueChangePayload(el, details),
          serverEventName: getString(el, "onValueChange"),
          clientEventName: getString(el, "onValueChangeClient"),
        });
      },
    } as Props);

    queueMicrotask(() => {
      if (!isCorexFormField(el)) return;
      syncRadioGroupValueInputForPhoenix(el, zag.api.value ?? null, { markUsed: false });
    });

    const valueInput = el.querySelector<HTMLInputElement>(
      '[data-scope="radio-group"][data-part="value-input"]'
    );
    if (valueInput) syncInputFormAssociation(valueInput, el);

    const emitValue = createValueEmitter(
      { el, pushEvent, canPushServer: canPush },
      {
        getValue: () => zag.api.value,
        serverEventName: "radio_group_value_response",
        domEventName: "radio-group-value",
      }
    );

    dom.add<CustomEvent<{ value: string }>>("corex:radio-group:set-value", (event) => {
      zag.api.setValue(event.detail.value);
    });

    dom.add("corex:radio-group:clear-value", () => {
      zag.api.clearValue();
    });

    dom.add("corex:radio-group:focus", () => {
      zag.api.focus();
    });

    dom.add<CustomEvent>("corex:radio-group:value", (event) => {
      emitValue(parseRespondTo(event.detail));
    });

    server.add("radio_group_set_value", (payload: { id?: string; value: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.setValue(payload.value);
    });

    server.add("radio_group_clear_value", (payload: { id?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.clearValue();
    });

    server.add("radio_group_focus", (payload: { id?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.focus();
    });

    server.add("radio_group_value", (payload: { id?: string; respond_to?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitValue(parseRespondTo(payload));
    });

    return zag;
  },

  update(hook, zag) {
    const el = hook.el;
    const valuePatch = readUpdatedServerString(el, hook.beforeAttrs);

    zag.updateProps({
      id: el.id,
      ...valuePatch,
      name: getString(el, "name"),
      disabled: getBoolean(el, "disabled"),
      invalid: getBoolean(el, "invalid"),
      required: getBoolean(el, "required"),
      readOnly: getBoolean(el, "readonly"),
      orientation: getString<"horizontal" | "vertical">(el, "orientation"),
      dir: getDir(el),
    } as Partial<Props>);

    if ("value" in valuePatch) {
      syncRadioGroupValueInputForPhoenix(el, valuePatch.value ?? null, { markUsed: false });
    }
  },
});

export { RadioGroupHook as RadioGroup };
