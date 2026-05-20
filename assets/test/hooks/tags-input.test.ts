import { describe, expect, it } from "vitest";
import { el } from "../helpers/dom";
import { blurBehavior, maxProp, parseJsonTags } from "../../hooks/tags-input";

describe("parseJsonTags", () => {
  it("parses JSON string array", () => {
    const node = document.createElement("div");
    node.dataset.tags = '["a","b"]';
    expect(parseJsonTags(node, "tags")).toEqual(["a", "b"]);
  });

  it("returns empty for invalid JSON", () => {
    const node = document.createElement("div");
    node.dataset.tags = "not-json";
    expect(parseJsonTags(node, "tags")).toEqual([]);
  });
});

describe("blurBehavior", () => {
  it("reads allowed values", () => {
    expect(blurBehavior(el({ blurBehavior: "add" }))).toBe("add");
  });
});

describe("maxProp", () => {
  it("returns undefined for invalid max", () => {
    expect(maxProp(el({ max: 0 }))).toBeUndefined();
    expect(maxProp(el({ max: -1 }))).toBeUndefined();
  });

  it("returns positive max", () => {
    expect(maxProp(el({ max: 5 }))).toBe(5);
  });
});
