"use strict";
var __defProp = Object.defineProperty;
var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
var __getOwnPropNames = Object.getOwnPropertyNames;
var __hasOwnProp = Object.prototype.hasOwnProperty;
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

// hooks/corex.ts
var corex_exports = {};
__export(corex_exports, {
  Accordion: () => AccordionHook,
  Checkbox: () => CheckboxHook,
  Clipboard: () => ClipboardHook,
  Collapsible: () => CollapsibleHook,
  Combobox: () => ComboboxHook,
  DatePicker: () => DatePickerHook,
  Dialog: () => DialogHook,
  Select: () => SelectHook,
  SignaturePad: () => SignaturePadHook,
  Switch: () => SwitchHook,
  Tabs: () => TabsHook,
  Toast: () => ToastHook,
  ToggleGroup: () => ToggleGroupHook,
  default: () => corex_default
});
module.exports = __toCommonJS(corex_exports);

// ../node_modules/.pnpm/@zag-js+anatomy@1.33.1/node_modules/@zag-js/anatomy/dist/index.mjs
var createAnatomy = (name, parts14 = []) => ({
  parts: (...values) => {
    if (isEmpty(parts14)) {
      return createAnatomy(name, values);
    }
    throw new Error("createAnatomy().parts(...) should only be called once. Did you mean to use .extendWith(...) ?");
  },
  extendWith: (...values) => createAnatomy(name, [...parts14, ...values]),
  omit: (...values) => createAnatomy(name, parts14.filter((part) => !values.includes(part))),
  rename: (newName) => createAnatomy(newName, parts14),
  keys: () => parts14,
  build: () => [...new Set(parts14)].reduce(
    (prev, part) => Object.assign(prev, {
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
var toKebabCase = (value) => value.replace(/([A-Z])([A-Z])/g, "$1-$2").replace(/([a-z])([A-Z])/g, "$1-$2").replace(/[\s_]+/g, "-").toLowerCase();
var isEmpty = (v2) => v2.length === 0;

// ../node_modules/.pnpm/@zag-js+dom-query@1.33.1/node_modules/@zag-js/dom-query/dist/index.mjs
var __defProp2 = Object.defineProperty;
var __defNormalProp = (obj, key, value) => key in obj ? __defProp2(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
var __publicField = (obj, key, value) => __defNormalProp(obj, typeof key !== "symbol" ? key + "" : key, value);
function setCaretToEnd(input) {
  if (!input) return;
  try {
    if (input.ownerDocument.activeElement !== input) return;
    const len = input.value.length;
    input.setSelectionRange(len, len);
  } catch {
  }
}
var clamp = (value) => Math.max(0, Math.min(1, value));
var wrap = (v2, idx) => {
  return v2.map((_2, index) => v2[(Math.max(idx, 0) + index) % v2.length]);
};
var pipe = (...fns) => (arg) => fns.reduce((acc, fn) => fn(acc), arg);
var noop = () => void 0;
var isObject = (v2) => typeof v2 === "object" && v2 !== null;
var MAX_Z_INDEX = 2147483647;
var dataAttr = (guard) => guard ? "" : void 0;
var ariaAttr = (guard) => guard ? "true" : void 0;
var ELEMENT_NODE = 1;
var DOCUMENT_NODE = 9;
var DOCUMENT_FRAGMENT_NODE = 11;
var isHTMLElement = (el) => isObject(el) && el.nodeType === ELEMENT_NODE && typeof el.nodeName === "string";
var isDocument = (el) => isObject(el) && el.nodeType === DOCUMENT_NODE;
var isWindow = (el) => isObject(el) && el === el.window;
var getNodeName = (node) => {
  if (isHTMLElement(node)) return node.localName || "";
  return "#document";
};
function isRootElement(node) {
  return ["html", "body", "#document"].includes(getNodeName(node));
}
var isNode = (el) => isObject(el) && el.nodeType !== void 0;
var isShadowRoot = (el) => isNode(el) && el.nodeType === DOCUMENT_FRAGMENT_NODE && "host" in el;
var isInputElement = (el) => isHTMLElement(el) && el.localName === "input";
var isAnchorElement = (el) => !!el?.matches("a[href]");
var isElementVisible = (el) => {
  if (!isHTMLElement(el)) return false;
  return el.offsetWidth > 0 || el.offsetHeight > 0 || el.getClientRects().length > 0;
};
function isActiveElement(element) {
  if (!element) return false;
  const rootNode = element.getRootNode();
  return getActiveElement(rootNode) === element;
}
var TEXTAREA_SELECT_REGEX = /(textarea|select)/;
function isEditableElement(el) {
  if (el == null || !isHTMLElement(el)) return false;
  try {
    return isInputElement(el) && el.selectionStart != null || TEXTAREA_SELECT_REGEX.test(el.localName) || el.isContentEditable || el.getAttribute("contenteditable") === "true" || el.getAttribute("contenteditable") === "";
  } catch {
    return false;
  }
}
function contains(parent, child) {
  if (!parent || !child) return false;
  if (!isHTMLElement(parent) || !isHTMLElement(child)) return false;
  const rootNode = child.getRootNode?.();
  if (parent === child) return true;
  if (parent.contains(child)) return true;
  if (rootNode && isShadowRoot(rootNode)) {
    let next = child;
    while (next) {
      if (parent === next) return true;
      next = next.parentNode || next.host;
    }
  }
  return false;
}
function getDocument(el) {
  if (isDocument(el)) return el;
  if (isWindow(el)) return el.document;
  return el?.ownerDocument ?? document;
}
function getDocumentElement(el) {
  return getDocument(el).documentElement;
}
function getWindow(el) {
  if (isShadowRoot(el)) return getWindow(el.host);
  if (isDocument(el)) return el.defaultView ?? window;
  if (isHTMLElement(el)) return el.ownerDocument?.defaultView ?? window;
  return window;
}
function getActiveElement(rootNode) {
  let activeElement = rootNode.activeElement;
  while (activeElement?.shadowRoot) {
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
  let result;
  try {
    result = node.getRootNode({ composed: true });
    if (isDocument(result) || isShadowRoot(result)) return result;
  } catch {
  }
  return node.ownerDocument ?? document;
}
var styleCache = /* @__PURE__ */ new WeakMap();
function getComputedStyle2(el) {
  if (!styleCache.has(el)) {
    styleCache.set(el, getWindow(el).getComputedStyle(el));
  }
  return styleCache.get(el);
}
var INTERACTIVE_CONTAINER_ROLE = /* @__PURE__ */ new Set(["menu", "listbox", "dialog", "grid", "tree", "region"]);
var isInteractiveContainerRole = (role) => INTERACTIVE_CONTAINER_ROLE.has(role);
var getAriaControls = (element) => element.getAttribute("aria-controls")?.split(" ") || [];
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
  if (isControllerElement(element)) return true;
  return Boolean(element.querySelector?.('[aria-controls][aria-expanded="true"]'));
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
      context?.drawImage(image, 0, 0, canvas.width, canvas.height);
      resolve(canvas.toDataURL(type, quality));
      svgClone.remove();
    };
  });
}
var isDom = () => typeof document !== "undefined";
function getPlatform() {
  const agent = navigator.userAgentData;
  return agent?.platform ?? navigator.platform;
}
function getUserAgent() {
  const ua2 = navigator.userAgentData;
  if (ua2 && Array.isArray(ua2.brands)) {
    return ua2.brands.map(({ brand, version }) => `${brand}/${version}`).join(" ");
  }
  return navigator.userAgent;
}
var pt = (v2) => isDom() && v2.test(getPlatform());
var ua = (v2) => isDom() && v2.test(getUserAgent());
var vn = (v2) => isDom() && v2.test(navigator.vendor);
var isTouchDevice = () => isDom() && !!navigator.maxTouchPoints;
var isIPhone = () => pt(/^iPhone/i);
var isIPad = () => pt(/^iPad/i) || isMac() && navigator.maxTouchPoints > 1;
var isIos = () => isIPhone() || isIPad();
var isApple = () => isMac() || isIos();
var isMac = () => pt(/^Mac/i);
var isSafari = () => isApple() && vn(/apple/i);
var isFirefox = () => ua(/Firefox/i);
var isAndroid = () => ua(/Android/i);
function getComposedPath(event) {
  return event.composedPath?.() ?? event.nativeEvent?.composedPath?.();
}
function getEventTarget(event) {
  const composedPath = getComposedPath(event);
  return composedPath?.[0] ?? event.target;
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
function isVirtualClick(e2) {
  if (e2.pointerType === "" && e2.isTrusted) return true;
  if (isAndroid() && e2.pointerType) {
    return e2.type === "click" && e2.buttons === 1;
  }
  return e2.detail === 0 && !e2.pointerType;
}
var isLeftClick = (e2) => e2.button === 0;
var isContextMenuEvent = (e2) => {
  return e2.button === 2 || isMac() && e2.ctrlKey && e2.button === 0;
};
var isModifierKey = (e2) => e2.ctrlKey || e2.altKey || e2.metaKey;
var isTouchEvent = (event) => "touches" in event && event.touches.length > 0;
var keyMap = {
  Up: "ArrowUp",
  Down: "ArrowDown",
  Esc: "Escape",
  " ": "Space",
  ",": "Comma",
  Left: "ArrowLeft",
  Right: "ArrowRight"
};
var rtlKeyMap = {
  ArrowLeft: "ArrowRight",
  ArrowRight: "ArrowLeft"
};
function getEventKey(event, options = {}) {
  const { dir = "ltr", orientation = "horizontal" } = options;
  let key = event.key;
  key = keyMap[key] ?? key;
  const isRtl = dir === "rtl" && orientation === "horizontal";
  if (isRtl && key in rtlKeyMap) key = rtlKeyMap[key];
  return key;
}
function getNativeEvent(event) {
  return event.nativeEvent ?? event;
}
function getEventPoint(event, type = "client") {
  const point = isTouchEvent(event) ? event.touches[0] || event.changedTouches[0] : event;
  return { x: point[`${type}X`], y: point[`${type}Y`] };
}
var addDomEvent = (target, eventName, handler, options) => {
  const node = typeof target === "function" ? target() : target;
  node?.addEventListener(eventName, handler, options);
  return () => {
    node?.removeEventListener(eventName, handler, options);
  };
};
function getDescriptor(el, options) {
  const { type = "HTMLInputElement", property = "value" } = options;
  const proto = getWindow(el)[type].prototype;
  return Object.getOwnPropertyDescriptor(proto, property) ?? {};
}
function getElementType(el) {
  if (el.localName === "input") return "HTMLInputElement";
  if (el.localName === "textarea") return "HTMLTextAreaElement";
  if (el.localName === "select") return "HTMLSelectElement";
}
function setElementValue(el, value, property = "value") {
  if (!el) return;
  const type = getElementType(el);
  if (type) {
    const descriptor = getDescriptor(el, { type, property });
    descriptor.set?.call(el, value);
  }
  el.setAttribute(property, value);
}
function setElementChecked(el, checked) {
  if (!el) return;
  const descriptor = getDescriptor(el, { type: "HTMLInputElement", property: "checked" });
  descriptor.set?.call(el, checked);
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
  form?.addEventListener("reset", onReset, { passive: true });
  return () => form?.removeEventListener("reset", onReset);
}
function trackFieldsetDisabled(el, callback) {
  const fieldset = el?.closest("fieldset");
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
  return () => cleanups.forEach((cleanup) => cleanup?.());
}
var isFrame = (el) => isHTMLElement(el) && el.tagName === "IFRAME";
var NATURALLY_TABBABLE_REGEX = /^(audio|video|details)$/;
function parseTabIndex(el) {
  const attr = el.getAttribute("tabindex");
  if (!attr) return NaN;
  return parseInt(attr, 10);
}
var hasTabIndex = (el) => !Number.isNaN(parseTabIndex(el));
var hasNegativeTabIndex = (el) => parseTabIndex(el) < 0;
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
var focusableSelector = "input:not([type='hidden']):not([disabled]), select:not([disabled]), textarea:not([disabled]), a[href], button:not([disabled]), [tabindex], iframe, object, embed, area[href], audio[controls], video[controls], [contenteditable]:not([contenteditable='false']), details > summary:first-of-type";
var getFocusables = (container, options = {}) => {
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
  const { root, getInitialEl, filter, enabled = true } = options;
  if (!enabled) return;
  let node = null;
  node || (node = typeof getInitialEl === "function" ? getInitialEl() : getInitialEl);
  node || (node = root?.querySelector("[data-autofocus],[autofocus]"));
  if (!node) {
    const tabbables = getTabbables(root);
    node = filter ? tabbables.filter(filter)[0] : tabbables[0];
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
var AnimationFrame = class _AnimationFrame {
  constructor() {
    __publicField(this, "id", null);
    __publicField(this, "fn_cleanup");
    __publicField(this, "cleanup", () => {
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
      this.fn_cleanup = fn?.();
    });
  }
  cancel() {
    if (this.id !== null) {
      globalThis.cancelAnimationFrame(this.id);
      this.id = null;
    }
    this.fn_cleanup?.();
    this.fn_cleanup = void 0;
  }
  isActive() {
    return this.id !== null;
  }
};
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
    cleanups.forEach((fn) => fn?.());
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
    cleanups.forEach((fn) => fn?.());
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
var OVERFLOW_RE = /auto|scroll|overlay|hidden|clip/;
var nonOverflowValues = /* @__PURE__ */ new Set(["inline", "contents"]);
function isOverflowElement(el) {
  const win = getWindow(el);
  const { overflow, overflowX, overflowY, display } = win.getComputedStyle(el);
  return OVERFLOW_RE.test(overflow + overflowY + overflowX) && !nonOverflowValues.has(display);
}
function isScrollable(el) {
  return el.scrollHeight > el.clientHeight || el.scrollWidth > el.clientWidth;
}
function scrollIntoView(el, options) {
  const { rootEl, ...scrollOptions } = options || {};
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
var state = "default";
var userSelect = "";
var elementMap = /* @__PURE__ */ new WeakMap();
function disableTextSelectionImpl(options = {}) {
  const { target, doc } = options;
  const docNode = doc ?? document;
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
  const docNode = doc ?? document;
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
        target.style.userSelect = prevUserSelect ?? "";
      }
      if (target.getAttribute("style") === "") {
        target.removeAttribute("style");
      }
      elementMap.delete(target);
    }
  }
}
function disableTextSelection(options = {}) {
  const { defer, target, ...restOptions } = options;
  const func = defer ? raf : (v2) => v2();
  const cleanups = [];
  cleanups.push(
    func(() => {
      const node = typeof target === "function" ? target() : target;
      cleanups.push(disableTextSelectionImpl({ ...restOptions, target: node }));
    })
  );
  return () => {
    cleanups.forEach((fn) => fn?.());
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
    onPressStart?.(getInfo(event));
  }
  function cancelPress(event) {
    onPressEnd?.(getInfo(event));
  }
  const startPointerPress = (startEvent) => {
    removeEndListeners();
    const endPointerPress = (endEvent) => {
      const target = getEventTarget(endEvent);
      if (contains(pointerNode, target)) {
        onPress?.(getInfo(endEvent));
      } else {
        onPressEnd?.(getInfo(endEvent));
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
        onPress?.(info);
        onPressEnd?.(info);
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
  return Array.from(root?.querySelectorAll(selector) ?? []);
}
function query(root, selector) {
  return root?.querySelector(selector) ?? null;
}
var defaultItemToId = (v2) => v2.id;
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
    observer?.unobserve(element);
  };
  return {
    observe,
    unobserve
  };
}
var resizeObserverBorderBox = /* @__PURE__ */ createSharedResizeObserver({
  box: "border-box"
});
var sanitize = (str) => str.split("").map((char) => {
  const code = char.charCodeAt(0);
  if (code > 0 && code < 128) return char;
  if (code >= 128 && code <= 255) return `/x${code.toString(16)}`.replace("/", "\\");
  return "";
}).join("").trim();
var getValueText = (el) => {
  return sanitize(el.dataset?.valuetext ?? el.textContent ?? "");
};
var match = (valueText, query2) => {
  return valueText.trim().toLowerCase().startsWith(query2.toLowerCase());
};
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
  const prev = el.getAttribute(attr);
  const exists = prev != null;
  if (prev === v2) return noop;
  el.setAttribute(attr, v2);
  return () => {
    if (!exists) {
      el.removeAttribute(attr);
    } else {
      el.setAttribute(attr, prev);
    }
  };
}
function setStyle(el, style) {
  if (!el) return noop;
  const prev = Object.keys(style).reduce((acc, key) => {
    acc[key] = el.style.getPropertyValue(key);
    return acc;
  }, {});
  if (isEqual(prev, style)) return noop;
  Object.assign(el.style, style);
  return () => {
    Object.assign(el.style, prev);
    if (el.style.length === 0) {
      el.removeAttribute("style");
    }
  };
}
function setStyleProperty(el, prop, value) {
  if (!el) return noop;
  const prev = el.style.getPropertyValue(prop);
  if (prev === value) return noop;
  el.style.setProperty(prop, value);
  return () => {
    el.style.setProperty(prop, prev);
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
  const next = getByText(items, query2, activeId, itemToId);
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
  return next;
}
var getByTypeahead = /* @__PURE__ */ Object.assign(getByTypeaheadImpl, {
  defaultOptions: { keysSoFar: "", timer: -1 },
  isValidEvent: isValidTypeaheadEvent
});
function isValidTypeaheadEvent(event) {
  return event.key.length === 1 && !event.ctrlKey && !event.metaKey;
}
var visuallyHiddenStyle = {
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

// ../node_modules/.pnpm/@zag-js+utils@1.33.1/node_modules/@zag-js/utils/dist/index.mjs
var __defProp3 = Object.defineProperty;
var __typeError = (msg) => {
  throw TypeError(msg);
};
var __defNormalProp2 = (obj, key, value) => key in obj ? __defProp3(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
var __publicField2 = (obj, key, value) => __defNormalProp2(obj, typeof key !== "symbol" ? key + "" : key, value);
var __accessCheck = (obj, member, msg) => member.has(obj) || __typeError("Cannot " + msg);
var __privateGet = (obj, member, getter) => (__accessCheck(obj, member, "read from private field"), member.get(obj));
var __privateAdd = (obj, member, value) => member.has(obj) ? __typeError("Cannot add the same private member more than once") : member instanceof WeakSet ? member.add(obj) : member.set(obj, value);
function toArray(v2) {
  if (v2 == null) return [];
  return Array.isArray(v2) ? v2 : [v2];
}
var first = (v2) => v2[0];
var last = (v2) => v2[v2.length - 1];
var has = (v2, t2) => v2.indexOf(t2) !== -1;
var add = (v2, ...items) => v2.concat(items);
var remove = (v2, ...items) => v2.filter((t2) => !items.includes(t2));
var addOrRemove = (v2, item) => has(v2, item) ? remove(v2, item) : add(v2, item);
function chunk(v2, size3) {
  return v2.reduce((rows, value, index) => {
    if (index % size3 === 0) rows.push([value]);
    else last(rows)?.push(value);
    return rows;
  }, []);
}
var isArrayLike = (value) => value?.constructor.name === "Array";
var isArrayEqual = (a2, b2) => {
  if (a2.length !== b2.length) return false;
  for (let i2 = 0; i2 < a2.length; i2++) {
    if (!isEqual2(a2[i2], b2[i2])) return false;
  }
  return true;
};
var isEqual2 = (a2, b2) => {
  if (Object.is(a2, b2)) return true;
  if (a2 == null && b2 != null || a2 != null && b2 == null) return false;
  if (typeof a2?.isEqual === "function" && typeof b2?.isEqual === "function") {
    return a2.isEqual(b2);
  }
  if (typeof a2 === "function" && typeof b2 === "function") {
    return a2.toString() === b2.toString();
  }
  if (isArrayLike(a2) && isArrayLike(b2)) {
    return isArrayEqual(Array.from(a2), Array.from(b2));
  }
  if (!(typeof a2 === "object") || !(typeof b2 === "object")) return false;
  const keys = Object.keys(b2 ?? /* @__PURE__ */ Object.create(null));
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
var isArray = (v2) => Array.isArray(v2);
var isBoolean = (v2) => v2 === true || v2 === false;
var isObjectLike = (v2) => v2 != null && typeof v2 === "object";
var isObject2 = (v2) => isObjectLike(v2) && !isArray(v2);
var isString = (v2) => typeof v2 === "string";
var isFunction = (v2) => typeof v2 === "function";
var isNull = (v2) => v2 == null;
var hasProp = (obj, prop) => Object.prototype.hasOwnProperty.call(obj, prop);
var baseGetTag = (v2) => Object.prototype.toString.call(v2);
var fnToString = Function.prototype.toString;
var objectCtorString = fnToString.call(Object);
var isPlainObject = (v2) => {
  if (!isObjectLike(v2) || baseGetTag(v2) != "[object Object]" || isFrameworkElement(v2)) return false;
  const proto = Object.getPrototypeOf(v2);
  if (proto === null) return true;
  const Ctor = hasProp(proto, "constructor") && proto.constructor;
  return typeof Ctor == "function" && Ctor instanceof Ctor && fnToString.call(Ctor) == objectCtorString;
};
var isReactElement = (x2) => typeof x2 === "object" && x2 !== null && "$$typeof" in x2 && "props" in x2;
var isVueElement = (x2) => typeof x2 === "object" && x2 !== null && "__v_isVNode" in x2;
var isFrameworkElement = (x2) => isReactElement(x2) || isVueElement(x2);
var runIfFn = (v2, ...a2) => {
  const res = typeof v2 === "function" ? v2(...a2) : v2;
  return res ?? void 0;
};
var identity = (v2) => v2();
var noop2 = () => {
};
var callAll = (...fns) => (...a2) => {
  fns.forEach(function(fn) {
    fn?.(...a2);
  });
};
var uuid = /* @__PURE__ */ (() => {
  let id = 0;
  return () => {
    id++;
    return id.toString(36);
  };
})();
function match2(key, record, ...args) {
  if (key in record) {
    const fn = record[key];
    return isFunction(fn) ? fn(...args) : fn;
  }
  const error = new Error(`No matching key: ${JSON.stringify(key)} in ${JSON.stringify(Object.keys(record))}`);
  Error.captureStackTrace?.(error, match2);
  throw error;
}
var { floor, abs, round, min, max, pow, sign } = Math;
var isNaN2 = (v2) => Number.isNaN(v2);
var nan = (v2) => isNaN2(v2) ? 0 : v2;
var isValueWithinRange = (v2, vmin, vmax) => {
  const value = nan(v2);
  const minCheck = vmin == null || value >= vmin;
  const maxCheck = vmax == null || value <= vmax;
  return minCheck && maxCheck;
};
var clampValue = (v2, vmin, vmax) => min(max(nan(v2), vmin), vmax);
var toPx = (v2) => typeof v2 === "number" ? `${v2}px` : v2;
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
function splitProps(props13, keys) {
  const rest = {};
  const result = {};
  const keySet = new Set(keys);
  const ownKeys = Reflect.ownKeys(props13);
  for (const key of ownKeys) {
    if (keySet.has(key)) {
      result[key] = props13[key];
    } else {
      rest[key] = props13[key];
    }
  }
  return [result, rest];
}
var createSplitProps = (keys) => {
  return function split(props13) {
    return splitProps(props13, keys);
  };
};
var currentTime = () => performance.now();
var _tick;
var Timer = class {
  constructor(onTick) {
    this.onTick = onTick;
    __publicField2(this, "frameId", null);
    __publicField2(this, "pausedAtMs", null);
    __publicField2(this, "context");
    __publicField2(this, "cancelFrame", () => {
      if (this.frameId === null) return;
      cancelAnimationFrame(this.frameId);
      this.frameId = null;
    });
    __publicField2(this, "setStartMs", (startMs) => {
      this.context.startMs = startMs;
    });
    __publicField2(this, "start", () => {
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
    __publicField2(this, "pause", () => {
      if (this.frameId === null) return;
      this.cancelFrame();
      this.pausedAtMs = currentTime();
    });
    __publicField2(this, "stop", () => {
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
function ensureProps(props13, keys, scope) {
  let missingKeys = [];
  for (const key of keys) {
    if (props13[key] == null) missingKeys.push(key);
  }
  if (missingKeys.length > 0)
    throw new Error(`[zag-js${scope ? ` > ${scope}` : ""}] missing required props: ${missingKeys.join(", ")}`);
}

// ../node_modules/.pnpm/@zag-js+core@1.33.1/node_modules/@zag-js/core/dist/index.mjs
function memo(getDeps, fn, opts) {
  let deps = [];
  let result;
  return (depArgs) => {
    const newDeps = getDeps(depArgs);
    const depsChanged = newDeps.length !== deps.length || newDeps.some((dep, index) => !isEqual2(deps[index], dep));
    if (!depsChanged) return result;
    deps = newDeps;
    result = fn(newDeps, depArgs);
    opts?.onChange?.(result);
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
        return choose2(transitions)?.actions;
      };
    }
  };
}
var MachineStatus = /* @__PURE__ */ ((MachineStatus2) => {
  MachineStatus2["NotStarted"] = "Not Started";
  MachineStatus2["Started"] = "Started";
  MachineStatus2["Stopped"] = "Stopped";
  return MachineStatus2;
})(MachineStatus || {});
var INIT_STATE = "__init__";
function createScope(props13) {
  const getRootNode2 = () => props13.getRootNode?.() ?? document;
  const getDoc = () => getDocument(getRootNode2());
  const getWin = () => getDoc().defaultView ?? window;
  const getActiveElementFn = () => getActiveElement(getRootNode2());
  const getById = (id) => getRootNode2().getElementById(id);
  return {
    ...props13,
    getRootNode: getRootNode2,
    getDoc,
    getWin,
    getActiveElement: getActiveElementFn,
    isActiveElement,
    getById
  };
}

// ../node_modules/.pnpm/@zag-js+types@1.33.1/node_modules/@zag-js/types/dist/index.mjs
function createNormalizer(fn) {
  return new Proxy({}, {
    get(_target, key) {
      if (key === "style")
        return (props13) => {
          return fn({ style: props13 }).style;
        };
      return fn;
    }
  });
}
var createProps = () => (props13) => Array.from(new Set(props13));

// ../node_modules/.pnpm/@zag-js+accordion@1.33.1/node_modules/@zag-js/accordion/dist/index.mjs
var anatomy = createAnatomy("accordion").parts("root", "item", "itemTrigger", "itemContent", "itemIndicator");
var parts = anatomy.build();
var getRootId = (ctx) => ctx.ids?.root ?? `accordion:${ctx.id}`;
var getItemId = (ctx, value) => ctx.ids?.item?.(value) ?? `accordion:${ctx.id}:item:${value}`;
var getItemContentId = (ctx, value) => ctx.ids?.itemContent?.(value) ?? `accordion:${ctx.id}:content:${value}`;
var getItemTriggerId = (ctx, value) => ctx.ids?.itemTrigger?.(value) ?? `accordion:${ctx.id}:trigger:${value}`;
var getRootEl = (ctx) => ctx.getById(getRootId(ctx));
var getTriggerEls = (ctx) => {
  const ownerId = CSS.escape(getRootId(ctx));
  const selector = `[data-controls][data-ownedby='${ownerId}']:not([disabled])`;
  return queryAll(getRootEl(ctx), selector);
};
var getFirstTriggerEl = (ctx) => first(getTriggerEls(ctx));
var getLastTriggerEl = (ctx) => last(getTriggerEls(ctx));
var getNextTriggerEl = (ctx, id) => nextById(getTriggerEls(ctx), getItemTriggerId(ctx, id));
var getPrevTriggerEl = (ctx, id) => prevById(getTriggerEls(ctx), getItemTriggerId(ctx, id));
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
    return {
      expanded: value.includes(props22.value),
      focused: focusedValue === props22.value,
      disabled: Boolean(props22.disabled ?? prop("disabled"))
    };
  }
  return {
    focusedValue,
    value,
    setValue,
    getItemState,
    getRootProps() {
      return normalize.element({
        ...parts.root.attrs,
        dir: prop("dir"),
        id: getRootId(scope),
        "data-orientation": prop("orientation")
      });
    },
    getItemProps(props22) {
      const itemState = getItemState(props22);
      return normalize.element({
        ...parts.item.attrs,
        dir: prop("dir"),
        id: getItemId(scope, props22.value),
        "data-state": itemState.expanded ? "open" : "closed",
        "data-focus": dataAttr(itemState.focused),
        "data-disabled": dataAttr(itemState.disabled),
        "data-orientation": prop("orientation")
      });
    },
    getItemContentProps(props22) {
      const itemState = getItemState(props22);
      return normalize.element({
        ...parts.itemContent.attrs,
        dir: prop("dir"),
        role: "region",
        id: getItemContentId(scope, props22.value),
        "aria-labelledby": getItemTriggerId(scope, props22.value),
        hidden: !itemState.expanded,
        "data-state": itemState.expanded ? "open" : "closed",
        "data-disabled": dataAttr(itemState.disabled),
        "data-focus": dataAttr(itemState.focused),
        "data-orientation": prop("orientation")
      });
    },
    getItemIndicatorProps(props22) {
      const itemState = getItemState(props22);
      return normalize.element({
        ...parts.itemIndicator.attrs,
        dir: prop("dir"),
        "aria-hidden": true,
        "data-state": itemState.expanded ? "open" : "closed",
        "data-disabled": dataAttr(itemState.disabled),
        "data-focus": dataAttr(itemState.focused),
        "data-orientation": prop("orientation")
      });
    },
    getItemTriggerProps(props22) {
      const { value: value2 } = props22;
      const itemState = getItemState(props22);
      return normalize.button({
        ...parts.itemTrigger.attrs,
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
      });
    }
  };
}
var { and, not } = createGuards();
var machine = createMachine({
  props({ props: props22 }) {
    return {
      collapsible: false,
      multiple: false,
      orientation: "vertical",
      defaultValue: [],
      ...props22
    };
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
          prop("onFocusChange")?.({ value });
        }
      })),
      value: bindable2(() => ({
        defaultValue: prop("defaultValue"),
        value: prop("value"),
        onChange(value) {
          prop("onValueChange")?.({ value });
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
        const next = prop("multiple") ? remove(context.get("value"), event.value) : [];
        context.set("value", next);
      },
      expand({ context, prop, event }) {
        const next = prop("multiple") ? add(context.get("value"), event.value) : [event.value];
        context.set("value", next);
      },
      focusFirstTrigger({ scope }) {
        getFirstTriggerEl(scope)?.focus();
      },
      focusLastTrigger({ scope }) {
        getLastTriggerEl(scope)?.focus();
      },
      focusNextTrigger({ context, scope }) {
        const focusedValue = context.get("focusedValue");
        if (!focusedValue) return;
        const triggerEl = getNextTriggerEl(scope, focusedValue);
        triggerEl?.focus();
      },
      focusPrevTrigger({ context, scope }) {
        const focusedValue = context.get("focusedValue");
        if (!focusedValue) return;
        const triggerEl = getPrevTriggerEl(scope, focusedValue);
        triggerEl?.focus();
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
var props = createProps()([
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
var splitProps2 = createSplitProps(props);
var itemProps = createProps()(["value", "disabled"]);
var splitItemProps = createSplitProps(itemProps);

// ../node_modules/.pnpm/proxy-compare@3.0.1/node_modules/proxy-compare/dist/index.js
var TRACK_MEMO_SYMBOL = Symbol();
var GET_ORIGINAL_SYMBOL = Symbol();
var getProto = Object.getPrototypeOf;
var objectsToTrack = /* @__PURE__ */ new WeakMap();
var isObjectToTrack = (obj) => obj && (objectsToTrack.has(obj) ? objectsToTrack.get(obj) : getProto(obj) === Object.prototype || getProto(obj) === Array.prototype);
var getUntracked = (obj) => {
  if (isObjectToTrack(obj)) {
    return obj[GET_ORIGINAL_SYMBOL] || null;
  }
  return null;
};
var markToTrack = (obj, mark = true) => {
  objectsToTrack.set(obj, mark);
};

// ../node_modules/.pnpm/@zag-js+store@1.33.1/node_modules/@zag-js/store/dist/index.mjs
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
var refSet = globalRef("__zag__refSet", () => /* @__PURE__ */ new WeakSet());
var isReactElement2 = (x2) => typeof x2 === "object" && x2 !== null && "$$typeof" in x2 && "props" in x2;
var isVueElement2 = (x2) => typeof x2 === "object" && x2 !== null && "__v_isVNode" in x2;
var isDOMElement = (x2) => typeof x2 === "object" && x2 !== null && "nodeType" in x2 && typeof x2.nodeName === "string";
var isElement = (x2) => isReactElement2(x2) || isVueElement2(x2) || isDOMElement(x2);
var isObject3 = (x2) => x2 !== null && typeof x2 === "object";
var canProxy = (x2) => isObject3(x2) && !refSet.has(x2) && (Array.isArray(x2) || !(Symbol.iterator in x2)) && !isElement(x2) && !(x2 instanceof WeakMap) && !(x2 instanceof WeakSet) && !(x2 instanceof Error) && !(x2 instanceof Number) && !(x2 instanceof Date) && !(x2 instanceof String) && !(x2 instanceof RegExp) && !(x2 instanceof ArrayBuffer) && !(x2 instanceof Promise) && !(x2 instanceof File) && !(x2 instanceof Blob) && !(x2 instanceof AbortController);
var isDev = () => true;
var proxyStateMap = globalRef("__zag__proxyStateMap", () => /* @__PURE__ */ new WeakMap());
var buildProxyFunction = (objectIs = Object.is, newProxy = (target, handler) => new Proxy(target, handler), snapCache = /* @__PURE__ */ new WeakMap(), createSnapshot = (target, version) => {
  const cache = snapCache.get(target);
  if (cache?.[0] === version) {
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
      const remove2 = propProxyState[3](createPropListener(prop));
      propProxyStates.set(prop, [propProxyState, remove2]);
    } else {
      propProxyStates.set(prop, [propProxyState]);
    }
  };
  const removePropListener = (prop) => {
    const entry = propProxyStates.get(prop);
    if (entry) {
      propProxyStates.delete(prop);
      entry[1]?.();
    }
  };
  const addListener = (listener) => {
    listeners.add(listener);
    if (listeners.size === 1) {
      propProxyStates.forEach(([propProxyState, prevRemove], prop) => {
        if (isDev() && prevRemove) {
          throw new Error("remove already exists");
        }
        const remove2 = propProxyState[3](createPropListener(prop));
        propProxyStates.set(prop, [propProxyState, remove2]);
      });
    }
    const removeListener = () => {
      listeners.delete(listener);
      if (listeners.size === 0) {
        propProxyStates.forEach(([propProxyState, remove2], prop) => {
          if (remove2) {
            remove2();
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
      if (Object.getOwnPropertyDescriptor(target, prop)?.set) ;
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
var [proxyFunction] = buildProxyFunction();
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

// ../node_modules/.pnpm/@zag-js+vanilla@1.33.1/node_modules/@zag-js/vanilla/dist/index.mjs
var __defProp4 = Object.defineProperty;
var __defNormalProp3 = (obj, key, value) => key in obj ? __defProp4(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
var __publicField3 = (obj, key, value) => __defNormalProp3(obj, typeof key !== "symbol" ? key + "" : key, value);
var propMap = {
  onFocus: "onFocusin",
  onBlur: "onFocusout",
  onChange: "onInput",
  onDoubleClick: "onDblclick",
  htmlFor: "for",
  className: "class",
  defaultValue: "value",
  defaultChecked: "checked"
};
var caseSensitiveSvgAttrs = /* @__PURE__ */ new Set(["viewBox", "preserveAspectRatio"]);
var toStyleString = (style) => {
  let string = "";
  for (let key in style) {
    const value = style[key];
    if (value === null || value === void 0) continue;
    if (!key.startsWith("--")) key = key.replace(/[A-Z]/g, (match4) => `-${match4.toLowerCase()}`);
    string += `${key}:${value};`;
  }
  return string;
};
var normalizeProps = createNormalizer((props13) => {
  return Object.entries(props13).reduce((acc, [key, value]) => {
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
var prevAttrsMap = /* @__PURE__ */ new WeakMap();
var assignableProps = /* @__PURE__ */ new Set(["value", "checked", "selected"]);
var caseSensitiveSvgAttrs2 = /* @__PURE__ */ new Set([
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
var isSvgElement = (node) => {
  return node.tagName === "svg" || node.namespaceURI === "http://www.w3.org/2000/svg";
};
var getAttributeName = (node, attrName) => {
  const shouldPreserveCase = isSvgElement(node) && caseSensitiveSvgAttrs2.has(attrName);
  return shouldPreserveCase ? attrName : attrName.toLowerCase();
};
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
      node.className = value ?? "";
      return;
    }
    if (assignableProps.has(attrName)) {
      node[attrName] = value ?? "";
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
function bindable(props13) {
  const initial = props13().value ?? props13().defaultValue;
  if (props13().debug) {
    console.log(`[bindable > ${props13().debug}] initial`, initial);
  }
  const eq = props13().isEqual ?? Object.is;
  const store = proxy({ value: initial });
  const controlled = () => props13().value !== void 0;
  return {
    initial,
    ref: store,
    get() {
      return controlled() ? props13().value : store.value;
    },
    set(nextValue) {
      const prev = store.value;
      const next = isFunction(nextValue) ? nextValue(prev) : nextValue;
      if (props13().debug) {
        console.log(`[bindable > ${props13().debug}] setValue`, { next, prev });
      }
      if (!controlled()) store.value = next;
      if (!eq(next, prev)) {
        props13().onChange?.(next, prev);
      }
    },
    invoke(nextValue, prevValue) {
      props13().onChange?.(nextValue, prevValue);
    },
    hash(value) {
      return props13().hash?.(value) ?? String(value);
    }
  };
}
bindable.cleanup = (_fn) => {
};
bindable.ref = (defaultValue) => {
  let value = defaultValue;
  return {
    get: () => value,
    set: (next) => {
      value = next;
    }
  };
};
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
function mergeMachineProps(prev, next) {
  if (!isPlainObject(prev) || !isPlainObject(next)) {
    return next === void 0 ? prev : next;
  }
  const result = { ...prev };
  for (const key of Object.keys(next)) {
    const nextValue = next[key];
    const prevValue = prev[key];
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
var VanillaMachine = class {
  constructor(machine14, userProps = {}) {
    this.machine = machine14;
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
    __publicField3(this, "getEvent", () => ({
      ...this.event,
      current: () => this.event,
      previous: () => this.previousEvent
    }));
    __publicField3(this, "getStateConfig", (state3) => {
      return this.machine.states[state3];
    });
    __publicField3(this, "getState", () => ({
      ...this.state,
      matches: (...values) => values.includes(this.state.get()),
      hasTag: (tag) => !!this.getStateConfig(this.state.get())?.tags?.includes(tag)
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
        if (!event) return;
        this.previousEvent = this.event;
        this.event = event;
        this.debug("send", event);
        let currentState = this.state.get();
        const eventType = event.type;
        const transitions = this.getStateConfig(currentState)?.on?.[eventType] ?? this.machine.on?.[eventType];
        const transition = this.choose(transitions);
        if (!transition) return;
        this.transition = transition;
        const target = transition.target ?? currentState;
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
        const fn = this.machine.implementations?.actions?.[s2];
        if (!fn) warn(`[zag-js] No implementation found for action "${JSON.stringify(s2)}"`);
        return fn;
      });
      for (const fn of fns) {
        fn?.(this.getParams());
      }
    });
    __publicField3(this, "guard", (str) => {
      if (isFunction(str)) return str(this.getParams());
      return this.machine.implementations?.guards?.[str](this.getParams());
    });
    __publicField3(this, "effect", (keys) => {
      const strs = isFunction(keys) ? keys(this.getParams()) : keys;
      if (!strs) return;
      const fns = strs.map((s2) => {
        const fn = this.machine.implementations?.effects?.[s2];
        if (!fn) warn(`[zag-js] No implementation found for effect "${JSON.stringify(s2)}"`);
        return fn;
      });
      const cleanups = [];
      for (const fn of fns) {
        const cleanup = fn?.(this.getParams());
        if (cleanup) cleanups.push(cleanup);
      }
      return () => cleanups.forEach((fn) => fn?.());
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
      this.machine.watch?.(this.getParams());
    });
    __publicField3(this, "callTrackers", () => {
      this.trackers.forEach(({ deps, fn }) => {
        const next = deps.map((dep) => dep());
        if (!isEqual2(fn.prev, next)) {
          fn();
          fn.prev = next;
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
      const __props = runIfFn(this.userPropsRef.current);
      const props13 = machine14.props?.({ props: compact(__props), scope: this.scope }) ?? __props;
      return props13[key];
    };
    this.prop = prop;
    const context = machine14.context?.({
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
        return context?.[key].get();
      },
      set(key, value) {
        context?.[key].set(value);
      },
      initial(key) {
        return context?.[key].initial;
      },
      hash(key) {
        const current = context?.[key].get();
        return context?.[key].hash(current);
      }
    };
    this.context = ctx;
    const computed = (key) => {
      return machine14.computed?.[key]({
        context: ctx,
        event: this.getEvent(),
        prop,
        refs: this.refs,
        scope: this.scope,
        computed
      }) ?? {};
    };
    this.computed = computed;
    const refs = createRefs(machine14.refs?.({ prop, context: ctx }) ?? {});
    this.refs = refs;
    const state2 = bindable(() => ({
      defaultValue: machine14.initialState({ prop }),
      onChange: (nextState, prevState) => {
        if (prevState) {
          const exitEffects = this.effects.get(prevState);
          exitEffects?.();
          this.effects.delete(prevState);
        }
        if (prevState) {
          this.action(this.getStateConfig(prevState)?.exit);
        }
        this.action(this.transition?.actions);
        const cleanup = this.effect(this.getStateConfig(nextState)?.effects);
        if (cleanup) this.effects.set(nextState, cleanup);
        if (prevState === INIT_STATE) {
          this.action(machine14.entry);
          const cleanup2 = this.effect(machine14.effects);
          if (cleanup2) this.effects.set(INIT_STATE, cleanup2);
        }
        this.action(this.getStateConfig(nextState)?.entry);
      }
    }));
    this.state = state2;
    this.cleanups.push(subscribe(this.state.ref, () => this.notify()));
  }
  updateProps(newProps) {
    const prevSource = this.userPropsRef.current;
    this.userPropsRef.current = () => {
      const prev = runIfFn(prevSource);
      const next = runIfFn(newProps);
      return mergeMachineProps(prev, next);
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
    this.effects.forEach((fn) => fn?.());
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

// lib/core.ts
var Component = class {
  el;
  doc;
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  machine;
  api;
  constructor(el, props13) {
    if (!el) throw new Error("Root element not found");
    this.el = el;
    this.doc = document;
    this.machine = this.initMachine(props13);
    this.api = this.initApi();
  }
  init = () => {
    this.render();
    this.machine.subscribe(() => {
      this.api = this.initApi();
      this.render();
    });
    this.machine.start();
  };
  destroy = () => {
    this.machine.stop();
  };
  spreadProps = (el, props13) => {
    spreadProps(el, props13, this.machine.scope.id);
  };
  updateProps = (props13) => {
    this.machine.updateProps(props13);
  };
};

// components/accordion.ts
var Accordion = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props13) {
    return new VanillaMachine(machine, props13);
  }
  initApi() {
    return connect(this.machine.service, normalizeProps);
  }
  render() {
    const rootEl = this.el.querySelector('[data-scope="accordion"][data-part="root"]');
    if (!rootEl) return;
    this.spreadProps(rootEl, this.api.getRootProps());
    const items = rootEl.querySelectorAll(
      ':scope > [data-scope="accordion"][data-part="item"]'
    );
    for (let i2 = 0; i2 < items.length; i2++) {
      const itemEl = items[i2];
      const value = itemEl.dataset.value;
      if (!value) continue;
      const disabled = itemEl.hasAttribute("data-disabled");
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
};

// lib/util.ts
var getString = (element, attrName, validValues) => {
  const value = element.dataset[attrName];
  if (value !== void 0 && (!validValues || validValues.includes(value))) {
    return value;
  }
  return void 0;
};
var getStringList = (element, attrName) => {
  const value = element.dataset[attrName];
  if (typeof value === "string") {
    return value.split(",").map((v2) => v2.trim()).filter((v2) => v2.length > 0);
  }
  return void 0;
};
var getNumber = (element, attrName, validValues) => {
  const raw = element.dataset[attrName];
  if (raw === void 0) return void 0;
  const parsed = Number(raw);
  if (Number.isNaN(parsed)) return void 0;
  if (validValues && !validValues.includes(parsed)) return 0;
  return parsed;
};
var getBoolean = (element, attrName) => {
  const dashName = attrName.replace(/([A-Z])/g, "-$1").toLowerCase();
  return element.hasAttribute(`data-${dashName}`);
};
var generateId = (element, fallbackId = "element") => {
  if (element?.id) return element.id;
  return `${fallbackId}-${Math.random().toString(36).substring(2, 9)}`;
};

// hooks/accordion.ts
var AccordionHook = {
  mounted() {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const accordion = new Accordion(
      el,
      {
        id: el.id,
        ...getBoolean(el, "controlled") ? { value: getStringList(el, "value") } : { defaultValue: getStringList(el, "defaultValue") },
        collapsible: getBoolean(el, "collapsible"),
        disabled: getBoolean(el, "disabled"),
        multiple: getBoolean(el, "multiple"),
        orientation: getString(el, "orientation", ["horizontal", "vertical"]),
        dir: getString(el, "dir", ["ltr", "rtl"]),
        onValueChange: (details) => {
          const eventName = getString(el, "onValueChange");
          if (eventName && this.liveSocket.main.isConnected()) {
            pushEvent(eventName, {
              id: el.id,
              value: details.value ?? null
            });
          }
          const eventNameClient = getString(el, "onValueChangeClient");
          if (eventNameClient) {
            el.dispatchEvent(
              new CustomEvent(eventNameClient, {
                bubbles: true,
                detail: {
                  id: el.id,
                  value: details.value ?? null
                }
              })
            );
          }
        },
        onFocusChange: (details) => {
          const eventName = getString(el, "onFocusChange");
          if (eventName && this.liveSocket.main.isConnected()) {
            pushEvent(eventName, {
              id: el.id,
              value: details.value ?? null
            });
          }
          const eventNameClient = getString(el, "onFocusChangeClient");
          if (eventNameClient) {
            el.dispatchEvent(
              new CustomEvent(eventNameClient, {
                bubbles: true,
                detail: {
                  id: el.id,
                  value: details.value ?? null
                }
              })
            );
          }
        }
      }
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
          if (targetId && targetId !== el.id) return;
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
    this.accordion?.updateProps({
      id: this.el.id,
      ...getBoolean(this.el, "controlled") ? { value: getStringList(this.el, "value") } : { defaultValue: getStringList(this.el, "defaultValue") },
      collapsible: getBoolean(this.el, "collapsible"),
      disabled: getBoolean(this.el, "disabled"),
      multiple: getBoolean(this.el, "multiple"),
      orientation: getString(this.el, "orientation", ["horizontal", "vertical"]),
      dir: getString(this.el, "dir", ["ltr", "rtl"])
    });
    const wasFocused = this.accordion?.api?.focusedValue;
    if (wasFocused) {
      const triggerEl = this.el.querySelector(
        `[data-scope="accordion"][data-part="item"][data-value="${wasFocused}"] [data-part="item-trigger"]`
      );
      if (triggerEl && document.activeElement !== triggerEl) {
        triggerEl.focus();
      }
    }
  },
  destroyed() {
    if (this.onSetValue) {
      this.el.removeEventListener("phx:accordion:set-value", this.onSetValue);
    }
    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }
    this.accordion?.destroy();
  }
};

// ../node_modules/.pnpm/@zag-js+interact-outside@1.33.1/node_modules/@zag-js/interact-outside/dist/index.mjs
function getWindowFrames(win) {
  const frames = {
    each(cb) {
      for (let i2 = 0; i2 < win.frames?.length; i2 += 1) {
        const frame = win.frames[i2];
        if (frame) cb(frame);
      }
    },
    addEventListener(event, listener, options) {
      frames.each((frame) => {
        try {
          frame.document.addEventListener(event, listener, options);
        } catch {
        }
      });
      return () => {
        try {
          frames.removeEventListener(event, listener, options);
        } catch {
        }
      };
    },
    removeEventListener(event, listener, options) {
      frames.each((frame) => {
        try {
          frame.document.removeEventListener(event, listener, options);
        } catch {
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
        parent?.addEventListener(event, listener, options);
      } catch {
      }
      return () => {
        try {
          parent?.removeEventListener(event, listener, options);
        } catch {
        }
      };
    },
    removeEventListener: (event, listener, options) => {
      try {
        parent?.removeEventListener(event, listener, options);
      } catch {
      }
    }
  };
}
var POINTER_OUTSIDE_EVENT = "pointerdown.outside";
var FOCUS_OUTSIDE_EVENT = "focus.outside";
function isComposedPathFocusable(composedPath) {
  for (const node of composedPath) {
    if (isHTMLElement(node) && isFocusable(node)) return true;
  }
  return false;
}
var isPointerEvent = (event) => "clientY" in event;
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
    return !exclude?.(target);
  }
  const pointerdownCleanups = /* @__PURE__ */ new Set();
  const isInShadowRoot = isShadowRoot(node?.getRootNode());
  function onPointerDown(event) {
    function handler(clickEvent) {
      const func = defer && !isTouchDevice() ? raf : (v2) => v2();
      const evt = clickEvent ?? event;
      const composedPath = evt?.composedPath?.() ?? [evt?.target];
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
      const composedPath = event?.composedPath?.() ?? [event?.target];
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
    cleanups.forEach((fn) => fn?.());
  };
}
function fireCustomEvent(el, type, init) {
  const win = el.ownerDocument.defaultView || window;
  const event = new win.CustomEvent(type, init);
  return el.dispatchEvent(event);
}

// ../node_modules/.pnpm/@zag-js+dismissable@1.33.1/node_modules/@zag-js/dismissable/dist/index.mjs
function trackEscapeKeydown(node, fn) {
  const handleKeyDown = (event) => {
    if (event.key !== "Escape") return;
    if (event.isComposing) return;
    fn?.(event);
  };
  return addDomEvent(getDocument(node), "keydown", handleKeyDown, { capture: true });
}
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
      layer.requestDismiss?.(event);
      if (!event.defaultPrevented) {
        layer?.dismiss();
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
function fireCustomEvent2(el, type, detail) {
  const win = el.ownerDocument.defaultView || window;
  const event = new win.CustomEvent(type, { cancelable: true, bubbles: true, detail });
  return el.dispatchEvent(event);
}
function addListenerOnce(el, type, callback) {
  el.addEventListener(type, callback, { once: true });
}
var originalBodyPointerEvents;
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
    if (!node) return false;
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
    cleanups.forEach((fn) => fn?.());
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
    cleanups.forEach((fn) => fn?.());
  };
}

// ../node_modules/.pnpm/@zag-js+toast@1.33.1/node_modules/@zag-js/toast/dist/index.mjs
var anatomy2 = createAnatomy("toast").parts(
  "group",
  "root",
  "title",
  "description",
  "actionTrigger",
  "closeTrigger"
);
var parts2 = anatomy2.build();
var getRegionId = (placement) => `toast-group:${placement}`;
var getRegionEl = (ctx, placement) => ctx.getById(`toast-group:${placement}`);
var getRootId2 = (ctx) => `toast:${ctx.id}`;
var getRootEl2 = (ctx) => ctx.getById(getRootId2(ctx));
var getTitleId = (ctx) => `toast:${ctx.id}:title`;
var getDescriptionId = (ctx) => `toast:${ctx.id}:description`;
var getCloseTriggerId = (ctx) => `toast${ctx.id}:close`;
var defaultTimeouts = {
  info: 5e3,
  error: 5e3,
  success: 2e3,
  loading: Infinity,
  DEFAULT: 5e3
};
function getToastDuration(duration, type) {
  return duration ?? defaultTimeouts[type] ?? defaultTimeouts.DEFAULT;
}
var getOffsets = (offsets) => typeof offsets === "string" ? { left: offsets, right: offsets, bottom: offsets, top: offsets } : offsets;
function getGroupPlacementStyle(service, placement) {
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
    "--first-height": `${heights[0]?.height || 0}px`,
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
      return normalize.element({
        ...parts2.group.attrs,
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
      });
    },
    subscribe(fn) {
      const store = prop("store");
      return store.subscribe(() => fn(context.get("toasts")));
    }
  };
}
var { guards, createMachine: createMachine2 } = setup();
var { and: and2 } = guards;
var groupMachine = createMachine2({
  props({ props: props13 }) {
    return {
      dir: "ltr",
      id: uuid(),
      ...props13,
      store: props13.store
    };
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
        guard: and2("isOverlapping", "isPointerOut"),
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
            context.set("toasts", (prev) => prev.filter((t2) => t2.id !== toast.id));
            return;
          }
          context.set("toasts", (prev) => {
            const index = prev.findIndex((t2) => t2.id === toast.id);
            if (index !== -1) {
              return [...prev.slice(0, index), { ...prev[index], ...toast }, ...prev.slice(index + 1)];
            }
            return [toast, ...prev];
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
        const toasts = context.get("toasts");
        const placement = computed("placement");
        const hasToasts = toasts.length > 0;
        if (!hasToasts) {
          refs.get("dismissableCleanup")?.();
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
        refs.get("dismissableCleanup")?.();
      },
      focusRegionEl({ scope, computed }) {
        queueMicrotask(() => {
          getRegionEl(scope, computed("placement"))?.focus();
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
        if (event?.id == null) return;
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
        if (!refs.get("lastFocusedEl") || refs.get("isPointerWithin")) return;
        refs.get("lastFocusedEl")?.focus({ preventScroll: true });
        refs.set("lastFocusedEl", null);
        refs.set("isFocusWithin", false);
      },
      setPointerWithin({ refs }) {
        refs.set("isPointerWithin", true);
      },
      clearPointerWithin({ refs }) {
        refs.set("isPointerWithin", false);
        if (refs.get("lastFocusedEl") && !refs.get("isFocusWithin")) {
          refs.get("lastFocusedEl")?.focus({ preventScroll: true });
          refs.set("lastFocusedEl", null);
        }
      },
      clearFocusWithin({ refs }) {
        refs.set("isFocusWithin", false);
      },
      clearLastFocusedEl({ refs }) {
        if (!refs.get("lastFocusedEl")) return;
        refs.get("lastFocusedEl")?.focus({ preventScroll: true });
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
function connect2(service, normalize) {
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
      return normalize.element({
        ...parts2.root.attrs,
        dir: prop("dir"),
        id: getRootId2(scope),
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
        "aria-describedby": description ? getDescriptionId(scope) : void 0,
        "aria-labelledby": title ? getTitleId(scope) : void 0,
        tabIndex: 0,
        style: getPlacementStyle(service, visible),
        onKeyDown(event) {
          if (event.defaultPrevented) return;
          if (event.key == "Escape") {
            send({ type: "DISMISS", src: "keyboard" });
            event.preventDefault();
          }
        }
      });
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
      return normalize.element({
        ...parts2.title.attrs,
        id: getTitleId(scope)
      });
    },
    getDescriptionProps() {
      return normalize.element({
        ...parts2.description.attrs,
        id: getDescriptionId(scope)
      });
    },
    getActionTriggerProps() {
      return normalize.button({
        ...parts2.actionTrigger.attrs,
        type: "button",
        onClick(event) {
          if (event.defaultPrevented) return;
          action?.onClick?.();
          send({ type: "DISMISS", src: "user" });
        }
      });
    },
    getCloseTriggerProps() {
      return normalize.button({
        id: getCloseTriggerId(scope),
        ...parts2.closeTrigger.attrs,
        type: "button",
        "aria-label": "Dismiss notification",
        onClick(event) {
          if (event.defaultPrevented) return;
          send({ type: "DISMISS", src: "user" });
        }
      });
    }
  };
}
var { not: not2 } = createGuards();
var machine2 = createMachine({
  props({ props: props13 }) {
    ensureProps(props13, ["id", "type", "parent", "removeDelay"], "toast");
    return {
      closable: true,
      ...props13,
      duration: getToastDuration(props13.duration, props13.type)
    };
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
      const heights = prop("parent").context.get("heights");
      const height = heights.find((height2) => height2.id === prop("id"));
      return height?.height ?? 0;
    },
    heightIndex: ({ prop }) => {
      const heights = prop("parent").context.get("heights");
      return heights.findIndex((height) => height.id === prop("id"));
    },
    frontmost: ({ prop }) => prop("index") === 0,
    heightBefore: ({ prop }) => {
      const heights = prop("parent").context.get("heights");
      const heightIndex = heights.findIndex((height) => height.id === prop("id"));
      return heights.reduce((prev, curr, reducerIndex) => {
        if (reducerIndex >= heightIndex) return prev;
        return prev + curr.height;
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
          guard: not2("isLoadingType"),
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
          const rootEl = getRootEl2(scope);
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
        return () => cleanup?.();
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
          const rootEl = getRootEl2(scope);
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
        context.set("remainingTime", (prev) => {
          const closeTimerStartTime = refs.get("closeTimerStartTime");
          const elapsedTime = Date.now() - closeTimerStartTime;
          refs.set("lastCloseStartTimerStartTime", Date.now());
          return prev - elapsedTime;
        });
      },
      notifyParentToRemove({ prop }) {
        const parent = prop("parent");
        parent.send({ type: "TOAST.REMOVE", id: prop("id") });
      },
      invokeOnDismiss({ prop, event }) {
        prop("onStatusChange")?.({ status: "dismissing", src: event.src });
      },
      invokeOnUnmount({ prop }) {
        prop("onStatusChange")?.({ status: "unmounted" });
      },
      invokeOnVisible({ prop }) {
        prop("onStatusChange")?.({ status: "visible" });
      }
    }
  }
});
function setHeight(parent, item) {
  const { id, height } = item;
  parent.context.set("heights", (prev) => {
    const alreadyExists = prev.find((i2) => i2.id === id);
    if (!alreadyExists) {
      return [{ id, height }, ...prev];
    } else {
      return prev.map((i2) => i2.id === id ? { ...i2, height } : i2);
    }
  });
}
var withDefaults = (options, defaults) => {
  return { ...defaults, ...compact(options) };
};
function createToastStore(props13 = {}) {
  const attrs = withDefaults(props13, {
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
    const id = data.id ?? `toast:${uuid()}`;
    const exists = toasts.find((toast) => toast.id === id);
    if (dismissedToasts.has(id)) dismissedToasts.delete(id);
    if (exists) {
      toasts = toasts.map((toast) => {
        if (toast.id === id) {
          return publish({ ...toast, ...data, id });
        }
        return toast;
      });
    } else {
      addToast({
        id,
        duration: attrs.duration,
        removeDelay: attrs.removeDelay,
        type: "info",
        ...data,
        stacked: !attrs.overlap,
        gap: attrs.gap
      });
    }
    return id;
  };
  const remove2 = (id) => {
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
    return create({ ...data, type: "error" });
  };
  const success = (data) => {
    return create({ ...data, type: "success" });
  };
  const info = (data) => {
    return create({ ...data, type: "info" });
  };
  const warning = (data) => {
    return create({ ...data, type: "warning" });
  };
  const loading = (data) => {
    return create({ ...data, type: "loading" });
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
    const id = create({
      ...shared,
      ...options.loading,
      promise: promise2,
      type: "loading"
    });
    let removable = true;
    let result;
    const prom = runIfFn(promise2).then(async (response) => {
      result = ["resolve", response];
      if (isHttpResponse(response) && !response.ok) {
        removable = false;
        const errorOptions = runIfFn(options.error, `HTTP Error! status: ${response.status}`);
        create({ ...shared, ...errorOptions, id, type: "error" });
      } else if (options.success !== void 0) {
        removable = false;
        const successOptions = runIfFn(options.success, response);
        create({ ...shared, ...successOptions, id, type: "success" });
      }
    }).catch(async (error2) => {
      result = ["reject", error2];
      if (options.error !== void 0) {
        removable = false;
        const errorOptions = runIfFn(options.error, error2);
        create({ ...shared, ...errorOptions, id, type: "error" });
      }
    }).finally(() => {
      if (removable) {
        remove2(id);
      }
      options.finally?.();
    });
    const unwrap = () => new Promise(
      (resolve, reject) => prom.then(() => result[0] === "reject" ? reject(result[1]) : resolve(result[1])).catch(reject)
    );
    return { id, unwrap };
  };
  const update = (id, data) => {
    return create({ id, ...data });
  };
  const pause = (id) => {
    if (id != null) {
      toasts = toasts.map((toast) => {
        if (toast.id === id) return publish({ ...toast, message: "PAUSE" });
        return toast;
      });
    } else {
      toasts = toasts.map((toast) => publish({ ...toast, message: "PAUSE" }));
    }
  };
  const resume = (id) => {
    if (id != null) {
      toasts = toasts.map((toast) => {
        if (toast.id === id) return publish({ ...toast, message: "RESUME" });
        return toast;
      });
    } else {
      toasts = toasts.map((toast) => publish({ ...toast, message: "RESUME" }));
    }
  };
  const dismiss = (id) => {
    if (id != null) {
      toasts = toasts.map((toast) => {
        if (toast.id === id) return publish({ ...toast, message: "DISMISS" });
        return toast;
      });
    } else {
      toasts = toasts.map((toast) => publish({ ...toast, message: "DISMISS" }));
    }
  };
  const isVisible = (id) => {
    return !dismissedToasts.has(id) && !!toasts.find((toast) => toast.id === id);
  };
  const isDismissed = (id) => {
    return dismissedToasts.has(id);
  };
  const expand = () => {
    toasts = toasts.map((toast) => publish({ ...toast, stacked: true }));
  };
  const collapse = () => {
    toasts = toasts.map((toast) => publish({ ...toast, stacked: false }));
  };
  return {
    attrs,
    subscribe: subscribe2,
    create,
    update,
    remove: remove2,
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
var isHttpResponse = (data) => {
  return data && typeof data === "object" && "ok" in data && typeof data.ok === "boolean" && "status" in data && typeof data.status === "number";
};
var group = {
  connect: groupConnect,
  machine: groupMachine
};

// components/toast.ts
var toastGroups = /* @__PURE__ */ new Map();
var toastStores = /* @__PURE__ */ new Map();
var ToastItem = class extends Component {
  parts;
  duration;
  constructor(el, props13) {
    super(el, props13);
    this.duration = props13.duration;
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
  initMachine(props13) {
    return new VanillaMachine(machine2, props13);
  }
  initApi() {
    return connect2(this.machine.service, normalizeProps);
  }
  render() {
    this.spreadProps(this.el, this.api.getRootProps());
    this.spreadProps(this.parts.close, this.api.getCloseTriggerProps());
    this.spreadProps(this.parts.ghostBefore, this.api.getGhostBeforeProps());
    this.spreadProps(this.parts.ghostAfter, this.api.getGhostAfterProps());
    if (this.parts.title.textContent !== this.api.title) {
      this.parts.title.textContent = this.api.title ?? "";
    }
    if (this.parts.description.textContent !== this.api.description) {
      this.parts.description.textContent = this.api.description ?? "";
    }
    this.spreadProps(this.parts.title, this.api.getTitleProps());
    this.spreadProps(this.parts.description, this.api.getDescriptionProps());
    const duration = this.duration;
    const isInfinity = duration === "Infinity" || duration === Infinity || duration === Number.POSITIVE_INFINITY;
    const toastGroup = this.el.closest('[phx-hook="Toast"]');
    const loadingIconTemplate = toastGroup?.querySelector("[data-loading-icon-template]");
    const loadingIcon = loadingIconTemplate?.innerHTML;
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
  destroy = () => {
    this.machine.stop();
    this.el.remove();
  };
};
var ToastGroup = class extends Component {
  toastComponents = /* @__PURE__ */ new Map();
  groupEl;
  store;
  constructor(el, props13) {
    super(el, props13);
    this.store = props13.store;
    this.groupEl = el.querySelector('[data-part="group"]') ?? (() => {
      const g2 = document.createElement("div");
      g2.setAttribute("data-scope", "toast");
      g2.setAttribute("data-part", "group");
      el.appendChild(g2);
      return g2;
    })();
  }
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props13) {
    return new VanillaMachine(group.machine, props13);
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
        item = new ToastItem(el, {
          ...toastData,
          parent: this.machine.service,
          index
        });
        item.init();
        this.toastComponents.set(toastData.id, item);
      } else {
        item.duration = toastData.duration;
        item.updateProps({
          ...toastData,
          parent: this.machine.service,
          index
        });
      }
    });
    for (const [id, comp] of this.toastComponents) {
      if (!nextIds.has(id)) {
        comp.destroy();
        this.toastComponents.delete(id);
      }
    }
  }
  destroy = () => {
    for (const comp of this.toastComponents.values()) {
      comp.destroy();
    }
    this.toastComponents.clear();
    this.machine.stop();
  };
};
function createToastGroup(container, options) {
  const groupId = options?.id ?? generateId(container, "toast");
  const store = options?.store ?? createToastStore({
    placement: options?.placement ?? "bottom",
    overlap: options?.overlap,
    max: options?.max,
    gap: options?.gap,
    offsets: options?.offsets,
    pauseOnPageIdle: options?.pauseOnPageIdle
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

// hooks/toast.ts
var ToastHook = {
  mounted() {
    const el = this.el;
    if (!el.id) {
      el.id = generateId(el, "toast");
    }
    this.groupId = el.id;
    const parseOffsets = (offsetsString) => {
      if (!offsetsString) return void 0;
      try {
        return offsetsString.includes("{") ? JSON.parse(offsetsString) : offsetsString;
      } catch {
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
    const placement = getString(el, "placement", [
      "top-start",
      "top",
      "top-end",
      "bottom-start",
      "bottom",
      "bottom-end"
    ]) ?? "bottom-end";
    createToastGroup(el, {
      id: this.groupId,
      placement,
      overlap: getBoolean(el, "overlap"),
      max: getNumber(el, "max"),
      gap: getNumber(el, "gap"),
      offsets: parseOffsets(getString(el, "offset")),
      pauseOnPageIdle: getBoolean(el, "pauseOnPageIdle")
    });
    this.handlers = [];
    this.handlers.push(
      this.handleEvent("toast-create", (payload) => {
        const store = getToastStore(payload.groupId || this.groupId);
        if (!store) return;
        try {
          store.create({
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
        const store = getToastStore(payload.groupId || this.groupId);
        if (!store) return;
        try {
          store.update(payload.id, {
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
        const store = getToastStore(payload.groupId || this.groupId);
        if (!store) return;
        try {
          store.dismiss(payload.id);
        } catch (error) {
          console.error("Failed to dismiss toast:", error);
        }
      })
    );
    el.addEventListener("toast:create", (event) => {
      const { detail } = event;
      const store = getToastStore(detail.groupId || this.groupId);
      if (!store) return;
      try {
        store.create({
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

// ../node_modules/.pnpm/@zag-js+toggle-group@1.33.1/node_modules/@zag-js/toggle-group/dist/index.mjs
var anatomy3 = createAnatomy("toggle-group").parts("root", "item");
var parts3 = anatomy3.build();
var getRootId3 = (ctx) => ctx.ids?.root ?? `toggle-group:${ctx.id}`;
var getItemId2 = (ctx, value) => ctx.ids?.item?.(value) ?? `toggle-group:${ctx.id}:${value}`;
var getRootEl3 = (ctx) => ctx.getById(getRootId3(ctx));
var getElements = (ctx) => {
  const ownerId = CSS.escape(getRootId3(ctx));
  const selector = `[data-ownedby='${ownerId}']:not([data-disabled])`;
  return queryAll(getRootEl3(ctx), selector);
};
var getFirstEl = (ctx) => first(getElements(ctx));
var getLastEl = (ctx) => last(getElements(ctx));
var getNextEl = (ctx, id, loopFocus) => nextById(getElements(ctx), id, loopFocus);
var getPrevEl = (ctx, id, loopFocus) => prevById(getElements(ctx), id, loopFocus);
function connect3(service, normalize) {
  const { context, send, prop, scope } = service;
  const value = context.get("value");
  const disabled = prop("disabled");
  const isSingle = !prop("multiple");
  const rovingFocus = prop("rovingFocus");
  const isHorizontal = prop("orientation") === "horizontal";
  function getItemState(props22) {
    const id = getItemId2(scope, props22.value);
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
      return normalize.element({
        ...parts3.root.attrs,
        id: getRootId3(scope),
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
      });
    },
    getItemState,
    getItemProps(props22) {
      const itemState = getItemState(props22);
      const rovingTabIndex = itemState.focused ? 0 : -1;
      return normalize.button({
        ...parts3.item.attrs,
        id: itemState.id,
        type: "button",
        "data-ownedby": getRootId3(scope),
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
      });
    }
  };
}
var { not: not3, and: and3 } = createGuards();
var machine3 = createMachine({
  props({ props: props22 }) {
    return {
      defaultValue: [],
      orientation: "horizontal",
      rovingFocus: true,
      loopFocus: true,
      deselectable: true,
      ...props22
    };
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
          prop("onValueChange")?.({ value });
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
          guard: not3(and3("isClickFocus", "isTabbingBackward")),
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
            guard: not3("isFirstToggleFocused"),
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
      isFirstToggleFocused: ({ context, scope }) => context.get("focusedId") === getFirstEl(scope)?.id
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
        const closestToolbar = getRootEl3(scope)?.closest("[role=toolbar]");
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
        let next = context.get("value");
        if (isArray(event.value)) {
          next = event.value;
        } else if (prop("multiple")) {
          next = addOrRemove(next, event.value);
        } else {
          const isSelected = isEqual2(next, [event.value]);
          next = isSelected && prop("deselectable") ? [] : [event.value];
        }
        context.set("value", next);
      },
      focusNextToggle({ context, scope, prop }) {
        raf(() => {
          const focusedId = context.get("focusedId");
          if (!focusedId) return;
          getNextEl(scope, focusedId, prop("loopFocus"))?.focus({ preventScroll: true });
        });
      },
      focusPrevToggle({ context, scope, prop }) {
        raf(() => {
          const focusedId = context.get("focusedId");
          if (!focusedId) return;
          getPrevEl(scope, focusedId, prop("loopFocus"))?.focus({ preventScroll: true });
        });
      },
      focusFirstToggle({ scope }) {
        raf(() => {
          getFirstEl(scope)?.focus({ preventScroll: true });
        });
      },
      focusLastToggle({ scope }) {
        raf(() => {
          getLastEl(scope)?.focus({ preventScroll: true });
        });
      }
    }
  }
});
var props2 = createProps()([
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
var splitProps3 = createSplitProps(props2);
var itemProps2 = createProps()(["value", "disabled"]);
var splitItemProps2 = createSplitProps(itemProps2);

// components/toggle-group.ts
var ToggleGroup = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props13) {
    return new VanillaMachine(machine3, props13);
  }
  initApi() {
    return connect3(this.machine.service, normalizeProps);
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

// hooks/toggle-group.ts
var ToggleGroupHook = {
  mounted() {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const props13 = {
      id: el.id,
      ...getBoolean(el, "controlled") ? { value: getStringList(el, "value") } : { defaultValue: getStringList(el, "defaultValue") },
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
    };
    const toggleGroup = new ToggleGroup(el, props13);
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
    this.toggleGroup?.updateProps({
      ...getBoolean(this.el, "controlled") ? { value: getStringList(this.el, "value") } : { defaultValue: getStringList(this.el, "defaultValue") },
      deselectable: getBoolean(this.el, "deselectable"),
      loopFocus: getBoolean(this.el, "loopFocus"),
      rovingFocus: getBoolean(this.el, "rovingFocus"),
      disabled: getBoolean(this.el, "disabled"),
      multiple: getBoolean(this.el, "multiple"),
      orientation: getString(this.el, "orientation", ["horizontal", "vertical"]),
      dir: getString(this.el, "dir", ["ltr", "rtl"])
    });
  },
  destroyed() {
    if (this.onSetValue) {
      this.el.removeEventListener("phx:toggle-group:set-value", this.onSetValue);
    }
    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }
    this.toggleGroup?.destroy();
  }
};

// ../node_modules/.pnpm/@zag-js+collection@1.33.1/node_modules/@zag-js/collection/dist/index.mjs
var __defProp5 = Object.defineProperty;
var __defNormalProp4 = (obj, key, value) => key in obj ? __defProp5(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
var __publicField4 = (obj, key, value) => __defNormalProp4(obj, typeof key !== "symbol" ? key + "" : key, value);
var fallback = {
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
var ListCollection = class _ListCollection {
  constructor(options) {
    this.options = options;
    __publicField4(this, "items");
    __publicField4(this, "indexMap", null);
    __publicField4(this, "copy", (items) => {
      return new _ListCollection({ ...this.options, items: items ?? [...this.items] });
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
      if (!this.options.groupBy && !this.options.groupSort) {
        return this.items[index] ?? null;
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
      return (indexA ?? 0) - (indexB ?? 0);
    });
    __publicField4(this, "sort", (values) => {
      return [...values].sort(this.sortFn.bind(this));
    });
    __publicField4(this, "getItemValue", (item) => {
      if (item == null) return null;
      return this.options.itemToValue?.(item) ?? fallback.itemToValue(item);
    });
    __publicField4(this, "getItemDisabled", (item) => {
      if (item == null) return false;
      return this.options.isItemDisabled?.(item) ?? fallback.isItemDisabled(item);
    });
    __publicField4(this, "stringifyItem", (item) => {
      if (item == null) return null;
      return this.options.itemToString?.(item) ?? fallback.itemToString(item);
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
      return this.indexMap.get(value) ?? -1;
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
    yield* this.items;
  }
};
var match3 = (label, query2) => {
  return !!label?.toLowerCase().startsWith(query2.toLowerCase());
};
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

// ../node_modules/.pnpm/@floating-ui+utils@0.2.10/node_modules/@floating-ui/utils/dist/floating-ui.utils.mjs
var sides = ["top", "right", "bottom", "left"];
var min2 = Math.min;
var max2 = Math.max;
var round2 = Math.round;
var floor2 = Math.floor;
var createCoords = (v2) => ({
  x: v2,
  y: v2
});
var oppositeSideMap = {
  left: "right",
  right: "left",
  bottom: "top",
  top: "bottom"
};
var oppositeAlignmentMap = {
  start: "end",
  end: "start"
};
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
var yAxisSides = /* @__PURE__ */ new Set(["top", "bottom"]);
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
var lrPlacement = ["left", "right"];
var rlPlacement = ["right", "left"];
var tbPlacement = ["top", "bottom"];
var btPlacement = ["bottom", "top"];
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
  return {
    top: 0,
    right: 0,
    bottom: 0,
    left: 0,
    ...padding
  };
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

// ../node_modules/.pnpm/@floating-ui+core@1.7.4/node_modules/@floating-ui/core/dist/floating-ui.core.mjs
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
async function detectOverflow(state2, options) {
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
  const clippingClientRect = rectToClientRect(await platform2.getClippingRect({
    element: ((_await$platform$isEle = await (platform2.isElement == null ? void 0 : platform2.isElement(element))) != null ? _await$platform$isEle : true) ? element : element.contextElement || await (platform2.getDocumentElement == null ? void 0 : platform2.getDocumentElement(elements.floating)),
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
  const offsetParent = await (platform2.getOffsetParent == null ? void 0 : platform2.getOffsetParent(elements.floating));
  const offsetScale = await (platform2.isElement == null ? void 0 : platform2.isElement(offsetParent)) ? await (platform2.getScale == null ? void 0 : platform2.getScale(offsetParent)) || {
    x: 1,
    y: 1
  } : {
    x: 1,
    y: 1
  };
  const elementClientRect = rectToClientRect(platform2.convertOffsetParentRelativeRectToViewportRelativeRect ? await platform2.convertOffsetParentRelativeRectToViewportRelativeRect({
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
}
var computePosition = async (reference, floating, config) => {
  const {
    placement = "bottom",
    strategy = "absolute",
    middleware = [],
    platform: platform2
  } = config;
  const validMiddleware = middleware.filter(Boolean);
  const rtl = await (platform2.isRTL == null ? void 0 : platform2.isRTL(floating));
  let rects = await platform2.getElementRects({
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
    } = await fn({
      x: x2,
      y: y2,
      initialPlacement: placement,
      placement: statefulPlacement,
      strategy,
      middlewareData,
      rects,
      platform: {
        ...platform2,
        detectOverflow: (_platform$detectOverf = platform2.detectOverflow) != null ? _platform$detectOverf : detectOverflow
      },
      elements: {
        reference,
        floating
      }
    });
    x2 = nextX != null ? nextX : x2;
    y2 = nextY != null ? nextY : y2;
    middlewareData = {
      ...middlewareData,
      [name]: {
        ...middlewareData[name],
        ...data
      }
    };
    if (reset && resetCount <= 50) {
      resetCount++;
      if (typeof reset === "object") {
        if (reset.placement) {
          statefulPlacement = reset.placement;
        }
        if (reset.rects) {
          rects = reset.rects === true ? await platform2.getElementRects({
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
};
var arrow = (options) => ({
  name: "arrow",
  options,
  async fn(state2) {
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
    const arrowDimensions = await platform2.getDimensions(element);
    const isYAxis = axis === "y";
    const minProp = isYAxis ? "top" : "left";
    const maxProp = isYAxis ? "bottom" : "right";
    const clientProp = isYAxis ? "clientHeight" : "clientWidth";
    const endDiff = rects.reference[length] + rects.reference[axis] - coords[axis] - rects.floating[length];
    const startDiff = coords[axis] - rects.reference[axis];
    const arrowOffsetParent = await (platform2.getOffsetParent == null ? void 0 : platform2.getOffsetParent(element));
    let clientSize = arrowOffsetParent ? arrowOffsetParent[clientProp] : 0;
    if (!clientSize || !await (platform2.isElement == null ? void 0 : platform2.isElement(arrowOffsetParent))) {
      clientSize = elements.floating[clientProp] || rects.floating[length];
    }
    const centerToReference = endDiff / 2 - startDiff / 2;
    const largestPossiblePadding = clientSize / 2 - arrowDimensions[length] / 2 - 1;
    const minPadding = min2(paddingObject[minProp], largestPossiblePadding);
    const maxPadding = min2(paddingObject[maxProp], largestPossiblePadding);
    const min$1 = minPadding;
    const max3 = clientSize - arrowDimensions[length] - maxPadding;
    const center = clientSize / 2 - arrowDimensions[length] / 2 + centerToReference;
    const offset3 = clamp2(min$1, center, max3);
    const shouldAddOffset = !middlewareData.arrow && getAlignment(placement) != null && center !== offset3 && rects.reference[length] / 2 - (center < min$1 ? minPadding : maxPadding) - arrowDimensions[length] / 2 < 0;
    const alignmentOffset = shouldAddOffset ? center < min$1 ? center - min$1 : center - max3 : 0;
    return {
      [axis]: coords[axis] + alignmentOffset,
      data: {
        [axis]: offset3,
        centerOffset: center - offset3 - alignmentOffset,
        ...shouldAddOffset && {
          alignmentOffset
        }
      },
      reset: shouldAddOffset
    };
  }
});
var flip = function(options) {
  if (options === void 0) {
    options = {};
  }
  return {
    name: "flip",
    options,
    async fn(state2) {
      var _middlewareData$arrow, _middlewareData$flip;
      const {
        placement,
        middlewareData,
        rects,
        initialPlacement,
        platform: platform2,
        elements
      } = state2;
      const {
        mainAxis: checkMainAxis = true,
        crossAxis: checkCrossAxis = true,
        fallbackPlacements: specifiedFallbackPlacements,
        fallbackStrategy = "bestFit",
        fallbackAxisSideDirection = "none",
        flipAlignment = true,
        ...detectOverflowOptions
      } = evaluate(options, state2);
      if ((_middlewareData$arrow = middlewareData.arrow) != null && _middlewareData$arrow.alignmentOffset) {
        return {};
      }
      const side = getSide(placement);
      const initialSideAxis = getSideAxis(initialPlacement);
      const isBasePlacement = getSide(initialPlacement) === initialPlacement;
      const rtl = await (platform2.isRTL == null ? void 0 : platform2.isRTL(elements.floating));
      const fallbackPlacements = specifiedFallbackPlacements || (isBasePlacement || !flipAlignment ? [getOppositePlacement(initialPlacement)] : getExpandedPlacements(initialPlacement));
      const hasFallbackAxisSideDirection = fallbackAxisSideDirection !== "none";
      if (!specifiedFallbackPlacements && hasFallbackAxisSideDirection) {
        fallbackPlacements.push(...getOppositeAxisPlacements(initialPlacement, flipAlignment, fallbackAxisSideDirection, rtl));
      }
      const placements2 = [initialPlacement, ...fallbackPlacements];
      const overflow = await platform2.detectOverflow(state2, detectOverflowOptions);
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
    }
  };
};
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
var hide = function(options) {
  if (options === void 0) {
    options = {};
  }
  return {
    name: "hide",
    options,
    async fn(state2) {
      const {
        rects,
        platform: platform2
      } = state2;
      const {
        strategy = "referenceHidden",
        ...detectOverflowOptions
      } = evaluate(options, state2);
      switch (strategy) {
        case "referenceHidden": {
          const overflow = await platform2.detectOverflow(state2, {
            ...detectOverflowOptions,
            elementContext: "reference"
          });
          const offsets = getSideOffsets(overflow, rects.reference);
          return {
            data: {
              referenceHiddenOffsets: offsets,
              referenceHidden: isAnySideFullyClipped(offsets)
            }
          };
        }
        case "escaped": {
          const overflow = await platform2.detectOverflow(state2, {
            ...detectOverflowOptions,
            altBoundary: true
          });
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
    }
  };
};
var originSides = /* @__PURE__ */ new Set(["left", "top"]);
async function convertValueToCoords(state2, options) {
  const {
    placement,
    platform: platform2,
    elements
  } = state2;
  const rtl = await (platform2.isRTL == null ? void 0 : platform2.isRTL(elements.floating));
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
}
var offset = function(options) {
  if (options === void 0) {
    options = 0;
  }
  return {
    name: "offset",
    options,
    async fn(state2) {
      var _middlewareData$offse, _middlewareData$arrow;
      const {
        x: x2,
        y: y2,
        placement,
        middlewareData
      } = state2;
      const diffCoords = await convertValueToCoords(state2, options);
      if (placement === ((_middlewareData$offse = middlewareData.offset) == null ? void 0 : _middlewareData$offse.placement) && (_middlewareData$arrow = middlewareData.arrow) != null && _middlewareData$arrow.alignmentOffset) {
        return {};
      }
      return {
        x: x2 + diffCoords.x,
        y: y2 + diffCoords.y,
        data: {
          ...diffCoords,
          placement
        }
      };
    }
  };
};
var shift = function(options) {
  if (options === void 0) {
    options = {};
  }
  return {
    name: "shift",
    options,
    async fn(state2) {
      const {
        x: x2,
        y: y2,
        placement,
        platform: platform2
      } = state2;
      const {
        mainAxis: checkMainAxis = true,
        crossAxis: checkCrossAxis = false,
        limiter = {
          fn: (_ref) => {
            let {
              x: x3,
              y: y3
            } = _ref;
            return {
              x: x3,
              y: y3
            };
          }
        },
        ...detectOverflowOptions
      } = evaluate(options, state2);
      const coords = {
        x: x2,
        y: y2
      };
      const overflow = await platform2.detectOverflow(state2, detectOverflowOptions);
      const crossAxis = getSideAxis(getSide(placement));
      const mainAxis = getOppositeAxis(crossAxis);
      let mainAxisCoord = coords[mainAxis];
      let crossAxisCoord = coords[crossAxis];
      if (checkMainAxis) {
        const minSide = mainAxis === "y" ? "top" : "left";
        const maxSide = mainAxis === "y" ? "bottom" : "right";
        const min3 = mainAxisCoord + overflow[minSide];
        const max3 = mainAxisCoord - overflow[maxSide];
        mainAxisCoord = clamp2(min3, mainAxisCoord, max3);
      }
      if (checkCrossAxis) {
        const minSide = crossAxis === "y" ? "top" : "left";
        const maxSide = crossAxis === "y" ? "bottom" : "right";
        const min3 = crossAxisCoord + overflow[minSide];
        const max3 = crossAxisCoord - overflow[maxSide];
        crossAxisCoord = clamp2(min3, crossAxisCoord, max3);
      }
      const limitedCoords = limiter.fn({
        ...state2,
        [mainAxis]: mainAxisCoord,
        [crossAxis]: crossAxisCoord
      });
      return {
        ...limitedCoords,
        data: {
          x: limitedCoords.x - x2,
          y: limitedCoords.y - y2,
          enabled: {
            [mainAxis]: checkMainAxis,
            [crossAxis]: checkCrossAxis
          }
        }
      };
    }
  };
};
var limitShift = function(options) {
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
      } : {
        mainAxis: 0,
        crossAxis: 0,
        ...rawOffset
      };
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
var size = function(options) {
  if (options === void 0) {
    options = {};
  }
  return {
    name: "size",
    options,
    async fn(state2) {
      var _state$middlewareData, _state$middlewareData2;
      const {
        placement,
        rects,
        platform: platform2,
        elements
      } = state2;
      const {
        apply = () => {
        },
        ...detectOverflowOptions
      } = evaluate(options, state2);
      const overflow = await platform2.detectOverflow(state2, detectOverflowOptions);
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
        widthSide = alignment === (await (platform2.isRTL == null ? void 0 : platform2.isRTL(elements.floating)) ? "start" : "end") ? "left" : "right";
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
      await apply({
        ...state2,
        availableWidth,
        availableHeight
      });
      const nextDimensions = await platform2.getDimensions(elements.floating);
      if (width !== nextDimensions.width || height !== nextDimensions.height) {
        return {
          reset: {
            rects: true
          }
        };
      }
      return {};
    }
  };
};

// ../node_modules/.pnpm/@floating-ui+utils@0.2.10/node_modules/@floating-ui/utils/dist/floating-ui.utils.dom.mjs
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
var invalidOverflowDisplayValues = /* @__PURE__ */ new Set(["inline", "contents"]);
function isOverflowElement2(element) {
  const {
    overflow,
    overflowX,
    overflowY,
    display
  } = getComputedStyle3(element);
  return /auto|scroll|overlay|hidden|clip/.test(overflow + overflowY + overflowX) && !invalidOverflowDisplayValues.has(display);
}
var tableElements = /* @__PURE__ */ new Set(["table", "td", "th"]);
function isTableElement(element) {
  return tableElements.has(getNodeName2(element));
}
var topLayerSelectors = [":popover-open", ":modal"];
function isTopLayer(element) {
  return topLayerSelectors.some((selector) => {
    try {
      return element.matches(selector);
    } catch (_e) {
      return false;
    }
  });
}
var transformProperties = ["transform", "translate", "scale", "rotate", "perspective"];
var willChangeValues = ["transform", "translate", "scale", "rotate", "perspective", "filter"];
var containValues = ["paint", "layout", "strict", "content"];
function isContainingBlock(elementOrCss) {
  const webkit = isWebKit();
  const css = isElement2(elementOrCss) ? getComputedStyle3(elementOrCss) : elementOrCss;
  return transformProperties.some((value) => css[value] ? css[value] !== "none" : false) || (css.containerType ? css.containerType !== "normal" : false) || !webkit && (css.backdropFilter ? css.backdropFilter !== "none" : false) || !webkit && (css.filter ? css.filter !== "none" : false) || willChangeValues.some((value) => (css.willChange || "").includes(value)) || containValues.some((value) => (css.contain || "").includes(value));
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
var lastTraversableNodeNames = /* @__PURE__ */ new Set(["html", "body", "#document"]);
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

// ../node_modules/.pnpm/@floating-ui+dom@1.7.5/node_modules/@floating-ui/dom/dist/floating-ui.dom.mjs
function getCssDimensions(element) {
  const css = getComputedStyle3(element);
  let width = parseFloat(css.width) || 0;
  let height = parseFloat(css.height) || 0;
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
var noOffsets = /* @__PURE__ */ createCoords(0);
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
      const css = getComputedStyle3(currentIFrame);
      const left = iframeRect.left + (currentIFrame.clientLeft + parseFloat(css.paddingLeft)) * iframeScale.x;
      const top = iframeRect.top + (currentIFrame.clientTop + parseFloat(css.paddingTop)) * iframeScale.y;
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
var SCROLLBAR_MAX = 25;
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
var absoluteOrFixed = /* @__PURE__ */ new Set(["absolute", "fixed"]);
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
var getElementRects = async function(data) {
  const getOffsetParentFn = this.getOffsetParent || getOffsetParent;
  const getDimensionsFn = this.getDimensions;
  const floatingDimensions = await getDimensionsFn(data.floating);
  return {
    reference: getRectRelativeToOffsetParent(data.reference, await getOffsetParentFn(data.floating), data.strategy),
    floating: {
      x: 0,
      y: 0,
      width: floatingDimensions.width,
      height: floatingDimensions.height
    }
  };
};
function isRTL(element) {
  return getComputedStyle3(element).direction === "rtl";
}
var platform = {
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
      io = new IntersectionObserver(handleObserve, {
        ...options,
        // Handle <iframe>s
        root: root.ownerDocument
      });
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
var offset2 = offset;
var shift2 = shift;
var flip2 = flip;
var size2 = size;
var hide2 = hide;
var arrow2 = arrow;
var limitShift2 = limitShift;
var computePosition2 = (reference, floating, options) => {
  const cache = /* @__PURE__ */ new Map();
  const mergedOptions = {
    platform,
    ...options
  };
  const platformWithCache = {
    ...mergedOptions.platform,
    _c: cache
  };
  return computePosition(reference, floating, {
    ...mergedOptions,
    platform: platformWithCache
  });
};

// ../node_modules/.pnpm/@zag-js+popper@1.33.1/node_modules/@zag-js/popper/dist/index.mjs
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
  return { ...rect, toJSON: () => rect };
}
function getDOMRect(anchorRect) {
  if (!anchorRect) return createDOMRect();
  const { x: x2, y: y2, width, height } = anchorRect;
  return createDOMRect(x2, y2, width, height);
}
function getAnchorElement(anchorElement, getAnchorRect) {
  return {
    contextElement: isHTMLElement(anchorElement) ? anchorElement : anchorElement?.contextElement,
    getBoundingClientRect: () => {
      const anchor = anchorElement;
      const anchorRect = getAnchorRect?.(anchor);
      if (anchorRect || !anchor) {
        return getDOMRect(anchorRect);
      }
      return anchor.getBoundingClientRect();
    }
  };
}
var toVar = (value) => ({ variable: value, reference: `var(${value})` });
var cssVars = {
  arrowSize: toVar("--arrow-size"),
  arrowSizeHalf: toVar("--arrow-size-half"),
  arrowBg: toVar("--arrow-background"),
  transformOrigin: toVar("--transform-origin"),
  arrowOffset: toVar("--arrow-offset")
};
var getSideAxis2 = (side) => side === "top" || side === "bottom" ? "y" : "x";
function createTransformOriginMiddleware(opts, arrowEl) {
  return {
    name: "transformOrigin",
    fn(state2) {
      const { elements, middlewareData, placement, rects, y: y2 } = state2;
      const side = placement.split("-")[0];
      const axis = getSideAxis2(side);
      const arrowX = middlewareData.arrow?.x || 0;
      const arrowY = middlewareData.arrow?.y || 0;
      const arrowWidth = arrowEl?.clientWidth || 0;
      const arrowHeight = arrowEl?.clientHeight || 0;
      const transformX = arrowX + arrowWidth / 2;
      const transformY = arrowY + arrowHeight / 2;
      const shiftY = Math.abs(middlewareData.shift?.y || 0);
      const halfAnchorHeight = rects.reference.height / 2;
      const arrowOffset = arrowHeight / 2;
      const gutter = opts.offset?.mainAxis ?? opts.gutter;
      const sideOffsetValue = typeof gutter === "number" ? gutter + arrowOffset : gutter ?? arrowOffset;
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
var rectMiddleware = {
  name: "rects",
  fn({ rects }) {
    return {
      data: rects
    };
  }
};
var shiftArrowMiddleware = (arrowEl) => {
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
function getPlacementDetails(placement) {
  const [side, align] = placement.split("-");
  return { side, align, hasAlign: align != null };
}
var defaultOptions = {
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
  if (isNull(opts.offset ?? opts.gutter)) return;
  return offset2(({ placement }) => {
    const arrowOffset = (arrowElement?.clientHeight || 0) / 2;
    const gutter = opts.offset?.mainAxis ?? opts.gutter;
    const mainAxis = typeof gutter === "number" ? gutter + arrowOffset : gutter ?? arrowOffset;
    const { hasAlign } = getPlacementDetails(placement);
    const shift22 = !hasAlign ? opts.shift : void 0;
    const crossAxis = opts.offset?.crossAxis ?? shift22;
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
  return flip2({
    ...boundary ? { boundary } : void 0,
    padding: opts.overflowPadding,
    fallbackPlacements: opts.flip === true ? void 0 : opts.flip
  });
}
function getShiftMiddleware(opts) {
  if (!opts.slide && !opts.overlap) return;
  const boundary = resolveBoundaryOption(opts.boundary);
  return shift2({
    ...boundary ? { boundary } : void 0,
    mainAxis: opts.slide,
    crossAxis: opts.overlap,
    padding: opts.overflowPadding,
    limiter: limitShift2()
  });
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
  if (!opts.hideWhenDetached) return;
  return hide2({ strategy: "referenceHidden", boundary: resolveBoundaryOption(opts.boundary) ?? "clippingAncestors" });
}
function getAutoUpdateOptions(opts) {
  if (!opts) return {};
  if (opts === true) {
    return { ancestorResize: true, ancestorScroll: true, elementResize: true, layoutShift: true };
  }
  return opts;
}
function getPlacementImpl(referenceOrVirtual, floating, opts = {}) {
  const anchor = opts.getAnchorElement?.() ?? referenceOrVirtual;
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
  const updatePosition = async () => {
    if (!reference || !floating) return;
    const pos = await computePosition2(reference, floating, {
      placement,
      middleware,
      strategy
    });
    onComplete?.(pos);
    onPositioned?.({ placed: true });
    const win = getWindow(floating);
    const x2 = roundByDpr(win, pos.x);
    const y2 = roundByDpr(win, pos.y);
    floating.style.setProperty("--x", `${x2}px`);
    floating.style.setProperty("--y", `${y2}px`);
    if (options.hideWhenDetached) {
      const isHidden = pos.middlewareData.hide?.referenceHidden;
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
  };
  const update = async () => {
    if (opts.updatePosition) {
      await opts.updatePosition({ updatePosition, floatingElement: floating });
      onPositioned?.({ placed: true });
    } else {
      await updatePosition();
    }
  };
  const autoUpdateOptions = getAutoUpdateOptions(options.listeners);
  const cancelAutoUpdate = options.listeners ? autoUpdate(reference, floating, update, autoUpdateOptions) : noop2;
  update();
  return () => {
    cancelAutoUpdate?.();
    onPositioned?.({ placed: false });
  };
}
function getPlacement(referenceOrFn, floatingOrFn, opts = {}) {
  const { defer, ...options } = opts;
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
    cleanups.forEach((fn) => fn?.());
  };
}
var ARROW_FLOATING_STYLE = {
  bottom: "rotate(45deg)",
  left: "rotate(135deg)",
  top: "rotate(225deg)",
  right: "rotate(315deg)"
};
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

// ../node_modules/.pnpm/@zag-js+select@1.33.1/node_modules/@zag-js/select/dist/index.mjs
var anatomy4 = createAnatomy("select").parts(
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
var parts4 = anatomy4.build();
var collection = (options) => {
  return new ListCollection(options);
};
collection.empty = () => {
  return new ListCollection({ items: [] });
};
var getRootId4 = (ctx) => ctx.ids?.root ?? `select:${ctx.id}`;
var getContentId = (ctx) => ctx.ids?.content ?? `select:${ctx.id}:content`;
var getTriggerId = (ctx) => ctx.ids?.trigger ?? `select:${ctx.id}:trigger`;
var getClearTriggerId = (ctx) => ctx.ids?.clearTrigger ?? `select:${ctx.id}:clear-trigger`;
var getLabelId = (ctx) => ctx.ids?.label ?? `select:${ctx.id}:label`;
var getControlId = (ctx) => ctx.ids?.control ?? `select:${ctx.id}:control`;
var getItemId3 = (ctx, id) => ctx.ids?.item?.(id) ?? `select:${ctx.id}:option:${id}`;
var getHiddenSelectId = (ctx) => ctx.ids?.hiddenSelect ?? `select:${ctx.id}:select`;
var getPositionerId = (ctx) => ctx.ids?.positioner ?? `select:${ctx.id}:positioner`;
var getItemGroupId = (ctx, id) => ctx.ids?.itemGroup?.(id) ?? `select:${ctx.id}:optgroup:${id}`;
var getItemGroupLabelId = (ctx, id) => ctx.ids?.itemGroupLabel?.(id) ?? `select:${ctx.id}:optgroup-label:${id}`;
var getHiddenSelectEl = (ctx) => ctx.getById(getHiddenSelectId(ctx));
var getContentEl = (ctx) => ctx.getById(getContentId(ctx));
var getTriggerEl = (ctx) => ctx.getById(getTriggerId(ctx));
var getClearTriggerEl = (ctx) => ctx.getById(getClearTriggerId(ctx));
var getPositionerEl = (ctx) => ctx.getById(getPositionerId(ctx));
var getItemEl = (ctx, id) => {
  if (id == null) return null;
  return ctx.getById(getItemId3(ctx, id));
};
function connect4(service, normalize) {
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
  const ariaActiveDescendant = highlightedValue ? getItemId3(scope, highlightedValue) : void 0;
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
  const popperStyles = getPlacementStyles({
    ...prop("positioning"),
    placement: currentPlacement
  });
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
      getTriggerEl(scope)?.focus({ preventScroll: true });
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
      return normalize.element({
        ...parts4.root.attrs,
        dir: prop("dir"),
        id: getRootId4(scope),
        "data-invalid": dataAttr(invalid),
        "data-readonly": dataAttr(readOnly)
      });
    },
    getLabelProps() {
      return normalize.label({
        dir: prop("dir"),
        id: getLabelId(scope),
        ...parts4.label.attrs,
        "data-disabled": dataAttr(disabled),
        "data-invalid": dataAttr(invalid),
        "data-readonly": dataAttr(readOnly),
        "data-required": dataAttr(required),
        htmlFor: getHiddenSelectId(scope),
        onClick(event) {
          if (event.defaultPrevented) return;
          if (disabled) return;
          getTriggerEl(scope)?.focus({ preventScroll: true });
        }
      });
    },
    getControlProps() {
      return normalize.element({
        ...parts4.control.attrs,
        dir: prop("dir"),
        id: getControlId(scope),
        "data-state": open ? "open" : "closed",
        "data-focus": dataAttr(focused),
        "data-disabled": dataAttr(disabled),
        "data-invalid": dataAttr(invalid)
      });
    },
    getValueTextProps() {
      return normalize.element({
        ...parts4.valueText.attrs,
        dir: prop("dir"),
        "data-disabled": dataAttr(disabled),
        "data-invalid": dataAttr(invalid),
        "data-focus": dataAttr(focused)
      });
    },
    getTriggerProps() {
      return normalize.button({
        id: getTriggerId(scope),
        disabled,
        dir: prop("dir"),
        type: "button",
        role: "combobox",
        "aria-controls": getContentId(scope),
        "aria-expanded": open,
        "aria-haspopup": "listbox",
        "data-state": open ? "open" : "closed",
        "aria-invalid": invalid,
        "aria-required": required,
        "aria-labelledby": getLabelId(scope),
        ...parts4.trigger.attrs,
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
      });
    },
    getIndicatorProps() {
      return normalize.element({
        ...parts4.indicator.attrs,
        dir: prop("dir"),
        "aria-hidden": true,
        "data-state": open ? "open" : "closed",
        "data-disabled": dataAttr(disabled),
        "data-invalid": dataAttr(invalid),
        "data-readonly": dataAttr(readOnly)
      });
    },
    getItemProps(props22) {
      const itemState = getItemState(props22);
      return normalize.element({
        id: getItemId3(scope, itemState.value),
        role: "option",
        ...parts4.item.attrs,
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
          if (itemState.disabled) return;
          if (props22.persistFocus) return;
          if (event.pointerType !== "mouse") return;
          const pointerMoved = service.event.previous()?.type.includes("POINTER");
          if (!pointerMoved) return;
          send({ type: "ITEM.POINTER_LEAVE" });
        }
      });
    },
    getItemTextProps(props22) {
      const itemState = getItemState(props22);
      return normalize.element({
        ...parts4.itemText.attrs,
        "data-state": itemState.selected ? "checked" : "unchecked",
        "data-disabled": dataAttr(itemState.disabled),
        "data-highlighted": dataAttr(itemState.highlighted)
      });
    },
    getItemIndicatorProps(props22) {
      const itemState = getItemState(props22);
      return normalize.element({
        "aria-hidden": true,
        ...parts4.itemIndicator.attrs,
        "data-state": itemState.selected ? "checked" : "unchecked",
        hidden: !itemState.selected
      });
    },
    getItemGroupLabelProps(props22) {
      const { htmlFor } = props22;
      return normalize.element({
        ...parts4.itemGroupLabel.attrs,
        id: getItemGroupLabelId(scope, htmlFor),
        dir: prop("dir"),
        role: "presentation"
      });
    },
    getItemGroupProps(props22) {
      const { id } = props22;
      return normalize.element({
        ...parts4.itemGroup.attrs,
        "data-disabled": dataAttr(disabled),
        id: getItemGroupId(scope, id),
        "aria-labelledby": getItemGroupLabelId(scope, id),
        role: "group",
        dir: prop("dir")
      });
    },
    getClearTriggerProps() {
      return normalize.button({
        ...parts4.clearTrigger.attrs,
        id: getClearTriggerId(scope),
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
      });
    },
    getHiddenSelectProps() {
      const value = context.get("value");
      const defaultValue = prop("multiple") ? value : value?.[0];
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
          getTriggerEl(scope)?.focus({ preventScroll: true });
        },
        "aria-labelledby": getLabelId(scope)
      });
    },
    getPositionerProps() {
      return normalize.element({
        ...parts4.positioner.attrs,
        dir: prop("dir"),
        id: getPositionerId(scope),
        style: popperStyles.floating
      });
    },
    getContentProps() {
      return normalize.element({
        hidden: !open,
        dir: prop("dir"),
        id: getContentId(scope),
        role: composite ? "listbox" : "dialog",
        ...parts4.content.attrs,
        "data-state": open ? "open" : "closed",
        "data-placement": currentPlacement,
        "data-activedescendant": ariaActiveDescendant,
        "aria-activedescendant": composite ? ariaActiveDescendant : void 0,
        "aria-multiselectable": prop("multiple") && composite ? true : void 0,
        "aria-labelledby": getLabelId(scope),
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
              if (isTypingAhead) {
                send({ type: "CONTENT.TYPEAHEAD", key: event2.key });
              } else {
                keyMap2.Enter?.(event2);
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
      });
    },
    getListProps() {
      return normalize.element({
        ...parts4.list.attrs,
        tabIndex: 0,
        role: !composite ? "listbox" : void 0,
        "aria-labelledby": getTriggerId(scope),
        "aria-activedescendant": !composite ? ariaActiveDescendant : void 0,
        "aria-multiselectable": !composite && prop("multiple") ? true : void 0
      });
    }
  };
}
var { and: and4, not: not4, or } = createGuards();
var machine4 = createMachine({
  props({ props: props22 }) {
    return {
      loopFocus: false,
      closeOnSelect: !props22.multiple,
      composite: true,
      defaultValue: [],
      ...props22,
      collection: props22.collection ?? collection.empty(),
      positioning: {
        placement: "bottom-start",
        gutter: 8,
        ...props22.positioning
      }
    };
  },
  context({ prop, bindable: bindable2 }) {
    return {
      value: bindable2(() => ({
        defaultValue: prop("defaultValue"),
        value: prop("value"),
        isEqual: isEqual2,
        onChange(value) {
          const items = prop("collection").findMany(value);
          return prop("onValueChange")?.({ value, items });
        }
      })),
      highlightedValue: bindable2(() => ({
        defaultValue: prop("defaultHighlightedValue") || null,
        value: prop("highlightedValue"),
        onChange(value) {
          prop("onHighlightChange")?.({
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
        const value = prop("value") ?? prop("defaultValue") ?? [];
        const items = prop("collection").findMany(value);
        return { defaultValue: items };
      })
    };
  },
  refs() {
    return {
      typeahead: { ...getByTypeahead.defaultOptions }
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
            guard: or("isTriggerArrowDownEvent", "isTriggerEnterEvent"),
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
            guard: and4(not4("multiple"), "hasSelectedItems"),
            actions: ["selectPreviousItem"]
          },
          {
            guard: not4("multiple"),
            actions: ["selectLastItem"]
          }
        ],
        "TRIGGER.ARROW_RIGHT": [
          {
            guard: and4(not4("multiple"), "hasSelectedItems"),
            actions: ["selectNextItem"]
          },
          {
            guard: not4("multiple"),
            actions: ["selectFirstItem"]
          }
        ],
        "TRIGGER.HOME": {
          guard: not4("multiple"),
          actions: ["selectFirstItem"]
        },
        "TRIGGER.END": {
          guard: not4("multiple"),
          actions: ["selectLastItem"]
        },
        "TRIGGER.TYPEAHEAD": {
          guard: not4("multiple"),
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
            guard: and4("closeOnSelect", "isOpenControlled"),
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
            guard: and4("hasHighlightedItem", "loop", "isLastItemHighlighted"),
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
            guard: and4("hasHighlightedItem", "loop", "isFirstItemHighlighted"),
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
      closeOnSelect: ({ prop, event }) => !!(event.closeOnSelect ?? prop("closeOnSelect")),
      restoreFocus: ({ event }) => restoreFocusFn(event),
      // guard assertions (for controlled mode)
      isOpenControlled: ({ prop }) => prop("open") !== void 0,
      isTriggerClickEvent: ({ event }) => event.previousEvent?.type === "TRIGGER.CLICK",
      isTriggerEnterEvent: ({ event }) => event.previousEvent?.type === "TRIGGER.ENTER",
      isTriggerArrowUpEvent: ({ event }) => event.previousEvent?.type === "TRIGGER.ARROW_UP",
      isTriggerArrowDownEvent: ({ event }) => event.previousEvent?.type === "TRIGGER.ARROW_DOWN"
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
        const contentEl = () => getContentEl(scope);
        let restoreFocus = true;
        return trackDismissableElement(contentEl, {
          type: "listbox",
          defer: true,
          exclude: [getTriggerEl(scope), getClearTriggerEl(scope)],
          onFocusOutside: prop("onFocusOutside"),
          onPointerDownOutside: prop("onPointerDownOutside"),
          onInteractOutside(event) {
            prop("onInteractOutside")?.(event);
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
        const triggerEl = () => getTriggerEl(scope);
        const positionerEl = () => getPositionerEl(scope);
        return getPlacement(triggerEl, positionerEl, {
          defer: true,
          ...positioning,
          onComplete(data) {
            context.set("currentPlacement", data.placement);
          }
        });
      },
      scrollToHighlightedItem({ context, prop, scope, event }) {
        const exec = (immediate) => {
          const highlightedValue = context.get("highlightedValue");
          if (highlightedValue == null) return;
          if (event.current().type.includes("POINTER")) return;
          const contentEl2 = getContentEl(scope);
          const scrollToIndexFn = prop("scrollToIndexFn");
          if (scrollToIndexFn) {
            const highlightedIndex = prop("collection").indexOf(highlightedValue);
            scrollToIndexFn?.({
              index: highlightedIndex,
              immediate,
              getElement: () => getItemEl(scope, highlightedValue)
            });
            return;
          }
          const itemEl = getItemEl(scope, highlightedValue);
          scrollIntoView(itemEl, { rootEl: contentEl2, block: "nearest" });
        };
        raf(() => exec(true));
        const contentEl = () => getContentEl(scope);
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
        const positionerEl = () => getPositionerEl(scope);
        getPlacement(getTriggerEl(scope), positionerEl, {
          ...prop("positioning"),
          ...event.options,
          defer: true,
          listeners: false,
          onComplete(data) {
            context.set("currentPlacement", data.placement);
          }
        });
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
            root: getContentEl(scope)
          });
          element?.focus({ preventScroll: true });
        });
      },
      focusTriggerEl({ event, scope }) {
        if (!restoreFocusFn(event)) return;
        raf(() => {
          const element = getTriggerEl(scope);
          element?.focus({ preventScroll: true });
        });
      },
      selectHighlightedItem({ context, prop, event }) {
        let value = event.value ?? context.get("highlightedValue");
        if (value == null || !prop("collection").has(value)) return;
        prop("onSelect")?.({ value });
        const nullable = prop("deselectable") && !prop("multiple") && context.get("value").includes(value);
        value = nullable ? null : value;
        context.set("value", (prev) => {
          if (value == null) return [];
          if (prop("multiple")) return addOrRemove(prev, value);
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
        prop("onSelect")?.({ value: event.value });
        const nullable = prop("deselectable") && !prop("multiple") && context.get("value").includes(event.value);
        const value = nullable ? null : event.value;
        context.set("value", (prev) => {
          if (value == null) return [];
          if (prop("multiple")) return addOrRemove(prev, value);
          return [value];
        });
      },
      clearItem({ context, event }) {
        context.set("value", (prev) => prev.filter((v2) => v2 !== event.value));
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
        if (prop("scrollToIndexFn")) {
          const firstValue = prop("collection").firstValue;
          prop("scrollToIndexFn")?.({
            index: 0,
            immediate: true,
            getElement: () => getItemEl(scope, firstValue)
          });
        } else {
          getContentEl(scope)?.scrollTo(0, 0);
        }
      },
      invokeOnOpen({ prop, context }) {
        prop("onOpenChange")?.({ open: true, value: context.get("value") });
      },
      invokeOnClose({ prop, context }) {
        prop("onOpenChange")?.({ open: false, value: context.get("value") });
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
function restoreFocusFn(event) {
  const v2 = event.restoreFocus ?? event.previousEvent?.restoreFocus;
  return v2 == null || !!v2;
}
var props3 = createProps()([
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
var splitProps4 = createSplitProps(props3);
var itemProps3 = createProps()(["item", "persistFocus"]);
var splitItemProps3 = createSplitProps(itemProps3);
var itemGroupProps = createProps()(["id"]);
var splitItemGroupProps = createSplitProps(itemGroupProps);
var itemGroupLabelProps = createProps()(["htmlFor"]);
var splitItemGroupLabelProps = createSplitProps(itemGroupLabelProps);

// components/select.ts
var Select = class extends Component {
  _options = [];
  hasGroups = false;
  placeholder = "";
  constructor(el, props13) {
    super(el, props13);
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
      return collection({
        items,
        itemToValue: (item) => item.id ?? item.value ?? "",
        itemToString: (item) => item.label,
        isItemDisabled: (item) => !!item.disabled,
        groupBy: (item) => item.group
      });
    }
    return collection({
      items,
      itemToValue: (item) => item.id ?? item.value ?? "",
      itemToString: (item) => item.label,
      isItemDisabled: (item) => !!item.disabled
    });
  }
  initMachine(props13) {
    const self2 = this;
    return new VanillaMachine(machine4, {
      ...props13,
      get collection() {
        return self2.getCollection();
      }
    });
  }
  initApi() {
    return connect4(this.machine.service, normalizeProps);
  }
  renderItems() {
    const contentEl = this.el.querySelector(
      '[data-scope="select"][data-part="content"]'
    );
    if (!contentEl) return;
    const templatesContainer = this.el.querySelector('[data-templates="select"]');
    if (!templatesContainer) return;
    contentEl.querySelectorAll('[data-scope="select"][data-part="item"]:not([data-template])').forEach((el) => el.remove());
    contentEl.querySelectorAll('[data-scope="select"][data-part="item-group"]:not([data-template])').forEach((el) => el.remove());
    const items = this.api.collection.items;
    const groups = this.api.collection.group?.() ?? [];
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
          const itemValue = item.id ?? item.value ?? "";
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

// hooks/select.ts
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
var SelectHook = {
  mounted() {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const allItems = JSON.parse(el.dataset.collection || "[]");
    const hasGroups = allItems.some((item) => item.group !== void 0);
    let selectComponent;
    const hook = this;
    this.wasFocused = false;
    selectComponent = new Select(
      el,
      {
        id: el.id,
        ...getBoolean(el, "controlled") ? { value: getStringList(el, "value") } : { defaultValue: getStringList(el, "defaultValue") },
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
              return transformPositioningOptions(parsed);
            } catch {
              return void 0;
            }
          }
          return void 0;
        })(),
        onValueChange: (details) => {
          const valueInput = el.querySelector(
            '[data-scope="select"][data-part="value-input"]'
          );
          if (valueInput) {
            valueInput.value = details.value.length === 0 ? "" : details.value.length === 1 ? String(details.value[0]) : details.value.map(String).join(",");
            valueInput.dispatchEvent(new Event("input", { bubbles: true }));
            valueInput.dispatchEvent(new Event("change", { bubbles: true }));
          }
          const eventName = getString(el, "onValueChange");
          if (eventName && !hook.liveSocket.main.isDead && hook.liveSocket.main.isConnected()) {
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
      }
    );
    selectComponent.hasGroups = hasGroups;
    selectComponent.setOptions(allItems);
    selectComponent.init();
    this.select = selectComponent;
    this.handlers = [];
  },
  beforeUpdate() {
    this.wasFocused = this.select?.api?.focused ?? false;
  },
  updated() {
    const newCollection = JSON.parse(this.el.dataset.collection || "[]");
    const hasGroups = newCollection.some((item) => item.group !== void 0);
    if (this.select) {
      this.select.hasGroups = hasGroups;
      this.select.setOptions(newCollection);
      this.select.updateProps({
        id: this.el.id,
        ...getBoolean(this.el, "controlled") ? { value: getStringList(this.el, "value") } : { defaultValue: getStringList(this.el, "defaultValue") },
        name: getString(this.el, "name"),
        form: getString(this.el, "form"),
        disabled: getBoolean(this.el, "disabled"),
        multiple: getBoolean(this.el, "multiple"),
        dir: getString(this.el, "dir", ["ltr", "rtl"]),
        invalid: getBoolean(this.el, "invalid"),
        required: getBoolean(this.el, "required"),
        readOnly: getBoolean(this.el, "readOnly")
      });
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
    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }
    this.select?.destroy();
  }
};

// ../node_modules/.pnpm/@zag-js+focus-visible@1.33.1/node_modules/@zag-js/focus-visible/dist/index.mjs
function isValidKey(e2) {
  return !(e2.metaKey || !isMac() && e2.altKey || e2.ctrlKey || e2.key === "Control" || e2.key === "Shift" || e2.key === "Meta");
}
var nonTextInputTypes = /* @__PURE__ */ new Set(["checkbox", "radio", "range", "color", "file", "image", "button", "submit", "reset"]);
function isKeyboardFocusEvent(isTextInput, modality, e2) {
  const target = e2 ? getEventTarget(e2) : null;
  const win = getWindow(target);
  isTextInput = isTextInput || target instanceof win.HTMLInputElement && !nonTextInputTypes.has(target?.type) || target instanceof win.HTMLTextAreaElement || target instanceof win.HTMLElement && target.isContentEditable;
  return !(isTextInput && modality === "keyboard" && e2 instanceof win.KeyboardEvent && !Reflect.has(FOCUS_VISIBLE_INPUT_KEYS, e2.key));
}
var currentModality = null;
var changeHandlers = /* @__PURE__ */ new Set();
var listenerMap = /* @__PURE__ */ new Map();
var hasEventBeforeFocus = false;
var hasBlurredWindowRecently = false;
var FOCUS_VISIBLE_INPUT_KEYS = {
  Tab: true,
  Escape: true
};
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
  } catch {
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
var tearDownWindowFocusTracking = (root, loadListener) => {
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
  } catch {
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
function isFocusVisible() {
  return currentModality === "keyboard";
}
function trackFocusVisible(props13 = {}) {
  const { isTextInput, autoFocus, onChange, root } = props13;
  setupGlobalFocusEvents(root);
  onChange?.({ isFocusVisible: autoFocus || isFocusVisible(), modality: currentModality });
  const handler = (modality, e2) => {
    if (!isKeyboardFocusEvent(!!isTextInput, modality, e2)) return;
    onChange?.({ isFocusVisible: isFocusVisible(), modality });
  };
  changeHandlers.add(handler);
  return () => {
    changeHandlers.delete(handler);
  };
}

// ../node_modules/.pnpm/@zag-js+switch@1.33.1/node_modules/@zag-js/switch/dist/index.mjs
var anatomy5 = createAnatomy("switch").parts("root", "label", "control", "thumb");
var parts5 = anatomy5.build();
var getRootId5 = (ctx) => ctx.ids?.root ?? `switch:${ctx.id}`;
var getLabelId2 = (ctx) => ctx.ids?.label ?? `switch:${ctx.id}:label`;
var getThumbId = (ctx) => ctx.ids?.thumb ?? `switch:${ctx.id}:thumb`;
var getControlId2 = (ctx) => ctx.ids?.control ?? `switch:${ctx.id}:control`;
var getHiddenInputId = (ctx) => ctx.ids?.hiddenInput ?? `switch:${ctx.id}:input`;
var getRootEl4 = (ctx) => ctx.getById(getRootId5(ctx));
var getHiddenInputEl = (ctx) => ctx.getById(getHiddenInputId(ctx));
function connect5(service, normalize) {
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
      return normalize.label({
        ...parts5.root.attrs,
        ...dataAttrs,
        dir: prop("dir"),
        id: getRootId5(scope),
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
          if (disabled) return;
          const target = getEventTarget(event);
          if (target === getHiddenInputEl(scope)) {
            event.stopPropagation();
          }
          if (isSafari()) {
            getHiddenInputEl(scope)?.focus();
          }
        }
      });
    },
    getLabelProps() {
      return normalize.element({
        ...parts5.label.attrs,
        ...dataAttrs,
        dir: prop("dir"),
        id: getLabelId2(scope)
      });
    },
    getThumbProps() {
      return normalize.element({
        ...parts5.thumb.attrs,
        ...dataAttrs,
        dir: prop("dir"),
        id: getThumbId(scope),
        "aria-hidden": true
      });
    },
    getControlProps() {
      return normalize.element({
        ...parts5.control.attrs,
        ...dataAttrs,
        dir: prop("dir"),
        id: getControlId2(scope),
        "aria-hidden": true
      });
    },
    getHiddenInputProps() {
      return normalize.input({
        id: getHiddenInputId(scope),
        type: "checkbox",
        required: prop("required"),
        defaultChecked: checked,
        disabled,
        "aria-labelledby": getLabelId2(scope),
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
var { not: not5 } = createGuards();
var machine5 = createMachine({
  props({ props: props22 }) {
    return {
      defaultChecked: false,
      label: "switch",
      value: "on",
      ...props22
    };
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
          prop("onCheckedChange")?.({ checked: value });
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
        guard: not5("isTrusted"),
        actions: ["toggleChecked", "dispatchChangeEvent"]
      },
      {
        actions: ["toggleChecked"]
      }
    ],
    "CHECKED.SET": [
      {
        guard: not5("isTrusted"),
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
          pointerNode: getRootEl4(scope),
          keyboardNode: getHiddenInputEl(scope),
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
        return trackFormControl(getHiddenInputEl(scope), {
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
        const inputEl = getHiddenInputEl(scope);
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
          const inputEl = getHiddenInputEl(scope);
          dispatchInputCheckedEvent(inputEl, { checked: context.get("checked") });
        });
      }
    }
  }
});
var props4 = createProps()([
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
var splitProps5 = createSplitProps(props4);

// components/switch.ts
var Switch = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props13) {
    return new VanillaMachine(machine5, props13);
  }
  initApi() {
    return connect5(this.machine.service, normalizeProps);
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

// hooks/switch.ts
var SwitchHook = {
  mounted() {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    this.wasFocused = false;
    const zagSwitch = new Switch(el, {
      id: el.id,
      ...getBoolean(el, "controlled") ? { checked: getBoolean(el, "checked") } : { defaultChecked: getBoolean(el, "defaultChecked") },
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
    });
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
    this.wasFocused = this.zagSwitch?.api.focused ?? false;
  },
  updated() {
    this.zagSwitch?.updateProps({
      id: this.el.id,
      ...getBoolean(this.el, "controlled") ? { checked: getBoolean(this.el, "checked") } : { defaultChecked: getBoolean(this.el, "defaultChecked") },
      disabled: getBoolean(this.el, "disabled"),
      name: getString(this.el, "name"),
      form: getString(this.el, "form"),
      value: getString(this.el, "value"),
      dir: getString(this.el, "dir", ["ltr", "rtl"]),
      invalid: getBoolean(this.el, "invalid"),
      required: getBoolean(this.el, "required"),
      readOnly: getBoolean(this.el, "readOnly"),
      label: getString(this.el, "label")
    });
    if (getBoolean(this.el, "controlled")) {
      if (this.wasFocused) {
        const hiddenInput = this.el.querySelector('[data-part="hidden-input"]');
        hiddenInput?.focus();
      }
    }
  },
  destroyed() {
    if (this.onSetChecked) {
      this.el.removeEventListener("phx:switch:set-checked", this.onSetChecked);
    }
    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }
    this.zagSwitch?.destroy();
  }
};

// ../node_modules/.pnpm/@zag-js+combobox@1.33.1/node_modules/@zag-js/combobox/dist/index.mjs
var anatomy6 = createAnatomy("combobox").parts(
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
var parts6 = anatomy6.build();
var collection2 = (options) => {
  return new ListCollection(options);
};
collection2.empty = () => {
  return new ListCollection({ items: [] });
};
var getRootId6 = (ctx) => ctx.ids?.root ?? `combobox:${ctx.id}`;
var getLabelId3 = (ctx) => ctx.ids?.label ?? `combobox:${ctx.id}:label`;
var getControlId3 = (ctx) => ctx.ids?.control ?? `combobox:${ctx.id}:control`;
var getInputId = (ctx) => ctx.ids?.input ?? `combobox:${ctx.id}:input`;
var getContentId2 = (ctx) => ctx.ids?.content ?? `combobox:${ctx.id}:content`;
var getPositionerId2 = (ctx) => ctx.ids?.positioner ?? `combobox:${ctx.id}:popper`;
var getTriggerId2 = (ctx) => ctx.ids?.trigger ?? `combobox:${ctx.id}:toggle-btn`;
var getClearTriggerId2 = (ctx) => ctx.ids?.clearTrigger ?? `combobox:${ctx.id}:clear-btn`;
var getItemGroupId2 = (ctx, id) => ctx.ids?.itemGroup?.(id) ?? `combobox:${ctx.id}:optgroup:${id}`;
var getItemGroupLabelId2 = (ctx, id) => ctx.ids?.itemGroupLabel?.(id) ?? `combobox:${ctx.id}:optgroup-label:${id}`;
var getItemId4 = (ctx, id) => ctx.ids?.item?.(id) ?? `combobox:${ctx.id}:option:${id}`;
var getContentEl2 = (ctx) => ctx.getById(getContentId2(ctx));
var getInputEl = (ctx) => ctx.getById(getInputId(ctx));
var getPositionerEl2 = (ctx) => ctx.getById(getPositionerId2(ctx));
var getControlEl = (ctx) => ctx.getById(getControlId3(ctx));
var getTriggerEl2 = (ctx) => ctx.getById(getTriggerId2(ctx));
var getClearTriggerEl2 = (ctx) => ctx.getById(getClearTriggerId2(ctx));
var getItemEl2 = (ctx, value) => {
  if (value == null) return null;
  const selector = `[role=option][data-value="${CSS.escape(value)}"]`;
  return query(getContentEl2(ctx), selector);
};
var focusInputEl = (ctx) => {
  const inputEl = getInputEl(ctx);
  if (ctx.isActiveElement(inputEl)) return;
  inputEl?.focus({ preventScroll: true });
};
var focusTriggerEl = (ctx) => {
  const triggerEl = getTriggerEl2(ctx);
  if (ctx.isActiveElement(triggerEl)) return;
  triggerEl?.focus({ preventScroll: true });
};
function connect6(service, normalize) {
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
  const popperStyles = getPlacementStyles({
    ...prop("positioning"),
    placement: context.get("currentPlacement")
  });
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
      getInputEl(scope)?.focus();
    },
    setOpen(nextOpen, reason = "script") {
      const open2 = state2.hasTag("open");
      if (open2 === nextOpen) return;
      send({ type: nextOpen ? "OPEN" : "CLOSE", src: reason });
    },
    getRootProps() {
      return normalize.element({
        ...parts6.root.attrs,
        dir: prop("dir"),
        id: getRootId6(scope),
        "data-invalid": dataAttr(invalid),
        "data-readonly": dataAttr(readOnly)
      });
    },
    getLabelProps() {
      return normalize.label({
        ...parts6.label.attrs,
        dir: prop("dir"),
        htmlFor: getInputId(scope),
        id: getLabelId3(scope),
        "data-readonly": dataAttr(readOnly),
        "data-disabled": dataAttr(disabled),
        "data-invalid": dataAttr(invalid),
        "data-required": dataAttr(required),
        "data-focus": dataAttr(focused),
        onClick(event2) {
          if (composite) return;
          event2.preventDefault();
          getTriggerEl2(scope)?.focus({ preventScroll: true });
        }
      });
    },
    getControlProps() {
      return normalize.element({
        ...parts6.control.attrs,
        dir: prop("dir"),
        id: getControlId3(scope),
        "data-state": open ? "open" : "closed",
        "data-focus": dataAttr(focused),
        "data-disabled": dataAttr(disabled),
        "data-invalid": dataAttr(invalid)
      });
    },
    getPositionerProps() {
      return normalize.element({
        ...parts6.positioner.attrs,
        dir: prop("dir"),
        id: getPositionerId2(scope),
        style: popperStyles.floating
      });
    },
    getInputProps() {
      return normalize.input({
        ...parts6.input.attrs,
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
        id: getInputId(scope),
        type: "text",
        role: "combobox",
        defaultValue: context.get("inputValue"),
        "aria-autocomplete": computed("autoComplete") ? "both" : "list",
        "aria-controls": getContentId2(scope),
        "aria-expanded": open,
        "data-state": open ? "open" : "closed",
        "aria-activedescendant": highlightedValue ? getItemId4(scope, highlightedValue) : void 0,
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
              send({ type: "INPUT.ENTER", keypress, src: "item-select" });
              const submittable = computed("isCustomValue") && prop("allowCustomValue");
              const hasHighlight = highlightedValue != null;
              const alwaysSubmit = prop("alwaysSubmitOnEnter");
              if (open && !submittable && !alwaysSubmit && hasHighlight) {
                event3.preventDefault();
              }
              if (highlightedValue == null) return;
              const itemEl = getItemEl2(scope, highlightedValue);
              if (isAnchorElement(itemEl)) {
                prop("navigate")?.({ value: highlightedValue, node: itemEl, href: itemEl.href });
              }
            },
            Escape() {
              send({ type: "INPUT.ESCAPE", keypress, src: "escape-key" });
              event2.preventDefault();
            }
          };
          const key = getEventKey(event2, { dir: prop("dir") });
          const exec = keymap[key];
          exec?.(event2);
        }
      });
    },
    getTriggerProps(props22 = {}) {
      return normalize.button({
        ...parts6.trigger.attrs,
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
            getInputEl(scope)?.focus({ preventScroll: true });
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
      });
    },
    getContentProps() {
      return normalize.element({
        ...parts6.content.attrs,
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
      });
    },
    getListProps() {
      return normalize.element({
        ...parts6.list.attrs,
        role: !composite ? "listbox" : void 0,
        "data-empty": dataAttr(collection22.size === 0),
        "aria-labelledby": getLabelId3(scope),
        "aria-multiselectable": prop("multiple") && !composite ? true : void 0
      });
    },
    getClearTriggerProps() {
      return normalize.button({
        ...parts6.clearTrigger.attrs,
        dir: prop("dir"),
        id: getClearTriggerId2(scope),
        type: "button",
        tabIndex: -1,
        disabled,
        "data-invalid": dataAttr(invalid),
        "aria-label": translations.clearTriggerLabel,
        "aria-controls": getInputId(scope),
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
      });
    },
    getItemState,
    getItemProps(props22) {
      const itemState = getItemState(props22);
      const value = itemState.value;
      return normalize.element({
        ...parts6.item.attrs,
        dir: prop("dir"),
        id: getItemId4(scope, value),
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
          const prev = event.previous();
          const mouseMoved = prev?.type.includes("POINTER");
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
      });
    },
    getItemTextProps(props22) {
      const itemState = getItemState(props22);
      return normalize.element({
        ...parts6.itemText.attrs,
        dir: prop("dir"),
        "data-state": itemState.selected ? "checked" : "unchecked",
        "data-disabled": dataAttr(itemState.disabled),
        "data-highlighted": dataAttr(itemState.highlighted)
      });
    },
    getItemIndicatorProps(props22) {
      const itemState = getItemState(props22);
      return normalize.element({
        "aria-hidden": true,
        ...parts6.itemIndicator.attrs,
        dir: prop("dir"),
        "data-state": itemState.selected ? "checked" : "unchecked",
        hidden: !itemState.selected
      });
    },
    getItemGroupProps(props22) {
      const { id } = props22;
      return normalize.element({
        ...parts6.itemGroup.attrs,
        dir: prop("dir"),
        id: getItemGroupId2(scope, id),
        "aria-labelledby": getItemGroupLabelId2(scope, id),
        "data-empty": dataAttr(collection22.size === 0),
        role: "group"
      });
    },
    getItemGroupLabelProps(props22) {
      const { htmlFor } = props22;
      return normalize.element({
        ...parts6.itemGroupLabel.attrs,
        dir: prop("dir"),
        id: getItemGroupLabelId2(scope, htmlFor),
        role: "presentation"
      });
    }
  };
}
var { guards: guards2, createMachine: createMachine3, choose } = setup();
var { and: and5, not: not6 } = guards2;
var machine6 = createMachine3({
  props({ props: props22 }) {
    return {
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
      collection: collection2.empty(),
      ...props22,
      positioning: {
        placement: "bottom",
        sameWidth: true,
        ...props22.positioning
      },
      translations: {
        triggerLabel: "Toggle suggestions",
        clearTriggerLabel: "Clear value",
        ...props22.translations
      }
    };
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
          const context = getContext();
          const prevSelectedItems = context.get("selectedItems");
          const collection22 = prop("collection");
          const nextItems = value.map((v2) => {
            const item = prevSelectedItems.find((item2) => collection22.getItemValue(item2) === v2);
            return item || collection22.find(v2);
          });
          context.set("selectedItems", nextItems);
          prop("onValueChange")?.({ value, items: nextItems });
        }
      })),
      highlightedValue: bindable2(() => ({
        defaultValue: prop("defaultHighlightedValue") || null,
        value: prop("highlightedValue"),
        onChange(value) {
          const item = prop("collection").find(value);
          prop("onHighlightChange")?.({ highlightedValue: value, highlightedItem: item });
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
            const event = getEvent();
            const reason = (event.previousEvent || event).src;
            prop("onInputValueChange")?.({ inputValue: value2, reason });
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
            guard: and5("isOpenControlled", "openOnChange"),
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
          guard: and5("isCustomValue", not6("allowCustomValue")),
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
            guard: and5("isOpenControlled", "autoComplete"),
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
            guard: and5("autoComplete", "isLastItemHighlighted"),
            actions: ["clearHighlightedValue", "scrollContentToTop"]
          },
          {
            actions: ["highlightNextItem"]
          }
        ],
        "INPUT.ARROW_UP": [
          {
            guard: and5("autoComplete", "isFirstItemHighlighted"),
            actions: ["clearHighlightedValue"]
          },
          {
            actions: ["highlightPrevItem"]
          }
        ],
        "INPUT.ENTER": [
          // == group 1 ==
          {
            guard: and5("isOpenControlled", "isCustomValue", not6("hasHighlightedItem"), not6("allowCustomValue")),
            actions: ["revertInputValue", "invokeOnClose"]
          },
          {
            guard: and5("isCustomValue", not6("hasHighlightedItem"), not6("allowCustomValue")),
            target: "focused",
            actions: ["revertInputValue", "invokeOnClose"]
          },
          // == group 2 ==
          {
            guard: and5("isOpenControlled", "closeOnSelect"),
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
            guard: and5("isOpenControlled", "closeOnSelect"),
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
            guard: and5("isOpenControlled", "autoComplete"),
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
            guard: and5("isOpenControlled", "isCustomValue", not6("allowCustomValue")),
            actions: ["revertInputValue", "invokeOnClose"]
          },
          {
            guard: and5("isCustomValue", not6("allowCustomValue")),
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
            guard: and5("isHighlightedItemRemoved", "hasCollectionItems", "autoHighlight"),
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
            guard: and5("isOpenControlled", "isCustomValue", not6("hasHighlightedItem"), not6("allowCustomValue")),
            actions: ["revertInputValue", "invokeOnClose"]
          },
          {
            guard: and5("isCustomValue", not6("hasHighlightedItem"), not6("allowCustomValue")),
            target: "focused",
            actions: ["revertInputValue", "invokeOnClose"]
          },
          // == group 2 ==
          {
            guard: and5("isOpenControlled", "closeOnSelect"),
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
            guard: and5("isOpenControlled", "isCustomValue", not6("allowCustomValue")),
            actions: ["revertInputValue", "invokeOnClose"]
          },
          {
            guard: and5("isCustomValue", not6("allowCustomValue")),
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
            guard: and5("isOpenControlled", "closeOnSelect"),
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
        return !!openOnChange?.({ inputValue: context.get("inputValue") });
      },
      restoreFocus: ({ event }) => {
        const restoreFocus = event.restoreFocus ?? event.previousEvent?.restoreFocus;
        return restoreFocus == null ? true : !!restoreFocus;
      },
      isChangeEvent: ({ event }) => event.previousEvent?.type === "INPUT.CHANGE",
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
          exclude: () => [getInputEl(scope), getTriggerEl2(scope), getClearTriggerEl2(scope)],
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
        const anchorEl = () => getControlEl(scope) || getTriggerEl2(scope);
        const positionerEl = () => getPositionerEl2(scope);
        context.set("currentPlacement", prop("positioning").placement);
        return getPlacement(anchorEl, positionerEl, {
          ...prop("positioning"),
          defer: true,
          onComplete(data) {
            context.set("currentPlacement", data.placement);
          }
        });
      },
      scrollToHighlightedItem({ context, prop, scope, event }) {
        const inputEl = getInputEl(scope);
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
              getElement: () => getItemEl2(scope, highlightedValue)
            });
            return;
          }
          const itemEl = getItemEl2(scope, highlightedValue);
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
        const positionerEl = () => getPositionerEl2(scope);
        getPlacement(controlEl, positionerEl, {
          ...prop("positioning"),
          ...event.options,
          defer: true,
          listeners: false,
          onComplete(data) {
            context.set("currentPlacement", data.placement);
          }
        });
      },
      setHighlightedValue({ context, event }) {
        if (event.value == null) return;
        context.set("highlightedValue", event.value);
      },
      clearHighlightedValue({ context }) {
        context.set("highlightedValue", null);
      },
      selectHighlightedItem(params) {
        const { context, prop } = params;
        const collection22 = prop("collection");
        const highlightedValue = context.get("highlightedValue");
        if (!highlightedValue || !collection22.has(highlightedValue)) return;
        const nextValue = prop("multiple") ? addOrRemove(context.get("value"), highlightedValue) : [highlightedValue];
        prop("onSelect")?.({ value: nextValue, itemValue: highlightedValue });
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
          const itemEl = getItemEl2(scope, highlightedValue);
          const contentEl = getContentEl2(scope);
          const scrollToIndexFn = prop("scrollToIndexFn");
          if (scrollToIndexFn) {
            const highlightedIndex = prop("collection").indexOf(highlightedValue);
            scrollToIndexFn({
              index: highlightedIndex,
              immediate: true,
              getElement: () => getItemEl2(scope, highlightedValue)
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
          const nextValue = prop("multiple") ? addOrRemove(context.get("value"), event.value) : [event.value];
          prop("onSelect")?.({ value: nextValue, itemValue: event.value });
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
          const triggerEl = getTriggerEl2(scope);
          if (triggerEl?.dataset.focusable == null) {
            focusInputEl(scope);
          } else {
            focusTriggerEl(scope);
          }
        });
      },
      syncInputValue({ context, scope, event }) {
        const inputEl = getInputEl(scope);
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
            getElement: () => getItemEl2(scope, firstValue)
          });
        } else {
          const contentEl = getContentEl2(scope);
          if (!contentEl) return;
          contentEl.scrollTop = 0;
        }
      },
      invokeOnOpen({ prop, event, context }) {
        const reason = getOpenChangeReason(event);
        prop("onOpenChange")?.({ open: true, reason, value: context.get("value") });
      },
      invokeOnClose({ prop, event, context }) {
        const reason = getOpenChangeReason(event);
        prop("onOpenChange")?.({ open: false, reason, value: context.get("value") });
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
        const inputEl = getInputEl(scope);
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
function getOpenChangeReason(event) {
  return (event.previousEvent || event).src;
}
var props5 = createProps()([
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
var splitProps6 = createSplitProps(props5);
var itemGroupLabelProps2 = createProps()(["htmlFor"]);
var splitItemGroupLabelProps2 = createSplitProps(itemGroupLabelProps2);
var itemGroupProps2 = createProps()(["id"]);
var splitItemGroupProps2 = createSplitProps(itemGroupProps2);
var itemProps4 = createProps()(["item", "persistFocus"]);
var splitItemProps4 = createSplitProps(itemProps4);

// components/combobox.ts
var Combobox = class extends Component {
  options = [];
  allOptions = [];
  hasGroups = false;
  setAllOptions(options) {
    this.allOptions = options;
    this.options = options;
  }
  getCollection() {
    const items = this.options || this.allOptions || [];
    if (this.hasGroups) {
      return collection2({
        items,
        itemToValue: (item) => item.id,
        itemToString: (item) => item.label,
        isItemDisabled: (item) => item.disabled,
        groupBy: (item) => item.group
      });
    }
    return collection2({
      items,
      itemToValue: (item) => item.id,
      itemToString: (item) => item.label,
      isItemDisabled: (item) => item.disabled
    });
  }
  initMachine(props13) {
    const self2 = this;
    return new VanillaMachine(machine6, {
      ...props13,
      get collection() {
        return self2.getCollection();
      },
      onOpenChange: (details) => {
        if (details.open) {
          self2.options = self2.allOptions;
        }
        if (props13.onOpenChange) {
          props13.onOpenChange(details);
        }
      },
      onInputValueChange: (details) => {
        const filtered = self2.allOptions.filter(
          (item) => item.label.toLowerCase().includes(details.inputValue.toLowerCase())
        );
        self2.options = filtered.length > 0 ? filtered : self2.allOptions;
        if (props13.onInputValueChange) {
          props13.onInputValueChange(details);
        }
      }
    });
  }
  initApi() {
    return connect6(this.machine.service, normalizeProps);
  }
  renderItems() {
    const contentEl = this.el.querySelector('[data-scope="combobox"][data-part="content"]');
    if (!contentEl) return;
    const templatesContainer = this.el.querySelector('[data-templates="combobox"]');
    if (!templatesContainer) return;
    contentEl.querySelectorAll('[data-scope="combobox"][data-part="item"]:not([data-template])').forEach((el) => el.remove());
    contentEl.querySelectorAll('[data-scope="combobox"][data-part="item-group"]:not([data-template])').forEach((el) => el.remove());
    const items = this.api.collection.items;
    const groups = this.api.collection.group?.() ?? [];
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

// hooks/combobox.ts
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
var ComboboxHook = {
  mounted() {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const allItems = JSON.parse(el.dataset.collection || "[]");
    const hasGroups = allItems.some((item) => item.group !== void 0);
    const props13 = {
      id: el.id,
      ...getBoolean(el, "controlled") ? { value: getStringList(el, "value") } : { defaultValue: getStringList(el, "defaultValue") },
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
            return transformPositioningOptions2(parsed);
          } catch {
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
    };
    const combobox = new Combobox(el, props13);
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
      this.combobox.updateProps({
        ...getBoolean(this.el, "controlled") ? { value: getStringList(this.el, "value") } : { defaultValue: getStringList(this.el, "defaultValue") },
        name: getString(this.el, "name"),
        form: getString(this.el, "form"),
        disabled: getBoolean(this.el, "disabled"),
        multiple: getBoolean(this.el, "multiple"),
        dir: getString(this.el, "dir", ["ltr", "rtl"]),
        invalid: getBoolean(this.el, "invalid"),
        required: getBoolean(this.el, "required"),
        readOnly: getBoolean(this.el, "readOnly")
      });
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
    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }
    this.combobox?.destroy();
  }
};

// ../node_modules/.pnpm/@zag-js+checkbox@1.33.1/node_modules/@zag-js/checkbox/dist/index.mjs
var anatomy7 = createAnatomy("checkbox").parts("root", "label", "control", "indicator");
var parts7 = anatomy7.build();
var getRootId7 = (ctx) => ctx.ids?.root ?? `checkbox:${ctx.id}`;
var getLabelId4 = (ctx) => ctx.ids?.label ?? `checkbox:${ctx.id}:label`;
var getControlId4 = (ctx) => ctx.ids?.control ?? `checkbox:${ctx.id}:control`;
var getHiddenInputId2 = (ctx) => ctx.ids?.hiddenInput ?? `checkbox:${ctx.id}:input`;
var getRootEl5 = (ctx) => ctx.getById(getRootId7(ctx));
var getHiddenInputEl2 = (ctx) => ctx.getById(getHiddenInputId2(ctx));
function connect7(service, normalize) {
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
      return normalize.label({
        ...parts7.root.attrs,
        ...dataAttrs,
        dir: prop("dir"),
        id: getRootId7(scope),
        htmlFor: getHiddenInputId2(scope),
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
          if (target === getHiddenInputEl2(scope)) {
            event.stopPropagation();
          }
        }
      });
    },
    getLabelProps() {
      return normalize.element({
        ...parts7.label.attrs,
        ...dataAttrs,
        dir: prop("dir"),
        id: getLabelId4(scope)
      });
    },
    getControlProps() {
      return normalize.element({
        ...parts7.control.attrs,
        ...dataAttrs,
        dir: prop("dir"),
        id: getControlId4(scope),
        "aria-hidden": true
      });
    },
    getIndicatorProps() {
      return normalize.element({
        ...parts7.indicator.attrs,
        ...dataAttrs,
        dir: prop("dir"),
        hidden: !indeterminate && !checked
      });
    },
    getHiddenInputProps() {
      return normalize.input({
        id: getHiddenInputId2(scope),
        type: "checkbox",
        required: prop("required"),
        defaultChecked: checked,
        disabled,
        "aria-labelledby": getLabelId4(scope),
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
var { not: not7 } = createGuards();
var machine7 = createMachine({
  props({ props: props22 }) {
    return {
      value: "on",
      ...props22,
      defaultChecked: props22.defaultChecked ?? false
    };
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
          prop("onCheckedChange")?.({ checked });
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
        guard: not7("isTrusted"),
        actions: ["toggleChecked", "dispatchChangeEvent"]
      },
      {
        actions: ["toggleChecked"]
      }
    ],
    "CHECKED.SET": [
      {
        guard: not7("isTrusted"),
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
          pointerNode: getRootEl5(scope),
          keyboardNode: getHiddenInputEl2(scope),
          isValidKey: (event) => event.key === " ",
          onPress: () => context.set("active", false),
          onPressStart: () => context.set("active", true),
          onPressEnd: () => context.set("active", false)
        });
      },
      trackFocusVisible({ computed, scope }) {
        if (computed("disabled")) return;
        return trackFocusVisible({ root: scope.getRootNode?.() });
      },
      trackFormControlState({ context, scope }) {
        return trackFormControl(getHiddenInputEl2(scope), {
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
        const inputEl = getHiddenInputEl2(scope);
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
          const inputEl = getHiddenInputEl2(scope);
          dispatchInputCheckedEvent(inputEl, { checked: computed("checked") });
        });
      }
    }
  }
});
function isIndeterminate(checked) {
  return checked === "indeterminate";
}
function isChecked(checked) {
  return isIndeterminate(checked) ? false : !!checked;
}
var props6 = createProps()([
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
var splitProps7 = createSplitProps(props6);

// components/checkbox.ts
var Checkbox = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props13) {
    return new VanillaMachine(machine7, props13);
  }
  initApi() {
    return connect7(this.machine.service, normalizeProps);
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

// hooks/checkbox.ts
var CheckboxHook = {
  mounted() {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    this.wasFocused = false;
    const indeterminateAttr = el.getAttribute("data-indeterminate");
    const indeterminate = indeterminateAttr !== null && indeterminateAttr !== "false";
    const checkedValue = getBoolean(el, "checked");
    const defaultCheckedValue = getBoolean(el, "defaultChecked");
    let checkedProp;
    let defaultCheckedProp;
    if (indeterminate) {
      if (getBoolean(el, "controlled")) {
        checkedProp = "indeterminate";
      } else {
        defaultCheckedProp = "indeterminate";
      }
    } else {
      if (getBoolean(el, "controlled")) {
        checkedProp = checkedValue;
      } else {
        defaultCheckedProp = defaultCheckedValue;
      }
    }
    const zagCheckbox = new Checkbox(el, {
      id: el.id,
      ...checkedProp !== void 0 ? { checked: checkedProp } : {},
      ...defaultCheckedProp !== void 0 ? { defaultChecked: defaultCheckedProp } : {},
      disabled: getBoolean(el, "disabled"),
      name: getString(el, "name"),
      form: getString(el, "form"),
      value: getString(el, "value"),
      dir: getString(el, "dir", ["ltr", "rtl"]),
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
    });
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
  beforeUpdate() {
    this.wasFocused = this.checkbox?.api.focused ?? false;
  },
  updated() {
    this.checkbox?.updateProps({
      id: this.el.id,
      ...getBoolean(this.el, "controlled") ? { checked: getBoolean(this.el, "checked") } : { defaultChecked: getBoolean(this.el, "defaultChecked") },
      disabled: getBoolean(this.el, "disabled"),
      name: getString(this.el, "name"),
      form: getString(this.el, "form"),
      value: getString(this.el, "value"),
      dir: getString(this.el, "dir", ["ltr", "rtl"]),
      invalid: getBoolean(this.el, "invalid"),
      required: getBoolean(this.el, "required"),
      readOnly: getBoolean(this.el, "readOnly"),
      label: getString(this.el, "label")
    });
    if (getBoolean(this.el, "controlled")) {
      if (this.wasFocused) {
        const hiddenInput = this.el.querySelector('[data-part="hidden-input"]');
        hiddenInput?.focus();
      }
    }
  },
  destroyed() {
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
    this.checkbox?.destroy();
  }
};

// ../node_modules/.pnpm/@zag-js+tabs@1.33.1/node_modules/@zag-js/tabs/dist/index.mjs
var anatomy8 = createAnatomy("tabs").parts("root", "list", "trigger", "content", "indicator");
var parts8 = anatomy8.build();
var getRootId8 = (ctx) => ctx.ids?.root ?? `tabs:${ctx.id}`;
var getListId = (ctx) => ctx.ids?.list ?? `tabs:${ctx.id}:list`;
var getContentId3 = (ctx, value) => ctx.ids?.content?.(value) ?? `tabs:${ctx.id}:content-${value}`;
var getTriggerId3 = (ctx, value) => ctx.ids?.trigger?.(value) ?? `tabs:${ctx.id}:trigger-${value}`;
var getIndicatorId = (ctx) => ctx.ids?.indicator ?? `tabs:${ctx.id}:indicator`;
var getListEl = (ctx) => ctx.getById(getListId(ctx));
var getContentEl3 = (ctx, value) => ctx.getById(getContentId3(ctx, value));
var getTriggerEl3 = (ctx, value) => value != null ? ctx.getById(getTriggerId3(ctx, value)) : null;
var getIndicatorEl = (ctx) => ctx.getById(getIndicatorId(ctx));
var getElements2 = (ctx) => {
  const ownerId = CSS.escape(getListId(ctx));
  const selector = `[role=tab][data-ownedby='${ownerId}']:not([disabled])`;
  return queryAll(getListEl(ctx), selector);
};
var getFirstTriggerEl2 = (ctx) => first(getElements2(ctx));
var getLastTriggerEl2 = (ctx) => last(getElements2(ctx));
var getNextTriggerEl2 = (ctx, opts) => nextById(getElements2(ctx), getTriggerId3(ctx, opts.value), opts.loopFocus);
var getPrevTriggerEl2 = (ctx, opts) => prevById(getElements2(ctx), getTriggerId3(ctx, opts.value), opts.loopFocus);
var getOffsetRect = (el) => ({
  x: el?.offsetLeft ?? 0,
  y: el?.offsetTop ?? 0,
  width: el?.offsetWidth ?? 0,
  height: el?.offsetHeight ?? 0
});
var getRectByValue = (ctx, value) => {
  const tab = itemById(getElements2(ctx), getTriggerId3(ctx, value));
  return getOffsetRect(tab);
};
function connect8(service, normalize) {
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
      const id = getTriggerId3(scope, value);
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
      const value = context.get("value");
      if (!value) return;
      getTriggerEl3(scope, value)?.focus();
    },
    getRootProps() {
      return normalize.element({
        ...parts8.root.attrs,
        id: getRootId8(scope),
        "data-orientation": prop("orientation"),
        "data-focus": dataAttr(focused),
        dir: prop("dir")
      });
    },
    getListProps() {
      return normalize.element({
        ...parts8.list.attrs,
        id: getListId(scope),
        role: "tablist",
        dir: prop("dir"),
        "data-focus": dataAttr(focused),
        "aria-orientation": prop("orientation"),
        "data-orientation": prop("orientation"),
        "aria-label": translations?.listLabel,
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
      });
    },
    getTriggerState,
    getTriggerProps(props22) {
      const { value, disabled } = props22;
      const triggerState = getTriggerState(props22);
      return normalize.button({
        ...parts8.trigger.attrs,
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
        "aria-controls": triggerState.selected ? getContentId3(scope, value) : void 0,
        "data-ownedby": getListId(scope),
        "data-ssr": dataAttr(context.get("ssr")),
        id: getTriggerId3(scope, value),
        tabIndex: triggerState.selected && composite ? 0 : -1,
        onFocus() {
          send({ type: "TAB_FOCUS", value });
        },
        onBlur(event) {
          const target = event.relatedTarget;
          if (target?.getAttribute("role") !== "tab") {
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
      });
    },
    getContentProps(props22) {
      const { value } = props22;
      const selected = context.get("value") === value;
      return normalize.element({
        ...parts8.content.attrs,
        dir: prop("dir"),
        id: getContentId3(scope, value),
        tabIndex: composite ? 0 : -1,
        "aria-labelledby": getTriggerId3(scope, value),
        role: "tabpanel",
        "data-ownedby": getListId(scope),
        "data-selected": dataAttr(selected),
        "data-orientation": prop("orientation"),
        hidden: !selected
      });
    },
    getIndicatorProps() {
      const rect = context.get("indicatorRect");
      const rectIsEmpty = rect == null || rect.width === 0 && rect.height === 0 && rect.x === 0 && rect.y === 0;
      return normalize.element({
        id: getIndicatorId(scope),
        ...parts8.indicator.attrs,
        dir: prop("dir"),
        "data-orientation": prop("orientation"),
        hidden: rectIsEmpty,
        style: {
          "--transition-property": "left, right, top, bottom, width, height",
          "--left": toPx(rect?.x),
          "--top": toPx(rect?.y),
          "--width": toPx(rect?.width),
          "--height": toPx(rect?.height),
          position: "absolute",
          willChange: "var(--transition-property)",
          transitionProperty: "var(--transition-property)",
          transitionDuration: "var(--transition-duration, 150ms)",
          transitionTimingFunction: "var(--transition-timing-function)",
          [isHorizontal ? "left" : "top"]: isHorizontal ? "var(--left)" : "var(--top)"
        }
      });
    }
  };
}
var { createMachine: createMachine4 } = setup();
var machine8 = createMachine4({
  props({ props: props22 }) {
    return {
      dir: "ltr",
      orientation: "horizontal",
      activationMode: "automatic",
      loopFocus: true,
      composite: true,
      navigate(details) {
        clickIfLink(details.node);
      },
      defaultValue: null,
      ...props22
    };
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
          prop("onValueChange")?.({ value });
        }
      })),
      focusedValue: bindable2(() => ({
        defaultValue: prop("value") || prop("defaultValue"),
        sync: true,
        onChange(value) {
          prop("onFocusChange")?.({ focusedValue: value });
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
          getFirstTriggerEl2(scope)?.focus();
        });
      },
      focusLastTab({ scope }) {
        raf(() => {
          getLastTriggerEl2(scope)?.focus();
        });
      },
      focusNextTab({ context, prop, scope, event }) {
        const focusedValue = event.value ?? context.get("focusedValue");
        if (!focusedValue) return;
        const triggerEl = getNextTriggerEl2(scope, {
          value: focusedValue,
          loopFocus: prop("loopFocus")
        });
        raf(() => {
          if (prop("composite")) {
            triggerEl?.focus();
          } else if (triggerEl?.dataset.value != null) {
            context.set("focusedValue", triggerEl.dataset.value);
          }
        });
      },
      focusPrevTab({ context, prop, scope, event }) {
        const focusedValue = event.value ?? context.get("focusedValue");
        if (!focusedValue) return;
        const triggerEl = getPrevTriggerEl2(scope, {
          value: focusedValue,
          loopFocus: prop("loopFocus")
        });
        raf(() => {
          if (prop("composite")) {
            triggerEl?.focus();
          } else if (triggerEl?.dataset.value != null) {
            context.set("focusedValue", triggerEl.dataset.value);
          }
        });
      },
      syncTabIndex({ context, scope }) {
        raf(() => {
          const value = context.get("value");
          if (!value) return;
          const contentEl = getContentEl3(scope, value);
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
        const value = event.id ?? context.get("value");
        const indicatorEl = getIndicatorEl(scope);
        if (!indicatorEl) return;
        if (!value) return;
        const triggerEl = getTriggerEl3(scope, value);
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
          const triggerEl = getTriggerEl3(scope, context.get("value"));
          if (!triggerEl) return;
          const rect = getOffsetRect(triggerEl);
          context.set("indicatorRect", (prev) => isEqual2(prev, rect) ? prev : rect);
        };
        exec();
        const triggerEls = getElements2(scope);
        const indicatorCleanup = callAll(...triggerEls.map((el) => resizeObserverBorderBox.observe(el, exec)));
        refs.set("indicatorCleanup", indicatorCleanup);
      },
      navigateIfNeeded({ context, prop, scope }) {
        const value = context.get("value");
        if (!value) return;
        const triggerEl = getTriggerEl3(scope, value);
        if (isAnchorElement(triggerEl)) {
          prop("navigate")?.({ value, node: triggerEl, href: triggerEl.href });
        }
      }
    }
  }
});
var props7 = createProps()([
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
var splitProps8 = createSplitProps(props7);
var triggerProps = createProps()(["disabled", "value"]);
var splitTriggerProps = createSplitProps(triggerProps);
var contentProps = createProps()(["value"]);
var splitContentProps = createSplitProps(contentProps);

// components/tabs.ts
var Tabs = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props13) {
    return new VanillaMachine(machine8, props13);
  }
  initApi() {
    return connect8(this.machine.service, normalizeProps);
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
      this.spreadProps(triggerEl, this.api.getTriggerProps({ value: item.value }));
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

// hooks/tabs.ts
var TabsHook = {
  mounted() {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const tabs = new Tabs(
      el,
      {
        id: el.id,
        composite: true,
        ...getBoolean(el, "controlled") ? { value: getString(el, "value") } : { defaultValue: getString(el, "defaultValue") },
        orientation: getString(el, "orientation", ["horizontal", "vertical"]),
        dir: getString(el, "dir", ["ltr", "rtl"]),
        onValueChange: (details) => {
          const eventName = getString(el, "onValueChange");
          if (eventName && this.liveSocket.main.isConnected()) {
            pushEvent(eventName, {
              id: el.id,
              value: details.value ?? null
            });
          }
          const eventNameClient = getString(el, "onValueChangeClient");
          if (eventNameClient) {
            el.dispatchEvent(
              new CustomEvent(eventNameClient, {
                bubbles: true,
                detail: {
                  id: el.id,
                  value: details.value ?? null
                }
              })
            );
          }
        },
        onFocusChange: (details) => {
          const eventName = getString(el, "onFocusChange");
          if (eventName && this.liveSocket.main.isConnected()) {
            pushEvent(eventName, {
              id: el.id,
              value: details.focusedValue ?? null
            });
          }
          const eventNameClient = getString(el, "onFocusChangeClient");
          if (eventNameClient) {
            el.dispatchEvent(
              new CustomEvent(eventNameClient, {
                bubbles: true,
                detail: {
                  id: el.id,
                  value: details.focusedValue ?? null
                }
              })
            );
          }
        }
      }
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
    this.tabs?.updateProps({
      id: this.el.id,
      ...getBoolean(this.el, "controlled") ? { value: getString(this.el, "value") } : { defaultValue: getString(this.el, "defaultValue") },
      orientation: getString(this.el, "orientation", ["horizontal", "vertical"]),
      dir: getString(this.el, "dir", ["ltr", "rtl"])
    });
    const wasFocused = this.tabs?.api?.focusedValue;
    if (wasFocused) {
      const triggerEl = this.el.querySelector(
        `[data-scope="tabs"][data-part="list"] [data-part="trigger"][data-value="${wasFocused}"]`
      );
      if (triggerEl && document.activeElement !== triggerEl) {
        triggerEl.focus();
      }
    }
  },
  destroyed() {
    if (this.onSetValue) {
      this.el.removeEventListener("phx:tabs:set-value", this.onSetValue);
    }
    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }
    this.tabs?.destroy();
  }
};

// ../node_modules/.pnpm/@zag-js+clipboard@1.33.1/node_modules/@zag-js/clipboard/dist/index.mjs
var anatomy9 = createAnatomy("clipboard").parts("root", "control", "trigger", "indicator", "input", "label");
var parts9 = anatomy9.build();
var getRootId9 = (ctx) => ctx.ids?.root ?? `clip:${ctx.id}`;
var getInputId2 = (ctx) => ctx.ids?.input ?? `clip:${ctx.id}:input`;
var getLabelId5 = (ctx) => ctx.ids?.label ?? `clip:${ctx.id}:label`;
var getInputEl2 = (ctx) => ctx.getById(getInputId2(ctx));
var writeToClipboard = (ctx, value) => copyText(ctx.getDoc(), value);
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
  const win = doc.defaultView || window;
  if (win.navigator.clipboard?.writeText !== void 0) {
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
function connect9(service, normalize) {
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
      return normalize.element({
        ...parts9.root.attrs,
        "data-copied": dataAttr(copied),
        id: getRootId9(scope)
      });
    },
    getLabelProps() {
      return normalize.label({
        ...parts9.label.attrs,
        htmlFor: getInputId2(scope),
        "data-copied": dataAttr(copied),
        id: getLabelId5(scope)
      });
    },
    getControlProps() {
      return normalize.element({
        ...parts9.control.attrs,
        "data-copied": dataAttr(copied)
      });
    },
    getInputProps() {
      return normalize.input({
        ...parts9.input.attrs,
        defaultValue: context.get("value"),
        "data-copied": dataAttr(copied),
        readOnly: true,
        "data-readonly": "true",
        id: getInputId2(scope),
        onFocus(event) {
          event.currentTarget.select();
        },
        onCopy() {
          send({ type: "INPUT.COPY" });
        }
      });
    },
    getTriggerProps() {
      return normalize.button({
        ...parts9.trigger.attrs,
        type: "button",
        "aria-label": copied ? "Copied to clipboard" : "Copy to clipboard",
        "data-copied": dataAttr(copied),
        onClick() {
          send({ type: "COPY" });
        }
      });
    },
    getIndicatorProps(props22) {
      return normalize.element({
        ...parts9.indicator.attrs,
        hidden: props22.copied !== copied
      });
    }
  };
}
var machine9 = createMachine({
  props({ props: props22 }) {
    return {
      timeout: 3e3,
      defaultValue: "",
      ...props22
    };
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
          prop("onValueChange")?.({ value });
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
        prop("onStatusChange")?.({ copied: true });
      },
      syncInputElement({ context, scope }) {
        const inputEl = getInputEl2(scope);
        if (!inputEl) return;
        setElementValue(inputEl, context.get("value"));
      }
    }
  }
});
var props8 = createProps()([
  "getRootNode",
  "id",
  "ids",
  "value",
  "defaultValue",
  "timeout",
  "onStatusChange",
  "onValueChange"
]);
var contextProps = createSplitProps(props8);
var indicatorProps = createProps()(["copied"]);
var splitIndicatorProps = createSplitProps(indicatorProps);

// components/clipboard.ts
var Clipboard = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props13) {
    return new VanillaMachine(machine9, props13);
  }
  initApi() {
    return connect9(this.machine.service, normalizeProps);
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
          const inputProps2 = { ...this.api.getInputProps() };
          const inputAriaLabel = this.el.dataset.inputAriaLabel;
          if (inputAriaLabel) {
            inputProps2["aria-label"] = inputAriaLabel;
          }
          this.spreadProps(inputEl, inputProps2);
        }
        const triggerEl = controlEl.querySelector('[data-scope="clipboard"][data-part="trigger"]');
        if (triggerEl) {
          const triggerProps2 = { ...this.api.getTriggerProps() };
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

// hooks/clipboard.ts
var ClipboardHook = {
  mounted() {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const liveSocket = this.liveSocket;
    const clipboard = new Clipboard(el, {
      id: el.id,
      timeout: getNumber(el, "timeout"),
      ...getBoolean(el, "controlled") ? { value: getString(el, "value") } : { defaultValue: getString(el, "defaultValue") },
      onValueChange: (details) => {
        const eventName = getString(el, "onValueChange");
        if (eventName && liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            id: el.id,
            value: details.value ?? null
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
    });
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
    this.clipboard?.updateProps({
      id: this.el.id,
      timeout: getNumber(this.el, "timeout"),
      ...getBoolean(this.el, "controlled") ? { value: getString(this.el, "value") } : { defaultValue: getString(this.el, "value") },
      dir: getString(this.el, "dir", ["ltr", "rtl"])
    });
  },
  destroyed() {
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
    this.clipboard?.destroy();
  }
};

// ../node_modules/.pnpm/@zag-js+collapsible@1.33.1/node_modules/@zag-js/collapsible/dist/index.mjs
var anatomy10 = createAnatomy("collapsible").parts("root", "trigger", "content", "indicator");
var parts10 = anatomy10.build();
var getRootId10 = (ctx) => ctx.ids?.root ?? `collapsible:${ctx.id}`;
var getContentId4 = (ctx) => ctx.ids?.content ?? `collapsible:${ctx.id}:content`;
var getTriggerId4 = (ctx) => ctx.ids?.trigger ?? `collapsible:${ctx.id}:trigger`;
var getContentEl4 = (ctx) => ctx.getById(getContentId4(ctx));
function connect10(service, normalize) {
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
      return normalize.element({
        ...parts10.root.attrs,
        "data-state": open ? "open" : "closed",
        dir: prop("dir"),
        id: getRootId10(scope)
      });
    },
    getContentProps() {
      return normalize.element({
        ...parts10.content.attrs,
        id: getContentId4(scope),
        "data-collapsible": "",
        "data-state": skip ? void 0 : open ? "open" : "closed",
        "data-disabled": dataAttr(disabled),
        "data-has-collapsed-size": dataAttr(hasCollapsedSize),
        hidden: !visible && !hasCollapsedSize,
        dir: prop("dir"),
        style: {
          "--height": toPx(height),
          "--width": toPx(width),
          "--collapsed-height": toPx(collapsedHeight),
          "--collapsed-width": toPx(collapsedWidth),
          ...closed && hasCollapsedHeight && {
            overflow: "hidden",
            minHeight: toPx(collapsedHeight),
            maxHeight: toPx(collapsedHeight)
          },
          ...closed && hasCollapsedWidth && {
            overflow: "hidden",
            minWidth: toPx(collapsedWidth),
            maxWidth: toPx(collapsedWidth)
          }
        }
      });
    },
    getTriggerProps() {
      return normalize.element({
        ...parts10.trigger.attrs,
        id: getTriggerId4(scope),
        dir: prop("dir"),
        type: "button",
        "data-state": open ? "open" : "closed",
        "data-disabled": dataAttr(disabled),
        "aria-controls": getContentId4(scope),
        "aria-expanded": visible || false,
        onClick(event) {
          if (event.defaultPrevented) return;
          if (disabled) return;
          send({ type: open ? "close" : "open" });
        }
      });
    },
    getIndicatorProps() {
      return normalize.element({
        ...parts10.indicator.attrs,
        dir: prop("dir"),
        "data-state": open ? "open" : "closed",
        "data-disabled": dataAttr(disabled)
      });
    }
  };
}
var machine10 = createMachine({
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
          const contentEl = getContentEl4(scope);
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
          cleanup?.();
        };
      },
      trackExitAnimation: ({ send, scope }) => {
        let cleanup;
        const rafCleanup = raf(() => {
          const contentEl = getContentEl4(scope);
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
          cleanup?.();
        };
      },
      trackTabbableElements: ({ scope, prop }) => {
        if (!prop("collapsedHeight") && !prop("collapsedWidth")) return;
        const contentEl = getContentEl4(scope);
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
        const contentEl = getContentEl4(scope);
        if (!contentEl) return;
        const { height, width } = contentEl.getBoundingClientRect();
        context.set("size", { height, width });
      },
      computeSize: ({ refs, scope, context }) => {
        refs.get("cleanup")?.();
        const rafCleanup = raf(() => {
          const contentEl = getContentEl4(scope);
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
        prop("onOpenChange")?.({ open: true });
      },
      invokeOnClose: ({ prop }) => {
        prop("onOpenChange")?.({ open: false });
      },
      invokeOnExitComplete: ({ prop }) => {
        prop("onExitComplete")?.();
      },
      toggleVisibility: ({ prop, send }) => {
        send({ type: prop("open") ? "controlled.open" : "controlled.close" });
      }
    }
  }
});
var props9 = createProps()([
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
var splitProps9 = createSplitProps(props9);

// components/collapsible.ts
var Collapsible = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props13) {
    return new VanillaMachine(machine10, props13);
  }
  initApi() {
    return connect10(this.machine.service, normalizeProps);
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

// hooks/collapsible.ts
var CollapsibleHook = {
  mounted() {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const collapsible = new Collapsible(el, {
      id: el.id,
      ...getBoolean(el, "controlled") ? { open: getBoolean(el, "open") } : { defaultOpen: getBoolean(el, "defaultOpen") },
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
    });
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
    this.collapsible?.updateProps({
      id: this.el.id,
      ...getBoolean(this.el, "controlled") ? { open: getBoolean(this.el, "open") } : { defaultOpen: getBoolean(this.el, "defaultOpen") },
      disabled: getBoolean(this.el, "disabled"),
      dir: getString(this.el, "dir", ["ltr", "rtl"])
    });
  },
  destroyed() {
    if (this.onSetOpen) {
      this.el.removeEventListener("phx:collapsible:set-open", this.onSetOpen);
    }
    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }
    this.collapsible?.destroy();
  }
};

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
}).filter((x2) => Boolean(x2));
var ignoreableNodes = /* @__PURE__ */ new Set(["script", "output", "status", "next-route-announcer"]);
var isIgnoredNode = (node) => {
  if (ignoreableNodes.has(node.localName)) return true;
  if (node.role === "status") return true;
  if (node.hasAttribute("aria-live")) return true;
  return node.matches("[data-live-announcer]");
};
var walkTreeOutside = (originalTarget, props13) => {
  const { parentNode, markerName, controlAttribute, followControlledElements = true } = props13;
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
var getParentNode3 = (originalTarget) => {
  const target = Array.isArray(originalTarget) ? originalTarget[0] : originalTarget;
  return target.ownerDocument.body;
};
var hideOthers = (originalTarget, parentNode = getParentNode3(originalTarget), markerName = "data-aria-hidden", followControlledElements = true) => {
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
    cleanups.forEach((fn) => fn?.());
  };
}

// ../node_modules/.pnpm/@zag-js+focus-trap@1.33.1/node_modules/@zag-js/focus-trap/dist/index.mjs
var __defProp6 = Object.defineProperty;
var __defNormalProp5 = (obj, key, value) => key in obj ? __defProp6(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
var __publicField5 = (obj, key, value) => __defNormalProp5(obj, typeof key !== "symbol" ? key + "" : key, value);
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
    __publicField5(this, "pause", (pauseOptions) => {
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
    __publicField5(this, "unpause", (unpauseOptions) => {
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
var isKeyForward = (e2) => isKeyboardEvent(e2) && e2.key === "Tab" && !e2?.shiftKey;
var isKeyBackward = (e2) => isKeyboardEvent(e2) && e2.key === "Tab" && e2?.shiftKey;
var valueOrHandler = (value, ...params) => typeof value === "function" ? value(...params) : value;
var isEscapeEvent = (event) => !event.isComposing && event.key === "Escape";
var delay = (fn) => setTimeout(fn, 0);
var isSelectableInput = (node) => node.localName === "input" && "select" in node && typeof node.select === "function";
function trapFocus(el, options = {}) {
  let trap;
  const cleanup = raf(() => {
    const elements = Array.isArray(el) ? el : [el];
    const resolvedElements = elements.map((e2) => typeof e2 === "function" ? e2() : e2).filter((e2) => e2 != null);
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
  const styles = getComputedStyle2(element);
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
var anatomy11 = createAnatomy("dialog").parts(
  "trigger",
  "backdrop",
  "positioner",
  "content",
  "title",
  "description",
  "closeTrigger"
);
var parts11 = anatomy11.build();
var getPositionerId3 = (ctx) => ctx.ids?.positioner ?? `dialog:${ctx.id}:positioner`;
var getBackdropId = (ctx) => ctx.ids?.backdrop ?? `dialog:${ctx.id}:backdrop`;
var getContentId5 = (ctx) => ctx.ids?.content ?? `dialog:${ctx.id}:content`;
var getTriggerId5 = (ctx) => ctx.ids?.trigger ?? `dialog:${ctx.id}:trigger`;
var getTitleId2 = (ctx) => ctx.ids?.title ?? `dialog:${ctx.id}:title`;
var getDescriptionId2 = (ctx) => ctx.ids?.description ?? `dialog:${ctx.id}:description`;
var getCloseTriggerId2 = (ctx) => ctx.ids?.closeTrigger ?? `dialog:${ctx.id}:close`;
var getContentEl5 = (ctx) => ctx.getById(getContentId5(ctx));
var getPositionerEl3 = (ctx) => ctx.getById(getPositionerId3(ctx));
var getBackdropEl = (ctx) => ctx.getById(getBackdropId(ctx));
var getTriggerEl4 = (ctx) => ctx.getById(getTriggerId5(ctx));
var getTitleEl = (ctx) => ctx.getById(getTitleId2(ctx));
var getDescriptionEl = (ctx) => ctx.getById(getDescriptionId2(ctx));
var getCloseTriggerEl = (ctx) => ctx.getById(getCloseTriggerId2(ctx));
function connect11(service, normalize) {
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
      return normalize.button({
        ...parts11.trigger.attrs,
        dir: prop("dir"),
        id: getTriggerId5(scope),
        "aria-haspopup": "dialog",
        type: "button",
        "aria-expanded": open,
        "data-state": open ? "open" : "closed",
        "aria-controls": getContentId5(scope),
        onClick(event) {
          if (event.defaultPrevented) return;
          send({ type: "TOGGLE" });
        }
      });
    },
    getBackdropProps() {
      return normalize.element({
        ...parts11.backdrop.attrs,
        dir: prop("dir"),
        hidden: !open,
        id: getBackdropId(scope),
        "data-state": open ? "open" : "closed"
      });
    },
    getPositionerProps() {
      return normalize.element({
        ...parts11.positioner.attrs,
        dir: prop("dir"),
        id: getPositionerId3(scope),
        style: {
          pointerEvents: open ? void 0 : "none"
        }
      });
    },
    getContentProps() {
      const rendered = context.get("rendered");
      return normalize.element({
        ...parts11.content.attrs,
        dir: prop("dir"),
        role: prop("role"),
        hidden: !open,
        id: getContentId5(scope),
        tabIndex: -1,
        "data-state": open ? "open" : "closed",
        "aria-modal": true,
        "aria-label": ariaLabel || void 0,
        "aria-labelledby": ariaLabel || !rendered.title ? void 0 : getTitleId2(scope),
        "aria-describedby": rendered.description ? getDescriptionId2(scope) : void 0
      });
    },
    getTitleProps() {
      return normalize.element({
        ...parts11.title.attrs,
        dir: prop("dir"),
        id: getTitleId2(scope)
      });
    },
    getDescriptionProps() {
      return normalize.element({
        ...parts11.description.attrs,
        dir: prop("dir"),
        id: getDescriptionId2(scope)
      });
    },
    getCloseTriggerProps() {
      return normalize.button({
        ...parts11.closeTrigger.attrs,
        dir: prop("dir"),
        id: getCloseTriggerId2(scope),
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
var machine11 = createMachine({
  props({ props: props22, scope }) {
    const alertDialog = props22.role === "alertdialog";
    const initialFocusEl = alertDialog ? () => getCloseTriggerEl(scope) : void 0;
    const modal = typeof props22.modal === "boolean" ? props22.modal : true;
    return {
      role: "dialog",
      modal,
      trapFocus: modal,
      preventScroll: modal,
      closeOnInteractOutside: !alertDialog,
      closeOnEscape: true,
      restoreFocus: true,
      initialFocusEl,
      ...props22
    };
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
        const getContentEl22 = () => getContentEl5(scope);
        return trackDismissableElement(getContentEl22, {
          type: "dialog",
          defer: true,
          pointerBlocking: prop("modal"),
          exclude: [getTriggerEl4(scope)],
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
        const contentEl = () => getContentEl5(scope);
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
        const getElements3 = () => [getContentEl5(scope)];
        return ariaHidden(getElements3, { defer: true });
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
          const contentEl = getContentEl5(scope);
          if (!contentEl) return;
          const styles = getComputedStyle2(contentEl);
          const elems = [getPositionerEl3(scope), getBackdropEl(scope)];
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
var props10 = createProps()([
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
var splitProps10 = createSplitProps(props10);

// components/dialog.ts
var Dialog = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props13) {
    return new VanillaMachine(machine11, props13);
  }
  initApi() {
    return connect11(this.machine.service, normalizeProps);
  }
  render() {
    const triggerEl = this.el.querySelector('[data-scope="dialog"][data-part="trigger"]');
    if (triggerEl) {
      this.spreadProps(triggerEl, this.api.getTriggerProps());
    }
    const backdropEl = this.el.querySelector('[data-scope="dialog"][data-part="backdrop"]');
    if (backdropEl) {
      this.spreadProps(backdropEl, this.api.getBackdropProps());
    }
    const positionerEl = this.el.querySelector('[data-scope="dialog"][data-part="positioner"]');
    if (positionerEl) {
      this.spreadProps(positionerEl, this.api.getPositionerProps());
    }
    const contentEl = this.el.querySelector('[data-scope="dialog"][data-part="content"]');
    if (contentEl) {
      this.spreadProps(contentEl, this.api.getContentProps());
    }
    const titleEl = this.el.querySelector('[data-scope="dialog"][data-part="title"]');
    if (titleEl) {
      this.spreadProps(titleEl, this.api.getTitleProps());
    }
    const descriptionEl = this.el.querySelector('[data-scope="dialog"][data-part="description"]');
    if (descriptionEl) {
      this.spreadProps(descriptionEl, this.api.getDescriptionProps());
    }
    const closeTriggerEl = this.el.querySelector('[data-scope="dialog"][data-part="close-trigger"]');
    if (closeTriggerEl) {
      this.spreadProps(closeTriggerEl, this.api.getCloseTriggerProps());
    }
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
      closeOnEscapeKeyDown: getBoolean(el, "closeOnEscapeKeyDown"),
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
      closeOnEscapeKeyDown: getBoolean(this.el, "closeOnEscapeKeyDown"),
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

// ../node_modules/.pnpm/@internationalized+date@3.11.0/node_modules/@internationalized/date/dist/utils.mjs
function $2b4dce13dd5a17fa$export$842a2cf37af977e1(amount, numerator) {
  return amount - numerator * Math.floor(amount / numerator);
}

// ../node_modules/.pnpm/@internationalized+date@3.11.0/node_modules/@internationalized/date/dist/GregorianCalendar.mjs
var $3b62074eb05584b2$var$EPOCH = 1721426;
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
var $3b62074eb05584b2$var$daysInMonth = {
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
var $3b62074eb05584b2$export$80ee6245ec4f29ec = class {
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

// ../node_modules/.pnpm/@internationalized+date@3.11.0/node_modules/@internationalized/date/dist/weekStartData.mjs
var $2fe286d2fb449abb$export$7a5acbd77d414bd9 = {
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

// ../node_modules/.pnpm/@internationalized+date@3.11.0/node_modules/@internationalized/date/dist/queries.mjs
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
var $14e0f24ef4ac5c92$var$DAY_MAP = {
  sun: 0,
  mon: 1,
  tue: 2,
  wed: 3,
  thu: 4,
  fri: 5,
  sat: 6
};
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
var $14e0f24ef4ac5c92$var$localTimeZone = null;
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
var $14e0f24ef4ac5c92$var$cachedRegions = /* @__PURE__ */ new Map();
var $14e0f24ef4ac5c92$var$cachedWeekInfo = /* @__PURE__ */ new Map();
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
var $14e0f24ef4ac5c92$var$WEEKEND_DATA = {
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

// ../node_modules/.pnpm/@internationalized+date@3.11.0/node_modules/@internationalized/date/dist/conversion.mjs
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
var $11d87f3f76e88657$var$formattersByTimeZone = /* @__PURE__ */ new Map();
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
  let parts14 = formatter.formatToParts(new Date(ms));
  let namedParts = {};
  for (let part of parts14) if (part.type !== "literal") namedParts[part.type] = part.value;
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
var $11d87f3f76e88657$var$DAYMILLIS = 864e5;
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
  let parts14 = $11d87f3f76e88657$var$getTimeZoneParts(absolute, timeZone);
  return date.year === parts14.year && date.month === parts14.month && date.day === parts14.day && date.hour === parts14.hour && date.minute === parts14.minute && date.second === parts14.second;
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

// ../node_modules/.pnpm/@internationalized+date@3.11.0/node_modules/@internationalized/date/dist/manipulation.mjs
var $735220c2d4774dd3$var$ONE_HOUR = 36e5;
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
      let min3 = 0;
      let max3 = 23;
      if ((options === null || options === void 0 ? void 0 : options.hourCycle) === 12) {
        let isPM = hours >= 12;
        min3 = isPM ? 12 : 0;
        max3 = isPM ? 23 : 11;
      }
      mutable.hour = $735220c2d4774dd3$var$cycleValue(hours, amount, min3, max3, options === null || options === void 0 ? void 0 : options.round);
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
function $735220c2d4774dd3$var$cycleValue(value, amount, min3, max3, round3 = false) {
  if (round3) {
    value += Math.sign(amount);
    if (value < min3) value = max3;
    let div = Math.abs(amount);
    if (amount > 0) value = Math.ceil(value / div) * div;
    else value = Math.floor(value / div) * div;
    if (value > max3) value = min3;
  } else {
    value += amount;
    if (value < min3) value = max3 - (min3 - value - 1);
    else if (value > max3) value = min3 + (value - max3 - 1);
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
      let min3 = 0;
      let max3 = 23;
      if ((options === null || options === void 0 ? void 0 : options.hourCycle) === 12) {
        let isPM = dateTime.hour >= 12;
        min3 = isPM ? 12 : 0;
        max3 = isPM ? 23 : 11;
      }
      let plainDateTime = (0, $11d87f3f76e88657$export$b21e0b124e224484)(dateTime);
      let minDate = (0, $11d87f3f76e88657$export$b4a036af3fc0b032)($735220c2d4774dd3$export$e5d5e1c1822b6e56(plainDateTime, {
        hour: min3
      }), new (0, $3b62074eb05584b2$export$80ee6245ec4f29ec)());
      let minAbsolute = [
        (0, $11d87f3f76e88657$export$5107c82f94518f5c)(minDate, dateTime.timeZone, "earlier"),
        (0, $11d87f3f76e88657$export$5107c82f94518f5c)(minDate, dateTime.timeZone, "later")
      ].filter((ms2) => (0, $11d87f3f76e88657$export$1b96692a1ba042ac)(ms2, dateTime.timeZone).day === minDate.day)[0];
      let maxDate = (0, $11d87f3f76e88657$export$b4a036af3fc0b032)($735220c2d4774dd3$export$e5d5e1c1822b6e56(plainDateTime, {
        hour: max3
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

// ../node_modules/.pnpm/@internationalized+date@3.11.0/node_modules/@internationalized/date/dist/string.mjs
var $fae977aafc393c5c$var$DATE_RE = /^([+-]\d{6}|\d{4})-(\d{2})-(\d{2})$/;
var $fae977aafc393c5c$var$ABSOLUTE_RE = /^([+-]\d{6}|\d{4})-(\d{2})-(\d{2})(?:T(\d{2}))?(?::(\d{2}))?(?::(\d{2}))?(\.\d+)?(?:(?:([+-]\d{2})(?::?(\d{2}))?)|Z)$/;
var $fae977aafc393c5c$var$requiredDurationTimeGroups = [
  "hours",
  "minutes",
  "seconds"
];
var $fae977aafc393c5c$var$requiredDurationGroups = [
  "years",
  "months",
  "weeks",
  "days",
  ...$fae977aafc393c5c$var$requiredDurationTimeGroups
];
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
function $fae977aafc393c5c$var$parseNumber(value, min3, max3) {
  let val = Number(value);
  if (val < min3 || val > max3) throw new RangeError(`Value out of range: ${min3} <= ${val} <= ${max3}`);
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
  let sign2 = Math.sign(offset3) < 0 ? "-" : "+";
  offset3 = Math.abs(offset3);
  let offsetHours = Math.floor(offset3 / 36e5);
  let offsetMinutes = Math.floor(offset3 % 36e5 / 6e4);
  let offsetSeconds = Math.floor(offset3 % 36e5 % 6e4 / 1e3);
  let stringOffset = `${sign2}${String(offsetHours).padStart(2, "0")}:${String(offsetMinutes).padStart(2, "0")}`;
  if (offsetSeconds !== 0) stringOffset += `:${String(offsetSeconds).padStart(2, "0")}`;
  return stringOffset;
}
function $fae977aafc393c5c$export$bf79f1ebf4b18792(date) {
  return `${$fae977aafc393c5c$export$4223de14708adc63(date)}${$fae977aafc393c5c$var$offsetToString(date.offset)}[${date.timeZone}]`;
}

// ../node_modules/.pnpm/@swc+helpers@0.5.18/node_modules/@swc/helpers/esm/_check_private_redeclaration.js
function _check_private_redeclaration(obj, privateCollection) {
  if (privateCollection.has(obj)) {
    throw new TypeError("Cannot initialize the same private elements twice on an object");
  }
}

// ../node_modules/.pnpm/@swc+helpers@0.5.18/node_modules/@swc/helpers/esm/_class_private_field_init.js
function _class_private_field_init(obj, privateMap, value) {
  _check_private_redeclaration(obj, privateMap);
  privateMap.set(obj, value);
}

// ../node_modules/.pnpm/@internationalized+date@3.11.0/node_modules/@internationalized/date/dist/CalendarDate.mjs
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
var $35ea8db9cb2ccb90$var$_type = /* @__PURE__ */ new WeakMap();
var $35ea8db9cb2ccb90$export$99faa760c7908e4f = class _$35ea8db9cb2ccb90$export$99faa760c7908e4f {
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
var $35ea8db9cb2ccb90$var$_type2 = /* @__PURE__ */ new WeakMap();
var $35ea8db9cb2ccb90$export$ca871e8dbb80966f = class _$35ea8db9cb2ccb90$export$ca871e8dbb80966f {
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
var $35ea8db9cb2ccb90$var$_type3 = /* @__PURE__ */ new WeakMap();
var $35ea8db9cb2ccb90$export$d3b7288e7994edea = class _$35ea8db9cb2ccb90$export$d3b7288e7994edea {
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

// ../node_modules/.pnpm/@internationalized+date@3.11.0/node_modules/@internationalized/date/dist/DateFormatter.mjs
var $fb18d541ea1ad717$var$formatterCache = /* @__PURE__ */ new Map();
var $fb18d541ea1ad717$export$ad991b66133851cf = class {
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
      ...startParts.map((p2) => ({
        ...p2,
        source: "startRange"
      })),
      {
        type: "literal",
        value: " \u2013 ",
        source: "shared"
      },
      ...endParts.map((p2) => ({
        ...p2,
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
var $fb18d541ea1ad717$var$hour12Preferences = {
  true: {
    // Only Japanese uses the h11 style for 12 hour time. All others use h12.
    ja: "h11"
  },
  false: {}
};
function $fb18d541ea1ad717$var$getCachedDateFormatter(locale, options = {}) {
  if (typeof options.hour12 === "boolean" && $fb18d541ea1ad717$var$hasBuggyHour12Behavior()) {
    options = {
      ...options
    };
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
var $fb18d541ea1ad717$var$_hasBuggyHour12Behavior = null;
function $fb18d541ea1ad717$var$hasBuggyHour12Behavior() {
  if ($fb18d541ea1ad717$var$_hasBuggyHour12Behavior == null) $fb18d541ea1ad717$var$_hasBuggyHour12Behavior = new Intl.DateTimeFormat("en-US", {
    hour: "numeric",
    hour12: false
  }).format(new Date(2020, 2, 3, 0)) === "24";
  return $fb18d541ea1ad717$var$_hasBuggyHour12Behavior;
}
var $fb18d541ea1ad717$var$_hasBuggyResolvedHourCycle = null;
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
  let formatter = $fb18d541ea1ad717$var$getCachedDateFormatter(locale, {
    ...options,
    timeZone: void 0
    // use local timezone
  });
  let min3 = parseInt(formatter.formatToParts(new Date(2020, 2, 3, 0)).find((p2) => p2.type === "hour").value, 10);
  let max3 = parseInt(formatter.formatToParts(new Date(2020, 2, 3, 23)).find((p2) => p2.type === "hour").value, 10);
  if (min3 === 0 && max3 === 23) return "h23";
  if (min3 === 24 && max3 === 23) return "h24";
  if (min3 === 0 && max3 === 11) return "h11";
  if (min3 === 12 && max3 === 11) return "h12";
  throw new Error("Unexpected hour cycle result");
}

// ../node_modules/.pnpm/@zag-js+date-utils@1.33.1_@internationalized+date@3.11.0/node_modules/@zag-js/date-utils/dist/index.mjs
function alignCenter(date, duration, locale, min3, max3) {
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
  return constrainStart(date, aligned, duration, locale, min3, max3);
}
function alignStart(date, duration, locale, min3, max3) {
  let aligned = date;
  if (duration.years) {
    aligned = $14e0f24ef4ac5c92$export$f91e89d3d0406102(date);
  } else if (duration.months) {
    aligned = $14e0f24ef4ac5c92$export$a5a3b454ada2268e(date);
  } else if (duration.weeks) {
    aligned = $14e0f24ef4ac5c92$export$42c81a444fbfb5d4(date, locale);
  }
  return constrainStart(date, aligned, duration, locale, min3, max3);
}
function alignEnd(date, duration, locale, min3, max3) {
  let d2 = { ...duration };
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
  return constrainStart(date, aligned, duration, locale, min3, max3);
}
function constrainStart(date, aligned, duration, locale, min3, max3) {
  if (min3 && date.compare(min3) >= 0) {
    aligned = $14e0f24ef4ac5c92$export$a75f2bff57811055(aligned, alignStart($11d87f3f76e88657$export$93522d1a439f3617(min3), duration, locale));
  }
  if (max3 && date.compare(max3) <= 0) {
    aligned = $14e0f24ef4ac5c92$export$5c333a116e949cdd(aligned, alignEnd($11d87f3f76e88657$export$93522d1a439f3617(max3), duration, locale));
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
function alignDate(date, alignment, duration, locale, min3, max3) {
  switch (alignment) {
    case "start":
      return alignStart(date, duration, locale, min3, max3);
    case "end":
      return alignEnd(date, duration, locale, min3, max3);
    case "center":
    default:
      return alignCenter(date, duration, locale, min3, max3);
  }
}
function isDateEqual(dateA, dateB) {
  if (dateA == null || dateB == null) return dateA === dateB;
  return $14e0f24ef4ac5c92$export$ea39ec197993aef0(dateA, dateB);
}
function isDateUnavailable(date, isUnavailable, locale, minValue, maxValue) {
  if (!date) return false;
  if (isUnavailable?.(date, locale)) return true;
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
  let clone = { ...duration };
  for (let key in clone) clone[key] = 1;
  return clone;
}
function getEndDate(startDate, duration) {
  let clone = { ...duration };
  if (clone.days) clone.days--;
  else clone.days = -1;
  return startDate.add(clone);
}
function getEraFormat(date) {
  return date?.calendar.identifier === "gregory" && date.era === "BC" ? "short" : void 0;
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
    calendar: date?.calendar.identifier,
    timeZone
  });
}
function formatRange(startDate, endDate, formatter, toString, timeZone) {
  let parts14 = formatter.formatRangeToParts(startDate.toDate(timeZone), endDate.toDate(timeZone));
  let separatorIndex = -1;
  for (let i2 = 0; i2 < parts14.length; i2++) {
    let part = parts14[i2];
    if (part.source === "shared" && part.type === "literal") {
      separatorIndex = i2;
    } else if (part.source === "endRange") {
      break;
    }
  }
  let start = "";
  let end = "";
  for (let i2 = 0; i2 < parts14.length; i2++) {
    if (i2 < separatorIndex) {
      start += parts14[i2].value;
    } else if (i2 > separatorIndex) {
      end += parts14[i2].value;
    }
  }
  return toString(start, end);
}
function formatSelectedDate(startDate, endDate, locale, timeZone) {
  if (!startDate) return "";
  let start = startDate;
  let end = endDate ?? startDate;
  let formatter = getDayFormatter(locale, timeZone);
  if ($14e0f24ef4ac5c92$export$ea39ec197993aef0(start, end)) {
    return formatter.format(start.toDate(timeZone));
  }
  return formatRange(start, end, formatter, (start2, end2) => `${start2} \u2013 ${end2}`, timeZone);
}
var daysOfTheWeek = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"];
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
  const monthWeeks = numOfWeeks ?? $14e0f24ef4ac5c92$export$ccc1b2479e7dd654(from, locale, firstDay);
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
var FUTURE_YEAR_COERCION = 10;
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
  const chunkSize = opts?.strict ? 10 : 12;
  const computedYear = year - year % 10;
  const years = [];
  for (let i2 = 0; i2 < chunkSize; i2 += 1) {
    const value = computedYear + i2;
    years.push(value);
  }
  return years;
}
function getTodayDate(timeZone) {
  return $14e0f24ef4ac5c92$export$d0bdf45af03a6ea3(timeZone ?? $14e0f24ef4ac5c92$export$aa8b41735afcabd2());
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
var isValidYear = (year) => year != null && year.length === 4;
var isValidMonth = (month) => month != null && parseFloat(month) <= 12;
var isValidDay = (day) => day != null && parseFloat(day) <= 31;
function parseDateString(date, locale, timeZone) {
  const regex = createRegex(locale, timeZone);
  let { year, month, day } = extract(regex, date) ?? {};
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
  const parts14 = formatter.formatToParts(new Date(2e3, 11, 25));
  return parts14.map(({ type, value }) => type === "literal" ? `${value}?` : `((?!=<${type}>)\\d+)?`).join("");
}
function extract(pattern, str) {
  const matches = str.match(pattern);
  return pattern.toString().match(/<(.+?)>/g)?.map((group2) => {
    const groupMatches = group2.match(/<(.+)>/);
    if (!groupMatches || groupMatches.length <= 0) {
      return null;
    }
    return group2.match(/<(.+)>/)?.[1];
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

// ../node_modules/.pnpm/@zag-js+live-region@1.33.1/node_modules/@zag-js/live-region/dist/index.mjs
var ID = "__live-region__";
function createLiveRegion(opts = {}) {
  const { level = "polite", document: doc = document, root, delay: _delay = 0 } = opts;
  const win = doc.defaultView ?? window;
  const parent = root ?? doc.body;
  function announce(message, delay2) {
    const oldRegion = doc.getElementById(ID);
    oldRegion?.remove();
    delay2 = delay2 ?? _delay;
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
    oldRegion?.remove();
  }
  return {
    announce,
    destroy,
    toJSON() {
      return ID;
    }
  };
}

// ../node_modules/.pnpm/@zag-js+date-picker@1.33.1_@internationalized+date@3.11.0/node_modules/@zag-js/date-picker/dist/index.mjs
var anatomy12 = createAnatomy("date-picker").parts(
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
var parts12 = anatomy12.build();
var getLabelId6 = (ctx, index) => ctx.ids?.label?.(index) ?? `datepicker:${ctx.id}:label:${index}`;
var getRootId11 = (ctx) => ctx.ids?.root ?? `datepicker:${ctx.id}`;
var getTableId = (ctx, id) => ctx.ids?.table?.(id) ?? `datepicker:${ctx.id}:table:${id}`;
var getContentId6 = (ctx) => ctx.ids?.content ?? `datepicker:${ctx.id}:content`;
var getCellTriggerId = (ctx, id) => ctx.ids?.cellTrigger?.(id) ?? `datepicker:${ctx.id}:cell-trigger:${id}`;
var getPrevTriggerId = (ctx, view) => ctx.ids?.prevTrigger?.(view) ?? `datepicker:${ctx.id}:prev:${view}`;
var getNextTriggerId = (ctx, view) => ctx.ids?.nextTrigger?.(view) ?? `datepicker:${ctx.id}:next:${view}`;
var getViewTriggerId = (ctx, view) => ctx.ids?.viewTrigger?.(view) ?? `datepicker:${ctx.id}:view:${view}`;
var getClearTriggerId3 = (ctx) => ctx.ids?.clearTrigger ?? `datepicker:${ctx.id}:clear`;
var getControlId5 = (ctx) => ctx.ids?.control ?? `datepicker:${ctx.id}:control`;
var getInputId3 = (ctx, index) => ctx.ids?.input?.(index) ?? `datepicker:${ctx.id}:input:${index}`;
var getTriggerId6 = (ctx) => ctx.ids?.trigger ?? `datepicker:${ctx.id}:trigger`;
var getPositionerId4 = (ctx) => ctx.ids?.positioner ?? `datepicker:${ctx.id}:positioner`;
var getMonthSelectId = (ctx) => ctx.ids?.monthSelect ?? `datepicker:${ctx.id}:month-select`;
var getYearSelectId = (ctx) => ctx.ids?.yearSelect ?? `datepicker:${ctx.id}:year-select`;
var getFocusedCell = (ctx, view) => query(getContentEl6(ctx), `[data-part=table-cell-trigger][data-view=${view}][data-focus]:not([data-outside-range])`);
var getTriggerEl5 = (ctx) => ctx.getById(getTriggerId6(ctx));
var getContentEl6 = (ctx) => ctx.getById(getContentId6(ctx));
var getInputEls = (ctx) => queryAll(getControlEl2(ctx), `[data-part=input]`);
var getYearSelectEl = (ctx) => ctx.getById(getYearSelectId(ctx));
var getMonthSelectEl = (ctx) => ctx.getById(getMonthSelectId(ctx));
var getClearTriggerEl3 = (ctx) => ctx.getById(getClearTriggerId3(ctx));
var getPositionerEl4 = (ctx) => ctx.getById(getPositionerId4(ctx));
var getControlEl2 = (ctx) => ctx.getById(getControlId5(ctx));
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
var PLACEHOLDERS = {
  day: "dd",
  month: "mm",
  year: "yyyy"
};
function getInputPlaceholder(locale) {
  return new $fb18d541ea1ad717$export$ad991b66133851cf(locale).formatToParts(/* @__PURE__ */ new Date()).map((item) => PLACEHOLDERS[item.type] ?? item.value).join("");
}
var isValidCharacter = (char, separator) => {
  if (!char) return true;
  return /\d/.test(char) || char === separator || char.length !== 1;
};
var isValidDate = (value) => {
  return !Number.isNaN(value.day) && !Number.isNaN(value.month) && !Number.isNaN(value.year);
};
var ensureValidCharacters = (value, separator) => {
  return value.split("").filter((char) => isValidCharacter(char, separator)).join("");
};
function getLocaleSeparator(locale) {
  const dateFormatter = new Intl.DateTimeFormat(locale);
  const parts22 = dateFormatter.formatToParts(/* @__PURE__ */ new Date());
  const literalPart = parts22.find((part) => part.type === "literal");
  return literalPart ? literalPart.value : "/";
}
var defaultTranslations = {
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
var views = ["day", "month", "year"];
function eachView(cb) {
  views.forEach((view) => cb(view));
}
var getVisibleRangeText = memo(
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
function connect12(service, normalize) {
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
  const min3 = prop("min");
  const max3 = prop("max");
  const locale = prop("locale");
  const timeZone = prop("timeZone");
  const startOfWeek = prop("startOfWeek");
  const focused = state2.matches("focused");
  const open = state2.matches("open");
  const isRangePicker = prop("selectionMode") === "range";
  const isDateUnavailableFn = prop("isDateUnavailable");
  const currentPlacement = context.get("currentPlacement");
  const popperStyles = getPlacementStyles({
    ...prop("positioning"),
    placement: currentPlacement
  });
  const separator = getLocaleSeparator(locale);
  const translations = { ...defaultTranslations, ...prop("translations") };
  function getMonthWeeks(from = startValue) {
    const numOfWeeks = prop("fixedWeeks") ? 6 : void 0;
    return getMonthDays(from, locale, numOfWeeks, startOfWeek);
  }
  function getMonths(props22 = {}) {
    const { format } = props22;
    return getMonthNames(locale, format).map((label, index) => {
      const value = index + 1;
      const dateValue = focusedValue.set({ month: value });
      const disabled2 = isDateOutsideRange(dateValue, min3, max3);
      return { label, value, disabled: disabled2 };
    });
  }
  function getYears() {
    const range = getYearsRange({ from: min3?.year ?? 1900, to: max3?.year ?? 2100 });
    return range.map((year) => ({
      label: year.toString(),
      value: year,
      disabled: !isValueWithinRange(year, min3?.year, max3?.year)
    }));
  }
  function isUnavailable(date) {
    return isDateUnavailable(date, isDateUnavailableFn, locale, min3, max3);
  }
  function focusMonth(month) {
    const date = startValue ?? getTodayDate(timeZone);
    send({ type: "FOCUS.SET", value: date.set({ month }) });
  }
  function focusYear(year) {
    const date = startValue ?? getTodayDate(timeZone);
    send({ type: "FOCUS.SET", value: date.set({ year }) });
  }
  function getYearTableCellState(props22) {
    const { value, disabled: disabled2 } = props22;
    const dateValue = focusedValue.set({ year: value });
    const decadeYears = getDecadeRange(startValue.year, { strict: true });
    const isOutsideVisibleRange = !decadeYears.includes(value);
    const isOutsideRange = isValueWithinRange(value, min3?.year, max3?.year);
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
      selectable: !isDateOutsideRange(dateValue, min3, max3),
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
      invalid: isDateOutsideRange(value, min3, max3),
      disabled: disabled2 || !outsideDaySelectable && isOutsideRange || isDateOutsideRange(value, min3, max3),
      selected: selectedValue.some((date) => isDateEqual(value, date)),
      unavailable: isDateUnavailable(value, isDateUnavailableFn, locale, min3, max3) && !disabled2,
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
    focusedValueAsDate: focusedValue?.toDate(timeZone),
    focusedValueAsString: prop("format")(focusedValue, { locale, timeZone }),
    visibleRange: computed("visibleRange"),
    selectToday() {
      const value = constrainValue(getTodayDate(timeZone), min3, max3);
      send({ type: "VALUE.SET", value });
    },
    setValue(values) {
      const computedValue = values.map((date) => constrainValue(date, min3, max3));
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
        disabled: !isValueWithinRange(year, min3?.year, max3?.year)
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
      return normalize.element({
        ...parts12.root.attrs,
        dir: prop("dir"),
        id: getRootId11(scope),
        "data-state": open ? "open" : "closed",
        "data-disabled": dataAttr(disabled),
        "data-readonly": dataAttr(readOnly),
        "data-empty": dataAttr(empty)
      });
    },
    getLabelProps(props22 = {}) {
      const { index = 0 } = props22;
      return normalize.label({
        ...parts12.label.attrs,
        id: getLabelId6(scope, index),
        dir: prop("dir"),
        htmlFor: getInputId3(scope, index),
        "data-state": open ? "open" : "closed",
        "data-index": index,
        "data-disabled": dataAttr(disabled),
        "data-readonly": dataAttr(readOnly)
      });
    },
    getControlProps() {
      return normalize.element({
        ...parts12.control.attrs,
        dir: prop("dir"),
        id: getControlId5(scope),
        "data-disabled": dataAttr(disabled),
        "data-placeholder-shown": dataAttr(empty)
      });
    },
    getRangeTextProps() {
      return normalize.element({
        ...parts12.rangeText.attrs,
        dir: prop("dir")
      });
    },
    getContentProps() {
      return normalize.element({
        ...parts12.content.attrs,
        hidden: !open,
        dir: prop("dir"),
        "data-state": open ? "open" : "closed",
        "data-placement": currentPlacement,
        "data-inline": dataAttr(prop("inline")),
        id: getContentId6(scope),
        tabIndex: -1,
        role: "application",
        "aria-roledescription": "datepicker",
        "aria-label": translations.content
      });
    },
    getTableProps(props22 = {}) {
      const { view = "day", columns = view === "day" ? 7 : 4 } = props22;
      const uid = getTableId2(props22);
      return normalize.element({
        ...parts12.table.attrs,
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
      });
    },
    getTableHeadProps(props22 = {}) {
      const { view = "day" } = props22;
      return normalize.element({
        ...parts12.tableHead.attrs,
        "aria-hidden": true,
        dir: prop("dir"),
        "data-view": view,
        "data-disabled": dataAttr(disabled)
      });
    },
    getTableHeaderProps(props22 = {}) {
      const { view = "day" } = props22;
      return normalize.element({
        ...parts12.tableHeader.attrs,
        dir: prop("dir"),
        "data-view": view,
        "data-disabled": dataAttr(disabled)
      });
    },
    getTableBodyProps(props22 = {}) {
      const { view = "day" } = props22;
      return normalize.element({
        ...parts12.tableBody.attrs,
        "data-view": view,
        "data-disabled": dataAttr(disabled)
      });
    },
    getTableRowProps(props22 = {}) {
      const { view = "day" } = props22;
      return normalize.element({
        ...parts12.tableRow.attrs,
        "aria-disabled": ariaAttr(disabled),
        "data-disabled": dataAttr(disabled),
        "data-view": view
      });
    },
    getDayTableCellState,
    getDayTableCellProps(props22) {
      const { value } = props22;
      const cellState = getDayTableCellState(props22);
      return normalize.element({
        ...parts12.tableCell.attrs,
        role: "gridcell",
        "aria-disabled": ariaAttr(!cellState.selectable),
        "aria-selected": cellState.selected || cellState.inRange,
        "aria-invalid": ariaAttr(cellState.invalid),
        "aria-current": cellState.today ? "date" : void 0,
        "data-value": value.toString()
      });
    },
    getDayTableCellTriggerProps(props22) {
      const { value } = props22;
      const cellState = getDayTableCellState(props22);
      return normalize.element({
        ...parts12.tableCellTrigger.attrs,
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
      });
    },
    getMonthTableCellState,
    getMonthTableCellProps(props22) {
      const { value, columns } = props22;
      const cellState = getMonthTableCellState(props22);
      return normalize.element({
        ...parts12.tableCell.attrs,
        dir: prop("dir"),
        colSpan: columns,
        role: "gridcell",
        "aria-selected": ariaAttr(cellState.selected || cellState.inRange),
        "data-selected": dataAttr(cellState.selected),
        "aria-disabled": ariaAttr(!cellState.selectable),
        "data-value": value
      });
    },
    getMonthTableCellTriggerProps(props22) {
      const { value } = props22;
      const cellState = getMonthTableCellState(props22);
      return normalize.element({
        ...parts12.tableCellTrigger.attrs,
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
      });
    },
    getYearTableCellState,
    getYearTableCellProps(props22) {
      const { value, columns } = props22;
      const cellState = getYearTableCellState(props22);
      return normalize.element({
        ...parts12.tableCell.attrs,
        dir: prop("dir"),
        colSpan: columns,
        role: "gridcell",
        "aria-selected": ariaAttr(cellState.selected),
        "data-selected": dataAttr(cellState.selected),
        "aria-disabled": ariaAttr(!cellState.selectable),
        "data-value": value
      });
    },
    getYearTableCellTriggerProps(props22) {
      const { value } = props22;
      const cellState = getYearTableCellState(props22);
      return normalize.element({
        ...parts12.tableCellTrigger.attrs,
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
      });
    },
    getNextTriggerProps(props22 = {}) {
      const { view = "day" } = props22;
      const isDisabled = disabled || !computed("isNextVisibleRangeValid");
      return normalize.button({
        ...parts12.nextTrigger.attrs,
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
      });
    },
    getPrevTriggerProps(props22 = {}) {
      const { view = "day" } = props22;
      const isDisabled = disabled || !computed("isPrevVisibleRangeValid");
      return normalize.button({
        ...parts12.prevTrigger.attrs,
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
      });
    },
    getClearTriggerProps() {
      return normalize.button({
        ...parts12.clearTrigger.attrs,
        id: getClearTriggerId3(scope),
        dir: prop("dir"),
        type: "button",
        "aria-label": translations.clearTrigger,
        hidden: !selectedValue.length,
        onClick(event) {
          if (event.defaultPrevented) return;
          send({ type: "VALUE.CLEAR" });
        }
      });
    },
    getTriggerProps() {
      return normalize.button({
        ...parts12.trigger.attrs,
        id: getTriggerId6(scope),
        dir: prop("dir"),
        type: "button",
        "data-placement": currentPlacement,
        "aria-label": translations.trigger(open),
        "aria-controls": getContentId6(scope),
        "data-state": open ? "open" : "closed",
        "data-placeholder-shown": dataAttr(empty),
        "aria-haspopup": "grid",
        disabled,
        onClick(event) {
          if (event.defaultPrevented) return;
          if (!interactive) return;
          send({ type: "TRIGGER.CLICK" });
        }
      });
    },
    getViewProps(props22 = {}) {
      const { view = "day" } = props22;
      return normalize.element({
        ...parts12.view.attrs,
        "data-view": view,
        hidden: context.get("view") !== view
      });
    },
    getViewTriggerProps(props22 = {}) {
      const { view = "day" } = props22;
      return normalize.button({
        ...parts12.viewTrigger.attrs,
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
      });
    },
    getViewControlProps(props22 = {}) {
      const { view = "day" } = props22;
      return normalize.element({
        ...parts12.viewControl.attrs,
        "data-view": view,
        dir: prop("dir")
      });
    },
    getInputProps(props22 = {}) {
      const { index = 0, fixOnBlur = true } = props22;
      return normalize.input({
        ...parts12.input.attrs,
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
      });
    },
    getMonthSelectProps() {
      return normalize.select({
        ...parts12.monthSelect.attrs,
        id: getMonthSelectId(scope),
        "aria-label": translations.monthSelect,
        disabled,
        dir: prop("dir"),
        defaultValue: startValue.month,
        onChange(event) {
          focusMonth(Number(event.currentTarget.value));
        }
      });
    },
    getYearSelectProps() {
      return normalize.select({
        ...parts12.yearSelect.attrs,
        id: getYearSelectId(scope),
        disabled,
        "aria-label": translations.yearSelect,
        dir: prop("dir"),
        defaultValue: startValue.year,
        onChange(event) {
          focusYear(Number(event.currentTarget.value));
        }
      });
    },
    getPositionerProps() {
      return normalize.element({
        id: getPositionerId4(scope),
        ...parts12.positioner.attrs,
        dir: prop("dir"),
        style: popperStyles.floating
      });
    },
    getPresetTriggerProps(props22) {
      const value = Array.isArray(props22.value) ? props22.value : getDateRangePreset(props22.value, locale, timeZone);
      const valueAsString = value.filter((item) => item != null).map((item) => item.toDate(timeZone).toDateString());
      return normalize.button({
        ...parts12.presetTrigger.attrs,
        "aria-label": translations.presetTrigger(valueAsString),
        type: "button",
        onClick(event) {
          if (event.defaultPrevented) return;
          send({ type: "PRESET.CLICK", value });
        }
      });
    }
  };
}
var { and: and6 } = createGuards();
function isDateArrayEqual(a2, b2) {
  if (a2?.length !== b2?.length) return false;
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
var machine12 = createMachine({
  props({ props: props22 }) {
    const locale = props22.locale || "en-US";
    const timeZone = props22.timeZone || "UTC";
    const selectionMode = props22.selectionMode || "single";
    const numOfMonths = props22.numOfMonths || 1;
    const defaultValue = props22.defaultValue ? sortDates(props22.defaultValue).map((date) => constrainValue(date, props22.min, props22.max)) : void 0;
    const value = props22.value ? sortDates(props22.value).map((date) => constrainValue(date, props22.min, props22.max)) : void 0;
    let focusedValue = props22.focusedValue || props22.defaultFocusedValue || value?.[0] || defaultValue?.[0] || getTodayDate(timeZone);
    focusedValue = constrainValue(focusedValue, props22.min, props22.max);
    const minView = "day";
    const maxView = "year";
    const defaultView = clampView(props22.view || minView, minView, maxView);
    return {
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
      },
      ...props22,
      focusedValue: typeof props22.focusedValue === "undefined" ? void 0 : focusedValue,
      defaultFocusedValue: focusedValue,
      value,
      defaultValue: defaultValue ?? [],
      positioning: {
        placement: "bottom",
        ...props22.positioning
      }
    };
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
          const context = getContext();
          const view = context.get("view");
          const value = context.get("value");
          const valueAsString = getValueAsString(value, prop);
          prop("onFocusChange")?.({ value, valueAsString, view, focusedValue });
        }
      })),
      value: bindable2(() => ({
        defaultValue: prop("defaultValue"),
        value: prop("value"),
        isEqual: isDateArrayEqual,
        hash: (v2) => v2.map((date) => date?.toString() ?? "").join(","),
        onChange(value) {
          const context = getContext();
          const valueAsString = getValueAsString(value, prop);
          prop("onValueChange")?.({ value, valueAsString, view: context.get("view") });
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
          prop("onViewChange")?.({ view: value });
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
            guard: and6("shouldRestoreFocus", "isInteractOutsideEvent"),
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
            guard: and6("isRangePicker", "hasSelectedRange"),
            actions: ["setActiveIndexToStart", "resetSelection", "setActiveIndexToEnd"]
          },
          // === Grouped transitions (based on `closeOnSelect` and `isOpenControlled`) ===
          {
            guard: and6("isRangePicker", "isSelectingEndDate", "closeOnSelect", "isOpenControlled"),
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
            guard: and6("isRangePicker", "isSelectingEndDate", "closeOnSelect"),
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
            guard: and6("isRangePicker", "isSelectingEndDate"),
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
            guard: and6("closeOnSelect", "isOpenControlled"),
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
          guard: and6("isRangePicker", "isSelectingEndDate"),
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
            guard: and6("isRangePicker", "hasSelectedRange"),
            actions: ["setActiveIndexToStart", "clearDateValue", "setSelectedDate", "setActiveIndexToEnd"]
          },
          // === Grouped transitions (based on `closeOnSelect` and `isOpenControlled`) ===
          {
            guard: and6("isRangePicker", "isSelectingEndDate", "closeOnSelect", "isOpenControlled"),
            actions: ["setSelectedDate", "setActiveIndexToStart", "clearHoveredDate", "invokeOnClose"]
          },
          {
            guard: and6("isRangePicker", "isSelectingEndDate", "closeOnSelect"),
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
            guard: and6("isRangePicker", "isSelectingEndDate"),
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
            guard: and6("closeOnSelect", "isOpenControlled"),
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
      isInteractOutsideEvent: ({ event }) => event.previousEvent?.type === "INTERACT_OUTSIDE",
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
        const getPositionerEl22 = () => getPositionerEl4(scope);
        return getPlacement(anchorEl, getPositionerEl22, {
          ...prop("positioning"),
          defer: true,
          onComplete(data) {
            context.set("currentPlacement", data.placement);
          }
        });
      },
      setupLiveRegion({ scope, refs }) {
        const doc = scope.getDoc();
        refs.set("announcer", createLiveRegion({ level: "assertive", document: doc }));
        return () => refs.get("announcer")?.destroy?.();
      },
      trackDismissableElement({ scope, send, context, prop }) {
        if (prop("inline")) return;
        const getContentEl22 = () => getContentEl6(scope);
        return trackDismissableElement(getContentEl22, {
          type: "popover",
          defer: true,
          exclude: [...getInputEls(scope), getTriggerEl5(scope), getClearTriggerEl3(scope)],
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
        refs.get("announcer")?.announce(announceText, 3e3);
      },
      announceVisibleRange({ computed, refs }) {
        const { formatted } = computed("visibleRangeText");
        refs.get("announcer")?.announce(formatted);
      },
      disableTextSelection({ scope }) {
        disableTextSelection({ target: getContentEl6(scope), doc: scope.getDoc() });
      },
      enableTextSelection({ scope }) {
        restoreTextSelection({ doc: scope.getDoc(), target: getContentEl6(scope) });
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
        const { context, event } = params;
        const values = Array.from(context.get("value"));
        values[context.get("activeIndex")] = normalizeValue(params, event.value ?? context.get("focusedValue"));
        context.set("value", adjustStartAndEndDate(values));
      },
      resetSelection(params) {
        const { context, event } = params;
        const value = normalizeValue(params, event.value ?? context.get("focusedValue"));
        context.set("value", [value]);
      },
      toggleSelectedDate(params) {
        const { context, event } = params;
        const currentValue = normalizeValue(params, event.value ?? context.get("focusedValue"));
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
          const view = context.get("view");
          getFocusedCell(scope, view)?.focus({ preventScroll: true });
        });
      },
      focusActiveCellIfNeeded({ scope, context, event }) {
        if (!event.focus) return;
        raf(() => {
          const view = context.get("view");
          getFocusedCell(scope, view)?.focus({ preventScroll: true });
        });
      },
      setHoveredValueIfKeyboard({ context, event, prop }) {
        if (!event.type.startsWith("TABLE.ARROW") || prop("selectionMode") !== "range" || context.get("activeIndex") === 0)
          return;
        context.set("hoveredValue", context.get("focusedValue").copy());
      },
      focusTriggerElement({ scope }) {
        raf(() => {
          getTriggerEl5(scope)?.focus({ preventScroll: true });
        });
      },
      focusFirstInputElement({ scope }) {
        raf(() => {
          const [inputEl] = getInputEls(scope);
          inputEl?.focus({ preventScroll: true });
        });
      },
      focusInputElement({ scope }) {
        raf(() => {
          const inputEls = getInputEls(scope);
          const lastIndexWithValue = inputEls.findLastIndex((inputEl2) => inputEl2.value !== "");
          const indexToFocus = Math.max(lastIndexWithValue, 0);
          const inputEl = inputEls[indexToFocus];
          inputEl?.focus({ preventScroll: true });
          inputEl?.setSelectionRange(inputEl.value.length, inputEl.value.length);
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
          const inputEls = getInputEls(scope);
          const idx = event.index ?? context.get("activeIndex");
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
        if (prop("inline")) return;
        prop("onOpenChange")?.({ open: true, value: context.get("value") });
      },
      invokeOnClose({ prop, context }) {
        if (prop("inline")) return;
        prop("onOpenChange")?.({ open: false, value: context.get("value") });
      },
      invokeOnVisibleRangeChange({ prop, context, computed }) {
        prop("onVisibleRangeChange")?.({
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
var normalizeValue = (ctx, value) => {
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
var props11 = createProps()([
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
var splitProps11 = createSplitProps(props11);
var inputProps = createProps()(["index", "fixOnBlur"]);
var splitInputProps = createSplitProps(inputProps);
var presetTriggerProps = createProps()(["value"]);
var splitPresetTriggerProps = createSplitProps(presetTriggerProps);
var tableProps = createProps()(["columns", "id", "view"]);
var splitTableProps = createSplitProps(tableProps);
var tableCellProps = createProps()(["disabled", "value", "columns"]);
var splitTableCellProps = createSplitProps(tableCellProps);
var viewProps = createProps()(["view"]);
var splitViewProps = createSplitProps(viewProps);

// components/date-picker.ts
var DatePicker = class extends Component {
  initMachine(props13) {
    return new VanillaMachine(machine12, {
      ...props13
    });
  }
  initApi() {
    return connect12(this.machine.service, normalizeProps);
  }
  // View container helpers - these elements never get spreadProps called on them,
  // so their data-part values remain stable across renders.
  getDayView = () => this.el.querySelector('[data-part="day-view"]');
  getMonthView = () => this.el.querySelector('[data-part="month-view"]');
  getYearView = () => this.el.querySelector('[data-part="year-view"]');
  syncWeekDays = () => {
    const dayView = this.getDayView();
    if (!dayView) return;
    const headerRow = dayView.querySelector("thead tr");
    if (!headerRow) return;
    this.spreadProps(headerRow, this.api.getTableRowProps({ view: "day" }));
    const existingCells = Array.from(headerRow.querySelectorAll("th"));
    while (existingCells.length > this.api.weekDays.length) {
      const cell = existingCells.pop();
      if (cell) headerRow.removeChild(cell);
    }
    this.api.weekDays.forEach((day, index) => {
      let cellEl = existingCells[index];
      if (!cellEl) {
        cellEl = this.doc.createElement("th");
        cellEl.scope = "col";
        headerRow.appendChild(cellEl);
      }
      cellEl.setAttribute("aria-label", day.long);
      cellEl.textContent = day.narrow;
    });
  };
  syncDayGrid = () => {
    const dayView = this.getDayView();
    if (!dayView) return;
    const tbody = dayView.querySelector("tbody");
    if (!tbody) return;
    this.spreadProps(tbody, this.api.getTableBodyProps({ view: "day" }));
    if (!this.api.weeks) return;
    const existingRows = Array.from(tbody.querySelectorAll("tr"));
    while (existingRows.length > this.api.weeks.length) {
      const row = existingRows.pop();
      if (row) tbody.removeChild(row);
    }
    this.api.weeks.forEach((week, rowIndex) => {
      let rowEl = existingRows[rowIndex];
      if (!rowEl) {
        rowEl = this.doc.createElement("tr");
        tbody.appendChild(rowEl);
      }
      this.spreadProps(rowEl, this.api.getTableRowProps({ view: "day" }));
      const existingCells = Array.from(rowEl.querySelectorAll("td"));
      while (existingCells.length > week.length) {
        const cell = existingCells.pop();
        if (cell) rowEl.removeChild(cell);
      }
      week.forEach((value, cellIndex) => {
        let cellEl = existingCells[cellIndex];
        if (!cellEl) {
          cellEl = this.doc.createElement("td");
          const triggerEl2 = this.doc.createElement("div");
          cellEl.appendChild(triggerEl2);
          rowEl.appendChild(cellEl);
        }
        this.spreadProps(cellEl, this.api.getDayTableCellProps({ value }));
        const triggerEl = cellEl.querySelector("div");
        if (triggerEl) {
          this.spreadProps(
            triggerEl,
            this.api.getDayTableCellTriggerProps({ value })
          );
          triggerEl.textContent = String(value.day);
        }
      });
    });
  };
  syncMonthGrid = () => {
    const monthView = this.getMonthView();
    if (!monthView) return;
    const tbody = monthView.querySelector("tbody");
    if (!tbody) return;
    this.spreadProps(tbody, this.api.getTableBodyProps({ view: "month" }));
    const monthsGrid = this.api.getMonthsGrid({ columns: 4, format: "short" });
    const existingRows = Array.from(tbody.querySelectorAll("tr"));
    while (existingRows.length > monthsGrid.length) {
      const row = existingRows.pop();
      if (row) tbody.removeChild(row);
    }
    monthsGrid.forEach((months, rowIndex) => {
      let rowEl = existingRows[rowIndex];
      if (!rowEl) {
        rowEl = this.doc.createElement("tr");
        tbody.appendChild(rowEl);
      }
      this.spreadProps(rowEl, this.api.getTableRowProps());
      const existingCells = Array.from(rowEl.querySelectorAll("td"));
      while (existingCells.length > months.length) {
        const cell = existingCells.pop();
        if (cell) rowEl.removeChild(cell);
      }
      months.forEach((month, cellIndex) => {
        let cellEl = existingCells[cellIndex];
        if (!cellEl) {
          cellEl = this.doc.createElement("td");
          const triggerEl2 = this.doc.createElement("div");
          cellEl.appendChild(triggerEl2);
          rowEl.appendChild(cellEl);
        }
        this.spreadProps(
          cellEl,
          this.api.getMonthTableCellProps({ ...month, columns: 4 })
        );
        const triggerEl = cellEl.querySelector("div");
        if (triggerEl) {
          this.spreadProps(
            triggerEl,
            this.api.getMonthTableCellTriggerProps({ ...month, columns: 4 })
          );
          triggerEl.textContent = month.label;
        }
      });
    });
  };
  syncYearGrid = () => {
    const yearView = this.getYearView();
    if (!yearView) return;
    const tbody = yearView.querySelector("tbody");
    if (!tbody) return;
    this.spreadProps(tbody, this.api.getTableBodyProps());
    const yearsGrid = this.api.getYearsGrid({ columns: 4 });
    const existingRows = Array.from(tbody.querySelectorAll("tr"));
    while (existingRows.length > yearsGrid.length) {
      const row = existingRows.pop();
      if (row) tbody.removeChild(row);
    }
    yearsGrid.forEach((years, rowIndex) => {
      let rowEl = existingRows[rowIndex];
      if (!rowEl) {
        rowEl = this.doc.createElement("tr");
        tbody.appendChild(rowEl);
      }
      this.spreadProps(rowEl, this.api.getTableRowProps({ view: "year" }));
      const existingCells = Array.from(rowEl.querySelectorAll("td"));
      while (existingCells.length > years.length) {
        const cell = existingCells.pop();
        if (cell) rowEl.removeChild(cell);
      }
      years.forEach((year, cellIndex) => {
        let cellEl = existingCells[cellIndex];
        if (!cellEl) {
          cellEl = this.doc.createElement("td");
          const triggerEl2 = this.doc.createElement("div");
          cellEl.appendChild(triggerEl2);
          rowEl.appendChild(cellEl);
        }
        this.spreadProps(
          cellEl,
          this.api.getYearTableCellProps({ ...year, columns: 4 })
        );
        const triggerEl = cellEl.querySelector("div");
        if (triggerEl) {
          this.spreadProps(
            triggerEl,
            this.api.getYearTableCellTriggerProps({ ...year, columns: 4 })
          );
          triggerEl.textContent = year.label;
        }
      });
    });
  };
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
      const inputProps2 = { ...this.api.getInputProps() };
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
      const triggerProps2 = { ...this.api.getTriggerProps() };
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
    const dayView = this.getDayView();
    if (dayView) {
      dayView.hidden = this.api.view !== "day";
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
        this.spreadProps(thead, this.api.getTableHeaderProps({ view: "day" }));
    }
    this.syncWeekDays();
    this.syncDayGrid();
    const monthView = this.getMonthView();
    if (monthView) {
      monthView.hidden = this.api.view !== "month";
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
    }
    this.syncMonthGrid();
    const yearView = this.getYearView();
    if (yearView) {
      yearView.hidden = this.api.view !== "year";
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
    }
    this.syncYearGrid();
  }
};

// hooks/date-picker.ts
function toISOString(d2) {
  const pad = (n2) => String(n2).padStart(2, "0");
  return `${d2.year}-${pad(d2.month)}-${pad(d2.day)}`;
}
var DatePickerHook = {
  mounted() {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const liveSocket = this.liveSocket;
    const min3 = getString(el, "min");
    const max3 = getString(el, "max");
    const positioningJson = getString(el, "positioning");
    const isControlled = getBoolean(el, "controlled");
    const parseList = (v2) => v2 ? v2.map((x2) => parse(x2)) : void 0;
    const parseOne = (v2) => v2 ? parse(v2) : void 0;
    const initialValue = parseList(getStringList(el, isControlled ? "value" : "defaultValue"));
    const datePickerInstance = new DatePicker(el, {
      id: el.id,
      defaultValue: initialValue,
      defaultFocusedValue: parseOne(getString(el, "focusedValue")),
      defaultView: getString(el, "defaultView", ["day", "month", "year"]),
      defaultOpen: el.hasAttribute("data-default-open") ? getBoolean(el, "defaultOpen") : void 0,
      dir: getString(el, "dir", ["ltr", "rtl"]),
      locale: getString(el, "locale"),
      timeZone: getString(el, "timeZone"),
      disabled: getBoolean(el, "disabled"),
      readOnly: getBoolean(el, "readOnly"),
      required: getBoolean(el, "required"),
      invalid: getBoolean(el, "invalid"),
      outsideDaySelectable: getBoolean(el, "outsideDaySelectable"),
      closeOnSelect: getBoolean(el, "closeOnSelect"),
      min: min3 ? parse(min3) : void 0,
      max: max3 ? parse(max3) : void 0,
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
        const isoStr = details.value?.length ? details.value.map((d2) => toISOString(d2)).join(",") : "";
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
        const eventName = getString(el, "onFocusChange");
        if (eventName && liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            id: el.id,
            focused: details.focused ?? false
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
    });
    datePickerInstance.init();
    this.datePicker = datePickerInstance;
    this.handlers = [];
    this.handlers.push(
      this.handleEvent("date_picker_set_value", (payload) => {
        const targetId = payload.date_picker_id;
        if (targetId && targetId !== el.id) return;
        datePickerInstance.api.setValue([parse(payload.value)]);
      })
    );
    this.onSetValue = (event) => {
      const value = event.detail?.value;
      if (typeof value === "string") {
        datePickerInstance.api.setValue([parse(value)]);
      }
    };
    el.addEventListener("phx:date-picker:set-value", this.onSetValue);
  },
  updated() {
    const el = this.el;
    const min3 = getString(el, "min");
    const max3 = getString(el, "max");
    const positioningJson = getString(el, "positioning");
    const isControlled = getBoolean(el, "controlled");
    const focusedStr = getString(el, "focusedValue");
    this.datePicker?.updateProps({
      id: el.id,
      defaultFocusedValue: focusedStr ? parse(focusedStr) : void 0,
      defaultView: getString(el, "defaultView", ["day", "month", "year"]),
      defaultOpen: el.hasAttribute("data-default-open") ? getBoolean(el, "defaultOpen") : void 0,
      dir: getString(this.el, "dir", ["ltr", "rtl"]),
      locale: getString(this.el, "locale"),
      timeZone: getString(this.el, "timeZone"),
      disabled: getBoolean(this.el, "disabled"),
      readOnly: getBoolean(this.el, "readOnly"),
      required: getBoolean(this.el, "required"),
      invalid: getBoolean(this.el, "invalid"),
      outsideDaySelectable: getBoolean(this.el, "outsideDaySelectable"),
      closeOnSelect: getBoolean(this.el, "closeOnSelect"),
      min: min3 ? parse(min3) : void 0,
      max: max3 ? parse(max3) : void 0,
      numOfMonths: getNumber(this.el, "numOfMonths"),
      startOfWeek: getNumber(this.el, "startOfWeek"),
      fixedWeeks: getBoolean(this.el, "fixedWeeks"),
      selectionMode: getString(this.el, "selectionMode", ["single", "multiple", "range"]),
      placeholder: getString(this.el, "placeholder"),
      minView: getString(this.el, "minView", ["day", "month", "year"]),
      maxView: getString(this.el, "maxView", ["day", "month", "year"]),
      inline: getBoolean(this.el, "inline"),
      positioning: positioningJson ? JSON.parse(positioningJson) : void 0
    });
    if (isControlled && this.datePicker) {
      const serverValues = getStringList(el, "value");
      const zagValue = this.datePicker.api.value;
      const zagIso = zagValue?.length ? zagValue.map((d2) => toISOString(d2)).join(",") : "";
      const serverIso = serverValues?.join(",") ?? "";
      if (serverIso && serverIso !== zagIso) {
        this.datePicker.api.setValue(serverValues.map((x2) => parse(x2)));
      }
    }
  },
  destroyed() {
    if (this.onSetValue) {
      this.el.removeEventListener("phx:date-picker:set-value", this.onSetValue);
    }
    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }
    this.datePicker?.destroy();
  }
};

// ../node_modules/.pnpm/perfect-freehand@1.2.3/node_modules/perfect-freehand/dist/esm/index.mjs
var { PI: e } = Math;
var t = e + 1e-4;
var n = 0.5;
var r = [1, 1];
function i(e2, t2, n2, r2 = (e3) => e3) {
  return e2 * r2(0.5 - t2 * (0.5 - n2));
}
var { min: a } = Math;
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
var E = [0, 0];
var D = [0, 0];
var O = [0, 0];
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
var F = [0, 0];
function I(e2) {
  return e2 != null && e2 >= 0;
}
function L(e2, t2 = {}) {
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
  return u2[0].vector = u2[1]?.vector || [0, 0], u2;
}
function R(e2, t2 = {}) {
  return P(L(e2, t2), t2);
}
var z = R;

// ../node_modules/.pnpm/@zag-js+signature-pad@1.33.1/node_modules/@zag-js/signature-pad/dist/index.mjs
var anatomy13 = createAnatomy("signature-pad").parts(
  "root",
  "control",
  "segment",
  "segmentPath",
  "guide",
  "clearTrigger",
  "label"
);
var parts13 = anatomy13.build();
var getRootId12 = (ctx) => ctx.ids?.root ?? `signature-${ctx.id}`;
var getControlId6 = (ctx) => ctx.ids?.control ?? `signature-control-${ctx.id}`;
var getLabelId7 = (ctx) => ctx.ids?.label ?? `signature-label-${ctx.id}`;
var getHiddenInputId3 = (ctx) => ctx.ids?.hiddenInput ?? `signature-input-${ctx.id}`;
var getControlEl3 = (ctx) => ctx.getById(getControlId6(ctx));
var getSegmentEl = (ctx) => query(getControlEl3(ctx), "[data-part=segment]");
var getDataUrl2 = (ctx, options) => {
  return getDataUrl(getSegmentEl(ctx), options);
};
function connect13(service, normalize) {
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
      return normalize.label({
        ...parts13.label.attrs,
        id: getLabelId7(scope),
        "data-disabled": dataAttr(disabled),
        "data-required": dataAttr(required),
        htmlFor: getHiddenInputId3(scope),
        onClick(event) {
          if (!interactive) return;
          if (event.defaultPrevented) return;
          const controlEl = getControlEl3(scope);
          controlEl?.focus({ preventScroll: true });
        }
      });
    },
    getRootProps() {
      return normalize.element({
        ...parts13.root.attrs,
        "data-disabled": dataAttr(disabled),
        id: getRootId12(scope)
      });
    },
    getControlProps() {
      return normalize.element({
        ...parts13.control.attrs,
        tabIndex: disabled ? void 0 : 0,
        id: getControlId6(scope),
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
          if (target?.closest("[data-part=clear-trigger]")) return;
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
      });
    },
    getSegmentProps() {
      return normalize.svg({
        ...parts13.segment.attrs,
        style: {
          position: "absolute",
          top: 0,
          left: 0,
          width: "100%",
          height: "100%",
          pointerEvents: "none",
          fill: prop("drawing").fill
        }
      });
    },
    getSegmentPathProps(props22) {
      return normalize.path({
        ...parts13.segmentPath.attrs,
        d: props22.path
      });
    },
    getGuideProps() {
      return normalize.element({
        ...parts13.guide.attrs,
        "data-disabled": dataAttr(disabled)
      });
    },
    getClearTriggerProps() {
      return normalize.button({
        ...parts13.clearTrigger.attrs,
        type: "button",
        "aria-label": translations.clearTrigger,
        hidden: !context.get("paths").length || drawing,
        disabled,
        onClick() {
          send({ type: "CLEAR" });
        }
      });
    },
    getHiddenInputProps(props22) {
      return normalize.input({
        id: getHiddenInputId3(scope),
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
var average = (a2, b2) => (a2 + b2) / 2;
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
  for (let i2 = 2, max3 = len - 1; i2 < max3; i2++) {
    a2 = points[i2];
    b2 = points[i2 + 1];
    result += `${average(a2[0], b2[0]).toFixed(2)},${average(a2[1], b2[1]).toFixed(2)} `;
  }
  if (closed) {
    result += "Z";
  }
  return result;
}
var machine13 = createMachine({
  props({ props: props22 }) {
    return {
      defaultPaths: [],
      ...props22,
      drawing: {
        size: 2,
        simulatePressure: false,
        thinning: 0.7,
        smoothing: 0.4,
        streamline: 0.6,
        ...props22.drawing
      },
      translations: {
        control: "signature pad",
        clearTrigger: "clear signature",
        ...props22.translations
      }
    };
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
          prop("onDraw")?.({ paths: value });
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
          scope.getActiveElement()?.focus({ preventScroll: true });
        });
      },
      invokeOnDraw({ context, prop }) {
        prop("onDraw")?.({
          paths: [...context.get("paths"), context.get("currentPath")]
        });
      },
      invokeOnDrawEnd({ context, prop, scope, computed }) {
        prop("onDrawEnd")?.({
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
var props12 = createProps()([
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
var splitProps12 = createSplitProps(props12);

// components/signature-pad.ts
var SignaturePad = class extends Component {
  imageURL = "";
  initMachine(props13) {
    return new VanillaMachine(machine13, props13);
  }
  initApi() {
    return connect13(this.machine.service, normalizeProps);
  }
  syncPaths = () => {
    const segment = this.el.querySelector('[data-scope="signature-pad"][data-part="segment"]');
    if (!segment) return;
    const totalPaths = this.api.paths.length + (this.api.currentPath ? 1 : 0);
    if (totalPaths === 0) {
      Array.from(segment.querySelectorAll("path")).forEach((path) => segment.removeChild(path));
      this.imageURL = "";
      return;
    }
    const allPathElements = Array.from(
      segment.querySelectorAll('[data-scope="signature-pad"][data-part="path"], [data-scope="signature-pad"][data-part="current-path"]')
    );
    const existingPaths = [];
    const existingCurrentPath = [];
    allPathElements.forEach((path) => {
      (path.getAttribute("data-part") === "current-path" ? existingCurrentPath : existingPaths).push(path);
    });
    while (existingPaths.length > this.api.paths.length) {
      const path = existingPaths.pop();
      if (path) segment.removeChild(path);
    }
    this.api.paths.forEach((pathData, index) => {
      let pathEl = existingPaths[index];
      if (!pathEl) {
        pathEl = document.createElementNS("http://www.w3.org/2000/svg", "path");
        pathEl.setAttribute("data-scope", "signature-pad");
        pathEl.setAttribute("data-part", "path");
        segment.appendChild(pathEl);
      }
      this.spreadProps(pathEl, this.api.getSegmentPathProps({ path: pathData }));
    });
    if (this.api.currentPath) {
      let currentPathEl = existingCurrentPath[0];
      if (!currentPathEl) {
        currentPathEl = document.createElementNS("http://www.w3.org/2000/svg", "path");
        currentPathEl.setAttribute("data-scope", "signature-pad");
        currentPathEl.setAttribute("data-part", "current-path");
        segment.appendChild(currentPathEl);
      }
      this.spreadProps(currentPathEl, this.api.getSegmentPathProps({ path: this.api.currentPath }));
    } else {
      existingCurrentPath.forEach((path) => segment.removeChild(path));
    }
  };
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
    }
    const hiddenInput = rootEl.querySelector('[data-scope="signature-pad"][data-part="hidden-input"]');
    if (hiddenInput) {
      this.spreadProps(hiddenInput, this.api.getHiddenInputProps({ value: this.imageURL }));
    }
    this.syncPaths();
  }
};

// hooks/signature-pad.ts
var SignaturePadHook = {
  mounted() {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const signaturePad = new SignaturePad(el, {
      id: el.id,
      drawing: {
        fill: getString(el, "drawingFill"),
        size: getNumber(el, "drawingSize"),
        simulatePressure: getBoolean(el, "drawingSimulatePressure")
      },
      onDrawEnd: (details) => {
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
    });
    signaturePad.init();
    this.signaturePad = signaturePad;
    this.onClear = (event) => {
      const { id: targetId } = event.detail;
      if (targetId && targetId !== el.id) return;
      signaturePad.api.clear();
    };
    el.addEventListener("phx:signature-pad:clear", this.onClear);
    this.handlers = [];
    this.handlers.push(
      this.handleEvent("signature_pad_clear", (payload) => {
        const targetId = payload.signature_pad_id;
        if (targetId && targetId !== el.id) return;
        signaturePad.api.clear();
      })
    );
  },
  updated() {
    this.signaturePad?.updateProps({
      id: this.el.id,
      drawing: {
        fill: getString(this.el, "drawingFill") || "black",
        size: getNumber(this.el, "drawingSize") || 2,
        simulatePressure: getBoolean(this.el, "drawingSimulatePressure")
      }
    });
  },
  destroyed() {
    if (this.onClear) {
      this.el.removeEventListener("phx:signature-pad:clear", this.onClear);
    }
    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }
    this.signaturePad?.destroy();
  }
};

// hooks/corex.ts
var Hooks = { Accordion: AccordionHook, ToggleGroup: ToggleGroupHook, Toast: ToastHook, Select: SelectHook, Switch: SwitchHook, Combobox: ComboboxHook, Checkbox: CheckboxHook, Tabs: TabsHook, Clipboard: ClipboardHook, Collapsible: CollapsibleHook, Dialog: DialogHook, DatePicker: DatePickerHook, SignaturePad: SignaturePadHook };
var corex_default = Hooks;
//# sourceMappingURL=corex.cjs.js.map
