import {
  getPlacement,
  getPlacementStyles
} from "./chunk-GRHV6R4F.mjs";
import {
  trackDismissableElement
} from "./chunk-BPSX7Z7Y.mjs";
import {
  Component,
  VanillaMachine,
  ariaAttr,
  chunk,
  clampValue,
  createAnatomy,
  createGuards,
  createMachine,
  createProps,
  createSplitProps,
  dataAttr,
  disableTextSelection,
  getBoolean,
  getEventKey,
  getNativeEvent,
  getNumber,
  getString,
  getStringList,
  isComposingEvent,
  isValueWithinRange,
  match,
  memo,
  normalizeProps,
  query,
  queryAll,
  raf,
  restoreTextSelection,
  setElementValue
} from "./chunk-GFGFZBBD.mjs";

// ../node_modules/.pnpm/@internationalized+date@3.11.0/node_modules/@internationalized/date/dist/utils.mjs
function $2b4dce13dd5a17fa$export$842a2cf37af977e1(amount, numerator) {
  return amount - numerator * Math.floor(amount / numerator);
}

// ../node_modules/.pnpm/@internationalized+date@3.11.0/node_modules/@internationalized/date/dist/GregorianCalendar.mjs
var $3b62074eb05584b2$var$EPOCH = 1721426;
function $3b62074eb05584b2$export$f297eb839006d339(era, year, month, day) {
  year = $3b62074eb05584b2$export$c36e0ecb2d4fa69d(era, year);
  let y1 = year - 1;
  let monthOffset = -2;
  if (month <= 2) monthOffset = 0;
  else if ($3b62074eb05584b2$export$553d7fa8e3805fc0(year)) monthOffset = -1;
  return $3b62074eb05584b2$var$EPOCH - 1 + 365 * y1 + Math.floor(y1 / 4) - Math.floor(y1 / 100) + Math.floor(y1 / 400) + Math.floor((367 * month - 362) / 12 + monthOffset + day);
}
function $3b62074eb05584b2$export$553d7fa8e3805fc0(year) {
  return year % 4 === 0 && (year % 100 !== 0 || year % 400 === 0);
}
function $3b62074eb05584b2$export$c36e0ecb2d4fa69d(era, year) {
  return era === "BC" ? 1 - year : year;
}
function $3b62074eb05584b2$export$4475b7e617eb123c(year) {
  let era = "AD";
  if (year <= 0) {
    era = "BC";
    year = 1 - year;
  }
  return [
    era,
    year
  ];
}
var $3b62074eb05584b2$var$daysInMonth = {
  standard: [
    31,
    28,
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31
  ],
  leapyear: [
    31,
    29,
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31
  ]
};
var $3b62074eb05584b2$export$80ee6245ec4f29ec = class {
  fromJulianDay(jd) {
    let jd0 = jd;
    let depoch = jd0 - $3b62074eb05584b2$var$EPOCH;
    let quadricent = Math.floor(depoch / 146097);
    let dqc = (0, $2b4dce13dd5a17fa$export$842a2cf37af977e1)(depoch, 146097);
    let cent = Math.floor(dqc / 36524);
    let dcent = (0, $2b4dce13dd5a17fa$export$842a2cf37af977e1)(dqc, 36524);
    let quad = Math.floor(dcent / 1461);
    let dquad = (0, $2b4dce13dd5a17fa$export$842a2cf37af977e1)(dcent, 1461);
    let yindex = Math.floor(dquad / 365);
    let extendedYear = quadricent * 400 + cent * 100 + quad * 4 + yindex + (cent !== 4 && yindex !== 4 ? 1 : 0);
    let [era, year] = $3b62074eb05584b2$export$4475b7e617eb123c(extendedYear);
    let yearDay = jd0 - $3b62074eb05584b2$export$f297eb839006d339(era, year, 1, 1);
    let leapAdj = 2;
    if (jd0 < $3b62074eb05584b2$export$f297eb839006d339(era, year, 3, 1)) leapAdj = 0;
    else if ($3b62074eb05584b2$export$553d7fa8e3805fc0(year)) leapAdj = 1;
    let month = Math.floor(((yearDay + leapAdj) * 12 + 373) / 367);
    let day = jd0 - $3b62074eb05584b2$export$f297eb839006d339(era, year, month, 1) + 1;
    return new (0, $35ea8db9cb2ccb90$export$99faa760c7908e4f)(era, year, month, day);
  }
  toJulianDay(date) {
    return $3b62074eb05584b2$export$f297eb839006d339(date.era, date.year, date.month, date.day);
  }
  getDaysInMonth(date) {
    return $3b62074eb05584b2$var$daysInMonth[$3b62074eb05584b2$export$553d7fa8e3805fc0(date.year) ? "leapyear" : "standard"][date.month - 1];
  }
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  getMonthsInYear(date) {
    return 12;
  }
  getDaysInYear(date) {
    return $3b62074eb05584b2$export$553d7fa8e3805fc0(date.year) ? 366 : 365;
  }
  getMaximumMonthsInYear() {
    return 12;
  }
  getMaximumDaysInMonth() {
    return 31;
  }
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  getYearsInEra(date) {
    return 9999;
  }
  getEras() {
    return [
      "BC",
      "AD"
    ];
  }
  isInverseEra(date) {
    return date.era === "BC";
  }
  balanceDate(date) {
    if (date.year <= 0) {
      date.era = date.era === "BC" ? "AD" : "BC";
      date.year = 1 - date.year;
    }
  }
  constructor() {
    this.identifier = "gregory";
  }
};

// ../node_modules/.pnpm/@internationalized+date@3.11.0/node_modules/@internationalized/date/dist/weekStartData.mjs
var $2fe286d2fb449abb$export$7a5acbd77d414bd9 = {
  "001": 1,
  AD: 1,
  AE: 6,
  AF: 6,
  AI: 1,
  AL: 1,
  AM: 1,
  AN: 1,
  AR: 1,
  AT: 1,
  AU: 1,
  AX: 1,
  AZ: 1,
  BA: 1,
  BE: 1,
  BG: 1,
  BH: 6,
  BM: 1,
  BN: 1,
  BY: 1,
  CH: 1,
  CL: 1,
  CM: 1,
  CN: 1,
  CR: 1,
  CY: 1,
  CZ: 1,
  DE: 1,
  DJ: 6,
  DK: 1,
  DZ: 6,
  EC: 1,
  EE: 1,
  EG: 6,
  ES: 1,
  FI: 1,
  FJ: 1,
  FO: 1,
  FR: 1,
  GB: 1,
  GE: 1,
  GF: 1,
  GP: 1,
  GR: 1,
  HR: 1,
  HU: 1,
  IE: 1,
  IQ: 6,
  IR: 6,
  IS: 1,
  IT: 1,
  JO: 6,
  KG: 1,
  KW: 6,
  KZ: 1,
  LB: 1,
  LI: 1,
  LK: 1,
  LT: 1,
  LU: 1,
  LV: 1,
  LY: 6,
  MC: 1,
  MD: 1,
  ME: 1,
  MK: 1,
  MN: 1,
  MQ: 1,
  MV: 5,
  MY: 1,
  NL: 1,
  NO: 1,
  NZ: 1,
  OM: 6,
  PL: 1,
  QA: 6,
  RE: 1,
  RO: 1,
  RS: 1,
  RU: 1,
  SD: 6,
  SE: 1,
  SI: 1,
  SK: 1,
  SM: 1,
  SY: 6,
  TJ: 1,
  TM: 1,
  TR: 1,
  UA: 1,
  UY: 1,
  UZ: 1,
  VA: 1,
  VN: 1,
  XK: 1
};

// ../node_modules/.pnpm/@internationalized+date@3.11.0/node_modules/@internationalized/date/dist/queries.mjs
function $14e0f24ef4ac5c92$export$ea39ec197993aef0(a, b) {
  b = (0, $11d87f3f76e88657$export$b4a036af3fc0b032)(b, a.calendar);
  return a.era === b.era && a.year === b.year && a.month === b.month && a.day === b.day;
}
function $14e0f24ef4ac5c92$export$a18c89cbd24170ff(a, b) {
  b = (0, $11d87f3f76e88657$export$b4a036af3fc0b032)(b, a.calendar);
  a = $14e0f24ef4ac5c92$export$a5a3b454ada2268e(a);
  b = $14e0f24ef4ac5c92$export$a5a3b454ada2268e(b);
  return a.era === b.era && a.year === b.year && a.month === b.month;
}
function $14e0f24ef4ac5c92$export$5841f9eb9773f25f(a, b) {
  b = (0, $11d87f3f76e88657$export$b4a036af3fc0b032)(b, a.calendar);
  a = $14e0f24ef4ac5c92$export$f91e89d3d0406102(a);
  b = $14e0f24ef4ac5c92$export$f91e89d3d0406102(b);
  return a.era === b.era && a.year === b.year;
}
function $14e0f24ef4ac5c92$export$91b62ebf2ba703ee(a, b) {
  return $14e0f24ef4ac5c92$export$dbc69fd56b53d5e(a.calendar, b.calendar) && $14e0f24ef4ac5c92$export$ea39ec197993aef0(a, b);
}
function $14e0f24ef4ac5c92$export$5a8da0c44a3afdf2(a, b) {
  return $14e0f24ef4ac5c92$export$dbc69fd56b53d5e(a.calendar, b.calendar) && $14e0f24ef4ac5c92$export$a18c89cbd24170ff(a, b);
}
function $14e0f24ef4ac5c92$export$ea840f5a6dda8147(a, b) {
  return $14e0f24ef4ac5c92$export$dbc69fd56b53d5e(a.calendar, b.calendar) && $14e0f24ef4ac5c92$export$5841f9eb9773f25f(a, b);
}
function $14e0f24ef4ac5c92$export$dbc69fd56b53d5e(a, b) {
  var _a_isEqual, _b_isEqual;
  var _a_isEqual1, _ref;
  return (_ref = (_a_isEqual1 = (_a_isEqual = a.isEqual) === null || _a_isEqual === void 0 ? void 0 : _a_isEqual.call(a, b)) !== null && _a_isEqual1 !== void 0 ? _a_isEqual1 : (_b_isEqual = b.isEqual) === null || _b_isEqual === void 0 ? void 0 : _b_isEqual.call(b, a)) !== null && _ref !== void 0 ? _ref : a.identifier === b.identifier;
}
function $14e0f24ef4ac5c92$export$629b0a497aa65267(date, timeZone) {
  return $14e0f24ef4ac5c92$export$ea39ec197993aef0(date, $14e0f24ef4ac5c92$export$d0bdf45af03a6ea3(timeZone));
}
var $14e0f24ef4ac5c92$var$DAY_MAP = {
  sun: 0,
  mon: 1,
  tue: 2,
  wed: 3,
  thu: 4,
  fri: 5,
  sat: 6
};
function $14e0f24ef4ac5c92$export$2061056d06d7cdf7(date, locale, firstDayOfWeek) {
  let julian = date.calendar.toJulianDay(date);
  let weekStart = firstDayOfWeek ? $14e0f24ef4ac5c92$var$DAY_MAP[firstDayOfWeek] : $14e0f24ef4ac5c92$var$getWeekStart(locale);
  let dayOfWeek = Math.ceil(julian + 1 - weekStart) % 7;
  if (dayOfWeek < 0) dayOfWeek += 7;
  return dayOfWeek;
}
function $14e0f24ef4ac5c92$export$461939dd4422153(timeZone) {
  return (0, $11d87f3f76e88657$export$1b96692a1ba042ac)(Date.now(), timeZone);
}
function $14e0f24ef4ac5c92$export$d0bdf45af03a6ea3(timeZone) {
  return (0, $11d87f3f76e88657$export$93522d1a439f3617)($14e0f24ef4ac5c92$export$461939dd4422153(timeZone));
}
function $14e0f24ef4ac5c92$export$68781ddf31c0090f(a, b) {
  return a.calendar.toJulianDay(a) - b.calendar.toJulianDay(b);
}
function $14e0f24ef4ac5c92$export$c19a80a9721b80f6(a, b) {
  return $14e0f24ef4ac5c92$var$timeToMs(a) - $14e0f24ef4ac5c92$var$timeToMs(b);
}
function $14e0f24ef4ac5c92$var$timeToMs(a) {
  return a.hour * 36e5 + a.minute * 6e4 + a.second * 1e3 + a.millisecond;
}
var $14e0f24ef4ac5c92$var$localTimeZone = null;
function $14e0f24ef4ac5c92$export$aa8b41735afcabd2() {
  if ($14e0f24ef4ac5c92$var$localTimeZone == null) $14e0f24ef4ac5c92$var$localTimeZone = new Intl.DateTimeFormat().resolvedOptions().timeZone;
  return $14e0f24ef4ac5c92$var$localTimeZone;
}
function $14e0f24ef4ac5c92$export$a5a3b454ada2268e(date) {
  return date.subtract({
    days: date.day - 1
  });
}
function $14e0f24ef4ac5c92$export$a2258d9c4118825c(date) {
  return date.add({
    days: date.calendar.getDaysInMonth(date) - date.day
  });
}
function $14e0f24ef4ac5c92$export$f91e89d3d0406102(date) {
  return $14e0f24ef4ac5c92$export$a5a3b454ada2268e(date.subtract({
    months: date.month - 1
  }));
}
function $14e0f24ef4ac5c92$export$8b7aa55c66d5569e(date) {
  return $14e0f24ef4ac5c92$export$a2258d9c4118825c(date.add({
    months: date.calendar.getMonthsInYear(date) - date.month
  }));
}
function $14e0f24ef4ac5c92$export$42c81a444fbfb5d4(date, locale, firstDayOfWeek) {
  let dayOfWeek = $14e0f24ef4ac5c92$export$2061056d06d7cdf7(date, locale, firstDayOfWeek);
  return date.subtract({
    days: dayOfWeek
  });
}
function $14e0f24ef4ac5c92$export$ef8b6d9133084f4e(date, locale, firstDayOfWeek) {
  return $14e0f24ef4ac5c92$export$42c81a444fbfb5d4(date, locale, firstDayOfWeek).add({
    days: 6
  });
}
var $14e0f24ef4ac5c92$var$cachedRegions = /* @__PURE__ */ new Map();
var $14e0f24ef4ac5c92$var$cachedWeekInfo = /* @__PURE__ */ new Map();
function $14e0f24ef4ac5c92$var$getRegion(locale) {
  if (Intl.Locale) {
    let region = $14e0f24ef4ac5c92$var$cachedRegions.get(locale);
    if (!region) {
      region = new Intl.Locale(locale).maximize().region;
      if (region) $14e0f24ef4ac5c92$var$cachedRegions.set(locale, region);
    }
    return region;
  }
  let part = locale.split("-")[1];
  return part === "u" ? void 0 : part;
}
function $14e0f24ef4ac5c92$var$getWeekStart(locale) {
  let weekInfo = $14e0f24ef4ac5c92$var$cachedWeekInfo.get(locale);
  if (!weekInfo) {
    if (Intl.Locale) {
      let localeInst = new Intl.Locale(locale);
      if ("getWeekInfo" in localeInst) {
        weekInfo = localeInst.getWeekInfo();
        if (weekInfo) {
          $14e0f24ef4ac5c92$var$cachedWeekInfo.set(locale, weekInfo);
          return weekInfo.firstDay;
        }
      }
    }
    let region = $14e0f24ef4ac5c92$var$getRegion(locale);
    if (locale.includes("-fw-")) {
      let day = locale.split("-fw-")[1].split("-")[0];
      if (day === "mon") weekInfo = {
        firstDay: 1
      };
      else if (day === "tue") weekInfo = {
        firstDay: 2
      };
      else if (day === "wed") weekInfo = {
        firstDay: 3
      };
      else if (day === "thu") weekInfo = {
        firstDay: 4
      };
      else if (day === "fri") weekInfo = {
        firstDay: 5
      };
      else if (day === "sat") weekInfo = {
        firstDay: 6
      };
      else weekInfo = {
        firstDay: 0
      };
    } else if (locale.includes("-ca-iso8601")) weekInfo = {
      firstDay: 1
    };
    else weekInfo = {
      firstDay: region ? (0, $2fe286d2fb449abb$export$7a5acbd77d414bd9)[region] || 0 : 0
    };
    $14e0f24ef4ac5c92$var$cachedWeekInfo.set(locale, weekInfo);
  }
  return weekInfo.firstDay;
}
function $14e0f24ef4ac5c92$export$ccc1b2479e7dd654(date, locale, firstDayOfWeek) {
  let days = date.calendar.getDaysInMonth(date);
  return Math.ceil(($14e0f24ef4ac5c92$export$2061056d06d7cdf7($14e0f24ef4ac5c92$export$a5a3b454ada2268e(date), locale, firstDayOfWeek) + days) / 7);
}
function $14e0f24ef4ac5c92$export$5c333a116e949cdd(a, b) {
  if (a && b) return a.compare(b) <= 0 ? a : b;
  return a || b;
}
function $14e0f24ef4ac5c92$export$a75f2bff57811055(a, b) {
  if (a && b) return a.compare(b) >= 0 ? a : b;
  return a || b;
}
var $14e0f24ef4ac5c92$var$WEEKEND_DATA = {
  AF: [
    4,
    5
  ],
  AE: [
    5,
    6
  ],
  BH: [
    5,
    6
  ],
  DZ: [
    5,
    6
  ],
  EG: [
    5,
    6
  ],
  IL: [
    5,
    6
  ],
  IQ: [
    5,
    6
  ],
  IR: [
    5,
    5
  ],
  JO: [
    5,
    6
  ],
  KW: [
    5,
    6
  ],
  LY: [
    5,
    6
  ],
  OM: [
    5,
    6
  ],
  QA: [
    5,
    6
  ],
  SA: [
    5,
    6
  ],
  SD: [
    5,
    6
  ],
  SY: [
    5,
    6
  ],
  YE: [
    5,
    6
  ]
};
function $14e0f24ef4ac5c92$export$618d60ea299da42(date, locale) {
  let julian = date.calendar.toJulianDay(date);
  let dayOfWeek = Math.ceil(julian + 1) % 7;
  if (dayOfWeek < 0) dayOfWeek += 7;
  let region = $14e0f24ef4ac5c92$var$getRegion(locale);
  let [start, end] = $14e0f24ef4ac5c92$var$WEEKEND_DATA[region] || [
    6,
    0
  ];
  return dayOfWeek === start || dayOfWeek === end;
}

// ../node_modules/.pnpm/@internationalized+date@3.11.0/node_modules/@internationalized/date/dist/conversion.mjs
function $11d87f3f76e88657$export$bd4fb2bc8bb06fb(date) {
  date = $11d87f3f76e88657$export$b4a036af3fc0b032(date, new (0, $3b62074eb05584b2$export$80ee6245ec4f29ec)());
  let year = (0, $3b62074eb05584b2$export$c36e0ecb2d4fa69d)(date.era, date.year);
  return $11d87f3f76e88657$var$epochFromParts(year, date.month, date.day, date.hour, date.minute, date.second, date.millisecond);
}
function $11d87f3f76e88657$var$epochFromParts(year, month, day, hour, minute, second, millisecond) {
  let date = /* @__PURE__ */ new Date();
  date.setUTCHours(hour, minute, second, millisecond);
  date.setUTCFullYear(year, month - 1, day);
  return date.getTime();
}
function $11d87f3f76e88657$export$59c99f3515d3493f(ms, timeZone) {
  if (timeZone === "UTC") return 0;
  if (ms > 0 && timeZone === (0, $14e0f24ef4ac5c92$export$aa8b41735afcabd2)()) return new Date(ms).getTimezoneOffset() * -6e4;
  let { year, month, day, hour, minute, second } = $11d87f3f76e88657$var$getTimeZoneParts(ms, timeZone);
  let utc = $11d87f3f76e88657$var$epochFromParts(year, month, day, hour, minute, second, 0);
  return utc - Math.floor(ms / 1e3) * 1e3;
}
var $11d87f3f76e88657$var$formattersByTimeZone = /* @__PURE__ */ new Map();
function $11d87f3f76e88657$var$getTimeZoneParts(ms, timeZone) {
  let formatter = $11d87f3f76e88657$var$formattersByTimeZone.get(timeZone);
  if (!formatter) {
    formatter = new Intl.DateTimeFormat("en-US", {
      timeZone,
      hour12: false,
      era: "short",
      year: "numeric",
      month: "numeric",
      day: "numeric",
      hour: "numeric",
      minute: "numeric",
      second: "numeric"
    });
    $11d87f3f76e88657$var$formattersByTimeZone.set(timeZone, formatter);
  }
  let parts2 = formatter.formatToParts(new Date(ms));
  let namedParts = {};
  for (let part of parts2) if (part.type !== "literal") namedParts[part.type] = part.value;
  return {
    // Firefox returns B instead of BC... https://bugzilla.mozilla.org/show_bug.cgi?id=1752253
    year: namedParts.era === "BC" || namedParts.era === "B" ? -namedParts.year + 1 : +namedParts.year,
    month: +namedParts.month,
    day: +namedParts.day,
    hour: namedParts.hour === "24" ? 0 : +namedParts.hour,
    minute: +namedParts.minute,
    second: +namedParts.second
  };
}
var $11d87f3f76e88657$var$DAYMILLIS = 864e5;
function $11d87f3f76e88657$var$getValidWallTimes(date, timeZone, earlier, later) {
  let found = earlier === later ? [
    earlier
  ] : [
    earlier,
    later
  ];
  return found.filter((absolute) => $11d87f3f76e88657$var$isValidWallTime(date, timeZone, absolute));
}
function $11d87f3f76e88657$var$isValidWallTime(date, timeZone, absolute) {
  let parts2 = $11d87f3f76e88657$var$getTimeZoneParts(absolute, timeZone);
  return date.year === parts2.year && date.month === parts2.month && date.day === parts2.day && date.hour === parts2.hour && date.minute === parts2.minute && date.second === parts2.second;
}
function $11d87f3f76e88657$export$5107c82f94518f5c(date, timeZone, disambiguation = "compatible") {
  let dateTime = $11d87f3f76e88657$export$b21e0b124e224484(date);
  if (timeZone === "UTC") return $11d87f3f76e88657$export$bd4fb2bc8bb06fb(dateTime);
  if (timeZone === (0, $14e0f24ef4ac5c92$export$aa8b41735afcabd2)() && disambiguation === "compatible") {
    dateTime = $11d87f3f76e88657$export$b4a036af3fc0b032(dateTime, new (0, $3b62074eb05584b2$export$80ee6245ec4f29ec)());
    let date2 = /* @__PURE__ */ new Date();
    let year = (0, $3b62074eb05584b2$export$c36e0ecb2d4fa69d)(dateTime.era, dateTime.year);
    date2.setFullYear(year, dateTime.month - 1, dateTime.day);
    date2.setHours(dateTime.hour, dateTime.minute, dateTime.second, dateTime.millisecond);
    return date2.getTime();
  }
  let ms = $11d87f3f76e88657$export$bd4fb2bc8bb06fb(dateTime);
  let offsetBefore = $11d87f3f76e88657$export$59c99f3515d3493f(ms - $11d87f3f76e88657$var$DAYMILLIS, timeZone);
  let offsetAfter = $11d87f3f76e88657$export$59c99f3515d3493f(ms + $11d87f3f76e88657$var$DAYMILLIS, timeZone);
  let valid = $11d87f3f76e88657$var$getValidWallTimes(dateTime, timeZone, ms - offsetBefore, ms - offsetAfter);
  if (valid.length === 1) return valid[0];
  if (valid.length > 1) switch (disambiguation) {
    // 'compatible' means 'earlier' for "fall back" transitions
    case "compatible":
    case "earlier":
      return valid[0];
    case "later":
      return valid[valid.length - 1];
    case "reject":
      throw new RangeError("Multiple possible absolute times found");
  }
  switch (disambiguation) {
    case "earlier":
      return Math.min(ms - offsetBefore, ms - offsetAfter);
    // 'compatible' means 'later' for "spring forward" transitions
    case "compatible":
    case "later":
      return Math.max(ms - offsetBefore, ms - offsetAfter);
    case "reject":
      throw new RangeError("No such absolute time found");
  }
}
function $11d87f3f76e88657$export$e67a095c620b86fe(dateTime, timeZone, disambiguation = "compatible") {
  return new Date($11d87f3f76e88657$export$5107c82f94518f5c(dateTime, timeZone, disambiguation));
}
function $11d87f3f76e88657$export$1b96692a1ba042ac(ms, timeZone) {
  let offset = $11d87f3f76e88657$export$59c99f3515d3493f(ms, timeZone);
  let date = new Date(ms + offset);
  let year = date.getUTCFullYear();
  let month = date.getUTCMonth() + 1;
  let day = date.getUTCDate();
  let hour = date.getUTCHours();
  let minute = date.getUTCMinutes();
  let second = date.getUTCSeconds();
  let millisecond = date.getUTCMilliseconds();
  return new (0, $35ea8db9cb2ccb90$export$d3b7288e7994edea)(year < 1 ? "BC" : "AD", year < 1 ? -year + 1 : year, month, day, timeZone, offset, hour, minute, second, millisecond);
}
function $11d87f3f76e88657$export$93522d1a439f3617(dateTime) {
  return new (0, $35ea8db9cb2ccb90$export$99faa760c7908e4f)(dateTime.calendar, dateTime.era, dateTime.year, dateTime.month, dateTime.day);
}
function $11d87f3f76e88657$export$b21e0b124e224484(date, time) {
  let hour = 0, minute = 0, second = 0, millisecond = 0;
  if ("timeZone" in date) ({ hour, minute, second, millisecond } = date);
  else if ("hour" in date && !time) return date;
  if (time) ({ hour, minute, second, millisecond } = time);
  return new (0, $35ea8db9cb2ccb90$export$ca871e8dbb80966f)(date.calendar, date.era, date.year, date.month, date.day, hour, minute, second, millisecond);
}
function $11d87f3f76e88657$export$b4a036af3fc0b032(date, calendar) {
  if ((0, $14e0f24ef4ac5c92$export$dbc69fd56b53d5e)(date.calendar, calendar)) return date;
  let calendarDate = calendar.fromJulianDay(date.calendar.toJulianDay(date));
  let copy = date.copy();
  copy.calendar = calendar;
  copy.era = calendarDate.era;
  copy.year = calendarDate.year;
  copy.month = calendarDate.month;
  copy.day = calendarDate.day;
  (0, $735220c2d4774dd3$export$c4e2ecac49351ef2)(copy);
  return copy;
}
function $11d87f3f76e88657$export$84c95a83c799e074(date, timeZone, disambiguation) {
  if (date instanceof (0, $35ea8db9cb2ccb90$export$d3b7288e7994edea)) {
    if (date.timeZone === timeZone) return date;
    return $11d87f3f76e88657$export$538b00033cc11c75(date, timeZone);
  }
  let ms = $11d87f3f76e88657$export$5107c82f94518f5c(date, timeZone, disambiguation);
  return $11d87f3f76e88657$export$1b96692a1ba042ac(ms, timeZone);
}
function $11d87f3f76e88657$export$83aac07b4c37b25(date) {
  let ms = $11d87f3f76e88657$export$bd4fb2bc8bb06fb(date) - date.offset;
  return new Date(ms);
}
function $11d87f3f76e88657$export$538b00033cc11c75(date, timeZone) {
  let ms = $11d87f3f76e88657$export$bd4fb2bc8bb06fb(date) - date.offset;
  return $11d87f3f76e88657$export$b4a036af3fc0b032($11d87f3f76e88657$export$1b96692a1ba042ac(ms, timeZone), date.calendar);
}

// ../node_modules/.pnpm/@internationalized+date@3.11.0/node_modules/@internationalized/date/dist/manipulation.mjs
var $735220c2d4774dd3$var$ONE_HOUR = 36e5;
function $735220c2d4774dd3$export$e16d8520af44a096(date, duration) {
  let mutableDate = date.copy();
  let days = "hour" in mutableDate ? $735220c2d4774dd3$var$addTimeFields(mutableDate, duration) : 0;
  $735220c2d4774dd3$var$addYears(mutableDate, duration.years || 0);
  if (mutableDate.calendar.balanceYearMonth) mutableDate.calendar.balanceYearMonth(mutableDate, date);
  mutableDate.month += duration.months || 0;
  $735220c2d4774dd3$var$balanceYearMonth(mutableDate);
  $735220c2d4774dd3$var$constrainMonthDay(mutableDate);
  mutableDate.day += (duration.weeks || 0) * 7;
  mutableDate.day += duration.days || 0;
  mutableDate.day += days;
  $735220c2d4774dd3$var$balanceDay(mutableDate);
  if (mutableDate.calendar.balanceDate) mutableDate.calendar.balanceDate(mutableDate);
  if (mutableDate.year < 1) {
    mutableDate.year = 1;
    mutableDate.month = 1;
    mutableDate.day = 1;
  }
  let maxYear = mutableDate.calendar.getYearsInEra(mutableDate);
  if (mutableDate.year > maxYear) {
    var _mutableDate_calendar_isInverseEra, _mutableDate_calendar;
    let isInverseEra = (_mutableDate_calendar_isInverseEra = (_mutableDate_calendar = mutableDate.calendar).isInverseEra) === null || _mutableDate_calendar_isInverseEra === void 0 ? void 0 : _mutableDate_calendar_isInverseEra.call(_mutableDate_calendar, mutableDate);
    mutableDate.year = maxYear;
    mutableDate.month = isInverseEra ? 1 : mutableDate.calendar.getMonthsInYear(mutableDate);
    mutableDate.day = isInverseEra ? 1 : mutableDate.calendar.getDaysInMonth(mutableDate);
  }
  if (mutableDate.month < 1) {
    mutableDate.month = 1;
    mutableDate.day = 1;
  }
  let maxMonth = mutableDate.calendar.getMonthsInYear(mutableDate);
  if (mutableDate.month > maxMonth) {
    mutableDate.month = maxMonth;
    mutableDate.day = mutableDate.calendar.getDaysInMonth(mutableDate);
  }
  mutableDate.day = Math.max(1, Math.min(mutableDate.calendar.getDaysInMonth(mutableDate), mutableDate.day));
  return mutableDate;
}
function $735220c2d4774dd3$var$addYears(date, years) {
  var _date_calendar_isInverseEra, _date_calendar;
  if ((_date_calendar_isInverseEra = (_date_calendar = date.calendar).isInverseEra) === null || _date_calendar_isInverseEra === void 0 ? void 0 : _date_calendar_isInverseEra.call(_date_calendar, date)) years = -years;
  date.year += years;
}
function $735220c2d4774dd3$var$balanceYearMonth(date) {
  while (date.month < 1) {
    $735220c2d4774dd3$var$addYears(date, -1);
    date.month += date.calendar.getMonthsInYear(date);
  }
  let monthsInYear = 0;
  while (date.month > (monthsInYear = date.calendar.getMonthsInYear(date))) {
    date.month -= monthsInYear;
    $735220c2d4774dd3$var$addYears(date, 1);
  }
}
function $735220c2d4774dd3$var$balanceDay(date) {
  while (date.day < 1) {
    date.month--;
    $735220c2d4774dd3$var$balanceYearMonth(date);
    date.day += date.calendar.getDaysInMonth(date);
  }
  while (date.day > date.calendar.getDaysInMonth(date)) {
    date.day -= date.calendar.getDaysInMonth(date);
    date.month++;
    $735220c2d4774dd3$var$balanceYearMonth(date);
  }
}
function $735220c2d4774dd3$var$constrainMonthDay(date) {
  date.month = Math.max(1, Math.min(date.calendar.getMonthsInYear(date), date.month));
  date.day = Math.max(1, Math.min(date.calendar.getDaysInMonth(date), date.day));
}
function $735220c2d4774dd3$export$c4e2ecac49351ef2(date) {
  if (date.calendar.constrainDate) date.calendar.constrainDate(date);
  date.year = Math.max(1, Math.min(date.calendar.getYearsInEra(date), date.year));
  $735220c2d4774dd3$var$constrainMonthDay(date);
}
function $735220c2d4774dd3$export$3e2544e88a25bff8(duration) {
  let inverseDuration = {};
  for (let key in duration) if (typeof duration[key] === "number") inverseDuration[key] = -duration[key];
  return inverseDuration;
}
function $735220c2d4774dd3$export$4e2d2ead65e5f7e3(date, duration) {
  return $735220c2d4774dd3$export$e16d8520af44a096(date, $735220c2d4774dd3$export$3e2544e88a25bff8(duration));
}
function $735220c2d4774dd3$export$adaa4cf7ef1b65be(date, fields) {
  let mutableDate = date.copy();
  if (fields.era != null) mutableDate.era = fields.era;
  if (fields.year != null) mutableDate.year = fields.year;
  if (fields.month != null) mutableDate.month = fields.month;
  if (fields.day != null) mutableDate.day = fields.day;
  $735220c2d4774dd3$export$c4e2ecac49351ef2(mutableDate);
  return mutableDate;
}
function $735220c2d4774dd3$export$e5d5e1c1822b6e56(value, fields) {
  let mutableValue = value.copy();
  if (fields.hour != null) mutableValue.hour = fields.hour;
  if (fields.minute != null) mutableValue.minute = fields.minute;
  if (fields.second != null) mutableValue.second = fields.second;
  if (fields.millisecond != null) mutableValue.millisecond = fields.millisecond;
  $735220c2d4774dd3$export$7555de1e070510cb(mutableValue);
  return mutableValue;
}
function $735220c2d4774dd3$var$balanceTime(time) {
  time.second += Math.floor(time.millisecond / 1e3);
  time.millisecond = $735220c2d4774dd3$var$nonNegativeMod(time.millisecond, 1e3);
  time.minute += Math.floor(time.second / 60);
  time.second = $735220c2d4774dd3$var$nonNegativeMod(time.second, 60);
  time.hour += Math.floor(time.minute / 60);
  time.minute = $735220c2d4774dd3$var$nonNegativeMod(time.minute, 60);
  let days = Math.floor(time.hour / 24);
  time.hour = $735220c2d4774dd3$var$nonNegativeMod(time.hour, 24);
  return days;
}
function $735220c2d4774dd3$export$7555de1e070510cb(time) {
  time.millisecond = Math.max(0, Math.min(time.millisecond, 1e3));
  time.second = Math.max(0, Math.min(time.second, 59));
  time.minute = Math.max(0, Math.min(time.minute, 59));
  time.hour = Math.max(0, Math.min(time.hour, 23));
}
function $735220c2d4774dd3$var$nonNegativeMod(a, b) {
  let result = a % b;
  if (result < 0) result += b;
  return result;
}
function $735220c2d4774dd3$var$addTimeFields(time, duration) {
  time.hour += duration.hours || 0;
  time.minute += duration.minutes || 0;
  time.second += duration.seconds || 0;
  time.millisecond += duration.milliseconds || 0;
  return $735220c2d4774dd3$var$balanceTime(time);
}
function $735220c2d4774dd3$export$d52ced6badfb9a4c(value, field, amount, options) {
  let mutable = value.copy();
  switch (field) {
    case "era": {
      let eras = value.calendar.getEras();
      let eraIndex = eras.indexOf(value.era);
      if (eraIndex < 0) throw new Error("Invalid era: " + value.era);
      eraIndex = $735220c2d4774dd3$var$cycleValue(eraIndex, amount, 0, eras.length - 1, options === null || options === void 0 ? void 0 : options.round);
      mutable.era = eras[eraIndex];
      $735220c2d4774dd3$export$c4e2ecac49351ef2(mutable);
      break;
    }
    case "year":
      var _mutable_calendar_isInverseEra, _mutable_calendar;
      if ((_mutable_calendar_isInverseEra = (_mutable_calendar = mutable.calendar).isInverseEra) === null || _mutable_calendar_isInverseEra === void 0 ? void 0 : _mutable_calendar_isInverseEra.call(_mutable_calendar, mutable)) amount = -amount;
      mutable.year = $735220c2d4774dd3$var$cycleValue(value.year, amount, -Infinity, 9999, options === null || options === void 0 ? void 0 : options.round);
      if (mutable.year === -Infinity) mutable.year = 1;
      if (mutable.calendar.balanceYearMonth) mutable.calendar.balanceYearMonth(mutable, value);
      break;
    case "month":
      mutable.month = $735220c2d4774dd3$var$cycleValue(value.month, amount, 1, value.calendar.getMonthsInYear(value), options === null || options === void 0 ? void 0 : options.round);
      break;
    case "day":
      mutable.day = $735220c2d4774dd3$var$cycleValue(value.day, amount, 1, value.calendar.getDaysInMonth(value), options === null || options === void 0 ? void 0 : options.round);
      break;
    default:
      throw new Error("Unsupported field " + field);
  }
  if (value.calendar.balanceDate) value.calendar.balanceDate(mutable);
  $735220c2d4774dd3$export$c4e2ecac49351ef2(mutable);
  return mutable;
}
function $735220c2d4774dd3$export$dd02b3e0007dfe28(value, field, amount, options) {
  let mutable = value.copy();
  switch (field) {
    case "hour": {
      let hours = value.hour;
      let min = 0;
      let max = 23;
      if ((options === null || options === void 0 ? void 0 : options.hourCycle) === 12) {
        let isPM = hours >= 12;
        min = isPM ? 12 : 0;
        max = isPM ? 23 : 11;
      }
      mutable.hour = $735220c2d4774dd3$var$cycleValue(hours, amount, min, max, options === null || options === void 0 ? void 0 : options.round);
      break;
    }
    case "minute":
      mutable.minute = $735220c2d4774dd3$var$cycleValue(value.minute, amount, 0, 59, options === null || options === void 0 ? void 0 : options.round);
      break;
    case "second":
      mutable.second = $735220c2d4774dd3$var$cycleValue(value.second, amount, 0, 59, options === null || options === void 0 ? void 0 : options.round);
      break;
    case "millisecond":
      mutable.millisecond = $735220c2d4774dd3$var$cycleValue(value.millisecond, amount, 0, 999, options === null || options === void 0 ? void 0 : options.round);
      break;
    default:
      throw new Error("Unsupported field " + field);
  }
  return mutable;
}
function $735220c2d4774dd3$var$cycleValue(value, amount, min, max, round = false) {
  if (round) {
    value += Math.sign(amount);
    if (value < min) value = max;
    let div = Math.abs(amount);
    if (amount > 0) value = Math.ceil(value / div) * div;
    else value = Math.floor(value / div) * div;
    if (value > max) value = min;
  } else {
    value += amount;
    if (value < min) value = max - (min - value - 1);
    else if (value > max) value = min + (value - max - 1);
  }
  return value;
}
function $735220c2d4774dd3$export$96b1d28349274637(dateTime, duration) {
  let ms;
  if (duration.years != null && duration.years !== 0 || duration.months != null && duration.months !== 0 || duration.weeks != null && duration.weeks !== 0 || duration.days != null && duration.days !== 0) {
    let res2 = $735220c2d4774dd3$export$e16d8520af44a096((0, $11d87f3f76e88657$export$b21e0b124e224484)(dateTime), {
      years: duration.years,
      months: duration.months,
      weeks: duration.weeks,
      days: duration.days
    });
    ms = (0, $11d87f3f76e88657$export$5107c82f94518f5c)(res2, dateTime.timeZone);
  } else
    ms = (0, $11d87f3f76e88657$export$bd4fb2bc8bb06fb)(dateTime) - dateTime.offset;
  ms += duration.milliseconds || 0;
  ms += (duration.seconds || 0) * 1e3;
  ms += (duration.minutes || 0) * 6e4;
  ms += (duration.hours || 0) * 36e5;
  let res = (0, $11d87f3f76e88657$export$1b96692a1ba042ac)(ms, dateTime.timeZone);
  return (0, $11d87f3f76e88657$export$b4a036af3fc0b032)(res, dateTime.calendar);
}
function $735220c2d4774dd3$export$6814caac34ca03c7(dateTime, duration) {
  return $735220c2d4774dd3$export$96b1d28349274637(dateTime, $735220c2d4774dd3$export$3e2544e88a25bff8(duration));
}
function $735220c2d4774dd3$export$9a297d111fc86b79(dateTime, field, amount, options) {
  switch (field) {
    case "hour": {
      let min = 0;
      let max = 23;
      if ((options === null || options === void 0 ? void 0 : options.hourCycle) === 12) {
        let isPM = dateTime.hour >= 12;
        min = isPM ? 12 : 0;
        max = isPM ? 23 : 11;
      }
      let plainDateTime = (0, $11d87f3f76e88657$export$b21e0b124e224484)(dateTime);
      let minDate = (0, $11d87f3f76e88657$export$b4a036af3fc0b032)($735220c2d4774dd3$export$e5d5e1c1822b6e56(plainDateTime, {
        hour: min
      }), new (0, $3b62074eb05584b2$export$80ee6245ec4f29ec)());
      let minAbsolute = [
        (0, $11d87f3f76e88657$export$5107c82f94518f5c)(minDate, dateTime.timeZone, "earlier"),
        (0, $11d87f3f76e88657$export$5107c82f94518f5c)(minDate, dateTime.timeZone, "later")
      ].filter((ms2) => (0, $11d87f3f76e88657$export$1b96692a1ba042ac)(ms2, dateTime.timeZone).day === minDate.day)[0];
      let maxDate = (0, $11d87f3f76e88657$export$b4a036af3fc0b032)($735220c2d4774dd3$export$e5d5e1c1822b6e56(plainDateTime, {
        hour: max
      }), new (0, $3b62074eb05584b2$export$80ee6245ec4f29ec)());
      let maxAbsolute = [
        (0, $11d87f3f76e88657$export$5107c82f94518f5c)(maxDate, dateTime.timeZone, "earlier"),
        (0, $11d87f3f76e88657$export$5107c82f94518f5c)(maxDate, dateTime.timeZone, "later")
      ].filter((ms2) => (0, $11d87f3f76e88657$export$1b96692a1ba042ac)(ms2, dateTime.timeZone).day === maxDate.day).pop();
      let ms = (0, $11d87f3f76e88657$export$bd4fb2bc8bb06fb)(dateTime) - dateTime.offset;
      let hours = Math.floor(ms / $735220c2d4774dd3$var$ONE_HOUR);
      let remainder = ms % $735220c2d4774dd3$var$ONE_HOUR;
      ms = $735220c2d4774dd3$var$cycleValue(hours, amount, Math.floor(minAbsolute / $735220c2d4774dd3$var$ONE_HOUR), Math.floor(maxAbsolute / $735220c2d4774dd3$var$ONE_HOUR), options === null || options === void 0 ? void 0 : options.round) * $735220c2d4774dd3$var$ONE_HOUR + remainder;
      return (0, $11d87f3f76e88657$export$b4a036af3fc0b032)((0, $11d87f3f76e88657$export$1b96692a1ba042ac)(ms, dateTime.timeZone), dateTime.calendar);
    }
    case "minute":
    case "second":
    case "millisecond":
      return $735220c2d4774dd3$export$dd02b3e0007dfe28(dateTime, field, amount, options);
    case "era":
    case "year":
    case "month":
    case "day": {
      let res = $735220c2d4774dd3$export$d52ced6badfb9a4c((0, $11d87f3f76e88657$export$b21e0b124e224484)(dateTime), field, amount, options);
      let ms = (0, $11d87f3f76e88657$export$5107c82f94518f5c)(res, dateTime.timeZone);
      return (0, $11d87f3f76e88657$export$b4a036af3fc0b032)((0, $11d87f3f76e88657$export$1b96692a1ba042ac)(ms, dateTime.timeZone), dateTime.calendar);
    }
    default:
      throw new Error("Unsupported field " + field);
  }
}
function $735220c2d4774dd3$export$31b5430eb18be4f8(dateTime, fields, disambiguation) {
  let plainDateTime = (0, $11d87f3f76e88657$export$b21e0b124e224484)(dateTime);
  let res = $735220c2d4774dd3$export$e5d5e1c1822b6e56($735220c2d4774dd3$export$adaa4cf7ef1b65be(plainDateTime, fields), fields);
  if (res.compare(plainDateTime) === 0) return dateTime;
  let ms = (0, $11d87f3f76e88657$export$5107c82f94518f5c)(res, dateTime.timeZone, disambiguation);
  return (0, $11d87f3f76e88657$export$b4a036af3fc0b032)((0, $11d87f3f76e88657$export$1b96692a1ba042ac)(ms, dateTime.timeZone), dateTime.calendar);
}

// ../node_modules/.pnpm/@internationalized+date@3.11.0/node_modules/@internationalized/date/dist/string.mjs
var $fae977aafc393c5c$var$DATE_RE = /^([+-]\d{6}|\d{4})-(\d{2})-(\d{2})$/;
var $fae977aafc393c5c$var$ABSOLUTE_RE = /^([+-]\d{6}|\d{4})-(\d{2})-(\d{2})(?:T(\d{2}))?(?::(\d{2}))?(?::(\d{2}))?(\.\d+)?(?:(?:([+-]\d{2})(?::?(\d{2}))?)|Z)$/;
var $fae977aafc393c5c$var$requiredDurationTimeGroups = [
  "hours",
  "minutes",
  "seconds"
];
var $fae977aafc393c5c$var$requiredDurationGroups = [
  "years",
  "months",
  "weeks",
  "days",
  ...$fae977aafc393c5c$var$requiredDurationTimeGroups
];
function $fae977aafc393c5c$export$6b862160d295c8e(value) {
  let m = value.match($fae977aafc393c5c$var$DATE_RE);
  if (!m) {
    if ($fae977aafc393c5c$var$ABSOLUTE_RE.test(value)) throw new Error(`Invalid ISO 8601 date string: ${value}. Use parseAbsolute() instead.`);
    throw new Error("Invalid ISO 8601 date string: " + value);
  }
  let date = new (0, $35ea8db9cb2ccb90$export$99faa760c7908e4f)($fae977aafc393c5c$var$parseNumber(m[1], 0, 9999), $fae977aafc393c5c$var$parseNumber(m[2], 1, 12), 1);
  date.day = $fae977aafc393c5c$var$parseNumber(m[3], 1, date.calendar.getDaysInMonth(date));
  return date;
}
function $fae977aafc393c5c$var$parseNumber(value, min, max) {
  let val = Number(value);
  if (val < min || val > max) throw new RangeError(`Value out of range: ${min} <= ${val} <= ${max}`);
  return val;
}
function $fae977aafc393c5c$export$f59dee82248f5ad4(time) {
  return `${String(time.hour).padStart(2, "0")}:${String(time.minute).padStart(2, "0")}:${String(time.second).padStart(2, "0")}${time.millisecond ? String(time.millisecond / 1e3).slice(1) : ""}`;
}
function $fae977aafc393c5c$export$60dfd74aa96791bd(date) {
  let gregorianDate = (0, $11d87f3f76e88657$export$b4a036af3fc0b032)(date, new (0, $3b62074eb05584b2$export$80ee6245ec4f29ec)());
  let year;
  if (gregorianDate.era === "BC") year = gregorianDate.year === 1 ? "0000" : "-" + String(Math.abs(1 - gregorianDate.year)).padStart(6, "00");
  else year = String(gregorianDate.year).padStart(4, "0");
  return `${year}-${String(gregorianDate.month).padStart(2, "0")}-${String(gregorianDate.day).padStart(2, "0")}`;
}
function $fae977aafc393c5c$export$4223de14708adc63(date) {
  return `${$fae977aafc393c5c$export$60dfd74aa96791bd(date)}T${$fae977aafc393c5c$export$f59dee82248f5ad4(date)}`;
}
function $fae977aafc393c5c$var$offsetToString(offset) {
  let sign = Math.sign(offset) < 0 ? "-" : "+";
  offset = Math.abs(offset);
  let offsetHours = Math.floor(offset / 36e5);
  let offsetMinutes = Math.floor(offset % 36e5 / 6e4);
  let offsetSeconds = Math.floor(offset % 36e5 % 6e4 / 1e3);
  let stringOffset = `${sign}${String(offsetHours).padStart(2, "0")}:${String(offsetMinutes).padStart(2, "0")}`;
  if (offsetSeconds !== 0) stringOffset += `:${String(offsetSeconds).padStart(2, "0")}`;
  return stringOffset;
}
function $fae977aafc393c5c$export$bf79f1ebf4b18792(date) {
  return `${$fae977aafc393c5c$export$4223de14708adc63(date)}${$fae977aafc393c5c$var$offsetToString(date.offset)}[${date.timeZone}]`;
}

// ../node_modules/.pnpm/@swc+helpers@0.5.18/node_modules/@swc/helpers/esm/_check_private_redeclaration.js
function _check_private_redeclaration(obj, privateCollection) {
  if (privateCollection.has(obj)) {
    throw new TypeError("Cannot initialize the same private elements twice on an object");
  }
}

// ../node_modules/.pnpm/@swc+helpers@0.5.18/node_modules/@swc/helpers/esm/_class_private_field_init.js
function _class_private_field_init(obj, privateMap, value) {
  _check_private_redeclaration(obj, privateMap);
  privateMap.set(obj, value);
}

// ../node_modules/.pnpm/@internationalized+date@3.11.0/node_modules/@internationalized/date/dist/CalendarDate.mjs
function $35ea8db9cb2ccb90$var$shiftArgs(args) {
  let calendar = typeof args[0] === "object" ? args.shift() : new (0, $3b62074eb05584b2$export$80ee6245ec4f29ec)();
  let era;
  if (typeof args[0] === "string") era = args.shift();
  else {
    let eras = calendar.getEras();
    era = eras[eras.length - 1];
  }
  let year = args.shift();
  let month = args.shift();
  let day = args.shift();
  return [
    calendar,
    era,
    year,
    month,
    day
  ];
}
var $35ea8db9cb2ccb90$var$_type = /* @__PURE__ */ new WeakMap();
var $35ea8db9cb2ccb90$export$99faa760c7908e4f = class _$35ea8db9cb2ccb90$export$99faa760c7908e4f {
  /** Returns a copy of this date. */
  copy() {
    if (this.era) return new _$35ea8db9cb2ccb90$export$99faa760c7908e4f(this.calendar, this.era, this.year, this.month, this.day);
    else return new _$35ea8db9cb2ccb90$export$99faa760c7908e4f(this.calendar, this.year, this.month, this.day);
  }
  /** Returns a new `CalendarDate` with the given duration added to it. */
  add(duration) {
    return (0, $735220c2d4774dd3$export$e16d8520af44a096)(this, duration);
  }
  /** Returns a new `CalendarDate` with the given duration subtracted from it. */
  subtract(duration) {
    return (0, $735220c2d4774dd3$export$4e2d2ead65e5f7e3)(this, duration);
  }
  /** Returns a new `CalendarDate` with the given fields set to the provided values. Other fields will be constrained accordingly. */
  set(fields) {
    return (0, $735220c2d4774dd3$export$adaa4cf7ef1b65be)(this, fields);
  }
  /**
  * Returns a new `CalendarDate` with the given field adjusted by a specified amount.
  * When the resulting value reaches the limits of the field, it wraps around.
  */
  cycle(field, amount, options) {
    return (0, $735220c2d4774dd3$export$d52ced6badfb9a4c)(this, field, amount, options);
  }
  /** Converts the date to a native JavaScript Date object, with the time set to midnight in the given time zone. */
  toDate(timeZone) {
    return (0, $11d87f3f76e88657$export$e67a095c620b86fe)(this, timeZone);
  }
  /** Converts the date to an ISO 8601 formatted string. */
  toString() {
    return (0, $fae977aafc393c5c$export$60dfd74aa96791bd)(this);
  }
  /** Compares this date with another. A negative result indicates that this date is before the given one, and a positive date indicates that it is after. */
  compare(b) {
    return (0, $14e0f24ef4ac5c92$export$68781ddf31c0090f)(this, b);
  }
  constructor(...args) {
    (0, _class_private_field_init)(this, $35ea8db9cb2ccb90$var$_type, {
      writable: true,
      value: void 0
    });
    let [calendar, era, year, month, day] = $35ea8db9cb2ccb90$var$shiftArgs(args);
    this.calendar = calendar;
    this.era = era;
    this.year = year;
    this.month = month;
    this.day = day;
    (0, $735220c2d4774dd3$export$c4e2ecac49351ef2)(this);
  }
};
var $35ea8db9cb2ccb90$var$_type2 = /* @__PURE__ */ new WeakMap();
var $35ea8db9cb2ccb90$export$ca871e8dbb80966f = class _$35ea8db9cb2ccb90$export$ca871e8dbb80966f {
  /** Returns a copy of this date. */
  copy() {
    if (this.era) return new _$35ea8db9cb2ccb90$export$ca871e8dbb80966f(this.calendar, this.era, this.year, this.month, this.day, this.hour, this.minute, this.second, this.millisecond);
    else return new _$35ea8db9cb2ccb90$export$ca871e8dbb80966f(this.calendar, this.year, this.month, this.day, this.hour, this.minute, this.second, this.millisecond);
  }
  /** Returns a new `CalendarDateTime` with the given duration added to it. */
  add(duration) {
    return (0, $735220c2d4774dd3$export$e16d8520af44a096)(this, duration);
  }
  /** Returns a new `CalendarDateTime` with the given duration subtracted from it. */
  subtract(duration) {
    return (0, $735220c2d4774dd3$export$4e2d2ead65e5f7e3)(this, duration);
  }
  /** Returns a new `CalendarDateTime` with the given fields set to the provided values. Other fields will be constrained accordingly. */
  set(fields) {
    return (0, $735220c2d4774dd3$export$adaa4cf7ef1b65be)((0, $735220c2d4774dd3$export$e5d5e1c1822b6e56)(this, fields), fields);
  }
  /**
  * Returns a new `CalendarDateTime` with the given field adjusted by a specified amount.
  * When the resulting value reaches the limits of the field, it wraps around.
  */
  cycle(field, amount, options) {
    switch (field) {
      case "era":
      case "year":
      case "month":
      case "day":
        return (0, $735220c2d4774dd3$export$d52ced6badfb9a4c)(this, field, amount, options);
      default:
        return (0, $735220c2d4774dd3$export$dd02b3e0007dfe28)(this, field, amount, options);
    }
  }
  /** Converts the date to a native JavaScript Date object in the given time zone. */
  toDate(timeZone, disambiguation) {
    return (0, $11d87f3f76e88657$export$e67a095c620b86fe)(this, timeZone, disambiguation);
  }
  /** Converts the date to an ISO 8601 formatted string. */
  toString() {
    return (0, $fae977aafc393c5c$export$4223de14708adc63)(this);
  }
  /** Compares this date with another. A negative result indicates that this date is before the given one, and a positive date indicates that it is after. */
  compare(b) {
    let res = (0, $14e0f24ef4ac5c92$export$68781ddf31c0090f)(this, b);
    if (res === 0) return (0, $14e0f24ef4ac5c92$export$c19a80a9721b80f6)(this, (0, $11d87f3f76e88657$export$b21e0b124e224484)(b));
    return res;
  }
  constructor(...args) {
    (0, _class_private_field_init)(this, $35ea8db9cb2ccb90$var$_type2, {
      writable: true,
      value: void 0
    });
    let [calendar, era, year, month, day] = $35ea8db9cb2ccb90$var$shiftArgs(args);
    this.calendar = calendar;
    this.era = era;
    this.year = year;
    this.month = month;
    this.day = day;
    this.hour = args.shift() || 0;
    this.minute = args.shift() || 0;
    this.second = args.shift() || 0;
    this.millisecond = args.shift() || 0;
    (0, $735220c2d4774dd3$export$c4e2ecac49351ef2)(this);
  }
};
var $35ea8db9cb2ccb90$var$_type3 = /* @__PURE__ */ new WeakMap();
var $35ea8db9cb2ccb90$export$d3b7288e7994edea = class _$35ea8db9cb2ccb90$export$d3b7288e7994edea {
  /** Returns a copy of this date. */
  copy() {
    if (this.era) return new _$35ea8db9cb2ccb90$export$d3b7288e7994edea(this.calendar, this.era, this.year, this.month, this.day, this.timeZone, this.offset, this.hour, this.minute, this.second, this.millisecond);
    else return new _$35ea8db9cb2ccb90$export$d3b7288e7994edea(this.calendar, this.year, this.month, this.day, this.timeZone, this.offset, this.hour, this.minute, this.second, this.millisecond);
  }
  /** Returns a new `ZonedDateTime` with the given duration added to it. */
  add(duration) {
    return (0, $735220c2d4774dd3$export$96b1d28349274637)(this, duration);
  }
  /** Returns a new `ZonedDateTime` with the given duration subtracted from it. */
  subtract(duration) {
    return (0, $735220c2d4774dd3$export$6814caac34ca03c7)(this, duration);
  }
  /** Returns a new `ZonedDateTime` with the given fields set to the provided values. Other fields will be constrained accordingly. */
  set(fields, disambiguation) {
    return (0, $735220c2d4774dd3$export$31b5430eb18be4f8)(this, fields, disambiguation);
  }
  /**
  * Returns a new `ZonedDateTime` with the given field adjusted by a specified amount.
  * When the resulting value reaches the limits of the field, it wraps around.
  */
  cycle(field, amount, options) {
    return (0, $735220c2d4774dd3$export$9a297d111fc86b79)(this, field, amount, options);
  }
  /** Converts the date to a native JavaScript Date object. */
  toDate() {
    return (0, $11d87f3f76e88657$export$83aac07b4c37b25)(this);
  }
  /** Converts the date to an ISO 8601 formatted string, including the UTC offset and time zone identifier. */
  toString() {
    return (0, $fae977aafc393c5c$export$bf79f1ebf4b18792)(this);
  }
  /** Converts the date to an ISO 8601 formatted string in UTC. */
  toAbsoluteString() {
    return this.toDate().toISOString();
  }
  /** Compares this date with another. A negative result indicates that this date is before the given one, and a positive date indicates that it is after. */
  compare(b) {
    return this.toDate().getTime() - (0, $11d87f3f76e88657$export$84c95a83c799e074)(b, this.timeZone).toDate().getTime();
  }
  constructor(...args) {
    (0, _class_private_field_init)(this, $35ea8db9cb2ccb90$var$_type3, {
      writable: true,
      value: void 0
    });
    let [calendar, era, year, month, day] = $35ea8db9cb2ccb90$var$shiftArgs(args);
    let timeZone = args.shift();
    let offset = args.shift();
    this.calendar = calendar;
    this.era = era;
    this.year = year;
    this.month = month;
    this.day = day;
    this.timeZone = timeZone;
    this.offset = offset;
    this.hour = args.shift() || 0;
    this.minute = args.shift() || 0;
    this.second = args.shift() || 0;
    this.millisecond = args.shift() || 0;
    (0, $735220c2d4774dd3$export$c4e2ecac49351ef2)(this);
  }
};

// ../node_modules/.pnpm/@internationalized+date@3.11.0/node_modules/@internationalized/date/dist/DateFormatter.mjs
var $fb18d541ea1ad717$var$formatterCache = /* @__PURE__ */ new Map();
var $fb18d541ea1ad717$export$ad991b66133851cf = class {
  /** Formats a date as a string according to the locale and format options passed to the constructor. */
  format(value) {
    return this.formatter.format(value);
  }
  /** Formats a date to an array of parts such as separators, numbers, punctuation, and more. */
  formatToParts(value) {
    return this.formatter.formatToParts(value);
  }
  /** Formats a date range as a string. */
  formatRange(start, end) {
    if (typeof this.formatter.formatRange === "function")
      return this.formatter.formatRange(start, end);
    if (end < start) throw new RangeError("End date must be >= start date");
    return `${this.formatter.format(start)} \u2013 ${this.formatter.format(end)}`;
  }
  /** Formats a date range as an array of parts. */
  formatRangeToParts(start, end) {
    if (typeof this.formatter.formatRangeToParts === "function")
      return this.formatter.formatRangeToParts(start, end);
    if (end < start) throw new RangeError("End date must be >= start date");
    let startParts = this.formatter.formatToParts(start);
    let endParts = this.formatter.formatToParts(end);
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
    let resolvedOptions = this.formatter.resolvedOptions();
    if ($fb18d541ea1ad717$var$hasBuggyResolvedHourCycle()) {
      if (!this.resolvedHourCycle) this.resolvedHourCycle = $fb18d541ea1ad717$var$getResolvedHourCycle(resolvedOptions.locale, this.options);
      resolvedOptions.hourCycle = this.resolvedHourCycle;
      resolvedOptions.hour12 = this.resolvedHourCycle === "h11" || this.resolvedHourCycle === "h12";
    }
    if (resolvedOptions.calendar === "ethiopic-amete-alem") resolvedOptions.calendar = "ethioaa";
    return resolvedOptions;
  }
  constructor(locale, options = {}) {
    this.formatter = $fb18d541ea1ad717$var$getCachedDateFormatter(locale, options);
    this.options = options;
  }
};
var $fb18d541ea1ad717$var$hour12Preferences = {
  true: {
    // Only Japanese uses the h11 style for 12 hour time. All others use h12.
    ja: "h11"
  },
  false: {}
};
function $fb18d541ea1ad717$var$getCachedDateFormatter(locale, options = {}) {
  if (typeof options.hour12 === "boolean" && $fb18d541ea1ad717$var$hasBuggyHour12Behavior()) {
    options = {
      ...options
    };
    let pref = $fb18d541ea1ad717$var$hour12Preferences[String(options.hour12)][locale.split("-")[0]];
    let defaultHourCycle = options.hour12 ? "h12" : "h23";
    options.hourCycle = pref !== null && pref !== void 0 ? pref : defaultHourCycle;
    delete options.hour12;
  }
  let cacheKey = locale + (options ? Object.entries(options).sort((a, b) => a[0] < b[0] ? -1 : 1).join() : "");
  if ($fb18d541ea1ad717$var$formatterCache.has(cacheKey)) return $fb18d541ea1ad717$var$formatterCache.get(cacheKey);
  let numberFormatter = new Intl.DateTimeFormat(locale, options);
  $fb18d541ea1ad717$var$formatterCache.set(cacheKey, numberFormatter);
  return numberFormatter;
}
var $fb18d541ea1ad717$var$_hasBuggyHour12Behavior = null;
function $fb18d541ea1ad717$var$hasBuggyHour12Behavior() {
  if ($fb18d541ea1ad717$var$_hasBuggyHour12Behavior == null) $fb18d541ea1ad717$var$_hasBuggyHour12Behavior = new Intl.DateTimeFormat("en-US", {
    hour: "numeric",
    hour12: false
  }).format(new Date(2020, 2, 3, 0)) === "24";
  return $fb18d541ea1ad717$var$_hasBuggyHour12Behavior;
}
var $fb18d541ea1ad717$var$_hasBuggyResolvedHourCycle = null;
function $fb18d541ea1ad717$var$hasBuggyResolvedHourCycle() {
  if ($fb18d541ea1ad717$var$_hasBuggyResolvedHourCycle == null) $fb18d541ea1ad717$var$_hasBuggyResolvedHourCycle = new Intl.DateTimeFormat("fr", {
    hour: "numeric",
    hour12: false
  }).resolvedOptions().hourCycle === "h12";
  return $fb18d541ea1ad717$var$_hasBuggyResolvedHourCycle;
}
function $fb18d541ea1ad717$var$getResolvedHourCycle(locale, options) {
  if (!options.timeStyle && !options.hour) return void 0;
  locale = locale.replace(/(-u-)?-nu-[a-zA-Z0-9]+/, "");
  locale += (locale.includes("-u-") ? "" : "-u") + "-nu-latn";
  let formatter = $fb18d541ea1ad717$var$getCachedDateFormatter(locale, {
    ...options,
    timeZone: void 0
    // use local timezone
  });
  let min = parseInt(formatter.formatToParts(new Date(2020, 2, 3, 0)).find((p) => p.type === "hour").value, 10);
  let max = parseInt(formatter.formatToParts(new Date(2020, 2, 3, 23)).find((p) => p.type === "hour").value, 10);
  if (min === 0 && max === 23) return "h23";
  if (min === 24 && max === 23) return "h24";
  if (min === 0 && max === 11) return "h11";
  if (min === 12 && max === 11) return "h12";
  throw new Error("Unexpected hour cycle result");
}

// ../node_modules/.pnpm/@zag-js+date-utils@1.33.1_@internationalized+date@3.11.0/node_modules/@zag-js/date-utils/dist/index.mjs
function alignCenter(date, duration, locale, min, max) {
  const halfDuration = {};
  for (let prop in duration) {
    const key = prop;
    const value = duration[key];
    if (value == null) continue;
    halfDuration[key] = Math.floor(value / 2);
    if (halfDuration[key] > 0 && value % 2 === 0) {
      halfDuration[key]--;
    }
  }
  const aligned = alignStart(date, duration, locale).subtract(halfDuration);
  return constrainStart(date, aligned, duration, locale, min, max);
}
function alignStart(date, duration, locale, min, max) {
  let aligned = date;
  if (duration.years) {
    aligned = $14e0f24ef4ac5c92$export$f91e89d3d0406102(date);
  } else if (duration.months) {
    aligned = $14e0f24ef4ac5c92$export$a5a3b454ada2268e(date);
  } else if (duration.weeks) {
    aligned = $14e0f24ef4ac5c92$export$42c81a444fbfb5d4(date, locale);
  }
  return constrainStart(date, aligned, duration, locale, min, max);
}
function alignEnd(date, duration, locale, min, max) {
  let d = { ...duration };
  if (d.days) {
    d.days--;
  } else if (d.weeks) {
    d.weeks--;
  } else if (d.months) {
    d.months--;
  } else if (d.years) {
    d.years--;
  }
  let aligned = alignStart(date, duration, locale).subtract(d);
  return constrainStart(date, aligned, duration, locale, min, max);
}
function constrainStart(date, aligned, duration, locale, min, max) {
  if (min && date.compare(min) >= 0) {
    aligned = $14e0f24ef4ac5c92$export$a75f2bff57811055(aligned, alignStart($11d87f3f76e88657$export$93522d1a439f3617(min), duration, locale));
  }
  if (max && date.compare(max) <= 0) {
    aligned = $14e0f24ef4ac5c92$export$5c333a116e949cdd(aligned, alignEnd($11d87f3f76e88657$export$93522d1a439f3617(max), duration, locale));
  }
  return aligned;
}
function constrainValue(date, minValue, maxValue) {
  let constrainedDate = $11d87f3f76e88657$export$93522d1a439f3617(date);
  if (minValue) {
    constrainedDate = $14e0f24ef4ac5c92$export$a75f2bff57811055(constrainedDate, $11d87f3f76e88657$export$93522d1a439f3617(minValue));
  }
  if (maxValue) {
    constrainedDate = $14e0f24ef4ac5c92$export$5c333a116e949cdd(constrainedDate, $11d87f3f76e88657$export$93522d1a439f3617(maxValue));
  }
  return constrainedDate;
}
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
function isDateEqual(dateA, dateB) {
  if (dateA == null || dateB == null) return dateA === dateB;
  return $14e0f24ef4ac5c92$export$ea39ec197993aef0(dateA, dateB);
}
function isDateUnavailable(date, isUnavailable, locale, minValue, maxValue) {
  if (!date) return false;
  if (isUnavailable?.(date, locale)) return true;
  return isDateOutsideRange(date, minValue, maxValue);
}
function isDateOutsideRange(date, startDate, endDate) {
  return startDate != null && date.compare(startDate) < 0 || endDate != null && date.compare(endDate) > 0;
}
function isPreviousRangeInvalid(startDate, minValue, maxValue) {
  const prevDate = startDate.subtract({ days: 1 });
  return $14e0f24ef4ac5c92$export$ea39ec197993aef0(prevDate, startDate) || isDateOutsideRange(prevDate, minValue, maxValue);
}
function isNextRangeInvalid(endDate, minValue, maxValue) {
  const nextDate = endDate.add({ days: 1 });
  return $14e0f24ef4ac5c92$export$ea39ec197993aef0(nextDate, endDate) || isDateOutsideRange(nextDate, minValue, maxValue);
}
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
function getEraFormat(date) {
  return date?.calendar.identifier === "gregory" && date.era === "BC" ? "short" : void 0;
}
function getDayFormatter(locale, timeZone) {
  const date = $11d87f3f76e88657$export$b21e0b124e224484($14e0f24ef4ac5c92$export$d0bdf45af03a6ea3(timeZone));
  return new $fb18d541ea1ad717$export$ad991b66133851cf(locale, {
    weekday: "long",
    month: "long",
    year: "numeric",
    day: "numeric",
    era: getEraFormat(date),
    timeZone
  });
}
function getMonthFormatter(locale, timeZone) {
  const date = $14e0f24ef4ac5c92$export$d0bdf45af03a6ea3(timeZone);
  return new $fb18d541ea1ad717$export$ad991b66133851cf(locale, {
    month: "long",
    year: "numeric",
    era: getEraFormat(date),
    calendar: date?.calendar.identifier,
    timeZone
  });
}
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
  if ($14e0f24ef4ac5c92$export$ea39ec197993aef0(start, end)) {
    return formatter.format(start.toDate(timeZone));
  }
  return formatRange(start, end, formatter, (start2, end2) => `${start2} \u2013 ${end2}`, timeZone);
}
var daysOfTheWeek = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"];
function normalizeFirstDayOfWeek(firstDayOfWeek) {
  return firstDayOfWeek != null ? daysOfTheWeek[firstDayOfWeek] : void 0;
}
function getStartOfWeek(date, locale, firstDayOfWeek) {
  const firstDay = normalizeFirstDayOfWeek(firstDayOfWeek);
  return $14e0f24ef4ac5c92$export$42c81a444fbfb5d4(date, locale, firstDay);
}
function getDaysInWeek(weekIndex, from, locale, firstDayOfWeek) {
  const weekDate = from.add({ weeks: weekIndex });
  const dates = [];
  let date = getStartOfWeek(weekDate, locale, firstDayOfWeek);
  while (dates.length < 7) {
    dates.push(date);
    let nextDate = date.add({ days: 1 });
    if ($14e0f24ef4ac5c92$export$ea39ec197993aef0(date, nextDate)) break;
    date = nextDate;
  }
  return dates;
}
function getMonthDays(from, locale, numOfWeeks, firstDayOfWeek) {
  const firstDay = normalizeFirstDayOfWeek(firstDayOfWeek);
  const monthWeeks = numOfWeeks ?? $14e0f24ef4ac5c92$export$ccc1b2479e7dd654(from, locale, firstDay);
  const weeks = [...new Array(monthWeeks).keys()];
  return weeks.map((week) => getDaysInWeek(week, from, locale, firstDayOfWeek));
}
function getWeekdayFormats(locale, timeZone) {
  const longFormat = new $fb18d541ea1ad717$export$ad991b66133851cf(locale, { weekday: "long", timeZone });
  const shortFormat = new $fb18d541ea1ad717$export$ad991b66133851cf(locale, { weekday: "short", timeZone });
  const narrowFormat = new $fb18d541ea1ad717$export$ad991b66133851cf(locale, { weekday: "narrow", timeZone });
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
function getMonthNames(locale, format = "long") {
  const date = new Date(2021, 0, 1);
  const monthNames = [];
  for (let i = 0; i < 12; i++) {
    monthNames.push(date.toLocaleString(locale, { month: format }));
    date.setMonth(date.getMonth() + 1);
  }
  return monthNames;
}
function getYearsRange(range) {
  const years = [];
  for (let year = range.from; year <= range.to; year += 1) years.push(year);
  return years;
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
function getTodayDate(timeZone) {
  return $14e0f24ef4ac5c92$export$d0bdf45af03a6ea3(timeZone ?? $14e0f24ef4ac5c92$export$aa8b41735afcabd2());
}
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
    return new $35ea8db9cb2ccb90$export$99faa760c7908e4f(+year, +month, +day);
  }
  const time = Date.parse(date);
  if (!isNaN(time)) {
    const date2 = new Date(time);
    return new $35ea8db9cb2ccb90$export$99faa760c7908e4f(date2.getFullYear(), date2.getMonth() + 1, date2.getDate());
  }
}
function createRegex(locale, timeZone) {
  const formatter = new $fb18d541ea1ad717$export$ad991b66133851cf(locale, { day: "numeric", month: "numeric", year: "numeric", timeZone });
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
function getDateRangePreset(preset, locale, timeZone) {
  const today3 = $11d87f3f76e88657$export$93522d1a439f3617($14e0f24ef4ac5c92$export$461939dd4422153(timeZone));
  switch (preset) {
    case "thisWeek":
      return [$14e0f24ef4ac5c92$export$42c81a444fbfb5d4(today3, locale), $14e0f24ef4ac5c92$export$ef8b6d9133084f4e(today3, locale)];
    case "thisMonth":
      return [$14e0f24ef4ac5c92$export$a5a3b454ada2268e(today3), today3];
    case "thisQuarter":
      return [$14e0f24ef4ac5c92$export$a5a3b454ada2268e(today3).add({ months: -((today3.month - 1) % 3) }), today3];
    case "thisYear":
      return [$14e0f24ef4ac5c92$export$f91e89d3d0406102(today3), today3];
    case "last3Days":
      return [today3.add({ days: -2 }), today3];
    case "last7Days":
      return [today3.add({ days: -6 }), today3];
    case "last14Days":
      return [today3.add({ days: -13 }), today3];
    case "last30Days":
      return [today3.add({ days: -29 }), today3];
    case "last90Days":
      return [today3.add({ days: -89 }), today3];
    case "lastMonth":
      return [$14e0f24ef4ac5c92$export$a5a3b454ada2268e(today3.add({ months: -1 })), $14e0f24ef4ac5c92$export$a2258d9c4118825c(today3.add({ months: -1 }))];
    case "lastQuarter":
      return [
        $14e0f24ef4ac5c92$export$a5a3b454ada2268e(today3.add({ months: -((today3.month - 1) % 3) - 3 })),
        $14e0f24ef4ac5c92$export$a2258d9c4118825c(today3.add({ months: -((today3.month - 1) % 3) - 1 }))
      ];
    case "lastWeek":
      return [$14e0f24ef4ac5c92$export$42c81a444fbfb5d4(today3, locale).add({ weeks: -1 }), $14e0f24ef4ac5c92$export$ef8b6d9133084f4e(today3, locale).add({ weeks: -1 })];
    case "lastYear":
      return [$14e0f24ef4ac5c92$export$f91e89d3d0406102(today3.add({ years: -1 })), $14e0f24ef4ac5c92$export$8b7aa55c66d5569e(today3.add({ years: -1 }))];
    default:
      throw new Error(`Invalid date range preset: ${preset}`);
  }
}

// ../node_modules/.pnpm/@zag-js+live-region@1.33.1/node_modules/@zag-js/live-region/dist/index.mjs
var ID = "__live-region__";
function createLiveRegion(opts = {}) {
  const { level = "polite", document: doc = document, root, delay: _delay = 0 } = opts;
  const win = doc.defaultView ?? window;
  const parent = root ?? doc.body;
  function announce(message, delay) {
    const oldRegion = doc.getElementById(ID);
    oldRegion?.remove();
    delay = delay ?? _delay;
    const region = doc.createElement("span");
    region.id = ID;
    region.dataset.liveAnnouncer = "true";
    const role = level !== "assertive" ? "status" : "alert";
    region.setAttribute("aria-live", level);
    region.setAttribute("role", role);
    Object.assign(region.style, {
      border: "0",
      clip: "rect(0 0 0 0)",
      height: "1px",
      margin: "-1px",
      overflow: "hidden",
      padding: "0",
      position: "absolute",
      width: "1px",
      whiteSpace: "nowrap",
      wordWrap: "normal"
    });
    parent.appendChild(region);
    win.setTimeout(() => {
      region.textContent = message;
    }, delay);
  }
  function destroy() {
    const oldRegion = doc.getElementById(ID);
    oldRegion?.remove();
  }
  return {
    announce,
    destroy,
    toJSON() {
      return ID;
    }
  };
}

// ../node_modules/.pnpm/@zag-js+date-picker@1.33.1_@internationalized+date@3.11.0/node_modules/@zag-js/date-picker/dist/index.mjs
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
  return new $fb18d541ea1ad717$export$ad991b66133851cf(locale).formatToParts(/* @__PURE__ */ new Date()).map((item) => PLACEHOLDERS[item.type] ?? item.value).join("");
}
var isValidCharacter = (char, separator) => {
  if (!char) return true;
  return /\d/.test(char) || char === separator || char.length !== 1;
};
var isValidDate = (value) => {
  return !Number.isNaN(value.day) && !Number.isNaN(value.month) && !Number.isNaN(value.year);
};
var ensureValidCharacters = (value, separator) => {
  return value.split("").filter((char) => isValidCharacter(char, separator)).join("");
};
function getLocaleSeparator(locale) {
  const dateFormatter = new Intl.DateTimeFormat(locale);
  const parts2 = dateFormatter.formatToParts(/* @__PURE__ */ new Date());
  const literalPart = parts2.find((part) => part.type === "literal");
  return literalPart ? literalPart.value : "/";
}
var defaultTranslations = {
  dayCell(state) {
    if (state.unavailable) return `Not available. ${state.formattedDate}`;
    if (state.selected) return `Selected date. ${state.formattedDate}`;
    return `Choose ${state.formattedDate}`;
  },
  trigger(open) {
    return open ? "Close calendar" : "Open calendar";
  },
  viewTrigger(view) {
    return match(view, {
      year: "Switch to month view",
      month: "Switch to day view",
      day: "Switch to year view"
    });
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
  clearTrigger: "Clear selected dates"
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
  (opts) => [opts.view, opts.startValue.toString(), opts.endValue.toString(), opts.locale],
  ([view], opts) => {
    const { startValue, endValue, locale, timeZone, selectionMode } = opts;
    if (view === "year") {
      const years = getDecadeRange(startValue.year, { strict: true });
      const start2 = years.at(0).toString();
      const end2 = years.at(-1).toString();
      return { start: start2, end: end2, formatted: `${start2} - ${end2}` };
    }
    if (view === "month") {
      const formatter2 = new $fb18d541ea1ad717$export$ad991b66133851cf(locale, { year: "numeric", timeZone });
      const start2 = formatter2.format(startValue.toDate(timeZone));
      const end2 = formatter2.format(endValue.toDate(timeZone));
      const formatted2 = selectionMode === "range" ? `${start2} - ${end2}` : start2;
      return { start: start2, end: end2, formatted: formatted2 };
    }
    const formatter = new $fb18d541ea1ad717$export$ad991b66133851cf(locale, { month: "long", year: "numeric", timeZone });
    const start = formatter.format(startValue.toDate(timeZone));
    const end = formatter.format(endValue.toDate(timeZone));
    const formatted = selectionMode === "range" ? `${start} - ${end}` : start;
    return { start, end, formatted };
  }
);
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
  const isDateUnavailableFn = prop("isDateUnavailable");
  const currentPlacement = context.get("currentPlacement");
  const popperStyles = getPlacementStyles({
    ...prop("positioning"),
    placement: currentPlacement
  });
  const separator = getLocaleSeparator(locale);
  const translations = { ...defaultTranslations, ...prop("translations") };
  function getMonthWeeks(from = startValue) {
    const numOfWeeks = prop("fixedWeeks") ? 6 : void 0;
    return getMonthDays(from, locale, numOfWeeks, startOfWeek);
  }
  function getMonths(props2 = {}) {
    const { format } = props2;
    return getMonthNames(locale, format).map((label, index) => {
      const value = index + 1;
      const dateValue = focusedValue.set({ month: value });
      const disabled2 = isDateOutsideRange(dateValue, min, max);
      return { label, value, disabled: disabled2 };
    });
  }
  function getYears() {
    const range = getYearsRange({ from: min?.year ?? 1900, to: max?.year ?? 2100 });
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
    const date = startValue ?? getTodayDate(timeZone);
    send({ type: "FOCUS.SET", value: date.set({ month }) });
  }
  function focusYear(year) {
    const date = startValue ?? getTodayDate(timeZone);
    send({ type: "FOCUS.SET", value: date.set({ year }) });
  }
  function getYearTableCellState(props2) {
    const { value, disabled: disabled2 } = props2;
    const dateValue = focusedValue.set({ year: value });
    const decadeYears = getDecadeRange(startValue.year, { strict: true });
    const isOutsideVisibleRange = !decadeYears.includes(value);
    const isOutsideRange = isValueWithinRange(value, min?.year, max?.year);
    const cellState = {
      focused: focusedValue.year === props2.value,
      selectable: isOutsideVisibleRange || isOutsideRange,
      outsideRange: isOutsideVisibleRange,
      selected: !!selectedValue.find((date) => date && date.year === value),
      valueText: value.toString(),
      inRange: isRangePicker && (isDateWithinRange(dateValue, selectedValue) || isDateWithinRange(dateValue, hoveredRangeValue)),
      value: dateValue,
      get disabled() {
        return disabled2 || !cellState.selectable;
      }
    };
    return cellState;
  }
  function getMonthTableCellState(props2) {
    const { value, disabled: disabled2 } = props2;
    const dateValue = focusedValue.set({ month: value });
    const formatter = getMonthFormatter(locale, timeZone);
    const cellState = {
      focused: focusedValue.month === props2.value,
      selectable: !isDateOutsideRange(dateValue, min, max),
      selected: !!selectedValue.find((date) => date && date.month === value && date.year === focusedValue.year),
      valueText: formatter.format(dateValue.toDate(timeZone)),
      inRange: isRangePicker && (isDateWithinRange(dateValue, selectedValue) || isDateWithinRange(dateValue, hoveredRangeValue)),
      value: dateValue,
      get disabled() {
        return disabled2 || !cellState.selectable;
      }
    };
    return cellState;
  }
  function getDayTableCellState(props2) {
    const { value, disabled: disabled2, visibleRange = computed("visibleRange") } = props2;
    const formatter = getDayFormatter(locale, timeZone);
    const unitDuration = getUnitDuration(computed("visibleDuration"));
    const outsideDaySelectable = prop("outsideDaySelectable");
    const end = visibleRange.start.add(unitDuration).subtract({ days: 1 });
    const isOutsideRange = isDateOutsideRange(value, visibleRange.start, end);
    const isInSelectedRange = isRangePicker && isDateWithinRange(value, selectedValue);
    const isFirstInSelectedRange = isRangePicker && isDateEqual(value, selectedValue[0]);
    const isLastInSelectedRange = isRangePicker && isDateEqual(value, selectedValue[1]);
    const hasHoveredRange = isRangePicker && hoveredRangeValue.length > 0;
    const isInHoveredRange = hasHoveredRange && isDateWithinRange(value, hoveredRangeValue);
    const isFirstInHoveredRange = hasHoveredRange && isDateEqual(value, hoveredRangeValue[0]);
    const isLastInHoveredRange = hasHoveredRange && isDateEqual(value, hoveredRangeValue[1]);
    const cellState = {
      invalid: isDateOutsideRange(value, min, max),
      disabled: disabled2 || !outsideDaySelectable && isOutsideRange || isDateOutsideRange(value, min, max),
      selected: selectedValue.some((date) => isDateEqual(value, date)),
      unavailable: isDateUnavailable(value, isDateUnavailableFn, locale, min, max) && !disabled2,
      outsideRange: isOutsideRange,
      today: $14e0f24ef4ac5c92$export$629b0a497aa65267(value, timeZone),
      weekend: $14e0f24ef4ac5c92$export$618d60ea299da42(value, locale),
      formattedDate: formatter.format(value.toDate(timeZone)),
      get focused() {
        return isDateEqual(value, focusedValue) && (!cellState.outsideRange || outsideDaySelectable);
      },
      get ariaLabel() {
        return translations.dayCell(cellState);
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
  function getTableId2(props2) {
    const { view = "day", id } = props2;
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
    selectionMode: prop("selectionMode"),
    view: context.get("view"),
    getRangePresetValue(preset) {
      return getDateRangePreset(preset, locale, timeZone);
    },
    getDaysInWeek(week, from = startValue) {
      return getDaysInWeek(week, from, locale, startOfWeek);
    },
    getOffset(duration) {
      const from = startValue.add(duration);
      const end = endValue.add(duration);
      const formatter = getMonthFormatter(locale, timeZone);
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
    weekDays: getWeekDays(getTodayDate(timeZone), startOfWeek, timeZone, locale),
    visibleRangeText: computed("visibleRangeText"),
    value: selectedValue,
    valueAsDate: selectedValue.filter((date) => date != null).map((date) => date.toDate(timeZone)),
    valueAsString: computed("valueAsString"),
    focusedValue,
    focusedValueAsDate: focusedValue?.toDate(timeZone),
    focusedValueAsString: prop("format")(focusedValue, { locale, timeZone }),
    visibleRange: computed("visibleRange"),
    selectToday() {
      const value = constrainValue(getTodayDate(timeZone), min, max);
      send({ type: "VALUE.SET", value });
    },
    setValue(values) {
      const computedValue = values.map((date) => constrainValue(date, min, max));
      send({ type: "VALUE.SET", value: computedValue });
    },
    clearValue() {
      send({ type: "VALUE.CLEAR" });
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
    getYearsGrid(props2 = {}) {
      const { columns = 1 } = props2;
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
    getMonthsGrid(props2 = {}) {
      const { columns = 1, format } = props2;
      return chunk(getMonths({ format }), columns);
    },
    format(value, opts = { month: "long", year: "numeric" }) {
      return new $fb18d541ea1ad717$export$ad991b66133851cf(locale, opts).format(value.toDate(timeZone));
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
    getLabelProps(props2 = {}) {
      const { index = 0 } = props2;
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
        "data-inline": dataAttr(prop("inline")),
        id: getContentId(scope),
        tabIndex: -1,
        role: "application",
        "aria-roledescription": "datepicker",
        "aria-label": translations.content
      });
    },
    getTableProps(props2 = {}) {
      const { view = "day", columns = view === "day" ? 7 : 4 } = props2;
      const uid = getTableId2(props2);
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
          const keyMap = {
            Enter() {
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
    getTableHeadProps(props2 = {}) {
      const { view = "day" } = props2;
      return normalize.element({
        ...parts.tableHead.attrs,
        "aria-hidden": true,
        dir: prop("dir"),
        "data-view": view,
        "data-disabled": dataAttr(disabled)
      });
    },
    getTableHeaderProps(props2 = {}) {
      const { view = "day" } = props2;
      return normalize.element({
        ...parts.tableHeader.attrs,
        dir: prop("dir"),
        "data-view": view,
        "data-disabled": dataAttr(disabled)
      });
    },
    getTableBodyProps(props2 = {}) {
      const { view = "day" } = props2;
      return normalize.element({
        ...parts.tableBody.attrs,
        "data-view": view,
        "data-disabled": dataAttr(disabled)
      });
    },
    getTableRowProps(props2 = {}) {
      const { view = "day" } = props2;
      return normalize.element({
        ...parts.tableRow.attrs,
        "aria-disabled": ariaAttr(disabled),
        "data-disabled": dataAttr(disabled),
        "data-view": view
      });
    },
    getDayTableCellState,
    getDayTableCellProps(props2) {
      const { value } = props2;
      const cellState = getDayTableCellState(props2);
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
    getDayTableCellTriggerProps(props2) {
      const { value } = props2;
      const cellState = getDayTableCellState(props2);
      return normalize.element({
        ...parts.tableCellTrigger.attrs,
        id: getCellTriggerId(scope, value.toString()),
        role: "button",
        dir: prop("dir"),
        tabIndex: cellState.focused ? 0 : -1,
        "aria-label": cellState.ariaLabel,
        "aria-disabled": ariaAttr(!cellState.selectable),
        "aria-invalid": ariaAttr(cellState.invalid),
        "data-disabled": dataAttr(!cellState.selectable),
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
          if (!cellState.selectable) return;
          send({ type: "CELL.CLICK", cell: "day", value });
        },
        onPointerMove: isRangePicker ? (event) => {
          if (event.pointerType === "touch") return;
          if (!cellState.selectable) return;
          const focus = !scope.isActiveElement(event.currentTarget);
          if (hoveredValue && $14e0f24ef4ac5c92$export$91b62ebf2ba703ee(value, hoveredValue)) return;
          send({ type: "CELL.POINTER_MOVE", cell: "day", value, focus });
        } : void 0
      });
    },
    getMonthTableCellState,
    getMonthTableCellProps(props2) {
      const { value, columns } = props2;
      const cellState = getMonthTableCellState(props2);
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
    getMonthTableCellTriggerProps(props2) {
      const { value } = props2;
      const cellState = getMonthTableCellState(props2);
      return normalize.element({
        ...parts.tableCellTrigger.attrs,
        dir: prop("dir"),
        role: "button",
        id: getCellTriggerId(scope, value.toString()),
        "data-selected": dataAttr(cellState.selected),
        "aria-disabled": ariaAttr(!cellState.selectable),
        "data-disabled": dataAttr(!cellState.selectable),
        "data-focus": dataAttr(cellState.focused),
        "data-in-range": dataAttr(cellState.inRange),
        "data-outside-range": dataAttr(cellState.outsideRange),
        "aria-label": cellState.valueText,
        "data-view": "month",
        "data-value": value,
        tabIndex: cellState.focused ? 0 : -1,
        onClick(event) {
          if (event.defaultPrevented) return;
          if (!cellState.selectable) return;
          send({ type: "CELL.CLICK", cell: "month", value });
        },
        onPointerMove: isRangePicker ? (event) => {
          if (event.pointerType === "touch") return;
          if (!cellState.selectable) return;
          const focus = !scope.isActiveElement(event.currentTarget);
          if (hoveredValue && cellState.value && $14e0f24ef4ac5c92$export$5a8da0c44a3afdf2(cellState.value, hoveredValue)) return;
          send({ type: "CELL.POINTER_MOVE", cell: "month", value: cellState.value, focus });
        } : void 0
      });
    },
    getYearTableCellState,
    getYearTableCellProps(props2) {
      const { value, columns } = props2;
      const cellState = getYearTableCellState(props2);
      return normalize.element({
        ...parts.tableCell.attrs,
        dir: prop("dir"),
        colSpan: columns,
        role: "gridcell",
        "aria-selected": ariaAttr(cellState.selected),
        "data-selected": dataAttr(cellState.selected),
        "aria-disabled": ariaAttr(!cellState.selectable),
        "data-value": value
      });
    },
    getYearTableCellTriggerProps(props2) {
      const { value } = props2;
      const cellState = getYearTableCellState(props2);
      return normalize.element({
        ...parts.tableCellTrigger.attrs,
        dir: prop("dir"),
        role: "button",
        id: getCellTriggerId(scope, value.toString()),
        "data-selected": dataAttr(cellState.selected),
        "data-focus": dataAttr(cellState.focused),
        "data-in-range": dataAttr(cellState.inRange),
        "aria-disabled": ariaAttr(!cellState.selectable),
        "data-disabled": dataAttr(!cellState.selectable),
        "aria-label": cellState.valueText,
        "data-outside-range": dataAttr(cellState.outsideRange),
        "data-value": value,
        "data-view": "year",
        tabIndex: cellState.focused ? 0 : -1,
        onClick(event) {
          if (event.defaultPrevented) return;
          if (!cellState.selectable) return;
          send({ type: "CELL.CLICK", cell: "year", value });
        },
        onPointerMove: isRangePicker ? (event) => {
          if (event.pointerType === "touch") return;
          if (!cellState.selectable) return;
          const focus = !scope.isActiveElement(event.currentTarget);
          if (hoveredValue && cellState.value && $14e0f24ef4ac5c92$export$ea840f5a6dda8147(cellState.value, hoveredValue)) return;
          send({ type: "CELL.POINTER_MOVE", cell: "year", value: cellState.value, focus });
        } : void 0
      });
    },
    getNextTriggerProps(props2 = {}) {
      const { view = "day" } = props2;
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
    getPrevTriggerProps(props2 = {}) {
      const { view = "day" } = props2;
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
        "aria-label": translations.trigger(open),
        "aria-controls": getContentId(scope),
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
    getViewProps(props2 = {}) {
      const { view = "day" } = props2;
      return normalize.element({
        ...parts.view.attrs,
        "data-view": view,
        hidden: context.get("view") !== view
      });
    },
    getViewTriggerProps(props2 = {}) {
      const { view = "day" } = props2;
      return normalize.button({
        ...parts.viewTrigger.attrs,
        "data-view": view,
        dir: prop("dir"),
        id: getViewTriggerId(scope, view),
        type: "button",
        disabled,
        "aria-label": translations.viewTrigger(view),
        onClick(event) {
          if (event.defaultPrevented) return;
          if (!interactive) return;
          send({ type: "VIEW.TOGGLE", src: "viewTrigger" });
        }
      });
    },
    getViewControlProps(props2 = {}) {
      const { view = "day" } = props2;
      return normalize.element({
        ...parts.viewControl.attrs,
        "data-view": view,
        dir: prop("dir")
      });
    },
    getInputProps(props2 = {}) {
      const { index = 0, fixOnBlur = true } = props2;
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
          if (!isValidCharacter(data, separator)) {
            event.preventDefault();
          }
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
          send({ type: "INPUT.CHANGE", value: ensureValidCharacters(value, separator), index });
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
    getPresetTriggerProps(props2) {
      const value = Array.isArray(props2.value) ? props2.value : getDateRangePreset(props2.value, locale, timeZone);
      const valueAsString = value.filter((item) => item != null).map((item) => item.toDate(timeZone).toDateString());
      return normalize.button({
        ...parts.presetTrigger.attrs,
        "aria-label": translations.presetTrigger(valueAsString),
        type: "button",
        onClick(event) {
          if (event.defaultPrevented) return;
          send({ type: "PRESET.CLICK", value });
        }
      });
    }
  };
}
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
  props({ props: props2 }) {
    const locale = props2.locale || "en-US";
    const timeZone = props2.timeZone || "UTC";
    const selectionMode = props2.selectionMode || "single";
    const numOfMonths = props2.numOfMonths || 1;
    const defaultValue = props2.defaultValue ? sortDates(props2.defaultValue).map((date) => constrainValue(date, props2.min, props2.max)) : void 0;
    const value = props2.value ? sortDates(props2.value).map((date) => constrainValue(date, props2.min, props2.max)) : void 0;
    let focusedValue = props2.focusedValue || props2.defaultFocusedValue || value?.[0] || defaultValue?.[0] || getTodayDate(timeZone);
    focusedValue = constrainValue(focusedValue, props2.min, props2.max);
    const minView = "day";
    const maxView = "year";
    const defaultView = clampView(props2.view || minView, minView, maxView);
    return {
      locale,
      numOfMonths,
      timeZone,
      selectionMode,
      defaultView,
      minView,
      maxView,
      outsideDaySelectable: false,
      closeOnSelect: true,
      format(date, { locale: locale2, timeZone: timeZone2 }) {
        const formatter = new $fb18d541ea1ad717$export$ad991b66133851cf(locale2, { timeZone: timeZone2, day: "2-digit", month: "2-digit", year: "numeric" });
        return formatter.format(date.toDate(timeZone2));
      },
      parse(value2, { locale: locale2, timeZone: timeZone2 }) {
        return parseDateString(value2, locale2, timeZone2);
      },
      ...props2,
      focusedValue: typeof props2.focusedValue === "undefined" ? void 0 : focusedValue,
      defaultFocusedValue: focusedValue,
      value,
      defaultValue: defaultValue ?? [],
      positioning: {
        placement: "bottom",
        ...props2.positioning
      }
    };
  },
  initialState({ prop }) {
    const open = prop("open") || prop("defaultOpen") || prop("inline");
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
      actions: ["clearDateValue", "clearFocusedDate", "focusFirstInputElement"]
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
          actions: ["focusFirstSelectedDate", "focusActiveCell"]
        },
        "TRIGGER.CLICK": [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["focusFirstSelectedDate", "focusActiveCell", "invokeOnOpen"]
          }
        ],
        OPEN: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["focusFirstSelectedDate", "focusActiveCell", "invokeOnOpen"]
          }
        ]
      }
    },
    focused: {
      tags: ["closed"],
      on: {
        "CONTROLLED.OPEN": {
          target: "open",
          actions: ["focusFirstSelectedDate", "focusActiveCell"]
        },
        "TRIGGER.CLICK": [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["focusFirstSelectedDate", "focusActiveCell", "invokeOnOpen"]
          }
        ],
        OPEN: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["focusFirstSelectedDate", "focusActiveCell", "invokeOnOpen"]
          }
        ]
      }
    },
    open: {
      tags: ["open"],
      effects: ["trackDismissableElement", "trackPositioning"],
      exit: ["clearHoveredDate", "resetView"],
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
            guard: "isMultiPicker",
            actions: ["setFocusedDate", "toggleSelectedDate"]
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
        "CELL.POINTER_MOVE": {
          guard: and("isRangePicker", "isSelectingEndDate"),
          actions: ["setHoveredDate", "setFocusedDate"]
        },
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
            actions: ["setActiveIndexToStart", "clearDateValue", "setSelectedDate", "setActiveIndexToEnd"]
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
            guard: "isMultiPicker",
            actions: ["toggleSelectedDate"]
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
      shouldRestoreFocus: ({ context }) => !!context.get("restoreFocus"),
      isSelectingEndDate: ({ context }) => context.get("activeIndex") === 1,
      closeOnSelect: ({ prop }) => !!prop("closeOnSelect"),
      isOpenControlled: ({ prop }) => prop("open") != void 0 || !!prop("inline"),
      isInteractOutsideEvent: ({ event }) => event.previousEvent?.type === "INTERACT_OUTSIDE",
      isInputValueEmpty: ({ event }) => event.value.trim() === "",
      shouldFixOnBlur: ({ event }) => !!event.fixOnBlur
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
        values[context.get("activeIndex")] = normalizeValue(params, event.value ?? context.get("focusedValue"));
        context.set("value", adjustStartAndEndDate(values));
      },
      resetSelection(params) {
        const { context, event } = params;
        const value = normalizeValue(params, event.value ?? context.get("focusedValue"));
        context.set("value", [value]);
      },
      toggleSelectedDate(params) {
        const { context, event } = params;
        const currentValue = normalizeValue(params, event.value ?? context.get("focusedValue"));
        const index = context.get("value").findIndex((date) => isDateEqual(date, currentValue));
        if (index === -1) {
          const values = [...context.get("value"), currentValue];
          context.set("value", sortDates(values));
        } else {
          const values = Array.from(context.get("value"));
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
        values[activeIndex] = context.get("focusedValue").copy();
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
        const { prop } = params;
        setFocusedValue(params, getTodayDate(prop("timeZone")));
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
        const nextValue = context.get("focusedValue").set({ month: 1 });
        setFocusedValue(params, nextValue);
      },
      focusLastMonth(params) {
        const { context } = params;
        const nextValue = context.get("focusedValue").set({ month: 12 });
        setFocusedValue(params, nextValue);
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
      focusActiveCell({ scope, context }) {
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
        if (!event.type.startsWith("TABLE.ARROW") || prop("selectionMode") !== "range" || context.get("activeIndex") === 0)
          return;
        context.set("hoveredValue", context.get("focusedValue").copy());
      },
      focusTriggerElement({ scope }) {
        raf(() => {
          getTriggerEl(scope)?.focus({ preventScroll: true });
        });
      },
      focusFirstInputElement({ scope }) {
        raf(() => {
          const [inputEl] = getInputEls(scope);
          inputEl?.focus({ preventScroll: true });
        });
      },
      focusInputElement({ scope }) {
        raf(() => {
          const inputEls = getInputEls(scope);
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
        values[event.index] = date;
        context.set("value", values);
        const valueAsString = getValueAsString(values, prop);
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
function parse(value) {
  if (Array.isArray(value)) {
    return value.map((v) => parse(v));
  }
  if (value instanceof Date) {
    return new $35ea8db9cb2ccb90$export$99faa760c7908e4f(value.getFullYear(), value.getMonth() + 1, value.getDate());
  }
  return $fae977aafc393c5c$export$6b862160d295c8e(value);
}
var props = createProps()([
  "closeOnSelect",
  "dir",
  "disabled",
  "fixedWeeks",
  "focusedValue",
  "format",
  "parse",
  "placeholder",
  "getRootNode",
  "id",
  "ids",
  "inline",
  "invalid",
  "isDateUnavailable",
  "locale",
  "max",
  "min",
  "name",
  "numOfMonths",
  "onFocusChange",
  "onOpenChange",
  "onValueChange",
  "onViewChange",
  "onVisibleRangeChange",
  "open",
  "defaultOpen",
  "positioning",
  "readOnly",
  "required",
  "selectionMode",
  "startOfWeek",
  "timeZone",
  "translations",
  "value",
  "defaultView",
  "defaultValue",
  "view",
  "defaultFocusedValue",
  "outsideDaySelectable",
  "minView",
  "maxView"
]);
var splitProps = createSplitProps(props);
var inputProps = createProps()(["index", "fixOnBlur"]);
var splitInputProps = createSplitProps(inputProps);
var presetTriggerProps = createProps()(["value"]);
var splitPresetTriggerProps = createSplitProps(presetTriggerProps);
var tableProps = createProps()(["columns", "id", "view"]);
var splitTableProps = createSplitProps(tableProps);
var tableCellProps = createProps()(["disabled", "value", "columns"]);
var splitTableCellProps = createSplitProps(tableCellProps);
var viewProps = createProps()(["view"]);
var splitViewProps = createSplitProps(viewProps);

// components/date-picker.ts
var DatePicker = class extends Component {
  _lastView = null;
  _lastDayRangeKey = "";
  _lastMonthYear = null;
  _lastYearDecade = "";
  initMachine(props2) {
    return new VanillaMachine(machine, {
      ...props2
    });
  }
  initApi() {
    return connect(this.machine.service, normalizeProps);
  }
  getDayView = () => this.el.querySelector('[data-part="day-view"]');
  getMonthView = () => this.el.querySelector('[data-part="month-view"]');
  getYearView = () => this.el.querySelector('[data-part="year-view"]');
  renderDayTableHeader = () => {
    const dayView = this.getDayView();
    const thead = dayView?.querySelector("thead");
    if (!thead || !this.api.weekDays) return;
    const tr = this.doc.createElement("tr");
    this.spreadProps(tr, this.api.getTableRowProps({ view: "day" }));
    this.api.weekDays.forEach((day) => {
      const th = this.doc.createElement("th");
      th.scope = "col";
      th.setAttribute("aria-label", day.long);
      th.textContent = day.narrow;
      tr.appendChild(th);
    });
    thead.innerHTML = "";
    thead.appendChild(tr);
  };
  renderDayTableBody = () => {
    const dayView = this.getDayView();
    const tbody = dayView?.querySelector("tbody");
    if (!tbody) return;
    this.spreadProps(tbody, this.api.getTableBodyProps({ view: "day" }));
    if (!this.api.weeks) return;
    tbody.innerHTML = "";
    this.api.weeks.forEach((week) => {
      const tr = this.doc.createElement("tr");
      this.spreadProps(tr, this.api.getTableRowProps({ view: "day" }));
      week.forEach((value) => {
        const td = this.doc.createElement("td");
        this.spreadProps(td, this.api.getDayTableCellProps({ value }));
        const trigger = this.doc.createElement("div");
        this.spreadProps(
          trigger,
          this.api.getDayTableCellTriggerProps({ value })
        );
        trigger.textContent = String(value.day);
        td.appendChild(trigger);
        tr.appendChild(td);
      });
      tbody.appendChild(tr);
    });
  };
  renderMonthTableBody = () => {
    const monthView = this.getMonthView();
    const tbody = monthView?.querySelector("tbody");
    if (!tbody) return;
    this.spreadProps(tbody, this.api.getTableBodyProps({ view: "month" }));
    const monthsGrid = this.api.getMonthsGrid({ columns: 4, format: "short" });
    tbody.innerHTML = "";
    monthsGrid.forEach((months) => {
      const tr = this.doc.createElement("tr");
      this.spreadProps(tr, this.api.getTableRowProps());
      months.forEach((month) => {
        const td = this.doc.createElement("td");
        this.spreadProps(
          td,
          this.api.getMonthTableCellProps({ ...month, columns: 4 })
        );
        const trigger = this.doc.createElement("div");
        this.spreadProps(
          trigger,
          this.api.getMonthTableCellTriggerProps({ ...month, columns: 4 })
        );
        trigger.textContent = month.label;
        td.appendChild(trigger);
        tr.appendChild(td);
      });
      tbody.appendChild(tr);
    });
  };
  renderYearTableBody = () => {
    const yearView = this.getYearView();
    const tbody = yearView?.querySelector("tbody");
    if (!tbody) return;
    this.spreadProps(tbody, this.api.getTableBodyProps());
    const yearsGrid = this.api.getYearsGrid({ columns: 4 });
    tbody.innerHTML = "";
    yearsGrid.forEach((years) => {
      const tr = this.doc.createElement("tr");
      this.spreadProps(tr, this.api.getTableRowProps({ view: "year" }));
      years.forEach((year) => {
        const td = this.doc.createElement("td");
        this.spreadProps(
          td,
          this.api.getYearTableCellProps({ ...year, columns: 4 })
        );
        const trigger = this.doc.createElement("div");
        this.spreadProps(
          trigger,
          this.api.getYearTableCellTriggerProps({ ...year, columns: 4 })
        );
        trigger.textContent = year.label;
        td.appendChild(trigger);
        tr.appendChild(td);
      });
      tbody.appendChild(tr);
    });
  };
  render() {
    const root = this.el.querySelector(
      '[data-scope="date-picker"][data-part="root"]'
    );
    if (root) this.spreadProps(root, this.api.getRootProps());
    const label = this.el.querySelector(
      '[data-scope="date-picker"][data-part="label"]'
    );
    if (label) this.spreadProps(label, this.api.getLabelProps());
    const control = this.el.querySelector(
      '[data-scope="date-picker"][data-part="control"]'
    );
    if (control) this.spreadProps(control, this.api.getControlProps());
    const input = this.el.querySelector(
      '[data-scope="date-picker"][data-part="input"]'
    );
    if (input) {
      const inputProps2 = { ...this.api.getInputProps() };
      const inputAriaLabel = this.el.dataset.inputAriaLabel;
      if (inputAriaLabel) {
        inputProps2["aria-label"] = inputAriaLabel;
      }
      this.spreadProps(input, inputProps2);
    }
    const trigger = this.el.querySelector(
      '[data-scope="date-picker"][data-part="trigger"]'
    );
    if (trigger) {
      const triggerProps = { ...this.api.getTriggerProps() };
      const ariaLabel = this.el.dataset.triggerAriaLabel;
      if (ariaLabel) {
        triggerProps["aria-label"] = ariaLabel;
      }
      this.spreadProps(trigger, triggerProps);
    }
    const positioner = this.el.querySelector(
      '[data-scope="date-picker"][data-part="positioner"]'
    );
    if (positioner) this.spreadProps(positioner, this.api.getPositionerProps());
    const content = this.el.querySelector(
      '[data-scope="date-picker"][data-part="content"]'
    );
    if (content) this.spreadProps(content, this.api.getContentProps());
    if (this.api.open) {
      const dayView = this.getDayView();
      const monthView = this.getMonthView();
      const yearView = this.getYearView();
      if (dayView) dayView.hidden = this.api.view !== "day";
      if (monthView) monthView.hidden = this.api.view !== "month";
      if (yearView) yearView.hidden = this.api.view !== "year";
      if (this.api.view === "day" && dayView) {
        const viewControl = dayView.querySelector(
          '[data-part="view-control"]'
        );
        if (viewControl)
          this.spreadProps(
            viewControl,
            this.api.getViewControlProps({ view: "year" })
          );
        const prevTrigger = dayView.querySelector(
          '[data-part="prev-trigger"]'
        );
        if (prevTrigger)
          this.spreadProps(prevTrigger, this.api.getPrevTriggerProps());
        const viewTrigger = dayView.querySelector(
          '[data-part="view-trigger"]'
        );
        if (viewTrigger) {
          this.spreadProps(viewTrigger, this.api.getViewTriggerProps());
          viewTrigger.textContent = this.api.visibleRangeText.start;
        }
        const nextTrigger = dayView.querySelector(
          '[data-part="next-trigger"]'
        );
        if (nextTrigger)
          this.spreadProps(nextTrigger, this.api.getNextTriggerProps());
        const table = dayView.querySelector("table");
        if (table)
          this.spreadProps(table, this.api.getTableProps({ view: "day" }));
        const thead = dayView.querySelector("thead");
        if (thead)
          this.spreadProps(
            thead,
            this.api.getTableHeaderProps({ view: "day" })
          );
        this.renderDayTableHeader();
        this.renderDayTableBody();
      } else if (this.api.view === "month" && monthView) {
        const viewControl = monthView.querySelector(
          '[data-part="view-control"]'
        );
        if (viewControl)
          this.spreadProps(
            viewControl,
            this.api.getViewControlProps({ view: "month" })
          );
        const prevTrigger = monthView.querySelector(
          '[data-part="prev-trigger"]'
        );
        if (prevTrigger)
          this.spreadProps(
            prevTrigger,
            this.api.getPrevTriggerProps({ view: "month" })
          );
        const viewTrigger = monthView.querySelector(
          '[data-part="view-trigger"]'
        );
        if (viewTrigger) {
          this.spreadProps(
            viewTrigger,
            this.api.getViewTriggerProps({ view: "month" })
          );
          viewTrigger.textContent = String(this.api.visibleRange.start.year);
        }
        const nextTrigger = monthView.querySelector(
          '[data-part="next-trigger"]'
        );
        if (nextTrigger)
          this.spreadProps(
            nextTrigger,
            this.api.getNextTriggerProps({ view: "month" })
          );
        const table = monthView.querySelector("table");
        if (table)
          this.spreadProps(
            table,
            this.api.getTableProps({ view: "month", columns: 4 })
          );
        this.renderMonthTableBody();
      } else if (this.api.view === "year" && yearView) {
        const viewControl = yearView.querySelector(
          '[data-part="view-control"]'
        );
        if (viewControl)
          this.spreadProps(
            viewControl,
            this.api.getViewControlProps({ view: "year" })
          );
        const prevTrigger = yearView.querySelector(
          '[data-part="prev-trigger"]'
        );
        if (prevTrigger)
          this.spreadProps(
            prevTrigger,
            this.api.getPrevTriggerProps({ view: "year" })
          );
        const decadeText = yearView.querySelector(
          '[data-part="decade"]'
        );
        if (decadeText) {
          const decade = this.api.getDecade();
          decadeText.textContent = `${decade.start} - ${decade.end}`;
        }
        const nextTrigger = yearView.querySelector(
          '[data-part="next-trigger"]'
        );
        if (nextTrigger)
          this.spreadProps(
            nextTrigger,
            this.api.getNextTriggerProps({ view: "year" })
          );
        const table = yearView.querySelector("table");
        if (table)
          this.spreadProps(
            table,
            this.api.getTableProps({ view: "year", columns: 4 })
          );
        this.renderYearTableBody();
      }
    }
  }
};

// hooks/date-picker.ts
function toISOString(d) {
  const pad = (n) => String(n).padStart(2, "0");
  return `${d.year}-${pad(d.month)}-${pad(d.day)}`;
}
var DatePickerHook = {
  mounted() {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const liveSocket = this.liveSocket;
    const min = getString(el, "min");
    const max = getString(el, "max");
    const positioningJson = getString(el, "positioning");
    const parseList = (v) => v ? v.map((x) => parse(x)) : void 0;
    const parseOne = (v) => v ? parse(v) : void 0;
    const datePickerInstance = new DatePicker(el, {
      id: el.id,
      ...getBoolean(el, "controlled") ? { value: parseList(getStringList(el, "value")) } : { defaultValue: parseList(getStringList(el, "defaultValue")) },
      defaultFocusedValue: parseOne(getString(el, "focusedValue")),
      defaultView: getString(el, "defaultView", ["day", "month", "year"]),
      dir: getString(el, "dir", ["ltr", "rtl"]),
      locale: getString(el, "locale"),
      timeZone: getString(el, "timeZone"),
      disabled: getBoolean(el, "disabled"),
      readOnly: getBoolean(el, "readOnly"),
      required: getBoolean(el, "required"),
      invalid: getBoolean(el, "invalid"),
      outsideDaySelectable: getBoolean(el, "outsideDaySelectable"),
      closeOnSelect: getBoolean(el, "closeOnSelect"),
      min: min ? parse(min) : void 0,
      max: max ? parse(max) : void 0,
      numOfMonths: getNumber(el, "numOfMonths"),
      startOfWeek: getNumber(el, "startOfWeek"),
      fixedWeeks: getBoolean(el, "fixedWeeks"),
      selectionMode: getString(el, "selectionMode", ["single", "multiple", "range"]),
      placeholder: getString(el, "placeholder"),
      minView: getString(el, "minView", ["day", "month", "year"]),
      maxView: getString(el, "maxView", ["day", "month", "year"]),
      inline: getBoolean(el, "inline"),
      positioning: positioningJson ? JSON.parse(positioningJson) : void 0,
      onValueChange: (details) => {
        const isoStr = details.value?.length ? details.value.map((d) => toISOString(d)).join(",") : "";
        const hiddenInput = el.querySelector(
          `#${el.id}-value`
        );
        if (hiddenInput && hiddenInput.value !== isoStr) {
          hiddenInput.value = isoStr;
          hiddenInput.dispatchEvent(new Event("input", { bubbles: true }));
          hiddenInput.dispatchEvent(new Event("change", { bubbles: true }));
        }
        const eventName = getString(el, "onValueChange");
        if (eventName && liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            id: el.id,
            value: isoStr || null
          });
        }
      },
      onFocusChange: (details) => {
        const eventName = getString(el, "onFocusChange");
        if (eventName && liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            id: el.id,
            focused: details.focused ?? false
          });
        }
      },
      onViewChange: (details) => {
        const eventName = getString(el, "onViewChange");
        if (eventName && liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            id: el.id,
            view: details.view
          });
        }
      },
      onVisibleRangeChange: (details) => {
        const eventName = getString(el, "onVisibleRangeChange");
        if (eventName && liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            id: el.id,
            start: details.start,
            end: details.end
          });
        }
      },
      onOpenChange: (details) => {
        const eventName = getString(el, "onOpenChange");
        if (eventName && liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            id: el.id,
            open: details.open
          });
        }
      }
    });
    datePickerInstance.init();
    this.datePicker = datePickerInstance;
    const inputWrapper = el.querySelector(
      '[data-scope="date-picker"][data-part="input-wrapper"]'
    );
    if (inputWrapper) inputWrapper.removeAttribute("data-loading");
    this.handlers = [];
    this.handlers.push(
      this.handleEvent("date_picker_set_value", (payload) => {
        const targetId = payload.date_picker_id;
        if (targetId && targetId !== el.id) return;
        datePickerInstance.api.setValue([parse(payload.value)]);
      })
    );
    this.onSetValue = (event) => {
      const value = event.detail?.value;
      if (typeof value === "string") {
        datePickerInstance.api.setValue([parse(value)]);
      }
    };
    el.addEventListener("phx:date-picker:set-value", this.onSetValue);
  },
  updated() {
    const el = this.el;
    const inputWrapper = el.querySelector(
      '[data-scope="date-picker"][data-part="input-wrapper"]'
    );
    if (inputWrapper) inputWrapper.removeAttribute("data-loading");
    const parseList = (v) => v ? v.map((x) => parse(x)) : void 0;
    const min = getString(el, "min");
    const max = getString(el, "max");
    const positioningJson = getString(el, "positioning");
    const isControlled = getBoolean(el, "controlled");
    const focusedStr = getString(el, "focusedValue");
    this.datePicker?.updateProps({
      ...getBoolean(el, "controlled") ? { value: parseList(getStringList(el, "value")) } : { defaultValue: parseList(getStringList(el, "defaultValue")) },
      defaultFocusedValue: focusedStr ? parse(focusedStr) : void 0,
      defaultView: getString(el, "defaultView", ["day", "month", "year"]),
      dir: getString(this.el, "dir", ["ltr", "rtl"]),
      locale: getString(this.el, "locale"),
      timeZone: getString(this.el, "timeZone"),
      disabled: getBoolean(this.el, "disabled"),
      readOnly: getBoolean(this.el, "readOnly"),
      required: getBoolean(this.el, "required"),
      invalid: getBoolean(this.el, "invalid"),
      outsideDaySelectable: getBoolean(this.el, "outsideDaySelectable"),
      closeOnSelect: getBoolean(this.el, "closeOnSelect"),
      min: min ? parse(min) : void 0,
      max: max ? parse(max) : void 0,
      numOfMonths: getNumber(this.el, "numOfMonths"),
      startOfWeek: getNumber(this.el, "startOfWeek"),
      fixedWeeks: getBoolean(this.el, "fixedWeeks"),
      selectionMode: getString(this.el, "selectionMode", ["single", "multiple", "range"]),
      placeholder: getString(this.el, "placeholder"),
      minView: getString(this.el, "minView", ["day", "month", "year"]),
      maxView: getString(this.el, "maxView", ["day", "month", "year"]),
      inline: getBoolean(this.el, "inline"),
      positioning: positioningJson ? JSON.parse(positioningJson) : void 0
    });
    if (isControlled && this.datePicker) {
      const serverValues = getStringList(el, "value");
      const serverIso = serverValues?.join(",") ?? "";
      const zagValue = this.datePicker.api.value;
      const zagIso = zagValue?.length ? zagValue.map((d) => toISOString(d)).join(",") : "";
      if (serverIso !== zagIso) {
        const parsed = serverValues?.length ? serverValues.map((x) => parse(x)) : [];
        this.datePicker.api.setValue(parsed);
      }
    }
  },
  destroyed() {
    if (this.onSetValue) {
      this.el.removeEventListener("phx:date-picker:set-value", this.onSetValue);
    }
    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }
    this.datePicker?.destroy();
  }
};
export {
  DatePickerHook as DatePicker
};
