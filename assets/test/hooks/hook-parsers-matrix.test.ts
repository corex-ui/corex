import { describe, expect, it } from "vitest";
import { el } from "../helpers/dom";
import { hasKey } from "../helpers/matrix";
import { parseSize, parsePoint } from "../../hooks/floating-panel";
import { parsePathsFromDataset, buildDrawingOptions } from "../../hooks/signature-pad";
import { readExpandedAttr, readSelectedAttr, parseRootNode } from "../../hooks/tree-view";
import {
  comboboxValueBinding,
  selectedItemLabel,
  syncVisibleInputAttribute,
} from "../../hooks/combobox";
import { readCorexPage, readInstant } from "../../hooks/carousel";
import { parseSingleExecJsEffect, parseActionSpec } from "../../hooks/toast";
import { parseTimerTranslations } from "../../hooks/timer";

describe("parseSize matrix", () => {
  it.each([
    [undefined, undefined],
    ["", undefined],
    ['{"width":1,"height":2}', { width: 1, height: 2 }],
    ['{"width":"a","height":1}', undefined],
    ["not-json", undefined],
    ['{"width":0,"height":0}', { width: 0, height: 0 }],
  ] as const)("%#", (input, expected) => {
    expect(parseSize(input)).toEqual(expected);
  });
});

describe("parsePoint matrix", () => {
  it.each([
    [undefined, undefined],
    ['{"x":0,"y":0}', { x: 0, y: 0 }],
    ['{"x":1}', undefined],
    ["{}", undefined],
  ] as const)("%#", (input, expected) => {
    expect(parsePoint(input)).toEqual(expected);
  });
});

describe("parsePathsFromDataset matrix", () => {
  it.each([
    ["defaultPaths", "", []],
    ["paths", "M0 0\n\nM1 1", ["M0 0", "M1 1"]],
    ["defaultPaths", "  a  \n  ", ["a"]],
  ] as const)("%#", (key, raw, expected) => {
    const node = document.createElement("div");
    node.dataset[key] = raw;
    expect(parsePathsFromDataset(node, key)).toEqual(expected);
  });
});

describe("buildDrawingOptions matrix", () => {
  it.each([
    [{ drawingFill: "red", drawingSize: 2 }, "red", 2],
    [{}, undefined, undefined],
    [{ drawingSimulatePressure: true, drawingSmoothing: 0.5 }, undefined, undefined],
  ] as const)("%#", (dataset, fill, size) => {
    const opts = buildDrawingOptions(el(dataset as Record<string, string | number | boolean>));
    if (fill != null) expect(opts.fill).toBe(fill);
    if (size != null) expect(opts.size).toBe(size);
    if (hasKey(dataset, "drawingSimulatePressure") && dataset.drawingSimulatePressure) {
      expect(opts.simulatePressure).toBe(true);
    }
  });
});

describe("tree-view attr readers matrix", () => {
  it.each([
    [{ controlled: true, expandedValue: "a,b" }, "expanded-value", "a,b"],
    [{ defaultExpandedValue: "x" }, "expanded-value", "x"],
    [{ controlled: true }, "expanded-value", ""],
  ] as const)("readExpandedAttr %#", (attrs, attrName, expected) => {
    const node = document.createElement("div");
    if (hasKey(attrs, "controlled") && attrs.controlled) node.dataset.controlled = "true";
    if ("expandedValue" in attrs && typeof attrs.expandedValue === "string")
      node.setAttribute(`data-${attrName}`, attrs.expandedValue);
    if ("defaultExpandedValue" in attrs && typeof attrs.defaultExpandedValue === "string")
      node.setAttribute("data-default-expanded-value", attrs.defaultExpandedValue);
    expect(readExpandedAttr(node)).toBe(expected);
  });

  it.each([
    [{ controlled: true, selectedValue: "id-1" }, "id-1"],
    [{ defaultSelectedValue: "id-2" }, "id-2"],
    [{}, ""],
  ] as const)("readSelectedAttr %#", (attrs, expected) => {
    const node = document.createElement("div");
    if (hasKey(attrs, "controlled") && attrs.controlled) node.dataset.controlled = "true";
    if ("selectedValue" in attrs && typeof attrs.selectedValue === "string")
      node.setAttribute("data-selected-value", attrs.selectedValue);
    if ("defaultSelectedValue" in attrs && typeof attrs.defaultSelectedValue === "string")
      node.setAttribute("data-default-selected-value", attrs.defaultSelectedValue);
    expect(readSelectedAttr(node)).toBe(expected);
  });
});

describe("parseRootNode matrix", () => {
  it("parses valid tree JSON", () => {
    const node = el({ tree: '{"id":"r","name":"Root","children":[]}' });
    expect(parseRootNode(node).name).toBe("Root");
  });

  it.each([{}, { tree: "" }] as const)("throws when tree missing %#", (dataset) => {
    const node = el(dataset as Record<string, string>);
    expect(() => parseRootNode(node)).toThrow(/missing data-tree/);
  });
});

describe("combobox helpers matrix", () => {
  it.each([
    [[], ""],
    [[{ label: "One" }], "One"],
    [[{ label: 42 }], "42"],
    [[{ value: "x" }], ""],
    [[{ label: "A" }, { label: "B" }], "A"],
  ] as const)("selectedItemLabel %#", (items, label) => {
    expect(selectedItemLabel(items)).toBe(label);
  });

  it("syncVisibleInputAttribute sets value on input", () => {
    const root = document.createElement("div");
    root.innerHTML = '<input data-scope="combobox" data-part="input" />';
    syncVisibleInputAttribute(root, "hello");
    expect(root.querySelector("input")?.getAttribute("value")).toBe("hello");
  });

  it.each([
    [{ controlled: true, value: "a,b,c" }, "value", 3],
    [{ defaultValue: "x" }, "defaultValue", 1],
  ] as const)("comboboxValueBinding lengths %#", (dataset, key, len) => {
    const binding = comboboxValueBinding(el(dataset as Record<string, string | boolean>));
    expect((binding as Record<string, string[]>)[key]).toHaveLength(len);
  });
});

describe("carousel parsers matrix", () => {
  it.each([
    [{ page: 1 }, "page", 0],
    [{ defaultPage: 3 }, "defaultPage", 2],
    [{ page: 0 }, "page", 0],
    [{}, "page", undefined],
  ] as const)("readCorexPage %#", (dataset, attr, zag) => {
    expect(readCorexPage(el(dataset as Record<string, number>), attr)).toBe(zag);
  });

  it.each([
    [{ instant: true }, true],
    [{ instant: "true" }, true],
    [{ instant: false }, false],
    [{}, false],
    [null, false],
    ["x", false],
  ] as const)("readInstant %#", (detail, expected) => {
    expect(readInstant(detail)).toBe(expected);
  });
});

describe("toast action parsers matrix", () => {
  it.each([
    [{ kind: "exec_js", encoded: "js()" }, "js()"],
    [{ kind: "other" }, null],
    [{ kind: "exec_js", encoded: "" }, null],
    [null, null],
  ] as const)("parseSingleExecJsEffect %#", (raw, expected) => {
    expect(parseSingleExecJsEffect(raw)).toBe(expected);
  });

  it.each([
    [{ label: "Undo", effects: [{ kind: "exec_js", encoded: "x()" }] }, "Undo"],
    [{ label: "", effects: [] }, null],
    [{ label: "Ok", effects: [] }, null],
    [
      {
        label: "Ok",
        effects: [
          { kind: "exec_js", encoded: "a()" },
          { kind: "exec_js", encoded: "b()" },
        ],
      },
      null,
    ],
    [{ label: "Styled", effects: [{ kind: "exec_js", encoded: "z()" }], class: " btn " }, "Styled"],
  ] as const)("parseActionSpec %#", (raw, label) => {
    const spec = parseActionSpec(raw);
    if (label == null) expect(spec).toBeNull();
    else {
      expect(spec?.label).toBe(label);
      expect(spec?.encoded).toBeTruthy();
    }
  });
});

describe("parseTimerTranslations matrix", () => {
  it.each([
    [undefined, false],
    ['{"areaLabel":"Timer"}', true],
    ['{"areaLabel":""}', false],
    ["not-json", false],
    ['{"other":1}', false],
  ] as const)("%#", (raw, hasLabel) => {
    const node = document.createElement("div");
    if (raw != null) node.dataset.translation = raw;
    const t = parseTimerTranslations(node);
    if (hasLabel) {
      const areaLabel = t?.areaLabel as (() => string) | undefined;
      expect(areaLabel?.()).toBe("Timer");
    } else expect(t).toBeUndefined();
  });
});
