import {
  $12a3c853105e5a70$export$ad991b66133851cf,
  $2aaf608024c21ca1$export$99faa760c7908e4f,
  $58246871e4652552$export$6b862160d295c8e,
  $ad063034c8620db8$export$42c81a444fbfb5d4,
  $ad063034c8620db8$export$461939dd4422153,
  $ad063034c8620db8$export$5a8da0c44a3afdf2,
  $ad063034c8620db8$export$618d60ea299da42,
  $ad063034c8620db8$export$629b0a497aa65267,
  $ad063034c8620db8$export$8b7aa55c66d5569e,
  $ad063034c8620db8$export$91b62ebf2ba703ee,
  $ad063034c8620db8$export$a2258d9c4118825c,
  $ad063034c8620db8$export$a5a3b454ada2268e,
  $ad063034c8620db8$export$ccc1b2479e7dd654,
  $ad063034c8620db8$export$d0bdf45af03a6ea3,
  $ad063034c8620db8$export$ea39ec197993aef0,
  $ad063034c8620db8$export$ea840f5a6dda8147,
  $ad063034c8620db8$export$ef8b6d9133084f4e,
  $ad063034c8620db8$export$f91e89d3d0406102,
  $d07e34cce18680fd$export$84c95a83c799e074,
  $d07e34cce18680fd$export$93522d1a439f3617,
  $d07e34cce18680fd$export$b21e0b124e224484,
  $d07e34cce18680fd$export$b4a036af3fc0b032,
  alignCenter,
  alignEnd,
  alignStart,
  constrainStart,
  constrainValue,
  ensureValidCharacters,
  getLocaleSeparator,
  getTodayDate,
  isDateEqual,
  isDateOutsideRange,
  isDateUnavailable,
  isNextRangeInvalid,
  isPreviousRangeInvalid,
  isValidCharacter
} from "./chunks/chunk-YIRWSF62.mjs";
import {
  memo
} from "./chunks/chunk-G4YHNHIV.mjs";
import {
  clampValue,
  isValueWithinRange
} from "./chunks/chunk-AJX2XHOK.mjs";
import {
  createLiveRegion
} from "./chunks/chunk-NUOTFVKH.mjs";
import {
  getPlacement,
  getPlacementSide,
  getPlacementStyles
} from "./chunks/chunk-7DTCDTRW.mjs";
import {
  trackDismissableElement
} from "./chunks/chunk-4ATAXYH3.mjs";
import "./chunks/chunk-AVGG6QG4.mjs";
import {
  readPositioningOptions
} from "./chunks/chunk-55YTGZEH.mjs";
import {
  setArrayValues,
  setScalarValue
} from "./chunks/chunk-6Q56QPKD.mjs";
import {
  mountStringListBinding,
  readDatasetStringList,
  readUpdatedServerStringList
} from "./chunks/chunk-2TVI6WVN.mjs";
import {
  notifyChange
} from "./chunks/chunk-EAQ6WQNO.mjs";
import {
  createAnatomy
} from "./chunks/chunk-YMOPD357.mjs";
import {
  Component,
  VanillaMachine,
  ariaAttr,
  canPushEvent,
  chunk,
  createGuards,
  createMachine,
  createZagLiveHook,
  dataAttr,
  disableTextSelection,
  getBoolean,
  getEventKey,
  getNativeEvent,
  getNumber,
  getString,
  isComposingEvent,
  match,
  mergeWithDefault,
  query,
  queryAll,
  raf,
  restoreTextSelection,
  setElementValue
} from "./chunks/chunk-R62PCG6O.mjs";

// ../node_modules/.pnpm/@zag-js+date-picker@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-picker/dist/date-picker.anatomy.mjs
var anatomy = createAnatomy("date-picker").parts(
  "clearTrigger",
  "content",
  "control",
  "input",
  "label",
  "monthSelect",
  "nextTrigger",
  "positioner",
  "presetTrigger",
  "prevTrigger",
  "rangeText",
  "root",
  "table",
  "tableBody",
  "tableCell",
  "tableCellTrigger",
  "tableHead",
  "tableHeader",
  "tableRow",
  "trigger",
  "view",
  "viewControl",
  "viewTrigger",
  "yearSelect"
);
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+date-utils@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-utils/dist/align.mjs
function alignDate(date, alignment, duration, locale, min, max) {
  switch (alignment) {
    case "start":
      return alignStart(date, duration, locale, min, max);
    case "end":
      return alignEnd(date, duration, locale, min, max);
    case "center":
    default:
      return alignCenter(date, duration, locale, min, max);
  }
}

// ../node_modules/.pnpm/@zag-js+date-utils@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-utils/dist/duration.mjs
function getUnitDuration(duration) {
  let clone = { ...duration };
  for (let key in clone) clone[key] = 1;
  return clone;
}
function getEndDate(startDate, duration) {
  let clone = { ...duration };
  if (clone.days) clone.days--;
  else clone.days = -1;
  return startDate.add(clone);
}

// ../node_modules/.pnpm/@zag-js+date-utils@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-utils/dist/get-era-format.mjs
function getEraFormat(date) {
  if (!date) return void 0;
  const id = date.calendar.identifier;
  if (id === "gregory" || id === "iso8601") {
    return date.era === "BC" ? "short" : void 0;
  }
  return "short";
}

// ../node_modules/.pnpm/@zag-js+date-utils@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-utils/dist/formatter.mjs
function getDayFormatter(locale, timeZone, referenceDate) {
  const date = referenceDate ?? $d07e34cce18680fd$export$b21e0b124e224484($ad063034c8620db8$export$d0bdf45af03a6ea3(timeZone));
  return new $12a3c853105e5a70$export$ad991b66133851cf(locale, {
    weekday: "long",
    month: "long",
    year: "numeric",
    day: "numeric",
    era: getEraFormat(date),
    calendar: date.calendar.identifier,
    timeZone
  });
}
function getMonthFormatter(locale, timeZone, referenceDate) {
  const date = referenceDate ?? $ad063034c8620db8$export$d0bdf45af03a6ea3(timeZone);
  return new $12a3c853105e5a70$export$ad991b66133851cf(locale, {
    month: "long",
    year: "numeric",
    era: getEraFormat(date),
    calendar: date.calendar.identifier,
    timeZone
  });
}

// ../node_modules/.pnpm/@zag-js+date-utils@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-utils/dist/format.mjs
function formatRange(startDate, endDate, formatter, toString, timeZone) {
  let parts2 = formatter.formatRangeToParts(startDate.toDate(timeZone), endDate.toDate(timeZone));
  let separatorIndex = -1;
  for (let i = 0; i < parts2.length; i++) {
    let part = parts2[i];
    if (part.source === "shared" && part.type === "literal") {
      separatorIndex = i;
    } else if (part.source === "endRange") {
      break;
    }
  }
  let start = "";
  let end = "";
  for (let i = 0; i < parts2.length; i++) {
    if (i < separatorIndex) {
      start += parts2[i].value;
    } else if (i > separatorIndex) {
      end += parts2[i].value;
    }
  }
  return toString(start, end);
}
function formatSelectedDate(startDate, endDate, locale, timeZone) {
  if (!startDate) return "";
  let start = startDate;
  let end = endDate ?? startDate;
  let formatter = getDayFormatter(locale, timeZone);
  if ($ad063034c8620db8$export$ea39ec197993aef0(start, end)) {
    return formatter.format(start.toDate(timeZone));
  }
  return formatRange(start, end, formatter, (start2, end2) => `${start2} \u2013 ${end2}`, timeZone);
}

// ../node_modules/.pnpm/@zag-js+date-utils@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-utils/dist/date-month.mjs
var daysOfTheWeek = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"];
function normalizeFirstDayOfWeek(firstDayOfWeek) {
  return firstDayOfWeek != null ? daysOfTheWeek[firstDayOfWeek] : void 0;
}
function getStartOfWeek(date, locale, firstDayOfWeek) {
  const firstDay = normalizeFirstDayOfWeek(firstDayOfWeek);
  return $ad063034c8620db8$export$42c81a444fbfb5d4(date, locale, firstDay);
}
function getDaysInWeek(weekIndex, from, locale, firstDayOfWeek) {
  const weekDate = from.add({ weeks: weekIndex });
  const dates = [];
  let date = getStartOfWeek(weekDate, locale, firstDayOfWeek);
  while (dates.length < 7) {
    dates.push(date);
    let nextDate = date.add({ days: 1 });
    if ($ad063034c8620db8$export$ea39ec197993aef0(date, nextDate)) break;
    date = nextDate;
  }
  return dates;
}
function getMonthDays(from, locale, numOfWeeks, firstDayOfWeek) {
  const firstDay = normalizeFirstDayOfWeek(firstDayOfWeek);
  const monthWeeks = numOfWeeks ?? $ad063034c8620db8$export$ccc1b2479e7dd654(from, locale, firstDay);
  const weeks = [...new Array(monthWeeks).keys()];
  return weeks.map((week) => getDaysInWeek(week, from, locale, firstDayOfWeek));
}
function getWeekdayFormats(locale, timeZone) {
  const longFormat = new $12a3c853105e5a70$export$ad991b66133851cf(locale, { weekday: "long", timeZone });
  const shortFormat = new $12a3c853105e5a70$export$ad991b66133851cf(locale, { weekday: "short", timeZone });
  const narrowFormat = new $12a3c853105e5a70$export$ad991b66133851cf(locale, { weekday: "narrow", timeZone });
  return (value) => {
    const date = value instanceof Date ? value : value.toDate(timeZone);
    return {
      value,
      short: shortFormat.format(date),
      long: longFormat.format(date),
      narrow: narrowFormat.format(date)
    };
  };
}
function getWeekDays(date, startOfWeekProp, timeZone, locale) {
  const firstDayOfWeek = getStartOfWeek(date, locale, startOfWeekProp);
  const weeks = [...new Array(7).keys()];
  const format = getWeekdayFormats(locale, timeZone);
  return weeks.map((index) => format(firstDayOfWeek.add({ days: index })));
}
function getMonthNames(locale, format = "long", referenceDate) {
  if (!referenceDate || referenceDate.calendar.identifier === "gregory" || referenceDate.calendar.identifier === "iso8601") {
    const date = new Date(2021, 0, 1);
    const monthNames2 = [];
    for (let i = 0; i < 12; i++) {
      monthNames2.push(date.toLocaleString(locale, { month: format }));
      date.setMonth(date.getMonth() + 1);
    }
    return monthNames2;
  }
  const monthCount = referenceDate.calendar.getMonthsInYear(referenceDate);
  const formatter = new $12a3c853105e5a70$export$ad991b66133851cf(locale, {
    month: format,
    calendar: referenceDate.calendar.identifier
  });
  const monthNames = [];
  for (let month = 1; month <= monthCount; month++) {
    const d = referenceDate.set({ month });
    monthNames.push(formatter.format(d.toDate("UTC")));
  }
  return monthNames;
}
function getWeekOfYear(date, locale) {
  const mondayOfWeek = $ad063034c8620db8$export$42c81a444fbfb5d4(date, locale, "mon");
  const year = mondayOfWeek.year;
  const jan4 = mondayOfWeek.set({ month: 1, day: 4 });
  const week1Monday = $ad063034c8620db8$export$42c81a444fbfb5d4(jan4, locale, "mon");
  const julianMonday = mondayOfWeek.calendar.toJulianDay(mondayOfWeek);
  const julianWeek1 = week1Monday.calendar.toJulianDay(week1Monday);
  if (julianMonday >= julianWeek1) {
    return 1 + Math.floor((julianMonday - julianWeek1) / 7);
  }
  const prevJan4 = mondayOfWeek.set({ year: year - 1, month: 1, day: 4 });
  const prevWeek1Monday = $ad063034c8620db8$export$42c81a444fbfb5d4(prevJan4, locale, "mon");
  const julianPrevWeek1 = prevWeek1Monday.calendar.toJulianDay(prevWeek1Monday);
  return 1 + Math.floor((julianMonday - julianPrevWeek1) / 7);
}

// ../node_modules/.pnpm/@zag-js+date-utils@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-utils/dist/date-year.mjs
function getYearsRange(range) {
  const years = [];
  for (let year = range.from; year <= range.to; year += 1) years.push(year);
  return years;
}
var DEFAULT_MIN_YEAR = 1900;
var DEFAULT_MAX_YEAR = 2099;
function getDefaultYearRange(referenceDate, min, max) {
  const calendar = referenceDate.calendar;
  const fromYear = min?.year ?? $d07e34cce18680fd$export$b4a036af3fc0b032(new $2aaf608024c21ca1$export$99faa760c7908e4f(DEFAULT_MIN_YEAR, 1, 1), calendar).year;
  const toYear = max?.year ?? $d07e34cce18680fd$export$b4a036af3fc0b032(new $2aaf608024c21ca1$export$99faa760c7908e4f(DEFAULT_MAX_YEAR, 12, 31), calendar).year;
  return { from: fromYear, to: toYear };
}
var FUTURE_YEAR_COERCION = 10;
function normalizeYear(year) {
  if (!year) return;
  if (year.length === 3) return year.padEnd(4, "0");
  if (year.length === 2) {
    const currentYear = (/* @__PURE__ */ new Date()).getFullYear();
    const currentCentury = Math.floor(currentYear / 100) * 100;
    const twoDigitYear = parseInt(year.slice(-2), 10);
    const fullYear = currentCentury + twoDigitYear;
    return fullYear > currentYear + FUTURE_YEAR_COERCION ? (fullYear - 100).toString() : fullYear.toString();
  }
  return year;
}
function getDecadeRange(year, opts) {
  const chunkSize = opts?.strict ? 10 : 12;
  const computedYear = year - year % 10;
  const years = [];
  for (let i = 0; i < chunkSize; i += 1) {
    const value = computedYear + i;
    years.push(value);
  }
  return years;
}

// ../node_modules/.pnpm/@zag-js+date-utils@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-utils/dist/pagination.mjs
function getAdjustedDateFn(visibleDuration, locale, minValue, maxValue) {
  return function getDate(options) {
    const { startDate, focusedDate } = options;
    const endDate = getEndDate(startDate, visibleDuration);
    if (isDateOutsideRange(focusedDate, minValue, maxValue)) {
      return {
        startDate,
        focusedDate: constrainValue(focusedDate, minValue, maxValue),
        endDate
      };
    }
    if (focusedDate.compare(startDate) < 0) {
      return {
        startDate: alignEnd(focusedDate, visibleDuration, locale, minValue, maxValue),
        focusedDate: constrainValue(focusedDate, minValue, maxValue),
        endDate
      };
    }
    if (focusedDate.compare(endDate) > 0) {
      return {
        startDate: alignStart(focusedDate, visibleDuration, locale, minValue, maxValue),
        endDate,
        focusedDate: constrainValue(focusedDate, minValue, maxValue)
      };
    }
    return {
      startDate,
      endDate,
      focusedDate: constrainValue(focusedDate, minValue, maxValue)
    };
  };
}
function getNextPage(focusedDate, startDate, visibleDuration, locale, minValue, maxValue) {
  const adjust = getAdjustedDateFn(visibleDuration, locale, minValue, maxValue);
  const start = startDate.add(visibleDuration);
  return adjust({
    focusedDate: focusedDate.add(visibleDuration),
    startDate: alignStart(
      constrainStart(focusedDate, start, visibleDuration, locale, minValue, maxValue),
      visibleDuration,
      locale
    )
  });
}
function getPreviousPage(focusedDate, startDate, visibleDuration, locale, minValue, maxValue) {
  const adjust = getAdjustedDateFn(visibleDuration, locale, minValue, maxValue);
  let start = startDate.subtract(visibleDuration);
  return adjust({
    focusedDate: focusedDate.subtract(visibleDuration),
    startDate: alignStart(
      constrainStart(focusedDate, start, visibleDuration, locale, minValue, maxValue),
      visibleDuration,
      locale
    )
  });
}
function getNextSection(focusedDate, startDate, larger, visibleDuration, locale, minValue, maxValue) {
  const adjust = getAdjustedDateFn(visibleDuration, locale, minValue, maxValue);
  if (!larger && !visibleDuration.days) {
    return adjust({
      focusedDate: focusedDate.add(getUnitDuration(visibleDuration)),
      startDate
    });
  }
  if (visibleDuration.days) {
    return getNextPage(focusedDate, startDate, visibleDuration, locale, minValue, maxValue);
  }
  if (visibleDuration.weeks) {
    return adjust({
      focusedDate: focusedDate.add({ months: 1 }),
      startDate
    });
  }
  if (visibleDuration.months || visibleDuration.years) {
    return adjust({
      focusedDate: focusedDate.add({ years: 1 }),
      startDate
    });
  }
}
function getPreviousSection(focusedDate, startDate, larger, visibleDuration, locale, minValue, maxValue) {
  const adjust = getAdjustedDateFn(visibleDuration, locale, minValue, maxValue);
  if (!larger && !visibleDuration.days) {
    return adjust({
      focusedDate: focusedDate.subtract(getUnitDuration(visibleDuration)),
      startDate
    });
  }
  if (visibleDuration.days) {
    return getPreviousPage(focusedDate, startDate, visibleDuration, locale, minValue, maxValue);
  }
  if (visibleDuration.weeks) {
    return adjust({
      focusedDate: focusedDate.subtract({ months: 1 }),
      startDate
    });
  }
  if (visibleDuration.months || visibleDuration.years) {
    return adjust({
      focusedDate: focusedDate.subtract({ years: 1 }),
      startDate
    });
  }
}

// ../node_modules/.pnpm/@zag-js+date-utils@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-utils/dist/parse-date.mjs
var isValidYear = (year) => year != null && year.length === 4;
var isValidMonth = (month) => month != null && parseFloat(month) <= 12;
var isValidDay = (day) => day != null && parseFloat(day) <= 31;
function parseDateString(date, locale, timeZone) {
  const regex = createRegex(locale, timeZone);
  let { year, month, day } = extract(regex, date) ?? {};
  const hasMatch = year != null || month != null || day != null;
  if (hasMatch) {
    const curr = /* @__PURE__ */ new Date();
    year || (year = curr.getFullYear().toString());
    month || (month = (curr.getMonth() + 1).toString());
    day || (day = curr.getDate().toString());
  }
  if (!isValidYear(year)) {
    year = normalizeYear(year);
  }
  if (isValidYear(year) && isValidMonth(month) && isValidDay(day)) {
    return new $2aaf608024c21ca1$export$99faa760c7908e4f(+year, +month, +day);
  }
  const time = Date.parse(date);
  if (!isNaN(time)) {
    const date2 = new Date(time);
    return new $2aaf608024c21ca1$export$99faa760c7908e4f(date2.getFullYear(), date2.getMonth() + 1, date2.getDate());
  }
}
function createRegex(locale, timeZone) {
  const formatter = new $12a3c853105e5a70$export$ad991b66133851cf(locale, { day: "numeric", month: "numeric", year: "numeric", timeZone });
  const parts2 = formatter.formatToParts(new Date(2e3, 11, 25));
  return parts2.map(({ type, value }) => type === "literal" ? `${value}?` : `((?!=<${type}>)\\d+)?`).join("");
}
function extract(pattern, str) {
  const matches = str.match(pattern);
  return pattern.toString().match(/<(.+?)>/g)?.map((group) => {
    const groupMatches = group.match(/<(.+)>/);
    if (!groupMatches || groupMatches.length <= 0) {
      return null;
    }
    return group.match(/<(.+)>/)?.[1];
  }).reduce((acc, curr, index) => {
    if (!curr) return acc;
    if (matches && matches.length > index) {
      acc[curr] = matches[index + 1];
    } else {
      acc[curr] = null;
    }
    return acc;
  }, {});
}

// ../node_modules/.pnpm/@zag-js+date-utils@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-utils/dist/preset.mjs
function getDateRangePreset(preset, locale, timeZone) {
  const today = $d07e34cce18680fd$export$93522d1a439f3617($ad063034c8620db8$export$461939dd4422153(timeZone));
  switch (preset) {
    case "thisWeek":
      return [$ad063034c8620db8$export$42c81a444fbfb5d4(today, locale), $ad063034c8620db8$export$ef8b6d9133084f4e(today, locale)];
    case "thisMonth":
      return [$ad063034c8620db8$export$a5a3b454ada2268e(today), today];
    case "thisQuarter":
      return [$ad063034c8620db8$export$a5a3b454ada2268e(today).add({ months: -((today.month - 1) % 3) }), today];
    case "thisYear":
      return [$ad063034c8620db8$export$f91e89d3d0406102(today), today];
    case "last3Days":
      return [today.add({ days: -2 }), today];
    case "last7Days":
      return [today.add({ days: -6 }), today];
    case "last14Days":
      return [today.add({ days: -13 }), today];
    case "last30Days":
      return [today.add({ days: -29 }), today];
    case "last90Days":
      return [today.add({ days: -89 }), today];
    case "lastMonth":
      return [$ad063034c8620db8$export$a5a3b454ada2268e(today.add({ months: -1 })), $ad063034c8620db8$export$a2258d9c4118825c(today.add({ months: -1 }))];
    case "lastQuarter":
      return [
        $ad063034c8620db8$export$a5a3b454ada2268e(today.add({ months: -((today.month - 1) % 3) - 3 })),
        $ad063034c8620db8$export$a2258d9c4118825c(today.add({ months: -((today.month - 1) % 3) - 1 }))
      ];
    case "lastWeek":
      return [$ad063034c8620db8$export$42c81a444fbfb5d4(today, locale).add({ weeks: -1 }), $ad063034c8620db8$export$ef8b6d9133084f4e(today, locale).add({ weeks: -1 })];
    case "lastYear":
      return [$ad063034c8620db8$export$f91e89d3d0406102(today.add({ years: -1 })), $ad063034c8620db8$export$8b7aa55c66d5569e(today.add({ years: -1 }))];
    default:
      throw new Error(`Invalid date range preset: ${preset}`);
  }
}

// ../node_modules/.pnpm/@zag-js+date-picker@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-picker/dist/date-picker.dom.mjs
var getLabelId = (ctx, index) => ctx.ids?.label?.(index) ?? `datepicker:${ctx.id}:label:${index}`;
var getRootId = (ctx) => ctx.ids?.root ?? `datepicker:${ctx.id}`;
var getTableId = (ctx, id) => ctx.ids?.table?.(id) ?? `datepicker:${ctx.id}:table:${id}`;
var getContentId = (ctx) => ctx.ids?.content ?? `datepicker:${ctx.id}:content`;
var getCellTriggerId = (ctx, id) => ctx.ids?.cellTrigger?.(id) ?? `datepicker:${ctx.id}:cell-trigger:${id}`;
var getPrevTriggerId = (ctx, view) => ctx.ids?.prevTrigger?.(view) ?? `datepicker:${ctx.id}:prev:${view}`;
var getNextTriggerId = (ctx, view) => ctx.ids?.nextTrigger?.(view) ?? `datepicker:${ctx.id}:next:${view}`;
var getViewTriggerId = (ctx, view) => ctx.ids?.viewTrigger?.(view) ?? `datepicker:${ctx.id}:view:${view}`;
var getClearTriggerId = (ctx) => ctx.ids?.clearTrigger ?? `datepicker:${ctx.id}:clear`;
var getControlId = (ctx) => ctx.ids?.control ?? `datepicker:${ctx.id}:control`;
var getInputId = (ctx, index) => ctx.ids?.input?.(index) ?? `datepicker:${ctx.id}:input:${index}`;
var getTriggerId = (ctx) => ctx.ids?.trigger ?? `datepicker:${ctx.id}:trigger`;
var getPositionerId = (ctx) => ctx.ids?.positioner ?? `datepicker:${ctx.id}:positioner`;
var getMonthSelectId = (ctx) => ctx.ids?.monthSelect ?? `datepicker:${ctx.id}:month-select`;
var getYearSelectId = (ctx) => ctx.ids?.yearSelect ?? `datepicker:${ctx.id}:year-select`;
var getFocusedCell = (ctx, view) => query(getContentEl(ctx), `[data-part=table-cell-trigger][data-view=${view}][data-focus]:not([data-outside-range])`);
var getTriggerEl = (ctx) => ctx.getById(getTriggerId(ctx));
var getContentEl = (ctx) => ctx.getById(getContentId(ctx));
var getInputEls = (ctx) => queryAll(getControlEl(ctx), `[data-part=input]`);
var getYearSelectEl = (ctx) => ctx.getById(getYearSelectId(ctx));
var getMonthSelectEl = (ctx) => ctx.getById(getMonthSelectId(ctx));
var getClearTriggerEl = (ctx) => ctx.getById(getClearTriggerId(ctx));
var getPositionerEl = (ctx) => ctx.getById(getPositionerId(ctx));
var getControlEl = (ctx) => ctx.getById(getControlId(ctx));

// ../node_modules/.pnpm/@zag-js+date-picker@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-picker/dist/date-picker.utils.mjs
function adjustStartAndEndDate(value) {
  const [startDate, endDate] = value;
  let result;
  if (!startDate || !endDate) result = value;
  else result = startDate.compare(endDate) <= 0 ? value : [endDate, startDate];
  return result;
}
function isDateWithinRange(date, value) {
  const [startDate, endDate] = value;
  if (!startDate || !endDate) return false;
  return startDate.compare(date) <= 0 && endDate.compare(date) >= 0;
}
function sortDates(values) {
  return values.slice().filter((date) => date != null).sort((a, b) => a.compare(b));
}
function getRoleDescription(view) {
  return match(view, {
    year: "calendar decade",
    month: "calendar year",
    day: "calendar month"
  });
}
var PLACEHOLDERS = {
  day: "dd",
  month: "mm",
  year: "yyyy"
};
function getInputPlaceholder(locale) {
  return new $12a3c853105e5a70$export$ad991b66133851cf(locale).formatToParts(/* @__PURE__ */ new Date()).map((item) => PLACEHOLDERS[item.type] ?? item.value).join("");
}
var isValidDate = (value) => {
  return !Number.isNaN(value.day) && !Number.isNaN(value.month) && !Number.isNaN(value.year);
};
var defaultTranslations = {
  dayCell(state) {
    if (state.unavailable) return `Not available. ${state.valueText}`;
    if (state.firstInRange) return `Starting range from ${state.valueText}`;
    if (state.lastInRange) return `Range ending at ${state.valueText}`;
    if (state.inRange) return `In range. ${state.valueText}`;
    if (state.selected) return `Selected date. ${state.valueText}`;
    return `Choose ${state.valueText}`;
  },
  trigger(open) {
    return open ? "Close calendar" : "Open calendar";
  },
  viewTrigger(view, nextView) {
    if (!nextView) return `${view} view`;
    return `Switch to ${nextView} view`;
  },
  presetTrigger(value) {
    const [start = "", end = ""] = value;
    return `select ${start} to ${end}`;
  },
  prevTrigger(view) {
    return match(view, {
      year: "Switch to previous decade",
      month: "Switch to previous year",
      day: "Switch to previous month"
    });
  },
  nextTrigger(view) {
    return match(view, {
      year: "Switch to next decade",
      month: "Switch to next year",
      day: "Switch to next month"
    });
  },
  // TODO: Revisit this
  placeholder() {
    return { day: "dd", month: "mm", year: "yyyy" };
  },
  content: "calendar",
  monthSelect: "Select month",
  yearSelect: "Select year",
  clearTrigger: "Clear selected dates",
  weekColumnHeader: "Wk",
  weekNumberCell(weekNumber) {
    return `Week ${weekNumber}`;
  }
};
function viewToNumber(view, fallback) {
  if (!view) return fallback || 0;
  return view === "day" ? 0 : view === "month" ? 1 : 2;
}
function viewNumberToView(viewNumber) {
  return viewNumber === 0 ? "day" : viewNumber === 1 ? "month" : "year";
}
function clampView(view, minView, maxView) {
  return viewNumberToView(
    clampValue(viewToNumber(view, 0), viewToNumber(minView, 0), viewToNumber(maxView, 2))
  );
}
function isAboveMinView(view, minView) {
  return viewToNumber(view, 0) > viewToNumber(minView, 0);
}
function isBelowMinView(view, minView) {
  return viewToNumber(view, 0) < viewToNumber(minView, 0);
}
function getNextView(view, minView, maxView) {
  const nextViewNumber = viewToNumber(view, 0) + 1;
  return clampView(viewNumberToView(nextViewNumber), minView, maxView);
}
function getPreviousView(view, minView, maxView) {
  const prevViewNumber = viewToNumber(view, 0) - 1;
  return clampView(viewNumberToView(prevViewNumber), minView, maxView);
}
var views = ["day", "month", "year"];
function eachView(cb) {
  views.forEach((view) => cb(view));
}
var getVisibleRangeText = memo(
  (opts) => [
    opts.view,
    opts.startValue.toString(),
    opts.endValue.toString(),
    opts.locale,
    opts.timeZone,
    opts.selectionMode
  ],
  ([view], opts) => {
    const { startValue, endValue, locale, timeZone, selectionMode } = opts;
    if (view === "year") {
      const years = getDecadeRange(startValue.year, { strict: true });
      const start2 = years.at(0).toString();
      const end2 = years.at(-1).toString();
      return { start: start2, end: end2, formatted: `${start2} - ${end2}` };
    }
    if (view === "month") {
      const formatter2 = new $12a3c853105e5a70$export$ad991b66133851cf(locale, {
        year: "numeric",
        timeZone,
        calendar: startValue.calendar.identifier
      });
      const start2 = formatter2.format(startValue.toDate(timeZone));
      const end2 = formatter2.format(endValue.toDate(timeZone));
      const formatted2 = selectionMode === "range" ? `${start2} - ${end2}` : start2;
      return { start: start2, end: end2, formatted: formatted2 };
    }
    const formatter = new $12a3c853105e5a70$export$ad991b66133851cf(locale, {
      month: "long",
      year: "numeric",
      timeZone,
      calendar: startValue.calendar.identifier
    });
    const start = formatter.format(startValue.toDate(timeZone));
    const end = formatter.format(endValue.toDate(timeZone));
    const formatted = selectionMode === "range" ? `${start} - ${end}` : start;
    return { start, end, formatted };
  }
);

// ../node_modules/.pnpm/@zag-js+date-picker@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-picker/dist/date-picker.connect.mjs
function connect(service, normalize) {
  const { state, context, prop, send, computed, scope } = service;
  const startValue = context.get("startValue");
  const endValue = computed("endValue");
  const selectedValue = context.get("value");
  const focusedValue = context.get("focusedValue");
  const hoveredValue = context.get("hoveredValue");
  const hoveredRangeValue = hoveredValue ? adjustStartAndEndDate([selectedValue[0], hoveredValue]) : [];
  const disabled = Boolean(prop("disabled"));
  const readOnly = Boolean(prop("readOnly"));
  const invalid = Boolean(prop("invalid"));
  const interactive = computed("isInteractive");
  const empty = selectedValue.length === 0;
  const min = prop("min");
  const max = prop("max");
  const locale = prop("locale");
  const timeZone = prop("timeZone");
  const startOfWeek = prop("startOfWeek");
  const focused = state.matches("focused");
  const open = state.matches("open");
  const isRangePicker = prop("selectionMode") === "range";
  const isMultiPicker = prop("selectionMode") === "multiple";
  const isDateUnavailableFn = prop("isDateUnavailable");
  const maxSelectedDates = prop("maxSelectedDates");
  const isMaxSelected = isMultiPicker && maxSelectedDates != null && selectedValue.length >= maxSelectedDates;
  const currentPlacement = context.get("currentPlacement");
  const currentPlacementSide = currentPlacement ? getPlacementSide(currentPlacement) : void 0;
  const popperStyles = getPlacementStyles({
    ...prop("positioning"),
    placement: currentPlacement
  });
  const separator = getLocaleSeparator(locale);
  const translations = mergeWithDefault(defaultTranslations, prop("translations"));
  function getMonthWeeks(from = startValue) {
    const numOfWeeks = prop("fixedWeeks") ? 6 : void 0;
    return getMonthDays(from, locale, numOfWeeks, startOfWeek);
  }
  function getMonths(props = {}) {
    const { format } = props;
    return getMonthNames(locale, format, focusedValue).map((label, index) => {
      const value = index + 1;
      const dateValue = focusedValue.set({ month: value });
      const disabled2 = isDateOutsideRange(dateValue, min, max);
      return { label, value, disabled: disabled2 };
    });
  }
  function getYears() {
    const defaultRange = getDefaultYearRange(focusedValue, min, max);
    const range = getYearsRange(defaultRange);
    return range.map((year) => ({
      label: year.toString(),
      value: year,
      disabled: !isValueWithinRange(year, min?.year, max?.year)
    }));
  }
  function isUnavailable(date) {
    return isDateUnavailable(date, isDateUnavailableFn, locale, min, max);
  }
  function focusMonth(month) {
    const date = startValue ?? getTodayDate(timeZone, focusedValue.calendar);
    send({ type: "FOCUS.SET", value: date.set({ month }) });
  }
  function focusYear(year) {
    const date = startValue ?? getTodayDate(timeZone, focusedValue.calendar);
    send({ type: "FOCUS.SET", value: date.set({ year }) });
  }
  function getYearTableCellState(props) {
    const { value, disabled: disabled2 } = props;
    const dateValue = focusedValue.set({ year: value });
    const decadeYears = getDecadeRange(startValue.year, { strict: true });
    const isOutsideVisibleRange = !decadeYears.includes(value);
    const isWithinMinMax = isValueWithinRange(value, min?.year, max?.year);
    const isInSelectedRange = isRangePicker && isDateWithinRange(dateValue, selectedValue);
    const isFirstInSelectedRange = isRangePicker && selectedValue[0] && $ad063034c8620db8$export$ea840f5a6dda8147(dateValue, selectedValue[0]);
    const isLastInSelectedRange = isRangePicker && selectedValue[1] && $ad063034c8620db8$export$ea840f5a6dda8147(dateValue, selectedValue[1]);
    const hasHoveredRange = isRangePicker && hoveredRangeValue.length > 0;
    const isInHoveredRange = hasHoveredRange && isDateWithinRange(dateValue, hoveredRangeValue);
    const isFirstInHoveredRange = hasHoveredRange && hoveredRangeValue[0] && $ad063034c8620db8$export$ea840f5a6dda8147(dateValue, hoveredRangeValue[0]);
    const isLastInHoveredRange = hasHoveredRange && hoveredRangeValue[1] && $ad063034c8620db8$export$ea840f5a6dda8147(dateValue, hoveredRangeValue[1]);
    const cellState = {
      focused: focusedValue.year === props.value,
      selectable: !isOutsideVisibleRange && isWithinMinMax,
      outsideRange: isOutsideVisibleRange,
      selected: !!selectedValue.find((date) => date && date.year === value),
      valueText: value.toString(),
      inRange: isInSelectedRange || isInHoveredRange,
      firstInRange: !!isFirstInSelectedRange,
      lastInRange: !!isLastInSelectedRange,
      inHoveredRange: !!isInHoveredRange,
      firstInHoveredRange: !!isFirstInHoveredRange,
      lastInHoveredRange: !!isLastInHoveredRange,
      value: dateValue,
      get disabled() {
        return disabled2 || !cellState.selectable;
      }
    };
    return cellState;
  }
  function getMonthTableCellState(props) {
    const { value, disabled: disabled2 } = props;
    const dateValue = focusedValue.set({ month: value });
    const formatter = getMonthFormatter(locale, timeZone, focusedValue);
    const isInSelectedRange = isRangePicker && isDateWithinRange(dateValue, selectedValue);
    const isFirstInSelectedRange = isRangePicker && selectedValue[0] && $ad063034c8620db8$export$5a8da0c44a3afdf2(dateValue, selectedValue[0]);
    const isLastInSelectedRange = isRangePicker && selectedValue[1] && $ad063034c8620db8$export$5a8da0c44a3afdf2(dateValue, selectedValue[1]);
    const hasHoveredRange = isRangePicker && hoveredRangeValue.length > 0;
    const isInHoveredRange = hasHoveredRange && isDateWithinRange(dateValue, hoveredRangeValue);
    const isFirstInHoveredRange = hasHoveredRange && hoveredRangeValue[0] && $ad063034c8620db8$export$5a8da0c44a3afdf2(dateValue, hoveredRangeValue[0]);
    const isLastInHoveredRange = hasHoveredRange && hoveredRangeValue[1] && $ad063034c8620db8$export$5a8da0c44a3afdf2(dateValue, hoveredRangeValue[1]);
    const cellState = {
      focused: focusedValue.month === props.value,
      selectable: !isDateOutsideRange(dateValue, min, max),
      selected: !!selectedValue.find((date) => date && date.month === value && date.year === focusedValue.year),
      valueText: formatter.format(dateValue.toDate(timeZone)),
      inRange: isInSelectedRange || isInHoveredRange,
      firstInRange: !!isFirstInSelectedRange,
      lastInRange: !!isLastInSelectedRange,
      inHoveredRange: !!isInHoveredRange,
      firstInHoveredRange: !!isFirstInHoveredRange,
      lastInHoveredRange: !!isLastInHoveredRange,
      outsideRange: false,
      value: dateValue,
      get disabled() {
        return disabled2 || !cellState.selectable;
      }
    };
    return cellState;
  }
  function getDayTableCellState(props) {
    const { value, disabled: disabled2, visibleRange = computed("visibleRange") } = props;
    const formatter = getDayFormatter(locale, timeZone, focusedValue);
    const unitDuration = getUnitDuration(computed("visibleDuration"));
    const outsideDaySelectable = prop("outsideDaySelectable");
    const end = visibleRange.start.add(unitDuration).subtract({ days: 1 });
    const isOutsideRange = isDateOutsideRange(value, visibleRange.start, end);
    const isInSelectedRange = isRangePicker && isDateWithinRange(value, selectedValue);
    const isFirstInSelectedRange = isRangePicker && selectedValue[0] && $ad063034c8620db8$export$ea39ec197993aef0(value, selectedValue[0]);
    const isLastInSelectedRange = isRangePicker && selectedValue[1] && $ad063034c8620db8$export$ea39ec197993aef0(value, selectedValue[1]);
    const hasHoveredRange = isRangePicker && hoveredRangeValue.length > 0;
    const isInHoveredRange = hasHoveredRange && isDateWithinRange(value, hoveredRangeValue);
    const isFirstInHoveredRange = hasHoveredRange && hoveredRangeValue[0] && $ad063034c8620db8$export$ea39ec197993aef0(value, hoveredRangeValue[0]);
    const isLastInHoveredRange = hasHoveredRange && hoveredRangeValue[1] && $ad063034c8620db8$export$ea39ec197993aef0(value, hoveredRangeValue[1]);
    const isSelected = selectedValue.some((date) => date != null && $ad063034c8620db8$export$ea39ec197993aef0(value, date));
    const cellState = {
      invalid: isDateOutsideRange(value, min, max),
      disabled: disabled2 || !outsideDaySelectable && isOutsideRange || isDateOutsideRange(value, min, max) || // Disable unselected dates when max is reached in multiple selection mode
      isMaxSelected && !isSelected,
      selected: isSelected,
      unavailable: isDateUnavailable(value, isDateUnavailableFn, locale, min, max) && !disabled2,
      outsideRange: isOutsideRange,
      today: $ad063034c8620db8$export$629b0a497aa65267(value, timeZone),
      weekend: $ad063034c8620db8$export$618d60ea299da42(value, locale),
      value,
      valueText: formatter.format(value.toDate(timeZone)),
      get focused() {
        return focusedValue != null && $ad063034c8620db8$export$ea39ec197993aef0(value, focusedValue) && (!cellState.outsideRange || outsideDaySelectable);
      },
      get selectable() {
        return !cellState.disabled && !cellState.unavailable;
      },
      // Range states
      inRange: isInSelectedRange || isInHoveredRange,
      firstInRange: isFirstInSelectedRange,
      lastInRange: isLastInSelectedRange,
      // Preview range states
      inHoveredRange: isInHoveredRange,
      firstInHoveredRange: isFirstInHoveredRange,
      lastInHoveredRange: isLastInHoveredRange
    };
    return cellState;
  }
  function getTableId2(props) {
    const { view = "day", id } = props;
    return [view, id].filter(Boolean).join(" ");
  }
  return {
    focused,
    open,
    disabled,
    invalid,
    readOnly,
    inline: !!prop("inline"),
    numOfMonths: prop("numOfMonths"),
    showWeekNumbers: !!prop("showWeekNumbers"),
    selectionMode: prop("selectionMode"),
    maxSelectedDates,
    isMaxSelected,
    view: context.get("view"),
    getRangePresetValue(preset) {
      return getDateRangePreset(preset, locale, timeZone);
    },
    getWeekNumber(week) {
      const firstDay = week[0];
      return firstDay ? getWeekOfYear(firstDay, locale) : 0;
    },
    getDaysInWeek(week, from = startValue) {
      return getDaysInWeek(week, from, locale, startOfWeek);
    },
    getOffset(duration) {
      const from = startValue.add(duration);
      const end = endValue.add(duration);
      const formatter = getMonthFormatter(locale, timeZone, focusedValue);
      return {
        visibleRange: { start: from, end },
        weeks: getMonthWeeks(from),
        visibleRangeText: {
          start: formatter.format(from.toDate(timeZone)),
          end: formatter.format(end.toDate(timeZone))
        }
      };
    },
    getMonthWeeks,
    isUnavailable,
    weeks: getMonthWeeks(),
    weekDays: getWeekDays(startValue, startOfWeek, timeZone, locale),
    visibleRangeText: computed("visibleRangeText"),
    value: selectedValue,
    valueAsDate: selectedValue.filter((date) => date != null).map((date) => date.toDate(timeZone)),
    valueAsString: computed("valueAsString"),
    focusedValue,
    focusedValueAsDate: focusedValue?.toDate(timeZone),
    focusedValueAsString: prop("format")(focusedValue, { locale, timeZone }),
    visibleRange: computed("visibleRange"),
    selectToday() {
      const value = constrainValue(getTodayDate(timeZone, focusedValue.calendar), min, max);
      send({ type: "VALUE.SET", value: [value] });
    },
    setValue(values) {
      const computedValue = values.map((date) => constrainValue(date, min, max));
      send({ type: "VALUE.SET", value: computedValue });
    },
    setTime(time, index = 0) {
      const values = Array.from(selectedValue);
      let dateValue = values[index];
      if (!dateValue) return;
      if (!("hour" in dateValue)) {
        dateValue = $d07e34cce18680fd$export$b21e0b124e224484(dateValue);
      }
      dateValue = dateValue.set({
        hour: time.hour ?? ("hour" in dateValue ? dateValue.hour : 0),
        minute: time.minute ?? ("minute" in dateValue ? dateValue.minute : 0),
        second: time.second ?? ("second" in dateValue ? dateValue.second : 0),
        millisecond: time.millisecond ?? ("millisecond" in dateValue ? dateValue.millisecond : 0)
      });
      values[index] = constrainValue(dateValue, min, max);
      send({ type: "VALUE.SET", value: values });
    },
    clearValue(options = {}) {
      const { focus = true } = options;
      send({ type: "VALUE.CLEAR", focus });
    },
    setFocusedValue(value) {
      send({ type: "FOCUS.SET", value });
    },
    setOpen(nextOpen) {
      if (prop("inline")) return;
      const open2 = state.matches("open");
      if (open2 === nextOpen) return;
      send({ type: nextOpen ? "OPEN" : "CLOSE" });
    },
    focusMonth,
    focusYear,
    getYears,
    getMonths,
    getYearsGrid(props = {}) {
      const { columns = 1 } = props;
      const years = getDecadeRange(startValue.year, { strict: true }).map((year) => ({
        label: year.toString(),
        value: year,
        disabled: !isValueWithinRange(year, min?.year, max?.year)
      }));
      return chunk(years, columns);
    },
    getDecade() {
      const years = getDecadeRange(startValue.year, { strict: true });
      return { start: years.at(0), end: years.at(-1) };
    },
    getMonthsGrid(props = {}) {
      const { columns = 1, format } = props;
      return chunk(getMonths({ format }), columns);
    },
    format(value, opts = { month: "long", year: "numeric" }) {
      return new $12a3c853105e5a70$export$ad991b66133851cf(locale, {
        ...opts,
        calendar: value.calendar.identifier
      }).format(value.toDate(timeZone));
    },
    setView(view) {
      send({ type: "VIEW.SET", view });
    },
    goToNext() {
      send({ type: "GOTO.NEXT", view: context.get("view") });
    },
    goToPrev() {
      send({ type: "GOTO.PREV", view: context.get("view") });
    },
    getRootProps() {
      return normalize.element({
        ...parts.root.attrs,
        dir: prop("dir"),
        id: getRootId(scope),
        "data-state": open ? "open" : "closed",
        "data-disabled": dataAttr(disabled),
        "data-readonly": dataAttr(readOnly),
        "data-empty": dataAttr(empty)
      });
    },
    getLabelProps(props = {}) {
      const { index = 0 } = props;
      return normalize.label({
        ...parts.label.attrs,
        id: getLabelId(scope, index),
        dir: prop("dir"),
        htmlFor: getInputId(scope, index),
        "data-state": open ? "open" : "closed",
        "data-index": index,
        "data-disabled": dataAttr(disabled),
        "data-readonly": dataAttr(readOnly)
      });
    },
    getControlProps() {
      return normalize.element({
        ...parts.control.attrs,
        dir: prop("dir"),
        id: getControlId(scope),
        "data-disabled": dataAttr(disabled),
        "data-placeholder-shown": dataAttr(empty)
      });
    },
    getRangeTextProps() {
      return normalize.element({
        ...parts.rangeText.attrs,
        dir: prop("dir")
      });
    },
    getContentProps() {
      return normalize.element({
        ...parts.content.attrs,
        hidden: !open,
        dir: prop("dir"),
        "data-state": open ? "open" : "closed",
        "data-placement": currentPlacement,
        "data-side": currentPlacementSide,
        "data-inline": dataAttr(prop("inline")),
        id: getContentId(scope),
        tabIndex: -1,
        role: "application",
        "aria-roledescription": "datepicker",
        "aria-label": translations.content
      });
    },
    getTableProps(props = {}) {
      const { view = "day", columns = view === "day" ? 7 : 4 } = props;
      const uid = getTableId2(props);
      return normalize.element({
        ...parts.table.attrs,
        role: "grid",
        "data-columns": columns,
        "aria-roledescription": getRoleDescription(view),
        id: getTableId(scope, uid),
        "aria-readonly": ariaAttr(readOnly),
        "aria-disabled": ariaAttr(disabled),
        "aria-multiselectable": ariaAttr(prop("selectionMode") !== "single"),
        "data-view": view,
        dir: prop("dir"),
        tabIndex: -1,
        onKeyDown(event) {
          if (event.defaultPrevented) return;
          if (disabled) return;
          const keyMap = {
            Enter() {
              if (!interactive) return;
              if (view === "day" && isUnavailable(focusedValue)) return;
              if (view === "month") {
                const cellState = getMonthTableCellState({ value: focusedValue.month });
                if (!cellState.selectable) return;
              }
              if (view === "year") {
                const cellState = getYearTableCellState({ value: focusedValue.year });
                if (!cellState.selectable) return;
              }
              send({ type: "TABLE.ENTER", view, columns, focus: true });
            },
            ArrowLeft() {
              send({ type: "TABLE.ARROW_LEFT", view, columns, focus: true });
            },
            ArrowRight() {
              send({ type: "TABLE.ARROW_RIGHT", view, columns, focus: true });
            },
            ArrowUp() {
              send({ type: "TABLE.ARROW_UP", view, columns, focus: true });
            },
            ArrowDown() {
              send({ type: "TABLE.ARROW_DOWN", view, columns, focus: true });
            },
            PageUp(event2) {
              send({ type: "TABLE.PAGE_UP", larger: event2.shiftKey, view, columns, focus: true });
            },
            PageDown(event2) {
              send({ type: "TABLE.PAGE_DOWN", larger: event2.shiftKey, view, columns, focus: true });
            },
            Home() {
              send({ type: "TABLE.HOME", view, columns, focus: true });
            },
            End() {
              send({ type: "TABLE.END", view, columns, focus: true });
            }
          };
          const exec = keyMap[getEventKey(event, {
            dir: prop("dir")
          })];
          if (exec) {
            exec(event);
            event.preventDefault();
            event.stopPropagation();
          }
        },
        onPointerLeave() {
          send({ type: "TABLE.POINTER_LEAVE" });
        },
        onPointerDown() {
          send({ type: "TABLE.POINTER_DOWN", view });
        },
        onPointerUp() {
          send({ type: "TABLE.POINTER_UP", view });
        }
      });
    },
    getTableHeadProps(props = {}) {
      const { view = "day" } = props;
      return normalize.element({
        ...parts.tableHead.attrs,
        "aria-hidden": true,
        dir: prop("dir"),
        "data-view": view,
        "data-disabled": dataAttr(disabled)
      });
    },
    getTableHeaderProps(props = {}) {
      const { view = "day" } = props;
      return normalize.element({
        ...parts.tableHeader.attrs,
        dir: prop("dir"),
        "data-view": view,
        "data-disabled": dataAttr(disabled)
      });
    },
    getTableBodyProps(props = {}) {
      const { view = "day" } = props;
      return normalize.element({
        ...parts.tableBody.attrs,
        "data-view": view,
        "data-disabled": dataAttr(disabled)
      });
    },
    getTableRowProps(props = {}) {
      const { view = "day" } = props;
      return normalize.element({
        ...parts.tableRow.attrs,
        "aria-disabled": ariaAttr(disabled),
        "data-disabled": dataAttr(disabled),
        "data-view": view
      });
    },
    getWeekNumberHeaderCellProps(props = {}) {
      const { view = "day" } = props;
      return normalize.element({
        ...parts.tableCell.attrs,
        scope: "col",
        "aria-label": translations.weekColumnHeader,
        "data-view": view,
        "data-type": "week-number",
        "data-disabled": dataAttr(disabled)
      });
    },
    getWeekNumberCellProps(props) {
      const { weekIndex, week } = props;
      const weekNumber = week[0] ? getWeekOfYear(week[0], locale) : 0;
      return normalize.element({
        ...parts.tableCell.attrs,
        role: "rowheader",
        "aria-label": translations.weekNumberCell?.(weekNumber),
        "data-view": "day",
        "data-week-index": weekIndex,
        "data-type": "week-number",
        "data-disabled": dataAttr(disabled)
      });
    },
    getDayTableCellState,
    getDayTableCellProps(props) {
      const { value } = props;
      const cellState = getDayTableCellState(props);
      return normalize.element({
        ...parts.tableCell.attrs,
        role: "gridcell",
        "aria-disabled": ariaAttr(!cellState.selectable),
        "aria-selected": cellState.selected || cellState.inRange,
        "aria-invalid": ariaAttr(cellState.invalid),
        "aria-current": cellState.today ? "date" : void 0,
        "data-value": value.toString()
      });
    },
    getDayTableCellTriggerProps(props) {
      const { value } = props;
      const cellState = getDayTableCellState(props);
      return normalize.element({
        ...parts.tableCellTrigger.attrs,
        id: getCellTriggerId(scope, value.toString()),
        role: "button",
        dir: prop("dir"),
        tabIndex: disabled ? -1 : cellState.focused ? 0 : -1,
        "aria-label": translations.dayCell(cellState),
        "aria-disabled": ariaAttr(!cellState.selectable),
        "aria-invalid": ariaAttr(cellState.invalid),
        "data-disabled": dataAttr(!cellState.selectable),
        "data-selectable": dataAttr(cellState.selectable),
        "data-selected": dataAttr(cellState.selected),
        "data-value": value.toString(),
        "data-view": "day",
        "data-today": dataAttr(cellState.today),
        "data-focus": dataAttr(cellState.focused),
        "data-unavailable": dataAttr(cellState.unavailable),
        "data-range-start": dataAttr(cellState.firstInRange),
        "data-range-end": dataAttr(cellState.lastInRange),
        "data-in-range": dataAttr(cellState.inRange),
        "data-outside-range": dataAttr(cellState.outsideRange),
        "data-weekend": dataAttr(cellState.weekend),
        "data-in-hover-range": dataAttr(cellState.inHoveredRange),
        "data-hover-range-start": dataAttr(cellState.firstInHoveredRange),
        "data-hover-range-end": dataAttr(cellState.lastInHoveredRange),
        onClick(event) {
          if (event.defaultPrevented) return;
          if (!interactive) return;
          if (!cellState.selectable) return;
          send({ type: "CELL.CLICK", cell: "day", value });
        },
        onPointerMove: isRangePicker ? (event) => {
          if (event.pointerType === "touch") return;
          if (!cellState.selectable) return;
          const focus = !scope.isActiveElement(event.currentTarget);
          if (hoveredValue && $ad063034c8620db8$export$91b62ebf2ba703ee(value, hoveredValue)) return;
          send({
            type: "CELL.POINTER_MOVE",
            cell: "day",
            value,
            focus,
            outsideRange: cellState.outsideRange
          });
        } : void 0
      });
    },
    getMonthTableCellState,
    getMonthTableCellProps(props) {
      const { value, columns } = props;
      const cellState = getMonthTableCellState(props);
      return normalize.element({
        ...parts.tableCell.attrs,
        dir: prop("dir"),
        colSpan: columns,
        role: "gridcell",
        "aria-selected": ariaAttr(cellState.selected || cellState.inRange),
        "data-selected": dataAttr(cellState.selected),
        "aria-disabled": ariaAttr(!cellState.selectable),
        "data-value": value
      });
    },
    getMonthTableCellTriggerProps(props) {
      const { value } = props;
      const cellState = getMonthTableCellState(props);
      return normalize.element({
        ...parts.tableCellTrigger.attrs,
        id: getCellTriggerId(scope, value.toString()),
        role: "button",
        dir: prop("dir"),
        tabIndex: disabled ? -1 : cellState.focused ? 0 : -1,
        "aria-label": cellState.valueText,
        "aria-disabled": ariaAttr(!cellState.selectable),
        "data-disabled": dataAttr(!cellState.selectable),
        "data-selectable": dataAttr(cellState.selectable),
        "data-selected": dataAttr(cellState.selected),
        "data-value": value,
        "data-view": "month",
        "data-focus": dataAttr(cellState.focused),
        "data-outside-range": dataAttr(cellState.outsideRange),
        "data-range-start": dataAttr(cellState.firstInRange),
        "data-range-end": dataAttr(cellState.lastInRange),
        "data-in-range": dataAttr(cellState.inRange),
        "data-in-hover-range": dataAttr(cellState.inHoveredRange),
        "data-hover-range-start": dataAttr(cellState.firstInHoveredRange),
        "data-hover-range-end": dataAttr(cellState.lastInHoveredRange),
        onClick(event) {
          if (event.defaultPrevented) return;
          if (!interactive) return;
          if (!cellState.selectable) return;
          send({ type: "CELL.CLICK", cell: "month", value });
        },
        onPointerMove: isRangePicker ? (event) => {
          if (event.pointerType === "touch") return;
          if (!cellState.selectable) return;
          const focus = !scope.isActiveElement(event.currentTarget);
          if (hoveredValue && cellState.value && $ad063034c8620db8$export$5a8da0c44a3afdf2(cellState.value, hoveredValue)) return;
          send({ type: "CELL.POINTER_MOVE", cell: "month", value: cellState.value, focus });
        } : void 0
      });
    },
    getYearTableCellState,
    getYearTableCellProps(props) {
      const { value, columns } = props;
      const cellState = getYearTableCellState(props);
      return normalize.element({
        ...parts.tableCell.attrs,
        dir: prop("dir"),
        colSpan: columns,
        role: "gridcell",
        "aria-selected": ariaAttr(cellState.selected || cellState.inRange),
        "data-selected": dataAttr(cellState.selected),
        "aria-disabled": ariaAttr(!cellState.selectable),
        "data-value": value
      });
    },
    getYearTableCellTriggerProps(props) {
      const { value } = props;
      const cellState = getYearTableCellState(props);
      return normalize.element({
        ...parts.tableCellTrigger.attrs,
        id: getCellTriggerId(scope, value.toString()),
        role: "button",
        dir: prop("dir"),
        tabIndex: disabled ? -1 : cellState.focused ? 0 : -1,
        "aria-label": cellState.valueText,
        "aria-disabled": ariaAttr(!cellState.selectable),
        "data-disabled": dataAttr(!cellState.selectable),
        "data-selectable": dataAttr(cellState.selectable),
        "data-selected": dataAttr(cellState.selected),
        "data-value": value,
        "data-view": "year",
        "data-focus": dataAttr(cellState.focused),
        "data-outside-range": dataAttr(cellState.outsideRange),
        "data-range-start": dataAttr(cellState.firstInRange),
        "data-range-end": dataAttr(cellState.lastInRange),
        "data-in-range": dataAttr(cellState.inRange),
        "data-in-hover-range": dataAttr(cellState.inHoveredRange),
        "data-hover-range-start": dataAttr(cellState.firstInHoveredRange),
        "data-hover-range-end": dataAttr(cellState.lastInHoveredRange),
        onClick(event) {
          if (event.defaultPrevented) return;
          if (!interactive) return;
          if (!cellState.selectable) return;
          send({ type: "CELL.CLICK", cell: "year", value });
        },
        onPointerMove: isRangePicker ? (event) => {
          if (event.pointerType === "touch") return;
          if (!cellState.selectable) return;
          const focus = !scope.isActiveElement(event.currentTarget);
          if (hoveredValue && cellState.value && $ad063034c8620db8$export$ea840f5a6dda8147(cellState.value, hoveredValue)) return;
          send({ type: "CELL.POINTER_MOVE", cell: "year", value: cellState.value, focus });
        } : void 0
      });
    },
    getNextTriggerProps(props = {}) {
      const { view = "day" } = props;
      const isDisabled = disabled || !computed("isNextVisibleRangeValid");
      return normalize.button({
        ...parts.nextTrigger.attrs,
        dir: prop("dir"),
        id: getNextTriggerId(scope, view),
        type: "button",
        "aria-label": translations.nextTrigger(view),
        disabled: isDisabled,
        "data-disabled": dataAttr(isDisabled),
        onClick(event) {
          if (event.defaultPrevented) return;
          send({ type: "GOTO.NEXT", view });
        }
      });
    },
    getPrevTriggerProps(props = {}) {
      const { view = "day" } = props;
      const isDisabled = disabled || !computed("isPrevVisibleRangeValid");
      return normalize.button({
        ...parts.prevTrigger.attrs,
        dir: prop("dir"),
        id: getPrevTriggerId(scope, view),
        type: "button",
        "aria-label": translations.prevTrigger(view),
        disabled: isDisabled,
        "data-disabled": dataAttr(isDisabled),
        onClick(event) {
          if (event.defaultPrevented) return;
          send({ type: "GOTO.PREV", view });
        }
      });
    },
    getClearTriggerProps() {
      return normalize.button({
        ...parts.clearTrigger.attrs,
        id: getClearTriggerId(scope),
        dir: prop("dir"),
        type: "button",
        "aria-label": translations.clearTrigger,
        hidden: !selectedValue.length,
        onClick(event) {
          if (event.defaultPrevented) return;
          if (!interactive) return;
          send({ type: "VALUE.CLEAR" });
        }
      });
    },
    getTriggerProps() {
      return normalize.button({
        ...parts.trigger.attrs,
        id: getTriggerId(scope),
        dir: prop("dir"),
        type: "button",
        "data-placement": currentPlacement,
        "data-side": currentPlacementSide,
        "aria-label": translations.trigger(open),
        "aria-controls": getContentId(scope),
        "aria-expanded": open,
        "data-state": open ? "open" : "closed",
        "data-placeholder-shown": dataAttr(empty),
        "aria-haspopup": "grid",
        disabled,
        onClick(event) {
          if (event.defaultPrevented) return;
          if (!interactive) return;
          send({ type: "TRIGGER.CLICK" });
        }
      });
    },
    getViewProps(props = {}) {
      const { view = "day" } = props;
      return normalize.element({
        ...parts.view.attrs,
        "data-view": view,
        hidden: context.get("view") !== view
      });
    },
    getViewTriggerProps(props = {}) {
      const { view = "day" } = props;
      const nextView = getNextView(view, prop("minView"), prop("maxView"));
      const hasNextView = nextView !== view;
      const isDisabled = disabled || !hasNextView;
      return normalize.button({
        ...parts.viewTrigger.attrs,
        "data-view": view,
        dir: prop("dir"),
        id: getViewTriggerId(scope, view),
        type: "button",
        disabled: isDisabled,
        "data-disabled": dataAttr(isDisabled),
        "aria-label": translations.viewTrigger(view, hasNextView ? nextView : void 0),
        onClick(event) {
          if (event.defaultPrevented) return;
          if (!interactive) return;
          send({ type: "VIEW.TOGGLE", src: "viewTrigger" });
        }
      });
    },
    getViewControlProps(props = {}) {
      const { view = "day" } = props;
      return normalize.element({
        ...parts.viewControl.attrs,
        "data-view": view,
        dir: prop("dir")
      });
    },
    getInputProps(props = {}) {
      const { index = 0, fixOnBlur = true } = props;
      return normalize.input({
        ...parts.input.attrs,
        id: getInputId(scope, index),
        autoComplete: "off",
        autoCorrect: "off",
        spellCheck: "false",
        dir: prop("dir"),
        name: prop("name"),
        "data-index": index,
        "data-state": open ? "open" : "closed",
        "data-placeholder-shown": dataAttr(empty),
        readOnly,
        disabled,
        required: prop("required"),
        "aria-invalid": ariaAttr(invalid),
        "data-invalid": dataAttr(invalid),
        placeholder: prop("placeholder") || getInputPlaceholder(locale),
        defaultValue: computed("valueAsString")[index],
        onBeforeInput(event) {
          const { data } = getNativeEvent(event);
          if (!isValidCharacter(data, separator, locale)) {
            event.preventDefault();
          }
        },
        onClick(event) {
          if (event.defaultPrevented) return;
          if (!prop("openOnClick")) return;
          if (!interactive) return;
          send({ type: "OPEN", src: "input.click" });
        },
        onFocus() {
          send({ type: "INPUT.FOCUS", index });
        },
        onBlur(event) {
          const value = event.currentTarget.value.trim();
          send({ type: "INPUT.BLUR", value, index, fixOnBlur });
        },
        onKeyDown(event) {
          if (event.defaultPrevented) return;
          if (!interactive) return;
          const keyMap = {
            Enter(event2) {
              if (isComposingEvent(event2)) return;
              if (isUnavailable(focusedValue)) return;
              if (event2.currentTarget.value.trim() === "") return;
              send({ type: "INPUT.ENTER", value: event2.currentTarget.value, index });
            }
          };
          const exec = keyMap[event.key];
          if (exec) {
            exec(event);
            event.preventDefault();
          }
        },
        onInput(event) {
          const value = event.currentTarget.value;
          send({ type: "INPUT.CHANGE", value: ensureValidCharacters(value, separator, locale), index });
        }
      });
    },
    getMonthSelectProps() {
      return normalize.select({
        ...parts.monthSelect.attrs,
        id: getMonthSelectId(scope),
        "aria-label": translations.monthSelect,
        disabled,
        dir: prop("dir"),
        defaultValue: startValue.month,
        onChange(event) {
          focusMonth(Number(event.currentTarget.value));
        }
      });
    },
    getYearSelectProps() {
      return normalize.select({
        ...parts.yearSelect.attrs,
        id: getYearSelectId(scope),
        disabled,
        "aria-label": translations.yearSelect,
        dir: prop("dir"),
        defaultValue: startValue.year,
        onChange(event) {
          focusYear(Number(event.currentTarget.value));
        }
      });
    },
    getPositionerProps() {
      return normalize.element({
        id: getPositionerId(scope),
        ...parts.positioner.attrs,
        dir: prop("dir"),
        style: popperStyles.floating
      });
    },
    getPresetTriggerProps(props) {
      const value = Array.isArray(props.value) ? props.value : getDateRangePreset(props.value, locale, timeZone);
      const valueAsString = value.filter((item) => item != null).map((item) => item.toDate(timeZone).toDateString());
      return normalize.button({
        ...parts.presetTrigger.attrs,
        "aria-label": translations.presetTrigger(valueAsString),
        type: "button",
        onClick(event) {
          if (event.defaultPrevented) return;
          if (!interactive) return;
          send({ type: "PRESET.CLICK", value });
        }
      });
    }
  };
}

// ../node_modules/.pnpm/@zag-js+date-picker@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-picker/dist/date-picker.machine.mjs
var { and } = createGuards();
function isDateArrayEqual(a, b) {
  if (a?.length !== b?.length) return false;
  const len = Math.max(a.length, b.length);
  for (let i = 0; i < len; i++) {
    if (!isDateEqual(a[i], b[i])) return false;
  }
  return true;
}
function getValueAsString(value, prop) {
  return value.map((date) => {
    if (date == null) return "";
    return prop("format")(date, { locale: prop("locale"), timeZone: prop("timeZone") });
  });
}
var machine = createMachine({
  props({ props }) {
    const locale = props.locale || "en-US";
    const timeZone = props.timeZone || "UTC";
    const selectionMode = props.selectionMode || "single";
    const numOfMonths = props.numOfMonths || 1;
    let calendar;
    if (props.createCalendar) {
      const resolved = new Intl.DateTimeFormat(locale).resolvedOptions();
      const calendarId = resolved.calendar;
      if (calendarId !== "gregory" && calendarId !== "iso8601") {
        calendar = props.createCalendar(calendarId);
      }
    }
    const toTargetCalendar = (date) => {
      if (!calendar) return date;
      if (date.calendar.identifier === calendar.identifier) return date;
      return $d07e34cce18680fd$export$b4a036af3fc0b032(date, calendar);
    };
    const defaultValue = props.defaultValue ? sortDates(props.defaultValue).map((date) => constrainValue(toTargetCalendar(date), props.min, props.max)) : void 0;
    const value = props.value ? sortDates(props.value).map((date) => constrainValue(toTargetCalendar(date), props.min, props.max)) : void 0;
    let focusedValue = props.focusedValue || props.defaultFocusedValue || value?.[0] || defaultValue?.[0] || getTodayDate(timeZone, calendar);
    focusedValue = constrainValue(toTargetCalendar(focusedValue), props.min, props.max);
    const minView = props.minView || "day";
    const maxView = props.maxView || "year";
    const defaultView = clampView(props.defaultView || props.view || minView, minView, maxView);
    return {
      locale,
      numOfMonths,
      timeZone,
      selectionMode,
      minView,
      maxView,
      outsideDaySelectable: false,
      closeOnSelect: true,
      format(date, { locale: locale2, timeZone: timeZone2 }) {
        const formatter = new $12a3c853105e5a70$export$ad991b66133851cf(locale2, {
          timeZone: timeZone2,
          day: "2-digit",
          month: "2-digit",
          year: "numeric",
          calendar: calendar?.identifier
        });
        return formatter.format(date.toDate(timeZone2));
      },
      parse(value2, { locale: locale2, timeZone: timeZone2 }) {
        return parseDateString(value2, locale2, timeZone2);
      },
      ...props,
      focusedValue: typeof props.focusedValue === "undefined" ? void 0 : focusedValue,
      defaultFocusedValue: focusedValue,
      value,
      defaultValue: defaultValue ?? [],
      defaultView,
      positioning: {
        placement: "bottom",
        ...props.positioning
      }
    };
  },
  initialState({ prop }) {
    const open = prop("inline") || (prop("open") ?? prop("defaultOpen"));
    return open ? "open" : "idle";
  },
  refs() {
    return {
      announcer: void 0
    };
  },
  context({ prop, bindable, getContext }) {
    return {
      focusedValue: bindable(() => ({
        defaultValue: prop("defaultFocusedValue"),
        value: prop("focusedValue"),
        isEqual: isDateEqual,
        hash: (v) => v.toString(),
        sync: true,
        onChange(focusedValue) {
          const context = getContext();
          const view = context.get("view");
          const value = context.get("value");
          const valueAsString = getValueAsString(value, prop);
          prop("onFocusChange")?.({ value, valueAsString, view, focusedValue });
        }
      })),
      value: bindable(() => ({
        defaultValue: prop("defaultValue"),
        value: prop("value"),
        isEqual: isDateArrayEqual,
        hash: (v) => v.map((date) => date?.toString() ?? "").join(","),
        onChange(value) {
          const context = getContext();
          const valueAsString = getValueAsString(value, prop);
          prop("onValueChange")?.({ value, valueAsString, view: context.get("view") });
        }
      })),
      inputValue: bindable(() => ({
        defaultValue: ""
      })),
      activeIndex: bindable(() => ({
        defaultValue: 0,
        sync: true
      })),
      hoveredValue: bindable(() => ({
        defaultValue: null,
        isEqual: isDateEqual
      })),
      view: bindable(() => ({
        defaultValue: prop("defaultView"),
        value: prop("view"),
        onChange(value) {
          prop("onViewChange")?.({ view: value });
        }
      })),
      startValue: bindable(() => {
        const focusedValue = prop("focusedValue") || prop("defaultFocusedValue");
        return {
          defaultValue: alignDate(focusedValue, "start", { months: prop("numOfMonths") }, prop("locale")),
          isEqual: isDateEqual,
          hash: (v) => v.toString()
        };
      }),
      currentPlacement: bindable(() => ({
        defaultValue: void 0
      })),
      restoreFocus: bindable(() => ({
        defaultValue: false
      }))
    };
  },
  computed: {
    isInteractive: ({ prop }) => !prop("disabled") && !prop("readOnly"),
    visibleDuration: ({ prop }) => ({ months: prop("numOfMonths") }),
    endValue: ({ context, computed }) => getEndDate(context.get("startValue"), computed("visibleDuration")),
    visibleRange: ({ context, computed }) => ({ start: context.get("startValue"), end: computed("endValue") }),
    visibleRangeText: ({ context, prop, computed }) => getVisibleRangeText({
      view: context.get("view"),
      startValue: context.get("startValue"),
      endValue: computed("endValue"),
      locale: prop("locale"),
      timeZone: prop("timeZone"),
      selectionMode: prop("selectionMode")
    }),
    isPrevVisibleRangeValid: ({ context, prop }) => !isPreviousRangeInvalid(context.get("startValue"), prop("min"), prop("max")),
    isNextVisibleRangeValid: ({ prop, computed }) => !isNextRangeInvalid(computed("endValue"), prop("min"), prop("max")),
    valueAsString: ({ context, prop }) => getValueAsString(context.get("value"), prop)
  },
  effects: ["setupLiveRegion"],
  watch({ track, prop, context, action, computed }) {
    track([() => prop("locale")], () => {
      action(["setStartValue", "syncInputElement"]);
    });
    track([() => context.hash("focusedValue")], () => {
      action(["setStartValue", "focusActiveCellIfNeeded", "setHoveredValueIfKeyboard"]);
    });
    track([() => context.hash("startValue")], () => {
      action(["syncMonthSelectElement", "syncYearSelectElement", "invokeOnVisibleRangeChange"]);
    });
    track([() => context.get("inputValue")], () => {
      action(["syncInputValue"]);
    });
    track([() => context.hash("value")], () => {
      action(["syncInputElement"]);
    });
    track([() => computed("valueAsString").toString()], () => {
      action(["announceValueText"]);
    });
    track([() => context.get("view")], () => {
      action(["focusActiveCell"]);
    });
    track([() => prop("open")], () => {
      action(["toggleVisibility"]);
    });
  },
  on: {
    "VALUE.SET": {
      actions: ["setDateValue", "setFocusedDate"]
    },
    "VIEW.SET": {
      actions: ["setView"]
    },
    "FOCUS.SET": {
      actions: ["setFocusedDate"]
    },
    "VALUE.CLEAR": {
      actions: [
        "clearDateValue",
        "clearFocusedDate",
        "setActiveIndexToStart",
        "clearHoveredDate",
        "focusFirstInputElement"
      ]
    },
    "INPUT.CHANGE": [
      {
        guard: "isInputValueEmpty",
        actions: ["setInputValue", "clearDateValue", "clearFocusedDate"]
      },
      {
        actions: ["setInputValue", "focusParsedDate"]
      }
    ],
    "INPUT.ENTER": {
      actions: ["focusParsedDate", "selectFocusedDate"]
    },
    "INPUT.FOCUS": {
      actions: ["setActiveIndex"]
    },
    "INPUT.BLUR": [
      {
        guard: "shouldFixOnBlur",
        actions: ["setActiveIndexToStart", "selectParsedDate"]
      },
      {
        actions: ["setActiveIndexToStart"]
      }
    ],
    "PRESET.CLICK": [
      {
        guard: "isOpenControlled",
        actions: ["setDateValue", "setFocusedDate", "invokeOnClose"]
      },
      {
        target: "focused",
        actions: ["setDateValue", "setFocusedDate", "focusInputElement"]
      }
    ],
    "GOTO.NEXT": [
      {
        guard: "isYearView",
        actions: ["focusNextDecade", "announceVisibleRange"]
      },
      {
        guard: "isMonthView",
        actions: ["focusNextYear", "announceVisibleRange"]
      },
      {
        actions: ["focusNextPage"]
      }
    ],
    "GOTO.PREV": [
      {
        guard: "isYearView",
        actions: ["focusPreviousDecade", "announceVisibleRange"]
      },
      {
        guard: "isMonthView",
        actions: ["focusPreviousYear", "announceVisibleRange"]
      },
      {
        actions: ["focusPreviousPage"]
      }
    ]
  },
  states: {
    idle: {
      tags: ["closed"],
      on: {
        "CONTROLLED.OPEN": {
          target: "open",
          actions: ["resetView", "focusFirstSelectedDate", "focusActiveCell"]
        },
        "TRIGGER.CLICK": [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["resetView", "focusFirstSelectedDate", "focusActiveCell", "invokeOnOpen"]
          }
        ],
        OPEN: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["resetView", "focusFirstSelectedDate", "focusActiveCell", "invokeOnOpen"]
          }
        ]
      }
    },
    focused: {
      tags: ["closed"],
      on: {
        "CONTROLLED.OPEN": {
          target: "open",
          actions: ["resetView", "focusFirstSelectedDate", "focusActiveCell"]
        },
        "TRIGGER.CLICK": [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["resetView", "focusFirstSelectedDate", "focusActiveCell", "invokeOnOpen"]
          }
        ],
        OPEN: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["resetView", "focusFirstSelectedDate", "focusActiveCell", "invokeOnOpen"]
          }
        ]
      }
    },
    open: {
      tags: ["open"],
      entry: ["resumeRangeSelection"],
      effects: ["trackDismissableElement", "trackPositioning"],
      exit: ["clearHoveredDate"],
      on: {
        "CONTROLLED.CLOSE": [
          {
            guard: and("shouldRestoreFocus", "isInteractOutsideEvent"),
            target: "focused",
            actions: ["focusTriggerElement"]
          },
          {
            guard: "shouldRestoreFocus",
            target: "focused",
            actions: ["focusInputElement"]
          },
          {
            target: "idle"
          }
        ],
        "CELL.CLICK": [
          {
            guard: "isAboveMinView",
            actions: ["setFocusedValueForView", "setPreviousView"]
          },
          {
            guard: and("isRangePicker", "hasSelectedRange"),
            actions: ["setActiveIndexToStart", "resetSelection", "setActiveIndexToEnd"]
          },
          // === Grouped transitions (based on `closeOnSelect` and `isOpenControlled`) ===
          {
            guard: and("isRangePicker", "isSelectingEndDate", "closeOnSelect", "isOpenControlled"),
            actions: [
              "setFocusedDate",
              "setSelectedDate",
              "setActiveIndexToStart",
              "clearHoveredDate",
              "invokeOnClose",
              "setRestoreFocus"
            ]
          },
          {
            guard: and("isRangePicker", "isSelectingEndDate", "closeOnSelect"),
            target: "focused",
            actions: [
              "setFocusedDate",
              "setSelectedDate",
              "setActiveIndexToStart",
              "clearHoveredDate",
              "invokeOnClose",
              "focusInputElement"
            ]
          },
          {
            guard: and("isRangePicker", "isSelectingEndDate"),
            actions: ["setFocusedDate", "setSelectedDate", "setActiveIndexToStart", "clearHoveredDate"]
          },
          // ===
          {
            guard: "isRangePicker",
            actions: ["setFocusedDate", "setSelectedDate", "setActiveIndexToEnd"]
          },
          {
            guard: and("isMultiPicker", "canSelectDate"),
            actions: ["setFocusedDate", "toggleSelectedDate"]
          },
          {
            guard: "isMultiPicker",
            actions: ["setFocusedDate"]
          },
          // === Grouped transitions (based on `closeOnSelect` and `isOpenControlled`) ===
          {
            guard: and("closeOnSelect", "isOpenControlled"),
            actions: ["setFocusedDate", "setSelectedDate", "invokeOnClose"]
          },
          {
            guard: "closeOnSelect",
            target: "focused",
            actions: ["setFocusedDate", "setSelectedDate", "invokeOnClose", "focusInputElement"]
          },
          {
            actions: ["setFocusedDate", "setSelectedDate"]
          }
          // ===
        ],
        "CELL.POINTER_MOVE": [
          {
            guard: and("isRangePicker", "isSelectingEndDate", "isDayPointerMoveOutsideVisibleMonth"),
            actions: ["setHoveredDate"]
          },
          {
            guard: and("isRangePicker", "isSelectingEndDate"),
            actions: ["setHoveredDate", "setFocusedDate"]
          }
        ],
        "TABLE.POINTER_LEAVE": {
          guard: "isRangePicker",
          actions: ["clearHoveredDate"]
        },
        "TABLE.POINTER_DOWN": {
          actions: ["disableTextSelection"]
        },
        "TABLE.POINTER_UP": {
          actions: ["enableTextSelection"]
        },
        "TABLE.ESCAPE": [
          {
            guard: "isOpenControlled",
            actions: ["focusFirstSelectedDate", "invokeOnClose"]
          },
          {
            target: "focused",
            actions: ["focusFirstSelectedDate", "invokeOnClose", "focusTriggerElement"]
          }
        ],
        "TABLE.ENTER": [
          {
            guard: "isAboveMinView",
            actions: ["setPreviousView"]
          },
          {
            guard: and("isRangePicker", "hasSelectedRange"),
            actions: ["setActiveIndexToStart", "resetSelection", "setActiveIndexToEnd", "focusNextDay"]
          },
          // === Grouped transitions (based on `closeOnSelect` and `isOpenControlled`) ===
          {
            guard: and("isRangePicker", "isSelectingEndDate", "closeOnSelect", "isOpenControlled"),
            actions: ["setSelectedDate", "setActiveIndexToStart", "clearHoveredDate", "invokeOnClose"]
          },
          {
            guard: and("isRangePicker", "isSelectingEndDate", "closeOnSelect"),
            target: "focused",
            actions: [
              "setSelectedDate",
              "setActiveIndexToStart",
              "clearHoveredDate",
              "invokeOnClose",
              "focusInputElement"
            ]
          },
          {
            guard: and("isRangePicker", "isSelectingEndDate"),
            actions: ["setSelectedDate", "setActiveIndexToStart", "clearHoveredDate"]
          },
          // ===
          {
            guard: "isRangePicker",
            actions: ["setSelectedDate", "setActiveIndexToEnd", "focusNextDay"]
          },
          {
            guard: and("isMultiPicker", "canSelectDate"),
            actions: ["toggleSelectedDate"]
          },
          {
            guard: "isMultiPicker"
          },
          // === Grouped transitions (based on `closeOnSelect` and `isOpenControlled`) ===
          {
            guard: and("closeOnSelect", "isOpenControlled"),
            actions: ["selectFocusedDate", "invokeOnClose"]
          },
          {
            guard: "closeOnSelect",
            target: "focused",
            actions: ["selectFocusedDate", "invokeOnClose", "focusInputElement"]
          },
          {
            actions: ["selectFocusedDate"]
          }
          // ===
        ],
        "TABLE.ARROW_RIGHT": [
          {
            guard: "isMonthView",
            actions: ["focusNextMonth"]
          },
          {
            guard: "isYearView",
            actions: ["focusNextYear"]
          },
          {
            actions: ["focusNextDay", "setHoveredDate"]
          }
        ],
        "TABLE.ARROW_LEFT": [
          {
            guard: "isMonthView",
            actions: ["focusPreviousMonth"]
          },
          {
            guard: "isYearView",
            actions: ["focusPreviousYear"]
          },
          {
            actions: ["focusPreviousDay"]
          }
        ],
        "TABLE.ARROW_UP": [
          {
            guard: "isMonthView",
            actions: ["focusPreviousMonthColumn"]
          },
          {
            guard: "isYearView",
            actions: ["focusPreviousYearColumn"]
          },
          {
            actions: ["focusPreviousWeek"]
          }
        ],
        "TABLE.ARROW_DOWN": [
          {
            guard: "isMonthView",
            actions: ["focusNextMonthColumn"]
          },
          {
            guard: "isYearView",
            actions: ["focusNextYearColumn"]
          },
          {
            actions: ["focusNextWeek"]
          }
        ],
        "TABLE.PAGE_UP": {
          actions: ["focusPreviousSection"]
        },
        "TABLE.PAGE_DOWN": {
          actions: ["focusNextSection"]
        },
        "TABLE.HOME": [
          {
            guard: "isMonthView",
            actions: ["focusFirstMonth"]
          },
          {
            guard: "isYearView",
            actions: ["focusFirstYear"]
          },
          {
            actions: ["focusSectionStart"]
          }
        ],
        "TABLE.END": [
          {
            guard: "isMonthView",
            actions: ["focusLastMonth"]
          },
          {
            guard: "isYearView",
            actions: ["focusLastYear"]
          },
          {
            actions: ["focusSectionEnd"]
          }
        ],
        "TRIGGER.CLICK": [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnClose"]
          },
          {
            target: "focused",
            actions: ["invokeOnClose"]
          }
        ],
        "VIEW.TOGGLE": {
          actions: ["setNextView"]
        },
        INTERACT_OUTSIDE: [
          {
            guard: "isOpenControlled",
            actions: ["setActiveIndexToStart", "invokeOnClose"]
          },
          {
            guard: "shouldRestoreFocus",
            target: "focused",
            actions: ["setActiveIndexToStart", "invokeOnClose", "focusTriggerElement"]
          },
          {
            target: "idle",
            actions: ["setActiveIndexToStart", "invokeOnClose"]
          }
        ],
        CLOSE: [
          {
            guard: "isOpenControlled",
            actions: ["setActiveIndexToStart", "invokeOnClose"]
          },
          {
            target: "idle",
            actions: ["setActiveIndexToStart", "invokeOnClose"]
          }
        ]
      }
    }
  },
  implementations: {
    guards: {
      isAboveMinView: ({ context, prop }) => isAboveMinView(context.get("view"), prop("minView")),
      isDayView: ({ context, event }) => (event.view || context.get("view")) === "day",
      isMonthView: ({ context, event }) => (event.view || context.get("view")) === "month",
      isYearView: ({ context, event }) => (event.view || context.get("view")) === "year",
      isRangePicker: ({ prop }) => prop("selectionMode") === "range",
      hasSelectedRange: ({ context }) => context.get("value").length === 2,
      isMultiPicker: ({ prop }) => prop("selectionMode") === "multiple",
      canSelectDate: (params) => {
        const { context, prop, event } = params;
        const maxSelectedDates = prop("maxSelectedDates");
        if (maxSelectedDates == null) return true;
        const existingValues = context.get("value");
        const currentValue = normalizeValue(params, event.value ?? context.get("focusedValue"));
        const isDeselecting = existingValues.some((date) => isDateEqual(date, currentValue));
        if (isDeselecting) return true;
        return existingValues.length < maxSelectedDates;
      },
      shouldRestoreFocus: ({ context }) => !!context.get("restoreFocus"),
      isSelectingEndDate: ({ context }) => context.get("activeIndex") === 1,
      closeOnSelect: ({ prop }) => !!prop("closeOnSelect"),
      isOpenControlled: ({ prop }) => prop("open") != void 0 || !!prop("inline"),
      isInteractOutsideEvent: ({ event }) => event.previousEvent?.type === "INTERACT_OUTSIDE",
      isInputValueEmpty: ({ event }) => event.value.trim() === "",
      shouldFixOnBlur: ({ event }) => !!event.fixOnBlur,
      isDayPointerMoveOutsideVisibleMonth: ({ event }) => event.cell === "day" && event.outsideRange === true
    },
    effects: {
      trackPositioning({ context, prop, scope }) {
        if (prop("inline")) return;
        if (!context.get("currentPlacement")) {
          context.set("currentPlacement", prop("positioning").placement);
        }
        const anchorEl = getControlEl(scope);
        const getPositionerEl2 = () => getPositionerEl(scope);
        return getPlacement(anchorEl, getPositionerEl2, {
          ...prop("positioning"),
          defer: true,
          onComplete(data) {
            context.set("currentPlacement", data.placement);
          }
        });
      },
      setupLiveRegion({ scope, refs }) {
        const doc = scope.getDoc();
        refs.set("announcer", createLiveRegion({ level: "assertive", document: doc }));
        return () => refs.get("announcer")?.destroy?.();
      },
      trackDismissableElement({ scope, send, context, prop }) {
        if (prop("inline")) return;
        const getContentEl2 = () => getContentEl(scope);
        return trackDismissableElement(getContentEl2, {
          type: "popover",
          defer: true,
          layerStyleTargets: [() => getPositionerEl(scope)],
          exclude: [...getInputEls(scope), getTriggerEl(scope), getClearTriggerEl(scope)],
          onInteractOutside(event) {
            context.set("restoreFocus", !event.detail.focusable);
          },
          onDismiss() {
            send({ type: "INTERACT_OUTSIDE" });
          },
          onEscapeKeyDown(event) {
            event.preventDefault();
            send({ type: "TABLE.ESCAPE", src: "dismissable" });
          }
        });
      }
    },
    actions: {
      setNextView({ context, prop }) {
        const nextView = getNextView(context.get("view"), prop("minView"), prop("maxView"));
        context.set("view", nextView);
      },
      setPreviousView({ context, prop }) {
        const prevView = getPreviousView(context.get("view"), prop("minView"), prop("maxView"));
        context.set("view", prevView);
      },
      setView({ context, event }) {
        context.set("view", event.view);
      },
      setRestoreFocus({ context }) {
        context.set("restoreFocus", true);
      },
      announceValueText({ context, prop, refs }) {
        const value = context.get("value");
        const locale = prop("locale");
        const timeZone = prop("timeZone");
        let announceText;
        if (prop("selectionMode") === "range") {
          const [startDate, endDate] = value;
          if (startDate && endDate) {
            announceText = formatSelectedDate(startDate, endDate, locale, timeZone);
          } else if (startDate) {
            announceText = formatSelectedDate(startDate, null, locale, timeZone);
          } else if (endDate) {
            announceText = formatSelectedDate(endDate, null, locale, timeZone);
          } else {
            announceText = "";
          }
        } else {
          announceText = value.map((date) => formatSelectedDate(date, null, locale, timeZone)).filter(Boolean).join(",");
        }
        refs.get("announcer")?.announce(announceText, 3e3);
      },
      announceVisibleRange({ computed, refs }) {
        const { formatted } = computed("visibleRangeText");
        refs.get("announcer")?.announce(formatted);
      },
      disableTextSelection({ scope }) {
        disableTextSelection({ target: getContentEl(scope), doc: scope.getDoc() });
      },
      enableTextSelection({ scope }) {
        restoreTextSelection({ doc: scope.getDoc(), target: getContentEl(scope) });
      },
      focusFirstSelectedDate(params) {
        const { context } = params;
        if (!context.get("value").length) return;
        setFocusedValue(params, context.get("value")[0]);
      },
      syncInputElement({ scope, computed }) {
        raf(() => {
          const inputEls = getInputEls(scope);
          inputEls.forEach((inputEl, index) => {
            setElementValue(inputEl, computed("valueAsString")[index] || "");
          });
        });
      },
      setFocusedDate(params) {
        const { event } = params;
        const value = Array.isArray(event.value) ? event.value[0] : event.value;
        setFocusedValue(params, value);
      },
      setFocusedValueForView(params) {
        const { context, event } = params;
        setFocusedValue(params, context.get("focusedValue").set({ [context.get("view")]: event.value }));
      },
      focusNextMonth(params) {
        const { context } = params;
        setFocusedValue(params, context.get("focusedValue").add({ months: 1 }));
      },
      focusPreviousMonth(params) {
        const { context } = params;
        setFocusedValue(params, context.get("focusedValue").subtract({ months: 1 }));
      },
      setDateValue({ context, event, prop }) {
        if (!Array.isArray(event.value)) return;
        const value = event.value.map((date) => constrainValue(date, prop("min"), prop("max")));
        context.set("value", value);
      },
      clearDateValue({ context }) {
        context.set("value", []);
      },
      setSelectedDate(params) {
        const { context, event } = params;
        const values = Array.from(context.get("value"));
        const activeIndex = context.get("activeIndex");
        const existingValue = values[activeIndex];
        const newValue = normalizeValue(params, event.value ?? context.get("focusedValue"));
        values[activeIndex] = preserveTime(existingValue, newValue);
        context.set("value", adjustStartAndEndDate(values));
      },
      resetSelection(params) {
        const { context, event } = params;
        const existingValue = context.get("value")[0];
        const newValue = normalizeValue(params, event.value ?? context.get("focusedValue"));
        context.set("value", [preserveTime(existingValue, newValue)]);
      },
      toggleSelectedDate(params) {
        const { context, event } = params;
        const currentValue = normalizeValue(params, event.value ?? context.get("focusedValue"));
        const existingValues = context.get("value");
        const index = existingValues.findIndex((date) => isDateEqual(date, currentValue));
        if (index === -1) {
          const values = [...existingValues, currentValue];
          context.set("value", sortDates(values));
        } else {
          const values = Array.from(existingValues);
          values.splice(index, 1);
          context.set("value", sortDates(values));
        }
      },
      setHoveredDate({ context, event }) {
        context.set("hoveredValue", event.value);
      },
      clearHoveredDate({ context }) {
        context.set("hoveredValue", null);
      },
      selectFocusedDate({ context, computed }) {
        const values = Array.from(context.get("value"));
        const activeIndex = context.get("activeIndex");
        const existingValue = values[activeIndex];
        const newValue = context.get("focusedValue").copy();
        values[activeIndex] = preserveTime(existingValue, newValue);
        context.set("value", adjustStartAndEndDate(values));
        const valueAsString = computed("valueAsString");
        context.set("inputValue", valueAsString[activeIndex]);
      },
      focusPreviousDay(params) {
        const { context } = params;
        const nextValue = context.get("focusedValue").subtract({ days: 1 });
        setFocusedValue(params, nextValue);
      },
      focusNextDay(params) {
        const { context } = params;
        const nextValue = context.get("focusedValue").add({ days: 1 });
        setFocusedValue(params, nextValue);
      },
      focusPreviousWeek(params) {
        const { context } = params;
        const nextValue = context.get("focusedValue").subtract({ weeks: 1 });
        setFocusedValue(params, nextValue);
      },
      focusNextWeek(params) {
        const { context } = params;
        const nextValue = context.get("focusedValue").add({ weeks: 1 });
        setFocusedValue(params, nextValue);
      },
      focusNextPage(params) {
        const { context, computed, prop } = params;
        const nextPage = getNextPage(
          context.get("focusedValue"),
          context.get("startValue"),
          computed("visibleDuration"),
          prop("locale"),
          prop("min"),
          prop("max")
        );
        setAdjustedValue(params, nextPage);
      },
      focusPreviousPage(params) {
        const { context, computed, prop } = params;
        const previousPage = getPreviousPage(
          context.get("focusedValue"),
          context.get("startValue"),
          computed("visibleDuration"),
          prop("locale"),
          prop("min"),
          prop("max")
        );
        setAdjustedValue(params, previousPage);
      },
      focusSectionStart(params) {
        const { context } = params;
        setFocusedValue(params, context.get("startValue").copy());
      },
      focusSectionEnd(params) {
        const { computed } = params;
        setFocusedValue(params, computed("endValue").copy());
      },
      focusNextSection(params) {
        const { context, event, computed, prop } = params;
        const nextSection = getNextSection(
          context.get("focusedValue"),
          context.get("startValue"),
          event.larger,
          computed("visibleDuration"),
          prop("locale"),
          prop("min"),
          prop("max")
        );
        if (!nextSection) return;
        setAdjustedValue(params, nextSection);
      },
      focusPreviousSection(params) {
        const { context, event, computed, prop } = params;
        const previousSection = getPreviousSection(
          context.get("focusedValue"),
          context.get("startValue"),
          event.larger,
          computed("visibleDuration"),
          prop("locale"),
          prop("min"),
          prop("max")
        );
        if (!previousSection) return;
        setAdjustedValue(params, previousSection);
      },
      focusNextYear(params) {
        const { context } = params;
        const nextValue = context.get("focusedValue").add({ years: 1 });
        setFocusedValue(params, nextValue);
      },
      focusPreviousYear(params) {
        const { context } = params;
        const nextValue = context.get("focusedValue").subtract({ years: 1 });
        setFocusedValue(params, nextValue);
      },
      focusNextDecade(params) {
        const { context } = params;
        const nextValue = context.get("focusedValue").add({ years: 10 });
        setFocusedValue(params, nextValue);
      },
      focusPreviousDecade(params) {
        const { context } = params;
        const nextValue = context.get("focusedValue").subtract({ years: 10 });
        setFocusedValue(params, nextValue);
      },
      clearFocusedDate(params) {
        const { context, prop } = params;
        const calendar = context.get("focusedValue").calendar;
        setFocusedValue(params, getTodayDate(prop("timeZone"), calendar));
      },
      focusPreviousMonthColumn(params) {
        const { context, event } = params;
        const nextValue = context.get("focusedValue").subtract({ months: event.columns });
        setFocusedValue(params, nextValue);
      },
      focusNextMonthColumn(params) {
        const { context, event } = params;
        const nextValue = context.get("focusedValue").add({ months: event.columns });
        setFocusedValue(params, nextValue);
      },
      focusPreviousYearColumn(params) {
        const { context, event } = params;
        const nextValue = context.get("focusedValue").subtract({ years: event.columns });
        setFocusedValue(params, nextValue);
      },
      focusNextYearColumn(params) {
        const { context, event } = params;
        const nextValue = context.get("focusedValue").add({ years: event.columns });
        setFocusedValue(params, nextValue);
      },
      focusFirstMonth(params) {
        const { context } = params;
        const focused = context.get("focusedValue");
        const minMonth = focused.calendar.getMinimumMonthInYear?.(focused) ?? 1;
        setFocusedValue(params, focused.set({ month: minMonth }));
      },
      focusLastMonth(params) {
        const { context } = params;
        const focused = context.get("focusedValue");
        const maxMonth = focused.calendar.getMonthsInYear(focused);
        setFocusedValue(params, focused.set({ month: maxMonth }));
      },
      focusFirstYear(params) {
        const { context } = params;
        const range = getDecadeRange(context.get("focusedValue").year);
        const nextValue = context.get("focusedValue").set({ year: range[0] });
        setFocusedValue(params, nextValue);
      },
      focusLastYear(params) {
        const { context } = params;
        const range = getDecadeRange(context.get("focusedValue").year);
        const nextValue = context.get("focusedValue").set({ year: range[range.length - 1] });
        setFocusedValue(params, nextValue);
      },
      setActiveIndex({ context, event }) {
        context.set("activeIndex", event.index);
      },
      setActiveIndexToEnd({ context }) {
        context.set("activeIndex", 1);
      },
      setActiveIndexToStart({ context }) {
        context.set("activeIndex", 0);
      },
      resumeRangeSelection({ context, prop }) {
        if (prop("selectionMode") === "range" && context.get("value").length === 1) {
          context.set("activeIndex", 1);
        }
      },
      focusActiveCell({ scope, context, event }) {
        if (event.src === "input.click") return;
        raf(() => {
          const view = context.get("view");
          getFocusedCell(scope, view)?.focus({ preventScroll: true });
        });
      },
      focusActiveCellIfNeeded({ scope, context, event }) {
        if (!event.focus) return;
        raf(() => {
          const view = context.get("view");
          getFocusedCell(scope, view)?.focus({ preventScroll: true });
        });
      },
      setHoveredValueIfKeyboard({ context, event, prop }) {
        const isKeyboardNavigation = event.type.startsWith("TABLE.ARROW") || ["TABLE.ENTER", "TABLE.HOME", "TABLE.END", "TABLE.PAGE_UP", "TABLE.PAGE_DOWN"].includes(event.type);
        if (!isKeyboardNavigation || prop("selectionMode") !== "range" || context.get("activeIndex") === 0) return;
        context.set("hoveredValue", context.get("focusedValue").copy());
      },
      focusTriggerElement({ scope }) {
        raf(() => {
          getTriggerEl(scope)?.focus({ preventScroll: true });
        });
      },
      focusFirstInputElement({ scope, event }) {
        if (event.focus === false) return;
        raf(() => {
          const [inputEl] = getInputEls(scope);
          const elementToFocus = inputEl ?? getTriggerEl(scope);
          elementToFocus?.focus({ preventScroll: true });
        });
      },
      focusInputElement({ scope }) {
        raf(() => {
          const inputEls = getInputEls(scope);
          if (inputEls.length === 0) {
            getTriggerEl(scope)?.focus({ preventScroll: true });
            return;
          }
          const lastIndexWithValue = inputEls.findLastIndex((inputEl2) => inputEl2.value !== "");
          const indexToFocus = Math.max(lastIndexWithValue, 0);
          const inputEl = inputEls[indexToFocus];
          inputEl?.focus({ preventScroll: true });
          inputEl?.setSelectionRange(inputEl.value.length, inputEl.value.length);
        });
      },
      syncMonthSelectElement({ scope, context }) {
        const monthSelectEl = getMonthSelectEl(scope);
        setElementValue(monthSelectEl, context.get("startValue").month.toString());
      },
      syncYearSelectElement({ scope, context }) {
        const yearSelectEl = getYearSelectEl(scope);
        setElementValue(yearSelectEl, context.get("startValue").year.toString());
      },
      setInputValue({ context, event }) {
        if (context.get("activeIndex") !== event.index) return;
        context.set("inputValue", event.value);
      },
      syncInputValue({ scope, context, event }) {
        queueMicrotask(() => {
          const inputEls = getInputEls(scope);
          const idx = event.index ?? context.get("activeIndex");
          setElementValue(inputEls[idx], context.get("inputValue"));
        });
      },
      focusParsedDate(params) {
        const { event, prop } = params;
        if (event.index == null) return;
        const parse2 = prop("parse");
        const date = parse2(event.value, { locale: prop("locale"), timeZone: prop("timeZone") });
        if (!date || !isValidDate(date)) return;
        setFocusedValue(params, date);
      },
      selectParsedDate({ context, event, prop }) {
        if (event.index == null) return;
        const parse2 = prop("parse");
        let date = parse2(event.value, { locale: prop("locale"), timeZone: prop("timeZone") });
        if (!date || !isValidDate(date)) {
          if (event.value) {
            date = context.get("focusedValue").copy();
          }
        }
        if (!date) return;
        date = constrainValue(date, prop("min"), prop("max"));
        const values = Array.from(context.get("value"));
        values[event.index] = preserveTime(values[event.index], date);
        const adjustedValues = adjustStartAndEndDate(values);
        context.set("value", adjustedValues);
        const valueAsString = getValueAsString(adjustedValues, prop);
        context.set("inputValue", valueAsString[event.index]);
      },
      resetView({ context }) {
        context.set("view", context.initial("view"));
      },
      setStartValue({ context, computed, prop }) {
        const focusedValue = context.get("focusedValue");
        const outside = isDateOutsideRange(focusedValue, context.get("startValue"), computed("endValue"));
        if (!outside) return;
        const startValue = alignDate(focusedValue, "start", { months: prop("numOfMonths") }, prop("locale"));
        context.set("startValue", startValue);
      },
      invokeOnOpen({ prop, context }) {
        if (prop("inline")) return;
        prop("onOpenChange")?.({ open: true, value: context.get("value") });
      },
      invokeOnClose({ prop, context }) {
        if (prop("inline")) return;
        prop("onOpenChange")?.({ open: false, value: context.get("value") });
      },
      invokeOnVisibleRangeChange({ prop, context, computed }) {
        prop("onVisibleRangeChange")?.({
          view: context.get("view"),
          visibleRange: computed("visibleRange")
        });
      },
      toggleVisibility({ event, send, prop }) {
        send({ type: prop("open") ? "CONTROLLED.OPEN" : "CONTROLLED.CLOSE", previousEvent: event });
      }
    }
  }
});
var normalizeValue = (ctx, value) => {
  const { context, prop } = ctx;
  const view = context.get("view");
  let dateValue = typeof value === "number" ? context.get("focusedValue").set({ [view]: value }) : value;
  eachView((view2) => {
    if (isBelowMinView(view2, prop("minView"))) {
      dateValue = dateValue.set({ [view2]: view2 === "day" ? 1 : 0 });
    }
  });
  return dateValue;
};
var preserveTime = (existingDate, newDate) => {
  if (!existingDate || !("hour" in existingDate)) {
    return newDate;
  }
  const isZoned = "timeZone" in existingDate;
  let dateWithTime = newDate;
  if (!("hour" in newDate)) {
    if (isZoned) {
      dateWithTime = $d07e34cce18680fd$export$84c95a83c799e074($d07e34cce18680fd$export$b21e0b124e224484(newDate), existingDate.timeZone);
    } else {
      dateWithTime = $d07e34cce18680fd$export$b21e0b124e224484(newDate);
    }
  }
  return dateWithTime.set({
    hour: existingDate.hour,
    minute: existingDate.minute,
    second: existingDate.second,
    millisecond: existingDate.millisecond
  });
};
function setFocusedValue(ctx, mixedValue) {
  const { context, prop, computed } = ctx;
  if (!mixedValue) return;
  const value = normalizeValue(ctx, mixedValue);
  if (isDateEqual(context.get("focusedValue"), value)) return;
  const adjustFn = getAdjustedDateFn(computed("visibleDuration"), prop("locale"), prop("min"), prop("max"));
  const adjustedValue = adjustFn({
    focusedDate: value,
    startDate: context.get("startValue")
  });
  context.set("startValue", adjustedValue.startDate);
  context.set("focusedValue", adjustedValue.focusedDate);
}
function setAdjustedValue(ctx, value) {
  const { context } = ctx;
  context.set("startValue", value.startDate);
  const focusedValue = context.get("focusedValue");
  if (isDateEqual(focusedValue, value.focusedDate)) return;
  context.set("focusedValue", value.focusedDate);
}

// ../node_modules/.pnpm/@zag-js+date-picker@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-picker/dist/date-picker.parse.mjs
function parse(value) {
  if (Array.isArray(value)) {
    return value.map((v) => parse(v));
  }
  if (value instanceof Date) {
    return new $2aaf608024c21ca1$export$99faa760c7908e4f(value.getFullYear(), value.getMonth() + 1, value.getDate());
  }
  return $58246871e4652552$export$6b862160d295c8e(value);
}

// components/date-picker.ts
var pickViewLabel = (view, day, month, year) => view === "year" ? year ?? "" : view === "month" ? month ?? "" : day ?? "";
var formatWeek = (template, n) => template.split("__N__").join(String(n));
function buildZagDatePickerTranslations(m) {
  const t = {};
  if (m.content) t.content = m.content;
  if (m.monthSelect) t.monthSelect = m.monthSelect;
  if (m.yearSelect) t.yearSelect = m.yearSelect;
  if (m.clearTrigger) t.clearTrigger = m.clearTrigger;
  if (m.weekColumnHeader) t.weekColumnHeader = m.weekColumnHeader;
  if (m.weekNumber) t.weekNumberCell = (n) => formatWeek(m.weekNumber, n);
  if (m.openCalendar && m.closeCalendar) {
    t.trigger = (open) => open ? m.closeCalendar : m.openCalendar;
  }
  if (m.viewTriggerDay || m.viewTriggerMonth || m.viewTriggerYear) {
    t.viewTrigger = (view) => pickViewLabel(
      view,
      m.viewTriggerDay,
      m.viewTriggerMonth,
      m.viewTriggerYear
    );
  }
  if (m.prevTriggerDay || m.prevTriggerMonth || m.prevTriggerYear) {
    t.prevTrigger = (view) => pickViewLabel(
      view,
      m.prevTriggerDay,
      m.prevTriggerMonth,
      m.prevTriggerYear
    );
  }
  if (m.nextTriggerDay || m.nextTriggerMonth || m.nextTriggerYear) {
    t.nextTrigger = (view) => pickViewLabel(
      view,
      m.nextTriggerDay,
      m.nextTriggerMonth,
      m.nextTriggerYear
    );
  }
  if (m.placeholderDay && m.placeholderMonth && m.placeholderYear) {
    t.placeholder = () => ({
      day: m.placeholderDay,
      month: m.placeholderMonth,
      year: m.placeholderYear
    });
  }
  return t;
}
function applyInputAriaIfNeeded(el, inputs, selectionMode) {
  if (selectionMode === "range" || el.querySelector('[data-scope="date-picker"][data-part="label"]')) {
    return;
  }
  let tr = null;
  const raw = el.dataset.translation;
  if (raw) {
    try {
      tr = JSON.parse(raw);
    } catch {
      tr = null;
    }
  }
  const value = tr?.input;
  if (!value) return;
  for (const input of inputs) {
    if (!input.getAttribute("aria-labelledby")) {
      input.setAttribute("aria-label", value);
    }
  }
}
var DatePicker = class extends Component {
  initMachine(props) {
    return new VanillaMachine(machine, props);
  }
  initApi() {
    return this.zagConnect(connect);
  }
  getDayView = () => this.el.querySelector('[data-part="day-view"]');
  getMonthView = () => this.el.querySelector('[data-part="month-view"]');
  getYearView = () => this.el.querySelector('[data-part="year-view"]');
  ensureTableRow(tbody, rowIndex) {
    let tr = tbody.children[rowIndex];
    if (!tr || tr.tagName !== "TR") {
      tr = this.doc.createElement("tr");
      const ref = tbody.children[rowIndex] ?? null;
      tbody.insertBefore(tr, ref);
    }
    return tr;
  }
  ensureTableCell(tr, cellIndex, cellKey) {
    let td = tr.children[cellIndex];
    if (td && (td.tagName !== "TD" || td.dataset.dateCell !== cellKey)) {
      td.remove();
      td = void 0;
    }
    if (!td) {
      td = this.doc.createElement("td");
      td.dataset.dateCell = cellKey;
      const trigger2 = this.doc.createElement("div");
      td.appendChild(trigger2);
      const ref = tr.children[cellIndex] ?? null;
      tr.insertBefore(td, ref);
    }
    const trigger = td.querySelector("div");
    return { td, trigger };
  }
  trimTableRows(tbody, rowCount) {
    while (tbody.children.length > rowCount) {
      tbody.lastElementChild?.remove();
    }
  }
  trimTableCells(tr, cellCount) {
    while (tr.children.length > cellCount) {
      tr.lastElementChild?.remove();
    }
  }
  renderDayTableHeader = () => {
    const dayView = this.getDayView();
    const thead = dayView?.querySelector("thead");
    if (!thead || !this.api.weekDays) return;
    let tr = thead.querySelector("tr");
    if (!tr || tr.children.length !== this.api.weekDays.length) {
      tr = this.doc.createElement("tr");
      thead.replaceChildren(tr);
      this.api.weekDays.forEach(() => {
        const th = this.doc.createElement("th");
        th.scope = "col";
        tr.appendChild(th);
      });
    }
    this.spreadProps(tr, this.api.getTableRowProps({ view: "day" }));
    this.api.weekDays.forEach((day, index) => {
      const th = tr.children[index];
      th.setAttribute("aria-label", day.long);
      if (th.textContent !== day.narrow) {
        th.textContent = day.narrow;
      }
    });
  };
  renderDayTableBody = () => {
    const dayView = this.getDayView();
    const tbody = dayView?.querySelector("tbody");
    if (!tbody) return;
    this.spreadProps(tbody, this.api.getTableBodyProps({ view: "day" }));
    if (!this.api.weeks) {
      tbody.replaceChildren();
      return;
    }
    const weeks = this.api.weeks;
    this.trimTableRows(tbody, weeks.length);
    weeks.forEach((week, weekIndex) => {
      const tr = this.ensureTableRow(tbody, weekIndex);
      this.spreadProps(tr, this.api.getTableRowProps({ view: "day" }));
      this.trimTableCells(tr, week.length);
      week.forEach((value, cellIndex) => {
        const cellKey = `${value.year}-${value.month}-${value.day}`;
        const { td, trigger } = this.ensureTableCell(tr, cellIndex, cellKey);
        this.spreadProps(td, this.api.getDayTableCellProps({ value }));
        this.spreadProps(trigger, this.api.getDayTableCellTriggerProps({ value }));
        const label = String(value.day);
        if (trigger.textContent !== label) {
          trigger.textContent = label;
        }
      });
    });
  };
  renderMonthTableBody = () => {
    const monthView = this.getMonthView();
    const tbody = monthView?.querySelector("tbody");
    if (!tbody) return;
    this.spreadProps(tbody, this.api.getTableBodyProps({ view: "month" }));
    const monthsGrid = this.api.getMonthsGrid({ columns: 4, format: "short" });
    this.trimTableRows(tbody, monthsGrid.length);
    monthsGrid.forEach((months, rowIndex) => {
      const tr = this.ensureTableRow(tbody, rowIndex);
      this.spreadProps(tr, this.api.getTableRowProps());
      this.trimTableCells(tr, months.length);
      months.forEach((month, cellIndex) => {
        const cellKey = `${this.api.visibleRange.start.year}-${month.value}`;
        const { td, trigger } = this.ensureTableCell(tr, cellIndex, cellKey);
        this.spreadProps(td, this.api.getMonthTableCellProps({ ...month, columns: 4 }));
        this.spreadProps(trigger, this.api.getMonthTableCellTriggerProps({ ...month, columns: 4 }));
        if (trigger.textContent !== month.label) {
          trigger.textContent = month.label;
        }
      });
    });
  };
  renderYearTableBody = () => {
    const yearView = this.getYearView();
    const tbody = yearView?.querySelector("tbody");
    if (!tbody) return;
    this.spreadProps(tbody, this.api.getTableBodyProps());
    const yearsGrid = this.api.getYearsGrid({ columns: 4 });
    this.trimTableRows(tbody, yearsGrid.length);
    yearsGrid.forEach((years, rowIndex) => {
      const tr = this.ensureTableRow(tbody, rowIndex);
      this.spreadProps(tr, this.api.getTableRowProps({ view: "year" }));
      this.trimTableCells(tr, years.length);
      years.forEach((year, cellIndex) => {
        const cellKey = String(year.value);
        const { td, trigger } = this.ensureTableCell(tr, cellIndex, cellKey);
        this.spreadProps(td, this.api.getYearTableCellProps({ ...year, columns: 4 }));
        this.spreadProps(trigger, this.api.getYearTableCellTriggerProps({ ...year, columns: 4 }));
        if (trigger.textContent !== year.label) {
          trigger.textContent = year.label;
        }
      });
    });
  };
  render() {
    const root = this.el.querySelector('[data-scope="date-picker"][data-part="root"]');
    if (root) this.spreadProps(root, this.api.getRootProps());
    const label = this.el.querySelector(
      '[data-scope="date-picker"][data-part="label"]'
    );
    if (label) this.spreadProps(label, this.api.getLabelProps());
    const control = this.el.querySelector(
      '[data-scope="date-picker"][data-part="control"]'
    );
    if (control) this.spreadProps(control, this.api.getControlProps());
    const inputs = Array.from(
      this.el.querySelectorAll('[data-scope="date-picker"][data-part="input"]')
    );
    const selectionMode = this.api.selectionMode;
    for (let i = 0; i < inputs.length; i += 1) {
      const inputEl = inputs[i];
      this.spreadProps(inputEl, this.api.getInputProps({ index: i }));
      if (inputEl.getAttribute("value") !== inputEl.value) {
        inputEl.setAttribute("value", inputEl.value);
      }
    }
    if (selectionMode === "multiple" && inputs.length > 0) {
      const input = inputs[0];
      const applyMultipleDisplay = () => {
        const vs = this.api.valueAsString;
        const parts2 = Array.isArray(vs) ? vs : vs == null || vs === "" ? [] : [String(vs)];
        const joined = parts2.filter(Boolean).join(", ");
        if (input.value !== joined) {
          input.value = joined;
        }
      };
      applyMultipleDisplay();
      queueMicrotask(() => {
        requestAnimationFrame(applyMultipleDisplay);
      });
    }
    applyInputAriaIfNeeded(this.el, inputs, this.api.selectionMode);
    const trigger = this.el.querySelector(
      '[data-scope="date-picker"][data-part="trigger"]'
    );
    if (trigger) {
      this.spreadProps(trigger, this.api.getTriggerProps());
    }
    const positioner = this.el.querySelector(
      '[data-scope="date-picker"][data-part="positioner"]'
    );
    if (positioner) this.spreadProps(positioner, this.api.getPositionerProps());
    const content = this.el.querySelector(
      '[data-scope="date-picker"][data-part="content"]'
    );
    if (content) this.spreadProps(content, this.api.getContentProps());
    const dayView = this.getDayView();
    const monthView = this.getMonthView();
    const yearView = this.getYearView();
    if (!this.api.open) {
      if (dayView) dayView.hidden = true;
      if (monthView) monthView.hidden = true;
      if (yearView) yearView.hidden = true;
      return;
    }
    if (dayView) dayView.hidden = this.api.view !== "day";
    if (monthView) monthView.hidden = this.api.view !== "month";
    if (yearView) yearView.hidden = this.api.view !== "year";
    if (this.api.view === "day" && dayView) {
      const viewControl = dayView.querySelector('[data-part="view-control"]');
      if (viewControl)
        this.spreadProps(viewControl, this.api.getViewControlProps({ view: "year" }));
      const prevTrigger = dayView.querySelector('[data-part="prev-trigger"]');
      if (prevTrigger) this.spreadProps(prevTrigger, this.api.getPrevTriggerProps());
      const viewTrigger = dayView.querySelector('[data-part="view-trigger"]');
      if (viewTrigger) {
        this.spreadProps(viewTrigger, this.api.getViewTriggerProps());
        viewTrigger.textContent = this.api.visibleRangeText.start;
      }
      const nextTrigger = dayView.querySelector('[data-part="next-trigger"]');
      if (nextTrigger) this.spreadProps(nextTrigger, this.api.getNextTriggerProps());
      const table = dayView.querySelector("table");
      if (table) this.spreadProps(table, this.api.getTableProps({ view: "day" }));
      const thead = dayView.querySelector("thead");
      if (thead) this.spreadProps(thead, this.api.getTableHeaderProps({ view: "day" }));
      this.renderDayTableHeader();
      this.renderDayTableBody();
    } else if (this.api.view === "month" && monthView) {
      const viewControl = monthView.querySelector('[data-part="view-control"]');
      if (viewControl)
        this.spreadProps(viewControl, this.api.getViewControlProps({ view: "month" }));
      const prevTrigger = monthView.querySelector('[data-part="prev-trigger"]');
      if (prevTrigger)
        this.spreadProps(prevTrigger, this.api.getPrevTriggerProps({ view: "month" }));
      const viewTrigger = monthView.querySelector('[data-part="view-trigger"]');
      if (viewTrigger) {
        this.spreadProps(viewTrigger, this.api.getViewTriggerProps({ view: "month" }));
        viewTrigger.textContent = String(this.api.visibleRange.start.year);
      }
      const nextTrigger = monthView.querySelector('[data-part="next-trigger"]');
      if (nextTrigger)
        this.spreadProps(nextTrigger, this.api.getNextTriggerProps({ view: "month" }));
      const table = monthView.querySelector("table");
      if (table) this.spreadProps(table, this.api.getTableProps({ view: "month", columns: 4 }));
      this.renderMonthTableBody();
    } else if (this.api.view === "year" && yearView) {
      const viewControl = yearView.querySelector('[data-part="view-control"]');
      if (viewControl)
        this.spreadProps(viewControl, this.api.getViewControlProps({ view: "year" }));
      const prevTrigger = yearView.querySelector('[data-part="prev-trigger"]');
      if (prevTrigger)
        this.spreadProps(prevTrigger, this.api.getPrevTriggerProps({ view: "year" }));
      const decadeText = yearView.querySelector('[data-part="decade"]');
      if (decadeText) {
        const decade = this.api.getDecade();
        decadeText.textContent = `${decade.start} - ${decade.end}`;
      }
      const nextTrigger = yearView.querySelector('[data-part="next-trigger"]');
      if (nextTrigger)
        this.spreadProps(nextTrigger, this.api.getNextTriggerProps({ view: "year" }));
      const table = yearView.querySelector("table");
      if (table) this.spreadProps(table, this.api.getTableProps({ view: "year", columns: 4 }));
      this.renderYearTableBody();
    }
  }
};

// hooks/date-picker.ts
var DATE_PICKER_UPDATE_ATTR_KEYS = [
  "dir",
  "locale",
  "timeZone",
  "disabled",
  "readonly",
  "required",
  "invalid",
  "outsideDaySelectable",
  "closeOnSelect",
  "min",
  "max",
  "startOfWeek",
  "fixedWeeks",
  "selectionMode",
  "maxSelectedDates",
  "placeholder",
  "minView",
  "maxView",
  "inline",
  "translation",
  "submitName",
  "value",
  "positionStrategy",
  "positionPlacement",
  "positionGutter",
  "positionShift",
  "positionOverflowPadding",
  "positionArrowPadding",
  "positionOffsetMainAxis",
  "positionOffsetCrossAxis",
  "positionFlip",
  "positionSlide",
  "positionOverlap",
  "positionSameWidth",
  "positionFitViewport",
  "positionHideWhenDetached"
];
var DATE_PICKER_PRESENCE_ATTR_KEYS = /* @__PURE__ */ new Set([
  "disabled",
  "readonly",
  "required",
  "invalid",
  "outsideDaySelectable",
  "closeOnSelect",
  "fixedWeeks",
  "inline",
  "positionFlip",
  "positionSlide",
  "positionOverlap",
  "positionSameWidth",
  "positionFitViewport",
  "positionHideWhenDetached"
]);
function dataAttrName(camelKey) {
  return `data-${camelKey.replace(/([A-Z])/g, "-$1").toLowerCase()}`;
}
function datePickerUpdateAttrsKey(el) {
  const d = el.dataset;
  let out = "";
  for (const key of DATE_PICKER_UPDATE_ATTR_KEYS) {
    out += key;
    out += "=";
    if (DATE_PICKER_PRESENCE_ATTR_KEYS.has(key)) {
      out += el.hasAttribute(dataAttrName(key)) ? "1" : "0";
    } else {
      out += d[key] ?? "";
    }
    out += ";";
  }
  return out;
}
function sameStringList(a, b) {
  return a.length === b.length && a.every((v, i) => v === b[i]);
}
function isDateLike(d) {
  return typeof d === "object" && d !== null && "year" in d && "month" in d && "day" in d && typeof d.year === "number" && typeof d.month === "number" && typeof d.day === "number";
}
function tryParseDate(raw, label = "date") {
  try {
    return parse(raw);
  } catch (error) {
    console.warn(`[corex] date-picker: failed to parse ${label}`, raw, error);
    return void 0;
  }
}
function tryParseDateList(values) {
  if (!values) return void 0;
  const parsed = [];
  for (const x of values) {
    const next = tryParseDate(x, "value");
    if (next) parsed.push(next);
  }
  return parsed;
}
function valueToIsoString(d) {
  if (d == null) return "";
  if (typeof d === "string") {
    const trimmed = d.trim();
    if (trimmed === "") return "";
    try {
      return parse(trimmed).toString();
    } catch {
      return trimmed;
    }
  }
  if (isDateLike(d)) {
    const { year, month, day } = d;
    const mm = String(month).padStart(2, "0");
    const dd = String(day).padStart(2, "0");
    return `${year}-${mm}-${dd}`;
  }
  return String(d);
}
function isoListFromValues(values) {
  return values?.length ? values.map((d) => valueToIsoString(d)).filter(Boolean) : [];
}
function hiddenValueInputIsoList(el) {
  const hiddenInput = el.querySelector(
    '[data-scope="date-picker"][data-part="value-input"]'
  );
  if (!hiddenInput?.value) return [];
  return hiddenInput.value.split(",").map((v) => v.trim()).filter(Boolean);
}
function resolveIsoListForFormSync(el, apiValues, serverValues) {
  if (serverValues != null) {
    return serverValues;
  }
  const fromApi = isoListFromValues(apiValues);
  if (fromApi.length > 0) return fromApi;
  const fromHidden = hiddenValueInputIsoList(el);
  if (fromHidden.length > 0) return fromHidden;
  return readDatasetStringList(el, "value");
}
function applyServerIsoToZagIfNeeded(datePickerInstance, isoList) {
  const current = isoListFromValues(datePickerInstance.api.value);
  if (current.length > 0) return current;
  if (isoList.length === 0) return [];
  const parsed = tryParseDateList(isoList);
  if (!parsed || parsed.length === 0) return current;
  try {
    datePickerInstance.api.setValue(parsed);
  } catch (error) {
    console.warn("[corex] date-picker: failed to set value from server iso", isoList, error);
    return current;
  }
  return isoListFromValues(datePickerInstance.api.value);
}
function syncDatePickerValueInput(el, isoStr, notifyForm = false) {
  const hiddenInput = el.querySelector(
    '[data-scope="date-picker"][data-part="value-input"]'
  );
  if (!hiddenInput) return;
  if (notifyForm) {
    setScalarValue(hiddenInput, isoStr);
  } else {
    setScalarValue(hiddenInput, isoStr, { markUsed: false });
  }
}
function resolveZagDatePickerTranslations(el) {
  const raw = el.dataset.translation;
  if (!raw) {
    return {};
  }
  try {
    const tr = JSON.parse(raw);
    return { translations: buildZagDatePickerTranslations(tr) };
  } catch {
    return {};
  }
}
function resolveCloseOnSelect(el) {
  return getBoolean(el, "closeOnSelect");
}
var DatePickerHook = createZagLiveHook({
  key: "datePicker",
  controlledKeys: ["value"],
  mount(hook, { dom, server }) {
    const el = hook.el;
    hook.fieldTouched = false;
    const pushEvent = hook.pushEvent.bind(hook);
    const liveSocket = hook.liveSocket;
    const canPush = () => canPushEvent(hook.liveSocket);
    const min = getString(el, "min");
    const max = getString(el, "max");
    const parseList = (v) => tryParseDateList(v);
    const parseOne = (v) => v ? tryParseDate(v, "focusedValue") : void 0;
    const valueBinding = mountStringListBinding(el);
    const initialIsoList = "value" in valueBinding ? valueBinding.value : valueBinding.defaultValue;
    const datePickerInstance = new DatePicker(el, {
      id: el.id,
      ...(() => {
        if ("value" in valueBinding) {
          return { value: parseList(valueBinding.value) };
        }
        return { defaultValue: parseList(valueBinding.defaultValue) };
      })(),
      defaultFocusedValue: parseOne(getString(el, "focusedValue")),
      defaultView: getString(el, "defaultView"),
      dir: getString(el, "dir"),
      locale: getString(el, "locale"),
      timeZone: getString(el, "timeZone"),
      disabled: getBoolean(el, "disabled"),
      readOnly: getBoolean(el, "readonly"),
      required: getBoolean(el, "required"),
      invalid: getBoolean(el, "invalid"),
      outsideDaySelectable: getBoolean(el, "outsideDaySelectable"),
      closeOnSelect: resolveCloseOnSelect(el),
      min: min ? tryParseDate(min, "min") : void 0,
      max: max ? tryParseDate(max, "max") : void 0,
      startOfWeek: getNumber(el, "startOfWeek"),
      fixedWeeks: getBoolean(el, "fixedWeeks"),
      selectionMode: getString(el, "selectionMode"),
      maxSelectedDates: getNumber(el, "maxSelectedDates"),
      placeholder: getString(el, "placeholder"),
      minView: getString(el, "minView"),
      maxView: getString(el, "maxView"),
      defaultOpen: false,
      inline: getBoolean(el, "inline"),
      positioning: readPositioningOptions(el),
      ...resolveZagDatePickerTranslations(el),
      onValueChange: (details) => {
        const isoList2 = isoListFromValues(details.value);
        const isMountEcho = hook.fieldTouched !== true && sameStringList(isoList2, initialIsoList);
        if (!isMountEcho) {
          hook.fieldTouched = true;
        }
        const submitName2 = getString(el, "submitName");
        if (submitName2) {
          setArrayValues(el, isoList2, {
            scope: "date-picker",
            submitName: submitName2,
            notifyLiveView: !isMountEcho
          });
        } else {
          const isoStr = isoList2.length > 0 ? isoList2.join(",") : "";
          syncDatePickerValueInput(el, isoStr, !isMountEcho);
        }
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: {
            id: el.id,
            value: isoList2.length > 0 ? isoList2.join(",") : null
          },
          serverEventName: getString(el, "onValueChange"),
          clientEventName: getString(el, "onValueChangeClient")
        });
      },
      onFocusChange: (details) => {
        const eventName = getString(el, "onFocusChange");
        if (eventName && canPushEvent(liveSocket)) {
          pushEvent(eventName, {
            id: el.id,
            focused: details.focused ?? false
          });
        }
      },
      onViewChange: (details) => {
        const eventName = getString(el, "onViewChange");
        if (eventName && canPushEvent(liveSocket)) {
          pushEvent(eventName, {
            id: el.id,
            view: details.view
          });
        }
      },
      onVisibleRangeChange: (details) => {
        const eventName = getString(el, "onVisibleRangeChange");
        if (eventName && canPushEvent(liveSocket)) {
          pushEvent(eventName, {
            id: el.id,
            start: details.start,
            end: details.end
          });
        }
      },
      onOpenChange: (details) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: { id: el.id, open: details.open },
          serverEventName: getString(el, "onOpenChange"),
          clientEventName: getString(el, "onOpenChangeClient")
        });
      }
    });
    const submitName = getString(el, "submitName");
    const isoList = applyServerIsoToZagIfNeeded(
      datePickerInstance,
      resolveIsoListForFormSync(el, datePickerInstance.api.value)
    );
    if (submitName) {
      setArrayValues(el, isoList, {
        scope: "date-picker",
        submitName,
        notifyLiveView: false
      });
    } else {
      syncDatePickerValueInput(el, isoList.length > 0 ? isoList.join(",") : "", false);
    }
    server.add("date_picker_set_value", (payload) => {
      const targetId = payload.date_picker_id;
      if (!targetId || targetId !== el.id) return;
      const parsed = tryParseDate(payload.value, "set_value");
      if (parsed) datePickerInstance.api.setValue([parsed]);
    });
    dom.add("corex:date-picker:set-value", (event) => {
      const value = event.detail?.value;
      if (typeof value === "string") {
        const parsed = tryParseDate(value, "set-value");
        if (parsed) datePickerInstance.api.setValue([parsed]);
      }
    });
    hook.lastUpdateAttrsKey = datePickerUpdateAttrsKey(el);
    hook.locale = getString(el, "locale");
    return datePickerInstance;
  },
  update(hook, zag) {
    const el = hook.el;
    const attrsKey = datePickerUpdateAttrsKey(el);
    if (attrsKey === hook.lastUpdateAttrsKey) return;
    hook.lastUpdateAttrsKey = attrsKey;
    const min = getString(el, "min");
    const max = getString(el, "max");
    const valuePatch = readUpdatedServerStringList(el, hook.beforeAttrs);
    const locale = getString(el, "locale");
    const localeChanged = hook.locale !== void 0 && hook.locale !== locale;
    hook.locale = locale;
    zag.updateProps({
      dir: getString(el, "dir"),
      locale: getString(el, "locale"),
      timeZone: getString(el, "timeZone"),
      disabled: getBoolean(el, "disabled"),
      readOnly: getBoolean(el, "readonly"),
      required: getBoolean(el, "required"),
      invalid: getBoolean(el, "invalid"),
      outsideDaySelectable: getBoolean(el, "outsideDaySelectable"),
      closeOnSelect: resolveCloseOnSelect(el),
      min: min ? tryParseDate(min, "min") : void 0,
      max: max ? tryParseDate(max, "max") : void 0,
      startOfWeek: getNumber(el, "startOfWeek"),
      fixedWeeks: getBoolean(el, "fixedWeeks"),
      selectionMode: getString(el, "selectionMode"),
      maxSelectedDates: getNumber(el, "maxSelectedDates"),
      placeholder: getString(el, "placeholder"),
      minView: getString(el, "minView"),
      maxView: getString(el, "maxView"),
      inline: getBoolean(el, "inline"),
      positioning: readPositioningOptions(el),
      ...resolveZagDatePickerTranslations(el),
      ...valuePatch.value !== void 0 ? { value: tryParseDateList(valuePatch.value) } : {}
    });
    const currentValue = zag.api.value;
    if (localeChanged && currentValue?.length) {
      zag.api.setValue(currentValue);
    }
    zag.render();
    const submitName = getString(el, "submitName");
    const isoList = isoListFromValues(zag.api.value);
    if (submitName) {
      setArrayValues(el, isoList, {
        scope: "date-picker",
        submitName,
        notifyLiveView: false
      });
    } else {
      syncDatePickerValueInput(el, isoList.length > 0 ? isoList.join(",") : "", false);
    }
  }
});
export {
  DatePickerHook as DatePicker,
  applyServerIsoToZagIfNeeded,
  resolveCloseOnSelect,
  resolveIsoListForFormSync,
  syncDatePickerValueInput,
  valueToIsoString
};
