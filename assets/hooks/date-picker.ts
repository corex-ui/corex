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
import { syncArrayHiddenInputsForPhoenix } from "../lib/form-array-submit";
import {
  mountStringListBinding,
  readDatasetStringList,
  readUpdatedServerStringList,
} from "../lib/read-props";
import { notifyPhoenixFormChange } from "../lib/live-view-form-input";
import { readPositioningOptions } from "../lib/positioning";
import { notifyChange } from "../lib/respond-to";

type DateLike = { year: number; month: number; day: number };

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

  if (hiddenInput.value !== isoStr) {
    hiddenInput.value = isoStr;
  }

  if (notifyForm) {
    notifyPhoenixFormChange(hiddenInput, isoStr);
  } else {
    notifyPhoenixFormChange(hiddenInput, isoStr, { markUsed: false });
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
};

const DatePickerHook: Hook<object & DatePickerHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & DatePickerHookState) {
    const el = this.el;
    const hook = this as object & HookInterface<HTMLElement> & DatePickerHookState;
    hook.allowFormNotify = false;
    const pushEvent = this.pushEvent.bind(this);
    const liveSocket = this.liveSocket;
    const canPush = () => canPushEvent(this.liveSocket);

    const min = getString(el, "min");
    const max = getString(el, "max");
    const parseList = (v: string[] | undefined) =>
      v ? v.map((x) => datePicker.parse(x)) : undefined;
    const parseOne = (v: string | undefined) => (v ? datePicker.parse(v) : undefined);

    const datePickerInstance = new DatePicker(el, {
      id: el.id,
      ...(() => {
        const binding = mountStringListBinding(el);
        if ("value" in binding) {
          return { value: parseList(binding.value) };
        }
        return { defaultValue: parseList(binding.defaultValue) };
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

        const submitName = getString(el, "submitName");
        if (submitName) {
          syncArrayHiddenInputsForPhoenix(el, isoList, {
            scope: "date-picker",
            submitName,
            notifyLiveView: hook.allowFormNotify === true,
          });
        } else {
          const isoStr = isoList.length > 0 ? isoList.join(",") : "";
          syncDatePickerValueInput(el, isoStr, hook.allowFormNotify === true);
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

    queueMicrotask(() => {
      const submitName = getString(el, "submitName");
      const isoList = applyServerIsoToZagIfNeeded(
        datePickerInstance,
        resolveIsoListForFormSync(el, datePickerInstance.api.value)
      );

      if (submitName) {
        syncArrayHiddenInputsForPhoenix(el, isoList, {
          scope: "date-picker",
          submitName,
          notifyLiveView: false,
        });
      } else {
        syncDatePickerValueInput(el, isoList.length > 0 ? isoList.join(",") : "", false);
      }

      hook.allowFormNotify = true;
    });

    this.handlers = [];

    this.handlers.push(
      this.handleEvent(
        "date_picker_set_value",
        (payload: { date_picker_id?: string; value: string }) => {
          const targetId = payload.date_picker_id;
          if (targetId && targetId !== el.id) return;
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
    const valuePatch = readUpdatedServerStringList(el);
    const parsedValue =
      "value" in valuePatch ? { value: valuePatch.value.map((x) => datePicker.parse(x)) } : {};

    zag?.updateProps({
      ...parsedValue,
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

    if (!getString(el, "submitName")) {
      queueMicrotask(() => {
        const serverValues = "value" in valuePatch ? valuePatch.value : null;
        let isoList = resolveIsoListForFormSync(el, zag?.api.value, serverValues);

        if (zag) {
          isoList = applyServerIsoToZagIfNeeded(zag, isoList);
        }

        syncDatePickerValueInput(el, isoList.join(","), false);
      });
    }
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
