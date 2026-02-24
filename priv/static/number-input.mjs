import {
  Component,
  MAX_Z_INDEX,
  VanillaMachine,
  addDomEvent,
  ariaAttr,
  callAll,
  clampValue,
  createAnatomy,
  createProps,
  createSplitProps,
  dataAttr,
  decrementValue,
  getBoolean,
  getEventPoint,
  getEventStep,
  getNumber,
  getString,
  getWindow,
  incrementValue,
  isComposingEvent,
  isLeftClick,
  isModifierKey,
  isSafari,
  isValueAtMax,
  isValueAtMin,
  isValueWithinRange,
  memo,
  normalizeProps,
  observeAttributes,
  raf,
  requestPointerLock,
  roundToDpr,
  setCaretToEnd,
  setElementValue,
  setup,
  trackFormControl,
  wrap
} from "./chunk-PLUM2DEK.mjs";

// ../node_modules/.pnpm/@internationalized+number@3.6.5/node_modules/@internationalized/number/dist/NumberFormatter.mjs
var $488c6ddbf4ef74c2$var$formatterCache = /* @__PURE__ */ new Map();
var $488c6ddbf4ef74c2$var$supportsSignDisplay = false;
try {
  $488c6ddbf4ef74c2$var$supportsSignDisplay = new Intl.NumberFormat("de-DE", {
    signDisplay: "exceptZero"
  }).resolvedOptions().signDisplay === "exceptZero";
} catch {
}
var $488c6ddbf4ef74c2$var$supportsUnit = false;
try {
  $488c6ddbf4ef74c2$var$supportsUnit = new Intl.NumberFormat("de-DE", {
    style: "unit",
    unit: "degree"
  }).resolvedOptions().style === "unit";
} catch {
}
var $488c6ddbf4ef74c2$var$UNITS = {
  degree: {
    narrow: {
      default: "\xB0",
      "ja-JP": " \u5EA6",
      "zh-TW": "\u5EA6",
      "sl-SI": " \xB0"
    }
  }
};
var $488c6ddbf4ef74c2$export$cc77c4ff7e8673c5 = class {
  /** Formats a number value as a string, according to the locale and options provided to the constructor. */
  format(value) {
    let res = "";
    if (!$488c6ddbf4ef74c2$var$supportsSignDisplay && this.options.signDisplay != null) res = $488c6ddbf4ef74c2$export$711b50b3c525e0f2(this.numberFormatter, this.options.signDisplay, value);
    else res = this.numberFormatter.format(value);
    if (this.options.style === "unit" && !$488c6ddbf4ef74c2$var$supportsUnit) {
      var _UNITS_unit;
      let { unit, unitDisplay = "short", locale } = this.resolvedOptions();
      if (!unit) return res;
      let values = (_UNITS_unit = $488c6ddbf4ef74c2$var$UNITS[unit]) === null || _UNITS_unit === void 0 ? void 0 : _UNITS_unit[unitDisplay];
      res += values[locale] || values.default;
    }
    return res;
  }
  /** Formats a number to an array of parts such as separators, digits, punctuation, and more. */
  formatToParts(value) {
    return this.numberFormatter.formatToParts(value);
  }
  /** Formats a number range as a string. */
  formatRange(start, end) {
    if (typeof this.numberFormatter.formatRange === "function") return this.numberFormatter.formatRange(start, end);
    if (end < start) throw new RangeError("End date must be >= start date");
    return `${this.format(start)} \u2013 ${this.format(end)}`;
  }
  /** Formats a number range as an array of parts. */
  formatRangeToParts(start, end) {
    if (typeof this.numberFormatter.formatRangeToParts === "function") return this.numberFormatter.formatRangeToParts(start, end);
    if (end < start) throw new RangeError("End date must be >= start date");
    let startParts = this.numberFormatter.formatToParts(start);
    let endParts = this.numberFormatter.formatToParts(end);
    return [
      ...startParts.map((p) => ({
        ...p,
        source: "startRange"
      })),
      {
        type: "literal",
        value: " \u2013 ",
        source: "shared"
      },
      ...endParts.map((p) => ({
        ...p,
        source: "endRange"
      }))
    ];
  }
  /** Returns the resolved formatting options based on the values passed to the constructor. */
  resolvedOptions() {
    let options = this.numberFormatter.resolvedOptions();
    if (!$488c6ddbf4ef74c2$var$supportsSignDisplay && this.options.signDisplay != null) options = {
      ...options,
      signDisplay: this.options.signDisplay
    };
    if (!$488c6ddbf4ef74c2$var$supportsUnit && this.options.style === "unit") options = {
      ...options,
      style: "unit",
      unit: this.options.unit,
      unitDisplay: this.options.unitDisplay
    };
    return options;
  }
  constructor(locale, options = {}) {
    this.numberFormatter = $488c6ddbf4ef74c2$var$getCachedNumberFormatter(locale, options);
    this.options = options;
  }
};
function $488c6ddbf4ef74c2$var$getCachedNumberFormatter(locale, options = {}) {
  let { numberingSystem } = options;
  if (numberingSystem && locale.includes("-nu-")) {
    if (!locale.includes("-u-")) locale += "-u-";
    locale += `-nu-${numberingSystem}`;
  }
  if (options.style === "unit" && !$488c6ddbf4ef74c2$var$supportsUnit) {
    var _UNITS_unit;
    let { unit, unitDisplay = "short" } = options;
    if (!unit) throw new Error('unit option must be provided with style: "unit"');
    if (!((_UNITS_unit = $488c6ddbf4ef74c2$var$UNITS[unit]) === null || _UNITS_unit === void 0 ? void 0 : _UNITS_unit[unitDisplay])) throw new Error(`Unsupported unit ${unit} with unitDisplay = ${unitDisplay}`);
    options = {
      ...options,
      style: "decimal"
    };
  }
  let cacheKey = locale + (options ? Object.entries(options).sort((a, b) => a[0] < b[0] ? -1 : 1).join() : "");
  if ($488c6ddbf4ef74c2$var$formatterCache.has(cacheKey)) return $488c6ddbf4ef74c2$var$formatterCache.get(cacheKey);
  let numberFormatter = new Intl.NumberFormat(locale, options);
  $488c6ddbf4ef74c2$var$formatterCache.set(cacheKey, numberFormatter);
  return numberFormatter;
}
function $488c6ddbf4ef74c2$export$711b50b3c525e0f2(numberFormat, signDisplay, num) {
  if (signDisplay === "auto") return numberFormat.format(num);
  else if (signDisplay === "never") return numberFormat.format(Math.abs(num));
  else {
    let needsPositiveSign = false;
    if (signDisplay === "always") needsPositiveSign = num > 0 || Object.is(num, 0);
    else if (signDisplay === "exceptZero") {
      if (Object.is(num, -0) || Object.is(num, 0)) num = Math.abs(num);
      else needsPositiveSign = num > 0;
    }
    if (needsPositiveSign) {
      let negative = numberFormat.format(-num);
      let noSign = numberFormat.format(num);
      let minus = negative.replace(noSign, "").replace(/\u200e|\u061C/, "");
      if ([
        ...minus
      ].length !== 1) console.warn("@react-aria/i18n polyfill for NumberFormat signDisplay: Unsupported case");
      let positive = negative.replace(noSign, "!!!").replace(minus, "+").replace("!!!", noSign);
      return positive;
    } else return numberFormat.format(num);
  }
}

// ../node_modules/.pnpm/@internationalized+number@3.6.5/node_modules/@internationalized/number/dist/NumberParser.mjs
var $6c7bd7858deea686$var$CURRENCY_SIGN_REGEX = new RegExp("^.*\\(.*\\).*$");
var $6c7bd7858deea686$var$NUMBERING_SYSTEMS = [
  "latn",
  "arab",
  "hanidec",
  "deva",
  "beng",
  "fullwide"
];
var $6c7bd7858deea686$export$cd11ab140839f11d = class {
  /**
  * Parses the given string to a number. Returns NaN if a valid number could not be parsed.
  */
  parse(value) {
    return $6c7bd7858deea686$var$getNumberParserImpl(this.locale, this.options, value).parse(value);
  }
  /**
  * Returns whether the given string could potentially be a valid number. This should be used to
  * validate user input as the user types. If a `minValue` or `maxValue` is provided, the validity
  * of the minus/plus sign characters can be checked.
  */
  isValidPartialNumber(value, minValue, maxValue) {
    return $6c7bd7858deea686$var$getNumberParserImpl(this.locale, this.options, value).isValidPartialNumber(value, minValue, maxValue);
  }
  /**
  * Returns a numbering system for which the given string is valid in the current locale.
  * If no numbering system could be detected, the default numbering system for the current
  * locale is returned.
  */
  getNumberingSystem(value) {
    return $6c7bd7858deea686$var$getNumberParserImpl(this.locale, this.options, value).options.numberingSystem;
  }
  constructor(locale, options = {}) {
    this.locale = locale;
    this.options = options;
  }
};
var $6c7bd7858deea686$var$numberParserCache = /* @__PURE__ */ new Map();
function $6c7bd7858deea686$var$getNumberParserImpl(locale, options, value) {
  let defaultParser = $6c7bd7858deea686$var$getCachedNumberParser(locale, options);
  if (!locale.includes("-nu-") && !defaultParser.isValidPartialNumber(value)) {
    for (let numberingSystem of $6c7bd7858deea686$var$NUMBERING_SYSTEMS) if (numberingSystem !== defaultParser.options.numberingSystem) {
      let parser = $6c7bd7858deea686$var$getCachedNumberParser(locale + (locale.includes("-u-") ? "-nu-" : "-u-nu-") + numberingSystem, options);
      if (parser.isValidPartialNumber(value)) return parser;
    }
  }
  return defaultParser;
}
function $6c7bd7858deea686$var$getCachedNumberParser(locale, options) {
  let cacheKey = locale + (options ? Object.entries(options).sort((a, b) => a[0] < b[0] ? -1 : 1).join() : "");
  let parser = $6c7bd7858deea686$var$numberParserCache.get(cacheKey);
  if (!parser) {
    parser = new $6c7bd7858deea686$var$NumberParserImpl(locale, options);
    $6c7bd7858deea686$var$numberParserCache.set(cacheKey, parser);
  }
  return parser;
}
var $6c7bd7858deea686$var$NumberParserImpl = class {
  parse(value) {
    let fullySanitizedValue = this.sanitize(value);
    if (this.symbols.group)
      fullySanitizedValue = $6c7bd7858deea686$var$replaceAll(fullySanitizedValue, this.symbols.group, "");
    if (this.symbols.decimal) fullySanitizedValue = fullySanitizedValue.replace(this.symbols.decimal, ".");
    if (this.symbols.minusSign) fullySanitizedValue = fullySanitizedValue.replace(this.symbols.minusSign, "-");
    fullySanitizedValue = fullySanitizedValue.replace(this.symbols.numeral, this.symbols.index);
    if (this.options.style === "percent") {
      let isNegative = fullySanitizedValue.indexOf("-");
      fullySanitizedValue = fullySanitizedValue.replace("-", "");
      fullySanitizedValue = fullySanitizedValue.replace("+", "");
      let index = fullySanitizedValue.indexOf(".");
      if (index === -1) index = fullySanitizedValue.length;
      fullySanitizedValue = fullySanitizedValue.replace(".", "");
      if (index - 2 === 0) fullySanitizedValue = `0.${fullySanitizedValue}`;
      else if (index - 2 === -1) fullySanitizedValue = `0.0${fullySanitizedValue}`;
      else if (index - 2 === -2) fullySanitizedValue = "0.00";
      else fullySanitizedValue = `${fullySanitizedValue.slice(0, index - 2)}.${fullySanitizedValue.slice(index - 2)}`;
      if (isNegative > -1) fullySanitizedValue = `-${fullySanitizedValue}`;
    }
    let newValue = fullySanitizedValue ? +fullySanitizedValue : NaN;
    if (isNaN(newValue)) return NaN;
    if (this.options.style === "percent") {
      var _this_options_minimumFractionDigits, _this_options_maximumFractionDigits;
      let options = {
        ...this.options,
        style: "decimal",
        minimumFractionDigits: Math.min(((_this_options_minimumFractionDigits = this.options.minimumFractionDigits) !== null && _this_options_minimumFractionDigits !== void 0 ? _this_options_minimumFractionDigits : 0) + 2, 20),
        maximumFractionDigits: Math.min(((_this_options_maximumFractionDigits = this.options.maximumFractionDigits) !== null && _this_options_maximumFractionDigits !== void 0 ? _this_options_maximumFractionDigits : 0) + 2, 20)
      };
      return new $6c7bd7858deea686$export$cd11ab140839f11d(this.locale, options).parse(new (0, $488c6ddbf4ef74c2$export$cc77c4ff7e8673c5)(this.locale, options).format(newValue));
    }
    if (this.options.currencySign === "accounting" && $6c7bd7858deea686$var$CURRENCY_SIGN_REGEX.test(value)) newValue = -1 * newValue;
    return newValue;
  }
  sanitize(value) {
    value = value.replace(this.symbols.literals, "");
    if (this.symbols.minusSign) value = value.replace("-", this.symbols.minusSign);
    if (this.options.numberingSystem === "arab") {
      if (this.symbols.decimal) {
        value = value.replace(",", this.symbols.decimal);
        value = value.replace(String.fromCharCode(1548), this.symbols.decimal);
      }
      if (this.symbols.group) value = $6c7bd7858deea686$var$replaceAll(value, ".", this.symbols.group);
    }
    if (this.symbols.group === "\u2019" && value.includes("'")) value = $6c7bd7858deea686$var$replaceAll(value, "'", this.symbols.group);
    if (this.options.locale === "fr-FR" && this.symbols.group) {
      value = $6c7bd7858deea686$var$replaceAll(value, " ", this.symbols.group);
      value = $6c7bd7858deea686$var$replaceAll(value, /\u00A0/g, this.symbols.group);
    }
    return value;
  }
  isValidPartialNumber(value, minValue = -Infinity, maxValue = Infinity) {
    value = this.sanitize(value);
    if (this.symbols.minusSign && value.startsWith(this.symbols.minusSign) && minValue < 0) value = value.slice(this.symbols.minusSign.length);
    else if (this.symbols.plusSign && value.startsWith(this.symbols.plusSign) && maxValue > 0) value = value.slice(this.symbols.plusSign.length);
    if (this.symbols.group && value.startsWith(this.symbols.group)) return false;
    if (this.symbols.decimal && value.indexOf(this.symbols.decimal) > -1 && this.options.maximumFractionDigits === 0) return false;
    if (this.symbols.group) value = $6c7bd7858deea686$var$replaceAll(value, this.symbols.group, "");
    value = value.replace(this.symbols.numeral, "");
    if (this.symbols.decimal) value = value.replace(this.symbols.decimal, "");
    return value.length === 0;
  }
  constructor(locale, options = {}) {
    this.locale = locale;
    if (options.roundingIncrement !== 1 && options.roundingIncrement != null) {
      if (options.maximumFractionDigits == null && options.minimumFractionDigits == null) {
        options.maximumFractionDigits = 0;
        options.minimumFractionDigits = 0;
      } else if (options.maximumFractionDigits == null) options.maximumFractionDigits = options.minimumFractionDigits;
      else if (options.minimumFractionDigits == null) options.minimumFractionDigits = options.maximumFractionDigits;
    }
    this.formatter = new Intl.NumberFormat(locale, options);
    this.options = this.formatter.resolvedOptions();
    this.symbols = $6c7bd7858deea686$var$getSymbols(locale, this.formatter, this.options, options);
    var _this_options_minimumFractionDigits, _this_options_maximumFractionDigits;
    if (this.options.style === "percent" && (((_this_options_minimumFractionDigits = this.options.minimumFractionDigits) !== null && _this_options_minimumFractionDigits !== void 0 ? _this_options_minimumFractionDigits : 0) > 18 || ((_this_options_maximumFractionDigits = this.options.maximumFractionDigits) !== null && _this_options_maximumFractionDigits !== void 0 ? _this_options_maximumFractionDigits : 0) > 18)) console.warn("NumberParser cannot handle percentages with greater than 18 decimal places, please reduce the number in your options.");
  }
};
var $6c7bd7858deea686$var$nonLiteralParts = /* @__PURE__ */ new Set([
  "decimal",
  "fraction",
  "integer",
  "minusSign",
  "plusSign",
  "group"
]);
var $6c7bd7858deea686$var$pluralNumbers = [
  0,
  4,
  2,
  1,
  11,
  20,
  3,
  7,
  100,
  21,
  0.1,
  1.1
];
function $6c7bd7858deea686$var$getSymbols(locale, formatter, intlOptions, originalOptions) {
  var _allParts_find, _posAllParts_find, _decimalParts_find, _allParts_find1;
  let symbolFormatter = new Intl.NumberFormat(locale, {
    ...intlOptions,
    // Resets so we get the full range of symbols
    minimumSignificantDigits: 1,
    maximumSignificantDigits: 21,
    roundingIncrement: 1,
    roundingPriority: "auto",
    roundingMode: "halfExpand"
  });
  let allParts = symbolFormatter.formatToParts(-10000.111);
  let posAllParts = symbolFormatter.formatToParts(10000.111);
  let pluralParts = $6c7bd7858deea686$var$pluralNumbers.map((n) => symbolFormatter.formatToParts(n));
  var _allParts_find_value;
  let minusSign = (_allParts_find_value = (_allParts_find = allParts.find((p) => p.type === "minusSign")) === null || _allParts_find === void 0 ? void 0 : _allParts_find.value) !== null && _allParts_find_value !== void 0 ? _allParts_find_value : "-";
  let plusSign = (_posAllParts_find = posAllParts.find((p) => p.type === "plusSign")) === null || _posAllParts_find === void 0 ? void 0 : _posAllParts_find.value;
  if (!plusSign && ((originalOptions === null || originalOptions === void 0 ? void 0 : originalOptions.signDisplay) === "exceptZero" || (originalOptions === null || originalOptions === void 0 ? void 0 : originalOptions.signDisplay) === "always")) plusSign = "+";
  let decimalParts = new Intl.NumberFormat(locale, {
    ...intlOptions,
    minimumFractionDigits: 2,
    maximumFractionDigits: 2
  }).formatToParts(1e-3);
  let decimal = (_decimalParts_find = decimalParts.find((p) => p.type === "decimal")) === null || _decimalParts_find === void 0 ? void 0 : _decimalParts_find.value;
  let group = (_allParts_find1 = allParts.find((p) => p.type === "group")) === null || _allParts_find1 === void 0 ? void 0 : _allParts_find1.value;
  let allPartsLiterals = allParts.filter((p) => !$6c7bd7858deea686$var$nonLiteralParts.has(p.type)).map((p) => $6c7bd7858deea686$var$escapeRegex(p.value));
  let pluralPartsLiterals = pluralParts.flatMap((p) => p.filter((p2) => !$6c7bd7858deea686$var$nonLiteralParts.has(p2.type)).map((p2) => $6c7bd7858deea686$var$escapeRegex(p2.value)));
  let sortedLiterals = [
    .../* @__PURE__ */ new Set([
      ...allPartsLiterals,
      ...pluralPartsLiterals
    ])
  ].sort((a, b) => b.length - a.length);
  let literals = sortedLiterals.length === 0 ? new RegExp("[\\p{White_Space}]", "gu") : new RegExp(`${sortedLiterals.join("|")}|[\\p{White_Space}]`, "gu");
  let numerals = [
    ...new Intl.NumberFormat(intlOptions.locale, {
      useGrouping: false
    }).format(9876543210)
  ].reverse();
  let indexes = new Map(numerals.map((d, i) => [
    d,
    i
  ]));
  let numeral = new RegExp(`[${numerals.join("")}]`, "g");
  let index = (d) => String(indexes.get(d));
  return {
    minusSign,
    plusSign,
    decimal,
    group,
    literals,
    numeral,
    index
  };
}
function $6c7bd7858deea686$var$replaceAll(str, find, replace) {
  if (str.replaceAll) return str.replaceAll(find, replace);
  return str.split(find).join(replace);
}
function $6c7bd7858deea686$var$escapeRegex(string) {
  return string.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

// ../node_modules/.pnpm/@zag-js+number-input@1.34.1/node_modules/@zag-js/number-input/dist/index.mjs
var anatomy = createAnatomy("numberInput").parts(
  "root",
  "label",
  "input",
  "control",
  "valueText",
  "incrementTrigger",
  "decrementTrigger",
  "scrubber"
);
var parts = anatomy.build();
function recordCursor(inputEl, scope) {
  if (!inputEl || !scope.isActiveElement(inputEl)) return;
  try {
    const { selectionStart: start, selectionEnd: end, value } = inputEl;
    if (start == null || end == null) return void 0;
    return { start, end, value };
  } catch {
    return void 0;
  }
}
function restoreCursor(inputEl, selection, scope) {
  if (!inputEl || !scope.isActiveElement(inputEl)) return;
  if (!selection) {
    const len = inputEl.value.length;
    inputEl.setSelectionRange(len, len);
    return;
  }
  try {
    const newValue = inputEl.value;
    const { start, end, value: oldValue } = selection;
    if (newValue === oldValue) {
      inputEl.setSelectionRange(start, end);
      return;
    }
    const newStart = getNextCursorPosition(oldValue, newValue, start);
    const newEnd = start === end ? newStart : getNextCursorPosition(oldValue, newValue, end);
    const clampedStart = Math.max(0, Math.min(newStart, newValue.length));
    const clampedEnd = Math.max(clampedStart, Math.min(newEnd, newValue.length));
    inputEl.setSelectionRange(clampedStart, clampedEnd);
  } catch {
    const len = inputEl.value.length;
    inputEl.setSelectionRange(len, len);
  }
}
function getNextCursorPosition(oldValue, newValue, oldPosition) {
  const beforeCursor = oldValue.slice(0, oldPosition);
  const afterCursor = oldValue.slice(oldPosition);
  let prefixLength = 0;
  const maxPrefixLength = Math.min(beforeCursor.length, newValue.length);
  for (let i = 0; i < maxPrefixLength; i++) {
    if (beforeCursor[i] === newValue[i]) {
      prefixLength = i + 1;
    } else {
      break;
    }
  }
  let suffixLength = 0;
  const maxSuffixLength = Math.min(afterCursor.length, newValue.length - prefixLength);
  for (let i = 0; i < maxSuffixLength; i++) {
    const oldIndex = afterCursor.length - 1 - i;
    const newIndex = newValue.length - 1 - i;
    if (afterCursor[oldIndex] === newValue[newIndex]) {
      suffixLength = i + 1;
    } else {
      break;
    }
  }
  if (beforeCursor.length > 0 && prefixLength >= beforeCursor.length) {
    return prefixLength;
  }
  if (suffixLength >= afterCursor.length) {
    return newValue.length - suffixLength;
  }
  if (prefixLength > 0) {
    return prefixLength;
  }
  if (suffixLength > 0) {
    return newValue.length - suffixLength;
  }
  if (oldPosition === 0 && prefixLength === 0 && suffixLength === 0) {
    return newValue.length;
  }
  if (oldValue.length > 0) {
    const ratio = oldPosition / oldValue.length;
    return Math.round(ratio * newValue.length);
  }
  return newValue.length;
}
var getRootId = (ctx) => ctx.ids?.root ?? `number-input:${ctx.id}`;
var getInputId = (ctx) => ctx.ids?.input ?? `number-input:${ctx.id}:input`;
var getIncrementTriggerId = (ctx) => ctx.ids?.incrementTrigger ?? `number-input:${ctx.id}:inc`;
var getDecrementTriggerId = (ctx) => ctx.ids?.decrementTrigger ?? `number-input:${ctx.id}:dec`;
var getScrubberId = (ctx) => ctx.ids?.scrubber ?? `number-input:${ctx.id}:scrubber`;
var getCursorId = (ctx) => `number-input:${ctx.id}:cursor`;
var getLabelId = (ctx) => ctx.ids?.label ?? `number-input:${ctx.id}:label`;
var getInputEl = (ctx) => ctx.getById(getInputId(ctx));
var getIncrementTriggerEl = (ctx) => ctx.getById(getIncrementTriggerId(ctx));
var getDecrementTriggerEl = (ctx) => ctx.getById(getDecrementTriggerId(ctx));
var getCursorEl = (ctx) => ctx.getDoc().getElementById(getCursorId(ctx));
var getPressedTriggerEl = (ctx, hint) => {
  let btnEl = null;
  if (hint === "increment") {
    btnEl = getIncrementTriggerEl(ctx);
  }
  if (hint === "decrement") {
    btnEl = getDecrementTriggerEl(ctx);
  }
  return btnEl;
};
var setupVirtualCursor = (ctx, point) => {
  if (isSafari()) return;
  createVirtualCursor(ctx, point);
  return () => {
    getCursorEl(ctx)?.remove();
  };
};
var preventTextSelection = (ctx) => {
  const doc = ctx.getDoc();
  const html = doc.documentElement;
  const body = doc.body;
  body.style.pointerEvents = "none";
  html.style.userSelect = "none";
  html.style.cursor = "ew-resize";
  return () => {
    body.style.pointerEvents = "";
    html.style.userSelect = "";
    html.style.cursor = "";
    if (!html.style.length) {
      html.removeAttribute("style");
    }
    if (!body.style.length) {
      body.removeAttribute("style");
    }
  };
};
var getMousemoveValue = (ctx, opts) => {
  const { point, isRtl, event } = opts;
  const win = ctx.getWin();
  const x = roundToDpr(event.movementX, win.devicePixelRatio);
  const y = roundToDpr(event.movementY, win.devicePixelRatio);
  let hint = x > 0 ? "increment" : x < 0 ? "decrement" : null;
  if (isRtl && hint === "increment") hint = "decrement";
  if (isRtl && hint === "decrement") hint = "increment";
  const newPoint = { x: point.x + x, y: point.y + y };
  const width = win.innerWidth;
  const half = roundToDpr(7.5, win.devicePixelRatio);
  newPoint.x = wrap(newPoint.x + half, width) - half;
  return { hint, point: newPoint };
};
var createVirtualCursor = (ctx, point) => {
  const doc = ctx.getDoc();
  const el = doc.createElement("div");
  el.className = "scrubber--cursor";
  el.id = getCursorId(ctx);
  Object.assign(el.style, {
    width: "15px",
    height: "15px",
    position: "fixed",
    pointerEvents: "none",
    left: "0px",
    top: "0px",
    zIndex: MAX_Z_INDEX,
    transform: point ? `translate3d(${point.x}px, ${point.y}px, 0px)` : void 0,
    willChange: "transform"
  });
  el.innerHTML = `
      <svg width="46" height="15" style="left: -15.5px; position: absolute; top: 0; filter: drop-shadow(rgba(0, 0, 0, 0.4) 0px 1px 1.1px);">
        <g transform="translate(2 3)">
          <path fill-rule="evenodd" d="M 15 4.5L 15 2L 11.5 5.5L 15 9L 15 6.5L 31 6.5L 31 9L 34.5 5.5L 31 2L 31 4.5Z" style="stroke-width: 2px; stroke: white;"></path>
          <path fill-rule="evenodd" d="M 15 4.5L 15 2L 11.5 5.5L 15 9L 15 6.5L 31 6.5L 31 9L 34.5 5.5L 31 2L 31 4.5Z"></path>
        </g>
      </svg>`;
  doc.body.appendChild(el);
};
function connect(service, normalize) {
  const { state, send, prop, scope, computed } = service;
  const focused = state.hasTag("focus");
  const disabled = computed("isDisabled");
  const readOnly = !!prop("readOnly");
  const required = !!prop("required");
  const scrubbing = state.matches("scrubbing");
  const empty = computed("isValueEmpty");
  const invalid = prop("invalid") !== void 0 ? !!prop("invalid") : computed("isOutOfRange");
  const isIncrementDisabled = disabled || !computed("canIncrement") || readOnly;
  const isDecrementDisabled = disabled || !computed("canDecrement") || readOnly;
  const translations = prop("translations");
  return {
    focused,
    invalid,
    empty,
    value: computed("formattedValue"),
    valueAsNumber: computed("valueAsNumber"),
    setValue(value) {
      send({ type: "VALUE.SET", value });
    },
    clearValue() {
      send({ type: "VALUE.CLEAR" });
    },
    increment() {
      send({ type: "VALUE.INCREMENT" });
    },
    decrement() {
      send({ type: "VALUE.DECREMENT" });
    },
    setToMax() {
      send({ type: "VALUE.SET", value: prop("max") });
    },
    setToMin() {
      send({ type: "VALUE.SET", value: prop("min") });
    },
    focus() {
      getInputEl(scope)?.focus();
    },
    getRootProps() {
      return normalize.element({
        id: getRootId(scope),
        ...parts.root.attrs,
        dir: prop("dir"),
        "data-disabled": dataAttr(disabled),
        "data-focus": dataAttr(focused),
        "data-invalid": dataAttr(invalid),
        "data-scrubbing": dataAttr(scrubbing)
      });
    },
    getLabelProps() {
      return normalize.label({
        ...parts.label.attrs,
        dir: prop("dir"),
        "data-disabled": dataAttr(disabled),
        "data-focus": dataAttr(focused),
        "data-invalid": dataAttr(invalid),
        "data-required": dataAttr(required),
        "data-scrubbing": dataAttr(scrubbing),
        id: getLabelId(scope),
        htmlFor: getInputId(scope),
        onClick() {
          raf(() => {
            setCaretToEnd(getInputEl(scope));
          });
        }
      });
    },
    getControlProps() {
      return normalize.element({
        ...parts.control.attrs,
        dir: prop("dir"),
        role: "group",
        "aria-disabled": disabled,
        "data-focus": dataAttr(focused),
        "data-disabled": dataAttr(disabled),
        "data-invalid": dataAttr(invalid),
        "data-scrubbing": dataAttr(scrubbing),
        "aria-invalid": ariaAttr(invalid)
      });
    },
    getValueTextProps() {
      return normalize.element({
        ...parts.valueText.attrs,
        dir: prop("dir"),
        "data-disabled": dataAttr(disabled),
        "data-invalid": dataAttr(invalid),
        "data-focus": dataAttr(focused),
        "data-scrubbing": dataAttr(scrubbing)
      });
    },
    getInputProps() {
      return normalize.input({
        ...parts.input.attrs,
        dir: prop("dir"),
        name: prop("name"),
        form: prop("form"),
        id: getInputId(scope),
        role: "spinbutton",
        defaultValue: computed("formattedValue"),
        pattern: prop("formatOptions") ? void 0 : prop("pattern"),
        inputMode: prop("inputMode"),
        "aria-invalid": ariaAttr(invalid),
        "data-invalid": dataAttr(invalid),
        disabled,
        "data-disabled": dataAttr(disabled),
        readOnly,
        required: prop("required"),
        autoComplete: "off",
        autoCorrect: "off",
        spellCheck: "false",
        type: "text",
        "aria-roledescription": "numberfield",
        "aria-valuemin": prop("min"),
        "aria-valuemax": prop("max"),
        "aria-valuenow": Number.isNaN(computed("valueAsNumber")) ? void 0 : computed("valueAsNumber"),
        "aria-valuetext": computed("valueText"),
        "data-scrubbing": dataAttr(scrubbing),
        onFocus() {
          send({ type: "INPUT.FOCUS" });
        },
        onBlur() {
          send({ type: "INPUT.BLUR" });
        },
        onInput(event) {
          const selection = recordCursor(event.currentTarget, scope);
          send({ type: "INPUT.CHANGE", target: event.currentTarget, hint: "set", selection });
        },
        onBeforeInput(event) {
          try {
            const { selectionStart, selectionEnd, value } = event.currentTarget;
            const nextValue = value.slice(0, selectionStart) + (event.data ?? "") + value.slice(selectionEnd);
            const isValid = computed("parser").isValidPartialNumber(nextValue);
            if (!isValid) {
              event.preventDefault();
            }
          } catch {
          }
        },
        onKeyDown(event) {
          if (event.defaultPrevented) return;
          if (readOnly) return;
          if (isComposingEvent(event)) return;
          const step = getEventStep(event) * prop("step");
          const keyMap = {
            ArrowUp() {
              send({ type: "INPUT.ARROW_UP", step });
              event.preventDefault();
            },
            ArrowDown() {
              send({ type: "INPUT.ARROW_DOWN", step });
              event.preventDefault();
            },
            Home() {
              if (isModifierKey(event)) return;
              send({ type: "INPUT.HOME" });
              event.preventDefault();
            },
            End() {
              if (isModifierKey(event)) return;
              send({ type: "INPUT.END" });
              event.preventDefault();
            },
            Enter(event2) {
              const selection = recordCursor(event2.currentTarget, scope);
              send({ type: "INPUT.ENTER", selection });
            }
          };
          const exec = keyMap[event.key];
          exec?.(event);
        }
      });
    },
    getDecrementTriggerProps() {
      return normalize.button({
        ...parts.decrementTrigger.attrs,
        dir: prop("dir"),
        id: getDecrementTriggerId(scope),
        disabled: isDecrementDisabled,
        "data-disabled": dataAttr(isDecrementDisabled),
        "aria-label": translations.decrementLabel,
        type: "button",
        tabIndex: -1,
        "aria-controls": getInputId(scope),
        "data-scrubbing": dataAttr(scrubbing),
        onPointerDown(event) {
          if (isDecrementDisabled) return;
          if (!isLeftClick(event)) return;
          send({ type: "TRIGGER.PRESS_DOWN", hint: "decrement", pointerType: event.pointerType });
          if (event.pointerType === "mouse") {
            event.preventDefault();
          }
          if (event.pointerType === "touch") {
            event.currentTarget?.focus({ preventScroll: true });
          }
        },
        onPointerUp(event) {
          send({ type: "TRIGGER.PRESS_UP", hint: "decrement", pointerType: event.pointerType });
        },
        onPointerLeave() {
          if (isDecrementDisabled) return;
          send({ type: "TRIGGER.PRESS_UP", hint: "decrement" });
        }
      });
    },
    getIncrementTriggerProps() {
      return normalize.button({
        ...parts.incrementTrigger.attrs,
        dir: prop("dir"),
        id: getIncrementTriggerId(scope),
        disabled: isIncrementDisabled,
        "data-disabled": dataAttr(isIncrementDisabled),
        "aria-label": translations.incrementLabel,
        type: "button",
        tabIndex: -1,
        "aria-controls": getInputId(scope),
        "data-scrubbing": dataAttr(scrubbing),
        onPointerDown(event) {
          if (isIncrementDisabled || !isLeftClick(event)) return;
          send({ type: "TRIGGER.PRESS_DOWN", hint: "increment", pointerType: event.pointerType });
          if (event.pointerType === "mouse") {
            event.preventDefault();
          }
          if (event.pointerType === "touch") {
            event.currentTarget?.focus({ preventScroll: true });
          }
        },
        onPointerUp(event) {
          send({ type: "TRIGGER.PRESS_UP", hint: "increment", pointerType: event.pointerType });
        },
        onPointerLeave(event) {
          send({ type: "TRIGGER.PRESS_UP", hint: "increment", pointerType: event.pointerType });
        }
      });
    },
    getScrubberProps() {
      return normalize.element({
        ...parts.scrubber.attrs,
        dir: prop("dir"),
        "data-disabled": dataAttr(disabled),
        id: getScrubberId(scope),
        role: "presentation",
        "data-scrubbing": dataAttr(scrubbing),
        onMouseDown(event) {
          if (disabled) return;
          if (!isLeftClick(event)) return;
          const point = getEventPoint(event);
          const win = getWindow(event.currentTarget);
          const dpr = win.devicePixelRatio;
          point.x = point.x - roundToDpr(7.5, dpr);
          point.y = point.y - roundToDpr(7.5, dpr);
          send({ type: "SCRUBBER.PRESS_DOWN", point });
          event.preventDefault();
          raf(() => {
            setCaretToEnd(getInputEl(scope));
          });
        },
        style: {
          cursor: disabled ? void 0 : "ew-resize"
        }
      });
    }
  };
}
var createFormatter = (locale, options = {}) => {
  return new Intl.NumberFormat(locale, options);
};
var createParser = (locale, options = {}) => {
  return new $6c7bd7858deea686$export$cd11ab140839f11d(locale, options);
};
var parseValue = (value, params) => {
  const { prop, computed } = params;
  if (!prop("formatOptions")) return parseFloat(value);
  if (value === "") return Number.NaN;
  return computed("parser").parse(value);
};
var formatValue = (value, params) => {
  const { prop, computed } = params;
  if (Number.isNaN(value)) return "";
  if (!prop("formatOptions")) return value.toString();
  return computed("formatter").format(value);
};
var getDefaultStep = (step, formatOptions) => {
  let defaultStep = step !== void 0 && !Number.isNaN(step) ? step : 1;
  if (formatOptions?.style === "percent" && (step === void 0 || Number.isNaN(step))) {
    defaultStep = 0.01;
  }
  return defaultStep;
};
var { choose, guards, createMachine } = setup();
var { not, and } = guards;
var machine = createMachine({
  props({ props: props2 }) {
    const step = getDefaultStep(props2.step, props2.formatOptions);
    return {
      dir: "ltr",
      locale: "en-US",
      focusInputOnChange: true,
      clampValueOnBlur: !props2.allowOverflow,
      allowOverflow: false,
      inputMode: "decimal",
      pattern: "-?[0-9]*(.[0-9]+)?",
      defaultValue: "",
      step,
      min: Number.MIN_SAFE_INTEGER,
      max: Number.MAX_SAFE_INTEGER,
      spinOnPress: true,
      ...props2,
      translations: {
        incrementLabel: "increment value",
        decrementLabel: "decrease value",
        ...props2.translations
      }
    };
  },
  initialState() {
    return "idle";
  },
  context({ prop, bindable, getComputed }) {
    return {
      value: bindable(() => ({
        defaultValue: prop("defaultValue"),
        value: prop("value"),
        onChange(value) {
          const computed = getComputed();
          const valueAsNumber = parseValue(value, { computed, prop });
          prop("onValueChange")?.({ value, valueAsNumber });
        }
      })),
      hint: bindable(() => ({ defaultValue: null })),
      scrubberCursorPoint: bindable(() => ({
        defaultValue: null,
        hash(value) {
          return value ? `x:${value.x}, y:${value.y}` : "";
        }
      })),
      fieldsetDisabled: bindable(() => ({ defaultValue: false }))
    };
  },
  computed: {
    isRtl: ({ prop }) => prop("dir") === "rtl",
    valueAsNumber: ({ context, computed, prop }) => parseValue(context.get("value"), { computed, prop }),
    formattedValue: ({ computed, prop }) => formatValue(computed("valueAsNumber"), { computed, prop }),
    isAtMin: ({ computed, prop }) => isValueAtMin(computed("valueAsNumber"), prop("min")),
    isAtMax: ({ computed, prop }) => isValueAtMax(computed("valueAsNumber"), prop("max")),
    isOutOfRange: ({ computed, prop }) => !isValueWithinRange(computed("valueAsNumber"), prop("min"), prop("max")),
    isValueEmpty: ({ context }) => context.get("value") === "",
    isDisabled: ({ prop, context }) => !!prop("disabled") || context.get("fieldsetDisabled"),
    canIncrement: ({ prop, computed }) => prop("allowOverflow") || !computed("isAtMax"),
    canDecrement: ({ prop, computed }) => prop("allowOverflow") || !computed("isAtMin"),
    valueText: ({ prop, context }) => prop("translations").valueText?.(context.get("value")),
    formatter: memo(
      ({ prop }) => [prop("locale"), prop("formatOptions")],
      ([locale, formatOptions]) => createFormatter(locale, formatOptions)
    ),
    parser: memo(
      ({ prop }) => [prop("locale"), prop("formatOptions")],
      ([locale, formatOptions]) => createParser(locale, formatOptions)
    )
  },
  watch({ track, action, context, computed, prop }) {
    track([() => context.get("value"), () => prop("locale"), () => JSON.stringify(prop("formatOptions"))], () => {
      action(["syncInputElement"]);
    });
    track([() => computed("isOutOfRange")], () => {
      action(["invokeOnInvalid"]);
    });
    track([() => context.hash("scrubberCursorPoint")], () => {
      action(["setVirtualCursorPosition"]);
    });
  },
  effects: ["trackFormControl"],
  on: {
    "VALUE.SET": {
      actions: ["setRawValue"]
    },
    "VALUE.CLEAR": {
      actions: ["clearValue"]
    },
    "VALUE.INCREMENT": {
      actions: ["increment"]
    },
    "VALUE.DECREMENT": {
      actions: ["decrement"]
    }
  },
  states: {
    idle: {
      on: {
        "TRIGGER.PRESS_DOWN": [
          { guard: "isTouchPointer", target: "before:spin", actions: ["setHint"] },
          {
            target: "before:spin",
            actions: ["focusInput", "invokeOnFocus", "setHint"]
          }
        ],
        "SCRUBBER.PRESS_DOWN": {
          target: "scrubbing",
          actions: ["focusInput", "invokeOnFocus", "setHint", "setCursorPoint"]
        },
        "INPUT.FOCUS": {
          target: "focused",
          actions: ["focusInput", "invokeOnFocus"]
        }
      }
    },
    focused: {
      tags: ["focus"],
      effects: ["attachWheelListener"],
      on: {
        "TRIGGER.PRESS_DOWN": [
          { guard: "isTouchPointer", target: "before:spin", actions: ["setHint"] },
          { target: "before:spin", actions: ["focusInput", "setHint"] }
        ],
        "SCRUBBER.PRESS_DOWN": {
          target: "scrubbing",
          actions: ["focusInput", "setHint", "setCursorPoint"]
        },
        "INPUT.ARROW_UP": {
          actions: ["increment"]
        },
        "INPUT.ARROW_DOWN": {
          actions: ["decrement"]
        },
        "INPUT.HOME": {
          actions: ["decrementToMin"]
        },
        "INPUT.END": {
          actions: ["incrementToMax"]
        },
        "INPUT.CHANGE": {
          actions: ["setValue", "setHint"]
        },
        "INPUT.BLUR": [
          {
            guard: and("clampValueOnBlur", not("isInRange")),
            target: "idle",
            actions: ["setClampedValue", "clearHint", "invokeOnBlur", "invokeOnValueCommit"]
          },
          {
            guard: not("isInRange"),
            target: "idle",
            actions: ["setFormattedValue", "clearHint", "invokeOnBlur", "invokeOnInvalid", "invokeOnValueCommit"]
          },
          {
            target: "idle",
            actions: ["setFormattedValue", "clearHint", "invokeOnBlur", "invokeOnValueCommit"]
          }
        ],
        "INPUT.ENTER": {
          actions: ["setFormattedValue", "clearHint", "invokeOnBlur", "invokeOnValueCommit"]
        }
      }
    },
    "before:spin": {
      tags: ["focus"],
      effects: ["trackButtonDisabled", "waitForChangeDelay"],
      entry: choose([
        { guard: "isIncrementHint", actions: ["increment"] },
        { guard: "isDecrementHint", actions: ["decrement"] }
      ]),
      on: {
        CHANGE_DELAY: {
          target: "spinning",
          guard: and("isInRange", "spinOnPress")
        },
        "TRIGGER.PRESS_UP": [
          { guard: "isTouchPointer", target: "focused", actions: ["clearHint"] },
          { target: "focused", actions: ["focusInput", "clearHint"] }
        ]
      }
    },
    spinning: {
      tags: ["focus"],
      effects: ["trackButtonDisabled", "spinValue"],
      on: {
        SPIN: [
          {
            guard: "isIncrementHint",
            actions: ["increment"]
          },
          {
            guard: "isDecrementHint",
            actions: ["decrement"]
          }
        ],
        "TRIGGER.PRESS_UP": {
          target: "focused",
          actions: ["focusInput", "clearHint"]
        }
      }
    },
    scrubbing: {
      tags: ["focus"],
      effects: ["activatePointerLock", "trackMousemove", "setupVirtualCursor", "preventTextSelection"],
      on: {
        "SCRUBBER.POINTER_UP": {
          target: "focused",
          actions: ["focusInput", "clearCursorPoint"]
        },
        "SCRUBBER.POINTER_MOVE": [
          {
            guard: "isIncrementHint",
            actions: ["increment", "setCursorPoint"]
          },
          {
            guard: "isDecrementHint",
            actions: ["decrement", "setCursorPoint"]
          }
        ]
      }
    }
  },
  implementations: {
    guards: {
      clampValueOnBlur: ({ prop }) => prop("clampValueOnBlur"),
      spinOnPress: ({ prop }) => !!prop("spinOnPress"),
      isInRange: ({ computed }) => !computed("isOutOfRange"),
      isDecrementHint: ({ context, event }) => (event.hint ?? context.get("hint")) === "decrement",
      isIncrementHint: ({ context, event }) => (event.hint ?? context.get("hint")) === "increment",
      isTouchPointer: ({ event }) => event.pointerType === "touch"
    },
    effects: {
      waitForChangeDelay({ send }) {
        const id = setTimeout(() => {
          send({ type: "CHANGE_DELAY" });
        }, 300);
        return () => clearTimeout(id);
      },
      spinValue({ send }) {
        const id = setInterval(() => {
          send({ type: "SPIN" });
        }, 50);
        return () => clearInterval(id);
      },
      trackFormControl({ context, scope }) {
        const inputEl = getInputEl(scope);
        return trackFormControl(inputEl, {
          onFieldsetDisabledChange(disabled) {
            context.set("fieldsetDisabled", disabled);
          },
          onFormReset() {
            context.set("value", context.initial("value"));
          }
        });
      },
      setupVirtualCursor({ context, scope }) {
        const point = context.get("scrubberCursorPoint");
        return setupVirtualCursor(scope, point);
      },
      preventTextSelection({ scope }) {
        return preventTextSelection(scope);
      },
      trackButtonDisabled({ context, scope, send }) {
        const hint = context.get("hint");
        const btn = getPressedTriggerEl(scope, hint);
        return observeAttributes(btn, {
          attributes: ["disabled"],
          callback() {
            send({ type: "TRIGGER.PRESS_UP", src: "attr" });
          }
        });
      },
      attachWheelListener({ scope, send, prop }) {
        const inputEl = getInputEl(scope);
        if (!inputEl || !scope.isActiveElement(inputEl) || !prop("allowMouseWheel")) return;
        function onWheel(event) {
          event.preventDefault();
          const dir = Math.sign(event.deltaY) * -1;
          if (dir === 1) {
            send({ type: "VALUE.INCREMENT" });
          } else if (dir === -1) {
            send({ type: "VALUE.DECREMENT" });
          }
        }
        return addDomEvent(inputEl, "wheel", onWheel, { passive: false });
      },
      activatePointerLock({ scope }) {
        if (isSafari()) return;
        return requestPointerLock(scope.getDoc());
      },
      trackMousemove({ scope, send, context, computed }) {
        const doc = scope.getDoc();
        function onMousemove(event) {
          const point = context.get("scrubberCursorPoint");
          const isRtl = computed("isRtl");
          const value = getMousemoveValue(scope, { point, isRtl, event });
          if (!value.hint) return;
          send({
            type: "SCRUBBER.POINTER_MOVE",
            hint: value.hint,
            point: value.point
          });
        }
        function onMouseup() {
          send({ type: "SCRUBBER.POINTER_UP" });
        }
        return callAll(addDomEvent(doc, "mousemove", onMousemove, false), addDomEvent(doc, "mouseup", onMouseup, false));
      }
    },
    actions: {
      focusInput({ scope, prop }) {
        if (!prop("focusInputOnChange")) return;
        const inputEl = getInputEl(scope);
        if (scope.isActiveElement(inputEl)) return;
        raf(() => inputEl?.focus({ preventScroll: true }));
      },
      increment({ context, event, prop, computed }) {
        let nextValue = incrementValue(computed("valueAsNumber"), event.step ?? prop("step"));
        if (!prop("allowOverflow")) nextValue = clampValue(nextValue, prop("min"), prop("max"));
        context.set("value", formatValue(nextValue, { computed, prop }));
      },
      decrement({ context, event, prop, computed }) {
        let nextValue = decrementValue(computed("valueAsNumber"), event.step ?? prop("step"));
        if (!prop("allowOverflow")) nextValue = clampValue(nextValue, prop("min"), prop("max"));
        context.set("value", formatValue(nextValue, { computed, prop }));
      },
      setClampedValue({ context, prop, computed }) {
        const nextValue = clampValue(computed("valueAsNumber"), prop("min"), prop("max"));
        context.set("value", formatValue(nextValue, { computed, prop }));
      },
      setRawValue({ context, event, prop, computed }) {
        let nextValue = parseValue(event.value, { computed, prop });
        if (!prop("allowOverflow")) nextValue = clampValue(nextValue, prop("min"), prop("max"));
        context.set("value", formatValue(nextValue, { computed, prop }));
      },
      setValue({ context, event }) {
        const value = event.target?.value ?? event.value;
        context.set("value", value);
      },
      clearValue({ context }) {
        context.set("value", "");
      },
      incrementToMax({ context, prop, computed }) {
        const value = formatValue(prop("max"), { computed, prop });
        context.set("value", value);
      },
      decrementToMin({ context, prop, computed }) {
        const value = formatValue(prop("min"), { computed, prop });
        context.set("value", value);
      },
      setHint({ context, event }) {
        context.set("hint", event.hint);
      },
      clearHint({ context }) {
        context.set("hint", null);
      },
      invokeOnFocus({ computed, prop }) {
        prop("onFocusChange")?.({
          focused: true,
          value: computed("formattedValue"),
          valueAsNumber: computed("valueAsNumber")
        });
      },
      invokeOnBlur({ computed, prop }) {
        prop("onFocusChange")?.({
          focused: false,
          value: computed("formattedValue"),
          valueAsNumber: computed("valueAsNumber")
        });
      },
      invokeOnInvalid({ computed, prop, event }) {
        if (event.type === "INPUT.CHANGE") return;
        const reason = computed("valueAsNumber") > prop("max") ? "rangeOverflow" : "rangeUnderflow";
        prop("onValueInvalid")?.({
          reason,
          value: computed("formattedValue"),
          valueAsNumber: computed("valueAsNumber")
        });
      },
      invokeOnValueCommit({ computed, prop }) {
        prop("onValueCommit")?.({
          value: computed("formattedValue"),
          valueAsNumber: computed("valueAsNumber")
        });
      },
      syncInputElement({ context, event, computed, scope }) {
        const value = event.type.endsWith("CHANGE") ? context.get("value") : computed("formattedValue");
        const inputEl = getInputEl(scope);
        const sel = event.selection ?? recordCursor(inputEl, scope);
        raf(() => {
          setElementValue(inputEl, value);
          restoreCursor(inputEl, sel, scope);
        });
      },
      setFormattedValue({ context, computed, action }) {
        context.set("value", computed("formattedValue"));
        action(["syncInputElement"]);
      },
      setCursorPoint({ context, event }) {
        context.set("scrubberCursorPoint", event.point);
      },
      clearCursorPoint({ context }) {
        context.set("scrubberCursorPoint", null);
      },
      setVirtualCursorPosition({ context, scope }) {
        const cursorEl = getCursorEl(scope);
        const point = context.get("scrubberCursorPoint");
        if (!cursorEl || !point) return;
        cursorEl.style.transform = `translate3d(${point.x}px, ${point.y}px, 0px)`;
      }
    }
  }
});
var props = createProps()([
  "allowMouseWheel",
  "allowOverflow",
  "clampValueOnBlur",
  "dir",
  "disabled",
  "focusInputOnChange",
  "form",
  "formatOptions",
  "getRootNode",
  "id",
  "ids",
  "inputMode",
  "invalid",
  "locale",
  "max",
  "min",
  "name",
  "onFocusChange",
  "onValueChange",
  "onValueCommit",
  "onValueInvalid",
  "pattern",
  "required",
  "readOnly",
  "spinOnPress",
  "step",
  "translations",
  "value",
  "defaultValue"
]);
var splitProps = createSplitProps(props);

// components/number-input.ts
var NumberInput = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props2) {
    return new VanillaMachine(machine, props2);
  }
  initApi() {
    return connect(this.machine.service, normalizeProps);
  }
  render() {
    const rootEl = this.el.querySelector('[data-scope="number-input"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());
    const labelEl = this.el.querySelector(
      '[data-scope="number-input"][data-part="label"]'
    );
    if (labelEl) this.spreadProps(labelEl, this.api.getLabelProps());
    const controlEl = this.el.querySelector(
      '[data-scope="number-input"][data-part="control"]'
    );
    if (controlEl) this.spreadProps(controlEl, this.api.getControlProps());
    const valueTextEl = this.el.querySelector(
      '[data-scope="number-input"][data-part="value-text"]'
    );
    if (valueTextEl) this.spreadProps(valueTextEl, this.api.getValueTextProps());
    const inputEl = this.el.querySelector(
      '[data-scope="number-input"][data-part="input"]'
    );
    if (inputEl) this.spreadProps(inputEl, this.api.getInputProps());
    const decrementEl = this.el.querySelector(
      '[data-scope="number-input"][data-part="decrement-trigger"]'
    );
    if (decrementEl) this.spreadProps(decrementEl, this.api.getDecrementTriggerProps());
    const incrementEl = this.el.querySelector(
      '[data-scope="number-input"][data-part="increment-trigger"]'
    );
    if (incrementEl) this.spreadProps(incrementEl, this.api.getIncrementTriggerProps());
    const scrubberEl = this.el.querySelector(
      '[data-scope="number-input"][data-part="scrubber"]'
    );
    if (scrubberEl) {
      this.spreadProps(scrubberEl, this.api.getScrubberProps());
      scrubberEl.setAttribute("aria-label", "Scrub to adjust value");
      scrubberEl.removeAttribute("role");
    }
  }
};

// hooks/number-input.ts
var NumberInputHook = {
  mounted() {
    const el = this.el;
    const valueStr = getString(el, "value");
    const defaultValueStr = getString(el, "defaultValue");
    const controlled = getBoolean(el, "controlled");
    const zag = new NumberInput(el, {
      id: el.id,
      ...controlled && valueStr !== void 0 ? { value: valueStr } : { defaultValue: defaultValueStr },
      min: getNumber(el, "min"),
      max: getNumber(el, "max"),
      step: getNumber(el, "step"),
      disabled: getBoolean(el, "disabled"),
      readOnly: getBoolean(el, "readOnly"),
      invalid: getBoolean(el, "invalid"),
      required: getBoolean(el, "required"),
      allowMouseWheel: getBoolean(el, "allowMouseWheel"),
      name: getString(el, "name"),
      form: getString(el, "form"),
      onValueChange: (details) => {
        const inputEl = el.querySelector(
          '[data-scope="number-input"][data-part="input"]'
        );
        if (inputEl) {
          inputEl.value = details.value;
          inputEl.dispatchEvent(new Event("input", { bubbles: true }));
          inputEl.dispatchEvent(new Event("change", { bubbles: true }));
        }
        const eventName = getString(el, "onValueChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, {
            value: details.value,
            valueAsNumber: details.valueAsNumber,
            id: el.id
          });
        }
        const clientName = getString(el, "onValueChangeClient");
        if (clientName) {
          el.dispatchEvent(
            new CustomEvent(clientName, {
              bubbles: true,
              detail: { value: details, id: el.id }
            })
          );
        }
      }
    });
    zag.init();
    this.numberInput = zag;
    this.handlers = [];
  },
  updated() {
    const valueStr = getString(this.el, "value");
    const controlled = getBoolean(this.el, "controlled");
    this.numberInput?.updateProps({
      id: this.el.id,
      ...controlled && valueStr !== void 0 ? { value: valueStr } : {},
      min: getNumber(this.el, "min"),
      max: getNumber(this.el, "max"),
      step: getNumber(this.el, "step"),
      disabled: getBoolean(this.el, "disabled"),
      readOnly: getBoolean(this.el, "readOnly"),
      invalid: getBoolean(this.el, "invalid"),
      required: getBoolean(this.el, "required"),
      name: getString(this.el, "name"),
      form: getString(this.el, "form")
    });
  },
  destroyed() {
    if (this.handlers) {
      for (const h of this.handlers) this.removeHandleEvent(h);
    }
    this.numberInput?.destroy();
  }
};
export {
  NumberInputHook as NumberInput
};
