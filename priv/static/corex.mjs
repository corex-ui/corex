// hooks/corex.ts
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
export {
  LazyHooks,
  corex_default as default,
  lazyHook
};
//# sourceMappingURL=corex.mjs.map
