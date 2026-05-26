import { describe, expect, it } from "vitest";
import * as hookModule from "../../hooks/tooltip";
import { getCloseDelay } from "../../hooks/tooltip";
import { el } from "../helpers/dom";
import { expectHookModule } from "../helpers/expect-hook";

describe("tooltip hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});

describe("getCloseDelay", () => {
  it.each([
    [{ interactive: true }, 400],
    [{ interactive: true, closeDelay: 200 }, 200],
    [{ closeDelay: 100 }, 100],
  ] as const)("%#", (dataset, expected) => {
    expect(getCloseDelay(el(dataset as Record<string, string | boolean | number>))).toBe(expected);
  });
});
