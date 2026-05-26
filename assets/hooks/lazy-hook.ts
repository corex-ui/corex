import type { Hook } from "phoenix_live_view";

export type HookModule = Record<string, Hook<object, HTMLElement> | undefined>;

export function createLazyHook(importFn: () => Promise<HookModule>, exportName: string): Hook {
  return {
    async mounted() {
      const el = this.el;

      try {
        const mod = await importFn();
        const real = mod[exportName];
        (this as { _realHook?: Hook<object, HTMLElement> })._realHook = real;

        if (real?.mounted) {
          await real.mounted.call(this);
        }
      } finally {
        el.removeAttribute("data-loading");
      }
    },
    updated() {
      (this as { _realHook?: Hook })._realHook?.updated?.call(this);
    },
    destroyed() {
      (this as { _realHook?: Hook })._realHook?.destroyed?.call(this);
    },
    disconnected() {
      (this as { _realHook?: Hook })._realHook?.disconnected?.call(this);
    },
    reconnected() {
      (this as { _realHook?: Hook })._realHook?.reconnected?.call(this);
    },
    beforeUpdate() {
      (this as { _realHook?: Hook })._realHook?.beforeUpdate?.call(this);
    },
  };
}
