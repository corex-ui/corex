import { describe, expect, it } from "vitest";
import * as datePicker from "@zag-js/date-picker";
import {
  applyInputAriaIfNeeded,
  buildZagDatePickerTranslations,
  DatePicker,
} from "../../components/date-picker";

function datePickerDayViewTree(): HTMLElement {
  const host = document.createElement("div");
  host.id = "dp-perf";
  host.innerHTML = `
    <div data-scope="date-picker" data-part="root"></div>
    <div data-scope="date-picker" data-part="control">
      <input data-scope="date-picker" data-part="input" />
    </div>
    <div data-scope="date-picker" data-part="positioner">
      <div data-scope="date-picker" data-part="content">
        <div data-part="day-view">
          <div data-part="view-control"></div>
          <div data-part="prev-trigger"></div>
          <div data-part="view-trigger"></div>
          <div data-part="next-trigger"></div>
          <table><thead></thead><tbody></tbody></table>
        </div>
        <div data-part="month-view" hidden><table><tbody></tbody></table></div>
        <div data-part="year-view" hidden><table><tbody></tbody></table></div>
      </div>
    </div>
  `;
  return host;
}

describe("buildZagDatePickerTranslations", () => {
  it("maps open/close calendar labels to trigger", () => {
    const t = buildZagDatePickerTranslations({
      openCalendar: "Open",
      closeCalendar: "Close",
    });
    expect(t.trigger?.(false)).toBe("Open");
    expect(t.trigger?.(true)).toBe("Close");
  });

  it("formats week numbers from template", () => {
    const t = buildZagDatePickerTranslations({ weekNumber: "W__N__" });
    expect(t.weekNumberCell?.(3)).toBe("W3");
  });

  it("picks view-specific prev/next labels", () => {
    const t = buildZagDatePickerTranslations({
      prevTriggerDay: "Prev day",
      prevTriggerMonth: "Prev month",
      prevTriggerYear: "Prev year",
    });
    expect(t.prevTrigger?.("day")).toBe("Prev day");
    expect(t.prevTrigger?.("month")).toBe("Prev month");
    expect(t.prevTrigger?.("year")).toBe("Prev year");
  });

  it("builds placeholder object", () => {
    const t = buildZagDatePickerTranslations({
      placeholderDay: "DD",
      placeholderMonth: "MM",
      placeholderYear: "YYYY",
    });
    const placeholder = t.placeholder as
      | (() => { day: string; month: string; year: string })
      | undefined;
    expect(placeholder?.()).toEqual({ day: "DD", month: "MM", year: "YYYY" });
  });
});

describe("applyInputAriaIfNeeded", () => {
  it("sets aria-label from translation when no label part", () => {
    const root = document.createElement("div");
    root.dataset.translation = JSON.stringify({ input: "Birth date" });
    const input = document.createElement("input");
    applyInputAriaIfNeeded(root, [input], "single");
    expect(input.getAttribute("aria-label")).toBe("Birth date");
  });

  it("skips when label part exists", () => {
    const root = document.createElement("div");
    root.innerHTML = `<span data-scope="date-picker" data-part="label">Date</span>`;
    root.dataset.translation = JSON.stringify({ input: "Birth date" });
    const input = document.createElement("input");
    applyInputAriaIfNeeded(root, [input], "single");
    expect(input.getAttribute("aria-label")).toBeNull();
  });

  it("skips range selection mode", () => {
    const root = document.createElement("div");
    root.dataset.translation = JSON.stringify({ input: "Range" });
    const input = document.createElement("input");
    applyInputAriaIfNeeded(root, [input], "range");
    expect(input.getAttribute("aria-label")).toBeNull();
  });
});

describe("DatePicker render", () => {
  it("reuses day table cells on repeated render", () => {
    const host = datePickerDayViewTree();
    const instance = new DatePicker(host, {
      id: host.id,
      selectionMode: "single",
      defaultOpen: true,
      defaultValue: [datePicker.parse("2024-06-15")],
    });
    instance.init();
    instance.render();

    const tbody = host.querySelector("tbody");
    const firstCell = tbody?.querySelector("td");
    expect(firstCell).toBeTruthy();

    instance.render();
    expect(tbody?.querySelector("td")).toBe(firstCell);

    instance.destroy();
  });

  it("reuses day table header row on repeated render", () => {
    const host = datePickerDayViewTree();
    const instance = new DatePicker(host, {
      id: host.id,
      selectionMode: "single",
      defaultOpen: true,
      defaultValue: [datePicker.parse("2024-06-15")],
    });
    instance.init();
    instance.render();

    const thead = host.querySelector("thead");
    const firstRow = thead?.querySelector("tr");
    expect(firstRow).toBeTruthy();

    instance.render();
    expect(thead?.querySelector("tr")).toBe(firstRow);

    instance.destroy();
  });
});
