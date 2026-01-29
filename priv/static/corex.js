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
  var __defNormalProp = (obj, key, value) => key in obj ? __defProp(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
  var __spreadValues = (a, b) => {
    for (var prop in b || (b = {}))
      if (__hasOwnProp.call(b, prop))
        __defNormalProp(a, prop, b[prop]);
    if (__getOwnPropSymbols)
      for (var prop of __getOwnPropSymbols(b)) {
        if (__propIsEnum.call(b, prop))
          __defNormalProp(a, prop, b[prop]);
      }
    return a;
  };
  var __spreadProps = (a, b) => __defProps(a, __getOwnPropDescs(b));
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
        } catch (e) {
          reject(e);
        }
      };
      var rejected = (value) => {
        try {
          step(generator.throw(value));
        } catch (e) {
          reject(e);
        }
      };
      var step = (x) => x.done ? resolve(x.value) : Promise.resolve(x.value).then(fulfilled, rejected);
      step((generator = generator.apply(__this, __arguments)).next());
    });
  };

  // hooks/corex.ts
  var corex_exports = {};
  __export(corex_exports, {
    default: () => corex_default
  });

  // ../node_modules/.pnpm/@zag-js+anatomy@1.33.0/node_modules/@zag-js/anatomy/dist/index.mjs
  var createAnatomy = (name, parts4 = []) => ({
    parts: (...values) => {
      if (isEmpty(parts4)) {
        return createAnatomy(name, values);
      }
      throw new Error("createAnatomy().parts(...) should only be called once. Did you mean to use .extendWith(...) ?");
    },
    extendWith: (...values) => createAnatomy(name, [...parts4, ...values]),
    omit: (...values) => createAnatomy(name, parts4.filter((part) => !values.includes(part))),
    rename: (newName) => createAnatomy(newName, parts4),
    keys: () => parts4,
    build: () => [...new Set(parts4)].reduce(
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
  var isEmpty = (v) => v.length === 0;

  // ../node_modules/.pnpm/@zag-js+dom-query@1.33.0/node_modules/@zag-js/dom-query/dist/index.mjs
  var __defProp2 = Object.defineProperty;
  var __defNormalProp2 = (obj, key, value) => key in obj ? __defProp2(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
  var __publicField2 = (obj, key, value) => __defNormalProp2(obj, typeof key !== "symbol" ? key + "" : key, value);
  var pipe = (...fns) => (arg) => fns.reduce((acc, fn) => fn(acc), arg);
  var noop = () => void 0;
  var isObject = (v) => typeof v === "object" && v !== null;
  var MAX_Z_INDEX = 2147483647;
  var dataAttr = (guard) => guard ? "" : void 0;
  var ELEMENT_NODE = 1;
  var DOCUMENT_NODE = 9;
  var DOCUMENT_FRAGMENT_NODE = 11;
  var isHTMLElement = (el) => isObject(el) && el.nodeType === ELEMENT_NODE && typeof el.nodeName === "string";
  var isDocument = (el) => isObject(el) && el.nodeType === DOCUMENT_NODE;
  var isWindow = (el) => isObject(el) && el === el.window;
  var isNode = (el) => isObject(el) && el.nodeType !== void 0;
  var isShadowRoot = (el) => isNode(el) && el.nodeType === DOCUMENT_FRAGMENT_NODE && "host" in el;
  function isActiveElement(element) {
    if (!element) return false;
    const rootNode = element.getRootNode();
    return getActiveElement(rootNode) === element;
  }
  function contains(parent, child) {
    var _a;
    if (!parent || !child) return false;
    if (!isHTMLElement(parent) || !isHTMLElement(child)) return false;
    const rootNode = (_a = child.getRootNode) == null ? void 0 : _a.call(child);
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
    var _a;
    if (isDocument(el)) return el;
    if (isWindow(el)) return el.document;
    return (_a = el == null ? void 0 : el.ownerDocument) != null ? _a : document;
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
  var isDom = () => typeof document !== "undefined";
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
  var pt = (v) => isDom() && v.test(getPlatform());
  var ua = (v) => isDom() && v.test(getUserAgent());
  var vn = (v) => isDom() && v.test(navigator.vendor);
  var isIPhone = () => pt(/^iPhone/i);
  var isIPad = () => pt(/^iPad/i) || isMac() && navigator.maxTouchPoints > 1;
  var isIos = () => isIPhone() || isIPad();
  var isApple = () => isMac() || isIos();
  var isMac = () => pt(/^Mac/i);
  var isSafari = () => isApple() && vn(/apple/i);
  var isAndroid = () => ua(/Android/i);
  function getComposedPath(event) {
    var _a, _b, _c, _d;
    return (_d = (_a = event.composedPath) == null ? void 0 : _a.call(event)) != null ? _d : (_c = (_b = event.nativeEvent) == null ? void 0 : _b.composedPath) == null ? void 0 : _c.call(_b);
  }
  function getEventTarget(event) {
    var _a;
    const composedPath = getComposedPath(event);
    return (_a = composedPath == null ? void 0 : composedPath[0]) != null ? _a : event.target;
  }
  function isVirtualClick(e) {
    if (e.pointerType === "" && e.isTrusted) return true;
    if (isAndroid() && e.pointerType) {
      return e.type === "click" && e.buttons === 1;
    }
    return e.detail === 0 && !e.pointerType;
  }
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
    var _a;
    const { dir = "ltr", orientation = "horizontal" } = options;
    let key = event.key;
    key = (_a = keyMap[key]) != null ? _a : key;
    const isRtl = dir === "rtl" && orientation === "horizontal";
    if (isRtl && key in rtlKeyMap) key = rtlKeyMap[key];
    return key;
  }
  function getEventPoint(event, type = "client") {
    const point = isTouchEvent(event) ? event.touches[0] || event.changedTouches[0] : event;
    return { x: point[`${type}X`], y: point[`${type}Y`] };
  }
  var addDomEvent = (target, eventName, handler, options) => {
    const node = typeof target === "function" ? target() : target;
    node == null ? void 0 : node.addEventListener(eventName, handler, options);
    return () => {
      node == null ? void 0 : node.removeEventListener(eventName, handler, options);
    };
  };
  function getDescriptor(el, options) {
    var _a;
    const { type = "HTMLInputElement", property = "value" } = options;
    const proto = getWindow(el)[type].prototype;
    return (_a = Object.getOwnPropertyDescriptor(proto, property)) != null ? _a : {};
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
    const onReset = (e) => {
      if (e.defaultPrevented) return;
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
  var AnimationFrame = class _AnimationFrame {
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
  function raf(fn) {
    const frame = AnimationFrame.create();
    frame.request(fn);
    return frame.cleanup;
  }
  function trackPress(options) {
    const {
      pointerNode,
      keyboardNode = pointerNode,
      onPress,
      onPressStart,
      onPressEnd,
      isValidKey: isValidKey2 = (e) => e.key === "Enter"
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
  var defaultItemToId = (v) => v.id;
  function itemById(v, id, itemToId = defaultItemToId) {
    return v.find((item) => itemToId(item) === id);
  }
  function indexOfId(v, id, itemToId = defaultItemToId) {
    const item = itemById(v, id, itemToId);
    return item ? v.indexOf(item) : -1;
  }
  function nextById(v, id, loop = true) {
    let idx = indexOfId(v, id);
    idx = loop ? (idx + 1) % v.length : Math.min(idx + 1, v.length - 1);
    return v[idx];
  }
  function prevById(v, id, loop = true) {
    let idx = indexOfId(v, id);
    if (idx === -1) return loop ? v[v.length - 1] : null;
    idx = loop ? (idx - 1 + v.length) % v.length : Math.max(0, idx - 1);
    return v[idx];
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

  // ../node_modules/.pnpm/@zag-js+utils@1.33.0/node_modules/@zag-js/utils/dist/index.mjs
  var __defProp3 = Object.defineProperty;
  var __typeError = (msg) => {
    throw TypeError(msg);
  };
  var __defNormalProp3 = (obj, key, value) => key in obj ? __defProp3(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
  var __publicField3 = (obj, key, value) => __defNormalProp3(obj, typeof key !== "symbol" ? key + "" : key, value);
  var __accessCheck = (obj, member, msg) => member.has(obj) || __typeError("Cannot " + msg);
  var __privateGet = (obj, member, getter) => (__accessCheck(obj, member, "read from private field"), member.get(obj));
  var __privateAdd = (obj, member, value) => member.has(obj) ? __typeError("Cannot add the same private member more than once") : member instanceof WeakSet ? member.add(obj) : member.set(obj, value);
  function toArray(v) {
    if (v == null) return [];
    return Array.isArray(v) ? v : [v];
  }
  var first = (v) => v[0];
  var last = (v) => v[v.length - 1];
  var add = (v, ...items) => v.concat(items);
  var remove = (v, ...items) => v.filter((t) => !items.includes(t));
  var isArrayLike = (value) => (value == null ? void 0 : value.constructor.name) === "Array";
  var isArrayEqual = (a, b) => {
    if (a.length !== b.length) return false;
    for (let i = 0; i < a.length; i++) {
      if (!isEqual(a[i], b[i])) return false;
    }
    return true;
  };
  var isEqual = (a, b) => {
    if (Object.is(a, b)) return true;
    if (a == null && b != null || a != null && b == null) return false;
    if (typeof (a == null ? void 0 : a.isEqual) === "function" && typeof (b == null ? void 0 : b.isEqual) === "function") {
      return a.isEqual(b);
    }
    if (typeof a === "function" && typeof b === "function") {
      return a.toString() === b.toString();
    }
    if (isArrayLike(a) && isArrayLike(b)) {
      return isArrayEqual(Array.from(a), Array.from(b));
    }
    if (!(typeof a === "object") || !(typeof b === "object")) return false;
    const keys = Object.keys(b != null ? b : /* @__PURE__ */ Object.create(null));
    const length = keys.length;
    for (let i = 0; i < length; i++) {
      const hasKey = Reflect.has(a, keys[i]);
      if (!hasKey) return false;
    }
    for (let i = 0; i < length; i++) {
      const key = keys[i];
      if (!isEqual(a[key], b[key])) return false;
    }
    return true;
  };
  var isObjectLike = (v) => v != null && typeof v === "object";
  var isString = (v) => typeof v === "string";
  var isFunction = (v) => typeof v === "function";
  var hasProp = (obj, prop) => Object.prototype.hasOwnProperty.call(obj, prop);
  var baseGetTag = (v) => Object.prototype.toString.call(v);
  var fnToString = Function.prototype.toString;
  var objectCtorString = fnToString.call(Object);
  var isPlainObject = (v) => {
    if (!isObjectLike(v) || baseGetTag(v) != "[object Object]" || isFrameworkElement(v)) return false;
    const proto = Object.getPrototypeOf(v);
    if (proto === null) return true;
    const Ctor = hasProp(proto, "constructor") && proto.constructor;
    return typeof Ctor == "function" && Ctor instanceof Ctor && fnToString.call(Ctor) == objectCtorString;
  };
  var isReactElement = (x) => typeof x === "object" && x !== null && "$$typeof" in x && "props" in x;
  var isVueElement = (x) => typeof x === "object" && x !== null && "__v_isVNode" in x;
  var isFrameworkElement = (x) => isReactElement(x) || isVueElement(x);
  var runIfFn = (v, ...a) => {
    const res = typeof v === "function" ? v(...a) : v;
    return res != null ? res : void 0;
  };
  var identity = (v) => v();
  var uuid = /* @__PURE__ */ (() => {
    let id = 0;
    return () => {
      id++;
      return id.toString(36);
    };
  })();
  var { floor, abs, round, min, max, pow, sign } = Math;
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
  function splitProps(props3, keys) {
    const rest = {};
    const result = {};
    const keySet = new Set(keys);
    const ownKeys = Reflect.ownKeys(props3);
    for (const key of ownKeys) {
      if (keySet.has(key)) {
        result[key] = props3[key];
      } else {
        rest[key] = props3[key];
      }
    }
    return [result, rest];
  }
  var createSplitProps = (keys) => {
    return function split(props3) {
      return splitProps(props3, keys);
    };
  };
  var currentTime = () => performance.now();
  var _tick;
  var Timer = class {
    constructor(onTick) {
      this.onTick = onTick;
      __publicField3(this, "frameId", null);
      __publicField3(this, "pausedAtMs", null);
      __publicField3(this, "context");
      __publicField3(this, "cancelFrame", () => {
        if (this.frameId === null) return;
        cancelAnimationFrame(this.frameId);
        this.frameId = null;
      });
      __publicField3(this, "setStartMs", (startMs) => {
        this.context.startMs = startMs;
      });
      __publicField3(this, "start", () => {
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
      __publicField3(this, "pause", () => {
        if (this.frameId === null) return;
        this.cancelFrame();
        this.pausedAtMs = currentTime();
      });
      __publicField3(this, "stop", () => {
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
  function warn(...a) {
    const m = a.length === 1 ? a[0] : a[1];
    const c = a.length === 2 ? a[0] : true;
    if (c && true) {
      console.warn(m);
    }
  }
  function ensureProps(props3, keys, scope) {
    let missingKeys = [];
    for (const key of keys) {
      if (props3[key] == null) missingKeys.push(key);
    }
    if (missingKeys.length > 0)
      throw new Error(`[zag-js${scope ? ` > ${scope}` : ""}] missing required props: ${missingKeys.join(", ")}`);
  }

  // ../node_modules/.pnpm/@zag-js+core@1.33.0/node_modules/@zag-js/core/dist/index.mjs
  function createGuards() {
    return {
      and: (...guards2) => {
        return function andGuard(params) {
          return guards2.every((str) => params.guard(str));
        };
      },
      or: (...guards2) => {
        return function orGuard(params) {
          return guards2.some((str) => params.guard(str));
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
        return function chooseFn({ choose }) {
          var _a;
          return (_a = choose(transitions)) == null ? void 0 : _a.actions;
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
  function createScope(props3) {
    const getRootNode = () => {
      var _a, _b;
      return (_b = (_a = props3.getRootNode) == null ? void 0 : _a.call(props3)) != null ? _b : document;
    };
    const getDoc = () => getDocument(getRootNode());
    const getWin = () => {
      var _a;
      return (_a = getDoc().defaultView) != null ? _a : window;
    };
    const getActiveElementFn = () => getActiveElement(getRootNode());
    const getById = (id) => getRootNode().getElementById(id);
    return __spreadProps(__spreadValues({}, props3), {
      getRootNode,
      getDoc,
      getWin,
      getActiveElement: getActiveElementFn,
      isActiveElement,
      getById
    });
  }

  // ../node_modules/.pnpm/@zag-js+types@1.33.0/node_modules/@zag-js/types/dist/index.mjs
  function createNormalizer(fn) {
    return new Proxy({}, {
      get(_target, key) {
        if (key === "style")
          return (props3) => {
            return fn({ style: props3 }).style;
          };
        return fn;
      }
    });
  }
  var createProps = () => (props3) => Array.from(new Set(props3));

  // ../node_modules/.pnpm/@zag-js+accordion@1.33.0/node_modules/@zag-js/accordion/dist/index.mjs
  var anatomy = createAnatomy("accordion").parts("root", "item", "itemTrigger", "itemContent", "itemIndicator");
  var parts = anatomy.build();
  var getRootId = (ctx) => {
    var _a, _b;
    return (_b = (_a = ctx.ids) == null ? void 0 : _a.root) != null ? _b : `accordion:${ctx.id}`;
  };
  var getItemId = (ctx, value) => {
    var _a, _b, _c;
    return (_c = (_b = (_a = ctx.ids) == null ? void 0 : _a.item) == null ? void 0 : _b.call(_a, value)) != null ? _c : `accordion:${ctx.id}:item:${value}`;
  };
  var getItemContentId = (ctx, value) => {
    var _a, _b, _c;
    return (_c = (_b = (_a = ctx.ids) == null ? void 0 : _a.itemContent) == null ? void 0 : _b.call(_a, value)) != null ? _c : `accordion:${ctx.id}:content:${value}`;
  };
  var getItemTriggerId = (ctx, value) => {
    var _a, _b, _c;
    return (_c = (_b = (_a = ctx.ids) == null ? void 0 : _a.itemTrigger) == null ? void 0 : _b.call(_a, value)) != null ? _c : `accordion:${ctx.id}:trigger:${value}`;
  };
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
  var { and, not } = createGuards();
  var machine = createMachine({
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
          const next = prop("multiple") ? remove(context.get("value"), event.value) : [];
          context.set("value", next);
        },
        expand({ context, prop, event }) {
          const next = prop("multiple") ? add(context.get("value"), event.value) : [event.value];
          context.set("value", next);
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

  // ../node_modules/.pnpm/@zag-js+store@1.33.0/node_modules/@zag-js/store/dist/index.mjs
  function glob() {
    if (typeof globalThis !== "undefined") return globalThis;
    if (typeof self !== "undefined") return self;
    if (typeof window !== "undefined") return window;
    if (typeof global !== "undefined") return global;
  }
  function globalRef(key, value) {
    const g = glob();
    if (!g) return value();
    g[key] || (g[key] = value());
    return g[key];
  }
  var refSet = globalRef("__zag__refSet", () => /* @__PURE__ */ new WeakSet());
  var isReactElement2 = (x) => typeof x === "object" && x !== null && "$$typeof" in x && "props" in x;
  var isVueElement2 = (x) => typeof x === "object" && x !== null && "__v_isVNode" in x;
  var isDOMElement = (x) => typeof x === "object" && x !== null && "nodeType" in x && typeof x.nodeName === "string";
  var isElement = (x) => isReactElement2(x) || isVueElement2(x) || isDOMElement(x);
  var isObject2 = (x) => x !== null && typeof x === "object";
  var canProxy = (x) => isObject2(x) && !refSet.has(x) && (Array.isArray(x) || !(Symbol.iterator in x)) && !isElement(x) && !(x instanceof WeakMap) && !(x instanceof WeakSet) && !(x instanceof Error) && !(x instanceof Number) && !(x instanceof Date) && !(x instanceof String) && !(x instanceof RegExp) && !(x instanceof ArrayBuffer) && !(x instanceof Promise) && !(x instanceof File) && !(x instanceof Blob) && !(x instanceof AbortController);
  var isDev = () => true;
  var proxyStateMap = globalRef("__zag__proxyStateMap", () => /* @__PURE__ */ new WeakMap());
  var buildProxyFunction = (objectIs = Object.is, newProxy = (target, handler) => new Proxy(target, handler), snapCache = /* @__PURE__ */ new WeakMap(), createSnapshot = (target, version) => {
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
    if (!isObject2(initialObject)) {
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
        var _a;
        const hasPrevValue = Reflect.has(target, prop);
        const prevValue = Reflect.get(target, prop, receiver);
        if (hasPrevValue && (objectIs(prevValue, value) || proxyCache.has(value) && objectIs(prevValue, proxyCache.get(value)))) {
          return true;
        }
        removePropListener(prop);
        if (isObject2(value)) {
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

  // ../node_modules/.pnpm/@zag-js+vanilla@1.33.0/node_modules/@zag-js/vanilla/dist/index.mjs
  var __defProp4 = Object.defineProperty;
  var __defNormalProp4 = (obj, key, value) => key in obj ? __defProp4(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
  var __publicField4 = (obj, key, value) => __defNormalProp4(obj, typeof key !== "symbol" ? key + "" : key, value);
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
      if (!key.startsWith("--")) key = key.replace(/[A-Z]/g, (match) => `-${match.toLowerCase()}`);
      string += `${key}:${value};`;
    }
    return string;
  };
  var normalizeProps = createNormalizer((props3) => {
    return Object.entries(props3).reduce((acc, [key, value]) => {
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
    const addEvt = (e, f) => {
      node.addEventListener(e.toLowerCase(), f);
    };
    const remEvt = (e, f) => {
      node.removeEventListener(e.toLowerCase(), f);
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
  function bindable(props3) {
    var _a, _b;
    const initial = (_a = props3().value) != null ? _a : props3().defaultValue;
    if (props3().debug) {
      console.log(`[bindable > ${props3().debug}] initial`, initial);
    }
    const eq = (_b = props3().isEqual) != null ? _b : Object.is;
    const store = proxy({ value: initial });
    const controlled = () => props3().value !== void 0;
    return {
      initial,
      ref: store,
      get() {
        return controlled() ? props3().value : store.value;
      },
      set(nextValue) {
        var _a2, _b2;
        const prev = store.value;
        const next = isFunction(nextValue) ? nextValue(prev) : nextValue;
        if (props3().debug) {
          console.log(`[bindable > ${props3().debug}] setValue`, { next, prev });
        }
        if (!controlled()) store.value = next;
        if (!eq(next, prev)) {
          (_b2 = (_a2 = props3()).onChange) == null ? void 0 : _b2.call(_a2, next, prev);
        }
      },
      invoke(nextValue, prevValue) {
        var _a2, _b2;
        (_b2 = (_a2 = props3()).onChange) == null ? void 0 : _b2.call(_a2, nextValue, prevValue);
      },
      hash(value) {
        var _a2, _b2, _c;
        return (_c = (_b2 = (_a2 = props3()).hash) == null ? void 0 : _b2.call(_a2, value)) != null ? _c : String(value);
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
    const result = __spreadValues({}, prev);
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
    constructor(machine4, userProps = {}) {
      var _a, _b, _c;
      this.machine = machine4;
      __publicField4(this, "scope");
      __publicField4(this, "context");
      __publicField4(this, "prop");
      __publicField4(this, "state");
      __publicField4(this, "refs");
      __publicField4(this, "computed");
      __publicField4(this, "event", { type: "" });
      __publicField4(this, "previousEvent", { type: "" });
      __publicField4(this, "effects", /* @__PURE__ */ new Map());
      __publicField4(this, "transition", null);
      __publicField4(this, "cleanups", []);
      __publicField4(this, "subscriptions", []);
      __publicField4(this, "userPropsRef");
      __publicField4(this, "getEvent", () => __spreadProps(__spreadValues({}, this.event), {
        current: () => this.event,
        previous: () => this.previousEvent
      }));
      __publicField4(this, "getStateConfig", (state2) => {
        return this.machine.states[state2];
      });
      __publicField4(this, "getState", () => __spreadProps(__spreadValues({}, this.state), {
        matches: (...values) => values.includes(this.state.get()),
        hasTag: (tag) => {
          var _a2, _b2;
          return !!((_b2 = (_a2 = this.getStateConfig(this.state.get())) == null ? void 0 : _a2.tags) == null ? void 0 : _b2.includes(tag));
        }
      }));
      __publicField4(this, "debug", (...args) => {
        if (this.machine.debug) console.log(...args);
      });
      __publicField4(this, "notify", () => {
        this.publish();
      });
      __publicField4(this, "send", (event) => {
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
      __publicField4(this, "action", (keys) => {
        const strs = isFunction(keys) ? keys(this.getParams()) : keys;
        if (!strs) return;
        const fns = strs.map((s) => {
          var _a2, _b2;
          const fn = (_b2 = (_a2 = this.machine.implementations) == null ? void 0 : _a2.actions) == null ? void 0 : _b2[s];
          if (!fn) warn(`[zag-js] No implementation found for action "${JSON.stringify(s)}"`);
          return fn;
        });
        for (const fn of fns) {
          fn == null ? void 0 : fn(this.getParams());
        }
      });
      __publicField4(this, "guard", (str) => {
        var _a2, _b2;
        if (isFunction(str)) return str(this.getParams());
        return (_b2 = (_a2 = this.machine.implementations) == null ? void 0 : _a2.guards) == null ? void 0 : _b2[str](this.getParams());
      });
      __publicField4(this, "effect", (keys) => {
        const strs = isFunction(keys) ? keys(this.getParams()) : keys;
        if (!strs) return;
        const fns = strs.map((s) => {
          var _a2, _b2;
          const fn = (_b2 = (_a2 = this.machine.implementations) == null ? void 0 : _a2.effects) == null ? void 0 : _b2[s];
          if (!fn) warn(`[zag-js] No implementation found for effect "${JSON.stringify(s)}"`);
          return fn;
        });
        const cleanups = [];
        for (const fn of fns) {
          const cleanup = fn == null ? void 0 : fn(this.getParams());
          if (cleanup) cleanups.push(cleanup);
        }
        return () => cleanups.forEach((fn) => fn == null ? void 0 : fn());
      });
      __publicField4(this, "choose", (transitions) => {
        return toArray(transitions).find((t) => {
          let result = !t.guard;
          if (isString(t.guard)) result = !!this.guard(t.guard);
          else if (isFunction(t.guard)) result = t.guard(this.getParams());
          return result;
        });
      });
      __publicField4(this, "subscribe", (fn) => {
        this.subscriptions.push(fn);
        return () => {
          const index = this.subscriptions.indexOf(fn);
          if (index > -1) this.subscriptions.splice(index, 1);
        };
      });
      __publicField4(this, "status", MachineStatus.NotStarted);
      __publicField4(this, "publish", () => {
        this.callTrackers();
        this.subscriptions.forEach((fn) => fn(this.service));
      });
      __publicField4(this, "trackers", []);
      __publicField4(this, "setupTrackers", () => {
        var _a2, _b2;
        (_b2 = (_a2 = this.machine).watch) == null ? void 0 : _b2.call(_a2, this.getParams());
      });
      __publicField4(this, "callTrackers", () => {
        this.trackers.forEach(({ deps, fn }) => {
          const next = deps.map((dep) => dep());
          if (!isEqual(fn.prev, next)) {
            fn();
            fn.prev = next;
          }
        });
      });
      __publicField4(this, "getParams", () => ({
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
      const { id, ids, getRootNode } = runIfFn(userProps);
      this.scope = createScope({ id, ids, getRootNode });
      const prop = (key) => {
        var _a2, _b2;
        const __props = runIfFn(this.userPropsRef.current);
        const props3 = (_b2 = (_a2 = machine4.props) == null ? void 0 : _a2.call(machine4, { props: compact(__props), scope: this.scope })) != null ? _b2 : __props;
        return props3[key];
      };
      this.prop = prop;
      const context = (_a = machine4.context) == null ? void 0 : _a.call(machine4, {
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
        return (_b2 = (_a2 = machine4.computed) == null ? void 0 : _a2[key]({
          context: ctx,
          event: this.getEvent(),
          prop,
          refs: this.refs,
          scope: this.scope,
          computed
        })) != null ? _b2 : {};
      };
      this.computed = computed;
      const refs = createRefs((_c = (_b = machine4.refs) == null ? void 0 : _b.call(machine4, { prop, context: ctx })) != null ? _c : {});
      this.refs = refs;
      const state = bindable(() => ({
        defaultValue: machine4.initialState({ prop }),
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
            this.action(machine4.entry);
            const cleanup2 = this.effect(machine4.effects);
            if (cleanup2) this.effects.set(INIT_STATE, cleanup2);
          }
          this.action((_d = this.getStateConfig(nextState)) == null ? void 0 : _d.entry);
        }
      }));
      this.state = state;
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

  // lib/core.ts
  var Component = class {
    constructor(el, props3) {
      __publicField(this, "el");
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      __publicField(this, "machine");
      __publicField(this, "api");
      __publicField(this, "init", () => {
        this.machine.start();
        this.render();
        this.machine.subscribe(() => {
          this.api = this.initApi();
          this.render();
        });
      });
      __publicField(this, "destroy", () => {
        this.machine.stop();
      });
      __publicField(this, "spreadProps", (el, props3) => {
        spreadProps(el, props3);
      });
      __publicField(this, "updateProps", (props3) => {
        this.machine.updateProps(props3);
      });
      if (!el) throw new Error("Root element not found");
      this.el = el;
      this.machine = this.initMachine(props3);
      this.api = this.initApi();
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
      return value.split(",").map((v) => v.trim()).filter((v) => v.length > 0);
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
    return element.hasAttribute(`data-${attrName}`);
  };
  var generateId = (element, fallbackId = "element") => {
    if (element == null ? void 0 : element.id) return element.id;
    return `${fallbackId}-${Math.random().toString(36).substring(2, 9)}`;
  };

  // components/accordion.ts
  var Accordion = class extends Component {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    initMachine(props3) {
      return new VanillaMachine(machine, props3);
    }
    initApi() {
      return connect(this.machine.service, normalizeProps);
    }
    render() {
      const rootEl = this.el.querySelector('[data-part="root"]') || this.el;
      this.spreadProps(rootEl, this.api.getRootProps());
      const items = this.el.querySelectorAll('[data-part="item"]');
      for (let i = 0; i < items.length; i++) {
        const itemEl = items[i];
        const value = getString(itemEl, "value");
        if (!value) continue;
        const disabled = getBoolean(itemEl, "disabled");
        this.spreadProps(itemEl, this.api.getItemProps({ value, disabled }));
        const triggerEl = itemEl.querySelector('[data-part="item-trigger"]');
        if (triggerEl) {
          this.spreadProps(triggerEl, this.api.getItemTriggerProps({ value, disabled }));
        }
        const indicatorEl = itemEl.querySelector('[data-part="item-indicator"]');
        if (indicatorEl) {
          this.spreadProps(indicatorEl, this.api.getItemIndicatorProps({ value, disabled }));
        }
        const contentEl = itemEl.querySelector('[data-part="item-content"]');
        if (contentEl) {
          this.spreadProps(contentEl, this.api.getItemContentProps({ value, disabled }));
        }
      }
    }
  };

  // hooks/accordion.ts
  var AccordionHook = {
    mounted() {
      this.wasFocused = null;
      const el = this.el;
      const pushEvent = this.pushEvent.bind(this);
      const props3 = {
        id: el.id,
        defaultValue: getStringList(el, "defaultValue"),
        value: getStringList(el, "value"),
        collapsible: getBoolean(el, "collapsible"),
        disabled: getBoolean(el, "disabled"),
        multiple: getBoolean(el, "multiple"),
        orientation: getString(el, "orientation", ["horizontal", "vertical"]),
        dir: getString(el, "dir", ["ltr", "rtl"]),
        onValueChange: (details) => {
          const eventName = getString(el, "onValueChange");
          if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
            pushEvent(eventName, {
              value: details.value,
              accordion_id: el.id
            });
          }
          const eventNameClient = getString(el, "onValueChangeClient");
          if (eventNameClient) {
            el.dispatchEvent(
              new CustomEvent(eventNameClient, {
                bubbles: true,
                detail: {
                  value: details.value,
                  accordion_id: el.id
                }
              })
            );
          }
        }
      };
      const accordion = new Accordion(el, props3);
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
      var _a;
      (_a = this.accordion) == null ? void 0 : _a.updateProps({
        defaultValue: getStringList(this.el, "defaultValue"),
        value: getStringList(this.el, "value"),
        collapsible: getBoolean(this.el, "collapsible"),
        disabled: getBoolean(this.el, "disabled"),
        multiple: getBoolean(this.el, "multiple"),
        orientation: getString(this.el, "orientation", ["horizontal", "vertical"]),
        dir: getString(this.el, "dir", ["ltr", "rtl"])
      });
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

  // ../node_modules/.pnpm/@zag-js+dismissable@1.33.0/node_modules/@zag-js/dismissable/dist/index.mjs
  var LAYER_REQUEST_DISMISS_EVENT = "layer:request-dismiss";
  var layerStack = {
    layers: [],
    branches: [],
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
      return this.getNestedLayers(node).some((layer) => contains(layer.node, target));
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
  function fireCustomEvent(el, type, detail) {
    const win = el.ownerDocument.defaultView || window;
    const event = new win.CustomEvent(type, { cancelable: true, bubbles: true, detail });
    return el.dispatchEvent(event);
  }
  function addListenerOnce(el, type, callback) {
    el.addEventListener(type, callback, { once: true });
  }
  function trackDismissableBranch(nodeOrFn, options = {}) {
    const { defer } = options;
    const func = defer ? raf : (v) => v();
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

  // ../node_modules/.pnpm/@zag-js+toast@1.33.0/node_modules/@zag-js/toast/dist/index.mjs
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
    var _a;
    return (_a = duration != null ? duration : defaultTimeouts[type]) != null ? _a : defaultTimeouts.DEFAULT;
  }
  var getOffsets = (offsets) => typeof offsets === "string" ? { left: offsets, right: offsets, bottom: offsets, top: offsets } : offsets;
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
      const offset = computedOffset.top;
      styles.top = `max(env(safe-area-inset-top, 0px), ${offset})`;
    }
    if (computedPlacement.includes("bottom")) {
      const offset = computedOffset.bottom;
      styles.bottom = `max(env(safe-area-inset-bottom, 0px), ${offset})`;
    }
    if (!computedPlacement.includes("left")) {
      const offset = computedOffset.right;
      styles.insetInlineEnd = `calc(env(safe-area-inset-right, 0px) + ${offset})`;
    }
    if (!computedPlacement.includes("right")) {
      const offset = computedOffset.left;
      styles.insetInlineStart = `calc(env(safe-area-inset-left, 0px) + ${offset})`;
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
    const offset = computed("heightIndex") * gap + computed("heightBefore");
    const styles = {
      position: "absolute",
      pointerEvents: "auto",
      "--opacity": "0",
      "--remove-delay": `${prop("removeDelay")}ms`,
      "--duration": `${duration}ms`,
      "--initial-height": `${height}px`,
      "--offset": `${offset}px`,
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
        return normalize.element(__spreadProps(__spreadValues({}, parts2.group.attrs), {
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
  var { guards, createMachine: createMachine2 } = setup();
  var { and: and2 } = guards;
  var groupMachine = createMachine2({
    props({ props: props3 }) {
      return __spreadProps(__spreadValues({
        dir: "ltr",
        id: uuid()
      }, props3), {
        store: props3.store
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
          hash: (toasts) => toasts.map((t) => t.id).join(",")
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
              context.set("toasts", (prev) => prev.filter((t) => t.id !== toast.id));
              return;
            }
            context.set("toasts", (prev) => {
              const index = prev.findIndex((t) => t.id === toast.id);
              if (index !== -1) {
                return [...prev.slice(0, index), __spreadValues(__spreadValues({}, prev[index]), toast), ...prev.slice(index + 1)];
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
  function connect2(service, normalize) {
    const { state, send, prop, scope, context, computed } = service;
    const visible = state.hasTag("visible");
    const paused = state.hasTag("paused");
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
        return normalize.element(__spreadProps(__spreadValues({}, parts2.root.attrs), {
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
        return normalize.element(__spreadProps(__spreadValues({}, parts2.title.attrs), {
          id: getTitleId(scope)
        }));
      },
      getDescriptionProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts2.description.attrs), {
          id: getDescriptionId(scope)
        }));
      },
      getActionTriggerProps() {
        return normalize.button(__spreadProps(__spreadValues({}, parts2.actionTrigger.attrs), {
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
          id: getCloseTriggerId(scope)
        }, parts2.closeTrigger.attrs), {
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
  var { not: not2 } = createGuards();
  var machine2 = createMachine({
    props({ props: props3 }) {
      ensureProps(props3, ["id", "type", "parent", "removeDelay"], "toast");
      return __spreadProps(__spreadValues({
        closable: true
      }, props3), {
        duration: getToastDuration(props3.duration, props3.type)
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
  function setHeight(parent, item) {
    const { id, height } = item;
    parent.context.set("heights", (prev) => {
      const alreadyExists = prev.find((i) => i.id === id);
      if (!alreadyExists) {
        return [{ id, height }, ...prev];
      } else {
        return prev.map((i) => i.id === id ? __spreadProps(__spreadValues({}, i), { height }) : i);
      }
    });
  }
  var withDefaults = (options, defaults) => {
    return __spreadValues(__spreadValues({}, defaults), compact(options));
  };
  function createToastStore(props3 = {}) {
    const attrs = withDefaults(props3, {
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
          remove2(id);
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
    constructor(el, props3) {
      super(el, props3);
      __publicField(this, "parts");
      __publicField(this, "destroy", () => {
        this.machine.stop();
        this.el.remove();
      });
      this.el.setAttribute("data-scope", "toast");
      this.el.setAttribute("data-part", "root");
      this.el.innerHTML = `
      <span data-scope="toast" data-part="ghost-before"></span>
      <div data-scope="toast" data-part="progressbar"></div>

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
        title: this.el.querySelector('[data-part="title"]'),
        description: this.el.querySelector('[data-part="description"]'),
        close: this.el.querySelector('[data-part="close-trigger"]'),
        ghostBefore: this.el.querySelector('[data-part="ghost-before"]'),
        ghostAfter: this.el.querySelector('[data-part="ghost-after"]')
      };
    }
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    initMachine(props3) {
      return new VanillaMachine(machine2, props3);
    }
    initApi() {
      return connect2(this.machine.service, normalizeProps);
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
    }
  };
  var ToastGroup = class extends Component {
    constructor(el, props3) {
      var _a;
      super(el, props3);
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
      this.store = props3.store;
      this.groupEl = (_a = el.querySelector('[data-part="group"]')) != null ? _a : (() => {
        const g = document.createElement("div");
        g.setAttribute("data-scope", "toast");
        g.setAttribute("data-part", "group");
        el.appendChild(g);
        return g;
      })();
    }
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    initMachine(props3) {
      return new VanillaMachine(group.machine, props3);
    }
    initApi() {
      return group.connect(this.machine.service, normalizeProps);
    }
    render() {
      this.spreadProps(this.groupEl, this.api.getGroupProps());
      const toasts = this.api.getToasts().filter((t) => typeof t.id === "string");
      const nextIds = new Set(toasts.map((t) => t.id));
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

  // hooks/toast.ts
  function onDisconnect(groupId) {
    const store = getToastStore(groupId);
    if (!store) return;
    store.create({
      title: "Disconnected",
      description: "You have been disconnected from the server.",
      type: "info"
    });
  }
  function onConnect(groupId) {
    const store = getToastStore(groupId);
    if (!store) return;
    store.create({
      title: "Connected",
      description: "You have been connected to the server.",
      type: "success"
    });
  }
  var ToastHook = {
    mounted() {
      const el = this.el;
      if (!el.id) {
        el.id = generateId(el, "toast");
      }
      const groupId = el.id;
      const placement = getString(el, "placement", [
        "top-start",
        "top",
        "top-end",
        "bottom-start",
        "bottom",
        "bottom-end"
      ]) || "bottom-end";
      const overlap = getBoolean(el, "overlap");
      const max2 = getNumber(el, "max");
      const gap = getNumber(el, "gap");
      const offsets = getString(el, "offset");
      const pauseOnPageIdle = getBoolean(el, "pause-on-page-idle");
      let parsedOffsets;
      if (offsets) {
        try {
          parsedOffsets = offsets.includes("{") ? JSON.parse(offsets) : offsets;
        } catch (e) {
          parsedOffsets = offsets;
        }
      }
      createToastGroup(el, {
        id: groupId,
        placement,
        overlap,
        max: max2,
        gap,
        offsets: parsedOffsets,
        pauseOnPageIdle
      });
      this.handleEvent(
        "toast-create",
        (payload) => {
          const store2 = getToastStore(payload.groupId || groupId);
          if (!store2) return;
          try {
            store2.create({
              title: payload.title,
              description: payload.description,
              type: payload.type || "info",
              id: payload.id || generateId(void 0, "toast"),
              duration: payload.duration
            });
          } catch (error) {
            console.error("Failed to create toast:", error);
          }
        }
      );
      this.handleEvent(
        "toast-update",
        (payload) => {
          const store2 = getToastStore(payload.groupId || groupId);
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
        }
      );
      this.handleEvent("toast-dismiss", (payload) => {
        const store2 = getToastStore(payload.groupId || groupId);
        if (!store2) return;
        try {
          store2.dismiss(payload.id);
        } catch (error) {
          console.error("Failed to dismiss toast:", error);
        }
      });
      el.addEventListener("toast:create", (event) => {
        const { detail } = event;
        const store2 = getToastStore(detail.groupId || groupId);
        if (!store2) return;
        try {
          store2.create({
            title: detail.title,
            description: detail.description,
            type: detail.type || "info",
            id: detail.id || generateId(void 0, "toast"),
            duration: detail.duration
          });
        } catch (error) {
          console.error("Failed to create toast:", error);
        }
      });
      const store = getToastStore(groupId);
      const flashInfo = el.dataset.flashInfo;
      const flashError = el.dataset.flashError;
      if (store && flashInfo) {
        try {
          store.create({
            title: flashInfo,
            type: "info",
            id: generateId(void 0, "toast")
          });
        } catch (error) {
          console.error("Failed to create flash info toast:", error);
        }
      }
      if (store && flashError) {
        try {
          store.create({
            title: flashError,
            type: "error",
            id: generateId(void 0, "toast")
          });
        } catch (error) {
          console.error("Failed to create flash error toast:", error);
        }
      }
      const handleDisconnect = () => onDisconnect(groupId);
      const handleConnect = () => onConnect(groupId);
      this._toastDisconnect = handleDisconnect;
      this._toastConnect = handleConnect;
      window.addEventListener("phx:disconnect", handleDisconnect);
      window.addEventListener("phx:connect", handleConnect);
    },
    destroyed() {
      const anyThis = this;
      if (anyThis._toastDisconnect) {
        window.removeEventListener("phx:disconnect", anyThis._toastDisconnect);
      }
      if (anyThis._toastConnect) {
        window.removeEventListener("phx:connect", anyThis._toastConnect);
      }
    }
  };

  // ../node_modules/.pnpm/@zag-js+focus-visible@1.33.0/node_modules/@zag-js/focus-visible/dist/index.mjs
  function isValidKey(e) {
    return !(e.metaKey || !isMac() && e.altKey || e.ctrlKey || e.key === "Control" || e.key === "Shift" || e.key === "Meta");
  }
  var nonTextInputTypes = /* @__PURE__ */ new Set(["checkbox", "radio", "range", "color", "file", "image", "button", "submit", "reset"]);
  function isKeyboardFocusEvent(isTextInput, modality, e) {
    const target = e ? getEventTarget(e) : null;
    const win = getWindow(target);
    isTextInput = isTextInput || target instanceof win.HTMLInputElement && !nonTextInputTypes.has(target == null ? void 0 : target.type) || target instanceof win.HTMLTextAreaElement || target instanceof win.HTMLElement && target.isContentEditable;
    return !(isTextInput && modality === "keyboard" && e instanceof win.KeyboardEvent && !Reflect.has(FOCUS_VISIBLE_INPUT_KEYS, e.key));
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
  function triggerChangeHandlers(modality, e) {
    for (let handler of changeHandlers) {
      handler(modality, e);
    }
  }
  function handleKeyboardEvent(e) {
    hasEventBeforeFocus = true;
    if (isValidKey(e)) {
      currentModality = "keyboard";
      triggerChangeHandlers("keyboard", e);
    }
  }
  function handlePointerEvent(e) {
    currentModality = "pointer";
    if (e.type === "mousedown" || e.type === "pointerdown") {
      hasEventBeforeFocus = true;
      triggerChangeHandlers("pointer", e);
    }
  }
  function handleClickEvent(e) {
    if (isVirtualClick(e)) {
      hasEventBeforeFocus = true;
      currentModality = "virtual";
    }
  }
  function handleFocusEvent(e) {
    const target = getEventTarget(e);
    if (target === getWindow(target) || target === getDocument(target)) {
      return;
    }
    if (!hasEventBeforeFocus && !hasBlurredWindowRecently) {
      currentModality = "virtual";
      triggerChangeHandlers("virtual", e);
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
    } catch (e) {
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
    } catch (e) {
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
  function trackFocusVisible(props3 = {}) {
    const { isTextInput, autoFocus, onChange, root } = props3;
    setupGlobalFocusEvents(root);
    onChange == null ? void 0 : onChange({ isFocusVisible: autoFocus || isFocusVisible(), modality: currentModality });
    const handler = (modality, e) => {
      if (!isKeyboardFocusEvent(!!isTextInput, modality, e)) return;
      onChange == null ? void 0 : onChange({ isFocusVisible: isFocusVisible(), modality });
    };
    changeHandlers.add(handler);
    return () => {
      changeHandlers.delete(handler);
    };
  }

  // ../node_modules/.pnpm/@zag-js+switch@1.33.0/node_modules/@zag-js/switch/dist/index.mjs
  var anatomy3 = createAnatomy("switch").parts("root", "label", "control", "thumb");
  var parts3 = anatomy3.build();
  var getRootId3 = (ctx) => {
    var _a, _b;
    return (_b = (_a = ctx.ids) == null ? void 0 : _a.root) != null ? _b : `switch:${ctx.id}`;
  };
  var getLabelId = (ctx) => {
    var _a, _b;
    return (_b = (_a = ctx.ids) == null ? void 0 : _a.label) != null ? _b : `switch:${ctx.id}:label`;
  };
  var getThumbId = (ctx) => {
    var _a, _b;
    return (_b = (_a = ctx.ids) == null ? void 0 : _a.thumb) != null ? _b : `switch:${ctx.id}:thumb`;
  };
  var getControlId = (ctx) => {
    var _a, _b;
    return (_b = (_a = ctx.ids) == null ? void 0 : _a.control) != null ? _b : `switch:${ctx.id}:control`;
  };
  var getHiddenInputId = (ctx) => {
    var _a, _b;
    return (_b = (_a = ctx.ids) == null ? void 0 : _a.hiddenInput) != null ? _b : `switch:${ctx.id}:input`;
  };
  var getRootEl3 = (ctx) => ctx.getById(getRootId3(ctx));
  var getHiddenInputEl = (ctx) => ctx.getById(getHiddenInputId(ctx));
  function connect3(service, normalize) {
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
        return normalize.label(__spreadProps(__spreadValues(__spreadValues({}, parts3.root.attrs), dataAttrs), {
          dir: prop("dir"),
          id: getRootId3(scope),
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
            var _a;
            if (disabled) return;
            const target = getEventTarget(event);
            if (target === getHiddenInputEl(scope)) {
              event.stopPropagation();
            }
            if (isSafari()) {
              (_a = getHiddenInputEl(scope)) == null ? void 0 : _a.focus();
            }
          }
        }));
      },
      getLabelProps() {
        return normalize.element(__spreadProps(__spreadValues(__spreadValues({}, parts3.label.attrs), dataAttrs), {
          dir: prop("dir"),
          id: getLabelId(scope)
        }));
      },
      getThumbProps() {
        return normalize.element(__spreadProps(__spreadValues(__spreadValues({}, parts3.thumb.attrs), dataAttrs), {
          dir: prop("dir"),
          id: getThumbId(scope),
          "aria-hidden": true
        }));
      },
      getControlProps() {
        return normalize.element(__spreadProps(__spreadValues(__spreadValues({}, parts3.control.attrs), dataAttrs), {
          dir: prop("dir"),
          id: getControlId(scope),
          "aria-hidden": true
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
  var { not: not3 } = createGuards();
  var machine3 = createMachine({
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
          guard: not3("isTrusted"),
          actions: ["toggleChecked", "dispatchChangeEvent"]
        },
        {
          actions: ["toggleChecked"]
        }
      ],
      "CHECKED.SET": [
        {
          guard: not3("isTrusted"),
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
  var props2 = createProps()([
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
  var splitProps3 = createSplitProps(props2);

  // components/switch.ts
  var Switch = class extends Component {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    initMachine(props3) {
      return new VanillaMachine(machine3, props3);
    }
    initApi() {
      return connect3(this.machine.service, normalizeProps);
    }
    render() {
      const rootEl = this.el.querySelector('[data-part="root"]') || this.el;
      this.spreadProps(rootEl, this.api.getRootProps());
      const inputEl = this.el.querySelector('[data-part="hidden-input"]');
      if (inputEl) {
        this.spreadProps(inputEl, this.api.getHiddenInputProps());
      }
      const labelEl = this.el.querySelector('[data-part="label"]');
      if (labelEl) {
        this.spreadProps(labelEl, this.api.getLabelProps());
      }
      const controlEl = this.el.querySelector('[data-part="control"]');
      if (controlEl) {
        this.spreadProps(controlEl, this.api.getControlProps());
      }
      const thumbEl = this.el.querySelector('[data-part="thumb"]');
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
      const zagSwitch = new Switch(el, __spreadProps(__spreadValues({
        id: el.id
      }, getBoolean(el, "controlled") ? { checked: getBoolean(el, "checked") } : { defaultChecked: getBoolean(el, "default-checked") }), {
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
              switch_id: el.id
            });
          }
          const eventNameClient = getString(el, "onCheckedChangeClient");
          if (eventNameClient) {
            el.dispatchEvent(
              new CustomEvent(eventNameClient, {
                bubbles: true,
                detail: {
                  value: details,
                  switch_id: el.id
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
          const targetId = payload.switch_id;
          if (targetId && targetId !== el.id) return;
          zagSwitch.api.setChecked(payload.value);
        })
      );
      this.handlers.push(
        this.handleEvent("switch_toggle_checked", (payload) => {
          const targetId = payload.switch_id;
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
      var _a;
      this.wasFocused = ((_a = this.zagSwitch) == null ? void 0 : _a.api.focused) || false;
    },
    updated() {
      var _a;
      (_a = this.zagSwitch) == null ? void 0 : _a.updateProps(__spreadProps(__spreadValues({
        id: this.el.id
      }, getBoolean(this.el, "controlled") ? { checked: getBoolean(this.el, "checked") } : { defaultChecked: getBoolean(this.el, "default-checked") }), {
        disabled: getBoolean(this.el, "disabled"),
        name: getString(this.el, "name"),
        value: getString(this.el, "value"),
        dir: getString(this.el, "dir", ["ltr", "rtl"]),
        invalid: getBoolean(this.el, "invalid"),
        required: getBoolean(this.el, "required"),
        readOnly: getBoolean(this.el, "read-only"),
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

  // hooks/corex.ts
  var Hooks = { Accordion: AccordionHook, Toast: ToastHook, Switch: SwitchHook };
  var corex_default = Hooks;
  return __toCommonJS(corex_exports);
})();
