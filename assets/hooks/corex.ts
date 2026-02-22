import type { Hook } from "phoenix_live_view";

type HookModule = Record<string, Hook<object, HTMLElement> | undefined>;

function createLazyHook(importFn: () => Promise<HookModule>, exportName: string): Hook {
  return {
    async mounted() {
      const mod = await importFn();
      const real = mod[exportName];
      (this as { _realHook?: Hook<object, HTMLElement> })._realHook = real;
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
  Accordion: createLazyHook(() => import("corex/accordion"), "Accordion"),
  AngleSlider: createLazyHook(() => import("corex/angle-slider"), "AngleSlider"),
  Avatar: createLazyHook(() => import("corex/avatar"), "Avatar"),
  Carousel: createLazyHook(() => import("corex/carousel"), "Carousel"),
  Checkbox: createLazyHook(() => import("corex/checkbox"), "Checkbox"),
  Clipboard: createLazyHook(() => import("corex/clipboard"), "Clipboard"),
  Collapsible: createLazyHook(() => import("corex/collapsible"), "Collapsible"),
  Combobox: createLazyHook(() => import("corex/combobox"), "Combobox"),
  DatePicker: createLazyHook(() => import("corex/date-picker"), "DatePicker"),
  Dialog: createLazyHook(() => import("corex/dialog"), "Dialog"),
  Editable: createLazyHook(() => import("corex/editable"), "Editable"),
  FloatingPanel: createLazyHook(() => import("corex/floating-panel"), "FloatingPanel"),
  Listbox: createLazyHook(() => import("corex/listbox"), "Listbox"),
  Marquee: createLazyHook(() => import("corex/marquee"), "Marquee"),
  Menu: createLazyHook(() => import("corex/menu"), "Menu"),
  NumberInput: createLazyHook(() => import("corex/number-input"), "NumberInput"),
  PasswordInput: createLazyHook(() => import("corex/password-input"), "PasswordInput"),
  PinInput: createLazyHook(() => import("corex/pin-input"), "PinInput"),
  RadioGroup: createLazyHook(() => import("corex/radio-group"), "RadioGroup"),
  Select: createLazyHook(() => import("corex/select"), "Select"),
  SignaturePad: createLazyHook(() => import("corex/signature-pad"), "SignaturePad"),
  Switch: createLazyHook(() => import("corex/switch"), "Switch"),
  Tabs: createLazyHook(() => import("corex/tabs"), "Tabs"),
  Timer: createLazyHook(() => import("corex/timer"), "Timer"),
  Toast: createLazyHook(() => import("corex/toast"), "Toast"),
  ToggleGroup: createLazyHook(() => import("corex/toggle-group"), "ToggleGroup"),
  TreeView: createLazyHook(() => import("corex/tree-view"), "TreeView"),
};

export function hooks<T extends keyof typeof Hooks>(
  componentNames: readonly T[]
): Pick<typeof Hooks, T> {
  return Object.fromEntries(
    componentNames.filter((name): name is T => name in Hooks).map((name) => [name, Hooks[name]])
  ) as Pick<typeof Hooks, T>;
}

export default Hooks;
