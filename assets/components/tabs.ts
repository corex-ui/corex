import { connect, machine, type Props, type Api } from "@zag-js/tabs";
import { VanillaMachine, type Attrs } from "@zag-js/vanilla";
import { Component } from "../lib/core";

export type TabsDomIds = {
  root: string;
  list: string;
  indicator: string;
  content: (value: string) => string;
  trigger: (value: string) => string;
};

export function tabsDomIds(rootId: string): TabsDomIds {
  return {
    root: `tabs-${rootId}-root`,
    list: `tabs-${rootId}-list`,
    indicator: `tabs-${rootId}-indicator`,
    content: (value: string) => `tabs-${rootId}-content-${value}`,
    trigger: (value: string) => `tabs-${rootId}-trigger-${value}`,
  };
}

export class Tabs extends Component<Props, Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    const id = props.id ?? this.el.id;
    return new VanillaMachine(machine, { ...props, id, ids: tabsDomIds(id) });
  }

  updateProps = (attrs: Attrs) => {
    const props = attrs as Props;
    const id = props.id ?? this.el.id;
    this.machine.updateProps({ ...props, id, ids: tabsDomIds(id) });
  };

  initApi(): Api {
    return this.zagConnect(connect);
  }

  render(): void {
    const rootEl = this.el.querySelector<HTMLElement>('[data-scope="tabs"][data-part="root"]');
    if (!rootEl) return;
    this.spreadProps(rootEl, this.api.getRootProps());

    const listEl = rootEl.querySelector<HTMLElement>(
      ':scope > [data-scope="tabs"][data-part="list"]'
    );
    if (!listEl) return;
    this.spreadProps(listEl, this.api.getListProps());

    const triggers = listEl.querySelectorAll<HTMLElement>(
      ':scope > [data-scope="tabs"][data-part="trigger"]'
    );

    triggers.forEach((triggerEl) => {
      const value = triggerEl.dataset.value;
      const disabled = triggerEl.dataset.disabled === "";

      if (!value) return;

      this.spreadProps(triggerEl, this.api.getTriggerProps({ value, disabled }));
    });

    const contents = rootEl.querySelectorAll<HTMLElement>(
      ':scope > [data-scope="tabs"][data-part="content"]'
    );

    contents.forEach((contentEl) => {
      const value = contentEl.dataset.value;

      if (!value) return;

      this.spreadProps(contentEl, this.api.getContentProps({ value }));
    });
  }
}
