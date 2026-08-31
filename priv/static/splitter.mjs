import {
  setRafTimeout
} from "./chunks/chunk-W2RDEPR5.mjs";
import {
  createAnatomy
} from "./chunks/chunk-YMOPD357.mjs";
import {
  Component,
  VanillaMachine,
  canPushEvent,
  createMachine,
  createZagLiveHook,
  dataAttr,
  ensure,
  ensureProps,
  getByOwnerId,
  getDir,
  getEventKey,
  getEventPoint,
  getString,
  isEqual,
  isHTMLElement,
  isLeftClick,
  next,
  observeChildren,
  prev,
  queryAll,
  resizeObserverBorderBox,
  trackPointerMove
} from "./chunks/chunk-R62PCG6O.mjs";

// ../node_modules/.pnpm/@zag-js+splitter@1.43.3/node_modules/@zag-js/splitter/dist/splitter.anatomy.mjs
var anatomy = createAnatomy("splitter").parts("root", "panel", "resizeTrigger", "resizeTriggerIndicator");
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+splitter@1.43.3/node_modules/@zag-js/splitter/dist/splitter.dom.mjs
var getRootId = (ctx) => ctx.ids?.root ?? `splitter:${ctx.id}`;
var getResizeTriggerId = (ctx, id) => ctx.ids?.resizeTrigger?.(id) ?? `splitter:${ctx.id}:splitter:${id}`;
var getPanelId = (ctx, id) => ctx.ids?.panel?.(id) ?? `splitter:${ctx.id}:panel:${id}`;
var getGlobalCursorId = (ctx) => `splitter:${ctx.id}:global-cursor`;
var getRootEl = (ctx) => ctx.getById(getRootId(ctx));
var getResizeTriggerEl = (ctx, id) => id != null ? ctx.getById(getResizeTriggerId(ctx, id)) : null;
var getPanelIdFromEl = (el) => {
  return isHTMLElement(el) && el.dataset.part === "panel" ? el.dataset.id : void 0;
};
var getPrevPanelId = (el) => {
  let prev2 = el?.previousElementSibling ?? null;
  while (prev2) {
    const id = getPanelIdFromEl(prev2);
    if (id) return id;
    prev2 = prev2.previousElementSibling;
  }
};
var getNextPanelId = (el) => {
  let next2 = el?.nextElementSibling ?? null;
  while (next2) {
    const id = getPanelIdFromEl(next2);
    if (id) return id;
    next2 = next2.nextElementSibling;
  }
};
var resolveResizeTriggerId = (ctx, id) => {
  const [beforeId, afterId] = id.split(":");
  if (beforeId && afterId) return id;
  const triggerEl = getResizeTriggerEl(ctx, id);
  const resolvedBeforeId = beforeId || getPrevPanelId(triggerEl);
  const resolvedAfterId = afterId || getNextPanelId(triggerEl);
  return resolvedBeforeId && resolvedAfterId ? `${resolvedBeforeId}:${resolvedAfterId}` : null;
};
var getCursor = (state, x) => {
  let cursor = x ? "col-resize" : "row-resize";
  if (state.isAtMin) cursor = x ? "e-resize" : "s-resize";
  if (state.isAtMax) cursor = x ? "w-resize" : "n-resize";
  return cursor;
};
var getResizeTriggerEls = (ctx) => {
  return queryAll(getRootEl(ctx), `[role=separator]${getByOwnerId(getRootId(ctx))}`);
};
var getGlobalCursorEl = (ctx) => {
  return ctx.getDoc().getElementById(getGlobalCursorId(ctx));
};
var setupGlobalCursor = (ctx, state, x, nonce) => {
  const styleEl = getGlobalCursorEl(ctx);
  const textContent = `* { cursor: ${getCursor(state, x)} !important; }`;
  if (styleEl) {
    styleEl.textContent = textContent;
  } else {
    const style = ctx.getDoc().createElement("style");
    if (nonce) style.nonce = nonce;
    style.id = getGlobalCursorId(ctx);
    style.textContent = textContent;
    ctx.getDoc().head.appendChild(style);
  }
};
var removeGlobalCursor = (ctx) => {
  const styleEl = getGlobalCursorEl(ctx);
  styleEl?.remove();
};

// ../node_modules/.pnpm/@zag-js+splitter@1.43.3/node_modules/@zag-js/splitter/dist/utils/aria.mjs
function calculateAriaValues({
  size,
  panels,
  pivotIndices
}) {
  let currentMinSize = 0;
  let currentMaxSize = 100;
  let totalMinSize = 0;
  let totalMaxSize = 0;
  const firstIndex = pivotIndices[0];
  ensure(firstIndex, () => "No pivot index found");
  panels.forEach((panel, index) => {
    const { maxSize = 100, minSize = 0 } = panel;
    if (index === firstIndex) {
      currentMinSize = minSize;
      currentMaxSize = maxSize;
    } else {
      totalMinSize += minSize;
      totalMaxSize += maxSize;
    }
  });
  const valueMax = Math.min(currentMaxSize, 100 - totalMinSize);
  const valueMin = Math.max(currentMinSize, 100 - totalMaxSize);
  const valueNow = size[firstIndex];
  return {
    valueMax,
    valueMin,
    valueNow
  };
}
function getAriaValue(size, panels, handleId) {
  const [beforeId, afterId] = handleId.split(":");
  const beforeIndex = panels.findIndex((panel) => panel.id === beforeId);
  const afterIndex = panels.findIndex((panel) => panel.id === afterId);
  if (beforeIndex === -1 || afterIndex === -1) {
    return {
      beforeId: beforeId || void 0,
      afterId: afterId || void 0,
      valueMax: void 0,
      valueMin: void 0,
      valueNow: void 0
    };
  }
  const { valueMax, valueMin, valueNow } = calculateAriaValues({
    size,
    panels,
    pivotIndices: [beforeIndex, afterIndex]
  });
  return {
    beforeId,
    afterId,
    valueMax: Math.round(valueMax),
    valueMin: Math.round(valueMin),
    valueNow: valueNow != null ? Math.round(valueNow) : void 0
  };
}

// ../node_modules/.pnpm/@zag-js+splitter@1.43.3/node_modules/@zag-js/splitter/dist/utils/fuzzy.mjs
var PRECISION = 10;
function fuzzyCompareNumbers(actual, expected, fractionDigits = PRECISION) {
  if (actual.toFixed(fractionDigits) === expected.toFixed(fractionDigits)) {
    return 0;
  } else {
    return actual > expected ? 1 : -1;
  }
}
function fuzzyNumbersEqual(actual, expected, fractionDigits = PRECISION) {
  if (actual == null || expected == null) return false;
  return fuzzyCompareNumbers(actual, expected, fractionDigits) === 0;
}
function fuzzySizeEqual(actual, expected, fractionDigits) {
  if (actual.length !== expected.length) {
    return false;
  }
  for (let index = 0; index < actual.length; index++) {
    const actualSize = actual[index];
    const expectedSize = expected[index];
    if (!fuzzyNumbersEqual(actualSize, expectedSize, fractionDigits)) {
      return false;
    }
  }
  return true;
}

// ../node_modules/.pnpm/@zag-js+splitter@1.43.3/node_modules/@zag-js/splitter/dist/utils/size.mjs
var sizeRegex = /^(-?\d*\.?\d+)(%|px|em|rem|vw|vh)?$/;
var percentRegex = /^(-?\d*\.?\d+)%$/;
function getRootSize(rootEl, orientation) {
  if (!rootEl) return 0;
  const rect = rootEl.getBoundingClientRect();
  return orientation === "horizontal" ? rect.width : rect.height;
}
function getGroupSize(rootEl, orientation) {
  return getRootSize(rootEl, orientation);
}
function toPixelValue(value, unit, rootEl) {
  const win = rootEl.ownerDocument.defaultView;
  if (!win) return void 0;
  switch (unit) {
    case "px":
      return value;
    case "em": {
      const fontSize = Number.parseFloat(win.getComputedStyle(rootEl).fontSize);
      return value * fontSize;
    }
    case "rem": {
      const fontSize = Number.parseFloat(win.getComputedStyle(rootEl.ownerDocument.documentElement).fontSize);
      return value * fontSize;
    }
    case "vw":
      return value / 100 * win.innerWidth;
    case "vh":
      return value / 100 * win.innerHeight;
    default:
      return void 0;
  }
}
function parsePanelSize(size, rootEl, orientation) {
  if (size == null) return void 0;
  if (typeof size === "number") {
    return size;
  }
  const match = size.trim().match(sizeRegex);
  if (!match) return void 0;
  const value = Number.parseFloat(match[1]);
  if (!Number.isFinite(value)) return void 0;
  const unit = match[2];
  if (unit == null || unit === "%") {
    return value;
  }
  if (!rootEl) return void 0;
  const rootSize = getRootSize(rootEl, orientation);
  if (rootSize === 0) return void 0;
  const px = toPixelValue(value, unit, rootEl);
  return px == null ? void 0 : px / rootSize * 100;
}
function toCssPanelSize(size) {
  if (size == null) return void 0;
  if (typeof size === "number") {
    return `${size}%`;
  }
  const trimmed = size.trim();
  if (percentRegex.test(trimmed)) {
    return trimmed;
  }
  const match = trimmed.match(sizeRegex);
  if (!match) return void 0;
  const value = Number.parseFloat(match[1]);
  if (!Number.isFinite(value)) return void 0;
  const unit = match[2];
  return unit == null ? `${value}%` : `${value}${unit}`;
}
function resolvePanelSizes({
  sizes,
  panels,
  rootEl,
  orientation
}) {
  const nextSize = Array(panels.length);
  let remainingSize = 100;
  let numPanelsWithSizes = 0;
  for (let index = 0; index < panels.length; index++) {
    const size = parsePanelSize(sizes?.[index], rootEl, orientation);
    if (size == null) continue;
    numPanelsWithSizes++;
    nextSize[index] = size;
    remainingSize -= size;
  }
  for (let index = 0; index < panels.length; index++) {
    if (nextSize[index] != null) continue;
    const numRemainingPanels = panels.length - numPanelsWithSizes;
    const size = numRemainingPanels > 0 ? remainingSize / numRemainingPanels : 0;
    numPanelsWithSizes++;
    nextSize[index] = size;
    remainingSize -= size;
  }
  return nextSize;
}
function normalizePanels(panels, rootEl, orientation) {
  return panels.map((panel) => ({
    ...panel,
    minSize: parsePanelSize(panel.minSize, rootEl, orientation),
    maxSize: parsePanelSize(panel.maxSize, rootEl, orientation),
    collapsedSize: parsePanelSize(panel.collapsedSize, rootEl, orientation)
  }));
}

// ../node_modules/.pnpm/@zag-js+splitter@1.43.3/node_modules/@zag-js/splitter/dist/utils/panel.mjs
function getPanelById(panels, id) {
  const panel = panels.find((panel2) => panel2.id === id);
  ensure(panel, () => `Panel data not found for id "${id}"`);
  return panel;
}
function findPanelDataIndex(panels, panel) {
  return panels.findIndex((prevPanel) => prevPanel === panel || prevPanel.id === panel.id);
}
function findPanelIndex(panels, id) {
  return panels.findIndex((panel) => panel.id === id);
}
function panelDataHelper(panels, panel, sizes) {
  const index = findPanelIndex(panels, panel.id);
  const pivotIndices = index === panels.length - 1 ? [index - 1, index] : [index, index + 1];
  const panelSize = sizes[index];
  return { ...panel, panelSize, pivotIndices };
}
function sortPanels(panels) {
  return panels.sort((panelA, panelB) => {
    const orderA = panelA.order;
    const orderB = panelB.order;
    if (orderA == null && orderB == null) {
      return 0;
    } else if (orderA == null) {
      return -1;
    } else if (orderB == null) {
      return 1;
    } else {
      return orderA - orderB;
    }
  });
}
function getPanelLayout(panels) {
  return panels.map((panel) => panel.id).sort().join(":");
}
function serializePanels(panels) {
  const keys = panels.map((panel) => panel.id);
  const sortedKeys = keys.sort();
  const serialized = sortedKeys.map((key) => {
    const panel = panels.find((panel2) => panel2.id === key);
    return JSON.stringify(panel);
  });
  return serialized.join(",");
}
function getPanelFlexBoxStyle({
  size,
  defaultSize,
  dragState,
  resolvedSizes,
  panels,
  panelIndex,
  horizontal,
  collapsed = false,
  precision = 3
}) {
  const resolvedSize = resolvedSizes[panelIndex];
  const layoutSize = size ?? defaultSize;
  const panel = panels[panelIndex];
  let flexGrow;
  let flexBasis;
  let flexShrink = 1;
  const constraintAxis = horizontal ? "Width" : "Height";
  const minSizeCss = panel ? toCssPanelSize(panel.minSize) : void 0;
  const maxSize = panel ? toCssPanelSize(panel.maxSize) : void 0;
  const minSize = collapsed ? toCssPanelSize(panel?.collapsedSize ?? 0) : minSizeCss;
  const layoutCssSize = toCssPanelSize(layoutSize);
  if (resolvedSize == null) {
    if (layoutCssSize != null) {
      if (layoutCssSize.endsWith("%")) {
        flexGrow = Number.parseFloat(layoutCssSize).toPrecision(precision);
      } else {
        flexBasis = getClampedFlexBasis({
          basis: layoutCssSize,
          minSize: minSizeCss,
          maxSize
        });
        flexGrow = "0";
        flexShrink = 0;
      }
    } else {
      flexGrow = "1";
    }
  } else if (panels.length === 1) {
    flexGrow = "1";
  } else {
    flexGrow = resolvedSize.toPrecision(precision);
  }
  return {
    flexBasis: flexBasis ?? 0,
    flexGrow,
    flexShrink,
    ...minSize ? { [`min${constraintAxis}`]: minSize } : {},
    ...maxSize ? { [`max${constraintAxis}`]: maxSize } : {},
    // Without this, Panel sizes may be unintentionally overridden by their content
    overflow: "hidden",
    // Disable pointer events inside of a panel during resize
    // This avoid edge cases like nested iframes
    pointerEvents: dragState !== null ? "none" : void 0
  };
}
function getClampedFlexBasis({
  basis,
  minSize,
  maxSize
}) {
  return `clamp(${minSize ?? "0%"}, ${basis}, ${maxSize ?? "100%"})`;
}

// ../node_modules/.pnpm/@zag-js+splitter@1.43.3/node_modules/@zag-js/splitter/dist/splitter.connect.mjs
function connect(service, normalize) {
  const { state, send, prop, computed, context, scope } = service;
  const horizontal = computed("horizontal");
  const dragging = state.matches("dragging");
  const registry = prop("registry");
  const orientation = prop("orientation");
  const rawPanels = prop("panels");
  const panels = context.get("panels");
  const getResolvedSizes = () => {
    const sizes = context.get("size");
    if (sizes.length > 0) return sizes;
    return resolvePanelSizes({
      sizes: prop("size") ?? prop("defaultSize"),
      panels: rawPanels,
      rootEl: null,
      orientation
    });
  };
  const getPanelStyle = (id) => {
    const panelIndex = rawPanels.findIndex((panel) => panel.id === id);
    const size = prop("size")?.[panelIndex];
    const defaultSize = prop("defaultSize")?.[panelIndex];
    const dragState = context.get("dragState");
    const resolvedSizes = context.get("size");
    const panelData = panels[panelIndex];
    const panelSize = resolvedSizes[panelIndex];
    const collapsed = !!panelData?.collapsible && panelSize != null && fuzzyNumbersEqual(panelSize, panelData.collapsedSize ?? 0);
    return getPanelFlexBoxStyle({
      size,
      defaultSize,
      dragState,
      resolvedSizes,
      panels: rawPanels,
      panelIndex,
      horizontal,
      collapsed
    });
  };
  const resolveResizeTriggerId2 = (id) => {
    const [beforeId, afterId] = id.split(":");
    if (beforeId && afterId) return id;
    if (beforeId) {
      const index = rawPanels.findIndex((panel) => panel.id === beforeId);
      const nextPanel = rawPanels[index + 1];
      return nextPanel ? `${beforeId}:${nextPanel.id}` : id;
    }
    if (afterId) {
      const index = rawPanels.findIndex((panel) => panel.id === afterId);
      const prevPanel = rawPanels[index - 1];
      return prevPanel ? `${prevPanel.id}:${afterId}` : id;
    }
    return id;
  };
  const getResizeTriggerState = (props) => {
    const { id, disabled } = props;
    const dragging2 = context.get("dragState")?.resizeTriggerId === id;
    const focused = dragging2 || state.matches("focused") && context.get("keyboardState")?.resizeTriggerId === id;
    return {
      dragging: dragging2,
      focused,
      disabled: !!disabled
    };
  };
  return {
    dragging,
    orientation,
    getPanels() {
      return rawPanels;
    },
    getPanelById(id) {
      return getPanelById(rawPanels, id);
    },
    getItems() {
      return rawPanels.flatMap((panel, index, arr) => {
        const nextPanel = arr[index + 1];
        if (panel && nextPanel) {
          return [
            { type: "panel", id: panel.id },
            { type: "handle", id: `${panel.id}:${nextPanel.id}` }
          ];
        }
        return [{ type: "panel", id: panel.id }];
      });
    },
    getSizes() {
      return getResolvedSizes();
    },
    setSizes(size) {
      send({ type: "SIZE.SET", size });
    },
    resetSizes() {
      send({ type: "SIZE.RESET" });
    },
    collapsePanel(id) {
      send({ type: "PANEL.COLLAPSE", id });
    },
    expandPanel(id, minSize) {
      send({ type: "PANEL.EXPAND", id, minSize });
    },
    resizePanel(id, unsafePanelSize) {
      send({ type: "PANEL.RESIZE", id, size: unsafePanelSize });
    },
    getPanelSize(id) {
      const panels2 = context.get("panels");
      const size = getResolvedSizes();
      const panelData = getPanelById(panels2, id);
      const { panelSize } = panelDataHelper(panels2, panelData, size);
      ensure(panelSize != null, () => `Panel size not found for panel "${panelData.id}"`);
      return panelSize;
    },
    isPanelCollapsed(id) {
      const panels2 = context.get("panels");
      const size = getResolvedSizes();
      const panelData = getPanelById(panels2, id);
      const { collapsedSize = 0, collapsible, panelSize } = panelDataHelper(panels2, panelData, size);
      ensure(panelSize != null, () => `Panel size not found for panel "${panelData.id}"`);
      return collapsible === true && fuzzyNumbersEqual(panelSize, collapsedSize);
    },
    isPanelExpanded(id) {
      const panels2 = context.get("panels");
      const size = getResolvedSizes();
      const panelData = getPanelById(panels2, id);
      const { collapsedSize = 0, collapsible, panelSize } = panelDataHelper(panels2, panelData, size);
      ensure(panelSize != null, () => `Panel size not found for panel "${panelData.id}"`);
      return !collapsible || fuzzyCompareNumbers(panelSize, collapsedSize) > 0;
    },
    getLayout() {
      return getPanelLayout(prop("panels"));
    },
    getRootProps() {
      return normalize.element({
        ...parts.root.attrs,
        "data-orientation": orientation,
        "data-dragging": dataAttr(dragging),
        id: getRootId(scope),
        dir: prop("dir"),
        style: {
          display: "flex",
          flexDirection: horizontal ? "row" : "column",
          height: "100%",
          width: "100%",
          overflow: "hidden"
        }
      });
    },
    getPanelProps(props) {
      const { id } = props;
      return normalize.element({
        ...parts.panel.attrs,
        "data-orientation": orientation,
        "data-dragging": dataAttr(dragging),
        dir: prop("dir"),
        "data-id": id,
        "data-index": findPanelIndex(prop("panels"), id),
        id: getPanelId(scope, id),
        "data-ownedby": getRootId(scope),
        style: getPanelStyle(id)
      });
    },
    getResizeTriggerState,
    getResizeTriggerIndicator(props) {
      const triggerState = getResizeTriggerState(props);
      return normalize.element({
        ...parts.resizeTriggerIndicator.attrs,
        "data-orientation": orientation,
        "data-focus": dataAttr(triggerState.focused),
        "data-dragging": dataAttr(triggerState.dragging),
        "data-disabled": dataAttr(triggerState.disabled),
        "data-ownedby": getRootId(scope)
      });
    },
    getResizeTriggerProps(props) {
      const { id } = props;
      const triggerState = getResizeTriggerState(props);
      const resolvedId = resolveResizeTriggerId2(id);
      const aria = getAriaValue(getResolvedSizes(), panels, resolvedId);
      return normalize.element({
        ...parts.resizeTrigger.attrs,
        dir: prop("dir"),
        id: getResizeTriggerId(scope, id),
        role: "separator",
        "data-id": id,
        "data-ownedby": getRootId(scope),
        tabIndex: triggerState.disabled ? void 0 : 0,
        "aria-valuenow": aria.valueNow,
        "aria-valuemin": aria.valueMin,
        "aria-valuemax": aria.valueMax,
        "data-orientation": orientation,
        "aria-orientation": orientation,
        "aria-controls": aria.beforeId && aria.afterId ? `${getPanelId(scope, aria.beforeId)} ${getPanelId(scope, aria.afterId)}` : void 0,
        "data-focus": dataAttr(triggerState.focused),
        "data-dragging": dataAttr(triggerState.dragging),
        "data-disabled": dataAttr(triggerState.disabled),
        style: {
          touchAction: "none",
          userSelect: "none",
          WebkitUserSelect: "none",
          flex: "0 0 auto",
          pointerEvents: triggerState.disabled ? "none" : triggerState.dragging && !triggerState.focused ? "none" : void 0,
          cursor: triggerState.disabled || registry ? void 0 : horizontal ? "col-resize" : "row-resize",
          [horizontal ? "minHeight" : "minWidth"]: "0"
        },
        onPointerDown(event) {
          if (!isLeftClick(event)) return;
          if (triggerState.disabled) {
            event.preventDefault();
            return;
          }
          event.currentTarget.focus({ preventScroll: true, focusVisible: false });
          if (registry) {
            return;
          }
          const point = getEventPoint(event);
          send({ type: "POINTER_DOWN", id, point });
          event.currentTarget.setPointerCapture(event.pointerId);
          event.preventDefault();
          event.stopPropagation();
        },
        onPointerUp(event) {
          if (triggerState.disabled) return;
          if (event.currentTarget.hasPointerCapture(event.pointerId)) {
            event.currentTarget.releasePointerCapture(event.pointerId);
          }
        },
        onPointerOver() {
          if (triggerState.disabled || registry) return;
          send({ type: "POINTER_OVER", id });
        },
        onPointerLeave() {
          if (triggerState.disabled || registry) return;
          send({ type: "POINTER_LEAVE", id });
        },
        onBlur() {
          if (triggerState.disabled) return;
          send({ type: "BLUR" });
        },
        onFocus() {
          if (triggerState.disabled) return;
          send({ type: "FOCUS", id });
        },
        onKeyDown(event) {
          if (event.defaultPrevented) return;
          if (triggerState.disabled) return;
          const keyboardResizeBy = prop("keyboardResizeBy");
          let delta = 0;
          if (event.shiftKey) {
            delta = 10;
          } else if (keyboardResizeBy != null) {
            delta = keyboardResizeBy;
          } else {
            delta = 1;
          }
          const keyMap = {
            Enter() {
              send({ type: "ENTER", id });
            },
            ArrowUp() {
              send({ type: "KEYBOARD_MOVE", id, delta: horizontal ? 0 : -delta });
            },
            ArrowDown() {
              send({ type: "KEYBOARD_MOVE", id, delta: horizontal ? 0 : delta });
            },
            ArrowLeft() {
              send({ type: "KEYBOARD_MOVE", id, delta: horizontal ? -delta : 0 });
            },
            ArrowRight() {
              send({ type: "KEYBOARD_MOVE", id, delta: horizontal ? delta : 0 });
            },
            Home() {
              send({ type: "KEYBOARD_MOVE", id, delta: -100 });
            },
            End() {
              send({ type: "KEYBOARD_MOVE", id, delta: 100 });
            },
            F6() {
              send({ type: "FOCUS.CYCLE", id, shiftKey: event.shiftKey });
            }
          };
          const key = getEventKey(event, {
            dir: prop("dir"),
            orientation
          });
          const exec = keyMap[key];
          if (exec) {
            exec(event);
            event.preventDefault();
          }
        }
      });
    }
  };
}

// ../node_modules/.pnpm/@zag-js+splitter@1.43.3/node_modules/@zag-js/splitter/dist/utils/preserve-fixed-panel-sizes.mjs
function preserveFixedPanelSizes({
  panels,
  prevLayout,
  prevGroupSize,
  nextGroupSize
}) {
  if (prevGroupSize <= 0 || nextGroupSize <= 0) {
    return prevLayout;
  }
  const nextLayout = [...prevLayout];
  const relativeIndices = [];
  let fixedTotal = 0;
  let relativeTotal = 0;
  panels.forEach((panel, index) => {
    if (panel.resizeBehavior === "preserve-pixel-size") {
      const prevPixelSize = prevLayout[index] / 100 * prevGroupSize;
      const nextPercentSize = prevPixelSize / nextGroupSize * 100;
      nextLayout[index] = nextPercentSize;
      fixedTotal += nextPercentSize;
    } else {
      relativeIndices.push(index);
      relativeTotal += prevLayout[index];
    }
  });
  if (relativeIndices.length === 0) {
    const total2 = nextLayout.reduce((accumulated, current) => accumulated + current, 0);
    if (fuzzyNumbersEqual(total2, 100)) {
      return nextLayout;
    }
    if (total2 <= 0) {
      return prevLayout;
    }
    const scale2 = 100 / total2;
    return nextLayout.map((size) => size * scale2);
  }
  const remainingSize = 100 - fixedTotal;
  if (remainingSize <= 0) {
    const total2 = nextLayout.reduce((accumulated, current) => accumulated + current, 0);
    if (fuzzyNumbersEqual(total2, 100)) {
      return nextLayout;
    }
    const scale2 = 100 / Math.max(total2, 1);
    return nextLayout.map((size) => size * scale2);
  }
  if (fuzzyNumbersEqual(relativeTotal, 0)) {
    const size = remainingSize / relativeIndices.length;
    relativeIndices.forEach((index) => {
      nextLayout[index] = size;
    });
    return nextLayout;
  }
  relativeIndices.forEach((index) => {
    nextLayout[index] = prevLayout[index] / relativeTotal * remainingSize;
  });
  const total = nextLayout.reduce((accumulated, current) => accumulated + current, 0);
  if (fuzzyNumbersEqual(total, 100)) {
    return nextLayout;
  }
  const scale = 100 / total;
  return nextLayout.map((size) => size * scale);
}

// ../node_modules/.pnpm/@zag-js+splitter@1.43.3/node_modules/@zag-js/splitter/dist/utils/resize-panel.mjs
function resizePanel({ panels, index, size }) {
  const panel = panels[index];
  ensure(panel, () => `Panel data not found for index ${index}`);
  let { collapsedSize = 0, collapsible, maxSize = 100, minSize = 0 } = panel;
  if (fuzzyCompareNumbers(size, minSize) < 0) {
    if (collapsible) {
      const halfwayPoint = (collapsedSize + minSize) / 2;
      if (fuzzyCompareNumbers(size, halfwayPoint) < 0) {
        size = collapsedSize;
      } else {
        size = minSize;
      }
    } else {
      size = minSize;
    }
  }
  size = Math.min(maxSize, size);
  size = parseFloat(size.toFixed(PRECISION));
  return size;
}

// ../node_modules/.pnpm/@zag-js+splitter@1.43.3/node_modules/@zag-js/splitter/dist/utils/resize-by-delta.mjs
function resizeByDelta(props) {
  let { delta, initialSize, panels, pivotIndices, prevSize, trigger } = props;
  if (fuzzyNumbersEqual(delta, 0)) {
    return initialSize;
  }
  const nextSize = [...initialSize];
  const [firstPivotIndex, secondPivotIndex] = pivotIndices;
  ensure(firstPivotIndex, () => "Invalid first pivot index");
  ensure(secondPivotIndex, () => "Invalid second pivot index");
  let deltaApplied = 0;
  {
    if (trigger === "keyboard") {
      {
        const index = delta < 0 ? secondPivotIndex : firstPivotIndex;
        const panel = panels[index];
        ensure(panel, () => `Panel data not found for index ${index}`);
        const { collapsedSize = 0, collapsible, minSize = 0 } = panel;
        if (collapsible) {
          const prevSize2 = initialSize[index];
          ensure(prevSize2, () => `Previous size not found for panel index ${index}`);
          if (fuzzyNumbersEqual(prevSize2, collapsedSize)) {
            const localDelta = minSize - prevSize2;
            if (fuzzyCompareNumbers(localDelta, Math.abs(delta)) > 0) {
              delta = delta < 0 ? 0 - localDelta : localDelta;
            }
          }
        }
      }
      {
        const index = delta < 0 ? firstPivotIndex : secondPivotIndex;
        const panel = panels[index];
        ensure(panel, () => `No panel data found for index ${index}`);
        const { collapsedSize = 0, collapsible, minSize = 0 } = panel;
        if (collapsible) {
          const prevSize2 = initialSize[index];
          ensure(prevSize2, () => `Previous size not found for panel index ${index}`);
          if (fuzzyNumbersEqual(prevSize2, minSize)) {
            const localDelta = prevSize2 - collapsedSize;
            if (fuzzyCompareNumbers(localDelta, Math.abs(delta)) > 0) {
              delta = delta < 0 ? 0 - localDelta : localDelta;
            }
          }
        }
      }
    }
  }
  {
    const increment = delta < 0 ? 1 : -1;
    let index = delta < 0 ? secondPivotIndex : firstPivotIndex;
    let maxAvailableDelta = 0;
    while (true) {
      const prevSize2 = initialSize[index];
      ensure(prevSize2, () => `Previous size not found for panel index ${index}`);
      const maxSafeSize = resizePanel({
        panels,
        index,
        size: 100
      });
      const delta2 = maxSafeSize - prevSize2;
      maxAvailableDelta += delta2;
      index += increment;
      if (index < 0 || index >= panels.length) {
        break;
      }
    }
    const minAbsDelta = Math.min(Math.abs(delta), Math.abs(maxAvailableDelta));
    delta = delta < 0 ? 0 - minAbsDelta : minAbsDelta;
  }
  {
    const pivotIndex = delta < 0 ? firstPivotIndex : secondPivotIndex;
    let index = pivotIndex;
    while (index >= 0 && index < panels.length) {
      const deltaRemaining = Math.abs(delta) - Math.abs(deltaApplied);
      const prevSize2 = initialSize[index];
      ensure(prevSize2, () => `Previous size not found for panel index ${index}`);
      const unsafeSize = prevSize2 - deltaRemaining;
      const safeSize = resizePanel({ panels, index, size: unsafeSize });
      if (!fuzzyNumbersEqual(prevSize2, safeSize)) {
        deltaApplied += prevSize2 - safeSize;
        nextSize[index] = safeSize;
        if (deltaApplied.toPrecision(3).localeCompare(Math.abs(delta).toPrecision(3), void 0, {
          numeric: true
        }) >= 0) {
          break;
        }
      }
      if (delta < 0) {
        index--;
      } else {
        index++;
      }
    }
  }
  if (fuzzySizeEqual(prevSize, nextSize)) {
    return prevSize;
  }
  {
    const pivotIndex = delta < 0 ? secondPivotIndex : firstPivotIndex;
    const prevSize2 = initialSize[pivotIndex];
    ensure(prevSize2, () => `Previous size not found for panel index ${pivotIndex}`);
    const unsafeSize = prevSize2 + deltaApplied;
    const safeSize = resizePanel({ panels, index: pivotIndex, size: unsafeSize });
    nextSize[pivotIndex] = safeSize;
    if (!fuzzyNumbersEqual(safeSize, unsafeSize)) {
      let deltaRemaining = unsafeSize - safeSize;
      const pivotIndex2 = delta < 0 ? secondPivotIndex : firstPivotIndex;
      let index = pivotIndex2;
      while (index >= 0 && index < panels.length) {
        const prevSize3 = nextSize[index];
        ensure(prevSize3, () => `Previous size not found for panel index ${index}`);
        const unsafeSize2 = prevSize3 + deltaRemaining;
        const safeSize2 = resizePanel({ panels, index, size: unsafeSize2 });
        if (!fuzzyNumbersEqual(prevSize3, safeSize2)) {
          deltaRemaining -= safeSize2 - prevSize3;
          nextSize[index] = safeSize2;
        }
        if (fuzzyNumbersEqual(deltaRemaining, 0)) {
          break;
        }
        if (delta > 0) {
          index--;
        } else {
          index++;
        }
      }
    }
  }
  const totalSize = nextSize.reduce((total, size) => size + total, 0);
  if (!fuzzyNumbersEqual(totalSize, 100)) {
    return prevSize;
  }
  return nextSize;
}

// ../node_modules/.pnpm/@zag-js+splitter@1.43.3/node_modules/@zag-js/splitter/dist/utils/validate-sizes.mjs
function validateSizes({ size: prevSize, panels }) {
  const nextSize = [...prevSize];
  const nextSizeTotalSize = nextSize.reduce((accumulated, current) => accumulated + current, 0);
  if (nextSize.length !== panels.length) {
    throw Error(`Invalid ${panels.length} panel size: ${nextSize.map((size) => `${size}%`).join(", ")}`);
  } else if (!fuzzyNumbersEqual(nextSizeTotalSize, 100) && nextSize.length > 0) {
    for (let index = 0; index < panels.length; index++) {
      const unsafeSize = nextSize[index];
      ensure(unsafeSize, () => `No size data found for index ${index}`);
      const safeSize = 100 / nextSizeTotalSize * unsafeSize;
      nextSize[index] = safeSize;
    }
  }
  let remainingSize = 0;
  for (let index = 0; index < panels.length; index++) {
    const unsafeSize = nextSize[index];
    ensure(unsafeSize, () => `No size data found for index ${index}`);
    const safeSize = resizePanel({ panels, index, size: unsafeSize });
    if (unsafeSize != safeSize) {
      remainingSize += unsafeSize - safeSize;
      nextSize[index] = safeSize;
    }
  }
  if (!fuzzyNumbersEqual(remainingSize, 0)) {
    for (let index = 0; index < panels.length; index++) {
      const prevSize2 = nextSize[index];
      ensure(prevSize2, () => `No size data found for index ${index}`);
      const unsafeSize = prevSize2 + remainingSize;
      const safeSize = resizePanel({ panels, index, size: unsafeSize });
      if (prevSize2 !== safeSize) {
        remainingSize -= safeSize - prevSize2;
        nextSize[index] = safeSize;
        if (fuzzyNumbersEqual(remainingSize, 0)) {
          break;
        }
      }
    }
  }
  return nextSize;
}

// ../node_modules/.pnpm/@zag-js+splitter@1.43.3/node_modules/@zag-js/splitter/dist/splitter.machine.mjs
var machine = createMachine({
  props({ props }) {
    ensureProps(props, ["panels"]);
    return {
      orientation: "horizontal",
      defaultSize: [],
      dir: "ltr",
      ...props,
      panels: sortPanels(props.panels)
    };
  },
  initialState() {
    return "idle";
  },
  context({ prop, bindable, getContext, getRefs }) {
    return {
      panels: bindable(() => ({
        defaultValue: normalizePanels(prop("panels"), null, prop("orientation"))
      })),
      size: bindable(() => ({
        defaultValue: [],
        isEqual(a, b) {
          return b != null && fuzzySizeEqual(a, b);
        },
        onChange(value) {
          const ctx = getContext();
          const refs = getRefs();
          if (refs.get("suppressOnResize")) return;
          const sizesBeforeCollapse = refs.get("panelSizeBeforeCollapse");
          const expandToSizes = Object.fromEntries(sizesBeforeCollapse.entries());
          const resizeTriggerId = ctx.get("dragState")?.resizeTriggerId ?? null;
          const layout = getPanelLayout(prop("panels"));
          prop("onResize")?.({
            size: value,
            layout,
            resizeTriggerId,
            expandToSizes
          });
        }
      })),
      dragState: bindable(() => ({
        defaultValue: null
      })),
      keyboardState: bindable(() => ({
        defaultValue: null
      }))
    };
  },
  watch({ track, action, prop }) {
    track(
      [
        () => serializePanels(prop("panels")),
        () => JSON.stringify(prop("size") ?? []),
        () => JSON.stringify(prop("defaultSize") ?? [])
      ],
      () => {
        action(["syncSize"]);
      }
    );
  },
  refs() {
    return {
      panelSizeBeforeCollapse: /* @__PURE__ */ new Map(),
      prevDelta: 0,
      panelIdToLastNotifiedSizeMap: /* @__PURE__ */ new Map(),
      initialSize: null,
      prevInitialLayout: null,
      prevGroupSize: null,
      lastRequestedSize: null,
      suppressOnResize: false
    };
  },
  computed: {
    horizontal({ prop }) {
      return prop("orientation") === "horizontal";
    }
  },
  on: {
    "SIZE.SET": {
      actions: ["setSize"]
    },
    "SIZE.RESET": {
      actions: ["resetSize"]
    },
    "PANEL.COLLAPSE": {
      actions: ["collapsePanel"]
    },
    "PANEL.EXPAND": {
      actions: ["expandPanel"]
    },
    "PANEL.RESIZE": {
      actions: ["resizePanel"]
    },
    "ROOT.RESIZE": {
      actions: ["syncSize"]
    }
  },
  entry: ["syncSize"],
  exit: ["clearGlobalCursor"],
  effects: ["trackResizeHandles", "trackRootResize"],
  states: {
    idle: {
      entry: ["clearDraggingState", "clearKeyboardState"],
      on: {
        POINTER_OVER: {
          target: "hover:temp",
          actions: ["setKeyboardState"]
        },
        FOCUS: {
          target: "focused",
          actions: ["setKeyboardState"]
        },
        POINTER_DOWN: {
          target: "dragging",
          actions: ["setDraggingState"]
        }
      }
    },
    "hover:temp": {
      effects: ["waitForHoverDelay"],
      on: {
        HOVER_DELAY: {
          target: "hover"
        },
        FOCUS: {
          target: "focused",
          actions: ["setKeyboardState"]
        },
        POINTER_DOWN: {
          target: "dragging",
          actions: ["setDraggingState"]
        },
        POINTER_LEAVE: {
          target: "idle"
        }
      }
    },
    hover: {
      tags: ["focus"],
      on: {
        FOCUS: {
          target: "focused",
          actions: ["setKeyboardState"]
        },
        POINTER_DOWN: {
          target: "dragging",
          actions: ["setDraggingState"]
        },
        POINTER_LEAVE: {
          target: "idle"
        }
      }
    },
    focused: {
      tags: ["focus"],
      on: {
        BLUR: {
          target: "idle"
        },
        ENTER: {
          actions: ["collapseOrExpandPanel"]
        },
        POINTER_DOWN: {
          target: "dragging",
          actions: ["setDraggingState"]
        },
        KEYBOARD_MOVE: {
          actions: ["invokeOnResizeStart", "setKeyboardValue", "invokeOnResizeEnd"]
        },
        "FOCUS.CYCLE": {
          actions: ["focusNextResizeTrigger"]
        }
      }
    },
    dragging: {
      tags: ["focus"],
      effects: ["trackPointerMove"],
      entry: ["invokeOnResizeStart"],
      on: {
        POINTER_MOVE: {
          actions: ["setPointerValue", "setGlobalCursor"]
        },
        POINTER_UP: [
          {
            guard: "isResizeTriggerFocused",
            target: "focused",
            actions: ["invokeOnResizeEnd", "setKeyboardState", "clearDraggingState", "clearGlobalCursor"]
          },
          {
            target: "idle",
            actions: ["invokeOnResizeEnd", "clearGlobalCursor"]
          }
        ]
      }
    }
  },
  implementations: {
    guards: {
      isResizeTriggerFocused({ context, scope }) {
        const dragState = context.get("dragState");
        return scope.isActiveElement(getResizeTriggerEl(scope, dragState?.resizeTriggerId));
      }
    },
    effects: {
      trackResizeHandles: ({ prop, scope, send }) => {
        const registry = prop("registry");
        if (!registry) return;
        let cleanups = [];
        const exec = () => {
          cleanups.forEach((fn) => fn());
          cleanups = getResizeTriggerEls(scope).map((resizeTriggerEl) => {
            const id = resizeTriggerEl.dataset.id;
            if (!id) return;
            return registry.register({
              id: getResizeTriggerId(scope, id),
              element: resizeTriggerEl,
              orientation: prop("orientation"),
              onActivate(point) {
                send({ type: "POINTER_DOWN", id, point });
              },
              onDeactivate() {
                send({ type: "POINTER_UP" });
              }
            });
          }).filter(Boolean);
        };
        exec();
        const observeCleanup = observeChildren(getRootEl(scope), {
          callback: exec
        });
        return () => {
          cleanups.forEach((fn) => fn());
          observeCleanup?.();
        };
      },
      trackRootResize: ({ scope, send }) => {
        const rootEl = getRootEl(scope);
        if (!rootEl) return;
        return resizeObserverBorderBox.observe(rootEl, () => {
          send({ type: "ROOT.RESIZE" });
        });
      },
      waitForHoverDelay: ({ send }) => {
        return setRafTimeout(() => {
          send({ type: "HOVER_DELAY" });
        }, 250);
      },
      trackPointerMove: ({ scope, send }) => {
        const doc = scope.getDoc();
        return trackPointerMove(doc, {
          onPointerMove(info) {
            send({ type: "POINTER_MOVE", point: info.point });
          },
          onPointerUp() {
            send({ type: "POINTER_UP" });
          }
        });
      }
    },
    actions: {
      setSize(params) {
        const { context, event, prop, scope } = params;
        const unsafeSize = event.size;
        const prevSize = context.get("size");
        const panels = context.get("panels");
        const safeSize = validateSizes({
          size: resolvePanelSizes({
            sizes: unsafeSize,
            panels: prop("panels"),
            rootEl: getRootEl(scope),
            orientation: prop("orientation")
          }),
          panels
        });
        if (!isEqual(prevSize, safeSize)) {
          setSize(params, safeSize);
        }
      },
      resetSize(params) {
        const { refs, context, prop, scope } = params;
        const initialSize = refs.get("initialSize");
        const nextSize = initialSize ?? validateSizes({
          size: resolvePanelSizes({
            sizes: prop("size") ?? prop("defaultSize"),
            panels: prop("panels"),
            rootEl: getRootEl(scope),
            orientation: prop("orientation")
          }),
          panels: context.get("panels")
        });
        setSize(params, nextSize);
      },
      syncSize(params) {
        const { context, scope, prop, refs } = params;
        const rootEl = getRootEl(scope);
        if (!rootEl) return;
        const orientation = prop("orientation");
        const nextGroupSize = getGroupSize(rootEl, orientation);
        if (nextGroupSize <= 0) return;
        const panels = normalizePanels(prop("panels"), rootEl, prop("orientation"));
        context.set("panels", panels);
        const sizeSpec = prop("size") ?? prop("defaultSize");
        const initialLayout = `${getPanelLayout(prop("panels"))}:${JSON.stringify(prop("size") ?? [])}:${JSON.stringify(prop("defaultSize") ?? [])}`;
        const prevGroupSize = refs.get("prevGroupSize");
        const currentSize = context.get("size");
        const nextResolvedSize = resolvePanelSizes({
          sizes: sizeSpec,
          panels: prop("panels"),
          rootEl,
          orientation
        });
        const canPreserveLayout = prevGroupSize != null && prevGroupSize !== nextGroupSize && currentSize.length === panels.length;
        const nextSize = canPreserveLayout ? preserveFixedPanelSizes({
          panels,
          prevLayout: currentSize,
          prevGroupSize,
          nextGroupSize
        }) : nextResolvedSize;
        const safeSize = validateSizes({
          size: nextSize,
          panels
        });
        if (refs.get("prevInitialLayout") !== initialLayout) {
          refs.set("initialSize", safeSize);
          refs.set("prevInitialLayout", initialLayout);
        }
        const prevSize = context.get("size");
        if (!isEqual(prevSize, safeSize)) {
          refs.set("suppressOnResize", prop("size") != null || prevSize.length === 0);
          context.set("size", safeSize);
          refs.set("suppressOnResize", false);
        }
        refs.set("prevGroupSize", nextGroupSize);
      },
      setDraggingState({ context, event, prop, scope }) {
        const orientation = prop("orientation");
        const size = context.get("size");
        const resizeTriggerId = event.id;
        const resolvedResizeTriggerId = resolveResizeTriggerId(scope, resizeTriggerId);
        if (!resolvedResizeTriggerId) return;
        const panelGroupEl = getRootEl(scope);
        if (!panelGroupEl) return;
        const handleElement = getResizeTriggerEl(scope, resizeTriggerId);
        ensure(handleElement, () => `Drag handle element not found for id "${resizeTriggerId}"`);
        const initialCursorPosition = orientation === "horizontal" ? event.point.x : event.point.y;
        context.set("dragState", {
          resizeTriggerId: event.id,
          resolvedResizeTriggerId,
          resizeTriggerRect: handleElement.getBoundingClientRect(),
          initialCursorPosition,
          initialSize: size
        });
      },
      clearDraggingState({ context }) {
        context.set("dragState", null);
      },
      setKeyboardState({ context, event, scope }) {
        const id = event.id ?? context.get("dragState")?.resizeTriggerId;
        if (id == null) return;
        context.set("keyboardState", {
          resizeTriggerId: id,
          resolvedResizeTriggerId: resolveResizeTriggerId(scope, id)
        });
      },
      clearKeyboardState({ context }) {
        context.set("keyboardState", null);
      },
      collapsePanel(params) {
        const { context, event, refs } = params;
        const prevSize = context.get("size");
        const panels = context.get("panels");
        const panel = panels.find((panel2) => panel2.id === event.id);
        ensure(panel, () => `Panel data not found for id "${event.id}"`);
        if (panel.collapsible) {
          const { collapsedSize = 0, panelSize, pivotIndices } = panelDataHelper(panels, panel, prevSize);
          ensure(panelSize != null, () => `Panel size not found for panel "${panel.id}"`);
          if (!fuzzyNumbersEqual(panelSize, collapsedSize)) {
            refs.get("panelSizeBeforeCollapse").set(panel.id, panelSize);
            const isLastPanel = findPanelDataIndex(panels, panel) === panels.length - 1;
            const delta = isLastPanel ? panelSize - collapsedSize : collapsedSize - panelSize;
            const nextSize = resizeByDelta({
              delta,
              initialSize: prevSize,
              panels,
              pivotIndices,
              prevSize,
              trigger: "imperative-api"
            });
            if (!isEqual(prevSize, nextSize)) {
              setSize(params, nextSize);
            }
          }
        }
      },
      expandPanel(params) {
        const { context, event, refs } = params;
        const panels = context.get("panels");
        const prevSize = context.get("size");
        const panel = panels.find((panel2) => panel2.id === event.id);
        ensure(panel, () => `Panel data not found for id "${event.id}"`);
        if (panel.collapsible) {
          const {
            collapsedSize = 0,
            panelSize = 0,
            minSize: minSizeFromProps = 0,
            pivotIndices
          } = panelDataHelper(panels, panel, prevSize);
          const minSize = event.minSize ?? minSizeFromProps;
          if (fuzzyNumbersEqual(panelSize, collapsedSize)) {
            const prevPanelSize = refs.get("panelSizeBeforeCollapse").get(panel.id);
            const baseSize = prevPanelSize != null && prevPanelSize >= minSize ? prevPanelSize : minSize;
            const isLastPanel = findPanelDataIndex(panels, panel) === panels.length - 1;
            const delta = isLastPanel ? panelSize - baseSize : baseSize - panelSize;
            const nextSize = resizeByDelta({
              delta,
              initialSize: prevSize,
              panels,
              pivotIndices,
              prevSize,
              trigger: "imperative-api"
            });
            if (!isEqual(prevSize, nextSize)) {
              setSize(params, nextSize);
            }
          }
        }
      },
      resizePanel(params) {
        const { context, event } = params;
        const prevSize = context.get("size");
        const panels = context.get("panels");
        const panel = getPanelById(panels, event.id);
        const unsafePanelSize = event.size;
        const { panelSize, pivotIndices } = panelDataHelper(panels, panel, prevSize);
        ensure(panelSize != null, () => `Panel size not found for panel "${panel.id}"`);
        const isLastPanel = findPanelDataIndex(panels, panel) === panels.length - 1;
        const delta = isLastPanel ? panelSize - unsafePanelSize : unsafePanelSize - panelSize;
        const nextSize = resizeByDelta({
          delta,
          initialSize: prevSize,
          panels,
          pivotIndices,
          prevSize,
          trigger: "imperative-api"
        });
        if (!isEqual(prevSize, nextSize)) {
          setSize(params, nextSize);
        }
      },
      setPointerValue(params) {
        const { context, event, prop, scope } = params;
        const dragState = context.get("dragState");
        if (!dragState) return;
        const { resolvedResizeTriggerId, initialSize, initialCursorPosition } = dragState;
        const panels = context.get("panels");
        const panelGroupElement = getRootEl(scope);
        ensure(panelGroupElement, () => `Panel group element not found`);
        const pivotIndices = resolvedResizeTriggerId.split(":").map((id) => panels.findIndex((panel) => panel.id === id));
        const horizontal = prop("orientation") === "horizontal";
        const cursorPosition = horizontal ? event.point.x : event.point.y;
        const groupRect = panelGroupElement.getBoundingClientRect();
        const groupSizeInPixels = horizontal ? groupRect.width : groupRect.height;
        const offsetPixels = cursorPosition - initialCursorPosition;
        const offsetPercentage = offsetPixels / groupSizeInPixels * 100;
        const prevSize = context.get("size");
        const nextSize = resizeByDelta({
          delta: offsetPercentage,
          initialSize: initialSize ?? prevSize,
          panels,
          pivotIndices,
          prevSize,
          trigger: "mouse-or-touch"
        });
        if (!isEqual(prevSize, nextSize)) {
          setSize(params, nextSize);
        }
      },
      setKeyboardValue(params) {
        const { context, event } = params;
        const panelDataArray = context.get("panels");
        const resizeTriggerId = resolveResizeTriggerId(params.scope, event.id);
        if (!resizeTriggerId) return;
        const delta = event.delta;
        const pivotIndices = resizeTriggerId.split(":").map((id) => panelDataArray.findIndex((panelData) => panelData.id === id));
        const prevSize = context.get("size");
        const nextSize = resizeByDelta({
          delta,
          initialSize: prevSize,
          panels: panelDataArray,
          pivotIndices,
          prevSize,
          trigger: "keyboard"
        });
        if (!isEqual(prevSize, nextSize)) {
          setSize(params, nextSize);
        }
      },
      invokeOnResizeEnd({ context, prop, refs }) {
        queueMicrotask(() => {
          const dragState = context.get("dragState");
          prop("onResizeEnd")?.({
            size: refs.get("lastRequestedSize") ?? context.get("size"),
            resizeTriggerId: dragState?.resizeTriggerId ?? null
          });
        });
      },
      invokeOnResizeStart({ prop }) {
        queueMicrotask(() => {
          prop("onResizeStart")?.();
        });
      },
      collapseOrExpandPanel(params) {
        const { context, refs } = params;
        const panelDataArray = context.get("panels");
        const sizes = context.get("size");
        const resizeTriggerId = context.get("keyboardState")?.resolvedResizeTriggerId;
        const [idBefore, idAfter] = resizeTriggerId?.split(":") ?? [];
        const index = panelDataArray.findIndex((panelData2) => panelData2.id === idBefore);
        if (index === -1) return;
        const panelData = panelDataArray[index];
        ensure(panelData, () => `No panel data found for index ${index}`);
        const size = sizes[index];
        const { collapsedSize = 0, collapsible, minSize = 0 } = panelData;
        if (size != null && collapsible) {
          const pivotIndices = [idBefore, idAfter].map(
            (id) => panelDataArray.findIndex((panelData2) => panelData2.id === id)
          );
          const nextSize = resizeByDelta({
            delta: fuzzyNumbersEqual(size, collapsedSize) ? minSize - collapsedSize : collapsedSize - size,
            initialSize: refs.get("initialSize") ?? sizes,
            panels: panelDataArray,
            pivotIndices,
            prevSize: sizes,
            trigger: "keyboard"
          });
          if (!isEqual(sizes, nextSize)) {
            setSize(params, nextSize);
          }
        }
      },
      setGlobalCursor(params) {
        const { context, scope, prop } = params;
        const registry = prop("registry");
        if (registry) return;
        const dragState = context.get("dragState");
        if (!dragState) return;
        const panels = context.get("panels");
        const horizontal = prop("orientation") === "horizontal";
        const [idBefore] = dragState.resolvedResizeTriggerId.split(":");
        const indexBefore = panels.findIndex((panel2) => panel2.id === idBefore);
        const panel = panels[indexBefore];
        const size = context.get("size");
        const aria = getAriaValue(size, panels, dragState.resolvedResizeTriggerId);
        const isAtMin = fuzzyNumbersEqual(aria.valueNow, aria.valueMin) || fuzzyNumbersEqual(aria.valueNow, panel.collapsedSize);
        const isAtMax = fuzzyNumbersEqual(aria.valueNow, aria.valueMax);
        const cursorState = { isAtMin, isAtMax };
        setupGlobalCursor(scope, cursorState, horizontal, prop("nonce"));
      },
      clearGlobalCursor({ scope }) {
        removeGlobalCursor(scope);
      },
      focusNextResizeTrigger({ event, scope }) {
        const resizeTriggers = getResizeTriggerEls(scope);
        const index = resizeTriggers.findIndex((el) => el.dataset.id === event.id);
        const handleEl = event.shiftKey ? prev(resizeTriggers, index) : next(resizeTriggers, index);
        handleEl?.focus();
      }
    }
  }
});
function setSize(params, sizes) {
  const { refs, prop, context } = params;
  const panelsArray = context.get("panels");
  const onCollapse = prop("onCollapse");
  const onExpand = prop("onExpand");
  const onResize = prop("onResize");
  const onResizeStart = prop("onResizeStart");
  const onResizeEnd = prop("onResizeEnd");
  const panelIdToLastNotifiedSizeMap = refs.get("panelIdToLastNotifiedSizeMap");
  const dragState = context.get("dragState");
  const keyboardState = context.get("keyboardState");
  const isProgrammatic = dragState === null && keyboardState === null;
  refs.set("lastRequestedSize", sizes);
  if (isProgrammatic && onResizeStart) {
    queueMicrotask(() => {
      onResizeStart();
    });
  }
  if (prop("size") == null) {
    context.set("size", sizes);
  } else if (onResize) {
    const sizesBeforeCollapse = refs.get("panelSizeBeforeCollapse");
    const expandToSizes = Object.fromEntries(sizesBeforeCollapse.entries());
    const resizeTriggerId = dragState?.resizeTriggerId ?? null;
    const layout = getPanelLayout(prop("panels"));
    onResize({
      size: sizes,
      layout,
      resizeTriggerId,
      expandToSizes
    });
  }
  sizes.forEach((size, index) => {
    const panelData = panelsArray[index];
    ensure(panelData, () => `Panel data not found for index ${index}`);
    const { collapsedSize = 0, collapsible, id: panelId } = panelData;
    const lastNotifiedSize = panelIdToLastNotifiedSizeMap.get(panelId);
    if (lastNotifiedSize == null || size !== lastNotifiedSize) {
      panelIdToLastNotifiedSizeMap.set(panelId, size);
      if (collapsible && lastNotifiedSize != null && (onCollapse || onExpand)) {
        if (fuzzyNumbersEqual(lastNotifiedSize, collapsedSize) && !fuzzyNumbersEqual(size, collapsedSize)) {
          onExpand?.({ panelId, size });
        }
        if (!fuzzyNumbersEqual(lastNotifiedSize, collapsedSize) && fuzzyNumbersEqual(size, collapsedSize)) {
          onCollapse?.({ panelId, size });
        }
      }
    }
  });
  if (isProgrammatic && onResizeEnd) {
    queueMicrotask(() => {
      onResizeEnd({
        size: sizes,
        resizeTriggerId: null
        // Programmatic changes don't have a resize trigger
      });
    });
  }
}

// components/splitter.ts
var Splitter = class extends Component {
  initMachine(props) {
    return new VanillaMachine(machine, props);
  }
  initApi() {
    return this.zagConnect(connect);
  }
  render() {
    const root = this.el.querySelector('[data-scope="splitter"][data-part="root"]') ?? this.el;
    this.spreadProps(root, this.api.getRootProps());
    this.el.querySelectorAll('[data-scope="splitter"][data-part="panel"]').forEach((panel) => {
      const id = panel.dataset.id;
      if (!id) return;
      this.spreadProps(panel, this.api.getPanelProps({ id }));
    });
    this.el.querySelectorAll('[data-scope="splitter"][data-part="resize-trigger"]').forEach((trigger) => {
      const id = trigger.dataset.id;
      if (!id) return;
      this.spreadProps(trigger, this.api.getResizeTriggerProps({ id }));
    });
  }
};

// hooks/splitter.ts
function splitterProps(el, hook) {
  const onResize = (details) => {
    const eventName = getString(el, "onResize");
    if (eventName && canPushEvent(hook.liveSocket)) {
      hook.pushEvent(eventName, { id: el.id, size: details.size });
    }
    const client = getString(el, "onResizeClient");
    if (client) {
      el.dispatchEvent(
        new CustomEvent(client, { bubbles: true, detail: { id: el.id, size: details.size } })
      );
    }
  };
  return {
    id: el.id,
    dir: getDir(el),
    orientation: getString(el, "orientation", ["horizontal", "vertical"]),
    panels: [
      { id: "a", minSize: 15 },
      { id: "b", minSize: 15 }
    ],
    defaultSize: [50, 50],
    onResize
  };
}
var SplitterHook = createZagLiveHook({
  key: "splitter",
  mount(hook) {
    return new Splitter(hook.el, splitterProps(hook.el, hook));
  },
  update(hook, inst) {
    inst.updateProps(splitterProps(hook.el, hook));
  }
});
export {
  SplitterHook as Splitter
};
