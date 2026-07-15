import { describe, expect, it, vi, afterEach } from "vitest";
import type { CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { parseTimerTranslations, Timer as TimerHook } from "../../hooks/timer";
import { Timer as TimerComponent } from "../../components/timer";
import {
  callHookDestroyed,
  callHookLifecycle,
  callHookMounted,
  mockHookContext,
} from "../helpers/mock-hook";

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

describe("Timer hook updated identity props", () => {
  afterEach(() => {
    document.body.innerHTML = "";
  });

  it("only re-pushes identity props when raw dataset strings change and never autoStart", () => {
    const el = document.createElement("div");
    el.id = "timer-1";
    el.dataset.startMs = "60000";
    el.dataset.interval = "1000";
    el.dataset.autoStart = "true";
    document.body.appendChild(el);

    const { hook } = mockHookContext(el, {
      connected: false,
      overrides: {
        timer: undefined as TimerComponent | undefined,
        handlers: [] as CallbackRef[],
      },
    });

    callHookMounted(TimerHook, hook);
    const updateSpy = vi.spyOn(hook.timer!, "updateProps");

    callHookLifecycle(TimerHook, hook, "updated");
    expect(updateSpy).toHaveBeenCalledTimes(1);
    const firstPatch = updateSpy.mock.calls[0]![0] as Record<string, unknown>;
    expect(firstPatch).not.toHaveProperty("startMs");
    expect(firstPatch).not.toHaveProperty("interval");
    expect(firstPatch).not.toHaveProperty("autoStart");

    el.dataset.startMs = "30000";
    callHookLifecycle(TimerHook, hook, "updated");
    const secondPatch = updateSpy.mock.calls[1]![0] as Record<string, unknown>;
    expect(secondPatch.startMs).toBe(30000);
    expect(secondPatch).not.toHaveProperty("autoStart");

    callHookDestroyed(TimerHook, hook);
    updateSpy.mockRestore();
  });
});
