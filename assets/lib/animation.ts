import { getBooleanValue } from "./util";

export type CorexHeightAnimationOptions = {
  duration: number;
  easing: string;
  opacityStart: number;
  opacityEnd: number;
  blockInteraction: boolean;
};

export type CorexScaleAnimationOptions = {
  duration: number;
  easing: string;
  opacityStart: number;
  opacityEnd: number;
  scaleStart: number;
  scaleEnd: number;
  blockInteraction: boolean;
};

function readRequiredAttrString(el: HTMLElement, dataAttr: string, label: string): string {
  const raw = el.getAttribute(dataAttr);
  if (raw === null) {
    throw new Error(`[corex] missing ${label} on #${el.id}`);
  }
  return raw;
}

function readRequiredAttrNumber(el: HTMLElement, dataAttr: string, label: string): number {
  const raw = readRequiredAttrString(el, dataAttr, label);
  const n = parseFloat(raw);
  if (Number.isNaN(n)) {
    throw new Error(`[corex] invalid ${label} on #${el.id}`);
  }
  return n;
}

export function readHeightAnimationOptions(el: HTMLElement): CorexHeightAnimationOptions {
  return {
    duration: readRequiredAttrNumber(el, "data-anim-height-duration", "data-anim-height-duration"),
    easing: readRequiredAttrString(el, "data-anim-height-easing", "data-anim-height-easing"),
    opacityStart: readRequiredAttrNumber(
      el,
      "data-anim-height-opacity-start",
      "data-anim-height-opacity-start"
    ),
    opacityEnd: readRequiredAttrNumber(
      el,
      "data-anim-height-opacity-end",
      "data-anim-height-opacity-end"
    ),
    blockInteraction: getBooleanValue(el, "animHeightBlockInteraction") !== false,
  };
}

export function readScaleAnimationOptions(el: HTMLElement): CorexScaleAnimationOptions {
  return {
    duration: readRequiredAttrNumber(el, "data-anim-scale-duration", "data-anim-scale-duration"),
    easing: readRequiredAttrString(el, "data-anim-scale-easing", "data-anim-scale-easing"),
    opacityStart: readRequiredAttrNumber(
      el,
      "data-anim-scale-opacity-start",
      "data-anim-scale-opacity-start"
    ),
    opacityEnd: readRequiredAttrNumber(
      el,
      "data-anim-scale-opacity-end",
      "data-anim-scale-opacity-end"
    ),
    scaleStart: readRequiredAttrNumber(
      el,
      "data-anim-transform-scale-start",
      "data-anim-transform-scale-start"
    ),
    scaleEnd: readRequiredAttrNumber(
      el,
      "data-anim-transform-scale-end",
      "data-anim-transform-scale-end"
    ),
    blockInteraction: getBooleanValue(el, "animScaleBlockInteraction") !== false,
  };
}

const rootPointerBlockCount = new WeakMap<HTMLElement, number>();

function beginRootPointerBlock(root: HTMLElement): void {
  const c = (rootPointerBlockCount.get(root) ?? 0) + 1;
  rootPointerBlockCount.set(root, c);
  if (c === 1) {
    root.style.pointerEvents = "none";
  }
}

function endRootPointerBlock(root: HTMLElement): void {
  const c = (rootPointerBlockCount.get(root) ?? 0) - 1;
  if (c <= 0) {
    rootPointerBlockCount.delete(root);
    root.style.removeProperty("pointer-events");
  } else {
    rootPointerBlockCount.set(root, c);
  }
}

export function pointerBlockDuringMs(
  root: HTMLElement,
  durationMs: number,
  enabled: boolean
): void {
  if (!enabled || durationMs <= 0) return;
  beginRootPointerBlock(root);
  window.setTimeout(() => {
    endRootPointerBlock(root);
  }, durationMs);
}

export type ScaleClosedStyleFeatures = Partial<{ scale: boolean }>;

function applyScaleClosedStyles(
  el: HTMLElement,
  opts: CorexScaleAnimationOptions,
  features?: ScaleClosedStyleFeatures
): void {
  const isBackdrop = el.dataset.part === "backdrop";
  const sc =
    features?.scale !== false &&
    !isBackdrop &&
    (opts.scaleStart !== opts.scaleEnd || opts.scaleStart !== 1 || opts.scaleEnd !== 1);
  el.style.opacity = String(opts.opacityStart);
  if (sc) {
    el.style.transform = `scale(${opts.scaleStart})`;
  } else {
    el.style.removeProperty("transform");
  }
}

function applyHeightClosedStyles(el: HTMLElement, opts: CorexHeightAnimationOptions): void {
  el.style.opacity = String(opts.opacityStart);
  el.style.height = "0px";
  el.style.overflow = "hidden";
  el.style.removeProperty("transform");
}

export function stripHiddenFromProps(props: Record<string, unknown>): Record<string, unknown> {
  const next = { ...props };
  delete next.hidden;
  return next;
}

export function clearOpenStyles(el: HTMLElement): void {
  el.style.opacity = "";
  el.style.height = "";
  el.style.overflow = "";
  el.style.removeProperty("transform");
}

export function prepareInitialHeightState(
  rootEl: HTMLElement,
  selector: string,
  opts: CorexHeightAnimationOptions
): void {
  rootEl.querySelectorAll<HTMLElement>(selector).forEach((el) => {
    if (el.dataset.state === "open") {
      clearOpenStyles(el);
    } else {
      applyHeightClosedStyles(el, opts);
    }
  });
}

export function prepareInitialScaleState(
  rootEl: HTMLElement,
  selector: string,
  opts: CorexScaleAnimationOptions,
  closedStyleFor?: (el: HTMLElement) => ScaleClosedStyleFeatures | undefined
): void {
  rootEl.querySelectorAll<HTMLElement>(selector).forEach((el) => {
    if (el.dataset.state === "open") {
      clearOpenStyles(el);
    } else {
      applyScaleClosedStyles(el, opts, closedStyleFor?.(el));
    }
  });
}

export function runOpenStateTransitionsHeight(args: {
  rootEl: HTMLElement;
  selector: string;
  opts: CorexHeightAnimationOptions;
  isOpen: (el: HTMLElement) => boolean;
  wasOpen?: (el: HTMLElement) => boolean;
}): void {
  const { rootEl, selector, opts, isOpen, wasOpen } = args;
  const blockRoot = opts.blockInteraction ? rootEl : undefined;
  rootEl.querySelectorAll<HTMLElement>(selector).forEach((el) => {
    const previouslyOpen = wasOpen ? wasOpen(el) : el.dataset.state === "open";
    const nowOpen = isOpen(el);
    if (previouslyOpen === nowOpen) return;
    runHeightPanelAnimation(el, nowOpen, opts, blockRoot);
  });
}

export function isJsAnimation(el: HTMLElement): boolean {
  return el.dataset.animation === "js";
}

export function isInOpenValueList(value: string | undefined, openValues: string[]): boolean {
  return !!value && openValues.includes(value);
}

export type HeightContentValueResolver = (contentEl: HTMLElement) => string | undefined;

export function contentDatasetValue(contentEl: HTMLElement): string | undefined {
  return contentEl.dataset.value;
}

export function closestPartValue(itemSelector: string): HeightContentValueResolver {
  return (contentEl) => contentEl.closest<HTMLElement>(itemSelector)?.dataset.value;
}

export function runHeightOpenTransition(args: {
  el: HTMLElement;
  selector: string;
  prevOpen: string[];
  nextOpen: string[];
  resolveValue: HeightContentValueResolver;
}): void {
  const { el, selector, prevOpen, nextOpen, resolveValue } = args;
  if (!isJsAnimation(el)) return;

  runOpenStateTransitionsHeight({
    rootEl: el,
    selector,
    opts: readHeightAnimationOptions(el),
    wasOpen: (node) => isInOpenValueList(resolveValue(node), prevOpen),
    isOpen: (node) => isInOpenValueList(resolveValue(node), nextOpen),
  });
}

export function runHeightOpenToValues(args: {
  el: HTMLElement;
  selector: string;
  openValues: string[];
  resolveValue: HeightContentValueResolver;
}): void {
  const { el, selector, openValues, resolveValue } = args;
  if (!isJsAnimation(el)) return;

  runOpenStateTransitionsHeight({
    rootEl: el,
    selector,
    opts: readHeightAnimationOptions(el),
    isOpen: (node) => isInOpenValueList(resolveValue(node), openValues),
  });
}

export function prepareJsHeightInitialState(el: HTMLElement, selector: string): void {
  if (!isJsAnimation(el)) return;
  prepareInitialHeightState(el, selector, readHeightAnimationOptions(el));
}

export function prepareJsScaleInitialState(
  el: HTMLElement,
  selector: string,
  closedStyleFor?: (el: HTMLElement) => ScaleClosedStyleFeatures | undefined
): void {
  if (!isJsAnimation(el)) return;
  prepareInitialScaleState(el, selector, readScaleAnimationOptions(el), closedStyleFor);
}

export function runHeightPanelAnimation(
  targetEl: HTMLElement,
  isOpening: boolean,
  opts: CorexHeightAnimationOptions,
  blockRoot?: HTMLElement
): Animation {
  targetEl.getAnimations().forEach((a) => a.cancel());

  const fromOp = isOpening ? opts.opacityStart : opts.opacityEnd;
  const toOp = isOpening ? opts.opacityEnd : opts.opacityStart;

  targetEl.style.overflow = "hidden";
  targetEl.style.height = "auto";
  const fullHeight = `${targetEl.scrollHeight}px`;
  targetEl.style.height = isOpening ? "0px" : fullHeight;

  const fromFrame = {
    opacity: fromOp,
    height: isOpening ? "0px" : fullHeight,
  };
  const toFrame = {
    opacity: toOp,
    height: isOpening ? fullHeight : "0px",
  };

  if (blockRoot && opts.blockInteraction) {
    beginRootPointerBlock(blockRoot);
  }

  const anim = targetEl.animate([fromFrame, toFrame], {
    duration: opts.duration * 1000,
    easing: opts.easing,
    fill: "forwards",
  });
  let finished = false;
  const finish = (): void => {
    if (finished) return;
    finished = true;
    anim.cancel();
    if (blockRoot && opts.blockInteraction) {
      endRootPointerBlock(blockRoot);
    }
    if (isOpening) {
      targetEl.style.height = "auto";
      targetEl.style.opacity = "";
      targetEl.style.overflow = "";
    } else {
      targetEl.style.height = "0px";
      targetEl.style.opacity = String(opts.opacityStart);
      targetEl.style.overflow = "hidden";
    }
  };
  anim.onfinish = () => {
    finish();
  };
  anim.oncancel = () => {
    finish();
  };
  return anim;
}

export function runScaleAnimation(
  targetEl: HTMLElement,
  isOpening: boolean,
  opts: CorexScaleAnimationOptions,
  blockRoot?: HTMLElement
): Animation {
  targetEl.getAnimations().forEach((a) => a.cancel());

  const isBackdrop = targetEl.dataset.part === "backdrop";
  const useScale =
    !isBackdrop &&
    (opts.scaleStart !== opts.scaleEnd || opts.scaleStart !== 1 || opts.scaleEnd !== 1);

  const fromOp = isOpening ? opts.opacityStart : opts.opacityEnd;
  const toOp = isOpening ? opts.opacityEnd : opts.opacityStart;
  const fromS = isOpening ? opts.scaleStart : opts.scaleEnd;
  const toS = isOpening ? opts.scaleEnd : opts.scaleStart;

  const fromFrame: Record<string, string | number> = { opacity: fromOp };
  const toFrame: Record<string, string | number> = { opacity: toOp };
  if (useScale) {
    fromFrame.transform = `scale(${fromS})`;
    toFrame.transform = `scale(${toS})`;
  }

  if (blockRoot && opts.blockInteraction) {
    beginRootPointerBlock(blockRoot);
  }

  const anim = targetEl.animate([fromFrame, toFrame], {
    duration: opts.duration * 1000,
    easing: opts.easing,
    fill: "forwards",
  });
  let finished = false;
  const finish = (): void => {
    if (finished) return;
    finished = true;
    anim.cancel();
    if (blockRoot && opts.blockInteraction) {
      endRootPointerBlock(blockRoot);
    }
    if (isOpening) {
      targetEl.style.opacity = "";
      targetEl.style.removeProperty("transform");
    } else {
      targetEl.style.opacity = String(opts.opacityStart);
      if (isBackdrop) {
        targetEl.style.removeProperty("transform");
      } else if (useScale) {
        targetEl.style.transform = `scale(${opts.scaleStart})`;
      } else {
        targetEl.style.removeProperty("transform");
      }
    }
  };
  anim.onfinish = () => {
    finish();
  };
  anim.oncancel = () => {
    finish();
  };
  return anim;
}

export function animateHeightOpacityPanel(
  contentEl: HTMLElement,
  isOpening: boolean,
  opts: CorexHeightAnimationOptions,
  blockRoot?: HTMLElement
): Animation {
  return runHeightPanelAnimation(contentEl, isOpening, opts, blockRoot);
}
