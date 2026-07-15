import { VanillaMachine, spreadProps, normalizeProps } from "@zag-js/vanilla";
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
  private unsubscribe: (() => void) | undefined;

  constructor(
    el: HTMLElement | null,
    props: Props,
    beforeInitMachine?: (instance: Component<Props, Api>) => void
  ) {
    if (!el) throw new Error("Root element not found");
    this.el = el;
    this.doc = document;
    beforeInitMachine?.(this);
    this.machine = this.initMachine(props);
    this.api = this.initApi();
  }

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  abstract initMachine(props: Props): VanillaMachine<any>;
  abstract initApi(): Api;
  abstract render(): void;

  init = () => {
    try {
      this.machine.start();
      this.render();
      this.unsubscribe = this.machine.subscribe(() => {
        this.api = this.initApi();
        this.render();
      });
    } finally {
      this.el.removeAttribute("data-loading");
    }
  };

  destroy = () => {
    this.el.removeAttribute("data-loading");
    this.unsubscribe?.();
    this.unsubscribe = undefined;
    this.machine.stop();
  };

  spreadProps = (el: HTMLElement | Element, props: Attrs) => {
    spreadProps(el, props, this.machine.scope.id);
  };

  updateProps(props: Attrs) {
    this.machine.updateProps(props);
  }

  protected zagConnect<A>(
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    connectFn: (service: any, np: typeof normalizeProps) => A
  ): A {
    return connectFn(this.machine.service, normalizeProps);
  }
}
