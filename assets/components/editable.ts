import { connect, machine, type Props, type Api } from "@zag-js/editable";
import { VanillaMachine, normalizeProps } from "@zag-js/vanilla";
import { Component } from "../lib/core";

export class Editable extends Component<Props, Api> {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props: Props): VanillaMachine<any> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return connect(this.machine.service, normalizeProps);
  }

  render(): void {
    const rootEl =
      this.el.querySelector<HTMLElement>('[data-scope="editable"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());

    const areaEl = this.el.querySelector<HTMLElement>('[data-scope="editable"][data-part="area"]');
    if (areaEl) this.spreadProps(areaEl, this.api.getAreaProps());

    const labelEl = this.el.querySelector<HTMLElement>(
      '[data-scope="editable"][data-part="label"]'
    );
    if (labelEl) this.spreadProps(labelEl, this.api.getLabelProps());

    const inputEl = this.el.querySelector<HTMLElement>(
      '[data-scope="editable"][data-part="input"]'
    );
    if (inputEl) this.spreadProps(inputEl, this.api.getInputProps());

    const previewEl = this.el.querySelector<HTMLElement>(
      '[data-scope="editable"][data-part="preview"]'
    );
    if (previewEl) this.spreadProps(previewEl, this.api.getPreviewProps());

    const editTriggerEl = this.el.querySelector<HTMLElement>(
      '[data-scope="editable"][data-part="edit-trigger"]'
    );
    if (editTriggerEl) this.spreadProps(editTriggerEl, this.api.getEditTriggerProps());

    const controlEl = this.el.querySelector<HTMLElement>(
      '[data-scope="editable"][data-part="control"]'
    );
    if (controlEl) this.spreadProps(controlEl, this.api.getControlProps());

    const submitTriggerEl = this.el.querySelector<HTMLElement>(
      '[data-scope="editable"][data-part="submit-trigger"]'
    );
    if (submitTriggerEl) this.spreadProps(submitTriggerEl, this.api.getSubmitTriggerProps());

    const cancelTriggerEl = this.el.querySelector<HTMLElement>(
      '[data-scope="editable"][data-part="cancel-trigger"]'
    );
    if (cancelTriggerEl) this.spreadProps(cancelTriggerEl, this.api.getCancelTriggerProps());
  }
}
