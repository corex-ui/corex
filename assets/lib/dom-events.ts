type DomEventTarget = {
  addEventListener: (name: string, listener: EventListener) => void;
  removeEventListener: (name: string, listener: EventListener) => void;
};

export interface DomEventRegistry {
  add: <E extends Event = Event>(eventName: string, listener: (event: E) => void) => void;
  teardown: () => void;
}

interface RegistryEntry {
  eventName: string;
  listener: EventListener;
}

export function createDomEventRegistry(target: DomEventTarget): DomEventRegistry {
  const entries: RegistryEntry[] = [];

  return {
    add<E extends Event = Event>(eventName: string, listener: (event: E) => void) {
      const wrapped = listener as EventListener;
      target.addEventListener(eventName, wrapped);
      entries.push({ eventName, listener: wrapped });
    },
    teardown() {
      for (const { eventName, listener } of entries) {
        target.removeEventListener(eventName, listener);
      }
      entries.length = 0;
    },
  };
}
