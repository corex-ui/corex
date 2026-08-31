import { connect, machine, type Props, type Api } from "@zag-js/tour";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component, type SchemaOf } from "../lib/core";

type Schema = SchemaOf<typeof machine>;

export class Tour extends Component<Props, Api, Schema> {
  initMachine(props: Props): VanillaMachine<Schema> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  render(): void {
    const backdrop = this.el.querySelector<HTMLElement>(
      '[data-scope="tour"][data-part="backdrop"]'
    );
    if (backdrop) this.spreadProps(backdrop, this.api.getBackdropProps());

    const positioner = this.el.querySelector<HTMLElement>(
      '[data-scope="tour"][data-part="positioner"]'
    );
    if (positioner) this.spreadProps(positioner, this.api.getPositionerProps());

    const content = this.el.querySelector<HTMLElement>('[data-scope="tour"][data-part="content"]');
    if (content) {
      this.spreadProps(content, this.api.getContentProps());
      const title = content.querySelector<HTMLElement>('[data-scope="tour"][data-part="title"]');
      if (title) {
        this.spreadProps(title, this.api.getTitleProps());
        const step = this.api.step;
        if (step) title.textContent = String(step.title ?? "");
      }
      const description = content.querySelector<HTMLElement>(
        '[data-scope="tour"][data-part="description"]'
      );
      if (description) {
        this.spreadProps(description, this.api.getDescriptionProps());
        const step = this.api.step;
        if (step) description.textContent = String(step.description ?? "");
      }
    }

    const close = this.el.querySelector<HTMLElement>(
      '[data-scope="tour"][data-part="close-trigger"]'
    );
    if (close) this.spreadProps(close, this.api.getCloseTriggerProps());
  }
}
