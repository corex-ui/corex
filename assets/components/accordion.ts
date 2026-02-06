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
    const rootEl = this.el.querySelector<HTMLElement>('[data-scope="accordion"][data-part="root"]') || this.el;
    this.spreadProps(rootEl, this.api.getRootProps());

    const items = rootEl.querySelectorAll<HTMLElement>(
      ':scope > [data-scope="accordion"][data-part="item"]'
    );
    
    for (let i = 0; i < items.length; i++) {
      const itemEl = items[i];
      const value = itemEl.dataset.value;
      if (!value) continue;

      const disabled = itemEl.hasAttribute('data-disabled');
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
}