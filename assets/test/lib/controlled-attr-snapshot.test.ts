import { describe, expect, it } from "vitest";
import { el } from "../helpers/dom";
import {
  anyDatasetKeyChanged,
  datasetKeyChanged,
  snapshotDataset,
} from "../../lib/controlled-attr-snapshot";

describe("snapshotDataset", () => {
  it("captures listed dataset keys", () => {
    const node = el({ checked: "true", value: "a", disabled: true });
    expect(snapshotDataset(node, ["checked", "value"])).toEqual({
      checked: "true",
      value: "a",
    });
  });
});

describe("datasetKeyChanged", () => {
  it("treats missing before snapshot as changed", () => {
    const node = el({ value: "a" });
    expect(datasetKeyChanged(undefined, node, "value")).toBe(true);
  });

  it("detects unchanged and changed keys", () => {
    const node = el({ value: "next" });
    expect(datasetKeyChanged({ value: "next" }, node, "value")).toBe(false);
    expect(datasetKeyChanged({ value: "prev" }, node, "value")).toBe(true);
  });
});

describe("anyDatasetKeyChanged", () => {
  it("is true when any listed key differs", () => {
    const node = el({ value: "1", defaultValue: "2" });
    expect(
      anyDatasetKeyChanged({ value: "1", defaultValue: "2" }, node, ["value", "defaultValue"])
    ).toBe(false);
    expect(
      anyDatasetKeyChanged({ value: "0", defaultValue: "2" }, node, ["value", "defaultValue"])
    ).toBe(true);
  });
});
