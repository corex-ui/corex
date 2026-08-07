import { Marquee } from "../components/marquee";
import type { Props } from "@zag-js/marquee";
import { getBoolean, getDir, getNumber, getString } from "../lib/util";
import { idMatches, readPayloadId } from "../lib/respond-to";
import { createZagLiveHook } from "../lib/zag-live-hook";

type MarqueeHookState = {
  marquee?: Marquee;
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

const MarqueeHook = createZagLiveHook<MarqueeHookState, Marquee>({
  key: "marquee",
  mount(hook, { dom, server }) {
    const el = hook.el;
    const pushEvent = hook.pushEvent.bind(hook);

    const zag = new Marquee(el, {
      ...readMarqueeProps(el),
      onPauseChange: (details) => {
        const eventName = getString(el, "onPauseChange");
        if (eventName && hook.liveSocket.main.isConnected()) {
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
        if (eventName && hook.liveSocket.main.isConnected()) {
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
        if (eventName && hook.liveSocket.main.isConnected()) {
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

    dom.add("corex:marquee:pause", () => zag.api.pause());
    dom.add("corex:marquee:resume", () => zag.api.resume());
    dom.add("corex:marquee:toggle-pause", () => zag.api.togglePause());

    server.add("marquee_pause", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.pause();
    });

    server.add("marquee_resume", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.resume();
    });

    server.add("marquee_toggle_pause", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.togglePause();
    });

    return zag;
  },

  update(hook, zag) {
    zag.updateProps(readMarqueeProps(hook.el) as Partial<Props>);
  },
});

export { MarqueeHook as Marquee };
