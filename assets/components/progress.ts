import { connect, machine, type Props, type Api } from "@zag-js/progress";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component, type SchemaOf } from "../lib/core";

type Schema = SchemaOf<typeof machine>;

export class Progress extends Component<Props, Api, Schema> {
  initMachine(props: Props): VanillaMachine<Schema> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  render(): void {
    const root =
      this.el.querySelector<HTMLElement>('[data-scope="progress"][data-part="root"]') ?? this.el;
    this.spreadProps(root, this.api.getRootProps());

    const track = this.el.querySelector<HTMLElement>('[data-scope="progress"][data-part="track"]');
    if (track) this.spreadProps(track, this.api.getTrackProps());

    const range = this.el.querySelector<HTMLElement>('[data-scope="progress"][data-part="range"]');
    if (range) this.spreadProps(range, this.api.getRangeProps());

    const circle = this.el.querySelector<SVGElement>('[data-scope="progress"][data-part="circle"]');
    if (circle) this.spreadProps(circle, this.api.getCircleProps());

    const circleTrack = this.el.querySelector<SVGElement>(
      '[data-scope="progress"][data-part="circle-track"]'
    );
    if (circleTrack) this.spreadProps(circleTrack, this.api.getCircleTrackProps());

    const circleRange = this.el.querySelector<SVGElement>(
      '[data-scope="progress"][data-part="circle-range"]'
    );
    if (circleRange) this.spreadProps(circleRange, this.api.getCircleRangeProps());

    const valueText = this.el.querySelector<HTMLElement>(
      '[data-scope="progress"][data-part="value-text"]'
    );
    if (valueText) {
      this.spreadProps(valueText, this.api.getValueTextProps());
      valueText.textContent = this.api.valueAsString;
    }
  }
}
