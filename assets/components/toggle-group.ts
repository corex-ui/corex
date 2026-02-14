import { connect, machine, type Props, type Api } from "@zag-js/toggle-group";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";
import { getString, getBoolean } from "../lib/util";

export class ToggleGroup extends Component<Props, Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return connect(this.machine.service, normalizeProps);
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

    for (let i = 0; i < items.length; i++) {
      const itemEl = items[i];
      const value = getString(itemEl, "value");
      if (!value) continue;

      const disabled = getBoolean(itemEl, "disabled");
      this.spreadProps(itemEl, this.api.getItemProps({ value, disabled }));
    }
  }
}
