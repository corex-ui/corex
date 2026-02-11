"use strict";
var __create = Object.create;
var __defProp = Object.defineProperty;
var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
var __getOwnPropNames = Object.getOwnPropertyNames;
var __getProtoOf = Object.getPrototypeOf;
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
var __toESM = (mod, isNodeMode, target) => (target = mod != null ? __create(__getProtoOf(mod)) : {}, __copyProps(
  // If the importer is in node compatibility mode or this is not an ESM
  // file that has been converted to a CommonJS file using a Babel-
  // compatible transform (i.e. "__esModule" has not been set), then set
  // "default" to the CommonJS "module.exports" for node compatibility.
  isNodeMode || !mod || !mod.__esModule ? __defProp(target, "default", { value: mod, enumerable: true }) : target,
  mod
));
var __toCommonJS = (mod) => __copyProps(__defProp({}, "__esModule", { value: true }), mod);

// hooks/corex.ts
var corex_exports = {};
__export(corex_exports, {
  LazyHooks: () => LazyHooks,
  default: () => corex_default,
  lazyHook: () => lazyHook
});
module.exports = __toCommonJS(corex_exports);
function lazyHook(importFn, exportName) {
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
var LazyHooks = {
  Accordion: lazyHook(() => import("corex/accordion"), "Accordion"),
  Checkbox: lazyHook(() => import("corex/checkbox"), "Checkbox"),
  Clipboard: lazyHook(() => import("corex/clipboard"), "Clipboard"),
  Collapsible: lazyHook(() => import("corex/collapsible"), "Collapsible"),
  Combobox: lazyHook(() => import("corex/combobox"), "Combobox"),
  DatePicker: lazyHook(() => import("corex/date-picker"), "DatePicker"),
  Dialog: lazyHook(() => import("corex/dialog"), "Dialog"),
  Menu: lazyHook(() => import("corex/menu"), "Menu"),
  Select: lazyHook(() => import("corex/select"), "Select"),
  SignaturePad: lazyHook(() => import("corex/signature-pad"), "SignaturePad"),
  Switch: lazyHook(() => import("corex/switch"), "Switch"),
  Tabs: lazyHook(() => import("corex/tabs"), "Tabs"),
  Toast: lazyHook(() => import("corex/toast"), "Toast"),
  ToggleGroup: lazyHook(() => import("corex/toggle-group"), "ToggleGroup")
};
var corex_default = LazyHooks;
//# sourceMappingURL=corex.cjs.js.map
