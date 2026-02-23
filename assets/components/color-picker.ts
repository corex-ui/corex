import { connect, machine, parse, type Props, type Api } from "@zag-js/color-picker";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";

export class ColorPicker extends Component<Props, Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return connect(this.machine.service, normalizeProps);
  }

  render(): void {
    const rootEl = this.el.querySelector<HTMLElement>('[data-part="root"]');
    if (rootEl) this.spreadProps(rootEl, this.api.getRootProps());

    const labelEl = this.el.querySelector<HTMLElement>('[data-part="label"]');
    if (labelEl) this.spreadProps(labelEl, this.api.getLabelProps());

    const hiddenInputEl = this.el.querySelector<HTMLInputElement>('[data-part="hidden-input"]');
    if (hiddenInputEl) this.spreadProps(hiddenInputEl, this.api.getHiddenInputProps());

    const controlEl = this.el.querySelector<HTMLElement>('[data-part="control"]');
    if (controlEl) this.spreadProps(controlEl, this.api.getControlProps());

    const triggerEl = this.el.querySelector<HTMLElement>('[data-part="trigger"]');
    if (triggerEl) this.spreadProps(triggerEl, this.api.getTriggerProps());

    const triggerGrids = this.el.querySelectorAll<HTMLElement>(
      '[data-part="transparency-grid"][data-size="10px"]'
    );
    triggerGrids.forEach((el) =>
      this.spreadProps(el, this.api.getTransparencyGridProps({ size: "10px" }))
    );

    const triggerSwatch = triggerEl?.querySelector<HTMLElement>('[data-part="swatch"]');
    if (triggerSwatch)
      this.spreadProps(triggerSwatch, this.api.getSwatchProps({ value: this.api.value }));

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
      this.spreadProps(hueTrackEl, this.api.getChannelSliderTrackProps({ channel: "hue" }));

    const hueThumbEl = this.el.querySelector<HTMLElement>(
      '[data-part="channel-slider-thumb"][data-channel="hue"]'
    );
    if (hueThumbEl)
      this.spreadProps(hueThumbEl, this.api.getChannelSliderThumbProps({ channel: "hue" }));

    const alphaSliderEl = this.el.querySelector<HTMLElement>(
      '[data-part="channel-slider"][data-channel="alpha"]'
    );
    if (alphaSliderEl)
      this.spreadProps(alphaSliderEl, this.api.getChannelSliderProps({ channel: "alpha" }));

    const alphaGrids = this.el.querySelectorAll<HTMLElement>(
      '[data-part="transparency-grid"][data-size="12px"]'
    );
    alphaGrids.forEach((el) =>
      this.spreadProps(el, this.api.getTransparencyGridProps({ size: "12px" }))
    );

    const alphaTrackEl = this.el.querySelector<HTMLElement>(
      '[data-part="channel-slider-track"][data-channel="alpha"]'
    );
    if (alphaTrackEl)
      this.spreadProps(alphaTrackEl, this.api.getChannelSliderTrackProps({ channel: "alpha" }));

    const alphaThumbEl = this.el.querySelector<HTMLElement>(
      '[data-part="channel-slider-thumb"][data-channel="alpha"]'
    );
    if (alphaThumbEl)
      this.spreadProps(alphaThumbEl, this.api.getChannelSliderThumbProps({ channel: "alpha" }));

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
        if (swatchValue)
          this.spreadProps(swatchEl, this.api.getSwatchProps({ value: swatchValue }));
      }
    });

    const swatchGrids = this.el.querySelectorAll<HTMLElement>(
      '[data-part="transparency-grid"][data-size="var(--spacing-mini)"]'
    );
    swatchGrids.forEach((el) =>
      this.spreadProps(el, this.api.getTransparencyGridProps({ size: "var(--spacing-mini)" }))
    );
  }
}

export { parse };
