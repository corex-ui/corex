import { describe, expect, it } from "vitest";
import * as hookModule from "../../hooks/drawer";
import { parseSnapPoints } from "../../hooks/drawer";
import { expectHookModule } from "../helpers/expect-hook";

describe("drawer hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});

describe("parseSnapPoints", () => {
  it("parses mixed numeric and pixel points", () => {
    expect(parseSnapPoints("0.3,200px,1")).toEqual([0.3, "200px", 1]);
  });
});
