import { connect, machine, type Props, type Api } from "@zag-js/navigation-menu";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component, type SchemaOf } from "../lib/core";

type Schema = SchemaOf<typeof machine>;

export class NavigationMenu extends Component<Props, Api, Schema> {
  initMachine(props: Props): VanillaMachine<Schema> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  render(): void {
    const root =
      this.el.querySelector<HTMLElement>('[data-scope="navigation-menu"][data-part="root"]') ??
      this.el;
    this.spreadProps(root, this.api.getRootProps());

    const list = this.el.querySelector<HTMLElement>(
      '[data-scope="navigation-menu"][data-part="list"]'
    );
    if (list) this.spreadProps(list, this.api.getListProps());

    this.el
      .querySelectorAll<HTMLElement>('[data-scope="navigation-menu"][data-part="item"]')
      .forEach((item) => {
        const value = item.dataset.value;
        if (!value) return;
        this.spreadProps(item, this.api.getItemProps({ value }));
      });

    this.el
      .querySelectorAll<HTMLElement>('[data-scope="navigation-menu"][data-part="trigger"]')
      .forEach((trigger) => {
        const value = trigger.dataset.value;
        if (!value) return;
        this.spreadProps(trigger, this.api.getTriggerProps({ value }));
      });

    this.el
      .querySelectorAll<HTMLElement>('[data-scope="navigation-menu"][data-part="link"]')
      .forEach((link) => {
        const value = link.dataset.value;
        if (!value) return;
        this.spreadProps(link, this.api.getLinkProps({ value }));
      });

    this.el
      .querySelectorAll<HTMLElement>('[data-scope="navigation-menu"][data-part="content"]')
      .forEach((content) => {
        const value = content.dataset.value;
        if (!value) return;
        this.spreadProps(content, this.api.getContentProps({ value }));
      });

    const viewport = this.el.querySelector<HTMLElement>(
      '[data-scope="navigation-menu"][data-part="viewport"]'
    );
    if (viewport) this.spreadProps(viewport, this.api.getViewportProps());
  }
}
