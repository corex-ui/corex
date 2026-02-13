import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { DatePicker } from "../components/date-picker";

import type { ValueChangeDetails, Props } from "@zag-js/date-picker";
import type { Direction } from "@zag-js/types";
import * as datePicker from "@zag-js/date-picker";

import { getString, getBoolean, getStringList, getNumber } from "../lib/util";

function toISOString(d: { year: number; month: number; day: number }): string {
  const pad = (n: number) => String(n).padStart(2, "0");
  return `${d.year}-${pad(d.month)}-${pad(d.day)}`;
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

    const min = getString(el, "min");
    const max = getString(el, "max");
    const positioningJson = getString(el, "positioning");
    const parseList = (v: string[] | undefined) => (v ? v.map((x) => datePicker.parse(x)) : undefined);
    const parseOne = (v: string | undefined) => (v ? datePicker.parse(v) : undefined);


    const datePickerInstance = new DatePicker(el, {
      id: el.id,
      ...(getBoolean(el, "controlled")
      ? { value: parseList(getStringList(el, "value") ) }
      : { defaultValue: parseList(getStringList(el, "defaultValue") )}),
      defaultFocusedValue: parseOne(getString(el, "focusedValue")),
      defaultView: getString<"day" | "month" | "year">(el, "defaultView", ["day", "month", "year"]),
      dir: getString<Direction>(el, "dir", ["ltr", "rtl"]),
      locale: getString(el, "locale"),
      timeZone: getString(el, "timeZone"),
      disabled: getBoolean(el, "disabled"),
      readOnly: getBoolean(el, "readOnly"),
      required: getBoolean(el, "required"),
      invalid: getBoolean(el, "invalid"),
      outsideDaySelectable: getBoolean(el, "outsideDaySelectable"),
      closeOnSelect: getBoolean(el, "closeOnSelect"),
      min: min ? datePicker.parse(min) : undefined,
      max: max ? datePicker.parse(max) : undefined,
      numOfMonths: getNumber(el, "numOfMonths"),
      startOfWeek: getNumber(el, "startOfWeek"),
      fixedWeeks: getBoolean(el, "fixedWeeks"),
      selectionMode: getString<"single" | "multiple" | "range">(el, "selectionMode", ["single", "multiple", "range"]),
      placeholder: getString(el, "placeholder"),
      minView: getString<"day" | "month" | "year">(el, "minView", ["day", "month", "year"]),
      maxView: getString<"day" | "month" | "year">(el, "maxView", ["day", "month", "year"]),
      inline: getBoolean(el, "inline"),
      positioning: positioningJson ? JSON.parse(positioningJson) : undefined,

      onValueChange: (details: ValueChangeDetails) => {
        const isoStr = details.value?.length
          ? details.value
              .map((d: { year: number; month: number; day: number }) => toISOString(d))
              .join(",")
          : "";

        const hiddenInput = el.querySelector<HTMLInputElement>(
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
            value: isoStr || null,
          });
        }
      },
      onFocusChange: (details: any) => {
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
      onVisibleRangeChange: (details: any) => {
        const eventName = getString(el, "onVisibleRangeChange");
        if (eventName && liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            id: el.id,
            start: details.start,
            end: details.end,
          });
        }
      },
      onOpenChange: (details: any) => {
        const eventName = getString(el, "onOpenChange");
        if (eventName && liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            id: el.id,
            open: details.open,
          });
        }
      },
    } as Props);

    datePickerInstance.init();
    this.datePicker = datePickerInstance;

    const inputWrapper = el.querySelector<HTMLElement>(
      '[data-scope="date-picker"][data-part="input-wrapper"]',
    );
    if (inputWrapper) inputWrapper.removeAttribute("data-loading");

    this.handlers = [];

    this.handlers.push(
      this.handleEvent("date_picker_set_value", (payload: { date_picker_id?: string; value: string }) => {
        const targetId = payload.date_picker_id;
        if (targetId && targetId !== el.id) return;
        datePickerInstance.api.setValue([datePicker.parse(payload.value)]);
      })
    );

    this.onSetValue = (event: Event) => {
      const value = (event as CustomEvent<{ value: string }>).detail?.value;
      if (typeof value === "string") {
        datePickerInstance.api.setValue([datePicker.parse(value)]);
      }
    };
    el.addEventListener("phx:date-picker:set-value", this.onSetValue);
  },

  updated(this: object & HookInterface<HTMLElement> & DatePickerHookState) {
    const el = this.el;
    const inputWrapper = el.querySelector<HTMLElement>(
      '[data-scope="date-picker"][data-part="input-wrapper"]',
    );
    if (inputWrapper) inputWrapper.removeAttribute("data-loading");

    const parseList = (v: string[] | undefined) => (v ? v.map((x) => datePicker.parse(x)) : undefined);
    const min = getString(el, "min");
    const max = getString(el, "max");
    const positioningJson = getString(el, "positioning");
    const isControlled = getBoolean(el, "controlled");
    const focusedStr = getString(el, "focusedValue");

    this.datePicker?.updateProps({
      ...(getBoolean(el, "controlled")
      ? { value: parseList(getStringList(el, "value") ) }
      : { defaultValue: parseList(getStringList(el, "defaultValue") )}),
      defaultFocusedValue: focusedStr ? datePicker.parse(focusedStr) : undefined,
      defaultView: getString<"day" | "month" | "year">(el, "defaultView", ["day", "month", "year"]),
      dir: getString<Direction>(this.el, "dir", ["ltr", "rtl"]),
      locale: getString(this.el, "locale"),
      timeZone: getString(this.el, "timeZone"),
      disabled: getBoolean(this.el, "disabled"),
      readOnly: getBoolean(this.el, "readOnly"),
      required: getBoolean(this.el, "required"),
      invalid: getBoolean(this.el, "invalid"),
      outsideDaySelectable: getBoolean(this.el, "outsideDaySelectable"),
      closeOnSelect: getBoolean(this.el, "closeOnSelect"),
      min: min ? datePicker.parse(min) : undefined,
      max: max ? datePicker.parse(max) : undefined,
      numOfMonths: getNumber(this.el, "numOfMonths"),
      startOfWeek: getNumber(this.el, "startOfWeek"),
      fixedWeeks: getBoolean(this.el, "fixedWeeks"),
      selectionMode: getString<"single" | "multiple" | "range">(this.el, "selectionMode", ["single", "multiple", "range"]),
      placeholder: getString(this.el, "placeholder"),
      minView: getString<"day" | "month" | "year">(this.el, "minView", ["day", "month", "year"]),
      maxView: getString<"day" | "month" | "year">(this.el, "maxView", ["day", "month", "year"]),
      inline: getBoolean(this.el, "inline"),
      positioning: positioningJson ? JSON.parse(positioningJson) : undefined,
    });

    if (isControlled && this.datePicker) {
      const serverValues = getStringList(el, "value");
      const serverIso = serverValues?.join(",") ?? "";
      const zagValue = this.datePicker.api.value;
      const zagIso = zagValue?.length
        ? zagValue.map((d: { year: number; month: number; day: number }) => toISOString(d)).join(",")
        : "";
      if (serverIso !== zagIso) {
        const parsed = serverValues?.length
          ? serverValues.map((x) => datePicker.parse(x))
          : [];
        this.datePicker.api.setValue(parsed);
      }
    }
  },

  destroyed(this: object & HookInterface<HTMLElement> & DatePickerHookState) {
    if (this.onSetValue) {
      this.el.removeEventListener("phx:date-picker:set-value", this.onSetValue);
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
