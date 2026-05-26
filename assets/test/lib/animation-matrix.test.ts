import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { mutableStrings } from "../helpers/matrix";
import {
  stripHiddenFromProps,
  isJsAnimation,
  isInOpenValueList,
  contentDatasetValue,
  pointerBlockDuringMs,
  clearOpenStyles,
  closestPartValue,
  readHeightAnimationOptions,
  readScaleAnimationOptions,
} from "../../lib/animation";

function animEl(extra: Record<string, string> = {}): HTMLElement {
  const node = document.createElement("div");
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

describe("stripHiddenFromProps matrix", () => {
  it.each([
    [
      { hidden: true, open: true, id: "a" },
      { open: true, id: "a" },
    ],
    [{}, {}],
    [{ hidden: false, id: "x" }, { id: "x" }],
    [
      { "aria-hidden": true, tabIndex: 0 },
      { "aria-hidden": true, tabIndex: 0 },
    ],
  ] as const)("%#", (input, expected) => {
    expect(stripHiddenFromProps(input)).toEqual(expected);
  });
});

describe("isJsAnimation matrix", () => {
  it.each([
    ["js", true],
    ["css", false],
    [undefined, false],
  ] as const)("%#", (animation, expected) => {
    const node = document.createElement("div");
    if (animation) node.dataset.animation = animation;
    expect(isJsAnimation(node)).toBe(expected);
  });
});

describe("isInOpenValueList matrix", () => {
  it.each([
    ["a", ["a", "b"], true],
    ["c", ["a", "b"], false],
    [undefined, ["a"], false],
    ["", ["a"], false],
    ["x", [], false],
  ] as const)("%#", (value, list, expected) => {
    expect(isInOpenValueList(value, mutableStrings(list))).toBe(expected);
  });
});

describe("contentDatasetValue matrix", () => {
  it.each([
    ["item-1", "item-1"],
    [undefined, undefined],
    ["", ""],
  ] as const)("%#", (value, expected) => {
    const node = document.createElement("div");
    if (value != null) node.dataset.value = value;
    expect(contentDatasetValue(node)).toBe(expected);
  });
});

describe("pointerBlockDuringMs matrix", () => {
  beforeEach(() => {
    vi.useFakeTimers();
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  it.each([
    [100, true, "none"],
    [100, false, ""],
    [0, true, ""],
  ] as const)("%#", (duration, enabled, afterCall) => {
    const root = document.createElement("div");
    pointerBlockDuringMs(root, duration, enabled);
    expect(root.style.pointerEvents).toBe(afterCall);
    if (enabled && duration > 0) {
      vi.advanceTimersByTime(duration);
      expect(root.style.pointerEvents).toBe("");
    }
  });
});

describe("clearOpenStyles matrix", () => {
  it.each([
    ["opacity", "0"],
    ["height", "0px"],
    ["overflow", "hidden"],
  ] as const)("%#", (prop, value) => {
    const node = document.createElement("div");
    node.style.setProperty(prop, value);
    clearOpenStyles(node);
    expect(node.style.getPropertyValue(prop)).toBe("");
  });
});

describe("closestPartValue matrix", () => {
  it.each([
    ["one", "one"],
    ["two", "two"],
  ] as const)("%#", (dataValue, expected) => {
    const root = document.createElement("div");
    root.innerHTML = `
      <div data-scope="accordion" data-part="item" data-value="${dataValue}">
        <div data-part="item-content">X</div>
      </div>
    `;
    const content = root.querySelector("[data-part=item-content]") as HTMLElement;
    const resolve = closestPartValue('[data-scope="accordion"][data-part="item"]');
    expect(resolve(content)).toBe(expected);
  });
});

describe("readHeightAnimationOptions matrix", () => {
  it.each([
    [{ "data-anim-height-block-interaction": "false" }, false],
    [{}, true],
  ] as const)("%#", (attrs, blockInteraction) => {
    const node = animEl(attrs);
    expect(readHeightAnimationOptions(node).blockInteraction).toBe(blockInteraction);
  });
});

describe("readScaleAnimationOptions matrix", () => {
  it.each([
    ["0.8", 0.8],
    ["1", 1],
  ] as const)("%#", (scaleStart, expected) => {
    const node = animEl();
    node.setAttribute("data-anim-transform-scale-start", scaleStart);
    expect(readScaleAnimationOptions(node).scaleStart).toBe(expected);
  });
});
