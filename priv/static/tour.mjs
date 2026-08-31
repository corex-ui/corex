import {
  mergeProps
} from "./chunks/chunk-BEC4QQ5D.mjs";
import {
  trapFocus
} from "./chunks/chunk-VAIEEUKU.mjs";
import {
  toPx
} from "./chunks/chunk-AJX2XHOK.mjs";
import {
  getPlacement,
  getPlacementSide,
  getPlacementStyles
} from "./chunks/chunk-7DTCDTRW.mjs";
import {
  trackDismissableBranch
} from "./chunks/chunk-4ATAXYH3.mjs";
import {
  trackInteractOutside
} from "./chunks/chunk-AVGG6QG4.mjs";
import {
  idMatches,
  readPayloadId
} from "./chunks/chunk-EAQ6WQNO.mjs";
import {
  createAnatomy
} from "./chunks/chunk-YMOPD357.mjs";
import {
  Component,
  VanillaMachine,
  canPushEvent,
  contains,
  createGuards,
  createMachine,
  createZagLiveHook,
  dataAttr,
  getComputedStyle as getComputedStyle2,
  getDir,
  getString,
  getWindow,
  isEqual,
  isHTMLElement,
  isString,
  mergeWithDefault,
  nextIndex,
  prevIndex,
  raf,
  safeParseJson,
  setStyleProperty,
  warn
} from "./chunks/chunk-R62PCG6O.mjs";

// ../node_modules/.pnpm/@zag-js+tour@1.43.3/node_modules/@zag-js/tour/dist/tour.anatomy.mjs
var anatomy = createAnatomy("tour").parts(
  "content",
  "actionTrigger",
  "closeTrigger",
  "progressText",
  "title",
  "description",
  "positioner",
  "arrow",
  "arrowTip",
  "backdrop",
  "spotlight"
);
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+tour@1.43.3/node_modules/@zag-js/tour/dist/tour.dom.mjs
var getPositionerId = (ctx) => ctx.ids?.positioner ?? `tour-positioner-${ctx.id}`;
var getContentId = (ctx) => ctx.ids?.content ?? `tour-content-${ctx.id}`;
var getTitleId = (ctx) => ctx.ids?.title ?? `tour-title-${ctx.id}`;
var getDescriptionId = (ctx) => ctx.ids?.description ?? `tour-desc-${ctx.id}`;
var getArrowId = (ctx) => ctx.ids?.arrow ?? `tour-arrow-${ctx.id}`;
var getBackdropId = (ctx) => ctx.ids?.backdrop ?? `tour-backdrop-${ctx.id}`;
var getContentEl = (ctx) => ctx.getById(getContentId(ctx));
var getPositionerEl = (ctx) => ctx.getById(getPositionerId(ctx));
function syncZIndex(scope) {
  const restores = [];
  const cancel = raf(() => {
    const contentEl = getContentEl(scope);
    if (!contentEl) return;
    const zIndex = getComputedStyle2(contentEl).zIndex;
    if (!zIndex || zIndex === "auto") return;
    const positionerEl = getPositionerEl(scope);
    if (!positionerEl) return;
    restores.push(
      setStyleProperty(positionerEl, "--z-index", zIndex),
      setStyleProperty(positionerEl, "z-index", "var(--z-index)")
    );
  });
  return () => {
    cancel();
    restores.forEach((restore) => restore());
  };
}

// ../node_modules/.pnpm/@zag-js+tour@1.43.3/node_modules/@zag-js/tour/dist/utils/clip-path.mjs
function getClipPath(options) {
  const {
    radius = 0,
    rootSize: { width: w, height: h },
    rect: { width, height, x, y },
    enabled = true
  } = options;
  if (!enabled) return "";
  const {
    topLeft = 0,
    topRight = 0,
    bottomRight = 0,
    bottomLeft = 0
  } = typeof radius === "number" ? { topLeft: radius, topRight: radius, bottomRight: radius, bottomLeft: radius } : radius;
  return `M${w},${h}  H0  V0  H${w}  V${h}  Z  M${x + topLeft},${y}  a${topLeft},${topLeft},0,0,0-${topLeft},${topLeft}  V${height + y - bottomLeft}  a${bottomLeft},${bottomLeft},0,0,0,${bottomLeft},${bottomLeft}  H${width + x - bottomRight}  a${bottomRight},${bottomRight},0,0,0,${bottomRight}-${bottomRight}  V${y + topRight}  a${topRight},${topRight},0,0,0-${topRight}-${topRight}  Z`;
}

// ../node_modules/.pnpm/@zag-js+tour@1.43.3/node_modules/@zag-js/tour/dist/utils/step.mjs
var isTooltipStep = (step) => {
  return step?.type === "tooltip";
};
var isDialogStep = (step) => {
  return step?.type === "dialog";
};
var isWaitStep = (step) => {
  return step?.type === "wait";
};
var getEffectiveSteps = (steps) => {
  return steps.filter((step) => step.type !== "wait");
};
var getProgress = (steps, stepIndex) => {
  const effectiveLength = getEffectiveSteps(steps).length;
  return (stepIndex + 1) / effectiveLength;
};
var getEffectiveStepIndex = (steps, stepId) => {
  const effectiveSteps = getEffectiveSteps(steps);
  return findStepIndex(effectiveSteps, stepId);
};
var isTooltipPlacement = (placement) => {
  return placement != null && placement != "center";
};
var normalizeStep = (step) => {
  if (step.type === "floating") {
    return { backdrop: false, arrow: false, placement: "bottom-end", ...step };
  }
  if (step.target == null || step.type === "dialog") {
    return { type: "dialog", placement: "center", backdrop: true, ...step };
  }
  if (!step.type || step.type === "tooltip") {
    return { type: "tooltip", arrow: true, backdrop: true, ...step };
  }
  return step;
};
var findStep = (steps, id) => {
  const res = id != null ? steps.find((step) => step.id === id) : null;
  return res ? normalizeStep(res) : null;
};
var findStepIndex = (steps, id) => {
  return id != null ? steps.findIndex((step) => step.id === id) : -1;
};

// ../node_modules/.pnpm/@zag-js+tour@1.43.3/node_modules/@zag-js/tour/dist/tour.connect.mjs
var defaultTranslations = {
  nextStep: "next step",
  prevStep: "previous step",
  close: "close tour",
  progressText: ({ current, total }) => `${current + 1} of ${total}`,
  skip: "skip tour"
};
function connect(service, normalize) {
  const { state, context, computed, send, prop, scope } = service;
  const translations = mergeWithDefault(defaultTranslations, prop("translations"));
  const open = state.hasTag("open");
  const steps = Array.from(context.get("steps"));
  const stepIndex = computed("stepIndex");
  const step = computed("step");
  const hasTarget = typeof step?.target?.() !== "undefined";
  const hasNextStep = computed("hasNextStep");
  const hasPrevStep = computed("hasPrevStep");
  const firstStep = computed("isFirstStep");
  const lastStep = computed("isLastStep");
  const placement = context.get("currentPlacement");
  const placementSide = isTooltipPlacement(placement) ? getPlacementSide(placement) : void 0;
  const targetRect = context.get("targetRect");
  const floatingOffset = context.get("floatingOffset");
  const tooltipPositioned = isTooltipStep(step) && floatingOffset != null;
  const popperStyles = getPlacementStyles({
    strategy: "absolute",
    placement: tooltipPositioned && isTooltipPlacement(placement) ? placement : void 0
  });
  const clipPath = getClipPath({
    enabled: isTooltipStep(step),
    rect: targetRect,
    rootSize: context.get("boundarySize"),
    radius: prop("spotlightRadius")
  });
  const actionMap = {
    next() {
      send({ type: "STEP.NEXT", src: "actionTrigger" });
    },
    prev() {
      send({ type: "STEP.PREV", src: "actionTrigger" });
    },
    dismiss() {
      send({ type: "DISMISS", src: "actionTrigger" });
    },
    skip() {
      send({ type: "SKIP", src: "actionTrigger" });
    },
    goto(id) {
      send({ type: "STEP.SET", value: id, src: "actionTrigger" });
    }
  };
  return {
    open,
    totalSteps: steps.length,
    stepIndex,
    step,
    hasNextStep,
    hasPrevStep,
    firstStep,
    lastStep,
    addStep(step2) {
      const next = steps.concat(step2);
      send({ type: "STEPS.SET", value: next, src: "addStep" });
    },
    removeStep(id) {
      const next = steps.filter((step2) => step2.id !== id);
      send({ type: "STEPS.SET", value: next, src: "removeStep" });
    },
    updateStep(id, stepOverrides) {
      const next = steps.map((step2) => step2.id === id ? mergeProps(step2, stepOverrides) : step2);
      send({ type: "STEPS.SET", value: next, src: "updateStep" });
    },
    setSteps(steps2) {
      send({ type: "STEPS.SET", value: steps2, src: "setSteps" });
    },
    setStep(id) {
      send({ type: "STEP.SET", value: id });
    },
    start(id) {
      send({ type: "START", value: id });
    },
    isValidStep(id) {
      return steps.some((step2) => step2.id === id);
    },
    isCurrentStep(id) {
      return Boolean(step?.id === id);
    },
    next() {
      send({ type: "STEP.NEXT" });
    },
    prev() {
      send({ type: "STEP.PREV" });
    },
    getProgressPercent() {
      const index = getEffectiveStepIndex(steps, step?.id);
      const total = getEffectiveSteps(steps).length;
      return (index + 1) / total * 100;
    },
    getProgressText() {
      const index = getEffectiveStepIndex(steps, step?.id);
      const total = getEffectiveSteps(steps).length;
      const details = { current: index, total };
      return translations.progressText(details);
    },
    getBackdropProps() {
      return normalize.element({
        ...parts.backdrop.attrs,
        id: getBackdropId(scope),
        dir: prop("dir"),
        hidden: !open,
        "data-state": open ? "open" : "closed",
        "data-type": step?.type,
        style: {
          "--tour-layer": 0,
          clipPath: isTooltipStep(step) ? `path("${clipPath}")` : void 0,
          position: isDialogStep(step) ? "fixed" : "absolute",
          inset: "0",
          willChange: isTooltipStep(step) ? "clip-path" : void 0
        }
      });
    },
    getSpotlightProps() {
      return normalize.element({
        ...parts.spotlight.attrs,
        hidden: !open || !step?.target?.(),
        style: {
          "--tour-layer": 1,
          "--spotlight-x": toPx(targetRect.x),
          "--spotlight-y": toPx(targetRect.y),
          "--spotlight-width": toPx(targetRect.width),
          "--spotlight-height": toPx(targetRect.height),
          position: "absolute",
          width: "var(--spotlight-width)",
          height: "var(--spotlight-height)",
          left: "var(--spotlight-x)",
          top: "var(--spotlight-y)",
          borderRadius: toPx(prop("spotlightRadius")),
          pointerEvents: "none"
        }
      });
    },
    getProgressTextProps() {
      return normalize.element({
        ...parts.progressText.attrs
      });
    },
    getPositionerProps() {
      return normalize.element({
        ...parts.positioner.attrs,
        dir: prop("dir"),
        id: getPositionerId(scope),
        "data-type": step?.type,
        "data-placement": placement,
        "data-side": placementSide,
        style: {
          "--tour-layer": 2,
          ...isTooltipStep(step) && {
            ...popperStyles.floating,
            ...floatingOffset && {
              "--x": toPx(floatingOffset.x),
              "--y": toPx(floatingOffset.y)
            },
            "--z-index": "calc(var(--tour-layer) + var(--tour-z-index))"
          },
          ...!open && { pointerEvents: "none" }
        }
      });
    },
    getArrowProps() {
      return normalize.element({
        id: getArrowId(scope),
        ...parts.arrow.attrs,
        dir: prop("dir"),
        hidden: !tooltipPositioned,
        style: tooltipPositioned ? popperStyles.arrow : void 0,
        opacity: hasTarget ? void 0 : 0
      });
    },
    getArrowTipProps() {
      return normalize.element({
        ...parts.arrowTip.attrs,
        dir: prop("dir"),
        style: popperStyles.arrowTip
      });
    },
    getContentProps() {
      return normalize.element({
        ...parts.content.attrs,
        id: getContentId(scope),
        dir: prop("dir"),
        role: "alertdialog",
        "aria-modal": "true",
        "aria-live": "polite",
        "aria-atomic": "true",
        hidden: !open,
        "data-state": open ? "open" : "closed",
        "data-type": step?.type,
        "data-placement": placement,
        "data-side": placementSide,
        "data-step": step?.id,
        "aria-labelledby": getTitleId(scope),
        "aria-describedby": getDescriptionId(scope),
        tabIndex: -1,
        onKeyDown(event) {
          if (event.defaultPrevented) return;
          if (!prop("keyboardNavigation")) return;
          const isRtl = prop("dir") === "rtl";
          switch (event.key) {
            case "ArrowRight":
              if (!hasNextStep) return;
              send({ type: isRtl ? "STEP.PREV" : "STEP.NEXT", src: "keydown" });
              break;
            case "ArrowLeft":
              if (!hasPrevStep) return;
              send({ type: isRtl ? "STEP.NEXT" : "STEP.PREV", src: "keydown" });
              break;
            default:
              break;
          }
        }
      });
    },
    getTitleProps() {
      return normalize.element({
        ...parts.title.attrs,
        id: getTitleId(scope),
        "data-placement": hasTarget ? placement : "center",
        "data-side": hasTarget ? placementSide : void 0
      });
    },
    getDescriptionProps() {
      return normalize.element({
        ...parts.description.attrs,
        id: getDescriptionId(scope),
        "data-placement": hasTarget ? placement : "center",
        "data-side": hasTarget ? placementSide : void 0
      });
    },
    getCloseTriggerProps() {
      return normalize.button({
        ...parts.closeTrigger.attrs,
        type: "button",
        "data-type": step?.type,
        "aria-label": translations.close,
        onClick: actionMap.dismiss
      });
    },
    getActionTriggerProps(props) {
      const { action, attrs } = props.action;
      let actionProps = {};
      switch (action) {
        case "next":
          actionProps = {
            "data-type": "next",
            disabled: !hasNextStep,
            "data-disabled": dataAttr(!hasNextStep),
            "aria-label": translations.nextStep,
            onClick: actionMap.next
          };
          break;
        case "prev":
          actionProps = {
            "data-type": "prev",
            disabled: !hasPrevStep,
            "data-disabled": dataAttr(!hasPrevStep),
            "aria-label": translations.prevStep,
            onClick: actionMap.prev
          };
          break;
        case "dismiss":
          actionProps = {
            "data-type": "close",
            "aria-label": translations.close,
            onClick: actionMap.dismiss
          };
          break;
        case "skip":
          actionProps = {
            "data-type": "skip",
            "aria-label": translations.skip,
            onClick: actionMap.skip
          };
          break;
        default:
          actionProps = {
            "data-type": "custom",
            onClick() {
              if (typeof action === "function") {
                action(actionMap);
              }
            }
          };
          break;
      }
      return normalize.button({
        ...parts.actionTrigger.attrs,
        type: "button",
        ...attrs,
        ...actionProps
      });
    }
  };
}

// ../node_modules/.pnpm/@zag-js+tour@1.43.3/node_modules/@zag-js/tour/dist/utils/rect.mjs
function getFrameElement(win) {
  return win.parent && Object.getPrototypeOf(win.parent) ? win.frameElement : null;
}
var normalizeEventPoint = (event) => {
  let clientX = event.clientX;
  let clientY = event.clientY;
  let win = event.view || window;
  let frame = getFrameElement(win);
  while (frame) {
    const iframeRect = frame.getBoundingClientRect();
    const css = getComputedStyle(frame);
    const left = iframeRect.left + (frame.clientLeft + parseFloat(css.paddingLeft));
    const top = iframeRect.top + (frame.clientTop + parseFloat(css.paddingTop));
    clientX += left;
    clientY += top;
    win = getWindow(frame);
    frame = getFrameElement(win);
  }
  return { clientX, clientY };
};
function isEventInRect(rect, event) {
  const { clientX, clientY } = normalizeEventPoint(event);
  return rect.y <= clientY && clientY <= rect.y + rect.height && rect.x <= clientX && clientX <= rect.x + rect.width;
}
function offset(r, i) {
  const dx = i.x || 0;
  const dy = i.y || 0;
  return {
    x: r.x - dx,
    y: r.y - dy,
    width: r.width + dx + dx,
    height: r.height + dy + dy
  };
}

// ../node_modules/.pnpm/@zag-js+tour@1.43.3/node_modules/@zag-js/tour/dist/tour.machine.mjs
var { and } = createGuards();
var machine = createMachine({
  props({ props }) {
    return {
      preventInteraction: false,
      closeOnInteractOutside: true,
      closeOnEscape: true,
      keyboardNavigation: true,
      spotlightOffset: { x: 10, y: 10 },
      spotlightRadius: 4,
      ...props
    };
  },
  initialState() {
    return "tourInactive";
  },
  context({ prop, bindable, getContext }) {
    return {
      steps: bindable(() => ({
        defaultValue: prop("steps") ?? [],
        onChange(value) {
          prop("onStepsChange")?.({ steps: value });
        }
      })),
      stepId: bindable(() => ({
        defaultValue: prop("stepId"),
        sync: true,
        onChange(value) {
          const context = getContext();
          const steps = context.get("steps");
          const stepIndex = findStepIndex(steps, value);
          const progress = getProgress(steps, stepIndex);
          const complete = stepIndex == steps.length - 1;
          prop("onStepChange")?.({ stepId: value, stepIndex, totalSteps: steps.length, complete, progress });
        }
      })),
      resolvedTarget: bindable(() => ({
        sync: true,
        defaultValue: null
      })),
      targetRect: bindable(() => ({
        defaultValue: { width: 0, height: 0, x: 0, y: 0 }
      })),
      boundarySize: bindable(() => ({
        defaultValue: { width: 0, height: 0 }
      })),
      currentPlacement: bindable(() => ({
        defaultValue: void 0
      })),
      floatingOffset: bindable(() => ({
        defaultValue: null
      }))
    };
  },
  computed: {
    stepIndex: ({ context }) => findStepIndex(context.get("steps"), context.get("stepId")),
    step: ({ context }) => findStep(context.get("steps"), context.get("stepId")),
    hasNextStep: ({ context, computed }) => computed("stepIndex") < context.get("steps").length - 1,
    hasPrevStep: ({ computed }) => computed("stepIndex") > 0,
    isFirstStep: ({ computed }) => computed("stepIndex") === 0,
    isLastStep: ({ context, computed }) => computed("stepIndex") === context.get("steps").length - 1,
    progress: ({ context, computed }) => {
      const effectiveLength = getEffectiveSteps(context.get("steps")).length;
      return (computed("stepIndex") + 1) / effectiveLength;
    }
  },
  // Watch for external stepId changes (via sync: true bindable).
  // Internal changes set _internalChange flag to skip this.
  watch({ track, context, refs, send }) {
    track([() => context.get("stepId")], () => {
      if (refs.get("_internalChange")) {
        refs.set("_internalChange", false);
        return;
      }
      const step = findStep(context.get("steps"), context.get("stepId"));
      context.set("resolvedTarget", step?.target?.() ?? null);
      syncTargetAttrsFromContext({ context, refs });
      queueMicrotask(() => {
        send({ type: "STEP.CHANGED" });
      });
    });
  },
  effects: ["trackBoundarySize"],
  exit: ["cleanupAll"],
  on: {
    "STEPS.SET": {
      actions: ["setSteps", "validateSteps"]
    },
    // External step change (from watch): cleans up previous effect
    "STEP.CHANGED": [
      {
        guard: and("isValidStep", "hasResolvedTarget"),
        target: "running.scrolling",
        reenter: true,
        actions: ["cleanupStepEffect"]
      },
      {
        guard: and("isValidStep", "hasTarget"),
        target: "running.resolving",
        reenter: true,
        actions: ["cleanupStepEffect"]
      },
      {
        guard: and("isValidStep", "isWaitingStep"),
        target: "running.waiting",
        reenter: true,
        actions: ["cleanupStepEffect"]
      },
      {
        guard: "isValidStep",
        target: "running.active",
        reenter: true,
        actions: ["cleanupStepEffect"]
      }
    ],
    // Internal step change (from performStepTransition/show): no effect cleanup
    // because performStepTransition already cleaned up the previous effect
    "STEP.ROUTE": [
      {
        guard: and("isValidStep", "hasResolvedTarget"),
        target: "running.scrolling",
        reenter: true
      },
      {
        guard: and("isValidStep", "hasTarget"),
        target: "running.resolving",
        reenter: true
      },
      {
        guard: and("isValidStep", "isWaitingStep"),
        target: "running.waiting",
        reenter: true
      },
      {
        guard: "isValidStep",
        target: "running.active",
        reenter: true
      }
    ]
  },
  states: {
    tourInactive: {
      tags: ["closed"],
      entry: ["validateSteps"],
      on: {
        START: {
          actions: ["clearStep", "setInitialStep", "invokeOnStart"]
        }
      }
    },
    running: {
      initial: "resolving",
      on: {
        "STEP.SET": {
          actions: ["setStep"]
        },
        "STEP.NEXT": {
          actions: ["setNextStep"]
        },
        "STEP.PREV": {
          actions: ["setPrevStep"]
        },
        DISMISS: [
          {
            guard: "isLastStep",
            target: "tourInactive",
            actions: ["cleanupAll", "invokeOnDismiss", "invokeOnComplete"]
          },
          {
            target: "tourInactive",
            actions: ["cleanupAll", "invokeOnDismiss"]
          }
        ],
        SKIP: {
          target: "tourInactive",
          actions: ["cleanupAll", "invokeOnSkip"]
        }
      },
      states: {
        resolving: {
          tags: ["closed"],
          effects: ["waitForTarget", "waitForTargetTimeout"],
          on: {
            "TARGET.NOT_FOUND": {
              target: "tourInactive",
              actions: ["invokeOnNotFound", "clearStep"]
            },
            "TARGET.RESOLVED": {
              target: "scrolling",
              actions: ["setResolvedTarget"]
            }
          }
        },
        scrolling: {
          tags: ["open"],
          entry: ["scrollToTarget"],
          effects: [
            "waitForScrollEnd",
            "trapFocus",
            "trackPlacement",
            "trackDismissableBranch",
            "trackInteractOutside",
            "trackEscapeKeydown"
          ],
          on: {
            "SCROLL.END": {
              target: "active"
            }
          }
        },
        waiting: {
          tags: ["closed"]
        },
        active: {
          tags: ["open"],
          effects: [
            "trapFocus",
            "trackPlacement",
            "trackDismissableBranch",
            "trackInteractOutside",
            "trackEscapeKeydown"
          ]
        }
      }
    }
  },
  implementations: {
    guards: {
      isLastStep: ({ computed, context }) => computed("stepIndex") === context.get("steps").length - 1,
      isValidStep: ({ context }) => context.get("stepId") != null,
      hasTarget: ({ computed }) => computed("step")?.target != null,
      hasResolvedTarget: ({ context }) => context.get("resolvedTarget") != null,
      isWaitingStep: ({ computed }) => computed("step")?.type === "wait"
    },
    actions: {
      scrollToTarget({ context }) {
        const node = context.get("resolvedTarget");
        node?.scrollIntoView({ behavior: "instant", block: "nearest", inline: "nearest" });
      },
      setSteps(params) {
        const { event, context } = params;
        context.set("steps", event.value);
      },
      setStep(params) {
        const { event } = params;
        if (event.value == null) return;
        const steps = params.context.get("steps");
        const idx = isString(event.value) ? findStepIndex(steps, event.value) : event.value;
        performStepTransition(params, idx);
      },
      clearStep({ context, refs }) {
        refs.get("_targetCleanup")?.();
        refs.set("_targetCleanup", void 0);
        context.set("targetRect", { width: 0, height: 0, x: 0, y: 0 });
        context.set("resolvedTarget", null);
        context.set("currentPlacement", void 0);
        context.set("floatingOffset", null);
        refs.set("_internalChange", true);
        context.set("stepId", null);
      },
      setInitialStep(params) {
        const { context, event } = params;
        const steps = context.get("steps");
        if (steps.length === 0) return;
        const idx = isString(event.value) ? findStepIndex(steps, event.value) : event.value ?? 0;
        performStepTransition(params, idx);
      },
      setNextStep(params) {
        const steps = params.context.get("steps");
        const idx = nextIndex(steps, params.computed("stepIndex"));
        performStepTransition(params, idx);
      },
      setPrevStep(params) {
        const steps = params.context.get("steps");
        const idx = prevIndex(steps, params.computed("stepIndex"));
        performStepTransition(params, idx);
      },
      invokeOnStart({ prop, context, computed }) {
        prop("onStatusChange")?.({
          status: "started",
          stepId: context.get("stepId"),
          stepIndex: computed("stepIndex")
        });
      },
      invokeOnDismiss({ prop, context, computed }) {
        prop("onStatusChange")?.({
          status: "dismissed",
          stepId: context.get("stepId"),
          stepIndex: computed("stepIndex")
        });
      },
      invokeOnComplete({ prop, context, computed }) {
        prop("onStatusChange")?.({
          status: "completed",
          stepId: context.get("stepId"),
          stepIndex: computed("stepIndex")
        });
      },
      invokeOnSkip({ prop, context, computed }) {
        prop("onStatusChange")?.({
          status: "skipped",
          stepId: context.get("stepId"),
          stepIndex: computed("stepIndex")
        });
      },
      invokeOnNotFound({ prop, context, computed }) {
        prop("onStatusChange")?.({
          status: "not-found",
          stepId: context.get("stepId"),
          stepIndex: computed("stepIndex")
        });
      },
      setResolvedTarget({ context, event, computed }) {
        const node = event.node ?? computed("step")?.target?.();
        context.set("resolvedTarget", node ?? null);
      },
      cleanupAll({ refs }) {
        refs.get("_targetCleanup")?.();
        refs.set("_targetCleanup", void 0);
        refs.set("_prevTarget", void 0);
        refs.get("_effectCleanup")?.();
        refs.set("_effectCleanup", void 0);
      },
      cleanupStepEffect({ refs }) {
        refs.get("_effectCleanup")?.();
        refs.set("_effectCleanup", void 0);
      },
      validateSteps({ context }) {
        const ids = /* @__PURE__ */ new Set();
        context.get("steps").forEach((step) => {
          if (ids.has(step.id)) {
            throw new Error(`[zag-js/tour] Duplicate step id: ${step.id}`);
          }
          if (step.target == null && step.type == null) {
            throw new Error(`[zag-js/tour] Step ${step.id} has no target or type. At least one of those is required.`);
          }
          ids.add(step.id);
        });
      }
    },
    effects: {
      waitForScrollEnd({ send }) {
        const id = setTimeout(() => {
          send({ type: "SCROLL.END" });
        }, 100);
        return () => clearTimeout(id);
      },
      waitForTargetTimeout({ send }) {
        const id = setTimeout(() => {
          send({ type: "TARGET.NOT_FOUND" });
        }, 3e3);
        return () => clearTimeout(id);
      },
      waitForTarget({ scope, computed, send }) {
        const step = computed("step");
        if (!step) return;
        const targetEl = step.target;
        const win = scope.getWin();
        const rootNode = scope.getRootNode();
        const observer = new win.MutationObserver(() => {
          const node = targetEl?.();
          if (node) {
            send({ type: "TARGET.RESOLVED", node });
            observer.disconnect();
          }
        });
        observer.observe(rootNode, {
          childList: true,
          subtree: true,
          characterData: true
        });
        return () => {
          observer.disconnect();
        };
      },
      trackBoundarySize({ context, scope }) {
        const win = scope.getWin();
        const doc = scope.getDoc();
        const onResize = () => {
          const width = visualViewport?.width ?? win.innerWidth;
          const height = doc.documentElement.scrollHeight;
          context.set("boundarySize", { width, height });
        };
        onResize();
        const viewport = win.visualViewport ?? win;
        viewport.addEventListener("resize", onResize);
        return () => viewport.removeEventListener("resize", onResize);
      },
      trackEscapeKeydown({ scope, send, prop }) {
        if (!prop("closeOnEscape")) return;
        const doc = scope.getDoc();
        const onKeyDown = (event) => {
          if (event.key === "Escape") {
            event.preventDefault();
            event.stopPropagation();
            send({ type: "DISMISS", src: "esc" });
          }
        };
        doc.addEventListener("keydown", onKeyDown, true);
        return () => {
          doc.removeEventListener("keydown", onKeyDown, true);
        };
      },
      trackInteractOutside({ context, computed, scope, send, prop }) {
        const step = computed("step");
        if (step == null) return;
        const contentEl = () => getContentEl(scope);
        return trackInteractOutside(contentEl, {
          defer: true,
          exclude(target) {
            return contains(step.target?.(), target);
          },
          onFocusOutside(event) {
            prop("onFocusOutside")?.(event);
            if (!prop("closeOnInteractOutside")) {
              event.preventDefault();
            }
          },
          onPointerDownOutside(event) {
            prop("onPointerDownOutside")?.(event);
            const isWithin = isEventInRect(context.get("targetRect"), event.detail.originalEvent);
            if (isWithin) {
              event.preventDefault();
              return;
            }
            if (!prop("closeOnInteractOutside")) {
              event.preventDefault();
            }
          },
          onInteractOutside(event) {
            prop("onInteractOutside")?.(event);
            if (event.defaultPrevented) return;
            send({ type: "DISMISS", src: "interact-outside" });
          }
        });
      },
      trackDismissableBranch({ computed, scope }) {
        const step = computed("step");
        if (step == null) return;
        const contentEl = () => getContentEl(scope);
        return trackDismissableBranch(contentEl, { defer: true });
      },
      trapFocus({ computed, scope, context }) {
        const step = computed("step");
        if (step == null) return;
        const contentEl = () => getContentEl(scope);
        const targetEl = () => context.get("resolvedTarget");
        return trapFocus([contentEl, targetEl], {
          escapeDeactivates: false,
          allowOutsideClick: true,
          preventScroll: true,
          returnFocusOnDeactivate: false,
          getShadowRoot: true
        });
      },
      trackPlacement({ context, computed, scope, prop }) {
        const step = computed("step");
        if (step == null) return;
        context.set("currentPlacement", step.placement ?? "bottom");
        if (isDialogStep(step)) {
          context.set("floatingOffset", null);
          return syncZIndex(scope);
        }
        if (!isTooltipStep(step)) {
          context.set("floatingOffset", null);
          return;
        }
        const positionerEl = () => getPositionerEl(scope);
        return getPlacement(context.get("resolvedTarget"), positionerEl, {
          defer: true,
          placement: step.placement ?? "bottom",
          strategy: "absolute",
          gutter: 10,
          offset: step.offset,
          restoreStyles: false,
          applyStyles: false,
          getAnchorRect(el) {
            if (!isHTMLElement(el)) return null;
            const rect = el.getBoundingClientRect();
            return offset(rect, prop("spotlightOffset"));
          },
          onComplete(data) {
            const { rects } = data.middlewareData;
            context.set("currentPlacement", data.placement);
            context.set("targetRect", rects.reference);
            context.set("floatingOffset", { x: data.x, y: data.y });
          }
        });
      }
    }
  }
});
function syncTargetAttrsFromContext(params) {
  const { context, refs, prop } = params;
  const targetEl = context.get("resolvedTarget");
  const prevTarget = refs.get("_prevTarget");
  if (targetEl !== prevTarget) {
    refs.get("_targetCleanup")?.();
    refs.set("_targetCleanup", void 0);
  }
  if (!targetEl) {
    refs.set("_prevTarget", null);
    return;
  }
  if (targetEl === prevTarget) return;
  if (prop?.("preventInteraction")) targetEl.inert = true;
  targetEl.setAttribute("data-tour-highlighted", "");
  refs.set("_targetCleanup", () => {
    if (prop?.("preventInteraction")) targetEl.inert = false;
    targetEl.removeAttribute("data-tour-highlighted");
  });
  refs.set("_prevTarget", targetEl);
}
function performStepTransition(params, idx) {
  const { context, refs, send } = params;
  const steps = context.get("steps");
  const step = steps[idx];
  if (!step) {
    refs.set("_internalChange", true);
    context.set("stepId", null);
    return;
  }
  if (isEqual(context.get("stepId"), step.id)) {
    return;
  }
  refs.get("_effectCleanup")?.();
  refs.set("_effectCleanup", void 0);
  refs.get("_targetCleanup")?.();
  refs.set("_targetCleanup", void 0);
  if (step.effect) {
    executeStepEffect(params, step, idx);
    return;
  }
  const resolvedTarget = step.target?.() ?? null;
  context.set("resolvedTarget", resolvedTarget);
  refs.set("_internalChange", true);
  context.set("stepId", step.id);
  syncTargetAttrsFromContext(params);
  send({ type: "STEP.ROUTE" });
}
function createEffectUtilities(params, step, idx) {
  const { context, computed, refs, send } = params;
  const steps = context.get("steps");
  return {
    show: () => {
      const resolvedTarget = step.target?.() ?? null;
      context.set("resolvedTarget", resolvedTarget);
      refs.set("_internalChange", true);
      context.set("stepId", step.id);
      syncTargetAttrsFromContext(params);
      send({ type: "STEP.ROUTE" });
    },
    update: (data) => {
      context.set("steps", (prev) => prev.map((s, i) => i === idx ? { ...s, ...data } : s));
    },
    next: () => {
      const nextIdx = nextIndex(steps, computed("stepIndex"));
      performStepTransition(params, nextIdx);
    },
    goto: (id) => {
      const targetIdx = findStepIndex(steps, id);
      if (targetIdx === -1) {
        warn(`[zag-js/tour] Step with id "${id}" not found`);
        return;
      }
      performStepTransition(params, targetIdx);
    },
    dismiss: () => {
      send({ type: "DISMISS", src: "step-effect" });
    },
    target: step.target
  };
}
function executeStepEffect(params, step, idx) {
  const { refs } = params;
  const utilities = createEffectUtilities(params, step, idx);
  let cleanup;
  try {
    cleanup = step.effect(utilities);
  } catch (error) {
    console.error(error);
    return;
  }
  refs.set("_effectCleanup", cleanup);
  if (isWaitStep(step)) {
    utilities.show();
  }
}

// components/tour.ts
var TOUR_Z = "2147483000";
function ensureVisualViewport() {
  if (typeof window === "undefined" || window.visualViewport) return;
  Object.defineProperty(window, "visualViewport", {
    configurable: true,
    value: {
      width: window.innerWidth,
      height: window.innerHeight,
      offsetLeft: 0,
      offsetTop: 0,
      pageLeft: 0,
      pageTop: 0,
      scale: 1,
      addEventListener() {
      },
      removeEventListener() {
      }
    }
  });
}
var Tour = class extends Component {
  portalled = /* @__PURE__ */ new Set();
  get overlayRootId() {
    return `corex-tour-overlay-${this.el.id}`;
  }
  initMachine(props) {
    ensureVisualViewport();
    return new VanillaMachine(machine, props);
  }
  initApi() {
    return this.zagConnect(connect);
  }
  unportal() {
    const root = this.el.querySelector('[data-scope="tour"][data-part="root"]') ?? this.el;
    for (const node of this.portalled) {
      if (node.isConnected) root.appendChild(node);
    }
    this.portalled.clear();
    document.getElementById(this.overlayRootId)?.remove();
  }
  render() {
    this.portalOverlay();
    const backdrop = this.part("backdrop");
    if (backdrop) this.spreadProps(backdrop, this.api.getBackdropProps());
    const spotlight = this.part("spotlight");
    if (spotlight) this.spreadProps(spotlight, this.api.getSpotlightProps());
    const positioner = this.part("positioner");
    if (positioner) {
      this.spreadProps(positioner, this.api.getPositionerProps());
      positioner.hidden = !this.api.open;
      if (this.api.open) {
        positioner.style.removeProperty("transform");
        positioner.removeAttribute("aria-hidden");
        positioner.style.pointerEvents = "auto";
      }
    }
    const overlay = document.getElementById(this.overlayRootId);
    if (overlay) overlay.style.pointerEvents = this.api.open ? "auto" : "none";
    const content = this.part("content");
    if (content) {
      this.spreadProps(content, this.api.getContentProps());
      const title = content.querySelector('[data-scope="tour"][data-part="title"]');
      if (title) {
        this.spreadProps(title, this.api.getTitleProps());
        title.textContent = String(this.api.step?.title ?? "");
      }
      const description = content.querySelector(
        '[data-scope="tour"][data-part="description"]'
      );
      if (description) {
        this.spreadProps(description, this.api.getDescriptionProps());
        description.textContent = String(this.api.step?.description ?? "");
      }
      const progressText = content.querySelector(
        '[data-scope="tour"][data-part="progress-text"]'
      );
      if (progressText) {
        this.spreadProps(progressText, this.api.getProgressTextProps());
        progressText.textContent = this.api.getProgressText();
      }
      this.renderActions(content, this.api.step);
    }
    const close = this.part("close-trigger");
    if (close) this.spreadProps(close, this.api.getCloseTriggerProps());
  }
  part(name) {
    const fromHost = this.el.querySelector(
      `[data-scope="tour"][data-part="${name}"]`
    );
    if (fromHost) return fromHost;
    for (const node of this.portalled) {
      if (node.dataset.part === name) return node;
      const nested = node.querySelector(`[data-scope="tour"][data-part="${name}"]`);
      if (nested) return nested;
    }
    return null;
  }
  overlayHost() {
    let host = document.getElementById(this.overlayRootId);
    if (!host) {
      host = document.createElement("div");
      host.id = this.overlayRootId;
      host.setAttribute("data-corex-tour-overlay", "");
      host.style.cssText = `position:fixed;inset:0;z-index:${TOUR_Z};pointer-events:none;`;
      document.body.appendChild(host);
    }
    return host;
  }
  portalOverlay() {
    const host = this.overlayHost();
    const parts2 = ["backdrop", "spotlight", "positioner"];
    for (const part of parts2) {
      const node = this.el.querySelector(`[data-scope="tour"][data-part="${part}"]`) ?? [...this.portalled].find((el) => el.dataset.part === part);
      if (!node) continue;
      if (node.parentElement !== host) {
        host.appendChild(node);
        this.portalled.add(node);
      }
      node.style.setProperty("z-index", TOUR_Z);
    }
  }
  renderActions(content, step) {
    const host = content.querySelector('[data-scope="tour"][data-part="actions"]') ?? (() => {
      const el = document.createElement("div");
      el.dataset.scope = "tour";
      el.dataset.part = "actions";
      content.appendChild(el);
      return el;
    })();
    host.replaceChildren();
    for (const action of step?.actions ?? []) {
      const button = document.createElement("button");
      button.type = "button";
      button.dataset.scope = "tour";
      button.dataset.part = "action-trigger";
      this.spreadProps(button, this.api.getActionTriggerProps({ action }));
      button.textContent = action.label;
      host.appendChild(button);
    }
  }
};

// hooks/tour.ts
var DEFAULT_STEPS = [
  {
    id: "welcome",
    type: "dialog",
    title: "Welcome to Corex",
    description: "This overlay stays closed on the server. Start it after JavaScript hydrates.",
    actions: [{ label: "Next", action: "next" }]
  },
  {
    id: "docs",
    type: "tooltip",
    title: "Docs",
    description: "Open Anatomy, API, Events, and Style from the sidebar.",
    target: "#tour-target-nav",
    actions: [
      { label: "Back", action: "prev" },
      { label: "Next", action: "next" }
    ]
  },
  {
    id: "playground",
    type: "tooltip",
    title: "Playground",
    description: "Try interactions live, then copy the anatomy into your app.",
    target: "#tour-target-playground",
    actions: [
      { label: "Back", action: "prev" },
      { label: "Next", action: "next" }
    ]
  },
  {
    id: "done",
    type: "dialog",
    title: "You\u2019re set",
    description: "That\u2019s the tour. Close when you\u2019re ready to explore.",
    actions: [{ label: "Finish", action: "dismiss" }]
  }
];
function hydrateSteps(steps) {
  return steps.map((step) => {
    const target = step.target;
    if (typeof target === "string") {
      const selector = target;
      return { ...step, target: () => document.querySelector(selector) };
    }
    return step;
  });
}
function tourProps(el, hook) {
  const onStepChange = (details) => {
    const eventName = getString(el, "onStepChange") ?? getString(el, "onValueChange");
    if (eventName && canPushEvent(hook.liveSocket)) {
      hook.pushEvent(eventName, { id: el.id, value: details.stepId, step: details.stepIndex });
    }
    const client = getString(el, "onStepChangeClient") ?? getString(el, "onValueChangeClient");
    if (client) {
      el.dispatchEvent(
        new CustomEvent(client, {
          bubbles: true,
          detail: { id: el.id, value: details.stepId, step: details.stepIndex }
        })
      );
    }
  };
  return {
    id: el.id,
    dir: getDir(el),
    steps: hydrateSteps(safeParseJson(el.dataset.steps, DEFAULT_STEPS)),
    onStepChange
  };
}
var TourHook = createZagLiveHook({
  key: "tour",
  mount(hook, { dom, server }) {
    const tour = new Tour(hook.el, tourProps(hook.el, hook));
    dom.add("corex:tour:start", () => {
      tour.api.start();
    });
    server.add("tour_start", (payload) => {
      if (!idMatches(hook.el.id, readPayloadId(payload))) return;
      tour.api.start();
    });
    return tour;
  },
  update(hook, inst) {
    inst.updateProps(tourProps(hook.el, hook));
  },
  destroy(_hook, inst) {
    inst.unportal();
  }
});
export {
  TourHook as Tour
};
