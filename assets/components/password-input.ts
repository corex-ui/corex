import { connect, machine, type Props, type Api } from "@zag-js/password-input";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component, type SchemaOf } from "../lib/core";

type Schema = SchemaOf<typeof machine>;

export class PasswordInput extends Component<Props, Api, Schema> {
  initMachine(props: Props): VanillaMachine<Schema> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
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
