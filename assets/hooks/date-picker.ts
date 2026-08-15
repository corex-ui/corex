import {
  DatePicker,
  buildZagDatePickerTranslations,
  type DatePickerMessageMap,
} from "../components/date-picker";

import type { ValueChangeDetails, Props, DateValue } from "@zag-js/date-picker";
import type { Direction } from "@zag-js/types";
import * as datePicker from "@zag-js/date-picker";

import { getString, getBoolean, getNumber, canPushEvent } from "../lib/util";
import {
  mountStringListBinding,
  readDatasetStringList,
  readUpdatedServerStringList,
} from "../lib/read-props";
import { setArrayValues, setScalarValue } from "../lib/phoenix-form-bridge";
import { readPositioningOptions } from "../lib/positioning";
import { notifyChange } from "../lib/respond-to";
import { createZagLiveHook } from "../lib/zag-live-hook";

const DATE_PICKER_UPDATE_ATTR_KEYS = [
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
  "positionHideWhenDetached",
] as const;

/** Boolean presence attrs: empty string when on, absent when off — both hash to "" via dataset. */
const DATE_PICKER_PRESENCE_ATTR_KEYS = new Set([
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
  "positionHideWhenDetached",
]);

function dataAttrName(camelKey: string): string {
  return `data-${camelKey.replace(/([A-Z])/g, "-$1").toLowerCase()}`;
}

function datePickerUpdateAttrsKey(el: HTMLElement): string {
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

type DateLike = { year: number; month: number; day: number };

function sameStringList(a: ReadonlyArray<string>, b: ReadonlyArray<string>): boolean {
  return a.length === b.length && a.every((v, i) => v === b[i]);
}

function isDateLike(d: unknown): d is DateLike {
  return (
    typeof d === "object" &&
    d !== null &&
    "year" in d &&
    "month" in d &&
    "day" in d &&
    typeof (d as DateLike).year === "number" &&
    typeof (d as DateLike).month === "number" &&
    typeof (d as DateLike).day === "number"
  );
}

function tryParseDate(raw: string, label = "date"): DateValue | undefined {
  try {
    return datePicker.parse(raw);
  } catch (error) {
    console.warn(`[corex] date-picker: failed to parse ${label}`, raw, error);
    return undefined;
  }
}

function tryParseDateList(values: string[] | undefined): DateValue[] | undefined {
  if (!values) return undefined;
  const parsed: DateValue[] = [];
  for (const x of values) {
    const next = tryParseDate(x, "value");
    if (next) parsed.push(next);
  }
  return parsed;
}

export function valueToIsoString(d: unknown): string {
  if (d == null) return "";

  if (typeof d === "string") {
    const trimmed = d.trim();
    if (trimmed === "") return "";
    try {
      return datePicker.parse(trimmed).toString();
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

function isoListFromValues(values: unknown[] | undefined): string[] {
  return values?.length ? values.map((d) => valueToIsoString(d)).filter(Boolean) : [];
}

function hiddenValueInputIsoList(el: HTMLElement): string[] {
  const hiddenInput = el.querySelector<HTMLInputElement>(
    '[data-scope="date-picker"][data-part="value-input"]'
  );
  if (!hiddenInput?.value) return [];

  return hiddenInput.value
    .split(",")
    .map((v) => v.trim())
    .filter(Boolean);
}

export function resolveIsoListForFormSync(
  el: HTMLElement,
  apiValues: unknown[] | undefined,
  serverValues?: string[] | null
): string[] {
  if (serverValues != null) {
    return serverValues;
  }

  const fromApi = isoListFromValues(apiValues);
  if (fromApi.length > 0) return fromApi;

  const fromHidden = hiddenValueInputIsoList(el);
  if (fromHidden.length > 0) return fromHidden;

  return readDatasetStringList(el, "value");
}

export function applyServerIsoToZagIfNeeded(
  datePickerInstance: DatePicker,
  isoList: string[]
): string[] {
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

export function syncDatePickerValueInput(
  el: HTMLElement,
  isoStr: string,
  notifyForm = false
): void {
  const hiddenInput = el.querySelector<HTMLInputElement>(
    '[data-scope="date-picker"][data-part="value-input"]'
  );
  if (!hiddenInput) return;

  if (notifyForm) {
    setScalarValue(hiddenInput, isoStr);
  } else {
    setScalarValue(hiddenInput, isoStr, { markUsed: false });
  }
}

function resolveZagDatePickerTranslations(
  el: HTMLElement
): { translations: NonNullable<Props["translations"]> } | Record<string, never> {
  const raw = el.dataset.translation;
  if (!raw) {
    return {};
  }
  try {
    const tr = JSON.parse(raw) as DatePickerMessageMap;
    return { translations: buildZagDatePickerTranslations(tr) };
  } catch {
    return {};
  }
}

export function resolveCloseOnSelect(el: HTMLElement): boolean {
  return getBoolean(el, "closeOnSelect");
}

type DatePickerHookState = {
  datePicker?: DatePicker;
  fieldTouched?: boolean;
  lastUpdateAttrsKey?: string;
  locale?: string;
};

const DatePickerHook = createZagLiveHook<DatePickerHookState, DatePicker>({
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
    const parseList = (v: string[] | undefined) => tryParseDateList(v);
    const parseOne = (v: string | undefined) => (v ? tryParseDate(v, "focusedValue") : undefined);
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
      defaultView: getString<"day" | "month" | "year">(el, "defaultView"),
      dir: getString<Direction>(el, "dir"),
      locale: getString(el, "locale"),
      timeZone: getString(el, "timeZone"),
      disabled: getBoolean(el, "disabled"),
      readOnly: getBoolean(el, "readonly"),
      required: getBoolean(el, "required"),
      invalid: getBoolean(el, "invalid"),
      outsideDaySelectable: getBoolean(el, "outsideDaySelectable"),
      closeOnSelect: resolveCloseOnSelect(el),
      min: min ? tryParseDate(min, "min") : undefined,
      max: max ? tryParseDate(max, "max") : undefined,
      startOfWeek: getNumber(el, "startOfWeek"),
      fixedWeeks: getBoolean(el, "fixedWeeks"),
      selectionMode: getString<"single" | "multiple" | "range">(el, "selectionMode"),
      maxSelectedDates: getNumber(el, "maxSelectedDates"),
      placeholder: getString(el, "placeholder"),
      minView: getString<"day" | "month" | "year">(el, "minView"),
      maxView: getString<"day" | "month" | "year">(el, "maxView"),
      defaultOpen: false,
      inline: getBoolean(el, "inline"),
      positioning: readPositioningOptions(el),
      ...resolveZagDatePickerTranslations(el),

      onValueChange: (details: ValueChangeDetails) => {
        const isoList = isoListFromValues(details.value);
        const isMountEcho = hook.fieldTouched !== true && sameStringList(isoList, initialIsoList);
        if (!isMountEcho) {
          hook.fieldTouched = true;
        }

        const submitName = getString(el, "submitName");
        if (submitName) {
          setArrayValues(el, isoList, {
            scope: "date-picker",
            submitName,
            notifyLiveView: !isMountEcho,
          });
        } else {
          const isoStr = isoList.length > 0 ? isoList.join(",") : "";
          syncDatePickerValueInput(el, isoStr, !isMountEcho);
        }

        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: {
            id: el.id,
            value: isoList.length > 0 ? isoList.join(",") : null,
          } as Record<string, unknown>,
          serverEventName: getString(el, "onValueChange"),
          clientEventName: getString(el, "onValueChangeClient"),
        });
      },
      onFocusChange: (details: { focused?: boolean }) => {
        const eventName = getString(el, "onFocusChange");
        if (eventName && canPushEvent(liveSocket)) {
          pushEvent(eventName, {
            id: el.id,
            focused: details.focused ?? false,
          });
        }
      },
      onViewChange: (details) => {
        const eventName = getString(el, "onViewChange");
        if (eventName && canPushEvent(liveSocket)) {
          pushEvent(eventName, {
            id: el.id,
            view: details.view,
          });
        }
      },
      onVisibleRangeChange: (details: { start?: unknown; end?: unknown }) => {
        const eventName = getString(el, "onVisibleRangeChange");
        if (eventName && canPushEvent(liveSocket)) {
          pushEvent(eventName, {
            id: el.id,
            start: details.start,
            end: details.end,
          });
        }
      },
      onOpenChange: (details: { open?: boolean }) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: { id: el.id, open: details.open } as Record<string, unknown>,
          serverEventName: getString(el, "onOpenChange"),
          clientEventName: getString(el, "onOpenChangeClient"),
        });
      },
    } as Props);

    const submitName = getString(el, "submitName");
    const isoList = applyServerIsoToZagIfNeeded(
      datePickerInstance,
      resolveIsoListForFormSync(el, datePickerInstance.api.value)
    );

    if (submitName) {
      setArrayValues(el, isoList, {
        scope: "date-picker",
        submitName,
        notifyLiveView: false,
      });
    } else {
      syncDatePickerValueInput(el, isoList.length > 0 ? isoList.join(",") : "", false);
    }

    server.add("date_picker_set_value", (payload: { date_picker_id?: string; value: string }) => {
      const targetId = payload.date_picker_id;
      if (!targetId || targetId !== el.id) return;
      const parsed = tryParseDate(payload.value, "set_value");
      if (parsed) datePickerInstance.api.setValue([parsed]);
    });

    dom.add<CustomEvent<{ value: string }>>("corex:date-picker:set-value", (event) => {
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
    const localeChanged = hook.locale !== undefined && hook.locale !== locale;
    hook.locale = locale;

    zag.updateProps({
      dir: getString<Direction>(el, "dir"),
      locale: getString(el, "locale"),
      timeZone: getString(el, "timeZone"),
      disabled: getBoolean(el, "disabled"),
      readOnly: getBoolean(el, "readonly"),
      required: getBoolean(el, "required"),
      invalid: getBoolean(el, "invalid"),
      outsideDaySelectable: getBoolean(el, "outsideDaySelectable"),
      closeOnSelect: resolveCloseOnSelect(el),
      min: min ? tryParseDate(min, "min") : undefined,
      max: max ? tryParseDate(max, "max") : undefined,
      startOfWeek: getNumber(el, "startOfWeek"),
      fixedWeeks: getBoolean(el, "fixedWeeks"),
      selectionMode: getString<"single" | "multiple" | "range">(el, "selectionMode"),
      maxSelectedDates: getNumber(el, "maxSelectedDates"),
      placeholder: getString(el, "placeholder"),
      minView: getString<"day" | "month" | "year">(el, "minView"),
      maxView: getString<"day" | "month" | "year">(el, "maxView"),
      inline: getBoolean(el, "inline"),
      positioning: readPositioningOptions(el),
      ...resolveZagDatePickerTranslations(el),
      ...(valuePatch.value !== undefined ? { value: tryParseDateList(valuePatch.value) } : {}),
    } as Props);

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
        notifyLiveView: false,
      });
    } else {
      syncDatePickerValueInput(el, isoList.length > 0 ? isoList.join(",") : "", false);
    }
  },
});

export { DatePickerHook as DatePicker };
