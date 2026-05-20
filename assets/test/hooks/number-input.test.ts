import { describe, expect, it, vi } from "vitest";
import * as hookModule from "../../hooks/number-input";
import { buildMachineProps } from "../../hooks/number-input";
import { el } from "../helpers/dom";
import { expectHookModule } from "../helpers/expect-hook";

describe("number-input hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});

describe("buildMachineProps", () => {
  it("reads numeric dataset into props", () => {
    const node = el({
      controlled: true,
      value: 5,
      min: 0,
      max: 10,
      step: 1,
      disabled: false,
    });
    node.id = "ni";
    const props = buildMachineProps(node, vi.fn(), () => true);
    expect(props.id).toBe("ni");
    expect(props.value).toBe(5);
    expect(props.min).toBe(0);
    expect(props.max).toBe(10);
  });

  it("uses defaultValue when uncontrolled", () => {
    const node = el({ defaultValue: 2, step: 1 });
    node.id = "ni2";
    const props = buildMachineProps(node, vi.fn(), () => false);
    expect(props.defaultValue).toBe(2);
  });
});
