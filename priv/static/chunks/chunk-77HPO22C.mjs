// lib/hook-handlers.ts
function createHookHandleEventRegistry(hook) {
  const refs = [];
  return {
    add(eventName, fn) {
      refs.push(hook.handleEvent(eventName, fn));
    },
    teardown() {
      for (const ref of refs) {
        hook.removeHandleEvent(ref);
      }
      refs.length = 0;
    }
  };
}

// lib/dom-events.ts
function createDomEventRegistry(target) {
  const entries = [];
  return {
    add(eventName, listener) {
      const wrapped = listener;
      target.addEventListener(eventName, wrapped);
      entries.push({ eventName, listener: wrapped });
    },
    teardown() {
      for (const { eventName, listener } of entries) {
        target.removeEventListener(eventName, listener);
      }
      entries.length = 0;
    }
  };
}

export {
  createHookHandleEventRegistry,
  createDomEventRegistry
};
