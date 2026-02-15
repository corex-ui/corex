import type { Hook } from "phoenix_live_view";

type HookModule = Record<string, Hook<any, HTMLElement> | undefined>;

function hooks(importFn: () => Promise<HookModule>, exportName: string): Hook {
  return {
    async mounted() {
      const mod = await importFn();
      const real = mod[exportName];
      (this as { _realHook?: Hook<any, HTMLElement> })._realHook = real;
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
  Accordion: hooks(() => import("corex/accordion"), "Accordion"),
  AngleSlider: hooks(() => import("corex/angle-slider"), "AngleSlider"),
  Avatar: hooks(() => import("corex/avatar"), "Avatar"),
  Carousel: hooks(() => import("corex/carousel"), "Carousel"),
  Checkbox: hooks(() => import("corex/checkbox"), "Checkbox"),
  Clipboard: hooks(() => import("corex/clipboard"), "Clipboard"),
  Collapsible: hooks(() => import("corex/collapsible"), "Collapsible"),
  Combobox: hooks(() => import("corex/combobox"), "Combobox"),
  DatePicker: hooks(() => import("corex/date-picker"), "DatePicker"),
  Dialog: hooks(() => import("corex/dialog"), "Dialog"),
  Editable: hooks(() => import("corex/editable"), "Editable"),
  FloatingPanel: hooks(() => import("corex/floating-panel"), "FloatingPanel"),
  Listbox: hooks(() => import("corex/listbox"), "Listbox"),
  Menu: hooks(() => import("corex/menu"), "Menu"),
  NumberInput: hooks(() => import("corex/number-input"), "NumberInput"),
  PasswordInput: hooks(() => import("corex/password-input"), "PasswordInput"),
  PinInput: hooks(() => import("corex/pin-input"), "PinInput"),
  RadioGroup: hooks(() => import("corex/radio-group"), "RadioGroup"),
  Select: hooks(() => import("corex/select"), "Select"),
  SignaturePad: hooks(() => import("corex/signature-pad"), "SignaturePad"),
  Switch: hooks(() => import("corex/switch"), "Switch"),
  Tabs: hooks(() => import("corex/tabs"), "Tabs"),
  Timer: hooks(() => import("corex/timer"), "Timer"),
  Toast: hooks(() => import("corex/toast"), "Toast"),
  ToggleGroup: hooks(() => import("corex/toggle-group"), "ToggleGroup"),
  TreeView: hooks(() => import("corex/tree-view"), "TreeView"),
};

export { hooks };

export default Hooks;
