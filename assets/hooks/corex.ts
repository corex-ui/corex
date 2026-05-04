export type {
  AccordionChangedDetail,
  TreeViewExpandedChangedDetail,
  TreeViewSelectionChangedDetail,
  DialogOpenChangedDetail,
} from "../lib/event-details";

export type { Animator, AnimateHeightOptions, AnimateScaleOptions } from "../lib/custom-animation";

export {
  applyClosedHeight,
  applyOpenHeight,
  animateHeightOpen,
  animateHeightClose,
  applyClosedScale,
  applyOpenScale,
  animateScaleOpen,
  animateScaleClose,
  findAccordionContent,
  findTreeBranch,
  findDialogBackdrop,
  findDialogContent,
} from "../lib/custom-animation";

import { createLazyHook } from "./lazy-hook";

export type { HookModule } from "./lazy-hook";

export const Hooks = {
  Accordion: createLazyHook(() => import("corex/accordion"), "Accordion"),
  AngleSlider: createLazyHook(() => import("corex/angle-slider"), "AngleSlider"),
  Avatar: createLazyHook(() => import("corex/avatar"), "Avatar"),
  Carousel: createLazyHook(() => import("corex/carousel"), "Carousel"),
  Checkbox: createLazyHook(() => import("corex/checkbox"), "Checkbox"),
  Clipboard: createLazyHook(() => import("corex/clipboard"), "Clipboard"),
  Code: createLazyHook(() => import("corex/code"), "Code"),
  Collapsible: createLazyHook(() => import("corex/collapsible"), "Collapsible"),
  Combobox: createLazyHook(() => import("corex/combobox"), "Combobox"),
  ColorPicker: createLazyHook(() => import("corex/color-picker"), "ColorPicker"),
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
  Tooltip: createLazyHook(() => import("corex/tooltip"), "Tooltip"),
  ToggleGroup: createLazyHook(() => import("corex/toggle-group"), "ToggleGroup"),
  TreeView: createLazyHook(() => import("corex/tree-view"), "TreeView"),
};

export default Hooks;
