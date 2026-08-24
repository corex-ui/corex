import {
  trackInteractOutside
} from "./chunk-4F3TQ7OK.mjs";
import {
  addDomEvent,
  contains,
  getComputedStyle,
  getDocument,
  getEventTarget,
  getWindow,
  isHTMLElement,
  nextTick,
  setStyle,
  waitForElement,
  warn,
  whenNode
} from "./chunk-NHD23A5Q.mjs";

// ../node_modules/@zag-js/dismissable/dist/escape-keydown.mjs
function trackEscapeKeydown(node, fn) {
  const handleKeyDown = (event) => {
    if (event.key !== "Escape") return;
    if (event.isComposing) return;
    fn?.(event);
  };
  return addDomEvent(getDocument(node), "keydown", handleKeyDown, { capture: true });
}

// ../node_modules/@zag-js/dismissable/dist/layer-stack.mjs
var LAYER_REQUEST_DISMISS_EVENT = "layer:request-dismiss";
var layerStack = {
  layers: [],
  branches: [],
  recentlyRemoved: /* @__PURE__ */ new Set(),
  count() {
    return this.layers.length;
  },
  pointerBlockingLayers() {
    return this.layers.filter((layer) => layer.pointerBlocking);
  },
  topMostPointerBlockingLayer() {
    return [...this.pointerBlockingLayers()].slice(-1)[0];
  },
  hasPointerBlockingLayer() {
    return this.pointerBlockingLayers().length > 0;
  },
  isBelowPointerBlockingLayer(node) {
    const index = this.indexOf(node);
    const highestBlockingIndex = this.topMostPointerBlockingLayer() ? this.indexOf(this.topMostPointerBlockingLayer()?.node) : -1;
    return index < highestBlockingIndex;
  },
  isTopMost(node) {
    const layer = this.layers[this.count() - 1];
    return layer?.node === node;
  },
  getNestedLayers(node) {
    return Array.from(this.layers).slice(this.indexOf(node) + 1);
  },
  getLayersByType(type) {
    return this.layers.filter((layer) => layer.type === type);
  },
  getNestedLayersByType(node, type) {
    const index = this.indexOf(node);
    if (index === -1) return [];
    return this.layers.slice(index + 1).filter((layer) => layer.type === type);
  },
  getParentLayerOfType(node, type) {
    const index = this.indexOf(node);
    if (index <= 0) return void 0;
    return this.layers.slice(0, index).reverse().find((layer) => layer.type === type);
  },
  countNestedLayersOfType(node, type) {
    return this.getNestedLayersByType(node, type).length;
  },
  isInNestedLayer(node, target) {
    const inNested = this.getNestedLayers(node).some((layer) => contains(layer.node, target));
    if (inNested) return true;
    if (this.recentlyRemoved.size > 0) return true;
    return false;
  },
  isInBranch(target) {
    return Array.from(this.branches).some((branch) => contains(branch, target));
  },
  add(layer) {
    const existingIndex = this.indexOf(layer.node);
    if (existingIndex !== -1) {
      this.layers.splice(existingIndex, 1);
    }
    this.layers.push(layer);
    this.syncLayers();
  },
  addBranch(node) {
    this.branches.push(node);
  },
  remove(node) {
    const index = this.indexOf(node);
    if (index < 0) return;
    const layer = this.layers[index];
    layer.styleTargets?.forEach((getTarget) => {
      const target = getTarget();
      if (target) {
        clearLayerStyleMirror(target);
      }
    });
    this.recentlyRemoved.add(node);
    nextTick(() => this.recentlyRemoved.delete(node));
    if (index < this.count() - 1) {
      const _layers = this.getNestedLayers(node);
      _layers.forEach((layer2) => layerStack.dismiss(layer2.node, node));
    }
    this.layers.splice(index, 1);
    this.syncLayers();
  },
  removeBranch(node) {
    const index = this.branches.indexOf(node);
    if (index >= 0) this.branches.splice(index, 1);
  },
  syncLayers() {
    this.layers.forEach((layer, index) => {
      applyLayerStackMetadata(layer, index, layer.node);
      layer.styleTargets?.forEach((getTarget) => {
        const target = getTarget();
        if (!target || target === layer.node) return;
        applyLayerStackMetadata(layer, index, target);
        const { zIndex } = getComputedStyle(layer.node);
        target.style.setProperty("--z-index", zIndex);
      });
    });
  },
  indexOf(node) {
    return this.layers.findIndex((layer) => layer.node === node);
  },
  dismiss(node, parent) {
    const index = this.indexOf(node);
    if (index === -1) return;
    const layer = this.layers[index];
    addListenerOnce(node, LAYER_REQUEST_DISMISS_EVENT, (event) => {
      layer.requestDismiss?.(event);
      if (!event.defaultPrevented) {
        layer?.dismiss();
      }
    });
    fireCustomEvent(node, LAYER_REQUEST_DISMISS_EVENT, {
      originalLayer: node,
      targetLayer: parent,
      originalIndex: index,
      targetIndex: parent ? this.indexOf(parent) : -1
    });
    this.syncLayers();
  },
  clear() {
    this.remove(this.layers[0].node);
  }
};
function applyLayerStackMetadata(layer, index, el) {
  el.style.setProperty("--layer-index", `${index}`);
  el.removeAttribute("data-nested");
  el.removeAttribute("data-has-nested");
  const parentOfSameType = layerStack.getParentLayerOfType(layer.node, layer.type);
  if (parentOfSameType) {
    el.setAttribute("data-nested", layer.type);
  }
  const nestedCount = layerStack.countNestedLayersOfType(layer.node, layer.type);
  if (nestedCount > 0) {
    el.setAttribute("data-has-nested", layer.type);
  }
  el.style.setProperty("--nested-layer-count", `${nestedCount}`);
}
function clearLayerStyleMirror(el) {
  el.style.removeProperty("--layer-index");
  el.style.removeProperty("--nested-layer-count");
  el.style.removeProperty("--z-index");
  el.removeAttribute("data-nested");
  el.removeAttribute("data-has-nested");
}
function fireCustomEvent(el, type, detail) {
  const win = el.ownerDocument.defaultView || window;
  const event = new win.CustomEvent(type, { cancelable: true, bubbles: true, detail });
  return el.dispatchEvent(event);
}
function addListenerOnce(el, type, callback) {
  el.addEventListener(type, callback, { once: true });
}

// ../node_modules/@zag-js/dismissable/dist/pointer-event-outside.mjs
var originalBodyPointerEvents = /* @__PURE__ */ new WeakMap();
var layerObservers = /* @__PURE__ */ new WeakMap();
function getDesiredPointerEvents(node) {
  return layerStack.isBelowPointerBlockingLayer(node) ? "none" : "auto";
}
function applyPointerEvents(node) {
  const desired = getDesiredPointerEvents(node);
  if (node.style.pointerEvents !== desired) {
    node.style.pointerEvents = desired;
  }
}
function ensurePointerEventsObserver(node) {
  if (layerObservers.has(node)) return;
  const win = getWindow(node);
  if (typeof win.MutationObserver === "undefined") return;
  const observer = new win.MutationObserver(() => {
    if (!layerObservers.has(node)) return;
    applyPointerEvents(node);
  });
  observer.observe(node, { attributes: true, attributeFilter: ["style"] });
  layerObservers.set(node, observer);
}
function assignPointerEventToLayers() {
  layerStack.layers.forEach(({ node }) => {
    applyPointerEvents(node);
    ensurePointerEventsObserver(node);
  });
}
function clearPointerEvent(node) {
  const observer = layerObservers.get(node);
  if (observer) {
    observer.disconnect();
    layerObservers.delete(node);
  }
  node.style.pointerEvents = "";
}
function disablePointerEventsOutside(node, persistentElements) {
  const doc = getDocument(node);
  const cleanups = [];
  if (layerStack.hasPointerBlockingLayer() && !doc.body.hasAttribute("data-inert")) {
    originalBodyPointerEvents.set(doc.body, doc.body.style.pointerEvents);
    queueMicrotask(() => {
      const body = doc.body;
      if (!body) return;
      body.style.pointerEvents = "none";
      body.setAttribute("data-inert", "");
    });
  }
  persistentElements?.forEach((el) => {
    const [promise, abort] = waitForElement(
      () => {
        const node2 = el();
        return isHTMLElement(node2) ? node2 : null;
      },
      { timeout: 1e3 }
    );
    promise.then((el2) => cleanups.push(setStyle(el2, { pointerEvents: "auto" })));
    cleanups.push(abort);
  });
  return () => {
    if (layerStack.hasPointerBlockingLayer()) return;
    queueMicrotask(() => {
      const body = doc.body;
      if (!body) return;
      const original = originalBodyPointerEvents.get(body);
      if (original !== void 0) {
        body.style.pointerEvents = original;
        originalBodyPointerEvents.delete(body);
      }
      body.removeAttribute("data-inert");
      if (body.style.length === 0) body.removeAttribute("style");
    });
    cleanups.forEach((fn) => fn());
  };
}

// ../node_modules/@zag-js/dismissable/dist/dismissable-layer.mjs
function trackDismissableElementImpl(node, options) {
  const {
    onDismiss,
    onRequestDismiss,
    pointerBlocking,
    exclude: excludeContainers,
    debug,
    type = "dialog",
    layerStyleTargets
  } = options;
  const layer = {
    dismiss: onDismiss,
    node,
    type,
    pointerBlocking,
    requestDismiss: onRequestDismiss,
    styleTargets: layerStyleTargets
  };
  layerStack.add(layer);
  assignPointerEventToLayers();
  function onPointerDownOutside(event) {
    const target = getEventTarget(event.detail.originalEvent);
    if (layerStack.isBelowPointerBlockingLayer(node) || layerStack.isInBranch(target)) return;
    options.onPointerDownOutside?.(event);
    options.onInteractOutside?.(event);
    if (event.defaultPrevented) return;
    if (debug) {
      console.log("onPointerDownOutside:", event.detail.originalEvent);
    }
    onDismiss?.();
  }
  function onFocusOutside(event) {
    const target = getEventTarget(event.detail.originalEvent);
    if (layerStack.isInBranch(target)) return;
    options.onFocusOutside?.(event);
    options.onInteractOutside?.(event);
    if (event.defaultPrevented) return;
    if (debug) {
      console.log("onFocusOutside:", event.detail.originalEvent);
    }
    onDismiss?.();
  }
  function onEscapeKeyDown(event) {
    if (!layerStack.isTopMost(node)) return;
    options.onEscapeKeyDown?.(event);
    if (!event.defaultPrevented && onDismiss) {
      event.preventDefault();
      onDismiss();
    }
  }
  function exclude(target) {
    const containers = typeof excludeContainers === "function" ? excludeContainers() : excludeContainers;
    const _containers = Array.isArray(containers) ? containers : [containers];
    const persistentElements = options.persistentElements?.map((fn) => fn()).filter(isHTMLElement);
    if (persistentElements) _containers.push(...persistentElements);
    return _containers.some((node2) => contains(node2, target)) || layerStack.isInNestedLayer(node, target);
  }
  const cleanups = [
    pointerBlocking ? disablePointerEventsOutside(node, options.persistentElements) : void 0,
    trackEscapeKeydown(node, onEscapeKeyDown),
    trackInteractOutside(node, { exclude, onFocusOutside, onPointerDownOutside, defer: options.defer })
  ];
  return () => {
    layerStack.remove(node);
    assignPointerEventToLayers();
    clearPointerEvent(node);
    cleanups.forEach((fn) => fn?.());
  };
}
function trackDismissableElement(nodeOrFn, options) {
  const { warnOnMissingNode = true } = options;
  return whenNode(nodeOrFn, (node) => trackDismissableElementImpl(node, options), {
    defer: options.defer,
    onMissing: warnOnMissingNode ? () => warn("[@zag-js/dismissable] node is `null` or `undefined`") : void 0
  });
}
function trackDismissableBranch(nodeOrFn, options = {}) {
  return whenNode(
    nodeOrFn,
    (node) => {
      layerStack.addBranch(node);
      return () => {
        layerStack.removeBranch(node);
      };
    },
    {
      defer: options.defer,
      onMissing: () => warn("[@zag-js/dismissable] branch node is `null` or `undefined`")
    }
  );
}

export {
  trackDismissableElement,
  trackDismissableBranch
};
