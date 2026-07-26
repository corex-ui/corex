import { describe, expect, it, vi } from "vitest";
import type { CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import * as hookModule from "../../hooks/select";
import {
  buildCollection,
  controlledValueMatchesServer,
  formatSelectHiddenValue,
  reapplySelectInteractiveState,
  syncSelectHiddenInputForPhoenix,
  syncControlledValueInputFromServer,
  syncSelectHiddenSelectForPhoenix,
  Select as SelectHook,
} from "../../hooks/select";
import type { Select as SelectComponent } from "../../components/select";
import { mutableArray } from "../helpers/matrix";
import type { ValueLabelItem } from "../../lib/list-collection";
import { expectHookModule } from "../helpers/expect-hook";
import { el } from "../helpers/dom";
import {
  callHookDestroyed,
  callHookLifecycle,
  callHookMounted,
  mockHookContext,
} from "../helpers/mock-hook";
import { scopeTree } from "../helpers/component-fixture";
import { withId } from "../helpers/component-smoke";

const items: ValueLabelItem[] = [
  { label: "Alpha", value: "a" },
  { label: "Beta", value: "b" },
];

describe("select hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});

describe("reapplySelectInteractiveState", () => {
  it("clears stale disabled on trigger when hook is enabled", () => {
    const root = el({});
    root.setAttribute("data-loading", "");
    root.innerHTML = `<button data-scope="select" data-part="trigger" disabled></button>`;

    reapplySelectInteractiveState(root);

    const trigger = root.querySelector("button")!;
    expect(root.hasAttribute("data-loading")).toBe(false);
    expect(trigger.disabled).toBe(false);
    expect(trigger.hasAttribute("disabled")).toBe(false);
  });

  it("keeps disabled trigger when hook is disabled", () => {
    const root = el({ disabled: true });
    root.innerHTML = `<button data-scope="select" data-part="trigger" data-disabled disabled></button>`;

    reapplySelectInteractiveState(root);

    const trigger = root.querySelector("button")!;
    expect(trigger.disabled).toBe(true);
  });
});

describe("buildCollection", () => {
  it("builds flat collection", () => {
    expect(buildCollection(items, false).size).toBe(2);
  });

  it("builds grouped collection", () => {
    const grouped: ValueLabelItem[] = [
      { label: "A", value: "a", group: "g1" },
      { label: "B", value: "b", group: "g2" },
    ];
    expect(buildCollection(mutableArray(grouped), true).size).toBe(2);
  });
});

describe("syncSelectHiddenInputForPhoenix", () => {
  it("syncs multiple form values to hidden select options when name[] is present", () => {
    const root = el({ multiple: true, hiddenSelectName: "post[tags][]" });
    root.innerHTML = `
      <input data-scope="select" data-part="value-input" type="text" hidden name="post[tags]" />
      <select data-scope="select" data-part="hidden-select" multiple>
        <option value=""></option>
        <option value="option1">Option 1</option>
        <option value="option2">Option 2</option>
      </select>
    `;

    syncSelectHiddenInputForPhoenix(root, ["option1", "option2"]);

    const hiddenSelect = root.querySelector<HTMLSelectElement>(
      '[data-scope="select"][data-part="hidden-select"]'
    )!;
    expect(hiddenSelect.name).toBe("post[tags][]");
    const selected = Array.from(hiddenSelect.selectedOptions).map((option) => option.value);
    expect(selected).toEqual(["option1", "option2"]);
  });

  it("syncs single select values to value-input synchronously", () => {
    const root = el({ multiple: false });
    root.innerHTML = `<input data-scope="select" data-part="value-input" type="text" hidden name="post[status]" />`;

    syncSelectHiddenInputForPhoenix(root, ["draft"]);

    const valueInput = root.querySelector<HTMLInputElement>(
      '[data-scope="select"][data-part="value-input"]'
    )!;
    expect(valueInput.value).toBe("draft");
  });
});

describe("formatSelectHiddenValue", () => {
  it("joins multiple values with commas for legacy value-input mode", () => {
    const root = el({ multiple: true });
    expect(formatSelectHiddenValue(root, ["a", "b"])).toBe("a,b");
  });
});

describe("controlledValueMatchesServer", () => {
  it("matches empty controlled value against empty server data-value", () => {
    const root = el({ controlled: true, value: "" });
    expect(controlledValueMatchesServer(root, [])).toBe(true);
  });

  it("does not match user selection before server data-value updates", () => {
    const root = el({ controlled: true, value: "" });
    expect(controlledValueMatchesServer(root, ["fra"])).toBe(false);
  });
});

describe("syncControlledValueInputFromServer", () => {
  it("updates value-input without dispatching change", () => {
    const root = el({ controlled: true, value: "fra" });
    root.innerHTML = `<input data-scope="select" data-part="value-input" type="text" hidden name="post[country]" value="" />`;
    const valueInput = root.querySelector<HTMLInputElement>(
      '[data-scope="select"][data-part="value-input"]'
    )!;
    const changeHandler = vi.fn();
    valueInput.addEventListener("change", changeHandler);

    syncControlledValueInputFromServer(root, ["fra"]);

    expect(valueInput.value).toBe("fra");
    expect(changeHandler).not.toHaveBeenCalled();
  });

  it("no-ops when value already matches server", () => {
    const root = el({ controlled: true, value: "fra" });
    root.innerHTML = `<input data-scope="select" data-part="value-input" type="text" hidden name="post[country]" value="fra" />`;

    syncControlledValueInputFromServer(root, ["fra"]);

    const valueInput = root.querySelector<HTMLInputElement>(
      '[data-scope="select"][data-part="value-input"]'
    )!;
    expect(valueInput.value).toBe("fra");
  });
});

describe("syncSelectHiddenSelectForPhoenix", () => {
  it("clears selection when values are empty", () => {
    const hiddenSelect = document.createElement("select");
    hiddenSelect.multiple = true;
    hiddenSelect.innerHTML = `
      <option value=""></option>
      <option value="option1">Option 1</option>
    `;
    hiddenSelect.options[1]!.selected = true;

    syncSelectHiddenSelectForPhoenix(hiddenSelect, []);

    expect(Array.from(hiddenSelect.selectedOptions)).toHaveLength(0);
  });
});

describe("Select hook morph sync", () => {
  it("updated restores trigger label after morph wipe", () => {
    const root = withId(
      scopeTree("select", [
        {
          part: "root",
          children: [
            {
              part: "control",
              children: [
                {
                  part: "trigger",
                  children: [{ part: "item-text", text: "France" }],
                },
              ],
            },
            {
              part: "content",
              children: [
                {
                  part: "item",
                  attrs: { "data-value": "fra" },
                  children: [{ part: "item-text", text: "France" }],
                },
              ],
            },
          ],
        },
      ])
    );
    root.id = "select-morph";
    root.setAttribute("phx-hook", "Select");
    root.setAttribute("data-placeholder", "Pick");
    root.setAttribute("data-default-value", "fra");
    root.setAttribute(
      "data-items",
      JSON.stringify([{ label: "France", value: "fra", disabled: false }])
    );
    document.body.appendChild(root);

    const { hook } = mockHookContext(root, {
      connected: false,
      overrides: {
        select: undefined as SelectComponent | undefined,
        handlers: [] as CallbackRef[],
        beforeAttrs: undefined,
        lastItemsJson: undefined as string | undefined,
      },
    });

    callHookMounted(SelectHook, hook);

    const valueText = root.querySelector<HTMLElement>(
      '[data-scope="select"][data-part="trigger"] [data-part="item-text"]'
    )!;
    expect(hook.select!.api.value).toEqual(["fra"]);
    expect(valueText.textContent).toBe("France");

    valueText.textContent = "Pick";
    callHookLifecycle(SelectHook, hook, "updated");
    expect(valueText.textContent).toBe("France");

    callHookDestroyed(SelectHook, hook);
    root.remove();
  });
});
