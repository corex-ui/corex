import { connect, machine, parse, type Props, type Api } from "@zag-js/color-picker";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component, type SchemaOf } from "../lib/core";
import { syncHiddenInputValue } from "../lib/value-form-sync";

type Schema = SchemaOf<typeof machine>;

export class ColorPicker extends Component<Props, Api, Schema> {
  initMachine(props: Props): VanillaMachine<Schema> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  private reassertSwatchColor(swatchEl: HTMLElement, colorValue: unknown): void {
    this.spreadProps(swatchEl, this.api.getSwatchProps({ value: colorValue as never }));
    let color =
      typeof colorValue === "string"
        ? colorValue
        : ((colorValue as { toString?: (format?: string) => string } | null)?.toString?.("css") ??
          "");
    if (
      !color &&
      colorValue &&
      typeof (colorValue as { toString?: () => string }).toString === "function"
    ) {
      try {
        color = String((colorValue as { toString: () => string }).toString());
      } catch {
        color = "";
      }
    }
    if (!color && this.api.valueAsString) color = this.api.valueAsString;
    if (color) {
      swatchEl.style.setProperty("--color", color);
      swatchEl.style.background = color;
    }
  }

  render(): void {
    const rootEl = this.el.querySelector<HTMLElement>('[data-part="root"]');
    if (rootEl) this.spreadProps(rootEl, this.api.getRootProps());

    const labelEl = this.el.querySelector<HTMLElement>('[data-part="label"]');
    if (labelEl) this.spreadProps(labelEl, this.api.getLabelProps());

    const hiddenInputEl = this.el.querySelector<HTMLInputElement>('[data-part="hidden-input"]');
    if (hiddenInputEl) {
      syncHiddenInputValue(
        hiddenInputEl,
        this.el,
        this.api.valueAsString ?? "",
        (el, props) => this.spreadProps(el, props),
        this.api.getHiddenInputProps() as Record<string, unknown>
      );
    }

    const controlEl = this.el.querySelector<HTMLElement>('[data-part="control"]');
    if (controlEl) this.spreadProps(controlEl, this.api.getControlProps());

    const triggerEl = this.el.querySelector<HTMLElement>('[data-part="trigger"]');
    if (triggerEl) this.spreadProps(triggerEl, this.api.getTriggerProps());

    const transparencyGrids = this.el.querySelectorAll<HTMLElement>(
      '[data-part="transparency-grid"]'
    );
    transparencyGrids.forEach((el) => {
      const size = el.getAttribute("data-size") || "12px";
      this.spreadProps(el, this.api.getTransparencyGridProps({ size }));
    });

    const triggerSwatch = triggerEl?.querySelector<HTMLElement>('[data-part="swatch"]');
    if (triggerSwatch) {
      this.reassertSwatchColor(triggerSwatch, this.api.value);
    }

    const hexInputs = this.el.querySelectorAll<HTMLInputElement>(
      '[data-part="channel-input"][data-channel="hex"]'
    );
    hexInputs.forEach((el) =>
      this.spreadProps(el, this.api.getChannelInputProps({ channel: "hex" }))
    );

    const alphaInputs = this.el.querySelectorAll<HTMLInputElement>(
      '[data-part="channel-input"][data-channel="alpha"]'
    );
    alphaInputs.forEach((el) =>
      this.spreadProps(el, this.api.getChannelInputProps({ channel: "alpha" }))
    );

    const positionerEl = this.el.querySelector<HTMLElement>('[data-part="positioner"]');
    if (positionerEl) this.spreadProps(positionerEl, this.api.getPositionerProps());

    const contentEl = this.el.querySelector<HTMLElement>('[data-part="content"]');
    if (contentEl) this.spreadProps(contentEl, this.api.getContentProps());

    const areaEl = this.el.querySelector<HTMLElement>('[data-part="area"]');
    if (areaEl) this.spreadProps(areaEl, this.api.getAreaProps());

    const areaBgEl = this.el.querySelector<HTMLElement>('[data-part="area-background"]');
    if (areaBgEl) this.spreadProps(areaBgEl, this.api.getAreaBackgroundProps());

    const areaThumbEl = this.el.querySelector<HTMLElement>('[data-part="area-thumb"]');
    if (areaThumbEl) this.spreadProps(areaThumbEl, this.api.getAreaThumbProps());

    const hueSliderEl = this.el.querySelector<HTMLElement>(
      '[data-part="channel-slider"][data-channel="hue"]'
    );
    if (hueSliderEl)
      this.spreadProps(hueSliderEl, this.api.getChannelSliderProps({ channel: "hue" }));

    const hueTrackEl = this.el.querySelector<HTMLElement>(
      '[data-part="channel-slider-track"][data-channel="hue"]'
    );
    if (hueTrackEl)
      this.spreadProps(
        hueTrackEl,
        this.api.getChannelSliderTrackProps({ channel: "hue", format: "hsba" })
      );

    const hueThumbEl = this.el.querySelector<HTMLElement>(
      '[data-part="channel-slider-thumb"][data-channel="hue"]'
    );
    if (hueThumbEl)
      this.spreadProps(
        hueThumbEl,
        this.api.getChannelSliderThumbProps({ channel: "hue", format: "hsba" })
      );

    const alphaSliderEl = this.el.querySelector<HTMLElement>(
      '[data-part="channel-slider"][data-channel="alpha"]'
    );
    if (alphaSliderEl)
      this.spreadProps(alphaSliderEl, this.api.getChannelSliderProps({ channel: "alpha" }));

    const alphaTrackEl = this.el.querySelector<HTMLElement>(
      '[data-part="channel-slider-track"][data-channel="alpha"]'
    );
    if (alphaTrackEl)
      this.spreadProps(
        alphaTrackEl,
        this.api.getChannelSliderTrackProps({ channel: "alpha", format: "hsba" })
      );

    const alphaThumbEl = this.el.querySelector<HTMLElement>(
      '[data-part="channel-slider-thumb"][data-channel="alpha"]'
    );
    if (alphaThumbEl)
      this.spreadProps(
        alphaThumbEl,
        this.api.getChannelSliderThumbProps({ channel: "alpha", format: "hsba" })
      );

    const redInputs = this.el.querySelectorAll<HTMLInputElement>(
      '[data-part="channel-input"][data-channel="red"]'
    );
    redInputs.forEach((el) =>
      this.spreadProps(el, this.api.getChannelInputProps({ channel: "red" }))
    );

    const greenInputs = this.el.querySelectorAll<HTMLInputElement>(
      '[data-part="channel-input"][data-channel="green"]'
    );
    greenInputs.forEach((el) =>
      this.spreadProps(el, this.api.getChannelInputProps({ channel: "green" }))
    );

    const blueInputs = this.el.querySelectorAll<HTMLInputElement>(
      '[data-part="channel-input"][data-channel="blue"]'
    );
    blueInputs.forEach((el) =>
      this.spreadProps(el, this.api.getChannelInputProps({ channel: "blue" }))
    );

    const swatchGroupEl = this.el.querySelector<HTMLElement>('[data-part="swatch-group"]');
    if (swatchGroupEl) this.spreadProps(swatchGroupEl, this.api.getSwatchGroupProps());

    const swatchTriggers = this.el.querySelectorAll<HTMLElement>(
      '[data-part="swatch-trigger"][data-value]'
    );
    swatchTriggers.forEach((trigger) => {
      const value = trigger.getAttribute("data-value");
      if (value) this.spreadProps(trigger, this.api.getSwatchTriggerProps({ value }));
      const swatchEl = trigger.querySelector<HTMLElement>('[data-part="swatch"][data-value]');
      if (swatchEl) {
        const swatchValue = swatchEl.getAttribute("data-value");
        if (swatchValue) this.reassertSwatchColor(swatchEl, swatchValue);
      }
    });
  }
}

export { parse };
