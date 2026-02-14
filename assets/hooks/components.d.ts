/**
 * Type declarations for corex package subpath exports (corex/accordion, etc.).
 * Resolves "Cannot find module 'corex/accordion'" when building from within the package.
 */
type CorexHook = import("phoenix_live_view").Hook;

declare module "corex/accordion" {
  export const Accordion: CorexHook;
}
declare module "corex/angle-slider" {
  export const AngleSlider: CorexHook;
}
declare module "corex/avatar" {
  export const Avatar: CorexHook;
}
declare module "corex/carousel" {
  export const Carousel: CorexHook;
}
declare module "corex/checkbox" {
  export const Checkbox: CorexHook;
}
declare module "corex/clipboard" {
  export const Clipboard: CorexHook;
}
declare module "corex/collapsible" {
  export const Collapsible: CorexHook;
}
declare module "corex/combobox" {
  export const Combobox: CorexHook;
}
declare module "corex/date-picker" {
  export const DatePicker: CorexHook;
}
declare module "corex/dialog" {
  export const Dialog: CorexHook;
}
declare module "corex/editable" {
  export const Editable: CorexHook;
}
declare module "corex/floating-panel" {
  export const FloatingPanel: CorexHook;
}
declare module "corex/listbox" {
  export const Listbox: CorexHook;
}
declare module "corex/menu" {
  export const Menu: CorexHook;
}
declare module "corex/number-input" {
  export const NumberInput: CorexHook;
}
declare module "corex/password-input" {
  export const PasswordInput: CorexHook;
}
declare module "corex/pin-input" {
  export const PinInput: CorexHook;
}
declare module "corex/radio-group" {
  export const RadioGroup: CorexHook;
}
declare module "corex/select" {
  export const Select: CorexHook;
}
declare module "corex/signature-pad" {
  export const SignaturePad: CorexHook;
}
declare module "corex/switch" {
  export const Switch: CorexHook;
}
declare module "corex/tabs" {
  export const Tabs: CorexHook;
}
declare module "corex/timer" {
  export const Timer: CorexHook;
}
declare module "corex/toast" {
  export const Toast: CorexHook;
}
declare module "corex/toggle-group" {
  export const ToggleGroup: CorexHook;
}
declare module "corex/tree-view" {
  export const TreeView: CorexHook;
}
