import { connect, machine, type Props, type Api } from "@zag-js/password-input";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";

export class PasswordInput extends Component<Props, Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return connect(this.machine.service, normalizeProps);
  }

  render(): void {
    const rootEl =
      this.el.querySelector<HTMLElement>('[data-scope="password-input"][data-part="root"]') ??
      this.el;
    this.spreadProps(rootEl, this.api.getRootProps());

    const labelEl = this.el.querySelector<HTMLElement>(
      '[data-scope="password-input"][data-part="label"]'
    );
    if (labelEl) this.spreadProps(labelEl, this.api.getLabelProps());

    const controlEl = this.el.querySelector<HTMLElement>(
      '[data-scope="password-input"][data-part="control"]'
    );
    if (controlEl) this.spreadProps(controlEl, this.api.getControlProps());

    const inputEl = this.el.querySelector<HTMLElement>(
      '[data-scope="password-input"][data-part="input"]'
    );
    if (inputEl) this.spreadProps(inputEl, this.api.getInputProps());

    const triggerEl = this.el.querySelector<HTMLElement>(
      '[data-scope="password-input"][data-part="visibility-trigger"]'
    );
    if (triggerEl) this.spreadProps(triggerEl, this.api.getVisibilityTriggerProps());

    const indicatorEl = this.el.querySelector<HTMLElement>(
      '[data-scope="password-input"][data-part="indicator"]'
    );
    if (indicatorEl) this.spreadProps(indicatorEl, this.api.getIndicatorProps());
  }
}
