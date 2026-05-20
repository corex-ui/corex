import { describe, expect, it } from "vitest";
import { el } from "../helpers/dom";
import { parseRootNode, readExpandedAttr, readSelectedAttr } from "../../hooks/tree-view";

describe("parseRootNode", () => {
  it("parses data-tree JSON", () => {
    const node = document.createElement("div");
    node.dataset.tree = JSON.stringify({ value: "root", name: "Root" });
    expect(parseRootNode(node)).toEqual({ value: "root", name: "Root" });
  });

  it("throws when data-tree missing", () => {
    expect(() => parseRootNode(document.createElement("div"))).toThrow(/missing data-tree/);
  });
});

describe("readExpandedAttr", () => {
  it("reads controlled expanded value attribute", () => {
    const node = el({ controlled: true });
    node.setAttribute("data-expanded-value", "a,b");
    expect(readExpandedAttr(node)).toBe("a,b");
  });

  it("reads default expanded when uncontrolled", () => {
    const node = el({});
    node.setAttribute("data-default-expanded-value", "x");
    expect(readExpandedAttr(node)).toBe("x");
  });
});

describe("readSelectedAttr", () => {
  it("reads controlled selected value attribute", () => {
    const node = el({ controlled: true });
    node.setAttribute("data-selected-value", "item-1");
    expect(readSelectedAttr(node)).toBe("item-1");
  });
});
