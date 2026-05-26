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

describe("getBoolean", () => {
  it("returns false when attribute is absent", () => {
    expect(getBoolean(el({}), "readonly")).toBe(false);
  });

  it("returns true for empty data attribute", () => {
    expect(getBoolean(el({ readonly: true }), "readonly")).toBe(true);
  });

  it("returns false for data-readonly=false", () => {
    const node = document.createElement("div");
    node.setAttribute("data-readonly", "false");
    expect(getBoolean(node, "readonly")).toBe(false);
  });

  it("returns false for data-readonly=0", () => {
    const node = document.createElement("div");
    node.setAttribute("data-readonly", "0");
    expect(getBoolean(node, "readonly")).toBe(false);
  });

  it("maps camelCase readonly to data-readonly", () => {
    expect(getBoolean(el({ readonly: true }), "readonly")).toBe(true);
  });
});

describe("getNumber", () => {
  it("parses numeric data attributes", () => {
    expect(getNumber(el({ page: 3 }), "page")).toBe(3);
  });

  it("returns undefined for missing attribute", () => {
    expect(getNumber(el({}), "page")).toBeUndefined();
  });

  it("returns undefined for NaN", () => {
    const node = document.createElement("div");
    node.setAttribute("data-page", "nope");
    expect(getNumber(node, "page")).toBeUndefined();
  });

  it("returns 0 when value is not in validValues", () => {
    expect(getNumber(el({ step: 7 }), "step", [1, 2, 5] as const)).toBe(0);
  });
});

describe("getString", () => {
  it("returns value when allowed", () => {
    expect(
      getString(el({ orientation: "vertical" }), "orientation", ["horizontal", "vertical"])
    ).toBe("vertical");
  });

  it("returns undefined when not in validValues", () => {
    expect(
      getString(el({ orientation: "diagonal" }), "orientation", ["horizontal", "vertical"])
    ).toBeUndefined();
  });
});

describe("getStringList", () => {
  it("splits comma-separated values", () => {
    expect(getStringList(el({ value: "a, b ,c" }), "value")).toEqual(["a", "b", "c"]);
  });

  it("returns undefined when attribute missing", () => {
    expect(getStringList(el({}), "value")).toBeUndefined();
  });

  it("returns empty array for blank comma list", () => {
    const node = document.createElement("div");
    node.setAttribute("data-value", " , ");
    expect(getStringList(node, "value")).toEqual([]);
  });
});

describe("getString without validValues", () => {
  it("returns any dataset string", () => {
    expect(getString(el({ name: "field" }), "name")).toBe("field");
  });
});

describe("getCheckedState", () => {
  it("reads true and false", () => {
    expect(getCheckedState(el({ checked: "true" }), "checked")).toBe(true);
    expect(getCheckedState(el({ checked: "false" }), "checked")).toBe(false);
  });

  it("reads indeterminate", () => {
    expect(getCheckedState(el({ checked: "indeterminate" }), "checked")).toBe("indeterminate");
  });
});

describe("getBooleanValue", () => {
  it("returns true only for dataset true", () => {
    expect(getBooleanValue(el({ controlled: "true" }), "controlled")).toBe(true);
    expect(getBooleanValue(el({ controlled: "" }), "controlled")).toBeUndefined();
  });
});

describe("templatesContentRoot", () => {
  it("returns template content", () => {
    const root = document.createElement("div");
    root.innerHTML = `<template data-templates="items"><span>Item</span></template>`;
    const content = templatesContentRoot(root, "items");
    expect(content).not.toBeNull();
    expect(content instanceof DocumentFragment || content instanceof HTMLElement).toBe(true);
  });
});

describe("generateId", () => {
  it("reuses element id", () => {
    const node = document.createElement("div");
    node.id = "existing";
    expect(generateId(node)).toBe("existing");
  });

  it("generates id with fallback prefix", () => {
    expect(generateId(undefined, "toast")).toMatch(/^toast-/);
  });
});

describe("canPushEvent", () => {
  it("is true when connected", () => {
    expect(canPushEvent({ main: { isDead: false, isConnected: () => true } })).toBe(true);
  });

  it("is false when dead", () => {
    expect(canPushEvent({ main: { isDead: true, isConnected: () => true } })).toBe(false);
  });
});

describe("getDir", () => {
  afterEach(() => {
    document.documentElement.removeAttribute("dir");
  });

  it("prefers element data-dir", () => {
    expect(getDir(el({ dir: "rtl" }))).toBe("rtl");
  });

  it("falls back to document dir", () => {
    document.documentElement.setAttribute("dir", "rtl");
    expect(getDir(el({}))).toBe("rtl");
  });

  it("defaults to ltr", () => {
    expect(getDir(el({}))).toBe("ltr");
  });
});
