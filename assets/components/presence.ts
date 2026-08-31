import { connect, machine, type Props, type Api } from "@zag-js/presence";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component, type SchemaOf } from "../lib/core";

type Schema = SchemaOf<typeof machine>;

export class Presence extends Component<Props, Api, Schema> {
  initMachine(props: Props): VanillaMachine<Schema> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  render(): void {
    const root = this.el.querySelector<HTMLElement>('[data-scope="presence"][data-part="root"]') ?? this.el;
    this.api.setNode(root);
    root.hidden = !this.api.present;
    root.dataset.state = this.api.present ? "open" : "closed";
    root.dataset.present = this.api.present ? "true" : "false";
  }
}
