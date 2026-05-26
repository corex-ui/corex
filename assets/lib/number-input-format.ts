const MAX_FRACTION_DIGITS = 10;

export function fractionDigitsForStep(step: number): number | null {
  if (!Number.isFinite(step) || step === Math.trunc(step)) {
    return null;
  }

  const frac = step.toString().split(".")[1]?.replace(/0+$/, "");

  if (!frac) return null;

  return Math.min(frac.length, MAX_FRACTION_DIGITS);
}

export function formatOptionsFromStep(step: number): Intl.NumberFormatOptions {
  const digits = fractionDigitsForStep(step);

  if (digits === null) {
    return { useGrouping: true };
  }

  return {
    maximumFractionDigits: digits,
    minimumFractionDigits: 0,
    useGrouping: true,
  };
}

export function mergeFormatOptions(step: number): Intl.NumberFormatOptions {
  return formatOptionsFromStep(step);
}

export function formatSubmitOptions(step: number): Intl.NumberFormatOptions {
  return { ...formatOptionsFromStep(step), useGrouping: false };
}

export function formatSubmitValue(value: string | number | undefined | null, step: number): string {
  if (value === undefined || value === null) return "";

  const trimmed = String(value).trim();
  if (trimmed === "") return "";

  const n = typeof value === "number" ? value : Number(trimmed.replace(/,/g, ""));
  if (Number.isNaN(n)) return trimmed.replace(/,/g, "");

  return new Intl.NumberFormat("en-US", formatSubmitOptions(step)).format(n);
}

export function formatDisplayValue(
  value: string | number | undefined | null,
  step: number
): string {
  if (value === undefined || value === null) return "";

  const trimmed = String(value).trim();
  if (trimmed === "") return "";

  const n = typeof value === "number" ? value : Number(trimmed.replace(/,/g, ""));
  if (Number.isNaN(n)) return trimmed;

  return new Intl.NumberFormat("en-US", mergeFormatOptions(step)).format(n);
}
