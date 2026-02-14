import { connect, machine, type Props, type Api } from "@zag-js/tabs";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";

export class Tabs extends Component<Props, Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return connect(this.machine.service, normalizeProps);
  }

  render(): void {
    const rootEl = this.el.querySelector<HTMLElement>('[data-scope="tabs"][data-part="root"]');
    if (!rootEl) return;
    this.spreadProps(rootEl, this.api.getRootProps());

    const listEl = rootEl.querySelector<HTMLElement>('[data-scope="tabs"][data-part="list"]');
    if (!listEl) return;
    this.spreadProps(listEl, this.api.getListProps());

    const itemsData = this.el.getAttribute("data-items");
    const items: Array<{ value: string; disabled: boolean }> = itemsData
      ? JSON.parse(itemsData)
      : [];

    const triggers = listEl.querySelectorAll<HTMLElement>(
      '[data-scope="tabs"][data-part="trigger"]'
    );

    for (let i = 0; i < triggers.length && i < items.length; i++) {
      const triggerEl = triggers[i];
      const item = items[i];
      this.spreadProps(
        triggerEl,
        this.api.getTriggerProps({ value: item.value, disabled: item.disabled })
      );
    }

    const contents = rootEl.querySelectorAll<HTMLElement>(
      '[data-scope="tabs"][data-part="content"]'
    );

    for (let i = 0; i < contents.length && i < items.length; i++) {
      const contentEl = contents[i];
      const item = items[i];
      this.spreadProps(contentEl, this.api.getContentProps({ value: item.value }));
    }
  }
}
