import {
  $12a3c853105e5a70$export$ad991b66133851cf,
  $2aaf608024c21ca1$export$99faa760c7908e4f,
  $58246871e4652552$export$6b862160d295c8e,
  $d07e34cce18680fd$export$b21e0b124e224484,
  $d07e34cce18680fd$export$b4a036af3fc0b032,
  constrainSegments,
  getLocaleSeparator,
  getTodayDate,
  isDateEqual,
  isValidCharacter
} from "./chunks/chunk-YIRWSF62.mjs";
import {
  memo
} from "./chunks/chunk-G4YHNHIV.mjs";
import {
  createLiveRegion
} from "./chunks/chunk-NUOTFVKH.mjs";
import {
  createAnatomy
} from "./chunks/chunk-YMOPD357.mjs";
import {
  Component,
  VanillaMachine,
  ariaAttr,
  canPushEvent,
  contains,
  createMachine,
  createZagLiveHook,
  dataAttr,
  getBoolean,
  getDir,
  getEventKey,
  getNativeEvent,
  getString,
  isComposingEvent,
  mergeWithDefault,
  queryAll,
  raf,
  visuallyHiddenStyle
} from "./chunks/chunk-R62PCG6O.mjs";

// ../node_modules/.pnpm/@zag-js+date-input@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-input/dist/chunk-QZ7TP4HQ.mjs
var __defProp = Object.defineProperty;
var __defNormalProp = (obj, key, value) => key in obj ? __defProp(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
var __publicField = (obj, key, value) => __defNormalProp(obj, typeof key !== "symbol" ? key + "" : key, value);

// ../node_modules/.pnpm/@zag-js+date-input@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-input/dist/date-input.anatomy.mjs
var anatomy = createAnatomy("date-input").parts(
  "root",
  "label",
  "control",
  "segmentGroup",
  "segment",
  "hiddenInput"
);
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+date-input@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-input/dist/date-input.dom.mjs
var getRootId = (ctx) => ctx.ids?.root ?? `date-input:${ctx.id}`;
var getLabelId = (ctx, index) => ctx.ids?.label?.(index) ?? `date-input:${ctx.id}:label:${index}`;
var getControlId = (ctx) => ctx.ids?.control ?? `date-input:${ctx.id}:control`;
var getSegmentGroupId = (ctx, index) => ctx.ids?.segmentGroup?.(index) ?? `date-input:${ctx.id}:segment-group:${index}`;
var getHiddenInputId = (ctx, index) => ctx.ids?.hiddenInput?.(index) ?? `date-input:${ctx.id}:hidden-input:${index}`;
var getControlEl = (ctx) => ctx.getById(getControlId(ctx));
var getSegmentEls = (ctx) => queryAll(getControlEl(ctx), `[data-part=segment]`);

// ../node_modules/.pnpm/@zag-js+date-input@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-input/dist/utils/segments.mjs
function needsTimeGranularity(granularity) {
  return granularity === "hour" || granularity === "minute" || granularity === "second";
}
function getFormatterOptions(opts) {
  const { granularity, digitStyle, hourCycle, timeZone, hasTimeZone, hideTimeZone } = opts;
  const options = {
    timeZone,
    day: digitStyle,
    month: digitStyle,
    year: "numeric",
    hourCycle
  };
  if (needsTimeGranularity(granularity)) options.hour = digitStyle;
  if (granularity === "minute" || granularity === "second") options.minute = "2-digit";
  if (granularity === "second") options.second = "2-digit";
  if (hasTimeZone && !hideTimeZone) options.timeZoneName = "short";
  return options;
}
function resolveAllSegments(formatter) {
  const segs = formatter.formatToParts(/* @__PURE__ */ new Date()).filter((seg) => EDITABLE_SEGMENTS[seg.type]).reduce((p, seg) => {
    const key = TYPE_MAPPING[seg.type] || seg.type;
    p[key] = true;
    return p;
  }, {});
  if (segs.year) segs.era = true;
  return segs;
}
var EDITABLE_SEGMENTS = {
  year: true,
  month: true,
  day: true,
  hour: true,
  minute: true,
  second: true,
  dayPeriod: true,
  era: true,
  literal: false,
  timeZoneName: false,
  weekday: false,
  unknown: false,
  fractionalSecond: false
};
var PAGE_STEP = {
  year: 5,
  month: 2,
  day: 7,
  hour: 2,
  minute: 15,
  second: 15,
  dayPeriod: void 0,
  era: void 0,
  literal: void 0,
  timeZoneName: void 0,
  weekday: void 0,
  unknown: void 0,
  fractionalSecond: void 0
};
var SEGMENT_LABELS = {
  era: "Era",
  year: "Year",
  month: "Month",
  day: "Day",
  hour: "Hour",
  minute: "Minute",
  second: "Second",
  dayPeriod: "AM/PM",
  timeZoneName: "Time zone"
};
function getSegmentLabel(type) {
  return SEGMENT_LABELS[type] ?? type;
}
var TYPE_MAPPING = {
  // Node seems to convert everything to lowercase...
  dayperiod: "dayPeriod",
  // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/DateTimeFormat/formatToParts#named_years
  relatedYear: "year",
  yearName: "literal",
  // not editable
  unknown: "literal"
};
function getSafeType(type) {
  return TYPE_MAPPING[type] ?? type;
}
function getPlaceholder(type, translations, locale) {
  return translations.placeholder?.(locale)?.[type] ?? "";
}
function isEditableSegment(type) {
  return EDITABLE_SEGMENTS[type] === true;
}
function getSafeFormatParts(formatter, dateValue, displayValue) {
  try {
    return formatter.formatToParts(dateValue);
  } catch {
    return formatter.formatToParts(/* @__PURE__ */ new Date()).map((part) => {
      const type = part.type;
      switch (type) {
        case "year":
        case "relatedYear":
          return { ...part, value: String(displayValue.year ?? 0) };
        case "month":
          return { ...part, value: String(displayValue.month ?? 0) };
        case "day":
          return { ...part, value: String(displayValue.day ?? 0) };
      }
      return part;
    });
  }
}
function processSegments({
  dateValue,
  displayValue,
  formatter,
  locale,
  translations,
  granularity
}) {
  const timeValue = ["hour", "minute", "second"];
  const segments = getSafeFormatParts(formatter, dateValue, displayValue);
  const processedSegments = [];
  for (const segment of segments) {
    const type = getSafeType(segment.type);
    let isEditable = isEditableSegment(type);
    if (type === "era" && displayValue.calendar.getEras().length === 1) {
      isEditable = false;
    }
    const isPlaceholder = isEditable && displayValue[type] == null;
    let placeholder = isEditableSegment(type) ? getPlaceholder(type, translations, locale) : null;
    if ((type === "dayPeriod" || type === "era") && segment.value) {
      placeholder = segment.value;
    }
    const dateSegment = {
      type,
      text: isPlaceholder ? placeholder : segment.value,
      ...displayValue.getSegmentLimits(type) ?? {},
      isPlaceholder,
      placeholder,
      isEditable
    };
    if (type === "hour") {
      processedSegments.push({
        type: "literal",
        text: "\u2066",
        isPlaceholder: false,
        placeholder: "",
        isEditable: false
      });
      processedSegments.push(dateSegment);
      if (type === granularity) {
        processedSegments.push({
          type: "literal",
          text: "\u2069",
          isPlaceholder: false,
          placeholder: "",
          isEditable: false
        });
      }
    } else if (timeValue.includes(type) && type === granularity) {
      processedSegments.push(dateSegment);
      processedSegments.push({
        type: "literal",
        text: "\u2069",
        isPlaceholder: false,
        placeholder: "",
        isEditable: false
      });
    } else {
      processedSegments.push(dateSegment);
    }
  }
  return processedSegments;
}

// ../node_modules/.pnpm/@zag-js+date-input@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-input/dist/utils/validity.mjs
var isFocusableSegment = (segment) => segment.type !== "literal";
function getGroupCount(selectionMode) {
  return selectionMode === "range" ? 2 : 1;
}
function getGroupOffset(allSegments, index) {
  return allSegments.slice(0, index).reduce((acc, segs) => acc + segs.length, 0);
}
function resolveActiveSegment(ctx) {
  const { context, computed } = ctx;
  const index = context.get("activeIndex");
  const activeSegmentIndex = context.get("activeSegmentIndex");
  const allSegments = computed("segments");
  const offset = getGroupOffset(allSegments, index);
  return { allSegments, segments: allSegments[index], offset, localIndex: activeSegmentIndex - offset };
}
function getActiveSegment(ctx) {
  const { allSegments, localIndex } = resolveActiveSegment(ctx);
  const index = ctx.context.get("activeIndex");
  return allSegments[index]?.[localIndex];
}
function goToNextSegment(ctx, predicate = isFocusableSegment) {
  const { context } = ctx;
  const index = context.get("activeIndex");
  const { allSegments, segments, offset, localIndex } = resolveActiveSegment(ctx);
  const nextLocalIndex = segments.findIndex((s, i) => i > localIndex && predicate(s));
  if (nextLocalIndex !== -1) {
    context.set("activeSegmentIndex", offset + nextLocalIndex);
    return;
  }
  const nextGroupSegments = allSegments[index + 1];
  if (!nextGroupSegments) return;
  const firstNextGroupLocalIndex = nextGroupSegments.findIndex(predicate);
  if (firstNextGroupLocalIndex === -1) return;
  context.set("activeIndex", index + 1);
  context.set("activeSegmentIndex", offset + segments.length + firstNextGroupLocalIndex);
}
function goToPreviousSegment(ctx, predicate = isFocusableSegment) {
  const { context } = ctx;
  const index = context.get("activeIndex");
  const { allSegments, segments, offset, localIndex } = resolveActiveSegment(ctx);
  const prevLocalIndex = segments.findLastIndex((s, i) => i < localIndex && predicate(s));
  if (prevLocalIndex !== -1) {
    context.set("activeSegmentIndex", offset + prevLocalIndex);
    return;
  }
  const prevGroupIndex = index - 1;
  if (prevGroupIndex < 0) return;
  const prevGroupSegments = allSegments[prevGroupIndex];
  if (!prevGroupSegments) return;
  const lastPrevGroupLocalIndex = prevGroupSegments.findLastIndex(predicate);
  if (lastPrevGroupLocalIndex === -1) return;
  context.set("activeIndex", prevGroupIndex);
  context.set("activeSegmentIndex", getGroupOffset(allSegments, prevGroupIndex) + lastPrevGroupLocalIndex);
}
function getActiveDisplayValue(ctx) {
  const index = ctx.context.get("activeIndex");
  return ctx.context.get("displayValues")[index];
}
function setDisplayValue(ctx, index, dv) {
  const displayValues = [...ctx.context.get("displayValues")];
  displayValues[index] = dv;
  ctx.context.set("displayValues", displayValues);
}

// ../node_modules/.pnpm/@zag-js+date-input@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-input/dist/date-input.connect.mjs
function connect(service, normalize) {
  const { state, context, prop, send, computed, scope } = service;
  const disabled = Boolean(prop("disabled"));
  const readOnly = Boolean(prop("readOnly"));
  const isDateUnavailableFn = prop("isDateUnavailable");
  const value = context.get("value");
  const valueAsDate = value.filter((date) => date != null).map((date) => date.toDate(prop("timeZone")));
  const isDateUnavailable = isDateUnavailableFn ? value.some((date) => date != null && isDateUnavailableFn(date, prop("locale"))) : false;
  const invalid = prop("invalid") ?? isDateUnavailable;
  const focused = state.matches("focused");
  const locale = prop("locale");
  const separator = getLocaleSeparator(locale);
  function getSegmentState(props) {
    const { segment, index = 0 } = props;
    const isEditable = !disabled && !readOnly && segment.isEditable;
    const activeIndex = context.get("activeIndex");
    const isFocused = focused && activeIndex === index;
    return {
      editable: isEditable,
      focused: isFocused,
      readonly: !segment.isEditable || readOnly
    };
  }
  return {
    focused,
    disabled,
    invalid,
    value,
    valueAsDate,
    valueAsString: computed("valueAsString"),
    placeholderValue: context.get("placeholderValue"),
    displayValues: context.get("displayValues"),
    focus() {
      getSegmentEls(scope)[0]?.focus();
    },
    setValue(values) {
      send({ type: "VALUE.SET", value: values });
    },
    clearValue() {
      send({ type: "VALUE.CLEAR" });
    },
    getSegments(props = {}) {
      const { index = 0 } = props;
      const allSegments = computed("segments");
      const segments = allSegments[index] ?? [];
      const enteredKeys = context.get("enteredKeys");
      const activeIndex = context.get("activeIndex");
      const activeSegmentIndex = context.get("activeSegmentIndex");
      if (focused && enteredKeys && index === activeIndex && activeSegmentIndex >= 0) {
        const localActiveSegmentIndex = activeSegmentIndex - getGroupOffset(allSegments, index);
        return segments.map((segment, index2) => {
          if (index2 !== localActiveSegmentIndex) return segment;
          return { ...segment, text: enteredKeys, isPlaceholder: false };
        });
      }
      return segments;
    },
    getSegmentState,
    getRootProps() {
      return normalize.element({
        ...parts.root.attrs,
        dir: prop("dir"),
        id: getRootId(scope),
        "data-disabled": dataAttr(disabled),
        "data-readonly": dataAttr(readOnly),
        "data-invalid": dataAttr(invalid)
      });
    },
    getLabelProps(props = {}) {
      const { index = 0 } = props;
      return normalize.label({
        ...parts.label.attrs,
        id: getLabelId(scope, index),
        dir: prop("dir"),
        htmlFor: getHiddenInputId(scope, index),
        "data-disabled": dataAttr(disabled),
        "data-readonly": dataAttr(readOnly),
        "data-invalid": dataAttr(invalid),
        onClick() {
          if (disabled) return;
          getSegmentEls(scope)[0]?.focus();
        }
      });
    },
    getControlProps() {
      return normalize.element({
        ...parts.control.attrs,
        dir: prop("dir"),
        id: getControlId(scope),
        "data-disabled": dataAttr(disabled),
        "data-readonly": dataAttr(readOnly),
        "data-invalid": dataAttr(invalid),
        "data-focus": dataAttr(focused)
      });
    },
    getSegmentGroupProps(props = {}) {
      const { index = 0 } = props;
      const activeIndex = context.get("activeIndex");
      return normalize.element({
        ...parts.segmentGroup.attrs,
        id: getSegmentGroupId(scope, index),
        dir: prop("dir"),
        role: "group",
        "aria-labelledby": getLabelId(scope, index),
        "data-disabled": dataAttr(disabled),
        "data-readonly": dataAttr(readOnly),
        "data-invalid": dataAttr(invalid),
        "data-focus": dataAttr(focused && activeIndex === index),
        style: {
          unicodeBidi: "isolate"
        }
      });
    },
    getSegmentProps(props) {
      const { segment, index = 0 } = props;
      const segmentState = getSegmentState(props);
      if (segment.type === "literal") {
        return normalize.element({
          ...parts.segment.attrs,
          dir: prop("dir"),
          "aria-hidden": true,
          "data-type": segment.type,
          "data-readonly": "",
          "data-disabled": ""
        });
      }
      return normalize.element({
        ...parts.segment.attrs,
        dir: prop("dir"),
        role: "spinbutton",
        tabIndex: disabled ? void 0 : 0,
        autoComplete: "off",
        spellCheck: segmentState.editable ? "false" : void 0,
        autoCorrect: segmentState.editable ? "off" : void 0,
        contentEditable: segmentState.editable,
        suppressContentEditableWarning: segmentState.editable,
        inputMode: disabled || segment.type === "dayPeriod" || segment.type === "era" || !segmentState.editable ? void 0 : "numeric",
        enterKeyHint: "next",
        "aria-label": getSegmentLabel(segment.type),
        "aria-valuenow": segment.isPlaceholder ? void 0 : segment.value,
        "aria-valuetext": segment.isPlaceholder ? segment.placeholder : segment.text,
        "aria-valuemin": segment.minValue,
        "aria-valuemax": segment.maxValue,
        "aria-invalid": ariaAttr(invalid),
        "aria-readonly": ariaAttr(segmentState.readonly),
        "aria-disabled": ariaAttr(disabled),
        "data-value": segment.value,
        "data-type": segment.type,
        "data-readonly": dataAttr(segmentState.readonly),
        "data-disabled": dataAttr(disabled),
        "data-editable": dataAttr(segment.isEditable && !readOnly && !disabled),
        "data-placeholder-shown": dataAttr(segment.isPlaceholder),
        style: {
          caretColor: "transparent"
        },
        onFocus(event) {
          const segmentEls = getSegmentEls(scope);
          const target = event.currentTarget;
          const segmentIndex = segmentEls.indexOf(target);
          send({ type: "SEGMENT.FOCUS", dateIndex: index, segmentIndex });
          const selection = target.ownerDocument?.getSelection?.();
          if (selection && target) {
            selection.collapse(target);
          }
        },
        onBlur(event) {
          const next = event.relatedTarget;
          const control = getControlEl(scope);
          if (contains(control, next)) return;
          send({ type: "SEGMENT.BLUR", index: -1 });
        },
        onKeyDown(event) {
          if (event.defaultPrevented || event.ctrlKey || event.metaKey || event.shiftKey || event.altKey || readOnly || isComposingEvent(event)) {
            return;
          }
          const keyMap = {
            ArrowLeft() {
              send({ type: "SEGMENT.ARROW_LEFT" });
            },
            ArrowRight() {
              send({ type: "SEGMENT.ARROW_RIGHT" });
            },
            ArrowUp() {
              send({ type: "SEGMENT.ADJUST", segment, amount: 1 });
            },
            ArrowDown() {
              send({ type: "SEGMENT.ADJUST", segment, amount: -1 });
            },
            PageUp() {
              send({
                type: "SEGMENT.ADJUST",
                segment,
                amount: PAGE_STEP[segment.type] ?? 1
              });
            },
            PageDown() {
              send({
                type: "SEGMENT.ADJUST",
                segment,
                amount: -(PAGE_STEP[segment.type] ?? 1)
              });
            },
            Backspace() {
              send({ type: "SEGMENT.BACKSPACE", segment });
            },
            Delete() {
              send({ type: "SEGMENT.BACKSPACE", segment });
            },
            Home() {
              send({ type: "SEGMENT.HOME", segment });
            },
            End() {
              send({ type: "SEGMENT.END", segment });
            }
          };
          const exec = keyMap[getEventKey(event, { dir: prop("dir") })];
          if (exec) {
            exec(event);
            event.preventDefault();
            event.stopPropagation();
          }
        },
        onPointerDown(event) {
          event.stopPropagation();
        },
        onMouseDown(event) {
          event.stopPropagation();
        },
        onBeforeInput(event) {
          const { data, inputType } = getNativeEvent(event);
          if (ALLOWED_INPUT_TYPES.includes(inputType)) {
            event.preventDefault();
            return;
          }
          if (inputType === "insertFromPaste") {
            event.preventDefault();
            return;
          }
          if (inputType === "insertCompositionText") {
            const target = event.currentTarget || event.target;
            if (target) {
              event.preventDefault();
              if (data != null) {
                send({ type: "SEGMENT.INPUT", segment, input: data });
              }
            }
            return;
          }
          const isTextSegment = segment.type === "dayPeriod" || segment.type === "era";
          if (data && (isTextSegment || isValidCharacter(data, separator, locale))) {
            event.preventDefault();
            send({ type: "SEGMENT.INPUT", segment, input: data });
          } else {
            event.preventDefault();
          }
        },
        onPaste(event) {
          event.preventDefault();
          const text = event.clipboardData?.getData("text/plain")?.trim();
          if (text) {
            send({ type: "SEGMENT.PASTE", value: text });
          }
        }
      });
    },
    getHiddenInputProps(props = {}) {
      const { index = 0, name } = props;
      const value2 = context.get("value");
      const inputName = name || prop("name");
      return normalize.input({
        ...parts.hiddenInput.attrs,
        type: "hidden",
        id: getHiddenInputId(scope, index),
        name: inputName ? value2.length > 1 ? `${inputName}[${index}]` : inputName : void 0,
        form: prop("form"),
        required: prop("required"),
        disabled,
        readOnly,
        value: computed("valueAsString")[index] ?? "",
        style: visuallyHiddenStyle
      });
    }
  };
}
var ALLOWED_INPUT_TYPES = ["deleteContentBackward", "deleteContentForward", "deleteByCut", "deleteByDrag"];

// ../node_modules/.pnpm/@zag-js+date-input@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-input/dist/utils/formatting.mjs
function toFormatterDate(date, formatter) {
  return date.toDate(formatter.resolvedOptions().timeZone);
}
function getValueAsString(value, prop) {
  return value.map((date) => {
    if (date == null) return "";
    try {
      return prop("format")(date, { locale: prop("locale"), timeZone: prop("timeZone") });
    } catch {
      return "";
    }
  });
}
function resolveHourCycleProp(hourCycle) {
  if (hourCycle === 12) return "h12";
  if (hourCycle === 24) return "h23";
}
function resolvePlaceholderValue(options, timeZone, granularity, value, defaultValue, calendar) {
  let placeholder = options.placeholderValue || options.defaultPlaceholderValue || value?.[0] || defaultValue?.[0] || getTodayDate(timeZone, calendar);
  placeholder = constrainSegments(placeholder, options.min, options.max);
  if (needsTimeGranularity(granularity) && !("hour" in placeholder)) {
    placeholder = $d07e34cce18680fd$export$b21e0b124e224484(placeholder);
  }
  return placeholder;
}
function createFormatFn(formatter) {
  return (date) => {
    const isBC = date.calendar?.identifier === "gregory" && date.era === "BC";
    if (isBC) {
      const jsd = date.toDate("UTC");
      const prolYear = jsd.getUTCFullYear();
      const safeDate = new Date(Date.UTC(2e3, jsd.getUTCMonth(), jsd.getUTCDate()));
      return formatter.formatToParts(safeDate).map((p) => p.type === "year" ? String(prolYear) : p.value).join("");
    }
    return formatter.format(toFormatterDate(date, formatter));
  };
}

// ../node_modules/.pnpm/@zag-js+date-input@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-input/dist/utils/incomplete-date.mjs
function resolvedHourCycle(formatter) {
  const hc = formatter.resolvedOptions().hourCycle;
  if (hc === "h11" || hc === "h12" || hc === "h23" || hc === "h24") return hc;
  return "h23";
}
function incompleteDateHash(dv) {
  return `${dv.year}|${dv.month}|${dv.day}|${dv.hour}|${dv.dayPeriod}|${dv.minute}|${dv.second}|${dv.era}`;
}
function incompleteDateEqual(a, b) {
  return incompleteDateHash(a) === incompleteDateHash(b);
}
function initDisplayValues(value, placeholderValue, hourCycle, count) {
  const calendar = placeholderValue.calendar;
  if (value?.length) {
    return Array.from(
      { length: count },
      (_, i) => value[i] ? new IncompleteDate(calendar, hourCycle, value[i]) : new IncompleteDate(calendar, hourCycle)
    );
  }
  return Array.from({ length: count }, () => new IncompleteDate(calendar, hourCycle));
}
var IncompleteDate = class _IncompleteDate {
  constructor(calendar, hourCycle, dateValue) {
    __publicField(this, "calendar");
    __publicField(this, "era");
    __publicField(this, "year");
    __publicField(this, "month");
    __publicField(this, "day");
    __publicField(this, "hour");
    __publicField(this, "hourCycle");
    __publicField(this, "dayPeriod");
    __publicField(this, "minute");
    __publicField(this, "second");
    __publicField(this, "millisecond");
    __publicField(this, "offset");
    this.era = dateValue?.era ?? null;
    this.calendar = calendar;
    this.year = dateValue?.year ?? null;
    this.month = dateValue?.month ?? null;
    this.day = dateValue?.day ?? null;
    this.hour = dateValue?.hour ?? null;
    this.hourCycle = hourCycle;
    this.dayPeriod = null;
    this.minute = dateValue?.minute ?? null;
    this.second = dateValue?.second ?? null;
    this.millisecond = dateValue?.millisecond ?? null;
    this.offset = "offset" in (dateValue ?? {}) ? dateValue.offset : null;
    if (this.hour != null) {
      const [dayPeriod, hour] = toHourCycle(this.hour, hourCycle);
      this.dayPeriod = dayPeriod;
      this.hour = hour;
    }
  }
  copy() {
    const res = new _IncompleteDate(this.calendar, this.hourCycle);
    res.era = this.era;
    res.year = this.year;
    res.month = this.month;
    res.day = this.day;
    res.hour = this.hour;
    res.dayPeriod = this.dayPeriod;
    res.minute = this.minute;
    res.second = this.second;
    res.millisecond = this.millisecond;
    res.offset = this.offset;
    return res;
  }
  /** Rebuild this date under a new hour cycle, preserving all field values. */
  withHourCycle(nextHourCycle) {
    if (nextHourCycle === this.hourCycle) return this;
    const hour24 = this.hour != null ? fromHourCycle(this.hour, this.dayPeriod ?? 0, this.hourCycle) : null;
    const res = new _IncompleteDate(this.calendar, nextHourCycle, {
      era: this.era,
      year: this.year,
      month: this.month,
      day: this.day,
      hour: hour24,
      minute: this.minute,
      second: this.second,
      millisecond: this.millisecond
    });
    res.offset = this.offset;
    if (this.hour == null && this.dayPeriod != null && (nextHourCycle === "h12" || nextHourCycle === "h11")) {
      res.dayPeriod = this.dayPeriod;
    }
    return res;
  }
  /** Checks whether all the specified segments have a value. */
  isComplete(segments) {
    return segments.every((segment) => this[segment] != null);
  }
  /** Checks if the date is empty (i.e. all specified segments are null). */
  isCleared(segments) {
    return segments.every((segment) => this[segment] === null);
  }
  /** Sets the given field. */
  set(field, value, placeholder) {
    const result = this.copy();
    result[field] = value;
    if (field === "hour" && result.dayPeriod == null && "hour" in placeholder) {
      result.dayPeriod = toHourCycle(placeholder.hour, this.hourCycle)[0];
    }
    if (field === "year" && result.era == null) {
      result.era = placeholder.era;
    }
    if (field !== "second" && field !== "literal" && field !== "timeZoneName") {
      result.offset = null;
    }
    return result;
  }
  /** Sets the given field to null. */
  clear(field) {
    const result = this.copy();
    result[field] = null;
    if (field === "year") {
      result.era = null;
    }
    result.offset = null;
    return result;
  }
  /** Increments or decrements the given field. If it is null, then it is set to the placeholder value (no increment on first press). */
  cycle(field, amount, placeholder, displaySegments) {
    const res = this.copy();
    if (res[field] == null && field !== "dayPeriod" && field !== "era") {
      if (field === "hour" && "hour" in placeholder) {
        const [dayPeriod, hour] = toHourCycle(placeholder.hour, this.hourCycle);
        res.dayPeriod = dayPeriod;
        res.hour = hour;
      } else {
        ;
        res[field] = placeholder[field];
      }
      if (field === "year" && res.era == null) {
        res.era = placeholder.era;
      }
      return res;
    }
    switch (field) {
      case "era": {
        const eras = this.calendar.getEras();
        let index = eras.indexOf(res.era);
        index = cycleValue(index, amount, 0, eras.length - 1);
        res.era = eras[index];
        break;
      }
      case "year": {
        let date = new $2aaf608024c21ca1$export$99faa760c7908e4f(
          this.calendar,
          this.era ?? placeholder.era,
          this.year ?? placeholder.year,
          this.month ?? 1,
          this.day ?? 1
        );
        date = date.cycle(field, amount, { round: field === "year" });
        res.era = date.era;
        res.year = date.year;
        break;
      }
      case "month":
        res.month = cycleValue(res.month ?? 1, amount, 1, this.calendar.getMaximumMonthsInYear());
        break;
      case "day":
        res.day = cycleValue(res.day ?? 1, amount, 1, this.calendar.getMaximumDaysInMonth());
        break;
      case "hour": {
        const hasDateSegments = displaySegments.some((s) => ["year", "month", "day"].includes(s));
        if ("timeZone" in placeholder && (!hasDateSegments || res.year != null && res.month != null && res.day != null)) {
          let date = this.toValue(placeholder);
          date = date.cycle("hour", amount, { hourCycle: this.hourCycle === "h12" ? 12 : 24, round: false });
          const [dayPeriod, adjustedHour] = toHourCycle(date.hour, this.hourCycle);
          res.hour = adjustedHour;
          res.dayPeriod = dayPeriod;
          res.offset = date.offset;
        } else {
          const hours = res.hour ?? 0;
          const limits = this.getSegmentLimits("hour");
          res.hour = cycleValue(hours, amount, limits.minValue, limits.maxValue);
          if (res.dayPeriod == null && "hour" in placeholder) {
            res.dayPeriod = toHourCycle(placeholder.hour, this.hourCycle)[0];
          }
        }
        break;
      }
      case "dayPeriod":
        res.dayPeriod = cycleValue(res.dayPeriod ?? 0, amount, 0, 1);
        break;
      case "minute":
        res.minute = cycleValue(res.minute ?? 0, amount, 0, 59, true);
        break;
      case "second":
        res.second = cycleValue(res.second ?? 0, amount, 0, 59, true);
        break;
    }
    return res;
  }
  /** Converts the incomplete date to a full date value, using the provided value for any unset fields. */
  toValue(value) {
    if ("hour" in value) {
      let hour = this.hour;
      if (hour != null) {
        hour = fromHourCycle(hour, this.dayPeriod ?? 0, this.hourCycle);
      } else if (this.hourCycle === "h12" || this.hourCycle === "h11") {
        hour = this.dayPeriod === 1 ? 12 : 0;
      }
      const res = value.set({
        era: this.era ?? value.era,
        year: this.year ?? value.year,
        month: this.month ?? value.month,
        day: this.day ?? value.day,
        hour: hour ?? value.hour,
        minute: this.minute ?? value.minute,
        second: this.second ?? value.second,
        millisecond: this.millisecond ?? value.millisecond
      });
      if ("offset" in res && this.offset != null && res.offset !== this.offset) {
        return res.add({ milliseconds: res.offset - this.offset });
      }
      return res;
    } else {
      return value.set({
        era: this.era ?? value.era,
        year: this.year ?? value.year,
        month: this.month ?? value.month,
        day: this.day ?? value.day
      });
    }
  }
  getSegmentLimits(type) {
    switch (type) {
      case "era": {
        const eras = this.calendar.getEras();
        return {
          value: this.era != null ? eras.indexOf(this.era) : eras.length - 1,
          minValue: 0,
          maxValue: eras.length - 1
        };
      }
      case "year":
        return {
          value: this.year,
          minValue: 1,
          maxValue: 9999
        };
      case "month":
        return {
          value: this.month,
          minValue: 1,
          maxValue: this.calendar.getMaximumMonthsInYear()
        };
      case "day":
        return {
          value: this.day,
          minValue: 1,
          maxValue: this.calendar.getMaximumDaysInMonth()
        };
      case "dayPeriod":
        return {
          value: this.dayPeriod,
          minValue: 0,
          maxValue: 1
        };
      case "hour": {
        let minValue = 0;
        let maxValue = 23;
        if (this.hourCycle === "h12") {
          minValue = 1;
          maxValue = 12;
        } else if (this.hourCycle === "h11") {
          minValue = 0;
          maxValue = 11;
        }
        return {
          value: this.hour,
          minValue,
          maxValue
        };
      }
      case "minute":
        return {
          value: this.minute,
          minValue: 0,
          maxValue: 59
        };
      case "second":
        return {
          value: this.second,
          minValue: 0,
          maxValue: 59
        };
    }
  }
  /** Returns a debug string of all non-null fields. Returns "-" when all fields are null. */
  toString() {
    const fields = {
      era: this.era,
      year: this.year,
      month: this.month,
      day: this.day,
      hour: this.hour,
      dayPeriod: this.dayPeriod,
      minute: this.minute,
      second: this.second
    };
    const parts2 = Object.entries(fields).filter(([, v]) => v != null).map(([k, v]) => `${k}=${v}`);
    return parts2.length > 0 ? parts2.join(",") : "-";
  }
};
function cycleValue(value, amount, min, max, round = false) {
  if (round) {
    value += Math.sign(amount);
    if (value < min) {
      value = max;
    }
    const div = Math.abs(amount);
    if (amount > 0) {
      value = Math.ceil(value / div) * div;
    } else {
      value = Math.floor(value / div) * div;
    }
    if (value > max) {
      value = min;
    }
  } else {
    value += amount;
    if (value < min) {
      value = max - (min - value - 1);
    } else if (value > max) {
      value = min + (value - max - 1);
    }
  }
  return value;
}
function toHourCycle(hour, hourCycle) {
  let dayPeriod = hour >= 12 ? 1 : 0;
  switch (hourCycle) {
    case "h11":
      if (hour >= 12) {
        hour -= 12;
      }
      break;
    case "h12":
      if (hour === 0) {
        hour = 12;
      } else if (hour > 12) {
        hour -= 12;
      }
      break;
    case "h23":
      dayPeriod = null;
      break;
    case "h24":
      hour += 1;
      dayPeriod = null;
  }
  return [dayPeriod, hour];
}
function fromHourCycle(hour, dayPeriod, hourCycle) {
  switch (hourCycle) {
    case "h11":
      if (dayPeriod === 1) {
        hour += 12;
      }
      break;
    case "h12":
      if (hour === 12) {
        hour = 0;
      }
      if (dayPeriod === 1) {
        hour += 12;
      }
      break;
    case "h24":
      hour -= 1;
      break;
  }
  return hour;
}

// ../node_modules/.pnpm/@zag-js+date-input@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-input/dist/utils/input.mjs
function isNumberString(value) {
  return !Number.isNaN(Number.parseInt(value));
}
function updateSegmentValue(ctx, segment, input) {
  const { context, prop } = ctx;
  const type = segment.type;
  const index = context.get("activeIndex");
  const formatter = prop("formatter");
  const enteredKeys = context.get("enteredKeys");
  const placeholderValue = context.get("placeholderValue");
  let dv = getActiveDisplayValue(ctx);
  let next;
  switch (type) {
    case "dayPeriod": {
      if (!("hour" in dv.toValue(placeholderValue))) return;
      const amPmFormatter = new $12a3c853105e5a70$export$ad991b66133851cf(prop("locale"), { hour: "numeric", hour12: true });
      const amDate = /* @__PURE__ */ new Date();
      amDate.setHours(0);
      const pmDate = /* @__PURE__ */ new Date();
      pmDate.setHours(12);
      const am = amPmFormatter.formatToParts(amDate).find((p) => p.type === "dayPeriod")?.value || "AM";
      const pm = amPmFormatter.formatToParts(pmDate).find((p) => p.type === "dayPeriod")?.value || "PM";
      const lowerInput = input.toLowerCase();
      if (am.toLowerCase().startsWith(lowerInput)) {
        next = dv.set("dayPeriod", 0, placeholderValue);
      } else if (pm.toLowerCase().startsWith(lowerInput)) {
        next = dv.set("dayPeriod", 1, placeholderValue);
      } else {
        break;
      }
      setDisplayValue(ctx, index, next);
      goToNextSegment(ctx);
      break;
    }
    case "era": {
      const eras = dv.calendar.getEras();
      const eraFormatter = new $12a3c853105e5a70$export$ad991b66133851cf(prop("locale"), { era: "short" });
      const lowerInput = input.toLowerCase();
      for (let i = 0; i < eras.length; i++) {
        const eraDate = dv.toValue(placeholderValue).set({ year: 1 }).toDate(prop("timeZone"));
        const formattedEra = eraFormatter.formatToParts(eraDate).find((p) => p.type === "era")?.value;
        if (formattedEra && formattedEra.toLowerCase().startsWith(lowerInput)) {
          next = dv.set("era", eras[i], placeholderValue);
          setDisplayValue(ctx, index, next);
          goToNextSegment(ctx);
          break;
        }
      }
      break;
    }
    case "day":
    case "hour":
    case "minute":
    case "second":
    case "month":
    case "year": {
      let newValue = enteredKeys + input;
      let numberValue = Number.parseInt(newValue);
      let segmentValue = numberValue;
      let allowsZero = segment.minValue === 0;
      if (!isNumberString(input)) return;
      if (segment.type === "hour" && formatter.resolvedOptions().hour12) {
        switch (formatter.resolvedOptions().hourCycle) {
          case "h11":
            if (numberValue > 11) {
              segmentValue = Number.parseInt(input);
            }
            break;
          case "h12":
            allowsZero = false;
            if (numberValue > 12) {
              segmentValue = Number.parseInt(input);
            }
            break;
        }
        if (segment.value !== void 0 && segment.value >= 12 && numberValue > 1) {
          numberValue += 12;
        }
      } else if (segment.maxValue !== void 0 && numberValue > segment.maxValue) {
        segmentValue = Number.parseInt(input);
      }
      if (isNaN(numberValue)) {
        return;
      }
      const shouldSetValue = segmentValue !== 0 || allowsZero;
      if (shouldSetValue) {
        dv = dv.set(type, segmentValue, placeholderValue);
        next = dv;
        setDisplayValue(ctx, index, dv);
      }
      if (segment.maxValue !== void 0 && (Number(numberValue + "0") > segment.maxValue || newValue.length >= String(segment.maxValue).length)) {
        context.set("enteredKeys", "");
        if (shouldSetValue) {
          goToNextSegment(ctx);
        }
      } else {
        context.set("enteredKeys", newValue);
      }
      break;
    }
  }
  return next;
}

// ../node_modules/.pnpm/@zag-js+date-input@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-input/dist/utils/placeholders.mjs
var LOCALE_PLACEHOLDERS = {
  ach: ["mwaka", "dwe", "nino"],
  af: ["jjjj", "mm", "dd"],
  am: ["\u12D3\u12D3\u12D3\u12D3", "\u121A\u121C", "\u1240\u1240"],
  an: ["aaaa", "mm", "dd"],
  ar: ["\u0633\u0646\u0629", "\u0634\u0647\u0631", "\u064A\u0648\u0645"],
  ast: ["aaaa", "mm", "dd"],
  az: ["iiii", "aa", "gg"],
  be: ["\u0433\u0433\u0433\u0433", "\u043C\u043C", "\u0434\u0434"],
  bg: ["\u0433\u0433\u0433\u0433", "\u043C\u043C", "\u0434\u0434"],
  bn: ["yyyy", "\u09AE\u09BF\u09AE\u09BF", "dd"],
  br: ["bbbb", "mm", "dd"],
  bs: ["gggg", "mm", "dd"],
  ca: ["aaaa", "mm", "dd"],
  cak: ["jjjj", "ii", "q'q'"],
  ckb: ["\u0633\u0627\u06B5", "\u0645\u0627\u0646\u06AF", "\u0695\u06C6\u0698"],
  cs: ["rrrr", "mm", "dd"],
  cy: ["bbbb", "mm", "dd"],
  da: ["\xE5\xE5\xE5\xE5", "mm", "dd"],
  de: ["jjjj", "mm", "tt"],
  dsb: ["llll", "mm", "\u017A\u017A"],
  el: ["\u03B5\u03B5\u03B5\u03B5", "\u03BC\u03BC", "\u03B7\u03B7"],
  en: ["yyyy", "mm", "dd"],
  eo: ["jjjj", "mm", "tt"],
  es: ["aaaa", "mm", "dd"],
  et: ["aaaa", "kk", "pp"],
  eu: ["uuuu", "hh", "ee"],
  fa: ["\u0633\u0627\u0644", "\u0645\u0627\u0647", "\u0631\u0648\u0632"],
  ff: ["hhhh", "ll", "\xF1\xF1"],
  fi: ["vvvv", "kk", "pp"],
  fr: ["aaaa", "mm", "jj"],
  fy: ["jjjj", "mm", "dd"],
  ga: ["bbbb", "mm", "ll"],
  gd: ["bbbb", "mm", "ll"],
  gl: ["aaaa", "mm", "dd"],
  he: ["\u05E9\u05E0\u05D4", "\u05D7\u05D5\u05D3\u05E9", "\u05D9\u05D5\u05DD"],
  hr: ["gggg", "mm", "dd"],
  hsb: ["llll", "mm", "dd"],
  hu: ["\xE9\xE9\xE9\xE9", "hh", "nn"],
  ia: ["aaaa", "mm", "dd"],
  id: ["tttt", "bb", "hh"],
  it: ["aaaa", "mm", "gg"],
  ja: ["\u5E74", "\u6708", "\u65E5"],
  ka: ["\u10EC\u10EC\u10EC\u10EC", "\u10D7\u10D7", "\u10E0\u10E0"],
  kk: ["\u0436\u0436\u0436\u0436", "\u0430\u0430", "\u043A\u043A"],
  kn: ["\u0CB5\u0CB5\u0CB5\u0CB5", "\u0CAE\u0CBF\u0CAE\u0CC0", "\u0CA6\u0CBF\u0CA6\u0CBF"],
  ko: ["\uC5F0\uB3C4", "\uC6D4", "\uC77C"],
  lb: ["jjjj", "mm", "dd"],
  lo: ["\u0E9B\u0E9B\u0E9B\u0E9B", "\u0E94\u0E94", "\u0EA7\u0EA7"],
  lt: ["mmmm", "mm", "dd"],
  lv: ["gggg", "mm", "dd"],
  meh: ["aaaa", "mm", "dd"],
  ml: ["\u0D35\u0D7C\u0D37\u0D02", "\u0D2E\u0D3E\u0D38\u0D02", "\u0D24\u0D40\u0D2F\u0D24\u0D3F"],
  ms: ["tttt", "mm", "hh"],
  nl: ["jjjj", "mm", "dd"],
  nn: ["\xE5\xE5\xE5\xE5", "mm", "dd"],
  no: ["\xE5\xE5\xE5\xE5", "mm", "dd"],
  oc: ["aaaa", "mm", "jj"],
  pl: ["rrrr", "mm", "dd"],
  pt: ["aaaa", "mm", "dd"],
  rm: ["oooo", "mm", "dd"],
  ro: ["aaaa", "ll", "zz"],
  ru: ["\u0433\u0433\u0433\u0433", "\u043C\u043C", "\u0434\u0434"],
  sc: ["aaaa", "mm", "dd"],
  scn: ["aaaa", "mm", "jj"],
  sk: ["rrrr", "mm", "dd"],
  sl: ["llll", "mm", "dd"],
  sr: ["\u0433\u0433\u0433\u0433", "\u043C\u043C", "\u0434\u0434"],
  sv: ["\xE5\xE5\xE5\xE5", "mm", "dd"],
  szl: ["rrrr", "mm", "dd"],
  tg: ["\u0441\u0441\u0441\u0441", "\u043C\u043C", "\u0440\u0440"],
  th: ["\u0E1B\u0E1B\u0E1B\u0E1B", "\u0E14\u0E14", "\u0E27\u0E27"],
  tr: ["yyyy", "aa", "gg"],
  uk: ["\u0440\u0440\u0440\u0440", "\u043C\u043C", "\u0434\u0434"],
  "sr-Latn": ["gggg", "mm", "dd"],
  "zh-CN": ["\u5E74", "\u6708", "\u65E5"],
  "zh-TW": ["\u5E74", "\u6708", "\u65E5"]
};
function getLocaleLanguage(locale) {
  if (typeof Intl !== "undefined" && Intl.Locale) {
    return new Intl.Locale(locale).language;
  }
  return locale.split("-")[0];
}
function getLocaleScript(locale) {
  if (typeof Intl !== "undefined" && Intl.Locale) {
    return new Intl.Locale(locale).script || void 0;
  }
  const script = locale.split("-").find((part) => part.length === 4);
  if (!script) return void 0;
  return script.charAt(0).toUpperCase() + script.slice(1).toLowerCase();
}
function getLocalePlaceholders(locale) {
  const exact = LOCALE_PLACEHOLDERS[locale];
  if (exact) return exact;
  const lang = getLocaleLanguage(locale);
  const script = getLocaleScript(locale);
  if (script) {
    const langScript = `${lang}-${script}`;
    const langScriptPlaceholder = LOCALE_PLACEHOLDERS[langScript];
    if (langScriptPlaceholder) return langScriptPlaceholder;
  }
  return LOCALE_PLACEHOLDERS[lang] || LOCALE_PLACEHOLDERS.en;
}
var defaultTranslations = {
  placeholder(locale) {
    const [year, month, day] = getLocalePlaceholders(locale);
    return {
      day,
      month,
      year,
      hour: "\u2013\u2013",
      minute: "\u2013\u2013",
      second: "\u2013\u2013",
      dayPeriod: "AM/PM",
      era: "era",
      timeZoneName: "timeZone",
      weekday: "weekday",
      unknown: "unknown",
      fractionalSecond: "ff"
    };
  }
};

// ../node_modules/.pnpm/@zag-js+date-input@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-input/dist/date-input.parse.mjs
function parse(value) {
  if (Array.isArray(value)) {
    return value.map((v) => parse(v));
  }
  if (value instanceof Date) {
    return new $2aaf608024c21ca1$export$99faa760c7908e4f(value.getFullYear(), value.getMonth() + 1, value.getDate());
  }
  return $58246871e4652552$export$6b862160d295c8e(value);
}

// ../node_modules/.pnpm/@zag-js+date-input@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-input/dist/date-input.machine.mjs
var machine = createMachine({
  props({ props }) {
    const locale = props.locale || "en-US";
    const timeZone = props.timeZone || "UTC";
    const selectionMode = props.selectionMode || "single";
    const granularity = props.granularity || "day";
    const calendar = resolveCalendar(locale, props.createCalendar);
    const defaultValue = props.defaultValue ? props.defaultValue.map((date) => constrainSegments(toTargetCalendar(date, calendar), props.min, props.max)) : [];
    const value = props.value ? props.value.map((date) => constrainSegments(toTargetCalendar(date, calendar), props.min, props.max)) : void 0;
    const placeholderValue = resolvePlaceholderValue(props, timeZone, granularity, value, defaultValue, calendar);
    const hourCycle = resolveHourCycleProp(props.hourCycle);
    const shouldForceLeadingZeros = props.shouldForceLeadingZeros ?? false;
    const digitStyle = shouldForceLeadingZeros ? "2-digit" : "numeric";
    const firstValue = value?.[0] ?? defaultValue?.[0] ?? placeholderValue;
    const hasTimeZone = firstValue != null && "timeZone" in firstValue;
    const formatter = props.formatter ?? new $12a3c853105e5a70$export$ad991b66133851cf(
      locale,
      getFormatterOptions({
        granularity,
        digitStyle,
        hourCycle,
        timeZone,
        hasTimeZone,
        hideTimeZone: props.hideTimeZone
      })
    );
    const allSegments = props.allSegments ?? resolveAllSegments(formatter);
    return {
      locale,
      timeZone,
      selectionMode,
      format: createFormatFn(formatter),
      ...props,
      value,
      defaultValue,
      granularity,
      shouldForceLeadingZeros,
      formatter,
      placeholderValue: typeof props.placeholderValue === "undefined" ? void 0 : placeholderValue,
      defaultPlaceholderValue: placeholderValue,
      allSegments
    };
  },
  initialState() {
    return "idle";
  },
  refs() {
    return {
      announcer: null,
      segmentToAnnounceIndex: null
    };
  },
  effects: ["setupLiveRegion"],
  context({ prop, bindable }) {
    const formatter = prop("formatter");
    const hourCycle = resolvedHourCycle(formatter);
    const placeholderValue = prop("defaultPlaceholderValue");
    const initialValue = prop("value") || prop("defaultValue");
    const groupCount = getGroupCount(prop("selectionMode"));
    return {
      value: bindable(() => ({
        defaultValue: prop("defaultValue"),
        value: prop("value"),
        isEqual(a, b) {
          if (a?.length !== b?.length) return false;
          const len = Math.max(a.length, b.length);
          for (let i = 0; i < len; i++) {
            if (!isDateEqual(a[i], b[i])) return false;
          }
          return true;
        },
        hash: (v) => v.map((date) => date?.toString() ?? "").join(","),
        onChange(value) {
          const valueAsString = getValueAsString(value, prop);
          prop("onValueChange")?.({ value, valueAsString });
        }
      })),
      activeIndex: bindable(() => ({
        defaultValue: 0,
        sync: true
      })),
      activeSegmentIndex: bindable(() => ({
        defaultValue: -1,
        sync: true
      })),
      placeholderValue: bindable(() => ({
        defaultValue: prop("defaultPlaceholderValue"),
        isEqual: isDateEqual,
        hash: (v) => v.toString(),
        onChange(placeholderValue2) {
          prop("onPlaceholderChange")?.({ value: prop("value") ?? [], valueAsString: [], placeholderValue: placeholderValue2 });
        }
      })),
      displayValues: bindable(() => ({
        defaultValue: initDisplayValues(
          initialValue,
          placeholderValue ?? getTodayDate(prop("timeZone")),
          hourCycle,
          groupCount
        ),
        isEqual: (a, b) => b != null && a.length === b.length && a.every((d, i) => incompleteDateEqual(d, b[i])),
        hash: (v) => v.map(incompleteDateHash).join("||")
      })),
      enteredKeys: bindable(() => ({
        defaultValue: "",
        sync: true
      }))
    };
  },
  computed: {
    isInteractive: ({ prop }) => !prop("disabled") && !prop("readOnly"),
    groupCount: ({ prop }) => getGroupCount(prop("selectionMode")),
    valueAsString: ({ context, prop }) => getValueAsString(context.get("value"), prop),
    segments: memo(
      ({ context, prop }) => [
        context.hash("value"),
        prop("selectionMode"),
        context.hash("placeholderValue"),
        context.hash("displayValues"),
        prop("allSegments"),
        prop("timeZone"),
        prop("translations"),
        prop("granularity"),
        JSON.stringify(prop("formatter").resolvedOptions()),
        prop("locale")
      ],
      (_deps, { context, prop, computed }) => {
        const value = context.get("value");
        const placeholderValue = context.get("placeholderValue");
        const displayValues = context.get("displayValues");
        const allSegments = prop("allSegments");
        const translations = mergeWithDefault(defaultTranslations, prop("translations"));
        const granularity = prop("granularity");
        const formatter = prop("formatter");
        const locale = prop("locale");
        const allSegmentTypes = Object.keys(allSegments);
        return Array.from({ length: computed("groupCount") }, (_, i) => {
          const displayValue = displayValues[i] ?? new IncompleteDate(placeholderValue.calendar, resolvedHourCycle(formatter));
          const committedValue = value?.[i];
          const displayDate = committedValue && displayValue.isComplete(allSegmentTypes) ? displayValue.toValue(committedValue) : displayValue.toValue(placeholderValue);
          const showEra = displayValue.era === "BC" && displayValue.calendar.identifier === "gregory";
          const segmentFormatter = showEra ? new $12a3c853105e5a70$export$ad991b66133851cf(locale, {
            ...formatter.resolvedOptions(),
            era: "short"
          }) : formatter;
          return processSegments({
            dateValue: toFormatterDate(displayDate, segmentFormatter),
            displayValue,
            formatter: segmentFormatter,
            locale,
            translations,
            granularity
          });
        });
      }
    )
  },
  watch({ track, context, prop, action }) {
    track([() => context.hash("value")], () => {
      action(["syncDisplayValues"]);
    });
    track([() => resolvedHourCycle(prop("formatter"))], () => {
      action(["syncDisplayValueHourCycle"]);
    });
    track([() => context.get("activeSegmentIndex")], () => {
      action(["focusActiveSegment"]);
    });
    track([() => prop("placeholderValue")?.toString()], () => {
      action(["syncPlaceholderProp"]);
    });
    track([() => prop("defaultPlaceholderValue")?.toString()], () => {
      action(["syncDefaultPlaceholderValue"]);
    });
  },
  on: {
    "VALUE.SET": {
      actions: ["setDateValue"]
    },
    "VALUE.CLEAR": {
      actions: ["clearDateValue", "clearDisplayValues", "clearEnteredKeys"]
    }
  },
  states: {
    idle: {
      on: {
        "SEGMENT.FOCUS": {
          target: "focused",
          actions: ["setActiveSegmentIndex", "invokeOnFocus"]
        }
      }
    },
    focused: {
      on: {
        "SEGMENT.FOCUS": [
          {
            // DOM focus catching up to an auto-advance must not discard keys already typed into it
            guard: "isActiveSegmentFocus",
            actions: ["setActiveSegmentIndex"]
          },
          {
            actions: ["setActiveSegmentIndex", "clearEnteredKeys"]
          }
        ],
        "SEGMENT.BLUR": {
          target: "idle",
          actions: ["confirmPlaceholder", "clearEnteredKeys", "invokeOnBlur"]
        },
        "SEGMENT.INPUT": {
          actions: ["setSegmentValue", "announceSegmentValue"]
        },
        "SEGMENT.ADJUST": {
          actions: ["invokeOnSegmentAdjust", "clearEnteredKeys", "announceSegmentValue"]
        },
        "SEGMENT.ARROW_LEFT": {
          actions: ["setPreviousActiveSegmentIndex", "clearEnteredKeys"]
        },
        "SEGMENT.ARROW_RIGHT": {
          actions: ["setNextActiveSegmentIndex", "clearEnteredKeys"]
        },
        "SEGMENT.BACKSPACE": [
          {
            guard: "isActiveSegmentPlaceholder",
            actions: ["setPreviousActiveSegmentIndex", "clearEnteredKeys"]
          },
          {
            actions: ["clearSegmentValue", "announceSegmentValue"]
          }
        ],
        "SEGMENT.HOME": {
          actions: ["setSegmentToLowestValue", "clearEnteredKeys", "announceSegmentValue"]
        },
        "SEGMENT.END": {
          actions: ["setSegmentToHighestValue", "clearEnteredKeys", "announceSegmentValue"]
        },
        "SEGMENT.PASTE": {
          actions: ["setPastedValue", "clearEnteredKeys"]
        }
      }
    }
  },
  implementations: {
    effects: {
      setupLiveRegion({ scope, refs }) {
        const liveRegion = createLiveRegion({
          level: "assertive",
          document: scope.getDoc()
        });
        refs.set("announcer", liveRegion);
        return () => liveRegion.destroy();
      }
    },
    guards: {
      isActiveSegmentFocus: ({ context, event }) => {
        const sameGroup = event.dateIndex == null || event.dateIndex === context.get("activeIndex");
        return sameGroup && event.segmentIndex === context.get("activeSegmentIndex");
      },
      isActiveSegmentPlaceholder: (ctx) => {
        const hasEnteredKeys = ctx.context.get("enteredKeys") !== "";
        if (hasEnteredKeys) return false;
        return getActiveSegment(ctx)?.isPlaceholder === true;
      }
    },
    actions: {
      invokeOnFocus({ prop }) {
        prop("onFocusChange")?.({ focused: true });
      },
      invokeOnBlur({ prop }) {
        prop("onFocusChange")?.({ focused: false });
      },
      setActiveSegmentIndex({ context, event }) {
        if (event.dateIndex != null) {
          context.set("activeIndex", event.dateIndex);
        }
        context.set("activeSegmentIndex", event.segmentIndex);
      },
      clearDisplayValues({ context, prop, computed }) {
        const hourCycle = resolvedHourCycle(prop("formatter"));
        const placeholderValue = context.get("placeholderValue");
        context.set(
          "displayValues",
          Array.from(
            { length: computed("groupCount") },
            () => new IncompleteDate(placeholderValue.calendar, hourCycle)
          )
        );
      },
      clearEnteredKeys({ context }) {
        context.set("enteredKeys", "");
      },
      setPreviousActiveSegmentIndex(ctx) {
        goToPreviousSegment(ctx);
      },
      setNextActiveSegmentIndex(ctx) {
        goToNextSegment(ctx);
      },
      focusActiveSegment({ scope, context }) {
        raf(() => {
          const segmentEls = getSegmentEls(scope);
          const activeSegmentEl = segmentEls[context.get("activeSegmentIndex")];
          activeSegmentEl?.focus({ preventScroll: true });
        });
      },
      clearSegmentValue(params) {
        const { context, prop, event } = params;
        const index = context.get("activeIndex");
        const allSegments = prop("allSegments");
        const allSegmentTypes = Object.keys(allSegments);
        const placeholderValue = context.get("placeholderValue");
        const segment = getActiveSegment(params) ?? event.segment;
        const type = segment.type;
        let displayValue = getActiveDisplayValue(params);
        if (type === "dayPeriod") {
          const cleared = displayValue.clear(type);
          setDisplayValue(params, index, cleared);
          if (cleared.isCleared(allSegmentTypes)) commitClear(params, index);
          return;
        }
        if (type === "hour") {
          const cleared = displayValue.clear(type);
          setDisplayValue(params, index, cleared);
          if (cleared.isCleared(allSegmentTypes)) commitClear(params, index);
          return;
        }
        const enteredKeys = context.get("enteredKeys");
        const textToUse = enteredKeys !== "" ? enteredKeys : segment.text;
        const newValue = textToUse.slice(0, -1);
        if (newValue === "" || newValue === "0") {
          context.set("enteredKeys", "");
          const cleared = displayValue.clear(type);
          setDisplayValue(params, index, cleared);
          if (cleared.isCleared(allSegmentTypes)) commitClear(params, index);
        } else {
          context.set("enteredKeys", newValue);
          displayValue = displayValue.set(type, Number(newValue), placeholderValue);
          setDisplayValue(params, index, displayValue);
        }
      },
      invokeOnSegmentAdjust(params) {
        const { context, prop, event } = params;
        const { amount } = event;
        const segment = getActiveSegment(params) ?? event.segment;
        const type = segment.type;
        const index = context.get("activeIndex");
        const allSegments = prop("allSegments");
        const allSegmentTypes = Object.keys(allSegments);
        const placeholderValue = context.get("placeholderValue");
        const displaySegmentTypes = allSegmentTypes;
        const displayValue = getActiveDisplayValue(params);
        const next = displayValue.cycle(type, amount, placeholderValue, displaySegmentTypes);
        setDisplayValue(params, index, next);
        if (next.isComplete(allSegmentTypes)) {
          commitValue(params, index, next);
        }
      },
      setSegmentValue(params) {
        const { event, context, refs } = params;
        const { input } = event;
        const segment = getActiveSegment(params) ?? event.segment;
        refs.set("segmentToAnnounceIndex", context.get("activeSegmentIndex"));
        const index = context.get("activeIndex");
        const displayValue = updateSegmentValue(params, segment, input);
        const allSegmentTypes = Object.keys(params.prop("allSegments"));
        if (displayValue && displayValue.isComplete(allSegmentTypes) && context.get("enteredKeys") === "") {
          commitValue(params, index, displayValue);
        }
      },
      setSegmentToLowestValue(params) {
        const { event, context, prop } = params;
        const segment = getActiveSegment(params) ?? event.segment;
        const index = context.get("activeIndex");
        const allSegmentTypes = Object.keys(prop("allSegments"));
        const placeholderValue = context.get("placeholderValue");
        if (segment.minValue == null) return;
        const displayValue = getActiveDisplayValue(params).set(
          segment.type,
          segment.minValue,
          placeholderValue
        );
        setDisplayValue(params, index, displayValue);
        if (displayValue.isComplete(allSegmentTypes)) commitValue(params, index, displayValue);
      },
      setSegmentToHighestValue(params) {
        const { event, context, prop } = params;
        const segment = getActiveSegment(params) ?? event.segment;
        const index = context.get("activeIndex");
        const allSegmentTypes = Object.keys(prop("allSegments"));
        const placeholderValue = context.get("placeholderValue");
        if (segment.maxValue == null) return;
        const displayValue = getActiveDisplayValue(params).set(
          segment.type,
          segment.maxValue,
          placeholderValue
        );
        setDisplayValue(params, index, displayValue);
        if (displayValue.isComplete(allSegmentTypes)) commitValue(params, index, displayValue);
      },
      setDateValue({ context, event, prop }) {
        if (!Array.isArray(event.value)) return;
        const value = event.value.map((date) => constrainSegments(date, prop("min"), prop("max")));
        context.set("value", value);
      },
      clearDateValue({ context }) {
        context.set("value", []);
      },
      setPastedValue({ context, event, prop }) {
        try {
          const parsed = parse(event.value);
          const constrained = constrainSegments(parsed, prop("min"), prop("max"));
          const index = context.get("activeIndex");
          const values = Array.from(context.get("value"));
          values[index] = constrained;
          context.set("value", values);
        } catch {
        }
      },
      syncDisplayValues({ context, prop, computed }) {
        const value = context.get("value");
        const hourCycle = resolvedHourCycle(prop("formatter"));
        const placeholderValue = context.get("placeholderValue");
        context.set(
          "displayValues",
          initDisplayValues(value?.length ? value : void 0, placeholderValue, hourCycle, computed("groupCount"))
        );
      },
      syncDisplayValueHourCycle({ context, prop }) {
        const hourCycle = resolvedHourCycle(prop("formatter"));
        const dvs = context.get("displayValues");
        context.set(
          "displayValues",
          dvs.map((dv) => dv.withHourCycle(hourCycle))
        );
      },
      syncDefaultPlaceholderValue({ prop, context }) {
        if (prop("placeholderValue") != null) return;
        const defaultPlaceholder = prop("defaultPlaceholderValue");
        if (!defaultPlaceholder) return;
        context.set("placeholderValue", defaultPlaceholder);
      },
      syncPlaceholderProp({ prop, context, computed }) {
        const propValue = prop("placeholderValue");
        if (propValue) {
          context.set("placeholderValue", propValue);
          const value = context.get("value");
          if (value?.length) {
            const hourCycle = resolvedHourCycle(prop("formatter"));
            context.set("displayValues", initDisplayValues(value, propValue, hourCycle, computed("groupCount")));
          }
        }
      },
      announceSegmentValue({ refs, computed, context }) {
        const announcer = refs.get("announcer");
        if (!announcer) return;
        const index = context.get("activeIndex");
        const activeSegmentIndex = context.get("activeSegmentIndex");
        const segmentIndexToUse = refs.get("segmentToAnnounceIndex") ?? activeSegmentIndex;
        refs.set("segmentToAnnounceIndex", null);
        const allSegments = computed("segments");
        const segment = allSegments[index]?.[segmentIndexToUse - getGroupOffset(allSegments, index)];
        if (!segment || segment.type === "literal") return;
        const valueText = segment.isPlaceholder ? "Empty" : segment.text;
        announcer.announce(`${getSegmentLabel(segment.type)}, ${valueText}`);
      },
      // On blur, if only dayPeriod is unfilled, auto-fill it and commit the value.
      // Also commit any complete display values that were deferred during partial typing.
      confirmPlaceholder(params) {
        const { context, prop, computed } = params;
        const allSegments = prop("allSegments");
        const allSegmentTypes = Object.keys(allSegments);
        const dateCount = computed("groupCount");
        const placeholderValue = context.get("placeholderValue");
        let values = Array.from(context.get("value"));
        let shouldUpdateValue = false;
        for (let i = 0; i < dateCount; i++) {
          const displayValue = context.get("displayValues")[i];
          if (!displayValue) continue;
          const allExceptDayPeriod = allSegmentTypes.filter((s) => s !== "dayPeriod");
          if (allSegments.dayPeriod && displayValue.isComplete(allExceptDayPeriod) && displayValue.dayPeriod == null) {
            const filled = displayValue.set(
              "dayPeriod",
              placeholderValue && "hour" in placeholderValue ? placeholderValue.hour >= 12 ? 1 : 0 : 0,
              placeholderValue
            );
            setDisplayValue(params, i, filled);
            values[i] = filled.toValue(placeholderValue);
            shouldUpdateValue = true;
          } else if (displayValue.isComplete(allSegmentTypes)) {
            values[i] = displayValue.toValue(placeholderValue);
            shouldUpdateValue = true;
          }
        }
        const min = prop("min");
        const max = prop("max");
        if ((min || max) && values.length > 0) {
          values = values.map((d) => constrainSegments(d, min, max));
          shouldUpdateValue = true;
        }
        if (shouldUpdateValue) {
          context.set("value", values);
        }
      }
    }
  }
});
function commitValue(params, index, displayValue) {
  const { context } = params;
  const placeholderValue = context.get("placeholderValue");
  const date = displayValue.toValue(placeholderValue);
  const values = Array.from(context.get("value"));
  values[index] = date;
  context.set("value", values);
}
function commitClear(params, index) {
  const { context } = params;
  const values = context.get("value");
  if (index < values.length) {
    context.set("value", values.slice(0, index));
  }
}
function toTargetCalendar(date, calendar) {
  if (!calendar) return date;
  if (date.calendar.identifier === calendar.identifier) return date;
  return $d07e34cce18680fd$export$b4a036af3fc0b032(date, calendar);
}
function resolveCalendar(locale, createCalendar) {
  if (!createCalendar) return void 0;
  const calendarId = new Intl.DateTimeFormat(locale).resolvedOptions().calendar;
  if (calendarId === "gregory" || calendarId === "iso8601") return void 0;
  return createCalendar(calendarId);
}

// components/date-input.ts
var DateInput = class extends Component {
  initMachine(props) {
    return new VanillaMachine(machine, props);
  }
  initApi() {
    return this.zagConnect(connect);
  }
  render() {
    const root = this.el.querySelector('[data-scope="date-input"][data-part="root"]') ?? this.el;
    this.spreadProps(root, this.api.getRootProps());
    const control = this.el.querySelector(
      '[data-scope="date-input"][data-part="control"]'
    );
    if (control) this.spreadProps(control, this.api.getControlProps());
    let group = this.el.querySelector(
      '[data-scope="date-input"][data-part="segment-group"]'
    );
    if (!group && control) {
      group = document.createElement("div");
      group.dataset.scope = "date-input";
      group.dataset.part = "segment-group";
      control.prepend(group);
    }
    if (group) {
      this.spreadProps(group, this.api.getSegmentGroupProps());
      const segments = this.api.getSegments();
      const existing = Array.from(
        group.querySelectorAll('[data-scope="date-input"][data-part="segment"]')
      );
      segments.forEach((segment, i) => {
        let node = existing[i];
        if (!node) {
          node = document.createElement("span");
          node.dataset.scope = "date-input";
          node.dataset.part = "segment";
          group.appendChild(node);
        }
        node.dataset.type = segment.type;
        node.textContent = segment.text;
        this.spreadProps(node, this.api.getSegmentProps({ segment, index: 0 }));
      });
      existing.slice(segments.length).forEach((node) => node.remove());
    }
    const hidden = this.el.querySelector(
      '[data-scope="date-input"][data-part="hidden-input"]'
    );
    if (hidden) this.spreadProps(hidden, this.api.getHiddenInputProps());
  }
};

// hooks/date-input.ts
function dateInputProps(el, hook) {
  const onValueChange = (details) => {
    const eventName = getString(el, "onValueChange");
    if (eventName && canPushEvent(hook.liveSocket)) {
      hook.pushEvent(eventName, { id: el.id, value: details.valueAsString });
    }
    const client = getString(el, "onValueChangeClient");
    if (client) {
      el.dispatchEvent(
        new CustomEvent(client, {
          bubbles: true,
          detail: { id: el.id, value: details.valueAsString }
        })
      );
    }
  };
  return {
    id: el.id,
    dir: getDir(el),
    locale: getString(el, "locale"),
    name: getString(el, "name"),
    disabled: getBoolean(el, "disabled"),
    readOnly: getBoolean(el, "readonly"),
    required: getBoolean(el, "required"),
    invalid: getBoolean(el, "invalid"),
    granularity: getString(el, "granularity"),
    onValueChange
  };
}
var DateInputHook = createZagLiveHook({
  key: "date-input",
  mount(hook) {
    return new DateInput(hook.el, dateInputProps(hook.el, hook));
  },
  update(hook, inst) {
    inst.updateProps(dateInputProps(hook.el, hook));
  }
});
export {
  DateInputHook as DateInput
};
