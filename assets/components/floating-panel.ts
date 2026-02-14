import { connect, machine, type Props, type Api } from "@zag-js/floating-panel";
import type { ResizeTriggerProps, StageTriggerProps } from "@zag-js/floating-panel";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";

export class FloatingPanel extends Component<Props, Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return connect(this.machine.service, normalizeProps);
  }

  render(): void {
    const triggerEl = this.el.querySelector<HTMLElement>(
      '[data-scope="floating-panel"][data-part="trigger"]'
    );
    if (triggerEl) this.spreadProps(triggerEl, this.api.getTriggerProps());

    const positionerEl = this.el.querySelector<HTMLElement>(
      '[data-scope="floating-panel"][data-part="positioner"]'
    );
    if (positionerEl) this.spreadProps(positionerEl, this.api.getPositionerProps());

    const contentEl = this.el.querySelector<HTMLElement>(
      '[data-scope="floating-panel"][data-part="content"]'
    );
    if (contentEl) this.spreadProps(contentEl, this.api.getContentProps());

    const titleEl = this.el.querySelector<HTMLElement>(
      '[data-scope="floating-panel"][data-part="title"]'
    );
    if (titleEl) this.spreadProps(titleEl, this.api.getTitleProps());

    const headerEl = this.el.querySelector<HTMLElement>(
      '[data-scope="floating-panel"][data-part="header"]'
    );
    if (headerEl) this.spreadProps(headerEl, this.api.getHeaderProps());

    const bodyEl = this.el.querySelector<HTMLElement>(
      '[data-scope="floating-panel"][data-part="body"]'
    );
    if (bodyEl) this.spreadProps(bodyEl, this.api.getBodyProps());

    const dragTriggerEl = this.el.querySelector<HTMLElement>(
      '[data-scope="floating-panel"][data-part="drag-trigger"]'
    );
    if (dragTriggerEl) this.spreadProps(dragTriggerEl, this.api.getDragTriggerProps());

    const resizeAxes = ["s", "w", "e", "n", "sw", "nw", "se", "ne"] as const;
    resizeAxes.forEach((axis) => {
      const resizeEl = this.el.querySelector<HTMLElement>(
        `[data-scope="floating-panel"][data-part="resize-trigger"][data-axis="${axis}"]`
      );
      if (resizeEl)
        this.spreadProps(resizeEl, this.api.getResizeTriggerProps({ axis } as ResizeTriggerProps));
    });

    const closeTriggerEl = this.el.querySelector<HTMLElement>(
      '[data-scope="floating-panel"][data-part="close-trigger"]'
    );
    if (closeTriggerEl) this.spreadProps(closeTriggerEl, this.api.getCloseTriggerProps());

    const controlEl = this.el.querySelector<HTMLElement>(
      '[data-scope="floating-panel"][data-part="control"]'
    );
    if (controlEl) this.spreadProps(controlEl, this.api.getControlProps());

    const stages = ["minimized", "maximized", "default"] as const;
    stages.forEach((stage) => {
      const stageTriggerEl = this.el.querySelector<HTMLElement>(
        `[data-scope="floating-panel"][data-part="stage-trigger"][data-stage="${stage}"]`
      );
      if (stageTriggerEl)
        this.spreadProps(
          stageTriggerEl,
          this.api.getStageTriggerProps({ stage } as StageTriggerProps)
        );
    });
  }
}
