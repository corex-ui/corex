import { describe, expect, it } from "vitest";
import * as hookModule from "../../hooks/clipboard";
import { copyPayload } from "../../hooks/clipboard";
import { expectHookModule } from "../helpers/expect-hook";

describe("clipboard hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});

describe("copyPayload", () => {
  it.each([
    ["hello", "hello"],
    [undefined, undefined],
  ] as const)("%#", (value, expected) => {
    const el = document.createElement("div");
    el.id = "clip";
    expect(copyPayload(el, value)).toEqual({ id: "clip", value: expected });
  });
});
