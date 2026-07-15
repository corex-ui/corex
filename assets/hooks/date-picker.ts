import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import {
  DatePicker,
  buildZagDatePickerTranslations,
  type DatePickerMessageMap,
} from "../components/date-picker";

import type { ValueChangeDetails, Props } from "@zag-js/date-picker";
import type { Direction } from "@zag-js/types";
import * as datePicker from "@zag-js/date-picker";

import { getString, getBoolean, getNumber, canPushEvent } from "../lib/util";
import { mountStringListBinding, readDatasetStringList } from "../lib/read-props";
import { setArrayValues, setScalarValue } from "../lib/phoenix-form-bridge";
import { readPositioningOptions } from "../lib/positioning";
import { notifyChange } from "../lib/respond-to";

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

  datePickerInstance.api.setValue(isoList.map((x) => datePicker.parse(x)));
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
  handlers?: Array<CallbackRef>;
  onSetValue?: (event: Event) => void;
  fieldTouched?: boolean;
};

const DatePickerHook: Hook<object & DatePickerHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & DatePickerHookState) {
    const el = this.el;
    const hook = this as object & HookInterface<HTMLElement> & DatePickerHookState;
    hook.fieldTouched = false;
    const pushEvent = this.pushEvent.bind(this);
    const liveSocket = this.liveSocket;
    const canPush = () => canPushEvent(this.liveSocket);

    const min = getString(el, "min");
    const max = getString(el, "max");
    const parseList = (v: string[] | undefined) =>
      v ? v.map((x) => datePicker.parse(x)) : undefined;
    const parseOne = (v: string | undefined) => (v ? datePicker.parse(v) : undefined);
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
      min: min ? datePicker.parse(min) : undefined,
      max: max ? datePicker.parse(max) : undefined,
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
        if (eventName && liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            id: el.id,
            focused: details.focused ?? false,
          });
        }
      },
      onViewChange: (details) => {
        const eventName = getString(el, "onViewChange");
        if (eventName && liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            id: el.id,
            view: details.view,
          });
        }
      },
      onVisibleRangeChange: (details: { start?: unknown; end?: unknown }) => {
        const eventName = getString(el, "onVisibleRangeChange");
        if (eventName && liveSocket.main.isConnected()) {
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

    datePickerInstance.init();
    this.datePicker = datePickerInstance;

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

    this.handlers = [];

    this.handlers.push(
      this.handleEvent(
        "date_picker_set_value",
        (payload: { date_picker_id?: string; value: string }) => {
          const targetId = payload.date_picker_id;
          if (!targetId || targetId !== el.id) return;
          datePickerInstance.api.setValue([datePicker.parse(payload.value)]);
        }
      )
    );

    this.onSetValue = (event: Event) => {
      const value = (event as CustomEvent<{ value: string }>).detail?.value;
      if (typeof value === "string") {
        datePickerInstance.api.setValue([datePicker.parse(value)]);
      }
    };
    el.addEventListener("corex:date-picker:set-value", this.onSetValue);
  },

  updated(this: object & HookInterface<HTMLElement> & DatePickerHookState) {
    const el = this.el;
    const zag = this.datePicker;
    const min = getString(el, "min");
    const max = getString(el, "max");

    zag?.updateProps({
      dir: getString<Direction>(el, "dir"),
      locale: getString(el, "locale"),
      timeZone: getString(el, "timeZone"),
      disabled: getBoolean(el, "disabled"),
      readOnly: getBoolean(el, "readonly"),
      required: getBoolean(el, "required"),
      invalid: getBoolean(el, "invalid"),
      outsideDaySelectable: getBoolean(el, "outsideDaySelectable"),
      closeOnSelect: resolveCloseOnSelect(el),
      min: min ? datePicker.parse(min) : undefined,
      max: max ? datePicker.parse(max) : undefined,
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
    } as Props);

    if (!zag) return;

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
    zag.render();
  },

  destroyed(this: object & HookInterface<HTMLElement> & DatePickerHookState) {
    if (this.onSetValue) {
      this.el.removeEventListener("corex:date-picker:set-value", this.onSetValue);
    }
    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }

    this.datePicker?.destroy();
  },
};

export { DatePickerHook as DatePicker };
