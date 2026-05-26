import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Timer } from "../components/timer";
import type { Api, Props, TickDetails } from "@zag-js/timer";
import type { Orientation } from "@zag-js/types";

import { getString, getBoolean, getNumber, getDir, canPushEvent } from "../lib/util";
import {
  emitResponse,
  idMatches,
  readPayloadId,
  parseRespondTo,
  type RespondTo,
} from "../lib/respond-to";
import { createHookHandleEventRegistry } from "../lib/hook-handlers";
import { createDomEventRegistry } from "../lib/dom-events";

type TimerMachineState = {
  running: boolean;
  paused: boolean;
  progressPercent: number;
  time: Api["time"];
  formattedTime: Api["formattedTime"];
};

function machineState(api: Api): TimerMachineState {
  return {
    running: api.running,
    paused: api.paused,
    progressPercent: api.progressPercent,
    time: api.time,
    formattedTime: api.formattedTime,
  };
}

type TimerHookState = {
  timer?: Timer;
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
};

export function parseTimerTranslations(el: HTMLElement): Props["translations"] {
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

function buildTimerProps(
  el: HTMLElement,
  pushEvent: (name: string, payload: Record<string, unknown>) => void,
  canPush: () => boolean
): Props {
  return {
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
      if (eventName && canPush()) {
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
      if (eventName && canPush()) {
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
  } as Props;
}

const TimerHook: Hook<object & TimerHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & TimerHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);

    const zag = new Timer(el, buildTimerProps(el, pushEvent, canPush));
    zag.init();
    this.timer = zag;

    const emitState = (respondTo: RespondTo) => {
      const snapshot = machineState(zag.api);
      emitResponse({
        respondTo,
        canPushServer: canPush(),
        pushEvent,
        serverEventName: "timer_state_response",
        serverPayload: { id: el.id, ...snapshot },
        el,
        domEventName: "timer-state",
        domDetail: { id: el.id, ...snapshot },
      });
    };

    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;

    domRegistry.add<CustomEvent>("corex:timer:start", () => {
      zag.api.start();
    });

    domRegistry.add<CustomEvent>("corex:timer:pause", () => {
      zag.api.pause();
    });

    domRegistry.add<CustomEvent>("corex:timer:resume", () => {
      zag.api.resume();
    });

    domRegistry.add<CustomEvent>("corex:timer:reset", () => {
      zag.api.reset();
    });

    domRegistry.add<CustomEvent>("corex:timer:restart", () => {
      zag.api.restart();
    });

    domRegistry.add<CustomEvent>("corex:timer:state", (event) => {
      emitState(parseRespondTo(event.detail));
    });

    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;

    registry.add("timer_start", (payload: { id?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.start();
    });

    registry.add("timer_pause", (payload: { id?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.pause();
    });

    registry.add("timer_resume", (payload: { id?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.resume();
    });

    registry.add("timer_reset", (payload: { id?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.reset();
    });

    registry.add("timer_restart", (payload: { id?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.restart();
    });

    registry.add("timer_state", (payload: { id?: string; respond_to?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitState(parseRespondTo(payload));
    });
  },

  updated(this: object & HookInterface<HTMLElement> & TimerHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);

    this.timer?.updateProps(buildTimerProps(el, pushEvent, canPush) as Partial<Props>);
  },

  destroyed(this: object & HookInterface<HTMLElement> & TimerHookState) {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.timer?.destroy();
  },
};

export { TimerHook as Timer };
