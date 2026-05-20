import { describe, expect, it, vi } from "vitest";
import {
  animateHeightClose,
  animateHeightOpen,
  animateScaleClose,
  animateScaleOpen,
  applyClosedHeight,
  applyClosedScale,
  applyOpenHeight,
  applyOpenScale,
  findAccordionContent,
  findDialogBackdrop,
  findDialogContent,
  findTreeBranch,
} from "./custom-animation";

describe("find* helpers", () => {
  it("finds accordion item content by value", () => {
    const root = document.createElement("div");
    root.innerHTML = `
      <div data-scope="accordion" data-part="item" data-value="one">
        <div data-part="item-content">Content</div>
      </div>
    `;
    const content = findAccordionContent(root, "one");
    expect(content?.textContent).toBe("Content");
  });

  it("finds tree branch content by value", () => {
    const root = document.createElement("div");
    root.innerHTML = `
      <div data-scope="tree-view" data-part="branch-content" data-value="node-a">Branch</div>
    `;
    expect(findTreeBranch(root, "node-a")?.textContent).toBe("Branch");
  });

  it("finds dialog backdrop and content", () => {
    const root = document.createElement("div");
    root.innerHTML = `
      <div data-scope="dialog" data-part="backdrop"></div>
      <div data-scope="dialog" data-part="content">Body</div>
    `;
    expect(findDialogBackdrop(root)).not.toBeNull();
    expect(findDialogContent(root)?.textContent).toBe("Body");
  });
});

describe("applyClosedHeight / applyOpenHeight", () => {
  it("sets and clears closed height styles", () => {
    const el = document.createElement("div");
    applyClosedHeight(el);
    expect(el.style.height).toBe("0px");
    expect(el.style.opacity).toBe("0");
    applyOpenHeight(el);
    expect(el.style.height).toBe("");
    expect(el.style.opacity).toBe("");
  });
});

describe("applyClosedScale / applyOpenScale", () => {
  it("applies scale on content not backdrop", () => {
    const content = document.createElement("div");
    content.dataset.part = "content";
    applyClosedScale(content, { scaleStart: 0.5, opacityStart: 0 });
    expect(content.style.transform).toBe("scale(0.5)");
    applyOpenScale(content);
    expect(content.style.transform).toBe("");
  });

  it("skips transform on backdrop", () => {
    const backdrop = document.createElement("div");
    backdrop.dataset.part = "backdrop";
    applyClosedScale(backdrop);
    expect(backdrop.style.transform).toBe("");
  });
});

describe("animateHeightOpen / animateHeightClose", () => {
  const stubAnimator = () => ({
    finished: Promise.resolve(),
  });

  it("opens with animator keyframes", async () => {
    const el = document.createElement("div");
    Object.defineProperty(el, "scrollHeight", { value: 100, configurable: true });
    const animator = vi.fn(stubAnimator);
    await animateHeightOpen(el, { animator, duration: 0.1 });
    expect(animator).toHaveBeenCalled();
    expect(el.style.height).toBe("");
  });

  it("closes with animator keyframes", async () => {
    const el = document.createElement("div");
    Object.defineProperty(el, "scrollHeight", { value: 80, configurable: true });
    const animator = vi.fn(stubAnimator);
    await animateHeightClose(el, { animator, duration: 0.1 });
    expect(animator).toHaveBeenCalled();
    expect(el.style.height).toBe("0px");
  });
});

describe("animateScaleOpen / animateScaleClose", () => {
  const stubAnimator = () => ({
    finished: Promise.resolve(),
  });

  it("opens scale on content", async () => {
    const el = document.createElement("div");
    el.dataset.part = "content";
    const animator = vi.fn(stubAnimator);
    await animateScaleOpen(el, { animator, duration: 0.1 });
    expect(animator).toHaveBeenCalled();
    expect(el.style.opacity).toBe("");
  });

  it("closes scale on content", async () => {
    const el = document.createElement("div");
    el.dataset.part = "content";
    const animator = vi.fn(stubAnimator);
    await animateScaleClose(el, { animator, duration: 0.1 });
    expect(animator).toHaveBeenCalled();
    expect(el.style.opacity).toBe("0");
  });
});
