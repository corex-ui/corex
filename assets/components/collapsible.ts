import { connect, machine, type Props, type Api } from "@zag-js/collapsible";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component, type SchemaOf } from "../lib/core";

type Schema = SchemaOf<typeof machine>;

export class Collapsible extends Component<Props, Api, Schema> {
  initMachine(props: Props): VanillaMachine<Schema> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  render(): void {
    const orientation = this.el.dataset.orientation;
    const rootEl = this.el.querySelector<HTMLElement>(
      '[data-scope="collapsible"][data-part="root"]'
    );
    if (rootEl) {
      this.spreadProps(rootEl, this.api.getRootProps());
      if (orientation) rootEl.dataset.orientation = orientation;

      const triggerEl = rootEl.querySelector<HTMLElement>(
        '[data-scope="collapsible"][data-part="trigger"]'
      );
      if (triggerEl) {
        this.spreadProps(triggerEl, this.api.getTriggerProps());
        if (orientation) triggerEl.dataset.orientation = orientation;
      }

      const contentEl = rootEl.querySelector<HTMLElement>(
        '[data-scope="collapsible"][data-part="content"]'
      );
      if (contentEl) {
        this.spreadProps(contentEl, this.api.getContentProps());
        if (orientation) contentEl.dataset.orientation = orientation;
      }
    }
  }
}
