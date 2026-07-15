import type { Hook } from "phoenix_live_view";

export type HookModule = Record<string, Hook<object, HTMLElement> | undefined>;

type LazyHookState = {
  _realHook?: Hook<object, HTMLElement>;
  _pendingUpdated?: boolean;
  _destroyedBeforeMount?: boolean;
  _mountPromise?: Promise<void>;
};

export function createLazyHook(importFn: () => Promise<HookModule>, exportName: string): Hook {
  return {
    async mounted() {
      const el = this.el;
      const state = this as LazyHookState;

      const run = async () => {
        try {
          const mod = await importFn();
          const real = mod[exportName];
          if (!real) {
            console.error(`Lazy hook: export "${exportName}" not found`);
            el.setAttribute("data-error", "");
            return;
          }

          state._realHook = real;

          if (state._destroyedBeforeMount) {
            real.destroyed?.call(this);
            return;
          }

          if (real.mounted) {
            await real.mounted.call(this);
          }

          if (state._destroyedBeforeMount) {
            real.destroyed?.call(this);
            return;
          }

          if (state._pendingUpdated) {
            state._pendingUpdated = false;
            real.updated?.call(this);
          }
        } catch (error) {
          console.error(`Lazy hook: failed to load "${exportName}"`, error);
          el.setAttribute("data-error", "");
        } finally {
          el.removeAttribute("data-loading");
        }
      };

      state._mountPromise = run();
      await state._mountPromise;
    },
    updated() {
      const state = this as LazyHookState;
      if (state._realHook?.updated) {
        state._realHook.updated.call(this);
      } else if (state._mountPromise) {
        state._pendingUpdated = true;
      }
    },
    destroyed() {
      const state = this as LazyHookState;
      if (state._realHook?.destroyed) {
        state._realHook.destroyed.call(this);
      } else if (state._mountPromise) {
        state._destroyedBeforeMount = true;
      }
    },
    disconnected() {
      (this as LazyHookState)._realHook?.disconnected?.call(this);
    },
    reconnected() {
      (this as LazyHookState)._realHook?.reconnected?.call(this);
    },
    beforeUpdate() {
      (this as LazyHookState)._realHook?.beforeUpdate?.call(this);
    },
  };
}
