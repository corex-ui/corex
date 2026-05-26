import { describe, expect, it } from "vitest";
import { el } from "../helpers/dom";
import {
  readBooleanControlledZagProps,
  readControlledOrDefaultBoolean,
  readControlledOrDefaultStringList,
  readNumberControlledZagProps,
  readStringControlledZagProps,
  readStringListControlledZagProps,
} from "../../lib/read-props";

describe("readStringControlledZagProps extended", () => {
  it.each([
    [{ controlled: true, value: "" }, { value: "" }],
    [{ defaultValue: "" }, { defaultValue: "" }],
  ] as const)("%#", (dataset, expected) => {
    expect(readStringControlledZagProps(el(dataset), "value", "defaultValue")).toEqual(expected);
  });
});

describe("readNumberControlledZagProps extended", () => {
  it.each([
    [
      { controlled: true, value: 0 },
      { value: "0", step: 1 },
    ],
    [
      { defaultValue: 0, step: 2 },
      { defaultValue: "0", step: 2 },
    ],
    [{}, { defaultValue: undefined, step: 1 }],
  ] as const)("%#", (dataset, expected) => {
    expect(readNumberControlledZagProps(el(dataset as Record<string, number>))).toEqual(expected);
  });
});

describe("readBooleanControlledZagProps extended", () => {
  it.each([
    [{ controlled: true, open: false }, { open: false }],
    [{ defaultOpen: false }, { defaultOpen: false }],
  ] as const)("%#", (dataset, expected) => {
    expect(readBooleanControlledZagProps(el(dataset), "open", "defaultOpen")).toEqual(expected);
  });
});

describe("readStringListControlledZagProps extended", () => {
  it.each([
    [{ controlled: true, value: "" }, { value: [] }],
    [{ defaultValue: " solo " }, { defaultValue: ["solo"] }],
    [{ controlled: true, value: "a, b , c" }, { value: ["a", "b", "c"] }],
  ] as const)("%#", (dataset, expected) => {
    expect(
      readStringListControlledZagProps(
        el(dataset as Record<string, string>),
        "value",
        "defaultValue"
      )
    ).toEqual(expected);
  });
});

describe("readControlledOrDefaultBoolean extended", () => {
  it.each([
    [{ controlled: true, open: false }, false],
    [{ defaultOpen: false }, false],
    [{ controlled: true, open: true }, true],
  ] as const)("%#", (dataset, expected) => {
    expect(readControlledOrDefaultBoolean(el(dataset), "open", "defaultOpen")).toBe(expected);
  });
});

describe("readControlledOrDefaultStringList extended", () => {
  it.each([
    [{ defaultValue: "x,y,z" }, ["x", "y", "z"]],
    [{ controlled: true, value: "only" }, ["only"]],
  ] as const)("%#", (dataset, expected) => {
    expect(
      readControlledOrDefaultStringList(
        el(dataset as Record<string, string>),
        "value",
        "defaultValue"
      )
    ).toEqual(expected);
  });
});
