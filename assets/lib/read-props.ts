import { getBoolean, getNumber, getString, getStringList } from "./util";

const z = (s: string | undefined) => (s === undefined ? null : s);

export function readStringControlledZagProps(
  el: HTMLElement,
  valueKey: string,
  defaultKey: string
): { value: string | null } | { defaultValue: string | null } {
  return getBoolean(el, "controlled")
    ? { value: z(getString(el, valueKey)) }
    : { defaultValue: z(getString(el, defaultKey)) };
}

export function readStringControlledZagUpdate(
  el: HTMLElement,
  valueKey: string,
  defaultKey: string
): Record<string, string | null> {
  return getBoolean(el, "controlled")
    ? { value: z(getString(el, valueKey)) }
    : { defaultValue: z(getString(el, defaultKey)) };
}

type NumZag =
  | { value: number | undefined; step: number | undefined; defaultValue?: never }
  | { value?: never; defaultValue: number | undefined; step: number | undefined };

export function readNumberControlledZagProps(el: HTMLElement): NumZag {
  const step = getNumber(el, "step");
  return getBoolean(el, "controlled")
    ? { value: getNumber(el, "value"), step }
    : { defaultValue: getNumber(el, "defaultValue"), step };
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
  return getBoolean(el, "controlled")
    ? { value: getStringList(el, valueKey) }
    : { defaultValue: getStringList(el, defaultValueKey) };
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
