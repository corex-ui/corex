import * as combobox from "@zag-js/combobox";
import { collection } from "@zag-js/combobox";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";
import { OpenChangeDetails, InputValueChangeDetails } from "@zag-js/combobox";

export class Combobox extends Component<combobox.Props, combobox.Api> {
  options: any[] = [];
  allOptions: any[] = [];
  hasGroups: boolean = false;

  setAllOptions(options: any[]) {
    this.allOptions = options;
    this.options = options;
  }

  private getCollection() {
    // Ensure we always have an array
    const items = this.options || this.allOptions || [];
    
    if (this.hasGroups) {
      return collection({
        items: items,
        itemToValue: (item: any) => item.id,
        itemToString: (item: any) => item.label,
        isItemDisabled: (item: any) => item.disabled,
        groupBy: (item: any) => item.group,
      });
    }

    return collection({
      items: items,
      itemToValue: (item: any) => item.id,
      itemToString: (item: any) => item.label,
      isItemDisabled: (item: any) => item.disabled,
    });
  }

  initMachine(props: combobox.Props): VanillaMachine<any> {
    const self = this;
    
    return new VanillaMachine(combobox.machine, {
      ...props,
      get collection() {
        return self.getCollection();
      },
      onOpenChange: (details: OpenChangeDetails) => {
        // Reset to all items when opening
        if (details.open) {
          self.options = self.allOptions;
        }
        // Call the original callback if it exists
        if (props.onOpenChange) {
          props.onOpenChange(details);
        }
      },
      onInputValueChange: (details: InputValueChangeDetails) => {
        // Filter items based on input
        const filtered = self.allOptions.filter((item: any) =>
          item.label.toLowerCase().includes(details.inputValue.toLowerCase())
        );
        self.options = filtered.length > 0 ? filtered : self.allOptions;
        
        // Call the original callback if it exists
        if (props.onInputValueChange) {
          props.onInputValueChange(details);
        }
      },
    });
  }

  initApi(): combobox.Api {
    return combobox.connect(this.machine.service, normalizeProps);
  }

  renderItems(): void {
    const contentEl = this.el.querySelector<HTMLElement>('[data-scope="combobox"][data-part="content"]');
    if (!contentEl) return;

    const templatesContainer =
      this.el.querySelector<HTMLElement>('[data-templates="combobox"]');
    if (!templatesContainer) return;

    contentEl
      .querySelectorAll('[data-scope="combobox"][data-part="item"]:not([data-template])')
      .forEach(el => el.remove());

    contentEl
      .querySelectorAll('[data-scope="combobox"][data-part="item-group"]:not([data-template])')
      .forEach(el => el.remove());

    const items = this.api.collection.items;

    const groups = this.api.collection.group?.() ?? [];
    const hasGroupsInCollection = groups.some(([group]) => group != null);

    if (hasGroupsInCollection) {
      this.renderGroupedItems(contentEl, templatesContainer, groups);
    } else {
      this.renderFlatItems(contentEl, templatesContainer, items);
    }
  }

  renderGroupedItems(
    contentEl: HTMLElement,
    templatesContainer: HTMLElement,
    groups: [string | null, any[]][]
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
        this.spreadProps(
          labelEl,
          this.api.getItemGroupLabelProps({ htmlFor: groupId })
        );
      }
  
      const groupContentEl = groupEl.querySelector<HTMLElement>(
        '[data-scope="combobox"][data-part="item-group-content"]'
      );
      if (!groupContentEl) continue;

      // Clear any template items that were cloned with the group template
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
    items: any[]
  ): void {
    for (const item of items) {
      const itemEl = this.cloneItem(templatesContainer, item);
      if (itemEl) contentEl.appendChild(itemEl);
    }
  }

  cloneItem(
    templatesContainer: HTMLElement,
    item: any
  ): HTMLElement | null {
    const value = this.api.collection.getItemValue(item);

    // Find template by data-value (templates are rendered per item in Elixir when custom slots are used)
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

    const indicatorEl =
      el.querySelector<HTMLElement>('[data-scope="combobox"][data-part="item-indicator"]');
    if (indicatorEl) {
      this.spreadProps(
        indicatorEl,
        this.api.getItemIndicatorProps({ item })
      );
    }

    return el;
  }

  render(): void {
    const root =
      this.el.querySelector<HTMLElement>('[data-scope="combobox"][data-part="root"]') ?? this.el;
    this.spreadProps(root, this.api.getRootProps());

    [
      "label",
      "control",
      "input",
      "trigger",
      "clear-trigger",
      "positioner",
    ].forEach(part => {
      const el = this.el.querySelector<HTMLElement>(`[data-scope="combobox"][data-part="${part}"]`);
      if (!el) return;

      const apiMethod =
        "get" +
        part
          .split("-")
          .map(s => s[0].toUpperCase() + s.slice(1))
          .join("") +
        "Props";

      // @ts-expect-error dynamic
      this.spreadProps(el, this.api[apiMethod]());
    });

    const contentEl =
      this.el.querySelector<HTMLElement>('[data-scope="combobox"][data-part="content"]');
    if (contentEl) {
      this.spreadProps(contentEl, this.api.getContentProps());
      this.renderItems();
    }
  }
}