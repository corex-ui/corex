import { AngleSlider } from "../components/angle-slider";
import type { Props, ValueChangeDetails } from "@zag-js/angle-slider";
import { getString, getBoolean, getDir, canPushEvent } from "../lib/util";
import { mountNumberBinding, readUpdatedServerNumber } from "../lib/read-props";
import { createZagLiveHook } from "../lib/zag-live-hook";
import { notifyPhoenixFormChange } from "../lib/phoenix-form-bridge";
import {
  parseRespondTo,
  emitResponse,
  idMatches,
  readPayloadId,
  notifyChange,
  type RespondTo,
} from "../lib/respond-to";

type AngleSliderHookState = {
  angleSlider?: AngleSlider;
  fieldTouched?: boolean;
};

export function valueChangePayload(
  el: HTMLElement,
  details: ValueChangeDetails
): Record<string, unknown> {
  return {
    id: el.id,
    value: details.value,
    valueAsDegree: details.valueAsDegree,
  };
}

function formSubmitName(el: HTMLElement): string | undefined {
  return getString(el, "submitName") ?? getString(el, "name");
}

function hiddenInput(el: HTMLElement): HTMLInputElement | null {
  return el.querySelector<HTMLInputElement>(
    '[data-scope="angle-slider"][data-part="hidden-input"]'
  );
}

function ensureHiddenInputName(el: HTMLElement): HTMLInputElement | null {
  const input = hiddenInput(el);
  if (!input) return null;
  const name = formSubmitName(el);
  if (name && !input.getAttribute("name")) {
    input.setAttribute("name", name);
  }
  return input;
}

function stripHiddenInputName(el: HTMLElement): void {
  const input = hiddenInput(el);
  if (!input) return;
  input.removeAttribute("name");
  input.removeAttribute("form");
}

function zagNameForForm(el: HTMLElement): string | undefined {
  return hiddenInput(el)?.getAttribute("name") ?? undefined;
}

function queueFormBubblingInputForPhoenix(
  el: HTMLElement,
  getZag: () => InstanceType<typeof AngleSlider>,
  opts: { markUsed?: boolean } = {}
): void {
  queueMicrotask(() => {
    const zag = getZag();
    const input = ensureHiddenInputName(el);
    if (!input) return;
    notifyPhoenixFormChange(input, String(zag.api.value), {
      force: true,
      markUsed: opts.markUsed,
    });
  });
}

const AngleSliderHook = createZagLiveHook<AngleSliderHookState, AngleSlider>({
  key: "angleSlider",
  controlledKeys: ["value", "defaultValue"],
  mount(hook, { dom, server }) {
    const el = hook.el;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);
    hook.fieldTouched = getBoolean(el, "fieldUsed") === true;

    const zag = new AngleSlider(el, {
      id: el.id,
      ...mountNumberBinding(el),
      disabled: getBoolean(el, "disabled"),
      readOnly: getBoolean(el, "readonly"),
      invalid: getBoolean(el, "invalid"),
      name: zagNameForForm(el),
      dir: getDir(el),
      "aria-label": getString(el, "aria-label"),
      "aria-labelledby": getString(el, "aria-labelledby"),

      onValueChange: (details: ValueChangeDetails) => {
        hook.fieldTouched = true;
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: valueChangePayload(el, details),
          serverEventName: getString(el, "onValueChange"),
          clientEventName: getString(el, "onValueChangeClient"),
        });
      },
      onValueChangeEnd: (details: ValueChangeDetails) => {
        hook.fieldTouched = true;
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: valueChangePayload(el, details),
          serverEventName: getString(el, "onValueChangeEnd"),
          clientEventName: getString(el, "onValueChangeEndClient"),
        });
        queueFormBubblingInputForPhoenix(el, () => zag);
      },
    } as Props);

    const emitValue = (respondTo: RespondTo) => {
      emitResponse({
        respondTo,
        canPushServer: canPush(),
        pushEvent,
        serverEventName: "angle_slider_value_response",
        serverPayload: {
          id: el.id,
          value: zag.api.value,
          valueAsDegree: zag.api.valueAsDegree,
          dragging: zag.api.dragging,
        } as Record<string, unknown>,
        el,
        domEventName: "angle-slider-value",
        domDetail: {
          id: el.id,
          value: zag.api.value,
          valueAsDegree: zag.api.valueAsDegree,
          dragging: zag.api.dragging,
        } as Record<string, unknown>,
      });
    };

    dom.add<CustomEvent<{ value: number }>>("corex:angle-slider:set-value", (event) => {
      hook.fieldTouched = true;
      zag.api.setValue(event.detail.value);
      queueFormBubblingInputForPhoenix(el, () => zag);
    });

    dom.add<CustomEvent>("corex:angle-slider:value", (event) => {
      emitValue(parseRespondTo(event.detail));
    });

    server.add("angle_slider_set_value", (payload: { id?: string; value: number }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.setValue(payload.value);
      queueFormBubblingInputForPhoenix(el, () => zag, { markUsed: false });
    });

    server.add("angle_slider_value", (payload: { id?: string; respond_to?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitValue(parseRespondTo(payload));
    });

    return zag;
  },

  afterInit(hook, zag) {
    if (!hook.fieldTouched) {
      stripHiddenInputName(hook.el);
      zag.updateProps({ name: undefined } as Partial<Props>);
      zag.render();
    }
  },

  update(hook, zag) {
    const el = hook.el;
    const valuePatch = readUpdatedServerNumber(el, hook.beforeAttrs);
    if (getBoolean(el, "fieldUsed")) {
      hook.fieldTouched = true;
    }

    const name = hook.fieldTouched ? formSubmitName(el) : zagNameForForm(el);

    zag.updateProps({
      id: el.id,
      disabled: getBoolean(el, "disabled"),
      readOnly: getBoolean(el, "readonly"),
      invalid: getBoolean(el, "invalid"),
      name,
      dir: getDir(el),
      ...(valuePatch.value !== undefined ? { value: valuePatch.value } : {}),
      ...(valuePatch.step !== undefined ? { step: valuePatch.step } : {}),
    } as Partial<Props>);

    zag.render();

    if (!hook.fieldTouched) {
      stripHiddenInputName(el);
    }
  },
});

export { AngleSliderHook as AngleSlider };
