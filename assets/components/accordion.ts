import {connect, machine, type Props, type Api}  from "@zag-js/accordion";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";

export class Accordion extends Component<Props, Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return connect(this.machine.service, normalizeProps);
  }

  render(): void {
    const rootEl =
      this.el.querySelector<HTMLElement>('[data-scope="accordion"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());

    const itemsList = this.getItemsList();
    const itemEls = rootEl.querySelectorAll<HTMLElement>(
      '[data-scope="accordion"][data-part="item"]'
    );

    for (let i = 0; i < itemEls.length; i++) {
      const itemEl = itemEls[i];
      const itemData = itemsList[i];
      if (!itemData?.value) continue;

      const { value, disabled } = itemData;
      this.spreadProps(itemEl, this.api.getItemProps({ value, disabled }));

      const triggerEl = itemEl.querySelector<HTMLElement>('[data-scope="accordion"][data-part="item-trigger"]');
      if (triggerEl) {
        this.spreadProps(triggerEl, this.api.getItemTriggerProps({ value, disabled }));
      }

      const indicatorEl = itemEl.querySelector<HTMLElement>('[data-scope="accordion"][data-part="item-indicator"]');
      if (indicatorEl) {
        this.spreadProps(indicatorEl, this.api.getItemIndicatorProps({ value, disabled }));
      }

      const contentEl = itemEl.querySelector<HTMLElement>('[data-scope="accordion"][data-part="item-content"]');
      if (contentEl) {
        this.spreadProps(contentEl, this.api.getItemContentProps({ value, disabled }));
      }
    }
  }

  private getItemsList(): Array<{ value: string; disabled: boolean }> {
    const raw = this.el.getAttribute("data-items");
    if (!raw) return [];
    try {
      return JSON.parse(raw) as Array<{ value: string; disabled: boolean }>;
    } catch {
      return [];
    }
  }
}