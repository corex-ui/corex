import { connect, machine, type Props, type Api } from "@zag-js/marquee";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component } from "../lib/core";

export class Marquee extends Component<Props, Api> {
  private items: HTMLElement[] | null = null;
  private unsubscribe: (() => void) | undefined;

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  init = (): void => {
    try {
      this.machine.start();
      (this as { api: Api }).api = this.initApi();
      this.render();
      this.unsubscribe = this.machine.subscribe(() => {
        (this as { api: Api }).api = this.initApi();
        this.render();
      });
    } finally {
      this.el.removeAttribute("data-loading");
    }
  };

  destroy = (): void => {
    this.unsubscribe?.();
    this.unsubscribe = undefined;
    this.el.removeAttribute("data-loading");
    this.machine.stop();
  };

  buildDom(): void {
    const templateEl = this.el.querySelector<HTMLTemplateElement>(
      'template[data-part="items-template"]'
    );
    if (templateEl) {
      this.items = Array.from(templateEl.content.children).map(
        (el) => el.cloneNode(true) as HTMLElement
      );
      templateEl.remove();
    }
    if (!this.items) return;

    const existingRoot = this.el.querySelector('[data-scope="marquee"][data-part="root"]');
    if (existingRoot) existingRoot.remove();

    const root = document.createElement("div");
    root.setAttribute("data-scope", "marquee");
    root.setAttribute("data-part", "root");
    root.id = `marquee:${this.el.id}`;
    root.style.cssText =
      "display:flex;flex-direction:row;position:relative;overflow:hidden;width:100%";
    this.el.appendChild(root);

    const edgeStart = document.createElement("div");
    root.appendChild(edgeStart);
    this.spreadProps(edgeStart, this.api.getEdgeProps({ side: "start" }));

    const viewport = document.createElement("div");
    viewport.setAttribute("data-scope", "marquee");
    viewport.setAttribute("data-part", "viewport");
    viewport.id = `marquee:${this.el.id}:viewport`;
    viewport.style.cssText = "display:flex;width:100%";
    root.appendChild(viewport);

    const content = document.createElement("div");
    content.setAttribute("data-scope", "marquee");
    content.setAttribute("data-part", "content");
    content.setAttribute("data-index", "0");
    content.id = `marquee:${this.el.id}:content:0`;
    content.style.cssText = "display:flex;flex-direction:row;flex-shrink:0";
    viewport.appendChild(content);
    this.fillContent(content);

    const edgeEnd = document.createElement("div");
    root.appendChild(edgeEnd);
    this.spreadProps(edgeEnd, this.api.getEdgeProps({ side: "end" }));

    const ssrPreview = this.el.querySelector('[data-part="ssr-preview"]');
    if (ssrPreview) ssrPreview.remove();
  }

  ensureDom(): void {
    if (!this.items) return;
    if (!this.el.querySelector('[data-scope="marquee"][data-part="root"]')) {
      this.buildDom();
    }
    this.render();
  }

  render(): void {
    if (!this.items) return;

    const root = this.el.querySelector<HTMLElement>('[data-scope="marquee"][data-part="root"]');
    if (!root) return;
    this.spreadProps(root, this.api.getRootProps());
    this.applyExplicitDuration(root);

    const edgeStart = root.querySelector<HTMLElement>('[data-part="edge"][data-side="start"]');
    if (edgeStart) this.spreadProps(edgeStart, this.api.getEdgeProps({ side: "start" }));

    const viewport = root.querySelector<HTMLElement>('[data-part="viewport"]');
    if (!viewport) return;
    this.spreadProps(viewport, this.api.getViewportProps());

    const existingContents = Array.from(
      viewport.querySelectorAll<HTMLElement>(':scope > [data-part="content"]')
    );

    while (existingContents.length > this.api.contentCount) {
      const el = existingContents.pop();
      if (el) viewport.removeChild(el);
    }

    Array.from({ length: this.api.contentCount }).forEach((_, i) => {
      let contentEl = existingContents[i];
      if (!contentEl) {
        contentEl = document.createElement("div");
        viewport.appendChild(contentEl);
        this.fillContent(contentEl);
      } else if (contentEl.querySelectorAll('[data-part="item"]').length === 0) {
        this.fillContent(contentEl);
      }
      this.spreadProps(contentEl, this.api.getContentProps({ index: i }));
      contentEl.querySelectorAll<HTMLElement>('[data-part="item"]').forEach((itemEl) => {
        this.spreadProps(itemEl, this.api.getItemProps());
      });
    });

    const edgeEnd = root.querySelector<HTMLElement>('[data-part="edge"][data-side="end"]');
    if (edgeEnd) this.spreadProps(edgeEnd, this.api.getEdgeProps({ side: "end" }));
  }

  private fillContent(contentEl: HTMLElement): void {
    if (!this.items) return;
    this.items.forEach((itemEl) => {
      contentEl.appendChild(itemEl.cloneNode(true) as HTMLElement);
    });
  }

  private applyExplicitDuration(root: HTMLElement): void {
    const explicit = this.el.dataset.duration;
    if (explicit !== undefined && explicit !== "") {
      root.style.setProperty("--marquee-duration", `${explicit}s`);
    }
  }
}
