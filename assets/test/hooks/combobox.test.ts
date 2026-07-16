import { afterEach, describe, expect, it, vi } from "vitest";
import type { CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import * as hookModule from "../../hooks/combobox";
import {
  comboboxValueBinding,
  formatComboboxHiddenValue,
  Combobox as ComboboxHook,
  selectedItemLabel,
  syncVisibleInputAttribute,
} from "../../hooks/combobox";
import type { Combobox as ComboboxComponent } from "../../components/combobox";
import { expectHookModule } from "../helpers/expect-hook";
import { callHookDestroyed, callHookMounted, mockHookContext } from "../helpers/mock-hook";
import { comboboxTree } from "../helpers/component-smoke";
import { el } from "../helpers/dom";

describe("combobox hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});

describe("comboboxValueBinding", () => {
  it("returns defaultValue when uncontrolled", () => {
    expect(comboboxValueBinding(el({ defaultValue: "x" }))).toEqual({ defaultValue: ["x"] });
  });
});

describe("selectedItemLabel", () => {
  it("returns first item label", () => {
    expect(selectedItemLabel([{ label: "Alpha" }])).toBe("Alpha");
  });

  it("returns empty when no items", () => {
    expect(selectedItemLabel([])).toBe("");
  });
});

describe("formatComboboxHiddenValue", () => {
  it("returns single value", () => {
    expect(formatComboboxHiddenValue(el({}), ["eur"])).toBe("eur");
  });

  it("returns comma joined values when multiple", () => {
    expect(formatComboboxHiddenValue(el({ multiple: true }), ["a", "b"])).toBe("a,b");
  });

  it("returns empty string when no values", () => {
    expect(formatComboboxHiddenValue(el({}), [])).toBe("");
  });
});

describe("syncVisibleInputAttribute", () => {
  it("sets value attribute on visible input", () => {
    const root = document.createElement("div");
    root.innerHTML = `<input data-scope="combobox" data-part="input" />`;
    syncVisibleInputAttribute(root, "query");
    expect(root.querySelector("input")?.getAttribute("value")).toBe("query");
  });
});

describe("Combobox hook lifecycle", () => {
  afterEach(() => {
    document.body.innerHTML = "";
  });

  function mountComboboxHook(id: string) {
    const root = comboboxTree();
    root.id = id;
    root.setAttribute("phx-hook", "Combobox");
    root.setAttribute(
      "data-items",
      JSON.stringify([
        {
          label: "France",
          value: "fra",
          disabled: false,
          meta: {},
          group: null,
        },
      ])
    );
    document.body.appendChild(root);

    const { hook } = mockHookContext(root, {
      connected: true,
      overrides: {
        combobox: undefined as ComboboxComponent | undefined,
        handleRegistry: undefined,
        domRegistry: undefined,
        handlers: [] as CallbackRef[],
      },
    });

    callHookMounted(ComboboxHook, hook);
    return { hook, root };
  }

  it("combobox_set_open only opens the matching combobox root", () => {
    const { hook } = mountComboboxHook("combobox-api-open-server");
    const setOpenSpy = vi.spyOn(hook.combobox!.api, "setOpen");
    const setOpenHandler = hook.handleEvent.mock.calls.find(
      ([event]) => event === "combobox_set_open"
    )?.[1];
    expect(setOpenHandler).toBeDefined();

    setOpenHandler!({ id: "combobox-api-open-client", open: true });
    setOpenHandler!({ id: "combobox-api-open-server", open: true });

    expect(setOpenSpy).toHaveBeenCalledTimes(1);
    expect(setOpenSpy).toHaveBeenCalledWith(true);

    callHookDestroyed(ComboboxHook, hook);
    setOpenSpy.mockRestore();
  });

  it("corex:combobox:set-open dispatches to api.setOpen", () => {
    const { hook, root } = mountComboboxHook("combobox-api-open-client");
    const setOpenSpy = vi.spyOn(hook.combobox!.api, "setOpen");

    root.dispatchEvent(
      new CustomEvent("corex:combobox:set-open", { bubbles: false, detail: { open: true } })
    );

    expect(setOpenSpy).toHaveBeenCalledWith(true);

    callHookDestroyed(ComboboxHook, hook);
    setOpenSpy.mockRestore();
  });
});
