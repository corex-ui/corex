import { describe, expect, it, vi } from "vitest";
import * as hookModule from "../../hooks/number-input";
import { buildMachineProps } from "../../hooks/number-input";
import { mountNumberBinding, readUpdatedServerNumber } from "../../lib/read-props";
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
    expect(props.value).toBe("5");
    expect(props.min).toBe(0);
    expect(props.max).toBe(10);
    expect(props.formatOptions).toEqual({ useGrouping: true });
  });

  it("formats 10.0 as 10 for whole step", () => {
    const node = el({ controlled: true, value: "10.0", step: 1 });
    node.id = "ni-whole";
    const props = buildMachineProps(node, vi.fn(), () => true);
    expect(props.value).toBe("10");
  });

  it("uses defaultValue when uncontrolled", () => {
    const node = el({ defaultValue: 2, step: 1 });
    node.id = "ni2";
    const props = buildMachineProps(node, vi.fn(), () => false);
    expect(props.defaultValue).toBe("2");
  });
});

describe("mountNumberBinding", () => {
  it("formField uses defaultValue from data-default-value", () => {
    const node = el({ formField: true, defaultValue: "1234", step: 1 });
    const props = mountNumberBinding(node);
    expect(props.defaultValue).toBe("1,234");
    expect(props.value).toBeUndefined();
  });
});

describe("readUpdatedServerNumber", () => {
  it("formField without controlled returns step only when attrs unchanged", () => {
    const node = el({ formField: true, defaultValue: "1234", step: 1 });
    expect(readUpdatedServerNumber(node, { defaultValue: "1234" })).toEqual({ step: 1 });
  });

  it("controlled patches when data-value changes across patch", () => {
    const node = el({ controlled: true, value: "50", step: 1 });
    expect(readUpdatedServerNumber(node, { value: "1234" })).toEqual({
      step: 1,
      value: "50",
    });
  });
});
