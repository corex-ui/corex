import * as toggleGroup from "@zag-js/toggle-group";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";
import { getString, getBoolean } from "../lib/util";

export class ToggleGroup extends Component<toggleGroup.Props, toggleGroup.Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: toggleGroup.Props): VanillaMachine<any> {
    return new VanillaMachine(toggleGroup.machine, props);
  }

  initApi(): toggleGroup.Api {
    return toggleGroup.connect(this.machine.service, normalizeProps);
  }

  render(): void {
    const rootEl = this.el.querySelector<HTMLElement>('[data-part="root"]') || this.el;
    this.spreadProps(rootEl, this.api.getRootProps());

    const items = this.el.querySelectorAll<HTMLElement>('[data-part="item"]');

    for (let i = 0; i < items.length; i++) {
      const itemEl = items[i];
      const value = getString(itemEl, "value");
      if (!value) continue;

      const disabled = getBoolean(itemEl, "disabled");
      this.spreadProps(itemEl, this.api.getItemProps({ value, disabled }));

    }
  }
}
