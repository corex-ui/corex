import { describe, expect, it, vi, afterEach } from "vitest";
import * as hookModule from "../../hooks/checkbox";
import { checkedChangePayload, Checkbox as CheckboxHook } from "../../hooks/checkbox";
import { Checkbox as CheckboxComponent } from "../../components/checkbox";
import { expectHookModule } from "../helpers/expect-hook";
import { callHookDestroyed, callHookMounted, mockHookContext } from "../helpers/mock-hook";

describe("checkbox hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});

describe("checkedChangePayload", () => {
  it.each([
    [true, true],
    [false, false],
  ] as const)("%#", (checked, expected) => {
    const el = document.createElement("div");
    el.id = "cb-1";
    expect(checkedChangePayload(el, { checked })).toEqual({ id: "cb-1", checked: expected });
  });
});

describe("checkbox_set_checked_many", () => {
  afterEach(() => {
    document.body.innerHTML = "";
  });

  it("sets checked when el id is in payload ids", () => {
    const el = document.createElement("div");
    el.id = "row-1";
    document.body.appendChild(el);

    const { hook } = mockHookContext(el, {
      connected: false,
      overrides: {
        checkbox: undefined as CheckboxComponent | undefined,
        handleRegistry: undefined as
          | ReturnType<typeof import("../../lib/hook-handlers").createHookHandleEventRegistry>
          | undefined,
        domRegistry: undefined as
          | ReturnType<typeof import("../../lib/dom-events").createDomEventRegistry>
          | undefined,
      },
    });

    callHookMounted(CheckboxHook, hook);
    const setCheckedSpy = vi.spyOn(hook.checkbox!.api, "setChecked");

    const manyHandler = hook.handleEvent.mock.calls.find(
      ([event]) => event === "checkbox_set_checked_many"
    )?.[1];
    expect(manyHandler).toBeDefined();

    manyHandler!({ ids: ["other"], checked: true });
    expect(setCheckedSpy).not.toHaveBeenCalled();

    manyHandler!({ ids: ["row-1", "row-2"], checked: true });
    expect(setCheckedSpy).toHaveBeenCalledWith(true);

    callHookDestroyed(CheckboxHook, hook);
    setCheckedSpy.mockRestore();
  });
});
