import { beforeEach, describe, expect, it, vi } from "vitest";
import { Component } from "../../lib/core";
import type { VanillaMachine } from "@zag-js/vanilla";
import type { MachineSchema } from "@zag-js/core";

type TestProps = {
  value?: string;
  open?: boolean;
  onChange?: () => void;
  collection?: { id: string };
};

type TestApi = { value: string };
type TestSchema = MachineSchema;

type MachineStub = {
  start: ReturnType<typeof vi.fn>;
  stop: ReturnType<typeof vi.fn>;
  subscribe: ReturnType<typeof vi.fn>;
  updateProps: ReturnType<typeof vi.fn>;
  service: object;
  scope: { id: string };
};

const stubs = new WeakMap<object, MachineStub>();

function createMachineStub(): MachineStub {
  return {
    start: vi.fn(),
    stop: vi.fn(),
    subscribe: vi.fn(() => vi.fn()),
    updateProps: vi.fn(),
    service: {},
    scope: { id: "test-scope" },
  };
}

class TestComponent extends Component<TestProps, TestApi, TestSchema> {
  renderCount = 0;

  initMachine(_props: TestProps): VanillaMachine<TestSchema> {
    const stub = createMachineStub();
    stubs.set(this, stub);
    return stub as unknown as VanillaMachine<TestSchema>;
  }

  initApi(): TestApi {
    return { value: "ok" };
  }

  render(): void {
    this.renderCount += 1;
  }

  get stub(): MachineStub {
    return stubs.get(this)!;
  }
}

describe("Component", () => {
  beforeEach(() => {
    document.body.innerHTML = "";
  });

  it("requires a root element", () => {
    expect(() => new TestComponent(null as unknown as HTMLElement, {})).toThrow(
      "Root element not found"
    );
  });

  it("clears data-loading, starts the machine, and renders on init", () => {
    const el = document.createElement("div");
    el.setAttribute("data-loading", "");
    document.body.appendChild(el);
    const component = new TestComponent(el, {});

    component.init();

    expect(el.hasAttribute("data-loading")).toBe(false);
    expect(component.stub.start).toHaveBeenCalledOnce();
    expect(component.renderCount).toBe(1);
    expect(component.stub.subscribe).toHaveBeenCalledOnce();
  });

  it("stops the machine and clears the subscription on destroy", () => {
    const el = document.createElement("div");
    document.body.appendChild(el);
    const unsubscribe = vi.fn();
    const component = new TestComponent(el, {});
    component.stub.subscribe.mockReturnValue(unsubscribe);

    component.init();
    component.destroy();

    expect(unsubscribe).toHaveBeenCalledOnce();
    expect(component.stub.stop).toHaveBeenCalledOnce();
  });

  it("skips a controlled update when the props key is unchanged", () => {
    const el = document.createElement("div");
    document.body.appendChild(el);
    const component = new TestComponent(el, { value: "one" });

    expect(component.updateProps({ value: "one", open: true })).toBe(true);
    expect(component.updateProps({ open: true, value: "one" })).toBe(false);
    expect(component.stub.updateProps).toHaveBeenCalledOnce();
  });

  it("applies a controlled update when a tracked prop changes", () => {
    const el = document.createElement("div");
    document.body.appendChild(el);
    const component = new TestComponent(el, {});

    expect(component.updateProps({ value: "one" })).toBe(true);
    expect(component.updateProps({ value: "two" })).toBe(true);
    expect(component.stub.updateProps).toHaveBeenCalledTimes(2);
  });

  it("ignores function props and heavy collection keys when hashing updates", () => {
    const el = document.createElement("div");
    document.body.appendChild(el);
    const component = new TestComponent(el, {});

    expect(
      component.updateProps({
        value: "one",
        onChange: () => {},
        collection: { id: "a" },
      })
    ).toBe(true);
    expect(
      component.updateProps({
        value: "one",
        onChange: () => {},
        collection: { id: "b" },
      })
    ).toBe(false);
    expect(component.stub.updateProps).toHaveBeenCalledOnce();
  });
});
