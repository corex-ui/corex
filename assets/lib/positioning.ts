import type { PositioningOptions } from "@zag-js/popper";
import { getString, getNumber, getBooleanValue } from "./util";

export function readFlipAttr(el: HTMLElement): PositioningOptions["flip"] | undefined {
  const raw = el.dataset.positionFlip;
  if (raw == null) return undefined;
  if (raw === "true") return true;
  if (raw === "false") return false;
  const list = raw
    .split(",")
    .map((v) => v.trim())
    .filter(Boolean);
  return list.length > 0 ? (list as PositioningOptions["flip"]) : undefined;
}

export function readPositioningOptions(el: HTMLElement): PositioningOptions | undefined {
  const options: Record<string, unknown> = {};
  const strategy = getString(el, "positionStrategy");
  if (strategy) options.strategy = strategy;
  const placement = getString(el, "positionPlacement");
  if (placement) options.placement = placement;
  const gutter = getNumber(el, "positionGutter");
  if (gutter !== undefined) options.gutter = gutter;
  const shift = getNumber(el, "positionShift");
  if (shift !== undefined) options.shift = shift;
  const overflowPadding = getNumber(el, "positionOverflowPadding");
  if (overflowPadding !== undefined) options.overflowPadding = overflowPadding;
  const arrowPadding = getNumber(el, "positionArrowPadding");
  if (arrowPadding !== undefined) options.arrowPadding = arrowPadding;
  const flip = readFlipAttr(el);
  if (flip !== undefined) options.flip = flip;
  const slide = getBooleanValue(el, "positionSlide");
  if (slide !== undefined) options.slide = slide;
  const overlap = getBooleanValue(el, "positionOverlap");
  if (overlap !== undefined) options.overlap = overlap;
  const sameWidth = getBooleanValue(el, "positionSameWidth");
  if (sameWidth !== undefined) options.sameWidth = sameWidth;
  const fitViewport = getBooleanValue(el, "positionFitViewport");
  if (fitViewport !== undefined) options.fitViewport = fitViewport;
  const hideWhenDetached = getBooleanValue(el, "positionHideWhenDetached");
  if (hideWhenDetached !== undefined) options.hideWhenDetached = hideWhenDetached;
  return Object.keys(options).length > 0 ? (options as PositioningOptions) : undefined;
}
