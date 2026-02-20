import {
  Component,
  VanillaMachine,
  add,
  addDomEvent,
  ariaAttr,
  callAll,
  clampValue,
  contains,
  createAnatomy,
  createMachine,
  createProps,
  createSplitProps,
  dataAttr,
  ensureProps,
  getBoolean,
  getComputedStyle as getComputedStyle2,
  getDir,
  getEventKey,
  getEventTarget,
  getNumber,
  getString,
  getTabbables,
  isFocusable,
  isLeftClick,
  isObject,
  nextIndex,
  normalizeProps,
  prevIndex,
  queryAll,
  raf,
  remove,
  resizeObserverBorderBox,
  throttle,
  trackPointerMove,
  uniq
} from "./chunk-TZXIWZZ7.mjs";

// ../node_modules/.pnpm/@zag-js+scroll-snap@1.34.0/node_modules/@zag-js/scroll-snap/dist/index.mjs
var getDirection = (element) => getComputedStyle2(element).direction;
function getScrollPadding(element) {
  const style = getComputedStyle2(element);
  const rect = element.getBoundingClientRect();
  let xBeforeRaw = style.getPropertyValue("scroll-padding-left").replace("auto", "0px");
  let yBeforeRaw = style.getPropertyValue("scroll-padding-top").replace("auto", "0px");
  let xAfterRaw = style.getPropertyValue("scroll-padding-right").replace("auto", "0px");
  let yAfterRaw = style.getPropertyValue("scroll-padding-bottom").replace("auto", "0px");
  function convert(raw, size) {
    let n = parseFloat(raw);
    if (/%/.test(raw)) {
      n /= 100;
      n *= size;
    }
    return Number.isNaN(n) ? 0 : n;
  }
  let xBefore = convert(xBeforeRaw, rect.width);
  let yBefore = convert(yBeforeRaw, rect.height);
  let xAfter = convert(xAfterRaw, rect.width);
  let yAfter = convert(yAfterRaw, rect.height);
  return {
    x: { before: xBefore, after: xAfter },
    y: { before: yBefore, after: yAfter }
  };
}
function isRectIntersecting(a, b, axis = "both") {
  return axis === "x" && a.right >= b.left && a.left <= b.right || axis === "y" && a.bottom >= b.top && a.top <= b.bottom || axis === "both" && a.right >= b.left && a.left <= b.right && a.bottom >= b.top && a.top <= b.bottom;
}
function getDescendants(parent) {
  let children = [];
  for (const child of parent.children) {
    children = children.concat(child, getDescendants(child));
  }
  return children;
}
function getSnapPositions(parent, subtree = false) {
  const parentRect = parent.getBoundingClientRect();
  const dir = getDirection(parent);
  const isRtl = dir === "rtl";
  const positions = {
    x: { start: [], center: [], end: [] },
    y: { start: [], center: [], end: [] }
  };
  const children = subtree ? getDescendants(parent) : parent.children;
  for (const axis of ["x", "y"]) {
    const orthogonalAxis = axis === "x" ? "y" : "x";
    const axisStart = axis === "x" ? "left" : "top";
    const axisEnd = axis === "x" ? "right" : "bottom";
    const axisSize = axis === "x" ? "width" : "height";
    const axisScroll = axis === "x" ? "scrollLeft" : "scrollTop";
    const useRtlCalc = isRtl && axis === "x";
    for (const child of children) {
      const childRect = child.getBoundingClientRect();
      if (!isRectIntersecting(parentRect, childRect, orthogonalAxis)) {
        continue;
      }
      const childStyle = getComputedStyle2(child);
      let [childAlignY, childAlignX] = childStyle.getPropertyValue("scroll-snap-align").split(" ");
      if (typeof childAlignX === "undefined") {
        childAlignX = childAlignY;
      }
      const childAlign = axis === "x" ? childAlignX : childAlignY;
      let childOffsetStart;
      let childOffsetEnd;
      let childOffsetCenter;
      if (useRtlCalc) {
        const scrollOffset = Math.abs(parent[axisScroll]);
        const rightOffset = parentRect[axisEnd] - childRect[axisEnd] + scrollOffset;
        childOffsetStart = rightOffset;
        childOffsetEnd = rightOffset + childRect[axisSize];
        childOffsetCenter = rightOffset + childRect[axisSize] / 2;
      } else {
        childOffsetStart = childRect[axisStart] - parentRect[axisStart] + parent[axisScroll];
        childOffsetEnd = childOffsetStart + childRect[axisSize];
        childOffsetCenter = childOffsetStart + childRect[axisSize] / 2;
      }
      switch (childAlign) {
        case "none":
          break;
        case "start":
          positions[axis].start.push({ node: child, position: childOffsetStart });
          break;
        case "center":
          positions[axis].center.push({ node: child, position: childOffsetCenter });
          break;
        case "end":
          positions[axis].end.push({ node: child, position: childOffsetEnd });
          break;
      }
    }
  }
  return positions;
}
function getScrollSnapPositions(element) {
  const dir = getDirection(element);
  const rect = element.getBoundingClientRect();
  const scrollPadding = getScrollPadding(element);
  const snapPositions = getSnapPositions(element);
  const maxScroll = {
    x: element.scrollWidth - element.offsetWidth,
    y: element.scrollHeight - element.offsetHeight
  };
  const isRtl = dir === "rtl";
  const usesNegativeScrollLeft = isRtl && element.scrollLeft <= 0;
  let xPositions;
  if (isRtl) {
    xPositions = uniq2(
      [
        ...snapPositions.x.start.map((v) => v.position - scrollPadding.x.after),
        ...snapPositions.x.center.map((v) => v.position - rect.width / 2),
        ...snapPositions.x.end.map((v) => v.position - rect.width + scrollPadding.x.before)
      ].map(clamp(0, maxScroll.x))
    );
    if (usesNegativeScrollLeft) {
      xPositions = xPositions.map((pos) => -pos);
    }
  } else {
    xPositions = uniq2(
      [
        ...snapPositions.x.start.map((v) => v.position - scrollPadding.x.before),
        ...snapPositions.x.center.map((v) => v.position - rect.width / 2),
        ...snapPositions.x.end.map((v) => v.position - rect.width + scrollPadding.x.after)
      ].map(clamp(0, maxScroll.x))
    );
  }
  return {
    x: xPositions,
    y: uniq2(
      [
        ...snapPositions.y.start.map((v) => v.position - scrollPadding.y.before),
        ...snapPositions.y.center.map((v) => v.position - rect.height / 2),
        ...snapPositions.y.end.map((v) => v.position - rect.height + scrollPadding.y.after)
      ].map(clamp(0, maxScroll.y))
    )
  };
}
function findSnapPoint(parent, axis, predicate) {
  const dir = getDirection(parent);
  const scrollPadding = getScrollPadding(parent);
  const snapPositions = getSnapPositions(parent);
  const items = [...snapPositions[axis].start, ...snapPositions[axis].center, ...snapPositions[axis].end];
  const isRtl = dir === "rtl";
  const usesNegativeScrollLeft = isRtl && axis === "x" && parent.scrollLeft <= 0;
  for (const item of items) {
    if (predicate(item.node)) {
      let position;
      if (axis === "x" && isRtl) {
        position = item.position - scrollPadding.x.after;
        if (usesNegativeScrollLeft) {
          position = -position;
        }
      } else {
        position = item.position - (axis === "x" ? scrollPadding.x.before : scrollPadding.y.before);
      }
      return position;
    }
  }
}
var uniq2 = (arr) => [...new Set(arr)];
var clamp = (min, max) => (value) => Math.max(min, Math.min(max, value));

// ../node_modules/.pnpm/@zag-js+carousel@1.34.0/node_modules/@zag-js/carousel/dist/index.mjs
var anatomy = createAnatomy("carousel").parts(
  "root",
  "itemGroup",
  "item",
  "control",
  "nextTrigger",
  "prevTrigger",
  "indicatorGroup",
  "indicator",
  "autoplayTrigger",
  "progressText"
);
var parts = anatomy.build();
var getRootId = (ctx) => ctx.ids?.root ?? `carousel:${ctx.id}`;
var getItemId = (ctx, index) => ctx.ids?.item?.(index) ?? `carousel:${ctx.id}:item:${index}`;
var getItemGroupId = (ctx) => ctx.ids?.itemGroup ?? `carousel:${ctx.id}:item-group`;
var getNextTriggerId = (ctx) => ctx.ids?.nextTrigger ?? `carousel:${ctx.id}:next-trigger`;
var getPrevTriggerId = (ctx) => ctx.ids?.prevTrigger ?? `carousel:${ctx.id}:prev-trigger`;
var getIndicatorGroupId = (ctx) => ctx.ids?.indicatorGroup ?? `carousel:${ctx.id}:indicator-group`;
var getIndicatorId = (ctx, index) => ctx.ids?.indicator?.(index) ?? `carousel:${ctx.id}:indicator:${index}`;
var getItemGroupEl = (ctx) => ctx.getById(getItemGroupId(ctx));
var getItemEls = (ctx) => queryAll(getItemGroupEl(ctx), `[data-part=item]`);
var getIndicatorEl = (ctx, page) => ctx.getById(getIndicatorId(ctx, page));
var syncTabIndex = (ctx) => {
  const el = getItemGroupEl(ctx);
  if (!el) return;
  const tabbables = getTabbables(el);
  el.setAttribute("tabindex", tabbables.length > 0 ? "-1" : "0");
};
function connect(service, normalize) {
  const { state, context, computed, send, scope, prop } = service;
  const isPlaying = state.matches("autoplay");
  const isDragging = state.matches("dragging");
  const canScrollNext = computed("canScrollNext");
  const canScrollPrev = computed("canScrollPrev");
  const horizontal = computed("isHorizontal");
  const autoSize = prop("autoSize");
  const pageSnapPoints = Array.from(context.get("pageSnapPoints"));
  const page = context.get("page");
  const slidesPerPage = prop("slidesPerPage");
  const padding = prop("padding");
  const translations = prop("translations");
  return {
    isPlaying,
    isDragging,
    page,
    pageSnapPoints,
    canScrollNext,
    canScrollPrev,
    getProgress() {
      return page / pageSnapPoints.length;
    },
    getProgressText() {
      const details = { page: page + 1, totalPages: pageSnapPoints.length };
      return translations.progressText?.(details) ?? "";
    },
    scrollToIndex(index, instant) {
      send({ type: "INDEX.SET", index, instant });
    },
    scrollTo(index, instant) {
      send({ type: "PAGE.SET", index, instant });
    },
    scrollNext(instant) {
      send({ type: "PAGE.NEXT", instant });
    },
    scrollPrev(instant) {
      send({ type: "PAGE.PREV", instant });
    },
    play() {
      send({ type: "AUTOPLAY.START" });
    },
    pause() {
      send({ type: "AUTOPLAY.PAUSE" });
    },
    isInView(index) {
      return Array.from(context.get("slidesInView")).includes(index);
    },
    refresh() {
      send({ type: "SNAP.REFRESH" });
    },
    getRootProps() {
      return normalize.element({
        ...parts.root.attrs,
        id: getRootId(scope),
        role: "region",
        "aria-roledescription": "carousel",
        "data-orientation": prop("orientation"),
        dir: prop("dir"),
        style: {
          "--slides-per-page": slidesPerPage,
          "--slide-spacing": prop("spacing"),
          "--slide-item-size": autoSize ? "auto" : "calc(100% / var(--slides-per-page) - var(--slide-spacing) * (var(--slides-per-page) - 1) / var(--slides-per-page))"
        }
      });
    },
    getItemGroupProps() {
      return normalize.element({
        ...parts.itemGroup.attrs,
        id: getItemGroupId(scope),
        "data-orientation": prop("orientation"),
        "data-dragging": dataAttr(isDragging),
        dir: prop("dir"),
        "aria-live": isPlaying ? "off" : "polite",
        onFocus(event) {
          if (!contains(event.currentTarget, getEventTarget(event))) return;
          send({ type: "VIEWPORT.FOCUS" });
        },
        onBlur(event) {
          if (contains(event.currentTarget, event.relatedTarget)) return;
          send({ type: "VIEWPORT.BLUR" });
        },
        onMouseDown(event) {
          if (event.defaultPrevented) return;
          if (!prop("allowMouseDrag")) return;
          if (!isLeftClick(event)) return;
          const target = getEventTarget(event);
          if (isFocusable(target) && target !== event.currentTarget) return;
          event.preventDefault();
          send({ type: "DRAGGING.START" });
        },
        onWheel: throttle((event) => {
          const axis = prop("orientation") === "horizontal" ? "deltaX" : "deltaY";
          const isScrollingLeft = event[axis] < 0;
          if (isScrollingLeft && !computed("canScrollPrev")) return;
          const isScrollingRight = event[axis] > 0;
          if (isScrollingRight && !computed("canScrollNext")) return;
          send({ type: "USER.SCROLL" });
        }, 150),
        onTouchStart() {
          send({ type: "USER.SCROLL" });
        },
        style: {
          display: autoSize ? "flex" : "grid",
          gap: "var(--slide-spacing)",
          scrollSnapType: [horizontal ? "x" : "y", prop("snapType")].join(" "),
          gridAutoFlow: horizontal ? "column" : "row",
          scrollbarWidth: "none",
          overscrollBehaviorX: "contain",
          [horizontal ? "gridAutoColumns" : "gridAutoRows"]: autoSize ? void 0 : "var(--slide-item-size)",
          [horizontal ? "scrollPaddingInline" : "scrollPaddingBlock"]: padding,
          [horizontal ? "paddingInline" : "paddingBlock"]: padding,
          [horizontal ? "overflowX" : "overflowY"]: "auto"
        }
      });
    },
    getItemProps(props2) {
      const isInView = context.get("slidesInView").includes(props2.index);
      return normalize.element({
        ...parts.item.attrs,
        id: getItemId(scope, props2.index),
        dir: prop("dir"),
        role: "group",
        "data-index": props2.index,
        "data-inview": dataAttr(isInView),
        "aria-roledescription": "slide",
        "data-orientation": prop("orientation"),
        "aria-label": translations.item(props2.index, prop("slideCount")),
        "aria-hidden": ariaAttr(!isInView),
        style: {
          flex: "0 0 auto",
          [horizontal ? "maxWidth" : "maxHeight"]: "100%",
          scrollSnapAlign: (() => {
            const snapAlign = props2.snapAlign ?? "start";
            const slidesPerMove = prop("slidesPerMove");
            const perMove = slidesPerMove === "auto" ? Math.floor(prop("slidesPerPage")) : slidesPerMove;
            const shouldSnap = (props2.index + perMove) % perMove === 0;
            return shouldSnap ? snapAlign : void 0;
          })()
        }
      });
    },
    getControlProps() {
      return normalize.element({
        ...parts.control.attrs,
        "data-orientation": prop("orientation")
      });
    },
    getPrevTriggerProps() {
      return normalize.button({
        ...parts.prevTrigger.attrs,
        id: getPrevTriggerId(scope),
        type: "button",
        disabled: !canScrollPrev,
        dir: prop("dir"),
        "aria-label": translations.prevTrigger,
        "data-orientation": prop("orientation"),
        "aria-controls": getItemGroupId(scope),
        onClick(event) {
          if (event.defaultPrevented) return;
          send({ type: "PAGE.PREV", src: "trigger" });
        }
      });
    },
    getNextTriggerProps() {
      return normalize.button({
        ...parts.nextTrigger.attrs,
        dir: prop("dir"),
        id: getNextTriggerId(scope),
        type: "button",
        "aria-label": translations.nextTrigger,
        "data-orientation": prop("orientation"),
        "aria-controls": getItemGroupId(scope),
        disabled: !canScrollNext,
        onClick(event) {
          if (event.defaultPrevented) return;
          send({ type: "PAGE.NEXT", src: "trigger" });
        }
      });
    },
    getIndicatorGroupProps() {
      return normalize.element({
        ...parts.indicatorGroup.attrs,
        dir: prop("dir"),
        id: getIndicatorGroupId(scope),
        "data-orientation": prop("orientation"),
        onKeyDown(event) {
          if (event.defaultPrevented) return;
          const src = "indicator";
          const keyMap = {
            ArrowDown(event2) {
              if (horizontal) return;
              send({ type: "PAGE.NEXT", src });
              event2.preventDefault();
            },
            ArrowUp(event2) {
              if (horizontal) return;
              send({ type: "PAGE.PREV", src });
              event2.preventDefault();
            },
            ArrowRight(event2) {
              if (!horizontal) return;
              send({ type: "PAGE.NEXT", src });
              event2.preventDefault();
            },
            ArrowLeft(event2) {
              if (!horizontal) return;
              send({ type: "PAGE.PREV", src });
              event2.preventDefault();
            },
            Home(event2) {
              send({ type: "PAGE.SET", index: 0, src });
              event2.preventDefault();
            },
            End(event2) {
              send({ type: "PAGE.SET", index: pageSnapPoints.length - 1, src });
              event2.preventDefault();
            }
          };
          const key = getEventKey(event, {
            dir: prop("dir"),
            orientation: prop("orientation")
          });
          const exec = keyMap[key];
          exec?.(event);
        }
      });
    },
    getIndicatorProps(props2) {
      return normalize.button({
        ...parts.indicator.attrs,
        dir: prop("dir"),
        id: getIndicatorId(scope, props2.index),
        type: "button",
        "data-orientation": prop("orientation"),
        "data-index": props2.index,
        "data-readonly": dataAttr(props2.readOnly),
        "data-current": dataAttr(props2.index === page),
        "aria-label": translations.indicator(props2.index),
        onClick(event) {
          if (event.defaultPrevented) return;
          if (props2.readOnly) return;
          send({ type: "PAGE.SET", index: props2.index, src: "indicator" });
        }
      });
    },
    getAutoplayTriggerProps() {
      return normalize.button({
        ...parts.autoplayTrigger.attrs,
        type: "button",
        "data-orientation": prop("orientation"),
        "data-pressed": dataAttr(isPlaying),
        "aria-label": isPlaying ? translations.autoplayStop : translations.autoplayStart,
        onClick(event) {
          if (event.defaultPrevented) return;
          send({ type: isPlaying ? "AUTOPLAY.PAUSE" : "AUTOPLAY.START" });
        }
      });
    },
    getProgressTextProps() {
      return normalize.element({
        ...parts.progressText.attrs
      });
    }
  };
}
var machine = createMachine({
  props({ props: props2 }) {
    ensureProps(props2, ["slideCount"], "carousel");
    return {
      dir: "ltr",
      defaultPage: 0,
      orientation: "horizontal",
      snapType: "mandatory",
      loop: !!props2.autoplay,
      slidesPerPage: 1,
      slidesPerMove: "auto",
      spacing: "0px",
      autoplay: false,
      allowMouseDrag: false,
      inViewThreshold: 0.6,
      autoSize: false,
      ...props2,
      translations: {
        nextTrigger: "Next slide",
        prevTrigger: "Previous slide",
        indicator: (index) => `Go to slide ${index + 1}`,
        item: (index, count) => `${index + 1} of ${count}`,
        autoplayStart: "Start slide rotation",
        autoplayStop: "Stop slide rotation",
        progressText: ({ page, totalPages }) => `${page} / ${totalPages}`,
        ...props2.translations
      }
    };
  },
  refs() {
    return {
      timeoutRef: void 0
    };
  },
  initialState({ prop }) {
    return prop("autoplay") ? "autoplay" : "idle";
  },
  context({ prop, bindable, getContext }) {
    return {
      page: bindable(() => ({
        defaultValue: prop("defaultPage"),
        value: prop("page"),
        onChange(page) {
          const ctx = getContext();
          const pageSnapPoints = ctx.get("pageSnapPoints");
          prop("onPageChange")?.({ page, pageSnapPoint: pageSnapPoints[page] });
        }
      })),
      pageSnapPoints: bindable(() => {
        return {
          defaultValue: prop("autoSize") ? Array.from({ length: prop("slideCount") }, (_, i) => i) : getPageSnapPoints(prop("slideCount"), prop("slidesPerMove"), prop("slidesPerPage"))
        };
      }),
      slidesInView: bindable(() => ({
        defaultValue: []
      }))
    };
  },
  computed: {
    isRtl: ({ prop }) => prop("dir") === "rtl",
    isHorizontal: ({ prop }) => prop("orientation") === "horizontal",
    canScrollNext: ({ prop, context }) => prop("loop") || context.get("page") < context.get("pageSnapPoints").length - 1,
    canScrollPrev: ({ prop, context }) => prop("loop") || context.get("page") > 0,
    autoplayInterval: ({ prop }) => {
      const autoplay = prop("autoplay");
      return isObject(autoplay) ? autoplay.delay : 4e3;
    }
  },
  watch({ track, action, context, prop, send }) {
    track([() => prop("slidesPerPage"), () => prop("slidesPerMove")], () => {
      action(["setSnapPoints"]);
    });
    track([() => context.get("page")], () => {
      action(["scrollToPage", "focusIndicatorEl"]);
    });
    track([() => prop("orientation"), () => prop("autoSize"), () => prop("dir")], () => {
      action(["setSnapPoints", "scrollToPage"]);
    });
    track([() => prop("slideCount")], () => {
      send({ type: "SNAP.REFRESH", src: "slide.count" });
    });
    track([() => !!prop("autoplay")], () => {
      send({ type: prop("autoplay") ? "AUTOPLAY.START" : "AUTOPLAY.PAUSE", src: "autoplay.prop.change" });
    });
  },
  on: {
    "PAGE.NEXT": {
      target: "idle",
      actions: ["clearScrollEndTimer", "setNextPage"]
    },
    "PAGE.PREV": {
      target: "idle",
      actions: ["clearScrollEndTimer", "setPrevPage"]
    },
    "PAGE.SET": {
      target: "idle",
      actions: ["clearScrollEndTimer", "setPage"]
    },
    "INDEX.SET": {
      target: "idle",
      actions: ["clearScrollEndTimer", "setMatchingPage"]
    },
    "SNAP.REFRESH": {
      actions: ["setSnapPoints", "clampPage"]
    },
    "PAGE.SCROLL": {
      actions: ["scrollToPage"]
    }
  },
  effects: ["trackSlideMutation", "trackSlideIntersections", "trackSlideResize"],
  entry: ["setSnapPoints", "setPage"],
  exit: ["clearScrollEndTimer"],
  states: {
    idle: {
      on: {
        "DRAGGING.START": {
          target: "dragging",
          actions: ["invokeDragStart"]
        },
        "AUTOPLAY.START": {
          target: "autoplay",
          actions: ["invokeAutoplayStart"]
        },
        "USER.SCROLL": {
          target: "userScroll"
        },
        "VIEWPORT.FOCUS": {
          target: "focus"
        }
      }
    },
    focus: {
      effects: ["trackKeyboardScroll"],
      on: {
        "VIEWPORT.BLUR": {
          target: "idle"
        },
        "PAGE.NEXT": {
          actions: ["clearScrollEndTimer", "setNextPage"]
        },
        "PAGE.PREV": {
          actions: ["clearScrollEndTimer", "setPrevPage"]
        },
        "PAGE.SET": {
          actions: ["clearScrollEndTimer", "setPage"]
        },
        "INDEX.SET": {
          actions: ["clearScrollEndTimer", "setMatchingPage"]
        },
        "USER.SCROLL": {
          target: "userScroll"
        }
      }
    },
    dragging: {
      effects: ["trackPointerMove"],
      entry: ["disableScrollSnap"],
      on: {
        DRAGGING: {
          actions: ["scrollSlides", "invokeDragging"]
        },
        "DRAGGING.END": {
          target: "idle",
          actions: ["endDragging", "invokeDraggingEnd"]
        }
      }
    },
    userScroll: {
      effects: ["trackScroll"],
      on: {
        "DRAGGING.START": {
          target: "dragging",
          actions: ["invokeDragStart"]
        },
        "SCROLL.END": [
          {
            guard: "isFocused",
            target: "focus",
            actions: ["setClosestPage"]
          },
          {
            target: "idle",
            actions: ["setClosestPage"]
          }
        ]
      }
    },
    autoplay: {
      effects: ["trackDocumentVisibility", "trackScroll", "autoUpdateSlide"],
      exit: ["invokeAutoplayEnd"],
      on: {
        "AUTOPLAY.TICK": {
          actions: ["setNextPage", "invokeAutoplay"]
        },
        "DRAGGING.START": {
          target: "dragging",
          actions: ["invokeDragStart"]
        },
        "AUTOPLAY.PAUSE": {
          target: "idle"
        }
      }
    }
  },
  implementations: {
    guards: {
      isFocused: ({ scope }) => scope.isActiveElement(getItemGroupEl(scope))
    },
    effects: {
      autoUpdateSlide({ computed, send }) {
        const id = setInterval(() => {
          send({
            type: computed("canScrollNext") ? "AUTOPLAY.TICK" : "AUTOPLAY.PAUSE",
            src: "autoplay.interval"
          });
        }, computed("autoplayInterval"));
        return () => clearInterval(id);
      },
      trackSlideMutation({ scope, send }) {
        const el = getItemGroupEl(scope);
        if (!el) return;
        const win = scope.getWin();
        const observer = new win.MutationObserver(() => {
          send({ type: "SNAP.REFRESH", src: "slide.mutation" });
          syncTabIndex(scope);
        });
        syncTabIndex(scope);
        observer.observe(el, { childList: true, subtree: true });
        return () => observer.disconnect();
      },
      trackSlideResize({ scope, send }) {
        const el = getItemGroupEl(scope);
        if (!el) return;
        const exec = () => {
          send({ type: "SNAP.REFRESH", src: "slide.resize" });
        };
        raf(() => {
          exec();
          raf(() => {
            send({ type: "PAGE.SCROLL", instant: true });
          });
        });
        const itemEls = getItemEls(scope);
        itemEls.forEach(exec);
        const cleanups = itemEls.map((el2) => resizeObserverBorderBox.observe(el2, exec));
        return callAll(...cleanups);
      },
      trackSlideIntersections({ scope, prop, context }) {
        const el = getItemGroupEl(scope);
        const win = scope.getWin();
        const observer = new win.IntersectionObserver(
          (entries) => {
            const slidesInView = entries.reduce((acc, entry) => {
              const target = entry.target;
              const index = Number(target.dataset.index ?? "-1");
              if (index == null || Number.isNaN(index) || index === -1) return acc;
              return entry.isIntersecting ? add(acc, index) : remove(acc, index);
            }, context.get("slidesInView"));
            context.set("slidesInView", uniq(slidesInView));
          },
          {
            root: el,
            threshold: prop("inViewThreshold")
          }
        );
        getItemEls(scope).forEach((slide) => observer.observe(slide));
        return () => observer.disconnect();
      },
      trackScroll({ send, refs, scope }) {
        const el = getItemGroupEl(scope);
        if (!el) return;
        const onScroll = () => {
          clearTimeout(refs.get("timeoutRef"));
          refs.set("timeoutRef", void 0);
          refs.set(
            "timeoutRef",
            setTimeout(() => {
              send({ type: "SCROLL.END" });
            }, 150)
          );
        };
        return addDomEvent(el, "scroll", onScroll, { passive: true });
      },
      trackDocumentVisibility({ scope, send }) {
        const doc = scope.getDoc();
        const onVisibilityChange = () => {
          if (doc.visibilityState === "visible") return;
          send({ type: "AUTOPLAY.PAUSE", src: "doc.hidden" });
        };
        return addDomEvent(doc, "visibilitychange", onVisibilityChange);
      },
      trackPointerMove({ scope, send }) {
        const doc = scope.getDoc();
        return trackPointerMove(doc, {
          onPointerMove({ event }) {
            send({ type: "DRAGGING", left: -event.movementX, top: -event.movementY });
          },
          onPointerUp() {
            send({ type: "DRAGGING.END" });
          }
        });
      },
      trackKeyboardScroll({ scope, send, context }) {
        const win = scope.getWin();
        const onKeyDown = (event) => {
          switch (event.key) {
            case "ArrowRight":
              event.preventDefault();
              send({ type: "PAGE.NEXT" });
              break;
            case "ArrowLeft":
              event.preventDefault();
              send({ type: "PAGE.PREV" });
              break;
            case "Home":
              event.preventDefault();
              send({ type: "PAGE.SET", index: 0 });
              break;
            case "End":
              event.preventDefault();
              send({ type: "PAGE.SET", index: context.get("pageSnapPoints").length - 1 });
          }
        };
        return addDomEvent(win, "keydown", onKeyDown, { capture: true });
      }
    },
    actions: {
      clearScrollEndTimer({ refs }) {
        if (refs.get("timeoutRef") == null) return;
        clearTimeout(refs.get("timeoutRef"));
        refs.set("timeoutRef", void 0);
      },
      scrollToPage({ context, event, scope, computed, flush }) {
        const behavior = event.instant ? "instant" : "smooth";
        const index = clampValue(event.index ?? context.get("page"), 0, context.get("pageSnapPoints").length - 1);
        const el = getItemGroupEl(scope);
        if (!el) return;
        const axis = computed("isHorizontal") ? "left" : "top";
        flush(() => {
          el.scrollTo({ [axis]: context.get("pageSnapPoints")[index], behavior });
        });
      },
      setClosestPage({ context, scope, computed }) {
        const el = getItemGroupEl(scope);
        if (!el) return;
        const scrollPosition = computed("isHorizontal") ? el.scrollLeft : el.scrollTop;
        const page = context.get("pageSnapPoints").findIndex((point) => Math.abs(point - scrollPosition) < 1);
        if (page === -1) return;
        context.set("page", page);
      },
      setNextPage({ context, prop, state }) {
        const loop = state.matches("autoplay") || prop("loop");
        const page = nextIndex(context.get("pageSnapPoints"), context.get("page"), { loop });
        context.set("page", page);
      },
      setPrevPage({ context, prop, state }) {
        const loop = state.matches("autoplay") || prop("loop");
        const page = prevIndex(context.get("pageSnapPoints"), context.get("page"), { loop });
        context.set("page", page);
      },
      setMatchingPage({ context, event, computed, scope }) {
        const el = getItemGroupEl(scope);
        if (!el) return;
        const snapPoint = findSnapPoint(
          el,
          computed("isHorizontal") ? "x" : "y",
          (node) => node.dataset.index === event.index.toString()
        );
        if (snapPoint == null) return;
        const page = context.get("pageSnapPoints").findIndex((point) => Math.abs(point - snapPoint) < 1);
        context.set("page", page);
      },
      setPage({ context, event }) {
        const page = event.index ?? context.get("page");
        context.set("page", page);
      },
      clampPage({ context }) {
        const index = clampValue(context.get("page"), 0, context.get("pageSnapPoints").length - 1);
        context.set("page", index);
      },
      setSnapPoints({ context, computed, scope }) {
        const el = getItemGroupEl(scope);
        if (!el) return;
        const scrollSnapPoints = getScrollSnapPositions(el);
        context.set("pageSnapPoints", computed("isHorizontal") ? scrollSnapPoints.x : scrollSnapPoints.y);
      },
      disableScrollSnap({ scope }) {
        const el = getItemGroupEl(scope);
        if (!el) return;
        const styles = getComputedStyle(el);
        el.dataset.scrollSnapType = styles.getPropertyValue("scroll-snap-type");
        el.style.setProperty("scroll-snap-type", "none");
      },
      scrollSlides({ scope, event }) {
        const el = getItemGroupEl(scope);
        el?.scrollBy({ left: event.left, top: event.top, behavior: "instant" });
      },
      endDragging({ scope, context, computed }) {
        const el = getItemGroupEl(scope);
        if (!el) return;
        const isHorizontal = computed("isHorizontal");
        const scrollPos = isHorizontal ? el.scrollLeft : el.scrollTop;
        const snapPoints = context.get("pageSnapPoints");
        const closest = snapPoints.reduce((closest2, curr) => {
          return Math.abs(curr - scrollPos) < Math.abs(closest2 - scrollPos) ? curr : closest2;
        }, snapPoints[0]);
        raf(() => {
          el.scrollTo({
            left: isHorizontal ? closest : el.scrollLeft,
            top: isHorizontal ? el.scrollTop : closest,
            behavior: "smooth"
          });
          context.set("page", snapPoints.indexOf(closest));
          const scrollSnapType = el.dataset.scrollSnapType;
          if (scrollSnapType) {
            el.style.setProperty("scroll-snap-type", scrollSnapType);
            delete el.dataset.scrollSnapType;
          }
        });
      },
      focusIndicatorEl({ context, event, scope }) {
        if (event.src !== "indicator") return;
        const el = getIndicatorEl(scope, context.get("page"));
        if (!el) return;
        raf(() => el.focus({ preventScroll: true }));
      },
      invokeDragStart({ context, prop }) {
        prop("onDragStatusChange")?.({ type: "dragging.start", isDragging: true, page: context.get("page") });
      },
      invokeDragging({ context, prop }) {
        prop("onDragStatusChange")?.({ type: "dragging", isDragging: true, page: context.get("page") });
      },
      invokeDraggingEnd({ context, prop }) {
        prop("onDragStatusChange")?.({ type: "dragging.end", isDragging: false, page: context.get("page") });
      },
      invokeAutoplay({ context, prop }) {
        prop("onAutoplayStatusChange")?.({ type: "autoplay", isPlaying: true, page: context.get("page") });
      },
      invokeAutoplayStart({ context, prop }) {
        prop("onAutoplayStatusChange")?.({ type: "autoplay.start", isPlaying: true, page: context.get("page") });
      },
      invokeAutoplayEnd({ context, prop }) {
        prop("onAutoplayStatusChange")?.({ type: "autoplay.stop", isPlaying: false, page: context.get("page") });
      }
    }
  }
});
function getPageSnapPoints(totalSlides, slidesPerMove, slidesPerPage) {
  if (totalSlides == null || slidesPerPage <= 0) {
    return [];
  }
  const snapPoints = [];
  const perMove = slidesPerMove === "auto" ? Math.floor(slidesPerPage) : slidesPerMove;
  if (perMove <= 0) {
    return [];
  }
  for (let i = 0; i < totalSlides; i += perMove) {
    if (i + slidesPerPage > totalSlides) break;
    snapPoints.push(i);
  }
  return snapPoints;
}
var props = createProps()([
  "dir",
  "getRootNode",
  "id",
  "ids",
  "loop",
  "page",
  "defaultPage",
  "onPageChange",
  "orientation",
  "slideCount",
  "slidesPerPage",
  "slidesPerMove",
  "spacing",
  "padding",
  "autoplay",
  "allowMouseDrag",
  "inViewThreshold",
  "translations",
  "snapType",
  "autoSize",
  "onDragStatusChange",
  "onAutoplayStatusChange"
]);
var splitProps = createSplitProps(props);
var indicatorProps = createProps()(["index", "readOnly"]);
var splitIndicatorProps = createSplitProps(indicatorProps);
var itemProps = createProps()(["index", "snapAlign"]);
var splitItemProps = createSplitProps(itemProps);

// components/carousel.ts
var Carousel = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props2) {
    return new VanillaMachine(machine, props2);
  }
  initApi() {
    return connect(this.machine.service, normalizeProps);
  }
  render() {
    const rootEl = this.el.querySelector('[data-scope="carousel"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());
    const controlEl = this.el.querySelector(
      '[data-scope="carousel"][data-part="control"]'
    );
    if (controlEl) this.spreadProps(controlEl, this.api.getControlProps());
    const itemGroupEl = this.el.querySelector(
      '[data-scope="carousel"][data-part="item-group"]'
    );
    if (itemGroupEl) this.spreadProps(itemGroupEl, this.api.getItemGroupProps());
    const slideCount = Number(this.el.dataset.slideCount) || 0;
    for (let i = 0; i < slideCount; i++) {
      const itemEl = this.el.querySelector(
        `[data-scope="carousel"][data-part="item"][data-index="${i}"]`
      );
      if (itemEl) this.spreadProps(itemEl, this.api.getItemProps({ index: i }));
    }
    const prevTriggerEl = this.el.querySelector(
      '[data-scope="carousel"][data-part="prev-trigger"]'
    );
    if (prevTriggerEl) this.spreadProps(prevTriggerEl, this.api.getPrevTriggerProps());
    const nextTriggerEl = this.el.querySelector(
      '[data-scope="carousel"][data-part="next-trigger"]'
    );
    if (nextTriggerEl) this.spreadProps(nextTriggerEl, this.api.getNextTriggerProps());
    const autoplayTriggerEl = this.el.querySelector(
      '[data-scope="carousel"][data-part="autoplay-trigger"]'
    );
    if (autoplayTriggerEl) this.spreadProps(autoplayTriggerEl, this.api.getAutoplayTriggerProps());
    const indicatorGroupEl = this.el.querySelector(
      '[data-scope="carousel"][data-part="indicator-group"]'
    );
    if (indicatorGroupEl) this.spreadProps(indicatorGroupEl, this.api.getIndicatorGroupProps());
    const indicatorCount = this.api.pageSnapPoints.length;
    for (let i = 0; i < indicatorCount; i++) {
      const indicatorEl = this.el.querySelector(
        `[data-scope="carousel"][data-part="indicator"][data-index="${i}"]`
      );
      if (indicatorEl)
        this.spreadProps(indicatorEl, this.api.getIndicatorProps({ index: i }));
    }
    const progressTextEl = this.el.querySelector(
      '[data-scope="carousel"][data-part="progress-text"]'
    );
    if (progressTextEl) this.spreadProps(progressTextEl, this.api.getProgressTextProps());
  }
};

// hooks/carousel.ts
var CarouselHook = {
  mounted() {
    const el = this.el;
    const page = getNumber(el, "page");
    const defaultPage = getNumber(el, "defaultPage");
    const controlled = getBoolean(el, "controlled");
    const slideCount = getNumber(el, "slideCount");
    if (slideCount == null || slideCount < 1) {
      return;
    }
    const zag = new Carousel(el, {
      id: el.id,
      slideCount,
      ...controlled && page !== void 0 ? { page } : { defaultPage: defaultPage ?? 0 },
      dir: getDir(el),
      orientation: getString(el, "orientation", [
        "horizontal",
        "vertical"
      ]),
      slidesPerPage: getNumber(el, "slidesPerPage") ?? 1,
      slidesPerMove: getString(el, "slidesPerMove") === "auto" ? "auto" : getNumber(el, "slidesPerMove"),
      loop: getBoolean(el, "loop"),
      autoplay: getBoolean(el, "autoplay") ? { delay: getNumber(el, "autoplayDelay") ?? 4e3 } : false,
      allowMouseDrag: getBoolean(el, "allowMouseDrag"),
      spacing: getString(el, "spacing") ?? "0px",
      padding: getString(el, "padding"),
      inViewThreshold: getNumber(el, "inViewThreshold") ?? 0.6,
      snapType: getString(el, "snapType", ["proximity", "mandatory"]),
      autoSize: getBoolean(el, "autoSize"),
      onPageChange: (details) => {
        const eventName = getString(el, "onPageChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, {
            page: details.page,
            pageSnapPoint: details.pageSnapPoint,
            id: el.id
          });
        }
        const clientName = getString(el, "onPageChangeClient");
        if (clientName) {
          el.dispatchEvent(
            new CustomEvent(clientName, {
              bubbles: true,
              detail: { value: details, id: el.id }
            })
          );
        }
      }
    });
    zag.init();
    this.carousel = zag;
    this.handlers = [];
  },
  updated() {
    const slideCount = getNumber(this.el, "slideCount");
    if (slideCount == null || slideCount < 1) return;
    const page = getNumber(this.el, "page");
    const controlled = getBoolean(this.el, "controlled");
    this.carousel?.updateProps({
      id: this.el.id,
      slideCount,
      ...controlled && page !== void 0 ? { page } : {},
      dir: getDir(this.el),
      orientation: getString(this.el, "orientation", [
        "horizontal",
        "vertical"
      ]),
      slidesPerPage: getNumber(this.el, "slidesPerPage") ?? 1,
      loop: getBoolean(this.el, "loop"),
      allowMouseDrag: getBoolean(this.el, "allowMouseDrag")
    });
  },
  destroyed() {
    if (this.handlers) {
      for (const h of this.handlers) this.removeHandleEvent(h);
    }
    this.carousel?.destroy();
  }
};
export {
  CarouselHook as Carousel
};
