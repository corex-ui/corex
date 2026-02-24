import {
  addPoints,
  clampPoint,
  clampSize,
  constrainRect,
  createRect,
  getElementRect,
  getWindowRect,
  isPointEqual,
  isSizeEqual,
  resizeRect,
  subtractPoints
} from "./chunk-QHOSSHQC.mjs";
import {
  Component,
  VanillaMachine,
  addDomEvent,
  clampValue,
  createAnatomy,
  createGuards,
  createMachine,
  createProps,
  createSplitProps,
  dataAttr,
  ensureProps,
  getBoolean,
  getDir,
  getEventKey,
  getEventStep,
  getEventTarget,
  getString,
  invariant,
  isHTMLElement,
  isLeftClick,
  match,
  normalizeProps,
  pick,
  proxy,
  raf,
  resizeObserverBorderBox,
  subscribe,
  toPx,
  trackPointerMove
} from "./chunk-PLUM2DEK.mjs";

// ../node_modules/.pnpm/@zag-js+floating-panel@1.34.1/node_modules/@zag-js/floating-panel/dist/index.mjs
var anatomy = createAnatomy("floating-panel").parts(
  "trigger",
  "positioner",
  "content",
  "header",
  "body",
  "title",
  "resizeTrigger",
  "dragTrigger",
  "stageTrigger",
  "closeTrigger",
  "control"
);
var parts = anatomy.build();
var getTriggerId = (ctx) => ctx.ids?.trigger ?? `float:${ctx.id}:trigger`;
var getPositionerId = (ctx) => ctx.ids?.positioner ?? `float:${ctx.id}:positioner`;
var getContentId = (ctx) => ctx.ids?.content ?? `float:${ctx.id}:content`;
var getTitleId = (ctx) => ctx.ids?.title ?? `float:${ctx.id}:title`;
var getHeaderId = (ctx) => ctx.ids?.header ?? `float:${ctx.id}:header`;
var getTriggerEl = (ctx) => ctx.getById(getTriggerId(ctx));
var getPositionerEl = (ctx) => ctx.getById(getPositionerId(ctx));
var getContentEl = (ctx) => ctx.getById(getContentId(ctx));
var getHeaderEl = (ctx) => ctx.getById(getHeaderId(ctx));
var getBoundaryRect = (ctx, boundaryEl, allowOverflow) => {
  let boundaryRect;
  if (isHTMLElement(boundaryEl)) {
    boundaryRect = getElementRect(boundaryEl);
  } else {
    boundaryRect = getWindowRect(ctx.getWin());
  }
  if (allowOverflow) {
    boundaryRect = createRect({
      x: -boundaryRect.width,
      // empty(left)
      y: boundaryRect.minY,
      width: boundaryRect.width * 3,
      // empty(left) + win + empty(right)
      height: boundaryRect.height * 2
      // win + empty(bottom)
    });
  }
  return pick(boundaryRect, ["x", "y", "width", "height"]);
};
function getResizeAxisStyle(axis) {
  switch (axis) {
    case "n":
      return {
        cursor: "n-resize",
        width: "100%",
        top: 0,
        left: "50%",
        translate: "-50%"
      };
    case "e":
      return {
        cursor: "e-resize",
        height: "100%",
        right: 0,
        top: "50%",
        translate: "0 -50%"
      };
    case "s":
      return {
        cursor: "s-resize",
        width: "100%",
        bottom: 0,
        left: "50%",
        translate: "-50%"
      };
    case "w":
      return {
        cursor: "w-resize",
        height: "100%",
        left: 0,
        top: "50%",
        translate: "0 -50%"
      };
    case "se":
      return {
        cursor: "se-resize",
        bottom: 0,
        right: 0
      };
    case "sw":
      return {
        cursor: "sw-resize",
        bottom: 0,
        left: 0
      };
    case "ne":
      return {
        cursor: "ne-resize",
        top: 0,
        right: 0
      };
    case "nw":
      return {
        cursor: "nw-resize",
        top: 0,
        left: 0
      };
    default:
      throw new Error(`Invalid axis: ${axis}`);
  }
}
var validStages = /* @__PURE__ */ new Set(["minimized", "maximized", "default"]);
function connect(service, normalize) {
  const { state, send, scope, prop, computed, context } = service;
  const open = state.hasTag("open");
  const dragging = state.matches("open.dragging");
  const resizing = state.matches("open.resizing");
  const isTopmost = context.get("isTopmost");
  const size = context.get("size");
  const position = context.get("position");
  const isMaximized = computed("isMaximized");
  const isMinimized = computed("isMinimized");
  const isStaged = computed("isStaged");
  const canResize = computed("canResize");
  const canDrag = computed("canDrag");
  return {
    open,
    resizable: prop("resizable"),
    draggable: prop("draggable"),
    setOpen(nextOpen) {
      const open2 = state.hasTag("open");
      if (open2 === nextOpen) return;
      send({ type: nextOpen ? "OPEN" : "CLOSE" });
    },
    dragging,
    resizing,
    position,
    size,
    setPosition(position2) {
      send({ type: "SET_POSITION", position: position2 });
    },
    setSize(size2) {
      send({ type: "SET_SIZE", size: size2 });
    },
    minimize() {
      send({ type: "MINIMIZE" });
    },
    maximize() {
      send({ type: "MAXIMIZE" });
    },
    restore() {
      send({ type: "RESTORE" });
    },
    getTriggerProps() {
      return normalize.button({
        ...parts.trigger.attrs,
        dir: prop("dir"),
        type: "button",
        disabled: prop("disabled"),
        id: getTriggerId(scope),
        "data-state": open ? "open" : "closed",
        "data-dragging": dataAttr(dragging),
        "aria-controls": getContentId(scope),
        onClick(event) {
          if (event.defaultPrevented) return;
          if (prop("disabled")) return;
          const open2 = state.hasTag("open");
          send({ type: open2 ? "CLOSE" : "OPEN", src: "trigger" });
        }
      });
    },
    getPositionerProps() {
      return normalize.element({
        ...parts.positioner.attrs,
        dir: prop("dir"),
        id: getPositionerId(scope),
        style: {
          "--width": toPx(size?.width),
          "--height": toPx(size?.height),
          "--x": toPx(position?.x),
          "--y": toPx(position?.y),
          position: prop("strategy"),
          top: "var(--y)",
          left: "var(--x)"
        }
      });
    },
    getContentProps() {
      return normalize.element({
        ...parts.content.attrs,
        dir: prop("dir"),
        role: "dialog",
        tabIndex: 0,
        hidden: !open,
        id: getContentId(scope),
        "aria-labelledby": getTitleId(scope),
        "data-state": open ? "open" : "closed",
        "data-dragging": dataAttr(dragging),
        "data-topmost": dataAttr(isTopmost),
        "data-behind": dataAttr(!isTopmost),
        "data-minimized": dataAttr(isMinimized),
        "data-maximized": dataAttr(isMaximized),
        "data-staged": dataAttr(isStaged),
        style: {
          width: "var(--width)",
          height: "var(--height)",
          overflow: isMinimized ? "hidden" : void 0
        },
        onFocus() {
          send({ type: "CONTENT_FOCUS" });
        },
        onKeyDown(event) {
          if (event.defaultPrevented) return;
          if (event.currentTarget !== getEventTarget(event)) return;
          const step = getEventStep(event) * prop("gridSize");
          const keyMap = {
            Escape() {
              if (!isTopmost) return;
              send({ type: "ESCAPE" });
            },
            ArrowLeft() {
              send({ type: "MOVE", direction: "left", step });
            },
            ArrowRight() {
              send({ type: "MOVE", direction: "right", step });
            },
            ArrowUp() {
              send({ type: "MOVE", direction: "up", step });
            },
            ArrowDown() {
              send({ type: "MOVE", direction: "down", step });
            }
          };
          const handler = keyMap[getEventKey(event, { dir: prop("dir") })];
          if (handler) {
            event.preventDefault();
            handler(event);
          }
        }
      });
    },
    getCloseTriggerProps() {
      return normalize.button({
        ...parts.closeTrigger.attrs,
        dir: prop("dir"),
        disabled: prop("disabled"),
        "aria-label": "Close Window",
        type: "button",
        onClick(event) {
          if (event.defaultPrevented) return;
          send({ type: "CLOSE" });
        }
      });
    },
    getStageTriggerProps(props2) {
      if (!validStages.has(props2.stage)) {
        throw new Error(`[zag-js] Invalid stage: ${props2.stage}. Must be one of: ${Array.from(validStages).join(", ")}`);
      }
      const translations = prop("translations");
      const actionProps = match(props2.stage, {
        minimized: () => ({
          "aria-label": translations.minimize,
          hidden: isStaged
        }),
        maximized: () => ({
          "aria-label": translations.maximize,
          hidden: isStaged
        }),
        default: () => ({
          "aria-label": translations.restore,
          hidden: !isStaged
        })
      });
      return normalize.button({
        ...parts.stageTrigger.attrs,
        dir: prop("dir"),
        disabled: prop("disabled"),
        "data-stage": props2.stage,
        ...actionProps,
        type: "button",
        onClick(event) {
          if (event.defaultPrevented) return;
          if (!prop("resizable")) return;
          const type = match(props2.stage, {
            minimized: () => "MINIMIZE",
            maximized: () => "MAXIMIZE",
            default: () => "RESTORE"
          });
          send({ type: type.toUpperCase() });
        }
      });
    },
    getResizeTriggerProps(props2) {
      return normalize.element({
        ...parts.resizeTrigger.attrs,
        dir: prop("dir"),
        "data-disabled": dataAttr(!canResize),
        "data-axis": props2.axis,
        onPointerDown(event) {
          if (!canResize) return;
          if (!isLeftClick(event)) return;
          event.currentTarget.setPointerCapture(event.pointerId);
          event.stopPropagation();
          send({
            type: "RESIZE_START",
            axis: props2.axis,
            position: { x: event.clientX, y: event.clientY }
          });
        },
        onPointerUp(event) {
          if (!canResize) return;
          const node = event.currentTarget;
          if (node.hasPointerCapture(event.pointerId)) {
            node.releasePointerCapture(event.pointerId);
          }
        },
        style: {
          position: "absolute",
          touchAction: "none",
          ...getResizeAxisStyle(props2.axis)
        }
      });
    },
    getDragTriggerProps() {
      return normalize.element({
        ...parts.dragTrigger.attrs,
        dir: prop("dir"),
        "data-disabled": dataAttr(!canDrag),
        onPointerDown(event) {
          if (!canDrag) return;
          if (!isLeftClick(event)) return;
          const target = getEventTarget(event);
          if (target?.closest("button") || target?.closest("[data-no-drag]")) {
            return;
          }
          event.currentTarget.setPointerCapture(event.pointerId);
          event.stopPropagation();
          send({
            type: "DRAG_START",
            pointerId: event.pointerId,
            position: { x: event.clientX, y: event.clientY }
          });
        },
        onPointerUp(event) {
          if (!canDrag) return;
          const node = event.currentTarget;
          if (node.hasPointerCapture(event.pointerId)) {
            node.releasePointerCapture(event.pointerId);
          }
        },
        onDoubleClick(event) {
          if (event.defaultPrevented) return;
          if (!prop("resizable")) return;
          send({ type: isStaged ? "RESTORE" : "MAXIMIZE" });
        },
        style: {
          WebkitUserSelect: "none",
          userSelect: "none",
          touchAction: "none",
          cursor: "move"
        }
      });
    },
    getControlProps() {
      return normalize.element({
        ...parts.control.attrs,
        dir: prop("dir"),
        "data-disabled": dataAttr(prop("disabled")),
        "data-stage": context.get("stage"),
        "data-minimized": dataAttr(isMinimized),
        "data-maximized": dataAttr(isMaximized),
        "data-staged": dataAttr(isStaged)
      });
    },
    getTitleProps() {
      return normalize.element({
        ...parts.title.attrs,
        dir: prop("dir"),
        id: getTitleId(scope)
      });
    },
    getHeaderProps() {
      return normalize.element({
        ...parts.header.attrs,
        dir: prop("dir"),
        id: getHeaderId(scope),
        "data-dragging": dataAttr(dragging),
        "data-topmost": dataAttr(isTopmost),
        "data-behind": dataAttr(!isTopmost),
        "data-minimized": dataAttr(isMinimized),
        "data-maximized": dataAttr(isMaximized),
        "data-staged": dataAttr(isStaged)
      });
    },
    getBodyProps() {
      return normalize.element({
        ...parts.body.attrs,
        dir: prop("dir"),
        "data-dragging": dataAttr(dragging),
        "data-minimized": dataAttr(isMinimized),
        "data-maximized": dataAttr(isMaximized),
        "data-staged": dataAttr(isStaged),
        hidden: isMinimized
      });
    }
  };
}
var panelStack = proxy({
  stack: [],
  count() {
    return this.stack.length;
  },
  add(panelId) {
    if (this.stack.includes(panelId)) return;
    this.stack.push(panelId);
  },
  remove(panelId) {
    const index = this.stack.indexOf(panelId);
    if (index < 0) return;
    this.stack.splice(index, 1);
  },
  bringToFront(id) {
    this.remove(id);
    this.add(id);
  },
  isTopmost(id) {
    return this.stack[this.stack.length - 1] === id;
  },
  indexOf(id) {
    return this.stack.indexOf(id);
  }
});
var { not, and } = createGuards();
var defaultTranslations = {
  minimize: "Minimize window",
  maximize: "Maximize window",
  restore: "Restore window"
};
var machine = createMachine({
  props({ props: props2 }) {
    ensureProps(props2, ["id"], "floating-panel");
    return {
      strategy: "fixed",
      gridSize: 1,
      defaultSize: { width: 320, height: 240 },
      defaultPosition: { x: 300, y: 100 },
      allowOverflow: true,
      resizable: true,
      draggable: true,
      ...props2,
      hasSpecifiedPosition: !!props2.defaultPosition || !!props2.position,
      translations: {
        ...defaultTranslations,
        ...props2.translations
      }
    };
  },
  initialState({ prop }) {
    const open = prop("open") || prop("defaultOpen");
    return open ? "open" : "closed";
  },
  context({ prop, bindable }) {
    return {
      size: bindable(() => ({
        defaultValue: prop("defaultSize"),
        value: prop("size"),
        isEqual: isSizeEqual,
        sync: true,
        hash(v) {
          return `W:${v.width} H:${v.height}`;
        },
        onChange(value) {
          prop("onSizeChange")?.({ size: value });
        }
      })),
      position: bindable(() => ({
        defaultValue: prop("defaultPosition"),
        value: prop("position"),
        isEqual: isPointEqual,
        sync: true,
        hash(v) {
          return `X:${v.x} Y:${v.y}`;
        },
        onChange(value) {
          prop("onPositionChange")?.({ position: value });
        }
      })),
      stage: bindable(() => ({
        defaultValue: "default",
        onChange(value) {
          prop("onStageChange")?.({ stage: value });
        }
      })),
      lastEventPosition: bindable(() => ({
        defaultValue: null
      })),
      prevPosition: bindable(() => ({
        defaultValue: null
      })),
      prevSize: bindable(() => ({
        defaultValue: null
      })),
      isTopmost: bindable(() => ({
        defaultValue: void 0
      }))
    };
  },
  computed: {
    isMaximized: ({ context }) => context.get("stage") === "maximized",
    isMinimized: ({ context }) => context.get("stage") === "minimized",
    isStaged: ({ context }) => context.get("stage") !== "default",
    canResize: ({ context, prop }) => prop("resizable") && !prop("disabled") && context.get("stage") === "default",
    canDrag: ({ prop, computed }) => prop("draggable") && !prop("disabled") && !computed("isMaximized")
  },
  watch({ track, context, action, prop }) {
    track([() => context.hash("position")], () => {
      action(["setPositionStyle"]);
    });
    track([() => context.hash("size")], () => {
      action(["setSizeStyle"]);
    });
    track([() => prop("open")], () => {
      action(["toggleVisibility"]);
    });
  },
  effects: ["trackPanelStack"],
  on: {
    CONTENT_FOCUS: {
      actions: ["bringToFrontOfPanelStack"]
    },
    SET_POSITION: {
      actions: ["setPosition"]
    },
    SET_SIZE: {
      actions: ["setSize"]
    }
  },
  states: {
    closed: {
      tags: ["closed"],
      on: {
        "CONTROLLED.OPEN": {
          target: "open",
          actions: ["setAnchorPosition", "setPositionStyle", "setSizeStyle", "focusContentEl"]
        },
        OPEN: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["invokeOnOpen", "setAnchorPosition", "setPositionStyle", "setSizeStyle", "focusContentEl"]
          }
        ]
      }
    },
    open: {
      tags: ["open"],
      entry: ["bringToFrontOfPanelStack"],
      effects: ["trackBoundaryRect"],
      on: {
        DRAG_START: {
          guard: not("isMaximized"),
          target: "open.dragging",
          actions: ["setPrevPosition"]
        },
        RESIZE_START: {
          guard: not("isMinimized"),
          target: "open.resizing",
          actions: ["setPrevSize"]
        },
        "CONTROLLED.CLOSE": {
          target: "closed",
          actions: ["resetRect", "focusTriggerEl"]
        },
        CLOSE: [
          {
            guard: "isOpenControlled",
            target: "closed",
            actions: ["invokeOnClose"]
          },
          {
            target: "closed",
            actions: ["invokeOnClose", "resetRect", "focusTriggerEl"]
          }
        ],
        ESCAPE: [
          {
            guard: and("isOpenControlled", "closeOnEsc"),
            actions: ["invokeOnClose"]
          },
          {
            guard: "closeOnEsc",
            target: "closed",
            actions: ["invokeOnClose", "resetRect", "focusTriggerEl"]
          }
        ],
        MINIMIZE: {
          actions: ["setMinimized"]
        },
        MAXIMIZE: {
          actions: ["setMaximized"]
        },
        RESTORE: {
          actions: ["setRestored"]
        },
        MOVE: {
          actions: ["setPositionFromKeyboard"]
        }
      }
    },
    "open.dragging": {
      tags: ["open"],
      effects: ["trackPointerMove"],
      exit: ["clearPrevPosition"],
      on: {
        DRAG: {
          actions: ["setPosition"]
        },
        DRAG_END: {
          target: "open",
          actions: ["invokeOnDragEnd"]
        },
        "CONTROLLED.CLOSE": {
          target: "closed",
          actions: ["resetRect"]
        },
        CLOSE: [
          {
            guard: "isOpenControlled",
            target: "closed",
            actions: ["invokeOnClose"]
          },
          {
            target: "closed",
            actions: ["invokeOnClose", "resetRect"]
          }
        ],
        ESCAPE: {
          target: "open"
        }
      }
    },
    "open.resizing": {
      tags: ["open"],
      effects: ["trackPointerMove"],
      exit: ["clearPrevSize"],
      on: {
        DRAG: {
          actions: ["setSize"]
        },
        DRAG_END: {
          target: "open",
          actions: ["invokeOnResizeEnd"]
        },
        "CONTROLLED.CLOSE": {
          target: "closed",
          actions: ["resetRect"]
        },
        CLOSE: [
          {
            guard: "isOpenControlled",
            target: "closed",
            actions: ["invokeOnClose"]
          },
          {
            target: "closed",
            actions: ["invokeOnClose", "resetRect"]
          }
        ],
        ESCAPE: {
          target: "open"
        }
      }
    }
  },
  implementations: {
    guards: {
      closeOnEsc: ({ prop }) => !!prop("closeOnEscape"),
      isMaximized: ({ context }) => context.get("stage") === "maximized",
      isMinimized: ({ context }) => context.get("stage") === "minimized",
      isOpenControlled: ({ prop }) => prop("open") != void 0
    },
    effects: {
      trackPointerMove({ scope, send, event: evt, prop }) {
        const doc = scope.getDoc();
        const boundaryEl = prop("getBoundaryEl")?.();
        const boundaryRect = getBoundaryRect(scope, boundaryEl, false);
        return trackPointerMove(doc, {
          onPointerMove({ point, event }) {
            const { altKey, shiftKey } = event;
            let x = clampValue(point.x, boundaryRect.x, boundaryRect.x + boundaryRect.width);
            let y = clampValue(point.y, boundaryRect.y, boundaryRect.y + boundaryRect.height);
            send({ type: "DRAG", position: { x, y }, axis: evt.axis, altKey, shiftKey });
          },
          onPointerUp() {
            send({ type: "DRAG_END" });
          }
        });
      },
      trackBoundaryRect({ context, scope, prop, computed }) {
        const win = scope.getWin();
        let skip = true;
        const exec = () => {
          if (skip) {
            skip = false;
            return;
          }
          const boundaryEl2 = prop("getBoundaryEl")?.();
          let boundaryRect = getBoundaryRect(scope, boundaryEl2, false);
          if (!computed("isMaximized")) {
            const rect = { ...context.get("position"), ...context.get("size") };
            boundaryRect = constrainRect(rect, boundaryRect);
          }
          context.set("size", pick(boundaryRect, ["width", "height"]));
          context.set("position", pick(boundaryRect, ["x", "y"]));
        };
        const boundaryEl = prop("getBoundaryEl")?.();
        if (isHTMLElement(boundaryEl)) {
          return resizeObserverBorderBox.observe(boundaryEl, exec);
        }
        return addDomEvent(win, "resize", exec);
      },
      trackPanelStack({ context, scope }) {
        const unsub = subscribe(panelStack, () => {
          context.set("isTopmost", panelStack.isTopmost(scope.id));
          const contentEl = getContentEl(scope);
          if (!contentEl) return;
          const index = panelStack.indexOf(scope.id);
          if (index === -1) return;
          contentEl.style.setProperty("--z-index", `${index + 1}`);
        });
        return () => {
          panelStack.remove(scope.id);
          unsub();
        };
      }
    },
    actions: {
      setAnchorPosition({ context, prop, scope }) {
        if (prop("hasSpecifiedPosition")) return;
        const hasPrevRect = context.get("prevPosition") || context.get("prevSize");
        if (prop("persistRect") && hasPrevRect) return;
        raf(() => {
          const triggerRect = getTriggerEl(scope);
          const boundaryRect = getBoundaryRect(scope, prop("getBoundaryEl")?.(), false);
          let anchorPosition = prop("getAnchorPosition")?.({
            triggerRect: triggerRect ? DOMRect.fromRect(getElementRect(triggerRect)) : null,
            boundaryRect: DOMRect.fromRect(boundaryRect)
          });
          if (!anchorPosition) {
            const size = context.get("size");
            anchorPosition = {
              x: boundaryRect.x + (boundaryRect.width - size.width) / 2,
              y: boundaryRect.y + (boundaryRect.height - size.height) / 2
            };
          }
          if (!anchorPosition) return;
          context.set("position", anchorPosition);
        });
      },
      setPrevPosition({ context, event }) {
        context.set("prevPosition", { ...context.get("position") });
        context.set("lastEventPosition", event.position);
      },
      clearPrevPosition({ context, prop }) {
        if (!prop("persistRect")) context.set("prevPosition", null);
        context.set("lastEventPosition", null);
      },
      setPosition({ context, event, prop, scope }) {
        let diff = subtractPoints(event.position, context.get("lastEventPosition"));
        diff.x = Math.round(diff.x / prop("gridSize")) * prop("gridSize");
        diff.y = Math.round(diff.y / prop("gridSize")) * prop("gridSize");
        const prevPosition = context.get("prevPosition");
        if (!prevPosition) return;
        let position = addPoints(prevPosition, diff);
        const boundaryEl = prop("getBoundaryEl")?.();
        const boundaryRect = getBoundaryRect(scope, boundaryEl, prop("allowOverflow"));
        position = clampPoint(position, context.get("size"), boundaryRect);
        context.set("position", position);
      },
      setPositionStyle({ scope, context }) {
        const el = getPositionerEl(scope);
        const position = context.get("position");
        el?.style.setProperty("--x", `${position.x}px`);
        el?.style.setProperty("--y", `${position.y}px`);
      },
      resetRect({ context, prop }) {
        context.set("stage", "default");
        if (!prop("persistRect")) {
          context.set("position", context.initial("position"));
          context.set("size", context.initial("size"));
        }
      },
      setPrevSize({ context, event }) {
        context.set("prevSize", { ...context.get("size") });
        context.set("prevPosition", { ...context.get("position") });
        context.set("lastEventPosition", event.position);
      },
      clearPrevSize({ context }) {
        context.set("prevSize", null);
        context.set("prevPosition", null);
        context.set("lastEventPosition", null);
      },
      setSize({ context, event, scope, prop }) {
        const prevSize = context.get("prevSize");
        const prevPosition = context.get("prevPosition");
        const lastEventPosition = context.get("lastEventPosition");
        if (!prevSize || !prevPosition || !lastEventPosition) return;
        const prevRect = createRect({ ...prevPosition, ...prevSize });
        const offset = subtractPoints(event.position, lastEventPosition);
        const nextRect = resizeRect(prevRect, offset, event.axis, {
          scalingOriginMode: event.altKey ? "center" : "extent",
          lockAspectRatio: !!prop("lockAspectRatio") || event.shiftKey
        });
        let nextSize = pick(nextRect, ["width", "height"]);
        let nextPosition = pick(nextRect, ["x", "y"]);
        const boundaryEl = prop("getBoundaryEl")?.();
        const boundaryRect = getBoundaryRect(scope, boundaryEl, false);
        nextSize = clampSize(nextSize, prop("minSize"), prop("maxSize"));
        nextSize = clampSize(nextSize, prop("minSize"), boundaryRect);
        context.set("size", nextSize);
        if (nextPosition) {
          const point = clampPoint(nextPosition, nextSize, boundaryRect);
          context.set("position", point);
        }
      },
      setSizeStyle({ scope, context }) {
        queueMicrotask(() => {
          const el = getPositionerEl(scope);
          const size = context.get("size");
          el?.style.setProperty("--width", `${size.width}px`);
          el?.style.setProperty("--height", `${size.height}px`);
        });
      },
      setMaximized({ context, prop, scope }) {
        context.set("stage", "maximized");
        context.set("prevSize", context.get("size"));
        context.set("prevPosition", context.get("position"));
        const boundaryEl = prop("getBoundaryEl")?.();
        const boundaryRect = getBoundaryRect(scope, boundaryEl, false);
        context.set("position", pick(boundaryRect, ["x", "y"]));
        context.set("size", pick(boundaryRect, ["height", "width"]));
      },
      setMinimized({ context, scope }) {
        context.set("stage", "minimized");
        context.set("prevSize", context.get("size"));
        context.set("prevPosition", context.get("position"));
        const headerEl = getHeaderEl(scope);
        if (!headerEl) return;
        const size = {
          ...context.get("size"),
          height: headerEl?.offsetHeight
        };
        context.set("size", size);
      },
      setRestored({ context, prop, scope }) {
        const boundaryRect = getBoundaryRect(scope, prop("getBoundaryEl")?.(), false);
        context.set("stage", "default");
        const prevSize = context.get("prevSize");
        if (prevSize) {
          let nextSize = prevSize;
          nextSize = clampSize(nextSize, prop("minSize"), prop("maxSize"));
          nextSize = clampSize(nextSize, prop("minSize"), boundaryRect);
          context.set("size", nextSize);
          context.set("prevSize", null);
        }
        if (context.get("prevPosition")) {
          let nextPosition = context.get("prevPosition");
          nextPosition = clampPoint(nextPosition, context.get("size"), boundaryRect);
          context.set("position", nextPosition);
          context.set("prevPosition", null);
        }
      },
      setPositionFromKeyboard({ context, event, prop, scope }) {
        invariant(event.step == null, "step is required");
        const position = context.get("position");
        const step = event.step;
        let nextPosition = match(event.direction, {
          left: { x: position.x - step, y: position.y },
          right: { x: position.x + step, y: position.y },
          up: { x: position.x, y: position.y - step },
          down: { x: position.x, y: position.y + step }
        });
        const boundaryEl = prop("getBoundaryEl")?.();
        const boundaryRect = getBoundaryRect(scope, boundaryEl, false);
        nextPosition = clampPoint(nextPosition, context.get("size"), boundaryRect);
        context.set("position", nextPosition);
      },
      bringToFrontOfPanelStack({ prop }) {
        panelStack.bringToFront(prop("id"));
      },
      invokeOnOpen({ prop }) {
        prop("onOpenChange")?.({ open: true });
      },
      invokeOnClose({ prop }) {
        prop("onOpenChange")?.({ open: false });
      },
      invokeOnDragEnd({ context, prop }) {
        prop("onPositionChangeEnd")?.({ position: context.get("position") });
      },
      invokeOnResizeEnd({ context, prop }) {
        prop("onSizeChangeEnd")?.({ size: context.get("size") });
      },
      focusTriggerEl({ scope }) {
        raf(() => {
          getTriggerEl(scope)?.focus();
        });
      },
      focusContentEl({ scope }) {
        raf(() => {
          getContentEl(scope)?.focus();
        });
      },
      toggleVisibility({ send, prop, event }) {
        send({ type: prop("open") ? "CONTROLLED.OPEN" : "CONTROLLED.CLOSE", previousEvent: event });
      }
    }
  }
});
var props = createProps()([
  "allowOverflow",
  "closeOnEscape",
  "defaultOpen",
  "defaultPosition",
  "defaultSize",
  "dir",
  "disabled",
  "draggable",
  "getAnchorPosition",
  "getBoundaryEl",
  "getRootNode",
  "gridSize",
  "id",
  "ids",
  "lockAspectRatio",
  "maxSize",
  "minSize",
  "onOpenChange",
  "onPositionChange",
  "onPositionChangeEnd",
  "onSizeChange",
  "onSizeChangeEnd",
  "onStageChange",
  "open",
  "persistRect",
  "position",
  "resizable",
  "size",
  "strategy",
  "translations"
]);
var splitProps = createSplitProps(props);
var resizeTriggerProps = createProps()(["axis"]);
var splitResizeTriggerProps = createSplitProps(resizeTriggerProps);

// components/floating-panel.ts
var FloatingPanel = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props2) {
    return new VanillaMachine(machine, props2);
  }
  initApi() {
    return connect(this.machine.service, normalizeProps);
  }
  render() {
    const triggerEl = this.el.querySelector(
      '[data-scope="floating-panel"][data-part="trigger"]'
    );
    if (triggerEl) this.spreadProps(triggerEl, this.api.getTriggerProps());
    const positionerEl = this.el.querySelector(
      '[data-scope="floating-panel"][data-part="positioner"]'
    );
    if (positionerEl) this.spreadProps(positionerEl, this.api.getPositionerProps());
    const contentEl = this.el.querySelector(
      '[data-scope="floating-panel"][data-part="content"]'
    );
    if (contentEl) this.spreadProps(contentEl, this.api.getContentProps());
    const titleEl = this.el.querySelector(
      '[data-scope="floating-panel"][data-part="title"]'
    );
    if (titleEl) this.spreadProps(titleEl, this.api.getTitleProps());
    const headerEl = this.el.querySelector(
      '[data-scope="floating-panel"][data-part="header"]'
    );
    if (headerEl) this.spreadProps(headerEl, this.api.getHeaderProps());
    const bodyEl = this.el.querySelector(
      '[data-scope="floating-panel"][data-part="body"]'
    );
    if (bodyEl) this.spreadProps(bodyEl, this.api.getBodyProps());
    const dragTriggerEl = this.el.querySelector(
      '[data-scope="floating-panel"][data-part="drag-trigger"]'
    );
    if (dragTriggerEl) this.spreadProps(dragTriggerEl, this.api.getDragTriggerProps());
    const resizeAxes = ["s", "w", "e", "n", "sw", "nw", "se", "ne"];
    resizeAxes.forEach((axis) => {
      const resizeEl = this.el.querySelector(
        `[data-scope="floating-panel"][data-part="resize-trigger"][data-axis="${axis}"]`
      );
      if (resizeEl)
        this.spreadProps(resizeEl, this.api.getResizeTriggerProps({ axis }));
    });
    const closeTriggerEl = this.el.querySelector(
      '[data-scope="floating-panel"][data-part="close-trigger"]'
    );
    if (closeTriggerEl) this.spreadProps(closeTriggerEl, this.api.getCloseTriggerProps());
    const controlEl = this.el.querySelector(
      '[data-scope="floating-panel"][data-part="control"]'
    );
    if (controlEl) this.spreadProps(controlEl, this.api.getControlProps());
    const stages = ["minimized", "maximized", "default"];
    stages.forEach((stage) => {
      const stageTriggerEl = this.el.querySelector(
        `[data-scope="floating-panel"][data-part="stage-trigger"][data-stage="${stage}"]`
      );
      if (stageTriggerEl)
        this.spreadProps(
          stageTriggerEl,
          this.api.getStageTriggerProps({ stage })
        );
    });
  }
};

// hooks/floating-panel.ts
function parseSize(val) {
  if (!val) return void 0;
  try {
    const parsed = JSON.parse(val);
    if (typeof parsed.width === "number" && typeof parsed.height === "number") {
      return { width: parsed.width, height: parsed.height };
    }
  } catch {
  }
  return void 0;
}
function parsePoint(val) {
  if (!val) return void 0;
  try {
    const parsed = JSON.parse(val);
    if (typeof parsed.x === "number" && typeof parsed.y === "number") {
      return { x: parsed.x, y: parsed.y };
    }
  } catch {
  }
  return void 0;
}
var FloatingPanelHook = {
  mounted() {
    const el = this.el;
    const open = getBoolean(el, "open");
    const defaultOpen = getBoolean(el, "defaultOpen");
    const controlled = getBoolean(el, "controlled");
    const size = parseSize(el.dataset.size);
    const defaultSize = parseSize(el.dataset.defaultSize);
    const position = parsePoint(el.dataset.position);
    const defaultPosition = parsePoint(el.dataset.defaultPosition);
    const zag = new FloatingPanel(el, {
      id: el.id,
      ...controlled ? { open } : { defaultOpen },
      draggable: getBoolean(el, "draggable") !== false,
      resizable: getBoolean(el, "resizable") !== false,
      allowOverflow: getBoolean(el, "allowOverflow") !== false,
      closeOnEscape: getBoolean(el, "closeOnEscape") !== false,
      disabled: getBoolean(el, "disabled"),
      dir: getDir(el),
      size,
      defaultSize,
      position,
      defaultPosition,
      minSize: parseSize(el.dataset.minSize),
      maxSize: parseSize(el.dataset.maxSize),
      persistRect: getBoolean(el, "persistRect"),
      gridSize: Number(el.dataset.gridSize) || 1,
      onOpenChange: (details) => {
        const eventName = getString(el, "onOpenChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, { open: details.open, id: el.id });
        }
        const clientName = getString(el, "onOpenChangeClient");
        if (clientName) {
          el.dispatchEvent(
            new CustomEvent(clientName, {
              bubbles: true,
              detail: { value: details, id: el.id }
            })
          );
        }
      },
      onPositionChange: (details) => {
        const eventName = getString(el, "onPositionChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, {
            position: details.position,
            id: el.id
          });
        }
      },
      onSizeChange: (details) => {
        const eventName = getString(el, "onSizeChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, {
            size: details.size,
            id: el.id
          });
        }
      },
      onStageChange: (details) => {
        const eventName = getString(el, "onStageChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, {
            stage: details.stage,
            id: el.id
          });
        }
      }
    });
    zag.init();
    this.floatingPanel = zag;
    this.handlers = [];
  },
  updated() {
    const open = getBoolean(this.el, "open");
    const controlled = getBoolean(this.el, "controlled");
    this.floatingPanel?.updateProps({
      id: this.el.id,
      ...controlled ? { open } : {},
      disabled: getBoolean(this.el, "disabled"),
      dir: getDir(this.el)
    });
  },
  destroyed() {
    if (this.handlers) {
      for (const h of this.handlers) this.removeHandleEvent(h);
    }
    this.floatingPanel?.destroy();
  }
};
export {
  FloatingPanelHook as FloatingPanel
};
