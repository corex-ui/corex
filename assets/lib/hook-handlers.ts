import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";

export interface HookHandleEventRegistry {
  add: <P = unknown>(eventName: string, fn: (payload: P) => void) => void;
  teardown: () => void;
}

export function createHookHandleEventRegistry(
  hook: Pick<HookInterface<HTMLElement>, "handleEvent" | "removeHandleEvent">
): HookHandleEventRegistry {
  const refs: CallbackRef[] = [];

  return {
    add<P>(eventName: string, fn: (payload: P) => void) {
      refs.push(hook.handleEvent(eventName, fn as (payload: unknown) => void));
    },
    teardown() {
      for (const ref of refs) {
        hook.removeHandleEvent(ref);
      }
      refs.length = 0;
    },
  };
}
