import {
  memo
} from "./chunks/chunk-W6DW6OBY.mjs";
import {
  setRafInterval,
  setRafTimeout
} from "./chunks/chunk-FFJGC56K.mjs";
import {
  clampValue
} from "./chunks/chunk-PE34YET2.mjs";
import {
  Component,
  VanillaMachine,
  canPushEvent,
  createAnatomy,
  createMachine,
  getBoolean,
  getDir,
  getNumber,
  getString,
  getStringList,
  match
} from "./chunks/chunk-XGGASIX4.mjs";

// ../node_modules/.pnpm/@zag-js+timer@1.40.0/node_modules/@zag-js/timer/dist/timer.anatomy.mjs
var anatomy = createAnatomy("timer").parts(
  "root",
  "area",
  "control",
  "item",
  "itemValue",
  "itemLabel",
  "actionTrigger",
  "separator"
);
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+timer@1.40.0/node_modules/@zag-js/timer/dist/timer.dom.mjs
var getRootId = (ctx) => ctx.ids?.root ?? `timer:${ctx.id}:root`;
var getAreaId = (ctx) => ctx.ids?.area ?? `timer:${ctx.id}:area`;

// ../node_modules/.pnpm/@zag-js+timer@1.40.0/node_modules/@zag-js/timer/dist/timer.connect.mjs
var validActions = /* @__PURE__ */ new Set(["start", "pause", "resume", "reset", "restart"]);
function connect(service, normalize) {
  const { state, send, computed, scope, prop } = service;
  const translations = prop("translations");
  const running = state.matches("running");
  const paused = state.matches("paused");
  const time = computed("time");
  const formattedTime = computed("formattedTime");
  const progressPercent = computed("progressPercent");
  return {
    running,
    paused,
    time,
    formattedTime,
    progressPercent,
    start() {
      send({ type: "START" });
    },
    pause() {
      send({ type: "PAUSE" });
    },
    resume() {
      send({ type: "RESUME" });
    },
    reset() {
      send({ type: "RESET" });
    },
    restart() {
      send({ type: "RESTART" });
    },
    getRootProps() {
      return normalize.element({
        id: getRootId(scope),
        ...parts.root.attrs
      });
    },
    getAreaProps() {
      return normalize.element({
        role: "timer",
        id: getAreaId(scope),
        "aria-label": translations.areaLabel?.(time, formattedTime),
        "aria-atomic": true,
        ...parts.area.attrs
      });
    },
    getControlProps() {
      return normalize.element({
        ...parts.control.attrs
      });
    },
    getItemProps(props) {
      const value = time[props.type];
      return normalize.element({
        ...parts.item.attrs,
        "data-type": props.type,
        style: {
          "--value": value
        }
      });
    },
    getItemLabelProps(props) {
      return normalize.element({
        ...parts.itemLabel.attrs,
        "data-type": props.type
      });
    },
    getItemValueProps(props) {
      return normalize.element({
        ...parts.itemValue.attrs,
        "data-type": props.type
      });
    },
    getSeparatorProps() {
      return normalize.element({
        "aria-hidden": true,
        ...parts.separator.attrs
      });
    },
    getActionTriggerProps(props) {
      if (!validActions.has(props.action)) {
        throw new Error(
          `[zag-js] Invalid action: ${props.action}. Must be one of: ${Array.from(validActions).join(", ")}`
        );
      }
      return normalize.button({
        ...parts.actionTrigger.attrs,
        hidden: match(props.action, {
          start: () => running || paused,
          pause: () => !running,
          reset: () => !running && !paused,
          resume: () => !paused,
          restart: () => false
        }),
        type: "button",
        onClick(event) {
          if (event.defaultPrevented) return;
          send({ type: props.action.toUpperCase() });
        }
      });
    }
  };
}

// ../node_modules/.pnpm/@zag-js+timer@1.40.0/node_modules/@zag-js/timer/dist/timer.machine.mjs
var machine = createMachine({
  props({ props }) {
    validateProps(props);
    return {
      interval: 1e3,
      startMs: 0,
      ...props,
      translations: {
        areaLabel: (time, formattedTime) => `${time.days} days ${formattedTime.hours}:${formattedTime.minutes}:${formattedTime.seconds}`,
        ...props.translations
      }
    };
  },
  initialState({ prop }) {
    return prop("autoStart") ? "running" : "idle";
  },
  context({ prop, bindable }) {
    return {
      currentMs: bindable(() => ({
        defaultValue: prop("startMs")
      }))
    };
  },
  watch({ track, send, prop }) {
    track([() => prop("startMs")], () => {
      send({ type: "RESTART" });
    });
  },
  on: {
    RESTART: {
      target: "running:temp",
      actions: ["resetTime"]
    }
  },
  computed: {
    time: ({ context }) => msToTime(context.get("currentMs")),
    formattedTime: ({ computed }) => formatTime(computed("time")),
    progressPercent: memo(
      ({ context, prop }) => [context.get("currentMs"), prop("targetMs"), prop("startMs"), prop("countdown")],
      ([currentMs, targetMs = 0, startMs, countdown]) => {
        const percent = countdown ? toPercent(currentMs, targetMs, startMs) : toPercent(currentMs, startMs, targetMs);
        return clampValue(percent, 0, 1);
      }
    )
  },
  states: {
    idle: {
      on: {
        START: {
          target: "running"
        },
        RESET: {
          actions: ["resetTime"]
        }
      }
    },
    "running:temp": {
      effects: ["waitForNextTick"],
      on: {
        CONTINUE: {
          target: "running"
        }
      }
    },
    running: {
      effects: ["keepTicking"],
      on: {
        PAUSE: {
          target: "paused"
        },
        TICK: [
          {
            target: "idle",
            guard: "hasReachedTarget",
            actions: ["invokeOnComplete"]
          },
          {
            actions: ["updateTime", "invokeOnTick"]
          }
        ],
        RESET: {
          actions: ["resetTime"]
        }
      }
    },
    paused: {
      on: {
        RESUME: {
          target: "running"
        },
        RESET: {
          target: "idle",
          actions: ["resetTime"]
        }
      }
    }
  },
  implementations: {
    effects: {
      keepTicking({ prop, send }) {
        return setRafInterval(({ deltaMs }) => {
          send({ type: "TICK", deltaMs });
        }, prop("interval"));
      },
      waitForNextTick({ send }) {
        return setRafTimeout(() => {
          send({ type: "CONTINUE" });
        }, 0);
      }
    },
    actions: {
      updateTime({ context, prop, event }) {
        const sign = prop("countdown") ? -1 : 1;
        const deltaMs = roundToInterval(event.deltaMs, prop("interval"));
        context.set("currentMs", (prev) => {
          const newValue = prev + sign * deltaMs;
          let targetMs = prop("targetMs");
          if (targetMs == null && prop("countdown")) targetMs = 0;
          if (prop("countdown") && targetMs != null) {
            return Math.max(newValue, targetMs);
          } else if (!prop("countdown") && targetMs != null) {
            return Math.min(newValue, targetMs);
          }
          return newValue;
        });
      },
      resetTime({ context, prop }) {
        let targetMs = prop("targetMs");
        if (targetMs == null && prop("countdown")) targetMs = 0;
        context.set("currentMs", prop("startMs") ?? 0);
      },
      invokeOnTick({ context, prop, computed }) {
        prop("onTick")?.({
          value: context.get("currentMs"),
          time: computed("time"),
          formattedTime: computed("formattedTime")
        });
      },
      invokeOnComplete({ prop }) {
        prop("onComplete")?.();
      }
    },
    guards: {
      hasReachedTarget: ({ context, prop }) => {
        let targetMs = prop("targetMs");
        if (targetMs == null && prop("countdown")) targetMs = 0;
        if (targetMs == null) return false;
        const currentMs = context.get("currentMs");
        return prop("countdown") ? currentMs <= targetMs : currentMs >= targetMs;
      }
    }
  }
});
function msToTime(ms) {
  const time = Math.max(0, ms);
  const milliseconds = time % 1e3;
  const seconds = Math.floor(time / 1e3) % 60;
  const minutes = Math.floor(time / (1e3 * 60)) % 60;
  const hours = Math.floor(time / (1e3 * 60 * 60)) % 24;
  const days = Math.floor(time / (1e3 * 60 * 60 * 24));
  return {
    days,
    hours,
    minutes,
    seconds,
    milliseconds
  };
}
function toPercent(value, minValue, maxValue) {
  const range = maxValue - minValue;
  if (range === 0) return 0;
  return (value - minValue) / range;
}
function padStart(num, size = 2) {
  return num.toString().padStart(size, "0");
}
function roundToInterval(value, interval) {
  return Math.floor(value / interval) * interval;
}
function formatTime(time) {
  const { days, hours, minutes, seconds } = time;
  return {
    days: padStart(days),
    hours: padStart(hours),
    minutes: padStart(minutes),
    seconds: padStart(seconds),
    milliseconds: padStart(time.milliseconds, 3)
  };
}
function validateProps(props) {
  const { startMs, targetMs, countdown, interval } = props;
  if (interval != null && (typeof interval !== "number" || interval <= 0)) {
    throw new Error(`[timer] Invalid interval: ${interval}. Must be a positive number.`);
  }
  if (startMs != null && (typeof startMs !== "number" || startMs < 0)) {
    throw new Error(`[timer] Invalid startMs: ${startMs}. Must be a non-negative number.`);
  }
  if (targetMs != null && (typeof targetMs !== "number" || targetMs < 0)) {
    throw new Error(`[timer] Invalid targetMs: ${targetMs}. Must be a non-negative number.`);
  }
  if (countdown && startMs != null && targetMs != null) {
    if (startMs <= targetMs) {
      throw new Error(
        `[timer] Invalid countdown configuration: startMs (${startMs}) must be greater than targetMs (${targetMs}).`
      );
    }
  }
  if (!countdown && startMs != null && targetMs != null) {
    if (startMs >= targetMs) {
      throw new Error(
        `[timer] Invalid stopwatch configuration: startMs (${startMs}) must be less than targetMs (${targetMs}).`
      );
    }
  }
  if (countdown && targetMs == null && startMs != null && startMs <= 0) {
    throw new Error(
      `[timer] Invalid countdown configuration: startMs (${startMs}) must be greater than 0 when no targetMs is provided.`
    );
  }
}

// components/timer.ts
function collapseStartIndex(vals) {
  const rec = (idx) => {
    if (idx > 2) return idx;
    const restAfter = vals.length - idx;
    if (idx < 3 && vals[idx] === 0 && restAfter > 2) {
      return rec(idx + 1);
    }
    return idx;
  };
  return rec(0);
}
function computeItemHidden(root, time) {
  const types = ["days", "hours", "minutes", "seconds"];
  const vals = [time.days, time.hours, time.minutes, time.seconds].map(Number);
  const segments = getStringList(root, "segments");
  const countdown = root.dataset.countdown === "true";
  const collapseRaw = root.dataset.collapseLeadingZeros;
  if (segments && segments.length > 0) {
    return types.map((t) => !segments.includes(t));
  }
  if (collapseRaw === "false") {
    return [false, false, false, false];
  }
  if (collapseRaw === "true" || collapseRaw !== "false" && countdown) {
    const start = collapseStartIndex(vals);
    return types.map((_, i) => i < start);
  }
  return [false, false, false, false];
}
function applyTimerItemVisibility(root, api) {
  const hidden = computeItemHidden(root, api.time);
  const types = ["days", "hours", "minutes", "seconds"];
  const hostId = root.id;
  types.forEach((type, i) => {
    const segmentEl = root.querySelector(`[data-timer-segment][data-type="${type}"]`);
    if (segmentEl) {
      if (hidden[i]) {
        segmentEl.setAttribute("hidden", "");
      } else {
        segmentEl.removeAttribute("hidden");
      }
    }
    const itemEl = root.querySelector(
      `[data-scope="timer"][data-part="item"][data-type="${type}"]`
    );
    if (itemEl) {
      if (hidden[i]) {
        itemEl.setAttribute("hidden", "");
        itemEl.setAttribute("aria-hidden", "true");
      } else {
        itemEl.removeAttribute("hidden");
        itemEl.setAttribute("aria-hidden", "false");
      }
    }
  });
  for (let k = 0; k < 3; k++) {
    const sepId = `timer:${hostId}:sep:${k}`;
    const sepEl = root.querySelector(`[id="${CSS.escape(sepId)}"]`);
    if (sepEl) {
      if (hidden[k]) {
        sepEl.setAttribute("hidden", "");
      } else {
        sepEl.removeAttribute("hidden");
      }
    }
  }
}
var Timer = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props) {
    return new VanillaMachine(machine, props);
  }
  initApi() {
    return this.zagConnect(connect);
  }
  init = () => {
    this.machine.subscribe(() => {
      this.api = this.initApi();
      this.render();
    });
    try {
      this.machine.start();
      this.api = this.initApi();
      this.render();
    } finally {
      this.el.removeAttribute("data-loading");
    }
  };
  render() {
    const rootEl = this.el.querySelector('[data-scope="timer"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());
    const areaEl = this.el.querySelector('[data-scope="timer"][data-part="area"]');
    if (areaEl) this.spreadProps(areaEl, this.api.getAreaProps());
    const controlEl = this.el.querySelector(
      '[data-scope="timer"][data-part="control"]'
    );
    if (controlEl) this.spreadProps(controlEl, this.api.getControlProps());
    const timeParts = ["days", "hours", "minutes", "seconds"];
    timeParts.forEach((type) => {
      const itemEl = this.el.querySelector(
        `[data-scope="timer"][data-part="item"][data-type="${type}"]`
      );
      if (itemEl) {
        this.spreadProps(itemEl, this.api.getItemProps({ type }));
      }
      const labelEl = this.el.querySelector(
        `[data-scope="timer"][data-part="item-label"][data-type="${type}"]`
      );
      if (labelEl) {
        this.spreadProps(labelEl, this.api.getItemLabelProps({ type }));
      }
    });
    this.el.querySelectorAll('[data-scope="timer"][data-part="separator"]').forEach((separatorEl) => {
      this.spreadProps(separatorEl, this.api.getSeparatorProps());
    });
    const actions = ["start", "pause", "resume", "reset"];
    actions.forEach((action) => {
      const triggerEl = this.el.querySelector(
        `[data-scope="timer"][data-part="action-trigger"][data-action="${action}"]`
      );
      if (triggerEl)
        this.spreadProps(
          triggerEl,
          this.api.getActionTriggerProps({ action })
        );
    });
    applyTimerItemVisibility(this.el, this.api);
  }
};

// hooks/timer.ts
function parseTimerTranslations(el) {
  const raw = el.dataset.translation;
  if (!raw) return void 0;
  try {
    const o = JSON.parse(raw);
    if (typeof o.areaLabel === "string" && o.areaLabel.length > 0) {
      const label = o.areaLabel;
      return { areaLabel: () => label };
    }
  } catch {
    return void 0;
  }
  return void 0;
}
var TimerHook = {
  mounted() {
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
      orientation: getString(el, "orientation"),
      translations: parseTimerTranslations(el),
      onTick: (details) => {
        const eventName = getString(el, "onTick");
        if (eventName && canPushEvent(this.liveSocket)) {
          pushEvent(eventName, {
            value: details.value,
            time: details.time,
            formattedTime: details.formattedTime,
            id: el.id
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
                formattedTime: details.formattedTime
              }
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
              detail: { id: el.id }
            })
          );
        }
      }
    });
    zag.init();
    this.timer = zag;
    this.handlers = [];
  },
  updated() {
    this.timer?.updateProps({
      id: this.el.id,
      countdown: getBoolean(this.el, "countdown"),
      startMs: getNumber(this.el, "startMs"),
      targetMs: getNumber(this.el, "targetMs"),
      autoStart: getBoolean(this.el, "autoStart"),
      interval: getNumber(this.el, "interval"),
      dir: getDir(this.el),
      orientation: getString(this.el, "orientation"),
      translations: parseTimerTranslations(this.el)
    });
  },
  destroyed() {
    if (this.handlers) {
      for (const h of this.handlers) this.removeHandleEvent(h);
    }
    this.timer?.destroy();
  }
};
export {
  TimerHook as Timer
};
