import { connect, machine, type Props, type Api } from "@zag-js/slider";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component, type SchemaOf } from "../lib/core";
import { syncHiddenInputValue } from "../lib/value-form-sync";

type Schema = SchemaOf<typeof machine>;

export function formatSliderNumber(n: number): string {
  if (Number.isFinite(n) && n === Math.trunc(n)) return String(Math.trunc(n));
  return String(n);
}

export function formatSliderValues(values: ReadonlyArray<number>): string {
  return values.map(formatSliderNumber).join(" – ");
}

function thumbIndex(el: HTMLElement): number {
  const raw = el.dataset.index;
  const n = raw === undefined ? 0 : Number(raw);
  return Number.isFinite(n) ? n : 0;
}

export class Slider extends Component<Props, Api, Schema> {
  initMachine(props: Props): VanillaMachine<Schema> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  render(): void {
    const rootEl =
      this.el.querySelector<HTMLElement>('[data-scope="slider"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());

    const labelEl = this.el.querySelector<HTMLElement>('[data-scope="slider"][data-part="label"]');
    if (labelEl) this.spreadProps(labelEl, this.api.getLabelProps());

    const controlEl = this.el.querySelector<HTMLElement>(
      '[data-scope="slider"][data-part="control"]'
    );
    if (controlEl) this.spreadProps(controlEl, this.api.getControlProps());

    const trackEl = this.el.querySelector<HTMLElement>('[data-scope="slider"][data-part="track"]');
    if (trackEl) this.spreadProps(trackEl, this.api.getTrackProps());

    const rangeEl = this.el.querySelector<HTMLElement>('[data-scope="slider"][data-part="range"]');
    if (rangeEl) this.spreadProps(rangeEl, this.api.getRangeProps());

    const submitName = this.el.dataset.submitName;
    const gatedName = this.el.dataset.name;
    const gateHiddenName = Boolean(submitName && !gatedName);

    this.el
      .querySelectorAll<HTMLElement>('[data-scope="slider"][data-part="thumb"]')
      .forEach((thumbEl) => {
        const index = thumbIndex(thumbEl);
        this.spreadProps(thumbEl, this.api.getThumbProps({ index }));
      });

    this.el
      .querySelectorAll<HTMLElement>('[data-scope="slider"][data-part="hidden-input"]')
      .forEach((hiddenEl) => {
        if (!(hiddenEl instanceof HTMLInputElement)) return;
        const index = thumbIndex(hiddenEl);
        const value = this.api.value[index];
        syncHiddenInputValue(
          hiddenEl,
          this.el,
          value === undefined ? "" : String(value),
          (el, props) => this.spreadProps(el, props),
          this.api.getHiddenInputProps({ index }) as Record<string, unknown>
        );
        if (gateHiddenName) {
          hiddenEl.removeAttribute("name");
          hiddenEl.removeAttribute("form");
        } else if (submitName && !hiddenEl.getAttribute("name")) {
          hiddenEl.setAttribute("name", submitName);
        }
      });

    const valueTextEl = this.el.querySelector<HTMLElement>(
      '[data-scope="slider"][data-part="value-text"]'
    );
    if (valueTextEl) {
      this.spreadProps(valueTextEl, this.api.getValueTextProps());
      const valueSpan = valueTextEl.querySelector<HTMLElement>(
        '[data-scope="slider"][data-part="value"]'
      );
      const nextValue = formatSliderValues(this.api.value);
      if (valueSpan && valueSpan.textContent !== nextValue) valueSpan.textContent = nextValue;
    }

    const markerGroupEl = this.el.querySelector<HTMLElement>(
      '[data-scope="slider"][data-part="marker-group"]'
    );
    if (markerGroupEl) this.spreadProps(markerGroupEl, this.api.getMarkerGroupProps());

    this.el
      .querySelectorAll<HTMLElement>('[data-scope="slider"][data-part="marker"]')
      .forEach((markerEl) => {
        const valueStr = markerEl.dataset.value;
        if (valueStr == null) return;
        const value = Number(valueStr);
        if (Number.isNaN(value)) return;
        this.spreadProps(markerEl, this.api.getMarkerProps({ value }));
      });
  }
}
