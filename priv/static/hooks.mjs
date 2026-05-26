// hooks/lazy-hook.ts
function createLazyHook(importFn, exportName) {
  return {
    async mounted() {
      const el = this.el;
      try {
        const mod = await importFn();
        const real = mod[exportName];
        this._realHook = real;
        if (real?.mounted) {
          await real.mounted.call(this);
        }
      } finally {
        el.removeAttribute("data-loading");
      }
    },
    updated() {
      this._realHook?.updated?.call(this);
    },
    destroyed() {
      this._realHook?.destroyed?.call(this);
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
