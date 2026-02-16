import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { Timer } from "../components/timer";
import type { Props, TickDetails } from "@zag-js/timer";
import { getString, getBoolean, getNumber } from "../lib/util";

type TimerHookState = {
  timer?: Timer;
  handlers?: Array<CallbackRef>;
};

const TimerHook: Hook<object & TimerHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & TimerHookState) {
    const el = this.el;
    const zag = new Timer(el, {
      id: el.id,
      countdown: getBoolean(el, "countdown"),
      startMs: getNumber(el, "startMs"),
      targetMs: getNumber(el, "targetMs"),
      autoStart: getBoolean(el, "autoStart"),
      interval: getNumber(el, "interval") ?? 1000,
      onTick: (details: TickDetails) => {
        const eventName = getString(el, "onTick");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, {
            value: details.value,
            time: details.time,
            formattedTime: details.formattedTime,
            id: el.id,
          });
        }
      },
      onComplete: () => {
        const eventName = getString(el, "onComplete");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, { id: el.id });
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
      interval: getNumber(this.el, "interval") ?? 1000,
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
