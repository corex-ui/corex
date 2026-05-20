import { describe, expect, it } from "vitest";
import { parseTimerTranslations } from "../../hooks/timer";

describe("parseTimerTranslations", () => {
  it("returns areaLabel function from JSON", () => {
    const el = document.createElement("div");
    el.dataset.translation = JSON.stringify({ areaLabel: "Countdown" });
    const t = parseTimerTranslations(el);
    const areaLabel = t?.areaLabel as (() => string) | undefined;
    expect(areaLabel?.()).toBe("Countdown");
  });

  it("returns undefined for invalid JSON", () => {
    const el = document.createElement("div");
    el.dataset.translation = "{";
    expect(parseTimerTranslations(el)).toBeUndefined();
  });
});
