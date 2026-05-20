import { describe, expect, it } from "vitest";
import { diffStringValues } from "./event-details";

describe("diffStringValues", () => {
  it("computes added and removed", () => {
    expect(diffStringValues(["a", "c"], ["a", "b"])).toEqual({
      added: ["c"],
      removed: ["b"],
    });
  });

  it("returns empty when unchanged", () => {
    expect(diffStringValues(["x"], ["x"])).toEqual({ added: [], removed: [] });
  });
});
