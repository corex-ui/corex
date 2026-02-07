import {connect, machine, type Props, type Api}  from "@zag-js/clipboard";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";

export class Clipboard extends Component<Props, Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return connect(this.machine.service, normalizeProps);
  }

  render(): void {
    const rootEl = this.el.querySelector<HTMLElement>('[data-scope="clipboard"][data-part="root"]');
    if (rootEl) {
      this.spreadProps(rootEl, this.api.getRootProps());

      const labelEl = rootEl.querySelector<HTMLElement>('[data-scope="clipboard"][data-part="label"]');
      if (labelEl) {
        this.spreadProps(labelEl, this.api.getLabelProps());
      }

      const controlEl = rootEl.querySelector<HTMLElement>('[data-scope="clipboard"][data-part="control"]');
      if (controlEl) {
        this.spreadProps(controlEl, this.api.getControlProps());

        const inputEl = controlEl.querySelector<HTMLElement>('[data-scope="clipboard"][data-part="input"]');
        if (inputEl) {
          const inputProps = { ...this.api.getInputProps() };
          const inputAriaLabel = this.el.dataset.inputAriaLabel;
          if (inputAriaLabel) {
            inputProps["aria-label"] = inputAriaLabel;
          }
          this.spreadProps(inputEl, inputProps);
        }

        const triggerEl = controlEl.querySelector<HTMLElement>('[data-scope="clipboard"][data-part="trigger"]');
        if (triggerEl) {
          const triggerProps = { ...this.api.getTriggerProps() };
          const ariaLabel = this.el.dataset.triggerAriaLabel;
          if (ariaLabel) {
            triggerProps["aria-label"] = ariaLabel;
          }
          this.spreadProps(triggerEl, triggerProps);
        }
      }
    }

  }
}