import { collection } from "@zag-js/listbox";
import { safeParseJson } from "./util";

export type ValueLabelItem = {
  value?: string;
  label: string;
  disabled?: boolean;
  group?: string;
};

export type ItemsHost<T extends ValueLabelItem> = {
  hasGroups: boolean;
  setOptions?: (items: T[]) => void;
  setAllOptions?: (items: T[]) => void;
};

export type ItemsJsonHost = {
  lastItemsJson?: string;
};

export function itemValue(item: ValueLabelItem): string {
  return item.value ?? "";
}

/** Ordered value fingerprint — ignores disabled/label/meta, used to skip DOM rebuilds. */
export function itemsMembershipKey(items: ReadonlyArray<ValueLabelItem>): string {
  return items.map((item) => itemValue(item)).join("\0");
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

export function buildCollection<T extends ValueLabelItem>(items: T[], hasGroups: boolean) {
  return collection(zagListCollectionConfig(items, hasGroups));
}

export function readItemsJson(el: HTMLElement): string {
  return el.getAttribute("data-items") ?? "[]";
}

export function parseItemsJson<T extends ValueLabelItem>(raw: string): T[] {
  return safeParseJson<T[]>(raw, []);
}

export function itemsHaveGroups<T extends ValueLabelItem>(items: T[]): boolean {
  return items.some((item) => Boolean(item.group));
}

export function readItems<T extends ValueLabelItem>(
  el: HTMLElement
): {
  json: string;
  items: T[];
  hasGroups: boolean;
} {
  const json = readItemsJson(el);
  const items = parseItemsJson<T>(json);
  return { json, items, hasGroups: itemsHaveGroups(items) };
}

export function applyItems<T extends ValueLabelItem>(
  host: ItemsHost<T>,
  items: T[],
  hasGroups = itemsHaveGroups(items)
): void {
  host.hasGroups = hasGroups;
  if (host.setAllOptions) {
    host.setAllOptions(items);
  } else if (host.setOptions) {
    host.setOptions(items);
  }
}

export function refreshItemsIfChanged<T extends ValueLabelItem>(
  el: HTMLElement,
  state: ItemsJsonHost,
  host: ItemsHost<T>
): boolean {
  const json = readItemsJson(el);
  if (json === state.lastItemsJson) return false;
  state.lastItemsJson = json;
  const items = parseItemsJson<T>(json);
  applyItems(host, items);
  return true;
}
