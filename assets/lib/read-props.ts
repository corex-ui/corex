import {
  getBoolean,
  getCheckedState,
  getNumber,
  getString,
  getStringList,
  type CheckedState,
} from "./util";

const z = (s: string | undefined) => (s === undefined ? null : s);

export function readStringControlledZagProps(
  el: HTMLElement,
  valueKey: string,
  defaultKey: string
): { value: string | null } | { defaultValue: string | null } {
  return mountStringBinding(el, valueKey, defaultKey);
}

export function readStringControlledZagUpdate(
  el: HTMLElement,
  valueKey: string,
  _defaultKey: string
): Record<string, string | null> {
  if (!isZagValueControlled(el)) {
    return {};
  }

  return { value: z(getString(el, valueKey)) };
}

export function readCheckedControlledZagUpdate(
  el: HTMLElement
): { checked: CheckedState } | Record<string, never> {
  return readUpdatedServerChecked(el);
}

export function readFormFieldServerChecked(el: HTMLElement): boolean | undefined {
  if (!getBoolean(el, "formField")) {
    return undefined;
  }

  if (!el.hasAttribute("data-default-checked")) {
    return false;
  }

  return getCheckedState(el, "defaultChecked") === true;
}

export function readFormFieldServerString(
  el: HTMLElement,
  datasetKey = "defaultValue"
): string | undefined {
  if (!getBoolean(el, "formField")) {
    return undefined;
  }

  return getString(el, datasetKey) ?? "";
}

export function getJsonStringList(el: HTMLElement, datasetKey: string): string[] | undefined {
  const raw = el.dataset[datasetKey];
  if (raw === undefined) return undefined;
  if (!raw || raw.trim() === "") return [];
  const trimmed = raw.trim();
  if (!trimmed.startsWith("[")) return undefined;
  try {
    const v = JSON.parse(trimmed) as unknown;
    return Array.isArray(v) && v.every((x) => typeof x === "string") ? (v as string[]) : [];
  } catch {
    return [];
  }
}

export function readFormFieldServerStringList(
  el: HTMLElement,
  datasetKey = "defaultValue"
): string[] | undefined {
  if (!getBoolean(el, "formField")) {
    return undefined;
  }

  return getJsonStringList(el, datasetKey) ?? getStringList(el, datasetKey) ?? [];
}

export function formFieldValuesDiffer(current: string[], server: string[]): boolean {
  if (current.length !== server.length) return true;
  return current.some((v, i) => v !== server[i]);
}

export function readFormFieldDefaultAttr(
  el: HTMLElement,
  attrName: "data-default-value" | "data-default-checked"
): string | undefined {
  if (!getBoolean(el, "formField")) {
    return undefined;
  }
  return el.getAttribute(attrName) ?? "";
}

export function shouldResyncFormFieldString(
  el: HTMLElement,
  lastAttr: string | undefined
): { resync: boolean; nextAttr: string } | null {
  const currentAttr = readFormFieldDefaultAttr(el, "data-default-value");
  if (currentAttr === undefined) return null;
  if (lastAttr === currentAttr) return null;
  return { resync: true, nextAttr: currentAttr };
}

export function shouldResyncFormFieldChecked(
  el: HTMLElement,
  lastAttr: string | undefined
): { resync: boolean; nextAttr: string } | null {
  const currentAttr = readFormFieldDefaultAttr(el, "data-default-checked");
  if (currentAttr === undefined) return null;
  if (lastAttr === currentAttr) return null;
  return { resync: true, nextAttr: currentAttr };
}

export function readFormFieldServerJsonTags(
  el: HTMLElement,
  datasetKey: "defaultTags" | "tags" = "defaultTags"
): string[] | undefined {
  if (!getBoolean(el, "formField")) {
    return undefined;
  }

  const raw = el.dataset[datasetKey];
  if (!raw || raw.trim() === "") return [];
  try {
    const v = JSON.parse(raw) as unknown;
    return Array.isArray(v) && v.every((x) => typeof x === "string") ? (v as string[]) : [];
  } catch {
    return [];
  }
}

export function readFormFieldServerPaths(
  el: HTMLElement,
  datasetKey = "defaultPaths"
): string[] | undefined {
  if (!getBoolean(el, "formField")) {
    return undefined;
  }

  const json = getJsonStringList(el, datasetKey);
  if (json !== undefined) return json;

  const raw = el.dataset[datasetKey];
  if (!raw) return [];
  return raw
    .split("\n")
    .map((line) => line.trim())
    .filter(Boolean);
}

export function readBooleanControlledZagUpdate(
  el: HTMLElement,
  openKey: string,
  _defaultOpenKey: string
): { open: boolean } | Record<string, never> {
  if (!getBoolean(el, "controlled")) {
    return {};
  }

  return { open: getBoolean(el, openKey) };
}

export function isZagValueControlled(el: HTMLElement): boolean {
  return getBoolean(el, "controlled") || getBoolean(el, "formField");
}

export function readDatasetStringList(el: HTMLElement, datasetKey: string): string[] {
  return getJsonStringList(el, datasetKey) ?? getStringList(el, datasetKey) ?? [];
}

export function readUpdatedServerStringList(
  el: HTMLElement
): { value: string[] } | Record<string, never> {
  if (!isZagValueControlled(el)) {
    return {};
  }

  return { value: readDatasetStringList(el, "value") };
}

export function mountStringListBinding(
  el: HTMLElement
): { value: string[] } | { defaultValue: string[] } {
  if (isZagValueControlled(el)) {
    return { value: readDatasetStringList(el, "value") };
  }

  return { defaultValue: readDatasetStringList(el, "defaultValue") };
}

export function readUpdatedServerString(
  el: HTMLElement
): { value: string | null } | Record<string, never> {
  if (!isZagValueControlled(el)) {
    return {};
  }

  return { value: z(getString(el, "value")) };
}

export function mountStringBinding(
  el: HTMLElement,
  valueKey: string,
  defaultKey: string
): { value: string | null } | { defaultValue: string | null } {
  if (isZagValueControlled(el)) {
    return { value: z(getString(el, valueKey)) };
  }

  return { defaultValue: z(getString(el, defaultKey)) };
}

export function isZagCheckedControlled(el: HTMLElement): boolean {
  return getBoolean(el, "controlled") || getBoolean(el, "formField");
}

export function readUpdatedServerChecked(
  el: HTMLElement
): { checked: CheckedState } | Record<string, never> {
  if (!isZagCheckedControlled(el)) {
    return {};
  }

  return { checked: getCheckedState(el, "checked") };
}

export function mountCheckedBinding(
  el: HTMLElement
): { checked: CheckedState } | { defaultChecked: CheckedState } {
  if (getBoolean(el, "controlled")) {
    return { checked: getCheckedState(el, "checked") };
  }

  if (getBoolean(el, "formField")) {
    return { defaultChecked: getCheckedState(el, "checked") };
  }

  return { defaultChecked: getCheckedState(el, "defaultChecked") };
}

function readDatasetTagsList(el: HTMLElement, datasetKey: "tags" | "defaultTags"): string[] {
  const raw = datasetKey === "tags" ? el.dataset.tags : el.dataset.defaultTags;
  if (!raw || raw.trim() === "") return [];
  try {
    const v = JSON.parse(raw) as unknown;
    return Array.isArray(v) && v.every((x) => typeof x === "string") ? (v as string[]) : [];
  } catch {
    return [];
  }
}

export function readUpdatedServerTags(
  el: HTMLElement
): { value: string[] } | Record<string, never> {
  if (!isZagValueControlled(el)) {
    return {};
  }

  return { value: readDatasetTagsList(el, "tags") };
}

export function mountTagsBinding(
  el: HTMLElement
): { value: string[] } | { defaultValue: string[] } {
  if (isZagValueControlled(el)) {
    return { value: readDatasetTagsList(el, "tags") };
  }

  return { defaultValue: readDatasetTagsList(el, "defaultTags") };
}

export function readUpdatedServerNumber(el: HTMLElement): { value?: number; step?: number } {
  const step = getNumber(el, "step");
  const base = step !== undefined ? { step } : {};

  if (!isZagValueControlled(el)) {
    return base;
  }

  const raw = getString(el, "value");
  if (raw === undefined || raw === "") {
    return base;
  }

  const parsed = Number(raw);
  return Number.isNaN(parsed) ? base : { ...base, value: parsed };
}

export function mountNumberBinding(el: HTMLElement): NumZag {
  const step = getNumber(el, "step");
  if (isZagValueControlled(el)) {
    const raw = getString(el, "value");
    const value =
      raw !== undefined && raw !== "" && !Number.isNaN(Number(raw)) ? Number(raw) : undefined;
    return { value, step };
  }

  return { defaultValue: getNumber(el, "defaultValue"), step };
}

export function readStringListControlledZagUpdate(
  el: HTMLElement,
  _valueKey: string,
  _defaultValueKey: string
): { value: string[] | undefined } | Record<string, never> {
  return readUpdatedServerStringList(el);
}

export function readPressedControlledZagUpdate(
  el: HTMLElement
): { pressed: boolean } | Record<string, never> {
  if (!getBoolean(el, "controlled")) {
    return {};
  }

  return { pressed: getBoolean(el, "pressed") };
}

export function readEditControlledZagUpdate(
  el: HTMLElement
): { edit: boolean } | Record<string, never> {
  if (!getBoolean(el, "controlled")) {
    return {};
  }

  return { edit: getBoolean(el, "edit") };
}

type NumZag =
  | { value: number | undefined; step: number | undefined; defaultValue?: never }
  | { value?: never; defaultValue: number | undefined; step: number | undefined };

export function readNumberControlledZagProps(el: HTMLElement): NumZag {
  return mountNumberBinding(el);
}

export function readNumberControlledZagUpdate(el: HTMLElement): { value?: number; step?: number } {
  return readUpdatedServerNumber(el);
}

export function readBooleanControlledZagProps(
  el: HTMLElement,
  openKey: string,
  defaultOpenKey: string
): { open: boolean } | { defaultOpen: boolean } {
  return getBoolean(el, "controlled")
    ? { open: getBoolean(el, openKey) }
    : { defaultOpen: getBoolean(el, defaultOpenKey) };
}

export function readControlledOrDefaultBoolean(
  el: HTMLElement,
  openKey: string,
  defaultOpenKey: string
): boolean {
  return getBoolean(el, "controlled") ? getBoolean(el, openKey) : getBoolean(el, defaultOpenKey);
}

export function readStringListControlledZagProps(
  el: HTMLElement,
  valueKey: string,
  defaultValueKey: string
): { value: string[] | undefined } | { defaultValue: string[] | undefined } {
  if (isZagValueControlled(el)) {
    return { value: readDatasetStringList(el, valueKey) };
  }

  return { defaultValue: readDatasetStringList(el, defaultValueKey) };
}

export function readControlledOrDefaultStringList(
  el: HTMLElement,
  valueKey: string,
  defaultValueKey: string
): string[] {
  return (
    (getBoolean(el, "controlled")
      ? getStringList(el, valueKey)
      : getStringList(el, defaultValueKey)) ?? []
  );
}
