"use strict";
var Corex = (() => {
  var __defProp = Object.defineProperty;
  var __defProps = Object.defineProperties;
  var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
  var __getOwnPropDescs = Object.getOwnPropertyDescriptors;
  var __getOwnPropNames = Object.getOwnPropertyNames;
  var __getOwnPropSymbols = Object.getOwnPropertySymbols;
  var __hasOwnProp = Object.prototype.hasOwnProperty;
  var __propIsEnum = Object.prototype.propertyIsEnumerable;
  var __knownSymbol = (name, symbol) => (symbol = Symbol[name]) ? symbol : Symbol.for("Symbol." + name);
  var __typeError = (msg) => {
    throw TypeError(msg);
  };
  var __defNormalProp = (obj, key, value) => key in obj ? __defProp(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
  var __spreadValues = (a2, b2) => {
    for (var prop in b2 || (b2 = {}))
      if (__hasOwnProp.call(b2, prop))
        __defNormalProp(a2, prop, b2[prop]);
    if (__getOwnPropSymbols)
      for (var prop of __getOwnPropSymbols(b2)) {
        if (__propIsEnum.call(b2, prop))
          __defNormalProp(a2, prop, b2[prop]);
      }
    return a2;
  };
  var __spreadProps = (a2, b2) => __defProps(a2, __getOwnPropDescs(b2));
  var __objRest = (source, exclude) => {
    var target = {};
    for (var prop in source)
      if (__hasOwnProp.call(source, prop) && exclude.indexOf(prop) < 0)
        target[prop] = source[prop];
    if (source != null && __getOwnPropSymbols)
      for (var prop of __getOwnPropSymbols(source)) {
        if (exclude.indexOf(prop) < 0 && __propIsEnum.call(source, prop))
          target[prop] = source[prop];
      }
    return target;
  };
  var __esm = (fn, res) => function __init() {
    return fn && (res = (0, fn[__getOwnPropNames(fn)[0]])(fn = 0)), res;
  };
  var __export = (target, all) => {
    for (var name in all)
      __defProp(target, name, { get: all[name], enumerable: true });
  };
  var __copyProps = (to, from, except, desc) => {
    if (from && typeof from === "object" || typeof from === "function") {
      for (let key of __getOwnPropNames(from))
        if (!__hasOwnProp.call(to, key) && key !== except)
          __defProp(to, key, { get: () => from[key], enumerable: !(desc = __getOwnPropDesc(from, key)) || desc.enumerable });
    }
    return to;
  };
  var __toCommonJS = (mod) => __copyProps(__defProp({}, "__esModule", { value: true }), mod);
  var __publicField = (obj, key, value) => __defNormalProp(obj, typeof key !== "symbol" ? key + "" : key, value);
  var __async = (__this, __arguments, generator) => {
    return new Promise((resolve, reject) => {
      var fulfilled = (value) => {
        try {
          step(generator.next(value));
        } catch (e2) {
          reject(e2);
        }
      };
      var rejected = (value) => {
        try {
          step(generator.throw(value));
        } catch (e2) {
          reject(e2);
        }
      };
      var step = (x2) => x2.done ? resolve(x2.value) : Promise.resolve(x2.value).then(fulfilled, rejected);
      step((generator = generator.apply(__this, __arguments)).next());
    });
  };
  var __await = function(promise, isYieldStar) {
    this[0] = promise;
    this[1] = isYieldStar;
  };
  var __yieldStar = (value) => {
    var obj = value[__knownSymbol("asyncIterator")], isAwait = false, method, it = {};
    if (obj == null) {
      obj = value[__knownSymbol("iterator")]();
      method = (k2) => it[k2] = (x2) => obj[k2](x2);
    } else {
      obj = obj.call(value);
      method = (k2) => it[k2] = (v2) => {
        if (isAwait) {
          isAwait = false;
          if (k2 === "throw") throw v2;
          return v2;
        }
        isAwait = true;
        return {
          done: false,
          value: new __await(new Promise((resolve) => {
            var x2 = obj[k2](v2);
            if (!(x2 instanceof Object)) __typeError("Object expected");
            resolve(x2);
          }), 1)
        };
      };
    }
    return it[__knownSymbol("iterator")] = () => it, method("next"), "throw" in obj ? method("throw") : it.throw = (x2) => {
      throw x2;
    }, "return" in obj && method("return"), it;
  };

  // ../priv/static/chunk-GFGFZBBD.mjs
  function getDir(element) {
    const fromEl = element.dataset.dir;
    if (fromEl !== void 0 && DIR_VALUES.includes(fromEl)) {
      return fromEl;
    }
    const fromDoc = document.documentElement.getAttribute("dir");
    if (fromDoc === "ltr" || fromDoc === "rtl") return fromDoc;
    return "ltr";
  }
  function setCaretToEnd(input) {
    if (!input) return;
    try {
      if (input.ownerDocument.activeElement !== input) return;
      const len = input.value.length;
      input.setSelectionRange(len, len);
    } catch (e2) {
    }
  }
  function isRootElement(node) {
    return ["html", "body", "#document"].includes(getNodeName(node));
  }
  function isActiveElement(element) {
    if (!element) return false;
    const rootNode = element.getRootNode();
    return getActiveElement(rootNode) === element;
  }
  function isEditableElement(el) {
    if (el == null || !isHTMLElement(el)) return false;
    try {
      return isInputElement(el) && el.selectionStart != null || TEXTAREA_SELECT_REGEX.test(el.localName) || el.isContentEditable || el.getAttribute("contenteditable") === "true" || el.getAttribute("contenteditable") === "";
    } catch (e2) {
      return false;
    }
  }
  function contains(parent, child) {
    var _a;
    if (!parent || !child) return false;
    if (!isHTMLElement(parent) || !isHTMLElement(child)) return false;
    const rootNode = (_a = child.getRootNode) == null ? void 0 : _a.call(child);
    if (parent === child) return true;
    if (parent.contains(child)) return true;
    if (rootNode && isShadowRoot(rootNode)) {
      let next2 = child;
      while (next2) {
        if (parent === next2) return true;
        next2 = next2.parentNode || next2.host;
      }
    }
    return false;
  }
  function getDocument(el) {
    var _a;
    if (isDocument(el)) return el;
    if (isWindow(el)) return el.document;
    return (_a = el == null ? void 0 : el.ownerDocument) != null ? _a : document;
  }
  function getDocumentElement(el) {
    return getDocument(el).documentElement;
  }
  function getWindow(el) {
    var _a, _b, _c;
    if (isShadowRoot(el)) return getWindow(el.host);
    if (isDocument(el)) return (_a = el.defaultView) != null ? _a : window;
    if (isHTMLElement(el)) return (_c = (_b = el.ownerDocument) == null ? void 0 : _b.defaultView) != null ? _c : window;
    return window;
  }
  function getActiveElement(rootNode) {
    let activeElement = rootNode.activeElement;
    while (activeElement == null ? void 0 : activeElement.shadowRoot) {
      const el = activeElement.shadowRoot.activeElement;
      if (!el || el === activeElement) break;
      else activeElement = el;
    }
    return activeElement;
  }
  function getParentNode(node) {
    if (getNodeName(node) === "html") return node;
    const result = node.assignedSlot || node.parentNode || isShadowRoot(node) && node.host || getDocumentElement(node);
    return isShadowRoot(result) ? result.host : result;
  }
  function getRootNode(node) {
    var _a;
    let result;
    try {
      result = node.getRootNode({ composed: true });
      if (isDocument(result) || isShadowRoot(result)) return result;
    } catch (e2) {
    }
    return (_a = node.ownerDocument) != null ? _a : document;
  }
  function getComputedStyle2(el) {
    if (!styleCache.has(el)) {
      styleCache.set(el, getWindow(el).getComputedStyle(el));
    }
    return styleCache.get(el);
  }
  function isControlledElement(container, element) {
    const visitedIds = /* @__PURE__ */ new Set();
    const rootNode = getRootNode(container);
    const checkElement = (searchRoot) => {
      const controllingElements = searchRoot.querySelectorAll("[aria-controls]");
      for (const controller of controllingElements) {
        if (controller.getAttribute("aria-expanded") !== "true") continue;
        const controlledIds = getAriaControls(controller);
        for (const id of controlledIds) {
          if (!id || visitedIds.has(id)) continue;
          visitedIds.add(id);
          const controlledElement = rootNode.getElementById(id);
          if (controlledElement) {
            const role = controlledElement.getAttribute("role");
            const modal = controlledElement.getAttribute("aria-modal") === "true";
            if (role && isInteractiveContainerRole(role) && !modal) {
              if (controlledElement === element || controlledElement.contains(element)) {
                return true;
              }
              if (checkElement(controlledElement)) {
                return true;
              }
            }
          }
        }
      }
      return false;
    };
    return checkElement(container);
  }
  function findControlledElements(searchRoot, callback) {
    const rootNode = getRootNode(searchRoot);
    const visitedIds = /* @__PURE__ */ new Set();
    const findRecursive = (root) => {
      const controllingElements = root.querySelectorAll("[aria-controls]");
      for (const controller of controllingElements) {
        if (controller.getAttribute("aria-expanded") !== "true") continue;
        const controlledIds = getAriaControls(controller);
        for (const id of controlledIds) {
          if (!id || visitedIds.has(id)) continue;
          visitedIds.add(id);
          const controlledElement = rootNode.getElementById(id);
          if (controlledElement) {
            const role = controlledElement.getAttribute("role");
            const modal = controlledElement.getAttribute("aria-modal") === "true";
            if (role && INTERACTIVE_CONTAINER_ROLE.has(role) && !modal) {
              callback(controlledElement);
              findRecursive(controlledElement);
            }
          }
        }
      }
    };
    findRecursive(searchRoot);
  }
  function getControlledElements(container) {
    const controlledElements = /* @__PURE__ */ new Set();
    findControlledElements(container, (controlledElement) => {
      if (!container.contains(controlledElement)) {
        controlledElements.add(controlledElement);
      }
    });
    return Array.from(controlledElements);
  }
  function isInteractiveContainerElement(element) {
    const role = element.getAttribute("role");
    return Boolean(role && INTERACTIVE_CONTAINER_ROLE.has(role));
  }
  function isControllerElement(element) {
    return element.hasAttribute("aria-controls") && element.getAttribute("aria-expanded") === "true";
  }
  function hasControllerElements(element) {
    var _a;
    if (isControllerElement(element)) return true;
    return Boolean((_a = element.querySelector) == null ? void 0 : _a.call(element, '[aria-controls][aria-expanded="true"]'));
  }
  function isControlledByExpandedController(element) {
    if (!element.id) return false;
    const rootNode = getRootNode(element);
    const escapedId = CSS.escape(element.id);
    const selector = `[aria-controls~="${escapedId}"][aria-expanded="true"], [aria-controls="${escapedId}"][aria-expanded="true"]`;
    const controller = rootNode.querySelector(selector);
    return Boolean(controller && isInteractiveContainerElement(element));
  }
  function getDataUrl(svg, opts) {
    const { type, quality = 0.92, background } = opts;
    if (!svg) throw new Error("[zag-js > getDataUrl]: Could not find the svg element");
    const win = getWindow(svg);
    const doc = win.document;
    const svgBounds = svg.getBoundingClientRect();
    const svgClone = svg.cloneNode(true);
    if (!svgClone.hasAttribute("viewBox")) {
      svgClone.setAttribute("viewBox", `0 0 ${svgBounds.width} ${svgBounds.height}`);
    }
    const serializer = new win.XMLSerializer();
    const source = '<?xml version="1.0" standalone="no"?>\r\n' + serializer.serializeToString(svgClone);
    const svgString = "data:image/svg+xml;charset=utf-8," + encodeURIComponent(source);
    if (type === "image/svg+xml") {
      return Promise.resolve(svgString).then((str) => {
        svgClone.remove();
        return str;
      });
    }
    const dpr = win.devicePixelRatio || 1;
    const canvas = doc.createElement("canvas");
    const image = new win.Image();
    image.src = svgString;
    canvas.width = svgBounds.width * dpr;
    canvas.height = svgBounds.height * dpr;
    const context = canvas.getContext("2d");
    if (type === "image/jpeg" || background) {
      context.fillStyle = background || "white";
      context.fillRect(0, 0, canvas.width, canvas.height);
    }
    return new Promise((resolve) => {
      image.onload = () => {
        context == null ? void 0 : context.drawImage(image, 0, 0, canvas.width, canvas.height);
        resolve(canvas.toDataURL(type, quality));
        svgClone.remove();
      };
    });
  }
  function getPlatform() {
    var _a;
    const agent = navigator.userAgentData;
    return (_a = agent == null ? void 0 : agent.platform) != null ? _a : navigator.platform;
  }
  function getUserAgent() {
    const ua2 = navigator.userAgentData;
    if (ua2 && Array.isArray(ua2.brands)) {
      return ua2.brands.map(({ brand, version }) => `${brand}/${version}`).join(" ");
    }
    return navigator.userAgent;
  }
  function getComposedPath(event) {
    var _a, _b, _c, _d;
    return (_d = (_a = event.composedPath) == null ? void 0 : _a.call(event)) != null ? _d : (_c = (_b = event.nativeEvent) == null ? void 0 : _b.composedPath) == null ? void 0 : _c.call(_b);
  }
  function getEventTarget(event) {
    var _a;
    const composedPath = getComposedPath(event);
    return (_a = composedPath == null ? void 0 : composedPath[0]) != null ? _a : event.target;
  }
  function isOpeningInNewTab(event) {
    const element = event.currentTarget;
    if (!element) return false;
    const validElement = element.matches("a[href], button[type='submit'], input[type='submit']");
    if (!validElement) return false;
    const isMiddleClick = event.button === 1;
    const isModKeyClick = isCtrlOrMetaKey(event);
    return isMiddleClick || isModKeyClick;
  }
  function isDownloadingEvent(event) {
    const element = event.currentTarget;
    if (!element) return false;
    const localName = element.localName;
    if (!event.altKey) return false;
    if (localName === "a") return true;
    if (localName === "button" && element.type === "submit") return true;
    if (localName === "input" && element.type === "submit") return true;
    return false;
  }
  function isComposingEvent(event) {
    return getNativeEvent(event).isComposing || event.keyCode === 229;
  }
  function isCtrlOrMetaKey(e2) {
    if (isMac()) return e2.metaKey;
    return e2.ctrlKey;
  }
  function isPrintableKey(e2) {
    return e2.key.length === 1 && !e2.ctrlKey && !e2.metaKey;
  }
  function isVirtualClick(e2) {
    if (e2.pointerType === "" && e2.isTrusted) return true;
    if (isAndroid() && e2.pointerType) {
      return e2.type === "click" && e2.buttons === 1;
    }
    return e2.detail === 0 && !e2.pointerType;
  }
  function getEventKey(event, options = {}) {
    var _a;
    const { dir = "ltr", orientation = "horizontal" } = options;
    let key = event.key;
    key = (_a = keyMap[key]) != null ? _a : key;
    const isRtl = dir === "rtl" && orientation === "horizontal";
    if (isRtl && key in rtlKeyMap) key = rtlKeyMap[key];
    return key;
  }
  function getNativeEvent(event) {
    var _a;
    return (_a = event.nativeEvent) != null ? _a : event;
  }
  function getEventPoint(event, type = "client") {
    const point = isTouchEvent(event) ? event.touches[0] || event.changedTouches[0] : event;
    return { x: point[`${type}X`], y: point[`${type}Y`] };
  }
  function getDescriptor(el, options) {
    var _a;
    const { type = "HTMLInputElement", property = "value" } = options;
    const proto = getWindow(el)[type].prototype;
    return (_a = Object.getOwnPropertyDescriptor(proto, property)) != null ? _a : {};
  }
  function getElementType(el) {
    if (el.localName === "input") return "HTMLInputElement";
    if (el.localName === "textarea") return "HTMLTextAreaElement";
    if (el.localName === "select") return "HTMLSelectElement";
  }
  function setElementValue(el, value, property = "value") {
    var _a;
    if (!el) return;
    const type = getElementType(el);
    if (type) {
      const descriptor = getDescriptor(el, { type, property });
      (_a = descriptor.set) == null ? void 0 : _a.call(el, value);
    }
    el.setAttribute(property, value);
  }
  function setElementChecked(el, checked) {
    var _a;
    if (!el) return;
    const descriptor = getDescriptor(el, { type: "HTMLInputElement", property: "checked" });
    (_a = descriptor.set) == null ? void 0 : _a.call(el, checked);
    if (checked) el.setAttribute("checked", "");
    else el.removeAttribute("checked");
  }
  function dispatchInputCheckedEvent(el, options) {
    const { checked, bubbles = true } = options;
    if (!el) return;
    const win = getWindow(el);
    if (!(el instanceof win.HTMLInputElement)) return;
    setElementChecked(el, checked);
    el.dispatchEvent(new win.Event("click", { bubbles }));
  }
  function getClosestForm(el) {
    return isFormElement(el) ? el.form : el.closest("form");
  }
  function isFormElement(el) {
    return el.matches("textarea, input, select, button");
  }
  function trackFormReset(el, callback) {
    if (!el) return;
    const form = getClosestForm(el);
    const onReset = (e2) => {
      if (e2.defaultPrevented) return;
      callback();
    };
    form == null ? void 0 : form.addEventListener("reset", onReset, { passive: true });
    return () => form == null ? void 0 : form.removeEventListener("reset", onReset);
  }
  function trackFieldsetDisabled(el, callback) {
    const fieldset = el == null ? void 0 : el.closest("fieldset");
    if (!fieldset) return;
    callback(fieldset.disabled);
    const win = getWindow(fieldset);
    const obs = new win.MutationObserver(() => callback(fieldset.disabled));
    obs.observe(fieldset, {
      attributes: true,
      attributeFilter: ["disabled"]
    });
    return () => obs.disconnect();
  }
  function trackFormControl(el, options) {
    if (!el) return;
    const { onFieldsetDisabledChange, onFormReset } = options;
    const cleanups = [trackFormReset(el, onFormReset), trackFieldsetDisabled(el, onFieldsetDisabledChange)];
    return () => cleanups.forEach((cleanup) => cleanup == null ? void 0 : cleanup());
  }
  function parseTabIndex(el) {
    const attr = el.getAttribute("tabindex");
    if (!attr) return NaN;
    return parseInt(attr, 10);
  }
  function getShadowRootForNode(element, getShadowRoot) {
    if (!getShadowRoot) return null;
    if (getShadowRoot === true) {
      return element.shadowRoot || null;
    }
    const result = getShadowRoot(element);
    return (result === true ? element.shadowRoot : result) || null;
  }
  function collectElementsWithShadowDOM(elements, getShadowRoot, filterFn) {
    const allElements = [...elements];
    const toProcess = [...elements];
    const processed = /* @__PURE__ */ new Set();
    const positionMap = /* @__PURE__ */ new Map();
    elements.forEach((el, i2) => positionMap.set(el, i2));
    let processIndex = 0;
    while (processIndex < toProcess.length) {
      const element = toProcess[processIndex++];
      if (!element || processed.has(element)) continue;
      processed.add(element);
      const shadowRoot = getShadowRootForNode(element, getShadowRoot);
      if (shadowRoot) {
        const shadowElements = Array.from(shadowRoot.querySelectorAll(focusableSelector)).filter(filterFn);
        const hostIndex = positionMap.get(element);
        if (hostIndex !== void 0) {
          const insertPosition = hostIndex + 1;
          allElements.splice(insertPosition, 0, ...shadowElements);
          shadowElements.forEach((el, i2) => {
            positionMap.set(el, insertPosition + i2);
          });
          for (let i2 = insertPosition + shadowElements.length; i2 < allElements.length; i2++) {
            positionMap.set(allElements[i2], i2);
          }
        } else {
          const insertPosition = allElements.length;
          allElements.push(...shadowElements);
          shadowElements.forEach((el, i2) => {
            positionMap.set(el, insertPosition + i2);
          });
        }
        toProcess.push(...shadowElements);
      }
    }
    return allElements;
  }
  function isFocusable(element) {
    if (!isHTMLElement(element) || element.closest("[inert]")) return false;
    return element.matches(focusableSelector) && isElementVisible(element);
  }
  function getTabbables(container, options = {}) {
    if (!container) return [];
    const { includeContainer, getShadowRoot } = options;
    const elements = Array.from(container.querySelectorAll(focusableSelector));
    if (includeContainer && isTabbable(container)) {
      elements.unshift(container);
    }
    const tabbableElements = [];
    for (const element of elements) {
      if (!isTabbable(element)) continue;
      if (isFrame(element) && element.contentDocument) {
        const frameBody = element.contentDocument.body;
        tabbableElements.push(...getTabbables(frameBody, { getShadowRoot }));
        continue;
      }
      tabbableElements.push(element);
    }
    if (getShadowRoot) {
      const allElements = collectElementsWithShadowDOM(tabbableElements, getShadowRoot, isTabbable);
      if (!allElements.length && includeContainer) {
        return elements;
      }
      return allElements;
    }
    if (!tabbableElements.length && includeContainer) {
      return elements;
    }
    return tabbableElements;
  }
  function isTabbable(el) {
    if (isHTMLElement(el) && el.tabIndex > 0) return true;
    return isFocusable(el) && !hasNegativeTabIndex(el);
  }
  function getTabbableEdges(container, options = {}) {
    const elements = getTabbables(container, options);
    const first2 = elements[0] || null;
    const last2 = elements[elements.length - 1] || null;
    return [first2, last2];
  }
  function getTabIndex(node) {
    if (node.tabIndex < 0) {
      if ((NATURALLY_TABBABLE_REGEX.test(node.localName) || isEditableElement(node)) && !hasTabIndex(node)) {
        return 0;
      }
    }
    return node.tabIndex;
  }
  function getInitialFocus(options) {
    const { root, getInitialEl, filter: filter2, enabled = true } = options;
    if (!enabled) return;
    let node = null;
    node || (node = typeof getInitialEl === "function" ? getInitialEl() : getInitialEl);
    node || (node = root == null ? void 0 : root.querySelector("[data-autofocus],[autofocus]"));
    if (!node) {
      const tabbables = getTabbables(root);
      node = filter2 ? tabbables.filter(filter2)[0] : tabbables[0];
    }
    return node || root || void 0;
  }
  function isValidTabEvent(event) {
    const container = event.currentTarget;
    if (!container) return false;
    const [firstTabbable, lastTabbable] = getTabbableEdges(container);
    if (isActiveElement(firstTabbable) && event.shiftKey) return false;
    if (isActiveElement(lastTabbable) && !event.shiftKey) return false;
    if (!firstTabbable && !lastTabbable) return false;
    return true;
  }
  function raf(fn) {
    const frame = AnimationFrame.create();
    frame.request(fn);
    return frame.cleanup;
  }
  function nextTick(fn) {
    const set = /* @__PURE__ */ new Set();
    function raf22(fn2) {
      const id = globalThis.requestAnimationFrame(fn2);
      set.add(() => globalThis.cancelAnimationFrame(id));
    }
    raf22(() => raf22(fn));
    return function cleanup() {
      set.forEach((fn2) => fn2());
    };
  }
  function queueBeforeEvent(el, type, cb) {
    const cancelTimer = raf(() => {
      el.removeEventListener(type, exec, true);
      cb();
    });
    const exec = () => {
      cancelTimer();
      cb();
    };
    el.addEventListener(type, exec, { once: true, capture: true });
    return cancelTimer;
  }
  function observeAttributesImpl(node, options) {
    if (!node) return;
    const { attributes, callback: fn } = options;
    const win = node.ownerDocument.defaultView || window;
    const obs = new win.MutationObserver((changes) => {
      for (const change of changes) {
        if (change.type === "attributes" && change.attributeName && attributes.includes(change.attributeName)) {
          fn(change);
        }
      }
    });
    obs.observe(node, { attributes: true, attributeFilter: attributes });
    return () => obs.disconnect();
  }
  function observeAttributes(nodeOrFn, options) {
    const { defer } = options;
    const func = defer ? raf : (v2) => v2();
    const cleanups = [];
    cleanups.push(
      func(() => {
        const node = typeof nodeOrFn === "function" ? nodeOrFn() : nodeOrFn;
        cleanups.push(observeAttributesImpl(node, options));
      })
    );
    return () => {
      cleanups.forEach((fn) => fn == null ? void 0 : fn());
    };
  }
  function observeChildrenImpl(node, options) {
    const { callback: fn } = options;
    if (!node) return;
    const win = node.ownerDocument.defaultView || window;
    const obs = new win.MutationObserver(fn);
    obs.observe(node, { childList: true, subtree: true });
    return () => obs.disconnect();
  }
  function observeChildren(nodeOrFn, options) {
    const { defer } = options;
    const func = defer ? raf : (v2) => v2();
    const cleanups = [];
    cleanups.push(
      func(() => {
        const node = typeof nodeOrFn === "function" ? nodeOrFn() : nodeOrFn;
        cleanups.push(observeChildrenImpl(node, options));
      })
    );
    return () => {
      cleanups.forEach((fn) => fn == null ? void 0 : fn());
    };
  }
  function clickIfLink(el) {
    const click = () => {
      const win = getWindow(el);
      el.dispatchEvent(new win.MouseEvent("click"));
    };
    if (isFirefox()) {
      queueBeforeEvent(el, "keyup", click);
    } else {
      queueMicrotask(click);
    }
  }
  function getNearestOverflowAncestor(el) {
    const parentNode = getParentNode(el);
    if (isRootElement(parentNode)) return getDocument(parentNode).body;
    if (isHTMLElement(parentNode) && isOverflowElement(parentNode)) return parentNode;
    return getNearestOverflowAncestor(parentNode);
  }
  function isOverflowElement(el) {
    const win = getWindow(el);
    const { overflow, overflowX, overflowY, display } = win.getComputedStyle(el);
    return OVERFLOW_RE.test(overflow + overflowY + overflowX) && !nonOverflowValues.has(display);
  }
  function isScrollable(el) {
    return el.scrollHeight > el.clientHeight || el.scrollWidth > el.clientWidth;
  }
  function scrollIntoView(el, options) {
    const _a = options || {}, { rootEl } = _a, scrollOptions = __objRest(_a, ["rootEl"]);
    if (!el || !rootEl) return;
    if (!isOverflowElement(rootEl) || !isScrollable(rootEl)) return;
    el.scrollIntoView(scrollOptions);
  }
  function getRelativePoint(point, element) {
    const { left, top, width, height } = element.getBoundingClientRect();
    const offset3 = { x: point.x - left, y: point.y - top };
    const percent = { x: clamp(offset3.x / width), y: clamp(offset3.y / height) };
    function getPercentValue(options = {}) {
      const { dir = "ltr", orientation = "horizontal", inverted } = options;
      const invertX = typeof inverted === "object" ? inverted.x : inverted;
      const invertY = typeof inverted === "object" ? inverted.y : inverted;
      if (orientation === "horizontal") {
        return dir === "rtl" || invertX ? 1 - percent.x : percent.x;
      }
      return invertY ? 1 - percent.y : percent.y;
    }
    return { offset: offset3, percent, getPercentValue };
  }
  function disableTextSelectionImpl(options = {}) {
    const { target, doc } = options;
    const docNode = doc != null ? doc : document;
    const rootEl = docNode.documentElement;
    if (isIos()) {
      if (state === "default") {
        userSelect = rootEl.style.webkitUserSelect;
        rootEl.style.webkitUserSelect = "none";
      }
      state = "disabled";
    } else if (target) {
      elementMap.set(target, target.style.userSelect);
      target.style.userSelect = "none";
    }
    return () => restoreTextSelection({ target, doc: docNode });
  }
  function restoreTextSelection(options = {}) {
    const { target, doc } = options;
    const docNode = doc != null ? doc : document;
    const rootEl = docNode.documentElement;
    if (isIos()) {
      if (state !== "disabled") return;
      state = "restoring";
      setTimeout(() => {
        nextTick(() => {
          if (state === "restoring") {
            if (rootEl.style.webkitUserSelect === "none") {
              rootEl.style.webkitUserSelect = userSelect || "";
            }
            userSelect = "";
            state = "default";
          }
        });
      }, 300);
    } else {
      if (target && elementMap.has(target)) {
        const prevUserSelect = elementMap.get(target);
        if (target.style.userSelect === "none") {
          target.style.userSelect = prevUserSelect != null ? prevUserSelect : "";
        }
        if (target.getAttribute("style") === "") {
          target.removeAttribute("style");
        }
        elementMap.delete(target);
      }
    }
  }
  function disableTextSelection(options = {}) {
    const _a = options, { defer, target } = _a, restOptions = __objRest(_a, ["defer", "target"]);
    const func = defer ? raf : (v2) => v2();
    const cleanups = [];
    cleanups.push(
      func(() => {
        const node = typeof target === "function" ? target() : target;
        cleanups.push(disableTextSelectionImpl(__spreadProps(__spreadValues({}, restOptions), { target: node })));
      })
    );
    return () => {
      cleanups.forEach((fn) => fn == null ? void 0 : fn());
    };
  }
  function trackPointerMove(doc, handlers) {
    const { onPointerMove, onPointerUp } = handlers;
    const handleMove = (event) => {
      const point = getEventPoint(event);
      const distance = Math.sqrt(point.x ** 2 + point.y ** 2);
      const moveBuffer = event.pointerType === "touch" ? 10 : 5;
      if (distance < moveBuffer) return;
      if (event.pointerType === "mouse" && event.buttons === 0) {
        handleUp(event);
        return;
      }
      onPointerMove({ point, event });
    };
    const handleUp = (event) => {
      const point = getEventPoint(event);
      onPointerUp({ point, event });
    };
    const cleanups = [
      addDomEvent(doc, "pointermove", handleMove, false),
      addDomEvent(doc, "pointerup", handleUp, false),
      addDomEvent(doc, "pointercancel", handleUp, false),
      addDomEvent(doc, "contextmenu", handleUp, false),
      disableTextSelection({ doc })
    ];
    return () => {
      cleanups.forEach((cleanup) => cleanup());
    };
  }
  function trackPress(options) {
    const {
      pointerNode,
      keyboardNode = pointerNode,
      onPress,
      onPressStart,
      onPressEnd,
      isValidKey: isValidKey2 = (e2) => e2.key === "Enter"
    } = options;
    if (!pointerNode) return noop;
    const win = getWindow(pointerNode);
    let removeStartListeners = noop;
    let removeEndListeners = noop;
    let removeAccessibleListeners = noop;
    const getInfo = (event) => ({
      point: getEventPoint(event),
      event
    });
    function startPress(event) {
      onPressStart == null ? void 0 : onPressStart(getInfo(event));
    }
    function cancelPress(event) {
      onPressEnd == null ? void 0 : onPressEnd(getInfo(event));
    }
    const startPointerPress = (startEvent) => {
      removeEndListeners();
      const endPointerPress = (endEvent) => {
        const target = getEventTarget(endEvent);
        if (contains(pointerNode, target)) {
          onPress == null ? void 0 : onPress(getInfo(endEvent));
        } else {
          onPressEnd == null ? void 0 : onPressEnd(getInfo(endEvent));
        }
      };
      const removePointerUpListener = addDomEvent(win, "pointerup", endPointerPress, { passive: !onPress, once: true });
      const removePointerCancelListener = addDomEvent(win, "pointercancel", cancelPress, {
        passive: !onPressEnd,
        once: true
      });
      removeEndListeners = pipe(removePointerUpListener, removePointerCancelListener);
      if (isActiveElement(keyboardNode) && startEvent.pointerType === "mouse") {
        startEvent.preventDefault();
      }
      startPress(startEvent);
    };
    const removePointerListener = addDomEvent(pointerNode, "pointerdown", startPointerPress, { passive: !onPressStart });
    const removeFocusListener = addDomEvent(keyboardNode, "focus", startAccessiblePress);
    removeStartListeners = pipe(removePointerListener, removeFocusListener);
    function startAccessiblePress() {
      const handleKeydown = (keydownEvent) => {
        if (!isValidKey2(keydownEvent)) return;
        const handleKeyup = (keyupEvent) => {
          if (!isValidKey2(keyupEvent)) return;
          const evt2 = new win.PointerEvent("pointerup");
          const info = getInfo(evt2);
          onPress == null ? void 0 : onPress(info);
          onPressEnd == null ? void 0 : onPressEnd(info);
        };
        removeEndListeners();
        removeEndListeners = addDomEvent(keyboardNode, "keyup", handleKeyup);
        const evt = new win.PointerEvent("pointerdown");
        startPress(evt);
      };
      const handleBlur = () => {
        const evt = new win.PointerEvent("pointercancel");
        cancelPress(evt);
      };
      const removeKeydownListener = addDomEvent(keyboardNode, "keydown", handleKeydown);
      const removeBlurListener = addDomEvent(keyboardNode, "blur", handleBlur);
      removeAccessibleListeners = pipe(removeKeydownListener, removeBlurListener);
    }
    return () => {
      removeStartListeners();
      removeEndListeners();
      removeAccessibleListeners();
    };
  }
  function queryAll(root, selector) {
    var _a;
    return Array.from((_a = root == null ? void 0 : root.querySelectorAll(selector)) != null ? _a : []);
  }
  function query(root, selector) {
    var _a;
    return (_a = root == null ? void 0 : root.querySelector(selector)) != null ? _a : null;
  }
  function itemById(v2, id, itemToId = defaultItemToId) {
    return v2.find((item) => itemToId(item) === id);
  }
  function indexOfId(v2, id, itemToId = defaultItemToId) {
    const item = itemById(v2, id, itemToId);
    return item ? v2.indexOf(item) : -1;
  }
  function nextById(v2, id, loop = true) {
    let idx = indexOfId(v2, id);
    idx = loop ? (idx + 1) % v2.length : Math.min(idx + 1, v2.length - 1);
    return v2[idx];
  }
  function prevById(v2, id, loop = true) {
    let idx = indexOfId(v2, id);
    if (idx === -1) return loop ? v2[v2.length - 1] : null;
    idx = loop ? (idx - 1 + v2.length) % v2.length : Math.max(0, idx - 1);
    return v2[idx];
  }
  function createSharedResizeObserver(options) {
    const listeners = /* @__PURE__ */ new WeakMap();
    let observer;
    const entries = /* @__PURE__ */ new WeakMap();
    const getObserver = (win) => {
      if (observer) return observer;
      observer = new win.ResizeObserver((observedEntries) => {
        for (const entry of observedEntries) {
          entries.set(entry.target, entry);
          const elementListeners = listeners.get(entry.target);
          if (elementListeners) {
            for (const listener of elementListeners) {
              listener(entry);
            }
          }
        }
      });
      return observer;
    };
    const observe = (element, listener) => {
      let elementListeners = listeners.get(element) || /* @__PURE__ */ new Set();
      elementListeners.add(listener);
      listeners.set(element, elementListeners);
      const win = getWindow(element);
      getObserver(win).observe(element, options);
      return () => {
        const elementListeners2 = listeners.get(element);
        if (!elementListeners2) return;
        elementListeners2.delete(listener);
        if (elementListeners2.size === 0) {
          listeners.delete(element);
          getObserver(win).unobserve(element);
        }
      };
    };
    const unobserve = (element) => {
      listeners.delete(element);
      observer == null ? void 0 : observer.unobserve(element);
    };
    return {
      observe,
      unobserve
    };
  }
  function getByText(v2, text, currentId, itemToId = defaultItemToId) {
    const index = currentId ? indexOfId(v2, currentId, itemToId) : -1;
    let items = currentId ? wrap(v2, index) : v2;
    const isSingleKey = text.length === 1;
    if (isSingleKey) {
      items = items.filter((item) => itemToId(item) !== currentId);
    }
    return items.find((item) => match(getValueText(item), text));
  }
  function setAttribute(el, attr, v2) {
    const prev2 = el.getAttribute(attr);
    const exists = prev2 != null;
    if (prev2 === v2) return noop;
    el.setAttribute(attr, v2);
    return () => {
      if (!exists) {
        el.removeAttribute(attr);
      } else {
        el.setAttribute(attr, prev2);
      }
    };
  }
  function setStyle(el, style) {
    if (!el) return noop;
    const prev2 = Object.keys(style).reduce((acc, key) => {
      acc[key] = el.style.getPropertyValue(key);
      return acc;
    }, {});
    if (isEqual(prev2, style)) return noop;
    Object.assign(el.style, style);
    return () => {
      Object.assign(el.style, prev2);
      if (el.style.length === 0) {
        el.removeAttribute("style");
      }
    };
  }
  function setStyleProperty(el, prop, value) {
    if (!el) return noop;
    const prev2 = el.style.getPropertyValue(prop);
    if (prev2 === value) return noop;
    el.style.setProperty(prop, value);
    return () => {
      el.style.setProperty(prop, prev2);
      if (el.style.length === 0) {
        el.removeAttribute("style");
      }
    };
  }
  function isEqual(a2, b2) {
    return Object.keys(a2).every((key) => a2[key] === b2[key]);
  }
  function getByTypeaheadImpl(baseItems, options) {
    const { state: state2, activeId, key, timeout = 350, itemToId } = options;
    const search = state2.keysSoFar + key;
    const isRepeated = search.length > 1 && Array.from(search).every((char) => char === search[0]);
    const query2 = isRepeated ? search[0] : search;
    let items = baseItems.slice();
    const next2 = getByText(items, query2, activeId, itemToId);
    function cleanup() {
      clearTimeout(state2.timer);
      state2.timer = -1;
    }
    function update(value) {
      state2.keysSoFar = value;
      cleanup();
      if (value !== "") {
        state2.timer = +setTimeout(() => {
          update("");
          cleanup();
        }, timeout);
      }
    }
    update(search);
    return next2;
  }
  function isValidTypeaheadEvent(event) {
    return event.key.length === 1 && !event.ctrlKey && !event.metaKey;
  }
  function waitForPromise(promise, controller, timeout) {
    const { signal } = controller;
    const wrappedPromise = new Promise((resolve, reject) => {
      const timeoutId = setTimeout(() => {
        reject(new Error(`Timeout of ${timeout}ms exceeded`));
      }, timeout);
      signal.addEventListener("abort", () => {
        clearTimeout(timeoutId);
        reject(new Error("Promise aborted"));
      });
      promise.then((result) => {
        if (!signal.aborted) {
          clearTimeout(timeoutId);
          resolve(result);
        }
      }).catch((error) => {
        if (!signal.aborted) {
          clearTimeout(timeoutId);
          reject(error);
        }
      });
    });
    const abort = () => controller.abort();
    return [wrappedPromise, abort];
  }
  function waitForElement(target, options) {
    const { timeout, rootNode } = options;
    const win = getWindow(rootNode);
    const doc = getDocument(rootNode);
    const controller = new win.AbortController();
    return waitForPromise(
      new Promise((resolve) => {
        const el = target();
        if (el) {
          resolve(el);
          return;
        }
        const observer = new win.MutationObserver(() => {
          const el2 = target();
          if (el2 && el2.isConnected) {
            observer.disconnect();
            resolve(el2);
          }
        });
        observer.observe(doc.body, {
          childList: true,
          subtree: true
        });
      }),
      controller,
      timeout
    );
  }
  function toArray(v2) {
    if (v2 == null) return [];
    return Array.isArray(v2) ? v2 : [v2];
  }
  function nextIndex(v2, idx, opts = {}) {
    const { step = 1, loop = true } = opts;
    const next2 = idx + step;
    const len = v2.length;
    const last2 = len - 1;
    if (idx === -1) return step > 0 ? 0 : last2;
    if (next2 < 0) return loop ? last2 : 0;
    if (next2 >= len) return loop ? 0 : idx > len ? len : idx;
    return next2;
  }
  function next(v2, idx, opts = {}) {
    return v2[nextIndex(v2, idx, opts)];
  }
  function prevIndex(v2, idx, opts = {}) {
    const { step = 1, loop = true } = opts;
    return nextIndex(v2, idx, { step: -step, loop });
  }
  function prev(v2, index, opts = {}) {
    return v2[prevIndex(v2, index, opts)];
  }
  function chunk(v2, size3) {
    return v2.reduce((rows, value, index) => {
      var _a;
      if (index % size3 === 0) rows.push([value]);
      else (_a = last(rows)) == null ? void 0 : _a.push(value);
      return rows;
    }, []);
  }
  function partition(arr, fn) {
    return arr.reduce(
      ([pass, fail], value) => {
        if (fn(value)) pass.push(value);
        else fail.push(value);
        return [pass, fail];
      },
      [[], []]
    );
  }
  function match2(key, record, ...args) {
    var _a;
    if (key in record) {
      const fn = record[key];
      return isFunction(fn) ? fn(...args) : fn;
    }
    const error = new Error(`No matching key: ${JSON.stringify(key)} in ${JSON.stringify(Object.keys(record))}`);
    (_a = Error.captureStackTrace) == null ? void 0 : _a.call(Error, error, match2);
    throw error;
  }
  function compact(obj) {
    if (!isPlainObject(obj) || obj === void 0) return obj;
    const keys = Reflect.ownKeys(obj).filter((key) => typeof key === "string");
    const filtered = {};
    for (const key of keys) {
      const value = obj[key];
      if (value !== void 0) {
        filtered[key] = compact(value);
      }
    }
    return filtered;
  }
  function splitProps(props15, keys) {
    const rest = {};
    const result = {};
    const keySet = new Set(keys);
    const ownKeys = Reflect.ownKeys(props15);
    for (const key of ownKeys) {
      if (keySet.has(key)) {
        result[key] = props15[key];
      } else {
        rest[key] = props15[key];
      }
    }
    return [result, rest];
  }
  function setRafTimeout(fn, delayMs) {
    const timer = new Timer(({ deltaMs }) => {
      if (deltaMs >= delayMs) {
        fn();
        return false;
      }
    });
    timer.start();
    return () => timer.stop();
  }
  function warn(...a2) {
    const m2 = a2.length === 1 ? a2[0] : a2[1];
    const c2 = a2.length === 2 ? a2[0] : true;
    if (c2 && true) {
      console.warn(m2);
    }
  }
  function ensure(c2, m2) {
    if (c2 == null) throw new Error(m2());
  }
  function ensureProps(props15, keys, scope) {
    let missingKeys = [];
    for (const key of keys) {
      if (props15[key] == null) missingKeys.push(key);
    }
    if (missingKeys.length > 0)
      throw new Error(`[zag-js${scope ? ` > ${scope}` : ""}] missing required props: ${missingKeys.join(", ")}`);
  }
  function mergeProps(...args) {
    let result = {};
    for (let props15 of args) {
      if (!props15) continue;
      for (let key in result) {
        if (key.startsWith("on") && typeof result[key] === "function" && typeof props15[key] === "function") {
          result[key] = callAll(props15[key], result[key]);
          continue;
        }
        if (key === "className" || key === "class") {
          result[key] = clsx(result[key], props15[key]);
          continue;
        }
        if (key === "style") {
          result[key] = css(result[key], props15[key]);
          continue;
        }
        result[key] = props15[key] !== void 0 ? props15[key] : result[key];
      }
      for (let key in props15) {
        if (result[key] === void 0) {
          result[key] = props15[key];
        }
      }
      const symbols = Object.getOwnPropertySymbols(props15);
      for (let symbol of symbols) {
        result[symbol] = props15[symbol];
      }
    }
    return result;
  }
  function memo(getDeps, fn, opts) {
    let deps = [];
    let result;
    return (depArgs) => {
      var _a;
      const newDeps = getDeps(depArgs);
      const depsChanged = newDeps.length !== deps.length || newDeps.some((dep, index) => !isEqual2(deps[index], dep));
      if (!depsChanged) return result;
      deps = newDeps;
      result = fn(newDeps, depArgs);
      (_a = opts == null ? void 0 : opts.onChange) == null ? void 0 : _a.call(opts, result);
      return result;
    };
  }
  function createGuards() {
    return {
      and: (...guards3) => {
        return function andGuard(params) {
          return guards3.every((str) => params.guard(str));
        };
      },
      or: (...guards3) => {
        return function orGuard(params) {
          return guards3.some((str) => params.guard(str));
        };
      },
      not: (guard) => {
        return function notGuard(params) {
          return !params.guard(guard);
        };
      }
    };
  }
  function createMachine(config) {
    return config;
  }
  function setup() {
    return {
      guards: createGuards(),
      createMachine: (config) => {
        return createMachine(config);
      },
      choose: (transitions) => {
        return function chooseFn({ choose: choose2 }) {
          var _a;
          return (_a = choose2(transitions)) == null ? void 0 : _a.actions;
        };
      }
    };
  }
  function createScope(props15) {
    const getRootNode2 = () => {
      var _a, _b;
      return (_b = (_a = props15.getRootNode) == null ? void 0 : _a.call(props15)) != null ? _b : document;
    };
    const getDoc = () => getDocument(getRootNode2());
    const getWin = () => {
      var _a;
      return (_a = getDoc().defaultView) != null ? _a : window;
    };
    const getActiveElementFn = () => getActiveElement(getRootNode2());
    const getById = (id) => getRootNode2().getElementById(id);
    return __spreadProps(__spreadValues({}, props15), {
      getRootNode: getRootNode2,
      getDoc,
      getWin,
      getActiveElement: getActiveElementFn,
      isActiveElement,
      getById
    });
  }
  function createNormalizer(fn) {
    return new Proxy({}, {
      get(_target, key) {
        if (key === "style")
          return (props15) => {
            return fn({ style: props15 }).style;
          };
        return fn;
      }
    });
  }
  function glob() {
    if (typeof globalThis !== "undefined") return globalThis;
    if (typeof self !== "undefined") return self;
    if (typeof window !== "undefined") return window;
    if (typeof global !== "undefined") return global;
  }
  function globalRef(key, value) {
    const g2 = glob();
    if (!g2) return value();
    g2[key] || (g2[key] = value());
    return g2[key];
  }
  function proxy(initialObject = {}) {
    return proxyFunction(initialObject);
  }
  function subscribe(proxyObject, callback, notifyInSync) {
    const proxyState = proxyStateMap.get(proxyObject);
    if (isDev() && !proxyState) {
      console.warn("Please use proxy object");
    }
    let promise;
    const ops = [];
    const addListener = proxyState[3];
    let isListenerActive = false;
    const listener = (op) => {
      ops.push(op);
      if (notifyInSync) {
        callback(ops.splice(0));
        return;
      }
      if (!promise) {
        promise = Promise.resolve().then(() => {
          promise = void 0;
          if (isListenerActive) {
            callback(ops.splice(0));
          }
        });
      }
    };
    const removeListener = addListener(listener);
    isListenerActive = true;
    return () => {
      isListenerActive = false;
      removeListener();
    };
  }
  function snapshot(proxyObject) {
    const proxyState = proxyStateMap.get(proxyObject);
    if (isDev() && !proxyState) {
      console.warn("Please use proxy object");
    }
    const [target, ensureVersion, createSnapshot] = proxyState;
    return createSnapshot(target, ensureVersion());
  }
  function spreadProps(node, attrs, machineId) {
    const scopeKey = machineId || "default";
    let machineMap = prevAttrsMap.get(node);
    if (!machineMap) {
      machineMap = /* @__PURE__ */ new Map();
      prevAttrsMap.set(node, machineMap);
    }
    const oldAttrs = machineMap.get(scopeKey) || {};
    const attrKeys = Object.keys(attrs);
    const addEvt = (e2, f2) => {
      node.addEventListener(e2.toLowerCase(), f2);
    };
    const remEvt = (e2, f2) => {
      node.removeEventListener(e2.toLowerCase(), f2);
    };
    const onEvents = (attr) => attr.startsWith("on");
    const others = (attr) => !attr.startsWith("on");
    const setup2 = (attr) => addEvt(attr.substring(2), attrs[attr]);
    const teardown = (attr) => remEvt(attr.substring(2), attrs[attr]);
    const apply = (attrName) => {
      const value = attrs[attrName];
      const oldValue = oldAttrs[attrName];
      if (value === oldValue) return;
      if (attrName === "class") {
        node.className = value != null ? value : "";
        return;
      }
      if (assignableProps.has(attrName)) {
        node[attrName] = value != null ? value : "";
        return;
      }
      if (typeof value === "boolean" && !attrName.includes("aria-")) {
        node.toggleAttribute(getAttributeName(node, attrName), value);
        return;
      }
      if (attrName === "children") {
        node.innerHTML = value;
        return;
      }
      if (value != null) {
        node.setAttribute(getAttributeName(node, attrName), value);
        return;
      }
      node.removeAttribute(getAttributeName(node, attrName));
    };
    for (const key in oldAttrs) {
      if (attrs[key] == null) {
        if (key === "class") {
          node.className = "";
        } else if (assignableProps.has(key)) {
          node[key] = "";
        } else {
          node.removeAttribute(getAttributeName(node, key));
        }
      }
    }
    const oldEvents = Object.keys(oldAttrs).filter(onEvents);
    oldEvents.forEach((evt) => {
      remEvt(evt.substring(2), oldAttrs[evt]);
    });
    attrKeys.filter(onEvents).forEach(setup2);
    attrKeys.filter(others).forEach(apply);
    machineMap.set(scopeKey, attrs);
    return function cleanup() {
      attrKeys.filter(onEvents).forEach(teardown);
      const currentMachineMap = prevAttrsMap.get(node);
      if (currentMachineMap) {
        currentMachineMap.delete(scopeKey);
        if (currentMachineMap.size === 0) {
          prevAttrsMap.delete(node);
        }
      }
    };
  }
  function bindable(props15) {
    var _a, _b;
    const initial = (_a = props15().value) != null ? _a : props15().defaultValue;
    if (props15().debug) {
      console.log(`[bindable > ${props15().debug}] initial`, initial);
    }
    const eq = (_b = props15().isEqual) != null ? _b : Object.is;
    const store = proxy({ value: initial });
    const controlled = () => props15().value !== void 0;
    return {
      initial,
      ref: store,
      get() {
        return controlled() ? props15().value : store.value;
      },
      set(nextValue) {
        var _a2, _b2;
        const prev2 = store.value;
        const next2 = isFunction(nextValue) ? nextValue(prev2) : nextValue;
        if (props15().debug) {
          console.log(`[bindable > ${props15().debug}] setValue`, { next: next2, prev: prev2 });
        }
        if (!controlled()) store.value = next2;
        if (!eq(next2, prev2)) {
          (_b2 = (_a2 = props15()).onChange) == null ? void 0 : _b2.call(_a2, next2, prev2);
        }
      },
      invoke(nextValue, prevValue) {
        var _a2, _b2;
        (_b2 = (_a2 = props15()).onChange) == null ? void 0 : _b2.call(_a2, nextValue, prevValue);
      },
      hash(value) {
        var _a2, _b2, _c;
        return (_c = (_b2 = (_a2 = props15()).hash) == null ? void 0 : _b2.call(_a2, value)) != null ? _c : String(value);
      }
    };
  }
  function createRefs(refs) {
    const ref = { current: refs };
    return {
      get(key) {
        return ref.current[key];
      },
      set(key, value) {
        ref.current[key] = value;
      }
    };
  }
  function mergeMachineProps(prev2, next2) {
    if (!isPlainObject(prev2) || !isPlainObject(next2)) {
      return next2 === void 0 ? prev2 : next2;
    }
    const result = __spreadValues({}, prev2);
    for (const key of Object.keys(next2)) {
      const nextValue = next2[key];
      const prevValue = prev2[key];
      if (nextValue === void 0) {
        continue;
      }
      if (isPlainObject(prevValue) && isPlainObject(nextValue)) {
        result[key] = mergeMachineProps(prevValue, nextValue);
      } else {
        result[key] = nextValue;
      }
    }
    return result;
  }
  var DIR_VALUES, getString, getStringList, getNumber, getBoolean, generateId, createAnatomy, toKebabCase, isEmpty, __defProp2, __defNormalProp2, __publicField2, clamp, wrap, pipe, noop, isObject, MAX_Z_INDEX, dataAttr, ariaAttr, ELEMENT_NODE, DOCUMENT_NODE, DOCUMENT_FRAGMENT_NODE, isHTMLElement, isDocument, isWindow, getNodeName, isNode, isShadowRoot, isInputElement, isAnchorElement, isElementVisible, TEXTAREA_SELECT_REGEX, styleCache, INTERACTIVE_CONTAINER_ROLE, isInteractiveContainerRole, getAriaControls, isDom, pt, ua, vn, isTouchDevice, isIPhone, isIPad, isIos, isApple, isMac, isSafari, isFirefox, isAndroid, isLeftClick, isContextMenuEvent, isModifierKey, isTouchEvent, keyMap, rtlKeyMap, addDomEvent, isFrame, NATURALLY_TABBABLE_REGEX, hasTabIndex, hasNegativeTabIndex, focusableSelector, getFocusables, AnimationFrame, OVERFLOW_RE, nonOverflowValues, state, userSelect, elementMap, defaultItemToId, resizeObserverBorderBox, sanitize, getValueText, match, getByTypeahead, visuallyHiddenStyle, __defProp22, __typeError2, __defNormalProp22, __publicField22, __accessCheck, __privateGet, __privateAdd, first, last, has, add, remove, uniq, diff, addOrRemove, isArrayLike, isArrayEqual, isEqual2, isArray, isBoolean, isObjectLike, isObject2, isString, isFunction, isNull, hasProp, baseGetTag, fnToString, objectCtorString, isPlainObject, isReactElement, isVueElement, isFrameworkElement, runIfFn, cast, identity, noop2, callAll, uuid, floor, abs, round, min, max, pow, sign, isNaN2, nan, isValueWithinRange, clampValue, toPx, createSplitProps, currentTime, _tick, Timer, clsx, CSS_REGEX, serialize, css, MachineStatus, INIT_STATE, createProps, TRACK_MEMO_SYMBOL, GET_ORIGINAL_SYMBOL, getProto, objectsToTrack, isObjectToTrack, getUntracked, markToTrack, refSet, isReactElement2, isVueElement2, isDOMElement, isElement, isObject3, canProxy, isDev, proxyStateMap, buildProxyFunction, proxyFunction, __defProp3, __defNormalProp3, __publicField3, propMap, caseSensitiveSvgAttrs, toStyleString, normalizeProps, prevAttrsMap, assignableProps, caseSensitiveSvgAttrs2, isSvgElement, getAttributeName, VanillaMachine, Component;
  var init_chunk_GFGFZBBD = __esm({
    "../priv/static/chunk-GFGFZBBD.mjs"() {
      "use strict";
      DIR_VALUES = ["ltr", "rtl"];
      getString = (element, attrName, validValues) => {
        const value = element.dataset[attrName];
        if (value !== void 0 && (!validValues || validValues.includes(value))) {
          return value;
        }
        return void 0;
      };
      getStringList = (element, attrName) => {
        const value = element.dataset[attrName];
        if (typeof value === "string") {
          return value.split(",").map((v2) => v2.trim()).filter((v2) => v2.length > 0);
        }
        return void 0;
      };
      getNumber = (element, attrName, validValues) => {
        const raw = element.dataset[attrName];
        if (raw === void 0) return void 0;
        const parsed = Number(raw);
        if (Number.isNaN(parsed)) return void 0;
        if (validValues && !validValues.includes(parsed)) return 0;
        return parsed;
      };
      getBoolean = (element, attrName) => {
        const dashName = attrName.replace(/([A-Z])/g, "-$1").toLowerCase();
        return element.hasAttribute(`data-${dashName}`);
      };
      generateId = (element, fallbackId = "element") => {
        if (element == null ? void 0 : element.id) return element.id;
        return `${fallbackId}-${Math.random().toString(36).substring(2, 9)}`;
      };
      createAnatomy = (name, parts16 = []) => ({
        parts: (...values) => {
          if (isEmpty(parts16)) {
            return createAnatomy(name, values);
          }
          throw new Error("createAnatomy().parts(...) should only be called once. Did you mean to use .extendWith(...) ?");
        },
        extendWith: (...values) => createAnatomy(name, [...parts16, ...values]),
        omit: (...values) => createAnatomy(name, parts16.filter((part) => !values.includes(part))),
        rename: (newName) => createAnatomy(newName, parts16),
        keys: () => parts16,
        build: () => [...new Set(parts16)].reduce(
          (prev2, part) => Object.assign(prev2, {
            [part]: {
              selector: [
                `&[data-scope="${toKebabCase(name)}"][data-part="${toKebabCase(part)}"]`,
                `& [data-scope="${toKebabCase(name)}"][data-part="${toKebabCase(part)}"]`
              ].join(", "),
              attrs: { "data-scope": toKebabCase(name), "data-part": toKebabCase(part) }
            }
          }),
          {}
        )
      });
      toKebabCase = (value) => value.replace(/([A-Z])([A-Z])/g, "$1-$2").replace(/([a-z])([A-Z])/g, "$1-$2").replace(/[\s_]+/g, "-").toLowerCase();
      isEmpty = (v2) => v2.length === 0;
      __defProp2 = Object.defineProperty;
      __defNormalProp2 = (obj, key, value) => key in obj ? __defProp2(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
      __publicField2 = (obj, key, value) => __defNormalProp2(obj, typeof key !== "symbol" ? key + "" : key, value);
      clamp = (value) => Math.max(0, Math.min(1, value));
      wrap = (v2, idx) => {
        return v2.map((_2, index) => v2[(Math.max(idx, 0) + index) % v2.length]);
      };
      pipe = (...fns) => (arg) => fns.reduce((acc, fn) => fn(acc), arg);
      noop = () => void 0;
      isObject = (v2) => typeof v2 === "object" && v2 !== null;
      MAX_Z_INDEX = 2147483647;
      dataAttr = (guard) => guard ? "" : void 0;
      ariaAttr = (guard) => guard ? "true" : void 0;
      ELEMENT_NODE = 1;
      DOCUMENT_NODE = 9;
      DOCUMENT_FRAGMENT_NODE = 11;
      isHTMLElement = (el) => isObject(el) && el.nodeType === ELEMENT_NODE && typeof el.nodeName === "string";
      isDocument = (el) => isObject(el) && el.nodeType === DOCUMENT_NODE;
      isWindow = (el) => isObject(el) && el === el.window;
      getNodeName = (node) => {
        if (isHTMLElement(node)) return node.localName || "";
        return "#document";
      };
      isNode = (el) => isObject(el) && el.nodeType !== void 0;
      isShadowRoot = (el) => isNode(el) && el.nodeType === DOCUMENT_FRAGMENT_NODE && "host" in el;
      isInputElement = (el) => isHTMLElement(el) && el.localName === "input";
      isAnchorElement = (el) => !!(el == null ? void 0 : el.matches("a[href]"));
      isElementVisible = (el) => {
        if (!isHTMLElement(el)) return false;
        return el.offsetWidth > 0 || el.offsetHeight > 0 || el.getClientRects().length > 0;
      };
      TEXTAREA_SELECT_REGEX = /(textarea|select)/;
      styleCache = /* @__PURE__ */ new WeakMap();
      INTERACTIVE_CONTAINER_ROLE = /* @__PURE__ */ new Set(["menu", "listbox", "dialog", "grid", "tree", "region"]);
      isInteractiveContainerRole = (role) => INTERACTIVE_CONTAINER_ROLE.has(role);
      getAriaControls = (element) => {
        var _a;
        return ((_a = element.getAttribute("aria-controls")) == null ? void 0 : _a.split(" ")) || [];
      };
      isDom = () => typeof document !== "undefined";
      pt = (v2) => isDom() && v2.test(getPlatform());
      ua = (v2) => isDom() && v2.test(getUserAgent());
      vn = (v2) => isDom() && v2.test(navigator.vendor);
      isTouchDevice = () => isDom() && !!navigator.maxTouchPoints;
      isIPhone = () => pt(/^iPhone/i);
      isIPad = () => pt(/^iPad/i) || isMac() && navigator.maxTouchPoints > 1;
      isIos = () => isIPhone() || isIPad();
      isApple = () => isMac() || isIos();
      isMac = () => pt(/^Mac/i);
      isSafari = () => isApple() && vn(/apple/i);
      isFirefox = () => ua(/Firefox/i);
      isAndroid = () => ua(/Android/i);
      isLeftClick = (e2) => e2.button === 0;
      isContextMenuEvent = (e2) => {
        return e2.button === 2 || isMac() && e2.ctrlKey && e2.button === 0;
      };
      isModifierKey = (e2) => e2.ctrlKey || e2.altKey || e2.metaKey;
      isTouchEvent = (event) => "touches" in event && event.touches.length > 0;
      keyMap = {
        Up: "ArrowUp",
        Down: "ArrowDown",
        Esc: "Escape",
        " ": "Space",
        ",": "Comma",
        Left: "ArrowLeft",
        Right: "ArrowRight"
      };
      rtlKeyMap = {
        ArrowLeft: "ArrowRight",
        ArrowRight: "ArrowLeft"
      };
      addDomEvent = (target, eventName, handler, options) => {
        const node = typeof target === "function" ? target() : target;
        node == null ? void 0 : node.addEventListener(eventName, handler, options);
        return () => {
          node == null ? void 0 : node.removeEventListener(eventName, handler, options);
        };
      };
      isFrame = (el) => isHTMLElement(el) && el.tagName === "IFRAME";
      NATURALLY_TABBABLE_REGEX = /^(audio|video|details)$/;
      hasTabIndex = (el) => !Number.isNaN(parseTabIndex(el));
      hasNegativeTabIndex = (el) => parseTabIndex(el) < 0;
      focusableSelector = "input:not([type='hidden']):not([disabled]), select:not([disabled]), textarea:not([disabled]), a[href], button:not([disabled]), [tabindex], iframe, object, embed, area[href], audio[controls], video[controls], [contenteditable]:not([contenteditable='false']), details > summary:first-of-type";
      getFocusables = (container, options = {}) => {
        if (!container) return [];
        const { includeContainer = false, getShadowRoot } = options;
        const elements = Array.from(container.querySelectorAll(focusableSelector));
        const include = includeContainer == true || includeContainer == "if-empty" && elements.length === 0;
        if (include && isHTMLElement(container) && isFocusable(container)) {
          elements.unshift(container);
        }
        const focusableElements = [];
        for (const element of elements) {
          if (!isFocusable(element)) continue;
          if (isFrame(element) && element.contentDocument) {
            const frameBody = element.contentDocument.body;
            focusableElements.push(...getFocusables(frameBody, { getShadowRoot }));
            continue;
          }
          focusableElements.push(element);
        }
        if (getShadowRoot) {
          return collectElementsWithShadowDOM(focusableElements, getShadowRoot, isFocusable);
        }
        return focusableElements;
      };
      AnimationFrame = class _AnimationFrame {
        constructor() {
          __publicField2(this, "id", null);
          __publicField2(this, "fn_cleanup");
          __publicField2(this, "cleanup", () => {
            this.cancel();
          });
        }
        static create() {
          return new _AnimationFrame();
        }
        request(fn) {
          this.cancel();
          this.id = globalThis.requestAnimationFrame(() => {
            this.id = null;
            this.fn_cleanup = fn == null ? void 0 : fn();
          });
        }
        cancel() {
          var _a;
          if (this.id !== null) {
            globalThis.cancelAnimationFrame(this.id);
            this.id = null;
          }
          (_a = this.fn_cleanup) == null ? void 0 : _a.call(this);
          this.fn_cleanup = void 0;
        }
        isActive() {
          return this.id !== null;
        }
      };
      OVERFLOW_RE = /auto|scroll|overlay|hidden|clip/;
      nonOverflowValues = /* @__PURE__ */ new Set(["inline", "contents"]);
      state = "default";
      userSelect = "";
      elementMap = /* @__PURE__ */ new WeakMap();
      defaultItemToId = (v2) => v2.id;
      resizeObserverBorderBox = /* @__PURE__ */ createSharedResizeObserver({
        box: "border-box"
      });
      sanitize = (str) => str.split("").map((char) => {
        const code = char.charCodeAt(0);
        if (code > 0 && code < 128) return char;
        if (code >= 128 && code <= 255) return `/x${code.toString(16)}`.replace("/", "\\");
        return "";
      }).join("").trim();
      getValueText = (el) => {
        var _a, _b, _c;
        return sanitize((_c = (_b = (_a = el.dataset) == null ? void 0 : _a.valuetext) != null ? _b : el.textContent) != null ? _c : "");
      };
      match = (valueText, query2) => {
        return valueText.trim().toLowerCase().startsWith(query2.toLowerCase());
      };
      getByTypeahead = /* @__PURE__ */ Object.assign(getByTypeaheadImpl, {
        defaultOptions: { keysSoFar: "", timer: -1 },
        isValidEvent: isValidTypeaheadEvent
      });
      visuallyHiddenStyle = {
        border: "0",
        clip: "rect(0 0 0 0)",
        height: "1px",
        margin: "-1px",
        overflow: "hidden",
        padding: "0",
        position: "absolute",
        width: "1px",
        whiteSpace: "nowrap",
        wordWrap: "normal"
      };
      __defProp22 = Object.defineProperty;
      __typeError2 = (msg) => {
        throw TypeError(msg);
      };
      __defNormalProp22 = (obj, key, value) => key in obj ? __defProp22(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
      __publicField22 = (obj, key, value) => __defNormalProp22(obj, typeof key !== "symbol" ? key + "" : key, value);
      __accessCheck = (obj, member, msg) => member.has(obj) || __typeError2("Cannot " + msg);
      __privateGet = (obj, member, getter) => (__accessCheck(obj, member, "read from private field"), member.get(obj));
      __privateAdd = (obj, member, value) => member.has(obj) ? __typeError2("Cannot add the same private member more than once") : member instanceof WeakSet ? member.add(obj) : member.set(obj, value);
      first = (v2) => v2[0];
      last = (v2) => v2[v2.length - 1];
      has = (v2, t2) => v2.indexOf(t2) !== -1;
      add = (v2, ...items) => v2.concat(items);
      remove = (v2, ...items) => v2.filter((t2) => !items.includes(t2));
      uniq = (v2) => Array.from(new Set(v2));
      diff = (a2, b2) => {
        const set = new Set(b2);
        return a2.filter((t2) => !set.has(t2));
      };
      addOrRemove = (v2, item) => has(v2, item) ? remove(v2, item) : add(v2, item);
      isArrayLike = (value) => (value == null ? void 0 : value.constructor.name) === "Array";
      isArrayEqual = (a2, b2) => {
        if (a2.length !== b2.length) return false;
        for (let i2 = 0; i2 < a2.length; i2++) {
          if (!isEqual2(a2[i2], b2[i2])) return false;
        }
        return true;
      };
      isEqual2 = (a2, b2) => {
        if (Object.is(a2, b2)) return true;
        if (a2 == null && b2 != null || a2 != null && b2 == null) return false;
        if (typeof (a2 == null ? void 0 : a2.isEqual) === "function" && typeof (b2 == null ? void 0 : b2.isEqual) === "function") {
          return a2.isEqual(b2);
        }
        if (typeof a2 === "function" && typeof b2 === "function") {
          return a2.toString() === b2.toString();
        }
        if (isArrayLike(a2) && isArrayLike(b2)) {
          return isArrayEqual(Array.from(a2), Array.from(b2));
        }
        if (!(typeof a2 === "object") || !(typeof b2 === "object")) return false;
        const keys = Object.keys(b2 != null ? b2 : /* @__PURE__ */ Object.create(null));
        const length = keys.length;
        for (let i2 = 0; i2 < length; i2++) {
          const hasKey = Reflect.has(a2, keys[i2]);
          if (!hasKey) return false;
        }
        for (let i2 = 0; i2 < length; i2++) {
          const key = keys[i2];
          if (!isEqual2(a2[key], b2[key])) return false;
        }
        return true;
      };
      isArray = (v2) => Array.isArray(v2);
      isBoolean = (v2) => v2 === true || v2 === false;
      isObjectLike = (v2) => v2 != null && typeof v2 === "object";
      isObject2 = (v2) => isObjectLike(v2) && !isArray(v2);
      isString = (v2) => typeof v2 === "string";
      isFunction = (v2) => typeof v2 === "function";
      isNull = (v2) => v2 == null;
      hasProp = (obj, prop) => Object.prototype.hasOwnProperty.call(obj, prop);
      baseGetTag = (v2) => Object.prototype.toString.call(v2);
      fnToString = Function.prototype.toString;
      objectCtorString = fnToString.call(Object);
      isPlainObject = (v2) => {
        if (!isObjectLike(v2) || baseGetTag(v2) != "[object Object]" || isFrameworkElement(v2)) return false;
        const proto = Object.getPrototypeOf(v2);
        if (proto === null) return true;
        const Ctor = hasProp(proto, "constructor") && proto.constructor;
        return typeof Ctor == "function" && Ctor instanceof Ctor && fnToString.call(Ctor) == objectCtorString;
      };
      isReactElement = (x2) => typeof x2 === "object" && x2 !== null && "$$typeof" in x2 && "props" in x2;
      isVueElement = (x2) => typeof x2 === "object" && x2 !== null && "__v_isVNode" in x2;
      isFrameworkElement = (x2) => isReactElement(x2) || isVueElement(x2);
      runIfFn = (v2, ...a2) => {
        const res = typeof v2 === "function" ? v2(...a2) : v2;
        return res != null ? res : void 0;
      };
      cast = (v2) => v2;
      identity = (v2) => v2();
      noop2 = () => {
      };
      callAll = (...fns) => (...a2) => {
        fns.forEach(function(fn) {
          fn == null ? void 0 : fn(...a2);
        });
      };
      uuid = /* @__PURE__ */ (() => {
        let id = 0;
        return () => {
          id++;
          return id.toString(36);
        };
      })();
      ({ floor, abs, round, min, max, pow, sign } = Math);
      isNaN2 = (v2) => Number.isNaN(v2);
      nan = (v2) => isNaN2(v2) ? 0 : v2;
      isValueWithinRange = (v2, vmin, vmax) => {
        const value = nan(v2);
        const minCheck = vmin == null || value >= vmin;
        const maxCheck = vmax == null || value <= vmax;
        return minCheck && maxCheck;
      };
      clampValue = (v2, vmin, vmax) => min(max(nan(v2), vmin), vmax);
      toPx = (v2) => typeof v2 === "number" ? `${v2}px` : v2;
      createSplitProps = (keys) => {
        return function split(props15) {
          return splitProps(props15, keys);
        };
      };
      currentTime = () => performance.now();
      Timer = class {
        constructor(onTick) {
          this.onTick = onTick;
          __publicField22(this, "frameId", null);
          __publicField22(this, "pausedAtMs", null);
          __publicField22(this, "context");
          __publicField22(this, "cancelFrame", () => {
            if (this.frameId === null) return;
            cancelAnimationFrame(this.frameId);
            this.frameId = null;
          });
          __publicField22(this, "setStartMs", (startMs) => {
            this.context.startMs = startMs;
          });
          __publicField22(this, "start", () => {
            if (this.frameId !== null) return;
            const now = currentTime();
            if (this.pausedAtMs !== null) {
              this.context.startMs += now - this.pausedAtMs;
              this.pausedAtMs = null;
            } else {
              this.context.startMs = now;
            }
            this.frameId = requestAnimationFrame(__privateGet(this, _tick));
          });
          __publicField22(this, "pause", () => {
            if (this.frameId === null) return;
            this.cancelFrame();
            this.pausedAtMs = currentTime();
          });
          __publicField22(this, "stop", () => {
            if (this.frameId === null) return;
            this.cancelFrame();
            this.pausedAtMs = null;
          });
          __privateAdd(this, _tick, (now) => {
            this.context.now = now;
            this.context.deltaMs = now - this.context.startMs;
            const shouldContinue = this.onTick(this.context);
            if (shouldContinue === false) {
              this.stop();
              return;
            }
            this.frameId = requestAnimationFrame(__privateGet(this, _tick));
          });
          this.context = { now: 0, startMs: currentTime(), deltaMs: 0 };
        }
        get elapsedMs() {
          if (this.pausedAtMs !== null) {
            return this.pausedAtMs - this.context.startMs;
          }
          return currentTime() - this.context.startMs;
        }
      };
      _tick = /* @__PURE__ */ new WeakMap();
      clsx = (...args) => args.map((str) => {
        var _a;
        return (_a = str == null ? void 0 : str.trim) == null ? void 0 : _a.call(str);
      }).filter(Boolean).join(" ");
      CSS_REGEX = /((?:--)?(?:\w+-?)+)\s*:\s*([^;]*)/g;
      serialize = (style) => {
        const res = {};
        let match32;
        while (match32 = CSS_REGEX.exec(style)) {
          res[match32[1]] = match32[2];
        }
        return res;
      };
      css = (a2, b2) => {
        if (isString(a2)) {
          if (isString(b2)) return `${a2};${b2}`;
          a2 = serialize(a2);
        } else if (isString(b2)) {
          b2 = serialize(b2);
        }
        return Object.assign({}, a2 != null ? a2 : {}, b2 != null ? b2 : {});
      };
      MachineStatus = /* @__PURE__ */ ((MachineStatus2) => {
        MachineStatus2["NotStarted"] = "Not Started";
        MachineStatus2["Started"] = "Started";
        MachineStatus2["Stopped"] = "Stopped";
        return MachineStatus2;
      })(MachineStatus || {});
      INIT_STATE = "__init__";
      createProps = () => (props15) => Array.from(new Set(props15));
      TRACK_MEMO_SYMBOL = Symbol();
      GET_ORIGINAL_SYMBOL = Symbol();
      getProto = Object.getPrototypeOf;
      objectsToTrack = /* @__PURE__ */ new WeakMap();
      isObjectToTrack = (obj) => obj && (objectsToTrack.has(obj) ? objectsToTrack.get(obj) : getProto(obj) === Object.prototype || getProto(obj) === Array.prototype);
      getUntracked = (obj) => {
        if (isObjectToTrack(obj)) {
          return obj[GET_ORIGINAL_SYMBOL] || null;
        }
        return null;
      };
      markToTrack = (obj, mark = true) => {
        objectsToTrack.set(obj, mark);
      };
      refSet = globalRef("__zag__refSet", () => /* @__PURE__ */ new WeakSet());
      isReactElement2 = (x2) => typeof x2 === "object" && x2 !== null && "$$typeof" in x2 && "props" in x2;
      isVueElement2 = (x2) => typeof x2 === "object" && x2 !== null && "__v_isVNode" in x2;
      isDOMElement = (x2) => typeof x2 === "object" && x2 !== null && "nodeType" in x2 && typeof x2.nodeName === "string";
      isElement = (x2) => isReactElement2(x2) || isVueElement2(x2) || isDOMElement(x2);
      isObject3 = (x2) => x2 !== null && typeof x2 === "object";
      canProxy = (x2) => isObject3(x2) && !refSet.has(x2) && (Array.isArray(x2) || !(Symbol.iterator in x2)) && !isElement(x2) && !(x2 instanceof WeakMap) && !(x2 instanceof WeakSet) && !(x2 instanceof Error) && !(x2 instanceof Number) && !(x2 instanceof Date) && !(x2 instanceof String) && !(x2 instanceof RegExp) && !(x2 instanceof ArrayBuffer) && !(x2 instanceof Promise) && !(x2 instanceof File) && !(x2 instanceof Blob) && !(x2 instanceof AbortController);
      isDev = () => true;
      proxyStateMap = globalRef("__zag__proxyStateMap", () => /* @__PURE__ */ new WeakMap());
      buildProxyFunction = (objectIs = Object.is, newProxy = (target, handler) => new Proxy(target, handler), snapCache = /* @__PURE__ */ new WeakMap(), createSnapshot = (target, version) => {
        const cache = snapCache.get(target);
        if ((cache == null ? void 0 : cache[0]) === version) {
          return cache[1];
        }
        const snap = Array.isArray(target) ? [] : Object.create(Object.getPrototypeOf(target));
        markToTrack(snap, true);
        snapCache.set(target, [version, snap]);
        Reflect.ownKeys(target).forEach((key) => {
          const value = Reflect.get(target, key);
          if (refSet.has(value)) {
            markToTrack(value, false);
            snap[key] = value;
          } else if (proxyStateMap.has(value)) {
            snap[key] = snapshot(value);
          } else {
            snap[key] = value;
          }
        });
        return Object.freeze(snap);
      }, proxyCache = /* @__PURE__ */ new WeakMap(), versionHolder = [1, 1], proxyFunction2 = (initialObject) => {
        if (!isObject3(initialObject)) {
          throw new Error("object required");
        }
        const found = proxyCache.get(initialObject);
        if (found) {
          return found;
        }
        let version = versionHolder[0];
        const listeners = /* @__PURE__ */ new Set();
        const notifyUpdate = (op, nextVersion = ++versionHolder[0]) => {
          if (version !== nextVersion) {
            version = nextVersion;
            listeners.forEach((listener) => listener(op, nextVersion));
          }
        };
        let checkVersion = versionHolder[1];
        const ensureVersion = (nextCheckVersion = ++versionHolder[1]) => {
          if (checkVersion !== nextCheckVersion && !listeners.size) {
            checkVersion = nextCheckVersion;
            propProxyStates.forEach(([propProxyState]) => {
              const propVersion = propProxyState[1](nextCheckVersion);
              if (propVersion > version) {
                version = propVersion;
              }
            });
          }
          return version;
        };
        const createPropListener = (prop) => (op, nextVersion) => {
          const newOp = [...op];
          newOp[1] = [prop, ...newOp[1]];
          notifyUpdate(newOp, nextVersion);
        };
        const propProxyStates = /* @__PURE__ */ new Map();
        const addPropListener = (prop, propProxyState) => {
          if (isDev() && propProxyStates.has(prop)) {
            throw new Error("prop listener already exists");
          }
          if (listeners.size) {
            const remove22 = propProxyState[3](createPropListener(prop));
            propProxyStates.set(prop, [propProxyState, remove22]);
          } else {
            propProxyStates.set(prop, [propProxyState]);
          }
        };
        const removePropListener = (prop) => {
          var _a;
          const entry = propProxyStates.get(prop);
          if (entry) {
            propProxyStates.delete(prop);
            (_a = entry[1]) == null ? void 0 : _a.call(entry);
          }
        };
        const addListener = (listener) => {
          listeners.add(listener);
          if (listeners.size === 1) {
            propProxyStates.forEach(([propProxyState, prevRemove], prop) => {
              if (isDev() && prevRemove) {
                throw new Error("remove already exists");
              }
              const remove22 = propProxyState[3](createPropListener(prop));
              propProxyStates.set(prop, [propProxyState, remove22]);
            });
          }
          const removeListener = () => {
            listeners.delete(listener);
            if (listeners.size === 0) {
              propProxyStates.forEach(([propProxyState, remove22], prop) => {
                if (remove22) {
                  remove22();
                  propProxyStates.set(prop, [propProxyState]);
                }
              });
            }
          };
          return removeListener;
        };
        const baseObject = Array.isArray(initialObject) ? [] : Object.create(Object.getPrototypeOf(initialObject));
        const handler = {
          deleteProperty(target, prop) {
            const prevValue = Reflect.get(target, prop);
            removePropListener(prop);
            const deleted = Reflect.deleteProperty(target, prop);
            if (deleted) {
              notifyUpdate(["delete", [prop], prevValue]);
            }
            return deleted;
          },
          set(target, prop, value, receiver) {
            var _a;
            const hasPrevValue = Reflect.has(target, prop);
            const prevValue = Reflect.get(target, prop, receiver);
            if (hasPrevValue && (objectIs(prevValue, value) || proxyCache.has(value) && objectIs(prevValue, proxyCache.get(value)))) {
              return true;
            }
            removePropListener(prop);
            if (isObject3(value)) {
              value = getUntracked(value) || value;
            }
            let nextValue = value;
            if ((_a = Object.getOwnPropertyDescriptor(target, prop)) == null ? void 0 : _a.set) ;
            else {
              if (!proxyStateMap.has(value) && canProxy(value)) {
                nextValue = proxy(value);
              }
              const childProxyState = !refSet.has(nextValue) && proxyStateMap.get(nextValue);
              if (childProxyState) {
                addPropListener(prop, childProxyState);
              }
            }
            Reflect.set(target, prop, nextValue, receiver);
            notifyUpdate(["set", [prop], value, prevValue]);
            return true;
          }
        };
        const proxyObject = newProxy(baseObject, handler);
        proxyCache.set(initialObject, proxyObject);
        const proxyState = [baseObject, ensureVersion, createSnapshot, addListener];
        proxyStateMap.set(proxyObject, proxyState);
        Reflect.ownKeys(initialObject).forEach((key) => {
          const desc = Object.getOwnPropertyDescriptor(initialObject, key);
          if (desc.get || desc.set) {
            Object.defineProperty(baseObject, key, desc);
          } else {
            proxyObject[key] = initialObject[key];
          }
        });
        return proxyObject;
      }) => [
        // public functions
        proxyFunction2,
        // shared state
        proxyStateMap,
        refSet,
        // internal things
        objectIs,
        newProxy,
        canProxy,
        snapCache,
        createSnapshot,
        proxyCache,
        versionHolder
      ];
      [proxyFunction] = buildProxyFunction();
      __defProp3 = Object.defineProperty;
      __defNormalProp3 = (obj, key, value) => key in obj ? __defProp3(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
      __publicField3 = (obj, key, value) => __defNormalProp3(obj, typeof key !== "symbol" ? key + "" : key, value);
      propMap = {
        onFocus: "onFocusin",
        onBlur: "onFocusout",
        onChange: "onInput",
        onDoubleClick: "onDblclick",
        htmlFor: "for",
        className: "class",
        defaultValue: "value",
        defaultChecked: "checked"
      };
      caseSensitiveSvgAttrs = /* @__PURE__ */ new Set(["viewBox", "preserveAspectRatio"]);
      toStyleString = (style) => {
        let string = "";
        for (let key in style) {
          const value = style[key];
          if (value === null || value === void 0) continue;
          if (!key.startsWith("--")) key = key.replace(/[A-Z]/g, (match32) => `-${match32.toLowerCase()}`);
          string += `${key}:${value};`;
        }
        return string;
      };
      normalizeProps = createNormalizer((props15) => {
        return Object.entries(props15).reduce((acc, [key, value]) => {
          if (value === void 0) return acc;
          if (key in propMap) {
            key = propMap[key];
          }
          if (key === "style" && typeof value === "object") {
            acc.style = toStyleString(value);
            return acc;
          }
          const normalizedKey = caseSensitiveSvgAttrs.has(key) ? key : key.toLowerCase();
          acc[normalizedKey] = value;
          return acc;
        }, {});
      });
      prevAttrsMap = /* @__PURE__ */ new WeakMap();
      assignableProps = /* @__PURE__ */ new Set(["value", "checked", "selected"]);
      caseSensitiveSvgAttrs2 = /* @__PURE__ */ new Set([
        "viewBox",
        "preserveAspectRatio",
        "clipPath",
        "clipRule",
        "fillRule",
        "strokeWidth",
        "strokeLinecap",
        "strokeLinejoin",
        "strokeDasharray",
        "strokeDashoffset",
        "strokeMiterlimit"
      ]);
      isSvgElement = (node) => {
        return node.tagName === "svg" || node.namespaceURI === "http://www.w3.org/2000/svg";
      };
      getAttributeName = (node, attrName) => {
        const shouldPreserveCase = isSvgElement(node) && caseSensitiveSvgAttrs2.has(attrName);
        return shouldPreserveCase ? attrName : attrName.toLowerCase();
      };
      bindable.cleanup = (_fn) => {
      };
      bindable.ref = (defaultValue) => {
        let value = defaultValue;
        return {
          get: () => value,
          set: (next2) => {
            value = next2;
          }
        };
      };
      VanillaMachine = class {
        constructor(machine16, userProps = {}) {
          var _a, _b, _c;
          this.machine = machine16;
          __publicField3(this, "scope");
          __publicField3(this, "context");
          __publicField3(this, "prop");
          __publicField3(this, "state");
          __publicField3(this, "refs");
          __publicField3(this, "computed");
          __publicField3(this, "event", { type: "" });
          __publicField3(this, "previousEvent", { type: "" });
          __publicField3(this, "effects", /* @__PURE__ */ new Map());
          __publicField3(this, "transition", null);
          __publicField3(this, "cleanups", []);
          __publicField3(this, "subscriptions", []);
          __publicField3(this, "userPropsRef");
          __publicField3(this, "getEvent", () => __spreadProps(__spreadValues({}, this.event), {
            current: () => this.event,
            previous: () => this.previousEvent
          }));
          __publicField3(this, "getStateConfig", (state3) => {
            return this.machine.states[state3];
          });
          __publicField3(this, "getState", () => __spreadProps(__spreadValues({}, this.state), {
            matches: (...values) => values.includes(this.state.get()),
            hasTag: (tag) => {
              var _a2, _b2;
              return !!((_b2 = (_a2 = this.getStateConfig(this.state.get())) == null ? void 0 : _a2.tags) == null ? void 0 : _b2.includes(tag));
            }
          }));
          __publicField3(this, "debug", (...args) => {
            if (this.machine.debug) console.log(...args);
          });
          __publicField3(this, "notify", () => {
            this.publish();
          });
          __publicField3(this, "send", (event) => {
            if (this.status !== MachineStatus.Started) return;
            queueMicrotask(() => {
              var _a2, _b2, _c2, _d, _e;
              if (!event) return;
              this.previousEvent = this.event;
              this.event = event;
              this.debug("send", event);
              let currentState = this.state.get();
              const eventType = event.type;
              const transitions = (_d = (_b2 = (_a2 = this.getStateConfig(currentState)) == null ? void 0 : _a2.on) == null ? void 0 : _b2[eventType]) != null ? _d : (_c2 = this.machine.on) == null ? void 0 : _c2[eventType];
              const transition = this.choose(transitions);
              if (!transition) return;
              this.transition = transition;
              const target = (_e = transition.target) != null ? _e : currentState;
              this.debug("transition", transition);
              const changed = target !== currentState;
              if (changed) {
                this.state.set(target);
              } else if (transition.reenter && !changed) {
                this.state.invoke(currentState, currentState);
              } else {
                this.action(transition.actions);
              }
            });
          });
          __publicField3(this, "action", (keys) => {
            const strs = isFunction(keys) ? keys(this.getParams()) : keys;
            if (!strs) return;
            const fns = strs.map((s2) => {
              var _a2, _b2;
              const fn = (_b2 = (_a2 = this.machine.implementations) == null ? void 0 : _a2.actions) == null ? void 0 : _b2[s2];
              if (!fn) warn(`[zag-js] No implementation found for action "${JSON.stringify(s2)}"`);
              return fn;
            });
            for (const fn of fns) {
              fn == null ? void 0 : fn(this.getParams());
            }
          });
          __publicField3(this, "guard", (str) => {
            var _a2, _b2;
            if (isFunction(str)) return str(this.getParams());
            return (_b2 = (_a2 = this.machine.implementations) == null ? void 0 : _a2.guards) == null ? void 0 : _b2[str](this.getParams());
          });
          __publicField3(this, "effect", (keys) => {
            const strs = isFunction(keys) ? keys(this.getParams()) : keys;
            if (!strs) return;
            const fns = strs.map((s2) => {
              var _a2, _b2;
              const fn = (_b2 = (_a2 = this.machine.implementations) == null ? void 0 : _a2.effects) == null ? void 0 : _b2[s2];
              if (!fn) warn(`[zag-js] No implementation found for effect "${JSON.stringify(s2)}"`);
              return fn;
            });
            const cleanups = [];
            for (const fn of fns) {
              const cleanup = fn == null ? void 0 : fn(this.getParams());
              if (cleanup) cleanups.push(cleanup);
            }
            return () => cleanups.forEach((fn) => fn == null ? void 0 : fn());
          });
          __publicField3(this, "choose", (transitions) => {
            return toArray(transitions).find((t2) => {
              let result = !t2.guard;
              if (isString(t2.guard)) result = !!this.guard(t2.guard);
              else if (isFunction(t2.guard)) result = t2.guard(this.getParams());
              return result;
            });
          });
          __publicField3(this, "subscribe", (fn) => {
            this.subscriptions.push(fn);
            return () => {
              const index = this.subscriptions.indexOf(fn);
              if (index > -1) this.subscriptions.splice(index, 1);
            };
          });
          __publicField3(this, "status", MachineStatus.NotStarted);
          __publicField3(this, "publish", () => {
            this.callTrackers();
            this.subscriptions.forEach((fn) => fn(this.service));
          });
          __publicField3(this, "trackers", []);
          __publicField3(this, "setupTrackers", () => {
            var _a2, _b2;
            (_b2 = (_a2 = this.machine).watch) == null ? void 0 : _b2.call(_a2, this.getParams());
          });
          __publicField3(this, "callTrackers", () => {
            this.trackers.forEach(({ deps, fn }) => {
              const next2 = deps.map((dep) => dep());
              if (!isEqual2(fn.prev, next2)) {
                fn();
                fn.prev = next2;
              }
            });
          });
          __publicField3(this, "getParams", () => ({
            state: this.getState(),
            context: this.context,
            event: this.getEvent(),
            prop: this.prop,
            send: this.send,
            action: this.action,
            guard: this.guard,
            track: (deps, fn) => {
              fn.prev = deps.map((dep) => dep());
              this.trackers.push({ deps, fn });
            },
            refs: this.refs,
            computed: this.computed,
            flush: identity,
            scope: this.scope,
            choose: this.choose
          }));
          this.userPropsRef = { current: userProps };
          const { id, ids, getRootNode: getRootNode2 } = runIfFn(userProps);
          this.scope = createScope({ id, ids, getRootNode: getRootNode2 });
          const prop = (key) => {
            var _a2, _b2;
            const __props = runIfFn(this.userPropsRef.current);
            const props15 = (_b2 = (_a2 = machine16.props) == null ? void 0 : _a2.call(machine16, { props: compact(__props), scope: this.scope })) != null ? _b2 : __props;
            return props15[key];
          };
          this.prop = prop;
          const context = (_a = machine16.context) == null ? void 0 : _a.call(machine16, {
            prop,
            bindable,
            scope: this.scope,
            flush(fn) {
              queueMicrotask(fn);
            },
            getContext() {
              return ctx;
            },
            getComputed() {
              return computed;
            },
            getRefs() {
              return refs;
            },
            getEvent: this.getEvent.bind(this)
          });
          if (context) {
            Object.values(context).forEach((item) => {
              const unsub = subscribe(item.ref, () => this.notify());
              this.cleanups.push(unsub);
            });
          }
          const ctx = {
            get(key) {
              return context == null ? void 0 : context[key].get();
            },
            set(key, value) {
              context == null ? void 0 : context[key].set(value);
            },
            initial(key) {
              return context == null ? void 0 : context[key].initial;
            },
            hash(key) {
              const current = context == null ? void 0 : context[key].get();
              return context == null ? void 0 : context[key].hash(current);
            }
          };
          this.context = ctx;
          const computed = (key) => {
            var _a2, _b2;
            return (_b2 = (_a2 = machine16.computed) == null ? void 0 : _a2[key]({
              context: ctx,
              event: this.getEvent(),
              prop,
              refs: this.refs,
              scope: this.scope,
              computed
            })) != null ? _b2 : {};
          };
          this.computed = computed;
          const refs = createRefs((_c = (_b = machine16.refs) == null ? void 0 : _b.call(machine16, { prop, context: ctx })) != null ? _c : {});
          this.refs = refs;
          const state2 = bindable(() => ({
            defaultValue: machine16.initialState({ prop }),
            onChange: (nextState, prevState) => {
              var _a2, _b2, _c2, _d;
              if (prevState) {
                const exitEffects = this.effects.get(prevState);
                exitEffects == null ? void 0 : exitEffects();
                this.effects.delete(prevState);
              }
              if (prevState) {
                this.action((_a2 = this.getStateConfig(prevState)) == null ? void 0 : _a2.exit);
              }
              this.action((_b2 = this.transition) == null ? void 0 : _b2.actions);
              const cleanup = this.effect((_c2 = this.getStateConfig(nextState)) == null ? void 0 : _c2.effects);
              if (cleanup) this.effects.set(nextState, cleanup);
              if (prevState === INIT_STATE) {
                this.action(machine16.entry);
                const cleanup2 = this.effect(machine16.effects);
                if (cleanup2) this.effects.set(INIT_STATE, cleanup2);
              }
              this.action((_d = this.getStateConfig(nextState)) == null ? void 0 : _d.entry);
            }
          }));
          this.state = state2;
          this.cleanups.push(subscribe(this.state.ref, () => this.notify()));
        }
        updateProps(newProps) {
          const prevSource = this.userPropsRef.current;
          this.userPropsRef.current = () => {
            const prev2 = runIfFn(prevSource);
            const next2 = runIfFn(newProps);
            return mergeMachineProps(prev2, next2);
          };
          this.notify();
        }
        start() {
          this.status = MachineStatus.Started;
          this.debug("initializing...");
          this.state.invoke(this.state.initial, INIT_STATE);
          this.setupTrackers();
        }
        stop() {
          this.effects.forEach((fn) => fn == null ? void 0 : fn());
          this.effects.clear();
          this.transition = null;
          this.action(this.machine.exit);
          this.cleanups.forEach((unsub) => unsub());
          this.cleanups = [];
          this.subscriptions = [];
          this.status = MachineStatus.Stopped;
          this.debug("unmounting...");
        }
        get service() {
          return {
            state: this.getState(),
            send: this.send,
            context: this.context,
            prop: this.prop,
            scope: this.scope,
            refs: this.refs,
            computed: this.computed,
            event: this.getEvent(),
            getStatus: () => this.status
          };
        }
      };
      Component = class {
        constructor(el, props15) {
          __publicField(this, "el");
          __publicField(this, "doc");
          // eslint-disable-next-line @typescript-eslint/no-explicit-any
          __publicField(this, "machine");
          __publicField(this, "api");
          __publicField(this, "init", () => {
            this.render();
            this.machine.subscribe(() => {
              this.api = this.initApi();
              this.render();
            });
            this.machine.start();
          });
          __publicField(this, "destroy", () => {
            this.machine.stop();
          });
          __publicField(this, "spreadProps", (el, props15) => {
            spreadProps(el, props15, this.machine.scope.id);
          });
          __publicField(this, "updateProps", (props15) => {
            this.machine.updateProps(props15);
          });
          if (!el) throw new Error("Root element not found");
          this.el = el;
          this.doc = document;
          this.machine = this.initMachine(props15);
          this.api = this.initApi();
        }
      };
    }
  });

  // ../priv/static/accordion.mjs
  var accordion_exports = {};
  __export(accordion_exports, {
    Accordion: () => AccordionHook
  });
  function connect(service, normalize) {
    const { send, context, prop, scope, computed } = service;
    const focusedValue = context.get("focusedValue");
    const value = context.get("value");
    const multiple = prop("multiple");
    function setValue(value2) {
      let nextValue = value2;
      if (!multiple && nextValue.length > 1) {
        nextValue = [nextValue[0]];
      }
      send({ type: "VALUE.SET", value: nextValue });
    }
    function getItemState(props22) {
      var _a;
      return {
        expanded: value.includes(props22.value),
        focused: focusedValue === props22.value,
        disabled: Boolean((_a = props22.disabled) != null ? _a : prop("disabled"))
      };
    }
    return {
      focusedValue,
      value,
      setValue,
      getItemState,
      getRootProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts.root.attrs), {
          dir: prop("dir"),
          id: getRootId(scope),
          "data-orientation": prop("orientation")
        }));
      },
      getItemProps(props22) {
        const itemState = getItemState(props22);
        return normalize.element(__spreadProps(__spreadValues({}, parts.item.attrs), {
          dir: prop("dir"),
          id: getItemId(scope, props22.value),
          "data-state": itemState.expanded ? "open" : "closed",
          "data-focus": dataAttr(itemState.focused),
          "data-disabled": dataAttr(itemState.disabled),
          "data-orientation": prop("orientation")
        }));
      },
      getItemContentProps(props22) {
        const itemState = getItemState(props22);
        return normalize.element(__spreadProps(__spreadValues({}, parts.itemContent.attrs), {
          dir: prop("dir"),
          role: "region",
          id: getItemContentId(scope, props22.value),
          "aria-labelledby": getItemTriggerId(scope, props22.value),
          hidden: !itemState.expanded,
          "data-state": itemState.expanded ? "open" : "closed",
          "data-disabled": dataAttr(itemState.disabled),
          "data-focus": dataAttr(itemState.focused),
          "data-orientation": prop("orientation")
        }));
      },
      getItemIndicatorProps(props22) {
        const itemState = getItemState(props22);
        return normalize.element(__spreadProps(__spreadValues({}, parts.itemIndicator.attrs), {
          dir: prop("dir"),
          "aria-hidden": true,
          "data-state": itemState.expanded ? "open" : "closed",
          "data-disabled": dataAttr(itemState.disabled),
          "data-focus": dataAttr(itemState.focused),
          "data-orientation": prop("orientation")
        }));
      },
      getItemTriggerProps(props22) {
        const { value: value2 } = props22;
        const itemState = getItemState(props22);
        return normalize.button(__spreadProps(__spreadValues({}, parts.itemTrigger.attrs), {
          type: "button",
          dir: prop("dir"),
          id: getItemTriggerId(scope, value2),
          "aria-controls": getItemContentId(scope, value2),
          "data-controls": getItemContentId(scope, value2),
          "aria-expanded": itemState.expanded,
          disabled: itemState.disabled,
          "data-orientation": prop("orientation"),
          "aria-disabled": itemState.disabled,
          "data-state": itemState.expanded ? "open" : "closed",
          "data-ownedby": getRootId(scope),
          onFocus() {
            if (itemState.disabled) return;
            send({ type: "TRIGGER.FOCUS", value: value2 });
          },
          onBlur() {
            if (itemState.disabled) return;
            send({ type: "TRIGGER.BLUR" });
          },
          onClick(event) {
            if (itemState.disabled) return;
            if (isSafari()) {
              event.currentTarget.focus();
            }
            send({ type: "TRIGGER.CLICK", value: value2 });
          },
          onKeyDown(event) {
            if (event.defaultPrevented) return;
            if (itemState.disabled) return;
            const keyMap2 = {
              ArrowDown() {
                if (computed("isHorizontal")) return;
                send({ type: "GOTO.NEXT", value: value2 });
              },
              ArrowUp() {
                if (computed("isHorizontal")) return;
                send({ type: "GOTO.PREV", value: value2 });
              },
              ArrowRight() {
                if (!computed("isHorizontal")) return;
                send({ type: "GOTO.NEXT", value: value2 });
              },
              ArrowLeft() {
                if (!computed("isHorizontal")) return;
                send({ type: "GOTO.PREV", value: value2 });
              },
              Home() {
                send({ type: "GOTO.FIRST", value: value2 });
              },
              End() {
                send({ type: "GOTO.LAST", value: value2 });
              }
            };
            const key = getEventKey(event, {
              dir: prop("dir"),
              orientation: prop("orientation")
            });
            const exec = keyMap2[key];
            if (exec) {
              exec(event);
              event.preventDefault();
            }
          }
        }));
      }
    };
  }
  var anatomy, parts, getRootId, getItemId, getItemContentId, getItemTriggerId, getRootEl, getTriggerEls, getFirstTriggerEl, getLastTriggerEl, getNextTriggerEl, getPrevTriggerEl, and, not, machine, props, splitProps2, itemProps, splitItemProps, Accordion, AccordionHook;
  var init_accordion = __esm({
    "../priv/static/accordion.mjs"() {
      "use strict";
      init_chunk_GFGFZBBD();
      anatomy = createAnatomy("accordion").parts("root", "item", "itemTrigger", "itemContent", "itemIndicator");
      parts = anatomy.build();
      getRootId = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.root) != null ? _b : `accordion:${ctx.id}`;
      };
      getItemId = (ctx, value) => {
        var _a, _b, _c;
        return (_c = (_b = (_a = ctx.ids) == null ? void 0 : _a.item) == null ? void 0 : _b.call(_a, value)) != null ? _c : `accordion:${ctx.id}:item:${value}`;
      };
      getItemContentId = (ctx, value) => {
        var _a, _b, _c;
        return (_c = (_b = (_a = ctx.ids) == null ? void 0 : _a.itemContent) == null ? void 0 : _b.call(_a, value)) != null ? _c : `accordion:${ctx.id}:content:${value}`;
      };
      getItemTriggerId = (ctx, value) => {
        var _a, _b, _c;
        return (_c = (_b = (_a = ctx.ids) == null ? void 0 : _a.itemTrigger) == null ? void 0 : _b.call(_a, value)) != null ? _c : `accordion:${ctx.id}:trigger:${value}`;
      };
      getRootEl = (ctx) => ctx.getById(getRootId(ctx));
      getTriggerEls = (ctx) => {
        const ownerId = CSS.escape(getRootId(ctx));
        const selector = `[data-controls][data-ownedby='${ownerId}']:not([disabled])`;
        return queryAll(getRootEl(ctx), selector);
      };
      getFirstTriggerEl = (ctx) => first(getTriggerEls(ctx));
      getLastTriggerEl = (ctx) => last(getTriggerEls(ctx));
      getNextTriggerEl = (ctx, id) => nextById(getTriggerEls(ctx), getItemTriggerId(ctx, id));
      getPrevTriggerEl = (ctx, id) => prevById(getTriggerEls(ctx), getItemTriggerId(ctx, id));
      ({ and, not } = createGuards());
      machine = createMachine({
        props({ props: props22 }) {
          return __spreadValues({
            collapsible: false,
            multiple: false,
            orientation: "vertical",
            defaultValue: []
          }, props22);
        },
        initialState() {
          return "idle";
        },
        context({ prop, bindable: bindable2 }) {
          return {
            focusedValue: bindable2(() => ({
              defaultValue: null,
              sync: true,
              onChange(value) {
                var _a;
                (_a = prop("onFocusChange")) == null ? void 0 : _a({ value });
              }
            })),
            value: bindable2(() => ({
              defaultValue: prop("defaultValue"),
              value: prop("value"),
              onChange(value) {
                var _a;
                (_a = prop("onValueChange")) == null ? void 0 : _a({ value });
              }
            }))
          };
        },
        computed: {
          isHorizontal: ({ prop }) => prop("orientation") === "horizontal"
        },
        on: {
          "VALUE.SET": {
            actions: ["setValue"]
          }
        },
        states: {
          idle: {
            on: {
              "TRIGGER.FOCUS": {
                target: "focused",
                actions: ["setFocusedValue"]
              }
            }
          },
          focused: {
            on: {
              "GOTO.NEXT": {
                actions: ["focusNextTrigger"]
              },
              "GOTO.PREV": {
                actions: ["focusPrevTrigger"]
              },
              "TRIGGER.CLICK": [
                {
                  guard: and("isExpanded", "canToggle"),
                  actions: ["collapse"]
                },
                {
                  guard: not("isExpanded"),
                  actions: ["expand"]
                }
              ],
              "GOTO.FIRST": {
                actions: ["focusFirstTrigger"]
              },
              "GOTO.LAST": {
                actions: ["focusLastTrigger"]
              },
              "TRIGGER.BLUR": {
                target: "idle",
                actions: ["clearFocusedValue"]
              }
            }
          }
        },
        implementations: {
          guards: {
            canToggle: ({ prop }) => !!prop("collapsible") || !!prop("multiple"),
            isExpanded: ({ context, event }) => context.get("value").includes(event.value)
          },
          actions: {
            collapse({ context, prop, event }) {
              const next2 = prop("multiple") ? remove(context.get("value"), event.value) : [];
              context.set("value", next2);
            },
            expand({ context, prop, event }) {
              const next2 = prop("multiple") ? add(context.get("value"), event.value) : [event.value];
              context.set("value", next2);
            },
            focusFirstTrigger({ scope }) {
              var _a;
              (_a = getFirstTriggerEl(scope)) == null ? void 0 : _a.focus();
            },
            focusLastTrigger({ scope }) {
              var _a;
              (_a = getLastTriggerEl(scope)) == null ? void 0 : _a.focus();
            },
            focusNextTrigger({ context, scope }) {
              const focusedValue = context.get("focusedValue");
              if (!focusedValue) return;
              const triggerEl = getNextTriggerEl(scope, focusedValue);
              triggerEl == null ? void 0 : triggerEl.focus();
            },
            focusPrevTrigger({ context, scope }) {
              const focusedValue = context.get("focusedValue");
              if (!focusedValue) return;
              const triggerEl = getPrevTriggerEl(scope, focusedValue);
              triggerEl == null ? void 0 : triggerEl.focus();
            },
            setFocusedValue({ context, event }) {
              context.set("focusedValue", event.value);
            },
            clearFocusedValue({ context }) {
              context.set("focusedValue", null);
            },
            setValue({ context, event }) {
              context.set("value", event.value);
            },
            coarseValue({ context, prop }) {
              if (!prop("multiple") && context.get("value").length > 1) {
                warn(`The value of accordion should be a single value when multiple is false.`);
                context.set("value", [context.get("value")[0]]);
              }
            }
          }
        }
      });
      props = createProps()([
        "collapsible",
        "dir",
        "disabled",
        "getRootNode",
        "id",
        "ids",
        "multiple",
        "onFocusChange",
        "onValueChange",
        "orientation",
        "value",
        "defaultValue"
      ]);
      splitProps2 = createSplitProps(props);
      itemProps = createProps()(["value", "disabled"]);
      splitItemProps = createSplitProps(itemProps);
      Accordion = class extends Component {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        initMachine(props22) {
          return new VanillaMachine(machine, props22);
        }
        initApi() {
          return connect(this.machine.service, normalizeProps);
        }
        render() {
          var _a;
          const rootEl = (_a = this.el.querySelector('[data-scope="accordion"][data-part="root"]')) != null ? _a : this.el;
          this.spreadProps(rootEl, this.api.getRootProps());
          const itemsList = this.getItemsList();
          const itemEls = rootEl.querySelectorAll(
            '[data-scope="accordion"][data-part="item"]'
          );
          for (let i2 = 0; i2 < itemEls.length; i2++) {
            const itemEl = itemEls[i2];
            const itemData = itemsList[i2];
            if (!(itemData == null ? void 0 : itemData.value)) continue;
            const { value, disabled } = itemData;
            this.spreadProps(itemEl, this.api.getItemProps({ value, disabled }));
            const triggerEl = itemEl.querySelector('[data-scope="accordion"][data-part="item-trigger"]');
            if (triggerEl) {
              this.spreadProps(triggerEl, this.api.getItemTriggerProps({ value, disabled }));
            }
            const indicatorEl = itemEl.querySelector('[data-scope="accordion"][data-part="item-indicator"]');
            if (indicatorEl) {
              this.spreadProps(indicatorEl, this.api.getItemIndicatorProps({ value, disabled }));
            }
            const contentEl = itemEl.querySelector('[data-scope="accordion"][data-part="item-content"]');
            if (contentEl) {
              this.spreadProps(contentEl, this.api.getItemContentProps({ value, disabled }));
            }
          }
        }
        getItemsList() {
          const raw = this.el.getAttribute("data-items");
          if (!raw) return [];
          try {
            return JSON.parse(raw);
          } catch (e2) {
            return [];
          }
        }
      };
      AccordionHook = {
        mounted() {
          const el = this.el;
          const pushEvent = this.pushEvent.bind(this);
          const accordion = new Accordion(
            el,
            __spreadProps(__spreadValues({
              id: el.id
            }, getBoolean(el, "controlled") ? { value: getStringList(el, "value") } : { defaultValue: getStringList(el, "defaultValue") }), {
              collapsible: getBoolean(el, "collapsible"),
              multiple: getBoolean(el, "multiple"),
              orientation: getString(el, "orientation", ["horizontal", "vertical"]),
              dir: getDir(el),
              onValueChange: (details) => {
                var _a, _b;
                const eventName = getString(el, "onValueChange");
                if (eventName && this.liveSocket.main.isConnected()) {
                  pushEvent(eventName, {
                    id: el.id,
                    value: (_a = details.value) != null ? _a : null
                  });
                }
                const eventNameClient = getString(el, "onValueChangeClient");
                if (eventNameClient) {
                  el.dispatchEvent(
                    new CustomEvent(eventNameClient, {
                      bubbles: true,
                      detail: {
                        id: el.id,
                        value: (_b = details.value) != null ? _b : null
                      }
                    })
                  );
                }
              },
              onFocusChange: (details) => {
                var _a, _b;
                const eventName = getString(el, "onFocusChange");
                if (eventName && this.liveSocket.main.isConnected()) {
                  pushEvent(eventName, {
                    id: el.id,
                    value: (_a = details.value) != null ? _a : null
                  });
                }
                const eventNameClient = getString(el, "onFocusChangeClient");
                if (eventNameClient) {
                  el.dispatchEvent(
                    new CustomEvent(eventNameClient, {
                      bubbles: true,
                      detail: {
                        id: el.id,
                        value: (_b = details.value) != null ? _b : null
                      }
                    })
                  );
                }
              }
            })
          );
          accordion.init();
          this.accordion = accordion;
          this.onSetValue = (event) => {
            const { value } = event.detail;
            accordion.api.setValue(value);
          };
          el.addEventListener("phx:accordion:set-value", this.onSetValue);
          this.handlers = [];
          this.handlers.push(
            this.handleEvent(
              "accordion_set_value",
              (payload) => {
                const targetId = payload.accordion_id;
                if (targetId) {
                  const matches = el.id === targetId || el.id === `accordion:${targetId}`;
                  if (!matches) return;
                }
                accordion.api.setValue(payload.value);
              }
            )
          );
          this.handlers.push(
            this.handleEvent("accordion_value", () => {
              this.pushEvent("accordion_value_response", {
                value: accordion.api.value
              });
            })
          );
          this.handlers.push(
            this.handleEvent("accordion_focused_value", () => {
              this.pushEvent("accordion_focused_value_response", {
                value: accordion.api.focusedValue
              });
            })
          );
        },
        updated() {
          var _a, _b, _c, _d;
          const controlled = getBoolean(this.el, "controlled");
          (_d = this.accordion) == null ? void 0 : _d.updateProps(__spreadProps(__spreadValues({
            id: this.el.id
          }, controlled ? { value: getStringList(this.el, "value") } : {
            defaultValue: (_c = (_b = (_a = this.accordion) == null ? void 0 : _a.api) == null ? void 0 : _b.value) != null ? _c : getStringList(this.el, "defaultValue")
          }), {
            collapsible: getBoolean(this.el, "collapsible"),
            multiple: getBoolean(this.el, "multiple"),
            orientation: getString(this.el, "orientation", ["horizontal", "vertical"]),
            dir: getDir(this.el)
          }));
        },
        destroyed() {
          var _a;
          if (this.onSetValue) {
            this.el.removeEventListener("phx:accordion:set-value", this.onSetValue);
          }
          if (this.handlers) {
            for (const handler of this.handlers) {
              this.removeHandleEvent(handler);
            }
          }
          (_a = this.accordion) == null ? void 0 : _a.destroy();
        }
      };
    }
  });

  // ../priv/static/chunk-EAMC7PNF.mjs
  function isValidKey(e2) {
    return !(e2.metaKey || !isMac() && e2.altKey || e2.ctrlKey || e2.key === "Control" || e2.key === "Shift" || e2.key === "Meta");
  }
  function isKeyboardFocusEvent(isTextInput, modality, e2) {
    const target = e2 ? getEventTarget(e2) : null;
    const win = getWindow(target);
    isTextInput = isTextInput || target instanceof win.HTMLInputElement && !nonTextInputTypes.has(target == null ? void 0 : target.type) || target instanceof win.HTMLTextAreaElement || target instanceof win.HTMLElement && target.isContentEditable;
    return !(isTextInput && modality === "keyboard" && e2 instanceof win.KeyboardEvent && !Reflect.has(FOCUS_VISIBLE_INPUT_KEYS, e2.key));
  }
  function triggerChangeHandlers(modality, e2) {
    for (let handler of changeHandlers) {
      handler(modality, e2);
    }
  }
  function handleKeyboardEvent(e2) {
    hasEventBeforeFocus = true;
    if (isValidKey(e2)) {
      currentModality = "keyboard";
      triggerChangeHandlers("keyboard", e2);
    }
  }
  function handlePointerEvent(e2) {
    currentModality = "pointer";
    if (e2.type === "mousedown" || e2.type === "pointerdown") {
      hasEventBeforeFocus = true;
      triggerChangeHandlers("pointer", e2);
    }
  }
  function handleClickEvent(e2) {
    if (isVirtualClick(e2)) {
      hasEventBeforeFocus = true;
      currentModality = "virtual";
    }
  }
  function handleFocusEvent(e2) {
    const target = getEventTarget(e2);
    if (target === getWindow(target) || target === getDocument(target)) {
      return;
    }
    if (!hasEventBeforeFocus && !hasBlurredWindowRecently) {
      currentModality = "virtual";
      triggerChangeHandlers("virtual", e2);
    }
    hasEventBeforeFocus = false;
    hasBlurredWindowRecently = false;
  }
  function handleWindowBlur() {
    hasEventBeforeFocus = false;
    hasBlurredWindowRecently = true;
  }
  function setupGlobalFocusEvents(root) {
    if (typeof window === "undefined" || listenerMap.get(getWindow(root))) {
      return;
    }
    const win = getWindow(root);
    const doc = getDocument(root);
    let focus = win.HTMLElement.prototype.focus;
    function patchedFocus() {
      currentModality = "virtual";
      triggerChangeHandlers("virtual", null);
      hasEventBeforeFocus = true;
      focus.apply(this, arguments);
    }
    try {
      Object.defineProperty(win.HTMLElement.prototype, "focus", {
        configurable: true,
        value: patchedFocus
      });
    } catch (e2) {
    }
    doc.addEventListener("keydown", handleKeyboardEvent, true);
    doc.addEventListener("keyup", handleKeyboardEvent, true);
    doc.addEventListener("click", handleClickEvent, true);
    win.addEventListener("focus", handleFocusEvent, true);
    win.addEventListener("blur", handleWindowBlur, false);
    if (typeof win.PointerEvent !== "undefined") {
      doc.addEventListener("pointerdown", handlePointerEvent, true);
      doc.addEventListener("pointermove", handlePointerEvent, true);
      doc.addEventListener("pointerup", handlePointerEvent, true);
    } else {
      doc.addEventListener("mousedown", handlePointerEvent, true);
      doc.addEventListener("mousemove", handlePointerEvent, true);
      doc.addEventListener("mouseup", handlePointerEvent, true);
    }
    win.addEventListener(
      "beforeunload",
      () => {
        tearDownWindowFocusTracking(root);
      },
      { once: true }
    );
    listenerMap.set(win, { focus });
  }
  function isFocusVisible() {
    return currentModality === "keyboard";
  }
  function trackFocusVisible(props15 = {}) {
    const { isTextInput, autoFocus, onChange, root } = props15;
    setupGlobalFocusEvents(root);
    onChange == null ? void 0 : onChange({ isFocusVisible: autoFocus || isFocusVisible(), modality: currentModality });
    const handler = (modality, e2) => {
      if (!isKeyboardFocusEvent(!!isTextInput, modality, e2)) return;
      onChange == null ? void 0 : onChange({ isFocusVisible: isFocusVisible(), modality });
    };
    changeHandlers.add(handler);
    return () => {
      changeHandlers.delete(handler);
    };
  }
  var nonTextInputTypes, currentModality, changeHandlers, listenerMap, hasEventBeforeFocus, hasBlurredWindowRecently, FOCUS_VISIBLE_INPUT_KEYS, tearDownWindowFocusTracking;
  var init_chunk_EAMC7PNF = __esm({
    "../priv/static/chunk-EAMC7PNF.mjs"() {
      "use strict";
      init_chunk_GFGFZBBD();
      nonTextInputTypes = /* @__PURE__ */ new Set(["checkbox", "radio", "range", "color", "file", "image", "button", "submit", "reset"]);
      currentModality = null;
      changeHandlers = /* @__PURE__ */ new Set();
      listenerMap = /* @__PURE__ */ new Map();
      hasEventBeforeFocus = false;
      hasBlurredWindowRecently = false;
      FOCUS_VISIBLE_INPUT_KEYS = {
        Tab: true,
        Escape: true
      };
      tearDownWindowFocusTracking = (root, loadListener) => {
        const win = getWindow(root);
        const doc = getDocument(root);
        const listenerData = listenerMap.get(win);
        if (!listenerData) {
          return;
        }
        try {
          Object.defineProperty(win.HTMLElement.prototype, "focus", {
            configurable: true,
            value: listenerData.focus
          });
        } catch (e2) {
        }
        doc.removeEventListener("keydown", handleKeyboardEvent, true);
        doc.removeEventListener("keyup", handleKeyboardEvent, true);
        doc.removeEventListener("click", handleClickEvent, true);
        win.removeEventListener("focus", handleFocusEvent, true);
        win.removeEventListener("blur", handleWindowBlur, false);
        if (typeof win.PointerEvent !== "undefined") {
          doc.removeEventListener("pointerdown", handlePointerEvent, true);
          doc.removeEventListener("pointermove", handlePointerEvent, true);
          doc.removeEventListener("pointerup", handlePointerEvent, true);
        } else {
          doc.removeEventListener("mousedown", handlePointerEvent, true);
          doc.removeEventListener("mousemove", handlePointerEvent, true);
          doc.removeEventListener("mouseup", handlePointerEvent, true);
        }
        listenerMap.delete(win);
      };
    }
  });

  // ../priv/static/checkbox.mjs
  var checkbox_exports = {};
  __export(checkbox_exports, {
    Checkbox: () => CheckboxHook
  });
  function connect2(service, normalize) {
    const { send, context, prop, computed, scope } = service;
    const disabled = !!prop("disabled");
    const readOnly = !!prop("readOnly");
    const required = !!prop("required");
    const invalid = !!prop("invalid");
    const focused = !disabled && context.get("focused");
    const focusVisible = !disabled && context.get("focusVisible");
    const checked = computed("checked");
    const indeterminate = computed("indeterminate");
    const checkedState = context.get("checked");
    const dataAttrs = {
      "data-active": dataAttr(context.get("active")),
      "data-focus": dataAttr(focused),
      "data-focus-visible": dataAttr(focusVisible),
      "data-readonly": dataAttr(readOnly),
      "data-hover": dataAttr(context.get("hovered")),
      "data-disabled": dataAttr(disabled),
      "data-state": indeterminate ? "indeterminate" : checked ? "checked" : "unchecked",
      "data-invalid": dataAttr(invalid),
      "data-required": dataAttr(required)
    };
    return {
      checked,
      disabled,
      indeterminate,
      focused,
      checkedState,
      setChecked(checked2) {
        send({ type: "CHECKED.SET", checked: checked2, isTrusted: false });
      },
      toggleChecked() {
        send({ type: "CHECKED.TOGGLE", checked, isTrusted: false });
      },
      getRootProps() {
        return normalize.label(__spreadProps(__spreadValues(__spreadValues({}, parts2.root.attrs), dataAttrs), {
          dir: prop("dir"),
          id: getRootId2(scope),
          htmlFor: getHiddenInputId(scope),
          onPointerMove() {
            if (disabled) return;
            send({ type: "CONTEXT.SET", context: { hovered: true } });
          },
          onPointerLeave() {
            if (disabled) return;
            send({ type: "CONTEXT.SET", context: { hovered: false } });
          },
          onClick(event) {
            const target = getEventTarget(event);
            if (target === getHiddenInputEl(scope)) {
              event.stopPropagation();
            }
          }
        }));
      },
      getLabelProps() {
        return normalize.element(__spreadProps(__spreadValues(__spreadValues({}, parts2.label.attrs), dataAttrs), {
          dir: prop("dir"),
          id: getLabelId(scope)
        }));
      },
      getControlProps() {
        return normalize.element(__spreadProps(__spreadValues(__spreadValues({}, parts2.control.attrs), dataAttrs), {
          dir: prop("dir"),
          id: getControlId(scope),
          "aria-hidden": true
        }));
      },
      getIndicatorProps() {
        return normalize.element(__spreadProps(__spreadValues(__spreadValues({}, parts2.indicator.attrs), dataAttrs), {
          dir: prop("dir"),
          hidden: !indeterminate && !checked
        }));
      },
      getHiddenInputProps() {
        return normalize.input({
          id: getHiddenInputId(scope),
          type: "checkbox",
          required: prop("required"),
          defaultChecked: checked,
          disabled,
          "aria-labelledby": getLabelId(scope),
          "aria-invalid": invalid,
          name: prop("name"),
          form: prop("form"),
          value: prop("value"),
          style: visuallyHiddenStyle,
          onFocus() {
            const focusVisible2 = isFocusVisible();
            send({ type: "CONTEXT.SET", context: { focused: true, focusVisible: focusVisible2 } });
          },
          onBlur() {
            send({ type: "CONTEXT.SET", context: { focused: false, focusVisible: false } });
          },
          onClick(event) {
            if (readOnly) {
              event.preventDefault();
              return;
            }
            const checked2 = event.currentTarget.checked;
            send({ type: "CHECKED.SET", checked: checked2, isTrusted: true });
          }
        });
      }
    };
  }
  function isIndeterminate(checked) {
    return checked === "indeterminate";
  }
  function isChecked(checked) {
    return isIndeterminate(checked) ? false : !!checked;
  }
  var anatomy2, parts2, getRootId2, getLabelId, getControlId, getHiddenInputId, getRootEl2, getHiddenInputEl, not2, machine2, props2, splitProps3, Checkbox, CheckboxHook;
  var init_checkbox = __esm({
    "../priv/static/checkbox.mjs"() {
      "use strict";
      init_chunk_EAMC7PNF();
      init_chunk_GFGFZBBD();
      anatomy2 = createAnatomy("checkbox").parts("root", "label", "control", "indicator");
      parts2 = anatomy2.build();
      getRootId2 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.root) != null ? _b : `checkbox:${ctx.id}`;
      };
      getLabelId = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.label) != null ? _b : `checkbox:${ctx.id}:label`;
      };
      getControlId = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.control) != null ? _b : `checkbox:${ctx.id}:control`;
      };
      getHiddenInputId = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.hiddenInput) != null ? _b : `checkbox:${ctx.id}:input`;
      };
      getRootEl2 = (ctx) => ctx.getById(getRootId2(ctx));
      getHiddenInputEl = (ctx) => ctx.getById(getHiddenInputId(ctx));
      ({ not: not2 } = createGuards());
      machine2 = createMachine({
        props({ props: props22 }) {
          var _a;
          return __spreadProps(__spreadValues({
            value: "on"
          }, props22), {
            defaultChecked: (_a = props22.defaultChecked) != null ? _a : false
          });
        },
        initialState() {
          return "ready";
        },
        context({ prop, bindable: bindable2 }) {
          return {
            checked: bindable2(() => ({
              defaultValue: prop("defaultChecked"),
              value: prop("checked"),
              onChange(checked) {
                var _a;
                (_a = prop("onCheckedChange")) == null ? void 0 : _a({ checked });
              }
            })),
            fieldsetDisabled: bindable2(() => ({ defaultValue: false })),
            focusVisible: bindable2(() => ({ defaultValue: false })),
            active: bindable2(() => ({ defaultValue: false })),
            focused: bindable2(() => ({ defaultValue: false })),
            hovered: bindable2(() => ({ defaultValue: false }))
          };
        },
        watch({ track, context, prop, action }) {
          track([() => prop("disabled")], () => {
            action(["removeFocusIfNeeded"]);
          });
          track([() => context.get("checked")], () => {
            action(["syncInputElement"]);
          });
        },
        effects: ["trackFormControlState", "trackPressEvent", "trackFocusVisible"],
        on: {
          "CHECKED.TOGGLE": [
            {
              guard: not2("isTrusted"),
              actions: ["toggleChecked", "dispatchChangeEvent"]
            },
            {
              actions: ["toggleChecked"]
            }
          ],
          "CHECKED.SET": [
            {
              guard: not2("isTrusted"),
              actions: ["setChecked", "dispatchChangeEvent"]
            },
            {
              actions: ["setChecked"]
            }
          ],
          "CONTEXT.SET": {
            actions: ["setContext"]
          }
        },
        computed: {
          indeterminate: ({ context }) => isIndeterminate(context.get("checked")),
          checked: ({ context }) => isChecked(context.get("checked")),
          disabled: ({ context, prop }) => !!prop("disabled") || context.get("fieldsetDisabled")
        },
        states: {
          ready: {}
        },
        implementations: {
          guards: {
            isTrusted: ({ event }) => !!event.isTrusted
          },
          effects: {
            trackPressEvent({ context, computed, scope }) {
              if (computed("disabled")) return;
              return trackPress({
                pointerNode: getRootEl2(scope),
                keyboardNode: getHiddenInputEl(scope),
                isValidKey: (event) => event.key === " ",
                onPress: () => context.set("active", false),
                onPressStart: () => context.set("active", true),
                onPressEnd: () => context.set("active", false)
              });
            },
            trackFocusVisible({ computed, scope }) {
              var _a;
              if (computed("disabled")) return;
              return trackFocusVisible({ root: (_a = scope.getRootNode) == null ? void 0 : _a.call(scope) });
            },
            trackFormControlState({ context, scope }) {
              return trackFormControl(getHiddenInputEl(scope), {
                onFieldsetDisabledChange(disabled) {
                  context.set("fieldsetDisabled", disabled);
                },
                onFormReset() {
                  context.set("checked", context.initial("checked"));
                }
              });
            }
          },
          actions: {
            setContext({ context, event }) {
              for (const key in event.context) {
                context.set(key, event.context[key]);
              }
            },
            syncInputElement({ context, computed, scope }) {
              const inputEl = getHiddenInputEl(scope);
              if (!inputEl) return;
              setElementChecked(inputEl, computed("checked"));
              inputEl.indeterminate = isIndeterminate(context.get("checked"));
            },
            removeFocusIfNeeded({ context, prop }) {
              if (prop("disabled") && context.get("focused")) {
                context.set("focused", false);
                context.set("focusVisible", false);
              }
            },
            setChecked({ context, event }) {
              context.set("checked", event.checked);
            },
            toggleChecked({ context, computed }) {
              const checked = isIndeterminate(computed("checked")) ? true : !computed("checked");
              context.set("checked", checked);
            },
            dispatchChangeEvent({ computed, scope }) {
              queueMicrotask(() => {
                const inputEl = getHiddenInputEl(scope);
                dispatchInputCheckedEvent(inputEl, { checked: computed("checked") });
              });
            }
          }
        }
      });
      props2 = createProps()([
        "defaultChecked",
        "checked",
        "dir",
        "disabled",
        "form",
        "getRootNode",
        "id",
        "ids",
        "invalid",
        "name",
        "onCheckedChange",
        "readOnly",
        "required",
        "value"
      ]);
      splitProps3 = createSplitProps(props2);
      Checkbox = class extends Component {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        initMachine(props22) {
          return new VanillaMachine(machine2, props22);
        }
        initApi() {
          return connect2(this.machine.service, normalizeProps);
        }
        render() {
          const rootEl = this.el.querySelector('[data-scope="checkbox"][data-part="root"]');
          if (!rootEl) return;
          this.spreadProps(rootEl, this.api.getRootProps());
          const inputEl = rootEl.querySelector(':scope > [data-scope="checkbox"][data-part="hidden-input"]');
          if (inputEl) {
            this.spreadProps(inputEl, this.api.getHiddenInputProps());
          }
          const labelEl = rootEl.querySelector(':scope > [data-scope="checkbox"][data-part="label"]');
          if (labelEl) {
            this.spreadProps(labelEl, this.api.getLabelProps());
          }
          const controlEl = rootEl.querySelector(':scope > [data-scope="checkbox"][data-part="control"]');
          if (controlEl) {
            this.spreadProps(controlEl, this.api.getControlProps());
            const indicatorEl = controlEl.querySelector(':scope > [data-scope="checkbox"][data-part="indicator"]');
            if (indicatorEl) {
              this.spreadProps(indicatorEl, this.api.getIndicatorProps());
            }
          }
        }
      };
      CheckboxHook = {
        mounted() {
          const el = this.el;
          const pushEvent = this.pushEvent.bind(this);
          const zagCheckbox = new Checkbox(el, __spreadProps(__spreadValues({
            id: el.id
          }, getBoolean(el, "controlled") ? { checked: getBoolean(el, "checked") } : { defaultChecked: getBoolean(el, "defaultChecked") }), {
            disabled: getBoolean(el, "disabled"),
            name: getString(el, "name"),
            form: getString(el, "form"),
            value: getString(el, "value"),
            dir: getDir(el),
            invalid: getBoolean(el, "invalid"),
            required: getBoolean(el, "required"),
            readOnly: getBoolean(el, "readOnly"),
            onCheckedChange: (details) => {
              const eventName = getString(el, "onCheckedChange");
              if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
                pushEvent(eventName, {
                  checked: details.checked,
                  id: el.id
                });
              }
              const eventNameClient = getString(el, "onCheckedChangeClient");
              if (eventNameClient) {
                el.dispatchEvent(
                  new CustomEvent(eventNameClient, {
                    bubbles: true,
                    detail: {
                      value: details,
                      id: el.id
                    }
                  })
                );
              }
            }
          }));
          zagCheckbox.init();
          this.checkbox = zagCheckbox;
          this.onSetChecked = (event) => {
            const { checked } = event.detail;
            zagCheckbox.api.setChecked(checked);
          };
          el.addEventListener("phx:checkbox:set-checked", this.onSetChecked);
          this.onToggleChecked = () => {
            zagCheckbox.api.toggleChecked();
          };
          el.addEventListener("phx:checkbox:toggle-checked", this.onToggleChecked);
          this.handlers = [];
          this.handlers.push(
            this.handleEvent("checkbox_set_checked", (payload) => {
              const targetId = payload.id;
              if (targetId && targetId !== el.id) return;
              zagCheckbox.api.setChecked(payload.checked);
            })
          );
          this.handlers.push(
            this.handleEvent("checkbox_toggle_checked", (payload) => {
              const targetId = payload.id;
              if (targetId && targetId !== el.id) return;
              zagCheckbox.api.toggleChecked();
            })
          );
          this.handlers.push(
            this.handleEvent("checkbox_checked", () => {
              this.pushEvent("checkbox_checked_response", {
                value: zagCheckbox.api.checked
              });
            })
          );
          this.handlers.push(
            this.handleEvent("checkbox_focused", () => {
              this.pushEvent("checkbox_focused_response", {
                value: zagCheckbox.api.focused
              });
            })
          );
          this.handlers.push(
            this.handleEvent("checkbox_disabled", () => {
              this.pushEvent("checkbox_disabled_response", {
                value: zagCheckbox.api.disabled
              });
            })
          );
        },
        updated() {
          var _a;
          (_a = this.checkbox) == null ? void 0 : _a.updateProps(__spreadProps(__spreadValues({
            id: this.el.id
          }, getBoolean(this.el, "controlled") ? { checked: getBoolean(this.el, "checked") } : { defaultChecked: getBoolean(this.el, "defaultChecked") }), {
            disabled: getBoolean(this.el, "disabled"),
            name: getString(this.el, "name"),
            form: getString(this.el, "form"),
            value: getString(this.el, "value"),
            dir: getDir(this.el),
            invalid: getBoolean(this.el, "invalid"),
            required: getBoolean(this.el, "required"),
            readOnly: getBoolean(this.el, "readOnly"),
            label: getString(this.el, "label")
          }));
        },
        destroyed() {
          var _a;
          if (this.onSetChecked) {
            this.el.removeEventListener("phx:checkbox:set-checked", this.onSetChecked);
          }
          if (this.onToggleChecked) {
            this.el.removeEventListener("phx:checkbox:toggle-checked", this.onToggleChecked);
          }
          if (this.handlers) {
            for (const handler of this.handlers) {
              this.removeHandleEvent(handler);
            }
          }
          (_a = this.checkbox) == null ? void 0 : _a.destroy();
        }
      };
    }
  });

  // ../priv/static/clipboard.mjs
  var clipboard_exports = {};
  __export(clipboard_exports, {
    Clipboard: () => ClipboardHook
  });
  function createNode(doc, text) {
    const node = doc.createElement("pre");
    Object.assign(node.style, {
      width: "1px",
      height: "1px",
      position: "fixed",
      top: "5px"
    });
    node.textContent = text;
    return node;
  }
  function copyNode(node) {
    const win = getWindow(node);
    const selection = win.getSelection();
    if (selection == null) {
      return Promise.reject(new Error());
    }
    selection.removeAllRanges();
    const doc = node.ownerDocument;
    const range = doc.createRange();
    range.selectNodeContents(node);
    selection.addRange(range);
    doc.execCommand("copy");
    selection.removeAllRanges();
    return Promise.resolve();
  }
  function copyText(doc, text) {
    var _a;
    const win = doc.defaultView || window;
    if (((_a = win.navigator.clipboard) == null ? void 0 : _a.writeText) !== void 0) {
      return win.navigator.clipboard.writeText(text);
    }
    if (!doc.body) {
      return Promise.reject(new Error());
    }
    const node = createNode(doc, text);
    doc.body.appendChild(node);
    copyNode(node);
    doc.body.removeChild(node);
    return Promise.resolve();
  }
  function connect3(service, normalize) {
    const { state: state2, send, context, scope } = service;
    const copied = state2.matches("copied");
    return {
      copied,
      value: context.get("value"),
      setValue(value) {
        send({ type: "VALUE.SET", value });
      },
      copy() {
        send({ type: "COPY" });
      },
      getRootProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts3.root.attrs), {
          "data-copied": dataAttr(copied),
          id: getRootId3(scope)
        }));
      },
      getLabelProps() {
        return normalize.label(__spreadProps(__spreadValues({}, parts3.label.attrs), {
          htmlFor: getInputId(scope),
          "data-copied": dataAttr(copied),
          id: getLabelId2(scope)
        }));
      },
      getControlProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts3.control.attrs), {
          "data-copied": dataAttr(copied)
        }));
      },
      getInputProps() {
        return normalize.input(__spreadProps(__spreadValues({}, parts3.input.attrs), {
          defaultValue: context.get("value"),
          "data-copied": dataAttr(copied),
          readOnly: true,
          "data-readonly": "true",
          id: getInputId(scope),
          onFocus(event) {
            event.currentTarget.select();
          },
          onCopy() {
            send({ type: "INPUT.COPY" });
          }
        }));
      },
      getTriggerProps() {
        return normalize.button(__spreadProps(__spreadValues({}, parts3.trigger.attrs), {
          type: "button",
          "aria-label": copied ? "Copied to clipboard" : "Copy to clipboard",
          "data-copied": dataAttr(copied),
          onClick() {
            send({ type: "COPY" });
          }
        }));
      },
      getIndicatorProps(props22) {
        return normalize.element(__spreadProps(__spreadValues({}, parts3.indicator.attrs), {
          hidden: props22.copied !== copied
        }));
      }
    };
  }
  var anatomy3, parts3, getRootId3, getInputId, getLabelId2, getInputEl, writeToClipboard, machine3, props3, contextProps, indicatorProps, splitIndicatorProps, Clipboard, ClipboardHook;
  var init_clipboard = __esm({
    "../priv/static/clipboard.mjs"() {
      "use strict";
      init_chunk_GFGFZBBD();
      anatomy3 = createAnatomy("clipboard").parts("root", "control", "trigger", "indicator", "input", "label");
      parts3 = anatomy3.build();
      getRootId3 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.root) != null ? _b : `clip:${ctx.id}`;
      };
      getInputId = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.input) != null ? _b : `clip:${ctx.id}:input`;
      };
      getLabelId2 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.label) != null ? _b : `clip:${ctx.id}:label`;
      };
      getInputEl = (ctx) => ctx.getById(getInputId(ctx));
      writeToClipboard = (ctx, value) => copyText(ctx.getDoc(), value);
      machine3 = createMachine({
        props({ props: props22 }) {
          return __spreadValues({
            timeout: 3e3,
            defaultValue: ""
          }, props22);
        },
        initialState() {
          return "idle";
        },
        context({ prop, bindable: bindable2 }) {
          return {
            value: bindable2(() => ({
              defaultValue: prop("defaultValue"),
              value: prop("value"),
              onChange(value) {
                var _a;
                (_a = prop("onValueChange")) == null ? void 0 : _a({ value });
              }
            }))
          };
        },
        watch({ track, context, action }) {
          track([() => context.get("value")], () => {
            action(["syncInputElement"]);
          });
        },
        on: {
          "VALUE.SET": {
            actions: ["setValue"]
          },
          COPY: {
            target: "copied",
            actions: ["copyToClipboard", "invokeOnCopy"]
          }
        },
        states: {
          idle: {
            on: {
              "INPUT.COPY": {
                target: "copied",
                actions: ["invokeOnCopy"]
              }
            }
          },
          copied: {
            effects: ["waitForTimeout"],
            on: {
              "COPY.DONE": {
                target: "idle"
              },
              COPY: {
                target: "copied",
                actions: ["copyToClipboard", "invokeOnCopy"]
              },
              "INPUT.COPY": {
                actions: ["invokeOnCopy"]
              }
            }
          }
        },
        implementations: {
          effects: {
            waitForTimeout({ prop, send }) {
              return setRafTimeout(() => {
                send({ type: "COPY.DONE" });
              }, prop("timeout"));
            }
          },
          actions: {
            setValue({ context, event }) {
              context.set("value", event.value);
            },
            copyToClipboard({ context, scope }) {
              writeToClipboard(scope, context.get("value"));
            },
            invokeOnCopy({ prop }) {
              var _a;
              (_a = prop("onStatusChange")) == null ? void 0 : _a({ copied: true });
            },
            syncInputElement({ context, scope }) {
              const inputEl = getInputEl(scope);
              if (!inputEl) return;
              setElementValue(inputEl, context.get("value"));
            }
          }
        }
      });
      props3 = createProps()([
        "getRootNode",
        "id",
        "ids",
        "value",
        "defaultValue",
        "timeout",
        "onStatusChange",
        "onValueChange"
      ]);
      contextProps = createSplitProps(props3);
      indicatorProps = createProps()(["copied"]);
      splitIndicatorProps = createSplitProps(indicatorProps);
      Clipboard = class extends Component {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        initMachine(props22) {
          return new VanillaMachine(machine3, props22);
        }
        initApi() {
          return connect3(this.machine.service, normalizeProps);
        }
        render() {
          const rootEl = this.el.querySelector('[data-scope="clipboard"][data-part="root"]');
          if (rootEl) {
            this.spreadProps(rootEl, this.api.getRootProps());
            const labelEl = rootEl.querySelector('[data-scope="clipboard"][data-part="label"]');
            if (labelEl) {
              this.spreadProps(labelEl, this.api.getLabelProps());
            }
            const controlEl = rootEl.querySelector('[data-scope="clipboard"][data-part="control"]');
            if (controlEl) {
              this.spreadProps(controlEl, this.api.getControlProps());
              const inputEl = controlEl.querySelector('[data-scope="clipboard"][data-part="input"]');
              if (inputEl) {
                const inputProps2 = __spreadValues({}, this.api.getInputProps());
                const inputAriaLabel = this.el.dataset.inputAriaLabel;
                if (inputAriaLabel) {
                  inputProps2["aria-label"] = inputAriaLabel;
                }
                this.spreadProps(inputEl, inputProps2);
              }
              const triggerEl = controlEl.querySelector('[data-scope="clipboard"][data-part="trigger"]');
              if (triggerEl) {
                const triggerProps2 = __spreadValues({}, this.api.getTriggerProps());
                const ariaLabel = this.el.dataset.triggerAriaLabel;
                if (ariaLabel) {
                  triggerProps2["aria-label"] = ariaLabel;
                }
                this.spreadProps(triggerEl, triggerProps2);
              }
            }
          }
        }
      };
      ClipboardHook = {
        mounted() {
          const el = this.el;
          const pushEvent = this.pushEvent.bind(this);
          const liveSocket = this.liveSocket;
          const clipboard = new Clipboard(el, __spreadProps(__spreadValues({
            id: el.id,
            timeout: getNumber(el, "timeout")
          }, getBoolean(el, "controlled") ? { value: getString(el, "value") } : { defaultValue: getString(el, "defaultValue") }), {
            onValueChange: (details) => {
              var _a;
              const eventName = getString(el, "onValueChange");
              if (eventName && liveSocket.main.isConnected()) {
                pushEvent(eventName, {
                  id: el.id,
                  value: (_a = details.value) != null ? _a : null
                });
              }
            },
            onStatusChange: (details) => {
              const eventName = getString(el, "onStatusChange");
              if (eventName && liveSocket.main.isConnected()) {
                pushEvent(eventName, {
                  id: el.id,
                  copied: details.copied
                });
              }
              const eventNameClient = getString(el, "onStatusChangeClient");
              if (eventNameClient) {
                el.dispatchEvent(
                  new CustomEvent(eventNameClient, {
                    bubbles: true
                  })
                );
              }
            }
          }));
          clipboard.init();
          this.clipboard = clipboard;
          this.onCopy = () => {
            clipboard.api.copy();
          };
          el.addEventListener("phx:clipboard:copy", this.onCopy);
          this.onSetValue = (event) => {
            const { value } = event.detail;
            clipboard.api.setValue(value);
          };
          el.addEventListener("phx:clipboard:set-value", this.onSetValue);
          this.handlers = [];
          this.handlers.push(
            this.handleEvent("clipboard_copy", (payload) => {
              const targetId = payload.clipboard_id;
              if (targetId && targetId !== el.id) return;
              clipboard.api.copy();
            })
          );
          this.handlers.push(
            this.handleEvent("clipboard_set_value", (payload) => {
              const targetId = payload.clipboard_id;
              if (targetId && targetId !== el.id) return;
              clipboard.api.setValue(payload.value);
            })
          );
          this.handlers.push(
            this.handleEvent("clipboard_copied", () => {
              this.pushEvent("clipboard_copied_response", {
                value: clipboard.api.copied
              });
            })
          );
        },
        updated() {
          var _a;
          (_a = this.clipboard) == null ? void 0 : _a.updateProps(__spreadProps(__spreadValues({
            id: this.el.id,
            timeout: getNumber(this.el, "timeout")
          }, getBoolean(this.el, "controlled") ? { value: getString(this.el, "value") } : { defaultValue: getString(this.el, "value") }), {
            dir: getString(this.el, "dir", ["ltr", "rtl"])
          }));
        },
        destroyed() {
          var _a;
          if (this.onCopy) {
            this.el.removeEventListener("phx:clipboard:copy", this.onCopy);
          }
          if (this.onSetValue) {
            this.el.removeEventListener("phx:clipboard:set-value", this.onSetValue);
          }
          if (this.handlers) {
            for (const handler of this.handlers) {
              this.removeHandleEvent(handler);
            }
          }
          (_a = this.clipboard) == null ? void 0 : _a.destroy();
        }
      };
    }
  });

  // ../priv/static/collapsible.mjs
  var collapsible_exports = {};
  __export(collapsible_exports, {
    Collapsible: () => CollapsibleHook
  });
  function connect4(service, normalize) {
    const { state: state2, send, context, scope, prop } = service;
    const visible = state2.matches("open") || state2.matches("closing");
    const open = state2.matches("open");
    const closed = state2.matches("closed");
    const { width, height } = context.get("size");
    const disabled = !!prop("disabled");
    const collapsedHeight = prop("collapsedHeight");
    const collapsedWidth = prop("collapsedWidth");
    const hasCollapsedHeight = collapsedHeight != null;
    const hasCollapsedWidth = collapsedWidth != null;
    const hasCollapsedSize = hasCollapsedHeight || hasCollapsedWidth;
    const skip = !context.get("initial") && open;
    return {
      disabled,
      visible,
      open,
      measureSize() {
        send({ type: "size.measure" });
      },
      setOpen(nextOpen) {
        const open2 = state2.matches("open");
        if (open2 === nextOpen) return;
        send({ type: nextOpen ? "open" : "close" });
      },
      getRootProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts4.root.attrs), {
          "data-state": open ? "open" : "closed",
          dir: prop("dir"),
          id: getRootId4(scope)
        }));
      },
      getContentProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts4.content.attrs), {
          id: getContentId(scope),
          "data-collapsible": "",
          "data-state": skip ? void 0 : open ? "open" : "closed",
          "data-disabled": dataAttr(disabled),
          "data-has-collapsed-size": dataAttr(hasCollapsedSize),
          hidden: !visible && !hasCollapsedSize,
          dir: prop("dir"),
          style: __spreadValues(__spreadValues({
            "--height": toPx(height),
            "--width": toPx(width),
            "--collapsed-height": toPx(collapsedHeight),
            "--collapsed-width": toPx(collapsedWidth)
          }, closed && hasCollapsedHeight && {
            overflow: "hidden",
            minHeight: toPx(collapsedHeight),
            maxHeight: toPx(collapsedHeight)
          }), closed && hasCollapsedWidth && {
            overflow: "hidden",
            minWidth: toPx(collapsedWidth),
            maxWidth: toPx(collapsedWidth)
          })
        }));
      },
      getTriggerProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts4.trigger.attrs), {
          id: getTriggerId(scope),
          dir: prop("dir"),
          type: "button",
          "data-state": open ? "open" : "closed",
          "data-disabled": dataAttr(disabled),
          "aria-controls": getContentId(scope),
          "aria-expanded": visible || false,
          onClick(event) {
            if (event.defaultPrevented) return;
            if (disabled) return;
            send({ type: open ? "close" : "open" });
          }
        }));
      },
      getIndicatorProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts4.indicator.attrs), {
          dir: prop("dir"),
          "data-state": open ? "open" : "closed",
          "data-disabled": dataAttr(disabled)
        }));
      }
    };
  }
  var anatomy4, parts4, getRootId4, getContentId, getTriggerId, getContentEl, machine4, props4, splitProps4, Collapsible, CollapsibleHook;
  var init_collapsible = __esm({
    "../priv/static/collapsible.mjs"() {
      "use strict";
      init_chunk_GFGFZBBD();
      anatomy4 = createAnatomy("collapsible").parts("root", "trigger", "content", "indicator");
      parts4 = anatomy4.build();
      getRootId4 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.root) != null ? _b : `collapsible:${ctx.id}`;
      };
      getContentId = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.content) != null ? _b : `collapsible:${ctx.id}:content`;
      };
      getTriggerId = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.trigger) != null ? _b : `collapsible:${ctx.id}:trigger`;
      };
      getContentEl = (ctx) => ctx.getById(getContentId(ctx));
      machine4 = createMachine({
        initialState({ prop }) {
          const open = prop("open") || prop("defaultOpen");
          return open ? "open" : "closed";
        },
        context({ bindable: bindable2 }) {
          return {
            size: bindable2(() => ({
              defaultValue: { height: 0, width: 0 },
              sync: true
            })),
            initial: bindable2(() => ({
              defaultValue: false
            }))
          };
        },
        refs() {
          return {
            cleanup: void 0,
            stylesRef: void 0
          };
        },
        watch({ track, prop, action }) {
          track([() => prop("open")], () => {
            action(["setInitial", "computeSize", "toggleVisibility"]);
          });
        },
        exit: ["cleanupNode"],
        states: {
          closed: {
            effects: ["trackTabbableElements"],
            on: {
              "controlled.open": {
                target: "open"
              },
              open: [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnOpen"]
                },
                {
                  target: "open",
                  actions: ["setInitial", "computeSize", "invokeOnOpen"]
                }
              ]
            }
          },
          closing: {
            effects: ["trackExitAnimation"],
            on: {
              "controlled.close": {
                target: "closed"
              },
              "controlled.open": {
                target: "open"
              },
              open: [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnOpen"]
                },
                {
                  target: "open",
                  actions: ["setInitial", "invokeOnOpen"]
                }
              ],
              close: [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnExitComplete"]
                },
                {
                  target: "closed",
                  actions: ["setInitial", "computeSize", "invokeOnExitComplete"]
                }
              ],
              "animation.end": {
                target: "closed",
                actions: ["invokeOnExitComplete", "clearInitial"]
              }
            }
          },
          open: {
            effects: ["trackEnterAnimation"],
            on: {
              "controlled.close": {
                target: "closing"
              },
              close: [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnClose"]
                },
                {
                  target: "closing",
                  actions: ["setInitial", "computeSize", "invokeOnClose"]
                }
              ],
              "size.measure": {
                actions: ["measureSize"]
              },
              "animation.end": {
                actions: ["clearInitial"]
              }
            }
          }
        },
        implementations: {
          guards: {
            isOpenControlled: ({ prop }) => prop("open") != void 0
          },
          effects: {
            trackEnterAnimation: ({ send, scope }) => {
              let cleanup;
              const rafCleanup = raf(() => {
                const contentEl = getContentEl(scope);
                if (!contentEl) return;
                const animationName = getComputedStyle2(contentEl).animationName;
                const hasNoAnimation = !animationName || animationName === "none";
                if (hasNoAnimation) {
                  send({ type: "animation.end" });
                  return;
                }
                const onEnd = (event) => {
                  const target = getEventTarget(event);
                  if (target === contentEl) {
                    send({ type: "animation.end" });
                  }
                };
                contentEl.addEventListener("animationend", onEnd);
                cleanup = () => {
                  contentEl.removeEventListener("animationend", onEnd);
                };
              });
              return () => {
                rafCleanup();
                cleanup == null ? void 0 : cleanup();
              };
            },
            trackExitAnimation: ({ send, scope }) => {
              let cleanup;
              const rafCleanup = raf(() => {
                const contentEl = getContentEl(scope);
                if (!contentEl) return;
                const animationName = getComputedStyle2(contentEl).animationName;
                const hasNoAnimation = !animationName || animationName === "none";
                if (hasNoAnimation) {
                  send({ type: "animation.end" });
                  return;
                }
                const onEnd = (event) => {
                  const target = getEventTarget(event);
                  if (target === contentEl) {
                    send({ type: "animation.end" });
                  }
                };
                contentEl.addEventListener("animationend", onEnd);
                const restoreStyles = setStyle(contentEl, {
                  animationFillMode: "forwards"
                });
                cleanup = () => {
                  contentEl.removeEventListener("animationend", onEnd);
                  nextTick(() => restoreStyles());
                };
              });
              return () => {
                rafCleanup();
                cleanup == null ? void 0 : cleanup();
              };
            },
            trackTabbableElements: ({ scope, prop }) => {
              if (!prop("collapsedHeight") && !prop("collapsedWidth")) return;
              const contentEl = getContentEl(scope);
              if (!contentEl) return;
              const applyInertToTabbables = () => {
                const tabbables = getTabbables(contentEl);
                const restoreAttrs = tabbables.map((tabbable) => setAttribute(tabbable, "inert", ""));
                return () => {
                  restoreAttrs.forEach((attr) => attr());
                };
              };
              let restoreInert = applyInertToTabbables();
              const observerCleanup = observeChildren(contentEl, {
                callback() {
                  restoreInert();
                  restoreInert = applyInertToTabbables();
                }
              });
              return () => {
                restoreInert();
                observerCleanup();
              };
            }
          },
          actions: {
            setInitial: ({ context, flush }) => {
              flush(() => {
                context.set("initial", true);
              });
            },
            clearInitial: ({ context }) => {
              context.set("initial", false);
            },
            cleanupNode: ({ refs }) => {
              refs.set("stylesRef", null);
            },
            measureSize: ({ context, scope }) => {
              const contentEl = getContentEl(scope);
              if (!contentEl) return;
              const { height, width } = contentEl.getBoundingClientRect();
              context.set("size", { height, width });
            },
            computeSize: ({ refs, scope, context }) => {
              var _a;
              (_a = refs.get("cleanup")) == null ? void 0 : _a();
              const rafCleanup = raf(() => {
                const contentEl = getContentEl(scope);
                if (!contentEl) return;
                const hidden = contentEl.hidden;
                contentEl.style.animationName = "none";
                contentEl.style.animationDuration = "0s";
                contentEl.hidden = false;
                const rect = contentEl.getBoundingClientRect();
                context.set("size", { height: rect.height, width: rect.width });
                if (context.get("initial")) {
                  contentEl.style.animationName = "";
                  contentEl.style.animationDuration = "";
                }
                contentEl.hidden = hidden;
              });
              refs.set("cleanup", rafCleanup);
            },
            invokeOnOpen: ({ prop }) => {
              var _a;
              (_a = prop("onOpenChange")) == null ? void 0 : _a({ open: true });
            },
            invokeOnClose: ({ prop }) => {
              var _a;
              (_a = prop("onOpenChange")) == null ? void 0 : _a({ open: false });
            },
            invokeOnExitComplete: ({ prop }) => {
              var _a;
              (_a = prop("onExitComplete")) == null ? void 0 : _a();
            },
            toggleVisibility: ({ prop, send }) => {
              send({ type: prop("open") ? "controlled.open" : "controlled.close" });
            }
          }
        }
      });
      props4 = createProps()([
        "dir",
        "disabled",
        "getRootNode",
        "id",
        "ids",
        "collapsedHeight",
        "collapsedWidth",
        "onExitComplete",
        "onOpenChange",
        "defaultOpen",
        "open"
      ]);
      splitProps4 = createSplitProps(props4);
      Collapsible = class extends Component {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        initMachine(props22) {
          return new VanillaMachine(machine4, props22);
        }
        initApi() {
          return connect4(this.machine.service, normalizeProps);
        }
        render() {
          const rootEl = this.el.querySelector('[data-scope="collapsible"][data-part="root"]');
          if (rootEl) {
            this.spreadProps(rootEl, this.api.getRootProps());
            const triggerEl = rootEl.querySelector('[data-scope="collapsible"][data-part="trigger"]');
            if (triggerEl) {
              this.spreadProps(triggerEl, this.api.getTriggerProps());
            }
            const contentEl = rootEl.querySelector('[data-scope="collapsible"][data-part="content"]');
            if (contentEl) {
              this.spreadProps(contentEl, this.api.getContentProps());
            }
          }
        }
      };
      CollapsibleHook = {
        mounted() {
          const el = this.el;
          const pushEvent = this.pushEvent.bind(this);
          const collapsible = new Collapsible(el, __spreadProps(__spreadValues({
            id: el.id
          }, getBoolean(el, "controlled") ? { open: getBoolean(el, "open") } : { defaultOpen: getBoolean(el, "defaultOpen") }), {
            disabled: getBoolean(el, "disabled"),
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
          }));
          collapsible.init();
          this.collapsible = collapsible;
          this.onSetOpen = (event) => {
            const { open } = event.detail;
            collapsible.api.setOpen(open);
          };
          el.addEventListener("phx:collapsible:set-open", this.onSetOpen);
          this.handlers = [];
          this.handlers.push(
            this.handleEvent("collapsible_set_open", (payload) => {
              const targetId = payload.collapsible_id;
              if (targetId && targetId !== el.id) return;
              collapsible.api.setOpen(payload.open);
            })
          );
          this.handlers.push(
            this.handleEvent("collapsible_open", () => {
              this.pushEvent("collapsible_open_response", {
                value: collapsible.api.open
              });
            })
          );
        },
        updated() {
          var _a;
          (_a = this.collapsible) == null ? void 0 : _a.updateProps(__spreadProps(__spreadValues({
            id: this.el.id
          }, getBoolean(this.el, "controlled") ? { open: getBoolean(this.el, "open") } : { defaultOpen: getBoolean(this.el, "defaultOpen") }), {
            disabled: getBoolean(this.el, "disabled"),
            dir: getString(this.el, "dir", ["ltr", "rtl"])
          }));
        },
        destroyed() {
          var _a;
          if (this.onSetOpen) {
            this.el.removeEventListener("phx:collapsible:set-open", this.onSetOpen);
          }
          if (this.handlers) {
            for (const handler of this.handlers) {
              this.removeHandleEvent(handler);
            }
          }
          (_a = this.collapsible) == null ? void 0 : _a.destroy();
        }
      };
    }
  });

  // ../priv/static/chunk-2DWEYSRA.mjs
  function insert(items, index, ...values) {
    return [...items.slice(0, index), ...values, ...items.slice(index)];
  }
  function move(items, indices, toIndex) {
    indices = [...indices].sort((a2, b2) => a2 - b2);
    const itemsToMove = indices.map((i2) => items[i2]);
    for (let i2 = indices.length - 1; i2 >= 0; i2--) {
      items = [...items.slice(0, indices[i2]), ...items.slice(indices[i2] + 1)];
    }
    toIndex = Math.max(0, toIndex - indices.filter((i2) => i2 < toIndex).length);
    return [...items.slice(0, toIndex), ...itemsToMove, ...items.slice(toIndex)];
  }
  function access(node, indexPath, options) {
    for (let i2 = 0; i2 < indexPath.length; i2++) node = options.getChildren(node, indexPath.slice(i2 + 1))[indexPath[i2]];
    return node;
  }
  function ancestorIndexPaths(indexPaths) {
    const sortedPaths = sortIndexPaths(indexPaths);
    const result = [];
    const seen = /* @__PURE__ */ new Set();
    for (const indexPath of sortedPaths) {
      const key = indexPath.join();
      if (!seen.has(key)) {
        seen.add(key);
        result.push(indexPath);
      }
    }
    return result;
  }
  function compareIndexPaths(a2, b2) {
    for (let i2 = 0; i2 < Math.min(a2.length, b2.length); i2++) {
      if (a2[i2] < b2[i2]) return -1;
      if (a2[i2] > b2[i2]) return 1;
    }
    return a2.length - b2.length;
  }
  function sortIndexPaths(indexPaths) {
    return indexPaths.sort(compareIndexPaths);
  }
  function find(node, options) {
    let found;
    visit(node, __spreadProps(__spreadValues({}, options), {
      onEnter: (child, indexPath) => {
        if (options.predicate(child, indexPath)) {
          found = child;
          return "stop";
        }
      }
    }));
    return found;
  }
  function findAll(node, options) {
    const found = [];
    visit(node, {
      onEnter: (child, indexPath) => {
        if (options.predicate(child, indexPath)) found.push(child);
      },
      getChildren: options.getChildren
    });
    return found;
  }
  function findIndexPath(node, options) {
    let found;
    visit(node, {
      onEnter: (child, indexPath) => {
        if (options.predicate(child, indexPath)) {
          found = [...indexPath];
          return "stop";
        }
      },
      getChildren: options.getChildren
    });
    return found;
  }
  function reduce(node, options) {
    let result = options.initialResult;
    visit(node, __spreadProps(__spreadValues({}, options), {
      onEnter: (child, indexPath) => {
        result = options.nextResult(result, child, indexPath);
      }
    }));
    return result;
  }
  function flatMap(node, options) {
    return reduce(node, __spreadProps(__spreadValues({}, options), {
      initialResult: [],
      nextResult: (result, child, indexPath) => {
        result.push(...options.transform(child, indexPath));
        return result;
      }
    }));
  }
  function filter(node, options) {
    const { predicate, create, getChildren } = options;
    const filterRecursive = (node2, indexPath) => {
      const children = getChildren(node2, indexPath);
      const filteredChildren = [];
      children.forEach((child, index) => {
        const childIndexPath = [...indexPath, index];
        const filteredChild = filterRecursive(child, childIndexPath);
        if (filteredChild) filteredChildren.push(filteredChild);
      });
      const isRoot = indexPath.length === 0;
      const nodeMatches = predicate(node2, indexPath);
      const hasFilteredChildren = filteredChildren.length > 0;
      if (isRoot || nodeMatches || hasFilteredChildren) {
        return create(node2, filteredChildren, indexPath);
      }
      return null;
    };
    return filterRecursive(node, []) || create(node, [], []);
  }
  function flatten(rootNode, options) {
    const nodes = [];
    let idx = 0;
    const idxMap = /* @__PURE__ */ new Map();
    const parentMap = /* @__PURE__ */ new Map();
    visit(rootNode, {
      getChildren: options.getChildren,
      onEnter: (node, indexPath) => {
        if (!idxMap.has(node)) {
          idxMap.set(node, idx++);
        }
        const children = options.getChildren(node, indexPath);
        children.forEach((child) => {
          if (!parentMap.has(child)) {
            parentMap.set(child, node);
          }
          if (!idxMap.has(child)) {
            idxMap.set(child, idx++);
          }
        });
        const _children = children.length > 0 ? children.map((child) => idxMap.get(child)) : void 0;
        const parent = parentMap.get(node);
        const _parent = parent ? idxMap.get(parent) : void 0;
        const _index = idxMap.get(node);
        nodes.push(__spreadProps(__spreadValues({}, node), { _children, _parent, _index }));
      }
    });
    return nodes;
  }
  function insertOperation(index, nodes) {
    return { type: "insert", index, nodes };
  }
  function removeOperation(indexes) {
    return { type: "remove", indexes };
  }
  function replaceOperation() {
    return { type: "replace" };
  }
  function splitIndexPath(indexPath) {
    return [indexPath.slice(0, -1), indexPath[indexPath.length - 1]];
  }
  function getInsertionOperations(indexPath, nodes, operations = /* @__PURE__ */ new Map()) {
    var _a;
    const [parentIndexPath, index] = splitIndexPath(indexPath);
    for (let i2 = parentIndexPath.length - 1; i2 >= 0; i2--) {
      const parentKey = parentIndexPath.slice(0, i2).join();
      switch ((_a = operations.get(parentKey)) == null ? void 0 : _a.type) {
        case "remove":
          continue;
      }
      operations.set(parentKey, replaceOperation());
    }
    const operation = operations.get(parentIndexPath.join());
    switch (operation == null ? void 0 : operation.type) {
      case "remove":
        operations.set(parentIndexPath.join(), {
          type: "removeThenInsert",
          removeIndexes: operation.indexes,
          insertIndex: index,
          insertNodes: nodes
        });
        break;
      default:
        operations.set(parentIndexPath.join(), insertOperation(index, nodes));
    }
    return operations;
  }
  function getRemovalOperations(indexPaths) {
    var _a;
    const operations = /* @__PURE__ */ new Map();
    const indexesToRemove = /* @__PURE__ */ new Map();
    for (const indexPath of indexPaths) {
      const parentKey = indexPath.slice(0, -1).join();
      const value = (_a = indexesToRemove.get(parentKey)) != null ? _a : [];
      value.push(indexPath[indexPath.length - 1]);
      indexesToRemove.set(
        parentKey,
        value.sort((a2, b2) => a2 - b2)
      );
    }
    for (const indexPath of indexPaths) {
      for (let i2 = indexPath.length - 2; i2 >= 0; i2--) {
        const parentKey = indexPath.slice(0, i2).join();
        if (!operations.has(parentKey)) {
          operations.set(parentKey, replaceOperation());
        }
      }
    }
    for (const [parentKey, indexes] of indexesToRemove) {
      operations.set(parentKey, removeOperation(indexes));
    }
    return operations;
  }
  function getReplaceOperations(indexPath, node) {
    const operations = /* @__PURE__ */ new Map();
    const [parentIndexPath, index] = splitIndexPath(indexPath);
    for (let i2 = parentIndexPath.length - 1; i2 >= 0; i2--) {
      const parentKey = parentIndexPath.slice(0, i2).join();
      operations.set(parentKey, replaceOperation());
    }
    operations.set(parentIndexPath.join(), {
      type: "removeThenInsert",
      removeIndexes: [index],
      insertIndex: index,
      insertNodes: [node]
    });
    return operations;
  }
  function mutate(node, operations, options) {
    return map(node, __spreadProps(__spreadValues({}, options), {
      getChildren: (node2, indexPath) => {
        const key = indexPath.join();
        const operation = operations.get(key);
        switch (operation == null ? void 0 : operation.type) {
          case "replace":
          case "remove":
          case "removeThenInsert":
          case "insert":
            return options.getChildren(node2, indexPath);
          default:
            return [];
        }
      },
      transform: (node2, children, indexPath) => {
        const key = indexPath.join();
        const operation = operations.get(key);
        switch (operation == null ? void 0 : operation.type) {
          case "remove":
            return options.create(
              node2,
              children.filter((_2, index) => !operation.indexes.includes(index)),
              indexPath
            );
          case "removeThenInsert":
            const updatedChildren = children.filter((_2, index) => !operation.removeIndexes.includes(index));
            const adjustedIndex = operation.removeIndexes.reduce(
              (index, removedIndex) => removedIndex < index ? index - 1 : index,
              operation.insertIndex
            );
            return options.create(node2, splice(updatedChildren, adjustedIndex, 0, ...operation.insertNodes), indexPath);
          case "insert":
            return options.create(node2, splice(children, operation.index, 0, ...operation.nodes), indexPath);
          case "replace":
            return options.create(node2, children, indexPath);
          default:
            return node2;
        }
      }
    }));
  }
  function splice(array, start, deleteCount, ...items) {
    return [...array.slice(0, start), ...items, ...array.slice(start + deleteCount)];
  }
  function map(node, options) {
    const childrenMap = {};
    visit(node, __spreadProps(__spreadValues({}, options), {
      onLeave: (child, indexPath) => {
        var _a, _b;
        const keyIndexPath = [0, ...indexPath];
        const key = keyIndexPath.join();
        const transformed = options.transform(child, (_a = childrenMap[key]) != null ? _a : [], indexPath);
        const parentKey = keyIndexPath.slice(0, -1).join();
        const parentChildren = (_b = childrenMap[parentKey]) != null ? _b : [];
        parentChildren.push(transformed);
        childrenMap[parentKey] = parentChildren;
      }
    }));
    return childrenMap[""][0];
  }
  function insert2(node, options) {
    const { nodes, at } = options;
    if (at.length === 0) throw new Error(`Can't insert nodes at the root`);
    const state2 = getInsertionOperations(at, nodes);
    return mutate(node, state2, options);
  }
  function replace(node, options) {
    if (options.at.length === 0) return options.node;
    const operations = getReplaceOperations(options.at, options.node);
    return mutate(node, operations, options);
  }
  function remove2(node, options) {
    if (options.indexPaths.length === 0) return node;
    for (const indexPath of options.indexPaths) {
      if (indexPath.length === 0) throw new Error(`Can't remove the root node`);
    }
    const operations = getRemovalOperations(options.indexPaths);
    return mutate(node, operations, options);
  }
  function move2(node, options) {
    if (options.indexPaths.length === 0) return node;
    for (const indexPath of options.indexPaths) {
      if (indexPath.length === 0) throw new Error(`Can't move the root node`);
    }
    if (options.to.length === 0) throw new Error(`Can't move nodes to the root`);
    const _ancestorIndexPaths = ancestorIndexPaths(options.indexPaths);
    const nodesToInsert = _ancestorIndexPaths.map((indexPath) => access(node, indexPath, options));
    const operations = getInsertionOperations(options.to, nodesToInsert, getRemovalOperations(_ancestorIndexPaths));
    return mutate(node, operations, options);
  }
  function visit(node, options) {
    const { onEnter, onLeave, getChildren } = options;
    let indexPath = [];
    let stack = [{ node }];
    const getIndexPath = options.reuseIndexPath ? () => indexPath : () => indexPath.slice();
    while (stack.length > 0) {
      let wrapper = stack[stack.length - 1];
      if (wrapper.state === void 0) {
        const enterResult = onEnter == null ? void 0 : onEnter(wrapper.node, getIndexPath());
        if (enterResult === "stop") return;
        wrapper.state = enterResult === "skip" ? -1 : 0;
      }
      const children = wrapper.children || getChildren(wrapper.node, getIndexPath());
      wrapper.children || (wrapper.children = children);
      if (wrapper.state !== -1) {
        if (wrapper.state < children.length) {
          let currentIndex = wrapper.state;
          indexPath.push(currentIndex);
          stack.push({ node: children[currentIndex] });
          wrapper.state = currentIndex + 1;
          continue;
        }
        const leaveResult = onLeave == null ? void 0 : onLeave(wrapper.node, getIndexPath());
        if (leaveResult === "stop") return;
      }
      indexPath.pop();
      stack.pop();
    }
  }
  var __defProp4, __defNormalProp4, __publicField4, fallback, ListCollection, match3, TreeCollection, fallbackMethods;
  var init_chunk_2DWEYSRA = __esm({
    "../priv/static/chunk-2DWEYSRA.mjs"() {
      "use strict";
      init_chunk_GFGFZBBD();
      __defProp4 = Object.defineProperty;
      __defNormalProp4 = (obj, key, value) => key in obj ? __defProp4(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
      __publicField4 = (obj, key, value) => __defNormalProp4(obj, typeof key !== "symbol" ? key + "" : key, value);
      fallback = {
        itemToValue(item) {
          if (typeof item === "string") return item;
          if (isObject2(item) && hasProp(item, "value")) return item.value;
          return "";
        },
        itemToString(item) {
          if (typeof item === "string") return item;
          if (isObject2(item) && hasProp(item, "label")) return item.label;
          return fallback.itemToValue(item);
        },
        isItemDisabled(item) {
          if (isObject2(item) && hasProp(item, "disabled")) return !!item.disabled;
          return false;
        }
      };
      ListCollection = class _ListCollection {
        constructor(options) {
          this.options = options;
          __publicField4(this, "items");
          __publicField4(this, "indexMap", null);
          __publicField4(this, "copy", (items) => {
            return new _ListCollection(__spreadProps(__spreadValues({}, this.options), { items: items != null ? items : [...this.items] }));
          });
          __publicField4(this, "isEqual", (other) => {
            return isEqual2(this.items, other.items);
          });
          __publicField4(this, "setItems", (items) => {
            return this.copy(items);
          });
          __publicField4(this, "getValues", (items = this.items) => {
            const values = [];
            for (const item of items) {
              const value = this.getItemValue(item);
              if (value != null) values.push(value);
            }
            return values;
          });
          __publicField4(this, "find", (value) => {
            if (value == null) return null;
            const index = this.indexOf(value);
            return index !== -1 ? this.at(index) : null;
          });
          __publicField4(this, "findMany", (values) => {
            const result = [];
            for (const value of values) {
              const item = this.find(value);
              if (item != null) result.push(item);
            }
            return result;
          });
          __publicField4(this, "at", (index) => {
            var _a;
            if (!this.options.groupBy && !this.options.groupSort) {
              return (_a = this.items[index]) != null ? _a : null;
            }
            let idx = 0;
            const groups = this.group();
            for (const [, items] of groups) {
              for (const item of items) {
                if (idx === index) return item;
                idx++;
              }
            }
            return null;
          });
          __publicField4(this, "sortFn", (valueA, valueB) => {
            const indexA = this.indexOf(valueA);
            const indexB = this.indexOf(valueB);
            return (indexA != null ? indexA : 0) - (indexB != null ? indexB : 0);
          });
          __publicField4(this, "sort", (values) => {
            return [...values].sort(this.sortFn.bind(this));
          });
          __publicField4(this, "getItemValue", (item) => {
            var _a, _b, _c;
            if (item == null) return null;
            return (_c = (_b = (_a = this.options).itemToValue) == null ? void 0 : _b.call(_a, item)) != null ? _c : fallback.itemToValue(item);
          });
          __publicField4(this, "getItemDisabled", (item) => {
            var _a, _b, _c;
            if (item == null) return false;
            return (_c = (_b = (_a = this.options).isItemDisabled) == null ? void 0 : _b.call(_a, item)) != null ? _c : fallback.isItemDisabled(item);
          });
          __publicField4(this, "stringifyItem", (item) => {
            var _a, _b, _c;
            if (item == null) return null;
            return (_c = (_b = (_a = this.options).itemToString) == null ? void 0 : _b.call(_a, item)) != null ? _c : fallback.itemToString(item);
          });
          __publicField4(this, "stringify", (value) => {
            if (value == null) return null;
            return this.stringifyItem(this.find(value));
          });
          __publicField4(this, "stringifyItems", (items, separator = ", ") => {
            const strs = [];
            for (const item of items) {
              const str = this.stringifyItem(item);
              if (str != null) strs.push(str);
            }
            return strs.join(separator);
          });
          __publicField4(this, "stringifyMany", (value, separator) => {
            return this.stringifyItems(this.findMany(value), separator);
          });
          __publicField4(this, "has", (value) => {
            return this.indexOf(value) !== -1;
          });
          __publicField4(this, "hasItem", (item) => {
            if (item == null) return false;
            return this.has(this.getItemValue(item));
          });
          __publicField4(this, "group", () => {
            const { groupBy, groupSort } = this.options;
            if (!groupBy) return [["", [...this.items]]];
            const groups = /* @__PURE__ */ new Map();
            this.items.forEach((item, index) => {
              const groupKey = groupBy(item, index);
              if (!groups.has(groupKey)) {
                groups.set(groupKey, []);
              }
              groups.get(groupKey).push(item);
            });
            let entries = Array.from(groups.entries());
            if (groupSort) {
              entries.sort(([a2], [b2]) => {
                if (typeof groupSort === "function") return groupSort(a2, b2);
                if (Array.isArray(groupSort)) {
                  const indexA = groupSort.indexOf(a2);
                  const indexB = groupSort.indexOf(b2);
                  if (indexA === -1) return 1;
                  if (indexB === -1) return -1;
                  return indexA - indexB;
                }
                if (groupSort === "asc") return a2.localeCompare(b2);
                if (groupSort === "desc") return b2.localeCompare(a2);
                return 0;
              });
            }
            return entries;
          });
          __publicField4(this, "getNextValue", (value, step = 1, clamp3 = false) => {
            let index = this.indexOf(value);
            if (index === -1) return null;
            index = clamp3 ? Math.min(index + step, this.size - 1) : index + step;
            while (index <= this.size && this.getItemDisabled(this.at(index))) index++;
            return this.getItemValue(this.at(index));
          });
          __publicField4(this, "getPreviousValue", (value, step = 1, clamp3 = false) => {
            let index = this.indexOf(value);
            if (index === -1) return null;
            index = clamp3 ? Math.max(index - step, 0) : index - step;
            while (index >= 0 && this.getItemDisabled(this.at(index))) index--;
            return this.getItemValue(this.at(index));
          });
          __publicField4(this, "indexOf", (value) => {
            var _a;
            if (value == null) return -1;
            if (!this.options.groupBy && !this.options.groupSort) {
              return this.items.findIndex((item) => this.getItemValue(item) === value);
            }
            if (!this.indexMap) {
              this.indexMap = /* @__PURE__ */ new Map();
              let idx = 0;
              const groups = this.group();
              for (const [, items] of groups) {
                for (const item of items) {
                  const itemValue = this.getItemValue(item);
                  if (itemValue != null) {
                    this.indexMap.set(itemValue, idx);
                  }
                  idx++;
                }
              }
            }
            return (_a = this.indexMap.get(value)) != null ? _a : -1;
          });
          __publicField4(this, "getByText", (text, current) => {
            const currentIndex = current != null ? this.indexOf(current) : -1;
            const isSingleKey = text.length === 1;
            for (let i2 = 0; i2 < this.items.length; i2++) {
              const item = this.items[(currentIndex + i2 + 1) % this.items.length];
              if (isSingleKey && this.getItemValue(item) === current) continue;
              if (this.getItemDisabled(item)) continue;
              if (match3(this.stringifyItem(item), text)) return item;
            }
            return void 0;
          });
          __publicField4(this, "search", (queryString, options2) => {
            const { state: state2, currentValue, timeout = 350 } = options2;
            const search = state2.keysSoFar + queryString;
            const isRepeated = search.length > 1 && Array.from(search).every((char) => char === search[0]);
            const query2 = isRepeated ? search[0] : search;
            const item = this.getByText(query2, currentValue);
            const value = this.getItemValue(item);
            function cleanup() {
              clearTimeout(state2.timer);
              state2.timer = -1;
            }
            function update(value2) {
              state2.keysSoFar = value2;
              cleanup();
              if (value2 !== "") {
                state2.timer = +setTimeout(() => {
                  update("");
                  cleanup();
                }, timeout);
              }
            }
            update(search);
            return value;
          });
          __publicField4(this, "update", (value, item) => {
            let index = this.indexOf(value);
            if (index === -1) return this;
            return this.copy([...this.items.slice(0, index), item, ...this.items.slice(index + 1)]);
          });
          __publicField4(this, "upsert", (value, item, mode = "append") => {
            let index = this.indexOf(value);
            if (index === -1) {
              const fn = mode === "append" ? this.append : this.prepend;
              return fn(item);
            }
            return this.copy([...this.items.slice(0, index), item, ...this.items.slice(index + 1)]);
          });
          __publicField4(this, "insert", (index, ...items) => {
            return this.copy(insert(this.items, index, ...items));
          });
          __publicField4(this, "insertBefore", (value, ...items) => {
            let toIndex = this.indexOf(value);
            if (toIndex === -1) {
              if (this.items.length === 0) toIndex = 0;
              else return this;
            }
            return this.copy(insert(this.items, toIndex, ...items));
          });
          __publicField4(this, "insertAfter", (value, ...items) => {
            let toIndex = this.indexOf(value);
            if (toIndex === -1) {
              if (this.items.length === 0) toIndex = 0;
              else return this;
            }
            return this.copy(insert(this.items, toIndex + 1, ...items));
          });
          __publicField4(this, "prepend", (...items) => {
            return this.copy(insert(this.items, 0, ...items));
          });
          __publicField4(this, "append", (...items) => {
            return this.copy(insert(this.items, this.items.length, ...items));
          });
          __publicField4(this, "filter", (fn) => {
            const filteredItems = this.items.filter((item, index) => fn(this.stringifyItem(item), index, item));
            return this.copy(filteredItems);
          });
          __publicField4(this, "remove", (...itemsOrValues) => {
            const values = itemsOrValues.map(
              (itemOrValue) => typeof itemOrValue === "string" ? itemOrValue : this.getItemValue(itemOrValue)
            );
            return this.copy(
              this.items.filter((item) => {
                const value = this.getItemValue(item);
                if (value == null) return false;
                return !values.includes(value);
              })
            );
          });
          __publicField4(this, "move", (value, toIndex) => {
            const fromIndex = this.indexOf(value);
            if (fromIndex === -1) return this;
            return this.copy(move(this.items, [fromIndex], toIndex));
          });
          __publicField4(this, "moveBefore", (value, ...values) => {
            let toIndex = this.items.findIndex((item) => this.getItemValue(item) === value);
            if (toIndex === -1) return this;
            let indices = values.map((value2) => this.items.findIndex((item) => this.getItemValue(item) === value2)).sort((a2, b2) => a2 - b2);
            return this.copy(move(this.items, indices, toIndex));
          });
          __publicField4(this, "moveAfter", (value, ...values) => {
            let toIndex = this.items.findIndex((item) => this.getItemValue(item) === value);
            if (toIndex === -1) return this;
            let indices = values.map((value2) => this.items.findIndex((item) => this.getItemValue(item) === value2)).sort((a2, b2) => a2 - b2);
            return this.copy(move(this.items, indices, toIndex + 1));
          });
          __publicField4(this, "reorder", (fromIndex, toIndex) => {
            return this.copy(move(this.items, [fromIndex], toIndex));
          });
          __publicField4(this, "compareValue", (a2, b2) => {
            const indexA = this.indexOf(a2);
            const indexB = this.indexOf(b2);
            if (indexA < indexB) return -1;
            if (indexA > indexB) return 1;
            return 0;
          });
          __publicField4(this, "range", (from, to) => {
            let keys = [];
            let key = from;
            while (key != null) {
              let item = this.find(key);
              if (item) keys.push(key);
              if (key === to) return keys;
              key = this.getNextValue(key);
            }
            return [];
          });
          __publicField4(this, "getValueRange", (from, to) => {
            if (from && to) {
              if (this.compareValue(from, to) <= 0) {
                return this.range(from, to);
              }
              return this.range(to, from);
            }
            return [];
          });
          __publicField4(this, "toString", () => {
            let result = "";
            for (const item of this.items) {
              const value = this.getItemValue(item);
              const label = this.stringifyItem(item);
              const disabled = this.getItemDisabled(item);
              const itemString = [value, label, disabled].filter(Boolean).join(":");
              result += itemString + ",";
            }
            return result;
          });
          __publicField4(this, "toJSON", () => {
            return {
              size: this.size,
              first: this.firstValue,
              last: this.lastValue
            };
          });
          this.items = [...options.items];
        }
        /**
         * Returns the number of items in the collection
         */
        get size() {
          return this.items.length;
        }
        /**
         * Returns the first value in the collection
         */
        get firstValue() {
          let index = 0;
          while (this.getItemDisabled(this.at(index))) index++;
          return this.getItemValue(this.at(index));
        }
        /**
         * Returns the last value in the collection
         */
        get lastValue() {
          let index = this.size - 1;
          while (this.getItemDisabled(this.at(index))) index--;
          return this.getItemValue(this.at(index));
        }
        *[Symbol.iterator]() {
          yield* __yieldStar(this.items);
        }
      };
      match3 = (label, query2) => {
        return !!(label == null ? void 0 : label.toLowerCase().startsWith(query2.toLowerCase()));
      };
      TreeCollection = class _TreeCollection {
        constructor(options) {
          this.options = options;
          __publicField4(this, "rootNode");
          __publicField4(this, "isEqual", (other) => {
            return isEqual2(this.rootNode, other.rootNode);
          });
          __publicField4(this, "getNodeChildren", (node) => {
            var _a, _b, _c, _d;
            return (_d = (_c = (_b = (_a = this.options).nodeToChildren) == null ? void 0 : _b.call(_a, node)) != null ? _c : fallbackMethods.nodeToChildren(node)) != null ? _d : [];
          });
          __publicField4(this, "resolveIndexPath", (valueOrIndexPath) => {
            return typeof valueOrIndexPath === "string" ? this.getIndexPath(valueOrIndexPath) : valueOrIndexPath;
          });
          __publicField4(this, "resolveNode", (valueOrIndexPath) => {
            const indexPath = this.resolveIndexPath(valueOrIndexPath);
            return indexPath ? this.at(indexPath) : void 0;
          });
          __publicField4(this, "getNodeChildrenCount", (node) => {
            var _a, _b, _c;
            return (_c = (_b = (_a = this.options).nodeToChildrenCount) == null ? void 0 : _b.call(_a, node)) != null ? _c : fallbackMethods.nodeToChildrenCount(node);
          });
          __publicField4(this, "getNodeValue", (node) => {
            var _a, _b, _c;
            return (_c = (_b = (_a = this.options).nodeToValue) == null ? void 0 : _b.call(_a, node)) != null ? _c : fallbackMethods.nodeToValue(node);
          });
          __publicField4(this, "getNodeDisabled", (node) => {
            var _a, _b, _c;
            return (_c = (_b = (_a = this.options).isNodeDisabled) == null ? void 0 : _b.call(_a, node)) != null ? _c : fallbackMethods.isNodeDisabled(node);
          });
          __publicField4(this, "stringify", (value) => {
            const node = this.findNode(value);
            if (!node) return null;
            return this.stringifyNode(node);
          });
          __publicField4(this, "stringifyNode", (node) => {
            var _a, _b, _c;
            return (_c = (_b = (_a = this.options).nodeToString) == null ? void 0 : _b.call(_a, node)) != null ? _c : fallbackMethods.nodeToString(node);
          });
          __publicField4(this, "getFirstNode", (rootNode = this.rootNode, opts = {}) => {
            let firstChild;
            visit(rootNode, {
              getChildren: this.getNodeChildren,
              onEnter: (node, indexPath) => {
                var _a;
                if (this.isSameNode(node, rootNode)) return;
                if ((_a = opts.skip) == null ? void 0 : _a.call(opts, { value: this.getNodeValue(node), node, indexPath })) return "skip";
                if (!firstChild && indexPath.length > 0 && !this.getNodeDisabled(node)) {
                  firstChild = node;
                  return "stop";
                }
              }
            });
            return firstChild;
          });
          __publicField4(this, "getLastNode", (rootNode = this.rootNode, opts = {}) => {
            let lastChild;
            visit(rootNode, {
              getChildren: this.getNodeChildren,
              onEnter: (node, indexPath) => {
                var _a;
                if (this.isSameNode(node, rootNode)) return;
                if ((_a = opts.skip) == null ? void 0 : _a.call(opts, { value: this.getNodeValue(node), node, indexPath })) return "skip";
                if (indexPath.length > 0 && !this.getNodeDisabled(node)) {
                  lastChild = node;
                }
              }
            });
            return lastChild;
          });
          __publicField4(this, "at", (indexPath) => {
            return access(this.rootNode, indexPath, {
              getChildren: this.getNodeChildren
            });
          });
          __publicField4(this, "findNode", (value, rootNode = this.rootNode) => {
            return find(rootNode, {
              getChildren: this.getNodeChildren,
              predicate: (node) => this.getNodeValue(node) === value
            });
          });
          __publicField4(this, "findNodes", (values, rootNode = this.rootNode) => {
            const v2 = new Set(values.filter((v22) => v22 != null));
            return findAll(rootNode, {
              getChildren: this.getNodeChildren,
              predicate: (node) => v2.has(this.getNodeValue(node))
            });
          });
          __publicField4(this, "sort", (values) => {
            return values.reduce((acc, value) => {
              const indexPath = this.getIndexPath(value);
              if (indexPath) acc.push({ value, indexPath });
              return acc;
            }, []).sort((a2, b2) => compareIndexPaths(a2.indexPath, b2.indexPath)).map(({ value }) => value);
          });
          __publicField4(this, "getIndexPath", (value) => {
            return findIndexPath(this.rootNode, {
              getChildren: this.getNodeChildren,
              predicate: (node) => this.getNodeValue(node) === value
            });
          });
          __publicField4(this, "getValue", (indexPath) => {
            const node = this.at(indexPath);
            return node ? this.getNodeValue(node) : void 0;
          });
          __publicField4(this, "getValuePath", (indexPath) => {
            if (!indexPath) return [];
            const valuePath = [];
            let currentPath = [...indexPath];
            while (currentPath.length > 0) {
              const node = this.at(currentPath);
              if (node) valuePath.unshift(this.getNodeValue(node));
              currentPath.pop();
            }
            return valuePath;
          });
          __publicField4(this, "getDepth", (value) => {
            var _a;
            const indexPath = findIndexPath(this.rootNode, {
              getChildren: this.getNodeChildren,
              predicate: (node) => this.getNodeValue(node) === value
            });
            return (_a = indexPath == null ? void 0 : indexPath.length) != null ? _a : 0;
          });
          __publicField4(this, "isSameNode", (node, other) => {
            return this.getNodeValue(node) === this.getNodeValue(other);
          });
          __publicField4(this, "isRootNode", (node) => {
            return this.isSameNode(node, this.rootNode);
          });
          __publicField4(this, "contains", (parentIndexPath, valueIndexPath) => {
            if (!parentIndexPath || !valueIndexPath) return false;
            return valueIndexPath.slice(0, parentIndexPath.length).every((_2, i2) => parentIndexPath[i2] === valueIndexPath[i2]);
          });
          __publicField4(this, "getNextNode", (value, opts = {}) => {
            let found = false;
            let nextNode;
            visit(this.rootNode, {
              getChildren: this.getNodeChildren,
              onEnter: (node, indexPath) => {
                var _a;
                if (this.isRootNode(node)) return;
                const nodeValue = this.getNodeValue(node);
                if ((_a = opts.skip) == null ? void 0 : _a.call(opts, { value: nodeValue, node, indexPath })) {
                  if (nodeValue === value) {
                    found = true;
                  }
                  return "skip";
                }
                if (found && !this.getNodeDisabled(node)) {
                  nextNode = node;
                  return "stop";
                }
                if (nodeValue === value) {
                  found = true;
                }
              }
            });
            return nextNode;
          });
          __publicField4(this, "getPreviousNode", (value, opts = {}) => {
            let previousNode;
            let found = false;
            visit(this.rootNode, {
              getChildren: this.getNodeChildren,
              onEnter: (node, indexPath) => {
                var _a;
                if (this.isRootNode(node)) return;
                const nodeValue = this.getNodeValue(node);
                if ((_a = opts.skip) == null ? void 0 : _a.call(opts, { value: nodeValue, node, indexPath })) {
                  return "skip";
                }
                if (nodeValue === value) {
                  found = true;
                  return "stop";
                }
                if (!this.getNodeDisabled(node)) {
                  previousNode = node;
                }
              }
            });
            return found ? previousNode : void 0;
          });
          __publicField4(this, "getParentNodes", (valueOrIndexPath) => {
            var _a;
            const indexPath = (_a = this.resolveIndexPath(valueOrIndexPath)) == null ? void 0 : _a.slice();
            if (!indexPath) return [];
            const result = [];
            while (indexPath.length > 0) {
              indexPath.pop();
              const parentNode = this.at(indexPath);
              if (parentNode && !this.isRootNode(parentNode)) {
                result.unshift(parentNode);
              }
            }
            return result;
          });
          __publicField4(this, "getDescendantNodes", (valueOrIndexPath, options2) => {
            const parentNode = this.resolveNode(valueOrIndexPath);
            if (!parentNode) return [];
            const result = [];
            visit(parentNode, {
              getChildren: this.getNodeChildren,
              onEnter: (node, nodeIndexPath) => {
                if (nodeIndexPath.length === 0) return;
                if (!(options2 == null ? void 0 : options2.withBranch) && this.isBranchNode(node)) return;
                result.push(node);
              }
            });
            return result;
          });
          __publicField4(this, "getDescendantValues", (valueOrIndexPath, options2) => {
            const children = this.getDescendantNodes(valueOrIndexPath, options2);
            return children.map((child) => this.getNodeValue(child));
          });
          __publicField4(this, "getParentIndexPath", (indexPath) => {
            return indexPath.slice(0, -1);
          });
          __publicField4(this, "getParentNode", (valueOrIndexPath) => {
            const indexPath = this.resolveIndexPath(valueOrIndexPath);
            return indexPath ? this.at(this.getParentIndexPath(indexPath)) : void 0;
          });
          __publicField4(this, "visit", (opts) => {
            const _a = opts, { skip } = _a, rest = __objRest(_a, ["skip"]);
            visit(this.rootNode, __spreadProps(__spreadValues({}, rest), {
              getChildren: this.getNodeChildren,
              onEnter: (node, indexPath) => {
                var _a2;
                if (this.isRootNode(node)) return;
                if (skip == null ? void 0 : skip({ value: this.getNodeValue(node), node, indexPath })) return "skip";
                return (_a2 = rest.onEnter) == null ? void 0 : _a2.call(rest, node, indexPath);
              }
            }));
          });
          __publicField4(this, "getPreviousSibling", (indexPath) => {
            const parentNode = this.getParentNode(indexPath);
            if (!parentNode) return;
            const siblings = this.getNodeChildren(parentNode);
            let idx = indexPath[indexPath.length - 1];
            while (--idx >= 0) {
              const sibling = siblings[idx];
              if (!this.getNodeDisabled(sibling)) return sibling;
            }
            return;
          });
          __publicField4(this, "getNextSibling", (indexPath) => {
            const parentNode = this.getParentNode(indexPath);
            if (!parentNode) return;
            const siblings = this.getNodeChildren(parentNode);
            let idx = indexPath[indexPath.length - 1];
            while (++idx < siblings.length) {
              const sibling = siblings[idx];
              if (!this.getNodeDisabled(sibling)) return sibling;
            }
            return;
          });
          __publicField4(this, "getSiblingNodes", (indexPath) => {
            const parentNode = this.getParentNode(indexPath);
            return parentNode ? this.getNodeChildren(parentNode) : [];
          });
          __publicField4(this, "getValues", (rootNode = this.rootNode) => {
            const values = flatMap(rootNode, {
              getChildren: this.getNodeChildren,
              transform: (node) => [this.getNodeValue(node)]
            });
            return values.slice(1);
          });
          __publicField4(this, "isValidDepth", (indexPath, depth) => {
            if (depth == null) return true;
            if (typeof depth === "function") return depth(indexPath.length);
            return indexPath.length === depth;
          });
          __publicField4(this, "isBranchNode", (node) => {
            return this.getNodeChildren(node).length > 0 || this.getNodeChildrenCount(node) != null;
          });
          __publicField4(this, "getBranchValues", (rootNode = this.rootNode, opts = {}) => {
            let values = [];
            visit(rootNode, {
              getChildren: this.getNodeChildren,
              onEnter: (node, indexPath) => {
                var _a;
                if (indexPath.length === 0) return;
                const nodeValue = this.getNodeValue(node);
                if ((_a = opts.skip) == null ? void 0 : _a.call(opts, { value: nodeValue, node, indexPath })) return "skip";
                if (this.isBranchNode(node) && this.isValidDepth(indexPath, opts.depth)) {
                  values.push(this.getNodeValue(node));
                }
              }
            });
            return values;
          });
          __publicField4(this, "flatten", (rootNode = this.rootNode) => {
            return flatten(rootNode, { getChildren: this.getNodeChildren });
          });
          __publicField4(this, "_create", (node, children) => {
            if (this.getNodeChildren(node).length > 0 || children.length > 0) {
              return __spreadProps(__spreadValues({}, node), { children });
            }
            return __spreadValues({}, node);
          });
          __publicField4(this, "_insert", (rootNode, indexPath, nodes) => {
            return this.copy(
              insert2(rootNode, { at: indexPath, nodes, getChildren: this.getNodeChildren, create: this._create })
            );
          });
          __publicField4(this, "copy", (rootNode) => {
            return new _TreeCollection(__spreadProps(__spreadValues({}, this.options), { rootNode }));
          });
          __publicField4(this, "_replace", (rootNode, indexPath, node) => {
            return this.copy(
              replace(rootNode, { at: indexPath, node, getChildren: this.getNodeChildren, create: this._create })
            );
          });
          __publicField4(this, "_move", (rootNode, indexPaths, to) => {
            return this.copy(move2(rootNode, { indexPaths, to, getChildren: this.getNodeChildren, create: this._create }));
          });
          __publicField4(this, "_remove", (rootNode, indexPaths) => {
            return this.copy(remove2(rootNode, { indexPaths, getChildren: this.getNodeChildren, create: this._create }));
          });
          __publicField4(this, "replace", (indexPath, node) => {
            return this._replace(this.rootNode, indexPath, node);
          });
          __publicField4(this, "remove", (indexPaths) => {
            return this._remove(this.rootNode, indexPaths);
          });
          __publicField4(this, "insertBefore", (indexPath, nodes) => {
            const parentNode = this.getParentNode(indexPath);
            return parentNode ? this._insert(this.rootNode, indexPath, nodes) : void 0;
          });
          __publicField4(this, "insertAfter", (indexPath, nodes) => {
            const parentNode = this.getParentNode(indexPath);
            if (!parentNode) return;
            const nextIndex2 = [...indexPath.slice(0, -1), indexPath[indexPath.length - 1] + 1];
            return this._insert(this.rootNode, nextIndex2, nodes);
          });
          __publicField4(this, "move", (fromIndexPaths, toIndexPath) => {
            return this._move(this.rootNode, fromIndexPaths, toIndexPath);
          });
          __publicField4(this, "filter", (predicate) => {
            const filteredRoot = filter(this.rootNode, {
              predicate,
              getChildren: this.getNodeChildren,
              create: this._create
            });
            return this.copy(filteredRoot);
          });
          __publicField4(this, "toJSON", () => {
            return this.getValues(this.rootNode);
          });
          this.rootNode = options.rootNode;
        }
      };
      fallbackMethods = {
        nodeToValue(node) {
          if (typeof node === "string") return node;
          if (isObject2(node) && hasProp(node, "value")) return node.value;
          return "";
        },
        nodeToString(node) {
          if (typeof node === "string") return node;
          if (isObject2(node) && hasProp(node, "label")) return node.label;
          return fallbackMethods.nodeToValue(node);
        },
        isNodeDisabled(node) {
          if (isObject2(node) && hasProp(node, "disabled")) return !!node.disabled;
          return false;
        },
        nodeToChildren(node) {
          return node.children;
        },
        nodeToChildrenCount(node) {
          if (isObject2(node) && hasProp(node, "childrenCount")) return node.childrenCount;
        }
      };
    }
  });

  // ../priv/static/chunk-GRHV6R4F.mjs
  function clamp2(start, value, end) {
    return max2(start, min2(value, end));
  }
  function evaluate(value, param) {
    return typeof value === "function" ? value(param) : value;
  }
  function getSide(placement) {
    return placement.split("-")[0];
  }
  function getAlignment(placement) {
    return placement.split("-")[1];
  }
  function getOppositeAxis(axis) {
    return axis === "x" ? "y" : "x";
  }
  function getAxisLength(axis) {
    return axis === "y" ? "height" : "width";
  }
  function getSideAxis(placement) {
    return yAxisSides.has(getSide(placement)) ? "y" : "x";
  }
  function getAlignmentAxis(placement) {
    return getOppositeAxis(getSideAxis(placement));
  }
  function getAlignmentSides(placement, rects, rtl) {
    if (rtl === void 0) {
      rtl = false;
    }
    const alignment = getAlignment(placement);
    const alignmentAxis = getAlignmentAxis(placement);
    const length = getAxisLength(alignmentAxis);
    let mainAlignmentSide = alignmentAxis === "x" ? alignment === (rtl ? "end" : "start") ? "right" : "left" : alignment === "start" ? "bottom" : "top";
    if (rects.reference[length] > rects.floating[length]) {
      mainAlignmentSide = getOppositePlacement(mainAlignmentSide);
    }
    return [mainAlignmentSide, getOppositePlacement(mainAlignmentSide)];
  }
  function getExpandedPlacements(placement) {
    const oppositePlacement = getOppositePlacement(placement);
    return [getOppositeAlignmentPlacement(placement), oppositePlacement, getOppositeAlignmentPlacement(oppositePlacement)];
  }
  function getOppositeAlignmentPlacement(placement) {
    return placement.replace(/start|end/g, (alignment) => oppositeAlignmentMap[alignment]);
  }
  function getSideList(side, isStart, rtl) {
    switch (side) {
      case "top":
      case "bottom":
        if (rtl) return isStart ? rlPlacement : lrPlacement;
        return isStart ? lrPlacement : rlPlacement;
      case "left":
      case "right":
        return isStart ? tbPlacement : btPlacement;
      default:
        return [];
    }
  }
  function getOppositeAxisPlacements(placement, flipAlignment, direction, rtl) {
    const alignment = getAlignment(placement);
    let list = getSideList(getSide(placement), direction === "start", rtl);
    if (alignment) {
      list = list.map((side) => side + "-" + alignment);
      if (flipAlignment) {
        list = list.concat(list.map(getOppositeAlignmentPlacement));
      }
    }
    return list;
  }
  function getOppositePlacement(placement) {
    return placement.replace(/left|right|bottom|top/g, (side) => oppositeSideMap[side]);
  }
  function expandPaddingObject(padding) {
    return __spreadValues({
      top: 0,
      right: 0,
      bottom: 0,
      left: 0
    }, padding);
  }
  function getPaddingObject(padding) {
    return typeof padding !== "number" ? expandPaddingObject(padding) : {
      top: padding,
      right: padding,
      bottom: padding,
      left: padding
    };
  }
  function rectToClientRect(rect) {
    const {
      x: x2,
      y: y2,
      width,
      height
    } = rect;
    return {
      width,
      height,
      top: y2,
      left: x2,
      right: x2 + width,
      bottom: y2 + height,
      x: x2,
      y: y2
    };
  }
  function computeCoordsFromPlacement(_ref, placement, rtl) {
    let {
      reference,
      floating
    } = _ref;
    const sideAxis = getSideAxis(placement);
    const alignmentAxis = getAlignmentAxis(placement);
    const alignLength = getAxisLength(alignmentAxis);
    const side = getSide(placement);
    const isVertical = sideAxis === "y";
    const commonX = reference.x + reference.width / 2 - floating.width / 2;
    const commonY = reference.y + reference.height / 2 - floating.height / 2;
    const commonAlign = reference[alignLength] / 2 - floating[alignLength] / 2;
    let coords;
    switch (side) {
      case "top":
        coords = {
          x: commonX,
          y: reference.y - floating.height
        };
        break;
      case "bottom":
        coords = {
          x: commonX,
          y: reference.y + reference.height
        };
        break;
      case "right":
        coords = {
          x: reference.x + reference.width,
          y: commonY
        };
        break;
      case "left":
        coords = {
          x: reference.x - floating.width,
          y: commonY
        };
        break;
      default:
        coords = {
          x: reference.x,
          y: reference.y
        };
    }
    switch (getAlignment(placement)) {
      case "start":
        coords[alignmentAxis] -= commonAlign * (rtl && isVertical ? -1 : 1);
        break;
      case "end":
        coords[alignmentAxis] += commonAlign * (rtl && isVertical ? -1 : 1);
        break;
    }
    return coords;
  }
  function detectOverflow(state2, options) {
    return __async(this, null, function* () {
      var _await$platform$isEle;
      if (options === void 0) {
        options = {};
      }
      const {
        x: x2,
        y: y2,
        platform: platform2,
        rects,
        elements,
        strategy
      } = state2;
      const {
        boundary = "clippingAncestors",
        rootBoundary = "viewport",
        elementContext = "floating",
        altBoundary = false,
        padding = 0
      } = evaluate(options, state2);
      const paddingObject = getPaddingObject(padding);
      const altContext = elementContext === "floating" ? "reference" : "floating";
      const element = elements[altBoundary ? altContext : elementContext];
      const clippingClientRect = rectToClientRect(yield platform2.getClippingRect({
        element: ((_await$platform$isEle = yield platform2.isElement == null ? void 0 : platform2.isElement(element)) != null ? _await$platform$isEle : true) ? element : element.contextElement || (yield platform2.getDocumentElement == null ? void 0 : platform2.getDocumentElement(elements.floating)),
        boundary,
        rootBoundary,
        strategy
      }));
      const rect = elementContext === "floating" ? {
        x: x2,
        y: y2,
        width: rects.floating.width,
        height: rects.floating.height
      } : rects.reference;
      const offsetParent = yield platform2.getOffsetParent == null ? void 0 : platform2.getOffsetParent(elements.floating);
      const offsetScale = (yield platform2.isElement == null ? void 0 : platform2.isElement(offsetParent)) ? (yield platform2.getScale == null ? void 0 : platform2.getScale(offsetParent)) || {
        x: 1,
        y: 1
      } : {
        x: 1,
        y: 1
      };
      const elementClientRect = rectToClientRect(platform2.convertOffsetParentRelativeRectToViewportRelativeRect ? yield platform2.convertOffsetParentRelativeRectToViewportRelativeRect({
        elements,
        rect,
        offsetParent,
        strategy
      }) : rect);
      return {
        top: (clippingClientRect.top - elementClientRect.top + paddingObject.top) / offsetScale.y,
        bottom: (elementClientRect.bottom - clippingClientRect.bottom + paddingObject.bottom) / offsetScale.y,
        left: (clippingClientRect.left - elementClientRect.left + paddingObject.left) / offsetScale.x,
        right: (elementClientRect.right - clippingClientRect.right + paddingObject.right) / offsetScale.x
      };
    });
  }
  function getSideOffsets(overflow, rect) {
    return {
      top: overflow.top - rect.height,
      right: overflow.right - rect.width,
      bottom: overflow.bottom - rect.height,
      left: overflow.left - rect.width
    };
  }
  function isAnySideFullyClipped(overflow) {
    return sides.some((side) => overflow[side] >= 0);
  }
  function convertValueToCoords(state2, options) {
    return __async(this, null, function* () {
      const {
        placement,
        platform: platform2,
        elements
      } = state2;
      const rtl = yield platform2.isRTL == null ? void 0 : platform2.isRTL(elements.floating);
      const side = getSide(placement);
      const alignment = getAlignment(placement);
      const isVertical = getSideAxis(placement) === "y";
      const mainAxisMulti = originSides.has(side) ? -1 : 1;
      const crossAxisMulti = rtl && isVertical ? -1 : 1;
      const rawValue = evaluate(options, state2);
      let {
        mainAxis,
        crossAxis,
        alignmentAxis
      } = typeof rawValue === "number" ? {
        mainAxis: rawValue,
        crossAxis: 0,
        alignmentAxis: null
      } : {
        mainAxis: rawValue.mainAxis || 0,
        crossAxis: rawValue.crossAxis || 0,
        alignmentAxis: rawValue.alignmentAxis
      };
      if (alignment && typeof alignmentAxis === "number") {
        crossAxis = alignment === "end" ? alignmentAxis * -1 : alignmentAxis;
      }
      return isVertical ? {
        x: crossAxis * crossAxisMulti,
        y: mainAxis * mainAxisMulti
      } : {
        x: mainAxis * mainAxisMulti,
        y: crossAxis * crossAxisMulti
      };
    });
  }
  function hasWindow() {
    return typeof window !== "undefined";
  }
  function getNodeName2(node) {
    if (isNode2(node)) {
      return (node.nodeName || "").toLowerCase();
    }
    return "#document";
  }
  function getWindow2(node) {
    var _node$ownerDocument;
    return (node == null || (_node$ownerDocument = node.ownerDocument) == null ? void 0 : _node$ownerDocument.defaultView) || window;
  }
  function getDocumentElement2(node) {
    var _ref;
    return (_ref = (isNode2(node) ? node.ownerDocument : node.document) || window.document) == null ? void 0 : _ref.documentElement;
  }
  function isNode2(value) {
    if (!hasWindow()) {
      return false;
    }
    return value instanceof Node || value instanceof getWindow2(value).Node;
  }
  function isElement2(value) {
    if (!hasWindow()) {
      return false;
    }
    return value instanceof Element || value instanceof getWindow2(value).Element;
  }
  function isHTMLElement2(value) {
    if (!hasWindow()) {
      return false;
    }
    return value instanceof HTMLElement || value instanceof getWindow2(value).HTMLElement;
  }
  function isShadowRoot2(value) {
    if (!hasWindow() || typeof ShadowRoot === "undefined") {
      return false;
    }
    return value instanceof ShadowRoot || value instanceof getWindow2(value).ShadowRoot;
  }
  function isOverflowElement2(element) {
    const {
      overflow,
      overflowX,
      overflowY,
      display
    } = getComputedStyle3(element);
    return /auto|scroll|overlay|hidden|clip/.test(overflow + overflowY + overflowX) && !invalidOverflowDisplayValues.has(display);
  }
  function isTableElement(element) {
    return tableElements.has(getNodeName2(element));
  }
  function isTopLayer(element) {
    return topLayerSelectors.some((selector) => {
      try {
        return element.matches(selector);
      } catch (_e) {
        return false;
      }
    });
  }
  function isContainingBlock(elementOrCss) {
    const webkit = isWebKit();
    const css2 = isElement2(elementOrCss) ? getComputedStyle3(elementOrCss) : elementOrCss;
    return transformProperties.some((value) => css2[value] ? css2[value] !== "none" : false) || (css2.containerType ? css2.containerType !== "normal" : false) || !webkit && (css2.backdropFilter ? css2.backdropFilter !== "none" : false) || !webkit && (css2.filter ? css2.filter !== "none" : false) || willChangeValues.some((value) => (css2.willChange || "").includes(value)) || containValues.some((value) => (css2.contain || "").includes(value));
  }
  function getContainingBlock(element) {
    let currentNode = getParentNode2(element);
    while (isHTMLElement2(currentNode) && !isLastTraversableNode(currentNode)) {
      if (isContainingBlock(currentNode)) {
        return currentNode;
      } else if (isTopLayer(currentNode)) {
        return null;
      }
      currentNode = getParentNode2(currentNode);
    }
    return null;
  }
  function isWebKit() {
    if (typeof CSS === "undefined" || !CSS.supports) return false;
    return CSS.supports("-webkit-backdrop-filter", "none");
  }
  function isLastTraversableNode(node) {
    return lastTraversableNodeNames.has(getNodeName2(node));
  }
  function getComputedStyle3(element) {
    return getWindow2(element).getComputedStyle(element);
  }
  function getNodeScroll(element) {
    if (isElement2(element)) {
      return {
        scrollLeft: element.scrollLeft,
        scrollTop: element.scrollTop
      };
    }
    return {
      scrollLeft: element.scrollX,
      scrollTop: element.scrollY
    };
  }
  function getParentNode2(node) {
    if (getNodeName2(node) === "html") {
      return node;
    }
    const result = (
      // Step into the shadow DOM of the parent of a slotted node.
      node.assignedSlot || // DOM Element detected.
      node.parentNode || // ShadowRoot detected.
      isShadowRoot2(node) && node.host || // Fallback.
      getDocumentElement2(node)
    );
    return isShadowRoot2(result) ? result.host : result;
  }
  function getNearestOverflowAncestor2(node) {
    const parentNode = getParentNode2(node);
    if (isLastTraversableNode(parentNode)) {
      return node.ownerDocument ? node.ownerDocument.body : node.body;
    }
    if (isHTMLElement2(parentNode) && isOverflowElement2(parentNode)) {
      return parentNode;
    }
    return getNearestOverflowAncestor2(parentNode);
  }
  function getOverflowAncestors(node, list, traverseIframes) {
    var _node$ownerDocument2;
    if (list === void 0) {
      list = [];
    }
    if (traverseIframes === void 0) {
      traverseIframes = true;
    }
    const scrollableAncestor = getNearestOverflowAncestor2(node);
    const isBody = scrollableAncestor === ((_node$ownerDocument2 = node.ownerDocument) == null ? void 0 : _node$ownerDocument2.body);
    const win = getWindow2(scrollableAncestor);
    if (isBody) {
      const frameElement = getFrameElement(win);
      return list.concat(win, win.visualViewport || [], isOverflowElement2(scrollableAncestor) ? scrollableAncestor : [], frameElement && traverseIframes ? getOverflowAncestors(frameElement) : []);
    }
    return list.concat(scrollableAncestor, getOverflowAncestors(scrollableAncestor, [], traverseIframes));
  }
  function getFrameElement(win) {
    return win.parent && Object.getPrototypeOf(win.parent) ? win.frameElement : null;
  }
  function getCssDimensions(element) {
    const css2 = getComputedStyle3(element);
    let width = parseFloat(css2.width) || 0;
    let height = parseFloat(css2.height) || 0;
    const hasOffset = isHTMLElement2(element);
    const offsetWidth = hasOffset ? element.offsetWidth : width;
    const offsetHeight = hasOffset ? element.offsetHeight : height;
    const shouldFallback = round2(width) !== offsetWidth || round2(height) !== offsetHeight;
    if (shouldFallback) {
      width = offsetWidth;
      height = offsetHeight;
    }
    return {
      width,
      height,
      $: shouldFallback
    };
  }
  function unwrapElement(element) {
    return !isElement2(element) ? element.contextElement : element;
  }
  function getScale(element) {
    const domElement = unwrapElement(element);
    if (!isHTMLElement2(domElement)) {
      return createCoords(1);
    }
    const rect = domElement.getBoundingClientRect();
    const {
      width,
      height,
      $
    } = getCssDimensions(domElement);
    let x2 = ($ ? round2(rect.width) : rect.width) / width;
    let y2 = ($ ? round2(rect.height) : rect.height) / height;
    if (!x2 || !Number.isFinite(x2)) {
      x2 = 1;
    }
    if (!y2 || !Number.isFinite(y2)) {
      y2 = 1;
    }
    return {
      x: x2,
      y: y2
    };
  }
  function getVisualOffsets(element) {
    const win = getWindow2(element);
    if (!isWebKit() || !win.visualViewport) {
      return noOffsets;
    }
    return {
      x: win.visualViewport.offsetLeft,
      y: win.visualViewport.offsetTop
    };
  }
  function shouldAddVisualOffsets(element, isFixed, floatingOffsetParent) {
    if (isFixed === void 0) {
      isFixed = false;
    }
    if (!floatingOffsetParent || isFixed && floatingOffsetParent !== getWindow2(element)) {
      return false;
    }
    return isFixed;
  }
  function getBoundingClientRect(element, includeScale, isFixedStrategy, offsetParent) {
    if (includeScale === void 0) {
      includeScale = false;
    }
    if (isFixedStrategy === void 0) {
      isFixedStrategy = false;
    }
    const clientRect = element.getBoundingClientRect();
    const domElement = unwrapElement(element);
    let scale = createCoords(1);
    if (includeScale) {
      if (offsetParent) {
        if (isElement2(offsetParent)) {
          scale = getScale(offsetParent);
        }
      } else {
        scale = getScale(element);
      }
    }
    const visualOffsets = shouldAddVisualOffsets(domElement, isFixedStrategy, offsetParent) ? getVisualOffsets(domElement) : createCoords(0);
    let x2 = (clientRect.left + visualOffsets.x) / scale.x;
    let y2 = (clientRect.top + visualOffsets.y) / scale.y;
    let width = clientRect.width / scale.x;
    let height = clientRect.height / scale.y;
    if (domElement) {
      const win = getWindow2(domElement);
      const offsetWin = offsetParent && isElement2(offsetParent) ? getWindow2(offsetParent) : offsetParent;
      let currentWin = win;
      let currentIFrame = getFrameElement(currentWin);
      while (currentIFrame && offsetParent && offsetWin !== currentWin) {
        const iframeScale = getScale(currentIFrame);
        const iframeRect = currentIFrame.getBoundingClientRect();
        const css2 = getComputedStyle3(currentIFrame);
        const left = iframeRect.left + (currentIFrame.clientLeft + parseFloat(css2.paddingLeft)) * iframeScale.x;
        const top = iframeRect.top + (currentIFrame.clientTop + parseFloat(css2.paddingTop)) * iframeScale.y;
        x2 *= iframeScale.x;
        y2 *= iframeScale.y;
        width *= iframeScale.x;
        height *= iframeScale.y;
        x2 += left;
        y2 += top;
        currentWin = getWindow2(currentIFrame);
        currentIFrame = getFrameElement(currentWin);
      }
    }
    return rectToClientRect({
      width,
      height,
      x: x2,
      y: y2
    });
  }
  function getWindowScrollBarX(element, rect) {
    const leftScroll = getNodeScroll(element).scrollLeft;
    if (!rect) {
      return getBoundingClientRect(getDocumentElement2(element)).left + leftScroll;
    }
    return rect.left + leftScroll;
  }
  function getHTMLOffset(documentElement, scroll) {
    const htmlRect = documentElement.getBoundingClientRect();
    const x2 = htmlRect.left + scroll.scrollLeft - getWindowScrollBarX(documentElement, htmlRect);
    const y2 = htmlRect.top + scroll.scrollTop;
    return {
      x: x2,
      y: y2
    };
  }
  function convertOffsetParentRelativeRectToViewportRelativeRect(_ref) {
    let {
      elements,
      rect,
      offsetParent,
      strategy
    } = _ref;
    const isFixed = strategy === "fixed";
    const documentElement = getDocumentElement2(offsetParent);
    const topLayer = elements ? isTopLayer(elements.floating) : false;
    if (offsetParent === documentElement || topLayer && isFixed) {
      return rect;
    }
    let scroll = {
      scrollLeft: 0,
      scrollTop: 0
    };
    let scale = createCoords(1);
    const offsets = createCoords(0);
    const isOffsetParentAnElement = isHTMLElement2(offsetParent);
    if (isOffsetParentAnElement || !isOffsetParentAnElement && !isFixed) {
      if (getNodeName2(offsetParent) !== "body" || isOverflowElement2(documentElement)) {
        scroll = getNodeScroll(offsetParent);
      }
      if (isHTMLElement2(offsetParent)) {
        const offsetRect = getBoundingClientRect(offsetParent);
        scale = getScale(offsetParent);
        offsets.x = offsetRect.x + offsetParent.clientLeft;
        offsets.y = offsetRect.y + offsetParent.clientTop;
      }
    }
    const htmlOffset = documentElement && !isOffsetParentAnElement && !isFixed ? getHTMLOffset(documentElement, scroll) : createCoords(0);
    return {
      width: rect.width * scale.x,
      height: rect.height * scale.y,
      x: rect.x * scale.x - scroll.scrollLeft * scale.x + offsets.x + htmlOffset.x,
      y: rect.y * scale.y - scroll.scrollTop * scale.y + offsets.y + htmlOffset.y
    };
  }
  function getClientRects(element) {
    return Array.from(element.getClientRects());
  }
  function getDocumentRect(element) {
    const html = getDocumentElement2(element);
    const scroll = getNodeScroll(element);
    const body = element.ownerDocument.body;
    const width = max2(html.scrollWidth, html.clientWidth, body.scrollWidth, body.clientWidth);
    const height = max2(html.scrollHeight, html.clientHeight, body.scrollHeight, body.clientHeight);
    let x2 = -scroll.scrollLeft + getWindowScrollBarX(element);
    const y2 = -scroll.scrollTop;
    if (getComputedStyle3(body).direction === "rtl") {
      x2 += max2(html.clientWidth, body.clientWidth) - width;
    }
    return {
      width,
      height,
      x: x2,
      y: y2
    };
  }
  function getViewportRect(element, strategy) {
    const win = getWindow2(element);
    const html = getDocumentElement2(element);
    const visualViewport = win.visualViewport;
    let width = html.clientWidth;
    let height = html.clientHeight;
    let x2 = 0;
    let y2 = 0;
    if (visualViewport) {
      width = visualViewport.width;
      height = visualViewport.height;
      const visualViewportBased = isWebKit();
      if (!visualViewportBased || visualViewportBased && strategy === "fixed") {
        x2 = visualViewport.offsetLeft;
        y2 = visualViewport.offsetTop;
      }
    }
    const windowScrollbarX = getWindowScrollBarX(html);
    if (windowScrollbarX <= 0) {
      const doc = html.ownerDocument;
      const body = doc.body;
      const bodyStyles = getComputedStyle(body);
      const bodyMarginInline = doc.compatMode === "CSS1Compat" ? parseFloat(bodyStyles.marginLeft) + parseFloat(bodyStyles.marginRight) || 0 : 0;
      const clippingStableScrollbarWidth = Math.abs(html.clientWidth - body.clientWidth - bodyMarginInline);
      if (clippingStableScrollbarWidth <= SCROLLBAR_MAX) {
        width -= clippingStableScrollbarWidth;
      }
    } else if (windowScrollbarX <= SCROLLBAR_MAX) {
      width += windowScrollbarX;
    }
    return {
      width,
      height,
      x: x2,
      y: y2
    };
  }
  function getInnerBoundingClientRect(element, strategy) {
    const clientRect = getBoundingClientRect(element, true, strategy === "fixed");
    const top = clientRect.top + element.clientTop;
    const left = clientRect.left + element.clientLeft;
    const scale = isHTMLElement2(element) ? getScale(element) : createCoords(1);
    const width = element.clientWidth * scale.x;
    const height = element.clientHeight * scale.y;
    const x2 = left * scale.x;
    const y2 = top * scale.y;
    return {
      width,
      height,
      x: x2,
      y: y2
    };
  }
  function getClientRectFromClippingAncestor(element, clippingAncestor, strategy) {
    let rect;
    if (clippingAncestor === "viewport") {
      rect = getViewportRect(element, strategy);
    } else if (clippingAncestor === "document") {
      rect = getDocumentRect(getDocumentElement2(element));
    } else if (isElement2(clippingAncestor)) {
      rect = getInnerBoundingClientRect(clippingAncestor, strategy);
    } else {
      const visualOffsets = getVisualOffsets(element);
      rect = {
        x: clippingAncestor.x - visualOffsets.x,
        y: clippingAncestor.y - visualOffsets.y,
        width: clippingAncestor.width,
        height: clippingAncestor.height
      };
    }
    return rectToClientRect(rect);
  }
  function hasFixedPositionAncestor(element, stopNode) {
    const parentNode = getParentNode2(element);
    if (parentNode === stopNode || !isElement2(parentNode) || isLastTraversableNode(parentNode)) {
      return false;
    }
    return getComputedStyle3(parentNode).position === "fixed" || hasFixedPositionAncestor(parentNode, stopNode);
  }
  function getClippingElementAncestors(element, cache) {
    const cachedResult = cache.get(element);
    if (cachedResult) {
      return cachedResult;
    }
    let result = getOverflowAncestors(element, [], false).filter((el) => isElement2(el) && getNodeName2(el) !== "body");
    let currentContainingBlockComputedStyle = null;
    const elementIsFixed = getComputedStyle3(element).position === "fixed";
    let currentNode = elementIsFixed ? getParentNode2(element) : element;
    while (isElement2(currentNode) && !isLastTraversableNode(currentNode)) {
      const computedStyle = getComputedStyle3(currentNode);
      const currentNodeIsContaining = isContainingBlock(currentNode);
      if (!currentNodeIsContaining && computedStyle.position === "fixed") {
        currentContainingBlockComputedStyle = null;
      }
      const shouldDropCurrentNode = elementIsFixed ? !currentNodeIsContaining && !currentContainingBlockComputedStyle : !currentNodeIsContaining && computedStyle.position === "static" && !!currentContainingBlockComputedStyle && absoluteOrFixed.has(currentContainingBlockComputedStyle.position) || isOverflowElement2(currentNode) && !currentNodeIsContaining && hasFixedPositionAncestor(element, currentNode);
      if (shouldDropCurrentNode) {
        result = result.filter((ancestor) => ancestor !== currentNode);
      } else {
        currentContainingBlockComputedStyle = computedStyle;
      }
      currentNode = getParentNode2(currentNode);
    }
    cache.set(element, result);
    return result;
  }
  function getClippingRect(_ref) {
    let {
      element,
      boundary,
      rootBoundary,
      strategy
    } = _ref;
    const elementClippingAncestors = boundary === "clippingAncestors" ? isTopLayer(element) ? [] : getClippingElementAncestors(element, this._c) : [].concat(boundary);
    const clippingAncestors = [...elementClippingAncestors, rootBoundary];
    const firstClippingAncestor = clippingAncestors[0];
    const clippingRect = clippingAncestors.reduce((accRect, clippingAncestor) => {
      const rect = getClientRectFromClippingAncestor(element, clippingAncestor, strategy);
      accRect.top = max2(rect.top, accRect.top);
      accRect.right = min2(rect.right, accRect.right);
      accRect.bottom = min2(rect.bottom, accRect.bottom);
      accRect.left = max2(rect.left, accRect.left);
      return accRect;
    }, getClientRectFromClippingAncestor(element, firstClippingAncestor, strategy));
    return {
      width: clippingRect.right - clippingRect.left,
      height: clippingRect.bottom - clippingRect.top,
      x: clippingRect.left,
      y: clippingRect.top
    };
  }
  function getDimensions(element) {
    const {
      width,
      height
    } = getCssDimensions(element);
    return {
      width,
      height
    };
  }
  function getRectRelativeToOffsetParent(element, offsetParent, strategy) {
    const isOffsetParentAnElement = isHTMLElement2(offsetParent);
    const documentElement = getDocumentElement2(offsetParent);
    const isFixed = strategy === "fixed";
    const rect = getBoundingClientRect(element, true, isFixed, offsetParent);
    let scroll = {
      scrollLeft: 0,
      scrollTop: 0
    };
    const offsets = createCoords(0);
    function setLeftRTLScrollbarOffset() {
      offsets.x = getWindowScrollBarX(documentElement);
    }
    if (isOffsetParentAnElement || !isOffsetParentAnElement && !isFixed) {
      if (getNodeName2(offsetParent) !== "body" || isOverflowElement2(documentElement)) {
        scroll = getNodeScroll(offsetParent);
      }
      if (isOffsetParentAnElement) {
        const offsetRect = getBoundingClientRect(offsetParent, true, isFixed, offsetParent);
        offsets.x = offsetRect.x + offsetParent.clientLeft;
        offsets.y = offsetRect.y + offsetParent.clientTop;
      } else if (documentElement) {
        setLeftRTLScrollbarOffset();
      }
    }
    if (isFixed && !isOffsetParentAnElement && documentElement) {
      setLeftRTLScrollbarOffset();
    }
    const htmlOffset = documentElement && !isOffsetParentAnElement && !isFixed ? getHTMLOffset(documentElement, scroll) : createCoords(0);
    const x2 = rect.left + scroll.scrollLeft - offsets.x - htmlOffset.x;
    const y2 = rect.top + scroll.scrollTop - offsets.y - htmlOffset.y;
    return {
      x: x2,
      y: y2,
      width: rect.width,
      height: rect.height
    };
  }
  function isStaticPositioned(element) {
    return getComputedStyle3(element).position === "static";
  }
  function getTrueOffsetParent(element, polyfill) {
    if (!isHTMLElement2(element) || getComputedStyle3(element).position === "fixed") {
      return null;
    }
    if (polyfill) {
      return polyfill(element);
    }
    let rawOffsetParent = element.offsetParent;
    if (getDocumentElement2(element) === rawOffsetParent) {
      rawOffsetParent = rawOffsetParent.ownerDocument.body;
    }
    return rawOffsetParent;
  }
  function getOffsetParent(element, polyfill) {
    const win = getWindow2(element);
    if (isTopLayer(element)) {
      return win;
    }
    if (!isHTMLElement2(element)) {
      let svgOffsetParent = getParentNode2(element);
      while (svgOffsetParent && !isLastTraversableNode(svgOffsetParent)) {
        if (isElement2(svgOffsetParent) && !isStaticPositioned(svgOffsetParent)) {
          return svgOffsetParent;
        }
        svgOffsetParent = getParentNode2(svgOffsetParent);
      }
      return win;
    }
    let offsetParent = getTrueOffsetParent(element, polyfill);
    while (offsetParent && isTableElement(offsetParent) && isStaticPositioned(offsetParent)) {
      offsetParent = getTrueOffsetParent(offsetParent, polyfill);
    }
    if (offsetParent && isLastTraversableNode(offsetParent) && isStaticPositioned(offsetParent) && !isContainingBlock(offsetParent)) {
      return win;
    }
    return offsetParent || getContainingBlock(element) || win;
  }
  function isRTL(element) {
    return getComputedStyle3(element).direction === "rtl";
  }
  function rectsAreEqual(a2, b2) {
    return a2.x === b2.x && a2.y === b2.y && a2.width === b2.width && a2.height === b2.height;
  }
  function observeMove(element, onMove) {
    let io = null;
    let timeoutId;
    const root = getDocumentElement2(element);
    function cleanup() {
      var _io;
      clearTimeout(timeoutId);
      (_io = io) == null || _io.disconnect();
      io = null;
    }
    function refresh(skip, threshold) {
      if (skip === void 0) {
        skip = false;
      }
      if (threshold === void 0) {
        threshold = 1;
      }
      cleanup();
      const elementRectForRootMargin = element.getBoundingClientRect();
      const {
        left,
        top,
        width,
        height
      } = elementRectForRootMargin;
      if (!skip) {
        onMove();
      }
      if (!width || !height) {
        return;
      }
      const insetTop = floor2(top);
      const insetRight = floor2(root.clientWidth - (left + width));
      const insetBottom = floor2(root.clientHeight - (top + height));
      const insetLeft = floor2(left);
      const rootMargin = -insetTop + "px " + -insetRight + "px " + -insetBottom + "px " + -insetLeft + "px";
      const options = {
        rootMargin,
        threshold: max2(0, min2(1, threshold)) || 1
      };
      let isFirstUpdate = true;
      function handleObserve(entries) {
        const ratio = entries[0].intersectionRatio;
        if (ratio !== threshold) {
          if (!isFirstUpdate) {
            return refresh();
          }
          if (!ratio) {
            timeoutId = setTimeout(() => {
              refresh(false, 1e-7);
            }, 1e3);
          } else {
            refresh(false, ratio);
          }
        }
        if (ratio === 1 && !rectsAreEqual(elementRectForRootMargin, element.getBoundingClientRect())) {
          refresh();
        }
        isFirstUpdate = false;
      }
      try {
        io = new IntersectionObserver(handleObserve, __spreadProps(__spreadValues({}, options), {
          // Handle <iframe>s
          root: root.ownerDocument
        }));
      } catch (_e) {
        io = new IntersectionObserver(handleObserve, options);
      }
      io.observe(element);
    }
    refresh(true);
    return cleanup;
  }
  function autoUpdate(reference, floating, update, options) {
    if (options === void 0) {
      options = {};
    }
    const {
      ancestorScroll = true,
      ancestorResize = true,
      elementResize = typeof ResizeObserver === "function",
      layoutShift = typeof IntersectionObserver === "function",
      animationFrame = false
    } = options;
    const referenceEl = unwrapElement(reference);
    const ancestors = ancestorScroll || ancestorResize ? [...referenceEl ? getOverflowAncestors(referenceEl) : [], ...getOverflowAncestors(floating)] : [];
    ancestors.forEach((ancestor) => {
      ancestorScroll && ancestor.addEventListener("scroll", update, {
        passive: true
      });
      ancestorResize && ancestor.addEventListener("resize", update);
    });
    const cleanupIo = referenceEl && layoutShift ? observeMove(referenceEl, update) : null;
    let reobserveFrame = -1;
    let resizeObserver = null;
    if (elementResize) {
      resizeObserver = new ResizeObserver((_ref) => {
        let [firstEntry] = _ref;
        if (firstEntry && firstEntry.target === referenceEl && resizeObserver) {
          resizeObserver.unobserve(floating);
          cancelAnimationFrame(reobserveFrame);
          reobserveFrame = requestAnimationFrame(() => {
            var _resizeObserver;
            (_resizeObserver = resizeObserver) == null || _resizeObserver.observe(floating);
          });
        }
        update();
      });
      if (referenceEl && !animationFrame) {
        resizeObserver.observe(referenceEl);
      }
      resizeObserver.observe(floating);
    }
    let frameId;
    let prevRefRect = animationFrame ? getBoundingClientRect(reference) : null;
    if (animationFrame) {
      frameLoop();
    }
    function frameLoop() {
      const nextRefRect = getBoundingClientRect(reference);
      if (prevRefRect && !rectsAreEqual(prevRefRect, nextRefRect)) {
        update();
      }
      prevRefRect = nextRefRect;
      frameId = requestAnimationFrame(frameLoop);
    }
    update();
    return () => {
      var _resizeObserver2;
      ancestors.forEach((ancestor) => {
        ancestorScroll && ancestor.removeEventListener("scroll", update);
        ancestorResize && ancestor.removeEventListener("resize", update);
      });
      cleanupIo == null || cleanupIo();
      (_resizeObserver2 = resizeObserver) == null || _resizeObserver2.disconnect();
      resizeObserver = null;
      if (animationFrame) {
        cancelAnimationFrame(frameId);
      }
    };
  }
  function createDOMRect(x2 = 0, y2 = 0, width = 0, height = 0) {
    if (typeof DOMRect === "function") {
      return new DOMRect(x2, y2, width, height);
    }
    const rect = {
      x: x2,
      y: y2,
      width,
      height,
      top: y2,
      right: x2 + width,
      bottom: y2 + height,
      left: x2
    };
    return __spreadProps(__spreadValues({}, rect), { toJSON: () => rect });
  }
  function getDOMRect(anchorRect) {
    if (!anchorRect) return createDOMRect();
    const { x: x2, y: y2, width, height } = anchorRect;
    return createDOMRect(x2, y2, width, height);
  }
  function getAnchorElement(anchorElement, getAnchorRect) {
    return {
      contextElement: isHTMLElement(anchorElement) ? anchorElement : anchorElement == null ? void 0 : anchorElement.contextElement,
      getBoundingClientRect: () => {
        const anchor = anchorElement;
        const anchorRect = getAnchorRect == null ? void 0 : getAnchorRect(anchor);
        if (anchorRect || !anchor) {
          return getDOMRect(anchorRect);
        }
        return anchor.getBoundingClientRect();
      }
    };
  }
  function createTransformOriginMiddleware(opts, arrowEl) {
    return {
      name: "transformOrigin",
      fn(state2) {
        var _a, _b, _c, _d, _e;
        const { elements, middlewareData, placement, rects, y: y2 } = state2;
        const side = placement.split("-")[0];
        const axis = getSideAxis2(side);
        const arrowX = ((_a = middlewareData.arrow) == null ? void 0 : _a.x) || 0;
        const arrowY = ((_b = middlewareData.arrow) == null ? void 0 : _b.y) || 0;
        const arrowWidth = (arrowEl == null ? void 0 : arrowEl.clientWidth) || 0;
        const arrowHeight = (arrowEl == null ? void 0 : arrowEl.clientHeight) || 0;
        const transformX = arrowX + arrowWidth / 2;
        const transformY = arrowY + arrowHeight / 2;
        const shiftY = Math.abs(((_c = middlewareData.shift) == null ? void 0 : _c.y) || 0);
        const halfAnchorHeight = rects.reference.height / 2;
        const arrowOffset = arrowHeight / 2;
        const gutter = (_e = (_d = opts.offset) == null ? void 0 : _d.mainAxis) != null ? _e : opts.gutter;
        const sideOffsetValue = typeof gutter === "number" ? gutter + arrowOffset : gutter != null ? gutter : arrowOffset;
        const isOverlappingAnchor = shiftY > sideOffsetValue;
        const adjacentTransformOrigin = {
          top: `${transformX}px calc(100% + ${sideOffsetValue}px)`,
          bottom: `${transformX}px ${-sideOffsetValue}px`,
          left: `calc(100% + ${sideOffsetValue}px) ${transformY}px`,
          right: `${-sideOffsetValue}px ${transformY}px`
        }[side];
        const overlapTransformOrigin = `${transformX}px ${rects.reference.y + halfAnchorHeight - y2}px`;
        const useOverlap = Boolean(opts.overlap) && axis === "y" && isOverlappingAnchor;
        elements.floating.style.setProperty(
          cssVars.transformOrigin.variable,
          useOverlap ? overlapTransformOrigin : adjacentTransformOrigin
        );
        return {
          data: {
            transformOrigin: useOverlap ? overlapTransformOrigin : adjacentTransformOrigin
          }
        };
      }
    };
  }
  function getPlacementDetails(placement) {
    const [side, align] = placement.split("-");
    return { side, align, hasAlign: align != null };
  }
  function getPlacementSide(placement) {
    return placement.split("-")[0];
  }
  function roundByDpr(win, value) {
    const dpr = win.devicePixelRatio || 1;
    return Math.round(value * dpr) / dpr;
  }
  function resolveBoundaryOption(boundary) {
    if (typeof boundary === "function") return boundary();
    if (boundary === "clipping-ancestors") return "clippingAncestors";
    return boundary;
  }
  function getArrowMiddleware(arrowElement, doc, opts) {
    const element = arrowElement || doc.createElement("div");
    return arrow2({ element, padding: opts.arrowPadding });
  }
  function getOffsetMiddleware(arrowElement, opts) {
    var _a;
    if (isNull((_a = opts.offset) != null ? _a : opts.gutter)) return;
    return offset2(({ placement }) => {
      var _a2, _b, _c, _d;
      const arrowOffset = ((arrowElement == null ? void 0 : arrowElement.clientHeight) || 0) / 2;
      const gutter = (_b = (_a2 = opts.offset) == null ? void 0 : _a2.mainAxis) != null ? _b : opts.gutter;
      const mainAxis = typeof gutter === "number" ? gutter + arrowOffset : gutter != null ? gutter : arrowOffset;
      const { hasAlign } = getPlacementDetails(placement);
      const shift22 = !hasAlign ? opts.shift : void 0;
      const crossAxis = (_d = (_c = opts.offset) == null ? void 0 : _c.crossAxis) != null ? _d : shift22;
      return compact({
        crossAxis,
        mainAxis,
        alignmentAxis: opts.shift
      });
    });
  }
  function getFlipMiddleware(opts) {
    if (!opts.flip) return;
    const boundary = resolveBoundaryOption(opts.boundary);
    return flip2(__spreadProps(__spreadValues({}, boundary ? { boundary } : void 0), {
      padding: opts.overflowPadding,
      fallbackPlacements: opts.flip === true ? void 0 : opts.flip
    }));
  }
  function getShiftMiddleware(opts) {
    if (!opts.slide && !opts.overlap) return;
    const boundary = resolveBoundaryOption(opts.boundary);
    return shift2(__spreadProps(__spreadValues({}, boundary ? { boundary } : void 0), {
      mainAxis: opts.slide,
      crossAxis: opts.overlap,
      padding: opts.overflowPadding,
      limiter: limitShift2()
    }));
  }
  function getSizeMiddleware(opts) {
    return size2({
      padding: opts.overflowPadding,
      apply({ elements, rects, availableHeight, availableWidth }) {
        const floating = elements.floating;
        const referenceWidth = Math.round(rects.reference.width);
        const referenceHeight = Math.round(rects.reference.height);
        availableWidth = Math.floor(availableWidth);
        availableHeight = Math.floor(availableHeight);
        floating.style.setProperty("--reference-width", `${referenceWidth}px`);
        floating.style.setProperty("--reference-height", `${referenceHeight}px`);
        floating.style.setProperty("--available-width", `${availableWidth}px`);
        floating.style.setProperty("--available-height", `${availableHeight}px`);
      }
    });
  }
  function hideWhenDetachedMiddleware(opts) {
    var _a;
    if (!opts.hideWhenDetached) return;
    return hide2({ strategy: "referenceHidden", boundary: (_a = resolveBoundaryOption(opts.boundary)) != null ? _a : "clippingAncestors" });
  }
  function getAutoUpdateOptions(opts) {
    if (!opts) return {};
    if (opts === true) {
      return { ancestorResize: true, ancestorScroll: true, elementResize: true, layoutShift: true };
    }
    return opts;
  }
  function getPlacementImpl(referenceOrVirtual, floating, opts = {}) {
    var _a, _b;
    const anchor = (_b = (_a = opts.getAnchorElement) == null ? void 0 : _a.call(opts)) != null ? _b : referenceOrVirtual;
    const reference = getAnchorElement(anchor, opts.getAnchorRect);
    if (!floating || !reference) return;
    const options = Object.assign({}, defaultOptions, opts);
    const arrowEl = floating.querySelector("[data-part=arrow]");
    const middleware = [
      getOffsetMiddleware(arrowEl, options),
      getFlipMiddleware(options),
      getShiftMiddleware(options),
      getArrowMiddleware(arrowEl, floating.ownerDocument, options),
      shiftArrowMiddleware(arrowEl),
      createTransformOriginMiddleware(
        { gutter: options.gutter, offset: options.offset, overlap: options.overlap },
        arrowEl
      ),
      getSizeMiddleware(options),
      hideWhenDetachedMiddleware(options),
      rectMiddleware
    ];
    const { placement, strategy, onComplete, onPositioned } = options;
    const updatePosition = () => __async(null, null, function* () {
      var _a2;
      if (!reference || !floating) return;
      const pos = yield computePosition2(reference, floating, {
        placement,
        middleware,
        strategy
      });
      onComplete == null ? void 0 : onComplete(pos);
      onPositioned == null ? void 0 : onPositioned({ placed: true });
      const win = getWindow(floating);
      const x2 = roundByDpr(win, pos.x);
      const y2 = roundByDpr(win, pos.y);
      floating.style.setProperty("--x", `${x2}px`);
      floating.style.setProperty("--y", `${y2}px`);
      if (options.hideWhenDetached) {
        const isHidden = (_a2 = pos.middlewareData.hide) == null ? void 0 : _a2.referenceHidden;
        if (isHidden) {
          floating.style.setProperty("visibility", "hidden");
          floating.style.setProperty("pointer-events", "none");
        } else {
          floating.style.removeProperty("visibility");
          floating.style.removeProperty("pointer-events");
        }
      }
      const contentEl = floating.firstElementChild;
      if (contentEl) {
        const styles = getComputedStyle2(contentEl);
        floating.style.setProperty("--z-index", styles.zIndex);
      }
    });
    const update = () => __async(null, null, function* () {
      if (opts.updatePosition) {
        yield opts.updatePosition({ updatePosition, floatingElement: floating });
        onPositioned == null ? void 0 : onPositioned({ placed: true });
      } else {
        yield updatePosition();
      }
    });
    const autoUpdateOptions = getAutoUpdateOptions(options.listeners);
    const cancelAutoUpdate = options.listeners ? autoUpdate(reference, floating, update, autoUpdateOptions) : noop2;
    update();
    return () => {
      cancelAutoUpdate == null ? void 0 : cancelAutoUpdate();
      onPositioned == null ? void 0 : onPositioned({ placed: false });
    };
  }
  function getPlacement(referenceOrFn, floatingOrFn, opts = {}) {
    const _a = opts, { defer } = _a, options = __objRest(_a, ["defer"]);
    const func = defer ? raf : (v2) => v2();
    const cleanups = [];
    cleanups.push(
      func(() => {
        const reference = typeof referenceOrFn === "function" ? referenceOrFn() : referenceOrFn;
        const floating = typeof floatingOrFn === "function" ? floatingOrFn() : floatingOrFn;
        cleanups.push(getPlacementImpl(reference, floating, options));
      })
    );
    return () => {
      cleanups.forEach((fn) => fn == null ? void 0 : fn());
    };
  }
  function getPlacementStyles(options = {}) {
    const { placement, sameWidth, fitViewport, strategy = "absolute" } = options;
    return {
      arrow: {
        position: "absolute",
        width: cssVars.arrowSize.reference,
        height: cssVars.arrowSize.reference,
        [cssVars.arrowSizeHalf.variable]: `calc(${cssVars.arrowSize.reference} / 2)`,
        [cssVars.arrowOffset.variable]: `calc(${cssVars.arrowSizeHalf.reference} * -1)`
      },
      arrowTip: {
        // @ts-expect-error - Fix this
        transform: placement ? ARROW_FLOATING_STYLE[placement.split("-")[0]] : void 0,
        background: cssVars.arrowBg.reference,
        top: "0",
        left: "0",
        width: "100%",
        height: "100%",
        position: "absolute",
        zIndex: "inherit"
      },
      floating: {
        position: strategy,
        isolation: "isolate",
        minWidth: sameWidth ? void 0 : "max-content",
        width: sameWidth ? "var(--reference-width)" : void 0,
        maxWidth: fitViewport ? "var(--available-width)" : void 0,
        maxHeight: fitViewport ? "var(--available-height)" : void 0,
        pointerEvents: !placement ? "none" : void 0,
        top: "0px",
        left: "0px",
        // move off-screen if placement is not defined
        transform: placement ? "translate3d(var(--x), var(--y), 0)" : "translate3d(0, -100vh, 0)",
        zIndex: "var(--z-index)"
      }
    };
  }
  var sides, min2, max2, round2, floor2, createCoords, oppositeSideMap, oppositeAlignmentMap, yAxisSides, lrPlacement, rlPlacement, tbPlacement, btPlacement, computePosition, arrow, flip, hide, originSides, offset, shift, limitShift, size, invalidOverflowDisplayValues, tableElements, topLayerSelectors, transformProperties, willChangeValues, containValues, lastTraversableNodeNames, noOffsets, SCROLLBAR_MAX, absoluteOrFixed, getElementRects, platform, offset2, shift2, flip2, size2, hide2, arrow2, limitShift2, computePosition2, toVar, cssVars, getSideAxis2, rectMiddleware, shiftArrowMiddleware, defaultOptions, ARROW_FLOATING_STYLE;
  var init_chunk_GRHV6R4F = __esm({
    "../priv/static/chunk-GRHV6R4F.mjs"() {
      "use strict";
      init_chunk_GFGFZBBD();
      sides = ["top", "right", "bottom", "left"];
      min2 = Math.min;
      max2 = Math.max;
      round2 = Math.round;
      floor2 = Math.floor;
      createCoords = (v2) => ({
        x: v2,
        y: v2
      });
      oppositeSideMap = {
        left: "right",
        right: "left",
        bottom: "top",
        top: "bottom"
      };
      oppositeAlignmentMap = {
        start: "end",
        end: "start"
      };
      yAxisSides = /* @__PURE__ */ new Set(["top", "bottom"]);
      lrPlacement = ["left", "right"];
      rlPlacement = ["right", "left"];
      tbPlacement = ["top", "bottom"];
      btPlacement = ["bottom", "top"];
      computePosition = (reference, floating, config) => __async(null, null, function* () {
        const {
          placement = "bottom",
          strategy = "absolute",
          middleware = [],
          platform: platform2
        } = config;
        const validMiddleware = middleware.filter(Boolean);
        const rtl = yield platform2.isRTL == null ? void 0 : platform2.isRTL(floating);
        let rects = yield platform2.getElementRects({
          reference,
          floating,
          strategy
        });
        let {
          x: x2,
          y: y2
        } = computeCoordsFromPlacement(rects, placement, rtl);
        let statefulPlacement = placement;
        let middlewareData = {};
        let resetCount = 0;
        for (let i2 = 0; i2 < validMiddleware.length; i2++) {
          var _platform$detectOverf;
          const {
            name,
            fn
          } = validMiddleware[i2];
          const {
            x: nextX,
            y: nextY,
            data,
            reset
          } = yield fn({
            x: x2,
            y: y2,
            initialPlacement: placement,
            placement: statefulPlacement,
            strategy,
            middlewareData,
            rects,
            platform: __spreadProps(__spreadValues({}, platform2), {
              detectOverflow: (_platform$detectOverf = platform2.detectOverflow) != null ? _platform$detectOverf : detectOverflow
            }),
            elements: {
              reference,
              floating
            }
          });
          x2 = nextX != null ? nextX : x2;
          y2 = nextY != null ? nextY : y2;
          middlewareData = __spreadProps(__spreadValues({}, middlewareData), {
            [name]: __spreadValues(__spreadValues({}, middlewareData[name]), data)
          });
          if (reset && resetCount <= 50) {
            resetCount++;
            if (typeof reset === "object") {
              if (reset.placement) {
                statefulPlacement = reset.placement;
              }
              if (reset.rects) {
                rects = reset.rects === true ? yield platform2.getElementRects({
                  reference,
                  floating,
                  strategy
                }) : reset.rects;
              }
              ({
                x: x2,
                y: y2
              } = computeCoordsFromPlacement(rects, statefulPlacement, rtl));
            }
            i2 = -1;
          }
        }
        return {
          x: x2,
          y: y2,
          placement: statefulPlacement,
          strategy,
          middlewareData
        };
      });
      arrow = (options) => ({
        name: "arrow",
        options,
        fn(state2) {
          return __async(this, null, function* () {
            const {
              x: x2,
              y: y2,
              placement,
              rects,
              platform: platform2,
              elements,
              middlewareData
            } = state2;
            const {
              element,
              padding = 0
            } = evaluate(options, state2) || {};
            if (element == null) {
              return {};
            }
            const paddingObject = getPaddingObject(padding);
            const coords = {
              x: x2,
              y: y2
            };
            const axis = getAlignmentAxis(placement);
            const length = getAxisLength(axis);
            const arrowDimensions = yield platform2.getDimensions(element);
            const isYAxis = axis === "y";
            const minProp = isYAxis ? "top" : "left";
            const maxProp = isYAxis ? "bottom" : "right";
            const clientProp = isYAxis ? "clientHeight" : "clientWidth";
            const endDiff = rects.reference[length] + rects.reference[axis] - coords[axis] - rects.floating[length];
            const startDiff = coords[axis] - rects.reference[axis];
            const arrowOffsetParent = yield platform2.getOffsetParent == null ? void 0 : platform2.getOffsetParent(element);
            let clientSize = arrowOffsetParent ? arrowOffsetParent[clientProp] : 0;
            if (!clientSize || !(yield platform2.isElement == null ? void 0 : platform2.isElement(arrowOffsetParent))) {
              clientSize = elements.floating[clientProp] || rects.floating[length];
            }
            const centerToReference = endDiff / 2 - startDiff / 2;
            const largestPossiblePadding = clientSize / 2 - arrowDimensions[length] / 2 - 1;
            const minPadding = min2(paddingObject[minProp], largestPossiblePadding);
            const maxPadding = min2(paddingObject[maxProp], largestPossiblePadding);
            const min$1 = minPadding;
            const max22 = clientSize - arrowDimensions[length] - maxPadding;
            const center = clientSize / 2 - arrowDimensions[length] / 2 + centerToReference;
            const offset3 = clamp2(min$1, center, max22);
            const shouldAddOffset = !middlewareData.arrow && getAlignment(placement) != null && center !== offset3 && rects.reference[length] / 2 - (center < min$1 ? minPadding : maxPadding) - arrowDimensions[length] / 2 < 0;
            const alignmentOffset = shouldAddOffset ? center < min$1 ? center - min$1 : center - max22 : 0;
            return {
              [axis]: coords[axis] + alignmentOffset,
              data: __spreadValues({
                [axis]: offset3,
                centerOffset: center - offset3 - alignmentOffset
              }, shouldAddOffset && {
                alignmentOffset
              }),
              reset: shouldAddOffset
            };
          });
        }
      });
      flip = function(options) {
        if (options === void 0) {
          options = {};
        }
        return {
          name: "flip",
          options,
          fn(state2) {
            return __async(this, null, function* () {
              var _middlewareData$arrow, _middlewareData$flip;
              const {
                placement,
                middlewareData,
                rects,
                initialPlacement,
                platform: platform2,
                elements
              } = state2;
              const _a2 = evaluate(options, state2), {
                mainAxis: checkMainAxis = true,
                crossAxis: checkCrossAxis = true,
                fallbackPlacements: specifiedFallbackPlacements,
                fallbackStrategy = "bestFit",
                fallbackAxisSideDirection = "none",
                flipAlignment = true
              } = _a2, detectOverflowOptions = __objRest(_a2, [
                "mainAxis",
                "crossAxis",
                "fallbackPlacements",
                "fallbackStrategy",
                "fallbackAxisSideDirection",
                "flipAlignment"
              ]);
              if ((_middlewareData$arrow = middlewareData.arrow) != null && _middlewareData$arrow.alignmentOffset) {
                return {};
              }
              const side = getSide(placement);
              const initialSideAxis = getSideAxis(initialPlacement);
              const isBasePlacement = getSide(initialPlacement) === initialPlacement;
              const rtl = yield platform2.isRTL == null ? void 0 : platform2.isRTL(elements.floating);
              const fallbackPlacements = specifiedFallbackPlacements || (isBasePlacement || !flipAlignment ? [getOppositePlacement(initialPlacement)] : getExpandedPlacements(initialPlacement));
              const hasFallbackAxisSideDirection = fallbackAxisSideDirection !== "none";
              if (!specifiedFallbackPlacements && hasFallbackAxisSideDirection) {
                fallbackPlacements.push(...getOppositeAxisPlacements(initialPlacement, flipAlignment, fallbackAxisSideDirection, rtl));
              }
              const placements2 = [initialPlacement, ...fallbackPlacements];
              const overflow = yield platform2.detectOverflow(state2, detectOverflowOptions);
              const overflows = [];
              let overflowsData = ((_middlewareData$flip = middlewareData.flip) == null ? void 0 : _middlewareData$flip.overflows) || [];
              if (checkMainAxis) {
                overflows.push(overflow[side]);
              }
              if (checkCrossAxis) {
                const sides2 = getAlignmentSides(placement, rects, rtl);
                overflows.push(overflow[sides2[0]], overflow[sides2[1]]);
              }
              overflowsData = [...overflowsData, {
                placement,
                overflows
              }];
              if (!overflows.every((side2) => side2 <= 0)) {
                var _middlewareData$flip2, _overflowsData$filter;
                const nextIndex2 = (((_middlewareData$flip2 = middlewareData.flip) == null ? void 0 : _middlewareData$flip2.index) || 0) + 1;
                const nextPlacement = placements2[nextIndex2];
                if (nextPlacement) {
                  const ignoreCrossAxisOverflow = checkCrossAxis === "alignment" ? initialSideAxis !== getSideAxis(nextPlacement) : false;
                  if (!ignoreCrossAxisOverflow || // We leave the current main axis only if every placement on that axis
                  // overflows the main axis.
                  overflowsData.every((d2) => getSideAxis(d2.placement) === initialSideAxis ? d2.overflows[0] > 0 : true)) {
                    return {
                      data: {
                        index: nextIndex2,
                        overflows: overflowsData
                      },
                      reset: {
                        placement: nextPlacement
                      }
                    };
                  }
                }
                let resetPlacement = (_overflowsData$filter = overflowsData.filter((d2) => d2.overflows[0] <= 0).sort((a2, b2) => a2.overflows[1] - b2.overflows[1])[0]) == null ? void 0 : _overflowsData$filter.placement;
                if (!resetPlacement) {
                  switch (fallbackStrategy) {
                    case "bestFit": {
                      var _overflowsData$filter2;
                      const placement2 = (_overflowsData$filter2 = overflowsData.filter((d2) => {
                        if (hasFallbackAxisSideDirection) {
                          const currentSideAxis = getSideAxis(d2.placement);
                          return currentSideAxis === initialSideAxis || // Create a bias to the `y` side axis due to horizontal
                          // reading directions favoring greater width.
                          currentSideAxis === "y";
                        }
                        return true;
                      }).map((d2) => [d2.placement, d2.overflows.filter((overflow2) => overflow2 > 0).reduce((acc, overflow2) => acc + overflow2, 0)]).sort((a2, b2) => a2[1] - b2[1])[0]) == null ? void 0 : _overflowsData$filter2[0];
                      if (placement2) {
                        resetPlacement = placement2;
                      }
                      break;
                    }
                    case "initialPlacement":
                      resetPlacement = initialPlacement;
                      break;
                  }
                }
                if (placement !== resetPlacement) {
                  return {
                    reset: {
                      placement: resetPlacement
                    }
                  };
                }
              }
              return {};
            });
          }
        };
      };
      hide = function(options) {
        if (options === void 0) {
          options = {};
        }
        return {
          name: "hide",
          options,
          fn(state2) {
            return __async(this, null, function* () {
              const {
                rects,
                platform: platform2
              } = state2;
              const _a2 = evaluate(options, state2), {
                strategy = "referenceHidden"
              } = _a2, detectOverflowOptions = __objRest(_a2, [
                "strategy"
              ]);
              switch (strategy) {
                case "referenceHidden": {
                  const overflow = yield platform2.detectOverflow(state2, __spreadProps(__spreadValues({}, detectOverflowOptions), {
                    elementContext: "reference"
                  }));
                  const offsets = getSideOffsets(overflow, rects.reference);
                  return {
                    data: {
                      referenceHiddenOffsets: offsets,
                      referenceHidden: isAnySideFullyClipped(offsets)
                    }
                  };
                }
                case "escaped": {
                  const overflow = yield platform2.detectOverflow(state2, __spreadProps(__spreadValues({}, detectOverflowOptions), {
                    altBoundary: true
                  }));
                  const offsets = getSideOffsets(overflow, rects.floating);
                  return {
                    data: {
                      escapedOffsets: offsets,
                      escaped: isAnySideFullyClipped(offsets)
                    }
                  };
                }
                default: {
                  return {};
                }
              }
            });
          }
        };
      };
      originSides = /* @__PURE__ */ new Set(["left", "top"]);
      offset = function(options) {
        if (options === void 0) {
          options = 0;
        }
        return {
          name: "offset",
          options,
          fn(state2) {
            return __async(this, null, function* () {
              var _middlewareData$offse, _middlewareData$arrow;
              const {
                x: x2,
                y: y2,
                placement,
                middlewareData
              } = state2;
              const diffCoords = yield convertValueToCoords(state2, options);
              if (placement === ((_middlewareData$offse = middlewareData.offset) == null ? void 0 : _middlewareData$offse.placement) && (_middlewareData$arrow = middlewareData.arrow) != null && _middlewareData$arrow.alignmentOffset) {
                return {};
              }
              return {
                x: x2 + diffCoords.x,
                y: y2 + diffCoords.y,
                data: __spreadProps(__spreadValues({}, diffCoords), {
                  placement
                })
              };
            });
          }
        };
      };
      shift = function(options) {
        if (options === void 0) {
          options = {};
        }
        return {
          name: "shift",
          options,
          fn(state2) {
            return __async(this, null, function* () {
              const {
                x: x2,
                y: y2,
                placement,
                platform: platform2
              } = state2;
              const _a2 = evaluate(options, state2), {
                mainAxis: checkMainAxis = true,
                crossAxis: checkCrossAxis = false,
                limiter = {
                  fn: (_ref) => {
                    let {
                      x: x22,
                      y: y22
                    } = _ref;
                    return {
                      x: x22,
                      y: y22
                    };
                  }
                }
              } = _a2, detectOverflowOptions = __objRest(_a2, [
                "mainAxis",
                "crossAxis",
                "limiter"
              ]);
              const coords = {
                x: x2,
                y: y2
              };
              const overflow = yield platform2.detectOverflow(state2, detectOverflowOptions);
              const crossAxis = getSideAxis(getSide(placement));
              const mainAxis = getOppositeAxis(crossAxis);
              let mainAxisCoord = coords[mainAxis];
              let crossAxisCoord = coords[crossAxis];
              if (checkMainAxis) {
                const minSide = mainAxis === "y" ? "top" : "left";
                const maxSide = mainAxis === "y" ? "bottom" : "right";
                const min23 = mainAxisCoord + overflow[minSide];
                const max22 = mainAxisCoord - overflow[maxSide];
                mainAxisCoord = clamp2(min23, mainAxisCoord, max22);
              }
              if (checkCrossAxis) {
                const minSide = crossAxis === "y" ? "top" : "left";
                const maxSide = crossAxis === "y" ? "bottom" : "right";
                const min23 = crossAxisCoord + overflow[minSide];
                const max22 = crossAxisCoord - overflow[maxSide];
                crossAxisCoord = clamp2(min23, crossAxisCoord, max22);
              }
              const limitedCoords = limiter.fn(__spreadProps(__spreadValues({}, state2), {
                [mainAxis]: mainAxisCoord,
                [crossAxis]: crossAxisCoord
              }));
              return __spreadProps(__spreadValues({}, limitedCoords), {
                data: {
                  x: limitedCoords.x - x2,
                  y: limitedCoords.y - y2,
                  enabled: {
                    [mainAxis]: checkMainAxis,
                    [crossAxis]: checkCrossAxis
                  }
                }
              });
            });
          }
        };
      };
      limitShift = function(options) {
        if (options === void 0) {
          options = {};
        }
        return {
          options,
          fn(state2) {
            const {
              x: x2,
              y: y2,
              placement,
              rects,
              middlewareData
            } = state2;
            const {
              offset: offset3 = 0,
              mainAxis: checkMainAxis = true,
              crossAxis: checkCrossAxis = true
            } = evaluate(options, state2);
            const coords = {
              x: x2,
              y: y2
            };
            const crossAxis = getSideAxis(placement);
            const mainAxis = getOppositeAxis(crossAxis);
            let mainAxisCoord = coords[mainAxis];
            let crossAxisCoord = coords[crossAxis];
            const rawOffset = evaluate(offset3, state2);
            const computedOffset = typeof rawOffset === "number" ? {
              mainAxis: rawOffset,
              crossAxis: 0
            } : __spreadValues({
              mainAxis: 0,
              crossAxis: 0
            }, rawOffset);
            if (checkMainAxis) {
              const len = mainAxis === "y" ? "height" : "width";
              const limitMin = rects.reference[mainAxis] - rects.floating[len] + computedOffset.mainAxis;
              const limitMax = rects.reference[mainAxis] + rects.reference[len] - computedOffset.mainAxis;
              if (mainAxisCoord < limitMin) {
                mainAxisCoord = limitMin;
              } else if (mainAxisCoord > limitMax) {
                mainAxisCoord = limitMax;
              }
            }
            if (checkCrossAxis) {
              var _middlewareData$offse, _middlewareData$offse2;
              const len = mainAxis === "y" ? "width" : "height";
              const isOriginSide = originSides.has(getSide(placement));
              const limitMin = rects.reference[crossAxis] - rects.floating[len] + (isOriginSide ? ((_middlewareData$offse = middlewareData.offset) == null ? void 0 : _middlewareData$offse[crossAxis]) || 0 : 0) + (isOriginSide ? 0 : computedOffset.crossAxis);
              const limitMax = rects.reference[crossAxis] + rects.reference[len] + (isOriginSide ? 0 : ((_middlewareData$offse2 = middlewareData.offset) == null ? void 0 : _middlewareData$offse2[crossAxis]) || 0) - (isOriginSide ? computedOffset.crossAxis : 0);
              if (crossAxisCoord < limitMin) {
                crossAxisCoord = limitMin;
              } else if (crossAxisCoord > limitMax) {
                crossAxisCoord = limitMax;
              }
            }
            return {
              [mainAxis]: mainAxisCoord,
              [crossAxis]: crossAxisCoord
            };
          }
        };
      };
      size = function(options) {
        if (options === void 0) {
          options = {};
        }
        return {
          name: "size",
          options,
          fn(state2) {
            return __async(this, null, function* () {
              var _state$middlewareData, _state$middlewareData2;
              const {
                placement,
                rects,
                platform: platform2,
                elements
              } = state2;
              const _a2 = evaluate(options, state2), {
                apply = () => {
                }
              } = _a2, detectOverflowOptions = __objRest(_a2, [
                "apply"
              ]);
              const overflow = yield platform2.detectOverflow(state2, detectOverflowOptions);
              const side = getSide(placement);
              const alignment = getAlignment(placement);
              const isYAxis = getSideAxis(placement) === "y";
              const {
                width,
                height
              } = rects.floating;
              let heightSide;
              let widthSide;
              if (side === "top" || side === "bottom") {
                heightSide = side;
                widthSide = alignment === ((yield platform2.isRTL == null ? void 0 : platform2.isRTL(elements.floating)) ? "start" : "end") ? "left" : "right";
              } else {
                widthSide = side;
                heightSide = alignment === "end" ? "top" : "bottom";
              }
              const maximumClippingHeight = height - overflow.top - overflow.bottom;
              const maximumClippingWidth = width - overflow.left - overflow.right;
              const overflowAvailableHeight = min2(height - overflow[heightSide], maximumClippingHeight);
              const overflowAvailableWidth = min2(width - overflow[widthSide], maximumClippingWidth);
              const noShift = !state2.middlewareData.shift;
              let availableHeight = overflowAvailableHeight;
              let availableWidth = overflowAvailableWidth;
              if ((_state$middlewareData = state2.middlewareData.shift) != null && _state$middlewareData.enabled.x) {
                availableWidth = maximumClippingWidth;
              }
              if ((_state$middlewareData2 = state2.middlewareData.shift) != null && _state$middlewareData2.enabled.y) {
                availableHeight = maximumClippingHeight;
              }
              if (noShift && !alignment) {
                const xMin = max2(overflow.left, 0);
                const xMax = max2(overflow.right, 0);
                const yMin = max2(overflow.top, 0);
                const yMax = max2(overflow.bottom, 0);
                if (isYAxis) {
                  availableWidth = width - 2 * (xMin !== 0 || xMax !== 0 ? xMin + xMax : max2(overflow.left, overflow.right));
                } else {
                  availableHeight = height - 2 * (yMin !== 0 || yMax !== 0 ? yMin + yMax : max2(overflow.top, overflow.bottom));
                }
              }
              yield apply(__spreadProps(__spreadValues({}, state2), {
                availableWidth,
                availableHeight
              }));
              const nextDimensions = yield platform2.getDimensions(elements.floating);
              if (width !== nextDimensions.width || height !== nextDimensions.height) {
                return {
                  reset: {
                    rects: true
                  }
                };
              }
              return {};
            });
          }
        };
      };
      invalidOverflowDisplayValues = /* @__PURE__ */ new Set(["inline", "contents"]);
      tableElements = /* @__PURE__ */ new Set(["table", "td", "th"]);
      topLayerSelectors = [":popover-open", ":modal"];
      transformProperties = ["transform", "translate", "scale", "rotate", "perspective"];
      willChangeValues = ["transform", "translate", "scale", "rotate", "perspective", "filter"];
      containValues = ["paint", "layout", "strict", "content"];
      lastTraversableNodeNames = /* @__PURE__ */ new Set(["html", "body", "#document"]);
      noOffsets = /* @__PURE__ */ createCoords(0);
      SCROLLBAR_MAX = 25;
      absoluteOrFixed = /* @__PURE__ */ new Set(["absolute", "fixed"]);
      getElementRects = function(data) {
        return __async(this, null, function* () {
          const getOffsetParentFn = this.getOffsetParent || getOffsetParent;
          const getDimensionsFn = this.getDimensions;
          const floatingDimensions = yield getDimensionsFn(data.floating);
          return {
            reference: getRectRelativeToOffsetParent(data.reference, yield getOffsetParentFn(data.floating), data.strategy),
            floating: {
              x: 0,
              y: 0,
              width: floatingDimensions.width,
              height: floatingDimensions.height
            }
          };
        });
      };
      platform = {
        convertOffsetParentRelativeRectToViewportRelativeRect,
        getDocumentElement: getDocumentElement2,
        getClippingRect,
        getOffsetParent,
        getElementRects,
        getClientRects,
        getDimensions,
        getScale,
        isElement: isElement2,
        isRTL
      };
      offset2 = offset;
      shift2 = shift;
      flip2 = flip;
      size2 = size;
      hide2 = hide;
      arrow2 = arrow;
      limitShift2 = limitShift;
      computePosition2 = (reference, floating, options) => {
        const cache = /* @__PURE__ */ new Map();
        const mergedOptions = __spreadValues({
          platform
        }, options);
        const platformWithCache = __spreadProps(__spreadValues({}, mergedOptions.platform), {
          _c: cache
        });
        return computePosition(reference, floating, __spreadProps(__spreadValues({}, mergedOptions), {
          platform: platformWithCache
        }));
      };
      toVar = (value) => ({ variable: value, reference: `var(${value})` });
      cssVars = {
        arrowSize: toVar("--arrow-size"),
        arrowSizeHalf: toVar("--arrow-size-half"),
        arrowBg: toVar("--arrow-background"),
        transformOrigin: toVar("--transform-origin"),
        arrowOffset: toVar("--arrow-offset")
      };
      getSideAxis2 = (side) => side === "top" || side === "bottom" ? "y" : "x";
      rectMiddleware = {
        name: "rects",
        fn({ rects }) {
          return {
            data: rects
          };
        }
      };
      shiftArrowMiddleware = (arrowEl) => {
        if (!arrowEl) return;
        return {
          name: "shiftArrow",
          fn({ placement, middlewareData }) {
            if (!middlewareData.arrow) return {};
            const { x: x2, y: y2 } = middlewareData.arrow;
            const dir = placement.split("-")[0];
            Object.assign(arrowEl.style, {
              left: x2 != null ? `${x2}px` : "",
              top: y2 != null ? `${y2}px` : "",
              [dir]: `calc(100% + ${cssVars.arrowOffset.reference})`
            });
            return {};
          }
        };
      };
      defaultOptions = {
        strategy: "absolute",
        placement: "bottom",
        listeners: true,
        gutter: 8,
        flip: true,
        slide: true,
        overlap: false,
        sameWidth: false,
        fitViewport: false,
        overflowPadding: 8,
        arrowPadding: 4
      };
      ARROW_FLOATING_STYLE = {
        bottom: "rotate(45deg)",
        left: "rotate(135deg)",
        top: "rotate(225deg)",
        right: "rotate(315deg)"
      };
    }
  });

  // ../priv/static/chunk-BPSX7Z7Y.mjs
  function getWindowFrames(win) {
    const frames = {
      each(cb) {
        var _a;
        for (let i2 = 0; i2 < ((_a = win.frames) == null ? void 0 : _a.length); i2 += 1) {
          const frame = win.frames[i2];
          if (frame) cb(frame);
        }
      },
      addEventListener(event, listener, options) {
        frames.each((frame) => {
          try {
            frame.document.addEventListener(event, listener, options);
          } catch (e2) {
          }
        });
        return () => {
          try {
            frames.removeEventListener(event, listener, options);
          } catch (e2) {
          }
        };
      },
      removeEventListener(event, listener, options) {
        frames.each((frame) => {
          try {
            frame.document.removeEventListener(event, listener, options);
          } catch (e2) {
          }
        });
      }
    };
    return frames;
  }
  function getParentWindow(win) {
    const parent = win.frameElement != null ? win.parent : null;
    return {
      addEventListener: (event, listener, options) => {
        try {
          parent == null ? void 0 : parent.addEventListener(event, listener, options);
        } catch (e2) {
        }
        return () => {
          try {
            parent == null ? void 0 : parent.removeEventListener(event, listener, options);
          } catch (e2) {
          }
        };
      },
      removeEventListener: (event, listener, options) => {
        try {
          parent == null ? void 0 : parent.removeEventListener(event, listener, options);
        } catch (e2) {
        }
      }
    };
  }
  function isComposedPathFocusable(composedPath) {
    for (const node of composedPath) {
      if (isHTMLElement(node) && isFocusable(node)) return true;
    }
    return false;
  }
  function isEventPointWithin(node, event) {
    if (!isPointerEvent(event) || !node) return false;
    const rect = node.getBoundingClientRect();
    if (rect.width === 0 || rect.height === 0) return false;
    return rect.top <= event.clientY && event.clientY <= rect.top + rect.height && rect.left <= event.clientX && event.clientX <= rect.left + rect.width;
  }
  function isPointInRect(rect, point) {
    return rect.y <= point.y && point.y <= rect.y + rect.height && rect.x <= point.x && point.x <= rect.x + rect.width;
  }
  function isEventWithinScrollbar(event, ancestor) {
    if (!ancestor || !isPointerEvent(event)) return false;
    const isScrollableY = ancestor.scrollHeight > ancestor.clientHeight;
    const onScrollbarY = isScrollableY && event.clientX > ancestor.offsetLeft + ancestor.clientWidth;
    const isScrollableX = ancestor.scrollWidth > ancestor.clientWidth;
    const onScrollbarX = isScrollableX && event.clientY > ancestor.offsetTop + ancestor.clientHeight;
    const rect = {
      x: ancestor.offsetLeft,
      y: ancestor.offsetTop,
      width: ancestor.clientWidth + (isScrollableY ? 16 : 0),
      height: ancestor.clientHeight + (isScrollableX ? 16 : 0)
    };
    const point = {
      x: event.clientX,
      y: event.clientY
    };
    if (!isPointInRect(rect, point)) return false;
    return onScrollbarY || onScrollbarX;
  }
  function trackInteractOutsideImpl(node, options) {
    const {
      exclude,
      onFocusOutside,
      onPointerDownOutside,
      onInteractOutside,
      defer,
      followControlledElements = true
    } = options;
    if (!node) return;
    const doc = getDocument(node);
    const win = getWindow(node);
    const frames = getWindowFrames(win);
    const parentWin = getParentWindow(win);
    function isEventOutside(event, target) {
      if (!isHTMLElement(target)) return false;
      if (!target.isConnected) return false;
      if (contains(node, target)) return false;
      if (isEventPointWithin(node, event)) return false;
      if (followControlledElements && isControlledElement(node, target)) return false;
      const triggerEl = doc.querySelector(`[aria-controls="${node.id}"]`);
      if (triggerEl) {
        const triggerAncestor = getNearestOverflowAncestor(triggerEl);
        if (isEventWithinScrollbar(event, triggerAncestor)) return false;
      }
      const nodeAncestor = getNearestOverflowAncestor(node);
      if (isEventWithinScrollbar(event, nodeAncestor)) return false;
      return !(exclude == null ? void 0 : exclude(target));
    }
    const pointerdownCleanups = /* @__PURE__ */ new Set();
    const isInShadowRoot = isShadowRoot(node == null ? void 0 : node.getRootNode());
    function onPointerDown(event) {
      function handler(clickEvent) {
        var _a, _b;
        const func = defer && !isTouchDevice() ? raf : (v2) => v2();
        const evt = clickEvent != null ? clickEvent : event;
        const composedPath = (_b = (_a = evt == null ? void 0 : evt.composedPath) == null ? void 0 : _a.call(evt)) != null ? _b : [evt == null ? void 0 : evt.target];
        func(() => {
          const target = isInShadowRoot ? composedPath[0] : getEventTarget(event);
          if (!node || !isEventOutside(event, target)) return;
          if (onPointerDownOutside || onInteractOutside) {
            const handler2 = callAll(onPointerDownOutside, onInteractOutside);
            node.addEventListener(POINTER_OUTSIDE_EVENT, handler2, { once: true });
          }
          fireCustomEvent(node, POINTER_OUTSIDE_EVENT, {
            bubbles: false,
            cancelable: true,
            detail: {
              originalEvent: evt,
              contextmenu: isContextMenuEvent(evt),
              focusable: isComposedPathFocusable(composedPath),
              target
            }
          });
        });
      }
      if (event.pointerType === "touch") {
        pointerdownCleanups.forEach((fn) => fn());
        pointerdownCleanups.add(addDomEvent(doc, "click", handler, { once: true }));
        pointerdownCleanups.add(parentWin.addEventListener("click", handler, { once: true }));
        pointerdownCleanups.add(frames.addEventListener("click", handler, { once: true }));
      } else {
        handler();
      }
    }
    const cleanups = /* @__PURE__ */ new Set();
    const timer = setTimeout(() => {
      cleanups.add(addDomEvent(doc, "pointerdown", onPointerDown, true));
      cleanups.add(parentWin.addEventListener("pointerdown", onPointerDown, true));
      cleanups.add(frames.addEventListener("pointerdown", onPointerDown, true));
    }, 0);
    function onFocusin(event) {
      const func = defer ? raf : (v2) => v2();
      func(() => {
        var _a, _b;
        const composedPath = (_b = (_a = event == null ? void 0 : event.composedPath) == null ? void 0 : _a.call(event)) != null ? _b : [event == null ? void 0 : event.target];
        const target = isInShadowRoot ? composedPath[0] : getEventTarget(event);
        if (!node || !isEventOutside(event, target)) return;
        if (onFocusOutside || onInteractOutside) {
          const handler = callAll(onFocusOutside, onInteractOutside);
          node.addEventListener(FOCUS_OUTSIDE_EVENT, handler, { once: true });
        }
        fireCustomEvent(node, FOCUS_OUTSIDE_EVENT, {
          bubbles: false,
          cancelable: true,
          detail: {
            originalEvent: event,
            contextmenu: false,
            focusable: isFocusable(target),
            target
          }
        });
      });
    }
    if (!isTouchDevice()) {
      cleanups.add(addDomEvent(doc, "focusin", onFocusin, true));
      cleanups.add(parentWin.addEventListener("focusin", onFocusin, true));
      cleanups.add(frames.addEventListener("focusin", onFocusin, true));
    }
    return () => {
      clearTimeout(timer);
      pointerdownCleanups.forEach((fn) => fn());
      cleanups.forEach((fn) => fn());
    };
  }
  function trackInteractOutside(nodeOrFn, options) {
    const { defer } = options;
    const func = defer ? raf : (v2) => v2();
    const cleanups = [];
    cleanups.push(
      func(() => {
        const node = typeof nodeOrFn === "function" ? nodeOrFn() : nodeOrFn;
        cleanups.push(trackInteractOutsideImpl(node, options));
      })
    );
    return () => {
      cleanups.forEach((fn) => fn == null ? void 0 : fn());
    };
  }
  function fireCustomEvent(el, type, init) {
    const win = el.ownerDocument.defaultView || window;
    const event = new win.CustomEvent(type, init);
    return el.dispatchEvent(event);
  }
  function trackEscapeKeydown(node, fn) {
    const handleKeyDown = (event) => {
      if (event.key !== "Escape") return;
      if (event.isComposing) return;
      fn == null ? void 0 : fn(event);
    };
    return addDomEvent(getDocument(node), "keydown", handleKeyDown, { capture: true });
  }
  function fireCustomEvent2(el, type, detail) {
    const win = el.ownerDocument.defaultView || window;
    const event = new win.CustomEvent(type, { cancelable: true, bubbles: true, detail });
    return el.dispatchEvent(event);
  }
  function addListenerOnce(el, type, callback) {
    el.addEventListener(type, callback, { once: true });
  }
  function assignPointerEventToLayers() {
    layerStack.layers.forEach(({ node }) => {
      node.style.pointerEvents = layerStack.isBelowPointerBlockingLayer(node) ? "none" : "auto";
    });
  }
  function clearPointerEvent(node) {
    node.style.pointerEvents = "";
  }
  function disablePointerEventsOutside(node, persistentElements) {
    const doc = getDocument(node);
    const cleanups = [];
    if (layerStack.hasPointerBlockingLayer() && !doc.body.hasAttribute("data-inert")) {
      originalBodyPointerEvents = document.body.style.pointerEvents;
      queueMicrotask(() => {
        doc.body.style.pointerEvents = "none";
        doc.body.setAttribute("data-inert", "");
      });
    }
    persistentElements == null ? void 0 : persistentElements.forEach((el) => {
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
        doc.body.style.pointerEvents = originalBodyPointerEvents;
        doc.body.removeAttribute("data-inert");
        if (doc.body.style.length === 0) doc.body.removeAttribute("style");
      });
      cleanups.forEach((fn) => fn());
    };
  }
  function trackDismissableElementImpl(node, options) {
    const { warnOnMissingNode = true } = options;
    if (warnOnMissingNode && !node) {
      warn("[@zag-js/dismissable] node is `null` or `undefined`");
      return;
    }
    if (!node) {
      return;
    }
    const { onDismiss, onRequestDismiss, pointerBlocking, exclude: excludeContainers, debug, type = "dialog" } = options;
    const layer = { dismiss: onDismiss, node, type, pointerBlocking, requestDismiss: onRequestDismiss };
    layerStack.add(layer);
    assignPointerEventToLayers();
    function onPointerDownOutside(event) {
      var _a, _b;
      const target = getEventTarget(event.detail.originalEvent);
      if (layerStack.isBelowPointerBlockingLayer(node) || layerStack.isInBranch(target)) return;
      (_a = options.onPointerDownOutside) == null ? void 0 : _a.call(options, event);
      (_b = options.onInteractOutside) == null ? void 0 : _b.call(options, event);
      if (event.defaultPrevented) return;
      if (debug) {
        console.log("onPointerDownOutside:", event.detail.originalEvent);
      }
      onDismiss == null ? void 0 : onDismiss();
    }
    function onFocusOutside(event) {
      var _a, _b;
      const target = getEventTarget(event.detail.originalEvent);
      if (layerStack.isInBranch(target)) return;
      (_a = options.onFocusOutside) == null ? void 0 : _a.call(options, event);
      (_b = options.onInteractOutside) == null ? void 0 : _b.call(options, event);
      if (event.defaultPrevented) return;
      if (debug) {
        console.log("onFocusOutside:", event.detail.originalEvent);
      }
      onDismiss == null ? void 0 : onDismiss();
    }
    function onEscapeKeyDown(event) {
      var _a;
      if (!layerStack.isTopMost(node)) return;
      (_a = options.onEscapeKeyDown) == null ? void 0 : _a.call(options, event);
      if (!event.defaultPrevented && onDismiss) {
        event.preventDefault();
        onDismiss();
      }
    }
    function exclude(target) {
      var _a;
      if (!node) return false;
      const containers = typeof excludeContainers === "function" ? excludeContainers() : excludeContainers;
      const _containers = Array.isArray(containers) ? containers : [containers];
      const persistentElements = (_a = options.persistentElements) == null ? void 0 : _a.map((fn) => fn()).filter(isHTMLElement);
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
      cleanups.forEach((fn) => fn == null ? void 0 : fn());
    };
  }
  function trackDismissableElement(nodeOrFn, options) {
    const { defer } = options;
    const func = defer ? raf : (v2) => v2();
    const cleanups = [];
    cleanups.push(
      func(() => {
        const node = isFunction(nodeOrFn) ? nodeOrFn() : nodeOrFn;
        cleanups.push(trackDismissableElementImpl(node, options));
      })
    );
    return () => {
      cleanups.forEach((fn) => fn == null ? void 0 : fn());
    };
  }
  function trackDismissableBranch(nodeOrFn, options = {}) {
    const { defer } = options;
    const func = defer ? raf : (v2) => v2();
    const cleanups = [];
    cleanups.push(
      func(() => {
        const node = isFunction(nodeOrFn) ? nodeOrFn() : nodeOrFn;
        if (!node) {
          warn("[@zag-js/dismissable] branch node is `null` or `undefined`");
          return;
        }
        layerStack.addBranch(node);
        cleanups.push(() => {
          layerStack.removeBranch(node);
        });
      })
    );
    return () => {
      cleanups.forEach((fn) => fn == null ? void 0 : fn());
    };
  }
  var POINTER_OUTSIDE_EVENT, FOCUS_OUTSIDE_EVENT, isPointerEvent, LAYER_REQUEST_DISMISS_EVENT, layerStack, originalBodyPointerEvents;
  var init_chunk_BPSX7Z7Y = __esm({
    "../priv/static/chunk-BPSX7Z7Y.mjs"() {
      "use strict";
      init_chunk_GFGFZBBD();
      POINTER_OUTSIDE_EVENT = "pointerdown.outside";
      FOCUS_OUTSIDE_EVENT = "focus.outside";
      isPointerEvent = (event) => "clientY" in event;
      LAYER_REQUEST_DISMISS_EVENT = "layer:request-dismiss";
      layerStack = {
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
          var _a;
          const index = this.indexOf(node);
          const highestBlockingIndex = this.topMostPointerBlockingLayer() ? this.indexOf((_a = this.topMostPointerBlockingLayer()) == null ? void 0 : _a.node) : -1;
          return index < highestBlockingIndex;
        },
        isTopMost(node) {
          const layer = this.layers[this.count() - 1];
          return (layer == null ? void 0 : layer.node) === node;
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
          this.layers.push(layer);
          this.syncLayers();
        },
        addBranch(node) {
          this.branches.push(node);
        },
        remove(node) {
          const index = this.indexOf(node);
          if (index < 0) return;
          this.recentlyRemoved.add(node);
          nextTick(() => this.recentlyRemoved.delete(node));
          if (index < this.count() - 1) {
            const _layers = this.getNestedLayers(node);
            _layers.forEach((layer) => layerStack.dismiss(layer.node, node));
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
            layer.node.style.setProperty("--layer-index", `${index}`);
            layer.node.removeAttribute("data-nested");
            layer.node.removeAttribute("data-has-nested");
            const parentOfSameType = this.getParentLayerOfType(layer.node, layer.type);
            if (parentOfSameType) {
              layer.node.setAttribute("data-nested", layer.type);
            }
            const nestedCount = this.countNestedLayersOfType(layer.node, layer.type);
            if (nestedCount > 0) {
              layer.node.setAttribute("data-has-nested", layer.type);
            }
            layer.node.style.setProperty("--nested-layer-count", `${nestedCount}`);
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
            var _a;
            (_a = layer.requestDismiss) == null ? void 0 : _a.call(layer, event);
            if (!event.defaultPrevented) {
              layer == null ? void 0 : layer.dismiss();
            }
          });
          fireCustomEvent2(node, LAYER_REQUEST_DISMISS_EVENT, {
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
    }
  });

  // ../priv/static/combobox.mjs
  var combobox_exports = {};
  __export(combobox_exports, {
    Combobox: () => ComboboxHook
  });
  function connect5(service, normalize) {
    const { context, prop, state: state2, send, scope, computed, event } = service;
    const translations = prop("translations");
    const collection22 = prop("collection");
    const disabled = !!prop("disabled");
    const interactive = computed("isInteractive");
    const invalid = !!prop("invalid");
    const required = !!prop("required");
    const readOnly = !!prop("readOnly");
    const open = state2.hasTag("open");
    const focused = state2.hasTag("focused");
    const composite = prop("composite");
    const highlightedValue = context.get("highlightedValue");
    const popperStyles = getPlacementStyles(__spreadProps(__spreadValues({}, prop("positioning")), {
      placement: context.get("currentPlacement")
    }));
    function getItemState(props22) {
      const disabled2 = collection22.getItemDisabled(props22.item);
      const value = collection22.getItemValue(props22.item);
      ensure(value, () => `[zag-js] No value found for item ${JSON.stringify(props22.item)}`);
      return {
        value,
        disabled: Boolean(disabled2 || disabled2),
        highlighted: highlightedValue === value,
        selected: context.get("value").includes(value)
      };
    }
    return {
      focused,
      open,
      inputValue: context.get("inputValue"),
      highlightedValue,
      highlightedItem: context.get("highlightedItem"),
      value: context.get("value"),
      valueAsString: computed("valueAsString"),
      hasSelectedItems: computed("hasSelectedItems"),
      selectedItems: context.get("selectedItems"),
      collection: prop("collection"),
      multiple: !!prop("multiple"),
      disabled: !!disabled,
      syncSelectedItems() {
        send({ type: "SELECTED_ITEMS.SYNC" });
      },
      reposition(options = {}) {
        send({ type: "POSITIONING.SET", options });
      },
      setHighlightValue(value) {
        send({ type: "HIGHLIGHTED_VALUE.SET", value });
      },
      clearHighlightValue() {
        send({ type: "HIGHLIGHTED_VALUE.CLEAR" });
      },
      selectValue(value) {
        send({ type: "ITEM.SELECT", value });
      },
      setValue(value) {
        send({ type: "VALUE.SET", value });
      },
      setInputValue(value, reason = "script") {
        send({ type: "INPUT_VALUE.SET", value, src: reason });
      },
      clearValue(value) {
        if (value != null) {
          send({ type: "ITEM.CLEAR", value });
        } else {
          send({ type: "VALUE.CLEAR" });
        }
      },
      focus() {
        var _a;
        (_a = getInputEl2(scope)) == null ? void 0 : _a.focus();
      },
      setOpen(nextOpen, reason = "script") {
        const open2 = state2.hasTag("open");
        if (open2 === nextOpen) return;
        send({ type: nextOpen ? "OPEN" : "CLOSE", src: reason });
      },
      getRootProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts5.root.attrs), {
          dir: prop("dir"),
          id: getRootId5(scope),
          "data-invalid": dataAttr(invalid),
          "data-readonly": dataAttr(readOnly)
        }));
      },
      getLabelProps() {
        return normalize.label(__spreadProps(__spreadValues({}, parts5.label.attrs), {
          dir: prop("dir"),
          htmlFor: getInputId2(scope),
          id: getLabelId3(scope),
          "data-readonly": dataAttr(readOnly),
          "data-disabled": dataAttr(disabled),
          "data-invalid": dataAttr(invalid),
          "data-required": dataAttr(required),
          "data-focus": dataAttr(focused),
          onClick(event2) {
            var _a;
            if (composite) return;
            event2.preventDefault();
            (_a = getTriggerEl(scope)) == null ? void 0 : _a.focus({ preventScroll: true });
          }
        }));
      },
      getControlProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts5.control.attrs), {
          dir: prop("dir"),
          id: getControlId2(scope),
          "data-state": open ? "open" : "closed",
          "data-focus": dataAttr(focused),
          "data-disabled": dataAttr(disabled),
          "data-invalid": dataAttr(invalid)
        }));
      },
      getPositionerProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts5.positioner.attrs), {
          dir: prop("dir"),
          id: getPositionerId(scope),
          style: popperStyles.floating
        }));
      },
      getInputProps() {
        return normalize.input(__spreadProps(__spreadValues({}, parts5.input.attrs), {
          dir: prop("dir"),
          "aria-invalid": ariaAttr(invalid),
          "data-invalid": dataAttr(invalid),
          "data-autofocus": dataAttr(prop("autoFocus")),
          name: prop("name"),
          form: prop("form"),
          disabled,
          required: prop("required"),
          autoComplete: "off",
          autoCorrect: "off",
          autoCapitalize: "none",
          spellCheck: "false",
          readOnly,
          placeholder: prop("placeholder"),
          id: getInputId2(scope),
          type: "text",
          role: "combobox",
          defaultValue: context.get("inputValue"),
          "aria-autocomplete": computed("autoComplete") ? "both" : "list",
          "aria-controls": getContentId2(scope),
          "aria-expanded": open,
          "data-state": open ? "open" : "closed",
          "aria-activedescendant": highlightedValue ? getItemId2(scope, highlightedValue) : void 0,
          onClick(event2) {
            if (event2.defaultPrevented) return;
            if (!prop("openOnClick")) return;
            if (!interactive) return;
            send({ type: "INPUT.CLICK", src: "input-click" });
          },
          onFocus() {
            if (disabled) return;
            send({ type: "INPUT.FOCUS" });
          },
          onBlur() {
            if (disabled) return;
            send({ type: "INPUT.BLUR" });
          },
          onChange(event2) {
            send({ type: "INPUT.CHANGE", value: event2.currentTarget.value, src: "input-change" });
          },
          onKeyDown(event2) {
            if (event2.defaultPrevented) return;
            if (!interactive) return;
            if (event2.ctrlKey || event2.shiftKey || isComposingEvent(event2)) return;
            const openOnKeyPress = prop("openOnKeyPress");
            const isModifierKey2 = event2.ctrlKey || event2.metaKey || event2.shiftKey;
            const keypress = true;
            const keymap = {
              ArrowDown(event3) {
                if (!openOnKeyPress && !open) return;
                send({ type: event3.altKey ? "OPEN" : "INPUT.ARROW_DOWN", keypress, src: "arrow-key" });
                event3.preventDefault();
              },
              ArrowUp() {
                if (!openOnKeyPress && !open) return;
                send({ type: event2.altKey ? "CLOSE" : "INPUT.ARROW_UP", keypress, src: "arrow-key" });
                event2.preventDefault();
              },
              Home(event3) {
                if (isModifierKey2) return;
                send({ type: "INPUT.HOME", keypress });
                if (open) {
                  event3.preventDefault();
                }
              },
              End(event3) {
                if (isModifierKey2) return;
                send({ type: "INPUT.END", keypress });
                if (open) {
                  event3.preventDefault();
                }
              },
              Enter(event3) {
                var _a;
                send({ type: "INPUT.ENTER", keypress, src: "item-select" });
                const submittable = computed("isCustomValue") && prop("allowCustomValue");
                const hasHighlight = highlightedValue != null;
                const alwaysSubmit = prop("alwaysSubmitOnEnter");
                if (open && !submittable && !alwaysSubmit && hasHighlight) {
                  event3.preventDefault();
                }
                if (highlightedValue == null) return;
                const itemEl = getItemEl(scope, highlightedValue);
                if (isAnchorElement(itemEl)) {
                  (_a = prop("navigate")) == null ? void 0 : _a({ value: highlightedValue, node: itemEl, href: itemEl.href });
                }
              },
              Escape() {
                send({ type: "INPUT.ESCAPE", keypress, src: "escape-key" });
                event2.preventDefault();
              }
            };
            const key = getEventKey(event2, { dir: prop("dir") });
            const exec = keymap[key];
            exec == null ? void 0 : exec(event2);
          }
        }));
      },
      getTriggerProps(props22 = {}) {
        return normalize.button(__spreadProps(__spreadValues({}, parts5.trigger.attrs), {
          dir: prop("dir"),
          id: getTriggerId2(scope),
          "aria-haspopup": composite ? "listbox" : "dialog",
          type: "button",
          tabIndex: props22.focusable ? void 0 : -1,
          "aria-label": translations.triggerLabel,
          "aria-expanded": open,
          "data-state": open ? "open" : "closed",
          "aria-controls": open ? getContentId2(scope) : void 0,
          disabled,
          "data-invalid": dataAttr(invalid),
          "data-focusable": dataAttr(props22.focusable),
          "data-readonly": dataAttr(readOnly),
          "data-disabled": dataAttr(disabled),
          onFocus() {
            if (!props22.focusable) return;
            send({ type: "INPUT.FOCUS", src: "trigger" });
          },
          onClick(event2) {
            if (event2.defaultPrevented) return;
            if (!interactive) return;
            if (!isLeftClick(event2)) return;
            send({ type: "TRIGGER.CLICK", src: "trigger-click" });
          },
          onPointerDown(event2) {
            if (!interactive) return;
            if (event2.pointerType === "touch") return;
            if (!isLeftClick(event2)) return;
            event2.preventDefault();
            queueMicrotask(() => {
              var _a;
              (_a = getInputEl2(scope)) == null ? void 0 : _a.focus({ preventScroll: true });
            });
          },
          onKeyDown(event2) {
            if (event2.defaultPrevented) return;
            if (composite) return;
            const keyMap2 = {
              ArrowDown() {
                send({ type: "INPUT.ARROW_DOWN", src: "arrow-key" });
              },
              ArrowUp() {
                send({ type: "INPUT.ARROW_UP", src: "arrow-key" });
              }
            };
            const key = getEventKey(event2, { dir: prop("dir") });
            const exec = keyMap2[key];
            if (exec) {
              exec(event2);
              event2.preventDefault();
            }
          }
        }));
      },
      getContentProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts5.content.attrs), {
          dir: prop("dir"),
          id: getContentId2(scope),
          role: !composite ? "dialog" : "listbox",
          tabIndex: -1,
          hidden: !open,
          "data-state": open ? "open" : "closed",
          "data-placement": context.get("currentPlacement"),
          "aria-labelledby": getLabelId3(scope),
          "aria-multiselectable": prop("multiple") && composite ? true : void 0,
          "data-empty": dataAttr(collection22.size === 0),
          onPointerDown(event2) {
            if (!isLeftClick(event2)) return;
            event2.preventDefault();
          }
        }));
      },
      getListProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts5.list.attrs), {
          role: !composite ? "listbox" : void 0,
          "data-empty": dataAttr(collection22.size === 0),
          "aria-labelledby": getLabelId3(scope),
          "aria-multiselectable": prop("multiple") && !composite ? true : void 0
        }));
      },
      getClearTriggerProps() {
        return normalize.button(__spreadProps(__spreadValues({}, parts5.clearTrigger.attrs), {
          dir: prop("dir"),
          id: getClearTriggerId(scope),
          type: "button",
          tabIndex: -1,
          disabled,
          "data-invalid": dataAttr(invalid),
          "aria-label": translations.clearTriggerLabel,
          "aria-controls": getInputId2(scope),
          hidden: !context.get("value").length,
          onPointerDown(event2) {
            if (!isLeftClick(event2)) return;
            event2.preventDefault();
          },
          onClick(event2) {
            if (event2.defaultPrevented) return;
            if (!interactive) return;
            send({ type: "VALUE.CLEAR", src: "clear-trigger" });
          }
        }));
      },
      getItemState,
      getItemProps(props22) {
        const itemState = getItemState(props22);
        const value = itemState.value;
        return normalize.element(__spreadProps(__spreadValues({}, parts5.item.attrs), {
          dir: prop("dir"),
          id: getItemId2(scope, value),
          role: "option",
          tabIndex: -1,
          "data-highlighted": dataAttr(itemState.highlighted),
          "data-state": itemState.selected ? "checked" : "unchecked",
          "aria-selected": ariaAttr(itemState.highlighted),
          "aria-disabled": ariaAttr(itemState.disabled),
          "data-disabled": dataAttr(itemState.disabled),
          "data-value": itemState.value,
          onPointerMove() {
            if (itemState.disabled) return;
            if (itemState.highlighted) return;
            send({ type: "ITEM.POINTER_MOVE", value });
          },
          onPointerLeave() {
            if (props22.persistFocus) return;
            if (itemState.disabled) return;
            const prev2 = event.previous();
            const mouseMoved = prev2 == null ? void 0 : prev2.type.includes("POINTER");
            if (!mouseMoved) return;
            send({ type: "ITEM.POINTER_LEAVE", value });
          },
          onClick(event2) {
            if (isDownloadingEvent(event2)) return;
            if (isOpeningInNewTab(event2)) return;
            if (isContextMenuEvent(event2)) return;
            if (itemState.disabled) return;
            send({ type: "ITEM.CLICK", src: "item-select", value });
          }
        }));
      },
      getItemTextProps(props22) {
        const itemState = getItemState(props22);
        return normalize.element(__spreadProps(__spreadValues({}, parts5.itemText.attrs), {
          dir: prop("dir"),
          "data-state": itemState.selected ? "checked" : "unchecked",
          "data-disabled": dataAttr(itemState.disabled),
          "data-highlighted": dataAttr(itemState.highlighted)
        }));
      },
      getItemIndicatorProps(props22) {
        const itemState = getItemState(props22);
        return normalize.element(__spreadProps(__spreadValues({
          "aria-hidden": true
        }, parts5.itemIndicator.attrs), {
          dir: prop("dir"),
          "data-state": itemState.selected ? "checked" : "unchecked",
          hidden: !itemState.selected
        }));
      },
      getItemGroupProps(props22) {
        const { id } = props22;
        return normalize.element(__spreadProps(__spreadValues({}, parts5.itemGroup.attrs), {
          dir: prop("dir"),
          id: getItemGroupId(scope, id),
          "aria-labelledby": getItemGroupLabelId(scope, id),
          "data-empty": dataAttr(collection22.size === 0),
          role: "group"
        }));
      },
      getItemGroupLabelProps(props22) {
        const { htmlFor } = props22;
        return normalize.element(__spreadProps(__spreadValues({}, parts5.itemGroupLabel.attrs), {
          dir: prop("dir"),
          id: getItemGroupLabelId(scope, htmlFor),
          role: "presentation"
        }));
      }
    };
  }
  function getOpenChangeReason(event) {
    return (event.previousEvent || event).src;
  }
  function snakeToCamel(str) {
    return str.replace(/_([a-z])/g, (_2, letter) => letter.toUpperCase());
  }
  function transformPositioningOptions(obj) {
    const result = {};
    for (const [key, value] of Object.entries(obj)) {
      const camelKey = snakeToCamel(key);
      result[camelKey] = value;
    }
    return result;
  }
  var anatomy5, parts5, collection, getRootId5, getLabelId3, getControlId2, getInputId2, getContentId2, getPositionerId, getTriggerId2, getClearTriggerId, getItemGroupId, getItemGroupLabelId, getItemId2, getContentEl2, getInputEl2, getPositionerEl, getControlEl, getTriggerEl, getClearTriggerEl, getItemEl, focusInputEl, focusTriggerEl, guards, createMachine2, choose, and2, not3, machine5, props5, splitProps5, itemGroupLabelProps, splitItemGroupLabelProps, itemGroupProps, splitItemGroupProps, itemProps2, splitItemProps2, Combobox, ComboboxHook;
  var init_combobox = __esm({
    "../priv/static/combobox.mjs"() {
      "use strict";
      init_chunk_2DWEYSRA();
      init_chunk_GRHV6R4F();
      init_chunk_BPSX7Z7Y();
      init_chunk_GFGFZBBD();
      anatomy5 = createAnatomy("combobox").parts(
        "root",
        "clearTrigger",
        "content",
        "control",
        "input",
        "item",
        "itemGroup",
        "itemGroupLabel",
        "itemIndicator",
        "itemText",
        "label",
        "list",
        "positioner",
        "trigger"
      );
      parts5 = anatomy5.build();
      collection = (options) => {
        return new ListCollection(options);
      };
      collection.empty = () => {
        return new ListCollection({ items: [] });
      };
      getRootId5 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.root) != null ? _b : `combobox:${ctx.id}`;
      };
      getLabelId3 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.label) != null ? _b : `combobox:${ctx.id}:label`;
      };
      getControlId2 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.control) != null ? _b : `combobox:${ctx.id}:control`;
      };
      getInputId2 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.input) != null ? _b : `combobox:${ctx.id}:input`;
      };
      getContentId2 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.content) != null ? _b : `combobox:${ctx.id}:content`;
      };
      getPositionerId = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.positioner) != null ? _b : `combobox:${ctx.id}:popper`;
      };
      getTriggerId2 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.trigger) != null ? _b : `combobox:${ctx.id}:toggle-btn`;
      };
      getClearTriggerId = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.clearTrigger) != null ? _b : `combobox:${ctx.id}:clear-btn`;
      };
      getItemGroupId = (ctx, id) => {
        var _a, _b, _c;
        return (_c = (_b = (_a = ctx.ids) == null ? void 0 : _a.itemGroup) == null ? void 0 : _b.call(_a, id)) != null ? _c : `combobox:${ctx.id}:optgroup:${id}`;
      };
      getItemGroupLabelId = (ctx, id) => {
        var _a, _b, _c;
        return (_c = (_b = (_a = ctx.ids) == null ? void 0 : _a.itemGroupLabel) == null ? void 0 : _b.call(_a, id)) != null ? _c : `combobox:${ctx.id}:optgroup-label:${id}`;
      };
      getItemId2 = (ctx, id) => {
        var _a, _b, _c;
        return (_c = (_b = (_a = ctx.ids) == null ? void 0 : _a.item) == null ? void 0 : _b.call(_a, id)) != null ? _c : `combobox:${ctx.id}:option:${id}`;
      };
      getContentEl2 = (ctx) => ctx.getById(getContentId2(ctx));
      getInputEl2 = (ctx) => ctx.getById(getInputId2(ctx));
      getPositionerEl = (ctx) => ctx.getById(getPositionerId(ctx));
      getControlEl = (ctx) => ctx.getById(getControlId2(ctx));
      getTriggerEl = (ctx) => ctx.getById(getTriggerId2(ctx));
      getClearTriggerEl = (ctx) => ctx.getById(getClearTriggerId(ctx));
      getItemEl = (ctx, value) => {
        if (value == null) return null;
        const selector = `[role=option][data-value="${CSS.escape(value)}"]`;
        return query(getContentEl2(ctx), selector);
      };
      focusInputEl = (ctx) => {
        const inputEl = getInputEl2(ctx);
        if (ctx.isActiveElement(inputEl)) return;
        inputEl == null ? void 0 : inputEl.focus({ preventScroll: true });
      };
      focusTriggerEl = (ctx) => {
        const triggerEl = getTriggerEl(ctx);
        if (ctx.isActiveElement(triggerEl)) return;
        triggerEl == null ? void 0 : triggerEl.focus({ preventScroll: true });
      };
      ({ guards, createMachine: createMachine2, choose } = setup());
      ({ and: and2, not: not3 } = guards);
      machine5 = createMachine2({
        props({ props: props22 }) {
          return __spreadProps(__spreadValues({
            loopFocus: true,
            openOnClick: false,
            defaultValue: [],
            defaultInputValue: "",
            closeOnSelect: !props22.multiple,
            allowCustomValue: false,
            alwaysSubmitOnEnter: false,
            inputBehavior: "none",
            selectionBehavior: props22.multiple ? "clear" : "replace",
            openOnKeyPress: true,
            openOnChange: true,
            composite: true,
            navigate({ node }) {
              clickIfLink(node);
            },
            collection: collection.empty()
          }, props22), {
            positioning: __spreadValues({
              placement: "bottom",
              sameWidth: true
            }, props22.positioning),
            translations: __spreadValues({
              triggerLabel: "Toggle suggestions",
              clearTriggerLabel: "Clear value"
            }, props22.translations)
          });
        },
        initialState({ prop }) {
          const open = prop("open") || prop("defaultOpen");
          return open ? "suggesting" : "idle";
        },
        context({ prop, bindable: bindable2, getContext, getEvent }) {
          return {
            currentPlacement: bindable2(() => ({
              defaultValue: void 0
            })),
            value: bindable2(() => ({
              defaultValue: prop("defaultValue"),
              value: prop("value"),
              isEqual: isEqual2,
              hash(value) {
                return value.join(",");
              },
              onChange(value) {
                var _a;
                const context = getContext();
                const prevSelectedItems = context.get("selectedItems");
                const collection22 = prop("collection");
                const nextItems = value.map((v2) => {
                  const item = prevSelectedItems.find((item2) => collection22.getItemValue(item2) === v2);
                  return item || collection22.find(v2);
                });
                context.set("selectedItems", nextItems);
                (_a = prop("onValueChange")) == null ? void 0 : _a({ value, items: nextItems });
              }
            })),
            highlightedValue: bindable2(() => ({
              defaultValue: prop("defaultHighlightedValue") || null,
              value: prop("highlightedValue"),
              onChange(value) {
                var _a;
                const item = prop("collection").find(value);
                (_a = prop("onHighlightChange")) == null ? void 0 : _a({ highlightedValue: value, highlightedItem: item });
              }
            })),
            inputValue: bindable2(() => {
              let inputValue = prop("inputValue") || prop("defaultInputValue");
              const value = prop("value") || prop("defaultValue");
              if (!inputValue.trim() && !prop("multiple")) {
                const valueAsString = prop("collection").stringifyMany(value);
                inputValue = match2(prop("selectionBehavior"), {
                  preserve: inputValue || valueAsString,
                  replace: valueAsString,
                  clear: ""
                });
              }
              return {
                defaultValue: inputValue,
                value: prop("inputValue"),
                onChange(value2) {
                  var _a;
                  const event = getEvent();
                  const reason = (event.previousEvent || event).src;
                  (_a = prop("onInputValueChange")) == null ? void 0 : _a({ inputValue: value2, reason });
                }
              };
            }),
            highlightedItem: bindable2(() => {
              const highlightedValue = prop("highlightedValue");
              const highlightedItem = prop("collection").find(highlightedValue);
              return { defaultValue: highlightedItem };
            }),
            selectedItems: bindable2(() => {
              const value = prop("value") || prop("defaultValue") || [];
              const selectedItems = prop("collection").findMany(value);
              return { defaultValue: selectedItems };
            })
          };
        },
        computed: {
          isInputValueEmpty: ({ context }) => context.get("inputValue").length === 0,
          isInteractive: ({ prop }) => !(prop("readOnly") || prop("disabled")),
          autoComplete: ({ prop }) => prop("inputBehavior") === "autocomplete",
          autoHighlight: ({ prop }) => prop("inputBehavior") === "autohighlight",
          hasSelectedItems: ({ context }) => context.get("value").length > 0,
          valueAsString: ({ context, prop }) => prop("collection").stringifyItems(context.get("selectedItems")),
          isCustomValue: ({ context, computed }) => context.get("inputValue") !== computed("valueAsString")
        },
        watch({ context, prop, track, action, send }) {
          track([() => context.hash("value")], () => {
            action(["syncSelectedItems"]);
          });
          track([() => context.get("inputValue")], () => {
            action(["syncInputValue"]);
          });
          track([() => context.get("highlightedValue")], () => {
            action(["syncHighlightedItem", "autofillInputValue"]);
          });
          track([() => prop("open")], () => {
            action(["toggleVisibility"]);
          });
          track([() => prop("collection").toString()], () => {
            send({ type: "CHILDREN_CHANGE" });
          });
        },
        on: {
          "SELECTED_ITEMS.SYNC": {
            actions: ["syncSelectedItems"]
          },
          "HIGHLIGHTED_VALUE.SET": {
            actions: ["setHighlightedValue"]
          },
          "HIGHLIGHTED_VALUE.CLEAR": {
            actions: ["clearHighlightedValue"]
          },
          "ITEM.SELECT": {
            actions: ["selectItem"]
          },
          "ITEM.CLEAR": {
            actions: ["clearItem"]
          },
          "VALUE.SET": {
            actions: ["setValue"]
          },
          "INPUT_VALUE.SET": {
            actions: ["setInputValue"]
          },
          "POSITIONING.SET": {
            actions: ["reposition"]
          }
        },
        entry: choose([
          {
            guard: "autoFocus",
            actions: ["setInitialFocus"]
          }
        ]),
        states: {
          idle: {
            tags: ["idle", "closed"],
            entry: ["scrollContentToTop", "clearHighlightedValue"],
            on: {
              "CONTROLLED.OPEN": {
                target: "interacting"
              },
              "TRIGGER.CLICK": [
                {
                  guard: "isOpenControlled",
                  actions: ["setInitialFocus", "highlightFirstSelectedItem", "invokeOnOpen"]
                },
                {
                  target: "interacting",
                  actions: ["setInitialFocus", "highlightFirstSelectedItem", "invokeOnOpen"]
                }
              ],
              "INPUT.CLICK": [
                {
                  guard: "isOpenControlled",
                  actions: ["highlightFirstSelectedItem", "invokeOnOpen"]
                },
                {
                  target: "interacting",
                  actions: ["highlightFirstSelectedItem", "invokeOnOpen"]
                }
              ],
              "INPUT.FOCUS": {
                target: "focused"
              },
              OPEN: [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnOpen"]
                },
                {
                  target: "interacting",
                  actions: ["invokeOnOpen"]
                }
              ],
              "VALUE.CLEAR": {
                target: "focused",
                actions: ["clearInputValue", "clearSelectedItems", "setInitialFocus"]
              }
            }
          },
          focused: {
            tags: ["focused", "closed"],
            entry: ["scrollContentToTop", "clearHighlightedValue"],
            on: {
              "CONTROLLED.OPEN": [
                {
                  guard: "isChangeEvent",
                  target: "suggesting"
                },
                {
                  target: "interacting"
                }
              ],
              "INPUT.CHANGE": [
                {
                  guard: and2("isOpenControlled", "openOnChange"),
                  actions: ["setInputValue", "invokeOnOpen", "highlightFirstItemIfNeeded"]
                },
                {
                  guard: "openOnChange",
                  target: "suggesting",
                  actions: ["setInputValue", "invokeOnOpen", "highlightFirstItemIfNeeded"]
                },
                {
                  actions: ["setInputValue"]
                }
              ],
              "LAYER.INTERACT_OUTSIDE": {
                target: "idle"
              },
              "INPUT.ESCAPE": {
                guard: and2("isCustomValue", not3("allowCustomValue")),
                actions: ["revertInputValue"]
              },
              "INPUT.BLUR": {
                target: "idle"
              },
              "INPUT.CLICK": [
                {
                  guard: "isOpenControlled",
                  actions: ["highlightFirstSelectedItem", "invokeOnOpen"]
                },
                {
                  target: "interacting",
                  actions: ["highlightFirstSelectedItem", "invokeOnOpen"]
                }
              ],
              "TRIGGER.CLICK": [
                {
                  guard: "isOpenControlled",
                  actions: ["setInitialFocus", "highlightFirstSelectedItem", "invokeOnOpen"]
                },
                {
                  target: "interacting",
                  actions: ["setInitialFocus", "highlightFirstSelectedItem", "invokeOnOpen"]
                }
              ],
              "INPUT.ARROW_DOWN": [
                // == group 1 ==
                {
                  guard: and2("isOpenControlled", "autoComplete"),
                  actions: ["invokeOnOpen"]
                },
                {
                  guard: "autoComplete",
                  target: "interacting",
                  actions: ["invokeOnOpen"]
                },
                // == group 2 ==
                {
                  guard: "isOpenControlled",
                  actions: ["highlightFirstOrSelectedItem", "invokeOnOpen"]
                },
                {
                  target: "interacting",
                  actions: ["highlightFirstOrSelectedItem", "invokeOnOpen"]
                }
              ],
              "INPUT.ARROW_UP": [
                // == group 1 ==
                {
                  guard: "autoComplete",
                  target: "interacting",
                  actions: ["invokeOnOpen"]
                },
                {
                  guard: "autoComplete",
                  target: "interacting",
                  actions: ["invokeOnOpen"]
                },
                // == group 2 ==
                {
                  target: "interacting",
                  actions: ["highlightLastOrSelectedItem", "invokeOnOpen"]
                },
                {
                  target: "interacting",
                  actions: ["highlightLastOrSelectedItem", "invokeOnOpen"]
                }
              ],
              OPEN: [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnOpen"]
                },
                {
                  target: "interacting",
                  actions: ["invokeOnOpen"]
                }
              ],
              "VALUE.CLEAR": {
                actions: ["clearInputValue", "clearSelectedItems"]
              }
            }
          },
          interacting: {
            tags: ["open", "focused"],
            entry: ["setInitialFocus"],
            effects: ["scrollToHighlightedItem", "trackDismissableLayer", "trackPlacement"],
            on: {
              "CONTROLLED.CLOSE": [
                {
                  guard: "restoreFocus",
                  target: "focused",
                  actions: ["setFinalFocus"]
                },
                {
                  target: "idle"
                }
              ],
              CHILDREN_CHANGE: [
                {
                  guard: "isHighlightedItemRemoved",
                  actions: ["clearHighlightedValue"]
                },
                {
                  actions: ["scrollToHighlightedItem"]
                }
              ],
              "INPUT.HOME": {
                actions: ["highlightFirstItem"]
              },
              "INPUT.END": {
                actions: ["highlightLastItem"]
              },
              "INPUT.ARROW_DOWN": [
                {
                  guard: and2("autoComplete", "isLastItemHighlighted"),
                  actions: ["clearHighlightedValue", "scrollContentToTop"]
                },
                {
                  actions: ["highlightNextItem"]
                }
              ],
              "INPUT.ARROW_UP": [
                {
                  guard: and2("autoComplete", "isFirstItemHighlighted"),
                  actions: ["clearHighlightedValue"]
                },
                {
                  actions: ["highlightPrevItem"]
                }
              ],
              "INPUT.ENTER": [
                // == group 1 ==
                {
                  guard: and2("isOpenControlled", "isCustomValue", not3("hasHighlightedItem"), not3("allowCustomValue")),
                  actions: ["revertInputValue", "invokeOnClose"]
                },
                {
                  guard: and2("isCustomValue", not3("hasHighlightedItem"), not3("allowCustomValue")),
                  target: "focused",
                  actions: ["revertInputValue", "invokeOnClose"]
                },
                // == group 2 ==
                {
                  guard: and2("isOpenControlled", "closeOnSelect"),
                  actions: ["selectHighlightedItem", "invokeOnClose"]
                },
                {
                  guard: "closeOnSelect",
                  target: "focused",
                  actions: ["selectHighlightedItem", "invokeOnClose", "setFinalFocus"]
                },
                {
                  actions: ["selectHighlightedItem"]
                }
              ],
              "INPUT.CHANGE": [
                {
                  guard: "autoComplete",
                  target: "suggesting",
                  actions: ["setInputValue"]
                },
                {
                  target: "suggesting",
                  actions: ["clearHighlightedValue", "setInputValue"]
                }
              ],
              "ITEM.POINTER_MOVE": {
                actions: ["setHighlightedValue"]
              },
              "ITEM.POINTER_LEAVE": {
                actions: ["clearHighlightedValue"]
              },
              "ITEM.CLICK": [
                {
                  guard: and2("isOpenControlled", "closeOnSelect"),
                  actions: ["selectItem", "invokeOnClose"]
                },
                {
                  guard: "closeOnSelect",
                  target: "focused",
                  actions: ["selectItem", "invokeOnClose", "setFinalFocus"]
                },
                {
                  actions: ["selectItem"]
                }
              ],
              "LAYER.ESCAPE": [
                {
                  guard: and2("isOpenControlled", "autoComplete"),
                  actions: ["syncInputValue", "invokeOnClose"]
                },
                {
                  guard: "autoComplete",
                  target: "focused",
                  actions: ["syncInputValue", "invokeOnClose"]
                },
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnClose"]
                },
                {
                  target: "focused",
                  actions: ["invokeOnClose", "setFinalFocus"]
                }
              ],
              "TRIGGER.CLICK": [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnClose"]
                },
                {
                  target: "focused",
                  actions: ["invokeOnClose"]
                }
              ],
              "LAYER.INTERACT_OUTSIDE": [
                // == group 1 ==
                {
                  guard: and2("isOpenControlled", "isCustomValue", not3("allowCustomValue")),
                  actions: ["revertInputValue", "invokeOnClose"]
                },
                {
                  guard: and2("isCustomValue", not3("allowCustomValue")),
                  target: "idle",
                  actions: ["revertInputValue", "invokeOnClose"]
                },
                // == group 2 ==
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnClose"]
                },
                {
                  target: "idle",
                  actions: ["invokeOnClose"]
                }
              ],
              CLOSE: [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnClose"]
                },
                {
                  target: "focused",
                  actions: ["invokeOnClose", "setFinalFocus"]
                }
              ],
              "VALUE.CLEAR": [
                {
                  guard: "isOpenControlled",
                  actions: ["clearInputValue", "clearSelectedItems", "invokeOnClose"]
                },
                {
                  target: "focused",
                  actions: ["clearInputValue", "clearSelectedItems", "invokeOnClose", "setFinalFocus"]
                }
              ]
            }
          },
          suggesting: {
            tags: ["open", "focused"],
            effects: ["trackDismissableLayer", "scrollToHighlightedItem", "trackPlacement"],
            entry: ["setInitialFocus"],
            on: {
              "CONTROLLED.CLOSE": [
                {
                  guard: "restoreFocus",
                  target: "focused",
                  actions: ["setFinalFocus"]
                },
                {
                  target: "idle"
                }
              ],
              CHILDREN_CHANGE: [
                {
                  guard: and2("isHighlightedItemRemoved", "hasCollectionItems", "autoHighlight"),
                  actions: ["clearHighlightedValue", "highlightFirstItem"]
                },
                {
                  guard: "isHighlightedItemRemoved",
                  actions: ["clearHighlightedValue"]
                },
                {
                  guard: "autoHighlight",
                  actions: ["highlightFirstItem"]
                }
              ],
              "INPUT.ARROW_DOWN": {
                target: "interacting",
                actions: ["highlightNextItem"]
              },
              "INPUT.ARROW_UP": {
                target: "interacting",
                actions: ["highlightPrevItem"]
              },
              "INPUT.HOME": {
                target: "interacting",
                actions: ["highlightFirstItem"]
              },
              "INPUT.END": {
                target: "interacting",
                actions: ["highlightLastItem"]
              },
              "INPUT.ENTER": [
                // == group 1 ==
                {
                  guard: and2("isOpenControlled", "isCustomValue", not3("hasHighlightedItem"), not3("allowCustomValue")),
                  actions: ["revertInputValue", "invokeOnClose"]
                },
                {
                  guard: and2("isCustomValue", not3("hasHighlightedItem"), not3("allowCustomValue")),
                  target: "focused",
                  actions: ["revertInputValue", "invokeOnClose"]
                },
                // == group 2 ==
                {
                  guard: and2("isOpenControlled", "closeOnSelect"),
                  actions: ["selectHighlightedItem", "invokeOnClose"]
                },
                {
                  guard: "closeOnSelect",
                  target: "focused",
                  actions: ["selectHighlightedItem", "invokeOnClose", "setFinalFocus"]
                },
                {
                  actions: ["selectHighlightedItem"]
                }
              ],
              "INPUT.CHANGE": {
                actions: ["setInputValue"]
              },
              "LAYER.ESCAPE": [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnClose"]
                },
                {
                  target: "focused",
                  actions: ["invokeOnClose"]
                }
              ],
              "ITEM.POINTER_MOVE": {
                target: "interacting",
                actions: ["setHighlightedValue"]
              },
              "ITEM.POINTER_LEAVE": {
                actions: ["clearHighlightedValue"]
              },
              "LAYER.INTERACT_OUTSIDE": [
                // == group 1 ==
                {
                  guard: and2("isOpenControlled", "isCustomValue", not3("allowCustomValue")),
                  actions: ["revertInputValue", "invokeOnClose"]
                },
                {
                  guard: and2("isCustomValue", not3("allowCustomValue")),
                  target: "idle",
                  actions: ["revertInputValue", "invokeOnClose"]
                },
                // == group 2 ==
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnClose"]
                },
                {
                  target: "idle",
                  actions: ["invokeOnClose"]
                }
              ],
              "TRIGGER.CLICK": [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnClose"]
                },
                {
                  target: "focused",
                  actions: ["invokeOnClose"]
                }
              ],
              "ITEM.CLICK": [
                {
                  guard: and2("isOpenControlled", "closeOnSelect"),
                  actions: ["selectItem", "invokeOnClose"]
                },
                {
                  guard: "closeOnSelect",
                  target: "focused",
                  actions: ["selectItem", "invokeOnClose", "setFinalFocus"]
                },
                {
                  actions: ["selectItem"]
                }
              ],
              CLOSE: [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnClose"]
                },
                {
                  target: "focused",
                  actions: ["invokeOnClose", "setFinalFocus"]
                }
              ],
              "VALUE.CLEAR": [
                {
                  guard: "isOpenControlled",
                  actions: ["clearInputValue", "clearSelectedItems", "invokeOnClose"]
                },
                {
                  target: "focused",
                  actions: ["clearInputValue", "clearSelectedItems", "invokeOnClose", "setFinalFocus"]
                }
              ]
            }
          }
        },
        implementations: {
          guards: {
            isInputValueEmpty: ({ computed }) => computed("isInputValueEmpty"),
            autoComplete: ({ computed, prop }) => computed("autoComplete") && !prop("multiple"),
            autoHighlight: ({ computed }) => computed("autoHighlight"),
            isFirstItemHighlighted: ({ prop, context }) => prop("collection").firstValue === context.get("highlightedValue"),
            isLastItemHighlighted: ({ prop, context }) => prop("collection").lastValue === context.get("highlightedValue"),
            isCustomValue: ({ computed }) => computed("isCustomValue"),
            allowCustomValue: ({ prop }) => !!prop("allowCustomValue"),
            hasHighlightedItem: ({ context }) => context.get("highlightedValue") != null,
            closeOnSelect: ({ prop }) => !!prop("closeOnSelect"),
            isOpenControlled: ({ prop }) => prop("open") != null,
            openOnChange: ({ prop, context }) => {
              const openOnChange = prop("openOnChange");
              if (isBoolean(openOnChange)) return openOnChange;
              return !!(openOnChange == null ? void 0 : openOnChange({ inputValue: context.get("inputValue") }));
            },
            restoreFocus: ({ event }) => {
              var _a, _b;
              const restoreFocus = (_b = event.restoreFocus) != null ? _b : (_a = event.previousEvent) == null ? void 0 : _a.restoreFocus;
              return restoreFocus == null ? true : !!restoreFocus;
            },
            isChangeEvent: ({ event }) => {
              var _a;
              return ((_a = event.previousEvent) == null ? void 0 : _a.type) === "INPUT.CHANGE";
            },
            autoFocus: ({ prop }) => !!prop("autoFocus"),
            isHighlightedItemRemoved: ({ prop, context }) => !prop("collection").has(context.get("highlightedValue")),
            hasCollectionItems: ({ prop }) => prop("collection").size > 0
          },
          effects: {
            trackDismissableLayer({ send, prop, scope }) {
              if (prop("disableLayer")) return;
              const contentEl = () => getContentEl2(scope);
              return trackDismissableElement(contentEl, {
                type: "listbox",
                defer: true,
                exclude: () => [getInputEl2(scope), getTriggerEl(scope), getClearTriggerEl(scope)],
                onFocusOutside: prop("onFocusOutside"),
                onPointerDownOutside: prop("onPointerDownOutside"),
                onInteractOutside: prop("onInteractOutside"),
                onEscapeKeyDown(event) {
                  event.preventDefault();
                  event.stopPropagation();
                  send({ type: "LAYER.ESCAPE", src: "escape-key" });
                },
                onDismiss() {
                  send({ type: "LAYER.INTERACT_OUTSIDE", src: "interact-outside", restoreFocus: false });
                }
              });
            },
            trackPlacement({ context, prop, scope }) {
              const anchorEl = () => getControlEl(scope) || getTriggerEl(scope);
              const positionerEl = () => getPositionerEl(scope);
              context.set("currentPlacement", prop("positioning").placement);
              return getPlacement(anchorEl, positionerEl, __spreadProps(__spreadValues({}, prop("positioning")), {
                defer: true,
                onComplete(data) {
                  context.set("currentPlacement", data.placement);
                }
              }));
            },
            scrollToHighlightedItem({ context, prop, scope, event }) {
              const inputEl = getInputEl2(scope);
              let cleanups = [];
              const exec = (immediate) => {
                const pointer = event.current().type.includes("POINTER");
                const highlightedValue = context.get("highlightedValue");
                if (pointer || !highlightedValue) return;
                const contentEl = getContentEl2(scope);
                const scrollToIndexFn = prop("scrollToIndexFn");
                if (scrollToIndexFn) {
                  const highlightedIndex = prop("collection").indexOf(highlightedValue);
                  scrollToIndexFn({
                    index: highlightedIndex,
                    immediate,
                    getElement: () => getItemEl(scope, highlightedValue)
                  });
                  return;
                }
                const itemEl = getItemEl(scope, highlightedValue);
                const raf_cleanup = raf(() => {
                  scrollIntoView(itemEl, { rootEl: contentEl, block: "nearest" });
                });
                cleanups.push(raf_cleanup);
              };
              const rafCleanup = raf(() => exec(true));
              cleanups.push(rafCleanup);
              const observerCleanup = observeAttributes(inputEl, {
                attributes: ["aria-activedescendant"],
                callback: () => exec(false)
              });
              cleanups.push(observerCleanup);
              return () => {
                cleanups.forEach((cleanup) => cleanup());
              };
            }
          },
          actions: {
            reposition({ context, prop, scope, event }) {
              const controlEl = () => getControlEl(scope);
              const positionerEl = () => getPositionerEl(scope);
              getPlacement(controlEl, positionerEl, __spreadProps(__spreadValues(__spreadValues({}, prop("positioning")), event.options), {
                defer: true,
                listeners: false,
                onComplete(data) {
                  context.set("currentPlacement", data.placement);
                }
              }));
            },
            setHighlightedValue({ context, event }) {
              if (event.value == null) return;
              context.set("highlightedValue", event.value);
            },
            clearHighlightedValue({ context }) {
              context.set("highlightedValue", null);
            },
            selectHighlightedItem(params) {
              var _a;
              const { context, prop } = params;
              const collection22 = prop("collection");
              const highlightedValue = context.get("highlightedValue");
              if (!highlightedValue || !collection22.has(highlightedValue)) return;
              const nextValue = prop("multiple") ? addOrRemove(context.get("value"), highlightedValue) : [highlightedValue];
              (_a = prop("onSelect")) == null ? void 0 : _a({ value: nextValue, itemValue: highlightedValue });
              context.set("value", nextValue);
              const inputValue = match2(prop("selectionBehavior"), {
                preserve: context.get("inputValue"),
                replace: collection22.stringifyMany(nextValue),
                clear: ""
              });
              context.set("inputValue", inputValue);
            },
            scrollToHighlightedItem({ context, prop, scope }) {
              nextTick(() => {
                const highlightedValue = context.get("highlightedValue");
                if (highlightedValue == null) return;
                const itemEl = getItemEl(scope, highlightedValue);
                const contentEl = getContentEl2(scope);
                const scrollToIndexFn = prop("scrollToIndexFn");
                if (scrollToIndexFn) {
                  const highlightedIndex = prop("collection").indexOf(highlightedValue);
                  scrollToIndexFn({
                    index: highlightedIndex,
                    immediate: true,
                    getElement: () => getItemEl(scope, highlightedValue)
                  });
                  return;
                }
                scrollIntoView(itemEl, { rootEl: contentEl, block: "nearest" });
              });
            },
            selectItem(params) {
              const { context, event, flush, prop } = params;
              if (event.value == null) return;
              flush(() => {
                var _a;
                const nextValue = prop("multiple") ? addOrRemove(context.get("value"), event.value) : [event.value];
                (_a = prop("onSelect")) == null ? void 0 : _a({ value: nextValue, itemValue: event.value });
                context.set("value", nextValue);
                const inputValue = match2(prop("selectionBehavior"), {
                  preserve: context.get("inputValue"),
                  replace: prop("collection").stringifyMany(nextValue),
                  clear: ""
                });
                context.set("inputValue", inputValue);
              });
            },
            clearItem(params) {
              const { context, event, flush, prop } = params;
              if (event.value == null) return;
              flush(() => {
                const nextValue = remove(context.get("value"), event.value);
                context.set("value", nextValue);
                const inputValue = match2(prop("selectionBehavior"), {
                  preserve: context.get("inputValue"),
                  replace: prop("collection").stringifyMany(nextValue),
                  clear: ""
                });
                context.set("inputValue", inputValue);
              });
            },
            setInitialFocus({ scope }) {
              raf(() => {
                focusInputEl(scope);
              });
            },
            setFinalFocus({ scope }) {
              raf(() => {
                const triggerEl = getTriggerEl(scope);
                if ((triggerEl == null ? void 0 : triggerEl.dataset.focusable) == null) {
                  focusInputEl(scope);
                } else {
                  focusTriggerEl(scope);
                }
              });
            },
            syncInputValue({ context, scope, event }) {
              const inputEl = getInputEl2(scope);
              if (!inputEl) return;
              inputEl.value = context.get("inputValue");
              queueMicrotask(() => {
                if (event.current().type === "INPUT.CHANGE") return;
                setCaretToEnd(inputEl);
              });
            },
            setInputValue({ context, event }) {
              context.set("inputValue", event.value);
            },
            clearInputValue({ context }) {
              context.set("inputValue", "");
            },
            revertInputValue({ context, prop, computed }) {
              const selectionBehavior = prop("selectionBehavior");
              const inputValue = match2(selectionBehavior, {
                replace: computed("hasSelectedItems") ? computed("valueAsString") : "",
                preserve: context.get("inputValue"),
                clear: ""
              });
              context.set("inputValue", inputValue);
            },
            setValue(params) {
              const { context, flush, event, prop } = params;
              flush(() => {
                context.set("value", event.value);
                const inputValue = match2(prop("selectionBehavior"), {
                  preserve: context.get("inputValue"),
                  replace: prop("collection").stringifyMany(event.value),
                  clear: ""
                });
                context.set("inputValue", inputValue);
              });
            },
            clearSelectedItems(params) {
              const { context, flush, prop } = params;
              flush(() => {
                context.set("value", []);
                const inputValue = match2(prop("selectionBehavior"), {
                  preserve: context.get("inputValue"),
                  replace: prop("collection").stringifyMany([]),
                  clear: ""
                });
                context.set("inputValue", inputValue);
              });
            },
            scrollContentToTop({ prop, scope }) {
              const scrollToIndexFn = prop("scrollToIndexFn");
              if (scrollToIndexFn) {
                const firstValue = prop("collection").firstValue;
                scrollToIndexFn({
                  index: 0,
                  immediate: true,
                  getElement: () => getItemEl(scope, firstValue)
                });
              } else {
                const contentEl = getContentEl2(scope);
                if (!contentEl) return;
                contentEl.scrollTop = 0;
              }
            },
            invokeOnOpen({ prop, event, context }) {
              var _a;
              const reason = getOpenChangeReason(event);
              (_a = prop("onOpenChange")) == null ? void 0 : _a({ open: true, reason, value: context.get("value") });
            },
            invokeOnClose({ prop, event, context }) {
              var _a;
              const reason = getOpenChangeReason(event);
              (_a = prop("onOpenChange")) == null ? void 0 : _a({ open: false, reason, value: context.get("value") });
            },
            highlightFirstItem({ context, prop, scope }) {
              const exec = getContentEl2(scope) ? queueMicrotask : raf;
              exec(() => {
                const value = prop("collection").firstValue;
                if (value) context.set("highlightedValue", value);
              });
            },
            highlightFirstItemIfNeeded({ computed, action }) {
              if (!computed("autoHighlight")) return;
              action(["highlightFirstItem"]);
            },
            highlightLastItem({ context, prop, scope }) {
              const exec = getContentEl2(scope) ? queueMicrotask : raf;
              exec(() => {
                const value = prop("collection").lastValue;
                if (value) context.set("highlightedValue", value);
              });
            },
            highlightNextItem({ context, prop }) {
              let value = null;
              const highlightedValue = context.get("highlightedValue");
              const collection22 = prop("collection");
              if (highlightedValue) {
                value = collection22.getNextValue(highlightedValue);
                if (!value && prop("loopFocus")) value = collection22.firstValue;
              } else {
                value = collection22.firstValue;
              }
              if (value) context.set("highlightedValue", value);
            },
            highlightPrevItem({ context, prop }) {
              let value = null;
              const highlightedValue = context.get("highlightedValue");
              const collection22 = prop("collection");
              if (highlightedValue) {
                value = collection22.getPreviousValue(highlightedValue);
                if (!value && prop("loopFocus")) value = collection22.lastValue;
              } else {
                value = collection22.lastValue;
              }
              if (value) context.set("highlightedValue", value);
            },
            highlightFirstSelectedItem({ context, prop }) {
              raf(() => {
                const [value] = prop("collection").sort(context.get("value"));
                if (value) context.set("highlightedValue", value);
              });
            },
            highlightFirstOrSelectedItem({ context, prop, computed }) {
              raf(() => {
                let value = null;
                if (computed("hasSelectedItems")) {
                  value = prop("collection").sort(context.get("value"))[0];
                } else {
                  value = prop("collection").firstValue;
                }
                if (value) context.set("highlightedValue", value);
              });
            },
            highlightLastOrSelectedItem({ context, prop, computed }) {
              raf(() => {
                const collection22 = prop("collection");
                let value = null;
                if (computed("hasSelectedItems")) {
                  value = collection22.sort(context.get("value"))[0];
                } else {
                  value = collection22.lastValue;
                }
                if (value) context.set("highlightedValue", value);
              });
            },
            autofillInputValue({ context, computed, prop, event, scope }) {
              const inputEl = getInputEl2(scope);
              const collection22 = prop("collection");
              if (!computed("autoComplete") || !inputEl || !event.keypress) return;
              const valueText = collection22.stringify(context.get("highlightedValue"));
              raf(() => {
                inputEl.value = valueText || context.get("inputValue");
              });
            },
            syncSelectedItems(params) {
              queueMicrotask(() => {
                const { context, prop } = params;
                const collection22 = prop("collection");
                const value = context.get("value");
                const selectedItems = value.map((v2) => {
                  const item = context.get("selectedItems").find((item2) => collection22.getItemValue(item2) === v2);
                  return item || collection22.find(v2);
                });
                context.set("selectedItems", selectedItems);
                const inputValue = match2(prop("selectionBehavior"), {
                  preserve: context.get("inputValue"),
                  replace: collection22.stringifyMany(value),
                  clear: ""
                });
                context.set("inputValue", inputValue);
              });
            },
            syncHighlightedItem({ context, prop }) {
              const item = prop("collection").find(context.get("highlightedValue"));
              context.set("highlightedItem", item);
            },
            toggleVisibility({ event, send, prop }) {
              send({ type: prop("open") ? "CONTROLLED.OPEN" : "CONTROLLED.CLOSE", previousEvent: event });
            }
          }
        }
      });
      props5 = createProps()([
        "allowCustomValue",
        "autoFocus",
        "closeOnSelect",
        "collection",
        "composite",
        "defaultHighlightedValue",
        "defaultInputValue",
        "defaultOpen",
        "defaultValue",
        "dir",
        "disabled",
        "disableLayer",
        "form",
        "getRootNode",
        "highlightedValue",
        "id",
        "ids",
        "inputBehavior",
        "inputValue",
        "invalid",
        "loopFocus",
        "multiple",
        "name",
        "navigate",
        "onFocusOutside",
        "onHighlightChange",
        "onInputValueChange",
        "onInteractOutside",
        "onOpenChange",
        "onOpenChange",
        "onPointerDownOutside",
        "onSelect",
        "onValueChange",
        "open",
        "openOnChange",
        "openOnClick",
        "openOnKeyPress",
        "placeholder",
        "positioning",
        "readOnly",
        "required",
        "scrollToIndexFn",
        "selectionBehavior",
        "translations",
        "value",
        "alwaysSubmitOnEnter"
      ]);
      splitProps5 = createSplitProps(props5);
      itemGroupLabelProps = createProps()(["htmlFor"]);
      splitItemGroupLabelProps = createSplitProps(itemGroupLabelProps);
      itemGroupProps = createProps()(["id"]);
      splitItemGroupProps = createSplitProps(itemGroupProps);
      itemProps2 = createProps()(["item", "persistFocus"]);
      splitItemProps2 = createSplitProps(itemProps2);
      Combobox = class extends Component {
        constructor() {
          super(...arguments);
          __publicField(this, "options", []);
          __publicField(this, "allOptions", []);
          __publicField(this, "hasGroups", false);
        }
        setAllOptions(options) {
          this.allOptions = options;
          this.options = options;
        }
        getCollection() {
          const items = this.options || this.allOptions || [];
          if (this.hasGroups) {
            return collection({
              items,
              itemToValue: (item) => item.id,
              itemToString: (item) => item.label,
              isItemDisabled: (item) => item.disabled,
              groupBy: (item) => item.group
            });
          }
          return collection({
            items,
            itemToValue: (item) => item.id,
            itemToString: (item) => item.label,
            isItemDisabled: (item) => item.disabled
          });
        }
        initMachine(props22) {
          const self2 = this;
          return new VanillaMachine(machine5, __spreadProps(__spreadValues({}, props22), {
            get collection() {
              return self2.getCollection();
            },
            onOpenChange: (details) => {
              if (details.open) {
                self2.options = self2.allOptions;
              }
              if (props22.onOpenChange) {
                props22.onOpenChange(details);
              }
            },
            onInputValueChange: (details) => {
              const filtered = self2.allOptions.filter(
                (item) => item.label.toLowerCase().includes(details.inputValue.toLowerCase())
              );
              self2.options = filtered.length > 0 ? filtered : self2.allOptions;
              if (props22.onInputValueChange) {
                props22.onInputValueChange(details);
              }
            }
          }));
        }
        initApi() {
          return connect5(this.machine.service, normalizeProps);
        }
        renderItems() {
          var _a, _b, _c;
          const contentEl = this.el.querySelector('[data-scope="combobox"][data-part="content"]');
          if (!contentEl) return;
          const templatesContainer = this.el.querySelector('[data-templates="combobox"]');
          if (!templatesContainer) return;
          contentEl.querySelectorAll('[data-scope="combobox"][data-part="item"]:not([data-template])').forEach((el) => el.remove());
          contentEl.querySelectorAll('[data-scope="combobox"][data-part="item-group"]:not([data-template])').forEach((el) => el.remove());
          const items = this.api.collection.items;
          const groups = (_c = (_b = (_a = this.api.collection).group) == null ? void 0 : _b.call(_a)) != null ? _c : [];
          const hasGroupsInCollection = groups.some(([group2]) => group2 != null);
          if (hasGroupsInCollection) {
            this.renderGroupedItems(contentEl, templatesContainer, groups);
          } else {
            this.renderFlatItems(contentEl, templatesContainer, items);
          }
        }
        renderGroupedItems(contentEl, templatesContainer, groups) {
          for (const [groupId, groupItems] of groups) {
            if (groupId == null) continue;
            const groupTemplate = templatesContainer.querySelector(
              `[data-scope="combobox"][data-part="item-group"][data-id="${groupId}"][data-template]`
            );
            if (!groupTemplate) continue;
            const groupEl = groupTemplate.cloneNode(true);
            groupEl.removeAttribute("data-template");
            this.spreadProps(groupEl, this.api.getItemGroupProps({ id: groupId }));
            const labelEl = groupEl.querySelector(
              '[data-scope="combobox"][data-part="item-group-label"]'
            );
            if (labelEl) {
              this.spreadProps(
                labelEl,
                this.api.getItemGroupLabelProps({ htmlFor: groupId })
              );
            }
            const groupContentEl = groupEl.querySelector(
              '[data-scope="combobox"][data-part="item-group-content"]'
            );
            if (!groupContentEl) continue;
            groupContentEl.innerHTML = "";
            for (const item of groupItems) {
              const itemEl = this.cloneItem(templatesContainer, item);
              if (itemEl) groupContentEl.appendChild(itemEl);
            }
            contentEl.appendChild(groupEl);
          }
        }
        renderFlatItems(contentEl, templatesContainer, items) {
          for (const item of items) {
            const itemEl = this.cloneItem(templatesContainer, item);
            if (itemEl) contentEl.appendChild(itemEl);
          }
        }
        cloneItem(templatesContainer, item) {
          const value = this.api.collection.getItemValue(item);
          const template = templatesContainer.querySelector(
            `[data-scope="combobox"][data-part="item"][data-value="${value}"][data-template]`
          );
          if (!template) return null;
          const el = template.cloneNode(true);
          el.removeAttribute("data-template");
          this.spreadProps(el, this.api.getItemProps({ item }));
          const textEl = el.querySelector('[data-scope="combobox"][data-part="item-text"]');
          if (textEl) {
            this.spreadProps(textEl, this.api.getItemTextProps({ item }));
            if (textEl.children.length === 0) {
              textEl.textContent = item.label || "";
            }
          }
          const indicatorEl = el.querySelector('[data-scope="combobox"][data-part="item-indicator"]');
          if (indicatorEl) {
            this.spreadProps(
              indicatorEl,
              this.api.getItemIndicatorProps({ item })
            );
          }
          return el;
        }
        render() {
          const root = this.el.querySelector('[data-scope="combobox"][data-part="root"]');
          if (!root) return;
          this.spreadProps(root, this.api.getRootProps());
          [
            "label",
            "control",
            "input",
            "trigger",
            "clear-trigger",
            "positioner"
          ].forEach((part) => {
            const el = this.el.querySelector(`[data-scope="combobox"][data-part="${part}"]`);
            if (!el) return;
            const apiMethod = "get" + part.split("-").map((s2) => s2[0].toUpperCase() + s2.slice(1)).join("") + "Props";
            this.spreadProps(el, this.api[apiMethod]());
          });
          const contentEl = this.el.querySelector('[data-scope="combobox"][data-part="content"]');
          if (contentEl) {
            this.spreadProps(contentEl, this.api.getContentProps());
            this.renderItems();
          }
        }
      };
      ComboboxHook = {
        mounted() {
          const el = this.el;
          const pushEvent = this.pushEvent.bind(this);
          const allItems = JSON.parse(el.dataset.collection || "[]");
          const hasGroups = allItems.some((item) => item.group !== void 0);
          const props22 = __spreadProps(__spreadValues({
            id: el.id
          }, getBoolean(el, "controlled") ? { value: getStringList(el, "value") } : { defaultValue: getStringList(el, "defaultValue") }), {
            disabled: getBoolean(el, "disabled"),
            placeholder: getString(el, "placeholder"),
            alwaysSubmitOnEnter: getBoolean(el, "alwaysSubmitOnEnter"),
            autoFocus: getBoolean(el, "autoFocus"),
            closeOnSelect: getBoolean(el, "closeOnSelect"),
            dir: getString(el, "dir", ["ltr", "rtl"]),
            inputBehavior: getString(el, "inputBehavior", ["autohighlight", "autocomplete", "none"]),
            loopFocus: getBoolean(el, "loopFocus"),
            multiple: getBoolean(el, "multiple"),
            invalid: getBoolean(el, "invalid"),
            allowCustomValue: false,
            selectionBehavior: "replace",
            name: getString(el, "name"),
            form: getString(el, "form"),
            readOnly: getBoolean(el, "readOnly"),
            required: getBoolean(el, "required"),
            positioning: (() => {
              const positioningJson = el.dataset.positioning;
              if (positioningJson) {
                try {
                  const parsed = JSON.parse(positioningJson);
                  return transformPositioningOptions(parsed);
                } catch (e2) {
                  return void 0;
                }
              }
              return void 0;
            })(),
            onOpenChange: (details) => {
              const eventName = getString(el, "onOpenChange");
              if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
                pushEvent(eventName, {
                  open: details.open,
                  reason: details.reason,
                  value: details.value,
                  id: el.id
                });
              }
              const eventNameClient = getString(el, "onOpenChangeClient");
              if (eventNameClient) {
                el.dispatchEvent(
                  new CustomEvent(eventNameClient, {
                    bubbles: getBoolean(el, "bubble"),
                    detail: {
                      open: details.open,
                      reason: details.reason,
                      value: details.value,
                      id: el.id
                    }
                  })
                );
              }
            },
            onInputValueChange: (details) => {
              const eventName = getString(el, "onInputValueChange");
              if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
                pushEvent(eventName, {
                  value: details.inputValue,
                  reason: details.reason,
                  id: el.id
                });
              }
              const eventNameClient = getString(el, "onInputValueChangeClient");
              if (eventNameClient) {
                el.dispatchEvent(
                  new CustomEvent(eventNameClient, {
                    bubbles: getBoolean(el, "bubble"),
                    detail: {
                      value: details.inputValue,
                      reason: details.reason,
                      id: el.id
                    }
                  })
                );
              }
            },
            onValueChange: (details) => {
              const valueInput = el.querySelector(
                '[data-scope="combobox"][data-part="value-input"]'
              );
              if (valueInput) {
                const idValue = details.value.length === 0 ? "" : details.value.length === 1 ? String(details.value[0]) : details.value.map(String).join(",");
                valueInput.value = idValue;
                const formId = valueInput.getAttribute("form");
                let form = null;
                if (formId) {
                  form = document.getElementById(formId);
                } else {
                  form = valueInput.closest("form");
                }
                const changeEvent = new Event("change", {
                  bubbles: true,
                  cancelable: true
                });
                valueInput.dispatchEvent(changeEvent);
                const inputEvent = new Event("input", {
                  bubbles: true,
                  cancelable: true
                });
                valueInput.dispatchEvent(inputEvent);
                if (form && form.hasAttribute("phx-change")) {
                  requestAnimationFrame(() => {
                    const formElement = form.querySelector("input, select, textarea");
                    if (formElement) {
                      const formChangeEvent = new Event("change", {
                        bubbles: true,
                        cancelable: true
                      });
                      formElement.dispatchEvent(formChangeEvent);
                    } else {
                      const formChangeEvent = new Event("change", {
                        bubbles: true,
                        cancelable: true
                      });
                      form.dispatchEvent(formChangeEvent);
                    }
                  });
                }
              }
              const eventName = getString(el, "onValueChange");
              if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
                pushEvent(eventName, {
                  value: details.value,
                  items: details.items,
                  id: el.id
                });
              }
              const eventNameClient = getString(el, "onValueChangeClient");
              if (eventNameClient) {
                el.dispatchEvent(
                  new CustomEvent(eventNameClient, {
                    bubbles: getBoolean(el, "bubble"),
                    detail: {
                      value: details.value,
                      items: details.items,
                      id: el.id
                    }
                  })
                );
              }
            }
          });
          const combobox = new Combobox(el, props22);
          combobox.hasGroups = hasGroups;
          combobox.setAllOptions(allItems);
          combobox.init();
          const initialValue = getBoolean(el, "controlled") ? getStringList(el, "value") : getStringList(el, "defaultValue");
          if (initialValue && initialValue.length > 0) {
            const selectedItems = allItems.filter(
              (item) => initialValue.includes(item.id)
            );
            if (selectedItems.length > 0) {
              const inputValue = selectedItems.map((item) => item.label).join(", ");
              if (combobox.api && typeof combobox.api.setInputValue === "function") {
                combobox.api.setInputValue(inputValue);
              } else {
                const inputEl = el.querySelector(
                  '[data-scope="combobox"][data-part="input"]'
                );
                if (inputEl) {
                  inputEl.value = inputValue;
                }
              }
            }
          }
          this.combobox = combobox;
          this.handlers = [];
        },
        updated() {
          const newCollection = JSON.parse(this.el.dataset.collection || "[]");
          const hasGroups = newCollection.some((item) => item.group !== void 0);
          if (this.combobox) {
            this.combobox.hasGroups = hasGroups;
            this.combobox.setAllOptions(newCollection);
            this.combobox.updateProps(__spreadProps(__spreadValues({}, getBoolean(this.el, "controlled") ? { value: getStringList(this.el, "value") } : { defaultValue: getStringList(this.el, "defaultValue") }), {
              name: getString(this.el, "name"),
              form: getString(this.el, "form"),
              disabled: getBoolean(this.el, "disabled"),
              multiple: getBoolean(this.el, "multiple"),
              dir: getString(this.el, "dir", ["ltr", "rtl"]),
              invalid: getBoolean(this.el, "invalid"),
              required: getBoolean(this.el, "required"),
              readOnly: getBoolean(this.el, "readOnly")
            }));
            const inputEl = this.el.querySelector(
              '[data-scope="combobox"][data-part="input"]'
            );
            if (inputEl) {
              inputEl.removeAttribute("name");
              inputEl.removeAttribute("form");
              inputEl.name = "";
            }
          }
        },
        destroyed() {
          var _a;
          if (this.handlers) {
            for (const handler of this.handlers) {
              this.removeHandleEvent(handler);
            }
          }
          (_a = this.combobox) == null ? void 0 : _a.destroy();
        }
      };
    }
  });

  // ../priv/static/date-picker.mjs
  var date_picker_exports = {};
  __export(date_picker_exports, {
    DatePicker: () => DatePickerHook
  });
  function $2b4dce13dd5a17fa$export$842a2cf37af977e1(amount, numerator) {
    return amount - numerator * Math.floor(amount / numerator);
  }
  function $3b62074eb05584b2$export$f297eb839006d339(era, year, month, day) {
    year = $3b62074eb05584b2$export$c36e0ecb2d4fa69d(era, year);
    let y1 = year - 1;
    let monthOffset = -2;
    if (month <= 2) monthOffset = 0;
    else if ($3b62074eb05584b2$export$553d7fa8e3805fc0(year)) monthOffset = -1;
    return $3b62074eb05584b2$var$EPOCH - 1 + 365 * y1 + Math.floor(y1 / 4) - Math.floor(y1 / 100) + Math.floor(y1 / 400) + Math.floor((367 * month - 362) / 12 + monthOffset + day);
  }
  function $3b62074eb05584b2$export$553d7fa8e3805fc0(year) {
    return year % 4 === 0 && (year % 100 !== 0 || year % 400 === 0);
  }
  function $3b62074eb05584b2$export$c36e0ecb2d4fa69d(era, year) {
    return era === "BC" ? 1 - year : year;
  }
  function $3b62074eb05584b2$export$4475b7e617eb123c(year) {
    let era = "AD";
    if (year <= 0) {
      era = "BC";
      year = 1 - year;
    }
    return [
      era,
      year
    ];
  }
  function $14e0f24ef4ac5c92$export$ea39ec197993aef0(a2, b2) {
    b2 = (0, $11d87f3f76e88657$export$b4a036af3fc0b032)(b2, a2.calendar);
    return a2.era === b2.era && a2.year === b2.year && a2.month === b2.month && a2.day === b2.day;
  }
  function $14e0f24ef4ac5c92$export$a18c89cbd24170ff(a2, b2) {
    b2 = (0, $11d87f3f76e88657$export$b4a036af3fc0b032)(b2, a2.calendar);
    a2 = $14e0f24ef4ac5c92$export$a5a3b454ada2268e(a2);
    b2 = $14e0f24ef4ac5c92$export$a5a3b454ada2268e(b2);
    return a2.era === b2.era && a2.year === b2.year && a2.month === b2.month;
  }
  function $14e0f24ef4ac5c92$export$5841f9eb9773f25f(a2, b2) {
    b2 = (0, $11d87f3f76e88657$export$b4a036af3fc0b032)(b2, a2.calendar);
    a2 = $14e0f24ef4ac5c92$export$f91e89d3d0406102(a2);
    b2 = $14e0f24ef4ac5c92$export$f91e89d3d0406102(b2);
    return a2.era === b2.era && a2.year === b2.year;
  }
  function $14e0f24ef4ac5c92$export$91b62ebf2ba703ee(a2, b2) {
    return $14e0f24ef4ac5c92$export$dbc69fd56b53d5e(a2.calendar, b2.calendar) && $14e0f24ef4ac5c92$export$ea39ec197993aef0(a2, b2);
  }
  function $14e0f24ef4ac5c92$export$5a8da0c44a3afdf2(a2, b2) {
    return $14e0f24ef4ac5c92$export$dbc69fd56b53d5e(a2.calendar, b2.calendar) && $14e0f24ef4ac5c92$export$a18c89cbd24170ff(a2, b2);
  }
  function $14e0f24ef4ac5c92$export$ea840f5a6dda8147(a2, b2) {
    return $14e0f24ef4ac5c92$export$dbc69fd56b53d5e(a2.calendar, b2.calendar) && $14e0f24ef4ac5c92$export$5841f9eb9773f25f(a2, b2);
  }
  function $14e0f24ef4ac5c92$export$dbc69fd56b53d5e(a2, b2) {
    var _a_isEqual, _b_isEqual;
    var _a_isEqual1, _ref;
    return (_ref = (_a_isEqual1 = (_a_isEqual = a2.isEqual) === null || _a_isEqual === void 0 ? void 0 : _a_isEqual.call(a2, b2)) !== null && _a_isEqual1 !== void 0 ? _a_isEqual1 : (_b_isEqual = b2.isEqual) === null || _b_isEqual === void 0 ? void 0 : _b_isEqual.call(b2, a2)) !== null && _ref !== void 0 ? _ref : a2.identifier === b2.identifier;
  }
  function $14e0f24ef4ac5c92$export$629b0a497aa65267(date, timeZone) {
    return $14e0f24ef4ac5c92$export$ea39ec197993aef0(date, $14e0f24ef4ac5c92$export$d0bdf45af03a6ea3(timeZone));
  }
  function $14e0f24ef4ac5c92$export$2061056d06d7cdf7(date, locale, firstDayOfWeek) {
    let julian = date.calendar.toJulianDay(date);
    let weekStart = firstDayOfWeek ? $14e0f24ef4ac5c92$var$DAY_MAP[firstDayOfWeek] : $14e0f24ef4ac5c92$var$getWeekStart(locale);
    let dayOfWeek = Math.ceil(julian + 1 - weekStart) % 7;
    if (dayOfWeek < 0) dayOfWeek += 7;
    return dayOfWeek;
  }
  function $14e0f24ef4ac5c92$export$461939dd4422153(timeZone) {
    return (0, $11d87f3f76e88657$export$1b96692a1ba042ac)(Date.now(), timeZone);
  }
  function $14e0f24ef4ac5c92$export$d0bdf45af03a6ea3(timeZone) {
    return (0, $11d87f3f76e88657$export$93522d1a439f3617)($14e0f24ef4ac5c92$export$461939dd4422153(timeZone));
  }
  function $14e0f24ef4ac5c92$export$68781ddf31c0090f(a2, b2) {
    return a2.calendar.toJulianDay(a2) - b2.calendar.toJulianDay(b2);
  }
  function $14e0f24ef4ac5c92$export$c19a80a9721b80f6(a2, b2) {
    return $14e0f24ef4ac5c92$var$timeToMs(a2) - $14e0f24ef4ac5c92$var$timeToMs(b2);
  }
  function $14e0f24ef4ac5c92$var$timeToMs(a2) {
    return a2.hour * 36e5 + a2.minute * 6e4 + a2.second * 1e3 + a2.millisecond;
  }
  function $14e0f24ef4ac5c92$export$aa8b41735afcabd2() {
    if ($14e0f24ef4ac5c92$var$localTimeZone == null) $14e0f24ef4ac5c92$var$localTimeZone = new Intl.DateTimeFormat().resolvedOptions().timeZone;
    return $14e0f24ef4ac5c92$var$localTimeZone;
  }
  function $14e0f24ef4ac5c92$export$a5a3b454ada2268e(date) {
    return date.subtract({
      days: date.day - 1
    });
  }
  function $14e0f24ef4ac5c92$export$a2258d9c4118825c(date) {
    return date.add({
      days: date.calendar.getDaysInMonth(date) - date.day
    });
  }
  function $14e0f24ef4ac5c92$export$f91e89d3d0406102(date) {
    return $14e0f24ef4ac5c92$export$a5a3b454ada2268e(date.subtract({
      months: date.month - 1
    }));
  }
  function $14e0f24ef4ac5c92$export$8b7aa55c66d5569e(date) {
    return $14e0f24ef4ac5c92$export$a2258d9c4118825c(date.add({
      months: date.calendar.getMonthsInYear(date) - date.month
    }));
  }
  function $14e0f24ef4ac5c92$export$42c81a444fbfb5d4(date, locale, firstDayOfWeek) {
    let dayOfWeek = $14e0f24ef4ac5c92$export$2061056d06d7cdf7(date, locale, firstDayOfWeek);
    return date.subtract({
      days: dayOfWeek
    });
  }
  function $14e0f24ef4ac5c92$export$ef8b6d9133084f4e(date, locale, firstDayOfWeek) {
    return $14e0f24ef4ac5c92$export$42c81a444fbfb5d4(date, locale, firstDayOfWeek).add({
      days: 6
    });
  }
  function $14e0f24ef4ac5c92$var$getRegion(locale) {
    if (Intl.Locale) {
      let region = $14e0f24ef4ac5c92$var$cachedRegions.get(locale);
      if (!region) {
        region = new Intl.Locale(locale).maximize().region;
        if (region) $14e0f24ef4ac5c92$var$cachedRegions.set(locale, region);
      }
      return region;
    }
    let part = locale.split("-")[1];
    return part === "u" ? void 0 : part;
  }
  function $14e0f24ef4ac5c92$var$getWeekStart(locale) {
    let weekInfo = $14e0f24ef4ac5c92$var$cachedWeekInfo.get(locale);
    if (!weekInfo) {
      if (Intl.Locale) {
        let localeInst = new Intl.Locale(locale);
        if ("getWeekInfo" in localeInst) {
          weekInfo = localeInst.getWeekInfo();
          if (weekInfo) {
            $14e0f24ef4ac5c92$var$cachedWeekInfo.set(locale, weekInfo);
            return weekInfo.firstDay;
          }
        }
      }
      let region = $14e0f24ef4ac5c92$var$getRegion(locale);
      if (locale.includes("-fw-")) {
        let day = locale.split("-fw-")[1].split("-")[0];
        if (day === "mon") weekInfo = {
          firstDay: 1
        };
        else if (day === "tue") weekInfo = {
          firstDay: 2
        };
        else if (day === "wed") weekInfo = {
          firstDay: 3
        };
        else if (day === "thu") weekInfo = {
          firstDay: 4
        };
        else if (day === "fri") weekInfo = {
          firstDay: 5
        };
        else if (day === "sat") weekInfo = {
          firstDay: 6
        };
        else weekInfo = {
          firstDay: 0
        };
      } else if (locale.includes("-ca-iso8601")) weekInfo = {
        firstDay: 1
      };
      else weekInfo = {
        firstDay: region ? (0, $2fe286d2fb449abb$export$7a5acbd77d414bd9)[region] || 0 : 0
      };
      $14e0f24ef4ac5c92$var$cachedWeekInfo.set(locale, weekInfo);
    }
    return weekInfo.firstDay;
  }
  function $14e0f24ef4ac5c92$export$ccc1b2479e7dd654(date, locale, firstDayOfWeek) {
    let days = date.calendar.getDaysInMonth(date);
    return Math.ceil(($14e0f24ef4ac5c92$export$2061056d06d7cdf7($14e0f24ef4ac5c92$export$a5a3b454ada2268e(date), locale, firstDayOfWeek) + days) / 7);
  }
  function $14e0f24ef4ac5c92$export$5c333a116e949cdd(a2, b2) {
    if (a2 && b2) return a2.compare(b2) <= 0 ? a2 : b2;
    return a2 || b2;
  }
  function $14e0f24ef4ac5c92$export$a75f2bff57811055(a2, b2) {
    if (a2 && b2) return a2.compare(b2) >= 0 ? a2 : b2;
    return a2 || b2;
  }
  function $14e0f24ef4ac5c92$export$618d60ea299da42(date, locale) {
    let julian = date.calendar.toJulianDay(date);
    let dayOfWeek = Math.ceil(julian + 1) % 7;
    if (dayOfWeek < 0) dayOfWeek += 7;
    let region = $14e0f24ef4ac5c92$var$getRegion(locale);
    let [start, end] = $14e0f24ef4ac5c92$var$WEEKEND_DATA[region] || [
      6,
      0
    ];
    return dayOfWeek === start || dayOfWeek === end;
  }
  function $11d87f3f76e88657$export$bd4fb2bc8bb06fb(date) {
    date = $11d87f3f76e88657$export$b4a036af3fc0b032(date, new (0, $3b62074eb05584b2$export$80ee6245ec4f29ec)());
    let year = (0, $3b62074eb05584b2$export$c36e0ecb2d4fa69d)(date.era, date.year);
    return $11d87f3f76e88657$var$epochFromParts(year, date.month, date.day, date.hour, date.minute, date.second, date.millisecond);
  }
  function $11d87f3f76e88657$var$epochFromParts(year, month, day, hour, minute, second, millisecond) {
    let date = /* @__PURE__ */ new Date();
    date.setUTCHours(hour, minute, second, millisecond);
    date.setUTCFullYear(year, month - 1, day);
    return date.getTime();
  }
  function $11d87f3f76e88657$export$59c99f3515d3493f(ms, timeZone) {
    if (timeZone === "UTC") return 0;
    if (ms > 0 && timeZone === (0, $14e0f24ef4ac5c92$export$aa8b41735afcabd2)()) return new Date(ms).getTimezoneOffset() * -6e4;
    let { year, month, day, hour, minute, second } = $11d87f3f76e88657$var$getTimeZoneParts(ms, timeZone);
    let utc = $11d87f3f76e88657$var$epochFromParts(year, month, day, hour, minute, second, 0);
    return utc - Math.floor(ms / 1e3) * 1e3;
  }
  function $11d87f3f76e88657$var$getTimeZoneParts(ms, timeZone) {
    let formatter = $11d87f3f76e88657$var$formattersByTimeZone.get(timeZone);
    if (!formatter) {
      formatter = new Intl.DateTimeFormat("en-US", {
        timeZone,
        hour12: false,
        era: "short",
        year: "numeric",
        month: "numeric",
        day: "numeric",
        hour: "numeric",
        minute: "numeric",
        second: "numeric"
      });
      $11d87f3f76e88657$var$formattersByTimeZone.set(timeZone, formatter);
    }
    let parts22 = formatter.formatToParts(new Date(ms));
    let namedParts = {};
    for (let part of parts22) if (part.type !== "literal") namedParts[part.type] = part.value;
    return {
      // Firefox returns B instead of BC... https://bugzilla.mozilla.org/show_bug.cgi?id=1752253
      year: namedParts.era === "BC" || namedParts.era === "B" ? -namedParts.year + 1 : +namedParts.year,
      month: +namedParts.month,
      day: +namedParts.day,
      hour: namedParts.hour === "24" ? 0 : +namedParts.hour,
      minute: +namedParts.minute,
      second: +namedParts.second
    };
  }
  function $11d87f3f76e88657$var$getValidWallTimes(date, timeZone, earlier, later) {
    let found = earlier === later ? [
      earlier
    ] : [
      earlier,
      later
    ];
    return found.filter((absolute) => $11d87f3f76e88657$var$isValidWallTime(date, timeZone, absolute));
  }
  function $11d87f3f76e88657$var$isValidWallTime(date, timeZone, absolute) {
    let parts22 = $11d87f3f76e88657$var$getTimeZoneParts(absolute, timeZone);
    return date.year === parts22.year && date.month === parts22.month && date.day === parts22.day && date.hour === parts22.hour && date.minute === parts22.minute && date.second === parts22.second;
  }
  function $11d87f3f76e88657$export$5107c82f94518f5c(date, timeZone, disambiguation = "compatible") {
    let dateTime = $11d87f3f76e88657$export$b21e0b124e224484(date);
    if (timeZone === "UTC") return $11d87f3f76e88657$export$bd4fb2bc8bb06fb(dateTime);
    if (timeZone === (0, $14e0f24ef4ac5c92$export$aa8b41735afcabd2)() && disambiguation === "compatible") {
      dateTime = $11d87f3f76e88657$export$b4a036af3fc0b032(dateTime, new (0, $3b62074eb05584b2$export$80ee6245ec4f29ec)());
      let date2 = /* @__PURE__ */ new Date();
      let year = (0, $3b62074eb05584b2$export$c36e0ecb2d4fa69d)(dateTime.era, dateTime.year);
      date2.setFullYear(year, dateTime.month - 1, dateTime.day);
      date2.setHours(dateTime.hour, dateTime.minute, dateTime.second, dateTime.millisecond);
      return date2.getTime();
    }
    let ms = $11d87f3f76e88657$export$bd4fb2bc8bb06fb(dateTime);
    let offsetBefore = $11d87f3f76e88657$export$59c99f3515d3493f(ms - $11d87f3f76e88657$var$DAYMILLIS, timeZone);
    let offsetAfter = $11d87f3f76e88657$export$59c99f3515d3493f(ms + $11d87f3f76e88657$var$DAYMILLIS, timeZone);
    let valid = $11d87f3f76e88657$var$getValidWallTimes(dateTime, timeZone, ms - offsetBefore, ms - offsetAfter);
    if (valid.length === 1) return valid[0];
    if (valid.length > 1) switch (disambiguation) {
      // 'compatible' means 'earlier' for "fall back" transitions
      case "compatible":
      case "earlier":
        return valid[0];
      case "later":
        return valid[valid.length - 1];
      case "reject":
        throw new RangeError("Multiple possible absolute times found");
    }
    switch (disambiguation) {
      case "earlier":
        return Math.min(ms - offsetBefore, ms - offsetAfter);
      // 'compatible' means 'later' for "spring forward" transitions
      case "compatible":
      case "later":
        return Math.max(ms - offsetBefore, ms - offsetAfter);
      case "reject":
        throw new RangeError("No such absolute time found");
    }
  }
  function $11d87f3f76e88657$export$e67a095c620b86fe(dateTime, timeZone, disambiguation = "compatible") {
    return new Date($11d87f3f76e88657$export$5107c82f94518f5c(dateTime, timeZone, disambiguation));
  }
  function $11d87f3f76e88657$export$1b96692a1ba042ac(ms, timeZone) {
    let offset3 = $11d87f3f76e88657$export$59c99f3515d3493f(ms, timeZone);
    let date = new Date(ms + offset3);
    let year = date.getUTCFullYear();
    let month = date.getUTCMonth() + 1;
    let day = date.getUTCDate();
    let hour = date.getUTCHours();
    let minute = date.getUTCMinutes();
    let second = date.getUTCSeconds();
    let millisecond = date.getUTCMilliseconds();
    return new (0, $35ea8db9cb2ccb90$export$d3b7288e7994edea)(year < 1 ? "BC" : "AD", year < 1 ? -year + 1 : year, month, day, timeZone, offset3, hour, minute, second, millisecond);
  }
  function $11d87f3f76e88657$export$93522d1a439f3617(dateTime) {
    return new (0, $35ea8db9cb2ccb90$export$99faa760c7908e4f)(dateTime.calendar, dateTime.era, dateTime.year, dateTime.month, dateTime.day);
  }
  function $11d87f3f76e88657$export$b21e0b124e224484(date, time) {
    let hour = 0, minute = 0, second = 0, millisecond = 0;
    if ("timeZone" in date) ({ hour, minute, second, millisecond } = date);
    else if ("hour" in date && !time) return date;
    if (time) ({ hour, minute, second, millisecond } = time);
    return new (0, $35ea8db9cb2ccb90$export$ca871e8dbb80966f)(date.calendar, date.era, date.year, date.month, date.day, hour, minute, second, millisecond);
  }
  function $11d87f3f76e88657$export$b4a036af3fc0b032(date, calendar) {
    if ((0, $14e0f24ef4ac5c92$export$dbc69fd56b53d5e)(date.calendar, calendar)) return date;
    let calendarDate = calendar.fromJulianDay(date.calendar.toJulianDay(date));
    let copy = date.copy();
    copy.calendar = calendar;
    copy.era = calendarDate.era;
    copy.year = calendarDate.year;
    copy.month = calendarDate.month;
    copy.day = calendarDate.day;
    (0, $735220c2d4774dd3$export$c4e2ecac49351ef2)(copy);
    return copy;
  }
  function $11d87f3f76e88657$export$84c95a83c799e074(date, timeZone, disambiguation) {
    if (date instanceof (0, $35ea8db9cb2ccb90$export$d3b7288e7994edea)) {
      if (date.timeZone === timeZone) return date;
      return $11d87f3f76e88657$export$538b00033cc11c75(date, timeZone);
    }
    let ms = $11d87f3f76e88657$export$5107c82f94518f5c(date, timeZone, disambiguation);
    return $11d87f3f76e88657$export$1b96692a1ba042ac(ms, timeZone);
  }
  function $11d87f3f76e88657$export$83aac07b4c37b25(date) {
    let ms = $11d87f3f76e88657$export$bd4fb2bc8bb06fb(date) - date.offset;
    return new Date(ms);
  }
  function $11d87f3f76e88657$export$538b00033cc11c75(date, timeZone) {
    let ms = $11d87f3f76e88657$export$bd4fb2bc8bb06fb(date) - date.offset;
    return $11d87f3f76e88657$export$b4a036af3fc0b032($11d87f3f76e88657$export$1b96692a1ba042ac(ms, timeZone), date.calendar);
  }
  function $735220c2d4774dd3$export$e16d8520af44a096(date, duration) {
    let mutableDate = date.copy();
    let days = "hour" in mutableDate ? $735220c2d4774dd3$var$addTimeFields(mutableDate, duration) : 0;
    $735220c2d4774dd3$var$addYears(mutableDate, duration.years || 0);
    if (mutableDate.calendar.balanceYearMonth) mutableDate.calendar.balanceYearMonth(mutableDate, date);
    mutableDate.month += duration.months || 0;
    $735220c2d4774dd3$var$balanceYearMonth(mutableDate);
    $735220c2d4774dd3$var$constrainMonthDay(mutableDate);
    mutableDate.day += (duration.weeks || 0) * 7;
    mutableDate.day += duration.days || 0;
    mutableDate.day += days;
    $735220c2d4774dd3$var$balanceDay(mutableDate);
    if (mutableDate.calendar.balanceDate) mutableDate.calendar.balanceDate(mutableDate);
    if (mutableDate.year < 1) {
      mutableDate.year = 1;
      mutableDate.month = 1;
      mutableDate.day = 1;
    }
    let maxYear = mutableDate.calendar.getYearsInEra(mutableDate);
    if (mutableDate.year > maxYear) {
      var _mutableDate_calendar_isInverseEra, _mutableDate_calendar;
      let isInverseEra = (_mutableDate_calendar_isInverseEra = (_mutableDate_calendar = mutableDate.calendar).isInverseEra) === null || _mutableDate_calendar_isInverseEra === void 0 ? void 0 : _mutableDate_calendar_isInverseEra.call(_mutableDate_calendar, mutableDate);
      mutableDate.year = maxYear;
      mutableDate.month = isInverseEra ? 1 : mutableDate.calendar.getMonthsInYear(mutableDate);
      mutableDate.day = isInverseEra ? 1 : mutableDate.calendar.getDaysInMonth(mutableDate);
    }
    if (mutableDate.month < 1) {
      mutableDate.month = 1;
      mutableDate.day = 1;
    }
    let maxMonth = mutableDate.calendar.getMonthsInYear(mutableDate);
    if (mutableDate.month > maxMonth) {
      mutableDate.month = maxMonth;
      mutableDate.day = mutableDate.calendar.getDaysInMonth(mutableDate);
    }
    mutableDate.day = Math.max(1, Math.min(mutableDate.calendar.getDaysInMonth(mutableDate), mutableDate.day));
    return mutableDate;
  }
  function $735220c2d4774dd3$var$addYears(date, years) {
    var _date_calendar_isInverseEra, _date_calendar;
    if ((_date_calendar_isInverseEra = (_date_calendar = date.calendar).isInverseEra) === null || _date_calendar_isInverseEra === void 0 ? void 0 : _date_calendar_isInverseEra.call(_date_calendar, date)) years = -years;
    date.year += years;
  }
  function $735220c2d4774dd3$var$balanceYearMonth(date) {
    while (date.month < 1) {
      $735220c2d4774dd3$var$addYears(date, -1);
      date.month += date.calendar.getMonthsInYear(date);
    }
    let monthsInYear = 0;
    while (date.month > (monthsInYear = date.calendar.getMonthsInYear(date))) {
      date.month -= monthsInYear;
      $735220c2d4774dd3$var$addYears(date, 1);
    }
  }
  function $735220c2d4774dd3$var$balanceDay(date) {
    while (date.day < 1) {
      date.month--;
      $735220c2d4774dd3$var$balanceYearMonth(date);
      date.day += date.calendar.getDaysInMonth(date);
    }
    while (date.day > date.calendar.getDaysInMonth(date)) {
      date.day -= date.calendar.getDaysInMonth(date);
      date.month++;
      $735220c2d4774dd3$var$balanceYearMonth(date);
    }
  }
  function $735220c2d4774dd3$var$constrainMonthDay(date) {
    date.month = Math.max(1, Math.min(date.calendar.getMonthsInYear(date), date.month));
    date.day = Math.max(1, Math.min(date.calendar.getDaysInMonth(date), date.day));
  }
  function $735220c2d4774dd3$export$c4e2ecac49351ef2(date) {
    if (date.calendar.constrainDate) date.calendar.constrainDate(date);
    date.year = Math.max(1, Math.min(date.calendar.getYearsInEra(date), date.year));
    $735220c2d4774dd3$var$constrainMonthDay(date);
  }
  function $735220c2d4774dd3$export$3e2544e88a25bff8(duration) {
    let inverseDuration = {};
    for (let key in duration) if (typeof duration[key] === "number") inverseDuration[key] = -duration[key];
    return inverseDuration;
  }
  function $735220c2d4774dd3$export$4e2d2ead65e5f7e3(date, duration) {
    return $735220c2d4774dd3$export$e16d8520af44a096(date, $735220c2d4774dd3$export$3e2544e88a25bff8(duration));
  }
  function $735220c2d4774dd3$export$adaa4cf7ef1b65be(date, fields) {
    let mutableDate = date.copy();
    if (fields.era != null) mutableDate.era = fields.era;
    if (fields.year != null) mutableDate.year = fields.year;
    if (fields.month != null) mutableDate.month = fields.month;
    if (fields.day != null) mutableDate.day = fields.day;
    $735220c2d4774dd3$export$c4e2ecac49351ef2(mutableDate);
    return mutableDate;
  }
  function $735220c2d4774dd3$export$e5d5e1c1822b6e56(value, fields) {
    let mutableValue = value.copy();
    if (fields.hour != null) mutableValue.hour = fields.hour;
    if (fields.minute != null) mutableValue.minute = fields.minute;
    if (fields.second != null) mutableValue.second = fields.second;
    if (fields.millisecond != null) mutableValue.millisecond = fields.millisecond;
    $735220c2d4774dd3$export$7555de1e070510cb(mutableValue);
    return mutableValue;
  }
  function $735220c2d4774dd3$var$balanceTime(time) {
    time.second += Math.floor(time.millisecond / 1e3);
    time.millisecond = $735220c2d4774dd3$var$nonNegativeMod(time.millisecond, 1e3);
    time.minute += Math.floor(time.second / 60);
    time.second = $735220c2d4774dd3$var$nonNegativeMod(time.second, 60);
    time.hour += Math.floor(time.minute / 60);
    time.minute = $735220c2d4774dd3$var$nonNegativeMod(time.minute, 60);
    let days = Math.floor(time.hour / 24);
    time.hour = $735220c2d4774dd3$var$nonNegativeMod(time.hour, 24);
    return days;
  }
  function $735220c2d4774dd3$export$7555de1e070510cb(time) {
    time.millisecond = Math.max(0, Math.min(time.millisecond, 1e3));
    time.second = Math.max(0, Math.min(time.second, 59));
    time.minute = Math.max(0, Math.min(time.minute, 59));
    time.hour = Math.max(0, Math.min(time.hour, 23));
  }
  function $735220c2d4774dd3$var$nonNegativeMod(a2, b2) {
    let result = a2 % b2;
    if (result < 0) result += b2;
    return result;
  }
  function $735220c2d4774dd3$var$addTimeFields(time, duration) {
    time.hour += duration.hours || 0;
    time.minute += duration.minutes || 0;
    time.second += duration.seconds || 0;
    time.millisecond += duration.milliseconds || 0;
    return $735220c2d4774dd3$var$balanceTime(time);
  }
  function $735220c2d4774dd3$export$d52ced6badfb9a4c(value, field, amount, options) {
    let mutable = value.copy();
    switch (field) {
      case "era": {
        let eras = value.calendar.getEras();
        let eraIndex = eras.indexOf(value.era);
        if (eraIndex < 0) throw new Error("Invalid era: " + value.era);
        eraIndex = $735220c2d4774dd3$var$cycleValue(eraIndex, amount, 0, eras.length - 1, options === null || options === void 0 ? void 0 : options.round);
        mutable.era = eras[eraIndex];
        $735220c2d4774dd3$export$c4e2ecac49351ef2(mutable);
        break;
      }
      case "year":
        var _mutable_calendar_isInverseEra, _mutable_calendar;
        if ((_mutable_calendar_isInverseEra = (_mutable_calendar = mutable.calendar).isInverseEra) === null || _mutable_calendar_isInverseEra === void 0 ? void 0 : _mutable_calendar_isInverseEra.call(_mutable_calendar, mutable)) amount = -amount;
        mutable.year = $735220c2d4774dd3$var$cycleValue(value.year, amount, -Infinity, 9999, options === null || options === void 0 ? void 0 : options.round);
        if (mutable.year === -Infinity) mutable.year = 1;
        if (mutable.calendar.balanceYearMonth) mutable.calendar.balanceYearMonth(mutable, value);
        break;
      case "month":
        mutable.month = $735220c2d4774dd3$var$cycleValue(value.month, amount, 1, value.calendar.getMonthsInYear(value), options === null || options === void 0 ? void 0 : options.round);
        break;
      case "day":
        mutable.day = $735220c2d4774dd3$var$cycleValue(value.day, amount, 1, value.calendar.getDaysInMonth(value), options === null || options === void 0 ? void 0 : options.round);
        break;
      default:
        throw new Error("Unsupported field " + field);
    }
    if (value.calendar.balanceDate) value.calendar.balanceDate(mutable);
    $735220c2d4774dd3$export$c4e2ecac49351ef2(mutable);
    return mutable;
  }
  function $735220c2d4774dd3$export$dd02b3e0007dfe28(value, field, amount, options) {
    let mutable = value.copy();
    switch (field) {
      case "hour": {
        let hours = value.hour;
        let min4 = 0;
        let max4 = 23;
        if ((options === null || options === void 0 ? void 0 : options.hourCycle) === 12) {
          let isPM = hours >= 12;
          min4 = isPM ? 12 : 0;
          max4 = isPM ? 23 : 11;
        }
        mutable.hour = $735220c2d4774dd3$var$cycleValue(hours, amount, min4, max4, options === null || options === void 0 ? void 0 : options.round);
        break;
      }
      case "minute":
        mutable.minute = $735220c2d4774dd3$var$cycleValue(value.minute, amount, 0, 59, options === null || options === void 0 ? void 0 : options.round);
        break;
      case "second":
        mutable.second = $735220c2d4774dd3$var$cycleValue(value.second, amount, 0, 59, options === null || options === void 0 ? void 0 : options.round);
        break;
      case "millisecond":
        mutable.millisecond = $735220c2d4774dd3$var$cycleValue(value.millisecond, amount, 0, 999, options === null || options === void 0 ? void 0 : options.round);
        break;
      default:
        throw new Error("Unsupported field " + field);
    }
    return mutable;
  }
  function $735220c2d4774dd3$var$cycleValue(value, amount, min4, max4, round3 = false) {
    if (round3) {
      value += Math.sign(amount);
      if (value < min4) value = max4;
      let div = Math.abs(amount);
      if (amount > 0) value = Math.ceil(value / div) * div;
      else value = Math.floor(value / div) * div;
      if (value > max4) value = min4;
    } else {
      value += amount;
      if (value < min4) value = max4 - (min4 - value - 1);
      else if (value > max4) value = min4 + (value - max4 - 1);
    }
    return value;
  }
  function $735220c2d4774dd3$export$96b1d28349274637(dateTime, duration) {
    let ms;
    if (duration.years != null && duration.years !== 0 || duration.months != null && duration.months !== 0 || duration.weeks != null && duration.weeks !== 0 || duration.days != null && duration.days !== 0) {
      let res2 = $735220c2d4774dd3$export$e16d8520af44a096((0, $11d87f3f76e88657$export$b21e0b124e224484)(dateTime), {
        years: duration.years,
        months: duration.months,
        weeks: duration.weeks,
        days: duration.days
      });
      ms = (0, $11d87f3f76e88657$export$5107c82f94518f5c)(res2, dateTime.timeZone);
    } else
      ms = (0, $11d87f3f76e88657$export$bd4fb2bc8bb06fb)(dateTime) - dateTime.offset;
    ms += duration.milliseconds || 0;
    ms += (duration.seconds || 0) * 1e3;
    ms += (duration.minutes || 0) * 6e4;
    ms += (duration.hours || 0) * 36e5;
    let res = (0, $11d87f3f76e88657$export$1b96692a1ba042ac)(ms, dateTime.timeZone);
    return (0, $11d87f3f76e88657$export$b4a036af3fc0b032)(res, dateTime.calendar);
  }
  function $735220c2d4774dd3$export$6814caac34ca03c7(dateTime, duration) {
    return $735220c2d4774dd3$export$96b1d28349274637(dateTime, $735220c2d4774dd3$export$3e2544e88a25bff8(duration));
  }
  function $735220c2d4774dd3$export$9a297d111fc86b79(dateTime, field, amount, options) {
    switch (field) {
      case "hour": {
        let min4 = 0;
        let max4 = 23;
        if ((options === null || options === void 0 ? void 0 : options.hourCycle) === 12) {
          let isPM = dateTime.hour >= 12;
          min4 = isPM ? 12 : 0;
          max4 = isPM ? 23 : 11;
        }
        let plainDateTime = (0, $11d87f3f76e88657$export$b21e0b124e224484)(dateTime);
        let minDate = (0, $11d87f3f76e88657$export$b4a036af3fc0b032)($735220c2d4774dd3$export$e5d5e1c1822b6e56(plainDateTime, {
          hour: min4
        }), new (0, $3b62074eb05584b2$export$80ee6245ec4f29ec)());
        let minAbsolute = [
          (0, $11d87f3f76e88657$export$5107c82f94518f5c)(minDate, dateTime.timeZone, "earlier"),
          (0, $11d87f3f76e88657$export$5107c82f94518f5c)(minDate, dateTime.timeZone, "later")
        ].filter((ms2) => (0, $11d87f3f76e88657$export$1b96692a1ba042ac)(ms2, dateTime.timeZone).day === minDate.day)[0];
        let maxDate = (0, $11d87f3f76e88657$export$b4a036af3fc0b032)($735220c2d4774dd3$export$e5d5e1c1822b6e56(plainDateTime, {
          hour: max4
        }), new (0, $3b62074eb05584b2$export$80ee6245ec4f29ec)());
        let maxAbsolute = [
          (0, $11d87f3f76e88657$export$5107c82f94518f5c)(maxDate, dateTime.timeZone, "earlier"),
          (0, $11d87f3f76e88657$export$5107c82f94518f5c)(maxDate, dateTime.timeZone, "later")
        ].filter((ms2) => (0, $11d87f3f76e88657$export$1b96692a1ba042ac)(ms2, dateTime.timeZone).day === maxDate.day).pop();
        let ms = (0, $11d87f3f76e88657$export$bd4fb2bc8bb06fb)(dateTime) - dateTime.offset;
        let hours = Math.floor(ms / $735220c2d4774dd3$var$ONE_HOUR);
        let remainder = ms % $735220c2d4774dd3$var$ONE_HOUR;
        ms = $735220c2d4774dd3$var$cycleValue(hours, amount, Math.floor(minAbsolute / $735220c2d4774dd3$var$ONE_HOUR), Math.floor(maxAbsolute / $735220c2d4774dd3$var$ONE_HOUR), options === null || options === void 0 ? void 0 : options.round) * $735220c2d4774dd3$var$ONE_HOUR + remainder;
        return (0, $11d87f3f76e88657$export$b4a036af3fc0b032)((0, $11d87f3f76e88657$export$1b96692a1ba042ac)(ms, dateTime.timeZone), dateTime.calendar);
      }
      case "minute":
      case "second":
      case "millisecond":
        return $735220c2d4774dd3$export$dd02b3e0007dfe28(dateTime, field, amount, options);
      case "era":
      case "year":
      case "month":
      case "day": {
        let res = $735220c2d4774dd3$export$d52ced6badfb9a4c((0, $11d87f3f76e88657$export$b21e0b124e224484)(dateTime), field, amount, options);
        let ms = (0, $11d87f3f76e88657$export$5107c82f94518f5c)(res, dateTime.timeZone);
        return (0, $11d87f3f76e88657$export$b4a036af3fc0b032)((0, $11d87f3f76e88657$export$1b96692a1ba042ac)(ms, dateTime.timeZone), dateTime.calendar);
      }
      default:
        throw new Error("Unsupported field " + field);
    }
  }
  function $735220c2d4774dd3$export$31b5430eb18be4f8(dateTime, fields, disambiguation) {
    let plainDateTime = (0, $11d87f3f76e88657$export$b21e0b124e224484)(dateTime);
    let res = $735220c2d4774dd3$export$e5d5e1c1822b6e56($735220c2d4774dd3$export$adaa4cf7ef1b65be(plainDateTime, fields), fields);
    if (res.compare(plainDateTime) === 0) return dateTime;
    let ms = (0, $11d87f3f76e88657$export$5107c82f94518f5c)(res, dateTime.timeZone, disambiguation);
    return (0, $11d87f3f76e88657$export$b4a036af3fc0b032)((0, $11d87f3f76e88657$export$1b96692a1ba042ac)(ms, dateTime.timeZone), dateTime.calendar);
  }
  function $fae977aafc393c5c$export$6b862160d295c8e(value) {
    let m2 = value.match($fae977aafc393c5c$var$DATE_RE);
    if (!m2) {
      if ($fae977aafc393c5c$var$ABSOLUTE_RE.test(value)) throw new Error(`Invalid ISO 8601 date string: ${value}. Use parseAbsolute() instead.`);
      throw new Error("Invalid ISO 8601 date string: " + value);
    }
    let date = new (0, $35ea8db9cb2ccb90$export$99faa760c7908e4f)($fae977aafc393c5c$var$parseNumber(m2[1], 0, 9999), $fae977aafc393c5c$var$parseNumber(m2[2], 1, 12), 1);
    date.day = $fae977aafc393c5c$var$parseNumber(m2[3], 1, date.calendar.getDaysInMonth(date));
    return date;
  }
  function $fae977aafc393c5c$var$parseNumber(value, min4, max4) {
    let val = Number(value);
    if (val < min4 || val > max4) throw new RangeError(`Value out of range: ${min4} <= ${val} <= ${max4}`);
    return val;
  }
  function $fae977aafc393c5c$export$f59dee82248f5ad4(time) {
    return `${String(time.hour).padStart(2, "0")}:${String(time.minute).padStart(2, "0")}:${String(time.second).padStart(2, "0")}${time.millisecond ? String(time.millisecond / 1e3).slice(1) : ""}`;
  }
  function $fae977aafc393c5c$export$60dfd74aa96791bd(date) {
    let gregorianDate = (0, $11d87f3f76e88657$export$b4a036af3fc0b032)(date, new (0, $3b62074eb05584b2$export$80ee6245ec4f29ec)());
    let year;
    if (gregorianDate.era === "BC") year = gregorianDate.year === 1 ? "0000" : "-" + String(Math.abs(1 - gregorianDate.year)).padStart(6, "00");
    else year = String(gregorianDate.year).padStart(4, "0");
    return `${year}-${String(gregorianDate.month).padStart(2, "0")}-${String(gregorianDate.day).padStart(2, "0")}`;
  }
  function $fae977aafc393c5c$export$4223de14708adc63(date) {
    return `${$fae977aafc393c5c$export$60dfd74aa96791bd(date)}T${$fae977aafc393c5c$export$f59dee82248f5ad4(date)}`;
  }
  function $fae977aafc393c5c$var$offsetToString(offset3) {
    let sign3 = Math.sign(offset3) < 0 ? "-" : "+";
    offset3 = Math.abs(offset3);
    let offsetHours = Math.floor(offset3 / 36e5);
    let offsetMinutes = Math.floor(offset3 % 36e5 / 6e4);
    let offsetSeconds = Math.floor(offset3 % 36e5 % 6e4 / 1e3);
    let stringOffset = `${sign3}${String(offsetHours).padStart(2, "0")}:${String(offsetMinutes).padStart(2, "0")}`;
    if (offsetSeconds !== 0) stringOffset += `:${String(offsetSeconds).padStart(2, "0")}`;
    return stringOffset;
  }
  function $fae977aafc393c5c$export$bf79f1ebf4b18792(date) {
    return `${$fae977aafc393c5c$export$4223de14708adc63(date)}${$fae977aafc393c5c$var$offsetToString(date.offset)}[${date.timeZone}]`;
  }
  function _check_private_redeclaration(obj, privateCollection) {
    if (privateCollection.has(obj)) {
      throw new TypeError("Cannot initialize the same private elements twice on an object");
    }
  }
  function _class_private_field_init(obj, privateMap, value) {
    _check_private_redeclaration(obj, privateMap);
    privateMap.set(obj, value);
  }
  function $35ea8db9cb2ccb90$var$shiftArgs(args) {
    let calendar = typeof args[0] === "object" ? args.shift() : new (0, $3b62074eb05584b2$export$80ee6245ec4f29ec)();
    let era;
    if (typeof args[0] === "string") era = args.shift();
    else {
      let eras = calendar.getEras();
      era = eras[eras.length - 1];
    }
    let year = args.shift();
    let month = args.shift();
    let day = args.shift();
    return [
      calendar,
      era,
      year,
      month,
      day
    ];
  }
  function $fb18d541ea1ad717$var$getCachedDateFormatter(locale, options = {}) {
    if (typeof options.hour12 === "boolean" && $fb18d541ea1ad717$var$hasBuggyHour12Behavior()) {
      options = __spreadValues({}, options);
      let pref = $fb18d541ea1ad717$var$hour12Preferences[String(options.hour12)][locale.split("-")[0]];
      let defaultHourCycle = options.hour12 ? "h12" : "h23";
      options.hourCycle = pref !== null && pref !== void 0 ? pref : defaultHourCycle;
      delete options.hour12;
    }
    let cacheKey = locale + (options ? Object.entries(options).sort((a2, b2) => a2[0] < b2[0] ? -1 : 1).join() : "");
    if ($fb18d541ea1ad717$var$formatterCache.has(cacheKey)) return $fb18d541ea1ad717$var$formatterCache.get(cacheKey);
    let numberFormatter = new Intl.DateTimeFormat(locale, options);
    $fb18d541ea1ad717$var$formatterCache.set(cacheKey, numberFormatter);
    return numberFormatter;
  }
  function $fb18d541ea1ad717$var$hasBuggyHour12Behavior() {
    if ($fb18d541ea1ad717$var$_hasBuggyHour12Behavior == null) $fb18d541ea1ad717$var$_hasBuggyHour12Behavior = new Intl.DateTimeFormat("en-US", {
      hour: "numeric",
      hour12: false
    }).format(new Date(2020, 2, 3, 0)) === "24";
    return $fb18d541ea1ad717$var$_hasBuggyHour12Behavior;
  }
  function $fb18d541ea1ad717$var$hasBuggyResolvedHourCycle() {
    if ($fb18d541ea1ad717$var$_hasBuggyResolvedHourCycle == null) $fb18d541ea1ad717$var$_hasBuggyResolvedHourCycle = new Intl.DateTimeFormat("fr", {
      hour: "numeric",
      hour12: false
    }).resolvedOptions().hourCycle === "h12";
    return $fb18d541ea1ad717$var$_hasBuggyResolvedHourCycle;
  }
  function $fb18d541ea1ad717$var$getResolvedHourCycle(locale, options) {
    if (!options.timeStyle && !options.hour) return void 0;
    locale = locale.replace(/(-u-)?-nu-[a-zA-Z0-9]+/, "");
    locale += (locale.includes("-u-") ? "" : "-u") + "-nu-latn";
    let formatter = $fb18d541ea1ad717$var$getCachedDateFormatter(locale, __spreadProps(__spreadValues({}, options), {
      timeZone: void 0
      // use local timezone
    }));
    let min4 = parseInt(formatter.formatToParts(new Date(2020, 2, 3, 0)).find((p2) => p2.type === "hour").value, 10);
    let max4 = parseInt(formatter.formatToParts(new Date(2020, 2, 3, 23)).find((p2) => p2.type === "hour").value, 10);
    if (min4 === 0 && max4 === 23) return "h23";
    if (min4 === 24 && max4 === 23) return "h24";
    if (min4 === 0 && max4 === 11) return "h11";
    if (min4 === 12 && max4 === 11) return "h12";
    throw new Error("Unexpected hour cycle result");
  }
  function alignCenter(date, duration, locale, min4, max4) {
    const halfDuration = {};
    for (let prop in duration) {
      const key = prop;
      const value = duration[key];
      if (value == null) continue;
      halfDuration[key] = Math.floor(value / 2);
      if (halfDuration[key] > 0 && value % 2 === 0) {
        halfDuration[key]--;
      }
    }
    const aligned = alignStart(date, duration, locale).subtract(halfDuration);
    return constrainStart(date, aligned, duration, locale, min4, max4);
  }
  function alignStart(date, duration, locale, min4, max4) {
    let aligned = date;
    if (duration.years) {
      aligned = $14e0f24ef4ac5c92$export$f91e89d3d0406102(date);
    } else if (duration.months) {
      aligned = $14e0f24ef4ac5c92$export$a5a3b454ada2268e(date);
    } else if (duration.weeks) {
      aligned = $14e0f24ef4ac5c92$export$42c81a444fbfb5d4(date, locale);
    }
    return constrainStart(date, aligned, duration, locale, min4, max4);
  }
  function alignEnd(date, duration, locale, min4, max4) {
    let d2 = __spreadValues({}, duration);
    if (d2.days) {
      d2.days--;
    } else if (d2.weeks) {
      d2.weeks--;
    } else if (d2.months) {
      d2.months--;
    } else if (d2.years) {
      d2.years--;
    }
    let aligned = alignStart(date, duration, locale).subtract(d2);
    return constrainStart(date, aligned, duration, locale, min4, max4);
  }
  function constrainStart(date, aligned, duration, locale, min4, max4) {
    if (min4 && date.compare(min4) >= 0) {
      aligned = $14e0f24ef4ac5c92$export$a75f2bff57811055(aligned, alignStart($11d87f3f76e88657$export$93522d1a439f3617(min4), duration, locale));
    }
    if (max4 && date.compare(max4) <= 0) {
      aligned = $14e0f24ef4ac5c92$export$5c333a116e949cdd(aligned, alignEnd($11d87f3f76e88657$export$93522d1a439f3617(max4), duration, locale));
    }
    return aligned;
  }
  function constrainValue(date, minValue, maxValue) {
    let constrainedDate = $11d87f3f76e88657$export$93522d1a439f3617(date);
    if (minValue) {
      constrainedDate = $14e0f24ef4ac5c92$export$a75f2bff57811055(constrainedDate, $11d87f3f76e88657$export$93522d1a439f3617(minValue));
    }
    if (maxValue) {
      constrainedDate = $14e0f24ef4ac5c92$export$5c333a116e949cdd(constrainedDate, $11d87f3f76e88657$export$93522d1a439f3617(maxValue));
    }
    return constrainedDate;
  }
  function alignDate(date, alignment, duration, locale, min4, max4) {
    switch (alignment) {
      case "start":
        return alignStart(date, duration, locale, min4, max4);
      case "end":
        return alignEnd(date, duration, locale, min4, max4);
      case "center":
      default:
        return alignCenter(date, duration, locale, min4, max4);
    }
  }
  function isDateEqual(dateA, dateB) {
    if (dateA == null || dateB == null) return dateA === dateB;
    return $14e0f24ef4ac5c92$export$ea39ec197993aef0(dateA, dateB);
  }
  function isDateUnavailable(date, isUnavailable, locale, minValue, maxValue) {
    if (!date) return false;
    if (isUnavailable == null ? void 0 : isUnavailable(date, locale)) return true;
    return isDateOutsideRange(date, minValue, maxValue);
  }
  function isDateOutsideRange(date, startDate, endDate) {
    return startDate != null && date.compare(startDate) < 0 || endDate != null && date.compare(endDate) > 0;
  }
  function isPreviousRangeInvalid(startDate, minValue, maxValue) {
    const prevDate = startDate.subtract({ days: 1 });
    return $14e0f24ef4ac5c92$export$ea39ec197993aef0(prevDate, startDate) || isDateOutsideRange(prevDate, minValue, maxValue);
  }
  function isNextRangeInvalid(endDate, minValue, maxValue) {
    const nextDate = endDate.add({ days: 1 });
    return $14e0f24ef4ac5c92$export$ea39ec197993aef0(nextDate, endDate) || isDateOutsideRange(nextDate, minValue, maxValue);
  }
  function getUnitDuration(duration) {
    let clone = __spreadValues({}, duration);
    for (let key in clone) clone[key] = 1;
    return clone;
  }
  function getEndDate(startDate, duration) {
    let clone = __spreadValues({}, duration);
    if (clone.days) clone.days--;
    else clone.days = -1;
    return startDate.add(clone);
  }
  function getEraFormat(date) {
    return (date == null ? void 0 : date.calendar.identifier) === "gregory" && date.era === "BC" ? "short" : void 0;
  }
  function getDayFormatter(locale, timeZone) {
    const date = $11d87f3f76e88657$export$b21e0b124e224484($14e0f24ef4ac5c92$export$d0bdf45af03a6ea3(timeZone));
    return new $fb18d541ea1ad717$export$ad991b66133851cf(locale, {
      weekday: "long",
      month: "long",
      year: "numeric",
      day: "numeric",
      era: getEraFormat(date),
      timeZone
    });
  }
  function getMonthFormatter(locale, timeZone) {
    const date = $14e0f24ef4ac5c92$export$d0bdf45af03a6ea3(timeZone);
    return new $fb18d541ea1ad717$export$ad991b66133851cf(locale, {
      month: "long",
      year: "numeric",
      era: getEraFormat(date),
      calendar: date == null ? void 0 : date.calendar.identifier,
      timeZone
    });
  }
  function formatRange(startDate, endDate, formatter, toString, timeZone) {
    let parts22 = formatter.formatRangeToParts(startDate.toDate(timeZone), endDate.toDate(timeZone));
    let separatorIndex = -1;
    for (let i2 = 0; i2 < parts22.length; i2++) {
      let part = parts22[i2];
      if (part.source === "shared" && part.type === "literal") {
        separatorIndex = i2;
      } else if (part.source === "endRange") {
        break;
      }
    }
    let start = "";
    let end = "";
    for (let i2 = 0; i2 < parts22.length; i2++) {
      if (i2 < separatorIndex) {
        start += parts22[i2].value;
      } else if (i2 > separatorIndex) {
        end += parts22[i2].value;
      }
    }
    return toString(start, end);
  }
  function formatSelectedDate(startDate, endDate, locale, timeZone) {
    if (!startDate) return "";
    let start = startDate;
    let end = endDate != null ? endDate : startDate;
    let formatter = getDayFormatter(locale, timeZone);
    if ($14e0f24ef4ac5c92$export$ea39ec197993aef0(start, end)) {
      return formatter.format(start.toDate(timeZone));
    }
    return formatRange(start, end, formatter, (start2, end2) => `${start2} \u2013 ${end2}`, timeZone);
  }
  function normalizeFirstDayOfWeek(firstDayOfWeek) {
    return firstDayOfWeek != null ? daysOfTheWeek[firstDayOfWeek] : void 0;
  }
  function getStartOfWeek(date, locale, firstDayOfWeek) {
    const firstDay = normalizeFirstDayOfWeek(firstDayOfWeek);
    return $14e0f24ef4ac5c92$export$42c81a444fbfb5d4(date, locale, firstDay);
  }
  function getDaysInWeek(weekIndex, from, locale, firstDayOfWeek) {
    const weekDate = from.add({ weeks: weekIndex });
    const dates = [];
    let date = getStartOfWeek(weekDate, locale, firstDayOfWeek);
    while (dates.length < 7) {
      dates.push(date);
      let nextDate = date.add({ days: 1 });
      if ($14e0f24ef4ac5c92$export$ea39ec197993aef0(date, nextDate)) break;
      date = nextDate;
    }
    return dates;
  }
  function getMonthDays(from, locale, numOfWeeks, firstDayOfWeek) {
    const firstDay = normalizeFirstDayOfWeek(firstDayOfWeek);
    const monthWeeks = numOfWeeks != null ? numOfWeeks : $14e0f24ef4ac5c92$export$ccc1b2479e7dd654(from, locale, firstDay);
    const weeks = [...new Array(monthWeeks).keys()];
    return weeks.map((week) => getDaysInWeek(week, from, locale, firstDayOfWeek));
  }
  function getWeekdayFormats(locale, timeZone) {
    const longFormat = new $fb18d541ea1ad717$export$ad991b66133851cf(locale, { weekday: "long", timeZone });
    const shortFormat = new $fb18d541ea1ad717$export$ad991b66133851cf(locale, { weekday: "short", timeZone });
    const narrowFormat = new $fb18d541ea1ad717$export$ad991b66133851cf(locale, { weekday: "narrow", timeZone });
    return (value) => {
      const date = value instanceof Date ? value : value.toDate(timeZone);
      return {
        value,
        short: shortFormat.format(date),
        long: longFormat.format(date),
        narrow: narrowFormat.format(date)
      };
    };
  }
  function getWeekDays(date, startOfWeekProp, timeZone, locale) {
    const firstDayOfWeek = getStartOfWeek(date, locale, startOfWeekProp);
    const weeks = [...new Array(7).keys()];
    const format = getWeekdayFormats(locale, timeZone);
    return weeks.map((index) => format(firstDayOfWeek.add({ days: index })));
  }
  function getMonthNames(locale, format = "long") {
    const date = new Date(2021, 0, 1);
    const monthNames = [];
    for (let i2 = 0; i2 < 12; i2++) {
      monthNames.push(date.toLocaleString(locale, { month: format }));
      date.setMonth(date.getMonth() + 1);
    }
    return monthNames;
  }
  function getYearsRange(range) {
    const years = [];
    for (let year = range.from; year <= range.to; year += 1) years.push(year);
    return years;
  }
  function normalizeYear(year) {
    if (!year) return;
    if (year.length === 3) return year.padEnd(4, "0");
    if (year.length === 2) {
      const currentYear = (/* @__PURE__ */ new Date()).getFullYear();
      const currentCentury = Math.floor(currentYear / 100) * 100;
      const twoDigitYear = parseInt(year.slice(-2), 10);
      const fullYear = currentCentury + twoDigitYear;
      return fullYear > currentYear + FUTURE_YEAR_COERCION ? (fullYear - 100).toString() : fullYear.toString();
    }
    return year;
  }
  function getDecadeRange(year, opts) {
    const chunkSize = (opts == null ? void 0 : opts.strict) ? 10 : 12;
    const computedYear = year - year % 10;
    const years = [];
    for (let i2 = 0; i2 < chunkSize; i2 += 1) {
      const value = computedYear + i2;
      years.push(value);
    }
    return years;
  }
  function getTodayDate(timeZone) {
    return $14e0f24ef4ac5c92$export$d0bdf45af03a6ea3(timeZone != null ? timeZone : $14e0f24ef4ac5c92$export$aa8b41735afcabd2());
  }
  function getAdjustedDateFn(visibleDuration, locale, minValue, maxValue) {
    return function getDate(options) {
      const { startDate, focusedDate } = options;
      const endDate = getEndDate(startDate, visibleDuration);
      if (isDateOutsideRange(focusedDate, minValue, maxValue)) {
        return {
          startDate,
          focusedDate: constrainValue(focusedDate, minValue, maxValue),
          endDate
        };
      }
      if (focusedDate.compare(startDate) < 0) {
        return {
          startDate: alignEnd(focusedDate, visibleDuration, locale, minValue, maxValue),
          focusedDate: constrainValue(focusedDate, minValue, maxValue),
          endDate
        };
      }
      if (focusedDate.compare(endDate) > 0) {
        return {
          startDate: alignStart(focusedDate, visibleDuration, locale, minValue, maxValue),
          endDate,
          focusedDate: constrainValue(focusedDate, minValue, maxValue)
        };
      }
      return {
        startDate,
        endDate,
        focusedDate: constrainValue(focusedDate, minValue, maxValue)
      };
    };
  }
  function getNextPage(focusedDate, startDate, visibleDuration, locale, minValue, maxValue) {
    const adjust = getAdjustedDateFn(visibleDuration, locale, minValue, maxValue);
    const start = startDate.add(visibleDuration);
    return adjust({
      focusedDate: focusedDate.add(visibleDuration),
      startDate: alignStart(
        constrainStart(focusedDate, start, visibleDuration, locale, minValue, maxValue),
        visibleDuration,
        locale
      )
    });
  }
  function getPreviousPage(focusedDate, startDate, visibleDuration, locale, minValue, maxValue) {
    const adjust = getAdjustedDateFn(visibleDuration, locale, minValue, maxValue);
    let start = startDate.subtract(visibleDuration);
    return adjust({
      focusedDate: focusedDate.subtract(visibleDuration),
      startDate: alignStart(
        constrainStart(focusedDate, start, visibleDuration, locale, minValue, maxValue),
        visibleDuration,
        locale
      )
    });
  }
  function getNextSection(focusedDate, startDate, larger, visibleDuration, locale, minValue, maxValue) {
    const adjust = getAdjustedDateFn(visibleDuration, locale, minValue, maxValue);
    if (!larger && !visibleDuration.days) {
      return adjust({
        focusedDate: focusedDate.add(getUnitDuration(visibleDuration)),
        startDate
      });
    }
    if (visibleDuration.days) {
      return getNextPage(focusedDate, startDate, visibleDuration, locale, minValue, maxValue);
    }
    if (visibleDuration.weeks) {
      return adjust({
        focusedDate: focusedDate.add({ months: 1 }),
        startDate
      });
    }
    if (visibleDuration.months || visibleDuration.years) {
      return adjust({
        focusedDate: focusedDate.add({ years: 1 }),
        startDate
      });
    }
  }
  function getPreviousSection(focusedDate, startDate, larger, visibleDuration, locale, minValue, maxValue) {
    const adjust = getAdjustedDateFn(visibleDuration, locale, minValue, maxValue);
    if (!larger && !visibleDuration.days) {
      return adjust({
        focusedDate: focusedDate.subtract(getUnitDuration(visibleDuration)),
        startDate
      });
    }
    if (visibleDuration.days) {
      return getPreviousPage(focusedDate, startDate, visibleDuration, locale, minValue, maxValue);
    }
    if (visibleDuration.weeks) {
      return adjust({
        focusedDate: focusedDate.subtract({ months: 1 }),
        startDate
      });
    }
    if (visibleDuration.months || visibleDuration.years) {
      return adjust({
        focusedDate: focusedDate.subtract({ years: 1 }),
        startDate
      });
    }
  }
  function parseDateString(date, locale, timeZone) {
    var _a;
    const regex = createRegex(locale, timeZone);
    let { year, month, day } = (_a = extract(regex, date)) != null ? _a : {};
    const hasMatch = year != null || month != null || day != null;
    if (hasMatch) {
      const curr = /* @__PURE__ */ new Date();
      year || (year = curr.getFullYear().toString());
      month || (month = (curr.getMonth() + 1).toString());
      day || (day = curr.getDate().toString());
    }
    if (!isValidYear(year)) {
      year = normalizeYear(year);
    }
    if (isValidYear(year) && isValidMonth(month) && isValidDay(day)) {
      return new $35ea8db9cb2ccb90$export$99faa760c7908e4f(+year, +month, +day);
    }
    const time = Date.parse(date);
    if (!isNaN(time)) {
      const date2 = new Date(time);
      return new $35ea8db9cb2ccb90$export$99faa760c7908e4f(date2.getFullYear(), date2.getMonth() + 1, date2.getDate());
    }
  }
  function createRegex(locale, timeZone) {
    const formatter = new $fb18d541ea1ad717$export$ad991b66133851cf(locale, { day: "numeric", month: "numeric", year: "numeric", timeZone });
    const parts22 = formatter.formatToParts(new Date(2e3, 11, 25));
    return parts22.map(({ type, value }) => type === "literal" ? `${value}?` : `((?!=<${type}>)\\d+)?`).join("");
  }
  function extract(pattern, str) {
    var _a;
    const matches = str.match(pattern);
    return (_a = pattern.toString().match(/<(.+?)>/g)) == null ? void 0 : _a.map((group2) => {
      var _a2;
      const groupMatches = group2.match(/<(.+)>/);
      if (!groupMatches || groupMatches.length <= 0) {
        return null;
      }
      return (_a2 = group2.match(/<(.+)>/)) == null ? void 0 : _a2[1];
    }).reduce((acc, curr, index) => {
      if (!curr) return acc;
      if (matches && matches.length > index) {
        acc[curr] = matches[index + 1];
      } else {
        acc[curr] = null;
      }
      return acc;
    }, {});
  }
  function getDateRangePreset(preset, locale, timeZone) {
    const today3 = $11d87f3f76e88657$export$93522d1a439f3617($14e0f24ef4ac5c92$export$461939dd4422153(timeZone));
    switch (preset) {
      case "thisWeek":
        return [$14e0f24ef4ac5c92$export$42c81a444fbfb5d4(today3, locale), $14e0f24ef4ac5c92$export$ef8b6d9133084f4e(today3, locale)];
      case "thisMonth":
        return [$14e0f24ef4ac5c92$export$a5a3b454ada2268e(today3), today3];
      case "thisQuarter":
        return [$14e0f24ef4ac5c92$export$a5a3b454ada2268e(today3).add({ months: -((today3.month - 1) % 3) }), today3];
      case "thisYear":
        return [$14e0f24ef4ac5c92$export$f91e89d3d0406102(today3), today3];
      case "last3Days":
        return [today3.add({ days: -2 }), today3];
      case "last7Days":
        return [today3.add({ days: -6 }), today3];
      case "last14Days":
        return [today3.add({ days: -13 }), today3];
      case "last30Days":
        return [today3.add({ days: -29 }), today3];
      case "last90Days":
        return [today3.add({ days: -89 }), today3];
      case "lastMonth":
        return [$14e0f24ef4ac5c92$export$a5a3b454ada2268e(today3.add({ months: -1 })), $14e0f24ef4ac5c92$export$a2258d9c4118825c(today3.add({ months: -1 }))];
      case "lastQuarter":
        return [
          $14e0f24ef4ac5c92$export$a5a3b454ada2268e(today3.add({ months: -((today3.month - 1) % 3) - 3 })),
          $14e0f24ef4ac5c92$export$a2258d9c4118825c(today3.add({ months: -((today3.month - 1) % 3) - 1 }))
        ];
      case "lastWeek":
        return [$14e0f24ef4ac5c92$export$42c81a444fbfb5d4(today3, locale).add({ weeks: -1 }), $14e0f24ef4ac5c92$export$ef8b6d9133084f4e(today3, locale).add({ weeks: -1 })];
      case "lastYear":
        return [$14e0f24ef4ac5c92$export$f91e89d3d0406102(today3.add({ years: -1 })), $14e0f24ef4ac5c92$export$8b7aa55c66d5569e(today3.add({ years: -1 }))];
      default:
        throw new Error(`Invalid date range preset: ${preset}`);
    }
  }
  function createLiveRegion(opts = {}) {
    var _a;
    const { level = "polite", document: doc = document, root, delay: _delay = 0 } = opts;
    const win = (_a = doc.defaultView) != null ? _a : window;
    const parent = root != null ? root : doc.body;
    function announce(message, delay2) {
      const oldRegion = doc.getElementById(ID);
      oldRegion == null ? void 0 : oldRegion.remove();
      delay2 = delay2 != null ? delay2 : _delay;
      const region = doc.createElement("span");
      region.id = ID;
      region.dataset.liveAnnouncer = "true";
      const role = level !== "assertive" ? "status" : "alert";
      region.setAttribute("aria-live", level);
      region.setAttribute("role", role);
      Object.assign(region.style, {
        border: "0",
        clip: "rect(0 0 0 0)",
        height: "1px",
        margin: "-1px",
        overflow: "hidden",
        padding: "0",
        position: "absolute",
        width: "1px",
        whiteSpace: "nowrap",
        wordWrap: "normal"
      });
      parent.appendChild(region);
      win.setTimeout(() => {
        region.textContent = message;
      }, delay2);
    }
    function destroy() {
      const oldRegion = doc.getElementById(ID);
      oldRegion == null ? void 0 : oldRegion.remove();
    }
    return {
      announce,
      destroy,
      toJSON() {
        return ID;
      }
    };
  }
  function adjustStartAndEndDate(value) {
    const [startDate, endDate] = value;
    let result;
    if (!startDate || !endDate) result = value;
    else result = startDate.compare(endDate) <= 0 ? value : [endDate, startDate];
    return result;
  }
  function isDateWithinRange(date, value) {
    const [startDate, endDate] = value;
    if (!startDate || !endDate) return false;
    return startDate.compare(date) <= 0 && endDate.compare(date) >= 0;
  }
  function sortDates(values) {
    return values.slice().filter((date) => date != null).sort((a2, b2) => a2.compare(b2));
  }
  function getRoleDescription(view) {
    return match2(view, {
      year: "calendar decade",
      month: "calendar year",
      day: "calendar month"
    });
  }
  function getInputPlaceholder(locale) {
    return new $fb18d541ea1ad717$export$ad991b66133851cf(locale).formatToParts(/* @__PURE__ */ new Date()).map((item) => {
      var _a;
      return (_a = PLACEHOLDERS[item.type]) != null ? _a : item.value;
    }).join("");
  }
  function getLocaleSeparator(locale) {
    const dateFormatter = new Intl.DateTimeFormat(locale);
    const parts22 = dateFormatter.formatToParts(/* @__PURE__ */ new Date());
    const literalPart = parts22.find((part) => part.type === "literal");
    return literalPart ? literalPart.value : "/";
  }
  function viewToNumber(view, fallback2) {
    if (!view) return fallback2 || 0;
    return view === "day" ? 0 : view === "month" ? 1 : 2;
  }
  function viewNumberToView(viewNumber) {
    return viewNumber === 0 ? "day" : viewNumber === 1 ? "month" : "year";
  }
  function clampView(view, minView, maxView) {
    return viewNumberToView(
      clampValue(viewToNumber(view, 0), viewToNumber(minView, 0), viewToNumber(maxView, 2))
    );
  }
  function isAboveMinView(view, minView) {
    return viewToNumber(view, 0) > viewToNumber(minView, 0);
  }
  function isBelowMinView(view, minView) {
    return viewToNumber(view, 0) < viewToNumber(minView, 0);
  }
  function getNextView(view, minView, maxView) {
    const nextViewNumber = viewToNumber(view, 0) + 1;
    return clampView(viewNumberToView(nextViewNumber), minView, maxView);
  }
  function getPreviousView(view, minView, maxView) {
    const prevViewNumber = viewToNumber(view, 0) - 1;
    return clampView(viewNumberToView(prevViewNumber), minView, maxView);
  }
  function eachView(cb) {
    views.forEach((view) => cb(view));
  }
  function connect6(service, normalize) {
    const { state: state2, context, prop, send, computed, scope } = service;
    const startValue = context.get("startValue");
    const endValue = computed("endValue");
    const selectedValue = context.get("value");
    const focusedValue = context.get("focusedValue");
    const hoveredValue = context.get("hoveredValue");
    const hoveredRangeValue = hoveredValue ? adjustStartAndEndDate([selectedValue[0], hoveredValue]) : [];
    const disabled = Boolean(prop("disabled"));
    const readOnly = Boolean(prop("readOnly"));
    const invalid = Boolean(prop("invalid"));
    const interactive = computed("isInteractive");
    const empty = selectedValue.length === 0;
    const min4 = prop("min");
    const max4 = prop("max");
    const locale = prop("locale");
    const timeZone = prop("timeZone");
    const startOfWeek = prop("startOfWeek");
    const focused = state2.matches("focused");
    const open = state2.matches("open");
    const isRangePicker = prop("selectionMode") === "range";
    const isDateUnavailableFn = prop("isDateUnavailable");
    const currentPlacement = context.get("currentPlacement");
    const popperStyles = getPlacementStyles(__spreadProps(__spreadValues({}, prop("positioning")), {
      placement: currentPlacement
    }));
    const separator = getLocaleSeparator(locale);
    const translations = __spreadValues(__spreadValues({}, defaultTranslations), prop("translations"));
    function getMonthWeeks(from = startValue) {
      const numOfWeeks = prop("fixedWeeks") ? 6 : void 0;
      return getMonthDays(from, locale, numOfWeeks, startOfWeek);
    }
    function getMonths(props22 = {}) {
      const { format } = props22;
      return getMonthNames(locale, format).map((label, index) => {
        const value = index + 1;
        const dateValue = focusedValue.set({ month: value });
        const disabled2 = isDateOutsideRange(dateValue, min4, max4);
        return { label, value, disabled: disabled2 };
      });
    }
    function getYears() {
      var _a, _b;
      const range = getYearsRange({ from: (_a = min4 == null ? void 0 : min4.year) != null ? _a : 1900, to: (_b = max4 == null ? void 0 : max4.year) != null ? _b : 2100 });
      return range.map((year) => ({
        label: year.toString(),
        value: year,
        disabled: !isValueWithinRange(year, min4 == null ? void 0 : min4.year, max4 == null ? void 0 : max4.year)
      }));
    }
    function isUnavailable(date) {
      return isDateUnavailable(date, isDateUnavailableFn, locale, min4, max4);
    }
    function focusMonth(month) {
      const date = startValue != null ? startValue : getTodayDate(timeZone);
      send({ type: "FOCUS.SET", value: date.set({ month }) });
    }
    function focusYear(year) {
      const date = startValue != null ? startValue : getTodayDate(timeZone);
      send({ type: "FOCUS.SET", value: date.set({ year }) });
    }
    function getYearTableCellState(props22) {
      const { value, disabled: disabled2 } = props22;
      const dateValue = focusedValue.set({ year: value });
      const decadeYears = getDecadeRange(startValue.year, { strict: true });
      const isOutsideVisibleRange = !decadeYears.includes(value);
      const isOutsideRange = isValueWithinRange(value, min4 == null ? void 0 : min4.year, max4 == null ? void 0 : max4.year);
      const cellState = {
        focused: focusedValue.year === props22.value,
        selectable: isOutsideVisibleRange || isOutsideRange,
        outsideRange: isOutsideVisibleRange,
        selected: !!selectedValue.find((date) => date && date.year === value),
        valueText: value.toString(),
        inRange: isRangePicker && (isDateWithinRange(dateValue, selectedValue) || isDateWithinRange(dateValue, hoveredRangeValue)),
        value: dateValue,
        get disabled() {
          return disabled2 || !cellState.selectable;
        }
      };
      return cellState;
    }
    function getMonthTableCellState(props22) {
      const { value, disabled: disabled2 } = props22;
      const dateValue = focusedValue.set({ month: value });
      const formatter = getMonthFormatter(locale, timeZone);
      const cellState = {
        focused: focusedValue.month === props22.value,
        selectable: !isDateOutsideRange(dateValue, min4, max4),
        selected: !!selectedValue.find((date) => date && date.month === value && date.year === focusedValue.year),
        valueText: formatter.format(dateValue.toDate(timeZone)),
        inRange: isRangePicker && (isDateWithinRange(dateValue, selectedValue) || isDateWithinRange(dateValue, hoveredRangeValue)),
        value: dateValue,
        get disabled() {
          return disabled2 || !cellState.selectable;
        }
      };
      return cellState;
    }
    function getDayTableCellState(props22) {
      const { value, disabled: disabled2, visibleRange = computed("visibleRange") } = props22;
      const formatter = getDayFormatter(locale, timeZone);
      const unitDuration = getUnitDuration(computed("visibleDuration"));
      const outsideDaySelectable = prop("outsideDaySelectable");
      const end = visibleRange.start.add(unitDuration).subtract({ days: 1 });
      const isOutsideRange = isDateOutsideRange(value, visibleRange.start, end);
      const isInSelectedRange = isRangePicker && isDateWithinRange(value, selectedValue);
      const isFirstInSelectedRange = isRangePicker && isDateEqual(value, selectedValue[0]);
      const isLastInSelectedRange = isRangePicker && isDateEqual(value, selectedValue[1]);
      const hasHoveredRange = isRangePicker && hoveredRangeValue.length > 0;
      const isInHoveredRange = hasHoveredRange && isDateWithinRange(value, hoveredRangeValue);
      const isFirstInHoveredRange = hasHoveredRange && isDateEqual(value, hoveredRangeValue[0]);
      const isLastInHoveredRange = hasHoveredRange && isDateEqual(value, hoveredRangeValue[1]);
      const cellState = {
        invalid: isDateOutsideRange(value, min4, max4),
        disabled: disabled2 || !outsideDaySelectable && isOutsideRange || isDateOutsideRange(value, min4, max4),
        selected: selectedValue.some((date) => isDateEqual(value, date)),
        unavailable: isDateUnavailable(value, isDateUnavailableFn, locale, min4, max4) && !disabled2,
        outsideRange: isOutsideRange,
        today: $14e0f24ef4ac5c92$export$629b0a497aa65267(value, timeZone),
        weekend: $14e0f24ef4ac5c92$export$618d60ea299da42(value, locale),
        formattedDate: formatter.format(value.toDate(timeZone)),
        get focused() {
          return isDateEqual(value, focusedValue) && (!cellState.outsideRange || outsideDaySelectable);
        },
        get ariaLabel() {
          return translations.dayCell(cellState);
        },
        get selectable() {
          return !cellState.disabled && !cellState.unavailable;
        },
        // Range states
        inRange: isInSelectedRange || isInHoveredRange,
        firstInRange: isFirstInSelectedRange,
        lastInRange: isLastInSelectedRange,
        // Preview range states
        inHoveredRange: isInHoveredRange,
        firstInHoveredRange: isFirstInHoveredRange,
        lastInHoveredRange: isLastInHoveredRange
      };
      return cellState;
    }
    function getTableId2(props22) {
      const { view = "day", id } = props22;
      return [view, id].filter(Boolean).join(" ");
    }
    return {
      focused,
      open,
      disabled,
      invalid,
      readOnly,
      inline: !!prop("inline"),
      numOfMonths: prop("numOfMonths"),
      selectionMode: prop("selectionMode"),
      view: context.get("view"),
      getRangePresetValue(preset) {
        return getDateRangePreset(preset, locale, timeZone);
      },
      getDaysInWeek(week, from = startValue) {
        return getDaysInWeek(week, from, locale, startOfWeek);
      },
      getOffset(duration) {
        const from = startValue.add(duration);
        const end = endValue.add(duration);
        const formatter = getMonthFormatter(locale, timeZone);
        return {
          visibleRange: { start: from, end },
          weeks: getMonthWeeks(from),
          visibleRangeText: {
            start: formatter.format(from.toDate(timeZone)),
            end: formatter.format(end.toDate(timeZone))
          }
        };
      },
      getMonthWeeks,
      isUnavailable,
      weeks: getMonthWeeks(),
      weekDays: getWeekDays(getTodayDate(timeZone), startOfWeek, timeZone, locale),
      visibleRangeText: computed("visibleRangeText"),
      value: selectedValue,
      valueAsDate: selectedValue.filter((date) => date != null).map((date) => date.toDate(timeZone)),
      valueAsString: computed("valueAsString"),
      focusedValue,
      focusedValueAsDate: focusedValue == null ? void 0 : focusedValue.toDate(timeZone),
      focusedValueAsString: prop("format")(focusedValue, { locale, timeZone }),
      visibleRange: computed("visibleRange"),
      selectToday() {
        const value = constrainValue(getTodayDate(timeZone), min4, max4);
        send({ type: "VALUE.SET", value });
      },
      setValue(values) {
        const computedValue = values.map((date) => constrainValue(date, min4, max4));
        send({ type: "VALUE.SET", value: computedValue });
      },
      clearValue() {
        send({ type: "VALUE.CLEAR" });
      },
      setFocusedValue(value) {
        send({ type: "FOCUS.SET", value });
      },
      setOpen(nextOpen) {
        if (prop("inline")) return;
        const open2 = state2.matches("open");
        if (open2 === nextOpen) return;
        send({ type: nextOpen ? "OPEN" : "CLOSE" });
      },
      focusMonth,
      focusYear,
      getYears,
      getMonths,
      getYearsGrid(props22 = {}) {
        const { columns = 1 } = props22;
        const years = getDecadeRange(startValue.year, { strict: true }).map((year) => ({
          label: year.toString(),
          value: year,
          disabled: !isValueWithinRange(year, min4 == null ? void 0 : min4.year, max4 == null ? void 0 : max4.year)
        }));
        return chunk(years, columns);
      },
      getDecade() {
        const years = getDecadeRange(startValue.year, { strict: true });
        return { start: years.at(0), end: years.at(-1) };
      },
      getMonthsGrid(props22 = {}) {
        const { columns = 1, format } = props22;
        return chunk(getMonths({ format }), columns);
      },
      format(value, opts = { month: "long", year: "numeric" }) {
        return new $fb18d541ea1ad717$export$ad991b66133851cf(locale, opts).format(value.toDate(timeZone));
      },
      setView(view) {
        send({ type: "VIEW.SET", view });
      },
      goToNext() {
        send({ type: "GOTO.NEXT", view: context.get("view") });
      },
      goToPrev() {
        send({ type: "GOTO.PREV", view: context.get("view") });
      },
      getRootProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts6.root.attrs), {
          dir: prop("dir"),
          id: getRootId6(scope),
          "data-state": open ? "open" : "closed",
          "data-disabled": dataAttr(disabled),
          "data-readonly": dataAttr(readOnly),
          "data-empty": dataAttr(empty)
        }));
      },
      getLabelProps(props22 = {}) {
        const { index = 0 } = props22;
        return normalize.label(__spreadProps(__spreadValues({}, parts6.label.attrs), {
          id: getLabelId4(scope, index),
          dir: prop("dir"),
          htmlFor: getInputId3(scope, index),
          "data-state": open ? "open" : "closed",
          "data-index": index,
          "data-disabled": dataAttr(disabled),
          "data-readonly": dataAttr(readOnly)
        }));
      },
      getControlProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts6.control.attrs), {
          dir: prop("dir"),
          id: getControlId3(scope),
          "data-disabled": dataAttr(disabled),
          "data-placeholder-shown": dataAttr(empty)
        }));
      },
      getRangeTextProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts6.rangeText.attrs), {
          dir: prop("dir")
        }));
      },
      getContentProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts6.content.attrs), {
          hidden: !open,
          dir: prop("dir"),
          "data-state": open ? "open" : "closed",
          "data-placement": currentPlacement,
          "data-inline": dataAttr(prop("inline")),
          id: getContentId3(scope),
          tabIndex: -1,
          role: "application",
          "aria-roledescription": "datepicker",
          "aria-label": translations.content
        }));
      },
      getTableProps(props22 = {}) {
        const { view = "day", columns = view === "day" ? 7 : 4 } = props22;
        const uid = getTableId2(props22);
        return normalize.element(__spreadProps(__spreadValues({}, parts6.table.attrs), {
          role: "grid",
          "data-columns": columns,
          "aria-roledescription": getRoleDescription(view),
          id: getTableId(scope, uid),
          "aria-readonly": ariaAttr(readOnly),
          "aria-disabled": ariaAttr(disabled),
          "aria-multiselectable": ariaAttr(prop("selectionMode") !== "single"),
          "data-view": view,
          dir: prop("dir"),
          tabIndex: -1,
          onKeyDown(event) {
            if (event.defaultPrevented) return;
            const keyMap2 = {
              Enter() {
                if (view === "day" && isUnavailable(focusedValue)) return;
                if (view === "month") {
                  const cellState = getMonthTableCellState({ value: focusedValue.month });
                  if (!cellState.selectable) return;
                }
                if (view === "year") {
                  const cellState = getYearTableCellState({ value: focusedValue.year });
                  if (!cellState.selectable) return;
                }
                send({ type: "TABLE.ENTER", view, columns, focus: true });
              },
              ArrowLeft() {
                send({ type: "TABLE.ARROW_LEFT", view, columns, focus: true });
              },
              ArrowRight() {
                send({ type: "TABLE.ARROW_RIGHT", view, columns, focus: true });
              },
              ArrowUp() {
                send({ type: "TABLE.ARROW_UP", view, columns, focus: true });
              },
              ArrowDown() {
                send({ type: "TABLE.ARROW_DOWN", view, columns, focus: true });
              },
              PageUp(event2) {
                send({ type: "TABLE.PAGE_UP", larger: event2.shiftKey, view, columns, focus: true });
              },
              PageDown(event2) {
                send({ type: "TABLE.PAGE_DOWN", larger: event2.shiftKey, view, columns, focus: true });
              },
              Home() {
                send({ type: "TABLE.HOME", view, columns, focus: true });
              },
              End() {
                send({ type: "TABLE.END", view, columns, focus: true });
              }
            };
            const exec = keyMap2[getEventKey(event, {
              dir: prop("dir")
            })];
            if (exec) {
              exec(event);
              event.preventDefault();
              event.stopPropagation();
            }
          },
          onPointerLeave() {
            send({ type: "TABLE.POINTER_LEAVE" });
          },
          onPointerDown() {
            send({ type: "TABLE.POINTER_DOWN", view });
          },
          onPointerUp() {
            send({ type: "TABLE.POINTER_UP", view });
          }
        }));
      },
      getTableHeadProps(props22 = {}) {
        const { view = "day" } = props22;
        return normalize.element(__spreadProps(__spreadValues({}, parts6.tableHead.attrs), {
          "aria-hidden": true,
          dir: prop("dir"),
          "data-view": view,
          "data-disabled": dataAttr(disabled)
        }));
      },
      getTableHeaderProps(props22 = {}) {
        const { view = "day" } = props22;
        return normalize.element(__spreadProps(__spreadValues({}, parts6.tableHeader.attrs), {
          dir: prop("dir"),
          "data-view": view,
          "data-disabled": dataAttr(disabled)
        }));
      },
      getTableBodyProps(props22 = {}) {
        const { view = "day" } = props22;
        return normalize.element(__spreadProps(__spreadValues({}, parts6.tableBody.attrs), {
          "data-view": view,
          "data-disabled": dataAttr(disabled)
        }));
      },
      getTableRowProps(props22 = {}) {
        const { view = "day" } = props22;
        return normalize.element(__spreadProps(__spreadValues({}, parts6.tableRow.attrs), {
          "aria-disabled": ariaAttr(disabled),
          "data-disabled": dataAttr(disabled),
          "data-view": view
        }));
      },
      getDayTableCellState,
      getDayTableCellProps(props22) {
        const { value } = props22;
        const cellState = getDayTableCellState(props22);
        return normalize.element(__spreadProps(__spreadValues({}, parts6.tableCell.attrs), {
          role: "gridcell",
          "aria-disabled": ariaAttr(!cellState.selectable),
          "aria-selected": cellState.selected || cellState.inRange,
          "aria-invalid": ariaAttr(cellState.invalid),
          "aria-current": cellState.today ? "date" : void 0,
          "data-value": value.toString()
        }));
      },
      getDayTableCellTriggerProps(props22) {
        const { value } = props22;
        const cellState = getDayTableCellState(props22);
        return normalize.element(__spreadProps(__spreadValues({}, parts6.tableCellTrigger.attrs), {
          id: getCellTriggerId(scope, value.toString()),
          role: "button",
          dir: prop("dir"),
          tabIndex: cellState.focused ? 0 : -1,
          "aria-label": cellState.ariaLabel,
          "aria-disabled": ariaAttr(!cellState.selectable),
          "aria-invalid": ariaAttr(cellState.invalid),
          "data-disabled": dataAttr(!cellState.selectable),
          "data-selected": dataAttr(cellState.selected),
          "data-value": value.toString(),
          "data-view": "day",
          "data-today": dataAttr(cellState.today),
          "data-focus": dataAttr(cellState.focused),
          "data-unavailable": dataAttr(cellState.unavailable),
          "data-range-start": dataAttr(cellState.firstInRange),
          "data-range-end": dataAttr(cellState.lastInRange),
          "data-in-range": dataAttr(cellState.inRange),
          "data-outside-range": dataAttr(cellState.outsideRange),
          "data-weekend": dataAttr(cellState.weekend),
          "data-in-hover-range": dataAttr(cellState.inHoveredRange),
          "data-hover-range-start": dataAttr(cellState.firstInHoveredRange),
          "data-hover-range-end": dataAttr(cellState.lastInHoveredRange),
          onClick(event) {
            if (event.defaultPrevented) return;
            if (!cellState.selectable) return;
            send({ type: "CELL.CLICK", cell: "day", value });
          },
          onPointerMove: isRangePicker ? (event) => {
            if (event.pointerType === "touch") return;
            if (!cellState.selectable) return;
            const focus = !scope.isActiveElement(event.currentTarget);
            if (hoveredValue && $14e0f24ef4ac5c92$export$91b62ebf2ba703ee(value, hoveredValue)) return;
            send({ type: "CELL.POINTER_MOVE", cell: "day", value, focus });
          } : void 0
        }));
      },
      getMonthTableCellState,
      getMonthTableCellProps(props22) {
        const { value, columns } = props22;
        const cellState = getMonthTableCellState(props22);
        return normalize.element(__spreadProps(__spreadValues({}, parts6.tableCell.attrs), {
          dir: prop("dir"),
          colSpan: columns,
          role: "gridcell",
          "aria-selected": ariaAttr(cellState.selected || cellState.inRange),
          "data-selected": dataAttr(cellState.selected),
          "aria-disabled": ariaAttr(!cellState.selectable),
          "data-value": value
        }));
      },
      getMonthTableCellTriggerProps(props22) {
        const { value } = props22;
        const cellState = getMonthTableCellState(props22);
        return normalize.element(__spreadProps(__spreadValues({}, parts6.tableCellTrigger.attrs), {
          dir: prop("dir"),
          role: "button",
          id: getCellTriggerId(scope, value.toString()),
          "data-selected": dataAttr(cellState.selected),
          "aria-disabled": ariaAttr(!cellState.selectable),
          "data-disabled": dataAttr(!cellState.selectable),
          "data-focus": dataAttr(cellState.focused),
          "data-in-range": dataAttr(cellState.inRange),
          "data-outside-range": dataAttr(cellState.outsideRange),
          "aria-label": cellState.valueText,
          "data-view": "month",
          "data-value": value,
          tabIndex: cellState.focused ? 0 : -1,
          onClick(event) {
            if (event.defaultPrevented) return;
            if (!cellState.selectable) return;
            send({ type: "CELL.CLICK", cell: "month", value });
          },
          onPointerMove: isRangePicker ? (event) => {
            if (event.pointerType === "touch") return;
            if (!cellState.selectable) return;
            const focus = !scope.isActiveElement(event.currentTarget);
            if (hoveredValue && cellState.value && $14e0f24ef4ac5c92$export$5a8da0c44a3afdf2(cellState.value, hoveredValue)) return;
            send({ type: "CELL.POINTER_MOVE", cell: "month", value: cellState.value, focus });
          } : void 0
        }));
      },
      getYearTableCellState,
      getYearTableCellProps(props22) {
        const { value, columns } = props22;
        const cellState = getYearTableCellState(props22);
        return normalize.element(__spreadProps(__spreadValues({}, parts6.tableCell.attrs), {
          dir: prop("dir"),
          colSpan: columns,
          role: "gridcell",
          "aria-selected": ariaAttr(cellState.selected),
          "data-selected": dataAttr(cellState.selected),
          "aria-disabled": ariaAttr(!cellState.selectable),
          "data-value": value
        }));
      },
      getYearTableCellTriggerProps(props22) {
        const { value } = props22;
        const cellState = getYearTableCellState(props22);
        return normalize.element(__spreadProps(__spreadValues({}, parts6.tableCellTrigger.attrs), {
          dir: prop("dir"),
          role: "button",
          id: getCellTriggerId(scope, value.toString()),
          "data-selected": dataAttr(cellState.selected),
          "data-focus": dataAttr(cellState.focused),
          "data-in-range": dataAttr(cellState.inRange),
          "aria-disabled": ariaAttr(!cellState.selectable),
          "data-disabled": dataAttr(!cellState.selectable),
          "aria-label": cellState.valueText,
          "data-outside-range": dataAttr(cellState.outsideRange),
          "data-value": value,
          "data-view": "year",
          tabIndex: cellState.focused ? 0 : -1,
          onClick(event) {
            if (event.defaultPrevented) return;
            if (!cellState.selectable) return;
            send({ type: "CELL.CLICK", cell: "year", value });
          },
          onPointerMove: isRangePicker ? (event) => {
            if (event.pointerType === "touch") return;
            if (!cellState.selectable) return;
            const focus = !scope.isActiveElement(event.currentTarget);
            if (hoveredValue && cellState.value && $14e0f24ef4ac5c92$export$ea840f5a6dda8147(cellState.value, hoveredValue)) return;
            send({ type: "CELL.POINTER_MOVE", cell: "year", value: cellState.value, focus });
          } : void 0
        }));
      },
      getNextTriggerProps(props22 = {}) {
        const { view = "day" } = props22;
        const isDisabled = disabled || !computed("isNextVisibleRangeValid");
        return normalize.button(__spreadProps(__spreadValues({}, parts6.nextTrigger.attrs), {
          dir: prop("dir"),
          id: getNextTriggerId(scope, view),
          type: "button",
          "aria-label": translations.nextTrigger(view),
          disabled: isDisabled,
          "data-disabled": dataAttr(isDisabled),
          onClick(event) {
            if (event.defaultPrevented) return;
            send({ type: "GOTO.NEXT", view });
          }
        }));
      },
      getPrevTriggerProps(props22 = {}) {
        const { view = "day" } = props22;
        const isDisabled = disabled || !computed("isPrevVisibleRangeValid");
        return normalize.button(__spreadProps(__spreadValues({}, parts6.prevTrigger.attrs), {
          dir: prop("dir"),
          id: getPrevTriggerId(scope, view),
          type: "button",
          "aria-label": translations.prevTrigger(view),
          disabled: isDisabled,
          "data-disabled": dataAttr(isDisabled),
          onClick(event) {
            if (event.defaultPrevented) return;
            send({ type: "GOTO.PREV", view });
          }
        }));
      },
      getClearTriggerProps() {
        return normalize.button(__spreadProps(__spreadValues({}, parts6.clearTrigger.attrs), {
          id: getClearTriggerId2(scope),
          dir: prop("dir"),
          type: "button",
          "aria-label": translations.clearTrigger,
          hidden: !selectedValue.length,
          onClick(event) {
            if (event.defaultPrevented) return;
            send({ type: "VALUE.CLEAR" });
          }
        }));
      },
      getTriggerProps() {
        return normalize.button(__spreadProps(__spreadValues({}, parts6.trigger.attrs), {
          id: getTriggerId3(scope),
          dir: prop("dir"),
          type: "button",
          "data-placement": currentPlacement,
          "aria-label": translations.trigger(open),
          "aria-controls": getContentId3(scope),
          "data-state": open ? "open" : "closed",
          "data-placeholder-shown": dataAttr(empty),
          "aria-haspopup": "grid",
          disabled,
          onClick(event) {
            if (event.defaultPrevented) return;
            if (!interactive) return;
            send({ type: "TRIGGER.CLICK" });
          }
        }));
      },
      getViewProps(props22 = {}) {
        const { view = "day" } = props22;
        return normalize.element(__spreadProps(__spreadValues({}, parts6.view.attrs), {
          "data-view": view,
          hidden: context.get("view") !== view
        }));
      },
      getViewTriggerProps(props22 = {}) {
        const { view = "day" } = props22;
        return normalize.button(__spreadProps(__spreadValues({}, parts6.viewTrigger.attrs), {
          "data-view": view,
          dir: prop("dir"),
          id: getViewTriggerId(scope, view),
          type: "button",
          disabled,
          "aria-label": translations.viewTrigger(view),
          onClick(event) {
            if (event.defaultPrevented) return;
            if (!interactive) return;
            send({ type: "VIEW.TOGGLE", src: "viewTrigger" });
          }
        }));
      },
      getViewControlProps(props22 = {}) {
        const { view = "day" } = props22;
        return normalize.element(__spreadProps(__spreadValues({}, parts6.viewControl.attrs), {
          "data-view": view,
          dir: prop("dir")
        }));
      },
      getInputProps(props22 = {}) {
        const { index = 0, fixOnBlur = true } = props22;
        return normalize.input(__spreadProps(__spreadValues({}, parts6.input.attrs), {
          id: getInputId3(scope, index),
          autoComplete: "off",
          autoCorrect: "off",
          spellCheck: "false",
          dir: prop("dir"),
          name: prop("name"),
          "data-index": index,
          "data-state": open ? "open" : "closed",
          "data-placeholder-shown": dataAttr(empty),
          readOnly,
          disabled,
          required: prop("required"),
          "aria-invalid": ariaAttr(invalid),
          "data-invalid": dataAttr(invalid),
          placeholder: prop("placeholder") || getInputPlaceholder(locale),
          defaultValue: computed("valueAsString")[index],
          onBeforeInput(event) {
            const { data } = getNativeEvent(event);
            if (!isValidCharacter(data, separator)) {
              event.preventDefault();
            }
          },
          onFocus() {
            send({ type: "INPUT.FOCUS", index });
          },
          onBlur(event) {
            const value = event.currentTarget.value.trim();
            send({ type: "INPUT.BLUR", value, index, fixOnBlur });
          },
          onKeyDown(event) {
            if (event.defaultPrevented) return;
            if (!interactive) return;
            const keyMap2 = {
              Enter(event2) {
                if (isComposingEvent(event2)) return;
                if (isUnavailable(focusedValue)) return;
                if (event2.currentTarget.value.trim() === "") return;
                send({ type: "INPUT.ENTER", value: event2.currentTarget.value, index });
              }
            };
            const exec = keyMap2[event.key];
            if (exec) {
              exec(event);
              event.preventDefault();
            }
          },
          onInput(event) {
            const value = event.currentTarget.value;
            send({ type: "INPUT.CHANGE", value: ensureValidCharacters(value, separator), index });
          }
        }));
      },
      getMonthSelectProps() {
        return normalize.select(__spreadProps(__spreadValues({}, parts6.monthSelect.attrs), {
          id: getMonthSelectId(scope),
          "aria-label": translations.monthSelect,
          disabled,
          dir: prop("dir"),
          defaultValue: startValue.month,
          onChange(event) {
            focusMonth(Number(event.currentTarget.value));
          }
        }));
      },
      getYearSelectProps() {
        return normalize.select(__spreadProps(__spreadValues({}, parts6.yearSelect.attrs), {
          id: getYearSelectId(scope),
          disabled,
          "aria-label": translations.yearSelect,
          dir: prop("dir"),
          defaultValue: startValue.year,
          onChange(event) {
            focusYear(Number(event.currentTarget.value));
          }
        }));
      },
      getPositionerProps() {
        return normalize.element(__spreadProps(__spreadValues({
          id: getPositionerId2(scope)
        }, parts6.positioner.attrs), {
          dir: prop("dir"),
          style: popperStyles.floating
        }));
      },
      getPresetTriggerProps(props22) {
        const value = Array.isArray(props22.value) ? props22.value : getDateRangePreset(props22.value, locale, timeZone);
        const valueAsString = value.filter((item) => item != null).map((item) => item.toDate(timeZone).toDateString());
        return normalize.button(__spreadProps(__spreadValues({}, parts6.presetTrigger.attrs), {
          "aria-label": translations.presetTrigger(valueAsString),
          type: "button",
          onClick(event) {
            if (event.defaultPrevented) return;
            send({ type: "PRESET.CLICK", value });
          }
        }));
      }
    };
  }
  function isDateArrayEqual(a2, b2) {
    if ((a2 == null ? void 0 : a2.length) !== (b2 == null ? void 0 : b2.length)) return false;
    const len = Math.max(a2.length, b2.length);
    for (let i2 = 0; i2 < len; i2++) {
      if (!isDateEqual(a2[i2], b2[i2])) return false;
    }
    return true;
  }
  function getValueAsString(value, prop) {
    return value.map((date) => {
      if (date == null) return "";
      return prop("format")(date, { locale: prop("locale"), timeZone: prop("timeZone") });
    });
  }
  function setFocusedValue(ctx, mixedValue) {
    const { context, prop, computed } = ctx;
    if (!mixedValue) return;
    const value = normalizeValue(ctx, mixedValue);
    if (isDateEqual(context.get("focusedValue"), value)) return;
    const adjustFn = getAdjustedDateFn(computed("visibleDuration"), prop("locale"), prop("min"), prop("max"));
    const adjustedValue = adjustFn({
      focusedDate: value,
      startDate: context.get("startValue")
    });
    context.set("startValue", adjustedValue.startDate);
    context.set("focusedValue", adjustedValue.focusedDate);
  }
  function setAdjustedValue(ctx, value) {
    const { context } = ctx;
    context.set("startValue", value.startDate);
    const focusedValue = context.get("focusedValue");
    if (isDateEqual(focusedValue, value.focusedDate)) return;
    context.set("focusedValue", value.focusedDate);
  }
  function parse(value) {
    if (Array.isArray(value)) {
      return value.map((v2) => parse(v2));
    }
    if (value instanceof Date) {
      return new $35ea8db9cb2ccb90$export$99faa760c7908e4f(value.getFullYear(), value.getMonth() + 1, value.getDate());
    }
    return $fae977aafc393c5c$export$6b862160d295c8e(value);
  }
  function toISOString(d2) {
    const pad = (n2) => String(n2).padStart(2, "0");
    return `${d2.year}-${pad(d2.month)}-${pad(d2.day)}`;
  }
  var $3b62074eb05584b2$var$EPOCH, $3b62074eb05584b2$var$daysInMonth, $3b62074eb05584b2$export$80ee6245ec4f29ec, $2fe286d2fb449abb$export$7a5acbd77d414bd9, $14e0f24ef4ac5c92$var$DAY_MAP, $14e0f24ef4ac5c92$var$localTimeZone, $14e0f24ef4ac5c92$var$cachedRegions, $14e0f24ef4ac5c92$var$cachedWeekInfo, $14e0f24ef4ac5c92$var$WEEKEND_DATA, $11d87f3f76e88657$var$formattersByTimeZone, $11d87f3f76e88657$var$DAYMILLIS, $735220c2d4774dd3$var$ONE_HOUR, $fae977aafc393c5c$var$DATE_RE, $fae977aafc393c5c$var$ABSOLUTE_RE, $fae977aafc393c5c$var$requiredDurationTimeGroups, $fae977aafc393c5c$var$requiredDurationGroups, $35ea8db9cb2ccb90$var$_type, $35ea8db9cb2ccb90$export$99faa760c7908e4f, $35ea8db9cb2ccb90$var$_type2, $35ea8db9cb2ccb90$export$ca871e8dbb80966f, $35ea8db9cb2ccb90$var$_type3, $35ea8db9cb2ccb90$export$d3b7288e7994edea, $fb18d541ea1ad717$var$formatterCache, $fb18d541ea1ad717$export$ad991b66133851cf, $fb18d541ea1ad717$var$hour12Preferences, $fb18d541ea1ad717$var$_hasBuggyHour12Behavior, $fb18d541ea1ad717$var$_hasBuggyResolvedHourCycle, daysOfTheWeek, FUTURE_YEAR_COERCION, isValidYear, isValidMonth, isValidDay, ID, anatomy6, parts6, getLabelId4, getRootId6, getTableId, getContentId3, getCellTriggerId, getPrevTriggerId, getNextTriggerId, getViewTriggerId, getClearTriggerId2, getControlId3, getInputId3, getTriggerId3, getPositionerId2, getMonthSelectId, getYearSelectId, getFocusedCell, getTriggerEl2, getContentEl3, getInputEls, getYearSelectEl, getMonthSelectEl, getClearTriggerEl2, getPositionerEl2, getControlEl2, PLACEHOLDERS, isValidCharacter, isValidDate, ensureValidCharacters, defaultTranslations, views, getVisibleRangeText, and3, machine6, normalizeValue, props6, splitProps6, inputProps, splitInputProps, presetTriggerProps, splitPresetTriggerProps, tableProps, splitTableProps, tableCellProps, splitTableCellProps, viewProps, splitViewProps, DatePicker, DatePickerHook;
  var init_date_picker = __esm({
    "../priv/static/date-picker.mjs"() {
      "use strict";
      init_chunk_GRHV6R4F();
      init_chunk_BPSX7Z7Y();
      init_chunk_GFGFZBBD();
      $3b62074eb05584b2$var$EPOCH = 1721426;
      $3b62074eb05584b2$var$daysInMonth = {
        standard: [
          31,
          28,
          31,
          30,
          31,
          30,
          31,
          31,
          30,
          31,
          30,
          31
        ],
        leapyear: [
          31,
          29,
          31,
          30,
          31,
          30,
          31,
          31,
          30,
          31,
          30,
          31
        ]
      };
      $3b62074eb05584b2$export$80ee6245ec4f29ec = class {
        fromJulianDay(jd) {
          let jd0 = jd;
          let depoch = jd0 - $3b62074eb05584b2$var$EPOCH;
          let quadricent = Math.floor(depoch / 146097);
          let dqc = (0, $2b4dce13dd5a17fa$export$842a2cf37af977e1)(depoch, 146097);
          let cent = Math.floor(dqc / 36524);
          let dcent = (0, $2b4dce13dd5a17fa$export$842a2cf37af977e1)(dqc, 36524);
          let quad = Math.floor(dcent / 1461);
          let dquad = (0, $2b4dce13dd5a17fa$export$842a2cf37af977e1)(dcent, 1461);
          let yindex = Math.floor(dquad / 365);
          let extendedYear = quadricent * 400 + cent * 100 + quad * 4 + yindex + (cent !== 4 && yindex !== 4 ? 1 : 0);
          let [era, year] = $3b62074eb05584b2$export$4475b7e617eb123c(extendedYear);
          let yearDay = jd0 - $3b62074eb05584b2$export$f297eb839006d339(era, year, 1, 1);
          let leapAdj = 2;
          if (jd0 < $3b62074eb05584b2$export$f297eb839006d339(era, year, 3, 1)) leapAdj = 0;
          else if ($3b62074eb05584b2$export$553d7fa8e3805fc0(year)) leapAdj = 1;
          let month = Math.floor(((yearDay + leapAdj) * 12 + 373) / 367);
          let day = jd0 - $3b62074eb05584b2$export$f297eb839006d339(era, year, month, 1) + 1;
          return new (0, $35ea8db9cb2ccb90$export$99faa760c7908e4f)(era, year, month, day);
        }
        toJulianDay(date) {
          return $3b62074eb05584b2$export$f297eb839006d339(date.era, date.year, date.month, date.day);
        }
        getDaysInMonth(date) {
          return $3b62074eb05584b2$var$daysInMonth[$3b62074eb05584b2$export$553d7fa8e3805fc0(date.year) ? "leapyear" : "standard"][date.month - 1];
        }
        // eslint-disable-next-line @typescript-eslint/no-unused-vars
        getMonthsInYear(date) {
          return 12;
        }
        getDaysInYear(date) {
          return $3b62074eb05584b2$export$553d7fa8e3805fc0(date.year) ? 366 : 365;
        }
        getMaximumMonthsInYear() {
          return 12;
        }
        getMaximumDaysInMonth() {
          return 31;
        }
        // eslint-disable-next-line @typescript-eslint/no-unused-vars
        getYearsInEra(date) {
          return 9999;
        }
        getEras() {
          return [
            "BC",
            "AD"
          ];
        }
        isInverseEra(date) {
          return date.era === "BC";
        }
        balanceDate(date) {
          if (date.year <= 0) {
            date.era = date.era === "BC" ? "AD" : "BC";
            date.year = 1 - date.year;
          }
        }
        constructor() {
          this.identifier = "gregory";
        }
      };
      $2fe286d2fb449abb$export$7a5acbd77d414bd9 = {
        "001": 1,
        AD: 1,
        AE: 6,
        AF: 6,
        AI: 1,
        AL: 1,
        AM: 1,
        AN: 1,
        AR: 1,
        AT: 1,
        AU: 1,
        AX: 1,
        AZ: 1,
        BA: 1,
        BE: 1,
        BG: 1,
        BH: 6,
        BM: 1,
        BN: 1,
        BY: 1,
        CH: 1,
        CL: 1,
        CM: 1,
        CN: 1,
        CR: 1,
        CY: 1,
        CZ: 1,
        DE: 1,
        DJ: 6,
        DK: 1,
        DZ: 6,
        EC: 1,
        EE: 1,
        EG: 6,
        ES: 1,
        FI: 1,
        FJ: 1,
        FO: 1,
        FR: 1,
        GB: 1,
        GE: 1,
        GF: 1,
        GP: 1,
        GR: 1,
        HR: 1,
        HU: 1,
        IE: 1,
        IQ: 6,
        IR: 6,
        IS: 1,
        IT: 1,
        JO: 6,
        KG: 1,
        KW: 6,
        KZ: 1,
        LB: 1,
        LI: 1,
        LK: 1,
        LT: 1,
        LU: 1,
        LV: 1,
        LY: 6,
        MC: 1,
        MD: 1,
        ME: 1,
        MK: 1,
        MN: 1,
        MQ: 1,
        MV: 5,
        MY: 1,
        NL: 1,
        NO: 1,
        NZ: 1,
        OM: 6,
        PL: 1,
        QA: 6,
        RE: 1,
        RO: 1,
        RS: 1,
        RU: 1,
        SD: 6,
        SE: 1,
        SI: 1,
        SK: 1,
        SM: 1,
        SY: 6,
        TJ: 1,
        TM: 1,
        TR: 1,
        UA: 1,
        UY: 1,
        UZ: 1,
        VA: 1,
        VN: 1,
        XK: 1
      };
      $14e0f24ef4ac5c92$var$DAY_MAP = {
        sun: 0,
        mon: 1,
        tue: 2,
        wed: 3,
        thu: 4,
        fri: 5,
        sat: 6
      };
      $14e0f24ef4ac5c92$var$localTimeZone = null;
      $14e0f24ef4ac5c92$var$cachedRegions = /* @__PURE__ */ new Map();
      $14e0f24ef4ac5c92$var$cachedWeekInfo = /* @__PURE__ */ new Map();
      $14e0f24ef4ac5c92$var$WEEKEND_DATA = {
        AF: [
          4,
          5
        ],
        AE: [
          5,
          6
        ],
        BH: [
          5,
          6
        ],
        DZ: [
          5,
          6
        ],
        EG: [
          5,
          6
        ],
        IL: [
          5,
          6
        ],
        IQ: [
          5,
          6
        ],
        IR: [
          5,
          5
        ],
        JO: [
          5,
          6
        ],
        KW: [
          5,
          6
        ],
        LY: [
          5,
          6
        ],
        OM: [
          5,
          6
        ],
        QA: [
          5,
          6
        ],
        SA: [
          5,
          6
        ],
        SD: [
          5,
          6
        ],
        SY: [
          5,
          6
        ],
        YE: [
          5,
          6
        ]
      };
      $11d87f3f76e88657$var$formattersByTimeZone = /* @__PURE__ */ new Map();
      $11d87f3f76e88657$var$DAYMILLIS = 864e5;
      $735220c2d4774dd3$var$ONE_HOUR = 36e5;
      $fae977aafc393c5c$var$DATE_RE = /^([+-]\d{6}|\d{4})-(\d{2})-(\d{2})$/;
      $fae977aafc393c5c$var$ABSOLUTE_RE = /^([+-]\d{6}|\d{4})-(\d{2})-(\d{2})(?:T(\d{2}))?(?::(\d{2}))?(?::(\d{2}))?(\.\d+)?(?:(?:([+-]\d{2})(?::?(\d{2}))?)|Z)$/;
      $fae977aafc393c5c$var$requiredDurationTimeGroups = [
        "hours",
        "minutes",
        "seconds"
      ];
      $fae977aafc393c5c$var$requiredDurationGroups = [
        "years",
        "months",
        "weeks",
        "days",
        ...$fae977aafc393c5c$var$requiredDurationTimeGroups
      ];
      $35ea8db9cb2ccb90$var$_type = /* @__PURE__ */ new WeakMap();
      $35ea8db9cb2ccb90$export$99faa760c7908e4f = class _$35ea8db9cb2ccb90$export$99faa760c7908e4f {
        /** Returns a copy of this date. */
        copy() {
          if (this.era) return new _$35ea8db9cb2ccb90$export$99faa760c7908e4f(this.calendar, this.era, this.year, this.month, this.day);
          else return new _$35ea8db9cb2ccb90$export$99faa760c7908e4f(this.calendar, this.year, this.month, this.day);
        }
        /** Returns a new `CalendarDate` with the given duration added to it. */
        add(duration) {
          return (0, $735220c2d4774dd3$export$e16d8520af44a096)(this, duration);
        }
        /** Returns a new `CalendarDate` with the given duration subtracted from it. */
        subtract(duration) {
          return (0, $735220c2d4774dd3$export$4e2d2ead65e5f7e3)(this, duration);
        }
        /** Returns a new `CalendarDate` with the given fields set to the provided values. Other fields will be constrained accordingly. */
        set(fields) {
          return (0, $735220c2d4774dd3$export$adaa4cf7ef1b65be)(this, fields);
        }
        /**
        * Returns a new `CalendarDate` with the given field adjusted by a specified amount.
        * When the resulting value reaches the limits of the field, it wraps around.
        */
        cycle(field, amount, options) {
          return (0, $735220c2d4774dd3$export$d52ced6badfb9a4c)(this, field, amount, options);
        }
        /** Converts the date to a native JavaScript Date object, with the time set to midnight in the given time zone. */
        toDate(timeZone) {
          return (0, $11d87f3f76e88657$export$e67a095c620b86fe)(this, timeZone);
        }
        /** Converts the date to an ISO 8601 formatted string. */
        toString() {
          return (0, $fae977aafc393c5c$export$60dfd74aa96791bd)(this);
        }
        /** Compares this date with another. A negative result indicates that this date is before the given one, and a positive date indicates that it is after. */
        compare(b2) {
          return (0, $14e0f24ef4ac5c92$export$68781ddf31c0090f)(this, b2);
        }
        constructor(...args) {
          (0, _class_private_field_init)(this, $35ea8db9cb2ccb90$var$_type, {
            writable: true,
            value: void 0
          });
          let [calendar, era, year, month, day] = $35ea8db9cb2ccb90$var$shiftArgs(args);
          this.calendar = calendar;
          this.era = era;
          this.year = year;
          this.month = month;
          this.day = day;
          (0, $735220c2d4774dd3$export$c4e2ecac49351ef2)(this);
        }
      };
      $35ea8db9cb2ccb90$var$_type2 = /* @__PURE__ */ new WeakMap();
      $35ea8db9cb2ccb90$export$ca871e8dbb80966f = class _$35ea8db9cb2ccb90$export$ca871e8dbb80966f {
        /** Returns a copy of this date. */
        copy() {
          if (this.era) return new _$35ea8db9cb2ccb90$export$ca871e8dbb80966f(this.calendar, this.era, this.year, this.month, this.day, this.hour, this.minute, this.second, this.millisecond);
          else return new _$35ea8db9cb2ccb90$export$ca871e8dbb80966f(this.calendar, this.year, this.month, this.day, this.hour, this.minute, this.second, this.millisecond);
        }
        /** Returns a new `CalendarDateTime` with the given duration added to it. */
        add(duration) {
          return (0, $735220c2d4774dd3$export$e16d8520af44a096)(this, duration);
        }
        /** Returns a new `CalendarDateTime` with the given duration subtracted from it. */
        subtract(duration) {
          return (0, $735220c2d4774dd3$export$4e2d2ead65e5f7e3)(this, duration);
        }
        /** Returns a new `CalendarDateTime` with the given fields set to the provided values. Other fields will be constrained accordingly. */
        set(fields) {
          return (0, $735220c2d4774dd3$export$adaa4cf7ef1b65be)((0, $735220c2d4774dd3$export$e5d5e1c1822b6e56)(this, fields), fields);
        }
        /**
        * Returns a new `CalendarDateTime` with the given field adjusted by a specified amount.
        * When the resulting value reaches the limits of the field, it wraps around.
        */
        cycle(field, amount, options) {
          switch (field) {
            case "era":
            case "year":
            case "month":
            case "day":
              return (0, $735220c2d4774dd3$export$d52ced6badfb9a4c)(this, field, amount, options);
            default:
              return (0, $735220c2d4774dd3$export$dd02b3e0007dfe28)(this, field, amount, options);
          }
        }
        /** Converts the date to a native JavaScript Date object in the given time zone. */
        toDate(timeZone, disambiguation) {
          return (0, $11d87f3f76e88657$export$e67a095c620b86fe)(this, timeZone, disambiguation);
        }
        /** Converts the date to an ISO 8601 formatted string. */
        toString() {
          return (0, $fae977aafc393c5c$export$4223de14708adc63)(this);
        }
        /** Compares this date with another. A negative result indicates that this date is before the given one, and a positive date indicates that it is after. */
        compare(b2) {
          let res = (0, $14e0f24ef4ac5c92$export$68781ddf31c0090f)(this, b2);
          if (res === 0) return (0, $14e0f24ef4ac5c92$export$c19a80a9721b80f6)(this, (0, $11d87f3f76e88657$export$b21e0b124e224484)(b2));
          return res;
        }
        constructor(...args) {
          (0, _class_private_field_init)(this, $35ea8db9cb2ccb90$var$_type2, {
            writable: true,
            value: void 0
          });
          let [calendar, era, year, month, day] = $35ea8db9cb2ccb90$var$shiftArgs(args);
          this.calendar = calendar;
          this.era = era;
          this.year = year;
          this.month = month;
          this.day = day;
          this.hour = args.shift() || 0;
          this.minute = args.shift() || 0;
          this.second = args.shift() || 0;
          this.millisecond = args.shift() || 0;
          (0, $735220c2d4774dd3$export$c4e2ecac49351ef2)(this);
        }
      };
      $35ea8db9cb2ccb90$var$_type3 = /* @__PURE__ */ new WeakMap();
      $35ea8db9cb2ccb90$export$d3b7288e7994edea = class _$35ea8db9cb2ccb90$export$d3b7288e7994edea {
        /** Returns a copy of this date. */
        copy() {
          if (this.era) return new _$35ea8db9cb2ccb90$export$d3b7288e7994edea(this.calendar, this.era, this.year, this.month, this.day, this.timeZone, this.offset, this.hour, this.minute, this.second, this.millisecond);
          else return new _$35ea8db9cb2ccb90$export$d3b7288e7994edea(this.calendar, this.year, this.month, this.day, this.timeZone, this.offset, this.hour, this.minute, this.second, this.millisecond);
        }
        /** Returns a new `ZonedDateTime` with the given duration added to it. */
        add(duration) {
          return (0, $735220c2d4774dd3$export$96b1d28349274637)(this, duration);
        }
        /** Returns a new `ZonedDateTime` with the given duration subtracted from it. */
        subtract(duration) {
          return (0, $735220c2d4774dd3$export$6814caac34ca03c7)(this, duration);
        }
        /** Returns a new `ZonedDateTime` with the given fields set to the provided values. Other fields will be constrained accordingly. */
        set(fields, disambiguation) {
          return (0, $735220c2d4774dd3$export$31b5430eb18be4f8)(this, fields, disambiguation);
        }
        /**
        * Returns a new `ZonedDateTime` with the given field adjusted by a specified amount.
        * When the resulting value reaches the limits of the field, it wraps around.
        */
        cycle(field, amount, options) {
          return (0, $735220c2d4774dd3$export$9a297d111fc86b79)(this, field, amount, options);
        }
        /** Converts the date to a native JavaScript Date object. */
        toDate() {
          return (0, $11d87f3f76e88657$export$83aac07b4c37b25)(this);
        }
        /** Converts the date to an ISO 8601 formatted string, including the UTC offset and time zone identifier. */
        toString() {
          return (0, $fae977aafc393c5c$export$bf79f1ebf4b18792)(this);
        }
        /** Converts the date to an ISO 8601 formatted string in UTC. */
        toAbsoluteString() {
          return this.toDate().toISOString();
        }
        /** Compares this date with another. A negative result indicates that this date is before the given one, and a positive date indicates that it is after. */
        compare(b2) {
          return this.toDate().getTime() - (0, $11d87f3f76e88657$export$84c95a83c799e074)(b2, this.timeZone).toDate().getTime();
        }
        constructor(...args) {
          (0, _class_private_field_init)(this, $35ea8db9cb2ccb90$var$_type3, {
            writable: true,
            value: void 0
          });
          let [calendar, era, year, month, day] = $35ea8db9cb2ccb90$var$shiftArgs(args);
          let timeZone = args.shift();
          let offset3 = args.shift();
          this.calendar = calendar;
          this.era = era;
          this.year = year;
          this.month = month;
          this.day = day;
          this.timeZone = timeZone;
          this.offset = offset3;
          this.hour = args.shift() || 0;
          this.minute = args.shift() || 0;
          this.second = args.shift() || 0;
          this.millisecond = args.shift() || 0;
          (0, $735220c2d4774dd3$export$c4e2ecac49351ef2)(this);
        }
      };
      $fb18d541ea1ad717$var$formatterCache = /* @__PURE__ */ new Map();
      $fb18d541ea1ad717$export$ad991b66133851cf = class {
        /** Formats a date as a string according to the locale and format options passed to the constructor. */
        format(value) {
          return this.formatter.format(value);
        }
        /** Formats a date to an array of parts such as separators, numbers, punctuation, and more. */
        formatToParts(value) {
          return this.formatter.formatToParts(value);
        }
        /** Formats a date range as a string. */
        formatRange(start, end) {
          if (typeof this.formatter.formatRange === "function")
            return this.formatter.formatRange(start, end);
          if (end < start) throw new RangeError("End date must be >= start date");
          return `${this.formatter.format(start)} \u2013 ${this.formatter.format(end)}`;
        }
        /** Formats a date range as an array of parts. */
        formatRangeToParts(start, end) {
          if (typeof this.formatter.formatRangeToParts === "function")
            return this.formatter.formatRangeToParts(start, end);
          if (end < start) throw new RangeError("End date must be >= start date");
          let startParts = this.formatter.formatToParts(start);
          let endParts = this.formatter.formatToParts(end);
          return [
            ...startParts.map((p2) => __spreadProps(__spreadValues({}, p2), {
              source: "startRange"
            })),
            {
              type: "literal",
              value: " \u2013 ",
              source: "shared"
            },
            ...endParts.map((p2) => __spreadProps(__spreadValues({}, p2), {
              source: "endRange"
            }))
          ];
        }
        /** Returns the resolved formatting options based on the values passed to the constructor. */
        resolvedOptions() {
          let resolvedOptions = this.formatter.resolvedOptions();
          if ($fb18d541ea1ad717$var$hasBuggyResolvedHourCycle()) {
            if (!this.resolvedHourCycle) this.resolvedHourCycle = $fb18d541ea1ad717$var$getResolvedHourCycle(resolvedOptions.locale, this.options);
            resolvedOptions.hourCycle = this.resolvedHourCycle;
            resolvedOptions.hour12 = this.resolvedHourCycle === "h11" || this.resolvedHourCycle === "h12";
          }
          if (resolvedOptions.calendar === "ethiopic-amete-alem") resolvedOptions.calendar = "ethioaa";
          return resolvedOptions;
        }
        constructor(locale, options = {}) {
          this.formatter = $fb18d541ea1ad717$var$getCachedDateFormatter(locale, options);
          this.options = options;
        }
      };
      $fb18d541ea1ad717$var$hour12Preferences = {
        true: {
          // Only Japanese uses the h11 style for 12 hour time. All others use h12.
          ja: "h11"
        },
        false: {}
      };
      $fb18d541ea1ad717$var$_hasBuggyHour12Behavior = null;
      $fb18d541ea1ad717$var$_hasBuggyResolvedHourCycle = null;
      daysOfTheWeek = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"];
      FUTURE_YEAR_COERCION = 10;
      isValidYear = (year) => year != null && year.length === 4;
      isValidMonth = (month) => month != null && parseFloat(month) <= 12;
      isValidDay = (day) => day != null && parseFloat(day) <= 31;
      ID = "__live-region__";
      anatomy6 = createAnatomy("date-picker").parts(
        "clearTrigger",
        "content",
        "control",
        "input",
        "label",
        "monthSelect",
        "nextTrigger",
        "positioner",
        "presetTrigger",
        "prevTrigger",
        "rangeText",
        "root",
        "table",
        "tableBody",
        "tableCell",
        "tableCellTrigger",
        "tableHead",
        "tableHeader",
        "tableRow",
        "trigger",
        "view",
        "viewControl",
        "viewTrigger",
        "yearSelect"
      );
      parts6 = anatomy6.build();
      getLabelId4 = (ctx, index) => {
        var _a, _b, _c;
        return (_c = (_b = (_a = ctx.ids) == null ? void 0 : _a.label) == null ? void 0 : _b.call(_a, index)) != null ? _c : `datepicker:${ctx.id}:label:${index}`;
      };
      getRootId6 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.root) != null ? _b : `datepicker:${ctx.id}`;
      };
      getTableId = (ctx, id) => {
        var _a, _b, _c;
        return (_c = (_b = (_a = ctx.ids) == null ? void 0 : _a.table) == null ? void 0 : _b.call(_a, id)) != null ? _c : `datepicker:${ctx.id}:table:${id}`;
      };
      getContentId3 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.content) != null ? _b : `datepicker:${ctx.id}:content`;
      };
      getCellTriggerId = (ctx, id) => {
        var _a, _b, _c;
        return (_c = (_b = (_a = ctx.ids) == null ? void 0 : _a.cellTrigger) == null ? void 0 : _b.call(_a, id)) != null ? _c : `datepicker:${ctx.id}:cell-trigger:${id}`;
      };
      getPrevTriggerId = (ctx, view) => {
        var _a, _b, _c;
        return (_c = (_b = (_a = ctx.ids) == null ? void 0 : _a.prevTrigger) == null ? void 0 : _b.call(_a, view)) != null ? _c : `datepicker:${ctx.id}:prev:${view}`;
      };
      getNextTriggerId = (ctx, view) => {
        var _a, _b, _c;
        return (_c = (_b = (_a = ctx.ids) == null ? void 0 : _a.nextTrigger) == null ? void 0 : _b.call(_a, view)) != null ? _c : `datepicker:${ctx.id}:next:${view}`;
      };
      getViewTriggerId = (ctx, view) => {
        var _a, _b, _c;
        return (_c = (_b = (_a = ctx.ids) == null ? void 0 : _a.viewTrigger) == null ? void 0 : _b.call(_a, view)) != null ? _c : `datepicker:${ctx.id}:view:${view}`;
      };
      getClearTriggerId2 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.clearTrigger) != null ? _b : `datepicker:${ctx.id}:clear`;
      };
      getControlId3 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.control) != null ? _b : `datepicker:${ctx.id}:control`;
      };
      getInputId3 = (ctx, index) => {
        var _a, _b, _c;
        return (_c = (_b = (_a = ctx.ids) == null ? void 0 : _a.input) == null ? void 0 : _b.call(_a, index)) != null ? _c : `datepicker:${ctx.id}:input:${index}`;
      };
      getTriggerId3 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.trigger) != null ? _b : `datepicker:${ctx.id}:trigger`;
      };
      getPositionerId2 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.positioner) != null ? _b : `datepicker:${ctx.id}:positioner`;
      };
      getMonthSelectId = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.monthSelect) != null ? _b : `datepicker:${ctx.id}:month-select`;
      };
      getYearSelectId = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.yearSelect) != null ? _b : `datepicker:${ctx.id}:year-select`;
      };
      getFocusedCell = (ctx, view) => query(getContentEl3(ctx), `[data-part=table-cell-trigger][data-view=${view}][data-focus]:not([data-outside-range])`);
      getTriggerEl2 = (ctx) => ctx.getById(getTriggerId3(ctx));
      getContentEl3 = (ctx) => ctx.getById(getContentId3(ctx));
      getInputEls = (ctx) => queryAll(getControlEl2(ctx), `[data-part=input]`);
      getYearSelectEl = (ctx) => ctx.getById(getYearSelectId(ctx));
      getMonthSelectEl = (ctx) => ctx.getById(getMonthSelectId(ctx));
      getClearTriggerEl2 = (ctx) => ctx.getById(getClearTriggerId2(ctx));
      getPositionerEl2 = (ctx) => ctx.getById(getPositionerId2(ctx));
      getControlEl2 = (ctx) => ctx.getById(getControlId3(ctx));
      PLACEHOLDERS = {
        day: "dd",
        month: "mm",
        year: "yyyy"
      };
      isValidCharacter = (char, separator) => {
        if (!char) return true;
        return /\d/.test(char) || char === separator || char.length !== 1;
      };
      isValidDate = (value) => {
        return !Number.isNaN(value.day) && !Number.isNaN(value.month) && !Number.isNaN(value.year);
      };
      ensureValidCharacters = (value, separator) => {
        return value.split("").filter((char) => isValidCharacter(char, separator)).join("");
      };
      defaultTranslations = {
        dayCell(state2) {
          if (state2.unavailable) return `Not available. ${state2.formattedDate}`;
          if (state2.selected) return `Selected date. ${state2.formattedDate}`;
          return `Choose ${state2.formattedDate}`;
        },
        trigger(open) {
          return open ? "Close calendar" : "Open calendar";
        },
        viewTrigger(view) {
          return match2(view, {
            year: "Switch to month view",
            month: "Switch to day view",
            day: "Switch to year view"
          });
        },
        presetTrigger(value) {
          const [start = "", end = ""] = value;
          return `select ${start} to ${end}`;
        },
        prevTrigger(view) {
          return match2(view, {
            year: "Switch to previous decade",
            month: "Switch to previous year",
            day: "Switch to previous month"
          });
        },
        nextTrigger(view) {
          return match2(view, {
            year: "Switch to next decade",
            month: "Switch to next year",
            day: "Switch to next month"
          });
        },
        // TODO: Revisit this
        placeholder() {
          return { day: "dd", month: "mm", year: "yyyy" };
        },
        content: "calendar",
        monthSelect: "Select month",
        yearSelect: "Select year",
        clearTrigger: "Clear selected dates"
      };
      views = ["day", "month", "year"];
      getVisibleRangeText = memo(
        (opts) => [opts.view, opts.startValue.toString(), opts.endValue.toString(), opts.locale],
        ([view], opts) => {
          const { startValue, endValue, locale, timeZone, selectionMode } = opts;
          if (view === "year") {
            const years = getDecadeRange(startValue.year, { strict: true });
            const start2 = years.at(0).toString();
            const end2 = years.at(-1).toString();
            return { start: start2, end: end2, formatted: `${start2} - ${end2}` };
          }
          if (view === "month") {
            const formatter2 = new $fb18d541ea1ad717$export$ad991b66133851cf(locale, { year: "numeric", timeZone });
            const start2 = formatter2.format(startValue.toDate(timeZone));
            const end2 = formatter2.format(endValue.toDate(timeZone));
            const formatted2 = selectionMode === "range" ? `${start2} - ${end2}` : start2;
            return { start: start2, end: end2, formatted: formatted2 };
          }
          const formatter = new $fb18d541ea1ad717$export$ad991b66133851cf(locale, { month: "long", year: "numeric", timeZone });
          const start = formatter.format(startValue.toDate(timeZone));
          const end = formatter.format(endValue.toDate(timeZone));
          const formatted = selectionMode === "range" ? `${start} - ${end}` : start;
          return { start, end, formatted };
        }
      );
      ({ and: and3 } = createGuards());
      machine6 = createMachine({
        props({ props: props22 }) {
          const locale = props22.locale || "en-US";
          const timeZone = props22.timeZone || "UTC";
          const selectionMode = props22.selectionMode || "single";
          const numOfMonths = props22.numOfMonths || 1;
          const defaultValue = props22.defaultValue ? sortDates(props22.defaultValue).map((date) => constrainValue(date, props22.min, props22.max)) : void 0;
          const value = props22.value ? sortDates(props22.value).map((date) => constrainValue(date, props22.min, props22.max)) : void 0;
          let focusedValue = props22.focusedValue || props22.defaultFocusedValue || (value == null ? void 0 : value[0]) || (defaultValue == null ? void 0 : defaultValue[0]) || getTodayDate(timeZone);
          focusedValue = constrainValue(focusedValue, props22.min, props22.max);
          const minView = "day";
          const maxView = "year";
          const defaultView = clampView(props22.view || minView, minView, maxView);
          return __spreadProps(__spreadValues({
            locale,
            numOfMonths,
            timeZone,
            selectionMode,
            defaultView,
            minView,
            maxView,
            outsideDaySelectable: false,
            closeOnSelect: true,
            format(date, { locale: locale2, timeZone: timeZone2 }) {
              const formatter = new $fb18d541ea1ad717$export$ad991b66133851cf(locale2, { timeZone: timeZone2, day: "2-digit", month: "2-digit", year: "numeric" });
              return formatter.format(date.toDate(timeZone2));
            },
            parse(value2, { locale: locale2, timeZone: timeZone2 }) {
              return parseDateString(value2, locale2, timeZone2);
            }
          }, props22), {
            focusedValue: typeof props22.focusedValue === "undefined" ? void 0 : focusedValue,
            defaultFocusedValue: focusedValue,
            value,
            defaultValue: defaultValue != null ? defaultValue : [],
            positioning: __spreadValues({
              placement: "bottom"
            }, props22.positioning)
          });
        },
        initialState({ prop }) {
          const open = prop("open") || prop("defaultOpen") || prop("inline");
          return open ? "open" : "idle";
        },
        refs() {
          return {
            announcer: void 0
          };
        },
        context({ prop, bindable: bindable2, getContext }) {
          return {
            focusedValue: bindable2(() => ({
              defaultValue: prop("defaultFocusedValue"),
              value: prop("focusedValue"),
              isEqual: isDateEqual,
              hash: (v2) => v2.toString(),
              sync: true,
              onChange(focusedValue) {
                var _a;
                const context = getContext();
                const view = context.get("view");
                const value = context.get("value");
                const valueAsString = getValueAsString(value, prop);
                (_a = prop("onFocusChange")) == null ? void 0 : _a({ value, valueAsString, view, focusedValue });
              }
            })),
            value: bindable2(() => ({
              defaultValue: prop("defaultValue"),
              value: prop("value"),
              isEqual: isDateArrayEqual,
              hash: (v2) => v2.map((date) => {
                var _a;
                return (_a = date == null ? void 0 : date.toString()) != null ? _a : "";
              }).join(","),
              onChange(value) {
                var _a;
                const context = getContext();
                const valueAsString = getValueAsString(value, prop);
                (_a = prop("onValueChange")) == null ? void 0 : _a({ value, valueAsString, view: context.get("view") });
              }
            })),
            inputValue: bindable2(() => ({
              defaultValue: ""
            })),
            activeIndex: bindable2(() => ({
              defaultValue: 0,
              sync: true
            })),
            hoveredValue: bindable2(() => ({
              defaultValue: null,
              isEqual: isDateEqual
            })),
            view: bindable2(() => ({
              defaultValue: prop("defaultView"),
              value: prop("view"),
              onChange(value) {
                var _a;
                (_a = prop("onViewChange")) == null ? void 0 : _a({ view: value });
              }
            })),
            startValue: bindable2(() => {
              const focusedValue = prop("focusedValue") || prop("defaultFocusedValue");
              return {
                defaultValue: alignDate(focusedValue, "start", { months: prop("numOfMonths") }, prop("locale")),
                isEqual: isDateEqual,
                hash: (v2) => v2.toString()
              };
            }),
            currentPlacement: bindable2(() => ({
              defaultValue: void 0
            })),
            restoreFocus: bindable2(() => ({
              defaultValue: false
            }))
          };
        },
        computed: {
          isInteractive: ({ prop }) => !prop("disabled") && !prop("readOnly"),
          visibleDuration: ({ prop }) => ({ months: prop("numOfMonths") }),
          endValue: ({ context, computed }) => getEndDate(context.get("startValue"), computed("visibleDuration")),
          visibleRange: ({ context, computed }) => ({ start: context.get("startValue"), end: computed("endValue") }),
          visibleRangeText: ({ context, prop, computed }) => getVisibleRangeText({
            view: context.get("view"),
            startValue: context.get("startValue"),
            endValue: computed("endValue"),
            locale: prop("locale"),
            timeZone: prop("timeZone"),
            selectionMode: prop("selectionMode")
          }),
          isPrevVisibleRangeValid: ({ context, prop }) => !isPreviousRangeInvalid(context.get("startValue"), prop("min"), prop("max")),
          isNextVisibleRangeValid: ({ prop, computed }) => !isNextRangeInvalid(computed("endValue"), prop("min"), prop("max")),
          valueAsString: ({ context, prop }) => getValueAsString(context.get("value"), prop)
        },
        effects: ["setupLiveRegion"],
        watch({ track, prop, context, action, computed }) {
          track([() => prop("locale")], () => {
            action(["setStartValue", "syncInputElement"]);
          });
          track([() => context.hash("focusedValue")], () => {
            action(["setStartValue", "focusActiveCellIfNeeded", "setHoveredValueIfKeyboard"]);
          });
          track([() => context.hash("startValue")], () => {
            action(["syncMonthSelectElement", "syncYearSelectElement", "invokeOnVisibleRangeChange"]);
          });
          track([() => context.get("inputValue")], () => {
            action(["syncInputValue"]);
          });
          track([() => context.hash("value")], () => {
            action(["syncInputElement"]);
          });
          track([() => computed("valueAsString").toString()], () => {
            action(["announceValueText"]);
          });
          track([() => context.get("view")], () => {
            action(["focusActiveCell"]);
          });
          track([() => prop("open")], () => {
            action(["toggleVisibility"]);
          });
        },
        on: {
          "VALUE.SET": {
            actions: ["setDateValue", "setFocusedDate"]
          },
          "VIEW.SET": {
            actions: ["setView"]
          },
          "FOCUS.SET": {
            actions: ["setFocusedDate"]
          },
          "VALUE.CLEAR": {
            actions: ["clearDateValue", "clearFocusedDate", "focusFirstInputElement"]
          },
          "INPUT.CHANGE": [
            {
              guard: "isInputValueEmpty",
              actions: ["setInputValue", "clearDateValue", "clearFocusedDate"]
            },
            {
              actions: ["setInputValue", "focusParsedDate"]
            }
          ],
          "INPUT.ENTER": {
            actions: ["focusParsedDate", "selectFocusedDate"]
          },
          "INPUT.FOCUS": {
            actions: ["setActiveIndex"]
          },
          "INPUT.BLUR": [
            {
              guard: "shouldFixOnBlur",
              actions: ["setActiveIndexToStart", "selectParsedDate"]
            },
            {
              actions: ["setActiveIndexToStart"]
            }
          ],
          "PRESET.CLICK": [
            {
              guard: "isOpenControlled",
              actions: ["setDateValue", "setFocusedDate", "invokeOnClose"]
            },
            {
              target: "focused",
              actions: ["setDateValue", "setFocusedDate", "focusInputElement"]
            }
          ],
          "GOTO.NEXT": [
            {
              guard: "isYearView",
              actions: ["focusNextDecade", "announceVisibleRange"]
            },
            {
              guard: "isMonthView",
              actions: ["focusNextYear", "announceVisibleRange"]
            },
            {
              actions: ["focusNextPage"]
            }
          ],
          "GOTO.PREV": [
            {
              guard: "isYearView",
              actions: ["focusPreviousDecade", "announceVisibleRange"]
            },
            {
              guard: "isMonthView",
              actions: ["focusPreviousYear", "announceVisibleRange"]
            },
            {
              actions: ["focusPreviousPage"]
            }
          ]
        },
        states: {
          idle: {
            tags: ["closed"],
            on: {
              "CONTROLLED.OPEN": {
                target: "open",
                actions: ["focusFirstSelectedDate", "focusActiveCell"]
              },
              "TRIGGER.CLICK": [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnOpen"]
                },
                {
                  target: "open",
                  actions: ["focusFirstSelectedDate", "focusActiveCell", "invokeOnOpen"]
                }
              ],
              OPEN: [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnOpen"]
                },
                {
                  target: "open",
                  actions: ["focusFirstSelectedDate", "focusActiveCell", "invokeOnOpen"]
                }
              ]
            }
          },
          focused: {
            tags: ["closed"],
            on: {
              "CONTROLLED.OPEN": {
                target: "open",
                actions: ["focusFirstSelectedDate", "focusActiveCell"]
              },
              "TRIGGER.CLICK": [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnOpen"]
                },
                {
                  target: "open",
                  actions: ["focusFirstSelectedDate", "focusActiveCell", "invokeOnOpen"]
                }
              ],
              OPEN: [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnOpen"]
                },
                {
                  target: "open",
                  actions: ["focusFirstSelectedDate", "focusActiveCell", "invokeOnOpen"]
                }
              ]
            }
          },
          open: {
            tags: ["open"],
            effects: ["trackDismissableElement", "trackPositioning"],
            exit: ["clearHoveredDate", "resetView"],
            on: {
              "CONTROLLED.CLOSE": [
                {
                  guard: and3("shouldRestoreFocus", "isInteractOutsideEvent"),
                  target: "focused",
                  actions: ["focusTriggerElement"]
                },
                {
                  guard: "shouldRestoreFocus",
                  target: "focused",
                  actions: ["focusInputElement"]
                },
                {
                  target: "idle"
                }
              ],
              "CELL.CLICK": [
                {
                  guard: "isAboveMinView",
                  actions: ["setFocusedValueForView", "setPreviousView"]
                },
                {
                  guard: and3("isRangePicker", "hasSelectedRange"),
                  actions: ["setActiveIndexToStart", "resetSelection", "setActiveIndexToEnd"]
                },
                // === Grouped transitions (based on `closeOnSelect` and `isOpenControlled`) ===
                {
                  guard: and3("isRangePicker", "isSelectingEndDate", "closeOnSelect", "isOpenControlled"),
                  actions: [
                    "setFocusedDate",
                    "setSelectedDate",
                    "setActiveIndexToStart",
                    "clearHoveredDate",
                    "invokeOnClose",
                    "setRestoreFocus"
                  ]
                },
                {
                  guard: and3("isRangePicker", "isSelectingEndDate", "closeOnSelect"),
                  target: "focused",
                  actions: [
                    "setFocusedDate",
                    "setSelectedDate",
                    "setActiveIndexToStart",
                    "clearHoveredDate",
                    "invokeOnClose",
                    "focusInputElement"
                  ]
                },
                {
                  guard: and3("isRangePicker", "isSelectingEndDate"),
                  actions: ["setFocusedDate", "setSelectedDate", "setActiveIndexToStart", "clearHoveredDate"]
                },
                // ===
                {
                  guard: "isRangePicker",
                  actions: ["setFocusedDate", "setSelectedDate", "setActiveIndexToEnd"]
                },
                {
                  guard: "isMultiPicker",
                  actions: ["setFocusedDate", "toggleSelectedDate"]
                },
                // === Grouped transitions (based on `closeOnSelect` and `isOpenControlled`) ===
                {
                  guard: and3("closeOnSelect", "isOpenControlled"),
                  actions: ["setFocusedDate", "setSelectedDate", "invokeOnClose"]
                },
                {
                  guard: "closeOnSelect",
                  target: "focused",
                  actions: ["setFocusedDate", "setSelectedDate", "invokeOnClose", "focusInputElement"]
                },
                {
                  actions: ["setFocusedDate", "setSelectedDate"]
                }
                // ===
              ],
              "CELL.POINTER_MOVE": {
                guard: and3("isRangePicker", "isSelectingEndDate"),
                actions: ["setHoveredDate", "setFocusedDate"]
              },
              "TABLE.POINTER_LEAVE": {
                guard: "isRangePicker",
                actions: ["clearHoveredDate"]
              },
              "TABLE.POINTER_DOWN": {
                actions: ["disableTextSelection"]
              },
              "TABLE.POINTER_UP": {
                actions: ["enableTextSelection"]
              },
              "TABLE.ESCAPE": [
                {
                  guard: "isOpenControlled",
                  actions: ["focusFirstSelectedDate", "invokeOnClose"]
                },
                {
                  target: "focused",
                  actions: ["focusFirstSelectedDate", "invokeOnClose", "focusTriggerElement"]
                }
              ],
              "TABLE.ENTER": [
                {
                  guard: "isAboveMinView",
                  actions: ["setPreviousView"]
                },
                {
                  guard: and3("isRangePicker", "hasSelectedRange"),
                  actions: ["setActiveIndexToStart", "clearDateValue", "setSelectedDate", "setActiveIndexToEnd"]
                },
                // === Grouped transitions (based on `closeOnSelect` and `isOpenControlled`) ===
                {
                  guard: and3("isRangePicker", "isSelectingEndDate", "closeOnSelect", "isOpenControlled"),
                  actions: ["setSelectedDate", "setActiveIndexToStart", "clearHoveredDate", "invokeOnClose"]
                },
                {
                  guard: and3("isRangePicker", "isSelectingEndDate", "closeOnSelect"),
                  target: "focused",
                  actions: [
                    "setSelectedDate",
                    "setActiveIndexToStart",
                    "clearHoveredDate",
                    "invokeOnClose",
                    "focusInputElement"
                  ]
                },
                {
                  guard: and3("isRangePicker", "isSelectingEndDate"),
                  actions: ["setSelectedDate", "setActiveIndexToStart", "clearHoveredDate"]
                },
                // ===
                {
                  guard: "isRangePicker",
                  actions: ["setSelectedDate", "setActiveIndexToEnd", "focusNextDay"]
                },
                {
                  guard: "isMultiPicker",
                  actions: ["toggleSelectedDate"]
                },
                // === Grouped transitions (based on `closeOnSelect` and `isOpenControlled`) ===
                {
                  guard: and3("closeOnSelect", "isOpenControlled"),
                  actions: ["selectFocusedDate", "invokeOnClose"]
                },
                {
                  guard: "closeOnSelect",
                  target: "focused",
                  actions: ["selectFocusedDate", "invokeOnClose", "focusInputElement"]
                },
                {
                  actions: ["selectFocusedDate"]
                }
                // ===
              ],
              "TABLE.ARROW_RIGHT": [
                {
                  guard: "isMonthView",
                  actions: ["focusNextMonth"]
                },
                {
                  guard: "isYearView",
                  actions: ["focusNextYear"]
                },
                {
                  actions: ["focusNextDay", "setHoveredDate"]
                }
              ],
              "TABLE.ARROW_LEFT": [
                {
                  guard: "isMonthView",
                  actions: ["focusPreviousMonth"]
                },
                {
                  guard: "isYearView",
                  actions: ["focusPreviousYear"]
                },
                {
                  actions: ["focusPreviousDay"]
                }
              ],
              "TABLE.ARROW_UP": [
                {
                  guard: "isMonthView",
                  actions: ["focusPreviousMonthColumn"]
                },
                {
                  guard: "isYearView",
                  actions: ["focusPreviousYearColumn"]
                },
                {
                  actions: ["focusPreviousWeek"]
                }
              ],
              "TABLE.ARROW_DOWN": [
                {
                  guard: "isMonthView",
                  actions: ["focusNextMonthColumn"]
                },
                {
                  guard: "isYearView",
                  actions: ["focusNextYearColumn"]
                },
                {
                  actions: ["focusNextWeek"]
                }
              ],
              "TABLE.PAGE_UP": {
                actions: ["focusPreviousSection"]
              },
              "TABLE.PAGE_DOWN": {
                actions: ["focusNextSection"]
              },
              "TABLE.HOME": [
                {
                  guard: "isMonthView",
                  actions: ["focusFirstMonth"]
                },
                {
                  guard: "isYearView",
                  actions: ["focusFirstYear"]
                },
                {
                  actions: ["focusSectionStart"]
                }
              ],
              "TABLE.END": [
                {
                  guard: "isMonthView",
                  actions: ["focusLastMonth"]
                },
                {
                  guard: "isYearView",
                  actions: ["focusLastYear"]
                },
                {
                  actions: ["focusSectionEnd"]
                }
              ],
              "TRIGGER.CLICK": [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnClose"]
                },
                {
                  target: "focused",
                  actions: ["invokeOnClose"]
                }
              ],
              "VIEW.TOGGLE": {
                actions: ["setNextView"]
              },
              INTERACT_OUTSIDE: [
                {
                  guard: "isOpenControlled",
                  actions: ["setActiveIndexToStart", "invokeOnClose"]
                },
                {
                  guard: "shouldRestoreFocus",
                  target: "focused",
                  actions: ["setActiveIndexToStart", "invokeOnClose", "focusTriggerElement"]
                },
                {
                  target: "idle",
                  actions: ["setActiveIndexToStart", "invokeOnClose"]
                }
              ],
              CLOSE: [
                {
                  guard: "isOpenControlled",
                  actions: ["setActiveIndexToStart", "invokeOnClose"]
                },
                {
                  target: "idle",
                  actions: ["setActiveIndexToStart", "invokeOnClose"]
                }
              ]
            }
          }
        },
        implementations: {
          guards: {
            isAboveMinView: ({ context, prop }) => isAboveMinView(context.get("view"), prop("minView")),
            isDayView: ({ context, event }) => (event.view || context.get("view")) === "day",
            isMonthView: ({ context, event }) => (event.view || context.get("view")) === "month",
            isYearView: ({ context, event }) => (event.view || context.get("view")) === "year",
            isRangePicker: ({ prop }) => prop("selectionMode") === "range",
            hasSelectedRange: ({ context }) => context.get("value").length === 2,
            isMultiPicker: ({ prop }) => prop("selectionMode") === "multiple",
            shouldRestoreFocus: ({ context }) => !!context.get("restoreFocus"),
            isSelectingEndDate: ({ context }) => context.get("activeIndex") === 1,
            closeOnSelect: ({ prop }) => !!prop("closeOnSelect"),
            isOpenControlled: ({ prop }) => prop("open") != void 0 || !!prop("inline"),
            isInteractOutsideEvent: ({ event }) => {
              var _a;
              return ((_a = event.previousEvent) == null ? void 0 : _a.type) === "INTERACT_OUTSIDE";
            },
            isInputValueEmpty: ({ event }) => event.value.trim() === "",
            shouldFixOnBlur: ({ event }) => !!event.fixOnBlur
          },
          effects: {
            trackPositioning({ context, prop, scope }) {
              if (prop("inline")) return;
              if (!context.get("currentPlacement")) {
                context.set("currentPlacement", prop("positioning").placement);
              }
              const anchorEl = getControlEl2(scope);
              const getPositionerEl22 = () => getPositionerEl2(scope);
              return getPlacement(anchorEl, getPositionerEl22, __spreadProps(__spreadValues({}, prop("positioning")), {
                defer: true,
                onComplete(data) {
                  context.set("currentPlacement", data.placement);
                }
              }));
            },
            setupLiveRegion({ scope, refs }) {
              const doc = scope.getDoc();
              refs.set("announcer", createLiveRegion({ level: "assertive", document: doc }));
              return () => {
                var _a, _b;
                return (_b = (_a = refs.get("announcer")) == null ? void 0 : _a.destroy) == null ? void 0 : _b.call(_a);
              };
            },
            trackDismissableElement({ scope, send, context, prop }) {
              if (prop("inline")) return;
              const getContentEl22 = () => getContentEl3(scope);
              return trackDismissableElement(getContentEl22, {
                type: "popover",
                defer: true,
                exclude: [...getInputEls(scope), getTriggerEl2(scope), getClearTriggerEl2(scope)],
                onInteractOutside(event) {
                  context.set("restoreFocus", !event.detail.focusable);
                },
                onDismiss() {
                  send({ type: "INTERACT_OUTSIDE" });
                },
                onEscapeKeyDown(event) {
                  event.preventDefault();
                  send({ type: "TABLE.ESCAPE", src: "dismissable" });
                }
              });
            }
          },
          actions: {
            setNextView({ context, prop }) {
              const nextView = getNextView(context.get("view"), prop("minView"), prop("maxView"));
              context.set("view", nextView);
            },
            setPreviousView({ context, prop }) {
              const prevView = getPreviousView(context.get("view"), prop("minView"), prop("maxView"));
              context.set("view", prevView);
            },
            setView({ context, event }) {
              context.set("view", event.view);
            },
            setRestoreFocus({ context }) {
              context.set("restoreFocus", true);
            },
            announceValueText({ context, prop, refs }) {
              var _a;
              const value = context.get("value");
              const locale = prop("locale");
              const timeZone = prop("timeZone");
              let announceText;
              if (prop("selectionMode") === "range") {
                const [startDate, endDate] = value;
                if (startDate && endDate) {
                  announceText = formatSelectedDate(startDate, endDate, locale, timeZone);
                } else if (startDate) {
                  announceText = formatSelectedDate(startDate, null, locale, timeZone);
                } else if (endDate) {
                  announceText = formatSelectedDate(endDate, null, locale, timeZone);
                } else {
                  announceText = "";
                }
              } else {
                announceText = value.map((date) => formatSelectedDate(date, null, locale, timeZone)).filter(Boolean).join(",");
              }
              (_a = refs.get("announcer")) == null ? void 0 : _a.announce(announceText, 3e3);
            },
            announceVisibleRange({ computed, refs }) {
              var _a;
              const { formatted } = computed("visibleRangeText");
              (_a = refs.get("announcer")) == null ? void 0 : _a.announce(formatted);
            },
            disableTextSelection({ scope }) {
              disableTextSelection({ target: getContentEl3(scope), doc: scope.getDoc() });
            },
            enableTextSelection({ scope }) {
              restoreTextSelection({ doc: scope.getDoc(), target: getContentEl3(scope) });
            },
            focusFirstSelectedDate(params) {
              const { context } = params;
              if (!context.get("value").length) return;
              setFocusedValue(params, context.get("value")[0]);
            },
            syncInputElement({ scope, computed }) {
              raf(() => {
                const inputEls = getInputEls(scope);
                inputEls.forEach((inputEl, index) => {
                  setElementValue(inputEl, computed("valueAsString")[index] || "");
                });
              });
            },
            setFocusedDate(params) {
              const { event } = params;
              const value = Array.isArray(event.value) ? event.value[0] : event.value;
              setFocusedValue(params, value);
            },
            setFocusedValueForView(params) {
              const { context, event } = params;
              setFocusedValue(params, context.get("focusedValue").set({ [context.get("view")]: event.value }));
            },
            focusNextMonth(params) {
              const { context } = params;
              setFocusedValue(params, context.get("focusedValue").add({ months: 1 }));
            },
            focusPreviousMonth(params) {
              const { context } = params;
              setFocusedValue(params, context.get("focusedValue").subtract({ months: 1 }));
            },
            setDateValue({ context, event, prop }) {
              if (!Array.isArray(event.value)) return;
              const value = event.value.map((date) => constrainValue(date, prop("min"), prop("max")));
              context.set("value", value);
            },
            clearDateValue({ context }) {
              context.set("value", []);
            },
            setSelectedDate(params) {
              var _a;
              const { context, event } = params;
              const values = Array.from(context.get("value"));
              values[context.get("activeIndex")] = normalizeValue(params, (_a = event.value) != null ? _a : context.get("focusedValue"));
              context.set("value", adjustStartAndEndDate(values));
            },
            resetSelection(params) {
              var _a;
              const { context, event } = params;
              const value = normalizeValue(params, (_a = event.value) != null ? _a : context.get("focusedValue"));
              context.set("value", [value]);
            },
            toggleSelectedDate(params) {
              var _a;
              const { context, event } = params;
              const currentValue = normalizeValue(params, (_a = event.value) != null ? _a : context.get("focusedValue"));
              const index = context.get("value").findIndex((date) => isDateEqual(date, currentValue));
              if (index === -1) {
                const values = [...context.get("value"), currentValue];
                context.set("value", sortDates(values));
              } else {
                const values = Array.from(context.get("value"));
                values.splice(index, 1);
                context.set("value", sortDates(values));
              }
            },
            setHoveredDate({ context, event }) {
              context.set("hoveredValue", event.value);
            },
            clearHoveredDate({ context }) {
              context.set("hoveredValue", null);
            },
            selectFocusedDate({ context, computed }) {
              const values = Array.from(context.get("value"));
              const activeIndex = context.get("activeIndex");
              values[activeIndex] = context.get("focusedValue").copy();
              context.set("value", adjustStartAndEndDate(values));
              const valueAsString = computed("valueAsString");
              context.set("inputValue", valueAsString[activeIndex]);
            },
            focusPreviousDay(params) {
              const { context } = params;
              const nextValue = context.get("focusedValue").subtract({ days: 1 });
              setFocusedValue(params, nextValue);
            },
            focusNextDay(params) {
              const { context } = params;
              const nextValue = context.get("focusedValue").add({ days: 1 });
              setFocusedValue(params, nextValue);
            },
            focusPreviousWeek(params) {
              const { context } = params;
              const nextValue = context.get("focusedValue").subtract({ weeks: 1 });
              setFocusedValue(params, nextValue);
            },
            focusNextWeek(params) {
              const { context } = params;
              const nextValue = context.get("focusedValue").add({ weeks: 1 });
              setFocusedValue(params, nextValue);
            },
            focusNextPage(params) {
              const { context, computed, prop } = params;
              const nextPage = getNextPage(
                context.get("focusedValue"),
                context.get("startValue"),
                computed("visibleDuration"),
                prop("locale"),
                prop("min"),
                prop("max")
              );
              setAdjustedValue(params, nextPage);
            },
            focusPreviousPage(params) {
              const { context, computed, prop } = params;
              const previousPage = getPreviousPage(
                context.get("focusedValue"),
                context.get("startValue"),
                computed("visibleDuration"),
                prop("locale"),
                prop("min"),
                prop("max")
              );
              setAdjustedValue(params, previousPage);
            },
            focusSectionStart(params) {
              const { context } = params;
              setFocusedValue(params, context.get("startValue").copy());
            },
            focusSectionEnd(params) {
              const { computed } = params;
              setFocusedValue(params, computed("endValue").copy());
            },
            focusNextSection(params) {
              const { context, event, computed, prop } = params;
              const nextSection = getNextSection(
                context.get("focusedValue"),
                context.get("startValue"),
                event.larger,
                computed("visibleDuration"),
                prop("locale"),
                prop("min"),
                prop("max")
              );
              if (!nextSection) return;
              setAdjustedValue(params, nextSection);
            },
            focusPreviousSection(params) {
              const { context, event, computed, prop } = params;
              const previousSection = getPreviousSection(
                context.get("focusedValue"),
                context.get("startValue"),
                event.larger,
                computed("visibleDuration"),
                prop("locale"),
                prop("min"),
                prop("max")
              );
              if (!previousSection) return;
              setAdjustedValue(params, previousSection);
            },
            focusNextYear(params) {
              const { context } = params;
              const nextValue = context.get("focusedValue").add({ years: 1 });
              setFocusedValue(params, nextValue);
            },
            focusPreviousYear(params) {
              const { context } = params;
              const nextValue = context.get("focusedValue").subtract({ years: 1 });
              setFocusedValue(params, nextValue);
            },
            focusNextDecade(params) {
              const { context } = params;
              const nextValue = context.get("focusedValue").add({ years: 10 });
              setFocusedValue(params, nextValue);
            },
            focusPreviousDecade(params) {
              const { context } = params;
              const nextValue = context.get("focusedValue").subtract({ years: 10 });
              setFocusedValue(params, nextValue);
            },
            clearFocusedDate(params) {
              const { prop } = params;
              setFocusedValue(params, getTodayDate(prop("timeZone")));
            },
            focusPreviousMonthColumn(params) {
              const { context, event } = params;
              const nextValue = context.get("focusedValue").subtract({ months: event.columns });
              setFocusedValue(params, nextValue);
            },
            focusNextMonthColumn(params) {
              const { context, event } = params;
              const nextValue = context.get("focusedValue").add({ months: event.columns });
              setFocusedValue(params, nextValue);
            },
            focusPreviousYearColumn(params) {
              const { context, event } = params;
              const nextValue = context.get("focusedValue").subtract({ years: event.columns });
              setFocusedValue(params, nextValue);
            },
            focusNextYearColumn(params) {
              const { context, event } = params;
              const nextValue = context.get("focusedValue").add({ years: event.columns });
              setFocusedValue(params, nextValue);
            },
            focusFirstMonth(params) {
              const { context } = params;
              const nextValue = context.get("focusedValue").set({ month: 1 });
              setFocusedValue(params, nextValue);
            },
            focusLastMonth(params) {
              const { context } = params;
              const nextValue = context.get("focusedValue").set({ month: 12 });
              setFocusedValue(params, nextValue);
            },
            focusFirstYear(params) {
              const { context } = params;
              const range = getDecadeRange(context.get("focusedValue").year);
              const nextValue = context.get("focusedValue").set({ year: range[0] });
              setFocusedValue(params, nextValue);
            },
            focusLastYear(params) {
              const { context } = params;
              const range = getDecadeRange(context.get("focusedValue").year);
              const nextValue = context.get("focusedValue").set({ year: range[range.length - 1] });
              setFocusedValue(params, nextValue);
            },
            setActiveIndex({ context, event }) {
              context.set("activeIndex", event.index);
            },
            setActiveIndexToEnd({ context }) {
              context.set("activeIndex", 1);
            },
            setActiveIndexToStart({ context }) {
              context.set("activeIndex", 0);
            },
            focusActiveCell({ scope, context }) {
              raf(() => {
                var _a;
                const view = context.get("view");
                (_a = getFocusedCell(scope, view)) == null ? void 0 : _a.focus({ preventScroll: true });
              });
            },
            focusActiveCellIfNeeded({ scope, context, event }) {
              if (!event.focus) return;
              raf(() => {
                var _a;
                const view = context.get("view");
                (_a = getFocusedCell(scope, view)) == null ? void 0 : _a.focus({ preventScroll: true });
              });
            },
            setHoveredValueIfKeyboard({ context, event, prop }) {
              if (!event.type.startsWith("TABLE.ARROW") || prop("selectionMode") !== "range" || context.get("activeIndex") === 0)
                return;
              context.set("hoveredValue", context.get("focusedValue").copy());
            },
            focusTriggerElement({ scope }) {
              raf(() => {
                var _a;
                (_a = getTriggerEl2(scope)) == null ? void 0 : _a.focus({ preventScroll: true });
              });
            },
            focusFirstInputElement({ scope }) {
              raf(() => {
                const [inputEl] = getInputEls(scope);
                inputEl == null ? void 0 : inputEl.focus({ preventScroll: true });
              });
            },
            focusInputElement({ scope }) {
              raf(() => {
                const inputEls = getInputEls(scope);
                const lastIndexWithValue = inputEls.findLastIndex((inputEl2) => inputEl2.value !== "");
                const indexToFocus = Math.max(lastIndexWithValue, 0);
                const inputEl = inputEls[indexToFocus];
                inputEl == null ? void 0 : inputEl.focus({ preventScroll: true });
                inputEl == null ? void 0 : inputEl.setSelectionRange(inputEl.value.length, inputEl.value.length);
              });
            },
            syncMonthSelectElement({ scope, context }) {
              const monthSelectEl = getMonthSelectEl(scope);
              setElementValue(monthSelectEl, context.get("startValue").month.toString());
            },
            syncYearSelectElement({ scope, context }) {
              const yearSelectEl = getYearSelectEl(scope);
              setElementValue(yearSelectEl, context.get("startValue").year.toString());
            },
            setInputValue({ context, event }) {
              if (context.get("activeIndex") !== event.index) return;
              context.set("inputValue", event.value);
            },
            syncInputValue({ scope, context, event }) {
              queueMicrotask(() => {
                var _a;
                const inputEls = getInputEls(scope);
                const idx = (_a = event.index) != null ? _a : context.get("activeIndex");
                setElementValue(inputEls[idx], context.get("inputValue"));
              });
            },
            focusParsedDate(params) {
              const { event, prop } = params;
              if (event.index == null) return;
              const parse2 = prop("parse");
              const date = parse2(event.value, { locale: prop("locale"), timeZone: prop("timeZone") });
              if (!date || !isValidDate(date)) return;
              setFocusedValue(params, date);
            },
            selectParsedDate({ context, event, prop }) {
              if (event.index == null) return;
              const parse2 = prop("parse");
              let date = parse2(event.value, { locale: prop("locale"), timeZone: prop("timeZone") });
              if (!date || !isValidDate(date)) {
                if (event.value) {
                  date = context.get("focusedValue").copy();
                }
              }
              if (!date) return;
              date = constrainValue(date, prop("min"), prop("max"));
              const values = Array.from(context.get("value"));
              values[event.index] = date;
              context.set("value", values);
              const valueAsString = getValueAsString(values, prop);
              context.set("inputValue", valueAsString[event.index]);
            },
            resetView({ context }) {
              context.set("view", context.initial("view"));
            },
            setStartValue({ context, computed, prop }) {
              const focusedValue = context.get("focusedValue");
              const outside = isDateOutsideRange(focusedValue, context.get("startValue"), computed("endValue"));
              if (!outside) return;
              const startValue = alignDate(focusedValue, "start", { months: prop("numOfMonths") }, prop("locale"));
              context.set("startValue", startValue);
            },
            invokeOnOpen({ prop, context }) {
              var _a;
              if (prop("inline")) return;
              (_a = prop("onOpenChange")) == null ? void 0 : _a({ open: true, value: context.get("value") });
            },
            invokeOnClose({ prop, context }) {
              var _a;
              if (prop("inline")) return;
              (_a = prop("onOpenChange")) == null ? void 0 : _a({ open: false, value: context.get("value") });
            },
            invokeOnVisibleRangeChange({ prop, context, computed }) {
              var _a;
              (_a = prop("onVisibleRangeChange")) == null ? void 0 : _a({
                view: context.get("view"),
                visibleRange: computed("visibleRange")
              });
            },
            toggleVisibility({ event, send, prop }) {
              send({ type: prop("open") ? "CONTROLLED.OPEN" : "CONTROLLED.CLOSE", previousEvent: event });
            }
          }
        }
      });
      normalizeValue = (ctx, value) => {
        const { context, prop } = ctx;
        const view = context.get("view");
        let dateValue = typeof value === "number" ? context.get("focusedValue").set({ [view]: value }) : value;
        eachView((view2) => {
          if (isBelowMinView(view2, prop("minView"))) {
            dateValue = dateValue.set({ [view2]: view2 === "day" ? 1 : 0 });
          }
        });
        return dateValue;
      };
      props6 = createProps()([
        "closeOnSelect",
        "dir",
        "disabled",
        "fixedWeeks",
        "focusedValue",
        "format",
        "parse",
        "placeholder",
        "getRootNode",
        "id",
        "ids",
        "inline",
        "invalid",
        "isDateUnavailable",
        "locale",
        "max",
        "min",
        "name",
        "numOfMonths",
        "onFocusChange",
        "onOpenChange",
        "onValueChange",
        "onViewChange",
        "onVisibleRangeChange",
        "open",
        "defaultOpen",
        "positioning",
        "readOnly",
        "required",
        "selectionMode",
        "startOfWeek",
        "timeZone",
        "translations",
        "value",
        "defaultView",
        "defaultValue",
        "view",
        "defaultFocusedValue",
        "outsideDaySelectable",
        "minView",
        "maxView"
      ]);
      splitProps6 = createSplitProps(props6);
      inputProps = createProps()(["index", "fixOnBlur"]);
      splitInputProps = createSplitProps(inputProps);
      presetTriggerProps = createProps()(["value"]);
      splitPresetTriggerProps = createSplitProps(presetTriggerProps);
      tableProps = createProps()(["columns", "id", "view"]);
      splitTableProps = createSplitProps(tableProps);
      tableCellProps = createProps()(["disabled", "value", "columns"]);
      splitTableCellProps = createSplitProps(tableCellProps);
      viewProps = createProps()(["view"]);
      splitViewProps = createSplitProps(viewProps);
      DatePicker = class extends Component {
        constructor() {
          super(...arguments);
          __publicField(this, "_lastView", null);
          __publicField(this, "_lastDayRangeKey", "");
          __publicField(this, "_lastMonthYear", null);
          __publicField(this, "_lastYearDecade", "");
          __publicField(this, "getDayView", () => this.el.querySelector('[data-part="day-view"]'));
          __publicField(this, "getMonthView", () => this.el.querySelector('[data-part="month-view"]'));
          __publicField(this, "getYearView", () => this.el.querySelector('[data-part="year-view"]'));
          __publicField(this, "renderDayTableHeader", () => {
            const dayView = this.getDayView();
            const thead = dayView == null ? void 0 : dayView.querySelector("thead");
            if (!thead || !this.api.weekDays) return;
            const tr = this.doc.createElement("tr");
            this.spreadProps(tr, this.api.getTableRowProps({ view: "day" }));
            this.api.weekDays.forEach((day) => {
              const th = this.doc.createElement("th");
              th.scope = "col";
              th.setAttribute("aria-label", day.long);
              th.textContent = day.narrow;
              tr.appendChild(th);
            });
            thead.innerHTML = "";
            thead.appendChild(tr);
          });
          __publicField(this, "renderDayTableBody", () => {
            const dayView = this.getDayView();
            const tbody = dayView == null ? void 0 : dayView.querySelector("tbody");
            if (!tbody) return;
            this.spreadProps(tbody, this.api.getTableBodyProps({ view: "day" }));
            if (!this.api.weeks) return;
            tbody.innerHTML = "";
            this.api.weeks.forEach((week) => {
              const tr = this.doc.createElement("tr");
              this.spreadProps(tr, this.api.getTableRowProps({ view: "day" }));
              week.forEach((value) => {
                const td = this.doc.createElement("td");
                this.spreadProps(td, this.api.getDayTableCellProps({ value }));
                const trigger = this.doc.createElement("div");
                this.spreadProps(
                  trigger,
                  this.api.getDayTableCellTriggerProps({ value })
                );
                trigger.textContent = String(value.day);
                td.appendChild(trigger);
                tr.appendChild(td);
              });
              tbody.appendChild(tr);
            });
          });
          __publicField(this, "renderMonthTableBody", () => {
            const monthView = this.getMonthView();
            const tbody = monthView == null ? void 0 : monthView.querySelector("tbody");
            if (!tbody) return;
            this.spreadProps(tbody, this.api.getTableBodyProps({ view: "month" }));
            const monthsGrid = this.api.getMonthsGrid({ columns: 4, format: "short" });
            tbody.innerHTML = "";
            monthsGrid.forEach((months) => {
              const tr = this.doc.createElement("tr");
              this.spreadProps(tr, this.api.getTableRowProps());
              months.forEach((month) => {
                const td = this.doc.createElement("td");
                this.spreadProps(
                  td,
                  this.api.getMonthTableCellProps(__spreadProps(__spreadValues({}, month), { columns: 4 }))
                );
                const trigger = this.doc.createElement("div");
                this.spreadProps(
                  trigger,
                  this.api.getMonthTableCellTriggerProps(__spreadProps(__spreadValues({}, month), { columns: 4 }))
                );
                trigger.textContent = month.label;
                td.appendChild(trigger);
                tr.appendChild(td);
              });
              tbody.appendChild(tr);
            });
          });
          __publicField(this, "renderYearTableBody", () => {
            const yearView = this.getYearView();
            const tbody = yearView == null ? void 0 : yearView.querySelector("tbody");
            if (!tbody) return;
            this.spreadProps(tbody, this.api.getTableBodyProps());
            const yearsGrid = this.api.getYearsGrid({ columns: 4 });
            tbody.innerHTML = "";
            yearsGrid.forEach((years) => {
              const tr = this.doc.createElement("tr");
              this.spreadProps(tr, this.api.getTableRowProps({ view: "year" }));
              years.forEach((year) => {
                const td = this.doc.createElement("td");
                this.spreadProps(
                  td,
                  this.api.getYearTableCellProps(__spreadProps(__spreadValues({}, year), { columns: 4 }))
                );
                const trigger = this.doc.createElement("div");
                this.spreadProps(
                  trigger,
                  this.api.getYearTableCellTriggerProps(__spreadProps(__spreadValues({}, year), { columns: 4 }))
                );
                trigger.textContent = year.label;
                td.appendChild(trigger);
                tr.appendChild(td);
              });
              tbody.appendChild(tr);
            });
          });
        }
        initMachine(props22) {
          return new VanillaMachine(machine6, __spreadValues({}, props22));
        }
        initApi() {
          return connect6(this.machine.service, normalizeProps);
        }
        render() {
          const root = this.el.querySelector(
            '[data-scope="date-picker"][data-part="root"]'
          );
          if (root) this.spreadProps(root, this.api.getRootProps());
          const label = this.el.querySelector(
            '[data-scope="date-picker"][data-part="label"]'
          );
          if (label) this.spreadProps(label, this.api.getLabelProps());
          const control = this.el.querySelector(
            '[data-scope="date-picker"][data-part="control"]'
          );
          if (control) this.spreadProps(control, this.api.getControlProps());
          const input = this.el.querySelector(
            '[data-scope="date-picker"][data-part="input"]'
          );
          if (input) {
            const inputProps2 = __spreadValues({}, this.api.getInputProps());
            const inputAriaLabel = this.el.dataset.inputAriaLabel;
            if (inputAriaLabel) {
              inputProps2["aria-label"] = inputAriaLabel;
            }
            this.spreadProps(input, inputProps2);
          }
          const trigger = this.el.querySelector(
            '[data-scope="date-picker"][data-part="trigger"]'
          );
          if (trigger) {
            const triggerProps2 = __spreadValues({}, this.api.getTriggerProps());
            const ariaLabel = this.el.dataset.triggerAriaLabel;
            if (ariaLabel) {
              triggerProps2["aria-label"] = ariaLabel;
            }
            this.spreadProps(trigger, triggerProps2);
          }
          const positioner = this.el.querySelector(
            '[data-scope="date-picker"][data-part="positioner"]'
          );
          if (positioner) this.spreadProps(positioner, this.api.getPositionerProps());
          const content = this.el.querySelector(
            '[data-scope="date-picker"][data-part="content"]'
          );
          if (content) this.spreadProps(content, this.api.getContentProps());
          if (this.api.open) {
            const dayView = this.getDayView();
            const monthView = this.getMonthView();
            const yearView = this.getYearView();
            if (dayView) dayView.hidden = this.api.view !== "day";
            if (monthView) monthView.hidden = this.api.view !== "month";
            if (yearView) yearView.hidden = this.api.view !== "year";
            if (this.api.view === "day" && dayView) {
              const viewControl = dayView.querySelector(
                '[data-part="view-control"]'
              );
              if (viewControl)
                this.spreadProps(
                  viewControl,
                  this.api.getViewControlProps({ view: "year" })
                );
              const prevTrigger = dayView.querySelector(
                '[data-part="prev-trigger"]'
              );
              if (prevTrigger)
                this.spreadProps(prevTrigger, this.api.getPrevTriggerProps());
              const viewTrigger = dayView.querySelector(
                '[data-part="view-trigger"]'
              );
              if (viewTrigger) {
                this.spreadProps(viewTrigger, this.api.getViewTriggerProps());
                viewTrigger.textContent = this.api.visibleRangeText.start;
              }
              const nextTrigger = dayView.querySelector(
                '[data-part="next-trigger"]'
              );
              if (nextTrigger)
                this.spreadProps(nextTrigger, this.api.getNextTriggerProps());
              const table = dayView.querySelector("table");
              if (table)
                this.spreadProps(table, this.api.getTableProps({ view: "day" }));
              const thead = dayView.querySelector("thead");
              if (thead)
                this.spreadProps(
                  thead,
                  this.api.getTableHeaderProps({ view: "day" })
                );
              this.renderDayTableHeader();
              this.renderDayTableBody();
            } else if (this.api.view === "month" && monthView) {
              const viewControl = monthView.querySelector(
                '[data-part="view-control"]'
              );
              if (viewControl)
                this.spreadProps(
                  viewControl,
                  this.api.getViewControlProps({ view: "month" })
                );
              const prevTrigger = monthView.querySelector(
                '[data-part="prev-trigger"]'
              );
              if (prevTrigger)
                this.spreadProps(
                  prevTrigger,
                  this.api.getPrevTriggerProps({ view: "month" })
                );
              const viewTrigger = monthView.querySelector(
                '[data-part="view-trigger"]'
              );
              if (viewTrigger) {
                this.spreadProps(
                  viewTrigger,
                  this.api.getViewTriggerProps({ view: "month" })
                );
                viewTrigger.textContent = String(this.api.visibleRange.start.year);
              }
              const nextTrigger = monthView.querySelector(
                '[data-part="next-trigger"]'
              );
              if (nextTrigger)
                this.spreadProps(
                  nextTrigger,
                  this.api.getNextTriggerProps({ view: "month" })
                );
              const table = monthView.querySelector("table");
              if (table)
                this.spreadProps(
                  table,
                  this.api.getTableProps({ view: "month", columns: 4 })
                );
              this.renderMonthTableBody();
            } else if (this.api.view === "year" && yearView) {
              const viewControl = yearView.querySelector(
                '[data-part="view-control"]'
              );
              if (viewControl)
                this.spreadProps(
                  viewControl,
                  this.api.getViewControlProps({ view: "year" })
                );
              const prevTrigger = yearView.querySelector(
                '[data-part="prev-trigger"]'
              );
              if (prevTrigger)
                this.spreadProps(
                  prevTrigger,
                  this.api.getPrevTriggerProps({ view: "year" })
                );
              const decadeText = yearView.querySelector(
                '[data-part="decade"]'
              );
              if (decadeText) {
                const decade = this.api.getDecade();
                decadeText.textContent = `${decade.start} - ${decade.end}`;
              }
              const nextTrigger = yearView.querySelector(
                '[data-part="next-trigger"]'
              );
              if (nextTrigger)
                this.spreadProps(
                  nextTrigger,
                  this.api.getNextTriggerProps({ view: "year" })
                );
              const table = yearView.querySelector("table");
              if (table)
                this.spreadProps(
                  table,
                  this.api.getTableProps({ view: "year", columns: 4 })
                );
              this.renderYearTableBody();
            }
          }
        }
      };
      DatePickerHook = {
        mounted() {
          const el = this.el;
          const pushEvent = this.pushEvent.bind(this);
          const liveSocket = this.liveSocket;
          const min4 = getString(el, "min");
          const max4 = getString(el, "max");
          const positioningJson = getString(el, "positioning");
          const parseList = (v2) => v2 ? v2.map((x2) => parse(x2)) : void 0;
          const parseOne = (v2) => v2 ? parse(v2) : void 0;
          const datePickerInstance = new DatePicker(el, __spreadProps(__spreadValues({
            id: el.id
          }, getBoolean(el, "controlled") ? { value: parseList(getStringList(el, "value")) } : { defaultValue: parseList(getStringList(el, "defaultValue")) }), {
            defaultFocusedValue: parseOne(getString(el, "focusedValue")),
            defaultView: getString(el, "defaultView", ["day", "month", "year"]),
            dir: getString(el, "dir", ["ltr", "rtl"]),
            locale: getString(el, "locale"),
            timeZone: getString(el, "timeZone"),
            disabled: getBoolean(el, "disabled"),
            readOnly: getBoolean(el, "readOnly"),
            required: getBoolean(el, "required"),
            invalid: getBoolean(el, "invalid"),
            outsideDaySelectable: getBoolean(el, "outsideDaySelectable"),
            closeOnSelect: getBoolean(el, "closeOnSelect"),
            min: min4 ? parse(min4) : void 0,
            max: max4 ? parse(max4) : void 0,
            numOfMonths: getNumber(el, "numOfMonths"),
            startOfWeek: getNumber(el, "startOfWeek"),
            fixedWeeks: getBoolean(el, "fixedWeeks"),
            selectionMode: getString(el, "selectionMode", ["single", "multiple", "range"]),
            placeholder: getString(el, "placeholder"),
            minView: getString(el, "minView", ["day", "month", "year"]),
            maxView: getString(el, "maxView", ["day", "month", "year"]),
            inline: getBoolean(el, "inline"),
            positioning: positioningJson ? JSON.parse(positioningJson) : void 0,
            onValueChange: (details) => {
              var _a;
              const isoStr = ((_a = details.value) == null ? void 0 : _a.length) ? details.value.map((d2) => toISOString(d2)).join(",") : "";
              const hiddenInput = el.querySelector(
                `#${el.id}-value`
              );
              if (hiddenInput && hiddenInput.value !== isoStr) {
                hiddenInput.value = isoStr;
                hiddenInput.dispatchEvent(new Event("input", { bubbles: true }));
                hiddenInput.dispatchEvent(new Event("change", { bubbles: true }));
              }
              const eventName = getString(el, "onValueChange");
              if (eventName && liveSocket.main.isConnected()) {
                pushEvent(eventName, {
                  id: el.id,
                  value: isoStr || null
                });
              }
            },
            onFocusChange: (details) => {
              var _a;
              const eventName = getString(el, "onFocusChange");
              if (eventName && liveSocket.main.isConnected()) {
                pushEvent(eventName, {
                  id: el.id,
                  focused: (_a = details.focused) != null ? _a : false
                });
              }
            },
            onViewChange: (details) => {
              const eventName = getString(el, "onViewChange");
              if (eventName && liveSocket.main.isConnected()) {
                pushEvent(eventName, {
                  id: el.id,
                  view: details.view
                });
              }
            },
            onVisibleRangeChange: (details) => {
              const eventName = getString(el, "onVisibleRangeChange");
              if (eventName && liveSocket.main.isConnected()) {
                pushEvent(eventName, {
                  id: el.id,
                  start: details.start,
                  end: details.end
                });
              }
            },
            onOpenChange: (details) => {
              const eventName = getString(el, "onOpenChange");
              if (eventName && liveSocket.main.isConnected()) {
                pushEvent(eventName, {
                  id: el.id,
                  open: details.open
                });
              }
            }
          }));
          datePickerInstance.init();
          this.datePicker = datePickerInstance;
          const inputWrapper = el.querySelector(
            '[data-scope="date-picker"][data-part="input-wrapper"]'
          );
          if (inputWrapper) inputWrapper.removeAttribute("data-loading");
          this.handlers = [];
          this.handlers.push(
            this.handleEvent("date_picker_set_value", (payload) => {
              const targetId = payload.date_picker_id;
              if (targetId && targetId !== el.id) return;
              datePickerInstance.api.setValue([parse(payload.value)]);
            })
          );
          this.onSetValue = (event) => {
            var _a;
            const value = (_a = event.detail) == null ? void 0 : _a.value;
            if (typeof value === "string") {
              datePickerInstance.api.setValue([parse(value)]);
            }
          };
          el.addEventListener("phx:date-picker:set-value", this.onSetValue);
        },
        updated() {
          var _a, _b;
          const el = this.el;
          const inputWrapper = el.querySelector(
            '[data-scope="date-picker"][data-part="input-wrapper"]'
          );
          if (inputWrapper) inputWrapper.removeAttribute("data-loading");
          const parseList = (v2) => v2 ? v2.map((x2) => parse(x2)) : void 0;
          const min4 = getString(el, "min");
          const max4 = getString(el, "max");
          const positioningJson = getString(el, "positioning");
          const isControlled = getBoolean(el, "controlled");
          const focusedStr = getString(el, "focusedValue");
          (_a = this.datePicker) == null ? void 0 : _a.updateProps(__spreadProps(__spreadValues({}, getBoolean(el, "controlled") ? { value: parseList(getStringList(el, "value")) } : { defaultValue: parseList(getStringList(el, "defaultValue")) }), {
            defaultFocusedValue: focusedStr ? parse(focusedStr) : void 0,
            defaultView: getString(el, "defaultView", ["day", "month", "year"]),
            dir: getString(this.el, "dir", ["ltr", "rtl"]),
            locale: getString(this.el, "locale"),
            timeZone: getString(this.el, "timeZone"),
            disabled: getBoolean(this.el, "disabled"),
            readOnly: getBoolean(this.el, "readOnly"),
            required: getBoolean(this.el, "required"),
            invalid: getBoolean(this.el, "invalid"),
            outsideDaySelectable: getBoolean(this.el, "outsideDaySelectable"),
            closeOnSelect: getBoolean(this.el, "closeOnSelect"),
            min: min4 ? parse(min4) : void 0,
            max: max4 ? parse(max4) : void 0,
            numOfMonths: getNumber(this.el, "numOfMonths"),
            startOfWeek: getNumber(this.el, "startOfWeek"),
            fixedWeeks: getBoolean(this.el, "fixedWeeks"),
            selectionMode: getString(this.el, "selectionMode", ["single", "multiple", "range"]),
            placeholder: getString(this.el, "placeholder"),
            minView: getString(this.el, "minView", ["day", "month", "year"]),
            maxView: getString(this.el, "maxView", ["day", "month", "year"]),
            inline: getBoolean(this.el, "inline"),
            positioning: positioningJson ? JSON.parse(positioningJson) : void 0
          }));
          if (isControlled && this.datePicker) {
            const serverValues = getStringList(el, "value");
            const serverIso = (_b = serverValues == null ? void 0 : serverValues.join(",")) != null ? _b : "";
            const zagValue = this.datePicker.api.value;
            const zagIso = (zagValue == null ? void 0 : zagValue.length) ? zagValue.map((d2) => toISOString(d2)).join(",") : "";
            if (serverIso !== zagIso) {
              const parsed = (serverValues == null ? void 0 : serverValues.length) ? serverValues.map((x2) => parse(x2)) : [];
              this.datePicker.api.setValue(parsed);
            }
          }
        },
        destroyed() {
          var _a;
          if (this.onSetValue) {
            this.el.removeEventListener("phx:date-picker:set-value", this.onSetValue);
          }
          if (this.handlers) {
            for (const handler of this.handlers) {
              this.removeHandleEvent(handler);
            }
          }
          (_a = this.datePicker) == null ? void 0 : _a.destroy();
        }
      };
    }
  });

  // ../priv/static/dialog.mjs
  var dialog_exports = {};
  __export(dialog_exports, {
    Dialog: () => DialogHook
  });
  function ariaHidden(targetsOrFn, options = {}) {
    const { defer = true } = options;
    const func = defer ? raf2 : (v2) => v2();
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
      cleanups.forEach((fn) => fn == null ? void 0 : fn());
    };
  }
  function trapFocus(el, options = {}) {
    let trap;
    const cleanup = raf(() => {
      const elements = Array.isArray(el) ? el : [el];
      const resolvedElements = elements.map((e2) => typeof e2 === "function" ? e2() : e2).filter((e2) => e2 != null);
      if (resolvedElements.length === 0) return;
      const primaryEl = resolvedElements[0];
      trap = new FocusTrap(resolvedElements, __spreadProps(__spreadValues({
        escapeDeactivates: false,
        allowOutsideClick: true,
        preventScroll: true,
        returnFocusOnDeactivate: true,
        delayInitialFocus: false,
        fallbackFocus: primaryEl
      }, options), {
        document: getDocument(primaryEl)
      }));
      try {
        trap.activate();
      } catch (e2) {
      }
    });
    return function destroy() {
      trap == null ? void 0 : trap.deactivate();
      cleanup();
    };
  }
  function getPaddingProperty(documentElement) {
    const documentLeft = documentElement.getBoundingClientRect().left;
    const scrollbarX = Math.round(documentLeft) + documentElement.scrollLeft;
    return scrollbarX ? "paddingLeft" : "paddingRight";
  }
  function hasStableScrollbarGutter(element) {
    const styles = getComputedStyle2(element);
    const scrollbarGutter = styles == null ? void 0 : styles.scrollbarGutter;
    return scrollbarGutter === "stable" || (scrollbarGutter == null ? void 0 : scrollbarGutter.startsWith("stable ")) === true;
  }
  function preventBodyScroll(_document) {
    var _a;
    const doc = _document != null ? _document : document;
    const win = (_a = doc.defaultView) != null ? _a : window;
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
      var _a2, _b;
      const { scrollX, scrollY, visualViewport } = win;
      const offsetLeft = (_a2 = visualViewport == null ? void 0 : visualViewport.offsetLeft) != null ? _a2 : 0;
      const offsetTop = (_b = visualViewport == null ? void 0 : visualViewport.offsetTop) != null ? _b : 0;
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
        restoreStyle == null ? void 0 : restoreStyle();
        win.scrollTo({ left: scrollX, top: scrollY, behavior: "instant" });
      };
    };
    const cleanups = [setScrollbarWidthProperty(), isIos() ? setBodyStyleIOS() : setBodyStyle()];
    return () => {
      cleanups.forEach((fn) => fn == null ? void 0 : fn());
      body.removeAttribute(LOCK_CLASSNAME);
    };
  }
  function connect7(service, normalize) {
    const { state: state2, send, context, prop, scope } = service;
    const ariaLabel = prop("aria-label");
    const open = state2.matches("open");
    return {
      open,
      setOpen(nextOpen) {
        const open2 = state2.matches("open");
        if (open2 === nextOpen) return;
        send({ type: nextOpen ? "OPEN" : "CLOSE" });
      },
      getTriggerProps() {
        return normalize.button(__spreadProps(__spreadValues({}, parts7.trigger.attrs), {
          dir: prop("dir"),
          id: getTriggerId4(scope),
          "aria-haspopup": "dialog",
          type: "button",
          "aria-expanded": open,
          "data-state": open ? "open" : "closed",
          "aria-controls": getContentId4(scope),
          onClick(event) {
            if (event.defaultPrevented) return;
            send({ type: "TOGGLE" });
          }
        }));
      },
      getBackdropProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts7.backdrop.attrs), {
          dir: prop("dir"),
          hidden: !open,
          id: getBackdropId(scope),
          "data-state": open ? "open" : "closed"
        }));
      },
      getPositionerProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts7.positioner.attrs), {
          dir: prop("dir"),
          id: getPositionerId3(scope),
          style: {
            pointerEvents: open ? void 0 : "none"
          }
        }));
      },
      getContentProps() {
        const rendered = context.get("rendered");
        return normalize.element(__spreadProps(__spreadValues({}, parts7.content.attrs), {
          dir: prop("dir"),
          role: prop("role"),
          hidden: !open,
          id: getContentId4(scope),
          tabIndex: -1,
          "data-state": open ? "open" : "closed",
          "aria-modal": true,
          "aria-label": ariaLabel || void 0,
          "aria-labelledby": ariaLabel || !rendered.title ? void 0 : getTitleId(scope),
          "aria-describedby": rendered.description ? getDescriptionId(scope) : void 0
        }));
      },
      getTitleProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts7.title.attrs), {
          dir: prop("dir"),
          id: getTitleId(scope)
        }));
      },
      getDescriptionProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts7.description.attrs), {
          dir: prop("dir"),
          id: getDescriptionId(scope)
        }));
      },
      getCloseTriggerProps() {
        return normalize.button(__spreadProps(__spreadValues({}, parts7.closeTrigger.attrs), {
          dir: prop("dir"),
          id: getCloseTriggerId(scope),
          type: "button",
          onClick(event) {
            if (event.defaultPrevented) return;
            event.stopPropagation();
            send({ type: "CLOSE" });
          }
        }));
      }
    };
  }
  var counterMap, uncontrolledNodes, markerMap, lockCount, unwrapHost, correctTargets, ignoreableNodes, isIgnoredNode, walkTreeOutside, getParentNode3, hideOthers, raf2, __defProp5, __defNormalProp5, __publicField5, activeFocusTraps, sharedTrapStack, FocusTrap, isKeyboardEvent, isTabEvent, isKeyForward, isKeyBackward, valueOrHandler, isEscapeEvent, delay, isSelectableInput, LOCK_CLASSNAME, anatomy7, parts7, getPositionerId3, getBackdropId, getContentId4, getTriggerId4, getTitleId, getDescriptionId, getCloseTriggerId, getContentEl4, getPositionerEl3, getBackdropEl, getTriggerEl3, getTitleEl, getDescriptionEl, getCloseTriggerEl, machine7, props7, splitProps7, Dialog, DialogHook;
  var init_dialog = __esm({
    "../priv/static/dialog.mjs"() {
      "use strict";
      init_chunk_BPSX7Z7Y();
      init_chunk_GFGFZBBD();
      counterMap = /* @__PURE__ */ new WeakMap();
      uncontrolledNodes = /* @__PURE__ */ new WeakMap();
      markerMap = {};
      lockCount = 0;
      unwrapHost = (node) => node && (node.host || unwrapHost(node.parentNode));
      correctTargets = (parent, targets) => targets.map((target) => {
        if (parent.contains(target)) return target;
        const correctedTarget = unwrapHost(target);
        if (correctedTarget && parent.contains(correctedTarget)) {
          return correctedTarget;
        }
        console.error("[zag-js > ariaHidden] target", target, "in not contained inside", parent, ". Doing nothing");
        return null;
      }).filter((x2) => Boolean(x2));
      ignoreableNodes = /* @__PURE__ */ new Set(["script", "output", "status", "next-route-announcer"]);
      isIgnoredNode = (node) => {
        if (ignoreableNodes.has(node.localName)) return true;
        if (node.role === "status") return true;
        if (node.hasAttribute("aria-live")) return true;
        return node.matches("[data-live-announcer]");
      };
      walkTreeOutside = (originalTarget, props22) => {
        const { parentNode, markerName, controlAttribute, followControlledElements = true } = props22;
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
              } catch (e2) {
                console.error("[zag-js > ariaHidden] cannot operate on ", node, e2);
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
      getParentNode3 = (originalTarget) => {
        const target = Array.isArray(originalTarget) ? originalTarget[0] : originalTarget;
        return target.ownerDocument.body;
      };
      hideOthers = (originalTarget, parentNode = getParentNode3(originalTarget), markerName = "data-aria-hidden", followControlledElements = true) => {
        if (!parentNode) return;
        return walkTreeOutside(originalTarget, {
          parentNode,
          markerName,
          controlAttribute: "aria-hidden",
          followControlledElements
        });
      };
      raf2 = (fn) => {
        const frameId = requestAnimationFrame(() => fn());
        return () => cancelAnimationFrame(frameId);
      };
      __defProp5 = Object.defineProperty;
      __defNormalProp5 = (obj, key, value) => key in obj ? __defProp5(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
      __publicField5 = (obj, key, value) => __defNormalProp5(obj, typeof key !== "symbol" ? key + "" : key, value);
      activeFocusTraps = {
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
      sharedTrapStack = [];
      FocusTrap = class {
        constructor(elements, options) {
          __publicField5(this, "trapStack");
          __publicField5(this, "config");
          __publicField5(this, "doc");
          __publicField5(this, "state", {
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
          __publicField5(this, "portalContainers", /* @__PURE__ */ new Set());
          __publicField5(this, "listenerCleanups", []);
          __publicField5(this, "handleFocus", (event) => {
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
                  if (!this.state.containerGroups.some((g2) => g2.tabbableNodes.some((n2) => getTabIndex(n2) > 0))) {
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
          __publicField5(this, "handlePointerDown", (event) => {
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
          __publicField5(this, "handleClick", (event) => {
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
          __publicField5(this, "handleTabKey", (event) => {
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
          __publicField5(this, "handleEscapeKey", (event) => {
            if (isEscapeEvent(event) && valueOrHandler(this.config.escapeDeactivates, event) !== false) {
              event.preventDefault();
              this.deactivate();
            }
          });
          __publicField5(this, "_mutationObserver");
          __publicField5(this, "setupMutationObserver", () => {
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
                    if (element.id && !this.state.containers.some((c2) => c2.contains(element))) {
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
          __publicField5(this, "updateObservedNodes", () => {
            var _a;
            (_a = this._mutationObserver) == null ? void 0 : _a.disconnect();
            if (this.state.active && !this.state.paused) {
              this.state.containers.map((container) => {
                var _a2;
                (_a2 = this._mutationObserver) == null ? void 0 : _a2.observe(container, {
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
          __publicField5(this, "getInitialFocusNode", () => {
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
          __publicField5(this, "tryFocus", (node) => {
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
          __publicField5(this, "deactivate", (deactivateOptions) => {
            if (!this.state.active) return this;
            const options2 = __spreadValues({
              onDeactivate: this.config.onDeactivate,
              onPostDeactivate: this.config.onPostDeactivate,
              checkCanReturnFocus: this.config.checkCanReturnFocus
            }, deactivateOptions);
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
            onDeactivate == null ? void 0 : onDeactivate();
            const finishDeactivation = () => {
              delay(() => {
                if (returnFocus) {
                  const returnFocusNode = this.getReturnFocusNode(this.state.nodeFocusedBeforeActivation);
                  this.tryFocus(returnFocusNode);
                }
                onPostDeactivate == null ? void 0 : onPostDeactivate();
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
          __publicField5(this, "pause", (pauseOptions) => {
            if (this.state.paused || !this.state.active) {
              return this;
            }
            const onPause = this.getOption(pauseOptions, "onPause");
            const onPostPause = this.getOption(pauseOptions, "onPostPause");
            this.state.paused = true;
            onPause == null ? void 0 : onPause();
            this.removeListeners();
            this.updateObservedNodes();
            onPostPause == null ? void 0 : onPostPause();
            return this;
          });
          __publicField5(this, "unpause", (unpauseOptions) => {
            if (!this.state.paused || !this.state.active) {
              return this;
            }
            const onUnpause = this.getOption(unpauseOptions, "onUnpause");
            const onPostUnpause = this.getOption(unpauseOptions, "onPostUnpause");
            this.state.paused = false;
            onUnpause == null ? void 0 : onUnpause();
            this.updateTabbableNodes();
            this.addListeners();
            this.updateObservedNodes();
            onPostUnpause == null ? void 0 : onPostUnpause();
            return this;
          });
          __publicField5(this, "updateContainerElements", (containerElements) => {
            this.state.containers = Array.isArray(containerElements) ? containerElements.filter(Boolean) : [containerElements].filter(Boolean);
            if (this.state.active) {
              this.updateTabbableNodes();
            }
            this.updateObservedNodes();
            return this;
          });
          __publicField5(this, "getReturnFocusNode", (previousActiveElement) => {
            const node = this.getNodeForOption("setReturnFocus", {
              params: [previousActiveElement]
            });
            return node ? node : node === false ? false : previousActiveElement;
          });
          __publicField5(this, "getOption", (configOverrideOptions, optionName, configOptionName) => {
            return configOverrideOptions && configOverrideOptions[optionName] !== void 0 ? configOverrideOptions[optionName] : (
              // @ts-expect-error
              this.config[configOptionName || optionName]
            );
          });
          __publicField5(this, "getNodeForOption", (optionName, { hasFallback = false, params = [] } = {}) => {
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
          __publicField5(this, "findNextNavNode", (opts) => {
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
                if (startOfGroupIndex < 0 && ((containerGroup == null ? void 0 : containerGroup.container) === target || isFocusable(target) && !isTabbable(target) && !(containerGroup == null ? void 0 : containerGroup.nextTabbableNode(target, false)))) {
                  startOfGroupIndex = containerIndex;
                }
                if (startOfGroupIndex >= 0) {
                  const destinationGroupIndex = startOfGroupIndex === 0 ? this.state.tabbableGroups.length - 1 : startOfGroupIndex - 1;
                  const destinationGroup = this.state.tabbableGroups[destinationGroupIndex];
                  destinationNode = getTabIndex(target) >= 0 ? destinationGroup.lastTabbableNode : destinationGroup.lastDomTabbableNode;
                } else if (!isTabEvent(event)) {
                  destinationNode = containerGroup == null ? void 0 : containerGroup.nextTabbableNode(target, false);
                }
              } else {
                let lastOfGroupIndex = this.state.tabbableGroups.findIndex(
                  ({ lastTabbableNode }) => target === lastTabbableNode
                );
                if (lastOfGroupIndex < 0 && ((containerGroup == null ? void 0 : containerGroup.container) === target || isFocusable(target) && !isTabbable(target) && !(containerGroup == null ? void 0 : containerGroup.nextTabbableNode(target)))) {
                  lastOfGroupIndex = containerIndex;
                }
                if (lastOfGroupIndex >= 0) {
                  const destinationGroupIndex = lastOfGroupIndex === this.state.tabbableGroups.length - 1 ? 0 : lastOfGroupIndex + 1;
                  const destinationGroup = this.state.tabbableGroups[destinationGroupIndex];
                  destinationNode = getTabIndex(target) >= 0 ? destinationGroup.firstTabbableNode : destinationGroup.firstDomTabbableNode;
                } else if (!isTabEvent(event)) {
                  destinationNode = containerGroup == null ? void 0 : containerGroup.nextTabbableNode(target);
                }
              }
            } else {
              destinationNode = this.getNodeForOption("fallbackFocus");
            }
            return destinationNode;
          });
          this.trapStack = options.trapStack || sharedTrapStack;
          const config = __spreadValues({
            returnFocusOnDeactivate: true,
            escapeDeactivates: true,
            delayInitialFocus: true,
            followControlledElements: true,
            isKeyForward,
            isKeyBackward
          }, options);
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
          var _a;
          (_a = this._mutationObserver) == null ? void 0 : _a.observe(portalContainer, {
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
          const composedPath = typeof (event == null ? void 0 : event.composedPath) === "function" ? event.composedPath() : void 0;
          return this.state.containerGroups.findIndex(
            ({ container, tabbableNodes }) => container.contains(element) || (composedPath == null ? void 0 : composedPath.includes(container)) || tabbableNodes.find((node) => node === element) || this.isControlledElement(container, element)
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
            for (let i2 = 0; i2 < tabbableNodes.length; i2++) {
              if (getTabIndex(tabbableNodes[i2]) > 0) {
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
                for (let i2 = focusableIdx + 1; i2 < focusableNodes.length; i2++) {
                  if (isTabbable(focusableNodes[i2])) return focusableNodes[i2];
                }
              } else {
                for (let i2 = focusableIdx - 1; i2 >= 0; i2--) {
                  if (isTabbable(focusableNodes[i2])) return focusableNodes[i2];
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
          this.state.tabbableGroups = this.state.containerGroups.filter((group2) => group2.tabbableNodes.length > 0);
          if (this.state.tabbableGroups.length <= 0 && !this.getNodeForOption("fallbackFocus")) {
            throw new Error(
              "Your focus-trap must have at least one container with at least one tabbable node in it at all times"
            );
          }
          if (this.state.containerGroups.find((g2) => g2.posTabIndexesFound) && this.state.containerGroups.length > 1) {
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
          onActivate == null ? void 0 : onActivate();
          const finishActivation = () => {
            if (checkCanFocusTrap) {
              this.updateTabbableNodes();
            }
            this.addListeners();
            this.updateObservedNodes();
            onPostActivate == null ? void 0 : onPostActivate();
          };
          if (checkCanFocusTrap) {
            checkCanFocusTrap(this.state.containers.concat()).then(finishActivation, finishActivation);
            return this;
          }
          finishActivation();
          return this;
        }
      };
      isKeyboardEvent = (event) => event.type === "keydown";
      isTabEvent = (event) => isKeyboardEvent(event) && (event == null ? void 0 : event.key) === "Tab";
      isKeyForward = (e2) => isKeyboardEvent(e2) && e2.key === "Tab" && !(e2 == null ? void 0 : e2.shiftKey);
      isKeyBackward = (e2) => isKeyboardEvent(e2) && e2.key === "Tab" && (e2 == null ? void 0 : e2.shiftKey);
      valueOrHandler = (value, ...params) => typeof value === "function" ? value(...params) : value;
      isEscapeEvent = (event) => !event.isComposing && event.key === "Escape";
      delay = (fn) => setTimeout(fn, 0);
      isSelectableInput = (node) => node.localName === "input" && "select" in node && typeof node.select === "function";
      LOCK_CLASSNAME = "data-scroll-lock";
      anatomy7 = createAnatomy("dialog").parts(
        "trigger",
        "backdrop",
        "positioner",
        "content",
        "title",
        "description",
        "closeTrigger"
      );
      parts7 = anatomy7.build();
      getPositionerId3 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.positioner) != null ? _b : `dialog:${ctx.id}:positioner`;
      };
      getBackdropId = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.backdrop) != null ? _b : `dialog:${ctx.id}:backdrop`;
      };
      getContentId4 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.content) != null ? _b : `dialog:${ctx.id}:content`;
      };
      getTriggerId4 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.trigger) != null ? _b : `dialog:${ctx.id}:trigger`;
      };
      getTitleId = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.title) != null ? _b : `dialog:${ctx.id}:title`;
      };
      getDescriptionId = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.description) != null ? _b : `dialog:${ctx.id}:description`;
      };
      getCloseTriggerId = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.closeTrigger) != null ? _b : `dialog:${ctx.id}:close`;
      };
      getContentEl4 = (ctx) => ctx.getById(getContentId4(ctx));
      getPositionerEl3 = (ctx) => ctx.getById(getPositionerId3(ctx));
      getBackdropEl = (ctx) => ctx.getById(getBackdropId(ctx));
      getTriggerEl3 = (ctx) => ctx.getById(getTriggerId4(ctx));
      getTitleEl = (ctx) => ctx.getById(getTitleId(ctx));
      getDescriptionEl = (ctx) => ctx.getById(getDescriptionId(ctx));
      getCloseTriggerEl = (ctx) => ctx.getById(getCloseTriggerId(ctx));
      machine7 = createMachine({
        props({ props: props22, scope }) {
          const alertDialog = props22.role === "alertdialog";
          const initialFocusEl = alertDialog ? () => getCloseTriggerEl(scope) : void 0;
          const modal = typeof props22.modal === "boolean" ? props22.modal : true;
          return __spreadValues({
            role: "dialog",
            modal,
            trapFocus: modal,
            preventScroll: modal,
            closeOnInteractOutside: !alertDialog,
            closeOnEscape: true,
            restoreFocus: true,
            initialFocusEl
          }, props22);
        },
        initialState({ prop }) {
          const open = prop("open") || prop("defaultOpen");
          return open ? "open" : "closed";
        },
        context({ bindable: bindable2 }) {
          return {
            rendered: bindable2(() => ({
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
              const getContentEl22 = () => getContentEl4(scope);
              return trackDismissableElement(getContentEl22, {
                type: "dialog",
                defer: true,
                pointerBlocking: prop("modal"),
                exclude: [getTriggerEl3(scope)],
                onInteractOutside(event) {
                  var _a;
                  (_a = prop("onInteractOutside")) == null ? void 0 : _a(event);
                  if (!prop("closeOnInteractOutside")) {
                    event.preventDefault();
                  }
                },
                persistentElements: prop("persistentElements"),
                onFocusOutside: prop("onFocusOutside"),
                onPointerDownOutside: prop("onPointerDownOutside"),
                onRequestDismiss: prop("onRequestDismiss"),
                onEscapeKeyDown(event) {
                  var _a;
                  (_a = prop("onEscapeKeyDown")) == null ? void 0 : _a(event);
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
              const contentEl = () => getContentEl4(scope);
              return trapFocus(contentEl, {
                preventScroll: true,
                returnFocusOnDeactivate: !!prop("restoreFocus"),
                initialFocus: prop("initialFocusEl"),
                setReturnFocus: (el) => {
                  var _a, _b;
                  return (_b = (_a = prop("finalFocusEl")) == null ? void 0 : _a()) != null ? _b : el;
                },
                getShadowRoot: true
              });
            },
            hideContentBelow({ scope, prop }) {
              if (!prop("modal")) return;
              const getElements4 = () => [getContentEl4(scope)];
              return ariaHidden(getElements4, { defer: true });
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
                const contentEl = getContentEl4(scope);
                if (!contentEl) return;
                const styles = getComputedStyle2(contentEl);
                const elems = [getPositionerEl3(scope), getBackdropEl(scope)];
                elems.forEach((node) => {
                  node == null ? void 0 : node.style.setProperty("--z-index", styles.zIndex);
                  node == null ? void 0 : node.style.setProperty("--layer-index", styles.getPropertyValue("--layer-index"));
                });
              });
            },
            invokeOnClose({ prop }) {
              var _a;
              (_a = prop("onOpenChange")) == null ? void 0 : _a({ open: false });
            },
            invokeOnOpen({ prop }) {
              var _a;
              (_a = prop("onOpenChange")) == null ? void 0 : _a({ open: true });
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
      props7 = createProps()([
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
      splitProps7 = createSplitProps(props7);
      Dialog = class extends Component {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        initMachine(props22) {
          return new VanillaMachine(machine7, props22);
        }
        initApi() {
          return connect7(this.machine.service, normalizeProps);
        }
        getPart(part) {
          const rootEl = this.el;
          const inRoot = rootEl.querySelector(
            `[data-scope="dialog"][data-part="${part}"]`
          );
          if (inRoot) return inRoot;
          const byId = this.doc.getElementById(`dialog:${rootEl.id}:${part}`);
          if (byId) return byId;
          const portalWrap = this.doc.getElementById(
            `_lv_portal_wrap_dialog:${rootEl.id}:portal`
          );
          if (portalWrap) {
            const inWrap = portalWrap.querySelector(
              `[data-scope="dialog"][data-part="${part}"]`
            );
            if (inWrap) return inWrap;
          }
          return null;
        }
        render() {
          const triggerEl = this.getPart("trigger");
          if (triggerEl) this.spreadProps(triggerEl, this.api.getTriggerProps());
          const backdropEl = this.getPart("backdrop");
          if (backdropEl) this.spreadProps(backdropEl, this.api.getBackdropProps());
          const positionerEl = this.getPart("positioner");
          if (positionerEl) {
            this.spreadProps(positionerEl, this.api.getPositionerProps());
            positionerEl.hidden = !this.api.open;
            positionerEl.dataset.state = this.api.open ? "open" : "closed";
          }
          const contentEl = this.getPart("content");
          if (contentEl) this.spreadProps(contentEl, this.api.getContentProps());
          const titleEl = this.getPart("title");
          if (titleEl) this.spreadProps(titleEl, this.api.getTitleProps());
          const descriptionEl = this.getPart("description");
          if (descriptionEl) this.spreadProps(descriptionEl, this.api.getDescriptionProps());
          const closeTriggerEl = this.getPart("close-trigger");
          if (closeTriggerEl) this.spreadProps(closeTriggerEl, this.api.getCloseTriggerProps());
        }
      };
      DialogHook = {
        mounted() {
          const el = this.el;
          const pushEvent = this.pushEvent.bind(this);
          const dialog = new Dialog(el, __spreadProps(__spreadValues({
            id: el.id
          }, getBoolean(el, "controlled") ? { open: getBoolean(el, "open") } : { defaultOpen: getBoolean(el, "defaultOpen") }), {
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
          }));
          dialog.init();
          this.dialog = dialog;
          requestAnimationFrame(() => {
            requestAnimationFrame(() => {
              var _a;
              (_a = this.dialog) == null ? void 0 : _a.render();
            });
          });
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
          var _a;
          (_a = this.dialog) == null ? void 0 : _a.updateProps(__spreadProps(__spreadValues({
            id: this.el.id
          }, getBoolean(this.el, "controlled") ? { open: getBoolean(this.el, "open") } : { defaultOpen: getBoolean(this.el, "defaultOpen") }), {
            modal: getBoolean(this.el, "modal"),
            closeOnInteractOutside: getBoolean(this.el, "closeOnInteractOutside"),
            closeOnEscape: getBoolean(this.el, "closeOnEscapeKeyDown"),
            preventScroll: getBoolean(this.el, "preventScroll"),
            restoreFocus: getBoolean(this.el, "restoreFocus"),
            dir: getString(this.el, "dir", ["ltr", "rtl"])
          }));
        },
        destroyed() {
          var _a;
          if (this.onSetOpen) {
            this.el.removeEventListener("phx:dialog:set-open", this.onSetOpen);
          }
          if (this.handlers) {
            for (const handler of this.handlers) {
              this.removeHandleEvent(handler);
            }
          }
          (_a = this.dialog) == null ? void 0 : _a.destroy();
        }
      };
    }
  });

  // ../priv/static/menu.mjs
  var menu_exports = {};
  __export(menu_exports, {
    Menu: () => MenuHook
  });
  function createRect(r2) {
    const { x: x2, y: y2, width, height } = r2;
    const midX = x2 + width / 2;
    const midY = y2 + height / 2;
    return {
      x: x2,
      y: y2,
      width,
      height,
      minX: x2,
      minY: y2,
      maxX: x2 + width,
      maxY: y2 + height,
      midX,
      midY,
      center: createPoint(midX, midY)
    };
  }
  function getRectCorners(v2) {
    const top = createPoint(v2.minX, v2.minY);
    const right = createPoint(v2.maxX, v2.minY);
    const bottom = createPoint(v2.maxX, v2.maxY);
    const left = createPoint(v2.minX, v2.maxY);
    return { top, right, bottom, left };
  }
  function getElementPolygon(rectValue, placement) {
    const rect = createRect(rectValue);
    const { top, right, left, bottom } = getRectCorners(rect);
    const [base] = placement.split("-");
    return {
      top: [left, top, right, bottom],
      right: [top, right, bottom, left],
      bottom: [top, left, bottom, right],
      left: [right, top, left, bottom]
    }[base];
  }
  function isPointInPolygon(polygon, point) {
    const { x: x2, y: y2 } = point;
    let c2 = false;
    for (let i2 = 0, j2 = polygon.length - 1; i2 < polygon.length; j2 = i2++) {
      const xi = polygon[i2].x;
      const yi = polygon[i2].y;
      const xj = polygon[j2].x;
      const yj = polygon[j2].y;
      if (yi > y2 !== yj > y2 && x2 < (xj - xi) * (y2 - yi) / (yj - yi) + xi) {
        c2 = !c2;
      }
    }
    return c2;
  }
  function dispatchSelectionEvent(el, value) {
    if (!el) return;
    const win = getWindow(el);
    const event = new win.CustomEvent(itemSelectEvent, { detail: { value } });
    el.dispatchEvent(event);
  }
  function connect8(service, normalize) {
    const { context, send, state: state2, computed, prop, scope } = service;
    const open = state2.hasTag("open");
    const isSubmenu = context.get("isSubmenu");
    const isTypingAhead = computed("isTypingAhead");
    const composite = prop("composite");
    const currentPlacement = context.get("currentPlacement");
    const anchorPoint = context.get("anchorPoint");
    const highlightedValue = context.get("highlightedValue");
    const popperStyles = getPlacementStyles(__spreadProps(__spreadValues({}, prop("positioning")), {
      placement: anchorPoint ? "bottom" : currentPlacement
    }));
    function getItemState(props22) {
      return {
        id: getItemId3(scope, props22.value),
        disabled: !!props22.disabled,
        highlighted: highlightedValue === props22.value
      };
    }
    function getOptionItemProps(props22) {
      var _a;
      const valueText = (_a = props22.valueText) != null ? _a : props22.value;
      return __spreadProps(__spreadValues({}, props22), { id: props22.value, valueText });
    }
    function getOptionItemState(props22) {
      const itemState = getItemState(getOptionItemProps(props22));
      return __spreadProps(__spreadValues({}, itemState), {
        checked: !!props22.checked
      });
    }
    function getItemProps(props22) {
      const { closeOnSelect, valueText, value } = props22;
      const itemState = getItemState(props22);
      const id = getItemId3(scope, value);
      return normalize.element(__spreadProps(__spreadValues({}, parts8.item.attrs), {
        id,
        role: "menuitem",
        "aria-disabled": ariaAttr(itemState.disabled),
        "data-disabled": dataAttr(itemState.disabled),
        "data-ownedby": getContentId5(scope),
        "data-highlighted": dataAttr(itemState.highlighted),
        "data-value": value,
        "data-valuetext": valueText,
        onDragStart(event) {
          const isLink = event.currentTarget.matches("a[href]");
          if (isLink) event.preventDefault();
        },
        onPointerMove(event) {
          if (itemState.disabled) return;
          if (event.pointerType !== "mouse") return;
          const target = event.currentTarget;
          if (itemState.highlighted) return;
          const point = getEventPoint(event);
          send({ type: "ITEM_POINTERMOVE", id, target, closeOnSelect, point });
        },
        onPointerLeave(event) {
          var _a;
          if (itemState.disabled) return;
          if (event.pointerType !== "mouse") return;
          const pointerMoved = (_a = service.event.previous()) == null ? void 0 : _a.type.includes("POINTER");
          if (!pointerMoved) return;
          const target = event.currentTarget;
          send({ type: "ITEM_POINTERLEAVE", id, target, closeOnSelect });
        },
        onPointerDown(event) {
          if (itemState.disabled) return;
          const target = event.currentTarget;
          send({ type: "ITEM_POINTERDOWN", target, id, closeOnSelect });
        },
        onClick(event) {
          if (isDownloadingEvent(event)) return;
          if (isOpeningInNewTab(event)) return;
          if (itemState.disabled) return;
          const target = event.currentTarget;
          send({ type: "ITEM_CLICK", target, id, closeOnSelect });
        }
      }));
    }
    return {
      highlightedValue,
      open,
      setOpen(nextOpen) {
        const open2 = state2.hasTag("open");
        if (open2 === nextOpen) return;
        send({ type: nextOpen ? "OPEN" : "CLOSE" });
      },
      setHighlightedValue(value) {
        send({ type: "HIGHLIGHTED.SET", value });
      },
      setParent(parent) {
        send({ type: "PARENT.SET", value: parent, id: parent.prop("id") });
      },
      setChild(child) {
        send({ type: "CHILD.SET", value: child, id: child.prop("id") });
      },
      reposition(options = {}) {
        send({ type: "POSITIONING.SET", options });
      },
      addItemListener(props22) {
        const node = scope.getById(props22.id);
        if (!node) return;
        const listener = () => {
          var _a;
          return (_a = props22.onSelect) == null ? void 0 : _a.call(props22);
        };
        node.addEventListener(itemSelectEvent, listener);
        return () => node.removeEventListener(itemSelectEvent, listener);
      },
      getContextTriggerProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts8.contextTrigger.attrs), {
          dir: prop("dir"),
          id: getContextTriggerId(scope),
          "data-state": open ? "open" : "closed",
          onPointerDown(event) {
            if (event.pointerType === "mouse") return;
            const point = getEventPoint(event);
            send({ type: "CONTEXT_MENU_START", point });
          },
          onPointerCancel(event) {
            if (event.pointerType === "mouse") return;
            send({ type: "CONTEXT_MENU_CANCEL" });
          },
          onPointerMove(event) {
            if (event.pointerType === "mouse") return;
            send({ type: "CONTEXT_MENU_CANCEL" });
          },
          onPointerUp(event) {
            if (event.pointerType === "mouse") return;
            send({ type: "CONTEXT_MENU_CANCEL" });
          },
          onContextMenu(event) {
            const point = getEventPoint(event);
            send({ type: "CONTEXT_MENU", point });
            event.preventDefault();
          },
          style: {
            WebkitTouchCallout: "none",
            WebkitUserSelect: "none",
            userSelect: "none"
          }
        }));
      },
      getTriggerItemProps(childApi) {
        const triggerProps2 = childApi.getTriggerProps();
        return mergeProps(getItemProps({ value: triggerProps2.id }), triggerProps2);
      },
      getTriggerProps() {
        return normalize.button(__spreadProps(__spreadValues({}, isSubmenu ? parts8.triggerItem.attrs : parts8.trigger.attrs), {
          "data-placement": context.get("currentPlacement"),
          type: "button",
          dir: prop("dir"),
          id: getTriggerId5(scope),
          "data-uid": prop("id"),
          "aria-haspopup": composite ? "menu" : "dialog",
          "aria-controls": getContentId5(scope),
          "data-controls": getContentId5(scope),
          "aria-expanded": open || void 0,
          "data-state": open ? "open" : "closed",
          onPointerMove(event) {
            if (event.pointerType !== "mouse") return;
            const disabled = isTargetDisabled(event.currentTarget);
            if (disabled || !isSubmenu) return;
            const point = getEventPoint(event);
            send({ type: "TRIGGER_POINTERMOVE", target: event.currentTarget, point });
          },
          onPointerLeave(event) {
            if (isTargetDisabled(event.currentTarget)) return;
            if (event.pointerType !== "mouse") return;
            if (!isSubmenu) return;
            const point = getEventPoint(event);
            send({
              type: "TRIGGER_POINTERLEAVE",
              target: event.currentTarget,
              point
            });
          },
          onPointerDown(event) {
            if (isTargetDisabled(event.currentTarget)) return;
            if (isContextMenuEvent(event)) return;
            event.preventDefault();
          },
          onClick(event) {
            if (event.defaultPrevented) return;
            if (isTargetDisabled(event.currentTarget)) return;
            send({ type: "TRIGGER_CLICK", target: event.currentTarget });
          },
          onBlur() {
            send({ type: "TRIGGER_BLUR" });
          },
          onFocus() {
            send({ type: "TRIGGER_FOCUS" });
          },
          onKeyDown(event) {
            if (event.defaultPrevented) return;
            const keyMap2 = {
              ArrowDown() {
                send({ type: "ARROW_DOWN" });
              },
              ArrowUp() {
                send({ type: "ARROW_UP" });
              },
              Enter() {
                send({ type: "ARROW_DOWN", src: "enter" });
              },
              Space() {
                send({ type: "ARROW_DOWN", src: "space" });
              }
            };
            const key = getEventKey(event, {
              orientation: "vertical",
              dir: prop("dir")
            });
            const exec = keyMap2[key];
            if (exec) {
              event.preventDefault();
              exec(event);
            }
          }
        }));
      },
      getIndicatorProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts8.indicator.attrs), {
          dir: prop("dir"),
          "data-state": open ? "open" : "closed"
        }));
      },
      getPositionerProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts8.positioner.attrs), {
          dir: prop("dir"),
          id: getPositionerId4(scope),
          style: popperStyles.floating
        }));
      },
      getArrowProps() {
        return normalize.element(__spreadProps(__spreadValues({
          id: getArrowId(scope)
        }, parts8.arrow.attrs), {
          dir: prop("dir"),
          style: popperStyles.arrow
        }));
      },
      getArrowTipProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts8.arrowTip.attrs), {
          dir: prop("dir"),
          style: popperStyles.arrowTip
        }));
      },
      getContentProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts8.content.attrs), {
          id: getContentId5(scope),
          "aria-label": prop("aria-label"),
          hidden: !open,
          "data-state": open ? "open" : "closed",
          role: composite ? "menu" : "dialog",
          tabIndex: 0,
          dir: prop("dir"),
          "aria-activedescendant": computed("highlightedId") || void 0,
          "aria-labelledby": getTriggerId5(scope),
          "data-placement": currentPlacement,
          onPointerEnter(event) {
            if (event.pointerType !== "mouse") return;
            send({ type: "MENU_POINTERENTER" });
          },
          onKeyDown(event) {
            if (event.defaultPrevented) return;
            if (!contains(event.currentTarget, getEventTarget(event))) return;
            const target = getEventTarget(event);
            const sameMenu = (target == null ? void 0 : target.closest("[role=menu]")) === event.currentTarget || target === event.currentTarget;
            if (!sameMenu) return;
            if (event.key === "Tab") {
              const valid = isValidTabEvent(event);
              if (!valid) {
                event.preventDefault();
                return;
              }
            }
            const keyMap2 = {
              ArrowDown() {
                send({ type: "ARROW_DOWN" });
              },
              ArrowUp() {
                send({ type: "ARROW_UP" });
              },
              ArrowLeft() {
                send({ type: "ARROW_LEFT" });
              },
              ArrowRight() {
                send({ type: "ARROW_RIGHT" });
              },
              Enter() {
                send({ type: "ENTER" });
              },
              Space(event2) {
                var _a;
                if (isTypingAhead) {
                  send({ type: "TYPEAHEAD", key: event2.key });
                } else {
                  (_a = keyMap2.Enter) == null ? void 0 : _a.call(keyMap2, event2);
                }
              },
              Home() {
                send({ type: "HOME" });
              },
              End() {
                send({ type: "END" });
              }
            };
            const key = getEventKey(event, { dir: prop("dir") });
            const exec = keyMap2[key];
            if (exec) {
              exec(event);
              event.stopPropagation();
              event.preventDefault();
              return;
            }
            if (!prop("typeahead")) return;
            if (!isPrintableKey(event)) return;
            if (isModifierKey(event)) return;
            if (isEditableElement(target)) return;
            send({ type: "TYPEAHEAD", key: event.key });
            event.preventDefault();
          }
        }));
      },
      getSeparatorProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts8.separator.attrs), {
          role: "separator",
          dir: prop("dir"),
          "aria-orientation": "horizontal"
        }));
      },
      getItemState,
      getItemProps,
      getOptionItemState,
      getOptionItemProps(props22) {
        const { type, disabled, closeOnSelect } = props22;
        const option = getOptionItemProps(props22);
        const itemState = getOptionItemState(props22);
        return __spreadValues(__spreadValues({}, getItemProps(option)), normalize.element(__spreadProps(__spreadValues({
          "data-type": type
        }, parts8.item.attrs), {
          dir: prop("dir"),
          "data-value": option.value,
          role: `menuitem${type}`,
          "aria-checked": !!itemState.checked,
          "data-state": itemState.checked ? "checked" : "unchecked",
          onClick(event) {
            if (disabled) return;
            if (isDownloadingEvent(event)) return;
            if (isOpeningInNewTab(event)) return;
            const target = event.currentTarget;
            send({ type: "ITEM_CLICK", target, option, closeOnSelect });
          }
        })));
      },
      getItemIndicatorProps(props22) {
        const itemState = getOptionItemState(cast(props22));
        const dataState = itemState.checked ? "checked" : "unchecked";
        return normalize.element(__spreadProps(__spreadValues({}, parts8.itemIndicator.attrs), {
          dir: prop("dir"),
          "data-disabled": dataAttr(itemState.disabled),
          "data-highlighted": dataAttr(itemState.highlighted),
          "data-state": hasProp(props22, "checked") ? dataState : void 0,
          hidden: hasProp(props22, "checked") ? !itemState.checked : void 0
        }));
      },
      getItemTextProps(props22) {
        const itemState = getOptionItemState(cast(props22));
        const dataState = itemState.checked ? "checked" : "unchecked";
        return normalize.element(__spreadProps(__spreadValues({}, parts8.itemText.attrs), {
          dir: prop("dir"),
          "data-disabled": dataAttr(itemState.disabled),
          "data-highlighted": dataAttr(itemState.highlighted),
          "data-state": hasProp(props22, "checked") ? dataState : void 0
        }));
      },
      getItemGroupLabelProps(props22) {
        return normalize.element(__spreadProps(__spreadValues({}, parts8.itemGroupLabel.attrs), {
          id: getGroupLabelId(scope, props22.htmlFor),
          dir: prop("dir")
        }));
      },
      getItemGroupProps(props22) {
        return normalize.element(__spreadProps(__spreadValues({
          id: getGroupId(scope, props22.id)
        }, parts8.itemGroup.attrs), {
          dir: prop("dir"),
          "aria-labelledby": getGroupLabelId(scope, props22.id),
          role: "group"
        }));
      }
    };
  }
  function closeRootMenu(ctx) {
    let parent = ctx.parent;
    while (parent && parent.context.get("isSubmenu")) {
      parent = parent.refs.get("parent");
    }
    parent == null ? void 0 : parent.send({ type: "CLOSE" });
  }
  function isWithinPolygon(polygon, point) {
    if (!polygon) return false;
    return isPointInPolygon(polygon, point);
  }
  function resolveItemId(children, value, scope) {
    const hasChildren = Object.keys(children).length > 0;
    if (!value) return null;
    if (!hasChildren) {
      return getItemId3(scope, value);
    }
    for (const id in children) {
      const childMenu = children[id];
      const childTriggerId = getTriggerId5(childMenu.scope);
      if (childTriggerId === value) {
        return childTriggerId;
      }
    }
    return getItemId3(scope, value);
  }
  var createPoint, min3, max3, sign2, abs2, min22, anatomy8, parts8, getTriggerId5, getContextTriggerId, getContentId5, getArrowId, getPositionerId4, getGroupId, getItemId3, getItemValue, getGroupLabelId, getContentEl5, getPositionerEl4, getTriggerEl4, getItemEl2, getContextTriggerEl, getElements, getFirstEl, getLastEl, isMatch, getNextEl, getPrevEl, getElemByKey, isTargetDisabled, isTriggerItem, itemSelectEvent, not4, and4, or, machine8, props8, splitProps8, itemProps3, splitItemProps3, itemGroupLabelProps2, splitItemGroupLabelProps2, itemGroupProps2, splitItemGroupProps2, optionItemProps, splitOptionItemProps, Menu, MenuHook;
  var init_menu = __esm({
    "../priv/static/menu.mjs"() {
      "use strict";
      init_chunk_GRHV6R4F();
      init_chunk_BPSX7Z7Y();
      init_chunk_GFGFZBBD();
      createPoint = (x2, y2) => ({ x: x2, y: y2 });
      ({ min: min3, max: max3 } = Math);
      ({ sign: sign2, abs: abs2, min: min22 } = Math);
      anatomy8 = createAnatomy("menu").parts(
        "arrow",
        "arrowTip",
        "content",
        "contextTrigger",
        "indicator",
        "item",
        "itemGroup",
        "itemGroupLabel",
        "itemIndicator",
        "itemText",
        "positioner",
        "separator",
        "trigger",
        "triggerItem"
      );
      parts8 = anatomy8.build();
      getTriggerId5 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.trigger) != null ? _b : `menu:${ctx.id}:trigger`;
      };
      getContextTriggerId = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.contextTrigger) != null ? _b : `menu:${ctx.id}:ctx-trigger`;
      };
      getContentId5 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.content) != null ? _b : `menu:${ctx.id}:content`;
      };
      getArrowId = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.arrow) != null ? _b : `menu:${ctx.id}:arrow`;
      };
      getPositionerId4 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.positioner) != null ? _b : `menu:${ctx.id}:popper`;
      };
      getGroupId = (ctx, id) => {
        var _a, _b, _c;
        return (_c = (_b = (_a = ctx.ids) == null ? void 0 : _a.group) == null ? void 0 : _b.call(_a, id)) != null ? _c : `menu:${ctx.id}:group:${id}`;
      };
      getItemId3 = (ctx, id) => `${ctx.id}/${id}`;
      getItemValue = (el) => {
        var _a;
        return (_a = el == null ? void 0 : el.dataset.value) != null ? _a : null;
      };
      getGroupLabelId = (ctx, id) => {
        var _a, _b, _c;
        return (_c = (_b = (_a = ctx.ids) == null ? void 0 : _a.groupLabel) == null ? void 0 : _b.call(_a, id)) != null ? _c : `menu:${ctx.id}:group-label:${id}`;
      };
      getContentEl5 = (ctx) => ctx.getById(getContentId5(ctx));
      getPositionerEl4 = (ctx) => ctx.getById(getPositionerId4(ctx));
      getTriggerEl4 = (ctx) => ctx.getById(getTriggerId5(ctx));
      getItemEl2 = (ctx, value) => value ? ctx.getById(getItemId3(ctx, value)) : null;
      getContextTriggerEl = (ctx) => ctx.getById(getContextTriggerId(ctx));
      getElements = (ctx) => {
        const ownerId = CSS.escape(getContentId5(ctx));
        const selector = `[role^="menuitem"][data-ownedby=${ownerId}]:not([data-disabled])`;
        return queryAll(getContentEl5(ctx), selector);
      };
      getFirstEl = (ctx) => first(getElements(ctx));
      getLastEl = (ctx) => last(getElements(ctx));
      isMatch = (el, value) => {
        if (!value) return false;
        return el.id === value || el.dataset.value === value;
      };
      getNextEl = (ctx, opts) => {
        var _a;
        const items = getElements(ctx);
        const index = items.findIndex((el) => isMatch(el, opts.value));
        return next(items, index, { loop: (_a = opts.loop) != null ? _a : opts.loopFocus });
      };
      getPrevEl = (ctx, opts) => {
        var _a;
        const items = getElements(ctx);
        const index = items.findIndex((el) => isMatch(el, opts.value));
        return prev(items, index, { loop: (_a = opts.loop) != null ? _a : opts.loopFocus });
      };
      getElemByKey = (ctx, opts) => {
        var _a;
        const items = getElements(ctx);
        const item = items.find((el) => isMatch(el, opts.value));
        return getByTypeahead(items, { state: opts.typeaheadState, key: opts.key, activeId: (_a = item == null ? void 0 : item.id) != null ? _a : null });
      };
      isTargetDisabled = (v2) => {
        return isHTMLElement(v2) && (v2.dataset.disabled === "" || v2.hasAttribute("disabled"));
      };
      isTriggerItem = (el) => {
        var _a;
        return !!((_a = el == null ? void 0 : el.getAttribute("role")) == null ? void 0 : _a.startsWith("menuitem")) && !!(el == null ? void 0 : el.hasAttribute("data-controls"));
      };
      itemSelectEvent = "menu:select";
      ({ not: not4, and: and4, or } = createGuards());
      machine8 = createMachine({
        props({ props: props22 }) {
          return __spreadProps(__spreadValues({
            closeOnSelect: true,
            typeahead: true,
            composite: true,
            loopFocus: false,
            navigate(details) {
              clickIfLink(details.node);
            }
          }, props22), {
            positioning: __spreadValues({
              placement: "bottom-start",
              gutter: 8
            }, props22.positioning)
          });
        },
        initialState({ prop }) {
          const open = prop("open") || prop("defaultOpen");
          return open ? "open" : "idle";
        },
        context({ bindable: bindable2, prop }) {
          return {
            suspendPointer: bindable2(() => ({
              defaultValue: false
            })),
            highlightedValue: bindable2(() => ({
              defaultValue: prop("defaultHighlightedValue") || null,
              value: prop("highlightedValue"),
              onChange(value) {
                var _a;
                (_a = prop("onHighlightChange")) == null ? void 0 : _a({ highlightedValue: value });
              }
            })),
            lastHighlightedValue: bindable2(() => ({
              defaultValue: null
            })),
            currentPlacement: bindable2(() => ({
              defaultValue: void 0
            })),
            intentPolygon: bindable2(() => ({
              defaultValue: null
            })),
            anchorPoint: bindable2(() => ({
              defaultValue: null,
              hash(value) {
                return `x: ${value == null ? void 0 : value.x}, y: ${value == null ? void 0 : value.y}`;
              }
            })),
            isSubmenu: bindable2(() => ({
              defaultValue: false
            }))
          };
        },
        refs() {
          return {
            parent: null,
            children: {},
            typeaheadState: __spreadValues({}, getByTypeahead.defaultOptions),
            positioningOverride: {}
          };
        },
        computed: {
          isRtl: ({ prop }) => prop("dir") === "rtl",
          isTypingAhead: ({ refs }) => refs.get("typeaheadState").keysSoFar !== "",
          highlightedId: ({ context, scope, refs }) => resolveItemId(refs.get("children"), context.get("highlightedValue"), scope)
        },
        watch({ track, action, context, prop }) {
          track([() => context.get("isSubmenu")], () => {
            action(["setSubmenuPlacement"]);
          });
          track([() => context.hash("anchorPoint")], () => {
            if (!context.get("anchorPoint")) return;
            action(["reposition"]);
          });
          track([() => prop("open")], () => {
            action(["toggleVisibility"]);
          });
        },
        on: {
          "PARENT.SET": {
            actions: ["setParentMenu"]
          },
          "CHILD.SET": {
            actions: ["setChildMenu"]
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
          OPEN_AUTOFOCUS: [
            {
              guard: "isOpenControlled",
              actions: ["invokeOnOpen"]
            },
            {
              // internal: true,
              target: "open",
              actions: ["highlightFirstItem", "invokeOnOpen"]
            }
          ],
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
          "HIGHLIGHTED.RESTORE": {
            actions: ["restoreHighlightedItem"]
          },
          "HIGHLIGHTED.SET": {
            actions: ["setHighlightedItem"]
          }
        },
        states: {
          idle: {
            tags: ["closed"],
            on: {
              "CONTROLLED.OPEN": {
                target: "open"
              },
              "CONTROLLED.CLOSE": {
                target: "closed"
              },
              CONTEXT_MENU_START: {
                target: "opening:contextmenu",
                actions: ["setAnchorPoint"]
              },
              CONTEXT_MENU: [
                {
                  guard: "isOpenControlled",
                  actions: ["setAnchorPoint", "invokeOnOpen"]
                },
                {
                  target: "open",
                  actions: ["setAnchorPoint", "invokeOnOpen"]
                }
              ],
              TRIGGER_CLICK: [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnOpen"]
                },
                {
                  target: "open",
                  actions: ["invokeOnOpen"]
                }
              ],
              TRIGGER_FOCUS: {
                guard: not4("isSubmenu"),
                target: "closed"
              },
              TRIGGER_POINTERMOVE: {
                guard: "isSubmenu",
                target: "opening"
              }
            }
          },
          "opening:contextmenu": {
            tags: ["closed"],
            effects: ["waitForLongPress"],
            on: {
              "CONTROLLED.OPEN": { target: "open" },
              "CONTROLLED.CLOSE": { target: "closed" },
              CONTEXT_MENU_CANCEL: [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnClose"]
                },
                {
                  target: "closed",
                  actions: ["invokeOnClose"]
                }
              ],
              "LONG_PRESS.OPEN": [
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
          },
          opening: {
            tags: ["closed"],
            effects: ["waitForOpenDelay"],
            on: {
              "CONTROLLED.OPEN": {
                target: "open"
              },
              "CONTROLLED.CLOSE": {
                target: "closed"
              },
              BLUR: [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnClose"]
                },
                {
                  target: "closed",
                  actions: ["invokeOnClose"]
                }
              ],
              TRIGGER_POINTERLEAVE: [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnClose"]
                },
                {
                  target: "closed",
                  actions: ["invokeOnClose"]
                }
              ],
              "DELAY.OPEN": [
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
          },
          closing: {
            tags: ["open"],
            effects: ["trackPointerMove", "trackInteractOutside", "waitForCloseDelay"],
            on: {
              "CONTROLLED.OPEN": {
                target: "open"
              },
              "CONTROLLED.CLOSE": {
                target: "closed",
                actions: ["focusParentMenu", "restoreParentHighlightedItem"]
              },
              // don't invoke on open here since the menu is still open (we're only keeping it open)
              MENU_POINTERENTER: {
                target: "open",
                actions: ["clearIntentPolygon"]
              },
              POINTER_MOVED_AWAY_FROM_SUBMENU: [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnClose"]
                },
                {
                  target: "closed",
                  actions: ["focusParentMenu", "restoreParentHighlightedItem"]
                }
              ],
              "DELAY.CLOSE": [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnClose"]
                },
                {
                  target: "closed",
                  actions: ["focusParentMenu", "restoreParentHighlightedItem", "invokeOnClose"]
                }
              ]
            }
          },
          closed: {
            tags: ["closed"],
            entry: ["clearHighlightedItem", "focusTrigger", "resumePointer", "clearAnchorPoint"],
            on: {
              "CONTROLLED.OPEN": [
                {
                  guard: or("isOpenAutoFocusEvent", "isArrowDownEvent"),
                  target: "open",
                  actions: ["highlightFirstItem"]
                },
                {
                  guard: "isArrowUpEvent",
                  target: "open",
                  actions: ["highlightLastItem"]
                },
                {
                  target: "open"
                }
              ],
              CONTEXT_MENU_START: {
                target: "opening:contextmenu",
                actions: ["setAnchorPoint"]
              },
              CONTEXT_MENU: [
                {
                  guard: "isOpenControlled",
                  actions: ["setAnchorPoint", "invokeOnOpen"]
                },
                {
                  target: "open",
                  actions: ["setAnchorPoint", "invokeOnOpen"]
                }
              ],
              TRIGGER_CLICK: [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnOpen"]
                },
                {
                  target: "open",
                  actions: ["invokeOnOpen"]
                }
              ],
              TRIGGER_POINTERMOVE: {
                guard: "isTriggerItem",
                target: "opening"
              },
              TRIGGER_BLUR: { target: "idle" },
              ARROW_DOWN: [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnOpen"]
                },
                {
                  target: "open",
                  actions: ["highlightFirstItem", "invokeOnOpen"]
                }
              ],
              ARROW_UP: [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnOpen"]
                },
                {
                  target: "open",
                  actions: ["highlightLastItem", "invokeOnOpen"]
                }
              ]
            }
          },
          open: {
            tags: ["open"],
            effects: ["trackInteractOutside", "trackPositioning", "scrollToHighlightedItem"],
            entry: ["focusMenu", "resumePointer"],
            on: {
              "CONTROLLED.CLOSE": [
                {
                  target: "closed",
                  guard: "isArrowLeftEvent",
                  actions: ["focusParentMenu"]
                },
                {
                  target: "closed"
                }
              ],
              TRIGGER_CLICK: [
                {
                  guard: and4(not4("isTriggerItem"), "isOpenControlled"),
                  actions: ["invokeOnClose"]
                },
                {
                  guard: not4("isTriggerItem"),
                  target: "closed",
                  actions: ["invokeOnClose"]
                }
              ],
              CONTEXT_MENU: {
                actions: ["setAnchorPoint", "focusMenu"]
              },
              ARROW_UP: {
                actions: ["highlightPrevItem", "focusMenu"]
              },
              ARROW_DOWN: {
                actions: ["highlightNextItem", "focusMenu"]
              },
              ARROW_LEFT: [
                {
                  guard: and4("isSubmenu", "isOpenControlled"),
                  actions: ["invokeOnClose"]
                },
                {
                  guard: "isSubmenu",
                  target: "closed",
                  actions: ["focusParentMenu", "invokeOnClose"]
                }
              ],
              HOME: {
                actions: ["highlightFirstItem", "focusMenu"]
              },
              END: {
                actions: ["highlightLastItem", "focusMenu"]
              },
              ARROW_RIGHT: {
                guard: "isTriggerItemHighlighted",
                actions: ["openSubmenu"]
              },
              ENTER: [
                {
                  guard: "isTriggerItemHighlighted",
                  actions: ["openSubmenu"]
                },
                {
                  actions: ["clickHighlightedItem"]
                }
              ],
              ITEM_POINTERMOVE: [
                {
                  guard: not4("isPointerSuspended"),
                  actions: ["setHighlightedItem", "focusMenu", "closeSiblingMenus"]
                },
                {
                  actions: ["setLastHighlightedItem", "closeSiblingMenus"]
                }
              ],
              ITEM_POINTERLEAVE: {
                guard: and4(not4("isPointerSuspended"), not4("isTriggerItem")),
                actions: ["clearHighlightedItem"]
              },
              ITEM_CLICK: [
                // == grouped ==
                {
                  guard: and4(
                    not4("isTriggerItemHighlighted"),
                    not4("isHighlightedItemEditable"),
                    "closeOnSelect",
                    "isOpenControlled"
                  ),
                  actions: ["invokeOnSelect", "setOptionState", "closeRootMenu", "invokeOnClose"]
                },
                {
                  guard: and4(not4("isTriggerItemHighlighted"), not4("isHighlightedItemEditable"), "closeOnSelect"),
                  target: "closed",
                  actions: ["invokeOnSelect", "setOptionState", "closeRootMenu", "invokeOnClose"]
                },
                //
                {
                  guard: and4(not4("isTriggerItemHighlighted"), not4("isHighlightedItemEditable")),
                  actions: ["invokeOnSelect", "setOptionState"]
                },
                { actions: ["setHighlightedItem"] }
              ],
              TRIGGER_POINTERMOVE: {
                guard: "isTriggerItem",
                actions: ["setIntentPolygon"]
              },
              TRIGGER_POINTERLEAVE: {
                target: "closing",
                actions: ["setIntentPolygon"]
              },
              ITEM_POINTERDOWN: {
                actions: ["setHighlightedItem"]
              },
              TYPEAHEAD: {
                actions: ["highlightMatchedItem"]
              },
              FOCUS_MENU: {
                actions: ["focusMenu"]
              },
              "POSITIONING.SET": {
                actions: ["reposition"]
              }
            }
          }
        },
        implementations: {
          guards: {
            closeOnSelect: ({ prop, event }) => {
              var _a;
              return !!((_a = event == null ? void 0 : event.closeOnSelect) != null ? _a : prop("closeOnSelect"));
            },
            // whether the trigger is also a menu item
            isTriggerItem: ({ event }) => isTriggerItem(event.target),
            // whether the trigger item is the active item
            isTriggerItemHighlighted: ({ event, scope, computed }) => {
              var _a;
              const target = (_a = event.target) != null ? _a : scope.getById(computed("highlightedId"));
              return !!(target == null ? void 0 : target.hasAttribute("data-controls"));
            },
            isSubmenu: ({ context }) => context.get("isSubmenu"),
            isPointerSuspended: ({ context }) => context.get("suspendPointer"),
            isHighlightedItemEditable: ({ scope, computed }) => isEditableElement(scope.getById(computed("highlightedId"))),
            // guard assertions (for controlled mode)
            isOpenControlled: ({ prop }) => prop("open") !== void 0,
            isArrowLeftEvent: ({ event }) => {
              var _a;
              return ((_a = event.previousEvent) == null ? void 0 : _a.type) === "ARROW_LEFT";
            },
            isArrowUpEvent: ({ event }) => {
              var _a;
              return ((_a = event.previousEvent) == null ? void 0 : _a.type) === "ARROW_UP";
            },
            isArrowDownEvent: ({ event }) => {
              var _a;
              return ((_a = event.previousEvent) == null ? void 0 : _a.type) === "ARROW_DOWN";
            },
            isOpenAutoFocusEvent: ({ event }) => {
              var _a;
              return ((_a = event.previousEvent) == null ? void 0 : _a.type) === "OPEN_AUTOFOCUS";
            }
          },
          effects: {
            waitForOpenDelay({ send }) {
              const timer = setTimeout(() => {
                send({ type: "DELAY.OPEN" });
              }, 200);
              return () => clearTimeout(timer);
            },
            waitForCloseDelay({ send }) {
              const timer = setTimeout(() => {
                send({ type: "DELAY.CLOSE" });
              }, 100);
              return () => clearTimeout(timer);
            },
            waitForLongPress({ send }) {
              const timer = setTimeout(() => {
                send({ type: "LONG_PRESS.OPEN" });
              }, 700);
              return () => clearTimeout(timer);
            },
            trackPositioning({ context, prop, scope, refs }) {
              if (!!getContextTriggerEl(scope)) return;
              const positioning = __spreadValues(__spreadValues({}, prop("positioning")), refs.get("positioningOverride"));
              context.set("currentPlacement", positioning.placement);
              const getPositionerEl22 = () => getPositionerEl4(scope);
              return getPlacement(getTriggerEl4(scope), getPositionerEl22, __spreadProps(__spreadValues({}, positioning), {
                defer: true,
                onComplete(data) {
                  context.set("currentPlacement", data.placement);
                }
              }));
            },
            trackInteractOutside({ refs, scope, prop, context, send }) {
              const getContentEl22 = () => getContentEl5(scope);
              let restoreFocus = true;
              return trackDismissableElement(getContentEl22, {
                type: "menu",
                defer: true,
                exclude: [getTriggerEl4(scope)],
                onInteractOutside: prop("onInteractOutside"),
                onRequestDismiss: prop("onRequestDismiss"),
                onFocusOutside(event) {
                  var _a;
                  (_a = prop("onFocusOutside")) == null ? void 0 : _a(event);
                  const target = getEventTarget(event.detail.originalEvent);
                  const isWithinContextTrigger = contains(getContextTriggerEl(scope), target);
                  if (isWithinContextTrigger) {
                    event.preventDefault();
                    return;
                  }
                },
                onEscapeKeyDown(event) {
                  var _a;
                  (_a = prop("onEscapeKeyDown")) == null ? void 0 : _a(event);
                  if (context.get("isSubmenu")) event.preventDefault();
                  closeRootMenu({ parent: refs.get("parent") });
                },
                onPointerDownOutside(event) {
                  var _a;
                  (_a = prop("onPointerDownOutside")) == null ? void 0 : _a(event);
                  const target = getEventTarget(event.detail.originalEvent);
                  const isWithinContextTrigger = contains(getContextTriggerEl(scope), target);
                  if (isWithinContextTrigger && event.detail.contextmenu) {
                    event.preventDefault();
                    return;
                  }
                  restoreFocus = !event.detail.focusable;
                },
                onDismiss() {
                  send({ type: "CLOSE", src: "interact-outside", restoreFocus });
                }
              });
            },
            trackPointerMove({ context, scope, send, refs, flush }) {
              const parent = refs.get("parent");
              flush(() => {
                parent.context.set("suspendPointer", true);
              });
              const doc = scope.getDoc();
              return addDomEvent(doc, "pointermove", (e2) => {
                const isMovingToSubmenu = isWithinPolygon(context.get("intentPolygon"), {
                  x: e2.clientX,
                  y: e2.clientY
                });
                if (!isMovingToSubmenu) {
                  send({ type: "POINTER_MOVED_AWAY_FROM_SUBMENU" });
                  parent.context.set("suspendPointer", false);
                }
              });
            },
            scrollToHighlightedItem({ event, scope, computed }) {
              const exec = () => {
                if (event.current().type.startsWith("ITEM_POINTER")) return;
                const itemEl = scope.getById(computed("highlightedId"));
                const contentEl2 = getContentEl5(scope);
                scrollIntoView(itemEl, { rootEl: contentEl2, block: "nearest" });
              };
              raf(() => exec());
              const contentEl = () => getContentEl5(scope);
              return observeAttributes(contentEl, {
                defer: true,
                attributes: ["aria-activedescendant"],
                callback: exec
              });
            }
          },
          actions: {
            setAnchorPoint({ context, event }) {
              context.set("anchorPoint", (prev2) => isEqual2(prev2, event.point) ? prev2 : event.point);
            },
            setSubmenuPlacement({ context, computed, refs }) {
              if (!context.get("isSubmenu")) return;
              const placement = computed("isRtl") ? "left-start" : "right-start";
              refs.set("positioningOverride", { placement, gutter: 0 });
            },
            reposition({ context, scope, prop, event, refs }) {
              var _a;
              const getPositionerEl22 = () => getPositionerEl4(scope);
              const anchorPoint = context.get("anchorPoint");
              const getAnchorRect = anchorPoint ? () => __spreadValues({ width: 0, height: 0 }, anchorPoint) : void 0;
              const positioning = __spreadValues(__spreadValues({}, prop("positioning")), refs.get("positioningOverride"));
              getPlacement(getTriggerEl4(scope), getPositionerEl22, __spreadProps(__spreadValues(__spreadProps(__spreadValues({}, positioning), {
                defer: true,
                getAnchorRect
              }), (_a = event.options) != null ? _a : {}), {
                listeners: false,
                onComplete(data) {
                  context.set("currentPlacement", data.placement);
                }
              }));
            },
            setOptionState({ event }) {
              if (!event.option) return;
              const { checked, onCheckedChange, type } = event.option;
              if (type === "radio") {
                onCheckedChange == null ? void 0 : onCheckedChange(true);
              } else if (type === "checkbox") {
                onCheckedChange == null ? void 0 : onCheckedChange(!checked);
              }
            },
            clickHighlightedItem({ scope, computed, prop, context }) {
              var _a;
              const itemEl = scope.getById(computed("highlightedId"));
              if (!itemEl || itemEl.dataset.disabled) return;
              const highlightedValue = context.get("highlightedValue");
              if (isAnchorElement(itemEl)) {
                (_a = prop("navigate")) == null ? void 0 : _a({ value: highlightedValue, node: itemEl, href: itemEl.href });
              } else {
                queueMicrotask(() => itemEl.click());
              }
            },
            setIntentPolygon({ context, scope, event }) {
              const menu = getContentEl5(scope);
              const placement = context.get("currentPlacement");
              if (!menu || !placement) return;
              const rect = menu.getBoundingClientRect();
              const polygon = getElementPolygon(rect, placement);
              if (!polygon) return;
              const rightSide = getPlacementSide(placement) === "right";
              const bleed = rightSide ? -5 : 5;
              context.set("intentPolygon", [__spreadProps(__spreadValues({}, event.point), { x: event.point.x + bleed }), ...polygon]);
            },
            clearIntentPolygon({ context }) {
              context.set("intentPolygon", null);
            },
            clearAnchorPoint({ context }) {
              context.set("anchorPoint", null);
            },
            resumePointer({ refs, flush }) {
              const parent = refs.get("parent");
              if (!parent) return;
              flush(() => {
                parent.context.set("suspendPointer", false);
              });
            },
            setHighlightedItem({ context, event }) {
              const value = event.value || getItemValue(event.target);
              context.set("highlightedValue", value);
            },
            clearHighlightedItem({ context }) {
              context.set("highlightedValue", null);
            },
            focusMenu({ scope }) {
              raf(() => {
                const contentEl = getContentEl5(scope);
                const initialFocusEl = getInitialFocus({
                  root: contentEl,
                  enabled: !contains(contentEl, scope.getActiveElement()),
                  filter(node) {
                    var _a;
                    return !((_a = node.role) == null ? void 0 : _a.startsWith("menuitem"));
                  }
                });
                initialFocusEl == null ? void 0 : initialFocusEl.focus({ preventScroll: true });
              });
            },
            highlightFirstItem({ context, scope }) {
              const fn = getContentEl5(scope) ? queueMicrotask : raf;
              fn(() => {
                const first2 = getFirstEl(scope);
                if (!first2) return;
                context.set("highlightedValue", getItemValue(first2));
              });
            },
            highlightLastItem({ context, scope }) {
              const fn = getContentEl5(scope) ? queueMicrotask : raf;
              fn(() => {
                const last2 = getLastEl(scope);
                if (!last2) return;
                context.set("highlightedValue", getItemValue(last2));
              });
            },
            highlightNextItem({ context, scope, event, prop }) {
              const next2 = getNextEl(scope, {
                loop: event.loop,
                value: context.get("highlightedValue"),
                loopFocus: prop("loopFocus")
              });
              context.set("highlightedValue", getItemValue(next2));
            },
            highlightPrevItem({ context, scope, event, prop }) {
              const prev2 = getPrevEl(scope, {
                loop: event.loop,
                value: context.get("highlightedValue"),
                loopFocus: prop("loopFocus")
              });
              context.set("highlightedValue", getItemValue(prev2));
            },
            invokeOnSelect({ context, prop, scope }) {
              var _a;
              const value = context.get("highlightedValue");
              if (value == null) return;
              const node = getItemEl2(scope, value);
              dispatchSelectionEvent(node, value);
              (_a = prop("onSelect")) == null ? void 0 : _a({ value });
            },
            focusTrigger({ scope, context, event }) {
              if (context.get("isSubmenu") || context.get("anchorPoint") || event.restoreFocus === false) return;
              queueMicrotask(() => {
                var _a;
                return (_a = getTriggerEl4(scope)) == null ? void 0 : _a.focus({ preventScroll: true });
              });
            },
            highlightMatchedItem({ scope, context, event, refs }) {
              const node = getElemByKey(scope, {
                key: event.key,
                value: context.get("highlightedValue"),
                typeaheadState: refs.get("typeaheadState")
              });
              if (!node) return;
              context.set("highlightedValue", getItemValue(node));
            },
            setParentMenu({ refs, event, context }) {
              refs.set("parent", event.value);
              context.set("isSubmenu", true);
            },
            setChildMenu({ refs, event }) {
              const children = refs.get("children");
              children[event.id] = event.value;
              refs.set("children", children);
            },
            closeSiblingMenus({ refs, event, scope }) {
              var _a;
              const target = event.target;
              if (!isTriggerItem(target)) return;
              const hoveredChildId = target == null ? void 0 : target.getAttribute("data-uid");
              const children = refs.get("children");
              for (const id in children) {
                if (id === hoveredChildId) continue;
                const child = children[id];
                const intentPolygon = child.context.get("intentPolygon");
                if (intentPolygon && event.point && isPointInPolygon(intentPolygon, event.point)) {
                  continue;
                }
                (_a = getContentEl5(scope)) == null ? void 0 : _a.focus({ preventScroll: true });
                child.send({ type: "CLOSE" });
              }
            },
            closeRootMenu({ refs }) {
              closeRootMenu({ parent: refs.get("parent") });
            },
            openSubmenu({ refs, scope, computed }) {
              const item = scope.getById(computed("highlightedId"));
              const id = item == null ? void 0 : item.getAttribute("data-uid");
              const children = refs.get("children");
              const child = id ? children[id] : null;
              child == null ? void 0 : child.send({ type: "OPEN_AUTOFOCUS" });
            },
            focusParentMenu({ refs }) {
              var _a;
              (_a = refs.get("parent")) == null ? void 0 : _a.send({ type: "FOCUS_MENU" });
            },
            setLastHighlightedItem({ context, event }) {
              context.set("lastHighlightedValue", getItemValue(event.target));
            },
            restoreHighlightedItem({ context }) {
              if (!context.get("lastHighlightedValue")) return;
              context.set("highlightedValue", context.get("lastHighlightedValue"));
              context.set("lastHighlightedValue", null);
            },
            restoreParentHighlightedItem({ refs }) {
              var _a;
              (_a = refs.get("parent")) == null ? void 0 : _a.send({ type: "HIGHLIGHTED.RESTORE" });
            },
            invokeOnOpen({ prop }) {
              var _a;
              (_a = prop("onOpenChange")) == null ? void 0 : _a({ open: true });
            },
            invokeOnClose({ prop }) {
              var _a;
              (_a = prop("onOpenChange")) == null ? void 0 : _a({ open: false });
            },
            toggleVisibility({ prop, event, send }) {
              send({
                type: prop("open") ? "CONTROLLED.OPEN" : "CONTROLLED.CLOSE",
                previousEvent: event
              });
            }
          }
        }
      });
      props8 = createProps()([
        "anchorPoint",
        "aria-label",
        "closeOnSelect",
        "composite",
        "defaultHighlightedValue",
        "defaultOpen",
        "dir",
        "getRootNode",
        "highlightedValue",
        "id",
        "ids",
        "loopFocus",
        "navigate",
        "onEscapeKeyDown",
        "onFocusOutside",
        "onHighlightChange",
        "onInteractOutside",
        "onOpenChange",
        "onPointerDownOutside",
        "onRequestDismiss",
        "onSelect",
        "open",
        "positioning",
        "typeahead"
      ]);
      splitProps8 = createSplitProps(props8);
      itemProps3 = createProps()(["closeOnSelect", "disabled", "value", "valueText"]);
      splitItemProps3 = createSplitProps(itemProps3);
      itemGroupLabelProps2 = createProps()(["htmlFor"]);
      splitItemGroupLabelProps2 = createSplitProps(itemGroupLabelProps2);
      itemGroupProps2 = createProps()(["id"]);
      splitItemGroupProps2 = createSplitProps(itemGroupProps2);
      optionItemProps = createProps()([
        "checked",
        "closeOnSelect",
        "disabled",
        "onCheckedChange",
        "type",
        "value",
        "valueText"
      ]);
      splitOptionItemProps = createSplitProps(optionItemProps);
      Menu = class extends Component {
        constructor() {
          super(...arguments);
          __publicField(this, "children", []);
        }
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        initMachine(props22) {
          return new VanillaMachine(machine8, props22);
        }
        initApi() {
          return connect8(this.machine.service, normalizeProps);
        }
        setChild(child) {
          this.api.setChild(child.machine.service);
          if (!this.children.includes(child)) {
            this.children.push(child);
          }
        }
        setParent(parent) {
          this.api.setParent(parent.machine.service);
        }
        /**
         * Check if an element belongs to THIS menu instance.
         * Uses the nearest phx-hook="Menu" ancestor to determine ownership.
         */
        isOwnElement(el) {
          const nearestHook = el.closest('[phx-hook="Menu"]');
          return nearestHook === this.el;
        }
        renderSubmenuTriggers() {
          const contentEl = this.el.querySelector(
            '[data-scope="menu"][data-part="content"]'
          );
          if (!contentEl) return;
          const triggerItems = contentEl.querySelectorAll(
            '[data-scope="menu"][data-nested-menu]'
          );
          for (const triggerEl of triggerItems) {
            if (!this.isOwnElement(triggerEl)) continue;
            const nestedMenuId = triggerEl.dataset.nestedMenu;
            if (!nestedMenuId) continue;
            const childMenu = this.children.find(
              (child) => child.el.id === `menu:${nestedMenuId}`
            );
            if (!childMenu) continue;
            const applyProps = () => {
              const triggerProps2 = this.api.getTriggerItemProps(childMenu.api);
              this.spreadProps(triggerEl, triggerProps2);
            };
            applyProps();
            this.machine.subscribe(applyProps);
            childMenu.machine.subscribe(applyProps);
          }
        }
        render() {
          const triggerEl = this.el.querySelector(
            '[data-scope="menu"][data-part="trigger"]'
          );
          if (triggerEl) {
            this.spreadProps(triggerEl, this.api.getTriggerProps());
          }
          const positionerEl = this.el.querySelector(
            '[data-scope="menu"][data-part="positioner"]'
          );
          const contentEl = this.el.querySelector(
            '[data-scope="menu"][data-part="content"]'
          );
          if (positionerEl && contentEl) {
            this.spreadProps(positionerEl, this.api.getPositionerProps());
            this.spreadProps(contentEl, this.api.getContentProps());
            positionerEl.hidden = !this.api.open;
            if (this.api.open) {
              const items = contentEl.querySelectorAll(
                '[data-scope="menu"][data-part="item"]'
              );
              items.forEach((itemEl) => {
                if (!this.isOwnElement(itemEl)) return;
                const value = itemEl.dataset.value;
                if (value) {
                  const disabled = itemEl.hasAttribute("data-disabled");
                  this.spreadProps(
                    itemEl,
                    this.api.getItemProps({ value, disabled: disabled || void 0 })
                  );
                }
              });
              const optionItems = contentEl.querySelectorAll(
                '[data-scope="menu"][data-part="option-item"]'
              );
              optionItems.forEach((optionItemEl) => {
                if (!this.isOwnElement(optionItemEl)) return;
                const value = optionItemEl.dataset.value;
                const type = optionItemEl.dataset.type;
                if (value && type) {
                  const checked = optionItemEl.hasAttribute("data-checked");
                  const disabled = optionItemEl.hasAttribute("data-disabled");
                  this.spreadProps(
                    optionItemEl,
                    this.api.getOptionItemProps({
                      value,
                      type,
                      checked,
                      disabled: disabled || void 0
                    })
                  );
                }
              });
              const itemGroups = contentEl.querySelectorAll(
                '[data-scope="menu"][data-part="item-group"]'
              );
              itemGroups.forEach((groupEl) => {
                if (!this.isOwnElement(groupEl)) return;
                const groupId = groupEl.id;
                if (groupId) {
                  this.spreadProps(groupEl, this.api.getItemGroupProps({ id: groupId }));
                }
              });
              const separators = contentEl.querySelectorAll(
                '[data-scope="menu"][data-part="separator"]'
              );
              separators.forEach((separatorEl) => {
                if (!this.isOwnElement(separatorEl)) return;
                this.spreadProps(separatorEl, this.api.getSeparatorProps());
              });
            }
          }
          const indicatorEl = this.el.querySelector(
            '[data-scope="menu"][data-part="indicator"]'
          );
          if (indicatorEl) {
            this.spreadProps(indicatorEl, this.api.getIndicatorProps());
          }
        }
      };
      MenuHook = {
        mounted() {
          const el = this.el;
          if (el.hasAttribute("data-nested")) {
            return;
          }
          const menu = new Menu(
            el,
            __spreadProps(__spreadValues({
              id: el.id.replace("menu:", "")
            }, getBoolean(el, "controlled") ? { open: getBoolean(el, "open") } : { defaultOpen: getBoolean(el, "defaultOpen") }), {
              closeOnSelect: getBoolean(el, "closeOnSelect"),
              loopFocus: getBoolean(el, "loopFocus"),
              typeahead: getBoolean(el, "typeahead"),
              composite: getBoolean(el, "composite"),
              dir: getString(el, "dir", ["ltr", "rtl"]),
              onSelect: (details) => {
                var _a, _b;
                const redirect = getBoolean(el, "redirect");
                const itemEl = [...el.querySelectorAll('[data-scope="menu"][data-part="item"]')].find(
                  (node) => node.getAttribute("data-value") === details.value
                );
                const itemRedirect = itemEl == null ? void 0 : itemEl.getAttribute("data-redirect");
                const itemNewTab = itemEl == null ? void 0 : itemEl.hasAttribute("data-new-tab");
                const doRedirect = redirect && details.value && !this.liveSocket.main.isConnected() && itemRedirect !== "false";
                if (doRedirect) {
                  if (itemNewTab) {
                    window.open(details.value, "_blank", "noopener,noreferrer");
                  } else {
                    window.location.href = details.value;
                  }
                }
                const eventName = getString(el, "onSelect");
                if (eventName && this.liveSocket.main.isConnected()) {
                  this.pushEvent(eventName, {
                    id: el.id,
                    value: (_a = details.value) != null ? _a : null
                  });
                }
                const eventNameClient = getString(el, "onSelectClient");
                if (eventNameClient) {
                  el.dispatchEvent(
                    new CustomEvent(eventNameClient, {
                      bubbles: true,
                      detail: {
                        id: el.id,
                        value: (_b = details.value) != null ? _b : null
                      }
                    })
                  );
                }
              },
              onOpenChange: (details) => {
                var _a, _b;
                const eventName = getString(el, "onOpenChange");
                if (eventName && this.liveSocket.main.isConnected()) {
                  this.pushEvent(eventName, {
                    id: el.id,
                    open: (_a = details.open) != null ? _a : false
                  });
                }
                const eventNameClient = getString(el, "onOpenChangeClient");
                if (eventNameClient) {
                  el.dispatchEvent(
                    new CustomEvent(eventNameClient, {
                      bubbles: true,
                      detail: {
                        id: el.id,
                        open: (_b = details.open) != null ? _b : false
                      }
                    })
                  );
                }
              }
            })
          );
          menu.init();
          this.menu = menu;
          this.nestedMenus = /* @__PURE__ */ new Map();
          const nestedMenuElements = el.querySelectorAll(
            '[data-scope="menu"][data-nested="menu"]'
          );
          const nestedMenuInstances = [];
          nestedMenuElements.forEach((nestedEl) => {
            var _a;
            const nestedId = nestedEl.id;
            if (nestedId) {
              const nestedMenuId = nestedId.replace("menu:", "");
              const nestedMenu = new Menu(nestedEl, {
                id: nestedMenuId,
                dir: getString(nestedEl, "dir", ["ltr", "rtl"]),
                closeOnSelect: getBoolean(nestedEl, "closeOnSelect"),
                loopFocus: getBoolean(nestedEl, "loopFocus"),
                typeahead: getBoolean(nestedEl, "typeahead"),
                composite: getBoolean(nestedEl, "composite")
              });
              nestedMenu.init();
              (_a = this.nestedMenus) == null ? void 0 : _a.set(nestedId, nestedMenu);
              nestedMenuInstances.push(nestedMenu);
            }
          });
          setTimeout(() => {
            nestedMenuInstances.forEach((nestedMenu) => {
              if (this.menu) {
                this.menu.setChild(nestedMenu);
                nestedMenu.setParent(this.menu);
              }
            });
            if (this.menu) {
              this.menu.api = this.menu.initApi();
              this.menu.render();
            }
            nestedMenuInstances.forEach((nestedMenu) => {
              nestedMenu.api = nestedMenu.initApi();
              nestedMenu.render();
            });
            if (this.menu && this.menu.children.length > 0) {
              this.menu.renderSubmenuTriggers();
            }
          }, 0);
          this.onSetOpen = (event) => {
            const { open } = event.detail;
            menu.api.setOpen(open);
          };
          el.addEventListener("phx:menu:set-open", this.onSetOpen);
          this.handlers = [];
          this.handlers.push(
            this.handleEvent("menu_set_open", (payload) => {
              const targetId = payload.menu_id;
              if (targetId && targetId !== el.id) return;
              menu.api.setOpen(payload.open);
            })
          );
          this.handlers.push(
            this.handleEvent("menu_open", () => {
              this.pushEvent("menu_open_response", {
                open: menu.api.open
              });
            })
          );
        },
        updated() {
          var _a;
          if (this.el.hasAttribute("data-nested")) return;
          (_a = this.menu) == null ? void 0 : _a.updateProps(__spreadProps(__spreadValues({
            id: this.el.id
          }, getBoolean(this.el, "controlled") ? { open: getBoolean(this.el, "open") } : { defaultOpen: getBoolean(this.el, "defaultOpen") }), {
            closeOnSelect: getBoolean(this.el, "closeOnSelect"),
            loopFocus: getBoolean(this.el, "loopFocus"),
            typeahead: getBoolean(this.el, "typeahead"),
            composite: getBoolean(this.el, "composite"),
            dir: getString(this.el, "dir", ["ltr", "rtl"])
          }));
        },
        destroyed() {
          var _a;
          if (this.el.hasAttribute("data-nested")) return;
          if (this.onSetOpen) {
            this.el.removeEventListener("phx:menu:set-open", this.onSetOpen);
          }
          if (this.handlers) {
            for (const handler of this.handlers) {
              this.removeHandleEvent(handler);
            }
          }
          if (this.nestedMenus) {
            for (const [, nestedMenu] of this.nestedMenus) {
              nestedMenu.destroy();
            }
          }
          (_a = this.menu) == null ? void 0 : _a.destroy();
        }
      };
    }
  });

  // ../priv/static/select.mjs
  var select_exports = {};
  __export(select_exports, {
    Select: () => SelectHook
  });
  function connect9(service, normalize) {
    const { context, prop, scope, state: state2, computed, send } = service;
    const disabled = prop("disabled") || context.get("fieldsetDisabled");
    const invalid = !!prop("invalid");
    const required = !!prop("required");
    const readOnly = !!prop("readOnly");
    const composite = prop("composite");
    const collection22 = prop("collection");
    const open = state2.hasTag("open");
    const focused = state2.matches("focused");
    const highlightedValue = context.get("highlightedValue");
    const highlightedItem = context.get("highlightedItem");
    const selectedItems = context.get("selectedItems");
    const currentPlacement = context.get("currentPlacement");
    const isTypingAhead = computed("isTypingAhead");
    const interactive = computed("isInteractive");
    const ariaActiveDescendant = highlightedValue ? getItemId4(scope, highlightedValue) : void 0;
    function getItemState(props22) {
      const _disabled = collection22.getItemDisabled(props22.item);
      const value = collection22.getItemValue(props22.item);
      ensure(value, () => `[zag-js] No value found for item ${JSON.stringify(props22.item)}`);
      return {
        value,
        disabled: Boolean(disabled || _disabled),
        highlighted: highlightedValue === value,
        selected: context.get("value").includes(value)
      };
    }
    const popperStyles = getPlacementStyles(__spreadProps(__spreadValues({}, prop("positioning")), {
      placement: currentPlacement
    }));
    return {
      open,
      focused,
      empty: context.get("value").length === 0,
      highlightedItem,
      highlightedValue,
      selectedItems,
      hasSelectedItems: computed("hasSelectedItems"),
      value: context.get("value"),
      valueAsString: computed("valueAsString"),
      collection: collection22,
      multiple: !!prop("multiple"),
      disabled: !!disabled,
      reposition(options = {}) {
        send({ type: "POSITIONING.SET", options });
      },
      focus() {
        var _a;
        (_a = getTriggerEl5(scope)) == null ? void 0 : _a.focus({ preventScroll: true });
      },
      setOpen(nextOpen) {
        const open2 = state2.hasTag("open");
        if (open2 === nextOpen) return;
        send({ type: nextOpen ? "OPEN" : "CLOSE" });
      },
      selectValue(value) {
        send({ type: "ITEM.SELECT", value });
      },
      setValue(value) {
        send({ type: "VALUE.SET", value });
      },
      selectAll() {
        send({ type: "VALUE.SET", value: collection22.getValues() });
      },
      setHighlightValue(value) {
        send({ type: "HIGHLIGHTED_VALUE.SET", value });
      },
      clearHighlightValue() {
        send({ type: "HIGHLIGHTED_VALUE.CLEAR" });
      },
      clearValue(value) {
        if (value) {
          send({ type: "ITEM.CLEAR", value });
        } else {
          send({ type: "VALUE.CLEAR" });
        }
      },
      getItemState,
      getRootProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts9.root.attrs), {
          dir: prop("dir"),
          id: getRootId7(scope),
          "data-invalid": dataAttr(invalid),
          "data-readonly": dataAttr(readOnly)
        }));
      },
      getLabelProps() {
        return normalize.label(__spreadProps(__spreadValues({
          dir: prop("dir"),
          id: getLabelId5(scope)
        }, parts9.label.attrs), {
          "data-disabled": dataAttr(disabled),
          "data-invalid": dataAttr(invalid),
          "data-readonly": dataAttr(readOnly),
          "data-required": dataAttr(required),
          htmlFor: getHiddenSelectId(scope),
          onClick(event) {
            var _a;
            if (event.defaultPrevented) return;
            if (disabled) return;
            (_a = getTriggerEl5(scope)) == null ? void 0 : _a.focus({ preventScroll: true });
          }
        }));
      },
      getControlProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts9.control.attrs), {
          dir: prop("dir"),
          id: getControlId4(scope),
          "data-state": open ? "open" : "closed",
          "data-focus": dataAttr(focused),
          "data-disabled": dataAttr(disabled),
          "data-invalid": dataAttr(invalid)
        }));
      },
      getValueTextProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts9.valueText.attrs), {
          dir: prop("dir"),
          "data-disabled": dataAttr(disabled),
          "data-invalid": dataAttr(invalid),
          "data-focus": dataAttr(focused)
        }));
      },
      getTriggerProps() {
        return normalize.button(__spreadProps(__spreadValues({
          id: getTriggerId6(scope),
          disabled,
          dir: prop("dir"),
          type: "button",
          role: "combobox",
          "aria-controls": getContentId6(scope),
          "aria-expanded": open,
          "aria-haspopup": "listbox",
          "data-state": open ? "open" : "closed",
          "aria-invalid": invalid,
          "aria-required": required,
          "aria-labelledby": getLabelId5(scope)
        }, parts9.trigger.attrs), {
          "data-disabled": dataAttr(disabled),
          "data-invalid": dataAttr(invalid),
          "data-readonly": dataAttr(readOnly),
          "data-placement": currentPlacement,
          "data-placeholder-shown": dataAttr(!computed("hasSelectedItems")),
          onClick(event) {
            if (!interactive) return;
            if (event.defaultPrevented) return;
            send({ type: "TRIGGER.CLICK" });
          },
          onFocus() {
            send({ type: "TRIGGER.FOCUS" });
          },
          onBlur() {
            send({ type: "TRIGGER.BLUR" });
          },
          onKeyDown(event) {
            if (event.defaultPrevented) return;
            if (!interactive) return;
            const keyMap2 = {
              ArrowUp() {
                send({ type: "TRIGGER.ARROW_UP" });
              },
              ArrowDown(event2) {
                send({ type: event2.altKey ? "OPEN" : "TRIGGER.ARROW_DOWN" });
              },
              ArrowLeft() {
                send({ type: "TRIGGER.ARROW_LEFT" });
              },
              ArrowRight() {
                send({ type: "TRIGGER.ARROW_RIGHT" });
              },
              Home() {
                send({ type: "TRIGGER.HOME" });
              },
              End() {
                send({ type: "TRIGGER.END" });
              },
              Enter() {
                send({ type: "TRIGGER.ENTER" });
              },
              Space(event2) {
                if (isTypingAhead) {
                  send({ type: "TRIGGER.TYPEAHEAD", key: event2.key });
                } else {
                  send({ type: "TRIGGER.ENTER" });
                }
              }
            };
            const exec = keyMap2[getEventKey(event, {
              dir: prop("dir"),
              orientation: "vertical"
            })];
            if (exec) {
              exec(event);
              event.preventDefault();
              return;
            }
            if (getByTypeahead.isValidEvent(event)) {
              send({ type: "TRIGGER.TYPEAHEAD", key: event.key });
              event.preventDefault();
            }
          }
        }));
      },
      getIndicatorProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts9.indicator.attrs), {
          dir: prop("dir"),
          "aria-hidden": true,
          "data-state": open ? "open" : "closed",
          "data-disabled": dataAttr(disabled),
          "data-invalid": dataAttr(invalid),
          "data-readonly": dataAttr(readOnly)
        }));
      },
      getItemProps(props22) {
        const itemState = getItemState(props22);
        return normalize.element(__spreadProps(__spreadValues({
          id: getItemId4(scope, itemState.value),
          role: "option"
        }, parts9.item.attrs), {
          dir: prop("dir"),
          "data-value": itemState.value,
          "aria-selected": itemState.selected,
          "data-state": itemState.selected ? "checked" : "unchecked",
          "data-highlighted": dataAttr(itemState.highlighted),
          "data-disabled": dataAttr(itemState.disabled),
          "aria-disabled": ariaAttr(itemState.disabled),
          onPointerMove(event) {
            if (itemState.disabled || event.pointerType !== "mouse") return;
            if (itemState.value === highlightedValue) return;
            send({ type: "ITEM.POINTER_MOVE", value: itemState.value });
          },
          onClick(event) {
            if (event.defaultPrevented) return;
            if (itemState.disabled) return;
            send({ type: "ITEM.CLICK", src: "pointerup", value: itemState.value });
          },
          onPointerLeave(event) {
            var _a;
            if (itemState.disabled) return;
            if (props22.persistFocus) return;
            if (event.pointerType !== "mouse") return;
            const pointerMoved = (_a = service.event.previous()) == null ? void 0 : _a.type.includes("POINTER");
            if (!pointerMoved) return;
            send({ type: "ITEM.POINTER_LEAVE" });
          }
        }));
      },
      getItemTextProps(props22) {
        const itemState = getItemState(props22);
        return normalize.element(__spreadProps(__spreadValues({}, parts9.itemText.attrs), {
          "data-state": itemState.selected ? "checked" : "unchecked",
          "data-disabled": dataAttr(itemState.disabled),
          "data-highlighted": dataAttr(itemState.highlighted)
        }));
      },
      getItemIndicatorProps(props22) {
        const itemState = getItemState(props22);
        return normalize.element(__spreadProps(__spreadValues({
          "aria-hidden": true
        }, parts9.itemIndicator.attrs), {
          "data-state": itemState.selected ? "checked" : "unchecked",
          hidden: !itemState.selected
        }));
      },
      getItemGroupLabelProps(props22) {
        const { htmlFor } = props22;
        return normalize.element(__spreadProps(__spreadValues({}, parts9.itemGroupLabel.attrs), {
          id: getItemGroupLabelId2(scope, htmlFor),
          dir: prop("dir"),
          role: "presentation"
        }));
      },
      getItemGroupProps(props22) {
        const { id } = props22;
        return normalize.element(__spreadProps(__spreadValues({}, parts9.itemGroup.attrs), {
          "data-disabled": dataAttr(disabled),
          id: getItemGroupId2(scope, id),
          "aria-labelledby": getItemGroupLabelId2(scope, id),
          role: "group",
          dir: prop("dir")
        }));
      },
      getClearTriggerProps() {
        return normalize.button(__spreadProps(__spreadValues({}, parts9.clearTrigger.attrs), {
          id: getClearTriggerId3(scope),
          type: "button",
          "aria-label": "Clear value",
          "data-invalid": dataAttr(invalid),
          disabled,
          hidden: !computed("hasSelectedItems"),
          dir: prop("dir"),
          onClick(event) {
            if (event.defaultPrevented) return;
            send({ type: "CLEAR.CLICK" });
          }
        }));
      },
      getHiddenSelectProps() {
        const value = context.get("value");
        const defaultValue = prop("multiple") ? value : value == null ? void 0 : value[0];
        return normalize.select({
          name: prop("name"),
          form: prop("form"),
          disabled,
          multiple: prop("multiple"),
          required: prop("required"),
          "aria-hidden": true,
          id: getHiddenSelectId(scope),
          defaultValue,
          style: visuallyHiddenStyle,
          tabIndex: -1,
          // Some browser extensions will focus the hidden select.
          // Let's forward the focus to the trigger.
          onFocus() {
            var _a;
            (_a = getTriggerEl5(scope)) == null ? void 0 : _a.focus({ preventScroll: true });
          },
          "aria-labelledby": getLabelId5(scope)
        });
      },
      getPositionerProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts9.positioner.attrs), {
          dir: prop("dir"),
          id: getPositionerId5(scope),
          style: popperStyles.floating
        }));
      },
      getContentProps() {
        return normalize.element(__spreadProps(__spreadValues({
          hidden: !open,
          dir: prop("dir"),
          id: getContentId6(scope),
          role: composite ? "listbox" : "dialog"
        }, parts9.content.attrs), {
          "data-state": open ? "open" : "closed",
          "data-placement": currentPlacement,
          "data-activedescendant": ariaActiveDescendant,
          "aria-activedescendant": composite ? ariaActiveDescendant : void 0,
          "aria-multiselectable": prop("multiple") && composite ? true : void 0,
          "aria-labelledby": getLabelId5(scope),
          tabIndex: 0,
          onKeyDown(event) {
            if (!interactive) return;
            if (!contains(event.currentTarget, getEventTarget(event))) return;
            if (event.key === "Tab") {
              const valid = isValidTabEvent(event);
              if (!valid) {
                event.preventDefault();
                return;
              }
            }
            const keyMap2 = {
              ArrowUp() {
                send({ type: "CONTENT.ARROW_UP" });
              },
              ArrowDown() {
                send({ type: "CONTENT.ARROW_DOWN" });
              },
              Home() {
                send({ type: "CONTENT.HOME" });
              },
              End() {
                send({ type: "CONTENT.END" });
              },
              Enter() {
                send({ type: "ITEM.CLICK", src: "keydown.enter" });
              },
              Space(event2) {
                var _a;
                if (isTypingAhead) {
                  send({ type: "CONTENT.TYPEAHEAD", key: event2.key });
                } else {
                  (_a = keyMap2.Enter) == null ? void 0 : _a.call(keyMap2, event2);
                }
              }
            };
            const exec = keyMap2[getEventKey(event)];
            if (exec) {
              exec(event);
              event.preventDefault();
              return;
            }
            const target = getEventTarget(event);
            if (isEditableElement(target)) {
              return;
            }
            if (getByTypeahead.isValidEvent(event)) {
              send({ type: "CONTENT.TYPEAHEAD", key: event.key });
              event.preventDefault();
            }
          }
        }));
      },
      getListProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts9.list.attrs), {
          tabIndex: 0,
          role: !composite ? "listbox" : void 0,
          "aria-labelledby": getTriggerId6(scope),
          "aria-activedescendant": !composite ? ariaActiveDescendant : void 0,
          "aria-multiselectable": !composite && prop("multiple") ? true : void 0
        }));
      }
    };
  }
  function restoreFocusFn(event) {
    var _a, _b;
    const v2 = (_b = event.restoreFocus) != null ? _b : (_a = event.previousEvent) == null ? void 0 : _a.restoreFocus;
    return v2 == null || !!v2;
  }
  function snakeToCamel2(str) {
    return str.replace(/_([a-z])/g, (_2, letter) => letter.toUpperCase());
  }
  function transformPositioningOptions2(obj) {
    const result = {};
    for (const [key, value] of Object.entries(obj)) {
      const camelKey = snakeToCamel2(key);
      result[camelKey] = value;
    }
    return result;
  }
  var anatomy9, parts9, collection2, getRootId7, getContentId6, getTriggerId6, getClearTriggerId3, getLabelId5, getControlId4, getItemId4, getHiddenSelectId, getPositionerId5, getItemGroupId2, getItemGroupLabelId2, getHiddenSelectEl, getContentEl6, getTriggerEl5, getClearTriggerEl3, getPositionerEl5, getItemEl3, and5, not5, or2, machine9, props9, splitProps9, itemProps4, splitItemProps4, itemGroupProps3, splitItemGroupProps3, itemGroupLabelProps3, splitItemGroupLabelProps3, Select, SelectHook;
  var init_select = __esm({
    "../priv/static/select.mjs"() {
      "use strict";
      init_chunk_2DWEYSRA();
      init_chunk_GRHV6R4F();
      init_chunk_BPSX7Z7Y();
      init_chunk_GFGFZBBD();
      anatomy9 = createAnatomy("select").parts(
        "label",
        "positioner",
        "trigger",
        "indicator",
        "clearTrigger",
        "item",
        "itemText",
        "itemIndicator",
        "itemGroup",
        "itemGroupLabel",
        "list",
        "content",
        "root",
        "control",
        "valueText"
      );
      parts9 = anatomy9.build();
      collection2 = (options) => {
        return new ListCollection(options);
      };
      collection2.empty = () => {
        return new ListCollection({ items: [] });
      };
      getRootId7 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.root) != null ? _b : `select:${ctx.id}`;
      };
      getContentId6 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.content) != null ? _b : `select:${ctx.id}:content`;
      };
      getTriggerId6 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.trigger) != null ? _b : `select:${ctx.id}:trigger`;
      };
      getClearTriggerId3 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.clearTrigger) != null ? _b : `select:${ctx.id}:clear-trigger`;
      };
      getLabelId5 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.label) != null ? _b : `select:${ctx.id}:label`;
      };
      getControlId4 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.control) != null ? _b : `select:${ctx.id}:control`;
      };
      getItemId4 = (ctx, id) => {
        var _a, _b, _c;
        return (_c = (_b = (_a = ctx.ids) == null ? void 0 : _a.item) == null ? void 0 : _b.call(_a, id)) != null ? _c : `select:${ctx.id}:option:${id}`;
      };
      getHiddenSelectId = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.hiddenSelect) != null ? _b : `select:${ctx.id}:select`;
      };
      getPositionerId5 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.positioner) != null ? _b : `select:${ctx.id}:positioner`;
      };
      getItemGroupId2 = (ctx, id) => {
        var _a, _b, _c;
        return (_c = (_b = (_a = ctx.ids) == null ? void 0 : _a.itemGroup) == null ? void 0 : _b.call(_a, id)) != null ? _c : `select:${ctx.id}:optgroup:${id}`;
      };
      getItemGroupLabelId2 = (ctx, id) => {
        var _a, _b, _c;
        return (_c = (_b = (_a = ctx.ids) == null ? void 0 : _a.itemGroupLabel) == null ? void 0 : _b.call(_a, id)) != null ? _c : `select:${ctx.id}:optgroup-label:${id}`;
      };
      getHiddenSelectEl = (ctx) => ctx.getById(getHiddenSelectId(ctx));
      getContentEl6 = (ctx) => ctx.getById(getContentId6(ctx));
      getTriggerEl5 = (ctx) => ctx.getById(getTriggerId6(ctx));
      getClearTriggerEl3 = (ctx) => ctx.getById(getClearTriggerId3(ctx));
      getPositionerEl5 = (ctx) => ctx.getById(getPositionerId5(ctx));
      getItemEl3 = (ctx, id) => {
        if (id == null) return null;
        return ctx.getById(getItemId4(ctx, id));
      };
      ({ and: and5, not: not5, or: or2 } = createGuards());
      machine9 = createMachine({
        props({ props: props22 }) {
          var _a;
          return __spreadProps(__spreadValues({
            loopFocus: false,
            closeOnSelect: !props22.multiple,
            composite: true,
            defaultValue: []
          }, props22), {
            collection: (_a = props22.collection) != null ? _a : collection2.empty(),
            positioning: __spreadValues({
              placement: "bottom-start",
              gutter: 8
            }, props22.positioning)
          });
        },
        context({ prop, bindable: bindable2 }) {
          return {
            value: bindable2(() => ({
              defaultValue: prop("defaultValue"),
              value: prop("value"),
              isEqual: isEqual2,
              onChange(value) {
                var _a;
                const items = prop("collection").findMany(value);
                return (_a = prop("onValueChange")) == null ? void 0 : _a({ value, items });
              }
            })),
            highlightedValue: bindable2(() => ({
              defaultValue: prop("defaultHighlightedValue") || null,
              value: prop("highlightedValue"),
              onChange(value) {
                var _a;
                (_a = prop("onHighlightChange")) == null ? void 0 : _a({
                  highlightedValue: value,
                  highlightedItem: prop("collection").find(value),
                  highlightedIndex: prop("collection").indexOf(value)
                });
              }
            })),
            currentPlacement: bindable2(() => ({
              defaultValue: void 0
            })),
            fieldsetDisabled: bindable2(() => ({
              defaultValue: false
            })),
            highlightedItem: bindable2(() => ({
              defaultValue: null
            })),
            selectedItems: bindable2(() => {
              var _a, _b;
              const value = (_b = (_a = prop("value")) != null ? _a : prop("defaultValue")) != null ? _b : [];
              const items = prop("collection").findMany(value);
              return { defaultValue: items };
            })
          };
        },
        refs() {
          return {
            typeahead: __spreadValues({}, getByTypeahead.defaultOptions)
          };
        },
        computed: {
          hasSelectedItems: ({ context }) => context.get("value").length > 0,
          isTypingAhead: ({ refs }) => refs.get("typeahead").keysSoFar !== "",
          isDisabled: ({ prop, context }) => !!prop("disabled") || !!context.get("fieldsetDisabled"),
          isInteractive: ({ prop }) => !(prop("disabled") || prop("readOnly")),
          valueAsString: ({ context, prop }) => prop("collection").stringifyItems(context.get("selectedItems"))
        },
        initialState({ prop }) {
          const open = prop("open") || prop("defaultOpen");
          return open ? "open" : "idle";
        },
        entry: ["syncSelectElement"],
        watch({ context, prop, track, action }) {
          track([() => context.get("value").toString()], () => {
            action(["syncSelectedItems", "syncSelectElement", "dispatchChangeEvent"]);
          });
          track([() => prop("open")], () => {
            action(["toggleVisibility"]);
          });
          track([() => context.get("highlightedValue")], () => {
            action(["syncHighlightedItem"]);
          });
          track([() => prop("collection").toString()], () => {
            action(["syncCollection"]);
          });
        },
        on: {
          "HIGHLIGHTED_VALUE.SET": {
            actions: ["setHighlightedItem"]
          },
          "HIGHLIGHTED_VALUE.CLEAR": {
            actions: ["clearHighlightedItem"]
          },
          "ITEM.SELECT": {
            actions: ["selectItem"]
          },
          "ITEM.CLEAR": {
            actions: ["clearItem"]
          },
          "VALUE.SET": {
            actions: ["setSelectedItems"]
          },
          "VALUE.CLEAR": {
            actions: ["clearSelectedItems"]
          },
          "CLEAR.CLICK": {
            actions: ["clearSelectedItems", "focusTriggerEl"]
          }
        },
        effects: ["trackFormControlState"],
        states: {
          idle: {
            tags: ["closed"],
            on: {
              "CONTROLLED.OPEN": [
                {
                  guard: "isTriggerClickEvent",
                  target: "open",
                  actions: ["setInitialFocus", "highlightFirstSelectedItem"]
                },
                {
                  target: "open",
                  actions: ["setInitialFocus"]
                }
              ],
              "TRIGGER.CLICK": [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnOpen"]
                },
                {
                  target: "open",
                  actions: ["invokeOnOpen", "setInitialFocus", "highlightFirstSelectedItem"]
                }
              ],
              "TRIGGER.FOCUS": {
                target: "focused"
              },
              OPEN: [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnOpen"]
                },
                {
                  target: "open",
                  actions: ["setInitialFocus", "invokeOnOpen"]
                }
              ]
            }
          },
          focused: {
            tags: ["closed"],
            on: {
              "CONTROLLED.OPEN": [
                {
                  guard: "isTriggerClickEvent",
                  target: "open",
                  actions: ["setInitialFocus", "highlightFirstSelectedItem"]
                },
                {
                  guard: "isTriggerArrowUpEvent",
                  target: "open",
                  actions: ["setInitialFocus", "highlightComputedLastItem"]
                },
                {
                  guard: or2("isTriggerArrowDownEvent", "isTriggerEnterEvent"),
                  target: "open",
                  actions: ["setInitialFocus", "highlightComputedFirstItem"]
                },
                {
                  target: "open",
                  actions: ["setInitialFocus"]
                }
              ],
              OPEN: [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnOpen"]
                },
                {
                  target: "open",
                  actions: ["setInitialFocus", "invokeOnOpen"]
                }
              ],
              "TRIGGER.BLUR": {
                target: "idle"
              },
              "TRIGGER.CLICK": [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnOpen"]
                },
                {
                  target: "open",
                  actions: ["setInitialFocus", "invokeOnOpen", "highlightFirstSelectedItem"]
                }
              ],
              "TRIGGER.ENTER": [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnOpen"]
                },
                {
                  target: "open",
                  actions: ["setInitialFocus", "invokeOnOpen", "highlightComputedFirstItem"]
                }
              ],
              "TRIGGER.ARROW_UP": [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnOpen"]
                },
                {
                  target: "open",
                  actions: ["setInitialFocus", "invokeOnOpen", "highlightComputedLastItem"]
                }
              ],
              "TRIGGER.ARROW_DOWN": [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnOpen"]
                },
                {
                  target: "open",
                  actions: ["setInitialFocus", "invokeOnOpen", "highlightComputedFirstItem"]
                }
              ],
              "TRIGGER.ARROW_LEFT": [
                {
                  guard: and5(not5("multiple"), "hasSelectedItems"),
                  actions: ["selectPreviousItem"]
                },
                {
                  guard: not5("multiple"),
                  actions: ["selectLastItem"]
                }
              ],
              "TRIGGER.ARROW_RIGHT": [
                {
                  guard: and5(not5("multiple"), "hasSelectedItems"),
                  actions: ["selectNextItem"]
                },
                {
                  guard: not5("multiple"),
                  actions: ["selectFirstItem"]
                }
              ],
              "TRIGGER.HOME": {
                guard: not5("multiple"),
                actions: ["selectFirstItem"]
              },
              "TRIGGER.END": {
                guard: not5("multiple"),
                actions: ["selectLastItem"]
              },
              "TRIGGER.TYPEAHEAD": {
                guard: not5("multiple"),
                actions: ["selectMatchingItem"]
              }
            }
          },
          open: {
            tags: ["open"],
            exit: ["scrollContentToTop"],
            effects: ["trackDismissableElement", "computePlacement", "scrollToHighlightedItem"],
            on: {
              "CONTROLLED.CLOSE": [
                {
                  guard: "restoreFocus",
                  target: "focused",
                  actions: ["focusTriggerEl", "clearHighlightedItem"]
                },
                {
                  target: "idle",
                  actions: ["clearHighlightedItem"]
                }
              ],
              CLOSE: [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnClose"]
                },
                {
                  guard: "restoreFocus",
                  target: "focused",
                  actions: ["invokeOnClose", "focusTriggerEl", "clearHighlightedItem"]
                },
                {
                  target: "idle",
                  actions: ["invokeOnClose", "clearHighlightedItem"]
                }
              ],
              "TRIGGER.CLICK": [
                {
                  guard: "isOpenControlled",
                  actions: ["invokeOnClose"]
                },
                {
                  target: "focused",
                  actions: ["invokeOnClose", "clearHighlightedItem"]
                }
              ],
              "ITEM.CLICK": [
                {
                  guard: and5("closeOnSelect", "isOpenControlled"),
                  actions: ["selectHighlightedItem", "invokeOnClose"]
                },
                {
                  guard: "closeOnSelect",
                  target: "focused",
                  actions: ["selectHighlightedItem", "invokeOnClose", "focusTriggerEl", "clearHighlightedItem"]
                },
                {
                  actions: ["selectHighlightedItem"]
                }
              ],
              "CONTENT.HOME": {
                actions: ["highlightFirstItem"]
              },
              "CONTENT.END": {
                actions: ["highlightLastItem"]
              },
              "CONTENT.ARROW_DOWN": [
                {
                  guard: and5("hasHighlightedItem", "loop", "isLastItemHighlighted"),
                  actions: ["highlightFirstItem"]
                },
                {
                  guard: "hasHighlightedItem",
                  actions: ["highlightNextItem"]
                },
                {
                  actions: ["highlightFirstItem"]
                }
              ],
              "CONTENT.ARROW_UP": [
                {
                  guard: and5("hasHighlightedItem", "loop", "isFirstItemHighlighted"),
                  actions: ["highlightLastItem"]
                },
                {
                  guard: "hasHighlightedItem",
                  actions: ["highlightPreviousItem"]
                },
                {
                  actions: ["highlightLastItem"]
                }
              ],
              "CONTENT.TYPEAHEAD": {
                actions: ["highlightMatchingItem"]
              },
              "ITEM.POINTER_MOVE": {
                actions: ["highlightItem"]
              },
              "ITEM.POINTER_LEAVE": {
                actions: ["clearHighlightedItem"]
              },
              "POSITIONING.SET": {
                actions: ["reposition"]
              }
            }
          }
        },
        implementations: {
          guards: {
            loop: ({ prop }) => !!prop("loopFocus"),
            multiple: ({ prop }) => !!prop("multiple"),
            hasSelectedItems: ({ computed }) => !!computed("hasSelectedItems"),
            hasHighlightedItem: ({ context }) => context.get("highlightedValue") != null,
            isFirstItemHighlighted: ({ context, prop }) => context.get("highlightedValue") === prop("collection").firstValue,
            isLastItemHighlighted: ({ context, prop }) => context.get("highlightedValue") === prop("collection").lastValue,
            closeOnSelect: ({ prop, event }) => {
              var _a;
              return !!((_a = event.closeOnSelect) != null ? _a : prop("closeOnSelect"));
            },
            restoreFocus: ({ event }) => restoreFocusFn(event),
            // guard assertions (for controlled mode)
            isOpenControlled: ({ prop }) => prop("open") !== void 0,
            isTriggerClickEvent: ({ event }) => {
              var _a;
              return ((_a = event.previousEvent) == null ? void 0 : _a.type) === "TRIGGER.CLICK";
            },
            isTriggerEnterEvent: ({ event }) => {
              var _a;
              return ((_a = event.previousEvent) == null ? void 0 : _a.type) === "TRIGGER.ENTER";
            },
            isTriggerArrowUpEvent: ({ event }) => {
              var _a;
              return ((_a = event.previousEvent) == null ? void 0 : _a.type) === "TRIGGER.ARROW_UP";
            },
            isTriggerArrowDownEvent: ({ event }) => {
              var _a;
              return ((_a = event.previousEvent) == null ? void 0 : _a.type) === "TRIGGER.ARROW_DOWN";
            }
          },
          effects: {
            trackFormControlState({ context, scope }) {
              return trackFormControl(getHiddenSelectEl(scope), {
                onFieldsetDisabledChange(disabled) {
                  context.set("fieldsetDisabled", disabled);
                },
                onFormReset() {
                  const value = context.initial("value");
                  context.set("value", value);
                }
              });
            },
            trackDismissableElement({ scope, send, prop }) {
              const contentEl = () => getContentEl6(scope);
              let restoreFocus = true;
              return trackDismissableElement(contentEl, {
                type: "listbox",
                defer: true,
                exclude: [getTriggerEl5(scope), getClearTriggerEl3(scope)],
                onFocusOutside: prop("onFocusOutside"),
                onPointerDownOutside: prop("onPointerDownOutside"),
                onInteractOutside(event) {
                  var _a;
                  (_a = prop("onInteractOutside")) == null ? void 0 : _a(event);
                  restoreFocus = !(event.detail.focusable || event.detail.contextmenu);
                },
                onDismiss() {
                  send({ type: "CLOSE", src: "interact-outside", restoreFocus });
                }
              });
            },
            computePlacement({ context, prop, scope }) {
              const positioning = prop("positioning");
              context.set("currentPlacement", positioning.placement);
              const triggerEl = () => getTriggerEl5(scope);
              const positionerEl = () => getPositionerEl5(scope);
              return getPlacement(triggerEl, positionerEl, __spreadProps(__spreadValues({
                defer: true
              }, positioning), {
                onComplete(data) {
                  context.set("currentPlacement", data.placement);
                }
              }));
            },
            scrollToHighlightedItem({ context, prop, scope, event }) {
              const exec = (immediate) => {
                const highlightedValue = context.get("highlightedValue");
                if (highlightedValue == null) return;
                if (event.current().type.includes("POINTER")) return;
                const contentEl2 = getContentEl6(scope);
                const scrollToIndexFn = prop("scrollToIndexFn");
                if (scrollToIndexFn) {
                  const highlightedIndex = prop("collection").indexOf(highlightedValue);
                  scrollToIndexFn == null ? void 0 : scrollToIndexFn({
                    index: highlightedIndex,
                    immediate,
                    getElement: () => getItemEl3(scope, highlightedValue)
                  });
                  return;
                }
                const itemEl = getItemEl3(scope, highlightedValue);
                scrollIntoView(itemEl, { rootEl: contentEl2, block: "nearest" });
              };
              raf(() => exec(true));
              const contentEl = () => getContentEl6(scope);
              return observeAttributes(contentEl, {
                defer: true,
                attributes: ["data-activedescendant"],
                callback() {
                  exec(false);
                }
              });
            }
          },
          actions: {
            reposition({ context, prop, scope, event }) {
              const positionerEl = () => getPositionerEl5(scope);
              getPlacement(getTriggerEl5(scope), positionerEl, __spreadProps(__spreadValues(__spreadValues({}, prop("positioning")), event.options), {
                defer: true,
                listeners: false,
                onComplete(data) {
                  context.set("currentPlacement", data.placement);
                }
              }));
            },
            toggleVisibility({ send, prop, event }) {
              send({ type: prop("open") ? "CONTROLLED.OPEN" : "CONTROLLED.CLOSE", previousEvent: event });
            },
            highlightPreviousItem({ context, prop }) {
              const highlightedValue = context.get("highlightedValue");
              if (highlightedValue == null) return;
              const value = prop("collection").getPreviousValue(highlightedValue, 1, prop("loopFocus"));
              if (value == null) return;
              context.set("highlightedValue", value);
            },
            highlightNextItem({ context, prop }) {
              const highlightedValue = context.get("highlightedValue");
              if (highlightedValue == null) return;
              const value = prop("collection").getNextValue(highlightedValue, 1, prop("loopFocus"));
              if (value == null) return;
              context.set("highlightedValue", value);
            },
            highlightFirstItem({ context, prop }) {
              const value = prop("collection").firstValue;
              context.set("highlightedValue", value);
            },
            highlightLastItem({ context, prop }) {
              const value = prop("collection").lastValue;
              context.set("highlightedValue", value);
            },
            setInitialFocus({ scope }) {
              raf(() => {
                const element = getInitialFocus({
                  root: getContentEl6(scope)
                });
                element == null ? void 0 : element.focus({ preventScroll: true });
              });
            },
            focusTriggerEl({ event, scope }) {
              if (!restoreFocusFn(event)) return;
              raf(() => {
                const element = getTriggerEl5(scope);
                element == null ? void 0 : element.focus({ preventScroll: true });
              });
            },
            selectHighlightedItem({ context, prop, event }) {
              var _a, _b;
              let value = (_a = event.value) != null ? _a : context.get("highlightedValue");
              if (value == null || !prop("collection").has(value)) return;
              (_b = prop("onSelect")) == null ? void 0 : _b({ value });
              const nullable = prop("deselectable") && !prop("multiple") && context.get("value").includes(value);
              value = nullable ? null : value;
              context.set("value", (prev2) => {
                if (value == null) return [];
                if (prop("multiple")) return addOrRemove(prev2, value);
                return [value];
              });
            },
            highlightComputedFirstItem({ context, prop, computed }) {
              const collection22 = prop("collection");
              const value = computed("hasSelectedItems") ? collection22.sort(context.get("value"))[0] : collection22.firstValue;
              context.set("highlightedValue", value);
            },
            highlightComputedLastItem({ context, prop, computed }) {
              const collection22 = prop("collection");
              const value = computed("hasSelectedItems") ? collection22.sort(context.get("value"))[0] : collection22.lastValue;
              context.set("highlightedValue", value);
            },
            highlightFirstSelectedItem({ context, prop, computed }) {
              if (!computed("hasSelectedItems")) return;
              const value = prop("collection").sort(context.get("value"))[0];
              context.set("highlightedValue", value);
            },
            highlightItem({ context, event }) {
              context.set("highlightedValue", event.value);
            },
            highlightMatchingItem({ context, prop, event, refs }) {
              const value = prop("collection").search(event.key, {
                state: refs.get("typeahead"),
                currentValue: context.get("highlightedValue")
              });
              if (value == null) return;
              context.set("highlightedValue", value);
            },
            setHighlightedItem({ context, event }) {
              context.set("highlightedValue", event.value);
            },
            clearHighlightedItem({ context }) {
              context.set("highlightedValue", null);
            },
            selectItem({ context, prop, event }) {
              var _a;
              (_a = prop("onSelect")) == null ? void 0 : _a({ value: event.value });
              const nullable = prop("deselectable") && !prop("multiple") && context.get("value").includes(event.value);
              const value = nullable ? null : event.value;
              context.set("value", (prev2) => {
                if (value == null) return [];
                if (prop("multiple")) return addOrRemove(prev2, value);
                return [value];
              });
            },
            clearItem({ context, event }) {
              context.set("value", (prev2) => prev2.filter((v2) => v2 !== event.value));
            },
            setSelectedItems({ context, event }) {
              context.set("value", event.value);
            },
            clearSelectedItems({ context }) {
              context.set("value", []);
            },
            selectPreviousItem({ context, prop }) {
              const [firstItem] = context.get("value");
              const value = prop("collection").getPreviousValue(firstItem);
              if (value) context.set("value", [value]);
            },
            selectNextItem({ context, prop }) {
              const [firstItem] = context.get("value");
              const value = prop("collection").getNextValue(firstItem);
              if (value) context.set("value", [value]);
            },
            selectFirstItem({ context, prop }) {
              const value = prop("collection").firstValue;
              if (value) context.set("value", [value]);
            },
            selectLastItem({ context, prop }) {
              const value = prop("collection").lastValue;
              if (value) context.set("value", [value]);
            },
            selectMatchingItem({ context, prop, event, refs }) {
              const value = prop("collection").search(event.key, {
                state: refs.get("typeahead"),
                currentValue: context.get("value")[0]
              });
              if (value == null) return;
              context.set("value", [value]);
            },
            scrollContentToTop({ prop, scope }) {
              var _a, _b;
              if (prop("scrollToIndexFn")) {
                const firstValue = prop("collection").firstValue;
                (_a = prop("scrollToIndexFn")) == null ? void 0 : _a({
                  index: 0,
                  immediate: true,
                  getElement: () => getItemEl3(scope, firstValue)
                });
              } else {
                (_b = getContentEl6(scope)) == null ? void 0 : _b.scrollTo(0, 0);
              }
            },
            invokeOnOpen({ prop, context }) {
              var _a;
              (_a = prop("onOpenChange")) == null ? void 0 : _a({ open: true, value: context.get("value") });
            },
            invokeOnClose({ prop, context }) {
              var _a;
              (_a = prop("onOpenChange")) == null ? void 0 : _a({ open: false, value: context.get("value") });
            },
            syncSelectElement({ context, prop, scope }) {
              const selectEl = getHiddenSelectEl(scope);
              if (!selectEl) return;
              if (context.get("value").length === 0 && !prop("multiple")) {
                selectEl.selectedIndex = -1;
                return;
              }
              for (const option of selectEl.options) {
                option.selected = context.get("value").includes(option.value);
              }
            },
            syncCollection({ context, prop }) {
              const collection22 = prop("collection");
              const highlightedItem = collection22.find(context.get("highlightedValue"));
              if (highlightedItem) context.set("highlightedItem", highlightedItem);
              const selectedItems = collection22.findMany(context.get("value"));
              context.set("selectedItems", selectedItems);
            },
            syncSelectedItems({ context, prop }) {
              const collection22 = prop("collection");
              const prevSelectedItems = context.get("selectedItems");
              const value = context.get("value");
              const selectedItems = value.map((value2) => {
                const item = prevSelectedItems.find((item2) => collection22.getItemValue(item2) === value2);
                return item || collection22.find(value2);
              });
              context.set("selectedItems", selectedItems);
            },
            syncHighlightedItem({ context, prop }) {
              const collection22 = prop("collection");
              const highlightedValue = context.get("highlightedValue");
              const highlightedItem = highlightedValue ? collection22.find(highlightedValue) : null;
              context.set("highlightedItem", highlightedItem);
            },
            dispatchChangeEvent({ scope }) {
              queueMicrotask(() => {
                const node = getHiddenSelectEl(scope);
                if (!node) return;
                const win = scope.getWin();
                const changeEvent = new win.Event("change", { bubbles: true, composed: true });
                node.dispatchEvent(changeEvent);
              });
            }
          }
        }
      });
      props9 = createProps()([
        "closeOnSelect",
        "collection",
        "composite",
        "defaultHighlightedValue",
        "defaultOpen",
        "defaultValue",
        "deselectable",
        "dir",
        "disabled",
        "form",
        "getRootNode",
        "highlightedValue",
        "id",
        "ids",
        "invalid",
        "loopFocus",
        "multiple",
        "name",
        "onFocusOutside",
        "onHighlightChange",
        "onInteractOutside",
        "onOpenChange",
        "onPointerDownOutside",
        "onSelect",
        "onValueChange",
        "open",
        "positioning",
        "readOnly",
        "required",
        "scrollToIndexFn",
        "value"
      ]);
      splitProps9 = createSplitProps(props9);
      itemProps4 = createProps()(["item", "persistFocus"]);
      splitItemProps4 = createSplitProps(itemProps4);
      itemGroupProps3 = createProps()(["id"]);
      splitItemGroupProps3 = createSplitProps(itemGroupProps3);
      itemGroupLabelProps3 = createProps()(["htmlFor"]);
      splitItemGroupLabelProps3 = createSplitProps(itemGroupLabelProps3);
      Select = class extends Component {
        constructor(el, props22) {
          super(el, props22);
          __publicField(this, "_options", []);
          __publicField(this, "hasGroups", false);
          __publicField(this, "placeholder", "");
          this.placeholder = getString(this.el, "placeholder") || "";
        }
        get options() {
          return Array.isArray(this._options) ? this._options : [];
        }
        setOptions(options) {
          this._options = Array.isArray(options) ? options : [];
        }
        getCollection() {
          const items = this.options;
          if (this.hasGroups) {
            return collection2({
              items,
              itemToValue: (item) => {
                var _a, _b;
                return (_b = (_a = item.id) != null ? _a : item.value) != null ? _b : "";
              },
              itemToString: (item) => item.label,
              isItemDisabled: (item) => !!item.disabled,
              groupBy: (item) => item.group
            });
          }
          return collection2({
            items,
            itemToValue: (item) => {
              var _a, _b;
              return (_b = (_a = item.id) != null ? _a : item.value) != null ? _b : "";
            },
            itemToString: (item) => item.label,
            isItemDisabled: (item) => !!item.disabled
          });
        }
        initMachine(props22) {
          const self2 = this;
          return new VanillaMachine(machine9, __spreadProps(__spreadValues({}, props22), {
            get collection() {
              return self2.getCollection();
            }
          }));
        }
        initApi() {
          return connect9(this.machine.service, normalizeProps);
        }
        renderItems() {
          var _a, _b, _c;
          const contentEl = this.el.querySelector(
            '[data-scope="select"][data-part="content"]'
          );
          if (!contentEl) return;
          const templatesContainer = this.el.querySelector('[data-templates="select"]');
          if (!templatesContainer) return;
          contentEl.querySelectorAll('[data-scope="select"][data-part="item"]:not([data-template])').forEach((el) => el.remove());
          contentEl.querySelectorAll('[data-scope="select"][data-part="item-group"]:not([data-template])').forEach((el) => el.remove());
          const items = this.api.collection.items;
          const groups = (_c = (_b = (_a = this.api.collection).group) == null ? void 0 : _b.call(_a)) != null ? _c : [];
          const hasGroupsInCollection = groups.some(([group2]) => group2 != null);
          if (hasGroupsInCollection) {
            this.renderGroupedItems(contentEl, templatesContainer, groups);
          } else {
            this.renderFlatItems(contentEl, templatesContainer, items);
          }
        }
        renderGroupedItems(contentEl, templatesContainer, groups) {
          for (const [groupId, groupItems] of groups) {
            if (groupId == null) continue;
            const groupTemplate = templatesContainer.querySelector(
              `[data-scope="select"][data-part="item-group"][data-id="${groupId}"][data-template]`
            );
            if (!groupTemplate) continue;
            const groupEl = groupTemplate.cloneNode(true);
            groupEl.removeAttribute("data-template");
            this.spreadProps(groupEl, this.api.getItemGroupProps({ id: groupId }));
            const labelEl = groupEl.querySelector(
              '[data-scope="select"][data-part="item-group-label"]'
            );
            if (labelEl) {
              this.spreadProps(
                labelEl,
                this.api.getItemGroupLabelProps({ htmlFor: groupId })
              );
            }
            const templateItems = groupEl.querySelectorAll(
              '[data-scope="select"][data-part="item"][data-template]'
            );
            templateItems.forEach((item) => item.remove());
            for (const item of groupItems) {
              const itemEl = this.cloneItem(templatesContainer, item);
              if (itemEl) groupEl.appendChild(itemEl);
            }
            contentEl.appendChild(groupEl);
          }
        }
        renderFlatItems(contentEl, templatesContainer, items) {
          for (const item of items) {
            const itemEl = this.cloneItem(templatesContainer, item);
            if (itemEl) contentEl.appendChild(itemEl);
          }
        }
        cloneItem(templatesContainer, item) {
          const value = this.api.collection.getItemValue(item);
          const template = templatesContainer.querySelector(
            `[data-scope="select"][data-part="item"][data-value="${value}"][data-template]`
          );
          if (!template) return null;
          const el = template.cloneNode(true);
          el.removeAttribute("data-template");
          this.spreadProps(el, this.api.getItemProps({ item }));
          const textEl = el.querySelector(
            '[data-scope="select"][data-part="item-text"]'
          );
          if (textEl) {
            this.spreadProps(textEl, this.api.getItemTextProps({ item }));
          }
          const indicatorEl = el.querySelector(
            '[data-scope="select"][data-part="item-indicator"]'
          );
          if (indicatorEl) {
            this.spreadProps(
              indicatorEl,
              this.api.getItemIndicatorProps({ item })
            );
          }
          return el;
        }
        render() {
          const root = this.el.querySelector('[data-scope="select"][data-part="root"]');
          if (!root) return;
          this.spreadProps(root, this.api.getRootProps());
          const hiddenSelect = this.el.querySelector(
            '[data-scope="select"][data-part="hidden-select"]'
          );
          const valueInput = this.el.querySelector(
            '[data-scope="select"][data-part="value-input"]'
          );
          if (valueInput) {
            if (!this.api.value || this.api.value.length === 0) {
              valueInput.value = "";
            } else if (this.api.value.length === 1) {
              valueInput.value = String(this.api.value[0]);
            } else {
              valueInput.value = this.api.value.map(String).join(",");
            }
          }
          if (hiddenSelect) {
            this.spreadProps(hiddenSelect, this.api.getHiddenSelectProps());
          }
          [
            "label",
            "control",
            "trigger",
            "indicator",
            "clear-trigger",
            "positioner"
          ].forEach((part) => {
            const el = this.el.querySelector(
              `[data-scope="select"][data-part="${part}"]`
            );
            if (!el) return;
            const method = "get" + part.split("-").map((s2) => s2[0].toUpperCase() + s2.slice(1)).join("") + "Props";
            this.spreadProps(el, this.api[method]());
          });
          const valueText = this.el.querySelector(
            '[data-scope="select"][data-part="item-text"]'
          );
          if (valueText) {
            const valueAsString = this.api.valueAsString;
            if (this.api.value && this.api.value.length > 0 && !valueAsString) {
              const selectedValue = this.api.value[0];
              const selectedItem = this.options.find((item) => {
                var _a, _b;
                const itemValue = (_b = (_a = item.id) != null ? _a : item.value) != null ? _b : "";
                return String(itemValue) === String(selectedValue);
              });
              if (selectedItem) {
                valueText.textContent = selectedItem.label;
              } else {
                valueText.textContent = this.placeholder || "";
              }
            } else {
              valueText.textContent = valueAsString || this.placeholder || "";
            }
          }
          const contentEl = this.el.querySelector(
            '[data-scope="select"][data-part="content"]'
          );
          if (contentEl) {
            this.spreadProps(contentEl, this.api.getContentProps());
            this.renderItems();
          }
        }
      };
      SelectHook = {
        mounted() {
          const el = this.el;
          const allItems = JSON.parse(el.dataset.collection || "[]");
          const hasGroups = allItems.some((item) => item.group !== void 0);
          let selectComponent;
          const hook = this;
          this.wasFocused = false;
          selectComponent = new Select(
            el,
            __spreadProps(__spreadValues({
              id: el.id
            }, getBoolean(el, "controlled") ? { value: getStringList(el, "value") } : { defaultValue: getStringList(el, "defaultValue") }), {
              disabled: getBoolean(el, "disabled"),
              closeOnSelect: getBoolean(el, "closeOnSelect"),
              dir: getString(el, "dir", ["ltr", "rtl"]),
              loopFocus: getBoolean(el, "loopFocus"),
              multiple: getBoolean(el, "multiple"),
              invalid: getBoolean(el, "invalid"),
              name: getString(el, "name"),
              form: getString(el, "form"),
              readOnly: getBoolean(el, "readOnly"),
              required: getBoolean(el, "required"),
              positioning: (() => {
                const positioningJson = el.dataset.positioning;
                if (positioningJson) {
                  try {
                    const parsed = JSON.parse(positioningJson);
                    return transformPositioningOptions2(parsed);
                  } catch (e2) {
                    return void 0;
                  }
                }
                return void 0;
              })(),
              onValueChange: (details) => {
                var _a;
                const redirect = getBoolean(el, "redirect");
                const firstValue = details.value.length > 0 ? String(details.value[0]) : null;
                const firstItem = ((_a = details.items) == null ? void 0 : _a.length) ? details.items[0] : null;
                const itemRedirect = firstItem && typeof firstItem === "object" && firstItem !== null && "redirect" in firstItem ? firstItem.redirect : void 0;
                const itemNewTab = firstItem && typeof firstItem === "object" && firstItem !== null && "new_tab" in firstItem ? firstItem.new_tab : void 0;
                const doRedirect = redirect && firstValue && hook.liveSocket.main.isDead && itemRedirect !== false;
                const openInNewTab = itemNewTab === true;
                if (doRedirect) {
                  if (openInNewTab) {
                    window.open(firstValue, "_blank", "noopener,noreferrer");
                  } else {
                    window.location.href = firstValue;
                  }
                }
                const valueInput = el.querySelector(
                  '[data-scope="select"][data-part="value-input"]'
                );
                if (valueInput) {
                  valueInput.value = details.value.length === 0 ? "" : details.value.length === 1 ? String(details.value[0]) : details.value.map(String).join(",");
                  valueInput.dispatchEvent(new Event("input", { bubbles: true }));
                  valueInput.dispatchEvent(new Event("change", { bubbles: true }));
                }
                const payload = {
                  value: details.value,
                  items: details.items,
                  id: el.id
                };
                const encodedJS = el.getAttribute("data-on-value-change-js");
                if (encodedJS) {
                  let js = encodedJS;
                  const indexMatches = [...js.matchAll(/__VALUE_(\d+)__/g)].map((m2) => parseInt(m2[1], 10));
                  const uniqueIndices = [...new Set(indexMatches)].sort((a2, b2) => b2 - a2);
                  for (const i2 of uniqueIndices) {
                    const val = details.value[i2];
                    const str = val !== void 0 && val !== null ? String(val) : "";
                    const escaped = JSON.stringify(str).slice(1, -1);
                    js = js.split(`__VALUE_${i2}__`).join(escaped);
                  }
                  js = js.split("__VALUE__").join(JSON.stringify(details.value));
                  hook.liveSocket.execJS(el, js);
                }
                const clientEventName = getString(el, "onValueChangeClient");
                if (clientEventName) {
                  el.dispatchEvent(
                    new CustomEvent(clientEventName, { bubbles: true, detail: payload })
                  );
                }
                const serverEventName = getString(el, "onValueChange");
                if (serverEventName && !hook.liveSocket.main.isDead && hook.liveSocket.main.isConnected()) {
                  this.pushEvent(serverEventName, payload);
                }
              }
            })
          );
          selectComponent.hasGroups = hasGroups;
          selectComponent.setOptions(allItems);
          selectComponent.init();
          this.select = selectComponent;
          this.handlers = [];
        },
        beforeUpdate() {
          var _a, _b, _c;
          this.wasFocused = (_c = (_b = (_a = this.select) == null ? void 0 : _a.api) == null ? void 0 : _b.focused) != null ? _c : false;
        },
        updated() {
          const newCollection = JSON.parse(this.el.dataset.collection || "[]");
          const hasGroups = newCollection.some((item) => item.group !== void 0);
          if (this.select) {
            this.select.hasGroups = hasGroups;
            this.select.setOptions(newCollection);
            this.select.updateProps(__spreadProps(__spreadValues({
              id: this.el.id
            }, getBoolean(this.el, "controlled") ? { value: getStringList(this.el, "value") } : { defaultValue: getStringList(this.el, "defaultValue") }), {
              name: getString(this.el, "name"),
              form: getString(this.el, "form"),
              disabled: getBoolean(this.el, "disabled"),
              multiple: getBoolean(this.el, "multiple"),
              dir: getString(this.el, "dir", ["ltr", "rtl"]),
              invalid: getBoolean(this.el, "invalid"),
              required: getBoolean(this.el, "required"),
              readOnly: getBoolean(this.el, "readOnly")
            }));
            if (getBoolean(this.el, "controlled")) {
              if (this.wasFocused) {
                const trigger = this.el.querySelector('[data-scope="select"][data-part="trigger"]');
                if (trigger && document.activeElement !== trigger) {
                  trigger.focus();
                }
              }
            }
          }
        },
        destroyed() {
          var _a;
          if (this.handlers) {
            for (const handler of this.handlers) {
              this.removeHandleEvent(handler);
            }
          }
          (_a = this.select) == null ? void 0 : _a.destroy();
        }
      };
    }
  });

  // ../priv/static/signature-pad.mjs
  var signature_pad_exports = {};
  __export(signature_pad_exports, {
    SignaturePad: () => SignaturePadHook
  });
  function i(e2, t2, n2, r2 = (e3) => e3) {
    return e2 * r2(0.5 - t2 * (0.5 - n2));
  }
  function o(e2, t2, n2) {
    let r2 = a(1, t2 / n2);
    return a(1, e2 + (a(1, 1 - r2) - e2) * (r2 * 0.275));
  }
  function s(e2) {
    return [-e2[0], -e2[1]];
  }
  function c(e2, t2) {
    return [e2[0] + t2[0], e2[1] + t2[1]];
  }
  function l(e2, t2, n2) {
    return e2[0] = t2[0] + n2[0], e2[1] = t2[1] + n2[1], e2;
  }
  function u(e2, t2) {
    return [e2[0] - t2[0], e2[1] - t2[1]];
  }
  function d(e2, t2, n2) {
    return e2[0] = t2[0] - n2[0], e2[1] = t2[1] - n2[1], e2;
  }
  function f(e2, t2) {
    return [e2[0] * t2, e2[1] * t2];
  }
  function p(e2, t2, n2) {
    return e2[0] = t2[0] * n2, e2[1] = t2[1] * n2, e2;
  }
  function m(e2, t2) {
    return [e2[0] / t2, e2[1] / t2];
  }
  function h(e2) {
    return [e2[1], -e2[0]];
  }
  function g(e2, t2) {
    let n2 = t2[0];
    return e2[0] = t2[1], e2[1] = -n2, e2;
  }
  function ee(e2, t2) {
    return e2[0] * t2[0] + e2[1] * t2[1];
  }
  function _(e2, t2) {
    return e2[0] === t2[0] && e2[1] === t2[1];
  }
  function v(e2) {
    return Math.hypot(e2[0], e2[1]);
  }
  function y(e2, t2) {
    let n2 = e2[0] - t2[0], r2 = e2[1] - t2[1];
    return n2 * n2 + r2 * r2;
  }
  function b(e2) {
    return m(e2, v(e2));
  }
  function x(e2, t2) {
    return Math.hypot(e2[1] - t2[1], e2[0] - t2[0]);
  }
  function S(e2, t2, n2) {
    let r2 = Math.sin(n2), i2 = Math.cos(n2), a2 = e2[0] - t2[0], o2 = e2[1] - t2[1], s2 = a2 * i2 - o2 * r2, c2 = a2 * r2 + o2 * i2;
    return [s2 + t2[0], c2 + t2[1]];
  }
  function C(e2, t2, n2, r2) {
    let i2 = Math.sin(r2), a2 = Math.cos(r2), o2 = t2[0] - n2[0], s2 = t2[1] - n2[1], c2 = o2 * a2 - s2 * i2, l2 = o2 * i2 + s2 * a2;
    return e2[0] = c2 + n2[0], e2[1] = l2 + n2[1], e2;
  }
  function w(e2, t2, n2) {
    return c(e2, f(u(t2, e2), n2));
  }
  function te(e2, t2, n2, r2) {
    let i2 = n2[0] - t2[0], a2 = n2[1] - t2[1];
    return e2[0] = t2[0] + i2 * r2, e2[1] = t2[1] + a2 * r2, e2;
  }
  function T(e2, t2, n2) {
    return c(e2, f(t2, n2));
  }
  function k(e2, n2) {
    let r2 = T(e2, b(h(u(e2, c(e2, [1, 1])))), -n2), i2 = [], a2 = 1 / 13;
    for (let n3 = a2; n3 <= 1; n3 += a2) i2.push(S(r2, e2, t * 2 * n3));
    return i2;
  }
  function A(e2, n2, r2) {
    let i2 = [], a2 = 1 / r2;
    for (let r3 = a2; r3 <= 1; r3 += a2) i2.push(S(n2, e2, t * r3));
    return i2;
  }
  function j(e2, t2, n2) {
    let r2 = u(t2, n2), i2 = f(r2, 0.5), a2 = f(r2, 0.51);
    return [u(e2, i2), u(e2, a2), c(e2, a2), c(e2, i2)];
  }
  function M(e2, n2, r2, i2) {
    let a2 = [], o2 = T(e2, n2, r2), s2 = 1 / i2;
    for (let n3 = s2; n3 < 1; n3 += s2) a2.push(S(o2, e2, t * 3 * n3));
    return a2;
  }
  function ne(e2, t2, n2) {
    return [c(e2, f(t2, n2)), c(e2, f(t2, n2 * 0.99)), u(e2, f(t2, n2 * 0.99)), u(e2, f(t2, n2))];
  }
  function N(e2, t2, n2) {
    return e2 === false || e2 === void 0 ? 0 : e2 === true ? Math.max(t2, n2) : e2;
  }
  function re(e2, t2, n2) {
    return e2.slice(0, 10).reduce((e3, r2) => {
      let i2 = r2.pressure;
      return t2 && (i2 = o(e3, r2.distance, n2)), (e3 + i2) / 2;
    }, e2[0].pressure);
  }
  function P(e2, n2 = {}) {
    let { size: r2 = 16, smoothing: a2 = 0.5, thinning: f2 = 0.5, simulatePressure: m2 = true, easing: _2 = (e3) => e3, start: v2 = {}, end: b2 = {}, last: x2 = false } = n2, { cap: S2 = true, easing: w2 = (e3) => e3 * (2 - e3) } = v2, { cap: T2 = true, easing: P2 = (e3) => --e3 * e3 * e3 + 1 } = b2;
    if (e2.length === 0 || r2 <= 0) return [];
    let F2 = e2[e2.length - 1].runningLength, I2 = N(v2.taper, r2, F2), L2 = N(b2.taper, r2, F2), R2 = (r2 * a2) ** 2, z2 = [], B = [], V = re(e2, m2, r2), H = i(r2, f2, e2[e2.length - 1].pressure, _2), U, W = e2[0].vector, G = e2[0].point, K = G, q = G, J = K, Y = false;
    for (let n3 = 0; n3 < e2.length; n3++) {
      let { pressure: a3 } = e2[n3], { point: s2, vector: h2, distance: v3, runningLength: b3 } = e2[n3], x3 = n3 === e2.length - 1;
      if (!x3 && F2 - b3 < 3) continue;
      f2 ? (m2 && (a3 = o(V, v3, r2)), H = i(r2, f2, a3, _2)) : H = r2 / 2, U === void 0 && (U = H);
      let S3 = b3 < I2 ? w2(b3 / I2) : 1, T3 = F2 - b3 < L2 ? P2((F2 - b3) / L2) : 1;
      H = Math.max(0.01, H * Math.min(S3, T3));
      let k2 = (x3 ? e2[n3] : e2[n3 + 1]).vector, A2 = x3 ? 1 : ee(h2, k2), j2 = ee(h2, W) < 0 && !Y, M2 = A2 !== null && A2 < 0;
      if (j2 || M2) {
        g(E, W), p(E, E, H);
        for (let e3 = 0; e3 <= 1; e3 += 0.07692307692307693) d(D, s2, E), C(D, D, s2, t * e3), q = [D[0], D[1]], z2.push(q), l(O, s2, E), C(O, O, s2, t * -e3), J = [O[0], O[1]], B.push(J);
        G = q, K = J, M2 && (Y = true);
        continue;
      }
      if (Y = false, x3) {
        g(E, h2), p(E, E, H), z2.push(u(s2, E)), B.push(c(s2, E));
        continue;
      }
      te(E, k2, h2, A2), g(E, E), p(E, E, H), d(D, s2, E), q = [D[0], D[1]], (n3 <= 1 || y(G, q) > R2) && (z2.push(q), G = q), l(O, s2, E), J = [O[0], O[1]], (n3 <= 1 || y(K, J) > R2) && (B.push(J), K = J), V = a3, W = h2;
    }
    let X = [e2[0].point[0], e2[0].point[1]], Z = e2.length > 1 ? [e2[e2.length - 1].point[0], e2[e2.length - 1].point[1]] : c(e2[0].point, [1, 1]), Q = [], $ = [];
    if (e2.length === 1) {
      if (!(I2 || L2) || x2) return k(X, U || H);
    } else {
      I2 || L2 && e2.length === 1 || (S2 ? Q.push(...A(X, B[0], 13)) : Q.push(...j(X, z2[0], B[0])));
      let t2 = h(s(e2[e2.length - 1].vector));
      L2 || I2 && e2.length === 1 ? $.push(Z) : T2 ? $.push(...M(Z, t2, H, 29)) : $.push(...ne(Z, t2, H));
    }
    return z2.concat($, B.reverse(), Q);
  }
  function I(e2) {
    return e2 != null && e2 >= 0;
  }
  function L(e2, t2 = {}) {
    var _a;
    let { streamline: i2 = 0.5, size: a2 = 16, last: o2 = false } = t2;
    if (e2.length === 0) return [];
    let s2 = 0.15 + (1 - i2) * 0.85, l2 = Array.isArray(e2[0]) ? e2 : e2.map(({ x: e3, y: t3, pressure: r2 = n }) => [e3, t3, r2]);
    if (l2.length === 2) {
      let e3 = l2[1];
      l2 = l2.slice(0, -1);
      for (let t3 = 1; t3 < 5; t3++) l2.push(w(l2[0], e3, t3 / 4));
    }
    l2.length === 1 && (l2 = [...l2, [...c(l2[0], r), ...l2[0].slice(2)]]);
    let u2 = [{ point: [l2[0][0], l2[0][1]], pressure: I(l2[0][2]) ? l2[0][2] : 0.25, vector: [...r], distance: 0, runningLength: 0 }], f2 = false, p2 = 0, m2 = u2[0], h2 = l2.length - 1;
    for (let e3 = 1; e3 < l2.length; e3++) {
      let t3 = o2 && e3 === h2 ? [l2[e3][0], l2[e3][1]] : w(m2.point, l2[e3], s2);
      if (_(m2.point, t3)) continue;
      let r2 = x(t3, m2.point);
      if (p2 += r2, e3 < h2 && !f2) {
        if (p2 < a2) continue;
        f2 = true;
      }
      d(F, m2.point, t3), m2 = { point: t3, pressure: I(l2[e3][2]) ? l2[e3][2] : n, vector: b(F), distance: r2, runningLength: p2 }, u2.push(m2);
    }
    return u2[0].vector = ((_a = u2[1]) == null ? void 0 : _a.vector) || [0, 0], u2;
  }
  function R(e2, t2 = {}) {
    return P(L(e2, t2), t2);
  }
  function connect10(service, normalize) {
    const { state: state2, send, prop, computed, context, scope } = service;
    const drawing = state2.matches("drawing");
    const empty = computed("isEmpty");
    const interactive = computed("isInteractive");
    const disabled = !!prop("disabled");
    const required = !!prop("required");
    const translations = prop("translations");
    return {
      empty,
      drawing,
      currentPath: context.get("currentPath"),
      paths: context.get("paths"),
      clear() {
        send({ type: "CLEAR" });
      },
      getDataUrl(type, quality) {
        if (computed("isEmpty")) return Promise.resolve("");
        return getDataUrl2(scope, { type, quality });
      },
      getLabelProps() {
        return normalize.label(__spreadProps(__spreadValues({}, parts10.label.attrs), {
          id: getLabelId6(scope),
          "data-disabled": dataAttr(disabled),
          "data-required": dataAttr(required),
          htmlFor: getHiddenInputId2(scope),
          onClick(event) {
            if (!interactive) return;
            if (event.defaultPrevented) return;
            const controlEl = getControlEl3(scope);
            controlEl == null ? void 0 : controlEl.focus({ preventScroll: true });
          }
        }));
      },
      getRootProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts10.root.attrs), {
          "data-disabled": dataAttr(disabled),
          id: getRootId8(scope)
        }));
      },
      getControlProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts10.control.attrs), {
          tabIndex: disabled ? void 0 : 0,
          id: getControlId5(scope),
          role: "application",
          "aria-roledescription": "signature pad",
          "aria-label": translations.control,
          "aria-disabled": disabled,
          "data-disabled": dataAttr(disabled),
          onPointerDown(event) {
            if (!isLeftClick(event)) return;
            if (isModifierKey(event)) return;
            if (!interactive) return;
            const target = getEventTarget(event);
            if (target == null ? void 0 : target.closest("[data-part=clear-trigger]")) return;
            event.currentTarget.setPointerCapture(event.pointerId);
            const point = { x: event.clientX, y: event.clientY };
            const controlEl = getControlEl3(scope);
            if (!controlEl) return;
            const { offset: offset3 } = getRelativePoint(point, controlEl);
            send({ type: "POINTER_DOWN", point: offset3, pressure: event.pressure });
          },
          onPointerUp(event) {
            if (!interactive) return;
            if (event.currentTarget.hasPointerCapture(event.pointerId)) {
              event.currentTarget.releasePointerCapture(event.pointerId);
            }
          },
          style: {
            position: "relative",
            touchAction: "none",
            userSelect: "none",
            WebkitUserSelect: "none"
          }
        }));
      },
      getSegmentProps() {
        return normalize.svg(__spreadProps(__spreadValues({}, parts10.segment.attrs), {
          style: {
            position: "absolute",
            top: 0,
            left: 0,
            width: "100%",
            height: "100%",
            pointerEvents: "none",
            fill: prop("drawing").fill
          }
        }));
      },
      getSegmentPathProps(props22) {
        return normalize.path(__spreadProps(__spreadValues({}, parts10.segmentPath.attrs), {
          d: props22.path
        }));
      },
      getGuideProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts10.guide.attrs), {
          "data-disabled": dataAttr(disabled)
        }));
      },
      getClearTriggerProps() {
        return normalize.button(__spreadProps(__spreadValues({}, parts10.clearTrigger.attrs), {
          type: "button",
          "aria-label": translations.clearTrigger,
          hidden: !context.get("paths").length || drawing,
          disabled,
          onClick() {
            send({ type: "CLEAR" });
          }
        }));
      },
      getHiddenInputProps(props22) {
        return normalize.input({
          id: getHiddenInputId2(scope),
          type: "text",
          hidden: true,
          disabled,
          required: prop("required"),
          readOnly: true,
          name: prop("name"),
          value: props22.value
        });
      }
    };
  }
  function getSvgPathFromStroke(points, closed = true) {
    const len = points.length;
    if (len < 4) {
      return "";
    }
    let a2 = points[0];
    let b2 = points[1];
    const c2 = points[2];
    let result = `M${a2[0].toFixed(2)},${a2[1].toFixed(2)} Q${b2[0].toFixed(2)},${b2[1].toFixed(2)} ${average(b2[0], c2[0]).toFixed(2)},${average(
      b2[1],
      c2[1]
    ).toFixed(2)} T`;
    for (let i2 = 2, max4 = len - 1; i2 < max4; i2++) {
      a2 = points[i2];
      b2 = points[i2 + 1];
      result += `${average(a2[0], b2[0]).toFixed(2)},${average(a2[1], b2[1]).toFixed(2)} `;
    }
    if (closed) {
      result += "Z";
    }
    return result;
  }
  function getPaths(el, attr) {
    const value = el.dataset[attr];
    if (!value) return [];
    try {
      return JSON.parse(value);
    } catch (e2) {
      return [];
    }
  }
  function buildDrawingOptions(el) {
    var _a, _b, _c, _d;
    return {
      fill: getString(el, "drawingFill") || "black",
      size: (_a = getNumber(el, "drawingSize")) != null ? _a : 2,
      simulatePressure: getBoolean(el, "drawingSimulatePressure"),
      smoothing: (_b = getNumber(el, "drawingSmoothing")) != null ? _b : 0.5,
      thinning: (_c = getNumber(el, "drawingThinning")) != null ? _c : 0.7,
      streamline: (_d = getNumber(el, "drawingStreamline")) != null ? _d : 0.65
    };
  }
  var e, t, n, r, a, E, D, O, F, z, anatomy10, parts10, getRootId8, getControlId5, getLabelId6, getHiddenInputId2, getControlEl3, getSegmentEl, getDataUrl2, average, machine10, props10, splitProps10, SignaturePad, SignaturePadHook;
  var init_signature_pad = __esm({
    "../priv/static/signature-pad.mjs"() {
      "use strict";
      init_chunk_GFGFZBBD();
      ({ PI: e } = Math);
      t = e + 1e-4;
      n = 0.5;
      r = [1, 1];
      ({ min: a } = Math);
      E = [0, 0];
      D = [0, 0];
      O = [0, 0];
      F = [0, 0];
      z = R;
      anatomy10 = createAnatomy("signature-pad").parts(
        "root",
        "control",
        "segment",
        "segmentPath",
        "guide",
        "clearTrigger",
        "label"
      );
      parts10 = anatomy10.build();
      getRootId8 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.root) != null ? _b : `signature-${ctx.id}`;
      };
      getControlId5 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.control) != null ? _b : `signature-control-${ctx.id}`;
      };
      getLabelId6 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.label) != null ? _b : `signature-label-${ctx.id}`;
      };
      getHiddenInputId2 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.hiddenInput) != null ? _b : `signature-input-${ctx.id}`;
      };
      getControlEl3 = (ctx) => ctx.getById(getControlId5(ctx));
      getSegmentEl = (ctx) => query(getControlEl3(ctx), "[data-part=segment]");
      getDataUrl2 = (ctx, options) => {
        return getDataUrl(getSegmentEl(ctx), options);
      };
      average = (a2, b2) => (a2 + b2) / 2;
      machine10 = createMachine({
        props({ props: props22 }) {
          return __spreadProps(__spreadValues({
            defaultPaths: []
          }, props22), {
            drawing: __spreadValues({
              size: 2,
              simulatePressure: false,
              thinning: 0.7,
              smoothing: 0.4,
              streamline: 0.6
            }, props22.drawing),
            translations: __spreadValues({
              control: "signature pad",
              clearTrigger: "clear signature"
            }, props22.translations)
          });
        },
        initialState() {
          return "idle";
        },
        context({ prop, bindable: bindable2 }) {
          return {
            paths: bindable2(() => ({
              defaultValue: prop("defaultPaths"),
              value: prop("paths"),
              sync: true,
              onChange(value) {
                var _a;
                (_a = prop("onDraw")) == null ? void 0 : _a({ paths: value });
              }
            })),
            currentPoints: bindable2(() => ({
              defaultValue: []
            })),
            currentPath: bindable2(() => ({
              defaultValue: null
            }))
          };
        },
        computed: {
          isInteractive: ({ prop }) => !(prop("disabled") || prop("readOnly")),
          isEmpty: ({ context }) => context.get("paths").length === 0
        },
        on: {
          CLEAR: {
            actions: ["clearPoints", "invokeOnDrawEnd", "focusCanvasEl"]
          }
        },
        states: {
          idle: {
            on: {
              POINTER_DOWN: {
                target: "drawing",
                actions: ["addPoint"]
              }
            }
          },
          drawing: {
            effects: ["trackPointerMove"],
            on: {
              POINTER_MOVE: {
                actions: ["addPoint", "invokeOnDraw"]
              },
              POINTER_UP: {
                target: "idle",
                actions: ["endStroke", "invokeOnDrawEnd"]
              }
            }
          }
        },
        implementations: {
          effects: {
            trackPointerMove({ scope, send }) {
              const doc = scope.getDoc();
              return trackPointerMove(doc, {
                onPointerMove({ event, point }) {
                  const controlEl = getControlEl3(scope);
                  if (!controlEl) return;
                  const { offset: offset3 } = getRelativePoint(point, controlEl);
                  send({ type: "POINTER_MOVE", point: offset3, pressure: event.pressure });
                },
                onPointerUp() {
                  send({ type: "POINTER_UP" });
                }
              });
            }
          },
          actions: {
            addPoint({ context, event, prop }) {
              const nextPoints = [...context.get("currentPoints"), event.point];
              context.set("currentPoints", nextPoints);
              const stroke = z(nextPoints, prop("drawing"));
              context.set("currentPath", getSvgPathFromStroke(stroke));
            },
            endStroke({ context }) {
              const nextPaths = [...context.get("paths"), context.get("currentPath")];
              context.set("paths", nextPaths);
              context.set("currentPoints", []);
              context.set("currentPath", null);
            },
            clearPoints({ context }) {
              context.set("currentPoints", []);
              context.set("paths", []);
              context.set("currentPath", null);
            },
            focusCanvasEl({ scope }) {
              queueMicrotask(() => {
                var _a;
                (_a = scope.getActiveElement()) == null ? void 0 : _a.focus({ preventScroll: true });
              });
            },
            invokeOnDraw({ context, prop }) {
              var _a;
              (_a = prop("onDraw")) == null ? void 0 : _a({
                paths: [...context.get("paths"), context.get("currentPath")]
              });
            },
            invokeOnDrawEnd({ context, prop, scope, computed }) {
              var _a;
              (_a = prop("onDrawEnd")) == null ? void 0 : _a({
                paths: [...context.get("paths")],
                getDataUrl(type, quality = 0.92) {
                  if (computed("isEmpty")) return Promise.resolve("");
                  return getDataUrl2(scope, { type, quality });
                }
              });
            }
          }
        }
      });
      props10 = createProps()([
        "defaultPaths",
        "dir",
        "disabled",
        "drawing",
        "getRootNode",
        "id",
        "ids",
        "name",
        "onDraw",
        "onDrawEnd",
        "paths",
        "readOnly",
        "required",
        "translations"
      ]);
      splitProps10 = createSplitProps(props10);
      SignaturePad = class extends Component {
        constructor() {
          super(...arguments);
          __publicField(this, "imageURL", "");
          __publicField(this, "paths", []);
          __publicField(this, "name");
          __publicField(this, "syncPaths", () => {
            const segment = this.el.querySelector('[data-scope="signature-pad"][data-part="segment"]');
            if (!segment) return;
            const totalPaths = this.api.paths.length + (this.api.currentPath ? 1 : 0);
            if (totalPaths === 0) {
              segment.innerHTML = "";
              this.imageURL = "";
              this.paths = [];
              const hiddenInput = this.el.querySelector('[data-scope="signature-pad"][data-part="hidden-input"]');
              if (hiddenInput) hiddenInput.value = "";
              return;
            }
            segment.innerHTML = "";
            this.api.paths.forEach((pathData) => {
              const pathEl = document.createElementNS("http://www.w3.org/2000/svg", "path");
              pathEl.setAttribute("data-scope", "signature-pad");
              pathEl.setAttribute("data-part", "path");
              this.spreadProps(pathEl, this.api.getSegmentPathProps({ path: pathData }));
              segment.appendChild(pathEl);
            });
            if (this.api.currentPath) {
              const currentPathEl = document.createElementNS("http://www.w3.org/2000/svg", "path");
              currentPathEl.setAttribute("data-scope", "signature-pad");
              currentPathEl.setAttribute("data-part", "current-path");
              this.spreadProps(currentPathEl, this.api.getSegmentPathProps({ path: this.api.currentPath }));
              segment.appendChild(currentPathEl);
            }
          });
        }
        initMachine(props22) {
          this.name = props22.name;
          return new VanillaMachine(machine10, props22);
        }
        setName(name) {
          this.name = name;
        }
        setPaths(paths) {
          this.paths = paths;
        }
        initApi() {
          return connect10(this.machine.service, normalizeProps);
        }
        render() {
          const rootEl = this.el.querySelector('[data-scope="signature-pad"][data-part="root"]');
          if (!rootEl) return;
          this.spreadProps(rootEl, this.api.getRootProps());
          const label = rootEl.querySelector('[data-scope="signature-pad"][data-part="label"]');
          if (label) this.spreadProps(label, this.api.getLabelProps());
          const control = rootEl.querySelector('[data-scope="signature-pad"][data-part="control"]');
          if (control) this.spreadProps(control, this.api.getControlProps());
          const segment = rootEl.querySelector('[data-scope="signature-pad"][data-part="segment"]');
          if (segment) this.spreadProps(segment, this.api.getSegmentProps());
          const guide = rootEl.querySelector('[data-scope="signature-pad"][data-part="guide"]');
          if (guide) this.spreadProps(guide, this.api.getGuideProps());
          const clearBtn = rootEl.querySelector('[data-scope="signature-pad"][data-part="clear-trigger"]');
          if (clearBtn) {
            this.spreadProps(clearBtn, this.api.getClearTriggerProps());
            const hasPaths = this.api.paths.length > 0 || !!this.api.currentPath;
            clearBtn.hidden = !hasPaths;
          }
          const hiddenInput = rootEl.querySelector('[data-scope="signature-pad"][data-part="hidden-input"]');
          if (hiddenInput) {
            const pathsForValue = this.paths.length > 0 ? this.paths : this.api.paths;
            if (this.paths.length === 0 && this.api.paths.length > 0) {
              this.paths = [...this.api.paths];
            }
            const pathsValue = pathsForValue.length > 0 ? JSON.stringify(pathsForValue) : "";
            this.spreadProps(hiddenInput, this.api.getHiddenInputProps({ value: pathsValue }));
            if (this.name) {
              hiddenInput.name = this.name;
            }
            hiddenInput.value = pathsValue;
          }
          this.syncPaths();
        }
      };
      SignaturePadHook = {
        mounted() {
          const el = this.el;
          const pushEvent = this.pushEvent.bind(this);
          const controlled = getBoolean(el, "controlled");
          const paths = getPaths(el, "paths");
          const defaultPaths = getPaths(el, "defaultPaths");
          const signaturePad = new SignaturePad(el, __spreadProps(__spreadValues(__spreadValues({
            id: el.id,
            name: getString(el, "name")
          }, controlled && paths.length > 0 ? { paths } : void 0), !controlled && defaultPaths.length > 0 ? { defaultPaths } : void 0), {
            drawing: buildDrawingOptions(el),
            onDrawEnd: (details) => {
              signaturePad.setPaths(details.paths);
              const hiddenInput = el.querySelector('[data-scope="signature-pad"][data-part="hidden-input"]');
              if (hiddenInput) {
                hiddenInput.value = JSON.stringify(details.paths);
              }
              details.getDataUrl("image/png").then((url) => {
                signaturePad.imageURL = url;
                const eventName = getString(el, "onDrawEnd");
                if (eventName && this.liveSocket.main.isConnected()) {
                  pushEvent(eventName, {
                    id: el.id,
                    paths: details.paths,
                    url
                  });
                }
                const eventNameClient = getString(el, "onDrawEndClient");
                if (eventNameClient) {
                  el.dispatchEvent(
                    new CustomEvent(eventNameClient, {
                      bubbles: true,
                      detail: {
                        id: el.id,
                        paths: details.paths,
                        url
                      }
                    })
                  );
                }
              });
            }
          }));
          signaturePad.init();
          this.signaturePad = signaturePad;
          const initialPaths = controlled ? paths : defaultPaths;
          if (initialPaths.length > 0) {
            const hiddenInput = el.querySelector('[data-scope="signature-pad"][data-part="hidden-input"]');
            if (hiddenInput) {
              hiddenInput.dispatchEvent(new Event("input", { bubbles: true }));
              hiddenInput.dispatchEvent(new Event("change", { bubbles: true }));
            }
          }
          this.onClear = (event) => {
            const { id: targetId } = event.detail;
            if (targetId && targetId !== el.id) return;
            signaturePad.api.clear();
            signaturePad.imageURL = "";
            signaturePad.setPaths([]);
            const hiddenInput = el.querySelector('[data-scope="signature-pad"][data-part="hidden-input"]');
            if (hiddenInput) {
              hiddenInput.value = "";
            }
          };
          el.addEventListener("phx:signature-pad:clear", this.onClear);
          this.handlers = [];
          this.handlers.push(
            this.handleEvent("signature_pad_clear", (payload) => {
              const targetId = payload.signature_pad_id;
              if (targetId && targetId !== el.id) return;
              signaturePad.api.clear();
              signaturePad.imageURL = "";
              signaturePad.setPaths([]);
              const hiddenInput = el.querySelector('[data-scope="signature-pad"][data-part="hidden-input"]');
              if (hiddenInput) {
                hiddenInput.value = "";
              }
            })
          );
        },
        updated() {
          var _a, _b;
          const controlled = getBoolean(this.el, "controlled");
          const paths = getPaths(this.el, "paths");
          const defaultPaths = getPaths(this.el, "defaultPaths");
          const name = getString(this.el, "name");
          if (name) {
            (_a = this.signaturePad) == null ? void 0 : _a.setName(name);
          }
          (_b = this.signaturePad) == null ? void 0 : _b.updateProps(__spreadProps(__spreadValues(__spreadValues({
            id: this.el.id,
            name
          }, controlled && paths.length > 0 ? { paths } : {}), !controlled && defaultPaths.length > 0 ? { defaultPaths } : {}), {
            drawing: buildDrawingOptions(this.el)
          }));
        },
        destroyed() {
          var _a;
          if (this.onClear) {
            this.el.removeEventListener("phx:signature-pad:clear", this.onClear);
          }
          if (this.handlers) {
            for (const handler of this.handlers) {
              this.removeHandleEvent(handler);
            }
          }
          (_a = this.signaturePad) == null ? void 0 : _a.destroy();
        }
      };
    }
  });

  // ../priv/static/switch.mjs
  var switch_exports = {};
  __export(switch_exports, {
    Switch: () => SwitchHook
  });
  function connect11(service, normalize) {
    const { context, send, prop, scope } = service;
    const disabled = !!prop("disabled");
    const readOnly = !!prop("readOnly");
    const required = !!prop("required");
    const checked = !!context.get("checked");
    const focused = !disabled && context.get("focused");
    const focusVisible = !disabled && context.get("focusVisible");
    const active = !disabled && context.get("active");
    const dataAttrs = {
      "data-active": dataAttr(active),
      "data-focus": dataAttr(focused),
      "data-focus-visible": dataAttr(focusVisible),
      "data-readonly": dataAttr(readOnly),
      "data-hover": dataAttr(context.get("hovered")),
      "data-disabled": dataAttr(disabled),
      "data-state": checked ? "checked" : "unchecked",
      "data-invalid": dataAttr(prop("invalid")),
      "data-required": dataAttr(required)
    };
    return {
      checked,
      disabled,
      focused,
      setChecked(checked2) {
        send({ type: "CHECKED.SET", checked: checked2, isTrusted: false });
      },
      toggleChecked() {
        send({ type: "CHECKED.TOGGLE", checked, isTrusted: false });
      },
      getRootProps() {
        return normalize.label(__spreadProps(__spreadValues(__spreadValues({}, parts11.root.attrs), dataAttrs), {
          dir: prop("dir"),
          id: getRootId9(scope),
          htmlFor: getHiddenInputId3(scope),
          onPointerMove() {
            if (disabled) return;
            send({ type: "CONTEXT.SET", context: { hovered: true } });
          },
          onPointerLeave() {
            if (disabled) return;
            send({ type: "CONTEXT.SET", context: { hovered: false } });
          },
          onClick(event) {
            var _a;
            if (disabled) return;
            const target = getEventTarget(event);
            if (target === getHiddenInputEl2(scope)) {
              event.stopPropagation();
            }
            if (isSafari()) {
              (_a = getHiddenInputEl2(scope)) == null ? void 0 : _a.focus();
            }
          }
        }));
      },
      getLabelProps() {
        return normalize.element(__spreadProps(__spreadValues(__spreadValues({}, parts11.label.attrs), dataAttrs), {
          dir: prop("dir"),
          id: getLabelId7(scope)
        }));
      },
      getThumbProps() {
        return normalize.element(__spreadProps(__spreadValues(__spreadValues({}, parts11.thumb.attrs), dataAttrs), {
          dir: prop("dir"),
          id: getThumbId(scope),
          "aria-hidden": true
        }));
      },
      getControlProps() {
        return normalize.element(__spreadProps(__spreadValues(__spreadValues({}, parts11.control.attrs), dataAttrs), {
          dir: prop("dir"),
          id: getControlId6(scope),
          "aria-hidden": true
        }));
      },
      getHiddenInputProps() {
        return normalize.input({
          id: getHiddenInputId3(scope),
          type: "checkbox",
          required: prop("required"),
          defaultChecked: checked,
          disabled,
          "aria-labelledby": getLabelId7(scope),
          "aria-invalid": prop("invalid"),
          name: prop("name"),
          form: prop("form"),
          value: prop("value"),
          style: visuallyHiddenStyle,
          onFocus() {
            const focusVisible2 = isFocusVisible();
            send({ type: "CONTEXT.SET", context: { focused: true, focusVisible: focusVisible2 } });
          },
          onBlur() {
            send({ type: "CONTEXT.SET", context: { focused: false, focusVisible: false } });
          },
          onClick(event) {
            if (readOnly) {
              event.preventDefault();
              return;
            }
            const checked2 = event.currentTarget.checked;
            send({ type: "CHECKED.SET", checked: checked2, isTrusted: true });
          }
        });
      }
    };
  }
  var anatomy11, parts11, getRootId9, getLabelId7, getThumbId, getControlId6, getHiddenInputId3, getRootEl3, getHiddenInputEl2, not6, machine11, props11, splitProps11, Switch, SwitchHook;
  var init_switch = __esm({
    "../priv/static/switch.mjs"() {
      "use strict";
      init_chunk_EAMC7PNF();
      init_chunk_GFGFZBBD();
      anatomy11 = createAnatomy("switch").parts("root", "label", "control", "thumb");
      parts11 = anatomy11.build();
      getRootId9 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.root) != null ? _b : `switch:${ctx.id}`;
      };
      getLabelId7 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.label) != null ? _b : `switch:${ctx.id}:label`;
      };
      getThumbId = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.thumb) != null ? _b : `switch:${ctx.id}:thumb`;
      };
      getControlId6 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.control) != null ? _b : `switch:${ctx.id}:control`;
      };
      getHiddenInputId3 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.hiddenInput) != null ? _b : `switch:${ctx.id}:input`;
      };
      getRootEl3 = (ctx) => ctx.getById(getRootId9(ctx));
      getHiddenInputEl2 = (ctx) => ctx.getById(getHiddenInputId3(ctx));
      ({ not: not6 } = createGuards());
      machine11 = createMachine({
        props({ props: props22 }) {
          return __spreadValues({
            defaultChecked: false,
            label: "switch",
            value: "on"
          }, props22);
        },
        initialState() {
          return "ready";
        },
        context({ prop, bindable: bindable2 }) {
          return {
            checked: bindable2(() => ({
              defaultValue: prop("defaultChecked"),
              value: prop("checked"),
              onChange(value) {
                var _a;
                (_a = prop("onCheckedChange")) == null ? void 0 : _a({ checked: value });
              }
            })),
            fieldsetDisabled: bindable2(() => ({
              defaultValue: false
            })),
            focusVisible: bindable2(() => ({
              defaultValue: false
            })),
            active: bindable2(() => ({
              defaultValue: false
            })),
            focused: bindable2(() => ({
              defaultValue: false
            })),
            hovered: bindable2(() => ({
              defaultValue: false
            }))
          };
        },
        computed: {
          isDisabled: ({ context, prop }) => prop("disabled") || context.get("fieldsetDisabled")
        },
        watch({ track, prop, context, action }) {
          track([() => prop("disabled")], () => {
            action(["removeFocusIfNeeded"]);
          });
          track([() => context.get("checked")], () => {
            action(["syncInputElement"]);
          });
        },
        effects: ["trackFormControlState", "trackPressEvent", "trackFocusVisible"],
        on: {
          "CHECKED.TOGGLE": [
            {
              guard: not6("isTrusted"),
              actions: ["toggleChecked", "dispatchChangeEvent"]
            },
            {
              actions: ["toggleChecked"]
            }
          ],
          "CHECKED.SET": [
            {
              guard: not6("isTrusted"),
              actions: ["setChecked", "dispatchChangeEvent"]
            },
            {
              actions: ["setChecked"]
            }
          ],
          "CONTEXT.SET": {
            actions: ["setContext"]
          }
        },
        states: {
          ready: {}
        },
        implementations: {
          guards: {
            isTrusted: ({ event }) => !!event.isTrusted
          },
          effects: {
            trackPressEvent({ computed, scope, context }) {
              if (computed("isDisabled")) return;
              return trackPress({
                pointerNode: getRootEl3(scope),
                keyboardNode: getHiddenInputEl2(scope),
                isValidKey: (event) => event.key === " ",
                onPress: () => context.set("active", false),
                onPressStart: () => context.set("active", true),
                onPressEnd: () => context.set("active", false)
              });
            },
            trackFocusVisible({ computed, scope }) {
              if (computed("isDisabled")) return;
              return trackFocusVisible({ root: scope.getRootNode() });
            },
            trackFormControlState({ context, send, scope }) {
              return trackFormControl(getHiddenInputEl2(scope), {
                onFieldsetDisabledChange(disabled) {
                  context.set("fieldsetDisabled", disabled);
                },
                onFormReset() {
                  const checked = context.initial("checked");
                  send({ type: "CHECKED.SET", checked: !!checked, src: "form-reset" });
                }
              });
            }
          },
          actions: {
            setContext({ context, event }) {
              for (const key in event.context) {
                context.set(key, event.context[key]);
              }
            },
            syncInputElement({ context, scope }) {
              const inputEl = getHiddenInputEl2(scope);
              if (!inputEl) return;
              setElementChecked(inputEl, !!context.get("checked"));
            },
            removeFocusIfNeeded({ context, prop }) {
              if (prop("disabled")) {
                context.set("focused", false);
              }
            },
            setChecked({ context, event }) {
              context.set("checked", event.checked);
            },
            toggleChecked({ context }) {
              context.set("checked", !context.get("checked"));
            },
            dispatchChangeEvent({ context, scope }) {
              queueMicrotask(() => {
                const inputEl = getHiddenInputEl2(scope);
                dispatchInputCheckedEvent(inputEl, { checked: context.get("checked") });
              });
            }
          }
        }
      });
      props11 = createProps()([
        "checked",
        "defaultChecked",
        "dir",
        "disabled",
        "form",
        "getRootNode",
        "id",
        "ids",
        "invalid",
        "label",
        "name",
        "onCheckedChange",
        "readOnly",
        "required",
        "value"
      ]);
      splitProps11 = createSplitProps(props11);
      Switch = class extends Component {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        initMachine(props22) {
          return new VanillaMachine(machine11, props22);
        }
        initApi() {
          return connect11(this.machine.service, normalizeProps);
        }
        render() {
          const rootEl = this.el.querySelector('[data-scope="switch"][data-part="root"]');
          if (!rootEl) return;
          this.spreadProps(rootEl, this.api.getRootProps());
          const inputEl = this.el.querySelector('[data-scope="switch"][data-part="hidden-input"]');
          if (inputEl) {
            this.spreadProps(inputEl, this.api.getHiddenInputProps());
          }
          const labelEl = this.el.querySelector('[data-scope="switch"][data-part="label"]');
          if (labelEl) {
            this.spreadProps(labelEl, this.api.getLabelProps());
          }
          const controlEl = this.el.querySelector('[data-scope="switch"][data-part="control"]');
          if (controlEl) {
            this.spreadProps(controlEl, this.api.getControlProps());
          }
          const thumbEl = this.el.querySelector('[data-scope="switch"][data-part="thumb"]');
          if (thumbEl) {
            this.spreadProps(thumbEl, this.api.getThumbProps());
          }
        }
      };
      SwitchHook = {
        mounted() {
          const el = this.el;
          const pushEvent = this.pushEvent.bind(this);
          this.wasFocused = false;
          const zagSwitch = new Switch(el, __spreadProps(__spreadValues({
            id: el.id
          }, getBoolean(el, "controlled") ? { checked: getBoolean(el, "checked") } : { defaultChecked: getBoolean(el, "defaultChecked") }), {
            disabled: getBoolean(el, "disabled"),
            name: getString(el, "name"),
            form: getString(el, "form"),
            value: getString(el, "value"),
            dir: getString(el, "dir", ["ltr", "rtl"]),
            invalid: getBoolean(el, "invalid"),
            required: getBoolean(el, "required"),
            readOnly: getBoolean(el, "readOnly"),
            label: getString(el, "label"),
            onCheckedChange: (details) => {
              const eventName = getString(el, "onCheckedChange");
              if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
                pushEvent(eventName, {
                  checked: details.checked,
                  id: el.id
                });
              }
              const eventNameClient = getString(el, "onCheckedChangeClient");
              if (eventNameClient) {
                el.dispatchEvent(
                  new CustomEvent(eventNameClient, {
                    bubbles: true,
                    detail: {
                      value: details,
                      id: el.id
                    }
                  })
                );
              }
            }
          }));
          zagSwitch.init();
          this.zagSwitch = zagSwitch;
          this.onSetChecked = (event) => {
            const { value } = event.detail;
            zagSwitch.api.setChecked(value);
          };
          el.addEventListener("phx:switch:set-checked", this.onSetChecked);
          this.handlers = [];
          this.handlers.push(
            this.handleEvent("switch_set_checked", (payload) => {
              const targetId = payload.id;
              if (targetId && targetId !== el.id) return;
              zagSwitch.api.setChecked(payload.value);
            })
          );
          this.handlers.push(
            this.handleEvent("switch_toggle_checked", (payload) => {
              const targetId = payload.id;
              if (targetId && targetId !== el.id) return;
              zagSwitch.api.toggleChecked();
            })
          );
          this.handlers.push(
            this.handleEvent("switch_checked", () => {
              this.pushEvent("switch_checked_response", {
                value: zagSwitch.api.checked
              });
            })
          );
          this.handlers.push(
            this.handleEvent("switch_focused", () => {
              this.pushEvent("switch_focused_response", {
                value: zagSwitch.api.focused
              });
            })
          );
          this.handlers.push(
            this.handleEvent("switch_disabled", () => {
              this.pushEvent("switch_disabled_response", {
                value: zagSwitch.api.disabled
              });
            })
          );
        },
        beforeUpdate() {
          var _a, _b;
          this.wasFocused = (_b = (_a = this.zagSwitch) == null ? void 0 : _a.api.focused) != null ? _b : false;
        },
        updated() {
          var _a;
          (_a = this.zagSwitch) == null ? void 0 : _a.updateProps(__spreadProps(__spreadValues({
            id: this.el.id
          }, getBoolean(this.el, "controlled") ? { checked: getBoolean(this.el, "checked") } : { defaultChecked: getBoolean(this.el, "defaultChecked") }), {
            disabled: getBoolean(this.el, "disabled"),
            name: getString(this.el, "name"),
            form: getString(this.el, "form"),
            value: getString(this.el, "value"),
            dir: getString(this.el, "dir", ["ltr", "rtl"]),
            invalid: getBoolean(this.el, "invalid"),
            required: getBoolean(this.el, "required"),
            readOnly: getBoolean(this.el, "readOnly"),
            label: getString(this.el, "label")
          }));
          if (getBoolean(this.el, "controlled")) {
            if (this.wasFocused) {
              const hiddenInput = this.el.querySelector('[data-part="hidden-input"]');
              hiddenInput == null ? void 0 : hiddenInput.focus();
            }
          }
        },
        destroyed() {
          var _a;
          if (this.onSetChecked) {
            this.el.removeEventListener("phx:switch:set-checked", this.onSetChecked);
          }
          if (this.handlers) {
            for (const handler of this.handlers) {
              this.removeHandleEvent(handler);
            }
          }
          (_a = this.zagSwitch) == null ? void 0 : _a.destroy();
        }
      };
    }
  });

  // ../priv/static/tabs.mjs
  var tabs_exports = {};
  __export(tabs_exports, {
    Tabs: () => TabsHook
  });
  function connect12(service, normalize) {
    const { state: state2, send, context, prop, scope } = service;
    const translations = prop("translations");
    const focused = state2.matches("focused");
    const isVertical = prop("orientation") === "vertical";
    const isHorizontal = prop("orientation") === "horizontal";
    const composite = prop("composite");
    function getTriggerState(props22) {
      return {
        selected: context.get("value") === props22.value,
        focused: context.get("focusedValue") === props22.value,
        disabled: !!props22.disabled
      };
    }
    return {
      value: context.get("value"),
      focusedValue: context.get("focusedValue"),
      setValue(value) {
        send({ type: "SET_VALUE", value });
      },
      clearValue() {
        send({ type: "CLEAR_VALUE" });
      },
      setIndicatorRect(value) {
        const id = getTriggerId7(scope, value);
        send({ type: "SET_INDICATOR_RECT", id });
      },
      syncTabIndex() {
        send({ type: "SYNC_TAB_INDEX" });
      },
      selectNext(fromValue) {
        send({ type: "TAB_FOCUS", value: fromValue, src: "selectNext" });
        send({ type: "ARROW_NEXT", src: "selectNext" });
      },
      selectPrev(fromValue) {
        send({ type: "TAB_FOCUS", value: fromValue, src: "selectPrev" });
        send({ type: "ARROW_PREV", src: "selectPrev" });
      },
      focus() {
        var _a;
        const value = context.get("value");
        if (!value) return;
        (_a = getTriggerEl6(scope, value)) == null ? void 0 : _a.focus();
      },
      getRootProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts12.root.attrs), {
          id: getRootId10(scope),
          "data-orientation": prop("orientation"),
          "data-focus": dataAttr(focused),
          dir: prop("dir")
        }));
      },
      getListProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts12.list.attrs), {
          id: getListId(scope),
          role: "tablist",
          dir: prop("dir"),
          "data-focus": dataAttr(focused),
          "aria-orientation": prop("orientation"),
          "data-orientation": prop("orientation"),
          "aria-label": translations == null ? void 0 : translations.listLabel,
          onKeyDown(event) {
            if (event.defaultPrevented) return;
            if (isComposingEvent(event)) return;
            if (!contains(event.currentTarget, getEventTarget(event))) return;
            const keyMap2 = {
              ArrowDown() {
                if (isHorizontal) return;
                send({ type: "ARROW_NEXT", key: "ArrowDown" });
              },
              ArrowUp() {
                if (isHorizontal) return;
                send({ type: "ARROW_PREV", key: "ArrowUp" });
              },
              ArrowLeft() {
                if (isVertical) return;
                send({ type: "ARROW_PREV", key: "ArrowLeft" });
              },
              ArrowRight() {
                if (isVertical) return;
                send({ type: "ARROW_NEXT", key: "ArrowRight" });
              },
              Home() {
                send({ type: "HOME" });
              },
              End() {
                send({ type: "END" });
              }
            };
            let key = getEventKey(event, {
              dir: prop("dir"),
              orientation: prop("orientation")
            });
            const exec = keyMap2[key];
            if (exec) {
              event.preventDefault();
              exec(event);
              return;
            }
          }
        }));
      },
      getTriggerState,
      getTriggerProps(props22) {
        const { value, disabled } = props22;
        const triggerState = getTriggerState(props22);
        return normalize.button(__spreadProps(__spreadValues({}, parts12.trigger.attrs), {
          role: "tab",
          type: "button",
          disabled,
          dir: prop("dir"),
          "data-orientation": prop("orientation"),
          "data-disabled": dataAttr(disabled),
          "aria-disabled": disabled,
          "data-value": value,
          "aria-selected": triggerState.selected,
          "data-selected": dataAttr(triggerState.selected),
          "data-focus": dataAttr(triggerState.focused),
          "aria-controls": triggerState.selected ? getContentId7(scope, value) : void 0,
          "data-ownedby": getListId(scope),
          "data-ssr": dataAttr(context.get("ssr")),
          id: getTriggerId7(scope, value),
          tabIndex: triggerState.selected && composite ? 0 : -1,
          onFocus() {
            send({ type: "TAB_FOCUS", value });
          },
          onBlur(event) {
            const target = event.relatedTarget;
            if ((target == null ? void 0 : target.getAttribute("role")) !== "tab") {
              send({ type: "TAB_BLUR" });
            }
          },
          onClick(event) {
            if (event.defaultPrevented) return;
            if (isOpeningInNewTab(event)) return;
            if (disabled) return;
            if (isSafari()) {
              event.currentTarget.focus();
            }
            send({ type: "TAB_CLICK", value });
          }
        }));
      },
      getContentProps(props22) {
        const { value } = props22;
        const selected = context.get("value") === value;
        return normalize.element(__spreadProps(__spreadValues({}, parts12.content.attrs), {
          dir: prop("dir"),
          id: getContentId7(scope, value),
          tabIndex: composite ? 0 : -1,
          "aria-labelledby": getTriggerId7(scope, value),
          role: "tabpanel",
          "data-ownedby": getListId(scope),
          "data-selected": dataAttr(selected),
          "data-orientation": prop("orientation"),
          hidden: !selected
        }));
      },
      getIndicatorProps() {
        const rect = context.get("indicatorRect");
        const rectIsEmpty = rect == null || rect.width === 0 && rect.height === 0 && rect.x === 0 && rect.y === 0;
        return normalize.element(__spreadProps(__spreadValues({
          id: getIndicatorId(scope)
        }, parts12.indicator.attrs), {
          dir: prop("dir"),
          "data-orientation": prop("orientation"),
          hidden: rectIsEmpty,
          style: {
            "--transition-property": "left, right, top, bottom, width, height",
            "--left": toPx(rect == null ? void 0 : rect.x),
            "--top": toPx(rect == null ? void 0 : rect.y),
            "--width": toPx(rect == null ? void 0 : rect.width),
            "--height": toPx(rect == null ? void 0 : rect.height),
            position: "absolute",
            willChange: "var(--transition-property)",
            transitionProperty: "var(--transition-property)",
            transitionDuration: "var(--transition-duration, 150ms)",
            transitionTimingFunction: "var(--transition-timing-function)",
            [isHorizontal ? "left" : "top"]: isHorizontal ? "var(--left)" : "var(--top)"
          }
        }));
      }
    };
  }
  var anatomy12, parts12, getRootId10, getListId, getContentId7, getTriggerId7, getIndicatorId, getListEl, getContentEl7, getTriggerEl6, getIndicatorEl, getElements2, getFirstTriggerEl2, getLastTriggerEl2, getNextTriggerEl2, getPrevTriggerEl2, getOffsetRect, getRectByValue, createMachine3, machine12, props12, splitProps12, triggerProps, splitTriggerProps, contentProps, splitContentProps, Tabs, TabsHook;
  var init_tabs = __esm({
    "../priv/static/tabs.mjs"() {
      "use strict";
      init_chunk_GFGFZBBD();
      anatomy12 = createAnatomy("tabs").parts("root", "list", "trigger", "content", "indicator");
      parts12 = anatomy12.build();
      getRootId10 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.root) != null ? _b : `tabs:${ctx.id}`;
      };
      getListId = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.list) != null ? _b : `tabs:${ctx.id}:list`;
      };
      getContentId7 = (ctx, value) => {
        var _a, _b, _c;
        return (_c = (_b = (_a = ctx.ids) == null ? void 0 : _a.content) == null ? void 0 : _b.call(_a, value)) != null ? _c : `tabs:${ctx.id}:content-${value}`;
      };
      getTriggerId7 = (ctx, value) => {
        var _a, _b, _c;
        return (_c = (_b = (_a = ctx.ids) == null ? void 0 : _a.trigger) == null ? void 0 : _b.call(_a, value)) != null ? _c : `tabs:${ctx.id}:trigger-${value}`;
      };
      getIndicatorId = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.indicator) != null ? _b : `tabs:${ctx.id}:indicator`;
      };
      getListEl = (ctx) => ctx.getById(getListId(ctx));
      getContentEl7 = (ctx, value) => ctx.getById(getContentId7(ctx, value));
      getTriggerEl6 = (ctx, value) => value != null ? ctx.getById(getTriggerId7(ctx, value)) : null;
      getIndicatorEl = (ctx) => ctx.getById(getIndicatorId(ctx));
      getElements2 = (ctx) => {
        const ownerId = CSS.escape(getListId(ctx));
        const selector = `[role=tab][data-ownedby='${ownerId}']:not([disabled])`;
        return queryAll(getListEl(ctx), selector);
      };
      getFirstTriggerEl2 = (ctx) => first(getElements2(ctx));
      getLastTriggerEl2 = (ctx) => last(getElements2(ctx));
      getNextTriggerEl2 = (ctx, opts) => nextById(getElements2(ctx), getTriggerId7(ctx, opts.value), opts.loopFocus);
      getPrevTriggerEl2 = (ctx, opts) => prevById(getElements2(ctx), getTriggerId7(ctx, opts.value), opts.loopFocus);
      getOffsetRect = (el) => {
        var _a, _b, _c, _d;
        return {
          x: (_a = el == null ? void 0 : el.offsetLeft) != null ? _a : 0,
          y: (_b = el == null ? void 0 : el.offsetTop) != null ? _b : 0,
          width: (_c = el == null ? void 0 : el.offsetWidth) != null ? _c : 0,
          height: (_d = el == null ? void 0 : el.offsetHeight) != null ? _d : 0
        };
      };
      getRectByValue = (ctx, value) => {
        const tab = itemById(getElements2(ctx), getTriggerId7(ctx, value));
        return getOffsetRect(tab);
      };
      ({ createMachine: createMachine3 } = setup());
      machine12 = createMachine3({
        props({ props: props22 }) {
          return __spreadValues({
            dir: "ltr",
            orientation: "horizontal",
            activationMode: "automatic",
            loopFocus: true,
            composite: true,
            navigate(details) {
              clickIfLink(details.node);
            },
            defaultValue: null
          }, props22);
        },
        initialState() {
          return "idle";
        },
        context({ prop, bindable: bindable2 }) {
          return {
            value: bindable2(() => ({
              defaultValue: prop("defaultValue"),
              value: prop("value"),
              onChange(value) {
                var _a;
                (_a = prop("onValueChange")) == null ? void 0 : _a({ value });
              }
            })),
            focusedValue: bindable2(() => ({
              defaultValue: prop("value") || prop("defaultValue"),
              sync: true,
              onChange(value) {
                var _a;
                (_a = prop("onFocusChange")) == null ? void 0 : _a({ focusedValue: value });
              }
            })),
            ssr: bindable2(() => ({ defaultValue: true })),
            indicatorRect: bindable2(() => ({
              defaultValue: null
            }))
          };
        },
        watch({ context, prop, track, action }) {
          track([() => context.get("value")], () => {
            action(["syncIndicatorRect", "syncTabIndex", "navigateIfNeeded"]);
          });
          track([() => prop("dir"), () => prop("orientation")], () => {
            action(["syncIndicatorRect"]);
          });
        },
        on: {
          SET_VALUE: {
            actions: ["setValue"]
          },
          CLEAR_VALUE: {
            actions: ["clearValue"]
          },
          SET_INDICATOR_RECT: {
            actions: ["setIndicatorRect"]
          },
          SYNC_TAB_INDEX: {
            actions: ["syncTabIndex"]
          }
        },
        entry: ["syncIndicatorRect", "syncTabIndex", "syncSsr"],
        exit: ["cleanupObserver"],
        states: {
          idle: {
            on: {
              TAB_FOCUS: {
                target: "focused",
                actions: ["setFocusedValue"]
              },
              TAB_CLICK: {
                target: "focused",
                actions: ["setFocusedValue", "setValue"]
              }
            }
          },
          focused: {
            on: {
              TAB_CLICK: {
                actions: ["setFocusedValue", "setValue"]
              },
              ARROW_PREV: [
                {
                  guard: "selectOnFocus",
                  actions: ["focusPrevTab", "selectFocusedTab"]
                },
                {
                  actions: ["focusPrevTab"]
                }
              ],
              ARROW_NEXT: [
                {
                  guard: "selectOnFocus",
                  actions: ["focusNextTab", "selectFocusedTab"]
                },
                {
                  actions: ["focusNextTab"]
                }
              ],
              HOME: [
                {
                  guard: "selectOnFocus",
                  actions: ["focusFirstTab", "selectFocusedTab"]
                },
                {
                  actions: ["focusFirstTab"]
                }
              ],
              END: [
                {
                  guard: "selectOnFocus",
                  actions: ["focusLastTab", "selectFocusedTab"]
                },
                {
                  actions: ["focusLastTab"]
                }
              ],
              TAB_FOCUS: {
                actions: ["setFocusedValue"]
              },
              TAB_BLUR: {
                target: "idle",
                actions: ["clearFocusedValue"]
              }
            }
          }
        },
        implementations: {
          guards: {
            selectOnFocus: ({ prop }) => prop("activationMode") === "automatic"
          },
          actions: {
            selectFocusedTab({ context, prop }) {
              raf(() => {
                const focusedValue = context.get("focusedValue");
                if (!focusedValue) return;
                const nullable = prop("deselectable") && context.get("value") === focusedValue;
                const value = nullable ? null : focusedValue;
                context.set("value", value);
              });
            },
            setFocusedValue({ context, event, flush }) {
              if (event.value == null) return;
              flush(() => {
                context.set("focusedValue", event.value);
              });
            },
            clearFocusedValue({ context }) {
              context.set("focusedValue", null);
            },
            setValue({ context, event, prop }) {
              const nullable = prop("deselectable") && context.get("value") === context.get("focusedValue");
              context.set("value", nullable ? null : event.value);
            },
            clearValue({ context }) {
              context.set("value", null);
            },
            focusFirstTab({ scope }) {
              raf(() => {
                var _a;
                (_a = getFirstTriggerEl2(scope)) == null ? void 0 : _a.focus();
              });
            },
            focusLastTab({ scope }) {
              raf(() => {
                var _a;
                (_a = getLastTriggerEl2(scope)) == null ? void 0 : _a.focus();
              });
            },
            focusNextTab({ context, prop, scope, event }) {
              var _a;
              const focusedValue = (_a = event.value) != null ? _a : context.get("focusedValue");
              if (!focusedValue) return;
              const triggerEl = getNextTriggerEl2(scope, {
                value: focusedValue,
                loopFocus: prop("loopFocus")
              });
              raf(() => {
                if (prop("composite")) {
                  triggerEl == null ? void 0 : triggerEl.focus();
                } else if ((triggerEl == null ? void 0 : triggerEl.dataset.value) != null) {
                  context.set("focusedValue", triggerEl.dataset.value);
                }
              });
            },
            focusPrevTab({ context, prop, scope, event }) {
              var _a;
              const focusedValue = (_a = event.value) != null ? _a : context.get("focusedValue");
              if (!focusedValue) return;
              const triggerEl = getPrevTriggerEl2(scope, {
                value: focusedValue,
                loopFocus: prop("loopFocus")
              });
              raf(() => {
                if (prop("composite")) {
                  triggerEl == null ? void 0 : triggerEl.focus();
                } else if ((triggerEl == null ? void 0 : triggerEl.dataset.value) != null) {
                  context.set("focusedValue", triggerEl.dataset.value);
                }
              });
            },
            syncTabIndex({ context, scope }) {
              raf(() => {
                const value = context.get("value");
                if (!value) return;
                const contentEl = getContentEl7(scope, value);
                if (!contentEl) return;
                const focusables = getFocusables(contentEl);
                if (focusables.length > 0) {
                  contentEl.removeAttribute("tabindex");
                } else {
                  contentEl.setAttribute("tabindex", "0");
                }
              });
            },
            cleanupObserver({ refs }) {
              const cleanup = refs.get("indicatorCleanup");
              if (cleanup) cleanup();
            },
            setIndicatorRect({ context, event, scope }) {
              var _a;
              const value = (_a = event.id) != null ? _a : context.get("value");
              const indicatorEl = getIndicatorEl(scope);
              if (!indicatorEl) return;
              if (!value) return;
              const triggerEl = getTriggerEl6(scope, value);
              if (!triggerEl) return;
              context.set("indicatorRect", getRectByValue(scope, value));
            },
            syncSsr({ context }) {
              context.set("ssr", false);
            },
            syncIndicatorRect({ context, refs, scope }) {
              const cleanup = refs.get("indicatorCleanup");
              if (cleanup) cleanup();
              const indicatorEl = getIndicatorEl(scope);
              if (!indicatorEl) return;
              const exec = () => {
                const triggerEl = getTriggerEl6(scope, context.get("value"));
                if (!triggerEl) return;
                const rect = getOffsetRect(triggerEl);
                context.set("indicatorRect", (prev2) => isEqual2(prev2, rect) ? prev2 : rect);
              };
              exec();
              const triggerEls = getElements2(scope);
              const indicatorCleanup = callAll(...triggerEls.map((el) => resizeObserverBorderBox.observe(el, exec)));
              refs.set("indicatorCleanup", indicatorCleanup);
            },
            navigateIfNeeded({ context, prop, scope }) {
              var _a;
              const value = context.get("value");
              if (!value) return;
              const triggerEl = getTriggerEl6(scope, value);
              if (isAnchorElement(triggerEl)) {
                (_a = prop("navigate")) == null ? void 0 : _a({ value, node: triggerEl, href: triggerEl.href });
              }
            }
          }
        }
      });
      props12 = createProps()([
        "activationMode",
        "composite",
        "deselectable",
        "dir",
        "getRootNode",
        "id",
        "ids",
        "loopFocus",
        "navigate",
        "onFocusChange",
        "onValueChange",
        "orientation",
        "translations",
        "value",
        "defaultValue"
      ]);
      splitProps12 = createSplitProps(props12);
      triggerProps = createProps()(["disabled", "value"]);
      splitTriggerProps = createSplitProps(triggerProps);
      contentProps = createProps()(["value"]);
      splitContentProps = createSplitProps(contentProps);
      Tabs = class extends Component {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        initMachine(props22) {
          return new VanillaMachine(machine12, props22);
        }
        initApi() {
          return connect12(this.machine.service, normalizeProps);
        }
        render() {
          const rootEl = this.el.querySelector('[data-scope="tabs"][data-part="root"]');
          if (!rootEl) return;
          this.spreadProps(rootEl, this.api.getRootProps());
          const listEl = rootEl.querySelector('[data-scope="tabs"][data-part="list"]');
          if (!listEl) return;
          this.spreadProps(listEl, this.api.getListProps());
          const itemsData = this.el.getAttribute("data-items");
          const items = itemsData ? JSON.parse(itemsData) : [];
          const triggers = listEl.querySelectorAll(
            '[data-scope="tabs"][data-part="trigger"]'
          );
          for (let i2 = 0; i2 < triggers.length && i2 < items.length; i2++) {
            const triggerEl = triggers[i2];
            const item = items[i2];
            this.spreadProps(triggerEl, this.api.getTriggerProps({ value: item.value, disabled: item.disabled }));
          }
          const contents = rootEl.querySelectorAll(
            '[data-scope="tabs"][data-part="content"]'
          );
          for (let i2 = 0; i2 < contents.length && i2 < items.length; i2++) {
            const contentEl = contents[i2];
            const item = items[i2];
            this.spreadProps(contentEl, this.api.getContentProps({ value: item.value }));
          }
        }
      };
      TabsHook = {
        mounted() {
          const el = this.el;
          const pushEvent = this.pushEvent.bind(this);
          const tabs = new Tabs(
            el,
            __spreadProps(__spreadValues({
              id: el.id
            }, getBoolean(el, "controlled") ? { value: getString(el, "value") } : { defaultValue: getString(el, "defaultValue") }), {
              orientation: getString(el, "orientation", ["horizontal", "vertical"]),
              dir: getString(el, "dir", ["ltr", "rtl"]),
              onValueChange: (details) => {
                var _a, _b;
                const eventName = getString(el, "onValueChange");
                if (eventName && this.liveSocket.main.isConnected()) {
                  pushEvent(eventName, {
                    id: el.id,
                    value: (_a = details.value) != null ? _a : null
                  });
                }
                const eventNameClient = getString(el, "onValueChangeClient");
                if (eventNameClient) {
                  el.dispatchEvent(
                    new CustomEvent(eventNameClient, {
                      bubbles: true,
                      detail: {
                        id: el.id,
                        value: (_b = details.value) != null ? _b : null
                      }
                    })
                  );
                }
              },
              onFocusChange: (details) => {
                var _a, _b;
                const eventName = getString(el, "onFocusChange");
                if (eventName && this.liveSocket.main.isConnected()) {
                  pushEvent(eventName, {
                    id: el.id,
                    value: (_a = details.focusedValue) != null ? _a : null
                  });
                }
                const eventNameClient = getString(el, "onFocusChangeClient");
                if (eventNameClient) {
                  el.dispatchEvent(
                    new CustomEvent(eventNameClient, {
                      bubbles: true,
                      detail: {
                        id: el.id,
                        value: (_b = details.focusedValue) != null ? _b : null
                      }
                    })
                  );
                }
              }
            })
          );
          tabs.init();
          this.tabs = tabs;
          this.onSetValue = (event) => {
            const { value } = event.detail;
            tabs.api.setValue(value);
          };
          el.addEventListener("phx:tabs:set-value", this.onSetValue);
          this.handlers = [];
          this.handlers.push(
            this.handleEvent(
              "tabs_set_value",
              (payload) => {
                const targetId = payload.tabs_id;
                if (targetId && targetId !== el.id) return;
                tabs.api.setValue(payload.value);
              }
            )
          );
          this.handlers.push(
            this.handleEvent("tabs_value", () => {
              this.pushEvent("tabs_value_response", {
                value: tabs.api.value
              });
            })
          );
          this.handlers.push(
            this.handleEvent("tabs_focused_value", () => {
              this.pushEvent("tabs_focused_value_response", {
                value: tabs.api.focusedValue
              });
            })
          );
        },
        updated() {
          var _a;
          (_a = this.tabs) == null ? void 0 : _a.updateProps(__spreadProps(__spreadValues({
            id: this.el.id
          }, getBoolean(this.el, "controlled") ? { value: getString(this.el, "value") } : { defaultValue: getString(this.el, "defaultValue") }), {
            orientation: getString(this.el, "orientation", ["horizontal", "vertical"]),
            dir: getString(this.el, "dir", ["ltr", "rtl"])
          }));
        },
        destroyed() {
          var _a;
          if (this.onSetValue) {
            this.el.removeEventListener("phx:tabs:set-value", this.onSetValue);
          }
          if (this.handlers) {
            for (const handler of this.handlers) {
              this.removeHandleEvent(handler);
            }
          }
          (_a = this.tabs) == null ? void 0 : _a.destroy();
        }
      };
    }
  });

  // ../priv/static/toast.mjs
  var toast_exports = {};
  __export(toast_exports, {
    Toast: () => ToastHook
  });
  function getToastDuration(duration, type) {
    var _a;
    return (_a = duration != null ? duration : defaultTimeouts[type]) != null ? _a : defaultTimeouts.DEFAULT;
  }
  function getGroupPlacementStyle(service, placement) {
    var _a;
    const { prop, computed, context } = service;
    const { offsets, gap } = prop("store").attrs;
    const heights = context.get("heights");
    const computedOffset = getOffsets(offsets);
    const rtl = prop("dir") === "rtl";
    const computedPlacement = placement.replace("-start", rtl ? "-right" : "-left").replace("-end", rtl ? "-left" : "-right");
    const isRighty = computedPlacement.includes("right");
    const isLefty = computedPlacement.includes("left");
    const styles = {
      position: "fixed",
      pointerEvents: computed("count") > 0 ? void 0 : "none",
      display: "flex",
      flexDirection: "column",
      "--gap": `${gap}px`,
      "--first-height": `${((_a = heights[0]) == null ? void 0 : _a.height) || 0}px`,
      "--viewport-offset-left": computedOffset.left,
      "--viewport-offset-right": computedOffset.right,
      "--viewport-offset-top": computedOffset.top,
      "--viewport-offset-bottom": computedOffset.bottom,
      zIndex: MAX_Z_INDEX
    };
    let alignItems = "center";
    if (isRighty) alignItems = "flex-end";
    if (isLefty) alignItems = "flex-start";
    styles.alignItems = alignItems;
    if (computedPlacement.includes("top")) {
      const offset3 = computedOffset.top;
      styles.top = `max(env(safe-area-inset-top, 0px), ${offset3})`;
    }
    if (computedPlacement.includes("bottom")) {
      const offset3 = computedOffset.bottom;
      styles.bottom = `max(env(safe-area-inset-bottom, 0px), ${offset3})`;
    }
    if (!computedPlacement.includes("left")) {
      const offset3 = computedOffset.right;
      styles.insetInlineEnd = `calc(env(safe-area-inset-right, 0px) + ${offset3})`;
    }
    if (!computedPlacement.includes("right")) {
      const offset3 = computedOffset.left;
      styles.insetInlineStart = `calc(env(safe-area-inset-left, 0px) + ${offset3})`;
    }
    return styles;
  }
  function getPlacementStyle(service, visible) {
    const { prop, context, computed } = service;
    const parent = prop("parent");
    const placement = parent.computed("placement");
    const { gap } = parent.prop("store").attrs;
    const [side] = placement.split("-");
    const mounted = context.get("mounted");
    const remainingTime = context.get("remainingTime");
    const height = computed("height");
    const frontmost = computed("frontmost");
    const sibling = !frontmost;
    const overlap = !prop("stacked");
    const stacked = prop("stacked");
    const type = prop("type");
    const duration = type === "loading" ? Number.MAX_SAFE_INTEGER : remainingTime;
    const offset3 = computed("heightIndex") * gap + computed("heightBefore");
    const styles = {
      position: "absolute",
      pointerEvents: "auto",
      "--opacity": "0",
      "--remove-delay": `${prop("removeDelay")}ms`,
      "--duration": `${duration}ms`,
      "--initial-height": `${height}px`,
      "--offset": `${offset3}px`,
      "--index": prop("index"),
      "--z-index": computed("zIndex"),
      "--lift-amount": "calc(var(--lift) * var(--gap))",
      "--y": "100%",
      "--x": "0"
    };
    const assign = (overrides) => Object.assign(styles, overrides);
    if (side === "top") {
      assign({
        top: "0",
        "--sign": "-1",
        "--y": "-100%",
        "--lift": "1"
      });
    } else if (side === "bottom") {
      assign({
        bottom: "0",
        "--sign": "1",
        "--y": "100%",
        "--lift": "-1"
      });
    }
    if (mounted) {
      assign({
        "--y": "0",
        "--opacity": "1"
      });
      if (stacked) {
        assign({
          "--y": "calc(var(--lift) * var(--offset))",
          "--height": "var(--initial-height)"
        });
      }
    }
    if (!visible) {
      assign({
        "--opacity": "0",
        pointerEvents: "none"
      });
    }
    if (sibling && overlap) {
      assign({
        "--base-scale": "var(--index) * 0.05 + 1",
        "--y": "calc(var(--lift-amount) * var(--index))",
        "--scale": "calc(-1 * var(--base-scale))",
        "--height": "var(--first-height)"
      });
      if (!visible) {
        assign({
          "--y": "calc(var(--sign) * 40%)"
        });
      }
    }
    if (sibling && stacked && !visible) {
      assign({
        "--y": "calc(var(--lift) * var(--offset) + var(--lift) * -100%)"
      });
    }
    if (frontmost && !visible) {
      assign({
        "--y": "calc(var(--lift) * -100%)"
      });
    }
    return styles;
  }
  function getGhostBeforeStyle(service, visible) {
    const { computed } = service;
    const styles = {
      position: "absolute",
      inset: "0",
      scale: "1 2",
      pointerEvents: visible ? "none" : "auto"
    };
    const assign = (overrides) => Object.assign(styles, overrides);
    if (computed("frontmost") && !visible) {
      assign({
        height: "calc(var(--initial-height) + 80%)"
      });
    }
    return styles;
  }
  function getGhostAfterStyle() {
    return {
      position: "absolute",
      left: "0",
      height: "calc(var(--gap) + 2px)",
      bottom: "100%",
      width: "100%"
    };
  }
  function groupConnect(service, normalize) {
    const { context, prop, send, refs, computed } = service;
    return {
      getCount() {
        return context.get("toasts").length;
      },
      getToasts() {
        return context.get("toasts");
      },
      getGroupProps(options = {}) {
        const { label = "Notifications" } = options;
        const { hotkey } = prop("store").attrs;
        const hotkeyLabel = hotkey.join("+").replace(/Key/g, "").replace(/Digit/g, "");
        const placement = computed("placement");
        const [side, align = "center"] = placement.split("-");
        return normalize.element(__spreadProps(__spreadValues({}, parts13.group.attrs), {
          dir: prop("dir"),
          tabIndex: -1,
          "aria-label": `${placement} ${label} ${hotkeyLabel}`,
          id: getRegionId(placement),
          "data-placement": placement,
          "data-side": side,
          "data-align": align,
          "aria-live": "polite",
          role: "region",
          style: getGroupPlacementStyle(service, placement),
          onMouseEnter() {
            if (refs.get("ignoreMouseTimer").isActive()) return;
            send({ type: "REGION.POINTER_ENTER", placement });
          },
          onMouseMove() {
            if (refs.get("ignoreMouseTimer").isActive()) return;
            send({ type: "REGION.POINTER_ENTER", placement });
          },
          onMouseLeave() {
            if (refs.get("ignoreMouseTimer").isActive()) return;
            send({ type: "REGION.POINTER_LEAVE", placement });
          },
          onFocus(event) {
            send({ type: "REGION.FOCUS", target: event.relatedTarget });
          },
          onBlur(event) {
            if (refs.get("isFocusWithin") && !contains(event.currentTarget, event.relatedTarget)) {
              queueMicrotask(() => send({ type: "REGION.BLUR" }));
            }
          }
        }));
      },
      subscribe(fn) {
        const store = prop("store");
        return store.subscribe(() => fn(context.get("toasts")));
      }
    };
  }
  function connect13(service, normalize) {
    const { state: state2, send, prop, scope, context, computed } = service;
    const visible = state2.hasTag("visible");
    const paused = state2.hasTag("paused");
    const mounted = context.get("mounted");
    const frontmost = computed("frontmost");
    const placement = prop("parent").computed("placement");
    const type = prop("type");
    const stacked = prop("stacked");
    const title = prop("title");
    const description = prop("description");
    const action = prop("action");
    const [side, align = "center"] = placement.split("-");
    return {
      type,
      title,
      description,
      placement,
      visible,
      paused,
      closable: !!prop("closable"),
      pause() {
        send({ type: "PAUSE" });
      },
      resume() {
        send({ type: "RESUME" });
      },
      dismiss() {
        send({ type: "DISMISS", src: "programmatic" });
      },
      getRootProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts13.root.attrs), {
          dir: prop("dir"),
          id: getRootId11(scope),
          "data-state": visible ? "open" : "closed",
          "data-type": type,
          "data-placement": placement,
          "data-align": align,
          "data-side": side,
          "data-mounted": dataAttr(mounted),
          "data-paused": dataAttr(paused),
          "data-first": dataAttr(frontmost),
          "data-sibling": dataAttr(!frontmost),
          "data-stack": dataAttr(stacked),
          "data-overlap": dataAttr(!stacked),
          role: "status",
          "aria-atomic": "true",
          "aria-describedby": description ? getDescriptionId2(scope) : void 0,
          "aria-labelledby": title ? getTitleId2(scope) : void 0,
          tabIndex: 0,
          style: getPlacementStyle(service, visible),
          onKeyDown(event) {
            if (event.defaultPrevented) return;
            if (event.key == "Escape") {
              send({ type: "DISMISS", src: "keyboard" });
              event.preventDefault();
            }
          }
        }));
      },
      /* Leave a ghost div to avoid setting hover to false when transitioning out */
      getGhostBeforeProps() {
        return normalize.element({
          "data-ghost": "before",
          style: getGhostBeforeStyle(service, visible)
        });
      },
      /* Needed to avoid setting hover to false when in between toasts */
      getGhostAfterProps() {
        return normalize.element({
          "data-ghost": "after",
          style: getGhostAfterStyle()
        });
      },
      getTitleProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts13.title.attrs), {
          id: getTitleId2(scope)
        }));
      },
      getDescriptionProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts13.description.attrs), {
          id: getDescriptionId2(scope)
        }));
      },
      getActionTriggerProps() {
        return normalize.button(__spreadProps(__spreadValues({}, parts13.actionTrigger.attrs), {
          type: "button",
          onClick(event) {
            var _a;
            if (event.defaultPrevented) return;
            (_a = action == null ? void 0 : action.onClick) == null ? void 0 : _a.call(action);
            send({ type: "DISMISS", src: "user" });
          }
        }));
      },
      getCloseTriggerProps() {
        return normalize.button(__spreadProps(__spreadValues({
          id: getCloseTriggerId2(scope)
        }, parts13.closeTrigger.attrs), {
          type: "button",
          "aria-label": "Dismiss notification",
          onClick(event) {
            if (event.defaultPrevented) return;
            send({ type: "DISMISS", src: "user" });
          }
        }));
      }
    };
  }
  function setHeight(parent, item) {
    const { id, height } = item;
    parent.context.set("heights", (prev2) => {
      const alreadyExists = prev2.find((i2) => i2.id === id);
      if (!alreadyExists) {
        return [{ id, height }, ...prev2];
      } else {
        return prev2.map((i2) => i2.id === id ? __spreadProps(__spreadValues({}, i2), { height }) : i2);
      }
    });
  }
  function createToastStore(props15 = {}) {
    const attrs = withDefaults(props15, {
      placement: "bottom",
      overlap: false,
      max: 24,
      gap: 16,
      offsets: "1rem",
      hotkey: ["altKey", "KeyT"],
      removeDelay: 200,
      pauseOnPageIdle: true
    });
    let subscribers = [];
    let toasts = [];
    let dismissedToasts = /* @__PURE__ */ new Set();
    let toastQueue = [];
    const subscribe2 = (subscriber) => {
      subscribers.push(subscriber);
      return () => {
        const index = subscribers.indexOf(subscriber);
        subscribers.splice(index, 1);
      };
    };
    const publish = (data) => {
      subscribers.forEach((subscriber) => subscriber(data));
      return data;
    };
    const addToast = (data) => {
      if (toasts.length >= attrs.max) {
        toastQueue.push(data);
        return;
      }
      publish(data);
      toasts.unshift(data);
    };
    const processQueue = () => {
      while (toastQueue.length > 0 && toasts.length < attrs.max) {
        const nextToast = toastQueue.shift();
        if (nextToast) {
          publish(nextToast);
          toasts.unshift(nextToast);
        }
      }
    };
    const create = (data) => {
      var _a;
      const id = (_a = data.id) != null ? _a : `toast:${uuid()}`;
      const exists = toasts.find((toast) => toast.id === id);
      if (dismissedToasts.has(id)) dismissedToasts.delete(id);
      if (exists) {
        toasts = toasts.map((toast) => {
          if (toast.id === id) {
            return publish(__spreadProps(__spreadValues(__spreadValues({}, toast), data), { id }));
          }
          return toast;
        });
      } else {
        addToast(__spreadProps(__spreadValues({
          id,
          duration: attrs.duration,
          removeDelay: attrs.removeDelay,
          type: "info"
        }, data), {
          stacked: !attrs.overlap,
          gap: attrs.gap
        }));
      }
      return id;
    };
    const remove3 = (id) => {
      dismissedToasts.add(id);
      if (!id) {
        toasts.forEach((toast) => {
          subscribers.forEach((subscriber) => subscriber({ id: toast.id, dismiss: true }));
        });
        toasts = [];
        toastQueue = [];
      } else {
        subscribers.forEach((subscriber) => subscriber({ id, dismiss: true }));
        toasts = toasts.filter((toast) => toast.id !== id);
        processQueue();
      }
      return id;
    };
    const error = (data) => {
      return create(__spreadProps(__spreadValues({}, data), { type: "error" }));
    };
    const success = (data) => {
      return create(__spreadProps(__spreadValues({}, data), { type: "success" }));
    };
    const info = (data) => {
      return create(__spreadProps(__spreadValues({}, data), { type: "info" }));
    };
    const warning = (data) => {
      return create(__spreadProps(__spreadValues({}, data), { type: "warning" }));
    };
    const loading = (data) => {
      return create(__spreadProps(__spreadValues({}, data), { type: "loading" }));
    };
    const getVisibleToasts = () => {
      return toasts.filter((toast) => !dismissedToasts.has(toast.id));
    };
    const getCount = () => {
      return toasts.length;
    };
    const promise = (promise2, options, shared = {}) => {
      if (!options || !options.loading) {
        warn("[zag-js > toast] toaster.promise() requires at least a 'loading' option to be specified");
        return;
      }
      const id = create(__spreadProps(__spreadValues(__spreadValues({}, shared), options.loading), {
        promise: promise2,
        type: "loading"
      }));
      let removable = true;
      let result;
      const prom = runIfFn(promise2).then((response) => __async(null, null, function* () {
        result = ["resolve", response];
        if (isHttpResponse(response) && !response.ok) {
          removable = false;
          const errorOptions = runIfFn(options.error, `HTTP Error! status: ${response.status}`);
          create(__spreadProps(__spreadValues(__spreadValues({}, shared), errorOptions), { id, type: "error" }));
        } else if (options.success !== void 0) {
          removable = false;
          const successOptions = runIfFn(options.success, response);
          create(__spreadProps(__spreadValues(__spreadValues({}, shared), successOptions), { id, type: "success" }));
        }
      })).catch((error2) => __async(null, null, function* () {
        result = ["reject", error2];
        if (options.error !== void 0) {
          removable = false;
          const errorOptions = runIfFn(options.error, error2);
          create(__spreadProps(__spreadValues(__spreadValues({}, shared), errorOptions), { id, type: "error" }));
        }
      })).finally(() => {
        var _a;
        if (removable) {
          remove3(id);
        }
        (_a = options.finally) == null ? void 0 : _a.call(options);
      });
      const unwrap = () => new Promise(
        (resolve, reject) => prom.then(() => result[0] === "reject" ? reject(result[1]) : resolve(result[1])).catch(reject)
      );
      return { id, unwrap };
    };
    const update = (id, data) => {
      return create(__spreadValues({ id }, data));
    };
    const pause = (id) => {
      if (id != null) {
        toasts = toasts.map((toast) => {
          if (toast.id === id) return publish(__spreadProps(__spreadValues({}, toast), { message: "PAUSE" }));
          return toast;
        });
      } else {
        toasts = toasts.map((toast) => publish(__spreadProps(__spreadValues({}, toast), { message: "PAUSE" })));
      }
    };
    const resume = (id) => {
      if (id != null) {
        toasts = toasts.map((toast) => {
          if (toast.id === id) return publish(__spreadProps(__spreadValues({}, toast), { message: "RESUME" }));
          return toast;
        });
      } else {
        toasts = toasts.map((toast) => publish(__spreadProps(__spreadValues({}, toast), { message: "RESUME" })));
      }
    };
    const dismiss = (id) => {
      if (id != null) {
        toasts = toasts.map((toast) => {
          if (toast.id === id) return publish(__spreadProps(__spreadValues({}, toast), { message: "DISMISS" }));
          return toast;
        });
      } else {
        toasts = toasts.map((toast) => publish(__spreadProps(__spreadValues({}, toast), { message: "DISMISS" })));
      }
    };
    const isVisible = (id) => {
      return !dismissedToasts.has(id) && !!toasts.find((toast) => toast.id === id);
    };
    const isDismissed = (id) => {
      return dismissedToasts.has(id);
    };
    const expand = () => {
      toasts = toasts.map((toast) => publish(__spreadProps(__spreadValues({}, toast), { stacked: true })));
    };
    const collapse = () => {
      toasts = toasts.map((toast) => publish(__spreadProps(__spreadValues({}, toast), { stacked: false })));
    };
    return {
      attrs,
      subscribe: subscribe2,
      create,
      update,
      remove: remove3,
      dismiss,
      error,
      success,
      info,
      warning,
      loading,
      getVisibleToasts,
      getCount,
      promise,
      pause,
      resume,
      isVisible,
      isDismissed,
      expand,
      collapse
    };
  }
  function createToastGroup(container, options) {
    var _a, _b, _c;
    const groupId = (_a = options == null ? void 0 : options.id) != null ? _a : generateId(container, "toast");
    const store = (_c = options == null ? void 0 : options.store) != null ? _c : createToastStore({
      placement: (_b = options == null ? void 0 : options.placement) != null ? _b : "bottom",
      overlap: options == null ? void 0 : options.overlap,
      max: options == null ? void 0 : options.max,
      gap: options == null ? void 0 : options.gap,
      offsets: options == null ? void 0 : options.offsets,
      pauseOnPageIdle: options == null ? void 0 : options.pauseOnPageIdle
    });
    const group2 = new ToastGroup(container, { id: groupId, store });
    group2.init();
    toastGroups.set(groupId, group2);
    toastStores.set(groupId, store);
    container.dataset.toastGroup = "true";
    container.dataset.toastGroupId = groupId;
    return { group: group2, store };
  }
  function getToastStore(groupId) {
    if (groupId) return toastStores.get(groupId);
    const el = document.querySelector("[data-toast-group]");
    if (!el) return;
    const id = el.dataset.toastGroupId || el.id;
    return id ? toastStores.get(id) : void 0;
  }
  var anatomy13, parts13, getRegionId, getRegionEl, getRootId11, getRootEl4, getTitleId2, getDescriptionId2, getCloseTriggerId2, defaultTimeouts, getOffsets, guards2, createMachine22, and6, groupMachine, not7, machine13, withDefaults, isHttpResponse, group, toastGroups, toastStores, ToastItem, ToastGroup, ToastHook;
  var init_toast = __esm({
    "../priv/static/toast.mjs"() {
      "use strict";
      init_chunk_BPSX7Z7Y();
      init_chunk_GFGFZBBD();
      anatomy13 = createAnatomy("toast").parts(
        "group",
        "root",
        "title",
        "description",
        "actionTrigger",
        "closeTrigger"
      );
      parts13 = anatomy13.build();
      getRegionId = (placement) => `toast-group:${placement}`;
      getRegionEl = (ctx, placement) => ctx.getById(`toast-group:${placement}`);
      getRootId11 = (ctx) => `toast:${ctx.id}`;
      getRootEl4 = (ctx) => ctx.getById(getRootId11(ctx));
      getTitleId2 = (ctx) => `toast:${ctx.id}:title`;
      getDescriptionId2 = (ctx) => `toast:${ctx.id}:description`;
      getCloseTriggerId2 = (ctx) => `toast${ctx.id}:close`;
      defaultTimeouts = {
        info: 5e3,
        error: 5e3,
        success: 2e3,
        loading: Infinity,
        DEFAULT: 5e3
      };
      getOffsets = (offsets) => typeof offsets === "string" ? { left: offsets, right: offsets, bottom: offsets, top: offsets } : offsets;
      ({ guards: guards2, createMachine: createMachine22 } = setup());
      ({ and: and6 } = guards2);
      groupMachine = createMachine22({
        props({ props: props15 }) {
          return __spreadProps(__spreadValues({
            dir: "ltr",
            id: uuid()
          }, props15), {
            store: props15.store
          });
        },
        initialState({ prop }) {
          return prop("store").attrs.overlap ? "overlap" : "stack";
        },
        refs() {
          return {
            lastFocusedEl: null,
            isFocusWithin: false,
            isPointerWithin: false,
            ignoreMouseTimer: AnimationFrame.create(),
            dismissableCleanup: void 0
          };
        },
        context({ bindable: bindable2 }) {
          return {
            toasts: bindable2(() => ({
              defaultValue: [],
              sync: true,
              hash: (toasts) => toasts.map((t2) => t2.id).join(",")
            })),
            heights: bindable2(() => ({
              defaultValue: [],
              sync: true
            }))
          };
        },
        computed: {
          count: ({ context }) => context.get("toasts").length,
          overlap: ({ prop }) => prop("store").attrs.overlap,
          placement: ({ prop }) => prop("store").attrs.placement
        },
        effects: ["subscribeToStore", "trackDocumentVisibility", "trackHotKeyPress"],
        watch({ track, context, action }) {
          track([() => context.hash("toasts")], () => {
            queueMicrotask(() => {
              action(["collapsedIfEmpty", "setDismissableBranch"]);
            });
          });
        },
        exit: ["clearDismissableBranch", "clearLastFocusedEl", "clearMouseEventTimer"],
        on: {
          "DOC.HOTKEY": {
            actions: ["focusRegionEl"]
          },
          "REGION.BLUR": [
            {
              guard: and6("isOverlapping", "isPointerOut"),
              target: "overlap",
              actions: ["collapseToasts", "resumeToasts", "restoreFocusIfPointerOut"]
            },
            {
              guard: "isPointerOut",
              target: "stack",
              actions: ["resumeToasts", "restoreFocusIfPointerOut"]
            },
            {
              actions: ["clearFocusWithin"]
            }
          ],
          "TOAST.REMOVE": {
            actions: ["removeToast", "removeHeight", "ignoreMouseEventsTemporarily"]
          },
          "TOAST.PAUSE": {
            actions: ["pauseToasts"]
          }
        },
        states: {
          stack: {
            on: {
              "REGION.POINTER_LEAVE": [
                {
                  guard: "isOverlapping",
                  target: "overlap",
                  actions: ["clearPointerWithin", "resumeToasts", "collapseToasts"]
                },
                {
                  actions: ["clearPointerWithin", "resumeToasts"]
                }
              ],
              "REGION.OVERLAP": {
                target: "overlap",
                actions: ["collapseToasts"]
              },
              "REGION.FOCUS": {
                actions: ["setLastFocusedEl", "pauseToasts"]
              },
              "REGION.POINTER_ENTER": {
                actions: ["setPointerWithin", "pauseToasts"]
              }
            }
          },
          overlap: {
            on: {
              "REGION.STACK": {
                target: "stack",
                actions: ["expandToasts"]
              },
              "REGION.POINTER_ENTER": {
                target: "stack",
                actions: ["setPointerWithin", "pauseToasts", "expandToasts"]
              },
              "REGION.FOCUS": {
                target: "stack",
                actions: ["setLastFocusedEl", "pauseToasts", "expandToasts"]
              }
            }
          }
        },
        implementations: {
          guards: {
            isOverlapping: ({ computed }) => computed("overlap"),
            isPointerOut: ({ refs }) => !refs.get("isPointerWithin")
          },
          effects: {
            subscribeToStore({ context, prop }) {
              const store = prop("store");
              context.set("toasts", store.getVisibleToasts());
              return store.subscribe((toast) => {
                if (toast.dismiss) {
                  context.set("toasts", (prev2) => prev2.filter((t2) => t2.id !== toast.id));
                  return;
                }
                context.set("toasts", (prev2) => {
                  const index = prev2.findIndex((t2) => t2.id === toast.id);
                  if (index !== -1) {
                    return [...prev2.slice(0, index), __spreadValues(__spreadValues({}, prev2[index]), toast), ...prev2.slice(index + 1)];
                  }
                  return [toast, ...prev2];
                });
              });
            },
            trackHotKeyPress({ prop, send }) {
              const handleKeyDown = (event) => {
                const { hotkey } = prop("store").attrs;
                const isHotkeyPressed = hotkey.every((key) => event[key] || event.code === key);
                if (!isHotkeyPressed) return;
                send({ type: "DOC.HOTKEY" });
              };
              return addDomEvent(document, "keydown", handleKeyDown, { capture: true });
            },
            trackDocumentVisibility({ prop, send, scope }) {
              const { pauseOnPageIdle } = prop("store").attrs;
              if (!pauseOnPageIdle) return;
              const doc = scope.getDoc();
              return addDomEvent(doc, "visibilitychange", () => {
                const isHidden = doc.visibilityState === "hidden";
                send({ type: isHidden ? "PAUSE_ALL" : "RESUME_ALL" });
              });
            }
          },
          actions: {
            setDismissableBranch({ refs, context, computed, scope }) {
              var _a;
              const toasts = context.get("toasts");
              const placement = computed("placement");
              const hasToasts = toasts.length > 0;
              if (!hasToasts) {
                (_a = refs.get("dismissableCleanup")) == null ? void 0 : _a();
                return;
              }
              if (hasToasts && refs.get("dismissableCleanup")) {
                return;
              }
              const groupEl = () => getRegionEl(scope, placement);
              const cleanup = trackDismissableBranch(groupEl, { defer: true });
              refs.set("dismissableCleanup", cleanup);
            },
            clearDismissableBranch({ refs }) {
              var _a;
              (_a = refs.get("dismissableCleanup")) == null ? void 0 : _a();
            },
            focusRegionEl({ scope, computed }) {
              queueMicrotask(() => {
                var _a;
                (_a = getRegionEl(scope, computed("placement"))) == null ? void 0 : _a.focus();
              });
            },
            pauseToasts({ prop }) {
              prop("store").pause();
            },
            resumeToasts({ prop }) {
              prop("store").resume();
            },
            expandToasts({ prop }) {
              prop("store").expand();
            },
            collapseToasts({ prop }) {
              prop("store").collapse();
            },
            removeToast({ prop, event }) {
              prop("store").remove(event.id);
            },
            removeHeight({ event, context }) {
              if ((event == null ? void 0 : event.id) == null) return;
              queueMicrotask(() => {
                context.set("heights", (heights) => heights.filter((height) => height.id !== event.id));
              });
            },
            collapsedIfEmpty({ send, computed }) {
              if (!computed("overlap") || computed("count") > 1) return;
              send({ type: "REGION.OVERLAP" });
            },
            setLastFocusedEl({ refs, event }) {
              if (refs.get("isFocusWithin") || !event.target) return;
              refs.set("isFocusWithin", true);
              refs.set("lastFocusedEl", event.target);
            },
            restoreFocusIfPointerOut({ refs }) {
              var _a;
              if (!refs.get("lastFocusedEl") || refs.get("isPointerWithin")) return;
              (_a = refs.get("lastFocusedEl")) == null ? void 0 : _a.focus({ preventScroll: true });
              refs.set("lastFocusedEl", null);
              refs.set("isFocusWithin", false);
            },
            setPointerWithin({ refs }) {
              refs.set("isPointerWithin", true);
            },
            clearPointerWithin({ refs }) {
              var _a;
              refs.set("isPointerWithin", false);
              if (refs.get("lastFocusedEl") && !refs.get("isFocusWithin")) {
                (_a = refs.get("lastFocusedEl")) == null ? void 0 : _a.focus({ preventScroll: true });
                refs.set("lastFocusedEl", null);
              }
            },
            clearFocusWithin({ refs }) {
              refs.set("isFocusWithin", false);
            },
            clearLastFocusedEl({ refs }) {
              var _a;
              if (!refs.get("lastFocusedEl")) return;
              (_a = refs.get("lastFocusedEl")) == null ? void 0 : _a.focus({ preventScroll: true });
              refs.set("lastFocusedEl", null);
              refs.set("isFocusWithin", false);
            },
            ignoreMouseEventsTemporarily({ refs }) {
              refs.get("ignoreMouseTimer").request();
            },
            clearMouseEventTimer({ refs }) {
              refs.get("ignoreMouseTimer").cancel();
            }
          }
        }
      });
      ({ not: not7 } = createGuards());
      machine13 = createMachine({
        props({ props: props15 }) {
          ensureProps(props15, ["id", "type", "parent", "removeDelay"], "toast");
          return __spreadProps(__spreadValues({
            closable: true
          }, props15), {
            duration: getToastDuration(props15.duration, props15.type)
          });
        },
        initialState({ prop }) {
          const persist = prop("type") === "loading" || prop("duration") === Infinity;
          return persist ? "visible:persist" : "visible";
        },
        context({ prop, bindable: bindable2 }) {
          return {
            remainingTime: bindable2(() => ({
              defaultValue: getToastDuration(prop("duration"), prop("type"))
            })),
            createdAt: bindable2(() => ({
              defaultValue: Date.now()
            })),
            mounted: bindable2(() => ({
              defaultValue: false
            })),
            initialHeight: bindable2(() => ({
              defaultValue: 0
            }))
          };
        },
        refs() {
          return {
            closeTimerStartTime: Date.now(),
            lastCloseStartTimerStartTime: 0
          };
        },
        computed: {
          zIndex: ({ prop }) => {
            const toasts = prop("parent").context.get("toasts");
            const index = toasts.findIndex((toast) => toast.id === prop("id"));
            return toasts.length - index;
          },
          height: ({ prop }) => {
            var _a;
            const heights = prop("parent").context.get("heights");
            const height = heights.find((height2) => height2.id === prop("id"));
            return (_a = height == null ? void 0 : height.height) != null ? _a : 0;
          },
          heightIndex: ({ prop }) => {
            const heights = prop("parent").context.get("heights");
            return heights.findIndex((height) => height.id === prop("id"));
          },
          frontmost: ({ prop }) => prop("index") === 0,
          heightBefore: ({ prop }) => {
            const heights = prop("parent").context.get("heights");
            const heightIndex = heights.findIndex((height) => height.id === prop("id"));
            return heights.reduce((prev2, curr, reducerIndex) => {
              if (reducerIndex >= heightIndex) return prev2;
              return prev2 + curr.height;
            }, 0);
          },
          shouldPersist: ({ prop }) => prop("type") === "loading" || prop("duration") === Infinity
        },
        watch({ track, prop, send }) {
          track([() => prop("message")], () => {
            const message = prop("message");
            if (message) send({ type: message, src: "programmatic" });
          });
          track([() => prop("type"), () => prop("duration")], () => {
            send({ type: "UPDATE" });
          });
        },
        on: {
          UPDATE: [
            {
              guard: "shouldPersist",
              target: "visible:persist",
              actions: ["resetCloseTimer"]
            },
            {
              target: "visible:updating",
              actions: ["resetCloseTimer"]
            }
          ],
          MEASURE: {
            actions: ["measureHeight"]
          }
        },
        entry: ["setMounted", "measureHeight", "invokeOnVisible"],
        effects: ["trackHeight"],
        states: {
          "visible:updating": {
            tags: ["visible", "updating"],
            effects: ["waitForNextTick"],
            on: {
              SHOW: {
                target: "visible"
              }
            }
          },
          "visible:persist": {
            tags: ["visible", "paused"],
            on: {
              RESUME: {
                guard: not7("isLoadingType"),
                target: "visible",
                actions: ["setCloseTimer"]
              },
              DISMISS: {
                target: "dismissing"
              }
            }
          },
          visible: {
            tags: ["visible"],
            effects: ["waitForDuration"],
            on: {
              DISMISS: {
                target: "dismissing"
              },
              PAUSE: {
                target: "visible:persist",
                actions: ["syncRemainingTime"]
              }
            }
          },
          dismissing: {
            entry: ["invokeOnDismiss"],
            effects: ["waitForRemoveDelay"],
            on: {
              REMOVE: {
                target: "unmounted",
                actions: ["notifyParentToRemove"]
              }
            }
          },
          unmounted: {
            entry: ["invokeOnUnmount"]
          }
        },
        implementations: {
          effects: {
            waitForRemoveDelay({ prop, send }) {
              return setRafTimeout(() => {
                send({ type: "REMOVE", src: "timer" });
              }, prop("removeDelay"));
            },
            waitForDuration({ send, context, computed }) {
              if (computed("shouldPersist")) return;
              return setRafTimeout(() => {
                send({ type: "DISMISS", src: "timer" });
              }, context.get("remainingTime"));
            },
            waitForNextTick({ send }) {
              return setRafTimeout(() => {
                send({ type: "SHOW", src: "timer" });
              }, 0);
            },
            trackHeight({ scope, prop }) {
              let cleanup;
              raf(() => {
                const rootEl = getRootEl4(scope);
                if (!rootEl) return;
                const syncHeight = () => {
                  const originalHeight = rootEl.style.height;
                  rootEl.style.height = "auto";
                  const height = rootEl.getBoundingClientRect().height;
                  rootEl.style.height = originalHeight;
                  const item = { id: prop("id"), height };
                  setHeight(prop("parent"), item);
                };
                const win = scope.getWin();
                const observer = new win.MutationObserver(syncHeight);
                observer.observe(rootEl, {
                  childList: true,
                  subtree: true,
                  characterData: true
                });
                cleanup = () => observer.disconnect();
              });
              return () => cleanup == null ? void 0 : cleanup();
            }
          },
          guards: {
            isLoadingType: ({ prop }) => prop("type") === "loading",
            shouldPersist: ({ computed }) => computed("shouldPersist")
          },
          actions: {
            setMounted({ context }) {
              raf(() => {
                context.set("mounted", true);
              });
            },
            measureHeight({ scope, prop, context }) {
              queueMicrotask(() => {
                const rootEl = getRootEl4(scope);
                if (!rootEl) return;
                const originalHeight = rootEl.style.height;
                rootEl.style.height = "auto";
                const height = rootEl.getBoundingClientRect().height;
                rootEl.style.height = originalHeight;
                context.set("initialHeight", height);
                const item = { id: prop("id"), height };
                setHeight(prop("parent"), item);
              });
            },
            setCloseTimer({ refs }) {
              refs.set("closeTimerStartTime", Date.now());
            },
            resetCloseTimer({ context, refs, prop }) {
              refs.set("closeTimerStartTime", Date.now());
              context.set("remainingTime", getToastDuration(prop("duration"), prop("type")));
            },
            syncRemainingTime({ context, refs }) {
              context.set("remainingTime", (prev2) => {
                const closeTimerStartTime = refs.get("closeTimerStartTime");
                const elapsedTime = Date.now() - closeTimerStartTime;
                refs.set("lastCloseStartTimerStartTime", Date.now());
                return prev2 - elapsedTime;
              });
            },
            notifyParentToRemove({ prop }) {
              const parent = prop("parent");
              parent.send({ type: "TOAST.REMOVE", id: prop("id") });
            },
            invokeOnDismiss({ prop, event }) {
              var _a;
              (_a = prop("onStatusChange")) == null ? void 0 : _a({ status: "dismissing", src: event.src });
            },
            invokeOnUnmount({ prop }) {
              var _a;
              (_a = prop("onStatusChange")) == null ? void 0 : _a({ status: "unmounted" });
            },
            invokeOnVisible({ prop }) {
              var _a;
              (_a = prop("onStatusChange")) == null ? void 0 : _a({ status: "visible" });
            }
          }
        }
      });
      withDefaults = (options, defaults) => {
        return __spreadValues(__spreadValues({}, defaults), compact(options));
      };
      isHttpResponse = (data) => {
        return data && typeof data === "object" && "ok" in data && typeof data.ok === "boolean" && "status" in data && typeof data.status === "number";
      };
      group = {
        connect: groupConnect,
        machine: groupMachine
      };
      toastGroups = /* @__PURE__ */ new Map();
      toastStores = /* @__PURE__ */ new Map();
      ToastItem = class extends Component {
        constructor(el, props15) {
          super(el, props15);
          __publicField(this, "parts");
          __publicField(this, "duration");
          __publicField(this, "destroy", () => {
            this.machine.stop();
            this.el.remove();
          });
          this.duration = props15.duration;
          this.el.setAttribute("data-scope", "toast");
          this.el.setAttribute("data-part", "root");
          this.el.innerHTML = `
      <span data-scope="toast" data-part="ghost-before"></span>
      <div data-scope="toast" data-part="progressbar"></div>
      <div data-scope="toast" data-part="loading-spinner" style="display: none;"></div>

      <div data-scope="toast" data-part="content">
        <div data-scope="toast" data-part="title"></div>
        <div data-scope="toast" data-part="description"></div>
      </div>

      <button data-scope="toast" data-part="close-trigger">
        <svg viewBox="0 0 20 20" aria-hidden="true">
          <path d="M4.293 4.293 10 8.586l5.707-5.707 1.414 1.414L11.414 10l5.707 5.707-1.414 1.414L10 11.414l-5.707 5.707-1.414-1.414L8.586 10 2.879 4.293z"/>
        </svg>
      </button>

      <span data-scope="toast" data-part="ghost-after"></span>
    `;
          this.parts = {
            title: this.el.querySelector('[data-scope="toast"][data-part="title"]'),
            description: this.el.querySelector('[data-scope="toast"][data-part="description"]'),
            close: this.el.querySelector('[data-scope="toast"][data-part="close-trigger"]'),
            ghostBefore: this.el.querySelector('[data-scope="toast"][data-part="ghost-before"]'),
            ghostAfter: this.el.querySelector('[data-scope="toast"][data-part="ghost-after"]'),
            progressbar: this.el.querySelector('[data-scope="toast"][data-part="progressbar"]'),
            loadingSpinner: this.el.querySelector('[data-scope="toast"][data-part="loading-spinner"]')
          };
        }
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        initMachine(props15) {
          return new VanillaMachine(machine13, props15);
        }
        initApi() {
          return connect13(this.machine.service, normalizeProps);
        }
        render() {
          var _a, _b;
          this.spreadProps(this.el, this.api.getRootProps());
          this.spreadProps(this.parts.close, this.api.getCloseTriggerProps());
          this.spreadProps(this.parts.ghostBefore, this.api.getGhostBeforeProps());
          this.spreadProps(this.parts.ghostAfter, this.api.getGhostAfterProps());
          if (this.parts.title.textContent !== this.api.title) {
            this.parts.title.textContent = (_a = this.api.title) != null ? _a : "";
          }
          if (this.parts.description.textContent !== this.api.description) {
            this.parts.description.textContent = (_b = this.api.description) != null ? _b : "";
          }
          this.spreadProps(this.parts.title, this.api.getTitleProps());
          this.spreadProps(this.parts.description, this.api.getDescriptionProps());
          const duration = this.duration;
          const isInfinity = duration === "Infinity" || duration === Infinity || duration === Number.POSITIVE_INFINITY;
          const toastGroup = this.el.closest('[phx-hook="Toast"]');
          const loadingIconTemplate = toastGroup == null ? void 0 : toastGroup.querySelector("[data-loading-icon-template]");
          const loadingIcon = loadingIconTemplate == null ? void 0 : loadingIconTemplate.innerHTML;
          if (isInfinity) {
            this.parts.progressbar.style.display = "none";
            this.parts.loadingSpinner.style.display = "flex";
            this.el.setAttribute("data-duration-infinity", "true");
            if (loadingIcon && this.parts.loadingSpinner.innerHTML !== loadingIcon) {
              this.parts.loadingSpinner.innerHTML = loadingIcon;
            }
          } else {
            this.parts.progressbar.style.display = "block";
            this.parts.loadingSpinner.style.display = "none";
            this.el.removeAttribute("data-duration-infinity");
          }
        }
      };
      ToastGroup = class extends Component {
        constructor(el, props15) {
          var _a;
          super(el, props15);
          __publicField(this, "toastComponents", /* @__PURE__ */ new Map());
          __publicField(this, "groupEl");
          __publicField(this, "store");
          __publicField(this, "destroy", () => {
            for (const comp of this.toastComponents.values()) {
              comp.destroy();
            }
            this.toastComponents.clear();
            this.machine.stop();
          });
          this.store = props15.store;
          this.groupEl = (_a = el.querySelector('[data-part="group"]')) != null ? _a : (() => {
            const g2 = document.createElement("div");
            g2.setAttribute("data-scope", "toast");
            g2.setAttribute("data-part", "group");
            el.appendChild(g2);
            return g2;
          })();
        }
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        initMachine(props15) {
          return new VanillaMachine(group.machine, props15);
        }
        initApi() {
          return group.connect(this.machine.service, normalizeProps);
        }
        render() {
          this.spreadProps(this.groupEl, this.api.getGroupProps());
          const toasts = this.api.getToasts().filter((t2) => typeof t2.id === "string");
          const nextIds = new Set(toasts.map((t2) => t2.id));
          toasts.forEach((toastData, index) => {
            let item = this.toastComponents.get(toastData.id);
            if (!item) {
              const el = document.createElement("div");
              el.setAttribute("data-scope", "toast");
              el.setAttribute("data-part", "root");
              this.groupEl.appendChild(el);
              item = new ToastItem(el, __spreadProps(__spreadValues({}, toastData), {
                parent: this.machine.service,
                index
              }));
              item.init();
              this.toastComponents.set(toastData.id, item);
            } else {
              item.duration = toastData.duration;
              item.updateProps(__spreadProps(__spreadValues({}, toastData), {
                parent: this.machine.service,
                index
              }));
            }
          });
          for (const [id, comp] of this.toastComponents) {
            if (!nextIds.has(id)) {
              comp.destroy();
              this.toastComponents.delete(id);
            }
          }
        }
      };
      ToastHook = {
        mounted() {
          var _a;
          const el = this.el;
          if (!el.id) {
            el.id = generateId(el, "toast");
          }
          this.groupId = el.id;
          const parseOffsets = (offsetsString) => {
            if (!offsetsString) return void 0;
            try {
              return offsetsString.includes("{") ? JSON.parse(offsetsString) : offsetsString;
            } catch (e2) {
              return offsetsString;
            }
          };
          const parseDuration = (duration) => {
            if (duration === "Infinity" || duration === Infinity) {
              return Infinity;
            }
            if (typeof duration === "string") {
              return parseInt(duration, 10) || void 0;
            }
            return duration;
          };
          const placement = (_a = getString(el, "placement", [
            "top-start",
            "top",
            "top-end",
            "bottom-start",
            "bottom",
            "bottom-end"
          ])) != null ? _a : "bottom-end";
          createToastGroup(el, {
            id: this.groupId,
            placement,
            overlap: getBoolean(el, "overlap"),
            max: getNumber(el, "max"),
            gap: getNumber(el, "gap"),
            offsets: parseOffsets(getString(el, "offset")),
            pauseOnPageIdle: getBoolean(el, "pauseOnPageIdle")
          });
          const store = getToastStore(this.groupId);
          const flashInfo = el.getAttribute("data-flash-info");
          const flashInfoTitle = el.getAttribute("data-flash-info-title");
          const flashError = el.getAttribute("data-flash-error");
          const flashErrorTitle = el.getAttribute("data-flash-error-title");
          const flashInfoDuration = el.getAttribute("data-flash-info-duration");
          const flashErrorDuration = el.getAttribute("data-flash-error-duration");
          if (store && flashInfo) {
            try {
              store.create({
                title: flashInfoTitle || "Success",
                description: flashInfo,
                type: "info",
                id: generateId(void 0, "toast"),
                duration: parseDuration(flashInfoDuration != null ? flashInfoDuration : void 0)
              });
            } catch (error) {
              console.error("Failed to create flash info toast:", error);
            }
          }
          if (store && flashError) {
            try {
              store.create({
                title: flashErrorTitle || "Error",
                description: flashError,
                type: "error",
                id: generateId(void 0, "toast"),
                duration: parseDuration(flashErrorDuration != null ? flashErrorDuration : void 0)
              });
            } catch (error) {
              console.error("Failed to create flash error toast:", error);
            }
          }
          this.handlers = [];
          this.handlers.push(
            this.handleEvent("toast-create", (payload) => {
              const store2 = getToastStore(payload.groupId || this.groupId);
              if (!store2) return;
              try {
                store2.create({
                  title: payload.title,
                  description: payload.description,
                  type: payload.type || "info",
                  id: payload.id || generateId(void 0, "toast"),
                  duration: parseDuration(payload.duration)
                });
              } catch (error) {
                console.error("Failed to create toast:", error);
              }
            })
          );
          this.handlers.push(
            this.handleEvent("toast-update", (payload) => {
              const store2 = getToastStore(payload.groupId || this.groupId);
              if (!store2) return;
              try {
                store2.update(payload.id, {
                  title: payload.title,
                  description: payload.description,
                  type: payload.type
                });
              } catch (error) {
                console.error("Failed to update toast:", error);
              }
            })
          );
          this.handlers.push(
            this.handleEvent("toast-dismiss", (payload) => {
              const store2 = getToastStore(payload.groupId || this.groupId);
              if (!store2) return;
              try {
                store2.dismiss(payload.id);
              } catch (error) {
                console.error("Failed to dismiss toast:", error);
              }
            })
          );
          el.addEventListener("toast:create", (event) => {
            const { detail } = event;
            const store2 = getToastStore(detail.groupId || this.groupId);
            if (!store2) return;
            try {
              store2.create({
                title: detail.title,
                description: detail.description,
                type: detail.type || "info",
                id: detail.id || generateId(void 0, "toast"),
                duration: parseDuration(detail.duration)
              });
            } catch (error) {
              console.error("Failed to create toast:", error);
            }
          });
        },
        destroyed() {
          if (this.handlers) {
            for (const handler of this.handlers) {
              this.removeHandleEvent(handler);
            }
          }
        }
      };
    }
  });

  // ../priv/static/toggle-group.mjs
  var toggle_group_exports = {};
  __export(toggle_group_exports, {
    ToggleGroup: () => ToggleGroupHook
  });
  function connect14(service, normalize) {
    const { context, send, prop, scope } = service;
    const value = context.get("value");
    const disabled = prop("disabled");
    const isSingle = !prop("multiple");
    const rovingFocus = prop("rovingFocus");
    const isHorizontal = prop("orientation") === "horizontal";
    function getItemState(props22) {
      const id = getItemId5(scope, props22.value);
      return {
        id,
        disabled: Boolean(props22.disabled || disabled),
        pressed: !!value.includes(props22.value),
        focused: context.get("focusedId") === id
      };
    }
    return {
      value,
      setValue(value2) {
        send({ type: "VALUE.SET", value: value2 });
      },
      getRootProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts14.root.attrs), {
          id: getRootId12(scope),
          dir: prop("dir"),
          role: isSingle ? "radiogroup" : "group",
          tabIndex: context.get("isTabbingBackward") ? -1 : 0,
          "data-disabled": dataAttr(disabled),
          "data-orientation": prop("orientation"),
          "data-focus": dataAttr(context.get("focusedId") != null),
          style: { outline: "none" },
          onMouseDown() {
            if (disabled) return;
            send({ type: "ROOT.MOUSE_DOWN" });
          },
          onFocus(event) {
            if (disabled) return;
            if (event.currentTarget !== getEventTarget(event)) return;
            if (context.get("isClickFocus")) return;
            if (context.get("isTabbingBackward")) return;
            send({ type: "ROOT.FOCUS" });
          },
          onBlur(event) {
            const target = event.relatedTarget;
            if (contains(event.currentTarget, target)) return;
            if (disabled) return;
            send({ type: "ROOT.BLUR" });
          }
        }));
      },
      getItemState,
      getItemProps(props22) {
        const itemState = getItemState(props22);
        const rovingTabIndex = itemState.focused ? 0 : -1;
        return normalize.button(__spreadProps(__spreadValues({}, parts14.item.attrs), {
          id: itemState.id,
          type: "button",
          "data-ownedby": getRootId12(scope),
          "data-focus": dataAttr(itemState.focused),
          disabled: itemState.disabled,
          tabIndex: rovingFocus ? rovingTabIndex : void 0,
          // radio
          role: isSingle ? "radio" : void 0,
          "aria-checked": isSingle ? itemState.pressed : void 0,
          "aria-pressed": isSingle ? void 0 : itemState.pressed,
          //
          "data-disabled": dataAttr(itemState.disabled),
          "data-orientation": prop("orientation"),
          dir: prop("dir"),
          "data-state": itemState.pressed ? "on" : "off",
          onFocus() {
            if (itemState.disabled) return;
            send({ type: "TOGGLE.FOCUS", id: itemState.id });
          },
          onClick(event) {
            if (itemState.disabled) return;
            send({ type: "TOGGLE.CLICK", id: itemState.id, value: props22.value });
            if (isSafari()) {
              event.currentTarget.focus({ preventScroll: true });
            }
          },
          onKeyDown(event) {
            if (event.defaultPrevented) return;
            if (!contains(event.currentTarget, getEventTarget(event))) return;
            if (itemState.disabled) return;
            const keyMap2 = {
              Tab(event2) {
                const isShiftTab = event2.shiftKey;
                send({ type: "TOGGLE.SHIFT_TAB", isShiftTab });
              },
              ArrowLeft() {
                if (!rovingFocus || !isHorizontal) return;
                send({ type: "TOGGLE.FOCUS_PREV" });
              },
              ArrowRight() {
                if (!rovingFocus || !isHorizontal) return;
                send({ type: "TOGGLE.FOCUS_NEXT" });
              },
              ArrowUp() {
                if (!rovingFocus || isHorizontal) return;
                send({ type: "TOGGLE.FOCUS_PREV" });
              },
              ArrowDown() {
                if (!rovingFocus || isHorizontal) return;
                send({ type: "TOGGLE.FOCUS_NEXT" });
              },
              Home() {
                if (!rovingFocus) return;
                send({ type: "TOGGLE.FOCUS_FIRST" });
              },
              End() {
                if (!rovingFocus) return;
                send({ type: "TOGGLE.FOCUS_LAST" });
              }
            };
            const exec = keyMap2[getEventKey(event)];
            if (exec) {
              exec(event);
              if (event.key !== "Tab") event.preventDefault();
            }
          }
        }));
      }
    };
  }
  var anatomy14, parts14, getRootId12, getItemId5, getRootEl5, getElements3, getFirstEl2, getLastEl2, getNextEl2, getPrevEl2, not8, and7, machine14, props13, splitProps13, itemProps5, splitItemProps5, ToggleGroup, ToggleGroupHook;
  var init_toggle_group = __esm({
    "../priv/static/toggle-group.mjs"() {
      "use strict";
      init_chunk_GFGFZBBD();
      anatomy14 = createAnatomy("toggle-group").parts("root", "item");
      parts14 = anatomy14.build();
      getRootId12 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.root) != null ? _b : `toggle-group:${ctx.id}`;
      };
      getItemId5 = (ctx, value) => {
        var _a, _b, _c;
        return (_c = (_b = (_a = ctx.ids) == null ? void 0 : _a.item) == null ? void 0 : _b.call(_a, value)) != null ? _c : `toggle-group:${ctx.id}:${value}`;
      };
      getRootEl5 = (ctx) => ctx.getById(getRootId12(ctx));
      getElements3 = (ctx) => {
        const ownerId = CSS.escape(getRootId12(ctx));
        const selector = `[data-ownedby='${ownerId}']:not([data-disabled])`;
        return queryAll(getRootEl5(ctx), selector);
      };
      getFirstEl2 = (ctx) => first(getElements3(ctx));
      getLastEl2 = (ctx) => last(getElements3(ctx));
      getNextEl2 = (ctx, id, loopFocus) => nextById(getElements3(ctx), id, loopFocus);
      getPrevEl2 = (ctx, id, loopFocus) => prevById(getElements3(ctx), id, loopFocus);
      ({ not: not8, and: and7 } = createGuards());
      machine14 = createMachine({
        props({ props: props22 }) {
          return __spreadValues({
            defaultValue: [],
            orientation: "horizontal",
            rovingFocus: true,
            loopFocus: true,
            deselectable: true
          }, props22);
        },
        initialState() {
          return "idle";
        },
        context({ prop, bindable: bindable2 }) {
          return {
            value: bindable2(() => ({
              defaultValue: prop("defaultValue"),
              value: prop("value"),
              onChange(value) {
                var _a;
                (_a = prop("onValueChange")) == null ? void 0 : _a({ value });
              }
            })),
            focusedId: bindable2(() => ({
              defaultValue: null
            })),
            isTabbingBackward: bindable2(() => ({
              defaultValue: false
            })),
            isClickFocus: bindable2(() => ({
              defaultValue: false
            })),
            isWithinToolbar: bindable2(() => ({
              defaultValue: false
            }))
          };
        },
        computed: {
          currentLoopFocus: ({ context, prop }) => prop("loopFocus") && !context.get("isWithinToolbar")
        },
        entry: ["checkIfWithinToolbar"],
        on: {
          "VALUE.SET": {
            actions: ["setValue"]
          },
          "TOGGLE.CLICK": {
            actions: ["setValue"]
          },
          "ROOT.MOUSE_DOWN": {
            actions: ["setClickFocus"]
          }
        },
        states: {
          idle: {
            on: {
              "ROOT.FOCUS": {
                target: "focused",
                guard: not8(and7("isClickFocus", "isTabbingBackward")),
                actions: ["focusFirstToggle", "clearClickFocus"]
              },
              "TOGGLE.FOCUS": {
                target: "focused",
                actions: ["setFocusedId"]
              }
            }
          },
          focused: {
            on: {
              "ROOT.BLUR": {
                target: "idle",
                actions: ["clearIsTabbingBackward", "clearFocusedId", "clearClickFocus"]
              },
              "TOGGLE.FOCUS": {
                actions: ["setFocusedId"]
              },
              "TOGGLE.FOCUS_NEXT": {
                actions: ["focusNextToggle"]
              },
              "TOGGLE.FOCUS_PREV": {
                actions: ["focusPrevToggle"]
              },
              "TOGGLE.FOCUS_FIRST": {
                actions: ["focusFirstToggle"]
              },
              "TOGGLE.FOCUS_LAST": {
                actions: ["focusLastToggle"]
              },
              "TOGGLE.SHIFT_TAB": [
                {
                  guard: not8("isFirstToggleFocused"),
                  target: "idle",
                  actions: ["setIsTabbingBackward"]
                },
                {
                  actions: ["setIsTabbingBackward"]
                }
              ]
            }
          }
        },
        implementations: {
          guards: {
            isClickFocus: ({ context }) => context.get("isClickFocus"),
            isTabbingBackward: ({ context }) => context.get("isTabbingBackward"),
            isFirstToggleFocused: ({ context, scope }) => {
              var _a;
              return context.get("focusedId") === ((_a = getFirstEl2(scope)) == null ? void 0 : _a.id);
            }
          },
          actions: {
            setIsTabbingBackward({ context }) {
              context.set("isTabbingBackward", true);
            },
            clearIsTabbingBackward({ context }) {
              context.set("isTabbingBackward", false);
            },
            setClickFocus({ context }) {
              context.set("isClickFocus", true);
            },
            clearClickFocus({ context }) {
              context.set("isClickFocus", false);
            },
            checkIfWithinToolbar({ context, scope }) {
              var _a;
              const closestToolbar = (_a = getRootEl5(scope)) == null ? void 0 : _a.closest("[role=toolbar]");
              context.set("isWithinToolbar", !!closestToolbar);
            },
            setFocusedId({ context, event }) {
              context.set("focusedId", event.id);
            },
            clearFocusedId({ context }) {
              context.set("focusedId", null);
            },
            setValue({ context, event, prop }) {
              ensureProps(event, ["value"]);
              let next2 = context.get("value");
              if (isArray(event.value)) {
                next2 = event.value;
              } else if (prop("multiple")) {
                next2 = addOrRemove(next2, event.value);
              } else {
                const isSelected = isEqual2(next2, [event.value]);
                next2 = isSelected && prop("deselectable") ? [] : [event.value];
              }
              context.set("value", next2);
            },
            focusNextToggle({ context, scope, prop }) {
              raf(() => {
                var _a;
                const focusedId = context.get("focusedId");
                if (!focusedId) return;
                (_a = getNextEl2(scope, focusedId, prop("loopFocus"))) == null ? void 0 : _a.focus({ preventScroll: true });
              });
            },
            focusPrevToggle({ context, scope, prop }) {
              raf(() => {
                var _a;
                const focusedId = context.get("focusedId");
                if (!focusedId) return;
                (_a = getPrevEl2(scope, focusedId, prop("loopFocus"))) == null ? void 0 : _a.focus({ preventScroll: true });
              });
            },
            focusFirstToggle({ scope }) {
              raf(() => {
                var _a;
                (_a = getFirstEl2(scope)) == null ? void 0 : _a.focus({ preventScroll: true });
              });
            },
            focusLastToggle({ scope }) {
              raf(() => {
                var _a;
                (_a = getLastEl2(scope)) == null ? void 0 : _a.focus({ preventScroll: true });
              });
            }
          }
        }
      });
      props13 = createProps()([
        "dir",
        "disabled",
        "getRootNode",
        "id",
        "ids",
        "loopFocus",
        "multiple",
        "onValueChange",
        "orientation",
        "rovingFocus",
        "value",
        "defaultValue",
        "deselectable"
      ]);
      splitProps13 = createSplitProps(props13);
      itemProps5 = createProps()(["value", "disabled"]);
      splitItemProps5 = createSplitProps(itemProps5);
      ToggleGroup = class extends Component {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        initMachine(props22) {
          return new VanillaMachine(machine14, props22);
        }
        initApi() {
          return connect14(this.machine.service, normalizeProps);
        }
        render() {
          const rootEl = this.el.querySelector('[data-scope="toggle-group"][data-part="root"]');
          if (!rootEl) return;
          this.spreadProps(rootEl, this.api.getRootProps());
          const items = this.el.querySelectorAll('[data-scope="toggle-group"][data-part="item"]');
          for (let i2 = 0; i2 < items.length; i2++) {
            const itemEl = items[i2];
            const value = getString(itemEl, "value");
            if (!value) continue;
            const disabled = getBoolean(itemEl, "disabled");
            this.spreadProps(itemEl, this.api.getItemProps({ value, disabled }));
          }
        }
      };
      ToggleGroupHook = {
        mounted() {
          const el = this.el;
          const pushEvent = this.pushEvent.bind(this);
          const props22 = __spreadProps(__spreadValues({
            id: el.id
          }, getBoolean(el, "controlled") ? { value: getStringList(el, "value") } : { defaultValue: getStringList(el, "defaultValue") }), {
            defaultValue: getStringList(el, "defaultValue"),
            deselectable: getBoolean(el, "deselectable"),
            loopFocus: getBoolean(el, "loopFocus"),
            rovingFocus: getBoolean(el, "rovingFocus"),
            disabled: getBoolean(el, "disabled"),
            multiple: getBoolean(el, "multiple"),
            orientation: getString(el, "orientation", ["horizontal", "vertical"]),
            dir: getString(el, "dir", ["ltr", "rtl"]),
            onValueChange: (details) => {
              const eventName = getString(el, "onValueChange");
              if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
                pushEvent(eventName, {
                  value: details.value,
                  id: el.id
                });
              }
              const eventNameClient = getString(el, "onValueChangeClient");
              if (eventNameClient) {
                el.dispatchEvent(
                  new CustomEvent(eventNameClient, {
                    bubbles: true,
                    detail: {
                      value: details.value,
                      id: el.id
                    }
                  })
                );
              }
            }
          });
          const toggleGroup = new ToggleGroup(el, props22);
          toggleGroup.init();
          this.toggleGroup = toggleGroup;
          this.onSetValue = (event) => {
            const { value } = event.detail;
            toggleGroup.api.setValue(value);
          };
          el.addEventListener("phx:toggle-group:set-value", this.onSetValue);
          this.handlers = [];
          this.handlers.push(
            this.handleEvent(
              "toggle-group_set_value",
              (payload) => {
                const targetId = payload.id;
                if (targetId && targetId !== el.id) return;
                toggleGroup.api.setValue(payload.value);
              }
            )
          );
          this.handlers.push(
            this.handleEvent("toggle-group:value", () => {
              this.pushEvent("toggle-group:value_response", {
                value: toggleGroup.api.value
              });
            })
          );
        },
        updated() {
          var _a;
          (_a = this.toggleGroup) == null ? void 0 : _a.updateProps(__spreadProps(__spreadValues({}, getBoolean(this.el, "controlled") ? { value: getStringList(this.el, "value") } : { defaultValue: getStringList(this.el, "defaultValue") }), {
            deselectable: getBoolean(this.el, "deselectable"),
            loopFocus: getBoolean(this.el, "loopFocus"),
            rovingFocus: getBoolean(this.el, "rovingFocus"),
            disabled: getBoolean(this.el, "disabled"),
            multiple: getBoolean(this.el, "multiple"),
            orientation: getString(this.el, "orientation", ["horizontal", "vertical"]),
            dir: getString(this.el, "dir", ["ltr", "rtl"])
          }));
        },
        destroyed() {
          var _a;
          if (this.onSetValue) {
            this.el.removeEventListener("phx:toggle-group:set-value", this.onSetValue);
          }
          if (this.handlers) {
            for (const handler of this.handlers) {
              this.removeHandleEvent(handler);
            }
          }
          (_a = this.toggleGroup) == null ? void 0 : _a.destroy();
        }
      };
    }
  });

  // ../priv/static/tree-view.mjs
  var tree_view_exports = {};
  __export(tree_view_exports, {
    TreeView: () => TreeViewHook
  });
  function getCheckedState(collection22, node, checkedValue) {
    const value = collection22.getNodeValue(node);
    if (!collection22.isBranchNode(node)) {
      return checkedValue.includes(value);
    }
    const childValues = collection22.getDescendantValues(value);
    const allChecked = childValues.every((v2) => checkedValue.includes(v2));
    const someChecked = childValues.some((v2) => checkedValue.includes(v2));
    return allChecked ? true : someChecked ? "indeterminate" : false;
  }
  function toggleBranchChecked(collection22, value, checkedValue) {
    const childValues = collection22.getDescendantValues(value);
    const allChecked = childValues.every((child) => checkedValue.includes(child));
    return uniq(allChecked ? remove(checkedValue, ...childValues) : add(checkedValue, ...childValues));
  }
  function getCheckedValueMap(collection22, checkedValue) {
    const map2 = /* @__PURE__ */ new Map();
    collection22.visit({
      onEnter: (node) => {
        const value = collection22.getNodeValue(node);
        const isBranch = collection22.isBranchNode(node);
        const checked = getCheckedState(collection22, node, checkedValue);
        map2.set(value, {
          type: isBranch ? "branch" : "leaf",
          checked
        });
      }
    });
    return map2;
  }
  function connect15(service, normalize) {
    const { context, scope, computed, prop, send } = service;
    const collection22 = prop("collection");
    const expandedValue = Array.from(context.get("expandedValue"));
    const selectedValue = Array.from(context.get("selectedValue"));
    const checkedValue = Array.from(context.get("checkedValue"));
    const isTypingAhead = computed("isTypingAhead");
    const focusedValue = context.get("focusedValue");
    const loadingStatus = context.get("loadingStatus");
    const renamingValue = context.get("renamingValue");
    const skip = ({ indexPath }) => {
      const paths = collection22.getValuePath(indexPath).slice(0, -1);
      return paths.some((value) => !expandedValue.includes(value));
    };
    const firstNode = collection22.getFirstNode(void 0, { skip });
    const firstNodeValue = firstNode ? collection22.getNodeValue(firstNode) : null;
    function getNodeState(props22) {
      const { node, indexPath } = props22;
      const value = collection22.getNodeValue(node);
      return {
        id: getNodeId(scope, value),
        value,
        indexPath,
        valuePath: collection22.getValuePath(indexPath),
        disabled: Boolean(node.disabled),
        focused: focusedValue == null ? firstNodeValue === value : focusedValue === value,
        selected: selectedValue.includes(value),
        expanded: expandedValue.includes(value),
        loading: loadingStatus[value] === "loading",
        depth: indexPath.length,
        isBranch: collection22.isBranchNode(node),
        renaming: renamingValue === value,
        get checked() {
          return getCheckedState(collection22, node, checkedValue);
        }
      };
    }
    return {
      collection: collection22,
      expandedValue,
      selectedValue,
      checkedValue,
      toggleChecked(value, isBranch) {
        send({ type: "CHECKED.TOGGLE", value, isBranch });
      },
      setChecked(value) {
        send({ type: "CHECKED.SET", value });
      },
      clearChecked() {
        send({ type: "CHECKED.CLEAR" });
      },
      getCheckedMap() {
        return getCheckedValueMap(collection22, checkedValue);
      },
      expand(value) {
        send({ type: value ? "BRANCH.EXPAND" : "EXPANDED.ALL", value });
      },
      collapse(value) {
        send({ type: value ? "BRANCH.COLLAPSE" : "EXPANDED.CLEAR", value });
      },
      deselect(value) {
        send({ type: value ? "NODE.DESELECT" : "SELECTED.CLEAR", value });
      },
      select(value) {
        send({ type: value ? "NODE.SELECT" : "SELECTED.ALL", value, isTrusted: false });
      },
      getVisibleNodes() {
        return computed("visibleNodes");
      },
      focus(value) {
        focusNode(scope, value);
      },
      selectParent(value) {
        const parentNode = collection22.getParentNode(value);
        if (!parentNode) return;
        const _selectedValue = add(selectedValue, collection22.getNodeValue(parentNode));
        send({ type: "SELECTED.SET", value: _selectedValue, src: "select.parent" });
      },
      expandParent(value) {
        const parentNode = collection22.getParentNode(value);
        if (!parentNode) return;
        const _expandedValue = add(expandedValue, collection22.getNodeValue(parentNode));
        send({ type: "EXPANDED.SET", value: _expandedValue, src: "expand.parent" });
      },
      setExpandedValue(value) {
        const _expandedValue = uniq(value);
        send({ type: "EXPANDED.SET", value: _expandedValue });
      },
      setSelectedValue(value) {
        const _selectedValue = uniq(value);
        send({ type: "SELECTED.SET", value: _selectedValue });
      },
      startRenaming(value) {
        send({ type: "NODE.RENAME", value });
      },
      submitRenaming(value, label) {
        send({ type: "RENAME.SUBMIT", value, label });
      },
      cancelRenaming() {
        send({ type: "RENAME.CANCEL" });
      },
      getRootProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts15.root.attrs), {
          id: getRootId13(scope),
          dir: prop("dir")
        }));
      },
      getLabelProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts15.label.attrs), {
          id: getLabelId8(scope),
          dir: prop("dir")
        }));
      },
      getTreeProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts15.tree.attrs), {
          id: getTreeId(scope),
          dir: prop("dir"),
          role: "tree",
          "aria-label": "Tree View",
          "aria-labelledby": getLabelId8(scope),
          "aria-multiselectable": prop("selectionMode") === "multiple" || void 0,
          tabIndex: -1,
          onKeyDown(event) {
            if (event.defaultPrevented) return;
            if (isComposingEvent(event)) return;
            const target = getEventTarget(event);
            if (isEditableElement(target)) return;
            const node = target == null ? void 0 : target.closest("[data-part=branch-control], [data-part=item]");
            if (!node) return;
            const nodeId = node.dataset.value;
            if (nodeId == null) {
              console.warn(`[zag-js/tree-view] Node id not found for node`, node);
              return;
            }
            const isBranchNode = node.matches("[data-part=branch-control]");
            const keyMap2 = {
              ArrowDown(event2) {
                if (isModifierKey(event2)) return;
                event2.preventDefault();
                send({ type: "NODE.ARROW_DOWN", id: nodeId, shiftKey: event2.shiftKey });
              },
              ArrowUp(event2) {
                if (isModifierKey(event2)) return;
                event2.preventDefault();
                send({ type: "NODE.ARROW_UP", id: nodeId, shiftKey: event2.shiftKey });
              },
              ArrowLeft(event2) {
                if (isModifierKey(event2) || node.dataset.disabled) return;
                event2.preventDefault();
                send({ type: isBranchNode ? "BRANCH_NODE.ARROW_LEFT" : "NODE.ARROW_LEFT", id: nodeId });
              },
              ArrowRight(event2) {
                if (!isBranchNode || node.dataset.disabled) return;
                event2.preventDefault();
                send({ type: "BRANCH_NODE.ARROW_RIGHT", id: nodeId });
              },
              Home(event2) {
                if (isModifierKey(event2)) return;
                event2.preventDefault();
                send({ type: "NODE.HOME", id: nodeId, shiftKey: event2.shiftKey });
              },
              End(event2) {
                if (isModifierKey(event2)) return;
                event2.preventDefault();
                send({ type: "NODE.END", id: nodeId, shiftKey: event2.shiftKey });
              },
              Space(event2) {
                var _a;
                if (node.dataset.disabled) return;
                if (isTypingAhead) {
                  send({ type: "TREE.TYPEAHEAD", key: event2.key });
                } else {
                  (_a = keyMap2.Enter) == null ? void 0 : _a.call(keyMap2, event2);
                }
              },
              Enter(event2) {
                if (node.dataset.disabled) return;
                if (isAnchorElement(target) && isModifierKey(event2)) return;
                send({ type: isBranchNode ? "BRANCH_NODE.CLICK" : "NODE.CLICK", id: nodeId, src: "keyboard" });
                if (!isAnchorElement(target)) {
                  event2.preventDefault();
                }
              },
              "*"(event2) {
                if (node.dataset.disabled) return;
                event2.preventDefault();
                send({ type: "SIBLINGS.EXPAND", id: nodeId });
              },
              a(event2) {
                if (!event2.metaKey || node.dataset.disabled) return;
                event2.preventDefault();
                send({ type: "SELECTED.ALL", moveFocus: true });
              },
              F2(event2) {
                if (node.dataset.disabled) return;
                const canRenameFn = prop("canRename");
                if (!canRenameFn) return;
                const indexPath = collection22.getIndexPath(nodeId);
                if (indexPath) {
                  const node2 = collection22.at(indexPath);
                  if (node2 && !canRenameFn(node2, indexPath)) {
                    return;
                  }
                }
                event2.preventDefault();
                send({ type: "NODE.RENAME", value: nodeId });
              }
            };
            const key = getEventKey(event, { dir: prop("dir") });
            const exec = keyMap2[key];
            if (exec) {
              exec(event);
              return;
            }
            if (!getByTypeahead.isValidEvent(event)) return;
            send({ type: "TREE.TYPEAHEAD", key: event.key, id: nodeId });
            event.preventDefault();
          }
        }));
      },
      getNodeState,
      getItemProps(props22) {
        const nodeState = getNodeState(props22);
        return normalize.element(__spreadProps(__spreadValues({}, parts15.item.attrs), {
          id: nodeState.id,
          dir: prop("dir"),
          "data-ownedby": getTreeId(scope),
          "data-path": props22.indexPath.join("/"),
          "data-value": nodeState.value,
          tabIndex: nodeState.focused ? 0 : -1,
          "data-focus": dataAttr(nodeState.focused),
          role: "treeitem",
          "aria-current": nodeState.selected ? "true" : void 0,
          "aria-selected": nodeState.disabled ? void 0 : nodeState.selected,
          "data-selected": dataAttr(nodeState.selected),
          "aria-disabled": ariaAttr(nodeState.disabled),
          "data-disabled": dataAttr(nodeState.disabled),
          "data-renaming": dataAttr(nodeState.renaming),
          "aria-level": nodeState.depth,
          "data-depth": nodeState.depth,
          style: {
            "--depth": nodeState.depth
          },
          onFocus(event) {
            event.stopPropagation();
            send({ type: "NODE.FOCUS", id: nodeState.value });
          },
          onClick(event) {
            if (nodeState.disabled) return;
            if (!isLeftClick(event)) return;
            if (isAnchorElement(event.currentTarget) && isModifierKey(event)) return;
            const isMetaKey = event.metaKey || event.ctrlKey;
            send({ type: "NODE.CLICK", id: nodeState.value, shiftKey: event.shiftKey, ctrlKey: isMetaKey });
            event.stopPropagation();
            if (!isAnchorElement(event.currentTarget)) {
              event.preventDefault();
            }
          }
        }));
      },
      getItemTextProps(props22) {
        const itemState = getNodeState(props22);
        return normalize.element(__spreadProps(__spreadValues({}, parts15.itemText.attrs), {
          "data-disabled": dataAttr(itemState.disabled),
          "data-selected": dataAttr(itemState.selected),
          "data-focus": dataAttr(itemState.focused)
        }));
      },
      getItemIndicatorProps(props22) {
        const itemState = getNodeState(props22);
        return normalize.element(__spreadProps(__spreadValues({}, parts15.itemIndicator.attrs), {
          "aria-hidden": true,
          "data-disabled": dataAttr(itemState.disabled),
          "data-selected": dataAttr(itemState.selected),
          "data-focus": dataAttr(itemState.focused),
          hidden: !itemState.selected
        }));
      },
      getBranchProps(props22) {
        const nodeState = getNodeState(props22);
        return normalize.element(__spreadProps(__spreadValues({}, parts15.branch.attrs), {
          "data-depth": nodeState.depth,
          dir: prop("dir"),
          "data-branch": nodeState.value,
          role: "treeitem",
          "data-ownedby": getTreeId(scope),
          "data-value": nodeState.value,
          "aria-level": nodeState.depth,
          "aria-selected": nodeState.disabled ? void 0 : nodeState.selected,
          "data-path": props22.indexPath.join("/"),
          "data-selected": dataAttr(nodeState.selected),
          "aria-expanded": nodeState.expanded,
          "data-state": nodeState.expanded ? "open" : "closed",
          "aria-disabled": ariaAttr(nodeState.disabled),
          "data-disabled": dataAttr(nodeState.disabled),
          "data-loading": dataAttr(nodeState.loading),
          "aria-busy": ariaAttr(nodeState.loading),
          style: {
            "--depth": nodeState.depth
          }
        }));
      },
      getBranchIndicatorProps(props22) {
        const nodeState = getNodeState(props22);
        return normalize.element(__spreadProps(__spreadValues({}, parts15.branchIndicator.attrs), {
          "aria-hidden": true,
          "data-state": nodeState.expanded ? "open" : "closed",
          "data-disabled": dataAttr(nodeState.disabled),
          "data-selected": dataAttr(nodeState.selected),
          "data-focus": dataAttr(nodeState.focused),
          "data-loading": dataAttr(nodeState.loading)
        }));
      },
      getBranchTriggerProps(props22) {
        const nodeState = getNodeState(props22);
        return normalize.element(__spreadProps(__spreadValues({}, parts15.branchTrigger.attrs), {
          role: "button",
          dir: prop("dir"),
          "data-disabled": dataAttr(nodeState.disabled),
          "data-state": nodeState.expanded ? "open" : "closed",
          "data-value": nodeState.value,
          "data-loading": dataAttr(nodeState.loading),
          disabled: nodeState.loading,
          onClick(event) {
            if (nodeState.disabled || nodeState.loading) return;
            send({ type: "BRANCH_TOGGLE.CLICK", id: nodeState.value });
            event.stopPropagation();
          }
        }));
      },
      getBranchControlProps(props22) {
        const nodeState = getNodeState(props22);
        return normalize.element(__spreadProps(__spreadValues({}, parts15.branchControl.attrs), {
          role: "button",
          id: nodeState.id,
          dir: prop("dir"),
          tabIndex: nodeState.focused ? 0 : -1,
          "data-path": props22.indexPath.join("/"),
          "data-state": nodeState.expanded ? "open" : "closed",
          "data-disabled": dataAttr(nodeState.disabled),
          "data-selected": dataAttr(nodeState.selected),
          "data-focus": dataAttr(nodeState.focused),
          "data-renaming": dataAttr(nodeState.renaming),
          "data-value": nodeState.value,
          "data-depth": nodeState.depth,
          "data-loading": dataAttr(nodeState.loading),
          "aria-busy": ariaAttr(nodeState.loading),
          onFocus(event) {
            send({ type: "NODE.FOCUS", id: nodeState.value });
            event.stopPropagation();
          },
          onClick(event) {
            if (nodeState.disabled) return;
            if (nodeState.loading) return;
            if (!isLeftClick(event)) return;
            if (isAnchorElement(event.currentTarget) && isModifierKey(event)) return;
            const isMetaKey = event.metaKey || event.ctrlKey;
            send({ type: "BRANCH_NODE.CLICK", id: nodeState.value, shiftKey: event.shiftKey, ctrlKey: isMetaKey });
            event.stopPropagation();
          }
        }));
      },
      getBranchTextProps(props22) {
        const nodeState = getNodeState(props22);
        return normalize.element(__spreadProps(__spreadValues({}, parts15.branchText.attrs), {
          dir: prop("dir"),
          "data-disabled": dataAttr(nodeState.disabled),
          "data-state": nodeState.expanded ? "open" : "closed",
          "data-loading": dataAttr(nodeState.loading)
        }));
      },
      getBranchContentProps(props22) {
        const nodeState = getNodeState(props22);
        return normalize.element(__spreadProps(__spreadValues({}, parts15.branchContent.attrs), {
          role: "group",
          dir: prop("dir"),
          "data-state": nodeState.expanded ? "open" : "closed",
          "data-depth": nodeState.depth,
          "data-path": props22.indexPath.join("/"),
          "data-value": nodeState.value,
          hidden: !nodeState.expanded
        }));
      },
      getBranchIndentGuideProps(props22) {
        const nodeState = getNodeState(props22);
        return normalize.element(__spreadProps(__spreadValues({}, parts15.branchIndentGuide.attrs), {
          "data-depth": nodeState.depth
        }));
      },
      getNodeCheckboxProps(props22) {
        const nodeState = getNodeState(props22);
        const checkedState = nodeState.checked;
        return normalize.element(__spreadProps(__spreadValues({}, parts15.nodeCheckbox.attrs), {
          tabIndex: -1,
          role: "checkbox",
          "data-state": checkedState === true ? "checked" : checkedState === false ? "unchecked" : "indeterminate",
          "aria-checked": checkedState === true ? "true" : checkedState === false ? "false" : "mixed",
          "data-disabled": dataAttr(nodeState.disabled),
          onClick(event) {
            if (event.defaultPrevented) return;
            if (nodeState.disabled) return;
            if (!isLeftClick(event)) return;
            send({ type: "CHECKED.TOGGLE", value: nodeState.value, isBranch: nodeState.isBranch });
            event.stopPropagation();
            const node = event.currentTarget.closest("[role=treeitem]");
            node == null ? void 0 : node.focus({ preventScroll: true });
          }
        }));
      },
      getNodeRenameInputProps(props22) {
        const nodeState = getNodeState(props22);
        return normalize.input(__spreadProps(__spreadValues({}, parts15.nodeRenameInput.attrs), {
          id: getRenameInputId(scope, nodeState.value),
          type: "text",
          "aria-label": "Rename tree item",
          hidden: !nodeState.renaming,
          onKeyDown(event) {
            if (isComposingEvent(event)) return;
            if (event.key === "Escape") {
              send({ type: "RENAME.CANCEL" });
              event.preventDefault();
            }
            if (event.key === "Enter") {
              send({ type: "RENAME.SUBMIT", label: event.currentTarget.value });
              event.preventDefault();
            }
            event.stopPropagation();
          },
          onBlur(event) {
            send({ type: "RENAME.SUBMIT", label: event.currentTarget.value });
          }
        }));
      }
    };
  }
  function expandBranches(params, values) {
    const { context, prop, refs } = params;
    if (!prop("loadChildren")) {
      context.set("expandedValue", (prev2) => uniq(add(prev2, ...values)));
      return;
    }
    const loadingStatus = context.get("loadingStatus");
    const [loadedValues, loadingValues] = partition(values, (value) => loadingStatus[value] === "loaded");
    if (loadedValues.length > 0) {
      context.set("expandedValue", (prev2) => uniq(add(prev2, ...loadedValues)));
    }
    if (loadingValues.length === 0) return;
    const collection22 = prop("collection");
    const [nodeWithChildren, nodeWithoutChildren] = partition(loadingValues, (id) => {
      const node = collection22.findNode(id);
      return collection22.getNodeChildren(node).length > 0;
    });
    if (nodeWithChildren.length > 0) {
      context.set("expandedValue", (prev2) => uniq(add(prev2, ...nodeWithChildren)));
    }
    if (nodeWithoutChildren.length === 0) return;
    context.set("loadingStatus", (prev2) => __spreadValues(__spreadValues({}, prev2), nodeWithoutChildren.reduce((acc, id) => __spreadProps(__spreadValues({}, acc), { [id]: "loading" }), {})));
    const nodesToLoad = nodeWithoutChildren.map((id) => {
      const indexPath = collection22.getIndexPath(id);
      const valuePath = collection22.getValuePath(indexPath);
      const node = collection22.findNode(id);
      return { id, indexPath, valuePath, node };
    });
    const pendingAborts = refs.get("pendingAborts");
    const loadChildren = prop("loadChildren");
    ensure(loadChildren, () => "[zag-js/tree-view] `loadChildren` is required for async expansion");
    const proms = nodesToLoad.map(({ id, indexPath, valuePath, node }) => {
      const existingAbort = pendingAborts.get(id);
      if (existingAbort) {
        existingAbort.abort();
        pendingAborts.delete(id);
      }
      const abortController = new AbortController();
      pendingAborts.set(id, abortController);
      return loadChildren({
        valuePath,
        indexPath,
        node,
        signal: abortController.signal
      });
    });
    Promise.allSettled(proms).then((results) => {
      var _a, _b;
      const loadedValues2 = [];
      const nodeWithErrors = [];
      const nextLoadingStatus = context.get("loadingStatus");
      let collection32 = prop("collection");
      results.forEach((result, index) => {
        const { id, indexPath, node, valuePath } = nodesToLoad[index];
        if (result.status === "fulfilled") {
          nextLoadingStatus[id] = "loaded";
          loadedValues2.push(id);
          collection32 = collection32.replace(indexPath, __spreadProps(__spreadValues({}, node), { children: result.value }));
        } else {
          pendingAborts.delete(id);
          Reflect.deleteProperty(nextLoadingStatus, id);
          nodeWithErrors.push({ node, error: result.reason, indexPath, valuePath });
        }
      });
      context.set("loadingStatus", nextLoadingStatus);
      if (loadedValues2.length) {
        context.set("expandedValue", (prev2) => uniq(add(prev2, ...loadedValues2)));
        (_a = prop("onLoadChildrenComplete")) == null ? void 0 : _a({ collection: collection32 });
      }
      if (nodeWithErrors.length) {
        (_b = prop("onLoadChildrenError")) == null ? void 0 : _b({ nodes: nodeWithErrors });
      }
    });
  }
  function skipFn(params) {
    const { prop, context } = params;
    return function skip({ indexPath }) {
      const paths = prop("collection").getValuePath(indexPath).slice(0, -1);
      return paths.some((value) => !context.get("expandedValue").includes(value));
    };
  }
  function scrollToNode(params, value) {
    const { prop, scope, computed } = params;
    const scrollToIndexFn = prop("scrollToIndexFn");
    if (!scrollToIndexFn) return false;
    const collection22 = prop("collection");
    const visibleNodes = computed("visibleNodes");
    for (let i2 = 0; i2 < visibleNodes.length; i2++) {
      const { node, indexPath } = visibleNodes[i2];
      if (collection22.getNodeValue(node) !== value) continue;
      scrollToIndexFn({
        index: i2,
        node,
        indexPath,
        getElement: () => scope.getById(getNodeId(scope, value))
      });
      return true;
    }
    return false;
  }
  function buildTreeFromDOM(rootEl) {
    var _a;
    const selector = '[data-scope="tree-view"][data-part="branch"], [data-scope="tree-view"][data-part="item"]';
    const elements = rootEl.querySelectorAll(selector);
    const nodes = [];
    for (const el of elements) {
      const pathRaw = el.getAttribute("data-path");
      const value = el.getAttribute("data-value");
      if (pathRaw == null || value == null) continue;
      const pathArr = pathRaw.split("/").map((s2) => parseInt(s2, 10));
      if (pathArr.some(Number.isNaN)) continue;
      const name = (_a = el.getAttribute("data-name")) != null ? _a : value;
      const isBranch = el.getAttribute("data-part") === "branch";
      nodes.push({ pathArr, id: value, name, isBranch });
    }
    nodes.sort((a2, b2) => {
      const len = Math.min(a2.pathArr.length, b2.pathArr.length);
      for (let i2 = 0; i2 < len; i2++) {
        if (a2.pathArr[i2] !== b2.pathArr[i2]) return a2.pathArr[i2] - b2.pathArr[i2];
      }
      return a2.pathArr.length - b2.pathArr.length;
    });
    const root = { id: "ROOT", name: "", children: [] };
    for (const { pathArr, id, name, isBranch } of nodes) {
      let parent = root;
      for (let i2 = 0; i2 < pathArr.length - 1; i2++) {
        const idx = pathArr[i2];
        if (!parent.children) parent.children = [];
        parent = parent.children[idx];
      }
      const lastIdx = pathArr[pathArr.length - 1];
      if (!parent.children) parent.children = [];
      parent.children[lastIdx] = isBranch ? { id, name, children: [] } : { id, name };
    }
    return root;
  }
  var anatomy15, parts15, collection3, getRootId13, getLabelId8, getNodeId, getTreeId, focusNode, getRenameInputId, getRenameInputEl, and8, machine15, props14, splitProps14, itemProps6, splitItemProps6, TreeView, TreeViewHook;
  var init_tree_view = __esm({
    "../priv/static/tree-view.mjs"() {
      "use strict";
      init_chunk_2DWEYSRA();
      init_chunk_GFGFZBBD();
      anatomy15 = createAnatomy("tree-view").parts(
        "branch",
        "branchContent",
        "branchControl",
        "branchIndentGuide",
        "branchIndicator",
        "branchText",
        "branchTrigger",
        "item",
        "itemIndicator",
        "itemText",
        "label",
        "nodeCheckbox",
        "nodeRenameInput",
        "root",
        "tree"
      );
      parts15 = anatomy15.build();
      collection3 = (options) => {
        return new TreeCollection(options);
      };
      collection3.empty = () => {
        return new TreeCollection({ rootNode: { children: [] } });
      };
      getRootId13 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.root) != null ? _b : `tree:${ctx.id}:root`;
      };
      getLabelId8 = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.label) != null ? _b : `tree:${ctx.id}:label`;
      };
      getNodeId = (ctx, value) => {
        var _a, _b, _c;
        return (_c = (_b = (_a = ctx.ids) == null ? void 0 : _a.node) == null ? void 0 : _b.call(_a, value)) != null ? _c : `tree:${ctx.id}:node:${value}`;
      };
      getTreeId = (ctx) => {
        var _a, _b;
        return (_b = (_a = ctx.ids) == null ? void 0 : _a.tree) != null ? _b : `tree:${ctx.id}:tree`;
      };
      focusNode = (ctx, value) => {
        var _a;
        if (value == null) return;
        (_a = ctx.getById(getNodeId(ctx, value))) == null ? void 0 : _a.focus();
      };
      getRenameInputId = (ctx, value) => `tree:${ctx.id}:rename-input:${value}`;
      getRenameInputEl = (ctx, value) => {
        return ctx.getById(getRenameInputId(ctx, value));
      };
      ({ and: and8 } = createGuards());
      machine15 = createMachine({
        props({ props: props22 }) {
          return __spreadValues({
            selectionMode: "single",
            collection: collection3.empty(),
            typeahead: true,
            expandOnClick: true,
            defaultExpandedValue: [],
            defaultSelectedValue: []
          }, props22);
        },
        initialState() {
          return "idle";
        },
        context({ prop, bindable: bindable2, getContext }) {
          return {
            expandedValue: bindable2(() => ({
              defaultValue: prop("defaultExpandedValue"),
              value: prop("expandedValue"),
              isEqual: isEqual2,
              onChange(expandedValue) {
                var _a;
                const ctx = getContext();
                const focusedValue = ctx.get("focusedValue");
                (_a = prop("onExpandedChange")) == null ? void 0 : _a({
                  expandedValue,
                  focusedValue,
                  get expandedNodes() {
                    return prop("collection").findNodes(expandedValue);
                  }
                });
              }
            })),
            selectedValue: bindable2(() => ({
              defaultValue: prop("defaultSelectedValue"),
              value: prop("selectedValue"),
              isEqual: isEqual2,
              onChange(selectedValue) {
                var _a;
                const ctx = getContext();
                const focusedValue = ctx.get("focusedValue");
                (_a = prop("onSelectionChange")) == null ? void 0 : _a({
                  selectedValue,
                  focusedValue,
                  get selectedNodes() {
                    return prop("collection").findNodes(selectedValue);
                  }
                });
              }
            })),
            focusedValue: bindable2(() => ({
              defaultValue: prop("defaultFocusedValue") || null,
              value: prop("focusedValue"),
              onChange(focusedValue) {
                var _a;
                (_a = prop("onFocusChange")) == null ? void 0 : _a({
                  focusedValue,
                  get focusedNode() {
                    return focusedValue ? prop("collection").findNode(focusedValue) : null;
                  }
                });
              }
            })),
            loadingStatus: bindable2(() => ({
              defaultValue: {}
            })),
            checkedValue: bindable2(() => ({
              defaultValue: prop("defaultCheckedValue") || [],
              value: prop("checkedValue"),
              isEqual: isEqual2,
              onChange(value) {
                var _a;
                (_a = prop("onCheckedChange")) == null ? void 0 : _a({ checkedValue: value });
              }
            })),
            renamingValue: bindable2(() => ({
              sync: true,
              defaultValue: null
            }))
          };
        },
        refs() {
          return {
            typeaheadState: __spreadValues({}, getByTypeahead.defaultOptions),
            pendingAborts: /* @__PURE__ */ new Map()
          };
        },
        computed: {
          isMultipleSelection: ({ prop }) => prop("selectionMode") === "multiple",
          isTypingAhead: ({ refs }) => refs.get("typeaheadState").keysSoFar.length > 0,
          visibleNodes: ({ prop, context }) => {
            const nodes = [];
            prop("collection").visit({
              skip: skipFn({ prop, context }),
              onEnter: (node, indexPath) => {
                nodes.push({ node, indexPath });
              }
            });
            return nodes;
          }
        },
        on: {
          "EXPANDED.SET": {
            actions: ["setExpanded"]
          },
          "EXPANDED.CLEAR": {
            actions: ["clearExpanded"]
          },
          "EXPANDED.ALL": {
            actions: ["expandAllBranches"]
          },
          "BRANCH.EXPAND": {
            actions: ["expandBranches"]
          },
          "BRANCH.COLLAPSE": {
            actions: ["collapseBranches"]
          },
          "SELECTED.SET": {
            actions: ["setSelected"]
          },
          "SELECTED.ALL": [
            {
              guard: and8("isMultipleSelection", "moveFocus"),
              actions: ["selectAllNodes", "focusTreeLastNode"]
            },
            {
              guard: "isMultipleSelection",
              actions: ["selectAllNodes"]
            }
          ],
          "SELECTED.CLEAR": {
            actions: ["clearSelected"]
          },
          "NODE.SELECT": {
            actions: ["selectNode"]
          },
          "NODE.DESELECT": {
            actions: ["deselectNode"]
          },
          "CHECKED.TOGGLE": {
            actions: ["toggleChecked"]
          },
          "CHECKED.SET": {
            actions: ["setChecked"]
          },
          "CHECKED.CLEAR": {
            actions: ["clearChecked"]
          },
          "NODE.FOCUS": {
            actions: ["setFocusedNode"]
          },
          "NODE.ARROW_DOWN": [
            {
              guard: and8("isShiftKey", "isMultipleSelection"),
              actions: ["focusTreeNextNode", "extendSelectionToNextNode"]
            },
            {
              actions: ["focusTreeNextNode"]
            }
          ],
          "NODE.ARROW_UP": [
            {
              guard: and8("isShiftKey", "isMultipleSelection"),
              actions: ["focusTreePrevNode", "extendSelectionToPrevNode"]
            },
            {
              actions: ["focusTreePrevNode"]
            }
          ],
          "NODE.ARROW_LEFT": {
            actions: ["focusBranchNode"]
          },
          "BRANCH_NODE.ARROW_LEFT": [
            {
              guard: "isBranchExpanded",
              actions: ["collapseBranch"]
            },
            {
              actions: ["focusBranchNode"]
            }
          ],
          "BRANCH_NODE.ARROW_RIGHT": [
            {
              guard: and8("isBranchFocused", "isBranchExpanded"),
              actions: ["focusBranchFirstNode"]
            },
            {
              actions: ["expandBranch"]
            }
          ],
          "SIBLINGS.EXPAND": {
            actions: ["expandSiblingBranches"]
          },
          "NODE.HOME": [
            {
              guard: and8("isShiftKey", "isMultipleSelection"),
              actions: ["extendSelectionToFirstNode", "focusTreeFirstNode"]
            },
            {
              actions: ["focusTreeFirstNode"]
            }
          ],
          "NODE.END": [
            {
              guard: and8("isShiftKey", "isMultipleSelection"),
              actions: ["extendSelectionToLastNode", "focusTreeLastNode"]
            },
            {
              actions: ["focusTreeLastNode"]
            }
          ],
          "NODE.CLICK": [
            {
              guard: and8("isCtrlKey", "isMultipleSelection"),
              actions: ["toggleNodeSelection"]
            },
            {
              guard: and8("isShiftKey", "isMultipleSelection"),
              actions: ["extendSelectionToNode"]
            },
            {
              actions: ["selectNode"]
            }
          ],
          "BRANCH_NODE.CLICK": [
            {
              guard: and8("isCtrlKey", "isMultipleSelection"),
              actions: ["toggleNodeSelection"]
            },
            {
              guard: and8("isShiftKey", "isMultipleSelection"),
              actions: ["extendSelectionToNode"]
            },
            {
              guard: "expandOnClick",
              actions: ["selectNode", "toggleBranchNode"]
            },
            {
              actions: ["selectNode"]
            }
          ],
          "BRANCH_TOGGLE.CLICK": {
            actions: ["toggleBranchNode"]
          },
          "TREE.TYPEAHEAD": {
            actions: ["focusMatchedNode"]
          }
        },
        exit: ["clearPendingAborts"],
        states: {
          idle: {
            on: {
              "NODE.RENAME": {
                target: "renaming",
                actions: ["setRenamingValue"]
              }
            }
          },
          renaming: {
            entry: ["syncRenameInput", "focusRenameInput"],
            on: {
              "RENAME.SUBMIT": {
                guard: "isRenameLabelValid",
                target: "idle",
                actions: ["submitRenaming"]
              },
              "RENAME.CANCEL": {
                target: "idle",
                actions: ["cancelRenaming"]
              }
            }
          }
        },
        implementations: {
          guards: {
            isBranchFocused: ({ context, event }) => context.get("focusedValue") === event.id,
            isBranchExpanded: ({ context, event }) => context.get("expandedValue").includes(event.id),
            isShiftKey: ({ event }) => event.shiftKey,
            isCtrlKey: ({ event }) => event.ctrlKey,
            hasSelectedItems: ({ context }) => context.get("selectedValue").length > 0,
            isMultipleSelection: ({ prop }) => prop("selectionMode") === "multiple",
            moveFocus: ({ event }) => !!event.moveFocus,
            expandOnClick: ({ prop }) => !!prop("expandOnClick"),
            isRenameLabelValid: ({ event }) => event.label.trim() !== ""
          },
          actions: {
            selectNode({ context, event }) {
              const value = event.id || event.value;
              context.set("selectedValue", (prev2) => {
                if (value == null) return prev2;
                if (!event.isTrusted && isArray(value)) return prev2.concat(...value);
                return [isArray(value) ? last(value) : value].filter(Boolean);
              });
            },
            deselectNode({ context, event }) {
              const value = toArray(event.id || event.value);
              context.set("selectedValue", (prev2) => remove(prev2, ...value));
            },
            setFocusedNode({ context, event }) {
              context.set("focusedValue", event.id);
            },
            clearFocusedNode({ context }) {
              context.set("focusedValue", null);
            },
            clearSelectedItem({ context }) {
              context.set("selectedValue", []);
            },
            toggleBranchNode({ context, event, action }) {
              const isExpanded = context.get("expandedValue").includes(event.id);
              action(isExpanded ? ["collapseBranch"] : ["expandBranch"]);
            },
            expandBranch(params) {
              const { event } = params;
              expandBranches(params, [event.id]);
            },
            expandBranches(params) {
              const { context, event } = params;
              const valuesToExpand = toArray(event.value);
              expandBranches(params, diff(valuesToExpand, context.get("expandedValue")));
            },
            collapseBranch({ context, event }) {
              context.set("expandedValue", (prev2) => remove(prev2, event.id));
            },
            collapseBranches(params) {
              const { context, event } = params;
              const value = toArray(event.value);
              context.set("expandedValue", (prev2) => remove(prev2, ...value));
            },
            setExpanded({ context, event }) {
              if (!isArray(event.value)) return;
              context.set("expandedValue", event.value);
            },
            clearExpanded({ context }) {
              context.set("expandedValue", []);
            },
            setSelected({ context, event }) {
              if (!isArray(event.value)) return;
              context.set("selectedValue", event.value);
            },
            clearSelected({ context }) {
              context.set("selectedValue", []);
            },
            focusTreeFirstNode(params) {
              const { prop, scope } = params;
              const collection22 = prop("collection");
              const firstNode = collection22.getFirstNode(void 0, { skip: skipFn(params) });
              if (!firstNode) return;
              const firstValue = collection22.getNodeValue(firstNode);
              const scrolled = scrollToNode(params, firstValue);
              if (scrolled) raf(() => focusNode(scope, firstValue));
              else focusNode(scope, firstValue);
            },
            focusTreeLastNode(params) {
              const { prop, scope } = params;
              const collection22 = prop("collection");
              const lastNode = collection22.getLastNode(void 0, { skip: skipFn(params) });
              const lastValue = collection22.getNodeValue(lastNode);
              const scrolled = scrollToNode(params, lastValue);
              if (scrolled) raf(() => focusNode(scope, lastValue));
              else focusNode(scope, lastValue);
            },
            focusBranchFirstNode(params) {
              const { event, prop, scope } = params;
              const collection22 = prop("collection");
              const branchNode = collection22.findNode(event.id);
              const firstNode = collection22.getFirstNode(branchNode, { skip: skipFn(params) });
              if (!firstNode) return;
              const firstValue = collection22.getNodeValue(firstNode);
              const scrolled = scrollToNode(params, firstValue);
              if (scrolled) raf(() => focusNode(scope, firstValue));
              else focusNode(scope, firstValue);
            },
            focusTreeNextNode(params) {
              const { event, prop, scope } = params;
              const collection22 = prop("collection");
              const nextNode = collection22.getNextNode(event.id, { skip: skipFn(params) });
              if (!nextNode) return;
              const nextValue = collection22.getNodeValue(nextNode);
              const scrolled = scrollToNode(params, nextValue);
              if (scrolled) raf(() => focusNode(scope, nextValue));
              else focusNode(scope, nextValue);
            },
            focusTreePrevNode(params) {
              const { event, prop, scope } = params;
              const collection22 = prop("collection");
              const prevNode = collection22.getPreviousNode(event.id, { skip: skipFn(params) });
              if (!prevNode) return;
              const prevValue = collection22.getNodeValue(prevNode);
              const scrolled = scrollToNode(params, prevValue);
              if (scrolled) raf(() => focusNode(scope, prevValue));
              else focusNode(scope, prevValue);
            },
            focusBranchNode(params) {
              const { event, prop, scope } = params;
              const collection22 = prop("collection");
              const parentNode = collection22.getParentNode(event.id);
              const parentValue = parentNode ? collection22.getNodeValue(parentNode) : void 0;
              if (!parentValue) return;
              const scrolled = scrollToNode(params, parentValue);
              if (scrolled) raf(() => focusNode(scope, parentValue));
              else focusNode(scope, parentValue);
            },
            selectAllNodes({ context, prop }) {
              context.set("selectedValue", prop("collection").getValues());
            },
            focusMatchedNode(params) {
              const { context, prop, refs, event, scope, computed } = params;
              const nodes = computed("visibleNodes");
              const elements = nodes.map(({ node: node2 }) => ({
                textContent: prop("collection").stringifyNode(node2),
                id: prop("collection").getNodeValue(node2)
              }));
              const node = getByTypeahead(elements, {
                state: refs.get("typeaheadState"),
                activeId: context.get("focusedValue"),
                key: event.key
              });
              if (!(node == null ? void 0 : node.id)) return;
              const scrolled = scrollToNode(params, node.id);
              if (scrolled) raf(() => focusNode(scope, node.id));
              else focusNode(scope, node.id);
            },
            toggleNodeSelection({ context, event }) {
              const selectedValue = addOrRemove(context.get("selectedValue"), event.id);
              context.set("selectedValue", selectedValue);
            },
            expandAllBranches(params) {
              const { context, prop } = params;
              const branchValues = prop("collection").getBranchValues();
              const valuesToExpand = diff(branchValues, context.get("expandedValue"));
              expandBranches(params, valuesToExpand);
            },
            expandSiblingBranches(params) {
              const { context, event, prop } = params;
              const collection22 = prop("collection");
              const indexPath = collection22.getIndexPath(event.id);
              if (!indexPath) return;
              const nodes = collection22.getSiblingNodes(indexPath);
              const values = nodes.map((node) => collection22.getNodeValue(node));
              const valuesToExpand = diff(values, context.get("expandedValue"));
              expandBranches(params, valuesToExpand);
            },
            extendSelectionToNode(params) {
              const { context, event, prop, computed } = params;
              const collection22 = prop("collection");
              const anchorValue = first(context.get("selectedValue")) || collection22.getNodeValue(collection22.getFirstNode());
              const targetValue = event.id;
              let values = [anchorValue, targetValue];
              let hits = 0;
              const visibleNodes = computed("visibleNodes");
              visibleNodes.forEach(({ node }) => {
                const nodeValue = collection22.getNodeValue(node);
                if (hits === 1) values.push(nodeValue);
                if (nodeValue === anchorValue || nodeValue === targetValue) hits++;
              });
              context.set("selectedValue", uniq(values));
            },
            extendSelectionToNextNode(params) {
              const { context, event, prop } = params;
              const collection22 = prop("collection");
              const nextNode = collection22.getNextNode(event.id, { skip: skipFn(params) });
              if (!nextNode) return;
              const values = new Set(context.get("selectedValue"));
              const nextValue = collection22.getNodeValue(nextNode);
              if (nextValue == null) return;
              if (values.has(event.id) && values.has(nextValue)) {
                values.delete(event.id);
              } else if (!values.has(nextValue)) {
                values.add(nextValue);
              }
              context.set("selectedValue", Array.from(values));
            },
            extendSelectionToPrevNode(params) {
              const { context, event, prop } = params;
              const collection22 = prop("collection");
              const prevNode = collection22.getPreviousNode(event.id, { skip: skipFn(params) });
              if (!prevNode) return;
              const values = new Set(context.get("selectedValue"));
              const prevValue = collection22.getNodeValue(prevNode);
              if (prevValue == null) return;
              if (values.has(event.id) && values.has(prevValue)) {
                values.delete(event.id);
              } else if (!values.has(prevValue)) {
                values.add(prevValue);
              }
              context.set("selectedValue", Array.from(values));
            },
            extendSelectionToFirstNode(params) {
              const { context, prop } = params;
              const collection22 = prop("collection");
              const currentSelection = first(context.get("selectedValue"));
              const values = [];
              collection22.visit({
                skip: skipFn(params),
                onEnter: (node) => {
                  const nodeValue = collection22.getNodeValue(node);
                  values.push(nodeValue);
                  if (nodeValue === currentSelection) {
                    return "stop";
                  }
                }
              });
              context.set("selectedValue", values);
            },
            extendSelectionToLastNode(params) {
              const { context, prop } = params;
              const collection22 = prop("collection");
              const currentSelection = first(context.get("selectedValue"));
              const values = [];
              let current = false;
              collection22.visit({
                skip: skipFn(params),
                onEnter: (node) => {
                  const nodeValue = collection22.getNodeValue(node);
                  if (nodeValue === currentSelection) current = true;
                  if (current) values.push(nodeValue);
                }
              });
              context.set("selectedValue", values);
            },
            clearPendingAborts({ refs }) {
              const aborts = refs.get("pendingAborts");
              aborts.forEach((abort) => abort.abort());
              aborts.clear();
            },
            toggleChecked({ context, event, prop }) {
              const collection22 = prop("collection");
              context.set(
                "checkedValue",
                (prev2) => event.isBranch ? toggleBranchChecked(collection22, event.value, prev2) : addOrRemove(prev2, event.value)
              );
            },
            setChecked({ context, event }) {
              context.set("checkedValue", event.value);
            },
            clearChecked({ context }) {
              context.set("checkedValue", []);
            },
            setRenamingValue({ context, event, prop }) {
              context.set("renamingValue", event.value);
              const onRenameStartFn = prop("onRenameStart");
              if (onRenameStartFn) {
                const collection22 = prop("collection");
                const indexPath = collection22.getIndexPath(event.value);
                if (indexPath) {
                  const node = collection22.at(indexPath);
                  if (node) {
                    onRenameStartFn({
                      value: event.value,
                      node,
                      indexPath
                    });
                  }
                }
              }
            },
            submitRenaming({ context, event, prop, scope }) {
              var _a;
              const renamingValue = context.get("renamingValue");
              if (!renamingValue) return;
              const collection22 = prop("collection");
              const indexPath = collection22.getIndexPath(renamingValue);
              if (!indexPath) return;
              const trimmedLabel = event.label.trim();
              const onBeforeRenameFn = prop("onBeforeRename");
              if (onBeforeRenameFn) {
                const details = {
                  value: renamingValue,
                  label: trimmedLabel,
                  indexPath
                };
                const shouldRename = onBeforeRenameFn(details);
                if (!shouldRename) {
                  context.set("renamingValue", null);
                  focusNode(scope, renamingValue);
                  return;
                }
              }
              (_a = prop("onRenameComplete")) == null ? void 0 : _a({
                value: renamingValue,
                label: trimmedLabel,
                indexPath
              });
              context.set("renamingValue", null);
              focusNode(scope, renamingValue);
            },
            cancelRenaming({ context, scope }) {
              const renamingValue = context.get("renamingValue");
              context.set("renamingValue", null);
              if (renamingValue) {
                focusNode(scope, renamingValue);
              }
            },
            syncRenameInput({ context, scope, prop }) {
              const renamingValue = context.get("renamingValue");
              if (!renamingValue) return;
              const collection22 = prop("collection");
              const node = collection22.findNode(renamingValue);
              if (!node) return;
              const label = collection22.stringifyNode(node);
              const inputEl = getRenameInputEl(scope, renamingValue);
              setElementValue(inputEl, label);
            },
            focusRenameInput({ context, scope }) {
              const renamingValue = context.get("renamingValue");
              if (!renamingValue) return;
              const inputEl = getRenameInputEl(scope, renamingValue);
              if (!inputEl) return;
              inputEl.focus();
              inputEl.select();
            }
          }
        }
      });
      props14 = createProps()([
        "ids",
        "collection",
        "dir",
        "expandedValue",
        "expandOnClick",
        "defaultFocusedValue",
        "focusedValue",
        "getRootNode",
        "id",
        "onExpandedChange",
        "onFocusChange",
        "onSelectionChange",
        "checkedValue",
        "selectedValue",
        "selectionMode",
        "typeahead",
        "defaultExpandedValue",
        "defaultSelectedValue",
        "defaultCheckedValue",
        "onCheckedChange",
        "onLoadChildrenComplete",
        "onLoadChildrenError",
        "loadChildren",
        "canRename",
        "onRenameStart",
        "onBeforeRename",
        "onRenameComplete",
        "scrollToIndexFn"
      ]);
      splitProps14 = createSplitProps(props14);
      itemProps6 = createProps()(["node", "indexPath"]);
      splitItemProps6 = createSplitProps(itemProps6);
      TreeView = class extends Component {
        constructor(el, props22) {
          var _a;
          const treeData = (_a = props22.treeData) != null ? _a : buildTreeFromDOM(el);
          const collection22 = collection3({
            nodeToValue: (node) => node.id,
            nodeToString: (node) => node.name,
            rootNode: treeData
          });
          super(el, __spreadProps(__spreadValues({}, props22), { collection: collection22 }));
          __publicField(this, "collection");
          __publicField(this, "syncTree", () => {
            const treeEl = this.el.querySelector(
              '[data-scope="tree-view"][data-part="tree"]'
            );
            if (!treeEl) return;
            this.spreadProps(treeEl, this.api.getTreeProps());
            this.updateExistingTree(treeEl);
          });
          this.collection = collection22;
        }
        initMachine(props22) {
          return new VanillaMachine(machine15, __spreadValues({}, props22));
        }
        initApi() {
          return connect15(this.machine.service, normalizeProps);
        }
        getNodeAt(indexPath) {
          var _a;
          if (indexPath.length === 0) return void 0;
          let current = this.collection.rootNode;
          for (const i2 of indexPath) {
            current = (_a = current == null ? void 0 : current.children) == null ? void 0 : _a[i2];
            if (!current) return void 0;
          }
          return current;
        }
        updateExistingTree(treeEl) {
          this.spreadProps(treeEl, this.api.getTreeProps());
          const branches = treeEl.querySelectorAll(
            '[data-scope="tree-view"][data-part="branch"]'
          );
          for (const branchEl of branches) {
            const pathRaw = branchEl.getAttribute("data-path");
            if (pathRaw == null) continue;
            const indexPath = pathRaw.split("/").map((s2) => parseInt(s2, 10));
            const node = this.getNodeAt(indexPath);
            if (!node) continue;
            const nodeProps = { indexPath, node };
            this.spreadProps(branchEl, this.api.getBranchProps(nodeProps));
            const controlEl = branchEl.querySelector(
              '[data-scope="tree-view"][data-part="branch-control"]'
            );
            if (controlEl) this.spreadProps(controlEl, this.api.getBranchControlProps(nodeProps));
            const textEl = branchEl.querySelector(
              '[data-scope="tree-view"][data-part="branch-text"]'
            );
            if (textEl) this.spreadProps(textEl, this.api.getBranchTextProps(nodeProps));
            const indicatorEl = branchEl.querySelector(
              '[data-scope="tree-view"][data-part="branch-indicator"]'
            );
            if (indicatorEl)
              this.spreadProps(indicatorEl, this.api.getBranchIndicatorProps(nodeProps));
            const contentEl = branchEl.querySelector(
              '[data-scope="tree-view"][data-part="branch-content"]'
            );
            if (contentEl) this.spreadProps(contentEl, this.api.getBranchContentProps(nodeProps));
            const indentGuideEl = branchEl.querySelector(
              '[data-scope="tree-view"][data-part="branch-indent-guide"]'
            );
            if (indentGuideEl)
              this.spreadProps(indentGuideEl, this.api.getBranchIndentGuideProps(nodeProps));
          }
          const items = treeEl.querySelectorAll(
            '[data-scope="tree-view"][data-part="item"]'
          );
          for (const itemEl of items) {
            const pathRaw = itemEl.getAttribute("data-path");
            if (pathRaw == null) continue;
            const indexPath = pathRaw.split("/").map((s2) => parseInt(s2, 10));
            const node = this.getNodeAt(indexPath);
            if (!node) continue;
            const nodeProps = { indexPath, node };
            this.spreadProps(itemEl, this.api.getItemProps(nodeProps));
          }
        }
        render() {
          var _a;
          const rootEl = (_a = this.el.querySelector(
            '[data-scope="tree-view"][data-part="root"]'
          )) != null ? _a : this.el;
          this.spreadProps(rootEl, this.api.getRootProps());
          const label = this.el.querySelector(
            '[data-scope="tree-view"][data-part="label"]'
          );
          if (label) this.spreadProps(label, this.api.getLabelProps());
          this.syncTree();
        }
      };
      TreeViewHook = {
        mounted() {
          var _a;
          const el = this.el;
          const pushEvent = this.pushEvent.bind(this);
          const treeView = new TreeView(el, __spreadProps(__spreadValues({
            id: el.id
          }, getBoolean(el, "controlled") ? {
            expandedValue: getStringList(el, "expandedValue"),
            selectedValue: getStringList(el, "selectedValue")
          } : {
            defaultExpandedValue: getStringList(el, "defaultExpandedValue"),
            defaultSelectedValue: getStringList(el, "defaultSelectedValue")
          }), {
            selectionMode: (_a = getString(el, "selectionMode", ["single", "multiple"])) != null ? _a : "single",
            dir: getDir(el),
            onSelectionChange: (details) => {
              var _a2;
              const redirect = getBoolean(el, "redirect");
              const value = ((_a2 = details.selectedValue) == null ? void 0 : _a2.length) ? details.selectedValue[0] : void 0;
              const itemEl = [
                ...el.querySelectorAll(
                  '[data-scope="tree-view"][data-part="item"], [data-scope="tree-view"][data-part="branch"]'
                )
              ].find((node) => node.getAttribute("data-value") === value);
              const isItem = (itemEl == null ? void 0 : itemEl.getAttribute("data-part")) === "item";
              const itemRedirect = itemEl == null ? void 0 : itemEl.getAttribute("data-redirect");
              const itemNewTab = itemEl == null ? void 0 : itemEl.hasAttribute("data-new-tab");
              const doRedirect = redirect && value && isItem && this.liveSocket.main.isDead && itemRedirect !== "false";
              if (doRedirect) {
                if (itemNewTab) {
                  window.open(value, "_blank", "noopener,noreferrer");
                } else {
                  window.location.href = value;
                }
              }
              const eventName = getString(el, "onSelectionChange");
              if (eventName && this.liveSocket.main.isConnected()) {
                pushEvent(eventName, {
                  id: el.id,
                  value: details
                });
              }
            },
            onExpandedChange: (details) => {
              const eventName = getString(el, "onExpandedChange");
              if (eventName && this.liveSocket.main.isConnected()) {
                pushEvent(eventName, {
                  id: el.id,
                  value: details
                });
              }
            }
          }));
          treeView.init();
          this.treeView = treeView;
          this.onSetExpandedValue = (event) => {
            const { value } = event.detail;
            treeView.api.setExpandedValue(value);
          };
          el.addEventListener("phx:tree-view:set-expanded-value", this.onSetExpandedValue);
          this.onSetSelectedValue = (event) => {
            const { value } = event.detail;
            treeView.api.setSelectedValue(value);
          };
          el.addEventListener("phx:tree-view:set-selected-value", this.onSetSelectedValue);
          this.handlers = [];
          this.handlers.push(
            this.handleEvent(
              "tree_view_set_expanded_value",
              (payload) => {
                const targetId = payload.tree_view_id;
                if (targetId && el.id !== targetId && el.id !== `tree-view:${targetId}`) return;
                treeView.api.setExpandedValue(payload.value);
              }
            )
          );
          this.handlers.push(
            this.handleEvent(
              "tree_view_set_selected_value",
              (payload) => {
                const targetId = payload.tree_view_id;
                if (targetId && el.id !== targetId && el.id !== `tree-view:${targetId}`) return;
                treeView.api.setSelectedValue(payload.value);
              }
            )
          );
          this.handlers.push(
            this.handleEvent("tree_view_expanded_value", () => {
              pushEvent("tree_view_expanded_value_response", {
                value: treeView.api.expandedValue
              });
            })
          );
          this.handlers.push(
            this.handleEvent("tree_view_selected_value", () => {
              pushEvent("tree_view_selected_value_response", {
                value: treeView.api.selectedValue
              });
            })
          );
        },
        updated() {
          var _a;
          if (!getBoolean(this.el, "controlled")) return;
          (_a = this.treeView) == null ? void 0 : _a.updateProps({
            expandedValue: getStringList(this.el, "expandedValue"),
            selectedValue: getStringList(this.el, "selectedValue")
          });
        },
        destroyed() {
          var _a;
          if (this.onSetExpandedValue) {
            this.el.removeEventListener("phx:tree-view:set-expanded-value", this.onSetExpandedValue);
          }
          if (this.onSetSelectedValue) {
            this.el.removeEventListener("phx:tree-view:set-selected-value", this.onSetSelectedValue);
          }
          if (this.handlers) {
            for (const handler of this.handlers) {
              this.removeHandleEvent(handler);
            }
          }
          (_a = this.treeView) == null ? void 0 : _a.destroy();
        }
      };
    }
  });

  // hooks/corex.ts
  var corex_exports = {};
  __export(corex_exports, {
    Hooks: () => Hooks,
    default: () => corex_default,
    hooks: () => hooks
  });
  function hooks(importFn, exportName) {
    return {
      mounted() {
        return __async(this, null, function* () {
          const mod = yield importFn();
          const real = mod[exportName];
          this._realHook = real;
          if (real == null ? void 0 : real.mounted) return real.mounted.call(this);
        });
      },
      updated() {
        var _a2, _b;
        (_b = (_a2 = this._realHook) == null ? void 0 : _a2.updated) == null ? void 0 : _b.call(this);
      },
      destroyed() {
        var _a2, _b;
        (_b = (_a2 = this._realHook) == null ? void 0 : _a2.destroyed) == null ? void 0 : _b.call(this);
      },
      disconnected() {
        var _a2, _b;
        (_b = (_a2 = this._realHook) == null ? void 0 : _a2.disconnected) == null ? void 0 : _b.call(this);
      },
      reconnected() {
        var _a2, _b;
        (_b = (_a2 = this._realHook) == null ? void 0 : _a2.reconnected) == null ? void 0 : _b.call(this);
      },
      beforeUpdate() {
        var _a2, _b;
        (_b = (_a2 = this._realHook) == null ? void 0 : _a2.beforeUpdate) == null ? void 0 : _b.call(this);
      }
    };
  }
  var Hooks = {
    Accordion: hooks(() => Promise.resolve().then(() => (init_accordion(), accordion_exports)), "Accordion"),
    Checkbox: hooks(() => Promise.resolve().then(() => (init_checkbox(), checkbox_exports)), "Checkbox"),
    Clipboard: hooks(() => Promise.resolve().then(() => (init_clipboard(), clipboard_exports)), "Clipboard"),
    Collapsible: hooks(() => Promise.resolve().then(() => (init_collapsible(), collapsible_exports)), "Collapsible"),
    Combobox: hooks(() => Promise.resolve().then(() => (init_combobox(), combobox_exports)), "Combobox"),
    DatePicker: hooks(() => Promise.resolve().then(() => (init_date_picker(), date_picker_exports)), "DatePicker"),
    Dialog: hooks(() => Promise.resolve().then(() => (init_dialog(), dialog_exports)), "Dialog"),
    Menu: hooks(() => Promise.resolve().then(() => (init_menu(), menu_exports)), "Menu"),
    Select: hooks(() => Promise.resolve().then(() => (init_select(), select_exports)), "Select"),
    SignaturePad: hooks(() => Promise.resolve().then(() => (init_signature_pad(), signature_pad_exports)), "SignaturePad"),
    Switch: hooks(() => Promise.resolve().then(() => (init_switch(), switch_exports)), "Switch"),
    Tabs: hooks(() => Promise.resolve().then(() => (init_tabs(), tabs_exports)), "Tabs"),
    Toast: hooks(() => Promise.resolve().then(() => (init_toast(), toast_exports)), "Toast"),
    ToggleGroup: hooks(() => Promise.resolve().then(() => (init_toggle_group(), toggle_group_exports)), "ToggleGroup"),
    TreeView: hooks(() => Promise.resolve().then(() => (init_tree_view(), tree_view_exports)), "TreeView")
  };
  var corex_default = Hooks;
  return __toCommonJS(corex_exports);
})();
