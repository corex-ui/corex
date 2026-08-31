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
  Collapsible: createLazyHook(() => import("corex/collapsible"), "Collapsible"),
  Combobox: createLazyHook(() => import("corex/combobox"), "Combobox"),
  ColorPicker: createLazyHook(() => import("corex/color-picker"), "ColorPicker"),
  DatePicker: createLazyHook(() => import("corex/date-picker"), "DatePicker"),
  Dialog: createLazyHook(() => import("corex/dialog"), "Dialog"),
  Drawer: createLazyHook(() => import("corex/drawer"), "Drawer"),
  Editable: createLazyHook(() => import("corex/editable"), "Editable"),
  FileUpload: createLazyHook(() => import("corex/file-upload"), "FileUpload"),
  FloatingPanel: createLazyHook(() => import("corex/floating-panel"), "FloatingPanel"),
  HoverCard: createLazyHook(() => import("corex/hover-card"), "HoverCard"),
  Listbox: createLazyHook(() => import("corex/listbox"), "Listbox"),
  Marquee: createLazyHook(() => import("corex/marquee"), "Marquee"),
  Menu: createLazyHook(() => import("corex/menu"), "Menu"),
  NumberInput: createLazyHook(() => import("corex/number-input"), "NumberInput"),
  Pagination: createLazyHook(() => import("corex/pagination"), "Pagination"),
  PasswordInput: createLazyHook(() => import("corex/password-input"), "PasswordInput"),
  PinInput: createLazyHook(() => import("corex/pin-input"), "PinInput"),
  Popover: createLazyHook(() => import("corex/popover"), "Popover"),
  RadioGroup: createLazyHook(() => import("corex/radio-group"), "RadioGroup"),
  Select: createLazyHook(() => import("corex/select"), "Select"),
  SignaturePad: createLazyHook(() => import("corex/signature-pad"), "SignaturePad"),
  Slider: createLazyHook(() => import("corex/slider"), "Slider"),
  Switch: createLazyHook(() => import("corex/switch"), "Switch"),
  TagsInput: createLazyHook(() => import("corex/tags-input"), "TagsInput"),
  Tabs: createLazyHook(() => import("corex/tabs"), "Tabs"),
  Timer: createLazyHook(() => import("corex/timer"), "Timer"),
  Toast: createLazyHook(() => import("corex/toast"), "Toast"),
  Tooltip: createLazyHook(() => import("corex/tooltip"), "Tooltip"),
  Toggle: createLazyHook(() => import("corex/toggle"), "Toggle"),
  ToggleGroup: createLazyHook(() => import("corex/toggle-group"), "ToggleGroup"),
  Progress: createLazyHook(() => import("corex/progress"), "Progress"),
  RatingGroup: createLazyHook(() => import("corex/rating-group"), "RatingGroup"),
  Steps: createLazyHook(() => import("corex/steps"), "Steps"),
  QrCode: createLazyHook(() => import("corex/qr-code"), "QrCode"),
  Presence: createLazyHook(() => import("corex/presence"), "Presence"),
  Splitter: createLazyHook(() => import("corex/splitter"), "Splitter"),
  ScrollArea: createLazyHook(() => import("corex/scroll-area"), "ScrollArea"),
  Toc: createLazyHook(() => import("corex/toc"), "Toc"),
  DateInput: createLazyHook(() => import("corex/date-input"), "DateInput"),
  ImageCropper: createLazyHook(() => import("corex/image-cropper"), "ImageCropper"),
  NavigationMenu: createLazyHook(() => import("corex/navigation-menu"), "NavigationMenu"),
  CascadeSelect: createLazyHook(() => import("corex/cascade-select"), "CascadeSelect"),
  Tour: createLazyHook(() => import("corex/tour"), "Tour"),
  TreeView: createLazyHook(() => import("corex/tree-view"), "TreeView"),
};

export default Hooks;
