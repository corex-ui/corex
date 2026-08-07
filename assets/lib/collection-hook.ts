import type { RedirectContext } from "./redirect";
import { performRedirect, readDomItemRedirect } from "./redirect";
import {
  type ItemsHost,
  type ItemsJsonHost,
  type ValueLabelItem,
  applyItems,
  buildCollection,
  itemValue,
  itemsMembershipKey,
  parseItemsJson,
  readItems,
  refreshItemsIfChanged,
  zagListCollectionConfig,
} from "./list-collection";

export type { ItemsHost, ItemsJsonHost, ValueLabelItem };
export {
  applyItems,
  buildCollection,
  itemValue,
  itemsMembershipKey,
  parseItemsJson,
  readItems,
  refreshItemsIfChanged,
  zagListCollectionConfig,
};

export function firstSelectedValue(values: ReadonlyArray<string>): string | null {
  return values.length > 0 ? String(values[0]) : null;
}

export function redirectCollectionItem(
  el: HTMLElement,
  scope: string,
  value: string | null | undefined,
  liveSocket: RedirectContext["liveSocket"]
): boolean {
  if (!value) return false;
  const itemEl = el.querySelector<HTMLElement>(
    `[data-scope="${scope}"][data-part="item"][data-value="${CSS.escape(value)}"]`
  );
  return performRedirect(readDomItemRedirect(itemEl, value), { liveSocket });
}

export function initCollectionItems<T extends ValueLabelItem>(
  el: HTMLElement,
  state: ItemsJsonHost
): { json: string; items: T[]; hasGroups: boolean } {
  const result = readItems<T>(el);
  state.lastItemsJson = result.json;
  return result;
}

export function mountCollectionItems<T extends ValueLabelItem>(
  el: HTMLElement,
  state: ItemsJsonHost,
  host: ItemsHost<T>
): { items: T[]; hasGroups: boolean } {
  const { items, hasGroups } = initCollectionItems<T>(el, state);
  applyItems(host, items, hasGroups);
  return { items, hasGroups };
}
