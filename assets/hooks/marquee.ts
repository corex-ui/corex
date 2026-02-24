import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { Marquee } from "../components/marquee";
import type { Props } from "@zag-js/marquee";
import { getString, getBoolean, getNumber, getDir } from "../lib/util";

type MarqueeHookState = {
  marquee?: Marquee;
  handlers?: Array<CallbackRef>;
  onPause?: (event: Event) => void;
  onResume?: (event: Event) => void;
  onTogglePause?: (event: Event) => void;
};

const MarqueeHook: Hook<object & MarqueeHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & MarqueeHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);

    const ariaLabel = getString(el, "ariaLabel") ?? `Marquee: ${el.id}`;

    const zag = new Marquee(el, {
      id: el.id,
      translations: { root: ariaLabel },
      duration: getNumber(el, "duration") ?? 20,
      side:
        getString<"start" | "end" | "top" | "bottom">(el, "side", [
          "start",
          "end",
          "top",
          "bottom",
        ]) ?? "end",
      speed: getNumber(el, "speed") ?? 50,
      spacing: getString(el, "spacing") ?? "1rem",
      autoFill: getBoolean(el, "autoFill"),
      pauseOnInteraction: getBoolean(el, "pauseOnInteraction"),
      defaultPaused: getBoolean(el, "defaultPaused"),
      delay: getNumber(el, "delay") ?? 0,
      loopCount: getNumber(el, "loopCount") ?? 0,
      reverse: getBoolean(el, "reverse"),
      dir: getDir(el),
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
    zag.init();
    this.marquee = zag;

    this.onPause = () => zag.api.pause();
    this.onResume = () => zag.api.resume();
    this.onTogglePause = () => zag.api.togglePause();

    el.addEventListener("phx:marquee:pause", this.onPause);
    el.addEventListener("phx:marquee:resume", this.onResume);
    el.addEventListener("phx:marquee:toggle-pause", this.onTogglePause);

    this.handlers = [];
    this.handlers.push(
      this.handleEvent("marquee_pause", (payload: { marquee_id?: string }) => {
        const targetId = payload.marquee_id;
        if (targetId && el.id !== targetId && el.id !== `marquee:${targetId}`) return;
        zag.api.pause();
      })
    );
    this.handlers.push(
      this.handleEvent("marquee_resume", (payload: { marquee_id?: string }) => {
        const targetId = payload.marquee_id;
        if (targetId && el.id !== targetId && el.id !== `marquee:${targetId}`) return;
        zag.api.resume();
      })
    );
    this.handlers.push(
      this.handleEvent("marquee_toggle_pause", (payload: { marquee_id?: string }) => {
        const targetId = payload.marquee_id;
        if (targetId && el.id !== targetId && el.id !== `marquee:${targetId}`) return;
        zag.api.togglePause();
      })
    );
  },

  updated(this: object & HookInterface<HTMLElement> & MarqueeHookState) {
    const ariaLabel = getString(this.el, "ariaLabel") ?? `Marquee: ${this.el.id}`;

    this.marquee?.updateProps({
      id: this.el.id,
      translations: { root: ariaLabel },
      duration: getNumber(this.el, "duration") ?? 20,
      side:
        getString<"start" | "end" | "top" | "bottom">(this.el, "side", [
          "start",
          "end",
          "top",
          "bottom",
        ]) ?? "end",
      speed: getNumber(this.el, "speed") ?? 50,
      spacing: getString(this.el, "spacing") ?? "1rem",
      autoFill: getBoolean(this.el, "autoFill"),
      pauseOnInteraction: getBoolean(this.el, "pauseOnInteraction"),
      defaultPaused: getBoolean(this.el, "defaultPaused"),
      delay: getNumber(this.el, "delay") ?? 0,
      loopCount: getNumber(this.el, "loopCount") ?? 0,
      reverse: getBoolean(this.el, "reverse"),
      dir: getDir(this.el),
    } as Partial<Props>);
  },

  destroyed(this: object & HookInterface<HTMLElement> & MarqueeHookState) {
    if (this.onPause) this.el.removeEventListener("phx:marquee:pause", this.onPause);
    if (this.onResume) this.el.removeEventListener("phx:marquee:resume", this.onResume);
    if (this.onTogglePause)
      this.el.removeEventListener("phx:marquee:toggle-pause", this.onTogglePause);
    if (this.handlers) {
      for (const h of this.handlers) this.removeHandleEvent(h);
    }
    this.marquee?.destroy();
  },
};

export { MarqueeHook as Marquee };
