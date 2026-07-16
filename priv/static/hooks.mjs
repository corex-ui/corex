// hooks/lazy-hook.ts
function createLazyHook(importFn, exportName) {
  return {
    async mounted() {
      const el = this.el;
      const state = this;
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
      const state = this;
      if (state._realHook?.updated) {
        state._realHook.updated.call(this);
      } else if (state._mountPromise) {
        state._pendingUpdated = true;
      }
    },
    destroyed() {
      const state = this;
      if (state._realHook?.destroyed) {
        state._realHook.destroyed.call(this);
      } else if (state._mountPromise) {
        state._destroyedBeforeMount = true;
      }
    },
    disconnected() {
      this._realHook?.disconnected?.call(this);
    },
    reconnected() {
      this._realHook?.reconnected?.call(this);
    },
    beforeUpdate() {
      this._realHook?.beforeUpdate?.call(this);
    }
  };
}

// hooks/hooks.ts
function everyEntryIsLazyFactory(named) {
  const values = Object.values(named);
  return values.length > 0 && values.every((v) => typeof v === "function");
}
function hooks(named) {
  const record = named;
  if (everyEntryIsLazyFactory(record)) {
    return Object.fromEntries(
      Object.keys(record).map((name) => [
        name,
        createLazyHook(record[name], name)
      ])
    );
  }
  return named;
}
export {
  hooks
};
//# sourceMappingURL=hooks.mjs.map
