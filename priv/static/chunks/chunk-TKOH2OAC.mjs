// lib/controlled-attr-snapshot.ts
function snapshotDataset(el, keys) {
  const snap = {};
  for (const key of keys) {
    snap[key] = el.dataset[key];
  }
  return snap;
}
function datasetKeyChanged(before, el, key) {
  if (before === void 0) return true;
  return before[key] !== el.dataset[key];
}
function anyDatasetKeyChanged(before, el, keys) {
  if (before === void 0) return true;
  return keys.some((key) => datasetKeyChanged(before, el, key));
}

export {
  snapshotDataset,
  datasetKeyChanged,
  anyDatasetKeyChanged
};
