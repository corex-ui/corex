import {
  ariaHidden,
  preventBodyScroll
} from "./chunks/chunk-V24WO2YM.mjs";
import {
  trapFocus
} from "./chunks/chunk-VAIEEUKU.mjs";
import {
  clampValue,
  toPx
} from "./chunks/chunk-AJX2XHOK.mjs";
import {
  trackDismissableElement
} from "./chunks/chunk-4ATAXYH3.mjs";
import "./chunks/chunk-AVGG6QG4.mjs";
import {
  idMatches,
  readPayloadId
} from "./chunks/chunk-EAQ6WQNO.mjs";
import {
  createAnatomy
} from "./chunks/chunk-YMOPD357.mjs";
import {
  AnimationFrame,
  Component,
  VanillaMachine,
  addDomEvent,
  canPushEvent,
  compact,
  contains,
  createGuards,
  createMachine,
  createZagLiveHook,
  dataAttr,
  disableTextSelection,
  getBoolean,
  getByOwnerId,
  getComputedStyle,
  getDir,
  getEventPoint,
  getEventTarget,
  getInitialFocus,
  getString,
  isEditableElement,
  isEqual,
  isFunction,
  isHTMLElement,
  isInputElement,
  isLeftClick,
  noop,
  queryAll,
  raf,
  resizeObserverBorderBox,
  waitForElement
} from "./chunks/chunk-R62PCG6O.mjs";

// ../node_modules/.pnpm/@zag-js+drawer@1.43.3/node_modules/@zag-js/drawer/dist/chunk-QZ7TP4HQ.mjs
var __defProp = Object.defineProperty;
var __defNormalProp = (obj, key, value) => key in obj ? __defProp(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
var __publicField = (obj, key, value) => __defNormalProp(obj, typeof key !== "symbol" ? key + "" : key, value);

// ../node_modules/.pnpm/@zag-js+drawer@1.43.3/node_modules/@zag-js/drawer/dist/drawer.anatomy.mjs
var anatomy = createAnatomy("drawer").parts(
  "positioner",
  "content",
  "title",
  "description",
  "trigger",
  "backdrop",
  "grabber",
  "grabberIndicator",
  "closeTrigger",
  "swipeArea"
);
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+drawer@1.43.3/node_modules/@zag-js/drawer/dist/drawer.dom.mjs
var getContentId = (ctx) => ctx.ids?.content ?? `drawer:${ctx.id}:content`;
var getPositionerId = (ctx) => ctx.ids?.positioner ?? `drawer:${ctx.id}:positioner`;
var getTitleId = (ctx) => ctx.ids?.title ?? `drawer:${ctx.id}:title`;
var getDescriptionId = (ctx) => ctx.ids?.description ?? `drawer:${ctx.id}:description`;
var getTriggerId = (ctx, value) => {
  const customId = ctx.ids?.trigger;
  if (customId != null) return isFunction(customId) ? customId(value) : customId;
  return value ? `drawer:${ctx.id}:trigger:${value}` : `drawer:${ctx.id}:trigger`;
};
var getTriggerEls = (ctx) => queryAll(ctx.getRootNode(), `[data-scope="drawer"][data-part="trigger"]${getByOwnerId(ctx.id)}`);
var getActiveTriggerEl = (ctx, value) => {
  if (value == null) return getTriggerEl(ctx) ?? getTriggerEls(ctx)[0];
  return ctx.getById(getTriggerId(ctx, value));
};
var getBackdropId = (ctx) => ctx.ids?.backdrop ?? `drawer:${ctx.id}:backdrop`;
var getGrabberId = (ctx) => ctx.ids?.grabber ?? `drawer:${ctx.id}:grabber`;
var getGrabberIndicatorId = (ctx) => ctx.ids?.grabberIndicator ?? `drawer:${ctx.id}:grabber-indicator`;
var getCloseTriggerId = (ctx) => ctx.ids?.closeTrigger ?? `drawer:${ctx.id}:close-trigger`;
var getSwipeAreaId = (ctx) => ctx.ids?.swipeArea ?? `drawer:${ctx.id}:swipe-area`;
var getContentEl = (ctx) => ctx.getById(getContentId(ctx));
var getPositionerEl = (ctx) => ctx.getById(getPositionerId(ctx));
var getTitleEl = (ctx) => ctx.getById(getTitleId(ctx));
var getDescriptionEl = (ctx) => ctx.getById(getDescriptionId(ctx));
var getTriggerEl = (ctx) => ctx.getById(getTriggerId(ctx));
var getBackdropEl = (ctx) => ctx.getById(getBackdropId(ctx));
var getCloseTriggerEl = (ctx) => ctx.getById(getCloseTriggerId(ctx));
var getSwipeAreaEl = (ctx) => ctx.getById(getSwipeAreaId(ctx));

// ../node_modules/.pnpm/@zag-js+drawer@1.43.3/node_modules/@zag-js/drawer/dist/utils/snap-point.mjs
function resolveSnapPointValue(snapPoint, viewportSize, rootFontSize) {
  if (!Number.isFinite(viewportSize) || viewportSize <= 0) return null;
  if (typeof snapPoint === "number") {
    if (!Number.isFinite(snapPoint)) return null;
    if (snapPoint <= 1) return clampValue(snapPoint, 0, 1) * viewportSize;
    return snapPoint;
  }
  const trimmed = snapPoint.trim();
  if (trimmed.endsWith("px")) {
    const value = Number.parseFloat(trimmed);
    return Number.isFinite(value) ? value : null;
  }
  if (trimmed.endsWith("rem")) {
    const value = Number.parseFloat(trimmed);
    return Number.isFinite(value) ? value * rootFontSize : null;
  }
  return null;
}
function resolveSnapPoint(snapPoint, options) {
  const { contentSize, viewportSize, rootFontSize } = options;
  const maxSize = Math.min(contentSize, viewportSize);
  if (!Number.isFinite(maxSize) || maxSize <= 0) return null;
  const resolvedSize = resolveSnapPointValue(snapPoint, viewportSize, rootFontSize);
  if (resolvedSize === null || !Number.isFinite(resolvedSize)) return null;
  const height = clampValue(resolvedSize, 0, maxSize);
  return {
    value: snapPoint,
    height,
    offset: Math.max(0, contentSize - height)
  };
}
var HEIGHT_DEDUP_EPSILON_PX = 1;
function dedupeSnapPoints(points) {
  if (points.length <= 1) return points;
  const deduped = [];
  const seenHeights = [];
  for (let index = points.length - 1; index >= 0; index -= 1) {
    const point = points[index];
    const isDuplicate = seenHeights.some((height) => Math.abs(height - point.height) <= HEIGHT_DEDUP_EPSILON_PX);
    if (isDuplicate) continue;
    seenHeights.push(point.height);
    deduped.push(point);
  }
  deduped.reverse();
  return deduped;
}
function findClosestSnapPoint(offset, snapPoints) {
  if (snapPoints.length === 0) return null;
  return snapPoints.reduce((acc, curr) => {
    const closestDiff = Math.abs(offset - acc.offset);
    const currentDiff = Math.abs(offset - curr.offset);
    return currentDiff < closestDiff ? curr : acc;
  });
}

// ../node_modules/.pnpm/@zag-js+drawer@1.43.3/node_modules/@zag-js/drawer/dist/utils/session.mjs
var VELOCITY_WINDOW_MS = 100;
var MAX_RELEASE_VELOCITY_AGE_MS = 80;
var MIN_GESTURE_DURATION_MS = 50;
var MIN_VELOCITY_SAMPLES = 2;
var SAMPLE_BUFFER_COMPACT_THRESHOLD = 8;
var DEFERRED_DRAG_MIN_MAIN_AXIS_PX = 6;
var DEFERRED_DRAG_MAIN_OVER_CROSS_RATIO = 1.35;
function isVerticalSwipeDirection(direction) {
  return direction === "down" || direction === "up";
}
function isNegativeSwipeDirection(direction) {
  return direction === "up" || direction === "left";
}
var SwipeSession = class {
  constructor() {
    __publicField(this, "startPoint", null);
    __publicField(this, "velocity", null);
    __publicField(this, "samples", []);
    __publicField(this, "sampleStartIndex", 0);
    __publicField(this, "gestureStartAxis", null);
    __publicField(this, "gestureStartTime", null);
    __publicField(this, "gestureSign", 1);
    __publicField(this, "pendingSwipe", null);
  }
  setStartPoint(point) {
    this.startPoint = point;
  }
  clearStartPoint() {
    this.startPoint = null;
  }
  getStartPoint() {
    return this.startPoint;
  }
  getGestureAxis(direction) {
    return direction === "left" || direction === "right" ? "x" : "y";
  }
  getGestureSign(direction) {
    return isNegativeSwipeDirection(direction) ? -1 : 1;
  }
  getAxisValue(point, axis) {
    return point[axis];
  }
  getMainAxisDisplacement(point, axis, sign) {
    if (!this.startPoint) return 0;
    const startAxis = this.getAxisValue(this.startPoint, axis);
    const currentAxis = this.getAxisValue(point, axis);
    return (startAxis - currentAxis) * sign;
  }
  getCrossAxisDisplacement(point, axis) {
    if (!this.startPoint) return 0;
    const crossAxis = axis === "x" ? "y" : "x";
    const startAxis = this.getAxisValue(this.startPoint, crossAxis);
    const currentAxis = this.getAxisValue(point, crossAxis);
    return currentAxis - startAxis;
  }
  track(point, axis, sign) {
    const axisValue = this.getAxisValue(point, axis);
    const now = performance.now();
    if (this.gestureStartAxis === null) {
      this.gestureStartAxis = axisValue;
      this.gestureStartTime = now;
      this.gestureSign = sign;
    }
    this.samples.push({ axis: axisValue, time: now });
    const cutoff = now - VELOCITY_WINDOW_MS;
    while (this.sampleStartIndex < this.samples.length && this.samples[this.sampleStartIndex].time < cutoff) {
      this.sampleStartIndex += 1;
    }
    if (this.sampleStartIndex >= SAMPLE_BUFFER_COMPACT_THRESHOLD) {
      this.samples = this.samples.slice(this.sampleStartIndex);
      this.sampleStartIndex = 0;
    }
    const sampleCount = this.samples.length - this.sampleStartIndex;
    if (sampleCount < MIN_VELOCITY_SAMPLES) {
      this.velocity = 0;
      return;
    }
    const oldest = this.samples[this.sampleStartIndex];
    const newest = this.samples[this.samples.length - 1];
    const dt = newest.time - oldest.time;
    if (dt <= 0) {
      this.velocity = 0;
      return;
    }
    const delta = (newest.axis - oldest.axis) * sign;
    const velocity = delta / dt * 1e3;
    this.velocity = Number.isFinite(velocity) ? velocity : 0;
  }
  getReleaseVelocity() {
    const now = performance.now();
    const sampleCount = this.samples.length - this.sampleStartIndex;
    if (sampleCount >= MIN_VELOCITY_SAMPLES) {
      const newest = this.samples[this.samples.length - 1];
      if (now - newest.time <= MAX_RELEASE_VELOCITY_AGE_MS) {
        return this.velocity ?? 0;
      }
    }
    if (this.gestureStartAxis !== null && this.gestureStartTime !== null) {
      const lastSample = this.samples[this.samples.length - 1];
      if (lastSample) {
        const dt = Math.max(lastSample.time - this.gestureStartTime, MIN_GESTURE_DURATION_MS);
        const delta = (lastSample.axis - this.gestureStartAxis) * this.gestureSign;
        const velocity = delta / dt * 1e3;
        return Number.isFinite(velocity) ? velocity : 0;
      }
    }
    return this.velocity ?? 0;
  }
  clearVelocityTracking() {
    this.samples = [];
    this.sampleStartIndex = 0;
    this.velocity = null;
    this.gestureStartAxis = null;
    this.gestureStartTime = null;
    this.gestureSign = 1;
  }
  clear() {
    this.cancelDeferredSwipe();
    this.clearStartPoint();
    this.clearVelocityTracking();
  }
  startDeferredSwipe(options) {
    const { getWin, pointerId, startPoint, swipeDirection, onCommit, canCommit, onCancel } = options;
    this.cancelDeferredSwipe();
    const win = getWin();
    const vertical = isVerticalSwipeDirection(swipeDirection);
    const onMove = (event) => {
      if (event.pointerId !== pointerId) return;
      const dx = event.clientX - startPoint.x;
      const dy = event.clientY - startPoint.y;
      const mainDelta = vertical ? dy : dx;
      const crossDelta = vertical ? dx : dy;
      const absMain = Math.abs(mainDelta);
      const absCross = Math.abs(crossDelta);
      if (absMain >= DEFERRED_DRAG_MIN_MAIN_AXIS_PX && absMain >= absCross * DEFERRED_DRAG_MAIN_OVER_CROSS_RATIO) {
        if (!canCommit || canCommit()) {
          onCommit(startPoint);
        }
        this.cancelDeferredSwipe();
      }
    };
    const onEnd = (event) => {
      if (event.pointerId !== pointerId) return;
      onCancel?.();
      this.cancelDeferredSwipe();
    };
    const cleanups = [
      addDomEvent(win, "pointermove", onMove, { capture: true }),
      addDomEvent(win, "pointerup", onEnd, { capture: true }),
      addDomEvent(win, "pointercancel", onEnd, { capture: true }),
      addDomEvent(win, "lostpointercapture", onEnd, { capture: true })
    ];
    this.pendingSwipe = { pointerId, startPoint, cleanups };
  }
  cancelDeferredSwipe() {
    if (!this.pendingSwipe) return;
    this.pendingSwipe.cleanups.forEach((cleanup) => cleanup());
    this.pendingSwipe = null;
  }
  bind(options) {
    const {
      getDoc,
      getSelectionTarget,
      swipeDirection,
      onStart,
      onMove,
      onEnd,
      onCancel,
      preventDefault,
      cancelOnInterrupt
    } = options;
    const doc = getDoc();
    let usingTouchEvents = false;
    let restoreSelection;
    const axis = this.getGestureAxis(swipeDirection);
    const sign = this.getGestureSign(swipeDirection);
    const trackPoint = (point) => {
      this.track(point, axis, sign);
    };
    const startSelectionGuard = () => {
      restoreSelection ?? (restoreSelection = disableTextSelection({
        doc,
        target: getSelectionTarget?.()
      }));
    };
    const stopSelectionGuard = () => {
      restoreSelection?.();
      restoreSelection = void 0;
    };
    function onPointerMove(event) {
      if (event.pointerType === "touch" && usingTouchEvents) return;
      const point = getEventPoint(event);
      const target = getEventTarget(event);
      startSelectionGuard();
      trackPoint(point);
      onMove({
        point,
        target,
        event,
        pointerType: event.pointerType,
        axis,
        swipeDirection
      });
    }
    function onPointerUp(event) {
      if (event.pointerType === "touch" && usingTouchEvents) {
        usingTouchEvents = false;
        return;
      }
      stopSelectionGuard();
      onEnd({ point: getEventPoint(event), swipeDirection });
    }
    function onPointerCancel(event) {
      if (event.pointerType === "touch" && usingTouchEvents) {
        usingTouchEvents = false;
        return;
      }
      stopSelectionGuard();
      onCancel();
    }
    function onTouchStartEvent(event) {
      if (!event.touches[0]) return;
      usingTouchEvents = true;
      const point = getEventPoint(event);
      const target = getEventTarget(event);
      onStart?.({ point, target, event, pointerType: "touch", axis, swipeDirection });
    }
    function onTouchMoveEvent(event) {
      if (!event.touches[0]) return;
      usingTouchEvents = true;
      const point = getEventPoint(event);
      const target = getEventTarget(event);
      const details = { point, target, event, pointerType: "touch", axis, swipeDirection };
      if (preventDefault?.(details) && event.cancelable) {
        event.preventDefault();
      }
      startSelectionGuard();
      trackPoint(point);
      onMove(details);
    }
    function onTouchEnd(event) {
      if (event.touches.length !== 0) return;
      stopSelectionGuard();
      onEnd({ point: getEventPoint(event), swipeDirection });
    }
    function onTouchCancel() {
      stopSelectionGuard();
      onCancel();
    }
    function onVisibilityChange() {
      if (doc.visibilityState !== "hidden") return;
      const shouldCancel = cancelOnInterrupt?.({
        reason: "visibility-hidden",
        event: doc,
        target: null,
        pointerType: null
      });
      if (shouldCancel === false) return;
      stopSelectionGuard();
      onCancel();
    }
    function onLostPointerCapture(event) {
      if (event.pointerType === "touch") return;
      const target = getEventTarget(event);
      const shouldCancel = cancelOnInterrupt?.({
        reason: "lost-pointer-capture",
        event,
        target,
        pointerType: event.pointerType
      });
      if (shouldCancel === false) return;
      onCancel();
    }
    const cleanups = [
      addDomEvent(doc, "pointermove", onPointerMove),
      addDomEvent(doc, "pointerup", onPointerUp),
      addDomEvent(doc, "pointercancel", onPointerCancel),
      addDomEvent(doc, "touchstart", onTouchStartEvent, { capture: true, passive: false }),
      addDomEvent(doc, "touchmove", onTouchMoveEvent, { capture: true, passive: false }),
      addDomEvent(doc, "touchend", onTouchEnd, { capture: true }),
      addDomEvent(doc, "touchcancel", onTouchCancel, { capture: true }),
      addDomEvent(doc, "visibilitychange", onVisibilityChange),
      addDomEvent(doc, "lostpointercapture", onLostPointerCapture, true)
    ];
    return () => {
      stopSelectionGuard();
      cleanups.forEach((cleanup) => cleanup());
    };
  }
};

// ../node_modules/.pnpm/@zag-js+drawer@1.43.3/node_modules/@zag-js/drawer/dist/utils/drawer-session.mjs
var RELEASE_DISPLACEMENT_TRUST_PX = 24;
var OPEN_SWIPE_HIDDEN_VISIBLE_RATIO = 0.22;
var OPEN_SWIPE_HIDDEN_VELOCITY_MULTIPLIER = 1.25;
var OPEN_SWIPE_REVEALED_VISIBLE_RATIO = 0.5;
var OPEN_SWIPE_REVEALED_OPPOSING_MAX_ABS_VELOCITY = 650;
var DRAG_START_THRESHOLD = 0.3;
var CROSS_AXIS_BIAS = 0.58;
var SCROLL_SLACK_GATE = 0.5;
var SCROLL_SLACK_EPSILON = 1;
var SEQUENTIAL_THRESHOLD = 24;
var SNAP_VELOCITY_THRESHOLD = 400;
var SNAP_VELOCITY_MULTIPLIER = 0.4;
var MAX_SNAP_VELOCITY = 4e3;
var SWIPE_STRENGTH_MAX_DURATION_MS = 360;
var SWIPE_STRENGTH_MIN_SCALAR = 0.1;
var SWIPE_STRENGTH_MAX_SCALAR = 1;
var SWIPE_AREA_OPEN_INTENT_MIN_PX = 5;
var NO_DRAG_DATA_ATTR = "data-no-drag";
var NO_DRAG_SELECTOR = `[${NO_DRAG_DATA_ATTR}]`;
var DrawerSwipeSession = class {
  constructor(options) {
    __publicField(this, "session", new SwipeSession());
    __publicField(this, "dragOffset", null);
    __publicField(this, "preventDragOnScroll");
    this.preventDragOnScroll = options.preventDragOnScroll;
  }
  contentPointerDown(options) {
    const { event, getDoc, getContentEl: getContentEl2, getWin, swipeDirection, canCommit, onCommit } = options;
    if (shouldIgnorePointerDownForDrag(event)) return;
    if (isTextSelectionInDrawer(getDoc(), getContentEl2())) return;
    if (!canCommit()) return;
    const point = getEventPoint(event);
    const shouldDefer = event.pointerType === "mouse" || event.pointerType === "pen";
    if (!shouldDefer) {
      onCommit(point);
      return;
    }
    this.session.startDeferredSwipe({
      getWin,
      pointerId: event.pointerId,
      startPoint: point,
      swipeDirection,
      onCommit,
      canCommit
    });
  }
  grabberPointerDown(options) {
    const { event, point, canCommit, onCommit } = options;
    if (shouldIgnorePointerDownForDrag(event)) return;
    this.session.cancelDeferredSwipe();
    if (!canCommit()) return;
    onCommit(point);
  }
  adjustReleaseVelocityAgainstDisplacement(velocity, displacementFromSnap) {
    const displacementSign = Math.sign(displacementFromSnap);
    const velocitySign = Math.sign(velocity);
    if (displacementSign !== 0 && Math.abs(displacementFromSnap) >= RELEASE_DISPLACEMENT_TRUST_PX && velocitySign !== 0 && velocitySign !== displacementSign) {
      return 0;
    }
    return velocity;
  }
  adjustReleaseVelocityForOpenSwipe(velocity, visibleRatio, swipeVelocityThreshold) {
    if (visibleRatio < OPEN_SWIPE_HIDDEN_VISIBLE_RATIO && velocity < 0 && Math.abs(velocity) < swipeVelocityThreshold * OPEN_SWIPE_HIDDEN_VELOCITY_MULTIPLIER) {
      return 0;
    }
    if (visibleRatio > OPEN_SWIPE_REVEALED_VISIBLE_RATIO && velocity > 0 && Math.abs(velocity) < OPEN_SWIPE_REVEALED_OPPOSING_MAX_ABS_VELOCITY) {
      return 0;
    }
    return velocity;
  }
  beginSwipe(point) {
    this.session.setStartPoint(point);
  }
  clearSwipeStart() {
    this.session.clearStartPoint();
  }
  getSwipeStart() {
    return this.session.getStartPoint();
  }
  getDragOffset() {
    return this.dragOffset;
  }
  resetDragOffset() {
    this.dragOffset = null;
  }
  resetVelocity() {
    this.session.clearVelocityTracking();
  }
  reset() {
    this.dragOffset = null;
    this.session.clear();
  }
  setDragOffset(point, resolvedActiveSnapPointOffset, direction) {
    if (!this.session.getStartPoint()) {
      this.dragOffset = null;
      return;
    }
    const axis = this.session.getGestureAxis(direction);
    const sign = this.session.getGestureSign(direction);
    let delta = this.session.getMainAxisDisplacement(point, axis, sign) - resolvedActiveSnapPointOffset;
    if (delta > 0) {
      delta = Math.sqrt(delta);
    }
    this.dragOffset = -delta;
  }
  setSwipeOpenOffset(point, contentSize, direction) {
    if (!this.session.getStartPoint()) {
      this.dragOffset = null;
      return;
    }
    const axis = this.session.getGestureAxis(direction);
    const sign = this.session.getGestureSign(direction);
    const openDisplacement = this.session.getMainAxisDisplacement(point, axis, sign);
    let dragOffset = contentSize - Math.max(0, openDisplacement);
    if (dragOffset < 0) {
      dragOffset = -Math.sqrt(Math.abs(dragOffset));
    }
    this.dragOffset = dragOffset;
  }
  canStartDrag(point, target, container, preventDragOnScroll, direction) {
    if (!isHTMLElement(target)) return false;
    if (isDragExemptElement(target)) return false;
    if (!this.session.getStartPoint() || !container) return false;
    if (!preventDragOnScroll) return true;
    const axis = this.session.getGestureAxis(direction);
    const sign = this.session.getGestureSign(direction);
    const delta = this.session.getMainAxisDisplacement(point, axis, sign);
    if (Math.abs(delta) < DRAG_START_THRESHOLD) return false;
    const crossDelta = Math.abs(this.session.getCrossAxisDisplacement(point, axis));
    if (crossDelta > Math.abs(delta) * CROSS_AXIS_BIAS) {
      const crossDirection = isVerticalSwipeDirection(direction) ? "right" : "down";
      const crossScroll = getScrollInfo(target, container, crossDirection);
      if (crossScroll.availableForwardScroll > SCROLL_SLACK_GATE || crossScroll.availableBackwardScroll > SCROLL_SLACK_GATE) {
        return false;
      }
    }
    const { availableForwardScroll, availableBackwardScroll } = getScrollInfo(target, container, direction);
    if (delta > 0 && availableForwardScroll > SCROLL_SLACK_GATE || delta < 0 && availableBackwardScroll > SCROLL_SLACK_GATE) {
      return false;
    }
    return true;
  }
  resolveSnapPointOnRelease(snapPoints, snapPoint, snapToSequentialPoints, contentSize) {
    const dragOffset = this.dragOffset;
    if (dragOffset === null) return snapPoints[0]?.value ?? 1;
    const releaseVelocity = this.session.getReleaseVelocity();
    if (snapToSequentialPoints && snapPoint) {
      const ordered = [...snapPoints].sort((a, b) => a.offset - b.offset);
      let currentIndex = 0;
      let closestDist = Math.abs(snapPoint.offset - ordered[0].offset);
      for (let i = 1; i < ordered.length; i++) {
        const dist = Math.abs(snapPoint.offset - ordered[i].offset);
        if (dist < closestDist) {
          closestDist = dist;
          currentIndex = i;
        }
      }
      const currentPoint = ordered[currentIndex];
      const delta = dragOffset - currentPoint.offset;
      const dragDirection = Math.sign(delta);
      const velocityAdjusted = this.adjustReleaseVelocityAgainstDisplacement(releaseVelocity, delta);
      const velocityDirection = Math.sign(velocityAdjusted);
      let targetSnapPoint = currentPoint;
      let effectiveTargetOffset = dragOffset;
      const shouldAdvance = dragDirection !== 0 && velocityDirection === dragDirection && Math.abs(velocityAdjusted) >= SNAP_VELOCITY_THRESHOLD;
      if (shouldAdvance) {
        const adjacentIndex = Math.min(Math.max(currentIndex + dragDirection, 0), ordered.length - 1);
        if (adjacentIndex !== currentIndex) {
          targetSnapPoint = ordered[adjacentIndex];
          effectiveTargetOffset = targetSnapPoint.offset;
        } else if (dragDirection > 0) {
          return null;
        }
      } else if (delta > SEQUENTIAL_THRESHOLD) {
        const nextPoint = ordered[Math.min(currentIndex + 1, ordered.length - 1)];
        if (nextPoint) {
          targetSnapPoint = nextPoint;
          effectiveTargetOffset = nextPoint.offset;
        }
      } else if (delta < -SEQUENTIAL_THRESHOLD) {
        const prevPoint = ordered[Math.max(currentIndex - 1, 0)];
        if (prevPoint) {
          targetSnapPoint = prevPoint;
          effectiveTargetOffset = prevPoint.offset;
        }
      }
      const closeDistance = Math.abs(effectiveTargetOffset - contentSize);
      const snapDistance = Math.abs(effectiveTargetOffset - targetSnapPoint.offset);
      if (closeDistance < snapDistance) return null;
      return targetSnapPoint.value;
    }
    const snapRestOffset = snapPoint?.offset ?? 0;
    const velocity = this.adjustReleaseVelocityAgainstDisplacement(releaseVelocity, dragOffset - snapRestOffset);
    let targetOffset = dragOffset;
    if (Math.abs(velocity) >= SNAP_VELOCITY_THRESHOLD) {
      const clamped = clampValue(velocity, -MAX_SNAP_VELOCITY, MAX_SNAP_VELOCITY);
      targetOffset += clamped * SNAP_VELOCITY_MULTIPLIER;
      targetOffset = Math.max(0, targetOffset);
    }
    return findClosestSnapPoint(targetOffset, snapPoints)?.value ?? null;
  }
  shouldOpenOnRelease(contentSize, swipeVelocityThreshold, openThreshold) {
    const dragOffset = this.dragOffset;
    if (dragOffset === null || contentSize === null) return false;
    const visibleSize = contentSize - dragOffset;
    const visibleRatio = visibleSize / contentSize;
    const velocity = this.adjustReleaseVelocityForOpenSwipe(
      this.session.getReleaseVelocity(),
      visibleRatio,
      swipeVelocityThreshold
    );
    return velocity < 0 && Math.abs(velocity) >= swipeVelocityThreshold || visibleSize >= contentSize * openThreshold;
  }
  shouldDismissOnRelease(contentSize, snapPoints, resolvedSnapOffset) {
    const dragOffset = this.dragOffset;
    if (dragOffset === null || contentSize === null) return false;
    const velocity = this.adjustReleaseVelocityAgainstDisplacement(
      this.session.getReleaseVelocity(),
      dragOffset - resolvedSnapOffset
    );
    const visibleSize = contentSize - dragOffset;
    if (visibleSize <= 0) return true;
    let targetOffset = dragOffset;
    if (Math.abs(velocity) >= SNAP_VELOCITY_THRESHOLD) {
      const clamped = clampValue(velocity, -MAX_SNAP_VELOCITY, MAX_SNAP_VELOCITY);
      targetOffset += clamped * SNAP_VELOCITY_MULTIPLIER;
      targetOffset = Math.max(0, targetOffset);
    }
    const closest = findClosestSnapPoint(targetOffset, snapPoints);
    if (!closest) return false;
    const closeDistance = Math.abs(targetOffset - contentSize);
    const snapDistance = Math.abs(targetOffset - closest.offset);
    return closeDistance < snapDistance;
  }
  getSwipeStrength(targetOffset, resolvedSnapOffset = null) {
    const dragOffset = this.dragOffset;
    if (dragOffset === null) return SWIPE_STRENGTH_MAX_SCALAR;
    let velocity = this.session.getReleaseVelocity();
    if (resolvedSnapOffset != null) {
      velocity = this.adjustReleaseVelocityAgainstDisplacement(velocity, dragOffset - resolvedSnapOffset);
    }
    const distance = Math.abs(dragOffset - targetOffset);
    const absVelocity = Math.abs(velocity);
    if (absVelocity <= 0 || distance <= 0) return SWIPE_STRENGTH_MAX_SCALAR;
    const estimatedTimeMs = distance / absVelocity * 1e3;
    const normalized = clampValue(estimatedTimeMs / SWIPE_STRENGTH_MAX_DURATION_MS, 0, 1);
    return SWIPE_STRENGTH_MIN_SCALAR + normalized * (SWIPE_STRENGTH_MAX_SCALAR - SWIPE_STRENGTH_MIN_SCALAR);
  }
  bindDragTracking(options) {
    const { getDoc, getContentEl: getContentEl2, getSwipeAreaEl: getSwipeAreaEl2, swipeDirection, onMove, onEnd, onCancel } = options;
    const preventDragOnScroll = this.preventDragOnScroll;
    const isVertical = isVerticalSwipeDirection(swipeDirection);
    let lastAxis = 0;
    return this.session.bind({
      getDoc,
      getSelectionTarget: getContentEl2,
      swipeDirection,
      onMove,
      onEnd,
      onCancel,
      cancelOnInterrupt: ({ reason, target }) => {
        if (reason !== "lost-pointer-capture") return true;
        return isWithinDrawerInteractionSurface(target, getContentEl2(), getSwipeAreaEl2());
      },
      onStart({ pointerType, point }) {
        if (pointerType !== "touch") return;
        lastAxis = isVertical ? point.y : point.x;
      },
      preventDefault({ event, pointerType, point, target }) {
        if (pointerType !== "touch") return false;
        const contentEl = getContentEl2();
        const resolvedTarget = target ?? event.target;
        if (!preventDragOnScroll()) return false;
        if (!contentEl || !resolvedTarget || isDragExemptElement(resolvedTarget)) return false;
        const scrollParent = findClosestScrollableAncestorOnSwipeAxis(resolvedTarget, contentEl, swipeDirection);
        if (scrollParent) {
          const currentAxis = isVertical ? point.y : point.x;
          const shouldPrevent = shouldPreventTouchScroll({
            scrollParent,
            swipeDirection,
            lastMainAxis: lastAxis,
            currentMainAxis: currentAxis
          });
          lastAxis = currentAxis;
          return shouldPrevent;
        }
        lastAxis = isVertical ? point.y : point.x;
        return false;
      }
    });
  }
  bindSwipeOpenTracking(options) {
    const { getDoc, getContentEl: getContentEl2, getSwipeAreaEl: getSwipeAreaEl2, swipeDirection, onMove, onEnd, onCancel } = options;
    return this.session.bind({
      getDoc,
      getSelectionTarget: getSwipeAreaEl2,
      swipeDirection,
      onMove({ point }) {
        onMove({ point });
      },
      onEnd,
      onCancel,
      cancelOnInterrupt: ({ reason, target }) => {
        if (reason !== "lost-pointer-capture") return true;
        return isWithinDrawerInteractionSurface(target, getContentEl2(), getSwipeAreaEl2());
      }
    });
  }
};
function isWithinDrawerInteractionSurface(target, contentEl, swipeAreaEl) {
  if (!target) return false;
  return contains(contentEl, target) || contains(swipeAreaEl, target);
}
var oppositeSwipeDirection = {
  up: "down",
  down: "up",
  start: "end",
  end: "start"
};
function resolveSwipeDirection(direction, dir) {
  if (direction === "start") return dir === "rtl" ? "right" : "left";
  if (direction === "end") return dir === "rtl" ? "left" : "right";
  return direction;
}
function getSwipeDirectionSize(rect, direction) {
  return isVerticalSwipeDirection(direction) ? rect.height : rect.width;
}
function resolveSwipeProgress(contentSize, dragOffset, snapPointOffset) {
  if (!contentSize || contentSize <= 0) return 0;
  const currentOffset = dragOffset ?? snapPointOffset;
  return clampValue(currentOffset / contentSize, 0, 1);
}
function hasOpeningSwipeIntent(start, current, direction) {
  const axis = isVerticalSwipeDirection(direction) ? "y" : "x";
  const sign = isNegativeSwipeDirection(direction) ? -1 : 1;
  const displacement = (start[axis] - current[axis]) * sign;
  return displacement > SWIPE_AREA_OPEN_INTENT_MIN_PX;
}
function overflowAllowsScroll(overflow) {
  return overflow === "auto" || overflow === "scroll" || overflow === "overlay";
}
function canScrollAlongY(el) {
  const style = getComputedStyle(el);
  if (!overflowAllowsScroll(style.overflowY)) return false;
  return el.scrollHeight > el.clientHeight + SCROLL_SLACK_EPSILON;
}
function canScrollAlongX(el) {
  const style = getComputedStyle(el);
  if (!overflowAllowsScroll(style.overflowX)) return false;
  return el.scrollWidth > el.clientWidth + SCROLL_SLACK_EPSILON;
}
function canScrollOnSwipeAxis(el, direction) {
  return isVerticalSwipeDirection(direction) ? canScrollAlongY(el) : canScrollAlongX(el);
}
function findClosestScrollableAncestorOnSwipeAxis(target, container, direction) {
  if (!container) return null;
  let el = target;
  while (el && el !== container) {
    if (canScrollOnSwipeAxis(el, direction)) return el;
    el = el.parentElement;
  }
  return null;
}
function getScrollInfo(target, container, direction) {
  let availableForwardScroll = 0;
  let availableBackwardScroll = 0;
  if (!container) return { availableForwardScroll, availableBackwardScroll };
  const vertical = isVerticalSwipeDirection(direction);
  let element = target;
  while (element) {
    if (vertical ? canScrollAlongY(element) : canScrollAlongX(element)) {
      const clientSize = vertical ? element.clientHeight : element.clientWidth;
      const scrollPos = vertical ? element.scrollTop : element.scrollLeft;
      const scrollSize = vertical ? element.scrollHeight : element.scrollWidth;
      const scrolled = scrollSize - scrollPos - clientSize;
      availableForwardScroll += scrolled;
      availableBackwardScroll += scrollPos;
    }
    if (element === container || element === element.ownerDocument.documentElement) break;
    element = element.parentElement;
  }
  return { availableForwardScroll, availableBackwardScroll };
}
function shouldPreventTouchScroll(options) {
  const { scrollParent, swipeDirection, lastMainAxis, currentMainAxis } = options;
  const vertical = isVerticalSwipeDirection(swipeDirection);
  const movingPositive = currentMainAxis > lastMainAxis;
  if (vertical) {
    const scrollPos = scrollParent.scrollTop;
    const maxScroll = Math.max(0, scrollParent.scrollHeight - scrollParent.clientHeight);
    if (swipeDirection === "down") return scrollPos <= SCROLL_SLACK_EPSILON && movingPositive;
    if (swipeDirection === "up") return scrollPos >= maxScroll - SCROLL_SLACK_EPSILON && !movingPositive;
  } else {
    const scrollPos = scrollParent.scrollLeft;
    const maxScroll = Math.max(0, scrollParent.scrollWidth - scrollParent.clientWidth);
    if (swipeDirection === "right") return scrollPos <= SCROLL_SLACK_EPSILON && movingPositive;
    if (swipeDirection === "left") return scrollPos >= maxScroll - SCROLL_SLACK_EPSILON && !movingPositive;
  }
  return false;
}
function isDragExemptElement(el) {
  if (!isHTMLElement(el)) return false;
  if (el.closest(NO_DRAG_SELECTOR)) return true;
  let node = el;
  while (node) {
    if (isEditableElement(node)) return true;
    node = node.parentElement;
  }
  const input = el.closest("input");
  if (isInputElement(input)) {
    const type = input.type;
    if (type === "range" || type === "file") return true;
  }
  return false;
}
function isTextSelectionInDrawer(doc, contentEl) {
  if (!contentEl) return false;
  const selection = doc.getSelection();
  if (!selection || selection.rangeCount === 0 || selection.isCollapsed) return false;
  try {
    const range = selection.getRangeAt(0);
    if (contains(contentEl, range.commonAncestorContainer)) return true;
    if (contains(contentEl, selection.anchorNode)) return true;
    if (contains(contentEl, selection.focusNode)) return true;
    if (typeof range.intersectsNode === "function" && range.intersectsNode(contentEl)) return true;
  } catch {
    return false;
  }
  return false;
}
function isDragExemptFromComposedPath(event) {
  const path = typeof event.composedPath === "function" ? event.composedPath() : [];
  for (const node of path) {
    if (isDragExemptElement(node)) return true;
  }
  return isDragExemptElement(event.target);
}
function shouldIgnorePointerDownForDrag(event) {
  if (!isLeftClick(event)) return true;
  const target = getEventTarget(event);
  if (target?.hasAttribute(NO_DRAG_DATA_ATTR) || target?.closest(NO_DRAG_SELECTOR)) return true;
  return isDragExemptFromComposedPath(event);
}

// ../node_modules/.pnpm/@zag-js+drawer@1.43.3/node_modules/@zag-js/drawer/dist/drawer.connect.mjs
var SWIPE_OPEN_HIDDEN_OFFSET = 9999;
function getSwipeOpenOffset(swipingOpen, dragOffset, contentSize) {
  if (!swipingOpen || dragOffset !== null) return null;
  return contentSize ?? SWIPE_OPEN_HIDDEN_OFFSET;
}
function connect(service, normalize) {
  const { state, send, context, scope, prop, refs } = service;
  const open = state.hasTag("open");
  const closed = state.matches("closed");
  const closing = state.matches("closing");
  const swipingOpen = state.matches("swiping-open");
  const dragOffset = context.get("dragOffset");
  const dragging = dragOffset !== null;
  const triggerValue = context.get("triggerValue");
  const snapPoint = context.get("snapPoint");
  const swipeDirection = prop("swipeDirection");
  const physicalDirection = resolveSwipeDirection(swipeDirection, prop("dir"));
  const contentSize = context.get("contentSize");
  const swipeStrength = context.get("swipeStrength");
  const resolvedActiveSnapPoint = context.get("resolvedActiveSnapPoint");
  const snapPointOffset = resolvedActiveSnapPoint?.offset ?? 0;
  const nestedMetrics = context.get("nestedMetrics");
  const swipeOpenOffset = getSwipeOpenOffset(swipingOpen, dragOffset, contentSize);
  const currentOffset = swipeOpenOffset ?? dragOffset ?? snapPointOffset;
  const signedSnapPointOffset = isNegativeSwipeDirection(physicalDirection) ? -snapPointOffset : snapPointOffset;
  const isActivelySwiping = dragging || swipingOpen;
  const swipeMovement = dragging || swipingOpen ? currentOffset - snapPointOffset : 0;
  const signedMovement = isNegativeSwipeDirection(physicalDirection) ? -swipeMovement : swipeMovement;
  const swipeProgress = isActivelySwiping && contentSize && contentSize > 0 ? clampValue(Math.abs(signedMovement) / contentSize, 0, 1) : swipingOpen ? 1 : 0;
  const signedCurrentOffset = isNegativeSwipeDirection(physicalDirection) ? -currentOffset : currentOffset;
  const translateX = isVerticalSwipeDirection(physicalDirection) ? 0 : signedCurrentOffset;
  const translateY = isVerticalSwipeDirection(physicalDirection) ? signedCurrentOffset : 0;
  function onContentPointerDown(event) {
    refs.get("swipeSession").contentPointerDown({
      event,
      getDoc: () => scope.getDoc(),
      getContentEl: () => getContentEl(scope),
      getWin: () => scope.getWin(),
      swipeDirection: physicalDirection,
      canCommit: () => state.hasTag("open") && !state.matches("closing"),
      onCommit(point) {
        send({ type: "POINTER_DOWN", point });
      }
    });
  }
  function onGrabberPointerDown(event) {
    refs.get("swipeSession").grabberPointerDown({
      event,
      point: getEventPoint(event),
      canCommit: () => state.hasTag("open") && !state.matches("closing"),
      onCommit(point) {
        send({ type: "POINTER_DOWN", point });
      }
    });
  }
  return {
    open,
    dragging,
    setOpen(nextOpen) {
      const open2 = state.hasTag("open");
      if (open2 === nextOpen) return;
      send({ type: nextOpen ? "OPEN" : "CLOSE" });
    },
    snapPoints: prop("snapPoints"),
    swipeDirection,
    snapPoint,
    setSnapPoint(snapPoint2) {
      const currentSnapPoint = context.get("snapPoint");
      if (currentSnapPoint === snapPoint2) return;
      send({ type: "SNAP_POINT.SET", snapPoint: snapPoint2 });
    },
    getOpenPercentage() {
      if (!open || !contentSize) return 0;
      return clampValue(1 - currentOffset / contentSize, 0, 1);
    },
    getSnapPointIndex() {
      if (snapPoint === null) return -1;
      return prop("snapPoints").indexOf(snapPoint);
    },
    getContentSize() {
      return contentSize;
    },
    getPositionerProps() {
      return normalize.element({
        ...parts.positioner.attrs,
        id: getPositionerId(scope),
        dir: prop("dir"),
        hidden: closed,
        "data-state": open ? "open" : "closed",
        "data-swipe-direction": physicalDirection,
        style: compact({
          pointerEvents: closing || !prop("modal") ? "none" : void 0
        })
      });
    },
    getContentProps(props = { draggable: true }) {
      const movementX = isVerticalSwipeDirection(physicalDirection) ? 0 : signedMovement;
      const movementY = isVerticalSwipeDirection(physicalDirection) ? signedMovement : 0;
      const rendered = context.get("rendered");
      return normalize.element({
        ...parts.content.attrs,
        dir: prop("dir"),
        id: getContentId(scope),
        tabIndex: -1,
        role: prop("role"),
        "aria-modal": prop("modal"),
        "aria-labelledby": rendered.title ? getTitleId(scope) : void 0,
        "aria-describedby": rendered.description ? getDescriptionId(scope) : void 0,
        hidden: !open,
        "data-state": open ? "open" : "closed",
        "data-expanded": resolvedActiveSnapPoint?.offset === 0 ? "" : void 0,
        "data-swipe-direction": physicalDirection,
        "data-swiping": dragging || swipingOpen ? "" : void 0,
        "data-dragging": dragging ? "" : void 0,
        "data-nested-drawer-open": nestedMetrics.open ? "" : void 0,
        "data-nested-drawer-swiping": nestedMetrics.swiping ? "" : void 0,
        style: compact({
          pointerEvents: prop("modal") ? void 0 : "auto",
          visibility: swipingOpen && dragOffset === null ? "hidden" : void 0,
          transform: "translate3d(var(--drawer-translate-x, 0px), var(--drawer-translate-y, 0px), 0)",
          transitionDuration: dragging || swipingOpen ? "0s" : void 0,
          "--drawer-translate": toPx(translateY),
          "--drawer-translate-x": toPx(translateX),
          "--drawer-translate-y": toPx(translateY),
          "--drawer-snap-point-offset-x": isVerticalSwipeDirection(physicalDirection) ? "0px" : toPx(signedSnapPointOffset),
          "--drawer-snap-point-offset-y": isVerticalSwipeDirection(physicalDirection) ? toPx(signedSnapPointOffset) : "0px",
          "--drawer-swipe-movement-x": toPx(movementX),
          "--drawer-swipe-movement-y": toPx(movementY),
          "--drawer-swipe-strength": `${swipeStrength}`,
          "--nested-drawers": `${nestedMetrics.count}`,
          "--drawer-height": nestedMetrics.height > 0 ? toPx(nestedMetrics.height) : void 0,
          "--drawer-frontmost-height": nestedMetrics.frontmostHeight > 0 ? toPx(nestedMetrics.frontmostHeight) : void 0,
          willChange: "transform"
        }),
        onPointerDown(event) {
          if (!props.draggable) return;
          onContentPointerDown(event);
        }
      });
    },
    getTitleProps() {
      return normalize.element({
        ...parts.title.attrs,
        id: getTitleId(scope),
        dir: prop("dir")
      });
    },
    getDescriptionProps() {
      return normalize.element({
        ...parts.description.attrs,
        id: getDescriptionId(scope),
        dir: prop("dir")
      });
    },
    triggerValue,
    setTriggerValue(value) {
      send({ type: "OPEN", value: value ?? void 0 });
    },
    getTriggerProps(props = {}) {
      const { value } = props;
      const current = value == null ? false : triggerValue === value;
      return normalize.button({
        ...parts.trigger.attrs,
        dir: prop("dir"),
        id: getTriggerId(scope, value),
        "data-ownedby": scope.id,
        "data-value": value,
        "aria-haspopup": "dialog",
        type: "button",
        "aria-expanded": value == null ? open : open && current,
        "data-state": open ? "open" : "closed",
        "aria-controls": getContentId(scope),
        "data-current": dataAttr(current),
        onClick(event) {
          if (event.defaultPrevented) return;
          const shouldSwitch = open && value != null && !current;
          send({ type: shouldSwitch ? "TRIGGER_VALUE.SET" : open ? "CLOSE" : "OPEN", value });
        }
      });
    },
    getBackdropProps() {
      return normalize.element({
        ...parts.backdrop.attrs,
        id: getBackdropId(scope),
        hidden: !open || swipingOpen && dragOffset === null,
        "data-state": open ? "open" : "closed",
        "data-swiping": dragging || swipingOpen ? "" : void 0,
        style: {
          willChange: "opacity",
          pointerEvents: closing ? "none" : void 0,
          "--drawer-swipe-progress": `${swipeProgress}`,
          "--drawer-swipe-strength": `${swipeStrength}`
        }
      });
    },
    getGrabberProps() {
      return normalize.element({
        ...parts.grabber.attrs,
        id: getGrabberId(scope),
        onPointerDown(event) {
          onGrabberPointerDown(event);
        },
        style: {
          touchAction: "none"
        }
      });
    },
    getGrabberIndicatorProps() {
      return normalize.element({
        ...parts.grabberIndicator.attrs,
        id: getGrabberIndicatorId(scope)
      });
    },
    getCloseTriggerProps() {
      return normalize.button({
        ...parts.closeTrigger.attrs,
        id: getCloseTriggerId(scope),
        type: "button",
        onClick() {
          send({ type: "CLOSE" });
        }
      });
    },
    getSwipeAreaProps(props = {}) {
      const disabled = props.disabled ?? false;
      const openDirection = props.swipeDirection ?? oppositeSwipeDirection[swipeDirection];
      const physicalOpenDirection = resolveSwipeDirection(openDirection, prop("dir"));
      return normalize.element({
        ...parts.swipeArea.attrs,
        id: getSwipeAreaId(scope),
        role: "presentation",
        "aria-hidden": true,
        "data-state": open ? "open" : "closed",
        "data-swiping": swipingOpen ? "" : void 0,
        "data-swipe-direction": physicalOpenDirection,
        "data-disabled": disabled ? "" : void 0,
        style: {
          touchAction: isVerticalSwipeDirection(physicalOpenDirection) ? "pan-x" : "pan-y",
          pointerEvents: disabled || open && !swipingOpen ? "none" : void 0
        },
        onPointerDown(event) {
          if (disabled) return;
          if (!isLeftClick(event)) return;
          if (event.pointerType === "touch") return;
          if (open && !swipingOpen) return;
          send({ type: "SWIPE_AREA.START", point: getEventPoint(event) });
          if (event.cancelable) event.preventDefault();
        },
        onTouchStart(event) {
          if (disabled) return;
          if (open && !swipingOpen) return;
          const touch = event.touches[0];
          if (!touch) return;
          send({ type: "SWIPE_AREA.START", point: { x: touch.clientX, y: touch.clientY } });
        }
      });
    }
  };
}

// ../node_modules/.pnpm/@zag-js+drawer@1.43.3/node_modules/@zag-js/drawer/dist/drawer.registry.mjs
var DrawerRegistry = class {
  constructor() {
    __publicField(this, "elements", /* @__PURE__ */ new Map());
    __publicField(this, "swipingIds", /* @__PURE__ */ new Set());
    __publicField(this, "swipeProgress", /* @__PURE__ */ new Map());
    __publicField(this, "listeners", /* @__PURE__ */ new Set());
  }
  notify() {
    this.listeners.forEach((fn) => fn());
  }
  register(id, el) {
    this.elements.set(id, el);
    this.notify();
  }
  unregister(id) {
    this.swipingIds.delete(id);
    this.swipeProgress.delete(id);
    if (!this.elements.delete(id)) return;
    this.notify();
  }
  setSwiping(id, swiping) {
    const changed = swiping ? !this.swipingIds.has(id) : this.swipingIds.has(id);
    if (!changed && swiping) return;
    if (swiping) {
      this.swipingIds.add(id);
    } else {
      this.swipingIds.delete(id);
      this.swipeProgress.delete(id);
    }
    this.notify();
  }
  setSwipeProgress(id, progress) {
    this.swipeProgress.set(id, progress);
    this.notify();
  }
  getSwipeProgressAfter(id) {
    const keys = [...this.elements.keys()];
    const myIndex = keys.indexOf(id);
    if (myIndex === -1) return 0;
    for (let i = keys.length - 1; i > myIndex; i -= 1) {
      if (this.swipingIds.has(keys[i])) {
        return this.swipeProgress.get(keys[i]) ?? 0;
      }
    }
    return 0;
  }
  hasSwipingAfter(id) {
    const keys = [...this.elements.keys()];
    const myIndex = keys.indexOf(id);
    if (myIndex === -1) return false;
    return keys.slice(myIndex + 1).some((key) => this.swipingIds.has(key));
  }
  getEntries() {
    return this.elements;
  }
  subscribe(fn) {
    this.listeners.add(fn);
    return () => {
      this.listeners.delete(fn);
    };
  }
};
var drawerRegistry = new DrawerRegistry();

// ../node_modules/.pnpm/@zag-js+drawer@1.43.3/node_modules/@zag-js/drawer/dist/drawer.machine.mjs
var { and } = createGuards();
var getActiveSnapOffset = (context) => context.get("resolvedActiveSnapPoint")?.offset ?? 0;
var hasRemSnapPoints = (snapPoints) => snapPoints.some((snapPoint) => typeof snapPoint === "string" && snapPoint.trim().endsWith("rem"));
var DEFAULT_SNAP_POINTS = [1];
var machine = createMachine({
  props({ props, scope }) {
    const alertDialog = props.role === "alertdialog";
    const initialFocusEl = alertDialog ? () => getCloseTriggerEl(scope) : void 0;
    const modal = typeof props.modal === "boolean" ? props.modal : true;
    const snapPoints = props.snapPoints ?? DEFAULT_SNAP_POINTS;
    return {
      modal,
      trapFocus: modal,
      preventScroll: modal,
      closeOnInteractOutside: true,
      closeOnEscape: true,
      restoreFocus: true,
      role: "dialog",
      initialFocusEl,
      snapPoints,
      defaultSnapPoint: props.defaultSnapPoint ?? snapPoints[0] ?? null,
      swipeDirection: "down",
      snapToSequentialPoints: false,
      swipeVelocityThreshold: 500,
      closeThreshold: 0.5,
      preventDragOnScroll: true,
      ...props
    };
  },
  context({ bindable, prop, scope }) {
    return {
      triggerValue: bindable(() => ({
        defaultValue: prop("defaultTriggerValue") ?? null,
        value: prop("triggerValue"),
        onChange(value) {
          const onTriggerValueChange = prop("onTriggerValueChange");
          if (!onTriggerValueChange) return;
          const triggerElement = getActiveTriggerEl(scope, value);
          onTriggerValueChange({ value, triggerElement });
        }
      })),
      dragOffset: bindable(() => ({
        defaultValue: null
      })),
      snapPoint: bindable(() => ({
        defaultValue: prop("defaultSnapPoint"),
        value: prop("snapPoint"),
        onChange(snapPoint) {
          return prop("onSnapPointChange")?.({ snapPoint });
        }
      })),
      resolvedActiveSnapPoint: bindable(() => ({
        defaultValue: null
      })),
      contentSize: bindable(() => ({
        defaultValue: null
      })),
      viewportSize: bindable(() => ({
        defaultValue: 0
      })),
      rootFontSize: bindable(() => ({
        defaultValue: 16
      })),
      swipeStrength: bindable(() => ({
        defaultValue: 1
      })),
      rendered: bindable(() => ({
        defaultValue: { title: true, description: true }
      })),
      nestedMetrics: bindable(() => ({
        defaultValue: { count: 0, height: 0, frontmostHeight: 0, open: false, swiping: false },
        isEqual
      }))
    };
  },
  refs({ prop }) {
    return {
      swipeSession: new DrawerSwipeSession({
        preventDragOnScroll: () => prop("preventDragOnScroll")
      }),
      snapBackFrame: AnimationFrame.create()
    };
  },
  computed: {
    drawerId({ prop, scope }) {
      return String(prop("id") ?? scope.id);
    },
    physicalSwipeDirection({ prop }) {
      return resolveSwipeDirection(prop("swipeDirection"), prop("dir"));
    },
    resolvedSnapPoints({ context, prop }) {
      const contentSize = context.get("contentSize");
      const viewportSize = context.get("viewportSize");
      const rootFontSize = context.get("rootFontSize");
      if (contentSize === null) return [];
      const points = prop("snapPoints").map((snapPoint) => resolveSnapPoint(snapPoint, { contentSize, viewportSize, rootFontSize })).filter((point) => point !== null);
      return dedupeSnapPoints(points);
    }
  },
  watch({ track, context, prop, action, computed }) {
    track(
      [
        () => context.get("snapPoint"),
        () => context.get("contentSize"),
        () => context.get("viewportSize"),
        () => context.get("rootFontSize"),
        () => prop("snapPoints").join("|")
      ],
      () => {
        const snapPoint = context.get("snapPoint");
        const contentSize = context.get("contentSize");
        const viewportSize = context.get("viewportSize");
        const rootFontSize = context.get("rootFontSize");
        if (snapPoint === null || contentSize === null) {
          context.set("resolvedActiveSnapPoint", null);
          return;
        }
        const resolvedPoints = computed("resolvedSnapPoints");
        const matchedPoint = resolvedPoints.find((point) => Object.is(point.value, snapPoint));
        if (matchedPoint) {
          context.set("resolvedActiveSnapPoint", matchedPoint);
          return;
        }
        const resolvedActiveSnapPoint = resolveSnapPoint(snapPoint, { contentSize, viewportSize, rootFontSize });
        if (resolvedActiveSnapPoint) {
          context.set("resolvedActiveSnapPoint", resolvedActiveSnapPoint);
          return;
        }
        const fallbackPoint = resolvedPoints[0];
        if (!fallbackPoint) {
          context.set("resolvedActiveSnapPoint", null);
          return;
        }
        context.set("snapPoint", fallbackPoint.value);
        context.set("resolvedActiveSnapPoint", fallbackPoint);
      }
    );
    track([() => prop("open")], () => {
      action(["toggleVisibility"]);
    });
    track(
      [() => context.get("dragOffset"), () => context.get("contentSize"), () => getActiveSnapOffset(context)],
      () => {
        action(["syncDrawerStack"]);
      }
    );
  },
  initialState({ prop }) {
    const open = prop("open") || prop("defaultOpen");
    return open ? "open" : "closed";
  },
  on: {
    "SNAP_POINT.SET": {
      actions: ["setSnapPoint"]
    }
  },
  states: {
    open: {
      tags: ["open"],
      entry: ["checkRenderedElements", "setInitialFocus", "deferClearDragOffset"],
      effects: [
        "trackDismissableElement",
        "preventScroll",
        "trapFocus",
        "hideContentBelow",
        "trackPointerMove",
        "trackSizeMeasurements",
        "trackNestedDrawerMetrics",
        "trackDrawerStack"
      ],
      on: {
        "TRIGGER_VALUE.SET": {
          actions: ["setTriggerValue"]
        },
        "CONTROLLED.CLOSE": {
          target: "closing",
          actions: ["clearSwipeOpenAnimation", "cancelSnapBack"]
        },
        POINTER_DOWN: {
          actions: ["setPointerStart", "cancelSnapBack"]
        },
        POINTER_MOVE: [
          {
            guard: "isDragging",
            actions: ["setDragOffset"]
          },
          {
            guard: "shouldStartDragging",
            actions: ["setRegistrySwiping", "setDragOffset"]
          }
        ],
        SNAP_BACK: {
          guard: "isDragging",
          actions: ["deferClearDragOffset", "resetSwipeStrength"]
        },
        POINTER_UP: [
          {
            guard: and("shouldCloseOnSwipe", "isOpenControlled"),
            actions: [
              "clearRegistrySwiping",
              "clearPointerStart",
              "setDismissSwipeStrength",
              "invokeOnClose",
              "scheduleSnapBack"
            ]
          },
          {
            guard: "shouldCloseOnSwipe",
            target: "closing",
            actions: ["clearSwipeOpenAnimation", "clearRegistrySwiping", "setDismissSwipeStrength"]
          },
          {
            guard: "isDragging",
            actions: [
              "clearRegistrySwiping",
              "suppressBackdropAnimation",
              "setSnapSwipeStrength",
              "setClosestSnapPoint",
              "clearPointerStart",
              "clearDragOffset",
              "clearVelocityTracking"
            ]
          },
          {
            actions: ["clearRegistrySwiping", "clearPointerStart", "clearDragOffset", "clearVelocityTracking"]
          }
        ],
        POINTER_CANCEL: [
          {
            guard: "isDragging",
            actions: ["clearRegistrySwiping", "clearPointerStart", "clearDragOffset", "clearVelocityTracking"]
          },
          {
            actions: ["clearRegistrySwiping", "clearPointerStart", "clearVelocityTracking"]
          }
        ],
        CLOSE: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnClose"]
          },
          {
            target: "closing",
            actions: ["clearSwipeOpenAnimation", "resetSwipeStrength", "invokeOnClose"]
          }
        ]
      }
    },
    closing: {
      entry: ["cancelSnapBack"],
      effects: ["trackExitAnimation"],
      on: {
        "CONTROLLED.OPEN": {
          target: "open"
        },
        OPEN: [
          {
            guard: "isOpenControlled",
            actions: ["setTriggerValue", "invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["setTriggerValue", "invokeOnOpen"]
          }
        ],
        "TRIGGER_VALUE.SET": {
          target: "open",
          actions: ["setTriggerValue", "invokeOnOpen"]
        },
        ANIMATION_END: {
          target: "closed",
          actions: [
            "invokeOnClose",
            "clearPointerStart",
            "clearDragOffset",
            "clearActiveSnapPoint",
            "clearResolvedActiveSnapPoint",
            "clearSizeMeasurements",
            "clearVelocityTracking"
          ]
        }
      }
    },
    "swipe-area-dragging": {
      tags: ["closed"],
      effects: ["trackSwipeOpenPointerMove"],
      on: {
        POINTER_MOVE: {
          guard: "hasSwipeIntent",
          target: "swiping-open"
        },
        POINTER_UP: {
          target: "closed",
          actions: ["clearPointerStart", "clearVelocityTracking"]
        },
        POINTER_CANCEL: {
          target: "closed",
          actions: ["clearPointerStart", "clearVelocityTracking"]
        }
      }
    },
    "swiping-open": {
      tags: ["open"],
      effects: ["trackSwipeOpenPointerMove", "trackSizeMeasurements"],
      on: {
        POINTER_MOVE: {
          actions: ["setSwipeOpenDragOffset"]
        },
        POINTER_UP: [
          {
            guard: and("shouldOpenOnSwipe", "isOpenControlled"),
            actions: ["clearPointerStart", "invokeOnOpen"]
          },
          {
            guard: "shouldOpenOnSwipe",
            target: "open",
            actions: ["clearPointerStart", "invokeOnOpen"]
          },
          {
            target: "closed",
            actions: ["clearPointerStart", "clearDragOffset", "clearSizeMeasurements"]
          }
        ],
        POINTER_CANCEL: {
          target: "closed",
          actions: ["clearPointerStart", "clearDragOffset", "clearSizeMeasurements", "clearVelocityTracking"]
        },
        "CONTROLLED.OPEN": {
          target: "open"
        },
        CLOSE: {
          target: "closed",
          actions: ["clearPointerStart", "clearDragOffset", "clearSizeMeasurements"]
        }
      }
    },
    closed: {
      tags: ["closed"],
      on: {
        "CONTROLLED.OPEN": {
          target: "open"
        },
        OPEN: [
          {
            guard: "isOpenControlled",
            actions: ["setTriggerValue", "invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["setTriggerValue", "invokeOnOpen"]
          }
        ],
        "SWIPE_AREA.START": {
          target: "swipe-area-dragging",
          actions: ["setPointerStart"]
        }
      }
    }
  },
  implementations: {
    guards: {
      isOpenControlled: ({ prop }) => prop("open") !== void 0,
      isDragging({ context }) {
        return context.get("dragOffset") !== null;
      },
      shouldStartDragging({ computed, prop, refs, event, scope }) {
        const swipeSession = refs.get("swipeSession");
        return swipeSession.canStartDrag(
          event.point,
          event.target,
          getContentEl(scope),
          prop("preventDragOnScroll"),
          computed("physicalSwipeDirection")
        );
      },
      shouldCloseOnSwipe({ prop, context, computed, refs }) {
        if (prop("snapToSequentialPoints")) return false;
        const swipeSession = refs.get("swipeSession");
        return swipeSession.shouldDismissOnRelease(
          context.get("contentSize"),
          computed("resolvedSnapPoints"),
          getActiveSnapOffset(context)
        );
      },
      hasSwipeIntent({ refs, computed, event }) {
        const swipeSession = refs.get("swipeSession");
        const start = swipeSession.getSwipeStart();
        if (!start || !event.point) return false;
        return hasOpeningSwipeIntent(start, event.point, computed("physicalSwipeDirection"));
      },
      shouldOpenOnSwipe({ context, refs, prop }) {
        const swipeSession = refs.get("swipeSession");
        return swipeSession.shouldOpenOnRelease(
          context.get("contentSize"),
          prop("swipeVelocityThreshold"),
          prop("closeThreshold")
        );
      }
    },
    actions: {
      setInitialFocus({ prop, scope }) {
        if (prop("trapFocus")) return;
        raf(() => {
          const element = getInitialFocus({
            root: getContentEl(scope),
            getInitialEl: prop("initialFocusEl")
          });
          element?.focus({ preventScroll: true });
        });
      },
      checkRenderedElements({ context, scope }) {
        raf(() => {
          context.set("rendered", {
            title: !!getTitleEl(scope),
            description: !!getDescriptionEl(scope)
          });
        });
      },
      deferClearDragOffset({ context, refs, scope }) {
        const dragOffset = context.get("dragOffset");
        if (dragOffset === null) return;
        const contentEl = getContentEl(scope);
        const backdropEl = getBackdropEl(scope);
        if (contentEl) contentEl.style.setProperty("animation", "none", "important");
        if (backdropEl) backdropEl.style.setProperty("animation", "none", "important");
        raf(() => {
          refs.get("swipeSession").resetDragOffset();
          context.set("dragOffset", null);
        });
      },
      suppressBackdropAnimation({ scope }) {
        const backdropEl = getBackdropEl(scope);
        if (!backdropEl) return;
        backdropEl.style.setProperty("animation", "none", "important");
      },
      clearSwipeOpenAnimation({ scope }) {
        const contentEl = getContentEl(scope);
        const backdropEl = getBackdropEl(scope);
        if (contentEl) contentEl.style.removeProperty("animation");
        if (backdropEl) backdropEl.style.removeProperty("animation");
      },
      setTriggerValue({ context, event }) {
        if (event.value === void 0) return;
        context.set("triggerValue", event.value);
      },
      invokeOnOpen({ prop }) {
        prop("onOpenChange")?.({ open: true });
      },
      invokeOnClose({ prop }) {
        prop("onOpenChange")?.({ open: false });
      },
      setSnapPoint({ context, event }) {
        context.set("snapPoint", event.snapPoint);
      },
      setPointerStart({ event, refs }) {
        refs.get("swipeSession").beginSwipe(event.point);
      },
      setDragOffset({ context, event, refs, computed }) {
        const swipeSession = refs.get("swipeSession");
        const physicalSwipeDirection = event.swipeDirection ?? computed("physicalSwipeDirection");
        swipeSession.setDragOffset(event.point, getActiveSnapOffset(context), physicalSwipeDirection);
        context.set("dragOffset", swipeSession.getDragOffset());
      },
      setSwipeOpenDragOffset({ context, event, refs, computed }) {
        const swipeSession = refs.get("swipeSession");
        const contentSize = context.get("contentSize");
        if (!contentSize) return;
        swipeSession.setSwipeOpenOffset(event.point, contentSize, computed("physicalSwipeDirection"));
        context.set("dragOffset", swipeSession.getDragOffset());
      },
      setClosestSnapPoint({ computed, context, refs, prop, send }) {
        const snapPoints = computed("resolvedSnapPoints");
        const contentSize = context.get("contentSize");
        const viewportSize = context.get("viewportSize");
        const rootFontSize = context.get("rootFontSize");
        if (!snapPoints.length || contentSize === null) return;
        const swipeSession = refs.get("swipeSession");
        const closestSnapPoint = swipeSession.resolveSnapPointOnRelease(
          snapPoints,
          context.get("resolvedActiveSnapPoint"),
          prop("snapToSequentialPoints"),
          contentSize
        );
        if (closestSnapPoint === null) {
          send({ type: "CLOSE" });
          return;
        }
        context.set("snapPoint", closestSnapPoint);
        const resolved = resolveSnapPoint(closestSnapPoint, { contentSize, viewportSize, rootFontSize });
        context.set("resolvedActiveSnapPoint", resolved);
      },
      clearDragOffset({ context, refs }) {
        refs.get("swipeSession").resetDragOffset();
        context.set("dragOffset", null);
      },
      clearActiveSnapPoint({ context }) {
        context.set("snapPoint", context.initial("snapPoint"));
      },
      clearSizeMeasurements({ context }) {
        context.set("contentSize", null);
        context.set("viewportSize", 0);
        context.set("rootFontSize", 16);
      },
      clearResolvedActiveSnapPoint({ context }) {
        context.set("resolvedActiveSnapPoint", null);
      },
      clearPointerStart({ refs }) {
        refs.get("swipeSession").clearSwipeStart();
      },
      clearVelocityTracking({ refs }) {
        refs.get("swipeSession").resetVelocity();
      },
      setSnapSwipeStrength({ context, refs, computed, prop }) {
        const swipeSession = refs.get("swipeSession");
        const snapPoints = computed("resolvedSnapPoints");
        const contentSize = context.get("contentSize");
        const closestSnapPoint = swipeSession.resolveSnapPointOnRelease(
          snapPoints,
          context.get("resolvedActiveSnapPoint"),
          prop("snapToSequentialPoints"),
          contentSize ?? 0
        );
        if (closestSnapPoint === null) return;
        const viewportSize = context.get("viewportSize");
        const rootFontSize = context.get("rootFontSize");
        const resolved = resolveSnapPoint(closestSnapPoint, {
          contentSize: contentSize ?? 0,
          viewportSize,
          rootFontSize
        });
        const restOffset = getActiveSnapOffset(context);
        context.set("swipeStrength", swipeSession.getSwipeStrength(resolved?.offset ?? 0, restOffset));
      },
      setDismissSwipeStrength({ context, refs }) {
        const swipeSession = refs.get("swipeSession");
        const contentSize = context.get("contentSize");
        const restOffset = getActiveSnapOffset(context);
        context.set("swipeStrength", swipeSession.getSwipeStrength(contentSize ?? 0, restOffset));
      },
      resetSwipeStrength({ context }) {
        context.set("swipeStrength", 1);
      },
      scheduleSnapBack({ refs, send, prop }) {
        if (prop("onOpenChange") != null) return;
        refs.get("snapBackFrame").request(() => {
          send({ type: "SNAP_BACK" });
        });
      },
      cancelSnapBack({ refs }) {
        refs.get("snapBackFrame").cancel();
      },
      setRegistrySwiping({ computed }) {
        drawerRegistry.setSwiping(computed("drawerId"), true);
      },
      clearRegistrySwiping({ computed }) {
        drawerRegistry.setSwiping(computed("drawerId"), false);
      },
      toggleVisibility({ event, send, prop }) {
        send({ type: prop("open") ? "CONTROLLED.OPEN" : "CONTROLLED.CLOSE", previousEvent: event });
      },
      syncDrawerStack({ context, prop, computed }) {
        const contentSize = context.get("contentSize");
        if (contentSize === null) return;
        const dragOffset = context.get("dragOffset");
        const snapPointOffset = getActiveSnapOffset(context);
        const progress = resolveSwipeProgress(contentSize, dragOffset, snapPointOffset);
        const id = computed("drawerId");
        if (dragOffset !== null) {
          drawerRegistry.setSwipeProgress(id, progress);
        }
        const stack = prop("stack");
        if (!stack) return;
        stack.setHeight(id, contentSize);
        stack.setSwipe(id, dragOffset !== null, progress);
      }
    },
    effects: {
      trackDrawerStack({ context, prop, computed }) {
        const stack = prop("stack");
        if (!stack) return;
        const id = computed("drawerId");
        stack.register(id);
        stack.setOpen(id, true);
        const sync = () => {
          const contentSize = context.get("contentSize");
          const dragOffset = context.get("dragOffset");
          const snapPointOffset = getActiveSnapOffset(context);
          stack.setHeight(id, contentSize ?? 0);
          stack.setSwipe(id, dragOffset !== null, resolveSwipeProgress(contentSize, dragOffset, snapPointOffset));
        };
        sync();
        return () => {
          stack.setSwipe(id, false, 0);
          stack.setOpen(id, false);
          stack.unregister(id);
        };
      },
      trackDismissableElement({ scope, prop, send }) {
        const getContentEl2 = () => getContentEl(scope);
        return trackDismissableElement(getContentEl2, {
          type: "drawer",
          defer: true,
          pointerBlocking: prop("modal"),
          layerStyleTargets: [() => getBackdropEl(scope), () => getPositionerEl(scope)],
          exclude: [getTriggerEl(scope), ...getTriggerEls(scope)].filter(Boolean),
          onInteractOutside(event) {
            prop("onInteractOutside")?.(event);
            if (!prop("closeOnInteractOutside")) {
              event.preventDefault();
            }
          },
          onFocusOutside: prop("onFocusOutside"),
          onEscapeKeyDown(event) {
            prop("onEscapeKeyDown")?.(event);
            if (!prop("closeOnEscape")) {
              event.preventDefault();
            }
          },
          onPointerDownOutside: prop("onPointerDownOutside"),
          onRequestDismiss: prop("onRequestDismiss"),
          onDismiss() {
            send({ type: "CLOSE", src: "interact-outside" });
          }
        });
      },
      preventScroll({ scope, prop }) {
        if (!prop("preventScroll")) return;
        return preventBodyScroll(scope.getDoc());
      },
      trapFocus({ scope, prop, context }) {
        if (!prop("trapFocus")) return;
        const contentEl = () => getContentEl(scope);
        return trapFocus(contentEl, {
          preventScroll: true,
          returnFocusOnDeactivate: !!prop("restoreFocus"),
          initialFocus: () => getInitialFocus({
            root: getContentEl(scope),
            getInitialEl: prop("initialFocusEl")
          }),
          setReturnFocus: (el) => {
            const finalFocusEl = prop("finalFocusEl")?.();
            if (finalFocusEl) return finalFocusEl;
            const triggerValue = context.get("triggerValue");
            if (triggerValue) {
              const activeTriggerEl = getActiveTriggerEl(scope, triggerValue);
              if (activeTriggerEl) return activeTriggerEl;
            }
            const fallbackTrigger = getTriggerEls(scope)[0];
            if (fallbackTrigger) return fallbackTrigger;
            return el;
          },
          getShadowRoot: true
        });
      },
      hideContentBelow({ scope, prop }) {
        if (!prop("modal")) return;
        const getElements = () => [getContentEl(scope)];
        return ariaHidden(getElements, { defer: true });
      },
      trackPointerMove({ scope, send, refs, computed }) {
        return refs.get("swipeSession").bindDragTracking({
          getDoc: () => scope.getDoc(),
          getContentEl: () => getContentEl(scope),
          getSwipeAreaEl: () => getSwipeAreaEl(scope),
          swipeDirection: computed("physicalSwipeDirection"),
          onMove(details) {
            send({ type: "POINTER_MOVE", ...details });
          },
          onEnd(details) {
            send({ type: "POINTER_UP", ...details });
          },
          onCancel() {
            send({ type: "POINTER_CANCEL" });
          }
        });
      },
      trackSizeMeasurements({ context, scope, computed, prop }) {
        const doc = scope.getDoc();
        const html = doc.documentElement;
        const shouldMeasureRootFontSize = hasRemSnapPoints(prop("snapPoints"));
        return waitForContentEl(scope, (contentEl) => {
          const updateSize = () => {
            const direction = computed("physicalSwipeDirection");
            const rect = contentEl.getBoundingClientRect();
            const viewportSize = isVerticalSwipeDirection(direction) ? html.clientHeight : html.clientWidth;
            context.set("contentSize", getSwipeDirectionSize(rect, direction));
            context.set("viewportSize", viewportSize);
            if (shouldMeasureRootFontSize) {
              const rootFontSize = Number.parseFloat(getComputedStyle(html).fontSize);
              if (Number.isFinite(rootFontSize)) {
                context.set("rootFontSize", rootFontSize);
              }
            }
          };
          updateSize();
          const cleanups = [
            resizeObserverBorderBox.observe(contentEl, updateSize),
            addDomEvent(scope.getWin(), "resize", updateSize)
          ];
          return () => cleanups.forEach((cleanup) => cleanup?.());
        });
      },
      trackNestedDrawerMetrics({ scope, computed, context }) {
        return waitForContentEl(scope, (contentEl) => {
          const id = computed("drawerId");
          drawerRegistry.register(id, contentEl);
          const sync = () => {
            const entries = [...drawerRegistry.getEntries().entries()];
            const myIndex = entries.findIndex(([entryId]) => entryId === id);
            if (myIndex === -1) return;
            const count = entries.length - 1 - myIndex;
            const frontmostEl = entries[entries.length - 1]?.[1];
            const frontmostHeight = frontmostEl?.getBoundingClientRect().height ?? 0;
            const height = contentEl.getBoundingClientRect().height;
            context.set("nestedMetrics", {
              count,
              height,
              frontmostHeight,
              open: count > 0 && frontmostHeight > 0,
              swiping: drawerRegistry.hasSwipingAfter(id)
            });
          };
          sync();
          const cleanups = [
            drawerRegistry.subscribe(sync),
            resizeObserverBorderBox.observe(contentEl, () => drawerRegistry.notify()),
            addDomEvent(scope.getWin(), "resize", () => drawerRegistry.notify())
          ];
          return () => {
            cleanups.forEach((cleanup) => cleanup?.());
            drawerRegistry.unregister(id);
          };
        });
      },
      trackSwipeOpenPointerMove({ scope, send, refs, computed }) {
        return refs.get("swipeSession").bindSwipeOpenTracking({
          getDoc: () => scope.getDoc(),
          getContentEl: () => getContentEl(scope),
          getSwipeAreaEl: () => getSwipeAreaEl(scope),
          swipeDirection: computed("physicalSwipeDirection"),
          onMove(details) {
            send({ type: "POINTER_MOVE", ...details });
          },
          onEnd(details) {
            send({ type: "POINTER_UP", ...details });
          },
          onCancel() {
            send({ type: "POINTER_CANCEL" });
          }
        });
      },
      trackExitAnimation({ send, scope }) {
        const contentEl = getContentEl(scope);
        if (!contentEl) return;
        return addDomEvent(contentEl, "exitcomplete", () => {
          send({ type: "ANIMATION_END" });
        });
      }
    }
  }
});
function waitForContentEl(scope, setup) {
  const contentEl = getContentEl(scope);
  let cleanup = contentEl ? setup(contentEl) : void 0;
  let abort;
  if (!cleanup) {
    const [promise, cancel] = waitForElement(() => getContentEl(scope), {
      timeout: 1e3,
      rootNode: scope.getDoc()
    });
    abort = cancel;
    promise.then((el) => cleanup = setup(el)).catch(noop);
  }
  return () => {
    abort?.();
    cleanup?.();
  };
}

// components/drawer.ts
var Drawer = class extends Component {
  initMachine(props) {
    return new VanillaMachine(machine, props);
  }
  initApi() {
    return this.zagConnect(connect);
  }
  syncDom() {
    this.api = this.initApi();
    this.render();
  }
  render() {
    const rootEl = this.el;
    rootEl.querySelectorAll('[data-scope="drawer"][data-part="trigger"]').forEach((triggerEl) => {
      const raw = triggerEl.dataset.value;
      const valueProps = raw != null && raw !== "" ? { value: raw } : {};
      this.spreadProps(triggerEl, this.api.getTriggerProps(valueProps));
    });
    const backdropEl = rootEl.querySelector(
      '[data-scope="drawer"][data-part="backdrop"]'
    );
    if (backdropEl) this.spreadProps(backdropEl, this.api.getBackdropProps());
    const positionerEl = rootEl.querySelector(
      '[data-scope="drawer"][data-part="positioner"]'
    );
    if (positionerEl) this.spreadProps(positionerEl, this.api.getPositionerProps());
    const contentEl = rootEl.querySelector(
      '[data-scope="drawer"][data-part="content"]'
    );
    if (contentEl) this.spreadProps(contentEl, this.api.getContentProps());
    const titleEl = rootEl.querySelector('[data-scope="drawer"][data-part="title"]');
    if (titleEl) this.spreadProps(titleEl, this.api.getTitleProps());
    const descriptionEl = rootEl.querySelector(
      '[data-scope="drawer"][data-part="description"]'
    );
    if (descriptionEl) this.spreadProps(descriptionEl, this.api.getDescriptionProps());
    const closeEl = rootEl.querySelector(
      '[data-scope="drawer"][data-part="close-trigger"]'
    );
    if (closeEl) this.spreadProps(closeEl, this.api.getCloseTriggerProps());
    const grabberEl = rootEl.querySelector(
      '[data-scope="drawer"][data-part="grabber"]'
    );
    if (grabberEl) this.spreadProps(grabberEl, this.api.getGrabberProps());
    const grabberIndicatorEl = rootEl.querySelector(
      '[data-scope="drawer"][data-part="grabber-indicator"]'
    );
    if (grabberIndicatorEl) this.spreadProps(grabberIndicatorEl, this.api.getGrabberIndicatorProps());
  }
};

// hooks/drawer.ts
function parseSnapPoints(raw) {
  if (!raw || raw.trim() === "") return void 0;
  return raw.split(",").map((part) => {
    const trimmed = part.trim();
    if (trimmed.endsWith("px") || trimmed.endsWith("%")) return trimmed;
    const n = Number(trimmed);
    return Number.isNaN(n) ? trimmed : n;
  });
}
function parseSnapPoint(raw) {
  if (!raw || raw.trim() === "") return void 0;
  const trimmed = raw.trim();
  if (trimmed.endsWith("px") || trimmed.endsWith("%")) return trimmed;
  const n = Number(trimmed);
  return Number.isNaN(n) ? trimmed : n;
}
function createDrawerCallbacks(el, pushEvent, liveSocket) {
  const onTriggerValueChange = (details) => {
    const eventName = getString(el, "onTriggerValueChange");
    if (eventName && canPushEvent(liveSocket)) {
      pushEvent(eventName, {
        id: el.id,
        value: details.value ?? ""
      });
    }
  };
  const onOpenChange = (details) => {
    const eventName = getString(el, "onOpenChange");
    if (eventName && canPushEvent(liveSocket)) {
      pushEvent(eventName, {
        id: el.id,
        open: details.open
      });
    }
    const eventNameClient = getString(el, "onOpenChangeClient");
    if (eventNameClient) {
      el.dispatchEvent(
        new CustomEvent(eventNameClient, {
          bubbles: true,
          detail: {
            id: el.id,
            open: details.open
          }
        })
      );
    }
  };
  const onSnapPointChange = (details) => {
    const eventName = getString(el, "onSnapPointChange");
    if (eventName && canPushEvent(liveSocket)) {
      pushEvent(eventName, {
        id: el.id,
        snap_point: details.snapPoint
      });
    }
    const eventNameClient = getString(el, "onSnapPointChangeClient");
    if (eventNameClient) {
      el.dispatchEvent(
        new CustomEvent(eventNameClient, {
          bubbles: true,
          detail: {
            id: el.id,
            snap_point: details.snapPoint
          }
        })
      );
    }
  };
  return { onOpenChange, onTriggerValueChange, onSnapPointChange };
}
function drawerProps(el, hook) {
  const swipeDirection = getString(el, "swipeDirection", ["up", "down", "start", "end"]);
  return {
    id: el.id,
    defaultOpen: getBoolean(el, "defaultOpen"),
    dir: getDir(el),
    modal: getBoolean(el, "modal"),
    trapFocus: getBoolean(el, "trapFocus"),
    preventScroll: getBoolean(el, "preventScroll"),
    closeOnInteractOutside: getBoolean(el, "closeOnInteractOutside"),
    closeOnEscape: getBoolean(el, "closeOnEscape"),
    preventDragOnScroll: getBoolean(el, "preventDragOnScroll"),
    swipeDirection,
    snapPoints: parseSnapPoints(getString(el, "snapPoints")),
    defaultSnapPoint: parseSnapPoint(getString(el, "defaultSnapPoint")),
    ...createDrawerCallbacks(el, hook.pushEvent.bind(hook), hook.liveSocket)
  };
}
var DrawerHook = createZagLiveHook({
  key: "drawer",
  mount(hook, { dom, server }) {
    const el = hook.el;
    const drawer = new Drawer(el, drawerProps(el, hook));
    dom.add("corex:drawer:set-open", (event) => {
      drawer.api.setOpen(event.detail.open);
    });
    server.add("drawer_set_open", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      drawer.api.setOpen(payload.open);
    });
    return drawer;
  },
  update(hook, drawer) {
    drawer.updateProps(drawerProps(hook.el, hook));
  }
});
export {
  DrawerHook as Drawer,
  parseSnapPoint,
  parseSnapPoints
};
