// ../node_modules/.pnpm/@internationalized+date@3.12.1/node_modules/@internationalized/date/dist/private/utils.mjs
function $09ec6a572d60460f$export$842a2cf37af977e1(amount, numerator) {
  return amount - numerator * Math.floor(amount / numerator);
}

// ../node_modules/.pnpm/@internationalized+date@3.12.1/node_modules/@internationalized/date/dist/private/calendars/GregorianCalendar.mjs
var $93635573935797de$var$EPOCH = 1721426;
function $93635573935797de$export$f297eb839006d339(era, year, month, day) {
  year = $93635573935797de$export$c36e0ecb2d4fa69d(era, year);
  let y1 = year - 1;
  let monthOffset = -2;
  if (month <= 2) monthOffset = 0;
  else if ($93635573935797de$export$553d7fa8e3805fc0(year)) monthOffset = -1;
  return $93635573935797de$var$EPOCH - 1 + 365 * y1 + Math.floor(y1 / 4) - Math.floor(y1 / 100) + Math.floor(y1 / 400) + Math.floor((367 * month - 362) / 12 + monthOffset + day);
}
function $93635573935797de$export$553d7fa8e3805fc0(year) {
  return year % 4 === 0 && (year % 100 !== 0 || year % 400 === 0);
}
function $93635573935797de$export$c36e0ecb2d4fa69d(era, year) {
  return era === "BC" ? 1 - year : year;
}
function $93635573935797de$export$4475b7e617eb123c(year) {
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
var $93635573935797de$var$daysInMonth = {
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
var $93635573935797de$export$80ee6245ec4f29ec = class {
  fromJulianDay(jd) {
    let jd0 = jd;
    let depoch = jd0 - $93635573935797de$var$EPOCH;
    let quadricent = Math.floor(depoch / 146097);
    let dqc = (0, $09ec6a572d60460f$export$842a2cf37af977e1)(depoch, 146097);
    let cent = Math.floor(dqc / 36524);
    let dcent = (0, $09ec6a572d60460f$export$842a2cf37af977e1)(dqc, 36524);
    let quad = Math.floor(dcent / 1461);
    let dquad = (0, $09ec6a572d60460f$export$842a2cf37af977e1)(dcent, 1461);
    let yindex = Math.floor(dquad / 365);
    let extendedYear = quadricent * 400 + cent * 100 + quad * 4 + yindex + (cent !== 4 && yindex !== 4 ? 1 : 0);
    let [era, year] = $93635573935797de$export$4475b7e617eb123c(extendedYear);
    let yearDay = jd0 - $93635573935797de$export$f297eb839006d339(era, year, 1, 1);
    let leapAdj = 2;
    if (jd0 < $93635573935797de$export$f297eb839006d339(era, year, 3, 1)) leapAdj = 0;
    else if ($93635573935797de$export$553d7fa8e3805fc0(year)) leapAdj = 1;
    let month = Math.floor(((yearDay + leapAdj) * 12 + 373) / 367);
    let day = jd0 - $93635573935797de$export$f297eb839006d339(era, year, month, 1) + 1;
    return new (0, $2aaf608024c21ca1$export$99faa760c7908e4f)(era, year, month, day);
  }
  toJulianDay(date) {
    return $93635573935797de$export$f297eb839006d339(date.era, date.year, date.month, date.day);
  }
  getDaysInMonth(date) {
    return $93635573935797de$var$daysInMonth[$93635573935797de$export$553d7fa8e3805fc0(date.year) ? "leapyear" : "standard"][date.month - 1];
  }
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  getMonthsInYear(date) {
    return 12;
  }
  getDaysInYear(date) {
    return $93635573935797de$export$553d7fa8e3805fc0(date.year) ? 366 : 365;
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

// ../node_modules/.pnpm/@internationalized+date@3.12.1/node_modules/@internationalized/date/dist/private/weekStartData.mjs
var $d2ca8165c9aa885a$export$7a5acbd77d414bd9 = {
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

// ../node_modules/.pnpm/@internationalized+date@3.12.1/node_modules/@internationalized/date/dist/private/queries.mjs
function $ad063034c8620db8$export$ea39ec197993aef0(a, b) {
  b = (0, $d07e34cce18680fd$export$b4a036af3fc0b032)(b, a.calendar);
  return a.era === b.era && a.year === b.year && a.month === b.month && a.day === b.day;
}
function $ad063034c8620db8$export$a18c89cbd24170ff(a, b) {
  b = (0, $d07e34cce18680fd$export$b4a036af3fc0b032)(b, a.calendar);
  a = $ad063034c8620db8$export$a5a3b454ada2268e(a);
  b = $ad063034c8620db8$export$a5a3b454ada2268e(b);
  return a.era === b.era && a.year === b.year && a.month === b.month;
}
function $ad063034c8620db8$export$5841f9eb9773f25f(a, b) {
  b = (0, $d07e34cce18680fd$export$b4a036af3fc0b032)(b, a.calendar);
  a = $ad063034c8620db8$export$f91e89d3d0406102(a);
  b = $ad063034c8620db8$export$f91e89d3d0406102(b);
  return a.era === b.era && a.year === b.year;
}
function $ad063034c8620db8$export$91b62ebf2ba703ee(a, b) {
  return $ad063034c8620db8$export$dbc69fd56b53d5e(a.calendar, b.calendar) && $ad063034c8620db8$export$ea39ec197993aef0(a, b);
}
function $ad063034c8620db8$export$5a8da0c44a3afdf2(a, b) {
  return $ad063034c8620db8$export$dbc69fd56b53d5e(a.calendar, b.calendar) && $ad063034c8620db8$export$a18c89cbd24170ff(a, b);
}
function $ad063034c8620db8$export$ea840f5a6dda8147(a, b) {
  return $ad063034c8620db8$export$dbc69fd56b53d5e(a.calendar, b.calendar) && $ad063034c8620db8$export$5841f9eb9773f25f(a, b);
}
function $ad063034c8620db8$export$dbc69fd56b53d5e(a, b) {
  return a.isEqual?.(b) ?? b.isEqual?.(a) ?? a.identifier === b.identifier;
}
function $ad063034c8620db8$export$629b0a497aa65267(date, timeZone) {
  return $ad063034c8620db8$export$ea39ec197993aef0(date, $ad063034c8620db8$export$d0bdf45af03a6ea3(timeZone));
}
var $ad063034c8620db8$var$DAY_MAP = {
  sun: 0,
  mon: 1,
  tue: 2,
  wed: 3,
  thu: 4,
  fri: 5,
  sat: 6
};
function $ad063034c8620db8$export$2061056d06d7cdf7(date, locale, firstDayOfWeek) {
  let julian = date.calendar.toJulianDay(date);
  let weekStart = firstDayOfWeek ? $ad063034c8620db8$var$DAY_MAP[firstDayOfWeek] : $ad063034c8620db8$var$getWeekStart(locale);
  let dayOfWeek = Math.ceil(julian + 1 - weekStart) % 7;
  if (dayOfWeek < 0) dayOfWeek += 7;
  return dayOfWeek;
}
function $ad063034c8620db8$export$461939dd4422153(timeZone) {
  return (0, $d07e34cce18680fd$export$1b96692a1ba042ac)(Date.now(), timeZone);
}
function $ad063034c8620db8$export$d0bdf45af03a6ea3(timeZone) {
  return (0, $d07e34cce18680fd$export$93522d1a439f3617)($ad063034c8620db8$export$461939dd4422153(timeZone));
}
function $ad063034c8620db8$export$68781ddf31c0090f(a, b) {
  return a.calendar.toJulianDay(a) - b.calendar.toJulianDay(b);
}
function $ad063034c8620db8$export$c19a80a9721b80f6(a, b) {
  return $ad063034c8620db8$var$timeToMs(a) - $ad063034c8620db8$var$timeToMs(b);
}
function $ad063034c8620db8$var$timeToMs(a) {
  return a.hour * 36e5 + a.minute * 6e4 + a.second * 1e3 + a.millisecond;
}
var $ad063034c8620db8$var$localTimeZone = null;
var $ad063034c8620db8$var$localTimeZoneOverride = false;
function $ad063034c8620db8$export$aa8b41735afcabd2() {
  if ($ad063034c8620db8$var$localTimeZone == null) $ad063034c8620db8$var$localTimeZone = new Intl.DateTimeFormat().resolvedOptions().timeZone;
  return $ad063034c8620db8$var$localTimeZone;
}
function $ad063034c8620db8$export$6ab69b273755230b() {
  return $ad063034c8620db8$var$localTimeZoneOverride;
}
function $ad063034c8620db8$export$a5a3b454ada2268e(date) {
  return date.subtract({
    days: date.day - 1
  });
}
function $ad063034c8620db8$export$a2258d9c4118825c(date) {
  return date.add({
    days: date.calendar.getDaysInMonth(date) - date.day
  });
}
function $ad063034c8620db8$export$f91e89d3d0406102(date) {
  return $ad063034c8620db8$export$a5a3b454ada2268e(date.subtract({
    months: date.month - 1
  }));
}
function $ad063034c8620db8$export$8b7aa55c66d5569e(date) {
  return $ad063034c8620db8$export$a2258d9c4118825c(date.add({
    months: date.calendar.getMonthsInYear(date) - date.month
  }));
}
function $ad063034c8620db8$export$42c81a444fbfb5d4(date, locale, firstDayOfWeek) {
  let dayOfWeek = $ad063034c8620db8$export$2061056d06d7cdf7(date, locale, firstDayOfWeek);
  return date.subtract({
    days: dayOfWeek
  });
}
function $ad063034c8620db8$export$ef8b6d9133084f4e(date, locale, firstDayOfWeek) {
  return $ad063034c8620db8$export$42c81a444fbfb5d4(date, locale, firstDayOfWeek).add({
    days: 6
  });
}
var $ad063034c8620db8$var$cachedRegions = /* @__PURE__ */ new Map();
var $ad063034c8620db8$var$cachedWeekInfo = /* @__PURE__ */ new Map();
function $ad063034c8620db8$var$getRegion(locale) {
  if (Intl.Locale) {
    let region = $ad063034c8620db8$var$cachedRegions.get(locale);
    if (!region) {
      region = new Intl.Locale(locale).maximize().region;
      if (region) $ad063034c8620db8$var$cachedRegions.set(locale, region);
    }
    return region;
  }
  let part = locale.split("-")[1];
  return part === "u" ? void 0 : part;
}
function $ad063034c8620db8$var$getWeekStart(locale) {
  let weekInfo = $ad063034c8620db8$var$cachedWeekInfo.get(locale);
  if (!weekInfo) {
    if (Intl.Locale) {
      let localeInst = new Intl.Locale(locale);
      if ("getWeekInfo" in localeInst) {
        weekInfo = localeInst.getWeekInfo();
        if (weekInfo) {
          $ad063034c8620db8$var$cachedWeekInfo.set(locale, weekInfo);
          return weekInfo.firstDay;
        }
      }
    }
    let region = $ad063034c8620db8$var$getRegion(locale);
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
      firstDay: region ? (0, $d2ca8165c9aa885a$export$7a5acbd77d414bd9)[region] || 0 : 0
    };
    $ad063034c8620db8$var$cachedWeekInfo.set(locale, weekInfo);
  }
  return weekInfo.firstDay;
}
function $ad063034c8620db8$export$ccc1b2479e7dd654(date, locale, firstDayOfWeek) {
  let days = date.calendar.getDaysInMonth(date);
  return Math.ceil(($ad063034c8620db8$export$2061056d06d7cdf7($ad063034c8620db8$export$a5a3b454ada2268e(date), locale, firstDayOfWeek) + days) / 7);
}
function $ad063034c8620db8$export$5c333a116e949cdd(a, b) {
  if (a && b) return a.compare(b) <= 0 ? a : b;
  return a || b;
}
function $ad063034c8620db8$export$a75f2bff57811055(a, b) {
  if (a && b) return a.compare(b) >= 0 ? a : b;
  return a || b;
}
var $ad063034c8620db8$var$WEEKEND_DATA = {
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
function $ad063034c8620db8$export$618d60ea299da42(date, locale) {
  let julian = date.calendar.toJulianDay(date);
  let dayOfWeek = Math.ceil(julian + 1) % 7;
  if (dayOfWeek < 0) dayOfWeek += 7;
  let region = $ad063034c8620db8$var$getRegion(locale);
  let [start, end] = $ad063034c8620db8$var$WEEKEND_DATA[region] || [
    6,
    0
  ];
  return dayOfWeek === start || dayOfWeek === end;
}

// ../node_modules/.pnpm/@internationalized+date@3.12.1/node_modules/@internationalized/date/dist/private/conversion.mjs
function $d07e34cce18680fd$export$bd4fb2bc8bb06fb(date) {
  date = $d07e34cce18680fd$export$b4a036af3fc0b032(date, new (0, $93635573935797de$export$80ee6245ec4f29ec)());
  let year = (0, $93635573935797de$export$c36e0ecb2d4fa69d)(date.era, date.year);
  return $d07e34cce18680fd$var$epochFromParts(year, date.month, date.day, date.hour, date.minute, date.second, date.millisecond);
}
function $d07e34cce18680fd$var$epochFromParts(year, month, day, hour, minute, second, millisecond) {
  let date = /* @__PURE__ */ new Date();
  date.setUTCHours(hour, minute, second, millisecond);
  date.setUTCFullYear(year, month - 1, day);
  return date.getTime();
}
function $d07e34cce18680fd$export$59c99f3515d3493f(ms, timeZone) {
  if (timeZone === "UTC") return 0;
  if (ms > 0 && timeZone === (0, $ad063034c8620db8$export$aa8b41735afcabd2)() && !(0, $ad063034c8620db8$export$6ab69b273755230b)()) return new Date(ms).getTimezoneOffset() * -6e4;
  let { year, month, day, hour, minute, second } = $d07e34cce18680fd$var$getTimeZoneParts(ms, timeZone);
  let utc = $d07e34cce18680fd$var$epochFromParts(year, month, day, hour, minute, second, 0);
  return utc - Math.floor(ms / 1e3) * 1e3;
}
var $d07e34cce18680fd$var$formattersByTimeZone = /* @__PURE__ */ new Map();
function $d07e34cce18680fd$var$getTimeZoneParts(ms, timeZone) {
  let formatter = $d07e34cce18680fd$var$formattersByTimeZone.get(timeZone);
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
    $d07e34cce18680fd$var$formattersByTimeZone.set(timeZone, formatter);
  }
  let parts = formatter.formatToParts(new Date(ms));
  let namedParts = {};
  for (let part of parts) if (part.type !== "literal") namedParts[part.type] = part.value;
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
var $d07e34cce18680fd$var$DAYMILLIS = 864e5;
function $d07e34cce18680fd$var$getValidWallTimes(date, timeZone, earlier, later) {
  let found = earlier === later ? [
    earlier
  ] : [
    earlier,
    later
  ];
  return found.filter((absolute) => $d07e34cce18680fd$var$isValidWallTime(date, timeZone, absolute));
}
function $d07e34cce18680fd$var$isValidWallTime(date, timeZone, absolute) {
  let parts = $d07e34cce18680fd$var$getTimeZoneParts(absolute, timeZone);
  return date.year === parts.year && date.month === parts.month && date.day === parts.day && date.hour === parts.hour && date.minute === parts.minute && date.second === parts.second;
}
function $d07e34cce18680fd$export$5107c82f94518f5c(date, timeZone, disambiguation = "compatible") {
  let dateTime = $d07e34cce18680fd$export$b21e0b124e224484(date);
  if (timeZone === "UTC") return $d07e34cce18680fd$export$bd4fb2bc8bb06fb(dateTime);
  if (timeZone === (0, $ad063034c8620db8$export$aa8b41735afcabd2)() && disambiguation === "compatible" && !(0, $ad063034c8620db8$export$6ab69b273755230b)()) {
    dateTime = $d07e34cce18680fd$export$b4a036af3fc0b032(dateTime, new (0, $93635573935797de$export$80ee6245ec4f29ec)());
    let date2 = /* @__PURE__ */ new Date();
    let year = (0, $93635573935797de$export$c36e0ecb2d4fa69d)(dateTime.era, dateTime.year);
    date2.setFullYear(year, dateTime.month - 1, dateTime.day);
    date2.setHours(dateTime.hour, dateTime.minute, dateTime.second, dateTime.millisecond);
    return date2.getTime();
  }
  let ms = $d07e34cce18680fd$export$bd4fb2bc8bb06fb(dateTime);
  let offsetBefore = $d07e34cce18680fd$export$59c99f3515d3493f(ms - $d07e34cce18680fd$var$DAYMILLIS, timeZone);
  let offsetAfter = $d07e34cce18680fd$export$59c99f3515d3493f(ms + $d07e34cce18680fd$var$DAYMILLIS, timeZone);
  let valid = $d07e34cce18680fd$var$getValidWallTimes(dateTime, timeZone, ms - offsetBefore, ms - offsetAfter);
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
function $d07e34cce18680fd$export$e67a095c620b86fe(dateTime, timeZone, disambiguation = "compatible") {
  return new Date($d07e34cce18680fd$export$5107c82f94518f5c(dateTime, timeZone, disambiguation));
}
function $d07e34cce18680fd$export$1b96692a1ba042ac(ms, timeZone) {
  let offset = $d07e34cce18680fd$export$59c99f3515d3493f(ms, timeZone);
  let date = new Date(ms + offset);
  let year = date.getUTCFullYear();
  let month = date.getUTCMonth() + 1;
  let day = date.getUTCDate();
  let hour = date.getUTCHours();
  let minute = date.getUTCMinutes();
  let second = date.getUTCSeconds();
  let millisecond = date.getUTCMilliseconds();
  return new (0, $2aaf608024c21ca1$export$d3b7288e7994edea)(year < 1 ? "BC" : "AD", year < 1 ? -year + 1 : year, month, day, timeZone, offset, hour, minute, second, millisecond);
}
function $d07e34cce18680fd$export$93522d1a439f3617(dateTime) {
  return new (0, $2aaf608024c21ca1$export$99faa760c7908e4f)(dateTime.calendar, dateTime.era, dateTime.year, dateTime.month, dateTime.day);
}
function $d07e34cce18680fd$export$b21e0b124e224484(date, time) {
  let hour = 0, minute = 0, second = 0, millisecond = 0;
  if ("timeZone" in date) ({ hour, minute, second, millisecond } = date);
  else if ("hour" in date && !time) return date;
  if (time) ({ hour, minute, second, millisecond } = time);
  return new (0, $2aaf608024c21ca1$export$ca871e8dbb80966f)(date.calendar, date.era, date.year, date.month, date.day, hour, minute, second, millisecond);
}
function $d07e34cce18680fd$export$b4a036af3fc0b032(date, calendar) {
  if ((0, $ad063034c8620db8$export$dbc69fd56b53d5e)(date.calendar, calendar)) return date;
  let calendarDate = calendar.fromJulianDay(date.calendar.toJulianDay(date));
  let copy = date.copy();
  copy.calendar = calendar;
  copy.era = calendarDate.era;
  copy.year = calendarDate.year;
  copy.month = calendarDate.month;
  copy.day = calendarDate.day;
  (0, $435a2ceaa8778ed8$export$c4e2ecac49351ef2)(copy);
  return copy;
}
function $d07e34cce18680fd$export$84c95a83c799e074(date, timeZone, disambiguation) {
  if (date instanceof (0, $2aaf608024c21ca1$export$d3b7288e7994edea)) {
    if (date.timeZone === timeZone) return date;
    return $d07e34cce18680fd$export$538b00033cc11c75(date, timeZone);
  }
  let ms = $d07e34cce18680fd$export$5107c82f94518f5c(date, timeZone, disambiguation);
  return $d07e34cce18680fd$export$1b96692a1ba042ac(ms, timeZone);
}
function $d07e34cce18680fd$export$83aac07b4c37b25(date) {
  let ms = $d07e34cce18680fd$export$bd4fb2bc8bb06fb(date) - date.offset;
  return new Date(ms);
}
function $d07e34cce18680fd$export$538b00033cc11c75(date, timeZone) {
  let ms = $d07e34cce18680fd$export$bd4fb2bc8bb06fb(date) - date.offset;
  return $d07e34cce18680fd$export$b4a036af3fc0b032($d07e34cce18680fd$export$1b96692a1ba042ac(ms, timeZone), date.calendar);
}

// ../node_modules/.pnpm/@internationalized+date@3.12.1/node_modules/@internationalized/date/dist/private/manipulation.mjs
var $435a2ceaa8778ed8$var$ONE_HOUR = 36e5;
function $435a2ceaa8778ed8$export$e16d8520af44a096(date, duration) {
  let mutableDate = date.copy();
  let days = "hour" in mutableDate ? $435a2ceaa8778ed8$var$addTimeFields(mutableDate, duration) : 0;
  $435a2ceaa8778ed8$var$addYears(mutableDate, duration.years || 0);
  if (mutableDate.calendar.balanceYearMonth) mutableDate.calendar.balanceYearMonth(mutableDate, date);
  mutableDate.month += duration.months || 0;
  $435a2ceaa8778ed8$var$balanceYearMonth(mutableDate);
  $435a2ceaa8778ed8$var$constrainMonthDay(mutableDate);
  mutableDate.day += (duration.weeks || 0) * 7;
  mutableDate.day += duration.days || 0;
  mutableDate.day += days;
  $435a2ceaa8778ed8$var$balanceDay(mutableDate);
  if (mutableDate.calendar.balanceDate) mutableDate.calendar.balanceDate(mutableDate);
  if (mutableDate.year < 1) {
    mutableDate.year = 1;
    mutableDate.month = 1;
    mutableDate.day = 1;
  }
  let maxYear = mutableDate.calendar.getYearsInEra(mutableDate);
  if (mutableDate.year > maxYear) {
    let isInverseEra = mutableDate.calendar.isInverseEra?.(mutableDate);
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
function $435a2ceaa8778ed8$var$addYears(date, years) {
  if (date.calendar.isInverseEra?.(date)) years = -years;
  date.year += years;
}
function $435a2ceaa8778ed8$var$balanceYearMonth(date) {
  while (date.month < 1) {
    $435a2ceaa8778ed8$var$addYears(date, -1);
    date.month += date.calendar.getMonthsInYear(date);
  }
  let monthsInYear = 0;
  while (date.month > (monthsInYear = date.calendar.getMonthsInYear(date))) {
    date.month -= monthsInYear;
    $435a2ceaa8778ed8$var$addYears(date, 1);
  }
}
function $435a2ceaa8778ed8$var$balanceDay(date) {
  while (date.day < 1) {
    date.month--;
    $435a2ceaa8778ed8$var$balanceYearMonth(date);
    date.day += date.calendar.getDaysInMonth(date);
  }
  while (date.day > date.calendar.getDaysInMonth(date)) {
    date.day -= date.calendar.getDaysInMonth(date);
    date.month++;
    $435a2ceaa8778ed8$var$balanceYearMonth(date);
  }
}
function $435a2ceaa8778ed8$var$constrainMonthDay(date) {
  date.month = Math.max(1, Math.min(date.calendar.getMonthsInYear(date), date.month));
  date.day = Math.max(1, Math.min(date.calendar.getDaysInMonth(date), date.day));
}
function $435a2ceaa8778ed8$export$c4e2ecac49351ef2(date) {
  if (date.calendar.constrainDate) date.calendar.constrainDate(date);
  date.year = Math.max(1, Math.min(date.calendar.getYearsInEra(date), date.year));
  $435a2ceaa8778ed8$var$constrainMonthDay(date);
}
function $435a2ceaa8778ed8$export$3e2544e88a25bff8(duration) {
  let inverseDuration = {};
  for (let key in duration) if (typeof duration[key] === "number") inverseDuration[key] = -duration[key];
  return inverseDuration;
}
function $435a2ceaa8778ed8$export$4e2d2ead65e5f7e3(date, duration) {
  return $435a2ceaa8778ed8$export$e16d8520af44a096(date, $435a2ceaa8778ed8$export$3e2544e88a25bff8(duration));
}
function $435a2ceaa8778ed8$export$adaa4cf7ef1b65be(date, fields) {
  let mutableDate = date.copy();
  if (fields.era != null) mutableDate.era = fields.era;
  if (fields.year != null) mutableDate.year = fields.year;
  if (fields.month != null) mutableDate.month = fields.month;
  if (fields.day != null) mutableDate.day = fields.day;
  $435a2ceaa8778ed8$export$c4e2ecac49351ef2(mutableDate);
  return mutableDate;
}
function $435a2ceaa8778ed8$export$e5d5e1c1822b6e56(value, fields) {
  let mutableValue = value.copy();
  if (fields.hour != null) mutableValue.hour = fields.hour;
  if (fields.minute != null) mutableValue.minute = fields.minute;
  if (fields.second != null) mutableValue.second = fields.second;
  if (fields.millisecond != null) mutableValue.millisecond = fields.millisecond;
  $435a2ceaa8778ed8$export$7555de1e070510cb(mutableValue);
  return mutableValue;
}
function $435a2ceaa8778ed8$var$balanceTime(time) {
  time.second += Math.floor(time.millisecond / 1e3);
  time.millisecond = $435a2ceaa8778ed8$var$nonNegativeMod(time.millisecond, 1e3);
  time.minute += Math.floor(time.second / 60);
  time.second = $435a2ceaa8778ed8$var$nonNegativeMod(time.second, 60);
  time.hour += Math.floor(time.minute / 60);
  time.minute = $435a2ceaa8778ed8$var$nonNegativeMod(time.minute, 60);
  let days = Math.floor(time.hour / 24);
  time.hour = $435a2ceaa8778ed8$var$nonNegativeMod(time.hour, 24);
  return days;
}
function $435a2ceaa8778ed8$export$7555de1e070510cb(time) {
  time.millisecond = Math.max(0, Math.min(time.millisecond, 1e3));
  time.second = Math.max(0, Math.min(time.second, 59));
  time.minute = Math.max(0, Math.min(time.minute, 59));
  time.hour = Math.max(0, Math.min(time.hour, 23));
}
function $435a2ceaa8778ed8$var$nonNegativeMod(a, b) {
  let result = a % b;
  if (result < 0) result += b;
  return result;
}
function $435a2ceaa8778ed8$var$addTimeFields(time, duration) {
  time.hour += duration.hours || 0;
  time.minute += duration.minutes || 0;
  time.second += duration.seconds || 0;
  time.millisecond += duration.milliseconds || 0;
  return $435a2ceaa8778ed8$var$balanceTime(time);
}
function $435a2ceaa8778ed8$export$d52ced6badfb9a4c(value, field, amount, options) {
  let mutable = value.copy();
  switch (field) {
    case "era": {
      let eras = value.calendar.getEras();
      let eraIndex = eras.indexOf(value.era);
      if (eraIndex < 0) throw new Error("Invalid era: " + value.era);
      eraIndex = $435a2ceaa8778ed8$var$cycleValue(eraIndex, amount, 0, eras.length - 1, options?.round);
      mutable.era = eras[eraIndex];
      $435a2ceaa8778ed8$export$c4e2ecac49351ef2(mutable);
      break;
    }
    case "year":
      if (mutable.calendar.isInverseEra?.(mutable)) amount = -amount;
      mutable.year = $435a2ceaa8778ed8$var$cycleValue(value.year, amount, -Infinity, 9999, options?.round);
      if (mutable.year === -Infinity) mutable.year = 1;
      if (mutable.calendar.balanceYearMonth) mutable.calendar.balanceYearMonth(mutable, value);
      break;
    case "month":
      mutable.month = $435a2ceaa8778ed8$var$cycleValue(value.month, amount, 1, value.calendar.getMonthsInYear(value), options?.round);
      break;
    case "day":
      mutable.day = $435a2ceaa8778ed8$var$cycleValue(value.day, amount, 1, value.calendar.getDaysInMonth(value), options?.round);
      break;
    default:
      throw new Error("Unsupported field " + field);
  }
  if (value.calendar.balanceDate) value.calendar.balanceDate(mutable);
  $435a2ceaa8778ed8$export$c4e2ecac49351ef2(mutable);
  return mutable;
}
function $435a2ceaa8778ed8$export$dd02b3e0007dfe28(value, field, amount, options) {
  let mutable = value.copy();
  switch (field) {
    case "hour": {
      let hours = value.hour;
      let min = 0;
      let max = 23;
      if (options?.hourCycle === 12) {
        let isPM = hours >= 12;
        min = isPM ? 12 : 0;
        max = isPM ? 23 : 11;
      }
      mutable.hour = $435a2ceaa8778ed8$var$cycleValue(hours, amount, min, max, options?.round);
      break;
    }
    case "minute":
      mutable.minute = $435a2ceaa8778ed8$var$cycleValue(value.minute, amount, 0, 59, options?.round);
      break;
    case "second":
      mutable.second = $435a2ceaa8778ed8$var$cycleValue(value.second, amount, 0, 59, options?.round);
      break;
    case "millisecond":
      mutable.millisecond = $435a2ceaa8778ed8$var$cycleValue(value.millisecond, amount, 0, 999, options?.round);
      break;
    default:
      throw new Error("Unsupported field " + field);
  }
  return mutable;
}
function $435a2ceaa8778ed8$var$cycleValue(value, amount, min, max, round = false) {
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
function $435a2ceaa8778ed8$export$96b1d28349274637(dateTime, duration) {
  let ms;
  if (duration.years != null && duration.years !== 0 || duration.months != null && duration.months !== 0 || duration.weeks != null && duration.weeks !== 0 || duration.days != null && duration.days !== 0) {
    let res2 = $435a2ceaa8778ed8$export$e16d8520af44a096((0, $d07e34cce18680fd$export$b21e0b124e224484)(dateTime), {
      years: duration.years,
      months: duration.months,
      weeks: duration.weeks,
      days: duration.days
    });
    ms = (0, $d07e34cce18680fd$export$5107c82f94518f5c)(res2, dateTime.timeZone);
  } else
    ms = (0, $d07e34cce18680fd$export$bd4fb2bc8bb06fb)(dateTime) - dateTime.offset;
  ms += duration.milliseconds || 0;
  ms += (duration.seconds || 0) * 1e3;
  ms += (duration.minutes || 0) * 6e4;
  ms += (duration.hours || 0) * 36e5;
  let res = (0, $d07e34cce18680fd$export$1b96692a1ba042ac)(ms, dateTime.timeZone);
  return (0, $d07e34cce18680fd$export$b4a036af3fc0b032)(res, dateTime.calendar);
}
function $435a2ceaa8778ed8$export$6814caac34ca03c7(dateTime, duration) {
  return $435a2ceaa8778ed8$export$96b1d28349274637(dateTime, $435a2ceaa8778ed8$export$3e2544e88a25bff8(duration));
}
function $435a2ceaa8778ed8$export$9a297d111fc86b79(dateTime, field, amount, options) {
  switch (field) {
    case "hour": {
      let min = 0;
      let max = 23;
      if (options?.hourCycle === 12) {
        let isPM = dateTime.hour >= 12;
        min = isPM ? 12 : 0;
        max = isPM ? 23 : 11;
      }
      let plainDateTime = (0, $d07e34cce18680fd$export$b21e0b124e224484)(dateTime);
      let minDate = (0, $d07e34cce18680fd$export$b4a036af3fc0b032)($435a2ceaa8778ed8$export$e5d5e1c1822b6e56(plainDateTime, {
        hour: min
      }), new (0, $93635573935797de$export$80ee6245ec4f29ec)());
      let minAbsolute = [
        (0, $d07e34cce18680fd$export$5107c82f94518f5c)(minDate, dateTime.timeZone, "earlier"),
        (0, $d07e34cce18680fd$export$5107c82f94518f5c)(minDate, dateTime.timeZone, "later")
      ].filter((ms2) => (0, $d07e34cce18680fd$export$1b96692a1ba042ac)(ms2, dateTime.timeZone).day === minDate.day)[0];
      let maxDate = (0, $d07e34cce18680fd$export$b4a036af3fc0b032)($435a2ceaa8778ed8$export$e5d5e1c1822b6e56(plainDateTime, {
        hour: max
      }), new (0, $93635573935797de$export$80ee6245ec4f29ec)());
      let maxAbsolute = [
        (0, $d07e34cce18680fd$export$5107c82f94518f5c)(maxDate, dateTime.timeZone, "earlier"),
        (0, $d07e34cce18680fd$export$5107c82f94518f5c)(maxDate, dateTime.timeZone, "later")
      ].filter((ms2) => (0, $d07e34cce18680fd$export$1b96692a1ba042ac)(ms2, dateTime.timeZone).day === maxDate.day).pop();
      let ms = (0, $d07e34cce18680fd$export$bd4fb2bc8bb06fb)(dateTime) - dateTime.offset;
      let hours = Math.floor(ms / $435a2ceaa8778ed8$var$ONE_HOUR);
      let remainder = ms % $435a2ceaa8778ed8$var$ONE_HOUR;
      ms = $435a2ceaa8778ed8$var$cycleValue(hours, amount, Math.floor(minAbsolute / $435a2ceaa8778ed8$var$ONE_HOUR), Math.floor(maxAbsolute / $435a2ceaa8778ed8$var$ONE_HOUR), options?.round) * $435a2ceaa8778ed8$var$ONE_HOUR + remainder;
      return (0, $d07e34cce18680fd$export$b4a036af3fc0b032)((0, $d07e34cce18680fd$export$1b96692a1ba042ac)(ms, dateTime.timeZone), dateTime.calendar);
    }
    case "minute":
    case "second":
    case "millisecond":
      return $435a2ceaa8778ed8$export$dd02b3e0007dfe28(dateTime, field, amount, options);
    case "era":
    case "year":
    case "month":
    case "day": {
      let res = $435a2ceaa8778ed8$export$d52ced6badfb9a4c((0, $d07e34cce18680fd$export$b21e0b124e224484)(dateTime), field, amount, options);
      let ms = (0, $d07e34cce18680fd$export$5107c82f94518f5c)(res, dateTime.timeZone);
      return (0, $d07e34cce18680fd$export$b4a036af3fc0b032)((0, $d07e34cce18680fd$export$1b96692a1ba042ac)(ms, dateTime.timeZone), dateTime.calendar);
    }
    default:
      throw new Error("Unsupported field " + field);
  }
}
function $435a2ceaa8778ed8$export$31b5430eb18be4f8(dateTime, fields, disambiguation) {
  let plainDateTime = (0, $d07e34cce18680fd$export$b21e0b124e224484)(dateTime);
  let res = $435a2ceaa8778ed8$export$e5d5e1c1822b6e56($435a2ceaa8778ed8$export$adaa4cf7ef1b65be(plainDateTime, fields), fields);
  if (res.compare(plainDateTime) === 0) return dateTime;
  let ms = (0, $d07e34cce18680fd$export$5107c82f94518f5c)(res, dateTime.timeZone, disambiguation);
  return (0, $d07e34cce18680fd$export$b4a036af3fc0b032)((0, $d07e34cce18680fd$export$1b96692a1ba042ac)(ms, dateTime.timeZone), dateTime.calendar);
}

// ../node_modules/.pnpm/@internationalized+date@3.12.1/node_modules/@internationalized/date/dist/private/CalendarDate.mjs
function $2aaf608024c21ca1$var$shiftArgs(args) {
  let calendar = typeof args[0] === "object" ? args.shift() : new (0, $93635573935797de$export$80ee6245ec4f29ec)();
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
var $2aaf608024c21ca1$export$99faa760c7908e4f = class _$2aaf608024c21ca1$export$99faa760c7908e4f {
  // This prevents TypeScript from allowing other types with the same fields to match.
  // i.e. a ZonedDateTime should not be be passable to a parameter that expects CalendarDate.
  // If that behavior is desired, use the AnyCalendarDate interface instead.
  // @ts-ignore
  #type;
  constructor(...args) {
    let [calendar, era, year, month, day] = $2aaf608024c21ca1$var$shiftArgs(args);
    this.calendar = calendar;
    this.era = era;
    this.year = year;
    this.month = month;
    this.day = day;
    (0, $435a2ceaa8778ed8$export$c4e2ecac49351ef2)(this);
  }
  /** Returns a copy of this date. */
  copy() {
    if (this.era) return new _$2aaf608024c21ca1$export$99faa760c7908e4f(this.calendar, this.era, this.year, this.month, this.day);
    else return new _$2aaf608024c21ca1$export$99faa760c7908e4f(this.calendar, this.year, this.month, this.day);
  }
  /** Returns a new `CalendarDate` with the given duration added to it. */
  add(duration) {
    return (0, $435a2ceaa8778ed8$export$e16d8520af44a096)(this, duration);
  }
  /** Returns a new `CalendarDate` with the given duration subtracted from it. */
  subtract(duration) {
    return (0, $435a2ceaa8778ed8$export$4e2d2ead65e5f7e3)(this, duration);
  }
  /** Returns a new `CalendarDate` with the given fields set to the provided values. Other fields will be constrained accordingly. */
  set(fields) {
    return (0, $435a2ceaa8778ed8$export$adaa4cf7ef1b65be)(this, fields);
  }
  /**
  * Returns a new `CalendarDate` with the given field adjusted by a specified amount.
  * When the resulting value reaches the limits of the field, it wraps around.
  */
  cycle(field, amount, options) {
    return (0, $435a2ceaa8778ed8$export$d52ced6badfb9a4c)(this, field, amount, options);
  }
  /** Converts the date to a native JavaScript Date object, with the time set to midnight in the given time zone. */
  toDate(timeZone) {
    return (0, $d07e34cce18680fd$export$e67a095c620b86fe)(this, timeZone);
  }
  /** Converts the date to an ISO 8601 formatted string. */
  toString() {
    return (0, $58246871e4652552$export$60dfd74aa96791bd)(this);
  }
  /** Compares this date with another. A negative result indicates that this date is before the given one, and a positive date indicates that it is after. */
  compare(b) {
    return (0, $ad063034c8620db8$export$68781ddf31c0090f)(this, b);
  }
};
var $2aaf608024c21ca1$export$ca871e8dbb80966f = class _$2aaf608024c21ca1$export$ca871e8dbb80966f {
  // This prevents TypeScript from allowing other types with the same fields to match.
  // @ts-ignore
  #type;
  constructor(...args) {
    let [calendar, era, year, month, day] = $2aaf608024c21ca1$var$shiftArgs(args);
    this.calendar = calendar;
    this.era = era;
    this.year = year;
    this.month = month;
    this.day = day;
    this.hour = args.shift() || 0;
    this.minute = args.shift() || 0;
    this.second = args.shift() || 0;
    this.millisecond = args.shift() || 0;
    (0, $435a2ceaa8778ed8$export$c4e2ecac49351ef2)(this);
  }
  /** Returns a copy of this date. */
  copy() {
    if (this.era) return new _$2aaf608024c21ca1$export$ca871e8dbb80966f(this.calendar, this.era, this.year, this.month, this.day, this.hour, this.minute, this.second, this.millisecond);
    else return new _$2aaf608024c21ca1$export$ca871e8dbb80966f(this.calendar, this.year, this.month, this.day, this.hour, this.minute, this.second, this.millisecond);
  }
  /** Returns a new `CalendarDateTime` with the given duration added to it. */
  add(duration) {
    return (0, $435a2ceaa8778ed8$export$e16d8520af44a096)(this, duration);
  }
  /** Returns a new `CalendarDateTime` with the given duration subtracted from it. */
  subtract(duration) {
    return (0, $435a2ceaa8778ed8$export$4e2d2ead65e5f7e3)(this, duration);
  }
  /** Returns a new `CalendarDateTime` with the given fields set to the provided values. Other fields will be constrained accordingly. */
  set(fields) {
    return (0, $435a2ceaa8778ed8$export$adaa4cf7ef1b65be)((0, $435a2ceaa8778ed8$export$e5d5e1c1822b6e56)(this, fields), fields);
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
        return (0, $435a2ceaa8778ed8$export$d52ced6badfb9a4c)(this, field, amount, options);
      default:
        return (0, $435a2ceaa8778ed8$export$dd02b3e0007dfe28)(this, field, amount, options);
    }
  }
  /** Converts the date to a native JavaScript Date object in the given time zone. */
  toDate(timeZone, disambiguation) {
    return (0, $d07e34cce18680fd$export$e67a095c620b86fe)(this, timeZone, disambiguation);
  }
  /** Converts the date to an ISO 8601 formatted string. */
  toString() {
    return (0, $58246871e4652552$export$4223de14708adc63)(this);
  }
  /** Compares this date with another. A negative result indicates that this date is before the given one, and a positive date indicates that it is after. */
  compare(b) {
    let res = (0, $ad063034c8620db8$export$68781ddf31c0090f)(this, b);
    if (res === 0) return (0, $ad063034c8620db8$export$c19a80a9721b80f6)(this, (0, $d07e34cce18680fd$export$b21e0b124e224484)(b));
    return res;
  }
};
var $2aaf608024c21ca1$export$d3b7288e7994edea = class _$2aaf608024c21ca1$export$d3b7288e7994edea {
  // This prevents TypeScript from allowing other types with the same fields to match.
  // @ts-ignore
  #type;
  constructor(...args) {
    let [calendar, era, year, month, day] = $2aaf608024c21ca1$var$shiftArgs(args);
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
    (0, $435a2ceaa8778ed8$export$c4e2ecac49351ef2)(this);
  }
  /** Returns a copy of this date. */
  copy() {
    if (this.era) return new _$2aaf608024c21ca1$export$d3b7288e7994edea(this.calendar, this.era, this.year, this.month, this.day, this.timeZone, this.offset, this.hour, this.minute, this.second, this.millisecond);
    else return new _$2aaf608024c21ca1$export$d3b7288e7994edea(this.calendar, this.year, this.month, this.day, this.timeZone, this.offset, this.hour, this.minute, this.second, this.millisecond);
  }
  /** Returns a new `ZonedDateTime` with the given duration added to it. */
  add(duration) {
    return (0, $435a2ceaa8778ed8$export$96b1d28349274637)(this, duration);
  }
  /** Returns a new `ZonedDateTime` with the given duration subtracted from it. */
  subtract(duration) {
    return (0, $435a2ceaa8778ed8$export$6814caac34ca03c7)(this, duration);
  }
  /** Returns a new `ZonedDateTime` with the given fields set to the provided values. Other fields will be constrained accordingly. */
  set(fields, disambiguation) {
    return (0, $435a2ceaa8778ed8$export$31b5430eb18be4f8)(this, fields, disambiguation);
  }
  /**
  * Returns a new `ZonedDateTime` with the given field adjusted by a specified amount.
  * When the resulting value reaches the limits of the field, it wraps around.
  */
  cycle(field, amount, options) {
    return (0, $435a2ceaa8778ed8$export$9a297d111fc86b79)(this, field, amount, options);
  }
  /** Converts the date to a native JavaScript Date object. */
  toDate() {
    return (0, $d07e34cce18680fd$export$83aac07b4c37b25)(this);
  }
  /** Converts the date to an ISO 8601 formatted string, including the UTC offset and time zone identifier. */
  toString() {
    return (0, $58246871e4652552$export$bf79f1ebf4b18792)(this);
  }
  /** Converts the date to an ISO 8601 formatted string in UTC. */
  toAbsoluteString() {
    return this.toDate().toISOString();
  }
  /** Compares this date with another. A negative result indicates that this date is before the given one, and a positive date indicates that it is after. */
  compare(b) {
    return this.toDate().getTime() - (0, $d07e34cce18680fd$export$84c95a83c799e074)(b, this.timeZone).toDate().getTime();
  }
};

// ../node_modules/.pnpm/@internationalized+date@3.12.1/node_modules/@internationalized/date/dist/private/string.mjs
var $58246871e4652552$var$DATE_RE = /^([+-]\d{6}|\d{4})-(\d{2})-(\d{2})$/;
var $58246871e4652552$var$ABSOLUTE_RE = /^([+-]\d{6}|\d{4})-(\d{2})-(\d{2})(?:T(\d{2}))?(?::(\d{2}))?(?::(\d{2}))?(\.\d+)?(?:(?:([+-]\d{2})(?::?(\d{2}))?)|Z)$/;
var $58246871e4652552$var$requiredDurationTimeGroups = [
  "hours",
  "minutes",
  "seconds"
];
var $58246871e4652552$var$requiredDurationGroups = [
  "years",
  "months",
  "weeks",
  "days",
  ...$58246871e4652552$var$requiredDurationTimeGroups
];
function $58246871e4652552$export$6b862160d295c8e(value) {
  let m = value.match($58246871e4652552$var$DATE_RE);
  if (!m) {
    if ($58246871e4652552$var$ABSOLUTE_RE.test(value)) throw new Error(`Invalid ISO 8601 date string: ${value}. Use parseAbsolute() instead.`);
    throw new Error("Invalid ISO 8601 date string: " + value);
  }
  let date = new (0, $2aaf608024c21ca1$export$99faa760c7908e4f)($58246871e4652552$var$parseNumber(m[1], 0, 9999), $58246871e4652552$var$parseNumber(m[2], 1, 12), 1);
  date.day = $58246871e4652552$var$parseNumber(m[3], 1, date.calendar.getDaysInMonth(date));
  return date;
}
function $58246871e4652552$var$parseNumber(value, min, max) {
  let val = Number(value);
  if (val < min || val > max) throw new RangeError(`Value out of range: ${min} <= ${val} <= ${max}`);
  return val;
}
function $58246871e4652552$export$f59dee82248f5ad4(time) {
  return `${String(time.hour).padStart(2, "0")}:${String(time.minute).padStart(2, "0")}:${String(time.second).padStart(2, "0")}${time.millisecond ? String(time.millisecond / 1e3).slice(1) : ""}`;
}
function $58246871e4652552$export$60dfd74aa96791bd(date) {
  let gregorianDate = (0, $d07e34cce18680fd$export$b4a036af3fc0b032)(date, new (0, $93635573935797de$export$80ee6245ec4f29ec)());
  let year;
  if (gregorianDate.era === "BC") year = gregorianDate.year === 1 ? "0000" : "-" + String(Math.abs(1 - gregorianDate.year)).padStart(6, "00");
  else year = String(gregorianDate.year).padStart(4, "0");
  return `${year}-${String(gregorianDate.month).padStart(2, "0")}-${String(gregorianDate.day).padStart(2, "0")}`;
}
function $58246871e4652552$export$4223de14708adc63(date) {
  return `${$58246871e4652552$export$60dfd74aa96791bd(date)}T${$58246871e4652552$export$f59dee82248f5ad4(date)}`;
}
function $58246871e4652552$var$offsetToString(offset) {
  let sign = Math.sign(offset) < 0 ? "-" : "+";
  offset = Math.abs(offset);
  let offsetHours = Math.floor(offset / 36e5);
  let offsetMinutes = Math.floor(offset % 36e5 / 6e4);
  let offsetSeconds = Math.floor(offset % 36e5 % 6e4 / 1e3);
  let stringOffset = `${sign}${String(offsetHours).padStart(2, "0")}:${String(offsetMinutes).padStart(2, "0")}`;
  if (offsetSeconds !== 0) stringOffset += `:${String(offsetSeconds).padStart(2, "0")}`;
  return stringOffset;
}
function $58246871e4652552$export$bf79f1ebf4b18792(date) {
  return `${$58246871e4652552$export$4223de14708adc63(date)}${$58246871e4652552$var$offsetToString(date.offset)}[${date.timeZone}]`;
}

// ../node_modules/.pnpm/@internationalized+date@3.12.1/node_modules/@internationalized/date/dist/private/DateFormatter.mjs
var $12a3c853105e5a70$var$formatterCache = /* @__PURE__ */ new Map();
var $12a3c853105e5a70$export$ad991b66133851cf = class {
  constructor(locale, options = {}) {
    this.formatter = $12a3c853105e5a70$var$getCachedDateFormatter(locale, options);
    this.options = options;
  }
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
    if ($12a3c853105e5a70$var$hasBuggyResolvedHourCycle()) {
      if (!this.resolvedHourCycle) this.resolvedHourCycle = $12a3c853105e5a70$var$getResolvedHourCycle(resolvedOptions.locale, this.options);
      resolvedOptions.hourCycle = this.resolvedHourCycle;
      resolvedOptions.hour12 = this.resolvedHourCycle === "h11" || this.resolvedHourCycle === "h12";
    }
    if (resolvedOptions.calendar === "ethiopic-amete-alem") resolvedOptions.calendar = "ethioaa";
    return resolvedOptions;
  }
};
var $12a3c853105e5a70$var$hour12Preferences = {
  true: {
    // Only Japanese uses the h11 style for 12 hour time. All others use h12.
    ja: "h11"
  },
  false: {}
};
function $12a3c853105e5a70$var$getCachedDateFormatter(locale, options = {}) {
  if (typeof options.hour12 === "boolean" && $12a3c853105e5a70$var$hasBuggyHour12Behavior()) {
    options = {
      ...options
    };
    let pref = $12a3c853105e5a70$var$hour12Preferences[String(options.hour12)][locale.split("-")[0]];
    let defaultHourCycle = options.hour12 ? "h12" : "h23";
    options.hourCycle = pref ?? defaultHourCycle;
    delete options.hour12;
  }
  let cacheKey = locale + (options ? Object.entries(options).sort((a, b) => a[0] < b[0] ? -1 : 1).join() : "");
  if ($12a3c853105e5a70$var$formatterCache.has(cacheKey)) return $12a3c853105e5a70$var$formatterCache.get(cacheKey);
  let numberFormatter = new Intl.DateTimeFormat(locale, options);
  $12a3c853105e5a70$var$formatterCache.set(cacheKey, numberFormatter);
  return numberFormatter;
}
var $12a3c853105e5a70$var$_hasBuggyHour12Behavior = null;
function $12a3c853105e5a70$var$hasBuggyHour12Behavior() {
  if ($12a3c853105e5a70$var$_hasBuggyHour12Behavior == null) $12a3c853105e5a70$var$_hasBuggyHour12Behavior = new Intl.DateTimeFormat("en-US", {
    hour: "numeric",
    hour12: false
  }).format(new Date(2020, 2, 3, 0)) === "24";
  return $12a3c853105e5a70$var$_hasBuggyHour12Behavior;
}
var $12a3c853105e5a70$var$_hasBuggyResolvedHourCycle = null;
function $12a3c853105e5a70$var$hasBuggyResolvedHourCycle() {
  if ($12a3c853105e5a70$var$_hasBuggyResolvedHourCycle == null) $12a3c853105e5a70$var$_hasBuggyResolvedHourCycle = new Intl.DateTimeFormat("fr", {
    hour: "numeric",
    hour12: false
  }).resolvedOptions().hourCycle === "h12";
  return $12a3c853105e5a70$var$_hasBuggyResolvedHourCycle;
}
function $12a3c853105e5a70$var$getResolvedHourCycle(locale, options) {
  if (!options.timeStyle && !options.hour) return void 0;
  locale = locale.replace(/(-u-)?-nu-[a-zA-Z0-9]+/, "");
  locale += (locale.includes("-u-") ? "" : "-u") + "-nu-latn";
  let formatter = $12a3c853105e5a70$var$getCachedDateFormatter(locale, {
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

// ../node_modules/.pnpm/@zag-js+date-utils@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-utils/dist/constrain.mjs
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
    aligned = $ad063034c8620db8$export$f91e89d3d0406102(date);
  } else if (duration.months) {
    aligned = $ad063034c8620db8$export$a5a3b454ada2268e(date);
  } else if (duration.weeks) {
    aligned = $ad063034c8620db8$export$42c81a444fbfb5d4(date, locale);
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
    aligned = $ad063034c8620db8$export$a75f2bff57811055(aligned, alignStart($d07e34cce18680fd$export$93522d1a439f3617(min), duration, locale));
  }
  if (max && date.compare(max) <= 0) {
    aligned = $ad063034c8620db8$export$5c333a116e949cdd(aligned, alignEnd($d07e34cce18680fd$export$93522d1a439f3617(max), duration, locale));
  }
  return aligned;
}
function constrainValue(date, minValue, maxValue) {
  const dateOnly = $d07e34cce18680fd$export$93522d1a439f3617(date);
  const minOnly = minValue ? $d07e34cce18680fd$export$93522d1a439f3617(minValue) : void 0;
  const maxOnly = maxValue ? $d07e34cce18680fd$export$93522d1a439f3617(maxValue) : void 0;
  let constrainedDateOnly = dateOnly;
  if (minOnly) {
    constrainedDateOnly = $ad063034c8620db8$export$a75f2bff57811055(constrainedDateOnly, minOnly);
  }
  if (maxOnly) {
    constrainedDateOnly = $ad063034c8620db8$export$5c333a116e949cdd(constrainedDateOnly, maxOnly);
  }
  if (constrainedDateOnly.compare(dateOnly) === 0) {
    return date;
  }
  if ("hour" in date) {
    return date.set({
      year: constrainedDateOnly.year,
      month: constrainedDateOnly.month,
      day: constrainedDateOnly.day
    });
  }
  return constrainedDateOnly;
}
function constrainSegments(date, minValue, maxValue) {
  const dateOnly = $d07e34cce18680fd$export$93522d1a439f3617(date);
  const minOnly = minValue ? $d07e34cce18680fd$export$93522d1a439f3617(minValue) : void 0;
  const maxOnly = maxValue ? $d07e34cce18680fd$export$93522d1a439f3617(maxValue) : void 0;
  let result = dateOnly;
  if (minOnly && result.compare(minOnly) < 0) {
    if (result.year < minOnly.year) {
      result = result.set({ year: minOnly.year });
    }
    if (result.compare(minOnly) < 0 && result.month < minOnly.month) {
      result = result.set({ month: minOnly.month });
    }
    if (result.compare(minOnly) < 0 && result.day < minOnly.day) {
      result = result.set({ day: minOnly.day });
    }
  }
  if (maxOnly && result.compare(maxOnly) > 0) {
    if (result.year > maxOnly.year) {
      result = result.set({ year: maxOnly.year });
    }
    if (result.compare(maxOnly) > 0 && result.month > maxOnly.month) {
      result = result.set({ month: maxOnly.month });
    }
    if (result.compare(maxOnly) > 0 && result.day > maxOnly.day) {
      result = result.set({ day: maxOnly.day });
    }
  }
  if (result.compare(dateOnly) === 0) {
    return date;
  }
  if ("hour" in date) {
    return date.set({ year: result.year, month: result.month, day: result.day });
  }
  return result;
}

// ../node_modules/.pnpm/@zag-js+date-utils@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-utils/dist/assertion.mjs
function isDateEqual(dateA, dateB) {
  if (dateA == null || dateB == null) return dateA === dateB;
  if (!("hour" in dateA) && !("hour" in dateB)) return $ad063034c8620db8$export$ea39ec197993aef0(dateA, dateB);
  return $d07e34cce18680fd$export$b21e0b124e224484(dateA).compare($d07e34cce18680fd$export$b21e0b124e224484(dateB)) === 0;
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
  return $ad063034c8620db8$export$ea39ec197993aef0(prevDate, startDate) || isDateOutsideRange(prevDate, minValue, maxValue);
}
function isNextRangeInvalid(endDate, minValue, maxValue) {
  const nextDate = endDate.add({ days: 1 });
  return $ad063034c8620db8$export$ea39ec197993aef0(nextDate, endDate) || isDateOutsideRange(nextDate, minValue, maxValue);
}

// ../node_modules/.pnpm/@zag-js+date-utils@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-utils/dist/mutation.mjs
function getTodayDate(timeZone, calendar) {
  const tod = $ad063034c8620db8$export$d0bdf45af03a6ea3(timeZone ?? $ad063034c8620db8$export$aa8b41735afcabd2());
  if (calendar) return $d07e34cce18680fd$export$b4a036af3fc0b032(tod, calendar);
  return tod;
}

// ../node_modules/.pnpm/@zag-js+date-utils@1.43.3_@internationalized+date@3.12.1/node_modules/@zag-js/date-utils/dist/locale.mjs
var digitsCache = /* @__PURE__ */ new Map();
function getLocaleDigits(locale) {
  let digits = digitsCache.get(locale);
  if (digits != null) return digits;
  const localeDigits = new Intl.NumberFormat(locale, { useGrouping: false }).format(1234567890);
  digits = "0123456789" + localeDigits;
  digitsCache.set(locale, digits);
  return digits;
}
var isDigit = (char, locale) => {
  return locale ? getLocaleDigits(locale).includes(char) : /\d/.test(char);
};
var isValidCharacter = (char, separator, locale) => {
  if (!char) return true;
  if (char.length !== 1) return true;
  return isDigit(char, locale) || separator.includes(char);
};
var ensureValidCharacters = (value, separator, locale) => {
  return value.split("").filter((char) => isValidCharacter(char, separator, locale)).join("");
};
var separatorCache = /* @__PURE__ */ new Map();
function getLocaleSeparator(locale) {
  let separator = separatorCache.get(locale);
  if (separator != null) return separator;
  const parts = new Intl.DateTimeFormat(locale).formatToParts(/* @__PURE__ */ new Date());
  const literal = parts.find((part) => part.type === "literal");
  separator = literal ? literal.value : "/";
  separatorCache.set(locale, separator);
  return separator;
}

export {
  $ad063034c8620db8$export$ea39ec197993aef0,
  $ad063034c8620db8$export$91b62ebf2ba703ee,
  $ad063034c8620db8$export$5a8da0c44a3afdf2,
  $ad063034c8620db8$export$ea840f5a6dda8147,
  $ad063034c8620db8$export$629b0a497aa65267,
  $ad063034c8620db8$export$461939dd4422153,
  $ad063034c8620db8$export$d0bdf45af03a6ea3,
  $ad063034c8620db8$export$a5a3b454ada2268e,
  $ad063034c8620db8$export$a2258d9c4118825c,
  $ad063034c8620db8$export$f91e89d3d0406102,
  $ad063034c8620db8$export$8b7aa55c66d5569e,
  $ad063034c8620db8$export$42c81a444fbfb5d4,
  $ad063034c8620db8$export$ef8b6d9133084f4e,
  $ad063034c8620db8$export$ccc1b2479e7dd654,
  $ad063034c8620db8$export$618d60ea299da42,
  $d07e34cce18680fd$export$93522d1a439f3617,
  $d07e34cce18680fd$export$b21e0b124e224484,
  $d07e34cce18680fd$export$b4a036af3fc0b032,
  $d07e34cce18680fd$export$84c95a83c799e074,
  $58246871e4652552$export$6b862160d295c8e,
  $2aaf608024c21ca1$export$99faa760c7908e4f,
  $12a3c853105e5a70$export$ad991b66133851cf,
  alignCenter,
  alignStart,
  alignEnd,
  constrainStart,
  constrainValue,
  constrainSegments,
  isDateEqual,
  isDateUnavailable,
  isDateOutsideRange,
  isPreviousRangeInvalid,
  isNextRangeInvalid,
  getTodayDate,
  isValidCharacter,
  ensureValidCharacters,
  getLocaleSeparator
};
