import { connect, machine, collection, type Props, type Api } from "@zag-js/listbox";
import type { ListCollection } from "@zag-js/collection";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component } from "../lib/core";
import { zagIdValueLabelCollectionConfig } from "../lib/list-collection";
import { templatesContentRoot } from "../lib/util";

type Item = {
  id?: string;
  value?: string;
  label: string;
  disabled?: boolean;
  group?: string;
};

export class Listbox extends Component<Props<Item>, Api> {
  private _options: Item[] = [];
  hasGroups: boolean = false;
  private lastItemsFingerprint = "";

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

  private itemsFingerprint(): string {
    const dir = this.el.dataset.dir ?? "";
    const orientation = this.el.dataset.orientation ?? "";
    return `${this.hasGroups}:${dir}:${orientation}:${JSON.stringify(this.options)}`;
  }

  getOrderedGroupIds(): string[] {
    const seen = new Set<string>();
    const ids: string[] = [];
    for (const item of this.options) {
      const id = item.group ?? "default";
      if (!seen.has(id)) {
        seen.add(id);
        ids.push(id);
      }
    }
    return ids;
  }

  getCollection(): ListCollection<Item> {
    return collection(zagIdValueLabelCollectionConfig(this.options, this.hasGroups));
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

  init = (): void => {
    this.machine.start();
    this.render();
    this.machine.subscribe(() => {
      this.api = this.initApi();
      this.render();
    });
  };

  renderItems(): void {
    const contentEl = this.el.querySelector<HTMLElement>(
      '[data-scope="listbox"][data-part="content"]'
    );
    if (!contentEl) return;

    const isOwnedByContent = (el: Element) =>
      el.closest('[data-scope="listbox"][data-part="content"]') === contentEl;

    const templatesRoot = templatesContentRoot(this.el, "listbox");
    if (!templatesRoot) return;

    Array.from(
      contentEl.querySelectorAll<HTMLElement>(
        '[data-scope="listbox"][data-part="empty"]:not([data-template])'
      )
    )
      .filter(isOwnedByContent)
      .forEach((el) => el.remove());
    Array.from(
      contentEl.querySelectorAll<HTMLElement>(
        '[data-scope="listbox"][data-part="item-group"]:not([data-template])'
      )
    )
      .filter(isOwnedByContent)
      .forEach((el) => el.remove());
    Array.from(
      contentEl.querySelectorAll<HTMLElement>(
        '[data-scope="listbox"][data-part="item"]:not([data-template])'
      )
    )
      .filter(isOwnedByContent)
      .forEach((el) => el.remove());

    const items = this.options;

    if (items.length === 0) {
      const emptyTemplate = templatesRoot.querySelector<HTMLElement>(
        '[data-scope="listbox"][data-part="empty"][data-template]'
      );
      if (emptyTemplate) {
        const emptyEl = emptyTemplate.cloneNode(true) as HTMLElement;
        emptyEl.removeAttribute("data-template");
        contentEl.appendChild(emptyEl);
      }
    } else if (this.hasGroups) {
      const groupIds = this.getOrderedGroupIds();
      for (const groupId of groupIds) {
        const template = templatesRoot.querySelector<HTMLElement>(
          `[data-scope="listbox"][data-part="item-group"][data-id="${CSS.escape(groupId)}"][data-template]`
        );
        if (!template) continue;
        const groupEl = template.cloneNode(true) as HTMLElement;
        groupEl.removeAttribute("data-template");
        groupEl
          .querySelectorAll<HTMLElement>("[data-template]")
          .forEach((e) => e.removeAttribute("data-template"));
        contentEl.appendChild(groupEl);
      }
    } else {
      for (const item of items) {
        const value = String(item.id ?? item.value ?? "");
        const template = templatesRoot.querySelector<HTMLElement>(
          `[data-scope="listbox"][data-part="item"][data-value="${value}"][data-template]`
        );
        if (!template) continue;
        const itemEl = template.cloneNode(true) as HTMLElement;
        itemEl.removeAttribute("data-template");
        contentEl.appendChild(itemEl);
      }
    }
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
        const item = this.options.find((i) => String(i.id ?? i.value ?? "") === String(value));
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
      const fp = this.itemsFingerprint();
      if (fp !== this.lastItemsFingerprint) {
        this.lastItemsFingerprint = fp;
        this.renderItems();
      }
      this.applyItemProps();
    }
  }
}
