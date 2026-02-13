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
  Hooks: () => Hooks,
  default: () => corex_default,
  hooks: () => hooks
});
module.exports = __toCommonJS(corex_exports);
function hooks(importFn, exportName) {
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
var Hooks = {
  Accordion: hooks(() => import("corex/accordion"), "Accordion"),
  Checkbox: hooks(() => import("corex/checkbox"), "Checkbox"),
  Clipboard: hooks(() => import("corex/clipboard"), "Clipboard"),
  Collapsible: hooks(() => import("corex/collapsible"), "Collapsible"),
  Combobox: hooks(() => import("corex/combobox"), "Combobox"),
  DatePicker: hooks(() => import("corex/date-picker"), "DatePicker"),
  Dialog: hooks(() => import("corex/dialog"), "Dialog"),
  Menu: hooks(() => import("corex/menu"), "Menu"),
  Select: hooks(() => import("corex/select"), "Select"),
  SignaturePad: hooks(() => import("corex/signature-pad"), "SignaturePad"),
  Switch: hooks(() => import("corex/switch"), "Switch"),
  Tabs: hooks(() => import("corex/tabs"), "Tabs"),
  Toast: hooks(() => import("corex/toast"), "Toast"),
  ToggleGroup: hooks(() => import("corex/toggle-group"), "ToggleGroup"),
  TreeView: hooks(() => import("corex/tree-view"), "TreeView")
};
var corex_default = Hooks;
//# sourceMappingURL=corex.cjs.js.map
