import { connect, machine, type Props, type Api } from "@zag-js/splitter";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component, type SchemaOf } from "../lib/core";

type Schema = SchemaOf<typeof machine>;

export class Splitter extends Component<Props, Api, Schema> {
  initMachine(props: Props): VanillaMachine<Schema> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  render(): void {
    const root =
      this.el.querySelector<HTMLElement>('[data-scope="splitter"][data-part="root"]') ?? this.el;
    this.spreadProps(root, this.api.getRootProps());

    this.el.querySelectorAll<HTMLElement>('[data-scope="splitter"][data-part="panel"]').forEach((panel) => {
      const id = panel.dataset.id;
      if (!id) return;
      this.spreadProps(panel, this.api.getPanelProps({ id }));
    });

    this.el
      .querySelectorAll<HTMLElement>('[data-scope="splitter"][data-part="resize-trigger"]')
      .forEach((trigger) => {
        const id = trigger.dataset.id as `${string}:${string}` | undefined;
        if (!id) return;
        this.spreadProps(trigger, this.api.getResizeTriggerProps({ id }));
      });
  }
}
