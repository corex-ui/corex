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
  var __spreadValues = (a3, b10) => {
    for (var prop in b10 || (b10 = {}))
      if (__hasOwnProp.call(b10, prop))
        __defNormalProp(a3, prop, b10[prop]);
    if (__getOwnPropSymbols)
      for (var prop of __getOwnPropSymbols(b10)) {
        if (__propIsEnum.call(b10, prop))
          __defNormalProp(a3, prop, b10[prop]);
      }
    return a3;
  };
  var __spreadProps = (a3, b10) => __defProps(a3, __getOwnPropDescs(b10));
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
  var __esm = (fn4, res) => function __init() {
    return fn4 && (res = (0, fn4[__getOwnPropNames(fn4)[0]])(fn4 = 0)), res;
  };
  var __export = (target, all) => {
    for (var name in all)
      __defProp(target, name, { get: all[name], enumerable: true });
  };
  var __copyProps = (to2, from, except, desc) => {
    if (from && typeof from === "object" || typeof from === "function") {
      for (let key of __getOwnPropNames(from))
        if (!__hasOwnProp.call(to2, key) && key !== except)
          __defProp(to2, key, { get: () => from[key], enumerable: !(desc = __getOwnPropDesc(from, key)) || desc.enumerable });
    }
    return to2;
  };
  var __toCommonJS = (mod) => __copyProps(__defProp({}, "__esModule", { value: true }), mod);
  var __publicField = (obj, key, value) => __defNormalProp(obj, typeof key !== "symbol" ? key + "" : key, value);
  var __async = (__this, __arguments, generator) => {
    return new Promise((resolve, reject) => {
      var fulfilled = (value) => {
        try {
          step(generator.next(value));
        } catch (e4) {
          reject(e4);
        }
      };
      var rejected = (value) => {
        try {
          step(generator.throw(value));
        } catch (e4) {
          reject(e4);
        }
      };
      var step = (x14) => x14.done ? resolve(x14.value) : Promise.resolve(x14.value).then(fulfilled, rejected);
      step((generator = generator.apply(__this, __arguments)).next());
    });
  };
  var __await = function(promise, isYieldStar) {
    this[0] = promise;
    this[1] = isYieldStar;
  };
  var __yieldStar = (value) => {
    var obj = value[__knownSymbol("asyncIterator")], isAwait = false, method, it8 = {};
    if (obj == null) {
      obj = value[__knownSymbol("iterator")]();
      method = (k14) => it8[k14] = (x14) => obj[k14](x14);
    } else {
      obj = obj.call(value);
      method = (k14) => it8[k14] = (v10) => {
        if (isAwait) {
          isAwait = false;
          if (k14 === "throw") throw v10;
          return v10;
        }
        isAwait = true;
        return {
          done: false,
          value: new __await(new Promise((resolve) => {
            var x14 = obj[k14](v10);
            if (!(x14 instanceof Object)) __typeError("Object expected");
            resolve(x14);
          }), 1)
        };
      };
    }
    return it8[__knownSymbol("iterator")] = () => it8, method("next"), "throw" in obj ? method("throw") : it8.throw = (x14) => {
      throw x14;
    }, "return" in obj && method("return"), it8;
  };

  // ../priv/static/chunk-IYURAQ6S.mjs
  function kr(t) {
    let e4 = t.dataset.dir;
    if (e4 !== void 0 && we.includes(e4)) return e4;
    let n = document.documentElement.getAttribute("dir");
    return n === "ltr" || n === "rtl" ? n : "ltr";
  }
  function Kr(t) {
    if (t) try {
      if (t.ownerDocument.activeElement !== t) return;
      let e4 = t.value.length;
      t.setSelectionRange(e4, e4);
    } catch (e4) {
    }
  }
  function Ne(t) {
    return ["html", "body", "#document"].includes(Vt(t));
  }
  function W(t) {
    if (!t) return false;
    let e4 = t.getRootNode();
    return bt(e4) === t;
  }
  function _e(t) {
    if (t == null || !S(t)) return false;
    try {
      return xe(t) && t.selectionStart != null || Le.test(t.localName) || t.isContentEditable || t.getAttribute("contenteditable") === "true" || t.getAttribute("contenteditable") === "";
    } catch (e4) {
      return false;
    }
  }
  function Ie(t, e4) {
    var _a2;
    if (!t || !e4 || !S(t) || !S(e4)) return false;
    let n = (_a2 = e4.getRootNode) == null ? void 0 : _a2.call(e4);
    if (t === e4 || t.contains(e4)) return true;
    if (n && z(n)) {
      let r3 = e4;
      for (; r3; ) {
        if (t === r3) return true;
        r3 = r3.parentNode || r3.host;
      }
    }
    return false;
  }
  function q(t) {
    var _a2;
    return yt(t) ? t : Me(t) ? t.document : (_a2 = t == null ? void 0 : t.ownerDocument) != null ? _a2 : document;
  }
  function De(t) {
    return q(t).documentElement;
  }
  function T(t) {
    var _a2, _b, _c;
    return z(t) ? T(t.host) : yt(t) ? (_a2 = t.defaultView) != null ? _a2 : window : S(t) ? (_c = (_b = t.ownerDocument) == null ? void 0 : _b.defaultView) != null ? _c : window : window;
  }
  function bt(t) {
    let e4 = t.activeElement;
    for (; e4 == null ? void 0 : e4.shadowRoot; ) {
      let n = e4.shadowRoot.activeElement;
      if (!n || n === e4) break;
      e4 = n;
    }
    return e4;
  }
  function Ve(t) {
    if (Vt(t) === "html") return t;
    let e4 = t.assignedSlot || t.parentNode || z(t) && t.host || De(t);
    return z(e4) ? e4.host : e4;
  }
  function vt(t) {
    var _a2;
    let e4;
    try {
      if (e4 = t.getRootNode({ composed: true }), yt(e4) || z(e4)) return e4;
    } catch (e5) {
    }
    return (_a2 = t.ownerDocument) != null ? _a2 : document;
  }
  function zr(t) {
    return ht.has(t) || ht.set(t, T(t).getComputedStyle(t)), ht.get(t);
  }
  function Wr(t, e4) {
    let n = /* @__PURE__ */ new Set(), r3 = vt(t), o2 = (s) => {
      let c5 = s.querySelectorAll("[aria-controls]");
      for (let i of c5) {
        if (i.getAttribute("aria-expanded") !== "true") continue;
        let l4 = Kt(i);
        for (let d4 of l4) {
          if (!d4 || n.has(d4)) continue;
          n.add(d4);
          let h6 = r3.getElementById(d4);
          if (h6) {
            let a3 = h6.getAttribute("role"), u3 = h6.getAttribute("aria-modal") === "true";
            if (a3 && Ke(a3) && !u3 && (h6 === e4 || h6.contains(e4) || o2(h6))) return true;
          }
        }
      }
      return false;
    };
    return o2(t);
  }
  function Fe(t, e4) {
    let n = vt(t), r3 = /* @__PURE__ */ new Set(), o2 = (s) => {
      let c5 = s.querySelectorAll("[aria-controls]");
      for (let i of c5) {
        if (i.getAttribute("aria-expanded") !== "true") continue;
        let l4 = Kt(i);
        for (let d4 of l4) {
          if (!d4 || r3.has(d4)) continue;
          r3.add(d4);
          let h6 = n.getElementById(d4);
          if (h6) {
            let a3 = h6.getAttribute("role"), u3 = h6.getAttribute("aria-modal") === "true";
            a3 && wt.has(a3) && !u3 && (e4(h6), o2(h6));
          }
        }
      }
    };
    o2(t);
  }
  function qr(t) {
    let e4 = /* @__PURE__ */ new Set();
    return Fe(t, (n) => {
      t.contains(n) || e4.add(n);
    }), Array.from(e4);
  }
  function je(t) {
    let e4 = t.getAttribute("role");
    return !!(e4 && wt.has(e4));
  }
  function Be(t) {
    return t.hasAttribute("aria-controls") && t.getAttribute("aria-expanded") === "true";
  }
  function Hr(t) {
    var _a2;
    return Be(t) ? true : !!((_a2 = t.querySelector) == null ? void 0 : _a2.call(t, '[aria-controls][aria-expanded="true"]'));
  }
  function Ur(t) {
    if (!t.id) return false;
    let e4 = vt(t), n = CSS.escape(t.id), r3 = `[aria-controls~="${n}"][aria-expanded="true"], [aria-controls="${n}"][aria-expanded="true"]`;
    return !!(e4.querySelector(r3) && je(t));
  }
  function Yr(t, e4) {
    let { type: n, quality: r3 = 0.92, background: o2 } = e4;
    if (!t) throw new Error("[zag-js > getDataUrl]: Could not find the svg element");
    let s = T(t), c5 = s.document, i = t.getBoundingClientRect(), l4 = t.cloneNode(true);
    l4.hasAttribute("viewBox") || l4.setAttribute("viewBox", `0 0 ${i.width} ${i.height}`);
    let h6 = `<?xml version="1.0" standalone="no"?>\r
` + new s.XMLSerializer().serializeToString(l4), a3 = "data:image/svg+xml;charset=utf-8," + encodeURIComponent(h6);
    if (n === "image/svg+xml") return Promise.resolve(a3).then((b10) => (l4.remove(), b10));
    let u3 = s.devicePixelRatio || 1, p4 = c5.createElement("canvas"), g7 = new s.Image();
    g7.src = a3, p4.width = i.width * u3, p4.height = i.height * u3;
    let f4 = p4.getContext("2d");
    return (n === "image/jpeg" || o2) && (f4.fillStyle = o2 || "white", f4.fillRect(0, 0, p4.width, p4.height)), new Promise((b10) => {
      g7.onload = () => {
        f4 == null ? void 0 : f4.drawImage(g7, 0, 0, p4.width, p4.height), b10(p4.toDataURL(n, r3)), l4.remove();
      };
    });
  }
  function $e() {
    var _a2, _b;
    return (_b = (_a2 = navigator.userAgentData) == null ? void 0 : _a2.platform) != null ? _b : navigator.platform;
  }
  function ze() {
    let t = navigator.userAgentData;
    return t && Array.isArray(t.brands) ? t.brands.map(({ brand: e4, version: n }) => `${e4}/${n}`).join(" ") : navigator.userAgent;
  }
  function Jr(t) {
    let { selectionStart: e4, selectionEnd: n, value: r3 } = t.currentTarget, o2 = t.data;
    return r3.slice(0, e4) + (o2 != null ? o2 : "") + r3.slice(n);
  }
  function Xe(t) {
    var _a2, _b, _c, _d;
    return (_d = (_a2 = t.composedPath) == null ? void 0 : _a2.call(t)) != null ? _d : (_c = (_b = t.nativeEvent) == null ? void 0 : _b.composedPath) == null ? void 0 : _c.call(_b);
  }
  function Je(t) {
    var _a2, _b;
    return (_b = (_a2 = Xe(t)) == null ? void 0 : _a2[0]) != null ? _b : t.target;
  }
  function Zr(t) {
    let e4 = t.currentTarget;
    if (!e4 || !e4.matches("a[href], button[type='submit'], input[type='submit']")) return false;
    let r3 = t.button === 1, o2 = Ze(t);
    return r3 || o2;
  }
  function Qr(t) {
    let e4 = t.currentTarget;
    if (!e4) return false;
    let n = e4.localName;
    return t.altKey ? n === "a" || n === "button" && e4.type === "submit" || n === "input" && e4.type === "submit" : false;
  }
  function to(t) {
    return en(t).isComposing || t.keyCode === 229;
  }
  function Ze(t) {
    return tt() ? t.metaKey : t.ctrlKey;
  }
  function eo(t) {
    return t.key.length === 1 && !t.ctrlKey && !t.metaKey;
  }
  function no(t) {
    return t.pointerType === "" && t.isTrusted ? true : Ge() && t.pointerType ? t.type === "click" && t.buttons === 1 : t.detail === 0 && !t.pointerType;
  }
  function io(t, e4 = {}) {
    var _a2;
    let { dir: n = "ltr", orientation: r3 = "horizontal" } = e4, o2 = t.key;
    return o2 = (_a2 = tn[o2]) != null ? _a2 : o2, n === "rtl" && r3 === "horizontal" && o2 in Dt && (o2 = Dt[o2]), o2;
  }
  function en(t) {
    var _a2;
    return (_a2 = t.nativeEvent) != null ? _a2 : t;
  }
  function co(t) {
    return t.ctrlKey || t.metaKey ? 0.1 : nn.has(t.key) || t.shiftKey && rn.has(t.key) ? 10 : 1;
  }
  function gt(t, e4 = "client") {
    let n = Qe(t) ? t.touches[0] || t.changedTouches[0] : t;
    return { x: n[`${e4}X`], y: n[`${e4}Y`] };
  }
  function jt(t, e4) {
    var _a2;
    let { type: n = "HTMLInputElement", property: r3 = "value" } = e4, o2 = T(t)[n].prototype;
    return (_a2 = Object.getOwnPropertyDescriptor(o2, r3)) != null ? _a2 : {};
  }
  function on(t) {
    if (t.localName === "input") return "HTMLInputElement";
    if (t.localName === "textarea") return "HTMLTextAreaElement";
    if (t.localName === "select") return "HTMLSelectElement";
  }
  function sn(t, e4, n = "value") {
    var _a2;
    if (!t) return;
    let r3 = on(t);
    r3 && ((_a2 = jt(t, { type: r3, property: n }).set) == null ? void 0 : _a2.call(t, e4)), t.setAttribute(n, e4);
  }
  function cn(t, e4) {
    var _a2;
    if (!t) return;
    (_a2 = jt(t, { type: "HTMLInputElement", property: "checked" }).set) == null ? void 0 : _a2.call(t, e4), e4 ? t.setAttribute("checked", "") : t.removeAttribute("checked");
  }
  function ao(t, e4) {
    let { value: n, bubbles: r3 = true } = e4;
    if (!t) return;
    let o2 = T(t);
    t instanceof o2.HTMLInputElement && (sn(t, `${n}`), t.dispatchEvent(new o2.Event("input", { bubbles: r3 })));
  }
  function uo(t, e4) {
    let { checked: n, bubbles: r3 = true } = e4;
    if (!t) return;
    let o2 = T(t);
    t instanceof o2.HTMLInputElement && (cn(t, n), t.dispatchEvent(new o2.Event("click", { bubbles: r3 })));
  }
  function an(t) {
    return un(t) ? t.form : t.closest("form");
  }
  function un(t) {
    return t.matches("textarea, input, select, button");
  }
  function ln(t, e4) {
    if (!t) return;
    let n = an(t), r3 = (o2) => {
      o2.defaultPrevented || e4();
    };
    return n == null ? void 0 : n.addEventListener("reset", r3, { passive: true }), () => n == null ? void 0 : n.removeEventListener("reset", r3);
  }
  function fn(t, e4) {
    let n = t == null ? void 0 : t.closest("fieldset");
    if (!n) return;
    e4(n.disabled);
    let r3 = T(n), o2 = new r3.MutationObserver(() => e4(n.disabled));
    return o2.observe(n, { attributes: true, attributeFilter: ["disabled"] }), () => o2.disconnect();
  }
  function lo(t, e4) {
    if (!t) return;
    let { onFieldsetDisabledChange: n, onFormReset: r3 } = e4, o2 = [ln(t, r3), fn(t, n)];
    return () => o2.forEach((s) => s == null ? void 0 : s());
  }
  function $t(t) {
    let e4 = t.getAttribute("tabindex");
    return e4 ? parseInt(e4, 10) : NaN;
  }
  function gn(t, e4) {
    if (!e4) return null;
    if (e4 === true) return t.shadowRoot || null;
    let n = e4(t);
    return (n === true ? t.shadowRoot : n) || null;
  }
  function zt(t, e4, n) {
    let r3 = [...t], o2 = [...t], s = /* @__PURE__ */ new Set(), c5 = /* @__PURE__ */ new Map();
    t.forEach((l4, d4) => c5.set(l4, d4));
    let i = 0;
    for (; i < o2.length; ) {
      let l4 = o2[i++];
      if (!l4 || s.has(l4)) continue;
      s.add(l4);
      let d4 = gn(l4, e4);
      if (d4) {
        let h6 = Array.from(d4.querySelectorAll(et)).filter(n), a3 = c5.get(l4);
        if (a3 !== void 0) {
          let u3 = a3 + 1;
          r3.splice(u3, 0, ...h6), h6.forEach((p4, g7) => {
            c5.set(p4, u3 + g7);
          });
          for (let p4 = u3 + h6.length; p4 < r3.length; p4++) c5.set(r3[p4], p4);
        } else {
          let u3 = r3.length;
          r3.push(...h6), h6.forEach((p4, g7) => {
            c5.set(p4, u3 + g7);
          });
        }
        o2.push(...h6);
      }
    }
    return r3;
  }
  function X(t) {
    return !S(t) || t.closest("[inert]") ? false : t.matches(et) && Ce(t);
  }
  function Pt(t, e4 = {}) {
    if (!t) return [];
    let { includeContainer: n, getShadowRoot: r3 } = e4, o2 = Array.from(t.querySelectorAll(et));
    n && pt(t) && o2.unshift(t);
    let s = [];
    for (let c5 of o2) if (pt(c5)) {
      if (Bt(c5) && c5.contentDocument) {
        let i = c5.contentDocument.body;
        s.push(...Pt(i, { getShadowRoot: r3 }));
        continue;
      }
      s.push(c5);
    }
    if (r3) {
      let c5 = zt(s, r3, pt);
      return !c5.length && n ? o2 : c5;
    }
    return !s.length && n ? o2 : s;
  }
  function pt(t) {
    return S(t) && t.tabIndex > 0 ? true : X(t) && !pn(t);
  }
  function yn(t, e4 = {}) {
    let n = Pt(t, e4), r3 = n[0] || null, o2 = n[n.length - 1] || null;
    return [r3, o2];
  }
  function fo(t) {
    return t.tabIndex < 0 && (dn.test(t.localName) || _e(t)) && !hn(t) ? 0 : t.tabIndex;
  }
  function ho(t) {
    let { root: e4, getInitialEl: n, filter: r3, enabled: o2 = true } = t;
    if (!o2) return;
    let s = null;
    if (s || (s = typeof n == "function" ? n() : n), s || (s = e4 == null ? void 0 : e4.querySelector("[data-autofocus],[autofocus]")), !s) {
      let c5 = Pt(e4);
      s = r3 ? c5.filter(r3)[0] : c5[0];
    }
    return s || e4 || void 0;
  }
  function po(t) {
    let e4 = t.currentTarget;
    if (!e4) return false;
    let [n, r3] = yn(e4);
    return !(W(n) && t.shiftKey || W(r3) && !t.shiftKey || !n && !r3);
  }
  function nt(t) {
    let e4 = bn.create();
    return e4.request(t), e4.cleanup;
  }
  function vn(t) {
    let e4 = /* @__PURE__ */ new Set();
    function n(r3) {
      let o2 = globalThis.requestAnimationFrame(r3);
      e4.add(() => globalThis.cancelAnimationFrame(o2));
    }
    return n(() => n(t)), function() {
      e4.forEach((o2) => o2());
    };
  }
  function wn(t, e4, n) {
    let r3 = nt(() => {
      t.removeEventListener(e4, o2, true), n();
    }), o2 = () => {
      r3(), n();
    };
    return t.addEventListener(e4, o2, { once: true, capture: true }), r3;
  }
  function En(t, e4) {
    if (!t) return;
    let { attributes: n, callback: r3 } = e4, o2 = t.ownerDocument.defaultView || window, s = new o2.MutationObserver((c5) => {
      for (let i of c5) i.type === "attributes" && i.attributeName && n.includes(i.attributeName) && r3(i);
    });
    return s.observe(t, { attributes: true, attributeFilter: n }), () => s.disconnect();
  }
  function go(t, e4) {
    let { defer: n } = e4, r3 = n ? nt : (s) => s(), o2 = [];
    return o2.push(r3(() => {
      let s = typeof t == "function" ? t() : t;
      o2.push(En(s, e4));
    })), () => {
      o2.forEach((s) => s == null ? void 0 : s());
    };
  }
  function An(t, e4) {
    let { callback: n } = e4;
    if (!t) return;
    let r3 = t.ownerDocument.defaultView || window, o2 = new r3.MutationObserver(n);
    return o2.observe(t, { childList: true, subtree: true }), () => o2.disconnect();
  }
  function mo(t, e4) {
    let { defer: n } = e4, r3 = n ? nt : (s) => s(), o2 = [];
    return o2.push(r3(() => {
      let s = typeof t == "function" ? t() : t;
      o2.push(An(s, e4));
    })), () => {
      o2.forEach((s) => s == null ? void 0 : s());
    };
  }
  function yo(t) {
    let e4 = () => {
      let n = T(t);
      t.dispatchEvent(new n.MouseEvent("click"));
    };
    Ye() ? wn(t, "keyup", e4) : queueMicrotask(e4);
  }
  function Pn(t) {
    let e4 = Ve(t);
    return Ne(e4) ? q(e4).body : S(e4) && qt(e4) ? e4 : Pn(e4);
  }
  function qt(t) {
    let e4 = T(t), { overflow: n, overflowX: r3, overflowY: o2, display: s } = e4.getComputedStyle(t);
    return Sn.test(n + o2 + r3) && !Tn.has(s);
  }
  function On(t) {
    return t.scrollHeight > t.clientHeight || t.scrollWidth > t.clientWidth;
  }
  function bo(t, e4) {
    let _a2 = e4 || {}, { rootEl: n } = _a2, r3 = __objRest(_a2, ["rootEl"]);
    !t || !n || !qt(n) || !On(n) || t.scrollIntoView(r3);
  }
  function vo(t, e4) {
    let { left: n, top: r3, width: o2, height: s } = e4.getBoundingClientRect(), c5 = { x: t.x - n, y: t.y - r3 }, i = { x: It(c5.x / o2), y: It(c5.y / s) };
    function l4(d4 = {}) {
      let { dir: h6 = "ltr", orientation: a3 = "horizontal", inverted: u3 } = d4, p4 = typeof u3 == "object" ? u3.x : u3, g7 = typeof u3 == "object" ? u3.y : u3;
      return a3 === "horizontal" ? h6 === "rtl" || p4 ? 1 - i.x : i.x : g7 ? 1 - i.y : i.y;
    }
    return { offset: c5, percent: i, getPercentValue: l4 };
  }
  function wo(t, e4) {
    let n = t.body, r3 = "pointerLockElement" in t || "mozPointerLockElement" in t, o2 = () => !!t.pointerLockElement;
    function s() {
      e4 == null ? void 0 : e4(o2());
    }
    function c5(l4) {
      o2() && (e4 == null ? void 0 : e4(false)), console.error("PointerLock error occurred:", l4), t.exitPointerLock();
    }
    if (!r3) return;
    try {
      n.requestPointerLock();
    } catch (e5) {
    }
    let i = [P(t, "pointerlockchange", s, false), P(t, "pointerlockerror", c5, false)];
    return () => {
      i.forEach((l4) => l4()), t.exitPointerLock();
    };
  }
  function Rn(t = {}) {
    let { target: e4, doc: n } = t, r3 = n != null ? n : document, o2 = r3.documentElement;
    return At() ? (D === "default" && (mt = o2.style.webkitUserSelect, o2.style.webkitUserSelect = "none"), D = "disabled") : e4 && (J.set(e4, e4.style.userSelect), e4.style.userSelect = "none"), () => Mn({ target: e4, doc: r3 });
  }
  function Mn(t = {}) {
    let { target: e4, doc: n } = t, o2 = (n != null ? n : document).documentElement;
    if (At()) {
      if (D !== "disabled") return;
      D = "restoring", setTimeout(() => {
        vn(() => {
          D === "restoring" && (o2.style.webkitUserSelect === "none" && (o2.style.webkitUserSelect = mt || ""), mt = "", D = "default");
        });
      }, 300);
    } else if (e4 && J.has(e4)) {
      let s = J.get(e4);
      e4.style.userSelect === "none" && (e4.style.userSelect = s != null ? s : ""), e4.getAttribute("style") === "" && e4.removeAttribute("style"), J.delete(e4);
    }
  }
  function Nn(t = {}) {
    let _a2 = t, { defer: e4, target: n } = _a2, r3 = __objRest(_a2, ["defer", "target"]), o2 = e4 ? nt : (c5) => c5(), s = [];
    return s.push(o2(() => {
      let c5 = typeof n == "function" ? n() : n;
      s.push(Rn(__spreadProps(__spreadValues({}, r3), { target: c5 })));
    })), () => {
      s.forEach((c5) => c5 == null ? void 0 : c5());
    };
  }
  function Eo(t, e4) {
    let { onPointerMove: n, onPointerUp: r3 } = e4, o2 = (i) => {
      let l4 = gt(i), d4 = Math.sqrt(l4.x ** 2 + l4.y ** 2), h6 = i.pointerType === "touch" ? 10 : 5;
      if (!(d4 < h6)) {
        if (i.pointerType === "mouse" && i.buttons === 0) {
          s(i);
          return;
        }
        n({ point: l4, event: i });
      }
    }, s = (i) => {
      let l4 = gt(i);
      r3({ point: l4, event: i });
    }, c5 = [P(t, "pointermove", o2, false), P(t, "pointerup", s, false), P(t, "pointercancel", s, false), P(t, "contextmenu", s, false), Nn({ doc: t })];
    return () => {
      c5.forEach((i) => i());
    };
  }
  function Ao(t) {
    let { pointerNode: e4, keyboardNode: n = e4, onPress: r3, onPressStart: o2, onPressEnd: s, isValidKey: c5 = (E15) => E15.key === "Enter" } = t;
    if (!e4) return N;
    let i = T(e4), l4 = N, d4 = N, h6 = N, a3 = (E15) => ({ point: gt(E15), event: E15 });
    function u3(E15) {
      o2 == null ? void 0 : o2(a3(E15));
    }
    function p4(E15) {
      s == null ? void 0 : s(a3(E15));
    }
    let f4 = P(e4, "pointerdown", (E15) => {
      d4();
      let U11 = P(i, "pointerup", (R7) => {
        let m5 = Je(R7);
        Ie(e4, m5) ? r3 == null ? void 0 : r3(a3(R7)) : s == null ? void 0 : s(a3(R7));
      }, { passive: !r3, once: true }), k14 = P(i, "pointercancel", p4, { passive: !s, once: true });
      d4 = dt(U11, k14), W(n) && E15.pointerType === "mouse" && E15.preventDefault(), u3(E15);
    }, { passive: !o2 }), b10 = P(n, "focus", O10);
    l4 = dt(f4, b10);
    function O10() {
      let E15 = (R7) => {
        if (!c5(R7)) return;
        let m5 = (v10) => {
          if (!c5(v10)) return;
          let A12 = new i.PointerEvent("pointerup"), M10 = a3(A12);
          r3 == null ? void 0 : r3(M10), s == null ? void 0 : s(M10);
        };
        d4(), d4 = P(n, "keyup", m5);
        let y11 = new i.PointerEvent("pointerdown");
        u3(y11);
      }, _12 = () => {
        let R7 = new i.PointerEvent("pointercancel");
        p4(R7);
      }, U11 = P(n, "keydown", E15), k14 = P(n, "blur", _12);
      h6 = dt(U11, k14);
    }
    return () => {
      l4(), d4(), h6();
    };
  }
  function Po(t, e4) {
    var _a2;
    return Array.from((_a2 = t == null ? void 0 : t.querySelectorAll(e4)) != null ? _a2 : []);
  }
  function So(t, e4) {
    var _a2;
    return (_a2 = t == null ? void 0 : t.querySelector(e4)) != null ? _a2 : null;
  }
  function kn(t, e4, n = St) {
    return t.find((r3) => n(r3) === e4);
  }
  function Tt(t, e4, n = St) {
    let r3 = kn(t, e4, n);
    return r3 ? t.indexOf(r3) : -1;
  }
  function To(t, e4, n = true) {
    let r3 = Tt(t, e4);
    return r3 = n ? (r3 + 1) % t.length : Math.min(r3 + 1, t.length - 1), t[r3];
  }
  function Oo(t, e4, n = true) {
    let r3 = Tt(t, e4);
    return r3 === -1 ? n ? t[t.length - 1] : null : (r3 = n ? (r3 - 1 + t.length) % t.length : Math.max(0, r3 - 1), t[r3]);
  }
  function xn(t) {
    let e4 = /* @__PURE__ */ new WeakMap(), n, r3 = /* @__PURE__ */ new WeakMap(), o2 = (i) => n || (n = new i.ResizeObserver((l4) => {
      for (let d4 of l4) {
        r3.set(d4.target, d4);
        let h6 = e4.get(d4.target);
        if (h6) for (let a3 of h6) a3(d4);
      }
    }), n);
    return { observe: (i, l4) => {
      let d4 = e4.get(i) || /* @__PURE__ */ new Set();
      d4.add(l4), e4.set(i, d4);
      let h6 = T(i);
      return o2(h6).observe(i, t), () => {
        let a3 = e4.get(i);
        a3 && (a3.delete(l4), a3.size === 0 && (e4.delete(i), o2(h6).unobserve(i)));
      };
    }, unobserve: (i) => {
      e4.delete(i), n == null ? void 0 : n.unobserve(i);
    } };
  }
  function In(t, e4, n, r3 = St) {
    let o2 = n ? Tt(t, n, r3) : -1, s = n ? Se(t, o2) : t;
    return e4.length === 1 && (s = s.filter((i) => r3(i) !== n)), s.find((i) => _n(Ln(i), e4));
  }
  function Mo(t, e4, n) {
    let r3 = t.getAttribute(e4), o2 = r3 != null;
    return r3 === n ? N : (t.setAttribute(e4, n), () => {
      o2 ? t.setAttribute(e4, r3) : t.removeAttribute(e4);
    });
  }
  function No(t, e4) {
    if (!t) return N;
    let n = Object.keys(e4).reduce((r3, o2) => (r3[o2] = t.style.getPropertyValue(o2), r3), {});
    return Dn(n, e4) ? N : (Object.assign(t.style, e4), () => {
      Object.assign(t.style, n), t.style.length === 0 && t.removeAttribute("style");
    });
  }
  function ko(t, e4, n) {
    if (!t) return N;
    let r3 = t.style.getPropertyValue(e4);
    return r3 === n ? N : (t.style.setProperty(e4, n), () => {
      t.style.setProperty(e4, r3), t.style.length === 0 && t.removeAttribute("style");
    });
  }
  function Dn(t, e4) {
    return Object.keys(t).every((n) => t[n] === e4[n]);
  }
  function Vn(t, e4) {
    let { state: n, activeId: r3, key: o2, timeout: s = 350, itemToId: c5 } = e4, i = n.keysSoFar + o2, d4 = i.length > 1 && Array.from(i).every((g7) => g7 === i[0]) ? i[0] : i, h6 = t.slice(), a3 = In(h6, d4, r3, c5);
    function u3() {
      clearTimeout(n.timer), n.timer = -1;
    }
    function p4(g7) {
      n.keysSoFar = g7, u3(), g7 !== "" && (n.timer = +setTimeout(() => {
        p4(""), u3();
      }, s));
    }
    return p4(i), a3;
  }
  function Kn(t) {
    return t.key.length === 1 && !t.ctrlKey && !t.metaKey;
  }
  function Fn(t, e4, n) {
    let { signal: r3 } = e4;
    return [new Promise((c5, i) => {
      let l4 = setTimeout(() => {
        i(new Error(`Timeout of ${n}ms exceeded`));
      }, n);
      r3.addEventListener("abort", () => {
        clearTimeout(l4), i(new Error("Promise aborted"));
      }), t.then((d4) => {
        r3.aborted || (clearTimeout(l4), c5(d4));
      }).catch((d4) => {
        r3.aborted || (clearTimeout(l4), i(d4));
      });
    }), () => e4.abort()];
  }
  function Lo(t, e4) {
    let { timeout: n, rootNode: r3 } = e4, o2 = T(r3), s = q(r3), c5 = new o2.AbortController();
    return Fn(new Promise((i) => {
      let l4 = t();
      if (l4) {
        i(l4);
        return;
      }
      let d4 = new o2.MutationObserver(() => {
        let h6 = t();
        h6 && h6.isConnected && (d4.disconnect(), i(h6));
      });
      d4.observe(s.body, { childList: true, subtree: true });
    }), c5, n);
  }
  function Zt(t) {
    return t == null ? [] : Array.isArray(t) ? t : [t];
  }
  function Qt(t, e4, n = {}) {
    let { step: r3 = 1, loop: o2 = true } = n, s = e4 + r3, c5 = t.length, i = c5 - 1;
    return e4 === -1 ? r3 > 0 ? 0 : i : s < 0 ? o2 ? i : 0 : s >= c5 ? o2 ? 0 : e4 > c5 ? c5 : e4 : s;
  }
  function Fo(t, e4, n = {}) {
    return t[Qt(t, e4, n)];
  }
  function Yn(t, e4, n = {}) {
    let { step: r3 = 1, loop: o2 = true } = n;
    return Qt(t, e4, { step: -r3, loop: o2 });
  }
  function jo(t, e4, n = {}) {
    return t[Yn(t, e4, n)];
  }
  function Bo(t, e4) {
    return t.reduce((n, r3, o2) => {
      var _a2;
      return o2 % e4 === 0 ? n.push([r3]) : (_a2 = Wn(n)) == null ? void 0 : _a2.push(r3), n;
    }, []);
  }
  function $o(t, e4) {
    return t.reduce(([n, r3], o2) => (e4(o2) ? n.push(o2) : r3.push(o2), [n, r3]), [[], []]);
  }
  function rr(t, e4, ...n) {
    var _a2;
    if (t in e4) {
      let o2 = e4[t];
      return C(o2) ? o2(...n) : o2;
    }
    let r3 = new Error(`No matching key: ${JSON.stringify(t)} in ${JSON.stringify(Object.keys(e4))}`);
    throw (_a2 = Error.captureStackTrace) == null ? void 0 : _a2.call(Error, r3, rr), r3;
  }
  function Go(t, e4 = 0) {
    let n = 0, r3 = null;
    return (...o2) => {
      let s = Date.now(), c5 = s - n;
      c5 >= e4 ? (r3 && (clearTimeout(r3), r3 = null), t(...o2), n = s) : r3 || (r3 = setTimeout(() => {
        t(...o2), n = Date.now(), r3 = null;
      }, e4 - c5));
    };
  }
  function Rt(t) {
    if (!F(t) || t === void 0) return t;
    let e4 = Reflect.ownKeys(t).filter((r3) => typeof r3 == "string"), n = {};
    for (let r3 of e4) {
      let o2 = t[r3];
      o2 !== void 0 && (n[r3] = Rt(o2));
    }
    return n;
  }
  function cs(t, e4) {
    let n = {};
    for (let r3 of e4) {
      let o2 = t[r3];
      o2 !== void 0 && (n[r3] = o2);
    }
    return n;
  }
  function ar(t, e4) {
    let n = {}, r3 = {}, o2 = new Set(e4), s = Reflect.ownKeys(t);
    for (let c5 of s) o2.has(c5) ? r3[c5] = t[c5] : n[c5] = t[c5];
    return [r3, n];
  }
  function us(t, e4) {
    let n = new ce(({ now: r3, deltaMs: o2 }) => {
      if (o2 >= e4) {
        let s = e4 > 0 ? r3 - o2 % e4 : r3;
        n.setStartMs(s), t({ startMs: s, deltaMs: o2 });
      }
    });
    return n.start(), () => n.stop();
  }
  function ls(t, e4) {
    let n = new ce(({ deltaMs: r3 }) => {
      if (r3 >= e4) return t(), false;
    });
    return n.start(), () => n.stop();
  }
  function Mt(...t) {
    let e4 = t.length === 1 ? t[0] : t[1], n = t.length === 2 ? t[0] : true;
  }
  function fs(...t) {
    let e4 = t.length === 1 ? t[0] : t[1], n = t.length === 2 ? t[0] : true;
  }
  function ds(t, e4) {
    if (t == null) throw new Error(e4());
  }
  function hs(t, e4, n) {
    let r3 = [];
    for (let o2 of e4) t[o2] == null && r3.push(o2);
    if (r3.length > 0) throw new Error(`[zag-js${n ? ` > ${n}` : ""}] missing required props: ${r3.join(", ")}`);
  }
  function bs(...t) {
    let e4 = {};
    for (let n of t) {
      if (!n) continue;
      for (let o2 in e4) {
        if (o2.startsWith("on") && typeof e4[o2] == "function" && typeof n[o2] == "function") {
          e4[o2] = re(n[o2], e4[o2]);
          continue;
        }
        if (o2 === "className" || o2 === "class") {
          e4[o2] = ur(e4[o2], n[o2]);
          continue;
        }
        if (o2 === "style") {
          e4[o2] = fr(e4[o2], n[o2]);
          continue;
        }
        e4[o2] = n[o2] !== void 0 ? n[o2] : e4[o2];
      }
      for (let o2 in n) e4[o2] === void 0 && (e4[o2] = n[o2]);
      let r3 = Object.getOwnPropertySymbols(n);
      for (let o2 of r3) e4[o2] = n[o2];
    }
    return e4;
  }
  function vs(t, e4, n) {
    let r3 = [], o2;
    return (s) => {
      var _a2;
      let c5 = t(s);
      return (c5.length !== r3.length || c5.some((l4, d4) => !V(r3[d4], l4))) && (r3 = c5, o2 = e4(c5, s), (_a2 = n == null ? void 0 : n.onChange) == null ? void 0 : _a2.call(n, o2)), o2;
    };
  }
  function dr() {
    return { and: (...t) => function(n) {
      return t.every((r3) => n.guard(r3));
    }, or: (...t) => function(n) {
      return t.some((r3) => n.guard(r3));
    }, not: (t) => function(n) {
      return !n.guard(t);
    } };
  }
  function ws() {
    return { guards: dr(), createMachine: (t) => t, choose: (t) => function({ choose: n }) {
      var _a2;
      return (_a2 = n(t)) == null ? void 0 : _a2.actions;
    } };
  }
  function ue(t) {
    let e4 = () => {
      var _a2, _b;
      return (_b = (_a2 = t.getRootNode) == null ? void 0 : _a2.call(t)) != null ? _b : document;
    }, n = () => q(e4());
    return __spreadProps(__spreadValues({}, t), { getRootNode: e4, getDoc: n, getWin: () => {
      var _a2;
      return (_a2 = n().defaultView) != null ? _a2 : window;
    }, getActiveElement: () => bt(e4()), isActiveElement: W, getById: (c5) => e4().getElementById(c5) });
  }
  function le(t) {
    return new Proxy({}, { get(e4, n) {
      return n === "style" ? (r3) => t({ style: r3 }).style : t;
    } });
  }
  function gr() {
    if (typeof globalThis < "u") return globalThis;
    if (typeof self < "u") return self;
    if (typeof window < "u") return window;
    if (typeof global < "u") return global;
  }
  function pe(t, e4) {
    let n = gr();
    return n ? (n[t] || (n[t] = e4()), n[t]) : e4();
  }
  function Ct(t = {}) {
    return Er(t);
  }
  function Lt(t, e4, n) {
    let r3 = L.get(t);
    ct() && !r3 && console.warn("Please use proxy object");
    let o2, s = [], c5 = r3[3], i = false, d4 = c5((h6) => {
      if (s.push(h6), n) {
        e4(s.splice(0));
        return;
      }
      o2 || (o2 = Promise.resolve().then(() => {
        o2 = void 0, i && e4(s.splice(0));
      }));
    });
    return i = true, () => {
      i = false, d4();
    };
  }
  function Ar(t) {
    let e4 = L.get(t);
    ct() && !e4 && console.warn("Please use proxy object");
    let [n, r3, o2] = e4;
    return o2(n, r3());
  }
  function ye(t, e4, n) {
    let r3 = n || "default", o2 = at.get(t);
    o2 || (o2 = /* @__PURE__ */ new Map(), at.set(t, o2));
    let s = o2.get(r3) || {}, c5 = Object.keys(e4), i = (f4, b10) => {
      t.addEventListener(f4.toLowerCase(), b10);
    }, l4 = (f4, b10) => {
      t.removeEventListener(f4.toLowerCase(), b10);
    }, d4 = (f4) => f4.startsWith("on"), h6 = (f4) => !f4.startsWith("on"), a3 = (f4) => i(f4.substring(2), e4[f4]), u3 = (f4) => l4(f4.substring(2), e4[f4]), p4 = (f4) => {
      let b10 = e4[f4], O10 = s[f4];
      if (b10 !== O10) {
        if (f4 === "class") {
          t.className = b10 != null ? b10 : "";
          return;
        }
        if (me.has(f4)) {
          t[f4] = b10 != null ? b10 : "";
          return;
        }
        if (typeof b10 == "boolean" && !f4.includes("aria-")) {
          t.toggleAttribute(ut(t, f4), b10);
          return;
        }
        if (f4 === "children") {
          t.innerHTML = b10;
          return;
        }
        if (b10 != null) {
          t.setAttribute(ut(t, f4), b10);
          return;
        }
        t.removeAttribute(ut(t, f4));
      }
    };
    for (let f4 in s) e4[f4] == null && (f4 === "class" ? t.className = "" : me.has(f4) ? t[f4] = "" : t.removeAttribute(ut(t, f4)));
    return Object.keys(s).filter(d4).forEach((f4) => {
      l4(f4.substring(2), s[f4]);
    }), c5.filter(d4).forEach(a3), c5.filter(h6).forEach(p4), o2.set(r3, e4), function() {
      c5.filter(d4).forEach(u3);
      let b10 = at.get(t);
      b10 && (b10.delete(r3), b10.size === 0 && at.delete(t));
    };
  }
  function lt(t) {
    var _a2, _b;
    let e4 = (_a2 = t().value) != null ? _a2 : t().defaultValue;
    t().debug && console.log(`[bindable > ${t().debug}] initial`, e4);
    let n = (_b = t().isEqual) != null ? _b : Object.is, r3 = Ct({ value: e4 }), o2 = () => t().value !== void 0;
    return { initial: e4, ref: r3, get() {
      return o2() ? t().value : r3.value;
    }, set(s) {
      var _a3, _b2;
      let c5 = r3.value, i = C(s) ? s(c5) : s;
      t().debug && console.log(`[bindable > ${t().debug}] setValue`, { next: i, prev: c5 }), o2() || (r3.value = i), n(i, c5) || ((_b2 = (_a3 = t()).onChange) == null ? void 0 : _b2.call(_a3, i, c5));
    }, invoke(s, c5) {
      var _a3, _b2;
      (_b2 = (_a3 = t()).onChange) == null ? void 0 : _b2.call(_a3, s, c5);
    }, hash(s) {
      var _a3, _b2, _c;
      return (_c = (_b2 = (_a3 = t()).hash) == null ? void 0 : _b2.call(_a3, s)) != null ? _c : String(s);
    } };
  }
  function Nr(t) {
    let e4 = { current: t };
    return { get(n) {
      return e4.current[n];
    }, set(n, r3) {
      e4.current[n] = r3;
    } };
  }
  function be(t, e4) {
    if (!F(t) || !F(e4)) return e4 === void 0 ? t : e4;
    let n = __spreadValues({}, t);
    for (let r3 of Object.keys(e4)) {
      let o2 = e4[r3], s = t[r3];
      o2 !== void 0 && (F(s) && F(o2) ? n[r3] = be(s, o2) : n[r3] = o2);
    }
    return n;
  }
  var we, xr, Cr, Lr, _r, Ir, G, I, Ee, Ae, Pe, ft, It, Se, dt, N, Z, Fr, jr, Br, Te, Oe, Re, S, yt, Me, Vt, ke, z, xe, $r, Ce, Le, ht, wt, Ke, Kt, Q, Et, Ft, We, Gr, qe, He, At, Ue, tt, Xr, Ye, Ge, ro, oo, so, Qe, tn, Dt, nn, rn, P, Bt, dn, hn, pn, et, mn, bn, Sn, Tn, D, mt, J, St, Ro, Cn, Ln, _n, xo, Co, jn, Jt, Bn, x, $n, Ht, zn, Io, Wn, qn, Hn, Un, Do, Vo, Ko, Ut, Gn, V, Xn, zo, te, Wo, K, C, qo, Jn, Zn, ee, Qn, F, tr, er, nr, H, Ho, ne, Uo, re, Yo, oe, Yt, se, or, sr, ir, cr, Ot, j, Xo, Jo, Zo, Qo, ts, Gt, es, ns, rs, Xt, ie, os, ss, is, as, rt, ot, ce, ur, lr, ae, fr, B, st, As, Ss, hr, fe, Nt, pr, de, kt, it, mr, yr, br, vr, xt, he, ct, L, wr, Er, Pr, Sr, w, ge, Tr, Or, Cs, at, me, Rr, Mr, ut, Ls, ve;
  var init_chunk_IYURAQ6S = __esm({
    "../priv/static/chunk-IYURAQ6S.mjs"() {
      "use strict";
      we = ["ltr", "rtl"];
      xr = (t, e4, n) => {
        let r3 = t.dataset[e4];
        if (r3 !== void 0 && (!n || n.includes(r3))) return r3;
      };
      Cr = (t, e4) => {
        let n = t.dataset[e4];
        if (typeof n == "string") return n.split(",").map((r3) => r3.trim()).filter((r3) => r3.length > 0);
      };
      Lr = (t, e4, n) => {
        let r3 = t.dataset[e4];
        if (r3 === void 0) return;
        let o2 = Number(r3);
        if (!Number.isNaN(o2)) return n && !n.includes(o2) ? 0 : o2;
      };
      _r = (t, e4) => {
        let n = e4.replace(/([A-Z])/g, "-$1").toLowerCase();
        return t.hasAttribute(`data-${n}`);
      };
      Ir = (t, e4 = "element") => (t == null ? void 0 : t.id) ? t.id : `${e4}-${Math.random().toString(36).substring(2, 9)}`;
      G = (t, e4 = []) => ({ parts: (...n) => {
        if (Ee(e4)) return G(t, n);
        throw new Error("createAnatomy().parts(...) should only be called once. Did you mean to use .extendWith(...) ?");
      }, extendWith: (...n) => G(t, [...e4, ...n]), omit: (...n) => G(t, e4.filter((r3) => !n.includes(r3))), rename: (n) => G(n, e4), keys: () => e4, build: () => [...new Set(e4)].reduce((n, r3) => Object.assign(n, { [r3]: { selector: [`&[data-scope="${I(t)}"][data-part="${I(r3)}"]`, `& [data-scope="${I(t)}"][data-part="${I(r3)}"]`].join(", "), attrs: { "data-scope": I(t), "data-part": I(r3) } } }), {}) });
      I = (t) => t.replace(/([A-Z])([A-Z])/g, "$1-$2").replace(/([a-z])([A-Z])/g, "$1-$2").replace(/[\s_]+/g, "-").toLowerCase();
      Ee = (t) => t.length === 0;
      Ae = Object.defineProperty;
      Pe = (t, e4, n) => e4 in t ? Ae(t, e4, { enumerable: true, configurable: true, writable: true, value: n }) : t[e4] = n;
      ft = (t, e4, n) => Pe(t, typeof e4 != "symbol" ? e4 + "" : e4, n);
      It = (t) => Math.max(0, Math.min(1, t));
      Se = (t, e4) => t.map((n, r3) => t[(Math.max(e4, 0) + r3) % t.length]);
      dt = (...t) => (e4) => t.reduce((n, r3) => r3(n), e4);
      N = () => {
      };
      Z = (t) => typeof t == "object" && t !== null;
      Fr = 2147483647;
      jr = (t) => t ? "" : void 0;
      Br = (t) => t ? "true" : void 0;
      Te = 1;
      Oe = 9;
      Re = 11;
      S = (t) => Z(t) && t.nodeType === Te && typeof t.nodeName == "string";
      yt = (t) => Z(t) && t.nodeType === Oe;
      Me = (t) => Z(t) && t === t.window;
      Vt = (t) => S(t) ? t.localName || "" : "#document";
      ke = (t) => Z(t) && t.nodeType !== void 0;
      z = (t) => ke(t) && t.nodeType === Re && "host" in t;
      xe = (t) => S(t) && t.localName === "input";
      $r = (t) => !!(t == null ? void 0 : t.matches("a[href]"));
      Ce = (t) => S(t) ? t.offsetWidth > 0 || t.offsetHeight > 0 || t.getClientRects().length > 0 : false;
      Le = /(textarea|select)/;
      ht = /* @__PURE__ */ new WeakMap();
      wt = /* @__PURE__ */ new Set(["menu", "listbox", "dialog", "grid", "tree", "region"]);
      Ke = (t) => wt.has(t);
      Kt = (t) => {
        var _a2;
        return ((_a2 = t.getAttribute("aria-controls")) == null ? void 0 : _a2.split(" ")) || [];
      };
      Q = () => typeof document < "u";
      Et = (t) => Q() && t.test($e());
      Ft = (t) => Q() && t.test(ze());
      We = (t) => Q() && t.test(navigator.vendor);
      Gr = () => Q() && !!navigator.maxTouchPoints;
      qe = () => Et(/^iPhone/i);
      He = () => Et(/^iPad/i) || tt() && navigator.maxTouchPoints > 1;
      At = () => qe() || He();
      Ue = () => tt() || At();
      tt = () => Et(/^Mac/i);
      Xr = () => Ue() && We(/apple/i);
      Ye = () => Ft(/Firefox/i);
      Ge = () => Ft(/Android/i);
      ro = (t) => t.button === 0;
      oo = (t) => t.button === 2 || tt() && t.ctrlKey && t.button === 0;
      so = (t) => t.ctrlKey || t.altKey || t.metaKey;
      Qe = (t) => "touches" in t && t.touches.length > 0;
      tn = { Up: "ArrowUp", Down: "ArrowDown", Esc: "Escape", " ": "Space", ",": "Comma", Left: "ArrowLeft", Right: "ArrowRight" };
      Dt = { ArrowLeft: "ArrowRight", ArrowRight: "ArrowLeft" };
      nn = /* @__PURE__ */ new Set(["PageUp", "PageDown"]);
      rn = /* @__PURE__ */ new Set(["ArrowUp", "ArrowDown", "ArrowLeft", "ArrowRight"]);
      P = (t, e4, n, r3) => {
        let o2 = typeof t == "function" ? t() : t;
        return o2 == null ? void 0 : o2.addEventListener(e4, n, r3), () => {
          o2 == null ? void 0 : o2.removeEventListener(e4, n, r3);
        };
      };
      Bt = (t) => S(t) && t.tagName === "IFRAME";
      dn = /^(audio|video|details)$/;
      hn = (t) => !Number.isNaN($t(t));
      pn = (t) => $t(t) < 0;
      et = "input:not([type='hidden']):not([disabled]), select:not([disabled]), textarea:not([disabled]), a[href], button:not([disabled]), [tabindex], iframe, object, embed, area[href], audio[controls], video[controls], [contenteditable]:not([contenteditable='false']), details > summary:first-of-type";
      mn = (t, e4 = {}) => {
        if (!t) return [];
        let { includeContainer: n = false, getShadowRoot: r3 } = e4, o2 = Array.from(t.querySelectorAll(et));
        (n == true || n == "if-empty" && o2.length === 0) && S(t) && X(t) && o2.unshift(t);
        let c5 = [];
        for (let i of o2) if (X(i)) {
          if (Bt(i) && i.contentDocument) {
            let l4 = i.contentDocument.body;
            c5.push(...mn(l4, { getShadowRoot: r3 }));
            continue;
          }
          c5.push(i);
        }
        return r3 ? zt(c5, r3, X) : c5;
      };
      bn = class Wt {
        constructor() {
          ft(this, "id", null), ft(this, "fn_cleanup"), ft(this, "cleanup", () => {
            this.cancel();
          });
        }
        static create() {
          return new Wt();
        }
        request(e4) {
          this.cancel(), this.id = globalThis.requestAnimationFrame(() => {
            this.id = null, this.fn_cleanup = e4 == null ? void 0 : e4();
          });
        }
        cancel() {
          var _a2;
          this.id !== null && (globalThis.cancelAnimationFrame(this.id), this.id = null), (_a2 = this.fn_cleanup) == null ? void 0 : _a2.call(this), this.fn_cleanup = void 0;
        }
        isActive() {
          return this.id !== null;
        }
      };
      Sn = /auto|scroll|overlay|hidden|clip/;
      Tn = /* @__PURE__ */ new Set(["inline", "contents"]);
      D = "default";
      mt = "";
      J = /* @__PURE__ */ new WeakMap();
      St = (t) => t.id;
      Ro = xn({ box: "border-box" });
      Cn = (t) => t.split("").map((e4) => {
        let n = e4.charCodeAt(0);
        return n > 0 && n < 128 ? e4 : n >= 128 && n <= 255 ? `/x${n.toString(16)}`.replace("/", "\\") : "";
      }).join("").trim();
      Ln = (t) => {
        var _a2, _b, _c;
        return Cn((_c = (_b = (_a2 = t.dataset) == null ? void 0 : _a2.valuetext) != null ? _b : t.textContent) != null ? _c : "");
      };
      _n = (t, e4) => t.trim().toLowerCase().startsWith(e4.toLowerCase());
      xo = Object.assign(Vn, { defaultOptions: { keysSoFar: "", timer: -1 }, isValidEvent: Kn });
      Co = { border: "0", clip: "rect(0 0 0 0)", height: "1px", margin: "-1px", overflow: "hidden", padding: "0", position: "absolute", width: "1px", whiteSpace: "nowrap", wordWrap: "normal" };
      jn = Object.defineProperty;
      Jt = (t) => {
        throw TypeError(t);
      };
      Bn = (t, e4, n) => e4 in t ? jn(t, e4, { enumerable: true, configurable: true, writable: true, value: n }) : t[e4] = n;
      x = (t, e4, n) => Bn(t, typeof e4 != "symbol" ? e4 + "" : e4, n);
      $n = (t, e4, n) => e4.has(t) || Jt("Cannot " + n);
      Ht = (t, e4, n) => ($n(t, e4, "read from private field"), e4.get(t));
      zn = (t, e4, n) => e4.has(t) ? Jt("Cannot add the same private member more than once") : e4 instanceof WeakSet ? e4.add(t) : e4.set(t, n);
      Io = (t) => t[0];
      Wn = (t) => t[t.length - 1];
      qn = (t, e4) => t.indexOf(e4) !== -1;
      Hn = (t, ...e4) => t.concat(e4);
      Un = (t, ...e4) => t.filter((n) => !e4.includes(n));
      Do = (t) => Array.from(new Set(t));
      Vo = (t, e4) => {
        let n = new Set(e4);
        return t.filter((r3) => !n.has(r3));
      };
      Ko = (t, e4) => qn(t, e4) ? Un(t, e4) : Hn(t, e4);
      Ut = (t) => (t == null ? void 0 : t.constructor.name) === "Array";
      Gn = (t, e4) => {
        if (t.length !== e4.length) return false;
        for (let n = 0; n < t.length; n++) if (!V(t[n], e4[n])) return false;
        return true;
      };
      V = (t, e4) => {
        if (Object.is(t, e4)) return true;
        if (t == null && e4 != null || t != null && e4 == null) return false;
        if (typeof (t == null ? void 0 : t.isEqual) == "function" && typeof (e4 == null ? void 0 : e4.isEqual) == "function") return t.isEqual(e4);
        if (typeof t == "function" && typeof e4 == "function") return t.toString() === e4.toString();
        if (Ut(t) && Ut(e4)) return Gn(Array.from(t), Array.from(e4));
        if (typeof t != "object" || typeof e4 != "object") return false;
        let n = Object.keys(e4 != null ? e4 : /* @__PURE__ */ Object.create(null)), r3 = n.length;
        for (let o2 = 0; o2 < r3; o2++) if (!Reflect.has(t, n[o2])) return false;
        for (let o2 = 0; o2 < r3; o2++) {
          let s = n[o2];
          if (!V(t[s], e4[s])) return false;
        }
        return true;
      };
      Xn = (t) => Array.isArray(t);
      zo = (t) => t === true || t === false;
      te = (t) => t != null && typeof t == "object";
      Wo = (t) => te(t) && !Xn(t);
      K = (t) => typeof t == "string";
      C = (t) => typeof t == "function";
      qo = (t) => t == null;
      Jn = (t, e4) => Object.prototype.hasOwnProperty.call(t, e4);
      Zn = (t) => Object.prototype.toString.call(t);
      ee = Function.prototype.toString;
      Qn = ee.call(Object);
      F = (t) => {
        if (!te(t) || Zn(t) != "[object Object]" || nr(t)) return false;
        let e4 = Object.getPrototypeOf(t);
        if (e4 === null) return true;
        let n = Jn(e4, "constructor") && e4.constructor;
        return typeof n == "function" && n instanceof n && ee.call(n) == Qn;
      };
      tr = (t) => typeof t == "object" && t !== null && "$$typeof" in t && "props" in t;
      er = (t) => typeof t == "object" && t !== null && "__v_isVNode" in t;
      nr = (t) => tr(t) || er(t);
      H = (t, ...e4) => {
        var _a2;
        return (_a2 = typeof t == "function" ? t(...e4) : t) != null ? _a2 : void 0;
      };
      Ho = (t) => t;
      ne = (t) => t();
      Uo = () => {
      };
      re = (...t) => (...e4) => {
        t.forEach(function(n) {
          n == null ? void 0 : n(...e4);
        });
      };
      Yo = /* @__PURE__ */ (() => {
        let t = 0;
        return () => (t++, t.toString(36));
      })();
      ({ floor: oe, abs: Yt, round: se, min: or, max: sr, pow: ir, sign: cr } = Math);
      Ot = (t) => Number.isNaN(t);
      j = (t) => Ot(t) ? 0 : t;
      Xo = (t, e4) => (t % e4 + e4) % e4;
      Jo = (t, e4) => j(t) >= e4;
      Zo = (t, e4) => j(t) <= e4;
      Qo = (t, e4, n) => {
        let r3 = j(t), o2 = e4 == null || r3 >= e4, s = n == null || r3 <= n;
        return o2 && s;
      };
      ts = (t, e4, n) => or(sr(j(t), e4), n);
      Gt = (t, e4) => {
        let n = t, r3 = e4.toString(), o2 = r3.indexOf("."), s = o2 >= 0 ? r3.length - o2 : 0;
        if (s > 0) {
          let c5 = ir(10, s);
          n = se(n * c5) / c5;
        }
        return n;
      };
      es = (t, e4) => typeof e4 == "number" ? oe(t * e4 + 0.5) / e4 : se(t);
      ns = (t, e4, n, r3) => {
        let o2 = e4 != null ? Number(e4) : 0, s = Number(n), c5 = (t - o2) % r3, i = Yt(c5) * 2 >= r3 ? t + cr(c5) * (r3 - Yt(c5)) : t - c5;
        if (i = Gt(i, r3), !Ot(o2) && i < o2) i = o2;
        else if (!Ot(s) && i > s) {
          let l4 = oe((s - o2) / r3), d4 = o2 + l4 * r3;
          i = l4 <= 0 || d4 < o2 ? s : d4;
        }
        return Gt(i, r3);
      };
      rs = (t, e4, n) => t[e4] === n ? t : [...t.slice(0, e4), n, ...t.slice(e4 + 1)];
      Xt = (t) => {
        if (!Number.isFinite(t)) return 0;
        let e4 = 1, n = 0;
        for (; Math.round(t * e4) / e4 !== t; ) e4 *= 10, n += 1;
        return n;
      };
      ie = (t, e4, n) => {
        let r3 = e4 === "+" ? t + n : t - n;
        if (t % 1 !== 0 || n % 1 !== 0) {
          let o2 = 10 ** Math.max(Xt(t), Xt(n));
          t = Math.round(t * o2), n = Math.round(n * o2), r3 = e4 === "+" ? t + n : t - n, r3 /= o2;
        }
        return r3;
      };
      os = (t, e4) => ie(j(t), "+", e4);
      ss = (t, e4) => ie(j(t), "-", e4);
      is = (t) => typeof t == "number" ? `${t}px` : t;
      as = (t) => function(n) {
        return ar(n, t);
      };
      rt = () => performance.now();
      ce = class {
        constructor(t) {
          this.onTick = t, x(this, "frameId", null), x(this, "pausedAtMs", null), x(this, "context"), x(this, "cancelFrame", () => {
            this.frameId !== null && (cancelAnimationFrame(this.frameId), this.frameId = null);
          }), x(this, "setStartMs", (e4) => {
            this.context.startMs = e4;
          }), x(this, "start", () => {
            if (this.frameId !== null) return;
            let e4 = rt();
            this.pausedAtMs !== null ? (this.context.startMs += e4 - this.pausedAtMs, this.pausedAtMs = null) : this.context.startMs = e4, this.frameId = requestAnimationFrame(Ht(this, ot));
          }), x(this, "pause", () => {
            this.frameId !== null && (this.cancelFrame(), this.pausedAtMs = rt());
          }), x(this, "stop", () => {
            this.frameId !== null && (this.cancelFrame(), this.pausedAtMs = null);
          }), zn(this, ot, (e4) => {
            if (this.context.now = e4, this.context.deltaMs = e4 - this.context.startMs, this.onTick(this.context) === false) {
              this.stop();
              return;
            }
            this.frameId = requestAnimationFrame(Ht(this, ot));
          }), this.context = { now: 0, startMs: rt(), deltaMs: 0 };
        }
        get elapsedMs() {
          return this.pausedAtMs !== null ? this.pausedAtMs - this.context.startMs : rt() - this.context.startMs;
        }
      };
      ot = /* @__PURE__ */ new WeakMap();
      ur = (...t) => t.map((e4) => {
        var _a2;
        return (_a2 = e4 == null ? void 0 : e4.trim) == null ? void 0 : _a2.call(e4);
      }).filter(Boolean).join(" ");
      lr = /((?:--)?(?:\w+-?)+)\s*:\s*([^;]*)/g;
      ae = (t) => {
        let e4 = {}, n;
        for (; n = lr.exec(t); ) e4[n[1]] = n[2];
        return e4;
      };
      fr = (t, e4) => {
        if (K(t)) {
          if (K(e4)) return `${t};${e4}`;
          t = ae(t);
        } else K(e4) && (e4 = ae(e4));
        return Object.assign({}, t != null ? t : {}, e4 != null ? e4 : {});
      };
      B = ((t) => (t.NotStarted = "Not Started", t.Started = "Started", t.Stopped = "Stopped", t))(B || {});
      st = "__init__";
      As = () => (t) => Array.from(new Set(t));
      Ss = Symbol();
      hr = Symbol();
      fe = Object.getPrototypeOf;
      Nt = /* @__PURE__ */ new WeakMap();
      pr = (t) => t && (Nt.has(t) ? Nt.get(t) : fe(t) === Object.prototype || fe(t) === Array.prototype);
      de = (t) => pr(t) && t[hr] || null;
      kt = (t, e4 = true) => {
        Nt.set(t, e4);
      };
      it = pe("__zag__refSet", () => /* @__PURE__ */ new WeakSet());
      mr = (t) => typeof t == "object" && t !== null && "$$typeof" in t && "props" in t;
      yr = (t) => typeof t == "object" && t !== null && "__v_isVNode" in t;
      br = (t) => typeof t == "object" && t !== null && "nodeType" in t && typeof t.nodeName == "string";
      vr = (t) => mr(t) || yr(t) || br(t);
      xt = (t) => t !== null && typeof t == "object";
      he = (t) => xt(t) && !it.has(t) && (Array.isArray(t) || !(Symbol.iterator in t)) && !vr(t) && !(t instanceof WeakMap) && !(t instanceof WeakSet) && !(t instanceof Error) && !(t instanceof Number) && !(t instanceof Date) && !(t instanceof String) && !(t instanceof RegExp) && !(t instanceof ArrayBuffer) && !(t instanceof Promise) && !(t instanceof File) && !(t instanceof Blob) && !(t instanceof AbortController);
      ct = () => false;
      L = pe("__zag__proxyStateMap", () => /* @__PURE__ */ new WeakMap());
      wr = (t = Object.is, e4 = (i, l4) => new Proxy(i, l4), n = /* @__PURE__ */ new WeakMap(), r3 = (i, l4) => {
        let d4 = n.get(i);
        if ((d4 == null ? void 0 : d4[0]) === l4) return d4[1];
        let h6 = Array.isArray(i) ? [] : Object.create(Object.getPrototypeOf(i));
        return kt(h6, true), n.set(i, [l4, h6]), Reflect.ownKeys(i).forEach((a3) => {
          let u3 = Reflect.get(i, a3);
          it.has(u3) ? (kt(u3, false), h6[a3] = u3) : L.has(u3) ? h6[a3] = Ar(u3) : h6[a3] = u3;
        }), Object.freeze(h6);
      }, o2 = /* @__PURE__ */ new WeakMap(), s = [1, 1], c5 = (i) => {
        if (!xt(i)) throw new Error("object required");
        let l4 = o2.get(i);
        if (l4) return l4;
        let d4 = s[0], h6 = /* @__PURE__ */ new Set(), a3 = (m5, y11 = ++s[0]) => {
          d4 !== y11 && (d4 = y11, h6.forEach((v10) => v10(m5, y11)));
        }, u3 = s[1], p4 = (m5 = ++s[1]) => (u3 !== m5 && !h6.size && (u3 = m5, f4.forEach(([y11]) => {
          let v10 = y11[1](m5);
          v10 > d4 && (d4 = v10);
        })), d4), g7 = (m5) => (y11, v10) => {
          let A12 = [...y11];
          A12[1] = [m5, ...A12[1]], a3(A12, v10);
        }, f4 = /* @__PURE__ */ new Map(), b10 = (m5, y11) => {
          if (ct() && f4.has(m5)) throw new Error("prop listener already exists");
          if (h6.size) {
            let v10 = y11[3](g7(m5));
            f4.set(m5, [y11, v10]);
          } else f4.set(m5, [y11]);
        }, O10 = (m5) => {
          var _a2;
          let y11 = f4.get(m5);
          y11 && (f4.delete(m5), (_a2 = y11[1]) == null ? void 0 : _a2.call(y11));
        }, E15 = (m5) => (h6.add(m5), h6.size === 1 && f4.forEach(([v10, A12], M10) => {
          if (ct() && A12) throw new Error("remove already exists");
          let $13 = v10[3](g7(M10));
          f4.set(M10, [v10, $13]);
        }), () => {
          h6.delete(m5), h6.size === 0 && f4.forEach(([v10, A12], M10) => {
            A12 && (A12(), f4.set(M10, [v10]));
          });
        }), _12 = Array.isArray(i) ? [] : Object.create(Object.getPrototypeOf(i)), k14 = e4(_12, { deleteProperty(m5, y11) {
          let v10 = Reflect.get(m5, y11);
          O10(y11);
          let A12 = Reflect.deleteProperty(m5, y11);
          return A12 && a3(["delete", [y11], v10]), A12;
        }, set(m5, y11, v10, A12) {
          var _a2;
          let M10 = Reflect.has(m5, y11), $13 = Reflect.get(m5, y11, A12);
          if (M10 && (t($13, v10) || o2.has(v10) && t($13, o2.get(v10)))) return true;
          O10(y11), xt(v10) && (v10 = de(v10) || v10);
          let Y16 = v10;
          if (!((_a2 = Object.getOwnPropertyDescriptor(m5, y11)) == null ? void 0 : _a2.set)) {
            !L.has(v10) && he(v10) && (Y16 = Ct(v10));
            let _t4 = !it.has(Y16) && L.get(Y16);
            _t4 && b10(y11, _t4);
          }
          return Reflect.set(m5, y11, Y16, A12), a3(["set", [y11], v10, $13]), true;
        } });
        o2.set(i, k14);
        let R7 = [_12, p4, r3, E15];
        return L.set(k14, R7), Reflect.ownKeys(i).forEach((m5) => {
          let y11 = Object.getOwnPropertyDescriptor(i, m5);
          y11.get || y11.set ? Object.defineProperty(_12, m5, y11) : k14[m5] = i[m5];
        }), k14;
      }) => [c5, L, it, t, e4, he, n, r3, o2, s];
      [Er] = wr();
      Pr = Object.defineProperty;
      Sr = (t, e4, n) => e4 in t ? Pr(t, e4, { enumerable: true, configurable: true, writable: true, value: n }) : t[e4] = n;
      w = (t, e4, n) => Sr(t, typeof e4 != "symbol" ? e4 + "" : e4, n);
      ge = { onFocus: "onFocusin", onBlur: "onFocusout", onChange: "onInput", onDoubleClick: "onDblclick", htmlFor: "for", className: "class", defaultValue: "value", defaultChecked: "checked" };
      Tr = /* @__PURE__ */ new Set(["viewBox", "preserveAspectRatio"]);
      Or = (t) => {
        let e4 = "";
        for (let n in t) {
          let r3 = t[n];
          r3 != null && (n.startsWith("--") || (n = n.replace(/[A-Z]/g, (o2) => `-${o2.toLowerCase()}`)), e4 += `${n}:${r3};`);
        }
        return e4;
      };
      Cs = le((t) => Object.entries(t).reduce((e4, [n, r3]) => {
        if (r3 === void 0) return e4;
        if (n in ge && (n = ge[n]), n === "style" && typeof r3 == "object") return e4.style = Or(r3), e4;
        let o2 = Tr.has(n) ? n : n.toLowerCase();
        return e4[o2] = r3, e4;
      }, {}));
      at = /* @__PURE__ */ new WeakMap();
      me = /* @__PURE__ */ new Set(["value", "checked", "selected"]);
      Rr = /* @__PURE__ */ new Set(["viewBox", "preserveAspectRatio", "clipPath", "clipRule", "fillRule", "strokeWidth", "strokeLinecap", "strokeLinejoin", "strokeDasharray", "strokeDashoffset", "strokeMiterlimit"]);
      Mr = (t) => t.tagName === "svg" || t.namespaceURI === "http://www.w3.org/2000/svg";
      ut = (t, e4) => Mr(t) && Rr.has(e4) ? e4 : e4.toLowerCase();
      lt.cleanup = (t) => {
      };
      lt.ref = (t) => {
        let e4 = t;
        return { get: () => e4, set: (n) => {
          e4 = n;
        } };
      };
      Ls = class {
        constructor(t, e4 = {}) {
          var _a2, _b, _c;
          this.machine = t, w(this, "scope"), w(this, "context"), w(this, "prop"), w(this, "state"), w(this, "refs"), w(this, "computed"), w(this, "event", { type: "" }), w(this, "previousEvent", { type: "" }), w(this, "effects", /* @__PURE__ */ new Map()), w(this, "transition", null), w(this, "cleanups", []), w(this, "subscriptions", []), w(this, "userPropsRef"), w(this, "getEvent", () => __spreadProps(__spreadValues({}, this.event), { current: () => this.event, previous: () => this.previousEvent })), w(this, "getStateConfig", (a3) => this.machine.states[a3]), w(this, "getState", () => __spreadProps(__spreadValues({}, this.state), { matches: (...a3) => a3.includes(this.state.get()), hasTag: (a3) => {
            var _a3, _b2;
            return !!((_b2 = (_a3 = this.getStateConfig(this.state.get())) == null ? void 0 : _a3.tags) == null ? void 0 : _b2.includes(a3));
          } })), w(this, "debug", (...a3) => {
            this.machine.debug && console.log(...a3);
          }), w(this, "notify", () => {
            this.publish();
          }), w(this, "send", (a3) => {
            this.status === B.Started && queueMicrotask(() => {
              var _a3, _b2, _c2, _d, _e9;
              if (!a3) return;
              this.previousEvent = this.event, this.event = a3, this.debug("send", a3);
              let u3 = this.state.get(), p4 = a3.type, g7 = (_d = (_b2 = (_a3 = this.getStateConfig(u3)) == null ? void 0 : _a3.on) == null ? void 0 : _b2[p4]) != null ? _d : (_c2 = this.machine.on) == null ? void 0 : _c2[p4], f4 = this.choose(g7);
              if (!f4) return;
              this.transition = f4;
              let b10 = (_e9 = f4.target) != null ? _e9 : u3;
              this.debug("transition", f4);
              let O10 = b10 !== u3;
              O10 ? this.state.set(b10) : f4.reenter && !O10 ? this.state.invoke(u3, u3) : this.action(f4.actions);
            });
          }), w(this, "action", (a3) => {
            let u3 = C(a3) ? a3(this.getParams()) : a3;
            if (!u3) return;
            let p4 = u3.map((g7) => {
              var _a3, _b2;
              let f4 = (_b2 = (_a3 = this.machine.implementations) == null ? void 0 : _a3.actions) == null ? void 0 : _b2[g7];
              return f4 || Mt(`[zag-js] No implementation found for action "${JSON.stringify(g7)}"`), f4;
            });
            for (let g7 of p4) g7 == null ? void 0 : g7(this.getParams());
          }), w(this, "guard", (a3) => {
            var _a3, _b2;
            return C(a3) ? a3(this.getParams()) : (_b2 = (_a3 = this.machine.implementations) == null ? void 0 : _a3.guards) == null ? void 0 : _b2[a3](this.getParams());
          }), w(this, "effect", (a3) => {
            let u3 = C(a3) ? a3(this.getParams()) : a3;
            if (!u3) return;
            let p4 = u3.map((f4) => {
              var _a3, _b2;
              let b10 = (_b2 = (_a3 = this.machine.implementations) == null ? void 0 : _a3.effects) == null ? void 0 : _b2[f4];
              return b10 || Mt(`[zag-js] No implementation found for effect "${JSON.stringify(f4)}"`), b10;
            }), g7 = [];
            for (let f4 of p4) {
              let b10 = f4 == null ? void 0 : f4(this.getParams());
              b10 && g7.push(b10);
            }
            return () => g7.forEach((f4) => f4 == null ? void 0 : f4());
          }), w(this, "choose", (a3) => Zt(a3).find((u3) => {
            let p4 = !u3.guard;
            return K(u3.guard) ? p4 = !!this.guard(u3.guard) : C(u3.guard) && (p4 = u3.guard(this.getParams())), p4;
          })), w(this, "subscribe", (a3) => (this.subscriptions.push(a3), () => {
            let u3 = this.subscriptions.indexOf(a3);
            u3 > -1 && this.subscriptions.splice(u3, 1);
          })), w(this, "status", B.NotStarted), w(this, "publish", () => {
            this.callTrackers(), this.subscriptions.forEach((a3) => a3(this.service));
          }), w(this, "trackers", []), w(this, "setupTrackers", () => {
            var _a3, _b2;
            (_b2 = (_a3 = this.machine).watch) == null ? void 0 : _b2.call(_a3, this.getParams());
          }), w(this, "callTrackers", () => {
            this.trackers.forEach(({ deps: a3, fn: u3 }) => {
              let p4 = a3.map((g7) => g7());
              V(u3.prev, p4) || (u3(), u3.prev = p4);
            });
          }), w(this, "getParams", () => ({ state: this.getState(), context: this.context, event: this.getEvent(), prop: this.prop, send: this.send, action: this.action, guard: this.guard, track: (a3, u3) => {
            u3.prev = a3.map((p4) => p4()), this.trackers.push({ deps: a3, fn: u3 });
          }, refs: this.refs, computed: this.computed, flush: ne, scope: this.scope, choose: this.choose })), this.userPropsRef = { current: e4 };
          let { id: n, ids: r3, getRootNode: o2 } = H(e4);
          this.scope = ue({ id: n, ids: r3, getRootNode: o2 });
          let s = (a3) => {
            var _a3, _b2;
            let u3 = H(this.userPropsRef.current);
            return ((_b2 = (_a3 = t.props) == null ? void 0 : _a3.call(t, { props: Rt(u3), scope: this.scope })) != null ? _b2 : u3)[a3];
          };
          this.prop = s;
          let c5 = (_a2 = t.context) == null ? void 0 : _a2.call(t, { prop: s, bindable: lt, scope: this.scope, flush(a3) {
            queueMicrotask(a3);
          }, getContext() {
            return i;
          }, getComputed() {
            return l4;
          }, getRefs() {
            return d4;
          }, getEvent: this.getEvent.bind(this) });
          c5 && Object.values(c5).forEach((a3) => {
            let u3 = Lt(a3.ref, () => this.notify());
            this.cleanups.push(u3);
          });
          let i = { get(a3) {
            return c5 == null ? void 0 : c5[a3].get();
          }, set(a3, u3) {
            c5 == null ? void 0 : c5[a3].set(u3);
          }, initial(a3) {
            return c5 == null ? void 0 : c5[a3].initial;
          }, hash(a3) {
            let u3 = c5 == null ? void 0 : c5[a3].get();
            return c5 == null ? void 0 : c5[a3].hash(u3);
          } };
          this.context = i;
          let l4 = (a3) => {
            var _a3, _b2;
            return (_b2 = (_a3 = t.computed) == null ? void 0 : _a3[a3]({ context: i, event: this.getEvent(), prop: s, refs: this.refs, scope: this.scope, computed: l4 })) != null ? _b2 : {};
          };
          this.computed = l4;
          let d4 = Nr((_c = (_b = t.refs) == null ? void 0 : _b.call(t, { prop: s, context: i })) != null ? _c : {});
          this.refs = d4;
          let h6 = lt(() => ({ defaultValue: t.initialState({ prop: s }), onChange: (a3, u3) => {
            var _a3, _b2, _c2, _d, _e9;
            u3 && ((_a3 = this.effects.get(u3)) == null ? void 0 : _a3(), this.effects.delete(u3)), u3 && this.action((_b2 = this.getStateConfig(u3)) == null ? void 0 : _b2.exit), this.action((_c2 = this.transition) == null ? void 0 : _c2.actions);
            let p4 = this.effect((_d = this.getStateConfig(a3)) == null ? void 0 : _d.effects);
            if (p4 && this.effects.set(a3, p4), u3 === st) {
              this.action(t.entry);
              let g7 = this.effect(t.effects);
              g7 && this.effects.set(st, g7);
            }
            this.action((_e9 = this.getStateConfig(a3)) == null ? void 0 : _e9.entry);
          } }));
          this.state = h6, this.cleanups.push(Lt(this.state.ref, () => this.notify()));
        }
        updateProps(t) {
          let e4 = this.userPropsRef.current;
          this.userPropsRef.current = () => {
            let n = H(e4), r3 = H(t);
            return be(n, r3);
          }, this.notify();
        }
        start() {
          this.status = B.Started, this.debug("initializing..."), this.state.invoke(this.state.initial, st), this.setupTrackers();
        }
        stop() {
          this.effects.forEach((t) => t == null ? void 0 : t()), this.effects.clear(), this.transition = null, this.action(this.machine.exit), this.cleanups.forEach((t) => t()), this.cleanups = [], this.subscriptions = [], this.status = B.Stopped, this.debug("unmounting...");
        }
        get service() {
          return { state: this.getState(), send: this.send, context: this.context, prop: this.prop, scope: this.scope, refs: this.refs, computed: this.computed, event: this.getEvent(), getStatus: () => this.status };
        }
      };
      ve = class {
        constructor(e4, n) {
          __publicField(this, "el");
          __publicField(this, "doc");
          __publicField(this, "machine");
          __publicField(this, "api");
          __publicField(this, "init", () => {
            this.render(), this.machine.subscribe(() => {
              this.api = this.initApi(), this.render();
            }), this.machine.start();
          });
          __publicField(this, "destroy", () => {
            this.machine.stop();
          });
          __publicField(this, "spreadProps", (e4, n) => {
            ye(e4, n, this.machine.scope.id);
          });
          __publicField(this, "updateProps", (e4) => {
            this.machine.updateProps(e4);
          });
          if (!e4) throw new Error("Root element not found");
          this.el = e4, this.doc = document, this.machine = this.initMachine(n), this.api = this.initApi();
        }
      };
    }
  });

  // ../priv/static/accordion.mjs
  var accordion_exports = {};
  __export(accordion_exports, {
    Accordion: () => Ve2
  });
  function U(e4, t) {
    let { send: a3, context: n, prop: o2, scope: r3, computed: c5 } = e4, u3 = n.get("focusedValue"), p4 = n.get("value"), T7 = o2("multiple");
    function b10(s) {
      let i = s;
      !T7 && i.length > 1 && (i = [i[0]]), a3({ type: "VALUE.SET", value: i });
    }
    function l4(s) {
      var _a2;
      return { expanded: p4.includes(s.value), focused: u3 === s.value, disabled: !!((_a2 = s.disabled) != null ? _a2 : o2("disabled")) };
    }
    return { focusedValue: u3, value: p4, setValue: b10, getItemState: l4, getRootProps() {
      return t.element(__spreadProps(__spreadValues({}, E.root.attrs), { dir: o2("dir"), id: V2(r3), "data-orientation": o2("orientation") }));
    }, getItemProps(s) {
      let i = l4(s);
      return t.element(__spreadProps(__spreadValues({}, E.item.attrs), { dir: o2("dir"), id: Q2(r3, s.value), "data-state": i.expanded ? "open" : "closed", "data-focus": jr(i.focused), "data-disabled": jr(i.disabled), "data-orientation": o2("orientation") }));
    }, getItemContentProps(s) {
      let i = l4(s);
      return t.element(__spreadProps(__spreadValues({}, E.itemContent.attrs), { dir: o2("dir"), role: "region", id: H2(r3, s.value), "aria-labelledby": y(r3, s.value), hidden: !i.expanded, "data-state": i.expanded ? "open" : "closed", "data-disabled": jr(i.disabled), "data-focus": jr(i.focused), "data-orientation": o2("orientation") }));
    }, getItemIndicatorProps(s) {
      let i = l4(s);
      return t.element(__spreadProps(__spreadValues({}, E.itemIndicator.attrs), { dir: o2("dir"), "aria-hidden": true, "data-state": i.expanded ? "open" : "closed", "data-disabled": jr(i.disabled), "data-focus": jr(i.focused), "data-orientation": o2("orientation") }));
    }, getItemTriggerProps(s) {
      let { value: i } = s, d4 = l4(s);
      return t.button(__spreadProps(__spreadValues({}, E.itemTrigger.attrs), { type: "button", dir: o2("dir"), id: y(r3, i), "aria-controls": H2(r3, i), "data-controls": H2(r3, i), "aria-expanded": d4.expanded, disabled: d4.disabled, "data-orientation": o2("orientation"), "aria-disabled": d4.disabled, "data-state": d4.expanded ? "open" : "closed", "data-ownedby": V2(r3), onFocus() {
        d4.disabled || a3({ type: "TRIGGER.FOCUS", value: i });
      }, onBlur() {
        d4.disabled || a3({ type: "TRIGGER.BLUR" });
      }, onClick(h6) {
        d4.disabled || (Xr() && h6.currentTarget.focus(), a3({ type: "TRIGGER.CLICK", value: i }));
      }, onKeyDown(h6) {
        if (h6.defaultPrevented || d4.disabled) return;
        let K19 = { ArrowDown() {
          c5("isHorizontal") || a3({ type: "GOTO.NEXT", value: i });
        }, ArrowUp() {
          c5("isHorizontal") || a3({ type: "GOTO.PREV", value: i });
        }, ArrowRight() {
          c5("isHorizontal") && a3({ type: "GOTO.NEXT", value: i });
        }, ArrowLeft() {
          c5("isHorizontal") && a3({ type: "GOTO.PREV", value: i });
        }, Home() {
          a3({ type: "GOTO.FIRST", value: i });
        }, End() {
          a3({ type: "GOTO.LAST", value: i });
        } }, X16 = io(h6, { dir: o2("dir"), orientation: o2("orientation") }), L13 = K19[X16];
        L13 && (L13(h6), h6.preventDefault());
      } }));
    } };
  }
  var J2, E, V2, Q2, H2, y, W2, I2, Y, Z2, ee2, te2, ae2, oe2, q2, ie2, pe2, ne2, ge2, C2, Ve2;
  var init_accordion = __esm({
    "../priv/static/accordion.mjs"() {
      "use strict";
      init_chunk_IYURAQ6S();
      J2 = G("accordion").parts("root", "item", "itemTrigger", "itemContent", "itemIndicator");
      E = J2.build();
      V2 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.root) != null ? _b : `accordion:${e4.id}`;
      };
      Q2 = (e4, t) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = e4.ids) == null ? void 0 : _a2.item) == null ? void 0 : _b.call(_a2, t)) != null ? _c : `accordion:${e4.id}:item:${t}`;
      };
      H2 = (e4, t) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = e4.ids) == null ? void 0 : _a2.itemContent) == null ? void 0 : _b.call(_a2, t)) != null ? _c : `accordion:${e4.id}:content:${t}`;
      };
      y = (e4, t) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = e4.ids) == null ? void 0 : _a2.itemTrigger) == null ? void 0 : _b.call(_a2, t)) != null ? _c : `accordion:${e4.id}:trigger:${t}`;
      };
      W2 = (e4) => e4.getById(V2(e4));
      I2 = (e4) => {
        let a3 = `[data-controls][data-ownedby='${CSS.escape(V2(e4))}']:not([disabled])`;
        return Po(W2(e4), a3);
      };
      Y = (e4) => Io(I2(e4));
      Z2 = (e4) => Wn(I2(e4));
      ee2 = (e4, t) => To(I2(e4), y(e4, t));
      te2 = (e4, t) => Oo(I2(e4), y(e4, t));
      ({ and: ae2, not: oe2 } = dr());
      q2 = { props({ props: e4 }) {
        return __spreadValues({ collapsible: false, multiple: false, orientation: "vertical", defaultValue: [] }, e4);
      }, initialState() {
        return "idle";
      }, context({ prop: e4, bindable: t }) {
        return { focusedValue: t(() => ({ defaultValue: null, sync: true, onChange(a3) {
          var _a2;
          (_a2 = e4("onFocusChange")) == null ? void 0 : _a2({ value: a3 });
        } })), value: t(() => ({ defaultValue: e4("defaultValue"), value: e4("value"), onChange(a3) {
          var _a2;
          (_a2 = e4("onValueChange")) == null ? void 0 : _a2({ value: a3 });
        } })) };
      }, computed: { isHorizontal: ({ prop: e4 }) => e4("orientation") === "horizontal" }, on: { "VALUE.SET": { actions: ["setValue"] } }, states: { idle: { on: { "TRIGGER.FOCUS": { target: "focused", actions: ["setFocusedValue"] } } }, focused: { on: { "GOTO.NEXT": { actions: ["focusNextTrigger"] }, "GOTO.PREV": { actions: ["focusPrevTrigger"] }, "TRIGGER.CLICK": [{ guard: ae2("isExpanded", "canToggle"), actions: ["collapse"] }, { guard: oe2("isExpanded"), actions: ["expand"] }], "GOTO.FIRST": { actions: ["focusFirstTrigger"] }, "GOTO.LAST": { actions: ["focusLastTrigger"] }, "TRIGGER.BLUR": { target: "idle", actions: ["clearFocusedValue"] } } } }, implementations: { guards: { canToggle: ({ prop: e4 }) => !!e4("collapsible") || !!e4("multiple"), isExpanded: ({ context: e4, event: t }) => e4.get("value").includes(t.value) }, actions: { collapse({ context: e4, prop: t, event: a3 }) {
        let n = t("multiple") ? Un(e4.get("value"), a3.value) : [];
        e4.set("value", n);
      }, expand({ context: e4, prop: t, event: a3 }) {
        let n = t("multiple") ? Hn(e4.get("value"), a3.value) : [a3.value];
        e4.set("value", n);
      }, focusFirstTrigger({ scope: e4 }) {
        var _a2;
        (_a2 = Y(e4)) == null ? void 0 : _a2.focus();
      }, focusLastTrigger({ scope: e4 }) {
        var _a2;
        (_a2 = Z2(e4)) == null ? void 0 : _a2.focus();
      }, focusNextTrigger({ context: e4, scope: t }) {
        var _a2;
        let a3 = e4.get("focusedValue");
        if (!a3) return;
        (_a2 = ee2(t, a3)) == null ? void 0 : _a2.focus();
      }, focusPrevTrigger({ context: e4, scope: t }) {
        var _a2;
        let a3 = e4.get("focusedValue");
        if (!a3) return;
        (_a2 = te2(t, a3)) == null ? void 0 : _a2.focus();
      }, setFocusedValue({ context: e4, event: t }) {
        e4.set("focusedValue", t.value);
      }, clearFocusedValue({ context: e4 }) {
        e4.set("focusedValue", null);
      }, setValue({ context: e4, event: t }) {
        e4.set("value", t.value);
      }, coarseValue({ context: e4, prop: t }) {
        !t("multiple") && e4.get("value").length > 1 && (Mt("The value of accordion should be a single value when multiple is false."), e4.set("value", [e4.get("value")[0]]));
      } } } };
      ie2 = As()(["collapsible", "dir", "disabled", "getRootNode", "id", "ids", "multiple", "onFocusChange", "onValueChange", "orientation", "value", "defaultValue"]);
      pe2 = as(ie2);
      ne2 = As()(["value", "disabled"]);
      ge2 = as(ne2);
      C2 = class extends ve {
        initMachine(t) {
          return new Ls(q2, t);
        }
        initApi() {
          return U(this.machine.service, Cs);
        }
        render() {
          var _a2;
          let t = (_a2 = this.el.querySelector('[data-scope="accordion"][data-part="root"]')) != null ? _a2 : this.el;
          this.spreadProps(t, this.api.getRootProps());
          let a3 = this.getItemsList(), n = t.querySelectorAll('[data-scope="accordion"][data-part="item"]');
          for (let o2 = 0; o2 < n.length; o2++) {
            let r3 = n[o2], c5 = a3[o2];
            if (!(c5 == null ? void 0 : c5.value)) continue;
            let { value: u3, disabled: p4 } = c5;
            this.spreadProps(r3, this.api.getItemProps({ value: u3, disabled: p4 }));
            let T7 = r3.querySelector('[data-scope="accordion"][data-part="item-trigger"]');
            T7 && this.spreadProps(T7, this.api.getItemTriggerProps({ value: u3, disabled: p4 }));
            let b10 = r3.querySelector('[data-scope="accordion"][data-part="item-indicator"]');
            b10 && this.spreadProps(b10, this.api.getItemIndicatorProps({ value: u3, disabled: p4 }));
            let l4 = r3.querySelector('[data-scope="accordion"][data-part="item-content"]');
            l4 && this.spreadProps(l4, this.api.getItemContentProps({ value: u3, disabled: p4 }));
          }
        }
        getItemsList() {
          let t = this.el.getAttribute("data-items");
          if (!t) return [];
          try {
            return JSON.parse(t);
          } catch (e4) {
            return [];
          }
        }
      };
      Ve2 = { mounted() {
        let e4 = this.el, t = this.pushEvent.bind(this), a3 = new C2(e4, __spreadProps(__spreadValues({ id: e4.id }, _r(e4, "controlled") ? { value: Cr(e4, "value") } : { defaultValue: Cr(e4, "defaultValue") }), { collapsible: _r(e4, "collapsible"), multiple: _r(e4, "multiple"), orientation: xr(e4, "orientation", ["horizontal", "vertical"]), dir: kr(e4), onValueChange: (n) => {
          var _a2, _b;
          let o2 = xr(e4, "onValueChange");
          o2 && this.liveSocket.main.isConnected() && t(o2, { id: e4.id, value: (_a2 = n.value) != null ? _a2 : null });
          let r3 = xr(e4, "onValueChangeClient");
          r3 && e4.dispatchEvent(new CustomEvent(r3, { bubbles: true, detail: { id: e4.id, value: (_b = n.value) != null ? _b : null } }));
        }, onFocusChange: (n) => {
          var _a2, _b;
          let o2 = xr(e4, "onFocusChange");
          o2 && this.liveSocket.main.isConnected() && t(o2, { id: e4.id, value: (_a2 = n.value) != null ? _a2 : null });
          let r3 = xr(e4, "onFocusChangeClient");
          r3 && e4.dispatchEvent(new CustomEvent(r3, { bubbles: true, detail: { id: e4.id, value: (_b = n.value) != null ? _b : null } }));
        } }));
        a3.init(), this.accordion = a3, this.onSetValue = (n) => {
          let { value: o2 } = n.detail;
          a3.api.setValue(o2);
        }, e4.addEventListener("phx:accordion:set-value", this.onSetValue), this.handlers = [], this.handlers.push(this.handleEvent("accordion_set_value", (n) => {
          let o2 = n.accordion_id;
          o2 && !(e4.id === o2 || e4.id === `accordion:${o2}`) || a3.api.setValue(n.value);
        })), this.handlers.push(this.handleEvent("accordion_value", () => {
          this.pushEvent("accordion_value_response", { value: a3.api.value });
        })), this.handlers.push(this.handleEvent("accordion_focused_value", () => {
          this.pushEvent("accordion_focused_value_response", { value: a3.api.focusedValue });
        }));
      }, updated() {
        var _a2, _b, _c, _d;
        let e4 = _r(this.el, "controlled");
        (_d = this.accordion) == null ? void 0 : _d.updateProps(__spreadProps(__spreadValues({ id: this.el.id }, e4 ? { value: Cr(this.el, "value") } : { defaultValue: (_c = (_b = (_a2 = this.accordion) == null ? void 0 : _a2.api) == null ? void 0 : _b.value) != null ? _c : Cr(this.el, "defaultValue") }), { collapsible: _r(this.el, "collapsible"), multiple: _r(this.el, "multiple"), orientation: xr(this.el, "orientation", ["horizontal", "vertical"]), dir: kr(this.el) }));
      }, destroyed() {
        var _a2;
        if (this.onSetValue && this.el.removeEventListener("phx:accordion:set-value", this.onSetValue), this.handlers) for (let e4 of this.handlers) this.removeHandleEvent(e4);
        (_a2 = this.accordion) == null ? void 0 : _a2.destroy();
      } };
    }
  });

  // ../priv/static/chunk-UBXVV7GZ.mjs
  function z2(n, t, e4 = n.center) {
    let i = t.x - e4.x, s = t.y - e4.y;
    return 360 - (Math.atan2(i, s) * (180 / Math.PI) + 180);
  }
  function R(n) {
    let { x: t, y: e4, width: i, height: s } = n, o2 = t + i / 2, m5 = e4 + s / 2;
    return { x: t, y: e4, width: i, height: s, minX: t, minY: e4, maxX: t + i, maxY: e4 + s, midX: o2, midY: m5, center: l(o2, m5) };
  }
  function I3(n) {
    let t = l(n.minX, n.minY), e4 = l(n.maxX, n.minY), i = l(n.maxX, n.maxY), s = l(n.minX, n.maxY);
    return { top: t, right: e4, bottom: i, left: s };
  }
  function j2(n) {
    if (!X2.has(n)) {
      let t = n.ownerDocument.defaultView || window;
      X2.set(n, t.getComputedStyle(n));
    }
    return X2.get(n);
  }
  function Z3(n, t = {}) {
    return R(D2(n, t));
  }
  function D2(n, t = {}) {
    let { excludeScrollbar: e4 = false, excludeBorders: i = false } = t, { x: s, y: o2, width: m5, height: c5 } = n.getBoundingClientRect(), h6 = { x: s, y: o2, width: m5, height: c5 }, x14 = j2(n), { borderLeftWidth: u3, borderTopWidth: d4, borderRightWidth: g7, borderBottomWidth: f4 } = x14, w10 = W3(u3, g7), a3 = W3(d4, f4);
    if (i && (h6.width -= w10, h6.height -= a3, h6.x += Y2(u3), h6.y += Y2(d4)), e4) {
      let T7 = n.offsetWidth - n.clientWidth - w10, F10 = n.offsetHeight - n.clientHeight - a3;
      h6.width -= T7, h6.height -= F10;
    }
    return h6;
  }
  function nt2(n, t = {}) {
    return R(N2(n, t));
  }
  function N2(n, t) {
    let { excludeScrollbar: e4 = false } = t, { innerWidth: i, innerHeight: s, document: o2, visualViewport: m5 } = n, c5 = (m5 == null ? void 0 : m5.width) || i, h6 = (m5 == null ? void 0 : m5.height) || s, x14 = { x: 0, y: 0, width: c5, height: h6 };
    if (e4) {
      let u3 = i - o2.documentElement.clientWidth, d4 = s - o2.documentElement.clientHeight;
      x14.width -= u3, x14.height -= d4;
    }
    return x14;
  }
  function et2(n, t) {
    let e4 = R(n), { top: i, right: s, left: o2, bottom: m5 } = I3(e4), [c5] = t.split("-");
    return { top: [o2, i, s, m5], right: [i, s, m5, o2], bottom: [i, o2, m5, s], left: [s, i, o2, m5] }[c5];
  }
  function it2(n, t) {
    let { x: e4, y: i } = t, s = false;
    for (let o2 = 0, m5 = n.length - 1; o2 < n.length; m5 = o2++) {
      let c5 = n[o2].x, h6 = n[o2].y, x14 = n[m5].x, u3 = n[m5].y;
      h6 > i != u3 > i && e4 < (x14 - c5) * (i - h6) / (u3 - h6) + c5 && (s = !s);
    }
    return s;
  }
  function A(n, t) {
    let { minX: e4, minY: i, maxX: s, maxY: o2, midX: m5, midY: c5 } = n, h6 = t.includes("w") ? e4 : t.includes("e") ? s : m5, x14 = t.includes("n") ? i : t.includes("s") ? o2 : c5;
    return { x: h6, y: x14 };
  }
  function q3(n) {
    return B2[n];
  }
  function st2(n, t, e4, i) {
    let { scalingOriginMode: s, lockAspectRatio: o2 } = i, m5 = A(n, e4), c5 = q3(e4), h6 = A(n, c5);
    s === "center" && (t = { x: t.x * 2, y: t.y * 2 });
    let x14 = { x: m5.x + t.x, y: m5.y + t.y }, u3 = { x: v[e4].x * 2 - 1, y: v[e4].y * 2 - 1 }, d4 = { width: x14.x - h6.x, height: x14.y - h6.y }, g7 = u3.x * d4.width / n.width, f4 = u3.y * d4.height / n.height, w10 = p(g7) > p(f4) ? g7 : f4, a3 = o2 ? { x: w10, y: w10 } : { x: m5.x === h6.x ? 1 : g7, y: m5.y === h6.y ? 1 : f4 };
    switch (m5.y === h6.y ? a3.y = p(a3.y) : M(a3.y) !== M(f4) && (a3.y *= -1), m5.x === h6.x ? a3.x = p(a3.x) : M(a3.x) !== M(g7) && (a3.x *= -1), s) {
      case "extent":
        return P2(n, E2.scale(a3.x, a3.y, h6), false);
      case "center":
        return P2(n, E2.scale(a3.x, a3.y, { x: n.midX, y: n.midY }), false);
    }
  }
  function V3(n, t, e4 = true) {
    return e4 ? { x: S2(t.x, n.x), y: S2(t.y, n.y), width: p(t.x - n.x), height: p(t.y - n.y) } : { x: n.x, y: n.y, width: t.x - n.x, height: t.y - n.y };
  }
  function P2(n, t, e4 = true) {
    let i = t.applyTo({ x: n.minX, y: n.minY }), s = t.applyTo({ x: n.maxX, y: n.maxY });
    return V3(i, s, e4);
  }
  var b, O, y2, E2, C3, L2, $, H3, k, l, G2, J3, K2, Q3, U2, X2, Y2, W3, _, tt2, v, B2, M, p, S2;
  var init_chunk_UBXVV7GZ = __esm({
    "../priv/static/chunk-UBXVV7GZ.mjs"() {
      "use strict";
      b = Object.defineProperty;
      O = (n, t, e4) => t in n ? b(n, t, { enumerable: true, configurable: true, writable: true, value: e4 }) : n[t] = e4;
      y2 = (n, t, e4) => O(n, typeof t != "symbol" ? t + "" : t, e4);
      E2 = class r {
        constructor([t, e4, i, s, o2, m5] = [0, 0, 0, 0, 0, 0]) {
          y2(this, "m00"), y2(this, "m01"), y2(this, "m02"), y2(this, "m10"), y2(this, "m11"), y2(this, "m12"), y2(this, "rotate", (...c5) => this.prepend(r.rotate(...c5))), y2(this, "scale", (...c5) => this.prepend(r.scale(...c5))), y2(this, "translate", (...c5) => this.prepend(r.translate(...c5))), this.m00 = t, this.m01 = e4, this.m02 = i, this.m10 = s, this.m11 = o2, this.m12 = m5;
        }
        applyTo(t) {
          let { x: e4, y: i } = t, { m00: s, m01: o2, m02: m5, m10: c5, m11: h6, m12: x14 } = this;
          return { x: s * e4 + o2 * i + m5, y: c5 * e4 + h6 * i + x14 };
        }
        prepend(t) {
          return new r([this.m00 * t.m00 + this.m01 * t.m10, this.m00 * t.m01 + this.m01 * t.m11, this.m00 * t.m02 + this.m01 * t.m12 + this.m02, this.m10 * t.m00 + this.m11 * t.m10, this.m10 * t.m01 + this.m11 * t.m11, this.m10 * t.m02 + this.m11 * t.m12 + this.m12]);
        }
        append(t) {
          return new r([t.m00 * this.m00 + t.m01 * this.m10, t.m00 * this.m01 + t.m01 * this.m11, t.m00 * this.m02 + t.m01 * this.m12 + t.m02, t.m10 * this.m00 + t.m11 * this.m10, t.m10 * this.m01 + t.m11 * this.m11, t.m10 * this.m02 + t.m11 * this.m12 + t.m12]);
        }
        get determinant() {
          return this.m00 * this.m11 - this.m01 * this.m10;
        }
        get isInvertible() {
          let t = this.determinant;
          return isFinite(t) && isFinite(this.m02) && isFinite(this.m12) && t !== 0;
        }
        invert() {
          let t = this.determinant;
          return new r([this.m11 / t, -this.m01 / t, (this.m01 * this.m12 - this.m11 * this.m02) / t, -this.m10 / t, this.m00 / t, (this.m10 * this.m02 - this.m00 * this.m12) / t]);
        }
        get array() {
          return [this.m00, this.m01, this.m02, this.m10, this.m11, this.m12, 0, 0, 1];
        }
        get float32Array() {
          return new Float32Array(this.array);
        }
        static get identity() {
          return new r([1, 0, 0, 0, 1, 0]);
        }
        static rotate(t, e4) {
          let i = new r([Math.cos(t), -Math.sin(t), 0, Math.sin(t), Math.cos(t), 0]);
          return e4 && (e4.x !== 0 || e4.y !== 0) ? r.multiply(r.translate(e4.x, e4.y), i, r.translate(-e4.x, -e4.y)) : i;
        }
        static scale(t, e4 = t, i = { x: 0, y: 0 }) {
          let s = new r([t, 0, 0, 0, e4, 0]);
          return i.x !== 0 || i.y !== 0 ? r.multiply(r.translate(i.x, i.y), s, r.translate(-i.x, -i.y)) : s;
        }
        static translate(t, e4) {
          return new r([1, 0, t, 0, 1, e4]);
        }
        static multiply(...[t, ...e4]) {
          return t ? e4.reduce((i, s) => i.prepend(s), t) : r.identity;
        }
        get a() {
          return this.m00;
        }
        get b() {
          return this.m10;
        }
        get c() {
          return this.m01;
        }
        get d() {
          return this.m11;
        }
        get tx() {
          return this.m02;
        }
        get ty() {
          return this.m12;
        }
        get scaleComponents() {
          return { x: this.a, y: this.d };
        }
        get translationComponents() {
          return { x: this.tx, y: this.ty };
        }
        get skewComponents() {
          return { x: this.c, y: this.b };
        }
        toString() {
          return `matrix(${this.a}, ${this.b}, ${this.c}, ${this.d}, ${this.tx}, ${this.ty})`;
        }
      };
      C3 = (n, t, e4) => Math.min(Math.max(n, t), e4);
      L2 = (n, t, e4) => {
        let i = C3(n.x, e4.x, e4.x + e4.width - t.width), s = C3(n.y, e4.y, e4.y + e4.height - t.height);
        return { x: i, y: s };
      };
      $ = { width: 0, height: 0 };
      H3 = { width: 1 / 0, height: 1 / 0 };
      k = (n, t = $, e4 = H3) => ({ width: Math.min(Math.max(n.width, t.width), e4.width), height: Math.min(Math.max(n.height, t.height), e4.height) });
      l = (n, t) => ({ x: n, y: t });
      G2 = (n, t) => t ? l(n.x - t.x, n.y - t.y) : n;
      J3 = (n, t) => l(n.x + t.x, n.y + t.y);
      K2 = (n, t) => {
        let e4 = Math.max(t.x, Math.min(n.x, t.x + t.width - n.width)), i = Math.max(t.y, Math.min(n.y, t.y + t.height - n.height));
        return { x: e4, y: i, width: Math.min(n.width, t.width), height: Math.min(n.height, t.height) };
      };
      Q3 = (n, t) => n.width === (t == null ? void 0 : t.width) && n.height === (t == null ? void 0 : t.height);
      U2 = (n, t) => n.x === (t == null ? void 0 : t.x) && n.y === (t == null ? void 0 : t.y);
      X2 = /* @__PURE__ */ new WeakMap();
      Y2 = (n) => parseFloat(n.replace("px", ""));
      W3 = (...n) => n.reduce((t, e4) => t + (e4 ? Y2(e4) : 0), 0);
      ({ min: _, max: tt2 } = Math);
      v = { n: { x: 0.5, y: 0 }, ne: { x: 1, y: 0 }, e: { x: 1, y: 0.5 }, se: { x: 1, y: 1 }, s: { x: 0.5, y: 1 }, sw: { x: 0, y: 1 }, w: { x: 0, y: 0.5 }, nw: { x: 0, y: 0 } };
      B2 = { n: "s", ne: "sw", e: "w", se: "nw", s: "n", sw: "ne", w: "e", nw: "se" };
      ({ sign: M, abs: p, min: S2 } = Math);
    }
  });

  // ../priv/static/angle-slider.mjs
  var angle_slider_exports = {};
  __export(angle_slider_exports, {
    AngleSlider: () => ke2
  });
  function J4(e4, t, a3) {
    let r3 = R(e4.getBoundingClientRect()), i = z2(r3, t);
    return a3 != null ? i - a3 : i;
  }
  function Q4(e4) {
    return Math.min(Math.max(e4, P3), O2);
  }
  function de2(e4, t) {
    let a3 = Q4(e4), r3 = Math.ceil(a3 / t), i = Math.round(a3 / t);
    return r3 >= a3 / t ? r3 * t === O2 ? P3 : r3 * t : i * t;
  }
  function F2(e4, t) {
    return ns(e4, P3, O2, t);
  }
  function Y3(e4, t) {
    let { state: a3, send: r3, context: i, prop: l4, computed: d4, scope: o2 } = e4, g7 = a3.matches("dragging"), u3 = i.get("value"), f4 = d4("valueAsDegree"), b10 = l4("disabled"), T7 = l4("invalid"), E15 = l4("readOnly"), y11 = d4("interactive"), z12 = l4("aria-label"), ee11 = l4("aria-labelledby");
    return { value: u3, valueAsDegree: f4, dragging: g7, setValue(n) {
      r3({ type: "VALUE.SET", value: n });
    }, getRootProps() {
      return t.element(__spreadProps(__spreadValues({}, h.root.attrs), { id: le2(o2), "data-disabled": jr(b10), "data-invalid": jr(T7), "data-readonly": jr(E15), style: { "--value": u3, "--angle": f4 } }));
    }, getLabelProps() {
      return t.label(__spreadProps(__spreadValues({}, h.label.attrs), { id: G3(o2), htmlFor: k2(o2), "data-disabled": jr(b10), "data-invalid": jr(T7), "data-readonly": jr(E15), onClick(n) {
        var _a2;
        y11 && (n.preventDefault(), (_a2 = S3(o2)) == null ? void 0 : _a2.focus());
      } }));
    }, getHiddenInputProps() {
      return t.element({ type: "hidden", value: u3, name: l4("name"), id: k2(o2) });
    }, getControlProps() {
      return t.element(__spreadProps(__spreadValues({}, h.control.attrs), { role: "presentation", id: X3(o2), "data-disabled": jr(b10), "data-invalid": jr(T7), "data-readonly": jr(E15), onPointerDown(n) {
        if (!y11 || !ro(n)) return;
        let c5 = gt(n), te10 = n.currentTarget, A12 = S3(o2), ae11 = en(n).composedPath(), re11 = A12 && ae11.includes(A12), H12 = null;
        re11 && (H12 = J4(te10, c5) - u3), r3({ type: "CONTROL.POINTER_DOWN", point: c5, angularOffset: H12 }), n.stopPropagation();
      }, style: { touchAction: "none", userSelect: "none", WebkitUserSelect: "none" } }));
    }, getThumbProps() {
      return t.element(__spreadProps(__spreadValues({}, h.thumb.attrs), { id: K3(o2), role: "slider", "aria-label": z12, "aria-labelledby": ee11 != null ? ee11 : G3(o2), "aria-valuemax": 360, "aria-valuemin": 0, "aria-valuenow": u3, tabIndex: E15 || y11 ? 0 : void 0, "data-disabled": jr(b10), "data-invalid": jr(T7), "data-readonly": jr(E15), onFocus() {
        r3({ type: "THUMB.FOCUS" });
      }, onBlur() {
        r3({ type: "THUMB.BLUR" });
      }, onKeyDown(n) {
        if (!y11) return;
        let c5 = co(n) * l4("step");
        switch (n.key) {
          case "ArrowLeft":
          case "ArrowUp":
            n.preventDefault(), r3({ type: "THUMB.ARROW_DEC", step: c5 });
            break;
          case "ArrowRight":
          case "ArrowDown":
            n.preventDefault(), r3({ type: "THUMB.ARROW_INC", step: c5 });
            break;
          case "Home":
            n.preventDefault(), r3({ type: "THUMB.HOME" });
            break;
          case "End":
            n.preventDefault(), r3({ type: "THUMB.END" });
            break;
        }
      }, style: { rotate: "var(--angle)" } }));
    }, getValueTextProps() {
      return t.element(__spreadProps(__spreadValues({}, h.valueText.attrs), { id: oe3(o2) }));
    }, getMarkerGroupProps() {
      return t.element(__spreadValues({}, h.markerGroup.attrs));
    }, getMarkerProps(n) {
      let c5;
      return n.value < u3 ? c5 = "under-value" : n.value > u3 ? c5 = "over-value" : c5 = "at-value", t.element(__spreadProps(__spreadValues({}, h.marker.attrs), { "data-value": n.value, "data-state": c5, "data-disabled": jr(b10), style: { "--marker-value": n.value, rotate: "calc(var(--marker-value) * 1deg)" } }));
    } };
  }
  var ne3, h, le2, K3, k2, X3, oe3, G3, ie3, se2, S3, P3, O2, Z4, ue2, fe2, M2, ke2;
  var init_angle_slider = __esm({
    "../priv/static/angle-slider.mjs"() {
      "use strict";
      init_chunk_UBXVV7GZ();
      init_chunk_IYURAQ6S();
      ne3 = G("angle-slider").parts("root", "label", "thumb", "valueText", "control", "track", "markerGroup", "marker");
      h = ne3.build();
      le2 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.root) != null ? _b : `angle-slider:${e4.id}`;
      };
      K3 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.thumb) != null ? _b : `angle-slider:${e4.id}:thumb`;
      };
      k2 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.hiddenInput) != null ? _b : `angle-slider:${e4.id}:input`;
      };
      X3 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.control) != null ? _b : `angle-slider:${e4.id}:control`;
      };
      oe3 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.valueText) != null ? _b : `angle-slider:${e4.id}:value-text`;
      };
      G3 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.label) != null ? _b : `angle-slider:${e4.id}:label`;
      };
      ie3 = (e4) => e4.getById(k2(e4));
      se2 = (e4) => e4.getById(X3(e4));
      S3 = (e4) => e4.getById(K3(e4));
      P3 = 0;
      O2 = 359;
      Z4 = { props({ props: e4 }) {
        return __spreadValues({ step: 1, defaultValue: 0 }, e4);
      }, context({ prop: e4, bindable: t }) {
        return { value: t(() => ({ defaultValue: e4("defaultValue"), value: e4("value"), onChange(a3) {
          var _a2;
          (_a2 = e4("onValueChange")) == null ? void 0 : _a2({ value: a3, valueAsDegree: `${a3}deg` });
        } })) };
      }, refs() {
        return { thumbDragOffset: null };
      }, computed: { interactive: ({ prop: e4 }) => !(e4("disabled") || e4("readOnly")), valueAsDegree: ({ context: e4 }) => `${e4.get("value")}deg` }, watch({ track: e4, context: t, action: a3 }) {
        e4([() => t.get("value")], () => {
          a3(["syncInputElement"]);
        });
      }, initialState() {
        return "idle";
      }, on: { "VALUE.SET": { actions: ["setValue"] } }, states: { idle: { on: { "CONTROL.POINTER_DOWN": { target: "dragging", actions: ["setThumbDragOffset", "setPointerValue", "focusThumb"] }, "THUMB.FOCUS": { target: "focused" } } }, focused: { on: { "CONTROL.POINTER_DOWN": { target: "dragging", actions: ["setThumbDragOffset", "setPointerValue", "focusThumb"] }, "THUMB.ARROW_DEC": { actions: ["decrementValue", "invokeOnChangeEnd"] }, "THUMB.ARROW_INC": { actions: ["incrementValue", "invokeOnChangeEnd"] }, "THUMB.HOME": { actions: ["setValueToMin", "invokeOnChangeEnd"] }, "THUMB.END": { actions: ["setValueToMax", "invokeOnChangeEnd"] }, "THUMB.BLUR": { target: "idle" } } }, dragging: { entry: ["focusThumb"], effects: ["trackPointerMove"], on: { "DOC.POINTER_UP": { target: "focused", actions: ["invokeOnChangeEnd", "clearThumbDragOffset"] }, "DOC.POINTER_MOVE": { actions: ["setPointerValue"] } } } }, implementations: { effects: { trackPointerMove({ scope: e4, send: t }) {
        return Eo(e4.getDoc(), { onPointerMove(a3) {
          t({ type: "DOC.POINTER_MOVE", point: a3.point });
        }, onPointerUp() {
          t({ type: "DOC.POINTER_UP" });
        } });
      } }, actions: { syncInputElement({ scope: e4, context: t }) {
        let a3 = ie3(e4);
        sn(a3, t.get("value").toString());
      }, invokeOnChangeEnd({ context: e4, prop: t, computed: a3 }) {
        var _a2;
        (_a2 = t("onValueChangeEnd")) == null ? void 0 : _a2({ value: e4.get("value"), valueAsDegree: a3("valueAsDegree") });
      }, setPointerValue({ scope: e4, event: t, context: a3, prop: r3, refs: i }) {
        let l4 = se2(e4);
        if (!l4) return;
        let d4 = i.get("thumbDragOffset"), o2 = J4(l4, t.point, d4);
        a3.set("value", de2(o2, r3("step")));
      }, setValueToMin({ context: e4 }) {
        e4.set("value", P3);
      }, setValueToMax({ context: e4 }) {
        e4.set("value", O2);
      }, setValue({ context: e4, event: t }) {
        e4.set("value", Q4(t.value));
      }, decrementValue({ context: e4, event: t, prop: a3 }) {
        var _a2;
        let r3 = F2(e4.get("value") - t.step, (_a2 = t.step) != null ? _a2 : a3("step"));
        e4.set("value", r3);
      }, incrementValue({ context: e4, event: t, prop: a3 }) {
        var _a2;
        let r3 = F2(e4.get("value") + t.step, (_a2 = t.step) != null ? _a2 : a3("step"));
        e4.set("value", r3);
      }, focusThumb({ scope: e4 }) {
        nt(() => {
          var _a2;
          (_a2 = S3(e4)) == null ? void 0 : _a2.focus({ preventScroll: true });
        });
      }, setThumbDragOffset({ refs: e4, event: t }) {
        var _a2;
        e4.set("thumbDragOffset", (_a2 = t.angularOffset) != null ? _a2 : null);
      }, clearThumbDragOffset({ refs: e4 }) {
        e4.set("thumbDragOffset", null);
      } } } };
      ue2 = As()(["aria-label", "aria-labelledby", "dir", "disabled", "getRootNode", "id", "ids", "invalid", "name", "onValueChange", "onValueChangeEnd", "readOnly", "step", "value", "defaultValue"]);
      fe2 = as(ue2);
      M2 = class extends ve {
        initMachine(t) {
          return new Ls(Z4, t);
        }
        initApi() {
          return Y3(this.machine.service, Cs);
        }
        render() {
          var _a2;
          let t = (_a2 = this.el.querySelector('[data-scope="angle-slider"][data-part="root"]')) != null ? _a2 : this.el;
          this.spreadProps(t, this.api.getRootProps());
          let a3 = this.el.querySelector('[data-scope="angle-slider"][data-part="label"]');
          a3 && this.spreadProps(a3, this.api.getLabelProps());
          let r3 = this.el.querySelector('[data-scope="angle-slider"][data-part="hidden-input"]');
          r3 && this.spreadProps(r3, this.api.getHiddenInputProps());
          let i = this.el.querySelector('[data-scope="angle-slider"][data-part="control"]');
          i && this.spreadProps(i, this.api.getControlProps());
          let l4 = this.el.querySelector('[data-scope="angle-slider"][data-part="thumb"]');
          l4 && this.spreadProps(l4, this.api.getThumbProps());
          let d4 = this.el.querySelector('[data-scope="angle-slider"][data-part="value-text"]');
          d4 && this.spreadProps(d4, this.api.getValueTextProps());
          let o2 = this.el.querySelector('[data-scope="angle-slider"][data-part="marker-group"]');
          o2 && this.spreadProps(o2, this.api.getMarkerGroupProps()), this.el.querySelectorAll('[data-scope="angle-slider"][data-part="marker"]').forEach((g7) => {
            let u3 = g7.dataset.value;
            if (u3 == null) return;
            let f4 = Number(u3);
            Number.isNaN(f4) || this.spreadProps(g7, this.api.getMarkerProps({ value: f4 }));
          });
        }
      };
      ke2 = { mounted() {
        var _a2;
        let e4 = this.el, t = Lr(e4, "value"), a3 = Lr(e4, "defaultValue"), r3 = _r(e4, "controlled"), i = new M2(e4, __spreadProps(__spreadValues({ id: e4.id }, r3 && t !== void 0 ? { value: t } : { defaultValue: a3 != null ? a3 : 0 }), { step: (_a2 = Lr(e4, "step")) != null ? _a2 : 1, disabled: _r(e4, "disabled"), readOnly: _r(e4, "readOnly"), invalid: _r(e4, "invalid"), name: xr(e4, "name"), dir: xr(e4, "dir", ["ltr", "rtl"]), onValueChange: (l4) => {
          let d4 = e4.querySelector('[data-scope="angle-slider"][data-part="hidden-input"]');
          d4 && (d4.value = String(l4.value), d4.dispatchEvent(new Event("input", { bubbles: true })), d4.dispatchEvent(new Event("change", { bubbles: true })));
          let o2 = xr(e4, "onValueChange");
          o2 && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected() && this.pushEvent(o2, { value: l4.value, valueAsDegree: l4.valueAsDegree, id: e4.id });
          let g7 = xr(e4, "onValueChangeClient");
          g7 && e4.dispatchEvent(new CustomEvent(g7, { bubbles: true, detail: { value: l4, id: e4.id } }));
        } }));
        i.init(), this.angleSlider = i, this.handlers = [];
      }, updated() {
        var _a2, _b;
        let e4 = Lr(this.el, "value"), t = _r(this.el, "controlled");
        (_b = this.angleSlider) == null ? void 0 : _b.updateProps(__spreadProps(__spreadValues({ id: this.el.id }, t && e4 !== void 0 ? { value: e4 } : {}), { step: (_a2 = Lr(this.el, "step")) != null ? _a2 : 1, disabled: _r(this.el, "disabled"), readOnly: _r(this.el, "readOnly"), invalid: _r(this.el, "invalid"), name: xr(this.el, "name") }));
      }, destroyed() {
        var _a2;
        if (this.handlers) for (let e4 of this.handlers) this.removeHandleEvent(e4);
        (_a2 = this.angleSlider) == null ? void 0 : _a2.destroy();
      } };
    }
  });

  // ../priv/static/avatar.mjs
  var avatar_exports = {};
  __export(avatar_exports, {
    Avatar: () => V4
  });
  function E3(t, e4) {
    let { state: a3, send: r3, prop: s, scope: o2 } = t, i = a3.matches("loaded");
    return { loaded: i, setSrc(H12) {
      var _a2;
      (_a2 = l2(o2)) == null ? void 0 : _a2.setAttribute("src", H12);
    }, setLoaded() {
      r3({ type: "img.loaded", src: "api" });
    }, setError() {
      r3({ type: "img.error", src: "api" });
    }, getRootProps() {
      return e4.element(__spreadProps(__spreadValues({}, c.root.attrs), { dir: s("dir"), id: b2(o2) }));
    }, getImageProps() {
      return e4.img(__spreadProps(__spreadValues({}, c.image.attrs), { hidden: !i, dir: s("dir"), id: y3(o2), "data-state": i ? "visible" : "hidden", onLoad() {
        r3({ type: "img.loaded", src: "element" });
      }, onError() {
        r3({ type: "img.error", src: "element" });
      } }));
    }, getFallbackProps() {
      return e4.element(__spreadProps(__spreadValues({}, c.fallback.attrs), { dir: s("dir"), id: A2(o2), hidden: i, "data-state": i ? "hidden" : "visible" }));
    } };
  }
  function I4(t) {
    return t.complete && t.naturalWidth !== 0 && t.naturalHeight !== 0;
  }
  var P4, c, b2, y3, A2, C4, l2, S4, L3, j3, d, V4;
  var init_avatar = __esm({
    "../priv/static/avatar.mjs"() {
      "use strict";
      init_chunk_IYURAQ6S();
      P4 = G("avatar").parts("root", "image", "fallback");
      c = P4.build();
      b2 = (t) => {
        var _a2, _b;
        return (_b = (_a2 = t.ids) == null ? void 0 : _a2.root) != null ? _b : `avatar:${t.id}`;
      };
      y3 = (t) => {
        var _a2, _b;
        return (_b = (_a2 = t.ids) == null ? void 0 : _a2.image) != null ? _b : `avatar:${t.id}:image`;
      };
      A2 = (t) => {
        var _a2, _b;
        return (_b = (_a2 = t.ids) == null ? void 0 : _a2.fallback) != null ? _b : `avatar:${t.id}:fallback`;
      };
      C4 = (t) => t.getById(b2(t));
      l2 = (t) => t.getById(y3(t));
      S4 = { initialState() {
        return "loading";
      }, effects: ["trackImageRemoval", "trackSrcChange"], on: { "src.change": { target: "loading" }, "img.unmount": { target: "error" } }, states: { loading: { entry: ["checkImageStatus"], on: { "img.loaded": { target: "loaded", actions: ["invokeOnLoad"] }, "img.error": { target: "error", actions: ["invokeOnError"] } } }, error: { on: { "img.loaded": { target: "loaded", actions: ["invokeOnLoad"] } } }, loaded: { on: { "img.error": { target: "error", actions: ["invokeOnError"] } } } }, implementations: { actions: { invokeOnLoad({ prop: t }) {
        var _a2;
        (_a2 = t("onStatusChange")) == null ? void 0 : _a2({ status: "loaded" });
      }, invokeOnError({ prop: t }) {
        var _a2;
        (_a2 = t("onStatusChange")) == null ? void 0 : _a2({ status: "error" });
      }, checkImageStatus({ send: t, scope: e4 }) {
        let a3 = l2(e4);
        if (!(a3 == null ? void 0 : a3.complete)) return;
        let r3 = I4(a3) ? "img.loaded" : "img.error";
        t({ type: r3, src: "ssr" });
      } }, effects: { trackImageRemoval({ send: t, scope: e4 }) {
        let a3 = C4(e4);
        return mo(a3, { callback(r3) {
          Array.from(r3[0].removedNodes).find((i) => i.nodeType === Node.ELEMENT_NODE && i.matches("[data-scope=avatar][data-part=image]")) && t({ type: "img.unmount" });
        } });
      }, trackSrcChange({ send: t, scope: e4 }) {
        let a3 = l2(e4);
        return go(a3, { attributes: ["src", "srcset"], callback() {
          t({ type: "src.change" });
        } });
      } } } };
      L3 = As()(["dir", "id", "ids", "onStatusChange", "getRootNode"]);
      j3 = as(L3);
      d = class extends ve {
        initMachine(e4) {
          return new Ls(S4, e4);
        }
        initApi() {
          return E3(this.machine.service, Cs);
        }
        render() {
          var _a2;
          let e4 = (_a2 = this.el.querySelector('[data-scope="avatar"][data-part="root"]')) != null ? _a2 : this.el;
          this.spreadProps(e4, this.api.getRootProps());
          let a3 = this.el.querySelector('[data-scope="avatar"][data-part="image"]');
          a3 && this.spreadProps(a3, this.api.getImageProps());
          let r3 = this.el.querySelector('[data-scope="avatar"][data-part="fallback"]');
          r3 && this.spreadProps(r3, this.api.getFallbackProps());
        }
      };
      V4 = { mounted() {
        let t = this.el, e4 = xr(t, "src"), a3 = new d(t, __spreadValues({ id: t.id, onStatusChange: (r3) => {
          let s = xr(t, "onStatusChange");
          s && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected() && this.pushEvent(s, { status: r3.status, id: t.id });
          let o2 = xr(t, "onStatusChangeClient");
          o2 && t.dispatchEvent(new CustomEvent(o2, { bubbles: true, detail: { value: r3, id: t.id } }));
        } }, e4 !== void 0 ? {} : {}));
        a3.init(), this.avatar = a3, e4 !== void 0 && a3.api.setSrc(e4), this.handlers = [];
      }, updated() {
        let t = xr(this.el, "src");
        t !== void 0 && this.avatar && this.avatar.api.setSrc(t);
      }, destroyed() {
        var _a2;
        if (this.handlers) for (let t of this.handlers) this.removeHandleEvent(t);
        (_a2 = this.avatar) == null ? void 0 : _a2.destroy();
      } };
    }
  });

  // ../priv/static/carousel.mjs
  var carousel_exports = {};
  __export(carousel_exports, {
    Carousel: () => Jt2
  });
  function pt2(t) {
    let e4 = zr(t), o2 = t.getBoundingClientRect(), r3 = e4.getPropertyValue("scroll-padding-left").replace("auto", "0px"), n = e4.getPropertyValue("scroll-padding-top").replace("auto", "0px"), a3 = e4.getPropertyValue("scroll-padding-right").replace("auto", "0px"), l4 = e4.getPropertyValue("scroll-padding-bottom").replace("auto", "0px");
    function i(u3, b10) {
      let h6 = parseFloat(u3);
      return /%/.test(u3) && (h6 /= 100, h6 *= b10), Number.isNaN(h6) ? 0 : h6;
    }
    let g7 = i(r3, o2.width), c5 = i(n, o2.height), f4 = i(a3, o2.width), p4 = i(l4, o2.height);
    return { x: { before: g7, after: f4 }, y: { before: c5, after: p4 } };
  }
  function Et2(t, e4, o2 = "both") {
    return o2 === "x" && t.right >= e4.left && t.left <= e4.right || o2 === "y" && t.bottom >= e4.top && t.top <= e4.bottom || o2 === "both" && t.right >= e4.left && t.left <= e4.right && t.bottom >= e4.top && t.top <= e4.bottom;
  }
  function ut2(t) {
    let e4 = [];
    for (let o2 of t.children) e4 = e4.concat(o2, ut2(o2));
    return e4;
  }
  function ft2(t, e4 = false) {
    let o2 = t.getBoundingClientRect(), n = $2(t) === "rtl", a3 = { x: { start: [], center: [], end: [] }, y: { start: [], center: [], end: [] } }, l4 = e4 ? ut2(t) : t.children;
    for (let i of ["x", "y"]) {
      let g7 = i === "x" ? "y" : "x", c5 = i === "x" ? "left" : "top", f4 = i === "x" ? "right" : "bottom", p4 = i === "x" ? "width" : "height", u3 = i === "x" ? "scrollLeft" : "scrollTop", b10 = n && i === "x";
      for (let h6 of l4) {
        let S13 = h6.getBoundingClientRect();
        if (!Et2(o2, S13, g7)) continue;
        let O10 = zr(h6), [D11, m5] = O10.getPropertyValue("scroll-snap-align").split(" ");
        typeof m5 > "u" && (m5 = D11);
        let s = i === "x" ? m5 : D11, d4, R7, E15;
        if (b10) {
          let C17 = Math.abs(t[u3]), P11 = o2[f4] - S13[f4] + C17;
          d4 = P11, R7 = P11 + S13[p4], E15 = P11 + S13[p4] / 2;
        } else d4 = S13[c5] - o2[c5] + t[u3], R7 = d4 + S13[p4], E15 = d4 + S13[p4] / 2;
        switch (s) {
          case "none":
            break;
          case "start":
            a3[i].start.push({ node: h6, position: d4 });
            break;
          case "center":
            a3[i].center.push({ node: h6, position: E15 });
            break;
          case "end":
            a3[i].end.push({ node: h6, position: R7 });
            break;
        }
      }
    }
    return a3;
  }
  function Pt2(t) {
    let e4 = $2(t), o2 = t.getBoundingClientRect(), r3 = pt2(t), n = ft2(t), a3 = { x: t.scrollWidth - t.offsetWidth, y: t.scrollHeight - t.offsetHeight }, l4 = e4 === "rtl", i = l4 && t.scrollLeft <= 0, g7;
    return l4 ? (g7 = Y4([...n.x.start.map((c5) => c5.position - r3.x.after), ...n.x.center.map((c5) => c5.position - o2.width / 2), ...n.x.end.map((c5) => c5.position - o2.width + r3.x.before)].map(X4(0, a3.x))), i && (g7 = g7.map((c5) => -c5))) : g7 = Y4([...n.x.start.map((c5) => c5.position - r3.x.before), ...n.x.center.map((c5) => c5.position - o2.width / 2), ...n.x.end.map((c5) => c5.position - o2.width + r3.x.after)].map(X4(0, a3.x))), { x: g7, y: Y4([...n.y.start.map((c5) => c5.position - r3.y.before), ...n.y.center.map((c5) => c5.position - o2.height / 2), ...n.y.end.map((c5) => c5.position - o2.height + r3.y.after)].map(X4(0, a3.y))) };
  }
  function ht2(t, e4, o2) {
    let r3 = $2(t), n = pt2(t), a3 = ft2(t), l4 = [...a3[e4].start, ...a3[e4].center, ...a3[e4].end], i = r3 === "rtl", g7 = i && e4 === "x" && t.scrollLeft <= 0;
    for (let c5 of l4) if (o2(c5.node)) {
      let f4;
      return e4 === "x" && i ? (f4 = c5.position - n.x.after, g7 && (f4 = -f4)) : f4 = c5.position - (e4 === "x" ? n.x.before : n.y.before), f4;
    }
  }
  function Tt2(t, e4) {
    let { state: o2, context: r3, computed: n, send: a3, scope: l4, prop: i } = t, g7 = o2.matches("autoplay"), c5 = o2.matches("dragging"), f4 = n("canScrollNext"), p4 = n("canScrollPrev"), u3 = n("isHorizontal"), b10 = i("autoSize"), h6 = Array.from(r3.get("pageSnapPoints")), S13 = r3.get("page"), O10 = i("slidesPerPage"), D11 = i("padding"), m5 = i("translations");
    return { isPlaying: g7, isDragging: c5, page: S13, pageSnapPoints: h6, canScrollNext: f4, canScrollPrev: p4, getProgress() {
      return S13 / h6.length;
    }, getProgressText() {
      var _a2, _b;
      let s = { page: S13 + 1, totalPages: h6.length };
      return (_b = (_a2 = m5.progressText) == null ? void 0 : _a2.call(m5, s)) != null ? _b : "";
    }, scrollToIndex(s, d4) {
      a3({ type: "INDEX.SET", index: s, instant: d4 });
    }, scrollTo(s, d4) {
      a3({ type: "PAGE.SET", index: s, instant: d4 });
    }, scrollNext(s) {
      a3({ type: "PAGE.NEXT", instant: s });
    }, scrollPrev(s) {
      a3({ type: "PAGE.PREV", instant: s });
    }, play() {
      a3({ type: "AUTOPLAY.START" });
    }, pause() {
      a3({ type: "AUTOPLAY.PAUSE" });
    }, isInView(s) {
      return Array.from(r3.get("slidesInView")).includes(s);
    }, refresh() {
      a3({ type: "SNAP.REFRESH" });
    }, getRootProps() {
      return e4.element(__spreadProps(__spreadValues({}, v2.root.attrs), { id: xt2(l4), role: "region", "aria-roledescription": "carousel", "data-orientation": i("orientation"), dir: i("dir"), style: { "--slides-per-page": O10, "--slide-spacing": i("spacing"), "--slide-item-size": b10 ? "auto" : "calc(100% / var(--slides-per-page) - var(--slide-spacing) * (var(--slides-per-page) - 1) / var(--slides-per-page))" } }));
    }, getItemGroupProps() {
      return e4.element(__spreadProps(__spreadValues({}, v2.itemGroup.attrs), { id: N3(l4), "data-orientation": i("orientation"), "data-dragging": jr(c5), dir: i("dir"), "aria-live": g7 ? "off" : "polite", onFocus(s) {
        Ie(s.currentTarget, Je(s)) && a3({ type: "VIEWPORT.FOCUS" });
      }, onBlur(s) {
        Ie(s.currentTarget, s.relatedTarget) || a3({ type: "VIEWPORT.BLUR" });
      }, onMouseDown(s) {
        if (s.defaultPrevented || !i("allowMouseDrag") || !ro(s)) return;
        let d4 = Je(s);
        X(d4) && d4 !== s.currentTarget || (s.preventDefault(), a3({ type: "DRAGGING.START" }));
      }, onWheel: Go((s) => {
        let d4 = i("orientation") === "horizontal" ? "deltaX" : "deltaY";
        s[d4] < 0 && !n("canScrollPrev") || s[d4] > 0 && !n("canScrollNext") || a3({ type: "USER.SCROLL" });
      }, 150), onTouchStart() {
        a3({ type: "USER.SCROLL" });
      }, style: { display: b10 ? "flex" : "grid", gap: "var(--slide-spacing)", scrollSnapType: [u3 ? "x" : "y", i("snapType")].join(" "), gridAutoFlow: u3 ? "column" : "row", scrollbarWidth: "none", overscrollBehaviorX: "contain", [u3 ? "gridAutoColumns" : "gridAutoRows"]: b10 ? void 0 : "var(--slide-item-size)", [u3 ? "scrollPaddingInline" : "scrollPaddingBlock"]: D11, [u3 ? "paddingInline" : "paddingBlock"]: D11, [u3 ? "overflowX" : "overflowY"]: "auto" } }));
    }, getItemProps(s) {
      let d4 = r3.get("slidesInView").includes(s.index);
      return e4.element(__spreadProps(__spreadValues({}, v2.item.attrs), { id: Rt2(l4, s.index), dir: i("dir"), role: "group", "data-index": s.index, "data-inview": jr(d4), "aria-roledescription": "slide", "data-orientation": i("orientation"), "aria-label": m5.item(s.index, i("slideCount")), "aria-hidden": Br(!d4), style: { flex: "0 0 auto", [u3 ? "maxWidth" : "maxHeight"]: "100%", scrollSnapAlign: (() => {
        var _a2;
        let R7 = (_a2 = s.snapAlign) != null ? _a2 : "start", E15 = i("slidesPerMove"), C17 = E15 === "auto" ? Math.floor(i("slidesPerPage")) : E15;
        return (s.index + C17) % C17 === 0 ? R7 : void 0;
      })() } }));
    }, getControlProps() {
      return e4.element(__spreadProps(__spreadValues({}, v2.control.attrs), { "data-orientation": i("orientation") }));
    }, getPrevTriggerProps() {
      return e4.button(__spreadProps(__spreadValues({}, v2.prevTrigger.attrs), { id: Ct2(l4), type: "button", disabled: !p4, dir: i("dir"), "aria-label": m5.prevTrigger, "data-orientation": i("orientation"), "aria-controls": N3(l4), onClick(s) {
        s.defaultPrevented || a3({ type: "PAGE.PREV", src: "trigger" });
      } }));
    }, getNextTriggerProps() {
      return e4.button(__spreadProps(__spreadValues({}, v2.nextTrigger.attrs), { dir: i("dir"), id: bt2(l4), type: "button", "aria-label": m5.nextTrigger, "data-orientation": i("orientation"), "aria-controls": N3(l4), disabled: !f4, onClick(s) {
        s.defaultPrevented || a3({ type: "PAGE.NEXT", src: "trigger" });
      } }));
    }, getIndicatorGroupProps() {
      return e4.element(__spreadProps(__spreadValues({}, v2.indicatorGroup.attrs), { dir: i("dir"), id: It2(l4), "data-orientation": i("orientation"), onKeyDown(s) {
        if (s.defaultPrevented) return;
        let d4 = "indicator", R7 = { ArrowDown(P11) {
          u3 || (a3({ type: "PAGE.NEXT", src: d4 }), P11.preventDefault());
        }, ArrowUp(P11) {
          u3 || (a3({ type: "PAGE.PREV", src: d4 }), P11.preventDefault());
        }, ArrowRight(P11) {
          u3 && (a3({ type: "PAGE.NEXT", src: d4 }), P11.preventDefault());
        }, ArrowLeft(P11) {
          u3 && (a3({ type: "PAGE.PREV", src: d4 }), P11.preventDefault());
        }, Home(P11) {
          a3({ type: "PAGE.SET", index: 0, src: d4 }), P11.preventDefault();
        }, End(P11) {
          a3({ type: "PAGE.SET", index: h6.length - 1, src: d4 }), P11.preventDefault();
        } }, E15 = io(s, { dir: i("dir"), orientation: i("orientation") }), C17 = R7[E15];
        C17 == null ? void 0 : C17(s);
      } }));
    }, getIndicatorProps(s) {
      return e4.button(__spreadProps(__spreadValues({}, v2.indicator.attrs), { dir: i("dir"), id: mt2(l4, s.index), type: "button", "data-orientation": i("orientation"), "data-index": s.index, "data-readonly": jr(s.readOnly), "data-current": jr(s.index === S13), "aria-label": m5.indicator(s.index), onClick(d4) {
        d4.defaultPrevented || s.readOnly || a3({ type: "PAGE.SET", index: s.index, src: "indicator" });
      } }));
    }, getAutoplayTriggerProps() {
      return e4.button(__spreadProps(__spreadValues({}, v2.autoplayTrigger.attrs), { type: "button", "data-orientation": i("orientation"), "data-pressed": jr(g7), "aria-label": g7 ? m5.autoplayStop : m5.autoplayStart, onClick(s) {
        s.defaultPrevented || a3({ type: g7 ? "AUTOPLAY.PAUSE" : "AUTOPLAY.START" });
      } }));
    }, getProgressTextProps() {
      return e4.element(__spreadValues({}, v2.progressText.attrs));
    } };
  }
  function wt2(t, e4, o2) {
    if (t == null || o2 <= 0) return [];
    let r3 = [], n = e4 === "auto" ? Math.floor(o2) : e4;
    if (n <= 0) return [];
    for (let a3 = 0; a3 < t && !(a3 + o2 > t); a3 += n) r3.push(a3);
    return r3;
  }
  var $2, Y4, X4, At2, v2, xt2, Rt2, N3, bt2, Ct2, It2, mt2, y4, yt2, Dt2, St2, vt2, Gt2, Bt2, kt2, Yt2, Lt2, Xt2, H4, Jt2;
  var init_carousel = __esm({
    "../priv/static/carousel.mjs"() {
      "use strict";
      init_chunk_IYURAQ6S();
      $2 = (t) => zr(t).direction;
      Y4 = (t) => [...new Set(t)];
      X4 = (t, e4) => (o2) => Math.max(t, Math.min(e4, o2));
      At2 = G("carousel").parts("root", "itemGroup", "item", "control", "nextTrigger", "prevTrigger", "indicatorGroup", "indicator", "autoplayTrigger", "progressText");
      v2 = At2.build();
      xt2 = (t) => {
        var _a2, _b;
        return (_b = (_a2 = t.ids) == null ? void 0 : _a2.root) != null ? _b : `carousel:${t.id}`;
      };
      Rt2 = (t, e4) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = t.ids) == null ? void 0 : _a2.item) == null ? void 0 : _b.call(_a2, e4)) != null ? _c : `carousel:${t.id}:item:${e4}`;
      };
      N3 = (t) => {
        var _a2, _b;
        return (_b = (_a2 = t.ids) == null ? void 0 : _a2.itemGroup) != null ? _b : `carousel:${t.id}:item-group`;
      };
      bt2 = (t) => {
        var _a2, _b;
        return (_b = (_a2 = t.ids) == null ? void 0 : _a2.nextTrigger) != null ? _b : `carousel:${t.id}:next-trigger`;
      };
      Ct2 = (t) => {
        var _a2, _b;
        return (_b = (_a2 = t.ids) == null ? void 0 : _a2.prevTrigger) != null ? _b : `carousel:${t.id}:prev-trigger`;
      };
      It2 = (t) => {
        var _a2, _b;
        return (_b = (_a2 = t.ids) == null ? void 0 : _a2.indicatorGroup) != null ? _b : `carousel:${t.id}:indicator-group`;
      };
      mt2 = (t, e4) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = t.ids) == null ? void 0 : _a2.indicator) == null ? void 0 : _b.call(_a2, e4)) != null ? _c : `carousel:${t.id}:indicator:${e4}`;
      };
      y4 = (t) => t.getById(N3(t));
      yt2 = (t) => Po(y4(t), "[data-part=item]");
      Dt2 = (t, e4) => t.getById(mt2(t, e4));
      St2 = (t) => {
        let e4 = y4(t);
        if (!e4) return;
        let o2 = Pt(e4);
        e4.setAttribute("tabindex", o2.length > 0 ? "-1" : "0");
      };
      vt2 = { props({ props: t }) {
        return hs(t, ["slideCount"], "carousel"), __spreadProps(__spreadValues({ dir: "ltr", defaultPage: 0, orientation: "horizontal", snapType: "mandatory", loop: !!t.autoplay, slidesPerPage: 1, slidesPerMove: "auto", spacing: "0px", autoplay: false, allowMouseDrag: false, inViewThreshold: 0.6, autoSize: false }, t), { translations: __spreadValues({ nextTrigger: "Next slide", prevTrigger: "Previous slide", indicator: (e4) => `Go to slide ${e4 + 1}`, item: (e4, o2) => `${e4 + 1} of ${o2}`, autoplayStart: "Start slide rotation", autoplayStop: "Stop slide rotation", progressText: ({ page: e4, totalPages: o2 }) => `${e4} / ${o2}` }, t.translations) });
      }, refs() {
        return { timeoutRef: void 0 };
      }, initialState({ prop: t }) {
        return t("autoplay") ? "autoplay" : "idle";
      }, context({ prop: t, bindable: e4, getContext: o2 }) {
        return { page: e4(() => ({ defaultValue: t("defaultPage"), value: t("page"), onChange(r3) {
          var _a2;
          let a3 = o2().get("pageSnapPoints");
          (_a2 = t("onPageChange")) == null ? void 0 : _a2({ page: r3, pageSnapPoint: a3[r3] });
        } })), pageSnapPoints: e4(() => ({ defaultValue: t("autoSize") ? Array.from({ length: t("slideCount") }, (r3, n) => n) : wt2(t("slideCount"), t("slidesPerMove"), t("slidesPerPage")) })), slidesInView: e4(() => ({ defaultValue: [] })) };
      }, computed: { isRtl: ({ prop: t }) => t("dir") === "rtl", isHorizontal: ({ prop: t }) => t("orientation") === "horizontal", canScrollNext: ({ prop: t, context: e4 }) => t("loop") || e4.get("page") < e4.get("pageSnapPoints").length - 1, canScrollPrev: ({ prop: t, context: e4 }) => t("loop") || e4.get("page") > 0, autoplayInterval: ({ prop: t }) => {
        let e4 = t("autoplay");
        return Wo(e4) ? e4.delay : 4e3;
      } }, watch({ track: t, action: e4, context: o2, prop: r3, send: n }) {
        t([() => r3("slidesPerPage"), () => r3("slidesPerMove")], () => {
          e4(["setSnapPoints"]);
        }), t([() => o2.get("page")], () => {
          e4(["scrollToPage", "focusIndicatorEl"]);
        }), t([() => r3("orientation"), () => r3("autoSize"), () => r3("dir")], () => {
          e4(["setSnapPoints", "scrollToPage"]);
        }), t([() => r3("slideCount")], () => {
          n({ type: "SNAP.REFRESH", src: "slide.count" });
        }), t([() => !!r3("autoplay")], () => {
          n({ type: r3("autoplay") ? "AUTOPLAY.START" : "AUTOPLAY.PAUSE", src: "autoplay.prop.change" });
        });
      }, on: { "PAGE.NEXT": { target: "idle", actions: ["clearScrollEndTimer", "setNextPage"] }, "PAGE.PREV": { target: "idle", actions: ["clearScrollEndTimer", "setPrevPage"] }, "PAGE.SET": { target: "idle", actions: ["clearScrollEndTimer", "setPage"] }, "INDEX.SET": { target: "idle", actions: ["clearScrollEndTimer", "setMatchingPage"] }, "SNAP.REFRESH": { actions: ["setSnapPoints", "clampPage"] }, "PAGE.SCROLL": { actions: ["scrollToPage"] } }, effects: ["trackSlideMutation", "trackSlideIntersections", "trackSlideResize"], entry: ["setSnapPoints", "setPage"], exit: ["clearScrollEndTimer"], states: { idle: { on: { "DRAGGING.START": { target: "dragging", actions: ["invokeDragStart"] }, "AUTOPLAY.START": { target: "autoplay", actions: ["invokeAutoplayStart"] }, "USER.SCROLL": { target: "userScroll" }, "VIEWPORT.FOCUS": { target: "focus" } } }, focus: { effects: ["trackKeyboardScroll"], on: { "VIEWPORT.BLUR": { target: "idle" }, "PAGE.NEXT": { actions: ["clearScrollEndTimer", "setNextPage"] }, "PAGE.PREV": { actions: ["clearScrollEndTimer", "setPrevPage"] }, "PAGE.SET": { actions: ["clearScrollEndTimer", "setPage"] }, "INDEX.SET": { actions: ["clearScrollEndTimer", "setMatchingPage"] }, "USER.SCROLL": { target: "userScroll" } } }, dragging: { effects: ["trackPointerMove"], entry: ["disableScrollSnap"], on: { DRAGGING: { actions: ["scrollSlides", "invokeDragging"] }, "DRAGGING.END": { target: "idle", actions: ["endDragging", "invokeDraggingEnd"] } } }, userScroll: { effects: ["trackScroll"], on: { "DRAGGING.START": { target: "dragging", actions: ["invokeDragStart"] }, "SCROLL.END": [{ guard: "isFocused", target: "focus", actions: ["setClosestPage"] }, { target: "idle", actions: ["setClosestPage"] }] } }, autoplay: { effects: ["trackDocumentVisibility", "trackScroll", "autoUpdateSlide"], exit: ["invokeAutoplayEnd"], on: { "AUTOPLAY.TICK": { actions: ["setNextPage", "invokeAutoplay"] }, "DRAGGING.START": { target: "dragging", actions: ["invokeDragStart"] }, "AUTOPLAY.PAUSE": { target: "idle" } } } }, implementations: { guards: { isFocused: ({ scope: t }) => t.isActiveElement(y4(t)) }, effects: { autoUpdateSlide({ computed: t, send: e4 }) {
        let o2 = setInterval(() => {
          e4({ type: t("canScrollNext") ? "AUTOPLAY.TICK" : "AUTOPLAY.PAUSE", src: "autoplay.interval" });
        }, t("autoplayInterval"));
        return () => clearInterval(o2);
      }, trackSlideMutation({ scope: t, send: e4 }) {
        let o2 = y4(t);
        if (!o2) return;
        let r3 = t.getWin(), n = new r3.MutationObserver(() => {
          e4({ type: "SNAP.REFRESH", src: "slide.mutation" }), St2(t);
        });
        return St2(t), n.observe(o2, { childList: true, subtree: true }), () => n.disconnect();
      }, trackSlideResize({ scope: t, send: e4 }) {
        if (!y4(t)) return;
        let r3 = () => {
          e4({ type: "SNAP.REFRESH", src: "slide.resize" });
        };
        nt(() => {
          r3(), nt(() => {
            e4({ type: "PAGE.SCROLL", instant: true });
          });
        });
        let n = yt2(t);
        n.forEach(r3);
        let a3 = n.map((l4) => Ro.observe(l4, r3));
        return re(...a3);
      }, trackSlideIntersections({ scope: t, prop: e4, context: o2 }) {
        let r3 = y4(t), n = t.getWin(), a3 = new n.IntersectionObserver((l4) => {
          let i = l4.reduce((g7, c5) => {
            var _a2;
            let f4 = c5.target, p4 = Number((_a2 = f4.dataset.index) != null ? _a2 : "-1");
            return p4 == null || Number.isNaN(p4) || p4 === -1 ? g7 : c5.isIntersecting ? Hn(g7, p4) : Un(g7, p4);
          }, o2.get("slidesInView"));
          o2.set("slidesInView", Do(i));
        }, { root: r3, threshold: e4("inViewThreshold") });
        return yt2(t).forEach((l4) => a3.observe(l4)), () => a3.disconnect();
      }, trackScroll({ send: t, refs: e4, scope: o2 }) {
        let r3 = y4(o2);
        return r3 ? P(r3, "scroll", () => {
          clearTimeout(e4.get("timeoutRef")), e4.set("timeoutRef", void 0), e4.set("timeoutRef", setTimeout(() => {
            t({ type: "SCROLL.END" });
          }, 150));
        }, { passive: true }) : void 0;
      }, trackDocumentVisibility({ scope: t, send: e4 }) {
        let o2 = t.getDoc();
        return P(o2, "visibilitychange", () => {
          o2.visibilityState !== "visible" && e4({ type: "AUTOPLAY.PAUSE", src: "doc.hidden" });
        });
      }, trackPointerMove({ scope: t, send: e4 }) {
        let o2 = t.getDoc();
        return Eo(o2, { onPointerMove({ event: r3 }) {
          e4({ type: "DRAGGING", left: -r3.movementX, top: -r3.movementY });
        }, onPointerUp() {
          e4({ type: "DRAGGING.END" });
        } });
      }, trackKeyboardScroll({ scope: t, send: e4, context: o2 }) {
        let r3 = t.getWin();
        return P(r3, "keydown", (a3) => {
          switch (a3.key) {
            case "ArrowRight":
              a3.preventDefault(), e4({ type: "PAGE.NEXT" });
              break;
            case "ArrowLeft":
              a3.preventDefault(), e4({ type: "PAGE.PREV" });
              break;
            case "Home":
              a3.preventDefault(), e4({ type: "PAGE.SET", index: 0 });
              break;
            case "End":
              a3.preventDefault(), e4({ type: "PAGE.SET", index: o2.get("pageSnapPoints").length - 1 });
          }
        }, { capture: true });
      } }, actions: { clearScrollEndTimer({ refs: t }) {
        t.get("timeoutRef") != null && (clearTimeout(t.get("timeoutRef")), t.set("timeoutRef", void 0));
      }, scrollToPage({ context: t, event: e4, scope: o2, computed: r3, flush: n }) {
        var _a2;
        let a3 = e4.instant ? "instant" : "smooth", l4 = ts((_a2 = e4.index) != null ? _a2 : t.get("page"), 0, t.get("pageSnapPoints").length - 1), i = y4(o2);
        if (!i) return;
        let g7 = r3("isHorizontal") ? "left" : "top";
        n(() => {
          i.scrollTo({ [g7]: t.get("pageSnapPoints")[l4], behavior: a3 });
        });
      }, setClosestPage({ context: t, scope: e4, computed: o2 }) {
        let r3 = y4(e4);
        if (!r3) return;
        let n = o2("isHorizontal") ? r3.scrollLeft : r3.scrollTop, a3 = t.get("pageSnapPoints").findIndex((l4) => Math.abs(l4 - n) < 1);
        a3 !== -1 && t.set("page", a3);
      }, setNextPage({ context: t, prop: e4, state: o2 }) {
        let r3 = o2.matches("autoplay") || e4("loop"), n = Qt(t.get("pageSnapPoints"), t.get("page"), { loop: r3 });
        t.set("page", n);
      }, setPrevPage({ context: t, prop: e4, state: o2 }) {
        let r3 = o2.matches("autoplay") || e4("loop"), n = Yn(t.get("pageSnapPoints"), t.get("page"), { loop: r3 });
        t.set("page", n);
      }, setMatchingPage({ context: t, event: e4, computed: o2, scope: r3 }) {
        let n = y4(r3);
        if (!n) return;
        let a3 = ht2(n, o2("isHorizontal") ? "x" : "y", (i) => i.dataset.index === e4.index.toString());
        if (a3 == null) return;
        let l4 = t.get("pageSnapPoints").findIndex((i) => Math.abs(i - a3) < 1);
        t.set("page", l4);
      }, setPage({ context: t, event: e4 }) {
        var _a2;
        let o2 = (_a2 = e4.index) != null ? _a2 : t.get("page");
        t.set("page", o2);
      }, clampPage({ context: t }) {
        let e4 = ts(t.get("page"), 0, t.get("pageSnapPoints").length - 1);
        t.set("page", e4);
      }, setSnapPoints({ context: t, computed: e4, scope: o2 }) {
        let r3 = y4(o2);
        if (!r3) return;
        let n = Pt2(r3);
        t.set("pageSnapPoints", e4("isHorizontal") ? n.x : n.y);
      }, disableScrollSnap({ scope: t }) {
        let e4 = y4(t);
        if (!e4) return;
        let o2 = getComputedStyle(e4);
        e4.dataset.scrollSnapType = o2.getPropertyValue("scroll-snap-type"), e4.style.setProperty("scroll-snap-type", "none");
      }, scrollSlides({ scope: t, event: e4 }) {
        var _a2;
        (_a2 = y4(t)) == null ? void 0 : _a2.scrollBy({ left: e4.left, top: e4.top, behavior: "instant" });
      }, endDragging({ scope: t, context: e4, computed: o2 }) {
        let r3 = y4(t);
        if (!r3) return;
        let n = o2("isHorizontal"), a3 = n ? r3.scrollLeft : r3.scrollTop, l4 = e4.get("pageSnapPoints"), i = l4.reduce((g7, c5) => Math.abs(c5 - a3) < Math.abs(g7 - a3) ? c5 : g7, l4[0]);
        nt(() => {
          r3.scrollTo({ left: n ? i : r3.scrollLeft, top: n ? r3.scrollTop : i, behavior: "smooth" }), e4.set("page", l4.indexOf(i));
          let g7 = r3.dataset.scrollSnapType;
          g7 && (r3.style.setProperty("scroll-snap-type", g7), delete r3.dataset.scrollSnapType);
        });
      }, focusIndicatorEl({ context: t, event: e4, scope: o2 }) {
        if (e4.src !== "indicator") return;
        let r3 = Dt2(o2, t.get("page"));
        r3 && nt(() => r3.focus({ preventScroll: true }));
      }, invokeDragStart({ context: t, prop: e4 }) {
        var _a2;
        (_a2 = e4("onDragStatusChange")) == null ? void 0 : _a2({ type: "dragging.start", isDragging: true, page: t.get("page") });
      }, invokeDragging({ context: t, prop: e4 }) {
        var _a2;
        (_a2 = e4("onDragStatusChange")) == null ? void 0 : _a2({ type: "dragging", isDragging: true, page: t.get("page") });
      }, invokeDraggingEnd({ context: t, prop: e4 }) {
        var _a2;
        (_a2 = e4("onDragStatusChange")) == null ? void 0 : _a2({ type: "dragging.end", isDragging: false, page: t.get("page") });
      }, invokeAutoplay({ context: t, prop: e4 }) {
        var _a2;
        (_a2 = e4("onAutoplayStatusChange")) == null ? void 0 : _a2({ type: "autoplay", isPlaying: true, page: t.get("page") });
      }, invokeAutoplayStart({ context: t, prop: e4 }) {
        var _a2;
        (_a2 = e4("onAutoplayStatusChange")) == null ? void 0 : _a2({ type: "autoplay.start", isPlaying: true, page: t.get("page") });
      }, invokeAutoplayEnd({ context: t, prop: e4 }) {
        var _a2;
        (_a2 = e4("onAutoplayStatusChange")) == null ? void 0 : _a2({ type: "autoplay.stop", isPlaying: false, page: t.get("page") });
      } } } };
      Gt2 = As()(["dir", "getRootNode", "id", "ids", "loop", "page", "defaultPage", "onPageChange", "orientation", "slideCount", "slidesPerPage", "slidesPerMove", "spacing", "padding", "autoplay", "allowMouseDrag", "inViewThreshold", "translations", "snapType", "autoSize", "onDragStatusChange", "onAutoplayStatusChange"]);
      Bt2 = as(Gt2);
      kt2 = As()(["index", "readOnly"]);
      Yt2 = as(kt2);
      Lt2 = As()(["index", "snapAlign"]);
      Xt2 = as(Lt2);
      H4 = class extends ve {
        initMachine(e4) {
          return new Ls(vt2, e4);
        }
        initApi() {
          return Tt2(this.machine.service, Cs);
        }
        render() {
          var _a2;
          let e4 = (_a2 = this.el.querySelector('[data-scope="carousel"][data-part="root"]')) != null ? _a2 : this.el;
          this.spreadProps(e4, this.api.getRootProps());
          let o2 = this.el.querySelector('[data-scope="carousel"][data-part="control"]');
          o2 && this.spreadProps(o2, this.api.getControlProps());
          let r3 = this.el.querySelector('[data-scope="carousel"][data-part="item-group"]');
          r3 && this.spreadProps(r3, this.api.getItemGroupProps());
          let n = Number(this.el.dataset.slideCount) || 0;
          for (let p4 = 0; p4 < n; p4++) {
            let u3 = this.el.querySelector(`[data-scope="carousel"][data-part="item"][data-index="${p4}"]`);
            u3 && this.spreadProps(u3, this.api.getItemProps({ index: p4 }));
          }
          let a3 = this.el.querySelector('[data-scope="carousel"][data-part="prev-trigger"]');
          a3 && this.spreadProps(a3, this.api.getPrevTriggerProps());
          let l4 = this.el.querySelector('[data-scope="carousel"][data-part="next-trigger"]');
          l4 && this.spreadProps(l4, this.api.getNextTriggerProps());
          let i = this.el.querySelector('[data-scope="carousel"][data-part="autoplay-trigger"]');
          i && this.spreadProps(i, this.api.getAutoplayTriggerProps());
          let g7 = this.el.querySelector('[data-scope="carousel"][data-part="indicator-group"]');
          g7 && this.spreadProps(g7, this.api.getIndicatorGroupProps());
          let c5 = this.api.pageSnapPoints.length;
          for (let p4 = 0; p4 < c5; p4++) {
            let u3 = this.el.querySelector(`[data-scope="carousel"][data-part="indicator"][data-index="${p4}"]`);
            u3 && this.spreadProps(u3, this.api.getIndicatorProps({ index: p4 }));
          }
          let f4 = this.el.querySelector('[data-scope="carousel"][data-part="progress-text"]');
          f4 && this.spreadProps(f4, this.api.getProgressTextProps());
        }
      };
      Jt2 = { mounted() {
        var _a2, _b, _c, _d;
        let t = this.el, e4 = Lr(t, "page"), o2 = Lr(t, "defaultPage"), r3 = _r(t, "controlled"), n = Lr(t, "slideCount");
        if (n == null || n < 1) return;
        let a3 = new H4(t, __spreadProps(__spreadValues({ id: t.id, slideCount: n }, r3 && e4 !== void 0 ? { page: e4 } : { defaultPage: o2 != null ? o2 : 0 }), { dir: kr(t), orientation: xr(t, "orientation", ["horizontal", "vertical"]), slidesPerPage: (_a2 = Lr(t, "slidesPerPage")) != null ? _a2 : 1, slidesPerMove: xr(t, "slidesPerMove") === "auto" ? "auto" : Lr(t, "slidesPerMove"), loop: _r(t, "loop"), autoplay: _r(t, "autoplay") ? { delay: (_b = Lr(t, "autoplayDelay")) != null ? _b : 4e3 } : false, allowMouseDrag: _r(t, "allowMouseDrag"), spacing: (_c = xr(t, "spacing")) != null ? _c : "0px", padding: xr(t, "padding"), inViewThreshold: (_d = Lr(t, "inViewThreshold")) != null ? _d : 0.6, snapType: xr(t, "snapType", ["proximity", "mandatory"]), autoSize: _r(t, "autoSize"), onPageChange: (l4) => {
          let i = xr(t, "onPageChange");
          i && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected() && this.pushEvent(i, { page: l4.page, pageSnapPoint: l4.pageSnapPoint, id: t.id });
          let g7 = xr(t, "onPageChangeClient");
          g7 && t.dispatchEvent(new CustomEvent(g7, { bubbles: true, detail: { value: l4, id: t.id } }));
        } }));
        a3.init(), this.carousel = a3, this.handlers = [];
      }, updated() {
        var _a2, _b;
        let t = Lr(this.el, "slideCount");
        if (t == null || t < 1) return;
        let e4 = Lr(this.el, "page"), o2 = _r(this.el, "controlled");
        (_b = this.carousel) == null ? void 0 : _b.updateProps(__spreadProps(__spreadValues({ id: this.el.id, slideCount: t }, o2 && e4 !== void 0 ? { page: e4 } : {}), { dir: kr(this.el), orientation: xr(this.el, "orientation", ["horizontal", "vertical"]), slidesPerPage: (_a2 = Lr(this.el, "slidesPerPage")) != null ? _a2 : 1, loop: _r(this.el, "loop"), allowMouseDrag: _r(this.el, "allowMouseDrag") }));
      }, destroyed() {
        var _a2;
        if (this.handlers) for (let t of this.handlers) this.removeHandleEvent(t);
        (_a2 = this.carousel) == null ? void 0 : _a2.destroy();
      } };
    }
  });

  // ../priv/static/chunk-XQAZHZIC.mjs
  function F3(e4) {
    return !(e4.metaKey || !tt() && e4.altKey || e4.ctrlKey || e4.key === "Control" || e4.key === "Shift" || e4.key === "Meta");
  }
  function C5(e4, r3, t) {
    let n = t ? Je(t) : null, i = T(n);
    return e4 = e4 || n instanceof i.HTMLInputElement && !T2.has(n == null ? void 0 : n.type) || n instanceof i.HTMLTextAreaElement || n instanceof i.HTMLElement && n.isContentEditable, !(e4 && r3 === "keyboard" && t instanceof i.KeyboardEvent && !Reflect.has(H5, t.key));
  }
  function v3(e4, r3) {
    for (let t of E4) t(e4, r3);
  }
  function l3(e4) {
    a = true, F3(e4) && (u = "keyboard", v3("keyboard", e4));
  }
  function o(e4) {
    u = "pointer", (e4.type === "mousedown" || e4.type === "pointerdown") && (a = true, v3("pointer", e4));
  }
  function g(e4) {
    no(e4) && (a = true, u = "virtual");
  }
  function w2(e4) {
    let r3 = Je(e4);
    r3 === T(r3) || r3 === q(r3) || (!a && !p2 && (u = "virtual", v3("virtual", e4)), a = false, p2 = false);
  }
  function k3() {
    a = false, p2 = true;
  }
  function K4(e4) {
    if (typeof window > "u" || d2.get(T(e4))) return;
    let r3 = T(e4), t = q(e4), n = r3.HTMLElement.prototype.focus;
    function i() {
      u = "virtual", v3("virtual", null), a = true, n.apply(this, arguments);
    }
    try {
      Object.defineProperty(r3.HTMLElement.prototype, "focus", { configurable: true, value: i });
    } catch (e5) {
    }
    t.addEventListener("keydown", l3, true), t.addEventListener("keyup", l3, true), t.addEventListener("click", g, true), r3.addEventListener("focus", w2, true), r3.addEventListener("blur", k3, false), typeof r3.PointerEvent < "u" ? (t.addEventListener("pointerdown", o, true), t.addEventListener("pointermove", o, true), t.addEventListener("pointerup", o, true)) : (t.addEventListener("mousedown", o, true), t.addEventListener("mousemove", o, true), t.addEventListener("mouseup", o, true)), r3.addEventListener("beforeunload", () => {
      I5(e4);
    }, { once: true }), d2.set(r3, { focus: n });
  }
  function P5() {
    return u;
  }
  function h2() {
    return u === "keyboard";
  }
  function S5(e4 = {}) {
    let { isTextInput: r3, autoFocus: t, onChange: n, root: i } = e4;
    K4(i), n == null ? void 0 : n({ isFocusVisible: t || h2(), modality: u });
    let y11 = (m5, M10) => {
      C5(!!r3, m5, M10) && (n == null ? void 0 : n({ isFocusVisible: h2(), modality: m5 }));
    };
    return E4.add(y11), () => {
      E4.delete(y11);
    };
  }
  var T2, u, E4, d2, a, p2, H5, I5;
  var init_chunk_XQAZHZIC = __esm({
    "../priv/static/chunk-XQAZHZIC.mjs"() {
      "use strict";
      init_chunk_IYURAQ6S();
      T2 = /* @__PURE__ */ new Set(["checkbox", "radio", "range", "color", "file", "image", "button", "submit", "reset"]);
      u = null;
      E4 = /* @__PURE__ */ new Set();
      d2 = /* @__PURE__ */ new Map();
      a = false;
      p2 = false;
      H5 = { Tab: true, Escape: true };
      I5 = (e4, r3) => {
        let t = T(e4), n = q(e4), i = d2.get(t);
        if (i) {
          try {
            Object.defineProperty(t.HTMLElement.prototype, "focus", { configurable: true, value: i.focus });
          } catch (e5) {
          }
          n.removeEventListener("keydown", l3, true), n.removeEventListener("keyup", l3, true), n.removeEventListener("click", g, true), t.removeEventListener("focus", w2, true), t.removeEventListener("blur", k3, false), typeof t.PointerEvent < "u" ? (n.removeEventListener("pointerdown", o, true), n.removeEventListener("pointermove", o, true), n.removeEventListener("pointerup", o, true)) : (n.removeEventListener("mousedown", o, true), n.removeEventListener("mousemove", o, true), n.removeEventListener("mouseup", o, true)), d2.delete(t);
        }
      };
    }
  });

  // ../priv/static/checkbox.mjs
  var checkbox_exports = {};
  __export(checkbox_exports, {
    Checkbox: () => pe3
  });
  function G4(e4, t) {
    let { send: o2, context: i, prop: s, computed: n, scope: h6 } = e4, l4 = !!s("disabled"), E15 = !!s("readOnly"), B12 = !!s("required"), y11 = !!s("invalid"), x14 = !l4 && i.get("focused"), $13 = !l4 && i.get("focusVisible"), u3 = n("checked"), g7 = n("indeterminate"), J15 = i.get("checked"), p4 = { "data-active": jr(i.get("active")), "data-focus": jr(x14), "data-focus-visible": jr($13), "data-readonly": jr(E15), "data-hover": jr(i.get("hovered")), "data-disabled": jr(l4), "data-state": g7 ? "indeterminate" : u3 ? "checked" : "unchecked", "data-invalid": jr(y11), "data-required": jr(B12) };
    return { checked: u3, disabled: l4, indeterminate: g7, focused: x14, checkedState: J15, setChecked(a3) {
      o2({ type: "CHECKED.SET", checked: a3, isTrusted: false });
    }, toggleChecked() {
      o2({ type: "CHECKED.TOGGLE", checked: u3, isTrusted: false });
    }, getRootProps() {
      return t.label(__spreadProps(__spreadValues(__spreadValues({}, f.root.attrs), p4), { dir: s("dir"), id: K5(h6), htmlFor: m(h6), onPointerMove() {
        l4 || o2({ type: "CONTEXT.SET", context: { hovered: true } });
      }, onPointerLeave() {
        l4 || o2({ type: "CONTEXT.SET", context: { hovered: false } });
      }, onClick(a3) {
        Je(a3) === k4(h6) && a3.stopPropagation();
      } }));
    }, getLabelProps() {
      return t.element(__spreadProps(__spreadValues(__spreadValues({}, f.label.attrs), p4), { dir: s("dir"), id: w3(h6) }));
    }, getControlProps() {
      return t.element(__spreadProps(__spreadValues(__spreadValues({}, f.control.attrs), p4), { dir: s("dir"), id: U3(h6), "aria-hidden": true }));
    }, getIndicatorProps() {
      return t.element(__spreadProps(__spreadValues(__spreadValues({}, f.indicator.attrs), p4), { dir: s("dir"), hidden: !g7 && !u3 }));
    }, getHiddenInputProps() {
      return t.input({ id: m(h6), type: "checkbox", required: s("required"), defaultChecked: u3, disabled: l4, "aria-labelledby": w3(h6), "aria-invalid": y11, name: s("name"), form: s("form"), value: s("value"), style: Co, onFocus() {
        let a3 = h2();
        o2({ type: "CONTEXT.SET", context: { focused: true, focusVisible: a3 } });
      }, onBlur() {
        o2({ type: "CONTEXT.SET", context: { focused: false, focusVisible: false } });
      }, onClick(a3) {
        if (E15) {
          a3.preventDefault();
          return;
        }
        let T7 = a3.currentTarget.checked;
        o2({ type: "CHECKED.SET", checked: T7, isTrusted: true });
      } });
    } };
  }
  function C6(e4) {
    return e4 === "indeterminate";
  }
  function Y5(e4) {
    return C6(e4) ? false : !!e4;
  }
  var Q5, f, K5, w3, U3, m, W4, k4, j4, X5, Z5, ce2, v4, pe3;
  var init_checkbox = __esm({
    "../priv/static/checkbox.mjs"() {
      "use strict";
      init_chunk_XQAZHZIC();
      init_chunk_IYURAQ6S();
      Q5 = G("checkbox").parts("root", "label", "control", "indicator");
      f = Q5.build();
      K5 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.root) != null ? _b : `checkbox:${e4.id}`;
      };
      w3 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.label) != null ? _b : `checkbox:${e4.id}:label`;
      };
      U3 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.control) != null ? _b : `checkbox:${e4.id}:control`;
      };
      m = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.hiddenInput) != null ? _b : `checkbox:${e4.id}:input`;
      };
      W4 = (e4) => e4.getById(K5(e4));
      k4 = (e4) => e4.getById(m(e4));
      ({ not: j4 } = dr());
      X5 = { props({ props: e4 }) {
        var _a2;
        return __spreadProps(__spreadValues({ value: "on" }, e4), { defaultChecked: (_a2 = e4.defaultChecked) != null ? _a2 : false });
      }, initialState() {
        return "ready";
      }, context({ prop: e4, bindable: t }) {
        return { checked: t(() => ({ defaultValue: e4("defaultChecked"), value: e4("checked"), onChange(o2) {
          var _a2;
          (_a2 = e4("onCheckedChange")) == null ? void 0 : _a2({ checked: o2 });
        } })), fieldsetDisabled: t(() => ({ defaultValue: false })), focusVisible: t(() => ({ defaultValue: false })), active: t(() => ({ defaultValue: false })), focused: t(() => ({ defaultValue: false })), hovered: t(() => ({ defaultValue: false })) };
      }, watch({ track: e4, context: t, prop: o2, action: i }) {
        e4([() => o2("disabled")], () => {
          i(["removeFocusIfNeeded"]);
        }), e4([() => t.get("checked")], () => {
          i(["syncInputElement"]);
        });
      }, effects: ["trackFormControlState", "trackPressEvent", "trackFocusVisible"], on: { "CHECKED.TOGGLE": [{ guard: j4("isTrusted"), actions: ["toggleChecked", "dispatchChangeEvent"] }, { actions: ["toggleChecked"] }], "CHECKED.SET": [{ guard: j4("isTrusted"), actions: ["setChecked", "dispatchChangeEvent"] }, { actions: ["setChecked"] }], "CONTEXT.SET": { actions: ["setContext"] } }, computed: { indeterminate: ({ context: e4 }) => C6(e4.get("checked")), checked: ({ context: e4 }) => Y5(e4.get("checked")), disabled: ({ context: e4, prop: t }) => !!t("disabled") || e4.get("fieldsetDisabled") }, states: { ready: {} }, implementations: { guards: { isTrusted: ({ event: e4 }) => !!e4.isTrusted }, effects: { trackPressEvent({ context: e4, computed: t, scope: o2 }) {
        if (!t("disabled")) return Ao({ pointerNode: W4(o2), keyboardNode: k4(o2), isValidKey: (i) => i.key === " ", onPress: () => e4.set("active", false), onPressStart: () => e4.set("active", true), onPressEnd: () => e4.set("active", false) });
      }, trackFocusVisible({ computed: e4, scope: t }) {
        var _a2;
        if (!e4("disabled")) return S5({ root: (_a2 = t.getRootNode) == null ? void 0 : _a2.call(t) });
      }, trackFormControlState({ context: e4, scope: t }) {
        return lo(k4(t), { onFieldsetDisabledChange(o2) {
          e4.set("fieldsetDisabled", o2);
        }, onFormReset() {
          e4.set("checked", e4.initial("checked"));
        } });
      } }, actions: { setContext({ context: e4, event: t }) {
        for (let o2 in t.context) e4.set(o2, t.context[o2]);
      }, syncInputElement({ context: e4, computed: t, scope: o2 }) {
        let i = k4(o2);
        i && (cn(i, t("checked")), i.indeterminate = C6(e4.get("checked")));
      }, removeFocusIfNeeded({ context: e4, prop: t }) {
        t("disabled") && e4.get("focused") && (e4.set("focused", false), e4.set("focusVisible", false));
      }, setChecked({ context: e4, event: t }) {
        e4.set("checked", t.checked);
      }, toggleChecked({ context: e4, computed: t }) {
        let o2 = C6(t("checked")) ? true : !t("checked");
        e4.set("checked", o2);
      }, dispatchChangeEvent({ computed: e4, scope: t }) {
        queueMicrotask(() => {
          let o2 = k4(t);
          uo(o2, { checked: e4("checked") });
        });
      } } } };
      Z5 = As()(["defaultChecked", "checked", "dir", "disabled", "form", "getRootNode", "id", "ids", "invalid", "name", "onCheckedChange", "readOnly", "required", "value"]);
      ce2 = as(Z5);
      v4 = class extends ve {
        initMachine(t) {
          return new Ls(X5, t);
        }
        initApi() {
          return G4(this.machine.service, Cs);
        }
        render() {
          let t = this.el.querySelector('[data-scope="checkbox"][data-part="root"]');
          if (!t) return;
          this.spreadProps(t, this.api.getRootProps());
          let o2 = t.querySelector(':scope > [data-scope="checkbox"][data-part="hidden-input"]');
          o2 && this.spreadProps(o2, this.api.getHiddenInputProps());
          let i = t.querySelector(':scope > [data-scope="checkbox"][data-part="label"]');
          i && this.spreadProps(i, this.api.getLabelProps());
          let s = t.querySelector(':scope > [data-scope="checkbox"][data-part="control"]');
          if (s) {
            this.spreadProps(s, this.api.getControlProps());
            let n = s.querySelector(':scope > [data-scope="checkbox"][data-part="indicator"]');
            n && this.spreadProps(n, this.api.getIndicatorProps());
          }
        }
      };
      pe3 = { mounted() {
        let e4 = this.el, t = this.pushEvent.bind(this), o2 = new v4(e4, __spreadProps(__spreadValues({ id: e4.id }, _r(e4, "controlled") ? { checked: _r(e4, "checked") } : { defaultChecked: _r(e4, "defaultChecked") }), { disabled: _r(e4, "disabled"), name: xr(e4, "name"), form: xr(e4, "form"), value: xr(e4, "value"), dir: kr(e4), invalid: _r(e4, "invalid"), required: _r(e4, "required"), readOnly: _r(e4, "readOnly"), onCheckedChange: (i) => {
          let s = xr(e4, "onCheckedChange");
          s && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected() && t(s, { checked: i.checked, id: e4.id });
          let n = xr(e4, "onCheckedChangeClient");
          n && e4.dispatchEvent(new CustomEvent(n, { bubbles: true, detail: { value: i, id: e4.id } }));
        } }));
        o2.init(), this.checkbox = o2, this.onSetChecked = (i) => {
          let { checked: s } = i.detail;
          o2.api.setChecked(s);
        }, e4.addEventListener("phx:checkbox:set-checked", this.onSetChecked), this.onToggleChecked = () => {
          o2.api.toggleChecked();
        }, e4.addEventListener("phx:checkbox:toggle-checked", this.onToggleChecked), this.handlers = [], this.handlers.push(this.handleEvent("checkbox_set_checked", (i) => {
          let s = i.id;
          s && s !== e4.id || o2.api.setChecked(i.checked);
        })), this.handlers.push(this.handleEvent("checkbox_toggle_checked", (i) => {
          let s = i.id;
          s && s !== e4.id || o2.api.toggleChecked();
        })), this.handlers.push(this.handleEvent("checkbox_checked", () => {
          this.pushEvent("checkbox_checked_response", { value: o2.api.checked });
        })), this.handlers.push(this.handleEvent("checkbox_focused", () => {
          this.pushEvent("checkbox_focused_response", { value: o2.api.focused });
        })), this.handlers.push(this.handleEvent("checkbox_disabled", () => {
          this.pushEvent("checkbox_disabled_response", { value: o2.api.disabled });
        }));
      }, updated() {
        var _a2;
        (_a2 = this.checkbox) == null ? void 0 : _a2.updateProps(__spreadProps(__spreadValues({ id: this.el.id }, _r(this.el, "controlled") ? { checked: _r(this.el, "checked") } : { defaultChecked: _r(this.el, "defaultChecked") }), { disabled: _r(this.el, "disabled"), name: xr(this.el, "name"), form: xr(this.el, "form"), value: xr(this.el, "value"), dir: kr(this.el), invalid: _r(this.el, "invalid"), required: _r(this.el, "required"), readOnly: _r(this.el, "readOnly"), label: xr(this.el, "label") }));
      }, destroyed() {
        var _a2;
        if (this.onSetChecked && this.el.removeEventListener("phx:checkbox:set-checked", this.onSetChecked), this.onToggleChecked && this.el.removeEventListener("phx:checkbox:toggle-checked", this.onToggleChecked), this.handlers) for (let e4 of this.handlers) this.removeHandleEvent(e4);
        (_a2 = this.checkbox) == null ? void 0 : _a2.destroy();
      } };
    }
  });

  // ../priv/static/clipboard.mjs
  var clipboard_exports = {};
  __export(clipboard_exports, {
    Clipboard: () => K6
  });
  function O3(e4, t) {
    let o2 = e4.createElement("pre");
    return Object.assign(o2.style, { width: "1px", height: "1px", position: "fixed", top: "5px" }), o2.textContent = t, o2;
  }
  function x2(e4) {
    let o2 = T(e4).getSelection();
    if (o2 == null) return Promise.reject(new Error());
    o2.removeAllRanges();
    let i = e4.ownerDocument, r3 = i.createRange();
    return r3.selectNodeContents(e4), o2.addRange(r3), i.execCommand("copy"), o2.removeAllRanges(), Promise.resolve();
  }
  function _2(e4, t) {
    var _a2;
    let o2 = e4.defaultView || window;
    if (((_a2 = o2.navigator.clipboard) == null ? void 0 : _a2.writeText) !== void 0) return o2.navigator.clipboard.writeText(t);
    if (!e4.body) return Promise.reject(new Error());
    let i = O3(e4, t);
    return e4.body.appendChild(i), x2(i), e4.body.removeChild(i), Promise.resolve();
  }
  function S6(e4, t) {
    let { state: o2, send: i, context: r3, scope: a3 } = e4, n = o2.matches("copied");
    return { copied: n, value: r3.get("value"), setValue(l4) {
      i({ type: "VALUE.SET", value: l4 });
    }, copy() {
      i({ type: "COPY" });
    }, getRootProps() {
      return t.element(__spreadProps(__spreadValues({}, d3.root.attrs), { "data-copied": jr(n), id: w4(a3) }));
    }, getLabelProps() {
      return t.label(__spreadProps(__spreadValues({}, d3.label.attrs), { htmlFor: g2(a3), "data-copied": jr(n), id: H6(a3) }));
    }, getControlProps() {
      return t.element(__spreadProps(__spreadValues({}, d3.control.attrs), { "data-copied": jr(n) }));
    }, getInputProps() {
      return t.input(__spreadProps(__spreadValues({}, d3.input.attrs), { defaultValue: r3.get("value"), "data-copied": jr(n), readOnly: true, "data-readonly": "true", id: g2(a3), onFocus(l4) {
        l4.currentTarget.select();
      }, onCopy() {
        i({ type: "INPUT.COPY" });
      } }));
    }, getTriggerProps() {
      return t.button(__spreadProps(__spreadValues({}, d3.trigger.attrs), { type: "button", "aria-label": n ? "Copied to clipboard" : "Copy to clipboard", "data-copied": jr(n), onClick() {
        i({ type: "COPY" });
      } }));
    }, getIndicatorProps(l4) {
      return t.element(__spreadProps(__spreadValues({}, d3.indicator.attrs), { hidden: l4.copied !== n }));
    } };
  }
  var k5, d3, w4, g2, H6, L4, I6, T3, A3, D3, M3, q4, c2, K6;
  var init_clipboard = __esm({
    "../priv/static/clipboard.mjs"() {
      "use strict";
      init_chunk_IYURAQ6S();
      k5 = G("clipboard").parts("root", "control", "trigger", "indicator", "input", "label");
      d3 = k5.build();
      w4 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.root) != null ? _b : `clip:${e4.id}`;
      };
      g2 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.input) != null ? _b : `clip:${e4.id}:input`;
      };
      H6 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.label) != null ? _b : `clip:${e4.id}:label`;
      };
      L4 = (e4) => e4.getById(g2(e4));
      I6 = (e4, t) => _2(e4.getDoc(), t);
      T3 = { props({ props: e4 }) {
        return __spreadValues({ timeout: 3e3, defaultValue: "" }, e4);
      }, initialState() {
        return "idle";
      }, context({ prop: e4, bindable: t }) {
        return { value: t(() => ({ defaultValue: e4("defaultValue"), value: e4("value"), onChange(o2) {
          var _a2;
          (_a2 = e4("onValueChange")) == null ? void 0 : _a2({ value: o2 });
        } })) };
      }, watch({ track: e4, context: t, action: o2 }) {
        e4([() => t.get("value")], () => {
          o2(["syncInputElement"]);
        });
      }, on: { "VALUE.SET": { actions: ["setValue"] }, COPY: { target: "copied", actions: ["copyToClipboard", "invokeOnCopy"] } }, states: { idle: { on: { "INPUT.COPY": { target: "copied", actions: ["invokeOnCopy"] } } }, copied: { effects: ["waitForTimeout"], on: { "COPY.DONE": { target: "idle" }, COPY: { target: "copied", actions: ["copyToClipboard", "invokeOnCopy"] }, "INPUT.COPY": { actions: ["invokeOnCopy"] } } } }, implementations: { effects: { waitForTimeout({ prop: e4, send: t }) {
        return ls(() => {
          t({ type: "COPY.DONE" });
        }, e4("timeout"));
      } }, actions: { setValue({ context: e4, event: t }) {
        e4.set("value", t.value);
      }, copyToClipboard({ context: e4, scope: t }) {
        I6(t, e4.get("value"));
      }, invokeOnCopy({ prop: e4 }) {
        var _a2;
        (_a2 = e4("onStatusChange")) == null ? void 0 : _a2({ copied: true });
      }, syncInputElement({ context: e4, scope: t }) {
        let o2 = L4(t);
        o2 && sn(o2, e4.get("value"));
      } } } };
      A3 = As()(["getRootNode", "id", "ids", "value", "defaultValue", "timeout", "onStatusChange", "onValueChange"]);
      D3 = as(A3);
      M3 = As()(["copied"]);
      q4 = as(M3);
      c2 = class extends ve {
        initMachine(t) {
          return new Ls(T3, t);
        }
        initApi() {
          return S6(this.machine.service, Cs);
        }
        render() {
          let t = this.el.querySelector('[data-scope="clipboard"][data-part="root"]');
          if (t) {
            this.spreadProps(t, this.api.getRootProps());
            let o2 = t.querySelector('[data-scope="clipboard"][data-part="label"]');
            o2 && this.spreadProps(o2, this.api.getLabelProps());
            let i = t.querySelector('[data-scope="clipboard"][data-part="control"]');
            if (i) {
              this.spreadProps(i, this.api.getControlProps());
              let r3 = i.querySelector('[data-scope="clipboard"][data-part="input"]');
              if (r3) {
                let n = __spreadValues({}, this.api.getInputProps()), l4 = this.el.dataset.inputAriaLabel;
                l4 && (n["aria-label"] = l4), this.spreadProps(r3, n);
              }
              let a3 = i.querySelector('[data-scope="clipboard"][data-part="trigger"]');
              if (a3) {
                let n = __spreadValues({}, this.api.getTriggerProps()), l4 = this.el.dataset.triggerAriaLabel;
                l4 && (n["aria-label"] = l4), this.spreadProps(a3, n);
              }
            }
          }
        }
      };
      K6 = { mounted() {
        let e4 = this.el, t = this.pushEvent.bind(this), o2 = this.liveSocket, i = new c2(e4, __spreadProps(__spreadValues({ id: e4.id, timeout: Lr(e4, "timeout") }, _r(e4, "controlled") ? { value: xr(e4, "value") } : { defaultValue: xr(e4, "defaultValue") }), { onValueChange: (r3) => {
          var _a2;
          let a3 = xr(e4, "onValueChange");
          a3 && o2.main.isConnected() && t(a3, { id: e4.id, value: (_a2 = r3.value) != null ? _a2 : null });
        }, onStatusChange: (r3) => {
          let a3 = xr(e4, "onStatusChange");
          a3 && o2.main.isConnected() && t(a3, { id: e4.id, copied: r3.copied });
          let n = xr(e4, "onStatusChangeClient");
          n && e4.dispatchEvent(new CustomEvent(n, { bubbles: true }));
        } }));
        i.init(), this.clipboard = i, this.onCopy = () => {
          i.api.copy();
        }, e4.addEventListener("phx:clipboard:copy", this.onCopy), this.onSetValue = (r3) => {
          let { value: a3 } = r3.detail;
          i.api.setValue(a3);
        }, e4.addEventListener("phx:clipboard:set-value", this.onSetValue), this.handlers = [], this.handlers.push(this.handleEvent("clipboard_copy", (r3) => {
          let a3 = r3.clipboard_id;
          a3 && a3 !== e4.id || i.api.copy();
        })), this.handlers.push(this.handleEvent("clipboard_set_value", (r3) => {
          let a3 = r3.clipboard_id;
          a3 && a3 !== e4.id || i.api.setValue(r3.value);
        })), this.handlers.push(this.handleEvent("clipboard_copied", () => {
          this.pushEvent("clipboard_copied_response", { value: i.api.copied });
        }));
      }, updated() {
        var _a2;
        (_a2 = this.clipboard) == null ? void 0 : _a2.updateProps(__spreadProps(__spreadValues({ id: this.el.id, timeout: Lr(this.el, "timeout") }, _r(this.el, "controlled") ? { value: xr(this.el, "value") } : { defaultValue: xr(this.el, "value") }), { dir: xr(this.el, "dir", ["ltr", "rtl"]) }));
      }, destroyed() {
        var _a2;
        if (this.onCopy && this.el.removeEventListener("phx:clipboard:copy", this.onCopy), this.onSetValue && this.el.removeEventListener("phx:clipboard:set-value", this.onSetValue), this.handlers) for (let e4 of this.handlers) this.removeHandleEvent(e4);
        (_a2 = this.clipboard) == null ? void 0 : _a2.destroy();
      } };
    }
  });

  // ../priv/static/collapsible.mjs
  var collapsible_exports = {};
  __export(collapsible_exports, {
    Collapsible: () => le3
  });
  function W5(e4, o2) {
    let { state: n, send: i, context: t, scope: a3, prop: l4 } = e4, r3 = n.matches("open") || n.matches("closing"), s = n.matches("open"), c5 = n.matches("closed"), { width: H12, height: B12 } = t.get("size"), h6 = !!l4("disabled"), f4 = l4("collapsedHeight"), b10 = l4("collapsedWidth"), I11 = f4 != null, P11 = b10 != null, x14 = I11 || P11, q15 = !t.get("initial") && s;
    return { disabled: h6, visible: r3, open: s, measureSize() {
      i({ type: "size.measure" });
    }, setOpen(v10) {
      n.matches("open") !== v10 && i({ type: v10 ? "open" : "close" });
    }, getRootProps() {
      return o2.element(__spreadProps(__spreadValues({}, E5.root.attrs), { "data-state": s ? "open" : "closed", dir: l4("dir"), id: F4(a3) }));
    }, getContentProps() {
      return o2.element(__spreadProps(__spreadValues({}, E5.content.attrs), { id: S7(a3), "data-collapsible": "", "data-state": q15 ? void 0 : s ? "open" : "closed", "data-disabled": jr(h6), "data-has-collapsed-size": jr(x14), hidden: !r3 && !x14, dir: l4("dir"), style: __spreadValues(__spreadValues({ "--height": is(B12), "--width": is(H12), "--collapsed-height": is(f4), "--collapsed-width": is(b10) }, c5 && I11 && { overflow: "hidden", minHeight: is(f4), maxHeight: is(f4) }), c5 && P11 && { overflow: "hidden", minWidth: is(b10), maxWidth: is(b10) }) }));
    }, getTriggerProps() {
      return o2.element(__spreadProps(__spreadValues({}, E5.trigger.attrs), { id: G5(a3), dir: l4("dir"), type: "button", "data-state": s ? "open" : "closed", "data-disabled": jr(h6), "aria-controls": S7(a3), "aria-expanded": r3 || false, onClick(v10) {
        v10.defaultPrevented || h6 || i({ type: s ? "close" : "open" });
      } }));
    }, getIndicatorProps() {
      return o2.element(__spreadProps(__spreadValues({}, E5.indicator.attrs), { dir: l4("dir"), "data-state": s ? "open" : "closed", "data-disabled": jr(h6) }));
    } };
  }
  var $3, E5, F4, S7, G5, u2, V5, J5, Z6, O4, le3;
  var init_collapsible = __esm({
    "../priv/static/collapsible.mjs"() {
      "use strict";
      init_chunk_IYURAQ6S();
      $3 = G("collapsible").parts("root", "trigger", "content", "indicator");
      E5 = $3.build();
      F4 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.root) != null ? _b : `collapsible:${e4.id}`;
      };
      S7 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.content) != null ? _b : `collapsible:${e4.id}:content`;
      };
      G5 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.trigger) != null ? _b : `collapsible:${e4.id}:trigger`;
      };
      u2 = (e4) => e4.getById(S7(e4));
      V5 = { initialState({ prop: e4 }) {
        return e4("open") || e4("defaultOpen") ? "open" : "closed";
      }, context({ bindable: e4 }) {
        return { size: e4(() => ({ defaultValue: { height: 0, width: 0 }, sync: true })), initial: e4(() => ({ defaultValue: false })) };
      }, refs() {
        return { cleanup: void 0, stylesRef: void 0 };
      }, watch({ track: e4, prop: o2, action: n }) {
        e4([() => o2("open")], () => {
          n(["setInitial", "computeSize", "toggleVisibility"]);
        });
      }, exit: ["cleanupNode"], states: { closed: { effects: ["trackTabbableElements"], on: { "controlled.open": { target: "open" }, open: [{ guard: "isOpenControlled", actions: ["invokeOnOpen"] }, { target: "open", actions: ["setInitial", "computeSize", "invokeOnOpen"] }] } }, closing: { effects: ["trackExitAnimation"], on: { "controlled.close": { target: "closed" }, "controlled.open": { target: "open" }, open: [{ guard: "isOpenControlled", actions: ["invokeOnOpen"] }, { target: "open", actions: ["setInitial", "invokeOnOpen"] }], close: [{ guard: "isOpenControlled", actions: ["invokeOnExitComplete"] }, { target: "closed", actions: ["setInitial", "computeSize", "invokeOnExitComplete"] }], "animation.end": { target: "closed", actions: ["invokeOnExitComplete", "clearInitial"] } } }, open: { effects: ["trackEnterAnimation"], on: { "controlled.close": { target: "closing" }, close: [{ guard: "isOpenControlled", actions: ["invokeOnClose"] }, { target: "closing", actions: ["setInitial", "computeSize", "invokeOnClose"] }], "size.measure": { actions: ["measureSize"] }, "animation.end": { actions: ["clearInitial"] } } } }, implementations: { guards: { isOpenControlled: ({ prop: e4 }) => e4("open") != null }, effects: { trackEnterAnimation: ({ send: e4, scope: o2 }) => {
        let n, i = nt(() => {
          let t = u2(o2);
          if (!t) return;
          let a3 = zr(t).animationName;
          if (!a3 || a3 === "none") {
            e4({ type: "animation.end" });
            return;
          }
          let r3 = (s) => {
            Je(s) === t && e4({ type: "animation.end" });
          };
          t.addEventListener("animationend", r3), n = () => {
            t.removeEventListener("animationend", r3);
          };
        });
        return () => {
          i(), n == null ? void 0 : n();
        };
      }, trackExitAnimation: ({ send: e4, scope: o2 }) => {
        let n, i = nt(() => {
          let t = u2(o2);
          if (!t) return;
          let a3 = zr(t).animationName;
          if (!a3 || a3 === "none") {
            e4({ type: "animation.end" });
            return;
          }
          let r3 = (c5) => {
            Je(c5) === t && e4({ type: "animation.end" });
          };
          t.addEventListener("animationend", r3);
          let s = No(t, { animationFillMode: "forwards" });
          n = () => {
            t.removeEventListener("animationend", r3), vn(() => s());
          };
        });
        return () => {
          i(), n == null ? void 0 : n();
        };
      }, trackTabbableElements: ({ scope: e4, prop: o2 }) => {
        if (!o2("collapsedHeight") && !o2("collapsedWidth")) return;
        let n = u2(e4);
        if (!n) return;
        let i = () => {
          let r3 = Pt(n).map((s) => Mo(s, "inert", ""));
          return () => {
            r3.forEach((s) => s());
          };
        }, t = i(), a3 = mo(n, { callback() {
          t(), t = i();
        } });
        return () => {
          t(), a3();
        };
      } }, actions: { setInitial: ({ context: e4, flush: o2 }) => {
        o2(() => {
          e4.set("initial", true);
        });
      }, clearInitial: ({ context: e4 }) => {
        e4.set("initial", false);
      }, cleanupNode: ({ refs: e4 }) => {
        e4.set("stylesRef", null);
      }, measureSize: ({ context: e4, scope: o2 }) => {
        let n = u2(o2);
        if (!n) return;
        let { height: i, width: t } = n.getBoundingClientRect();
        e4.set("size", { height: i, width: t });
      }, computeSize: ({ refs: e4, scope: o2, context: n }) => {
        var _a2;
        (_a2 = e4.get("cleanup")) == null ? void 0 : _a2();
        let i = nt(() => {
          let t = u2(o2);
          if (!t) return;
          let a3 = t.hidden;
          t.style.animationName = "none", t.style.animationDuration = "0s", t.hidden = false;
          let l4 = t.getBoundingClientRect();
          n.set("size", { height: l4.height, width: l4.width }), n.get("initial") && (t.style.animationName = "", t.style.animationDuration = ""), t.hidden = a3;
        });
        e4.set("cleanup", i);
      }, invokeOnOpen: ({ prop: e4 }) => {
        var _a2;
        (_a2 = e4("onOpenChange")) == null ? void 0 : _a2({ open: true });
      }, invokeOnClose: ({ prop: e4 }) => {
        var _a2;
        (_a2 = e4("onOpenChange")) == null ? void 0 : _a2({ open: false });
      }, invokeOnExitComplete: ({ prop: e4 }) => {
        var _a2;
        (_a2 = e4("onExitComplete")) == null ? void 0 : _a2();
      }, toggleVisibility: ({ prop: e4, send: o2 }) => {
        o2({ type: e4("open") ? "controlled.open" : "controlled.close" });
      } } } };
      J5 = As()(["dir", "disabled", "getRootNode", "id", "ids", "collapsedHeight", "collapsedWidth", "onExitComplete", "onOpenChange", "defaultOpen", "open"]);
      Z6 = as(J5);
      O4 = class extends ve {
        initMachine(o2) {
          return new Ls(V5, o2);
        }
        initApi() {
          return W5(this.machine.service, Cs);
        }
        render() {
          let o2 = this.el.querySelector('[data-scope="collapsible"][data-part="root"]');
          if (o2) {
            this.spreadProps(o2, this.api.getRootProps());
            let n = o2.querySelector('[data-scope="collapsible"][data-part="trigger"]');
            n && this.spreadProps(n, this.api.getTriggerProps());
            let i = o2.querySelector('[data-scope="collapsible"][data-part="content"]');
            i && this.spreadProps(i, this.api.getContentProps());
          }
        }
      };
      le3 = { mounted() {
        let e4 = this.el, o2 = this.pushEvent.bind(this), n = new O4(e4, __spreadProps(__spreadValues({ id: e4.id }, _r(e4, "controlled") ? { open: _r(e4, "open") } : { defaultOpen: _r(e4, "defaultOpen") }), { disabled: _r(e4, "disabled"), dir: xr(e4, "dir", ["ltr", "rtl"]), onOpenChange: (i) => {
          let t = xr(e4, "onOpenChange");
          t && this.liveSocket.main.isConnected() && o2(t, { id: e4.id, open: i.open });
          let a3 = xr(e4, "onOpenChangeClient");
          a3 && e4.dispatchEvent(new CustomEvent(a3, { bubbles: true, detail: { id: e4.id, open: i.open } }));
        } }));
        n.init(), this.collapsible = n, this.onSetOpen = (i) => {
          let { open: t } = i.detail;
          n.api.setOpen(t);
        }, e4.addEventListener("phx:collapsible:set-open", this.onSetOpen), this.handlers = [], this.handlers.push(this.handleEvent("collapsible_set_open", (i) => {
          let t = i.collapsible_id;
          t && t !== e4.id || n.api.setOpen(i.open);
        })), this.handlers.push(this.handleEvent("collapsible_open", () => {
          this.pushEvent("collapsible_open_response", { value: n.api.open });
        }));
      }, updated() {
        var _a2;
        (_a2 = this.collapsible) == null ? void 0 : _a2.updateProps(__spreadProps(__spreadValues({ id: this.el.id }, _r(this.el, "controlled") ? { open: _r(this.el, "open") } : { defaultOpen: _r(this.el, "defaultOpen") }), { disabled: _r(this.el, "disabled"), dir: xr(this.el, "dir", ["ltr", "rtl"]) }));
      }, destroyed() {
        var _a2;
        if (this.onSetOpen && this.el.removeEventListener("phx:collapsible:set-open", this.onSetOpen), this.handlers) for (let e4 of this.handlers) this.removeHandleEvent(e4);
        (_a2 = this.collapsible) == null ? void 0 : _a2.destroy();
      } };
    }
  });

  // ../priv/static/chunk-MMRG4CGO.mjs
  function y5(s, o2, ...t) {
    return [...s.slice(0, o2), ...t, ...s.slice(o2)];
  }
  function v5(s, o2, t) {
    o2 = [...o2].sort((i, n) => i - n);
    let e4 = o2.map((i) => s[i]);
    for (let i = o2.length - 1; i >= 0; i--) s = [...s.slice(0, o2[i]), ...s.slice(o2[i] + 1)];
    return t = Math.max(0, t - o2.filter((i) => i < t).length), [...s.slice(0, t), ...e4, ...s.slice(t)];
  }
  function ut3(s) {
    return Jn(s, "columnCount") && Jn(s, "getRows");
  }
  function O5(s, o2, t) {
    for (let e4 = 0; e4 < o2.length; e4++) s = t.getChildren(s, o2.slice(e4 + 1))[o2[e4]];
    return s;
  }
  function J6(s) {
    let o2 = W6(s), t = [], e4 = /* @__PURE__ */ new Set();
    for (let i of o2) {
      let n = i.join();
      e4.has(n) || (e4.add(n), t.push(i));
    }
    return t;
  }
  function P6(s, o2) {
    for (let t = 0; t < Math.min(s.length, o2.length); t++) {
      if (s[t] < o2[t]) return -1;
      if (s[t] > o2[t]) return 1;
    }
    return s.length - o2.length;
  }
  function W6(s) {
    return s.sort(P6);
  }
  function H7(s, o2) {
    let t;
    return g3(s, __spreadProps(__spreadValues({}, o2), { onEnter: (e4, i) => {
      if (o2.predicate(e4, i)) return t = e4, "stop";
    } })), t;
  }
  function Q6(s, o2) {
    let t = [];
    return g3(s, { onEnter: (e4, i) => {
      o2.predicate(e4, i) && t.push(e4);
    }, getChildren: o2.getChildren }), t;
  }
  function _3(s, o2) {
    let t;
    return g3(s, { onEnter: (e4, i) => {
      if (o2.predicate(e4, i)) return t = [...i], "stop";
    }, getChildren: o2.getChildren }), t;
  }
  function U4(s, o2) {
    let t = o2.initialResult;
    return g3(s, __spreadProps(__spreadValues({}, o2), { onEnter: (e4, i) => {
      t = o2.nextResult(t, e4, i);
    } })), t;
  }
  function X6(s, o2) {
    return U4(s, __spreadProps(__spreadValues({}, o2), { initialResult: [], nextResult: (t, e4, i) => (t.push(...o2.transform(e4, i)), t) }));
  }
  function Y6(s, o2) {
    let { predicate: t, create: e4, getChildren: i } = o2, n = (l4, h6) => {
      let u3 = i(l4, h6), c5 = [];
      u3.forEach((f4, C17) => {
        let z12 = [...h6, C17], M10 = n(f4, z12);
        M10 && c5.push(M10);
      });
      let a3 = h6.length === 0, d4 = t(l4, h6), p4 = c5.length > 0;
      return a3 || d4 || p4 ? e4(l4, c5, h6) : null;
    };
    return n(s, []) || e4(s, [], []);
  }
  function Z7(s, o2) {
    let t = [], e4 = 0, i = /* @__PURE__ */ new Map(), n = /* @__PURE__ */ new Map();
    return g3(s, { getChildren: o2.getChildren, onEnter: (l4, h6) => {
      i.has(l4) || i.set(l4, e4++);
      let u3 = o2.getChildren(l4, h6);
      u3.forEach((f4) => {
        n.has(f4) || n.set(f4, l4), i.has(f4) || i.set(f4, e4++);
      });
      let c5 = u3.length > 0 ? u3.map((f4) => i.get(f4)) : void 0, a3 = n.get(l4), d4 = a3 ? i.get(a3) : void 0, p4 = i.get(l4);
      t.push(__spreadProps(__spreadValues({}, l4), { _children: c5, _parent: d4, _index: p4 }));
    } }), t;
  }
  function $4(s, o2) {
    return { type: "insert", index: s, nodes: o2 };
  }
  function tt3(s) {
    return { type: "remove", indexes: s };
  }
  function S8() {
    return { type: "replace" };
  }
  function j5(s) {
    return [s.slice(0, -1), s[s.length - 1]];
  }
  function B3(s, o2, t = /* @__PURE__ */ new Map()) {
    var _a2;
    let [e4, i] = j5(s);
    for (let l4 = e4.length - 1; l4 >= 0; l4--) {
      let h6 = e4.slice(0, l4).join();
      switch ((_a2 = t.get(h6)) == null ? void 0 : _a2.type) {
        case "remove":
          continue;
      }
      t.set(h6, S8());
    }
    let n = t.get(e4.join());
    switch (n == null ? void 0 : n.type) {
      case "remove":
        t.set(e4.join(), { type: "removeThenInsert", removeIndexes: n.indexes, insertIndex: i, insertNodes: o2 });
        break;
      default:
        t.set(e4.join(), $4(i, o2));
    }
    return t;
  }
  function A4(s) {
    var _a2;
    let o2 = /* @__PURE__ */ new Map(), t = /* @__PURE__ */ new Map();
    for (let e4 of s) {
      let i = e4.slice(0, -1).join(), n = (_a2 = t.get(i)) != null ? _a2 : [];
      n.push(e4[e4.length - 1]), t.set(i, n.sort((l4, h6) => l4 - h6));
    }
    for (let e4 of s) for (let i = e4.length - 2; i >= 0; i--) {
      let n = e4.slice(0, i).join();
      o2.has(n) || o2.set(n, S8());
    }
    for (let [e4, i] of t) o2.set(e4, tt3(i));
    return o2;
  }
  function et3(s, o2) {
    let t = /* @__PURE__ */ new Map(), [e4, i] = j5(s);
    for (let n = e4.length - 1; n >= 0; n--) {
      let l4 = e4.slice(0, n).join();
      t.set(l4, S8());
    }
    return t.set(e4.join(), { type: "removeThenInsert", removeIndexes: [i], insertIndex: i, insertNodes: [o2] }), t;
  }
  function b3(s, o2, t) {
    return it3(s, __spreadProps(__spreadValues({}, t), { getChildren: (e4, i) => {
      var _a2;
      let n = i.join();
      switch ((_a2 = o2.get(n)) == null ? void 0 : _a2.type) {
        case "replace":
        case "remove":
        case "removeThenInsert":
        case "insert":
          return t.getChildren(e4, i);
        default:
          return [];
      }
    }, transform: (e4, i, n) => {
      let l4 = n.join(), h6 = o2.get(l4);
      switch (h6 == null ? void 0 : h6.type) {
        case "remove":
          return t.create(e4, i.filter((a3, d4) => !h6.indexes.includes(d4)), n);
        case "removeThenInsert":
          let u3 = i.filter((a3, d4) => !h6.removeIndexes.includes(d4)), c5 = h6.removeIndexes.reduce((a3, d4) => d4 < a3 ? a3 - 1 : a3, h6.insertIndex);
          return t.create(e4, D4(u3, c5, 0, ...h6.insertNodes), n);
        case "insert":
          return t.create(e4, D4(i, h6.index, 0, ...h6.nodes), n);
        case "replace":
          return t.create(e4, i, n);
        default:
          return e4;
      }
    } }));
  }
  function D4(s, o2, t, ...e4) {
    return [...s.slice(0, o2), ...e4, ...s.slice(o2 + t)];
  }
  function it3(s, o2) {
    let t = {};
    return g3(s, __spreadProps(__spreadValues({}, o2), { onLeave: (e4, i) => {
      var _a2, _b;
      let n = [0, ...i], l4 = n.join(), h6 = o2.transform(e4, (_a2 = t[l4]) != null ? _a2 : [], i), u3 = n.slice(0, -1).join(), c5 = (_b = t[u3]) != null ? _b : [];
      c5.push(h6), t[u3] = c5;
    } })), t[""][0];
  }
  function nt3(s, o2) {
    let { nodes: t, at: e4 } = o2;
    if (e4.length === 0) throw new Error("Can't insert nodes at the root");
    let i = B3(e4, t);
    return b3(s, i, o2);
  }
  function st3(s, o2) {
    if (o2.at.length === 0) return o2.node;
    let t = et3(o2.at, o2.node);
    return b3(s, t, o2);
  }
  function rt2(s, o2) {
    if (o2.indexPaths.length === 0) return s;
    for (let e4 of o2.indexPaths) if (e4.length === 0) throw new Error("Can't remove the root node");
    let t = A4(o2.indexPaths);
    return b3(s, t, o2);
  }
  function ot2(s, o2) {
    if (o2.indexPaths.length === 0) return s;
    for (let n of o2.indexPaths) if (n.length === 0) throw new Error("Can't move the root node");
    if (o2.to.length === 0) throw new Error("Can't move nodes to the root");
    let t = J6(o2.indexPaths), e4 = t.map((n) => O5(s, n, o2)), i = B3(o2.to, e4, A4(t));
    return b3(s, i, o2);
  }
  function g3(s, o2) {
    let { onEnter: t, onLeave: e4, getChildren: i } = o2, n = [], l4 = [{ node: s }], h6 = o2.reuseIndexPath ? () => n : () => n.slice();
    for (; l4.length > 0; ) {
      let u3 = l4[l4.length - 1];
      if (u3.state === void 0) {
        let a3 = t == null ? void 0 : t(u3.node, h6());
        if (a3 === "stop") return;
        u3.state = a3 === "skip" ? -1 : 0;
      }
      let c5 = u3.children || i(u3.node, h6());
      if (u3.children || (u3.children = c5), u3.state !== -1) {
        if (u3.state < c5.length) {
          let d4 = u3.state;
          n.push(d4), l4.push({ node: c5[d4] }), u3.state = d4 + 1;
          continue;
        }
        if ((e4 == null ? void 0 : e4(u3.node, h6())) === "stop") return;
      }
      n.pop(), l4.pop();
    }
  }
  var F5, K7, r2, V6, q5, G6, ht3, ct2, at2, x3;
  var init_chunk_MMRG4CGO = __esm({
    "../priv/static/chunk-MMRG4CGO.mjs"() {
      "use strict";
      init_chunk_IYURAQ6S();
      F5 = Object.defineProperty;
      K7 = (s, o2, t) => o2 in s ? F5(s, o2, { enumerable: true, configurable: true, writable: true, value: t }) : s[o2] = t;
      r2 = (s, o2, t) => K7(s, typeof o2 != "symbol" ? o2 + "" : o2, t);
      V6 = { itemToValue(s) {
        return typeof s == "string" ? s : Wo(s) && Jn(s, "value") ? s.value : "";
      }, itemToString(s) {
        return typeof s == "string" ? s : Wo(s) && Jn(s, "label") ? s.label : V6.itemToValue(s);
      }, isItemDisabled(s) {
        return Wo(s) && Jn(s, "disabled") ? !!s.disabled : false;
      } };
      q5 = class k6 {
        constructor(o2) {
          this.options = o2, r2(this, "items"), r2(this, "indexMap", null), r2(this, "copy", (t) => new k6(__spreadProps(__spreadValues({}, this.options), { items: t != null ? t : [...this.items] }))), r2(this, "isEqual", (t) => V(this.items, t.items)), r2(this, "setItems", (t) => this.copy(t)), r2(this, "getValues", (t = this.items) => {
            let e4 = [];
            for (let i of t) {
              let n = this.getItemValue(i);
              n != null && e4.push(n);
            }
            return e4;
          }), r2(this, "find", (t) => {
            if (t == null) return null;
            let e4 = this.indexOf(t);
            return e4 !== -1 ? this.at(e4) : null;
          }), r2(this, "findMany", (t) => {
            let e4 = [];
            for (let i of t) {
              let n = this.find(i);
              n != null && e4.push(n);
            }
            return e4;
          }), r2(this, "at", (t) => {
            var _a2;
            if (!this.options.groupBy && !this.options.groupSort) return (_a2 = this.items[t]) != null ? _a2 : null;
            let e4 = 0, i = this.group();
            for (let [, n] of i) for (let l4 of n) {
              if (e4 === t) return l4;
              e4++;
            }
            return null;
          }), r2(this, "sortFn", (t, e4) => {
            let i = this.indexOf(t), n = this.indexOf(e4);
            return (i != null ? i : 0) - (n != null ? n : 0);
          }), r2(this, "sort", (t) => [...t].sort(this.sortFn.bind(this))), r2(this, "getItemValue", (t) => {
            var _a2, _b, _c;
            return t == null ? null : (_c = (_b = (_a2 = this.options).itemToValue) == null ? void 0 : _b.call(_a2, t)) != null ? _c : V6.itemToValue(t);
          }), r2(this, "getItemDisabled", (t) => {
            var _a2, _b, _c;
            return t == null ? false : (_c = (_b = (_a2 = this.options).isItemDisabled) == null ? void 0 : _b.call(_a2, t)) != null ? _c : V6.isItemDisabled(t);
          }), r2(this, "stringifyItem", (t) => {
            var _a2, _b, _c;
            return t == null ? null : (_c = (_b = (_a2 = this.options).itemToString) == null ? void 0 : _b.call(_a2, t)) != null ? _c : V6.itemToString(t);
          }), r2(this, "stringify", (t) => t == null ? null : this.stringifyItem(this.find(t))), r2(this, "stringifyItems", (t, e4 = ", ") => {
            let i = [];
            for (let n of t) {
              let l4 = this.stringifyItem(n);
              l4 != null && i.push(l4);
            }
            return i.join(e4);
          }), r2(this, "stringifyMany", (t, e4) => this.stringifyItems(this.findMany(t), e4)), r2(this, "has", (t) => this.indexOf(t) !== -1), r2(this, "hasItem", (t) => t == null ? false : this.has(this.getItemValue(t))), r2(this, "group", () => {
            let { groupBy: t, groupSort: e4 } = this.options;
            if (!t) return [["", [...this.items]]];
            let i = /* @__PURE__ */ new Map();
            this.items.forEach((l4, h6) => {
              let u3 = t(l4, h6);
              i.has(u3) || i.set(u3, []), i.get(u3).push(l4);
            });
            let n = Array.from(i.entries());
            return e4 && n.sort(([l4], [h6]) => {
              if (typeof e4 == "function") return e4(l4, h6);
              if (Array.isArray(e4)) {
                let u3 = e4.indexOf(l4), c5 = e4.indexOf(h6);
                return u3 === -1 ? 1 : c5 === -1 ? -1 : u3 - c5;
              }
              return e4 === "asc" ? l4.localeCompare(h6) : e4 === "desc" ? h6.localeCompare(l4) : 0;
            }), n;
          }), r2(this, "getNextValue", (t, e4 = 1, i = false) => {
            let n = this.indexOf(t);
            if (n === -1) return null;
            for (n = i ? Math.min(n + e4, this.size - 1) : n + e4; n <= this.size && this.getItemDisabled(this.at(n)); ) n++;
            return this.getItemValue(this.at(n));
          }), r2(this, "getPreviousValue", (t, e4 = 1, i = false) => {
            let n = this.indexOf(t);
            if (n === -1) return null;
            for (n = i ? Math.max(n - e4, 0) : n - e4; n >= 0 && this.getItemDisabled(this.at(n)); ) n--;
            return this.getItemValue(this.at(n));
          }), r2(this, "indexOf", (t) => {
            var _a2;
            if (t == null) return -1;
            if (!this.options.groupBy && !this.options.groupSort) return this.items.findIndex((e4) => this.getItemValue(e4) === t);
            if (!this.indexMap) {
              this.indexMap = /* @__PURE__ */ new Map();
              let e4 = 0, i = this.group();
              for (let [, n] of i) for (let l4 of n) {
                let h6 = this.getItemValue(l4);
                h6 != null && this.indexMap.set(h6, e4), e4++;
              }
            }
            return (_a2 = this.indexMap.get(t)) != null ? _a2 : -1;
          }), r2(this, "getByText", (t, e4) => {
            let i = e4 != null ? this.indexOf(e4) : -1, n = t.length === 1;
            for (let l4 = 0; l4 < this.items.length; l4++) {
              let h6 = this.items[(i + l4 + 1) % this.items.length];
              if (!(n && this.getItemValue(h6) === e4) && !this.getItemDisabled(h6) && G6(this.stringifyItem(h6), t)) return h6;
            }
          }), r2(this, "search", (t, e4) => {
            let { state: i, currentValue: n, timeout: l4 = 350 } = e4, h6 = i.keysSoFar + t, c5 = h6.length > 1 && Array.from(h6).every((C17) => C17 === h6[0]) ? h6[0] : h6, a3 = this.getByText(c5, n), d4 = this.getItemValue(a3);
            function p4() {
              clearTimeout(i.timer), i.timer = -1;
            }
            function f4(C17) {
              i.keysSoFar = C17, p4(), C17 !== "" && (i.timer = +setTimeout(() => {
                f4(""), p4();
              }, l4));
            }
            return f4(h6), d4;
          }), r2(this, "update", (t, e4) => {
            let i = this.indexOf(t);
            return i === -1 ? this : this.copy([...this.items.slice(0, i), e4, ...this.items.slice(i + 1)]);
          }), r2(this, "upsert", (t, e4, i = "append") => {
            let n = this.indexOf(t);
            return n === -1 ? (i === "append" ? this.append : this.prepend)(e4) : this.copy([...this.items.slice(0, n), e4, ...this.items.slice(n + 1)]);
          }), r2(this, "insert", (t, ...e4) => this.copy(y5(this.items, t, ...e4))), r2(this, "insertBefore", (t, ...e4) => {
            let i = this.indexOf(t);
            if (i === -1) if (this.items.length === 0) i = 0;
            else return this;
            return this.copy(y5(this.items, i, ...e4));
          }), r2(this, "insertAfter", (t, ...e4) => {
            let i = this.indexOf(t);
            if (i === -1) if (this.items.length === 0) i = 0;
            else return this;
            return this.copy(y5(this.items, i + 1, ...e4));
          }), r2(this, "prepend", (...t) => this.copy(y5(this.items, 0, ...t))), r2(this, "append", (...t) => this.copy(y5(this.items, this.items.length, ...t))), r2(this, "filter", (t) => {
            let e4 = this.items.filter((i, n) => t(this.stringifyItem(i), n, i));
            return this.copy(e4);
          }), r2(this, "remove", (...t) => {
            let e4 = t.map((i) => typeof i == "string" ? i : this.getItemValue(i));
            return this.copy(this.items.filter((i) => {
              let n = this.getItemValue(i);
              return n == null ? false : !e4.includes(n);
            }));
          }), r2(this, "move", (t, e4) => {
            let i = this.indexOf(t);
            return i === -1 ? this : this.copy(v5(this.items, [i], e4));
          }), r2(this, "moveBefore", (t, ...e4) => {
            let i = this.items.findIndex((l4) => this.getItemValue(l4) === t);
            if (i === -1) return this;
            let n = e4.map((l4) => this.items.findIndex((h6) => this.getItemValue(h6) === l4)).sort((l4, h6) => l4 - h6);
            return this.copy(v5(this.items, n, i));
          }), r2(this, "moveAfter", (t, ...e4) => {
            let i = this.items.findIndex((l4) => this.getItemValue(l4) === t);
            if (i === -1) return this;
            let n = e4.map((l4) => this.items.findIndex((h6) => this.getItemValue(h6) === l4)).sort((l4, h6) => l4 - h6);
            return this.copy(v5(this.items, n, i + 1));
          }), r2(this, "reorder", (t, e4) => this.copy(v5(this.items, [t], e4))), r2(this, "compareValue", (t, e4) => {
            let i = this.indexOf(t), n = this.indexOf(e4);
            return i < n ? -1 : i > n ? 1 : 0;
          }), r2(this, "range", (t, e4) => {
            let i = [], n = t;
            for (; n != null; ) {
              if (this.find(n) && i.push(n), n === e4) return i;
              n = this.getNextValue(n);
            }
            return [];
          }), r2(this, "getValueRange", (t, e4) => t && e4 ? this.compareValue(t, e4) <= 0 ? this.range(t, e4) : this.range(e4, t) : []), r2(this, "toString", () => {
            let t = "";
            for (let e4 of this.items) {
              let i = this.getItemValue(e4), n = this.stringifyItem(e4), l4 = this.getItemDisabled(e4), h6 = [i, n, l4].filter(Boolean).join(":");
              t += h6 + ",";
            }
            return t;
          }), r2(this, "toJSON", () => ({ size: this.size, first: this.firstValue, last: this.lastValue })), this.items = [...o2.items];
        }
        get size() {
          return this.items.length;
        }
        get firstValue() {
          let o2 = 0;
          for (; this.getItemDisabled(this.at(o2)); ) o2++;
          return this.getItemValue(this.at(o2));
        }
        get lastValue() {
          let o2 = this.size - 1;
          for (; this.getItemDisabled(this.at(o2)); ) o2--;
          return this.getItemValue(this.at(o2));
        }
        *[Symbol.iterator]() {
          yield* __yieldStar(this.items);
        }
      };
      G6 = (s, o2) => !!(s == null ? void 0 : s.toLowerCase().startsWith(o2.toLowerCase()));
      ht3 = class extends q5 {
        constructor(s) {
          let { columnCount: o2 } = s;
          super(s), r2(this, "columnCount"), r2(this, "rows", null), r2(this, "getRows", () => (this.rows || (this.rows = Bo([...this.items], this.columnCount)), this.rows)), r2(this, "getRowCount", () => Math.ceil(this.items.length / this.columnCount)), r2(this, "getCellIndex", (t, e4) => t * this.columnCount + e4), r2(this, "getCell", (t, e4) => this.at(this.getCellIndex(t, e4))), r2(this, "getValueCell", (t) => {
            let e4 = this.indexOf(t);
            if (e4 === -1) return null;
            let i = Math.floor(e4 / this.columnCount), n = e4 % this.columnCount;
            return { row: i, column: n };
          }), r2(this, "getLastEnabledColumnIndex", (t) => {
            for (let e4 = this.columnCount - 1; e4 >= 0; e4--) {
              let i = this.getCell(t, e4);
              if (i && !this.getItemDisabled(i)) return e4;
            }
            return null;
          }), r2(this, "getFirstEnabledColumnIndex", (t) => {
            for (let e4 = 0; e4 < this.columnCount; e4++) {
              let i = this.getCell(t, e4);
              if (i && !this.getItemDisabled(i)) return e4;
            }
            return null;
          }), r2(this, "getPreviousRowValue", (t, e4 = false) => {
            let i = this.getValueCell(t);
            if (i === null) return null;
            let n = this.getRows(), l4 = n.length, h6 = i.row, u3 = i.column;
            for (let c5 = 1; c5 <= l4; c5++) {
              h6 = Yn(n, h6, { loop: e4 });
              let a3 = n[h6];
              if (!a3) continue;
              if (!a3[u3]) {
                let f4 = this.getLastEnabledColumnIndex(h6);
                f4 != null && (u3 = f4);
              }
              let p4 = this.getCell(h6, u3);
              if (!this.getItemDisabled(p4)) return this.getItemValue(p4);
            }
            return this.firstValue;
          }), r2(this, "getNextRowValue", (t, e4 = false) => {
            let i = this.getValueCell(t);
            if (i === null) return null;
            let n = this.getRows(), l4 = n.length, h6 = i.row, u3 = i.column;
            for (let c5 = 1; c5 <= l4; c5++) {
              h6 = Qt(n, h6, { loop: e4 });
              let a3 = n[h6];
              if (!a3) continue;
              if (!a3[u3]) {
                let f4 = this.getLastEnabledColumnIndex(h6);
                f4 != null && (u3 = f4);
              }
              let p4 = this.getCell(h6, u3);
              if (!this.getItemDisabled(p4)) return this.getItemValue(p4);
            }
            return this.lastValue;
          }), this.columnCount = o2;
        }
      };
      ct2 = class w5 extends Set {
        constructor(o2 = []) {
          super(o2), r2(this, "selectionMode", "single"), r2(this, "deselectable", true), r2(this, "copy", () => {
            let t = new w5([...this]);
            return this.sync(t);
          }), r2(this, "sync", (t) => (t.selectionMode = this.selectionMode, t.deselectable = this.deselectable, t)), r2(this, "isEmpty", () => this.size === 0), r2(this, "isSelected", (t) => this.selectionMode === "none" || t == null ? false : this.has(t)), r2(this, "canSelect", (t, e4) => this.selectionMode !== "none" || !t.getItemDisabled(t.find(e4))), r2(this, "firstSelectedValue", (t) => {
            let e4 = null;
            for (let i of this) (!e4 || t.compareValue(i, e4) < 0) && (e4 = i);
            return e4;
          }), r2(this, "lastSelectedValue", (t) => {
            let e4 = null;
            for (let i of this) (!e4 || t.compareValue(i, e4) > 0) && (e4 = i);
            return e4;
          }), r2(this, "extendSelection", (t, e4, i) => {
            if (this.selectionMode === "none") return this;
            if (this.selectionMode === "single") return this.replaceSelection(t, i);
            let n = this.copy(), l4 = Array.from(this).pop();
            for (let h6 of t.getValueRange(e4, l4 != null ? l4 : i)) n.delete(h6);
            for (let h6 of t.getValueRange(i, e4)) this.canSelect(t, h6) && n.add(h6);
            return n;
          }), r2(this, "toggleSelection", (t, e4) => {
            if (this.selectionMode === "none") return this;
            if (this.selectionMode === "single" && !this.isSelected(e4)) return this.replaceSelection(t, e4);
            let i = this.copy();
            return i.has(e4) ? i.delete(e4) : i.canSelect(t, e4) && i.add(e4), i;
          }), r2(this, "replaceSelection", (t, e4) => {
            if (this.selectionMode === "none") return this;
            if (e4 == null) return this;
            if (!this.canSelect(t, e4)) return this;
            let i = new w5([e4]);
            return this.sync(i);
          }), r2(this, "setSelection", (t) => {
            if (this.selectionMode === "none") return this;
            let e4 = new w5();
            for (let i of t) if (i != null && (e4.add(i), this.selectionMode === "single")) break;
            return this.sync(e4);
          }), r2(this, "clearSelection", () => {
            let t = this.copy();
            return t.deselectable && t.size > 0 && t.clear(), t;
          }), r2(this, "select", (t, e4, i) => this.selectionMode === "none" ? this : this.selectionMode === "single" ? this.isSelected(e4) && this.deselectable ? this.toggleSelection(t, e4) : this.replaceSelection(t, e4) : this.selectionMode === "multiple" || i ? this.toggleSelection(t, e4) : this.replaceSelection(t, e4)), r2(this, "deselect", (t) => {
            let e4 = this.copy();
            return e4.delete(t), e4;
          }), r2(this, "isEqual", (t) => V(Array.from(this), Array.from(t)));
        }
      };
      at2 = class L5 {
        constructor(o2) {
          this.options = o2, r2(this, "rootNode"), r2(this, "isEqual", (t) => V(this.rootNode, t.rootNode)), r2(this, "getNodeChildren", (t) => {
            var _a2, _b, _c, _d;
            return (_d = (_c = (_b = (_a2 = this.options).nodeToChildren) == null ? void 0 : _b.call(_a2, t)) != null ? _c : x3.nodeToChildren(t)) != null ? _d : [];
          }), r2(this, "resolveIndexPath", (t) => typeof t == "string" ? this.getIndexPath(t) : t), r2(this, "resolveNode", (t) => {
            let e4 = this.resolveIndexPath(t);
            return e4 ? this.at(e4) : void 0;
          }), r2(this, "getNodeChildrenCount", (t) => {
            var _a2, _b, _c;
            return (_c = (_b = (_a2 = this.options).nodeToChildrenCount) == null ? void 0 : _b.call(_a2, t)) != null ? _c : x3.nodeToChildrenCount(t);
          }), r2(this, "getNodeValue", (t) => {
            var _a2, _b, _c;
            return (_c = (_b = (_a2 = this.options).nodeToValue) == null ? void 0 : _b.call(_a2, t)) != null ? _c : x3.nodeToValue(t);
          }), r2(this, "getNodeDisabled", (t) => {
            var _a2, _b, _c;
            return (_c = (_b = (_a2 = this.options).isNodeDisabled) == null ? void 0 : _b.call(_a2, t)) != null ? _c : x3.isNodeDisabled(t);
          }), r2(this, "stringify", (t) => {
            let e4 = this.findNode(t);
            return e4 ? this.stringifyNode(e4) : null;
          }), r2(this, "stringifyNode", (t) => {
            var _a2, _b, _c;
            return (_c = (_b = (_a2 = this.options).nodeToString) == null ? void 0 : _b.call(_a2, t)) != null ? _c : x3.nodeToString(t);
          }), r2(this, "getFirstNode", (t = this.rootNode, e4 = {}) => {
            let i;
            return g3(t, { getChildren: this.getNodeChildren, onEnter: (n, l4) => {
              var _a2;
              if (!this.isSameNode(n, t)) {
                if ((_a2 = e4.skip) == null ? void 0 : _a2.call(e4, { value: this.getNodeValue(n), node: n, indexPath: l4 })) return "skip";
                if (!i && l4.length > 0 && !this.getNodeDisabled(n)) return i = n, "stop";
              }
            } }), i;
          }), r2(this, "getLastNode", (t = this.rootNode, e4 = {}) => {
            let i;
            return g3(t, { getChildren: this.getNodeChildren, onEnter: (n, l4) => {
              var _a2;
              if (!this.isSameNode(n, t)) {
                if ((_a2 = e4.skip) == null ? void 0 : _a2.call(e4, { value: this.getNodeValue(n), node: n, indexPath: l4 })) return "skip";
                l4.length > 0 && !this.getNodeDisabled(n) && (i = n);
              }
            } }), i;
          }), r2(this, "at", (t) => O5(this.rootNode, t, { getChildren: this.getNodeChildren })), r2(this, "findNode", (t, e4 = this.rootNode) => H7(e4, { getChildren: this.getNodeChildren, predicate: (i) => this.getNodeValue(i) === t })), r2(this, "findNodes", (t, e4 = this.rootNode) => {
            let i = new Set(t.filter((n) => n != null));
            return Q6(e4, { getChildren: this.getNodeChildren, predicate: (n) => i.has(this.getNodeValue(n)) });
          }), r2(this, "sort", (t) => t.reduce((e4, i) => {
            let n = this.getIndexPath(i);
            return n && e4.push({ value: i, indexPath: n }), e4;
          }, []).sort((e4, i) => P6(e4.indexPath, i.indexPath)).map(({ value: e4 }) => e4)), r2(this, "getIndexPath", (t) => _3(this.rootNode, { getChildren: this.getNodeChildren, predicate: (e4) => this.getNodeValue(e4) === t })), r2(this, "getValue", (t) => {
            let e4 = this.at(t);
            return e4 ? this.getNodeValue(e4) : void 0;
          }), r2(this, "getValuePath", (t) => {
            if (!t) return [];
            let e4 = [], i = [...t];
            for (; i.length > 0; ) {
              let n = this.at(i);
              n && e4.unshift(this.getNodeValue(n)), i.pop();
            }
            return e4;
          }), r2(this, "getDepth", (t) => {
            var _a2, _b;
            return (_b = (_a2 = _3(this.rootNode, { getChildren: this.getNodeChildren, predicate: (i) => this.getNodeValue(i) === t })) == null ? void 0 : _a2.length) != null ? _b : 0;
          }), r2(this, "isSameNode", (t, e4) => this.getNodeValue(t) === this.getNodeValue(e4)), r2(this, "isRootNode", (t) => this.isSameNode(t, this.rootNode)), r2(this, "contains", (t, e4) => !t || !e4 ? false : e4.slice(0, t.length).every((i, n) => t[n] === e4[n])), r2(this, "getNextNode", (t, e4 = {}) => {
            let i = false, n;
            return g3(this.rootNode, { getChildren: this.getNodeChildren, onEnter: (l4, h6) => {
              var _a2;
              if (this.isRootNode(l4)) return;
              let u3 = this.getNodeValue(l4);
              if ((_a2 = e4.skip) == null ? void 0 : _a2.call(e4, { value: u3, node: l4, indexPath: h6 })) return u3 === t && (i = true), "skip";
              if (i && !this.getNodeDisabled(l4)) return n = l4, "stop";
              u3 === t && (i = true);
            } }), n;
          }), r2(this, "getPreviousNode", (t, e4 = {}) => {
            let i, n = false;
            return g3(this.rootNode, { getChildren: this.getNodeChildren, onEnter: (l4, h6) => {
              var _a2;
              if (this.isRootNode(l4)) return;
              let u3 = this.getNodeValue(l4);
              if ((_a2 = e4.skip) == null ? void 0 : _a2.call(e4, { value: u3, node: l4, indexPath: h6 })) return "skip";
              if (u3 === t) return n = true, "stop";
              this.getNodeDisabled(l4) || (i = l4);
            } }), n ? i : void 0;
          }), r2(this, "getParentNodes", (t) => {
            var _a2;
            let e4 = (_a2 = this.resolveIndexPath(t)) == null ? void 0 : _a2.slice();
            if (!e4) return [];
            let i = [];
            for (; e4.length > 0; ) {
              e4.pop();
              let n = this.at(e4);
              n && !this.isRootNode(n) && i.unshift(n);
            }
            return i;
          }), r2(this, "getDescendantNodes", (t, e4) => {
            let i = this.resolveNode(t);
            if (!i) return [];
            let n = [];
            return g3(i, { getChildren: this.getNodeChildren, onEnter: (l4, h6) => {
              h6.length !== 0 && (!(e4 == null ? void 0 : e4.withBranch) && this.isBranchNode(l4) || n.push(l4));
            } }), n;
          }), r2(this, "getDescendantValues", (t, e4) => this.getDescendantNodes(t, e4).map((n) => this.getNodeValue(n))), r2(this, "getParentIndexPath", (t) => t.slice(0, -1)), r2(this, "getParentNode", (t) => {
            let e4 = this.resolveIndexPath(t);
            return e4 ? this.at(this.getParentIndexPath(e4)) : void 0;
          }), r2(this, "visit", (t) => {
            let _a2 = t, { skip: e4 } = _a2, i = __objRest(_a2, ["skip"]);
            g3(this.rootNode, __spreadProps(__spreadValues({}, i), { getChildren: this.getNodeChildren, onEnter: (n, l4) => {
              var _a3;
              if (!this.isRootNode(n)) return (e4 == null ? void 0 : e4({ value: this.getNodeValue(n), node: n, indexPath: l4 })) ? "skip" : (_a3 = i.onEnter) == null ? void 0 : _a3.call(i, n, l4);
            } }));
          }), r2(this, "getPreviousSibling", (t) => {
            let e4 = this.getParentNode(t);
            if (!e4) return;
            let i = this.getNodeChildren(e4), n = t[t.length - 1];
            for (; --n >= 0; ) {
              let l4 = i[n];
              if (!this.getNodeDisabled(l4)) return l4;
            }
          }), r2(this, "getNextSibling", (t) => {
            let e4 = this.getParentNode(t);
            if (!e4) return;
            let i = this.getNodeChildren(e4), n = t[t.length - 1];
            for (; ++n < i.length; ) {
              let l4 = i[n];
              if (!this.getNodeDisabled(l4)) return l4;
            }
          }), r2(this, "getSiblingNodes", (t) => {
            let e4 = this.getParentNode(t);
            return e4 ? this.getNodeChildren(e4) : [];
          }), r2(this, "getValues", (t = this.rootNode) => X6(t, { getChildren: this.getNodeChildren, transform: (i) => [this.getNodeValue(i)] }).slice(1)), r2(this, "isValidDepth", (t, e4) => e4 == null ? true : typeof e4 == "function" ? e4(t.length) : t.length === e4), r2(this, "isBranchNode", (t) => this.getNodeChildren(t).length > 0 || this.getNodeChildrenCount(t) != null), r2(this, "getBranchValues", (t = this.rootNode, e4 = {}) => {
            let i = [];
            return g3(t, { getChildren: this.getNodeChildren, onEnter: (n, l4) => {
              var _a2;
              if (l4.length === 0) return;
              let h6 = this.getNodeValue(n);
              if ((_a2 = e4.skip) == null ? void 0 : _a2.call(e4, { value: h6, node: n, indexPath: l4 })) return "skip";
              this.isBranchNode(n) && this.isValidDepth(l4, e4.depth) && i.push(this.getNodeValue(n));
            } }), i;
          }), r2(this, "flatten", (t = this.rootNode) => Z7(t, { getChildren: this.getNodeChildren })), r2(this, "_create", (t, e4) => this.getNodeChildren(t).length > 0 || e4.length > 0 ? __spreadProps(__spreadValues({}, t), { children: e4 }) : __spreadValues({}, t)), r2(this, "_insert", (t, e4, i) => this.copy(nt3(t, { at: e4, nodes: i, getChildren: this.getNodeChildren, create: this._create }))), r2(this, "copy", (t) => new L5(__spreadProps(__spreadValues({}, this.options), { rootNode: t }))), r2(this, "_replace", (t, e4, i) => this.copy(st3(t, { at: e4, node: i, getChildren: this.getNodeChildren, create: this._create }))), r2(this, "_move", (t, e4, i) => this.copy(ot2(t, { indexPaths: e4, to: i, getChildren: this.getNodeChildren, create: this._create }))), r2(this, "_remove", (t, e4) => this.copy(rt2(t, { indexPaths: e4, getChildren: this.getNodeChildren, create: this._create }))), r2(this, "replace", (t, e4) => this._replace(this.rootNode, t, e4)), r2(this, "remove", (t) => this._remove(this.rootNode, t)), r2(this, "insertBefore", (t, e4) => this.getParentNode(t) ? this._insert(this.rootNode, t, e4) : void 0), r2(this, "insertAfter", (t, e4) => {
            if (!this.getParentNode(t)) return;
            let n = [...t.slice(0, -1), t[t.length - 1] + 1];
            return this._insert(this.rootNode, n, e4);
          }), r2(this, "move", (t, e4) => this._move(this.rootNode, t, e4)), r2(this, "filter", (t) => {
            let e4 = Y6(this.rootNode, { predicate: t, getChildren: this.getNodeChildren, create: this._create });
            return this.copy(e4);
          }), r2(this, "toJSON", () => this.getValues(this.rootNode)), this.rootNode = o2.rootNode;
        }
      };
      x3 = { nodeToValue(s) {
        return typeof s == "string" ? s : Wo(s) && Jn(s, "value") ? s.value : "";
      }, nodeToString(s) {
        return typeof s == "string" ? s : Wo(s) && Jn(s, "label") ? s.label : x3.nodeToValue(s);
      }, isNodeDisabled(s) {
        return Wo(s) && Jn(s, "disabled") ? !!s.disabled : false;
      }, nodeToChildren(s) {
        return s.children;
      }, nodeToChildrenCount(s) {
        if (Wo(s) && Jn(s, "childrenCount")) return s.childrenCount;
      } };
    }
  });

  // ../priv/static/chunk-S6MRQC6S.mjs
  function ft3(t, e4, n) {
    return S9(t, F6(e4, n));
  }
  function N4(t, e4) {
    return typeof t == "function" ? t(e4) : t;
  }
  function V7(t) {
    return t.split("-")[0];
  }
  function K8(t) {
    return t.split("-")[1];
  }
  function ut4(t) {
    return t === "x" ? "y" : "x";
  }
  function dt2(t) {
    return t === "y" ? "height" : "width";
  }
  function B4(t) {
    return Oe2.has(V7(t)) ? "y" : "x";
  }
  function mt3(t) {
    return ut4(B4(t));
  }
  function $t2(t, e4, n) {
    n === void 0 && (n = false);
    let o2 = K8(t), i = mt3(t), r3 = dt2(i), s = i === "x" ? o2 === (n ? "end" : "start") ? "right" : "left" : o2 === "start" ? "bottom" : "top";
    return e4.reference[r3] > e4.floating[r3] && (s = ot3(s)), [s, ot3(s)];
  }
  function Bt3(t) {
    let e4 = ot3(t);
    return [at3(t), e4, at3(e4)];
  }
  function at3(t) {
    return t.replace(/start|end/g, (e4) => Ae2[e4]);
  }
  function Pe2(t, e4, n) {
    switch (t) {
      case "top":
      case "bottom":
        return n ? e4 ? Dt3 : Lt3 : e4 ? Lt3 : Dt3;
      case "left":
      case "right":
        return e4 ? Re2 : Se2;
      default:
        return [];
    }
  }
  function Wt2(t, e4, n, o2) {
    let i = K8(t), r3 = Pe2(V7(t), n === "start", o2);
    return i && (r3 = r3.map((s) => s + "-" + i), e4 && (r3 = r3.concat(r3.map(at3)))), r3;
  }
  function ot3(t) {
    return t.replace(/left|right|bottom|top/g, (e4) => be2[e4]);
  }
  function Ce2(t) {
    return __spreadValues({ top: 0, right: 0, bottom: 0, left: 0 }, t);
  }
  function yt3(t) {
    return typeof t != "number" ? Ce2(t) : { top: t, right: t, bottom: t, left: t };
  }
  function G7(t) {
    let { x: e4, y: n, width: o2, height: i } = t;
    return { width: o2, height: i, top: n, left: e4, right: e4 + o2, bottom: n + i, x: e4, y: n };
  }
  function Ht2(t, e4, n) {
    let { reference: o2, floating: i } = t, r3 = B4(e4), s = mt3(e4), c5 = dt2(s), l4 = V7(e4), f4 = r3 === "y", d4 = o2.x + o2.width / 2 - i.width / 2, u3 = o2.y + o2.height / 2 - i.height / 2, g7 = o2[c5] / 2 - i[c5] / 2, a3;
    switch (l4) {
      case "top":
        a3 = { x: d4, y: o2.y - i.height };
        break;
      case "bottom":
        a3 = { x: d4, y: o2.y + o2.height };
        break;
      case "right":
        a3 = { x: o2.x + o2.width, y: u3 };
        break;
      case "left":
        a3 = { x: o2.x - i.width, y: u3 };
        break;
      default:
        a3 = { x: o2.x, y: o2.y };
    }
    switch (K8(e4)) {
      case "start":
        a3[s] -= g7 * (n && f4 ? -1 : 1);
        break;
      case "end":
        a3[s] += g7 * (n && f4 ? -1 : 1);
        break;
    }
    return a3;
  }
  function Ft2(t, e4) {
    return __async(this, null, function* () {
      var n;
      e4 === void 0 && (e4 = {});
      let { x: o2, y: i, platform: r3, rects: s, elements: c5, strategy: l4 } = t, { boundary: f4 = "clippingAncestors", rootBoundary: d4 = "viewport", elementContext: u3 = "floating", altBoundary: g7 = false, padding: a3 = 0 } = N4(e4, t), m5 = yt3(a3), p4 = c5[g7 ? u3 === "floating" ? "reference" : "floating" : u3], w10 = G7(yield r3.getClippingRect({ element: (n = yield r3.isElement == null ? void 0 : r3.isElement(p4)) == null || n ? p4 : p4.contextElement || (yield r3.getDocumentElement == null ? void 0 : r3.getDocumentElement(c5.floating)), boundary: f4, rootBoundary: d4, strategy: l4 })), v10 = u3 === "floating" ? { x: o2, y: i, width: s.floating.width, height: s.floating.height } : s.reference, x14 = yield r3.getOffsetParent == null ? void 0 : r3.getOffsetParent(c5.floating), y11 = (yield r3.isElement == null ? void 0 : r3.isElement(x14)) ? (yield r3.getScale == null ? void 0 : r3.getScale(x14)) || { x: 1, y: 1 } : { x: 1, y: 1 }, b10 = G7(r3.convertOffsetParentRelativeRectToViewportRelativeRect ? yield r3.convertOffsetParentRelativeRectToViewportRelativeRect({ elements: c5, rect: v10, offsetParent: x14, strategy: l4 }) : v10);
      return { top: (w10.top - b10.top + m5.top) / y11.y, bottom: (b10.bottom - w10.bottom + m5.bottom) / y11.y, left: (w10.left - b10.left + m5.left) / y11.x, right: (b10.right - w10.right + m5.right) / y11.x };
    });
  }
  function kt3(t, e4) {
    return { top: t.top - e4.height, right: t.right - e4.width, bottom: t.bottom - e4.height, left: t.left - e4.width };
  }
  function zt2(t) {
    return Mt2.some((e4) => t[e4] >= 0);
  }
  function Te2(t, e4) {
    return __async(this, null, function* () {
      let { placement: n, platform: o2, elements: i } = t, r3 = yield o2.isRTL == null ? void 0 : o2.isRTL(i.floating), s = V7(n), c5 = K8(n), l4 = B4(n) === "y", f4 = Yt3.has(s) ? -1 : 1, d4 = r3 && l4 ? -1 : 1, u3 = N4(e4, t), { mainAxis: g7, crossAxis: a3, alignmentAxis: m5 } = typeof u3 == "number" ? { mainAxis: u3, crossAxis: 0, alignmentAxis: null } : { mainAxis: u3.mainAxis || 0, crossAxis: u3.crossAxis || 0, alignmentAxis: u3.alignmentAxis };
      return c5 && typeof m5 == "number" && (a3 = c5 === "end" ? m5 * -1 : m5), l4 ? { x: a3 * d4, y: g7 * f4 } : { x: g7 * f4, y: a3 * d4 };
    });
  }
  function gt2() {
    return typeof window < "u";
  }
  function J7(t) {
    return Gt3(t) ? (t.nodeName || "").toLowerCase() : "#document";
  }
  function P7(t) {
    var e4;
    return (t == null || (e4 = t.ownerDocument) == null ? void 0 : e4.defaultView) || window;
  }
  function W7(t) {
    var e4;
    return (e4 = (Gt3(t) ? t.ownerDocument : t.document) || window.document) == null ? void 0 : e4.documentElement;
  }
  function Gt3(t) {
    return gt2() ? t instanceof Node || t instanceof P7(t).Node : false;
  }
  function E6(t) {
    return gt2() ? t instanceof Element || t instanceof P7(t).Element : false;
  }
  function H8(t) {
    return gt2() ? t instanceof HTMLElement || t instanceof P7(t).HTMLElement : false;
  }
  function Kt2(t) {
    return !gt2() || typeof ShadowRoot > "u" ? false : t instanceof ShadowRoot || t instanceof P7(t).ShadowRoot;
  }
  function et4(t) {
    let { overflow: e4, overflowX: n, overflowY: o2, display: i } = L6(t);
    return /auto|scroll|overlay|hidden|clip/.test(e4 + o2 + n) && !Ee2.has(i);
  }
  function Jt3(t) {
    return Le2.has(J7(t));
  }
  function st4(t) {
    return De2.some((e4) => {
      try {
        return t.matches(e4);
      } catch (e5) {
        return false;
      }
    });
  }
  function ht4(t) {
    let e4 = pt3(), n = E6(t) ? L6(t) : t;
    return Me2.some((o2) => n[o2] ? n[o2] !== "none" : false) || (n.containerType ? n.containerType !== "normal" : false) || !e4 && (n.backdropFilter ? n.backdropFilter !== "none" : false) || !e4 && (n.filter ? n.filter !== "none" : false) || $e2.some((o2) => (n.willChange || "").includes(o2)) || Be2.some((o2) => (n.contain || "").includes(o2));
  }
  function Qt2(t) {
    let e4 = I7(t);
    for (; H8(e4) && !Q7(e4); ) {
      if (ht4(e4)) return e4;
      if (st4(e4)) return null;
      e4 = I7(e4);
    }
    return null;
  }
  function pt3() {
    return typeof CSS > "u" || !CSS.supports ? false : CSS.supports("-webkit-backdrop-filter", "none");
  }
  function Q7(t) {
    return We2.has(J7(t));
  }
  function L6(t) {
    return P7(t).getComputedStyle(t);
  }
  function ct3(t) {
    return E6(t) ? { scrollLeft: t.scrollLeft, scrollTop: t.scrollTop } : { scrollLeft: t.scrollX, scrollTop: t.scrollY };
  }
  function I7(t) {
    if (J7(t) === "html") return t;
    let e4 = t.assignedSlot || t.parentNode || Kt2(t) && t.host || W7(t);
    return Kt2(e4) ? e4.host : e4;
  }
  function Zt2(t) {
    let e4 = I7(t);
    return Q7(e4) ? t.ownerDocument ? t.ownerDocument.body : t.body : H8(e4) && et4(e4) ? e4 : Zt2(e4);
  }
  function tt4(t, e4, n) {
    var o2;
    e4 === void 0 && (e4 = []), n === void 0 && (n = true);
    let i = Zt2(t), r3 = i === ((o2 = t.ownerDocument) == null ? void 0 : o2.body), s = P7(i);
    if (r3) {
      let c5 = wt3(s);
      return e4.concat(s, s.visualViewport || [], et4(i) ? i : [], c5 && n ? tt4(c5) : []);
    }
    return e4.concat(i, tt4(i, [], n));
  }
  function wt3(t) {
    return t.parent && Object.getPrototypeOf(t.parent) ? t.frameElement : null;
  }
  function oe4(t) {
    let e4 = L6(t), n = parseFloat(e4.width) || 0, o2 = parseFloat(e4.height) || 0, i = H8(t), r3 = i ? t.offsetWidth : n, s = i ? t.offsetHeight : o2, c5 = it4(n) !== r3 || it4(o2) !== s;
    return c5 && (n = r3, o2 = s), { width: n, height: o2, $: c5 };
  }
  function bt3(t) {
    return E6(t) ? t : t.contextElement;
  }
  function nt4(t) {
    let e4 = bt3(t);
    if (!H8(e4)) return $5(1);
    let n = e4.getBoundingClientRect(), { width: o2, height: i, $: r3 } = oe4(e4), s = (r3 ? it4(n.width) : n.width) / o2, c5 = (r3 ? it4(n.height) : n.height) / i;
    return (!s || !Number.isFinite(s)) && (s = 1), (!c5 || !Number.isFinite(c5)) && (c5 = 1), { x: s, y: c5 };
  }
  function ie4(t) {
    let e4 = P7(t);
    return !pt3() || !e4.visualViewport ? He2 : { x: e4.visualViewport.offsetLeft, y: e4.visualViewport.offsetTop };
  }
  function ke3(t, e4, n) {
    return e4 === void 0 && (e4 = false), !n || e4 && n !== P7(t) ? false : e4;
  }
  function Z8(t, e4, n, o2) {
    e4 === void 0 && (e4 = false), n === void 0 && (n = false);
    let i = t.getBoundingClientRect(), r3 = bt3(t), s = $5(1);
    e4 && (o2 ? E6(o2) && (s = nt4(o2)) : s = nt4(t));
    let c5 = ke3(r3, n, o2) ? ie4(r3) : $5(0), l4 = (i.left + c5.x) / s.x, f4 = (i.top + c5.y) / s.y, d4 = i.width / s.x, u3 = i.height / s.y;
    if (r3) {
      let g7 = P7(r3), a3 = o2 && E6(o2) ? P7(o2) : o2, m5 = g7, h6 = wt3(m5);
      for (; h6 && o2 && a3 !== m5; ) {
        let p4 = nt4(h6), w10 = h6.getBoundingClientRect(), v10 = L6(h6), x14 = w10.left + (h6.clientLeft + parseFloat(v10.paddingLeft)) * p4.x, y11 = w10.top + (h6.clientTop + parseFloat(v10.paddingTop)) * p4.y;
        l4 *= p4.x, f4 *= p4.y, d4 *= p4.x, u3 *= p4.y, l4 += x14, f4 += y11, m5 = P7(h6), h6 = wt3(m5);
      }
    }
    return G7({ width: d4, height: u3, x: l4, y: f4 });
  }
  function xt3(t, e4) {
    let n = ct3(t).scrollLeft;
    return e4 ? e4.left + n : Z8(W7(t)).left + n;
  }
  function re2(t, e4) {
    let n = t.getBoundingClientRect(), o2 = n.left + e4.scrollLeft - xt3(t, n), i = n.top + e4.scrollTop;
    return { x: o2, y: i };
  }
  function ze2(t) {
    let { elements: e4, rect: n, offsetParent: o2, strategy: i } = t, r3 = i === "fixed", s = W7(o2), c5 = e4 ? st4(e4.floating) : false;
    if (o2 === s || c5 && r3) return n;
    let l4 = { scrollLeft: 0, scrollTop: 0 }, f4 = $5(1), d4 = $5(0), u3 = H8(o2);
    if ((u3 || !u3 && !r3) && ((J7(o2) !== "body" || et4(s)) && (l4 = ct3(o2)), H8(o2))) {
      let a3 = Z8(o2);
      f4 = nt4(o2), d4.x = a3.x + o2.clientLeft, d4.y = a3.y + o2.clientTop;
    }
    let g7 = s && !u3 && !r3 ? re2(s, l4) : $5(0);
    return { width: n.width * f4.x, height: n.height * f4.y, x: n.x * f4.x - l4.scrollLeft * f4.x + d4.x + g7.x, y: n.y * f4.y - l4.scrollTop * f4.y + d4.y + g7.y };
  }
  function Fe2(t) {
    return Array.from(t.getClientRects());
  }
  function Ne2(t) {
    let e4 = W7(t), n = ct3(t), o2 = t.ownerDocument.body, i = S9(e4.scrollWidth, e4.clientWidth, o2.scrollWidth, o2.clientWidth), r3 = S9(e4.scrollHeight, e4.clientHeight, o2.scrollHeight, o2.clientHeight), s = -n.scrollLeft + xt3(t), c5 = -n.scrollTop;
    return L6(o2).direction === "rtl" && (s += S9(e4.clientWidth, o2.clientWidth) - i), { width: i, height: r3, x: s, y: c5 };
  }
  function Ve3(t, e4) {
    let n = P7(t), o2 = W7(t), i = n.visualViewport, r3 = o2.clientWidth, s = o2.clientHeight, c5 = 0, l4 = 0;
    if (i) {
      r3 = i.width, s = i.height;
      let d4 = pt3();
      (!d4 || d4 && e4 === "fixed") && (c5 = i.offsetLeft, l4 = i.offsetTop);
    }
    let f4 = xt3(o2);
    if (f4 <= 0) {
      let d4 = o2.ownerDocument, u3 = d4.body, g7 = getComputedStyle(u3), a3 = d4.compatMode === "CSS1Compat" && parseFloat(g7.marginLeft) + parseFloat(g7.marginRight) || 0, m5 = Math.abs(o2.clientWidth - u3.clientWidth - a3);
      m5 <= te3 && (r3 -= m5);
    } else f4 <= te3 && (r3 += f4);
    return { width: r3, height: s, x: c5, y: l4 };
  }
  function Ie2(t, e4) {
    let n = Z8(t, true, e4 === "fixed"), o2 = n.top + t.clientTop, i = n.left + t.clientLeft, r3 = H8(t) ? nt4(t) : $5(1), s = t.clientWidth * r3.x, c5 = t.clientHeight * r3.y, l4 = i * r3.x, f4 = o2 * r3.y;
    return { width: s, height: c5, x: l4, y: f4 };
  }
  function ee3(t, e4, n) {
    let o2;
    if (e4 === "viewport") o2 = Ve3(t, n);
    else if (e4 === "document") o2 = Ne2(W7(t));
    else if (E6(e4)) o2 = Ie2(e4, n);
    else {
      let i = ie4(t);
      o2 = { x: e4.x - i.x, y: e4.y - i.y, width: e4.width, height: e4.height };
    }
    return G7(o2);
  }
  function se3(t, e4) {
    let n = I7(t);
    return n === e4 || !E6(n) || Q7(n) ? false : L6(n).position === "fixed" || se3(n, e4);
  }
  function Ye2(t, e4) {
    let n = e4.get(t);
    if (n) return n;
    let o2 = tt4(t, [], false).filter((c5) => E6(c5) && J7(c5) !== "body"), i = null, r3 = L6(t).position === "fixed", s = r3 ? I7(t) : t;
    for (; E6(s) && !Q7(s); ) {
      let c5 = L6(s), l4 = ht4(s);
      !l4 && c5.position === "fixed" && (i = null), (r3 ? !l4 && !i : !l4 && c5.position === "static" && !!i && _e2.has(i.position) || et4(s) && !l4 && se3(t, s)) ? o2 = o2.filter((d4) => d4 !== s) : i = c5, s = I7(s);
    }
    return e4.set(t, o2), o2;
  }
  function je2(t) {
    let { element: e4, boundary: n, rootBoundary: o2, strategy: i } = t, s = [...n === "clippingAncestors" ? st4(e4) ? [] : Ye2(e4, this._c) : [].concat(n), o2], c5 = s[0], l4 = s.reduce((f4, d4) => {
      let u3 = ee3(e4, d4, i);
      return f4.top = S9(u3.top, f4.top), f4.right = F6(u3.right, f4.right), f4.bottom = F6(u3.bottom, f4.bottom), f4.left = S9(u3.left, f4.left), f4;
    }, ee3(e4, c5, i));
    return { width: l4.right - l4.left, height: l4.bottom - l4.top, x: l4.left, y: l4.top };
  }
  function Xe2(t) {
    let { width: e4, height: n } = oe4(t);
    return { width: e4, height: n };
  }
  function Ue2(t, e4, n) {
    let o2 = H8(e4), i = W7(e4), r3 = n === "fixed", s = Z8(t, true, r3, e4), c5 = { scrollLeft: 0, scrollTop: 0 }, l4 = $5(0);
    function f4() {
      l4.x = xt3(i);
    }
    if (o2 || !o2 && !r3) if ((J7(e4) !== "body" || et4(i)) && (c5 = ct3(e4)), o2) {
      let a3 = Z8(e4, true, r3, e4);
      l4.x = a3.x + e4.clientLeft, l4.y = a3.y + e4.clientTop;
    } else i && f4();
    r3 && !o2 && i && f4();
    let d4 = i && !o2 && !r3 ? re2(i, c5) : $5(0), u3 = s.left + c5.scrollLeft - l4.x - d4.x, g7 = s.top + c5.scrollTop - l4.y - d4.y;
    return { x: u3, y: g7, width: s.width, height: s.height };
  }
  function vt3(t) {
    return L6(t).position === "static";
  }
  function ne4(t, e4) {
    if (!H8(t) || L6(t).position === "fixed") return null;
    if (e4) return e4(t);
    let n = t.offsetParent;
    return W7(t) === n && (n = n.ownerDocument.body), n;
  }
  function ce3(t, e4) {
    let n = P7(t);
    if (st4(t)) return n;
    if (!H8(t)) {
      let i = I7(t);
      for (; i && !Q7(i); ) {
        if (E6(i) && !vt3(i)) return i;
        i = I7(i);
      }
      return n;
    }
    let o2 = ne4(t, e4);
    for (; o2 && Jt3(o2) && vt3(o2); ) o2 = ne4(o2, e4);
    return o2 && Q7(o2) && vt3(o2) && !ht4(o2) ? n : o2 || Qt2(t) || n;
  }
  function Ke2(t) {
    return L6(t).direction === "rtl";
  }
  function le4(t, e4) {
    return t.x === e4.x && t.y === e4.y && t.width === e4.width && t.height === e4.height;
  }
  function Je2(t, e4) {
    let n = null, o2, i = W7(t);
    function r3() {
      var c5;
      clearTimeout(o2), (c5 = n) == null || c5.disconnect(), n = null;
    }
    function s(c5, l4) {
      c5 === void 0 && (c5 = false), l4 === void 0 && (l4 = 1), r3();
      let f4 = t.getBoundingClientRect(), { left: d4, top: u3, width: g7, height: a3 } = f4;
      if (c5 || e4(), !g7 || !a3) return;
      let m5 = rt3(u3), h6 = rt3(i.clientWidth - (d4 + g7)), p4 = rt3(i.clientHeight - (u3 + a3)), w10 = rt3(d4), x14 = { rootMargin: -m5 + "px " + -h6 + "px " + -p4 + "px " + -w10 + "px", threshold: S9(0, F6(1, l4)) || 1 }, y11 = true;
      function b10(A12) {
        let O10 = A12[0].intersectionRatio;
        if (O10 !== l4) {
          if (!y11) return s();
          O10 ? s(false, O10) : o2 = setTimeout(() => {
            s(false, 1e-7);
          }, 1e3);
        }
        O10 === 1 && !le4(f4, t.getBoundingClientRect()) && s(), y11 = false;
      }
      try {
        n = new IntersectionObserver(b10, __spreadProps(__spreadValues({}, x14), { root: i.ownerDocument }));
      } catch (e5) {
        n = new IntersectionObserver(b10, x14);
      }
      n.observe(t);
    }
    return s(true), r3;
  }
  function ae3(t, e4, n, o2) {
    o2 === void 0 && (o2 = {});
    let { ancestorScroll: i = true, ancestorResize: r3 = true, elementResize: s = typeof ResizeObserver == "function", layoutShift: c5 = typeof IntersectionObserver == "function", animationFrame: l4 = false } = o2, f4 = bt3(t), d4 = i || r3 ? [...f4 ? tt4(f4) : [], ...tt4(e4)] : [];
    d4.forEach((w10) => {
      i && w10.addEventListener("scroll", n, { passive: true }), r3 && w10.addEventListener("resize", n);
    });
    let u3 = f4 && c5 ? Je2(f4, n) : null, g7 = -1, a3 = null;
    s && (a3 = new ResizeObserver((w10) => {
      let [v10] = w10;
      v10 && v10.target === f4 && a3 && (a3.unobserve(e4), cancelAnimationFrame(g7), g7 = requestAnimationFrame(() => {
        var x14;
        (x14 = a3) == null || x14.observe(e4);
      })), n();
    }), f4 && !l4 && a3.observe(f4), a3.observe(e4));
    let m5, h6 = l4 ? Z8(t) : null;
    l4 && p4();
    function p4() {
      let w10 = Z8(t);
      h6 && !le4(h6, w10) && n(), h6 = w10, m5 = requestAnimationFrame(p4);
    }
    return n(), () => {
      var w10;
      d4.forEach((v10) => {
        i && v10.removeEventListener("scroll", n), r3 && v10.removeEventListener("resize", n);
      }), u3 == null ? void 0 : u3(), (w10 = a3) == null || w10.disconnect(), a3 = null, l4 && cancelAnimationFrame(m5);
    };
  }
  function xe2(t = 0, e4 = 0, n = 0, o2 = 0) {
    if (typeof DOMRect == "function") return new DOMRect(t, e4, n, o2);
    let i = { x: t, y: e4, width: n, height: o2, top: e4, right: t + n, bottom: e4 + o2, left: t };
    return __spreadProps(__spreadValues({}, i), { toJSON: () => i });
  }
  function Qe2(t) {
    if (!t) return xe2();
    let { x: e4, y: n, width: o2, height: i } = t;
    return xe2(e4, n, o2, i);
  }
  function Ze2(t, e4) {
    return { contextElement: S(t) ? t : t == null ? void 0 : t.contextElement, getBoundingClientRect: () => {
      let n = t, o2 = e4 == null ? void 0 : e4(n);
      return o2 || !n ? Qe2(o2) : n.getBoundingClientRect();
    } };
  }
  function en2(t, e4) {
    return { name: "transformOrigin", fn(n) {
      var _a2, _b, _c, _d, _e9;
      let { elements: o2, middlewareData: i, placement: r3, rects: s, y: c5 } = n, l4 = r3.split("-")[0], f4 = tn2(l4), d4 = ((_a2 = i.arrow) == null ? void 0 : _a2.x) || 0, u3 = ((_b = i.arrow) == null ? void 0 : _b.y) || 0, g7 = (e4 == null ? void 0 : e4.clientWidth) || 0, a3 = (e4 == null ? void 0 : e4.clientHeight) || 0, m5 = d4 + g7 / 2, h6 = u3 + a3 / 2, p4 = Math.abs(((_c = i.shift) == null ? void 0 : _c.y) || 0), w10 = s.reference.height / 2, v10 = a3 / 2, x14 = (_e9 = (_d = t.offset) == null ? void 0 : _d.mainAxis) != null ? _e9 : t.gutter, y11 = typeof x14 == "number" ? x14 + v10 : x14 != null ? x14 : v10, b10 = p4 > y11, A12 = { top: `${m5}px calc(100% + ${y11}px)`, bottom: `${m5}px ${-y11}px`, left: `calc(100% + ${y11}px) ${h6}px`, right: `${-y11}px ${h6}px` }[l4], O10 = `${m5}px ${s.reference.y + w10 - c5}px`, C17 = !!t.overlap && f4 === "y" && b10;
      return o2.floating.style.setProperty(Y7.transformOrigin.variable, C17 ? O10 : A12), { data: { transformOrigin: C17 ? O10 : A12 } };
    } };
  }
  function rn2(t) {
    let [e4, n] = t.split("-");
    return { side: e4, align: n, hasAlign: n != null };
  }
  function Dn2(t) {
    return t.split("-")[0];
  }
  function ye2(t, e4) {
    let n = t.devicePixelRatio || 1;
    return Math.round(e4 * n) / n;
  }
  function At3(t) {
    return typeof t == "function" ? t() : t === "clipping-ancestors" ? "clippingAncestors" : t;
  }
  function cn2(t, e4, n) {
    let o2 = t || e4.createElement("div");
    return he2({ element: o2, padding: n.arrowPadding });
  }
  function ln2(t, e4) {
    var _a2;
    if (!qo((_a2 = e4.offset) != null ? _a2 : e4.gutter)) return fe3(({ placement: n }) => {
      var _a3, _b, _c, _d;
      let o2 = ((t == null ? void 0 : t.clientHeight) || 0) / 2, i = (_b = (_a3 = e4.offset) == null ? void 0 : _a3.mainAxis) != null ? _b : e4.gutter, r3 = typeof i == "number" ? i + o2 : i != null ? i : o2, { hasAlign: s } = rn2(n), c5 = s ? void 0 : e4.shift, l4 = (_d = (_c = e4.offset) == null ? void 0 : _c.crossAxis) != null ? _d : c5;
      return Rt({ crossAxis: l4, mainAxis: r3, alignmentAxis: e4.shift });
    });
  }
  function an2(t) {
    if (!t.flip) return;
    let e4 = At3(t.boundary);
    return de3(__spreadProps(__spreadValues({}, e4 ? { boundary: e4 } : void 0), { padding: t.overflowPadding, fallbackPlacements: t.flip === true ? void 0 : t.flip }));
  }
  function fn2(t) {
    if (!t.slide && !t.overlap) return;
    let e4 = At3(t.boundary);
    return ue3(__spreadProps(__spreadValues({}, e4 ? { boundary: e4 } : void 0), { mainAxis: t.slide, crossAxis: t.overlap, padding: t.overflowPadding, limiter: pe4() }));
  }
  function un2(t) {
    return me2({ padding: t.overflowPadding, apply({ elements: e4, rects: n, availableHeight: o2, availableWidth: i }) {
      let r3 = e4.floating, s = Math.round(n.reference.width), c5 = Math.round(n.reference.height);
      i = Math.floor(i), o2 = Math.floor(o2), r3.style.setProperty("--reference-width", `${s}px`), r3.style.setProperty("--reference-height", `${c5}px`), r3.style.setProperty("--available-width", `${i}px`), r3.style.setProperty("--available-height", `${o2}px`);
    } });
  }
  function dn2(t) {
    var _a2;
    if (t.hideWhenDetached) return ge3({ strategy: "referenceHidden", boundary: (_a2 = At3(t.boundary)) != null ? _a2 : "clippingAncestors" });
  }
  function mn2(t) {
    return t ? t === true ? { ancestorResize: true, ancestorScroll: true, elementResize: true, layoutShift: true } : t : {};
  }
  function gn2(t, e4, n = {}) {
    var _a2, _b;
    let o2 = (_b = (_a2 = n.getAnchorElement) == null ? void 0 : _a2.call(n)) != null ? _b : t, i = Ze2(o2, n.getAnchorRect);
    if (!e4 || !i) return;
    let r3 = Object.assign({}, sn2, n), s = e4.querySelector("[data-part=arrow]"), c5 = [ln2(s, r3), an2(r3), fn2(r3), cn2(s, e4.ownerDocument, r3), on2(s), en2({ gutter: r3.gutter, offset: r3.offset, overlap: r3.overlap }, s), un2(r3), dn2(r3), nn2], { placement: l4, strategy: f4, onComplete: d4, onPositioned: u3 } = r3, g7 = () => __async(null, null, function* () {
      var _a3;
      if (!i || !e4) return;
      let p4 = yield we2(i, e4, { placement: l4, middleware: c5, strategy: f4 });
      d4 == null ? void 0 : d4(p4), u3 == null ? void 0 : u3({ placed: true });
      let w10 = T(e4), v10 = ye2(w10, p4.x), x14 = ye2(w10, p4.y);
      e4.style.setProperty("--x", `${v10}px`), e4.style.setProperty("--y", `${x14}px`), r3.hideWhenDetached && (((_a3 = p4.middlewareData.hide) == null ? void 0 : _a3.referenceHidden) ? (e4.style.setProperty("visibility", "hidden"), e4.style.setProperty("pointer-events", "none")) : (e4.style.removeProperty("visibility"), e4.style.removeProperty("pointer-events")));
      let y11 = e4.firstElementChild;
      if (y11) {
        let b10 = zr(y11);
        e4.style.setProperty("--z-index", b10.zIndex);
      }
    }), a3 = () => __async(null, null, function* () {
      n.updatePosition ? (yield n.updatePosition({ updatePosition: g7, floatingElement: e4 }), u3 == null ? void 0 : u3({ placed: true })) : yield g7();
    }), m5 = mn2(r3.listeners), h6 = r3.listeners ? ae3(i, e4, a3, m5) : Uo;
    return a3(), () => {
      h6 == null ? void 0 : h6(), u3 == null ? void 0 : u3({ placed: false });
    };
  }
  function Mn2(t, e4, n = {}) {
    let _a2 = n, { defer: o2 } = _a2, i = __objRest(_a2, ["defer"]), r3 = o2 ? nt : (c5) => c5(), s = [];
    return s.push(r3(() => {
      let c5 = typeof t == "function" ? t() : t, l4 = typeof e4 == "function" ? e4() : e4;
      s.push(gn2(c5, l4, i));
    })), () => {
      s.forEach((c5) => c5 == null ? void 0 : c5());
    };
  }
  function $n2(t = {}) {
    let { placement: e4, sameWidth: n, fitViewport: o2, strategy: i = "absolute" } = t;
    return { arrow: { position: "absolute", width: Y7.arrowSize.reference, height: Y7.arrowSize.reference, [Y7.arrowSizeHalf.variable]: `calc(${Y7.arrowSize.reference} / 2)`, [Y7.arrowOffset.variable]: `calc(${Y7.arrowSizeHalf.reference} * -1)` }, arrowTip: { transform: e4 ? hn2[e4.split("-")[0]] : void 0, background: Y7.arrowBg.reference, top: "0", left: "0", width: "100%", height: "100%", position: "absolute", zIndex: "inherit" }, floating: { position: i, isolation: "isolate", minWidth: n ? void 0 : "max-content", width: n ? "var(--reference-width)" : void 0, maxWidth: o2 ? "var(--available-width)" : void 0, maxHeight: o2 ? "var(--available-height)" : void 0, pointerEvents: e4 ? void 0 : "none", top: "0px", left: "0px", transform: e4 ? "translate3d(var(--x), var(--y), 0)" : "translate3d(0, -100vh, 0)", zIndex: "var(--z-index)" } };
  }
  var Mt2, F6, S9, it4, rt3, $5, be2, Ae2, Oe2, Lt3, Dt3, Re2, Se2, Nt2, Vt2, _t, It3, Yt3, jt2, Xt3, Ut2, qt2, Ee2, Le2, De2, Me2, $e2, Be2, We2, He2, te3, _e2, qe2, Ge2, fe3, ue3, de3, me2, ge3, he2, pe4, we2, lt2, Y7, tn2, nn2, on2, sn2, hn2;
  var init_chunk_S6MRQC6S = __esm({
    "../priv/static/chunk-S6MRQC6S.mjs"() {
      "use strict";
      init_chunk_IYURAQ6S();
      Mt2 = ["top", "right", "bottom", "left"];
      F6 = Math.min;
      S9 = Math.max;
      it4 = Math.round;
      rt3 = Math.floor;
      $5 = (t) => ({ x: t, y: t });
      be2 = { left: "right", right: "left", bottom: "top", top: "bottom" };
      Ae2 = { start: "end", end: "start" };
      Oe2 = /* @__PURE__ */ new Set(["top", "bottom"]);
      Lt3 = ["left", "right"];
      Dt3 = ["right", "left"];
      Re2 = ["top", "bottom"];
      Se2 = ["bottom", "top"];
      Nt2 = (t, e4, n) => __async(null, null, function* () {
        let { placement: o2 = "bottom", strategy: i = "absolute", middleware: r3 = [], platform: s } = n, c5 = r3.filter(Boolean), l4 = yield s.isRTL == null ? void 0 : s.isRTL(e4), f4 = yield s.getElementRects({ reference: t, floating: e4, strategy: i }), { x: d4, y: u3 } = Ht2(f4, o2, l4), g7 = o2, a3 = {}, m5 = 0;
        for (let p4 = 0; p4 < c5.length; p4++) {
          var h6;
          let { name: w10, fn: v10 } = c5[p4], { x: x14, y: y11, data: b10, reset: A12 } = yield v10({ x: d4, y: u3, initialPlacement: o2, placement: g7, strategy: i, middlewareData: a3, rects: f4, platform: __spreadProps(__spreadValues({}, s), { detectOverflow: (h6 = s.detectOverflow) != null ? h6 : Ft2 }), elements: { reference: t, floating: e4 } });
          d4 = x14 != null ? x14 : d4, u3 = y11 != null ? y11 : u3, a3 = __spreadProps(__spreadValues({}, a3), { [w10]: __spreadValues(__spreadValues({}, a3[w10]), b10) }), A12 && m5 <= 50 && (m5++, typeof A12 == "object" && (A12.placement && (g7 = A12.placement), A12.rects && (f4 = A12.rects === true ? yield s.getElementRects({ reference: t, floating: e4, strategy: i }) : A12.rects), { x: d4, y: u3 } = Ht2(f4, g7, l4)), p4 = -1);
        }
        return { x: d4, y: u3, placement: g7, strategy: i, middlewareData: a3 };
      });
      Vt2 = (t) => ({ name: "arrow", options: t, fn(e4) {
        return __async(this, null, function* () {
          let { x: n, y: o2, placement: i, rects: r3, platform: s, elements: c5, middlewareData: l4 } = e4, { element: f4, padding: d4 = 0 } = N4(t, e4) || {};
          if (f4 == null) return {};
          let u3 = yt3(d4), g7 = { x: n, y: o2 }, a3 = mt3(i), m5 = dt2(a3), h6 = yield s.getDimensions(f4), p4 = a3 === "y", w10 = p4 ? "top" : "left", v10 = p4 ? "bottom" : "right", x14 = p4 ? "clientHeight" : "clientWidth", y11 = r3.reference[m5] + r3.reference[a3] - g7[a3] - r3.floating[m5], b10 = g7[a3] - r3.reference[a3], A12 = yield s.getOffsetParent == null ? void 0 : s.getOffsetParent(f4), O10 = A12 ? A12[x14] : 0;
          (!O10 || !(yield s.isElement == null ? void 0 : s.isElement(A12))) && (O10 = c5.floating[x14] || r3.floating[m5]);
          let C17 = y11 / 2 - b10 / 2, k14 = O10 / 2 - h6[m5] / 2 - 1, T7 = F6(u3[w10], k14), j12 = F6(u3[v10], k14), z12 = T7, X16 = O10 - h6[m5] - j12, R7 = O10 / 2 - h6[m5] / 2 + C17, q15 = ft3(z12, R7, X16), _12 = !l4.arrow && K8(i) != null && R7 !== q15 && r3.reference[m5] / 2 - (R7 < z12 ? T7 : j12) - h6[m5] / 2 < 0, D11 = _12 ? R7 < z12 ? R7 - z12 : R7 - X16 : 0;
          return { [a3]: g7[a3] + D11, data: __spreadValues({ [a3]: q15, centerOffset: R7 - q15 - D11 }, _12 && { alignmentOffset: D11 }), reset: _12 };
        });
      } });
      _t = function(t) {
        return t === void 0 && (t = {}), { name: "flip", options: t, fn(e4) {
          return __async(this, null, function* () {
            var n, o2;
            let { placement: i, middlewareData: r3, rects: s, initialPlacement: c5, platform: l4, elements: f4 } = e4, _a3 = N4(t, e4), { mainAxis: d4 = true, crossAxis: u3 = true, fallbackPlacements: g7, fallbackStrategy: a3 = "bestFit", fallbackAxisSideDirection: m5 = "none", flipAlignment: h6 = true } = _a3, p4 = __objRest(_a3, ["mainAxis", "crossAxis", "fallbackPlacements", "fallbackStrategy", "fallbackAxisSideDirection", "flipAlignment"]);
            if ((n = r3.arrow) != null && n.alignmentOffset) return {};
            let w10 = V7(i), v10 = B4(c5), x14 = V7(c5) === c5, y11 = yield l4.isRTL == null ? void 0 : l4.isRTL(f4.floating), b10 = g7 || (x14 || !h6 ? [ot3(c5)] : Bt3(c5)), A12 = m5 !== "none";
            !g7 && A12 && b10.push(...Wt2(c5, h6, m5, y11));
            let O10 = [c5, ...b10], C17 = yield l4.detectOverflow(e4, p4), k14 = [], T7 = ((o2 = r3.flip) == null ? void 0 : o2.overflows) || [];
            if (d4 && k14.push(C17[w10]), u3) {
              let R7 = $t2(i, s, y11);
              k14.push(C17[R7[0]], C17[R7[1]]);
            }
            if (T7 = [...T7, { placement: i, overflows: k14 }], !k14.every((R7) => R7 <= 0)) {
              var j12, z12;
              let R7 = (((j12 = r3.flip) == null ? void 0 : j12.index) || 0) + 1, q15 = O10[R7];
              if (q15 && (!(u3 === "alignment" ? v10 !== B4(q15) : false) || T7.every((M10) => B4(M10.placement) === v10 ? M10.overflows[0] > 0 : true))) return { data: { index: R7, overflows: T7 }, reset: { placement: q15 } };
              let _12 = (z12 = T7.filter((D11) => D11.overflows[0] <= 0).sort((D11, M10) => D11.overflows[1] - M10.overflows[1])[0]) == null ? void 0 : z12.placement;
              if (!_12) switch (a3) {
                case "bestFit": {
                  var X16;
                  let D11 = (X16 = T7.filter((M10) => {
                    if (A12) {
                      let U11 = B4(M10.placement);
                      return U11 === v10 || U11 === "y";
                    }
                    return true;
                  }).map((M10) => [M10.placement, M10.overflows.filter((U11) => U11 > 0).reduce((U11, ve8) => U11 + ve8, 0)]).sort((M10, U11) => M10[1] - U11[1])[0]) == null ? void 0 : X16[0];
                  D11 && (_12 = D11);
                  break;
                }
                case "initialPlacement":
                  _12 = c5;
                  break;
              }
              if (i !== _12) return { reset: { placement: _12 } };
            }
            return {};
          });
        } };
      };
      It3 = function(t) {
        return t === void 0 && (t = {}), { name: "hide", options: t, fn(e4) {
          return __async(this, null, function* () {
            let { rects: n, platform: o2 } = e4, _a3 = N4(t, e4), { strategy: i = "referenceHidden" } = _a3, r3 = __objRest(_a3, ["strategy"]);
            switch (i) {
              case "referenceHidden": {
                let s = yield o2.detectOverflow(e4, __spreadProps(__spreadValues({}, r3), { elementContext: "reference" })), c5 = kt3(s, n.reference);
                return { data: { referenceHiddenOffsets: c5, referenceHidden: zt2(c5) } };
              }
              case "escaped": {
                let s = yield o2.detectOverflow(e4, __spreadProps(__spreadValues({}, r3), { altBoundary: true })), c5 = kt3(s, n.floating);
                return { data: { escapedOffsets: c5, escaped: zt2(c5) } };
              }
              default:
                return {};
            }
          });
        } };
      };
      Yt3 = /* @__PURE__ */ new Set(["left", "top"]);
      jt2 = function(t) {
        return t === void 0 && (t = 0), { name: "offset", options: t, fn(e4) {
          return __async(this, null, function* () {
            var n, o2;
            let { x: i, y: r3, placement: s, middlewareData: c5 } = e4, l4 = yield Te2(e4, t);
            return s === ((n = c5.offset) == null ? void 0 : n.placement) && (o2 = c5.arrow) != null && o2.alignmentOffset ? {} : { x: i + l4.x, y: r3 + l4.y, data: __spreadProps(__spreadValues({}, l4), { placement: s }) };
          });
        } };
      };
      Xt3 = function(t) {
        return t === void 0 && (t = {}), { name: "shift", options: t, fn(e4) {
          return __async(this, null, function* () {
            let { x: n, y: o2, placement: i, platform: r3 } = e4, _a3 = N4(t, e4), { mainAxis: s = true, crossAxis: c5 = false, limiter: l4 = { fn: (w10) => {
              let { x: v10, y: x14 } = w10;
              return { x: v10, y: x14 };
            } } } = _a3, f4 = __objRest(_a3, ["mainAxis", "crossAxis", "limiter"]), d4 = { x: n, y: o2 }, u3 = yield r3.detectOverflow(e4, f4), g7 = B4(V7(i)), a3 = ut4(g7), m5 = d4[a3], h6 = d4[g7];
            if (s) {
              let w10 = a3 === "y" ? "top" : "left", v10 = a3 === "y" ? "bottom" : "right", x14 = m5 + u3[w10], y11 = m5 - u3[v10];
              m5 = ft3(x14, m5, y11);
            }
            if (c5) {
              let w10 = g7 === "y" ? "top" : "left", v10 = g7 === "y" ? "bottom" : "right", x14 = h6 + u3[w10], y11 = h6 - u3[v10];
              h6 = ft3(x14, h6, y11);
            }
            let p4 = l4.fn(__spreadProps(__spreadValues({}, e4), { [a3]: m5, [g7]: h6 }));
            return __spreadProps(__spreadValues({}, p4), { data: { x: p4.x - n, y: p4.y - o2, enabled: { [a3]: s, [g7]: c5 } } });
          });
        } };
      };
      Ut2 = function(t) {
        return t === void 0 && (t = {}), { options: t, fn(e4) {
          let { x: n, y: o2, placement: i, rects: r3, middlewareData: s } = e4, { offset: c5 = 0, mainAxis: l4 = true, crossAxis: f4 = true } = N4(t, e4), d4 = { x: n, y: o2 }, u3 = B4(i), g7 = ut4(u3), a3 = d4[g7], m5 = d4[u3], h6 = N4(c5, e4), p4 = typeof h6 == "number" ? { mainAxis: h6, crossAxis: 0 } : __spreadValues({ mainAxis: 0, crossAxis: 0 }, h6);
          if (l4) {
            let x14 = g7 === "y" ? "height" : "width", y11 = r3.reference[g7] - r3.floating[x14] + p4.mainAxis, b10 = r3.reference[g7] + r3.reference[x14] - p4.mainAxis;
            a3 < y11 ? a3 = y11 : a3 > b10 && (a3 = b10);
          }
          if (f4) {
            var w10, v10;
            let x14 = g7 === "y" ? "width" : "height", y11 = Yt3.has(V7(i)), b10 = r3.reference[u3] - r3.floating[x14] + (y11 && ((w10 = s.offset) == null ? void 0 : w10[u3]) || 0) + (y11 ? 0 : p4.crossAxis), A12 = r3.reference[u3] + r3.reference[x14] + (y11 ? 0 : ((v10 = s.offset) == null ? void 0 : v10[u3]) || 0) - (y11 ? p4.crossAxis : 0);
            m5 < b10 ? m5 = b10 : m5 > A12 && (m5 = A12);
          }
          return { [g7]: a3, [u3]: m5 };
        } };
      };
      qt2 = function(t) {
        return t === void 0 && (t = {}), { name: "size", options: t, fn(e4) {
          return __async(this, null, function* () {
            var n, o2;
            let { placement: i, rects: r3, platform: s, elements: c5 } = e4, _a3 = N4(t, e4), { apply: l4 = () => {
            } } = _a3, f4 = __objRest(_a3, ["apply"]), d4 = yield s.detectOverflow(e4, f4), u3 = V7(i), g7 = K8(i), a3 = B4(i) === "y", { width: m5, height: h6 } = r3.floating, p4, w10;
            u3 === "top" || u3 === "bottom" ? (p4 = u3, w10 = g7 === ((yield s.isRTL == null ? void 0 : s.isRTL(c5.floating)) ? "start" : "end") ? "left" : "right") : (w10 = u3, p4 = g7 === "end" ? "top" : "bottom");
            let v10 = h6 - d4.top - d4.bottom, x14 = m5 - d4.left - d4.right, y11 = F6(h6 - d4[p4], v10), b10 = F6(m5 - d4[w10], x14), A12 = !e4.middlewareData.shift, O10 = y11, C17 = b10;
            if ((n = e4.middlewareData.shift) != null && n.enabled.x && (C17 = x14), (o2 = e4.middlewareData.shift) != null && o2.enabled.y && (O10 = v10), A12 && !g7) {
              let T7 = S9(d4.left, 0), j12 = S9(d4.right, 0), z12 = S9(d4.top, 0), X16 = S9(d4.bottom, 0);
              a3 ? C17 = m5 - 2 * (T7 !== 0 || j12 !== 0 ? T7 + j12 : S9(d4.left, d4.right)) : O10 = h6 - 2 * (z12 !== 0 || X16 !== 0 ? z12 + X16 : S9(d4.top, d4.bottom));
            }
            yield l4(__spreadProps(__spreadValues({}, e4), { availableWidth: C17, availableHeight: O10 }));
            let k14 = yield s.getDimensions(c5.floating);
            return m5 !== k14.width || h6 !== k14.height ? { reset: { rects: true } } : {};
          });
        } };
      };
      Ee2 = /* @__PURE__ */ new Set(["inline", "contents"]);
      Le2 = /* @__PURE__ */ new Set(["table", "td", "th"]);
      De2 = [":popover-open", ":modal"];
      Me2 = ["transform", "translate", "scale", "rotate", "perspective"];
      $e2 = ["transform", "translate", "scale", "rotate", "perspective", "filter"];
      Be2 = ["paint", "layout", "strict", "content"];
      We2 = /* @__PURE__ */ new Set(["html", "body", "#document"]);
      He2 = $5(0);
      te3 = 25;
      _e2 = /* @__PURE__ */ new Set(["absolute", "fixed"]);
      qe2 = function(t) {
        return __async(this, null, function* () {
          let e4 = this.getOffsetParent || ce3, n = this.getDimensions, o2 = yield n(t.floating);
          return { reference: Ue2(t.reference, yield e4(t.floating), t.strategy), floating: { x: 0, y: 0, width: o2.width, height: o2.height } };
        });
      };
      Ge2 = { convertOffsetParentRelativeRectToViewportRelativeRect: ze2, getDocumentElement: W7, getClippingRect: je2, getOffsetParent: ce3, getElementRects: qe2, getClientRects: Fe2, getDimensions: Xe2, getScale: nt4, isElement: E6, isRTL: Ke2 };
      fe3 = jt2;
      ue3 = Xt3;
      de3 = _t;
      me2 = qt2;
      ge3 = It3;
      he2 = Vt2;
      pe4 = Ut2;
      we2 = (t, e4, n) => {
        let o2 = /* @__PURE__ */ new Map(), i = __spreadValues({ platform: Ge2 }, n), r3 = __spreadProps(__spreadValues({}, i.platform), { _c: o2 });
        return Nt2(t, e4, __spreadProps(__spreadValues({}, i), { platform: r3 }));
      };
      lt2 = (t) => ({ variable: t, reference: `var(${t})` });
      Y7 = { arrowSize: lt2("--arrow-size"), arrowSizeHalf: lt2("--arrow-size-half"), arrowBg: lt2("--arrow-background"), transformOrigin: lt2("--transform-origin"), arrowOffset: lt2("--arrow-offset") };
      tn2 = (t) => t === "top" || t === "bottom" ? "y" : "x";
      nn2 = { name: "rects", fn({ rects: t }) {
        return { data: t };
      } };
      on2 = (t) => {
        if (t) return { name: "shiftArrow", fn({ placement: e4, middlewareData: n }) {
          if (!n.arrow) return {};
          let { x: o2, y: i } = n.arrow, r3 = e4.split("-")[0];
          return Object.assign(t.style, { left: o2 != null ? `${o2}px` : "", top: i != null ? `${i}px` : "", [r3]: `calc(100% + ${Y7.arrowOffset.reference})` }), {};
        } };
      };
      sn2 = { strategy: "absolute", placement: "bottom", listeners: true, gutter: 8, flip: true, slide: true, overlap: false, sameWidth: false, fitViewport: false, overflowPadding: 8, arrowPadding: 4 };
      hn2 = { bottom: "rotate(45deg)", left: "rotate(135deg)", top: "rotate(225deg)", right: "rotate(315deg)" };
    }
  });

  // ../priv/static/chunk-L4HS2GN2.mjs
  function $6(t) {
    let e4 = { each(n) {
      var _a2;
      for (let i = 0; i < ((_a2 = t.frames) == null ? void 0 : _a2.length); i += 1) {
        let r3 = t.frames[i];
        r3 && n(r3);
      }
    }, addEventListener(n, i, r3) {
      return e4.each((c5) => {
        try {
          c5.document.addEventListener(n, i, r3);
        } catch (e5) {
        }
      }), () => {
        try {
          e4.removeEventListener(n, i, r3);
        } catch (e5) {
        }
      };
    }, removeEventListener(n, i, r3) {
      e4.each((c5) => {
        try {
          c5.document.removeEventListener(n, i, r3);
        } catch (e5) {
        }
      });
    } };
    return e4;
  }
  function j6(t) {
    let e4 = t.frameElement != null ? t.parent : null;
    return { addEventListener: (n, i, r3) => {
      try {
        e4 == null ? void 0 : e4.addEventListener(n, i, r3);
      } catch (e5) {
      }
      return () => {
        try {
          e4 == null ? void 0 : e4.removeEventListener(n, i, r3);
        } catch (e5) {
        }
      };
    }, removeEventListener: (n, i, r3) => {
      try {
        e4 == null ? void 0 : e4.removeEventListener(n, i, r3);
      } catch (e5) {
      }
    } };
  }
  function z3(t) {
    for (let e4 of t) if (S(e4) && X(e4)) return true;
    return false;
  }
  function G8(t, e4) {
    if (!M4(e4) || !t) return false;
    let n = t.getBoundingClientRect();
    return n.width === 0 || n.height === 0 ? false : n.top <= e4.clientY && e4.clientY <= n.top + n.height && n.left <= e4.clientX && e4.clientX <= n.left + n.width;
  }
  function J8(t, e4) {
    return t.y <= e4.y && e4.y <= t.y + t.height && t.x <= e4.x && e4.x <= t.x + t.width;
  }
  function U5(t, e4) {
    if (!e4 || !M4(t)) return false;
    let n = e4.scrollHeight > e4.clientHeight, i = n && t.clientX > e4.offsetLeft + e4.clientWidth, r3 = e4.scrollWidth > e4.clientWidth, c5 = r3 && t.clientY > e4.offsetTop + e4.clientHeight, h6 = { x: e4.offsetLeft, y: e4.offsetTop, width: e4.clientWidth + (n ? 16 : 0), height: e4.clientHeight + (r3 ? 16 : 0) }, w10 = { x: t.clientX, y: t.clientY };
    return J8(h6, w10) ? i || c5 : false;
  }
  function K9(t, e4) {
    let { exclude: n, onFocusOutside: i, onPointerDownOutside: r3, onInteractOutside: c5, defer: h6, followControlledElements: w10 = true } = e4;
    if (!t) return;
    let E15 = q(t), I11 = T(t), v10 = $6(I11), L13 = j6(I11);
    function O10(o2, s) {
      if (!S(s) || !s.isConnected || Ie(t, s) || G8(t, o2) || w10 && Wr(t, s)) return false;
      let u3 = E15.querySelector(`[aria-controls="${t.id}"]`);
      if (u3) {
        let l4 = Pn(u3);
        if (U5(o2, l4)) return false;
      }
      let f4 = Pn(t);
      return U5(o2, f4) ? false : !(n == null ? void 0 : n(s));
    }
    let d4 = /* @__PURE__ */ new Set(), D11 = z(t == null ? void 0 : t.getRootNode());
    function b10(o2) {
      function s(u3) {
        var _a2, _b;
        let f4 = h6 && !Gr() ? nt : (m5) => m5(), l4 = u3 != null ? u3 : o2, Y16 = (_b = (_a2 = l4 == null ? void 0 : l4.composedPath) == null ? void 0 : _a2.call(l4)) != null ? _b : [l4 == null ? void 0 : l4.target];
        f4(() => {
          let m5 = D11 ? Y16[0] : Je(o2);
          if (!(!t || !O10(o2, m5))) {
            if (r3 || c5) {
              let B12 = re(r3, c5);
              t.addEventListener(F7, B12, { once: true });
            }
            V8(t, F7, { bubbles: false, cancelable: true, detail: { originalEvent: l4, contextmenu: oo(l4), focusable: z3(Y16), target: m5 } });
          }
        });
      }
      o2.pointerType === "touch" ? (d4.forEach((u3) => u3()), d4.add(P(E15, "click", s, { once: true })), d4.add(L13.addEventListener("click", s, { once: true })), d4.add(v10.addEventListener("click", s, { once: true }))) : s();
    }
    let a3 = /* @__PURE__ */ new Set(), q15 = setTimeout(() => {
      a3.add(P(E15, "pointerdown", b10, true)), a3.add(L13.addEventListener("pointerdown", b10, true)), a3.add(v10.addEventListener("pointerdown", b10, true));
    }, 0);
    function y11(o2) {
      (h6 ? nt : (u3) => u3())(() => {
        var _a2, _b;
        let u3 = (_b = (_a2 = o2 == null ? void 0 : o2.composedPath) == null ? void 0 : _a2.call(o2)) != null ? _b : [o2 == null ? void 0 : o2.target], f4 = D11 ? u3[0] : Je(o2);
        if (!(!t || !O10(o2, f4))) {
          if (i || c5) {
            let l4 = re(i, c5);
            t.addEventListener(_4, l4, { once: true });
          }
          V8(t, _4, { bubbles: false, cancelable: true, detail: { originalEvent: o2, contextmenu: false, focusable: X(f4), target: f4 } });
        }
      });
    }
    return Gr() || (a3.add(P(E15, "focusin", y11, true)), a3.add(L13.addEventListener("focusin", y11, true)), a3.add(v10.addEventListener("focusin", y11, true))), () => {
      clearTimeout(q15), d4.forEach((o2) => o2()), a3.forEach((o2) => o2());
    };
  }
  function tt5(t, e4) {
    let { defer: n } = e4, i = n ? nt : (c5) => c5(), r3 = [];
    return r3.push(i(() => {
      let c5 = typeof t == "function" ? t() : t;
      r3.push(K9(c5, e4));
    })), () => {
      r3.forEach((c5) => c5 == null ? void 0 : c5());
    };
  }
  function V8(t, e4, n) {
    let i = t.ownerDocument.defaultView || window, r3 = new i.CustomEvent(e4, n);
    return t.dispatchEvent(r3);
  }
  var F7, _4, M4;
  var init_chunk_L4HS2GN2 = __esm({
    "../priv/static/chunk-L4HS2GN2.mjs"() {
      "use strict";
      init_chunk_IYURAQ6S();
      F7 = "pointerdown.outside";
      _4 = "focus.outside";
      M4 = (t) => "clientY" in t;
    }
  });

  // ../priv/static/chunk-5MNNWH4C.mjs
  function q6(e4, t) {
    let n = (s) => {
      s.key === "Escape" && (s.isComposing || (t == null ? void 0 : t(s)));
    };
    return P(q(e4), "keydown", n, { capture: true });
  }
  function _5(e4, t, n) {
    let s = e4.ownerDocument.defaultView || window, i = new s.CustomEvent(t, { cancelable: true, bubbles: true, detail: n });
    return e4.dispatchEvent(i);
  }
  function C7(e4, t, n) {
    e4.addEventListener(t, n, { once: true });
  }
  function D5() {
    a2.layers.forEach(({ node: e4 }) => {
      e4.style.pointerEvents = a2.isBelowPointerBlockingLayer(e4) ? "none" : "auto";
    });
  }
  function K10(e4) {
    e4.style.pointerEvents = "";
  }
  function z4(e4, t) {
    let n = q(e4), s = [];
    return a2.hasPointerBlockingLayer() && !n.body.hasAttribute("data-inert") && (w6 = document.body.style.pointerEvents, queueMicrotask(() => {
      n.body.style.pointerEvents = "none", n.body.setAttribute("data-inert", "");
    })), t == null ? void 0 : t.forEach((i) => {
      let [o2, d4] = Lo(() => {
        let c5 = i();
        return S(c5) ? c5 : null;
      }, { timeout: 1e3 });
      o2.then((c5) => s.push(No(c5, { pointerEvents: "auto" }))), s.push(d4);
    }), () => {
      a2.hasPointerBlockingLayer() || (queueMicrotask(() => {
        n.body.style.pointerEvents = w6, n.body.removeAttribute("data-inert"), n.body.style.length === 0 && n.body.removeAttribute("style");
      }), s.forEach((i) => i()));
    };
  }
  function j7(e4, t) {
    let { warnOnMissingNode: n = true } = t;
    if (n && !e4) {
      Mt("[@zag-js/dismissable] node is `null` or `undefined`");
      return;
    }
    if (!e4) return;
    let { onDismiss: s, onRequestDismiss: i, pointerBlocking: o2, exclude: d4, debug: c5, type: T7 = "dialog" } = t, I11 = { dismiss: s, node: e4, type: T7, pointerBlocking: o2, requestDismiss: i };
    a2.add(I11), D5();
    function A12(r3) {
      var _a2, _b;
      let u3 = Je(r3.detail.originalEvent);
      a2.isBelowPointerBlockingLayer(e4) || a2.isInBranch(u3) || ((_a2 = t.onPointerDownOutside) == null ? void 0 : _a2.call(t, r3), (_b = t.onInteractOutside) == null ? void 0 : _b.call(t, r3), !r3.defaultPrevented && (c5 && console.log("onPointerDownOutside:", r3.detail.originalEvent), s == null ? void 0 : s()));
    }
    function N10(r3) {
      var _a2, _b;
      let u3 = Je(r3.detail.originalEvent);
      a2.isInBranch(u3) || ((_a2 = t.onFocusOutside) == null ? void 0 : _a2.call(t, r3), (_b = t.onInteractOutside) == null ? void 0 : _b.call(t, r3), !r3.defaultPrevented && (c5 && console.log("onFocusOutside:", r3.detail.originalEvent), s == null ? void 0 : s()));
    }
    function M10(r3) {
      var _a2;
      a2.isTopMost(e4) && ((_a2 = t.onEscapeKeyDown) == null ? void 0 : _a2.call(t, r3), !r3.defaultPrevented && s && (r3.preventDefault(), s()));
    }
    function S13(r3) {
      var _a2;
      if (!e4) return false;
      let u3 = typeof d4 == "function" ? d4() : d4, L13 = Array.isArray(u3) ? u3 : [u3], b10 = (_a2 = t.persistentElements) == null ? void 0 : _a2.map((y11) => y11()).filter(S);
      return b10 && L13.push(...b10), L13.some((y11) => Ie(y11, r3)) || a2.isInNestedLayer(e4, r3);
    }
    let R7 = [o2 ? z4(e4, t.persistentElements) : void 0, q6(e4, M10), tt5(e4, { exclude: S13, onFocusOutside: N10, onPointerDownOutside: A12, defer: t.defer })];
    return () => {
      a2.remove(e4), D5(), K10(e4), R7.forEach((r3) => r3 == null ? void 0 : r3());
    };
  }
  function H9(e4, t) {
    let { defer: n } = t, s = n ? nt : (o2) => o2(), i = [];
    return i.push(s(() => {
      let o2 = C(e4) ? e4() : e4;
      i.push(j7(o2, t));
    })), () => {
      i.forEach((o2) => o2 == null ? void 0 : o2());
    };
  }
  function Q8(e4, t = {}) {
    let { defer: n } = t, s = n ? nt : (o2) => o2(), i = [];
    return i.push(s(() => {
      let o2 = C(e4) ? e4() : e4;
      if (!o2) {
        Mt("[@zag-js/dismissable] branch node is `null` or `undefined`");
        return;
      }
      a2.addBranch(o2), i.push(() => {
        a2.removeBranch(o2);
      });
    })), () => {
      i.forEach((o2) => o2 == null ? void 0 : o2());
    };
  }
  var P8, a2, w6;
  var init_chunk_5MNNWH4C = __esm({
    "../priv/static/chunk-5MNNWH4C.mjs"() {
      "use strict";
      init_chunk_L4HS2GN2();
      init_chunk_IYURAQ6S();
      P8 = "layer:request-dismiss";
      a2 = { layers: [], branches: [], recentlyRemoved: /* @__PURE__ */ new Set(), count() {
        return this.layers.length;
      }, pointerBlockingLayers() {
        return this.layers.filter((e4) => e4.pointerBlocking);
      }, topMostPointerBlockingLayer() {
        return [...this.pointerBlockingLayers()].slice(-1)[0];
      }, hasPointerBlockingLayer() {
        return this.pointerBlockingLayers().length > 0;
      }, isBelowPointerBlockingLayer(e4) {
        var _a2;
        let t = this.indexOf(e4), n = this.topMostPointerBlockingLayer() ? this.indexOf((_a2 = this.topMostPointerBlockingLayer()) == null ? void 0 : _a2.node) : -1;
        return t < n;
      }, isTopMost(e4) {
        var _a2;
        return ((_a2 = this.layers[this.count() - 1]) == null ? void 0 : _a2.node) === e4;
      }, getNestedLayers(e4) {
        return Array.from(this.layers).slice(this.indexOf(e4) + 1);
      }, getLayersByType(e4) {
        return this.layers.filter((t) => t.type === e4);
      }, getNestedLayersByType(e4, t) {
        let n = this.indexOf(e4);
        return n === -1 ? [] : this.layers.slice(n + 1).filter((s) => s.type === t);
      }, getParentLayerOfType(e4, t) {
        let n = this.indexOf(e4);
        if (!(n <= 0)) return this.layers.slice(0, n).reverse().find((s) => s.type === t);
      }, countNestedLayersOfType(e4, t) {
        return this.getNestedLayersByType(e4, t).length;
      }, isInNestedLayer(e4, t) {
        return !!(this.getNestedLayers(e4).some((s) => Ie(s.node, t)) || this.recentlyRemoved.size > 0);
      }, isInBranch(e4) {
        return Array.from(this.branches).some((t) => Ie(t, e4));
      }, add(e4) {
        this.layers.push(e4), this.syncLayers();
      }, addBranch(e4) {
        this.branches.push(e4);
      }, remove(e4) {
        let t = this.indexOf(e4);
        t < 0 || (this.recentlyRemoved.add(e4), vn(() => this.recentlyRemoved.delete(e4)), t < this.count() - 1 && this.getNestedLayers(e4).forEach((s) => a2.dismiss(s.node, e4)), this.layers.splice(t, 1), this.syncLayers());
      }, removeBranch(e4) {
        let t = this.branches.indexOf(e4);
        t >= 0 && this.branches.splice(t, 1);
      }, syncLayers() {
        this.layers.forEach((e4, t) => {
          e4.node.style.setProperty("--layer-index", `${t}`), e4.node.removeAttribute("data-nested"), e4.node.removeAttribute("data-has-nested"), this.getParentLayerOfType(e4.node, e4.type) && e4.node.setAttribute("data-nested", e4.type);
          let s = this.countNestedLayersOfType(e4.node, e4.type);
          s > 0 && e4.node.setAttribute("data-has-nested", e4.type), e4.node.style.setProperty("--nested-layer-count", `${s}`);
        });
      }, indexOf(e4) {
        return this.layers.findIndex((t) => t.node === e4);
      }, dismiss(e4, t) {
        let n = this.indexOf(e4);
        if (n === -1) return;
        let s = this.layers[n];
        C7(e4, P8, (i) => {
          var _a2;
          (_a2 = s.requestDismiss) == null ? void 0 : _a2.call(s, i), i.defaultPrevented || (s == null ? void 0 : s.dismiss());
        }), _5(e4, P8, { originalLayer: e4, targetLayer: t, originalIndex: n, targetIndex: t ? this.indexOf(t) : -1 }), this.syncLayers();
      }, clear() {
        this.remove(this.layers[0].node);
      } };
    }
  });

  // ../priv/static/combobox.mjs
  var combobox_exports = {};
  __export(combobox_exports, {
    Combobox: () => Ct3
  });
  function Fe3(e4, t) {
    let { context: o2, prop: n, state: i, send: l4, scope: a3, computed: r3, event: c5 } = e4, d4 = n("translations"), b10 = n("collection"), h6 = !!n("disabled"), T7 = r3("isInteractive"), v10 = !!n("invalid"), D11 = !!n("required"), P11 = !!n("readOnly"), m5 = i.hasTag("open"), H12 = i.hasTag("focused"), N10 = n("composite"), L13 = o2.get("highlightedValue"), Ae8 = $n2(__spreadProps(__spreadValues({}, n("positioning")), { placement: o2.get("currentPlacement") }));
    function B12(s) {
      let u3 = b10.getItemDisabled(s.item), f4 = b10.getItemValue(s.item);
      return ds(f4, () => `[zag-js] No value found for item ${JSON.stringify(s.item)}`), { value: f4, disabled: !!(u3 || u3), highlighted: L13 === f4, selected: o2.get("value").includes(f4) };
    }
    return { focused: H12, open: m5, inputValue: o2.get("inputValue"), highlightedValue: L13, highlightedItem: o2.get("highlightedItem"), value: o2.get("value"), valueAsString: r3("valueAsString"), hasSelectedItems: r3("hasSelectedItems"), selectedItems: o2.get("selectedItems"), collection: n("collection"), multiple: !!n("multiple"), disabled: !!h6, syncSelectedItems() {
      l4({ type: "SELECTED_ITEMS.SYNC" });
    }, reposition(s = {}) {
      l4({ type: "POSITIONING.SET", options: s });
    }, setHighlightValue(s) {
      l4({ type: "HIGHLIGHTED_VALUE.SET", value: s });
    }, clearHighlightValue() {
      l4({ type: "HIGHLIGHTED_VALUE.CLEAR" });
    }, selectValue(s) {
      l4({ type: "ITEM.SELECT", value: s });
    }, setValue(s) {
      l4({ type: "VALUE.SET", value: s });
    }, setInputValue(s, u3 = "script") {
      l4({ type: "INPUT_VALUE.SET", value: s, src: u3 });
    }, clearValue(s) {
      s != null ? l4({ type: "ITEM.CLEAR", value: s }) : l4({ type: "VALUE.CLEAR" });
    }, focus() {
      var _a2;
      (_a2 = A5(a3)) == null ? void 0 : _a2.focus();
    }, setOpen(s, u3 = "script") {
      i.hasTag("open") !== s && l4({ type: s ? "OPEN" : "CLOSE", src: u3 });
    }, getRootProps() {
      return t.element(__spreadProps(__spreadValues({}, E7.root.attrs), { dir: n("dir"), id: _e3(a3), "data-invalid": jr(v10), "data-readonly": jr(P11) }));
    }, getLabelProps() {
      return t.label(__spreadProps(__spreadValues({}, E7.label.attrs), { dir: n("dir"), htmlFor: $7(a3), id: ee4(a3), "data-readonly": jr(P11), "data-disabled": jr(h6), "data-invalid": jr(v10), "data-required": jr(D11), "data-focus": jr(H12), onClick(s) {
        var _a2;
        N10 || (s.preventDefault(), (_a2 = _6(a3)) == null ? void 0 : _a2.focus({ preventScroll: true }));
      } }));
    }, getControlProps() {
      return t.element(__spreadProps(__spreadValues({}, E7.control.attrs), { dir: n("dir"), id: Le3(a3), "data-state": m5 ? "open" : "closed", "data-focus": jr(H12), "data-disabled": jr(h6), "data-invalid": jr(v10) }));
    }, getPositionerProps() {
      return t.element(__spreadProps(__spreadValues({}, E7.positioner.attrs), { dir: n("dir"), id: ke4(a3), style: Ae8.floating }));
    }, getInputProps() {
      return t.input(__spreadProps(__spreadValues({}, E7.input.attrs), { dir: n("dir"), "aria-invalid": Br(v10), "data-invalid": jr(v10), "data-autofocus": jr(n("autoFocus")), name: n("name"), form: n("form"), disabled: h6, required: n("required"), autoComplete: "off", autoCorrect: "off", autoCapitalize: "none", spellCheck: "false", readOnly: P11, placeholder: n("placeholder"), id: $7(a3), type: "text", role: "combobox", defaultValue: o2.get("inputValue"), "aria-autocomplete": r3("autoComplete") ? "both" : "list", "aria-controls": W8(a3), "aria-expanded": m5, "data-state": m5 ? "open" : "closed", "aria-activedescendant": L13 ? Ve4(a3, L13) : void 0, onClick(s) {
        s.defaultPrevented || n("openOnClick") && T7 && l4({ type: "INPUT.CLICK", src: "input-click" });
      }, onFocus() {
        h6 || l4({ type: "INPUT.FOCUS" });
      }, onBlur() {
        h6 || l4({ type: "INPUT.BLUR" });
      }, onChange(s) {
        l4({ type: "INPUT.CHANGE", value: s.currentTarget.value, src: "input-change" });
      }, onKeyDown(s) {
        if (s.defaultPrevented || !T7 || s.ctrlKey || s.shiftKey || to(s)) return;
        let u3 = n("openOnKeyPress"), f4 = s.ctrlKey || s.metaKey || s.shiftKey, O10 = true, M10 = { ArrowDown(k14) {
          !u3 && !m5 || (l4({ type: k14.altKey ? "OPEN" : "INPUT.ARROW_DOWN", keypress: O10, src: "arrow-key" }), k14.preventDefault());
        }, ArrowUp() {
          !u3 && !m5 || (l4({ type: s.altKey ? "CLOSE" : "INPUT.ARROW_UP", keypress: O10, src: "arrow-key" }), s.preventDefault());
        }, Home(k14) {
          f4 || (l4({ type: "INPUT.HOME", keypress: O10 }), m5 && k14.preventDefault());
        }, End(k14) {
          f4 || (l4({ type: "INPUT.END", keypress: O10 }), m5 && k14.preventDefault());
        }, Enter(k14) {
          var _a2;
          l4({ type: "INPUT.ENTER", keypress: O10, src: "item-select" });
          let Me8 = r3("isCustomValue") && n("allowCustomValue"), Ue8 = L13 != null, we8 = n("alwaysSubmitOnEnter");
          if (m5 && !Me8 && !we8 && Ue8 && k14.preventDefault(), L13 == null) return;
          let Y16 = R2(a3, L13);
          $r(Y16) && ((_a2 = n("navigate")) == null ? void 0 : _a2({ value: L13, node: Y16, href: Y16.href }));
        }, Escape() {
          l4({ type: "INPUT.ESCAPE", keypress: O10, src: "escape-key" }), s.preventDefault();
        } }, Re9 = io(s, { dir: n("dir") }), De9 = M10[Re9];
        De9 == null ? void 0 : De9(s);
      } }));
    }, getTriggerProps(s = {}) {
      return t.button(__spreadProps(__spreadValues({}, E7.trigger.attrs), { dir: n("dir"), id: He3(a3), "aria-haspopup": N10 ? "listbox" : "dialog", type: "button", tabIndex: s.focusable ? void 0 : -1, "aria-label": d4.triggerLabel, "aria-expanded": m5, "data-state": m5 ? "open" : "closed", "aria-controls": m5 ? W8(a3) : void 0, disabled: h6, "data-invalid": jr(v10), "data-focusable": jr(s.focusable), "data-readonly": jr(P11), "data-disabled": jr(h6), onFocus() {
        s.focusable && l4({ type: "INPUT.FOCUS", src: "trigger" });
      }, onClick(u3) {
        u3.defaultPrevented || T7 && ro(u3) && l4({ type: "TRIGGER.CLICK", src: "trigger-click" });
      }, onPointerDown(u3) {
        T7 && u3.pointerType !== "touch" && ro(u3) && (u3.preventDefault(), queueMicrotask(() => {
          var _a2;
          (_a2 = A5(a3)) == null ? void 0 : _a2.focus({ preventScroll: true });
        }));
      }, onKeyDown(u3) {
        if (u3.defaultPrevented || N10) return;
        let f4 = { ArrowDown() {
          l4({ type: "INPUT.ARROW_DOWN", src: "arrow-key" });
        }, ArrowUp() {
          l4({ type: "INPUT.ARROW_UP", src: "arrow-key" });
        } }, O10 = io(u3, { dir: n("dir") }), M10 = f4[O10];
        M10 && (M10(u3), u3.preventDefault());
      } }));
    }, getContentProps() {
      return t.element(__spreadProps(__spreadValues({}, E7.content.attrs), { dir: n("dir"), id: W8(a3), role: N10 ? "listbox" : "dialog", tabIndex: -1, hidden: !m5, "data-state": m5 ? "open" : "closed", "data-placement": o2.get("currentPlacement"), "aria-labelledby": ee4(a3), "aria-multiselectable": n("multiple") && N10 ? true : void 0, "data-empty": jr(b10.size === 0), onPointerDown(s) {
        ro(s) && s.preventDefault();
      } }));
    }, getListProps() {
      return t.element(__spreadProps(__spreadValues({}, E7.list.attrs), { role: N10 ? void 0 : "listbox", "data-empty": jr(b10.size === 0), "aria-labelledby": ee4(a3), "aria-multiselectable": n("multiple") && !N10 ? true : void 0 }));
    }, getClearTriggerProps() {
      return t.button(__spreadProps(__spreadValues({}, E7.clearTrigger.attrs), { dir: n("dir"), id: Ne3(a3), type: "button", tabIndex: -1, disabled: h6, "data-invalid": jr(v10), "aria-label": d4.clearTriggerLabel, "aria-controls": $7(a3), hidden: !o2.get("value").length, onPointerDown(s) {
        ro(s) && s.preventDefault();
      }, onClick(s) {
        s.defaultPrevented || T7 && l4({ type: "VALUE.CLEAR", src: "clear-trigger" });
      } }));
    }, getItemState: B12, getItemProps(s) {
      let u3 = B12(s), f4 = u3.value;
      return t.element(__spreadProps(__spreadValues({}, E7.item.attrs), { dir: n("dir"), id: Ve4(a3, f4), role: "option", tabIndex: -1, "data-highlighted": jr(u3.highlighted), "data-state": u3.selected ? "checked" : "unchecked", "aria-selected": Br(u3.highlighted), "aria-disabled": Br(u3.disabled), "data-disabled": jr(u3.disabled), "data-value": u3.value, onPointerMove() {
        u3.disabled || u3.highlighted || l4({ type: "ITEM.POINTER_MOVE", value: f4 });
      }, onPointerLeave() {
        var _a2;
        s.persistFocus || u3.disabled || !((_a2 = c5.previous()) == null ? void 0 : _a2.type.includes("POINTER")) || l4({ type: "ITEM.POINTER_LEAVE", value: f4 });
      }, onClick(O10) {
        Qr(O10) || Zr(O10) || oo(O10) || u3.disabled || l4({ type: "ITEM.CLICK", src: "item-select", value: f4 });
      } }));
    }, getItemTextProps(s) {
      let u3 = B12(s);
      return t.element(__spreadProps(__spreadValues({}, E7.itemText.attrs), { dir: n("dir"), "data-state": u3.selected ? "checked" : "unchecked", "data-disabled": jr(u3.disabled), "data-highlighted": jr(u3.highlighted) }));
    }, getItemIndicatorProps(s) {
      let u3 = B12(s);
      return t.element(__spreadProps(__spreadValues({ "aria-hidden": true }, E7.itemIndicator.attrs), { dir: n("dir"), "data-state": u3.selected ? "checked" : "unchecked", hidden: !u3.selected }));
    }, getItemGroupProps(s) {
      let { id: u3 } = s;
      return t.element(__spreadProps(__spreadValues({}, E7.itemGroup.attrs), { dir: n("dir"), id: qe3(a3, u3), "aria-labelledby": Oe3(a3, u3), "data-empty": jr(b10.size === 0), role: "group" }));
    }, getItemGroupLabelProps(s) {
      let { htmlFor: u3 } = s;
      return t.element(__spreadProps(__spreadValues({}, E7.itemGroupLabel.attrs), { dir: n("dir"), id: Oe3(a3, u3), role: "presentation" }));
    } };
  }
  function Pe3(e4) {
    return (e4.previousEvent || e4).src;
  }
  function Ze3(e4) {
    return e4.replace(/_([a-z])/g, (t, o2) => o2.toUpperCase());
  }
  function ze3(e4) {
    let t = {};
    for (let [o2, n] of Object.entries(e4)) {
      let i = Ze3(o2);
      t[i] = n;
    }
    return t;
  }
  var Ge3, E7, q7, _e3, ee4, Le3, $7, W8, ke4, He3, Ne3, qe3, Oe3, Ve4, x4, A5, ye3, Te3, _6, Be3, R2, Se3, Ke3, $e3, We3, je3, I8, V9, xe3, Ye3, rt4, Je3, ut5, Qe3, ct4, Xe3, dt3, j8, Ct3;
  var init_combobox = __esm({
    "../priv/static/combobox.mjs"() {
      "use strict";
      init_chunk_MMRG4CGO();
      init_chunk_S6MRQC6S();
      init_chunk_5MNNWH4C();
      init_chunk_L4HS2GN2();
      init_chunk_IYURAQ6S();
      Ge3 = G("combobox").parts("root", "clearTrigger", "content", "control", "input", "item", "itemGroup", "itemGroupLabel", "itemIndicator", "itemText", "label", "list", "positioner", "trigger");
      E7 = Ge3.build();
      q7 = (e4) => new q5(e4);
      q7.empty = () => new q5({ items: [] });
      _e3 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.root) != null ? _b : `combobox:${e4.id}`;
      };
      ee4 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.label) != null ? _b : `combobox:${e4.id}:label`;
      };
      Le3 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.control) != null ? _b : `combobox:${e4.id}:control`;
      };
      $7 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.input) != null ? _b : `combobox:${e4.id}:input`;
      };
      W8 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.content) != null ? _b : `combobox:${e4.id}:content`;
      };
      ke4 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.positioner) != null ? _b : `combobox:${e4.id}:popper`;
      };
      He3 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.trigger) != null ? _b : `combobox:${e4.id}:toggle-btn`;
      };
      Ne3 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.clearTrigger) != null ? _b : `combobox:${e4.id}:clear-btn`;
      };
      qe3 = (e4, t) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = e4.ids) == null ? void 0 : _a2.itemGroup) == null ? void 0 : _b.call(_a2, t)) != null ? _c : `combobox:${e4.id}:optgroup:${t}`;
      };
      Oe3 = (e4, t) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = e4.ids) == null ? void 0 : _a2.itemGroupLabel) == null ? void 0 : _b.call(_a2, t)) != null ? _c : `combobox:${e4.id}:optgroup-label:${t}`;
      };
      Ve4 = (e4, t) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = e4.ids) == null ? void 0 : _a2.item) == null ? void 0 : _b.call(_a2, t)) != null ? _c : `combobox:${e4.id}:option:${t}`;
      };
      x4 = (e4) => e4.getById(W8(e4));
      A5 = (e4) => e4.getById($7(e4));
      ye3 = (e4) => e4.getById(ke4(e4));
      Te3 = (e4) => e4.getById(Le3(e4));
      _6 = (e4) => e4.getById(He3(e4));
      Be3 = (e4) => e4.getById(Ne3(e4));
      R2 = (e4, t) => {
        if (t == null) return null;
        let o2 = `[role=option][data-value="${CSS.escape(t)}"]`;
        return So(x4(e4), o2);
      };
      Se3 = (e4) => {
        let t = A5(e4);
        e4.isActiveElement(t) || (t == null ? void 0 : t.focus({ preventScroll: true }));
      };
      Ke3 = (e4) => {
        let t = _6(e4);
        e4.isActiveElement(t) || (t == null ? void 0 : t.focus({ preventScroll: true }));
      };
      ({ guards: $e3, createMachine: We3, choose: je3 } = ws());
      ({ and: I8, not: V9 } = $e3);
      xe3 = We3({ props({ props: e4 }) {
        return __spreadProps(__spreadValues({ loopFocus: true, openOnClick: false, defaultValue: [], defaultInputValue: "", closeOnSelect: !e4.multiple, allowCustomValue: false, alwaysSubmitOnEnter: false, inputBehavior: "none", selectionBehavior: e4.multiple ? "clear" : "replace", openOnKeyPress: true, openOnChange: true, composite: true, navigate({ node: t }) {
          yo(t);
        }, collection: q7.empty() }, e4), { positioning: __spreadValues({ placement: "bottom", sameWidth: true }, e4.positioning), translations: __spreadValues({ triggerLabel: "Toggle suggestions", clearTriggerLabel: "Clear value" }, e4.translations) });
      }, initialState({ prop: e4 }) {
        return e4("open") || e4("defaultOpen") ? "suggesting" : "idle";
      }, context({ prop: e4, bindable: t, getContext: o2, getEvent: n }) {
        return { currentPlacement: t(() => ({ defaultValue: void 0 })), value: t(() => ({ defaultValue: e4("defaultValue"), value: e4("value"), isEqual: V, hash(i) {
          return i.join(",");
        }, onChange(i) {
          var _a2;
          let l4 = o2(), a3 = l4.get("selectedItems"), r3 = e4("collection"), c5 = i.map((d4) => a3.find((h6) => r3.getItemValue(h6) === d4) || r3.find(d4));
          l4.set("selectedItems", c5), (_a2 = e4("onValueChange")) == null ? void 0 : _a2({ value: i, items: c5 });
        } })), highlightedValue: t(() => ({ defaultValue: e4("defaultHighlightedValue") || null, value: e4("highlightedValue"), onChange(i) {
          var _a2;
          let l4 = e4("collection").find(i);
          (_a2 = e4("onHighlightChange")) == null ? void 0 : _a2({ highlightedValue: i, highlightedItem: l4 });
        } })), inputValue: t(() => {
          let i = e4("inputValue") || e4("defaultInputValue"), l4 = e4("value") || e4("defaultValue");
          if (!i.trim() && !e4("multiple")) {
            let a3 = e4("collection").stringifyMany(l4);
            i = rr(e4("selectionBehavior"), { preserve: i || a3, replace: a3, clear: "" });
          }
          return { defaultValue: i, value: e4("inputValue"), onChange(a3) {
            var _a2;
            let r3 = n(), c5 = (r3.previousEvent || r3).src;
            (_a2 = e4("onInputValueChange")) == null ? void 0 : _a2({ inputValue: a3, reason: c5 });
          } };
        }), highlightedItem: t(() => {
          let i = e4("highlightedValue");
          return { defaultValue: e4("collection").find(i) };
        }), selectedItems: t(() => {
          let i = e4("value") || e4("defaultValue") || [];
          return { defaultValue: e4("collection").findMany(i) };
        }) };
      }, computed: { isInputValueEmpty: ({ context: e4 }) => e4.get("inputValue").length === 0, isInteractive: ({ prop: e4 }) => !(e4("readOnly") || e4("disabled")), autoComplete: ({ prop: e4 }) => e4("inputBehavior") === "autocomplete", autoHighlight: ({ prop: e4 }) => e4("inputBehavior") === "autohighlight", hasSelectedItems: ({ context: e4 }) => e4.get("value").length > 0, valueAsString: ({ context: e4, prop: t }) => t("collection").stringifyItems(e4.get("selectedItems")), isCustomValue: ({ context: e4, computed: t }) => e4.get("inputValue") !== t("valueAsString") }, watch({ context: e4, prop: t, track: o2, action: n, send: i }) {
        o2([() => e4.hash("value")], () => {
          n(["syncSelectedItems"]);
        }), o2([() => e4.get("inputValue")], () => {
          n(["syncInputValue"]);
        }), o2([() => e4.get("highlightedValue")], () => {
          n(["syncHighlightedItem", "autofillInputValue"]);
        }), o2([() => t("open")], () => {
          n(["toggleVisibility"]);
        }), o2([() => t("collection").toString()], () => {
          i({ type: "CHILDREN_CHANGE" });
        });
      }, on: { "SELECTED_ITEMS.SYNC": { actions: ["syncSelectedItems"] }, "HIGHLIGHTED_VALUE.SET": { actions: ["setHighlightedValue"] }, "HIGHLIGHTED_VALUE.CLEAR": { actions: ["clearHighlightedValue"] }, "ITEM.SELECT": { actions: ["selectItem"] }, "ITEM.CLEAR": { actions: ["clearItem"] }, "VALUE.SET": { actions: ["setValue"] }, "INPUT_VALUE.SET": { actions: ["setInputValue"] }, "POSITIONING.SET": { actions: ["reposition"] } }, entry: je3([{ guard: "autoFocus", actions: ["setInitialFocus"] }]), states: { idle: { tags: ["idle", "closed"], entry: ["scrollContentToTop", "clearHighlightedValue"], on: { "CONTROLLED.OPEN": { target: "interacting" }, "TRIGGER.CLICK": [{ guard: "isOpenControlled", actions: ["setInitialFocus", "highlightFirstSelectedItem", "invokeOnOpen"] }, { target: "interacting", actions: ["setInitialFocus", "highlightFirstSelectedItem", "invokeOnOpen"] }], "INPUT.CLICK": [{ guard: "isOpenControlled", actions: ["highlightFirstSelectedItem", "invokeOnOpen"] }, { target: "interacting", actions: ["highlightFirstSelectedItem", "invokeOnOpen"] }], "INPUT.FOCUS": { target: "focused" }, OPEN: [{ guard: "isOpenControlled", actions: ["invokeOnOpen"] }, { target: "interacting", actions: ["invokeOnOpen"] }], "VALUE.CLEAR": { target: "focused", actions: ["clearInputValue", "clearSelectedItems", "setInitialFocus"] } } }, focused: { tags: ["focused", "closed"], entry: ["scrollContentToTop", "clearHighlightedValue"], on: { "CONTROLLED.OPEN": [{ guard: "isChangeEvent", target: "suggesting" }, { target: "interacting" }], "INPUT.CHANGE": [{ guard: I8("isOpenControlled", "openOnChange"), actions: ["setInputValue", "invokeOnOpen", "highlightFirstItemIfNeeded"] }, { guard: "openOnChange", target: "suggesting", actions: ["setInputValue", "invokeOnOpen", "highlightFirstItemIfNeeded"] }, { actions: ["setInputValue"] }], "LAYER.INTERACT_OUTSIDE": { target: "idle" }, "INPUT.ESCAPE": { guard: I8("isCustomValue", V9("allowCustomValue")), actions: ["revertInputValue"] }, "INPUT.BLUR": { target: "idle" }, "INPUT.CLICK": [{ guard: "isOpenControlled", actions: ["highlightFirstSelectedItem", "invokeOnOpen"] }, { target: "interacting", actions: ["highlightFirstSelectedItem", "invokeOnOpen"] }], "TRIGGER.CLICK": [{ guard: "isOpenControlled", actions: ["setInitialFocus", "highlightFirstSelectedItem", "invokeOnOpen"] }, { target: "interacting", actions: ["setInitialFocus", "highlightFirstSelectedItem", "invokeOnOpen"] }], "INPUT.ARROW_DOWN": [{ guard: I8("isOpenControlled", "autoComplete"), actions: ["invokeOnOpen"] }, { guard: "autoComplete", target: "interacting", actions: ["invokeOnOpen"] }, { guard: "isOpenControlled", actions: ["highlightFirstOrSelectedItem", "invokeOnOpen"] }, { target: "interacting", actions: ["highlightFirstOrSelectedItem", "invokeOnOpen"] }], "INPUT.ARROW_UP": [{ guard: "autoComplete", target: "interacting", actions: ["invokeOnOpen"] }, { guard: "autoComplete", target: "interacting", actions: ["invokeOnOpen"] }, { target: "interacting", actions: ["highlightLastOrSelectedItem", "invokeOnOpen"] }, { target: "interacting", actions: ["highlightLastOrSelectedItem", "invokeOnOpen"] }], OPEN: [{ guard: "isOpenControlled", actions: ["invokeOnOpen"] }, { target: "interacting", actions: ["invokeOnOpen"] }], "VALUE.CLEAR": { actions: ["clearInputValue", "clearSelectedItems"] } } }, interacting: { tags: ["open", "focused"], entry: ["setInitialFocus"], effects: ["scrollToHighlightedItem", "trackDismissableLayer", "trackPlacement"], on: { "CONTROLLED.CLOSE": [{ guard: "restoreFocus", target: "focused", actions: ["setFinalFocus"] }, { target: "idle" }], CHILDREN_CHANGE: [{ guard: "isHighlightedItemRemoved", actions: ["clearHighlightedValue"] }, { actions: ["scrollToHighlightedItem"] }], "INPUT.HOME": { actions: ["highlightFirstItem"] }, "INPUT.END": { actions: ["highlightLastItem"] }, "INPUT.ARROW_DOWN": [{ guard: I8("autoComplete", "isLastItemHighlighted"), actions: ["clearHighlightedValue", "scrollContentToTop"] }, { actions: ["highlightNextItem"] }], "INPUT.ARROW_UP": [{ guard: I8("autoComplete", "isFirstItemHighlighted"), actions: ["clearHighlightedValue"] }, { actions: ["highlightPrevItem"] }], "INPUT.ENTER": [{ guard: I8("isOpenControlled", "isCustomValue", V9("hasHighlightedItem"), V9("allowCustomValue")), actions: ["revertInputValue", "invokeOnClose"] }, { guard: I8("isCustomValue", V9("hasHighlightedItem"), V9("allowCustomValue")), target: "focused", actions: ["revertInputValue", "invokeOnClose"] }, { guard: I8("isOpenControlled", "closeOnSelect"), actions: ["selectHighlightedItem", "invokeOnClose"] }, { guard: "closeOnSelect", target: "focused", actions: ["selectHighlightedItem", "invokeOnClose", "setFinalFocus"] }, { actions: ["selectHighlightedItem"] }], "INPUT.CHANGE": [{ guard: "autoComplete", target: "suggesting", actions: ["setInputValue"] }, { target: "suggesting", actions: ["clearHighlightedValue", "setInputValue"] }], "ITEM.POINTER_MOVE": { actions: ["setHighlightedValue"] }, "ITEM.POINTER_LEAVE": { actions: ["clearHighlightedValue"] }, "ITEM.CLICK": [{ guard: I8("isOpenControlled", "closeOnSelect"), actions: ["selectItem", "invokeOnClose"] }, { guard: "closeOnSelect", target: "focused", actions: ["selectItem", "invokeOnClose", "setFinalFocus"] }, { actions: ["selectItem"] }], "LAYER.ESCAPE": [{ guard: I8("isOpenControlled", "autoComplete"), actions: ["syncInputValue", "invokeOnClose"] }, { guard: "autoComplete", target: "focused", actions: ["syncInputValue", "invokeOnClose"] }, { guard: "isOpenControlled", actions: ["invokeOnClose"] }, { target: "focused", actions: ["invokeOnClose", "setFinalFocus"] }], "TRIGGER.CLICK": [{ guard: "isOpenControlled", actions: ["invokeOnClose"] }, { target: "focused", actions: ["invokeOnClose"] }], "LAYER.INTERACT_OUTSIDE": [{ guard: I8("isOpenControlled", "isCustomValue", V9("allowCustomValue")), actions: ["revertInputValue", "invokeOnClose"] }, { guard: I8("isCustomValue", V9("allowCustomValue")), target: "idle", actions: ["revertInputValue", "invokeOnClose"] }, { guard: "isOpenControlled", actions: ["invokeOnClose"] }, { target: "idle", actions: ["invokeOnClose"] }], CLOSE: [{ guard: "isOpenControlled", actions: ["invokeOnClose"] }, { target: "focused", actions: ["invokeOnClose", "setFinalFocus"] }], "VALUE.CLEAR": [{ guard: "isOpenControlled", actions: ["clearInputValue", "clearSelectedItems", "invokeOnClose"] }, { target: "focused", actions: ["clearInputValue", "clearSelectedItems", "invokeOnClose", "setFinalFocus"] }] } }, suggesting: { tags: ["open", "focused"], effects: ["trackDismissableLayer", "scrollToHighlightedItem", "trackPlacement"], entry: ["setInitialFocus"], on: { "CONTROLLED.CLOSE": [{ guard: "restoreFocus", target: "focused", actions: ["setFinalFocus"] }, { target: "idle" }], CHILDREN_CHANGE: [{ guard: I8("isHighlightedItemRemoved", "hasCollectionItems", "autoHighlight"), actions: ["clearHighlightedValue", "highlightFirstItem"] }, { guard: "isHighlightedItemRemoved", actions: ["clearHighlightedValue"] }, { guard: "autoHighlight", actions: ["highlightFirstItem"] }], "INPUT.ARROW_DOWN": { target: "interacting", actions: ["highlightNextItem"] }, "INPUT.ARROW_UP": { target: "interacting", actions: ["highlightPrevItem"] }, "INPUT.HOME": { target: "interacting", actions: ["highlightFirstItem"] }, "INPUT.END": { target: "interacting", actions: ["highlightLastItem"] }, "INPUT.ENTER": [{ guard: I8("isOpenControlled", "isCustomValue", V9("hasHighlightedItem"), V9("allowCustomValue")), actions: ["revertInputValue", "invokeOnClose"] }, { guard: I8("isCustomValue", V9("hasHighlightedItem"), V9("allowCustomValue")), target: "focused", actions: ["revertInputValue", "invokeOnClose"] }, { guard: I8("isOpenControlled", "closeOnSelect"), actions: ["selectHighlightedItem", "invokeOnClose"] }, { guard: "closeOnSelect", target: "focused", actions: ["selectHighlightedItem", "invokeOnClose", "setFinalFocus"] }, { actions: ["selectHighlightedItem"] }], "INPUT.CHANGE": { actions: ["setInputValue"] }, "LAYER.ESCAPE": [{ guard: "isOpenControlled", actions: ["invokeOnClose"] }, { target: "focused", actions: ["invokeOnClose"] }], "ITEM.POINTER_MOVE": { target: "interacting", actions: ["setHighlightedValue"] }, "ITEM.POINTER_LEAVE": { actions: ["clearHighlightedValue"] }, "LAYER.INTERACT_OUTSIDE": [{ guard: I8("isOpenControlled", "isCustomValue", V9("allowCustomValue")), actions: ["revertInputValue", "invokeOnClose"] }, { guard: I8("isCustomValue", V9("allowCustomValue")), target: "idle", actions: ["revertInputValue", "invokeOnClose"] }, { guard: "isOpenControlled", actions: ["invokeOnClose"] }, { target: "idle", actions: ["invokeOnClose"] }], "TRIGGER.CLICK": [{ guard: "isOpenControlled", actions: ["invokeOnClose"] }, { target: "focused", actions: ["invokeOnClose"] }], "ITEM.CLICK": [{ guard: I8("isOpenControlled", "closeOnSelect"), actions: ["selectItem", "invokeOnClose"] }, { guard: "closeOnSelect", target: "focused", actions: ["selectItem", "invokeOnClose", "setFinalFocus"] }, { actions: ["selectItem"] }], CLOSE: [{ guard: "isOpenControlled", actions: ["invokeOnClose"] }, { target: "focused", actions: ["invokeOnClose", "setFinalFocus"] }], "VALUE.CLEAR": [{ guard: "isOpenControlled", actions: ["clearInputValue", "clearSelectedItems", "invokeOnClose"] }, { target: "focused", actions: ["clearInputValue", "clearSelectedItems", "invokeOnClose", "setFinalFocus"] }] } } }, implementations: { guards: { isInputValueEmpty: ({ computed: e4 }) => e4("isInputValueEmpty"), autoComplete: ({ computed: e4, prop: t }) => e4("autoComplete") && !t("multiple"), autoHighlight: ({ computed: e4 }) => e4("autoHighlight"), isFirstItemHighlighted: ({ prop: e4, context: t }) => e4("collection").firstValue === t.get("highlightedValue"), isLastItemHighlighted: ({ prop: e4, context: t }) => e4("collection").lastValue === t.get("highlightedValue"), isCustomValue: ({ computed: e4 }) => e4("isCustomValue"), allowCustomValue: ({ prop: e4 }) => !!e4("allowCustomValue"), hasHighlightedItem: ({ context: e4 }) => e4.get("highlightedValue") != null, closeOnSelect: ({ prop: e4 }) => !!e4("closeOnSelect"), isOpenControlled: ({ prop: e4 }) => e4("open") != null, openOnChange: ({ prop: e4, context: t }) => {
        let o2 = e4("openOnChange");
        return zo(o2) ? o2 : !!(o2 == null ? void 0 : o2({ inputValue: t.get("inputValue") }));
      }, restoreFocus: ({ event: e4 }) => {
        var _a2, _b;
        let t = (_b = e4.restoreFocus) != null ? _b : (_a2 = e4.previousEvent) == null ? void 0 : _a2.restoreFocus;
        return t == null ? true : !!t;
      }, isChangeEvent: ({ event: e4 }) => {
        var _a2;
        return ((_a2 = e4.previousEvent) == null ? void 0 : _a2.type) === "INPUT.CHANGE";
      }, autoFocus: ({ prop: e4 }) => !!e4("autoFocus"), isHighlightedItemRemoved: ({ prop: e4, context: t }) => !e4("collection").has(t.get("highlightedValue")), hasCollectionItems: ({ prop: e4 }) => e4("collection").size > 0 }, effects: { trackDismissableLayer({ send: e4, prop: t, scope: o2 }) {
        return t("disableLayer") ? void 0 : H9(() => x4(o2), { type: "listbox", defer: true, exclude: () => [A5(o2), _6(o2), Be3(o2)], onFocusOutside: t("onFocusOutside"), onPointerDownOutside: t("onPointerDownOutside"), onInteractOutside: t("onInteractOutside"), onEscapeKeyDown(i) {
          i.preventDefault(), i.stopPropagation(), e4({ type: "LAYER.ESCAPE", src: "escape-key" });
        }, onDismiss() {
          e4({ type: "LAYER.INTERACT_OUTSIDE", src: "interact-outside", restoreFocus: false });
        } });
      }, trackPlacement({ context: e4, prop: t, scope: o2 }) {
        let n = () => Te3(o2) || _6(o2), i = () => ye3(o2);
        return e4.set("currentPlacement", t("positioning").placement), Mn2(n, i, __spreadProps(__spreadValues({}, t("positioning")), { defer: true, onComplete(l4) {
          e4.set("currentPlacement", l4.placement);
        } }));
      }, scrollToHighlightedItem({ context: e4, prop: t, scope: o2, event: n }) {
        let i = A5(o2), l4 = [], a3 = (d4) => {
          let b10 = n.current().type.includes("POINTER"), h6 = e4.get("highlightedValue");
          if (b10 || !h6) return;
          let T7 = x4(o2), v10 = t("scrollToIndexFn");
          if (v10) {
            let m5 = t("collection").indexOf(h6);
            v10({ index: m5, immediate: d4, getElement: () => R2(o2, h6) });
            return;
          }
          let D11 = R2(o2, h6), P11 = nt(() => {
            bo(D11, { rootEl: T7, block: "nearest" });
          });
          l4.push(P11);
        }, r3 = nt(() => a3(true));
        l4.push(r3);
        let c5 = go(i, { attributes: ["aria-activedescendant"], callback: () => a3(false) });
        return l4.push(c5), () => {
          l4.forEach((d4) => d4());
        };
      } }, actions: { reposition({ context: e4, prop: t, scope: o2, event: n }) {
        Mn2(() => Te3(o2), () => ye3(o2), __spreadProps(__spreadValues(__spreadValues({}, t("positioning")), n.options), { defer: true, listeners: false, onComplete(a3) {
          e4.set("currentPlacement", a3.placement);
        } }));
      }, setHighlightedValue({ context: e4, event: t }) {
        t.value != null && e4.set("highlightedValue", t.value);
      }, clearHighlightedValue({ context: e4 }) {
        e4.set("highlightedValue", null);
      }, selectHighlightedItem(e4) {
        var _a2;
        let { context: t, prop: o2 } = e4, n = o2("collection"), i = t.get("highlightedValue");
        if (!i || !n.has(i)) return;
        let l4 = o2("multiple") ? Ko(t.get("value"), i) : [i];
        (_a2 = o2("onSelect")) == null ? void 0 : _a2({ value: l4, itemValue: i }), t.set("value", l4);
        let a3 = rr(o2("selectionBehavior"), { preserve: t.get("inputValue"), replace: n.stringifyMany(l4), clear: "" });
        t.set("inputValue", a3);
      }, scrollToHighlightedItem({ context: e4, prop: t, scope: o2 }) {
        vn(() => {
          let n = e4.get("highlightedValue");
          if (n == null) return;
          let i = R2(o2, n), l4 = x4(o2), a3 = t("scrollToIndexFn");
          if (a3) {
            let r3 = t("collection").indexOf(n);
            a3({ index: r3, immediate: true, getElement: () => R2(o2, n) });
            return;
          }
          bo(i, { rootEl: l4, block: "nearest" });
        });
      }, selectItem(e4) {
        let { context: t, event: o2, flush: n, prop: i } = e4;
        o2.value != null && n(() => {
          var _a2;
          let l4 = i("multiple") ? Ko(t.get("value"), o2.value) : [o2.value];
          (_a2 = i("onSelect")) == null ? void 0 : _a2({ value: l4, itemValue: o2.value }), t.set("value", l4);
          let a3 = rr(i("selectionBehavior"), { preserve: t.get("inputValue"), replace: i("collection").stringifyMany(l4), clear: "" });
          t.set("inputValue", a3);
        });
      }, clearItem(e4) {
        let { context: t, event: o2, flush: n, prop: i } = e4;
        o2.value != null && n(() => {
          let l4 = Un(t.get("value"), o2.value);
          t.set("value", l4);
          let a3 = rr(i("selectionBehavior"), { preserve: t.get("inputValue"), replace: i("collection").stringifyMany(l4), clear: "" });
          t.set("inputValue", a3);
        });
      }, setInitialFocus({ scope: e4 }) {
        nt(() => {
          Se3(e4);
        });
      }, setFinalFocus({ scope: e4 }) {
        nt(() => {
          var _a2;
          ((_a2 = _6(e4)) == null ? void 0 : _a2.dataset.focusable) == null ? Se3(e4) : Ke3(e4);
        });
      }, syncInputValue({ context: e4, scope: t, event: o2 }) {
        let n = A5(t);
        n && (n.value = e4.get("inputValue"), queueMicrotask(() => {
          o2.current().type !== "INPUT.CHANGE" && Kr(n);
        }));
      }, setInputValue({ context: e4, event: t }) {
        e4.set("inputValue", t.value);
      }, clearInputValue({ context: e4 }) {
        e4.set("inputValue", "");
      }, revertInputValue({ context: e4, prop: t, computed: o2 }) {
        let n = t("selectionBehavior"), i = rr(n, { replace: o2("hasSelectedItems") ? o2("valueAsString") : "", preserve: e4.get("inputValue"), clear: "" });
        e4.set("inputValue", i);
      }, setValue(e4) {
        let { context: t, flush: o2, event: n, prop: i } = e4;
        o2(() => {
          t.set("value", n.value);
          let l4 = rr(i("selectionBehavior"), { preserve: t.get("inputValue"), replace: i("collection").stringifyMany(n.value), clear: "" });
          t.set("inputValue", l4);
        });
      }, clearSelectedItems(e4) {
        let { context: t, flush: o2, prop: n } = e4;
        o2(() => {
          t.set("value", []);
          let i = rr(n("selectionBehavior"), { preserve: t.get("inputValue"), replace: n("collection").stringifyMany([]), clear: "" });
          t.set("inputValue", i);
        });
      }, scrollContentToTop({ prop: e4, scope: t }) {
        let o2 = e4("scrollToIndexFn");
        if (o2) {
          let n = e4("collection").firstValue;
          o2({ index: 0, immediate: true, getElement: () => R2(t, n) });
        } else {
          let n = x4(t);
          if (!n) return;
          n.scrollTop = 0;
        }
      }, invokeOnOpen({ prop: e4, event: t, context: o2 }) {
        var _a2;
        let n = Pe3(t);
        (_a2 = e4("onOpenChange")) == null ? void 0 : _a2({ open: true, reason: n, value: o2.get("value") });
      }, invokeOnClose({ prop: e4, event: t, context: o2 }) {
        var _a2;
        let n = Pe3(t);
        (_a2 = e4("onOpenChange")) == null ? void 0 : _a2({ open: false, reason: n, value: o2.get("value") });
      }, highlightFirstItem({ context: e4, prop: t, scope: o2 }) {
        (x4(o2) ? queueMicrotask : nt)(() => {
          let i = t("collection").firstValue;
          i && e4.set("highlightedValue", i);
        });
      }, highlightFirstItemIfNeeded({ computed: e4, action: t }) {
        e4("autoHighlight") && t(["highlightFirstItem"]);
      }, highlightLastItem({ context: e4, prop: t, scope: o2 }) {
        (x4(o2) ? queueMicrotask : nt)(() => {
          let i = t("collection").lastValue;
          i && e4.set("highlightedValue", i);
        });
      }, highlightNextItem({ context: e4, prop: t }) {
        let o2 = null, n = e4.get("highlightedValue"), i = t("collection");
        n ? (o2 = i.getNextValue(n), !o2 && t("loopFocus") && (o2 = i.firstValue)) : o2 = i.firstValue, o2 && e4.set("highlightedValue", o2);
      }, highlightPrevItem({ context: e4, prop: t }) {
        let o2 = null, n = e4.get("highlightedValue"), i = t("collection");
        n ? (o2 = i.getPreviousValue(n), !o2 && t("loopFocus") && (o2 = i.lastValue)) : o2 = i.lastValue, o2 && e4.set("highlightedValue", o2);
      }, highlightFirstSelectedItem({ context: e4, prop: t }) {
        nt(() => {
          let [o2] = t("collection").sort(e4.get("value"));
          o2 && e4.set("highlightedValue", o2);
        });
      }, highlightFirstOrSelectedItem({ context: e4, prop: t, computed: o2 }) {
        nt(() => {
          let n = null;
          o2("hasSelectedItems") ? n = t("collection").sort(e4.get("value"))[0] : n = t("collection").firstValue, n && e4.set("highlightedValue", n);
        });
      }, highlightLastOrSelectedItem({ context: e4, prop: t, computed: o2 }) {
        nt(() => {
          let n = t("collection"), i = null;
          o2("hasSelectedItems") ? i = n.sort(e4.get("value"))[0] : i = n.lastValue, i && e4.set("highlightedValue", i);
        });
      }, autofillInputValue({ context: e4, computed: t, prop: o2, event: n, scope: i }) {
        let l4 = A5(i), a3 = o2("collection");
        if (!t("autoComplete") || !l4 || !n.keypress) return;
        let r3 = a3.stringify(e4.get("highlightedValue"));
        nt(() => {
          l4.value = r3 || e4.get("inputValue");
        });
      }, syncSelectedItems(e4) {
        queueMicrotask(() => {
          let { context: t, prop: o2 } = e4, n = o2("collection"), i = t.get("value"), l4 = i.map((r3) => t.get("selectedItems").find((d4) => n.getItemValue(d4) === r3) || n.find(r3));
          t.set("selectedItems", l4);
          let a3 = rr(o2("selectionBehavior"), { preserve: t.get("inputValue"), replace: n.stringifyMany(i), clear: "" });
          t.set("inputValue", a3);
        });
      }, syncHighlightedItem({ context: e4, prop: t }) {
        let o2 = t("collection").find(e4.get("highlightedValue"));
        e4.set("highlightedItem", o2);
      }, toggleVisibility({ event: e4, send: t, prop: o2 }) {
        t({ type: o2("open") ? "CONTROLLED.OPEN" : "CONTROLLED.CLOSE", previousEvent: e4 });
      } } } });
      Ye3 = As()(["allowCustomValue", "autoFocus", "closeOnSelect", "collection", "composite", "defaultHighlightedValue", "defaultInputValue", "defaultOpen", "defaultValue", "dir", "disabled", "disableLayer", "form", "getRootNode", "highlightedValue", "id", "ids", "inputBehavior", "inputValue", "invalid", "loopFocus", "multiple", "name", "navigate", "onFocusOutside", "onHighlightChange", "onInputValueChange", "onInteractOutside", "onOpenChange", "onOpenChange", "onPointerDownOutside", "onSelect", "onValueChange", "open", "openOnChange", "openOnClick", "openOnKeyPress", "placeholder", "positioning", "readOnly", "required", "scrollToIndexFn", "selectionBehavior", "translations", "value", "alwaysSubmitOnEnter"]);
      rt4 = as(Ye3);
      Je3 = As()(["htmlFor"]);
      ut5 = as(Je3);
      Qe3 = As()(["id"]);
      ct4 = as(Qe3);
      Xe3 = As()(["item", "persistFocus"]);
      dt3 = as(Xe3);
      j8 = class extends ve {
        constructor() {
          super(...arguments);
          __publicField(this, "options", []);
          __publicField(this, "allOptions", []);
          __publicField(this, "hasGroups", false);
        }
        setAllOptions(t) {
          this.allOptions = t, this.options = t;
        }
        getCollection() {
          let t = this.options || this.allOptions || [];
          return this.hasGroups ? q7({ items: t, itemToValue: (o2) => {
            var _a2;
            return (_a2 = o2.id) != null ? _a2 : "";
          }, itemToString: (o2) => o2.label, isItemDisabled: (o2) => {
            var _a2;
            return (_a2 = o2.disabled) != null ? _a2 : false;
          }, groupBy: (o2) => o2.group }) : q7({ items: t, itemToValue: (o2) => {
            var _a2;
            return (_a2 = o2.id) != null ? _a2 : "";
          }, itemToString: (o2) => o2.label, isItemDisabled: (o2) => {
            var _a2;
            return (_a2 = o2.disabled) != null ? _a2 : false;
          } });
        }
        initMachine(t) {
          let o2 = this.getCollection.bind(this);
          return new Ls(xe3, __spreadProps(__spreadValues({}, t), { get collection() {
            return o2();
          }, onOpenChange: (n) => {
            n.open && (this.options = this.allOptions), t.onOpenChange && t.onOpenChange(n);
          }, onInputValueChange: (n) => {
            let i = this.allOptions.filter((l4) => l4.label.toLowerCase().includes(n.inputValue.toLowerCase()));
            this.options = i.length > 0 ? i : this.allOptions, t.onInputValueChange && t.onInputValueChange(n);
          } }));
        }
        initApi() {
          return Fe3(this.machine.service, Cs);
        }
        renderItems() {
          var _a2, _b, _c;
          let t = this.el.querySelector('[data-scope="combobox"][data-part="content"]');
          if (!t) return;
          let o2 = this.el.querySelector('[data-templates="combobox"]');
          if (!o2) return;
          t.querySelectorAll('[data-scope="combobox"][data-part="item"]:not([data-template])').forEach((a3) => a3.remove()), t.querySelectorAll('[data-scope="combobox"][data-part="item-group"]:not([data-template])').forEach((a3) => a3.remove());
          let n = this.api.collection.items, i = (_c = (_b = (_a2 = this.api.collection).group) == null ? void 0 : _b.call(_a2)) != null ? _c : [];
          i.some(([a3]) => a3 != null) ? this.renderGroupedItems(t, o2, i) : this.renderFlatItems(t, o2, n);
        }
        renderGroupedItems(t, o2, n) {
          for (let [i, l4] of n) {
            if (i == null) continue;
            let a3 = o2.querySelector(`[data-scope="combobox"][data-part="item-group"][data-id="${i}"][data-template]`);
            if (!a3) continue;
            let r3 = a3.cloneNode(true);
            r3.removeAttribute("data-template"), this.spreadProps(r3, this.api.getItemGroupProps({ id: i }));
            let c5 = r3.querySelector('[data-scope="combobox"][data-part="item-group-label"]');
            c5 && this.spreadProps(c5, this.api.getItemGroupLabelProps({ htmlFor: i }));
            let d4 = r3.querySelector('[data-scope="combobox"][data-part="item-group-content"]');
            if (d4) {
              d4.innerHTML = "";
              for (let b10 of l4) {
                let h6 = this.cloneItem(o2, b10);
                h6 && d4.appendChild(h6);
              }
              t.appendChild(r3);
            }
          }
        }
        renderFlatItems(t, o2, n) {
          for (let i of n) {
            let l4 = this.cloneItem(o2, i);
            l4 && t.appendChild(l4);
          }
        }
        cloneItem(t, o2) {
          let n = this.api.collection.getItemValue(o2), i = t.querySelector(`[data-scope="combobox"][data-part="item"][data-value="${n}"][data-template]`);
          if (!i) return null;
          let l4 = i.cloneNode(true);
          l4.removeAttribute("data-template"), this.spreadProps(l4, this.api.getItemProps({ item: o2 }));
          let a3 = l4.querySelector('[data-scope="combobox"][data-part="item-text"]');
          a3 && (this.spreadProps(a3, this.api.getItemTextProps({ item: o2 })), a3.children.length === 0 && (a3.textContent = o2.label || ""));
          let r3 = l4.querySelector('[data-scope="combobox"][data-part="item-indicator"]');
          return r3 && this.spreadProps(r3, this.api.getItemIndicatorProps({ item: o2 })), l4;
        }
        render() {
          let t = this.el.querySelector('[data-scope="combobox"][data-part="root"]');
          if (!t) return;
          this.spreadProps(t, this.api.getRootProps()), ["label", "control", "input", "trigger", "clear-trigger", "positioner"].forEach((n) => {
            let i = this.el.querySelector(`[data-scope="combobox"][data-part="${n}"]`);
            if (!i) return;
            let l4 = "get" + n.split("-").map((a3) => a3[0].toUpperCase() + a3.slice(1)).join("") + "Props";
            this.spreadProps(i, this.api[l4]());
          });
          let o2 = this.el.querySelector('[data-scope="combobox"][data-part="content"]');
          o2 && (this.spreadProps(o2, this.api.getContentProps()), this.renderItems());
        }
      };
      Ct3 = { mounted() {
        let e4 = this.el, t = this.pushEvent.bind(this), o2 = JSON.parse(e4.dataset.collection || "[]"), n = o2.some((r3) => r3.group !== void 0), i = __spreadProps(__spreadValues({ id: e4.id }, _r(e4, "controlled") ? { value: Cr(e4, "value") } : { defaultValue: Cr(e4, "defaultValue") }), { disabled: _r(e4, "disabled"), placeholder: xr(e4, "placeholder"), alwaysSubmitOnEnter: _r(e4, "alwaysSubmitOnEnter"), autoFocus: _r(e4, "autoFocus"), closeOnSelect: _r(e4, "closeOnSelect"), dir: xr(e4, "dir", ["ltr", "rtl"]), inputBehavior: xr(e4, "inputBehavior", ["autohighlight", "autocomplete", "none"]), loopFocus: _r(e4, "loopFocus"), multiple: _r(e4, "multiple"), invalid: _r(e4, "invalid"), allowCustomValue: false, selectionBehavior: "replace", name: xr(e4, "name"), form: xr(e4, "form"), readOnly: _r(e4, "readOnly"), required: _r(e4, "required"), positioning: (() => {
          let r3 = e4.dataset.positioning;
          if (r3) try {
            let c5 = JSON.parse(r3);
            return ze3(c5);
          } catch (e5) {
            return;
          }
        })(), onOpenChange: (r3) => {
          let c5 = xr(e4, "onOpenChange");
          c5 && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected() && t(c5, { open: r3.open, reason: r3.reason, value: r3.value, id: e4.id });
          let d4 = xr(e4, "onOpenChangeClient");
          d4 && e4.dispatchEvent(new CustomEvent(d4, { bubbles: _r(e4, "bubble"), detail: { open: r3.open, reason: r3.reason, value: r3.value, id: e4.id } }));
        }, onInputValueChange: (r3) => {
          let c5 = xr(e4, "onInputValueChange");
          c5 && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected() && t(c5, { value: r3.inputValue, reason: r3.reason, id: e4.id });
          let d4 = xr(e4, "onInputValueChangeClient");
          d4 && e4.dispatchEvent(new CustomEvent(d4, { bubbles: _r(e4, "bubble"), detail: { value: r3.inputValue, reason: r3.reason, id: e4.id } }));
        }, onValueChange: (r3) => {
          let c5 = e4.querySelector('[data-scope="combobox"][data-part="value-input"]');
          if (c5) {
            let h6 = r3.value.length === 0 ? "" : r3.value.length === 1 ? String(r3.value[0]) : r3.value.map(String).join(",");
            c5.value = h6;
            let T7 = c5.getAttribute("form"), v10 = null;
            T7 ? v10 = document.getElementById(T7) : v10 = c5.closest("form");
            let D11 = new Event("change", { bubbles: true, cancelable: true });
            c5.dispatchEvent(D11);
            let P11 = new Event("input", { bubbles: true, cancelable: true });
            c5.dispatchEvent(P11), v10 && v10.hasAttribute("phx-change") && requestAnimationFrame(() => {
              let m5 = v10.querySelector("input, select, textarea");
              if (m5) {
                let H12 = new Event("change", { bubbles: true, cancelable: true });
                m5.dispatchEvent(H12);
              } else {
                let H12 = new Event("change", { bubbles: true, cancelable: true });
                v10.dispatchEvent(H12);
              }
            });
          }
          let d4 = xr(e4, "onValueChange");
          d4 && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected() && t(d4, { value: r3.value, items: r3.items, id: e4.id });
          let b10 = xr(e4, "onValueChangeClient");
          b10 && e4.dispatchEvent(new CustomEvent(b10, { bubbles: _r(e4, "bubble"), detail: { value: r3.value, items: r3.items, id: e4.id } }));
        } }), l4 = new j8(e4, i);
        l4.hasGroups = n, l4.setAllOptions(o2), l4.init();
        let a3 = _r(e4, "controlled") ? Cr(e4, "value") : Cr(e4, "defaultValue");
        if (a3 && a3.length > 0) {
          let r3 = o2.filter((c5) => {
            var _a2;
            return a3.includes((_a2 = c5.id) != null ? _a2 : "");
          });
          if (r3.length > 0) {
            let c5 = r3.map((d4) => {
              var _a2;
              return (_a2 = d4.label) != null ? _a2 : "";
            }).join(", ");
            if (l4.api && typeof l4.api.setInputValue == "function") l4.api.setInputValue(c5);
            else {
              let d4 = e4.querySelector('[data-scope="combobox"][data-part="input"]');
              d4 && (d4.value = c5);
            }
          }
        }
        this.combobox = l4, this.handlers = [];
      }, updated() {
        let e4 = JSON.parse(this.el.dataset.collection || "[]"), t = e4.some((o2) => o2.group !== void 0);
        if (this.combobox) {
          this.combobox.hasGroups = t, this.combobox.setAllOptions(e4), this.combobox.updateProps(__spreadProps(__spreadValues({}, _r(this.el, "controlled") ? { value: Cr(this.el, "value") } : { defaultValue: Cr(this.el, "defaultValue") }), { name: xr(this.el, "name"), form: xr(this.el, "form"), disabled: _r(this.el, "disabled"), multiple: _r(this.el, "multiple"), dir: xr(this.el, "dir", ["ltr", "rtl"]), invalid: _r(this.el, "invalid"), required: _r(this.el, "required"), readOnly: _r(this.el, "readOnly") }));
          let o2 = this.el.querySelector('[data-scope="combobox"][data-part="input"]');
          o2 && (o2.removeAttribute("name"), o2.removeAttribute("form"), o2.name = "");
        }
      }, destroyed() {
        var _a2;
        if (this.handlers) for (let e4 of this.handlers) this.removeHandleEvent(e4);
        (_a2 = this.combobox) == null ? void 0 : _a2.destroy();
      } };
    }
  });

  // ../priv/static/date-picker.mjs
  var date_picker_exports = {};
  __export(date_picker_exports, {
    DatePicker: () => ps
  });
  function Le4(e4, t) {
    return e4 - t * Math.floor(e4 / t);
  }
  function Ne4(e4, t, a3, r3) {
    t = He4(e4, t);
    let n = t - 1, o2 = -2;
    return a3 <= 2 ? o2 = 0 : Fe4(t) && (o2 = -1), wa - 1 + 365 * n + Math.floor(n / 4) - Math.floor(n / 100) + Math.floor(n / 400) + Math.floor((367 * a3 - 362) / 12 + o2 + r3);
  }
  function Fe4(e4) {
    return e4 % 4 === 0 && (e4 % 100 !== 0 || e4 % 400 === 0);
  }
  function He4(e4, t) {
    return e4 === "BC" ? 1 - t : t;
  }
  function Mr2(e4) {
    let t = "AD";
    return e4 <= 0 && (t = "BC", e4 = 1 - e4), [t, e4];
  }
  function Q9(e4, t) {
    return t = C8(t, e4.calendar), e4.era === t.era && e4.year === t.year && e4.month === t.month && e4.day === t.day;
  }
  function Ea(e4, t) {
    return t = C8(t, e4.calendar), e4 = U6(e4), t = U6(t), e4.era === t.era && e4.year === t.year && e4.month === t.month;
  }
  function Sa(e4, t) {
    return t = C8(t, e4.calendar), e4 = se4(e4), t = se4(t), e4.era === t.era && e4.year === t.year;
  }
  function ut6(e4, t) {
    return ge4(e4.calendar, t.calendar) && Q9(e4, t);
  }
  function ft4(e4, t) {
    return ge4(e4.calendar, t.calendar) && Ea(e4, t);
  }
  function gt3(e4, t) {
    return ge4(e4.calendar, t.calendar) && Sa(e4, t);
  }
  function ge4(e4, t) {
    var a3, r3, n, o2;
    return (o2 = (n = (a3 = e4.isEqual) === null || a3 === void 0 ? void 0 : a3.call(e4, t)) !== null && n !== void 0 ? n : (r3 = t.isEqual) === null || r3 === void 0 ? void 0 : r3.call(t, e4)) !== null && o2 !== void 0 ? o2 : e4.identifier === t.identifier;
  }
  function ht5(e4, t) {
    return Q9(e4, he3(t));
  }
  function pt4(e4, t, a3) {
    let r3 = e4.calendar.toJulianDay(e4), n = a3 ? Or2[a3] : kr2(t), o2 = Math.ceil(r3 + 1 - n) % 7;
    return o2 < 0 && (o2 += 7), o2;
  }
  function Ye4(e4) {
    return A6(Date.now(), e4);
  }
  function he3(e4) {
    return K11(Ye4(e4));
  }
  function mt4(e4, t) {
    return e4.calendar.toJulianDay(e4) - t.calendar.toJulianDay(t);
  }
  function Ca(e4, t) {
    return Da(e4) - Da(t);
  }
  function Da(e4) {
    return e4.hour * 36e5 + e4.minute * 6e4 + e4.second * 1e3 + e4.millisecond;
  }
  function pe5() {
    return lt3 == null && (lt3 = new Intl.DateTimeFormat().resolvedOptions().timeZone), lt3;
  }
  function U6(e4) {
    return e4.subtract({ days: e4.day - 1 });
  }
  function Ee3(e4) {
    return e4.add({ days: e4.calendar.getDaysInMonth(e4) - e4.day });
  }
  function se4(e4) {
    return U6(e4.subtract({ months: e4.month - 1 }));
  }
  function $t3(e4) {
    return Ee3(e4.add({ months: e4.calendar.getMonthsInYear(e4) - e4.month }));
  }
  function ie5(e4, t, a3) {
    let r3 = pt4(e4, t, a3);
    return e4.subtract({ days: r3 });
  }
  function Be4(e4, t, a3) {
    return ie5(e4, t, a3).add({ days: 6 });
  }
  function Va(e4) {
    if (Intl.Locale) {
      let a3 = xa.get(e4);
      return a3 || (a3 = new Intl.Locale(e4).maximize().region, a3 && xa.set(e4, a3)), a3;
    }
    let t = e4.split("-")[1];
    return t === "u" ? void 0 : t;
  }
  function kr2(e4) {
    let t = dt4.get(e4);
    if (!t) {
      if (Intl.Locale) {
        let r3 = new Intl.Locale(e4);
        if ("getWeekInfo" in r3 && (t = r3.getWeekInfo(), t)) return dt4.set(e4, t), t.firstDay;
      }
      let a3 = Va(e4);
      if (e4.includes("-fw-")) {
        let r3 = e4.split("-fw-")[1].split("-")[0];
        r3 === "mon" ? t = { firstDay: 1 } : r3 === "tue" ? t = { firstDay: 2 } : r3 === "wed" ? t = { firstDay: 3 } : r3 === "thu" ? t = { firstDay: 4 } : r3 === "fri" ? t = { firstDay: 5 } : r3 === "sat" ? t = { firstDay: 6 } : t = { firstDay: 0 };
      } else e4.includes("-ca-iso8601") ? t = { firstDay: 1 } : t = { firstDay: a3 && Ta[a3] || 0 };
      dt4.set(e4, t);
    }
    return t.firstDay;
  }
  function yt4(e4, t, a3) {
    let r3 = e4.calendar.getDaysInMonth(e4);
    return Math.ceil((pt4(U6(e4), t, a3) + r3) / 7);
  }
  function We4(e4, t) {
    return e4 && t ? e4.compare(t) <= 0 ? e4 : t : e4 || t;
  }
  function _e4(e4, t) {
    return e4 && t ? e4.compare(t) >= 0 ? e4 : t : e4 || t;
  }
  function vt4(e4, t) {
    let a3 = e4.calendar.toJulianDay(e4), r3 = Math.ceil(a3 + 1) % 7;
    r3 < 0 && (r3 += 7);
    let n = Va(t), [o2, s] = Rr2[n] || [6, 0];
    return r3 === o2 || r3 === s;
  }
  function ae4(e4) {
    e4 = C8(e4, new Y8());
    let t = He4(e4.era, e4.year);
    return Ia(t, e4.month, e4.day, e4.hour, e4.minute, e4.second, e4.millisecond);
  }
  function Ia(e4, t, a3, r3, n, o2, s) {
    let i = /* @__PURE__ */ new Date();
    return i.setUTCHours(r3, n, o2, s), i.setUTCFullYear(e4, t - 1, a3), i.getTime();
  }
  function bt4(e4, t) {
    if (t === "UTC") return 0;
    if (e4 > 0 && t === pe5()) return new Date(e4).getTimezoneOffset() * -6e4;
    let { year: a3, month: r3, day: n, hour: o2, minute: s, second: i } = Oa(e4, t);
    return Ia(a3, r3, n, o2, s, i, 0) - Math.floor(e4 / 1e3) * 1e3;
  }
  function Oa(e4, t) {
    let a3 = Pa.get(t);
    a3 || (a3 = new Intl.DateTimeFormat("en-US", { timeZone: t, hour12: false, era: "short", year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric" }), Pa.set(t, a3));
    let r3 = a3.formatToParts(new Date(e4)), n = {};
    for (let o2 of r3) o2.type !== "literal" && (n[o2.type] = o2.value);
    return { year: n.era === "BC" || n.era === "B" ? -n.year + 1 : +n.year, month: +n.month, day: +n.day, hour: n.hour === "24" ? 0 : +n.hour, minute: +n.minute, second: +n.second };
  }
  function Ar2(e4, t, a3, r3) {
    return (a3 === r3 ? [a3] : [a3, r3]).filter((o2) => Lr2(e4, t, o2));
  }
  function Lr2(e4, t, a3) {
    let r3 = Oa(a3, t);
    return e4.year === r3.year && e4.month === r3.month && e4.day === r3.day && e4.hour === r3.hour && e4.minute === r3.minute && e4.second === r3.second;
  }
  function B5(e4, t, a3 = "compatible") {
    let r3 = W9(e4);
    if (t === "UTC") return ae4(r3);
    if (t === pe5() && a3 === "compatible") {
      r3 = C8(r3, new Y8());
      let u3 = /* @__PURE__ */ new Date(), p4 = He4(r3.era, r3.year);
      return u3.setFullYear(p4, r3.month - 1, r3.day), u3.setHours(r3.hour, r3.minute, r3.second, r3.millisecond), u3.getTime();
    }
    let n = ae4(r3), o2 = bt4(n - Ma, t), s = bt4(n + Ma, t), i = Ar2(r3, t, n - o2, n - s);
    if (i.length === 1) return i[0];
    if (i.length > 1) switch (a3) {
      case "compatible":
      case "earlier":
        return i[0];
      case "later":
        return i[i.length - 1];
      case "reject":
        throw new RangeError("Multiple possible absolute times found");
    }
    switch (a3) {
      case "earlier":
        return Math.min(n - o2, n - s);
      case "compatible":
      case "later":
        return Math.max(n - o2, n - s);
      case "reject":
        throw new RangeError("No such absolute time found");
    }
  }
  function wt4(e4, t, a3 = "compatible") {
    return new Date(B5(e4, t, a3));
  }
  function A6(e4, t) {
    let a3 = bt4(e4, t), r3 = new Date(e4 + a3), n = r3.getUTCFullYear(), o2 = r3.getUTCMonth() + 1, s = r3.getUTCDate(), i = r3.getUTCHours(), u3 = r3.getUTCMinutes(), p4 = r3.getUTCSeconds(), h6 = r3.getUTCMilliseconds();
    return new ce4(n < 1 ? "BC" : "AD", n < 1 ? -n + 1 : n, o2, s, t, a3, i, u3, p4, h6);
  }
  function K11(e4) {
    return new O6(e4.calendar, e4.era, e4.year, e4.month, e4.day);
  }
  function W9(e4, t) {
    let a3 = 0, r3 = 0, n = 0, o2 = 0;
    if ("timeZone" in e4) ({ hour: a3, minute: r3, second: n, millisecond: o2 } = e4);
    else if ("hour" in e4 && !t) return e4;
    return t && ({ hour: a3, minute: r3, second: n, millisecond: o2 } = t), new me3(e4.calendar, e4.era, e4.year, e4.month, e4.day, a3, r3, n, o2);
  }
  function C8(e4, t) {
    if (ge4(e4.calendar, t)) return e4;
    let a3 = t.fromJulianDay(e4.calendar.toJulianDay(e4)), r3 = e4.copy();
    return r3.calendar = t, r3.era = a3.era, r3.year = a3.year, r3.month = a3.month, r3.day = a3.day, X7(r3), r3;
  }
  function Tt3(e4, t, a3) {
    if (e4 instanceof ce4) return e4.timeZone === t ? e4 : Dt4(e4, t);
    let r3 = B5(e4, t, a3);
    return A6(r3, t);
  }
  function ka(e4) {
    let t = ae4(e4) - e4.offset;
    return new Date(t);
  }
  function Dt4(e4, t) {
    let a3 = ae4(e4) - e4.offset;
    return C8(A6(a3, t), e4.calendar);
  }
  function Ve5(e4, t) {
    let a3 = e4.copy(), r3 = "hour" in a3 ? Hr2(a3, t) : 0;
    xt4(a3, t.years || 0), a3.calendar.balanceYearMonth && a3.calendar.balanceYearMonth(a3, e4), a3.month += t.months || 0, Et3(a3), Aa(a3), a3.day += (t.weeks || 0) * 7, a3.day += t.days || 0, a3.day += r3, Nr2(a3), a3.calendar.balanceDate && a3.calendar.balanceDate(a3), a3.year < 1 && (a3.year = 1, a3.month = 1, a3.day = 1);
    let n = a3.calendar.getYearsInEra(a3);
    if (a3.year > n) {
      var o2, s;
      let u3 = (o2 = (s = a3.calendar).isInverseEra) === null || o2 === void 0 ? void 0 : o2.call(s, a3);
      a3.year = n, a3.month = u3 ? 1 : a3.calendar.getMonthsInYear(a3), a3.day = u3 ? 1 : a3.calendar.getDaysInMonth(a3);
    }
    a3.month < 1 && (a3.month = 1, a3.day = 1);
    let i = a3.calendar.getMonthsInYear(a3);
    return a3.month > i && (a3.month = i, a3.day = a3.calendar.getDaysInMonth(a3)), a3.day = Math.max(1, Math.min(a3.calendar.getDaysInMonth(a3), a3.day)), a3;
  }
  function xt4(e4, t) {
    var a3, r3;
    !((a3 = (r3 = e4.calendar).isInverseEra) === null || a3 === void 0) && a3.call(r3, e4) && (t = -t), e4.year += t;
  }
  function Et3(e4) {
    for (; e4.month < 1; ) xt4(e4, -1), e4.month += e4.calendar.getMonthsInYear(e4);
    let t = 0;
    for (; e4.month > (t = e4.calendar.getMonthsInYear(e4)); ) e4.month -= t, xt4(e4, 1);
  }
  function Nr2(e4) {
    for (; e4.day < 1; ) e4.month--, Et3(e4), e4.day += e4.calendar.getDaysInMonth(e4);
    for (; e4.day > e4.calendar.getDaysInMonth(e4); ) e4.day -= e4.calendar.getDaysInMonth(e4), e4.month++, Et3(e4);
  }
  function Aa(e4) {
    e4.month = Math.max(1, Math.min(e4.calendar.getMonthsInYear(e4), e4.month)), e4.day = Math.max(1, Math.min(e4.calendar.getDaysInMonth(e4), e4.day));
  }
  function X7(e4) {
    e4.calendar.constrainDate && e4.calendar.constrainDate(e4), e4.year = Math.max(1, Math.min(e4.calendar.getYearsInEra(e4), e4.year)), Aa(e4);
  }
  function La(e4) {
    let t = {};
    for (let a3 in e4) typeof e4[a3] == "number" && (t[a3] = -e4[a3]);
    return t;
  }
  function St3(e4, t) {
    return Ve5(e4, La(t));
  }
  function Ue3(e4, t) {
    let a3 = e4.copy();
    return t.era != null && (a3.era = t.era), t.year != null && (a3.year = t.year), t.month != null && (a3.month = t.month), t.day != null && (a3.day = t.day), X7(a3), a3;
  }
  function Ce3(e4, t) {
    let a3 = e4.copy();
    return t.hour != null && (a3.hour = t.hour), t.minute != null && (a3.minute = t.minute), t.second != null && (a3.second = t.second), t.millisecond != null && (a3.millisecond = t.millisecond), Na(a3), a3;
  }
  function Fr2(e4) {
    e4.second += Math.floor(e4.millisecond / 1e3), e4.millisecond = qe4(e4.millisecond, 1e3), e4.minute += Math.floor(e4.second / 60), e4.second = qe4(e4.second, 60), e4.hour += Math.floor(e4.minute / 60), e4.minute = qe4(e4.minute, 60);
    let t = Math.floor(e4.hour / 24);
    return e4.hour = qe4(e4.hour, 24), t;
  }
  function Na(e4) {
    e4.millisecond = Math.max(0, Math.min(e4.millisecond, 1e3)), e4.second = Math.max(0, Math.min(e4.second, 59)), e4.minute = Math.max(0, Math.min(e4.minute, 59)), e4.hour = Math.max(0, Math.min(e4.hour, 23));
  }
  function qe4(e4, t) {
    let a3 = e4 % t;
    return a3 < 0 && (a3 += t), a3;
  }
  function Hr2(e4, t) {
    return e4.hour += t.hours || 0, e4.minute += t.minutes || 0, e4.second += t.seconds || 0, e4.millisecond += t.milliseconds || 0, Fr2(e4);
  }
  function Ze4(e4, t, a3, r3) {
    let n = e4.copy();
    switch (t) {
      case "era": {
        let i = e4.calendar.getEras(), u3 = i.indexOf(e4.era);
        if (u3 < 0) throw new Error("Invalid era: " + e4.era);
        u3 = z5(u3, a3, 0, i.length - 1, r3 == null ? void 0 : r3.round), n.era = i[u3], X7(n);
        break;
      }
      case "year":
        var o2, s;
        !((o2 = (s = n.calendar).isInverseEra) === null || o2 === void 0) && o2.call(s, n) && (a3 = -a3), n.year = z5(e4.year, a3, -1 / 0, 9999, r3 == null ? void 0 : r3.round), n.year === -1 / 0 && (n.year = 1), n.calendar.balanceYearMonth && n.calendar.balanceYearMonth(n, e4);
        break;
      case "month":
        n.month = z5(e4.month, a3, 1, e4.calendar.getMonthsInYear(e4), r3 == null ? void 0 : r3.round);
        break;
      case "day":
        n.day = z5(e4.day, a3, 1, e4.calendar.getDaysInMonth(e4), r3 == null ? void 0 : r3.round);
        break;
      default:
        throw new Error("Unsupported field " + t);
    }
    return e4.calendar.balanceDate && e4.calendar.balanceDate(n), X7(n), n;
  }
  function Ct4(e4, t, a3, r3) {
    let n = e4.copy();
    switch (t) {
      case "hour": {
        let o2 = e4.hour, s = 0, i = 23;
        if ((r3 == null ? void 0 : r3.hourCycle) === 12) {
          let u3 = o2 >= 12;
          s = u3 ? 12 : 0, i = u3 ? 23 : 11;
        }
        n.hour = z5(o2, a3, s, i, r3 == null ? void 0 : r3.round);
        break;
      }
      case "minute":
        n.minute = z5(e4.minute, a3, 0, 59, r3 == null ? void 0 : r3.round);
        break;
      case "second":
        n.second = z5(e4.second, a3, 0, 59, r3 == null ? void 0 : r3.round);
        break;
      case "millisecond":
        n.millisecond = z5(e4.millisecond, a3, 0, 999, r3 == null ? void 0 : r3.round);
        break;
      default:
        throw new Error("Unsupported field " + t);
    }
    return n;
  }
  function z5(e4, t, a3, r3, n = false) {
    if (n) {
      e4 += Math.sign(t), e4 < a3 && (e4 = r3);
      let o2 = Math.abs(t);
      t > 0 ? e4 = Math.ceil(e4 / o2) * o2 : e4 = Math.floor(e4 / o2) * o2, e4 > r3 && (e4 = a3);
    } else e4 += t, e4 < a3 ? e4 = r3 - (a3 - e4 - 1) : e4 > r3 && (e4 = a3 + (e4 - r3 - 1));
    return e4;
  }
  function Vt3(e4, t) {
    let a3;
    if (t.years != null && t.years !== 0 || t.months != null && t.months !== 0 || t.weeks != null && t.weeks !== 0 || t.days != null && t.days !== 0) {
      let n = Ve5(W9(e4), { years: t.years, months: t.months, weeks: t.weeks, days: t.days });
      a3 = B5(n, e4.timeZone);
    } else a3 = ae4(e4) - e4.offset;
    a3 += t.milliseconds || 0, a3 += (t.seconds || 0) * 1e3, a3 += (t.minutes || 0) * 6e4, a3 += (t.hours || 0) * 36e5;
    let r3 = A6(a3, e4.timeZone);
    return C8(r3, e4.calendar);
  }
  function Fa(e4, t) {
    return Vt3(e4, La(t));
  }
  function Ha(e4, t, a3, r3) {
    switch (t) {
      case "hour": {
        let n = 0, o2 = 23;
        if ((r3 == null ? void 0 : r3.hourCycle) === 12) {
          let v10 = e4.hour >= 12;
          n = v10 ? 12 : 0, o2 = v10 ? 23 : 11;
        }
        let s = W9(e4), i = C8(Ce3(s, { hour: n }), new Y8()), u3 = [B5(i, e4.timeZone, "earlier"), B5(i, e4.timeZone, "later")].filter((v10) => A6(v10, e4.timeZone).day === i.day)[0], p4 = C8(Ce3(s, { hour: o2 }), new Y8()), h6 = [B5(p4, e4.timeZone, "earlier"), B5(p4, e4.timeZone, "later")].filter((v10) => A6(v10, e4.timeZone).day === p4.day).pop(), f4 = ae4(e4) - e4.offset, m5 = Math.floor(f4 / Se4), $13 = f4 % Se4;
        return f4 = z5(m5, a3, Math.floor(u3 / Se4), Math.floor(h6 / Se4), r3 == null ? void 0 : r3.round) * Se4 + $13, C8(A6(f4, e4.timeZone), e4.calendar);
      }
      case "minute":
      case "second":
      case "millisecond":
        return Ct4(e4, t, a3, r3);
      case "era":
      case "year":
      case "month":
      case "day": {
        let n = Ze4(W9(e4), t, a3, r3), o2 = B5(n, e4.timeZone);
        return C8(A6(o2, e4.timeZone), e4.calendar);
      }
      default:
        throw new Error("Unsupported field " + t);
    }
  }
  function Ya(e4, t, a3) {
    let r3 = W9(e4), n = Ce3(Ue3(r3, t), t);
    if (n.compare(r3) === 0) return e4;
    let o2 = B5(n, e4.timeZone, a3);
    return C8(A6(o2, e4.timeZone), e4.calendar);
  }
  function Mt3(e4) {
    let t = e4.match(Yr2);
    if (!t) throw Br2.test(e4) ? new Error(`Invalid ISO 8601 date string: ${e4}. Use parseAbsolute() instead.`) : new Error("Invalid ISO 8601 date string: " + e4);
    let a3 = new O6(Pt3(t[1], 0, 9999), Pt3(t[2], 1, 12), 1);
    return a3.day = Pt3(t[3], 1, a3.calendar.getDaysInMonth(a3)), a3;
  }
  function Pt3(e4, t, a3) {
    let r3 = Number(e4);
    if (r3 < t || r3 > a3) throw new RangeError(`Value out of range: ${t} <= ${r3} <= ${a3}`);
    return r3;
  }
  function Ba(e4) {
    return `${String(e4.hour).padStart(2, "0")}:${String(e4.minute).padStart(2, "0")}:${String(e4.second).padStart(2, "0")}${e4.millisecond ? String(e4.millisecond / 1e3).slice(1) : ""}`;
  }
  function It4(e4) {
    let t = C8(e4, new Y8()), a3;
    return t.era === "BC" ? a3 = t.year === 1 ? "0000" : "-" + String(Math.abs(1 - t.year)).padStart(6, "00") : a3 = String(t.year).padStart(4, "0"), `${a3}-${String(t.month).padStart(2, "0")}-${String(t.day).padStart(2, "0")}`;
  }
  function Ot2(e4) {
    return `${It4(e4)}T${Ba(e4)}`;
  }
  function _r2(e4) {
    let t = Math.sign(e4) < 0 ? "-" : "+";
    e4 = Math.abs(e4);
    let a3 = Math.floor(e4 / 36e5), r3 = Math.floor(e4 % 36e5 / 6e4), n = Math.floor(e4 % 36e5 % 6e4 / 1e3), o2 = `${t}${String(a3).padStart(2, "0")}:${String(r3).padStart(2, "0")}`;
    return n !== 0 && (o2 += `:${String(n).padStart(2, "0")}`), o2;
  }
  function Wa(e4) {
    return `${Ot2(e4)}${_r2(e4.offset)}[${e4.timeZone}]`;
  }
  function _a(e4, t) {
    if (t.has(e4)) throw new TypeError("Cannot initialize the same private elements twice on an object");
  }
  function Ge4(e4, t, a3) {
    _a(e4, t), t.set(e4, a3);
  }
  function kt4(e4) {
    let t = typeof e4[0] == "object" ? e4.shift() : new Y8(), a3;
    if (typeof e4[0] == "string") a3 = e4.shift();
    else {
      let s = t.getEras();
      a3 = s[s.length - 1];
    }
    let r3 = e4.shift(), n = e4.shift(), o2 = e4.shift();
    return [t, a3, r3, n, o2];
  }
  function qa(e4, t = {}) {
    if (typeof t.hour12 == "boolean" && jr2()) {
      t = __spreadValues({}, t);
      let n = Gr2[String(t.hour12)][e4.split("-")[0]], o2 = t.hour12 ? "h12" : "h23";
      t.hourCycle = n != null ? n : o2, delete t.hour12;
    }
    let a3 = e4 + (t ? Object.entries(t).sort((n, o2) => n[0] < o2[0] ? -1 : 1).join() : "");
    if (Rt3.has(a3)) return Rt3.get(a3);
    let r3 = new Intl.DateTimeFormat(e4, t);
    return Rt3.set(a3, r3), r3;
  }
  function jr2() {
    return At4 == null && (At4 = new Intl.DateTimeFormat("en-US", { hour: "numeric", hour12: false }).format(new Date(2020, 2, 3, 0)) === "24"), At4;
  }
  function Kr2() {
    return Lt4 == null && (Lt4 = new Intl.DateTimeFormat("fr", { hour: "numeric", hour12: false }).resolvedOptions().hourCycle === "h12"), Lt4;
  }
  function Jr2(e4, t) {
    if (!t.timeStyle && !t.hour) return;
    e4 = e4.replace(/(-u-)?-nu-[a-zA-Z0-9]+/, ""), e4 += (e4.includes("-u-") ? "" : "-u") + "-nu-latn";
    let a3 = qa(e4, __spreadProps(__spreadValues({}, t), { timeZone: void 0 })), r3 = parseInt(a3.formatToParts(new Date(2020, 2, 3, 0)).find((o2) => o2.type === "hour").value, 10), n = parseInt(a3.formatToParts(new Date(2020, 2, 3, 23)).find((o2) => o2.type === "hour").value, 10);
    if (r3 === 0 && n === 23) return "h23";
    if (r3 === 24 && n === 23) return "h24";
    if (r3 === 0 && n === 11) return "h11";
    if (r3 === 12 && n === 11) return "h12";
    throw new Error("Unexpected hour cycle result");
  }
  function Qr2(e4, t, a3, r3, n) {
    let o2 = {};
    for (let i in t) {
      let u3 = i, p4 = t[u3];
      p4 != null && (o2[u3] = Math.floor(p4 / 2), o2[u3] > 0 && p4 % 2 === 0 && o2[u3]--);
    }
    let s = le5(e4, t, a3).subtract(o2);
    return Pe4(e4, s, t, a3, r3, n);
  }
  function le5(e4, t, a3, r3, n) {
    let o2 = e4;
    return t.years ? o2 = se4(e4) : t.months ? o2 = U6(e4) : t.weeks && (o2 = ie5(e4, a3)), Pe4(e4, o2, t, a3, r3, n);
  }
  function Nt3(e4, t, a3, r3, n) {
    let o2 = __spreadValues({}, t);
    o2.days ? o2.days-- : o2.weeks ? o2.weeks-- : o2.months ? o2.months-- : o2.years && o2.years--;
    let s = le5(e4, t, a3).subtract(o2);
    return Pe4(e4, s, t, a3, r3, n);
  }
  function Pe4(e4, t, a3, r3, n, o2) {
    return n && e4.compare(n) >= 0 && (t = _e4(t, le5(K11(n), a3, r3))), o2 && e4.compare(o2) <= 0 && (t = We4(t, Nt3(K11(o2), a3, r3))), t;
  }
  function _7(e4, t, a3) {
    let r3 = K11(e4);
    return t && (r3 = _e4(r3, K11(t))), a3 && (r3 = We4(r3, K11(a3))), r3;
  }
  function Ft3(e4, t, a3, r3, n, o2) {
    switch (t) {
      case "start":
        return le5(e4, a3, r3, n, o2);
      case "end":
        return Nt3(e4, a3, r3, n, o2);
      case "center":
      default:
        return Qr2(e4, a3, r3, n, o2);
    }
  }
  function k7(e4, t) {
    return e4 == null || t == null ? e4 === t : Q9(e4, t);
  }
  function Ht3(e4, t, a3, r3, n) {
    return e4 ? (t == null ? void 0 : t(e4, a3)) ? true : Z9(e4, r3, n) : false;
  }
  function Z9(e4, t, a3) {
    return t != null && e4.compare(t) < 0 || a3 != null && e4.compare(a3) > 0;
  }
  function Za(e4, t, a3) {
    let r3 = e4.subtract({ days: 1 });
    return Q9(r3, e4) || Z9(r3, t, a3);
  }
  function Ga(e4, t, a3) {
    let r3 = e4.add({ days: 1 });
    return Q9(r3, e4) || Z9(r3, t, a3);
  }
  function je4(e4) {
    let t = __spreadValues({}, e4);
    for (let a3 in t) t[a3] = 1;
    return t;
  }
  function Yt4(e4, t) {
    let a3 = __spreadValues({}, t);
    return a3.days ? a3.days-- : a3.days = -1, e4.add(a3);
  }
  function ja(e4) {
    return (e4 == null ? void 0 : e4.calendar.identifier) === "gregory" && e4.era === "BC" ? "short" : void 0;
  }
  function Bt4(e4, t) {
    let a3 = W9(he3(t));
    return new I9(e4, { weekday: "long", month: "long", year: "numeric", day: "numeric", era: ja(a3), timeZone: t });
  }
  function Wt3(e4, t) {
    let a3 = he3(t);
    return new I9(e4, { month: "long", year: "numeric", era: ja(a3), calendar: a3 == null ? void 0 : a3.calendar.identifier, timeZone: t });
  }
  function Xr2(e4, t, a3, r3, n) {
    let o2 = a3.formatRangeToParts(e4.toDate(n), t.toDate(n)), s = -1;
    for (let p4 = 0; p4 < o2.length; p4++) {
      let h6 = o2[p4];
      if (h6.source === "shared" && h6.type === "literal") s = p4;
      else if (h6.source === "endRange") break;
    }
    let i = "", u3 = "";
    for (let p4 = 0; p4 < o2.length; p4++) p4 < s ? i += o2[p4].value : p4 > s && (u3 += o2[p4].value);
    return r3(i, u3);
  }
  function Me3(e4, t, a3, r3) {
    if (!e4) return "";
    let n = e4, o2 = t != null ? t : e4, s = Bt4(a3, r3);
    return Q9(n, o2) ? s.format(n.toDate(r3)) : Xr2(n, o2, s, (i, u3) => `${i} \u2013 ${u3}`, r3);
  }
  function Ka(e4) {
    return e4 != null ? zr2[e4] : void 0;
  }
  function Ja(e4, t, a3) {
    let r3 = Ka(a3);
    return ie5(e4, t, r3);
  }
  function _t2(e4, t, a3, r3) {
    let n = t.add({ weeks: e4 }), o2 = [], s = Ja(n, a3, r3);
    for (; o2.length < 7; ) {
      o2.push(s);
      let i = s.add({ days: 1 });
      if (Q9(s, i)) break;
      s = i;
    }
    return o2;
  }
  function Qa(e4, t, a3, r3) {
    let n = Ka(r3), o2 = a3 != null ? a3 : yt4(e4, t, n);
    return [...new Array(o2).keys()].map((i) => _t2(i, e4, t, r3));
  }
  function en3(e4, t) {
    let a3 = new I9(e4, { weekday: "long", timeZone: t }), r3 = new I9(e4, { weekday: "short", timeZone: t }), n = new I9(e4, { weekday: "narrow", timeZone: t });
    return (o2) => {
      let s = o2 instanceof Date ? o2 : o2.toDate(t);
      return { value: o2, short: r3.format(s), long: a3.format(s), narrow: n.format(s) };
    };
  }
  function Xa(e4, t, a3, r3) {
    let n = Ja(e4, r3, t), o2 = [...new Array(7).keys()], s = en3(r3, a3);
    return o2.map((i) => s(n.add({ days: i })));
  }
  function za(e4, t = "long") {
    let a3 = new Date(2021, 0, 1), r3 = [];
    for (let n = 0; n < 12; n++) r3.push(a3.toLocaleString(e4, { month: t })), a3.setMonth(a3.getMonth() + 1);
    return r3;
  }
  function er2(e4) {
    let t = [];
    for (let a3 = e4.from; a3 <= e4.to; a3 += 1) t.push(a3);
    return t;
  }
  function an3(e4) {
    if (e4) {
      if (e4.length === 3) return e4.padEnd(4, "0");
      if (e4.length === 2) {
        let t = (/* @__PURE__ */ new Date()).getFullYear(), a3 = Math.floor(t / 100) * 100, r3 = parseInt(e4.slice(-2), 10), n = a3 + r3;
        return n > t + tn3 ? (n - 100).toString() : n.toString();
      }
      return e4;
    }
  }
  function de4(e4, t) {
    let a3 = (t == null ? void 0 : t.strict) ? 10 : 12, r3 = e4 - e4 % 10, n = [];
    for (let o2 = 0; o2 < a3; o2 += 1) {
      let s = r3 + o2;
      n.push(s);
    }
    return n;
  }
  function ue4(e4) {
    return he3(e4 != null ? e4 : pe5());
  }
  function $e4(e4, t, a3, r3) {
    return function(o2) {
      let { startDate: s, focusedDate: i } = o2, u3 = Yt4(s, e4);
      return Z9(i, a3, r3) ? { startDate: s, focusedDate: _7(i, a3, r3), endDate: u3 } : i.compare(s) < 0 ? { startDate: Nt3(i, e4, t, a3, r3), focusedDate: _7(i, a3, r3), endDate: u3 } : i.compare(u3) > 0 ? { startDate: le5(i, e4, t, a3, r3), endDate: u3, focusedDate: _7(i, a3, r3) } : { startDate: s, endDate: u3, focusedDate: _7(i, a3, r3) };
    };
  }
  function qt3(e4, t, a3, r3, n, o2) {
    let s = $e4(a3, r3, n, o2), i = t.add(a3);
    return s({ focusedDate: e4.add(a3), startDate: le5(Pe4(e4, i, a3, r3, n, o2), a3, r3) });
  }
  function Ut3(e4, t, a3, r3, n, o2) {
    let s = $e4(a3, r3, n, o2), i = t.subtract(a3);
    return s({ focusedDate: e4.subtract(a3), startDate: le5(Pe4(e4, i, a3, r3, n, o2), a3, r3) });
  }
  function tr2(e4, t, a3, r3, n, o2, s) {
    let i = $e4(r3, n, o2, s);
    if (!a3 && !r3.days) return i({ focusedDate: e4.add(je4(r3)), startDate: t });
    if (r3.days) return qt3(e4, t, r3, n, o2, s);
    if (r3.weeks) return i({ focusedDate: e4.add({ months: 1 }), startDate: t });
    if (r3.months || r3.years) return i({ focusedDate: e4.add({ years: 1 }), startDate: t });
  }
  function ar2(e4, t, a3, r3, n, o2, s) {
    let i = $e4(r3, n, o2, s);
    if (!a3 && !r3.days) return i({ focusedDate: e4.subtract(je4(r3)), startDate: t });
    if (r3.days) return Ut3(e4, t, r3, n, o2, s);
    if (r3.weeks) return i({ focusedDate: e4.subtract({ months: 1 }), startDate: t });
    if (r3.months || r3.years) return i({ focusedDate: e4.subtract({ years: 1 }), startDate: t });
  }
  function rr2(e4, t, a3) {
    var _a2;
    let r3 = on3(t, a3), { year: n, month: o2, day: s } = (_a2 = sn3(r3, e4)) != null ? _a2 : {};
    if (n != null || o2 != null || s != null) {
      let p4 = /* @__PURE__ */ new Date();
      n || (n = p4.getFullYear().toString()), o2 || (o2 = (p4.getMonth() + 1).toString()), s || (s = p4.getDate().toString());
    }
    if (Ua(n) || (n = an3(n)), Ua(n) && rn3(o2) && nn3(s)) return new O6(+n, +o2, +s);
    let u3 = Date.parse(e4);
    if (!isNaN(u3)) {
      let p4 = new Date(u3);
      return new O6(p4.getFullYear(), p4.getMonth() + 1, p4.getDate());
    }
  }
  function on3(e4, t) {
    return new I9(e4, { day: "numeric", month: "numeric", year: "numeric", timeZone: t }).formatToParts(new Date(2e3, 11, 25)).map(({ type: n, value: o2 }) => n === "literal" ? `${o2}?` : `((?!=<${n}>)\\d+)?`).join("");
  }
  function sn3(e4, t) {
    var _a2;
    let a3 = t.match(e4);
    return (_a2 = e4.toString().match(/<(.+?)>/g)) == null ? void 0 : _a2.map((r3) => {
      var _a3;
      let n = r3.match(/<(.+)>/);
      return !n || n.length <= 0 ? null : (_a3 = r3.match(/<(.+)>/)) == null ? void 0 : _a3[1];
    }).reduce((r3, n, o2) => (n && (a3 && a3.length > o2 ? r3[n] = a3[o2 + 1] : r3[n] = null), r3), {});
  }
  function Zt3(e4, t, a3) {
    let r3 = K11(Ye4(a3));
    switch (e4) {
      case "thisWeek":
        return [ie5(r3, t), Be4(r3, t)];
      case "thisMonth":
        return [U6(r3), r3];
      case "thisQuarter":
        return [U6(r3).add({ months: -((r3.month - 1) % 3) }), r3];
      case "thisYear":
        return [se4(r3), r3];
      case "last3Days":
        return [r3.add({ days: -2 }), r3];
      case "last7Days":
        return [r3.add({ days: -6 }), r3];
      case "last14Days":
        return [r3.add({ days: -13 }), r3];
      case "last30Days":
        return [r3.add({ days: -29 }), r3];
      case "last90Days":
        return [r3.add({ days: -89 }), r3];
      case "lastMonth":
        return [U6(r3.add({ months: -1 })), Ee3(r3.add({ months: -1 }))];
      case "lastQuarter":
        return [U6(r3.add({ months: -((r3.month - 1) % 3) - 3 })), Ee3(r3.add({ months: -((r3.month - 1) % 3) - 1 }))];
      case "lastWeek":
        return [ie5(r3, t).add({ weeks: -1 }), Be4(r3, t).add({ weeks: -1 })];
      case "lastYear":
        return [se4(r3.add({ years: -1 })), $t3(r3.add({ years: -1 }))];
      default:
        throw new Error(`Invalid date range preset: ${e4}`);
    }
  }
  function nr2(e4 = {}) {
    var _a2;
    let { level: t = "polite", document: a3 = document, root: r3, delay: n = 0 } = e4, o2 = (_a2 = a3.defaultView) != null ? _a2 : window, s = r3 != null ? r3 : a3.body;
    function i(p4, h6) {
      var _a3;
      (_a3 = a3.getElementById(Ke4)) == null ? void 0 : _a3.remove(), h6 = h6 != null ? h6 : n;
      let m5 = a3.createElement("span");
      m5.id = Ke4, m5.dataset.liveAnnouncer = "true";
      let $13 = t !== "assertive" ? "status" : "alert";
      m5.setAttribute("aria-live", t), m5.setAttribute("role", $13), Object.assign(m5.style, { border: "0", clip: "rect(0 0 0 0)", height: "1px", margin: "-1px", overflow: "hidden", padding: "0", position: "absolute", width: "1px", whiteSpace: "nowrap", wordWrap: "normal" }), s.appendChild(m5), o2.setTimeout(() => {
        m5.textContent = p4;
      }, h6);
    }
    function u3() {
      var _a3;
      (_a3 = a3.getElementById(Ke4)) == null ? void 0 : _a3.remove();
    }
    return { announce: i, destroy: u3, toJSON() {
      return Ke4;
    } };
  }
  function Kt3(e4) {
    let [t, a3] = e4, r3;
    return !t || !a3 ? r3 = e4 : r3 = t.compare(a3) <= 0 ? e4 : [a3, t], r3;
  }
  function ye4(e4, t) {
    let [a3, r3] = t;
    return !a3 || !r3 ? false : a3.compare(e4) <= 0 && r3.compare(e4) >= 0;
  }
  function Je4(e4) {
    return e4.slice().filter((t) => t != null).sort((t, a3) => t.compare(a3));
  }
  function vn2(e4) {
    return rr(e4, { year: "calendar decade", month: "calendar year", day: "calendar month" });
  }
  function wn2(e4) {
    return new I9(e4).formatToParts(/* @__PURE__ */ new Date()).map((t) => {
      var _a2;
      return (_a2 = bn2[t.type]) != null ? _a2 : t.value;
    }).join("");
  }
  function Dn3(e4) {
    let r3 = new Intl.DateTimeFormat(e4).formatToParts(/* @__PURE__ */ new Date()).find((n) => n.type === "literal");
    return r3 ? r3.value : "/";
  }
  function ee5(e4, t) {
    return e4 ? e4 === "day" ? 0 : e4 === "month" ? 1 : 2 : t || 0;
  }
  function Jt4(e4) {
    return e4 === 0 ? "day" : e4 === 1 ? "month" : "year";
  }
  function Qt3(e4, t, a3) {
    return Jt4(ts(ee5(e4, 0), ee5(t, 0), ee5(a3, 2)));
  }
  function En2(e4, t) {
    return ee5(e4, 0) > ee5(t, 0);
  }
  function Sn2(e4, t) {
    return ee5(e4, 0) < ee5(t, 0);
  }
  function Cn2(e4, t, a3) {
    let r3 = ee5(e4, 0) + 1;
    return Qt3(Jt4(r3), t, a3);
  }
  function Vn2(e4, t, a3) {
    let r3 = ee5(e4, 0) - 1;
    return Qt3(Jt4(r3), t, a3);
  }
  function Mn3(e4) {
    Pn2.forEach((t) => e4(t));
  }
  function $r2(e4, t) {
    let { state: a3, context: r3, prop: n, send: o2, computed: s, scope: i } = e4, u3 = r3.get("startValue"), p4 = s("endValue"), h6 = r3.get("value"), f4 = r3.get("focusedValue"), m5 = r3.get("hoveredValue"), $13 = m5 ? Kt3([h6[0], m5]) : [], v10 = !!n("disabled"), S13 = !!n("readOnly"), N10 = !!n("invalid"), ve8 = s("isInteractive"), Oe10 = h6.length === 0, F10 = n("min"), H12 = n("max"), P11 = n("locale"), x14 = n("timeZone"), at8 = n("startOfWeek"), br2 = a3.matches("focused"), te10 = a3.matches("open"), J15 = n("selectionMode") === "range", Xt5 = n("isDateUnavailable"), rt9 = r3.get("currentPlacement"), wr2 = $n2(__spreadProps(__spreadValues({}, n("positioning")), { placement: rt9 })), zt3 = Dn3(P11), G14 = __spreadValues(__spreadValues({}, xn2), n("translations"));
    function nt8(l4 = u3) {
      let c5 = n("fixedWeeks") ? 6 : void 0;
      return Qa(l4, P11, c5, at8);
    }
    function ea(l4 = {}) {
      let { format: c5 } = l4;
      return za(P11, c5).map((d4, g7) => {
        let T7 = g7 + 1, R7 = f4.set({ month: T7 }), V16 = Z9(R7, F10, H12);
        return { label: d4, value: T7, disabled: V16 };
      });
    }
    function Tr2() {
      var _a2, _b;
      return er2({ from: (_a2 = F10 == null ? void 0 : F10.year) != null ? _a2 : 1900, to: (_b = H12 == null ? void 0 : H12.year) != null ? _b : 2100 }).map((c5) => ({ label: c5.toString(), value: c5, disabled: !Qo(c5, F10 == null ? void 0 : F10.year, H12 == null ? void 0 : H12.year) }));
    }
    function ot7(l4) {
      return Ht3(l4, Xt5, P11, F10, H12);
    }
    function ta(l4) {
      let c5 = u3 != null ? u3 : ue4(x14);
      o2({ type: "FOCUS.SET", value: c5.set({ month: l4 }) });
    }
    function aa(l4) {
      let c5 = u3 != null ? u3 : ue4(x14);
      o2({ type: "FOCUS.SET", value: c5.set({ year: l4 }) });
    }
    function ke11(l4) {
      let { value: c5, disabled: d4 } = l4, g7 = f4.set({ year: c5 }), R7 = !de4(u3.year, { strict: true }).includes(c5), V16 = Qo(c5, F10 == null ? void 0 : F10.year, H12 == null ? void 0 : H12.year), j12 = { focused: f4.year === l4.value, selectable: R7 || V16, outsideRange: R7, selected: !!h6.find((be10) => be10 && be10.year === c5), valueText: c5.toString(), inRange: J15 && (ye4(g7, h6) || ye4(g7, $13)), value: g7, get disabled() {
        return d4 || !j12.selectable;
      } };
      return j12;
    }
    function Re9(l4) {
      let { value: c5, disabled: d4 } = l4, g7 = f4.set({ month: c5 }), T7 = Wt3(P11, x14), R7 = { focused: f4.month === l4.value, selectable: !Z9(g7, F10, H12), selected: !!h6.find((V16) => V16 && V16.month === c5 && V16.year === f4.year), valueText: T7.format(g7.toDate(x14)), inRange: J15 && (ye4(g7, h6) || ye4(g7, $13)), value: g7, get disabled() {
        return d4 || !R7.selectable;
      } };
      return R7;
    }
    function st8(l4) {
      let { value: c5, disabled: d4, visibleRange: g7 = s("visibleRange") } = l4, T7 = Bt4(P11, x14), R7 = je4(s("visibleDuration")), V16 = n("outsideDaySelectable"), j12 = g7.start.add(R7).subtract({ days: 1 }), be10 = Z9(c5, g7.start, j12), xr2 = J15 && ye4(c5, h6), Er2 = J15 && k7(c5, h6[0]), Sr2 = J15 && k7(c5, h6[1]), it8 = J15 && $13.length > 0, ra = it8 && ye4(c5, $13), Cr2 = it8 && k7(c5, $13[0]), Vr = it8 && k7(c5, $13[1]), we8 = { invalid: Z9(c5, F10, H12), disabled: d4 || !V16 && be10 || Z9(c5, F10, H12), selected: h6.some((Pr2) => k7(c5, Pr2)), unavailable: Ht3(c5, Xt5, P11, F10, H12) && !d4, outsideRange: be10, today: ht5(c5, x14), weekend: vt4(c5, P11), formattedDate: T7.format(c5.toDate(x14)), get focused() {
        return k7(c5, f4) && (!we8.outsideRange || V16);
      }, get ariaLabel() {
        return G14.dayCell(we8);
      }, get selectable() {
        return !we8.disabled && !we8.unavailable;
      }, inRange: xr2 || ra, firstInRange: Er2, lastInRange: Sr2, inHoveredRange: ra, firstInHoveredRange: Cr2, lastInHoveredRange: Vr };
      return we8;
    }
    function Dr(l4) {
      let { view: c5 = "day", id: d4 } = l4;
      return [c5, d4].filter(Boolean).join(" ");
    }
    return { focused: br2, open: te10, disabled: v10, invalid: N10, readOnly: S13, inline: !!n("inline"), numOfMonths: n("numOfMonths"), selectionMode: n("selectionMode"), view: r3.get("view"), getRangePresetValue(l4) {
      return Zt3(l4, P11, x14);
    }, getDaysInWeek(l4, c5 = u3) {
      return _t2(l4, c5, P11, at8);
    }, getOffset(l4) {
      let c5 = u3.add(l4), d4 = p4.add(l4), g7 = Wt3(P11, x14);
      return { visibleRange: { start: c5, end: d4 }, weeks: nt8(c5), visibleRangeText: { start: g7.format(c5.toDate(x14)), end: g7.format(d4.toDate(x14)) } };
    }, getMonthWeeks: nt8, isUnavailable: ot7, weeks: nt8(), weekDays: Xa(ue4(x14), at8, x14, P11), visibleRangeText: s("visibleRangeText"), value: h6, valueAsDate: h6.filter((l4) => l4 != null).map((l4) => l4.toDate(x14)), valueAsString: s("valueAsString"), focusedValue: f4, focusedValueAsDate: f4 == null ? void 0 : f4.toDate(x14), focusedValueAsString: n("format")(f4, { locale: P11, timeZone: x14 }), visibleRange: s("visibleRange"), selectToday() {
      let l4 = _7(ue4(x14), F10, H12);
      o2({ type: "VALUE.SET", value: l4 });
    }, setValue(l4) {
      let c5 = l4.map((d4) => _7(d4, F10, H12));
      o2({ type: "VALUE.SET", value: c5 });
    }, clearValue() {
      o2({ type: "VALUE.CLEAR" });
    }, setFocusedValue(l4) {
      o2({ type: "FOCUS.SET", value: l4 });
    }, setOpen(l4) {
      n("inline") || a3.matches("open") === l4 || o2({ type: l4 ? "OPEN" : "CLOSE" });
    }, focusMonth: ta, focusYear: aa, getYears: Tr2, getMonths: ea, getYearsGrid(l4 = {}) {
      let { columns: c5 = 1 } = l4, d4 = de4(u3.year, { strict: true }).map((g7) => ({ label: g7.toString(), value: g7, disabled: !Qo(g7, F10 == null ? void 0 : F10.year, H12 == null ? void 0 : H12.year) }));
      return Bo(d4, c5);
    }, getDecade() {
      let l4 = de4(u3.year, { strict: true });
      return { start: l4.at(0), end: l4.at(-1) };
    }, getMonthsGrid(l4 = {}) {
      let { columns: c5 = 1, format: d4 } = l4;
      return Bo(ea({ format: d4 }), c5);
    }, format(l4, c5 = { month: "long", year: "numeric" }) {
      return new I9(P11, c5).format(l4.toDate(x14));
    }, setView(l4) {
      o2({ type: "VIEW.SET", view: l4 });
    }, goToNext() {
      o2({ type: "GOTO.NEXT", view: r3.get("view") });
    }, goToPrev() {
      o2({ type: "GOTO.PREV", view: r3.get("view") });
    }, getRootProps() {
      return t.element(__spreadProps(__spreadValues({}, w7.root.attrs), { dir: n("dir"), id: dn3(i), "data-state": te10 ? "open" : "closed", "data-disabled": jr(v10), "data-readonly": jr(S13), "data-empty": jr(Oe10) }));
    }, getLabelProps(l4 = {}) {
      let { index: c5 = 0 } = l4;
      return t.label(__spreadProps(__spreadValues({}, w7.label.attrs), { id: ln3(i, c5), dir: n("dir"), htmlFor: or2(i, c5), "data-state": te10 ? "open" : "closed", "data-index": c5, "data-disabled": jr(v10), "data-readonly": jr(S13) }));
    }, getControlProps() {
      return t.element(__spreadProps(__spreadValues({}, w7.control.attrs), { dir: n("dir"), id: dr2(i), "data-disabled": jr(v10), "data-placeholder-shown": jr(Oe10) }));
    }, getRangeTextProps() {
      return t.element(__spreadProps(__spreadValues({}, w7.rangeText.attrs), { dir: n("dir") }));
    }, getContentProps() {
      return t.element(__spreadProps(__spreadValues({}, w7.content.attrs), { hidden: !te10, dir: n("dir"), "data-state": te10 ? "open" : "closed", "data-placement": rt9, "data-inline": jr(n("inline")), id: jt3(i), tabIndex: -1, role: "application", "aria-roledescription": "datepicker", "aria-label": G14.content }));
    }, getTableProps(l4 = {}) {
      let { view: c5 = "day", columns: d4 = c5 === "day" ? 7 : 4 } = l4, g7 = Dr(l4);
      return t.element(__spreadProps(__spreadValues({}, w7.table.attrs), { role: "grid", "data-columns": d4, "aria-roledescription": vn2(c5), id: un3(i, g7), "aria-readonly": Br(S13), "aria-disabled": Br(v10), "aria-multiselectable": Br(n("selectionMode") !== "single"), "data-view": c5, dir: n("dir"), tabIndex: -1, onKeyDown(T7) {
        if (T7.defaultPrevented) return;
        let V16 = { Enter() {
          c5 === "day" && ot7(f4) || c5 === "month" && !Re9({ value: f4.month }).selectable || c5 === "year" && !ke11({ value: f4.year }).selectable || o2({ type: "TABLE.ENTER", view: c5, columns: d4, focus: true });
        }, ArrowLeft() {
          o2({ type: "TABLE.ARROW_LEFT", view: c5, columns: d4, focus: true });
        }, ArrowRight() {
          o2({ type: "TABLE.ARROW_RIGHT", view: c5, columns: d4, focus: true });
        }, ArrowUp() {
          o2({ type: "TABLE.ARROW_UP", view: c5, columns: d4, focus: true });
        }, ArrowDown() {
          o2({ type: "TABLE.ARROW_DOWN", view: c5, columns: d4, focus: true });
        }, PageUp(j12) {
          o2({ type: "TABLE.PAGE_UP", larger: j12.shiftKey, view: c5, columns: d4, focus: true });
        }, PageDown(j12) {
          o2({ type: "TABLE.PAGE_DOWN", larger: j12.shiftKey, view: c5, columns: d4, focus: true });
        }, Home() {
          o2({ type: "TABLE.HOME", view: c5, columns: d4, focus: true });
        }, End() {
          o2({ type: "TABLE.END", view: c5, columns: d4, focus: true });
        } }[io(T7, { dir: n("dir") })];
        V16 && (V16(T7), T7.preventDefault(), T7.stopPropagation());
      }, onPointerLeave() {
        o2({ type: "TABLE.POINTER_LEAVE" });
      }, onPointerDown() {
        o2({ type: "TABLE.POINTER_DOWN", view: c5 });
      }, onPointerUp() {
        o2({ type: "TABLE.POINTER_UP", view: c5 });
      } }));
    }, getTableHeadProps(l4 = {}) {
      let { view: c5 = "day" } = l4;
      return t.element(__spreadProps(__spreadValues({}, w7.tableHead.attrs), { "aria-hidden": true, dir: n("dir"), "data-view": c5, "data-disabled": jr(v10) }));
    }, getTableHeaderProps(l4 = {}) {
      let { view: c5 = "day" } = l4;
      return t.element(__spreadProps(__spreadValues({}, w7.tableHeader.attrs), { dir: n("dir"), "data-view": c5, "data-disabled": jr(v10) }));
    }, getTableBodyProps(l4 = {}) {
      let { view: c5 = "day" } = l4;
      return t.element(__spreadProps(__spreadValues({}, w7.tableBody.attrs), { "data-view": c5, "data-disabled": jr(v10) }));
    }, getTableRowProps(l4 = {}) {
      let { view: c5 = "day" } = l4;
      return t.element(__spreadProps(__spreadValues({}, w7.tableRow.attrs), { "aria-disabled": Br(v10), "data-disabled": jr(v10), "data-view": c5 }));
    }, getDayTableCellState: st8, getDayTableCellProps(l4) {
      let { value: c5 } = l4, d4 = st8(l4);
      return t.element(__spreadProps(__spreadValues({}, w7.tableCell.attrs), { role: "gridcell", "aria-disabled": Br(!d4.selectable), "aria-selected": d4.selected || d4.inRange, "aria-invalid": Br(d4.invalid), "aria-current": d4.today ? "date" : void 0, "data-value": c5.toString() }));
    }, getDayTableCellTriggerProps(l4) {
      let { value: c5 } = l4, d4 = st8(l4);
      return t.element(__spreadProps(__spreadValues({}, w7.tableCellTrigger.attrs), { id: Gt4(i, c5.toString()), role: "button", dir: n("dir"), tabIndex: d4.focused ? 0 : -1, "aria-label": d4.ariaLabel, "aria-disabled": Br(!d4.selectable), "aria-invalid": Br(d4.invalid), "data-disabled": jr(!d4.selectable), "data-selected": jr(d4.selected), "data-value": c5.toString(), "data-view": "day", "data-today": jr(d4.today), "data-focus": jr(d4.focused), "data-unavailable": jr(d4.unavailable), "data-range-start": jr(d4.firstInRange), "data-range-end": jr(d4.lastInRange), "data-in-range": jr(d4.inRange), "data-outside-range": jr(d4.outsideRange), "data-weekend": jr(d4.weekend), "data-in-hover-range": jr(d4.inHoveredRange), "data-hover-range-start": jr(d4.firstInHoveredRange), "data-hover-range-end": jr(d4.lastInHoveredRange), onClick(g7) {
        g7.defaultPrevented || d4.selectable && o2({ type: "CELL.CLICK", cell: "day", value: c5 });
      }, onPointerMove: J15 ? (g7) => {
        if (g7.pointerType === "touch" || !d4.selectable) return;
        let T7 = !i.isActiveElement(g7.currentTarget);
        m5 && ut6(c5, m5) || o2({ type: "CELL.POINTER_MOVE", cell: "day", value: c5, focus: T7 });
      } : void 0 }));
    }, getMonthTableCellState: Re9, getMonthTableCellProps(l4) {
      let { value: c5, columns: d4 } = l4, g7 = Re9(l4);
      return t.element(__spreadProps(__spreadValues({}, w7.tableCell.attrs), { dir: n("dir"), colSpan: d4, role: "gridcell", "aria-selected": Br(g7.selected || g7.inRange), "data-selected": jr(g7.selected), "aria-disabled": Br(!g7.selectable), "data-value": c5 }));
    }, getMonthTableCellTriggerProps(l4) {
      let { value: c5 } = l4, d4 = Re9(l4);
      return t.element(__spreadProps(__spreadValues({}, w7.tableCellTrigger.attrs), { dir: n("dir"), role: "button", id: Gt4(i, c5.toString()), "data-selected": jr(d4.selected), "aria-disabled": Br(!d4.selectable), "data-disabled": jr(!d4.selectable), "data-focus": jr(d4.focused), "data-in-range": jr(d4.inRange), "data-outside-range": jr(d4.outsideRange), "aria-label": d4.valueText, "data-view": "month", "data-value": c5, tabIndex: d4.focused ? 0 : -1, onClick(g7) {
        g7.defaultPrevented || d4.selectable && o2({ type: "CELL.CLICK", cell: "month", value: c5 });
      }, onPointerMove: J15 ? (g7) => {
        if (g7.pointerType === "touch" || !d4.selectable) return;
        let T7 = !i.isActiveElement(g7.currentTarget);
        m5 && d4.value && ft4(d4.value, m5) || o2({ type: "CELL.POINTER_MOVE", cell: "month", value: d4.value, focus: T7 });
      } : void 0 }));
    }, getYearTableCellState: ke11, getYearTableCellProps(l4) {
      let { value: c5, columns: d4 } = l4, g7 = ke11(l4);
      return t.element(__spreadProps(__spreadValues({}, w7.tableCell.attrs), { dir: n("dir"), colSpan: d4, role: "gridcell", "aria-selected": Br(g7.selected), "data-selected": jr(g7.selected), "aria-disabled": Br(!g7.selectable), "data-value": c5 }));
    }, getYearTableCellTriggerProps(l4) {
      let { value: c5 } = l4, d4 = ke11(l4);
      return t.element(__spreadProps(__spreadValues({}, w7.tableCellTrigger.attrs), { dir: n("dir"), role: "button", id: Gt4(i, c5.toString()), "data-selected": jr(d4.selected), "data-focus": jr(d4.focused), "data-in-range": jr(d4.inRange), "aria-disabled": Br(!d4.selectable), "data-disabled": jr(!d4.selectable), "aria-label": d4.valueText, "data-outside-range": jr(d4.outsideRange), "data-value": c5, "data-view": "year", tabIndex: d4.focused ? 0 : -1, onClick(g7) {
        g7.defaultPrevented || d4.selectable && o2({ type: "CELL.CLICK", cell: "year", value: c5 });
      }, onPointerMove: J15 ? (g7) => {
        if (g7.pointerType === "touch" || !d4.selectable) return;
        let T7 = !i.isActiveElement(g7.currentTarget);
        m5 && d4.value && gt3(d4.value, m5) || o2({ type: "CELL.POINTER_MOVE", cell: "year", value: d4.value, focus: T7 });
      } : void 0 }));
    }, getNextTriggerProps(l4 = {}) {
      let { view: c5 = "day" } = l4, d4 = v10 || !s("isNextVisibleRangeValid");
      return t.button(__spreadProps(__spreadValues({}, w7.nextTrigger.attrs), { dir: n("dir"), id: gn3(i, c5), type: "button", "aria-label": G14.nextTrigger(c5), disabled: d4, "data-disabled": jr(d4), onClick(g7) {
        g7.defaultPrevented || o2({ type: "GOTO.NEXT", view: c5 });
      } }));
    }, getPrevTriggerProps(l4 = {}) {
      let { view: c5 = "day" } = l4, d4 = v10 || !s("isPrevVisibleRangeValid");
      return t.button(__spreadProps(__spreadValues({}, w7.prevTrigger.attrs), { dir: n("dir"), id: fn3(i, c5), type: "button", "aria-label": G14.prevTrigger(c5), disabled: d4, "data-disabled": jr(d4), onClick(g7) {
        g7.defaultPrevented || o2({ type: "GOTO.PREV", view: c5 });
      } }));
    }, getClearTriggerProps() {
      return t.button(__spreadProps(__spreadValues({}, w7.clearTrigger.attrs), { id: lr2(i), dir: n("dir"), type: "button", "aria-label": G14.clearTrigger, hidden: !h6.length, onClick(l4) {
        l4.defaultPrevented || o2({ type: "VALUE.CLEAR" });
      } }));
    }, getTriggerProps() {
      return t.button(__spreadProps(__spreadValues({}, w7.trigger.attrs), { id: ur2(i), dir: n("dir"), type: "button", "data-placement": rt9, "aria-label": G14.trigger(te10), "aria-controls": jt3(i), "data-state": te10 ? "open" : "closed", "data-placeholder-shown": jr(Oe10), "aria-haspopup": "grid", disabled: v10, onClick(l4) {
        l4.defaultPrevented || ve8 && o2({ type: "TRIGGER.CLICK" });
      } }));
    }, getViewProps(l4 = {}) {
      let { view: c5 = "day" } = l4;
      return t.element(__spreadProps(__spreadValues({}, w7.view.attrs), { "data-view": c5, hidden: r3.get("view") !== c5 }));
    }, getViewTriggerProps(l4 = {}) {
      let { view: c5 = "day" } = l4;
      return t.button(__spreadProps(__spreadValues({}, w7.viewTrigger.attrs), { "data-view": c5, dir: n("dir"), id: hn3(i, c5), type: "button", disabled: v10, "aria-label": G14.viewTrigger(c5), onClick(d4) {
        d4.defaultPrevented || ve8 && o2({ type: "VIEW.TOGGLE", src: "viewTrigger" });
      } }));
    }, getViewControlProps(l4 = {}) {
      let { view: c5 = "day" } = l4;
      return t.element(__spreadProps(__spreadValues({}, w7.viewControl.attrs), { "data-view": c5, dir: n("dir") }));
    }, getInputProps(l4 = {}) {
      let { index: c5 = 0, fixOnBlur: d4 = true } = l4;
      return t.input(__spreadProps(__spreadValues({}, w7.input.attrs), { id: or2(i, c5), autoComplete: "off", autoCorrect: "off", spellCheck: "false", dir: n("dir"), name: n("name"), "data-index": c5, "data-state": te10 ? "open" : "closed", "data-placeholder-shown": jr(Oe10), readOnly: S13, disabled: v10, required: n("required"), "aria-invalid": Br(N10), "data-invalid": jr(N10), placeholder: n("placeholder") || wn2(P11), defaultValue: s("valueAsString")[c5], onBeforeInput(g7) {
        let { data: T7 } = en(g7);
        mr2(T7, zt3) || g7.preventDefault();
      }, onFocus() {
        o2({ type: "INPUT.FOCUS", index: c5 });
      }, onBlur(g7) {
        let T7 = g7.currentTarget.value.trim();
        o2({ type: "INPUT.BLUR", value: T7, index: c5, fixOnBlur: d4 });
      }, onKeyDown(g7) {
        if (g7.defaultPrevented || !ve8) return;
        let R7 = { Enter(V16) {
          to(V16) || ot7(f4) || V16.currentTarget.value.trim() !== "" && o2({ type: "INPUT.ENTER", value: V16.currentTarget.value, index: c5 });
        } }[g7.key];
        R7 && (R7(g7), g7.preventDefault());
      }, onInput(g7) {
        let T7 = g7.currentTarget.value;
        o2({ type: "INPUT.CHANGE", value: Tn2(T7, zt3), index: c5 });
      } }));
    }, getMonthSelectProps() {
      return t.select(__spreadProps(__spreadValues({}, w7.monthSelect.attrs), { id: gr2(i), "aria-label": G14.monthSelect, disabled: v10, dir: n("dir"), defaultValue: u3.month, onChange(l4) {
        ta(Number(l4.currentTarget.value));
      } }));
    }, getYearSelectProps() {
      return t.select(__spreadProps(__spreadValues({}, w7.yearSelect.attrs), { id: hr2(i), disabled: v10, "aria-label": G14.yearSelect, dir: n("dir"), defaultValue: u3.year, onChange(l4) {
        aa(Number(l4.currentTarget.value));
      } }));
    }, getPositionerProps() {
      return t.element(__spreadProps(__spreadValues({ id: fr2(i) }, w7.positioner.attrs), { dir: n("dir"), style: wr2.floating }));
    }, getPresetTriggerProps(l4) {
      let c5 = Array.isArray(l4.value) ? l4.value : Zt3(l4.value, P11, x14), d4 = c5.filter((g7) => g7 != null).map((g7) => g7.toDate(x14).toDateString());
      return t.button(__spreadProps(__spreadValues({}, w7.presetTrigger.attrs), { "aria-label": G14.presetTrigger(d4), type: "button", onClick(g7) {
        g7.defaultPrevented || o2({ type: "PRESET.CLICK", value: c5 });
      } }));
    } };
  }
  function On2(e4, t) {
    if ((e4 == null ? void 0 : e4.length) !== (t == null ? void 0 : t.length)) return false;
    let a3 = Math.max(e4.length, t.length);
    for (let r3 = 0; r3 < a3; r3++) if (!k7(e4[r3], t[r3])) return false;
    return true;
  }
  function Qe4(e4, t) {
    return e4.map((a3) => a3 == null ? "" : t("format")(a3, { locale: t("locale"), timeZone: t("timeZone") }));
  }
  function D6(e4, t) {
    let { context: a3, prop: r3, computed: n } = e4;
    if (!t) return;
    let o2 = et5(e4, t);
    if (k7(a3.get("focusedValue"), o2)) return;
    let i = $e4(n("visibleDuration"), r3("locale"), r3("min"), r3("max"))({ focusedDate: o2, startDate: a3.get("startValue") });
    a3.set("startValue", i.startDate), a3.set("focusedValue", i.focusedDate);
  }
  function Xe4(e4, t) {
    let { context: a3 } = e4;
    a3.set("startValue", t.startDate);
    let r3 = a3.get("focusedValue");
    k7(r3, t.focusedDate) || a3.set("focusedValue", t.focusedDate);
  }
  function L7(e4) {
    return Array.isArray(e4) ? e4.map((t) => L7(t)) : e4 instanceof Date ? new O6(e4.getFullYear(), e4.getMonth() + 1, e4.getDate()) : Mt3(e4);
  }
  function vr2(e4) {
    let t = (a3) => String(a3).padStart(2, "0");
    return `${e4.year}-${t(e4.month)}-${t(e4.day)}`;
  }
  var wa, Ir2, Y8, Ta, Or2, lt3, xa, dt4, Rr2, Pa, Ma, Se4, Yr2, Br2, Wr2, so2, qr2, O6, Ur2, me3, Zr2, ce4, Rt3, I9, Gr2, At4, Lt4, zr2, tn3, Ua, rn3, nn3, Ke4, cn3, w7, ln3, dn3, un3, jt3, Gt4, fn3, gn3, hn3, lr2, dr2, or2, ur2, fr2, gr2, hr2, sr2, ir2, ze4, Ie3, pn2, mn3, $n3, yn2, pr2, bn2, mr2, cr2, Tn2, xn2, Pn2, In2, q8, yr2, et5, kn2, rs2, Rn2, ns2, An2, os2, Ln2, ss2, Nn2, is2, Fn2, cs2, tt6, ps;
  var init_date_picker = __esm({
    "../priv/static/date-picker.mjs"() {
      "use strict";
      init_chunk_S6MRQC6S();
      init_chunk_5MNNWH4C();
      init_chunk_L4HS2GN2();
      init_chunk_IYURAQ6S();
      wa = 1721426;
      Ir2 = { standard: [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31], leapyear: [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31] };
      Y8 = class {
        fromJulianDay(t) {
          let a3 = t, r3 = a3 - wa, n = Math.floor(r3 / 146097), o2 = Le4(r3, 146097), s = Math.floor(o2 / 36524), i = Le4(o2, 36524), u3 = Math.floor(i / 1461), p4 = Le4(i, 1461), h6 = Math.floor(p4 / 365), f4 = n * 400 + s * 100 + u3 * 4 + h6 + (s !== 4 && h6 !== 4 ? 1 : 0), [m5, $13] = Mr2(f4), v10 = a3 - Ne4(m5, $13, 1, 1), S13 = 2;
          a3 < Ne4(m5, $13, 3, 1) ? S13 = 0 : Fe4($13) && (S13 = 1);
          let N10 = Math.floor(((v10 + S13) * 12 + 373) / 367), ve8 = a3 - Ne4(m5, $13, N10, 1) + 1;
          return new O6(m5, $13, N10, ve8);
        }
        toJulianDay(t) {
          return Ne4(t.era, t.year, t.month, t.day);
        }
        getDaysInMonth(t) {
          return Ir2[Fe4(t.year) ? "leapyear" : "standard"][t.month - 1];
        }
        getMonthsInYear(t) {
          return 12;
        }
        getDaysInYear(t) {
          return Fe4(t.year) ? 366 : 365;
        }
        getMaximumMonthsInYear() {
          return 12;
        }
        getMaximumDaysInMonth() {
          return 31;
        }
        getYearsInEra(t) {
          return 9999;
        }
        getEras() {
          return ["BC", "AD"];
        }
        isInverseEra(t) {
          return t.era === "BC";
        }
        balanceDate(t) {
          t.year <= 0 && (t.era = t.era === "BC" ? "AD" : "BC", t.year = 1 - t.year);
        }
        constructor() {
          this.identifier = "gregory";
        }
      };
      Ta = { "001": 1, AD: 1, AE: 6, AF: 6, AI: 1, AL: 1, AM: 1, AN: 1, AR: 1, AT: 1, AU: 1, AX: 1, AZ: 1, BA: 1, BE: 1, BG: 1, BH: 6, BM: 1, BN: 1, BY: 1, CH: 1, CL: 1, CM: 1, CN: 1, CR: 1, CY: 1, CZ: 1, DE: 1, DJ: 6, DK: 1, DZ: 6, EC: 1, EE: 1, EG: 6, ES: 1, FI: 1, FJ: 1, FO: 1, FR: 1, GB: 1, GE: 1, GF: 1, GP: 1, GR: 1, HR: 1, HU: 1, IE: 1, IQ: 6, IR: 6, IS: 1, IT: 1, JO: 6, KG: 1, KW: 6, KZ: 1, LB: 1, LI: 1, LK: 1, LT: 1, LU: 1, LV: 1, LY: 6, MC: 1, MD: 1, ME: 1, MK: 1, MN: 1, MQ: 1, MV: 5, MY: 1, NL: 1, NO: 1, NZ: 1, OM: 6, PL: 1, QA: 6, RE: 1, RO: 1, RS: 1, RU: 1, SD: 6, SE: 1, SI: 1, SK: 1, SM: 1, SY: 6, TJ: 1, TM: 1, TR: 1, UA: 1, UY: 1, UZ: 1, VA: 1, VN: 1, XK: 1 };
      Or2 = { sun: 0, mon: 1, tue: 2, wed: 3, thu: 4, fri: 5, sat: 6 };
      lt3 = null;
      xa = /* @__PURE__ */ new Map();
      dt4 = /* @__PURE__ */ new Map();
      Rr2 = { AF: [4, 5], AE: [5, 6], BH: [5, 6], DZ: [5, 6], EG: [5, 6], IL: [5, 6], IQ: [5, 6], IR: [5, 5], JO: [5, 6], KW: [5, 6], LY: [5, 6], OM: [5, 6], QA: [5, 6], SA: [5, 6], SD: [5, 6], SY: [5, 6], YE: [5, 6] };
      Pa = /* @__PURE__ */ new Map();
      Ma = 864e5;
      Se4 = 36e5;
      Yr2 = /^([+-]\d{6}|\d{4})-(\d{2})-(\d{2})$/;
      Br2 = /^([+-]\d{6}|\d{4})-(\d{2})-(\d{2})(?:T(\d{2}))?(?::(\d{2}))?(?::(\d{2}))?(\.\d+)?(?:(?:([+-]\d{2})(?::?(\d{2}))?)|Z)$/;
      Wr2 = ["hours", "minutes", "seconds"];
      so2 = ["years", "months", "weeks", "days", ...Wr2];
      qr2 = /* @__PURE__ */ new WeakMap();
      O6 = class e {
        copy() {
          return this.era ? new e(this.calendar, this.era, this.year, this.month, this.day) : new e(this.calendar, this.year, this.month, this.day);
        }
        add(t) {
          return Ve5(this, t);
        }
        subtract(t) {
          return St3(this, t);
        }
        set(t) {
          return Ue3(this, t);
        }
        cycle(t, a3, r3) {
          return Ze4(this, t, a3, r3);
        }
        toDate(t) {
          return wt4(this, t);
        }
        toString() {
          return It4(this);
        }
        compare(t) {
          return mt4(this, t);
        }
        constructor(...t) {
          Ge4(this, qr2, { writable: true, value: void 0 });
          let [a3, r3, n, o2, s] = kt4(t);
          this.calendar = a3, this.era = r3, this.year = n, this.month = o2, this.day = s, X7(this);
        }
      };
      Ur2 = /* @__PURE__ */ new WeakMap();
      me3 = class e2 {
        copy() {
          return this.era ? new e2(this.calendar, this.era, this.year, this.month, this.day, this.hour, this.minute, this.second, this.millisecond) : new e2(this.calendar, this.year, this.month, this.day, this.hour, this.minute, this.second, this.millisecond);
        }
        add(t) {
          return Ve5(this, t);
        }
        subtract(t) {
          return St3(this, t);
        }
        set(t) {
          return Ue3(Ce3(this, t), t);
        }
        cycle(t, a3, r3) {
          switch (t) {
            case "era":
            case "year":
            case "month":
            case "day":
              return Ze4(this, t, a3, r3);
            default:
              return Ct4(this, t, a3, r3);
          }
        }
        toDate(t, a3) {
          return wt4(this, t, a3);
        }
        toString() {
          return Ot2(this);
        }
        compare(t) {
          let a3 = mt4(this, t);
          return a3 === 0 ? Ca(this, W9(t)) : a3;
        }
        constructor(...t) {
          Ge4(this, Ur2, { writable: true, value: void 0 });
          let [a3, r3, n, o2, s] = kt4(t);
          this.calendar = a3, this.era = r3, this.year = n, this.month = o2, this.day = s, this.hour = t.shift() || 0, this.minute = t.shift() || 0, this.second = t.shift() || 0, this.millisecond = t.shift() || 0, X7(this);
        }
      };
      Zr2 = /* @__PURE__ */ new WeakMap();
      ce4 = class e3 {
        copy() {
          return this.era ? new e3(this.calendar, this.era, this.year, this.month, this.day, this.timeZone, this.offset, this.hour, this.minute, this.second, this.millisecond) : new e3(this.calendar, this.year, this.month, this.day, this.timeZone, this.offset, this.hour, this.minute, this.second, this.millisecond);
        }
        add(t) {
          return Vt3(this, t);
        }
        subtract(t) {
          return Fa(this, t);
        }
        set(t, a3) {
          return Ya(this, t, a3);
        }
        cycle(t, a3, r3) {
          return Ha(this, t, a3, r3);
        }
        toDate() {
          return ka(this);
        }
        toString() {
          return Wa(this);
        }
        toAbsoluteString() {
          return this.toDate().toISOString();
        }
        compare(t) {
          return this.toDate().getTime() - Tt3(t, this.timeZone).toDate().getTime();
        }
        constructor(...t) {
          Ge4(this, Zr2, { writable: true, value: void 0 });
          let [a3, r3, n, o2, s] = kt4(t), i = t.shift(), u3 = t.shift();
          this.calendar = a3, this.era = r3, this.year = n, this.month = o2, this.day = s, this.timeZone = i, this.offset = u3, this.hour = t.shift() || 0, this.minute = t.shift() || 0, this.second = t.shift() || 0, this.millisecond = t.shift() || 0, X7(this);
        }
      };
      Rt3 = /* @__PURE__ */ new Map();
      I9 = class {
        format(t) {
          return this.formatter.format(t);
        }
        formatToParts(t) {
          return this.formatter.formatToParts(t);
        }
        formatRange(t, a3) {
          if (typeof this.formatter.formatRange == "function") return this.formatter.formatRange(t, a3);
          if (a3 < t) throw new RangeError("End date must be >= start date");
          return `${this.formatter.format(t)} \u2013 ${this.formatter.format(a3)}`;
        }
        formatRangeToParts(t, a3) {
          if (typeof this.formatter.formatRangeToParts == "function") return this.formatter.formatRangeToParts(t, a3);
          if (a3 < t) throw new RangeError("End date must be >= start date");
          let r3 = this.formatter.formatToParts(t), n = this.formatter.formatToParts(a3);
          return [...r3.map((o2) => __spreadProps(__spreadValues({}, o2), { source: "startRange" })), { type: "literal", value: " \u2013 ", source: "shared" }, ...n.map((o2) => __spreadProps(__spreadValues({}, o2), { source: "endRange" }))];
        }
        resolvedOptions() {
          let t = this.formatter.resolvedOptions();
          return Kr2() && (this.resolvedHourCycle || (this.resolvedHourCycle = Jr2(t.locale, this.options)), t.hourCycle = this.resolvedHourCycle, t.hour12 = this.resolvedHourCycle === "h11" || this.resolvedHourCycle === "h12"), t.calendar === "ethiopic-amete-alem" && (t.calendar = "ethioaa"), t;
        }
        constructor(t, a3 = {}) {
          this.formatter = qa(t, a3), this.options = a3;
        }
      };
      Gr2 = { true: { ja: "h11" }, false: {} };
      At4 = null;
      Lt4 = null;
      zr2 = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"];
      tn3 = 10;
      Ua = (e4) => e4 != null && e4.length === 4;
      rn3 = (e4) => e4 != null && parseFloat(e4) <= 12;
      nn3 = (e4) => e4 != null && parseFloat(e4) <= 31;
      Ke4 = "__live-region__";
      cn3 = G("date-picker").parts("clearTrigger", "content", "control", "input", "label", "monthSelect", "nextTrigger", "positioner", "presetTrigger", "prevTrigger", "rangeText", "root", "table", "tableBody", "tableCell", "tableCellTrigger", "tableHead", "tableHeader", "tableRow", "trigger", "view", "viewControl", "viewTrigger", "yearSelect");
      w7 = cn3.build();
      ln3 = (e4, t) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = e4.ids) == null ? void 0 : _a2.label) == null ? void 0 : _b.call(_a2, t)) != null ? _c : `datepicker:${e4.id}:label:${t}`;
      };
      dn3 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.root) != null ? _b : `datepicker:${e4.id}`;
      };
      un3 = (e4, t) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = e4.ids) == null ? void 0 : _a2.table) == null ? void 0 : _b.call(_a2, t)) != null ? _c : `datepicker:${e4.id}:table:${t}`;
      };
      jt3 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.content) != null ? _b : `datepicker:${e4.id}:content`;
      };
      Gt4 = (e4, t) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = e4.ids) == null ? void 0 : _a2.cellTrigger) == null ? void 0 : _b.call(_a2, t)) != null ? _c : `datepicker:${e4.id}:cell-trigger:${t}`;
      };
      fn3 = (e4, t) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = e4.ids) == null ? void 0 : _a2.prevTrigger) == null ? void 0 : _b.call(_a2, t)) != null ? _c : `datepicker:${e4.id}:prev:${t}`;
      };
      gn3 = (e4, t) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = e4.ids) == null ? void 0 : _a2.nextTrigger) == null ? void 0 : _b.call(_a2, t)) != null ? _c : `datepicker:${e4.id}:next:${t}`;
      };
      hn3 = (e4, t) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = e4.ids) == null ? void 0 : _a2.viewTrigger) == null ? void 0 : _b.call(_a2, t)) != null ? _c : `datepicker:${e4.id}:view:${t}`;
      };
      lr2 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.clearTrigger) != null ? _b : `datepicker:${e4.id}:clear`;
      };
      dr2 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.control) != null ? _b : `datepicker:${e4.id}:control`;
      };
      or2 = (e4, t) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = e4.ids) == null ? void 0 : _a2.input) == null ? void 0 : _b.call(_a2, t)) != null ? _c : `datepicker:${e4.id}:input:${t}`;
      };
      ur2 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.trigger) != null ? _b : `datepicker:${e4.id}:trigger`;
      };
      fr2 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.positioner) != null ? _b : `datepicker:${e4.id}:positioner`;
      };
      gr2 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.monthSelect) != null ? _b : `datepicker:${e4.id}:month-select`;
      };
      hr2 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.yearSelect) != null ? _b : `datepicker:${e4.id}:year-select`;
      };
      sr2 = (e4, t) => So(ze4(e4), `[data-part=table-cell-trigger][data-view=${t}][data-focus]:not([data-outside-range])`);
      ir2 = (e4) => e4.getById(ur2(e4));
      ze4 = (e4) => e4.getById(jt3(e4));
      Ie3 = (e4) => Po(pr2(e4), "[data-part=input]");
      pn2 = (e4) => e4.getById(hr2(e4));
      mn3 = (e4) => e4.getById(gr2(e4));
      $n3 = (e4) => e4.getById(lr2(e4));
      yn2 = (e4) => e4.getById(fr2(e4));
      pr2 = (e4) => e4.getById(dr2(e4));
      bn2 = { day: "dd", month: "mm", year: "yyyy" };
      mr2 = (e4, t) => e4 ? /\d/.test(e4) || e4 === t || e4.length !== 1 : true;
      cr2 = (e4) => !Number.isNaN(e4.day) && !Number.isNaN(e4.month) && !Number.isNaN(e4.year);
      Tn2 = (e4, t) => e4.split("").filter((a3) => mr2(a3, t)).join("");
      xn2 = { dayCell(e4) {
        return e4.unavailable ? `Not available. ${e4.formattedDate}` : e4.selected ? `Selected date. ${e4.formattedDate}` : `Choose ${e4.formattedDate}`;
      }, trigger(e4) {
        return e4 ? "Close calendar" : "Open calendar";
      }, viewTrigger(e4) {
        return rr(e4, { year: "Switch to month view", month: "Switch to day view", day: "Switch to year view" });
      }, presetTrigger(e4) {
        let [t = "", a3 = ""] = e4;
        return `select ${t} to ${a3}`;
      }, prevTrigger(e4) {
        return rr(e4, { year: "Switch to previous decade", month: "Switch to previous year", day: "Switch to previous month" });
      }, nextTrigger(e4) {
        return rr(e4, { year: "Switch to next decade", month: "Switch to next year", day: "Switch to next month" });
      }, placeholder() {
        return { day: "dd", month: "mm", year: "yyyy" };
      }, content: "calendar", monthSelect: "Select month", yearSelect: "Select year", clearTrigger: "Clear selected dates" };
      Pn2 = ["day", "month", "year"];
      In2 = vs((e4) => [e4.view, e4.startValue.toString(), e4.endValue.toString(), e4.locale], ([e4], t) => {
        let { startValue: a3, endValue: r3, locale: n, timeZone: o2, selectionMode: s } = t;
        if (e4 === "year") {
          let f4 = de4(a3.year, { strict: true }), m5 = f4.at(0).toString(), $13 = f4.at(-1).toString();
          return { start: m5, end: $13, formatted: `${m5} - ${$13}` };
        }
        if (e4 === "month") {
          let f4 = new I9(n, { year: "numeric", timeZone: o2 }), m5 = f4.format(a3.toDate(o2)), $13 = f4.format(r3.toDate(o2)), v10 = s === "range" ? `${m5} - ${$13}` : m5;
          return { start: m5, end: $13, formatted: v10 };
        }
        let i = new I9(n, { month: "long", year: "numeric", timeZone: o2 }), u3 = i.format(a3.toDate(o2)), p4 = i.format(r3.toDate(o2)), h6 = s === "range" ? `${u3} - ${p4}` : u3;
        return { start: u3, end: p4, formatted: h6 };
      });
      ({ and: q8 } = dr());
      yr2 = { props({ props: e4 }) {
        let t = e4.locale || "en-US", a3 = e4.timeZone || "UTC", r3 = e4.selectionMode || "single", n = e4.numOfMonths || 1, o2 = e4.defaultValue ? Je4(e4.defaultValue).map((f4) => _7(f4, e4.min, e4.max)) : void 0, s = e4.value ? Je4(e4.value).map((f4) => _7(f4, e4.min, e4.max)) : void 0, i = e4.focusedValue || e4.defaultFocusedValue || (s == null ? void 0 : s[0]) || (o2 == null ? void 0 : o2[0]) || ue4(a3);
        i = _7(i, e4.min, e4.max);
        let u3 = "day", p4 = "year", h6 = Qt3(e4.view || u3, u3, p4);
        return __spreadProps(__spreadValues({ locale: t, numOfMonths: n, timeZone: a3, selectionMode: r3, defaultView: h6, minView: u3, maxView: p4, outsideDaySelectable: false, closeOnSelect: true, format(f4, { locale: m5, timeZone: $13 }) {
          return new I9(m5, { timeZone: $13, day: "2-digit", month: "2-digit", year: "numeric" }).format(f4.toDate($13));
        }, parse(f4, { locale: m5, timeZone: $13 }) {
          return rr2(f4, m5, $13);
        } }, e4), { focusedValue: typeof e4.focusedValue > "u" ? void 0 : i, defaultFocusedValue: i, value: s, defaultValue: o2 != null ? o2 : [], positioning: __spreadValues({ placement: "bottom" }, e4.positioning) });
      }, initialState({ prop: e4 }) {
        return e4("open") || e4("defaultOpen") || e4("inline") ? "open" : "idle";
      }, refs() {
        return { announcer: void 0 };
      }, context({ prop: e4, bindable: t, getContext: a3 }) {
        return { focusedValue: t(() => ({ defaultValue: e4("defaultFocusedValue"), value: e4("focusedValue"), isEqual: k7, hash: (r3) => r3.toString(), sync: true, onChange(r3) {
          var _a2;
          let n = a3(), o2 = n.get("view"), s = n.get("value"), i = Qe4(s, e4);
          (_a2 = e4("onFocusChange")) == null ? void 0 : _a2({ value: s, valueAsString: i, view: o2, focusedValue: r3 });
        } })), value: t(() => ({ defaultValue: e4("defaultValue"), value: e4("value"), isEqual: On2, hash: (r3) => r3.map((n) => {
          var _a2;
          return (_a2 = n == null ? void 0 : n.toString()) != null ? _a2 : "";
        }).join(","), onChange(r3) {
          var _a2;
          let n = a3(), o2 = Qe4(r3, e4);
          (_a2 = e4("onValueChange")) == null ? void 0 : _a2({ value: r3, valueAsString: o2, view: n.get("view") });
        } })), inputValue: t(() => ({ defaultValue: "" })), activeIndex: t(() => ({ defaultValue: 0, sync: true })), hoveredValue: t(() => ({ defaultValue: null, isEqual: k7 })), view: t(() => ({ defaultValue: e4("defaultView"), value: e4("view"), onChange(r3) {
          var _a2;
          (_a2 = e4("onViewChange")) == null ? void 0 : _a2({ view: r3 });
        } })), startValue: t(() => {
          let r3 = e4("focusedValue") || e4("defaultFocusedValue");
          return { defaultValue: Ft3(r3, "start", { months: e4("numOfMonths") }, e4("locale")), isEqual: k7, hash: (n) => n.toString() };
        }), currentPlacement: t(() => ({ defaultValue: void 0 })), restoreFocus: t(() => ({ defaultValue: false })) };
      }, computed: { isInteractive: ({ prop: e4 }) => !e4("disabled") && !e4("readOnly"), visibleDuration: ({ prop: e4 }) => ({ months: e4("numOfMonths") }), endValue: ({ context: e4, computed: t }) => Yt4(e4.get("startValue"), t("visibleDuration")), visibleRange: ({ context: e4, computed: t }) => ({ start: e4.get("startValue"), end: t("endValue") }), visibleRangeText: ({ context: e4, prop: t, computed: a3 }) => In2({ view: e4.get("view"), startValue: e4.get("startValue"), endValue: a3("endValue"), locale: t("locale"), timeZone: t("timeZone"), selectionMode: t("selectionMode") }), isPrevVisibleRangeValid: ({ context: e4, prop: t }) => !Za(e4.get("startValue"), t("min"), t("max")), isNextVisibleRangeValid: ({ prop: e4, computed: t }) => !Ga(t("endValue"), e4("min"), e4("max")), valueAsString: ({ context: e4, prop: t }) => Qe4(e4.get("value"), t) }, effects: ["setupLiveRegion"], watch({ track: e4, prop: t, context: a3, action: r3, computed: n }) {
        e4([() => t("locale")], () => {
          r3(["setStartValue", "syncInputElement"]);
        }), e4([() => a3.hash("focusedValue")], () => {
          r3(["setStartValue", "focusActiveCellIfNeeded", "setHoveredValueIfKeyboard"]);
        }), e4([() => a3.hash("startValue")], () => {
          r3(["syncMonthSelectElement", "syncYearSelectElement", "invokeOnVisibleRangeChange"]);
        }), e4([() => a3.get("inputValue")], () => {
          r3(["syncInputValue"]);
        }), e4([() => a3.hash("value")], () => {
          r3(["syncInputElement"]);
        }), e4([() => n("valueAsString").toString()], () => {
          r3(["announceValueText"]);
        }), e4([() => a3.get("view")], () => {
          r3(["focusActiveCell"]);
        }), e4([() => t("open")], () => {
          r3(["toggleVisibility"]);
        });
      }, on: { "VALUE.SET": { actions: ["setDateValue", "setFocusedDate"] }, "VIEW.SET": { actions: ["setView"] }, "FOCUS.SET": { actions: ["setFocusedDate"] }, "VALUE.CLEAR": { actions: ["clearDateValue", "clearFocusedDate", "focusFirstInputElement"] }, "INPUT.CHANGE": [{ guard: "isInputValueEmpty", actions: ["setInputValue", "clearDateValue", "clearFocusedDate"] }, { actions: ["setInputValue", "focusParsedDate"] }], "INPUT.ENTER": { actions: ["focusParsedDate", "selectFocusedDate"] }, "INPUT.FOCUS": { actions: ["setActiveIndex"] }, "INPUT.BLUR": [{ guard: "shouldFixOnBlur", actions: ["setActiveIndexToStart", "selectParsedDate"] }, { actions: ["setActiveIndexToStart"] }], "PRESET.CLICK": [{ guard: "isOpenControlled", actions: ["setDateValue", "setFocusedDate", "invokeOnClose"] }, { target: "focused", actions: ["setDateValue", "setFocusedDate", "focusInputElement"] }], "GOTO.NEXT": [{ guard: "isYearView", actions: ["focusNextDecade", "announceVisibleRange"] }, { guard: "isMonthView", actions: ["focusNextYear", "announceVisibleRange"] }, { actions: ["focusNextPage"] }], "GOTO.PREV": [{ guard: "isYearView", actions: ["focusPreviousDecade", "announceVisibleRange"] }, { guard: "isMonthView", actions: ["focusPreviousYear", "announceVisibleRange"] }, { actions: ["focusPreviousPage"] }] }, states: { idle: { tags: ["closed"], on: { "CONTROLLED.OPEN": { target: "open", actions: ["focusFirstSelectedDate", "focusActiveCell"] }, "TRIGGER.CLICK": [{ guard: "isOpenControlled", actions: ["invokeOnOpen"] }, { target: "open", actions: ["focusFirstSelectedDate", "focusActiveCell", "invokeOnOpen"] }], OPEN: [{ guard: "isOpenControlled", actions: ["invokeOnOpen"] }, { target: "open", actions: ["focusFirstSelectedDate", "focusActiveCell", "invokeOnOpen"] }] } }, focused: { tags: ["closed"], on: { "CONTROLLED.OPEN": { target: "open", actions: ["focusFirstSelectedDate", "focusActiveCell"] }, "TRIGGER.CLICK": [{ guard: "isOpenControlled", actions: ["invokeOnOpen"] }, { target: "open", actions: ["focusFirstSelectedDate", "focusActiveCell", "invokeOnOpen"] }], OPEN: [{ guard: "isOpenControlled", actions: ["invokeOnOpen"] }, { target: "open", actions: ["focusFirstSelectedDate", "focusActiveCell", "invokeOnOpen"] }] } }, open: { tags: ["open"], effects: ["trackDismissableElement", "trackPositioning"], exit: ["clearHoveredDate", "resetView"], on: { "CONTROLLED.CLOSE": [{ guard: q8("shouldRestoreFocus", "isInteractOutsideEvent"), target: "focused", actions: ["focusTriggerElement"] }, { guard: "shouldRestoreFocus", target: "focused", actions: ["focusInputElement"] }, { target: "idle" }], "CELL.CLICK": [{ guard: "isAboveMinView", actions: ["setFocusedValueForView", "setPreviousView"] }, { guard: q8("isRangePicker", "hasSelectedRange"), actions: ["setActiveIndexToStart", "resetSelection", "setActiveIndexToEnd"] }, { guard: q8("isRangePicker", "isSelectingEndDate", "closeOnSelect", "isOpenControlled"), actions: ["setFocusedDate", "setSelectedDate", "setActiveIndexToStart", "clearHoveredDate", "invokeOnClose", "setRestoreFocus"] }, { guard: q8("isRangePicker", "isSelectingEndDate", "closeOnSelect"), target: "focused", actions: ["setFocusedDate", "setSelectedDate", "setActiveIndexToStart", "clearHoveredDate", "invokeOnClose", "focusInputElement"] }, { guard: q8("isRangePicker", "isSelectingEndDate"), actions: ["setFocusedDate", "setSelectedDate", "setActiveIndexToStart", "clearHoveredDate"] }, { guard: "isRangePicker", actions: ["setFocusedDate", "setSelectedDate", "setActiveIndexToEnd"] }, { guard: "isMultiPicker", actions: ["setFocusedDate", "toggleSelectedDate"] }, { guard: q8("closeOnSelect", "isOpenControlled"), actions: ["setFocusedDate", "setSelectedDate", "invokeOnClose"] }, { guard: "closeOnSelect", target: "focused", actions: ["setFocusedDate", "setSelectedDate", "invokeOnClose", "focusInputElement"] }, { actions: ["setFocusedDate", "setSelectedDate"] }], "CELL.POINTER_MOVE": { guard: q8("isRangePicker", "isSelectingEndDate"), actions: ["setHoveredDate", "setFocusedDate"] }, "TABLE.POINTER_LEAVE": { guard: "isRangePicker", actions: ["clearHoveredDate"] }, "TABLE.POINTER_DOWN": { actions: ["disableTextSelection"] }, "TABLE.POINTER_UP": { actions: ["enableTextSelection"] }, "TABLE.ESCAPE": [{ guard: "isOpenControlled", actions: ["focusFirstSelectedDate", "invokeOnClose"] }, { target: "focused", actions: ["focusFirstSelectedDate", "invokeOnClose", "focusTriggerElement"] }], "TABLE.ENTER": [{ guard: "isAboveMinView", actions: ["setPreviousView"] }, { guard: q8("isRangePicker", "hasSelectedRange"), actions: ["setActiveIndexToStart", "clearDateValue", "setSelectedDate", "setActiveIndexToEnd"] }, { guard: q8("isRangePicker", "isSelectingEndDate", "closeOnSelect", "isOpenControlled"), actions: ["setSelectedDate", "setActiveIndexToStart", "clearHoveredDate", "invokeOnClose"] }, { guard: q8("isRangePicker", "isSelectingEndDate", "closeOnSelect"), target: "focused", actions: ["setSelectedDate", "setActiveIndexToStart", "clearHoveredDate", "invokeOnClose", "focusInputElement"] }, { guard: q8("isRangePicker", "isSelectingEndDate"), actions: ["setSelectedDate", "setActiveIndexToStart", "clearHoveredDate"] }, { guard: "isRangePicker", actions: ["setSelectedDate", "setActiveIndexToEnd", "focusNextDay"] }, { guard: "isMultiPicker", actions: ["toggleSelectedDate"] }, { guard: q8("closeOnSelect", "isOpenControlled"), actions: ["selectFocusedDate", "invokeOnClose"] }, { guard: "closeOnSelect", target: "focused", actions: ["selectFocusedDate", "invokeOnClose", "focusInputElement"] }, { actions: ["selectFocusedDate"] }], "TABLE.ARROW_RIGHT": [{ guard: "isMonthView", actions: ["focusNextMonth"] }, { guard: "isYearView", actions: ["focusNextYear"] }, { actions: ["focusNextDay", "setHoveredDate"] }], "TABLE.ARROW_LEFT": [{ guard: "isMonthView", actions: ["focusPreviousMonth"] }, { guard: "isYearView", actions: ["focusPreviousYear"] }, { actions: ["focusPreviousDay"] }], "TABLE.ARROW_UP": [{ guard: "isMonthView", actions: ["focusPreviousMonthColumn"] }, { guard: "isYearView", actions: ["focusPreviousYearColumn"] }, { actions: ["focusPreviousWeek"] }], "TABLE.ARROW_DOWN": [{ guard: "isMonthView", actions: ["focusNextMonthColumn"] }, { guard: "isYearView", actions: ["focusNextYearColumn"] }, { actions: ["focusNextWeek"] }], "TABLE.PAGE_UP": { actions: ["focusPreviousSection"] }, "TABLE.PAGE_DOWN": { actions: ["focusNextSection"] }, "TABLE.HOME": [{ guard: "isMonthView", actions: ["focusFirstMonth"] }, { guard: "isYearView", actions: ["focusFirstYear"] }, { actions: ["focusSectionStart"] }], "TABLE.END": [{ guard: "isMonthView", actions: ["focusLastMonth"] }, { guard: "isYearView", actions: ["focusLastYear"] }, { actions: ["focusSectionEnd"] }], "TRIGGER.CLICK": [{ guard: "isOpenControlled", actions: ["invokeOnClose"] }, { target: "focused", actions: ["invokeOnClose"] }], "VIEW.TOGGLE": { actions: ["setNextView"] }, INTERACT_OUTSIDE: [{ guard: "isOpenControlled", actions: ["setActiveIndexToStart", "invokeOnClose"] }, { guard: "shouldRestoreFocus", target: "focused", actions: ["setActiveIndexToStart", "invokeOnClose", "focusTriggerElement"] }, { target: "idle", actions: ["setActiveIndexToStart", "invokeOnClose"] }], CLOSE: [{ guard: "isOpenControlled", actions: ["setActiveIndexToStart", "invokeOnClose"] }, { target: "idle", actions: ["setActiveIndexToStart", "invokeOnClose"] }] } } }, implementations: { guards: { isAboveMinView: ({ context: e4, prop: t }) => En2(e4.get("view"), t("minView")), isDayView: ({ context: e4, event: t }) => (t.view || e4.get("view")) === "day", isMonthView: ({ context: e4, event: t }) => (t.view || e4.get("view")) === "month", isYearView: ({ context: e4, event: t }) => (t.view || e4.get("view")) === "year", isRangePicker: ({ prop: e4 }) => e4("selectionMode") === "range", hasSelectedRange: ({ context: e4 }) => e4.get("value").length === 2, isMultiPicker: ({ prop: e4 }) => e4("selectionMode") === "multiple", shouldRestoreFocus: ({ context: e4 }) => !!e4.get("restoreFocus"), isSelectingEndDate: ({ context: e4 }) => e4.get("activeIndex") === 1, closeOnSelect: ({ prop: e4 }) => !!e4("closeOnSelect"), isOpenControlled: ({ prop: e4 }) => e4("open") != null || !!e4("inline"), isInteractOutsideEvent: ({ event: e4 }) => {
        var _a2;
        return ((_a2 = e4.previousEvent) == null ? void 0 : _a2.type) === "INTERACT_OUTSIDE";
      }, isInputValueEmpty: ({ event: e4 }) => e4.value.trim() === "", shouldFixOnBlur: ({ event: e4 }) => !!e4.fixOnBlur }, effects: { trackPositioning({ context: e4, prop: t, scope: a3 }) {
        if (t("inline")) return;
        e4.get("currentPlacement") || e4.set("currentPlacement", t("positioning").placement);
        let r3 = pr2(a3);
        return Mn2(r3, () => yn2(a3), __spreadProps(__spreadValues({}, t("positioning")), { defer: true, onComplete(o2) {
          e4.set("currentPlacement", o2.placement);
        } }));
      }, setupLiveRegion({ scope: e4, refs: t }) {
        let a3 = e4.getDoc();
        return t.set("announcer", nr2({ level: "assertive", document: a3 })), () => {
          var _a2, _b;
          return (_b = (_a2 = t.get("announcer")) == null ? void 0 : _a2.destroy) == null ? void 0 : _b.call(_a2);
        };
      }, trackDismissableElement({ scope: e4, send: t, context: a3, prop: r3 }) {
        return r3("inline") ? void 0 : H9(() => ze4(e4), { type: "popover", defer: true, exclude: [...Ie3(e4), ir2(e4), $n3(e4)], onInteractOutside(o2) {
          a3.set("restoreFocus", !o2.detail.focusable);
        }, onDismiss() {
          t({ type: "INTERACT_OUTSIDE" });
        }, onEscapeKeyDown(o2) {
          o2.preventDefault(), t({ type: "TABLE.ESCAPE", src: "dismissable" });
        } });
      } }, actions: { setNextView({ context: e4, prop: t }) {
        let a3 = Cn2(e4.get("view"), t("minView"), t("maxView"));
        e4.set("view", a3);
      }, setPreviousView({ context: e4, prop: t }) {
        let a3 = Vn2(e4.get("view"), t("minView"), t("maxView"));
        e4.set("view", a3);
      }, setView({ context: e4, event: t }) {
        e4.set("view", t.view);
      }, setRestoreFocus({ context: e4 }) {
        e4.set("restoreFocus", true);
      }, announceValueText({ context: e4, prop: t, refs: a3 }) {
        var _a2;
        let r3 = e4.get("value"), n = t("locale"), o2 = t("timeZone"), s;
        if (t("selectionMode") === "range") {
          let [i, u3] = r3;
          i && u3 ? s = Me3(i, u3, n, o2) : i ? s = Me3(i, null, n, o2) : u3 ? s = Me3(u3, null, n, o2) : s = "";
        } else s = r3.map((i) => Me3(i, null, n, o2)).filter(Boolean).join(",");
        (_a2 = a3.get("announcer")) == null ? void 0 : _a2.announce(s, 3e3);
      }, announceVisibleRange({ computed: e4, refs: t }) {
        var _a2;
        let { formatted: a3 } = e4("visibleRangeText");
        (_a2 = t.get("announcer")) == null ? void 0 : _a2.announce(a3);
      }, disableTextSelection({ scope: e4 }) {
        Nn({ target: ze4(e4), doc: e4.getDoc() });
      }, enableTextSelection({ scope: e4 }) {
        Mn({ doc: e4.getDoc(), target: ze4(e4) });
      }, focusFirstSelectedDate(e4) {
        let { context: t } = e4;
        t.get("value").length && D6(e4, t.get("value")[0]);
      }, syncInputElement({ scope: e4, computed: t }) {
        nt(() => {
          Ie3(e4).forEach((r3, n) => {
            sn(r3, t("valueAsString")[n] || "");
          });
        });
      }, setFocusedDate(e4) {
        let { event: t } = e4, a3 = Array.isArray(t.value) ? t.value[0] : t.value;
        D6(e4, a3);
      }, setFocusedValueForView(e4) {
        let { context: t, event: a3 } = e4;
        D6(e4, t.get("focusedValue").set({ [t.get("view")]: a3.value }));
      }, focusNextMonth(e4) {
        let { context: t } = e4;
        D6(e4, t.get("focusedValue").add({ months: 1 }));
      }, focusPreviousMonth(e4) {
        let { context: t } = e4;
        D6(e4, t.get("focusedValue").subtract({ months: 1 }));
      }, setDateValue({ context: e4, event: t, prop: a3 }) {
        if (!Array.isArray(t.value)) return;
        let r3 = t.value.map((n) => _7(n, a3("min"), a3("max")));
        e4.set("value", r3);
      }, clearDateValue({ context: e4 }) {
        e4.set("value", []);
      }, setSelectedDate(e4) {
        var _a2;
        let { context: t, event: a3 } = e4, r3 = Array.from(t.get("value"));
        r3[t.get("activeIndex")] = et5(e4, (_a2 = a3.value) != null ? _a2 : t.get("focusedValue")), t.set("value", Kt3(r3));
      }, resetSelection(e4) {
        var _a2;
        let { context: t, event: a3 } = e4, r3 = et5(e4, (_a2 = a3.value) != null ? _a2 : t.get("focusedValue"));
        t.set("value", [r3]);
      }, toggleSelectedDate(e4) {
        var _a2;
        let { context: t, event: a3 } = e4, r3 = et5(e4, (_a2 = a3.value) != null ? _a2 : t.get("focusedValue")), n = t.get("value").findIndex((o2) => k7(o2, r3));
        if (n === -1) {
          let o2 = [...t.get("value"), r3];
          t.set("value", Je4(o2));
        } else {
          let o2 = Array.from(t.get("value"));
          o2.splice(n, 1), t.set("value", Je4(o2));
        }
      }, setHoveredDate({ context: e4, event: t }) {
        e4.set("hoveredValue", t.value);
      }, clearHoveredDate({ context: e4 }) {
        e4.set("hoveredValue", null);
      }, selectFocusedDate({ context: e4, computed: t }) {
        let a3 = Array.from(e4.get("value")), r3 = e4.get("activeIndex");
        a3[r3] = e4.get("focusedValue").copy(), e4.set("value", Kt3(a3));
        let n = t("valueAsString");
        e4.set("inputValue", n[r3]);
      }, focusPreviousDay(e4) {
        let { context: t } = e4, a3 = t.get("focusedValue").subtract({ days: 1 });
        D6(e4, a3);
      }, focusNextDay(e4) {
        let { context: t } = e4, a3 = t.get("focusedValue").add({ days: 1 });
        D6(e4, a3);
      }, focusPreviousWeek(e4) {
        let { context: t } = e4, a3 = t.get("focusedValue").subtract({ weeks: 1 });
        D6(e4, a3);
      }, focusNextWeek(e4) {
        let { context: t } = e4, a3 = t.get("focusedValue").add({ weeks: 1 });
        D6(e4, a3);
      }, focusNextPage(e4) {
        let { context: t, computed: a3, prop: r3 } = e4, n = qt3(t.get("focusedValue"), t.get("startValue"), a3("visibleDuration"), r3("locale"), r3("min"), r3("max"));
        Xe4(e4, n);
      }, focusPreviousPage(e4) {
        let { context: t, computed: a3, prop: r3 } = e4, n = Ut3(t.get("focusedValue"), t.get("startValue"), a3("visibleDuration"), r3("locale"), r3("min"), r3("max"));
        Xe4(e4, n);
      }, focusSectionStart(e4) {
        let { context: t } = e4;
        D6(e4, t.get("startValue").copy());
      }, focusSectionEnd(e4) {
        let { computed: t } = e4;
        D6(e4, t("endValue").copy());
      }, focusNextSection(e4) {
        let { context: t, event: a3, computed: r3, prop: n } = e4, o2 = tr2(t.get("focusedValue"), t.get("startValue"), a3.larger, r3("visibleDuration"), n("locale"), n("min"), n("max"));
        o2 && Xe4(e4, o2);
      }, focusPreviousSection(e4) {
        let { context: t, event: a3, computed: r3, prop: n } = e4, o2 = ar2(t.get("focusedValue"), t.get("startValue"), a3.larger, r3("visibleDuration"), n("locale"), n("min"), n("max"));
        o2 && Xe4(e4, o2);
      }, focusNextYear(e4) {
        let { context: t } = e4, a3 = t.get("focusedValue").add({ years: 1 });
        D6(e4, a3);
      }, focusPreviousYear(e4) {
        let { context: t } = e4, a3 = t.get("focusedValue").subtract({ years: 1 });
        D6(e4, a3);
      }, focusNextDecade(e4) {
        let { context: t } = e4, a3 = t.get("focusedValue").add({ years: 10 });
        D6(e4, a3);
      }, focusPreviousDecade(e4) {
        let { context: t } = e4, a3 = t.get("focusedValue").subtract({ years: 10 });
        D6(e4, a3);
      }, clearFocusedDate(e4) {
        let { prop: t } = e4;
        D6(e4, ue4(t("timeZone")));
      }, focusPreviousMonthColumn(e4) {
        let { context: t, event: a3 } = e4, r3 = t.get("focusedValue").subtract({ months: a3.columns });
        D6(e4, r3);
      }, focusNextMonthColumn(e4) {
        let { context: t, event: a3 } = e4, r3 = t.get("focusedValue").add({ months: a3.columns });
        D6(e4, r3);
      }, focusPreviousYearColumn(e4) {
        let { context: t, event: a3 } = e4, r3 = t.get("focusedValue").subtract({ years: a3.columns });
        D6(e4, r3);
      }, focusNextYearColumn(e4) {
        let { context: t, event: a3 } = e4, r3 = t.get("focusedValue").add({ years: a3.columns });
        D6(e4, r3);
      }, focusFirstMonth(e4) {
        let { context: t } = e4, a3 = t.get("focusedValue").set({ month: 1 });
        D6(e4, a3);
      }, focusLastMonth(e4) {
        let { context: t } = e4, a3 = t.get("focusedValue").set({ month: 12 });
        D6(e4, a3);
      }, focusFirstYear(e4) {
        let { context: t } = e4, a3 = de4(t.get("focusedValue").year), r3 = t.get("focusedValue").set({ year: a3[0] });
        D6(e4, r3);
      }, focusLastYear(e4) {
        let { context: t } = e4, a3 = de4(t.get("focusedValue").year), r3 = t.get("focusedValue").set({ year: a3[a3.length - 1] });
        D6(e4, r3);
      }, setActiveIndex({ context: e4, event: t }) {
        e4.set("activeIndex", t.index);
      }, setActiveIndexToEnd({ context: e4 }) {
        e4.set("activeIndex", 1);
      }, setActiveIndexToStart({ context: e4 }) {
        e4.set("activeIndex", 0);
      }, focusActiveCell({ scope: e4, context: t }) {
        nt(() => {
          var _a2;
          let a3 = t.get("view");
          (_a2 = sr2(e4, a3)) == null ? void 0 : _a2.focus({ preventScroll: true });
        });
      }, focusActiveCellIfNeeded({ scope: e4, context: t, event: a3 }) {
        a3.focus && nt(() => {
          var _a2;
          let r3 = t.get("view");
          (_a2 = sr2(e4, r3)) == null ? void 0 : _a2.focus({ preventScroll: true });
        });
      }, setHoveredValueIfKeyboard({ context: e4, event: t, prop: a3 }) {
        !t.type.startsWith("TABLE.ARROW") || a3("selectionMode") !== "range" || e4.get("activeIndex") === 0 || e4.set("hoveredValue", e4.get("focusedValue").copy());
      }, focusTriggerElement({ scope: e4 }) {
        nt(() => {
          var _a2;
          (_a2 = ir2(e4)) == null ? void 0 : _a2.focus({ preventScroll: true });
        });
      }, focusFirstInputElement({ scope: e4 }) {
        nt(() => {
          let [t] = Ie3(e4);
          t == null ? void 0 : t.focus({ preventScroll: true });
        });
      }, focusInputElement({ scope: e4 }) {
        nt(() => {
          let t = Ie3(e4), a3 = t.findLastIndex((o2) => o2.value !== ""), r3 = Math.max(a3, 0), n = t[r3];
          n == null ? void 0 : n.focus({ preventScroll: true }), n == null ? void 0 : n.setSelectionRange(n.value.length, n.value.length);
        });
      }, syncMonthSelectElement({ scope: e4, context: t }) {
        let a3 = mn3(e4);
        sn(a3, t.get("startValue").month.toString());
      }, syncYearSelectElement({ scope: e4, context: t }) {
        let a3 = pn2(e4);
        sn(a3, t.get("startValue").year.toString());
      }, setInputValue({ context: e4, event: t }) {
        e4.get("activeIndex") === t.index && e4.set("inputValue", t.value);
      }, syncInputValue({ scope: e4, context: t, event: a3 }) {
        queueMicrotask(() => {
          var _a2;
          let r3 = Ie3(e4), n = (_a2 = a3.index) != null ? _a2 : t.get("activeIndex");
          sn(r3[n], t.get("inputValue"));
        });
      }, focusParsedDate(e4) {
        let { event: t, prop: a3 } = e4;
        if (t.index == null) return;
        let n = a3("parse")(t.value, { locale: a3("locale"), timeZone: a3("timeZone") });
        !n || !cr2(n) || D6(e4, n);
      }, selectParsedDate({ context: e4, event: t, prop: a3 }) {
        if (t.index == null) return;
        let n = a3("parse")(t.value, { locale: a3("locale"), timeZone: a3("timeZone") });
        if ((!n || !cr2(n)) && t.value && (n = e4.get("focusedValue").copy()), !n) return;
        n = _7(n, a3("min"), a3("max"));
        let o2 = Array.from(e4.get("value"));
        o2[t.index] = n, e4.set("value", o2);
        let s = Qe4(o2, a3);
        e4.set("inputValue", s[t.index]);
      }, resetView({ context: e4 }) {
        e4.set("view", e4.initial("view"));
      }, setStartValue({ context: e4, computed: t, prop: a3 }) {
        let r3 = e4.get("focusedValue");
        if (!Z9(r3, e4.get("startValue"), t("endValue"))) return;
        let o2 = Ft3(r3, "start", { months: a3("numOfMonths") }, a3("locale"));
        e4.set("startValue", o2);
      }, invokeOnOpen({ prop: e4, context: t }) {
        var _a2;
        e4("inline") || ((_a2 = e4("onOpenChange")) == null ? void 0 : _a2({ open: true, value: t.get("value") }));
      }, invokeOnClose({ prop: e4, context: t }) {
        var _a2;
        e4("inline") || ((_a2 = e4("onOpenChange")) == null ? void 0 : _a2({ open: false, value: t.get("value") }));
      }, invokeOnVisibleRangeChange({ prop: e4, context: t, computed: a3 }) {
        var _a2;
        (_a2 = e4("onVisibleRangeChange")) == null ? void 0 : _a2({ view: t.get("view"), visibleRange: a3("visibleRange") });
      }, toggleVisibility({ event: e4, send: t, prop: a3 }) {
        t({ type: a3("open") ? "CONTROLLED.OPEN" : "CONTROLLED.CLOSE", previousEvent: e4 });
      } } } };
      et5 = (e4, t) => {
        let { context: a3, prop: r3 } = e4, n = a3.get("view"), o2 = typeof t == "number" ? a3.get("focusedValue").set({ [n]: t }) : t;
        return Mn3((s) => {
          Sn2(s, r3("minView")) && (o2 = o2.set({ [s]: s === "day" ? 1 : 0 }));
        }), o2;
      };
      kn2 = As()(["closeOnSelect", "dir", "disabled", "fixedWeeks", "focusedValue", "format", "parse", "placeholder", "getRootNode", "id", "ids", "inline", "invalid", "isDateUnavailable", "locale", "max", "min", "name", "numOfMonths", "onFocusChange", "onOpenChange", "onValueChange", "onViewChange", "onVisibleRangeChange", "open", "defaultOpen", "positioning", "readOnly", "required", "selectionMode", "startOfWeek", "timeZone", "translations", "value", "defaultView", "defaultValue", "view", "defaultFocusedValue", "outsideDaySelectable", "minView", "maxView"]);
      rs2 = as(kn2);
      Rn2 = As()(["index", "fixOnBlur"]);
      ns2 = as(Rn2);
      An2 = As()(["value"]);
      os2 = as(An2);
      Ln2 = As()(["columns", "id", "view"]);
      ss2 = as(Ln2);
      Nn2 = As()(["disabled", "value", "columns"]);
      is2 = as(Nn2);
      Fn2 = As()(["view"]);
      cs2 = as(Fn2);
      tt6 = class extends ve {
        constructor() {
          super(...arguments);
          __publicField(this, "getDayView", () => this.el.querySelector('[data-part="day-view"]'));
          __publicField(this, "getMonthView", () => this.el.querySelector('[data-part="month-view"]'));
          __publicField(this, "getYearView", () => this.el.querySelector('[data-part="year-view"]'));
          __publicField(this, "renderDayTableHeader", () => {
            var _a2;
            let a3 = (_a2 = this.getDayView()) == null ? void 0 : _a2.querySelector("thead");
            if (!a3 || !this.api.weekDays) return;
            let r3 = this.doc.createElement("tr");
            this.spreadProps(r3, this.api.getTableRowProps({ view: "day" })), this.api.weekDays.forEach((n) => {
              let o2 = this.doc.createElement("th");
              o2.scope = "col", o2.setAttribute("aria-label", n.long), o2.textContent = n.narrow, r3.appendChild(o2);
            }), a3.innerHTML = "", a3.appendChild(r3);
          });
          __publicField(this, "renderDayTableBody", () => {
            var _a2;
            let a3 = (_a2 = this.getDayView()) == null ? void 0 : _a2.querySelector("tbody");
            a3 && (this.spreadProps(a3, this.api.getTableBodyProps({ view: "day" })), this.api.weeks && (a3.innerHTML = "", this.api.weeks.forEach((r3) => {
              let n = this.doc.createElement("tr");
              this.spreadProps(n, this.api.getTableRowProps({ view: "day" })), r3.forEach((o2) => {
                let s = this.doc.createElement("td");
                this.spreadProps(s, this.api.getDayTableCellProps({ value: o2 }));
                let i = this.doc.createElement("div");
                this.spreadProps(i, this.api.getDayTableCellTriggerProps({ value: o2 })), i.textContent = String(o2.day), s.appendChild(i), n.appendChild(s);
              }), a3.appendChild(n);
            })));
          });
          __publicField(this, "renderMonthTableBody", () => {
            var _a2;
            let a3 = (_a2 = this.getMonthView()) == null ? void 0 : _a2.querySelector("tbody");
            if (!a3) return;
            this.spreadProps(a3, this.api.getTableBodyProps({ view: "month" }));
            let r3 = this.api.getMonthsGrid({ columns: 4, format: "short" });
            a3.innerHTML = "", r3.forEach((n) => {
              let o2 = this.doc.createElement("tr");
              this.spreadProps(o2, this.api.getTableRowProps()), n.forEach((s) => {
                let i = this.doc.createElement("td");
                this.spreadProps(i, this.api.getMonthTableCellProps(__spreadProps(__spreadValues({}, s), { columns: 4 })));
                let u3 = this.doc.createElement("div");
                this.spreadProps(u3, this.api.getMonthTableCellTriggerProps(__spreadProps(__spreadValues({}, s), { columns: 4 }))), u3.textContent = s.label, i.appendChild(u3), o2.appendChild(i);
              }), a3.appendChild(o2);
            });
          });
          __publicField(this, "renderYearTableBody", () => {
            var _a2;
            let a3 = (_a2 = this.getYearView()) == null ? void 0 : _a2.querySelector("tbody");
            if (!a3) return;
            this.spreadProps(a3, this.api.getTableBodyProps());
            let r3 = this.api.getYearsGrid({ columns: 4 });
            a3.innerHTML = "", r3.forEach((n) => {
              let o2 = this.doc.createElement("tr");
              this.spreadProps(o2, this.api.getTableRowProps({ view: "year" })), n.forEach((s) => {
                let i = this.doc.createElement("td");
                this.spreadProps(i, this.api.getYearTableCellProps(__spreadProps(__spreadValues({}, s), { columns: 4 })));
                let u3 = this.doc.createElement("div");
                this.spreadProps(u3, this.api.getYearTableCellTriggerProps(__spreadProps(__spreadValues({}, s), { columns: 4 }))), u3.textContent = s.label, i.appendChild(u3), o2.appendChild(i);
              }), a3.appendChild(o2);
            });
          });
        }
        initMachine(t) {
          return new Ls(yr2, t);
        }
        initApi() {
          return $r2(this.machine.service, Cs);
        }
        render() {
          let t = this.el.querySelector('[data-scope="date-picker"][data-part="root"]');
          t && this.spreadProps(t, this.api.getRootProps());
          let a3 = this.el.querySelector('[data-scope="date-picker"][data-part="label"]');
          a3 && this.spreadProps(a3, this.api.getLabelProps());
          let r3 = this.el.querySelector('[data-scope="date-picker"][data-part="control"]');
          r3 && this.spreadProps(r3, this.api.getControlProps());
          let n = this.el.querySelector('[data-scope="date-picker"][data-part="input"]');
          n && this.spreadProps(n, this.api.getInputProps());
          let o2 = this.el.querySelector('[data-scope="date-picker"][data-part="trigger"]');
          o2 && this.spreadProps(o2, this.api.getTriggerProps());
          let s = this.el.querySelector('[data-scope="date-picker"][data-part="positioner"]');
          s && this.spreadProps(s, this.api.getPositionerProps());
          let i = this.el.querySelector('[data-scope="date-picker"][data-part="content"]');
          if (i && this.spreadProps(i, this.api.getContentProps()), this.api.open) {
            let u3 = this.getDayView(), p4 = this.getMonthView(), h6 = this.getYearView();
            if (u3 && (u3.hidden = this.api.view !== "day"), p4 && (p4.hidden = this.api.view !== "month"), h6 && (h6.hidden = this.api.view !== "year"), this.api.view === "day" && u3) {
              let f4 = u3.querySelector('[data-part="view-control"]');
              f4 && this.spreadProps(f4, this.api.getViewControlProps({ view: "year" }));
              let m5 = u3.querySelector('[data-part="prev-trigger"]');
              m5 && this.spreadProps(m5, this.api.getPrevTriggerProps());
              let $13 = u3.querySelector('[data-part="view-trigger"]');
              $13 && (this.spreadProps($13, this.api.getViewTriggerProps()), $13.textContent = this.api.visibleRangeText.start);
              let v10 = u3.querySelector('[data-part="next-trigger"]');
              v10 && this.spreadProps(v10, this.api.getNextTriggerProps());
              let S13 = u3.querySelector("table");
              S13 && this.spreadProps(S13, this.api.getTableProps({ view: "day" }));
              let N10 = u3.querySelector("thead");
              N10 && this.spreadProps(N10, this.api.getTableHeaderProps({ view: "day" })), this.renderDayTableHeader(), this.renderDayTableBody();
            } else if (this.api.view === "month" && p4) {
              let f4 = p4.querySelector('[data-part="view-control"]');
              f4 && this.spreadProps(f4, this.api.getViewControlProps({ view: "month" }));
              let m5 = p4.querySelector('[data-part="prev-trigger"]');
              m5 && this.spreadProps(m5, this.api.getPrevTriggerProps({ view: "month" }));
              let $13 = p4.querySelector('[data-part="view-trigger"]');
              $13 && (this.spreadProps($13, this.api.getViewTriggerProps({ view: "month" })), $13.textContent = String(this.api.visibleRange.start.year));
              let v10 = p4.querySelector('[data-part="next-trigger"]');
              v10 && this.spreadProps(v10, this.api.getNextTriggerProps({ view: "month" }));
              let S13 = p4.querySelector("table");
              S13 && this.spreadProps(S13, this.api.getTableProps({ view: "month", columns: 4 })), this.renderMonthTableBody();
            } else if (this.api.view === "year" && h6) {
              let f4 = h6.querySelector('[data-part="view-control"]');
              f4 && this.spreadProps(f4, this.api.getViewControlProps({ view: "year" }));
              let m5 = h6.querySelector('[data-part="prev-trigger"]');
              m5 && this.spreadProps(m5, this.api.getPrevTriggerProps({ view: "year" }));
              let $13 = h6.querySelector('[data-part="decade"]');
              if ($13) {
                let N10 = this.api.getDecade();
                $13.textContent = `${N10.start} - ${N10.end}`;
              }
              let v10 = h6.querySelector('[data-part="next-trigger"]');
              v10 && this.spreadProps(v10, this.api.getNextTriggerProps({ view: "year" }));
              let S13 = h6.querySelector("table");
              S13 && this.spreadProps(S13, this.api.getTableProps({ view: "year", columns: 4 })), this.renderYearTableBody();
            }
          }
        }
      };
      ps = { mounted() {
        let e4 = this.el, t = this.pushEvent.bind(this), a3 = this.liveSocket, r3 = xr(e4, "min"), n = xr(e4, "max"), o2 = xr(e4, "positioning"), s = (h6) => h6 ? h6.map((f4) => L7(f4)) : void 0, i = (h6) => h6 ? L7(h6) : void 0, u3 = new tt6(e4, __spreadProps(__spreadValues({ id: e4.id }, _r(e4, "controlled") ? { value: s(Cr(e4, "value")) } : { defaultValue: s(Cr(e4, "defaultValue")) }), { defaultFocusedValue: i(xr(e4, "focusedValue")), defaultView: xr(e4, "defaultView", ["day", "month", "year"]), dir: xr(e4, "dir", ["ltr", "rtl"]), locale: xr(e4, "locale"), timeZone: xr(e4, "timeZone"), disabled: _r(e4, "disabled"), readOnly: _r(e4, "readOnly"), required: _r(e4, "required"), invalid: _r(e4, "invalid"), outsideDaySelectable: _r(e4, "outsideDaySelectable"), closeOnSelect: _r(e4, "closeOnSelect"), min: r3 ? L7(r3) : void 0, max: n ? L7(n) : void 0, numOfMonths: Lr(e4, "numOfMonths"), startOfWeek: Lr(e4, "startOfWeek"), fixedWeeks: _r(e4, "fixedWeeks"), selectionMode: xr(e4, "selectionMode", ["single", "multiple", "range"]), placeholder: xr(e4, "placeholder"), minView: xr(e4, "minView", ["day", "month", "year"]), maxView: xr(e4, "maxView", ["day", "month", "year"]), inline: _r(e4, "inline"), positioning: o2 ? JSON.parse(o2) : void 0, onValueChange: (h6) => {
          var _a2;
          let f4 = ((_a2 = h6.value) == null ? void 0 : _a2.length) ? h6.value.map((v10) => vr2(v10)).join(",") : "", m5 = e4.querySelector(`#${e4.id}-value`);
          m5 && m5.value !== f4 && (m5.value = f4, m5.dispatchEvent(new Event("input", { bubbles: true })), m5.dispatchEvent(new Event("change", { bubbles: true })));
          let $13 = xr(e4, "onValueChange");
          $13 && a3.main.isConnected() && t($13, { id: e4.id, value: f4 || null });
        }, onFocusChange: (h6) => {
          var _a2;
          let f4 = xr(e4, "onFocusChange");
          f4 && a3.main.isConnected() && t(f4, { id: e4.id, focused: (_a2 = h6.focused) != null ? _a2 : false });
        }, onViewChange: (h6) => {
          let f4 = xr(e4, "onViewChange");
          f4 && a3.main.isConnected() && t(f4, { id: e4.id, view: h6.view });
        }, onVisibleRangeChange: (h6) => {
          let f4 = xr(e4, "onVisibleRangeChange");
          f4 && a3.main.isConnected() && t(f4, { id: e4.id, start: h6.start, end: h6.end });
        }, onOpenChange: (h6) => {
          let f4 = xr(e4, "onOpenChange");
          f4 && a3.main.isConnected() && t(f4, { id: e4.id, open: h6.open });
        } }));
        u3.init(), this.datePicker = u3;
        let p4 = e4.querySelector('[data-scope="date-picker"][data-part="input-wrapper"]');
        p4 && p4.removeAttribute("data-loading"), this.handlers = [], this.handlers.push(this.handleEvent("date_picker_set_value", (h6) => {
          let f4 = h6.date_picker_id;
          f4 && f4 !== e4.id || u3.api.setValue([L7(h6.value)]);
        })), this.onSetValue = (h6) => {
          var _a2;
          let f4 = (_a2 = h6.detail) == null ? void 0 : _a2.value;
          typeof f4 == "string" && u3.api.setValue([L7(f4)]);
        }, e4.addEventListener("phx:date-picker:set-value", this.onSetValue);
      }, updated() {
        var _a2, _b;
        let e4 = this.el, t = e4.querySelector('[data-scope="date-picker"][data-part="input-wrapper"]');
        t && t.removeAttribute("data-loading");
        let a3 = (u3) => u3 ? u3.map((p4) => L7(p4)) : void 0, r3 = xr(e4, "min"), n = xr(e4, "max"), o2 = xr(e4, "positioning"), s = _r(e4, "controlled"), i = xr(e4, "focusedValue");
        if ((_a2 = this.datePicker) == null ? void 0 : _a2.updateProps(__spreadProps(__spreadValues({}, _r(e4, "controlled") ? { value: a3(Cr(e4, "value")) } : { defaultValue: a3(Cr(e4, "defaultValue")) }), { defaultFocusedValue: i ? L7(i) : void 0, defaultView: xr(e4, "defaultView", ["day", "month", "year"]), dir: xr(this.el, "dir", ["ltr", "rtl"]), locale: xr(this.el, "locale"), timeZone: xr(this.el, "timeZone"), disabled: _r(this.el, "disabled"), readOnly: _r(this.el, "readOnly"), required: _r(this.el, "required"), invalid: _r(this.el, "invalid"), outsideDaySelectable: _r(this.el, "outsideDaySelectable"), closeOnSelect: _r(this.el, "closeOnSelect"), min: r3 ? L7(r3) : void 0, max: n ? L7(n) : void 0, numOfMonths: Lr(this.el, "numOfMonths"), startOfWeek: Lr(this.el, "startOfWeek"), fixedWeeks: _r(this.el, "fixedWeeks"), selectionMode: xr(this.el, "selectionMode", ["single", "multiple", "range"]), placeholder: xr(this.el, "placeholder"), minView: xr(this.el, "minView", ["day", "month", "year"]), maxView: xr(this.el, "maxView", ["day", "month", "year"]), inline: _r(this.el, "inline"), positioning: o2 ? JSON.parse(o2) : void 0 })), s && this.datePicker) {
          let u3 = Cr(e4, "value"), p4 = (_b = u3 == null ? void 0 : u3.join(",")) != null ? _b : "", h6 = this.datePicker.api.value, f4 = (h6 == null ? void 0 : h6.length) ? h6.map((m5) => vr2(m5)).join(",") : "";
          if (p4 !== f4) {
            let m5 = (u3 == null ? void 0 : u3.length) ? u3.map(($13) => L7($13)) : [];
            this.datePicker.api.setValue(m5);
          }
        }
      }, destroyed() {
        var _a2;
        if (this.onSetValue && this.el.removeEventListener("phx:date-picker:set-value", this.onSetValue), this.handlers) for (let e4 of this.handlers) this.removeHandleEvent(e4);
        (_a2 = this.datePicker) == null ? void 0 : _a2.destroy();
      } };
    }
  });

  // ../priv/static/dialog.mjs
  var dialog_exports = {};
  __export(dialog_exports, {
    Dialog: () => vt5
  });
  function ue5(e4, s = {}) {
    let { defer: i = true } = s, t = i ? De3 : (a3) => a3(), o2 = [];
    return o2.push(t(() => {
      let r3 = (typeof e4 == "function" ? e4() : e4).filter(Boolean);
      r3.length !== 0 && o2.push(Ie4(r3));
    })), () => {
      o2.forEach((a3) => a3 == null ? void 0 : a3());
    };
  }
  function fe4(e4, s = {}) {
    let i, t = nt(() => {
      let a3 = (Array.isArray(e4) ? e4 : [e4]).map((n) => typeof n == "function" ? n() : n).filter((n) => n != null);
      if (a3.length === 0) return;
      let r3 = a3[0];
      i = new Ae3(a3, __spreadProps(__spreadValues({ escapeDeactivates: false, allowOutsideClick: true, preventScroll: true, returnFocusOnDeactivate: true, delayInitialFocus: false, fallbackFocus: r3 }, s), { document: q(r3) }));
      try {
        i.activate();
      } catch (e5) {
      }
    });
    return function() {
      i == null ? void 0 : i.deactivate(), t();
    };
  }
  function Me4(e4) {
    let s = e4.getBoundingClientRect().left;
    return Math.round(s) + e4.scrollLeft ? "paddingLeft" : "paddingRight";
  }
  function ge5(e4) {
    var _a2;
    let i = (_a2 = zr(e4)) == null ? void 0 : _a2.scrollbarGutter;
    return i === "stable" || (i == null ? void 0 : i.startsWith("stable ")) === true;
  }
  function be3(e4) {
    var _a2;
    let s = e4 != null ? e4 : document, i = (_a2 = s.defaultView) != null ? _a2 : window, { documentElement: t, body: o2 } = s;
    if (o2.hasAttribute($8)) return;
    let r3 = ge5(t) || ge5(o2), n = i.innerWidth - t.clientWidth;
    o2.setAttribute($8, "");
    let d4 = () => ko(t, "--scrollbar-width", `${n}px`), l4 = Me4(t), u3 = () => {
      let c5 = { overflow: "hidden" };
      return !r3 && n > 0 && (c5[l4] = `${n}px`), No(o2, c5);
    }, f4 = () => {
      var _a3, _b;
      let { scrollX: c5, scrollY: h6, visualViewport: v10 } = i, P11 = (_a3 = v10 == null ? void 0 : v10.offsetLeft) != null ? _a3 : 0, I11 = (_b = v10 == null ? void 0 : v10.offsetTop) != null ? _b : 0, C17 = { position: "fixed", overflow: "hidden", top: `${-(h6 - Math.floor(I11))}px`, left: `${-(c5 - Math.floor(P11))}px`, right: "0" };
      !r3 && n > 0 && (C17[l4] = `${n}px`);
      let Ne6 = No(o2, C17);
      return () => {
        Ne6 == null ? void 0 : Ne6(), i.scrollTo({ left: c5, top: h6, behavior: "instant" });
      };
    }, b10 = [d4(), At() ? f4() : u3()];
    return () => {
      b10.forEach((c5) => c5 == null ? void 0 : c5()), o2.removeAttribute($8);
    };
  }
  function Oe4(e4, s) {
    let { state: i, send: t, context: o2, prop: a3, scope: r3 } = e4, n = a3("aria-label"), d4 = i.matches("open");
    return { open: d4, setOpen(l4) {
      i.matches("open") !== l4 && t({ type: l4 ? "OPEN" : "CLOSE" });
    }, getTriggerProps() {
      return s.button(__spreadProps(__spreadValues({}, y6.trigger.attrs), { dir: a3("dir"), id: ye5(r3), "aria-haspopup": "dialog", type: "button", "aria-expanded": d4, "data-state": d4 ? "open" : "closed", "aria-controls": V10(r3), onClick(l4) {
        l4.defaultPrevented || t({ type: "TOGGLE" });
      } }));
    }, getBackdropProps() {
      return s.element(__spreadProps(__spreadValues({}, y6.backdrop.attrs), { dir: a3("dir"), hidden: !d4, id: me4(r3), "data-state": d4 ? "open" : "closed" }));
    }, getPositionerProps() {
      return s.element(__spreadProps(__spreadValues({}, y6.positioner.attrs), { dir: a3("dir"), id: ve2(r3), style: { pointerEvents: d4 ? void 0 : "none" } }));
    }, getContentProps() {
      let l4 = o2.get("rendered");
      return s.element(__spreadProps(__spreadValues({}, y6.content.attrs), { dir: a3("dir"), role: a3("role"), hidden: !d4, id: V10(r3), tabIndex: -1, "data-state": d4 ? "open" : "closed", "aria-modal": true, "aria-label": n || void 0, "aria-labelledby": n || !l4.title ? void 0 : q9(r3), "aria-describedby": l4.description ? W10(r3) : void 0 }));
    }, getTitleProps() {
      return s.element(__spreadProps(__spreadValues({}, y6.title.attrs), { dir: a3("dir"), id: q9(r3) }));
    }, getDescriptionProps() {
      return s.element(__spreadProps(__spreadValues({}, y6.description.attrs), { dir: a3("dir"), id: W10(r3) }));
    }, getCloseTriggerProps() {
      return s.button(__spreadProps(__spreadValues({}, y6.closeTrigger.attrs), { dir: a3("dir"), id: Ee4(r3), type: "button", onClick(l4) {
        l4.defaultPrevented || (l4.stopPropagation(), t({ type: "CLOSE" }));
      } }));
    } };
  }
  var O7, L8, A7, M5, de5, Fe5, Te4, we3, ke5, Pe5, Ie4, De3, Se5, xe4, p3, pe6, Le5, Ae3, K12, _8, Ge5, Re3, k8, Be5, he4, He5, $8, _e5, y6, ve2, me4, V10, ye5, q9, W10, Ee4, G9, Ke5, $e5, Ve6, qe5, We5, je5, Ce4, Ue4, ct5, R3, vt5;
  var init_dialog = __esm({
    "../priv/static/dialog.mjs"() {
      "use strict";
      init_chunk_5MNNWH4C();
      init_chunk_L4HS2GN2();
      init_chunk_IYURAQ6S();
      O7 = /* @__PURE__ */ new WeakMap();
      L8 = /* @__PURE__ */ new WeakMap();
      A7 = {};
      M5 = 0;
      de5 = (e4) => e4 && (e4.host || de5(e4.parentNode));
      Fe5 = (e4, s) => s.map((i) => {
        if (e4.contains(i)) return i;
        let t = de5(i);
        return t && e4.contains(t) ? t : (console.error("[zag-js > ariaHidden] target", i, "in not contained inside", e4, ". Doing nothing"), null);
      }).filter((i) => !!i);
      Te4 = /* @__PURE__ */ new Set(["script", "output", "status", "next-route-announcer"]);
      we3 = (e4) => Te4.has(e4.localName) || e4.role === "status" || e4.hasAttribute("aria-live") ? true : e4.matches("[data-live-announcer]");
      ke5 = (e4, s) => {
        let { parentNode: i, markerName: t, controlAttribute: o2, followControlledElements: a3 = true } = s, r3 = Fe5(i, Array.isArray(e4) ? e4 : [e4]);
        A7[t] || (A7[t] = /* @__PURE__ */ new WeakMap());
        let n = A7[t], d4 = [], l4 = /* @__PURE__ */ new Set(), u3 = new Set(r3), f4 = (c5) => {
          !c5 || l4.has(c5) || (l4.add(c5), f4(c5.parentNode));
        };
        r3.forEach((c5) => {
          f4(c5), a3 && S(c5) && Fe(c5, (h6) => {
            f4(h6);
          });
        });
        let b10 = (c5) => {
          !c5 || u3.has(c5) || Array.prototype.forEach.call(c5.children, (h6) => {
            if (l4.has(h6)) b10(h6);
            else try {
              if (we3(h6)) return;
              let P11 = h6.getAttribute(o2) === "true", I11 = (O7.get(h6) || 0) + 1, C17 = (n.get(h6) || 0) + 1;
              O7.set(h6, I11), n.set(h6, C17), d4.push(h6), I11 === 1 && P11 && L8.set(h6, true), C17 === 1 && h6.setAttribute(t, ""), P11 || h6.setAttribute(o2, "true");
            } catch (v10) {
              console.error("[zag-js > ariaHidden] cannot operate on ", h6, v10);
            }
          });
        };
        return b10(i), l4.clear(), M5++, () => {
          d4.forEach((c5) => {
            let h6 = O7.get(c5) - 1, v10 = n.get(c5) - 1;
            O7.set(c5, h6), n.set(c5, v10), h6 || (L8.has(c5) || c5.removeAttribute(o2), L8.delete(c5)), v10 || c5.removeAttribute(t);
          }), M5--, M5 || (O7 = /* @__PURE__ */ new WeakMap(), O7 = /* @__PURE__ */ new WeakMap(), L8 = /* @__PURE__ */ new WeakMap(), A7 = {});
        };
      };
      Pe5 = (e4) => (Array.isArray(e4) ? e4[0] : e4).ownerDocument.body;
      Ie4 = (e4, s = Pe5(e4), i = "data-aria-hidden", t = true) => {
        if (s) return ke5(e4, { parentNode: s, markerName: i, controlAttribute: "aria-hidden", followControlledElements: t });
      };
      De3 = (e4) => {
        let s = requestAnimationFrame(() => e4());
        return () => cancelAnimationFrame(s);
      };
      Se5 = Object.defineProperty;
      xe4 = (e4, s, i) => s in e4 ? Se5(e4, s, { enumerable: true, configurable: true, writable: true, value: i }) : e4[s] = i;
      p3 = (e4, s, i) => xe4(e4, typeof s != "symbol" ? s + "" : s, i);
      pe6 = { activateTrap(e4, s) {
        if (e4.length > 0) {
          let t = e4[e4.length - 1];
          t !== s && t.pause();
        }
        let i = e4.indexOf(s);
        i === -1 || e4.splice(i, 1), e4.push(s);
      }, deactivateTrap(e4, s) {
        let i = e4.indexOf(s);
        i !== -1 && e4.splice(i, 1), e4.length > 0 && e4[e4.length - 1].unpause();
      } };
      Le5 = [];
      Ae3 = class {
        constructor(e4, s) {
          p3(this, "trapStack"), p3(this, "config"), p3(this, "doc"), p3(this, "state", { containers: [], containerGroups: [], tabbableGroups: [], nodeFocusedBeforeActivation: null, mostRecentlyFocusedNode: null, active: false, paused: false, delayInitialFocusTimer: void 0, recentNavEvent: void 0 }), p3(this, "portalContainers", /* @__PURE__ */ new Set()), p3(this, "listenerCleanups", []), p3(this, "handleFocus", (t) => {
            let o2 = Je(t), a3 = this.findContainerIndex(o2, t) >= 0;
            if (a3 || yt(o2)) a3 && (this.state.mostRecentlyFocusedNode = o2);
            else {
              t.stopImmediatePropagation();
              let r3, n = true;
              if (this.state.mostRecentlyFocusedNode) if (fo(this.state.mostRecentlyFocusedNode) > 0) {
                let d4 = this.findContainerIndex(this.state.mostRecentlyFocusedNode), { tabbableNodes: l4 } = this.state.containerGroups[d4];
                if (l4.length > 0) {
                  let u3 = l4.findIndex((f4) => f4 === this.state.mostRecentlyFocusedNode);
                  u3 >= 0 && (this.config.isKeyForward(this.state.recentNavEvent) ? u3 + 1 < l4.length && (r3 = l4[u3 + 1], n = false) : u3 - 1 >= 0 && (r3 = l4[u3 - 1], n = false));
                }
              } else this.state.containerGroups.some((d4) => d4.tabbableNodes.some((l4) => fo(l4) > 0)) || (n = false);
              else n = false;
              n && (r3 = this.findNextNavNode({ target: this.state.mostRecentlyFocusedNode, isBackward: this.config.isKeyBackward(this.state.recentNavEvent) })), r3 ? this.tryFocus(r3) : this.tryFocus(this.state.mostRecentlyFocusedNode || this.getInitialFocusNode());
            }
            this.state.recentNavEvent = void 0;
          }), p3(this, "handlePointerDown", (t) => {
            let o2 = Je(t);
            if (!(this.findContainerIndex(o2, t) >= 0)) {
              if (k8(this.config.clickOutsideDeactivates, t)) {
                this.deactivate({ returnFocus: this.config.returnFocusOnDeactivate });
                return;
              }
              k8(this.config.allowOutsideClick, t) || t.preventDefault();
            }
          }), p3(this, "handleClick", (t) => {
            let o2 = Je(t);
            this.findContainerIndex(o2, t) >= 0 || k8(this.config.clickOutsideDeactivates, t) || k8(this.config.allowOutsideClick, t) || (t.preventDefault(), t.stopImmediatePropagation());
          }), p3(this, "handleTabKey", (t) => {
            if (this.config.isKeyForward(t) || this.config.isKeyBackward(t)) {
              this.state.recentNavEvent = t;
              let o2 = this.config.isKeyBackward(t), a3 = this.findNextNavNode({ event: t, isBackward: o2 });
              if (!a3) return;
              _8(t) && t.preventDefault(), this.tryFocus(a3);
            }
          }), p3(this, "handleEscapeKey", (t) => {
            Be5(t) && k8(this.config.escapeDeactivates, t) !== false && (t.preventDefault(), this.deactivate());
          }), p3(this, "_mutationObserver"), p3(this, "setupMutationObserver", () => {
            let t = this.doc.defaultView || window;
            this._mutationObserver = new t.MutationObserver((o2) => {
              o2.some((n) => Array.from(n.removedNodes).some((l4) => l4 === this.state.mostRecentlyFocusedNode)) && this.tryFocus(this.getInitialFocusNode()), o2.some((n) => n.type === "attributes" && (n.attributeName === "aria-controls" || n.attributeName === "aria-expanded") ? true : n.type === "childList" && n.addedNodes.length > 0 ? Array.from(n.addedNodes).some((d4) => {
                if (d4.nodeType !== Node.ELEMENT_NODE) return false;
                let l4 = d4;
                return Hr(l4) ? true : l4.id && !this.state.containers.some((u3) => u3.contains(l4)) ? Ur(l4) : false;
              }) : false) && this.state.active && !this.state.paused && (this.updateTabbableNodes(), this.updatePortalContainers());
            });
          }), p3(this, "updateObservedNodes", () => {
            var _a2;
            (_a2 = this._mutationObserver) == null ? void 0 : _a2.disconnect(), this.state.active && !this.state.paused && (this.state.containers.map((t) => {
              var _a3;
              (_a3 = this._mutationObserver) == null ? void 0 : _a3.observe(t, { subtree: true, childList: true, attributes: true, attributeFilter: ["aria-controls", "aria-expanded"] });
            }), this.portalContainers.forEach((t) => {
              this.observePortalContainer(t);
            }));
          }), p3(this, "getInitialFocusNode", () => {
            let t = this.getNodeForOption("initialFocus", { hasFallback: true });
            if (t === false) return false;
            if (t === void 0 || t && !X(t)) {
              let o2 = bt(this.doc);
              if (o2 && this.findContainerIndex(o2) >= 0) t = o2;
              else {
                let a3 = this.state.tabbableGroups[0];
                t = a3 && a3.firstTabbableNode || this.getNodeForOption("fallbackFocus");
              }
            } else t === null && (t = this.getNodeForOption("fallbackFocus"));
            if (!t) throw new Error("Your focus-trap needs to have at least one focusable element");
            return t.isConnected || (t = this.getNodeForOption("fallbackFocus")), t;
          }), p3(this, "tryFocus", (t) => {
            if (t !== false && t !== bt(this.doc)) {
              if (!t || !t.focus) {
                this.tryFocus(this.getInitialFocusNode());
                return;
              }
              t.focus({ preventScroll: !!this.config.preventScroll }), this.state.mostRecentlyFocusedNode = t, He5(t) && t.select();
            }
          }), p3(this, "deactivate", (t) => {
            if (!this.state.active) return this;
            let o2 = __spreadValues({ onDeactivate: this.config.onDeactivate, onPostDeactivate: this.config.onPostDeactivate, checkCanReturnFocus: this.config.checkCanReturnFocus }, t);
            clearTimeout(this.state.delayInitialFocusTimer), this.state.delayInitialFocusTimer = void 0, this.removeListeners(), this.state.active = false, this.state.paused = false, this.updateObservedNodes(), pe6.deactivateTrap(this.trapStack, this), this.portalContainers.clear();
            let a3 = this.getOption(o2, "onDeactivate"), r3 = this.getOption(o2, "onPostDeactivate"), n = this.getOption(o2, "checkCanReturnFocus"), d4 = this.getOption(o2, "returnFocus", "returnFocusOnDeactivate");
            a3 == null ? void 0 : a3();
            let l4 = () => {
              he4(() => {
                if (d4) {
                  let u3 = this.getReturnFocusNode(this.state.nodeFocusedBeforeActivation);
                  this.tryFocus(u3);
                }
                r3 == null ? void 0 : r3();
              });
            };
            if (d4 && n) {
              let u3 = this.getReturnFocusNode(this.state.nodeFocusedBeforeActivation);
              return n(u3).then(l4, l4), this;
            }
            return l4(), this;
          }), p3(this, "pause", (t) => {
            if (this.state.paused || !this.state.active) return this;
            let o2 = this.getOption(t, "onPause"), a3 = this.getOption(t, "onPostPause");
            return this.state.paused = true, o2 == null ? void 0 : o2(), this.removeListeners(), this.updateObservedNodes(), a3 == null ? void 0 : a3(), this;
          }), p3(this, "unpause", (t) => {
            if (!this.state.paused || !this.state.active) return this;
            let o2 = this.getOption(t, "onUnpause"), a3 = this.getOption(t, "onPostUnpause");
            return this.state.paused = false, o2 == null ? void 0 : o2(), this.updateTabbableNodes(), this.addListeners(), this.updateObservedNodes(), a3 == null ? void 0 : a3(), this;
          }), p3(this, "updateContainerElements", (t) => (this.state.containers = Array.isArray(t) ? t.filter(Boolean) : [t].filter(Boolean), this.state.active && this.updateTabbableNodes(), this.updateObservedNodes(), this)), p3(this, "getReturnFocusNode", (t) => {
            let o2 = this.getNodeForOption("setReturnFocus", { params: [t] });
            return o2 || (o2 === false ? false : t);
          }), p3(this, "getOption", (t, o2, a3) => t && t[o2] !== void 0 ? t[o2] : this.config[a3 || o2]), p3(this, "getNodeForOption", (t, { hasFallback: o2 = false, params: a3 = [] } = {}) => {
            let r3 = this.config[t];
            if (typeof r3 == "function" && (r3 = r3(...a3)), r3 === true && (r3 = void 0), !r3) {
              if (r3 === void 0 || r3 === false) return r3;
              throw new Error(`\`${t}\` was specified but was not a node, or did not return a node`);
            }
            let n = r3;
            if (typeof r3 == "string") {
              try {
                n = this.doc.querySelector(r3);
              } catch (d4) {
                throw new Error(`\`${t}\` appears to be an invalid selector; error="${d4.message}"`);
              }
              if (!n && !o2) throw new Error(`\`${t}\` as selector refers to no known node`);
            }
            return n;
          }), p3(this, "findNextNavNode", (t) => {
            let { event: o2, isBackward: a3 = false } = t, r3 = t.target || Je(o2);
            this.updateTabbableNodes();
            let n = null;
            if (this.state.tabbableGroups.length > 0) {
              let d4 = this.findContainerIndex(r3, o2), l4 = d4 >= 0 ? this.state.containerGroups[d4] : void 0;
              if (d4 < 0) a3 ? n = this.state.tabbableGroups[this.state.tabbableGroups.length - 1].lastTabbableNode : n = this.state.tabbableGroups[0].firstTabbableNode;
              else if (a3) {
                let u3 = this.state.tabbableGroups.findIndex(({ firstTabbableNode: f4 }) => r3 === f4);
                if (u3 < 0 && ((l4 == null ? void 0 : l4.container) === r3 || X(r3) && !pt(r3) && !(l4 == null ? void 0 : l4.nextTabbableNode(r3, false))) && (u3 = d4), u3 >= 0) {
                  let f4 = u3 === 0 ? this.state.tabbableGroups.length - 1 : u3 - 1, b10 = this.state.tabbableGroups[f4];
                  n = fo(r3) >= 0 ? b10.lastTabbableNode : b10.lastDomTabbableNode;
                } else _8(o2) || (n = l4 == null ? void 0 : l4.nextTabbableNode(r3, false));
              } else {
                let u3 = this.state.tabbableGroups.findIndex(({ lastTabbableNode: f4 }) => r3 === f4);
                if (u3 < 0 && ((l4 == null ? void 0 : l4.container) === r3 || X(r3) && !pt(r3) && !(l4 == null ? void 0 : l4.nextTabbableNode(r3))) && (u3 = d4), u3 >= 0) {
                  let f4 = u3 === this.state.tabbableGroups.length - 1 ? 0 : u3 + 1, b10 = this.state.tabbableGroups[f4];
                  n = fo(r3) >= 0 ? b10.firstTabbableNode : b10.firstDomTabbableNode;
                } else _8(o2) || (n = l4 == null ? void 0 : l4.nextTabbableNode(r3));
              }
            } else n = this.getNodeForOption("fallbackFocus");
            return n;
          }), this.trapStack = s.trapStack || Le5;
          let i = __spreadValues({ returnFocusOnDeactivate: true, escapeDeactivates: true, delayInitialFocus: true, followControlledElements: true, isKeyForward: Ge5, isKeyBackward: Re3 }, s);
          this.doc = i.document || q(Array.isArray(e4) ? e4[0] : e4), this.config = i, this.updateContainerElements(e4), this.setupMutationObserver();
        }
        addPortalContainer(e4) {
          let s = e4.parentElement;
          s && !this.portalContainers.has(s) && (this.portalContainers.add(s), this.state.active && !this.state.paused && this.observePortalContainer(s));
        }
        observePortalContainer(e4) {
          var _a2;
          (_a2 = this._mutationObserver) == null ? void 0 : _a2.observe(e4, { subtree: true, childList: true, attributes: true, attributeFilter: ["aria-controls", "aria-expanded"] });
        }
        updatePortalContainers() {
          this.config.followControlledElements && this.state.containers.forEach((e4) => {
            qr(e4).forEach((i) => {
              this.addPortalContainer(i);
            });
          });
        }
        get active() {
          return this.state.active;
        }
        get paused() {
          return this.state.paused;
        }
        findContainerIndex(e4, s) {
          let i = typeof (s == null ? void 0 : s.composedPath) == "function" ? s.composedPath() : void 0;
          return this.state.containerGroups.findIndex(({ container: t, tabbableNodes: o2 }) => t.contains(e4) || (i == null ? void 0 : i.includes(t)) || o2.find((a3) => a3 === e4) || this.isControlledElement(t, e4));
        }
        isControlledElement(e4, s) {
          return this.config.followControlledElements ? Wr(e4, s) : false;
        }
        updateTabbableNodes() {
          if (this.state.containerGroups = this.state.containers.map((e4) => {
            let s = Pt(e4, { getShadowRoot: this.config.getShadowRoot }), i = mn(e4, { getShadowRoot: this.config.getShadowRoot }), t = s[0], o2 = s[s.length - 1], a3 = t, r3 = o2, n = false;
            for (let l4 = 0; l4 < s.length; l4++) if (fo(s[l4]) > 0) {
              n = true;
              break;
            }
            function d4(l4, u3 = true) {
              let f4 = s.indexOf(l4);
              if (f4 >= 0) return s[f4 + (u3 ? 1 : -1)];
              let b10 = i.indexOf(l4);
              if (!(b10 < 0)) {
                if (u3) {
                  for (let c5 = b10 + 1; c5 < i.length; c5++) if (pt(i[c5])) return i[c5];
                } else for (let c5 = b10 - 1; c5 >= 0; c5--) if (pt(i[c5])) return i[c5];
              }
            }
            return { container: e4, tabbableNodes: s, focusableNodes: i, posTabIndexesFound: n, firstTabbableNode: t, lastTabbableNode: o2, firstDomTabbableNode: a3, lastDomTabbableNode: r3, nextTabbableNode: d4 };
          }), this.state.tabbableGroups = this.state.containerGroups.filter((e4) => e4.tabbableNodes.length > 0), this.state.tabbableGroups.length <= 0 && !this.getNodeForOption("fallbackFocus")) throw new Error("Your focus-trap must have at least one container with at least one tabbable node in it at all times");
          if (this.state.containerGroups.find((e4) => e4.posTabIndexesFound) && this.state.containerGroups.length > 1) throw new Error("At least one node with a positive tabindex was found in one of your focus-trap's multiple containers. Positive tabindexes are only supported in single-container focus-traps.");
        }
        addListeners() {
          if (this.state.active) return pe6.activateTrap(this.trapStack, this), this.state.delayInitialFocusTimer = this.config.delayInitialFocus ? he4(() => {
            this.tryFocus(this.getInitialFocusNode());
          }) : this.tryFocus(this.getInitialFocusNode()), this.listenerCleanups.push(P(this.doc, "focusin", this.handleFocus, true), P(this.doc, "mousedown", this.handlePointerDown, { capture: true, passive: false }), P(this.doc, "touchstart", this.handlePointerDown, { capture: true, passive: false }), P(this.doc, "click", this.handleClick, { capture: true, passive: false }), P(this.doc, "keydown", this.handleTabKey, { capture: true, passive: false }), P(this.doc, "keydown", this.handleEscapeKey)), this;
        }
        removeListeners() {
          if (this.state.active) return this.listenerCleanups.forEach((e4) => e4()), this.listenerCleanups = [], this;
        }
        activate(e4) {
          if (this.state.active) return this;
          let s = this.getOption(e4, "onActivate"), i = this.getOption(e4, "onPostActivate"), t = this.getOption(e4, "checkCanFocusTrap");
          t || this.updateTabbableNodes(), this.state.active = true, this.state.paused = false, this.state.nodeFocusedBeforeActivation = bt(this.doc), s == null ? void 0 : s();
          let o2 = () => {
            t && this.updateTabbableNodes(), this.addListeners(), this.updateObservedNodes(), i == null ? void 0 : i();
          };
          return t ? (t(this.state.containers.concat()).then(o2, o2), this) : (o2(), this);
        }
      };
      K12 = (e4) => e4.type === "keydown";
      _8 = (e4) => K12(e4) && (e4 == null ? void 0 : e4.key) === "Tab";
      Ge5 = (e4) => K12(e4) && e4.key === "Tab" && !(e4 == null ? void 0 : e4.shiftKey);
      Re3 = (e4) => K12(e4) && e4.key === "Tab" && (e4 == null ? void 0 : e4.shiftKey);
      k8 = (e4, ...s) => typeof e4 == "function" ? e4(...s) : e4;
      Be5 = (e4) => !e4.isComposing && e4.key === "Escape";
      he4 = (e4) => setTimeout(e4, 0);
      He5 = (e4) => e4.localName === "input" && "select" in e4 && typeof e4.select == "function";
      $8 = "data-scroll-lock";
      _e5 = G("dialog").parts("trigger", "backdrop", "positioner", "content", "title", "description", "closeTrigger");
      y6 = _e5.build();
      ve2 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.positioner) != null ? _b : `dialog:${e4.id}:positioner`;
      };
      me4 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.backdrop) != null ? _b : `dialog:${e4.id}:backdrop`;
      };
      V10 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.content) != null ? _b : `dialog:${e4.id}:content`;
      };
      ye5 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.trigger) != null ? _b : `dialog:${e4.id}:trigger`;
      };
      q9 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.title) != null ? _b : `dialog:${e4.id}:title`;
      };
      W10 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.description) != null ? _b : `dialog:${e4.id}:description`;
      };
      Ee4 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.closeTrigger) != null ? _b : `dialog:${e4.id}:close`;
      };
      G9 = (e4) => e4.getById(V10(e4));
      Ke5 = (e4) => e4.getById(ve2(e4));
      $e5 = (e4) => e4.getById(me4(e4));
      Ve6 = (e4) => e4.getById(ye5(e4));
      qe5 = (e4) => e4.getById(q9(e4));
      We5 = (e4) => e4.getById(W10(e4));
      je5 = (e4) => e4.getById(Ee4(e4));
      Ce4 = { props({ props: e4, scope: s }) {
        let i = e4.role === "alertdialog", t = i ? () => je5(s) : void 0, o2 = typeof e4.modal == "boolean" ? e4.modal : true;
        return __spreadValues({ role: "dialog", modal: o2, trapFocus: o2, preventScroll: o2, closeOnInteractOutside: !i, closeOnEscape: true, restoreFocus: true, initialFocusEl: t }, e4);
      }, initialState({ prop: e4 }) {
        return e4("open") || e4("defaultOpen") ? "open" : "closed";
      }, context({ bindable: e4 }) {
        return { rendered: e4(() => ({ defaultValue: { title: true, description: true } })) };
      }, watch({ track: e4, action: s, prop: i }) {
        e4([() => i("open")], () => {
          s(["toggleVisibility"]);
        });
      }, states: { open: { entry: ["checkRenderedElements", "syncZIndex"], effects: ["trackDismissableElement", "trapFocus", "preventScroll", "hideContentBelow"], on: { "CONTROLLED.CLOSE": { target: "closed" }, CLOSE: [{ guard: "isOpenControlled", actions: ["invokeOnClose"] }, { target: "closed", actions: ["invokeOnClose"] }], TOGGLE: [{ guard: "isOpenControlled", actions: ["invokeOnClose"] }, { target: "closed", actions: ["invokeOnClose"] }] } }, closed: { on: { "CONTROLLED.OPEN": { target: "open" }, OPEN: [{ guard: "isOpenControlled", actions: ["invokeOnOpen"] }, { target: "open", actions: ["invokeOnOpen"] }], TOGGLE: [{ guard: "isOpenControlled", actions: ["invokeOnOpen"] }, { target: "open", actions: ["invokeOnOpen"] }] } } }, implementations: { guards: { isOpenControlled: ({ prop: e4 }) => e4("open") != null }, effects: { trackDismissableElement({ scope: e4, send: s, prop: i }) {
        return H9(() => G9(e4), { type: "dialog", defer: true, pointerBlocking: i("modal"), exclude: [Ve6(e4)], onInteractOutside(o2) {
          var _a2;
          (_a2 = i("onInteractOutside")) == null ? void 0 : _a2(o2), i("closeOnInteractOutside") || o2.preventDefault();
        }, persistentElements: i("persistentElements"), onFocusOutside: i("onFocusOutside"), onPointerDownOutside: i("onPointerDownOutside"), onRequestDismiss: i("onRequestDismiss"), onEscapeKeyDown(o2) {
          var _a2;
          (_a2 = i("onEscapeKeyDown")) == null ? void 0 : _a2(o2), i("closeOnEscape") || o2.preventDefault();
        }, onDismiss() {
          s({ type: "CLOSE", src: "interact-outside" });
        } });
      }, preventScroll({ scope: e4, prop: s }) {
        if (s("preventScroll")) return be3(e4.getDoc());
      }, trapFocus({ scope: e4, prop: s }) {
        return s("trapFocus") ? fe4(() => G9(e4), { preventScroll: true, returnFocusOnDeactivate: !!s("restoreFocus"), initialFocus: s("initialFocusEl"), setReturnFocus: (t) => {
          var _a2, _b;
          return (_b = (_a2 = s("finalFocusEl")) == null ? void 0 : _a2()) != null ? _b : t;
        }, getShadowRoot: true }) : void 0;
      }, hideContentBelow({ scope: e4, prop: s }) {
        return s("modal") ? ue5(() => [G9(e4)], { defer: true }) : void 0;
      } }, actions: { checkRenderedElements({ context: e4, scope: s }) {
        nt(() => {
          e4.set("rendered", { title: !!qe5(s), description: !!We5(s) });
        });
      }, syncZIndex({ scope: e4 }) {
        nt(() => {
          let s = G9(e4);
          if (!s) return;
          let i = zr(s);
          [Ke5(e4), $e5(e4)].forEach((o2) => {
            o2 == null ? void 0 : o2.style.setProperty("--z-index", i.zIndex), o2 == null ? void 0 : o2.style.setProperty("--layer-index", i.getPropertyValue("--layer-index"));
          });
        });
      }, invokeOnClose({ prop: e4 }) {
        var _a2;
        (_a2 = e4("onOpenChange")) == null ? void 0 : _a2({ open: false });
      }, invokeOnOpen({ prop: e4 }) {
        var _a2;
        (_a2 = e4("onOpenChange")) == null ? void 0 : _a2({ open: true });
      }, toggleVisibility({ prop: e4, send: s, event: i }) {
        s({ type: e4("open") ? "CONTROLLED.OPEN" : "CONTROLLED.CLOSE", previousEvent: i });
      } } } };
      Ue4 = As()(["aria-label", "closeOnEscape", "closeOnInteractOutside", "dir", "finalFocusEl", "getRootNode", "getRootNode", "id", "id", "ids", "initialFocusEl", "modal", "onEscapeKeyDown", "onFocusOutside", "onInteractOutside", "onOpenChange", "onPointerDownOutside", "onRequestDismiss", "defaultOpen", "open", "persistentElements", "preventScroll", "restoreFocus", "role", "trapFocus"]);
      ct5 = as(Ue4);
      R3 = class extends ve {
        initMachine(s) {
          return new Ls(Ce4, s);
        }
        initApi() {
          return Oe4(this.machine.service, Cs);
        }
        render() {
          let s = this.el, i = s.querySelector('[data-scope="dialog"][data-part="trigger"]');
          i && this.spreadProps(i, this.api.getTriggerProps());
          let t = s.querySelector('[data-scope="dialog"][data-part="backdrop"]');
          t && this.spreadProps(t, this.api.getBackdropProps());
          let o2 = s.querySelector('[data-scope="dialog"][data-part="positioner"]');
          o2 && this.spreadProps(o2, this.api.getPositionerProps());
          let a3 = s.querySelector('[data-scope="dialog"][data-part="content"]');
          a3 && this.spreadProps(a3, this.api.getContentProps());
          let r3 = s.querySelector('[data-scope="dialog"][data-part="title"]');
          r3 && this.spreadProps(r3, this.api.getTitleProps());
          let n = s.querySelector('[data-scope="dialog"][data-part="description"]');
          n && this.spreadProps(n, this.api.getDescriptionProps());
          let d4 = s.querySelector('[data-scope="dialog"][data-part="close-trigger"]');
          d4 && this.spreadProps(d4, this.api.getCloseTriggerProps());
        }
      };
      vt5 = { mounted() {
        let e4 = this.el, s = this.pushEvent.bind(this), i = new R3(e4, __spreadProps(__spreadValues({ id: e4.id }, _r(e4, "controlled") ? { open: _r(e4, "open") } : { defaultOpen: _r(e4, "defaultOpen") }), { modal: _r(e4, "modal"), closeOnInteractOutside: _r(e4, "closeOnInteractOutside"), closeOnEscape: _r(e4, "closeOnEscapeKeyDown"), preventScroll: _r(e4, "preventScroll"), restoreFocus: _r(e4, "restoreFocus"), dir: xr(e4, "dir", ["ltr", "rtl"]), onOpenChange: (t) => {
          let o2 = xr(e4, "onOpenChange");
          o2 && this.liveSocket.main.isConnected() && s(o2, { id: e4.id, open: t.open });
          let a3 = xr(e4, "onOpenChangeClient");
          a3 && e4.dispatchEvent(new CustomEvent(a3, { bubbles: true, detail: { id: e4.id, open: t.open } }));
        } }));
        i.init(), this.dialog = i, this.onSetOpen = (t) => {
          let { open: o2 } = t.detail;
          i.api.setOpen(o2);
        }, e4.addEventListener("phx:dialog:set-open", this.onSetOpen), this.handlers = [], this.handlers.push(this.handleEvent("dialog_set_open", (t) => {
          let o2 = t.dialog_id;
          o2 && o2 !== e4.id || i.api.setOpen(t.open);
        })), this.handlers.push(this.handleEvent("dialog_open", () => {
          this.pushEvent("dialog_open_response", { value: i.api.open });
        }));
      }, updated() {
        var _a2;
        (_a2 = this.dialog) == null ? void 0 : _a2.updateProps(__spreadProps(__spreadValues({ id: this.el.id }, _r(this.el, "controlled") ? { open: _r(this.el, "open") } : { defaultOpen: _r(this.el, "defaultOpen") }), { modal: _r(this.el, "modal"), closeOnInteractOutside: _r(this.el, "closeOnInteractOutside"), closeOnEscape: _r(this.el, "closeOnEscapeKeyDown"), preventScroll: _r(this.el, "preventScroll"), restoreFocus: _r(this.el, "restoreFocus"), dir: xr(this.el, "dir", ["ltr", "rtl"]) }));
      }, destroyed() {
        var _a2;
        if (this.onSetOpen && this.el.removeEventListener("phx:dialog:set-open", this.onSetOpen), this.handlers) for (let e4 of this.handlers) this.removeHandleEvent(e4);
        (_a2 = this.dialog) == null ? void 0 : _a2.destroy();
      } };
    }
  });

  // ../priv/static/editable.mjs
  var editable_exports = {};
  __export(editable_exports, {
    Editable: () => Oe5
  });
  function Q10(e4, t) {
    var _a2;
    let { state: i, context: u3, send: a3, prop: r3, scope: o2, computed: h6 } = e4, c5 = !!r3("disabled"), d4 = h6("isInteractive"), b10 = !!r3("readOnly"), I11 = !!r3("required"), E15 = !!r3("invalid"), f4 = !!r3("autoResize"), y11 = r3("translations"), v10 = i.matches("edit"), T7 = r3("placeholder"), M10 = typeof T7 == "string" ? { edit: T7, preview: T7 } : T7, C17 = u3.get("value"), O10 = C17.trim() === "", L13 = O10 ? (_a2 = M10 == null ? void 0 : M10.preview) != null ? _a2 : "" : C17;
    return { editing: v10, empty: O10, value: C17, valueText: L13, setValue(n) {
      a3({ type: "VALUE.SET", value: n, src: "setValue" });
    }, clearValue() {
      a3({ type: "VALUE.SET", value: "", src: "clearValue" });
    }, edit() {
      d4 && a3({ type: "EDIT" });
    }, cancel() {
      d4 && a3({ type: "CANCEL" });
    }, submit() {
      d4 && a3({ type: "SUBMIT" });
    }, getRootProps() {
      return t.element(__spreadProps(__spreadValues({}, g4.root.attrs), { id: ee6(o2), dir: r3("dir") }));
    }, getAreaProps() {
      return t.element(__spreadProps(__spreadValues({}, g4.area.attrs), { id: te4(o2), dir: r3("dir"), style: f4 ? { display: "inline-grid" } : void 0, "data-focus": jr(v10), "data-disabled": jr(c5), "data-placeholder-shown": jr(O10) }));
    }, getLabelProps() {
      return t.label(__spreadProps(__spreadValues({}, g4.label.attrs), { id: ie6(o2), dir: r3("dir"), htmlFor: S10(o2), "data-focus": jr(v10), "data-invalid": jr(E15), "data-required": jr(I11), onClick() {
        var _a3;
        if (v10) return;
        (_a3 = ae5(o2)) == null ? void 0 : _a3.focus({ preventScroll: true });
      } }));
    }, getInputProps() {
      return t.input(__spreadProps(__spreadValues({}, g4.input.attrs), { dir: r3("dir"), "aria-label": y11 == null ? void 0 : y11.input, name: r3("name"), form: r3("form"), id: S10(o2), hidden: f4 ? void 0 : !v10, placeholder: M10 == null ? void 0 : M10.edit, maxLength: r3("maxLength"), required: r3("required"), disabled: c5, "data-disabled": jr(c5), readOnly: b10, "data-readonly": jr(b10), "aria-invalid": Br(E15), "data-invalid": jr(E15), "data-autoresize": jr(f4), defaultValue: C17, size: f4 ? 1 : void 0, onChange(n) {
        a3({ type: "VALUE.SET", src: "input.change", value: n.currentTarget.value });
      }, onKeyDown(n) {
        if (n.defaultPrevented || to(n)) return;
        let A12 = { Escape() {
          a3({ type: "CANCEL" }), n.preventDefault();
        }, Enter(m5) {
          if (!h6("submitOnEnter")) return;
          let { localName: D11 } = m5.currentTarget;
          if (D11 === "textarea") {
            if (!(Ue() ? m5.metaKey : m5.ctrlKey)) return;
            a3({ type: "SUBMIT", src: "keydown.enter" });
            return;
          }
          D11 === "input" && !m5.shiftKey && !m5.metaKey && (a3({ type: "SUBMIT", src: "keydown.enter" }), m5.preventDefault());
        } }[n.key];
        A12 && A12(n);
      }, style: f4 ? { gridArea: "1 / 1 / auto / auto", visibility: v10 ? void 0 : "hidden" } : void 0 }));
    }, getPreviewProps() {
      return t.element(__spreadProps(__spreadValues({ id: W11(o2) }, g4.preview.attrs), { dir: r3("dir"), "data-placeholder-shown": jr(O10), "aria-readonly": Br(b10), "data-readonly": jr(c5), "data-disabled": jr(c5), "aria-disabled": Br(c5), "aria-invalid": Br(E15), "data-invalid": jr(E15), "aria-label": y11 == null ? void 0 : y11.edit, "data-autoresize": jr(f4), children: L13, hidden: f4 ? void 0 : v10, tabIndex: d4 ? 0 : void 0, onClick() {
        d4 && r3("activationMode") === "click" && a3({ type: "EDIT", src: "click" });
      }, onFocus() {
        d4 && r3("activationMode") === "focus" && a3({ type: "EDIT", src: "focus" });
      }, onDoubleClick(n) {
        n.defaultPrevented || d4 && r3("activationMode") === "dblclick" && a3({ type: "EDIT", src: "dblclick" });
      }, style: f4 ? { whiteSpace: "pre", gridArea: "1 / 1 / auto / auto", visibility: v10 ? "hidden" : void 0, overflow: "hidden", textOverflow: "ellipsis" } : void 0 }));
    }, getEditTriggerProps() {
      return t.button(__spreadProps(__spreadValues({}, g4.editTrigger.attrs), { id: J9(o2), dir: r3("dir"), "aria-label": y11 == null ? void 0 : y11.edit, hidden: v10, type: "button", disabled: c5, onClick(n) {
        n.defaultPrevented || d4 && a3({ type: "EDIT", src: "edit.click" });
      } }));
    }, getControlProps() {
      return t.element(__spreadProps(__spreadValues({ id: re3(o2) }, g4.control.attrs), { dir: r3("dir") }));
    }, getSubmitTriggerProps() {
      return t.button(__spreadProps(__spreadValues({}, g4.submitTrigger.attrs), { dir: r3("dir"), id: z6(o2), "aria-label": y11 == null ? void 0 : y11.submit, hidden: !v10, disabled: c5, type: "button", onClick(n) {
        n.defaultPrevented || d4 && a3({ type: "SUBMIT", src: "submit.click" });
      } }));
    }, getCancelTriggerProps() {
      return t.button(__spreadProps(__spreadValues({}, g4.cancelTrigger.attrs), { dir: r3("dir"), "aria-label": y11 == null ? void 0 : y11.cancel, id: G10(o2), hidden: !v10, type: "button", disabled: c5, onClick(n) {
        n.defaultPrevented || d4 && a3({ type: "CANCEL", src: "cancel.click" });
      } }));
    } };
  }
  var Z10, g4, ee6, te4, ie6, W11, S10, re3, z6, G10, J9, k9, ae5, ne5, oe5, le6, X8, de6, me5, se5, Y9, V11, Oe5;
  var init_editable = __esm({
    "../priv/static/editable.mjs"() {
      "use strict";
      init_chunk_L4HS2GN2();
      init_chunk_IYURAQ6S();
      Z10 = G("editable").parts("root", "area", "label", "preview", "input", "editTrigger", "submitTrigger", "cancelTrigger", "control");
      g4 = Z10.build();
      ee6 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.root) != null ? _b : `editable:${e4.id}`;
      };
      te4 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.area) != null ? _b : `editable:${e4.id}:area`;
      };
      ie6 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.label) != null ? _b : `editable:${e4.id}:label`;
      };
      W11 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.preview) != null ? _b : `editable:${e4.id}:preview`;
      };
      S10 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.input) != null ? _b : `editable:${e4.id}:input`;
      };
      re3 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.control) != null ? _b : `editable:${e4.id}:control`;
      };
      z6 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.submitTrigger) != null ? _b : `editable:${e4.id}:submit`;
      };
      G10 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.cancelTrigger) != null ? _b : `editable:${e4.id}:cancel`;
      };
      J9 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.editTrigger) != null ? _b : `editable:${e4.id}:edit`;
      };
      k9 = (e4) => e4.getById(S10(e4));
      ae5 = (e4) => e4.getById(W11(e4));
      ne5 = (e4) => e4.getById(z6(e4));
      oe5 = (e4) => e4.getById(G10(e4));
      le6 = (e4) => e4.getById(J9(e4));
      X8 = { props({ props: e4 }) {
        return __spreadProps(__spreadValues({ activationMode: "focus", submitMode: "both", defaultValue: "", selectOnFocus: true }, e4), { translations: __spreadValues({ input: "editable input", edit: "edit", submit: "submit", cancel: "cancel" }, e4.translations) });
      }, initialState({ prop: e4 }) {
        return e4("edit") || e4("defaultEdit") ? "edit" : "preview";
      }, entry: ["focusInputIfNeeded"], context: ({ bindable: e4, prop: t }) => ({ value: e4(() => ({ defaultValue: t("defaultValue"), value: t("value"), onChange(i) {
        var _a2;
        return (_a2 = t("onValueChange")) == null ? void 0 : _a2({ value: i });
      } })), previousValue: e4(() => ({ defaultValue: "" })) }), watch({ track: e4, action: t, context: i, prop: u3 }) {
        e4([() => i.get("value")], () => {
          t(["syncInputValue"]);
        }), e4([() => u3("edit")], () => {
          t(["toggleEditing"]);
        });
      }, computed: { submitOnEnter({ prop: e4 }) {
        let t = e4("submitMode");
        return t === "both" || t === "enter";
      }, submitOnBlur({ prop: e4 }) {
        let t = e4("submitMode");
        return t === "both" || t === "blur";
      }, isInteractive({ prop: e4 }) {
        return !(e4("disabled") || e4("readOnly"));
      } }, on: { "VALUE.SET": { actions: ["setValue"] } }, states: { preview: { entry: ["blurInput"], on: { "CONTROLLED.EDIT": { target: "edit", actions: ["setPreviousValue", "focusInput"] }, EDIT: [{ guard: "isEditControlled", actions: ["invokeOnEdit"] }, { target: "edit", actions: ["setPreviousValue", "focusInput", "invokeOnEdit"] }] } }, edit: { effects: ["trackInteractOutside"], entry: ["syncInputValue"], on: { "CONTROLLED.PREVIEW": [{ guard: "isSubmitEvent", target: "preview", actions: ["setPreviousValue", "restoreFocus", "invokeOnSubmit"] }, { target: "preview", actions: ["revertValue", "restoreFocus", "invokeOnCancel"] }], CANCEL: [{ guard: "isEditControlled", actions: ["invokeOnPreview"] }, { target: "preview", actions: ["revertValue", "restoreFocus", "invokeOnCancel", "invokeOnPreview"] }], SUBMIT: [{ guard: "isEditControlled", actions: ["invokeOnPreview"] }, { target: "preview", actions: ["setPreviousValue", "restoreFocus", "invokeOnSubmit", "invokeOnPreview"] }] } } }, implementations: { guards: { isEditControlled: ({ prop: e4 }) => e4("edit") != null, isSubmitEvent: ({ event: e4 }) => {
        var _a2;
        return ((_a2 = e4.previousEvent) == null ? void 0 : _a2.type) === "SUBMIT";
      } }, effects: { trackInteractOutside({ send: e4, scope: t, prop: i, computed: u3 }) {
        return tt5(k9(t), { exclude(a3) {
          return [oe5(t), ne5(t)].some((o2) => Ie(o2, a3));
        }, onFocusOutside: i("onFocusOutside"), onPointerDownOutside: i("onPointerDownOutside"), onInteractOutside(a3) {
          var _a2;
          if ((_a2 = i("onInteractOutside")) == null ? void 0 : _a2(a3), a3.defaultPrevented) return;
          let { focusable: r3 } = a3.detail;
          e4({ type: u3("submitOnBlur") ? "SUBMIT" : "CANCEL", src: "interact-outside", focusable: r3 });
        } });
      } }, actions: { restoreFocus({ event: e4, scope: t, prop: i }) {
        e4.focusable || nt(() => {
          var _a2, _b, _c;
          (_c = (_b = (_a2 = i("finalFocusEl")) == null ? void 0 : _a2()) != null ? _b : le6(t)) == null ? void 0 : _c.focus({ preventScroll: true });
        });
      }, clearValue({ context: e4 }) {
        e4.set("value", "");
      }, focusInputIfNeeded({ action: e4, prop: t }) {
        (t("edit") || t("defaultEdit")) && e4(["focusInput"]);
      }, focusInput({ scope: e4, prop: t }) {
        nt(() => {
          let i = k9(e4);
          i && (t("selectOnFocus") ? i.select() : i.focus({ preventScroll: true }));
        });
      }, invokeOnCancel({ prop: e4, context: t }) {
        var _a2;
        let i = t.get("previousValue");
        (_a2 = e4("onValueRevert")) == null ? void 0 : _a2({ value: i });
      }, invokeOnSubmit({ prop: e4, context: t }) {
        var _a2;
        let i = t.get("value");
        (_a2 = e4("onValueCommit")) == null ? void 0 : _a2({ value: i });
      }, invokeOnEdit({ prop: e4 }) {
        var _a2;
        (_a2 = e4("onEditChange")) == null ? void 0 : _a2({ edit: true });
      }, invokeOnPreview({ prop: e4 }) {
        var _a2;
        (_a2 = e4("onEditChange")) == null ? void 0 : _a2({ edit: false });
      }, toggleEditing({ prop: e4, send: t, event: i }) {
        t({ type: e4("edit") ? "CONTROLLED.EDIT" : "CONTROLLED.PREVIEW", previousEvent: i });
      }, syncInputValue({ context: e4, scope: t }) {
        let i = k9(t);
        i && sn(i, e4.get("value"));
      }, setValue({ context: e4, prop: t, event: i }) {
        let u3 = t("maxLength"), a3 = u3 != null ? i.value.slice(0, u3) : i.value;
        e4.set("value", a3);
      }, setPreviousValue({ context: e4 }) {
        e4.set("previousValue", e4.get("value"));
      }, revertValue({ context: e4 }) {
        let t = e4.get("previousValue");
        t && e4.set("value", t);
      }, blurInput({ scope: e4 }) {
        var _a2;
        (_a2 = k9(e4)) == null ? void 0 : _a2.blur();
      } } } };
      de6 = As()(["activationMode", "autoResize", "dir", "disabled", "finalFocusEl", "form", "getRootNode", "id", "ids", "invalid", "maxLength", "name", "onEditChange", "onFocusOutside", "onInteractOutside", "onPointerDownOutside", "onValueChange", "onValueCommit", "onValueRevert", "placeholder", "readOnly", "required", "selectOnFocus", "edit", "defaultEdit", "submitMode", "translations", "defaultValue", "value"]);
      me5 = as(de6);
      se5 = ["root", "area", "label", "input", "preview", "edit-trigger", "submit-trigger", "cancel-trigger"];
      Y9 = '[data-scope="editable"][data-part]';
      V11 = class extends ve {
        initMachine(t) {
          return new Ls(X8, t);
        }
        initApi() {
          return Q10(this.machine.service, Cs);
        }
        render() {
          var _a2;
          for (let t of se5) {
            let i = t === "root" ? (_a2 = this.el.querySelector(`${Y9}[data-part="root"]`)) != null ? _a2 : this.el : this.el.querySelector(`${Y9}[data-part="${t}"]`);
            if (!i) continue;
            let u3 = this.getPartProps(t);
            u3 && this.spreadProps(i, u3);
          }
        }
        getPartProps(t) {
          switch (t) {
            case "root":
              return this.api.getRootProps();
            case "area":
              return this.api.getAreaProps();
            case "label":
              return this.api.getLabelProps();
            case "input":
              return this.api.getInputProps();
            case "preview":
              return this.api.getPreviewProps();
            case "edit-trigger":
              return this.api.getEditTriggerProps();
            case "submit-trigger":
              return this.api.getSubmitTriggerProps();
            case "cancel-trigger":
              return this.api.getCancelTriggerProps();
            default:
              return null;
          }
        }
      };
      Oe5 = { mounted() {
        let e4 = this.el, t = xr(e4, "value"), i = xr(e4, "defaultValue"), u3 = _r(e4, "controlled"), a3 = xr(e4, "placeholder"), r3 = xr(e4, "activationMode"), o2 = _r(e4, "selectOnFocus"), h6 = new V11(e4, __spreadProps(__spreadValues(__spreadValues(__spreadValues(__spreadValues(__spreadProps(__spreadValues({ id: e4.id }, u3 && t !== void 0 ? { value: t } : { defaultValue: i != null ? i : "" }), { disabled: _r(e4, "disabled"), readOnly: _r(e4, "readOnly"), required: _r(e4, "required"), invalid: _r(e4, "invalid"), name: xr(e4, "name"), form: xr(e4, "form"), dir: kr(e4) }), a3 !== void 0 ? { placeholder: a3 } : {}), r3 !== void 0 ? { activationMode: r3 } : {}), o2 !== void 0 ? { selectOnFocus: o2 } : {}), _r(e4, "controlledEdit") ? { edit: _r(e4, "edit") } : { defaultEdit: _r(e4, "defaultEdit") }), { onValueChange: (c5) => {
          let d4 = e4.querySelector('[data-scope="editable"][data-part="input"]');
          d4 && (d4.value = c5.value, d4.dispatchEvent(new Event("input", { bubbles: true })), d4.dispatchEvent(new Event("change", { bubbles: true })));
          let b10 = xr(e4, "onValueChange");
          b10 && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected() && this.pushEvent(b10, { value: c5.value, id: e4.id });
          let I11 = xr(e4, "onValueChangeClient");
          I11 && e4.dispatchEvent(new CustomEvent(I11, { bubbles: true, detail: { value: c5, id: e4.id } }));
        } }));
        h6.init(), this.editable = h6, this.handlers = [];
      }, updated() {
        var _a2;
        let e4 = xr(this.el, "value"), t = _r(this.el, "controlled");
        (_a2 = this.editable) == null ? void 0 : _a2.updateProps(__spreadProps(__spreadValues({ id: this.el.id }, t && e4 !== void 0 ? { value: e4 } : {}), { disabled: _r(this.el, "disabled"), readOnly: _r(this.el, "readOnly"), required: _r(this.el, "required"), invalid: _r(this.el, "invalid"), name: xr(this.el, "name"), form: xr(this.el, "form") }));
      }, destroyed() {
        var _a2;
        if (this.handlers) for (let e4 of this.handlers) this.removeHandleEvent(e4);
        (_a2 = this.editable) == null ? void 0 : _a2.destroy();
      } };
    }
  });

  // ../priv/static/floating-panel.mjs
  var floating_panel_exports = {};
  __export(floating_panel_exports, {
    FloatingPanel: () => Ye5
  });
  function ke6(e4) {
    switch (e4) {
      case "n":
        return { cursor: "n-resize", width: "100%", top: 0, left: "50%", translate: "-50%" };
      case "e":
        return { cursor: "e-resize", height: "100%", right: 0, top: "50%", translate: "0 -50%" };
      case "s":
        return { cursor: "s-resize", width: "100%", bottom: 0, left: "50%", translate: "-50%" };
      case "w":
        return { cursor: "w-resize", height: "100%", left: 0, top: "50%", translate: "0 -50%" };
      case "se":
        return { cursor: "se-resize", bottom: 0, right: 0 };
      case "sw":
        return { cursor: "sw-resize", bottom: 0, left: 0 };
      case "ne":
        return { cursor: "ne-resize", top: 0, right: 0 };
      case "nw":
        return { cursor: "nw-resize", top: 0, left: 0 };
      default:
        throw new Error(`Invalid axis: ${e4}`);
    }
  }
  function Oe6(e4, t) {
    let { state: s, send: i, scope: o2, prop: n, computed: a3, context: c5 } = e4, u3 = s.hasTag("open"), l4 = s.matches("open.dragging"), g7 = s.matches("open.resizing"), h6 = c5.get("isTopmost"), f4 = c5.get("size"), P11 = c5.get("position"), v10 = a3("isMaximized"), O10 = a3("isMinimized"), y11 = a3("isStaged"), L13 = a3("canResize"), H12 = a3("canDrag");
    return { open: u3, resizable: n("resizable"), draggable: n("draggable"), setOpen(r3) {
      s.hasTag("open") !== r3 && i({ type: r3 ? "OPEN" : "CLOSE" });
    }, dragging: l4, resizing: g7, position: P11, size: f4, setPosition(r3) {
      i({ type: "SET_POSITION", position: r3 });
    }, setSize(r3) {
      i({ type: "SET_SIZE", size: r3 });
    }, minimize() {
      i({ type: "MINIMIZE" });
    }, maximize() {
      i({ type: "MAXIMIZE" });
    }, restore() {
      i({ type: "RESTORE" });
    }, getTriggerProps() {
      return t.button(__spreadProps(__spreadValues({}, z7.trigger.attrs), { dir: n("dir"), type: "button", disabled: n("disabled"), id: Ee5(o2), "data-state": u3 ? "open" : "closed", "data-dragging": jr(l4), "aria-controls": K13(o2), onClick(r3) {
        if (r3.defaultPrevented || n("disabled")) return;
        let d4 = s.hasTag("open");
        i({ type: d4 ? "CLOSE" : "OPEN", src: "trigger" });
      } }));
    }, getPositionerProps() {
      return t.element(__spreadProps(__spreadValues({}, z7.positioner.attrs), { dir: n("dir"), id: Se6(o2), style: { "--width": is(f4 == null ? void 0 : f4.width), "--height": is(f4 == null ? void 0 : f4.height), "--x": is(P11 == null ? void 0 : P11.x), "--y": is(P11 == null ? void 0 : P11.y), position: n("strategy"), top: "var(--y)", left: "var(--x)" } }));
    }, getContentProps() {
      return t.element(__spreadProps(__spreadValues({}, z7.content.attrs), { dir: n("dir"), role: "dialog", tabIndex: 0, hidden: !u3, id: K13(o2), "aria-labelledby": he5(o2), "data-state": u3 ? "open" : "closed", "data-dragging": jr(l4), "data-topmost": jr(h6), "data-behind": jr(!h6), "data-minimized": jr(O10), "data-maximized": jr(v10), "data-staged": jr(y11), style: { width: "var(--width)", height: "var(--height)", overflow: O10 ? "hidden" : void 0 }, onFocus() {
        i({ type: "CONTENT_FOCUS" });
      }, onKeyDown(r3) {
        if (r3.defaultPrevented || r3.currentTarget !== Je(r3)) return;
        let d4 = co(r3) * n("gridSize"), M10 = { Escape() {
          h6 && i({ type: "ESCAPE" });
        }, ArrowLeft() {
          i({ type: "MOVE", direction: "left", step: d4 });
        }, ArrowRight() {
          i({ type: "MOVE", direction: "right", step: d4 });
        }, ArrowUp() {
          i({ type: "MOVE", direction: "up", step: d4 });
        }, ArrowDown() {
          i({ type: "MOVE", direction: "down", step: d4 });
        } }[io(r3, { dir: n("dir") })];
        M10 && (r3.preventDefault(), M10(r3));
      } }));
    }, getCloseTriggerProps() {
      return t.button(__spreadProps(__spreadValues({}, z7.closeTrigger.attrs), { dir: n("dir"), disabled: n("disabled"), "aria-label": "Close Window", type: "button", onClick(r3) {
        r3.defaultPrevented || i({ type: "CLOSE" });
      } }));
    }, getStageTriggerProps(r3) {
      if (!ze5.has(r3.stage)) throw new Error(`[zag-js] Invalid stage: ${r3.stage}. Must be one of: ${Array.from(ze5).join(", ")}`);
      let d4 = n("translations"), b10 = rr(r3.stage, { minimized: () => ({ "aria-label": d4.minimize, hidden: y11 }), maximized: () => ({ "aria-label": d4.maximize, hidden: y11 }), default: () => ({ "aria-label": d4.restore, hidden: !y11 }) });
      return t.button(__spreadProps(__spreadValues(__spreadProps(__spreadValues({}, z7.stageTrigger.attrs), { dir: n("dir"), disabled: n("disabled"), "data-stage": r3.stage }), b10), { type: "button", onClick(M10) {
        if (M10.defaultPrevented || !n("resizable")) return;
        let Te9 = rr(r3.stage, { minimized: () => "MINIMIZE", maximized: () => "MAXIMIZE", default: () => "RESTORE" });
        i({ type: Te9.toUpperCase() });
      } }));
    }, getResizeTriggerProps(r3) {
      return t.element(__spreadProps(__spreadValues({}, z7.resizeTrigger.attrs), { dir: n("dir"), "data-disabled": jr(!L13), "data-axis": r3.axis, onPointerDown(d4) {
        L13 && ro(d4) && (d4.currentTarget.setPointerCapture(d4.pointerId), d4.stopPropagation(), i({ type: "RESIZE_START", axis: r3.axis, position: { x: d4.clientX, y: d4.clientY } }));
      }, onPointerUp(d4) {
        if (!L13) return;
        let b10 = d4.currentTarget;
        b10.hasPointerCapture(d4.pointerId) && b10.releasePointerCapture(d4.pointerId);
      }, style: __spreadValues({ position: "absolute", touchAction: "none" }, ke6(r3.axis)) }));
    }, getDragTriggerProps() {
      return t.element(__spreadProps(__spreadValues({}, z7.dragTrigger.attrs), { dir: n("dir"), "data-disabled": jr(!H12), onPointerDown(r3) {
        if (!H12 || !ro(r3)) return;
        let d4 = Je(r3);
        (d4 == null ? void 0 : d4.closest("button")) || (d4 == null ? void 0 : d4.closest("[data-no-drag]")) || (r3.currentTarget.setPointerCapture(r3.pointerId), r3.stopPropagation(), i({ type: "DRAG_START", pointerId: r3.pointerId, position: { x: r3.clientX, y: r3.clientY } }));
      }, onPointerUp(r3) {
        if (!H12) return;
        let d4 = r3.currentTarget;
        d4.hasPointerCapture(r3.pointerId) && d4.releasePointerCapture(r3.pointerId);
      }, onDoubleClick(r3) {
        r3.defaultPrevented || n("resizable") && i({ type: y11 ? "RESTORE" : "MAXIMIZE" });
      }, style: { WebkitUserSelect: "none", userSelect: "none", touchAction: "none", cursor: "move" } }));
    }, getControlProps() {
      return t.element(__spreadProps(__spreadValues({}, z7.control.attrs), { dir: n("dir"), "data-disabled": jr(n("disabled")), "data-stage": c5.get("stage"), "data-minimized": jr(O10), "data-maximized": jr(v10), "data-staged": jr(y11) }));
    }, getTitleProps() {
      return t.element(__spreadProps(__spreadValues({}, z7.title.attrs), { dir: n("dir"), id: he5(o2) }));
    }, getHeaderProps() {
      return t.element(__spreadProps(__spreadValues({}, z7.header.attrs), { dir: n("dir"), id: ve3(o2), "data-dragging": jr(l4), "data-topmost": jr(h6), "data-behind": jr(!h6), "data-minimized": jr(O10), "data-maximized": jr(v10), "data-staged": jr(y11) }));
    }, getBodyProps() {
      return t.element(__spreadProps(__spreadValues({}, z7.body.attrs), { dir: n("dir"), "data-dragging": jr(l4), "data-minimized": jr(O10), "data-maximized": jr(v10), "data-staged": jr(y11), hidden: O10 }));
    } };
  }
  function A8(e4) {
    if (e4) try {
      let t = JSON.parse(e4);
      if (typeof t.width == "number" && typeof t.height == "number") return { width: t.width, height: t.height };
    } catch (e5) {
    }
  }
  function be4(e4) {
    if (e4) try {
      let t = JSON.parse(e4);
      if (typeof t.x == "number" && typeof t.y == "number") return { x: t.x, y: t.y };
    } catch (e5) {
    }
  }
  var Re4, z7, Ee5, Se6, K13, he5, ve3, fe5, me6, Pe6, we4, S11, ze5, k10, ye6, Me5, xe5, Ce5, Ie5, qe6, De4, Ve7, D7, Ye5;
  var init_floating_panel = __esm({
    "../priv/static/floating-panel.mjs"() {
      "use strict";
      init_chunk_UBXVV7GZ();
      init_chunk_IYURAQ6S();
      Re4 = G("floating-panel").parts("trigger", "positioner", "content", "header", "body", "title", "resizeTrigger", "dragTrigger", "stageTrigger", "closeTrigger", "control");
      z7 = Re4.build();
      Ee5 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.trigger) != null ? _b : `float:${e4.id}:trigger`;
      };
      Se6 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.positioner) != null ? _b : `float:${e4.id}:positioner`;
      };
      K13 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.content) != null ? _b : `float:${e4.id}:content`;
      };
      he5 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.title) != null ? _b : `float:${e4.id}:title`;
      };
      ve3 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.header) != null ? _b : `float:${e4.id}:header`;
      };
      fe5 = (e4) => e4.getById(Ee5(e4));
      me6 = (e4) => e4.getById(Se6(e4));
      Pe6 = (e4) => e4.getById(K13(e4));
      we4 = (e4) => e4.getById(ve3(e4));
      S11 = (e4, t, s) => {
        let i;
        return S(t) ? i = Z3(t) : i = nt2(e4.getWin()), s && (i = R({ x: -i.width, y: i.minY, width: i.width * 3, height: i.height * 2 })), cs(i, ["x", "y", "width", "height"]);
      };
      ze5 = /* @__PURE__ */ new Set(["minimized", "maximized", "default"]);
      k10 = Ct({ stack: [], count() {
        return this.stack.length;
      }, add(e4) {
        this.stack.includes(e4) || this.stack.push(e4);
      }, remove(e4) {
        let t = this.stack.indexOf(e4);
        t < 0 || this.stack.splice(t, 1);
      }, bringToFront(e4) {
        this.remove(e4), this.add(e4);
      }, isTopmost(e4) {
        return this.stack[this.stack.length - 1] === e4;
      }, indexOf(e4) {
        return this.stack.indexOf(e4);
      } });
      ({ not: ye6, and: Me5 } = dr());
      xe5 = { minimize: "Minimize window", maximize: "Maximize window", restore: "Restore window" };
      Ce5 = { props({ props: e4 }) {
        return hs(e4, ["id"], "floating-panel"), __spreadProps(__spreadValues({ strategy: "fixed", gridSize: 1, defaultSize: { width: 320, height: 240 }, defaultPosition: { x: 300, y: 100 }, allowOverflow: true, resizable: true, draggable: true }, e4), { hasSpecifiedPosition: !!e4.defaultPosition || !!e4.position, translations: __spreadValues(__spreadValues({}, xe5), e4.translations) });
      }, initialState({ prop: e4 }) {
        return e4("open") || e4("defaultOpen") ? "open" : "closed";
      }, context({ prop: e4, bindable: t }) {
        return { size: t(() => ({ defaultValue: e4("defaultSize"), value: e4("size"), isEqual: Q3, sync: true, hash(s) {
          return `W:${s.width} H:${s.height}`;
        }, onChange(s) {
          var _a2;
          (_a2 = e4("onSizeChange")) == null ? void 0 : _a2({ size: s });
        } })), position: t(() => ({ defaultValue: e4("defaultPosition"), value: e4("position"), isEqual: U2, sync: true, hash(s) {
          return `X:${s.x} Y:${s.y}`;
        }, onChange(s) {
          var _a2;
          (_a2 = e4("onPositionChange")) == null ? void 0 : _a2({ position: s });
        } })), stage: t(() => ({ defaultValue: "default", onChange(s) {
          var _a2;
          (_a2 = e4("onStageChange")) == null ? void 0 : _a2({ stage: s });
        } })), lastEventPosition: t(() => ({ defaultValue: null })), prevPosition: t(() => ({ defaultValue: null })), prevSize: t(() => ({ defaultValue: null })), isTopmost: t(() => ({ defaultValue: void 0 })) };
      }, computed: { isMaximized: ({ context: e4 }) => e4.get("stage") === "maximized", isMinimized: ({ context: e4 }) => e4.get("stage") === "minimized", isStaged: ({ context: e4 }) => e4.get("stage") !== "default", canResize: ({ context: e4, prop: t }) => t("resizable") && !t("disabled") && e4.get("stage") === "default", canDrag: ({ prop: e4, computed: t }) => e4("draggable") && !e4("disabled") && !t("isMaximized") }, watch({ track: e4, context: t, action: s, prop: i }) {
        e4([() => t.hash("position")], () => {
          s(["setPositionStyle"]);
        }), e4([() => t.hash("size")], () => {
          s(["setSizeStyle"]);
        }), e4([() => i("open")], () => {
          s(["toggleVisibility"]);
        });
      }, effects: ["trackPanelStack"], on: { CONTENT_FOCUS: { actions: ["bringToFrontOfPanelStack"] }, SET_POSITION: { actions: ["setPosition"] }, SET_SIZE: { actions: ["setSize"] } }, states: { closed: { tags: ["closed"], on: { "CONTROLLED.OPEN": { target: "open", actions: ["setAnchorPosition", "setPositionStyle", "setSizeStyle", "focusContentEl"] }, OPEN: [{ guard: "isOpenControlled", actions: ["invokeOnOpen"] }, { target: "open", actions: ["invokeOnOpen", "setAnchorPosition", "setPositionStyle", "setSizeStyle", "focusContentEl"] }] } }, open: { tags: ["open"], entry: ["bringToFrontOfPanelStack"], effects: ["trackBoundaryRect"], on: { DRAG_START: { guard: ye6("isMaximized"), target: "open.dragging", actions: ["setPrevPosition"] }, RESIZE_START: { guard: ye6("isMinimized"), target: "open.resizing", actions: ["setPrevSize"] }, "CONTROLLED.CLOSE": { target: "closed", actions: ["resetRect", "focusTriggerEl"] }, CLOSE: [{ guard: "isOpenControlled", target: "closed", actions: ["invokeOnClose"] }, { target: "closed", actions: ["invokeOnClose", "resetRect", "focusTriggerEl"] }], ESCAPE: [{ guard: Me5("isOpenControlled", "closeOnEsc"), actions: ["invokeOnClose"] }, { guard: "closeOnEsc", target: "closed", actions: ["invokeOnClose", "resetRect", "focusTriggerEl"] }], MINIMIZE: { actions: ["setMinimized"] }, MAXIMIZE: { actions: ["setMaximized"] }, RESTORE: { actions: ["setRestored"] }, MOVE: { actions: ["setPositionFromKeyboard"] } } }, "open.dragging": { tags: ["open"], effects: ["trackPointerMove"], exit: ["clearPrevPosition"], on: { DRAG: { actions: ["setPosition"] }, DRAG_END: { target: "open", actions: ["invokeOnDragEnd"] }, "CONTROLLED.CLOSE": { target: "closed", actions: ["resetRect"] }, CLOSE: [{ guard: "isOpenControlled", target: "closed", actions: ["invokeOnClose"] }, { target: "closed", actions: ["invokeOnClose", "resetRect"] }], ESCAPE: { target: "open" } } }, "open.resizing": { tags: ["open"], effects: ["trackPointerMove"], exit: ["clearPrevSize"], on: { DRAG: { actions: ["setSize"] }, DRAG_END: { target: "open", actions: ["invokeOnResizeEnd"] }, "CONTROLLED.CLOSE": { target: "closed", actions: ["resetRect"] }, CLOSE: [{ guard: "isOpenControlled", target: "closed", actions: ["invokeOnClose"] }, { target: "closed", actions: ["invokeOnClose", "resetRect"] }], ESCAPE: { target: "open" } } } }, implementations: { guards: { closeOnEsc: ({ prop: e4 }) => !!e4("closeOnEscape"), isMaximized: ({ context: e4 }) => e4.get("stage") === "maximized", isMinimized: ({ context: e4 }) => e4.get("stage") === "minimized", isOpenControlled: ({ prop: e4 }) => e4("open") != null }, effects: { trackPointerMove({ scope: e4, send: t, event: s, prop: i }) {
        var _a2;
        let o2 = e4.getDoc(), n = (_a2 = i("getBoundaryEl")) == null ? void 0 : _a2(), a3 = S11(e4, n, false);
        return Eo(o2, { onPointerMove({ point: c5, event: u3 }) {
          let { altKey: l4, shiftKey: g7 } = u3, h6 = ts(c5.x, a3.x, a3.x + a3.width), f4 = ts(c5.y, a3.y, a3.y + a3.height);
          t({ type: "DRAG", position: { x: h6, y: f4 }, axis: s.axis, altKey: l4, shiftKey: g7 });
        }, onPointerUp() {
          t({ type: "DRAG_END" });
        } });
      }, trackBoundaryRect({ context: e4, scope: t, prop: s, computed: i }) {
        var _a2;
        let o2 = t.getWin(), n = true, a3 = () => {
          var _a3;
          if (n) {
            n = false;
            return;
          }
          let u3 = (_a3 = s("getBoundaryEl")) == null ? void 0 : _a3(), l4 = S11(t, u3, false);
          if (!i("isMaximized")) {
            let g7 = __spreadValues(__spreadValues({}, e4.get("position")), e4.get("size"));
            l4 = K2(g7, l4);
          }
          e4.set("size", cs(l4, ["width", "height"])), e4.set("position", cs(l4, ["x", "y"]));
        }, c5 = (_a2 = s("getBoundaryEl")) == null ? void 0 : _a2();
        return S(c5) ? Ro.observe(c5, a3) : P(o2, "resize", a3);
      }, trackPanelStack({ context: e4, scope: t }) {
        let s = Lt(k10, () => {
          e4.set("isTopmost", k10.isTopmost(t.id));
          let i = Pe6(t);
          if (!i) return;
          let o2 = k10.indexOf(t.id);
          o2 !== -1 && i.style.setProperty("--z-index", `${o2 + 1}`);
        });
        return () => {
          k10.remove(t.id), s();
        };
      } }, actions: { setAnchorPosition({ context: e4, prop: t, scope: s }) {
        if (t("hasSpecifiedPosition")) return;
        let i = e4.get("prevPosition") || e4.get("prevSize");
        t("persistRect") && i || nt(() => {
          var _a2, _b;
          let o2 = fe5(s), n = S11(s, (_a2 = t("getBoundaryEl")) == null ? void 0 : _a2(), false), a3 = (_b = t("getAnchorPosition")) == null ? void 0 : _b({ triggerRect: o2 ? DOMRect.fromRect(Z3(o2)) : null, boundaryRect: DOMRect.fromRect(n) });
          if (!a3) {
            let c5 = e4.get("size");
            a3 = { x: n.x + (n.width - c5.width) / 2, y: n.y + (n.height - c5.height) / 2 };
          }
          a3 && e4.set("position", a3);
        });
      }, setPrevPosition({ context: e4, event: t }) {
        e4.set("prevPosition", __spreadValues({}, e4.get("position"))), e4.set("lastEventPosition", t.position);
      }, clearPrevPosition({ context: e4, prop: t }) {
        t("persistRect") || e4.set("prevPosition", null), e4.set("lastEventPosition", null);
      }, setPosition({ context: e4, event: t, prop: s, scope: i }) {
        var _a2;
        let o2 = G2(t.position, e4.get("lastEventPosition"));
        o2.x = Math.round(o2.x / s("gridSize")) * s("gridSize"), o2.y = Math.round(o2.y / s("gridSize")) * s("gridSize");
        let n = e4.get("prevPosition");
        if (!n) return;
        let a3 = J3(n, o2), c5 = (_a2 = s("getBoundaryEl")) == null ? void 0 : _a2(), u3 = S11(i, c5, s("allowOverflow"));
        a3 = L2(a3, e4.get("size"), u3), e4.set("position", a3);
      }, setPositionStyle({ scope: e4, context: t }) {
        let s = me6(e4), i = t.get("position");
        s == null ? void 0 : s.style.setProperty("--x", `${i.x}px`), s == null ? void 0 : s.style.setProperty("--y", `${i.y}px`);
      }, resetRect({ context: e4, prop: t }) {
        e4.set("stage", "default"), t("persistRect") || (e4.set("position", e4.initial("position")), e4.set("size", e4.initial("size")));
      }, setPrevSize({ context: e4, event: t }) {
        e4.set("prevSize", __spreadValues({}, e4.get("size"))), e4.set("prevPosition", __spreadValues({}, e4.get("position"))), e4.set("lastEventPosition", t.position);
      }, clearPrevSize({ context: e4 }) {
        e4.set("prevSize", null), e4.set("prevPosition", null), e4.set("lastEventPosition", null);
      }, setSize({ context: e4, event: t, scope: s, prop: i }) {
        var _a2;
        let o2 = e4.get("prevSize"), n = e4.get("prevPosition"), a3 = e4.get("lastEventPosition");
        if (!o2 || !n || !a3) return;
        let c5 = R(__spreadValues(__spreadValues({}, n), o2)), u3 = G2(t.position, a3), l4 = st2(c5, u3, t.axis, { scalingOriginMode: t.altKey ? "center" : "extent", lockAspectRatio: !!i("lockAspectRatio") || t.shiftKey }), g7 = cs(l4, ["width", "height"]), h6 = cs(l4, ["x", "y"]), f4 = (_a2 = i("getBoundaryEl")) == null ? void 0 : _a2(), P11 = S11(s, f4, false);
        if (g7 = k(g7, i("minSize"), i("maxSize")), g7 = k(g7, i("minSize"), P11), e4.set("size", g7), h6) {
          let v10 = L2(h6, g7, P11);
          e4.set("position", v10);
        }
      }, setSizeStyle({ scope: e4, context: t }) {
        queueMicrotask(() => {
          let s = me6(e4), i = t.get("size");
          s == null ? void 0 : s.style.setProperty("--width", `${i.width}px`), s == null ? void 0 : s.style.setProperty("--height", `${i.height}px`);
        });
      }, setMaximized({ context: e4, prop: t, scope: s }) {
        var _a2;
        e4.set("stage", "maximized"), e4.set("prevSize", e4.get("size")), e4.set("prevPosition", e4.get("position"));
        let i = (_a2 = t("getBoundaryEl")) == null ? void 0 : _a2(), o2 = S11(s, i, false);
        e4.set("position", cs(o2, ["x", "y"])), e4.set("size", cs(o2, ["height", "width"]));
      }, setMinimized({ context: e4, scope: t }) {
        e4.set("stage", "minimized"), e4.set("prevSize", e4.get("size")), e4.set("prevPosition", e4.get("position"));
        let s = we4(t);
        if (!s) return;
        let i = __spreadProps(__spreadValues({}, e4.get("size")), { height: s == null ? void 0 : s.offsetHeight });
        e4.set("size", i);
      }, setRestored({ context: e4, prop: t, scope: s }) {
        var _a2;
        let i = S11(s, (_a2 = t("getBoundaryEl")) == null ? void 0 : _a2(), false);
        e4.set("stage", "default");
        let o2 = e4.get("prevSize");
        if (o2) {
          let n = o2;
          n = k(n, t("minSize"), t("maxSize")), n = k(n, t("minSize"), i), e4.set("size", n), e4.set("prevSize", null);
        }
        if (e4.get("prevPosition")) {
          let n = e4.get("prevPosition");
          n = L2(n, e4.get("size"), i), e4.set("position", n), e4.set("prevPosition", null);
        }
      }, setPositionFromKeyboard({ context: e4, event: t, prop: s, scope: i }) {
        var _a2;
        fs(t.step == null, "step is required");
        let o2 = e4.get("position"), n = t.step, a3 = rr(t.direction, { left: { x: o2.x - n, y: o2.y }, right: { x: o2.x + n, y: o2.y }, up: { x: o2.x, y: o2.y - n }, down: { x: o2.x, y: o2.y + n } }), c5 = (_a2 = s("getBoundaryEl")) == null ? void 0 : _a2(), u3 = S11(i, c5, false);
        a3 = L2(a3, e4.get("size"), u3), e4.set("position", a3);
      }, bringToFrontOfPanelStack({ prop: e4 }) {
        k10.bringToFront(e4("id"));
      }, invokeOnOpen({ prop: e4 }) {
        var _a2;
        (_a2 = e4("onOpenChange")) == null ? void 0 : _a2({ open: true });
      }, invokeOnClose({ prop: e4 }) {
        var _a2;
        (_a2 = e4("onOpenChange")) == null ? void 0 : _a2({ open: false });
      }, invokeOnDragEnd({ context: e4, prop: t }) {
        var _a2;
        (_a2 = t("onPositionChangeEnd")) == null ? void 0 : _a2({ position: e4.get("position") });
      }, invokeOnResizeEnd({ context: e4, prop: t }) {
        var _a2;
        (_a2 = t("onSizeChangeEnd")) == null ? void 0 : _a2({ size: e4.get("size") });
      }, focusTriggerEl({ scope: e4 }) {
        nt(() => {
          var _a2;
          (_a2 = fe5(e4)) == null ? void 0 : _a2.focus();
        });
      }, focusContentEl({ scope: e4 }) {
        nt(() => {
          var _a2;
          (_a2 = Pe6(e4)) == null ? void 0 : _a2.focus();
        });
      }, toggleVisibility({ send: e4, prop: t, event: s }) {
        e4({ type: t("open") ? "CONTROLLED.OPEN" : "CONTROLLED.CLOSE", previousEvent: s });
      } } } };
      Ie5 = As()(["allowOverflow", "closeOnEscape", "defaultOpen", "defaultPosition", "defaultSize", "dir", "disabled", "draggable", "getAnchorPosition", "getBoundaryEl", "getRootNode", "gridSize", "id", "ids", "lockAspectRatio", "maxSize", "minSize", "onOpenChange", "onPositionChange", "onPositionChangeEnd", "onSizeChange", "onSizeChangeEnd", "onStageChange", "open", "persistRect", "position", "resizable", "size", "strategy", "translations"]);
      qe6 = as(Ie5);
      De4 = As()(["axis"]);
      Ve7 = as(De4);
      D7 = class extends ve {
        initMachine(t) {
          return new Ls(Ce5, t);
        }
        initApi() {
          return Oe6(this.machine.service, Cs);
        }
        render() {
          let t = this.el.querySelector('[data-scope="floating-panel"][data-part="trigger"]');
          t && this.spreadProps(t, this.api.getTriggerProps());
          let s = this.el.querySelector('[data-scope="floating-panel"][data-part="positioner"]');
          s && this.spreadProps(s, this.api.getPositionerProps());
          let i = this.el.querySelector('[data-scope="floating-panel"][data-part="content"]');
          i && this.spreadProps(i, this.api.getContentProps());
          let o2 = this.el.querySelector('[data-scope="floating-panel"][data-part="title"]');
          o2 && this.spreadProps(o2, this.api.getTitleProps());
          let n = this.el.querySelector('[data-scope="floating-panel"][data-part="header"]');
          n && this.spreadProps(n, this.api.getHeaderProps());
          let a3 = this.el.querySelector('[data-scope="floating-panel"][data-part="body"]');
          a3 && this.spreadProps(a3, this.api.getBodyProps());
          let c5 = this.el.querySelector('[data-scope="floating-panel"][data-part="drag-trigger"]');
          c5 && this.spreadProps(c5, this.api.getDragTriggerProps()), ["s", "w", "e", "n", "sw", "nw", "se", "ne"].forEach((f4) => {
            let P11 = this.el.querySelector(`[data-scope="floating-panel"][data-part="resize-trigger"][data-axis="${f4}"]`);
            P11 && this.spreadProps(P11, this.api.getResizeTriggerProps({ axis: f4 }));
          });
          let l4 = this.el.querySelector('[data-scope="floating-panel"][data-part="close-trigger"]');
          l4 && this.spreadProps(l4, this.api.getCloseTriggerProps());
          let g7 = this.el.querySelector('[data-scope="floating-panel"][data-part="control"]');
          g7 && this.spreadProps(g7, this.api.getControlProps()), ["minimized", "maximized", "default"].forEach((f4) => {
            let P11 = this.el.querySelector(`[data-scope="floating-panel"][data-part="stage-trigger"][data-stage="${f4}"]`);
            P11 && this.spreadProps(P11, this.api.getStageTriggerProps({ stage: f4 }));
          });
        }
      };
      Ye5 = { mounted() {
        let e4 = this.el, t = _r(e4, "open"), s = _r(e4, "defaultOpen"), i = _r(e4, "controlled"), o2 = A8(e4.dataset.size), n = A8(e4.dataset.defaultSize), a3 = be4(e4.dataset.position), c5 = be4(e4.dataset.defaultPosition), u3 = new D7(e4, __spreadProps(__spreadValues({ id: e4.id }, i ? { open: t } : { defaultOpen: s }), { draggable: _r(e4, "draggable") !== false, resizable: _r(e4, "resizable") !== false, allowOverflow: _r(e4, "allowOverflow") !== false, closeOnEscape: _r(e4, "closeOnEscape") !== false, disabled: _r(e4, "disabled"), dir: kr(e4), size: o2, defaultSize: n, position: a3, defaultPosition: c5, minSize: A8(e4.dataset.minSize), maxSize: A8(e4.dataset.maxSize), persistRect: _r(e4, "persistRect"), gridSize: Number(e4.dataset.gridSize) || 1, onOpenChange: (l4) => {
          let g7 = xr(e4, "onOpenChange");
          g7 && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected() && this.pushEvent(g7, { open: l4.open, id: e4.id });
          let h6 = xr(e4, "onOpenChangeClient");
          h6 && e4.dispatchEvent(new CustomEvent(h6, { bubbles: true, detail: { value: l4, id: e4.id } }));
        }, onPositionChange: (l4) => {
          let g7 = xr(e4, "onPositionChange");
          g7 && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected() && this.pushEvent(g7, { position: l4.position, id: e4.id });
        }, onSizeChange: (l4) => {
          let g7 = xr(e4, "onSizeChange");
          g7 && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected() && this.pushEvent(g7, { size: l4.size, id: e4.id });
        }, onStageChange: (l4) => {
          let g7 = xr(e4, "onStageChange");
          g7 && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected() && this.pushEvent(g7, { stage: l4.stage, id: e4.id });
        } }));
        u3.init(), this.floatingPanel = u3, this.handlers = [];
      }, updated() {
        var _a2;
        let e4 = _r(this.el, "open"), t = _r(this.el, "controlled");
        (_a2 = this.floatingPanel) == null ? void 0 : _a2.updateProps(__spreadProps(__spreadValues({ id: this.el.id }, t ? { open: e4 } : {}), { disabled: _r(this.el, "disabled"), dir: kr(this.el) }));
      }, destroyed() {
        var _a2;
        if (this.handlers) for (let e4 of this.handlers) this.removeHandleEvent(e4);
        (_a2 = this.floatingPanel) == null ? void 0 : _a2.destroy();
      } };
    }
  });

  // ../priv/static/listbox.mjs
  var listbox_exports = {};
  __export(listbox_exports, {
    Listbox: () => Ye6
  });
  function de7(e4, l4) {
    let { context: t, prop: i, scope: a3, computed: c5, send: o2, refs: h6 } = e4, m5 = i("disabled"), r3 = i("collection"), A12 = ut3(r3) ? "grid" : "list", T7 = t.get("focused"), _12 = h6.get("focusVisible") && T7, pe11 = h6.get("inputState"), k14 = t.get("value"), me9 = t.get("selectedItems"), u3 = t.get("highlightedValue"), fe11 = t.get("highlightedItem"), Ie10 = c5("isTypingAhead"), ve8 = c5("isInteractive"), N10 = u3 ? U7(a3, u3) : void 0;
    function x14(n) {
      let s = r3.getItemDisabled(n.item), g7 = r3.getItemValue(n.item);
      ds(g7, () => `[zag-js] No value found for item ${JSON.stringify(n.item)}`);
      let I11 = u3 === g7;
      return { value: g7, disabled: !!(m5 || s), focused: I11 && T7, focusVisible: I11 && _12, highlighted: I11 && (pe11.focused ? T7 : _12), selected: t.get("value").includes(g7) };
    }
    return { empty: k14.length === 0, highlightedItem: fe11, highlightedValue: u3, clearHighlightedValue() {
      o2({ type: "HIGHLIGHTED_VALUE.SET", value: null });
    }, selectedItems: me9, hasSelectedItems: c5("hasSelectedItems"), value: k14, valueAsString: c5("valueAsString"), collection: r3, disabled: !!m5, selectValue(n) {
      o2({ type: "ITEM.SELECT", value: n });
    }, setValue(n) {
      o2({ type: "VALUE.SET", value: n });
    }, selectAll() {
      if (!c5("multiple")) throw new Error("[zag-js] Cannot select all items in a single-select listbox");
      o2({ type: "VALUE.SET", value: r3.getValues() });
    }, highlightValue(n) {
      o2({ type: "HIGHLIGHTED_VALUE.SET", value: n });
    }, clearValue(n) {
      o2(n ? { type: "ITEM.CLEAR", value: n } : { type: "VALUE.CLEAR" });
    }, getItemState: x14, getRootProps() {
      return l4.element(__spreadProps(__spreadValues({}, v6.root.attrs), { dir: i("dir"), id: Ve8(a3), "data-orientation": i("orientation"), "data-disabled": jr(m5) }));
    }, getInputProps(n = {}) {
      return l4.input(__spreadProps(__spreadValues({}, v6.input.attrs), { dir: i("dir"), disabled: m5, "data-disabled": jr(m5), autoComplete: "off", autoCorrect: "off", "aria-haspopup": "listbox", "aria-controls": R4(a3), "aria-autocomplete": "list", "aria-activedescendant": N10, spellCheck: false, enterKeyHint: "go", onFocus() {
        queueMicrotask(() => {
          o2({ type: "INPUT.FOCUS", autoHighlight: !!(n == null ? void 0 : n.autoHighlight) });
        });
      }, onBlur() {
        o2({ type: "CONTENT.BLUR", src: "input" });
      }, onInput(s) {
        (n == null ? void 0 : n.autoHighlight) && (s.currentTarget.value.trim() || queueMicrotask(() => {
          o2({ type: "HIGHLIGHTED_VALUE.SET", value: null });
        }));
      }, onKeyDown(s) {
        if (s.defaultPrevented || to(s)) return;
        let g7 = en(s), I11 = () => {
          var _a2;
          s.preventDefault();
          let D11 = a3.getWin(), d4 = new D11.KeyboardEvent(g7.type, g7);
          (_a2 = C9(a3)) == null ? void 0 : _a2.dispatchEvent(d4);
        };
        switch (g7.key) {
          case "ArrowLeft":
          case "ArrowRight": {
            if (!ut3(r3) || s.ctrlKey) return;
            I11();
          }
          case "Home":
          case "End": {
            if (u3 == null && s.shiftKey) return;
            I11();
          }
          case "ArrowDown":
          case "ArrowUp": {
            I11();
            break;
          }
          case "Enter":
            u3 != null && (s.preventDefault(), o2({ type: "ITEM.CLICK", value: u3 }));
            break;
        }
      } }));
    }, getLabelProps() {
      return l4.element(__spreadProps(__spreadValues({ dir: i("dir"), id: re4(a3) }, v6.label.attrs), { "data-disabled": jr(m5) }));
    }, getValueTextProps() {
      return l4.element(__spreadProps(__spreadValues({}, v6.valueText.attrs), { dir: i("dir"), "data-disabled": jr(m5) }));
    }, getItemProps(n) {
      let s = x14(n);
      return l4.element(__spreadProps(__spreadValues({ id: U7(a3, s.value), role: "option" }, v6.item.attrs), { dir: i("dir"), "data-value": s.value, "aria-selected": s.selected, "data-selected": jr(s.selected), "data-layout": A12, "data-state": s.selected ? "checked" : "unchecked", "data-orientation": i("orientation"), "data-highlighted": jr(s.highlighted), "data-disabled": jr(s.disabled), "aria-disabled": Br(s.disabled), onPointerMove(g7) {
        n.highlightOnHover && (s.disabled || g7.pointerType !== "mouse" || s.highlighted || o2({ type: "ITEM.POINTER_MOVE", value: s.value }));
      }, onMouseDown(g7) {
        var _a2;
        g7.preventDefault(), (_a2 = C9(a3)) == null ? void 0 : _a2.focus();
      }, onClick(g7) {
        g7.defaultPrevented || s.disabled || o2({ type: "ITEM.CLICK", value: s.value, shiftKey: g7.shiftKey, anchorValue: u3, metaKey: Ze(g7) });
      } }));
    }, getItemTextProps(n) {
      let s = x14(n);
      return l4.element(__spreadProps(__spreadValues({}, v6.itemText.attrs), { "data-state": s.selected ? "checked" : "unchecked", "data-disabled": jr(s.disabled), "data-highlighted": jr(s.highlighted) }));
    }, getItemIndicatorProps(n) {
      let s = x14(n);
      return l4.element(__spreadProps(__spreadValues({}, v6.itemIndicator.attrs), { "aria-hidden": true, "data-state": s.selected ? "checked" : "unchecked", hidden: !s.selected }));
    }, getItemGroupLabelProps(n) {
      let { htmlFor: s } = n;
      return l4.element(__spreadProps(__spreadValues({}, v6.itemGroupLabel.attrs), { id: ce5(a3, s), dir: i("dir"), role: "presentation" }));
    }, getItemGroupProps(n) {
      let { id: s } = n;
      return l4.element(__spreadProps(__spreadValues({}, v6.itemGroup.attrs), { "data-disabled": jr(m5), "data-orientation": i("orientation"), "data-empty": jr(r3.size === 0), id: Ee6(a3, s), "aria-labelledby": ce5(a3, s), role: "group", dir: i("dir") }));
    }, getContentProps() {
      return l4.element(__spreadProps(__spreadValues({ dir: i("dir"), id: R4(a3), role: "listbox" }, v6.content.attrs), { "data-activedescendant": N10, "aria-activedescendant": N10, "data-orientation": i("orientation"), "aria-multiselectable": c5("multiple") ? true : void 0, "aria-labelledby": re4(a3), tabIndex: 0, "data-layout": A12, "data-empty": jr(r3.size === 0), style: { "--column-count": ut3(r3) ? r3.columnCount : 1 }, onFocus() {
        o2({ type: "CONTENT.FOCUS" });
      }, onBlur() {
        o2({ type: "CONTENT.BLUR" });
      }, onKeyDown(n) {
        if (!ve8 || !Ie(n.currentTarget, Je(n))) return;
        let s = n.shiftKey, g7 = { ArrowUp(d4) {
          let p4 = null;
          ut3(r3) && u3 ? p4 = r3.getPreviousRowValue(u3) : u3 && (p4 = r3.getPreviousValue(u3)), !p4 && (i("loopFocus") || !u3) && (p4 = r3.lastValue), p4 && (d4.preventDefault(), o2({ type: "NAVIGATE", value: p4, shiftKey: s, anchorValue: u3 }));
        }, ArrowDown(d4) {
          let p4 = null;
          ut3(r3) && u3 ? p4 = r3.getNextRowValue(u3) : u3 && (p4 = r3.getNextValue(u3)), !p4 && (i("loopFocus") || !u3) && (p4 = r3.firstValue), p4 && (d4.preventDefault(), o2({ type: "NAVIGATE", value: p4, shiftKey: s, anchorValue: u3 }));
        }, ArrowLeft() {
          if (!ut3(r3) && i("orientation") === "vertical") return;
          let d4 = u3 ? r3.getPreviousValue(u3) : null;
          !d4 && i("loopFocus") && (d4 = r3.lastValue), d4 && (n.preventDefault(), o2({ type: "NAVIGATE", value: d4, shiftKey: s, anchorValue: u3 }));
        }, ArrowRight() {
          if (!ut3(r3) && i("orientation") === "vertical") return;
          let d4 = u3 ? r3.getNextValue(u3) : null;
          !d4 && i("loopFocus") && (d4 = r3.firstValue), d4 && (n.preventDefault(), o2({ type: "NAVIGATE", value: d4, shiftKey: s, anchorValue: u3 }));
        }, Home(d4) {
          d4.preventDefault();
          let p4 = r3.firstValue;
          o2({ type: "NAVIGATE", value: p4, shiftKey: s, anchorValue: u3 });
        }, End(d4) {
          d4.preventDefault();
          let p4 = r3.lastValue;
          o2({ type: "NAVIGATE", value: p4, shiftKey: s, anchorValue: u3 });
        }, Enter() {
          o2({ type: "ITEM.CLICK", value: u3 });
        }, a(d4) {
          Ze(d4) && c5("multiple") && !i("disallowSelectAll") && (d4.preventDefault(), o2({ type: "VALUE.SET", value: r3.getValues() }));
        }, Space(d4) {
          var _a2;
          Ie10 && i("typeahead") ? o2({ type: "CONTENT.TYPEAHEAD", key: d4.key }) : (_a2 = g7.Enter) == null ? void 0 : _a2.call(g7, d4);
        }, Escape(d4) {
          i("deselectable") && k14.length > 0 && (d4.preventDefault(), d4.stopPropagation(), o2({ type: "VALUE.CLEAR" }));
        } }, I11 = g7[io(n)];
        if (I11) {
          I11(n);
          return;
        }
        let D11 = Je(n);
        _e(D11) || xo.isValidEvent(n) && i("typeahead") && (o2({ type: "CONTENT.TYPEAHEAD", key: n.key }), n.preventDefault());
      } }));
    } };
  }
  function L9(e4, l4, t) {
    let i = Le6(l4, e4);
    for (let a3 of i) t == null ? void 0 : t({ value: a3 });
  }
  function ge6(e4, l4) {
    return l4 ? E8({ items: e4, itemToValue: (t) => {
      var _a2, _b;
      return (_b = (_a2 = t.id) != null ? _a2 : t.value) != null ? _b : "";
    }, itemToString: (t) => t.label, isItemDisabled: (t) => !!t.disabled, groupBy: (t) => {
      var _a2;
      return (_a2 = t.group) != null ? _a2 : "";
    } }) : E8({ items: e4, itemToValue: (t) => {
      var _a2, _b;
      return (_b = (_a2 = t.id) != null ? _a2 : t.value) != null ? _b : "";
    }, itemToString: (t) => t.label, isItemDisabled: (t) => !!t.disabled });
  }
  var be5, v6, E8, ye7, Ve8, R4, re4, U7, Ee6, ce5, C9, ue6, Te5, Se7, He6, he6, Le6, Ae4, Oe7, xe6, Ke6, Pe7, Re5, Ce6, Ue5, M6, Ye6;
  var init_listbox = __esm({
    "../priv/static/listbox.mjs"() {
      "use strict";
      init_chunk_XQAZHZIC();
      init_chunk_MMRG4CGO();
      init_chunk_IYURAQ6S();
      be5 = G("listbox").parts("label", "input", "item", "itemText", "itemIndicator", "itemGroup", "itemGroupLabel", "content", "root", "valueText");
      v6 = be5.build();
      E8 = (e4) => new q5(e4);
      E8.empty = () => new q5({ items: [] });
      ye7 = (e4) => new ht3(e4);
      ye7.empty = () => new ht3({ items: [], columnCount: 0 });
      Ve8 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.root) != null ? _b : `select:${e4.id}`;
      };
      R4 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.content) != null ? _b : `select:${e4.id}:content`;
      };
      re4 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.label) != null ? _b : `select:${e4.id}:label`;
      };
      U7 = (e4, l4) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = e4.ids) == null ? void 0 : _a2.item) == null ? void 0 : _b.call(_a2, l4)) != null ? _c : `select:${e4.id}:option:${l4}`;
      };
      Ee6 = (e4, l4) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = e4.ids) == null ? void 0 : _a2.itemGroup) == null ? void 0 : _b.call(_a2, l4)) != null ? _c : `select:${e4.id}:optgroup:${l4}`;
      };
      ce5 = (e4, l4) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = e4.ids) == null ? void 0 : _a2.itemGroupLabel) == null ? void 0 : _b.call(_a2, l4)) != null ? _c : `select:${e4.id}:optgroup-label:${l4}`;
      };
      C9 = (e4) => e4.getById(R4(e4));
      ue6 = (e4, l4) => e4.getById(U7(e4, l4));
      ({ guards: Te5, createMachine: Se7 } = ws());
      ({ or: He6 } = Te5);
      he6 = Se7({ props({ props: e4 }) {
        return __spreadValues({ loopFocus: false, composite: true, defaultValue: [], multiple: false, typeahead: true, collection: E8.empty(), orientation: "vertical", selectionMode: "single" }, e4);
      }, context({ prop: e4, bindable: l4 }) {
        return { value: l4(() => ({ defaultValue: e4("defaultValue"), value: e4("value"), isEqual: V, onChange(t) {
          var _a2;
          let i = e4("collection").findMany(t);
          return (_a2 = e4("onValueChange")) == null ? void 0 : _a2({ value: t, items: i });
        } })), highlightedValue: l4(() => ({ defaultValue: e4("defaultHighlightedValue") || null, value: e4("highlightedValue"), sync: true, onChange(t) {
          var _a2;
          (_a2 = e4("onHighlightChange")) == null ? void 0 : _a2({ highlightedValue: t, highlightedItem: e4("collection").find(t), highlightedIndex: e4("collection").indexOf(t) });
        } })), highlightedItem: l4(() => ({ defaultValue: null })), selectedItems: l4(() => {
          var _a2, _b;
          let t = (_b = (_a2 = e4("value")) != null ? _a2 : e4("defaultValue")) != null ? _b : [];
          return { defaultValue: e4("collection").findMany(t) };
        }), focused: l4(() => ({ sync: true, defaultValue: false })) };
      }, refs() {
        return { typeahead: __spreadValues({}, xo.defaultOptions), focusVisible: false, inputState: { autoHighlight: false, focused: false } };
      }, computed: { hasSelectedItems: ({ context: e4 }) => e4.get("value").length > 0, isTypingAhead: ({ refs: e4 }) => e4.get("typeahead").keysSoFar !== "", isInteractive: ({ prop: e4 }) => !e4("disabled"), selection: ({ context: e4, prop: l4 }) => {
        let t = new ct2(e4.get("value"));
        return t.selectionMode = l4("selectionMode"), t.deselectable = !!l4("deselectable"), t;
      }, multiple: ({ prop: e4 }) => e4("selectionMode") === "multiple" || e4("selectionMode") === "extended", valueAsString: ({ context: e4, prop: l4 }) => l4("collection").stringifyItems(e4.get("selectedItems")) }, initialState() {
        return "idle";
      }, watch({ context: e4, prop: l4, track: t, action: i }) {
        t([() => e4.get("value").toString()], () => {
          i(["syncSelectedItems"]);
        }), t([() => e4.get("highlightedValue")], () => {
          i(["syncHighlightedItem"]);
        }), t([() => l4("collection").toString()], () => {
          i(["syncHighlightedValue"]);
        });
      }, effects: ["trackFocusVisible"], on: { "HIGHLIGHTED_VALUE.SET": { actions: ["setHighlightedItem"] }, "ITEM.SELECT": { actions: ["selectItem"] }, "ITEM.CLEAR": { actions: ["clearItem"] }, "VALUE.SET": { actions: ["setSelectedItems"] }, "VALUE.CLEAR": { actions: ["clearSelectedItems"] } }, states: { idle: { effects: ["scrollToHighlightedItem"], on: { "INPUT.FOCUS": { actions: ["setFocused", "setInputState"] }, "CONTENT.FOCUS": [{ guard: He6("hasSelectedValue", "hasHighlightedValue"), actions: ["setFocused"] }, { actions: ["setFocused", "setDefaultHighlightedValue"] }], "CONTENT.BLUR": { actions: ["clearFocused", "clearInputState"] }, "ITEM.CLICK": { actions: ["setHighlightedItem", "selectHighlightedItem"] }, "CONTENT.TYPEAHEAD": { actions: ["setFocused", "highlightMatchingItem"] }, "ITEM.POINTER_MOVE": { actions: ["highlightItem"] }, "ITEM.POINTER_LEAVE": { actions: ["clearHighlightedItem"] }, NAVIGATE: { actions: ["setFocused", "setHighlightedItem", "selectWithKeyboard"] } } } }, implementations: { guards: { hasSelectedValue: ({ context: e4 }) => e4.get("value").length > 0, hasHighlightedValue: ({ context: e4 }) => e4.get("highlightedValue") != null }, effects: { trackFocusVisible: ({ scope: e4, refs: l4 }) => {
        var _a2;
        return S5({ root: (_a2 = e4.getRootNode) == null ? void 0 : _a2.call(e4), onChange(t) {
          l4.set("focusVisible", t.isFocusVisible);
        } });
      }, scrollToHighlightedItem({ context: e4, prop: l4, scope: t }) {
        let i = (c5) => {
          let o2 = e4.get("highlightedValue");
          if (o2 == null || P5() !== "keyboard") return;
          let m5 = C9(t), r3 = l4("scrollToIndexFn");
          if (r3) {
            let T7 = l4("collection").indexOf(o2);
            r3 == null ? void 0 : r3({ index: T7, immediate: c5, getElement() {
              return ue6(t, o2);
            } });
            return;
          }
          let A12 = ue6(t, o2);
          bo(A12, { rootEl: m5, block: "nearest" });
        };
        return nt(() => i(true)), go(() => C9(t), { defer: true, attributes: ["data-activedescendant"], callback() {
          i(false);
        } });
      } }, actions: { selectHighlightedItem({ context: e4, prop: l4, event: t, computed: i }) {
        var _a2;
        let a3 = (_a2 = t.value) != null ? _a2 : e4.get("highlightedValue"), c5 = l4("collection");
        if (a3 == null || !c5.has(a3)) return;
        let o2 = i("selection");
        if (t.shiftKey && i("multiple") && t.anchorValue) {
          let h6 = o2.extendSelection(c5, t.anchorValue, a3);
          L9(o2, h6, l4("onSelect")), e4.set("value", Array.from(h6));
        } else {
          let h6 = o2.select(c5, a3, t.metaKey);
          L9(o2, h6, l4("onSelect")), e4.set("value", Array.from(h6));
        }
      }, selectWithKeyboard({ context: e4, prop: l4, event: t, computed: i }) {
        let a3 = i("selection"), c5 = l4("collection");
        if (t.shiftKey && i("multiple") && t.anchorValue) {
          let o2 = a3.extendSelection(c5, t.anchorValue, t.value);
          L9(a3, o2, l4("onSelect")), e4.set("value", Array.from(o2));
          return;
        }
        if (l4("selectOnHighlight")) {
          let o2 = a3.replaceSelection(c5, t.value);
          L9(a3, o2, l4("onSelect")), e4.set("value", Array.from(o2));
        }
      }, highlightItem({ context: e4, event: l4 }) {
        e4.set("highlightedValue", l4.value);
      }, highlightMatchingItem({ context: e4, prop: l4, event: t, refs: i }) {
        let a3 = l4("collection").search(t.key, { state: i.get("typeahead"), currentValue: e4.get("highlightedValue") });
        a3 != null && e4.set("highlightedValue", a3);
      }, setHighlightedItem({ context: e4, event: l4 }) {
        e4.set("highlightedValue", l4.value);
      }, clearHighlightedItem({ context: e4 }) {
        e4.set("highlightedValue", null);
      }, selectItem({ context: e4, prop: l4, event: t, computed: i }) {
        let a3 = l4("collection"), c5 = i("selection"), o2 = c5.select(a3, t.value);
        L9(c5, o2, l4("onSelect")), e4.set("value", Array.from(o2));
      }, clearItem({ context: e4, event: l4, computed: t }) {
        let a3 = t("selection").deselect(l4.value);
        e4.set("value", Array.from(a3));
      }, setSelectedItems({ context: e4, event: l4 }) {
        e4.set("value", l4.value);
      }, clearSelectedItems({ context: e4 }) {
        e4.set("value", []);
      }, syncSelectedItems({ context: e4, prop: l4 }) {
        let t = l4("collection"), i = e4.get("selectedItems"), c5 = e4.get("value").map((o2) => i.find((m5) => t.getItemValue(m5) === o2) || t.find(o2));
        e4.set("selectedItems", c5);
      }, syncHighlightedItem({ context: e4, prop: l4 }) {
        let t = l4("collection"), i = e4.get("highlightedValue"), a3 = i ? t.find(i) : null;
        e4.set("highlightedItem", a3);
      }, syncHighlightedValue({ context: e4, prop: l4, refs: t }) {
        let i = l4("collection"), a3 = e4.get("highlightedValue"), { autoHighlight: c5 } = t.get("inputState");
        if (c5) {
          queueMicrotask(() => {
            var _a2;
            e4.set("highlightedValue", (_a2 = l4("collection").firstValue) != null ? _a2 : null);
          });
          return;
        }
        a3 != null && !i.has(a3) && queueMicrotask(() => {
          e4.set("highlightedValue", null);
        });
      }, setFocused({ context: e4 }) {
        e4.set("focused", true);
      }, setDefaultHighlightedValue({ context: e4, prop: l4 }) {
        let i = l4("collection").firstValue;
        i != null && e4.set("highlightedValue", i);
      }, clearFocused({ context: e4 }) {
        e4.set("focused", false);
      }, setInputState({ refs: e4, event: l4 }) {
        e4.set("inputState", { autoHighlight: !!l4.autoHighlight, focused: true });
      }, clearInputState({ refs: e4 }) {
        e4.set("inputState", { autoHighlight: false, focused: false });
      } } } });
      Le6 = (e4, l4) => {
        let t = new Set(e4);
        for (let i of l4) t.delete(i);
        return t;
      };
      Ae4 = As()(["collection", "defaultHighlightedValue", "defaultValue", "dir", "disabled", "deselectable", "disallowSelectAll", "getRootNode", "highlightedValue", "id", "ids", "loopFocus", "onHighlightChange", "onSelect", "onValueChange", "orientation", "scrollToIndexFn", "selectionMode", "selectOnHighlight", "typeahead", "value"]);
      Oe7 = as(Ae4);
      xe6 = As()(["item", "highlightOnHover"]);
      Ke6 = as(xe6);
      Pe7 = As()(["id"]);
      Re5 = as(Pe7);
      Ce6 = As()(["htmlFor"]);
      Ue5 = as(Ce6);
      M6 = class extends ve {
        constructor(l4, t) {
          var _a2;
          super(l4, t);
          __publicField(this, "_options", []);
          __publicField(this, "hasGroups", false);
          __publicField(this, "init", () => {
            this.machine.start(), this.render(), this.machine.subscribe(() => {
              this.api = this.initApi(), this.render();
            });
          });
          let i = t.collection;
          this._options = (_a2 = i == null ? void 0 : i.items) != null ? _a2 : [];
        }
        get options() {
          return Array.isArray(this._options) ? this._options : [];
        }
        setOptions(l4) {
          this._options = Array.isArray(l4) ? l4 : [];
        }
        getCollection() {
          let l4 = this.options;
          return this.hasGroups ? E8({ items: l4, itemToValue: (t) => {
            var _a2, _b;
            return (_b = (_a2 = t.id) != null ? _a2 : t.value) != null ? _b : "";
          }, itemToString: (t) => t.label, isItemDisabled: (t) => !!t.disabled, groupBy: (t) => {
            var _a2;
            return (_a2 = t.group) != null ? _a2 : "";
          } }) : E8({ items: l4, itemToValue: (t) => {
            var _a2, _b;
            return (_b = (_a2 = t.id) != null ? _a2 : t.value) != null ? _b : "";
          }, itemToString: (t) => t.label, isItemDisabled: (t) => !!t.disabled });
        }
        initMachine(l4) {
          let t = this.getCollection.bind(this), i = l4.collection;
          return new Ls(he6, __spreadProps(__spreadValues({}, l4), { get collection() {
            return i != null ? i : t();
          } }));
        }
        initApi() {
          return de7(this.machine.service, Cs);
        }
        applyItemProps() {
          let l4 = this.el.querySelector('[data-scope="listbox"][data-part="content"]');
          l4 && (l4.querySelectorAll('[data-scope="listbox"][data-part="item-group"]').forEach((t) => {
            var _a2;
            let i = (_a2 = t.dataset.id) != null ? _a2 : "";
            this.spreadProps(t, this.api.getItemGroupProps({ id: i }));
            let a3 = t.querySelector('[data-scope="listbox"][data-part="item-group-label"]');
            a3 && this.spreadProps(a3, this.api.getItemGroupLabelProps({ htmlFor: i }));
          }), l4.querySelectorAll('[data-scope="listbox"][data-part="item"]').forEach((t) => {
            var _a2;
            let i = (_a2 = t.dataset.value) != null ? _a2 : "", a3 = this.options.find((h6) => {
              var _a3, _b;
              return String((_b = (_a3 = h6.id) != null ? _a3 : h6.value) != null ? _b : "") === String(i);
            });
            if (!a3) return;
            this.spreadProps(t, this.api.getItemProps({ item: a3 }));
            let c5 = t.querySelector('[data-scope="listbox"][data-part="item-text"]');
            c5 && this.spreadProps(c5, this.api.getItemTextProps({ item: a3 }));
            let o2 = t.querySelector('[data-scope="listbox"][data-part="item-indicator"]');
            o2 && this.spreadProps(o2, this.api.getItemIndicatorProps({ item: a3 }));
          }));
        }
        render() {
          var _a2;
          let l4 = (_a2 = this.el.querySelector('[data-scope="listbox"][data-part="root"]')) != null ? _a2 : this.el;
          this.spreadProps(l4, this.api.getRootProps());
          let t = this.el.querySelector('[data-scope="listbox"][data-part="label"]');
          t && this.spreadProps(t, this.api.getLabelProps());
          let i = this.el.querySelector('[data-scope="listbox"][data-part="value-text"]');
          i && this.spreadProps(i, this.api.getValueTextProps());
          let a3 = this.el.querySelector('[data-scope="listbox"][data-part="input"]');
          a3 && this.spreadProps(a3, this.api.getInputProps());
          let c5 = this.el.querySelector('[data-scope="listbox"][data-part="content"]');
          c5 && (this.spreadProps(c5, this.api.getContentProps()), this.applyItemProps());
        }
      };
      Ye6 = { mounted() {
        var _a2;
        let e4 = this.el, l4 = JSON.parse((_a2 = e4.dataset.collection) != null ? _a2 : "[]"), t = l4.some((h6) => h6.group !== void 0), i = Cr(e4, "value"), a3 = Cr(e4, "defaultValue"), c5 = _r(e4, "controlled"), o2 = new M6(e4, __spreadProps(__spreadValues({ id: e4.id, collection: ge6(l4, t) }, c5 && i ? { value: i } : { defaultValue: a3 != null ? a3 : [] }), { disabled: _r(e4, "disabled"), dir: xr(e4, "dir", ["ltr", "rtl"]), orientation: xr(e4, "orientation", ["horizontal", "vertical"]), loopFocus: _r(e4, "loopFocus"), selectionMode: xr(e4, "selectionMode", ["single", "multiple", "extended"]), selectOnHighlight: _r(e4, "selectOnHighlight"), deselectable: _r(e4, "deselectable"), typeahead: _r(e4, "typeahead"), onValueChange: (h6) => {
          let m5 = xr(e4, "onValueChange");
          m5 && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected() && this.pushEvent(m5, { value: h6.value, items: h6.items, id: e4.id });
          let r3 = xr(e4, "onValueChangeClient");
          r3 && e4.dispatchEvent(new CustomEvent(r3, { bubbles: true, detail: { value: h6, id: e4.id } }));
        } }));
        o2.hasGroups = t, o2.setOptions(l4), o2.init(), this.listbox = o2, this.handlers = [];
      }, updated() {
        var _a2;
        let e4 = JSON.parse((_a2 = this.el.dataset.collection) != null ? _a2 : "[]"), l4 = e4.some((a3) => a3.group !== void 0), t = Cr(this.el, "value"), i = _r(this.el, "controlled");
        this.listbox && (this.listbox.hasGroups = l4, this.listbox.setOptions(e4), this.listbox.updateProps(__spreadProps(__spreadValues({ collection: ge6(e4, l4), id: this.el.id }, i && t ? { value: t } : {}), { disabled: _r(this.el, "disabled"), dir: xr(this.el, "dir", ["ltr", "rtl"]), orientation: xr(this.el, "orientation", ["horizontal", "vertical"]) })));
      }, destroyed() {
        var _a2;
        if (this.handlers) for (let e4 of this.handlers) this.removeHandleEvent(e4);
        (_a2 = this.listbox) == null ? void 0 : _a2.destroy();
      } };
    }
  });

  // ../priv/static/menu.mjs
  var menu_exports = {};
  __export(menu_exports, {
    Menu: () => Lt5
  });
  function et6(e4, t) {
    if (!e4) return;
    let o2 = T(e4), n = new o2.CustomEvent(se6, { detail: { value: t } });
    e4.dispatchEvent(n);
  }
  function qe7(e4, t) {
    let { context: o2, send: n, state: a3, computed: c5, prop: r3, scope: s } = e4, d4 = a3.hasTag("open"), m5 = o2.get("isSubmenu"), h6 = c5("isTypingAhead"), p4 = r3("composite"), M10 = o2.get("currentPlacement"), R7 = o2.get("anchorPoint"), b10 = o2.get("highlightedValue"), k14 = $n2(__spreadProps(__spreadValues({}, r3("positioning")), { placement: R7 ? "bottom" : M10 }));
    function S13(i) {
      return { id: x5(s, i.value), disabled: !!i.disabled, highlighted: b10 === i.value };
    }
    function j12(i) {
      var _a2;
      let l4 = (_a2 = i.valueText) != null ? _a2 : i.value;
      return __spreadProps(__spreadValues({}, i), { id: i.value, valueText: l4 });
    }
    function L13(i) {
      return __spreadProps(__spreadValues({}, S13(j12(i))), { checked: !!i.checked });
    }
    function H12(i) {
      let { closeOnSelect: l4, valueText: O10, value: P11 } = i, f4 = S13(i), I11 = x5(s, P11);
      return t.element(__spreadProps(__spreadValues({}, E9.item.attrs), { id: I11, role: "menuitem", "aria-disabled": Br(f4.disabled), "data-disabled": jr(f4.disabled), "data-ownedby": V12(s), "data-highlighted": jr(f4.highlighted), "data-value": P11, "data-valuetext": O10, onDragStart(u3) {
        u3.currentTarget.matches("a[href]") && u3.preventDefault();
      }, onPointerMove(u3) {
        if (f4.disabled || u3.pointerType !== "mouse") return;
        let y11 = u3.currentTarget;
        if (f4.highlighted) return;
        let J15 = gt(u3);
        n({ type: "ITEM_POINTERMOVE", id: I11, target: y11, closeOnSelect: l4, point: J15 });
      }, onPointerLeave(u3) {
        var _a2;
        if (f4.disabled || u3.pointerType !== "mouse" || !((_a2 = e4.event.previous()) == null ? void 0 : _a2.type.includes("POINTER"))) return;
        let J15 = u3.currentTarget;
        n({ type: "ITEM_POINTERLEAVE", id: I11, target: J15, closeOnSelect: l4 });
      }, onPointerDown(u3) {
        if (f4.disabled) return;
        let y11 = u3.currentTarget;
        n({ type: "ITEM_POINTERDOWN", target: y11, id: I11, closeOnSelect: l4 });
      }, onClick(u3) {
        if (Qr(u3) || Zr(u3) || f4.disabled) return;
        let y11 = u3.currentTarget;
        n({ type: "ITEM_CLICK", target: y11, id: I11, closeOnSelect: l4 });
      } }));
    }
    return { highlightedValue: b10, open: d4, setOpen(i) {
      a3.hasTag("open") !== i && n({ type: i ? "OPEN" : "CLOSE" });
    }, setHighlightedValue(i) {
      n({ type: "HIGHLIGHTED.SET", value: i });
    }, setParent(i) {
      n({ type: "PARENT.SET", value: i, id: i.prop("id") });
    }, setChild(i) {
      n({ type: "CHILD.SET", value: i, id: i.prop("id") });
    }, reposition(i = {}) {
      n({ type: "POSITIONING.SET", options: i });
    }, addItemListener(i) {
      let l4 = s.getById(i.id);
      if (!l4) return;
      let O10 = () => {
        var _a2;
        return (_a2 = i.onSelect) == null ? void 0 : _a2.call(i);
      };
      return l4.addEventListener(se6, O10), () => l4.removeEventListener(se6, O10);
    }, getContextTriggerProps() {
      return t.element(__spreadProps(__spreadValues({}, E9.contextTrigger.attrs), { dir: r3("dir"), id: We6(s), "data-state": d4 ? "open" : "closed", onPointerDown(i) {
        if (i.pointerType === "mouse") return;
        let l4 = gt(i);
        n({ type: "CONTEXT_MENU_START", point: l4 });
      }, onPointerCancel(i) {
        i.pointerType !== "mouse" && n({ type: "CONTEXT_MENU_CANCEL" });
      }, onPointerMove(i) {
        i.pointerType !== "mouse" && n({ type: "CONTEXT_MENU_CANCEL" });
      }, onPointerUp(i) {
        i.pointerType !== "mouse" && n({ type: "CONTEXT_MENU_CANCEL" });
      }, onContextMenu(i) {
        let l4 = gt(i);
        n({ type: "CONTEXT_MENU", point: l4 }), i.preventDefault();
      }, style: { WebkitTouchCallout: "none", WebkitUserSelect: "none", userSelect: "none" } }));
    }, getTriggerItemProps(i) {
      let l4 = i.getTriggerProps();
      return bs(H12({ value: l4.id }), l4);
    }, getTriggerProps() {
      return t.button(__spreadProps(__spreadValues({}, m5 ? E9.triggerItem.attrs : E9.trigger.attrs), { "data-placement": o2.get("currentPlacement"), type: "button", dir: r3("dir"), id: Y10(s), "data-uid": r3("id"), "aria-haspopup": p4 ? "menu" : "dialog", "aria-controls": V12(s), "data-controls": V12(s), "aria-expanded": d4 || void 0, "data-state": d4 ? "open" : "closed", onPointerMove(i) {
        if (i.pointerType !== "mouse" || X9(i.currentTarget) || !m5) return;
        let O10 = gt(i);
        n({ type: "TRIGGER_POINTERMOVE", target: i.currentTarget, point: O10 });
      }, onPointerLeave(i) {
        if (X9(i.currentTarget) || i.pointerType !== "mouse" || !m5) return;
        let l4 = gt(i);
        n({ type: "TRIGGER_POINTERLEAVE", target: i.currentTarget, point: l4 });
      }, onPointerDown(i) {
        X9(i.currentTarget) || oo(i) || i.preventDefault();
      }, onClick(i) {
        i.defaultPrevented || X9(i.currentTarget) || n({ type: "TRIGGER_CLICK", target: i.currentTarget });
      }, onBlur() {
        n({ type: "TRIGGER_BLUR" });
      }, onFocus() {
        n({ type: "TRIGGER_FOCUS" });
      }, onKeyDown(i) {
        if (i.defaultPrevented) return;
        let l4 = { ArrowDown() {
          n({ type: "ARROW_DOWN" });
        }, ArrowUp() {
          n({ type: "ARROW_UP" });
        }, Enter() {
          n({ type: "ARROW_DOWN", src: "enter" });
        }, Space() {
          n({ type: "ARROW_DOWN", src: "space" });
        } }, O10 = io(i, { orientation: "vertical", dir: r3("dir") }), P11 = l4[O10];
        P11 && (i.preventDefault(), P11(i));
      } }));
    }, getIndicatorProps() {
      return t.element(__spreadProps(__spreadValues({}, E9.indicator.attrs), { dir: r3("dir"), "data-state": d4 ? "open" : "closed" }));
    }, getPositionerProps() {
      return t.element(__spreadProps(__spreadValues({}, E9.positioner.attrs), { dir: r3("dir"), id: xe7(s), style: k14.floating }));
    }, getArrowProps() {
      return t.element(__spreadProps(__spreadValues({ id: Ke7(s) }, E9.arrow.attrs), { dir: r3("dir"), style: k14.arrow }));
    }, getArrowTipProps() {
      return t.element(__spreadProps(__spreadValues({}, E9.arrowTip.attrs), { dir: r3("dir"), style: k14.arrowTip }));
    }, getContentProps() {
      return t.element(__spreadProps(__spreadValues({}, E9.content.attrs), { id: V12(s), "aria-label": r3("aria-label"), hidden: !d4, "data-state": d4 ? "open" : "closed", role: p4 ? "menu" : "dialog", tabIndex: 0, dir: r3("dir"), "aria-activedescendant": c5("highlightedId") || void 0, "aria-labelledby": Y10(s), "data-placement": M10, onPointerEnter(i) {
        i.pointerType === "mouse" && n({ type: "MENU_POINTERENTER" });
      }, onKeyDown(i) {
        if (i.defaultPrevented || !Ie(i.currentTarget, Je(i))) return;
        let l4 = Je(i);
        if (!((l4 == null ? void 0 : l4.closest("[role=menu]")) === i.currentTarget || l4 === i.currentTarget)) return;
        if (i.key === "Tab" && !po(i)) {
          i.preventDefault();
          return;
        }
        let P11 = { ArrowDown() {
          n({ type: "ARROW_DOWN" });
        }, ArrowUp() {
          n({ type: "ARROW_UP" });
        }, ArrowLeft() {
          n({ type: "ARROW_LEFT" });
        }, ArrowRight() {
          n({ type: "ARROW_RIGHT" });
        }, Enter() {
          n({ type: "ENTER" });
        }, Space(u3) {
          var _a2;
          h6 ? n({ type: "TYPEAHEAD", key: u3.key }) : (_a2 = P11.Enter) == null ? void 0 : _a2.call(P11, u3);
        }, Home() {
          n({ type: "HOME" });
        }, End() {
          n({ type: "END" });
        } }, f4 = io(i, { dir: r3("dir") }), I11 = P11[f4];
        if (I11) {
          I11(i), i.stopPropagation(), i.preventDefault();
          return;
        }
        r3("typeahead") && eo(i) && (so(i) || _e(l4) || (n({ type: "TYPEAHEAD", key: i.key }), i.preventDefault()));
      } }));
    }, getSeparatorProps() {
      return t.element(__spreadProps(__spreadValues({}, E9.separator.attrs), { role: "separator", dir: r3("dir"), "aria-orientation": "horizontal" }));
    }, getItemState: S13, getItemProps: H12, getOptionItemState: L13, getOptionItemProps(i) {
      let { type: l4, disabled: O10, closeOnSelect: P11 } = i, f4 = j12(i), I11 = L13(i);
      return __spreadValues(__spreadValues({}, H12(f4)), t.element(__spreadProps(__spreadValues({ "data-type": l4 }, E9.item.attrs), { dir: r3("dir"), "data-value": f4.value, role: `menuitem${l4}`, "aria-checked": !!I11.checked, "data-state": I11.checked ? "checked" : "unchecked", onClick(u3) {
        if (O10 || Qr(u3) || Zr(u3)) return;
        let y11 = u3.currentTarget;
        n({ type: "ITEM_CLICK", target: y11, option: f4, closeOnSelect: P11 });
      } })));
    }, getItemIndicatorProps(i) {
      let l4 = L13(Ho(i)), O10 = l4.checked ? "checked" : "unchecked";
      return t.element(__spreadProps(__spreadValues({}, E9.itemIndicator.attrs), { dir: r3("dir"), "data-disabled": jr(l4.disabled), "data-highlighted": jr(l4.highlighted), "data-state": Jn(i, "checked") ? O10 : void 0, hidden: Jn(i, "checked") ? !l4.checked : void 0 }));
    }, getItemTextProps(i) {
      let l4 = L13(Ho(i)), O10 = l4.checked ? "checked" : "unchecked";
      return t.element(__spreadProps(__spreadValues({}, E9.itemText.attrs), { dir: r3("dir"), "data-disabled": jr(l4.disabled), "data-highlighted": jr(l4.highlighted), "data-state": Jn(i, "checked") ? O10 : void 0 }));
    }, getItemGroupLabelProps(i) {
      return t.element(__spreadProps(__spreadValues({}, E9.itemGroupLabel.attrs), { id: Ge6(s, i.htmlFor), dir: r3("dir") }));
    }, getItemGroupProps(i) {
      return t.element(__spreadProps(__spreadValues({ id: Xe5(s, i.id) }, E9.itemGroup.attrs), { dir: r3("dir"), "aria-labelledby": Ge6(s, i.id), role: "group" }));
    } };
  }
  function Ue6(e4) {
    let t = e4.parent;
    for (; t && t.context.get("isSubmenu"); ) t = t.refs.get("parent");
    t == null ? void 0 : t.send({ type: "CLOSE" });
  }
  function nt5(e4, t) {
    return e4 ? it2(e4, t) : false;
  }
  function it5(e4, t, o2) {
    let n = Object.keys(e4).length > 0;
    if (!t) return null;
    if (!n) return x5(o2, t);
    for (let a3 in e4) {
      let c5 = e4[a3], r3 = Y10(c5.scope);
      if (r3 === t) return r3;
    }
    return x5(o2, t);
  }
  var $e6, E9, Y10, We6, V12, Ke7, xe7, Xe5, x5, N5, Ge6, C10, Ve9, K14, Ye7, re5, q10, je6, Je5, ae6, Qe5, Ze5, ze6, X9, Fe6, se6, T4, G11, tt7, Be6, ot4, ft5, rt5, Tt4, st5, It5, at4, Pt4, lt4, vt6, B6, Lt5;
  var init_menu = __esm({
    "../priv/static/menu.mjs"() {
      "use strict";
      init_chunk_UBXVV7GZ();
      init_chunk_S6MRQC6S();
      init_chunk_5MNNWH4C();
      init_chunk_L4HS2GN2();
      init_chunk_IYURAQ6S();
      $e6 = G("menu").parts("arrow", "arrowTip", "content", "contextTrigger", "indicator", "item", "itemGroup", "itemGroupLabel", "itemIndicator", "itemText", "positioner", "separator", "trigger", "triggerItem");
      E9 = $e6.build();
      Y10 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.trigger) != null ? _b : `menu:${e4.id}:trigger`;
      };
      We6 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.contextTrigger) != null ? _b : `menu:${e4.id}:ctx-trigger`;
      };
      V12 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.content) != null ? _b : `menu:${e4.id}:content`;
      };
      Ke7 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.arrow) != null ? _b : `menu:${e4.id}:arrow`;
      };
      xe7 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.positioner) != null ? _b : `menu:${e4.id}:popper`;
      };
      Xe5 = (e4, t) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = e4.ids) == null ? void 0 : _a2.group) == null ? void 0 : _b.call(_a2, t)) != null ? _c : `menu:${e4.id}:group:${t}`;
      };
      x5 = (e4, t) => `${e4.id}/${t}`;
      N5 = (e4) => {
        var _a2;
        return (_a2 = e4 == null ? void 0 : e4.dataset.value) != null ? _a2 : null;
      };
      Ge6 = (e4, t) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = e4.ids) == null ? void 0 : _a2.groupLabel) == null ? void 0 : _b.call(_a2, t)) != null ? _c : `menu:${e4.id}:group-label:${t}`;
      };
      C10 = (e4) => e4.getById(V12(e4));
      Ve9 = (e4) => e4.getById(xe7(e4));
      K14 = (e4) => e4.getById(Y10(e4));
      Ye7 = (e4, t) => t ? e4.getById(x5(e4, t)) : null;
      re5 = (e4) => e4.getById(We6(e4));
      q10 = (e4) => {
        let o2 = `[role^="menuitem"][data-ownedby=${CSS.escape(V12(e4))}]:not([data-disabled])`;
        return Po(C10(e4), o2);
      };
      je6 = (e4) => Io(q10(e4));
      Je5 = (e4) => Wn(q10(e4));
      ae6 = (e4, t) => t ? e4.id === t || e4.dataset.value === t : false;
      Qe5 = (e4, t) => {
        var _a2;
        let o2 = q10(e4), n = o2.findIndex((a3) => ae6(a3, t.value));
        return Fo(o2, n, { loop: (_a2 = t.loop) != null ? _a2 : t.loopFocus });
      };
      Ze5 = (e4, t) => {
        var _a2;
        let o2 = q10(e4), n = o2.findIndex((a3) => ae6(a3, t.value));
        return jo(o2, n, { loop: (_a2 = t.loop) != null ? _a2 : t.loopFocus });
      };
      ze6 = (e4, t) => {
        var _a2;
        let o2 = q10(e4), n = o2.find((a3) => ae6(a3, t.value));
        return xo(o2, { state: t.typeaheadState, key: t.key, activeId: (_a2 = n == null ? void 0 : n.id) != null ? _a2 : null });
      };
      X9 = (e4) => S(e4) && (e4.dataset.disabled === "" || e4.hasAttribute("disabled"));
      Fe6 = (e4) => {
        var _a2;
        return !!((_a2 = e4 == null ? void 0 : e4.getAttribute("role")) == null ? void 0 : _a2.startsWith("menuitem")) && !!(e4 == null ? void 0 : e4.hasAttribute("data-controls"));
      };
      se6 = "menu:select";
      ({ not: T4, and: G11, or: tt7 } = dr());
      Be6 = { props({ props: e4 }) {
        return __spreadProps(__spreadValues({ closeOnSelect: true, typeahead: true, composite: true, loopFocus: false, navigate(t) {
          yo(t.node);
        } }, e4), { positioning: __spreadValues({ placement: "bottom-start", gutter: 8 }, e4.positioning) });
      }, initialState({ prop: e4 }) {
        return e4("open") || e4("defaultOpen") ? "open" : "idle";
      }, context({ bindable: e4, prop: t }) {
        return { suspendPointer: e4(() => ({ defaultValue: false })), highlightedValue: e4(() => ({ defaultValue: t("defaultHighlightedValue") || null, value: t("highlightedValue"), onChange(o2) {
          var _a2;
          (_a2 = t("onHighlightChange")) == null ? void 0 : _a2({ highlightedValue: o2 });
        } })), lastHighlightedValue: e4(() => ({ defaultValue: null })), currentPlacement: e4(() => ({ defaultValue: void 0 })), intentPolygon: e4(() => ({ defaultValue: null })), anchorPoint: e4(() => ({ defaultValue: null, hash(o2) {
          return `x: ${o2 == null ? void 0 : o2.x}, y: ${o2 == null ? void 0 : o2.y}`;
        } })), isSubmenu: e4(() => ({ defaultValue: false })) };
      }, refs() {
        return { parent: null, children: {}, typeaheadState: __spreadValues({}, xo.defaultOptions), positioningOverride: {} };
      }, computed: { isRtl: ({ prop: e4 }) => e4("dir") === "rtl", isTypingAhead: ({ refs: e4 }) => e4.get("typeaheadState").keysSoFar !== "", highlightedId: ({ context: e4, scope: t, refs: o2 }) => it5(o2.get("children"), e4.get("highlightedValue"), t) }, watch({ track: e4, action: t, context: o2, prop: n }) {
        e4([() => o2.get("isSubmenu")], () => {
          t(["setSubmenuPlacement"]);
        }), e4([() => o2.hash("anchorPoint")], () => {
          o2.get("anchorPoint") && t(["reposition"]);
        }), e4([() => n("open")], () => {
          t(["toggleVisibility"]);
        });
      }, on: { "PARENT.SET": { actions: ["setParentMenu"] }, "CHILD.SET": { actions: ["setChildMenu"] }, OPEN: [{ guard: "isOpenControlled", actions: ["invokeOnOpen"] }, { target: "open", actions: ["invokeOnOpen"] }], OPEN_AUTOFOCUS: [{ guard: "isOpenControlled", actions: ["invokeOnOpen"] }, { target: "open", actions: ["highlightFirstItem", "invokeOnOpen"] }], CLOSE: [{ guard: "isOpenControlled", actions: ["invokeOnClose"] }, { target: "closed", actions: ["invokeOnClose"] }], "HIGHLIGHTED.RESTORE": { actions: ["restoreHighlightedItem"] }, "HIGHLIGHTED.SET": { actions: ["setHighlightedItem"] } }, states: { idle: { tags: ["closed"], on: { "CONTROLLED.OPEN": { target: "open" }, "CONTROLLED.CLOSE": { target: "closed" }, CONTEXT_MENU_START: { target: "opening:contextmenu", actions: ["setAnchorPoint"] }, CONTEXT_MENU: [{ guard: "isOpenControlled", actions: ["setAnchorPoint", "invokeOnOpen"] }, { target: "open", actions: ["setAnchorPoint", "invokeOnOpen"] }], TRIGGER_CLICK: [{ guard: "isOpenControlled", actions: ["invokeOnOpen"] }, { target: "open", actions: ["invokeOnOpen"] }], TRIGGER_FOCUS: { guard: T4("isSubmenu"), target: "closed" }, TRIGGER_POINTERMOVE: { guard: "isSubmenu", target: "opening" } } }, "opening:contextmenu": { tags: ["closed"], effects: ["waitForLongPress"], on: { "CONTROLLED.OPEN": { target: "open" }, "CONTROLLED.CLOSE": { target: "closed" }, CONTEXT_MENU_CANCEL: [{ guard: "isOpenControlled", actions: ["invokeOnClose"] }, { target: "closed", actions: ["invokeOnClose"] }], "LONG_PRESS.OPEN": [{ guard: "isOpenControlled", actions: ["invokeOnOpen"] }, { target: "open", actions: ["invokeOnOpen"] }] } }, opening: { tags: ["closed"], effects: ["waitForOpenDelay"], on: { "CONTROLLED.OPEN": { target: "open" }, "CONTROLLED.CLOSE": { target: "closed" }, BLUR: [{ guard: "isOpenControlled", actions: ["invokeOnClose"] }, { target: "closed", actions: ["invokeOnClose"] }], TRIGGER_POINTERLEAVE: [{ guard: "isOpenControlled", actions: ["invokeOnClose"] }, { target: "closed", actions: ["invokeOnClose"] }], "DELAY.OPEN": [{ guard: "isOpenControlled", actions: ["invokeOnOpen"] }, { target: "open", actions: ["invokeOnOpen"] }] } }, closing: { tags: ["open"], effects: ["trackPointerMove", "trackInteractOutside", "waitForCloseDelay"], on: { "CONTROLLED.OPEN": { target: "open" }, "CONTROLLED.CLOSE": { target: "closed", actions: ["focusParentMenu", "restoreParentHighlightedItem"] }, MENU_POINTERENTER: { target: "open", actions: ["clearIntentPolygon"] }, POINTER_MOVED_AWAY_FROM_SUBMENU: [{ guard: "isOpenControlled", actions: ["invokeOnClose"] }, { target: "closed", actions: ["focusParentMenu", "restoreParentHighlightedItem"] }], "DELAY.CLOSE": [{ guard: "isOpenControlled", actions: ["invokeOnClose"] }, { target: "closed", actions: ["focusParentMenu", "restoreParentHighlightedItem", "invokeOnClose"] }] } }, closed: { tags: ["closed"], entry: ["clearHighlightedItem", "focusTrigger", "resumePointer", "clearAnchorPoint"], on: { "CONTROLLED.OPEN": [{ guard: tt7("isOpenAutoFocusEvent", "isArrowDownEvent"), target: "open", actions: ["highlightFirstItem"] }, { guard: "isArrowUpEvent", target: "open", actions: ["highlightLastItem"] }, { target: "open" }], CONTEXT_MENU_START: { target: "opening:contextmenu", actions: ["setAnchorPoint"] }, CONTEXT_MENU: [{ guard: "isOpenControlled", actions: ["setAnchorPoint", "invokeOnOpen"] }, { target: "open", actions: ["setAnchorPoint", "invokeOnOpen"] }], TRIGGER_CLICK: [{ guard: "isOpenControlled", actions: ["invokeOnOpen"] }, { target: "open", actions: ["invokeOnOpen"] }], TRIGGER_POINTERMOVE: { guard: "isTriggerItem", target: "opening" }, TRIGGER_BLUR: { target: "idle" }, ARROW_DOWN: [{ guard: "isOpenControlled", actions: ["invokeOnOpen"] }, { target: "open", actions: ["highlightFirstItem", "invokeOnOpen"] }], ARROW_UP: [{ guard: "isOpenControlled", actions: ["invokeOnOpen"] }, { target: "open", actions: ["highlightLastItem", "invokeOnOpen"] }] } }, open: { tags: ["open"], effects: ["trackInteractOutside", "trackPositioning", "scrollToHighlightedItem"], entry: ["focusMenu", "resumePointer"], on: { "CONTROLLED.CLOSE": [{ target: "closed", guard: "isArrowLeftEvent", actions: ["focusParentMenu"] }, { target: "closed" }], TRIGGER_CLICK: [{ guard: G11(T4("isTriggerItem"), "isOpenControlled"), actions: ["invokeOnClose"] }, { guard: T4("isTriggerItem"), target: "closed", actions: ["invokeOnClose"] }], CONTEXT_MENU: { actions: ["setAnchorPoint", "focusMenu"] }, ARROW_UP: { actions: ["highlightPrevItem", "focusMenu"] }, ARROW_DOWN: { actions: ["highlightNextItem", "focusMenu"] }, ARROW_LEFT: [{ guard: G11("isSubmenu", "isOpenControlled"), actions: ["invokeOnClose"] }, { guard: "isSubmenu", target: "closed", actions: ["focusParentMenu", "invokeOnClose"] }], HOME: { actions: ["highlightFirstItem", "focusMenu"] }, END: { actions: ["highlightLastItem", "focusMenu"] }, ARROW_RIGHT: { guard: "isTriggerItemHighlighted", actions: ["openSubmenu"] }, ENTER: [{ guard: "isTriggerItemHighlighted", actions: ["openSubmenu"] }, { actions: ["clickHighlightedItem"] }], ITEM_POINTERMOVE: [{ guard: T4("isPointerSuspended"), actions: ["setHighlightedItem", "focusMenu", "closeSiblingMenus"] }, { actions: ["setLastHighlightedItem", "closeSiblingMenus"] }], ITEM_POINTERLEAVE: { guard: G11(T4("isPointerSuspended"), T4("isTriggerItem")), actions: ["clearHighlightedItem"] }, ITEM_CLICK: [{ guard: G11(T4("isTriggerItemHighlighted"), T4("isHighlightedItemEditable"), "closeOnSelect", "isOpenControlled"), actions: ["invokeOnSelect", "setOptionState", "closeRootMenu", "invokeOnClose"] }, { guard: G11(T4("isTriggerItemHighlighted"), T4("isHighlightedItemEditable"), "closeOnSelect"), target: "closed", actions: ["invokeOnSelect", "setOptionState", "closeRootMenu", "invokeOnClose"] }, { guard: G11(T4("isTriggerItemHighlighted"), T4("isHighlightedItemEditable")), actions: ["invokeOnSelect", "setOptionState"] }, { actions: ["setHighlightedItem"] }], TRIGGER_POINTERMOVE: { guard: "isTriggerItem", actions: ["setIntentPolygon"] }, TRIGGER_POINTERLEAVE: { target: "closing", actions: ["setIntentPolygon"] }, ITEM_POINTERDOWN: { actions: ["setHighlightedItem"] }, TYPEAHEAD: { actions: ["highlightMatchedItem"] }, FOCUS_MENU: { actions: ["focusMenu"] }, "POSITIONING.SET": { actions: ["reposition"] } } } }, implementations: { guards: { closeOnSelect: ({ prop: e4, event: t }) => {
        var _a2;
        return !!((_a2 = t == null ? void 0 : t.closeOnSelect) != null ? _a2 : e4("closeOnSelect"));
      }, isTriggerItem: ({ event: e4 }) => Fe6(e4.target), isTriggerItemHighlighted: ({ event: e4, scope: t, computed: o2 }) => {
        var _a2, _b;
        return !!((_b = (_a2 = e4.target) != null ? _a2 : t.getById(o2("highlightedId"))) == null ? void 0 : _b.hasAttribute("data-controls"));
      }, isSubmenu: ({ context: e4 }) => e4.get("isSubmenu"), isPointerSuspended: ({ context: e4 }) => e4.get("suspendPointer"), isHighlightedItemEditable: ({ scope: e4, computed: t }) => _e(e4.getById(t("highlightedId"))), isOpenControlled: ({ prop: e4 }) => e4("open") !== void 0, isArrowLeftEvent: ({ event: e4 }) => {
        var _a2;
        return ((_a2 = e4.previousEvent) == null ? void 0 : _a2.type) === "ARROW_LEFT";
      }, isArrowUpEvent: ({ event: e4 }) => {
        var _a2;
        return ((_a2 = e4.previousEvent) == null ? void 0 : _a2.type) === "ARROW_UP";
      }, isArrowDownEvent: ({ event: e4 }) => {
        var _a2;
        return ((_a2 = e4.previousEvent) == null ? void 0 : _a2.type) === "ARROW_DOWN";
      }, isOpenAutoFocusEvent: ({ event: e4 }) => {
        var _a2;
        return ((_a2 = e4.previousEvent) == null ? void 0 : _a2.type) === "OPEN_AUTOFOCUS";
      } }, effects: { waitForOpenDelay({ send: e4 }) {
        let t = setTimeout(() => {
          e4({ type: "DELAY.OPEN" });
        }, 200);
        return () => clearTimeout(t);
      }, waitForCloseDelay({ send: e4 }) {
        let t = setTimeout(() => {
          e4({ type: "DELAY.CLOSE" });
        }, 100);
        return () => clearTimeout(t);
      }, waitForLongPress({ send: e4 }) {
        let t = setTimeout(() => {
          e4({ type: "LONG_PRESS.OPEN" });
        }, 700);
        return () => clearTimeout(t);
      }, trackPositioning({ context: e4, prop: t, scope: o2, refs: n }) {
        if (re5(o2)) return;
        let a3 = __spreadValues(__spreadValues({}, t("positioning")), n.get("positioningOverride"));
        e4.set("currentPlacement", a3.placement);
        let c5 = () => Ve9(o2);
        return Mn2(K14(o2), c5, __spreadProps(__spreadValues({}, a3), { defer: true, onComplete(r3) {
          e4.set("currentPlacement", r3.placement);
        } }));
      }, trackInteractOutside({ refs: e4, scope: t, prop: o2, context: n, send: a3 }) {
        let c5 = () => C10(t), r3 = true;
        return H9(c5, { type: "menu", defer: true, exclude: [K14(t)], onInteractOutside: o2("onInteractOutside"), onRequestDismiss: o2("onRequestDismiss"), onFocusOutside(s) {
          var _a2;
          (_a2 = o2("onFocusOutside")) == null ? void 0 : _a2(s);
          let d4 = Je(s.detail.originalEvent);
          if (Ie(re5(t), d4)) {
            s.preventDefault();
            return;
          }
        }, onEscapeKeyDown(s) {
          var _a2;
          (_a2 = o2("onEscapeKeyDown")) == null ? void 0 : _a2(s), n.get("isSubmenu") && s.preventDefault(), Ue6({ parent: e4.get("parent") });
        }, onPointerDownOutside(s) {
          var _a2;
          (_a2 = o2("onPointerDownOutside")) == null ? void 0 : _a2(s);
          let d4 = Je(s.detail.originalEvent);
          if (Ie(re5(t), d4) && s.detail.contextmenu) {
            s.preventDefault();
            return;
          }
          r3 = !s.detail.focusable;
        }, onDismiss() {
          a3({ type: "CLOSE", src: "interact-outside", restoreFocus: r3 });
        } });
      }, trackPointerMove({ context: e4, scope: t, send: o2, refs: n, flush: a3 }) {
        let c5 = n.get("parent");
        a3(() => {
          c5.context.set("suspendPointer", true);
        });
        let r3 = t.getDoc();
        return P(r3, "pointermove", (s) => {
          nt5(e4.get("intentPolygon"), { x: s.clientX, y: s.clientY }) || (o2({ type: "POINTER_MOVED_AWAY_FROM_SUBMENU" }), c5.context.set("suspendPointer", false));
        });
      }, scrollToHighlightedItem({ event: e4, scope: t, computed: o2 }) {
        let n = () => {
          if (e4.current().type.startsWith("ITEM_POINTER")) return;
          let c5 = t.getById(o2("highlightedId")), r3 = C10(t);
          bo(c5, { rootEl: r3, block: "nearest" });
        };
        return nt(() => n()), go(() => C10(t), { defer: true, attributes: ["aria-activedescendant"], callback: n });
      } }, actions: { setAnchorPoint({ context: e4, event: t }) {
        e4.set("anchorPoint", (o2) => V(o2, t.point) ? o2 : t.point);
      }, setSubmenuPlacement({ context: e4, computed: t, refs: o2 }) {
        if (!e4.get("isSubmenu")) return;
        let n = t("isRtl") ? "left-start" : "right-start";
        o2.set("positioningOverride", { placement: n, gutter: 0 });
      }, reposition({ context: e4, scope: t, prop: o2, event: n, refs: a3 }) {
        var _a2;
        let c5 = () => Ve9(t), r3 = e4.get("anchorPoint"), s = r3 ? () => __spreadValues({ width: 0, height: 0 }, r3) : void 0, d4 = __spreadValues(__spreadValues({}, o2("positioning")), a3.get("positioningOverride"));
        Mn2(K14(t), c5, __spreadProps(__spreadValues(__spreadProps(__spreadValues({}, d4), { defer: true, getAnchorRect: s }), (_a2 = n.options) != null ? _a2 : {}), { listeners: false, onComplete(m5) {
          e4.set("currentPlacement", m5.placement);
        } }));
      }, setOptionState({ event: e4 }) {
        if (!e4.option) return;
        let { checked: t, onCheckedChange: o2, type: n } = e4.option;
        n === "radio" ? o2 == null ? void 0 : o2(true) : n === "checkbox" && (o2 == null ? void 0 : o2(!t));
      }, clickHighlightedItem({ scope: e4, computed: t, prop: o2, context: n }) {
        var _a2;
        let a3 = e4.getById(t("highlightedId"));
        if (!a3 || a3.dataset.disabled) return;
        let c5 = n.get("highlightedValue");
        $r(a3) ? (_a2 = o2("navigate")) == null ? void 0 : _a2({ value: c5, node: a3, href: a3.href }) : queueMicrotask(() => a3.click());
      }, setIntentPolygon({ context: e4, scope: t, event: o2 }) {
        let n = C10(t), a3 = e4.get("currentPlacement");
        if (!n || !a3) return;
        let c5 = n.getBoundingClientRect(), r3 = et2(c5, a3);
        if (!r3) return;
        let d4 = Dn2(a3) === "right" ? -5 : 5;
        e4.set("intentPolygon", [__spreadProps(__spreadValues({}, o2.point), { x: o2.point.x + d4 }), ...r3]);
      }, clearIntentPolygon({ context: e4 }) {
        e4.set("intentPolygon", null);
      }, clearAnchorPoint({ context: e4 }) {
        e4.set("anchorPoint", null);
      }, resumePointer({ refs: e4, flush: t }) {
        let o2 = e4.get("parent");
        o2 && t(() => {
          o2.context.set("suspendPointer", false);
        });
      }, setHighlightedItem({ context: e4, event: t }) {
        let o2 = t.value || N5(t.target);
        e4.set("highlightedValue", o2);
      }, clearHighlightedItem({ context: e4 }) {
        e4.set("highlightedValue", null);
      }, focusMenu({ scope: e4 }) {
        nt(() => {
          var _a2;
          let t = C10(e4);
          (_a2 = ho({ root: t, enabled: !Ie(t, e4.getActiveElement()), filter(n) {
            var _a3;
            return !((_a3 = n.role) == null ? void 0 : _a3.startsWith("menuitem"));
          } })) == null ? void 0 : _a2.focus({ preventScroll: true });
        });
      }, highlightFirstItem({ context: e4, scope: t }) {
        (C10(t) ? queueMicrotask : nt)(() => {
          let n = je6(t);
          n && e4.set("highlightedValue", N5(n));
        });
      }, highlightLastItem({ context: e4, scope: t }) {
        (C10(t) ? queueMicrotask : nt)(() => {
          let n = Je5(t);
          n && e4.set("highlightedValue", N5(n));
        });
      }, highlightNextItem({ context: e4, scope: t, event: o2, prop: n }) {
        let a3 = Qe5(t, { loop: o2.loop, value: e4.get("highlightedValue"), loopFocus: n("loopFocus") });
        e4.set("highlightedValue", N5(a3));
      }, highlightPrevItem({ context: e4, scope: t, event: o2, prop: n }) {
        let a3 = Ze5(t, { loop: o2.loop, value: e4.get("highlightedValue"), loopFocus: n("loopFocus") });
        e4.set("highlightedValue", N5(a3));
      }, invokeOnSelect({ context: e4, prop: t, scope: o2 }) {
        var _a2;
        let n = e4.get("highlightedValue");
        if (n == null) return;
        let a3 = Ye7(o2, n);
        et6(a3, n), (_a2 = t("onSelect")) == null ? void 0 : _a2({ value: n });
      }, focusTrigger({ scope: e4, context: t, event: o2 }) {
        t.get("isSubmenu") || t.get("anchorPoint") || o2.restoreFocus === false || queueMicrotask(() => {
          var _a2;
          return (_a2 = K14(e4)) == null ? void 0 : _a2.focus({ preventScroll: true });
        });
      }, highlightMatchedItem({ scope: e4, context: t, event: o2, refs: n }) {
        let a3 = ze6(e4, { key: o2.key, value: t.get("highlightedValue"), typeaheadState: n.get("typeaheadState") });
        a3 && t.set("highlightedValue", N5(a3));
      }, setParentMenu({ refs: e4, event: t, context: o2 }) {
        e4.set("parent", t.value), o2.set("isSubmenu", true);
      }, setChildMenu({ refs: e4, event: t }) {
        let o2 = e4.get("children");
        o2[t.id] = t.value, e4.set("children", o2);
      }, closeSiblingMenus({ refs: e4, event: t, scope: o2 }) {
        var _a2;
        let n = t.target;
        if (!Fe6(n)) return;
        let a3 = n == null ? void 0 : n.getAttribute("data-uid"), c5 = e4.get("children");
        for (let r3 in c5) {
          if (r3 === a3) continue;
          let s = c5[r3], d4 = s.context.get("intentPolygon");
          d4 && t.point && it2(d4, t.point) || ((_a2 = C10(o2)) == null ? void 0 : _a2.focus({ preventScroll: true }), s.send({ type: "CLOSE" }));
        }
      }, closeRootMenu({ refs: e4 }) {
        Ue6({ parent: e4.get("parent") });
      }, openSubmenu({ refs: e4, scope: t, computed: o2 }) {
        var _a2, _b;
        let a3 = (_a2 = t.getById(o2("highlightedId"))) == null ? void 0 : _a2.getAttribute("data-uid"), c5 = e4.get("children");
        (_b = a3 ? c5[a3] : null) == null ? void 0 : _b.send({ type: "OPEN_AUTOFOCUS" });
      }, focusParentMenu({ refs: e4 }) {
        var _a2;
        (_a2 = e4.get("parent")) == null ? void 0 : _a2.send({ type: "FOCUS_MENU" });
      }, setLastHighlightedItem({ context: e4, event: t }) {
        e4.set("lastHighlightedValue", N5(t.target));
      }, restoreHighlightedItem({ context: e4 }) {
        e4.get("lastHighlightedValue") && (e4.set("highlightedValue", e4.get("lastHighlightedValue")), e4.set("lastHighlightedValue", null));
      }, restoreParentHighlightedItem({ refs: e4 }) {
        var _a2;
        (_a2 = e4.get("parent")) == null ? void 0 : _a2.send({ type: "HIGHLIGHTED.RESTORE" });
      }, invokeOnOpen({ prop: e4 }) {
        var _a2;
        (_a2 = e4("onOpenChange")) == null ? void 0 : _a2({ open: true });
      }, invokeOnClose({ prop: e4 }) {
        var _a2;
        (_a2 = e4("onOpenChange")) == null ? void 0 : _a2({ open: false });
      }, toggleVisibility({ prop: e4, event: t, send: o2 }) {
        o2({ type: e4("open") ? "CONTROLLED.OPEN" : "CONTROLLED.CLOSE", previousEvent: t });
      } } } };
      ot4 = As()(["anchorPoint", "aria-label", "closeOnSelect", "composite", "defaultHighlightedValue", "defaultOpen", "dir", "getRootNode", "highlightedValue", "id", "ids", "loopFocus", "navigate", "onEscapeKeyDown", "onFocusOutside", "onHighlightChange", "onInteractOutside", "onOpenChange", "onPointerDownOutside", "onRequestDismiss", "onSelect", "open", "positioning", "typeahead"]);
      ft5 = as(ot4);
      rt5 = As()(["closeOnSelect", "disabled", "value", "valueText"]);
      Tt4 = as(rt5);
      st5 = As()(["htmlFor"]);
      It5 = as(st5);
      at4 = As()(["id"]);
      Pt4 = as(at4);
      lt4 = As()(["checked", "closeOnSelect", "disabled", "onCheckedChange", "type", "value", "valueText"]);
      vt6 = as(lt4);
      B6 = class extends ve {
        constructor() {
          super(...arguments);
          __publicField(this, "children", []);
        }
        initMachine(t) {
          return new Ls(Be6, t);
        }
        initApi() {
          return qe7(this.machine.service, Cs);
        }
        setChild(t) {
          this.api.setChild(t.machine.service), this.children.includes(t) || this.children.push(t);
        }
        setParent(t) {
          this.api.setParent(t.machine.service);
        }
        isOwnElement(t) {
          return t.closest('[phx-hook="Menu"]') === this.el;
        }
        renderSubmenuTriggers() {
          let t = this.el.querySelector('[data-scope="menu"][data-part="content"]');
          if (!t) return;
          let o2 = t.querySelectorAll('[data-scope="menu"][data-nested-menu]');
          for (let n of o2) {
            if (!this.isOwnElement(n)) continue;
            let a3 = n.dataset.nestedMenu;
            if (!a3) continue;
            let c5 = this.children.find((s) => s.el.id === `menu:${a3}`);
            if (!c5) continue;
            let r3 = () => {
              let s = this.api.getTriggerItemProps(c5.api);
              this.spreadProps(n, s);
            };
            r3(), this.machine.subscribe(r3), c5.machine.subscribe(r3);
          }
        }
        render() {
          let t = this.el.querySelector('[data-scope="menu"][data-part="trigger"]');
          t && this.spreadProps(t, this.api.getTriggerProps());
          let o2 = this.el.querySelector('[data-scope="menu"][data-part="positioner"]'), n = this.el.querySelector('[data-scope="menu"][data-part="content"]');
          if (o2 && n) {
            this.spreadProps(o2, this.api.getPositionerProps()), this.spreadProps(n, this.api.getContentProps()), n.style.pointerEvents = "auto", o2.hidden = !this.api.open;
            let c5 = !this.el.querySelector('[data-scope="menu"][data-part="trigger"]');
            (this.api.open || c5) && (n.querySelectorAll('[data-scope="menu"][data-part="item"]').forEach((h6) => {
              if (!this.isOwnElement(h6)) return;
              let p4 = h6.dataset.value;
              if (p4) {
                let M10 = h6.hasAttribute("data-disabled");
                this.spreadProps(h6, this.api.getItemProps({ value: p4, disabled: M10 || void 0 }));
              }
            }), n.querySelectorAll('[data-scope="menu"][data-part="item-group"]').forEach((h6) => {
              if (!this.isOwnElement(h6)) return;
              let p4 = h6.id;
              p4 && this.spreadProps(h6, this.api.getItemGroupProps({ id: p4 }));
            }), n.querySelectorAll('[data-scope="menu"][data-part="separator"]').forEach((h6) => {
              this.isOwnElement(h6) && this.spreadProps(h6, this.api.getSeparatorProps());
            }));
          }
          let a3 = this.el.querySelector('[data-scope="menu"][data-part="indicator"]');
          a3 && this.spreadProps(a3, this.api.getIndicatorProps());
        }
      };
      Lt5 = { mounted() {
        let e4 = this.el;
        if (e4.hasAttribute("data-nested")) return;
        let t = this.pushEvent.bind(this), o2 = () => {
          var _a2;
          return (_a2 = this.liveSocket) == null ? void 0 : _a2.main;
        }, n = new B6(e4, __spreadProps(__spreadValues({ id: e4.id.replace("menu:", "") }, _r(e4, "controlled") ? { open: _r(e4, "open") } : { defaultOpen: _r(e4, "defaultOpen") }), { closeOnSelect: _r(e4, "closeOnSelect"), loopFocus: _r(e4, "loopFocus"), typeahead: _r(e4, "typeahead"), composite: _r(e4, "composite"), dir: xr(e4, "dir", ["ltr", "rtl"]), onSelect: (r3) => {
          var _a2, _b, _c;
          let s = _r(e4, "redirect"), d4 = [...e4.querySelectorAll('[data-scope="menu"][data-part="item"]')].find((k14) => k14.getAttribute("data-value") === r3.value), m5 = d4 == null ? void 0 : d4.getAttribute("data-redirect"), h6 = d4 == null ? void 0 : d4.hasAttribute("data-new-tab"), p4 = o2();
          s && r3.value && ((_a2 = p4 == null ? void 0 : p4.isDead) != null ? _a2 : true) && m5 !== "false" && (h6 ? window.open(r3.value, "_blank", "noopener,noreferrer") : window.location.href = r3.value);
          let R7 = xr(e4, "onSelect");
          R7 && p4 && !p4.isDead && p4.isConnected() && t(R7, { id: e4.id, value: (_b = r3.value) != null ? _b : null });
          let b10 = xr(e4, "onSelectClient");
          b10 && e4.dispatchEvent(new CustomEvent(b10, { bubbles: true, detail: { id: e4.id, value: (_c = r3.value) != null ? _c : null } }));
        }, onOpenChange: (r3) => {
          var _a2, _b;
          let s = o2(), d4 = xr(e4, "onOpenChange");
          d4 && s && !s.isDead && s.isConnected() && t(d4, { id: e4.id, open: (_a2 = r3.open) != null ? _a2 : false });
          let m5 = xr(e4, "onOpenChangeClient");
          m5 && e4.dispatchEvent(new CustomEvent(m5, { bubbles: true, detail: { id: e4.id, open: (_b = r3.open) != null ? _b : false } }));
        } }));
        n.init(), this.menu = n, this.nestedMenus = /* @__PURE__ */ new Map();
        let a3 = e4.querySelectorAll('[data-scope="menu"][data-nested="menu"]'), c5 = [];
        a3.forEach((r3, s) => {
          var _a2;
          let d4 = r3.id;
          if (d4) {
            let m5 = `${d4}-${s}`, h6 = new B6(r3, { id: m5, dir: xr(r3, "dir", ["ltr", "rtl"]), closeOnSelect: _r(r3, "closeOnSelect"), loopFocus: _r(r3, "loopFocus"), typeahead: _r(r3, "typeahead"), composite: _r(r3, "composite"), onSelect: (p4) => {
              var _a3, _b, _c;
              let M10 = _r(e4, "redirect"), R7 = [...e4.querySelectorAll('[data-scope="menu"][data-part="item"]')].find((i) => i.getAttribute("data-value") === p4.value), b10 = R7 == null ? void 0 : R7.getAttribute("data-redirect"), k14 = R7 == null ? void 0 : R7.hasAttribute("data-new-tab"), S13 = o2();
              M10 && p4.value && ((_a3 = S13 == null ? void 0 : S13.isDead) != null ? _a3 : true) && b10 !== "false" && (k14 ? window.open(p4.value, "_blank", "noopener,noreferrer") : window.location.href = p4.value);
              let L13 = xr(e4, "onSelect");
              L13 && S13 && !S13.isDead && S13.isConnected() && t(L13, { id: e4.id, value: (_b = p4.value) != null ? _b : null });
              let H12 = xr(e4, "onSelectClient");
              H12 && e4.dispatchEvent(new CustomEvent(H12, { bubbles: true, detail: { id: e4.id, value: (_c = p4.value) != null ? _c : null } }));
            } });
            h6.init(), (_a2 = this.nestedMenus) == null ? void 0 : _a2.set(d4, h6), c5.push(h6);
          }
        }), setTimeout(() => {
          c5.forEach((r3) => {
            this.menu && (this.menu.setChild(r3), r3.setParent(this.menu));
          }), this.menu && this.menu.children.length > 0 && this.menu.renderSubmenuTriggers();
        }, 0), this.onSetOpen = (r3) => {
          let { open: s } = r3.detail;
          n.api.open !== s && n.api.setOpen(s);
        }, e4.addEventListener("phx:menu:set-open", this.onSetOpen), this.handlers = [], this.handlers.push(this.handleEvent("menu_set_open", (r3) => {
          let s = r3.menu_id;
          (!s || e4.id === s || e4.id === `menu:${s}`) && n.api.setOpen(r3.open);
        })), this.handlers.push(this.handleEvent("menu_open", () => {
          this.pushEvent("menu_open_response", { open: n.api.open });
        }));
      }, updated() {
        var _a2;
        this.el.hasAttribute("data-nested") || ((_a2 = this.menu) == null ? void 0 : _a2.updateProps(__spreadProps(__spreadValues({ id: this.el.id }, _r(this.el, "controlled") ? { open: _r(this.el, "open") } : { defaultOpen: _r(this.el, "defaultOpen") }), { closeOnSelect: _r(this.el, "closeOnSelect"), loopFocus: _r(this.el, "loopFocus"), typeahead: _r(this.el, "typeahead"), composite: _r(this.el, "composite"), dir: xr(this.el, "dir", ["ltr", "rtl"]) })));
      }, destroyed() {
        var _a2;
        if (!this.el.hasAttribute("data-nested")) {
          if (this.onSetOpen && this.el.removeEventListener("phx:menu:set-open", this.onSetOpen), this.handlers) for (let e4 of this.handlers) this.removeHandleEvent(e4);
          if (this.nestedMenus) for (let [, e4] of this.nestedMenus) e4.destroy();
          (_a2 = this.menu) == null ? void 0 : _a2.destroy();
        }
      } };
    }
  });

  // ../priv/static/number-input.mjs
  var number_input_exports = {};
  __export(number_input_exports, {
    NumberInput: () => Vt4
  });
  function Ue7(e4, t = {}) {
    let { numberingSystem: r3 } = t;
    if (r3 && e4.includes("-nu-") && (e4.includes("-u-") || (e4 += "-u-"), e4 += `-nu-${r3}`), t.style === "unit" && !k11) {
      var n;
      let { unit: s, unitDisplay: l4 = "short" } = t;
      if (!s) throw new Error('unit option must be provided with style: "unit"');
      if (!(!((n = Se8[s]) === null || n === void 0) && n[l4])) throw new Error(`Unsupported unit ${s} with unitDisplay = ${l4}`);
      t = __spreadProps(__spreadValues({}, t), { style: "decimal" });
    }
    let i = e4 + (t ? Object.entries(t).sort((s, l4) => s[0] < l4[0] ? -1 : 1).join() : "");
    if (Y11.has(i)) return Y11.get(i);
    let a3 = new Intl.NumberFormat(e4, t);
    return Y11.set(i, a3), a3;
  }
  function ke7(e4, t, r3) {
    if (t === "auto") return e4.format(r3);
    if (t === "never") return e4.format(Math.abs(r3));
    {
      let n = false;
      if (t === "always" ? n = r3 > 0 || Object.is(r3, 0) : t === "exceptZero" && (Object.is(r3, -0) || Object.is(r3, 0) ? r3 = Math.abs(r3) : n = r3 > 0), n) {
        let i = e4.format(-r3), a3 = e4.format(r3), s = i.replace(a3, "").replace(/\u200e|\u061C/, "");
        return [...s].length !== 1 && console.warn("@react-aria/i18n polyfill for NumberFormat signDisplay: Unsupported case"), i.replace(a3, "!!!").replace(s, "+").replace("!!!", a3);
      } else return e4.format(r3);
    }
  }
  function z8(e4, t, r3) {
    let n = Ie6(e4, t);
    if (!e4.includes("-nu-") && !n.isValidPartialNumber(r3)) {
      for (let i of _e6) if (i !== n.options.numberingSystem) {
        let a3 = Ie6(e4 + (e4.includes("-u-") ? "-nu-" : "-u-nu-") + i, t);
        if (a3.isValidPartialNumber(r3)) return a3;
      }
    }
    return n;
  }
  function Ie6(e4, t) {
    let r3 = e4 + (t ? Object.entries(t).sort((i, a3) => i[0] < a3[0] ? -1 : 1).join() : ""), n = Te6.get(r3);
    return n || (n = new K15(e4, t), Te6.set(r3, n)), n;
  }
  function We7(e4, t, r3, n) {
    var i, a3, s, l4;
    let u3 = new Intl.NumberFormat(e4, __spreadProps(__spreadValues({}, r3), { minimumSignificantDigits: 1, maximumSignificantDigits: 21, roundingIncrement: 1, roundingPriority: "auto", roundingMode: "halfExpand" })), c5 = u3.formatToParts(-10000.111), g7 = u3.formatToParts(10000.111), p4 = Ge7.map((d4) => u3.formatToParts(d4));
    var D11;
    let b10 = (D11 = (i = c5.find((d4) => d4.type === "minusSign")) === null || i === void 0 ? void 0 : i.value) !== null && D11 !== void 0 ? D11 : "-", P11 = (a3 = g7.find((d4) => d4.type === "plusSign")) === null || a3 === void 0 ? void 0 : a3.value;
    !P11 && ((n == null ? void 0 : n.signDisplay) === "exceptZero" || (n == null ? void 0 : n.signDisplay) === "always") && (P11 = "+");
    let F10 = (s = new Intl.NumberFormat(e4, __spreadProps(__spreadValues({}, r3), { minimumFractionDigits: 2, maximumFractionDigits: 2 })).formatToParts(1e-3).find((d4) => d4.type === "decimal")) === null || s === void 0 ? void 0 : s.value, o2 = (l4 = c5.find((d4) => d4.type === "group")) === null || l4 === void 0 ? void 0 : l4.value, f4 = c5.filter((d4) => !Re6.has(d4.type)).map((d4) => xe8(d4.value)), O10 = p4.flatMap((d4) => d4.filter((N10) => !Re6.has(N10.type)).map((N10) => xe8(N10.value))), v10 = [.../* @__PURE__ */ new Set([...f4, ...O10])].sort((d4, N10) => N10.length - d4.length), w10 = v10.length === 0 ? new RegExp("[\\p{White_Space}]", "gu") : new RegExp(`${v10.join("|")}|[\\p{White_Space}]`, "gu"), A12 = [...new Intl.NumberFormat(r3.locale, { useGrouping: false }).format(9876543210)].reverse(), Fe9 = new Map(A12.map((d4, N10) => [d4, N10])), He8 = new RegExp(`[${A12.join("")}]`, "g");
    return { minusSign: b10, plusSign: P11, decimal: F10, group: o2, literals: w10, numeral: He8, index: (d4) => String(Fe9.get(d4)) };
  }
  function x6(e4, t, r3) {
    return e4.replaceAll ? e4.replaceAll(t, r3) : e4.split(t).join(r3);
  }
  function xe8(e4) {
    return e4.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  }
  function Q11(e4, t) {
    if (!(!e4 || !t.isActiveElement(e4))) try {
      let { selectionStart: r3, selectionEnd: n, value: i } = e4;
      return r3 == null || n == null ? void 0 : { start: r3, end: n, value: i };
    } catch (e5) {
      return;
    }
  }
  function je7(e4, t, r3) {
    if (!(!e4 || !r3.isActiveElement(e4))) {
      if (!t) {
        let n = e4.value.length;
        e4.setSelectionRange(n, n);
        return;
      }
      try {
        let n = e4.value, { start: i, end: a3, value: s } = t;
        if (n === s) {
          e4.setSelectionRange(i, a3);
          return;
        }
        let l4 = Ce7(s, n, i), u3 = i === a3 ? l4 : Ce7(s, n, a3), c5 = Math.max(0, Math.min(l4, n.length)), g7 = Math.max(c5, Math.min(u3, n.length));
        e4.setSelectionRange(c5, g7);
      } catch (e5) {
        let n = e4.value.length;
        e4.setSelectionRange(n, n);
      }
    }
  }
  function Ce7(e4, t, r3) {
    let n = e4.slice(0, r3), i = e4.slice(r3), a3 = 0, s = Math.min(n.length, t.length);
    for (let c5 = 0; c5 < s && n[c5] === t[c5]; c5++) a3 = c5 + 1;
    let l4 = 0, u3 = Math.min(i.length, t.length - a3);
    for (let c5 = 0; c5 < u3; c5++) {
      let g7 = i.length - 1 - c5, p4 = t.length - 1 - c5;
      if (i[g7] === t[p4]) l4 = c5 + 1;
      else break;
    }
    if (n.length > 0 && a3 >= n.length) return a3;
    if (l4 >= i.length) return t.length - l4;
    if (a3 > 0) return a3;
    if (l4 > 0) return t.length - l4;
    if (r3 === 0 && a3 === 0 && l4 === 0) return t.length;
    if (e4.length > 0) {
      let c5 = r3 / e4.length;
      return Math.round(c5 * t.length);
    }
    return t.length;
  }
  function $e7(e4, t) {
    let { state: r3, send: n, prop: i, scope: a3, computed: s } = e4, l4 = r3.hasTag("focus"), u3 = s("isDisabled"), c5 = !!i("readOnly"), g7 = !!i("required"), p4 = r3.matches("scrubbing"), D11 = s("isValueEmpty"), b10 = s("isOutOfRange") || !!i("invalid"), P11 = u3 || !s("canIncrement") || c5, V16 = u3 || !s("canDecrement") || c5, F10 = i("translations");
    return { focused: l4, invalid: b10, empty: D11, value: s("formattedValue"), valueAsNumber: s("valueAsNumber"), setValue(o2) {
      n({ type: "VALUE.SET", value: o2 });
    }, clearValue() {
      n({ type: "VALUE.CLEAR" });
    }, increment() {
      n({ type: "VALUE.INCREMENT" });
    }, decrement() {
      n({ type: "VALUE.DECREMENT" });
    }, setToMax() {
      n({ type: "VALUE.SET", value: i("max") });
    }, setToMin() {
      n({ type: "VALUE.SET", value: i("min") });
    }, focus() {
      var _a2;
      (_a2 = I10(a3)) == null ? void 0 : _a2.focus();
    }, getRootProps() {
      return t.element(__spreadProps(__spreadValues({ id: Ze6(a3) }, E10.root.attrs), { dir: i("dir"), "data-disabled": jr(u3), "data-focus": jr(l4), "data-invalid": jr(b10), "data-scrubbing": jr(p4) }));
    }, getLabelProps() {
      return t.label(__spreadProps(__spreadValues({}, E10.label.attrs), { dir: i("dir"), "data-disabled": jr(u3), "data-focus": jr(l4), "data-invalid": jr(b10), "data-required": jr(g7), "data-scrubbing": jr(p4), id: Xe6(a3), htmlFor: L10(a3), onClick() {
        nt(() => {
          Kr(I10(a3));
        });
      } }));
    }, getControlProps() {
      return t.element(__spreadProps(__spreadValues({}, E10.control.attrs), { dir: i("dir"), role: "group", "aria-disabled": u3, "data-focus": jr(l4), "data-disabled": jr(u3), "data-invalid": jr(b10), "data-scrubbing": jr(p4), "aria-invalid": Br(b10) }));
    }, getValueTextProps() {
      return t.element(__spreadProps(__spreadValues({}, E10.valueText.attrs), { dir: i("dir"), "data-disabled": jr(u3), "data-invalid": jr(b10), "data-focus": jr(l4), "data-scrubbing": jr(p4) }));
    }, getInputProps() {
      return t.input(__spreadProps(__spreadValues({}, E10.input.attrs), { dir: i("dir"), name: i("name"), form: i("form"), id: L10(a3), role: "spinbutton", defaultValue: s("formattedValue"), pattern: i("formatOptions") ? void 0 : i("pattern"), inputMode: i("inputMode"), "aria-invalid": Br(b10), "data-invalid": jr(b10), disabled: u3, "data-disabled": jr(u3), readOnly: c5, required: i("required"), autoComplete: "off", autoCorrect: "off", spellCheck: "false", type: "text", "aria-roledescription": "numberfield", "aria-valuemin": i("min"), "aria-valuemax": i("max"), "aria-valuenow": Number.isNaN(s("valueAsNumber")) ? void 0 : s("valueAsNumber"), "aria-valuetext": s("valueText"), "data-scrubbing": jr(p4), onFocus() {
        n({ type: "INPUT.FOCUS" });
      }, onBlur() {
        n({ type: "INPUT.BLUR" });
      }, onInput(o2) {
        let f4 = Q11(o2.currentTarget, a3);
        n({ type: "INPUT.CHANGE", target: o2.currentTarget, hint: "set", selection: f4 });
      }, onBeforeInput(o2) {
        var _a2;
        try {
          let { selectionStart: f4, selectionEnd: O10, value: v10 } = o2.currentTarget, w10 = v10.slice(0, f4) + ((_a2 = o2.data) != null ? _a2 : "") + v10.slice(O10);
          s("parser").isValidPartialNumber(w10) || o2.preventDefault();
        } catch (e5) {
        }
      }, onKeyDown(o2) {
        if (o2.defaultPrevented || c5 || to(o2)) return;
        let f4 = co(o2) * i("step"), v10 = { ArrowUp() {
          n({ type: "INPUT.ARROW_UP", step: f4 }), o2.preventDefault();
        }, ArrowDown() {
          n({ type: "INPUT.ARROW_DOWN", step: f4 }), o2.preventDefault();
        }, Home() {
          so(o2) || (n({ type: "INPUT.HOME" }), o2.preventDefault());
        }, End() {
          so(o2) || (n({ type: "INPUT.END" }), o2.preventDefault());
        }, Enter(w10) {
          let A12 = Q11(w10.currentTarget, a3);
          n({ type: "INPUT.ENTER", selection: A12 });
        } }[o2.key];
        v10 == null ? void 0 : v10(o2);
      } }));
    }, getDecrementTriggerProps() {
      return t.button(__spreadProps(__spreadValues({}, E10.decrementTrigger.attrs), { dir: i("dir"), id: we5(a3), disabled: V16, "data-disabled": jr(V16), "aria-label": F10.decrementLabel, type: "button", tabIndex: -1, "aria-controls": L10(a3), "data-scrubbing": jr(p4), onPointerDown(o2) {
        var _a2;
        V16 || ro(o2) && (n({ type: "TRIGGER.PRESS_DOWN", hint: "decrement", pointerType: o2.pointerType }), o2.pointerType === "mouse" && o2.preventDefault(), o2.pointerType === "touch" && ((_a2 = o2.currentTarget) == null ? void 0 : _a2.focus({ preventScroll: true })));
      }, onPointerUp(o2) {
        n({ type: "TRIGGER.PRESS_UP", hint: "decrement", pointerType: o2.pointerType });
      }, onPointerLeave() {
        V16 || n({ type: "TRIGGER.PRESS_UP", hint: "decrement" });
      } }));
    }, getIncrementTriggerProps() {
      return t.button(__spreadProps(__spreadValues({}, E10.incrementTrigger.attrs), { dir: i("dir"), id: Oe8(a3), disabled: P11, "data-disabled": jr(P11), "aria-label": F10.incrementLabel, type: "button", tabIndex: -1, "aria-controls": L10(a3), "data-scrubbing": jr(p4), onPointerDown(o2) {
        var _a2;
        P11 || !ro(o2) || (n({ type: "TRIGGER.PRESS_DOWN", hint: "increment", pointerType: o2.pointerType }), o2.pointerType === "mouse" && o2.preventDefault(), o2.pointerType === "touch" && ((_a2 = o2.currentTarget) == null ? void 0 : _a2.focus({ preventScroll: true })));
      }, onPointerUp(o2) {
        n({ type: "TRIGGER.PRESS_UP", hint: "increment", pointerType: o2.pointerType });
      }, onPointerLeave(o2) {
        n({ type: "TRIGGER.PRESS_UP", hint: "increment", pointerType: o2.pointerType });
      } }));
    }, getScrubberProps() {
      return t.element(__spreadProps(__spreadValues({}, E10.scrubber.attrs), { dir: i("dir"), "data-disabled": jr(u3), id: Ye8(a3), role: "presentation", "data-scrubbing": jr(p4), onMouseDown(o2) {
        if (u3 || !ro(o2)) return;
        let f4 = gt(o2), v10 = T(o2.currentTarget).devicePixelRatio;
        f4.x = f4.x - es(7.5, v10), f4.y = f4.y - es(7.5, v10), n({ type: "SCRUBBER.PRESS_DOWN", point: f4 }), o2.preventDefault(), nt(() => {
          Kr(I10(a3));
        });
      }, style: { cursor: u3 ? void 0 : "ew-resize" } }));
    } };
  }
  var Y11, X10, k11, Se8, B7, Be7, _e6, C11, Te6, K15, Re6, Ge7, qe8, E10, Ze6, L10, Oe8, we5, Ye8, Ae5, Xe6, I10, ze7, Ke8, Me6, Je6, Qe6, et7, tt8, rt6, nt6, it6, J10, T5, at5, st6, ot5, lt5, De5, Ve10, Le7, ut7, Nt4, _9, Vt4;
  var init_number_input = __esm({
    "../priv/static/number-input.mjs"() {
      "use strict";
      init_chunk_IYURAQ6S();
      Y11 = /* @__PURE__ */ new Map();
      X10 = false;
      try {
        X10 = new Intl.NumberFormat("de-DE", { signDisplay: "exceptZero" }).resolvedOptions().signDisplay === "exceptZero";
      } catch (e4) {
      }
      k11 = false;
      try {
        k11 = new Intl.NumberFormat("de-DE", { style: "unit", unit: "degree" }).resolvedOptions().style === "unit";
      } catch (e4) {
      }
      Se8 = { degree: { narrow: { default: "\xB0", "ja-JP": " \u5EA6", "zh-TW": "\u5EA6", "sl-SI": " \xB0" } } };
      B7 = class {
        format(t) {
          let r3 = "";
          if (!X10 && this.options.signDisplay != null ? r3 = ke7(this.numberFormatter, this.options.signDisplay, t) : r3 = this.numberFormatter.format(t), this.options.style === "unit" && !k11) {
            var n;
            let { unit: i, unitDisplay: a3 = "short", locale: s } = this.resolvedOptions();
            if (!i) return r3;
            let l4 = (n = Se8[i]) === null || n === void 0 ? void 0 : n[a3];
            r3 += l4[s] || l4.default;
          }
          return r3;
        }
        formatToParts(t) {
          return this.numberFormatter.formatToParts(t);
        }
        formatRange(t, r3) {
          if (typeof this.numberFormatter.formatRange == "function") return this.numberFormatter.formatRange(t, r3);
          if (r3 < t) throw new RangeError("End date must be >= start date");
          return `${this.format(t)} \u2013 ${this.format(r3)}`;
        }
        formatRangeToParts(t, r3) {
          if (typeof this.numberFormatter.formatRangeToParts == "function") return this.numberFormatter.formatRangeToParts(t, r3);
          if (r3 < t) throw new RangeError("End date must be >= start date");
          let n = this.numberFormatter.formatToParts(t), i = this.numberFormatter.formatToParts(r3);
          return [...n.map((a3) => __spreadProps(__spreadValues({}, a3), { source: "startRange" })), { type: "literal", value: " \u2013 ", source: "shared" }, ...i.map((a3) => __spreadProps(__spreadValues({}, a3), { source: "endRange" }))];
        }
        resolvedOptions() {
          let t = this.numberFormatter.resolvedOptions();
          return !X10 && this.options.signDisplay != null && (t = __spreadProps(__spreadValues({}, t), { signDisplay: this.options.signDisplay })), !k11 && this.options.style === "unit" && (t = __spreadProps(__spreadValues({}, t), { style: "unit", unit: this.options.unit, unitDisplay: this.options.unitDisplay })), t;
        }
        constructor(t, r3 = {}) {
          this.numberFormatter = Ue7(t, r3), this.options = r3;
        }
      };
      Be7 = new RegExp("^.*\\(.*\\).*$");
      _e6 = ["latn", "arab", "hanidec", "deva", "beng", "fullwide"];
      C11 = class {
        parse(t) {
          return z8(this.locale, this.options, t).parse(t);
        }
        isValidPartialNumber(t, r3, n) {
          return z8(this.locale, this.options, t).isValidPartialNumber(t, r3, n);
        }
        getNumberingSystem(t) {
          return z8(this.locale, this.options, t).options.numberingSystem;
        }
        constructor(t, r3 = {}) {
          this.locale = t, this.options = r3;
        }
      };
      Te6 = /* @__PURE__ */ new Map();
      K15 = class {
        parse(t) {
          let r3 = this.sanitize(t);
          if (this.symbols.group && (r3 = x6(r3, this.symbols.group, "")), this.symbols.decimal && (r3 = r3.replace(this.symbols.decimal, ".")), this.symbols.minusSign && (r3 = r3.replace(this.symbols.minusSign, "-")), r3 = r3.replace(this.symbols.numeral, this.symbols.index), this.options.style === "percent") {
            let s = r3.indexOf("-");
            r3 = r3.replace("-", ""), r3 = r3.replace("+", "");
            let l4 = r3.indexOf(".");
            l4 === -1 && (l4 = r3.length), r3 = r3.replace(".", ""), l4 - 2 === 0 ? r3 = `0.${r3}` : l4 - 2 === -1 ? r3 = `0.0${r3}` : l4 - 2 === -2 ? r3 = "0.00" : r3 = `${r3.slice(0, l4 - 2)}.${r3.slice(l4 - 2)}`, s > -1 && (r3 = `-${r3}`);
          }
          let n = r3 ? +r3 : NaN;
          if (isNaN(n)) return NaN;
          if (this.options.style === "percent") {
            var i, a3;
            let s = __spreadProps(__spreadValues({}, this.options), { style: "decimal", minimumFractionDigits: Math.min(((i = this.options.minimumFractionDigits) !== null && i !== void 0 ? i : 0) + 2, 20), maximumFractionDigits: Math.min(((a3 = this.options.maximumFractionDigits) !== null && a3 !== void 0 ? a3 : 0) + 2, 20) });
            return new C11(this.locale, s).parse(new B7(this.locale, s).format(n));
          }
          return this.options.currencySign === "accounting" && Be7.test(t) && (n = -1 * n), n;
        }
        sanitize(t) {
          return t = t.replace(this.symbols.literals, ""), this.symbols.minusSign && (t = t.replace("-", this.symbols.minusSign)), this.options.numberingSystem === "arab" && (this.symbols.decimal && (t = t.replace(",", this.symbols.decimal), t = t.replace("\u060C", this.symbols.decimal)), this.symbols.group && (t = x6(t, ".", this.symbols.group))), this.symbols.group === "\u2019" && t.includes("'") && (t = x6(t, "'", this.symbols.group)), this.options.locale === "fr-FR" && this.symbols.group && (t = x6(t, " ", this.symbols.group), t = x6(t, /\u00A0/g, this.symbols.group)), t;
        }
        isValidPartialNumber(t, r3 = -1 / 0, n = 1 / 0) {
          return t = this.sanitize(t), this.symbols.minusSign && t.startsWith(this.symbols.minusSign) && r3 < 0 ? t = t.slice(this.symbols.minusSign.length) : this.symbols.plusSign && t.startsWith(this.symbols.plusSign) && n > 0 && (t = t.slice(this.symbols.plusSign.length)), this.symbols.group && t.startsWith(this.symbols.group) || this.symbols.decimal && t.indexOf(this.symbols.decimal) > -1 && this.options.maximumFractionDigits === 0 ? false : (this.symbols.group && (t = x6(t, this.symbols.group, "")), t = t.replace(this.symbols.numeral, ""), this.symbols.decimal && (t = t.replace(this.symbols.decimal, "")), t.length === 0);
        }
        constructor(t, r3 = {}) {
          this.locale = t, r3.roundingIncrement !== 1 && r3.roundingIncrement != null && (r3.maximumFractionDigits == null && r3.minimumFractionDigits == null ? (r3.maximumFractionDigits = 0, r3.minimumFractionDigits = 0) : r3.maximumFractionDigits == null ? r3.maximumFractionDigits = r3.minimumFractionDigits : r3.minimumFractionDigits == null && (r3.minimumFractionDigits = r3.maximumFractionDigits)), this.formatter = new Intl.NumberFormat(t, r3), this.options = this.formatter.resolvedOptions(), this.symbols = We7(t, this.formatter, this.options, r3);
          var n, i;
          this.options.style === "percent" && (((n = this.options.minimumFractionDigits) !== null && n !== void 0 ? n : 0) > 18 || ((i = this.options.maximumFractionDigits) !== null && i !== void 0 ? i : 0) > 18) && console.warn("NumberParser cannot handle percentages with greater than 18 decimal places, please reduce the number in your options.");
        }
      };
      Re6 = /* @__PURE__ */ new Set(["decimal", "fraction", "integer", "minusSign", "plusSign", "group"]);
      Ge7 = [0, 4, 2, 1, 11, 20, 3, 7, 100, 21, 0.1, 1.1];
      qe8 = G("numberInput").parts("root", "label", "input", "control", "valueText", "incrementTrigger", "decrementTrigger", "scrubber");
      E10 = qe8.build();
      Ze6 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.root) != null ? _b : `number-input:${e4.id}`;
      };
      L10 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.input) != null ? _b : `number-input:${e4.id}:input`;
      };
      Oe8 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.incrementTrigger) != null ? _b : `number-input:${e4.id}:inc`;
      };
      we5 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.decrementTrigger) != null ? _b : `number-input:${e4.id}:dec`;
      };
      Ye8 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.scrubber) != null ? _b : `number-input:${e4.id}:scrubber`;
      };
      Ae5 = (e4) => `number-input:${e4.id}:cursor`;
      Xe6 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.label) != null ? _b : `number-input:${e4.id}:label`;
      };
      I10 = (e4) => e4.getById(L10(e4));
      ze7 = (e4) => e4.getById(Oe8(e4));
      Ke8 = (e4) => e4.getById(we5(e4));
      Me6 = (e4) => e4.getDoc().getElementById(Ae5(e4));
      Je6 = (e4, t) => {
        let r3 = null;
        return t === "increment" && (r3 = ze7(e4)), t === "decrement" && (r3 = Ke8(e4)), r3;
      };
      Qe6 = (e4, t) => {
        if (!Xr()) return rt6(e4, t), () => {
          var _a2;
          (_a2 = Me6(e4)) == null ? void 0 : _a2.remove();
        };
      };
      et7 = (e4) => {
        let t = e4.getDoc(), r3 = t.documentElement, n = t.body;
        return n.style.pointerEvents = "none", r3.style.userSelect = "none", r3.style.cursor = "ew-resize", () => {
          n.style.pointerEvents = "", r3.style.userSelect = "", r3.style.cursor = "", r3.style.length || r3.removeAttribute("style"), n.style.length || n.removeAttribute("style");
        };
      };
      tt8 = (e4, t) => {
        let { point: r3, isRtl: n, event: i } = t, a3 = e4.getWin(), s = es(i.movementX, a3.devicePixelRatio), l4 = es(i.movementY, a3.devicePixelRatio), u3 = s > 0 ? "increment" : s < 0 ? "decrement" : null;
        n && u3 === "increment" && (u3 = "decrement"), n && u3 === "decrement" && (u3 = "increment");
        let c5 = { x: r3.x + s, y: r3.y + l4 }, g7 = a3.innerWidth, p4 = es(7.5, a3.devicePixelRatio);
        return c5.x = Xo(c5.x + p4, g7) - p4, { hint: u3, point: c5 };
      };
      rt6 = (e4, t) => {
        let r3 = e4.getDoc(), n = r3.createElement("div");
        n.className = "scrubber--cursor", n.id = Ae5(e4), Object.assign(n.style, { width: "15px", height: "15px", position: "fixed", pointerEvents: "none", left: "0px", top: "0px", zIndex: Fr, transform: t ? `translate3d(${t.x}px, ${t.y}px, 0px)` : void 0, willChange: "transform" }), n.innerHTML = `
      <svg width="46" height="15" style="left: -15.5px; position: absolute; top: 0; filter: drop-shadow(rgba(0, 0, 0, 0.4) 0px 1px 1.1px);">
        <g transform="translate(2 3)">
          <path fill-rule="evenodd" d="M 15 4.5L 15 2L 11.5 5.5L 15 9L 15 6.5L 31 6.5L 31 9L 34.5 5.5L 31 2L 31 4.5Z" style="stroke-width: 2px; stroke: white;"></path>
          <path fill-rule="evenodd" d="M 15 4.5L 15 2L 11.5 5.5L 15 9L 15 6.5L 31 6.5L 31 9L 34.5 5.5L 31 2L 31 4.5Z"></path>
        </g>
      </svg>`, r3.body.appendChild(n);
      };
      nt6 = (e4, t = {}) => new Intl.NumberFormat(e4, t);
      it6 = (e4, t = {}) => new C11(e4, t);
      J10 = (e4, t) => {
        let { prop: r3, computed: n } = t;
        return r3("formatOptions") ? e4 === "" ? Number.NaN : n("parser").parse(e4) : parseFloat(e4);
      };
      T5 = (e4, t) => {
        let { prop: r3, computed: n } = t;
        return Number.isNaN(e4) ? "" : r3("formatOptions") ? n("formatter").format(e4) : e4.toString();
      };
      at5 = (e4, t) => {
        let r3 = e4 !== void 0 && !Number.isNaN(e4) ? e4 : 1;
        return (t == null ? void 0 : t.style) === "percent" && (e4 === void 0 || Number.isNaN(e4)) && (r3 = 0.01), r3;
      };
      ({ choose: st6, guards: ot5, createMachine: lt5 } = ws());
      ({ not: De5, and: Ve10 } = ot5);
      Le7 = lt5({ props({ props: e4 }) {
        let t = at5(e4.step, e4.formatOptions);
        return __spreadProps(__spreadValues({ dir: "ltr", locale: "en-US", focusInputOnChange: true, clampValueOnBlur: !e4.allowOverflow, allowOverflow: false, inputMode: "decimal", pattern: "-?[0-9]*(.[0-9]+)?", defaultValue: "", step: t, min: Number.MIN_SAFE_INTEGER, max: Number.MAX_SAFE_INTEGER, spinOnPress: true }, e4), { translations: __spreadValues({ incrementLabel: "increment value", decrementLabel: "decrease value" }, e4.translations) });
      }, initialState() {
        return "idle";
      }, context({ prop: e4, bindable: t, getComputed: r3 }) {
        return { value: t(() => ({ defaultValue: e4("defaultValue"), value: e4("value"), onChange(n) {
          var _a2;
          let i = r3(), a3 = J10(n, { computed: i, prop: e4 });
          (_a2 = e4("onValueChange")) == null ? void 0 : _a2({ value: n, valueAsNumber: a3 });
        } })), hint: t(() => ({ defaultValue: null })), scrubberCursorPoint: t(() => ({ defaultValue: null, hash(n) {
          return n ? `x:${n.x}, y:${n.y}` : "";
        } })), fieldsetDisabled: t(() => ({ defaultValue: false })) };
      }, computed: { isRtl: ({ prop: e4 }) => e4("dir") === "rtl", valueAsNumber: ({ context: e4, computed: t, prop: r3 }) => J10(e4.get("value"), { computed: t, prop: r3 }), formattedValue: ({ computed: e4, prop: t }) => T5(e4("valueAsNumber"), { computed: e4, prop: t }), isAtMin: ({ computed: e4, prop: t }) => Zo(e4("valueAsNumber"), t("min")), isAtMax: ({ computed: e4, prop: t }) => Jo(e4("valueAsNumber"), t("max")), isOutOfRange: ({ computed: e4, prop: t }) => !Qo(e4("valueAsNumber"), t("min"), t("max")), isValueEmpty: ({ context: e4 }) => e4.get("value") === "", isDisabled: ({ prop: e4, context: t }) => !!e4("disabled") || t.get("fieldsetDisabled"), canIncrement: ({ prop: e4, computed: t }) => e4("allowOverflow") || !t("isAtMax"), canDecrement: ({ prop: e4, computed: t }) => e4("allowOverflow") || !t("isAtMin"), valueText: ({ prop: e4, context: t }) => {
        var _a2, _b;
        return (_b = (_a2 = e4("translations")).valueText) == null ? void 0 : _b.call(_a2, t.get("value"));
      }, formatter: vs(({ prop: e4 }) => [e4("locale"), e4("formatOptions")], ([e4, t]) => nt6(e4, t)), parser: vs(({ prop: e4 }) => [e4("locale"), e4("formatOptions")], ([e4, t]) => it6(e4, t)) }, watch({ track: e4, action: t, context: r3, computed: n, prop: i }) {
        e4([() => r3.get("value"), () => i("locale"), () => JSON.stringify(i("formatOptions"))], () => {
          t(["syncInputElement"]);
        }), e4([() => n("isOutOfRange")], () => {
          t(["invokeOnInvalid"]);
        }), e4([() => r3.hash("scrubberCursorPoint")], () => {
          t(["setVirtualCursorPosition"]);
        });
      }, effects: ["trackFormControl"], on: { "VALUE.SET": { actions: ["setRawValue"] }, "VALUE.CLEAR": { actions: ["clearValue"] }, "VALUE.INCREMENT": { actions: ["increment"] }, "VALUE.DECREMENT": { actions: ["decrement"] } }, states: { idle: { on: { "TRIGGER.PRESS_DOWN": [{ guard: "isTouchPointer", target: "before:spin", actions: ["setHint"] }, { target: "before:spin", actions: ["focusInput", "invokeOnFocus", "setHint"] }], "SCRUBBER.PRESS_DOWN": { target: "scrubbing", actions: ["focusInput", "invokeOnFocus", "setHint", "setCursorPoint"] }, "INPUT.FOCUS": { target: "focused", actions: ["focusInput", "invokeOnFocus"] } } }, focused: { tags: ["focus"], effects: ["attachWheelListener"], on: { "TRIGGER.PRESS_DOWN": [{ guard: "isTouchPointer", target: "before:spin", actions: ["setHint"] }, { target: "before:spin", actions: ["focusInput", "setHint"] }], "SCRUBBER.PRESS_DOWN": { target: "scrubbing", actions: ["focusInput", "setHint", "setCursorPoint"] }, "INPUT.ARROW_UP": { actions: ["increment"] }, "INPUT.ARROW_DOWN": { actions: ["decrement"] }, "INPUT.HOME": { actions: ["decrementToMin"] }, "INPUT.END": { actions: ["incrementToMax"] }, "INPUT.CHANGE": { actions: ["setValue", "setHint"] }, "INPUT.BLUR": [{ guard: Ve10("clampValueOnBlur", De5("isInRange")), target: "idle", actions: ["setClampedValue", "clearHint", "invokeOnBlur", "invokeOnValueCommit"] }, { guard: De5("isInRange"), target: "idle", actions: ["setFormattedValue", "clearHint", "invokeOnBlur", "invokeOnInvalid", "invokeOnValueCommit"] }, { target: "idle", actions: ["setFormattedValue", "clearHint", "invokeOnBlur", "invokeOnValueCommit"] }], "INPUT.ENTER": { actions: ["setFormattedValue", "clearHint", "invokeOnBlur", "invokeOnValueCommit"] } } }, "before:spin": { tags: ["focus"], effects: ["trackButtonDisabled", "waitForChangeDelay"], entry: st6([{ guard: "isIncrementHint", actions: ["increment"] }, { guard: "isDecrementHint", actions: ["decrement"] }]), on: { CHANGE_DELAY: { target: "spinning", guard: Ve10("isInRange", "spinOnPress") }, "TRIGGER.PRESS_UP": [{ guard: "isTouchPointer", target: "focused", actions: ["clearHint"] }, { target: "focused", actions: ["focusInput", "clearHint"] }] } }, spinning: { tags: ["focus"], effects: ["trackButtonDisabled", "spinValue"], on: { SPIN: [{ guard: "isIncrementHint", actions: ["increment"] }, { guard: "isDecrementHint", actions: ["decrement"] }], "TRIGGER.PRESS_UP": { target: "focused", actions: ["focusInput", "clearHint"] } } }, scrubbing: { tags: ["focus"], effects: ["activatePointerLock", "trackMousemove", "setupVirtualCursor", "preventTextSelection"], on: { "SCRUBBER.POINTER_UP": { target: "focused", actions: ["focusInput", "clearCursorPoint"] }, "SCRUBBER.POINTER_MOVE": [{ guard: "isIncrementHint", actions: ["increment", "setCursorPoint"] }, { guard: "isDecrementHint", actions: ["decrement", "setCursorPoint"] }] } } }, implementations: { guards: { clampValueOnBlur: ({ prop: e4 }) => e4("clampValueOnBlur"), spinOnPress: ({ prop: e4 }) => !!e4("spinOnPress"), isInRange: ({ computed: e4 }) => !e4("isOutOfRange"), isDecrementHint: ({ context: e4, event: t }) => {
        var _a2;
        return ((_a2 = t.hint) != null ? _a2 : e4.get("hint")) === "decrement";
      }, isIncrementHint: ({ context: e4, event: t }) => {
        var _a2;
        return ((_a2 = t.hint) != null ? _a2 : e4.get("hint")) === "increment";
      }, isTouchPointer: ({ event: e4 }) => e4.pointerType === "touch" }, effects: { waitForChangeDelay({ send: e4 }) {
        let t = setTimeout(() => {
          e4({ type: "CHANGE_DELAY" });
        }, 300);
        return () => clearTimeout(t);
      }, spinValue({ send: e4 }) {
        let t = setInterval(() => {
          e4({ type: "SPIN" });
        }, 50);
        return () => clearInterval(t);
      }, trackFormControl({ context: e4, scope: t }) {
        let r3 = I10(t);
        return lo(r3, { onFieldsetDisabledChange(n) {
          e4.set("fieldsetDisabled", n);
        }, onFormReset() {
          e4.set("value", e4.initial("value"));
        } });
      }, setupVirtualCursor({ context: e4, scope: t }) {
        let r3 = e4.get("scrubberCursorPoint");
        return Qe6(t, r3);
      }, preventTextSelection({ scope: e4 }) {
        return et7(e4);
      }, trackButtonDisabled({ context: e4, scope: t, send: r3 }) {
        let n = e4.get("hint"), i = Je6(t, n);
        return go(i, { attributes: ["disabled"], callback() {
          r3({ type: "TRIGGER.PRESS_UP", src: "attr" });
        } });
      }, attachWheelListener({ scope: e4, send: t, prop: r3 }) {
        let n = I10(e4);
        if (!n || !e4.isActiveElement(n) || !r3("allowMouseWheel")) return;
        function i(a3) {
          a3.preventDefault();
          let s = Math.sign(a3.deltaY) * -1;
          s === 1 ? t({ type: "VALUE.INCREMENT" }) : s === -1 && t({ type: "VALUE.DECREMENT" });
        }
        return P(n, "wheel", i, { passive: false });
      }, activatePointerLock({ scope: e4 }) {
        if (!Xr()) return wo(e4.getDoc());
      }, trackMousemove({ scope: e4, send: t, context: r3, computed: n }) {
        let i = e4.getDoc();
        function a3(l4) {
          let u3 = r3.get("scrubberCursorPoint"), c5 = n("isRtl"), g7 = tt8(e4, { point: u3, isRtl: c5, event: l4 });
          g7.hint && t({ type: "SCRUBBER.POINTER_MOVE", hint: g7.hint, point: g7.point });
        }
        function s() {
          t({ type: "SCRUBBER.POINTER_UP" });
        }
        return re(P(i, "mousemove", a3, false), P(i, "mouseup", s, false));
      } }, actions: { focusInput({ scope: e4, prop: t }) {
        if (!t("focusInputOnChange")) return;
        let r3 = I10(e4);
        e4.isActiveElement(r3) || nt(() => r3 == null ? void 0 : r3.focus({ preventScroll: true }));
      }, increment({ context: e4, event: t, prop: r3, computed: n }) {
        var _a2;
        let i = os(n("valueAsNumber"), (_a2 = t.step) != null ? _a2 : r3("step"));
        r3("allowOverflow") || (i = ts(i, r3("min"), r3("max"))), e4.set("value", T5(i, { computed: n, prop: r3 }));
      }, decrement({ context: e4, event: t, prop: r3, computed: n }) {
        var _a2;
        let i = ss(n("valueAsNumber"), (_a2 = t.step) != null ? _a2 : r3("step"));
        r3("allowOverflow") || (i = ts(i, r3("min"), r3("max"))), e4.set("value", T5(i, { computed: n, prop: r3 }));
      }, setClampedValue({ context: e4, prop: t, computed: r3 }) {
        let n = ts(r3("valueAsNumber"), t("min"), t("max"));
        e4.set("value", T5(n, { computed: r3, prop: t }));
      }, setRawValue({ context: e4, event: t, prop: r3, computed: n }) {
        let i = J10(t.value, { computed: n, prop: r3 });
        r3("allowOverflow") || (i = ts(i, r3("min"), r3("max"))), e4.set("value", T5(i, { computed: n, prop: r3 }));
      }, setValue({ context: e4, event: t }) {
        var _a2, _b;
        let r3 = (_b = (_a2 = t.target) == null ? void 0 : _a2.value) != null ? _b : t.value;
        e4.set("value", r3);
      }, clearValue({ context: e4 }) {
        e4.set("value", "");
      }, incrementToMax({ context: e4, prop: t, computed: r3 }) {
        let n = T5(t("max"), { computed: r3, prop: t });
        e4.set("value", n);
      }, decrementToMin({ context: e4, prop: t, computed: r3 }) {
        let n = T5(t("min"), { computed: r3, prop: t });
        e4.set("value", n);
      }, setHint({ context: e4, event: t }) {
        e4.set("hint", t.hint);
      }, clearHint({ context: e4 }) {
        e4.set("hint", null);
      }, invokeOnFocus({ computed: e4, prop: t }) {
        var _a2;
        (_a2 = t("onFocusChange")) == null ? void 0 : _a2({ focused: true, value: e4("formattedValue"), valueAsNumber: e4("valueAsNumber") });
      }, invokeOnBlur({ computed: e4, prop: t }) {
        var _a2;
        (_a2 = t("onFocusChange")) == null ? void 0 : _a2({ focused: false, value: e4("formattedValue"), valueAsNumber: e4("valueAsNumber") });
      }, invokeOnInvalid({ computed: e4, prop: t, event: r3 }) {
        var _a2;
        if (r3.type === "INPUT.CHANGE") return;
        let n = e4("valueAsNumber") > t("max") ? "rangeOverflow" : "rangeUnderflow";
        (_a2 = t("onValueInvalid")) == null ? void 0 : _a2({ reason: n, value: e4("formattedValue"), valueAsNumber: e4("valueAsNumber") });
      }, invokeOnValueCommit({ computed: e4, prop: t }) {
        var _a2;
        (_a2 = t("onValueCommit")) == null ? void 0 : _a2({ value: e4("formattedValue"), valueAsNumber: e4("valueAsNumber") });
      }, syncInputElement({ context: e4, event: t, computed: r3, scope: n }) {
        var _a2;
        let i = t.type.endsWith("CHANGE") ? e4.get("value") : r3("formattedValue"), a3 = I10(n), s = (_a2 = t.selection) != null ? _a2 : Q11(a3, n);
        nt(() => {
          sn(a3, i), je7(a3, s, n);
        });
      }, setFormattedValue({ context: e4, computed: t, action: r3 }) {
        e4.set("value", t("formattedValue")), r3(["syncInputElement"]);
      }, setCursorPoint({ context: e4, event: t }) {
        e4.set("scrubberCursorPoint", t.point);
      }, clearCursorPoint({ context: e4 }) {
        e4.set("scrubberCursorPoint", null);
      }, setVirtualCursorPosition({ context: e4, scope: t }) {
        let r3 = Me6(t), n = e4.get("scrubberCursorPoint");
        !r3 || !n || (r3.style.transform = `translate3d(${n.x}px, ${n.y}px, 0px)`);
      } } } });
      ut7 = As()(["allowMouseWheel", "allowOverflow", "clampValueOnBlur", "dir", "disabled", "focusInputOnChange", "form", "formatOptions", "getRootNode", "id", "ids", "inputMode", "invalid", "locale", "max", "min", "name", "onFocusChange", "onValueChange", "onValueCommit", "onValueInvalid", "pattern", "required", "readOnly", "spinOnPress", "step", "translations", "value", "defaultValue"]);
      Nt4 = as(ut7);
      _9 = class extends ve {
        initMachine(t) {
          return new Ls(Le7, t);
        }
        initApi() {
          return $e7(this.machine.service, Cs);
        }
        render() {
          var _a2;
          let t = (_a2 = this.el.querySelector('[data-scope="number-input"][data-part="root"]')) != null ? _a2 : this.el;
          this.spreadProps(t, this.api.getRootProps());
          let r3 = this.el.querySelector('[data-scope="number-input"][data-part="label"]');
          r3 && this.spreadProps(r3, this.api.getLabelProps());
          let n = this.el.querySelector('[data-scope="number-input"][data-part="control"]');
          n && this.spreadProps(n, this.api.getControlProps());
          let i = this.el.querySelector('[data-scope="number-input"][data-part="value-text"]');
          i && this.spreadProps(i, this.api.getValueTextProps());
          let a3 = this.el.querySelector('[data-scope="number-input"][data-part="input"]');
          a3 && this.spreadProps(a3, this.api.getInputProps());
          let s = this.el.querySelector('[data-scope="number-input"][data-part="decrement-trigger"]');
          s && this.spreadProps(s, this.api.getDecrementTriggerProps());
          let l4 = this.el.querySelector('[data-scope="number-input"][data-part="increment-trigger"]');
          l4 && this.spreadProps(l4, this.api.getIncrementTriggerProps());
          let u3 = this.el.querySelector('[data-scope="number-input"][data-part="scrubber"]');
          u3 && this.spreadProps(u3, this.api.getScrubberProps());
        }
      };
      Vt4 = { mounted() {
        let e4 = this.el, t = xr(e4, "value"), r3 = xr(e4, "defaultValue"), n = _r(e4, "controlled"), i = new _9(e4, __spreadProps(__spreadValues({ id: e4.id }, n && t !== void 0 ? { value: t } : { defaultValue: r3 }), { min: Lr(e4, "min"), max: Lr(e4, "max"), step: Lr(e4, "step"), disabled: _r(e4, "disabled"), readOnly: _r(e4, "readOnly"), invalid: _r(e4, "invalid"), required: _r(e4, "required"), allowMouseWheel: _r(e4, "allowMouseWheel"), name: xr(e4, "name"), form: xr(e4, "form"), onValueChange: (a3) => {
          let s = e4.querySelector('[data-scope="number-input"][data-part="input"]');
          s && (s.value = a3.value, s.dispatchEvent(new Event("input", { bubbles: true })), s.dispatchEvent(new Event("change", { bubbles: true })));
          let l4 = xr(e4, "onValueChange");
          l4 && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected() && this.pushEvent(l4, { value: a3.value, valueAsNumber: a3.valueAsNumber, id: e4.id });
          let u3 = xr(e4, "onValueChangeClient");
          u3 && e4.dispatchEvent(new CustomEvent(u3, { bubbles: true, detail: { value: a3, id: e4.id } }));
        } }));
        i.init(), this.numberInput = i, this.handlers = [];
      }, updated() {
        var _a2;
        let e4 = xr(this.el, "value"), t = _r(this.el, "controlled");
        (_a2 = this.numberInput) == null ? void 0 : _a2.updateProps(__spreadProps(__spreadValues({ id: this.el.id }, t && e4 !== void 0 ? { value: e4 } : {}), { min: Lr(this.el, "min"), max: Lr(this.el, "max"), step: Lr(this.el, "step"), disabled: _r(this.el, "disabled"), readOnly: _r(this.el, "readOnly"), invalid: _r(this.el, "invalid"), required: _r(this.el, "required"), name: xr(this.el, "name"), form: xr(this.el, "form") }));
      }, destroyed() {
        var _a2;
        if (this.handlers) for (let e4 of this.handlers) this.removeHandleEvent(e4);
        (_a2 = this.numberInput) == null ? void 0 : _a2.destroy();
      } };
    }
  });

  // ../priv/static/password-input.mjs
  var password_input_exports = {};
  __export(password_input_exports, {
    PasswordInput: () => $9
  });
  function S12(t, e4) {
    let { scope: n, prop: i, context: l4 } = t, s = l4.get("visible"), r3 = !!i("disabled"), p4 = !!i("invalid"), d4 = !!i("readOnly"), L13 = !!i("required"), k14 = !(d4 || r3), M10 = i("translations");
    return { visible: s, disabled: r3, invalid: p4, focus() {
      var _a2;
      (_a2 = v7(n)) == null ? void 0 : _a2.focus();
    }, setVisible(b10) {
      t.send({ type: "VISIBILITY.SET", value: b10 });
    }, toggleVisible() {
      t.send({ type: "VISIBILITY.SET", value: !s });
    }, getRootProps() {
      return e4.element(__spreadProps(__spreadValues({}, c3.root.attrs), { dir: i("dir"), "data-disabled": jr(r3), "data-invalid": jr(p4), "data-readonly": jr(d4) }));
    }, getLabelProps() {
      return e4.label(__spreadProps(__spreadValues({}, c3.label.attrs), { htmlFor: h3(n), "data-disabled": jr(r3), "data-invalid": jr(p4), "data-readonly": jr(d4), "data-required": jr(L13) }));
    }, getInputProps() {
      return e4.input(__spreadValues(__spreadProps(__spreadValues({}, c3.input.attrs), { id: h3(n), autoCapitalize: "off", name: i("name"), required: i("required"), autoComplete: i("autoComplete"), spellCheck: false, readOnly: d4, disabled: r3, type: s ? "text" : "password", "data-state": s ? "visible" : "hidden", "aria-invalid": Br(p4), "data-disabled": jr(r3), "data-invalid": jr(p4), "data-readonly": jr(d4) }), i("ignorePasswordManagers") ? x7 : {}));
    }, getVisibilityTriggerProps() {
      var _a2;
      return e4.button(__spreadProps(__spreadValues({}, c3.visibilityTrigger.attrs), { type: "button", tabIndex: -1, "aria-controls": h3(n), "aria-expanded": s, "data-readonly": jr(d4), disabled: r3, "data-disabled": jr(r3), "data-state": s ? "visible" : "hidden", "aria-label": (_a2 = M10 == null ? void 0 : M10.visibilityTrigger) == null ? void 0 : _a2.call(M10, s), onPointerDown(b10) {
        ro(b10) && k14 && (b10.preventDefault(), t.send({ type: "TRIGGER.CLICK" }));
      } }));
    }, getIndicatorProps() {
      return e4.element(__spreadProps(__spreadValues({}, c3.indicator.attrs), { "aria-hidden": true, "data-state": s ? "visible" : "hidden", "data-disabled": jr(r3), "data-invalid": jr(p4), "data-readonly": jr(d4) }));
    }, getControlProps() {
      return e4.element(__spreadProps(__spreadValues({}, c3.control.attrs), { "data-disabled": jr(r3), "data-invalid": jr(p4), "data-readonly": jr(d4) }));
    } };
  }
  var q11, c3, h3, v7, x7, H10, A9, D8, g5, $9;
  var init_password_input = __esm({
    "../priv/static/password-input.mjs"() {
      "use strict";
      init_chunk_IYURAQ6S();
      q11 = G("password-input").parts("root", "input", "label", "control", "indicator", "visibilityTrigger");
      c3 = q11.build();
      h3 = (t) => {
        var _a2, _b;
        return (_b = (_a2 = t.ids) == null ? void 0 : _a2.input) != null ? _b : `p-input-${t.id}-input`;
      };
      v7 = (t) => t.getById(h3(t));
      x7 = { "data-1p-ignore": "", "data-lpignore": "true", "data-bwignore": "true", "data-form-type": "other", "data-protonpass-ignore": "true" };
      H10 = { props({ props: t }) {
        return __spreadProps(__spreadValues({ id: Yo(), defaultVisible: false, autoComplete: "current-password", ignorePasswordManagers: false }, t), { translations: __spreadValues({ visibilityTrigger(e4) {
          return e4 ? "Hide password" : "Show password";
        } }, t.translations) });
      }, context({ prop: t, bindable: e4 }) {
        return { visible: e4(() => ({ value: t("visible"), defaultValue: t("defaultVisible"), onChange(n) {
          var _a2;
          (_a2 = t("onVisibilityChange")) == null ? void 0 : _a2({ visible: n });
        } })) };
      }, initialState() {
        return "idle";
      }, effects: ["trackFormEvents"], states: { idle: { on: { "VISIBILITY.SET": { actions: ["setVisibility"] }, "TRIGGER.CLICK": { actions: ["toggleVisibility", "focusInputEl"] } } } }, implementations: { actions: { setVisibility({ context: t, event: e4 }) {
        t.set("visible", e4.value);
      }, toggleVisibility({ context: t }) {
        t.set("visible", (e4) => !e4);
      }, focusInputEl({ scope: t }) {
        var _a2;
        (_a2 = v7(t)) == null ? void 0 : _a2.focus();
      } }, effects: { trackFormEvents({ scope: t, send: e4 }) {
        var _a2;
        let i = (_a2 = v7(t)) == null ? void 0 : _a2.form;
        if (!i) return;
        let l4 = t.getWin(), s = new l4.AbortController();
        return i.addEventListener("reset", (r3) => {
          r3.defaultPrevented || e4({ type: "VISIBILITY.SET", value: false });
        }, { signal: s.signal }), i.addEventListener("submit", () => {
          e4({ type: "VISIBILITY.SET", value: false });
        }, { signal: s.signal }), () => s.abort();
      } } } };
      A9 = As()(["defaultVisible", "dir", "id", "onVisibilityChange", "visible", "ids", "getRootNode", "disabled", "invalid", "required", "readOnly", "translations", "ignorePasswordManagers", "autoComplete", "name"]);
      D8 = as(A9);
      g5 = class extends ve {
        initMachine(e4) {
          return new Ls(H10, e4);
        }
        initApi() {
          return S12(this.machine.service, Cs);
        }
        render() {
          var _a2;
          let e4 = (_a2 = this.el.querySelector('[data-scope="password-input"][data-part="root"]')) != null ? _a2 : this.el;
          this.spreadProps(e4, this.api.getRootProps());
          let n = this.el.querySelector('[data-scope="password-input"][data-part="label"]');
          n && this.spreadProps(n, this.api.getLabelProps());
          let i = this.el.querySelector('[data-scope="password-input"][data-part="control"]');
          i && this.spreadProps(i, this.api.getControlProps());
          let l4 = this.el.querySelector('[data-scope="password-input"][data-part="input"]');
          l4 && this.spreadProps(l4, this.api.getInputProps());
          let s = this.el.querySelector('[data-scope="password-input"][data-part="visibility-trigger"]');
          s && this.spreadProps(s, this.api.getVisibilityTriggerProps());
          let r3 = this.el.querySelector('[data-scope="password-input"][data-part="indicator"]');
          r3 && this.spreadProps(r3, this.api.getIndicatorProps());
        }
      };
      $9 = { mounted() {
        let t = this.el, e4 = new g5(t, __spreadProps(__spreadValues({ id: t.id }, _r(t, "controlledVisible") ? { visible: _r(t, "visible") } : { defaultVisible: _r(t, "defaultVisible") }), { disabled: _r(t, "disabled"), invalid: _r(t, "invalid"), readOnly: _r(t, "readOnly"), required: _r(t, "required"), ignorePasswordManagers: _r(t, "ignorePasswordManagers"), name: xr(t, "name"), dir: kr(t), autoComplete: xr(t, "autoComplete", ["current-password", "new-password"]), onVisibilityChange: (n) => {
          let i = xr(t, "onVisibilityChange");
          i && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected() && this.pushEvent(i, { visible: n.visible, id: t.id });
          let l4 = xr(t, "onVisibilityChangeClient");
          l4 && t.dispatchEvent(new CustomEvent(l4, { bubbles: true, detail: { value: n, id: t.id } }));
        } }));
        e4.init(), this.passwordInput = e4, this.handlers = [];
      }, updated() {
        var _a2;
        (_a2 = this.passwordInput) == null ? void 0 : _a2.updateProps(__spreadProps(__spreadValues({ id: this.el.id }, _r(this.el, "controlledVisible") ? { visible: _r(this.el, "visible") } : {}), { disabled: _r(this.el, "disabled"), invalid: _r(this.el, "invalid"), readOnly: _r(this.el, "readOnly"), required: _r(this.el, "required"), name: xr(this.el, "name"), form: xr(this.el, "form"), dir: kr(this.el) }));
      }, destroyed() {
        var _a2;
        if (this.handlers) for (let t of this.handlers) this.removeHandleEvent(t);
        (_a2 = this.passwordInput) == null ? void 0 : _a2.destroy();
      } };
    }
  });

  // ../priv/static/pin-input.mjs
  var pin_input_exports = {};
  __export(pin_input_exports, {
    PinInput: () => Fe7
  });
  function fe6(e4, t) {
    var _a2;
    return e4 ? !!((_a2 = ce6[e4]) == null ? void 0 : _a2.test(t)) : true;
  }
  function Y12(e4, t, n) {
    return n ? new RegExp(n, "g").test(e4) : fe6(t, e4);
  }
  function te5(e4, t) {
    let { send: n, context: i, computed: l4, prop: a3, scope: u3 } = e4, v10 = l4("isValueComplete"), c5 = !!a3("disabled"), g7 = !!a3("readOnly"), m5 = !!a3("invalid"), P11 = !!a3("required"), ae11 = a3("translations"), ie12 = i.get("focusedIndex");
    function U11() {
      var _a2;
      (_a2 = pe7(u3)) == null ? void 0 : _a2.focus();
    }
    return { focus: U11, count: i.get("count"), items: Array.from({ length: i.get("count") }).map((h6, p4) => p4), value: i.get("value"), valueAsString: l4("valueAsString"), complete: v10, setValue(h6) {
      Array.isArray(h6) || fs("[pin-input/setValue] value must be an array"), n({ type: "VALUE.SET", value: h6 });
    }, clearValue() {
      n({ type: "VALUE.CLEAR" });
    }, setValueAtIndex(h6, p4) {
      n({ type: "VALUE.SET", value: p4, index: h6 });
    }, getRootProps() {
      return t.element(__spreadProps(__spreadValues({ dir: a3("dir") }, C12.root.attrs), { id: E11(u3), "data-invalid": jr(m5), "data-disabled": jr(c5), "data-complete": jr(v10), "data-readonly": jr(g7) }));
    }, getLabelProps() {
      return t.label(__spreadProps(__spreadValues({}, C12.label.attrs), { dir: a3("dir"), htmlFor: N6(u3), id: se7(u3), "data-invalid": jr(m5), "data-disabled": jr(c5), "data-complete": jr(v10), "data-required": jr(P11), "data-readonly": jr(g7), onClick(h6) {
        h6.preventDefault(), U11();
      } }));
    }, getHiddenInputProps() {
      return t.input({ "aria-hidden": true, type: "text", tabIndex: -1, id: N6(u3), readOnly: g7, disabled: c5, required: P11, name: a3("name"), form: a3("form"), style: Co, maxLength: l4("valueLength"), defaultValue: l4("valueAsString") });
    }, getControlProps() {
      return t.element(__spreadProps(__spreadValues({}, C12.control.attrs), { dir: a3("dir"), id: re6(u3) }));
    }, getInputProps(h6) {
      var _a2;
      let { index: p4 } = h6, ue9 = a3("type") === "numeric" ? "tel" : "text";
      return t.input(__spreadProps(__spreadValues({}, C12.input.attrs), { dir: a3("dir"), disabled: c5, "data-disabled": jr(c5), "data-complete": jr(v10), id: le7(u3, p4.toString()), "data-index": p4, "data-ownedby": E11(u3), "aria-label": (_a2 = ae11 == null ? void 0 : ae11.inputLabel) == null ? void 0 : _a2.call(ae11, p4, l4("valueLength")), inputMode: a3("otp") || a3("type") === "numeric" ? "numeric" : "text", "aria-invalid": Br(m5), "data-invalid": jr(m5), type: a3("mask") ? "password" : ue9, defaultValue: i.get("value")[p4] || "", readOnly: g7, autoCapitalize: "none", autoComplete: a3("otp") ? "one-time-code" : "off", placeholder: ie12 === p4 ? "" : a3("placeholder"), onPaste(o2) {
        var _a3;
        let s = (_a3 = o2.clipboardData) == null ? void 0 : _a3.getData("text/plain");
        if (!s) return;
        if (!Y12(s, a3("type"), a3("pattern"))) {
          n({ type: "VALUE.INVALID", value: s }), o2.preventDefault();
          return;
        }
        o2.preventDefault(), n({ type: "INPUT.PASTE", value: s });
      }, onBeforeInput(o2) {
        try {
          let s = Jr(o2);
          Y12(s, a3("type"), a3("pattern")) || (n({ type: "VALUE.INVALID", value: s }), o2.preventDefault()), s.length > 1 && o2.currentTarget.setSelectionRange(0, 1, "forward");
        } catch (e5) {
        }
      }, onChange(o2) {
        let s = en(o2), { value: I11 } = o2.currentTarget;
        if (s.inputType === "insertFromPaste") {
          o2.currentTarget.value = I11[0] || "";
          return;
        }
        if (I11.length > 2) {
          n({ type: "INPUT.PASTE", value: I11 }), o2.currentTarget.value = I11[0], o2.preventDefault();
          return;
        }
        if (s.inputType === "deleteContentBackward") {
          n({ type: "INPUT.BACKSPACE" });
          return;
        }
        n({ type: "INPUT.CHANGE", value: I11, index: p4 });
      }, onKeyDown(o2) {
        if (o2.defaultPrevented || to(o2) || so(o2)) return;
        let I11 = { Backspace() {
          n({ type: "INPUT.BACKSPACE" });
        }, Delete() {
          n({ type: "INPUT.DELETE" });
        }, ArrowLeft() {
          n({ type: "INPUT.ARROW_LEFT" });
        }, ArrowRight() {
          n({ type: "INPUT.ARROW_RIGHT" });
        }, Enter() {
          n({ type: "INPUT.ENTER" });
        } }[io(o2, { dir: a3("dir"), orientation: "horizontal" })];
        I11 && (I11(o2), o2.preventDefault());
      }, onFocus() {
        n({ type: "INPUT.FOCUS", index: p4 });
      }, onBlur(o2) {
        let s = o2.relatedTarget;
        S(s) && s.dataset.ownedby === E11(u3) || n({ type: "INPUT.BLUR", index: p4 });
      } }));
    } };
  }
  function ee7(e4, t) {
    let n = t;
    e4[0] === t[0] ? n = t[1] : e4[0] === t[1] && (n = t[0]);
    let i = n.split("");
    return n = i[i.length - 1], n != null ? n : "";
  }
  function b4(e4, t) {
    return Array.from({ length: t }).fill("").map((n, i) => e4[i] || n);
  }
  var oe6, C12, E11, le7, N6, se7, re6, de8, T6, y7, pe7, Q12, F8, ce6, Ie7, ve4, ne6, he7, Pe8, L11, Fe7;
  var init_pin_input = __esm({
    "../priv/static/pin-input.mjs"() {
      "use strict";
      init_chunk_IYURAQ6S();
      oe6 = G("pinInput").parts("root", "label", "input", "control");
      C12 = oe6.build();
      E11 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.root) != null ? _b : `pin-input:${e4.id}`;
      };
      le7 = (e4, t) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = e4.ids) == null ? void 0 : _a2.input) == null ? void 0 : _b.call(_a2, t)) != null ? _c : `pin-input:${e4.id}:${t}`;
      };
      N6 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.hiddenInput) != null ? _b : `pin-input:${e4.id}:hidden`;
      };
      se7 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.label) != null ? _b : `pin-input:${e4.id}:label`;
      };
      re6 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.control) != null ? _b : `pin-input:${e4.id}:control`;
      };
      de8 = (e4) => e4.getById(E11(e4));
      T6 = (e4) => {
        let n = `input[data-ownedby=${CSS.escape(E11(e4))}]`;
        return Po(de8(e4), n);
      };
      y7 = (e4, t) => T6(e4)[t];
      pe7 = (e4) => T6(e4)[0];
      Q12 = (e4) => e4.getById(N6(e4));
      F8 = (e4, t) => {
        e4.value = t, e4.setAttribute("value", t);
      };
      ce6 = { numeric: /^[0-9]+$/, alphabetic: /^[A-Za-z]+$/, alphanumeric: /^[a-zA-Z0-9]+$/i };
      ({ choose: Ie7, createMachine: ve4 } = ws());
      ne6 = ve4({ props({ props: e4 }) {
        return __spreadProps(__spreadValues({ placeholder: "\u25CB", otp: false, type: "numeric", defaultValue: e4.count ? b4([], e4.count) : [] }, e4), { translations: __spreadValues({ inputLabel: (t, n) => `pin code ${t + 1} of ${n}` }, e4.translations) });
      }, initialState() {
        return "idle";
      }, context({ prop: e4, bindable: t }) {
        return { value: t(() => ({ value: e4("value"), defaultValue: e4("defaultValue"), isEqual: V, onChange(n) {
          var _a2;
          (_a2 = e4("onValueChange")) == null ? void 0 : _a2({ value: n, valueAsString: n.join("") });
        } })), focusedIndex: t(() => ({ sync: true, defaultValue: -1 })), count: t(() => ({ defaultValue: e4("count") })) };
      }, computed: { _value: ({ context: e4 }) => b4(e4.get("value"), e4.get("count")), valueLength: ({ computed: e4 }) => e4("_value").length, filledValueLength: ({ computed: e4 }) => e4("_value").filter((t) => (t == null ? void 0 : t.trim()) !== "").length, isValueComplete: ({ computed: e4 }) => e4("valueLength") === e4("filledValueLength"), valueAsString: ({ computed: e4 }) => e4("_value").join(""), focusedValue: ({ computed: e4, context: t }) => e4("_value")[t.get("focusedIndex")] || "" }, entry: Ie7([{ guard: "autoFocus", actions: ["setInputCount", "setFocusIndexToFirst"] }, { actions: ["setInputCount"] }]), watch({ action: e4, track: t, context: n, computed: i }) {
        t([() => n.get("focusedIndex")], () => {
          e4(["focusInput", "selectInputIfNeeded"]);
        }), t([() => n.get("value").join(",")], () => {
          e4(["syncInputElements", "dispatchInputEvent"]);
        }), t([() => i("isValueComplete")], () => {
          e4(["invokeOnComplete", "blurFocusedInputIfNeeded"]);
        });
      }, on: { "VALUE.SET": [{ guard: "hasIndex", actions: ["setValueAtIndex"] }, { actions: ["setValue"] }], "VALUE.CLEAR": { actions: ["clearValue", "setFocusIndexToFirst"] } }, states: { idle: { on: { "INPUT.FOCUS": { target: "focused", actions: ["setFocusedIndex"] } } }, focused: { on: { "INPUT.CHANGE": { actions: ["setFocusedValue", "syncInputValue", "setNextFocusedIndex"] }, "INPUT.PASTE": { actions: ["setPastedValue", "setLastValueFocusIndex"] }, "INPUT.FOCUS": { actions: ["setFocusedIndex"] }, "INPUT.BLUR": { target: "idle", actions: ["clearFocusedIndex"] }, "INPUT.DELETE": { guard: "hasValue", actions: ["clearFocusedValue"] }, "INPUT.ARROW_LEFT": { actions: ["setPrevFocusedIndex"] }, "INPUT.ARROW_RIGHT": { actions: ["setNextFocusedIndex"] }, "INPUT.BACKSPACE": [{ guard: "hasValue", actions: ["clearFocusedValue"] }, { actions: ["setPrevFocusedIndex", "clearFocusedValue"] }], "INPUT.ENTER": { guard: "isValueComplete", actions: ["requestFormSubmit"] }, "VALUE.INVALID": { actions: ["invokeOnInvalid"] } } } }, implementations: { guards: { autoFocus: ({ prop: e4 }) => !!e4("autoFocus"), hasValue: ({ context: e4 }) => e4.get("value")[e4.get("focusedIndex")] !== "", isValueComplete: ({ computed: e4 }) => e4("isValueComplete"), hasIndex: ({ event: e4 }) => e4.index !== void 0 }, actions: { dispatchInputEvent({ computed: e4, scope: t }) {
        let n = Q12(t);
        ao(n, { value: e4("valueAsString") });
      }, setInputCount({ scope: e4, context: t, prop: n }) {
        if (n("count")) return;
        let i = T6(e4);
        t.set("count", i.length);
      }, focusInput({ context: e4, scope: t }) {
        var _a2;
        let n = e4.get("focusedIndex");
        n !== -1 && ((_a2 = y7(t, n)) == null ? void 0 : _a2.focus({ preventScroll: true }));
      }, selectInputIfNeeded({ context: e4, prop: t, scope: n }) {
        let i = e4.get("focusedIndex");
        !t("selectOnFocus") || i === -1 || nt(() => {
          var _a2;
          (_a2 = y7(n, i)) == null ? void 0 : _a2.select();
        });
      }, invokeOnComplete({ computed: e4, prop: t }) {
        var _a2;
        e4("isValueComplete") && ((_a2 = t("onValueComplete")) == null ? void 0 : _a2({ value: e4("_value"), valueAsString: e4("valueAsString") }));
      }, invokeOnInvalid({ context: e4, event: t, prop: n }) {
        var _a2;
        (_a2 = n("onValueInvalid")) == null ? void 0 : _a2({ value: t.value, index: e4.get("focusedIndex") });
      }, clearFocusedIndex({ context: e4 }) {
        e4.set("focusedIndex", -1);
      }, setFocusedIndex({ context: e4, event: t }) {
        e4.set("focusedIndex", t.index);
      }, setValue({ context: e4, event: t }) {
        let n = b4(t.value, e4.get("count"));
        e4.set("value", n);
      }, setFocusedValue({ context: e4, event: t, computed: n, flush: i }) {
        let l4 = n("focusedValue"), a3 = e4.get("focusedIndex"), u3 = ee7(l4, t.value);
        i(() => {
          e4.set("value", rs(n("_value"), a3, u3));
        });
      }, revertInputValue({ context: e4, computed: t, scope: n }) {
        let i = y7(n, e4.get("focusedIndex"));
        F8(i, t("focusedValue"));
      }, syncInputValue({ context: e4, event: t, scope: n }) {
        let i = e4.get("value"), l4 = y7(n, t.index);
        F8(l4, i[t.index]);
      }, syncInputElements({ context: e4, scope: t }) {
        let n = T6(t), i = e4.get("value");
        n.forEach((l4, a3) => {
          F8(l4, i[a3]);
        });
      }, setPastedValue({ context: e4, event: t, computed: n, flush: i }) {
        nt(() => {
          let l4 = n("valueAsString"), a3 = e4.get("focusedIndex"), u3 = n("valueLength"), v10 = n("filledValueLength"), c5 = Math.min(a3, v10), g7 = c5 > 0 ? l4.substring(0, a3) : "", m5 = t.value.substring(0, u3 - c5), P11 = b4(`${g7}${m5}`.split(""), u3);
          i(() => {
            e4.set("value", P11);
          });
        });
      }, setValueAtIndex({ context: e4, event: t, computed: n }) {
        let i = ee7(n("focusedValue"), t.value);
        e4.set("value", rs(n("_value"), t.index, i));
      }, clearValue({ context: e4 }) {
        let t = Array.from({ length: e4.get("count") }).fill("");
        queueMicrotask(() => {
          e4.set("value", t);
        });
      }, clearFocusedValue({ context: e4, computed: t }) {
        let n = e4.get("focusedIndex");
        n !== -1 && e4.set("value", rs(t("_value"), n, ""));
      }, setFocusIndexToFirst({ context: e4 }) {
        e4.set("focusedIndex", 0);
      }, setNextFocusedIndex({ context: e4, computed: t }) {
        e4.set("focusedIndex", Math.min(e4.get("focusedIndex") + 1, t("valueLength") - 1));
      }, setPrevFocusedIndex({ context: e4 }) {
        e4.set("focusedIndex", Math.max(e4.get("focusedIndex") - 1, 0));
      }, setLastValueFocusIndex({ context: e4, computed: t }) {
        nt(() => {
          e4.set("focusedIndex", Math.min(t("filledValueLength"), t("valueLength") - 1));
        });
      }, blurFocusedInputIfNeeded({ context: e4, prop: t, scope: n }) {
        t("blurOnComplete") && nt(() => {
          var _a2;
          (_a2 = y7(n, e4.get("focusedIndex"))) == null ? void 0 : _a2.blur();
        });
      }, requestFormSubmit({ computed: e4, prop: t, scope: n }) {
        var _a2, _b;
        if (!t("name") || !e4("isValueComplete")) return;
        (_b = (_a2 = Q12(n)) == null ? void 0 : _a2.form) == null ? void 0 : _b.requestSubmit();
      } } } });
      he7 = As()(["autoFocus", "blurOnComplete", "count", "defaultValue", "dir", "disabled", "form", "getRootNode", "id", "ids", "invalid", "mask", "name", "onValueChange", "onValueComplete", "onValueInvalid", "otp", "pattern", "placeholder", "readOnly", "required", "selectOnFocus", "translations", "type", "value"]);
      Pe8 = as(he7);
      L11 = class extends ve {
        initMachine(t) {
          return new Ls(ne6, t);
        }
        initApi() {
          return te5(this.machine.service, Cs);
        }
        render() {
          var _a2;
          let t = (_a2 = this.el.querySelector('[data-scope="pin-input"][data-part="root"]')) != null ? _a2 : this.el;
          this.spreadProps(t, this.api.getRootProps());
          let n = this.el.querySelector('[data-scope="pin-input"][data-part="label"]');
          n && this.spreadProps(n, this.api.getLabelProps());
          let i = this.el.querySelector('[data-scope="pin-input"][data-part="hidden-input"]');
          i && this.spreadProps(i, this.api.getHiddenInputProps());
          let l4 = this.el.querySelector('[data-scope="pin-input"][data-part="control"]');
          l4 && this.spreadProps(l4, this.api.getControlProps()), this.api.items.forEach((a3) => {
            let u3 = this.el.querySelector(`[data-scope="pin-input"][data-part="input"][data-index="${a3}"]`);
            u3 && this.spreadProps(u3, this.api.getInputProps({ index: a3 }));
          });
        }
      };
      Fe7 = { mounted() {
        var _a2;
        let e4 = this.el, t = Cr(e4, "value"), n = Cr(e4, "defaultValue"), i = _r(e4, "controlled"), l4 = new L11(e4, __spreadProps(__spreadValues({ id: e4.id, count: (_a2 = Lr(e4, "count")) != null ? _a2 : 4 }, i && t ? { value: t } : { defaultValue: n != null ? n : [] }), { disabled: _r(e4, "disabled"), invalid: _r(e4, "invalid"), required: _r(e4, "required"), readOnly: _r(e4, "readOnly"), mask: _r(e4, "mask"), otp: _r(e4, "otp"), blurOnComplete: _r(e4, "blurOnComplete"), selectOnFocus: _r(e4, "selectOnFocus"), name: xr(e4, "name"), form: xr(e4, "form"), dir: xr(e4, "dir", ["ltr", "rtl"]), type: xr(e4, "type", ["alphanumeric", "numeric", "alphabetic"]), placeholder: xr(e4, "placeholder"), onValueChange: (a3) => {
          let u3 = e4.querySelector('[data-scope="pin-input"][data-part="hidden-input"]');
          u3 && (u3.value = a3.valueAsString, u3.dispatchEvent(new Event("input", { bubbles: true })), u3.dispatchEvent(new Event("change", { bubbles: true })));
          let v10 = xr(e4, "onValueChange");
          v10 && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected() && this.pushEvent(v10, { value: a3.value, valueAsString: a3.valueAsString, id: e4.id });
          let c5 = xr(e4, "onValueChangeClient");
          c5 && e4.dispatchEvent(new CustomEvent(c5, { bubbles: true, detail: { value: a3, id: e4.id } }));
        }, onValueComplete: (a3) => {
          let u3 = xr(e4, "onValueComplete");
          u3 && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected() && this.pushEvent(u3, { value: a3.value, valueAsString: a3.valueAsString, id: e4.id });
        } }));
        l4.init(), this.pinInput = l4, this.handlers = [];
      }, updated() {
        var _a2, _b, _c, _d;
        let e4 = Cr(this.el, "value"), t = _r(this.el, "controlled");
        (_d = this.pinInput) == null ? void 0 : _d.updateProps(__spreadProps(__spreadValues({ id: this.el.id, count: (_c = (_b = Lr(this.el, "count")) != null ? _b : (_a2 = this.pinInput) == null ? void 0 : _a2.api.count) != null ? _c : 4 }, t && e4 ? { value: e4 } : {}), { disabled: _r(this.el, "disabled"), invalid: _r(this.el, "invalid"), required: _r(this.el, "required"), readOnly: _r(this.el, "readOnly"), name: xr(this.el, "name"), form: xr(this.el, "form") }));
      }, destroyed() {
        var _a2;
        if (this.handlers) for (let e4 of this.handlers) this.removeHandleEvent(e4);
        (_a2 = this.pinInput) == null ? void 0 : _a2.destroy();
      } };
    }
  });

  // ../priv/static/radio-group.mjs
  var radio_group_exports = {};
  __export(radio_group_exports, {
    RadioGroup: () => Ve11
  });
  function x8(e4, t) {
    let { context: r3, send: o2, computed: d4, prop: i, scope: n } = e4, c5 = d4("isDisabled"), m5 = i("invalid"), h6 = i("readOnly");
    function f4(a3) {
      return { value: a3.value, invalid: !!a3.invalid || !!m5, disabled: !!a3.disabled || c5, checked: r3.get("value") === a3.value, focused: r3.get("focusedValue") === a3.value, focusVisible: r3.get("focusVisibleValue") === a3.value, hovered: r3.get("hoveredValue") === a3.value, active: r3.get("activeValue") === a3.value };
    }
    function I11(a3) {
      let l4 = f4(a3);
      return { "data-focus": jr(l4.focused), "data-focus-visible": jr(l4.focusVisible), "data-disabled": jr(l4.disabled), "data-readonly": jr(h6), "data-state": l4.checked ? "checked" : "unchecked", "data-hover": jr(l4.hovered), "data-invalid": jr(l4.invalid), "data-orientation": i("orientation"), "data-ssr": jr(r3.get("ssr")) };
    }
    let T7 = () => {
      var _a2, _b;
      (_b = (_a2 = Z11(n)) != null ? _a2 : Y13(n)) == null ? void 0 : _b.focus();
    };
    return { focus: T7, value: r3.get("value"), setValue(a3) {
      o2({ type: "SET_VALUE", value: a3, isTrusted: false });
    }, clearValue() {
      o2({ type: "SET_VALUE", value: null, isTrusted: false });
    }, getRootProps() {
      return t.element(__spreadProps(__spreadValues({}, g6.root.attrs), { role: "radiogroup", id: b5(n), "aria-labelledby": U8(n), "aria-required": i("required") || void 0, "aria-disabled": c5 || void 0, "aria-readonly": h6 || void 0, "data-orientation": i("orientation"), "data-disabled": jr(c5), "data-invalid": jr(m5), "data-required": jr(i("required")), "aria-orientation": i("orientation"), dir: i("dir"), style: { position: "relative" } }));
    }, getLabelProps() {
      return t.element(__spreadProps(__spreadValues({}, g6.label.attrs), { dir: i("dir"), "data-orientation": i("orientation"), "data-disabled": jr(c5), "data-invalid": jr(m5), "data-required": jr(i("required")), id: U8(n), onClick: T7 }));
    }, getItemState: f4, getItemProps(a3) {
      let l4 = f4(a3);
      return t.label(__spreadProps(__spreadValues(__spreadProps(__spreadValues({}, g6.item.attrs), { dir: i("dir"), id: B8(n, a3.value), htmlFor: P9(n, a3.value) }), I11(a3)), { onPointerMove() {
        l4.disabled || l4.hovered || o2({ type: "SET_HOVERED", value: a3.value, hovered: true });
      }, onPointerLeave() {
        l4.disabled || o2({ type: "SET_HOVERED", value: null });
      }, onPointerDown(u3) {
        l4.disabled || ro(u3) && (l4.focused && u3.pointerType === "mouse" && u3.preventDefault(), o2({ type: "SET_ACTIVE", value: a3.value, active: true }));
      }, onPointerUp() {
        l4.disabled || o2({ type: "SET_ACTIVE", value: null });
      }, onClick() {
        var _a2;
        !l4.disabled && Xr() && ((_a2 = Q13(n, a3.value)) == null ? void 0 : _a2.focus());
      } }));
    }, getItemTextProps(a3) {
      return t.element(__spreadValues(__spreadProps(__spreadValues({}, g6.itemText.attrs), { dir: i("dir"), id: J11(n, a3.value) }), I11(a3)));
    }, getItemControlProps(a3) {
      let l4 = f4(a3);
      return t.element(__spreadValues(__spreadProps(__spreadValues({}, g6.itemControl.attrs), { dir: i("dir"), id: W12(n, a3.value), "data-active": jr(l4.active), "aria-hidden": true }), I11(a3)));
    }, getItemHiddenInputProps(a3) {
      let l4 = f4(a3);
      return t.input({ "data-ownedby": b5(n), id: P9(n, a3.value), type: "radio", name: i("name") || i("id"), form: i("form"), value: a3.value, required: i("required"), "aria-invalid": l4.invalid || void 0, onClick(u3) {
        if (h6) {
          u3.preventDefault();
          return;
        }
        u3.currentTarget.checked && o2({ type: "SET_VALUE", value: a3.value, isTrusted: true });
      }, onBlur() {
        o2({ type: "SET_FOCUSED", value: null, focused: false, focusVisible: false });
      }, onFocus() {
        let u3 = h2();
        o2({ type: "SET_FOCUSED", value: a3.value, focused: true, focusVisible: u3 });
      }, onKeyDown(u3) {
        u3.defaultPrevented || u3.key === " " && o2({ type: "SET_ACTIVE", value: a3.value, active: true });
      }, onKeyUp(u3) {
        u3.defaultPrevented || u3.key === " " && o2({ type: "SET_ACTIVE", value: null });
      }, disabled: l4.disabled || h6, defaultChecked: l4.checked, style: Co });
    }, getIndicatorProps() {
      let a3 = r3.get("indicatorRect"), l4 = a3 == null || a3.width === 0 && a3.height === 0 && a3.x === 0 && a3.y === 0;
      return t.element(__spreadProps(__spreadValues({ id: z9(n) }, g6.indicator.attrs), { dir: i("dir"), hidden: r3.get("value") == null || l4, "data-disabled": jr(c5), "data-orientation": i("orientation"), style: { "--transition-property": "left, top, width, height", "--left": is(a3 == null ? void 0 : a3.x), "--top": is(a3 == null ? void 0 : a3.y), "--width": is(a3 == null ? void 0 : a3.width), "--height": is(a3 == null ? void 0 : a3.height), position: "absolute", willChange: "var(--transition-property)", transitionProperty: "var(--transition-property)", transitionDuration: "var(--transition-duration, 150ms)", transitionTimingFunction: "var(--transition-timing-function)", [i("orientation") === "horizontal" ? "left" : "top"]: i("orientation") === "horizontal" ? "var(--left)" : "var(--top)" } }));
    } };
  }
  var K16, g6, b5, U8, B8, P9, W12, J11, z9, E12, Q13, X11, Y13, Z11, j9, ee8, te6, ae7, N7, ie7, pe8, re7, ve5, V13, Ve11;
  var init_radio_group = __esm({
    "../priv/static/radio-group.mjs"() {
      "use strict";
      init_chunk_XQAZHZIC();
      init_chunk_IYURAQ6S();
      K16 = G("radio-group").parts("root", "label", "item", "itemText", "itemControl", "indicator");
      g6 = K16.build();
      b5 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.root) != null ? _b : `radio-group:${e4.id}`;
      };
      U8 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.label) != null ? _b : `radio-group:${e4.id}:label`;
      };
      B8 = (e4, t) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = e4.ids) == null ? void 0 : _a2.item) == null ? void 0 : _b.call(_a2, t)) != null ? _c : `radio-group:${e4.id}:radio:${t}`;
      };
      P9 = (e4, t) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = e4.ids) == null ? void 0 : _a2.itemHiddenInput) == null ? void 0 : _b.call(_a2, t)) != null ? _c : `radio-group:${e4.id}:radio:input:${t}`;
      };
      W12 = (e4, t) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = e4.ids) == null ? void 0 : _a2.itemControl) == null ? void 0 : _b.call(_a2, t)) != null ? _c : `radio-group:${e4.id}:radio:control:${t}`;
      };
      J11 = (e4, t) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = e4.ids) == null ? void 0 : _a2.itemLabel) == null ? void 0 : _b.call(_a2, t)) != null ? _c : `radio-group:${e4.id}:radio:label:${t}`;
      };
      z9 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.indicator) != null ? _b : `radio-group:${e4.id}:indicator`;
      };
      E12 = (e4) => e4.getById(b5(e4));
      Q13 = (e4, t) => e4.getById(P9(e4, t));
      X11 = (e4) => e4.getById(z9(e4));
      Y13 = (e4) => {
        var _a2;
        return (_a2 = E12(e4)) == null ? void 0 : _a2.querySelector("input:not(:disabled)");
      };
      Z11 = (e4) => {
        var _a2;
        return (_a2 = E12(e4)) == null ? void 0 : _a2.querySelector("input:not(:disabled):checked");
      };
      j9 = (e4) => {
        let r3 = `input[type=radio][data-ownedby='${CSS.escape(b5(e4))}']:not([disabled])`;
        return Po(E12(e4), r3);
      };
      ee8 = (e4, t) => {
        if (t) return e4.getById(B8(e4, t));
      };
      te6 = (e4) => {
        var _a2, _b, _c, _d;
        return { x: (_a2 = e4 == null ? void 0 : e4.offsetLeft) != null ? _a2 : 0, y: (_b = e4 == null ? void 0 : e4.offsetTop) != null ? _b : 0, width: (_c = e4 == null ? void 0 : e4.offsetWidth) != null ? _c : 0, height: (_d = e4 == null ? void 0 : e4.offsetHeight) != null ? _d : 0 };
      };
      ({ not: ae7 } = dr());
      N7 = { props({ props: e4 }) {
        return __spreadValues({ orientation: "vertical" }, e4);
      }, initialState() {
        return "idle";
      }, context({ prop: e4, bindable: t }) {
        return { value: t(() => ({ defaultValue: e4("defaultValue"), value: e4("value"), onChange(r3) {
          var _a2;
          (_a2 = e4("onValueChange")) == null ? void 0 : _a2({ value: r3 });
        } })), activeValue: t(() => ({ defaultValue: null })), focusedValue: t(() => ({ defaultValue: null })), focusVisibleValue: t(() => ({ defaultValue: null })), hoveredValue: t(() => ({ defaultValue: null })), indicatorRect: t(() => ({ defaultValue: null })), fieldsetDisabled: t(() => ({ defaultValue: false })), ssr: t(() => ({ defaultValue: true })) };
      }, refs() {
        return { indicatorCleanup: null, focusVisibleValue: null };
      }, computed: { isDisabled: ({ prop: e4, context: t }) => !!e4("disabled") || t.get("fieldsetDisabled") }, entry: ["syncIndicatorRect", "syncSsr"], exit: ["cleanupObserver"], effects: ["trackFormControlState", "trackFocusVisible"], watch({ track: e4, action: t, context: r3 }) {
        e4([() => r3.get("value")], () => {
          t(["syncIndicatorRect", "syncInputElements"]);
        });
      }, on: { SET_VALUE: [{ guard: ae7("isTrusted"), actions: ["setValue", "dispatchChangeEvent"] }, { actions: ["setValue"] }], SET_HOVERED: { actions: ["setHovered"] }, SET_ACTIVE: { actions: ["setActive"] }, SET_FOCUSED: { actions: ["setFocused"] } }, states: { idle: {} }, implementations: { guards: { isTrusted: ({ event: e4 }) => !!e4.isTrusted }, effects: { trackFormControlState({ context: e4, scope: t }) {
        return lo(E12(t), { onFieldsetDisabledChange(r3) {
          e4.set("fieldsetDisabled", r3);
        }, onFormReset() {
          e4.set("value", e4.initial("value"));
        } });
      }, trackFocusVisible({ scope: e4 }) {
        var _a2;
        return S5({ root: (_a2 = e4.getRootNode) == null ? void 0 : _a2.call(e4) });
      } }, actions: { setValue({ context: e4, event: t }) {
        e4.set("value", t.value);
      }, setHovered({ context: e4, event: t }) {
        e4.set("hoveredValue", t.value);
      }, setActive({ context: e4, event: t }) {
        e4.set("activeValue", t.value);
      }, setFocused({ context: e4, event: t }) {
        e4.set("focusedValue", t.value);
        let r3 = t.value != null && t.focusVisible ? t.value : null;
        e4.set("focusVisibleValue", r3);
      }, syncInputElements({ context: e4, scope: t }) {
        j9(t).forEach((o2) => {
          o2.checked = o2.value === e4.get("value");
        });
      }, cleanupObserver({ refs: e4 }) {
        var _a2;
        (_a2 = e4.get("indicatorCleanup")) == null ? void 0 : _a2();
      }, syncSsr({ context: e4 }) {
        e4.set("ssr", false);
      }, syncIndicatorRect({ context: e4, scope: t, refs: r3 }) {
        var _a2;
        if ((_a2 = r3.get("indicatorCleanup")) == null ? void 0 : _a2(), !X11(t)) return;
        let o2 = e4.get("value"), d4 = ee8(t, o2);
        if (o2 == null || !d4) {
          e4.set("indicatorRect", null);
          return;
        }
        let i = () => {
          e4.set("indicatorRect", te6(d4));
        };
        i();
        let n = Ro.observe(d4, i);
        r3.set("indicatorCleanup", n);
      }, dispatchChangeEvent({ context: e4, scope: t }) {
        j9(t).forEach((o2) => {
          let d4 = o2.value === e4.get("value");
          d4 !== o2.checked && uo(o2, { checked: d4 });
        });
      } } } };
      ie7 = As()(["dir", "disabled", "form", "getRootNode", "id", "ids", "invalid", "name", "onValueChange", "orientation", "readOnly", "required", "value", "defaultValue"]);
      pe8 = as(ie7);
      re7 = As()(["value", "disabled", "invalid"]);
      ve5 = as(re7);
      V13 = class extends ve {
        initMachine(t) {
          return new Ls(N7, t);
        }
        initApi() {
          return x8(this.machine.service, Cs);
        }
        render() {
          var _a2;
          let t = (_a2 = this.el.querySelector('[data-scope="radio-group"][data-part="root"]')) != null ? _a2 : this.el;
          this.spreadProps(t, this.api.getRootProps());
          let r3 = this.el.querySelector('[data-scope="radio-group"][data-part="label"]');
          r3 && this.spreadProps(r3, this.api.getLabelProps());
          let o2 = this.el.querySelector('[data-scope="radio-group"][data-part="indicator"]');
          o2 && this.spreadProps(o2, this.api.getIndicatorProps()), this.el.querySelectorAll('[data-scope="radio-group"][data-part="item"]').forEach((d4) => {
            let i = d4.dataset.value;
            if (i == null) return;
            let n = d4.dataset.disabled === "true", c5 = d4.dataset.invalid === "true";
            this.spreadProps(d4, this.api.getItemProps({ value: i, disabled: n, invalid: c5 }));
            let m5 = d4.querySelector('[data-scope="radio-group"][data-part="item-text"]');
            m5 && this.spreadProps(m5, this.api.getItemTextProps({ value: i, disabled: n, invalid: c5 }));
            let h6 = d4.querySelector('[data-scope="radio-group"][data-part="item-control"]');
            h6 && this.spreadProps(h6, this.api.getItemControlProps({ value: i, disabled: n, invalid: c5 }));
            let f4 = d4.querySelector('[data-scope="radio-group"][data-part="item-hidden-input"]');
            f4 && this.spreadProps(f4, this.api.getItemHiddenInputProps({ value: i, disabled: n, invalid: c5 }));
          });
        }
      };
      Ve11 = { mounted() {
        let e4 = this.el, t = xr(e4, "value"), r3 = xr(e4, "defaultValue"), o2 = _r(e4, "controlled"), d4 = new V13(e4, __spreadProps(__spreadValues({ id: e4.id }, o2 && t !== void 0 ? { value: t != null ? t : null } : { defaultValue: r3 != null ? r3 : null }), { name: xr(e4, "name"), form: xr(e4, "form"), disabled: _r(e4, "disabled"), invalid: _r(e4, "invalid"), required: _r(e4, "required"), readOnly: _r(e4, "readOnly"), dir: xr(e4, "dir", ["ltr", "rtl"]), orientation: xr(e4, "orientation", ["horizontal", "vertical"]), onValueChange: (i) => {
          let n = xr(e4, "onValueChange");
          n && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected() && this.pushEvent(n, { value: i.value, id: e4.id });
          let c5 = xr(e4, "onValueChangeClient");
          c5 && e4.dispatchEvent(new CustomEvent(c5, { bubbles: true, detail: { value: i, id: e4.id } }));
        } }));
        d4.init(), this.radioGroup = d4, this.handlers = [];
      }, updated() {
        var _a2;
        let e4 = xr(this.el, "value"), t = _r(this.el, "controlled");
        (_a2 = this.radioGroup) == null ? void 0 : _a2.updateProps(__spreadProps(__spreadValues({ id: this.el.id }, t && e4 !== void 0 ? { value: e4 != null ? e4 : null } : {}), { name: xr(this.el, "name"), form: xr(this.el, "form"), disabled: _r(this.el, "disabled"), invalid: _r(this.el, "invalid"), required: _r(this.el, "required"), readOnly: _r(this.el, "readOnly"), orientation: xr(this.el, "orientation", ["horizontal", "vertical"]) }));
      }, destroyed() {
        var _a2;
        if (this.handlers) for (let e4 of this.handlers) this.removeHandleEvent(e4);
        (_a2 = this.radioGroup) == null ? void 0 : _a2.destroy();
      } };
    }
  });

  // ../priv/static/select.mjs
  var select_exports = {};
  __export(select_exports, {
    Select: () => ct6
  });
  function Se9(e4, t) {
    let { context: i, prop: l4, scope: n, state: a3, computed: d4, send: s } = e4, c5 = l4("disabled") || i.get("fieldsetDisabled"), g7 = !!l4("invalid"), E15 = !!l4("required"), O10 = !!l4("readOnly"), S13 = l4("composite"), f4 = l4("collection"), v10 = a3.hasTag("open"), R7 = a3.matches("focused"), T7 = i.get("highlightedValue"), Re9 = i.get("highlightedItem"), Pe10 = i.get("selectedItems"), w10 = i.get("currentPlacement"), z12 = d4("isTypingAhead"), _12 = d4("isInteractive"), q15 = T7 ? X12(n, T7) : void 0;
    function A12(o2) {
      let r3 = f4.getItemDisabled(o2.item), h6 = f4.getItemValue(o2.item);
      return ds(h6, () => `[zag-js] No value found for item ${JSON.stringify(o2.item)}`), { value: h6, disabled: !!(c5 || r3), highlighted: T7 === h6, selected: i.get("value").includes(h6) };
    }
    let Ve12 = $n2(__spreadProps(__spreadValues({}, l4("positioning")), { placement: w10 }));
    return { open: v10, focused: R7, empty: i.get("value").length === 0, highlightedItem: Re9, highlightedValue: T7, selectedItems: Pe10, hasSelectedItems: d4("hasSelectedItems"), value: i.get("value"), valueAsString: d4("valueAsString"), collection: f4, multiple: !!l4("multiple"), disabled: !!c5, reposition(o2 = {}) {
      s({ type: "POSITIONING.SET", options: o2 });
    }, focus() {
      var _a2;
      (_a2 = C13(n)) == null ? void 0 : _a2.focus({ preventScroll: true });
    }, setOpen(o2) {
      a3.hasTag("open") !== o2 && s({ type: o2 ? "OPEN" : "CLOSE" });
    }, selectValue(o2) {
      s({ type: "ITEM.SELECT", value: o2 });
    }, setValue(o2) {
      s({ type: "VALUE.SET", value: o2 });
    }, selectAll() {
      s({ type: "VALUE.SET", value: f4.getValues() });
    }, setHighlightValue(o2) {
      s({ type: "HIGHLIGHTED_VALUE.SET", value: o2 });
    }, clearHighlightValue() {
      s({ type: "HIGHLIGHTED_VALUE.CLEAR" });
    }, clearValue(o2) {
      s(o2 ? { type: "ITEM.CLEAR", value: o2 } : { type: "VALUE.CLEAR" });
    }, getItemState: A12, getRootProps() {
      return t.element(__spreadProps(__spreadValues({}, m2.root.attrs), { dir: l4("dir"), id: He7(n), "data-invalid": jr(g7), "data-readonly": jr(O10) }));
    }, getLabelProps() {
      return t.label(__spreadProps(__spreadValues({ dir: l4("dir"), id: D9(n) }, m2.label.attrs), { "data-disabled": jr(c5), "data-invalid": jr(g7), "data-readonly": jr(O10), "data-required": jr(E15), htmlFor: Z12(n), onClick(o2) {
        var _a2;
        o2.defaultPrevented || c5 || ((_a2 = C13(n)) == null ? void 0 : _a2.focus({ preventScroll: true }));
      } }));
    }, getControlProps() {
      return t.element(__spreadProps(__spreadValues({}, m2.control.attrs), { dir: l4("dir"), id: Ge8(n), "data-state": v10 ? "open" : "closed", "data-focus": jr(R7), "data-disabled": jr(c5), "data-invalid": jr(g7) }));
    }, getValueTextProps() {
      return t.element(__spreadProps(__spreadValues({}, m2.valueText.attrs), { dir: l4("dir"), "data-disabled": jr(c5), "data-invalid": jr(g7), "data-focus": jr(R7) }));
    }, getTriggerProps() {
      return t.button(__spreadProps(__spreadValues({ id: Q14(n), disabled: c5, dir: l4("dir"), type: "button", role: "combobox", "aria-controls": J12(n), "aria-expanded": v10, "aria-haspopup": "listbox", "data-state": v10 ? "open" : "closed", "aria-invalid": g7, "aria-required": E15, "aria-labelledby": D9(n) }, m2.trigger.attrs), { "data-disabled": jr(c5), "data-invalid": jr(g7), "data-readonly": jr(O10), "data-placement": w10, "data-placeholder-shown": jr(!d4("hasSelectedItems")), onClick(o2) {
        _12 && (o2.defaultPrevented || s({ type: "TRIGGER.CLICK" }));
      }, onFocus() {
        s({ type: "TRIGGER.FOCUS" });
      }, onBlur() {
        s({ type: "TRIGGER.BLUR" });
      }, onKeyDown(o2) {
        if (o2.defaultPrevented || !_12) return;
        let h6 = { ArrowUp() {
          s({ type: "TRIGGER.ARROW_UP" });
        }, ArrowDown(P11) {
          s({ type: P11.altKey ? "OPEN" : "TRIGGER.ARROW_DOWN" });
        }, ArrowLeft() {
          s({ type: "TRIGGER.ARROW_LEFT" });
        }, ArrowRight() {
          s({ type: "TRIGGER.ARROW_RIGHT" });
        }, Home() {
          s({ type: "TRIGGER.HOME" });
        }, End() {
          s({ type: "TRIGGER.END" });
        }, Enter() {
          s({ type: "TRIGGER.ENTER" });
        }, Space(P11) {
          s(z12 ? { type: "TRIGGER.TYPEAHEAD", key: P11.key } : { type: "TRIGGER.ENTER" });
        } }[io(o2, { dir: l4("dir"), orientation: "vertical" })];
        if (h6) {
          h6(o2), o2.preventDefault();
          return;
        }
        xo.isValidEvent(o2) && (s({ type: "TRIGGER.TYPEAHEAD", key: o2.key }), o2.preventDefault());
      } }));
    }, getIndicatorProps() {
      return t.element(__spreadProps(__spreadValues({}, m2.indicator.attrs), { dir: l4("dir"), "aria-hidden": true, "data-state": v10 ? "open" : "closed", "data-disabled": jr(c5), "data-invalid": jr(g7), "data-readonly": jr(O10) }));
    }, getItemProps(o2) {
      let r3 = A12(o2);
      return t.element(__spreadProps(__spreadValues({ id: X12(n, r3.value), role: "option" }, m2.item.attrs), { dir: l4("dir"), "data-value": r3.value, "aria-selected": r3.selected, "data-state": r3.selected ? "checked" : "unchecked", "data-highlighted": jr(r3.highlighted), "data-disabled": jr(r3.disabled), "aria-disabled": Br(r3.disabled), onPointerMove(h6) {
        r3.disabled || h6.pointerType !== "mouse" || r3.value !== T7 && s({ type: "ITEM.POINTER_MOVE", value: r3.value });
      }, onClick(h6) {
        h6.defaultPrevented || r3.disabled || s({ type: "ITEM.CLICK", src: "pointerup", value: r3.value });
      }, onPointerLeave(h6) {
        var _a2;
        r3.disabled || o2.persistFocus || h6.pointerType !== "mouse" || !((_a2 = e4.event.previous()) == null ? void 0 : _a2.type.includes("POINTER")) || s({ type: "ITEM.POINTER_LEAVE" });
      } }));
    }, getItemTextProps(o2) {
      let r3 = A12(o2);
      return t.element(__spreadProps(__spreadValues({}, m2.itemText.attrs), { "data-state": r3.selected ? "checked" : "unchecked", "data-disabled": jr(r3.disabled), "data-highlighted": jr(r3.highlighted) }));
    }, getItemIndicatorProps(o2) {
      let r3 = A12(o2);
      return t.element(__spreadProps(__spreadValues({ "aria-hidden": true }, m2.itemIndicator.attrs), { "data-state": r3.selected ? "checked" : "unchecked", hidden: !r3.selected }));
    }, getItemGroupLabelProps(o2) {
      let { htmlFor: r3 } = o2;
      return t.element(__spreadProps(__spreadValues({}, m2.itemGroupLabel.attrs), { id: fe7(n, r3), dir: l4("dir"), role: "presentation" }));
    }, getItemGroupProps(o2) {
      let { id: r3 } = o2;
      return t.element(__spreadProps(__spreadValues({}, m2.itemGroup.attrs), { "data-disabled": jr(c5), id: ke8(n, r3), "aria-labelledby": fe7(n, r3), role: "group", dir: l4("dir") }));
    }, getClearTriggerProps() {
      return t.button(__spreadProps(__spreadValues({}, m2.clearTrigger.attrs), { id: ye8(n), type: "button", "aria-label": "Clear value", "data-invalid": jr(g7), disabled: c5, hidden: !d4("hasSelectedItems"), dir: l4("dir"), onClick(o2) {
        o2.defaultPrevented || s({ type: "CLEAR.CLICK" });
      } }));
    }, getHiddenSelectProps() {
      let o2 = i.get("value"), r3 = l4("multiple") ? o2 : o2 == null ? void 0 : o2[0];
      return t.select({ name: l4("name"), form: l4("form"), disabled: c5, multiple: l4("multiple"), required: l4("required"), "aria-hidden": true, id: Z12(n), defaultValue: r3, style: Co, tabIndex: -1, onFocus() {
        var _a2;
        (_a2 = C13(n)) == null ? void 0 : _a2.focus({ preventScroll: true });
      }, "aria-labelledby": D9(n) });
    }, getPositionerProps() {
      return t.element(__spreadProps(__spreadValues({}, m2.positioner.attrs), { dir: l4("dir"), id: Oe9(n), style: Ve12.floating }));
    }, getContentProps() {
      return t.element(__spreadProps(__spreadValues({ hidden: !v10, dir: l4("dir"), id: J12(n), role: S13 ? "listbox" : "dialog" }, m2.content.attrs), { "data-state": v10 ? "open" : "closed", "data-placement": w10, "data-activedescendant": q15, "aria-activedescendant": S13 ? q15 : void 0, "aria-multiselectable": l4("multiple") && S13 ? true : void 0, "aria-labelledby": D9(n), tabIndex: 0, onKeyDown(o2) {
        if (!_12 || !Ie(o2.currentTarget, Je(o2))) return;
        if (o2.key === "Tab" && !po(o2)) {
          o2.preventDefault();
          return;
        }
        let r3 = { ArrowUp() {
          s({ type: "CONTENT.ARROW_UP" });
        }, ArrowDown() {
          s({ type: "CONTENT.ARROW_DOWN" });
        }, Home() {
          s({ type: "CONTENT.HOME" });
        }, End() {
          s({ type: "CONTENT.END" });
        }, Enter() {
          s({ type: "ITEM.CLICK", src: "keydown.enter" });
        }, Space(U11) {
          var _a2;
          z12 ? s({ type: "CONTENT.TYPEAHEAD", key: U11.key }) : (_a2 = r3.Enter) == null ? void 0 : _a2.call(r3, U11);
        } }, h6 = r3[io(o2)];
        if (h6) {
          h6(o2), o2.preventDefault();
          return;
        }
        let P11 = Je(o2);
        _e(P11) || xo.isValidEvent(o2) && (s({ type: "CONTENT.TYPEAHEAD", key: o2.key }), o2.preventDefault());
      } }));
    }, getListProps() {
      return t.element(__spreadProps(__spreadValues({}, m2.list.attrs), { tabIndex: 0, role: S13 ? void 0 : "listbox", "aria-labelledby": Q14(n), "aria-activedescendant": S13 ? void 0 : q15, "aria-multiselectable": !S13 && l4("multiple") ? true : void 0 }));
    } };
  }
  function Te7(e4) {
    var _a2, _b;
    let t = (_b = e4.restoreFocus) != null ? _b : (_a2 = e4.previousEvent) == null ? void 0 : _a2.restoreFocus;
    return t == null || !!t;
  }
  function Ce8(e4, t) {
    return t ? y8({ items: e4, itemToValue: (i) => {
      var _a2, _b;
      return (_b = (_a2 = i.id) != null ? _a2 : i.value) != null ? _b : "";
    }, itemToString: (i) => i.label, isItemDisabled: (i) => !!i.disabled, groupBy: (i) => {
      var _a2;
      return (_a2 = i.group) != null ? _a2 : "";
    } }) : y8({ items: e4, itemToValue: (i) => {
      var _a2, _b;
      return (_b = (_a2 = i.id) != null ? _a2 : i.value) != null ? _b : "";
    }, itemToString: (i) => i.label, isItemDisabled: (i) => !!i.disabled });
  }
  function _e7(e4) {
    return e4.replace(/_([a-z])/g, (t, i) => i.toUpperCase());
  }
  function qe9(e4) {
    let t = {};
    for (let [i, l4] of Object.entries(e4)) {
      let n = _e7(i);
      t[n] = l4;
    }
    return t;
  }
  var Le8, m2, y8, He7, J12, Q14, ye8, D9, Ge8, X12, Z12, Oe9, ke8, fe7, B9, G12, C13, Ae6, Ee7, Y14, k12, b6, Fe8, be6, Ne5, Qe7, De6, Xe7, Me7, Ze7, we6, ze8, M7, ct6;
  var init_select = __esm({
    "../priv/static/select.mjs"() {
      "use strict";
      init_chunk_MMRG4CGO();
      init_chunk_S6MRQC6S();
      init_chunk_5MNNWH4C();
      init_chunk_L4HS2GN2();
      init_chunk_IYURAQ6S();
      Le8 = G("select").parts("label", "positioner", "trigger", "indicator", "clearTrigger", "item", "itemText", "itemIndicator", "itemGroup", "itemGroupLabel", "list", "content", "root", "control", "valueText");
      m2 = Le8.build();
      y8 = (e4) => new q5(e4);
      y8.empty = () => new q5({ items: [] });
      He7 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.root) != null ? _b : `select:${e4.id}`;
      };
      J12 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.content) != null ? _b : `select:${e4.id}:content`;
      };
      Q14 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.trigger) != null ? _b : `select:${e4.id}:trigger`;
      };
      ye8 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.clearTrigger) != null ? _b : `select:${e4.id}:clear-trigger`;
      };
      D9 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.label) != null ? _b : `select:${e4.id}:label`;
      };
      Ge8 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.control) != null ? _b : `select:${e4.id}:control`;
      };
      X12 = (e4, t) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = e4.ids) == null ? void 0 : _a2.item) == null ? void 0 : _b.call(_a2, t)) != null ? _c : `select:${e4.id}:option:${t}`;
      };
      Z12 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.hiddenSelect) != null ? _b : `select:${e4.id}:select`;
      };
      Oe9 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.positioner) != null ? _b : `select:${e4.id}:positioner`;
      };
      ke8 = (e4, t) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = e4.ids) == null ? void 0 : _a2.itemGroup) == null ? void 0 : _b.call(_a2, t)) != null ? _c : `select:${e4.id}:optgroup:${t}`;
      };
      fe7 = (e4, t) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = e4.ids) == null ? void 0 : _a2.itemGroupLabel) == null ? void 0 : _b.call(_a2, t)) != null ? _c : `select:${e4.id}:optgroup-label:${t}`;
      };
      B9 = (e4) => e4.getById(Z12(e4));
      G12 = (e4) => e4.getById(J12(e4));
      C13 = (e4) => e4.getById(Q14(e4));
      Ae6 = (e4) => e4.getById(ye8(e4));
      Ee7 = (e4) => e4.getById(Oe9(e4));
      Y14 = (e4, t) => t == null ? null : e4.getById(X12(e4, t));
      ({ and: k12, not: b6, or: Fe8 } = dr());
      be6 = { props({ props: e4 }) {
        var _a2;
        return __spreadProps(__spreadValues({ loopFocus: false, closeOnSelect: !e4.multiple, composite: true, defaultValue: [] }, e4), { collection: (_a2 = e4.collection) != null ? _a2 : y8.empty(), positioning: __spreadValues({ placement: "bottom-start", gutter: 8 }, e4.positioning) });
      }, context({ prop: e4, bindable: t }) {
        return { value: t(() => ({ defaultValue: e4("defaultValue"), value: e4("value"), isEqual: V, onChange(i) {
          var _a2;
          let l4 = e4("collection").findMany(i);
          return (_a2 = e4("onValueChange")) == null ? void 0 : _a2({ value: i, items: l4 });
        } })), highlightedValue: t(() => ({ defaultValue: e4("defaultHighlightedValue") || null, value: e4("highlightedValue"), onChange(i) {
          var _a2;
          (_a2 = e4("onHighlightChange")) == null ? void 0 : _a2({ highlightedValue: i, highlightedItem: e4("collection").find(i), highlightedIndex: e4("collection").indexOf(i) });
        } })), currentPlacement: t(() => ({ defaultValue: void 0 })), fieldsetDisabled: t(() => ({ defaultValue: false })), highlightedItem: t(() => ({ defaultValue: null })), selectedItems: t(() => {
          var _a2, _b;
          let i = (_b = (_a2 = e4("value")) != null ? _a2 : e4("defaultValue")) != null ? _b : [];
          return { defaultValue: e4("collection").findMany(i) };
        }) };
      }, refs() {
        return { typeahead: __spreadValues({}, xo.defaultOptions) };
      }, computed: { hasSelectedItems: ({ context: e4 }) => e4.get("value").length > 0, isTypingAhead: ({ refs: e4 }) => e4.get("typeahead").keysSoFar !== "", isDisabled: ({ prop: e4, context: t }) => !!e4("disabled") || !!t.get("fieldsetDisabled"), isInteractive: ({ prop: e4 }) => !(e4("disabled") || e4("readOnly")), valueAsString: ({ context: e4, prop: t }) => t("collection").stringifyItems(e4.get("selectedItems")) }, initialState({ prop: e4 }) {
        return e4("open") || e4("defaultOpen") ? "open" : "idle";
      }, entry: ["syncSelectElement"], watch({ context: e4, prop: t, track: i, action: l4 }) {
        i([() => e4.get("value").toString()], () => {
          l4(["syncSelectedItems", "syncSelectElement", "dispatchChangeEvent"]);
        }), i([() => t("open")], () => {
          l4(["toggleVisibility"]);
        }), i([() => e4.get("highlightedValue")], () => {
          l4(["syncHighlightedItem"]);
        }), i([() => t("collection").toString()], () => {
          l4(["syncCollection"]);
        });
      }, on: { "HIGHLIGHTED_VALUE.SET": { actions: ["setHighlightedItem"] }, "HIGHLIGHTED_VALUE.CLEAR": { actions: ["clearHighlightedItem"] }, "ITEM.SELECT": { actions: ["selectItem"] }, "ITEM.CLEAR": { actions: ["clearItem"] }, "VALUE.SET": { actions: ["setSelectedItems"] }, "VALUE.CLEAR": { actions: ["clearSelectedItems"] }, "CLEAR.CLICK": { actions: ["clearSelectedItems", "focusTriggerEl"] } }, effects: ["trackFormControlState"], states: { idle: { tags: ["closed"], on: { "CONTROLLED.OPEN": [{ guard: "isTriggerClickEvent", target: "open", actions: ["setInitialFocus", "highlightFirstSelectedItem"] }, { target: "open", actions: ["setInitialFocus"] }], "TRIGGER.CLICK": [{ guard: "isOpenControlled", actions: ["invokeOnOpen"] }, { target: "open", actions: ["invokeOnOpen", "setInitialFocus", "highlightFirstSelectedItem"] }], "TRIGGER.FOCUS": { target: "focused" }, OPEN: [{ guard: "isOpenControlled", actions: ["invokeOnOpen"] }, { target: "open", actions: ["setInitialFocus", "invokeOnOpen"] }] } }, focused: { tags: ["closed"], on: { "CONTROLLED.OPEN": [{ guard: "isTriggerClickEvent", target: "open", actions: ["setInitialFocus", "highlightFirstSelectedItem"] }, { guard: "isTriggerArrowUpEvent", target: "open", actions: ["setInitialFocus", "highlightComputedLastItem"] }, { guard: Fe8("isTriggerArrowDownEvent", "isTriggerEnterEvent"), target: "open", actions: ["setInitialFocus", "highlightComputedFirstItem"] }, { target: "open", actions: ["setInitialFocus"] }], OPEN: [{ guard: "isOpenControlled", actions: ["invokeOnOpen"] }, { target: "open", actions: ["setInitialFocus", "invokeOnOpen"] }], "TRIGGER.BLUR": { target: "idle" }, "TRIGGER.CLICK": [{ guard: "isOpenControlled", actions: ["invokeOnOpen"] }, { target: "open", actions: ["setInitialFocus", "invokeOnOpen", "highlightFirstSelectedItem"] }], "TRIGGER.ENTER": [{ guard: "isOpenControlled", actions: ["invokeOnOpen"] }, { target: "open", actions: ["setInitialFocus", "invokeOnOpen", "highlightComputedFirstItem"] }], "TRIGGER.ARROW_UP": [{ guard: "isOpenControlled", actions: ["invokeOnOpen"] }, { target: "open", actions: ["setInitialFocus", "invokeOnOpen", "highlightComputedLastItem"] }], "TRIGGER.ARROW_DOWN": [{ guard: "isOpenControlled", actions: ["invokeOnOpen"] }, { target: "open", actions: ["setInitialFocus", "invokeOnOpen", "highlightComputedFirstItem"] }], "TRIGGER.ARROW_LEFT": [{ guard: k12(b6("multiple"), "hasSelectedItems"), actions: ["selectPreviousItem"] }, { guard: b6("multiple"), actions: ["selectLastItem"] }], "TRIGGER.ARROW_RIGHT": [{ guard: k12(b6("multiple"), "hasSelectedItems"), actions: ["selectNextItem"] }, { guard: b6("multiple"), actions: ["selectFirstItem"] }], "TRIGGER.HOME": { guard: b6("multiple"), actions: ["selectFirstItem"] }, "TRIGGER.END": { guard: b6("multiple"), actions: ["selectLastItem"] }, "TRIGGER.TYPEAHEAD": { guard: b6("multiple"), actions: ["selectMatchingItem"] } } }, open: { tags: ["open"], exit: ["scrollContentToTop"], effects: ["trackDismissableElement", "computePlacement", "scrollToHighlightedItem"], on: { "CONTROLLED.CLOSE": [{ guard: "restoreFocus", target: "focused", actions: ["focusTriggerEl", "clearHighlightedItem"] }, { target: "idle", actions: ["clearHighlightedItem"] }], CLOSE: [{ guard: "isOpenControlled", actions: ["invokeOnClose"] }, { guard: "restoreFocus", target: "focused", actions: ["invokeOnClose", "focusTriggerEl", "clearHighlightedItem"] }, { target: "idle", actions: ["invokeOnClose", "clearHighlightedItem"] }], "TRIGGER.CLICK": [{ guard: "isOpenControlled", actions: ["invokeOnClose"] }, { target: "focused", actions: ["invokeOnClose", "clearHighlightedItem"] }], "ITEM.CLICK": [{ guard: k12("closeOnSelect", "isOpenControlled"), actions: ["selectHighlightedItem", "invokeOnClose"] }, { guard: "closeOnSelect", target: "focused", actions: ["selectHighlightedItem", "invokeOnClose", "focusTriggerEl", "clearHighlightedItem"] }, { actions: ["selectHighlightedItem"] }], "CONTENT.HOME": { actions: ["highlightFirstItem"] }, "CONTENT.END": { actions: ["highlightLastItem"] }, "CONTENT.ARROW_DOWN": [{ guard: k12("hasHighlightedItem", "loop", "isLastItemHighlighted"), actions: ["highlightFirstItem"] }, { guard: "hasHighlightedItem", actions: ["highlightNextItem"] }, { actions: ["highlightFirstItem"] }], "CONTENT.ARROW_UP": [{ guard: k12("hasHighlightedItem", "loop", "isFirstItemHighlighted"), actions: ["highlightLastItem"] }, { guard: "hasHighlightedItem", actions: ["highlightPreviousItem"] }, { actions: ["highlightLastItem"] }], "CONTENT.TYPEAHEAD": { actions: ["highlightMatchingItem"] }, "ITEM.POINTER_MOVE": { actions: ["highlightItem"] }, "ITEM.POINTER_LEAVE": { actions: ["clearHighlightedItem"] }, "POSITIONING.SET": { actions: ["reposition"] } } } }, implementations: { guards: { loop: ({ prop: e4 }) => !!e4("loopFocus"), multiple: ({ prop: e4 }) => !!e4("multiple"), hasSelectedItems: ({ computed: e4 }) => !!e4("hasSelectedItems"), hasHighlightedItem: ({ context: e4 }) => e4.get("highlightedValue") != null, isFirstItemHighlighted: ({ context: e4, prop: t }) => e4.get("highlightedValue") === t("collection").firstValue, isLastItemHighlighted: ({ context: e4, prop: t }) => e4.get("highlightedValue") === t("collection").lastValue, closeOnSelect: ({ prop: e4, event: t }) => {
        var _a2;
        return !!((_a2 = t.closeOnSelect) != null ? _a2 : e4("closeOnSelect"));
      }, restoreFocus: ({ event: e4 }) => Te7(e4), isOpenControlled: ({ prop: e4 }) => e4("open") !== void 0, isTriggerClickEvent: ({ event: e4 }) => {
        var _a2;
        return ((_a2 = e4.previousEvent) == null ? void 0 : _a2.type) === "TRIGGER.CLICK";
      }, isTriggerEnterEvent: ({ event: e4 }) => {
        var _a2;
        return ((_a2 = e4.previousEvent) == null ? void 0 : _a2.type) === "TRIGGER.ENTER";
      }, isTriggerArrowUpEvent: ({ event: e4 }) => {
        var _a2;
        return ((_a2 = e4.previousEvent) == null ? void 0 : _a2.type) === "TRIGGER.ARROW_UP";
      }, isTriggerArrowDownEvent: ({ event: e4 }) => {
        var _a2;
        return ((_a2 = e4.previousEvent) == null ? void 0 : _a2.type) === "TRIGGER.ARROW_DOWN";
      } }, effects: { trackFormControlState({ context: e4, scope: t }) {
        return lo(B9(t), { onFieldsetDisabledChange(i) {
          e4.set("fieldsetDisabled", i);
        }, onFormReset() {
          let i = e4.initial("value");
          e4.set("value", i);
        } });
      }, trackDismissableElement({ scope: e4, send: t, prop: i }) {
        let l4 = () => G12(e4), n = true;
        return H9(l4, { type: "listbox", defer: true, exclude: [C13(e4), Ae6(e4)], onFocusOutside: i("onFocusOutside"), onPointerDownOutside: i("onPointerDownOutside"), onInteractOutside(a3) {
          var _a2;
          (_a2 = i("onInteractOutside")) == null ? void 0 : _a2(a3), n = !(a3.detail.focusable || a3.detail.contextmenu);
        }, onDismiss() {
          t({ type: "CLOSE", src: "interact-outside", restoreFocus: n });
        } });
      }, computePlacement({ context: e4, prop: t, scope: i }) {
        let l4 = t("positioning");
        return e4.set("currentPlacement", l4.placement), Mn2(() => C13(i), () => Ee7(i), __spreadProps(__spreadValues({ defer: true }, l4), { onComplete(d4) {
          e4.set("currentPlacement", d4.placement);
        } }));
      }, scrollToHighlightedItem({ context: e4, prop: t, scope: i, event: l4 }) {
        let n = (d4) => {
          let s = e4.get("highlightedValue");
          if (s == null || l4.current().type.includes("POINTER")) return;
          let c5 = G12(i), g7 = t("scrollToIndexFn");
          if (g7) {
            let O10 = t("collection").indexOf(s);
            g7 == null ? void 0 : g7({ index: O10, immediate: d4, getElement: () => Y14(i, s) });
            return;
          }
          let E15 = Y14(i, s);
          bo(E15, { rootEl: c5, block: "nearest" });
        };
        return nt(() => n(true)), go(() => G12(i), { defer: true, attributes: ["data-activedescendant"], callback() {
          n(false);
        } });
      } }, actions: { reposition({ context: e4, prop: t, scope: i, event: l4 }) {
        let n = () => Ee7(i);
        Mn2(C13(i), n, __spreadProps(__spreadValues(__spreadValues({}, t("positioning")), l4.options), { defer: true, listeners: false, onComplete(a3) {
          e4.set("currentPlacement", a3.placement);
        } }));
      }, toggleVisibility({ send: e4, prop: t, event: i }) {
        e4({ type: t("open") ? "CONTROLLED.OPEN" : "CONTROLLED.CLOSE", previousEvent: i });
      }, highlightPreviousItem({ context: e4, prop: t }) {
        let i = e4.get("highlightedValue");
        if (i == null) return;
        let l4 = t("collection").getPreviousValue(i, 1, t("loopFocus"));
        l4 != null && e4.set("highlightedValue", l4);
      }, highlightNextItem({ context: e4, prop: t }) {
        let i = e4.get("highlightedValue");
        if (i == null) return;
        let l4 = t("collection").getNextValue(i, 1, t("loopFocus"));
        l4 != null && e4.set("highlightedValue", l4);
      }, highlightFirstItem({ context: e4, prop: t }) {
        let i = t("collection").firstValue;
        e4.set("highlightedValue", i);
      }, highlightLastItem({ context: e4, prop: t }) {
        let i = t("collection").lastValue;
        e4.set("highlightedValue", i);
      }, setInitialFocus({ scope: e4 }) {
        nt(() => {
          var _a2;
          (_a2 = ho({ root: G12(e4) })) == null ? void 0 : _a2.focus({ preventScroll: true });
        });
      }, focusTriggerEl({ event: e4, scope: t }) {
        Te7(e4) && nt(() => {
          var _a2;
          (_a2 = C13(t)) == null ? void 0 : _a2.focus({ preventScroll: true });
        });
      }, selectHighlightedItem({ context: e4, prop: t, event: i }) {
        var _a2, _b;
        let l4 = (_a2 = i.value) != null ? _a2 : e4.get("highlightedValue");
        if (l4 == null || !t("collection").has(l4)) return;
        (_b = t("onSelect")) == null ? void 0 : _b({ value: l4 }), l4 = t("deselectable") && !t("multiple") && e4.get("value").includes(l4) ? null : l4, e4.set("value", (a3) => l4 == null ? [] : t("multiple") ? Ko(a3, l4) : [l4]);
      }, highlightComputedFirstItem({ context: e4, prop: t, computed: i }) {
        let l4 = t("collection"), n = i("hasSelectedItems") ? l4.sort(e4.get("value"))[0] : l4.firstValue;
        e4.set("highlightedValue", n);
      }, highlightComputedLastItem({ context: e4, prop: t, computed: i }) {
        let l4 = t("collection"), n = i("hasSelectedItems") ? l4.sort(e4.get("value"))[0] : l4.lastValue;
        e4.set("highlightedValue", n);
      }, highlightFirstSelectedItem({ context: e4, prop: t, computed: i }) {
        if (!i("hasSelectedItems")) return;
        let l4 = t("collection").sort(e4.get("value"))[0];
        e4.set("highlightedValue", l4);
      }, highlightItem({ context: e4, event: t }) {
        e4.set("highlightedValue", t.value);
      }, highlightMatchingItem({ context: e4, prop: t, event: i, refs: l4 }) {
        let n = t("collection").search(i.key, { state: l4.get("typeahead"), currentValue: e4.get("highlightedValue") });
        n != null && e4.set("highlightedValue", n);
      }, setHighlightedItem({ context: e4, event: t }) {
        e4.set("highlightedValue", t.value);
      }, clearHighlightedItem({ context: e4 }) {
        e4.set("highlightedValue", null);
      }, selectItem({ context: e4, prop: t, event: i }) {
        var _a2;
        (_a2 = t("onSelect")) == null ? void 0 : _a2({ value: i.value });
        let n = t("deselectable") && !t("multiple") && e4.get("value").includes(i.value) ? null : i.value;
        e4.set("value", (a3) => n == null ? [] : t("multiple") ? Ko(a3, n) : [n]);
      }, clearItem({ context: e4, event: t }) {
        e4.set("value", (i) => i.filter((l4) => l4 !== t.value));
      }, setSelectedItems({ context: e4, event: t }) {
        e4.set("value", t.value);
      }, clearSelectedItems({ context: e4 }) {
        e4.set("value", []);
      }, selectPreviousItem({ context: e4, prop: t }) {
        let [i] = e4.get("value"), l4 = t("collection").getPreviousValue(i);
        l4 && e4.set("value", [l4]);
      }, selectNextItem({ context: e4, prop: t }) {
        let [i] = e4.get("value"), l4 = t("collection").getNextValue(i);
        l4 && e4.set("value", [l4]);
      }, selectFirstItem({ context: e4, prop: t }) {
        let i = t("collection").firstValue;
        i && e4.set("value", [i]);
      }, selectLastItem({ context: e4, prop: t }) {
        let i = t("collection").lastValue;
        i && e4.set("value", [i]);
      }, selectMatchingItem({ context: e4, prop: t, event: i, refs: l4 }) {
        let n = t("collection").search(i.key, { state: l4.get("typeahead"), currentValue: e4.get("value")[0] });
        n != null && e4.set("value", [n]);
      }, scrollContentToTop({ prop: e4, scope: t }) {
        var _a2, _b;
        if (e4("scrollToIndexFn")) {
          let i = e4("collection").firstValue;
          (_a2 = e4("scrollToIndexFn")) == null ? void 0 : _a2({ index: 0, immediate: true, getElement: () => Y14(t, i) });
        } else (_b = G12(t)) == null ? void 0 : _b.scrollTo(0, 0);
      }, invokeOnOpen({ prop: e4, context: t }) {
        var _a2;
        (_a2 = e4("onOpenChange")) == null ? void 0 : _a2({ open: true, value: t.get("value") });
      }, invokeOnClose({ prop: e4, context: t }) {
        var _a2;
        (_a2 = e4("onOpenChange")) == null ? void 0 : _a2({ open: false, value: t.get("value") });
      }, syncSelectElement({ context: e4, prop: t, scope: i }) {
        let l4 = B9(i);
        if (l4) {
          if (e4.get("value").length === 0 && !t("multiple")) {
            l4.selectedIndex = -1;
            return;
          }
          for (let n of l4.options) n.selected = e4.get("value").includes(n.value);
        }
      }, syncCollection({ context: e4, prop: t }) {
        let i = t("collection"), l4 = i.find(e4.get("highlightedValue"));
        l4 && e4.set("highlightedItem", l4);
        let n = i.findMany(e4.get("value"));
        e4.set("selectedItems", n);
      }, syncSelectedItems({ context: e4, prop: t }) {
        let i = t("collection"), l4 = e4.get("selectedItems"), a3 = e4.get("value").map((d4) => l4.find((c5) => i.getItemValue(c5) === d4) || i.find(d4));
        e4.set("selectedItems", a3);
      }, syncHighlightedItem({ context: e4, prop: t }) {
        let i = t("collection"), l4 = e4.get("highlightedValue"), n = l4 ? i.find(l4) : null;
        e4.set("highlightedItem", n);
      }, dispatchChangeEvent({ scope: e4 }) {
        queueMicrotask(() => {
          let t = B9(e4);
          if (!t) return;
          let i = e4.getWin(), l4 = new i.Event("change", { bubbles: true, composed: true });
          t.dispatchEvent(l4);
        });
      } } } };
      Ne5 = As()(["closeOnSelect", "collection", "composite", "defaultHighlightedValue", "defaultOpen", "defaultValue", "deselectable", "dir", "disabled", "form", "getRootNode", "highlightedValue", "id", "ids", "invalid", "loopFocus", "multiple", "name", "onFocusOutside", "onHighlightChange", "onInteractOutside", "onOpenChange", "onPointerDownOutside", "onSelect", "onValueChange", "open", "positioning", "readOnly", "required", "scrollToIndexFn", "value"]);
      Qe7 = as(Ne5);
      De6 = As()(["item", "persistFocus"]);
      Xe7 = as(De6);
      Me7 = As()(["id"]);
      Ze7 = as(Me7);
      we6 = As()(["htmlFor"]);
      ze8 = as(we6);
      M7 = class extends ve {
        constructor(t, i) {
          var _a2;
          super(t, i);
          __publicField(this, "_options", []);
          __publicField(this, "hasGroups", false);
          __publicField(this, "placeholder", "");
          __publicField(this, "init", () => {
            this.machine.start(), this.render(), this.machine.subscribe(() => {
              this.api = this.initApi(), this.render();
            });
          });
          let l4 = i.collection;
          this._options = (_a2 = l4 == null ? void 0 : l4.items) != null ? _a2 : [], this.placeholder = xr(this.el, "placeholder") || "";
        }
        get options() {
          return Array.isArray(this._options) ? this._options : [];
        }
        setOptions(t) {
          this._options = Array.isArray(t) ? t : [];
        }
        getCollection() {
          let t = this.options;
          return this.hasGroups ? y8({ items: t, itemToValue: (i) => {
            var _a2, _b;
            return (_b = (_a2 = i.id) != null ? _a2 : i.value) != null ? _b : "";
          }, itemToString: (i) => i.label, isItemDisabled: (i) => !!i.disabled, groupBy: (i) => {
            var _a2;
            return (_a2 = i.group) != null ? _a2 : "";
          } }) : y8({ items: t, itemToValue: (i) => {
            var _a2, _b;
            return (_b = (_a2 = i.id) != null ? _a2 : i.value) != null ? _b : "";
          }, itemToString: (i) => i.label, isItemDisabled: (i) => !!i.disabled });
        }
        initMachine(t) {
          let i = this.getCollection.bind(this), l4 = t.collection;
          return new Ls(be6, __spreadProps(__spreadValues({}, t), { get collection() {
            return l4 != null ? l4 : i();
          } }));
        }
        initApi() {
          return Se9(this.machine.service, Cs);
        }
        applyItemProps() {
          let t = this.el.querySelector('[data-scope="select"][data-part="content"]');
          t && (t.querySelectorAll('[data-scope="select"][data-part="item-group"]').forEach((i) => {
            var _a2;
            let l4 = (_a2 = i.dataset.id) != null ? _a2 : "";
            this.spreadProps(i, this.api.getItemGroupProps({ id: l4 }));
            let n = i.querySelector('[data-scope="select"][data-part="item-group-label"]');
            n && this.spreadProps(n, this.api.getItemGroupLabelProps({ htmlFor: l4 }));
          }), t.querySelectorAll('[data-scope="select"][data-part="item"]').forEach((i) => {
            var _a2;
            let l4 = (_a2 = i.dataset.value) != null ? _a2 : "", n = this.options.find((s) => {
              var _a3, _b;
              return String((_b = (_a3 = s.id) != null ? _a3 : s.value) != null ? _b : "") === String(l4);
            });
            if (!n) return;
            this.spreadProps(i, this.api.getItemProps({ item: n }));
            let a3 = i.querySelector('[data-scope="select"][data-part="item-text"]');
            a3 && this.spreadProps(a3, this.api.getItemTextProps({ item: n }));
            let d4 = i.querySelector('[data-scope="select"][data-part="item-indicator"]');
            d4 && this.spreadProps(d4, this.api.getItemIndicatorProps({ item: n }));
          }));
        }
        render() {
          var _a2;
          let t = (_a2 = this.el.querySelector('[data-scope="select"][data-part="root"]')) != null ? _a2 : this.el;
          this.spreadProps(t, this.api.getRootProps());
          let i = this.el.querySelector('[data-scope="select"][data-part="hidden-select"]'), l4 = this.el.querySelector('[data-scope="select"][data-part="value-input"]');
          l4 && (!this.api.value || this.api.value.length === 0 ? l4.value = "" : this.api.value.length === 1 ? l4.value = String(this.api.value[0]) : l4.value = this.api.value.map(String).join(",")), i && this.spreadProps(i, this.api.getHiddenSelectProps()), ["label", "control", "trigger", "indicator", "clear-trigger", "positioner"].forEach((d4) => {
            let s = this.el.querySelector(`[data-scope="select"][data-part="${d4}"]`);
            if (!s) return;
            let c5 = "get" + d4.split("-").map((g7) => g7[0].toUpperCase() + g7.slice(1)).join("") + "Props";
            this.spreadProps(s, this.api[c5]());
          });
          let n = this.el.querySelector('[data-scope="select"][data-part="item-text"]');
          if (n) {
            let d4 = this.api.valueAsString;
            if (this.api.value && this.api.value.length > 0 && !d4) {
              let s = this.api.value[0], c5 = this.options.find((g7) => {
                var _a3, _b;
                let E15 = (_b = (_a3 = g7.id) != null ? _a3 : g7.value) != null ? _b : "";
                return String(E15) === String(s);
              });
              c5 ? n.textContent = c5.label : n.textContent = this.placeholder || "";
            } else n.textContent = d4 || this.placeholder || "";
          }
          let a3 = this.el.querySelector('[data-scope="select"][data-part="content"]');
          a3 && (this.spreadProps(a3, this.api.getContentProps()), this.applyItemProps());
        }
      };
      ct6 = { mounted() {
        let e4 = this.el, t = JSON.parse(e4.dataset.collection || "[]"), i = t.some((a3) => a3.group !== void 0), l4 = Ce8(t, i), n = new M7(e4, __spreadProps(__spreadValues({ id: e4.id, collection: l4 }, _r(e4, "controlled") ? { value: Cr(e4, "value") } : { defaultValue: Cr(e4, "defaultValue") }), { disabled: _r(e4, "disabled"), closeOnSelect: _r(e4, "closeOnSelect"), dir: xr(e4, "dir", ["ltr", "rtl"]), loopFocus: _r(e4, "loopFocus"), multiple: _r(e4, "multiple"), invalid: _r(e4, "invalid"), name: xr(e4, "name"), form: xr(e4, "form"), readOnly: _r(e4, "readOnly"), required: _r(e4, "required"), positioning: (() => {
          let a3 = e4.dataset.positioning;
          if (a3) try {
            let d4 = JSON.parse(a3);
            return qe9(d4);
          } catch (e5) {
            return;
          }
        })(), onValueChange: (a3) => {
          var _a2;
          let d4 = _r(e4, "redirect"), s = a3.value.length > 0 ? String(a3.value[0]) : null, c5 = ((_a2 = a3.items) == null ? void 0 : _a2.length) ? a3.items[0] : null, g7 = c5 && typeof c5 == "object" && c5 !== null && "redirect" in c5 ? c5.redirect : void 0, E15 = c5 && typeof c5 == "object" && c5 !== null && "new_tab" in c5 ? c5.new_tab : void 0;
          d4 && s && this.liveSocket.main.isDead && g7 !== false && (E15 === true ? window.open(s, "_blank", "noopener,noreferrer") : window.location.href = s);
          let f4 = e4.querySelector('[data-scope="select"][data-part="value-input"]');
          f4 && (f4.value = a3.value.length === 0 ? "" : a3.value.length === 1 ? String(a3.value[0]) : a3.value.map(String).join(","), f4.dispatchEvent(new Event("input", { bubbles: true })), f4.dispatchEvent(new Event("change", { bubbles: true })));
          let v10 = { value: a3.value, items: a3.items, id: e4.id }, R7 = xr(e4, "onValueChangeClient");
          R7 && e4.dispatchEvent(new CustomEvent(R7, { bubbles: true, detail: v10 }));
          let T7 = xr(e4, "onValueChange");
          T7 && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected() && this.pushEvent(T7, v10);
        } }));
        n.hasGroups = i, n.setOptions(t), n.init(), this.select = n, this.handlers = [];
      }, updated() {
        let e4 = JSON.parse(this.el.dataset.collection || "[]"), t = e4.some((i) => i.group !== void 0);
        this.select && (this.select.hasGroups = t, this.select.setOptions(e4), this.select.updateProps(__spreadProps(__spreadValues({ collection: Ce8(e4, t), id: this.el.id }, _r(this.el, "controlled") ? { value: Cr(this.el, "value") } : { defaultValue: Cr(this.el, "defaultValue") }), { name: xr(this.el, "name"), form: xr(this.el, "form"), disabled: _r(this.el, "disabled"), multiple: _r(this.el, "multiple"), dir: xr(this.el, "dir", ["ltr", "rtl"]), invalid: _r(this.el, "invalid"), required: _r(this.el, "required"), readOnly: _r(this.el, "readOnly") })));
      }, destroyed() {
        var _a2;
        if (this.handlers) for (let e4 of this.handlers) this.removeHandleEvent(e4);
        (_a2 = this.select) == null ? void 0 : _a2.destroy();
      } };
    }
  });

  // ../priv/static/signature-pad.mjs
  var signature_pad_exports = {};
  __export(signature_pad_exports, {
    SignaturePad: () => De7
  });
  function It6(t, e4, n, r3 = (a3) => a3) {
    return t * r3(0.5 - e4 * (0.5 - n));
  }
  function qt4(t, e4, n) {
    let r3 = rt7(1, e4 / n);
    return rt7(1, t + (rt7(1, 1 - r3) - t) * (r3 * 0.275));
  }
  function Qt4(t) {
    return [-t[0], -t[1]];
  }
  function v8(t, e4) {
    return [t[0] + e4[0], t[1] + e4[1]];
  }
  function kt5(t, e4, n) {
    return t[0] = e4[0] + n[0], t[1] = e4[1] + n[1], t;
  }
  function M8(t, e4) {
    return [t[0] - e4[0], t[1] - e4[1]];
  }
  function st7(t, e4, n) {
    return t[0] = e4[0] - n[0], t[1] = e4[1] - n[1], t;
  }
  function b7(t, e4) {
    return [t[0] * e4, t[1] * e4];
  }
  function at6(t, e4, n) {
    return t[0] = e4[0] * n, t[1] = e4[1] * n, t;
  }
  function Xt4(t, e4) {
    return [t[0] / e4, t[1] / e4];
  }
  function Nt5(t) {
    return [t[1], -t[0]];
  }
  function it7(t, e4) {
    let n = e4[0];
    return t[0] = e4[1], t[1] = -n, t;
  }
  function Tt5(t, e4) {
    return t[0] * e4[0] + t[1] * e4[1];
  }
  function Yt5(t, e4) {
    return t[0] === e4[0] && t[1] === e4[1];
  }
  function Zt4(t) {
    return Math.hypot(t[0], t[1]);
  }
  function Lt6(t, e4) {
    let n = t[0] - e4[0], r3 = t[1] - e4[1];
    return n * n + r3 * r3;
  }
  function At5(t) {
    return Xt4(t, Zt4(t));
  }
  function te7(t, e4) {
    return Math.hypot(t[1] - e4[1], t[0] - e4[0]);
  }
  function ot6(t, e4, n) {
    let r3 = Math.sin(n), a3 = Math.cos(n), i = t[0] - e4[0], o2 = t[1] - e4[1], s = i * a3 - o2 * r3, l4 = i * r3 + o2 * a3;
    return [s + e4[0], l4 + e4[1]];
  }
  function Ht4(t, e4, n, r3) {
    let a3 = Math.sin(r3), i = Math.cos(r3), o2 = e4[0] - n[0], s = e4[1] - n[1], l4 = o2 * i - s * a3, p4 = o2 * a3 + s * i;
    return t[0] = l4 + n[0], t[1] = p4 + n[1], t;
  }
  function Ct5(t, e4, n) {
    return v8(t, b7(M8(e4, t), n));
  }
  function ee9(t, e4, n, r3) {
    let a3 = n[0] - e4[0], i = n[1] - e4[1];
    return t[0] = e4[0] + a3 * r3, t[1] = e4[1] + i * r3, t;
  }
  function _t3(t, e4, n) {
    return v8(t, b7(e4, n));
  }
  function ne7(t, e4) {
    let n = _t3(t, At5(Nt5(M8(t, v8(t, [1, 1])))), -e4), r3 = [], a3 = 1 / 13;
    for (let i = a3; i <= 1; i += a3) r3.push(ot6(n, t, x9 * 2 * i));
    return r3;
  }
  function re8(t, e4, n) {
    let r3 = [], a3 = 1 / n;
    for (let i = a3; i <= 1; i += a3) r3.push(ot6(e4, t, x9 * i));
    return r3;
  }
  function ae8(t, e4, n) {
    let r3 = M8(e4, n), a3 = b7(r3, 0.5), i = b7(r3, 0.51);
    return [M8(t, a3), M8(t, i), v8(t, i), v8(t, a3)];
  }
  function ie8(t, e4, n, r3) {
    let a3 = [], i = _t3(t, e4, n), o2 = 1 / r3;
    for (let s = o2; s < 1; s += o2) a3.push(ot6(i, t, x9 * 3 * s));
    return a3;
  }
  function se8(t, e4, n) {
    return [v8(t, b7(e4, n)), v8(t, b7(e4, n * 0.99)), M8(t, b7(e4, n * 0.99)), M8(t, b7(e4, n))];
  }
  function Dt5(t, e4, n) {
    return t === false || t === void 0 ? 0 : t === true ? Math.max(e4, n) : t;
  }
  function oe7(t, e4, n) {
    return t.slice(0, 10).reduce((r3, a3) => {
      let i = a3.pressure;
      return e4 && (i = qt4(r3, a3.distance, n)), (r3 + i) / 2;
    }, t[0].pressure);
  }
  function ue7(t, e4 = {}) {
    let { size: n = 16, smoothing: r3 = 0.5, thinning: a3 = 0.5, simulatePressure: i = true, easing: o2 = (d4) => d4, start: s = {}, end: l4 = {}, last: p4 = false } = e4, { cap: f4 = true, easing: g7 = (d4) => d4 * (2 - d4) } = s, { cap: h6 = true, easing: m5 = (d4) => --d4 * d4 * d4 + 1 } = l4;
    if (t.length === 0 || n <= 0) return [];
    let u3 = t[t.length - 1].runningLength, E15 = Dt5(s.taper, n, u3), I11 = Dt5(l4.taper, n, u3), R7 = (n * r3) ** 2, k14 = [], C17 = [], ut9 = oe7(t, i, n), P11 = It6(n, a3, t[t.length - 1].pressure, o2), z12, K19 = t[0].vector, q15 = t[0].point, U11 = q15, T7 = q15, L13 = U11, Q17 = false;
    for (let d4 = 0; d4 < t.length; d4++) {
      let { pressure: tt9 } = t[d4], { point: S13, vector: N10, distance: Bt5, runningLength: A12 } = t[d4], F10 = d4 === t.length - 1;
      if (!F10 && u3 - A12 < 3) continue;
      a3 ? (i && (tt9 = qt4(ut9, Bt5, n)), P11 = It6(n, a3, tt9, o2)) : P11 = n / 2, z12 === void 0 && (z12 = P11);
      let Jt5 = A12 < E15 ? g7(A12 / E15) : 1, Wt4 = u3 - A12 < I11 ? m5((u3 - A12) / I11) : 1;
      P11 = Math.max(0.01, P11 * Math.min(Jt5, Wt4));
      let lt7 = (F10 ? t[d4] : t[d4 + 1]).vector, et8 = F10 ? 1 : Tt5(N10, lt7), zt3 = Tt5(N10, K19) < 0 && !Q17, pt6 = et8 !== null && et8 < 0;
      if (zt3 || pt6) {
        it7(c4, K19), at6(c4, c4, P11);
        for (let $13 = 0; $13 <= 1; $13 += 0.07692307692307693) st7(y9, S13, c4), Ht4(y9, y9, S13, x9 * $13), T7 = [y9[0], y9[1]], k14.push(T7), kt5(w8, S13, c4), Ht4(w8, w8, S13, x9 * -$13), L13 = [w8[0], w8[1]], C17.push(L13);
        q15 = T7, U11 = L13, pt6 && (Q17 = true);
        continue;
      }
      if (Q17 = false, F10) {
        it7(c4, N10), at6(c4, c4, P11), k14.push(M8(S13, c4)), C17.push(v8(S13, c4));
        continue;
      }
      ee9(c4, lt7, N10, et8), it7(c4, c4), at6(c4, c4, P11), st7(y9, S13, c4), T7 = [y9[0], y9[1]], (d4 <= 1 || Lt6(q15, T7) > R7) && (k14.push(T7), q15 = T7), kt5(w8, S13, c4), L13 = [w8[0], w8[1]], (d4 <= 1 || Lt6(U11, L13) > R7) && (C17.push(L13), U11 = L13), ut9 = tt9, K19 = N10;
    }
    let X16 = [t[0].point[0], t[0].point[1]], Y16 = t.length > 1 ? [t[t.length - 1].point[0], t[t.length - 1].point[1]] : v8(t[0].point, [1, 1]), Z14 = [], V16 = [];
    if (t.length === 1) {
      if (!(E15 || I11) || p4) return ne7(X16, z12 || P11);
    } else {
      E15 || I11 && t.length === 1 || (f4 ? Z14.push(...re8(X16, C17[0], 13)) : Z14.push(...ae8(X16, k14[0], C17[0])));
      let d4 = Nt5(Qt4(t[t.length - 1].vector));
      I11 || E15 && t.length === 1 ? V16.push(Y16) : h6 ? V16.push(...ie8(Y16, d4, P11, 29)) : V16.push(...se8(Y16, d4, P11));
    }
    return k14.concat(V16, C17.reverse(), Z14);
  }
  function Rt4(t) {
    return t != null && t >= 0;
  }
  function le8(t, e4 = {}) {
    var _a2;
    let { streamline: n = 0.5, size: r3 = 16, last: a3 = false } = e4;
    if (t.length === 0) return [];
    let i = 0.15 + (1 - n) * 0.85, o2 = Array.isArray(t[0]) ? t : t.map(({ x: h6, y: m5, pressure: u3 = bt5 }) => [h6, m5, u3]);
    if (o2.length === 2) {
      let h6 = o2[1];
      o2 = o2.slice(0, -1);
      for (let m5 = 1; m5 < 5; m5++) o2.push(Ct5(o2[0], h6, m5 / 4));
    }
    o2.length === 1 && (o2 = [...o2, [...v8(o2[0], Mt4), ...o2[0].slice(2)]]);
    let s = [{ point: [o2[0][0], o2[0][1]], pressure: Rt4(o2[0][2]) ? o2[0][2] : 0.25, vector: [...Mt4], distance: 0, runningLength: 0 }], l4 = false, p4 = 0, f4 = s[0], g7 = o2.length - 1;
    for (let h6 = 1; h6 < o2.length; h6++) {
      let m5 = a3 && h6 === g7 ? [o2[h6][0], o2[h6][1]] : Ct5(f4.point, o2[h6], i);
      if (Yt5(f4.point, m5)) continue;
      let u3 = te7(m5, f4.point);
      if (p4 += u3, h6 < g7 && !l4) {
        if (p4 < r3) continue;
        l4 = true;
      }
      st7(Ot3, f4.point, m5), f4 = { point: m5, pressure: Rt4(o2[h6][2]) ? o2[h6][2] : bt5, vector: At5(Ot3), distance: u3, runningLength: p4 }, s.push(f4);
    }
    return s[0].vector = ((_a2 = s[1]) == null ? void 0 : _a2.vector) || [0, 0], s;
  }
  function pe9(t, e4 = {}) {
    return ue7(le8(t, e4), e4);
  }
  function $t4(t, e4) {
    let { state: n, send: r3, prop: a3, computed: i, context: o2, scope: s } = t, l4 = n.matches("drawing"), p4 = i("isEmpty"), f4 = i("isInteractive"), g7 = !!a3("disabled"), h6 = !!a3("required"), m5 = a3("translations");
    return { empty: p4, drawing: l4, currentPath: o2.get("currentPath"), paths: o2.get("paths"), clear() {
      r3({ type: "CLEAR" });
    }, getDataUrl(u3, E15) {
      return i("isEmpty") ? Promise.resolve("") : Ft4(s, { type: u3, quality: E15 });
    }, getLabelProps() {
      return e4.label(__spreadProps(__spreadValues({}, H11.label.attrs), { id: ce7(s), "data-disabled": jr(g7), "data-required": jr(h6), htmlFor: Ut4(s), onClick(u3) {
        var _a2;
        if (!f4 || u3.defaultPrevented) return;
        (_a2 = B10(s)) == null ? void 0 : _a2.focus({ preventScroll: true });
      } }));
    }, getRootProps() {
      return e4.element(__spreadProps(__spreadValues({}, H11.root.attrs), { "data-disabled": jr(g7), id: he8(s) }));
    }, getControlProps() {
      return e4.element(__spreadProps(__spreadValues({}, H11.control.attrs), { tabIndex: g7 ? void 0 : 0, id: Vt5(s), role: "application", "aria-roledescription": "signature pad", "aria-label": m5.control, "aria-disabled": g7, "data-disabled": jr(g7), onPointerDown(u3) {
        var _a2;
        if (!ro(u3) || so(u3) || !f4 || ((_a2 = Je(u3)) == null ? void 0 : _a2.closest("[data-part=clear-trigger]"))) return;
        u3.currentTarget.setPointerCapture(u3.pointerId);
        let I11 = { x: u3.clientX, y: u3.clientY }, R7 = B10(s);
        if (!R7) return;
        let { offset: k14 } = vo(I11, R7);
        r3({ type: "POINTER_DOWN", point: k14, pressure: u3.pressure });
      }, onPointerUp(u3) {
        f4 && u3.currentTarget.hasPointerCapture(u3.pointerId) && u3.currentTarget.releasePointerCapture(u3.pointerId);
      }, style: { position: "relative", touchAction: "none", userSelect: "none", WebkitUserSelect: "none" } }));
    }, getSegmentProps() {
      return e4.svg(__spreadProps(__spreadValues({}, H11.segment.attrs), { style: { position: "absolute", top: 0, left: 0, width: "100%", height: "100%", pointerEvents: "none", fill: a3("drawing").fill } }));
    }, getSegmentPathProps(u3) {
      return e4.path(__spreadProps(__spreadValues({}, H11.segmentPath.attrs), { d: u3.path }));
    }, getGuideProps() {
      return e4.element(__spreadProps(__spreadValues({}, H11.guide.attrs), { "data-disabled": jr(g7) }));
    }, getClearTriggerProps() {
      return e4.button(__spreadProps(__spreadValues({}, H11.clearTrigger.attrs), { type: "button", "aria-label": m5.clearTrigger, hidden: !o2.get("paths").length || l4, disabled: g7, onClick() {
        r3({ type: "CLEAR" });
      } }));
    }, getHiddenInputProps(u3) {
      return e4.input({ id: Ut4(s), type: "text", hidden: true, disabled: g7, required: a3("required"), readOnly: true, name: a3("name"), value: u3.value });
    } };
  }
  function fe8(t, e4 = true) {
    let n = t.length;
    if (n < 4) return "";
    let r3 = t[0], a3 = t[1], i = t[2], o2 = `M${r3[0].toFixed(2)},${r3[1].toFixed(2)} Q${a3[0].toFixed(2)},${a3[1].toFixed(2)} ${G13(a3[0], i[0]).toFixed(2)},${G13(a3[1], i[1]).toFixed(2)} T`;
    for (let s = 2, l4 = n - 1; s < l4; s++) r3 = t[s], a3 = t[s + 1], o2 += `${G13(r3[0], a3[0]).toFixed(2)},${G13(r3[1], a3[1]).toFixed(2)} `;
    return e4 && (o2 += "Z"), o2;
  }
  function W13(t, e4) {
    let n = t.dataset[e4];
    if (!n) return [];
    try {
      return JSON.parse(n);
    } catch (e5) {
      return [];
    }
  }
  function Gt5(t) {
    var _a2, _b, _c, _d;
    return { fill: xr(t, "drawingFill") || "black", size: (_a2 = Lr(t, "drawingSize")) != null ? _a2 : 2, simulatePressure: _r(t, "drawingSimulatePressure"), smoothing: (_b = Lr(t, "drawingSmoothing")) != null ? _b : 0.5, thinning: (_c = Lr(t, "drawingThinning")) != null ? _c : 0.7, streamline: (_d = Lr(t, "drawingStreamline")) != null ? _d : 0.65 };
  }
  var Kt4, x9, bt5, Mt4, rt7, c4, y9, w8, Ot3, xt5, de9, H11, he8, Vt5, ce7, Ut4, B10, ge7, Ft4, G13, jt4, me7, be7, J13, De7;
  var init_signature_pad = __esm({
    "../priv/static/signature-pad.mjs"() {
      "use strict";
      init_chunk_IYURAQ6S();
      ({ PI: Kt4 } = Math);
      x9 = Kt4 + 1e-4;
      bt5 = 0.5;
      Mt4 = [1, 1];
      ({ min: rt7 } = Math);
      c4 = [0, 0];
      y9 = [0, 0];
      w8 = [0, 0];
      Ot3 = [0, 0];
      xt5 = pe9;
      de9 = G("signature-pad").parts("root", "control", "segment", "segmentPath", "guide", "clearTrigger", "label");
      H11 = de9.build();
      he8 = (t) => {
        var _a2, _b;
        return (_b = (_a2 = t.ids) == null ? void 0 : _a2.root) != null ? _b : `signature-${t.id}`;
      };
      Vt5 = (t) => {
        var _a2, _b;
        return (_b = (_a2 = t.ids) == null ? void 0 : _a2.control) != null ? _b : `signature-control-${t.id}`;
      };
      ce7 = (t) => {
        var _a2, _b;
        return (_b = (_a2 = t.ids) == null ? void 0 : _a2.label) != null ? _b : `signature-label-${t.id}`;
      };
      Ut4 = (t) => {
        var _a2, _b;
        return (_b = (_a2 = t.ids) == null ? void 0 : _a2.hiddenInput) != null ? _b : `signature-input-${t.id}`;
      };
      B10 = (t) => t.getById(Vt5(t));
      ge7 = (t) => So(B10(t), "[data-part=segment]");
      Ft4 = (t, e4) => Yr(ge7(t), e4);
      G13 = (t, e4) => (t + e4) / 2;
      jt4 = { props({ props: t }) {
        return __spreadProps(__spreadValues({ defaultPaths: [] }, t), { drawing: __spreadValues({ size: 2, simulatePressure: false, thinning: 0.7, smoothing: 0.4, streamline: 0.6 }, t.drawing), translations: __spreadValues({ control: "signature pad", clearTrigger: "clear signature" }, t.translations) });
      }, initialState() {
        return "idle";
      }, context({ prop: t, bindable: e4 }) {
        return { paths: e4(() => ({ defaultValue: t("defaultPaths"), value: t("paths"), sync: true, onChange(n) {
          var _a2;
          (_a2 = t("onDraw")) == null ? void 0 : _a2({ paths: n });
        } })), currentPoints: e4(() => ({ defaultValue: [] })), currentPath: e4(() => ({ defaultValue: null })) };
      }, computed: { isInteractive: ({ prop: t }) => !(t("disabled") || t("readOnly")), isEmpty: ({ context: t }) => t.get("paths").length === 0 }, on: { CLEAR: { actions: ["clearPoints", "invokeOnDrawEnd", "focusCanvasEl"] } }, states: { idle: { on: { POINTER_DOWN: { target: "drawing", actions: ["addPoint"] } } }, drawing: { effects: ["trackPointerMove"], on: { POINTER_MOVE: { actions: ["addPoint", "invokeOnDraw"] }, POINTER_UP: { target: "idle", actions: ["endStroke", "invokeOnDrawEnd"] } } } }, implementations: { effects: { trackPointerMove({ scope: t, send: e4 }) {
        let n = t.getDoc();
        return Eo(n, { onPointerMove({ event: r3, point: a3 }) {
          let i = B10(t);
          if (!i) return;
          let { offset: o2 } = vo(a3, i);
          e4({ type: "POINTER_MOVE", point: o2, pressure: r3.pressure });
        }, onPointerUp() {
          e4({ type: "POINTER_UP" });
        } });
      } }, actions: { addPoint({ context: t, event: e4, prop: n }) {
        let r3 = [...t.get("currentPoints"), e4.point];
        t.set("currentPoints", r3);
        let a3 = xt5(r3, n("drawing"));
        t.set("currentPath", fe8(a3));
      }, endStroke({ context: t }) {
        let e4 = [...t.get("paths"), t.get("currentPath")];
        t.set("paths", e4), t.set("currentPoints", []), t.set("currentPath", null);
      }, clearPoints({ context: t }) {
        t.set("currentPoints", []), t.set("paths", []), t.set("currentPath", null);
      }, focusCanvasEl({ scope: t }) {
        queueMicrotask(() => {
          var _a2;
          (_a2 = t.getActiveElement()) == null ? void 0 : _a2.focus({ preventScroll: true });
        });
      }, invokeOnDraw({ context: t, prop: e4 }) {
        var _a2;
        (_a2 = e4("onDraw")) == null ? void 0 : _a2({ paths: [...t.get("paths"), t.get("currentPath")] });
      }, invokeOnDrawEnd({ context: t, prop: e4, scope: n, computed: r3 }) {
        var _a2;
        (_a2 = e4("onDrawEnd")) == null ? void 0 : _a2({ paths: [...t.get("paths")], getDataUrl(a3, i = 0.92) {
          return r3("isEmpty") ? Promise.resolve("") : Ft4(n, { type: a3, quality: i });
        } });
      } } } };
      me7 = As()(["defaultPaths", "dir", "disabled", "drawing", "getRootNode", "id", "ids", "name", "onDraw", "onDrawEnd", "paths", "readOnly", "required", "translations"]);
      be7 = as(me7);
      J13 = class extends ve {
        constructor() {
          super(...arguments);
          __publicField(this, "imageURL", "");
          __publicField(this, "paths", []);
          __publicField(this, "name");
          __publicField(this, "syncPaths", () => {
            let e4 = this.el.querySelector('[data-scope="signature-pad"][data-part="segment"]');
            if (!e4) return;
            if (this.api.paths.length + (this.api.currentPath ? 1 : 0) === 0) {
              e4.innerHTML = "", this.imageURL = "", this.paths = [];
              let r3 = this.el.querySelector('[data-scope="signature-pad"][data-part="hidden-input"]');
              r3 && (r3.value = "");
              return;
            }
            if (e4.innerHTML = "", this.api.paths.forEach((r3) => {
              let a3 = document.createElementNS("http://www.w3.org/2000/svg", "path");
              a3.setAttribute("data-scope", "signature-pad"), a3.setAttribute("data-part", "path"), this.spreadProps(a3, this.api.getSegmentPathProps({ path: r3 })), e4.appendChild(a3);
            }), this.api.currentPath) {
              let r3 = document.createElementNS("http://www.w3.org/2000/svg", "path");
              r3.setAttribute("data-scope", "signature-pad"), r3.setAttribute("data-part", "current-path"), this.spreadProps(r3, this.api.getSegmentPathProps({ path: this.api.currentPath })), e4.appendChild(r3);
            }
          });
        }
        initMachine(e4) {
          return this.name = e4.name, new Ls(jt4, e4);
        }
        setName(e4) {
          this.name = e4;
        }
        setPaths(e4) {
          this.paths = e4;
        }
        initApi() {
          return $t4(this.machine.service, Cs);
        }
        render() {
          let e4 = this.el.querySelector('[data-scope="signature-pad"][data-part="root"]');
          if (!e4) return;
          this.spreadProps(e4, this.api.getRootProps());
          let n = e4.querySelector('[data-scope="signature-pad"][data-part="label"]');
          n && this.spreadProps(n, this.api.getLabelProps());
          let r3 = e4.querySelector('[data-scope="signature-pad"][data-part="control"]');
          r3 && this.spreadProps(r3, this.api.getControlProps());
          let a3 = e4.querySelector('[data-scope="signature-pad"][data-part="segment"]');
          a3 && this.spreadProps(a3, this.api.getSegmentProps());
          let i = e4.querySelector('[data-scope="signature-pad"][data-part="guide"]');
          i && this.spreadProps(i, this.api.getGuideProps());
          let o2 = e4.querySelector('[data-scope="signature-pad"][data-part="clear-trigger"]');
          if (o2) {
            this.spreadProps(o2, this.api.getClearTriggerProps());
            let l4 = this.api.paths.length > 0 || !!this.api.currentPath;
            o2.hidden = !l4;
          }
          let s = e4.querySelector('[data-scope="signature-pad"][data-part="hidden-input"]');
          if (s) {
            let l4 = this.paths.length > 0 ? this.paths : this.api.paths;
            this.paths.length === 0 && this.api.paths.length > 0 && (this.paths = [...this.api.paths]);
            let p4 = l4.length > 0 ? JSON.stringify(l4) : "";
            this.spreadProps(s, this.api.getHiddenInputProps({ value: p4 })), this.name && (s.name = this.name), s.value = p4;
          }
          this.syncPaths();
        }
      };
      De7 = { mounted() {
        let t = this.el, e4 = this.pushEvent.bind(this), n = _r(t, "controlled"), r3 = W13(t, "paths"), a3 = W13(t, "defaultPaths"), i = new J13(t, __spreadProps(__spreadValues(__spreadValues({ id: t.id, name: xr(t, "name") }, n && r3.length > 0 ? { paths: r3 } : void 0), !n && a3.length > 0 ? { defaultPaths: a3 } : void 0), { drawing: Gt5(t), onDrawEnd: (s) => {
          i.setPaths(s.paths);
          let l4 = t.querySelector('[data-scope="signature-pad"][data-part="hidden-input"]');
          l4 && (l4.value = JSON.stringify(s.paths)), s.getDataUrl("image/png").then((p4) => {
            i.imageURL = p4;
            let f4 = xr(t, "onDrawEnd");
            f4 && this.liveSocket.main.isConnected() && e4(f4, { id: t.id, paths: s.paths, url: p4 });
            let g7 = xr(t, "onDrawEndClient");
            g7 && t.dispatchEvent(new CustomEvent(g7, { bubbles: true, detail: { id: t.id, paths: s.paths, url: p4 } }));
          });
        } }));
        if (i.init(), this.signaturePad = i, (n ? r3 : a3).length > 0) {
          let s = t.querySelector('[data-scope="signature-pad"][data-part="hidden-input"]');
          s && (s.dispatchEvent(new Event("input", { bubbles: true })), s.dispatchEvent(new Event("change", { bubbles: true })));
        }
        this.onClear = (s) => {
          let { id: l4 } = s.detail;
          if (l4 && l4 !== t.id) return;
          i.api.clear(), i.imageURL = "", i.setPaths([]);
          let p4 = t.querySelector('[data-scope="signature-pad"][data-part="hidden-input"]');
          p4 && (p4.value = "");
        }, t.addEventListener("phx:signature-pad:clear", this.onClear), this.handlers = [], this.handlers.push(this.handleEvent("signature_pad_clear", (s) => {
          let l4 = s.signature_pad_id;
          if (l4 && l4 !== t.id) return;
          i.api.clear(), i.imageURL = "", i.setPaths([]);
          let p4 = t.querySelector('[data-scope="signature-pad"][data-part="hidden-input"]');
          p4 && (p4.value = "");
        }));
      }, updated() {
        var _a2, _b;
        let t = _r(this.el, "controlled"), e4 = W13(this.el, "paths"), n = W13(this.el, "defaultPaths"), r3 = xr(this.el, "name");
        r3 && ((_a2 = this.signaturePad) == null ? void 0 : _a2.setName(r3)), (_b = this.signaturePad) == null ? void 0 : _b.updateProps(__spreadProps(__spreadValues(__spreadValues({ id: this.el.id, name: r3 }, t && e4.length > 0 ? { paths: e4 } : {}), !t && n.length > 0 ? { defaultPaths: n } : {}), { drawing: Gt5(this.el) }));
      }, destroyed() {
        var _a2;
        if (this.onClear && this.el.removeEventListener("phx:signature-pad:clear", this.onClear), this.handlers) for (let t of this.handlers) this.removeHandleEvent(t);
        (_a2 = this.signaturePad) == null ? void 0 : _a2.destroy();
      } };
    }
  });

  // ../priv/static/switch.mjs
  var switch_exports = {};
  __export(switch_exports, {
    Switch: () => le9
  });
  function x10(e4, t) {
    let { context: i, send: s, prop: a3, scope: r3 } = e4, c5 = !!a3("disabled"), m5 = !!a3("readOnly"), j12 = !!a3("required"), u3 = !!i.get("checked"), C17 = !c5 && i.get("focused"), K19 = !c5 && i.get("focusVisible"), G14 = !c5 && i.get("active"), p4 = { "data-active": jr(G14), "data-focus": jr(C17), "data-focus-visible": jr(K19), "data-readonly": jr(m5), "data-hover": jr(i.get("hovered")), "data-disabled": jr(c5), "data-state": u3 ? "checked" : "unchecked", "data-invalid": jr(a3("invalid")), "data-required": jr(j12) };
    return { checked: u3, disabled: c5, focused: C17, setChecked(n) {
      s({ type: "CHECKED.SET", checked: n, isTrusted: false });
    }, toggleChecked() {
      s({ type: "CHECKED.TOGGLE", checked: u3, isTrusted: false });
    }, getRootProps() {
      return t.label(__spreadProps(__spreadValues(__spreadValues({}, f2.root.attrs), p4), { dir: a3("dir"), id: R5(r3), htmlFor: v9(r3), onPointerMove() {
        c5 || s({ type: "CONTEXT.SET", context: { hovered: true } });
      }, onPointerLeave() {
        c5 || s({ type: "CONTEXT.SET", context: { hovered: false } });
      }, onClick(n) {
        var _a2;
        if (c5) return;
        Je(n) === h4(r3) && n.stopPropagation(), Xr() && ((_a2 = h4(r3)) == null ? void 0 : _a2.focus());
      } }));
    }, getLabelProps() {
      return t.element(__spreadProps(__spreadValues(__spreadValues({}, f2.label.attrs), p4), { dir: a3("dir"), id: O8(r3) }));
    }, getThumbProps() {
      return t.element(__spreadProps(__spreadValues(__spreadValues({}, f2.thumb.attrs), p4), { dir: a3("dir"), id: $10(r3), "aria-hidden": true }));
    }, getControlProps() {
      return t.element(__spreadProps(__spreadValues(__spreadValues({}, f2.control.attrs), p4), { dir: a3("dir"), id: z10(r3), "aria-hidden": true }));
    }, getHiddenInputProps() {
      return t.input({ id: v9(r3), type: "checkbox", required: a3("required"), defaultChecked: u3, disabled: c5, "aria-labelledby": O8(r3), "aria-invalid": a3("invalid"), name: a3("name"), form: a3("form"), value: a3("value"), style: Co, onFocus() {
        let n = h2();
        s({ type: "CONTEXT.SET", context: { focused: true, focusVisible: n } });
      }, onBlur() {
        s({ type: "CONTEXT.SET", context: { focused: false, focusVisible: false } });
      }, onClick(n) {
        if (m5) {
          n.preventDefault();
          return;
        }
        let g7 = n.currentTarget.checked;
        s({ type: "CHECKED.SET", checked: g7, isTrusted: true });
      } });
    } };
  }
  var X13, f2, R5, O8, $10, z10, v9, B11, h4, N8, A10, U9, ie9, k13, le9;
  var init_switch = __esm({
    "../priv/static/switch.mjs"() {
      "use strict";
      init_chunk_XQAZHZIC();
      init_chunk_IYURAQ6S();
      X13 = G("switch").parts("root", "label", "control", "thumb");
      f2 = X13.build();
      R5 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.root) != null ? _b : `switch:${e4.id}`;
      };
      O8 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.label) != null ? _b : `switch:${e4.id}:label`;
      };
      $10 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.thumb) != null ? _b : `switch:${e4.id}:thumb`;
      };
      z10 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.control) != null ? _b : `switch:${e4.id}:control`;
      };
      v9 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.hiddenInput) != null ? _b : `switch:${e4.id}:input`;
      };
      B11 = (e4) => e4.getById(R5(e4));
      h4 = (e4) => e4.getById(v9(e4));
      ({ not: N8 } = dr());
      A10 = { props({ props: e4 }) {
        return __spreadValues({ defaultChecked: false, label: "switch", value: "on" }, e4);
      }, initialState() {
        return "ready";
      }, context({ prop: e4, bindable: t }) {
        return { checked: t(() => ({ defaultValue: e4("defaultChecked"), value: e4("checked"), onChange(i) {
          var _a2;
          (_a2 = e4("onCheckedChange")) == null ? void 0 : _a2({ checked: i });
        } })), fieldsetDisabled: t(() => ({ defaultValue: false })), focusVisible: t(() => ({ defaultValue: false })), active: t(() => ({ defaultValue: false })), focused: t(() => ({ defaultValue: false })), hovered: t(() => ({ defaultValue: false })) };
      }, computed: { isDisabled: ({ context: e4, prop: t }) => t("disabled") || e4.get("fieldsetDisabled") }, watch({ track: e4, prop: t, context: i, action: s }) {
        e4([() => t("disabled")], () => {
          s(["removeFocusIfNeeded"]);
        }), e4([() => i.get("checked")], () => {
          s(["syncInputElement"]);
        });
      }, effects: ["trackFormControlState", "trackPressEvent", "trackFocusVisible"], on: { "CHECKED.TOGGLE": [{ guard: N8("isTrusted"), actions: ["toggleChecked", "dispatchChangeEvent"] }, { actions: ["toggleChecked"] }], "CHECKED.SET": [{ guard: N8("isTrusted"), actions: ["setChecked", "dispatchChangeEvent"] }, { actions: ["setChecked"] }], "CONTEXT.SET": { actions: ["setContext"] } }, states: { ready: {} }, implementations: { guards: { isTrusted: ({ event: e4 }) => !!e4.isTrusted }, effects: { trackPressEvent({ computed: e4, scope: t, context: i }) {
        if (!e4("isDisabled")) return Ao({ pointerNode: B11(t), keyboardNode: h4(t), isValidKey: (s) => s.key === " ", onPress: () => i.set("active", false), onPressStart: () => i.set("active", true), onPressEnd: () => i.set("active", false) });
      }, trackFocusVisible({ computed: e4, scope: t }) {
        if (!e4("isDisabled")) return S5({ root: t.getRootNode() });
      }, trackFormControlState({ context: e4, send: t, scope: i }) {
        return lo(h4(i), { onFieldsetDisabledChange(s) {
          e4.set("fieldsetDisabled", s);
        }, onFormReset() {
          let s = e4.initial("checked");
          t({ type: "CHECKED.SET", checked: !!s, src: "form-reset" });
        } });
      } }, actions: { setContext({ context: e4, event: t }) {
        for (let i in t.context) e4.set(i, t.context[i]);
      }, syncInputElement({ context: e4, scope: t }) {
        let i = h4(t);
        i && cn(i, !!e4.get("checked"));
      }, removeFocusIfNeeded({ context: e4, prop: t }) {
        t("disabled") && e4.set("focused", false);
      }, setChecked({ context: e4, event: t }) {
        e4.set("checked", t.checked);
      }, toggleChecked({ context: e4 }) {
        e4.set("checked", !e4.get("checked"));
      }, dispatchChangeEvent({ context: e4, scope: t }) {
        queueMicrotask(() => {
          let i = h4(t);
          uo(i, { checked: e4.get("checked") });
        });
      } } } };
      U9 = As()(["checked", "defaultChecked", "dir", "disabled", "form", "getRootNode", "id", "ids", "invalid", "label", "name", "onCheckedChange", "readOnly", "required", "value"]);
      ie9 = as(U9);
      k13 = class extends ve {
        initMachine(t) {
          return new Ls(A10, t);
        }
        initApi() {
          return x10(this.machine.service, Cs);
        }
        render() {
          let t = this.el.querySelector('[data-scope="switch"][data-part="root"]');
          if (!t) return;
          this.spreadProps(t, this.api.getRootProps());
          let i = this.el.querySelector('[data-scope="switch"][data-part="hidden-input"]');
          i && this.spreadProps(i, this.api.getHiddenInputProps());
          let s = this.el.querySelector('[data-scope="switch"][data-part="label"]');
          s && this.spreadProps(s, this.api.getLabelProps());
          let a3 = this.el.querySelector('[data-scope="switch"][data-part="control"]');
          a3 && this.spreadProps(a3, this.api.getControlProps());
          let r3 = this.el.querySelector('[data-scope="switch"][data-part="thumb"]');
          r3 && this.spreadProps(r3, this.api.getThumbProps());
        }
      };
      le9 = { mounted() {
        let e4 = this.el, t = this.pushEvent.bind(this);
        this.wasFocused = false;
        let i = new k13(e4, __spreadProps(__spreadValues({ id: e4.id }, _r(e4, "controlled") ? { checked: _r(e4, "checked") } : { defaultChecked: _r(e4, "defaultChecked") }), { disabled: _r(e4, "disabled"), name: xr(e4, "name"), form: xr(e4, "form"), value: xr(e4, "value"), dir: xr(e4, "dir", ["ltr", "rtl"]), invalid: _r(e4, "invalid"), required: _r(e4, "required"), readOnly: _r(e4, "readOnly"), label: xr(e4, "label"), onCheckedChange: (s) => {
          let a3 = xr(e4, "onCheckedChange");
          a3 && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected() && t(a3, { checked: s.checked, id: e4.id });
          let r3 = xr(e4, "onCheckedChangeClient");
          r3 && e4.dispatchEvent(new CustomEvent(r3, { bubbles: true, detail: { value: s, id: e4.id } }));
        } }));
        i.init(), this.zagSwitch = i, this.onSetChecked = (s) => {
          let { value: a3 } = s.detail;
          i.api.setChecked(a3);
        }, e4.addEventListener("phx:switch:set-checked", this.onSetChecked), this.handlers = [], this.handlers.push(this.handleEvent("switch_set_checked", (s) => {
          let a3 = s.id;
          a3 && a3 !== e4.id || i.api.setChecked(s.value);
        })), this.handlers.push(this.handleEvent("switch_toggle_checked", (s) => {
          let a3 = s.id;
          a3 && a3 !== e4.id || i.api.toggleChecked();
        })), this.handlers.push(this.handleEvent("switch_checked", () => {
          this.pushEvent("switch_checked_response", { value: i.api.checked });
        })), this.handlers.push(this.handleEvent("switch_focused", () => {
          this.pushEvent("switch_focused_response", { value: i.api.focused });
        })), this.handlers.push(this.handleEvent("switch_disabled", () => {
          this.pushEvent("switch_disabled_response", { value: i.api.disabled });
        }));
      }, beforeUpdate() {
        var _a2, _b;
        this.wasFocused = (_b = (_a2 = this.zagSwitch) == null ? void 0 : _a2.api.focused) != null ? _b : false;
      }, updated() {
        var _a2, _b;
        (_a2 = this.zagSwitch) == null ? void 0 : _a2.updateProps(__spreadProps(__spreadValues({ id: this.el.id }, _r(this.el, "controlled") ? { checked: _r(this.el, "checked") } : { defaultChecked: _r(this.el, "defaultChecked") }), { disabled: _r(this.el, "disabled"), name: xr(this.el, "name"), form: xr(this.el, "form"), value: xr(this.el, "value"), dir: xr(this.el, "dir", ["ltr", "rtl"]), invalid: _r(this.el, "invalid"), required: _r(this.el, "required"), readOnly: _r(this.el, "readOnly"), label: xr(this.el, "label") })), _r(this.el, "controlled") && this.wasFocused && ((_b = this.el.querySelector('[data-part="hidden-input"]')) == null ? void 0 : _b.focus());
      }, destroyed() {
        var _a2;
        if (this.onSetChecked && this.el.removeEventListener("phx:switch:set-checked", this.onSetChecked), this.handlers) for (let e4 of this.handlers) this.removeHandleEvent(e4);
        (_a2 = this.zagSwitch) == null ? void 0 : _a2.destroy();
      } };
    }
  });

  // ../priv/static/tabs.mjs
  var tabs_exports = {};
  __export(tabs_exports, {
    Tabs: () => Be8
  });
  function se9(e4, t) {
    let { state: o2, send: a3, context: s, prop: i, scope: n } = e4, l4 = i("translations"), d4 = o2.matches("focused"), g7 = i("orientation") === "vertical", h6 = i("orientation") === "horizontal", S13 = i("composite");
    function L13(r3) {
      return { selected: s.get("value") === r3.value, focused: s.get("focusedValue") === r3.value, disabled: !!r3.disabled };
    }
    return { value: s.get("value"), focusedValue: s.get("focusedValue"), setValue(r3) {
      a3({ type: "SET_VALUE", value: r3 });
    }, clearValue() {
      a3({ type: "CLEAR_VALUE" });
    }, setIndicatorRect(r3) {
      let u3 = m3(n, r3);
      a3({ type: "SET_INDICATOR_RECT", id: u3 });
    }, syncTabIndex() {
      a3({ type: "SYNC_TAB_INDEX" });
    }, selectNext(r3) {
      a3({ type: "TAB_FOCUS", value: r3, src: "selectNext" }), a3({ type: "ARROW_NEXT", src: "selectNext" });
    }, selectPrev(r3) {
      a3({ type: "TAB_FOCUS", value: r3, src: "selectPrev" }), a3({ type: "ARROW_PREV", src: "selectPrev" });
    }, focus() {
      var _a2;
      let r3 = s.get("value");
      r3 && ((_a2 = R6(n, r3)) == null ? void 0 : _a2.focus());
    }, getRootProps() {
      return t.element(__spreadProps(__spreadValues({}, V14.root.attrs), { id: ne8(n), "data-orientation": i("orientation"), "data-focus": jr(d4), dir: i("dir") }));
    }, getListProps() {
      return t.element(__spreadProps(__spreadValues({}, V14.list.attrs), { id: C14(n), role: "tablist", dir: i("dir"), "data-focus": jr(d4), "aria-orientation": i("orientation"), "data-orientation": i("orientation"), "aria-label": l4 == null ? void 0 : l4.listLabel, onKeyDown(r3) {
        if (r3.defaultPrevented || to(r3) || !Ie(r3.currentTarget, Je(r3))) return;
        let u3 = { ArrowDown() {
          h6 || a3({ type: "ARROW_NEXT", key: "ArrowDown" });
        }, ArrowUp() {
          h6 || a3({ type: "ARROW_PREV", key: "ArrowUp" });
        }, ArrowLeft() {
          g7 || a3({ type: "ARROW_PREV", key: "ArrowLeft" });
        }, ArrowRight() {
          g7 || a3({ type: "ARROW_NEXT", key: "ArrowRight" });
        }, Home() {
          a3({ type: "HOME" });
        }, End() {
          a3({ type: "END" });
        } }, f4 = io(r3, { dir: i("dir"), orientation: i("orientation") }), v10 = u3[f4];
        if (v10) {
          r3.preventDefault(), v10(r3);
          return;
        }
      } }));
    }, getTriggerState: L13, getTriggerProps(r3) {
      let { value: u3, disabled: f4 } = r3, v10 = L13(r3);
      return t.button(__spreadProps(__spreadValues({}, V14.trigger.attrs), { role: "tab", type: "button", disabled: f4, dir: i("dir"), "data-orientation": i("orientation"), "data-disabled": jr(f4), "aria-disabled": f4, "data-value": u3, "aria-selected": v10.selected, "data-selected": jr(v10.selected), "data-focus": jr(v10.focused), "aria-controls": v10.selected ? P10(n, u3) : void 0, "data-ownedby": C14(n), "data-ssr": jr(s.get("ssr")), id: m3(n, u3), tabIndex: v10.selected && S13 ? 0 : -1, onFocus() {
        a3({ type: "TAB_FOCUS", value: u3 });
      }, onBlur(y11) {
        var _a2;
        ((_a2 = y11.relatedTarget) == null ? void 0 : _a2.getAttribute("role")) !== "tab" && a3({ type: "TAB_BLUR" });
      }, onClick(y11) {
        y11.defaultPrevented || Zr(y11) || f4 || (Xr() && y11.currentTarget.focus(), a3({ type: "TAB_CLICK", value: u3 }));
      } }));
    }, getContentProps(r3) {
      let { value: u3 } = r3, f4 = s.get("value") === u3;
      return t.element(__spreadProps(__spreadValues({}, V14.content.attrs), { dir: i("dir"), id: P10(n, u3), tabIndex: S13 ? 0 : -1, "aria-labelledby": m3(n, u3), role: "tabpanel", "data-ownedby": C14(n), "data-selected": jr(f4), "data-orientation": i("orientation"), hidden: !f4 }));
    }, getIndicatorProps() {
      let r3 = s.get("indicatorRect"), u3 = r3 == null || r3.width === 0 && r3.height === 0 && r3.x === 0 && r3.y === 0;
      return t.element(__spreadProps(__spreadValues({ id: ae9(n) }, V14.indicator.attrs), { dir: i("dir"), "data-orientation": i("orientation"), hidden: u3, style: { "--transition-property": "left, right, top, bottom, width, height", "--left": is(r3 == null ? void 0 : r3.x), "--top": is(r3 == null ? void 0 : r3.y), "--width": is(r3 == null ? void 0 : r3.width), "--height": is(r3 == null ? void 0 : r3.height), position: "absolute", willChange: "var(--transition-property)", transitionProperty: "var(--transition-property)", transitionDuration: "var(--transition-duration, 150ms)", transitionTimingFunction: "var(--transition-timing-function)", [h6 ? "left" : "top"]: h6 ? "var(--left)" : "var(--top)" } }));
    } };
  }
  var re9, V14, ne8, C14, P10, m3, ae9, le10, ue8, R6, te8, E13, ce8, de10, ge8, fe9, oe8, ve6, pe10, ie10, he9, Ie8, be8, Re7, me8, _e8, _10, Be8;
  var init_tabs = __esm({
    "../priv/static/tabs.mjs"() {
      "use strict";
      init_chunk_IYURAQ6S();
      re9 = G("tabs").parts("root", "list", "trigger", "content", "indicator");
      V14 = re9.build();
      ne8 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.root) != null ? _b : `tabs:${e4.id}`;
      };
      C14 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.list) != null ? _b : `tabs:${e4.id}:list`;
      };
      P10 = (e4, t) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = e4.ids) == null ? void 0 : _a2.content) == null ? void 0 : _b.call(_a2, t)) != null ? _c : `tabs:${e4.id}:content-${t}`;
      };
      m3 = (e4, t) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = e4.ids) == null ? void 0 : _a2.trigger) == null ? void 0 : _b.call(_a2, t)) != null ? _c : `tabs:${e4.id}:trigger-${t}`;
      };
      ae9 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.indicator) != null ? _b : `tabs:${e4.id}:indicator`;
      };
      le10 = (e4) => e4.getById(C14(e4));
      ue8 = (e4, t) => e4.getById(P10(e4, t));
      R6 = (e4, t) => t != null ? e4.getById(m3(e4, t)) : null;
      te8 = (e4) => e4.getById(ae9(e4));
      E13 = (e4) => {
        let o2 = `[role=tab][data-ownedby='${CSS.escape(C14(e4))}']:not([disabled])`;
        return Po(le10(e4), o2);
      };
      ce8 = (e4) => Io(E13(e4));
      de10 = (e4) => Wn(E13(e4));
      ge8 = (e4, t) => To(E13(e4), m3(e4, t.value), t.loopFocus);
      fe9 = (e4, t) => Oo(E13(e4), m3(e4, t.value), t.loopFocus);
      oe8 = (e4) => {
        var _a2, _b, _c, _d;
        return { x: (_a2 = e4 == null ? void 0 : e4.offsetLeft) != null ? _a2 : 0, y: (_b = e4 == null ? void 0 : e4.offsetTop) != null ? _b : 0, width: (_c = e4 == null ? void 0 : e4.offsetWidth) != null ? _c : 0, height: (_d = e4 == null ? void 0 : e4.offsetHeight) != null ? _d : 0 };
      };
      ve6 = (e4, t) => {
        let o2 = kn(E13(e4), m3(e4, t));
        return oe8(o2);
      };
      ({ createMachine: pe10 } = ws());
      ie10 = pe10({ props({ props: e4 }) {
        return __spreadValues({ dir: "ltr", orientation: "horizontal", activationMode: "automatic", loopFocus: true, composite: true, navigate(t) {
          yo(t.node);
        }, defaultValue: null }, e4);
      }, initialState() {
        return "idle";
      }, context({ prop: e4, bindable: t }) {
        return { value: t(() => ({ defaultValue: e4("defaultValue"), value: e4("value"), onChange(o2) {
          var _a2;
          (_a2 = e4("onValueChange")) == null ? void 0 : _a2({ value: o2 });
        } })), focusedValue: t(() => ({ defaultValue: e4("value") || e4("defaultValue"), sync: true, onChange(o2) {
          var _a2;
          (_a2 = e4("onFocusChange")) == null ? void 0 : _a2({ focusedValue: o2 });
        } })), ssr: t(() => ({ defaultValue: true })), indicatorRect: t(() => ({ defaultValue: null })) };
      }, watch({ context: e4, prop: t, track: o2, action: a3 }) {
        o2([() => e4.get("value")], () => {
          a3(["syncIndicatorRect", "syncTabIndex", "navigateIfNeeded"]);
        }), o2([() => t("dir"), () => t("orientation")], () => {
          a3(["syncIndicatorRect"]);
        });
      }, on: { SET_VALUE: { actions: ["setValue"] }, CLEAR_VALUE: { actions: ["clearValue"] }, SET_INDICATOR_RECT: { actions: ["setIndicatorRect"] }, SYNC_TAB_INDEX: { actions: ["syncTabIndex"] } }, entry: ["syncIndicatorRect", "syncTabIndex", "syncSsr"], exit: ["cleanupObserver"], states: { idle: { on: { TAB_FOCUS: { target: "focused", actions: ["setFocusedValue"] }, TAB_CLICK: { target: "focused", actions: ["setFocusedValue", "setValue"] } } }, focused: { on: { TAB_CLICK: { actions: ["setFocusedValue", "setValue"] }, ARROW_PREV: [{ guard: "selectOnFocus", actions: ["focusPrevTab", "selectFocusedTab"] }, { actions: ["focusPrevTab"] }], ARROW_NEXT: [{ guard: "selectOnFocus", actions: ["focusNextTab", "selectFocusedTab"] }, { actions: ["focusNextTab"] }], HOME: [{ guard: "selectOnFocus", actions: ["focusFirstTab", "selectFocusedTab"] }, { actions: ["focusFirstTab"] }], END: [{ guard: "selectOnFocus", actions: ["focusLastTab", "selectFocusedTab"] }, { actions: ["focusLastTab"] }], TAB_FOCUS: { actions: ["setFocusedValue"] }, TAB_BLUR: { target: "idle", actions: ["clearFocusedValue"] } } } }, implementations: { guards: { selectOnFocus: ({ prop: e4 }) => e4("activationMode") === "automatic" }, actions: { selectFocusedTab({ context: e4, prop: t }) {
        nt(() => {
          let o2 = e4.get("focusedValue");
          if (!o2) return;
          let s = t("deselectable") && e4.get("value") === o2 ? null : o2;
          e4.set("value", s);
        });
      }, setFocusedValue({ context: e4, event: t, flush: o2 }) {
        t.value != null && o2(() => {
          e4.set("focusedValue", t.value);
        });
      }, clearFocusedValue({ context: e4 }) {
        e4.set("focusedValue", null);
      }, setValue({ context: e4, event: t, prop: o2 }) {
        let a3 = o2("deselectable") && e4.get("value") === e4.get("focusedValue");
        e4.set("value", a3 ? null : t.value);
      }, clearValue({ context: e4 }) {
        e4.set("value", null);
      }, focusFirstTab({ scope: e4 }) {
        nt(() => {
          var _a2;
          (_a2 = ce8(e4)) == null ? void 0 : _a2.focus();
        });
      }, focusLastTab({ scope: e4 }) {
        nt(() => {
          var _a2;
          (_a2 = de10(e4)) == null ? void 0 : _a2.focus();
        });
      }, focusNextTab({ context: e4, prop: t, scope: o2, event: a3 }) {
        var _a2;
        let s = (_a2 = a3.value) != null ? _a2 : e4.get("focusedValue");
        if (!s) return;
        let i = ge8(o2, { value: s, loopFocus: t("loopFocus") });
        nt(() => {
          t("composite") ? i == null ? void 0 : i.focus() : (i == null ? void 0 : i.dataset.value) != null && e4.set("focusedValue", i.dataset.value);
        });
      }, focusPrevTab({ context: e4, prop: t, scope: o2, event: a3 }) {
        var _a2;
        let s = (_a2 = a3.value) != null ? _a2 : e4.get("focusedValue");
        if (!s) return;
        let i = fe9(o2, { value: s, loopFocus: t("loopFocus") });
        nt(() => {
          t("composite") ? i == null ? void 0 : i.focus() : (i == null ? void 0 : i.dataset.value) != null && e4.set("focusedValue", i.dataset.value);
        });
      }, syncTabIndex({ context: e4, scope: t }) {
        nt(() => {
          let o2 = e4.get("value");
          if (!o2) return;
          let a3 = ue8(t, o2);
          if (!a3) return;
          mn(a3).length > 0 ? a3.removeAttribute("tabindex") : a3.setAttribute("tabindex", "0");
        });
      }, cleanupObserver({ refs: e4 }) {
        let t = e4.get("indicatorCleanup");
        t && t();
      }, setIndicatorRect({ context: e4, event: t, scope: o2 }) {
        var _a2;
        let a3 = (_a2 = t.id) != null ? _a2 : e4.get("value");
        !te8(o2) || !a3 || !R6(o2, a3) || e4.set("indicatorRect", ve6(o2, a3));
      }, syncSsr({ context: e4 }) {
        e4.set("ssr", false);
      }, syncIndicatorRect({ context: e4, refs: t, scope: o2 }) {
        let a3 = t.get("indicatorCleanup");
        if (a3 && a3(), !te8(o2)) return;
        let i = () => {
          let d4 = R6(o2, e4.get("value"));
          if (!d4) return;
          let g7 = oe8(d4);
          e4.set("indicatorRect", (h6) => V(h6, g7) ? h6 : g7);
        };
        i();
        let n = E13(o2), l4 = re(...n.map((d4) => Ro.observe(d4, i)));
        t.set("indicatorCleanup", l4);
      }, navigateIfNeeded({ context: e4, prop: t, scope: o2 }) {
        var _a2;
        let a3 = e4.get("value");
        if (!a3) return;
        let s = R6(o2, a3);
        $r(s) && ((_a2 = t("navigate")) == null ? void 0 : _a2({ value: a3, node: s, href: s.href }));
      } } } });
      he9 = As()(["activationMode", "composite", "deselectable", "dir", "getRootNode", "id", "ids", "loopFocus", "navigate", "onFocusChange", "onValueChange", "orientation", "translations", "value", "defaultValue"]);
      Ie8 = as(he9);
      be8 = As()(["disabled", "value"]);
      Re7 = as(be8);
      me8 = As()(["value"]);
      _e8 = as(me8);
      _10 = class extends ve {
        initMachine(t) {
          return new Ls(ie10, t);
        }
        initApi() {
          return se9(this.machine.service, Cs);
        }
        render() {
          let t = this.el.querySelector('[data-scope="tabs"][data-part="root"]');
          if (!t) return;
          this.spreadProps(t, this.api.getRootProps());
          let o2 = t.querySelector('[data-scope="tabs"][data-part="list"]');
          if (!o2) return;
          this.spreadProps(o2, this.api.getListProps());
          let a3 = this.el.getAttribute("data-items"), s = a3 ? JSON.parse(a3) : [], i = o2.querySelectorAll('[data-scope="tabs"][data-part="trigger"]');
          for (let l4 = 0; l4 < i.length && l4 < s.length; l4++) {
            let d4 = i[l4], g7 = s[l4];
            this.spreadProps(d4, this.api.getTriggerProps({ value: g7.value, disabled: g7.disabled }));
          }
          let n = t.querySelectorAll('[data-scope="tabs"][data-part="content"]');
          for (let l4 = 0; l4 < n.length && l4 < s.length; l4++) {
            let d4 = n[l4], g7 = s[l4];
            this.spreadProps(d4, this.api.getContentProps({ value: g7.value }));
          }
        }
      };
      Be8 = { mounted() {
        let e4 = this.el, t = this.pushEvent.bind(this), o2 = new _10(e4, __spreadProps(__spreadValues({ id: e4.id }, _r(e4, "controlled") ? { value: xr(e4, "value") } : { defaultValue: xr(e4, "defaultValue") }), { orientation: xr(e4, "orientation", ["horizontal", "vertical"]), dir: xr(e4, "dir", ["ltr", "rtl"]), onValueChange: (a3) => {
          var _a2, _b;
          let s = xr(e4, "onValueChange");
          s && this.liveSocket.main.isConnected() && t(s, { id: e4.id, value: (_a2 = a3.value) != null ? _a2 : null });
          let i = xr(e4, "onValueChangeClient");
          i && e4.dispatchEvent(new CustomEvent(i, { bubbles: true, detail: { id: e4.id, value: (_b = a3.value) != null ? _b : null } }));
        }, onFocusChange: (a3) => {
          var _a2, _b;
          let s = xr(e4, "onFocusChange");
          s && this.liveSocket.main.isConnected() && t(s, { id: e4.id, value: (_a2 = a3.focusedValue) != null ? _a2 : null });
          let i = xr(e4, "onFocusChangeClient");
          i && e4.dispatchEvent(new CustomEvent(i, { bubbles: true, detail: { id: e4.id, value: (_b = a3.focusedValue) != null ? _b : null } }));
        } }));
        o2.init(), this.tabs = o2, this.onSetValue = (a3) => {
          let { value: s } = a3.detail;
          o2.api.setValue(s);
        }, e4.addEventListener("phx:tabs:set-value", this.onSetValue), this.handlers = [], this.handlers.push(this.handleEvent("tabs_set_value", (a3) => {
          let s = a3.tabs_id;
          s && s !== e4.id || o2.api.setValue(a3.value);
        })), this.handlers.push(this.handleEvent("tabs_value", () => {
          this.pushEvent("tabs_value_response", { value: o2.api.value });
        })), this.handlers.push(this.handleEvent("tabs_focused_value", () => {
          this.pushEvent("tabs_focused_value_response", { value: o2.api.focusedValue });
        }));
      }, updated() {
        var _a2;
        (_a2 = this.tabs) == null ? void 0 : _a2.updateProps(__spreadProps(__spreadValues({ id: this.el.id }, _r(this.el, "controlled") ? { value: xr(this.el, "value") } : { defaultValue: xr(this.el, "defaultValue") }), { orientation: xr(this.el, "orientation", ["horizontal", "vertical"]), dir: xr(this.el, "dir", ["ltr", "rtl"]) }));
      }, destroyed() {
        var _a2;
        if (this.onSetValue && this.el.removeEventListener("phx:tabs:set-value", this.onSetValue), this.handlers) for (let e4 of this.handlers) this.removeHandleEvent(e4);
        (_a2 = this.tabs) == null ? void 0 : _a2.destroy();
      } };
    }
  });

  // ../priv/static/timer.mjs
  var timer_exports = {};
  __export(timer_exports, {
    Timer: () => rt8
  });
  function C15(e4, t) {
    let { state: r3, send: a3, computed: s, scope: c5 } = e4, i = r3.matches("running"), o2 = r3.matches("paused"), l4 = s("time"), u3 = s("formattedTime"), g7 = s("progressPercent");
    return { running: i, paused: o2, time: l4, formattedTime: u3, progressPercent: g7, start() {
      a3({ type: "START" });
    }, pause() {
      a3({ type: "PAUSE" });
    }, resume() {
      a3({ type: "RESUME" });
    }, reset() {
      a3({ type: "RESET" });
    }, restart() {
      a3({ type: "RESTART" });
    }, getRootProps() {
      return t.element(__spreadValues({ id: N9(c5) }, m4.root.attrs));
    }, getAreaProps() {
      return t.element(__spreadValues({ role: "timer", id: x11(c5), "aria-label": `${l4.days} days ${u3.hours}:${u3.minutes}:${u3.seconds}`, "aria-atomic": true }, m4.area.attrs));
    }, getControlProps() {
      return t.element(__spreadValues({}, m4.control.attrs));
    }, getItemProps(n) {
      let T7 = l4[n.type];
      return t.element(__spreadProps(__spreadValues({}, m4.item.attrs), { "data-type": n.type, style: { "--value": T7 } }));
    }, getItemLabelProps(n) {
      return t.element(__spreadProps(__spreadValues({}, m4.itemLabel.attrs), { "data-type": n.type }));
    }, getItemValueProps(n) {
      return t.element(__spreadProps(__spreadValues({}, m4.itemValue.attrs), { "data-type": n.type }));
    }, getSeparatorProps() {
      return t.element(__spreadValues({ "aria-hidden": true }, m4.separator.attrs));
    }, getActionTriggerProps(n) {
      if (!A11.has(n.action)) throw new Error(`[zag-js] Invalid action: ${n.action}. Must be one of: ${Array.from(A11).join(", ")}`);
      return t.button(__spreadProps(__spreadValues({}, m4.actionTrigger.attrs), { hidden: rr(n.action, { start: () => i || o2, pause: () => !i, reset: () => !i && !o2, resume: () => !o2, restart: () => false }), type: "button", onClick(T7) {
        T7.defaultPrevented || a3({ type: n.action.toUpperCase() });
      } }));
    } };
  }
  function q12(e4) {
    let t = Math.max(0, e4), r3 = t % 1e3, a3 = Math.floor(t / 1e3) % 60, s = Math.floor(t / (1e3 * 60)) % 60, c5 = Math.floor(t / (1e3 * 60 * 60)) % 24;
    return { days: Math.floor(t / (1e3 * 60 * 60 * 24)), hours: c5, minutes: s, seconds: a3, milliseconds: r3 };
  }
  function $11(e4, t, r3) {
    let a3 = r3 - t;
    return a3 === 0 ? 0 : (e4 - t) / a3;
  }
  function h5(e4, t = 2) {
    return e4.toString().padStart(t, "0");
  }
  function O9(e4, t) {
    return Math.floor(e4 / t) * t;
  }
  function V15(e4) {
    let { days: t, hours: r3, minutes: a3, seconds: s } = e4;
    return { days: h5(t), hours: h5(r3), minutes: h5(a3), seconds: h5(s), milliseconds: h5(e4.milliseconds, 3) };
  }
  function U10(e4) {
    let { startMs: t, targetMs: r3, countdown: a3, interval: s } = e4;
    if (s != null && (typeof s != "number" || s <= 0)) throw new Error(`[timer] Invalid interval: ${s}. Must be a positive number.`);
    if (t != null && (typeof t != "number" || t < 0)) throw new Error(`[timer] Invalid startMs: ${t}. Must be a non-negative number.`);
    if (r3 != null && (typeof r3 != "number" || r3 < 0)) throw new Error(`[timer] Invalid targetMs: ${r3}. Must be a non-negative number.`);
    if (a3 && t != null && r3 != null && t <= r3) throw new Error(`[timer] Invalid countdown configuration: startMs (${t}) must be greater than targetMs (${r3}).`);
    if (!a3 && t != null && r3 != null && t >= r3) throw new Error(`[timer] Invalid stopwatch configuration: startMs (${t}) must be less than targetMs (${r3}).`);
    if (a3 && r3 == null && t != null && t <= 0) throw new Error(`[timer] Invalid countdown configuration: startMs (${t}) must be greater than 0 when no targetMs is provided.`);
  }
  var j10, m4, N9, x11, A11, L12, D10, Q15, f3, rt8;
  var init_timer = __esm({
    "../priv/static/timer.mjs"() {
      "use strict";
      init_chunk_IYURAQ6S();
      j10 = G("timer").parts("root", "area", "control", "item", "itemValue", "itemLabel", "actionTrigger", "separator");
      m4 = j10.build();
      N9 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.root) != null ? _b : `timer:${e4.id}:root`;
      };
      x11 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.area) != null ? _b : `timer:${e4.id}:area`;
      };
      A11 = /* @__PURE__ */ new Set(["start", "pause", "resume", "reset", "restart"]);
      L12 = { props({ props: e4 }) {
        return U10(e4), __spreadValues({ interval: 1e3, startMs: 0 }, e4);
      }, initialState({ prop: e4 }) {
        return e4("autoStart") ? "running" : "idle";
      }, context({ prop: e4, bindable: t }) {
        return { currentMs: t(() => ({ defaultValue: e4("startMs") })) };
      }, watch({ track: e4, send: t, prop: r3 }) {
        e4([() => r3("startMs")], () => {
          t({ type: "RESTART" });
        });
      }, on: { RESTART: { target: "running:temp", actions: ["resetTime"] } }, computed: { time: ({ context: e4 }) => q12(e4.get("currentMs")), formattedTime: ({ computed: e4 }) => V15(e4("time")), progressPercent: vs(({ context: e4, prop: t }) => [e4.get("currentMs"), t("targetMs"), t("startMs"), t("countdown")], ([e4, t = 0, r3, a3]) => {
        let s = a3 ? $11(e4, t, r3) : $11(e4, r3, t);
        return ts(s, 0, 1);
      }) }, states: { idle: { on: { START: { target: "running" }, RESET: { actions: ["resetTime"] } } }, "running:temp": { effects: ["waitForNextTick"], on: { CONTINUE: { target: "running" } } }, running: { effects: ["keepTicking"], on: { PAUSE: { target: "paused" }, TICK: [{ target: "idle", guard: "hasReachedTarget", actions: ["invokeOnComplete"] }, { actions: ["updateTime", "invokeOnTick"] }], RESET: { actions: ["resetTime"] } } }, paused: { on: { RESUME: { target: "running" }, RESET: { target: "idle", actions: ["resetTime"] } } } }, implementations: { effects: { keepTicking({ prop: e4, send: t }) {
        return us(({ deltaMs: r3 }) => {
          t({ type: "TICK", deltaMs: r3 });
        }, e4("interval"));
      }, waitForNextTick({ send: e4 }) {
        return ls(() => {
          e4({ type: "CONTINUE" });
        }, 0);
      } }, actions: { updateTime({ context: e4, prop: t, event: r3 }) {
        let a3 = t("countdown") ? -1 : 1, s = O9(r3.deltaMs, t("interval"));
        e4.set("currentMs", (c5) => {
          let i = c5 + a3 * s, o2 = t("targetMs");
          return o2 == null && t("countdown") && (o2 = 0), t("countdown") && o2 != null ? Math.max(i, o2) : !t("countdown") && o2 != null ? Math.min(i, o2) : i;
        });
      }, resetTime({ context: e4, prop: t }) {
        var _a2;
        let r3 = t("targetMs");
        r3 == null && t("countdown") && (r3 = 0), e4.set("currentMs", (_a2 = t("startMs")) != null ? _a2 : 0);
      }, invokeOnTick({ context: e4, prop: t, computed: r3 }) {
        var _a2;
        (_a2 = t("onTick")) == null ? void 0 : _a2({ value: e4.get("currentMs"), time: r3("time"), formattedTime: r3("formattedTime") });
      }, invokeOnComplete({ prop: e4 }) {
        var _a2;
        (_a2 = e4("onComplete")) == null ? void 0 : _a2();
      } }, guards: { hasReachedTarget: ({ context: e4, prop: t }) => {
        let r3 = t("targetMs");
        if (r3 == null && t("countdown") && (r3 = 0), r3 == null) return false;
        let a3 = e4.get("currentMs");
        return t("countdown") ? a3 <= r3 : a3 >= r3;
      } } } };
      D10 = As()(["autoStart", "countdown", "getRootNode", "id", "ids", "interval", "onComplete", "onTick", "startMs", "targetMs"]);
      Q15 = as(D10);
      f3 = class extends ve {
        initMachine(t) {
          return new Ls(L12, t);
        }
        initApi() {
          return C15(this.machine.service, Cs);
        }
        render() {
          var _a2;
          let t = (_a2 = this.el.querySelector('[data-scope="timer"][data-part="root"]')) != null ? _a2 : this.el;
          this.spreadProps(t, this.api.getRootProps());
          let r3 = this.el.querySelector('[data-scope="timer"][data-part="area"]');
          r3 && this.spreadProps(r3, this.api.getAreaProps());
          let a3 = this.el.querySelector('[data-scope="timer"][data-part="control"]');
          a3 && this.spreadProps(a3, this.api.getControlProps()), ["days", "hours", "minutes", "seconds", "milliseconds"].forEach((o2) => {
            let l4 = this.el.querySelector(`[data-scope="timer"][data-part="item"][data-type="${o2}"]`);
            l4 && this.spreadProps(l4, this.api.getItemProps({ type: o2 }));
            let u3 = this.el.querySelector(`[data-scope="timer"][data-part="item-value"][data-type="${o2}"]`);
            u3 && this.spreadProps(u3, this.api.getItemValueProps({ type: o2 }));
            let g7 = this.el.querySelector(`[data-scope="timer"][data-part="item-label"][data-type="${o2}"]`);
            g7 && this.spreadProps(g7, this.api.getItemLabelProps({ type: o2 }));
          });
          let c5 = this.el.querySelector('[data-scope="timer"][data-part="separator"]');
          c5 && this.spreadProps(c5, this.api.getSeparatorProps()), ["start", "pause", "resume", "reset", "restart"].forEach((o2) => {
            let l4 = this.el.querySelector(`[data-scope="timer"][data-part="action-trigger"][data-action="${o2}"]`);
            l4 && this.spreadProps(l4, this.api.getActionTriggerProps({ action: o2 }));
          });
        }
      };
      rt8 = { mounted() {
        var _a2;
        let e4 = this.el, t = new f3(e4, { id: e4.id, countdown: _r(e4, "countdown"), startMs: Lr(e4, "startMs"), targetMs: Lr(e4, "targetMs"), autoStart: _r(e4, "autoStart"), interval: (_a2 = Lr(e4, "interval")) != null ? _a2 : 1e3, onTick: (r3) => {
          let a3 = xr(e4, "onTick");
          a3 && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected() && this.pushEvent(a3, { value: r3.value, time: r3.time, formattedTime: r3.formattedTime, id: e4.id });
        }, onComplete: () => {
          let r3 = xr(e4, "onComplete");
          r3 && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected() && this.pushEvent(r3, { id: e4.id });
        } });
        t.init(), this.timer = t, this.handlers = [];
      }, updated() {
        var _a2, _b;
        (_b = this.timer) == null ? void 0 : _b.updateProps({ id: this.el.id, countdown: _r(this.el, "countdown"), startMs: Lr(this.el, "startMs"), targetMs: Lr(this.el, "targetMs"), autoStart: _r(this.el, "autoStart"), interval: (_a2 = Lr(this.el, "interval")) != null ? _a2 : 1e3 });
      }, destroyed() {
        var _a2;
        if (this.handlers) for (let e4 of this.handlers) this.removeHandleEvent(e4);
        (_a2 = this.timer) == null ? void 0 : _a2.destroy();
      } };
    }
  });

  // ../priv/static/toast.mjs
  var toast_exports = {};
  __export(toast_exports, {
    Toast: () => se10
  });
  function _11(t, e4) {
    var _a2;
    return (_a2 = t != null ? t : ut8[e4]) != null ? _a2 : ut8.DEFAULT;
  }
  function It7(t, e4) {
    var _a2;
    let { prop: i, computed: s, context: r3 } = t, { offsets: n, gap: l4 } = i("store").attrs, u3 = r3.get("heights"), d4 = bt6(n), y11 = i("dir") === "rtl", g7 = e4.replace("-start", y11 ? "-right" : "-left").replace("-end", y11 ? "-left" : "-right"), a3 = g7.includes("right"), p4 = g7.includes("left"), h6 = { position: "fixed", pointerEvents: s("count") > 0 ? void 0 : "none", display: "flex", flexDirection: "column", "--gap": `${l4}px`, "--first-height": `${((_a2 = u3[0]) == null ? void 0 : _a2.height) || 0}px`, "--viewport-offset-left": d4.left, "--viewport-offset-right": d4.right, "--viewport-offset-top": d4.top, "--viewport-offset-bottom": d4.bottom, zIndex: Fr }, f4 = "center";
    if (a3 && (f4 = "flex-end"), p4 && (f4 = "flex-start"), h6.alignItems = f4, g7.includes("top")) {
      let T7 = d4.top;
      h6.top = `max(env(safe-area-inset-top, 0px), ${T7})`;
    }
    if (g7.includes("bottom")) {
      let T7 = d4.bottom;
      h6.bottom = `max(env(safe-area-inset-bottom, 0px), ${T7})`;
    }
    if (!g7.includes("left")) {
      let T7 = d4.right;
      h6.insetInlineEnd = `calc(env(safe-area-inset-right, 0px) + ${T7})`;
    }
    if (!g7.includes("right")) {
      let T7 = d4.left;
      h6.insetInlineStart = `calc(env(safe-area-inset-left, 0px) + ${T7})`;
    }
    return h6;
  }
  function St4(t, e4) {
    let { prop: i, context: s, computed: r3 } = t, n = i("parent"), l4 = n.computed("placement"), { gap: u3 } = n.prop("store").attrs, [d4] = l4.split("-"), y11 = s.get("mounted"), g7 = s.get("remainingTime"), a3 = r3("height"), p4 = r3("frontmost"), h6 = !p4, f4 = !i("stacked"), T7 = i("stacked"), D11 = i("type") === "loading" ? Number.MAX_SAFE_INTEGER : g7, H12 = r3("heightIndex") * u3 + r3("heightBefore"), O10 = { position: "absolute", pointerEvents: "auto", "--opacity": "0", "--remove-delay": `${i("removeDelay")}ms`, "--duration": `${D11}ms`, "--initial-height": `${a3}px`, "--offset": `${H12}px`, "--index": i("index"), "--z-index": r3("zIndex"), "--lift-amount": "calc(var(--lift) * var(--gap))", "--y": "100%", "--x": "0" }, m5 = (Y16) => Object.assign(O10, Y16);
    return d4 === "top" ? m5({ top: "0", "--sign": "-1", "--y": "-100%", "--lift": "1" }) : d4 === "bottom" && m5({ bottom: "0", "--sign": "1", "--y": "100%", "--lift": "-1" }), y11 && (m5({ "--y": "0", "--opacity": "1" }), T7 && m5({ "--y": "calc(var(--lift) * var(--offset))", "--height": "var(--initial-height)" })), e4 || m5({ "--opacity": "0", pointerEvents: "none" }), h6 && f4 && (m5({ "--base-scale": "var(--index) * 0.05 + 1", "--y": "calc(var(--lift-amount) * var(--index))", "--scale": "calc(-1 * var(--base-scale))", "--height": "var(--first-height)" }), e4 || m5({ "--y": "calc(var(--sign) * 40%)" })), h6 && T7 && !e4 && m5({ "--y": "calc(var(--lift) * var(--offset) + var(--lift) * -100%)" }), p4 && !e4 && m5({ "--y": "calc(var(--lift) * -100%)" }), O10;
  }
  function Pt5(t, e4) {
    let { computed: i } = t, s = { position: "absolute", inset: "0", scale: "1 2", pointerEvents: e4 ? "none" : "auto" }, r3 = (n) => Object.assign(s, n);
    return i("frontmost") && !e4 && r3({ height: "calc(var(--initial-height) + 80%)" }), s;
  }
  function xt6() {
    return { position: "absolute", left: "0", height: "calc(var(--gap) + 2px)", bottom: "100%", width: "100%" };
  }
  function Mt5(t, e4) {
    let { context: i, prop: s, send: r3, refs: n, computed: l4 } = t;
    return { getCount() {
      return i.get("toasts").length;
    }, getToasts() {
      return i.get("toasts");
    }, getGroupProps(u3 = {}) {
      let { label: d4 = "Notifications" } = u3, { hotkey: y11 } = s("store").attrs, g7 = y11.join("+").replace(/Key/g, "").replace(/Digit/g, ""), a3 = l4("placement"), [p4, h6 = "center"] = a3.split("-");
      return e4.element(__spreadProps(__spreadValues({}, x12.group.attrs), { dir: s("dir"), tabIndex: -1, "aria-label": `${a3} ${d4} ${g7}`, id: vt7(a3), "data-placement": a3, "data-side": p4, "data-align": h6, "aria-live": "polite", role: "region", style: It7(t, a3), onMouseEnter() {
        n.get("ignoreMouseTimer").isActive() || r3({ type: "REGION.POINTER_ENTER", placement: a3 });
      }, onMouseMove() {
        n.get("ignoreMouseTimer").isActive() || r3({ type: "REGION.POINTER_ENTER", placement: a3 });
      }, onMouseLeave() {
        n.get("ignoreMouseTimer").isActive() || r3({ type: "REGION.POINTER_LEAVE", placement: a3 });
      }, onFocus(f4) {
        r3({ type: "REGION.FOCUS", target: f4.relatedTarget });
      }, onBlur(f4) {
        n.get("isFocusWithin") && !Ie(f4.currentTarget, f4.relatedTarget) && queueMicrotask(() => r3({ type: "REGION.BLUR" }));
      } }));
    }, subscribe(u3) {
      return s("store").subscribe(() => u3(i.get("toasts")));
    } };
  }
  function gt4(t, e4) {
    let { state: i, send: s, prop: r3, scope: n, context: l4, computed: u3 } = t, d4 = i.hasTag("visible"), y11 = i.hasTag("paused"), g7 = l4.get("mounted"), a3 = u3("frontmost"), p4 = r3("parent").computed("placement"), h6 = r3("type"), f4 = r3("stacked"), T7 = r3("title"), R7 = r3("description"), D11 = r3("action"), [H12, O10 = "center"] = p4.split("-");
    return { type: h6, title: T7, description: R7, placement: p4, visible: d4, paused: y11, closable: !!r3("closable"), pause() {
      s({ type: "PAUSE" });
    }, resume() {
      s({ type: "RESUME" });
    }, dismiss() {
      s({ type: "DISMISS", src: "programmatic" });
    }, getRootProps() {
      return e4.element(__spreadProps(__spreadValues({}, x12.root.attrs), { dir: r3("dir"), id: pt5(n), "data-state": d4 ? "open" : "closed", "data-type": h6, "data-placement": p4, "data-align": O10, "data-side": H12, "data-mounted": jr(g7), "data-paused": jr(y11), "data-first": jr(a3), "data-sibling": jr(!a3), "data-stack": jr(f4), "data-overlap": jr(!f4), role: "status", "aria-atomic": "true", "aria-describedby": R7 ? lt6(n) : void 0, "aria-labelledby": T7 ? ct7(n) : void 0, tabIndex: 0, style: St4(t, d4), onKeyDown(m5) {
        m5.defaultPrevented || m5.key == "Escape" && (s({ type: "DISMISS", src: "keyboard" }), m5.preventDefault());
      } }));
    }, getGhostBeforeProps() {
      return e4.element({ "data-ghost": "before", style: Pt5(t, d4) });
    }, getGhostAfterProps() {
      return e4.element({ "data-ghost": "after", style: xt6() });
    }, getTitleProps() {
      return e4.element(__spreadProps(__spreadValues({}, x12.title.attrs), { id: ct7(n) }));
    }, getDescriptionProps() {
      return e4.element(__spreadProps(__spreadValues({}, x12.description.attrs), { id: lt6(n) }));
    }, getActionTriggerProps() {
      return e4.button(__spreadProps(__spreadValues({}, x12.actionTrigger.attrs), { type: "button", onClick(m5) {
        var _a2;
        m5.defaultPrevented || ((_a2 = D11 == null ? void 0 : D11.onClick) == null ? void 0 : _a2.call(D11), s({ type: "DISMISS", src: "user" }));
      } }));
    }, getCloseTriggerProps() {
      return e4.button(__spreadProps(__spreadValues({ id: Et4(n) }, x12.closeTrigger.attrs), { type: "button", "aria-label": "Dismiss notification", onClick(m5) {
        m5.defaultPrevented || s({ type: "DISMISS", src: "user" });
      } }));
    } };
  }
  function dt5(t, e4) {
    let { id: i, height: s } = e4;
    t.context.set("heights", (r3) => r3.find((l4) => l4.id === i) ? r3.map((l4) => l4.id === i ? __spreadProps(__spreadValues({}, l4), { height: s }) : l4) : [{ id: i, height: s }, ...r3]);
  }
  function mt5(t = {}) {
    let e4 = Ht5(t, { placement: "bottom", overlap: false, max: 24, gap: 16, offsets: "1rem", hotkey: ["altKey", "KeyT"], removeDelay: 200, pauseOnPageIdle: true }), i = [], s = [], r3 = /* @__PURE__ */ new Set(), n = [], l4 = (o2) => (i.push(o2), () => {
      let c5 = i.indexOf(o2);
      i.splice(c5, 1);
    }), u3 = (o2) => (i.forEach((c5) => c5(o2)), o2), d4 = (o2) => {
      if (s.length >= e4.max) {
        n.push(o2);
        return;
      }
      u3(o2), s.unshift(o2);
    }, y11 = () => {
      for (; n.length > 0 && s.length < e4.max; ) {
        let o2 = n.shift();
        o2 && (u3(o2), s.unshift(o2));
      }
    }, g7 = (o2) => {
      var _a2;
      let c5 = (_a2 = o2.id) != null ? _a2 : `toast:${Yo()}`, b10 = s.find((v10) => v10.id === c5);
      return r3.has(c5) && r3.delete(c5), b10 ? s = s.map((v10) => v10.id === c5 ? u3(__spreadProps(__spreadValues(__spreadValues({}, v10), o2), { id: c5 })) : v10) : d4(__spreadProps(__spreadValues({ id: c5, duration: e4.duration, removeDelay: e4.removeDelay, type: "info" }, o2), { stacked: !e4.overlap, gap: e4.gap })), c5;
    }, a3 = (o2) => (r3.add(o2), o2 ? (i.forEach((c5) => c5({ id: o2, dismiss: true })), s = s.filter((c5) => c5.id !== o2), y11()) : (s.forEach((c5) => {
      i.forEach((b10) => b10({ id: c5.id, dismiss: true }));
    }), s = [], n = []), o2);
    return { attrs: e4, subscribe: l4, create: g7, update: (o2, c5) => g7(__spreadValues({ id: o2 }, c5)), remove: a3, dismiss: (o2) => {
      o2 != null ? s = s.map((c5) => c5.id === o2 ? u3(__spreadProps(__spreadValues({}, c5), { message: "DISMISS" })) : c5) : s = s.map((c5) => u3(__spreadProps(__spreadValues({}, c5), { message: "DISMISS" })));
    }, error: (o2) => g7(__spreadProps(__spreadValues({}, o2), { type: "error" })), success: (o2) => g7(__spreadProps(__spreadValues({}, o2), { type: "success" })), info: (o2) => g7(__spreadProps(__spreadValues({}, o2), { type: "info" })), warning: (o2) => g7(__spreadProps(__spreadValues({}, o2), { type: "warning" })), loading: (o2) => g7(__spreadProps(__spreadValues({}, o2), { type: "loading" })), getVisibleToasts: () => s.filter((o2) => !r3.has(o2.id)), getCount: () => s.length, promise: (o2, c5, b10 = {}) => {
      if (!c5 || !c5.loading) {
        Mt("[zag-js > toast] toaster.promise() requires at least a 'loading' option to be specified");
        return;
      }
      let v10 = g7(__spreadProps(__spreadValues(__spreadValues({}, b10), c5.loading), { promise: o2, type: "loading" })), F10 = true, k14, yt5 = H(o2).then((E15) => __async(null, null, function* () {
        if (k14 = ["resolve", E15], Ft5(E15) && !E15.ok) {
          F10 = false;
          let I11 = H(c5.error, `HTTP Error! status: ${E15.status}`);
          g7(__spreadProps(__spreadValues(__spreadValues({}, b10), I11), { id: v10, type: "error" }));
        } else if (c5.success !== void 0) {
          F10 = false;
          let I11 = H(c5.success, E15);
          g7(__spreadProps(__spreadValues(__spreadValues({}, b10), I11), { id: v10, type: "success" }));
        }
      })).catch((E15) => __async(null, null, function* () {
        if (k14 = ["reject", E15], c5.error !== void 0) {
          F10 = false;
          let I11 = H(c5.error, E15);
          g7(__spreadProps(__spreadValues(__spreadValues({}, b10), I11), { id: v10, type: "error" }));
        }
      })).finally(() => {
        var _a2;
        F10 && a3(v10), (_a2 = c5.finally) == null ? void 0 : _a2.call(c5);
      });
      return { id: v10, unwrap: () => new Promise((E15, I11) => yt5.then(() => k14[0] === "reject" ? I11(k14[1]) : E15(k14[1])).catch(I11)) };
    }, pause: (o2) => {
      o2 != null ? s = s.map((c5) => c5.id === o2 ? u3(__spreadProps(__spreadValues({}, c5), { message: "PAUSE" })) : c5) : s = s.map((c5) => u3(__spreadProps(__spreadValues({}, c5), { message: "PAUSE" })));
    }, resume: (o2) => {
      o2 != null ? s = s.map((c5) => c5.id === o2 ? u3(__spreadProps(__spreadValues({}, c5), { message: "RESUME" })) : c5) : s = s.map((c5) => u3(__spreadProps(__spreadValues({}, c5), { message: "RESUME" })));
    }, isVisible: (o2) => !r3.has(o2) && !!s.find((c5) => c5.id === o2), isDismissed: (o2) => r3.has(o2), expand: () => {
      s = s.map((o2) => u3(__spreadProps(__spreadValues({}, o2), { stacked: true })));
    }, collapse: () => {
      s = s.map((o2) => u3(__spreadProps(__spreadValues({}, o2), { stacked: false })));
    } };
  }
  function ft6(t, e4) {
    var _a2, _b, _c;
    let i = (_a2 = e4 == null ? void 0 : e4.id) != null ? _a2 : Ir(t, "toast"), s = (_c = e4 == null ? void 0 : e4.store) != null ? _c : mt5({ placement: (_b = e4 == null ? void 0 : e4.placement) != null ? _b : "bottom", overlap: e4 == null ? void 0 : e4.overlap, max: e4 == null ? void 0 : e4.max, gap: e4 == null ? void 0 : e4.gap, offsets: e4 == null ? void 0 : e4.offsets, pauseOnPageIdle: e4 == null ? void 0 : e4.pauseOnPageIdle }), r3 = new X14(t, { id: i, store: s });
    return r3.init(), Ct6.set(i, r3), j11.set(i, s), t.dataset.toastGroup = "true", t.dataset.toastGroupId = i, { group: r3, store: s };
  }
  function M9(t) {
    if (t) return j11.get(t);
    let e4 = document.querySelector("[data-toast-group]");
    if (!e4) return;
    let i = e4.dataset.toastGroupId || e4.id;
    return i ? j11.get(i) : void 0;
  }
  var Tt6, x12, vt7, nt7, pt5, at7, ct7, lt6, Et4, ut8, bt6, Ot4, kt6, At6, Rt5, Dt6, ht6, Ht5, Ft5, q13, Ct6, j11, K17, X14, se10;
  var init_toast = __esm({
    "../priv/static/toast.mjs"() {
      "use strict";
      init_chunk_5MNNWH4C();
      init_chunk_L4HS2GN2();
      init_chunk_IYURAQ6S();
      Tt6 = G("toast").parts("group", "root", "title", "description", "actionTrigger", "closeTrigger");
      x12 = Tt6.build();
      vt7 = (t) => `toast-group:${t}`;
      nt7 = (t, e4) => t.getById(`toast-group:${e4}`);
      pt5 = (t) => `toast:${t.id}`;
      at7 = (t) => t.getById(pt5(t));
      ct7 = (t) => `toast:${t.id}:title`;
      lt6 = (t) => `toast:${t.id}:description`;
      Et4 = (t) => `toast${t.id}:close`;
      ut8 = { info: 5e3, error: 5e3, success: 2e3, loading: 1 / 0, DEFAULT: 5e3 };
      bt6 = (t) => typeof t == "string" ? { left: t, right: t, bottom: t, top: t } : t;
      ({ guards: Ot4, createMachine: kt6 } = ws());
      ({ and: At6 } = Ot4);
      Rt5 = kt6({ props({ props: t }) {
        return __spreadProps(__spreadValues({ dir: "ltr", id: Yo() }, t), { store: t.store });
      }, initialState({ prop: t }) {
        return t("store").attrs.overlap ? "overlap" : "stack";
      }, refs() {
        return { lastFocusedEl: null, isFocusWithin: false, isPointerWithin: false, ignoreMouseTimer: bn.create(), dismissableCleanup: void 0 };
      }, context({ bindable: t }) {
        return { toasts: t(() => ({ defaultValue: [], sync: true, hash: (e4) => e4.map((i) => i.id).join(",") })), heights: t(() => ({ defaultValue: [], sync: true })) };
      }, computed: { count: ({ context: t }) => t.get("toasts").length, overlap: ({ prop: t }) => t("store").attrs.overlap, placement: ({ prop: t }) => t("store").attrs.placement }, effects: ["subscribeToStore", "trackDocumentVisibility", "trackHotKeyPress"], watch({ track: t, context: e4, action: i }) {
        t([() => e4.hash("toasts")], () => {
          queueMicrotask(() => {
            i(["collapsedIfEmpty", "setDismissableBranch"]);
          });
        });
      }, exit: ["clearDismissableBranch", "clearLastFocusedEl", "clearMouseEventTimer"], on: { "DOC.HOTKEY": { actions: ["focusRegionEl"] }, "REGION.BLUR": [{ guard: At6("isOverlapping", "isPointerOut"), target: "overlap", actions: ["collapseToasts", "resumeToasts", "restoreFocusIfPointerOut"] }, { guard: "isPointerOut", target: "stack", actions: ["resumeToasts", "restoreFocusIfPointerOut"] }, { actions: ["clearFocusWithin"] }], "TOAST.REMOVE": { actions: ["removeToast", "removeHeight", "ignoreMouseEventsTemporarily"] }, "TOAST.PAUSE": { actions: ["pauseToasts"] } }, states: { stack: { on: { "REGION.POINTER_LEAVE": [{ guard: "isOverlapping", target: "overlap", actions: ["clearPointerWithin", "resumeToasts", "collapseToasts"] }, { actions: ["clearPointerWithin", "resumeToasts"] }], "REGION.OVERLAP": { target: "overlap", actions: ["collapseToasts"] }, "REGION.FOCUS": { actions: ["setLastFocusedEl", "pauseToasts"] }, "REGION.POINTER_ENTER": { actions: ["setPointerWithin", "pauseToasts"] } } }, overlap: { on: { "REGION.STACK": { target: "stack", actions: ["expandToasts"] }, "REGION.POINTER_ENTER": { target: "stack", actions: ["setPointerWithin", "pauseToasts", "expandToasts"] }, "REGION.FOCUS": { target: "stack", actions: ["setLastFocusedEl", "pauseToasts", "expandToasts"] } } } }, implementations: { guards: { isOverlapping: ({ computed: t }) => t("overlap"), isPointerOut: ({ refs: t }) => !t.get("isPointerWithin") }, effects: { subscribeToStore({ context: t, prop: e4 }) {
        let i = e4("store");
        return t.set("toasts", i.getVisibleToasts()), i.subscribe((s) => {
          if (s.dismiss) {
            t.set("toasts", (r3) => r3.filter((n) => n.id !== s.id));
            return;
          }
          t.set("toasts", (r3) => {
            let n = r3.findIndex((l4) => l4.id === s.id);
            return n !== -1 ? [...r3.slice(0, n), __spreadValues(__spreadValues({}, r3[n]), s), ...r3.slice(n + 1)] : [s, ...r3];
          });
        });
      }, trackHotKeyPress({ prop: t, send: e4 }) {
        return P(document, "keydown", (s) => {
          let { hotkey: r3 } = t("store").attrs;
          r3.every((l4) => s[l4] || s.code === l4) && e4({ type: "DOC.HOTKEY" });
        }, { capture: true });
      }, trackDocumentVisibility({ prop: t, send: e4, scope: i }) {
        let { pauseOnPageIdle: s } = t("store").attrs;
        if (!s) return;
        let r3 = i.getDoc();
        return P(r3, "visibilitychange", () => {
          let n = r3.visibilityState === "hidden";
          e4({ type: n ? "PAUSE_ALL" : "RESUME_ALL" });
        });
      } }, actions: { setDismissableBranch({ refs: t, context: e4, computed: i, scope: s }) {
        var _a2;
        let r3 = e4.get("toasts"), n = i("placement"), l4 = r3.length > 0;
        if (!l4) {
          (_a2 = t.get("dismissableCleanup")) == null ? void 0 : _a2();
          return;
        }
        if (l4 && t.get("dismissableCleanup")) return;
        let d4 = Q8(() => nt7(s, n), { defer: true });
        t.set("dismissableCleanup", d4);
      }, clearDismissableBranch({ refs: t }) {
        var _a2;
        (_a2 = t.get("dismissableCleanup")) == null ? void 0 : _a2();
      }, focusRegionEl({ scope: t, computed: e4 }) {
        queueMicrotask(() => {
          var _a2;
          (_a2 = nt7(t, e4("placement"))) == null ? void 0 : _a2.focus();
        });
      }, pauseToasts({ prop: t }) {
        t("store").pause();
      }, resumeToasts({ prop: t }) {
        t("store").resume();
      }, expandToasts({ prop: t }) {
        t("store").expand();
      }, collapseToasts({ prop: t }) {
        t("store").collapse();
      }, removeToast({ prop: t, event: e4 }) {
        t("store").remove(e4.id);
      }, removeHeight({ event: t, context: e4 }) {
        (t == null ? void 0 : t.id) != null && queueMicrotask(() => {
          e4.set("heights", (i) => i.filter((s) => s.id !== t.id));
        });
      }, collapsedIfEmpty({ send: t, computed: e4 }) {
        !e4("overlap") || e4("count") > 1 || t({ type: "REGION.OVERLAP" });
      }, setLastFocusedEl({ refs: t, event: e4 }) {
        t.get("isFocusWithin") || !e4.target || (t.set("isFocusWithin", true), t.set("lastFocusedEl", e4.target));
      }, restoreFocusIfPointerOut({ refs: t }) {
        var _a2;
        !t.get("lastFocusedEl") || t.get("isPointerWithin") || ((_a2 = t.get("lastFocusedEl")) == null ? void 0 : _a2.focus({ preventScroll: true }), t.set("lastFocusedEl", null), t.set("isFocusWithin", false));
      }, setPointerWithin({ refs: t }) {
        t.set("isPointerWithin", true);
      }, clearPointerWithin({ refs: t }) {
        var _a2;
        t.set("isPointerWithin", false), t.get("lastFocusedEl") && !t.get("isFocusWithin") && ((_a2 = t.get("lastFocusedEl")) == null ? void 0 : _a2.focus({ preventScroll: true }), t.set("lastFocusedEl", null));
      }, clearFocusWithin({ refs: t }) {
        t.set("isFocusWithin", false);
      }, clearLastFocusedEl({ refs: t }) {
        var _a2;
        t.get("lastFocusedEl") && ((_a2 = t.get("lastFocusedEl")) == null ? void 0 : _a2.focus({ preventScroll: true }), t.set("lastFocusedEl", null), t.set("isFocusWithin", false));
      }, ignoreMouseEventsTemporarily({ refs: t }) {
        t.get("ignoreMouseTimer").request();
      }, clearMouseEventTimer({ refs: t }) {
        t.get("ignoreMouseTimer").cancel();
      } } } });
      ({ not: Dt6 } = dr());
      ht6 = { props({ props: t }) {
        return hs(t, ["id", "type", "parent", "removeDelay"], "toast"), __spreadProps(__spreadValues({ closable: true }, t), { duration: _11(t.duration, t.type) });
      }, initialState({ prop: t }) {
        return t("type") === "loading" || t("duration") === 1 / 0 ? "visible:persist" : "visible";
      }, context({ prop: t, bindable: e4 }) {
        return { remainingTime: e4(() => ({ defaultValue: _11(t("duration"), t("type")) })), createdAt: e4(() => ({ defaultValue: Date.now() })), mounted: e4(() => ({ defaultValue: false })), initialHeight: e4(() => ({ defaultValue: 0 })) };
      }, refs() {
        return { closeTimerStartTime: Date.now(), lastCloseStartTimerStartTime: 0 };
      }, computed: { zIndex: ({ prop: t }) => {
        let e4 = t("parent").context.get("toasts"), i = e4.findIndex((s) => s.id === t("id"));
        return e4.length - i;
      }, height: ({ prop: t }) => {
        var _a2, _b;
        return (_b = (_a2 = t("parent").context.get("heights").find((s) => s.id === t("id"))) == null ? void 0 : _a2.height) != null ? _b : 0;
      }, heightIndex: ({ prop: t }) => t("parent").context.get("heights").findIndex((i) => i.id === t("id")), frontmost: ({ prop: t }) => t("index") === 0, heightBefore: ({ prop: t }) => {
        let e4 = t("parent").context.get("heights"), i = e4.findIndex((s) => s.id === t("id"));
        return e4.reduce((s, r3, n) => n >= i ? s : s + r3.height, 0);
      }, shouldPersist: ({ prop: t }) => t("type") === "loading" || t("duration") === 1 / 0 }, watch({ track: t, prop: e4, send: i }) {
        t([() => e4("message")], () => {
          let s = e4("message");
          s && i({ type: s, src: "programmatic" });
        }), t([() => e4("type"), () => e4("duration")], () => {
          i({ type: "UPDATE" });
        });
      }, on: { UPDATE: [{ guard: "shouldPersist", target: "visible:persist", actions: ["resetCloseTimer"] }, { target: "visible:updating", actions: ["resetCloseTimer"] }], MEASURE: { actions: ["measureHeight"] } }, entry: ["setMounted", "measureHeight", "invokeOnVisible"], effects: ["trackHeight"], states: { "visible:updating": { tags: ["visible", "updating"], effects: ["waitForNextTick"], on: { SHOW: { target: "visible" } } }, "visible:persist": { tags: ["visible", "paused"], on: { RESUME: { guard: Dt6("isLoadingType"), target: "visible", actions: ["setCloseTimer"] }, DISMISS: { target: "dismissing" } } }, visible: { tags: ["visible"], effects: ["waitForDuration"], on: { DISMISS: { target: "dismissing" }, PAUSE: { target: "visible:persist", actions: ["syncRemainingTime"] } } }, dismissing: { entry: ["invokeOnDismiss"], effects: ["waitForRemoveDelay"], on: { REMOVE: { target: "unmounted", actions: ["notifyParentToRemove"] } } }, unmounted: { entry: ["invokeOnUnmount"] } }, implementations: { effects: { waitForRemoveDelay({ prop: t, send: e4 }) {
        return ls(() => {
          e4({ type: "REMOVE", src: "timer" });
        }, t("removeDelay"));
      }, waitForDuration({ send: t, context: e4, computed: i }) {
        if (!i("shouldPersist")) return ls(() => {
          t({ type: "DISMISS", src: "timer" });
        }, e4.get("remainingTime"));
      }, waitForNextTick({ send: t }) {
        return ls(() => {
          t({ type: "SHOW", src: "timer" });
        }, 0);
      }, trackHeight({ scope: t, prop: e4 }) {
        let i;
        return nt(() => {
          let s = at7(t);
          if (!s) return;
          let r3 = () => {
            let u3 = s.style.height;
            s.style.height = "auto";
            let d4 = s.getBoundingClientRect().height;
            s.style.height = u3;
            let y11 = { id: e4("id"), height: d4 };
            dt5(e4("parent"), y11);
          }, n = t.getWin(), l4 = new n.MutationObserver(r3);
          l4.observe(s, { childList: true, subtree: true, characterData: true }), i = () => l4.disconnect();
        }), () => i == null ? void 0 : i();
      } }, guards: { isLoadingType: ({ prop: t }) => t("type") === "loading", shouldPersist: ({ computed: t }) => t("shouldPersist") }, actions: { setMounted({ context: t }) {
        nt(() => {
          t.set("mounted", true);
        });
      }, measureHeight({ scope: t, prop: e4, context: i }) {
        queueMicrotask(() => {
          let s = at7(t);
          if (!s) return;
          let r3 = s.style.height;
          s.style.height = "auto";
          let n = s.getBoundingClientRect().height;
          s.style.height = r3, i.set("initialHeight", n);
          let l4 = { id: e4("id"), height: n };
          dt5(e4("parent"), l4);
        });
      }, setCloseTimer({ refs: t }) {
        t.set("closeTimerStartTime", Date.now());
      }, resetCloseTimer({ context: t, refs: e4, prop: i }) {
        e4.set("closeTimerStartTime", Date.now()), t.set("remainingTime", _11(i("duration"), i("type")));
      }, syncRemainingTime({ context: t, refs: e4 }) {
        t.set("remainingTime", (i) => {
          let s = e4.get("closeTimerStartTime"), r3 = Date.now() - s;
          return e4.set("lastCloseStartTimerStartTime", Date.now()), i - r3;
        });
      }, notifyParentToRemove({ prop: t }) {
        t("parent").send({ type: "TOAST.REMOVE", id: t("id") });
      }, invokeOnDismiss({ prop: t, event: e4 }) {
        var _a2;
        (_a2 = t("onStatusChange")) == null ? void 0 : _a2({ status: "dismissing", src: e4.src });
      }, invokeOnUnmount({ prop: t }) {
        var _a2;
        (_a2 = t("onStatusChange")) == null ? void 0 : _a2({ status: "unmounted" });
      }, invokeOnVisible({ prop: t }) {
        var _a2;
        (_a2 = t("onStatusChange")) == null ? void 0 : _a2({ status: "visible" });
      } } } };
      Ht5 = (t, e4) => __spreadValues(__spreadValues({}, e4), Rt(t));
      Ft5 = (t) => t && typeof t == "object" && "ok" in t && typeof t.ok == "boolean" && "status" in t && typeof t.status == "number";
      q13 = { connect: Mt5, machine: Rt5 };
      Ct6 = /* @__PURE__ */ new Map();
      j11 = /* @__PURE__ */ new Map();
      K17 = class extends ve {
        constructor(e4, i) {
          super(e4, i);
          __publicField(this, "parts");
          __publicField(this, "duration");
          __publicField(this, "destroy", () => {
            this.machine.stop(), this.el.remove();
          });
          this.duration = i.duration, this.el.setAttribute("data-scope", "toast"), this.el.setAttribute("data-part", "root"), this.el.innerHTML = `
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
    `, this.parts = { title: this.el.querySelector('[data-scope="toast"][data-part="title"]'), description: this.el.querySelector('[data-scope="toast"][data-part="description"]'), close: this.el.querySelector('[data-scope="toast"][data-part="close-trigger"]'), ghostBefore: this.el.querySelector('[data-scope="toast"][data-part="ghost-before"]'), ghostAfter: this.el.querySelector('[data-scope="toast"][data-part="ghost-after"]'), progressbar: this.el.querySelector('[data-scope="toast"][data-part="progressbar"]'), loadingSpinner: this.el.querySelector('[data-scope="toast"][data-part="loading-spinner"]') };
        }
        initMachine(e4) {
          return new Ls(ht6, e4);
        }
        initApi() {
          return gt4(this.machine.service, Cs);
        }
        render() {
          var _a2, _b, _c, _d;
          this.spreadProps(this.el, this.api.getRootProps()), this.spreadProps(this.parts.close, this.api.getCloseTriggerProps()), this.spreadProps(this.parts.ghostBefore, this.api.getGhostBeforeProps()), this.spreadProps(this.parts.ghostAfter, this.api.getGhostAfterProps()), this.parts.title.textContent !== this.api.title && (this.parts.title.textContent = (_a2 = this.api.title) != null ? _a2 : ""), this.parts.description.textContent !== this.api.description && (this.parts.description.textContent = (_b = this.api.description) != null ? _b : ""), this.spreadProps(this.parts.title, this.api.getTitleProps()), this.spreadProps(this.parts.description, this.api.getDescriptionProps());
          let e4 = this.duration, i = e4 === "Infinity" || e4 === 1 / 0 || e4 === Number.POSITIVE_INFINITY, n = (_d = (_c = this.el.closest('[phx-hook="Toast"]')) == null ? void 0 : _c.querySelector("[data-loading-icon-template]")) == null ? void 0 : _d.innerHTML;
          i ? (this.parts.progressbar.style.display = "none", this.parts.loadingSpinner.style.display = "flex", this.el.setAttribute("data-duration-infinity", "true"), n && this.parts.loadingSpinner.innerHTML !== n && (this.parts.loadingSpinner.innerHTML = n)) : (this.parts.progressbar.style.display = "block", this.parts.loadingSpinner.style.display = "none", this.el.removeAttribute("data-duration-infinity"));
        }
      };
      X14 = class extends ve {
        constructor(e4, i) {
          var _a2;
          super(e4, i);
          __publicField(this, "toastComponents", /* @__PURE__ */ new Map());
          __publicField(this, "groupEl");
          __publicField(this, "store");
          __publicField(this, "destroy", () => {
            for (let e4 of this.toastComponents.values()) e4.destroy();
            this.toastComponents.clear(), this.machine.stop();
          });
          this.store = i.store, this.groupEl = (_a2 = e4.querySelector('[data-part="group"]')) != null ? _a2 : (() => {
            let s = document.createElement("div");
            return s.setAttribute("data-scope", "toast"), s.setAttribute("data-part", "group"), e4.appendChild(s), s;
          })();
        }
        initMachine(e4) {
          return new Ls(q13.machine, e4);
        }
        initApi() {
          return q13.connect(this.machine.service, Cs);
        }
        render() {
          this.spreadProps(this.groupEl, this.api.getGroupProps());
          let e4 = this.api.getToasts().filter((s) => typeof s.id == "string"), i = new Set(e4.map((s) => s.id));
          e4.forEach((s, r3) => {
            let n = this.toastComponents.get(s.id);
            if (n) n.duration = s.duration, n.updateProps(__spreadProps(__spreadValues({}, s), { parent: this.machine.service, index: r3 }));
            else {
              let l4 = document.createElement("div");
              l4.setAttribute("data-scope", "toast"), l4.setAttribute("data-part", "root"), this.groupEl.appendChild(l4), n = new K17(l4, __spreadProps(__spreadValues({}, s), { parent: this.machine.service, index: r3 })), n.init(), this.toastComponents.set(s.id, n);
            }
          });
          for (let [s, r3] of this.toastComponents) i.has(s) || (r3.destroy(), this.toastComponents.delete(s));
        }
      };
      se10 = { mounted() {
        var _a2;
        let t = this.el;
        t.id || (t.id = Ir(t, "toast")), this.groupId = t.id;
        let e4 = (a3) => {
          if (a3) try {
            return a3.includes("{") ? JSON.parse(a3) : a3;
          } catch (e5) {
            return a3;
          }
        }, i = (a3) => a3 === "Infinity" || a3 === 1 / 0 ? 1 / 0 : typeof a3 == "string" ? parseInt(a3, 10) || void 0 : a3, s = (_a2 = xr(t, "placement", ["top-start", "top", "top-end", "bottom-start", "bottom", "bottom-end"])) != null ? _a2 : "bottom-end";
        ft6(t, { id: this.groupId, placement: s, overlap: _r(t, "overlap"), max: Lr(t, "max"), gap: Lr(t, "gap"), offsets: e4(xr(t, "offset")), pauseOnPageIdle: _r(t, "pauseOnPageIdle") });
        let r3 = M9(this.groupId), n = t.getAttribute("data-flash-info"), l4 = t.getAttribute("data-flash-info-title"), u3 = t.getAttribute("data-flash-error"), d4 = t.getAttribute("data-flash-error-title"), y11 = t.getAttribute("data-flash-info-duration"), g7 = t.getAttribute("data-flash-error-duration");
        if (r3 && n) try {
          r3.create({ title: l4 || "Success", description: n, type: "info", id: Ir(void 0, "toast"), duration: i(y11 != null ? y11 : void 0) });
        } catch (a3) {
          console.error("Failed to create flash info toast:", a3);
        }
        if (r3 && u3) try {
          r3.create({ title: d4 || "Error", description: u3, type: "error", id: Ir(void 0, "toast"), duration: i(g7 != null ? g7 : void 0) });
        } catch (a3) {
          console.error("Failed to create flash error toast:", a3);
        }
        this.handlers = [], this.handlers.push(this.handleEvent("toast-create", (a3) => {
          let p4 = M9(a3.groupId || this.groupId);
          if (p4) try {
            p4.create({ title: a3.title, description: a3.description, type: a3.type || "info", id: a3.id || Ir(void 0, "toast"), duration: i(a3.duration) });
          } catch (h6) {
            console.error("Failed to create toast:", h6);
          }
        })), this.handlers.push(this.handleEvent("toast-update", (a3) => {
          let p4 = M9(a3.groupId || this.groupId);
          if (p4) try {
            p4.update(a3.id, { title: a3.title, description: a3.description, type: a3.type });
          } catch (h6) {
            console.error("Failed to update toast:", h6);
          }
        })), this.handlers.push(this.handleEvent("toast-dismiss", (a3) => {
          let p4 = M9(a3.groupId || this.groupId);
          if (p4) try {
            p4.dismiss(a3.id);
          } catch (h6) {
            console.error("Failed to dismiss toast:", h6);
          }
        })), t.addEventListener("toast:create", (a3) => {
          let { detail: p4 } = a3, h6 = M9(p4.groupId || this.groupId);
          if (h6) try {
            h6.create({ title: p4.title, description: p4.description, type: p4.type || "info", id: p4.id || Ir(void 0, "toast"), duration: i(p4.duration) });
          } catch (f4) {
            console.error("Failed to create toast:", f4);
          }
        });
      }, destroyed() {
        if (this.handlers) for (let t of this.handlers) this.removeHandleEvent(t);
      } };
    }
  });

  // ../priv/static/toggle-group.mjs
  var toggle_group_exports = {};
  __export(toggle_group_exports, {
    ToggleGroup: () => ke9
  });
  function $12(e4, t) {
    let { context: a3, send: o2, prop: i, scope: l4 } = e4, c5 = a3.get("value"), f4 = i("disabled"), T7 = !i("multiple"), g7 = i("rovingFocus"), m5 = i("orientation") === "horizontal";
    function G14(n) {
      let r3 = ee10(l4, n.value);
      return { id: r3, disabled: !!(n.disabled || f4), pressed: !!c5.includes(n.value), focused: a3.get("focusedId") === r3 };
    }
    return { value: c5, setValue(n) {
      o2({ type: "VALUE.SET", value: n });
    }, getRootProps() {
      return t.element(__spreadProps(__spreadValues({}, z11.root.attrs), { id: b8(l4), dir: i("dir"), role: T7 ? "radiogroup" : "group", tabIndex: a3.get("isTabbingBackward") ? -1 : 0, "data-disabled": jr(f4), "data-orientation": i("orientation"), "data-focus": jr(a3.get("focusedId") != null), style: { outline: "none" }, onMouseDown() {
        f4 || o2({ type: "ROOT.MOUSE_DOWN" });
      }, onFocus(n) {
        f4 || n.currentTarget === Je(n) && (a3.get("isClickFocus") || a3.get("isTabbingBackward") || o2({ type: "ROOT.FOCUS" }));
      }, onBlur(n) {
        let r3 = n.relatedTarget;
        Ie(n.currentTarget, r3) || f4 || o2({ type: "ROOT.BLUR" });
      } }));
    }, getItemState: G14, getItemProps(n) {
      let r3 = G14(n), J15 = r3.focused ? 0 : -1;
      return t.button(__spreadProps(__spreadValues({}, z11.item.attrs), { id: r3.id, type: "button", "data-ownedby": b8(l4), "data-focus": jr(r3.focused), disabled: r3.disabled, tabIndex: g7 ? J15 : void 0, role: T7 ? "radio" : void 0, "aria-checked": T7 ? r3.pressed : void 0, "aria-pressed": T7 ? void 0 : r3.pressed, "data-disabled": jr(r3.disabled), "data-orientation": i("orientation"), dir: i("dir"), "data-state": r3.pressed ? "on" : "off", onFocus() {
        r3.disabled || o2({ type: "TOGGLE.FOCUS", id: r3.id });
      }, onClick(u3) {
        r3.disabled || (o2({ type: "TOGGLE.CLICK", id: r3.id, value: n.value }), Xr() && u3.currentTarget.focus({ preventScroll: true }));
      }, onKeyDown(u3) {
        if (u3.defaultPrevented || !Ie(u3.currentTarget, Je(u3)) || r3.disabled) return;
        let I11 = { Tab(Q17) {
          let Y16 = Q17.shiftKey;
          o2({ type: "TOGGLE.SHIFT_TAB", isShiftTab: Y16 });
        }, ArrowLeft() {
          !g7 || !m5 || o2({ type: "TOGGLE.FOCUS_PREV" });
        }, ArrowRight() {
          !g7 || !m5 || o2({ type: "TOGGLE.FOCUS_NEXT" });
        }, ArrowUp() {
          !g7 || m5 || o2({ type: "TOGGLE.FOCUS_PREV" });
        }, ArrowDown() {
          !g7 || m5 || o2({ type: "TOGGLE.FOCUS_NEXT" });
        }, Home() {
          g7 && o2({ type: "TOGGLE.FOCUS_FIRST" });
        }, End() {
          g7 && o2({ type: "TOGGLE.FOCUS_LAST" });
        } }[io(u3)];
        I11 && (I11(u3), u3.key !== "Tab" && u3.preventDefault());
      } }));
    } };
  }
  var Z13, z11, b8, ee10, q14, F9, W14, te9, oe9, ae10, K18, ie11, X15, re10, fe10, se11, ve7, E14, ke9;
  var init_toggle_group = __esm({
    "../priv/static/toggle-group.mjs"() {
      "use strict";
      init_chunk_IYURAQ6S();
      Z13 = G("toggle-group").parts("root", "item");
      z11 = Z13.build();
      b8 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.root) != null ? _b : `toggle-group:${e4.id}`;
      };
      ee10 = (e4, t) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = e4.ids) == null ? void 0 : _a2.item) == null ? void 0 : _b.call(_a2, t)) != null ? _c : `toggle-group:${e4.id}:${t}`;
      };
      q14 = (e4) => e4.getById(b8(e4));
      F9 = (e4) => {
        let a3 = `[data-ownedby='${CSS.escape(b8(e4))}']:not([data-disabled])`;
        return Po(q14(e4), a3);
      };
      W14 = (e4) => Io(F9(e4));
      te9 = (e4) => Wn(F9(e4));
      oe9 = (e4, t, a3) => To(F9(e4), t, a3);
      ae10 = (e4, t, a3) => Oo(F9(e4), t, a3);
      ({ not: K18, and: ie11 } = dr());
      X15 = { props({ props: e4 }) {
        return __spreadValues({ defaultValue: [], orientation: "horizontal", rovingFocus: true, loopFocus: true, deselectable: true }, e4);
      }, initialState() {
        return "idle";
      }, context({ prop: e4, bindable: t }) {
        return { value: t(() => ({ defaultValue: e4("defaultValue"), value: e4("value"), onChange(a3) {
          var _a2;
          (_a2 = e4("onValueChange")) == null ? void 0 : _a2({ value: a3 });
        } })), focusedId: t(() => ({ defaultValue: null })), isTabbingBackward: t(() => ({ defaultValue: false })), isClickFocus: t(() => ({ defaultValue: false })), isWithinToolbar: t(() => ({ defaultValue: false })) };
      }, computed: { currentLoopFocus: ({ context: e4, prop: t }) => t("loopFocus") && !e4.get("isWithinToolbar") }, entry: ["checkIfWithinToolbar"], on: { "VALUE.SET": { actions: ["setValue"] }, "TOGGLE.CLICK": { actions: ["setValue"] }, "ROOT.MOUSE_DOWN": { actions: ["setClickFocus"] } }, states: { idle: { on: { "ROOT.FOCUS": { target: "focused", guard: K18(ie11("isClickFocus", "isTabbingBackward")), actions: ["focusFirstToggle", "clearClickFocus"] }, "TOGGLE.FOCUS": { target: "focused", actions: ["setFocusedId"] } } }, focused: { on: { "ROOT.BLUR": { target: "idle", actions: ["clearIsTabbingBackward", "clearFocusedId", "clearClickFocus"] }, "TOGGLE.FOCUS": { actions: ["setFocusedId"] }, "TOGGLE.FOCUS_NEXT": { actions: ["focusNextToggle"] }, "TOGGLE.FOCUS_PREV": { actions: ["focusPrevToggle"] }, "TOGGLE.FOCUS_FIRST": { actions: ["focusFirstToggle"] }, "TOGGLE.FOCUS_LAST": { actions: ["focusLastToggle"] }, "TOGGLE.SHIFT_TAB": [{ guard: K18("isFirstToggleFocused"), target: "idle", actions: ["setIsTabbingBackward"] }, { actions: ["setIsTabbingBackward"] }] } } }, implementations: { guards: { isClickFocus: ({ context: e4 }) => e4.get("isClickFocus"), isTabbingBackward: ({ context: e4 }) => e4.get("isTabbingBackward"), isFirstToggleFocused: ({ context: e4, scope: t }) => {
        var _a2;
        return e4.get("focusedId") === ((_a2 = W14(t)) == null ? void 0 : _a2.id);
      } }, actions: { setIsTabbingBackward({ context: e4 }) {
        e4.set("isTabbingBackward", true);
      }, clearIsTabbingBackward({ context: e4 }) {
        e4.set("isTabbingBackward", false);
      }, setClickFocus({ context: e4 }) {
        e4.set("isClickFocus", true);
      }, clearClickFocus({ context: e4 }) {
        e4.set("isClickFocus", false);
      }, checkIfWithinToolbar({ context: e4, scope: t }) {
        var _a2;
        let a3 = (_a2 = q14(t)) == null ? void 0 : _a2.closest("[role=toolbar]");
        e4.set("isWithinToolbar", !!a3);
      }, setFocusedId({ context: e4, event: t }) {
        e4.set("focusedId", t.id);
      }, clearFocusedId({ context: e4 }) {
        e4.set("focusedId", null);
      }, setValue({ context: e4, event: t, prop: a3 }) {
        hs(t, ["value"]);
        let o2 = e4.get("value");
        Xn(t.value) ? o2 = t.value : a3("multiple") ? o2 = Ko(o2, t.value) : o2 = V(o2, [t.value]) && a3("deselectable") ? [] : [t.value], e4.set("value", o2);
      }, focusNextToggle({ context: e4, scope: t, prop: a3 }) {
        nt(() => {
          var _a2;
          let o2 = e4.get("focusedId");
          o2 && ((_a2 = oe9(t, o2, a3("loopFocus"))) == null ? void 0 : _a2.focus({ preventScroll: true }));
        });
      }, focusPrevToggle({ context: e4, scope: t, prop: a3 }) {
        nt(() => {
          var _a2;
          let o2 = e4.get("focusedId");
          o2 && ((_a2 = ae10(t, o2, a3("loopFocus"))) == null ? void 0 : _a2.focus({ preventScroll: true }));
        });
      }, focusFirstToggle({ scope: e4 }) {
        nt(() => {
          var _a2;
          (_a2 = W14(e4)) == null ? void 0 : _a2.focus({ preventScroll: true });
        });
      }, focusLastToggle({ scope: e4 }) {
        nt(() => {
          var _a2;
          (_a2 = te9(e4)) == null ? void 0 : _a2.focus({ preventScroll: true });
        });
      } } } };
      re10 = As()(["dir", "disabled", "getRootNode", "id", "ids", "loopFocus", "multiple", "onValueChange", "orientation", "rovingFocus", "value", "defaultValue", "deselectable"]);
      fe10 = as(re10);
      se11 = As()(["value", "disabled"]);
      ve7 = as(se11);
      E14 = class extends ve {
        initMachine(t) {
          return new Ls(X15, t);
        }
        initApi() {
          return $12(this.machine.service, Cs);
        }
        render() {
          let t = this.el.querySelector('[data-scope="toggle-group"][data-part="root"]');
          if (!t) return;
          this.spreadProps(t, this.api.getRootProps());
          let a3 = this.el.querySelectorAll('[data-scope="toggle-group"][data-part="item"]');
          for (let o2 = 0; o2 < a3.length; o2++) {
            let i = a3[o2], l4 = xr(i, "value");
            if (!l4) continue;
            let c5 = _r(i, "disabled");
            this.spreadProps(i, this.api.getItemProps({ value: l4, disabled: c5 }));
          }
        }
      };
      ke9 = { mounted() {
        let e4 = this.el, t = this.pushEvent.bind(this), a3 = __spreadProps(__spreadValues({ id: e4.id }, _r(e4, "controlled") ? { value: Cr(e4, "value") } : { defaultValue: Cr(e4, "defaultValue") }), { defaultValue: Cr(e4, "defaultValue"), deselectable: _r(e4, "deselectable"), loopFocus: _r(e4, "loopFocus"), rovingFocus: _r(e4, "rovingFocus"), disabled: _r(e4, "disabled"), multiple: _r(e4, "multiple"), orientation: xr(e4, "orientation", ["horizontal", "vertical"]), dir: xr(e4, "dir", ["ltr", "rtl"]), onValueChange: (i) => {
          let l4 = xr(e4, "onValueChange");
          l4 && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected() && t(l4, { value: i.value, id: e4.id });
          let c5 = xr(e4, "onValueChangeClient");
          c5 && e4.dispatchEvent(new CustomEvent(c5, { bubbles: true, detail: { value: i.value, id: e4.id } }));
        } }), o2 = new E14(e4, a3);
        o2.init(), this.toggleGroup = o2, this.onSetValue = (i) => {
          let { value: l4 } = i.detail;
          o2.api.setValue(l4);
        }, e4.addEventListener("phx:toggle-group:set-value", this.onSetValue), this.handlers = [], this.handlers.push(this.handleEvent("toggle-group_set_value", (i) => {
          let l4 = i.id;
          l4 && l4 !== e4.id || o2.api.setValue(i.value);
        })), this.handlers.push(this.handleEvent("toggle-group:value", () => {
          this.pushEvent("toggle-group:value_response", { value: o2.api.value });
        }));
      }, updated() {
        var _a2;
        (_a2 = this.toggleGroup) == null ? void 0 : _a2.updateProps(__spreadProps(__spreadValues({}, _r(this.el, "controlled") ? { value: Cr(this.el, "value") } : { defaultValue: Cr(this.el, "defaultValue") }), { deselectable: _r(this.el, "deselectable"), loopFocus: _r(this.el, "loopFocus"), rovingFocus: _r(this.el, "rovingFocus"), disabled: _r(this.el, "disabled"), multiple: _r(this.el, "multiple"), orientation: xr(this.el, "orientation", ["horizontal", "vertical"]), dir: xr(this.el, "dir", ["ltr", "rtl"]) }));
      }, destroyed() {
        var _a2;
        if (this.onSetValue && this.el.removeEventListener("phx:toggle-group:set-value", this.onSetValue), this.handlers) for (let e4 of this.handlers) this.removeHandleEvent(e4);
        (_a2 = this.toggleGroup) == null ? void 0 : _a2.destroy();
      } };
    }
  });

  // ../priv/static/tree-view.mjs
  var tree_view_exports = {};
  __export(tree_view_exports, {
    TreeView: () => ze9
  });
  function ye9(e4, t, n) {
    let a3 = e4.getNodeValue(t);
    if (!e4.isBranchNode(t)) return n.includes(a3);
    let l4 = e4.getDescendantValues(a3), s = l4.every((r3) => n.includes(r3)), d4 = l4.some((r3) => n.includes(r3));
    return s ? true : d4 ? "indeterminate" : false;
  }
  function De8(e4, t, n) {
    let a3 = e4.getDescendantValues(t), l4 = a3.every((s) => n.includes(s));
    return Do(l4 ? Un(n, ...a3) : Hn(n, ...a3));
  }
  function ke10(e4, t) {
    let n = /* @__PURE__ */ new Map();
    return e4.visit({ onEnter: (a3) => {
      let l4 = e4.getNodeValue(a3), s = e4.isBranchNode(a3), d4 = ye9(e4, a3, t);
      n.set(l4, { type: s ? "branch" : "leaf", checked: d4 });
    } }), n;
  }
  function Ae7(e4, t) {
    let { context: n, scope: a3, computed: l4, prop: s, send: d4 } = e4, r3 = s("collection"), u3 = Array.from(n.get("expandedValue")), p4 = Array.from(n.get("selectedValue")), V16 = Array.from(n.get("checkedValue")), N10 = l4("isTypingAhead"), v10 = n.get("focusedValue"), D11 = n.get("loadingStatus"), M10 = n.get("renamingValue"), E15 = ({ indexPath: i }) => r3.getValuePath(i).slice(0, -1).some((c5) => !u3.includes(c5)), S13 = r3.getFirstNode(void 0, { skip: E15 }), T7 = S13 ? r3.getNodeValue(S13) : null;
    function m5(i) {
      let { node: o2, indexPath: c5 } = i, h6 = r3.getNodeValue(o2);
      return { id: se12(a3, h6), value: h6, indexPath: c5, valuePath: r3.getValuePath(c5), disabled: !!o2.disabled, focused: v10 == null ? T7 === h6 : v10 === h6, selected: p4.includes(h6), expanded: u3.includes(h6), loading: D11[h6] === "loading", depth: c5.length, isBranch: r3.isBranchNode(o2), renaming: M10 === h6, get checked() {
        return ye9(r3, o2, V16);
      } };
    }
    return { collection: r3, expandedValue: u3, selectedValue: p4, checkedValue: V16, toggleChecked(i, o2) {
      d4({ type: "CHECKED.TOGGLE", value: i, isBranch: o2 });
    }, setChecked(i) {
      d4({ type: "CHECKED.SET", value: i });
    }, clearChecked() {
      d4({ type: "CHECKED.CLEAR" });
    }, getCheckedMap() {
      return ke10(r3, V16);
    }, expand(i) {
      d4({ type: i ? "BRANCH.EXPAND" : "EXPANDED.ALL", value: i });
    }, collapse(i) {
      d4({ type: i ? "BRANCH.COLLAPSE" : "EXPANDED.CLEAR", value: i });
    }, deselect(i) {
      d4({ type: i ? "NODE.DESELECT" : "SELECTED.CLEAR", value: i });
    }, select(i) {
      d4({ type: i ? "NODE.SELECT" : "SELECTED.ALL", value: i, isTrusted: false });
    }, getVisibleNodes() {
      return l4("visibleNodes");
    }, focus(i) {
      x13(a3, i);
    }, selectParent(i) {
      let o2 = r3.getParentNode(i);
      if (!o2) return;
      let c5 = Hn(p4, r3.getNodeValue(o2));
      d4({ type: "SELECTED.SET", value: c5, src: "select.parent" });
    }, expandParent(i) {
      let o2 = r3.getParentNode(i);
      if (!o2) return;
      let c5 = Hn(u3, r3.getNodeValue(o2));
      d4({ type: "EXPANDED.SET", value: c5, src: "expand.parent" });
    }, setExpandedValue(i) {
      let o2 = Do(i);
      d4({ type: "EXPANDED.SET", value: o2 });
    }, setSelectedValue(i) {
      let o2 = Do(i);
      d4({ type: "SELECTED.SET", value: o2 });
    }, startRenaming(i) {
      d4({ type: "NODE.RENAME", value: i });
    }, submitRenaming(i, o2) {
      d4({ type: "RENAME.SUBMIT", value: i, label: o2 });
    }, cancelRenaming() {
      d4({ type: "RENAME.CANCEL" });
    }, getRootProps() {
      return t.element(__spreadProps(__spreadValues({}, C16.root.attrs), { id: Le9(a3), dir: s("dir") }));
    }, getLabelProps() {
      return t.element(__spreadProps(__spreadValues({}, C16.label.attrs), { id: Ce9(a3), dir: s("dir") }));
    }, getTreeProps() {
      return t.element(__spreadProps(__spreadValues({}, C16.tree.attrs), { id: le11(a3), dir: s("dir"), role: "tree", "aria-label": "Tree View", "aria-labelledby": Ce9(a3), "aria-multiselectable": s("selectionMode") === "multiple" || void 0, tabIndex: -1, onKeyDown(i) {
        if (i.defaultPrevented || to(i)) return;
        let o2 = Je(i);
        if (_e(o2)) return;
        let c5 = o2 == null ? void 0 : o2.closest("[data-part=branch-control], [data-part=item]");
        if (!c5) return;
        let h6 = c5.dataset.value;
        if (h6 == null) {
          console.warn("[zag-js/tree-view] Node id not found for node", c5);
          return;
        }
        let k14 = c5.matches("[data-part=branch-control]"), O10 = { ArrowDown(f4) {
          so(f4) || (f4.preventDefault(), d4({ type: "NODE.ARROW_DOWN", id: h6, shiftKey: f4.shiftKey }));
        }, ArrowUp(f4) {
          so(f4) || (f4.preventDefault(), d4({ type: "NODE.ARROW_UP", id: h6, shiftKey: f4.shiftKey }));
        }, ArrowLeft(f4) {
          so(f4) || c5.dataset.disabled || (f4.preventDefault(), d4({ type: k14 ? "BRANCH_NODE.ARROW_LEFT" : "NODE.ARROW_LEFT", id: h6 }));
        }, ArrowRight(f4) {
          !k14 || c5.dataset.disabled || (f4.preventDefault(), d4({ type: "BRANCH_NODE.ARROW_RIGHT", id: h6 }));
        }, Home(f4) {
          so(f4) || (f4.preventDefault(), d4({ type: "NODE.HOME", id: h6, shiftKey: f4.shiftKey }));
        }, End(f4) {
          so(f4) || (f4.preventDefault(), d4({ type: "NODE.END", id: h6, shiftKey: f4.shiftKey }));
        }, Space(f4) {
          var _a2;
          c5.dataset.disabled || (N10 ? d4({ type: "TREE.TYPEAHEAD", key: f4.key }) : (_a2 = O10.Enter) == null ? void 0 : _a2.call(O10, f4));
        }, Enter(f4) {
          c5.dataset.disabled || $r(o2) && so(f4) || (d4({ type: k14 ? "BRANCH_NODE.CLICK" : "NODE.CLICK", id: h6, src: "keyboard" }), $r(o2) || f4.preventDefault());
        }, "*"(f4) {
          c5.dataset.disabled || (f4.preventDefault(), d4({ type: "SIBLINGS.EXPAND", id: h6 }));
        }, a(f4) {
          !f4.metaKey || c5.dataset.disabled || (f4.preventDefault(), d4({ type: "SELECTED.ALL", moveFocus: true }));
        }, F2(f4) {
          if (c5.dataset.disabled) return;
          let re11 = s("canRename");
          if (!re11) return;
          let z12 = r3.getIndexPath(h6);
          if (z12) {
            let ce9 = r3.at(z12);
            if (ce9 && !re11(ce9, z12)) return;
          }
          f4.preventDefault(), d4({ type: "NODE.RENAME", value: h6 });
        } }, Z14 = io(i, { dir: s("dir") }), ie12 = O10[Z14];
        if (ie12) {
          ie12(i);
          return;
        }
        xo.isValidEvent(i) && (d4({ type: "TREE.TYPEAHEAD", key: i.key, id: h6 }), i.preventDefault());
      } }));
    }, getNodeState: m5, getItemProps(i) {
      let o2 = m5(i);
      return t.element(__spreadProps(__spreadValues({}, C16.item.attrs), { id: o2.id, dir: s("dir"), "data-ownedby": le11(a3), "data-path": i.indexPath.join("/"), "data-value": o2.value, tabIndex: o2.focused ? 0 : -1, "data-focus": jr(o2.focused), role: "treeitem", "aria-current": o2.selected ? "true" : void 0, "aria-selected": o2.disabled ? void 0 : o2.selected, "data-selected": jr(o2.selected), "aria-disabled": Br(o2.disabled), "data-disabled": jr(o2.disabled), "data-renaming": jr(o2.renaming), "aria-level": o2.depth, "data-depth": o2.depth, style: { "--depth": o2.depth }, onFocus(c5) {
        c5.stopPropagation(), d4({ type: "NODE.FOCUS", id: o2.value });
      }, onClick(c5) {
        if (o2.disabled || !ro(c5) || $r(c5.currentTarget) && so(c5)) return;
        let h6 = c5.metaKey || c5.ctrlKey;
        d4({ type: "NODE.CLICK", id: o2.value, shiftKey: c5.shiftKey, ctrlKey: h6 }), c5.stopPropagation(), $r(c5.currentTarget) || c5.preventDefault();
      } }));
    }, getItemTextProps(i) {
      let o2 = m5(i);
      return t.element(__spreadProps(__spreadValues({}, C16.itemText.attrs), { "data-disabled": jr(o2.disabled), "data-selected": jr(o2.selected), "data-focus": jr(o2.focused) }));
    }, getItemIndicatorProps(i) {
      let o2 = m5(i);
      return t.element(__spreadProps(__spreadValues({}, C16.itemIndicator.attrs), { "aria-hidden": true, "data-disabled": jr(o2.disabled), "data-selected": jr(o2.selected), "data-focus": jr(o2.focused), hidden: !o2.selected }));
    }, getBranchProps(i) {
      let o2 = m5(i);
      return t.element(__spreadProps(__spreadValues({}, C16.branch.attrs), { "data-depth": o2.depth, dir: s("dir"), "data-branch": o2.value, role: "treeitem", "data-ownedby": le11(a3), "data-value": o2.value, "aria-level": o2.depth, "aria-selected": o2.disabled ? void 0 : o2.selected, "data-path": i.indexPath.join("/"), "data-selected": jr(o2.selected), "aria-expanded": o2.expanded, "data-state": o2.expanded ? "open" : "closed", "aria-disabled": Br(o2.disabled), "data-disabled": jr(o2.disabled), "data-loading": jr(o2.loading), "aria-busy": Br(o2.loading), style: { "--depth": o2.depth } }));
    }, getBranchIndicatorProps(i) {
      let o2 = m5(i);
      return t.element(__spreadProps(__spreadValues({}, C16.branchIndicator.attrs), { "aria-hidden": true, "data-state": o2.expanded ? "open" : "closed", "data-disabled": jr(o2.disabled), "data-selected": jr(o2.selected), "data-focus": jr(o2.focused), "data-loading": jr(o2.loading) }));
    }, getBranchTriggerProps(i) {
      let o2 = m5(i);
      return t.element(__spreadProps(__spreadValues({}, C16.branchTrigger.attrs), { role: "button", dir: s("dir"), "data-disabled": jr(o2.disabled), "data-state": o2.expanded ? "open" : "closed", "data-value": o2.value, "data-loading": jr(o2.loading), disabled: o2.loading, onClick(c5) {
        o2.disabled || o2.loading || (d4({ type: "BRANCH_TOGGLE.CLICK", id: o2.value }), c5.stopPropagation());
      } }));
    }, getBranchControlProps(i) {
      let o2 = m5(i);
      return t.element(__spreadProps(__spreadValues({}, C16.branchControl.attrs), { role: "button", id: o2.id, dir: s("dir"), tabIndex: o2.focused ? 0 : -1, "data-path": i.indexPath.join("/"), "data-state": o2.expanded ? "open" : "closed", "data-disabled": jr(o2.disabled), "data-selected": jr(o2.selected), "data-focus": jr(o2.focused), "data-renaming": jr(o2.renaming), "data-value": o2.value, "data-depth": o2.depth, "data-loading": jr(o2.loading), "aria-busy": Br(o2.loading), onFocus(c5) {
        d4({ type: "NODE.FOCUS", id: o2.value }), c5.stopPropagation();
      }, onClick(c5) {
        if (o2.disabled || o2.loading || !ro(c5) || $r(c5.currentTarget) && so(c5)) return;
        let h6 = c5.metaKey || c5.ctrlKey;
        d4({ type: "BRANCH_NODE.CLICK", id: o2.value, shiftKey: c5.shiftKey, ctrlKey: h6 }), c5.stopPropagation();
      } }));
    }, getBranchTextProps(i) {
      let o2 = m5(i);
      return t.element(__spreadProps(__spreadValues({}, C16.branchText.attrs), { dir: s("dir"), "data-disabled": jr(o2.disabled), "data-state": o2.expanded ? "open" : "closed", "data-loading": jr(o2.loading) }));
    }, getBranchContentProps(i) {
      let o2 = m5(i);
      return t.element(__spreadProps(__spreadValues({}, C16.branchContent.attrs), { role: "group", dir: s("dir"), "data-state": o2.expanded ? "open" : "closed", "data-depth": o2.depth, "data-path": i.indexPath.join("/"), "data-value": o2.value, hidden: !o2.expanded }));
    }, getBranchIndentGuideProps(i) {
      let o2 = m5(i);
      return t.element(__spreadProps(__spreadValues({}, C16.branchIndentGuide.attrs), { "data-depth": o2.depth }));
    }, getNodeCheckboxProps(i) {
      let o2 = m5(i), c5 = o2.checked;
      return t.element(__spreadProps(__spreadValues({}, C16.nodeCheckbox.attrs), { tabIndex: -1, role: "checkbox", "data-state": c5 === true ? "checked" : c5 === false ? "unchecked" : "indeterminate", "aria-checked": c5 === true ? "true" : c5 === false ? "false" : "mixed", "data-disabled": jr(o2.disabled), onClick(h6) {
        var _a2;
        if (h6.defaultPrevented || o2.disabled || !ro(h6)) return;
        d4({ type: "CHECKED.TOGGLE", value: o2.value, isBranch: o2.isBranch }), h6.stopPropagation(), (_a2 = h6.currentTarget.closest("[role=treeitem]")) == null ? void 0 : _a2.focus({ preventScroll: true });
      } }));
    }, getNodeRenameInputProps(i) {
      let o2 = m5(i);
      return t.input(__spreadProps(__spreadValues({}, C16.nodeRenameInput.attrs), { id: be9(a3, o2.value), type: "text", "aria-label": "Rename tree item", hidden: !o2.renaming, onKeyDown(c5) {
        to(c5) || (c5.key === "Escape" && (d4({ type: "RENAME.CANCEL" }), c5.preventDefault()), c5.key === "Enter" && (d4({ type: "RENAME.SUBMIT", label: c5.currentTarget.value }), c5.preventDefault()), c5.stopPropagation());
      }, onBlur(c5) {
        d4({ type: "RENAME.SUBMIT", label: c5.currentTarget.value });
      } }));
    } };
  }
  function Y15(e4, t) {
    let { context: n, prop: a3, refs: l4 } = e4;
    if (!a3("loadChildren")) {
      n.set("expandedValue", (E15) => Do(Hn(E15, ...t)));
      return;
    }
    let s = n.get("loadingStatus"), [d4, r3] = $o(t, (E15) => s[E15] === "loaded");
    if (d4.length > 0 && n.set("expandedValue", (E15) => Do(Hn(E15, ...d4))), r3.length === 0) return;
    let u3 = a3("collection"), [p4, V16] = $o(r3, (E15) => {
      let S13 = u3.findNode(E15);
      return u3.getNodeChildren(S13).length > 0;
    });
    if (p4.length > 0 && n.set("expandedValue", (E15) => Do(Hn(E15, ...p4))), V16.length === 0) return;
    n.set("loadingStatus", (E15) => __spreadValues(__spreadValues({}, E15), V16.reduce((S13, T7) => __spreadProps(__spreadValues({}, S13), { [T7]: "loading" }), {})));
    let N10 = V16.map((E15) => {
      let S13 = u3.getIndexPath(E15), T7 = u3.getValuePath(S13), m5 = u3.findNode(E15);
      return { id: E15, indexPath: S13, valuePath: T7, node: m5 };
    }), v10 = l4.get("pendingAborts"), D11 = a3("loadChildren");
    ds(D11, () => "[zag-js/tree-view] `loadChildren` is required for async expansion");
    let M10 = N10.map(({ id: E15, indexPath: S13, valuePath: T7, node: m5 }) => {
      let i = v10.get(E15);
      i && (i.abort(), v10.delete(E15));
      let o2 = new AbortController();
      return v10.set(E15, o2), D11({ valuePath: T7, indexPath: S13, node: m5, signal: o2.signal });
    });
    Promise.allSettled(M10).then((E15) => {
      var _a2, _b;
      let S13 = [], T7 = [], m5 = n.get("loadingStatus"), i = a3("collection");
      E15.forEach((o2, c5) => {
        let { id: h6, indexPath: k14, node: O10, valuePath: Z14 } = N10[c5];
        o2.status === "fulfilled" ? (m5[h6] = "loaded", S13.push(h6), i = i.replace(k14, __spreadProps(__spreadValues({}, O10), { children: o2.value }))) : (v10.delete(h6), Reflect.deleteProperty(m5, h6), T7.push({ node: O10, error: o2.reason, indexPath: k14, valuePath: Z14 }));
      }), n.set("loadingStatus", m5), S13.length && (n.set("expandedValue", (o2) => Do(Hn(o2, ...S13))), (_a2 = a3("onLoadChildrenComplete")) == null ? void 0 : _a2({ collection: i })), T7.length && ((_b = a3("onLoadChildrenError")) == null ? void 0 : _b({ nodes: T7 }));
    });
  }
  function b9(e4) {
    let { prop: t, context: n } = e4;
    return function({ indexPath: l4 }) {
      return t("collection").getValuePath(l4).slice(0, -1).some((d4) => !n.get("expandedValue").includes(d4));
    };
  }
  function w9(e4, t) {
    let { prop: n, scope: a3, computed: l4 } = e4, s = n("scrollToIndexFn");
    if (!s) return false;
    let d4 = n("collection"), r3 = l4("visibleNodes");
    for (let u3 = 0; u3 < r3.length; u3++) {
      let { node: p4, indexPath: V16 } = r3[u3];
      if (d4.getNodeValue(p4) === t) return s({ index: u3, node: p4, indexPath: V16, getElement: () => a3.getById(se12(a3, t)) }), true;
    }
    return false;
  }
  function Ie9(e4) {
    var _a2;
    let n = e4.querySelectorAll('[data-scope="tree-view"][data-part="branch"], [data-scope="tree-view"][data-part="item"]'), a3 = [];
    for (let s of n) {
      let d4 = s.getAttribute("data-path"), r3 = s.getAttribute("data-value");
      if (d4 == null || r3 == null) continue;
      let u3 = d4.split("/").map((N10) => parseInt(N10, 10));
      if (u3.some(Number.isNaN)) continue;
      let p4 = (_a2 = s.getAttribute("data-name")) != null ? _a2 : r3, V16 = s.getAttribute("data-part") === "branch";
      a3.push({ pathArr: u3, id: r3, name: p4, isBranch: V16 });
    }
    a3.sort((s, d4) => {
      let r3 = Math.min(s.pathArr.length, d4.pathArr.length);
      for (let u3 = 0; u3 < r3; u3++) if (s.pathArr[u3] !== d4.pathArr[u3]) return s.pathArr[u3] - d4.pathArr[u3];
      return s.pathArr.length - d4.pathArr.length;
    });
    let l4 = { id: "ROOT", name: "", children: [] };
    for (let { pathArr: s, id: d4, name: r3, isBranch: u3 } of a3) {
      let p4 = l4;
      for (let N10 = 0; N10 < s.length - 1; N10++) {
        let v10 = s[N10];
        p4.children || (p4.children = []), p4 = p4.children[v10];
      }
      let V16 = s[s.length - 1];
      p4.children || (p4.children = []), p4.children[V16] = u3 ? { id: d4, name: r3, children: [] } : { id: d4, name: r3 };
    }
    return l4;
  }
  var Re8, C16, J14, Le9, Ce9, se12, le11, x13, be9, Te8, y10, Pe9, Be9, We8, we7, je8, Q16, ze9;
  var init_tree_view = __esm({
    "../priv/static/tree-view.mjs"() {
      "use strict";
      init_chunk_MMRG4CGO();
      init_chunk_IYURAQ6S();
      Re8 = G("tree-view").parts("branch", "branchContent", "branchControl", "branchIndentGuide", "branchIndicator", "branchText", "branchTrigger", "item", "itemIndicator", "itemText", "label", "nodeCheckbox", "nodeRenameInput", "root", "tree");
      C16 = Re8.build();
      J14 = (e4) => new at2(e4);
      J14.empty = () => new at2({ rootNode: { children: [] } });
      Le9 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.root) != null ? _b : `tree:${e4.id}:root`;
      };
      Ce9 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.label) != null ? _b : `tree:${e4.id}:label`;
      };
      se12 = (e4, t) => {
        var _a2, _b, _c;
        return (_c = (_b = (_a2 = e4.ids) == null ? void 0 : _a2.node) == null ? void 0 : _b.call(_a2, t)) != null ? _c : `tree:${e4.id}:node:${t}`;
      };
      le11 = (e4) => {
        var _a2, _b;
        return (_b = (_a2 = e4.ids) == null ? void 0 : _a2.tree) != null ? _b : `tree:${e4.id}:tree`;
      };
      x13 = (e4, t) => {
        var _a2;
        t != null && ((_a2 = e4.getById(se12(e4, t))) == null ? void 0 : _a2.focus());
      };
      be9 = (e4, t) => `tree:${e4.id}:rename-input:${t}`;
      Te8 = (e4, t) => e4.getById(be9(e4, t));
      ({ and: y10 } = dr());
      Pe9 = { props({ props: e4 }) {
        return __spreadValues({ selectionMode: "single", collection: J14.empty(), typeahead: true, expandOnClick: true, defaultExpandedValue: [], defaultSelectedValue: [] }, e4);
      }, initialState() {
        return "idle";
      }, context({ prop: e4, bindable: t, getContext: n }) {
        return { expandedValue: t(() => ({ defaultValue: e4("defaultExpandedValue"), value: e4("expandedValue"), isEqual: V, onChange(a3) {
          var _a2;
          let s = n().get("focusedValue");
          (_a2 = e4("onExpandedChange")) == null ? void 0 : _a2({ expandedValue: a3, focusedValue: s, get expandedNodes() {
            return e4("collection").findNodes(a3);
          } });
        } })), selectedValue: t(() => ({ defaultValue: e4("defaultSelectedValue"), value: e4("selectedValue"), isEqual: V, onChange(a3) {
          var _a2;
          let s = n().get("focusedValue");
          (_a2 = e4("onSelectionChange")) == null ? void 0 : _a2({ selectedValue: a3, focusedValue: s, get selectedNodes() {
            return e4("collection").findNodes(a3);
          } });
        } })), focusedValue: t(() => ({ defaultValue: e4("defaultFocusedValue") || null, value: e4("focusedValue"), onChange(a3) {
          var _a2;
          (_a2 = e4("onFocusChange")) == null ? void 0 : _a2({ focusedValue: a3, get focusedNode() {
            return a3 ? e4("collection").findNode(a3) : null;
          } });
        } })), loadingStatus: t(() => ({ defaultValue: {} })), checkedValue: t(() => ({ defaultValue: e4("defaultCheckedValue") || [], value: e4("checkedValue"), isEqual: V, onChange(a3) {
          var _a2;
          (_a2 = e4("onCheckedChange")) == null ? void 0 : _a2({ checkedValue: a3 });
        } })), renamingValue: t(() => ({ sync: true, defaultValue: null })) };
      }, refs() {
        return { typeaheadState: __spreadValues({}, xo.defaultOptions), pendingAborts: /* @__PURE__ */ new Map() };
      }, computed: { isMultipleSelection: ({ prop: e4 }) => e4("selectionMode") === "multiple", isTypingAhead: ({ refs: e4 }) => e4.get("typeaheadState").keysSoFar.length > 0, visibleNodes: ({ prop: e4, context: t }) => {
        let n = [];
        return e4("collection").visit({ skip: b9({ prop: e4, context: t }), onEnter: (a3, l4) => {
          n.push({ node: a3, indexPath: l4 });
        } }), n;
      } }, on: { "EXPANDED.SET": { actions: ["setExpanded"] }, "EXPANDED.CLEAR": { actions: ["clearExpanded"] }, "EXPANDED.ALL": { actions: ["expandAllBranches"] }, "BRANCH.EXPAND": { actions: ["expandBranches"] }, "BRANCH.COLLAPSE": { actions: ["collapseBranches"] }, "SELECTED.SET": { actions: ["setSelected"] }, "SELECTED.ALL": [{ guard: y10("isMultipleSelection", "moveFocus"), actions: ["selectAllNodes", "focusTreeLastNode"] }, { guard: "isMultipleSelection", actions: ["selectAllNodes"] }], "SELECTED.CLEAR": { actions: ["clearSelected"] }, "NODE.SELECT": { actions: ["selectNode"] }, "NODE.DESELECT": { actions: ["deselectNode"] }, "CHECKED.TOGGLE": { actions: ["toggleChecked"] }, "CHECKED.SET": { actions: ["setChecked"] }, "CHECKED.CLEAR": { actions: ["clearChecked"] }, "NODE.FOCUS": { actions: ["setFocusedNode"] }, "NODE.ARROW_DOWN": [{ guard: y10("isShiftKey", "isMultipleSelection"), actions: ["focusTreeNextNode", "extendSelectionToNextNode"] }, { actions: ["focusTreeNextNode"] }], "NODE.ARROW_UP": [{ guard: y10("isShiftKey", "isMultipleSelection"), actions: ["focusTreePrevNode", "extendSelectionToPrevNode"] }, { actions: ["focusTreePrevNode"] }], "NODE.ARROW_LEFT": { actions: ["focusBranchNode"] }, "BRANCH_NODE.ARROW_LEFT": [{ guard: "isBranchExpanded", actions: ["collapseBranch"] }, { actions: ["focusBranchNode"] }], "BRANCH_NODE.ARROW_RIGHT": [{ guard: y10("isBranchFocused", "isBranchExpanded"), actions: ["focusBranchFirstNode"] }, { actions: ["expandBranch"] }], "SIBLINGS.EXPAND": { actions: ["expandSiblingBranches"] }, "NODE.HOME": [{ guard: y10("isShiftKey", "isMultipleSelection"), actions: ["extendSelectionToFirstNode", "focusTreeFirstNode"] }, { actions: ["focusTreeFirstNode"] }], "NODE.END": [{ guard: y10("isShiftKey", "isMultipleSelection"), actions: ["extendSelectionToLastNode", "focusTreeLastNode"] }, { actions: ["focusTreeLastNode"] }], "NODE.CLICK": [{ guard: y10("isCtrlKey", "isMultipleSelection"), actions: ["toggleNodeSelection"] }, { guard: y10("isShiftKey", "isMultipleSelection"), actions: ["extendSelectionToNode"] }, { actions: ["selectNode"] }], "BRANCH_NODE.CLICK": [{ guard: y10("isCtrlKey", "isMultipleSelection"), actions: ["toggleNodeSelection"] }, { guard: y10("isShiftKey", "isMultipleSelection"), actions: ["extendSelectionToNode"] }, { guard: "expandOnClick", actions: ["selectNode", "toggleBranchNode"] }, { actions: ["selectNode"] }], "BRANCH_TOGGLE.CLICK": { actions: ["toggleBranchNode"] }, "TREE.TYPEAHEAD": { actions: ["focusMatchedNode"] } }, exit: ["clearPendingAborts"], states: { idle: { on: { "NODE.RENAME": { target: "renaming", actions: ["setRenamingValue"] } } }, renaming: { entry: ["syncRenameInput", "focusRenameInput"], on: { "RENAME.SUBMIT": { guard: "isRenameLabelValid", target: "idle", actions: ["submitRenaming"] }, "RENAME.CANCEL": { target: "idle", actions: ["cancelRenaming"] } } } }, implementations: { guards: { isBranchFocused: ({ context: e4, event: t }) => e4.get("focusedValue") === t.id, isBranchExpanded: ({ context: e4, event: t }) => e4.get("expandedValue").includes(t.id), isShiftKey: ({ event: e4 }) => e4.shiftKey, isCtrlKey: ({ event: e4 }) => e4.ctrlKey, hasSelectedItems: ({ context: e4 }) => e4.get("selectedValue").length > 0, isMultipleSelection: ({ prop: e4 }) => e4("selectionMode") === "multiple", moveFocus: ({ event: e4 }) => !!e4.moveFocus, expandOnClick: ({ prop: e4 }) => !!e4("expandOnClick"), isRenameLabelValid: ({ event: e4 }) => e4.label.trim() !== "" }, actions: { selectNode({ context: e4, event: t }) {
        let n = t.id || t.value;
        e4.set("selectedValue", (a3) => n == null ? a3 : !t.isTrusted && Xn(n) ? a3.concat(...n) : [Xn(n) ? Wn(n) : n].filter(Boolean));
      }, deselectNode({ context: e4, event: t }) {
        let n = Zt(t.id || t.value);
        e4.set("selectedValue", (a3) => Un(a3, ...n));
      }, setFocusedNode({ context: e4, event: t }) {
        e4.set("focusedValue", t.id);
      }, clearFocusedNode({ context: e4 }) {
        e4.set("focusedValue", null);
      }, clearSelectedItem({ context: e4 }) {
        e4.set("selectedValue", []);
      }, toggleBranchNode({ context: e4, event: t, action: n }) {
        let a3 = e4.get("expandedValue").includes(t.id);
        n(a3 ? ["collapseBranch"] : ["expandBranch"]);
      }, expandBranch(e4) {
        let { event: t } = e4;
        Y15(e4, [t.id]);
      }, expandBranches(e4) {
        let { context: t, event: n } = e4, a3 = Zt(n.value);
        Y15(e4, Vo(a3, t.get("expandedValue")));
      }, collapseBranch({ context: e4, event: t }) {
        e4.set("expandedValue", (n) => Un(n, t.id));
      }, collapseBranches(e4) {
        let { context: t, event: n } = e4, a3 = Zt(n.value);
        t.set("expandedValue", (l4) => Un(l4, ...a3));
      }, setExpanded({ context: e4, event: t }) {
        Xn(t.value) && e4.set("expandedValue", t.value);
      }, clearExpanded({ context: e4 }) {
        e4.set("expandedValue", []);
      }, setSelected({ context: e4, event: t }) {
        Xn(t.value) && e4.set("selectedValue", t.value);
      }, clearSelected({ context: e4 }) {
        e4.set("selectedValue", []);
      }, focusTreeFirstNode(e4) {
        let { prop: t, scope: n } = e4, a3 = t("collection"), l4 = a3.getFirstNode(void 0, { skip: b9(e4) });
        if (!l4) return;
        let s = a3.getNodeValue(l4);
        w9(e4, s) ? nt(() => x13(n, s)) : x13(n, s);
      }, focusTreeLastNode(e4) {
        let { prop: t, scope: n } = e4, a3 = t("collection"), l4 = a3.getLastNode(void 0, { skip: b9(e4) }), s = a3.getNodeValue(l4);
        w9(e4, s) ? nt(() => x13(n, s)) : x13(n, s);
      }, focusBranchFirstNode(e4) {
        let { event: t, prop: n, scope: a3 } = e4, l4 = n("collection"), s = l4.findNode(t.id), d4 = l4.getFirstNode(s, { skip: b9(e4) });
        if (!d4) return;
        let r3 = l4.getNodeValue(d4);
        w9(e4, r3) ? nt(() => x13(a3, r3)) : x13(a3, r3);
      }, focusTreeNextNode(e4) {
        let { event: t, prop: n, scope: a3 } = e4, l4 = n("collection"), s = l4.getNextNode(t.id, { skip: b9(e4) });
        if (!s) return;
        let d4 = l4.getNodeValue(s);
        w9(e4, d4) ? nt(() => x13(a3, d4)) : x13(a3, d4);
      }, focusTreePrevNode(e4) {
        let { event: t, prop: n, scope: a3 } = e4, l4 = n("collection"), s = l4.getPreviousNode(t.id, { skip: b9(e4) });
        if (!s) return;
        let d4 = l4.getNodeValue(s);
        w9(e4, d4) ? nt(() => x13(a3, d4)) : x13(a3, d4);
      }, focusBranchNode(e4) {
        let { event: t, prop: n, scope: a3 } = e4, l4 = n("collection"), s = l4.getParentNode(t.id), d4 = s ? l4.getNodeValue(s) : void 0;
        if (!d4) return;
        w9(e4, d4) ? nt(() => x13(a3, d4)) : x13(a3, d4);
      }, selectAllNodes({ context: e4, prop: t }) {
        e4.set("selectedValue", t("collection").getValues());
      }, focusMatchedNode(e4) {
        let { context: t, prop: n, refs: a3, event: l4, scope: s, computed: d4 } = e4, u3 = d4("visibleNodes").map(({ node: N10 }) => ({ textContent: n("collection").stringifyNode(N10), id: n("collection").getNodeValue(N10) })), p4 = xo(u3, { state: a3.get("typeaheadState"), activeId: t.get("focusedValue"), key: l4.key });
        if (!(p4 == null ? void 0 : p4.id)) return;
        w9(e4, p4.id) ? nt(() => x13(s, p4.id)) : x13(s, p4.id);
      }, toggleNodeSelection({ context: e4, event: t }) {
        let n = Ko(e4.get("selectedValue"), t.id);
        e4.set("selectedValue", n);
      }, expandAllBranches(e4) {
        let { context: t, prop: n } = e4, a3 = n("collection").getBranchValues(), l4 = Vo(a3, t.get("expandedValue"));
        Y15(e4, l4);
      }, expandSiblingBranches(e4) {
        let { context: t, event: n, prop: a3 } = e4, l4 = a3("collection"), s = l4.getIndexPath(n.id);
        if (!s) return;
        let r3 = l4.getSiblingNodes(s).map((p4) => l4.getNodeValue(p4)), u3 = Vo(r3, t.get("expandedValue"));
        Y15(e4, u3);
      }, extendSelectionToNode(e4) {
        let { context: t, event: n, prop: a3, computed: l4 } = e4, s = a3("collection"), d4 = Io(t.get("selectedValue")) || s.getNodeValue(s.getFirstNode()), r3 = n.id, u3 = [d4, r3], p4 = 0;
        l4("visibleNodes").forEach(({ node: N10 }) => {
          let v10 = s.getNodeValue(N10);
          p4 === 1 && u3.push(v10), (v10 === d4 || v10 === r3) && p4++;
        }), t.set("selectedValue", Do(u3));
      }, extendSelectionToNextNode(e4) {
        let { context: t, event: n, prop: a3 } = e4, l4 = a3("collection"), s = l4.getNextNode(n.id, { skip: b9(e4) });
        if (!s) return;
        let d4 = new Set(t.get("selectedValue")), r3 = l4.getNodeValue(s);
        r3 != null && (d4.has(n.id) && d4.has(r3) ? d4.delete(n.id) : d4.has(r3) || d4.add(r3), t.set("selectedValue", Array.from(d4)));
      }, extendSelectionToPrevNode(e4) {
        let { context: t, event: n, prop: a3 } = e4, l4 = a3("collection"), s = l4.getPreviousNode(n.id, { skip: b9(e4) });
        if (!s) return;
        let d4 = new Set(t.get("selectedValue")), r3 = l4.getNodeValue(s);
        r3 != null && (d4.has(n.id) && d4.has(r3) ? d4.delete(n.id) : d4.has(r3) || d4.add(r3), t.set("selectedValue", Array.from(d4)));
      }, extendSelectionToFirstNode(e4) {
        let { context: t, prop: n } = e4, a3 = n("collection"), l4 = Io(t.get("selectedValue")), s = [];
        a3.visit({ skip: b9(e4), onEnter: (d4) => {
          let r3 = a3.getNodeValue(d4);
          if (s.push(r3), r3 === l4) return "stop";
        } }), t.set("selectedValue", s);
      }, extendSelectionToLastNode(e4) {
        let { context: t, prop: n } = e4, a3 = n("collection"), l4 = Io(t.get("selectedValue")), s = [], d4 = false;
        a3.visit({ skip: b9(e4), onEnter: (r3) => {
          let u3 = a3.getNodeValue(r3);
          u3 === l4 && (d4 = true), d4 && s.push(u3);
        } }), t.set("selectedValue", s);
      }, clearPendingAborts({ refs: e4 }) {
        let t = e4.get("pendingAborts");
        t.forEach((n) => n.abort()), t.clear();
      }, toggleChecked({ context: e4, event: t, prop: n }) {
        let a3 = n("collection");
        e4.set("checkedValue", (l4) => t.isBranch ? De8(a3, t.value, l4) : Ko(l4, t.value));
      }, setChecked({ context: e4, event: t }) {
        e4.set("checkedValue", t.value);
      }, clearChecked({ context: e4 }) {
        e4.set("checkedValue", []);
      }, setRenamingValue({ context: e4, event: t, prop: n }) {
        e4.set("renamingValue", t.value);
        let a3 = n("onRenameStart");
        if (a3) {
          let l4 = n("collection"), s = l4.getIndexPath(t.value);
          if (s) {
            let d4 = l4.at(s);
            d4 && a3({ value: t.value, node: d4, indexPath: s });
          }
        }
      }, submitRenaming({ context: e4, event: t, prop: n, scope: a3 }) {
        var _a2;
        let l4 = e4.get("renamingValue");
        if (!l4) return;
        let d4 = n("collection").getIndexPath(l4);
        if (!d4) return;
        let r3 = t.label.trim(), u3 = n("onBeforeRename");
        if (u3 && !u3({ value: l4, label: r3, indexPath: d4 })) {
          e4.set("renamingValue", null), x13(a3, l4);
          return;
        }
        (_a2 = n("onRenameComplete")) == null ? void 0 : _a2({ value: l4, label: r3, indexPath: d4 }), e4.set("renamingValue", null), x13(a3, l4);
      }, cancelRenaming({ context: e4, scope: t }) {
        let n = e4.get("renamingValue");
        e4.set("renamingValue", null), n && x13(t, n);
      }, syncRenameInput({ context: e4, scope: t, prop: n }) {
        let a3 = e4.get("renamingValue");
        if (!a3) return;
        let l4 = n("collection"), s = l4.findNode(a3);
        if (!s) return;
        let d4 = l4.stringifyNode(s), r3 = Te8(t, a3);
        sn(r3, d4);
      }, focusRenameInput({ context: e4, scope: t }) {
        let n = e4.get("renamingValue");
        if (!n) return;
        let a3 = Te8(t, n);
        a3 && (a3.focus(), a3.select());
      } } } };
      Be9 = As()(["ids", "collection", "dir", "expandedValue", "expandOnClick", "defaultFocusedValue", "focusedValue", "getRootNode", "id", "onExpandedChange", "onFocusChange", "onSelectionChange", "checkedValue", "selectedValue", "selectionMode", "typeahead", "defaultExpandedValue", "defaultSelectedValue", "defaultCheckedValue", "onCheckedChange", "onLoadChildrenComplete", "onLoadChildrenError", "loadChildren", "canRename", "onRenameStart", "onBeforeRename", "onRenameComplete", "scrollToIndexFn"]);
      We8 = as(Be9);
      we7 = As()(["node", "indexPath"]);
      je8 = as(we7);
      Q16 = class extends ve {
        constructor(t, n) {
          var _a2;
          let a3 = (_a2 = n.treeData) != null ? _a2 : Ie9(t), l4 = J14({ nodeToValue: (s) => s.id, nodeToString: (s) => s.name, rootNode: a3 });
          super(t, __spreadProps(__spreadValues({}, n), { collection: l4 }));
          __publicField(this, "treeCollection");
          __publicField(this, "syncTree", () => {
            let t = this.el.querySelector('[data-scope="tree-view"][data-part="tree"]');
            t && (this.spreadProps(t, this.api.getTreeProps()), this.updateExistingTree(t));
          });
          this.treeCollection = l4;
        }
        initMachine(t) {
          return new Ls(Pe9, __spreadValues({}, t));
        }
        initApi() {
          return Ae7(this.machine.service, Cs);
        }
        getNodeAt(t) {
          var _a2;
          if (t.length === 0) return;
          let n = this.treeCollection.rootNode;
          for (let a3 of t) if (n = (_a2 = n == null ? void 0 : n.children) == null ? void 0 : _a2[a3], !n) return;
          return n;
        }
        updateExistingTree(t) {
          this.spreadProps(t, this.api.getTreeProps());
          let n = t.querySelectorAll('[data-scope="tree-view"][data-part="branch"]');
          for (let l4 of n) {
            let s = l4.getAttribute("data-path");
            if (s == null) continue;
            let d4 = s.split("/").map((M10) => parseInt(M10, 10)), r3 = this.getNodeAt(d4);
            if (!r3) continue;
            let u3 = { indexPath: d4, node: r3 };
            this.spreadProps(l4, this.api.getBranchProps(u3));
            let p4 = l4.querySelector('[data-scope="tree-view"][data-part="branch-control"]');
            p4 && this.spreadProps(p4, this.api.getBranchControlProps(u3));
            let V16 = l4.querySelector('[data-scope="tree-view"][data-part="branch-text"]');
            V16 && this.spreadProps(V16, this.api.getBranchTextProps(u3));
            let N10 = l4.querySelector('[data-scope="tree-view"][data-part="branch-indicator"]');
            N10 && this.spreadProps(N10, this.api.getBranchIndicatorProps(u3));
            let v10 = l4.querySelector('[data-scope="tree-view"][data-part="branch-content"]');
            v10 && this.spreadProps(v10, this.api.getBranchContentProps(u3));
            let D11 = l4.querySelector('[data-scope="tree-view"][data-part="branch-indent-guide"]');
            D11 && this.spreadProps(D11, this.api.getBranchIndentGuideProps(u3));
          }
          let a3 = t.querySelectorAll('[data-scope="tree-view"][data-part="item"]');
          for (let l4 of a3) {
            let s = l4.getAttribute("data-path");
            if (s == null) continue;
            let d4 = s.split("/").map((p4) => parseInt(p4, 10)), r3 = this.getNodeAt(d4);
            if (!r3) continue;
            let u3 = { indexPath: d4, node: r3 };
            this.spreadProps(l4, this.api.getItemProps(u3));
          }
        }
        render() {
          var _a2;
          let t = (_a2 = this.el.querySelector('[data-scope="tree-view"][data-part="root"]')) != null ? _a2 : this.el;
          this.spreadProps(t, this.api.getRootProps());
          let n = this.el.querySelector('[data-scope="tree-view"][data-part="label"]');
          n && this.spreadProps(n, this.api.getLabelProps()), this.syncTree();
        }
      };
      ze9 = { mounted() {
        var _a2;
        let e4 = this.el, t = this.pushEvent.bind(this), n = new Q16(e4, __spreadProps(__spreadValues({ id: e4.id }, _r(e4, "controlled") ? { expandedValue: Cr(e4, "expandedValue"), selectedValue: Cr(e4, "selectedValue") } : { defaultExpandedValue: Cr(e4, "defaultExpandedValue"), defaultSelectedValue: Cr(e4, "defaultSelectedValue") }), { selectionMode: (_a2 = xr(e4, "selectionMode", ["single", "multiple"])) != null ? _a2 : "single", dir: kr(e4), onSelectionChange: (a3) => {
          var _a3;
          let l4 = _r(e4, "redirect"), s = ((_a3 = a3.selectedValue) == null ? void 0 : _a3.length) ? a3.selectedValue[0] : void 0, d4 = [...e4.querySelectorAll('[data-scope="tree-view"][data-part="item"], [data-scope="tree-view"][data-part="branch"]')].find((v10) => v10.getAttribute("data-value") === s), r3 = (d4 == null ? void 0 : d4.getAttribute("data-part")) === "item", u3 = d4 == null ? void 0 : d4.getAttribute("data-redirect"), p4 = d4 == null ? void 0 : d4.hasAttribute("data-new-tab");
          l4 && s && r3 && this.liveSocket.main.isDead && u3 !== "false" && (p4 ? window.open(s, "_blank", "noopener,noreferrer") : window.location.href = s);
          let N10 = xr(e4, "onSelectionChange");
          N10 && this.liveSocket.main.isConnected() && t(N10, { id: e4.id, value: __spreadProps(__spreadValues({}, a3), { isItem: r3 != null ? r3 : false }) });
        }, onExpandedChange: (a3) => {
          let l4 = xr(e4, "onExpandedChange");
          l4 && this.liveSocket.main.isConnected() && t(l4, { id: e4.id, value: a3 });
        } }));
        n.init(), this.treeView = n, this.onSetExpandedValue = (a3) => {
          let { value: l4 } = a3.detail;
          n.api.setExpandedValue(l4);
        }, e4.addEventListener("phx:tree-view:set-expanded-value", this.onSetExpandedValue), this.onSetSelectedValue = (a3) => {
          let { value: l4 } = a3.detail;
          n.api.setSelectedValue(l4);
        }, e4.addEventListener("phx:tree-view:set-selected-value", this.onSetSelectedValue), this.handlers = [], this.handlers.push(this.handleEvent("tree_view_set_expanded_value", (a3) => {
          let l4 = a3.tree_view_id;
          l4 && e4.id !== l4 && e4.id !== `tree-view:${l4}` || n.api.setExpandedValue(a3.value);
        })), this.handlers.push(this.handleEvent("tree_view_set_selected_value", (a3) => {
          let l4 = a3.tree_view_id;
          l4 && e4.id !== l4 && e4.id !== `tree-view:${l4}` || n.api.setSelectedValue(a3.value);
        })), this.handlers.push(this.handleEvent("tree_view_expanded_value", () => {
          t("tree_view_expanded_value_response", { value: n.api.expandedValue });
        })), this.handlers.push(this.handleEvent("tree_view_selected_value", () => {
          t("tree_view_selected_value_response", { value: n.api.selectedValue });
        }));
      }, updated() {
        var _a2;
        _r(this.el, "controlled") && ((_a2 = this.treeView) == null ? void 0 : _a2.updateProps({ expandedValue: Cr(this.el, "expandedValue"), selectedValue: Cr(this.el, "selectedValue") }));
      }, destroyed() {
        var _a2;
        if (this.onSetExpandedValue && this.el.removeEventListener("phx:tree-view:set-expanded-value", this.onSetExpandedValue), this.onSetSelectedValue && this.el.removeEventListener("phx:tree-view:set-selected-value", this.onSetSelectedValue), this.handlers) for (let e4 of this.handlers) this.removeHandleEvent(e4);
        (_a2 = this.treeView) == null ? void 0 : _a2.destroy();
      } };
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
        var _a3, _b;
        (_b = (_a3 = this._realHook) == null ? void 0 : _a3.updated) == null ? void 0 : _b.call(this);
      },
      destroyed() {
        var _a3, _b;
        (_b = (_a3 = this._realHook) == null ? void 0 : _a3.destroyed) == null ? void 0 : _b.call(this);
      },
      disconnected() {
        var _a3, _b;
        (_b = (_a3 = this._realHook) == null ? void 0 : _a3.disconnected) == null ? void 0 : _b.call(this);
      },
      reconnected() {
        var _a3, _b;
        (_b = (_a3 = this._realHook) == null ? void 0 : _a3.reconnected) == null ? void 0 : _b.call(this);
      },
      beforeUpdate() {
        var _a3, _b;
        (_b = (_a3 = this._realHook) == null ? void 0 : _a3.beforeUpdate) == null ? void 0 : _b.call(this);
      }
    };
  }
  var Hooks = {
    Accordion: hooks(() => Promise.resolve().then(() => (init_accordion(), accordion_exports)), "Accordion"),
    AngleSlider: hooks(() => Promise.resolve().then(() => (init_angle_slider(), angle_slider_exports)), "AngleSlider"),
    Avatar: hooks(() => Promise.resolve().then(() => (init_avatar(), avatar_exports)), "Avatar"),
    Carousel: hooks(() => Promise.resolve().then(() => (init_carousel(), carousel_exports)), "Carousel"),
    Checkbox: hooks(() => Promise.resolve().then(() => (init_checkbox(), checkbox_exports)), "Checkbox"),
    Clipboard: hooks(() => Promise.resolve().then(() => (init_clipboard(), clipboard_exports)), "Clipboard"),
    Collapsible: hooks(() => Promise.resolve().then(() => (init_collapsible(), collapsible_exports)), "Collapsible"),
    Combobox: hooks(() => Promise.resolve().then(() => (init_combobox(), combobox_exports)), "Combobox"),
    DatePicker: hooks(() => Promise.resolve().then(() => (init_date_picker(), date_picker_exports)), "DatePicker"),
    Dialog: hooks(() => Promise.resolve().then(() => (init_dialog(), dialog_exports)), "Dialog"),
    Editable: hooks(() => Promise.resolve().then(() => (init_editable(), editable_exports)), "Editable"),
    FloatingPanel: hooks(() => Promise.resolve().then(() => (init_floating_panel(), floating_panel_exports)), "FloatingPanel"),
    Listbox: hooks(() => Promise.resolve().then(() => (init_listbox(), listbox_exports)), "Listbox"),
    Menu: hooks(() => Promise.resolve().then(() => (init_menu(), menu_exports)), "Menu"),
    NumberInput: hooks(() => Promise.resolve().then(() => (init_number_input(), number_input_exports)), "NumberInput"),
    PasswordInput: hooks(() => Promise.resolve().then(() => (init_password_input(), password_input_exports)), "PasswordInput"),
    PinInput: hooks(() => Promise.resolve().then(() => (init_pin_input(), pin_input_exports)), "PinInput"),
    RadioGroup: hooks(() => Promise.resolve().then(() => (init_radio_group(), radio_group_exports)), "RadioGroup"),
    Select: hooks(() => Promise.resolve().then(() => (init_select(), select_exports)), "Select"),
    SignaturePad: hooks(() => Promise.resolve().then(() => (init_signature_pad(), signature_pad_exports)), "SignaturePad"),
    Switch: hooks(() => Promise.resolve().then(() => (init_switch(), switch_exports)), "Switch"),
    Tabs: hooks(() => Promise.resolve().then(() => (init_tabs(), tabs_exports)), "Tabs"),
    Timer: hooks(() => Promise.resolve().then(() => (init_timer(), timer_exports)), "Timer"),
    Toast: hooks(() => Promise.resolve().then(() => (init_toast(), toast_exports)), "Toast"),
    ToggleGroup: hooks(() => Promise.resolve().then(() => (init_toggle_group(), toggle_group_exports)), "ToggleGroup"),
    TreeView: hooks(() => Promise.resolve().then(() => (init_tree_view(), tree_view_exports)), "TreeView")
  };
  var corex_default = Hooks;
  return __toCommonJS(corex_exports);
})();
