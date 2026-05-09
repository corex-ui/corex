import { connect, machine, type Props, type Api } from "@zag-js/tooltip";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component } from "../lib/core";

export class Tooltip extends Component<Props, Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
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

    const triggerEls = rootEl.querySelectorAll<HTMLElement>(
      '[data-scope="tooltip"][data-part="trigger"]'
    );

    triggerEls.forEach((triggerEl) => {
      const raw = triggerEl.dataset.value;
      const valueProps = raw != null && raw !== "" ? { value: raw } : {};
      this.spreadProps(triggerEl, this.api.getTriggerProps(valueProps));
    });

    const positionerEl = rootEl.querySelector<HTMLElement>(
      '[data-scope="tooltip"][data-part="positioner"]'
    );
    if (positionerEl) this.spreadProps(positionerEl, this.api.getPositionerProps());

    const contentEl = rootEl.querySelector<HTMLElement>(
      '[data-scope="tooltip"][data-part="content"]'
    );
    if (contentEl) this.spreadProps(contentEl, this.api.getContentProps());

    const arrowEl = rootEl.querySelector<HTMLElement>('[data-scope="tooltip"][data-part="arrow"]');
    if (arrowEl) this.spreadProps(arrowEl, this.api.getArrowProps());

    const arrowTipEl = rootEl.querySelector<HTMLElement>(
      '[data-scope="tooltip"][data-part="arrow-tip"]'
    );
    if (arrowTipEl) this.spreadProps(arrowTipEl, this.api.getArrowTipProps());
  }
}
