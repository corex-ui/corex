import { connect, machine, type Props, type Api } from "@zag-js/marquee";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";

export class Marquee extends Component<Props, Api> {
  initMachine(props: Props): VanillaMachine<unknown> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return connect(this.machine.service, normalizeProps);
  }

  render(): void {
    const rootEl =
      this.el.querySelector<HTMLElement>('[data-scope="marquee"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());

    const edgeStart = this.el.querySelector<HTMLElement>(
      '[data-scope="marquee"][data-part="edge"][data-side="start"]'
    );
    if (edgeStart) this.spreadProps(edgeStart, this.api.getEdgeProps({ side: "start" }));

    const viewport = this.el.querySelector<HTMLElement>(
      '[data-scope="marquee"][data-part="viewport"]'
    );
    if (viewport) this.spreadProps(viewport, this.api.getViewportProps());

    const contentEls = this.el.querySelectorAll<HTMLElement>(
      '[data-scope="marquee"][data-part="content"]'
    );
    contentEls.forEach((contentEl, i) => {
      this.spreadProps(contentEl, this.api.getContentProps({ index: i }));
      const itemEls = contentEl.querySelectorAll<HTMLElement>(
        '[data-scope="marquee"][data-part="item"]'
      );
      itemEls.forEach((itemEl) => {
        this.spreadProps(itemEl, this.api.getItemProps());
      });
    });

    const edgeEnd = this.el.querySelector<HTMLElement>(
      '[data-scope="marquee"][data-part="edge"][data-side="end"]'
    );
    if (edgeEnd) this.spreadProps(edgeEnd, this.api.getEdgeProps({ side: "end" }));
  }
}
