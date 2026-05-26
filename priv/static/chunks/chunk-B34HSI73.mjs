import {
  getBoolean,
  getCheckedState,
  getNumber,
  getString,
  getStringList
} from "./chunk-EWT2BP2N.mjs";

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
  return getBoolean(el, "controlled") || getBoolean(el, "formField");
}
function readDatasetStringList(el, datasetKey) {
  return getJsonStringList(el, datasetKey) ?? getStringList(el, datasetKey) ?? [];
}
function readUpdatedServerStringList(el) {
  if (!isZagValueControlled(el)) {
    return {};
  }
  return { value: readDatasetStringList(el, "value") };
}
function mountStringListBinding(el) {
  if (isZagValueControlled(el)) {
    return { value: readDatasetStringList(el, "value") };
  }
  return { defaultValue: readDatasetStringList(el, "defaultValue") };
}
function readUpdatedServerString(el) {
  if (!isZagValueControlled(el)) {
    return {};
  }
  return { value: z(getString(el, "value")) };
}
function mountStringBinding(el, valueKey, defaultKey) {
  if (isZagValueControlled(el)) {
    return { value: z(getString(el, valueKey)) };
  }
  return { defaultValue: z(getString(el, defaultKey)) };
}
function isZagCheckedControlled(el) {
  return getBoolean(el, "controlled") || getBoolean(el, "formField");
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
  if (getBoolean(el, "formField")) {
    return { defaultChecked: getCheckedState(el, "checked") };
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
function readUpdatedServerTags(el) {
  if (!isZagValueControlled(el)) {
    return {};
  }
  return { value: readDatasetTagsList(el, "tags") };
}
function mountTagsBinding(el) {
  if (isZagValueControlled(el)) {
    return { value: readDatasetTagsList(el, "tags") };
  }
  return { defaultValue: readDatasetTagsList(el, "defaultTags") };
}
function readUpdatedServerNumber(el) {
  const step = getNumber(el, "step");
  const base = step !== void 0 ? { step } : {};
  if (!isZagValueControlled(el)) {
    return base;
  }
  const raw = getString(el, "value");
  if (raw === void 0 || raw === "") {
    return base;
  }
  const parsed = Number(raw);
  return Number.isNaN(parsed) ? base : { ...base, value: parsed };
}
function mountNumberBinding(el) {
  const step = getNumber(el, "step");
  if (isZagValueControlled(el)) {
    const raw = getString(el, "value");
    const value = raw !== void 0 && raw !== "" && !Number.isNaN(Number(raw)) ? Number(raw) : void 0;
    return { value, step };
  }
  return { defaultValue: getNumber(el, "defaultValue"), step };
}
function readStringListControlledZagUpdate(el, _valueKey, _defaultValueKey) {
  return readUpdatedServerStringList(el);
}
function readPressedControlledZagUpdate(el) {
  if (!getBoolean(el, "controlled")) {
    return {};
  }
  return { pressed: getBoolean(el, "pressed") };
}
function readEditControlledZagUpdate(el) {
  if (!getBoolean(el, "controlled")) {
    return {};
  }
  return { edit: getBoolean(el, "edit") };
}
function readBooleanControlledZagProps(el, openKey, defaultOpenKey) {
  return getBoolean(el, "controlled") ? { open: getBoolean(el, openKey) } : { defaultOpen: getBoolean(el, defaultOpenKey) };
}
function readControlledOrDefaultBoolean(el, openKey, defaultOpenKey) {
  return getBoolean(el, "controlled") ? getBoolean(el, openKey) : getBoolean(el, defaultOpenKey);
}
function readStringListControlledZagProps(el, valueKey, defaultValueKey) {
  if (isZagValueControlled(el)) {
    return { value: readDatasetStringList(el, valueKey) };
  }
  return { defaultValue: readDatasetStringList(el, defaultValueKey) };
}
function readControlledOrDefaultStringList(el, valueKey, defaultValueKey) {
  return (getBoolean(el, "controlled") ? getStringList(el, valueKey) : getStringList(el, defaultValueKey)) ?? [];
}

export {
  readStringControlledZagProps,
  readStringControlledZagUpdate,
  getJsonStringList,
  readFormFieldServerPaths,
  readBooleanControlledZagUpdate,
  readUpdatedServerStringList,
  mountStringListBinding,
  readUpdatedServerString,
  mountStringBinding,
  readUpdatedServerChecked,
  mountCheckedBinding,
  readUpdatedServerTags,
  mountTagsBinding,
  readUpdatedServerNumber,
  mountNumberBinding,
  readStringListControlledZagUpdate,
  readPressedControlledZagUpdate,
  readEditControlledZagUpdate,
  readBooleanControlledZagProps,
  readControlledOrDefaultBoolean,
  readStringListControlledZagProps,
  readControlledOrDefaultStringList
};
