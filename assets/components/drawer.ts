import { connect, machine, type Props, type Api } from "@zag-js/drawer";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component, type SchemaOf } from "../lib/core";

type Schema = SchemaOf<typeof machine>;

// Zag Props allow `defaultSnapPoint: null`; the machine schema does not.
export class Drawer extends Component<any, Api, Schema> {
  initMachine(props: Props): VanillaMachine<Schema> {
    return new VanillaMachine(machine, props as never);
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

    rootEl.querySelectorAll<HTMLElement>('[data-scope="drawer"][data-part="trigger"]').forEach((triggerEl) => {
      const raw = triggerEl.dataset.value;
      const valueProps = raw != null && raw !== "" ? { value: raw } : {};
      this.spreadProps(triggerEl, this.api.getTriggerProps(valueProps));
    });

    const backdropEl = rootEl.querySelector<HTMLElement>(
      '[data-scope="drawer"][data-part="backdrop"]'
    );
    if (backdropEl) this.spreadProps(backdropEl, this.api.getBackdropProps());

    const positionerEl = rootEl.querySelector<HTMLElement>(
      '[data-scope="drawer"][data-part="positioner"]'
    );
    if (positionerEl) this.spreadProps(positionerEl, this.api.getPositionerProps());

    const contentEl = rootEl.querySelector<HTMLElement>(
      '[data-scope="drawer"][data-part="content"]'
    );
    if (contentEl) this.spreadProps(contentEl, this.api.getContentProps());

    const titleEl = rootEl.querySelector<HTMLElement>('[data-scope="drawer"][data-part="title"]');
    if (titleEl) this.spreadProps(titleEl, this.api.getTitleProps());

    const descriptionEl = rootEl.querySelector<HTMLElement>(
      '[data-scope="drawer"][data-part="description"]'
    );
    if (descriptionEl) this.spreadProps(descriptionEl, this.api.getDescriptionProps());

    const closeEl = rootEl.querySelector<HTMLElement>(
      '[data-scope="drawer"][data-part="close-trigger"]'
    );
    if (closeEl) this.spreadProps(closeEl, this.api.getCloseTriggerProps());

    const grabberEl = rootEl.querySelector<HTMLElement>(
      '[data-scope="drawer"][data-part="grabber"]'
    );
    if (grabberEl) this.spreadProps(grabberEl, this.api.getGrabberProps());

    const grabberIndicatorEl = rootEl.querySelector<HTMLElement>(
      '[data-scope="drawer"][data-part="grabber-indicator"]'
    );
    if (grabberIndicatorEl) this.spreadProps(grabberIndicatorEl, this.api.getGrabberIndicatorProps());
  }
}
