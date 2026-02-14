import {
  Component,
  VanillaMachine,
  clampValue,
  createAnatomy,
  createMachine,
  createProps,
  createSplitProps,
  getBoolean,
  getNumber,
  getString,
  match,
  memo,
  normalizeProps,
  setRafInterval,
  setRafTimeout
} from "./chunk-IXOYOLUJ.mjs";

// ../node_modules/.pnpm/@zag-js+timer@1.33.1/node_modules/@zag-js/timer/dist/index.mjs
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
var getRootId = (ctx) => ctx.ids?.root ?? `timer:${ctx.id}:root`;
var getAreaId = (ctx) => ctx.ids?.area ?? `timer:${ctx.id}:area`;
var validActions = /* @__PURE__ */ new Set(["start", "pause", "resume", "reset", "restart"]);
function connect(service, normalize) {
  const { state, send, computed, scope } = service;
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
        "aria-label": `${time.days} days ${formattedTime.hours}:${formattedTime.minutes}:${formattedTime.seconds}`,
        "aria-atomic": true,
        ...parts.area.attrs
      });
    },
    getControlProps() {
      return normalize.element({
        ...parts.control.attrs
      });
    },
    getItemProps(props2) {
      const value = time[props2.type];
      return normalize.element({
        ...parts.item.attrs,
        "data-type": props2.type,
        style: {
          "--value": value
        }
      });
    },
    getItemLabelProps(props2) {
      return normalize.element({
        ...parts.itemLabel.attrs,
        "data-type": props2.type
      });
    },
    getItemValueProps(props2) {
      return normalize.element({
        ...parts.itemValue.attrs,
        "data-type": props2.type
      });
    },
    getSeparatorProps() {
      return normalize.element({
        "aria-hidden": true,
        ...parts.separator.attrs
      });
    },
    getActionTriggerProps(props2) {
      if (!validActions.has(props2.action)) {
        throw new Error(
          `[zag-js] Invalid action: ${props2.action}. Must be one of: ${Array.from(validActions).join(", ")}`
        );
      }
      return normalize.button({
        ...parts.actionTrigger.attrs,
        hidden: match(props2.action, {
          start: () => running || paused,
          pause: () => !running,
          reset: () => !running && !paused,
          resume: () => !paused,
          restart: () => false
        }),
        type: "button",
        onClick(event) {
          if (event.defaultPrevented) return;
          send({ type: props2.action.toUpperCase() });
        }
      });
    }
  };
}
var machine = createMachine({
  props({ props: props2 }) {
    validateProps(props2);
    return {
      interval: 1e3,
      startMs: 0,
      ...props2
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
function validateProps(props2) {
  const { startMs, targetMs, countdown, interval } = props2;
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
var props = createProps()([
  "autoStart",
  "countdown",
  "getRootNode",
  "id",
  "ids",
  "interval",
  "onComplete",
  "onTick",
  "startMs",
  "targetMs"
]);
var splitProps = createSplitProps(props);

// components/timer.ts
var Timer = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props2) {
    return new VanillaMachine(machine, props2);
  }
  initApi() {
    return connect(this.machine.service, normalizeProps);
  }
  render() {
    const rootEl = this.el.querySelector('[data-scope="timer"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());
    const areaEl = this.el.querySelector('[data-scope="timer"][data-part="area"]');
    if (areaEl) this.spreadProps(areaEl, this.api.getAreaProps());
    const controlEl = this.el.querySelector(
      '[data-scope="timer"][data-part="control"]'
    );
    if (controlEl) this.spreadProps(controlEl, this.api.getControlProps());
    const timeParts = ["days", "hours", "minutes", "seconds", "milliseconds"];
    timeParts.forEach((type) => {
      const itemEl = this.el.querySelector(
        `[data-scope="timer"][data-part="item"][data-type="${type}"]`
      );
      if (itemEl) this.spreadProps(itemEl, this.api.getItemProps({ type }));
      const valueEl = this.el.querySelector(
        `[data-scope="timer"][data-part="item-value"][data-type="${type}"]`
      );
      if (valueEl) this.spreadProps(valueEl, this.api.getItemValueProps({ type }));
      const labelEl = this.el.querySelector(
        `[data-scope="timer"][data-part="item-label"][data-type="${type}"]`
      );
      if (labelEl) this.spreadProps(labelEl, this.api.getItemLabelProps({ type }));
    });
    const separatorEl = this.el.querySelector(
      '[data-scope="timer"][data-part="separator"]'
    );
    if (separatorEl) this.spreadProps(separatorEl, this.api.getSeparatorProps());
    const actions = ["start", "pause", "resume", "reset", "restart"];
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
  }
};

// hooks/timer.ts
var TimerHook = {
  mounted() {
    const el = this.el;
    const zag = new Timer(el, {
      id: el.id,
      countdown: getBoolean(el, "countdown"),
      startMs: getNumber(el, "startMs"),
      targetMs: getNumber(el, "targetMs"),
      autoStart: getBoolean(el, "autoStart"),
      interval: getNumber(el, "interval") ?? 1e3,
      onTick: (details) => {
        const eventName = getString(el, "onTick");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, {
            value: details.value,
            time: details.time,
            formattedTime: details.formattedTime,
            id: el.id
          });
        }
      },
      onComplete: () => {
        const eventName = getString(el, "onComplete");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, { id: el.id });
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
      interval: getNumber(this.el, "interval") ?? 1e3
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
