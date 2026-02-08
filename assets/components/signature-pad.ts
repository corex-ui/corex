import { connect, machine } from "@zag-js/signature-pad";

import type { Props, Api } from "@zag-js/signature-pad";

import { Component } from "../lib/core";
import { normalizeProps, VanillaMachine } from "@zag-js/vanilla";

export class SignaturePad extends Component<Props, Api> {
  imageURL: string = "";

  initMachine(props: Props): VanillaMachine<any> {
    return new VanillaMachine(machine, props);
  }

  initApi() {
    return connect(this.machine.service, normalizeProps);
  }

  syncPaths = () => {
    const segment = this.el.querySelector<SVGSVGElement>('[data-scope="signature-pad"][data-part="segment"]');
    if (!segment) return;

    const totalPaths = this.api.paths.length + (this.api.currentPath ? 1 : 0);
    
    if (totalPaths === 0) {
      Array.from(segment.querySelectorAll("path")).forEach((path) => segment.removeChild(path));
      this.imageURL = "";
      return;
    }

    const allPathElements = Array.from(
      segment.querySelectorAll<SVGPathElement>('[data-scope="signature-pad"][data-part="path"], [data-scope="signature-pad"][data-part="current-path"]')
    );

    const existingPaths: SVGPathElement[] = [];
    const existingCurrentPath: SVGPathElement[] = [];
    
    allPathElements.forEach((path) => {
      (path.getAttribute("data-part") === "current-path" ? existingCurrentPath : existingPaths).push(path);
    });

    while (existingPaths.length > this.api.paths.length) {
      const path = existingPaths.pop();
      if (path) segment.removeChild(path);
    }

    this.api.paths.forEach((pathData, index) => {
      let pathEl = existingPaths[index];
      if (!pathEl) {
        pathEl = document.createElementNS("http://www.w3.org/2000/svg", "path");
        pathEl.setAttribute("data-scope", "signature-pad");
        pathEl.setAttribute("data-part", "path");
        segment.appendChild(pathEl);
      }
      this.spreadProps(pathEl, this.api.getSegmentPathProps({ path: pathData }));
    });

    if (this.api.currentPath) {
      let currentPathEl = existingCurrentPath[0];
      if (!currentPathEl) {
        currentPathEl = document.createElementNS("http://www.w3.org/2000/svg", "path");
        currentPathEl.setAttribute("data-scope", "signature-pad");
        currentPathEl.setAttribute("data-part", "current-path");
        segment.appendChild(currentPathEl);
      }
      this.spreadProps(currentPathEl, this.api.getSegmentPathProps({ path: this.api.currentPath }));
    } else {
      existingCurrentPath.forEach((path) => segment.removeChild(path));
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
    }

    const hiddenInput = rootEl.querySelector<HTMLInputElement>('[data-scope="signature-pad"][data-part="hidden-input"]');
    if (hiddenInput) {
      this.spreadProps(hiddenInput, this.api.getHiddenInputProps({ value: this.imageURL }));
    }

    this.syncPaths();
  }
}
