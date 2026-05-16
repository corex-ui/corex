import {
  getBoolean,
  getNumber,
  getString,
  getStringList
} from "./chunk-C6EFS75P.mjs";

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
function readBooleanControlledZagProps(el, openKey, defaultOpenKey) {
  return getBoolean(el, "controlled") ? { open: getBoolean(el, openKey) } : { defaultOpen: getBoolean(el, defaultOpenKey) };
}
function readControlledOrDefaultBoolean(el, openKey, defaultOpenKey) {
  return getBoolean(el, "controlled") ? getBoolean(el, openKey) : getBoolean(el, defaultOpenKey);
}
function readStringListControlledZagProps(el, valueKey, defaultValueKey) {
  return getBoolean(el, "controlled") ? { value: getStringList(el, valueKey) } : { defaultValue: getStringList(el, defaultValueKey) };
}
function readControlledOrDefaultStringList(el, valueKey, defaultValueKey) {
  return (getBoolean(el, "controlled") ? getStringList(el, valueKey) : getStringList(el, defaultValueKey)) ?? [];
}

export {
  readStringControlledZagProps,
  readStringControlledZagUpdate,
  readNumberControlledZagProps,
  readBooleanControlledZagProps,
  readControlledOrDefaultBoolean,
  readStringListControlledZagProps,
  readControlledOrDefaultStringList
};
