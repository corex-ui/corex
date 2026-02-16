// ../node_modules/.pnpm/@zag-js+rect-utils@1.33.1/node_modules/@zag-js/rect-utils/dist/index.mjs
var __defProp = Object.defineProperty;
var __defNormalProp = (obj, key, value) => key in obj ? __defProp(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
var __publicField = (obj, key, value) => __defNormalProp(obj, typeof key !== "symbol" ? key + "" : key, value);
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
function getPointAngle(rect, point, reference = rect.center) {
  const x = point.x - reference.x;
  const y = point.y - reference.y;
  const deg = Math.atan2(x, y) * (180 / Math.PI) + 180;
  return 360 - deg;
}
var clamp = (value, min3, max2) => Math.min(Math.max(value, min3), max2);
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
var createPoint = (x, y) => ({ x, y });
var subtractPoints = (a, b) => {
  if (!b) return a;
  return createPoint(a.x - b.x, a.y - b.y);
};
var addPoints = (a, b) => createPoint(a.x + b.x, a.y + b.y);
function createRect(r) {
  const { x, y, width, height } = r;
  const midX = x + width / 2;
  const midY = y + height / 2;
  return {
    x,
    y,
    width,
    height,
    minX: x,
    minY: y,
    maxX: x + width,
    maxY: y + height,
    midX,
    midY,
    center: createPoint(midX, midY)
  };
}
function getRectCorners(v) {
  const top = createPoint(v.minX, v.minY);
  const right = createPoint(v.maxX, v.minY);
  const bottom = createPoint(v.maxX, v.maxY);
  const left = createPoint(v.minX, v.maxY);
  return { top, right, bottom, left };
}
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
var isSizeEqual = (a, b) => {
  return a.width === b?.width && a.height === b?.height;
};
var isPointEqual = (a, b) => {
  return a.x === b?.x && a.y === b?.y;
};
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
var { min, max } = Math;
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
function getElementPolygon(rectValue, placement) {
  const rect = createRect(rectValue);
  const { top, right, left, bottom } = getRectCorners(rect);
  const [base] = placement.split("-");
  return {
    top: [left, top, right, bottom],
    right: [top, right, bottom, left],
    bottom: [top, left, bottom, right],
    left: [right, top, left, bottom]
  }[base];
}
function isPointInPolygon(polygon, point) {
  const { x, y } = point;
  let c = false;
  for (let i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
    const xi = polygon[i].x;
    const yi = polygon[i].y;
    const xj = polygon[j].x;
    const yj = polygon[j].y;
    if (yi > y !== yj > y && x < (xj - xi) * (y - yi) / (yj - yi) + xi) {
      c = !c;
    }
  }
  return c;
}
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
var { sign, abs, min: min2 } = Math;
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
      x: min2(finalPoint.x, initialPoint.x),
      y: min2(finalPoint.y, initialPoint.y),
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

export {
  getPointAngle,
  clampPoint,
  clampSize,
  subtractPoints,
  addPoints,
  createRect,
  constrainRect,
  isSizeEqual,
  isPointEqual,
  getElementRect,
  getWindowRect,
  getElementPolygon,
  isPointInPolygon,
  resizeRect
};
