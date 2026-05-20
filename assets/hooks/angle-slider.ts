import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { AngleSlider } from "../components/angle-slider";
import type { Props, ValueChangeDetails } from "@zag-js/angle-slider";
import { getString, getBoolean, getDir, canPushEvent } from "../lib/util";
import { readNumberControlledZagProps } from "../lib/read-props";
import {
  parseRespondTo,
  emitResponse,
  idMatches,
  readPayloadId,
  notifyChange,
  type RespondTo,
} from "../lib/respond-to";
import { createHookHandleEventRegistry } from "../lib/hook-handlers";
import { createDomEventRegistry } from "../lib/dom-events";

type AngleSliderHookState = {
  angleSlider?: AngleSlider;
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
};

export function valueChangePayload(el: HTMLElement, details: ValueChangeDetails): Record<string, unknown> {
  return {
    id: el.id,
    value: details.value,
    valueAsDegree: details.valueAsDegree,
  };
}

function queueFormBubblingInputForPhoenix(
  el: HTMLElement,
  getZag: () => InstanceType<typeof AngleSlider>
): void {
  queueMicrotask(() => {
    const zag = getZag();
    const input = el.querySelector<HTMLInputElement>(
      '[data-scope="angle-slider"][data-part="hidden-input"]'
    );
    if (!input) return;
    const v = zag.api.value;
    if (String(input.value) !== String(v)) {
      input.value = String(v);
    }
    input.dispatchEvent(new Event("input", { bubbles: true }));
    input.dispatchEvent(new Event("change", { bubbles: true }));
  });
}

const AngleSliderHook: Hook<object & AngleSliderHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & AngleSliderHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);

    const zag = new AngleSlider(el, {
      id: el.id,
      ...readNumberControlledZagProps(el),
      disabled: getBoolean(el, "disabled"),
      readOnly: getBoolean(el, "readonly"),
      invalid: getBoolean(el, "invalid"),
      name: getString(el, "name"),
      dir: getDir(el),
      "aria-label": getString(el, "aria-label"),
      "aria-labelledby": getString(el, "aria-labelledby"),

      onValueChange: (details: ValueChangeDetails) => {
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
    zag.init();
    this.angleSlider = zag;

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

    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;

    domRegistry.add<CustomEvent<{ value: number }>>("corex:angle-slider:set-value", (event) => {
      zag.api.setValue(event.detail.value);
      queueFormBubblingInputForPhoenix(el, () => zag);
    });

    domRegistry.add<CustomEvent>("corex:angle-slider:value", (event) => {
      emitValue(parseRespondTo(event.detail));
    });

    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;

    registry.add("angle_slider_set_value", (payload: { id?: string; value: number }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.setValue(payload.value);
      queueFormBubblingInputForPhoenix(el, () => zag);
    });

    registry.add("angle_slider_value", (payload: { id?: string; respond_to?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitValue(parseRespondTo(payload));
    });
  },

  updated(this: object & HookInterface<HTMLElement> & AngleSliderHookState) {
    this.angleSlider?.updateProps({
      id: this.el.id,
      ...readNumberControlledZagProps(this.el),
      disabled: getBoolean(this.el, "disabled"),
      readOnly: getBoolean(this.el, "readonly"),
      invalid: getBoolean(this.el, "invalid"),
      name: getString(this.el, "name"),
      dir: getDir(this.el),
    } as Partial<Props>);
  },

  destroyed(this: object & HookInterface<HTMLElement> & AngleSliderHookState) {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.angleSlider?.destroy();
  },
};

export { AngleSliderHook as AngleSlider };
