import { expect, vi, type Mock } from "vitest";
import type { CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { mockLiveSocket } from "./mock-live-socket";

type AnyMock = Mock<(...args: unknown[]) => unknown>;
type HandleEventMock = Mock<(event: string, callback: (payload: unknown) => void) => CallbackRef>;

const anyMock = (): AnyMock => vi.fn() as AnyMock;

export function mockHookJs(): {
  exec: AnyMock;
  show: AnyMock;
  hide: AnyMock;
  toggle: AnyMock;
  addClass: AnyMock;
  removeClass: AnyMock;
  toggleClass: AnyMock;
  transition: AnyMock;
  setAttribute: AnyMock;
  removeAttribute: AnyMock;
  toggleAttribute: AnyMock;
  push: AnyMock;
  navigate: AnyMock;
  patch: AnyMock;
  ignoreAttributes: AnyMock;
} {
  return {
    exec: anyMock(),
    show: anyMock(),
    hide: anyMock(),
    toggle: anyMock(),
    addClass: anyMock(),
    removeClass: anyMock(),
    toggleClass: anyMock(),
    transition: anyMock(),
    setAttribute: anyMock(),
    removeAttribute: anyMock(),
    toggleAttribute: anyMock(),
    push: anyMock(),
    navigate: anyMock(),
    patch: anyMock(),
    ignoreAttributes: anyMock(),
  };
}

export type MockHookJs = ReturnType<typeof mockHookJs>;

type BaseHookContext<E extends HTMLElement> = {
  el: E;
  pushEvent: AnyMock;
  js: () => MockHookJs;
  liveSocket: ReturnType<typeof mockLiveSocket>["ctx"]["liveSocket"];
  handleEvent: HandleEventMock;
  removeHandleEvent: AnyMock;
};

type MockHookContextOptions<Extra extends Record<string, unknown>> = {
  connected?: boolean;
  overrides?: Extra;
};

export function mockHookContext<
  E extends HTMLElement,
  Extra extends Record<string, unknown> = Record<string, never>,
>(
  el: E,
  opts: MockHookContextOptions<Extra> = {}
): {
  hook: BaseHookContext<E> & Extra;
  patch: AnyMock;
  navigate: AnyMock;
  jsCommands: MockHookJs;
  liveSocket: ReturnType<typeof mockLiveSocket>["ctx"]["liveSocket"];
} {
  const connected = opts.connected ?? false;
  const { ctx, patch, navigate } = mockLiveSocket(connected);
  const jsCommands = mockHookJs();
  jsCommands.patch = patch;
  jsCommands.navigate = navigate;

  const base: BaseHookContext<E> = {
    el,
    pushEvent: anyMock(),
    js: () => jsCommands,
    liveSocket: ctx.liveSocket,
    handleEvent: vi.fn((event: string, callback: (payload: unknown) => void): CallbackRef => ({
      event,
      callback,
    })) as HandleEventMock,
    removeHandleEvent: anyMock(),
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
