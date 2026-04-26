// lib/list-collection.ts
function itemToIdOrValue(item) {
  return item.id ?? item.value ?? "";
}
function zagIdValueLabelCollectionConfig(items, hasGroups) {
  if (hasGroups) {
    return {
      items,
      itemToValue: (item) => itemToIdOrValue(item),
      itemToString: (item) => item.label,
      isItemDisabled: (item) => !!item.disabled,
      groupBy: (item) => item.group ?? ""
    };
  }
  return {
    items,
    itemToValue: (item) => itemToIdOrValue(item),
    itemToString: (item) => item.label,
    isItemDisabled: (item) => !!item.disabled
  };
}
function zagComboboxCollectionConfig(items, hasGroups) {
  if (hasGroups) {
    return {
      items,
      itemToValue: (item) => item.id ?? "",
      itemToString: (item) => item.label,
      isItemDisabled: (item) => !!item.disabled,
      groupBy: (item) => item.group ?? ""
    };
  }
  return {
    items,
    itemToValue: (item) => item.id ?? "",
    itemToString: (item) => item.label,
    isItemDisabled: (item) => !!item.disabled
  };
}

export {
  zagIdValueLabelCollectionConfig,
  zagComboboxCollectionConfig
};
