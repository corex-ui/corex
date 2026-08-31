import {
  getString
} from "./chunk-R62PCG6O.mjs";

// lib/form-field-array-submit.ts
function hasArraySubmitName(el) {
  return getString(el, "submitName") !== void 0;
}
function stripZagSubmitNames(el, scope, parts = ["hidden-input"]) {
  if (!hasArraySubmitName(el)) return;
  for (const part of parts) {
    el.querySelectorAll(`[data-scope="${scope}"][data-part="${part}"]`).forEach(
      (node) => {
        node.removeAttribute("name");
        node.removeAttribute("form");
      }
    );
  }
}

export {
  stripZagSubmitNames
};
