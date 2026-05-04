import { connect, machine, type Props, type Api } from "@zag-js/angle-slider";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component } from "../lib/core";

export class AngleSlider extends Component<Props, Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  render(): void {
    const rootEl =
      this.el.querySelector<HTMLElement>('[data-scope="angle-slider"][data-part="root"]') ??
      this.el;
    this.spreadProps(rootEl, this.api.getRootProps());

    const labelEl = this.el.querySelector<HTMLElement>(
      '[data-scope="angle-slider"][data-part="label"]'
    );
    if (labelEl) this.spreadProps(labelEl, this.api.getLabelProps());

    const hiddenInputEl = this.el.querySelector<HTMLElement>(
      '[data-scope="angle-slider"][data-part="hidden-input"]'
    );
    if (hiddenInputEl) this.spreadProps(hiddenInputEl, this.api.getHiddenInputProps());

    const controlEl = this.el.querySelector<HTMLElement>(
      '[data-scope="angle-slider"][data-part="control"]'
    );
    if (controlEl) this.spreadProps(controlEl, this.api.getControlProps());

    const thumbEl = this.el.querySelector<HTMLElement>(
      '[data-scope="angle-slider"][data-part="thumb"]'
    );
    if (thumbEl) this.spreadProps(thumbEl, this.api.getThumbProps());

    const valueTextEl = this.el.querySelector<HTMLElement>(
      '[data-scope="angle-slider"][data-part="value-text"]'
    );
    if (valueTextEl) {
      this.spreadProps(valueTextEl, this.api.getValueTextProps());
      const valueSpan = valueTextEl.querySelector<HTMLElement>(
        '[data-scope="angle-slider"][data-part="value"]'
      );
      const format = this.el.dataset.valueTextAs;
      const nextValue =
        format === "raw"
          ? String(this.api.value)
          : String(this.api.valueAsDegree ?? this.api.value);
      if (valueSpan && valueSpan.textContent !== nextValue) valueSpan.textContent = nextValue;
    }

    const markerGroupEl = this.el.querySelector<HTMLElement>(
      '[data-scope="angle-slider"][data-part="marker-group"]'
    );
    if (markerGroupEl) this.spreadProps(markerGroupEl, this.api.getMarkerGroupProps());

    this.el
      .querySelectorAll<HTMLElement>('[data-scope="angle-slider"][data-part="marker"]')
      .forEach((markerEl) => {
        const valueStr = markerEl.dataset.value;
        if (valueStr == null) return;
        const value = Number(valueStr);
        if (Number.isNaN(value)) return;
        this.spreadProps(markerEl, this.api.getMarkerProps({ value }));
      });
  }
}
