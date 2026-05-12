import {
  getBooleanValue,
  getNumber,
  getString
} from "./chunk-EE44DOTL.mjs";

// lib/positioning.ts
function readFlipAttr(el) {
  const raw = el.dataset.positionFlip;
  if (raw == null) return void 0;
  if (raw === "true") return true;
  if (raw === "false") return false;
  const list = raw.split(",").map((v) => v.trim()).filter(Boolean);
  return list.length > 0 ? list : void 0;
}
function readPositioningOptions(el) {
  const options = {};
  const strategy = getString(el, "positionStrategy");
  if (strategy) options.strategy = strategy;
  const placement = getString(el, "positionPlacement");
  if (placement) options.placement = placement;
  const gutter = getNumber(el, "positionGutter");
  if (gutter !== void 0) options.gutter = gutter;
  const shift = getNumber(el, "positionShift");
  if (shift !== void 0) options.shift = shift;
  const overflowPadding = getNumber(el, "positionOverflowPadding");
  if (overflowPadding !== void 0) options.overflowPadding = overflowPadding;
  const arrowPadding = getNumber(el, "positionArrowPadding");
  if (arrowPadding !== void 0) options.arrowPadding = arrowPadding;
  const offsetMainAxis = getNumber(el, "positionOffsetMainAxis");
  const offsetCrossAxis = getNumber(el, "positionOffsetCrossAxis");
  if (offsetMainAxis !== void 0 || offsetCrossAxis !== void 0) {
    options.offset = {};
    if (offsetMainAxis !== void 0) options.offset.mainAxis = offsetMainAxis;
    if (offsetCrossAxis !== void 0) options.offset.crossAxis = offsetCrossAxis;
  }
  const flip = readFlipAttr(el);
  if (flip !== void 0) options.flip = flip;
  const slide = getBooleanValue(el, "positionSlide");
  if (slide !== void 0) options.slide = slide;
  const overlap = getBooleanValue(el, "positionOverlap");
  if (overlap !== void 0) options.overlap = overlap;
  const sameWidth = getBooleanValue(el, "positionSameWidth");
  if (sameWidth !== void 0) options.sameWidth = sameWidth;
  const fitViewport = getBooleanValue(el, "positionFitViewport");
  if (fitViewport !== void 0) options.fitViewport = fitViewport;
  const hideWhenDetached = getBooleanValue(el, "positionHideWhenDetached");
  if (hideWhenDetached !== void 0) options.hideWhenDetached = hideWhenDetached;
  return Object.keys(options).length > 0 ? options : void 0;
}

export {
  readPositioningOptions
};
