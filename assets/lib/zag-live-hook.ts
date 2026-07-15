import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { snapshotDataset, type DatasetSnapshot } from "./controlled-attr-snapshot";

export type ZagComponent = {
  init: () => void;
  destroy: () => void;
};

export type ZagLiveHookState = {
  beforeAttrs?: DatasetSnapshot;
};

export type ZagLiveHookConfig<
  TState extends Record<string, unknown>,
  TComponent extends ZagComponent,
> = {
  key: keyof TState & string;
  controlledKeys?: readonly string[];
  mount: (hook: HookInterface<HTMLElement> & TState & ZagLiveHookState) => TComponent;
  beforeUpdate?: (hook: HookInterface<HTMLElement> & TState & ZagLiveHookState) => void;
  update?: (
    hook: HookInterface<HTMLElement> & TState & ZagLiveHookState,
    component: TComponent
  ) => void;
  destroy?: (
    hook: HookInterface<HTMLElement> & TState & ZagLiveHookState,
    component: TComponent
  ) => void;
};

export function createZagLiveHook<
  TState extends Record<string, unknown>,
  TComponent extends ZagComponent,
>(
  config: ZagLiveHookConfig<TState, TComponent>
): Hook<object & TState & ZagLiveHookState, HTMLElement> {
  return {
    mounted(this: object & HookInterface<HTMLElement> & TState & ZagLiveHookState) {
      const component = config.mount(this);
      component.init();
      (this as Record<string, unknown>)[config.key] = component;
    },

    beforeUpdate(this: object & HookInterface<HTMLElement> & TState & ZagLiveHookState) {
      if (config.controlledKeys) {
        this.beforeAttrs = snapshotDataset(this.el, config.controlledKeys);
      }
      config.beforeUpdate?.(this);
    },

    updated(this: object & HookInterface<HTMLElement> & TState & ZagLiveHookState) {
      const component = (this as Record<string, unknown>)[config.key] as TComponent | undefined;
      if (!component) return;
      try {
        config.update?.(this, component);
      } finally {
        this.beforeAttrs = undefined;
      }
    },

    destroyed(this: object & HookInterface<HTMLElement> & TState & ZagLiveHookState) {
      const component = (this as Record<string, unknown>)[config.key] as TComponent | undefined;
      if (!component) return;
      config.destroy?.(this, component);
      component.destroy();
      (this as Record<string, unknown>)[config.key] = undefined;
      this.beforeAttrs = undefined;
    },
  };
}
