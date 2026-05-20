import { describe, expect, it } from "vitest";
import {
  applyInputAriaIfNeeded,
  buildZagDatePickerTranslations,
} from "../../components/date-picker";

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
