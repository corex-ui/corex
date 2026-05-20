export function mutableStrings(list: readonly string[]): string[] {
  return [...list];
}

export function mutableNumbers(list: readonly number[]): number[] {
  return [...list];
}

export function mutableArray<T>(items: readonly T[]): T[] {
  return [...items];
}

export function datasetRecord(
  attrs: Record<string, string | number | boolean>
): Record<string, string | number | boolean> {
  return attrs;
}

export function hasKey<K extends string>(obj: object, key: K): obj is Record<K, unknown> {
  return key in obj;
}
