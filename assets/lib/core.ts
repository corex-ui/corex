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

function stableUpdatePropsKey(props: Record<string, unknown>): string {
  const keys = Object.keys(props).sort();
  const serializable: Record<string, unknown> = {};
  for (const key of keys) {
    const value = props[key];
    if (typeof value === "function") continue;
    if (value !== null && typeof value === "object") {
      try {
        serializable[key] = JSON.parse(JSON.stringify(value));
      } catch {
        serializable[key] = String(value);
      }
    } else {
      serializable[key] = value;
    }
  }
  return JSON.stringify(serializable);
}

export abstract class Component<Props, Api> implements ComponentInterface<Api> {
  el: HTMLElement;
  protected doc: Document;
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  machine: VanillaMachine<any>;
  api: Api;
  protected unsubscribe: (() => void) | undefined;
  private lastUpdatePropsKey: string | undefined;
  private spreadCleanups = new Map<Element, () => void>();

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
      this.api = this.initApi();
      this.render();
      this.unsubscribe = this.machine.subscribe(() => {
        this.api = this.initApi();
        this.render();
      });
    } finally {
      this.el.removeAttribute("data-loading");
    }
  };

  protected clearSpreadPropsCleanups = () => {
    for (const cleanup of this.spreadCleanups.values()) {
      cleanup();
    }
    this.spreadCleanups.clear();
  };

  destroy = () => {
    this.el.removeAttribute("data-loading");
    this.unsubscribe?.();
    this.unsubscribe = undefined;
    this.clearSpreadPropsCleanups();
    this.machine.stop();
  };

  spreadProps = (el: HTMLElement | Element, props: Attrs) => {
    const cleanup = spreadProps(el, props, this.machine.scope.id);
    this.spreadCleanups.set(el, cleanup);
  };

  updateProps(props: Partial<Props>) {
    const key = stableUpdatePropsKey(props as Record<string, unknown>);
    if (key === this.lastUpdatePropsKey) return;
    this.lastUpdatePropsKey = key;
    this.machine.updateProps(props);
  }

  protected zagConnect<A>(
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    connectFn: (service: any, np: typeof normalizeProps) => A
  ): A {
    return connectFn(this.machine.service, normalizeProps);
  }
}
