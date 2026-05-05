// lib/custom-animation.ts
var DEFAULT_DURATION = 0.3;
var DEFAULT_EASING = "ease-out";
var DEFAULT_OPACITY_START = 0;
var DEFAULT_OPACITY_END = 1;
var DEFAULT_SCALE_START = 0.96;
var DEFAULT_SCALE_END = 1;
function reducedMotion() {
  return typeof window !== "undefined" && typeof window.matchMedia === "function" && window.matchMedia("(prefers-reduced-motion: reduce)").matches;
}
function applyClosedHeight(el) {
  el.style.opacity = "0";
  el.style.height = "0px";
  el.style.overflow = "hidden";
}
function applyOpenHeight(el) {
  el.style.opacity = "";
  el.style.height = "";
  el.style.overflow = "";
}
function findAccordionContent(rootEl, value) {
  return rootEl.querySelector(
    `[data-scope="accordion"][data-part="item"][data-value="${CSS.escape(value)}"] [data-part="item-content"]`
  );
}
function findTreeBranch(rootEl, value) {
  return rootEl.querySelector(
    `[data-scope="tree-view"][data-part="branch-content"][data-value="${CSS.escape(value)}"]`
  );
}
function findDialogBackdrop(rootEl) {
  return rootEl.querySelector('[data-scope="dialog"][data-part="backdrop"]');
}
function findDialogContent(rootEl) {
  return rootEl.querySelector('[data-scope="dialog"][data-part="content"]');
}
function applyClosedScale(el, opts = {}) {
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
function applyOpenScale(el) {
  el.style.opacity = "";
  el.style.removeProperty("transform");
}
function animateHeightOpen(el, opts) {
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
    opts.animator(
      el,
      { height: ["0px", toHeight], opacity: [opacityStart, opacityEnd] },
      { duration, easing }
    ).finished.then(() => {
      applyOpenHeight(el);
    })
  ).then(() => void 0);
}
function animateHeightClose(el, opts) {
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
    opts.animator(
      el,
      { height: [fromHeight, "0px"], opacity: [opacityEnd, opacityStart] },
      { duration, easing }
    ).finished.then(() => {
      applyClosedHeight(el);
    })
  ).then(() => void 0);
}
function animateScaleOpen(el, opts) {
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
  const keyframes = {
    opacity: [opacityStart, opacityEnd]
  };
  if (!isBackdrop && (scaleStart !== scaleEnd || scaleStart !== 1 || scaleEnd !== 1)) {
    keyframes.transform = [`scale(${scaleStart})`, `scale(${scaleEnd})`];
  }
  return Promise.resolve(
    opts.animator(el, keyframes, { duration, easing }).finished.then(() => {
      applyOpenScale(el);
    })
  ).then(() => void 0);
}
function animateScaleClose(el, opts) {
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
  const keyframes = {
    opacity: [opacityEnd, opacityStart]
  };
  if (!isBackdrop && (scaleStart !== scaleEnd || scaleStart !== 1 || scaleEnd !== 1)) {
    keyframes.transform = [`scale(${scaleEnd})`, `scale(${scaleStart})`];
  }
  return Promise.resolve(
    opts.animator(el, keyframes, { duration, easing }).finished.then(() => {
      applyClosedScale(el, { scaleStart, opacityStart });
    })
  ).then(() => void 0);
}

// hooks/lazy-hook.ts
function createLazyHook(importFn, exportName) {
  return {
    async mounted() {
      const mod = await importFn();
      const real = mod[exportName];
      this._realHook = real;
      if (real?.mounted) return real.mounted.call(this);
    },
    updated() {
      this._realHook?.updated?.call(this);
    },
    destroyed() {
      this._realHook?.destroyed?.call(this);
    },
    disconnected() {
      this._realHook?.disconnected?.call(this);
    },
    reconnected() {
      this._realHook?.reconnected?.call(this);
    },
    beforeUpdate() {
      this._realHook?.beforeUpdate?.call(this);
    }
  };
}

// hooks/corex.ts
var Hooks = {
  Accordion: createLazyHook(() => import("corex/accordion"), "Accordion"),
  AngleSlider: createLazyHook(() => import("corex/angle-slider"), "AngleSlider"),
  Avatar: createLazyHook(() => import("corex/avatar"), "Avatar"),
  Carousel: createLazyHook(() => import("corex/carousel"), "Carousel"),
  Checkbox: createLazyHook(() => import("corex/checkbox"), "Checkbox"),
  Clipboard: createLazyHook(() => import("corex/clipboard"), "Clipboard"),
  Code: createLazyHook(() => import("corex/code"), "Code"),
  Collapsible: createLazyHook(() => import("corex/collapsible"), "Collapsible"),
  Combobox: createLazyHook(() => import("corex/combobox"), "Combobox"),
  ColorPicker: createLazyHook(() => import("corex/color-picker"), "ColorPicker"),
  DatePicker: createLazyHook(() => import("corex/date-picker"), "DatePicker"),
  Dialog: createLazyHook(() => import("corex/dialog"), "Dialog"),
  Editable: createLazyHook(() => import("corex/editable"), "Editable"),
  FileUpload: createLazyHook(() => import("corex/file-upload"), "FileUpload"),
  FloatingPanel: createLazyHook(() => import("corex/floating-panel"), "FloatingPanel"),
  Listbox: createLazyHook(() => import("corex/listbox"), "Listbox"),
  Marquee: createLazyHook(() => import("corex/marquee"), "Marquee"),
  Menu: createLazyHook(() => import("corex/menu"), "Menu"),
  NumberInput: createLazyHook(() => import("corex/number-input"), "NumberInput"),
  PasswordInput: createLazyHook(() => import("corex/password-input"), "PasswordInput"),
  PinInput: createLazyHook(() => import("corex/pin-input"), "PinInput"),
  RadioGroup: createLazyHook(() => import("corex/radio-group"), "RadioGroup"),
  Select: createLazyHook(() => import("corex/select"), "Select"),
  SignaturePad: createLazyHook(() => import("corex/signature-pad"), "SignaturePad"),
  Switch: createLazyHook(() => import("corex/switch"), "Switch"),
  Tabs: createLazyHook(() => import("corex/tabs"), "Tabs"),
  Timer: createLazyHook(() => import("corex/timer"), "Timer"),
  Toast: createLazyHook(() => import("corex/toast"), "Toast"),
  Tooltip: createLazyHook(() => import("corex/tooltip"), "Tooltip"),
  ToggleGroup: createLazyHook(() => import("corex/toggle-group"), "ToggleGroup"),
  TreeView: createLazyHook(() => import("corex/tree-view"), "TreeView")
};
var corex_default = Hooks;
export {
  Hooks,
  animateHeightClose,
  animateHeightOpen,
  animateScaleClose,
  animateScaleOpen,
  applyClosedHeight,
  applyClosedScale,
  applyOpenHeight,
  applyOpenScale,
  corex_default as default,
  findAccordionContent,
  findDialogBackdrop,
  findDialogContent,
  findTreeBranch
};
//# sourceMappingURL=corex.mjs.map
