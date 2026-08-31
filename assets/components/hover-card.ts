import { connect, machine, type Props, type Api } from "@zag-js/hover-card";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component, type SchemaOf } from "../lib/core";

type Schema = SchemaOf<typeof machine>;

export class HoverCard extends Component<Props, Api, Schema> {
  initMachine(props: Props): VanillaMachine<Schema> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  syncDom(): void {
    this.api = this.initApi();
    this.render();
  }

  render(): void {
    const rootEl = this.el;

    rootEl
      .querySelectorAll<HTMLElement>('[data-scope="hover-card"][data-part="trigger"]')
      .forEach((triggerEl) => {
        const raw = triggerEl.dataset.value;
        const valueProps = raw != null && raw !== "" ? { value: raw } : {};
        this.spreadProps(triggerEl, this.api.getTriggerProps(valueProps));
      });

    const positionerEl = rootEl.querySelector<HTMLElement>(
      '[data-scope="hover-card"][data-part="positioner"]'
    );
    if (positionerEl) this.spreadProps(positionerEl, this.api.getPositionerProps());

    const contentEl = rootEl.querySelector<HTMLElement>(
      '[data-scope="hover-card"][data-part="content"]'
    );
    if (contentEl) this.spreadProps(contentEl, this.api.getContentProps());

    const arrowEl = rootEl.querySelector<HTMLElement>('[data-scope="hover-card"][data-part="arrow"]');
    if (arrowEl) this.spreadProps(arrowEl, this.api.getArrowProps());

    const arrowTipEl = rootEl.querySelector<HTMLElement>(
      '[data-scope="hover-card"][data-part="arrow-tip"]'
    );
    if (arrowTipEl) this.spreadProps(arrowTipEl, this.api.getArrowTipProps());
  }
}
