import * as accordion from "@zag-js/accordion";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";
import { getString, getBoolean } from "../lib/util";

export class Accordion extends Component<accordion.Props, accordion.Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: accordion.Props): VanillaMachine<any> {
    return new VanillaMachine(accordion.machine, props);
  }

  initApi(): accordion.Api {
    return accordion.connect(this.machine.service, normalizeProps);
  }

  render(): void {
    const rootEl = this.el.querySelector<HTMLElement>('[data-part="root"]') || this.el;
    this.spreadProps(rootEl, this.api.getRootProps());

    const items = this.el.querySelectorAll<HTMLElement>('[data-part="item"]');

    for (let i = 0; i < items.length; i++) {
      const itemEl = items[i];
      const value = getString(itemEl, "value");
      if (!value) continue;

      const disabled = getBoolean(itemEl, "disabled");
      this.spreadProps(itemEl, this.api.getItemProps({ value, disabled }));

      const triggerEl = itemEl.querySelector<HTMLElement>('[data-part="item-trigger"]');
      if (triggerEl) {
        this.spreadProps(triggerEl, this.api.getItemTriggerProps({ value, disabled }));
      }

      const indicatorEl = itemEl.querySelector<HTMLElement>('[data-part="item-indicator"]');
      if (indicatorEl) {
        this.spreadProps(indicatorEl, this.api.getItemIndicatorProps({ value, disabled }));
      }

      const contentEl = itemEl.querySelector<HTMLElement>('[data-part="item-content"]');
      if (contentEl) {
        this.spreadProps(contentEl, this.api.getItemContentProps({ value, disabled }));
      }
    }
  }
}
