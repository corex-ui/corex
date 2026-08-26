import { expect, vi } from "vitest";
import type { CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { mockLiveSocket } from "./mock-live-socket";

export function mockHookJs() {
  return {
    exec: vi.fn(),
    show: vi.fn(),
    hide: vi.fn(),
    toggle: vi.fn(),
    addClass: vi.fn(),
    removeClass: vi.fn(),
    toggleClass: vi.fn(),
    transition: vi.fn(),
    setAttribute: vi.fn(),
    removeAttribute: vi.fn(),
    toggleAttribute: vi.fn(),
    push: vi.fn(),
    navigate: vi.fn(),
    patch: vi.fn(),
    ignoreAttributes: vi.fn(),
  };
}

export type MockHookJs = ReturnType<typeof mockHookJs>;

type BaseHookContext<E extends HTMLElement> = {
  el: E;
  pushEvent: ReturnType<typeof vi.fn>;
  js: () => MockHookJs;
  liveSocket: ReturnType<typeof mockLiveSocket>["ctx"]["liveSocket"];
  handleEvent: ReturnType<
    typeof vi.fn<(event: string, callback: (payload: unknown) => void) => CallbackRef>
  >;
  removeHandleEvent: ReturnType<typeof vi.fn>;
};

type MockHookContextOptions<Extra extends Record<string, unknown>> = {
  connected?: boolean;
  overrides?: Extra;
};

export function mockHookContext<
  E extends HTMLElement,
  Extra extends Record<string, unknown> = Record<string, never>,
>(el: E, opts: MockHookContextOptions<Extra> = {}) {
  const connected = opts.connected ?? false;
  const { ctx, patch, navigate } = mockLiveSocket(connected);
  const jsCommands = mockHookJs();
  jsCommands.patch = patch;
  jsCommands.navigate = navigate;

  const base: BaseHookContext<E> = {
    el,
    pushEvent: vi.fn(),
    js: () => jsCommands,
    liveSocket: ctx.liveSocket,
    handleEvent: vi.fn(
      (event: string, callback: (payload: unknown) => void): CallbackRef => ({
        event,
        callback,
      })
    ),
    removeHandleEvent: vi.fn(),
  };

  const hook = { ...base, ...opts.overrides } as BaseHookContext<E> & Extra;

  return { hook, patch, navigate, jsCommands, liveSocket: ctx.liveSocket };
}

type HookLifecycle = "mounted" | "destroyed" | "updated" | "beforeUpdate";
type HookLifecycleMethods = {
  mounted?: (this: never) => void;
  destroyed?: (this: never) => void;
  updated?: (this: never) => void;
  beforeUpdate?: (this: never, toEl: HTMLElement) => void;
};

export function callHookLifecycle(
  hookModule: HookLifecycleMethods,
  hook: object,
  lifecycle: HookLifecycle,
  ...args: unknown[]
): void {
  const fn = hookModule[lifecycle] as ((this: object, ...args: unknown[]) => void) | undefined;
  expect(fn).toBeDefined();
  if (lifecycle === "beforeUpdate" && args.length === 0) {
    const el = (hook as { el?: HTMLElement }).el ?? document.createElement("div");
    fn!.call(hook, el);
    return;
  }
  fn!.call(hook, ...args);
}

export function callHookMounted(hookModule: HookLifecycleMethods, hook: object): void {
  callHookLifecycle(hookModule, hook, "mounted");
}

export function callHookDestroyed(hookModule: HookLifecycleMethods, hook: object): void {
  callHookLifecycle(hookModule, hook, "destroyed");
}
