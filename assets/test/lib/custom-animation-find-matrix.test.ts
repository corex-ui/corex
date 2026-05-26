import { describe, expect, it } from "vitest";
import {
  findAccordionContent,
  findTreeBranch,
  findDialogBackdrop,
  findDialogContent,
  applyClosedHeight,
  applyOpenHeight,
} from "../../lib/custom-animation";

describe("findAccordionContent matrix", () => {
  it.each(["a", "b", "missing"] as const)("%#", (value) => {
    const root = document.createElement("div");
    root.innerHTML = `
      <div data-scope="accordion" data-part="item" data-value="a">
        <div data-part="item-content">A</div>
      </div>
      <div data-scope="accordion" data-part="item" data-value="b">
        <div data-part="item-content">B</div>
      </div>
    `;
    const el = findAccordionContent(root, value);
    if (value === "missing") expect(el).toBeNull();
    else expect(el?.textContent).toBe(value.toUpperCase());
  });
});

describe("findTreeBranch matrix", () => {
  it.each(["node-1", "node-2", "none"] as const)("%#", (value) => {
    const root = document.createElement("div");
    root.innerHTML = `
      <div data-scope="tree-view" data-part="branch-content" data-value="node-1">N1</div>
      <div data-scope="tree-view" data-part="branch-content" data-value="node-2">N2</div>
    `;
    const el = findTreeBranch(root, value);
    if (value === "none") expect(el).toBeNull();
    else expect(el?.textContent).toContain("N");
  });
});

describe("findDialog parts matrix", () => {
  it("finds backdrop and content", () => {
    const root = document.createElement("div");
    root.innerHTML = `
      <div data-scope="dialog" data-part="backdrop"></div>
      <div data-scope="dialog" data-part="content">Body</div>
    `;
    expect(findDialogBackdrop(root)).not.toBeNull();
    expect(findDialogContent(root)?.textContent).toBe("Body");
  });

  it("returns null when parts missing", () => {
    const root = document.createElement("div");
    expect(findDialogBackdrop(root)).toBeNull();
    expect(findDialogContent(root)).toBeNull();
  });
});

describe("applyClosedHeight / applyOpenHeight matrix", () => {
  it.each([
    ["closed", "0px"],
    ["open", ""],
  ] as const)("%#", (mode, heightExpect) => {
    const el = document.createElement("div");
    if (mode === "closed") applyClosedHeight(el);
    else applyOpenHeight(el);
    if (heightExpect === "0px") expect(el.style.height).toBe("0px");
    else expect(el.style.height).toBe("");
  });
});
