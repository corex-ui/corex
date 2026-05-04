import { connect, machine, type Props, type Api } from "@zag-js/dialog";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component } from "../lib/core";
import { stripHiddenFromProps } from "../lib/animation";
import { getString } from "../lib/util";

export function dialogInitialAriaLabel(rootEl: HTMLElement): string | undefined {
  const titleEl = rootEl.querySelector<HTMLElement>('[data-scope="dialog"][data-part="title"]');
  if (titleEl?.textContent?.trim()) return undefined;
  const fromDataset = getString(rootEl, "dialogDefaultLabel")?.trim();
  if (fromDataset) return fromDataset;
  return "Dialog";
}

function syncDialogContentAriaRefs(rootEl: HTMLElement, contentEl: HTMLElement): void {
  const descriptionEl = rootEl.querySelector<HTMLElement>(
    '[data-scope="dialog"][data-part="description"]'
  );
  if (!descriptionEl?.textContent?.trim()) {
    contentEl.removeAttribute("aria-describedby");
  }
}

export class Dialog extends Component<Props, Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  render(): void {
    const rootEl = this.el;
    const animation = rootEl.dataset.animation ?? "instant";

    const triggerEl = rootEl.querySelector<HTMLElement>(
      '[data-scope="dialog"][data-part="trigger"]'
    );
    if (triggerEl) this.spreadProps(triggerEl, this.api.getTriggerProps());

    const backdropEl = rootEl.querySelector<HTMLElement>(
      '[data-scope="dialog"][data-part="backdrop"]'
    );
    if (backdropEl) {
      const rawBackdrop = this.api.getBackdropProps() as Record<string, unknown>;
      if (animation === "instant") {
        this.spreadProps(backdropEl, rawBackdrop);
      } else if (animation === "js" || animation === "custom") {
        this.spreadProps(backdropEl, stripHiddenFromProps(rawBackdrop));
        backdropEl.removeAttribute("hidden");
      }
    }

    const positionerEl = rootEl.querySelector<HTMLElement>(
      '[data-scope="dialog"][data-part="positioner"]'
    );
    if (positionerEl) this.spreadProps(positionerEl, this.api.getPositionerProps());

    const contentEl = rootEl.querySelector<HTMLElement>(
      '[data-scope="dialog"][data-part="content"]'
    );
    if (contentEl) {
      const rawContent = this.api.getContentProps() as Record<string, unknown>;
      if (animation === "instant") {
        this.spreadProps(contentEl, rawContent);
      } else if (animation === "js" || animation === "custom") {
        this.spreadProps(contentEl, stripHiddenFromProps(rawContent));
        contentEl.removeAttribute("hidden");
        if (!this.api.open) {
          contentEl.style.removeProperty("pointer-events");
        }
      }
      syncDialogContentAriaRefs(rootEl, contentEl);
    }

    const titleEl = rootEl.querySelector<HTMLElement>('[data-scope="dialog"][data-part="title"]');
    if (titleEl) this.spreadProps(titleEl, this.api.getTitleProps());

    const descriptionEl = rootEl.querySelector<HTMLElement>(
      '[data-scope="dialog"][data-part="description"]'
    );
    if (descriptionEl) this.spreadProps(descriptionEl, this.api.getDescriptionProps());

    const closeTriggerEl = rootEl.querySelector<HTMLElement>(
      '[data-scope="dialog"][data-part="close-trigger"]'
    );
    if (closeTriggerEl) this.spreadProps(closeTriggerEl, this.api.getCloseTriggerProps());
  }
}
