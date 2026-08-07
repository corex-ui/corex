import { connect, machine, type Props, type Api } from "@zag-js/radio-group";
import type { ItemProps } from "@zag-js/radio-group";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component, type SchemaOf } from "../lib/core";
import { hiddenInputPropsWithoutChecked } from "../lib/checkable-form-sync";
import { syncInputFormAssociation } from "../lib/util";

type Schema = SchemaOf<typeof machine>;

export class RadioGroup extends Component<Props, Api, Schema> {
  initMachine(props: Props): VanillaMachine<Schema> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  render(): void {
    const rootEl =
      this.el.querySelector<HTMLElement>('[data-scope="radio-group"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());

    const labelEl = this.el.querySelector<HTMLElement>(
      '[data-scope="radio-group"][data-part="label"]'
    );
    if (labelEl) this.spreadProps(labelEl, this.api.getLabelProps());

    const indicatorEl = this.el.querySelector<HTMLElement>(
      '[data-scope="radio-group"][data-part="indicator"]'
    );
    if (indicatorEl) this.spreadProps(indicatorEl, this.api.getIndicatorProps());

    this.el
      .querySelectorAll<HTMLElement>('[data-scope="radio-group"][data-part="item"]')
      .forEach((itemEl) => {
        const value = itemEl.dataset.value;
        if (value == null) return;
        const disabled = itemEl.dataset.disabled === "true";
        const invalid = itemEl.dataset.invalid === "true";
        this.spreadProps(itemEl, this.api.getItemProps({ value, disabled, invalid }));
        const textEl = itemEl.querySelector<HTMLElement>(
          '[data-scope="radio-group"][data-part="item-text"]'
        );
        if (textEl)
          this.spreadProps(
            textEl,
            this.api.getItemTextProps({ value, disabled, invalid } as ItemProps)
          );
        const controlEl = itemEl.querySelector<HTMLElement>(
          '[data-scope="radio-group"][data-part="item-control"]'
        );
        if (controlEl)
          this.spreadProps(
            controlEl,
            this.api.getItemControlProps({
              value,
              disabled,
              invalid,
            } as ItemProps)
          );
        const hiddenInputEl = itemEl.querySelector<HTMLElement>(
          '[data-scope="radio-group"][data-part="item-hidden-input"]'
        );
        if (hiddenInputEl instanceof HTMLInputElement) {
          this.spreadProps(
            hiddenInputEl,
            hiddenInputPropsWithoutChecked(
              this.api.getItemHiddenInputProps({
                value,
                disabled,
                invalid,
              } as ItemProps) as Record<string, unknown>
            )
          );
          hiddenInputEl.checked = this.api.value === value;
          syncInputFormAssociation(hiddenInputEl, this.el);
        }
      });
  }
}
