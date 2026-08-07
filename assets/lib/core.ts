import { VanillaMachine, spreadProps, normalizeProps } from "@zag-js/vanilla";
import type { Attrs } from "@zag-js/vanilla";
import type { Machine, MachineSchema, Service } from "@zag-js/core";

/**
 * The state schema behind a Zag machine value, so a component can name its
 * schema as `SchemaOf<typeof machine>` from the import it already has.
 */
export type SchemaOf<M> = M extends Machine<infer Schema> ? Schema : never;

interface ComponentInterface<Api, Schema extends MachineSchema> {
  el: HTMLElement;
  machine: VanillaMachine<Schema>;
  api: Api;

  init(): void;
  destroy(): void;
  render(): void;
}

const HEAVY_PROP_KEYS = new Set(["collection"]);

const objectRefIds = new WeakMap<object, number>();
let nextObjectRefId = 1;

function objectRefId(value: object): string {
  let id = objectRefIds.get(value);
  if (id === undefined) {
    id = nextObjectRefId++;
    objectRefIds.set(value, id);
  }
  return `#${id}`;
}

function isPlainObject(value: object): boolean {
  const proto = Object.getPrototypeOf(value);
  return proto === Object.prototype || proto === null;
}

function stableValueKey(value: unknown): string {
  if (value === null) return "null";
  const type = typeof value;
  if (type === "string") return JSON.stringify(value);
  if (type === "number" || type === "boolean") return String(value);
  if (type === "undefined") return "undefined";
  if (type === "function" || type === "symbol" || type === "bigint") return "";
  if (typeof value !== "object") return String(value);

  if (Array.isArray(value)) {
    let out = "[";
    for (let i = 0; i < value.length; i++) {
      if (i > 0) out += ",";
      out += stableValueKey(value[i]);
    }
    return out + "]";
  }

  if (isPlainObject(value)) {
    try {
      return JSON.stringify(value, (_key, nested) => {
        if (typeof nested === "function") return undefined;
        return nested;
      });
    } catch {
      return objectRefId(value);
    }
  }

  const asString = String(value);
  if (asString !== "[object Object]") {
    return JSON.stringify(asString);
  }
  return objectRefId(value);
}

function stableUpdatePropsKey(props: Record<string, unknown>): string {
  const keys = Object.keys(props).sort();
  let out = "";
  for (const key of keys) {
    if (HEAVY_PROP_KEYS.has(key)) continue;
    const value = props[key];
    if (typeof value === "function") continue;
    out += key;
    out += ":";
    out += stableValueKey(value);
    out += ";";
  }
  return out;
}

export abstract class Component<
  Props extends Partial<Schema["props"]>,
  Api,
  Schema extends MachineSchema = MachineSchema,
> implements ComponentInterface<Api, Schema> {
  el: HTMLElement;
  protected doc: Document;
  machine: VanillaMachine<Schema>;
  api: Api;
  protected unsubscribe: (() => void) | undefined;
  private lastUpdatePropsKey: string | undefined;
  private spreadCleanups = new Map<Element, () => void>();

  constructor(
    el: HTMLElement | null,
    props: Props,
    beforeInitMachine?: (instance: Component<Props, Api, Schema>) => void
  ) {
    if (!el) throw new Error("Root element not found");
    this.el = el;
    this.doc = document;
    beforeInitMachine?.(this);
    this.machine = this.initMachine(props);
    this.api = this.initApi();
  }

  abstract initMachine(props: Props): VanillaMachine<Schema>;
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

  updateProps(props: Partial<Props>, opts?: { force?: boolean }): boolean {
    const key = stableUpdatePropsKey(props as Record<string, unknown>);
    if (!opts?.force && key === this.lastUpdatePropsKey) return false;
    this.lastUpdatePropsKey = key;
    this.machine.updateProps(props);
    return true;
  }

  protected zagConnect<A>(
    connectFn: (service: Service<Schema>, np: typeof normalizeProps) => A
  ): A {
    return connectFn(this.machine.service, normalizeProps);
  }
}
