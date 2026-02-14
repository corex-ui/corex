import { connect, machine, type Props, type Api } from "@zag-js/avatar";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";

export class Avatar extends Component<Props, Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return connect(this.machine.service, normalizeProps);
  }

  render(): void {
    const rootEl =
      this.el.querySelector<HTMLElement>('[data-scope="avatar"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());

    const imageEl = this.el.querySelector<HTMLElement>('[data-scope="avatar"][data-part="image"]');
    if (imageEl) this.spreadProps(imageEl, this.api.getImageProps());

    const fallbackEl = this.el.querySelector<HTMLElement>(
      '[data-scope="avatar"][data-part="fallback"]'
    );
    if (fallbackEl) this.spreadProps(fallbackEl, this.api.getFallbackProps());
  }
}
