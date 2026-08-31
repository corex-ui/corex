import { connect, machine, type Props, type Api, type StepDetails } from "@zag-js/tour";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component, type SchemaOf } from "../lib/core";

type Schema = SchemaOf<typeof machine>;

const TOUR_Z = "2147483000";

function ensureVisualViewport(): void {
  if (typeof window === "undefined" || window.visualViewport) return;
  Object.defineProperty(window, "visualViewport", {
    configurable: true,
    value: {
      width: window.innerWidth,
      height: window.innerHeight,
      offsetLeft: 0,
      offsetTop: 0,
      pageLeft: 0,
      pageTop: 0,
      scale: 1,
      addEventListener() {},
      removeEventListener() {},
    },
  });
}

export class Tour extends Component<Props, Api, Schema> {
  private portalled = new Set<HTMLElement>();

  initMachine(props: Props): VanillaMachine<Schema> {
    ensureVisualViewport();
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  unportal(): void {
    const root =
      this.el.querySelector<HTMLElement>('[data-scope="tour"][data-part="root"]') ?? this.el;
    for (const node of this.portalled) {
      if (node.isConnected) root.appendChild(node);
    }
    this.portalled.clear();
  }

  render(): void {
    this.portalOverlay();
    const backdrop = this.part("backdrop");
    if (backdrop) this.spreadProps(backdrop, this.api.getBackdropProps());

    const spotlight = this.part("spotlight");
    if (spotlight) this.spreadProps(spotlight, this.api.getSpotlightProps());

    const positioner = this.part("positioner");
    if (positioner) this.spreadProps(positioner, this.api.getPositionerProps());

    const content = this.part("content");
    if (content) {
      this.spreadProps(content, this.api.getContentProps());
      const title = content.querySelector<HTMLElement>('[data-scope="tour"][data-part="title"]');
      if (title) {
        this.spreadProps(title, this.api.getTitleProps());
        title.textContent = String(this.api.step?.title ?? "");
      }
      const description = content.querySelector<HTMLElement>(
        '[data-scope="tour"][data-part="description"]'
      );
      if (description) {
        this.spreadProps(description, this.api.getDescriptionProps());
        description.textContent = String(this.api.step?.description ?? "");
      }
      const progressText = content.querySelector<HTMLElement>(
        '[data-scope="tour"][data-part="progress-text"]'
      );
      if (progressText) {
        this.spreadProps(progressText, this.api.getProgressTextProps());
        progressText.textContent = this.api.getProgressText();
      }
      this.renderActions(content, this.api.step);
    }

    const close = this.part("close-trigger");
    if (close) this.spreadProps(close, this.api.getCloseTriggerProps());
  }

  private part(name: string): HTMLElement | null {
    const fromHost = this.el.querySelector<HTMLElement>(
      `[data-scope="tour"][data-part="${name}"]`
    );
    if (fromHost) return fromHost;
    for (const node of this.portalled) {
      if (node.dataset.part === name) return node;
      const nested = node.querySelector<HTMLElement>(`[data-scope="tour"][data-part="${name}"]`);
      if (nested) return nested;
    }
    return null;
  }

  private portalOverlay(): void {
    const parts = ["backdrop", "spotlight", "positioner"] as const;
    for (const part of parts) {
      const node =
        this.el.querySelector<HTMLElement>(`[data-scope="tour"][data-part="${part}"]`) ??
        [...this.portalled].find((el) => el.dataset.part === part);
      if (!node) continue;
      if (node.parentElement !== document.body) {
        document.body.appendChild(node);
        this.portalled.add(node);
      }
      node.style.setProperty("z-index", TOUR_Z);
    }
  }

  private renderActions(content: HTMLElement, step: StepDetails | null): void {
    const host =
      content.querySelector<HTMLElement>('[data-scope="tour"][data-part="actions"]') ??
      (() => {
        const el = document.createElement("div");
        el.dataset.scope = "tour";
        el.dataset.part = "actions";
        content.appendChild(el);
        return el;
      })();
    host.replaceChildren();
    for (const action of step?.actions ?? []) {
      const button = document.createElement("button");
      button.type = "button";
      button.dataset.scope = "tour";
      button.dataset.part = "action-trigger";
      this.spreadProps(button, this.api.getActionTriggerProps({ action }));
      button.textContent = action.label;
      host.appendChild(button);
    }
  }
}
