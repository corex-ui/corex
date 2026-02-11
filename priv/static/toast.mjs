import {
  trackDismissableBranch
} from "./chunk-N455IPSM.mjs";
import {
  AnimationFrame,
  Component,
  MAX_Z_INDEX,
  VanillaMachine,
  addDomEvent,
  compact,
  contains,
  createAnatomy,
  createGuards,
  createMachine,
  dataAttr,
  ensureProps,
  generateId,
  getBoolean,
  getNumber,
  getString,
  normalizeProps,
  raf,
  runIfFn,
  setRafTimeout,
  setup,
  uuid,
  warn
} from "./chunk-AG6DB4N6.mjs";

// ../node_modules/.pnpm/@zag-js+toast@1.33.1/node_modules/@zag-js/toast/dist/index.mjs
var anatomy = createAnatomy("toast").parts(
  "group",
  "root",
  "title",
  "description",
  "actionTrigger",
  "closeTrigger"
);
var parts = anatomy.build();
var getRegionId = (placement) => `toast-group:${placement}`;
var getRegionEl = (ctx, placement) => ctx.getById(`toast-group:${placement}`);
var getRootId = (ctx) => `toast:${ctx.id}`;
var getRootEl = (ctx) => ctx.getById(getRootId(ctx));
var getTitleId = (ctx) => `toast:${ctx.id}:title`;
var getDescriptionId = (ctx) => `toast:${ctx.id}:description`;
var getCloseTriggerId = (ctx) => `toast${ctx.id}:close`;
var defaultTimeouts = {
  info: 5e3,
  error: 5e3,
  success: 2e3,
  loading: Infinity,
  DEFAULT: 5e3
};
function getToastDuration(duration, type) {
  return duration ?? defaultTimeouts[type] ?? defaultTimeouts.DEFAULT;
}
var getOffsets = (offsets) => typeof offsets === "string" ? { left: offsets, right: offsets, bottom: offsets, top: offsets } : offsets;
function getGroupPlacementStyle(service, placement) {
  const { prop, computed, context } = service;
  const { offsets, gap } = prop("store").attrs;
  const heights = context.get("heights");
  const computedOffset = getOffsets(offsets);
  const rtl = prop("dir") === "rtl";
  const computedPlacement = placement.replace("-start", rtl ? "-right" : "-left").replace("-end", rtl ? "-left" : "-right");
  const isRighty = computedPlacement.includes("right");
  const isLefty = computedPlacement.includes("left");
  const styles = {
    position: "fixed",
    pointerEvents: computed("count") > 0 ? void 0 : "none",
    display: "flex",
    flexDirection: "column",
    "--gap": `${gap}px`,
    "--first-height": `${heights[0]?.height || 0}px`,
    "--viewport-offset-left": computedOffset.left,
    "--viewport-offset-right": computedOffset.right,
    "--viewport-offset-top": computedOffset.top,
    "--viewport-offset-bottom": computedOffset.bottom,
    zIndex: MAX_Z_INDEX
  };
  let alignItems = "center";
  if (isRighty) alignItems = "flex-end";
  if (isLefty) alignItems = "flex-start";
  styles.alignItems = alignItems;
  if (computedPlacement.includes("top")) {
    const offset = computedOffset.top;
    styles.top = `max(env(safe-area-inset-top, 0px), ${offset})`;
  }
  if (computedPlacement.includes("bottom")) {
    const offset = computedOffset.bottom;
    styles.bottom = `max(env(safe-area-inset-bottom, 0px), ${offset})`;
  }
  if (!computedPlacement.includes("left")) {
    const offset = computedOffset.right;
    styles.insetInlineEnd = `calc(env(safe-area-inset-right, 0px) + ${offset})`;
  }
  if (!computedPlacement.includes("right")) {
    const offset = computedOffset.left;
    styles.insetInlineStart = `calc(env(safe-area-inset-left, 0px) + ${offset})`;
  }
  return styles;
}
function getPlacementStyle(service, visible) {
  const { prop, context, computed } = service;
  const parent = prop("parent");
  const placement = parent.computed("placement");
  const { gap } = parent.prop("store").attrs;
  const [side] = placement.split("-");
  const mounted = context.get("mounted");
  const remainingTime = context.get("remainingTime");
  const height = computed("height");
  const frontmost = computed("frontmost");
  const sibling = !frontmost;
  const overlap = !prop("stacked");
  const stacked = prop("stacked");
  const type = prop("type");
  const duration = type === "loading" ? Number.MAX_SAFE_INTEGER : remainingTime;
  const offset = computed("heightIndex") * gap + computed("heightBefore");
  const styles = {
    position: "absolute",
    pointerEvents: "auto",
    "--opacity": "0",
    "--remove-delay": `${prop("removeDelay")}ms`,
    "--duration": `${duration}ms`,
    "--initial-height": `${height}px`,
    "--offset": `${offset}px`,
    "--index": prop("index"),
    "--z-index": computed("zIndex"),
    "--lift-amount": "calc(var(--lift) * var(--gap))",
    "--y": "100%",
    "--x": "0"
  };
  const assign = (overrides) => Object.assign(styles, overrides);
  if (side === "top") {
    assign({
      top: "0",
      "--sign": "-1",
      "--y": "-100%",
      "--lift": "1"
    });
  } else if (side === "bottom") {
    assign({
      bottom: "0",
      "--sign": "1",
      "--y": "100%",
      "--lift": "-1"
    });
  }
  if (mounted) {
    assign({
      "--y": "0",
      "--opacity": "1"
    });
    if (stacked) {
      assign({
        "--y": "calc(var(--lift) * var(--offset))",
        "--height": "var(--initial-height)"
      });
    }
  }
  if (!visible) {
    assign({
      "--opacity": "0",
      pointerEvents: "none"
    });
  }
  if (sibling && overlap) {
    assign({
      "--base-scale": "var(--index) * 0.05 + 1",
      "--y": "calc(var(--lift-amount) * var(--index))",
      "--scale": "calc(-1 * var(--base-scale))",
      "--height": "var(--first-height)"
    });
    if (!visible) {
      assign({
        "--y": "calc(var(--sign) * 40%)"
      });
    }
  }
  if (sibling && stacked && !visible) {
    assign({
      "--y": "calc(var(--lift) * var(--offset) + var(--lift) * -100%)"
    });
  }
  if (frontmost && !visible) {
    assign({
      "--y": "calc(var(--lift) * -100%)"
    });
  }
  return styles;
}
function getGhostBeforeStyle(service, visible) {
  const { computed } = service;
  const styles = {
    position: "absolute",
    inset: "0",
    scale: "1 2",
    pointerEvents: visible ? "none" : "auto"
  };
  const assign = (overrides) => Object.assign(styles, overrides);
  if (computed("frontmost") && !visible) {
    assign({
      height: "calc(var(--initial-height) + 80%)"
    });
  }
  return styles;
}
function getGhostAfterStyle() {
  return {
    position: "absolute",
    left: "0",
    height: "calc(var(--gap) + 2px)",
    bottom: "100%",
    width: "100%"
  };
}
function groupConnect(service, normalize) {
  const { context, prop, send, refs, computed } = service;
  return {
    getCount() {
      return context.get("toasts").length;
    },
    getToasts() {
      return context.get("toasts");
    },
    getGroupProps(options = {}) {
      const { label = "Notifications" } = options;
      const { hotkey } = prop("store").attrs;
      const hotkeyLabel = hotkey.join("+").replace(/Key/g, "").replace(/Digit/g, "");
      const placement = computed("placement");
      const [side, align = "center"] = placement.split("-");
      return normalize.element({
        ...parts.group.attrs,
        dir: prop("dir"),
        tabIndex: -1,
        "aria-label": `${placement} ${label} ${hotkeyLabel}`,
        id: getRegionId(placement),
        "data-placement": placement,
        "data-side": side,
        "data-align": align,
        "aria-live": "polite",
        role: "region",
        style: getGroupPlacementStyle(service, placement),
        onMouseEnter() {
          if (refs.get("ignoreMouseTimer").isActive()) return;
          send({ type: "REGION.POINTER_ENTER", placement });
        },
        onMouseMove() {
          if (refs.get("ignoreMouseTimer").isActive()) return;
          send({ type: "REGION.POINTER_ENTER", placement });
        },
        onMouseLeave() {
          if (refs.get("ignoreMouseTimer").isActive()) return;
          send({ type: "REGION.POINTER_LEAVE", placement });
        },
        onFocus(event) {
          send({ type: "REGION.FOCUS", target: event.relatedTarget });
        },
        onBlur(event) {
          if (refs.get("isFocusWithin") && !contains(event.currentTarget, event.relatedTarget)) {
            queueMicrotask(() => send({ type: "REGION.BLUR" }));
          }
        }
      });
    },
    subscribe(fn) {
      const store = prop("store");
      return store.subscribe(() => fn(context.get("toasts")));
    }
  };
}
var { guards, createMachine: createMachine2 } = setup();
var { and } = guards;
var groupMachine = createMachine2({
  props({ props }) {
    return {
      dir: "ltr",
      id: uuid(),
      ...props,
      store: props.store
    };
  },
  initialState({ prop }) {
    return prop("store").attrs.overlap ? "overlap" : "stack";
  },
  refs() {
    return {
      lastFocusedEl: null,
      isFocusWithin: false,
      isPointerWithin: false,
      ignoreMouseTimer: AnimationFrame.create(),
      dismissableCleanup: void 0
    };
  },
  context({ bindable }) {
    return {
      toasts: bindable(() => ({
        defaultValue: [],
        sync: true,
        hash: (toasts) => toasts.map((t) => t.id).join(",")
      })),
      heights: bindable(() => ({
        defaultValue: [],
        sync: true
      }))
    };
  },
  computed: {
    count: ({ context }) => context.get("toasts").length,
    overlap: ({ prop }) => prop("store").attrs.overlap,
    placement: ({ prop }) => prop("store").attrs.placement
  },
  effects: ["subscribeToStore", "trackDocumentVisibility", "trackHotKeyPress"],
  watch({ track, context, action }) {
    track([() => context.hash("toasts")], () => {
      queueMicrotask(() => {
        action(["collapsedIfEmpty", "setDismissableBranch"]);
      });
    });
  },
  exit: ["clearDismissableBranch", "clearLastFocusedEl", "clearMouseEventTimer"],
  on: {
    "DOC.HOTKEY": {
      actions: ["focusRegionEl"]
    },
    "REGION.BLUR": [
      {
        guard: and("isOverlapping", "isPointerOut"),
        target: "overlap",
        actions: ["collapseToasts", "resumeToasts", "restoreFocusIfPointerOut"]
      },
      {
        guard: "isPointerOut",
        target: "stack",
        actions: ["resumeToasts", "restoreFocusIfPointerOut"]
      },
      {
        actions: ["clearFocusWithin"]
      }
    ],
    "TOAST.REMOVE": {
      actions: ["removeToast", "removeHeight", "ignoreMouseEventsTemporarily"]
    },
    "TOAST.PAUSE": {
      actions: ["pauseToasts"]
    }
  },
  states: {
    stack: {
      on: {
        "REGION.POINTER_LEAVE": [
          {
            guard: "isOverlapping",
            target: "overlap",
            actions: ["clearPointerWithin", "resumeToasts", "collapseToasts"]
          },
          {
            actions: ["clearPointerWithin", "resumeToasts"]
          }
        ],
        "REGION.OVERLAP": {
          target: "overlap",
          actions: ["collapseToasts"]
        },
        "REGION.FOCUS": {
          actions: ["setLastFocusedEl", "pauseToasts"]
        },
        "REGION.POINTER_ENTER": {
          actions: ["setPointerWithin", "pauseToasts"]
        }
      }
    },
    overlap: {
      on: {
        "REGION.STACK": {
          target: "stack",
          actions: ["expandToasts"]
        },
        "REGION.POINTER_ENTER": {
          target: "stack",
          actions: ["setPointerWithin", "pauseToasts", "expandToasts"]
        },
        "REGION.FOCUS": {
          target: "stack",
          actions: ["setLastFocusedEl", "pauseToasts", "expandToasts"]
        }
      }
    }
  },
  implementations: {
    guards: {
      isOverlapping: ({ computed }) => computed("overlap"),
      isPointerOut: ({ refs }) => !refs.get("isPointerWithin")
    },
    effects: {
      subscribeToStore({ context, prop }) {
        const store = prop("store");
        context.set("toasts", store.getVisibleToasts());
        return store.subscribe((toast) => {
          if (toast.dismiss) {
            context.set("toasts", (prev) => prev.filter((t) => t.id !== toast.id));
            return;
          }
          context.set("toasts", (prev) => {
            const index = prev.findIndex((t) => t.id === toast.id);
            if (index !== -1) {
              return [...prev.slice(0, index), { ...prev[index], ...toast }, ...prev.slice(index + 1)];
            }
            return [toast, ...prev];
          });
        });
      },
      trackHotKeyPress({ prop, send }) {
        const handleKeyDown = (event) => {
          const { hotkey } = prop("store").attrs;
          const isHotkeyPressed = hotkey.every((key) => event[key] || event.code === key);
          if (!isHotkeyPressed) return;
          send({ type: "DOC.HOTKEY" });
        };
        return addDomEvent(document, "keydown", handleKeyDown, { capture: true });
      },
      trackDocumentVisibility({ prop, send, scope }) {
        const { pauseOnPageIdle } = prop("store").attrs;
        if (!pauseOnPageIdle) return;
        const doc = scope.getDoc();
        return addDomEvent(doc, "visibilitychange", () => {
          const isHidden = doc.visibilityState === "hidden";
          send({ type: isHidden ? "PAUSE_ALL" : "RESUME_ALL" });
        });
      }
    },
    actions: {
      setDismissableBranch({ refs, context, computed, scope }) {
        const toasts = context.get("toasts");
        const placement = computed("placement");
        const hasToasts = toasts.length > 0;
        if (!hasToasts) {
          refs.get("dismissableCleanup")?.();
          return;
        }
        if (hasToasts && refs.get("dismissableCleanup")) {
          return;
        }
        const groupEl = () => getRegionEl(scope, placement);
        const cleanup = trackDismissableBranch(groupEl, { defer: true });
        refs.set("dismissableCleanup", cleanup);
      },
      clearDismissableBranch({ refs }) {
        refs.get("dismissableCleanup")?.();
      },
      focusRegionEl({ scope, computed }) {
        queueMicrotask(() => {
          getRegionEl(scope, computed("placement"))?.focus();
        });
      },
      pauseToasts({ prop }) {
        prop("store").pause();
      },
      resumeToasts({ prop }) {
        prop("store").resume();
      },
      expandToasts({ prop }) {
        prop("store").expand();
      },
      collapseToasts({ prop }) {
        prop("store").collapse();
      },
      removeToast({ prop, event }) {
        prop("store").remove(event.id);
      },
      removeHeight({ event, context }) {
        if (event?.id == null) return;
        queueMicrotask(() => {
          context.set("heights", (heights) => heights.filter((height) => height.id !== event.id));
        });
      },
      collapsedIfEmpty({ send, computed }) {
        if (!computed("overlap") || computed("count") > 1) return;
        send({ type: "REGION.OVERLAP" });
      },
      setLastFocusedEl({ refs, event }) {
        if (refs.get("isFocusWithin") || !event.target) return;
        refs.set("isFocusWithin", true);
        refs.set("lastFocusedEl", event.target);
      },
      restoreFocusIfPointerOut({ refs }) {
        if (!refs.get("lastFocusedEl") || refs.get("isPointerWithin")) return;
        refs.get("lastFocusedEl")?.focus({ preventScroll: true });
        refs.set("lastFocusedEl", null);
        refs.set("isFocusWithin", false);
      },
      setPointerWithin({ refs }) {
        refs.set("isPointerWithin", true);
      },
      clearPointerWithin({ refs }) {
        refs.set("isPointerWithin", false);
        if (refs.get("lastFocusedEl") && !refs.get("isFocusWithin")) {
          refs.get("lastFocusedEl")?.focus({ preventScroll: true });
          refs.set("lastFocusedEl", null);
        }
      },
      clearFocusWithin({ refs }) {
        refs.set("isFocusWithin", false);
      },
      clearLastFocusedEl({ refs }) {
        if (!refs.get("lastFocusedEl")) return;
        refs.get("lastFocusedEl")?.focus({ preventScroll: true });
        refs.set("lastFocusedEl", null);
        refs.set("isFocusWithin", false);
      },
      ignoreMouseEventsTemporarily({ refs }) {
        refs.get("ignoreMouseTimer").request();
      },
      clearMouseEventTimer({ refs }) {
        refs.get("ignoreMouseTimer").cancel();
      }
    }
  }
});
function connect(service, normalize) {
  const { state, send, prop, scope, context, computed } = service;
  const visible = state.hasTag("visible");
  const paused = state.hasTag("paused");
  const mounted = context.get("mounted");
  const frontmost = computed("frontmost");
  const placement = prop("parent").computed("placement");
  const type = prop("type");
  const stacked = prop("stacked");
  const title = prop("title");
  const description = prop("description");
  const action = prop("action");
  const [side, align = "center"] = placement.split("-");
  return {
    type,
    title,
    description,
    placement,
    visible,
    paused,
    closable: !!prop("closable"),
    pause() {
      send({ type: "PAUSE" });
    },
    resume() {
      send({ type: "RESUME" });
    },
    dismiss() {
      send({ type: "DISMISS", src: "programmatic" });
    },
    getRootProps() {
      return normalize.element({
        ...parts.root.attrs,
        dir: prop("dir"),
        id: getRootId(scope),
        "data-state": visible ? "open" : "closed",
        "data-type": type,
        "data-placement": placement,
        "data-align": align,
        "data-side": side,
        "data-mounted": dataAttr(mounted),
        "data-paused": dataAttr(paused),
        "data-first": dataAttr(frontmost),
        "data-sibling": dataAttr(!frontmost),
        "data-stack": dataAttr(stacked),
        "data-overlap": dataAttr(!stacked),
        role: "status",
        "aria-atomic": "true",
        "aria-describedby": description ? getDescriptionId(scope) : void 0,
        "aria-labelledby": title ? getTitleId(scope) : void 0,
        tabIndex: 0,
        style: getPlacementStyle(service, visible),
        onKeyDown(event) {
          if (event.defaultPrevented) return;
          if (event.key == "Escape") {
            send({ type: "DISMISS", src: "keyboard" });
            event.preventDefault();
          }
        }
      });
    },
    /* Leave a ghost div to avoid setting hover to false when transitioning out */
    getGhostBeforeProps() {
      return normalize.element({
        "data-ghost": "before",
        style: getGhostBeforeStyle(service, visible)
      });
    },
    /* Needed to avoid setting hover to false when in between toasts */
    getGhostAfterProps() {
      return normalize.element({
        "data-ghost": "after",
        style: getGhostAfterStyle()
      });
    },
    getTitleProps() {
      return normalize.element({
        ...parts.title.attrs,
        id: getTitleId(scope)
      });
    },
    getDescriptionProps() {
      return normalize.element({
        ...parts.description.attrs,
        id: getDescriptionId(scope)
      });
    },
    getActionTriggerProps() {
      return normalize.button({
        ...parts.actionTrigger.attrs,
        type: "button",
        onClick(event) {
          if (event.defaultPrevented) return;
          action?.onClick?.();
          send({ type: "DISMISS", src: "user" });
        }
      });
    },
    getCloseTriggerProps() {
      return normalize.button({
        id: getCloseTriggerId(scope),
        ...parts.closeTrigger.attrs,
        type: "button",
        "aria-label": "Dismiss notification",
        onClick(event) {
          if (event.defaultPrevented) return;
          send({ type: "DISMISS", src: "user" });
        }
      });
    }
  };
}
var { not } = createGuards();
var machine = createMachine({
  props({ props }) {
    ensureProps(props, ["id", "type", "parent", "removeDelay"], "toast");
    return {
      closable: true,
      ...props,
      duration: getToastDuration(props.duration, props.type)
    };
  },
  initialState({ prop }) {
    const persist = prop("type") === "loading" || prop("duration") === Infinity;
    return persist ? "visible:persist" : "visible";
  },
  context({ prop, bindable }) {
    return {
      remainingTime: bindable(() => ({
        defaultValue: getToastDuration(prop("duration"), prop("type"))
      })),
      createdAt: bindable(() => ({
        defaultValue: Date.now()
      })),
      mounted: bindable(() => ({
        defaultValue: false
      })),
      initialHeight: bindable(() => ({
        defaultValue: 0
      }))
    };
  },
  refs() {
    return {
      closeTimerStartTime: Date.now(),
      lastCloseStartTimerStartTime: 0
    };
  },
  computed: {
    zIndex: ({ prop }) => {
      const toasts = prop("parent").context.get("toasts");
      const index = toasts.findIndex((toast) => toast.id === prop("id"));
      return toasts.length - index;
    },
    height: ({ prop }) => {
      const heights = prop("parent").context.get("heights");
      const height = heights.find((height2) => height2.id === prop("id"));
      return height?.height ?? 0;
    },
    heightIndex: ({ prop }) => {
      const heights = prop("parent").context.get("heights");
      return heights.findIndex((height) => height.id === prop("id"));
    },
    frontmost: ({ prop }) => prop("index") === 0,
    heightBefore: ({ prop }) => {
      const heights = prop("parent").context.get("heights");
      const heightIndex = heights.findIndex((height) => height.id === prop("id"));
      return heights.reduce((prev, curr, reducerIndex) => {
        if (reducerIndex >= heightIndex) return prev;
        return prev + curr.height;
      }, 0);
    },
    shouldPersist: ({ prop }) => prop("type") === "loading" || prop("duration") === Infinity
  },
  watch({ track, prop, send }) {
    track([() => prop("message")], () => {
      const message = prop("message");
      if (message) send({ type: message, src: "programmatic" });
    });
    track([() => prop("type"), () => prop("duration")], () => {
      send({ type: "UPDATE" });
    });
  },
  on: {
    UPDATE: [
      {
        guard: "shouldPersist",
        target: "visible:persist",
        actions: ["resetCloseTimer"]
      },
      {
        target: "visible:updating",
        actions: ["resetCloseTimer"]
      }
    ],
    MEASURE: {
      actions: ["measureHeight"]
    }
  },
  entry: ["setMounted", "measureHeight", "invokeOnVisible"],
  effects: ["trackHeight"],
  states: {
    "visible:updating": {
      tags: ["visible", "updating"],
      effects: ["waitForNextTick"],
      on: {
        SHOW: {
          target: "visible"
        }
      }
    },
    "visible:persist": {
      tags: ["visible", "paused"],
      on: {
        RESUME: {
          guard: not("isLoadingType"),
          target: "visible",
          actions: ["setCloseTimer"]
        },
        DISMISS: {
          target: "dismissing"
        }
      }
    },
    visible: {
      tags: ["visible"],
      effects: ["waitForDuration"],
      on: {
        DISMISS: {
          target: "dismissing"
        },
        PAUSE: {
          target: "visible:persist",
          actions: ["syncRemainingTime"]
        }
      }
    },
    dismissing: {
      entry: ["invokeOnDismiss"],
      effects: ["waitForRemoveDelay"],
      on: {
        REMOVE: {
          target: "unmounted",
          actions: ["notifyParentToRemove"]
        }
      }
    },
    unmounted: {
      entry: ["invokeOnUnmount"]
    }
  },
  implementations: {
    effects: {
      waitForRemoveDelay({ prop, send }) {
        return setRafTimeout(() => {
          send({ type: "REMOVE", src: "timer" });
        }, prop("removeDelay"));
      },
      waitForDuration({ send, context, computed }) {
        if (computed("shouldPersist")) return;
        return setRafTimeout(() => {
          send({ type: "DISMISS", src: "timer" });
        }, context.get("remainingTime"));
      },
      waitForNextTick({ send }) {
        return setRafTimeout(() => {
          send({ type: "SHOW", src: "timer" });
        }, 0);
      },
      trackHeight({ scope, prop }) {
        let cleanup;
        raf(() => {
          const rootEl = getRootEl(scope);
          if (!rootEl) return;
          const syncHeight = () => {
            const originalHeight = rootEl.style.height;
            rootEl.style.height = "auto";
            const height = rootEl.getBoundingClientRect().height;
            rootEl.style.height = originalHeight;
            const item = { id: prop("id"), height };
            setHeight(prop("parent"), item);
          };
          const win = scope.getWin();
          const observer = new win.MutationObserver(syncHeight);
          observer.observe(rootEl, {
            childList: true,
            subtree: true,
            characterData: true
          });
          cleanup = () => observer.disconnect();
        });
        return () => cleanup?.();
      }
    },
    guards: {
      isLoadingType: ({ prop }) => prop("type") === "loading",
      shouldPersist: ({ computed }) => computed("shouldPersist")
    },
    actions: {
      setMounted({ context }) {
        raf(() => {
          context.set("mounted", true);
        });
      },
      measureHeight({ scope, prop, context }) {
        queueMicrotask(() => {
          const rootEl = getRootEl(scope);
          if (!rootEl) return;
          const originalHeight = rootEl.style.height;
          rootEl.style.height = "auto";
          const height = rootEl.getBoundingClientRect().height;
          rootEl.style.height = originalHeight;
          context.set("initialHeight", height);
          const item = { id: prop("id"), height };
          setHeight(prop("parent"), item);
        });
      },
      setCloseTimer({ refs }) {
        refs.set("closeTimerStartTime", Date.now());
      },
      resetCloseTimer({ context, refs, prop }) {
        refs.set("closeTimerStartTime", Date.now());
        context.set("remainingTime", getToastDuration(prop("duration"), prop("type")));
      },
      syncRemainingTime({ context, refs }) {
        context.set("remainingTime", (prev) => {
          const closeTimerStartTime = refs.get("closeTimerStartTime");
          const elapsedTime = Date.now() - closeTimerStartTime;
          refs.set("lastCloseStartTimerStartTime", Date.now());
          return prev - elapsedTime;
        });
      },
      notifyParentToRemove({ prop }) {
        const parent = prop("parent");
        parent.send({ type: "TOAST.REMOVE", id: prop("id") });
      },
      invokeOnDismiss({ prop, event }) {
        prop("onStatusChange")?.({ status: "dismissing", src: event.src });
      },
      invokeOnUnmount({ prop }) {
        prop("onStatusChange")?.({ status: "unmounted" });
      },
      invokeOnVisible({ prop }) {
        prop("onStatusChange")?.({ status: "visible" });
      }
    }
  }
});
function setHeight(parent, item) {
  const { id, height } = item;
  parent.context.set("heights", (prev) => {
    const alreadyExists = prev.find((i) => i.id === id);
    if (!alreadyExists) {
      return [{ id, height }, ...prev];
    } else {
      return prev.map((i) => i.id === id ? { ...i, height } : i);
    }
  });
}
var withDefaults = (options, defaults) => {
  return { ...defaults, ...compact(options) };
};
function createToastStore(props = {}) {
  const attrs = withDefaults(props, {
    placement: "bottom",
    overlap: false,
    max: 24,
    gap: 16,
    offsets: "1rem",
    hotkey: ["altKey", "KeyT"],
    removeDelay: 200,
    pauseOnPageIdle: true
  });
  let subscribers = [];
  let toasts = [];
  let dismissedToasts = /* @__PURE__ */ new Set();
  let toastQueue = [];
  const subscribe = (subscriber) => {
    subscribers.push(subscriber);
    return () => {
      const index = subscribers.indexOf(subscriber);
      subscribers.splice(index, 1);
    };
  };
  const publish = (data) => {
    subscribers.forEach((subscriber) => subscriber(data));
    return data;
  };
  const addToast = (data) => {
    if (toasts.length >= attrs.max) {
      toastQueue.push(data);
      return;
    }
    publish(data);
    toasts.unshift(data);
  };
  const processQueue = () => {
    while (toastQueue.length > 0 && toasts.length < attrs.max) {
      const nextToast = toastQueue.shift();
      if (nextToast) {
        publish(nextToast);
        toasts.unshift(nextToast);
      }
    }
  };
  const create = (data) => {
    const id = data.id ?? `toast:${uuid()}`;
    const exists = toasts.find((toast) => toast.id === id);
    if (dismissedToasts.has(id)) dismissedToasts.delete(id);
    if (exists) {
      toasts = toasts.map((toast) => {
        if (toast.id === id) {
          return publish({ ...toast, ...data, id });
        }
        return toast;
      });
    } else {
      addToast({
        id,
        duration: attrs.duration,
        removeDelay: attrs.removeDelay,
        type: "info",
        ...data,
        stacked: !attrs.overlap,
        gap: attrs.gap
      });
    }
    return id;
  };
  const remove = (id) => {
    dismissedToasts.add(id);
    if (!id) {
      toasts.forEach((toast) => {
        subscribers.forEach((subscriber) => subscriber({ id: toast.id, dismiss: true }));
      });
      toasts = [];
      toastQueue = [];
    } else {
      subscribers.forEach((subscriber) => subscriber({ id, dismiss: true }));
      toasts = toasts.filter((toast) => toast.id !== id);
      processQueue();
    }
    return id;
  };
  const error = (data) => {
    return create({ ...data, type: "error" });
  };
  const success = (data) => {
    return create({ ...data, type: "success" });
  };
  const info = (data) => {
    return create({ ...data, type: "info" });
  };
  const warning = (data) => {
    return create({ ...data, type: "warning" });
  };
  const loading = (data) => {
    return create({ ...data, type: "loading" });
  };
  const getVisibleToasts = () => {
    return toasts.filter((toast) => !dismissedToasts.has(toast.id));
  };
  const getCount = () => {
    return toasts.length;
  };
  const promise = (promise2, options, shared = {}) => {
    if (!options || !options.loading) {
      warn("[zag-js > toast] toaster.promise() requires at least a 'loading' option to be specified");
      return;
    }
    const id = create({
      ...shared,
      ...options.loading,
      promise: promise2,
      type: "loading"
    });
    let removable = true;
    let result;
    const prom = runIfFn(promise2).then(async (response) => {
      result = ["resolve", response];
      if (isHttpResponse(response) && !response.ok) {
        removable = false;
        const errorOptions = runIfFn(options.error, `HTTP Error! status: ${response.status}`);
        create({ ...shared, ...errorOptions, id, type: "error" });
      } else if (options.success !== void 0) {
        removable = false;
        const successOptions = runIfFn(options.success, response);
        create({ ...shared, ...successOptions, id, type: "success" });
      }
    }).catch(async (error2) => {
      result = ["reject", error2];
      if (options.error !== void 0) {
        removable = false;
        const errorOptions = runIfFn(options.error, error2);
        create({ ...shared, ...errorOptions, id, type: "error" });
      }
    }).finally(() => {
      if (removable) {
        remove(id);
      }
      options.finally?.();
    });
    const unwrap = () => new Promise(
      (resolve, reject) => prom.then(() => result[0] === "reject" ? reject(result[1]) : resolve(result[1])).catch(reject)
    );
    return { id, unwrap };
  };
  const update = (id, data) => {
    return create({ id, ...data });
  };
  const pause = (id) => {
    if (id != null) {
      toasts = toasts.map((toast) => {
        if (toast.id === id) return publish({ ...toast, message: "PAUSE" });
        return toast;
      });
    } else {
      toasts = toasts.map((toast) => publish({ ...toast, message: "PAUSE" }));
    }
  };
  const resume = (id) => {
    if (id != null) {
      toasts = toasts.map((toast) => {
        if (toast.id === id) return publish({ ...toast, message: "RESUME" });
        return toast;
      });
    } else {
      toasts = toasts.map((toast) => publish({ ...toast, message: "RESUME" }));
    }
  };
  const dismiss = (id) => {
    if (id != null) {
      toasts = toasts.map((toast) => {
        if (toast.id === id) return publish({ ...toast, message: "DISMISS" });
        return toast;
      });
    } else {
      toasts = toasts.map((toast) => publish({ ...toast, message: "DISMISS" }));
    }
  };
  const isVisible = (id) => {
    return !dismissedToasts.has(id) && !!toasts.find((toast) => toast.id === id);
  };
  const isDismissed = (id) => {
    return dismissedToasts.has(id);
  };
  const expand = () => {
    toasts = toasts.map((toast) => publish({ ...toast, stacked: true }));
  };
  const collapse = () => {
    toasts = toasts.map((toast) => publish({ ...toast, stacked: false }));
  };
  return {
    attrs,
    subscribe,
    create,
    update,
    remove,
    dismiss,
    error,
    success,
    info,
    warning,
    loading,
    getVisibleToasts,
    getCount,
    promise,
    pause,
    resume,
    isVisible,
    isDismissed,
    expand,
    collapse
  };
}
var isHttpResponse = (data) => {
  return data && typeof data === "object" && "ok" in data && typeof data.ok === "boolean" && "status" in data && typeof data.status === "number";
};
var group = {
  connect: groupConnect,
  machine: groupMachine
};

// components/toast.ts
var toastGroups = /* @__PURE__ */ new Map();
var toastStores = /* @__PURE__ */ new Map();
var ToastItem = class extends Component {
  parts;
  duration;
  constructor(el, props) {
    super(el, props);
    this.duration = props.duration;
    this.el.setAttribute("data-scope", "toast");
    this.el.setAttribute("data-part", "root");
    this.el.innerHTML = `
      <span data-scope="toast" data-part="ghost-before"></span>
      <div data-scope="toast" data-part="progressbar"></div>
      <div data-scope="toast" data-part="loading-spinner" style="display: none;"></div>

      <div data-scope="toast" data-part="content">
        <div data-scope="toast" data-part="title"></div>
        <div data-scope="toast" data-part="description"></div>
      </div>

      <button data-scope="toast" data-part="close-trigger">
        <svg viewBox="0 0 20 20" aria-hidden="true">
          <path d="M4.293 4.293 10 8.586l5.707-5.707 1.414 1.414L11.414 10l5.707 5.707-1.414 1.414L10 11.414l-5.707 5.707-1.414-1.414L8.586 10 2.879 4.293z"/>
        </svg>
      </button>

      <span data-scope="toast" data-part="ghost-after"></span>
    `;
    this.parts = {
      title: this.el.querySelector('[data-scope="toast"][data-part="title"]'),
      description: this.el.querySelector('[data-scope="toast"][data-part="description"]'),
      close: this.el.querySelector('[data-scope="toast"][data-part="close-trigger"]'),
      ghostBefore: this.el.querySelector('[data-scope="toast"][data-part="ghost-before"]'),
      ghostAfter: this.el.querySelector('[data-scope="toast"][data-part="ghost-after"]'),
      progressbar: this.el.querySelector('[data-scope="toast"][data-part="progressbar"]'),
      loadingSpinner: this.el.querySelector('[data-scope="toast"][data-part="loading-spinner"]')
    };
  }
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props) {
    return new VanillaMachine(machine, props);
  }
  initApi() {
    return connect(this.machine.service, normalizeProps);
  }
  render() {
    this.spreadProps(this.el, this.api.getRootProps());
    this.spreadProps(this.parts.close, this.api.getCloseTriggerProps());
    this.spreadProps(this.parts.ghostBefore, this.api.getGhostBeforeProps());
    this.spreadProps(this.parts.ghostAfter, this.api.getGhostAfterProps());
    if (this.parts.title.textContent !== this.api.title) {
      this.parts.title.textContent = this.api.title ?? "";
    }
    if (this.parts.description.textContent !== this.api.description) {
      this.parts.description.textContent = this.api.description ?? "";
    }
    this.spreadProps(this.parts.title, this.api.getTitleProps());
    this.spreadProps(this.parts.description, this.api.getDescriptionProps());
    const duration = this.duration;
    const isInfinity = duration === "Infinity" || duration === Infinity || duration === Number.POSITIVE_INFINITY;
    const toastGroup = this.el.closest('[phx-hook="Toast"]');
    const loadingIconTemplate = toastGroup?.querySelector("[data-loading-icon-template]");
    const loadingIcon = loadingIconTemplate?.innerHTML;
    if (isInfinity) {
      this.parts.progressbar.style.display = "none";
      this.parts.loadingSpinner.style.display = "flex";
      this.el.setAttribute("data-duration-infinity", "true");
      if (loadingIcon && this.parts.loadingSpinner.innerHTML !== loadingIcon) {
        this.parts.loadingSpinner.innerHTML = loadingIcon;
      }
    } else {
      this.parts.progressbar.style.display = "block";
      this.parts.loadingSpinner.style.display = "none";
      this.el.removeAttribute("data-duration-infinity");
    }
  }
  destroy = () => {
    this.machine.stop();
    this.el.remove();
  };
};
var ToastGroup = class extends Component {
  toastComponents = /* @__PURE__ */ new Map();
  groupEl;
  store;
  constructor(el, props) {
    super(el, props);
    this.store = props.store;
    this.groupEl = el.querySelector('[data-part="group"]') ?? (() => {
      const g = document.createElement("div");
      g.setAttribute("data-scope", "toast");
      g.setAttribute("data-part", "group");
      el.appendChild(g);
      return g;
    })();
  }
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props) {
    return new VanillaMachine(group.machine, props);
  }
  initApi() {
    return group.connect(this.machine.service, normalizeProps);
  }
  render() {
    this.spreadProps(this.groupEl, this.api.getGroupProps());
    const toasts = this.api.getToasts().filter((t) => typeof t.id === "string");
    const nextIds = new Set(toasts.map((t) => t.id));
    toasts.forEach((toastData, index) => {
      let item = this.toastComponents.get(toastData.id);
      if (!item) {
        const el = document.createElement("div");
        el.setAttribute("data-scope", "toast");
        el.setAttribute("data-part", "root");
        this.groupEl.appendChild(el);
        item = new ToastItem(el, {
          ...toastData,
          parent: this.machine.service,
          index
        });
        item.init();
        this.toastComponents.set(toastData.id, item);
      } else {
        item.duration = toastData.duration;
        item.updateProps({
          ...toastData,
          parent: this.machine.service,
          index
        });
      }
    });
    for (const [id, comp] of this.toastComponents) {
      if (!nextIds.has(id)) {
        comp.destroy();
        this.toastComponents.delete(id);
      }
    }
  }
  destroy = () => {
    for (const comp of this.toastComponents.values()) {
      comp.destroy();
    }
    this.toastComponents.clear();
    this.machine.stop();
  };
};
function createToastGroup(container, options) {
  const groupId = options?.id ?? generateId(container, "toast");
  const store = options?.store ?? createToastStore({
    placement: options?.placement ?? "bottom",
    overlap: options?.overlap,
    max: options?.max,
    gap: options?.gap,
    offsets: options?.offsets,
    pauseOnPageIdle: options?.pauseOnPageIdle
  });
  const group2 = new ToastGroup(container, { id: groupId, store });
  group2.init();
  toastGroups.set(groupId, group2);
  toastStores.set(groupId, store);
  container.dataset.toastGroup = "true";
  container.dataset.toastGroupId = groupId;
  return { group: group2, store };
}
function getToastStore(groupId) {
  if (groupId) return toastStores.get(groupId);
  const el = document.querySelector("[data-toast-group]");
  if (!el) return;
  const id = el.dataset.toastGroupId || el.id;
  return id ? toastStores.get(id) : void 0;
}

// hooks/toast.ts
var ToastHook = {
  mounted() {
    const el = this.el;
    if (!el.id) {
      el.id = generateId(el, "toast");
    }
    this.groupId = el.id;
    const parseOffsets = (offsetsString) => {
      if (!offsetsString) return void 0;
      try {
        return offsetsString.includes("{") ? JSON.parse(offsetsString) : offsetsString;
      } catch {
        return offsetsString;
      }
    };
    const parseDuration = (duration) => {
      if (duration === "Infinity" || duration === Infinity) {
        return Infinity;
      }
      if (typeof duration === "string") {
        return parseInt(duration, 10) || void 0;
      }
      return duration;
    };
    const placement = getString(el, "placement", [
      "top-start",
      "top",
      "top-end",
      "bottom-start",
      "bottom",
      "bottom-end"
    ]) ?? "bottom-end";
    createToastGroup(el, {
      id: this.groupId,
      placement,
      overlap: getBoolean(el, "overlap"),
      max: getNumber(el, "max"),
      gap: getNumber(el, "gap"),
      offsets: parseOffsets(getString(el, "offset")),
      pauseOnPageIdle: getBoolean(el, "pauseOnPageIdle")
    });
    this.handlers = [];
    this.handlers.push(
      this.handleEvent("toast-create", (payload) => {
        const store = getToastStore(payload.groupId || this.groupId);
        if (!store) return;
        try {
          store.create({
            title: payload.title,
            description: payload.description,
            type: payload.type || "info",
            id: payload.id || generateId(void 0, "toast"),
            duration: parseDuration(payload.duration)
          });
        } catch (error) {
          console.error("Failed to create toast:", error);
        }
      })
    );
    this.handlers.push(
      this.handleEvent("toast-update", (payload) => {
        const store = getToastStore(payload.groupId || this.groupId);
        if (!store) return;
        try {
          store.update(payload.id, {
            title: payload.title,
            description: payload.description,
            type: payload.type
          });
        } catch (error) {
          console.error("Failed to update toast:", error);
        }
      })
    );
    this.handlers.push(
      this.handleEvent("toast-dismiss", (payload) => {
        const store = getToastStore(payload.groupId || this.groupId);
        if (!store) return;
        try {
          store.dismiss(payload.id);
        } catch (error) {
          console.error("Failed to dismiss toast:", error);
        }
      })
    );
    el.addEventListener("toast:create", (event) => {
      const { detail } = event;
      const store = getToastStore(detail.groupId || this.groupId);
      if (!store) return;
      try {
        store.create({
          title: detail.title,
          description: detail.description,
          type: detail.type || "info",
          id: detail.id || generateId(void 0, "toast"),
          duration: parseDuration(detail.duration)
        });
      } catch (error) {
        console.error("Failed to create toast:", error);
      }
    });
  },
  destroyed() {
    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }
  }
};
export {
  ToastHook as Toast
};
