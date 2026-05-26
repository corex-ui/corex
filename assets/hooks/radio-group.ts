import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { RadioGroup } from "../components/radio-group";
import type { Props, ValueChangeDetails } from "@zag-js/radio-group";
import { getString, getBoolean, getDir, canPushEvent, syncInputFormAssociation } from "../lib/util";
import { readStringControlledZagProps, readUpdatedServerString } from "../lib/read-props";
import {
  emitResponse,
  idMatches,
  notifyChange,
  parseRespondTo,
  readPayloadId,
} from "../lib/respond-to";
import { createHookHandleEventRegistry } from "../lib/hook-handlers";
import { createDomEventRegistry } from "../lib/dom-events";
import {
  clearCorexFormFieldFeedback,
  hasCorexFormFieldValue,
  isCorexFormField,
} from "../lib/form-field-feedback";
import {
  notifyPhoenixFormChange,
  reapplyLiveViewValueInputUsage,
} from "../lib/live-view-form-input";

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
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
  lastServerValue?: string;
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

const RadioGroupHook: Hook<object & RadioGroupHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & RadioGroupHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
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
        if (isCorexFormField(el)) {
          this.lastServerValue = selected ?? undefined;
        }
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
            checked.dispatchEvent(new Event("input", { bubbles: true }));
            checked.dispatchEvent(new Event("change", { bubbles: true }));
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
    zag.init();
    this.radioGroup = zag;
    this.lastServerValue = getString(el, "value") ?? undefined;

    queueMicrotask(() => {
      if (!isCorexFormField(el)) return;
      syncRadioGroupValueInputForPhoenix(el, zag.api.value ?? null, { markUsed: false });
    });

    const valueInput = el.querySelector<HTMLInputElement>(
      '[data-scope="radio-group"][data-part="value-input"]'
    );
    if (valueInput) syncInputFormAssociation(valueInput, el);

    const emitValue = (respondTo: ReturnType<typeof parseRespondTo>) => {
      const value = zag.api.value;
      emitResponse({
        respondTo,
        canPushServer: canPush(),
        pushEvent,
        serverEventName: "radio_group_value_response",
        serverPayload: { id: el.id, value } as Record<string, unknown>,
        el,
        domEventName: "radio-group-value",
        domDetail: { id: el.id, value } as Record<string, unknown>,
      });
    };

    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;

    domRegistry.add<CustomEvent<{ value: string }>>("corex:radio-group:set-value", (event) => {
      zag.api.setValue(event.detail.value);
    });

    domRegistry.add("corex:radio-group:clear-value", () => {
      zag.api.clearValue();
    });

    domRegistry.add("corex:radio-group:focus", () => {
      zag.api.focus();
    });

    domRegistry.add<CustomEvent>("corex:radio-group:value", (event) => {
      emitValue(parseRespondTo(event.detail));
    });

    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;

    registry.add("radio_group_set_value", (payload: { id?: string; value: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.setValue(payload.value);
    });

    registry.add("radio_group_clear_value", (payload: { id?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.clearValue();
    });

    registry.add("radio_group_focus", (payload: { id?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.focus();
    });

    registry.add("radio_group_value", (payload: { id?: string; respond_to?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitValue(parseRespondTo(payload));
    });
  },

  updated(this: object & HookInterface<HTMLElement> & RadioGroupHookState) {
    const el = this.el;
    const zag = this.radioGroup;
    const valuePatch = readUpdatedServerString(el, this.lastServerValue);

    if ("value" in valuePatch) {
      this.lastServerValue = valuePatch.value ?? undefined;
    }

    zag?.updateProps({
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

  destroyed(this: object & HookInterface<HTMLElement> & RadioGroupHookState) {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.radioGroup?.destroy();
  },
};

export { RadioGroupHook as RadioGroup };
