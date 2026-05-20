import { describe, expect, it } from "vitest";
import * as hookModule from "../../hooks/password-input";
import { visibilityChangePayload } from "../../hooks/password-input";
import { expectHookModule } from "../helpers/expect-hook";

describe("password-input hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});

describe("visibilityChangePayload", () => {
  it.each([
    [true, true],
    [false, false],
  ] as const)("%#", (visible, expected) => {
    const el = document.createElement("div");
    el.id = "pw";
    expect(visibilityChangePayload(el, { visible })).toEqual({ id: "pw", visible: expected });
  });
});
