import { connect, machine, type Props, type Api } from "@zag-js/pin-input";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component, type SchemaOf } from "../lib/core";
import { stripZagSubmitNames } from "../lib/form-field-array-submit";
import { getString } from "../lib/util";
import { syncHiddenInputValue } from "../lib/value-form-sync";

type Schema = SchemaOf<typeof machine>;

export class PinInput extends Component<Props, Api, Schema> {
  initMachine(props: Props): VanillaMachine<Schema> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
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
    if (hiddenInputEl instanceof HTMLInputElement) {
      syncHiddenInputValue(
        hiddenInputEl,
        this.el,
        this.api.valueAsString ?? "",
        (el, props) => this.spreadProps(el, props),
        this.api.getHiddenInputProps() as Record<string, unknown>
      );
      if (getString(this.el, "submitName")) {
        hiddenInputEl.removeAttribute("name");
        hiddenInputEl.removeAttribute("form");
      }
    }

    stripZagSubmitNames(this.el, "pin-input");

    const controlEl = this.el.querySelector<HTMLElement>(
      '[data-scope="pin-input"][data-part="control"]'
    );
    if (controlEl) this.spreadProps(controlEl, this.api.getControlProps());

    // Prefer DOM order over data-index lookup so props (incl. data-ownedby) are
    // always applied — Zag focus advance queries inputs by [data-ownedby].
    const inputEls = Array.from(
      this.el.querySelectorAll<HTMLElement>('[data-scope="pin-input"][data-part="input"]')
    );
    const count = Math.max(this.api.items?.length ?? 0, inputEls.length);
    for (let i = 0; i < count; i += 1) {
      const inputEl =
        inputEls[i] ??
        this.el.querySelector<HTMLElement>(
          `[data-scope="pin-input"][data-part="input"][data-index="${i}"]`
        );
      if (inputEl) this.spreadProps(inputEl, this.api.getInputProps({ index: i }));
    }
  }
}
