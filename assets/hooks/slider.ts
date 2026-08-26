import { Slider } from "../components/slider";
import type { Props, ValueChangeDetails } from "@zag-js/slider";
import { getString, getBoolean, getDir, getNumber, canPushEvent } from "../lib/util";
import { mountNumberListBinding, readUpdatedServerNumberList } from "../lib/read-props";
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

type SliderHookState = {
  slider?: Slider;
  fieldTouched?: boolean;
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

function formSubmitName(el: HTMLElement): string | undefined {
  return getString(el, "submitName") ?? getString(el, "name");
}

function hiddenInputs(el: HTMLElement): HTMLInputElement[] {
  return Array.from(
    el.querySelectorAll<HTMLElement>('[data-scope="slider"][data-part="hidden-input"]')
  ).filter((node): node is HTMLInputElement => node instanceof HTMLInputElement);
}

function ensureHiddenInputNames(el: HTMLElement): HTMLInputElement[] {
  const inputs = hiddenInputs(el);
  const name = formSubmitName(el);
  if (name) {
    for (const input of inputs) {
      if (!input.getAttribute("name")) {
        input.setAttribute("name", name);
      }
    }
  }
  return inputs;
}

function stripHiddenInputNames(el: HTMLElement): void {
  for (const input of hiddenInputs(el)) {
    input.removeAttribute("name");
    input.removeAttribute("form");
  }
}

function shouldGateHiddenName(el: HTMLElement): boolean {
  return Boolean(formSubmitName(el)) && getString(el, "name") === undefined;
}

function queueFormBubblingInputForPhoenix(
  el: HTMLElement,
  getZag: () => InstanceType<typeof Slider>,
  opts: { markUsed?: boolean } = {}
): void {
  queueMicrotask(() => {
    const zag = getZag();
    const inputs = ensureHiddenInputNames(el);
    if (inputs.length === 0) return;
    const values = zag.api.value;
    inputs.forEach((input, i) => {
      notifyPhoenixFormChange(input, String(values[i] ?? ""), {
        force: true,
        markUsed: opts.markUsed,
      });
    });
  });
}

export function coerceSliderValues(value: unknown): number[] {
  if (Array.isArray(value)) {
    const nums = value.map((item) => Number(item)).filter((n) => Number.isFinite(n));
    return nums.length > 0 ? nums : [0];
  }
  if (typeof value === "number" && Number.isFinite(value)) return [value];
  if (typeof value === "string") {
    const trimmed = value.trim();
    if (trimmed.startsWith("[")) {
      try {
        return coerceSliderValues(JSON.parse(trimmed));
      } catch {
        return [0];
      }
    }
    const n = Number(trimmed);
    return Number.isFinite(n) ? [n] : [0];
  }
  return [0];
}

function readIndex(source: unknown): number {
  if (!source || typeof source !== "object") return 0;
  const o = source as Record<string, unknown>;
  const raw = o.index ?? o["index"];
  const n = Number(raw ?? 0);
  return Number.isFinite(n) ? n : 0;
}

function readThumbValue(source: unknown): number {
  if (!source || typeof source !== "object") return 0;
  const o = source as Record<string, unknown>;
  const n = Number(o.value ?? o["value"] ?? 0);
  return Number.isFinite(n) ? n : 0;
}

function sliderStaticProps(el: HTMLElement): Partial<Props> {
  const orientation = getString(el, "orientation", ["horizontal", "vertical"] as const);
  const origin = getString(el, "origin", ["start", "center", "end"] as const);
  const thumbAlignment = getString(el, "thumbAlignment", ["contain", "center"] as const);
  const thumbCollisionBehavior = getString(el, "thumbCollisionBehavior", [
    "none",
    "push",
    "swap",
  ] as const);

  return {
    min: getNumber(el, "min") ?? 0,
    max: getNumber(el, "max") ?? 100,
    step: getNumber(el, "step") ?? 1,
    ...(getNumber(el, "largeStep") !== undefined ? { largeStep: getNumber(el, "largeStep") } : {}),
    ...(orientation !== undefined ? { orientation } : {}),
    ...(origin !== undefined ? { origin } : {}),
    ...(thumbAlignment !== undefined ? { thumbAlignment } : {}),
    ...(getNumber(el, "minStepsBetweenThumbs") !== undefined
      ? { minStepsBetweenThumbs: getNumber(el, "minStepsBetweenThumbs") }
      : {}),
    ...(thumbCollisionBehavior !== undefined ? { thumbCollisionBehavior } : {}),
    disabled: getBoolean(el, "disabled"),
    readOnly: getBoolean(el, "readonly"),
    invalid: getBoolean(el, "invalid"),
    dir: getDir(el),
    form: shouldGateHiddenName(el) ? undefined : getString(el, "form"),
  };
}

const SliderHook = createZagLiveHook<SliderHookState, Slider>({
  key: "slider",
  controlledKeys: ["value", "defaultValue"],
  mount(hook, { dom, server }) {
    const el = hook.el;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);
    hook.fieldTouched = getBoolean(el, "fieldUsed") === true;

    const zag = new Slider(el, {
      id: el.id,
      ...mountNumberListBinding(el),
      ...sliderStaticProps(el),
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
        serverEventName: "slider_value_response",
        serverPayload: {
          id: el.id,
          value: zag.api.value,
          dragging: zag.api.dragging,
        } as Record<string, unknown>,
        el,
        domEventName: "slider-value",
        domDetail: {
          id: el.id,
          value: zag.api.value,
          dragging: zag.api.dragging,
        } as Record<string, unknown>,
      });
    };

    const applyValues = (values: number[]) => {
      hook.fieldTouched = true;
      zag.api.setValue(values);
      queueFormBubblingInputForPhoenix(el, () => zag);
    };

    dom.add<CustomEvent<{ value?: unknown }>>("corex:slider:set-value", (event) => {
      applyValues(coerceSliderValues(event.detail?.value));
    });

    dom.add<CustomEvent<{ index?: unknown; value?: unknown }>>(
      "corex:slider:set-thumb-value",
      (event) => {
        hook.fieldTouched = true;
        zag.api.setThumbValue(readIndex(event.detail), readThumbValue(event.detail));
        queueFormBubblingInputForPhoenix(el, () => zag);
      }
    );

    dom.add<CustomEvent<{ index?: unknown }>>("corex:slider:increment", (event) => {
      hook.fieldTouched = true;
      zag.api.increment(readIndex(event.detail));
      queueFormBubblingInputForPhoenix(el, () => zag);
    });

    dom.add<CustomEvent<{ index?: unknown }>>("corex:slider:decrement", (event) => {
      hook.fieldTouched = true;
      zag.api.decrement(readIndex(event.detail));
      queueFormBubblingInputForPhoenix(el, () => zag);
    });

    dom.add<CustomEvent>("corex:slider:value", (event) => {
      emitValue(parseRespondTo(event.detail));
    });

    server.add("slider_set_value", (payload: { id?: string; value?: unknown }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.setValue(coerceSliderValues(payload.value));
      queueFormBubblingInputForPhoenix(el, () => zag, { markUsed: false });
    });

    server.add(
      "slider_set_thumb_value",
      (payload: { id?: string; index?: unknown; value?: unknown }) => {
        if (!idMatches(el.id, readPayloadId(payload))) return;
        zag.api.setThumbValue(readIndex(payload), readThumbValue(payload));
        queueFormBubblingInputForPhoenix(el, () => zag, { markUsed: false });
      }
    );

    server.add("slider_increment", (payload: { id?: string; index?: unknown }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.increment(readIndex(payload));
      queueFormBubblingInputForPhoenix(el, () => zag, { markUsed: false });
    });

    server.add("slider_decrement", (payload: { id?: string; index?: unknown }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.decrement(readIndex(payload));
      queueFormBubblingInputForPhoenix(el, () => zag, { markUsed: false });
    });

    server.add("slider_value", (payload: { id?: string; respond_to?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitValue(parseRespondTo(payload));
    });

    return zag;
  },

  afterInit(hook, zag) {
    if (!hook.fieldTouched && shouldGateHiddenName(hook.el)) {
      stripHiddenInputNames(hook.el);
      zag.render();
    }
  },

  update(hook, zag) {
    const el = hook.el;
    const valuePatch = readUpdatedServerNumberList(el, hook.beforeAttrs);
    if (getBoolean(el, "fieldUsed")) {
      hook.fieldTouched = true;
    }

    zag.updateProps({
      id: el.id,
      ...sliderStaticProps(el),
      ...(valuePatch.value !== undefined ? { value: valuePatch.value } : {}),
    } as Partial<Props>);

    zag.render();

    if (!hook.fieldTouched && shouldGateHiddenName(el)) {
      stripHiddenInputNames(el);
    }
  },
});

export { SliderHook as Slider };
