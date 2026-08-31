import { connect, machine, type Props, type Api } from "@zag-js/presence";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component, type SchemaOf } from "../lib/core";

type Schema = SchemaOf<typeof machine>;

export class Presence extends Component<Props, Api, Schema> {
  desiredPresent = true;

  initMachine(props: Props): VanillaMachine<Schema> {
    this.desiredPresent = props.present ?? true;
    return new VanillaMachine(machine, { ...props, immediate: true });
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  updateProps(props: Partial<Props>, opts?: { force?: boolean }): boolean {
    if (typeof props.present === "boolean") this.desiredPresent = props.present;
    return super.updateProps(props, opts);
  }

  render(): void {
    const root =
      this.el.querySelector<HTMLElement>('[data-scope="presence"][data-part="root"]') ?? this.el;
    this.api.setNode(root);
    // Keep the node visible while Zag plays the exit animation (`api.present`
    // stays true in `unmountSuspended`). Drive `data-state` from the requested
    // present prop so CSS can start the close animation.
    root.dataset.state = this.desiredPresent ? "open" : "closed";
    root.dataset.present = this.desiredPresent ? "true" : "false";
    root.hidden = !this.api.present;
  }
}
