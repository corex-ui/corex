import { connect, machine, type Props, type Api } from "@zag-js/carousel";
import type { ItemProps, IndicatorProps } from "@zag-js/carousel";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";

export class Carousel extends Component<Props, Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return connect(this.machine.service, normalizeProps);
  }

  render(): void {
    const rootEl =
      this.el.querySelector<HTMLElement>('[data-scope="carousel"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());

    const controlEl = this.el.querySelector<HTMLElement>(
      '[data-scope="carousel"][data-part="control"]'
    );
    if (controlEl) this.spreadProps(controlEl, this.api.getControlProps());

    const itemGroupEl = this.el.querySelector<HTMLElement>(
      '[data-scope="carousel"][data-part="item-group"]'
    );
    if (itemGroupEl) this.spreadProps(itemGroupEl, this.api.getItemGroupProps());

    const slideCount = Number(this.el.dataset.slideCount) || 0;
    for (let i = 0; i < slideCount; i++) {
      const itemEl = this.el.querySelector<HTMLElement>(
        `[data-scope="carousel"][data-part="item"][data-index="${i}"]`
      );
      if (itemEl) this.spreadProps(itemEl, this.api.getItemProps({ index: i } as ItemProps));
    }

    const prevTriggerEl = this.el.querySelector<HTMLElement>(
      '[data-scope="carousel"][data-part="prev-trigger"]'
    );
    if (prevTriggerEl) this.spreadProps(prevTriggerEl, this.api.getPrevTriggerProps());

    const nextTriggerEl = this.el.querySelector<HTMLElement>(
      '[data-scope="carousel"][data-part="next-trigger"]'
    );
    if (nextTriggerEl) this.spreadProps(nextTriggerEl, this.api.getNextTriggerProps());

    const autoplayTriggerEl = this.el.querySelector<HTMLElement>(
      '[data-scope="carousel"][data-part="autoplay-trigger"]'
    );
    if (autoplayTriggerEl) this.spreadProps(autoplayTriggerEl, this.api.getAutoplayTriggerProps());

    const indicatorGroupEl = this.el.querySelector<HTMLElement>(
      '[data-scope="carousel"][data-part="indicator-group"]'
    );
    if (indicatorGroupEl) this.spreadProps(indicatorGroupEl, this.api.getIndicatorGroupProps());

    const indicatorCount = this.api.pageSnapPoints.length;
    for (let i = 0; i < indicatorCount; i++) {
      const indicatorEl = this.el.querySelector<HTMLElement>(
        `[data-scope="carousel"][data-part="indicator"][data-index="${i}"]`
      );
      if (indicatorEl)
        this.spreadProps(indicatorEl, this.api.getIndicatorProps({ index: i } as IndicatorProps));
    }

    const progressTextEl = this.el.querySelector<HTMLElement>(
      '[data-scope="carousel"][data-part="progress-text"]'
    );
    if (progressTextEl) this.spreadProps(progressTextEl, this.api.getProgressTextProps());
  }
}
