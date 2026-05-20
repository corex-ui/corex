import { describe, expect, it } from "vitest";
import { collapseStartIndex, computeItemHidden } from "../../components/timer";
import { timerTime } from "../helpers/timer";

describe("collapseStartIndex", () => {
  it("skips leading zeros when more segments remain", () => {
    expect(collapseStartIndex([0, 0, 1, 5])).toBe(2);
  });

  it("stops collapsing when only two segments remain", () => {
    expect(collapseStartIndex([0, 0, 0, 1])).toBe(2);
  });
});

describe("computeItemHidden", () => {
  it("respects segments list", () => {
    const root = document.createElement("div");
    root.dataset.segments = "minutes,seconds";
    const hidden = computeItemHidden(
      root,
      timerTime({ days: 0, hours: 0, minutes: 1, seconds: 30 })
    );
    expect(hidden).toEqual([true, true, false, false]);
  });

  it("collapses leading zeros in countdown mode", () => {
    const root = document.createElement("div");
    root.dataset.countdown = "true";
    const hidden = computeItemHidden(root, timerTime({ days: 0, hours: 0, minutes: 1, seconds: 5 }));
    expect(hidden[0]).toBe(true);
    expect(hidden[1]).toBe(true);
  });

  it("shows all segments when collapseLeadingZeros is false", () => {
    const root = document.createElement("div");
    root.dataset.collapseLeadingZeros = "false";
    const hidden = computeItemHidden(root, timerTime({ days: 0, hours: 0, minutes: 0, seconds: 1 }));
    expect(hidden).toEqual([false, false, false, false]);
  });
});
