import { getBoolean, getNumber, getString } from "./util";

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
