import {
  syncArrayHiddenInputsForPhoenix
} from "./chunk-4UPAN2NC.mjs";
import {
  notifyPhoenixFormChange,
  reapplyLiveViewValueInputUsage,
  syncLiveViewFormInput
} from "./chunk-7LA2VUMJ.mjs";

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
