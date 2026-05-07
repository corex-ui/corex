import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { Timer } from "../components/timer";
import type { Props, TickDetails } from "@zag-js/timer";
import type { Orientation } from "@zag-js/types";

import { getString, getBoolean, getNumber, getDir, canPushEvent } from "../lib/util";

type TimerHookState = {
  timer?: Timer;
  handlers?: Array<CallbackRef>;
};

function parseTimerTranslations(el: HTMLElement): Props["translations"] {
  const raw = el.dataset.translation;
  if (!raw) return undefined;
  try {
    const o = JSON.parse(raw) as { areaLabel?: string };
    if (typeof o.areaLabel === "string" && o.areaLabel.length > 0) {
      const label = o.areaLabel;
      return { areaLabel: () => label };
    }
  } catch {
    return undefined;
  }
  return undefined;
}

const TimerHook: Hook<object & TimerHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & TimerHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const zag = new Timer(el, {
      id: el.id,
      countdown: getBoolean(el, "countdown"),
      startMs: getNumber(el, "startMs"),
      targetMs: getNumber(el, "targetMs"),
      autoStart: getBoolean(el, "autoStart"),
      interval: getNumber(el, "interval"),
      dir: getDir(el),
      orientation: getString<Orientation>(el, "orientation"),
      translations: parseTimerTranslations(el),
      onTick: (details: TickDetails) => {
        const eventName = getString(el, "onTick");
        if (eventName && canPushEvent(this.liveSocket)) {
          pushEvent(eventName, {
            value: details.value,
            time: details.time,
            formattedTime: details.formattedTime,
            id: el.id,
          });
        }

        const eventNameClient = getString(el, "onTickClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
              bubbles: true,
              detail: {
                id: el.id,
                value: details.value,
                time: details.time,
                formattedTime: details.formattedTime,
              },
            })
          );
        }
      },
      onComplete: () => {
        const eventName = getString(el, "onComplete");
        if (eventName && canPushEvent(this.liveSocket)) {
          pushEvent(eventName, { id: el.id });
        }

        const eventNameClient = getString(el, "onCompleteClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
              bubbles: true,
              detail: { id: el.id },
            })
          );
        }
      },
    } as Props);
    zag.init();
    this.timer = zag;
    this.handlers = [];
  },

  updated(this: object & HookInterface<HTMLElement> & TimerHookState) {
    this.timer?.updateProps({
      id: this.el.id,
      countdown: getBoolean(this.el, "countdown"),
      startMs: getNumber(this.el, "startMs"),
      targetMs: getNumber(this.el, "targetMs"),
      autoStart: getBoolean(this.el, "autoStart"),
      interval: getNumber(this.el, "interval"),
      dir: getDir(this.el),
      orientation: getString<Orientation>(this.el, "orientation"),
      translations: parseTimerTranslations(this.el),
    } as Partial<Props>);
  },

  destroyed(this: object & HookInterface<HTMLElement> & TimerHookState) {
    if (this.handlers) {
      for (const h of this.handlers) this.removeHandleEvent(h);
    }
    this.timer?.destroy();
  },
};

export { TimerHook as Timer };
