import { connect, machine, type Props, type Api } from "@zag-js/toggle-group";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component, type SchemaOf } from "../lib/core";
import { getString, getBoolean } from "../lib/util";

type Schema = SchemaOf<typeof machine>;

export class ToggleGroup extends Component<Props, Api, Schema> {
  initMachine(props: Props): VanillaMachine<Schema> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  render(): void {
    const rootEl = this.el.querySelector<HTMLElement>(
      '[data-scope="toggle-group"][data-part="root"]'
    );
    if (!rootEl) return;
    this.spreadProps(rootEl, this.api.getRootProps());

    const items = this.el.querySelectorAll<HTMLElement>(
      '[data-scope="toggle-group"][data-part="item"]'
    );

    for (const itemEl of items) {
      const value = getString(itemEl, "value");
      if (!value) continue;

      const disabled = getBoolean(itemEl, "disabled");
      this.spreadProps(itemEl, this.api.getItemProps({ value, disabled }));
    }
  }
}
