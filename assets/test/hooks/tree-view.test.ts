import { describe, expect, it, vi } from "vitest";
import { el } from "../helpers/dom";
import { parseRootNode, readExpandedAttr, readSelectedAttr } from "../../hooks/tree-view";

describe("parseRootNode", () => {
  it("parses data-tree JSON", () => {
    const node = document.createElement("div");
    node.dataset.tree = JSON.stringify({ value: "root", name: "Root" });
    expect(parseRootNode(node)).toEqual({ value: "root", name: "Root" });
  });

  it("returns empty tree when data-tree missing", () => {
    const errorSpy = vi.spyOn(console, "error").mockImplementation(() => {});
    expect(parseRootNode(document.createElement("div"))).toEqual({
      value: "",
      name: "",
      children: [],
    });
    errorSpy.mockRestore();
  });
});

describe("readExpandedAttr", () => {
  it("reads default expanded value attribute", () => {
    const node = el({});
    node.setAttribute("data-default-expanded-value", "a,b");
    expect(readExpandedAttr(node)).toBe("a,b");
  });

  it("returns empty when unset", () => {
    expect(readExpandedAttr(el({}))).toBe("");
  });
});

describe("readSelectedAttr", () => {
  it("reads default selected value attribute", () => {
    const node = el({});
    node.setAttribute("data-default-selected-value", "item-1");
    expect(readSelectedAttr(node)).toBe("item-1");
  });
});
