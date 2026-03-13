import { connect, machine, collection, type Props, type Api } from "@zag-js/listbox";
import type { ListCollection } from "@zag-js/collection";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";

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
    const items = this.options;
    if (this.hasGroups) {
      return collection({
        items,
        itemToValue: (item) => item.id ?? item.value ?? "",
        itemToString: (item) => item.label,
        isItemDisabled: (item) => !!item.disabled,
        groupBy: (item: Item) => item.group ?? "",
      });
    }
    return collection({
      items,
      itemToValue: (item) => item.id ?? item.value ?? "",
      itemToString: (item) => item.label,
      isItemDisabled: (item) => !!item.disabled,
    });
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
    return connect(this.machine.service, normalizeProps);
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

    const templatesContainer = this.el.querySelector<HTMLElement>('[data-templates="listbox"]');
    if (!templatesContainer) return;

    contentEl
      .querySelectorAll<HTMLElement>(
        '[data-scope="listbox"][data-part="empty"]:not([data-template])'
      )
      .forEach((el) => el.remove());
    contentEl
      .querySelectorAll<HTMLElement>(
        '[data-scope="listbox"][data-part="item-group"]:not([data-template])'
      )
      .forEach((el) => el.remove());
    contentEl
      .querySelectorAll<HTMLElement>(
        '[data-scope="listbox"][data-part="item"]:not([data-template])'
      )
      .forEach((el) => el.remove());

    const items = this.options;

    if (items.length === 0) {
      const emptyTemplate = templatesContainer.querySelector<HTMLElement>(
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
        const template = templatesContainer.querySelector<HTMLElement>(
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
        const template = templatesContainer.querySelector<HTMLElement>(
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

    contentEl
      .querySelectorAll<HTMLElement>('[data-scope="listbox"][data-part="item-group"]')
      .forEach((groupEl) => {
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

    const valueTextEl = this.el.querySelector<HTMLElement>(
      '[data-scope="listbox"][data-part="value-text"]'
    );
    if (valueTextEl) this.spreadProps(valueTextEl, this.api.getValueTextProps());

    const inputEl = this.el.querySelector<HTMLElement>('[data-scope="listbox"][data-part="input"]');
    if (inputEl) this.spreadProps(inputEl, this.api.getInputProps());

    const contentEl = this.el.querySelector<HTMLElement>(
      '[data-scope="listbox"][data-part="content"]'
    );
    if (contentEl) {
      this.spreadProps(contentEl, this.api.getContentProps());
      this.renderItems();
      this.applyItemProps();
    }
  }
}
