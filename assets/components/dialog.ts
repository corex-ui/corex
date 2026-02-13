import {connect, machine, type Props, type Api}  from "@zag-js/dialog";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";

export class Dialog extends Component<Props, Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return connect(this.machine.service, normalizeProps);
  }

  render(): void {
    const rootEl = this.el;

    const triggerEl = rootEl.querySelector<HTMLElement>('[data-scope="dialog"][data-part="trigger"]');
    if (triggerEl) this.spreadProps(triggerEl, this.api.getTriggerProps());

    const backdropEl = rootEl.querySelector<HTMLElement>('[data-scope="dialog"][data-part="backdrop"]');
    if (backdropEl) this.spreadProps(backdropEl, this.api.getBackdropProps());

    const positionerEl = rootEl.querySelector<HTMLElement>('[data-scope="dialog"][data-part="positioner"]');
    if (positionerEl) this.spreadProps(positionerEl, this.api.getPositionerProps());

    const contentEl = rootEl.querySelector<HTMLElement>('[data-scope="dialog"][data-part="content"]');
    if (contentEl) this.spreadProps(contentEl, this.api.getContentProps());

    const titleEl = rootEl.querySelector<HTMLElement>('[data-scope="dialog"][data-part="title"]');
    if (titleEl) this.spreadProps(titleEl, this.api.getTitleProps());

    const descriptionEl = rootEl.querySelector<HTMLElement>('[data-scope="dialog"][data-part="description"]');
    if (descriptionEl) this.spreadProps(descriptionEl, this.api.getDescriptionProps());

    const closeTriggerEl = rootEl.querySelector<HTMLElement>('[data-scope="dialog"][data-part="close-trigger"]');
    if (closeTriggerEl) this.spreadProps(closeTriggerEl, this.api.getCloseTriggerProps());
  }
}