import {
  trackDismissableElement
} from "./chunk-RR7TJIQ5.mjs";
import "./chunk-ER3INIAI.mjs";
import {
  Component,
  VanillaMachine,
  addDomEvent,
  createAnatomy,
  createMachine,
  createProps,
  createSplitProps,
  findControlledElements,
  getActiveElement,
  getBoolean,
  getComputedStyle,
  getControlledElements,
  getDocument,
  getEventTarget,
  getFocusables,
  getString,
  getTabIndex,
  getTabbables,
  hasControllerElements,
  isControlledByExpandedController,
  isControlledElement,
  isDocument,
  isFocusable,
  isHTMLElement,
  isIos,
  isTabbable,
  normalizeProps,
  raf,
  setStyle,
  setStyleProperty
} from "./chunk-IXOYOLUJ.mjs";

// ../node_modules/.pnpm/@zag-js+aria-hidden@1.33.1/node_modules/@zag-js/aria-hidden/dist/index.mjs
var counterMap = /* @__PURE__ */ new WeakMap();
var uncontrolledNodes = /* @__PURE__ */ new WeakMap();
var markerMap = {};
var lockCount = 0;
var unwrapHost = (node) => node && (node.host || unwrapHost(node.parentNode));
var correctTargets = (parent, targets) => targets.map((target) => {
  if (parent.contains(target)) return target;
  const correctedTarget = unwrapHost(target);
  if (correctedTarget && parent.contains(correctedTarget)) {
    return correctedTarget;
  }
  console.error("[zag-js > ariaHidden] target", target, "in not contained inside", parent, ". Doing nothing");
  return null;
}).filter((x) => Boolean(x));
var ignoreableNodes = /* @__PURE__ */ new Set(["script", "output", "status", "next-route-announcer"]);
var isIgnoredNode = (node) => {
  if (ignoreableNodes.has(node.localName)) return true;
  if (node.role === "status") return true;
  if (node.hasAttribute("aria-live")) return true;
  return node.matches("[data-live-announcer]");
};
var walkTreeOutside = (originalTarget, props2) => {
  const { parentNode, markerName, controlAttribute, followControlledElements = true } = props2;
  const targets = correctTargets(parentNode, Array.isArray(originalTarget) ? originalTarget : [originalTarget]);
  markerMap[markerName] || (markerMap[markerName] = /* @__PURE__ */ new WeakMap());
  const markerCounter = markerMap[markerName];
  const hiddenNodes = [];
  const elementsToKeep = /* @__PURE__ */ new Set();
  const elementsToStop = new Set(targets);
  const keep = (el) => {
    if (!el || elementsToKeep.has(el)) return;
    elementsToKeep.add(el);
    keep(el.parentNode);
  };
  targets.forEach((target) => {
    keep(target);
    if (followControlledElements && isHTMLElement(target)) {
      findControlledElements(target, (controlledElement) => {
        keep(controlledElement);
      });
    }
  });
  const deep = (parent) => {
    if (!parent || elementsToStop.has(parent)) {
      return;
    }
    Array.prototype.forEach.call(parent.children, (node) => {
      if (elementsToKeep.has(node)) {
        deep(node);
      } else {
        try {
          if (isIgnoredNode(node)) return;
          const attr = node.getAttribute(controlAttribute);
          const alreadyHidden = attr === "true";
          const counterValue = (counterMap.get(node) || 0) + 1;
          const markerValue = (markerCounter.get(node) || 0) + 1;
          counterMap.set(node, counterValue);
          markerCounter.set(node, markerValue);
          hiddenNodes.push(node);
          if (counterValue === 1 && alreadyHidden) {
            uncontrolledNodes.set(node, true);
          }
          if (markerValue === 1) {
            node.setAttribute(markerName, "");
          }
          if (!alreadyHidden) {
            node.setAttribute(controlAttribute, "true");
          }
        } catch (e) {
          console.error("[zag-js > ariaHidden] cannot operate on ", node, e);
        }
      }
    });
  };
  deep(parentNode);
  elementsToKeep.clear();
  lockCount++;
  return () => {
    hiddenNodes.forEach((node) => {
      const counterValue = counterMap.get(node) - 1;
      const markerValue = markerCounter.get(node) - 1;
      counterMap.set(node, counterValue);
      markerCounter.set(node, markerValue);
      if (!counterValue) {
        if (!uncontrolledNodes.has(node)) {
          node.removeAttribute(controlAttribute);
        }
        uncontrolledNodes.delete(node);
      }
      if (!markerValue) {
        node.removeAttribute(markerName);
      }
    });
    lockCount--;
    if (!lockCount) {
      counterMap = /* @__PURE__ */ new WeakMap();
      counterMap = /* @__PURE__ */ new WeakMap();
      uncontrolledNodes = /* @__PURE__ */ new WeakMap();
      markerMap = {};
    }
  };
};
var getParentNode = (originalTarget) => {
  const target = Array.isArray(originalTarget) ? originalTarget[0] : originalTarget;
  return target.ownerDocument.body;
};
var hideOthers = (originalTarget, parentNode = getParentNode(originalTarget), markerName = "data-aria-hidden", followControlledElements = true) => {
  if (!parentNode) return;
  return walkTreeOutside(originalTarget, {
    parentNode,
    markerName,
    controlAttribute: "aria-hidden",
    followControlledElements
  });
};
var raf2 = (fn) => {
  const frameId = requestAnimationFrame(() => fn());
  return () => cancelAnimationFrame(frameId);
};
function ariaHidden(targetsOrFn, options = {}) {
  const { defer = true } = options;
  const func = defer ? raf2 : (v) => v();
  const cleanups = [];
  cleanups.push(
    func(() => {
      const targets = typeof targetsOrFn === "function" ? targetsOrFn() : targetsOrFn;
      const elements = targets.filter(Boolean);
      if (elements.length === 0) return;
      cleanups.push(hideOthers(elements));
    })
  );
  return () => {
    cleanups.forEach((fn) => fn?.());
  };
}

// ../node_modules/.pnpm/@zag-js+focus-trap@1.33.1/node_modules/@zag-js/focus-trap/dist/index.mjs
var __defProp = Object.defineProperty;
var __defNormalProp = (obj, key, value) => key in obj ? __defProp(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
var __publicField = (obj, key, value) => __defNormalProp(obj, typeof key !== "symbol" ? key + "" : key, value);
var activeFocusTraps = {
  activateTrap(trapStack, trap) {
    if (trapStack.length > 0) {
      const activeTrap = trapStack[trapStack.length - 1];
      if (activeTrap !== trap) {
        activeTrap.pause();
      }
    }
    const trapIndex = trapStack.indexOf(trap);
    if (trapIndex === -1) {
      trapStack.push(trap);
    } else {
      trapStack.splice(trapIndex, 1);
      trapStack.push(trap);
    }
  },
  deactivateTrap(trapStack, trap) {
    const trapIndex = trapStack.indexOf(trap);
    if (trapIndex !== -1) {
      trapStack.splice(trapIndex, 1);
    }
    if (trapStack.length > 0) {
      trapStack[trapStack.length - 1].unpause();
    }
  }
};
var sharedTrapStack = [];
var FocusTrap = class {
  constructor(elements, options) {
    __publicField(this, "trapStack");
    __publicField(this, "config");
    __publicField(this, "doc");
    __publicField(this, "state", {
      containers: [],
      containerGroups: [],
      tabbableGroups: [],
      nodeFocusedBeforeActivation: null,
      mostRecentlyFocusedNode: null,
      active: false,
      paused: false,
      delayInitialFocusTimer: void 0,
      recentNavEvent: void 0
    });
    __publicField(this, "portalContainers", /* @__PURE__ */ new Set());
    __publicField(this, "listenerCleanups", []);
    __publicField(this, "handleFocus", (event) => {
      const target = getEventTarget(event);
      const targetContained = this.findContainerIndex(target, event) >= 0;
      if (targetContained || isDocument(target)) {
        if (targetContained) {
          this.state.mostRecentlyFocusedNode = target;
        }
      } else {
        event.stopImmediatePropagation();
        let nextNode;
        let navAcrossContainers = true;
        if (this.state.mostRecentlyFocusedNode) {
          if (getTabIndex(this.state.mostRecentlyFocusedNode) > 0) {
            const mruContainerIdx = this.findContainerIndex(this.state.mostRecentlyFocusedNode);
            const { tabbableNodes } = this.state.containerGroups[mruContainerIdx];
            if (tabbableNodes.length > 0) {
              const mruTabIdx = tabbableNodes.findIndex((node) => node === this.state.mostRecentlyFocusedNode);
              if (mruTabIdx >= 0) {
                if (this.config.isKeyForward(this.state.recentNavEvent)) {
                  if (mruTabIdx + 1 < tabbableNodes.length) {
                    nextNode = tabbableNodes[mruTabIdx + 1];
                    navAcrossContainers = false;
                  }
                } else {
                  if (mruTabIdx - 1 >= 0) {
                    nextNode = tabbableNodes[mruTabIdx - 1];
                    navAcrossContainers = false;
                  }
                }
              }
            }
          } else {
            if (!this.state.containerGroups.some((g) => g.tabbableNodes.some((n) => getTabIndex(n) > 0))) {
              navAcrossContainers = false;
            }
          }
        } else {
          navAcrossContainers = false;
        }
        if (navAcrossContainers) {
          nextNode = this.findNextNavNode({
            // move FROM the MRU node, not event-related node (which will be the node that is
            //  outside the trap causing the focus escape we're trying to fix)
            target: this.state.mostRecentlyFocusedNode,
            isBackward: this.config.isKeyBackward(this.state.recentNavEvent)
          });
        }
        if (nextNode) {
          this.tryFocus(nextNode);
        } else {
          this.tryFocus(this.state.mostRecentlyFocusedNode || this.getInitialFocusNode());
        }
      }
      this.state.recentNavEvent = void 0;
    });
    __publicField(this, "handlePointerDown", (event) => {
      const target = getEventTarget(event);
      if (this.findContainerIndex(target, event) >= 0) {
        return;
      }
      if (valueOrHandler(this.config.clickOutsideDeactivates, event)) {
        this.deactivate({ returnFocus: this.config.returnFocusOnDeactivate });
        return;
      }
      if (valueOrHandler(this.config.allowOutsideClick, event)) {
        return;
      }
      event.preventDefault();
    });
    __publicField(this, "handleClick", (event) => {
      const target = getEventTarget(event);
      if (this.findContainerIndex(target, event) >= 0) {
        return;
      }
      if (valueOrHandler(this.config.clickOutsideDeactivates, event)) {
        return;
      }
      if (valueOrHandler(this.config.allowOutsideClick, event)) {
        return;
      }
      event.preventDefault();
      event.stopImmediatePropagation();
    });
    __publicField(this, "handleTabKey", (event) => {
      if (this.config.isKeyForward(event) || this.config.isKeyBackward(event)) {
        this.state.recentNavEvent = event;
        const isBackward = this.config.isKeyBackward(event);
        const destinationNode = this.findNextNavNode({ event, isBackward });
        if (!destinationNode) return;
        if (isTabEvent(event)) {
          event.preventDefault();
        }
        this.tryFocus(destinationNode);
      }
    });
    __publicField(this, "handleEscapeKey", (event) => {
      if (isEscapeEvent(event) && valueOrHandler(this.config.escapeDeactivates, event) !== false) {
        event.preventDefault();
        this.deactivate();
      }
    });
    __publicField(this, "_mutationObserver");
    __publicField(this, "setupMutationObserver", () => {
      const win = this.doc.defaultView || window;
      this._mutationObserver = new win.MutationObserver((mutations) => {
        const isFocusedNodeRemoved = mutations.some((mutation) => {
          const removedNodes = Array.from(mutation.removedNodes);
          return removedNodes.some((node) => node === this.state.mostRecentlyFocusedNode);
        });
        if (isFocusedNodeRemoved) {
          this.tryFocus(this.getInitialFocusNode());
        }
        const hasControlledChanges = mutations.some((mutation) => {
          if (mutation.type === "attributes" && (mutation.attributeName === "aria-controls" || mutation.attributeName === "aria-expanded")) {
            return true;
          }
          if (mutation.type === "childList" && mutation.addedNodes.length > 0) {
            return Array.from(mutation.addedNodes).some((node) => {
              if (node.nodeType !== Node.ELEMENT_NODE) return false;
              const element = node;
              if (hasControllerElements(element)) {
                return true;
              }
              if (element.id && !this.state.containers.some((c) => c.contains(element))) {
                return isControlledByExpandedController(element);
              }
              return false;
            });
          }
          return false;
        });
        if (hasControlledChanges && this.state.active && !this.state.paused) {
          this.updateTabbableNodes();
          this.updatePortalContainers();
        }
      });
    });
    __publicField(this, "updateObservedNodes", () => {
      this._mutationObserver?.disconnect();
      if (this.state.active && !this.state.paused) {
        this.state.containers.map((container) => {
          this._mutationObserver?.observe(container, {
            subtree: true,
            childList: true,
            attributes: true,
            attributeFilter: ["aria-controls", "aria-expanded"]
          });
        });
        this.portalContainers.forEach((portalContainer) => {
          this.observePortalContainer(portalContainer);
        });
      }
    });
    __publicField(this, "getInitialFocusNode", () => {
      let node = this.getNodeForOption("initialFocus", { hasFallback: true });
      if (node === false) {
        return false;
      }
      if (node === void 0 || node && !isFocusable(node)) {
        const activeElement = getActiveElement(this.doc);
        if (activeElement && this.findContainerIndex(activeElement) >= 0) {
          node = activeElement;
        } else {
          const firstTabbableGroup = this.state.tabbableGroups[0];
          const firstTabbableNode = firstTabbableGroup && firstTabbableGroup.firstTabbableNode;
          node = firstTabbableNode || this.getNodeForOption("fallbackFocus");
        }
      } else if (node === null) {
        node = this.getNodeForOption("fallbackFocus");
      }
      if (!node) {
        throw new Error("Your focus-trap needs to have at least one focusable element");
      }
      if (!node.isConnected) {
        node = this.getNodeForOption("fallbackFocus");
      }
      return node;
    });
    __publicField(this, "tryFocus", (node) => {
      if (node === false) return;
      if (node === getActiveElement(this.doc)) return;
      if (!node || !node.focus) {
        this.tryFocus(this.getInitialFocusNode());
        return;
      }
      node.focus({ preventScroll: !!this.config.preventScroll });
      this.state.mostRecentlyFocusedNode = node;
      if (isSelectableInput(node)) {
        node.select();
      }
    });
    __publicField(this, "deactivate", (deactivateOptions) => {
      if (!this.state.active) return this;
      const options2 = {
        onDeactivate: this.config.onDeactivate,
        onPostDeactivate: this.config.onPostDeactivate,
        checkCanReturnFocus: this.config.checkCanReturnFocus,
        ...deactivateOptions
      };
      clearTimeout(this.state.delayInitialFocusTimer);
      this.state.delayInitialFocusTimer = void 0;
      this.removeListeners();
      this.state.active = false;
      this.state.paused = false;
      this.updateObservedNodes();
      activeFocusTraps.deactivateTrap(this.trapStack, this);
      this.portalContainers.clear();
      const onDeactivate = this.getOption(options2, "onDeactivate");
      const onPostDeactivate = this.getOption(options2, "onPostDeactivate");
      const checkCanReturnFocus = this.getOption(options2, "checkCanReturnFocus");
      const returnFocus = this.getOption(options2, "returnFocus", "returnFocusOnDeactivate");
      onDeactivate?.();
      const finishDeactivation = () => {
        delay(() => {
          if (returnFocus) {
            const returnFocusNode = this.getReturnFocusNode(this.state.nodeFocusedBeforeActivation);
            this.tryFocus(returnFocusNode);
          }
          onPostDeactivate?.();
        });
      };
      if (returnFocus && checkCanReturnFocus) {
        const returnFocusNode = this.getReturnFocusNode(this.state.nodeFocusedBeforeActivation);
        checkCanReturnFocus(returnFocusNode).then(finishDeactivation, finishDeactivation);
        return this;
      }
      finishDeactivation();
      return this;
    });
    __publicField(this, "pause", (pauseOptions) => {
      if (this.state.paused || !this.state.active) {
        return this;
      }
      const onPause = this.getOption(pauseOptions, "onPause");
      const onPostPause = this.getOption(pauseOptions, "onPostPause");
      this.state.paused = true;
      onPause?.();
      this.removeListeners();
      this.updateObservedNodes();
      onPostPause?.();
      return this;
    });
    __publicField(this, "unpause", (unpauseOptions) => {
      if (!this.state.paused || !this.state.active) {
        return this;
      }
      const onUnpause = this.getOption(unpauseOptions, "onUnpause");
      const onPostUnpause = this.getOption(unpauseOptions, "onPostUnpause");
      this.state.paused = false;
      onUnpause?.();
      this.updateTabbableNodes();
      this.addListeners();
      this.updateObservedNodes();
      onPostUnpause?.();
      return this;
    });
    __publicField(this, "updateContainerElements", (containerElements) => {
      this.state.containers = Array.isArray(containerElements) ? containerElements.filter(Boolean) : [containerElements].filter(Boolean);
      if (this.state.active) {
        this.updateTabbableNodes();
      }
      this.updateObservedNodes();
      return this;
    });
    __publicField(this, "getReturnFocusNode", (previousActiveElement) => {
      const node = this.getNodeForOption("setReturnFocus", {
        params: [previousActiveElement]
      });
      return node ? node : node === false ? false : previousActiveElement;
    });
    __publicField(this, "getOption", (configOverrideOptions, optionName, configOptionName) => {
      return configOverrideOptions && configOverrideOptions[optionName] !== void 0 ? configOverrideOptions[optionName] : (
        // @ts-expect-error
        this.config[configOptionName || optionName]
      );
    });
    __publicField(this, "getNodeForOption", (optionName, { hasFallback = false, params = [] } = {}) => {
      let optionValue = this.config[optionName];
      if (typeof optionValue === "function") optionValue = optionValue(...params);
      if (optionValue === true) optionValue = void 0;
      if (!optionValue) {
        if (optionValue === void 0 || optionValue === false) {
          return optionValue;
        }
        throw new Error(`\`${optionName}\` was specified but was not a node, or did not return a node`);
      }
      let node = optionValue;
      if (typeof optionValue === "string") {
        try {
          node = this.doc.querySelector(optionValue);
        } catch (err) {
          throw new Error(`\`${optionName}\` appears to be an invalid selector; error="${err.message}"`);
        }
        if (!node) {
          if (!hasFallback) {
            throw new Error(`\`${optionName}\` as selector refers to no known node`);
          }
        }
      }
      return node;
    });
    __publicField(this, "findNextNavNode", (opts) => {
      const { event, isBackward = false } = opts;
      const target = opts.target || getEventTarget(event);
      this.updateTabbableNodes();
      let destinationNode = null;
      if (this.state.tabbableGroups.length > 0) {
        const containerIndex = this.findContainerIndex(target, event);
        const containerGroup = containerIndex >= 0 ? this.state.containerGroups[containerIndex] : void 0;
        if (containerIndex < 0) {
          if (isBackward) {
            destinationNode = this.state.tabbableGroups[this.state.tabbableGroups.length - 1].lastTabbableNode;
          } else {
            destinationNode = this.state.tabbableGroups[0].firstTabbableNode;
          }
        } else if (isBackward) {
          let startOfGroupIndex = this.state.tabbableGroups.findIndex(
            ({ firstTabbableNode }) => target === firstTabbableNode
          );
          if (startOfGroupIndex < 0 && (containerGroup?.container === target || isFocusable(target) && !isTabbable(target) && !containerGroup?.nextTabbableNode(target, false))) {
            startOfGroupIndex = containerIndex;
          }
          if (startOfGroupIndex >= 0) {
            const destinationGroupIndex = startOfGroupIndex === 0 ? this.state.tabbableGroups.length - 1 : startOfGroupIndex - 1;
            const destinationGroup = this.state.tabbableGroups[destinationGroupIndex];
            destinationNode = getTabIndex(target) >= 0 ? destinationGroup.lastTabbableNode : destinationGroup.lastDomTabbableNode;
          } else if (!isTabEvent(event)) {
            destinationNode = containerGroup?.nextTabbableNode(target, false);
          }
        } else {
          let lastOfGroupIndex = this.state.tabbableGroups.findIndex(
            ({ lastTabbableNode }) => target === lastTabbableNode
          );
          if (lastOfGroupIndex < 0 && (containerGroup?.container === target || isFocusable(target) && !isTabbable(target) && !containerGroup?.nextTabbableNode(target))) {
            lastOfGroupIndex = containerIndex;
          }
          if (lastOfGroupIndex >= 0) {
            const destinationGroupIndex = lastOfGroupIndex === this.state.tabbableGroups.length - 1 ? 0 : lastOfGroupIndex + 1;
            const destinationGroup = this.state.tabbableGroups[destinationGroupIndex];
            destinationNode = getTabIndex(target) >= 0 ? destinationGroup.firstTabbableNode : destinationGroup.firstDomTabbableNode;
          } else if (!isTabEvent(event)) {
            destinationNode = containerGroup?.nextTabbableNode(target);
          }
        }
      } else {
        destinationNode = this.getNodeForOption("fallbackFocus");
      }
      return destinationNode;
    });
    this.trapStack = options.trapStack || sharedTrapStack;
    const config = {
      returnFocusOnDeactivate: true,
      escapeDeactivates: true,
      delayInitialFocus: true,
      followControlledElements: true,
      isKeyForward,
      isKeyBackward,
      ...options
    };
    this.doc = config.document || getDocument(Array.isArray(elements) ? elements[0] : elements);
    this.config = config;
    this.updateContainerElements(elements);
    this.setupMutationObserver();
  }
  addPortalContainer(controlledElement) {
    const portalContainer = controlledElement.parentElement;
    if (portalContainer && !this.portalContainers.has(portalContainer)) {
      this.portalContainers.add(portalContainer);
      if (this.state.active && !this.state.paused) {
        this.observePortalContainer(portalContainer);
      }
    }
  }
  observePortalContainer(portalContainer) {
    this._mutationObserver?.observe(portalContainer, {
      subtree: true,
      childList: true,
      attributes: true,
      attributeFilter: ["aria-controls", "aria-expanded"]
    });
  }
  updatePortalContainers() {
    if (!this.config.followControlledElements) return;
    this.state.containers.forEach((container) => {
      const controlledElements = getControlledElements(container);
      controlledElements.forEach((controlledElement) => {
        this.addPortalContainer(controlledElement);
      });
    });
  }
  get active() {
    return this.state.active;
  }
  get paused() {
    return this.state.paused;
  }
  findContainerIndex(element, event) {
    const composedPath = typeof event?.composedPath === "function" ? event.composedPath() : void 0;
    return this.state.containerGroups.findIndex(
      ({ container, tabbableNodes }) => container.contains(element) || composedPath?.includes(container) || tabbableNodes.find((node) => node === element) || this.isControlledElement(container, element)
    );
  }
  isControlledElement(container, element) {
    if (!this.config.followControlledElements) return false;
    return isControlledElement(container, element);
  }
  updateTabbableNodes() {
    this.state.containerGroups = this.state.containers.map((container) => {
      const tabbableNodes = getTabbables(container, { getShadowRoot: this.config.getShadowRoot });
      const focusableNodes = getFocusables(container, { getShadowRoot: this.config.getShadowRoot });
      const firstTabbableNode = tabbableNodes[0];
      const lastTabbableNode = tabbableNodes[tabbableNodes.length - 1];
      const firstDomTabbableNode = firstTabbableNode;
      const lastDomTabbableNode = lastTabbableNode;
      let posTabIndexesFound = false;
      for (let i = 0; i < tabbableNodes.length; i++) {
        if (getTabIndex(tabbableNodes[i]) > 0) {
          posTabIndexesFound = true;
          break;
        }
      }
      function nextTabbableNode(node, forward = true) {
        const nodeIdx = tabbableNodes.indexOf(node);
        if (nodeIdx >= 0) {
          return tabbableNodes[nodeIdx + (forward ? 1 : -1)];
        }
        const focusableIdx = focusableNodes.indexOf(node);
        if (focusableIdx < 0) return void 0;
        if (forward) {
          for (let i = focusableIdx + 1; i < focusableNodes.length; i++) {
            if (isTabbable(focusableNodes[i])) return focusableNodes[i];
          }
        } else {
          for (let i = focusableIdx - 1; i >= 0; i--) {
            if (isTabbable(focusableNodes[i])) return focusableNodes[i];
          }
        }
        return void 0;
      }
      return {
        container,
        tabbableNodes,
        focusableNodes,
        posTabIndexesFound,
        firstTabbableNode,
        lastTabbableNode,
        firstDomTabbableNode,
        lastDomTabbableNode,
        nextTabbableNode
      };
    });
    this.state.tabbableGroups = this.state.containerGroups.filter((group) => group.tabbableNodes.length > 0);
    if (this.state.tabbableGroups.length <= 0 && !this.getNodeForOption("fallbackFocus")) {
      throw new Error(
        "Your focus-trap must have at least one container with at least one tabbable node in it at all times"
      );
    }
    if (this.state.containerGroups.find((g) => g.posTabIndexesFound) && this.state.containerGroups.length > 1) {
      throw new Error(
        "At least one node with a positive tabindex was found in one of your focus-trap's multiple containers. Positive tabindexes are only supported in single-container focus-traps."
      );
    }
  }
  addListeners() {
    if (!this.state.active) return;
    activeFocusTraps.activateTrap(this.trapStack, this);
    this.state.delayInitialFocusTimer = this.config.delayInitialFocus ? delay(() => {
      this.tryFocus(this.getInitialFocusNode());
    }) : this.tryFocus(this.getInitialFocusNode());
    this.listenerCleanups.push(
      addDomEvent(this.doc, "focusin", this.handleFocus, true),
      addDomEvent(this.doc, "mousedown", this.handlePointerDown, { capture: true, passive: false }),
      addDomEvent(this.doc, "touchstart", this.handlePointerDown, { capture: true, passive: false }),
      addDomEvent(this.doc, "click", this.handleClick, { capture: true, passive: false }),
      addDomEvent(this.doc, "keydown", this.handleTabKey, { capture: true, passive: false }),
      addDomEvent(this.doc, "keydown", this.handleEscapeKey)
    );
    return this;
  }
  removeListeners() {
    if (!this.state.active) return;
    this.listenerCleanups.forEach((cleanup) => cleanup());
    this.listenerCleanups = [];
    return this;
  }
  activate(activateOptions) {
    if (this.state.active) {
      return this;
    }
    const onActivate = this.getOption(activateOptions, "onActivate");
    const onPostActivate = this.getOption(activateOptions, "onPostActivate");
    const checkCanFocusTrap = this.getOption(activateOptions, "checkCanFocusTrap");
    if (!checkCanFocusTrap) {
      this.updateTabbableNodes();
    }
    this.state.active = true;
    this.state.paused = false;
    this.state.nodeFocusedBeforeActivation = getActiveElement(this.doc);
    onActivate?.();
    const finishActivation = () => {
      if (checkCanFocusTrap) {
        this.updateTabbableNodes();
      }
      this.addListeners();
      this.updateObservedNodes();
      onPostActivate?.();
    };
    if (checkCanFocusTrap) {
      checkCanFocusTrap(this.state.containers.concat()).then(finishActivation, finishActivation);
      return this;
    }
    finishActivation();
    return this;
  }
};
var isKeyboardEvent = (event) => event.type === "keydown";
var isTabEvent = (event) => isKeyboardEvent(event) && event?.key === "Tab";
var isKeyForward = (e) => isKeyboardEvent(e) && e.key === "Tab" && !e?.shiftKey;
var isKeyBackward = (e) => isKeyboardEvent(e) && e.key === "Tab" && e?.shiftKey;
var valueOrHandler = (value, ...params) => typeof value === "function" ? value(...params) : value;
var isEscapeEvent = (event) => !event.isComposing && event.key === "Escape";
var delay = (fn) => setTimeout(fn, 0);
var isSelectableInput = (node) => node.localName === "input" && "select" in node && typeof node.select === "function";
function trapFocus(el, options = {}) {
  let trap;
  const cleanup = raf(() => {
    const elements = Array.isArray(el) ? el : [el];
    const resolvedElements = elements.map((e) => typeof e === "function" ? e() : e).filter((e) => e != null);
    if (resolvedElements.length === 0) return;
    const primaryEl = resolvedElements[0];
    trap = new FocusTrap(resolvedElements, {
      escapeDeactivates: false,
      allowOutsideClick: true,
      preventScroll: true,
      returnFocusOnDeactivate: true,
      delayInitialFocus: false,
      fallbackFocus: primaryEl,
      ...options,
      document: getDocument(primaryEl)
    });
    try {
      trap.activate();
    } catch {
    }
  });
  return function destroy() {
    trap?.deactivate();
    cleanup();
  };
}

// ../node_modules/.pnpm/@zag-js+remove-scroll@1.33.1/node_modules/@zag-js/remove-scroll/dist/index.mjs
var LOCK_CLASSNAME = "data-scroll-lock";
function getPaddingProperty(documentElement) {
  const documentLeft = documentElement.getBoundingClientRect().left;
  const scrollbarX = Math.round(documentLeft) + documentElement.scrollLeft;
  return scrollbarX ? "paddingLeft" : "paddingRight";
}
function hasStableScrollbarGutter(element) {
  const styles = getComputedStyle(element);
  const scrollbarGutter = styles?.scrollbarGutter;
  return scrollbarGutter === "stable" || scrollbarGutter?.startsWith("stable ") === true;
}
function preventBodyScroll(_document) {
  const doc = _document ?? document;
  const win = doc.defaultView ?? window;
  const { documentElement, body } = doc;
  const locked = body.hasAttribute(LOCK_CLASSNAME);
  if (locked) return;
  const hasStableGutter = hasStableScrollbarGutter(documentElement) || hasStableScrollbarGutter(body);
  const scrollbarWidth = win.innerWidth - documentElement.clientWidth;
  body.setAttribute(LOCK_CLASSNAME, "");
  const setScrollbarWidthProperty = () => setStyleProperty(documentElement, "--scrollbar-width", `${scrollbarWidth}px`);
  const paddingProperty = getPaddingProperty(documentElement);
  const setBodyStyle = () => {
    const styles = {
      overflow: "hidden"
    };
    if (!hasStableGutter && scrollbarWidth > 0) {
      styles[paddingProperty] = `${scrollbarWidth}px`;
    }
    return setStyle(body, styles);
  };
  const setBodyStyleIOS = () => {
    const { scrollX, scrollY, visualViewport } = win;
    const offsetLeft = visualViewport?.offsetLeft ?? 0;
    const offsetTop = visualViewport?.offsetTop ?? 0;
    const styles = {
      position: "fixed",
      overflow: "hidden",
      top: `${-(scrollY - Math.floor(offsetTop))}px`,
      left: `${-(scrollX - Math.floor(offsetLeft))}px`,
      right: "0"
    };
    if (!hasStableGutter && scrollbarWidth > 0) {
      styles[paddingProperty] = `${scrollbarWidth}px`;
    }
    const restoreStyle = setStyle(body, styles);
    return () => {
      restoreStyle?.();
      win.scrollTo({ left: scrollX, top: scrollY, behavior: "instant" });
    };
  };
  const cleanups = [setScrollbarWidthProperty(), isIos() ? setBodyStyleIOS() : setBodyStyle()];
  return () => {
    cleanups.forEach((fn) => fn?.());
    body.removeAttribute(LOCK_CLASSNAME);
  };
}

// ../node_modules/.pnpm/@zag-js+dialog@1.33.1/node_modules/@zag-js/dialog/dist/index.mjs
var anatomy = createAnatomy("dialog").parts(
  "trigger",
  "backdrop",
  "positioner",
  "content",
  "title",
  "description",
  "closeTrigger"
);
var parts = anatomy.build();
var getPositionerId = (ctx) => ctx.ids?.positioner ?? `dialog:${ctx.id}:positioner`;
var getBackdropId = (ctx) => ctx.ids?.backdrop ?? `dialog:${ctx.id}:backdrop`;
var getContentId = (ctx) => ctx.ids?.content ?? `dialog:${ctx.id}:content`;
var getTriggerId = (ctx) => ctx.ids?.trigger ?? `dialog:${ctx.id}:trigger`;
var getTitleId = (ctx) => ctx.ids?.title ?? `dialog:${ctx.id}:title`;
var getDescriptionId = (ctx) => ctx.ids?.description ?? `dialog:${ctx.id}:description`;
var getCloseTriggerId = (ctx) => ctx.ids?.closeTrigger ?? `dialog:${ctx.id}:close`;
var getContentEl = (ctx) => ctx.getById(getContentId(ctx));
var getPositionerEl = (ctx) => ctx.getById(getPositionerId(ctx));
var getBackdropEl = (ctx) => ctx.getById(getBackdropId(ctx));
var getTriggerEl = (ctx) => ctx.getById(getTriggerId(ctx));
var getTitleEl = (ctx) => ctx.getById(getTitleId(ctx));
var getDescriptionEl = (ctx) => ctx.getById(getDescriptionId(ctx));
var getCloseTriggerEl = (ctx) => ctx.getById(getCloseTriggerId(ctx));
function connect(service, normalize) {
  const { state, send, context, prop, scope } = service;
  const ariaLabel = prop("aria-label");
  const open = state.matches("open");
  return {
    open,
    setOpen(nextOpen) {
      const open2 = state.matches("open");
      if (open2 === nextOpen) return;
      send({ type: nextOpen ? "OPEN" : "CLOSE" });
    },
    getTriggerProps() {
      return normalize.button({
        ...parts.trigger.attrs,
        dir: prop("dir"),
        id: getTriggerId(scope),
        "aria-haspopup": "dialog",
        type: "button",
        "aria-expanded": open,
        "data-state": open ? "open" : "closed",
        "aria-controls": getContentId(scope),
        onClick(event) {
          if (event.defaultPrevented) return;
          send({ type: "TOGGLE" });
        }
      });
    },
    getBackdropProps() {
      return normalize.element({
        ...parts.backdrop.attrs,
        dir: prop("dir"),
        hidden: !open,
        id: getBackdropId(scope),
        "data-state": open ? "open" : "closed"
      });
    },
    getPositionerProps() {
      return normalize.element({
        ...parts.positioner.attrs,
        dir: prop("dir"),
        id: getPositionerId(scope),
        style: {
          pointerEvents: open ? void 0 : "none"
        }
      });
    },
    getContentProps() {
      const rendered = context.get("rendered");
      return normalize.element({
        ...parts.content.attrs,
        dir: prop("dir"),
        role: prop("role"),
        hidden: !open,
        id: getContentId(scope),
        tabIndex: -1,
        "data-state": open ? "open" : "closed",
        "aria-modal": true,
        "aria-label": ariaLabel || void 0,
        "aria-labelledby": ariaLabel || !rendered.title ? void 0 : getTitleId(scope),
        "aria-describedby": rendered.description ? getDescriptionId(scope) : void 0
      });
    },
    getTitleProps() {
      return normalize.element({
        ...parts.title.attrs,
        dir: prop("dir"),
        id: getTitleId(scope)
      });
    },
    getDescriptionProps() {
      return normalize.element({
        ...parts.description.attrs,
        dir: prop("dir"),
        id: getDescriptionId(scope)
      });
    },
    getCloseTriggerProps() {
      return normalize.button({
        ...parts.closeTrigger.attrs,
        dir: prop("dir"),
        id: getCloseTriggerId(scope),
        type: "button",
        onClick(event) {
          if (event.defaultPrevented) return;
          event.stopPropagation();
          send({ type: "CLOSE" });
        }
      });
    }
  };
}
var machine = createMachine({
  props({ props: props2, scope }) {
    const alertDialog = props2.role === "alertdialog";
    const initialFocusEl = alertDialog ? () => getCloseTriggerEl(scope) : void 0;
    const modal = typeof props2.modal === "boolean" ? props2.modal : true;
    return {
      role: "dialog",
      modal,
      trapFocus: modal,
      preventScroll: modal,
      closeOnInteractOutside: !alertDialog,
      closeOnEscape: true,
      restoreFocus: true,
      initialFocusEl,
      ...props2
    };
  },
  initialState({ prop }) {
    const open = prop("open") || prop("defaultOpen");
    return open ? "open" : "closed";
  },
  context({ bindable }) {
    return {
      rendered: bindable(() => ({
        defaultValue: { title: true, description: true }
      }))
    };
  },
  watch({ track, action, prop }) {
    track([() => prop("open")], () => {
      action(["toggleVisibility"]);
    });
  },
  states: {
    open: {
      entry: ["checkRenderedElements", "syncZIndex"],
      effects: ["trackDismissableElement", "trapFocus", "preventScroll", "hideContentBelow"],
      on: {
        "CONTROLLED.CLOSE": {
          target: "closed"
        },
        CLOSE: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnClose"]
          },
          {
            target: "closed",
            actions: ["invokeOnClose"]
          }
        ],
        TOGGLE: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnClose"]
          },
          {
            target: "closed",
            actions: ["invokeOnClose"]
          }
        ]
      }
    },
    closed: {
      on: {
        "CONTROLLED.OPEN": {
          target: "open"
        },
        OPEN: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["invokeOnOpen"]
          }
        ],
        TOGGLE: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["invokeOnOpen"]
          }
        ]
      }
    }
  },
  implementations: {
    guards: {
      isOpenControlled: ({ prop }) => prop("open") != void 0
    },
    effects: {
      trackDismissableElement({ scope, send, prop }) {
        const getContentEl2 = () => getContentEl(scope);
        return trackDismissableElement(getContentEl2, {
          type: "dialog",
          defer: true,
          pointerBlocking: prop("modal"),
          exclude: [getTriggerEl(scope)],
          onInteractOutside(event) {
            prop("onInteractOutside")?.(event);
            if (!prop("closeOnInteractOutside")) {
              event.preventDefault();
            }
          },
          persistentElements: prop("persistentElements"),
          onFocusOutside: prop("onFocusOutside"),
          onPointerDownOutside: prop("onPointerDownOutside"),
          onRequestDismiss: prop("onRequestDismiss"),
          onEscapeKeyDown(event) {
            prop("onEscapeKeyDown")?.(event);
            if (!prop("closeOnEscape")) {
              event.preventDefault();
            }
          },
          onDismiss() {
            send({ type: "CLOSE", src: "interact-outside" });
          }
        });
      },
      preventScroll({ scope, prop }) {
        if (!prop("preventScroll")) return;
        return preventBodyScroll(scope.getDoc());
      },
      trapFocus({ scope, prop }) {
        if (!prop("trapFocus")) return;
        const contentEl = () => getContentEl(scope);
        return trapFocus(contentEl, {
          preventScroll: true,
          returnFocusOnDeactivate: !!prop("restoreFocus"),
          initialFocus: prop("initialFocusEl"),
          setReturnFocus: (el) => prop("finalFocusEl")?.() ?? el,
          getShadowRoot: true
        });
      },
      hideContentBelow({ scope, prop }) {
        if (!prop("modal")) return;
        const getElements = () => [getContentEl(scope)];
        return ariaHidden(getElements, { defer: true });
      }
    },
    actions: {
      checkRenderedElements({ context, scope }) {
        raf(() => {
          context.set("rendered", {
            title: !!getTitleEl(scope),
            description: !!getDescriptionEl(scope)
          });
        });
      },
      syncZIndex({ scope }) {
        raf(() => {
          const contentEl = getContentEl(scope);
          if (!contentEl) return;
          const styles = getComputedStyle(contentEl);
          const elems = [getPositionerEl(scope), getBackdropEl(scope)];
          elems.forEach((node) => {
            node?.style.setProperty("--z-index", styles.zIndex);
            node?.style.setProperty("--layer-index", styles.getPropertyValue("--layer-index"));
          });
        });
      },
      invokeOnClose({ prop }) {
        prop("onOpenChange")?.({ open: false });
      },
      invokeOnOpen({ prop }) {
        prop("onOpenChange")?.({ open: true });
      },
      toggleVisibility({ prop, send, event }) {
        send({
          type: prop("open") ? "CONTROLLED.OPEN" : "CONTROLLED.CLOSE",
          previousEvent: event
        });
      }
    }
  }
});
var props = createProps()([
  "aria-label",
  "closeOnEscape",
  "closeOnInteractOutside",
  "dir",
  "finalFocusEl",
  "getRootNode",
  "getRootNode",
  "id",
  "id",
  "ids",
  "initialFocusEl",
  "modal",
  "onEscapeKeyDown",
  "onFocusOutside",
  "onInteractOutside",
  "onOpenChange",
  "onPointerDownOutside",
  "onRequestDismiss",
  "defaultOpen",
  "open",
  "persistentElements",
  "preventScroll",
  "restoreFocus",
  "role",
  "trapFocus"
]);
var splitProps = createSplitProps(props);

// components/dialog.ts
var Dialog = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props2) {
    return new VanillaMachine(machine, props2);
  }
  initApi() {
    return connect(this.machine.service, normalizeProps);
  }
  render() {
    const rootEl = this.el;
    const triggerEl = rootEl.querySelector(
      '[data-scope="dialog"][data-part="trigger"]'
    );
    if (triggerEl) this.spreadProps(triggerEl, this.api.getTriggerProps());
    const backdropEl = rootEl.querySelector(
      '[data-scope="dialog"][data-part="backdrop"]'
    );
    if (backdropEl) this.spreadProps(backdropEl, this.api.getBackdropProps());
    const positionerEl = rootEl.querySelector(
      '[data-scope="dialog"][data-part="positioner"]'
    );
    if (positionerEl) this.spreadProps(positionerEl, this.api.getPositionerProps());
    const contentEl = rootEl.querySelector(
      '[data-scope="dialog"][data-part="content"]'
    );
    if (contentEl) this.spreadProps(contentEl, this.api.getContentProps());
    const titleEl = rootEl.querySelector('[data-scope="dialog"][data-part="title"]');
    if (titleEl) this.spreadProps(titleEl, this.api.getTitleProps());
    const descriptionEl = rootEl.querySelector(
      '[data-scope="dialog"][data-part="description"]'
    );
    if (descriptionEl) this.spreadProps(descriptionEl, this.api.getDescriptionProps());
    const closeTriggerEl = rootEl.querySelector(
      '[data-scope="dialog"][data-part="close-trigger"]'
    );
    if (closeTriggerEl) this.spreadProps(closeTriggerEl, this.api.getCloseTriggerProps());
  }
};

// hooks/dialog.ts
var DialogHook = {
  mounted() {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const dialog = new Dialog(el, {
      id: el.id,
      ...getBoolean(el, "controlled") ? { open: getBoolean(el, "open") } : { defaultOpen: getBoolean(el, "defaultOpen") },
      modal: getBoolean(el, "modal"),
      closeOnInteractOutside: getBoolean(el, "closeOnInteractOutside"),
      closeOnEscape: getBoolean(el, "closeOnEscapeKeyDown"),
      preventScroll: getBoolean(el, "preventScroll"),
      restoreFocus: getBoolean(el, "restoreFocus"),
      dir: getString(el, "dir", ["ltr", "rtl"]),
      onOpenChange: (details) => {
        const eventName = getString(el, "onOpenChange");
        if (eventName && this.liveSocket.main.isConnected()) {
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
      }
    });
    dialog.init();
    this.dialog = dialog;
    this.onSetOpen = (event) => {
      const { open } = event.detail;
      dialog.api.setOpen(open);
    };
    el.addEventListener("phx:dialog:set-open", this.onSetOpen);
    this.handlers = [];
    this.handlers.push(
      this.handleEvent("dialog_set_open", (payload) => {
        const targetId = payload.dialog_id;
        if (targetId && targetId !== el.id) return;
        dialog.api.setOpen(payload.open);
      })
    );
    this.handlers.push(
      this.handleEvent("dialog_open", () => {
        this.pushEvent("dialog_open_response", {
          value: dialog.api.open
        });
      })
    );
  },
  updated() {
    this.dialog?.updateProps({
      id: this.el.id,
      ...getBoolean(this.el, "controlled") ? { open: getBoolean(this.el, "open") } : { defaultOpen: getBoolean(this.el, "defaultOpen") },
      modal: getBoolean(this.el, "modal"),
      closeOnInteractOutside: getBoolean(this.el, "closeOnInteractOutside"),
      closeOnEscape: getBoolean(this.el, "closeOnEscapeKeyDown"),
      preventScroll: getBoolean(this.el, "preventScroll"),
      restoreFocus: getBoolean(this.el, "restoreFocus"),
      dir: getString(this.el, "dir", ["ltr", "rtl"])
    });
  },
  destroyed() {
    if (this.onSetOpen) {
      this.el.removeEventListener("phx:dialog:set-open", this.onSetOpen);
    }
    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }
    this.dialog?.destroy();
  }
};
export {
  DialogHook as Dialog
};
