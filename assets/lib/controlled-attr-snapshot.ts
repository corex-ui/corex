export type DatasetSnapshot = Record<string, string | undefined>;

export function snapshotDataset(el: HTMLElement, keys: readonly string[]): DatasetSnapshot {
  const snap: DatasetSnapshot = {};
  for (const key of keys) {
    snap[key] = el.dataset[key];
  }
  return snap;
}

export function datasetKeyChanged(
  before: DatasetSnapshot | undefined,
  el: HTMLElement,
  key: string
): boolean {
  if (before === undefined) return true;
  return before[key] !== el.dataset[key];
}

export function anyDatasetKeyChanged(
  before: DatasetSnapshot | undefined,
  el: HTMLElement,
  keys: readonly string[]
): boolean {
  if (before === undefined) return true;
  return keys.some((key) => datasetKeyChanged(before, el, key));
}
