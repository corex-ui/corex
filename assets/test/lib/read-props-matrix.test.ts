import { describe, expect, it } from "vitest";
import { el } from "../helpers/dom";
import {
  readBooleanControlledZagProps,
  readControlledOrDefaultBoolean,
  readControlledOrDefaultStringList,
  readNumberControlledZagProps,
  readStringControlledZagProps,
  readStringControlledZagUpdate,
  readStringListControlledZagProps,
} from "../../lib/read-props";

describe.each([
  [true, { controlled: true, value: "x" }, { value: "x" }],
  [false, { defaultValue: "y" }, { defaultValue: "y" }],
] as const)("readStringControlledZagProps controlled=%s", (controlled, dataset, expected) => {
  it("returns binding", () => {
    const node = el({ controlled, ...(dataset as Record<string, string>) });
    expect(readStringControlledZagProps(node, "value", "defaultValue")).toEqual(expected);
  });
});

describe.each([
  [true, { controlled: true, value: "live" }, { value: "live" }],
  [false, { defaultValue: "init" }, { defaultValue: "init" }],
] as const)("readStringControlledZagUpdate controlled=%s", (controlled, dataset, expected) => {
  it("returns update binding", () => {
    const node = el({ controlled, ...(dataset as Record<string, string>) });
    expect(readStringControlledZagUpdate(node, "value", "defaultValue")).toEqual(expected);
  });
});

describe.each([
  ["controlled", { controlled: true, value: 5, step: 2 }, { value: 5, step: 2 }],
  ["default", { defaultValue: 3, step: 1 }, { defaultValue: 3, step: 1 }],
] as const)("readNumberControlledZagProps %s", (_label, dataset, expected) => {
  it("reads numbers", () => {
    expect(readNumberControlledZagProps(el(dataset as Record<string, string | number>))).toEqual(
      expected
    );
  });
});

describe.each([
  ["controlled", { controlled: true, open: true }, { open: true }],
  ["default", { defaultOpen: true }, { defaultOpen: true }],
] as const)("readBooleanControlledZagProps %s", (_label, dataset, expected) => {
  it("reads open state", () => {
    expect(
      readBooleanControlledZagProps(el(dataset as Record<string, boolean>), "open", "defaultOpen")
    ).toEqual(expected);
  });
});

describe.each([
  ["controlled", { controlled: true, value: "a, b" }, { value: ["a", "b"] }],
  ["default", { defaultValue: "x,y" }, { defaultValue: ["x", "y"] }],
] as const)("readStringListControlledZagProps %s", (_label, dataset, expected) => {
  it("reads lists", () => {
    expect(
      readStringListControlledZagProps(
        el(dataset as Record<string, string>),
        "value",
        "defaultValue"
      )
    ).toEqual(expected);
  });
});

describe.each([
  ["controlled open", { controlled: true, open: true }, true],
  ["default open", { defaultOpen: true }, true],
  ["unset", {}, false],
] as const)("readControlledOrDefaultBoolean %s", (_label, dataset, expected) => {
  it("reads boolean", () => {
    expect(
      readControlledOrDefaultBoolean(el(dataset as Record<string, boolean>), "open", "defaultOpen")
    ).toBe(expected);
  });
});

describe.each([
  ["empty", {}, []],
  ["controlled", { controlled: true, value: "one,two" }, ["one", "two"]],
] as const)("readControlledOrDefaultStringList %s", (_label, dataset, expected) => {
  it("reads string list", () => {
    expect(
      readControlledOrDefaultStringList(
        el(dataset as Record<string, string>),
        "value",
        "defaultValue"
      )
    ).toEqual(expected);
  });
});
