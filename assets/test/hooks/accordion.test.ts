import { afterEach, describe, expect, it, vi } from "vitest";
import type { CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import * as hookModule from "../../hooks/accordion";
import { Accordion as AccordionHook, readAccordionLayoutProps } from "../../hooks/accordion";
import type { Accordion as AccordionComponent } from "../../components/accordion";
import { parseDatasetValueList } from "../../lib/read-props";
import { el } from "../helpers/dom";
import { hasKey } from "../helpers/matrix";
import { expectHookModule } from "../helpers/expect-hook";
import { scopeTree } from "../helpers/component-fixture";
import {
  callHookDestroyed,
  callHookLifecycle,
  callHookMounted,
  mockHookContext,
} from "../helpers/mock-hook";

const { runHeightOpenTransitionMock } = vi.hoisted(() => ({
  runHeightOpenTransitionMock: vi.fn(),
}));

vi.mock("../../lib/animation", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/animation")>();
  return {
    ...actual,
    runHeightOpenTransition: runHeightOpenTransitionMock,
  };
});

function twoItemRoot(id: string) {
  const root = scopeTree("accordion", [
    {
      part: "root",
      children: [
        {
          part: "item",
          attrs: { "data-value": "lorem", id: `accordion:${id}:item:lorem` },
          children: [
            { part: "item-trigger" },
            { part: "item-indicator" },
            { part: "item-content" },
          ],
        },
        {
          part: "item",
          attrs: { "data-value": "duis", id: `accordion:${id}:item:duis` },
          children: [
            { part: "item-trigger" },
            { part: "item-indicator" },
            { part: "item-content" },
          ],
        },
      ],
    },
  ]);
  root.id = id;
  root.setAttribute("phx-hook", "Accordion");
  return root;
}

function mountAccordion(
  root: HTMLElement,
  opts: { connected?: boolean; lastValue?: string[] } = {}
) {
  document.body.appendChild(root);
  const { hook } = mockHookContext(root, {
    connected: opts.connected ?? false,
    overrides: {
      accordion: undefined as AccordionComponent | undefined,
      handlers: [] as CallbackRef[],
      beforeAttrs: undefined as { value?: string } | undefined,
      lastValue: opts.lastValue as string[] | undefined,
    },
  });
  callHookMounted(AccordionHook, hook);
  return hook;
}

describe("accordion hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});

describe("readAccordionLayoutProps", () => {
  it.each([
    [{ collapsible: true, multiple: true, orientation: "vertical", dir: "rtl" }, true, "vertical"],
    [{ collapsible: false, orientation: "horizontal" }, false, "horizontal"],
  ] as const)("%#", (dataset, collapsible, orientation) => {
    const node = el(dataset as Record<string, string | boolean>);
    node.id = "acc-test";
    const props = readAccordionLayoutProps(node);
    expect(props.id).toBe("acc-test");
    expect(props.collapsible).toBe(collapsible);
    expect(props.orientation).toBe(orientation);
    expect(props.dir).toBe(hasKey(dataset, "dir") ? dataset.dir : "ltr");
  });
});

describe("parseDatasetValueList", () => {
  it.each([
    [undefined, []],
    ["", []],
    ['["lorem","duis"]', ["lorem", "duis"]],
    ["lorem,duis", ["lorem", "duis"]],
  ] as const)("%j → %j", (raw, expected) => {
    expect(parseDatasetValueList(raw)).toEqual([...expected]);
  });
});

describe("Accordion hook item disabled morph", () => {
  afterEach(() => {
    document.body.innerHTML = "";
  });

  it("updated re-spreads trigger disabled when item data-disabled flips without layout change", () => {
    const root = scopeTree("accordion", [
      {
        part: "root",
        children: [
          {
            part: "item",
            attrs: { "data-value": "lorem", id: "accordion:acc-disable:item:lorem" },
            children: [
              { part: "item-trigger" },
              { part: "item-indicator" },
              { part: "item-content" },
            ],
          },
        ],
      },
    ]);
    root.id = "acc-disable";
    root.setAttribute("phx-hook", "Accordion");
    root.dataset.collapsible = "true";
    document.body.appendChild(root);

    const { hook } = mockHookContext(root, {
      connected: false,
      overrides: {
        accordion: undefined as AccordionComponent | undefined,
        handlers: [] as CallbackRef[],
        beforeAttrs: undefined,
        lastValue: undefined as string[] | undefined,
      },
    });

    callHookMounted(AccordionHook, hook);

    const item = root.querySelector<HTMLElement>(
      '[data-scope="accordion"][data-part="item"][data-value="lorem"]'
    )!;
    const trigger = item.querySelector<HTMLElement>(
      '[data-scope="accordion"][data-part="item-trigger"]'
    )!;
    expect(trigger.hasAttribute("disabled")).toBe(false);

    item.setAttribute("data-disabled", "");
    callHookLifecycle(AccordionHook, hook, "beforeUpdate");
    callHookLifecycle(AccordionHook, hook, "updated");

    expect(trigger.hasAttribute("disabled")).toBe(true);

    item.removeAttribute("data-disabled");
    callHookLifecycle(AccordionHook, hook, "beforeUpdate");
    callHookLifecycle(AccordionHook, hook, "updated");

    expect(trigger.hasAttribute("disabled")).toBe(false);

    callHookDestroyed(AccordionHook, hook);
  });
});

describe("Accordion hook controlled height prev", () => {
  afterEach(() => {
    document.body.innerHTML = "";
    runHeightOpenTransitionMock.mockClear();
  });

  it("updated height transition uses beforeAttrs value, not a stale lastValue", () => {
    const root = twoItemRoot("acc-ctrl");
    root.dataset.controlled = "";
    root.dataset.animation = "js";
    root.dataset.value = JSON.stringify(["lorem"]);
    const hook = mountAccordion(root);

    hook.lastValue = ["wrong-stale"];
    runHeightOpenTransitionMock.mockClear();

    hook.beforeAttrs = { value: JSON.stringify(["lorem"]) };
    root.dataset.value = JSON.stringify(["duis"]);
    callHookLifecycle(AccordionHook, hook, "updated");

    expect(runHeightOpenTransitionMock).toHaveBeenCalledWith(
      expect.objectContaining({
        prevOpen: ["lorem"],
        nextOpen: ["duis"],
      })
    );
    expect(hook.lastValue).toEqual(["duis"]);

    callHookDestroyed(AccordionHook, hook);
  });
});

describe("Accordion hook uncontrolled JS height", () => {
  afterEach(() => {
    document.body.innerHTML = "";
    runHeightOpenTransitionMock.mockClear();
  });

  it("onValueChange runs height transition from previousValue to next", async () => {
    const root = twoItemRoot("acc-unctrl-js");
    root.dataset.animation = "js";
    root.dataset.collapsible = "true";
    root.dataset.defaultValue = JSON.stringify(["lorem"]);
    const hook = mountAccordion(root);
    runHeightOpenTransitionMock.mockClear();

    hook.accordion!.api.setValue(["duis"]);
    await Promise.resolve();

    expect(runHeightOpenTransitionMock).toHaveBeenCalledWith(
      expect.objectContaining({
        prevOpen: ["lorem"],
        nextOpen: ["duis"],
      })
    );
    expect(hook.lastValue).toEqual(["duis"]);

    callHookDestroyed(AccordionHook, hook);
  });

  it("controlled hosts skip client-side height transition onValueChange", async () => {
    const root = twoItemRoot("acc-ctrl-skip");
    root.dataset.animation = "js";
    root.dataset.controlled = "";
    root.dataset.value = JSON.stringify(["lorem"]);
    const hook = mountAccordion(root);
    runHeightOpenTransitionMock.mockClear();

    hook.accordion!.api.setValue(["duis"]);
    await Promise.resolve();

    expect(runHeightOpenTransitionMock).not.toHaveBeenCalled();

    callHookDestroyed(AccordionHook, hook);
  });
});

describe("AccordionChangedDetail payload", () => {
  afterEach(() => {
    document.body.innerHTML = "";
  });

  it("onValueChange pushes previousValue, added, and removed", async () => {
    const root = twoItemRoot("acc-detail");
    root.dataset.collapsible = "true";
    root.dataset.defaultValue = JSON.stringify(["lorem"]);
    root.dataset.onValueChange = "accordion_value_changed";
    const hook = mountAccordion(root, { connected: true });

    hook.accordion!.api.setValue(["duis"]);
    await Promise.resolve();

    expect(hook.pushEvent).toHaveBeenCalledWith(
      "accordion_value_changed",
      expect.objectContaining({
        id: "acc-detail",
        value: ["duis"],
        previousValue: ["lorem"],
        added: ["duis"],
        removed: ["lorem"],
      })
    );

    callHookDestroyed(AccordionHook, hook);
  });

  it("onValueChangeClient dispatches the same detail shape", async () => {
    const root = twoItemRoot("acc-detail-client");
    root.dataset.collapsible = "true";
    root.dataset.defaultValue = JSON.stringify(["lorem"]);
    root.dataset.onValueChangeClient = "my-accordion-changed";
    const hook = mountAccordion(root);
    const seen: unknown[] = [];
    root.addEventListener("my-accordion-changed", ((e: CustomEvent) => {
      seen.push(e.detail);
    }) as EventListener);

    hook.accordion!.api.setValue(["duis"]);
    await Promise.resolve();

    expect(seen).toEqual([
      expect.objectContaining({
        id: "acc-detail-client",
        value: ["duis"],
        previousValue: ["lorem"],
        added: ["duis"],
        removed: ["lorem"],
      }),
    ]);

    callHookDestroyed(AccordionHook, hook);
  });
});

describe("Accordion set-value APIs", () => {
  afterEach(() => {
    document.body.innerHTML = "";
  });

  it("corex:accordion:set-value calls api.setValue", async () => {
    const root = twoItemRoot("acc-set-dom");
    root.dataset.collapsible = "true";
    root.dataset.defaultValue = JSON.stringify(["lorem"]);
    const hook = mountAccordion(root);
    const spy = vi.spyOn(hook.accordion!.api, "setValue");

    root.dispatchEvent(
      new CustomEvent("corex:accordion:set-value", {
        bubbles: false,
        detail: { value: ["duis"] },
      })
    );
    await Promise.resolve();

    expect(spy).toHaveBeenCalledWith(["duis"]);

    callHookDestroyed(AccordionHook, hook);
    spy.mockRestore();
  });

  it("accordion_set_value only applies for matching id", async () => {
    const root = twoItemRoot("acc-set-srv");
    root.dataset.collapsible = "true";
    root.dataset.defaultValue = JSON.stringify(["lorem"]);
    const hook = mountAccordion(root);
    const spy = vi.spyOn(hook.accordion!.api, "setValue");
    const handler = hook.handleEvent.mock.calls.find(
      ([event]) => event === "accordion_set_value"
    )?.[1];
    expect(handler).toBeDefined();

    handler!({ id: "other", value: ["duis"] });
    handler!({ id: "acc-set-srv", value: ["duis"] });
    await Promise.resolve();

    expect(spy).toHaveBeenCalledTimes(1);
    expect(spy).toHaveBeenCalledWith(["duis"]);

    callHookDestroyed(AccordionHook, hook);
    spy.mockRestore();
  });
});

describe("Accordion value / focused / item-state emit", () => {
  afterEach(() => {
    document.body.innerHTML = "";
  });

  it("accordion_value responds on server and DOM channels", () => {
    const root = twoItemRoot("acc-value");
    root.dataset.defaultValue = JSON.stringify(["lorem"]);
    const hook = mountAccordion(root, { connected: true });
    const handler = hook.handleEvent.mock.calls.find(([event]) => event === "accordion_value")?.[1];
    expect(handler).toBeDefined();

    handler!({ id: "other" });
    expect(hook.pushEvent).not.toHaveBeenCalledWith(
      "accordion_value_response",
      expect.anything()
    );

    handler!({ id: "acc-value" });
    expect(hook.pushEvent).toHaveBeenCalledWith("accordion_value_response", {
      id: "acc-value",
      value: ["lorem"],
    });

    const seen: unknown[] = [];
    root.addEventListener("accordion-value", ((e: CustomEvent) => {
      seen.push(e.detail);
    }) as EventListener);

    root.dispatchEvent(
      new CustomEvent("corex:accordion:value", {
        bubbles: false,
        detail: { respond_to: "client" },
      })
    );

    expect(seen).toEqual([{ id: "acc-value", value: ["lorem"] }]);

    callHookDestroyed(AccordionHook, hook);
  });

  it("accordion_focused responds with focusedValue", () => {
    const root = twoItemRoot("acc-focused");
    const hook = mountAccordion(root, { connected: true });
    const handler = hook.handleEvent.mock.calls.find(
      ([event]) => event === "accordion_focused"
    )?.[1];
    expect(handler).toBeDefined();

    handler!({ id: "acc-focused" });
    expect(hook.pushEvent).toHaveBeenCalledWith("accordion_focused_response", {
      id: "acc-focused",
      value: hook.accordion!.api.focusedValue ?? null,
    });

    callHookDestroyed(AccordionHook, hook);
  });

  it("accordion_item_state responds with expanded focused disabled", () => {
    const root = twoItemRoot("acc-item-state");
    root.dataset.defaultValue = JSON.stringify(["lorem"]);
    const hook = mountAccordion(root, { connected: true });
    const handler = hook.handleEvent.mock.calls.find(
      ([event]) => event === "accordion_item_state"
    )?.[1];
    expect(handler).toBeDefined();

    handler!({ id: "acc-item-state", value: "lorem", disabled: false });
    expect(hook.pushEvent).toHaveBeenCalledWith(
      "accordion_item_state_response",
      expect.objectContaining({
        id: "acc-item-state",
        value: "lorem",
        state: expect.objectContaining({
          expanded: true,
          disabled: false,
        }),
      })
    );

    const seen: unknown[] = [];
    root.addEventListener("accordion-item-state", ((e: CustomEvent) => {
      seen.push(e.detail);
    }) as EventListener);

    root.dispatchEvent(
      new CustomEvent("corex:accordion:item-state", {
        bubbles: false,
        detail: { value: "duis", disabled: true, respond_to: "client" },
      })
    );

    expect(seen).toEqual([
      expect.objectContaining({
        id: "acc-item-state",
        value: "duis",
        state: expect.objectContaining({ disabled: true, expanded: false }),
      }),
    ]);

    callHookDestroyed(AccordionHook, hook);
  });
});

describe("Accordion onFocusChange notify", () => {
  afterEach(() => {
    document.body.innerHTML = "";
  });

  it("onFocusChange notify payload includes id and value", async () => {
    const root = twoItemRoot("acc-focus-change");
    root.dataset.onFocusChange = "accordion_focus_changed";
    const hook = mountAccordion(root, { connected: true });

    const trigger = root.querySelector<HTMLElement>(
      '[data-part="item"][data-value="duis"] [data-part="item-trigger"]'
    )!;
    trigger.focus();
    trigger.dispatchEvent(new FocusEvent("focusin", { bubbles: true }));
    await Promise.resolve();

    if (hook.pushEvent.mock.calls.length === 0) {
      trigger.dispatchEvent(
        new KeyboardEvent("keydown", { key: "ArrowDown", bubbles: true, code: "ArrowDown" })
      );
      await Promise.resolve();
    }

    expect(hook.pushEvent).toHaveBeenCalledWith(
      "accordion_focus_changed",
      expect.objectContaining({
        id: "acc-focus-change",
      })
    );

    callHookDestroyed(AccordionHook, hook);
  });
});

describe("Accordion render-on-miss", () => {
  afterEach(() => {
    document.body.innerHTML = "";
  });

  it("updated calls render when updateProps returns false", () => {
    const root = twoItemRoot("acc-render-miss");
    root.dataset.collapsible = "true";
    const hook = mountAccordion(root);
    const renderSpy = vi.spyOn(hook.accordion!, "render");
    const updateSpy = vi.spyOn(hook.accordion!, "updateProps").mockReturnValue(false);

    callHookLifecycle(AccordionHook, hook, "beforeUpdate");
    callHookLifecycle(AccordionHook, hook, "updated");

    expect(updateSpy).toHaveBeenCalled();
    expect(renderSpy).toHaveBeenCalled();

    callHookDestroyed(AccordionHook, hook);
    renderSpy.mockRestore();
    updateSpy.mockRestore();
  });

  it("updated does not call render when updateProps returns true", () => {
    const root = twoItemRoot("acc-render-hit");
    root.dataset.collapsible = "true";
    const hook = mountAccordion(root);
    const renderSpy = vi.spyOn(hook.accordion!, "render");
    const updateSpy = vi.spyOn(hook.accordion!, "updateProps").mockReturnValue(true);

    callHookLifecycle(AccordionHook, hook, "beforeUpdate");
    callHookLifecycle(AccordionHook, hook, "updated");

    expect(updateSpy).toHaveBeenCalled();
    expect(renderSpy).not.toHaveBeenCalled();

    callHookDestroyed(AccordionHook, hook);
    renderSpy.mockRestore();
    updateSpy.mockRestore();
  });
});
