import {
  collection,
  connect,
  machine,
  type Props,
  type Api,
  type OpenChangeDetails,
  type InputValueChangeDetails,
} from "@zag-js/combobox";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";

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

    if (this.hasGroups) {
      return collection({
        items: items,
        itemToValue: (item: ComboboxItem) => item.id ?? "",
        itemToString: (item: ComboboxItem) => item.label,
        isItemDisabled: (item: ComboboxItem) => item.disabled ?? false,
        groupBy: (item: ComboboxItem) => item.group ?? "",
      });
    }

    return collection({
      items: items,
      itemToValue: (item: ComboboxItem) => item.id ?? "",
      itemToString: (item: ComboboxItem) => item.label,
      isItemDisabled: (item: ComboboxItem) => item.disabled ?? false,
    });
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
          const filtered = this.allOptions.filter((item: ComboboxItem) =>
            item.label.toLowerCase().includes(details.inputValue.toLowerCase())
          );
          this.options = filtered.length > 0 ? filtered : this.allOptions;
        } else {
          this.options = this.allOptions;
        }
      },
    });
  }

  initApi(): Api {
    return connect(this.machine.service, normalizeProps);
  }

  renderItems(): void {
    const contentEl = this.el.querySelector<HTMLElement>(
      '[data-scope="combobox"][data-part="content"]'
    );
    if (!contentEl) return;

    const templatesContainer = this.el.querySelector<HTMLElement>('[data-templates="combobox"]');
    if (!templatesContainer) return;

    contentEl
      .querySelectorAll('[data-scope="combobox"][data-part="item"]:not([data-template])')
      .forEach((el) => el.remove());

    contentEl
      .querySelectorAll('[data-scope="combobox"][data-part="item-group"]:not([data-template])')
      .forEach((el) => el.remove());

    contentEl
      .querySelectorAll('[data-scope="combobox"][data-part="empty"]:not([data-template])')
      .forEach((el) => el.remove());

    const items = this.options?.length ? this.options : this.allOptions;

    if (items.length === 0) {
      const emptyTemplate = templatesContainer.querySelector<HTMLElement>(
        '[data-scope="combobox"][data-part="empty"][data-template]'
      );
      if (emptyTemplate) {
        const emptyEl = emptyTemplate.cloneNode(true) as HTMLElement;
        emptyEl.removeAttribute("data-template");
        contentEl.appendChild(emptyEl);
      }
    } else if (this.hasGroups) {
      const groups = this.api.collection.group?.() ?? [];
      this.renderGroupedItems(contentEl, templatesContainer, groups);
    } else {
      this.renderFlatItems(contentEl, templatesContainer, items);
    }
  }

  buildOrderedBlocks(
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

  renderGroupedItems(
    contentEl: HTMLElement,
    templatesContainer: HTMLElement,
    _groups: [string | null, ComboboxItem[]][]
  ): void {
    const items = this.options?.length ? this.options : this.allOptions;
    const blocks = this.buildOrderedBlocks(items);

    for (const block of blocks) {
      const templateId = block.type === "default" ? "default" : block.groupId;
      const groupTemplate = templatesContainer.querySelector<HTMLElement>(
        `[data-scope="combobox"][data-part="item-group"][data-id="${templateId}"][data-template]`
      );
      if (!groupTemplate) continue;

      const groupEl = groupTemplate.cloneNode(true) as HTMLElement;
      groupEl.removeAttribute("data-template");

      this.spreadProps(groupEl, this.api.getItemGroupProps({ id: templateId }));

      const labelEl = groupEl.querySelector<HTMLElement>(
        '[data-scope="combobox"][data-part="item-group-label"]'
      );
      if (labelEl) {
        this.spreadProps(labelEl, this.api.getItemGroupLabelProps({ htmlFor: templateId }));
      }

      const groupContentEl = groupEl.querySelector<HTMLElement>(
        '[data-scope="combobox"][data-part="item-group-content"]'
      );
      if (!groupContentEl) continue;

      groupContentEl.innerHTML = "";

      for (const item of block.items) {
        const itemEl = this.cloneItem(templatesContainer, item);
        if (itemEl) groupContentEl.appendChild(itemEl);
      }

      contentEl.appendChild(groupEl);
    }
  }

  renderFlatItems(
    contentEl: HTMLElement,
    templatesContainer: HTMLElement,
    items: ComboboxItem[]
  ): void {
    for (const item of items) {
      const itemEl = this.cloneItem(templatesContainer, item);
      if (itemEl) contentEl.appendChild(itemEl);
    }
  }

  cloneItem(templatesContainer: HTMLElement, item: ComboboxItem): HTMLElement | null {
    const value = (this.api.collection.getItemValue?.(item) as string | undefined) ?? item.id ?? "";

    const template = templatesContainer.querySelector<HTMLElement>(
      `[data-scope="combobox"][data-part="item"][data-value="${value}"][data-template]`
    );
    if (!template) return null;

    const el = template.cloneNode(true) as HTMLElement;
    el.removeAttribute("data-template");

    this.spreadProps(el, this.api.getItemProps({ item }));

    const textEl = el.querySelector<HTMLElement>('[data-scope="combobox"][data-part="item-text"]');
    if (textEl) {
      this.spreadProps(textEl, this.api.getItemTextProps({ item }));
      if (textEl.children.length === 0) {
        textEl.textContent = item.label || "";
      }
    }

    const indicatorEl = el.querySelector<HTMLElement>(
      '[data-scope="combobox"][data-part="item-indicator"]'
    );
    if (indicatorEl) {
      this.spreadProps(indicatorEl, this.api.getItemIndicatorProps({ item }));
    }

    return el;
  }

  render(): void {
    const root = this.el.querySelector<HTMLElement>('[data-scope="combobox"][data-part="root"]');
    if (!root) return;
    this.spreadProps(root, this.api.getRootProps());

    ["label", "control", "input", "trigger", "clear-trigger", "positioner"].forEach((part) => {
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

    const contentEl = this.el.querySelector<HTMLElement>(
      '[data-scope="combobox"][data-part="content"]'
    );
    if (contentEl) {
      this.spreadProps(contentEl, this.api.getContentProps());
      this.renderItems();
    }
  }
}
