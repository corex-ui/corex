import * as select from "@zag-js/select";
import { collection } from "@zag-js/select";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";
import { getString } from "../lib/util";

type Item = {
  id?: string;
  value?: string;
  label: string;
  disabled?: boolean;
};

export class Select extends Component<select.Props, select.Api> {
  private _options: Item[] = [];
  hasGroups: boolean = false;
  private placeholder: string = "";

  constructor(el: HTMLElement | null, props: select.Props) {
    super(el, props);
    this.placeholder = getString(this.el, "placeholder") || "";
  }

  get options(): Item[] {
    return Array.isArray(this._options) ? this._options : [];
  }

  setOptions(options: Item[]) {
    this._options = Array.isArray(options) ? options : [];
  }

  getCollection(): any {
    const items = this.options;

    if (this.hasGroups) {
      return collection({
        items: items,
        itemToValue: (item) => item.id ?? item.value ?? "",
        itemToString: (item) => item.label,
        isItemDisabled: (item) => !!item.disabled,
        groupBy: (item: any) => item.group,
      });
    }

    return collection({
      items: items,
      itemToValue: (item) => item.id ?? item.value ?? "",
      itemToString: (item) => item.label,
      isItemDisabled: (item) => !!item.disabled,
    });
  }

  initMachine(props: select.Props): VanillaMachine<any> {
    const self = this;

    return new VanillaMachine(select.machine, {
      ...props,
      get collection() {
        return self.getCollection();
      },
    });
  }

  initApi(): select.Api {
    return select.connect(this.machine.service, normalizeProps);
  }

  renderItems(): void {
    const contentEl = this.el.querySelector<HTMLElement>(
      '[data-scope="select"][data-part="content"]'
    );
    if (!contentEl) return;

    const templatesContainer =
      this.el.querySelector<HTMLElement>('[data-templates="select"]');
    if (!templatesContainer) return;

    contentEl
      .querySelectorAll('[data-scope="select"][data-part="item"]:not([data-template])')
      .forEach((el) => el.remove());

    contentEl
      .querySelectorAll('[data-scope="select"][data-part="item-group"]:not([data-template])')
      .forEach((el) => el.remove());

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
        `[data-scope="select"][data-part="item-group"][data-id="${groupId}"][data-template]`
      );
      if (!groupTemplate) continue;

      const groupEl = groupTemplate.cloneNode(true) as HTMLElement;
      groupEl.removeAttribute("data-template");

      this.spreadProps(groupEl, this.api.getItemGroupProps({ id: groupId }));

      const labelEl = groupEl.querySelector<HTMLElement>(
        '[data-scope="select"][data-part="item-group-label"]'
      );
      if (labelEl) {
        this.spreadProps(
          labelEl,
          this.api.getItemGroupLabelProps({ htmlFor: groupId })
        );
      }

      const templateItems = groupEl.querySelectorAll<HTMLElement>(
        '[data-scope="select"][data-part="item"][data-template]'
      );
      templateItems.forEach((item) => item.remove());

      for (const item of groupItems) {
        const itemEl = this.cloneItem(templatesContainer, item);
        if (itemEl) groupEl.appendChild(itemEl);
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
    item: Item
  ): HTMLElement | null {
    const value = this.api.collection.getItemValue(item);
    const template = templatesContainer.querySelector<HTMLElement>(
      `[data-scope="select"][data-part="item"][data-value="${value}"][data-template]`
    );
    if (!template) return null;

    const el = template.cloneNode(true) as HTMLElement;
    el.removeAttribute("data-template");

    this.spreadProps(el, this.api.getItemProps({ item }));

    const textEl = el.querySelector<HTMLElement>(
      '[data-scope="select"][data-part="item-text"]'
    );
    if (textEl) {
      this.spreadProps(textEl, this.api.getItemTextProps({ item }));
    }

    const indicatorEl = el.querySelector<HTMLElement>(
      '[data-scope="select"][data-part="item-indicator"]'
    );
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
    this.el.querySelector<HTMLElement>('[data-scope="select"][data-part="root"]') ??
    this.el;

  this.spreadProps(root, this.api.getRootProps());
  
  const hiddenSelect = this.el.querySelector<HTMLSelectElement>(
    '[data-scope="select"][data-part="hidden-select"]'
  );

  const valueInput = this.el.querySelector<HTMLInputElement>(
    '[data-scope="select"][data-part="value-input"]'
  );
  if (valueInput) {
    if (!this.api.value || this.api.value.length === 0) {
      valueInput.value = "";
    } else if (this.api.value.length === 1) {
      valueInput.value = String(this.api.value[0]);
    } else {
      valueInput.value = this.api.value.map(String).join(",");
    }
  }

  if (hiddenSelect) {
    this.spreadProps(hiddenSelect, this.api.getHiddenSelectProps());
  }

    [
      "label",
      "control",
      "trigger",
      "indicator",
      "clear-trigger",
      "positioner",
    ].forEach((part) => {
      const el = this.el.querySelector<HTMLElement>(
        `[data-scope="select"][data-part="${part}"]`
      );
      if (!el) return;

      const method =
        "get" +
        part
          .split("-")
          .map((s) => s[0].toUpperCase() + s.slice(1))
          .join("") +
        "Props";

      // @ts-expect-error zag dynamic api
      this.spreadProps(el, this.api[method]());
    });

    const valueText = this.el.querySelector<HTMLElement>(
      '[data-scope="select"][data-part="item-text"]'
    );
    if (valueText) {
      const valueAsString = this.api.valueAsString;
      if (this.api.value && this.api.value.length > 0 && !valueAsString) {
        const selectedValue = this.api.value[0];
        const selectedItem = this.options.find((item: any) => {
          const itemValue = item.id ?? item.value ?? "";
          return String(itemValue) === String(selectedValue);
        });
        if (selectedItem) {
          valueText.textContent = selectedItem.label;
        } else {
          valueText.textContent = this.placeholder || "";
        }
      } else {
        valueText.textContent = valueAsString || this.placeholder || "";
      }
    }

    const contentEl = this.el.querySelector<HTMLElement>(
      '[data-scope="select"][data-part="content"]'
    );
    if (contentEl) {
      this.spreadProps(contentEl, this.api.getContentProps());
      this.renderItems();
    }
  }
}

