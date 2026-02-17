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

  private getCollection() {
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
    const getCollection = this.getCollection.bind(this);

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
        const filtered = this.allOptions.filter((item: ComboboxItem) =>
          item.label.toLowerCase().includes(details.inputValue.toLowerCase())
        );
        this.options = filtered.length > 0 ? filtered : this.allOptions;

        if (props.onInputValueChange) {
          props.onInputValueChange(details);
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

    if (this.hasGroups) {
      const groups = this.api.collection.group?.() ?? [];
      this.renderGroupedItems(contentEl, templatesContainer, groups);
    } else {
      const items = this.options?.length ? this.options : this.allOptions;
      this.renderFlatItems(contentEl, templatesContainer, items);
    }
  }

  renderGroupedItems(
    contentEl: HTMLElement,
    templatesContainer: HTMLElement,
    groups: [string | null, ComboboxItem[]][]
  ): void {
    for (const [groupId, groupItems] of groups) {
      if (groupId == null) continue;

      const groupTemplate = templatesContainer.querySelector<HTMLElement>(
        `[data-scope="combobox"][data-part="item-group"][data-id="${groupId}"][data-template]`
      );
      if (!groupTemplate) continue;

      const groupEl = groupTemplate.cloneNode(true) as HTMLElement;
      groupEl.removeAttribute("data-template");

      this.spreadProps(groupEl, this.api.getItemGroupProps({ id: groupId }));

      const labelEl = groupEl.querySelector<HTMLElement>(
        '[data-scope="combobox"][data-part="item-group-label"]'
      );
      if (labelEl) {
        this.spreadProps(labelEl, this.api.getItemGroupLabelProps({ htmlFor: groupId }));
      }

      const groupContentEl = groupEl.querySelector<HTMLElement>(
        '[data-scope="combobox"][data-part="item-group-content"]'
      );
      if (!groupContentEl) continue;

      groupContentEl.innerHTML = "";

      for (const item of groupItems) {
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
      // Only set textContent if there are no child elements (custom HTML slots preserve their structure)
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
