import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import {
  clearOpenStyles,
  closestPartValue,
  contentDatasetValue,
  isInOpenValueList,
  isJsAnimation,
  pointerBlockDuringMs,
  prepareInitialHeightState,
  prepareInitialScaleState,
  readHeightAnimationOptions,
  readScaleAnimationOptions,
  runHeightOpenToValues,
  runHeightOpenTransition,
  stripHiddenFromProps,
} from "./animation";

function animEl(extra: Record<string, string> = {}): HTMLElement {
  const node = document.createElement("div");
  node.id = "anim-root";
  node.setAttribute("data-anim-height-duration", "300");
  node.setAttribute("data-anim-height-easing", "ease");
  node.setAttribute("data-anim-height-opacity-start", "0");
  node.setAttribute("data-anim-height-opacity-end", "1");
  node.setAttribute("data-anim-scale-duration", "200");
  node.setAttribute("data-anim-scale-easing", "ease-out");
  node.setAttribute("data-anim-scale-opacity-start", "0");
  node.setAttribute("data-anim-scale-opacity-end", "1");
  node.setAttribute("data-anim-transform-scale-start", "0.9");
  node.setAttribute("data-anim-transform-scale-end", "1");
  for (const [k, v] of Object.entries(extra)) {
    node.setAttribute(k, v);
  }
  return node;
}

describe("readHeightAnimationOptions", () => {
  it("reads required animation attributes", () => {
    const opts = readHeightAnimationOptions(animEl());
    expect(opts.duration).toBe(300);
    expect(opts.easing).toBe("ease");
    expect(opts.blockInteraction).toBe(true);
  });

  it("respects animHeightBlockInteraction=false", () => {
    const node = animEl();
    node.dataset.animHeightBlockInteraction = "false";
    expect(readHeightAnimationOptions(node).blockInteraction).toBe(false);
  });
});

describe("readScaleAnimationOptions", () => {
  it("reads scale animation attributes", () => {
    const opts = readScaleAnimationOptions(animEl());
    expect(opts.duration).toBe(200);
    expect(opts.scaleStart).toBe(0.9);
    expect(opts.scaleEnd).toBe(1);
  });
});

describe("stripHiddenFromProps", () => {
  it("removes hidden key", () => {
    expect(stripHiddenFromProps({ hidden: true, id: "x" })).toEqual({ id: "x" });
  });
});

describe("isJsAnimation", () => {
  it("detects js animation", () => {
    const node = document.createElement("div");
    node.dataset.animation = "js";
    expect(isJsAnimation(node)).toBe(true);
    expect(isJsAnimation(document.createElement("div"))).toBe(false);
  });
});

describe("isInOpenValueList", () => {
  it("checks membership", () => {
    expect(isInOpenValueList("a", ["a", "b"])).toBe(true);
    expect(isInOpenValueList(undefined, ["a"])).toBe(false);
    expect(isInOpenValueList("c", ["a", "b"])).toBe(false);
  });
});

describe("contentDatasetValue", () => {
  it("returns dataset value", () => {
    const el = document.createElement("div");
    el.dataset.value = "item-1";
    expect(contentDatasetValue(el)).toBe("item-1");
  });
});

describe("closestPartValue", () => {
  it("resolves value from closest item", () => {
    const root = document.createElement("div");
    root.innerHTML = `
      <div data-scope="accordion" data-part="item" data-value="one">
        <div data-part="item-content">X</div>
      </div>
    `;
    const content = root.querySelector("[data-part=item-content]")!;
    const resolve = closestPartValue('[data-scope="accordion"][data-part="item"]');
    expect(resolve(content as HTMLElement)).toBe("one");
  });
});

describe("clearOpenStyles", () => {
  it("clears inline styles", () => {
    const el = document.createElement("div");
    el.style.opacity = "0";
    el.style.height = "0px";
    el.style.overflow = "hidden";
    el.style.transform = "scale(0.9)";
    clearOpenStyles(el);
    expect(el.style.opacity).toBe("");
    expect(el.style.height).toBe("");
    expect(el.style.overflow).toBe("");
    expect(el.style.transform).toBe("");
  });
});

describe("prepareInitialHeightState", () => {
  it("applies closed styles when not open", () => {
    const root = animEl();
    const panel = document.createElement("div");
    panel.dataset.state = "closed";
    root.appendChild(panel);
    prepareInitialHeightState(root, "div", readHeightAnimationOptions(root));
    expect(panel.style.height).toBe("0px");
    expect(panel.style.opacity).toBe("0");
  });

  it("clears styles when open", () => {
    const root = animEl();
    const panel = document.createElement("div");
    panel.dataset.state = "open";
    panel.style.height = "0px";
    root.appendChild(panel);
    prepareInitialHeightState(root, "div", readHeightAnimationOptions(root));
    expect(panel.style.height).toBe("");
  });
});

describe("prepareInitialScaleState", () => {
  it("applies scale closed styles for backdrop", () => {
    const root = animEl();
    const backdrop = document.createElement("div");
    backdrop.dataset.part = "backdrop";
    backdrop.dataset.state = "closed";
    root.appendChild(backdrop);
    prepareInitialScaleState(root, "div", readScaleAnimationOptions(root));
    expect(backdrop.style.opacity).toBe("0");
    expect(backdrop.style.transform).toBe("");
  });
});

describe("pointerBlockDuringMs", () => {
  beforeEach(() => {
    vi.useFakeTimers();
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  it("blocks pointer events then restores", () => {
    const root = document.createElement("div");
    pointerBlockDuringMs(root, 100, true);
    expect(root.style.pointerEvents).toBe("none");
    vi.advanceTimersByTime(100);
    expect(root.style.pointerEvents).toBe("");
  });

  it("no-ops when disabled or zero duration", () => {
    const root = document.createElement("div");
    pointerBlockDuringMs(root, 100, false);
    expect(root.style.pointerEvents).toBe("");
    pointerBlockDuringMs(root, 0, true);
    expect(root.style.pointerEvents).toBe("");
  });
});

describe("runHeightOpenToValues", () => {
  it("no-ops when animation is not js", () => {
    const root = animEl();
    const panel = document.createElement("div");
    panel.dataset.value = "a";
    root.appendChild(panel);
    expect(() =>
      runHeightOpenToValues({
        el: root,
        selector: "div",
        openValues: ["a"],
        resolveValue: contentDatasetValue,
      })
    ).not.toThrow();
  });
});

describe("runHeightOpenTransition", () => {
  it("no-ops when animation is not js", () => {
    const root = animEl();
    expect(() =>
      runHeightOpenTransition({
        el: root,
        selector: "div",
        prevOpen: [],
        nextOpen: ["a"],
        resolveValue: contentDatasetValue,
      })
    ).not.toThrow();
  });

  it("opens when data-state is already open but prevOpen was empty", () => {
    const root = animEl();
    root.dataset.animation = "js";
    const panel = document.createElement("div");
    panel.dataset.value = "a";
    panel.dataset.state = "open";
    panel.style.height = "0px";
    panel.style.opacity = "0";
    panel.style.overflow = "hidden";
    root.appendChild(panel);

    const mockAnimation = {
      onfinish: null,
      oncancel: null,
      cancel: vi.fn(),
    } as unknown as Animation;

    const animate = vi.fn(() => mockAnimation);
    panel.animate = animate as unknown as typeof panel.animate;
    panel.getAnimations = vi.fn(() => []) as unknown as typeof panel.getAnimations;

    runHeightOpenTransition({
      el: root,
      selector: "div",
      prevOpen: [],
      nextOpen: ["a"],
      resolveValue: contentDatasetValue,
    });

    expect(animate).toHaveBeenCalled();
  });
});
