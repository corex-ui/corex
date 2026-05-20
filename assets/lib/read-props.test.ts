import { describe, expect, it } from "vitest";
import { el } from "../test/helpers/dom";
import {
  readBooleanControlledZagProps,
  readControlledOrDefaultBoolean,
  readControlledOrDefaultStringList,
  readNumberControlledZagProps,
  readStringControlledZagProps,
  readStringControlledZagUpdate,
  readStringListControlledZagProps,
} from "./read-props";

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
});

describe("readStringControlledZagUpdate", () => {
  it("returns value key when controlled", () => {
    const node = el({ controlled: true, value: "live" });
    expect(readStringControlledZagUpdate(node, "value", "defaultValue")).toEqual({
      value: "live",
    });
  });

  it("returns defaultValue key when uncontrolled", () => {
    const node = el({ defaultValue: "init" });
    expect(readStringControlledZagUpdate(node, "value", "defaultValue")).toEqual({
      defaultValue: "init",
    });
  });
});

describe("readNumberControlledZagProps", () => {
  it("returns value and step when controlled", () => {
    const node = el({ controlled: true, value: 5, step: 2 });
    expect(readNumberControlledZagProps(node)).toEqual({ value: 5, step: 2 });
  });

  it("returns defaultValue and step when uncontrolled", () => {
    const node = el({ defaultValue: 3, step: 1 });
    expect(readNumberControlledZagProps(node)).toEqual({ defaultValue: 3, step: 1 });
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
});

describe("readControlledOrDefaultStringList", () => {
  it("returns empty when unset", () => {
    expect(readControlledOrDefaultStringList(el({}), "value", "defaultValue")).toEqual([]);
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
