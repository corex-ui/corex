import { connect, machine, type Props, type Api } from "@zag-js/toggle";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component, type SchemaOf } from "../lib/core";

type Schema = SchemaOf<typeof machine>;

export class Toggle extends Component<Props, Api, Schema> {
  initMachine(props: Props): VanillaMachine<Schema> {
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
