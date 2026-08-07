import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { snapshotDataset, type DatasetSnapshot } from "./controlled-attr-snapshot";
import { createDomEventRegistry, type DomEventRegistry } from "./dom-events";
import { createHookHandleEventRegistry, type HookHandleEventRegistry } from "./hook-handlers";

export type ZagComponent = {
  init: () => void;
  destroy: () => void;
};

export type ZagLiveHookState = {
  beforeAttrs?: DatasetSnapshot;
};

/**
 * The listener registries a hook wires in `mount`. Both are torn down with the
 * hook, so a handler outlives neither the element nor the LiveView channel.
 */
export type ZagHookRegistries = {
  dom: DomEventRegistry;
  server: HookHandleEventRegistry;
};

type ZagHookContext<TState extends Record<string, unknown>> = HookInterface<HTMLElement> &
  TState &
  ZagLiveHookState;

export type ZagLiveHookConfig<
  TState extends Record<string, unknown>,
  TComponent extends ZagComponent,
> = {
  key: keyof TState & string;
  controlledKeys?: readonly string[];
  /**
   * Builds the component and wires its listeners. Returning `undefined` mounts
   * nothing, for a host that has to wait for markup the server has not sent
   * yet; the update and destroy callbacks are then skipped.
   */
  mount: (
    hook: ZagHookContext<TState>,
    registries: ZagHookRegistries
  ) => TComponent | undefined | void;
  /**
   * Runs once the machine has started, for the setup that has to read a
   * settled `component.api` rather than the pre-start snapshot.
   */
  afterInit?: (hook: ZagHookContext<TState>, component: TComponent) => void;
  beforeUpdate?: (hook: ZagHookContext<TState>) => void;
  update?: (hook: ZagHookContext<TState>, component: TComponent) => void;
  destroy?: (hook: ZagHookContext<TState>, component: TComponent) => void;
  disconnected?: (hook: ZagHookContext<TState>, component: TComponent) => void;
  reconnected?: (hook: ZagHookContext<TState>, component: TComponent) => void;
};

const REGISTRIES = Symbol("corex:zag-hook-registries");

type WithRegistries = { [REGISTRIES]?: ZagHookRegistries };

export function createZagLiveHook<
  TState extends Record<string, unknown>,
  TComponent extends ZagComponent,
>(
  config: ZagLiveHookConfig<TState, TComponent>
): Hook<object & TState & ZagLiveHookState, HTMLElement> {
  type Context = object & ZagHookContext<TState>;

  const componentOf = (hook: Context): TComponent | undefined =>
    (hook as Record<string, unknown>)[config.key] as TComponent | undefined;

  const withComponent = (hook: Context, fn?: (component: TComponent) => void) => {
    const component = componentOf(hook);
    if (component && fn) fn(component);
    return component;
  };

  return {
    mounted(this: Context) {
      const registries: ZagHookRegistries = {
        dom: createDomEventRegistry(this.el),
        server: createHookHandleEventRegistry(this),
      };
      (this as WithRegistries)[REGISTRIES] = registries;

      const component = config.mount(this, registries) || undefined;
      if (!component) return;

      component.init();
      (this as Record<string, unknown>)[config.key] = component;
      config.afterInit?.(this, component);
    },

    beforeUpdate(this: Context) {
      if (config.controlledKeys) {
        this.beforeAttrs = snapshotDataset(this.el, config.controlledKeys);
      }
      config.beforeUpdate?.(this);
    },

    updated(this: Context) {
      const component = componentOf(this);
      if (!component) return;
      try {
        config.update?.(this, component);
      } finally {
        this.beforeAttrs = undefined;
      }
    },

    disconnected(this: Context) {
      withComponent(this, (component) => config.disconnected?.(this, component));
    },

    reconnected(this: Context) {
      withComponent(this, (component) => config.reconnected?.(this, component));
    },

    destroyed(this: Context) {
      const registries = (this as WithRegistries)[REGISTRIES];
      registries?.dom.teardown();
      registries?.server.teardown();
      (this as WithRegistries)[REGISTRIES] = undefined;

      const component = withComponent(this, (component) => config.destroy?.(this, component));
      component?.destroy();
      (this as Record<string, unknown>)[config.key] = undefined;
      this.beforeAttrs = undefined;
    },
  };
}
