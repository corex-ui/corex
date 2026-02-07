import {connect, machine, type Props, type Api}  from "@zag-js/collapsible";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";

export class Collapsible extends Component<Props, Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return connect(this.machine.service, normalizeProps);
  }

  render(): void {
    const rootEl = this.el.querySelector<HTMLElement>('[data-scope="collapsible"][data-part="root"]');
    if (rootEl) {
      this.spreadProps(rootEl, this.api.getRootProps());

      const triggerEl = rootEl.querySelector<HTMLElement>('[data-scope="collapsible"][data-part="trigger"]');
      if (triggerEl) {
        this.spreadProps(triggerEl, this.api.getTriggerProps());
      }

      const contentEl = rootEl.querySelector<HTMLElement>('[data-scope="collapsible"][data-part="content"]');
      if (contentEl) {
        this.spreadProps(contentEl, this.api.getContentProps());
      }
    }

  }
}