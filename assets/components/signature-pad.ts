import { connect, machine } from "@zag-js/signature-pad";

import type { Props, Api } from "@zag-js/signature-pad";

import { Component } from "../lib/core";
import { normalizeProps, VanillaMachine } from "@zag-js/vanilla";

export class SignaturePad extends Component<Props, Api> {
  imageURL: string = "";
  paths: any[] = [];
  name?: string;

  initMachine(props: Props): VanillaMachine<any> {
    this.name = (props as any).name;
    return new VanillaMachine(machine, props);
  }

  setName(name: string) {
    this.name = name;
  }

  setPaths(paths: any[]) {
    this.paths = paths;
  }

  initApi() {
    return connect(this.machine.service, normalizeProps);
  }

  syncPaths = () => {
    const segment = this.el.querySelector<SVGSVGElement>('[data-scope="signature-pad"][data-part="segment"]');
    if (!segment) return;

    const totalPaths = this.api.paths.length + (this.api.currentPath ? 1 : 0);

    if (totalPaths === 0) {
      segment.innerHTML = "";
      this.imageURL = "";
      this.paths = [];
      const hiddenInput = this.el.querySelector<HTMLInputElement>('[data-scope="signature-pad"][data-part="hidden-input"]');
      if (hiddenInput) hiddenInput.value = "";
      return;
    }

    segment.innerHTML = "";

    this.api.paths.forEach((pathData) => {
      const pathEl = document.createElementNS("http://www.w3.org/2000/svg", "path");
      pathEl.setAttribute("data-scope", "signature-pad");
      pathEl.setAttribute("data-part", "path");
      this.spreadProps(pathEl, this.api.getSegmentPathProps({ path: pathData }));
      segment.appendChild(pathEl);
    });

    if (this.api.currentPath) {
      const currentPathEl = document.createElementNS("http://www.w3.org/2000/svg", "path");
      currentPathEl.setAttribute("data-scope", "signature-pad");
      currentPathEl.setAttribute("data-part", "current-path");
      this.spreadProps(currentPathEl, this.api.getSegmentPathProps({ path: this.api.currentPath }));
      segment.appendChild(currentPathEl);
    }
  };

  render() {
    const rootEl = this.el.querySelector<HTMLElement>('[data-scope="signature-pad"][data-part="root"]');
    if (!rootEl) return;
    this.spreadProps(rootEl, this.api.getRootProps());

    const label = rootEl.querySelector<HTMLElement>('[data-scope="signature-pad"][data-part="label"]');
    if (label) this.spreadProps(label, this.api.getLabelProps());

    const control = rootEl.querySelector<HTMLElement>('[data-scope="signature-pad"][data-part="control"]');
    if (control) this.spreadProps(control, this.api.getControlProps());

    const segment = rootEl.querySelector<SVGSVGElement>('[data-scope="signature-pad"][data-part="segment"]');
    if (segment) this.spreadProps(segment, this.api.getSegmentProps());

    const guide = rootEl.querySelector<SVGRectElement | HTMLElement>('[data-scope="signature-pad"][data-part="guide"]');
    if (guide) this.spreadProps(guide, this.api.getGuideProps());

    const clearBtn = rootEl.querySelector<HTMLElement>('[data-scope="signature-pad"][data-part="clear-trigger"]');
    if (clearBtn) {
      this.spreadProps(clearBtn, this.api.getClearTriggerProps());
      const hasPaths = this.api.paths.length > 0 || !!this.api.currentPath;
      clearBtn.hidden = !hasPaths;
    }

    const hiddenInput = rootEl.querySelector<HTMLInputElement>('[data-scope="signature-pad"][data-part="hidden-input"]');
    if (hiddenInput) {
      const pathsForValue = this.paths.length > 0 ? this.paths : this.api.paths;
      if (this.paths.length === 0 && this.api.paths.length > 0) {
        this.paths = [...this.api.paths];
      }
      const pathsValue = pathsForValue.length > 0 ? JSON.stringify(pathsForValue) : "";
      this.spreadProps(hiddenInput, this.api.getHiddenInputProps({ value: pathsValue }));
      if (this.name) {
        hiddenInput.name = this.name;
      }
      hiddenInput.value = pathsValue;
    }

    this.syncPaths();
  }
}
