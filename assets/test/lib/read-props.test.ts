import { describe, expect, it } from "vitest";
import { el } from "../helpers/dom";
import {
  readBooleanControlledZagProps,
  readControlledOrDefaultBoolean,
  readControlledOrDefaultStringList,
  readNumberControlledZagProps,
  readStringControlledZagProps,
  readBooleanControlledZagUpdate,
  readCheckedControlledZagUpdate,
  readNumberControlledZagUpdate,
  readPressedControlledZagUpdate,
  readStringControlledZagUpdate,
  readStringListControlledZagUpdate,
  readStringListControlledZagProps,
  readUpdatedServerString,
  mountCheckedBinding,
} from "../../lib/read-props";

describe("readStringControlledZagProps", () => {
  it("returns value when controlled", () => {
    const node = el({ controlled: true, value: "x" });
    expect(readStringControlledZagProps(node, "value", "defaultValue")).toEqual({ value: "x" });
  });

  it("returns defaultValue when uncontrolled", () => {
    const node = el({ defaultValue: "y" });
    expect(readStringControlledZagProps(node, "value", "defaultValue")).toEqual({
      defaultValue: "y",
    });
  });

  it("returns defaultValue from data-default-value when form field without controlled", () => {
    const node = el({ formField: true, defaultValue: "from-server" });
    expect(readStringControlledZagProps(node, "value", "defaultValue")).toEqual({
      defaultValue: "from-server",
    });
  });

  it("returns defaultValue when form field without controlled", () => {
    const node = el({ formField: true, defaultValue: '["fra"]' });
    expect(readStringListControlledZagProps(node, "value", "defaultValue")).toEqual({
      defaultValue: ["fra"],
    });
  });
});

describe("readStringControlledZagUpdate", () => {
  it("returns value key when controlled", () => {
    const node = el({ controlled: true, value: "live" });
    expect(readStringControlledZagUpdate(node, "value", "defaultValue")).toEqual({
      value: "live",
    });
  });

  it("returns empty when form field without controlled", () => {
    const node = el({ formField: true, defaultValue: '["from-server"]' });
    expect(readStringControlledZagUpdate(node, "value", "defaultValue")).toEqual({});
  });

  it("returns empty when uncontrolled", () => {
    const node = el({ defaultValue: "init" });
    expect(readStringControlledZagUpdate(node, "value", "defaultValue")).toEqual({});
  });

  it("returns empty when form field data-value unchanged and controlled", () => {
    const node = el({ formField: true, controlled: true, value: "same" });
    expect(readUpdatedServerString(node, "same")).toEqual({});
  });

  it("returns value when form field data-value changes and controlled", () => {
    const node = el({ formField: true, controlled: true, value: "next" });
    expect(readUpdatedServerString(node, "prev")).toEqual({ value: "next" });
  });
});

describe("mountCheckedBinding", () => {
  it("returns checked when controlled", () => {
    const node = el({ controlled: true, checked: "true" });
    expect(mountCheckedBinding(node)).toEqual({ checked: true });
  });

  it("returns defaultChecked from data-default-checked when form field without controlled", () => {
    const node = el({ formField: true, defaultChecked: "false" });
    expect(mountCheckedBinding(node)).toEqual({ defaultChecked: false });
  });

  it("returns defaultChecked when uncontrolled", () => {
    const node = el({ defaultChecked: "true" });
    expect(mountCheckedBinding(node)).toEqual({ defaultChecked: true });
  });
});

describe("readCheckedControlledZagUpdate", () => {
  it("returns checked when controlled", () => {
    const node = el({ controlled: true, checked: "true" });
    expect(readCheckedControlledZagUpdate(node)).toEqual({ checked: true });
  });

  it("returns checked when form field with data-controlled", () => {
    const node = el({ formField: true, controlled: true, checked: "false" });
    expect(readCheckedControlledZagUpdate(node)).toEqual({ checked: false });
  });

  it("returns empty when uncontrolled", () => {
    const node = el({ defaultChecked: true });
    expect(readCheckedControlledZagUpdate(node)).toEqual({});
  });
});

describe("readNumberControlledZagProps", () => {
  it("returns value and step when controlled", () => {
    const node = el({ controlled: true, value: 5, step: 2 });
    expect(readNumberControlledZagProps(node)).toEqual({ value: "5", step: 2 });
  });

  it("returns defaultValue and step when uncontrolled", () => {
    const node = el({ defaultValue: 3, step: 1 });
    expect(readNumberControlledZagProps(node)).toEqual({ defaultValue: "3", step: 1 });
  });
});

describe("readBooleanControlledZagProps", () => {
  it("returns open when controlled", () => {
    const node = el({ controlled: true, open: true });
    expect(readBooleanControlledZagProps(node, "open", "defaultOpen")).toEqual({ open: true });
  });

  it("returns defaultOpen when uncontrolled", () => {
    const node = el({ defaultOpen: true });
    expect(readBooleanControlledZagProps(node, "open", "defaultOpen")).toEqual({
      defaultOpen: true,
    });
  });
});

describe("readStringListControlledZagProps", () => {
  it("returns value list when controlled", () => {
    const node = el({ controlled: true, value: "a, b" });
    expect(readStringListControlledZagProps(node, "value", "defaultValue")).toEqual({
      value: ["a", "b"],
    });
  });

  it("returns defaultValue list when form field without controlled", () => {
    const node = el({ formField: true, defaultValue: "a, b" });
    expect(readStringListControlledZagProps(node, "value", "defaultValue")).toEqual({
      defaultValue: ["a", "b"],
    });
  });
});

describe("readControlledOrDefaultStringList", () => {
  it("returns empty when unset", () => {
    expect(readControlledOrDefaultStringList(el({}), "value", "defaultValue")).toEqual([]);
  });
});

describe("readBooleanControlledZagUpdate", () => {
  it("returns open when controlled", () => {
    const node = el({ controlled: true, open: true });
    expect(readBooleanControlledZagUpdate(node, "open", "defaultOpen")).toEqual({ open: true });
  });

  it("returns empty when uncontrolled", () => {
    expect(
      readBooleanControlledZagUpdate(el({ defaultOpen: true }), "open", "defaultOpen")
    ).toEqual({});
  });
});

describe("readStringListControlledZagUpdate", () => {
  it("returns value when controlled", () => {
    const node = el({ controlled: true, value: "a, b" });
    expect(readStringListControlledZagUpdate(node, "value", "defaultValue")).toEqual({
      value: ["a", "b"],
    });
  });

  it("returns empty when form field without controlled", () => {
    const node = el({ formField: true, defaultValue: '["a","b"]' });
    expect(readStringListControlledZagUpdate(node, "value", "defaultValue")).toEqual({});
  });

  it("returns empty when uncontrolled", () => {
    expect(
      readStringListControlledZagUpdate(el({ defaultValue: "x,y" }), "value", "defaultValue")
    ).toEqual({});
  });

  it("returns value when controlled server value is present", () => {
    const node = el({ controlled: true, value: '["fra"]' });
    expect(readStringListControlledZagUpdate(node, "value", "defaultValue")).toEqual({
      value: ["fra"],
    });
  });

  it("returns empty when server value matches lastServerValue", () => {
    const node = el({ controlled: true, value: "fra" });
    expect(readStringListControlledZagUpdate(node, "value", "defaultValue", "fra")).toEqual({});
  });
});

describe("readNumberControlledZagUpdate", () => {
  it("returns value and step when controlled", () => {
    const node = el({ controlled: true, value: 5, step: 2 });
    expect(readNumberControlledZagUpdate(node)).toEqual({
      value: "5",
      step: 2,
      nextServerValue: "5",
    });
  });

  it("returns step only when form field without controlled", () => {
    const node = el({ formField: true, value: "7", step: 1 });
    expect(readNumberControlledZagUpdate(node)).toEqual({ step: 1 });
  });

  it("returns step only when uncontrolled", () => {
    const node = el({ defaultValue: 3, step: 1 });
    expect(readNumberControlledZagUpdate(node)).toEqual({ step: 1 });
  });
});

describe("readPressedControlledZagUpdate", () => {
  it("returns pressed when controlled", () => {
    const node = el({ controlled: true, pressed: "true" });
    expect(readPressedControlledZagUpdate(node)).toEqual({ pressed: true });
  });

  it("returns empty when uncontrolled", () => {
    expect(readPressedControlledZagUpdate(el({ defaultPressed: true }))).toEqual({});
  });
});

describe("readControlledOrDefaultBoolean", () => {
  it("reads open or defaultOpen", () => {
    expect(
      readControlledOrDefaultBoolean(el({ controlled: true, open: true }), "open", "defaultOpen")
    ).toBe(true);
    expect(readControlledOrDefaultBoolean(el({ defaultOpen: true }), "open", "defaultOpen")).toBe(
      true
    );
  });
});
