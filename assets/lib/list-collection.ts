export type ValueLabelItem = {
  value?: string;
  label: string;
  disabled?: boolean;
  group?: string;
};

export function itemValue(item: ValueLabelItem): string {
  return item.value ?? "";
}

export function zagListCollectionConfig<T extends ValueLabelItem>(items: T[], hasGroups: boolean) {
  if (hasGroups) {
    return {
      items,
      itemToValue: (item: T) => itemValue(item),
      itemToString: (item: T) => item.label,
      isItemDisabled: (item: T) => !!item.disabled,
      groupBy: (item: T) => item.group ?? "",
    };
  }
  return {
    items,
    itemToValue: (item: T) => itemValue(item),
    itemToString: (item: T) => item.label,
    isItemDisabled: (item: T) => !!item.disabled,
  };
}
