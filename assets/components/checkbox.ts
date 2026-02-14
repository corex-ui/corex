import { connect, machine, type Props, type Api } from "@zag-js/checkbox";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";

export class Checkbox extends Component<Props, Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return connect(this.machine.service, normalizeProps);
  }

  render(): void {
    const rootEl = this.el.querySelector<HTMLElement>('[data-scope="checkbox"][data-part="root"]');
    if (!rootEl) return;
    this.spreadProps(rootEl, this.api.getRootProps());

    const inputEl = rootEl.querySelector<HTMLElement>(
      ':scope > [data-scope="checkbox"][data-part="hidden-input"]'
    );
    if (inputEl) {
      this.spreadProps(inputEl, this.api.getHiddenInputProps());
    }

    const labelEl = rootEl.querySelector<HTMLElement>(
      ':scope > [data-scope="checkbox"][data-part="label"]'
    );
    if (labelEl) {
      this.spreadProps(labelEl, this.api.getLabelProps());
    }

    const controlEl = rootEl.querySelector<HTMLElement>(
      ':scope > [data-scope="checkbox"][data-part="control"]'
    );
    if (controlEl) {
      this.spreadProps(controlEl, this.api.getControlProps());

      const indicatorEl = controlEl.querySelector<HTMLElement>(
        ':scope > [data-scope="checkbox"][data-part="indicator"]'
      );
      if (indicatorEl) {
        this.spreadProps(indicatorEl, this.api.getIndicatorProps());
      }
    }
  }
}
