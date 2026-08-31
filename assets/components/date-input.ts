import { connect, machine, type Props, type Api } from "@zag-js/date-input";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component, type SchemaOf } from "../lib/core";

type Schema = SchemaOf<typeof machine>;

export class DateInput extends Component<Props, Api, Schema> {
  initMachine(props: Props): VanillaMachine<Schema> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  render(): void {
    const root =
      this.el.querySelector<HTMLElement>('[data-scope="date-input"][data-part="root"]') ?? this.el;
    this.spreadProps(root, this.api.getRootProps());

    const control = this.el.querySelector<HTMLElement>(
      '[data-scope="date-input"][data-part="control"]'
    );
    if (control) this.spreadProps(control, this.api.getControlProps());

    let group = this.el.querySelector<HTMLElement>(
      '[data-scope="date-input"][data-part="segment-group"]'
    );
    if (!group && control) {
      group = document.createElement("div");
      group.dataset.scope = "date-input";
      group.dataset.part = "segment-group";
      control.prepend(group);
    }
    if (group) {
      this.spreadProps(group, this.api.getSegmentGroupProps());
      const segments = this.api.getSegments();
      const existing = Array.from(
        group.querySelectorAll<HTMLElement>('[data-scope="date-input"][data-part="segment"]')
      );
      segments.forEach((segment, i) => {
        let node = existing[i];
        if (!node) {
          node = document.createElement("span");
          node.dataset.scope = "date-input";
          node.dataset.part = "segment";
          group.appendChild(node);
        }
        node.dataset.type = segment.type;
        node.textContent = segment.text;
        this.spreadProps(node, this.api.getSegmentProps({ segment, index: 0 }));
      });
      existing.slice(segments.length).forEach((node) => node.remove());
    }

    const hidden = this.el.querySelector<HTMLElement>(
      '[data-scope="date-input"][data-part="hidden-input"]'
    );
    if (hidden) this.spreadProps(hidden, this.api.getHiddenInputProps());
  }
}
