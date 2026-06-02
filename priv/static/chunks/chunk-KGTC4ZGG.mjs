import {
  syncInputFormAssociation
} from "./chunk-2GQRP3FN.mjs";

// lib/checkable-form-sync.ts
function hiddenInputPropsWithoutChecked(props) {
  const rest = { ...props };
  delete rest.defaultChecked;
  delete rest.checked;
  return rest;
}
function syncCheckableHiddenInput(inputEl, hostEl, checked, spreadProps, hiddenInputProps) {
  spreadProps(inputEl, hiddenInputPropsWithoutChecked(hiddenInputProps));
  inputEl.checked = checked;
  syncInputFormAssociation(inputEl, hostEl);
}

export {
  hiddenInputPropsWithoutChecked,
  syncCheckableHiddenInput
};
