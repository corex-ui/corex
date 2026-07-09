import {
  getBoolean,
  getCheckedState,
  getNumber,
  getString,
  getStringList
} from "./chunk-2GQRP3FN.mjs";

// lib/number-input-format.ts
var MAX_FRACTION_DIGITS = 10;
function fractionDigitsForStep(step) {
  if (!Number.isFinite(step) || step === Math.trunc(step)) {
    return null;
  }
  const frac = step.toString().split(".")[1]?.replace(/0+$/, "");
  if (!frac) return null;
  return Math.min(frac.length, MAX_FRACTION_DIGITS);
}
function formatOptionsFromStep(step) {
  const digits = fractionDigitsForStep(step);
  if (digits === null) {
    return { useGrouping: true };
  }
  return {
    maximumFractionDigits: digits,
    minimumFractionDigits: 0,
    useGrouping: true
  };
}
function mergeFormatOptions(step) {
  return formatOptionsFromStep(step);
}
function formatSubmitOptions(step) {
  return { ...formatOptionsFromStep(step), useGrouping: false };
}
function formatSubmitValue(value, step) {
  if (value === void 0 || value === null) return "";
  const trimmed = String(value).trim();
  if (trimmed === "") return "";
  const n = typeof value === "number" ? value : Number(trimmed.replace(/,/g, ""));
  if (Number.isNaN(n)) return trimmed.replace(/,/g, "");
  return new Intl.NumberFormat("en-US", formatSubmitOptions(step)).format(n);
}
function formatDisplayValue(value, step) {
  if (value === void 0 || value === null) return "";
  const trimmed = String(value).trim();
  if (trimmed === "") return "";
  const n = typeof value === "number" ? value : Number(trimmed.replace(/,/g, ""));
  if (Number.isNaN(n)) return trimmed;
  return new Intl.NumberFormat("en-US", mergeFormatOptions(step)).format(n);
}

// lib/read-props.ts
var z = (s) => s === void 0 ? null : s;
function readStringControlledZagProps(el, valueKey, defaultKey) {
  return mountStringBinding(el, valueKey, defaultKey);
}
function readStringControlledZagUpdate(el, valueKey, _defaultKey) {
  if (!isZagValueControlled(el)) {
    return {};
  }
  return { value: z(getString(el, valueKey)) };
}
function getJsonStringList(el, datasetKey) {
  const raw = el.dataset[datasetKey];
  if (raw === void 0) return void 0;
  if (!raw || raw.trim() === "") return [];
  const trimmed = raw.trim();
  if (!trimmed.startsWith("[")) return void 0;
  try {
    const v = JSON.parse(trimmed);
    return Array.isArray(v) && v.every((x) => typeof x === "string") ? v : [];
  } catch {
    return [];
  }
}
function readFormFieldServerPaths(el, datasetKey = "defaultPaths") {
  if (!getBoolean(el, "formField")) {
    return void 0;
  }
  const json = getJsonStringList(el, datasetKey);
  if (json !== void 0) return json;
  const raw = el.dataset[datasetKey];
  if (!raw) return [];
  return raw.split("\n").map((line) => line.trim()).filter(Boolean);
}
function readBooleanControlledZagUpdate(el, openKey, _defaultOpenKey) {
  if (!getBoolean(el, "controlled")) {
    return {};
  }
  return { open: getBoolean(el, openKey) };
}
function isZagValueControlled(el) {
  return getBoolean(el, "controlled");
}
function readDatasetStringList(el, datasetKey) {
  return getJsonStringList(el, datasetKey) ?? getStringList(el, datasetKey) ?? [];
}
function readUpdatedServerStringList(el, lastServerValue) {
  if (!isZagValueControlled(el)) {
    return {};
  }
  const raw = getString(el, "value") ?? "";
  if (raw === lastServerValue) {
    return {};
  }
  return { value: readDatasetStringList(el, "value"), nextServerValue: raw };
}
function mountStringListBinding(el) {
  if (getBoolean(el, "controlled")) {
    return { value: readDatasetStringList(el, "value") };
  }
  return { defaultValue: readDatasetStringList(el, "defaultValue") };
}
function readUpdatedServerString(el, lastServerValue) {
  if (!isZagValueControlled(el)) {
    return {};
  }
  const raw = getString(el, "value");
  if (raw === lastServerValue) {
    return {};
  }
  return { value: z(raw) };
}
function mountStringBinding(el, valueKey, defaultKey) {
  if (getBoolean(el, "controlled")) {
    return { value: z(getString(el, valueKey)) };
  }
  return { defaultValue: z(getString(el, defaultKey)) };
}
function isZagCheckedControlled(el) {
  return getBoolean(el, "controlled");
}
function readUpdatedServerChecked(el) {
  if (!isZagCheckedControlled(el)) {
    return {};
  }
  return { checked: getCheckedState(el, "checked") };
}
function mountCheckedBinding(el) {
  if (getBoolean(el, "controlled")) {
    return { checked: getCheckedState(el, "checked") };
  }
  return { defaultChecked: getCheckedState(el, "defaultChecked") };
}
function readDatasetTagsList(el, datasetKey) {
  const raw = datasetKey === "tags" ? el.dataset.tags : el.dataset.defaultTags;
  if (!raw || raw.trim() === "") return [];
  try {
    const v = JSON.parse(raw);
    return Array.isArray(v) && v.every((x) => typeof x === "string") ? v : [];
  } catch {
    return [];
  }
}
function mountTagsBinding(el) {
  if (isZagValueControlled(el)) {
    return { value: readDatasetTagsList(el, "tags") };
  }
  return { defaultValue: readDatasetTagsList(el, "defaultTags") };
}
function numberInputStep(el) {
  return getNumber(el, "step") ?? 1;
}
function mountNumberBinding(el) {
  const step = numberInputStep(el);
  if (getBoolean(el, "controlled")) {
    const raw = getString(el, "value");
    const value = raw !== void 0 && raw !== "" ? formatDisplayValue(raw, step) : void 0;
    return { value, step };
  }
  const rawDefault = getString(el, "defaultValue");
  const defaultValue = rawDefault !== void 0 && rawDefault !== "" ? formatDisplayValue(rawDefault, step) : void 0;
  return { defaultValue, step };
}
function readStringListControlledZagUpdate(el, _valueKey, _defaultValueKey, lastServerValue) {
  const patch = readUpdatedServerStringList(el, lastServerValue);
  if (!("value" in patch)) {
    return {};
  }
  return { value: patch.value };
}
function readPressedControlledZagUpdate(el) {
  if (!getBoolean(el, "controlled")) {
    return {};
  }
  return { pressed: getBoolean(el, "pressed") };
}
function readBooleanControlledZagProps(el, openKey, defaultOpenKey) {
  return getBoolean(el, "controlled") ? { open: getBoolean(el, openKey) } : { defaultOpen: getBoolean(el, defaultOpenKey) };
}
function readControlledOrDefaultBoolean(el, openKey, defaultOpenKey) {
  return getBoolean(el, "controlled") ? getBoolean(el, openKey) : getBoolean(el, defaultOpenKey);
}
function readStringListControlledZagProps(el, _valueKey, _defaultValueKey) {
  return mountStringListBinding(el);
}
function readControlledOrDefaultStringList(el, valueKey, defaultValueKey) {
  return (getBoolean(el, "controlled") ? getStringList(el, valueKey) : getStringList(el, defaultValueKey)) ?? [];
}

export {
  mergeFormatOptions,
  formatSubmitValue,
  formatDisplayValue,
  readStringControlledZagProps,
  readStringControlledZagUpdate,
  getJsonStringList,
  readFormFieldServerPaths,
  readBooleanControlledZagUpdate,
  readDatasetStringList,
  readUpdatedServerStringList,
  mountStringListBinding,
  readUpdatedServerString,
  mountStringBinding,
  readUpdatedServerChecked,
  mountCheckedBinding,
  mountTagsBinding,
  mountNumberBinding,
  readStringListControlledZagUpdate,
  readPressedControlledZagUpdate,
  readBooleanControlledZagProps,
  readControlledOrDefaultBoolean,
  readStringListControlledZagProps,
  readControlledOrDefaultStringList
};
