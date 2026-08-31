import { connect, machine, type Props, type Api } from "@zag-js/toc";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component, type SchemaOf } from "../lib/core";

type Schema = SchemaOf<typeof machine>;

export class Toc extends Component<Props, Api, Schema> {
  initMachine(props: Props): VanillaMachine<Schema> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  render(): void {
    const root =
      this.el.querySelector<HTMLElement>('[data-scope="toc"][data-part="root"]') ?? this.el;
    this.spreadProps(root, this.api.getRootProps());

    const list = this.el.querySelector<HTMLElement>('[data-scope="toc"][data-part="list"]');
    if (list) this.spreadProps(list, this.api.getListProps());

    this.el.querySelectorAll<HTMLElement>('[data-scope="toc"][data-part="item"]').forEach((el) => {
      const value = el.dataset.value;
      const depth = Number(el.dataset.depth ?? "2");
      if (!value) return;
      const item = { value, depth };
      this.spreadProps(el, this.api.getItemProps({ item }));
    });

    this.el.querySelectorAll<HTMLElement>('[data-scope="toc"][data-part="link"]').forEach((link) => {
      const value = link.dataset.value;
      const depth = Number(link.dataset.depth ?? "2");
      if (!value) return;
      this.spreadProps(link, this.api.getLinkProps({ item: { value, depth } }));
    });

    const indicator = this.el.querySelector<HTMLElement>(
      '[data-scope="toc"][data-part="indicator"]'
    );
    if (indicator) this.spreadProps(indicator, this.api.getIndicatorProps());
  }
}
