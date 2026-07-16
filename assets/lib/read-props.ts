import { formatDisplayValue } from "./number-input-format";
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
  return getBoolean(el, "controlled");
}

export function readDatasetStringList(el: HTMLElement, datasetKey: string): string[] {
  return getJsonStringList(el, datasetKey) ?? getStringList(el, datasetKey) ?? [];
}

export function readUpdatedServerStringList(
  el: HTMLElement,
  lastServerValue?: string
): { value: string[]; nextServerValue: string } | Record<string, never> {
  if (!isZagValueControlled(el)) {
    return {};
  }

  const raw = getString(el, "value") ?? "";

  if (raw === lastServerValue) {
    return {};
  }

  return { value: readDatasetStringList(el, "value"), nextServerValue: raw };
}

export function mountStringListBinding(
  el: HTMLElement
): { value: string[] } | { defaultValue: string[] } {
  if (getBoolean(el, "controlled")) {
    return { value: readDatasetStringList(el, "value") };
  }

  return { defaultValue: readDatasetStringList(el, "defaultValue") };
}

export function readUpdatedServerString(
  el: HTMLElement,
  lastServerValue?: string
): { value: string | null } | Record<string, never> {
  if (!isZagValueControlled(el)) {
    return {};
  }

  const raw = getString(el, "value");

  if (raw === lastServerValue) {
    return {};
  }

  return { value: z(raw) };
}

export function mountStringBinding(
  el: HTMLElement,
  valueKey: string,
  defaultKey: string
): { value: string | null } | { defaultValue: string | null } {
  if (getBoolean(el, "controlled")) {
    return { value: z(getString(el, valueKey)) };
  }

  return { defaultValue: z(getString(el, defaultKey)) };
}

export function isZagCheckedControlled(el: HTMLElement): boolean {
  return getBoolean(el, "controlled");
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

export function mountTagsBinding(
  el: HTMLElement
): { value: string[] } | { defaultValue: string[] } {
  if (isZagValueControlled(el)) {
    return { value: readDatasetTagsList(el, "tags") };
  }

  return { defaultValue: readDatasetTagsList(el, "defaultTags") };
}

function numberInputStep(el: HTMLElement): number {
  return getNumber(el, "step") ?? 1;
}

export type NumberServerValuePatch = {
  value?: string;
  step?: number;
  nextServerValue?: string;
};

export function readUpdatedServerNumber(
  el: HTMLElement,
  lastServerValue?: string
): NumberServerValuePatch {
  const step = numberInputStep(el);
  const base: NumberServerValuePatch = { step };

  const sync = getBoolean(el, "controlled") || getBoolean(el, "formField");
  if (!sync) {
    return base;
  }

  const raw =
    getString(el, "value") ??
    (getBoolean(el, "formField") ? getString(el, "defaultValue") : undefined);
  if (raw === undefined || raw === "") {
    return base;
  }

  if (raw === lastServerValue) {
    return base;
  }

  return {
    ...base,
    value: formatDisplayValue(raw, step),
    nextServerValue: raw,
  };
}

export function mountNumberBinding(el: HTMLElement): NumZag {
  const step = numberInputStep(el);

  if (getBoolean(el, "controlled")) {
    const raw = getString(el, "value");
    const value = raw !== undefined && raw !== "" ? formatDisplayValue(raw, step) : undefined;
    return { value, step };
  }

  const rawDefault = getString(el, "defaultValue");
  const defaultValue =
    rawDefault !== undefined && rawDefault !== ""
      ? formatDisplayValue(rawDefault, step)
      : undefined;

  return { defaultValue, step };
}

export function readStringListControlledZagUpdate(
  el: HTMLElement,
  _valueKey: string,
  _defaultValueKey: string,
  lastServerValue?: string
): { value: string[] | undefined } | Record<string, never> {
  const patch = readUpdatedServerStringList(el, lastServerValue);
  if (!("value" in patch)) {
    return {};
  }

  return { value: patch.value };
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
  | { value: string | undefined; step: number | undefined; defaultValue?: never }
  | { value?: never; defaultValue: string | undefined; step: number | undefined };

export function readNumberControlledZagProps(el: HTMLElement): NumZag {
  return mountNumberBinding(el);
}

export function readNumberControlledZagUpdate(
  el: HTMLElement,
  lastServerValue?: string
): NumberServerValuePatch {
  return readUpdatedServerNumber(el, lastServerValue);
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
  _valueKey: string,
  _defaultValueKey: string
): { value: string[] | undefined } | { defaultValue: string[] | undefined } {
  return mountStringListBinding(el);
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
