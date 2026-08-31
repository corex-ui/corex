import {
  clampValue,
  toPx
} from "./chunks/chunk-AJX2XHOK.mjs";
import {
  createAnatomy
} from "./chunks/chunk-YMOPD357.mjs";
import {
  Component,
  VanillaMachine,
  addDomEvent,
  callAll,
  compact,
  contains,
  createMachine,
  createZagLiveHook,
  dataAttr,
  ensureProps,
  getByOwnerId,
  getComputedStyle,
  getDir,
  getEventPoint,
  getEventTarget,
  isEqual,
  query,
  setStyleProperty,
  trackPointerMove
} from "./chunks/chunk-R62PCG6O.mjs";

// ../node_modules/.pnpm/@zag-js+scroll-area@1.43.3/node_modules/@zag-js/scroll-area/dist/chunk-QZ7TP4HQ.mjs
var __defProp = Object.defineProperty;
var __defNormalProp = (obj, key, value) => key in obj ? __defProp(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
var __publicField = (obj, key, value) => __defNormalProp(obj, typeof key !== "symbol" ? key + "" : key, value);

// ../node_modules/.pnpm/@zag-js+scroll-area@1.43.3/node_modules/@zag-js/scroll-area/dist/scroll-area.anatomy.mjs
var anatomy = createAnatomy("scroll-area").parts("root", "viewport", "content", "scrollbar", "thumb", "corner");
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+scroll-area@1.43.3/node_modules/@zag-js/scroll-area/dist/scroll-area.dom.mjs
var getRootId = (ctx) => ctx.ids?.root ?? `scroll-area-${ctx.id}`;
var getViewportId = (ctx) => ctx.ids?.viewport ?? `scroll-area-${ctx.id}:viewport`;
var getContentId = (ctx) => ctx.ids?.content ?? `scroll-area-${ctx.id}:content`;
var getRootEl = (ctx) => ctx.getById(getRootId(ctx));
var getViewportEl = (ctx) => ctx.getById(getViewportId(ctx));
var getContentEl = (ctx) => ctx.getById(getContentId(ctx));
var getScrollbarXEl = (ctx) => query(getRootEl(ctx), `[data-part=scrollbar][data-orientation=horizontal]${getByOwnerId(getRootId(ctx))}`);
var getScrollbarYEl = (ctx) => query(getRootEl(ctx), `[data-part=scrollbar][data-orientation=vertical]${getByOwnerId(getRootId(ctx))}`);
var getThumbXEl = (ctx) => query(getScrollbarXEl(ctx), `[data-part=thumb][data-orientation=horizontal]${getByOwnerId(getRootId(ctx))}`);
var getThumbYEl = (ctx) => query(getScrollbarYEl(ctx), `[data-part=thumb][data-orientation=vertical]${getByOwnerId(getRootId(ctx))}`);
var getCornerEl = (ctx) => query(getRootEl(ctx), `[data-part=corner]${getByOwnerId(getRootId(ctx))}`);

// ../node_modules/.pnpm/@zag-js+scroll-area@1.43.3/node_modules/@zag-js/scroll-area/dist/utils/scroll-progress.mjs
function getScrollProgress(element, scrollThreshold) {
  if (!element) return EMPTY_SCROLL_PROGRESS;
  let progressX = 0;
  let progressY = 0;
  const maxScrollX = element.scrollWidth - element.clientWidth;
  if (maxScrollX > scrollThreshold) {
    progressX = Math.min(1, Math.max(0, element.scrollLeft / maxScrollX));
  }
  const maxScrollY = element.scrollHeight - element.clientHeight;
  if (maxScrollY > scrollThreshold) {
    progressY = Math.min(1, Math.max(0, element.scrollTop / maxScrollY));
  }
  return { x: progressX, y: progressY };
}
var EMPTY_SCROLL_PROGRESS = { x: 0, y: 0 };

// ../node_modules/.pnpm/@zag-js+scroll-area@1.43.3/node_modules/@zag-js/scroll-area/dist/utils/smooth-scroll.mjs
var DURATION = 300;
var EASE_OUT_QUAD = (t) => t * (2 - t);
function smoothScroll(node, options = {}) {
  const { top, left, duration = DURATION, easing = EASE_OUT_QUAD, onComplete } = options;
  if (!node) return;
  const state = {
    startTime: 0,
    startScrollTop: node.scrollTop,
    startScrollLeft: node.scrollLeft,
    targetScrollTop: top ?? node.scrollTop,
    targetScrollLeft: left ?? node.scrollLeft
  };
  let cancelled = false;
  const cleanup = () => {
    if (state.rafId) {
      cancelAnimationFrame(state.rafId);
      state.rafId = void 0;
    }
    cancelled = true;
  };
  const animate = (currentTime) => {
    if (cancelled) return;
    if (state.startTime === 0) {
      state.startTime = currentTime;
    }
    const elapsed = currentTime - state.startTime;
    const progress = Math.min(elapsed / duration, 1);
    const easedProgress = easing(progress);
    const deltaTop = state.targetScrollTop - state.startScrollTop;
    const deltaLeft = state.targetScrollLeft - state.startScrollLeft;
    node.scrollTop = state.startScrollTop + deltaTop * easedProgress;
    node.scrollLeft = state.startScrollLeft + deltaLeft * easedProgress;
    if (progress < 1) {
      state.rafId = requestAnimationFrame(animate);
    } else {
      onComplete?.();
    }
  };
  state.rafId = requestAnimationFrame(animate);
  return cleanup;
}

// ../node_modules/.pnpm/@zag-js+scroll-area@1.43.3/node_modules/@zag-js/scroll-area/dist/utils/scroll-to.mjs
function scrollTo(node, options = {}) {
  if (!node) return;
  const { top, left, behavior = "smooth", easing, duration } = options;
  if (behavior === "smooth") {
    smoothScroll(node, { top, left, easing, duration });
  } else {
    const scrollOptions = compact({ behavior, top, left });
    node.scrollTo(scrollOptions);
  }
}

// ../node_modules/.pnpm/@zag-js+scroll-area@1.43.3/node_modules/@zag-js/scroll-area/dist/utils/scroll-to-edge.mjs
function scrollToEdge(node, edge, dir, behavior = "smooth", easing, duration) {
  if (!node) return;
  const maxLeft = node.scrollWidth - node.clientWidth;
  const maxTop = node.scrollHeight - node.clientHeight;
  const isRtl = dir === "rtl";
  let targetScrollTop;
  let targetScrollLeft;
  switch (edge) {
    case "top":
      targetScrollTop = 0;
      break;
    case "bottom":
      targetScrollTop = maxTop;
      break;
    case "left":
      if (isRtl) {
        const negative = node.scrollLeft <= 0;
        targetScrollLeft = negative ? -maxLeft : 0;
      } else {
        targetScrollLeft = 0;
      }
      break;
    case "right":
      if (isRtl) {
        const negative = node.scrollLeft <= 0;
        targetScrollLeft = negative ? 0 : maxLeft;
      } else {
        targetScrollLeft = maxLeft;
      }
      break;
  }
  if (behavior === "smooth") {
    smoothScroll(node, { top: targetScrollTop, left: targetScrollLeft, easing, duration });
  } else {
    const options = compact({ left: targetScrollLeft, top: targetScrollTop, behavior });
    node.scrollTo(options);
  }
}

// ../node_modules/.pnpm/@zag-js+scroll-area@1.43.3/node_modules/@zag-js/scroll-area/dist/scroll-area.connect.mjs
function connect(service, normalize) {
  const { state, send, context, prop, scope } = service;
  const dragging = state.matches("dragging");
  const hovering = context.get("hovering");
  const cornerSize = context.get("cornerSize");
  const thumbSize = context.get("thumbSize");
  const hiddenState = context.get("hiddenState");
  const atSides = context.get("atSides");
  return {
    isAtTop: atSides.top,
    isAtBottom: atSides.bottom,
    isAtLeft: atSides.left,
    isAtRight: atSides.right,
    hasOverflowX: !hiddenState.scrollbarXHidden,
    hasOverflowY: !hiddenState.scrollbarYHidden,
    getScrollProgress() {
      return getScrollProgress(getViewportEl(scope), 0);
    },
    scrollToEdge(details) {
      const { edge, behavior } = details;
      return scrollToEdge(getViewportEl(scope), edge, prop("dir"), behavior);
    },
    scrollTo(details) {
      return scrollTo(getViewportEl(scope), details);
    },
    getScrollbarState(props) {
      const horizontal = props.orientation === "horizontal";
      return {
        hovering,
        dragging,
        scrolling: context.get(horizontal ? "scrollingX" : "scrollingY"),
        hidden: horizontal ? hiddenState.scrollbarXHidden : hiddenState.scrollbarYHidden
      };
    },
    getRootProps() {
      return normalize.element({
        ...parts.root.attrs,
        id: getRootId(scope),
        dir: prop("dir"),
        role: "presentation",
        "data-overflow-x": dataAttr(!hiddenState.scrollbarXHidden),
        "data-overflow-y": dataAttr(!hiddenState.scrollbarYHidden),
        onPointerEnter(event) {
          const target = getEventTarget(event);
          if (!contains(event.currentTarget, target)) return;
          send({ type: "root.pointerenter", pointerType: event.pointerType });
        },
        onPointerMove(event) {
          const target = getEventTarget(event);
          if (!contains(event.currentTarget, target)) return;
          send({ type: "root.pointerenter", pointerType: event.pointerType });
        },
        onPointerDown({ pointerType }) {
          send({ type: "root.pointerdown", pointerType });
        },
        onPointerLeave(event) {
          if (contains(event.currentTarget, event.relatedTarget)) return;
          send({ type: "root.pointerleave" });
        },
        style: {
          position: "relative",
          "--corner-width": toPx(cornerSize?.width),
          "--corner-height": toPx(cornerSize?.height),
          "--thumb-width": toPx(thumbSize?.width),
          "--thumb-height": toPx(thumbSize?.height)
        }
      });
    },
    getViewportProps() {
      const handleUserInteraction = () => {
        send({ type: "user.scroll" });
      };
      return normalize.element({
        ...parts.viewport.attrs,
        role: "presentation",
        "data-ownedby": getRootId(scope),
        id: getViewportId(scope),
        "data-at-top": dataAttr(atSides.top),
        "data-at-bottom": dataAttr(atSides.bottom),
        "data-at-left": dataAttr(atSides.left),
        "data-at-right": dataAttr(atSides.right),
        "data-overflow-x": dataAttr(!hiddenState.scrollbarXHidden),
        "data-overflow-y": dataAttr(!hiddenState.scrollbarYHidden),
        tabIndex: hiddenState.scrollbarXHidden || hiddenState.scrollbarYHidden ? void 0 : 0,
        style: {
          overflow: "auto"
        },
        onScroll(event) {
          send({ type: "viewport.scroll", target: event.currentTarget });
        },
        onWheel: handleUserInteraction,
        onTouchMove: handleUserInteraction,
        onPointerMove: handleUserInteraction,
        onPointerEnter: handleUserInteraction,
        onKeyDown: handleUserInteraction
      });
    },
    getContentProps() {
      return normalize.element({
        ...parts.content.attrs,
        id: getContentId(scope),
        role: "presentation",
        "data-overflow-x": dataAttr(!hiddenState.scrollbarXHidden),
        "data-overflow-y": dataAttr(!hiddenState.scrollbarYHidden),
        style: {
          minWidth: "fit-content"
        }
      });
    },
    getScrollbarProps(props = {}) {
      const { orientation = "vertical" } = props;
      return normalize.element({
        ...parts.scrollbar.attrs,
        "data-ownedby": getRootId(scope),
        "data-orientation": orientation,
        "data-scrolling": dataAttr(context.get(orientation === "horizontal" ? "scrollingX" : "scrollingY")),
        "data-hover": dataAttr(hovering),
        "data-dragging": dataAttr(dragging),
        "data-overflow-x": dataAttr(!hiddenState.scrollbarXHidden),
        "data-overflow-y": dataAttr(!hiddenState.scrollbarYHidden),
        onPointerUp() {
          send({ type: "scrollbar.pointerup", orientation });
        },
        onPointerDown(event) {
          if (event.button !== 0) {
            return;
          }
          if (event.currentTarget !== event.target) {
            return;
          }
          const point = getEventPoint(event);
          send({ type: "scrollbar.pointerdown", orientation, point });
          event.stopPropagation();
        },
        style: {
          position: "absolute",
          touchAction: "none",
          WebkitUserSelect: "none",
          userSelect: "none",
          ...orientation === "vertical" && {
            top: 0,
            bottom: `var(--corner-height)`,
            insetInlineEnd: 0
          },
          ...orientation === "horizontal" && {
            insetInlineStart: 0,
            insetInlineEnd: `var(--corner-width)`,
            bottom: 0
          }
        }
      });
    },
    getThumbProps(props = {}) {
      const { orientation = "vertical" } = props;
      return normalize.element({
        ...parts.thumb.attrs,
        "data-ownedby": getRootId(scope),
        "data-orientation": orientation,
        "data-hover": dataAttr(hovering),
        "data-dragging": dataAttr(dragging),
        onPointerDown(event) {
          if (event.button !== 0) return;
          const point = getEventPoint(event);
          send({ type: "thumb.pointerdown", orientation, point });
        },
        style: {
          ...orientation === "vertical" && {
            height: "var(--thumb-height)"
          },
          ...orientation === "horizontal" && {
            width: "var(--thumb-width)"
          }
        }
      });
    },
    getCornerProps() {
      return normalize.element({
        ...parts.corner.attrs,
        "data-ownedby": getRootId(scope),
        "data-hover": dataAttr(hovering),
        "data-state": hiddenState.cornerHidden ? "hidden" : "visible",
        "data-overflow-x": dataAttr(!hiddenState.scrollbarXHidden),
        "data-overflow-y": dataAttr(!hiddenState.scrollbarYHidden),
        style: {
          position: "absolute",
          bottom: 0,
          insetInlineEnd: 0,
          width: "var(--corner-width)",
          height: "var(--corner-height)"
        }
      });
    }
  };
}

// ../node_modules/.pnpm/@zag-js+scroll-area@1.43.3/node_modules/@zag-js/scroll-area/dist/utils/scroll-offset.mjs
function getScrollOffset(element, prop, axis) {
  if (!element) return 0;
  const styles = getComputedStyle(element);
  const propAxis = axis === "x" ? "Inline" : "Block";
  if (axis === "x" && prop === "margin") {
    return parseFloat(styles[`${prop}InlineStart`]) * 2;
  }
  return parseFloat(styles[`${prop}${propAxis}Start`]) + parseFloat(styles[`${prop}${propAxis}End`]);
}

// ../node_modules/.pnpm/@zag-js+scroll-area@1.43.3/node_modules/@zag-js/scroll-area/dist/utils/scroll-sides.mjs
function getScrollSides(node, dir) {
  const scrollTop = node.scrollTop;
  const scrollLeft = node.scrollLeft;
  const isRtl = dir === "rtl";
  const threshold = 1;
  const hasVerticalScroll = node.scrollHeight - node.clientHeight > threshold;
  const hasHorizontalScroll = node.scrollWidth - node.clientWidth > threshold;
  const maxScrollLeft = node.scrollWidth - node.clientWidth;
  const maxScrollTop = node.scrollHeight - node.clientHeight;
  let atLeft = false;
  let atRight = false;
  let atTop = false;
  let atBottom = false;
  if (hasHorizontalScroll) {
    if (isRtl) {
      if (scrollLeft <= 0) {
        atLeft = Math.abs(scrollLeft) >= maxScrollLeft - threshold;
        atRight = Math.abs(scrollLeft) <= threshold;
      } else {
        atLeft = scrollLeft <= threshold;
        atRight = scrollLeft >= maxScrollLeft - threshold;
      }
    } else {
      atLeft = scrollLeft <= threshold;
      atRight = scrollLeft >= maxScrollLeft - threshold;
    }
  }
  if (hasVerticalScroll) {
    atTop = scrollTop <= threshold;
    atBottom = scrollTop >= maxScrollTop - threshold;
  }
  return {
    top: atTop,
    right: atRight,
    bottom: atBottom,
    left: atLeft
  };
}

// ../node_modules/.pnpm/@zag-js+scroll-area@1.43.3/node_modules/@zag-js/scroll-area/dist/utils/timeout.mjs
var EMPTY = 0;
var Timeout = class {
  constructor() {
    __publicField(this, "currentId", EMPTY);
    __publicField(this, "clear", () => {
      if (this.currentId !== EMPTY) {
        clearTimeout(this.currentId);
        this.currentId = EMPTY;
      }
    });
    __publicField(this, "disposeEffect", () => {
      return this.clear;
    });
  }
  start(delay, fn) {
    this.clear();
    this.currentId = setTimeout(() => {
      this.currentId = EMPTY;
      fn();
    }, delay);
  }
  isStarted() {
    return this.currentId !== EMPTY;
  }
};

// ../node_modules/.pnpm/@zag-js+scroll-area@1.43.3/node_modules/@zag-js/scroll-area/dist/scroll-area.machine.mjs
var MIN_THUMB_SIZE = 20;
var SCROLL_TIMEOUT = 1e3;
var machine = createMachine({
  props({ props }) {
    ensureProps(props, ["id"]);
    return props;
  },
  context({ bindable }) {
    return {
      scrollingX: bindable(() => ({ defaultValue: false })),
      scrollingY: bindable(() => ({ defaultValue: false })),
      hovering: bindable(() => ({ defaultValue: false })),
      dragging: bindable(() => ({ defaultValue: false })),
      touchModality: bindable(() => ({ defaultValue: false })),
      atSides: bindable(() => ({
        defaultValue: { top: true, right: false, bottom: false, left: true }
      })),
      cornerSize: bindable(() => ({
        defaultValue: { width: 0, height: 0 }
      })),
      thumbSize: bindable(() => ({
        defaultValue: { width: 0, height: 0 }
      })),
      hiddenState: bindable(() => ({
        defaultValue: {
          scrollbarYHidden: false,
          scrollbarXHidden: false,
          cornerHidden: false
        },
        hash(a) {
          return `Y:${a.scrollbarYHidden} X:${a.scrollbarXHidden} C:${a.cornerHidden}`;
        }
      }))
    };
  },
  refs() {
    return {
      orientation: "vertical",
      scrollPosition: { x: 0, y: 0 },
      scrollYTimeout: new Timeout(),
      scrollXTimeout: new Timeout(),
      scrollEndTimeout: new Timeout(),
      startX: 0,
      startY: 0,
      startScrollTop: 0,
      startScrollLeft: 0,
      programmaticScroll: true
    };
  },
  initialState() {
    return "idle";
  },
  watch({ track, prop, context, send }) {
    track([() => prop("dir"), () => context.hash("hiddenState")], () => {
      send({ type: "thumb.measure" });
    });
  },
  effects: ["trackContentResize", "trackViewportVisibility", "trackWheelEvent"],
  entry: ["checkHovering"],
  exit: ["clearTimeouts"],
  on: {
    "thumb.measure": {
      actions: ["setThumbSize"]
    },
    "viewport.scroll": {
      actions: ["setThumbSize", "setScrolling", "setProgrammaticScroll"]
    },
    "root.pointerenter": {
      actions: ["setTouchModality", "setHovering"]
    },
    "root.pointerdown": {
      actions: ["setTouchModality"]
    },
    "root.pointerleave": {
      actions: ["clearHovering"]
    }
  },
  states: {
    idle: {
      on: {
        "scrollbar.pointerdown": {
          target: "dragging",
          actions: ["scrollToPointer", "startDragging"]
        },
        "thumb.pointerdown": {
          target: "dragging",
          actions: ["startDragging"]
        }
      }
    },
    dragging: {
      effects: ["trackPointerMove"],
      on: {
        "thumb.pointermove": {
          actions: ["setDraggingScroll"]
        },
        "scrollbar.pointerup": {
          target: "idle",
          actions: ["stopDragging"]
        },
        "thumb.pointerup": {
          target: "idle",
          actions: ["clearScrolling", "stopDragging"]
        }
      }
    }
  },
  implementations: {
    actions: {
      setTouchModality({ context, event }) {
        context.set("touchModality", event.pointerType === "touch");
      },
      setHovering({ context }) {
        context.set("hovering", true);
      },
      clearHovering({ context }) {
        context.set("hovering", false);
      },
      setProgrammaticScroll({ refs }) {
        const scrollEndTimeout = refs.get("scrollEndTimeout");
        scrollEndTimeout.start(100, () => {
          refs.set("programmaticScroll", true);
        });
      },
      clearScrolling({ context, event }) {
        context.set(event.orientation === "vertical" ? "scrollingY" : "scrollingX", false);
      },
      setThumbSize({ context, scope, prop }) {
        const viewportEl = getViewportEl(scope);
        if (!viewportEl) return;
        const scrollableContentHeight = viewportEl.scrollHeight;
        const scrollableContentWidth = viewportEl.scrollWidth;
        if (scrollableContentHeight === 0 || scrollableContentWidth === 0) return;
        const scrollbarYEl = getScrollbarYEl(scope);
        const scrollbarXEl = getScrollbarXEl(scope);
        const thumbYEl = getThumbYEl(scope);
        const thumbXEl = getThumbXEl(scope);
        const viewportHeight = viewportEl.clientHeight;
        const viewportWidth = viewportEl.clientWidth;
        const scrollTop = viewportEl.scrollTop;
        const scrollLeft = viewportEl.scrollLeft;
        const scrollbarYHidden = viewportHeight >= scrollableContentHeight;
        const scrollbarXHidden = viewportWidth >= scrollableContentWidth;
        const ratioX = viewportWidth / scrollableContentWidth;
        const ratioY = viewportHeight / scrollableContentHeight;
        const nextWidth = scrollbarXHidden ? 0 : viewportWidth;
        const nextHeight = scrollbarYHidden ? 0 : viewportHeight;
        const scrollbarXOffset = getScrollOffset(scrollbarXEl, "padding", "x");
        const scrollbarYOffset = getScrollOffset(scrollbarYEl, "padding", "y");
        const thumbXOffset = getScrollOffset(thumbXEl, "margin", "x");
        const thumbYOffset = getScrollOffset(thumbYEl, "margin", "y");
        const idealNextWidth = nextWidth - scrollbarXOffset - thumbXOffset;
        const idealNextHeight = nextHeight - scrollbarYOffset - thumbYOffset;
        const maxNextWidth = scrollbarXEl ? Math.min(scrollbarXEl.offsetWidth, idealNextWidth) : idealNextWidth;
        const maxNextHeight = scrollbarYEl ? Math.min(scrollbarYEl.offsetHeight, idealNextHeight) : idealNextHeight;
        const clampedNextWidth = Math.max(MIN_THUMB_SIZE, maxNextWidth * ratioX);
        const clampedNextHeight = Math.max(MIN_THUMB_SIZE, maxNextHeight * ratioY);
        context.set("thumbSize", (prevSize) => {
          if (prevSize.height === clampedNextHeight && prevSize.width === clampedNextWidth) {
            return prevSize;
          }
          return {
            width: clampedNextWidth,
            height: clampedNextHeight
          };
        });
        if (scrollbarYEl && thumbYEl) {
          const maxThumbOffsetY = scrollbarYEl.offsetHeight - clampedNextHeight - scrollbarYOffset - thumbYOffset;
          const scrollRatioY = scrollTop / (scrollableContentHeight - viewportHeight);
          const thumbOffsetY = Math.min(maxThumbOffsetY, Math.max(0, scrollRatioY * maxThumbOffsetY));
          thumbYEl.style.transform = `translate3d(0,${thumbOffsetY}px,0)`;
        }
        if (scrollbarXEl && thumbXEl) {
          const maxThumbOffsetX = scrollbarXEl.offsetWidth - clampedNextWidth - scrollbarXOffset - thumbXOffset;
          const scrollRatioX = scrollLeft / (scrollableContentWidth - viewportWidth);
          const thumbOffsetX = prop("dir") === "rtl" ? clampValue(scrollRatioX * maxThumbOffsetX, -maxThumbOffsetX, 0) : clampValue(scrollRatioX * maxThumbOffsetX, 0, maxThumbOffsetX);
          thumbXEl.style.transform = `translate3d(${thumbOffsetX}px,0,0)`;
        }
        const cornerEl = getCornerEl(scope);
        if (cornerEl) {
          if (scrollbarXHidden || scrollbarYHidden) {
            context.set("cornerSize", { width: 0, height: 0 });
          } else if (!scrollbarXHidden && !scrollbarYHidden) {
            const width = scrollbarYEl?.offsetWidth || 0;
            const height = scrollbarXEl?.offsetHeight || 0;
            context.set("cornerSize", { width, height });
          }
        }
        context.set("hiddenState", (prevState) => {
          const cornerHidden = scrollbarYHidden || scrollbarXHidden;
          if (prevState.scrollbarYHidden === scrollbarYHidden && prevState.scrollbarXHidden === scrollbarXHidden && prevState.cornerHidden === cornerHidden) {
            return prevState;
          }
          return {
            scrollbarYHidden,
            scrollbarXHidden,
            cornerHidden
          };
        });
        context.set("atSides", (prev) => {
          const next = getScrollSides(viewportEl, prop("dir"));
          if (isEqual(prev, next)) return prev;
          return next;
        });
        const maxScrollTop = Math.max(0, scrollableContentHeight - viewportHeight);
        const maxScrollLeft = Math.max(0, scrollableContentWidth - viewportWidth);
        let scrollLeftFromStart = 0;
        let scrollLeftFromEnd = 0;
        if (!scrollbarXHidden) {
          if (prop("dir") === "rtl") {
            scrollLeftFromStart = clampValue(-scrollLeft, 0, maxScrollLeft);
          } else {
            scrollLeftFromStart = clampValue(scrollLeft, 0, maxScrollLeft);
          }
          scrollLeftFromEnd = maxScrollLeft - scrollLeftFromStart;
        }
        const scrollTopFromStart = !scrollbarYHidden ? clampValue(scrollTop, 0, maxScrollTop) : 0;
        const scrollTopFromEnd = !scrollbarYHidden ? maxScrollTop - scrollTopFromStart : 0;
        setStyleProperty(viewportEl, "--scroll-area-overflow-x-start", `${scrollLeftFromStart}px`);
        setStyleProperty(viewportEl, "--scroll-area-overflow-x-end", `${scrollLeftFromEnd}px`);
        setStyleProperty(viewportEl, "--scroll-area-overflow-y-start", `${scrollTopFromStart}px`);
        setStyleProperty(viewportEl, "--scroll-area-overflow-y-end", `${scrollTopFromEnd}px`);
      },
      checkHovering({ scope, context }) {
        const viewportEl = getViewportEl(scope);
        if (viewportEl?.matches(":hover")) {
          context.set("hovering", true);
        }
      },
      setScrolling({ event, refs, context, prop }) {
        const scrollPosition = {
          x: event.target.scrollLeft,
          y: event.target.scrollTop
        };
        const scrollPositionRef = refs.get("scrollPosition");
        const offsetX = scrollPosition.x - scrollPositionRef.x;
        const offsetY = scrollPosition.y - scrollPositionRef.y;
        refs.set("scrollPosition", scrollPosition);
        context.set("atSides", (prev) => {
          const next = getScrollSides(event.target, prop("dir"));
          if (isEqual(prev, next)) return prev;
          return next;
        });
        if (offsetY !== 0) {
          context.set("scrollingY", true);
          refs.get("scrollYTimeout").start(SCROLL_TIMEOUT, () => {
            context.set("scrollingY", false);
          });
        }
        if (offsetX !== 0) {
          context.set("scrollingX", true);
          refs.get("scrollXTimeout").start(SCROLL_TIMEOUT, () => {
            context.set("scrollingX", false);
          });
        }
      },
      scrollToPointer({ event, scope, prop }) {
        const viewportEl = getViewportEl(scope);
        if (!viewportEl) return;
        const thumbYRef = getThumbYEl(scope);
        const scrollbarYRef = getScrollbarYEl(scope);
        const thumbXRef = getThumbXEl(scope);
        const scrollbarXRef = getScrollbarXEl(scope);
        const client = event.point;
        if (thumbYRef && scrollbarYRef && event.orientation === "vertical") {
          const thumbYOffset = getScrollOffset(thumbYRef, "margin", "y");
          const scrollbarYOffset = getScrollOffset(scrollbarYRef, "padding", "y");
          const thumbHeight = thumbYRef.offsetHeight;
          const trackRectY = scrollbarYRef.getBoundingClientRect();
          const clickY = client.y - trackRectY.top - thumbHeight / 2 - scrollbarYOffset + thumbYOffset / 2;
          const scrollableContentHeight = viewportEl.scrollHeight;
          const viewportHeight = viewportEl.clientHeight;
          const maxThumbOffsetY = scrollbarYRef.offsetHeight - thumbHeight - scrollbarYOffset - thumbYOffset;
          const scrollRatioY = clickY / maxThumbOffsetY;
          const newScrollTop = scrollRatioY * (scrollableContentHeight - viewportHeight);
          viewportEl.scrollTop = newScrollTop;
        }
        if (thumbXRef && scrollbarXRef && event.orientation === "horizontal") {
          const thumbXOffset = getScrollOffset(thumbXRef, "margin", "x");
          const scrollbarXOffset = getScrollOffset(scrollbarXRef, "padding", "x");
          const thumbWidth = thumbXRef.offsetWidth;
          const trackRectX = scrollbarXRef.getBoundingClientRect();
          const clickX = client.x - trackRectX.left - thumbWidth / 2 - scrollbarXOffset + thumbXOffset / 2;
          const scrollableContentWidth = viewportEl.scrollWidth;
          const viewportWidth = viewportEl.clientWidth;
          const maxThumbOffsetX = scrollbarXRef.offsetWidth - thumbWidth - scrollbarXOffset - thumbXOffset;
          const scrollRatioX = clickX / maxThumbOffsetX;
          let newScrollLeft;
          if (prop("dir") === "rtl") {
            newScrollLeft = (1 - scrollRatioX) * (scrollableContentWidth - viewportWidth);
            if (viewportEl.scrollLeft <= 0) {
              newScrollLeft = -newScrollLeft;
            }
          } else {
            newScrollLeft = scrollRatioX * (scrollableContentWidth - viewportWidth);
          }
          viewportEl.scrollLeft = newScrollLeft;
        }
      },
      startDragging({ event, refs, scope }) {
        refs.set("startX", event.point.x);
        refs.set("startY", event.point.y);
        refs.set("orientation", event.orientation);
        const viewportEl = getViewportEl(scope);
        if (!viewportEl) return;
        refs.set("startScrollTop", viewportEl.scrollTop);
        refs.set("startScrollLeft", viewportEl.scrollLeft);
      },
      setDraggingScroll({ event, refs, scope, context }) {
        const startY = refs.get("startY");
        const startX = refs.get("startX");
        const startScrollTop = refs.get("startScrollTop");
        const startScrollLeft = refs.get("startScrollLeft");
        const client = event.point;
        const deltaY = client.y - startY;
        const deltaX = client.x - startX;
        const viewportEl = getViewportEl(scope);
        if (!viewportEl) return;
        const scrollableContentHeight = viewportEl.scrollHeight;
        const viewportHeight = viewportEl.clientHeight;
        const scrollableContentWidth = viewportEl.scrollWidth;
        const viewportWidth = viewportEl.clientWidth;
        const orientation = refs.get("orientation");
        const thumbYEl = getThumbYEl(scope);
        const scrollbarYEl = getScrollbarYEl(scope);
        if (thumbYEl && scrollbarYEl && orientation === "vertical") {
          const scrollbarYOffset = getScrollOffset(scrollbarYEl, "padding", "y");
          const thumbYOffset = getScrollOffset(thumbYEl, "margin", "y");
          const thumbHeight = thumbYEl.offsetHeight;
          const maxThumbOffsetY = scrollbarYEl.offsetHeight - thumbHeight - scrollbarYOffset - thumbYOffset;
          const scrollRatioY = deltaY / maxThumbOffsetY;
          viewportEl.scrollTop = startScrollTop + scrollRatioY * (scrollableContentHeight - viewportHeight);
          context.set("scrollingY", true);
          refs.get("scrollYTimeout").start(SCROLL_TIMEOUT, () => {
            context.set("scrollingY", false);
          });
        }
        const thumbXEl = getThumbXEl(scope);
        const scrollbarXEl = getScrollbarXEl(scope);
        if (thumbXEl && scrollbarXEl && orientation === "horizontal") {
          const scrollbarXOffset = getScrollOffset(scrollbarXEl, "padding", "x");
          const thumbXOffset = getScrollOffset(thumbXEl, "margin", "x");
          const thumbWidth = thumbXEl.offsetWidth;
          const maxThumbOffsetX = scrollbarXEl.offsetWidth - thumbWidth - scrollbarXOffset - thumbXOffset;
          const scrollRatioX = deltaX / maxThumbOffsetX;
          viewportEl.scrollLeft = startScrollLeft + scrollRatioX * (scrollableContentWidth - viewportWidth);
          context.set("scrollingX", true);
          refs.get("scrollXTimeout").start(SCROLL_TIMEOUT, () => {
            context.set("scrollingX", false);
          });
        }
      },
      stopDragging({ refs }) {
        refs.set("orientation", null);
      },
      clearTimeouts({ refs }) {
        refs.get("scrollYTimeout").clear();
        refs.get("scrollXTimeout").clear();
        refs.get("scrollEndTimeout").clear();
      }
    },
    effects: {
      trackContentResize({ scope, send }) {
        const contentEl = getContentEl(scope);
        const rootEl = getRootEl(scope);
        if (!contentEl || !rootEl) return;
        const win = scope.getWin();
        const obs = new win.ResizeObserver(() => {
          setTimeout(() => {
            send({ type: "thumb.measure" });
          }, 1);
        });
        obs.observe(contentEl);
        obs.observe(rootEl);
        return () => {
          obs.disconnect();
        };
      },
      trackViewportVisibility({ scope, send }) {
        const win = scope.getWin();
        const viewportEl = getViewportEl(scope);
        if (!viewportEl) return;
        const observer = new win.IntersectionObserver((entries) => {
          entries.forEach((entry) => {
            if (entry.intersectionRatio > 0) {
              send({ type: "thumb.measure" });
              observer.disconnect();
            }
          });
        });
        observer.observe(viewportEl);
        return () => {
          observer.disconnect();
        };
      },
      trackWheelEvent({ scope }) {
        const scrollbarYEl = getScrollbarYEl(scope);
        const scrollbarXEl = getScrollbarXEl(scope);
        if (!scrollbarYEl && !scrollbarXEl) return;
        const onWheel = (event) => {
          const viewportEl = getViewportEl(scope);
          if (!viewportEl || event.ctrlKey) return;
          const orientation = event.currentTarget.dataset.orientation;
          if (orientation === "vertical") {
            const canScrollY = viewportEl.scrollHeight > viewportEl.clientHeight;
            const atTop = viewportEl.scrollTop === 0 && event.deltaY < 0;
            const atBottom = viewportEl.scrollTop === viewportEl.scrollHeight - viewportEl.clientHeight && event.deltaY > 0;
            const shouldScroll = canScrollY && event.deltaY !== 0 && !(atTop || atBottom);
            if (!shouldScroll) return;
            event.preventDefault();
            viewportEl.scrollTop += event.deltaY;
          } else if (orientation === "horizontal") {
            const canScrollX = viewportEl.scrollWidth > viewportEl.clientWidth;
            const atLeft = viewportEl.scrollLeft === 0 && event.deltaX < 0;
            const atRight = viewportEl.scrollLeft === viewportEl.scrollWidth - viewportEl.clientWidth && event.deltaX > 0;
            const shouldScroll = canScrollX && event.deltaX !== 0 && !(atLeft || atRight);
            if (!shouldScroll) return;
            event.preventDefault();
            viewportEl.scrollLeft += event.deltaX;
          }
        };
        return callAll(
          scrollbarYEl && addDomEvent(scrollbarYEl, "wheel", onWheel, { passive: false }),
          scrollbarXEl && addDomEvent(scrollbarXEl, "wheel", onWheel, { passive: false })
        );
      },
      trackPointerMove({ scope, send, refs }) {
        const doc = scope.getDoc();
        const orientation = refs.get("orientation");
        return trackPointerMove(doc, {
          onPointerMove({ point }) {
            send({ type: "thumb.pointermove", orientation, point });
          },
          onPointerUp() {
            send({ type: "thumb.pointerup", orientation });
          }
        });
      }
    }
  }
});

// components/scroll-area.ts
var ScrollArea = class extends Component {
  initMachine(props) {
    return new VanillaMachine(machine, props);
  }
  initApi() {
    return this.zagConnect(connect);
  }
  render() {
    const root = this.el.querySelector('[data-scope="scroll-area"][data-part="root"]') ?? this.el;
    this.spreadProps(root, this.api.getRootProps());
    const viewport = this.el.querySelector(
      '[data-scope="scroll-area"][data-part="viewport"]'
    );
    if (viewport) this.spreadProps(viewport, this.api.getViewportProps());
    const content = this.el.querySelector(
      '[data-scope="scroll-area"][data-part="content"]'
    );
    if (content) this.spreadProps(content, this.api.getContentProps());
    this.el.querySelectorAll('[data-scope="scroll-area"][data-part="scrollbar"]').forEach((scrollbar) => {
      const orientation = scrollbar.dataset.orientation ?? "vertical";
      this.spreadProps(scrollbar, this.api.getScrollbarProps({ orientation }));
    });
    this.el.querySelectorAll('[data-scope="scroll-area"][data-part="thumb"]').forEach((thumb) => {
      const orientation = thumb.dataset.orientation ?? "vertical";
      this.spreadProps(thumb, this.api.getThumbProps({ orientation }));
    });
    const corner = this.el.querySelector(
      '[data-scope="scroll-area"][data-part="corner"]'
    );
    if (corner) this.spreadProps(corner, this.api.getCornerProps());
  }
};

// hooks/scroll-area.ts
function scrollAreaProps(el, _hook) {
  return {
    id: el.id,
    dir: getDir(el)
  };
}
var ScrollAreaHook = createZagLiveHook({
  key: "scroll-area",
  mount(hook) {
    return new ScrollArea(hook.el, scrollAreaProps(hook.el, hook));
  },
  update(hook, inst) {
    inst.updateProps(scrollAreaProps(hook.el, hook));
  }
});
export {
  ScrollAreaHook as ScrollArea
};
