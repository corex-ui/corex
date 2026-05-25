import { connect, machine, type Props, type Api } from "@zag-js/number-input";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component } from "../lib/core";
import { getString } from "../lib/util";
import { syncHiddenInputValue } from "../lib/value-form-sync";

export class NumberInput extends Component<Props, Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  render(): void {
    const rootEl =
      this.el.querySelector<HTMLElement>('[data-scope="number-input"][data-part="root"]') ??
      this.el;
    this.spreadProps(rootEl, this.api.getRootProps());

    const labelEl = this.el.querySelector<HTMLElement>(
      '[data-scope="number-input"][data-part="label"]'
    );
    if (labelEl) this.spreadProps(labelEl, this.api.getLabelProps());

    const controlEl = this.el.querySelector<HTMLElement>(
      '[data-scope="number-input"][data-part="control"]'
    );
    if (controlEl) this.spreadProps(controlEl, this.api.getControlProps());

    const valueTextEl = this.el.querySelector<HTMLElement>(
      '[data-scope="number-input"][data-part="value-text"]'
    );
    if (valueTextEl) this.spreadProps(valueTextEl, this.api.getValueTextProps());

    const inputEl = this.el.querySelector<HTMLElement>(
      '[data-scope="number-input"][data-part="input"]'
    );
    if (inputEl) {
      const visibleProps = { ...(this.api.getInputProps() as Record<string, unknown>) };
      delete visibleProps.name;
      delete visibleProps.form;
      this.spreadProps(inputEl, visibleProps);
    }

    const decrementEl = this.el.querySelector<HTMLElement>(
      '[data-scope="number-input"][data-part="decrement-trigger"]'
    );
    if (decrementEl) this.spreadProps(decrementEl, this.api.getDecrementTriggerProps());

    const incrementEl = this.el.querySelector<HTMLElement>(
      '[data-scope="number-input"][data-part="increment-trigger"]'
    );
    if (incrementEl) this.spreadProps(incrementEl, this.api.getIncrementTriggerProps());

    const valueInputEl = this.el.querySelector<HTMLElement>(
      '[data-scope="number-input"][data-part="value-input"]'
    );
    if (valueInputEl instanceof HTMLInputElement) {
      const value = this.api.value || getString(this.el, "defaultValue") || "";
      syncHiddenInputValue(
        valueInputEl,
        this.el,
        value,
        (el, props) => this.spreadProps(el, props),
        {}
      );
    }
  }
}
