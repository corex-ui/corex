import { connect, machine, type Props, type Api } from "@zag-js/rating-group";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component, type SchemaOf } from "../lib/core";

type Schema = SchemaOf<typeof machine>;

export class RatingGroup extends Component<Props, Api, Schema> {
  initMachine(props: Props): VanillaMachine<Schema> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  render(): void {
    const root = this.el.querySelector<HTMLElement>('[data-scope="rating-group"][data-part="root"]') ?? this.el;
    this.spreadProps(root, this.api.getRootProps());
    const control = this.el.querySelector<HTMLElement>('[data-part="control"]');
    if (control) this.spreadProps(control, this.api.getControlProps());
    this.el.querySelectorAll<HTMLElement>('[data-part="item"]').forEach((item) => {
      const index = Number(item.dataset.index);
      this.spreadProps(item, this.api.getItemProps({ index }));
    });
    const hidden = this.el.querySelector<HTMLElement>('[data-part="hidden-input"]');
    if (hidden) this.spreadProps(hidden, this.api.getHiddenInputProps());
  }
}
