import {
  syncArrayHiddenInputsForPhoenix
} from "./chunk-3BEM4I52.mjs";
import {
  notifyPhoenixFormChange,
  reapplyLiveViewValueInputUsage,
  syncLiveViewFormInput
} from "./chunk-DOKFN6DA.mjs";

// lib/phoenix-form-bridge.ts
function markUsed(input) {
  reapplyLiveViewValueInputUsage(input);
}
function setScalarValue(input, value, options = {}) {
  notifyPhoenixFormChange(input, value, options);
}
function setArrayValues(el, values, options = {}) {
  syncArrayHiddenInputsForPhoenix(el, values, options);
}
function syncFormInput(input, getValue, onTouched) {
  syncLiveViewFormInput(input, getValue, onTouched);
}

export {
  markUsed,
  setScalarValue,
  setArrayValues,
  syncFormInput
};
