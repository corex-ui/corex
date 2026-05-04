export type IdValueLabelItem = {
  id?: string;
  value?: string;
  label: string;
  disabled?: boolean;
  group?: string;
};

export function itemToIdOrValue(item: IdValueLabelItem): string {
  return item.id ?? item.value ?? "";
}

export function zagIdValueLabelCollectionConfig<T extends IdValueLabelItem>(
  items: T[],
  hasGroups: boolean
) {
  if (hasGroups) {
    return {
      items,
      itemToValue: (item: T) => itemToIdOrValue(item),
      itemToString: (item: T) => item.label,
      isItemDisabled: (item: T) => !!item.disabled,
      groupBy: (item: T) => item.group ?? "",
    };
  }
  return {
    items,
    itemToValue: (item: T) => itemToIdOrValue(item),
    itemToString: (item: T) => item.label,
    isItemDisabled: (item: T) => !!item.disabled,
  };
}

export type ComboboxListItem = { id?: string; label: string; disabled?: boolean; group?: string };

export function zagComboboxCollectionConfig(items: ComboboxListItem[], hasGroups: boolean) {
  if (hasGroups) {
    return {
      items,
      itemToValue: (item: ComboboxListItem) => item.id ?? "",
      itemToString: (item: ComboboxListItem) => item.label,
      isItemDisabled: (item: ComboboxListItem) => !!item.disabled,
      groupBy: (item: ComboboxListItem) => item.group ?? "",
    };
  }
  return {
    items,
    itemToValue: (item: ComboboxListItem) => item.id ?? "",
    itemToString: (item: ComboboxListItem) => item.label,
    isItemDisabled: (item: ComboboxListItem) => !!item.disabled,
  };
}
