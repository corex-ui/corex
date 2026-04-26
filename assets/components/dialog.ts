import { connect, machine, type Props, type Api } from "@zag-js/dialog";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component } from "../lib/core";
import { stripHiddenFromProps } from "../lib/animation";

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
    const open = this.api.open;

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
      } else {
        this.spreadProps(backdropEl, stripHiddenFromProps(rawBackdrop));
        if (open) {
          backdropEl.removeAttribute("hidden");
        } else if (!rootEl.dataset.exitAnim) {
          backdropEl.setAttribute("hidden", "");
        }
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
      } else {
        this.spreadProps(contentEl, stripHiddenFromProps(rawContent));
        if (open) {
          contentEl.removeAttribute("hidden");
        } else if (!rootEl.dataset.exitAnim) {
          contentEl.setAttribute("hidden", "");
        }
      }
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

    if (animation !== "instant") {
      if (rootEl.dataset.animInteractionLocked === "true") {
        if (backdropEl) backdropEl.style.pointerEvents = "auto";
        if (positionerEl) positionerEl.style.pointerEvents = "auto";
        if (contentEl) contentEl.style.pointerEvents = "none";
      } else {
        if (contentEl) contentEl.style.removeProperty("pointer-events");

        if (open) {
          if (backdropEl) backdropEl.style.pointerEvents = "auto";
          if (positionerEl) positionerEl.style.pointerEvents = "auto";
        } else if (animation === "js") {
          const pe: "auto" | "none" = rootEl.dataset.exitAnim === "running" ? "auto" : "none";
          if (backdropEl) backdropEl.style.pointerEvents = pe;
          if (positionerEl) positionerEl.style.pointerEvents = pe;
        } else if (animation === "custom") {
          if (backdropEl) backdropEl.style.pointerEvents = "none";
          if (positionerEl) positionerEl.style.pointerEvents = "none";
        } else {
          if (backdropEl) backdropEl.style.pointerEvents = "none";
          if (positionerEl) positionerEl.style.pointerEvents = "none";
        }
      }
    }
  }
}
