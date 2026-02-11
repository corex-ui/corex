/**
 * Main entry: lazy-loaded hooks. Default export and LazyHooks load each
 * component chunk on first mount.
 */
import type { Hook } from "phoenix_live_view";

type HookModule = Record<string, Hook | undefined>;

function lazyHook(
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

/** Lazy-loaded Corex hooks. Each hook loads its chunk only when first mounted. */
export const LazyHooks = {
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
  ToggleGroup: lazyHook(() => import("corex/toggle-group"), "ToggleGroup"),
};

export { lazyHook };

/** Default export: lazy-loaded hooks (each chunk loads on first mount). */
export default LazyHooks;
