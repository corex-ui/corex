import {
  Component,
  VanillaMachine,
  createAnatomy,
  createMachine,
  createProps,
  createSplitProps,
  dataAttr,
  getBoolean,
  getDir,
  getNumber,
  getString,
  normalizeProps
} from "./chunk-PLUM2DEK.mjs";

// ../node_modules/.pnpm/@zag-js+marquee@1.34.1/node_modules/@zag-js/marquee/dist/index.mjs
var anatomy = createAnatomy("marquee").parts("root", "viewport", "content", "edge", "item");
var parts = anatomy.build();
var dom = {
  getRootId: (ctx) => ctx.ids?.root ?? `marquee:${ctx.id}`,
  getViewportId: (ctx) => ctx.ids?.viewport ?? `marquee:${ctx.id}:viewport`,
  getContentId: (ctx, index) => ctx.ids?.content?.(index) ?? `marquee:${ctx.id}:content:${index}`,
  getRootEl: (ctx) => ctx.getById(dom.getRootId(ctx)),
  getViewportEl: (ctx) => ctx.getById(dom.getViewportId(ctx)),
  getContentEl: (ctx, index) => ctx.getById(dom.getContentId(ctx, index))
};
var getEdgePositionStyles = (options) => {
  const { side } = options;
  switch (side) {
    case "start":
      return {
        top: 0,
        insetInlineStart: 0,
        height: "100%"
      };
    case "end":
      return {
        top: 0,
        insetInlineEnd: 0,
        height: "100%"
      };
    case "top":
      return {
        top: 0,
        insetInline: 0,
        width: "100%"
      };
    case "bottom":
      return {
        bottom: 0,
        insetInline: 0,
        width: "100%"
      };
  }
};
var getMarqueeTranslate = (options) => {
  const { side, dir } = options;
  if (side === "top") {
    return "-100%";
  }
  if (side === "bottom") {
    return "100%";
  }
  const shouldBeNegative = side === "start" && dir === "ltr" || side === "end" && dir === "rtl";
  return shouldBeNegative ? "-100%" : "100%";
};
function connect(service, normalize) {
  const { scope, send, context, computed, prop } = service;
  const side = prop("side");
  const paused = context.get("paused");
  const duration = context.get("duration");
  const orientation = computed("orientation");
  const multiplier = computed("multiplier");
  const isVertical = computed("isVertical");
  return {
    paused,
    orientation,
    side,
    multiplier,
    contentCount: multiplier + 1,
    pause() {
      send({ type: "PAUSE" });
    },
    resume() {
      send({ type: "RESUME" });
    },
    togglePause() {
      send({ type: "TOGGLE_PAUSE" });
    },
    restart() {
      send({ type: "RESTART" });
    },
    getRootProps() {
      const dir = prop("dir");
      return normalize.element({
        ...parts.root.attrs,
        id: dom.getRootId(scope),
        dir,
        role: "region",
        "aria-roledescription": "marquee",
        "aria-live": "off",
        "aria-label": prop("translations").root,
        "data-state": paused ? "paused" : "idle",
        "data-orientation": orientation,
        "data-paused": dataAttr(paused),
        onMouseEnter: prop("pauseOnInteraction") ? () => send({ type: "PAUSE" }) : void 0,
        onMouseLeave: prop("pauseOnInteraction") ? () => send({ type: "RESUME" }) : void 0,
        onFocusCapture: prop("pauseOnInteraction") ? (event) => {
          if (event.target !== event.currentTarget) {
            send({ type: "PAUSE" });
          }
        } : void 0,
        onBlurCapture: prop("pauseOnInteraction") ? (event) => {
          if (!event.currentTarget.contains(event.relatedTarget)) {
            send({ type: "RESUME" });
          }
        } : void 0,
        style: {
          display: "flex",
          flexDirection: orientation === "vertical" ? "column" : "row",
          position: "relative",
          // Essential for clipping scrolling content
          overflow: "hidden",
          // CSS containment for performance - prevents layout recalculation of parent elements
          contain: "layout style paint",
          "--marquee-duration": `${duration}s`,
          "--marquee-spacing": prop("spacing"),
          "--marquee-delay": `${prop("delay")}s`,
          "--marquee-loop-count": prop("loopCount") === 0 ? "infinite" : prop("loopCount").toString(),
          "--marquee-translate": getMarqueeTranslate({ side, dir })
        }
      });
    },
    getViewportProps() {
      return normalize.element({
        ...parts.viewport.attrs,
        id: dom.getViewportId(scope),
        "data-part": "viewport",
        "data-orientation": orientation,
        "data-side": side,
        onAnimationIteration(event) {
          if (event.target === dom.getContentEl(scope, 0)) {
            prop("onLoopComplete")?.();
          }
        },
        onAnimationEnd(event) {
          if (event.target === dom.getContentEl(scope, 0)) {
            prop("onComplete")?.();
          }
        },
        style: {
          display: "flex",
          [isVertical ? "height" : "width"]: "100%",
          // For bottom/end sides, reverse flex direction so clones appear on the correct side
          flexDirection: orientation === "vertical" ? side === "bottom" ? "column-reverse" : "column" : side === "end" ? "row-reverse" : "row"
        }
      });
    },
    getContentProps(props2) {
      const { index } = props2;
      const clone = index > 0;
      return normalize.element({
        ...parts.content.attrs,
        id: dom.getContentId(scope, index),
        dir: prop("dir"),
        "data-part": "content",
        "data-index": index,
        "data-orientation": orientation,
        "data-side": side,
        "data-reverse": prop("reverse") ? "" : void 0,
        "data-clone": dataAttr(clone),
        role: clone ? "presentation" : void 0,
        "aria-hidden": clone ? true : void 0,
        style: {
          // Essential layout for marquee content
          display: "flex",
          flexDirection: orientation === "vertical" ? "column" : "row",
          flexShrink: 0,
          // Force compositor layer to prevent flicker during animation reset
          backfaceVisibility: "hidden",
          WebkitBackfaceVisibility: "hidden",
          willChange: paused ? "auto" : "transform",
          transform: "translateZ(0)",
          [isVertical ? "minWidth" : "minHeight"]: "auto",
          // Prevent subpixel rendering issues that cause flicker in Firefox
          contain: "paint"
        }
      });
    },
    getEdgeProps(props2) {
      const { side: side2 } = props2;
      const dir = prop("dir");
      return normalize.element({
        ...parts.edge.attrs,
        dir,
        "data-part": "edge",
        "data-side": side2,
        "data-orientation": orientation,
        style: {
          pointerEvents: "none",
          position: "absolute",
          ...getEdgePositionStyles({ side: side2 })
        }
      });
    },
    getItemProps() {
      return normalize.element({
        ...parts.item.attrs,
        dir: prop("dir"),
        style: {
          [isVertical ? "marginBlock" : "marginInline"]: "calc(var(--marquee-spacing) / 2)"
        }
      });
    }
  };
}
var machine = createMachine({
  props({ props: props2 }) {
    return {
      dir: "ltr",
      side: "start",
      speed: 50,
      delay: 0,
      loopCount: 0,
      spacing: "1rem",
      autoFill: false,
      pauseOnInteraction: false,
      reverse: false,
      defaultPaused: false,
      translations: {
        root: "Marquee content"
      },
      ...props2
    };
  },
  refs() {
    return {
      dimensions: void 0,
      initialDurationSet: false
    };
  },
  context({ prop, bindable }) {
    return {
      paused: bindable(() => ({
        value: prop("paused"),
        defaultValue: prop("defaultPaused"),
        onChange(value) {
          prop("onPauseChange")?.({ paused: value });
        }
      })),
      duration: bindable(() => ({
        defaultValue: 2e3 / Math.max(1e-3, prop("speed"))
      }))
    };
  },
  initialState() {
    return "idle";
  },
  computed: {
    orientation: ({ prop }) => {
      const side = prop("side");
      return side === "top" || side === "bottom" ? "vertical" : "horizontal";
    },
    isVertical: ({ prop }) => {
      const side = prop("side");
      return side === "top" || side === "bottom";
    },
    multiplier: ({ refs, prop }) => {
      if (!prop("autoFill")) return 1;
      const dimensions = refs.get("dimensions");
      if (!dimensions) return 1;
      const { rootSize, contentSize } = dimensions;
      if (contentSize === 0) return 1;
      return contentSize < rootSize ? Math.ceil(rootSize / contentSize) : 1;
    }
  },
  watch({ track, action, prop }) {
    track([() => prop("speed")], () => {
      action(["recalculateDuration", "restartAnimation"]);
    });
    track([() => prop("spacing"), () => prop("side")], () => {
      action(["recalculateDuration"]);
    });
  },
  on: {
    PAUSE: {
      actions: ["setPaused"]
    },
    RESUME: {
      actions: ["setResumed"]
    },
    TOGGLE_PAUSE: {
      actions: ["togglePaused"]
    },
    RESTART: {
      actions: ["restartAnimation"]
    }
  },
  effects: ["trackDimensions"],
  states: {
    idle: {}
  },
  implementations: {
    actions: {
      setPaused({ context }) {
        context.set("paused", true);
      },
      setResumed({ context }) {
        context.set("paused", false);
      },
      togglePaused({ context }) {
        context.set("paused", (prev) => !prev);
      },
      restartAnimation({ scope }) {
        const viewportEl = dom.getViewportEl(scope);
        if (!viewportEl) return;
        const contentElements = viewportEl.querySelectorAll('[data-part="content"]');
        contentElements.forEach((el) => {
          el.style.animation = "none";
          el.style.animation = "";
        });
      },
      recalculateDuration({ refs, computed, context, prop }) {
        const dimensions = refs.get("dimensions");
        if (!dimensions) return;
        const { rootSize, contentSize } = dimensions;
        const duration = calculateDuration({
          rootSize,
          contentSize,
          speed: Math.max(1e-3, prop("speed")),
          multiplier: computed("multiplier"),
          autoFill: prop("autoFill")
        });
        context.set("duration", duration);
      }
    },
    effects: {
      trackDimensions({ scope, refs, computed, context, prop }) {
        const rootEl = dom.getRootEl(scope);
        const contentEl = dom.getContentEl(scope, 0);
        if (!rootEl || !contentEl) return;
        const win = scope.getWin();
        const measureDimensions = () => {
          const rootSize = computed("isVertical") ? rootEl.clientHeight : rootEl.clientWidth;
          const contentSize = computed("isVertical") ? contentEl.clientHeight : contentEl.clientWidth;
          return { rootSize, contentSize };
        };
        const exec = () => {
          const { rootSize, contentSize } = measureDimensions();
          if (rootSize > 0 && contentSize > 0) {
            refs.set("dimensions", { rootSize, contentSize });
            if (!refs.get("initialDurationSet")) {
              const duration = calculateDuration({
                rootSize,
                contentSize,
                speed: Math.max(1e-3, prop("speed")),
                multiplier: computed("multiplier"),
                autoFill: prop("autoFill")
              });
              context.set("duration", duration);
              refs.set("initialDurationSet", true);
            }
          }
        };
        let rafId = null;
        const observer = new win.ResizeObserver(() => {
          if (rafId !== null) return;
          rafId = win.requestAnimationFrame(() => {
            const { rootSize, contentSize } = measureDimensions();
            refs.set("dimensions", { rootSize, contentSize });
            rafId = null;
          });
        });
        observer.observe(rootEl);
        observer.observe(contentEl);
        exec();
        return () => {
          observer.disconnect();
          if (rafId !== null) win.cancelAnimationFrame(rafId);
        };
      }
    }
  }
});
function calculateDuration(options) {
  const { rootSize, contentSize, speed, multiplier, autoFill } = options;
  if (autoFill) {
    return contentSize * multiplier / speed;
  }
  return contentSize < rootSize ? rootSize / speed : contentSize / speed;
}
var props = createProps()([
  "autoFill",
  "defaultPaused",
  "delay",
  "dir",
  "getRootNode",
  "id",
  "ids",
  "loopCount",
  "onComplete",
  "onLoopComplete",
  "onPauseChange",
  "paused",
  "pauseOnInteraction",
  "reverse",
  "side",
  "spacing",
  "speed",
  "translations"
]);
var splitProps = createSplitProps(props);

// components/marquee.ts
var Marquee = class extends Component {
  initMachine(props2) {
    return new VanillaMachine(machine, props2);
  }
  initApi() {
    return connect(this.machine.service, normalizeProps);
  }
  render() {
    const rootEl = this.el.querySelector('[data-scope="marquee"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());
    const edgeStart = this.el.querySelector(
      '[data-scope="marquee"][data-part="edge"][data-side="start"]'
    );
    if (edgeStart) this.spreadProps(edgeStart, this.api.getEdgeProps({ side: "start" }));
    const viewport = this.el.querySelector(
      '[data-scope="marquee"][data-part="viewport"]'
    );
    if (viewport) this.spreadProps(viewport, this.api.getViewportProps());
    const contentEls = this.el.querySelectorAll(
      '[data-scope="marquee"][data-part="content"]'
    );
    contentEls.forEach((contentEl, i) => {
      this.spreadProps(contentEl, this.api.getContentProps({ index: i }));
      const itemEls = contentEl.querySelectorAll(
        '[data-scope="marquee"][data-part="item"]'
      );
      itemEls.forEach((itemEl) => {
        this.spreadProps(itemEl, this.api.getItemProps());
      });
    });
    const edgeEnd = this.el.querySelector(
      '[data-scope="marquee"][data-part="edge"][data-side="end"]'
    );
    if (edgeEnd) this.spreadProps(edgeEnd, this.api.getEdgeProps({ side: "end" }));
  }
};

// hooks/marquee.ts
var MarqueeHook = {
  mounted() {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const ariaLabel = getString(el, "ariaLabel") ?? `Marquee: ${el.id}`;
    const zag = new Marquee(el, {
      id: el.id,
      translations: { root: ariaLabel },
      duration: getNumber(el, "duration") ?? 20,
      side: getString(el, "side", [
        "start",
        "end",
        "top",
        "bottom"
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
              detail: { id: el.id, paused: details.paused }
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
      }
    });
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
      this.handleEvent("marquee_pause", (payload) => {
        const targetId = payload.marquee_id;
        if (targetId && el.id !== targetId && el.id !== `marquee:${targetId}`) return;
        zag.api.pause();
      })
    );
    this.handlers.push(
      this.handleEvent("marquee_resume", (payload) => {
        const targetId = payload.marquee_id;
        if (targetId && el.id !== targetId && el.id !== `marquee:${targetId}`) return;
        zag.api.resume();
      })
    );
    this.handlers.push(
      this.handleEvent("marquee_toggle_pause", (payload) => {
        const targetId = payload.marquee_id;
        if (targetId && el.id !== targetId && el.id !== `marquee:${targetId}`) return;
        zag.api.togglePause();
      })
    );
  },
  updated() {
    const ariaLabel = getString(this.el, "ariaLabel") ?? `Marquee: ${this.el.id}`;
    this.marquee?.updateProps({
      id: this.el.id,
      translations: { root: ariaLabel },
      duration: getNumber(this.el, "duration") ?? 20,
      side: getString(this.el, "side", [
        "start",
        "end",
        "top",
        "bottom"
      ]) ?? "end",
      speed: getNumber(this.el, "speed") ?? 50,
      spacing: getString(this.el, "spacing") ?? "1rem",
      autoFill: getBoolean(this.el, "autoFill"),
      pauseOnInteraction: getBoolean(this.el, "pauseOnInteraction"),
      defaultPaused: getBoolean(this.el, "defaultPaused"),
      delay: getNumber(this.el, "delay") ?? 0,
      loopCount: getNumber(this.el, "loopCount") ?? 0,
      reverse: getBoolean(this.el, "reverse"),
      dir: getDir(this.el)
    });
  },
  destroyed() {
    if (this.onPause) this.el.removeEventListener("phx:marquee:pause", this.onPause);
    if (this.onResume) this.el.removeEventListener("phx:marquee:resume", this.onResume);
    if (this.onTogglePause)
      this.el.removeEventListener("phx:marquee:toggle-pause", this.onTogglePause);
    if (this.handlers) {
      for (const h of this.handlers) this.removeHandleEvent(h);
    }
    this.marquee?.destroy();
  }
};
export {
  MarqueeHook as Marquee
};
