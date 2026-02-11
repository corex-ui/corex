/**
 * Type declarations for corex package subpath exports (corex/accordion, etc.).
 * Resolves "Cannot find module 'corex/accordion'" when building from within the package.
 */
type CorexHook = import("phoenix_live_view").Hook;

declare module "corex/accordion" {
  export const Accordion: CorexHook;
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
declare module "corex/menu" {
  export const Menu: CorexHook;
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
declare module "corex/toast" {
  export const Toast: CorexHook;
}
declare module "corex/toggle-group" {
  export const ToggleGroup: CorexHook;
}
