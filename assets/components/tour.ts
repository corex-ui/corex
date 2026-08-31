import { connect, machine, type Props, type Api, type StepDetails } from "@zag-js/tour";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component, type SchemaOf } from "../lib/core";

type Schema = SchemaOf<typeof machine>;

export class Tour extends Component<Props, Api, Schema> {
  initMachine(props: Props): VanillaMachine<Schema> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  render(): void {
    const backdrop = this.el.querySelector<HTMLElement>(
      '[data-scope="tour"][data-part="backdrop"]'
    );
    if (backdrop) this.spreadProps(backdrop, this.api.getBackdropProps());

    const spotlight = this.el.querySelector<HTMLElement>(
      '[data-scope="tour"][data-part="spotlight"]'
    );
    if (spotlight) this.spreadProps(spotlight, this.api.getSpotlightProps());

    const positioner = this.el.querySelector<HTMLElement>(
      '[data-scope="tour"][data-part="positioner"]'
    );
    if (positioner) this.spreadProps(positioner, this.api.getPositionerProps());

    const content = this.el.querySelector<HTMLElement>('[data-scope="tour"][data-part="content"]');
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

    const close = this.el.querySelector<HTMLElement>(
      '[data-scope="tour"][data-part="close-trigger"]'
    );
    if (close) this.spreadProps(close, this.api.getCloseTriggerProps());
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
