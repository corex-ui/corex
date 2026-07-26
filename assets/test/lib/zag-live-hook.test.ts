import { beforeEach, describe, expect, it, vi } from "vitest";
import type { CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { createZagLiveHook, type ZagHookRegistries } from "../../lib/zag-live-hook";

type FakeComponent = {
  init: () => void;
  destroy: () => void;
};

type FakeState = {
  widget?: FakeComponent;
  mountCount?: number;
};

function buildHost() {
  const el = document.createElement("div");
  el.id = "widget-1";
  document.body.appendChild(el);

  const removed: CallbackRef[] = [];
  const serverHandlers = new Map<string, (payload: unknown) => void>();

  const context = {
    el,
    handleEvent: vi.fn((name: string, fn: (payload: unknown) => void) => {
      serverHandlers.set(name, fn);
      return Symbol(name) as unknown as CallbackRef;
    }),
    removeHandleEvent: vi.fn((ref: CallbackRef) => {
      removed.push(ref);
    }),
  };

  return { el, context, removed, serverHandlers };
}

function buildComponent() {
  return { init: vi.fn(), destroy: vi.fn() } satisfies FakeComponent;
}

describe("createZagLiveHook", () => {
  beforeEach(() => {
    document.body.innerHTML = "";
  });

  it("stores the mounted component under the configured key and initializes it", () => {
    const { context } = buildHost();
    const component = buildComponent();
    const hook = createZagLiveHook<FakeState, FakeComponent>({
      key: "widget",
      mount: () => component,
    });

    hook.mounted?.call(context as never);

    expect(component.init).toHaveBeenCalledOnce();
    expect((context as unknown as FakeState).widget).toBe(component);
  });

  it("runs afterInit once the machine has started", () => {
    const { context } = buildHost();
    const component = buildComponent();
    const order: string[] = [];
    component.init.mockImplementation(() => order.push("init"));

    const hook = createZagLiveHook<FakeState, FakeComponent>({
      key: "widget",
      mount: () => component,
      afterInit: () => order.push("afterInit"),
    });

    hook.mounted?.call(context as never);

    expect(order).toEqual(["init", "afterInit"]);
  });

  it("skips the component lifecycle when mount returns nothing", () => {
    const { context } = buildHost();
    const update = vi.fn();
    const destroy = vi.fn();
    const hook = createZagLiveHook<FakeState, FakeComponent>({
      key: "widget",
      mount: () => undefined,
      update,
      destroy,
    });

    hook.mounted?.call(context as never);
    hook.updated?.call(context as never);
    hook.destroyed?.call(context as never);

    expect((context as unknown as FakeState).widget).toBeUndefined();
    expect(update).not.toHaveBeenCalled();
    expect(destroy).not.toHaveBeenCalled();
  });

  it("snapshots the controlled keys before an update and clears them after", () => {
    const { el, context } = buildHost();
    el.dataset.value = "one";
    const component = buildComponent();
    let seen: unknown;

    const hook = createZagLiveHook<FakeState, FakeComponent>({
      key: "widget",
      controlledKeys: ["value"],
      mount: () => component,
      update: (h) => {
        seen = h.beforeAttrs;
      },
    });

    hook.mounted?.call(context as never);
    hook.beforeUpdate?.call(context as never);
    el.dataset.value = "two";
    hook.updated?.call(context as never);

    expect(seen).toEqual({ value: "one" });
    expect((context as { beforeAttrs?: unknown }).beforeAttrs).toBeUndefined();
  });

  it("clears the snapshot even when the update callback throws", () => {
    const { context } = buildHost();
    const component = buildComponent();
    const hook = createZagLiveHook<FakeState, FakeComponent>({
      key: "widget",
      controlledKeys: ["value"],
      mount: () => component,
      update: () => {
        throw new Error("boom");
      },
    });

    hook.mounted?.call(context as never);
    hook.beforeUpdate?.call(context as never);

    expect(() => hook.updated?.call(context as never)).toThrow("boom");
    expect((context as { beforeAttrs?: unknown }).beforeAttrs).toBeUndefined();
  });

  it("runs the configured beforeUpdate alongside the snapshot", () => {
    const { context } = buildHost();
    const beforeUpdate = vi.fn();
    const hook = createZagLiveHook<FakeState, FakeComponent>({
      key: "widget",
      controlledKeys: ["value"],
      mount: () => buildComponent(),
      beforeUpdate,
    });

    hook.mounted?.call(context as never);
    hook.beforeUpdate?.call(context as never);

    expect(beforeUpdate).toHaveBeenCalledOnce();
  });

  it("tears down listeners, the component and the state key on destroy", () => {
    const { el, context, removed } = buildHost();
    const component = buildComponent();
    const domHandler = vi.fn();

    const hook = createZagLiveHook<FakeState, FakeComponent>({
      key: "widget",
      mount: (_hook, { dom, server }: ZagHookRegistries) => {
        dom.add("corex:widget:ping", domHandler);
        server.add("widget_ping", vi.fn());
        return component;
      },
    });

    hook.mounted?.call(context as never);
    el.dispatchEvent(new CustomEvent("corex:widget:ping"));
    expect(domHandler).toHaveBeenCalledOnce();

    hook.destroyed?.call(context as never);

    el.dispatchEvent(new CustomEvent("corex:widget:ping"));
    expect(domHandler).toHaveBeenCalledOnce();
    expect(removed).toHaveLength(1);
    expect(component.destroy).toHaveBeenCalledOnce();
    expect((context as unknown as FakeState).widget).toBeUndefined();
  });

  it("calls the destroy callback before the component tears itself down", () => {
    const { context } = buildHost();
    const component = buildComponent();
    const order: string[] = [];
    component.destroy.mockImplementation(() => order.push("component"));

    const hook = createZagLiveHook<FakeState, FakeComponent>({
      key: "widget",
      mount: () => component,
      destroy: () => order.push("callback"),
    });

    hook.mounted?.call(context as never);
    hook.destroyed?.call(context as never);

    expect(order).toEqual(["callback", "component"]);
  });

  it("re-registers listeners on a remount without leaking the previous ones", () => {
    const { el, context, removed } = buildHost();
    const handler = vi.fn();

    const hook = createZagLiveHook<FakeState, FakeComponent>({
      key: "widget",
      mount: (_hook, { dom, server }: ZagHookRegistries) => {
        dom.add("corex:widget:ping", handler);
        server.add("widget_ping", vi.fn());
        return buildComponent();
      },
    });

    hook.mounted?.call(context as never);
    hook.destroyed?.call(context as never);
    hook.mounted?.call(context as never);

    el.dispatchEvent(new CustomEvent("corex:widget:ping"));

    expect(handler).toHaveBeenCalledOnce();
    expect(removed).toHaveLength(1);
  });

  it("forwards disconnected and reconnected to the mounted component only", () => {
    const { context } = buildHost();
    const disconnected = vi.fn();
    const reconnected = vi.fn();

    const hook = createZagLiveHook<FakeState, FakeComponent>({
      key: "widget",
      mount: () => undefined,
      disconnected,
      reconnected,
    });

    hook.mounted?.call(context as never);
    hook.disconnected?.call(context as never);
    hook.reconnected?.call(context as never);

    expect(disconnected).not.toHaveBeenCalled();
    expect(reconnected).not.toHaveBeenCalled();
  });

  it("forwards disconnected and reconnected once a component is mounted", () => {
    const { context } = buildHost();
    const component = buildComponent();
    const disconnected = vi.fn();
    const reconnected = vi.fn();

    const hook = createZagLiveHook<FakeState, FakeComponent>({
      key: "widget",
      mount: () => component,
      disconnected,
      reconnected,
    });

    hook.mounted?.call(context as never);
    hook.disconnected?.call(context as never);
    hook.reconnected?.call(context as never);

    expect(disconnected).toHaveBeenCalledWith(context, component);
    expect(reconnected).toHaveBeenCalledWith(context, component);
  });
});
