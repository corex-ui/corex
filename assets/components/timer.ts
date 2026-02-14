import { connect, machine, type Props, type Api } from "@zag-js/timer";
import type { ItemProps, ActionTriggerProps } from "@zag-js/timer";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";

export class Timer extends Component<Props, Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return connect(this.machine.service, normalizeProps);
  }

  render(): void {
    const rootEl =
      this.el.querySelector<HTMLElement>('[data-scope="timer"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());

    const areaEl = this.el.querySelector<HTMLElement>('[data-scope="timer"][data-part="area"]');
    if (areaEl) this.spreadProps(areaEl, this.api.getAreaProps());

    const controlEl = this.el.querySelector<HTMLElement>(
      '[data-scope="timer"][data-part="control"]'
    );
    if (controlEl) this.spreadProps(controlEl, this.api.getControlProps());

    const timeParts = ["days", "hours", "minutes", "seconds", "milliseconds"] as const;
    timeParts.forEach((type) => {
      const itemEl = this.el.querySelector<HTMLElement>(
        `[data-scope="timer"][data-part="item"][data-type="${type}"]`
      );
      if (itemEl) this.spreadProps(itemEl, this.api.getItemProps({ type } as ItemProps));
      const valueEl = this.el.querySelector<HTMLElement>(
        `[data-scope="timer"][data-part="item-value"][data-type="${type}"]`
      );
      if (valueEl) this.spreadProps(valueEl, this.api.getItemValueProps({ type } as ItemProps));
      const labelEl = this.el.querySelector<HTMLElement>(
        `[data-scope="timer"][data-part="item-label"][data-type="${type}"]`
      );
      if (labelEl) this.spreadProps(labelEl, this.api.getItemLabelProps({ type } as ItemProps));
    });

    const separatorEl = this.el.querySelector<HTMLElement>(
      '[data-scope="timer"][data-part="separator"]'
    );
    if (separatorEl) this.spreadProps(separatorEl, this.api.getSeparatorProps());

    const actions = ["start", "pause", "resume", "reset", "restart"] as const;
    actions.forEach((action) => {
      const triggerEl = this.el.querySelector<HTMLElement>(
        `[data-scope="timer"][data-part="action-trigger"][data-action="${action}"]`
      );
      if (triggerEl)
        this.spreadProps(
          triggerEl,
          this.api.getActionTriggerProps({ action } as ActionTriggerProps)
        );
    });
  }
}
