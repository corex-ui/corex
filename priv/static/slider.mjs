import {
  memo
} from "./chunks/chunk-Z3EQ3GCO.mjs";
import {
  clampPercent,
  clampValue,
  getNextStepValue,
  getPercentValue,
  getPreviousStepValue,
  getValuePercent,
  getValueRanges,
  getValueTransformer,
  isValueWithinRange,
  setValueAtIndex,
  snapValueToStep,
  toPx
} from "./chunks/chunk-SYRKLN4X.mjs";
import {
  notifyPhoenixFormChange,
  syncHiddenInputValue
} from "./chunks/chunk-NUQOKDPA.mjs";
import {
  mountNumberListBinding,
  readUpdatedServerNumberList
} from "./chunks/chunk-4M2QDFLS.mjs";
import {
  emitResponse,
  idMatches,
  notifyChange,
  parseRespondTo,
  readPayloadId
} from "./chunks/chunk-EAQ6WQNO.mjs";
import {
  Component,
  VanillaMachine,
  ariaAttr,
  callAll,
  canPushEvent,
  createAnatomy,
  createMachine,
  createZagLiveHook,
  dataAttr,
  dispatchInputValueEvent,
  first,
  getBoolean,
  getDir,
  getEventKey,
  getEventPoint,
  getEventStepValue,
  getNumber,
  getString,
  isEqual,
  isLeftClick,
  isModifierKey,
  last,
  pick,
  queryAll,
  raf,
  resizeObserverBorderBox,
  setElementValue,
  trackFormControl,
  trackPointerMove
} from "./chunks/chunk-6L36XW7I.mjs";

// ../node_modules/.pnpm/@zag-js+slider@1.42.0/node_modules/@zag-js/slider/dist/slider.anatomy.mjs
var anatomy = createAnatomy("slider").parts(
  "root",
  "label",
  "thumb",
  "valueText",
  "track",
  "range",
  "control",
  "markerGroup",
  "marker",
  "draggingIndicator"
);
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+slider@1.42.0/node_modules/@zag-js/slider/dist/slider.dom.mjs
var getRootId = (ctx) => ctx.ids?.root ?? `slider:${ctx.id}`;
var getThumbId = (ctx, index) => ctx.ids?.thumb?.(index) ?? `slider:${ctx.id}:thumb:${index}`;
var getHiddenInputId = (ctx, index) => ctx.ids?.hiddenInput?.(index) ?? `slider:${ctx.id}:input:${index}`;
var getControlId = (ctx) => ctx.ids?.control ?? `slider:${ctx.id}:control`;
var getTrackId = (ctx) => ctx.ids?.track ?? `slider:${ctx.id}:track`;
var getRangeId = (ctx) => ctx.ids?.range ?? `slider:${ctx.id}:range`;
var getLabelId = (ctx) => ctx.ids?.label ?? `slider:${ctx.id}:label`;
var getValueTextId = (ctx) => ctx.ids?.valueText ?? `slider:${ctx.id}:value-text`;
var getMarkerId = (ctx, value) => ctx.ids?.marker?.(value) ?? `slider:${ctx.id}:marker:${value}`;
var getRootEl = (ctx) => ctx.getById(getRootId(ctx));
var getThumbEl = (ctx, index) => ctx.getById(getThumbId(ctx, index));
var getThumbEls = (ctx) => queryAll(getControlEl(ctx), "[role=slider]");
var getFirstThumbEl = (ctx) => getThumbEls(ctx)[0];
var getHiddenInputEl = (ctx, index) => ctx.getById(getHiddenInputId(ctx, index));
var getControlEl = (ctx) => ctx.getById(getControlId(ctx));
var getThumbInset = (thumbSize, thumbAlignment, orientation) => {
  const isContain = thumbAlignment === "contain";
  const isVertical = orientation === "vertical";
  return isContain ? (isVertical ? thumbSize?.height ?? 0 : thumbSize?.width ?? 0) / 2 : 0;
};
var getPointValue = (params, point) => {
  const { context, prop, scope, refs } = params;
  const controlEl = getControlEl(scope);
  if (!controlEl) return;
  const offset = refs.get("thumbDragOffset");
  const adjustedPoint = {
    x: point.x - (offset?.x ?? 0),
    y: point.y - (offset?.y ?? 0)
  };
  const thumbInset = getThumbInset(context.get("thumbSize"), prop("thumbAlignment"), prop("orientation"));
  const relativePoint = getRelativePointWithInset(adjustedPoint, controlEl, thumbInset);
  const percent = relativePoint.getPercentValue({
    orientation: prop("orientation"),
    dir: prop("dir"),
    inverted: { y: true }
  });
  return getPercentValue(percent, prop("min"), prop("max"), prop("step"));
};
function getRelativePointWithInset(point, element, inset) {
  const { left, top, width, height } = element.getBoundingClientRect();
  const effectiveWidth = width - inset * 2;
  const effectiveHeight = height - inset * 2;
  const effectiveLeft = left + inset;
  const effectiveTop = top + inset;
  const offset = {
    x: point.x - effectiveLeft,
    y: point.y - effectiveTop
  };
  const percent = {
    x: effectiveWidth > 0 ? clampPercent(offset.x / effectiveWidth) : 0,
    y: effectiveHeight > 0 ? clampPercent(offset.y / effectiveHeight) : 0
  };
  function getPercentValue2(options = {}) {
    const { dir = "ltr", orientation = "horizontal", inverted } = options;
    const invertX = typeof inverted === "object" ? inverted.x : inverted;
    const invertY = typeof inverted === "object" ? inverted.y : inverted;
    if (orientation === "horizontal") {
      return dir === "rtl" || invertX ? 1 - percent.x : percent.x;
    }
    return invertY ? 1 - percent.y : percent.y;
  }
  return { offset, percent, getPercentValue: getPercentValue2 };
}
var dispatchChangeEvent = (ctx, value) => {
  value.forEach((value2, index) => {
    const inputEl = getHiddenInputEl(ctx, index);
    if (!inputEl) return;
    dispatchInputValueEvent(inputEl, { value: value2 });
  });
};
var getOffsetRect = (el) => ({
  left: el?.offsetLeft ?? 0,
  top: el?.offsetTop ?? 0,
  width: el?.offsetWidth ?? 0,
  height: el?.offsetHeight ?? 0
});

// ../node_modules/.pnpm/@zag-js+slider@1.42.0/node_modules/@zag-js/slider/dist/slider.style.mjs
function getBounds(value) {
  const firstValue = value[0];
  const lastThumb = value[value.length - 1];
  return [firstValue, lastThumb];
}
function getRangeOffsets(params) {
  const { prop, computed } = params;
  const valuePercent = computed("valuePercent");
  const [firstPercent, lastPercent] = getBounds(valuePercent);
  if (valuePercent.length === 1) {
    if (prop("origin") === "center") {
      const isNegative = valuePercent[0] < 50;
      const start = isNegative ? `${valuePercent[0]}%` : "50%";
      const end = isNegative ? "50%" : `${100 - valuePercent[0]}%`;
      return { start, end };
    }
    if (prop("origin") === "end") {
      return { start: `${lastPercent}%`, end: "0%" };
    }
    return { start: "0%", end: `${100 - lastPercent}%` };
  }
  return { start: `${firstPercent}%`, end: `${100 - lastPercent}%` };
}
function getRangeStyle(params) {
  const { computed } = params;
  const isVertical = computed("isVertical");
  const isRtl = computed("isRtl");
  if (isVertical) {
    return {
      position: "absolute",
      bottom: "var(--slider-range-start)",
      top: "var(--slider-range-end)"
    };
  }
  return {
    position: "absolute",
    [isRtl ? "right" : "left"]: "var(--slider-range-start)",
    [isRtl ? "left" : "right"]: "var(--slider-range-end)"
  };
}
function getVerticalThumbOffset(params, value) {
  const { context, prop } = params;
  const { height = 0 } = context.get("thumbSize") ?? {};
  const getValue = getValueTransformer([prop("min"), prop("max")], [-height / 2, height / 2]);
  return parseFloat(getValue(value).toFixed(2));
}
function getHorizontalThumbOffset(params, value) {
  const { computed, context, prop } = params;
  const { width = 0 } = context.get("thumbSize") ?? {};
  const isRtl = computed("isRtl");
  if (isRtl) {
    const getValue2 = getValueTransformer([prop("max"), prop("min")], [-width / 2, width / 2]);
    return -1 * parseFloat(getValue2(value).toFixed(2));
  }
  const getValue = getValueTransformer([prop("min"), prop("max")], [-width / 2, width / 2]);
  return parseFloat(getValue(value).toFixed(2));
}
function getOffset(params, percent, value) {
  const { computed, prop } = params;
  if (prop("thumbAlignment") === "center") return `${percent}%`;
  const offset = computed("isVertical") ? getVerticalThumbOffset(params, value) : getHorizontalThumbOffset(params, value);
  return `calc(${percent}% - ${offset}px)`;
}
function getThumbOffset(params, value) {
  const { prop } = params;
  const percent = getValuePercent(value, prop("min"), prop("max")) * 100;
  return getOffset(params, percent, value);
}
function getVisibility(params) {
  const { computed, prop } = params;
  let visibility = "visible";
  if (prop("thumbAlignment") === "contain" && !computed("hasMeasuredThumbSize")) {
    visibility = "hidden";
  }
  return visibility;
}
function getThumbStyle(params, index) {
  const { computed, context } = params;
  const placementProp = computed("isVertical") ? "bottom" : "insetInlineStart";
  const focusedIndex = context.get("focusedIndex");
  return {
    visibility: getVisibility(params),
    position: "absolute",
    transform: "var(--slider-thumb-transform)",
    [placementProp]: `var(--slider-thumb-offset-${index})`,
    zIndex: focusedIndex === index ? 1 : void 0
  };
}
function getControlStyle() {
  return {
    touchAction: "none",
    userSelect: "none",
    WebkitUserSelect: "none",
    position: "relative"
  };
}
function getRootStyle(params) {
  const { context, computed } = params;
  const isVertical = computed("isVertical");
  const isRtl = computed("isRtl");
  const range = getRangeOffsets(params);
  const thumbSize = context.get("thumbSize");
  const offsetStyles = context.get("value").reduce((styles, value, index) => {
    const offset = getThumbOffset(params, value);
    return { ...styles, [`--slider-thumb-offset-${index}`]: offset };
  }, {});
  return {
    ...offsetStyles,
    "--slider-thumb-width": toPx(thumbSize?.width),
    "--slider-thumb-height": toPx(thumbSize?.height),
    "--slider-thumb-transform": isVertical ? "translateY(50%)" : isRtl ? "translateX(50%)" : "translateX(-50%)",
    "--slider-range-start": range.start,
    "--slider-range-end": range.end
  };
}
function getMarkerStyle(params, value) {
  const { computed } = params;
  const isHorizontal = computed("isHorizontal");
  const isRtl = computed("isRtl");
  return {
    visibility: getVisibility(params),
    position: "absolute",
    pointerEvents: "none",
    [isHorizontal ? "insetInlineStart" : "bottom"]: getThumbOffset(params, value),
    translate: "var(--translate-x) var(--translate-y)",
    "--translate-x": isHorizontal ? isRtl ? "50%" : "-50%" : "0%",
    "--translate-y": !isHorizontal ? "50%" : "0%"
  };
}
function getMarkerGroupStyle() {
  return {
    userSelect: "none",
    WebkitUserSelect: "none",
    pointerEvents: "none",
    position: "relative"
  };
}

// ../node_modules/.pnpm/@zag-js+slider@1.42.0/node_modules/@zag-js/slider/dist/slider.utils.mjs
function getThumbBounds(ctx) {
  const { index, values, min, max, gap } = ctx;
  const prevThumb = values[index - 1];
  const nextThumb = values[index + 1];
  return {
    min: prevThumb != null ? prevThumb + gap : min,
    max: nextThumb != null ? nextThumb - gap : max
  };
}
function round(value) {
  return Math.round(value * 1e10) / 1e10;
}
function handleNone(ctx) {
  const { index, value, values } = ctx;
  const bounds = getThumbBounds(ctx);
  const nextValues = values.slice();
  nextValues[index] = round(clampValue(value, bounds.min, bounds.max));
  return { values: nextValues, index, swapped: false };
}
function handlePush(ctx) {
  const { index, value, values, min, max, gap } = ctx;
  const nextValues = values.slice();
  const absoluteMin = min + index * gap;
  const absoluteMax = max - (values.length - 1 - index) * gap;
  nextValues[index] = round(clampValue(value, absoluteMin, absoluteMax));
  for (let i = index + 1; i < values.length; i++) {
    const minAllowed = nextValues[i - 1] + gap;
    if (nextValues[i] < minAllowed) {
      nextValues[i] = round(minAllowed);
    }
  }
  for (let i = index - 1; i >= 0; i--) {
    const maxAllowed = nextValues[i + 1] - gap;
    if (nextValues[i] > maxAllowed) {
      nextValues[i] = round(maxAllowed);
    }
  }
  return { values: nextValues, index, swapped: false };
}
function handleSwap(ctx, startValue) {
  const { index, value, values, gap } = ctx;
  const prevThumb = values[index - 1];
  const nextThumb = values[index + 1];
  const crossingNext = nextThumb != null && value >= nextThumb && value > startValue;
  const crossingPrev = prevThumb != null && value <= prevThumb && value < startValue;
  if (!crossingNext && !crossingPrev) {
    return handleNone(ctx);
  }
  const swapIndex = crossingNext ? index + 1 : index - 1;
  const nextValues = values.slice();
  const newCtx = { ...ctx, index: swapIndex };
  const bounds = getThumbBounds(newCtx);
  nextValues[swapIndex] = round(clampValue(value, bounds.min, bounds.max));
  nextValues[index] = values[swapIndex];
  if (crossingNext && nextValues[index] > nextValues[swapIndex] - gap) {
    nextValues[index] = round(nextValues[swapIndex] - gap);
  } else if (crossingPrev && nextValues[index] < nextValues[swapIndex] + gap) {
    nextValues[index] = round(nextValues[swapIndex] + gap);
  }
  return { values: nextValues, index: swapIndex, swapped: true };
}
function resolveThumbCollision(behavior, index, value, values, min, max, step, minStepsBetweenThumbs, startValue) {
  if (values.length === 1) {
    return { values: [round(clampValue(value, min, max))], index: 0, swapped: false };
  }
  const gap = step * minStepsBetweenThumbs;
  const ctx = { behavior, index, value, values, min, max, gap };
  switch (behavior) {
    case "push":
      return handlePush(ctx);
    case "swap":
      return handleSwap(ctx, startValue ?? values[index]);
    case "none":
    default:
      return handleNone(ctx);
  }
}
function normalizeValues(params, nextValues) {
  return nextValues.map((value, index) => {
    return constrainValue(params, value, index);
  });
}
function getRangeAtIndex(params, index) {
  const { context, prop } = params;
  const step = prop("step") * prop("minStepsBetweenThumbs");
  return getValueRanges(context.get("value"), prop("min"), prop("max"), step)[index];
}
function constrainValue(params, value, index) {
  const { prop } = params;
  const range = getRangeAtIndex(params, index);
  const snapValue = snapValueToStep(value, prop("min"), prop("max"), prop("step"));
  return clampValue(snapValue, range.min, range.max);
}
function decrement(params, index, step) {
  const { context, prop } = params;
  const idx = index ?? context.get("focusedIndex");
  const range = getRangeAtIndex(params, idx);
  const nextValues = getPreviousStepValue(idx, {
    ...range,
    step: step ?? prop("step"),
    values: context.get("value")
  });
  nextValues[idx] = clampValue(nextValues[idx], range.min, range.max);
  return nextValues;
}
function increment(params, index, step) {
  const { context, prop } = params;
  const idx = index ?? context.get("focusedIndex");
  const range = getRangeAtIndex(params, idx);
  const nextValues = getNextStepValue(idx, {
    ...range,
    step: step ?? prop("step"),
    values: context.get("value")
  });
  nextValues[idx] = clampValue(nextValues[idx], range.min, range.max);
  return nextValues;
}
function getClosestIndex(params, pointValue) {
  const { context } = params;
  const values = context.get("value");
  let closestIndex = 0;
  let minDistance = Math.abs(values[0] - pointValue);
  for (let i = 1; i < values.length; i++) {
    const distance = Math.abs(values[i] - pointValue);
    if (distance <= minDistance) {
      closestIndex = i;
      minDistance = distance;
    }
  }
  return selectMovableThumb(params, closestIndex);
}
function selectMovableThumb(params, index) {
  const { context, prop } = params;
  const values = context.get("value");
  const max = prop("max");
  const thumbValue = values[index];
  if (thumbValue === max) {
    let movableIndex = index;
    while (movableIndex > 0 && values[movableIndex - 1] === max) {
      movableIndex -= 1;
    }
    return movableIndex;
  }
  return index;
}

// ../node_modules/.pnpm/@zag-js+slider@1.42.0/node_modules/@zag-js/slider/dist/slider.connect.mjs
function connect(service, normalize2) {
  const { state, send, context, prop, computed, scope } = service;
  const ariaLabel = prop("aria-label");
  const ariaLabelledBy = prop("aria-labelledby");
  const sliderValue = context.get("value");
  const focusedIndex = context.get("focusedIndex");
  const focused = state.matches("focus");
  const dragging = state.matches("dragging");
  const disabled = computed("isDisabled");
  const invalid = prop("invalid");
  const interactive = computed("isInteractive");
  const isHorizontal = prop("orientation") === "horizontal";
  const isVertical = prop("orientation") === "vertical";
  function getValuePercentFn(value) {
    return getValuePercent(value, prop("min"), prop("max"));
  }
  function getPercentValueFn(percent) {
    return getPercentValue(percent, prop("min"), prop("max"), prop("step"));
  }
  return {
    value: sliderValue,
    dragging,
    focused,
    setValue(value) {
      send({ type: "SET_VALUE", value });
    },
    getThumbValue(index) {
      return sliderValue[index];
    },
    setThumbValue(index, value) {
      send({ type: "SET_VALUE", index, value });
    },
    getValuePercent: getValuePercentFn,
    getPercentValue: getPercentValueFn,
    getThumbPercent(index) {
      return getValuePercentFn(sliderValue[index]);
    },
    setThumbPercent(index, percent) {
      const value = getPercentValueFn(percent);
      send({ type: "SET_VALUE", index, value });
    },
    getThumbMin(index) {
      return getRangeAtIndex(service, index).min;
    },
    getThumbMax(index) {
      return getRangeAtIndex(service, index).max;
    },
    increment(index) {
      send({ type: "INCREMENT", index });
    },
    decrement(index) {
      send({ type: "DECREMENT", index });
    },
    focus() {
      if (!interactive) return;
      send({ type: "FOCUS", index: 0 });
    },
    getLabelProps() {
      return normalize2.label({
        ...parts.label.attrs,
        dir: prop("dir"),
        "data-disabled": dataAttr(disabled),
        "data-orientation": prop("orientation"),
        "data-invalid": dataAttr(invalid),
        "data-dragging": dataAttr(dragging),
        "data-focus": dataAttr(focused),
        id: getLabelId(scope),
        htmlFor: getHiddenInputId(scope, 0),
        onClick(event) {
          if (!interactive) return;
          event.preventDefault();
          getFirstThumbEl(scope)?.focus();
        },
        style: {
          userSelect: "none",
          WebkitUserSelect: "none"
        }
      });
    },
    getRootProps() {
      return normalize2.element({
        ...parts.root.attrs,
        "data-disabled": dataAttr(disabled),
        "data-orientation": prop("orientation"),
        "data-dragging": dataAttr(dragging),
        "data-invalid": dataAttr(invalid),
        "data-focus": dataAttr(focused),
        id: getRootId(scope),
        dir: prop("dir"),
        style: getRootStyle(service)
      });
    },
    getValueTextProps() {
      return normalize2.element({
        ...parts.valueText.attrs,
        dir: prop("dir"),
        "data-disabled": dataAttr(disabled),
        "data-orientation": prop("orientation"),
        "data-invalid": dataAttr(invalid),
        "data-focus": dataAttr(focused),
        id: getValueTextId(scope)
      });
    },
    getTrackProps() {
      return normalize2.element({
        ...parts.track.attrs,
        dir: prop("dir"),
        id: getTrackId(scope),
        "data-disabled": dataAttr(disabled),
        "data-invalid": dataAttr(invalid),
        "data-dragging": dataAttr(dragging),
        "data-orientation": prop("orientation"),
        "data-focus": dataAttr(focused),
        style: { position: "relative" }
      });
    },
    getThumbProps(props) {
      const { index = 0, name } = props;
      const value = sliderValue[index];
      const range = getRangeAtIndex(service, index);
      const valueText = prop("getAriaValueText")?.({ value, index });
      const _ariaLabel = Array.isArray(ariaLabel) ? ariaLabel[index] : ariaLabel;
      const _ariaLabelledBy = Array.isArray(ariaLabelledBy) ? ariaLabelledBy[index] : ariaLabelledBy;
      return normalize2.element({
        ...parts.thumb.attrs,
        dir: prop("dir"),
        "data-index": index,
        "data-name": name,
        id: getThumbId(scope, index),
        "data-disabled": dataAttr(disabled),
        "data-orientation": prop("orientation"),
        "data-focus": dataAttr(focused && focusedIndex === index),
        "data-dragging": dataAttr(dragging && focusedIndex === index),
        draggable: false,
        "aria-disabled": ariaAttr(disabled),
        "aria-label": _ariaLabel,
        "aria-labelledby": _ariaLabelledBy ?? getLabelId(scope),
        "aria-orientation": prop("orientation"),
        "aria-valuemax": range.max,
        "aria-valuemin": range.min,
        "aria-valuenow": sliderValue[index],
        "aria-valuetext": valueText,
        role: "slider",
        tabIndex: disabled ? void 0 : 0,
        style: getThumbStyle(service, index),
        onPointerDown(event) {
          if (!interactive) return;
          if (!isLeftClick(event)) return;
          const thumbEl = event.currentTarget;
          const rect = thumbEl.getBoundingClientRect();
          const midpoint = {
            x: rect.left + rect.width / 2,
            y: rect.top + rect.height / 2
          };
          const offset = {
            x: event.clientX - midpoint.x,
            y: event.clientY - midpoint.y
          };
          send({ type: "THUMB_POINTER_DOWN", index, offset });
          event.stopPropagation();
        },
        onBlur() {
          if (!interactive) return;
          send({ type: "BLUR" });
        },
        onFocus() {
          if (!interactive) return;
          send({ type: "FOCUS", index });
        },
        onKeyDown(event) {
          if (event.defaultPrevented) return;
          if (!interactive) return;
          const step = getEventStepValue(event, { step: prop("step"), largeStep: prop("largeStep") });
          const keyMap = {
            ArrowUp() {
              if (isHorizontal) return;
              send({ type: "ARROW_INC", step, src: "ArrowUp" });
            },
            ArrowDown() {
              if (isHorizontal) return;
              send({ type: "ARROW_DEC", step, src: "ArrowDown" });
            },
            ArrowLeft() {
              if (isVertical) return;
              send({ type: "ARROW_DEC", step, src: "ArrowLeft" });
            },
            ArrowRight() {
              if (isVertical) return;
              send({ type: "ARROW_INC", step, src: "ArrowRight" });
            },
            PageUp() {
              send({ type: "ARROW_INC", step, src: "PageUp" });
            },
            PageDown() {
              send({ type: "ARROW_DEC", step, src: "PageDown" });
            },
            Home() {
              send({ type: "HOME" });
            },
            End() {
              send({ type: "END" });
            }
          };
          const key = getEventKey(event, {
            dir: prop("dir"),
            orientation: prop("orientation")
          });
          const exec = keyMap[key];
          if (exec) {
            exec(event);
            event.preventDefault();
            event.stopPropagation();
          }
        }
      });
    },
    getHiddenInputProps(props) {
      const { index = 0, name } = props;
      return normalize2.input({
        name: name ?? (prop("name") ? prop("name") + (sliderValue.length > 1 ? "[]" : "") : void 0),
        form: prop("form"),
        type: "text",
        hidden: true,
        defaultValue: sliderValue[index],
        id: getHiddenInputId(scope, index)
      });
    },
    getRangeProps() {
      return normalize2.element({
        id: getRangeId(scope),
        ...parts.range.attrs,
        dir: prop("dir"),
        "data-dragging": dataAttr(dragging),
        "data-focus": dataAttr(focused),
        "data-invalid": dataAttr(invalid),
        "data-disabled": dataAttr(disabled),
        "data-orientation": prop("orientation"),
        style: getRangeStyle(service)
      });
    },
    getControlProps() {
      return normalize2.element({
        ...parts.control.attrs,
        dir: prop("dir"),
        id: getControlId(scope),
        "data-dragging": dataAttr(dragging),
        "data-disabled": dataAttr(disabled),
        "data-orientation": prop("orientation"),
        "data-invalid": dataAttr(invalid),
        "data-focus": dataAttr(focused),
        style: getControlStyle(),
        onPointerDown(event) {
          if (!interactive) return;
          if (!isLeftClick(event)) return;
          if (isModifierKey(event)) return;
          const point = getEventPoint(event);
          send({ type: "POINTER_DOWN", point });
          event.preventDefault();
          event.stopPropagation();
        }
      });
    },
    getMarkerGroupProps() {
      return normalize2.element({
        ...parts.markerGroup.attrs,
        role: "presentation",
        dir: prop("dir"),
        "aria-hidden": true,
        "data-orientation": prop("orientation"),
        style: getMarkerGroupStyle()
      });
    },
    getMarkerProps(props) {
      const style = getMarkerStyle(service, props.value);
      let markerState;
      if (props.value < first(sliderValue)) {
        markerState = "under-value";
      } else if (props.value > last(sliderValue)) {
        markerState = "over-value";
      } else {
        markerState = "at-value";
      }
      return normalize2.element({
        ...parts.marker.attrs,
        id: getMarkerId(scope, props.value),
        role: "presentation",
        dir: prop("dir"),
        "data-orientation": prop("orientation"),
        "data-value": props.value,
        "data-disabled": dataAttr(disabled),
        "data-state": markerState,
        style
      });
    },
    getDraggingIndicatorProps(props) {
      const { index = 0 } = props;
      const isDragging = index === focusedIndex && dragging;
      return normalize2.element({
        ...parts.draggingIndicator.attrs,
        role: "presentation",
        dir: prop("dir"),
        hidden: !isDragging,
        "data-orientation": prop("orientation"),
        "data-state": isDragging ? "open" : "closed",
        style: getThumbStyle(service, index)
      });
    }
  };
}

// ../node_modules/.pnpm/@zag-js+slider@1.42.0/node_modules/@zag-js/slider/dist/slider.machine.mjs
var isEqualSize = (a, b) => {
  return a?.width === b?.width && a?.height === b?.height;
};
var normalize = (value, min, max, step, minStepsBetweenThumbs) => {
  const ranges = getValueRanges(value, min, max, minStepsBetweenThumbs * step);
  return ranges.map((range) => {
    const snapValue = snapValueToStep(range.value, range.min, range.max, step);
    const rangeValue = clampValue(snapValue, range.min, range.max);
    if (!isValueWithinRange(rangeValue, min, max)) {
      throw new Error(
        "[zag-js/slider] The configured `min`, `max`, `step` or `minStepsBetweenThumbs` values are invalid"
      );
    }
    return rangeValue;
  });
};
var machine = createMachine({
  props({ props }) {
    const min = props.min ?? 0;
    const max = props.max ?? 100;
    const step = props.step ?? 1;
    const defaultValue = props.defaultValue ?? [min];
    const minStepsBetweenThumbs = props.minStepsBetweenThumbs ?? 0;
    return {
      dir: "ltr",
      thumbAlignment: "contain",
      origin: "start",
      orientation: "horizontal",
      thumbCollisionBehavior: "none",
      minStepsBetweenThumbs,
      ...props,
      largeStep: props.largeStep ?? 10 * step,
      defaultValue: normalize(defaultValue, min, max, step, minStepsBetweenThumbs),
      value: props.value ? normalize(props.value, min, max, step, minStepsBetweenThumbs) : void 0,
      max,
      step,
      min
    };
  },
  initialState() {
    return "idle";
  },
  context({ prop, bindable, getContext }) {
    return {
      thumbSize: bindable(() => ({
        defaultValue: prop("thumbSize") || null
      })),
      value: bindable(() => ({
        defaultValue: prop("defaultValue"),
        value: prop("value"),
        isEqual,
        hash(a) {
          return a.join(",");
        },
        onChange(value) {
          prop("onValueChange")?.({ value });
        }
      })),
      focusedIndex: bindable(() => ({
        defaultValue: -1,
        onChange(value) {
          const ctx = getContext();
          prop("onFocusChange")?.({ focusedIndex: value, value: ctx.get("value") });
        }
      })),
      fieldsetDisabled: bindable(() => ({
        defaultValue: false
      }))
    };
  },
  refs() {
    return {
      thumbDragOffset: null,
      thumbDragStartValue: null
    };
  },
  computed: {
    isHorizontal: ({ prop }) => prop("orientation") === "horizontal",
    isVertical: ({ prop }) => prop("orientation") === "vertical",
    isRtl: ({ prop }) => prop("orientation") === "horizontal" && prop("dir") === "rtl",
    isDisabled: ({ context, prop }) => !!prop("disabled") || context.get("fieldsetDisabled"),
    isInteractive: ({ prop, computed }) => !(prop("readOnly") || computed("isDisabled")),
    hasMeasuredThumbSize: ({ context }) => context.get("thumbSize") != null,
    valuePercent: memo(
      ({ context, prop }) => [context.get("value"), prop("min"), prop("max")],
      ([value, min, max]) => value.map((value2) => 100 * getValuePercent(value2, min, max))
    )
  },
  watch({ track, action, context, computed, send }) {
    track([() => context.hash("value")], () => {
      action(["syncInputElements", "dispatchChangeEvent"]);
    });
    track([() => computed("isDisabled")], () => {
      if (computed("isDisabled")) {
        send({ type: "POINTER_CANCEL" });
      }
    });
  },
  effects: ["trackFormControlState", "trackThumbSize"],
  on: {
    SET_VALUE: [
      {
        guard: "hasIndex",
        actions: ["setValueAtIndex", "invokeOnChangeEnd"]
      },
      {
        actions: ["setValue", "invokeOnChangeEnd"]
      }
    ],
    INCREMENT: {
      actions: ["incrementThumbAtIndex", "invokeOnChangeEnd"]
    },
    DECREMENT: {
      actions: ["decrementThumbAtIndex", "invokeOnChangeEnd"]
    }
  },
  states: {
    idle: {
      on: {
        POINTER_DOWN: {
          target: "dragging",
          actions: ["setClosestThumbIndex", "setThumbDragStartValue", "setPointerValue", "focusActiveThumb"]
        },
        FOCUS: {
          target: "focus",
          actions: ["setFocusedIndex"]
        },
        THUMB_POINTER_DOWN: {
          target: "dragging",
          actions: ["setFocusedIndex", "setThumbDragOffset", "setThumbDragStartValue", "focusActiveThumb"]
        }
      }
    },
    focus: {
      entry: ["focusActiveThumb"],
      on: {
        POINTER_DOWN: {
          target: "dragging",
          actions: ["setClosestThumbIndex", "setThumbDragStartValue", "setPointerValue", "focusActiveThumb"]
        },
        THUMB_POINTER_DOWN: {
          target: "dragging",
          actions: ["setFocusedIndex", "setThumbDragOffset", "setThumbDragStartValue", "focusActiveThumb"]
        },
        ARROW_DEC: {
          actions: ["decrementThumbAtIndex", "invokeOnChangeEnd"]
        },
        ARROW_INC: {
          actions: ["incrementThumbAtIndex", "invokeOnChangeEnd"]
        },
        HOME: {
          actions: ["setFocusedThumbToMin", "invokeOnChangeEnd"]
        },
        END: {
          actions: ["setFocusedThumbToMax", "invokeOnChangeEnd"]
        },
        BLUR: {
          target: "idle",
          actions: ["clearFocusedIndex"]
        }
      }
    },
    dragging: {
      entry: ["focusActiveThumb"],
      effects: ["trackPointerMove"],
      on: {
        POINTER_UP: {
          target: "focus",
          actions: ["invokeOnChangeEnd", "clearThumbDragOffset", "clearThumbDragStartValue"]
        },
        POINTER_MOVE: {
          actions: ["setPointerValue"]
        },
        POINTER_CANCEL: {
          target: "idle",
          actions: ["clearFocusedIndex", "clearThumbDragOffset", "clearThumbDragStartValue"]
        }
      }
    }
  },
  implementations: {
    guards: {
      hasIndex: ({ event }) => event.index != null
    },
    effects: {
      trackFormControlState({ context, scope }) {
        return trackFormControl(getRootEl(scope), {
          onFieldsetDisabledChange(disabled) {
            context.set("fieldsetDisabled", disabled);
          },
          onFormReset() {
            context.set("value", context.initial("value"));
          }
        });
      },
      trackPointerMove({ scope, send }) {
        return trackPointerMove(scope.getDoc(), {
          onPointerMove(info) {
            send({ type: "POINTER_MOVE", point: info.point });
          },
          onPointerUp() {
            send({ type: "POINTER_UP" });
          }
        });
      },
      trackThumbSize({ context, scope, prop }) {
        if (prop("thumbAlignment") !== "contain" || prop("thumbSize")) return;
        const exec = (el) => {
          const rect = getOffsetRect(el);
          const size = pick(rect, ["width", "height"]);
          if (isEqualSize(context.get("thumbSize"), size)) return;
          context.set("thumbSize", size);
        };
        const thumbEls = getThumbEls(scope);
        thumbEls.forEach(exec);
        const cleanups = thumbEls.map((el) => resizeObserverBorderBox.observe(el, () => exec(el)));
        return callAll(...cleanups);
      }
    },
    actions: {
      dispatchChangeEvent({ context, scope }) {
        dispatchChangeEvent(scope, context.get("value"));
      },
      syncInputElements({ context, scope }) {
        context.get("value").forEach((value, index) => {
          const inputEl = getHiddenInputEl(scope, index);
          setElementValue(inputEl, value.toString());
        });
      },
      invokeOnChangeEnd({ prop, context }) {
        queueMicrotask(() => {
          prop("onValueChangeEnd")?.({ value: context.get("value") });
        });
      },
      setClosestThumbIndex(params) {
        const { context, event } = params;
        const pointValue = getPointValue(params, event.point);
        if (pointValue == null) return;
        const focusedIndex = getClosestIndex(params, pointValue);
        context.set("focusedIndex", focusedIndex);
      },
      setFocusedIndex(params) {
        const { context, event } = params;
        const movableIndex = selectMovableThumb(params, event.index);
        context.set("focusedIndex", movableIndex);
      },
      clearFocusedIndex({ context }) {
        context.set("focusedIndex", -1);
      },
      setThumbDragOffset(params) {
        const { refs, event } = params;
        refs.set("thumbDragOffset", event.offset ?? null);
      },
      clearThumbDragOffset({ refs }) {
        refs.set("thumbDragOffset", null);
      },
      setThumbDragStartValue({ refs, context }) {
        refs.set("thumbDragStartValue", context.get("value").slice());
      },
      clearThumbDragStartValue({ refs }) {
        refs.set("thumbDragStartValue", null);
      },
      setPointerValue(params) {
        queueMicrotask(() => {
          const { context, event, prop, refs } = params;
          const pointValue = getPointValue(params, event.point);
          if (pointValue == null) return;
          const focusedIndex = context.get("focusedIndex");
          const startValues = refs.get("thumbDragStartValue");
          const result = resolveThumbCollision(
            prop("thumbCollisionBehavior"),
            focusedIndex,
            pointValue,
            context.get("value"),
            prop("min"),
            prop("max"),
            prop("step"),
            prop("minStepsBetweenThumbs"),
            startValues?.[focusedIndex]
          );
          if (result.swapped) {
            context.set("focusedIndex", result.index);
          }
          context.set("value", result.values);
        });
      },
      focusActiveThumb({ scope, context }) {
        raf(() => {
          const thumbEl = getThumbEl(scope, context.get("focusedIndex"));
          thumbEl?.focus({ preventScroll: true });
        });
      },
      decrementThumbAtIndex(params) {
        const { context, event } = params;
        const value = decrement(params, event.index, event.step);
        context.set("value", value);
      },
      incrementThumbAtIndex(params) {
        const { context, event } = params;
        const value = increment(params, event.index, event.step);
        context.set("value", value);
      },
      setFocusedThumbToMin(params) {
        const { context } = params;
        const index = context.get("focusedIndex");
        const { min } = getRangeAtIndex(params, index);
        context.set("value", (prev) => setValueAtIndex(prev, index, min));
      },
      setFocusedThumbToMax(params) {
        const { context } = params;
        const index = context.get("focusedIndex");
        const { max } = getRangeAtIndex(params, index);
        context.set("value", (prev) => setValueAtIndex(prev, index, max));
      },
      setValueAtIndex(params) {
        const { context, event } = params;
        const value = constrainValue(params, event.value, event.index);
        context.set("value", (prev) => setValueAtIndex(prev, event.index, value));
      },
      setValue(params) {
        const { context, event } = params;
        const value = normalizeValues(params, event.value);
        context.set("value", value);
      }
    }
  }
});

// components/slider.ts
function formatSliderNumber(n) {
  if (Number.isFinite(n) && n === Math.trunc(n)) return String(Math.trunc(n));
  return String(n);
}
function formatSliderValues(values) {
  return values.map(formatSliderNumber).join(" \u2013 ");
}
function thumbIndex(el) {
  const raw = el.dataset.index;
  const n = raw === void 0 ? 0 : Number(raw);
  return Number.isFinite(n) ? n : 0;
}
function cssThumbSize(el) {
  const sized = el.querySelector('[data-scope="slider"][data-part="control"]') ?? el.querySelector('[data-scope="slider"][data-part="root"]') ?? el;
  const raw = getComputedStyle(sized).getPropertyValue("--thumb-size").trim();
  const px = Number.parseFloat(raw);
  if (Number.isFinite(px) && px > 0) return { width: px, height: px };
  return void 0;
}
function readSliderThumbSize(el) {
  const thumb = el.querySelector('[data-scope="slider"][data-part="thumb"]');
  if (!thumb) return cssThumbSize(el);
  const { width, height } = thumb.getBoundingClientRect();
  if (width > 0 && height > 0) return { width, height };
  const offsetWidth = thumb.offsetWidth;
  const offsetHeight = thumb.offsetHeight;
  if (offsetWidth > 0 && offsetHeight > 0) {
    return { width: offsetWidth, height: offsetHeight };
  }
  const style = getComputedStyle(thumb);
  const computedWidth = Number.parseFloat(style.width);
  const computedHeight = Number.parseFloat(style.height);
  if (computedWidth > 0 && computedHeight > 0) {
    return { width: computedWidth, height: computedHeight };
  }
  return cssThumbSize(el);
}
function withMeasuredThumbSize(props, el) {
  if (props.thumbSize || props.thumbAlignment === "center") return props;
  const thumbSize = readSliderThumbSize(el);
  return thumbSize ? { ...props, thumbSize } : props;
}
var Slider = class extends Component {
  initMachine(props) {
    return new VanillaMachine(machine, withMeasuredThumbSize(props, this.el));
  }
  initApi() {
    return this.zagConnect(connect);
  }
  render() {
    const rootEl = this.el.querySelector('[data-scope="slider"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());
    const labelEl = this.el.querySelector('[data-scope="slider"][data-part="label"]');
    if (labelEl) this.spreadProps(labelEl, this.api.getLabelProps());
    const controlEl = this.el.querySelector(
      '[data-scope="slider"][data-part="control"]'
    );
    if (controlEl) this.spreadProps(controlEl, this.api.getControlProps());
    const trackEl = this.el.querySelector('[data-scope="slider"][data-part="track"]');
    if (trackEl) this.spreadProps(trackEl, this.api.getTrackProps());
    const rangeEl = this.el.querySelector('[data-scope="slider"][data-part="range"]');
    if (rangeEl) this.spreadProps(rangeEl, this.api.getRangeProps());
    const submitName = this.el.dataset.submitName;
    const gatedName = this.el.dataset.name;
    const gateHiddenName = Boolean(submitName && !gatedName);
    this.el.querySelectorAll('[data-scope="slider"][data-part="thumb"]').forEach((thumbEl) => {
      const index = thumbIndex(thumbEl);
      this.spreadProps(thumbEl, this.api.getThumbProps({ index }));
    });
    this.el.querySelectorAll('[data-scope="slider"][data-part="hidden-input"]').forEach((hiddenEl) => {
      if (!(hiddenEl instanceof HTMLInputElement)) return;
      const index = thumbIndex(hiddenEl);
      const value = this.api.value[index];
      syncHiddenInputValue(
        hiddenEl,
        this.el,
        value === void 0 ? "" : String(value),
        (el, props) => this.spreadProps(el, props),
        this.api.getHiddenInputProps({ index })
      );
      if (gateHiddenName) {
        hiddenEl.removeAttribute("name");
        hiddenEl.removeAttribute("form");
      } else if (submitName && !hiddenEl.getAttribute("name")) {
        hiddenEl.setAttribute("name", submitName);
      }
    });
    const valueTextEl = this.el.querySelector(
      '[data-scope="slider"][data-part="value-text"]'
    );
    if (valueTextEl) {
      this.spreadProps(valueTextEl, this.api.getValueTextProps());
      const valueSpan = valueTextEl.querySelector(
        '[data-scope="slider"][data-part="value"]'
      );
      const nextValue = formatSliderValues(this.api.value);
      if (valueSpan && valueSpan.textContent !== nextValue) valueSpan.textContent = nextValue;
    }
    const markerGroupEl = this.el.querySelector(
      '[data-scope="slider"][data-part="marker-group"]'
    );
    if (markerGroupEl) this.spreadProps(markerGroupEl, this.api.getMarkerGroupProps());
    this.el.querySelectorAll('[data-scope="slider"][data-part="marker"]').forEach((markerEl) => {
      const valueStr = markerEl.dataset.value;
      if (valueStr == null) return;
      const value = Number(valueStr);
      if (Number.isNaN(value)) return;
      this.spreadProps(markerEl, this.api.getMarkerProps({ value }));
    });
  }
};

// hooks/slider.ts
function valueChangePayload(el, details) {
  return {
    id: el.id,
    value: details.value
  };
}
function formSubmitName(el) {
  return getString(el, "submitName") ?? getString(el, "name");
}
function hiddenInputs(el) {
  return Array.from(
    el.querySelectorAll('[data-scope="slider"][data-part="hidden-input"]')
  ).filter((node) => node instanceof HTMLInputElement);
}
function ensureHiddenInputNames(el) {
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
function stripHiddenInputNames(el) {
  for (const input of hiddenInputs(el)) {
    input.removeAttribute("name");
    input.removeAttribute("form");
  }
}
function shouldGateHiddenName(el) {
  return Boolean(formSubmitName(el)) && getString(el, "name") === void 0;
}
function queueFormBubblingInputForPhoenix(el, getZag, opts = {}) {
  queueMicrotask(() => {
    const zag = getZag();
    const inputs = ensureHiddenInputNames(el);
    if (inputs.length === 0) return;
    const values = zag.api.value;
    inputs.forEach((input, i) => {
      notifyPhoenixFormChange(input, String(values[i] ?? ""), {
        force: true,
        markUsed: opts.markUsed
      });
    });
  });
}
function coerceSliderValues(value) {
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
function readIndex(source) {
  if (!source || typeof source !== "object") return 0;
  const o = source;
  const raw = o.index ?? o["index"];
  const n = Number(raw ?? 0);
  return Number.isFinite(n) ? n : 0;
}
function readThumbValue(source) {
  if (!source || typeof source !== "object") return 0;
  const o = source;
  const n = Number(o.value ?? o["value"] ?? 0);
  return Number.isFinite(n) ? n : 0;
}
function sliderStaticProps(el) {
  const orientation = getString(el, "orientation", ["horizontal", "vertical"]);
  const origin = getString(el, "origin", ["start", "center", "end"]);
  const thumbAlignment = getString(el, "thumbAlignment", ["contain", "center"]);
  const thumbCollisionBehavior = getString(el, "thumbCollisionBehavior", [
    "none",
    "push",
    "swap"
  ]);
  return {
    min: getNumber(el, "min") ?? 0,
    max: getNumber(el, "max") ?? 100,
    step: getNumber(el, "step") ?? 1,
    ...getNumber(el, "largeStep") !== void 0 ? { largeStep: getNumber(el, "largeStep") } : {},
    ...orientation !== void 0 ? { orientation } : {},
    ...origin !== void 0 ? { origin } : {},
    ...thumbAlignment !== void 0 ? { thumbAlignment } : {},
    ...getNumber(el, "minStepsBetweenThumbs") !== void 0 ? { minStepsBetweenThumbs: getNumber(el, "minStepsBetweenThumbs") } : {},
    ...thumbCollisionBehavior !== void 0 ? { thumbCollisionBehavior } : {},
    disabled: getBoolean(el, "disabled"),
    readOnly: getBoolean(el, "readonly"),
    invalid: getBoolean(el, "invalid"),
    dir: getDir(el),
    form: shouldGateHiddenName(el) ? void 0 : getString(el, "form")
  };
}
var SliderHook = createZagLiveHook({
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
      onValueChange: (details) => {
        hook.fieldTouched = true;
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: valueChangePayload(el, details),
          serverEventName: getString(el, "onValueChange"),
          clientEventName: getString(el, "onValueChangeClient")
        });
      },
      onValueChangeEnd: (details) => {
        hook.fieldTouched = true;
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: valueChangePayload(el, details),
          serverEventName: getString(el, "onValueChangeEnd"),
          clientEventName: getString(el, "onValueChangeEndClient")
        });
        queueFormBubblingInputForPhoenix(el, () => zag);
      }
    });
    const emitValue = (respondTo) => {
      emitResponse({
        respondTo,
        canPushServer: canPush(),
        pushEvent,
        serverEventName: "slider_value_response",
        serverPayload: {
          id: el.id,
          value: zag.api.value,
          dragging: zag.api.dragging
        },
        el,
        domEventName: "slider-value",
        domDetail: {
          id: el.id,
          value: zag.api.value,
          dragging: zag.api.dragging
        }
      });
    };
    const applyValues = (values) => {
      hook.fieldTouched = true;
      zag.api.setValue(values);
      queueFormBubblingInputForPhoenix(el, () => zag);
    };
    dom.add("corex:slider:set-value", (event) => {
      applyValues(coerceSliderValues(event.detail?.value));
    });
    dom.add(
      "corex:slider:set-thumb-value",
      (event) => {
        hook.fieldTouched = true;
        zag.api.setThumbValue(readIndex(event.detail), readThumbValue(event.detail));
        queueFormBubblingInputForPhoenix(el, () => zag);
      }
    );
    dom.add("corex:slider:increment", (event) => {
      hook.fieldTouched = true;
      zag.api.increment(readIndex(event.detail));
      queueFormBubblingInputForPhoenix(el, () => zag);
    });
    dom.add("corex:slider:decrement", (event) => {
      hook.fieldTouched = true;
      zag.api.decrement(readIndex(event.detail));
      queueFormBubblingInputForPhoenix(el, () => zag);
    });
    dom.add("corex:slider:value", (event) => {
      emitValue(parseRespondTo(event.detail));
    });
    server.add("slider_set_value", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.setValue(coerceSliderValues(payload.value));
      queueFormBubblingInputForPhoenix(el, () => zag, { markUsed: false });
    });
    server.add(
      "slider_set_thumb_value",
      (payload) => {
        if (!idMatches(el.id, readPayloadId(payload))) return;
        zag.api.setThumbValue(readIndex(payload), readThumbValue(payload));
        queueFormBubblingInputForPhoenix(el, () => zag, { markUsed: false });
      }
    );
    server.add("slider_increment", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.increment(readIndex(payload));
      queueFormBubblingInputForPhoenix(el, () => zag, { markUsed: false });
    });
    server.add("slider_decrement", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.decrement(readIndex(payload));
      queueFormBubblingInputForPhoenix(el, () => zag, { markUsed: false });
    });
    server.add("slider_value", (payload) => {
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
      ...valuePatch.value !== void 0 ? { value: valuePatch.value } : {}
    });
    zag.render();
    if (!hook.fieldTouched && shouldGateHiddenName(el)) {
      stripHiddenInputNames(el);
    }
  }
});
export {
  SliderHook as Slider,
  coerceSliderValues,
  valueChangePayload
};
