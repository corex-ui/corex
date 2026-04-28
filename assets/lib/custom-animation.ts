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

const DEFAULT_DURATION = 0.3;
const DEFAULT_EASING: string = "ease-out";
const DEFAULT_OPACITY_START = 0;
const DEFAULT_OPACITY_END = 1;

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

export function initCustomCollections(): void {
  document
    .querySelectorAll<HTMLElement>('[data-animation="custom"][phx-hook="Accordion"]')
    .forEach((host) => {
      host
        .querySelectorAll<HTMLElement>('[data-scope="accordion"][data-part="item-content"]')
        .forEach((el) => {
          if (el.dataset.state !== "open") applyClosedHeight(el);
        });
    });
  document
    .querySelectorAll<HTMLElement>('[data-animation="custom"][phx-hook="TreeView"]')
    .forEach((host) => {
      host
        .querySelectorAll<HTMLElement>('[data-scope="tree-view"][data-part="branch-content"]')
        .forEach((el) => {
          if (el.dataset.state !== "open") applyClosedHeight(el);
        });
    });
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
