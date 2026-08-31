import { connect, machine, type Props, type Api } from "@zag-js/qr-code";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component, type SchemaOf } from "../lib/core";

type Schema = SchemaOf<typeof machine>;

export class QrCode extends Component<Props, Api, Schema> {
  initMachine(props: Props): VanillaMachine<Schema> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  render(): void {
    const root = this.el.querySelector<HTMLElement>('[data-scope="qr-code"][data-part="root"]') ?? this.el;
    this.spreadProps(root, this.api.getRootProps());
    const frame = this.el.querySelector<HTMLElement>('[data-part="frame"]');
    if (frame) this.spreadProps(frame, this.api.getFrameProps());
    const pattern = this.el.querySelector<HTMLElement>('[data-part="pattern"]');
    if (pattern) this.spreadProps(pattern, this.api.getPatternProps());
    const overlay = this.el.querySelector<HTMLElement>('[data-part="overlay"]');
    if (overlay) this.spreadProps(overlay, this.api.getOverlayProps());
  }
}
