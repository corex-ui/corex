import { VanillaMachine, spreadProps } from "@zag-js/vanilla";
import type { Attrs } from "@zag-js/vanilla";

interface ComponentInterface<Api> {
  el: HTMLElement;
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  machine: VanillaMachine<any>;
  api: Api;

  init(): void;
  destroy(): void;
  render(): void;
}

export abstract class Component<Props, Api> implements ComponentInterface<Api> {
  el: HTMLElement;
  protected doc: Document;
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  machine: VanillaMachine<any>;
  api: Api;

  constructor(el: HTMLElement | null, props: Props) {
    if (!el) throw new Error("Root element not found");
    this.el = el;
    this.doc = document;
    this.machine = this.initMachine(props);
    this.api = this.initApi();
  }

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  abstract initMachine(props: Props): VanillaMachine<any>;
  abstract initApi(): Api;
  abstract render(): void;

  init = () => {
    this.render();
    this.machine.subscribe(() => {
      this.api = this.initApi();
      this.render();
    });
    this.machine.start();
  };

  destroy = () => {
    this.machine.stop();
  };

  spreadProps = (el: HTMLElement | Element, props: Attrs) => {
    spreadProps(el, props, this.machine.scope.id);
  };

  updateProps = (props: Attrs) => {
    this.machine.updateProps(props);
  };
}
