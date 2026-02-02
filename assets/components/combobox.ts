import * as combobox from "@zag-js/combobox";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";

export class Combobox extends Component<combobox.Props, combobox.Api> {
  initMachine(props: combobox.Props): VanillaMachine<any> {
    return new VanillaMachine(combobox.machine, props);
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
    const hasGroups = groups.some(([group]) => group != null);

    if (hasGroups) {
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

      groupEl
        .querySelectorAll('[data-scope="combobox"][data-part="item"][data-template]')
        .forEach(el => el.remove());

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
    item: any
  ): HTMLElement | null {
    const value = this.api.collection.getItemValue(item);

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
