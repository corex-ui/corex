import { connect, machine, type Props, type Api } from "@zag-js/marquee";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component, type SchemaOf } from "../lib/core";

const PHX_ATTR_PREFIX = "phx-";

function sanitizeClone(source: Element): HTMLElement {
  const clone = source.cloneNode(true) as HTMLElement;
  const nodes = [clone, ...Array.from(clone.querySelectorAll("*"))];

  for (const node of nodes) {
    if (!(node instanceof HTMLElement)) continue;

    if (node.hasAttribute("id")) node.removeAttribute("id");
    if (node.hasAttribute("phx-hook")) node.removeAttribute("phx-hook");
    if (node.hasAttribute("name")) node.removeAttribute("name");

    for (const attr of Array.from(node.attributes)) {
      if (attr.name.startsWith(PHX_ATTR_PREFIX)) {
        node.removeAttribute(attr.name);
      }
    }
  }

  return clone;
}

type Schema = SchemaOf<typeof machine>;

export class Marquee extends Component<Props, Api, Schema> {
  private items: HTMLElement[] | null = null;

  initMachine(props: Props): VanillaMachine<Schema> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  buildDom(): void {
    const templateEl = this.el.querySelector<HTMLTemplateElement>(
      'template[data-part="items-template"]'
    );
    if (templateEl) {
      this.items = Array.from(templateEl.content.children).map((el) => sanitizeClone(el));
      templateEl.remove();
    }
    if (!this.items) return;

    const existingRoot = this.el.querySelector('[data-scope="marquee"][data-part="root"]');
    if (existingRoot) existingRoot.remove();

    const root = document.createElement("div");
    root.setAttribute("data-scope", "marquee");
    root.setAttribute("data-part", "root");
    root.id = `marquee:${this.el.id}`;
    this.el.appendChild(root);

    const edgeStart = document.createElement("div");
    root.appendChild(edgeStart);
    this.spreadProps(edgeStart, this.api.getEdgeProps({ side: "start" }));

    const viewport = document.createElement("div");
    viewport.setAttribute("data-scope", "marquee");
    viewport.setAttribute("data-part", "viewport");
    viewport.id = `marquee:${this.el.id}:viewport`;
    root.appendChild(viewport);

    const content = document.createElement("div");
    content.setAttribute("data-scope", "marquee");
    content.setAttribute("data-part", "content");
    content.setAttribute("data-index", "0");
    content.id = `marquee:${this.el.id}:content:0`;
    viewport.appendChild(content);
    this.fillPrimaryContent(content);

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
        if (i === 0) {
          this.fillPrimaryContent(contentEl);
        } else {
          this.fillCloneContent(contentEl);
        }
      } else if (contentEl.querySelectorAll('[data-part="item"]').length === 0) {
        if (i === 0) {
          this.fillPrimaryContent(contentEl);
        } else {
          this.fillCloneContent(contentEl);
        }
      }

      this.spreadProps(contentEl, this.api.getContentProps({ index: i }));
      if (i > 0) {
        contentEl.inert = true;
      } else {
        contentEl.inert = false;
      }

      contentEl.querySelectorAll<HTMLElement>('[data-part="item"]').forEach((itemEl) => {
        this.spreadProps(itemEl, this.api.getItemProps());
      });
    });

    const edgeEnd = root.querySelector<HTMLElement>('[data-part="edge"][data-side="end"]');
    if (edgeEnd) this.spreadProps(edgeEnd, this.api.getEdgeProps({ side: "end" }));
  }

  private fillPrimaryContent(contentEl: HTMLElement): void {
    if (!this.items) return;

    const ssrPreview = this.el.querySelector('[data-part="ssr-preview"]');
    if (ssrPreview) {
      const liveItems = Array.from(
        ssrPreview.querySelectorAll<HTMLElement>(':scope > [data-part="item"]')
      );
      if (liveItems.length > 0) {
        liveItems.forEach((itemEl) => contentEl.appendChild(itemEl));
        return;
      }
    }

    this.fillCloneContent(contentEl);
  }

  private fillCloneContent(contentEl: HTMLElement): void {
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
