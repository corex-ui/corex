import {
  collection,
  connect,
  machine,
  type Props,
  type Api,
  type OpenChangeDetails,
  type InputValueChangeDetails,
} from "@zag-js/combobox";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component } from "../lib/core";
import { zagComboboxCollectionConfig } from "../lib/list-collection";
import { templatesContentRoot } from "../lib/util";

export type ComboboxItem = { id?: string; label: string; disabled?: boolean; group?: string };

export class Combobox extends Component<Props, Api> {
  options: ComboboxItem[] = [];
  allOptions: ComboboxItem[] = [];
  hasGroups: boolean = false;

  setAllOptions(options: ComboboxItem[]) {
    this.allOptions = options;
    this.options = options;
  }

  getCollection() {
    const items = this.options || this.allOptions || [];
    return collection(zagComboboxCollectionConfig(items, this.hasGroups));
  }

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    const getCollection = () => this.getCollection();

    return new VanillaMachine(machine, {
      ...props,
      get collection() {
        return getCollection();
      },
      onOpenChange: (details: OpenChangeDetails) => {
        if (details.open) {
          this.options = this.allOptions;
        }
        if (props.onOpenChange) {
          props.onOpenChange(details);
        }
      },
      onInputValueChange: (details: InputValueChangeDetails) => {
        if (props.onInputValueChange) {
          props.onInputValueChange(details);
        }
        if (this.el.hasAttribute("data-filter")) {
          const q = String(details.inputValue ?? "").toLowerCase();
          const filtered = this.allOptions.filter((item: ComboboxItem) => {
            const label = String(item.label ?? "");
            return label.toLowerCase().includes(q);
          });
          this.options = filtered.length > 0 ? filtered : this.allOptions;
        } else {
          this.options = this.allOptions;
        }
      },
    });
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  private getItemValue(item: ComboboxItem): string {
    const v = this.api.collection.getItemValue?.(item) as string | undefined;
    return v ?? item.id ?? "";
  }

  private buildOrderedBlocks(
    items: ComboboxItem[]
  ): (
    | { type: "default"; items: ComboboxItem[] }
    | { type: "group"; groupId: string; items: ComboboxItem[] }
  )[] {
    const blocks: (
      | { type: "default"; items: ComboboxItem[] }
      | { type: "group"; groupId: string; items: ComboboxItem[] }
    )[] = [];
    let current:
      | { type: "default"; items: ComboboxItem[] }
      | { type: "group"; groupId: string; items: ComboboxItem[] }
      | null = null;

    for (const item of items) {
      const groupKey = item.group ?? "";
      if (groupKey === "") {
        if (current?.type !== "default") {
          current = { type: "default", items: [] };
          blocks.push(current);
        }
        current.items.push(item);
      } else {
        if (current?.type !== "group" || current.groupId !== groupKey) {
          current = { type: "group", groupId: groupKey, items: [] };
          blocks.push(current);
        }
        current.items.push(item);
      }
    }
    return blocks;
  }

  renderItems(): void {
    const listEl = this.el.querySelector<HTMLElement>('[data-scope="combobox"][data-part="list"]');
    if (!listEl) return;

    const isOwnedByList = (el: Element) =>
      el.closest('[data-scope="combobox"][data-part="list"]') === listEl;

    const templatesRoot = templatesContentRoot(this.el, "combobox");
    if (!templatesRoot) return;

    (["empty", "item-group", "item"] as const).forEach((part) => {
      Array.from(
        listEl.querySelectorAll<HTMLElement>(
          `[data-scope="combobox"][data-part="${part}"]:not([data-template])`
        )
      )
        .filter(isOwnedByList)
        .forEach((el) => el.remove());
    });

    const items = this.options?.length ? this.options : this.allOptions;

    if (items.length === 0) {
      const emptyTemplate = templatesRoot.querySelector<HTMLElement>(
        '[data-scope="combobox"][data-part="empty"][data-template]'
      );
      if (emptyTemplate) {
        const emptyEl = emptyTemplate.cloneNode(true) as HTMLElement;
        emptyEl.removeAttribute("data-template");
        listEl.appendChild(emptyEl);
      }
      return;
    }

    if (this.hasGroups) {
      this.renderGroupedItems(listEl, templatesRoot, items);
    } else {
      this.renderFlatItems(listEl, templatesRoot, items);
    }
  }

  private renderGroupedItems(
    listEl: HTMLElement,
    templatesRoot: DocumentFragment | HTMLElement,
    items: ComboboxItem[]
  ): void {
    const blocks = this.buildOrderedBlocks(items);

    for (const block of blocks) {
      if (block.type !== "group") continue;

      const groupTemplate = templatesRoot.querySelector<HTMLElement>(
        `[data-scope="combobox"][data-part="item-group"][data-id="${CSS.escape(block.groupId)}"][data-template]`
      );
      if (!groupTemplate) continue;

      const groupEl = groupTemplate.cloneNode(true) as HTMLElement;
      groupEl.removeAttribute("data-template");
      groupEl
        .querySelectorAll<HTMLElement>("[data-template]")
        .forEach((e) => e.removeAttribute("data-template"));

      const keepValues = new Set(block.items.map((i) => this.getItemValue(i)));
      groupEl
        .querySelectorAll<HTMLElement>('[data-scope="combobox"][data-part="item"]')
        .forEach((itemEl) => {
          const v = itemEl.dataset.value ?? "";
          if (!keepValues.has(v)) itemEl.remove();
        });

      listEl.appendChild(groupEl);
    }
  }

  private renderFlatItems(
    listEl: HTMLElement,
    templatesRoot: DocumentFragment | HTMLElement,
    items: ComboboxItem[]
  ): void {
    for (const item of items) {
      const value = this.getItemValue(item);
      const template = templatesRoot.querySelector<HTMLElement>(
        `:scope > [data-scope="combobox"][data-part="item"][data-value="${CSS.escape(value)}"][data-template]`
      );
      if (!template) continue;
      const itemEl = template.cloneNode(true) as HTMLElement;
      itemEl.removeAttribute("data-template");
      listEl.appendChild(itemEl);
    }
  }

  applyItemProps(): void {
    const listEl = this.el.querySelector<HTMLElement>('[data-scope="combobox"][data-part="list"]');
    if (!listEl) return;

    const isOwnedByList = (el: Element) =>
      el.closest('[data-scope="combobox"][data-part="list"]') === listEl;

    listEl
      .querySelectorAll<HTMLElement>('[data-scope="combobox"][data-part="item-group"]')
      .forEach((groupEl) => {
        if (!isOwnedByList(groupEl)) return;
        const groupId = groupEl.dataset.id ?? "";
        this.spreadProps(groupEl, this.api.getItemGroupProps({ id: groupId }));
        const labelEl = groupEl.querySelector<HTMLElement>(
          '[data-scope="combobox"][data-part="item-group-label"]'
        );
        if (labelEl) {
          this.spreadProps(labelEl, this.api.getItemGroupLabelProps({ htmlFor: groupId }));
        }
      });

    const sourceItems = this.options?.length ? this.options : this.allOptions;
    const byValue = new Map<string, ComboboxItem>();
    for (const item of sourceItems) {
      byValue.set(this.getItemValue(item), item);
    }
    for (const item of this.allOptions) {
      const v = this.getItemValue(item);
      if (!byValue.has(v)) byValue.set(v, item);
    }

    listEl
      .querySelectorAll<HTMLElement>('[data-scope="combobox"][data-part="item"]')
      .forEach((itemEl) => {
        if (!isOwnedByList(itemEl)) return;
        const value = itemEl.dataset.value ?? "";
        const item = byValue.get(value);
        if (!item) return;
        this.spreadProps(itemEl, this.api.getItemProps({ item }));
        const textEl = itemEl.querySelector<HTMLElement>(
          '[data-scope="combobox"][data-part="item-text"]'
        );
        if (textEl) {
          this.spreadProps(textEl, this.api.getItemTextProps({ item }));
        }
        const indicatorEl = itemEl.querySelector<HTMLElement>(
          '[data-scope="combobox"][data-part="item-indicator"]'
        );
        if (indicatorEl) {
          this.spreadProps(indicatorEl, this.api.getItemIndicatorProps({ item }));
        }
      });
  }

  render(): void {
    const root = this.el.querySelector<HTMLElement>('[data-scope="combobox"][data-part="root"]');
    if (!root) return;
    this.spreadProps(root, this.api.getRootProps());

    [
      "label",
      "control",
      "input",
      "trigger",
      "clear-trigger",
      "positioner",
      "content",
      "list",
    ].forEach((part) => {
      const el = this.el.querySelector<HTMLElement>(`[data-scope="combobox"][data-part="${part}"]`);
      if (!el) return;

      const apiMethod =
        "get" +
        part
          .split("-")
          .map((s) => s[0].toUpperCase() + s.slice(1))
          .join("") +
        "Props";

      // @ts-expect-error dynamic
      this.spreadProps(el, this.api[apiMethod]());
    });

    this.renderItems();
    this.applyItemProps();
  }
}
