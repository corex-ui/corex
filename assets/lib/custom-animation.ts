export type Animator = (
  el: HTMLElement,
  keyframes: Record<string, (number | string)[]>,
  options: { duration: number; easing: string | number[] }
) => { finished: Promise<unknown> };

export type AnimateHeightOptions = {
  animator: Animator;
  duration?: number;
  easing?: string | number[];
  opacityStart?: number;
  opacityEnd?: number;
};

export type AnimateScaleOptions = {
  animator: Animator;
  duration?: number;
  easing?: string | number[];
  opacityStart?: number;
  opacityEnd?: number;
  scaleStart?: number;
  scaleEnd?: number;
};

const DEFAULT_DURATION = 0.3;
const DEFAULT_EASING: string = "ease-out";
const DEFAULT_OPACITY_START = 0;
const DEFAULT_OPACITY_END = 1;
const DEFAULT_SCALE_START = 0.96;
const DEFAULT_SCALE_END = 1;

function reducedMotion(): boolean {
  return (
    typeof window !== "undefined" &&
    typeof window.matchMedia === "function" &&
    window.matchMedia("(prefers-reduced-motion: reduce)").matches
  );
}

export function applyClosedHeight(el: HTMLElement): void {
  el.style.opacity = "0";
  el.style.height = "0px";
  el.style.overflow = "hidden";
}

export function applyOpenHeight(el: HTMLElement): void {
  el.style.opacity = "";
  el.style.height = "";
  el.style.overflow = "";
}

export function findAccordionContent(rootEl: HTMLElement, value: string): HTMLElement | null {
  return rootEl.querySelector<HTMLElement>(
    `[data-scope="accordion"][data-part="item"][data-value="${CSS.escape(value)}"] [data-part="item-content"]`
  );
}

export function findTreeBranch(rootEl: HTMLElement, value: string): HTMLElement | null {
  return rootEl.querySelector<HTMLElement>(
    `[data-scope="tree-view"][data-part="branch-content"][data-value="${CSS.escape(value)}"]`
  );
}

export function findDialogBackdrop(rootEl: HTMLElement): HTMLElement | null {
  return rootEl.querySelector<HTMLElement>('[data-scope="dialog"][data-part="backdrop"]');
}

export function findDialogContent(rootEl: HTMLElement): HTMLElement | null {
  return rootEl.querySelector<HTMLElement>('[data-scope="dialog"][data-part="content"]');
}

export function applyClosedScale(
  el: HTMLElement,
  opts: { scaleStart?: number; opacityStart?: number } = {}
): void {
  const isBackdrop = el.dataset.part === "backdrop";
  const opacityStart = opts.opacityStart ?? DEFAULT_OPACITY_START;
  const scaleStart = opts.scaleStart ?? DEFAULT_SCALE_START;
  el.style.opacity = String(opacityStart);
  if (!isBackdrop && scaleStart !== 1) {
    el.style.transform = `scale(${scaleStart})`;
  } else {
    el.style.removeProperty("transform");
  }
}

export function applyOpenScale(el: HTMLElement): void {
  el.style.opacity = "";
  el.style.removeProperty("transform");
}

export function animateHeightOpen(el: HTMLElement, opts: AnimateHeightOptions): Promise<void> {
  if (reducedMotion()) {
    applyOpenHeight(el);
    return Promise.resolve();
  }
  const duration = opts.duration ?? DEFAULT_DURATION;
  const easing = opts.easing ?? DEFAULT_EASING;
  const opacityStart = opts.opacityStart ?? DEFAULT_OPACITY_START;
  const opacityEnd = opts.opacityEnd ?? DEFAULT_OPACITY_END;

  const toHeight = `${el.scrollHeight}px`;
  el.style.height = "0px";
  el.style.overflow = "hidden";

  return Promise.resolve(
    opts
      .animator(
        el,
        { height: ["0px", toHeight], opacity: [opacityStart, opacityEnd] },
        { duration, easing }
      )
      .finished.then(() => {
        applyOpenHeight(el);
      })
  ).then(() => undefined);
}

export function animateHeightClose(el: HTMLElement, opts: AnimateHeightOptions): Promise<void> {
  if (reducedMotion()) {
    applyClosedHeight(el);
    return Promise.resolve();
  }
  const duration = opts.duration ?? DEFAULT_DURATION;
  const easing = opts.easing ?? DEFAULT_EASING;
  const opacityStart = opts.opacityStart ?? DEFAULT_OPACITY_START;
  const opacityEnd = opts.opacityEnd ?? DEFAULT_OPACITY_END;

  const fromHeight = `${el.scrollHeight}px`;
  el.style.height = fromHeight;
  el.style.overflow = "hidden";

  return Promise.resolve(
    opts
      .animator(
        el,
        { height: [fromHeight, "0px"], opacity: [opacityEnd, opacityStart] },
        { duration, easing }
      )
      .finished.then(() => {
        applyClosedHeight(el);
      })
  ).then(() => undefined);
}

export function animateScaleOpen(el: HTMLElement, opts: AnimateScaleOptions): Promise<void> {
  const isBackdrop = el.dataset.part === "backdrop";
  if (reducedMotion()) {
    applyOpenScale(el);
    return Promise.resolve();
  }
  const duration = opts.duration ?? DEFAULT_DURATION;
  const easing = opts.easing ?? DEFAULT_EASING;
  const opacityStart = opts.opacityStart ?? DEFAULT_OPACITY_START;
  const opacityEnd = opts.opacityEnd ?? DEFAULT_OPACITY_END;
  const scaleStart = opts.scaleStart ?? DEFAULT_SCALE_START;
  const scaleEnd = opts.scaleEnd ?? DEFAULT_SCALE_END;

  const keyframes: Record<string, (number | string)[]> = {
    opacity: [opacityStart, opacityEnd],
  };
  if (!isBackdrop && (scaleStart !== scaleEnd || scaleStart !== 1 || scaleEnd !== 1)) {
    keyframes.transform = [`scale(${scaleStart})`, `scale(${scaleEnd})`];
  }

  return Promise.resolve(
    opts.animator(el, keyframes, { duration, easing }).finished.then(() => {
      applyOpenScale(el);
    })
  ).then(() => undefined);
}

export function animateScaleClose(el: HTMLElement, opts: AnimateScaleOptions): Promise<void> {
  const isBackdrop = el.dataset.part === "backdrop";
  if (reducedMotion()) {
    applyClosedScale(el, { scaleStart: opts.scaleStart, opacityStart: opts.opacityStart });
    return Promise.resolve();
  }
  const duration = opts.duration ?? DEFAULT_DURATION;
  const easing = opts.easing ?? DEFAULT_EASING;
  const opacityStart = opts.opacityStart ?? DEFAULT_OPACITY_START;
  const opacityEnd = opts.opacityEnd ?? DEFAULT_OPACITY_END;
  const scaleStart = opts.scaleStart ?? DEFAULT_SCALE_START;
  const scaleEnd = opts.scaleEnd ?? DEFAULT_SCALE_END;

  const keyframes: Record<string, (number | string)[]> = {
    opacity: [opacityEnd, opacityStart],
  };
  if (!isBackdrop && (scaleStart !== scaleEnd || scaleStart !== 1 || scaleEnd !== 1)) {
    keyframes.transform = [`scale(${scaleEnd})`, `scale(${scaleStart})`];
  }

  return Promise.resolve(
    opts.animator(el, keyframes, { duration, easing }).finished.then(() => {
      applyClosedScale(el, { scaleStart, opacityStart });
    })
  ).then(() => undefined);
}
