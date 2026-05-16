import {
  getBooleanValue
} from "./chunk-XGGASIX4.mjs";

// lib/animation.ts
function readRequiredAttrString(el, dataAttr, label) {
  const raw = el.getAttribute(dataAttr);
  if (raw === null) {
    throw new Error(`[corex] missing ${label} on #${el.id}`);
  }
  return raw;
}
function readRequiredAttrNumber(el, dataAttr, label) {
  const raw = readRequiredAttrString(el, dataAttr, label);
  const n = parseFloat(raw);
  if (Number.isNaN(n)) {
    throw new Error(`[corex] invalid ${label} on #${el.id}`);
  }
  return n;
}
function readHeightAnimationOptions(el) {
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
    blockInteraction: getBooleanValue(el, "animHeightBlockInteraction") !== false
  };
}
function readScaleAnimationOptions(el) {
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
    blockInteraction: getBooleanValue(el, "animScaleBlockInteraction") !== false
  };
}
var rootPointerBlockCount = /* @__PURE__ */ new WeakMap();
function beginRootPointerBlock(root) {
  const c = (rootPointerBlockCount.get(root) ?? 0) + 1;
  rootPointerBlockCount.set(root, c);
  if (c === 1) {
    root.style.pointerEvents = "none";
  }
}
function endRootPointerBlock(root) {
  const c = (rootPointerBlockCount.get(root) ?? 0) - 1;
  if (c <= 0) {
    rootPointerBlockCount.delete(root);
    root.style.removeProperty("pointer-events");
  } else {
    rootPointerBlockCount.set(root, c);
  }
}
function applyScaleClosedStyles(el, opts, features) {
  const isBackdrop = el.dataset.part === "backdrop";
  const sc = features?.scale !== false && !isBackdrop && (opts.scaleStart !== opts.scaleEnd || opts.scaleStart !== 1 || opts.scaleEnd !== 1);
  el.style.opacity = String(opts.opacityStart);
  if (sc) {
    el.style.transform = `scale(${opts.scaleStart})`;
  } else {
    el.style.removeProperty("transform");
  }
}
function applyHeightClosedStyles(el, opts) {
  el.style.opacity = String(opts.opacityStart);
  el.style.height = "0px";
  el.style.overflow = "hidden";
  el.style.removeProperty("transform");
}
function stripHiddenFromProps(props) {
  const next = { ...props };
  delete next.hidden;
  return next;
}
function clearOpenStyles(el) {
  el.style.opacity = "";
  el.style.height = "";
  el.style.overflow = "";
  el.style.removeProperty("transform");
}
function prepareInitialHeightState(rootEl, selector, opts) {
  rootEl.querySelectorAll(selector).forEach((el) => {
    if (el.dataset.state === "open") {
      clearOpenStyles(el);
    } else {
      applyHeightClosedStyles(el, opts);
    }
  });
}
function prepareInitialScaleState(rootEl, selector, opts, closedStyleFor) {
  rootEl.querySelectorAll(selector).forEach((el) => {
    if (el.dataset.state === "open") {
      clearOpenStyles(el);
    } else {
      applyScaleClosedStyles(el, opts, closedStyleFor?.(el));
    }
  });
}
function runOpenStateTransitionsHeight(args) {
  const { rootEl, selector, opts, isOpen, wasOpen } = args;
  const blockRoot = opts.blockInteraction ? rootEl : void 0;
  rootEl.querySelectorAll(selector).forEach((el) => {
    const previouslyOpen = wasOpen ? wasOpen(el) : el.dataset.state === "open";
    const nowOpen = isOpen(el);
    if (previouslyOpen === nowOpen) return;
    runHeightPanelAnimation(el, nowOpen, opts, blockRoot);
  });
}
function runHeightPanelAnimation(targetEl, isOpening, opts, blockRoot) {
  targetEl.getAnimations().forEach((a) => a.cancel());
  const fromOp = isOpening ? opts.opacityStart : opts.opacityEnd;
  const toOp = isOpening ? opts.opacityEnd : opts.opacityStart;
  targetEl.style.overflow = "hidden";
  targetEl.style.height = "auto";
  const fullHeight = `${targetEl.scrollHeight}px`;
  targetEl.style.height = isOpening ? "0px" : fullHeight;
  const fromFrame = {
    opacity: fromOp,
    height: isOpening ? "0px" : fullHeight
  };
  const toFrame = {
    opacity: toOp,
    height: isOpening ? fullHeight : "0px"
  };
  if (blockRoot && opts.blockInteraction) {
    beginRootPointerBlock(blockRoot);
  }
  const anim = targetEl.animate([fromFrame, toFrame], {
    duration: opts.duration * 1e3,
    easing: opts.easing,
    fill: "forwards"
  });
  let finished = false;
  const finish = () => {
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
function runScaleAnimation(targetEl, isOpening, opts, blockRoot) {
  targetEl.getAnimations().forEach((a) => a.cancel());
  const isBackdrop = targetEl.dataset.part === "backdrop";
  const useScale = !isBackdrop && (opts.scaleStart !== opts.scaleEnd || opts.scaleStart !== 1 || opts.scaleEnd !== 1);
  const fromOp = isOpening ? opts.opacityStart : opts.opacityEnd;
  const toOp = isOpening ? opts.opacityEnd : opts.opacityStart;
  const fromS = isOpening ? opts.scaleStart : opts.scaleEnd;
  const toS = isOpening ? opts.scaleEnd : opts.scaleStart;
  const fromFrame = { opacity: fromOp };
  const toFrame = { opacity: toOp };
  if (useScale) {
    fromFrame.transform = `scale(${fromS})`;
    toFrame.transform = `scale(${toS})`;
  }
  if (blockRoot && opts.blockInteraction) {
    beginRootPointerBlock(blockRoot);
  }
  const anim = targetEl.animate([fromFrame, toFrame], {
    duration: opts.duration * 1e3,
    easing: opts.easing,
    fill: "forwards"
  });
  let finished = false;
  const finish = () => {
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

export {
  readHeightAnimationOptions,
  readScaleAnimationOptions,
  stripHiddenFromProps,
  prepareInitialHeightState,
  prepareInitialScaleState,
  runOpenStateTransitionsHeight,
  runScaleAnimation
};
