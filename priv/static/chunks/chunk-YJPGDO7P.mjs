import {
  getString
} from "./chunk-YGZLYEUJ.mjs";

// lib/form-field-array-submit.ts
function hasArraySubmitName(el) {
  return getString(el, "submitName") !== void 0;
}
function stripZagSubmitNames(el, scope, parts = ["hidden-input"]) {
  if (!hasArraySubmitName(el)) return;
  for (const part of parts) {
    const node = el.querySelector(`[data-scope="${scope}"][data-part="${part}"]`);
    if (!node) continue;
    node.removeAttribute("name");
    node.removeAttribute("form");
  }
}

export {
  stripZagSubmitNames
};
