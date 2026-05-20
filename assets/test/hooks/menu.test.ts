import { describe, expect, it } from "vitest";
import * as hookModule from "../../hooks/menu";
import { findImmediateParentMenuHookEl } from "../../hooks/menu";
import { expectHookModule } from "../helpers/expect-hook";

describe("menu hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});

describe("findImmediateParentMenuHookEl", () => {
  it("returns parent menu root with data-phx-hook", () => {
    const nested = document.createElement("div");
    const parent = document.createElement("div");
    parent.setAttribute("phx-hook", "Menu");
    parent.appendChild(nested);
    expect(findImmediateParentMenuHookEl(nested)).toBe(parent);
  });

  it("returns null when no parent menu hook", () => {
    const el = document.createElement("div");
    expect(findImmediateParentMenuHookEl(el)).toBeNull();
  });
});
