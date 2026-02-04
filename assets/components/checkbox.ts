import * as zagCheckbox from "@zag-js/checkbox";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";

export class Checkbox extends Component<zagCheckbox.Props, zagCheckbox.Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: zagCheckbox.Props): VanillaMachine<any> {
    return new VanillaMachine(zagCheckbox.machine, props);
  }

  initApi(): zagCheckbox.Api {
    return zagCheckbox.connect(this.machine.service, normalizeProps);
  }

  render(): void {
    const rootEl = this.el.querySelector<HTMLElement>('[data-scope="checkbox"][data-part="root"]') || this.el;
    this.spreadProps(rootEl, this.api.getRootProps());

    const inputEl = this.el.querySelector<HTMLElement>('[data-scope="checkbox"][data-part="hidden-input"]');
    if (inputEl) {
      this.spreadProps(inputEl, this.api.getHiddenInputProps());
    }

    const labelEl = this.el.querySelector<HTMLElement>('[data-scope="checkbox"][data-part="label"]');
    if (labelEl) {
      this.spreadProps(labelEl, this.api.getLabelProps());
    }

    const controlEl = this.el.querySelector<HTMLElement>('[data-scope="checkbox"][data-part="control"]');
    if (controlEl) {
      this.spreadProps(controlEl, this.api.getControlProps());
    }

    const indicatorEl = this.el.querySelector<HTMLElement>('[data-scope="checkbox"][data-part="indicator"]');
    if (indicatorEl) {
      this.spreadProps(indicatorEl, this.api.getIndicatorProps());
    }
  }
}
