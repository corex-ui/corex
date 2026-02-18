import {
  createRect,
  getPointAngle
} from "./chunk-BMVNROAE.mjs";
import {
  Component,
  VanillaMachine,
  createAnatomy,
  createMachine,
  createProps,
  createSplitProps,
  dataAttr,
  getBoolean,
  getEventPoint,
  getEventStep,
  getNativeEvent,
  getNumber,
  getString,
  isLeftClick,
  normalizeProps,
  raf,
  setElementValue,
  snapValueToStep,
  trackPointerMove
} from "./chunk-IXOYOLUJ.mjs";

// ../node_modules/.pnpm/@zag-js+angle-slider@1.33.1/node_modules/@zag-js/angle-slider/dist/index.mjs
var anatomy = createAnatomy("angle-slider").parts(
  "root",
  "label",
  "thumb",
  "valueText",
  "control",
  "track",
  "markerGroup",
  "marker"
);
var parts = anatomy.build();
var getRootId = (ctx) => ctx.ids?.root ?? `angle-slider:${ctx.id}`;
var getThumbId = (ctx) => ctx.ids?.thumb ?? `angle-slider:${ctx.id}:thumb`;
var getHiddenInputId = (ctx) => ctx.ids?.hiddenInput ?? `angle-slider:${ctx.id}:input`;
var getControlId = (ctx) => ctx.ids?.control ?? `angle-slider:${ctx.id}:control`;
var getValueTextId = (ctx) => ctx.ids?.valueText ?? `angle-slider:${ctx.id}:value-text`;
var getLabelId = (ctx) => ctx.ids?.label ?? `angle-slider:${ctx.id}:label`;
var getHiddenInputEl = (ctx) => ctx.getById(getHiddenInputId(ctx));
var getControlEl = (ctx) => ctx.getById(getControlId(ctx));
var getThumbEl = (ctx) => ctx.getById(getThumbId(ctx));
var MIN_VALUE = 0;
var MAX_VALUE = 359;
function getAngle(controlEl, point, angularOffset) {
  const rect = createRect(controlEl.getBoundingClientRect());
  const angle = getPointAngle(rect, point);
  if (angularOffset != null) {
    return angle - angularOffset;
  }
  return angle;
}
function clampAngle(degree) {
  return Math.min(Math.max(degree, MIN_VALUE), MAX_VALUE);
}
function constrainAngle(degree, step) {
  const clampedDegree = clampAngle(degree);
  const upperStep = Math.ceil(clampedDegree / step);
  const nearestStep = Math.round(clampedDegree / step);
  return upperStep >= clampedDegree / step ? upperStep * step === MAX_VALUE ? MIN_VALUE : upperStep * step : nearestStep * step;
}
function snapAngleToStep(value, step) {
  return snapValueToStep(value, MIN_VALUE, MAX_VALUE, step);
}
function connect(service, normalize) {
  const { state, send, context, prop, computed, scope } = service;
  const dragging = state.matches("dragging");
  const value = context.get("value");
  const valueAsDegree = computed("valueAsDegree");
  const disabled = prop("disabled");
  const invalid = prop("invalid");
  const readOnly = prop("readOnly");
  const interactive = computed("interactive");
  const ariaLabel = prop("aria-label");
  const ariaLabelledBy = prop("aria-labelledby");
  return {
    value,
    valueAsDegree,
    dragging,
    setValue(value2) {
      send({ type: "VALUE.SET", value: value2 });
    },
    getRootProps() {
      return normalize.element({
        ...parts.root.attrs,
        id: getRootId(scope),
        "data-disabled": dataAttr(disabled),
        "data-invalid": dataAttr(invalid),
        "data-readonly": dataAttr(readOnly),
        style: {
          "--value": value,
          "--angle": valueAsDegree
        }
      });
    },
    getLabelProps() {
      return normalize.label({
        ...parts.label.attrs,
        id: getLabelId(scope),
        htmlFor: getHiddenInputId(scope),
        "data-disabled": dataAttr(disabled),
        "data-invalid": dataAttr(invalid),
        "data-readonly": dataAttr(readOnly),
        onClick(event) {
          if (!interactive) return;
          event.preventDefault();
          getThumbEl(scope)?.focus();
        }
      });
    },
    getHiddenInputProps() {
      return normalize.element({
        type: "hidden",
        value,
        name: prop("name"),
        id: getHiddenInputId(scope)
      });
    },
    getControlProps() {
      return normalize.element({
        ...parts.control.attrs,
        role: "presentation",
        id: getControlId(scope),
        "data-disabled": dataAttr(disabled),
        "data-invalid": dataAttr(invalid),
        "data-readonly": dataAttr(readOnly),
        onPointerDown(event) {
          if (!interactive) return;
          if (!isLeftClick(event)) return;
          const point = getEventPoint(event);
          const controlEl = event.currentTarget;
          const thumbEl = getThumbEl(scope);
          const composedPath = getNativeEvent(event).composedPath();
          const isOverThumb = thumbEl && composedPath.includes(thumbEl);
          let angularOffset = null;
          if (isOverThumb) {
            const clickAngle = getAngle(controlEl, point);
            angularOffset = clickAngle - value;
          }
          send({ type: "CONTROL.POINTER_DOWN", point, angularOffset });
          event.stopPropagation();
        },
        style: {
          touchAction: "none",
          userSelect: "none",
          WebkitUserSelect: "none"
        }
      });
    },
    getThumbProps() {
      return normalize.element({
        ...parts.thumb.attrs,
        id: getThumbId(scope),
        role: "slider",
        "aria-label": ariaLabel,
        "aria-labelledby": ariaLabelledBy ?? getLabelId(scope),
        "aria-valuemax": 360,
        "aria-valuemin": 0,
        "aria-valuenow": value,
        tabIndex: readOnly || interactive ? 0 : void 0,
        "data-disabled": dataAttr(disabled),
        "data-invalid": dataAttr(invalid),
        "data-readonly": dataAttr(readOnly),
        onFocus() {
          send({ type: "THUMB.FOCUS" });
        },
        onBlur() {
          send({ type: "THUMB.BLUR" });
        },
        onKeyDown(event) {
          if (!interactive) return;
          const step = getEventStep(event) * prop("step");
          switch (event.key) {
            case "ArrowLeft":
            case "ArrowUp":
              event.preventDefault();
              send({ type: "THUMB.ARROW_DEC", step });
              break;
            case "ArrowRight":
            case "ArrowDown":
              event.preventDefault();
              send({ type: "THUMB.ARROW_INC", step });
              break;
            case "Home":
              event.preventDefault();
              send({ type: "THUMB.HOME" });
              break;
            case "End":
              event.preventDefault();
              send({ type: "THUMB.END" });
              break;
          }
        },
        style: {
          rotate: `var(--angle)`
        }
      });
    },
    getValueTextProps() {
      return normalize.element({
        ...parts.valueText.attrs,
        id: getValueTextId(scope)
      });
    },
    getMarkerGroupProps() {
      return normalize.element({
        ...parts.markerGroup.attrs
      });
    },
    getMarkerProps(props2) {
      let markerState;
      if (props2.value < value) {
        markerState = "under-value";
      } else if (props2.value > value) {
        markerState = "over-value";
      } else {
        markerState = "at-value";
      }
      return normalize.element({
        ...parts.marker.attrs,
        "data-value": props2.value,
        "data-state": markerState,
        "data-disabled": dataAttr(disabled),
        style: {
          "--marker-value": props2.value,
          rotate: `calc(var(--marker-value) * 1deg)`
        }
      });
    }
  };
}
var machine = createMachine({
  props({ props: props2 }) {
    return {
      step: 1,
      defaultValue: 0,
      ...props2
    };
  },
  context({ prop, bindable }) {
    return {
      value: bindable(() => ({
        defaultValue: prop("defaultValue"),
        value: prop("value"),
        onChange(value) {
          prop("onValueChange")?.({ value, valueAsDegree: `${value}deg` });
        }
      }))
    };
  },
  refs() {
    return {
      thumbDragOffset: null
    };
  },
  computed: {
    interactive: ({ prop }) => !(prop("disabled") || prop("readOnly")),
    valueAsDegree: ({ context }) => `${context.get("value")}deg`
  },
  watch({ track, context, action }) {
    track([() => context.get("value")], () => {
      action(["syncInputElement"]);
    });
  },
  initialState() {
    return "idle";
  },
  on: {
    "VALUE.SET": {
      actions: ["setValue"]
    }
  },
  states: {
    idle: {
      on: {
        "CONTROL.POINTER_DOWN": {
          target: "dragging",
          actions: ["setThumbDragOffset", "setPointerValue", "focusThumb"]
        },
        "THUMB.FOCUS": {
          target: "focused"
        }
      }
    },
    focused: {
      on: {
        "CONTROL.POINTER_DOWN": {
          target: "dragging",
          actions: ["setThumbDragOffset", "setPointerValue", "focusThumb"]
        },
        "THUMB.ARROW_DEC": {
          actions: ["decrementValue", "invokeOnChangeEnd"]
        },
        "THUMB.ARROW_INC": {
          actions: ["incrementValue", "invokeOnChangeEnd"]
        },
        "THUMB.HOME": {
          actions: ["setValueToMin", "invokeOnChangeEnd"]
        },
        "THUMB.END": {
          actions: ["setValueToMax", "invokeOnChangeEnd"]
        },
        "THUMB.BLUR": {
          target: "idle"
        }
      }
    },
    dragging: {
      entry: ["focusThumb"],
      effects: ["trackPointerMove"],
      on: {
        "DOC.POINTER_UP": {
          target: "focused",
          actions: ["invokeOnChangeEnd", "clearThumbDragOffset"]
        },
        "DOC.POINTER_MOVE": {
          actions: ["setPointerValue"]
        }
      }
    }
  },
  implementations: {
    effects: {
      trackPointerMove({ scope, send }) {
        return trackPointerMove(scope.getDoc(), {
          onPointerMove(info) {
            send({ type: "DOC.POINTER_MOVE", point: info.point });
          },
          onPointerUp() {
            send({ type: "DOC.POINTER_UP" });
          }
        });
      }
    },
    actions: {
      syncInputElement({ scope, context }) {
        const inputEl = getHiddenInputEl(scope);
        setElementValue(inputEl, context.get("value").toString());
      },
      invokeOnChangeEnd({ context, prop, computed }) {
        prop("onValueChangeEnd")?.({
          value: context.get("value"),
          valueAsDegree: computed("valueAsDegree")
        });
      },
      setPointerValue({ scope, event, context, prop, refs }) {
        const controlEl = getControlEl(scope);
        if (!controlEl) return;
        const angularOffset = refs.get("thumbDragOffset");
        const deg = getAngle(controlEl, event.point, angularOffset);
        context.set("value", constrainAngle(deg, prop("step")));
      },
      setValueToMin({ context }) {
        context.set("value", MIN_VALUE);
      },
      setValueToMax({ context }) {
        context.set("value", MAX_VALUE);
      },
      setValue({ context, event }) {
        context.set("value", clampAngle(event.value));
      },
      decrementValue({ context, event, prop }) {
        const value = snapAngleToStep(context.get("value") - event.step, event.step ?? prop("step"));
        context.set("value", value);
      },
      incrementValue({ context, event, prop }) {
        const value = snapAngleToStep(context.get("value") + event.step, event.step ?? prop("step"));
        context.set("value", value);
      },
      focusThumb({ scope }) {
        raf(() => {
          getThumbEl(scope)?.focus({ preventScroll: true });
        });
      },
      setThumbDragOffset({ refs, event }) {
        refs.set("thumbDragOffset", event.angularOffset ?? null);
      },
      clearThumbDragOffset({ refs }) {
        refs.set("thumbDragOffset", null);
      }
    }
  }
});
var props = createProps()([
  "aria-label",
  "aria-labelledby",
  "dir",
  "disabled",
  "getRootNode",
  "id",
  "ids",
  "invalid",
  "name",
  "onValueChange",
  "onValueChangeEnd",
  "readOnly",
  "step",
  "value",
  "defaultValue"
]);
var splitProps = createSplitProps(props);

// components/angle-slider.ts
var AngleSlider = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props2) {
    return new VanillaMachine(machine, props2);
  }
  initApi() {
    return connect(this.machine.service, normalizeProps);
  }
  render() {
    const rootEl = this.el.querySelector('[data-scope="angle-slider"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());
    const labelEl = this.el.querySelector(
      '[data-scope="angle-slider"][data-part="label"]'
    );
    if (labelEl) this.spreadProps(labelEl, this.api.getLabelProps());
    const hiddenInputEl = this.el.querySelector(
      '[data-scope="angle-slider"][data-part="hidden-input"]'
    );
    if (hiddenInputEl) this.spreadProps(hiddenInputEl, this.api.getHiddenInputProps());
    const controlEl = this.el.querySelector(
      '[data-scope="angle-slider"][data-part="control"]'
    );
    if (controlEl) this.spreadProps(controlEl, this.api.getControlProps());
    const thumbEl = this.el.querySelector(
      '[data-scope="angle-slider"][data-part="thumb"]'
    );
    if (thumbEl) this.spreadProps(thumbEl, this.api.getThumbProps());
    const valueTextEl = this.el.querySelector(
      '[data-scope="angle-slider"][data-part="value-text"]'
    );
    if (valueTextEl) {
      this.spreadProps(valueTextEl, this.api.getValueTextProps());
      const valueSpan = valueTextEl.querySelector(
        '[data-scope="angle-slider"][data-part="value"]'
      );
      if (valueSpan && valueSpan.textContent !== String(this.api.value)) {
        valueSpan.textContent = String(this.api.value);
      }
    }
    const markerGroupEl = this.el.querySelector(
      '[data-scope="angle-slider"][data-part="marker-group"]'
    );
    if (markerGroupEl) this.spreadProps(markerGroupEl, this.api.getMarkerGroupProps());
    this.el.querySelectorAll('[data-scope="angle-slider"][data-part="marker"]').forEach((markerEl) => {
      const valueStr = markerEl.dataset.value;
      if (valueStr == null) return;
      const value = Number(valueStr);
      if (Number.isNaN(value)) return;
      this.spreadProps(markerEl, this.api.getMarkerProps({ value }));
    });
  }
};

// hooks/angle-slider.ts
var AngleSliderHook = {
  mounted() {
    const el = this.el;
    const value = getNumber(el, "value");
    const defaultValue = getNumber(el, "defaultValue");
    const controlled = getBoolean(el, "controlled");
    const zag = new AngleSlider(el, {
      id: el.id,
      ...controlled && value !== void 0 ? { value } : { defaultValue: defaultValue ?? 0 },
      step: getNumber(el, "step") ?? 1,
      disabled: getBoolean(el, "disabled"),
      readOnly: getBoolean(el, "readOnly"),
      invalid: getBoolean(el, "invalid"),
      name: getString(el, "name"),
      dir: getString(el, "dir", ["ltr", "rtl"]),
      onValueChange: (details) => {
        const eventName = getString(el, "onValueChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, {
            value: details.value,
            valueAsDegree: details.valueAsDegree,
            id: el.id
          });
        }
        const eventNameClient = getString(el, "onValueChangeClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
              bubbles: true,
              detail: { value: details, id: el.id }
            })
          );
        }
      },
      onValueChangeEnd: (details) => {
        const eventName = getString(el, "onValueChangeEnd");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, {
            value: details.value,
            valueAsDegree: details.valueAsDegree,
            id: el.id
          });
        }
        const eventNameClient = getString(el, "onValueChangeEndClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
              bubbles: true,
              detail: { value: details, id: el.id }
            })
          );
        }
      }
    });
    zag.init();
    this.angleSlider = zag;
    this.handlers = [];
    this.onSetValue = (event) => {
      const { value: value2 } = event.detail;
      zag.api.setValue(value2);
    };
    el.addEventListener("phx:angle-slider:set-value", this.onSetValue);
    this.handlers.push(
      this.handleEvent(
        "angle_slider_set_value",
        (payload) => {
          const targetId = payload.angle_slider_id;
          if (targetId) {
            const matches = el.id === targetId || el.id === `angle-slider:${targetId}`;
            if (!matches) return;
          }
          zag.api.setValue(payload.value);
        }
      )
    );
    this.handlers.push(
      this.handleEvent("angle_slider_value", () => {
        this.pushEvent("angle_slider_value_response", {
          value: zag.api.value,
          valueAsDegree: zag.api.valueAsDegree,
          dragging: zag.api.dragging
        });
      })
    );
  },
  updated() {
    const value = getNumber(this.el, "value");
    const defaultValue = getNumber(this.el, "defaultValue");
    const controlled = getBoolean(this.el, "controlled");
    this.angleSlider?.updateProps({
      id: this.el.id,
      ...controlled && value !== void 0 ? { value } : { defaultValue: defaultValue ?? 0 },
      step: getNumber(this.el, "step") ?? 1,
      disabled: getBoolean(this.el, "disabled"),
      readOnly: getBoolean(this.el, "readOnly"),
      invalid: getBoolean(this.el, "invalid"),
      name: getString(this.el, "name"),
      dir: getString(this.el, "dir", ["ltr", "rtl"])
    });
  },
  destroyed() {
    if (this.onSetValue) {
      this.el.removeEventListener("phx:angle-slider:set-value", this.onSetValue);
    }
    if (this.handlers) {
      for (const h of this.handlers) this.removeHandleEvent(h);
    }
    this.angleSlider?.destroy();
  }
};
export {
  AngleSliderHook as AngleSlider
};
