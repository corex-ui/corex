import { describe, expect, it } from "vitest";
import { diffStringValues } from "../../lib/event-details";

describe.each([
  [["a", "b"], ["a"], { added: ["b"], removed: [] }],
  [["a"], ["a", "b"], { added: [], removed: ["b"] }],
  [[], ["x"], { added: [], removed: ["x"] }],
  [["x"], [], { added: ["x"], removed: [] }],
  [[], [], { added: [], removed: [] }],
  [["a", "b", "c"], ["b"], { added: ["a", "c"], removed: [] }],
  [["one"], ["two"], { added: ["one"], removed: ["two"] }],
  [["a", "b", "c"], ["b", "c", "d"], { added: ["a"], removed: ["d"] }],
  [["same"], ["same"], { added: [], removed: [] }],
  [["dup", "dup"], ["dup"], { added: [], removed: [] }],
] as const)("diffStringValues", (next, previous, expected) => {
  it(`next=${next.join(",")} previous=${previous.join(",")}`, () => {
    expect(diffStringValues(next, previous)).toEqual(expected);
  });
});
