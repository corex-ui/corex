import { connect, machine, type Props, type Api } from "@zag-js/scroll-area";
import type { PropTypes } from "@zag-js/types";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component, type SchemaOf } from "../lib/core";

type Schema = SchemaOf<typeof machine>;

export class ScrollArea extends Component<Props, Api<PropTypes>, Schema> {
  initMachine(props: Props): VanillaMachine<Schema> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api<PropTypes> {
    return this.zagConnect(connect);
  }

  render(): void {
    const root =
      this.el.querySelector<HTMLElement>('[data-scope="scroll-area"][data-part="root"]') ?? this.el;
    this.spreadProps(root, this.api.getRootProps());

    const viewport = this.el.querySelector<HTMLElement>(
      '[data-scope="scroll-area"][data-part="viewport"]'
    );
    if (viewport) this.spreadProps(viewport, this.api.getViewportProps());

    const content = this.el.querySelector<HTMLElement>(
      '[data-scope="scroll-area"][data-part="content"]'
    );
    if (content) this.spreadProps(content, this.api.getContentProps());

    this.el
      .querySelectorAll<HTMLElement>('[data-scope="scroll-area"][data-part="scrollbar"]')
      .forEach((scrollbar) => {
        const orientation =
          (scrollbar.dataset.orientation as "vertical" | "horizontal" | undefined) ?? "vertical";
        this.spreadProps(scrollbar, this.api.getScrollbarProps({ orientation }));
      });

    this.el
      .querySelectorAll<HTMLElement>('[data-scope="scroll-area"][data-part="thumb"]')
      .forEach((thumb) => {
        const orientation =
          (thumb.dataset.orientation as "vertical" | "horizontal" | undefined) ?? "vertical";
        this.spreadProps(thumb, this.api.getThumbProps({ orientation }));
      });

    const corner = this.el.querySelector<HTMLElement>(
      '[data-scope="scroll-area"][data-part="corner"]'
    );
    if (corner) this.spreadProps(corner, this.api.getCornerProps());
  }
}
