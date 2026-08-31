import {
  memo
} from "./chunks/chunk-G4YHNHIV.mjs";
import {
  isValueWithinRange
} from "./chunks/chunk-AJX2XHOK.mjs";
import {
  createAnatomy
} from "./chunks/chunk-YMOPD357.mjs";
import {
  Component,
  VanillaMachine,
  canPushEvent,
  createMachine,
  createZagLiveHook,
  dataAttr,
  fromLength,
  getBoolean,
  getDir,
  getNumber,
  getString
} from "./chunks/chunk-R62PCG6O.mjs";

// ../node_modules/.pnpm/@zag-js+steps@1.43.3/node_modules/@zag-js/steps/dist/steps.anatomy.mjs
var anatomy = createAnatomy("steps").parts(
  "root",
  "list",
  "item",
  "trigger",
  "indicator",
  "separator",
  "content",
  "nextTrigger",
  "prevTrigger",
  "progress"
);
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+steps@1.43.3/node_modules/@zag-js/steps/dist/steps.dom.mjs
var getRootId = (ctx) => ctx.ids?.root ?? `steps:${ctx.id}`;
var getListId = (ctx) => ctx.ids?.list ?? `steps:${ctx.id}:list`;
var getTriggerId = (ctx, index) => ctx.ids?.triggerId?.(index) ?? `steps:${ctx.id}:trigger:${index}`;
var getContentId = (ctx, index) => ctx.ids?.contentId?.(index) ?? `steps:${ctx.id}:content:${index}`;

// ../node_modules/.pnpm/@zag-js+steps@1.43.3/node_modules/@zag-js/steps/dist/steps.connect.mjs
function connect(service, normalize) {
  const { context, send, computed, prop, scope } = service;
  const step = context.get("step");
  const count = prop("count");
  const percent = computed("percent");
  const hasNextStep = computed("hasNextStep");
  const hasPrevStep = computed("hasPrevStep");
  const isStepValid = (index) => {
    return prop("isStepValid")?.(index) ?? true;
  };
  const isStepSkippable = (index) => {
    return prop("isStepSkippable")?.(index) ?? false;
  };
  const getItemState = (props) => ({
    triggerId: getTriggerId(scope, props.index),
    contentId: getContentId(scope, props.index),
    current: props.index === step,
    completed: props.index < step,
    incomplete: props.index > step,
    index: props.index,
    first: props.index === 0,
    last: props.index === count - 1,
    skippable: isStepSkippable(props.index),
    isValid: () => isStepValid(props.index)
  });
  const goToNextStep = () => {
    send({ type: "STEP.NEXT", src: "next.trigger.click" });
  };
  const goToPrevStep = () => {
    send({ type: "STEP.PREV", src: "prev.trigger.click" });
  };
  const resetStep = () => {
    send({ type: "STEP.RESET", src: "reset.trigger.click" });
  };
  const setStep = (value) => {
    send({ type: "STEP.SET", value, src: "api.setValue" });
  };
  return {
    value: step,
    count,
    percent,
    hasNextStep,
    hasPrevStep,
    isCompleted: computed("completed"),
    isStepValid,
    isStepSkippable,
    goToNextStep,
    goToPrevStep,
    resetStep,
    getItemState,
    setStep,
    getRootProps() {
      return normalize.element({
        ...parts.root.attrs,
        id: getRootId(scope),
        dir: prop("dir"),
        "data-orientation": prop("orientation"),
        style: {
          "--percent": `${percent}%`
        }
      });
    },
    getListProps() {
      const arr = fromLength(count);
      const triggerIds = arr.map((_, index) => getTriggerId(scope, index));
      return normalize.element({
        ...parts.list.attrs,
        dir: prop("dir"),
        id: getListId(scope),
        role: "tablist",
        "aria-owns": triggerIds.join(" "),
        "aria-orientation": prop("orientation"),
        "data-orientation": prop("orientation")
      });
    },
    getItemProps(props) {
      const itemState = getItemState(props);
      return normalize.element({
        ...parts.item.attrs,
        dir: prop("dir"),
        "aria-current": itemState.current ? "step" : void 0,
        "data-orientation": prop("orientation"),
        "data-skippable": dataAttr(itemState.skippable)
      });
    },
    getTriggerProps(props) {
      const itemState = getItemState(props);
      return normalize.button({
        ...parts.trigger.attrs,
        id: itemState.triggerId,
        role: "tab",
        type: "button",
        dir: prop("dir"),
        tabIndex: !prop("linear") || itemState.current ? 0 : -1,
        "aria-selected": itemState.current,
        "aria-controls": itemState.contentId,
        "data-state": itemState.current ? "open" : "closed",
        "data-orientation": prop("orientation"),
        "data-complete": dataAttr(itemState.completed),
        "data-current": dataAttr(itemState.current),
        "data-incomplete": dataAttr(itemState.incomplete),
        onClick(event) {
          if (event.defaultPrevented) return;
          if (prop("linear")) return;
          send({ type: "STEP.SET", value: props.index, src: "trigger.click" });
        }
      });
    },
    getContentProps(props) {
      const itemState = getItemState(props);
      return normalize.element({
        ...parts.content.attrs,
        dir: prop("dir"),
        id: itemState.contentId,
        role: "tabpanel",
        tabIndex: 0,
        hidden: !itemState.current,
        "data-state": itemState.current ? "open" : "closed",
        "data-orientation": prop("orientation"),
        "aria-labelledby": itemState.triggerId
      });
    },
    getIndicatorProps(props) {
      const itemState = getItemState(props);
      return normalize.element({
        ...parts.indicator.attrs,
        dir: prop("dir"),
        "aria-hidden": true,
        "data-complete": dataAttr(itemState.completed),
        "data-current": dataAttr(itemState.current),
        "data-incomplete": dataAttr(itemState.incomplete)
      });
    },
    getSeparatorProps(props) {
      const itemState = getItemState(props);
      return normalize.element({
        ...parts.separator.attrs,
        dir: prop("dir"),
        "data-orientation": prop("orientation"),
        "data-complete": dataAttr(itemState.completed),
        "data-current": dataAttr(itemState.current),
        "data-incomplete": dataAttr(itemState.incomplete)
      });
    },
    getNextTriggerProps() {
      return normalize.button({
        ...parts.nextTrigger.attrs,
        dir: prop("dir"),
        type: "button",
        disabled: !hasNextStep,
        onClick(event) {
          if (event.defaultPrevented) return;
          goToNextStep();
        }
      });
    },
    getPrevTriggerProps() {
      return normalize.button({
        dir: prop("dir"),
        ...parts.prevTrigger.attrs,
        type: "button",
        disabled: !hasPrevStep,
        onClick(event) {
          if (event.defaultPrevented) return;
          goToPrevStep();
        }
      });
    },
    getProgressProps() {
      return normalize.element({
        dir: prop("dir"),
        ...parts.progress.attrs,
        role: "progressbar",
        "aria-valuenow": percent,
        "aria-valuemin": 0,
        "aria-valuemax": 100,
        "aria-valuetext": `${percent}% complete`,
        "data-complete": dataAttr(percent === 100)
      });
    }
  };
}

// ../node_modules/.pnpm/@zag-js+steps@1.43.3/node_modules/@zag-js/steps/dist/steps.machine.mjs
var machine = createMachine({
  props({ props }) {
    return {
      defaultStep: 0,
      count: 1,
      linear: false,
      orientation: "horizontal",
      ...props
    };
  },
  context({ prop, bindable }) {
    return {
      step: bindable(() => ({
        defaultValue: prop("defaultStep"),
        value: prop("step"),
        onChange(value) {
          prop("onStepChange")?.({ step: value });
          const completed = value == prop("count");
          if (completed) prop("onStepComplete")?.();
        }
      }))
    };
  },
  computed: {
    percent: memo(
      ({ context, prop }) => [context.get("step"), prop("count")],
      ([step, count]) => step / count * 100
    ),
    hasNextStep: ({ context, prop }) => context.get("step") < prop("count"),
    hasPrevStep: ({ context }) => context.get("step") > 0,
    completed: ({ context, prop }) => context.get("step") === prop("count")
  },
  initialState() {
    return "idle";
  },
  entry: ["validateStepIndex"],
  states: {
    idle: {
      on: {
        "STEP.SET": [
          {
            guard: "isValidStepNavigation",
            actions: ["setStep"]
          },
          {
            actions: ["invokeOnStepInvalid"]
          }
        ],
        "STEP.NEXT": [
          {
            guard: "isCurrentStepValid",
            actions: ["goToNextStep"]
          },
          {
            actions: ["invokeOnStepInvalid"]
          }
        ],
        "STEP.PREV": {
          actions: ["goToPrevStep"]
        },
        "STEP.RESET": {
          actions: ["resetStep"]
        }
      }
    }
  },
  implementations: {
    guards: {
      isCurrentStepValid({ context, prop }) {
        const current = context.get("step");
        if (prop("isStepSkippable")?.(current)) return true;
        const isStepValid = prop("isStepValid");
        if (!isStepValid) return true;
        return isStepValid(current);
      },
      isValidStepNavigation({ context, event, prop }) {
        const current = context.get("step");
        if (event.value <= current) return true;
        if (prop("isStepSkippable")?.(current)) return true;
        const isStepValid = prop("isStepValid");
        if (!isStepValid) return true;
        return isStepValid(current);
      }
    },
    actions: {
      goToNextStep({ context, prop }) {
        const count = prop("count");
        context.set("step", Math.min(context.get("step") + 1, count));
      },
      goToPrevStep({ context }) {
        context.set("step", Math.max(context.get("step") - 1, 0));
      },
      resetStep({ context }) {
        context.set("step", 0);
      },
      setStep({ context, event }) {
        context.set("step", event.value);
      },
      validateStepIndex({ context, prop }) {
        validateStepIndex(prop("count"), context.get("step"));
      },
      invokeOnStepInvalid({ context, event, prop }) {
        prop("onStepInvalid")?.({
          step: context.get("step"),
          action: event.type === "STEP.NEXT" ? "next" : "set",
          targetStep: event.value
        });
      }
    }
  }
});
var validateStepIndex = (count, step) => {
  if (!isValueWithinRange(step, 0, count)) {
    throw new RangeError(`[zag-js/steps] step index ${step} is out of bounds`);
  }
};

// components/steps.ts
var Steps = class extends Component {
  initMachine(props) {
    return new VanillaMachine(machine, props);
  }
  initApi() {
    return this.zagConnect(connect);
  }
  render() {
    const root = this.el.querySelector('[data-scope="steps"][data-part="root"]') ?? this.el;
    this.spreadProps(root, this.api.getRootProps());
    const list = this.el.querySelector('[data-scope="steps"][data-part="list"]');
    if (list) {
      this.spreadProps(list, this.api.getListProps());
      list.removeAttribute("role");
      list.removeAttribute("aria-owns");
    }
    this.el.querySelectorAll('[data-scope="steps"][data-part="item"]').forEach((item) => {
      this.spreadProps(item, this.api.getItemProps({ index: Number(item.dataset.index) }));
    });
    this.el.querySelectorAll('[data-scope="steps"][data-part="trigger"]').forEach((el) => {
      this.spreadProps(el, this.api.getTriggerProps({ index: Number(el.dataset.index) }));
      el.removeAttribute("role");
      el.removeAttribute("aria-selected");
    });
    this.el.querySelectorAll('[data-scope="steps"][data-part="indicator"]').forEach((el) => {
      this.spreadProps(el, this.api.getIndicatorProps({ index: Number(el.dataset.index) }));
    });
    this.el.querySelectorAll('[data-scope="steps"][data-part="separator"]').forEach((el) => {
      this.spreadProps(el, this.api.getSeparatorProps({ index: Number(el.dataset.index) }));
    });
    this.el.querySelectorAll('[data-scope="steps"][data-part="content"]').forEach((el) => {
      this.spreadProps(el, this.api.getContentProps({ index: Number(el.dataset.index) }));
      el.removeAttribute("role");
    });
    const next = this.el.querySelector('[data-scope="steps"][data-part="next-trigger"]');
    if (next) this.spreadProps(next, this.api.getNextTriggerProps());
    const prev = this.el.querySelector('[data-scope="steps"][data-part="prev-trigger"]');
    if (prev) this.spreadProps(prev, this.api.getPrevTriggerProps());
  }
};

// hooks/steps.ts
function stepsProps(el, hook) {
  const onStepChange = (details) => {
    const eventName = getString(el, "onStepChange");
    if (eventName && canPushEvent(hook.liveSocket)) {
      hook.pushEvent(eventName, { id: el.id, step: details.step });
    }
    const client = getString(el, "onStepChangeClient");
    if (client) {
      el.dispatchEvent(
        new CustomEvent(client, { bubbles: true, detail: { id: el.id, step: details.step } })
      );
    }
  };
  return {
    id: el.id,
    dir: getDir(el),
    count: getNumber(el, "count") ?? 3,
    defaultStep: getNumber(el, "step"),
    linear: getBoolean(el, "linear"),
    orientation: getString(el, "orientation", ["horizontal", "vertical"]),
    isStepValid: (index) => {
      const content = el.querySelector(
        `[data-scope="steps"][data-part="content"][data-index="${index}"]`
      );
      const gate = content?.querySelector("[data-step-gate]");
      if (!gate) return true;
      if (gate.type === "checkbox" || gate.type === "radio") return gate.checked;
      return gate.value.trim().length > 0;
    },
    onStepChange
  };
}
var StepsHook = createZagLiveHook({
  key: "steps",
  mount(hook) {
    const inst = new Steps(hook.el, stepsProps(hook.el, hook));
    const refresh = () => inst.render();
    hook.el.addEventListener("input", refresh);
    hook.el.addEventListener("change", refresh);
    return inst;
  },
  update(hook, inst) {
    inst.updateProps(stepsProps(hook.el, hook));
  }
});
export {
  StepsHook as Steps
};
