import * as zagSwitch from "@zag-js/switch";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";

export class Switch extends Component<zagSwitch.Props, zagSwitch.Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: zagSwitch.Props): VanillaMachine<any> {
    return new VanillaMachine(zagSwitch.machine, props);
  }

  initApi(): zagSwitch.Api {
    return zagSwitch.connect(this.machine.service, normalizeProps);
  }

  render(): void {
    const rootEl = this.el.querySelector<HTMLElement>('[data-scope="switch"][data-part="root"]') || this.el;
    this.spreadProps(rootEl, this.api.getRootProps());

    const inputEl = this.el.querySelector<HTMLElement>('[data-scope="switch"][data-part="hidden-input"]');
    if (inputEl) {
      this.spreadProps(inputEl, this.api.getHiddenInputProps());
    }

    const labelEl = this.el.querySelector<HTMLElement>('[data-scope="switch"][data-part="label"]');
    if (labelEl) {
      this.spreadProps(labelEl, this.api.getLabelProps());
    }

    const controlEl = this.el.querySelector<HTMLElement>('[data-scope="switch"][data-part="control"]');
    if (controlEl) {
      this.spreadProps(controlEl, this.api.getControlProps());
    }

    const thumbEl = this.el.querySelector<HTMLElement>('[data-scope="switch"][data-part="thumb"]');
    if (thumbEl) {
      this.spreadProps(thumbEl, this.api.getThumbProps());
    }
  }
}
