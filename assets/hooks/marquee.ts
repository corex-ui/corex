import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { Marquee } from "../components/marquee";
import type { Props } from "@zag-js/marquee";
import { getBoolean, getDir, getNumber, getString } from "../lib/util";
import { idMatches, readPayloadId } from "../lib/respond-to";

type MarqueeHookState = {
  marquee?: Marquee;
  handlers?: Array<CallbackRef>;
  onPause?: (event: Event) => void;
  onResume?: (event: Event) => void;
  onTogglePause?: (event: Event) => void;
};

export function readMarqueeProps(el: HTMLElement) {
  return {
    id: el.id,
    translations: { root: getString(el, "ariaLabel") },
    duration: getNumber(el, "duration"),
    side: getString<"start" | "end" | "top" | "bottom">(el, "side"),
    speed: getNumber(el, "speed"),
    spacing: getString(el, "spacing"),
    autoFill: getBoolean(el, "autoFill"),
    pauseOnInteraction: getBoolean(el, "pauseOnInteraction"),
    defaultPaused: getBoolean(el, "defaultPaused"),
    delay: getNumber(el, "delay"),
    loopCount: getNumber(el, "loopCount"),
    reverse: getBoolean(el, "reverse"),
    dir: getDir(el),
  };
}

const MarqueeHook: Hook<object & MarqueeHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & MarqueeHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);

    const zag = new Marquee(el, {
      ...readMarqueeProps(el),
      onPauseChange: (details) => {
        const eventName = getString(el, "onPauseChange");
        if (eventName && this.liveSocket.main.isConnected()) {
          pushEvent(eventName, { id: el.id, paused: details.paused });
        }
        const clientEventName = getString(el, "onPauseChangeClient");
        if (clientEventName) {
          el.dispatchEvent(
            new CustomEvent(clientEventName, {
              bubbles: true,
              detail: { id: el.id, paused: details.paused },
            })
          );
        }
      },
      onLoopComplete: () => {
        const eventName = getString(el, "onLoopComplete");
        if (eventName && this.liveSocket.main.isConnected()) {
          pushEvent(eventName, { id: el.id });
        }
        const clientEventName = getString(el, "onLoopCompleteClient");
        if (clientEventName) {
          el.dispatchEvent(
            new CustomEvent(clientEventName, { bubbles: true, detail: { id: el.id } })
          );
        }
      },
      onComplete: () => {
        const eventName = getString(el, "onComplete");
        if (eventName && this.liveSocket.main.isConnected()) {
          pushEvent(eventName, { id: el.id });
        }
        const clientEventName = getString(el, "onCompleteClient");
        if (clientEventName) {
          el.dispatchEvent(
            new CustomEvent(clientEventName, { bubbles: true, detail: { id: el.id } })
          );
        }
      },
    } as Props);

    zag.buildDom();
    zag.init();

    this.marquee = zag;

    this.onPause = () => zag.api.pause();
    this.onResume = () => zag.api.resume();
    this.onTogglePause = () => zag.api.togglePause();

    el.addEventListener("corex:marquee:pause", this.onPause);
    el.addEventListener("corex:marquee:resume", this.onResume);
    el.addEventListener("corex:marquee:toggle-pause", this.onTogglePause);

    this.handlers = [];
    this.handlers.push(
      this.handleEvent("marquee_pause", (payload: unknown) => {
        if (!idMatches(el.id, readPayloadId(payload))) return;
        zag.api.pause();
      })
    );
    this.handlers.push(
      this.handleEvent("marquee_resume", (payload: unknown) => {
        if (!idMatches(el.id, readPayloadId(payload))) return;
        zag.api.resume();
      })
    );
    this.handlers.push(
      this.handleEvent("marquee_toggle_pause", (payload: unknown) => {
        if (!idMatches(el.id, readPayloadId(payload))) return;
        zag.api.togglePause();
      })
    );
  },

  updated(this: object & HookInterface<HTMLElement> & MarqueeHookState) {
    const zag = this.marquee;
    if (!zag) return;
    zag.updateProps(readMarqueeProps(this.el) as Partial<Props>);
    zag.ensureDom();
  },

  destroyed(this: object & HookInterface<HTMLElement> & MarqueeHookState) {
    if (this.onPause) this.el.removeEventListener("corex:marquee:pause", this.onPause);
    if (this.onResume) this.el.removeEventListener("corex:marquee:resume", this.onResume);
    if (this.onTogglePause)
      this.el.removeEventListener("corex:marquee:toggle-pause", this.onTogglePause);
    if (this.handlers) {
      for (const h of this.handlers) this.removeHandleEvent(h);
    }
    this.marquee?.destroy();
  },
};

export { MarqueeHook as Marquee };
