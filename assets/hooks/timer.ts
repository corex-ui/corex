import { Timer } from "../components/timer";
import type { Api, Props, TickDetails } from "@zag-js/timer";
import type { Orientation } from "@zag-js/types";

import { getString, getBoolean, getNumber, getDir, canPushEvent } from "../lib/util";
import { createZagLiveHook } from "../lib/zag-live-hook";
import {
  emitResponse,
  idMatches,
  readPayloadId,
  parseRespondTo,
  type RespondTo,
} from "../lib/respond-to";

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
  lastStartMsRaw?: string | undefined;
  lastTargetMsRaw?: string | undefined;
  lastCountdownRaw?: string | undefined;
  lastIntervalRaw?: string | undefined;
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

function readIdentityRaw(el: HTMLElement) {
  return {
    startMs: el.dataset.startMs,
    targetMs: el.dataset.targetMs,
    countdown: el.dataset.countdown,
    interval: el.dataset.interval,
  };
}

function buildTimerCallbacks(
  el: HTMLElement,
  pushEvent: (name: string, payload: Record<string, unknown>) => void,
  canPush: () => boolean
): Pick<Props, "onTick" | "onComplete"> {
  return {
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
  };
}

function syncTimerDir(el: HTMLElement): void {
  // Zag timer has no dir prop — HTML dir drives RTL flex/layout.
  const dir = getDir(el);
  if (dir) {
    el.setAttribute("dir", dir);
    el.querySelectorAll<HTMLElement>("[data-scope='timer']").forEach((node) => {
      node.setAttribute("dir", dir);
    });
  } else {
    el.removeAttribute("dir");
    el.querySelectorAll<HTMLElement>("[data-scope='timer'][dir]").forEach((node) => {
      node.removeAttribute("dir");
    });
  }
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
    orientation: getString<Orientation>(el, "orientation"),
    translations: parseTimerTranslations(el),
    ...buildTimerCallbacks(el, pushEvent, canPush),
  } as Props;
}

const TimerHook = createZagLiveHook<TimerHookState, Timer>({
  key: "timer",
  mount(hook, { dom, server }) {
    const el = hook.el;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);

    const identity = readIdentityRaw(el);
    hook.lastStartMsRaw = identity.startMs;
    hook.lastTargetMsRaw = identity.targetMs;
    hook.lastCountdownRaw = identity.countdown;
    hook.lastIntervalRaw = identity.interval;

    const zag = new Timer(el, buildTimerProps(el, pushEvent, canPush));
    syncTimerDir(el);

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

    dom.add<CustomEvent>("corex:timer:start", () => {
      zag.api.start();
    });

    dom.add<CustomEvent>("corex:timer:pause", () => {
      zag.api.pause();
    });

    dom.add<CustomEvent>("corex:timer:resume", () => {
      zag.api.resume();
    });

    dom.add<CustomEvent>("corex:timer:reset", () => {
      zag.api.reset();
    });

    dom.add<CustomEvent>("corex:timer:restart", () => {
      zag.api.restart();
    });

    dom.add<CustomEvent>("corex:timer:state", (event) => {
      emitState(parseRespondTo(event.detail));
    });

    server.add("timer_start", (payload: { id?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.start();
    });

    server.add("timer_pause", (payload: { id?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.pause();
    });

    server.add("timer_resume", (payload: { id?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.resume();
    });

    server.add("timer_reset", (payload: { id?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.reset();
    });

    server.add("timer_restart", (payload: { id?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.restart();
    });

    server.add("timer_state", (payload: { id?: string; respond_to?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitState(parseRespondTo(payload));
    });

    return zag;
  },

  update(hook, zag) {
    const el = hook.el;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);

    const patch: Partial<Props> = {
      id: el.id,
      orientation: getString<Orientation>(el, "orientation"),
      translations: parseTimerTranslations(el),
      ...buildTimerCallbacks(el, pushEvent, canPush),
    };

    const startMsRaw = el.dataset.startMs;
    if (startMsRaw !== hook.lastStartMsRaw) {
      patch.startMs = getNumber(el, "startMs");
      hook.lastStartMsRaw = startMsRaw;
    }

    const targetMsRaw = el.dataset.targetMs;
    if (targetMsRaw !== hook.lastTargetMsRaw) {
      patch.targetMs = getNumber(el, "targetMs");
      hook.lastTargetMsRaw = targetMsRaw;
    }

    const countdownRaw = el.dataset.countdown;
    if (countdownRaw !== hook.lastCountdownRaw) {
      patch.countdown = getBoolean(el, "countdown");
      hook.lastCountdownRaw = countdownRaw;
    }

    const intervalRaw = el.dataset.interval;
    if (intervalRaw !== hook.lastIntervalRaw) {
      patch.interval = getNumber(el, "interval");
      hook.lastIntervalRaw = intervalRaw;
    }

    // Zag timer has no dir prop — sync HTML dir from data-dir for RTL layout.
    syncTimerDir(el);

    zag.updateProps(patch);
  },
});

export { TimerHook as Timer };
