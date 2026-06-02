import {
  syncInputFormAssociation
} from "./chunk-2GQRP3FN.mjs";

// lib/value-form-sync.ts
function hiddenInputPropsWithoutValue(props) {
  const rest = { ...props };
  delete rest.defaultValue;
  delete rest.value;
  return rest;
}
function syncHiddenInputValue(inputEl, hostEl, value, spreadProps, hiddenProps) {
  if (Object.keys(hiddenProps).length > 0) {
    spreadProps(inputEl, hiddenInputPropsWithoutValue(hiddenProps));
  }
  inputEl.value = value;
  syncInputFormAssociation(inputEl, hostEl);
}

export {
  syncHiddenInputValue
};
