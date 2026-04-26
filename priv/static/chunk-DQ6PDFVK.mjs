import {
  getBoolean,
  getNumber,
  getString
} from "./chunk-SJ37CZDS.mjs";

// lib/read-props.ts
var z = (s) => s === void 0 ? null : s;
function readStringControlledZagProps(el, valueKey, defaultKey) {
  return getBoolean(el, "controlled") ? { value: z(getString(el, valueKey)) } : { defaultValue: z(getString(el, defaultKey)) };
}
function readStringControlledZagUpdate(el, valueKey, defaultKey) {
  return getBoolean(el, "controlled") ? { value: z(getString(el, valueKey)) } : { defaultValue: z(getString(el, defaultKey)) };
}
function readNumberControlledZagProps(el) {
  const step = getNumber(el, "step");
  return getBoolean(el, "controlled") ? { value: getNumber(el, "value"), step } : { defaultValue: getNumber(el, "defaultValue"), step };
}

export {
  readStringControlledZagProps,
  readStringControlledZagUpdate,
  readNumberControlledZagProps
};
