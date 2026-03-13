import {
  __publicField,
  addPoints,
  createRect,
  subtractPoints
} from "./chunk-ZZKFCQSP.mjs";
import {
  clampValue,
  toPx
} from "./chunk-MV633JPN.mjs";
import {
  Component,
  VanillaMachine,
  addDomEvent,
  createAnatomy,
  createGuards,
  createMachine,
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
  trackPointerMove
} from "./chunk-ZOODJA3P.mjs";

// ../node_modules/.pnpm/@zag-js+floating-panel@1.36.0/node_modules/@zag-js/floating-panel/dist/floating-panel.anatomy.mjs
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

// ../node_modules/.pnpm/@zag-js+rect-utils@1.36.0/node_modules/@zag-js/rect-utils/dist/affine-transform.mjs
var AffineTransform = class _AffineTransform {
  constructor([m00, m01, m02, m10, m11, m12] = [0, 0, 0, 0, 0, 0]) {
    __publicField(this, "m00");
    __publicField(this, "m01");
    __publicField(this, "m02");
    __publicField(this, "m10");
    __publicField(this, "m11");
    __publicField(this, "m12");
    __publicField(this, "rotate", (...args) => {
      return this.prepend(_AffineTransform.rotate(...args));
    });
    __publicField(this, "scale", (...args) => {
      return this.prepend(_AffineTransform.scale(...args));
    });
    __publicField(this, "translate", (...args) => {
      return this.prepend(_AffineTransform.translate(...args));
    });
    this.m00 = m00;
    this.m01 = m01;
    this.m02 = m02;
    this.m10 = m10;
    this.m11 = m11;
    this.m12 = m12;
  }
  applyTo(point) {
    const { x, y } = point;
    const { m00, m01, m02, m10, m11, m12 } = this;
    return {
      x: m00 * x + m01 * y + m02,
      y: m10 * x + m11 * y + m12
    };
  }
  prepend(other) {
    return new _AffineTransform([
      this.m00 * other.m00 + this.m01 * other.m10,
      // m00
      this.m00 * other.m01 + this.m01 * other.m11,
      // m01
      this.m00 * other.m02 + this.m01 * other.m12 + this.m02,
      // m02
      this.m10 * other.m00 + this.m11 * other.m10,
      // m10
      this.m10 * other.m01 + this.m11 * other.m11,
      // m11
      this.m10 * other.m02 + this.m11 * other.m12 + this.m12
      // m12
    ]);
  }
  append(other) {
    return new _AffineTransform([
      other.m00 * this.m00 + other.m01 * this.m10,
      // m00
      other.m00 * this.m01 + other.m01 * this.m11,
      // m01
      other.m00 * this.m02 + other.m01 * this.m12 + other.m02,
      // m02
      other.m10 * this.m00 + other.m11 * this.m10,
      // m10
      other.m10 * this.m01 + other.m11 * this.m11,
      // m11
      other.m10 * this.m02 + other.m11 * this.m12 + other.m12
      // m12
    ]);
  }
  get determinant() {
    return this.m00 * this.m11 - this.m01 * this.m10;
  }
  get isInvertible() {
    const det = this.determinant;
    return isFinite(det) && isFinite(this.m02) && isFinite(this.m12) && det !== 0;
  }
  invert() {
    const det = this.determinant;
    return new _AffineTransform([
      this.m11 / det,
      // m00
      -this.m01 / det,
      // m01
      (this.m01 * this.m12 - this.m11 * this.m02) / det,
      // m02
      -this.m10 / det,
      // m10
      this.m00 / det,
      // m11
      (this.m10 * this.m02 - this.m00 * this.m12) / det
      // m12
    ]);
  }
  get array() {
    return [this.m00, this.m01, this.m02, this.m10, this.m11, this.m12, 0, 0, 1];
  }
  get float32Array() {
    return new Float32Array(this.array);
  }
  // Static
  static get identity() {
    return new _AffineTransform([1, 0, 0, 0, 1, 0]);
  }
  static rotate(theta, origin) {
    const rotation = new _AffineTransform([Math.cos(theta), -Math.sin(theta), 0, Math.sin(theta), Math.cos(theta), 0]);
    if (origin && (origin.x !== 0 || origin.y !== 0)) {
      return _AffineTransform.multiply(
        _AffineTransform.translate(origin.x, origin.y),
        rotation,
        _AffineTransform.translate(-origin.x, -origin.y)
      );
    }
    return rotation;
  }
  static scale(sx, sy = sx, origin = { x: 0, y: 0 }) {
    const scale = new _AffineTransform([sx, 0, 0, 0, sy, 0]);
    if (origin.x !== 0 || origin.y !== 0) {
      return _AffineTransform.multiply(
        _AffineTransform.translate(origin.x, origin.y),
        scale,
        _AffineTransform.translate(-origin.x, -origin.y)
      );
    }
    return scale;
  }
  static translate(tx, ty) {
    return new _AffineTransform([1, 0, tx, 0, 1, ty]);
  }
  static multiply(...[first, ...rest]) {
    if (!first) return _AffineTransform.identity;
    return rest.reduce((result, item) => result.prepend(item), first);
  }
  get a() {
    return this.m00;
  }
  get b() {
    return this.m10;
  }
  get c() {
    return this.m01;
  }
  get d() {
    return this.m11;
  }
  get tx() {
    return this.m02;
  }
  get ty() {
    return this.m12;
  }
  get scaleComponents() {
    return { x: this.a, y: this.d };
  }
  get translationComponents() {
    return { x: this.tx, y: this.ty };
  }
  get skewComponents() {
    return { x: this.c, y: this.b };
  }
  toString() {
    return `matrix(${this.a}, ${this.b}, ${this.c}, ${this.d}, ${this.tx}, ${this.ty})`;
  }
};

// ../node_modules/.pnpm/@zag-js+rect-utils@1.36.0/node_modules/@zag-js/rect-utils/dist/clamp.mjs
var clamp = (value, min2, max) => Math.min(Math.max(value, min2), max);
var clampPoint = (position, size, boundaryRect) => {
  const x = clamp(position.x, boundaryRect.x, boundaryRect.x + boundaryRect.width - size.width);
  const y = clamp(position.y, boundaryRect.y, boundaryRect.y + boundaryRect.height - size.height);
  return { x, y };
};
var defaultMinSize = {
  width: 0,
  height: 0
};
var defaultMaxSize = {
  width: Infinity,
  height: Infinity
};
var clampSize = (size, minSize = defaultMinSize, maxSize = defaultMaxSize) => {
  return {
    width: Math.min(Math.max(size.width, minSize.width), maxSize.width),
    height: Math.min(Math.max(size.height, minSize.height), maxSize.height)
  };
};

// ../node_modules/.pnpm/@zag-js+rect-utils@1.36.0/node_modules/@zag-js/rect-utils/dist/constrain.mjs
var constrainRect = (rect, boundary) => {
  const left = Math.max(boundary.x, Math.min(rect.x, boundary.x + boundary.width - rect.width));
  const top = Math.max(boundary.y, Math.min(rect.y, boundary.y + boundary.height - rect.height));
  return {
    x: left,
    y: top,
    width: Math.min(rect.width, boundary.width),
    height: Math.min(rect.height, boundary.height)
  };
};

// ../node_modules/.pnpm/@zag-js+rect-utils@1.36.0/node_modules/@zag-js/rect-utils/dist/equality.mjs
var isSizeEqual = (a, b) => {
  return a.width === b?.width && a.height === b?.height;
};
var isPointEqual = (a, b) => {
  return a.x === b?.x && a.y === b?.y;
};

// ../node_modules/.pnpm/@zag-js+rect-utils@1.36.0/node_modules/@zag-js/rect-utils/dist/from-element.mjs
var styleCache = /* @__PURE__ */ new WeakMap();
function getCacheComputedStyle(el) {
  if (!styleCache.has(el)) {
    const win = el.ownerDocument.defaultView || window;
    styleCache.set(el, win.getComputedStyle(el));
  }
  return styleCache.get(el);
}
function getElementRect(el, opts = {}) {
  return createRect(getClientRect(el, opts));
}
function getClientRect(el, opts = {}) {
  const { excludeScrollbar = false, excludeBorders = false } = opts;
  const { x, y, width, height } = el.getBoundingClientRect();
  const r = { x, y, width, height };
  const style = getCacheComputedStyle(el);
  const { borderLeftWidth, borderTopWidth, borderRightWidth, borderBottomWidth } = style;
  const borderXWidth = sum(borderLeftWidth, borderRightWidth);
  const borderYWidth = sum(borderTopWidth, borderBottomWidth);
  if (excludeBorders) {
    r.width -= borderXWidth;
    r.height -= borderYWidth;
    r.x += px(borderLeftWidth);
    r.y += px(borderTopWidth);
  }
  if (excludeScrollbar) {
    const scrollbarWidth = el.offsetWidth - el.clientWidth - borderXWidth;
    const scrollbarHeight = el.offsetHeight - el.clientHeight - borderYWidth;
    r.width -= scrollbarWidth;
    r.height -= scrollbarHeight;
  }
  return r;
}
var px = (v) => parseFloat(v.replace("px", ""));
var sum = (...vals) => vals.reduce((sum2, v) => sum2 + (v ? px(v) : 0), 0);

// ../node_modules/.pnpm/@zag-js+rect-utils@1.36.0/node_modules/@zag-js/rect-utils/dist/from-window.mjs
function getWindowRect(win, opts = {}) {
  return createRect(getViewportRect(win, opts));
}
function getViewportRect(win, opts) {
  const { excludeScrollbar = false } = opts;
  const { innerWidth, innerHeight, document: doc, visualViewport } = win;
  const width = visualViewport?.width || innerWidth;
  const height = visualViewport?.height || innerHeight;
  const rect = { x: 0, y: 0, width, height };
  if (excludeScrollbar) {
    const scrollbarWidth = innerWidth - doc.documentElement.clientWidth;
    const scrollbarHeight = innerHeight - doc.documentElement.clientHeight;
    rect.width -= scrollbarWidth;
    rect.height -= scrollbarHeight;
  }
  return rect;
}

// ../node_modules/.pnpm/@zag-js+rect-utils@1.36.0/node_modules/@zag-js/rect-utils/dist/compass.mjs
var compassDirectionMap = {
  n: { x: 0.5, y: 0 },
  ne: { x: 1, y: 0 },
  e: { x: 1, y: 0.5 },
  se: { x: 1, y: 1 },
  s: { x: 0.5, y: 1 },
  sw: { x: 0, y: 1 },
  w: { x: 0, y: 0.5 },
  nw: { x: 0, y: 0 }
};
var oppositeDirectionMap = {
  n: "s",
  ne: "sw",
  e: "w",
  se: "nw",
  s: "n",
  sw: "ne",
  w: "e",
  nw: "se"
};

// ../node_modules/.pnpm/@zag-js+rect-utils@1.36.0/node_modules/@zag-js/rect-utils/dist/resize.mjs
var { sign, abs, min } = Math;
function getRectExtentPoint(rect, direction) {
  const { minX, minY, maxX, maxY, midX, midY } = rect;
  const x = direction.includes("w") ? minX : direction.includes("e") ? maxX : midX;
  const y = direction.includes("n") ? minY : direction.includes("s") ? maxY : midY;
  return { x, y };
}
function getOppositeDirection(direction) {
  return oppositeDirectionMap[direction];
}
function resizeRect(rect, offset, direction, opts) {
  const { scalingOriginMode, lockAspectRatio } = opts;
  const extent = getRectExtentPoint(rect, direction);
  const oppositeDirection = getOppositeDirection(direction);
  const oppositeExtent = getRectExtentPoint(rect, oppositeDirection);
  if (scalingOriginMode === "center") {
    offset = { x: offset.x * 2, y: offset.y * 2 };
  }
  const newExtent = {
    x: extent.x + offset.x,
    y: extent.y + offset.y
  };
  const multiplier = {
    x: compassDirectionMap[direction].x * 2 - 1,
    y: compassDirectionMap[direction].y * 2 - 1
  };
  const newSize = {
    width: newExtent.x - oppositeExtent.x,
    height: newExtent.y - oppositeExtent.y
  };
  const scaleX = multiplier.x * newSize.width / rect.width;
  const scaleY = multiplier.y * newSize.height / rect.height;
  const largestMagnitude = abs(scaleX) > abs(scaleY) ? scaleX : scaleY;
  const scale = lockAspectRatio ? { x: largestMagnitude, y: largestMagnitude } : {
    x: extent.x === oppositeExtent.x ? 1 : scaleX,
    y: extent.y === oppositeExtent.y ? 1 : scaleY
  };
  if (extent.y === oppositeExtent.y) {
    scale.y = abs(scale.y);
  } else if (sign(scale.y) !== sign(scaleY)) {
    scale.y *= -1;
  }
  if (extent.x === oppositeExtent.x) {
    scale.x = abs(scale.x);
  } else if (sign(scale.x) !== sign(scaleX)) {
    scale.x *= -1;
  }
  switch (scalingOriginMode) {
    case "extent":
      return transformRect(rect, AffineTransform.scale(scale.x, scale.y, oppositeExtent), false);
    case "center":
      return transformRect(
        rect,
        AffineTransform.scale(scale.x, scale.y, {
          x: rect.midX,
          y: rect.midY
        }),
        false
      );
  }
}
function createRectFromPoints(initialPoint, finalPoint, normalized = true) {
  if (normalized) {
    return {
      x: min(finalPoint.x, initialPoint.x),
      y: min(finalPoint.y, initialPoint.y),
      width: abs(finalPoint.x - initialPoint.x),
      height: abs(finalPoint.y - initialPoint.y)
    };
  }
  return {
    x: initialPoint.x,
    y: initialPoint.y,
    width: finalPoint.x - initialPoint.x,
    height: finalPoint.y - initialPoint.y
  };
}
function transformRect(rect, transform, normalized = true) {
  const p1 = transform.applyTo({ x: rect.minX, y: rect.minY });
  const p2 = transform.applyTo({ x: rect.maxX, y: rect.maxY });
  return createRectFromPoints(p1, p2, normalized);
}

// ../node_modules/.pnpm/@zag-js+floating-panel@1.36.0/node_modules/@zag-js/floating-panel/dist/floating-panel.dom.mjs
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

// ../node_modules/.pnpm/@zag-js+floating-panel@1.36.0/node_modules/@zag-js/floating-panel/dist/get-resize-axis-style.mjs
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

// ../node_modules/.pnpm/@zag-js+floating-panel@1.36.0/node_modules/@zag-js/floating-panel/dist/floating-panel.connect.mjs
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
    getStageTriggerProps(props) {
      if (!validStages.has(props.stage)) {
        throw new Error(`[zag-js] Invalid stage: ${props.stage}. Must be one of: ${Array.from(validStages).join(", ")}`);
      }
      const translations = prop("translations");
      const actionProps = match(props.stage, {
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
        "data-stage": props.stage,
        ...actionProps,
        type: "button",
        onClick(event) {
          if (event.defaultPrevented) return;
          if (!prop("resizable")) return;
          const type = match(props.stage, {
            minimized: () => "MINIMIZE",
            maximized: () => "MAXIMIZE",
            default: () => "RESTORE"
          });
          send({ type: type.toUpperCase() });
        }
      });
    },
    getResizeTriggerProps(props) {
      return normalize.element({
        ...parts.resizeTrigger.attrs,
        dir: prop("dir"),
        "data-disabled": dataAttr(!canResize),
        "data-axis": props.axis,
        onPointerDown(event) {
          if (!canResize) return;
          if (!isLeftClick(event)) return;
          event.currentTarget.setPointerCapture(event.pointerId);
          event.stopPropagation();
          send({
            type: "RESIZE_START",
            axis: props.axis,
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
          ...getResizeAxisStyle(props.axis)
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

// ../node_modules/.pnpm/@zag-js+floating-panel@1.36.0/node_modules/@zag-js/floating-panel/dist/floating-panel.store.mjs
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

// ../node_modules/.pnpm/@zag-js+floating-panel@1.36.0/node_modules/@zag-js/floating-panel/dist/floating-panel.machine.mjs
var { not, and } = createGuards();
var defaultTranslations = {
  minimize: "Minimize window",
  maximize: "Maximize window",
  restore: "Restore window"
};
var FALLBACK_SIZE = Object.freeze({ width: 320, height: 240 });
var FALLBACK_POSITION = Object.freeze({ x: 300, y: 100 });
var machine = createMachine({
  props({ props }) {
    ensureProps(props, ["id"], "floating-panel");
    return {
      strategy: "fixed",
      gridSize: 1,
      allowOverflow: true,
      resizable: true,
      draggable: true,
      ...props,
      translations: {
        ...defaultTranslations,
        ...props.translations
      }
    };
  },
  initialState({ prop }) {
    const open = prop("open") ?? prop("defaultOpen");
    return open ? "open" : "closed";
  },
  context({ prop, bindable }) {
    return {
      size: bindable(() => ({
        defaultValue: prop("defaultSize") ?? FALLBACK_SIZE,
        value: prop("size"),
        isEqual: isSizeEqual,
        hash(v) {
          return `W:${v.width} H:${v.height}`;
        },
        onChange(value) {
          prop("onSizeChange")?.({ size: value });
        }
      })),
      position: bindable(() => ({
        defaultValue: prop("defaultPosition") ?? FALLBACK_POSITION,
        value: prop("position"),
        isEqual: isPointEqual,
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
    hasSpecifiedPosition: ({ prop }) => prop("defaultPosition") != null || prop("position") != null,
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
          actions: ["setAnchorPosition", "setPositionStyle", "setSizeStyle", "setInitialFocus"]
        },
        OPEN: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["invokeOnOpen", "setAnchorPosition", "setPositionStyle", "setSizeStyle", "setInitialFocus"]
          }
        ]
      }
    },
    open: {
      tags: ["open"],
      entry: ["bringToFrontOfPanelStack"],
      initial: "idle",
      on: {
        "CONTROLLED.CLOSE": {
          target: "closed",
          actions: ["resetRect", "setFinalFocus"]
        },
        CLOSE: [
          {
            guard: "isOpenControlled",
            target: "closed",
            actions: ["invokeOnClose", "setFinalFocus"]
          },
          {
            target: "closed",
            actions: ["invokeOnClose", "resetRect", "setFinalFocus"]
          }
        ]
      },
      states: {
        idle: {
          effects: ["trackBoundaryRect"],
          on: {
            DRAG_START: {
              guard: not("isMaximized"),
              target: "dragging",
              actions: ["setPrevPosition"]
            },
            RESIZE_START: {
              guard: not("isMinimized"),
              target: "resizing",
              actions: ["setPrevSize"]
            },
            ESCAPE: [
              {
                guard: and("isOpenControlled", "closeOnEsc"),
                actions: ["invokeOnClose"]
              },
              {
                guard: "closeOnEsc",
                target: "closed",
                actions: ["invokeOnClose", "resetRect", "setFinalFocus"]
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
        dragging: {
          effects: ["trackPointerMove"],
          exit: ["clearPrevPosition"],
          on: {
            DRAG: {
              actions: ["setPositionFromDrag"]
            },
            DRAG_END: {
              target: "idle",
              actions: ["invokeOnDragEnd"]
            },
            ESCAPE: {
              target: "idle",
              actions: ["restorePosition"]
            }
          }
        },
        resizing: {
          effects: ["trackPointerMove"],
          exit: ["clearPrevSize"],
          on: {
            DRAG: {
              actions: ["setSizeFromDrag"]
            },
            DRAG_END: {
              target: "idle",
              actions: ["invokeOnResizeEnd"]
            },
            ESCAPE: {
              target: "idle",
              actions: ["restoreSize"]
            }
          }
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
      setPosition({ context, event, prop, scope }) {
        const boundaryEl = prop("getBoundaryEl")?.();
        const boundaryRect = getBoundaryRect(scope, boundaryEl, prop("allowOverflow"));
        const position = clampPoint(event.position, context.get("size"), boundaryRect);
        context.set("position", position);
      },
      setSize({ context, event, scope, prop }) {
        const boundaryEl = prop("getBoundaryEl")?.();
        const boundaryRect = getBoundaryRect(scope, boundaryEl, false);
        let nextSize = event.size;
        nextSize = clampSize(nextSize, prop("minSize"), prop("maxSize"));
        nextSize = clampSize(nextSize, prop("minSize"), boundaryRect);
        const nextPosition = clampPoint(context.get("position"), nextSize, boundaryRect);
        context.set("size", nextSize);
        context.set("position", nextPosition);
      },
      setAnchorPosition({ context, computed, prop, scope }) {
        if (computed("hasSpecifiedPosition")) return;
        const hasPrevRect = context.get("prevPosition") || context.get("prevSize");
        if (prop("persistRect") && hasPrevRect) return;
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
      },
      setPrevPosition({ context, event }) {
        context.set("prevPosition", { ...context.get("position") });
        context.set("lastEventPosition", event.position);
      },
      clearPrevPosition({ context, prop }) {
        if (!prop("persistRect")) context.set("prevPosition", null);
        context.set("lastEventPosition", null);
      },
      restorePosition({ context }) {
        const prevPosition = context.get("prevPosition");
        if (prevPosition) context.set("position", prevPosition);
      },
      setPositionFromDrag({ context, event, prop, scope }) {
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
      restoreSize({ context }) {
        const prevSize = context.get("prevSize");
        if (prevSize) context.set("size", prevSize);
        const prevPosition = context.get("prevPosition");
        if (prevPosition) context.set("position", prevPosition);
      },
      setSizeFromDrag({ context, event, scope, prop }) {
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
        if (context.get("stage") === "maximized") return;
        const wasDefault = context.get("stage") === "default";
        const currentSize = context.get("size");
        const currentPosition = context.get("position");
        const boundaryEl = prop("getBoundaryEl")?.();
        const boundaryRect = getBoundaryRect(scope, boundaryEl, false);
        const nextPosition = pick(boundaryRect, ["x", "y"]);
        const nextSize = pick(boundaryRect, ["height", "width"]);
        context.set("stage", "maximized");
        if (wasDefault) {
          context.set("prevSize", currentSize);
          context.set("prevPosition", currentPosition);
        }
        context.set("position", nextPosition);
        context.set("size", nextSize);
      },
      setMinimized({ context, scope }) {
        if (context.get("stage") === "minimized") return;
        const wasDefault = context.get("stage") === "default";
        const currentSize = context.get("size");
        const currentPosition = context.get("position");
        context.set("stage", "minimized");
        if (wasDefault) {
          context.set("prevSize", currentSize);
          context.set("prevPosition", currentPosition);
        }
        const headerEl = getHeaderEl(scope);
        if (!headerEl) return;
        const size = {
          ...currentSize,
          height: headerEl?.offsetHeight
        };
        context.set("size", size);
      },
      setRestored({ context, prop, scope }) {
        const boundaryRect = getBoundaryRect(scope, prop("getBoundaryEl")?.(), false);
        context.set("stage", "default");
        let restoredSize = context.get("size");
        const prevSize = context.get("prevSize");
        if (prevSize) {
          restoredSize = clampSize(prevSize, prop("minSize"), prop("maxSize"));
          restoredSize = clampSize(restoredSize, prop("minSize"), boundaryRect);
        }
        let restoredPosition = context.get("position");
        const prevPosition = context.get("prevPosition");
        if (prevPosition) {
          restoredPosition = clampPoint(prevPosition, restoredSize, boundaryRect);
        }
        context.set("size", restoredSize);
        context.set("position", restoredPosition);
        context.set("prevSize", null);
        context.set("prevPosition", null);
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
      setFinalFocus({ scope }) {
        raf(() => {
          getTriggerEl(scope)?.focus();
        });
      },
      setInitialFocus({ scope }) {
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

// components/floating-panel.ts
var FloatingPanel = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props) {
    return new VanillaMachine(machine, props);
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
