import { connect, machine, type Props, type Api } from "@zag-js/toggle";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component } from "../lib/core";

export class Toggle extends Component<Props, Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  render(): void {
    const rootEl = this.el.querySelector<HTMLElement>('[data-scope="toggle"][data-part="root"]');
    if (!rootEl) return;
    this.spreadProps(rootEl, this.api.getRootProps());

    const indicatorEl = rootEl.querySelector<HTMLElement>(
      ':scope > [data-scope="toggle"][data-part="indicator"]'
    );
    if (indicatorEl) {
      this.spreadProps(indicatorEl, this.api.getIndicatorProps());
    }
  }
}
