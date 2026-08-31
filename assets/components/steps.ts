import { connect, machine, type Props, type Api } from "@zag-js/steps";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component, type SchemaOf } from "../lib/core";

type Schema = SchemaOf<typeof machine>;

export class Steps extends Component<Props, Api, Schema> {
  initMachine(props: Props): VanillaMachine<Schema> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  render(): void {
    const root =
      this.el.querySelector<HTMLElement>('[data-scope="steps"][data-part="root"]') ?? this.el;
    this.spreadProps(root, this.api.getRootProps());

    const list = this.el.querySelector<HTMLElement>('[data-scope="steps"][data-part="list"]');
    if (list) {
      this.spreadProps(list, this.api.getListProps());
      // Zag marks the list as a tablist, but items are step wrappers (aria-current)
      // around tab buttons. Drop tablist so axe does not require tab children.
      list.removeAttribute("role");
      list.removeAttribute("aria-owns");
      list.removeAttribute("aria-orientation");
    }

    this.el.querySelectorAll<HTMLElement>('[data-scope="steps"][data-part="item"]').forEach((item) => {
      this.spreadProps(item, this.api.getItemProps({ index: Number(item.dataset.index) }));
    });
    this.el
      .querySelectorAll<HTMLElement>('[data-scope="steps"][data-part="trigger"]')
      .forEach((el) => {
        this.spreadProps(el, this.api.getTriggerProps({ index: Number(el.dataset.index) }));
        el.removeAttribute("role");
        el.removeAttribute("aria-selected");
      });
    this.el
      .querySelectorAll<HTMLElement>('[data-scope="steps"][data-part="indicator"]')
      .forEach((el) => {
        this.spreadProps(el, this.api.getIndicatorProps({ index: Number(el.dataset.index) }));
      });
    this.el
      .querySelectorAll<HTMLElement>('[data-scope="steps"][data-part="separator"]')
      .forEach((el) => {
        this.spreadProps(el, this.api.getSeparatorProps({ index: Number(el.dataset.index) }));
      });
    this.el
      .querySelectorAll<HTMLElement>('[data-scope="steps"][data-part="content"]')
      .forEach((el) => {
        this.spreadProps(el, this.api.getContentProps({ index: Number(el.dataset.index) }));
        el.removeAttribute("role");
      });

    const next = this.el.querySelector<HTMLElement>('[data-scope="steps"][data-part="next-trigger"]');
    if (next) this.spreadProps(next, this.api.getNextTriggerProps());
    const prev = this.el.querySelector<HTMLElement>('[data-scope="steps"][data-part="prev-trigger"]');
    if (prev) this.spreadProps(prev, this.api.getPrevTriggerProps());
  }
}
