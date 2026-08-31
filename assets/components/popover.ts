import { connect, machine, type Props, type Api } from "@zag-js/popover";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component, type SchemaOf } from "../lib/core";

type Schema = SchemaOf<typeof machine>;

export class Popover extends Component<Props, Api, Schema> {
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

    rootEl.querySelectorAll<HTMLElement>('[data-scope="popover"][data-part="trigger"]').forEach((triggerEl) => {
      const raw = triggerEl.dataset.value;
      const valueProps = raw != null && raw !== "" ? { value: raw } : {};
      this.spreadProps(triggerEl, this.api.getTriggerProps(valueProps));
    });

    const positionerEl = rootEl.querySelector<HTMLElement>(
      '[data-scope="popover"][data-part="positioner"]'
    );
    if (positionerEl) this.spreadProps(positionerEl, this.api.getPositionerProps());

    const contentEl = rootEl.querySelector<HTMLElement>(
      '[data-scope="popover"][data-part="content"]'
    );
    if (contentEl) this.spreadProps(contentEl, this.api.getContentProps());

    const titleEl = rootEl.querySelector<HTMLElement>('[data-scope="popover"][data-part="title"]');
    if (titleEl) this.spreadProps(titleEl, this.api.getTitleProps());

    const descriptionEl = rootEl.querySelector<HTMLElement>(
      '[data-scope="popover"][data-part="description"]'
    );
    if (descriptionEl) this.spreadProps(descriptionEl, this.api.getDescriptionProps());

    const closeEl = rootEl.querySelector<HTMLElement>(
      '[data-scope="popover"][data-part="close-trigger"]'
    );
    if (closeEl) this.spreadProps(closeEl, this.api.getCloseTriggerProps());

    const arrowEl = rootEl.querySelector<HTMLElement>('[data-scope="popover"][data-part="arrow"]');
    if (arrowEl) this.spreadProps(arrowEl, this.api.getArrowProps());

    const arrowTipEl = rootEl.querySelector<HTMLElement>(
      '[data-scope="popover"][data-part="arrow-tip"]'
    );
    if (arrowTipEl) this.spreadProps(arrowTipEl, this.api.getArrowTipProps());
  }
}
