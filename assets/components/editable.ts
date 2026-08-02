import { connect, machine, type Props, type Api } from "@zag-js/editable";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component, type SchemaOf } from "../lib/core";
import { syncInputFormAssociation } from "../lib/util";

type Schema = SchemaOf<typeof machine>;

export class Editable extends Component<Props, Api, Schema> {
  initMachine(props: Props): VanillaMachine<Schema> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  render(): void {
    const rootEl =
      this.el.querySelector<HTMLElement>('[data-scope="editable"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());

    const controlEl = this.el.querySelector<HTMLElement>(
      '[data-scope="editable"][data-part="control"]'
    );
    if (controlEl) {
      this.spreadProps(controlEl, this.api.getControlProps());
      // Zag control props omit data-readonly; keep host/SSR signal for ui-readonly.
      if (this.el.hasAttribute("data-readonly")) {
        controlEl.setAttribute("data-readonly", "");
      } else {
        controlEl.removeAttribute("data-readonly");
      }
    }

    const areaEl = this.el.querySelector<HTMLElement>('[data-scope="editable"][data-part="area"]');
    if (areaEl) this.spreadProps(areaEl, this.api.getAreaProps());

    const labelEl = this.el.querySelector<HTMLElement>(
      '[data-scope="editable"][data-part="label"]'
    );
    if (labelEl) this.spreadProps(labelEl, this.api.getLabelProps());

    const formValueEl = this.el.querySelector<HTMLInputElement>(`#${this.el.id}-value`);
    if (formValueEl) {
      formValueEl.value = this.api.value;
      syncInputFormAssociation(formValueEl, this.el);
    }

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
