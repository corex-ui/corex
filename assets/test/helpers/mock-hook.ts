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

export function callHookLifecycle(
  hookModule: Partial<Record<HookLifecycle, (this: never) => void>>,
  hook: object,
  lifecycle: HookLifecycle
): void {
  const fn = hookModule[lifecycle];
  expect(fn).toBeDefined();
  fn!.call(hook as never);
}

export function callHookMounted(
  hookModule: Partial<Record<"mounted", (this: never) => void>>,
  hook: object
): void {
  callHookLifecycle(hookModule, hook, "mounted");
}

export function callHookDestroyed(
  hookModule: Partial<Record<"destroyed", (this: never) => void>>,
  hook: object
): void {
  callHookLifecycle(hookModule, hook, "destroyed");
}
