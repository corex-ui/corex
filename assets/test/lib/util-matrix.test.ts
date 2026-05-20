import { afterEach, describe, expect, it } from "vitest";
import { el } from "../helpers/dom";
import {
  canPushEvent,
  generateId,
  getBoolean,
  getBooleanValue,
  getCheckedState,
  getDir,
  getNumber,
  getString,
  getStringList,
  templatesContentRoot,
} from "../../lib/util";

const booleanTruthy = [
  ["empty attr", { readonly: true }, true],
  ["true string", { readonly: "true" }, true],
  ["false string", { readonly: "false" }, false],
  ["zero string", { readonly: "0" }, false],
  ["absent", {}, false],
  ["readonly attr", { readonly: true }, true],
] as const;

describe.each(booleanTruthy)("getBoolean %s", (_label, dataset, expected) => {
  it("matches expected", () => {
    expect(getBoolean(el(dataset as Record<string, string | boolean>), "readonly")).toBe(expected);
  });
});

describe.each([
  ["valid", { page: 3 }, 3, undefined],
  ["missing", {}, undefined, undefined],
  ["nan", { page: "nope" }, undefined, undefined],
  ["invalid enum returns 0", { step: 7 }, 0, [1, 2, 5] as const],
] as const)("getNumber %s", (_label, dataset, expected, validValues) => {
  it("parses number", () => {
    const result = getNumber(
      el(dataset as Record<string, string | number>),
      _label === "invalid enum returns 0" ? "step" : "page",
      validValues
    );
    expect(result).toBe(expected);
  });
});

describe.each([
  ["allowed", { orientation: "vertical" }, "vertical"],
  ["disallowed", { orientation: "diagonal" }, undefined],
  ["any", { name: "field" }, "field"],
] as const)("getString %s", (_label, dataset, expected) => {
  it("reads string", () => {
    const valid = ["horizontal", "vertical"] as const;
    const result =
      _label === "any"
        ? getString(el(dataset as Record<string, string>), "name")
        : getString(el(dataset as Record<string, string>), "orientation", valid);
    expect(result).toBe(expected);
  });
});

describe.each([
  ["csv", { value: "a,b, c" }, ["a", "b", "c"]],
  ["empty tokens", { value: " , " }, []],
  ["missing", {}, undefined],
] as const)("getStringList %s", (_label, dataset, expected) => {
  it("reads list", () => {
    expect(getStringList(el(dataset as Record<string, string>), "value")).toEqual(expected);
  });
});

describe.each([
  ["true", { checked: "true" }, true],
  ["false", { checked: "false" }, false],
  ["indeterminate", { checked: "indeterminate" }, "indeterminate"],
] as const)("getCheckedState %s", (_label, dataset, expected) => {
  it("reads checked state", () => {
    expect(getCheckedState(el(dataset as Record<string, string>), "checked")).toBe(expected);
  });
});

describe.each([
  ["true", { controlled: "true" }, true],
  ["false", { controlled: "false" }, false],
  ["empty", { controlled: "" }, undefined],
] as const)("getBooleanValue %s", (_label, dataset, expected) => {
  it("reads boolean value", () => {
    expect(getBooleanValue(el(dataset as Record<string, string>), "controlled")).toBe(expected);
  });
});

describe("getDir", () => {
  afterEach(() => {
    document.documentElement.removeAttribute("dir");
  });

  it.each([
    ["element rtl", { dir: "rtl" }, "rtl"],
    ["document rtl", {}, "rtl"],
    ["default ltr", {}, "ltr"],
  ] as const)("case %s", (label, dataset, expected) => {
    if (label === "document rtl") {
      document.documentElement.setAttribute("dir", "rtl");
      expect(getDir(el({}))).toBe("rtl");
      return;
    }
    if (label === "default ltr") {
      expect(getDir(el({}))).toBe("ltr");
      return;
    }
    expect(getDir(el(dataset as Record<string, string>))).toBe(expected);
  });
});

describe("generateId", () => {
  it("reuses element id", () => {
    const node = document.createElement("div");
    node.id = "stable-id";
    expect(generateId(node)).toBe("stable-id");
  });

  it.each(["toast", "dialog", "menu"] as const)("generates with prefix %s", (prefix) => {
    expect(generateId(undefined, prefix)).toMatch(new RegExp(`^${prefix}-`));
  });
});

describe("canPushEvent", () => {
  it.each([
    ["connected", { main: { isDead: false, isConnected: (): boolean => true } }, true],
    ["dead", { main: { isDead: true, isConnected: (): boolean => true } }, false],
    ["disconnected", { main: { isDead: false, isConnected: (): boolean => false } }, false],
  ] as const)("%s", (_label, socket, expected) => {
    expect(canPushEvent(socket)).toBe(expected);
  });
});

describe.each([
  ["single", { tags: "one" }, ["one"]],
  ["multi", { tags: "a,b,c" }, ["a", "b", "c"]],
] as const)("getStringList extra %s", (_label, dataset, expected) => {
  it("reads tags list", () => {
    expect(getStringList(el(dataset as Record<string, string>), "tags")).toEqual(expected);
  });
});

describe.each([
  ["zero", { min: 0 }, 0],
  ["large", { max: 100 }, 100],
] as const)("getNumber extra %s", (_label, dataset, expected) => {
  it("reads min/max", () => {
    const key = _label === "zero" ? "min" : "max";
    expect(getNumber(el(dataset as Record<string, number>), key)).toBe(expected);
  });
});

describe("templatesContentRoot", () => {
  it("returns template content fragment", () => {
    const root = document.createElement("div");
    root.innerHTML = `<template data-templates="items"><span>A</span></template>`;
    const content = templatesContentRoot(root, "items");
    expect(content).not.toBeNull();
  });

  it("returns null when host missing", () => {
    expect(templatesContentRoot(document.createElement("div"), "missing")).toBeNull();
  });
});
