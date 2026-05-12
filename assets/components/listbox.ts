import { connect, machine, collection, type Props, type Api } from "@zag-js/listbox";
import type { ListCollection } from "@zag-js/collection";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component } from "../lib/core";
import { itemValue, zagListCollectionConfig } from "../lib/list-collection";

type Item = {
  value?: string;
  label: string;
  disabled?: boolean;
  group?: string;
};

export class Listbox extends Component<Props<Item>, Api> {
  private _options: Item[] = [];
  hasGroups: boolean = false;

  constructor(el: HTMLElement | null, props: Props<Item>) {
    super(el, props);
    const collectionFromProps = (props as Props<Item> & { collection?: { items: Item[] } })
      .collection;
    this._options = collectionFromProps?.items ?? [];
  }

  get options(): Item[] {
    return Array.isArray(this._options) ? this._options : [];
  }

  setOptions(options: Item[]) {
    this._options = Array.isArray(options) ? options : [];
  }

  getCollection(): ListCollection<Item> {
    return collection(zagListCollectionConfig(this.options, this.hasGroups));
  }

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props<Item>): VanillaMachine<any> {
    const getCollection = this.getCollection.bind(this);
    return new VanillaMachine(machine, {
      ...props,
      get collection() {
        return getCollection();
      },
    });
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  applyItemProps(): void {
    const contentEl = this.el.querySelector<HTMLElement>(
      '[data-scope="listbox"][data-part="content"]'
    );
    if (!contentEl) return;

    const isOwnedByContent = (el: Element) =>
      el.closest('[data-scope="listbox"][data-part="content"]') === contentEl;

    contentEl
      .querySelectorAll<HTMLElement>('[data-scope="listbox"][data-part="item-group"]')
      .forEach((groupEl) => {
        if (!isOwnedByContent(groupEl)) return;
        const groupId = groupEl.dataset.id ?? "";
        this.spreadProps(groupEl, this.api.getItemGroupProps({ id: groupId }));
        const labelEl = groupEl.querySelector<HTMLElement>(
          '[data-scope="listbox"][data-part="item-group-label"]'
        );
        if (labelEl) {
          this.spreadProps(labelEl, this.api.getItemGroupLabelProps({ htmlFor: groupId }));
        }
      });

    contentEl
      .querySelectorAll<HTMLElement>('[data-scope="listbox"][data-part="item"]')
      .forEach((itemEl) => {
        if (!isOwnedByContent(itemEl)) return;
        const value = itemEl.dataset.value ?? "";
        const item = this.options.find((i) => String(itemValue(i)) === String(value));
        if (!item) return;
        this.spreadProps(itemEl, this.api.getItemProps({ item }));
        const textEl = itemEl.querySelector<HTMLElement>(
          '[data-scope="listbox"][data-part="item-text"]'
        );
        if (textEl) {
          this.spreadProps(textEl, this.api.getItemTextProps({ item }));
        }
        const indicatorEl = itemEl.querySelector<HTMLElement>(
          '[data-scope="listbox"][data-part="item-indicator"]'
        );
        if (indicatorEl) {
          this.spreadProps(indicatorEl, this.api.getItemIndicatorProps({ item }));
        }
      });
  }

  render(): void {
    const rootEl =
      this.el.querySelector<HTMLElement>('[data-scope="listbox"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());

    const labelEl = this.el.querySelector<HTMLElement>('[data-scope="listbox"][data-part="label"]');
    if (labelEl) this.spreadProps(labelEl, this.api.getLabelProps());

    const inputEl = this.el.querySelector<HTMLElement>('[data-scope="listbox"][data-part="input"]');
    if (inputEl) this.spreadProps(inputEl, this.api.getInputProps());

    const contentEl = this.el.querySelector<HTMLElement>(
      '[data-scope="listbox"][data-part="content"]'
    );
    if (contentEl) {
      this.spreadProps(contentEl, this.api.getContentProps());
      this.applyItemProps();
    }
  }
}
