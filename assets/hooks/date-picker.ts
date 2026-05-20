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

import { getString, getBoolean, getStringList, getNumber, canPushEvent } from "../lib/util";
import { readPositioningOptions } from "../lib/positioning";
import { notifyChange } from "../lib/respond-to";

export function valueToIsoString(d: unknown): string {
  if (d == null) return "";
  return String(d);
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
      ...(getBoolean(el, "controlled")
        ? { value: parseList(getStringList(el, "value")) }
        : { defaultValue: parseList(getStringList(el, "defaultValue")) }),
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
        const isoStr = details.value?.length
          ? details.value
              .map((d: unknown) => valueToIsoString(d))
              .filter(Boolean)
              .join(",")
          : "";

        const hiddenInput = el.querySelector<HTMLInputElement>(`#${el.id}-value`);
        if (hiddenInput && hiddenInput.value !== isoStr) {
          hiddenInput.value = isoStr;
          hiddenInput.dispatchEvent(new Event("input", { bubbles: true }));
          hiddenInput.dispatchEvent(new Event("change", { bubbles: true }));
        }

        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: { id: el.id, value: isoStr || null } as Record<string, unknown>,
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
    const min = getString(el, "min");
    const max = getString(el, "max");
    const focusedStr = getString(el, "focusedValue");
    const controlled = getBoolean(el, "controlled");
    const valueList = getStringList(el, "value");

    this.datePicker?.updateProps({
      ...(controlled
        ? {
            value: (valueList ?? []).map((x) => datePicker.parse(x)),
          }
        : {}),
      defaultFocusedValue: focusedStr ? datePicker.parse(focusedStr) : undefined,
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
      inline: getBoolean(el, "inline"),
      positioning: readPositioningOptions(el),
      ...resolveZagDatePickerTranslations(el),
    } as Props);
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
