import type { Hook } from "phoenix_live_view";

type HookModule = Record<string, Hook<any, any> | undefined>;

function hooks(
  importFn: () => Promise<HookModule>,
  exportName: string
): Hook {
  return {
    async mounted() {
      const mod = await importFn();
      const real = mod[exportName];
      (this as { _realHook?: Hook })._realHook = real;
      if (real?.mounted) return real.mounted.call(this);
    },
    updated() {
      (this as { _realHook?: Hook })._realHook?.updated?.call(this);
    },
    destroyed() {
      (this as { _realHook?: Hook })._realHook?.destroyed?.call(this);
    },
    disconnected() {
      (this as { _realHook?: Hook })._realHook?.disconnected?.call(this);
    },
    reconnected() {
      (this as { _realHook?: Hook })._realHook?.reconnected?.call(this);
    },
    beforeUpdate() {
      (this as { _realHook?: Hook })._realHook?.beforeUpdate?.call(this);
    },
  };
}

export const Hooks = {
  Accordion: hooks(() => import("./accordion"), "Accordion"),
  Checkbox: hooks(() => import("./checkbox"), "Checkbox"),
  Clipboard: hooks(() => import("./clipboard"), "Clipboard"),
  Collapsible: hooks(() => import("./collapsible"), "Collapsible"),
  Combobox: hooks(() => import("./combobox"), "Combobox"),
  DatePicker: hooks(() => import("./date-picker"), "DatePicker"),
  Dialog: hooks(() => import("./dialog"), "Dialog"),
  Menu: hooks(() => import("./menu"), "Menu"),
  Select: hooks(() => import("./select"), "Select"),
  SignaturePad: hooks(() => import("./signature-pad"), "SignaturePad"),
  Switch: hooks(() => import("./switch"), "Switch"),
  Tabs: hooks(() => import("./tabs"), "Tabs"),
  Toast: hooks(() => import("./toast"), "Toast"),
  ToggleGroup: hooks(() => import("./toggle-group"), "ToggleGroup"),
  TreeView: hooks(() => import("./tree-view"), "TreeView"),
};

export { hooks };

export default Hooks;
