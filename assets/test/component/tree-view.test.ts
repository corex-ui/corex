import { describe, expect, it } from "vitest";
import { TreeView } from "../../components/tree-view";
import { sampleTreeRoot, treeViewTree } from "../helpers/component-smoke";

describe("TreeView", () => {
  it("replaceRootNode allows render without throwing", () => {
    const c = new TreeView(treeViewTree(), { id: "tv", rootNode: sampleTreeRoot });
    c.replaceRootNode({ value: "solo", name: "Solo" });
    expect(() => c.render()).not.toThrow();
  });

  it("render with branch DOM and data-path", () => {
    const el = treeViewTree();
    const branch = document.createElement("div");
    branch.dataset.scope = "tree-view";
    branch.dataset.part = "branch";
    branch.setAttribute("data-path", "0");
    el.querySelector('[data-part="tree"]')?.appendChild(branch);
    const c = new TreeView(el, { id: "tv", rootNode: sampleTreeRoot });
    expect(() => c.render()).not.toThrow();
    c.destroy();
  });
});
