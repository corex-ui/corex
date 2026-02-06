import {connect, machine, type Props, type Api}  from "@zag-js/tabs";
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
    const rootEl = this.el.querySelector<HTMLElement>('[data-scope="tabs"][data-part="root"]') || this.el;
    this.spreadProps(rootEl, this.api.getRootProps());

    const listEl = rootEl.querySelector<HTMLElement>('[data-scope="tabs"][data-part="list"]') || this.el;
    this.spreadProps(rootEl, this.api.getRootProps());

    const triggers = listEl.querySelectorAll<HTMLElement>(
      ':scope > [data-scope="tabs"][data-part="trigger"]'
    );
    
    for (let i = 0; i < triggers.length; i++) {
      const triggerEl = triggers[i];
      const value = triggerEl.dataset.value;
      if (!value) continue;

      this.spreadProps(triggerEl, this.api.getTriggerProps({ value }));
    }
  }
}