// hooks/corex.ts
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
export {
  Hooks,
  corex_default as default,
  hooks
};
//# sourceMappingURL=corex.mjs.map
