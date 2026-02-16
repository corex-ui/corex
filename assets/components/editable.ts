import { connect, machine, type Props, type Api } from "@zag-js/editable";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";

const PARTS = [
  "root",
  "area",
  "label",
  "input",
  "preview",
  "edit-trigger",
  "submit-trigger",
  "cancel-trigger",
] as const;

const PART_SELECTOR = '[data-scope="editable"][data-part]';

export class Editable extends Component<Props, Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return connect(this.machine.service, normalizeProps);
  }

  render(): void {
    for (const part of PARTS) {
      const el =
        part === "root"
          ? (this.el.querySelector<HTMLElement>(`${PART_SELECTOR}[data-part="root"]`) ?? this.el)
          : this.el.querySelector<HTMLElement>(`${PART_SELECTOR}[data-part="${part}"]`);
      if (!el) continue;
      const props = this.getPartProps(part);
      if (props) this.spreadProps(el, props);
    }
  }

  private getPartProps(part: (typeof PARTS)[number]): ReturnType<Api["getRootProps"]> | null {
    switch (part) {
      case "root":
        return this.api.getRootProps();
      case "area":
        return this.api.getAreaProps();
      case "label":
        return this.api.getLabelProps();
      case "input":
        return this.api.getInputProps();
      case "preview":
        return this.api.getPreviewProps();
      case "edit-trigger":
        return this.api.getEditTriggerProps();
      case "submit-trigger":
        return this.api.getSubmitTriggerProps();
      case "cancel-trigger":
        return this.api.getCancelTriggerProps();
      default:
        return null;
    }
  }
}
