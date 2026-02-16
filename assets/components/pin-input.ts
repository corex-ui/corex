import { connect, machine, type Props, type Api } from "@zag-js/pin-input";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";

export class PinInput extends Component<Props, Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return connect(this.machine.service, normalizeProps);
  }

  render(): void {
    const rootEl =
      this.el.querySelector<HTMLElement>('[data-scope="pin-input"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());

    const labelEl = this.el.querySelector<HTMLElement>(
      '[data-scope="pin-input"][data-part="label"]'
    );
    if (labelEl) this.spreadProps(labelEl, this.api.getLabelProps());

    const hiddenInputEl = this.el.querySelector<HTMLElement>(
      '[data-scope="pin-input"][data-part="hidden-input"]'
    );
    if (hiddenInputEl) this.spreadProps(hiddenInputEl, this.api.getHiddenInputProps());

    const controlEl = this.el.querySelector<HTMLElement>(
      '[data-scope="pin-input"][data-part="control"]'
    );
    if (controlEl) this.spreadProps(controlEl, this.api.getControlProps());

    this.api.items.forEach((i) => {
      const inputEl = this.el.querySelector<HTMLElement>(
        `[data-scope="pin-input"][data-part="input"][data-index="${i}"]`
      );
      if (inputEl) this.spreadProps(inputEl, this.api.getInputProps({ index: i }));
    });
  }
}
