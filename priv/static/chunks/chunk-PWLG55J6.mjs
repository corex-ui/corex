// lib/list-collection.ts
function itemValue(item) {
  return item.value ?? "";
}
function zagListCollectionConfig(items, hasGroups) {
  if (hasGroups) {
    return {
      items,
      itemToValue: (item) => itemValue(item),
      itemToString: (item) => item.label,
      isItemDisabled: (item) => !!item.disabled,
      groupBy: (item) => item.group ?? ""
    };
  }
  return {
    items,
    itemToValue: (item) => itemValue(item),
    itemToString: (item) => item.label,
    isItemDisabled: (item) => !!item.disabled
  };
}

export {
  itemValue,
  zagListCollectionConfig
};
