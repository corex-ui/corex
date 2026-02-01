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
  var __await = function(promise, isYieldStar) {
    this[0] = promise;
    this[1] = isYieldStar;
  };
  var __yieldStar = (value) => {
    var obj = value[__knownSymbol("asyncIterator")], isAwait = false, method, it = {};
    if (obj == null) {
      obj = value[__knownSymbol("iterator")]();
      method = (k) => it[k] = (x) => obj[k](x);
    } else {
      obj = obj.call(value);
      method = (k) => it[k] = (v) => {
        if (isAwait) {
          isAwait = false;
          if (k === "throw") throw v;
          return v;
        }
        isAwait = true;
        return {
          done: false,
          value: new __await(new Promise((resolve) => {
            var x = obj[k](v);
            if (!(x instanceof Object)) __typeError("Object expected");
            resolve(x);
          }), 1)
        };
      };
    }
    return it[__knownSymbol("iterator")] = () => it, method("next"), "throw" in obj ? method("throw") : it.throw = (x) => {
      throw x;
    }, "return" in obj && method("return"), it;
  };

  // hooks/corex.ts
  var corex_exports = {};
  __export(corex_exports, {
    default: () => corex_default
  });

  // ../node_modules/.pnpm/@zag-js+anatomy@1.33.0/node_modules/@zag-js/anatomy/dist/index.mjs
  var createAnatomy = (name, parts6 = []) => ({
    parts: (...values) => {
      if (isEmpty(parts6)) {
        return createAnatomy(name, values);
      }
      throw new Error("createAnatomy().parts(...) should only be called once. Did you mean to use .extendWith(...) ?");
    },
    extendWith: (...values) => createAnatomy(name, [...parts6, ...values]),
    omit: (...values) => createAnatomy(name, parts6.filter((part) => !values.includes(part))),
    rename: (newName) => createAnatomy(newName, parts6),
    keys: () => parts6,
    build: () => [...new Set(parts6)].reduce(
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
    const ua22 = navigator.userAgentData;
    if (ua22 && Array.isArray(ua22.brands)) {
      return ua22.brands.map(({ brand, version }) => `${brand}/${version}`).join(" ");
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
  var __typeError2 = (msg) => {
    throw TypeError(msg);
  };
  var __defNormalProp3 = (obj, key, value) => key in obj ? __defProp3(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
  var __publicField3 = (obj, key, value) => __defNormalProp3(obj, typeof key !== "symbol" ? key + "" : key, value);
  var __accessCheck = (obj, member, msg) => member.has(obj) || __typeError2("Cannot " + msg);
  var __privateGet = (obj, member, getter) => (__accessCheck(obj, member, "read from private field"), member.get(obj));
  var __privateAdd = (obj, member, value) => member.has(obj) ? __typeError2("Cannot add the same private member more than once") : member instanceof WeakSet ? member.add(obj) : member.set(obj, value);
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
  function splitProps(props5, keys) {
    const rest = {};
    const result = {};
    const keySet = new Set(keys);
    const ownKeys = Reflect.ownKeys(props5);
    for (const key of ownKeys) {
      if (keySet.has(key)) {
        result[key] = props5[key];
      } else {
        rest[key] = props5[key];
      }
    }
    return [result, rest];
  }
  var createSplitProps = (keys) => {
    return function split(props5) {
      return splitProps(props5, keys);
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
  function ensureProps(props5, keys, scope) {
    let missingKeys = [];
    for (const key of keys) {
      if (props5[key] == null) missingKeys.push(key);
    }
    if (missingKeys.length > 0)
      throw new Error(`[zag-js${scope ? ` > ${scope}` : ""}] missing required props: ${missingKeys.join(", ")}`);
  }

  // ../node_modules/.pnpm/@zag-js+core@1.33.0/node_modules/@zag-js/core/dist/index.mjs
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
  var MachineStatus = /* @__PURE__ */ ((MachineStatus2) => {
    MachineStatus2["NotStarted"] = "Not Started";
    MachineStatus2["Started"] = "Started";
    MachineStatus2["Stopped"] = "Stopped";
    return MachineStatus2;
  })(MachineStatus || {});
  var INIT_STATE = "__init__";
  function createScope(props5) {
    const getRootNode2 = () => {
      var _a, _b;
      return (_b = (_a = props5.getRootNode) == null ? void 0 : _a.call(props5)) != null ? _b : document;
    };
    const getDoc = () => getDocument(getRootNode2());
    const getWin = () => {
      var _a;
      return (_a = getDoc().defaultView) != null ? _a : window;
    };
    const getActiveElementFn = () => getActiveElement(getRootNode2());
    const getById = (id) => getRootNode2().getElementById(id);
    return __spreadProps(__spreadValues({}, props5), {
      getRootNode: getRootNode2,
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
          return (props5) => {
            return fn({ style: props5 }).style;
          };
        return fn;
      }
    });
  }
  var createProps = () => (props5) => Array.from(new Set(props5));

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
            const keyMap3 = {
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
            const exec = keyMap3[key];
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
        const remove3 = propProxyState[3](createPropListener(prop));
        propProxyStates.set(prop, [propProxyState, remove3]);
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
          const remove3 = propProxyState[3](createPropListener(prop));
          propProxyStates.set(prop, [propProxyState, remove3]);
        });
      }
      const removeListener = () => {
        listeners.delete(listener);
        if (listeners.size === 0) {
          propProxyStates.forEach(([propProxyState, remove3], prop) => {
            if (remove3) {
              remove3();
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
      if (!key.startsWith("--")) key = key.replace(/[A-Z]/g, (match3) => `-${match3.toLowerCase()}`);
      string += `${key}:${value};`;
    }
    return string;
  };
  var normalizeProps = createNormalizer((props5) => {
    return Object.entries(props5).reduce((acc, [key, value]) => {
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
    const setup3 = (attr) => addEvt(attr.substring(2), attrs[attr]);
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
    attrKeys.filter(onEvents).forEach(setup3);
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
  function bindable(props5) {
    var _a, _b;
    const initial = (_a = props5().value) != null ? _a : props5().defaultValue;
    if (props5().debug) {
      console.log(`[bindable > ${props5().debug}] initial`, initial);
    }
    const eq = (_b = props5().isEqual) != null ? _b : Object.is;
    const store = proxy({ value: initial });
    const controlled = () => props5().value !== void 0;
    return {
      initial,
      ref: store,
      get() {
        return controlled() ? props5().value : store.value;
      },
      set(nextValue) {
        var _a2, _b2;
        const prev = store.value;
        const next = isFunction(nextValue) ? nextValue(prev) : nextValue;
        if (props5().debug) {
          console.log(`[bindable > ${props5().debug}] setValue`, { next, prev });
        }
        if (!controlled()) store.value = next;
        if (!eq(next, prev)) {
          (_b2 = (_a2 = props5()).onChange) == null ? void 0 : _b2.call(_a2, next, prev);
        }
      },
      invoke(nextValue, prevValue) {
        var _a2, _b2;
        (_b2 = (_a2 = props5()).onChange) == null ? void 0 : _b2.call(_a2, nextValue, prevValue);
      },
      hash(value) {
        var _a2, _b2, _c;
        return (_c = (_b2 = (_a2 = props5()).hash) == null ? void 0 : _b2.call(_a2, value)) != null ? _c : String(value);
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
    constructor(machine6, userProps = {}) {
      var _a, _b, _c;
      this.machine = machine6;
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
      const { id, ids, getRootNode: getRootNode2 } = runIfFn(userProps);
      this.scope = createScope({ id, ids, getRootNode: getRootNode2 });
      const prop = (key) => {
        var _a2, _b2;
        const __props = runIfFn(this.userPropsRef.current);
        const props5 = (_b2 = (_a2 = machine6.props) == null ? void 0 : _a2.call(machine6, { props: compact(__props), scope: this.scope })) != null ? _b2 : __props;
        return props5[key];
      };
      this.prop = prop;
      const context = (_a = machine6.context) == null ? void 0 : _a.call(machine6, {
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
        return (_b2 = (_a2 = machine6.computed) == null ? void 0 : _a2[key]({
          context: ctx,
          event: this.getEvent(),
          prop,
          refs: this.refs,
          scope: this.scope,
          computed
        })) != null ? _b2 : {};
      };
      this.computed = computed;
      const refs = createRefs((_c = (_b = machine6.refs) == null ? void 0 : _b.call(machine6, { prop, context: ctx })) != null ? _c : {});
      this.refs = refs;
      const state = bindable(() => ({
        defaultValue: machine6.initialState({ prop }),
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
            this.action(machine6.entry);
            const cleanup2 = this.effect(machine6.effects);
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
    constructor(el, props5) {
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
      __publicField(this, "spreadProps", (el, props5) => {
        spreadProps(el, props5);
      });
      __publicField(this, "updateProps", (props5) => {
        this.machine.updateProps(props5);
      });
      if (!el) throw new Error("Root element not found");
      this.el = el;
      this.machine = this.initMachine(props5);
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
    const dashName = attrName.replace(/([A-Z])/g, "-$1").toLowerCase();
    return element.hasAttribute(`data-${dashName}`);
  };
  var generateId = (element, fallbackId = "element") => {
    if (element == null ? void 0 : element.id) return element.id;
    return `${fallbackId}-${Math.random().toString(36).substring(2, 9)}`;
  };

  // components/accordion.ts
  var Accordion = class extends Component {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    initMachine(props5) {
      return new VanillaMachine(machine, props5);
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
      const el = this.el;
      const pushEvent = this.pushEvent.bind(this);
      const props5 = __spreadProps(__spreadValues({
        id: el.id
      }, getBoolean(el, "controlled") ? { value: getStringList(el, "value") } : { defaultValue: getStringList(el, "defaultValue") }), {
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
      const accordion = new Accordion(el, props5);
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
      (_a = this.accordion) == null ? void 0 : _a.updateProps(__spreadProps(__spreadValues({}, getBoolean(this.el, "controlled") ? { value: getStringList(this.el, "value") } : { defaultValue: getStringList(this.el, "defaultValue") }), {
        collapsible: getBoolean(this.el, "collapsible"),
        disabled: getBoolean(this.el, "disabled"),
        multiple: getBoolean(this.el, "multiple"),
        orientation: getString(this.el, "orientation", ["horizontal", "vertical"]),
        dir: getString(this.el, "dir", ["ltr", "rtl"])
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
    props({ props: props5 }) {
      return __spreadProps(__spreadValues({
        dir: "ltr",
        id: uuid()
      }, props5), {
        store: props5.store
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
    props({ props: props5 }) {
      ensureProps(props5, ["id", "type", "parent", "removeDelay"], "toast");
      return __spreadProps(__spreadValues({
        closable: true
      }, props5), {
        duration: getToastDuration(props5.duration, props5.type)
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
  function createToastStore(props5 = {}) {
    const attrs = withDefaults(props5, {
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
    constructor(el, props5) {
      super(el, props5);
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
    initMachine(props5) {
      return new VanillaMachine(machine2, props5);
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
    constructor(el, props5) {
      var _a;
      super(el, props5);
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
      this.store = props5.store;
      this.groupEl = (_a = el.querySelector('[data-part="group"]')) != null ? _a : (() => {
        const g = document.createElement("div");
        g.setAttribute("data-scope", "toast");
        g.setAttribute("data-part", "group");
        el.appendChild(g);
        return g;
      })();
    }
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    initMachine(props5) {
      return new VanillaMachine(group.machine, props5);
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
      const max4 = getNumber(el, "max");
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
        max: max4,
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

  // ../node_modules/.pnpm/@zag-js+anatomy@1.33.1/node_modules/@zag-js/anatomy/dist/index.mjs
  var createAnatomy2 = (name, parts6 = []) => ({
    parts: (...values) => {
      if (isEmpty2(parts6)) {
        return createAnatomy2(name, values);
      }
      throw new Error("createAnatomy().parts(...) should only be called once. Did you mean to use .extendWith(...) ?");
    },
    extendWith: (...values) => createAnatomy2(name, [...parts6, ...values]),
    omit: (...values) => createAnatomy2(name, parts6.filter((part) => !values.includes(part))),
    rename: (newName) => createAnatomy2(newName, parts6),
    keys: () => parts6,
    build: () => [...new Set(parts6)].reduce(
      (prev, part) => Object.assign(prev, {
        [part]: {
          selector: [
            `&[data-scope="${toKebabCase2(name)}"][data-part="${toKebabCase2(part)}"]`,
            `& [data-scope="${toKebabCase2(name)}"][data-part="${toKebabCase2(part)}"]`
          ].join(", "),
          attrs: { "data-scope": toKebabCase2(name), "data-part": toKebabCase2(part) }
        }
      }),
      {}
    )
  });
  var toKebabCase2 = (value) => value.replace(/([A-Z])([A-Z])/g, "$1-$2").replace(/([a-z])([A-Z])/g, "$1-$2").replace(/[\s_]+/g, "-").toLowerCase();
  var isEmpty2 = (v) => v.length === 0;

  // ../node_modules/.pnpm/@zag-js+dom-query@1.33.1/node_modules/@zag-js/dom-query/dist/index.mjs
  var __defProp5 = Object.defineProperty;
  var __defNormalProp5 = (obj, key, value) => key in obj ? __defProp5(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
  var __publicField5 = (obj, key, value) => __defNormalProp5(obj, typeof key !== "symbol" ? key + "" : key, value);
  function setCaretToEnd(input) {
    if (!input) return;
    try {
      if (input.ownerDocument.activeElement !== input) return;
      const len = input.value.length;
      input.setSelectionRange(len, len);
    } catch (e) {
    }
  }
  var noop2 = () => void 0;
  var isObject3 = (v) => typeof v === "object" && v !== null;
  var dataAttr2 = (guard) => guard ? "" : void 0;
  var ariaAttr = (guard) => guard ? "true" : void 0;
  var ELEMENT_NODE2 = 1;
  var DOCUMENT_NODE2 = 9;
  var DOCUMENT_FRAGMENT_NODE2 = 11;
  var isHTMLElement2 = (el) => isObject3(el) && el.nodeType === ELEMENT_NODE2 && typeof el.nodeName === "string";
  var isDocument2 = (el) => isObject3(el) && el.nodeType === DOCUMENT_NODE2;
  var isWindow2 = (el) => isObject3(el) && el === el.window;
  var getNodeName = (node) => {
    if (isHTMLElement2(node)) return node.localName || "";
    return "#document";
  };
  function isRootElement(node) {
    return ["html", "body", "#document"].includes(getNodeName(node));
  }
  var isNode2 = (el) => isObject3(el) && el.nodeType !== void 0;
  var isShadowRoot2 = (el) => isNode2(el) && el.nodeType === DOCUMENT_FRAGMENT_NODE2 && "host" in el;
  var isAnchorElement = (el) => !!(el == null ? void 0 : el.matches("a[href]"));
  var isElementVisible = (el) => {
    if (!isHTMLElement2(el)) return false;
    return el.offsetWidth > 0 || el.offsetHeight > 0 || el.getClientRects().length > 0;
  };
  function contains2(parent, child) {
    var _a;
    if (!parent || !child) return false;
    if (!isHTMLElement2(parent) || !isHTMLElement2(child)) return false;
    const rootNode = (_a = child.getRootNode) == null ? void 0 : _a.call(child);
    if (parent === child) return true;
    if (parent.contains(child)) return true;
    if (rootNode && isShadowRoot2(rootNode)) {
      let next = child;
      while (next) {
        if (parent === next) return true;
        next = next.parentNode || next.host;
      }
    }
    return false;
  }
  function getDocument2(el) {
    var _a;
    if (isDocument2(el)) return el;
    if (isWindow2(el)) return el.document;
    return (_a = el == null ? void 0 : el.ownerDocument) != null ? _a : document;
  }
  function getDocumentElement(el) {
    return getDocument2(el).documentElement;
  }
  function getWindow2(el) {
    var _a, _b, _c;
    if (isShadowRoot2(el)) return getWindow2(el.host);
    if (isDocument2(el)) return (_a = el.defaultView) != null ? _a : window;
    if (isHTMLElement2(el)) return (_c = (_b = el.ownerDocument) == null ? void 0 : _b.defaultView) != null ? _c : window;
    return window;
  }
  function getParentNode(node) {
    if (getNodeName(node) === "html") return node;
    const result = node.assignedSlot || node.parentNode || isShadowRoot2(node) && node.host || getDocumentElement(node);
    return isShadowRoot2(result) ? result.host : result;
  }
  function getRootNode(node) {
    var _a;
    let result;
    try {
      result = node.getRootNode({ composed: true });
      if (isDocument2(result) || isShadowRoot2(result)) return result;
    } catch (e) {
    }
    return (_a = node.ownerDocument) != null ? _a : document;
  }
  var styleCache = /* @__PURE__ */ new WeakMap();
  function getComputedStyle2(el) {
    if (!styleCache.has(el)) {
      styleCache.set(el, getWindow2(el).getComputedStyle(el));
    }
    return styleCache.get(el);
  }
  var INTERACTIVE_CONTAINER_ROLE = /* @__PURE__ */ new Set(["menu", "listbox", "dialog", "grid", "tree", "region"]);
  var isInteractiveContainerRole = (role) => INTERACTIVE_CONTAINER_ROLE.has(role);
  var getAriaControls = (element) => {
    var _a;
    return ((_a = element.getAttribute("aria-controls")) == null ? void 0 : _a.split(" ")) || [];
  };
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
  var isDom2 = () => typeof document !== "undefined";
  function getPlatform2() {
    var _a;
    const agent = navigator.userAgentData;
    return (_a = agent == null ? void 0 : agent.platform) != null ? _a : navigator.platform;
  }
  function getUserAgent2() {
    const ua22 = navigator.userAgentData;
    if (ua22 && Array.isArray(ua22.brands)) {
      return ua22.brands.map(({ brand, version }) => `${brand}/${version}`).join(" ");
    }
    return navigator.userAgent;
  }
  var pt2 = (v) => isDom2() && v.test(getPlatform2());
  var ua2 = (v) => isDom2() && v.test(getUserAgent2());
  var vn2 = (v) => isDom2() && v.test(navigator.vendor);
  var isTouchDevice = () => isDom2() && !!navigator.maxTouchPoints;
  var isIPhone2 = () => pt2(/^iPhone/i);
  var isIPad2 = () => pt2(/^iPad/i) || isMac2() && navigator.maxTouchPoints > 1;
  var isIos2 = () => isIPhone2() || isIPad2();
  var isApple2 = () => isMac2() || isIos2();
  var isMac2 = () => pt2(/^Mac/i);
  var isSafari2 = () => isApple2() && vn2(/apple/i);
  var isFirefox = () => ua2(/Firefox/i);
  function getComposedPath2(event) {
    var _a, _b, _c, _d;
    return (_d = (_a = event.composedPath) == null ? void 0 : _a.call(event)) != null ? _d : (_c = (_b = event.nativeEvent) == null ? void 0 : _b.composedPath) == null ? void 0 : _c.call(_b);
  }
  function getEventTarget2(event) {
    var _a;
    const composedPath = getComposedPath2(event);
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
  function isCtrlOrMetaKey(e) {
    if (isMac2()) return e.metaKey;
    return e.ctrlKey;
  }
  var isLeftClick = (e) => e.button === 0;
  var isContextMenuEvent = (e) => {
    return e.button === 2 || isMac2() && e.ctrlKey && e.button === 0;
  };
  var keyMap2 = {
    Up: "ArrowUp",
    Down: "ArrowDown",
    Esc: "Escape",
    " ": "Space",
    ",": "Comma",
    Left: "ArrowLeft",
    Right: "ArrowRight"
  };
  var rtlKeyMap2 = {
    ArrowLeft: "ArrowRight",
    ArrowRight: "ArrowLeft"
  };
  function getEventKey2(event, options = {}) {
    var _a;
    const { dir = "ltr", orientation = "horizontal" } = options;
    let key = event.key;
    key = (_a = keyMap2[key]) != null ? _a : key;
    const isRtl = dir === "rtl" && orientation === "horizontal";
    if (isRtl && key in rtlKeyMap2) key = rtlKeyMap2[key];
    return key;
  }
  function getNativeEvent(event) {
    var _a;
    return (_a = event.nativeEvent) != null ? _a : event;
  }
  var addDomEvent2 = (target, eventName, handler, options) => {
    const node = typeof target === "function" ? target() : target;
    node == null ? void 0 : node.addEventListener(eventName, handler, options);
    return () => {
      node == null ? void 0 : node.removeEventListener(eventName, handler, options);
    };
  };
  var focusableSelector = "input:not([type='hidden']):not([disabled]), select:not([disabled]), textarea:not([disabled]), a[href], button:not([disabled]), [tabindex], iframe, object, embed, area[href], audio[controls], video[controls], [contenteditable]:not([contenteditable='false']), details > summary:first-of-type";
  function isFocusable(element) {
    if (!isHTMLElement2(element) || element.closest("[inert]")) return false;
    return element.matches(focusableSelector) && isElementVisible(element);
  }
  var AnimationFrame2 = class _AnimationFrame2 {
    constructor() {
      __publicField5(this, "id", null);
      __publicField5(this, "fn_cleanup");
      __publicField5(this, "cleanup", () => {
        this.cancel();
      });
    }
    static create() {
      return new _AnimationFrame2();
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
  function raf2(fn) {
    const frame = AnimationFrame2.create();
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
    const cancelTimer = raf2(() => {
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
    const func = defer ? raf2 : (v) => v();
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
  function clickIfLink(el) {
    const click = () => {
      const win = getWindow2(el);
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
    if (isRootElement(parentNode)) return getDocument2(parentNode).body;
    if (isHTMLElement2(parentNode) && isOverflowElement(parentNode)) return parentNode;
    return getNearestOverflowAncestor(parentNode);
  }
  var OVERFLOW_RE = /auto|scroll|overlay|hidden|clip/;
  var nonOverflowValues = /* @__PURE__ */ new Set(["inline", "contents"]);
  function isOverflowElement(el) {
    const win = getWindow2(el);
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
  function queryAll2(root, selector) {
    var _a;
    return Array.from((_a = root == null ? void 0 : root.querySelectorAll(selector)) != null ? _a : []);
  }
  function query(root, selector) {
    var _a;
    return (_a = root == null ? void 0 : root.querySelector(selector)) != null ? _a : null;
  }
  var defaultItemToId2 = (v) => v.id;
  function itemById2(v, id, itemToId = defaultItemToId2) {
    return v.find((item) => itemToId(item) === id);
  }
  function indexOfId2(v, id, itemToId = defaultItemToId2) {
    const item = itemById2(v, id, itemToId);
    return item ? v.indexOf(item) : -1;
  }
  function nextById2(v, id, loop = true) {
    let idx = indexOfId2(v, id);
    idx = loop ? (idx + 1) % v.length : Math.min(idx + 1, v.length - 1);
    return v[idx];
  }
  function prevById2(v, id, loop = true) {
    let idx = indexOfId2(v, id);
    if (idx === -1) return loop ? v[v.length - 1] : null;
    idx = loop ? (idx - 1 + v.length) % v.length : Math.max(0, idx - 1);
    return v[idx];
  }
  function setStyle2(el, style) {
    if (!el) return noop2;
    const prev = Object.keys(style).reduce((acc, key) => {
      acc[key] = el.style.getPropertyValue(key);
      return acc;
    }, {});
    if (isEqual2(prev, style)) return noop2;
    Object.assign(el.style, style);
    return () => {
      Object.assign(el.style, prev);
      if (el.style.length === 0) {
        el.removeAttribute("style");
      }
    };
  }
  function isEqual2(a, b) {
    return Object.keys(a).every((key) => a[key] === b[key]);
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
  function waitForElement2(target, options) {
    const { timeout, rootNode } = options;
    const win = getWindow2(rootNode);
    const doc = getDocument2(rootNode);
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
  var first2 = (v) => v[0];
  var last2 = (v) => v[v.length - 1];
  var has = (v, t) => v.indexOf(t) !== -1;
  var add2 = (v, ...items) => v.concat(items);
  var remove2 = (v, ...items) => v.filter((t) => !items.includes(t));
  var addOrRemove = (v, item) => has(v, item) ? remove2(v, item) : add2(v, item);
  var isArrayLike2 = (value) => (value == null ? void 0 : value.constructor.name) === "Array";
  var isArrayEqual2 = (a, b) => {
    if (a.length !== b.length) return false;
    for (let i = 0; i < a.length; i++) {
      if (!isEqual3(a[i], b[i])) return false;
    }
    return true;
  };
  var isEqual3 = (a, b) => {
    if (Object.is(a, b)) return true;
    if (a == null && b != null || a != null && b == null) return false;
    if (typeof (a == null ? void 0 : a.isEqual) === "function" && typeof (b == null ? void 0 : b.isEqual) === "function") {
      return a.isEqual(b);
    }
    if (typeof a === "function" && typeof b === "function") {
      return a.toString() === b.toString();
    }
    if (isArrayLike2(a) && isArrayLike2(b)) {
      return isArrayEqual2(Array.from(a), Array.from(b));
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
      if (!isEqual3(a[key], b[key])) return false;
    }
    return true;
  };
  var isArray = (v) => Array.isArray(v);
  var isBoolean = (v) => v === true || v === false;
  var isObjectLike2 = (v) => v != null && typeof v === "object";
  var isObject4 = (v) => isObjectLike2(v) && !isArray(v);
  var isFunction2 = (v) => typeof v === "function";
  var isNull = (v) => v == null;
  var hasProp2 = (obj, prop) => Object.prototype.hasOwnProperty.call(obj, prop);
  var baseGetTag2 = (v) => Object.prototype.toString.call(v);
  var fnToString2 = Function.prototype.toString;
  var objectCtorString2 = fnToString2.call(Object);
  var isPlainObject2 = (v) => {
    if (!isObjectLike2(v) || baseGetTag2(v) != "[object Object]" || isFrameworkElement2(v)) return false;
    const proto = Object.getPrototypeOf(v);
    if (proto === null) return true;
    const Ctor = hasProp2(proto, "constructor") && proto.constructor;
    return typeof Ctor == "function" && Ctor instanceof Ctor && fnToString2.call(Ctor) == objectCtorString2;
  };
  var isReactElement3 = (x) => typeof x === "object" && x !== null && "$$typeof" in x && "props" in x;
  var isVueElement3 = (x) => typeof x === "object" && x !== null && "__v_isVNode" in x;
  var isFrameworkElement2 = (x) => isReactElement3(x) || isVueElement3(x);
  var noop3 = () => {
  };
  var callAll = (...fns) => (...a) => {
    fns.forEach(function(fn) {
      fn == null ? void 0 : fn(...a);
    });
  };
  function match(key, record, ...args) {
    var _a;
    if (key in record) {
      const fn = record[key];
      return isFunction2(fn) ? fn(...args) : fn;
    }
    const error = new Error(`No matching key: ${JSON.stringify(key)} in ${JSON.stringify(Object.keys(record))}`);
    (_a = Error.captureStackTrace) == null ? void 0 : _a.call(Error, error, match);
    throw error;
  }
  var { floor: floor2, abs: abs2, round: round2, min: min2, max: max2, pow: pow2, sign: sign2 } = Math;
  function compact2(obj) {
    if (!isPlainObject2(obj) || obj === void 0) return obj;
    const keys = Reflect.ownKeys(obj).filter((key) => typeof key === "string");
    const filtered = {};
    for (const key of keys) {
      const value = obj[key];
      if (value !== void 0) {
        filtered[key] = compact2(value);
      }
    }
    return filtered;
  }
  function splitProps3(props5, keys) {
    const rest = {};
    const result = {};
    const keySet = new Set(keys);
    const ownKeys = Reflect.ownKeys(props5);
    for (const key of ownKeys) {
      if (keySet.has(key)) {
        result[key] = props5[key];
      } else {
        rest[key] = props5[key];
      }
    }
    return [result, rest];
  }
  var createSplitProps2 = (keys) => {
    return function split(props5) {
      return splitProps3(props5, keys);
    };
  };
  var _tick2;
  _tick2 = /* @__PURE__ */ new WeakMap();
  function warn2(...a) {
    const m = a.length === 1 ? a[0] : a[1];
    const c = a.length === 2 ? a[0] : true;
    if (c && true) {
      console.warn(m);
    }
  }
  function ensure(c, m) {
    if (c == null) throw new Error(m());
  }
  function ensureProps2(props5, keys, scope) {
    let missingKeys = [];
    for (const key of keys) {
      if (props5[key] == null) missingKeys.push(key);
    }
    if (missingKeys.length > 0)
      throw new Error(`[zag-js${scope ? ` > ${scope}` : ""}] missing required props: ${missingKeys.join(", ")}`);
  }

  // ../node_modules/.pnpm/@zag-js+core@1.33.1/node_modules/@zag-js/core/dist/index.mjs
  function createGuards2() {
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
  function createMachine3(config) {
    return config;
  }
  function setup2() {
    return {
      guards: createGuards2(),
      createMachine: (config) => {
        return createMachine3(config);
      },
      choose: (transitions) => {
        return function chooseFn({ choose: choose2 }) {
          var _a;
          return (_a = choose2(transitions)) == null ? void 0 : _a.actions;
        };
      }
    };
  }

  // ../node_modules/.pnpm/@zag-js+types@1.33.1/node_modules/@zag-js/types/dist/index.mjs
  var createProps2 = () => (props5) => Array.from(new Set(props5));

  // ../node_modules/.pnpm/@zag-js+toggle-group@1.33.1/node_modules/@zag-js/toggle-group/dist/index.mjs
  var anatomy3 = createAnatomy2("toggle-group").parts("root", "item");
  var parts3 = anatomy3.build();
  var getRootId3 = (ctx) => {
    var _a, _b;
    return (_b = (_a = ctx.ids) == null ? void 0 : _a.root) != null ? _b : `toggle-group:${ctx.id}`;
  };
  var getItemId2 = (ctx, value) => {
    var _a, _b, _c;
    return (_c = (_b = (_a = ctx.ids) == null ? void 0 : _a.item) == null ? void 0 : _b.call(_a, value)) != null ? _c : `toggle-group:${ctx.id}:${value}`;
  };
  var getRootEl3 = (ctx) => ctx.getById(getRootId3(ctx));
  var getElements = (ctx) => {
    const ownerId = CSS.escape(getRootId3(ctx));
    const selector = `[data-ownedby='${ownerId}']:not([data-disabled])`;
    return queryAll2(getRootEl3(ctx), selector);
  };
  var getFirstEl = (ctx) => first2(getElements(ctx));
  var getLastEl = (ctx) => last2(getElements(ctx));
  var getNextEl = (ctx, id, loopFocus) => nextById2(getElements(ctx), id, loopFocus);
  var getPrevEl = (ctx, id, loopFocus) => prevById2(getElements(ctx), id, loopFocus);
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
        return normalize.element(__spreadProps(__spreadValues({}, parts3.root.attrs), {
          id: getRootId3(scope),
          dir: prop("dir"),
          role: isSingle ? "radiogroup" : "group",
          tabIndex: context.get("isTabbingBackward") ? -1 : 0,
          "data-disabled": dataAttr2(disabled),
          "data-orientation": prop("orientation"),
          "data-focus": dataAttr2(context.get("focusedId") != null),
          style: { outline: "none" },
          onMouseDown() {
            if (disabled) return;
            send({ type: "ROOT.MOUSE_DOWN" });
          },
          onFocus(event) {
            if (disabled) return;
            if (event.currentTarget !== getEventTarget2(event)) return;
            if (context.get("isClickFocus")) return;
            if (context.get("isTabbingBackward")) return;
            send({ type: "ROOT.FOCUS" });
          },
          onBlur(event) {
            const target = event.relatedTarget;
            if (contains2(event.currentTarget, target)) return;
            if (disabled) return;
            send({ type: "ROOT.BLUR" });
          }
        }));
      },
      getItemState,
      getItemProps(props22) {
        const itemState = getItemState(props22);
        const rovingTabIndex = itemState.focused ? 0 : -1;
        return normalize.button(__spreadProps(__spreadValues({}, parts3.item.attrs), {
          id: itemState.id,
          type: "button",
          "data-ownedby": getRootId3(scope),
          "data-focus": dataAttr2(itemState.focused),
          disabled: itemState.disabled,
          tabIndex: rovingFocus ? rovingTabIndex : void 0,
          // radio
          role: isSingle ? "radio" : void 0,
          "aria-checked": isSingle ? itemState.pressed : void 0,
          "aria-pressed": isSingle ? void 0 : itemState.pressed,
          //
          "data-disabled": dataAttr2(itemState.disabled),
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
            if (isSafari2()) {
              event.currentTarget.focus({ preventScroll: true });
            }
          },
          onKeyDown(event) {
            if (event.defaultPrevented) return;
            if (!contains2(event.currentTarget, getEventTarget2(event))) return;
            if (itemState.disabled) return;
            const keyMap3 = {
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
            const exec = keyMap3[getEventKey2(event)];
            if (exec) {
              exec(event);
              if (event.key !== "Tab") event.preventDefault();
            }
          }
        }));
      }
    };
  }
  var { not: not3, and: and3 } = createGuards2();
  var machine3 = createMachine3({
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
        isFirstToggleFocused: ({ context, scope }) => {
          var _a;
          return context.get("focusedId") === ((_a = getFirstEl(scope)) == null ? void 0 : _a.id);
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
          const closestToolbar = (_a = getRootEl3(scope)) == null ? void 0 : _a.closest("[role=toolbar]");
          context.set("isWithinToolbar", !!closestToolbar);
        },
        setFocusedId({ context, event }) {
          context.set("focusedId", event.id);
        },
        clearFocusedId({ context }) {
          context.set("focusedId", null);
        },
        setValue({ context, event, prop }) {
          ensureProps2(event, ["value"]);
          let next = context.get("value");
          if (isArray(event.value)) {
            next = event.value;
          } else if (prop("multiple")) {
            next = addOrRemove(next, event.value);
          } else {
            const isSelected = isEqual3(next, [event.value]);
            next = isSelected && prop("deselectable") ? [] : [event.value];
          }
          context.set("value", next);
        },
        focusNextToggle({ context, scope, prop }) {
          raf2(() => {
            var _a;
            const focusedId = context.get("focusedId");
            if (!focusedId) return;
            (_a = getNextEl(scope, focusedId, prop("loopFocus"))) == null ? void 0 : _a.focus({ preventScroll: true });
          });
        },
        focusPrevToggle({ context, scope, prop }) {
          raf2(() => {
            var _a;
            const focusedId = context.get("focusedId");
            if (!focusedId) return;
            (_a = getPrevEl(scope, focusedId, prop("loopFocus"))) == null ? void 0 : _a.focus({ preventScroll: true });
          });
        },
        focusFirstToggle({ scope }) {
          raf2(() => {
            var _a;
            (_a = getFirstEl(scope)) == null ? void 0 : _a.focus({ preventScroll: true });
          });
        },
        focusLastToggle({ scope }) {
          raf2(() => {
            var _a;
            (_a = getLastEl(scope)) == null ? void 0 : _a.focus({ preventScroll: true });
          });
        }
      }
    }
  });
  var props2 = createProps2()([
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
  var splitProps4 = createSplitProps2(props2);
  var itemProps2 = createProps2()(["value", "disabled"]);
  var splitItemProps2 = createSplitProps2(itemProps2);

  // components/toggle-group.ts
  var ToggleGroup = class extends Component {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    initMachine(props5) {
      return new VanillaMachine(machine3, props5);
    }
    initApi() {
      return connect3(this.machine.service, normalizeProps);
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
      }
    }
  };

  // hooks/toggle-group.ts
  var ToggleGroupHook = {
    mounted() {
      const el = this.el;
      const pushEvent = this.pushEvent.bind(this);
      const props5 = __spreadProps(__spreadValues({
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
      const toggleGroup = new ToggleGroup(el, props5);
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
  function trackFocusVisible(props5 = {}) {
    const { isTextInput, autoFocus, onChange, root } = props5;
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
  var anatomy4 = createAnatomy("switch").parts("root", "label", "control", "thumb");
  var parts4 = anatomy4.build();
  var getRootId4 = (ctx) => {
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
  var getRootEl4 = (ctx) => ctx.getById(getRootId4(ctx));
  var getHiddenInputEl = (ctx) => ctx.getById(getHiddenInputId(ctx));
  function connect4(service, normalize) {
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
        return normalize.label(__spreadProps(__spreadValues(__spreadValues({}, parts4.root.attrs), dataAttrs), {
          dir: prop("dir"),
          id: getRootId4(scope),
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
        return normalize.element(__spreadProps(__spreadValues(__spreadValues({}, parts4.label.attrs), dataAttrs), {
          dir: prop("dir"),
          id: getLabelId(scope)
        }));
      },
      getThumbProps() {
        return normalize.element(__spreadProps(__spreadValues(__spreadValues({}, parts4.thumb.attrs), dataAttrs), {
          dir: prop("dir"),
          id: getThumbId(scope),
          "aria-hidden": true
        }));
      },
      getControlProps() {
        return normalize.element(__spreadProps(__spreadValues(__spreadValues({}, parts4.control.attrs), dataAttrs), {
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
  var { not: not4 } = createGuards();
  var machine4 = createMachine({
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
          guard: not4("isTrusted"),
          actions: ["toggleChecked", "dispatchChangeEvent"]
        },
        {
          actions: ["toggleChecked"]
        }
      ],
      "CHECKED.SET": [
        {
          guard: not4("isTrusted"),
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
  var props3 = createProps()([
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
  var splitProps5 = createSplitProps(props3);

  // components/switch.ts
  var Switch = class extends Component {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    initMachine(props5) {
      return new VanillaMachine(machine4, props5);
    }
    initApi() {
      return connect4(this.machine.service, normalizeProps);
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
      console.log(getString(el, "form"));
      const zagSwitch = new Switch(el, __spreadProps(__spreadValues({
        id: el.id
      }, getBoolean(el, "controlled") ? { checked: getBoolean(el, "checked") } : { defaultChecked: getBoolean(el, "defaultChecked") }), {
        defaultChecked: getBoolean(el, "defaultChecked"),
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
    updated() {
      var _a;
      (_a = this.zagSwitch) == null ? void 0 : _a.updateProps(__spreadProps(__spreadValues({
        id: this.el.id
      }, getBoolean(this.el, "controlled") ? { checked: getBoolean(this.el, "checked") } : { defaultChecked: getBoolean(this.el, "defaultChecked") }), {
        disabled: getBoolean(this.el, "disabled"),
        name: getString(this.el, "name"),
        value: getString(this.el, "value"),
        dir: getString(this.el, "dir", ["ltr", "rtl"]),
        invalid: getBoolean(this.el, "invalid"),
        required: getBoolean(this.el, "required"),
        readOnly: getBoolean(this.el, "readOnly"),
        label: getString(this.el, "label")
      }));
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

  // ../node_modules/.pnpm/@zag-js+collection@1.33.1/node_modules/@zag-js/collection/dist/index.mjs
  var __defProp6 = Object.defineProperty;
  var __defNormalProp6 = (obj, key, value) => key in obj ? __defProp6(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
  var __publicField6 = (obj, key, value) => __defNormalProp6(obj, typeof key !== "symbol" ? key + "" : key, value);
  var fallback = {
    itemToValue(item) {
      if (typeof item === "string") return item;
      if (isObject4(item) && hasProp2(item, "value")) return item.value;
      return "";
    },
    itemToString(item) {
      if (typeof item === "string") return item;
      if (isObject4(item) && hasProp2(item, "label")) return item.label;
      return fallback.itemToValue(item);
    },
    isItemDisabled(item) {
      if (isObject4(item) && hasProp2(item, "disabled")) return !!item.disabled;
      return false;
    }
  };
  var ListCollection = class _ListCollection {
    constructor(options) {
      this.options = options;
      __publicField6(this, "items");
      __publicField6(this, "indexMap", null);
      __publicField6(this, "copy", (items) => {
        return new _ListCollection(__spreadProps(__spreadValues({}, this.options), { items: items != null ? items : [...this.items] }));
      });
      __publicField6(this, "isEqual", (other) => {
        return isEqual3(this.items, other.items);
      });
      __publicField6(this, "setItems", (items) => {
        return this.copy(items);
      });
      __publicField6(this, "getValues", (items = this.items) => {
        const values = [];
        for (const item of items) {
          const value = this.getItemValue(item);
          if (value != null) values.push(value);
        }
        return values;
      });
      __publicField6(this, "find", (value) => {
        if (value == null) return null;
        const index = this.indexOf(value);
        return index !== -1 ? this.at(index) : null;
      });
      __publicField6(this, "findMany", (values) => {
        const result = [];
        for (const value of values) {
          const item = this.find(value);
          if (item != null) result.push(item);
        }
        return result;
      });
      __publicField6(this, "at", (index) => {
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
      __publicField6(this, "sortFn", (valueA, valueB) => {
        const indexA = this.indexOf(valueA);
        const indexB = this.indexOf(valueB);
        return (indexA != null ? indexA : 0) - (indexB != null ? indexB : 0);
      });
      __publicField6(this, "sort", (values) => {
        return [...values].sort(this.sortFn.bind(this));
      });
      __publicField6(this, "getItemValue", (item) => {
        var _a, _b, _c;
        if (item == null) return null;
        return (_c = (_b = (_a = this.options).itemToValue) == null ? void 0 : _b.call(_a, item)) != null ? _c : fallback.itemToValue(item);
      });
      __publicField6(this, "getItemDisabled", (item) => {
        var _a, _b, _c;
        if (item == null) return false;
        return (_c = (_b = (_a = this.options).isItemDisabled) == null ? void 0 : _b.call(_a, item)) != null ? _c : fallback.isItemDisabled(item);
      });
      __publicField6(this, "stringifyItem", (item) => {
        var _a, _b, _c;
        if (item == null) return null;
        return (_c = (_b = (_a = this.options).itemToString) == null ? void 0 : _b.call(_a, item)) != null ? _c : fallback.itemToString(item);
      });
      __publicField6(this, "stringify", (value) => {
        if (value == null) return null;
        return this.stringifyItem(this.find(value));
      });
      __publicField6(this, "stringifyItems", (items, separator = ", ") => {
        const strs = [];
        for (const item of items) {
          const str = this.stringifyItem(item);
          if (str != null) strs.push(str);
        }
        return strs.join(separator);
      });
      __publicField6(this, "stringifyMany", (value, separator) => {
        return this.stringifyItems(this.findMany(value), separator);
      });
      __publicField6(this, "has", (value) => {
        return this.indexOf(value) !== -1;
      });
      __publicField6(this, "hasItem", (item) => {
        if (item == null) return false;
        return this.has(this.getItemValue(item));
      });
      __publicField6(this, "group", () => {
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
          entries.sort(([a], [b]) => {
            if (typeof groupSort === "function") return groupSort(a, b);
            if (Array.isArray(groupSort)) {
              const indexA = groupSort.indexOf(a);
              const indexB = groupSort.indexOf(b);
              if (indexA === -1) return 1;
              if (indexB === -1) return -1;
              return indexA - indexB;
            }
            if (groupSort === "asc") return a.localeCompare(b);
            if (groupSort === "desc") return b.localeCompare(a);
            return 0;
          });
        }
        return entries;
      });
      __publicField6(this, "getNextValue", (value, step = 1, clamp2 = false) => {
        let index = this.indexOf(value);
        if (index === -1) return null;
        index = clamp2 ? Math.min(index + step, this.size - 1) : index + step;
        while (index <= this.size && this.getItemDisabled(this.at(index))) index++;
        return this.getItemValue(this.at(index));
      });
      __publicField6(this, "getPreviousValue", (value, step = 1, clamp2 = false) => {
        let index = this.indexOf(value);
        if (index === -1) return null;
        index = clamp2 ? Math.max(index - step, 0) : index - step;
        while (index >= 0 && this.getItemDisabled(this.at(index))) index--;
        return this.getItemValue(this.at(index));
      });
      __publicField6(this, "indexOf", (value) => {
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
      __publicField6(this, "getByText", (text, current) => {
        const currentIndex = current != null ? this.indexOf(current) : -1;
        const isSingleKey = text.length === 1;
        for (let i = 0; i < this.items.length; i++) {
          const item = this.items[(currentIndex + i + 1) % this.items.length];
          if (isSingleKey && this.getItemValue(item) === current) continue;
          if (this.getItemDisabled(item)) continue;
          if (match2(this.stringifyItem(item), text)) return item;
        }
        return void 0;
      });
      __publicField6(this, "search", (queryString, options2) => {
        const { state, currentValue, timeout = 350 } = options2;
        const search = state.keysSoFar + queryString;
        const isRepeated = search.length > 1 && Array.from(search).every((char) => char === search[0]);
        const query2 = isRepeated ? search[0] : search;
        const item = this.getByText(query2, currentValue);
        const value = this.getItemValue(item);
        function cleanup() {
          clearTimeout(state.timer);
          state.timer = -1;
        }
        function update(value2) {
          state.keysSoFar = value2;
          cleanup();
          if (value2 !== "") {
            state.timer = +setTimeout(() => {
              update("");
              cleanup();
            }, timeout);
          }
        }
        update(search);
        return value;
      });
      __publicField6(this, "update", (value, item) => {
        let index = this.indexOf(value);
        if (index === -1) return this;
        return this.copy([...this.items.slice(0, index), item, ...this.items.slice(index + 1)]);
      });
      __publicField6(this, "upsert", (value, item, mode = "append") => {
        let index = this.indexOf(value);
        if (index === -1) {
          const fn = mode === "append" ? this.append : this.prepend;
          return fn(item);
        }
        return this.copy([...this.items.slice(0, index), item, ...this.items.slice(index + 1)]);
      });
      __publicField6(this, "insert", (index, ...items) => {
        return this.copy(insert(this.items, index, ...items));
      });
      __publicField6(this, "insertBefore", (value, ...items) => {
        let toIndex = this.indexOf(value);
        if (toIndex === -1) {
          if (this.items.length === 0) toIndex = 0;
          else return this;
        }
        return this.copy(insert(this.items, toIndex, ...items));
      });
      __publicField6(this, "insertAfter", (value, ...items) => {
        let toIndex = this.indexOf(value);
        if (toIndex === -1) {
          if (this.items.length === 0) toIndex = 0;
          else return this;
        }
        return this.copy(insert(this.items, toIndex + 1, ...items));
      });
      __publicField6(this, "prepend", (...items) => {
        return this.copy(insert(this.items, 0, ...items));
      });
      __publicField6(this, "append", (...items) => {
        return this.copy(insert(this.items, this.items.length, ...items));
      });
      __publicField6(this, "filter", (fn) => {
        const filteredItems = this.items.filter((item, index) => fn(this.stringifyItem(item), index, item));
        return this.copy(filteredItems);
      });
      __publicField6(this, "remove", (...itemsOrValues) => {
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
      __publicField6(this, "move", (value, toIndex) => {
        const fromIndex = this.indexOf(value);
        if (fromIndex === -1) return this;
        return this.copy(move(this.items, [fromIndex], toIndex));
      });
      __publicField6(this, "moveBefore", (value, ...values) => {
        let toIndex = this.items.findIndex((item) => this.getItemValue(item) === value);
        if (toIndex === -1) return this;
        let indices = values.map((value2) => this.items.findIndex((item) => this.getItemValue(item) === value2)).sort((a, b) => a - b);
        return this.copy(move(this.items, indices, toIndex));
      });
      __publicField6(this, "moveAfter", (value, ...values) => {
        let toIndex = this.items.findIndex((item) => this.getItemValue(item) === value);
        if (toIndex === -1) return this;
        let indices = values.map((value2) => this.items.findIndex((item) => this.getItemValue(item) === value2)).sort((a, b) => a - b);
        return this.copy(move(this.items, indices, toIndex + 1));
      });
      __publicField6(this, "reorder", (fromIndex, toIndex) => {
        return this.copy(move(this.items, [fromIndex], toIndex));
      });
      __publicField6(this, "compareValue", (a, b) => {
        const indexA = this.indexOf(a);
        const indexB = this.indexOf(b);
        if (indexA < indexB) return -1;
        if (indexA > indexB) return 1;
        return 0;
      });
      __publicField6(this, "range", (from, to) => {
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
      __publicField6(this, "getValueRange", (from, to) => {
        if (from && to) {
          if (this.compareValue(from, to) <= 0) {
            return this.range(from, to);
          }
          return this.range(to, from);
        }
        return [];
      });
      __publicField6(this, "toString", () => {
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
      __publicField6(this, "toJSON", () => {
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
  var match2 = (label, query2) => {
    return !!(label == null ? void 0 : label.toLowerCase().startsWith(query2.toLowerCase()));
  };
  function insert(items, index, ...values) {
    return [...items.slice(0, index), ...values, ...items.slice(index)];
  }
  function move(items, indices, toIndex) {
    indices = [...indices].sort((a, b) => a - b);
    const itemsToMove = indices.map((i) => items[i]);
    for (let i = indices.length - 1; i >= 0; i--) {
      items = [...items.slice(0, indices[i]), ...items.slice(indices[i] + 1)];
    }
    toIndex = Math.max(0, toIndex - indices.filter((i) => i < toIndex).length);
    return [...items.slice(0, toIndex), ...itemsToMove, ...items.slice(toIndex)];
  }

  // ../node_modules/.pnpm/@floating-ui+utils@0.2.10/node_modules/@floating-ui/utils/dist/floating-ui.utils.mjs
  var sides = ["top", "right", "bottom", "left"];
  var min3 = Math.min;
  var max3 = Math.max;
  var round3 = Math.round;
  var floor3 = Math.floor;
  var createCoords = (v) => ({
    x: v,
    y: v
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
  function clamp(start, value, end) {
    return max3(start, min3(value, end));
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
      x,
      y,
      width,
      height
    } = rect;
    return {
      width,
      height,
      top: y,
      left: x,
      right: x + width,
      bottom: y + height,
      x,
      y
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
  function detectOverflow(state, options) {
    return __async(this, null, function* () {
      var _await$platform$isEle;
      if (options === void 0) {
        options = {};
      }
      const {
        x,
        y,
        platform: platform2,
        rects,
        elements,
        strategy
      } = state;
      const {
        boundary = "clippingAncestors",
        rootBoundary = "viewport",
        elementContext = "floating",
        altBoundary = false,
        padding = 0
      } = evaluate(options, state);
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
        x,
        y,
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
  var computePosition = (reference, floating, config) => __async(null, null, function* () {
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
      x,
      y
    } = computeCoordsFromPlacement(rects, placement, rtl);
    let statefulPlacement = placement;
    let middlewareData = {};
    let resetCount = 0;
    for (let i = 0; i < validMiddleware.length; i++) {
      var _platform$detectOverf;
      const {
        name,
        fn
      } = validMiddleware[i];
      const {
        x: nextX,
        y: nextY,
        data,
        reset
      } = yield fn({
        x,
        y,
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
      x = nextX != null ? nextX : x;
      y = nextY != null ? nextY : y;
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
            x,
            y
          } = computeCoordsFromPlacement(rects, statefulPlacement, rtl));
        }
        i = -1;
      }
    }
    return {
      x,
      y,
      placement: statefulPlacement,
      strategy,
      middlewareData
    };
  });
  var arrow = (options) => ({
    name: "arrow",
    options,
    fn(state) {
      return __async(this, null, function* () {
        const {
          x,
          y,
          placement,
          rects,
          platform: platform2,
          elements,
          middlewareData
        } = state;
        const {
          element,
          padding = 0
        } = evaluate(options, state) || {};
        if (element == null) {
          return {};
        }
        const paddingObject = getPaddingObject(padding);
        const coords = {
          x,
          y
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
        const minPadding = min3(paddingObject[minProp], largestPossiblePadding);
        const maxPadding = min3(paddingObject[maxProp], largestPossiblePadding);
        const min$1 = minPadding;
        const max4 = clientSize - arrowDimensions[length] - maxPadding;
        const center = clientSize / 2 - arrowDimensions[length] / 2 + centerToReference;
        const offset3 = clamp(min$1, center, max4);
        const shouldAddOffset = !middlewareData.arrow && getAlignment(placement) != null && center !== offset3 && rects.reference[length] / 2 - (center < min$1 ? minPadding : maxPadding) - arrowDimensions[length] / 2 < 0;
        const alignmentOffset = shouldAddOffset ? center < min$1 ? center - min$1 : center - max4 : 0;
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
  var flip = function(options) {
    if (options === void 0) {
      options = {};
    }
    return {
      name: "flip",
      options,
      fn(state) {
        return __async(this, null, function* () {
          var _middlewareData$arrow, _middlewareData$flip;
          const {
            placement,
            middlewareData,
            rects,
            initialPlacement,
            platform: platform2,
            elements
          } = state;
          const _a2 = evaluate(options, state), {
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
          const overflow = yield platform2.detectOverflow(state, detectOverflowOptions);
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
              overflowsData.every((d) => getSideAxis(d.placement) === initialSideAxis ? d.overflows[0] > 0 : true)) {
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
            let resetPlacement = (_overflowsData$filter = overflowsData.filter((d) => d.overflows[0] <= 0).sort((a, b) => a.overflows[1] - b.overflows[1])[0]) == null ? void 0 : _overflowsData$filter.placement;
            if (!resetPlacement) {
              switch (fallbackStrategy) {
                case "bestFit": {
                  var _overflowsData$filter2;
                  const placement2 = (_overflowsData$filter2 = overflowsData.filter((d) => {
                    if (hasFallbackAxisSideDirection) {
                      const currentSideAxis = getSideAxis(d.placement);
                      return currentSideAxis === initialSideAxis || // Create a bias to the `y` side axis due to horizontal
                      // reading directions favoring greater width.
                      currentSideAxis === "y";
                    }
                    return true;
                  }).map((d) => [d.placement, d.overflows.filter((overflow2) => overflow2 > 0).reduce((acc, overflow2) => acc + overflow2, 0)]).sort((a, b) => a[1] - b[1])[0]) == null ? void 0 : _overflowsData$filter2[0];
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
      fn(state) {
        return __async(this, null, function* () {
          const {
            rects,
            platform: platform2
          } = state;
          const _a2 = evaluate(options, state), {
            strategy = "referenceHidden"
          } = _a2, detectOverflowOptions = __objRest(_a2, [
            "strategy"
          ]);
          switch (strategy) {
            case "referenceHidden": {
              const overflow = yield platform2.detectOverflow(state, __spreadProps(__spreadValues({}, detectOverflowOptions), {
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
              const overflow = yield platform2.detectOverflow(state, __spreadProps(__spreadValues({}, detectOverflowOptions), {
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
  var originSides = /* @__PURE__ */ new Set(["left", "top"]);
  function convertValueToCoords(state, options) {
    return __async(this, null, function* () {
      const {
        placement,
        platform: platform2,
        elements
      } = state;
      const rtl = yield platform2.isRTL == null ? void 0 : platform2.isRTL(elements.floating);
      const side = getSide(placement);
      const alignment = getAlignment(placement);
      const isVertical = getSideAxis(placement) === "y";
      const mainAxisMulti = originSides.has(side) ? -1 : 1;
      const crossAxisMulti = rtl && isVertical ? -1 : 1;
      const rawValue = evaluate(options, state);
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
  var offset = function(options) {
    if (options === void 0) {
      options = 0;
    }
    return {
      name: "offset",
      options,
      fn(state) {
        return __async(this, null, function* () {
          var _middlewareData$offse, _middlewareData$arrow;
          const {
            x,
            y,
            placement,
            middlewareData
          } = state;
          const diffCoords = yield convertValueToCoords(state, options);
          if (placement === ((_middlewareData$offse = middlewareData.offset) == null ? void 0 : _middlewareData$offse.placement) && (_middlewareData$arrow = middlewareData.arrow) != null && _middlewareData$arrow.alignmentOffset) {
            return {};
          }
          return {
            x: x + diffCoords.x,
            y: y + diffCoords.y,
            data: __spreadProps(__spreadValues({}, diffCoords), {
              placement
            })
          };
        });
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
      fn(state) {
        return __async(this, null, function* () {
          const {
            x,
            y,
            placement,
            platform: platform2
          } = state;
          const _a2 = evaluate(options, state), {
            mainAxis: checkMainAxis = true,
            crossAxis: checkCrossAxis = false,
            limiter = {
              fn: (_ref) => {
                let {
                  x: x2,
                  y: y2
                } = _ref;
                return {
                  x: x2,
                  y: y2
                };
              }
            }
          } = _a2, detectOverflowOptions = __objRest(_a2, [
            "mainAxis",
            "crossAxis",
            "limiter"
          ]);
          const coords = {
            x,
            y
          };
          const overflow = yield platform2.detectOverflow(state, detectOverflowOptions);
          const crossAxis = getSideAxis(getSide(placement));
          const mainAxis = getOppositeAxis(crossAxis);
          let mainAxisCoord = coords[mainAxis];
          let crossAxisCoord = coords[crossAxis];
          if (checkMainAxis) {
            const minSide = mainAxis === "y" ? "top" : "left";
            const maxSide = mainAxis === "y" ? "bottom" : "right";
            const min4 = mainAxisCoord + overflow[minSide];
            const max4 = mainAxisCoord - overflow[maxSide];
            mainAxisCoord = clamp(min4, mainAxisCoord, max4);
          }
          if (checkCrossAxis) {
            const minSide = crossAxis === "y" ? "top" : "left";
            const maxSide = crossAxis === "y" ? "bottom" : "right";
            const min4 = crossAxisCoord + overflow[minSide];
            const max4 = crossAxisCoord - overflow[maxSide];
            crossAxisCoord = clamp(min4, crossAxisCoord, max4);
          }
          const limitedCoords = limiter.fn(__spreadProps(__spreadValues({}, state), {
            [mainAxis]: mainAxisCoord,
            [crossAxis]: crossAxisCoord
          }));
          return __spreadProps(__spreadValues({}, limitedCoords), {
            data: {
              x: limitedCoords.x - x,
              y: limitedCoords.y - y,
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
  var limitShift = function(options) {
    if (options === void 0) {
      options = {};
    }
    return {
      options,
      fn(state) {
        const {
          x,
          y,
          placement,
          rects,
          middlewareData
        } = state;
        const {
          offset: offset3 = 0,
          mainAxis: checkMainAxis = true,
          crossAxis: checkCrossAxis = true
        } = evaluate(options, state);
        const coords = {
          x,
          y
        };
        const crossAxis = getSideAxis(placement);
        const mainAxis = getOppositeAxis(crossAxis);
        let mainAxisCoord = coords[mainAxis];
        let crossAxisCoord = coords[crossAxis];
        const rawOffset = evaluate(offset3, state);
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
  var size = function(options) {
    if (options === void 0) {
      options = {};
    }
    return {
      name: "size",
      options,
      fn(state) {
        return __async(this, null, function* () {
          var _state$middlewareData, _state$middlewareData2;
          const {
            placement,
            rects,
            platform: platform2,
            elements
          } = state;
          const _a2 = evaluate(options, state), {
            apply = () => {
            }
          } = _a2, detectOverflowOptions = __objRest(_a2, [
            "apply"
          ]);
          const overflow = yield platform2.detectOverflow(state, detectOverflowOptions);
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
          const overflowAvailableHeight = min3(height - overflow[heightSide], maximumClippingHeight);
          const overflowAvailableWidth = min3(width - overflow[widthSide], maximumClippingWidth);
          const noShift = !state.middlewareData.shift;
          let availableHeight = overflowAvailableHeight;
          let availableWidth = overflowAvailableWidth;
          if ((_state$middlewareData = state.middlewareData.shift) != null && _state$middlewareData.enabled.x) {
            availableWidth = maximumClippingWidth;
          }
          if ((_state$middlewareData2 = state.middlewareData.shift) != null && _state$middlewareData2.enabled.y) {
            availableHeight = maximumClippingHeight;
          }
          if (noShift && !alignment) {
            const xMin = max3(overflow.left, 0);
            const xMax = max3(overflow.right, 0);
            const yMin = max3(overflow.top, 0);
            const yMax = max3(overflow.bottom, 0);
            if (isYAxis) {
              availableWidth = width - 2 * (xMin !== 0 || xMax !== 0 ? xMin + xMax : max3(overflow.left, overflow.right));
            } else {
              availableHeight = height - 2 * (yMin !== 0 || yMax !== 0 ? yMin + yMax : max3(overflow.top, overflow.bottom));
            }
          }
          yield apply(__spreadProps(__spreadValues({}, state), {
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

  // ../node_modules/.pnpm/@floating-ui+utils@0.2.10/node_modules/@floating-ui/utils/dist/floating-ui.utils.dom.mjs
  function hasWindow() {
    return typeof window !== "undefined";
  }
  function getNodeName2(node) {
    if (isNode3(node)) {
      return (node.nodeName || "").toLowerCase();
    }
    return "#document";
  }
  function getWindow3(node) {
    var _node$ownerDocument;
    return (node == null || (_node$ownerDocument = node.ownerDocument) == null ? void 0 : _node$ownerDocument.defaultView) || window;
  }
  function getDocumentElement2(node) {
    var _ref;
    return (_ref = (isNode3(node) ? node.ownerDocument : node.document) || window.document) == null ? void 0 : _ref.documentElement;
  }
  function isNode3(value) {
    if (!hasWindow()) {
      return false;
    }
    return value instanceof Node || value instanceof getWindow3(value).Node;
  }
  function isElement2(value) {
    if (!hasWindow()) {
      return false;
    }
    return value instanceof Element || value instanceof getWindow3(value).Element;
  }
  function isHTMLElement3(value) {
    if (!hasWindow()) {
      return false;
    }
    return value instanceof HTMLElement || value instanceof getWindow3(value).HTMLElement;
  }
  function isShadowRoot3(value) {
    if (!hasWindow() || typeof ShadowRoot === "undefined") {
      return false;
    }
    return value instanceof ShadowRoot || value instanceof getWindow3(value).ShadowRoot;
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
    while (isHTMLElement3(currentNode) && !isLastTraversableNode(currentNode)) {
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
    return getWindow3(element).getComputedStyle(element);
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
      isShadowRoot3(node) && node.host || // Fallback.
      getDocumentElement2(node)
    );
    return isShadowRoot3(result) ? result.host : result;
  }
  function getNearestOverflowAncestor2(node) {
    const parentNode = getParentNode2(node);
    if (isLastTraversableNode(parentNode)) {
      return node.ownerDocument ? node.ownerDocument.body : node.body;
    }
    if (isHTMLElement3(parentNode) && isOverflowElement2(parentNode)) {
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
    const win = getWindow3(scrollableAncestor);
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
    const hasOffset = isHTMLElement3(element);
    const offsetWidth = hasOffset ? element.offsetWidth : width;
    const offsetHeight = hasOffset ? element.offsetHeight : height;
    const shouldFallback = round3(width) !== offsetWidth || round3(height) !== offsetHeight;
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
    if (!isHTMLElement3(domElement)) {
      return createCoords(1);
    }
    const rect = domElement.getBoundingClientRect();
    const {
      width,
      height,
      $
    } = getCssDimensions(domElement);
    let x = ($ ? round3(rect.width) : rect.width) / width;
    let y = ($ ? round3(rect.height) : rect.height) / height;
    if (!x || !Number.isFinite(x)) {
      x = 1;
    }
    if (!y || !Number.isFinite(y)) {
      y = 1;
    }
    return {
      x,
      y
    };
  }
  var noOffsets = /* @__PURE__ */ createCoords(0);
  function getVisualOffsets(element) {
    const win = getWindow3(element);
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
    if (!floatingOffsetParent || isFixed && floatingOffsetParent !== getWindow3(element)) {
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
    let x = (clientRect.left + visualOffsets.x) / scale.x;
    let y = (clientRect.top + visualOffsets.y) / scale.y;
    let width = clientRect.width / scale.x;
    let height = clientRect.height / scale.y;
    if (domElement) {
      const win = getWindow3(domElement);
      const offsetWin = offsetParent && isElement2(offsetParent) ? getWindow3(offsetParent) : offsetParent;
      let currentWin = win;
      let currentIFrame = getFrameElement(currentWin);
      while (currentIFrame && offsetParent && offsetWin !== currentWin) {
        const iframeScale = getScale(currentIFrame);
        const iframeRect = currentIFrame.getBoundingClientRect();
        const css = getComputedStyle3(currentIFrame);
        const left = iframeRect.left + (currentIFrame.clientLeft + parseFloat(css.paddingLeft)) * iframeScale.x;
        const top = iframeRect.top + (currentIFrame.clientTop + parseFloat(css.paddingTop)) * iframeScale.y;
        x *= iframeScale.x;
        y *= iframeScale.y;
        width *= iframeScale.x;
        height *= iframeScale.y;
        x += left;
        y += top;
        currentWin = getWindow3(currentIFrame);
        currentIFrame = getFrameElement(currentWin);
      }
    }
    return rectToClientRect({
      width,
      height,
      x,
      y
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
    const x = htmlRect.left + scroll.scrollLeft - getWindowScrollBarX(documentElement, htmlRect);
    const y = htmlRect.top + scroll.scrollTop;
    return {
      x,
      y
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
    const isOffsetParentAnElement = isHTMLElement3(offsetParent);
    if (isOffsetParentAnElement || !isOffsetParentAnElement && !isFixed) {
      if (getNodeName2(offsetParent) !== "body" || isOverflowElement2(documentElement)) {
        scroll = getNodeScroll(offsetParent);
      }
      if (isHTMLElement3(offsetParent)) {
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
    const width = max3(html.scrollWidth, html.clientWidth, body.scrollWidth, body.clientWidth);
    const height = max3(html.scrollHeight, html.clientHeight, body.scrollHeight, body.clientHeight);
    let x = -scroll.scrollLeft + getWindowScrollBarX(element);
    const y = -scroll.scrollTop;
    if (getComputedStyle3(body).direction === "rtl") {
      x += max3(html.clientWidth, body.clientWidth) - width;
    }
    return {
      width,
      height,
      x,
      y
    };
  }
  var SCROLLBAR_MAX = 25;
  function getViewportRect(element, strategy) {
    const win = getWindow3(element);
    const html = getDocumentElement2(element);
    const visualViewport = win.visualViewport;
    let width = html.clientWidth;
    let height = html.clientHeight;
    let x = 0;
    let y = 0;
    if (visualViewport) {
      width = visualViewport.width;
      height = visualViewport.height;
      const visualViewportBased = isWebKit();
      if (!visualViewportBased || visualViewportBased && strategy === "fixed") {
        x = visualViewport.offsetLeft;
        y = visualViewport.offsetTop;
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
      x,
      y
    };
  }
  var absoluteOrFixed = /* @__PURE__ */ new Set(["absolute", "fixed"]);
  function getInnerBoundingClientRect(element, strategy) {
    const clientRect = getBoundingClientRect(element, true, strategy === "fixed");
    const top = clientRect.top + element.clientTop;
    const left = clientRect.left + element.clientLeft;
    const scale = isHTMLElement3(element) ? getScale(element) : createCoords(1);
    const width = element.clientWidth * scale.x;
    const height = element.clientHeight * scale.y;
    const x = left * scale.x;
    const y = top * scale.y;
    return {
      width,
      height,
      x,
      y
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
      accRect.top = max3(rect.top, accRect.top);
      accRect.right = min3(rect.right, accRect.right);
      accRect.bottom = min3(rect.bottom, accRect.bottom);
      accRect.left = max3(rect.left, accRect.left);
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
    const isOffsetParentAnElement = isHTMLElement3(offsetParent);
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
    const x = rect.left + scroll.scrollLeft - offsets.x - htmlOffset.x;
    const y = rect.top + scroll.scrollTop - offsets.y - htmlOffset.y;
    return {
      x,
      y,
      width: rect.width,
      height: rect.height
    };
  }
  function isStaticPositioned(element) {
    return getComputedStyle3(element).position === "static";
  }
  function getTrueOffsetParent(element, polyfill) {
    if (!isHTMLElement3(element) || getComputedStyle3(element).position === "fixed") {
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
    const win = getWindow3(element);
    if (isTopLayer(element)) {
      return win;
    }
    if (!isHTMLElement3(element)) {
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
  var getElementRects = function(data) {
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
  function rectsAreEqual(a, b) {
    return a.x === b.x && a.y === b.y && a.width === b.width && a.height === b.height;
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
      const insetTop = floor3(top);
      const insetRight = floor3(root.clientWidth - (left + width));
      const insetBottom = floor3(root.clientHeight - (top + height));
      const insetLeft = floor3(left);
      const rootMargin = -insetTop + "px " + -insetRight + "px " + -insetBottom + "px " + -insetLeft + "px";
      const options = {
        rootMargin,
        threshold: max3(0, min3(1, threshold)) || 1
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
  var offset2 = offset;
  var shift2 = shift;
  var flip2 = flip;
  var size2 = size;
  var hide2 = hide;
  var arrow2 = arrow;
  var limitShift2 = limitShift;
  var computePosition2 = (reference, floating, options) => {
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

  // ../node_modules/.pnpm/@zag-js+popper@1.33.1/node_modules/@zag-js/popper/dist/index.mjs
  function createDOMRect(x = 0, y = 0, width = 0, height = 0) {
    if (typeof DOMRect === "function") {
      return new DOMRect(x, y, width, height);
    }
    const rect = {
      x,
      y,
      width,
      height,
      top: y,
      right: x + width,
      bottom: y + height,
      left: x
    };
    return __spreadProps(__spreadValues({}, rect), { toJSON: () => rect });
  }
  function getDOMRect(anchorRect) {
    if (!anchorRect) return createDOMRect();
    const { x, y, width, height } = anchorRect;
    return createDOMRect(x, y, width, height);
  }
  function getAnchorElement(anchorElement, getAnchorRect) {
    return {
      contextElement: isHTMLElement2(anchorElement) ? anchorElement : anchorElement == null ? void 0 : anchorElement.contextElement,
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
      fn(state) {
        var _a, _b, _c, _d, _e;
        const { elements, middlewareData, placement, rects, y } = state;
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
        const overlapTransformOrigin = `${transformX}px ${rects.reference.y + halfAnchorHeight - y}px`;
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
        const { x, y } = middlewareData.arrow;
        const dir = placement.split("-")[0];
        Object.assign(arrowEl.style, {
          left: x != null ? `${x}px` : "",
          top: y != null ? `${y}px` : "",
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
      return compact2({
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
      const win = getWindow2(floating);
      const x = roundByDpr(win, pos.x);
      const y = roundByDpr(win, pos.y);
      floating.style.setProperty("--x", `${x}px`);
      floating.style.setProperty("--y", `${y}px`);
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
    const cancelAutoUpdate = options.listeners ? autoUpdate(reference, floating, update, autoUpdateOptions) : noop3;
    update();
    return () => {
      cancelAutoUpdate == null ? void 0 : cancelAutoUpdate();
      onPositioned == null ? void 0 : onPositioned({ placed: false });
    };
  }
  function getPlacement(referenceOrFn, floatingOrFn, opts = {}) {
    const _a = opts, { defer } = _a, options = __objRest(_a, ["defer"]);
    const func = defer ? raf2 : (v) => v();
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

  // ../node_modules/.pnpm/@zag-js+interact-outside@1.33.1/node_modules/@zag-js/interact-outside/dist/index.mjs
  function getWindowFrames(win) {
    const frames = {
      each(cb) {
        var _a;
        for (let i = 0; i < ((_a = win.frames) == null ? void 0 : _a.length); i += 1) {
          const frame = win.frames[i];
          if (frame) cb(frame);
        }
      },
      addEventListener(event, listener, options) {
        frames.each((frame) => {
          try {
            frame.document.addEventListener(event, listener, options);
          } catch (e) {
          }
        });
        return () => {
          try {
            frames.removeEventListener(event, listener, options);
          } catch (e) {
          }
        };
      },
      removeEventListener(event, listener, options) {
        frames.each((frame) => {
          try {
            frame.document.removeEventListener(event, listener, options);
          } catch (e) {
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
        } catch (e) {
        }
        return () => {
          try {
            parent == null ? void 0 : parent.removeEventListener(event, listener, options);
          } catch (e) {
          }
        };
      },
      removeEventListener: (event, listener, options) => {
        try {
          parent == null ? void 0 : parent.removeEventListener(event, listener, options);
        } catch (e) {
        }
      }
    };
  }
  var POINTER_OUTSIDE_EVENT = "pointerdown.outside";
  var FOCUS_OUTSIDE_EVENT = "focus.outside";
  function isComposedPathFocusable(composedPath) {
    for (const node of composedPath) {
      if (isHTMLElement2(node) && isFocusable(node)) return true;
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
    const doc = getDocument2(node);
    const win = getWindow2(node);
    const frames = getWindowFrames(win);
    const parentWin = getParentWindow(win);
    function isEventOutside(event, target) {
      if (!isHTMLElement2(target)) return false;
      if (!target.isConnected) return false;
      if (contains2(node, target)) return false;
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
    const isInShadowRoot = isShadowRoot2(node == null ? void 0 : node.getRootNode());
    function onPointerDown(event) {
      function handler(clickEvent) {
        var _a, _b;
        const func = defer && !isTouchDevice() ? raf2 : (v) => v();
        const evt = clickEvent != null ? clickEvent : event;
        const composedPath = (_b = (_a = evt == null ? void 0 : evt.composedPath) == null ? void 0 : _a.call(evt)) != null ? _b : [evt == null ? void 0 : evt.target];
        func(() => {
          const target = isInShadowRoot ? composedPath[0] : getEventTarget2(event);
          if (!node || !isEventOutside(event, target)) return;
          if (onPointerDownOutside || onInteractOutside) {
            const handler2 = callAll(onPointerDownOutside, onInteractOutside);
            node.addEventListener(POINTER_OUTSIDE_EVENT, handler2, { once: true });
          }
          fireCustomEvent2(node, POINTER_OUTSIDE_EVENT, {
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
        pointerdownCleanups.add(addDomEvent2(doc, "click", handler, { once: true }));
        pointerdownCleanups.add(parentWin.addEventListener("click", handler, { once: true }));
        pointerdownCleanups.add(frames.addEventListener("click", handler, { once: true }));
      } else {
        handler();
      }
    }
    const cleanups = /* @__PURE__ */ new Set();
    const timer = setTimeout(() => {
      cleanups.add(addDomEvent2(doc, "pointerdown", onPointerDown, true));
      cleanups.add(parentWin.addEventListener("pointerdown", onPointerDown, true));
      cleanups.add(frames.addEventListener("pointerdown", onPointerDown, true));
    }, 0);
    function onFocusin(event) {
      const func = defer ? raf2 : (v) => v();
      func(() => {
        var _a, _b;
        const composedPath = (_b = (_a = event == null ? void 0 : event.composedPath) == null ? void 0 : _a.call(event)) != null ? _b : [event == null ? void 0 : event.target];
        const target = isInShadowRoot ? composedPath[0] : getEventTarget2(event);
        if (!node || !isEventOutside(event, target)) return;
        if (onFocusOutside || onInteractOutside) {
          const handler = callAll(onFocusOutside, onInteractOutside);
          node.addEventListener(FOCUS_OUTSIDE_EVENT, handler, { once: true });
        }
        fireCustomEvent2(node, FOCUS_OUTSIDE_EVENT, {
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
      cleanups.add(addDomEvent2(doc, "focusin", onFocusin, true));
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
    const func = defer ? raf2 : (v) => v();
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
  function fireCustomEvent2(el, type, init) {
    const win = el.ownerDocument.defaultView || window;
    const event = new win.CustomEvent(type, init);
    return el.dispatchEvent(event);
  }

  // ../node_modules/.pnpm/@zag-js+dismissable@1.33.1/node_modules/@zag-js/dismissable/dist/index.mjs
  function trackEscapeKeydown(node, fn) {
    const handleKeyDown = (event) => {
      if (event.key !== "Escape") return;
      if (event.isComposing) return;
      fn == null ? void 0 : fn(event);
    };
    return addDomEvent2(getDocument2(node), "keydown", handleKeyDown, { capture: true });
  }
  var LAYER_REQUEST_DISMISS_EVENT2 = "layer:request-dismiss";
  var layerStack2 = {
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
      const inNested = this.getNestedLayers(node).some((layer) => contains2(layer.node, target));
      if (inNested) return true;
      if (this.recentlyRemoved.size > 0) return true;
      return false;
    },
    isInBranch(target) {
      return Array.from(this.branches).some((branch) => contains2(branch, target));
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
        _layers.forEach((layer) => layerStack2.dismiss(layer.node, node));
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
      addListenerOnce2(node, LAYER_REQUEST_DISMISS_EVENT2, (event) => {
        var _a;
        (_a = layer.requestDismiss) == null ? void 0 : _a.call(layer, event);
        if (!event.defaultPrevented) {
          layer == null ? void 0 : layer.dismiss();
        }
      });
      fireCustomEvent3(node, LAYER_REQUEST_DISMISS_EVENT2, {
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
  function fireCustomEvent3(el, type, detail) {
    const win = el.ownerDocument.defaultView || window;
    const event = new win.CustomEvent(type, { cancelable: true, bubbles: true, detail });
    return el.dispatchEvent(event);
  }
  function addListenerOnce2(el, type, callback) {
    el.addEventListener(type, callback, { once: true });
  }
  var originalBodyPointerEvents;
  function assignPointerEventToLayers() {
    layerStack2.layers.forEach(({ node }) => {
      node.style.pointerEvents = layerStack2.isBelowPointerBlockingLayer(node) ? "none" : "auto";
    });
  }
  function clearPointerEvent(node) {
    node.style.pointerEvents = "";
  }
  function disablePointerEventsOutside(node, persistentElements) {
    const doc = getDocument2(node);
    const cleanups = [];
    if (layerStack2.hasPointerBlockingLayer() && !doc.body.hasAttribute("data-inert")) {
      originalBodyPointerEvents = document.body.style.pointerEvents;
      queueMicrotask(() => {
        doc.body.style.pointerEvents = "none";
        doc.body.setAttribute("data-inert", "");
      });
    }
    persistentElements == null ? void 0 : persistentElements.forEach((el) => {
      const [promise, abort] = waitForElement2(
        () => {
          const node2 = el();
          return isHTMLElement2(node2) ? node2 : null;
        },
        { timeout: 1e3 }
      );
      promise.then((el2) => cleanups.push(setStyle2(el2, { pointerEvents: "auto" })));
      cleanups.push(abort);
    });
    return () => {
      if (layerStack2.hasPointerBlockingLayer()) return;
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
      warn2("[@zag-js/dismissable] node is `null` or `undefined`");
      return;
    }
    if (!node) {
      return;
    }
    const { onDismiss, onRequestDismiss, pointerBlocking, exclude: excludeContainers, debug, type = "dialog" } = options;
    const layer = { dismiss: onDismiss, node, type, pointerBlocking, requestDismiss: onRequestDismiss };
    layerStack2.add(layer);
    assignPointerEventToLayers();
    function onPointerDownOutside(event) {
      var _a, _b;
      const target = getEventTarget2(event.detail.originalEvent);
      if (layerStack2.isBelowPointerBlockingLayer(node) || layerStack2.isInBranch(target)) return;
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
      const target = getEventTarget2(event.detail.originalEvent);
      if (layerStack2.isInBranch(target)) return;
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
      if (!layerStack2.isTopMost(node)) return;
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
      const persistentElements = (_a = options.persistentElements) == null ? void 0 : _a.map((fn) => fn()).filter(isHTMLElement2);
      if (persistentElements) _containers.push(...persistentElements);
      return _containers.some((node2) => contains2(node2, target)) || layerStack2.isInNestedLayer(node, target);
    }
    const cleanups = [
      pointerBlocking ? disablePointerEventsOutside(node, options.persistentElements) : void 0,
      trackEscapeKeydown(node, onEscapeKeyDown),
      trackInteractOutside(node, { exclude, onFocusOutside, onPointerDownOutside, defer: options.defer })
    ];
    return () => {
      layerStack2.remove(node);
      assignPointerEventToLayers();
      clearPointerEvent(node);
      cleanups.forEach((fn) => fn == null ? void 0 : fn());
    };
  }
  function trackDismissableElement(nodeOrFn, options) {
    const { defer } = options;
    const func = defer ? raf2 : (v) => v();
    const cleanups = [];
    cleanups.push(
      func(() => {
        const node = isFunction2(nodeOrFn) ? nodeOrFn() : nodeOrFn;
        cleanups.push(trackDismissableElementImpl(node, options));
      })
    );
    return () => {
      cleanups.forEach((fn) => fn == null ? void 0 : fn());
    };
  }

  // ../node_modules/.pnpm/@zag-js+combobox@1.33.1/node_modules/@zag-js/combobox/dist/index.mjs
  var anatomy5 = createAnatomy2("combobox").parts(
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
  var parts5 = anatomy5.build();
  var collection = (options) => {
    return new ListCollection(options);
  };
  collection.empty = () => {
    return new ListCollection({ items: [] });
  };
  var getRootId5 = (ctx) => {
    var _a, _b;
    return (_b = (_a = ctx.ids) == null ? void 0 : _a.root) != null ? _b : `combobox:${ctx.id}`;
  };
  var getLabelId2 = (ctx) => {
    var _a, _b;
    return (_b = (_a = ctx.ids) == null ? void 0 : _a.label) != null ? _b : `combobox:${ctx.id}:label`;
  };
  var getControlId2 = (ctx) => {
    var _a, _b;
    return (_b = (_a = ctx.ids) == null ? void 0 : _a.control) != null ? _b : `combobox:${ctx.id}:control`;
  };
  var getInputId = (ctx) => {
    var _a, _b;
    return (_b = (_a = ctx.ids) == null ? void 0 : _a.input) != null ? _b : `combobox:${ctx.id}:input`;
  };
  var getContentId = (ctx) => {
    var _a, _b;
    return (_b = (_a = ctx.ids) == null ? void 0 : _a.content) != null ? _b : `combobox:${ctx.id}:content`;
  };
  var getPositionerId = (ctx) => {
    var _a, _b;
    return (_b = (_a = ctx.ids) == null ? void 0 : _a.positioner) != null ? _b : `combobox:${ctx.id}:popper`;
  };
  var getTriggerId = (ctx) => {
    var _a, _b;
    return (_b = (_a = ctx.ids) == null ? void 0 : _a.trigger) != null ? _b : `combobox:${ctx.id}:toggle-btn`;
  };
  var getClearTriggerId = (ctx) => {
    var _a, _b;
    return (_b = (_a = ctx.ids) == null ? void 0 : _a.clearTrigger) != null ? _b : `combobox:${ctx.id}:clear-btn`;
  };
  var getItemGroupId = (ctx, id) => {
    var _a, _b, _c;
    return (_c = (_b = (_a = ctx.ids) == null ? void 0 : _a.itemGroup) == null ? void 0 : _b.call(_a, id)) != null ? _c : `combobox:${ctx.id}:optgroup:${id}`;
  };
  var getItemGroupLabelId = (ctx, id) => {
    var _a, _b, _c;
    return (_c = (_b = (_a = ctx.ids) == null ? void 0 : _a.itemGroupLabel) == null ? void 0 : _b.call(_a, id)) != null ? _c : `combobox:${ctx.id}:optgroup-label:${id}`;
  };
  var getItemId3 = (ctx, id) => {
    var _a, _b, _c;
    return (_c = (_b = (_a = ctx.ids) == null ? void 0 : _a.item) == null ? void 0 : _b.call(_a, id)) != null ? _c : `combobox:${ctx.id}:option:${id}`;
  };
  var getContentEl = (ctx) => ctx.getById(getContentId(ctx));
  var getInputEl = (ctx) => ctx.getById(getInputId(ctx));
  var getPositionerEl = (ctx) => ctx.getById(getPositionerId(ctx));
  var getControlEl = (ctx) => ctx.getById(getControlId2(ctx));
  var getTriggerEl = (ctx) => ctx.getById(getTriggerId(ctx));
  var getClearTriggerEl = (ctx) => ctx.getById(getClearTriggerId(ctx));
  var getItemEl = (ctx, value) => {
    if (value == null) return null;
    const selector = `[role=option][data-value="${CSS.escape(value)}"]`;
    return query(getContentEl(ctx), selector);
  };
  var focusInputEl = (ctx) => {
    const inputEl = getInputEl(ctx);
    if (ctx.isActiveElement(inputEl)) return;
    inputEl == null ? void 0 : inputEl.focus({ preventScroll: true });
  };
  var focusTriggerEl = (ctx) => {
    const triggerEl = getTriggerEl(ctx);
    if (ctx.isActiveElement(triggerEl)) return;
    triggerEl == null ? void 0 : triggerEl.focus({ preventScroll: true });
  };
  function connect5(service, normalize) {
    const { context, prop, state, send, scope, computed, event } = service;
    const translations = prop("translations");
    const collection2 = prop("collection");
    const disabled = !!prop("disabled");
    const interactive = computed("isInteractive");
    const invalid = !!prop("invalid");
    const required = !!prop("required");
    const readOnly = !!prop("readOnly");
    const open = state.hasTag("open");
    const focused = state.hasTag("focused");
    const composite = prop("composite");
    const highlightedValue = context.get("highlightedValue");
    const popperStyles = getPlacementStyles(__spreadProps(__spreadValues({}, prop("positioning")), {
      placement: context.get("currentPlacement")
    }));
    function getItemState(props22) {
      const disabled2 = collection2.getItemDisabled(props22.item);
      const value = collection2.getItemValue(props22.item);
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
        (_a = getInputEl(scope)) == null ? void 0 : _a.focus();
      },
      setOpen(nextOpen, reason = "script") {
        const open2 = state.hasTag("open");
        if (open2 === nextOpen) return;
        send({ type: nextOpen ? "OPEN" : "CLOSE", src: reason });
      },
      getRootProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts5.root.attrs), {
          dir: prop("dir"),
          id: getRootId5(scope),
          "data-invalid": dataAttr2(invalid),
          "data-readonly": dataAttr2(readOnly)
        }));
      },
      getLabelProps() {
        return normalize.label(__spreadProps(__spreadValues({}, parts5.label.attrs), {
          dir: prop("dir"),
          htmlFor: getInputId(scope),
          id: getLabelId2(scope),
          "data-readonly": dataAttr2(readOnly),
          "data-disabled": dataAttr2(disabled),
          "data-invalid": dataAttr2(invalid),
          "data-required": dataAttr2(required),
          "data-focus": dataAttr2(focused),
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
          "data-focus": dataAttr2(focused),
          "data-disabled": dataAttr2(disabled),
          "data-invalid": dataAttr2(invalid)
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
          "data-invalid": dataAttr2(invalid),
          "data-autofocus": dataAttr2(prop("autoFocus")),
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
          "aria-controls": getContentId(scope),
          "aria-expanded": open,
          "data-state": open ? "open" : "closed",
          "aria-activedescendant": highlightedValue ? getItemId3(scope, highlightedValue) : void 0,
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
            const isModifierKey = event2.ctrlKey || event2.metaKey || event2.shiftKey;
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
                if (isModifierKey) return;
                send({ type: "INPUT.HOME", keypress });
                if (open) {
                  event3.preventDefault();
                }
              },
              End(event3) {
                if (isModifierKey) return;
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
            const key = getEventKey2(event2, { dir: prop("dir") });
            const exec = keymap[key];
            exec == null ? void 0 : exec(event2);
          }
        }));
      },
      getTriggerProps(props22 = {}) {
        return normalize.button(__spreadProps(__spreadValues({}, parts5.trigger.attrs), {
          dir: prop("dir"),
          id: getTriggerId(scope),
          "aria-haspopup": composite ? "listbox" : "dialog",
          type: "button",
          tabIndex: props22.focusable ? void 0 : -1,
          "aria-label": translations.triggerLabel,
          "aria-expanded": open,
          "data-state": open ? "open" : "closed",
          "aria-controls": open ? getContentId(scope) : void 0,
          disabled,
          "data-invalid": dataAttr2(invalid),
          "data-focusable": dataAttr2(props22.focusable),
          "data-readonly": dataAttr2(readOnly),
          "data-disabled": dataAttr2(disabled),
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
              (_a = getInputEl(scope)) == null ? void 0 : _a.focus({ preventScroll: true });
            });
          },
          onKeyDown(event2) {
            if (event2.defaultPrevented) return;
            if (composite) return;
            const keyMap3 = {
              ArrowDown() {
                send({ type: "INPUT.ARROW_DOWN", src: "arrow-key" });
              },
              ArrowUp() {
                send({ type: "INPUT.ARROW_UP", src: "arrow-key" });
              }
            };
            const key = getEventKey2(event2, { dir: prop("dir") });
            const exec = keyMap3[key];
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
          id: getContentId(scope),
          role: !composite ? "dialog" : "listbox",
          tabIndex: -1,
          hidden: !open,
          "data-state": open ? "open" : "closed",
          "data-placement": context.get("currentPlacement"),
          "aria-labelledby": getLabelId2(scope),
          "aria-multiselectable": prop("multiple") && composite ? true : void 0,
          "data-empty": dataAttr2(collection2.size === 0),
          onPointerDown(event2) {
            if (!isLeftClick(event2)) return;
            event2.preventDefault();
          }
        }));
      },
      getListProps() {
        return normalize.element(__spreadProps(__spreadValues({}, parts5.list.attrs), {
          role: !composite ? "listbox" : void 0,
          "data-empty": dataAttr2(collection2.size === 0),
          "aria-labelledby": getLabelId2(scope),
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
          "data-invalid": dataAttr2(invalid),
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
        }));
      },
      getItemState,
      getItemProps(props22) {
        const itemState = getItemState(props22);
        const value = itemState.value;
        return normalize.element(__spreadProps(__spreadValues({}, parts5.item.attrs), {
          dir: prop("dir"),
          id: getItemId3(scope, value),
          role: "option",
          tabIndex: -1,
          "data-highlighted": dataAttr2(itemState.highlighted),
          "data-state": itemState.selected ? "checked" : "unchecked",
          "aria-selected": ariaAttr(itemState.highlighted),
          "aria-disabled": ariaAttr(itemState.disabled),
          "data-disabled": dataAttr2(itemState.disabled),
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
            const mouseMoved = prev == null ? void 0 : prev.type.includes("POINTER");
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
          "data-disabled": dataAttr2(itemState.disabled),
          "data-highlighted": dataAttr2(itemState.highlighted)
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
          "data-empty": dataAttr2(collection2.size === 0),
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
  var { guards: guards2, createMachine: createMachine4, choose } = setup2();
  var { and: and4, not: not5 } = guards2;
  var machine5 = createMachine4({
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
          isEqual: isEqual3,
          hash(value) {
            return value.join(",");
          },
          onChange(value) {
            var _a;
            const context = getContext();
            const prevSelectedItems = context.get("selectedItems");
            const collection2 = prop("collection");
            const nextItems = value.map((v) => {
              const item = prevSelectedItems.find((item2) => collection2.getItemValue(item2) === v);
              return item || collection2.find(v);
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
            inputValue = match(prop("selectionBehavior"), {
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
              guard: and4("isOpenControlled", "openOnChange"),
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
            guard: and4("isCustomValue", not5("allowCustomValue")),
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
              guard: and4("isOpenControlled", "autoComplete"),
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
              guard: and4("autoComplete", "isLastItemHighlighted"),
              actions: ["clearHighlightedValue", "scrollContentToTop"]
            },
            {
              actions: ["highlightNextItem"]
            }
          ],
          "INPUT.ARROW_UP": [
            {
              guard: and4("autoComplete", "isFirstItemHighlighted"),
              actions: ["clearHighlightedValue"]
            },
            {
              actions: ["highlightPrevItem"]
            }
          ],
          "INPUT.ENTER": [
            // == group 1 ==
            {
              guard: and4("isOpenControlled", "isCustomValue", not5("hasHighlightedItem"), not5("allowCustomValue")),
              actions: ["revertInputValue", "invokeOnClose"]
            },
            {
              guard: and4("isCustomValue", not5("hasHighlightedItem"), not5("allowCustomValue")),
              target: "focused",
              actions: ["revertInputValue", "invokeOnClose"]
            },
            // == group 2 ==
            {
              guard: and4("isOpenControlled", "closeOnSelect"),
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
              guard: and4("isOpenControlled", "closeOnSelect"),
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
              guard: and4("isOpenControlled", "autoComplete"),
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
              guard: and4("isOpenControlled", "isCustomValue", not5("allowCustomValue")),
              actions: ["revertInputValue", "invokeOnClose"]
            },
            {
              guard: and4("isCustomValue", not5("allowCustomValue")),
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
              guard: and4("isHighlightedItemRemoved", "hasCollectionItems", "autoHighlight"),
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
              guard: and4("isOpenControlled", "isCustomValue", not5("hasHighlightedItem"), not5("allowCustomValue")),
              actions: ["revertInputValue", "invokeOnClose"]
            },
            {
              guard: and4("isCustomValue", not5("hasHighlightedItem"), not5("allowCustomValue")),
              target: "focused",
              actions: ["revertInputValue", "invokeOnClose"]
            },
            // == group 2 ==
            {
              guard: and4("isOpenControlled", "closeOnSelect"),
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
              guard: and4("isOpenControlled", "isCustomValue", not5("allowCustomValue")),
              actions: ["revertInputValue", "invokeOnClose"]
            },
            {
              guard: and4("isCustomValue", not5("allowCustomValue")),
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
              guard: and4("isOpenControlled", "closeOnSelect"),
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
          const contentEl = () => getContentEl(scope);
          return trackDismissableElement(contentEl, {
            type: "listbox",
            defer: true,
            exclude: () => [getInputEl(scope), getTriggerEl(scope), getClearTriggerEl(scope)],
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
          const inputEl = getInputEl(scope);
          let cleanups = [];
          const exec = (immediate) => {
            const pointer = event.current().type.includes("POINTER");
            const highlightedValue = context.get("highlightedValue");
            if (pointer || !highlightedValue) return;
            const contentEl = getContentEl(scope);
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
            const raf_cleanup = raf2(() => {
              scrollIntoView(itemEl, { rootEl: contentEl, block: "nearest" });
            });
            cleanups.push(raf_cleanup);
          };
          const rafCleanup = raf2(() => exec(true));
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
          const collection2 = prop("collection");
          const highlightedValue = context.get("highlightedValue");
          if (!highlightedValue || !collection2.has(highlightedValue)) return;
          const nextValue = prop("multiple") ? addOrRemove(context.get("value"), highlightedValue) : [highlightedValue];
          (_a = prop("onSelect")) == null ? void 0 : _a({ value: nextValue, itemValue: highlightedValue });
          context.set("value", nextValue);
          const inputValue = match(prop("selectionBehavior"), {
            preserve: context.get("inputValue"),
            replace: collection2.stringifyMany(nextValue),
            clear: ""
          });
          context.set("inputValue", inputValue);
        },
        scrollToHighlightedItem({ context, prop, scope }) {
          nextTick(() => {
            const highlightedValue = context.get("highlightedValue");
            if (highlightedValue == null) return;
            const itemEl = getItemEl(scope, highlightedValue);
            const contentEl = getContentEl(scope);
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
            const inputValue = match(prop("selectionBehavior"), {
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
            const nextValue = remove2(context.get("value"), event.value);
            context.set("value", nextValue);
            const inputValue = match(prop("selectionBehavior"), {
              preserve: context.get("inputValue"),
              replace: prop("collection").stringifyMany(nextValue),
              clear: ""
            });
            context.set("inputValue", inputValue);
          });
        },
        setInitialFocus({ scope }) {
          raf2(() => {
            focusInputEl(scope);
          });
        },
        setFinalFocus({ scope }) {
          raf2(() => {
            const triggerEl = getTriggerEl(scope);
            if ((triggerEl == null ? void 0 : triggerEl.dataset.focusable) == null) {
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
          const inputValue = match(selectionBehavior, {
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
            const inputValue = match(prop("selectionBehavior"), {
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
            const inputValue = match(prop("selectionBehavior"), {
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
            const contentEl = getContentEl(scope);
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
          const exec = getContentEl(scope) ? queueMicrotask : raf2;
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
          const exec = getContentEl(scope) ? queueMicrotask : raf2;
          exec(() => {
            const value = prop("collection").lastValue;
            if (value) context.set("highlightedValue", value);
          });
        },
        highlightNextItem({ context, prop }) {
          let value = null;
          const highlightedValue = context.get("highlightedValue");
          const collection2 = prop("collection");
          if (highlightedValue) {
            value = collection2.getNextValue(highlightedValue);
            if (!value && prop("loopFocus")) value = collection2.firstValue;
          } else {
            value = collection2.firstValue;
          }
          if (value) context.set("highlightedValue", value);
        },
        highlightPrevItem({ context, prop }) {
          let value = null;
          const highlightedValue = context.get("highlightedValue");
          const collection2 = prop("collection");
          if (highlightedValue) {
            value = collection2.getPreviousValue(highlightedValue);
            if (!value && prop("loopFocus")) value = collection2.lastValue;
          } else {
            value = collection2.lastValue;
          }
          if (value) context.set("highlightedValue", value);
        },
        highlightFirstSelectedItem({ context, prop }) {
          raf2(() => {
            const [value] = prop("collection").sort(context.get("value"));
            if (value) context.set("highlightedValue", value);
          });
        },
        highlightFirstOrSelectedItem({ context, prop, computed }) {
          raf2(() => {
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
          raf2(() => {
            const collection2 = prop("collection");
            let value = null;
            if (computed("hasSelectedItems")) {
              value = collection2.sort(context.get("value"))[0];
            } else {
              value = collection2.lastValue;
            }
            if (value) context.set("highlightedValue", value);
          });
        },
        autofillInputValue({ context, computed, prop, event, scope }) {
          const inputEl = getInputEl(scope);
          const collection2 = prop("collection");
          if (!computed("autoComplete") || !inputEl || !event.keypress) return;
          const valueText = collection2.stringify(context.get("highlightedValue"));
          raf2(() => {
            inputEl.value = valueText || context.get("inputValue");
          });
        },
        syncSelectedItems(params) {
          queueMicrotask(() => {
            const { context, prop } = params;
            const collection2 = prop("collection");
            const value = context.get("value");
            const selectedItems = value.map((v) => {
              const item = context.get("selectedItems").find((item2) => collection2.getItemValue(item2) === v);
              return item || collection2.find(v);
            });
            context.set("selectedItems", selectedItems);
            const inputValue = match(prop("selectionBehavior"), {
              preserve: context.get("inputValue"),
              replace: collection2.stringifyMany(value),
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
  var props4 = createProps2()([
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
  var splitProps6 = createSplitProps2(props4);
  var itemGroupLabelProps = createProps2()(["htmlFor"]);
  var splitItemGroupLabelProps = createSplitProps2(itemGroupLabelProps);
  var itemGroupProps = createProps2()(["id"]);
  var splitItemGroupProps = createSplitProps2(itemGroupProps);
  var itemProps3 = createProps2()(["item", "persistFocus"]);
  var splitItemProps3 = createSplitProps2(itemProps3);

  // components/combobox.ts
  var Combobox = class extends Component {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    initMachine(props5) {
      return new VanillaMachine(machine5, props5);
    }
    initApi() {
      return connect5(this.machine.service, normalizeProps);
    }
    render() {
      const rootEl = this.el.querySelector('[data-part="root"]') || this.el;
      this.spreadProps(rootEl, this.api.getRootProps());
      const labelEl = this.el.querySelector('[data-part="label"]');
      if (labelEl) {
        this.spreadProps(labelEl, this.api.getLabelProps());
      }
      const controlEl = this.el.querySelector('[data-part="control"]');
      if (controlEl) {
        this.spreadProps(controlEl, this.api.getControlProps());
      }
      const inputEl = this.el.querySelector('[data-part="input"]');
      if (inputEl) {
        this.spreadProps(inputEl, this.api.getInputProps());
      }
      const triggerEl = this.el.querySelector('[data-part="trigger"]');
      if (triggerEl) {
        this.spreadProps(triggerEl, this.api.getTriggerProps());
      }
      const clearTriggerEl = this.el.querySelector('[data-part="clear-trigger"]');
      if (clearTriggerEl) {
        this.spreadProps(clearTriggerEl, this.api.getClearTriggerProps());
      }
      const positionerEl = this.el.querySelector('[data-part="positioner"]');
      if (positionerEl) {
        this.spreadProps(positionerEl, this.api.getPositionerProps());
      }
      const contentEl = this.el.querySelector('[data-part="content"]');
      if (contentEl) {
        this.spreadProps(contentEl, this.api.getContentProps());
        const visibleGroups = /* @__PURE__ */ new Set();
        const itemEls = contentEl.querySelectorAll('[data-part="item"]');
        for (let j = 0; j < itemEls.length; j++) {
          const itemEl = itemEls[j];
          const value = getString(itemEl, "value");
          if (!value) continue;
          const item = this.api.collection.find(value);
          if (!item) {
            itemEl.style.display = "none";
            continue;
          }
          itemEl.style.display = "";
          this.spreadProps(itemEl, this.api.getItemProps({ item }));
          const groupEl = itemEl.closest('[data-part="item-group"]');
          if (groupEl) {
            const groupId = groupEl.getAttribute("data-id");
            if (groupId) visibleGroups.add(groupId);
          }
          const indicatorEl = itemEl.querySelector('[data-part="item-indicator"]');
          if (indicatorEl) {
            this.spreadProps(indicatorEl, this.api.getItemIndicatorProps({ item }));
          }
          const itemTextEl = itemEl.querySelector('[data-part="item-text"]');
          if (itemTextEl) {
            this.spreadProps(itemTextEl, this.api.getItemTextProps({ item }));
          }
        }
        const groupEls = contentEl.querySelectorAll('[data-part="item-group"]');
        for (let i = 0; i < groupEls.length; i++) {
          const groupEl = groupEls[i];
          const groupId = groupEl.getAttribute("data-id");
          if (groupId && visibleGroups.has(groupId)) {
            groupEl.style.display = "";
            this.spreadProps(groupEl, this.api.getItemGroupProps({ id: groupId }));
          } else {
            groupEl.style.display = "none";
          }
        }
        const groupLabelEls = contentEl.querySelectorAll('[data-part="item-group-label"]');
        for (let i = 0; i < groupLabelEls.length; i++) {
          const labelEl2 = groupLabelEls[i];
          const groupId = labelEl2.getAttribute("data-id");
          if (groupId && visibleGroups.has(groupId)) {
            labelEl2.style.display = "";
            this.spreadProps(labelEl2, this.api.getItemGroupLabelProps({ htmlFor: groupId }));
          } else {
            labelEl2.style.display = "none";
          }
        }
      }
    }
  };

  // hooks/combobox.ts
  var ComboboxHook = {
    mounted() {
      var _a, _b, _c, _d;
      const el = this.el;
      const pushEvent = this.pushEvent.bind(this);
      const allItems = JSON.parse(el.dataset.collection || "[]");
      this.allItems = allItems;
      const hasGroups = allItems.some((item) => item.group !== void 0);
      const createCollection = (items) => {
        if (hasGroups) {
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
      };
      const props5 = __spreadProps(__spreadValues(__spreadProps(__spreadValues(__spreadValues({
        id: el.id
      }, getBoolean(el, "controlled") ? { value: getStringList(el, "value") } : { defaultValue: getStringList(el, "defaultValue") }), getBoolean(el, "controlled") ? { inputValue: (_b = (_a = getStringList(el, "value")) == null ? void 0 : _a[0]) != null ? _b : "" } : { defaultInputValue: (_d = (_c = getStringList(el, "defaultValue")) == null ? void 0 : _c[0]) != null ? _d : "" }), {
        disabled: getBoolean(el, "disabled"),
        placeholder: getString(el, "placeholder"),
        collection: createCollection(allItems),
        alwaysSubmitOnEnter: getBoolean(el, "alwaysSubmitOnEnter"),
        autoFocus: getBoolean(el, "autoFocus"),
        closeOnSelect: getBoolean(el, "closeOnSelect"),
        dir: getString(this.el, "dir", ["ltr", "rtl"]),
        inputBehavior: getString(this.el, "inputBehavior", ["autohighlight", "autocomplete", "none"]),
        loopFocus: getBoolean(el, "loopFocus"),
        multiple: getBoolean(el, "multiple"),
        invalid: getBoolean(el, "invalid")
      }), getBoolean(el, "controlled") ? { open: getBoolean(el, "open") } : { defaultOpen: getBoolean(el, "defaultOpen") }), {
        name: getString(el, "name"),
        readOnly: getBoolean(el, "readOnly"),
        required: getBoolean(el, "required"),
        positioning: {
          hideWhenDetached: getBoolean(el, "hideWhenDetached"),
          strategy: getString(el, "strategy", ["absolute", "fixed"]),
          placement: getString(el, "placement", ["top", "bottom", "left", "right"]),
          offset: {
            mainAxis: getNumber(el, "offsetMainAxis"),
            crossAxis: getNumber(el, "offsetCrossAxis")
          },
          gutter: getNumber(el, "gutter"),
          shift: getNumber(el, "shift"),
          overflowPadding: getNumber(el, "overflowPadding"),
          flip: getBoolean(el, "flip"),
          slide: getBoolean(el, "slide"),
          overlap: getBoolean(el, "overlap"),
          sameWidth: getBoolean(el, "sameWidth"),
          fitViewport: getBoolean(el, "fitViewport")
        },
        onOpenChange: (details) => {
          if (details.open && this.combobox) {
            this.combobox.updateProps({
              collection: createCollection(this.allItems || [])
            });
          }
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
          if (!this.combobox || !this.allItems) return;
          const filtered = this.allItems.filter(
            (item) => item.label.toLowerCase().includes(details.inputValue.toLowerCase())
          );
          const currentItems = filtered.length > 0 ? filtered : this.allItems;
          this.combobox.updateProps({
            collection: createCollection(currentItems)
          });
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
        }
      });
      const combobox = new Combobox(el, props5);
      combobox.init();
      this.combobox = combobox;
      this.handlers = [];
    },
    updated() {
      var _a;
      (_a = this.combobox) == null ? void 0 : _a.updateProps(__spreadValues({
        disabled: getBoolean(this.el, "disabled"),
        placeholder: getString(this.el, "placeholder"),
        name: getString(this.el, "name")
      }, getBoolean(this.el, "controlled") ? { value: getStringList(this.el, "value") } : { defaultValue: getStringList(this.el, "defaultValue") }));
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

  // hooks/corex.ts
  var Hooks = { Accordion: AccordionHook, ToggleGroup: ToggleGroupHook, Toast: ToastHook, Switch: SwitchHook, Combobox: ComboboxHook };
  var corex_default = Hooks;
  return __toCommonJS(corex_exports);
})();
