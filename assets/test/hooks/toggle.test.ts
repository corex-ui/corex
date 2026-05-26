import { describe, expect, it } from "vitest";
import * as hookModule from "../../hooks/toggle";
import { pressedChangePayload } from "../../hooks/toggle";
import { expectHookModule } from "../helpers/expect-hook";

describe("toggle hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});

describe("pressedChangePayload", () => {
  it.each([
    [true, true],
    [false, false],
  ] as const)("%#", (pressed, expected) => {
    const el = document.createElement("div");
    el.id = "tg";
    expect(pressedChangePayload(el, pressed)).toEqual({ id: "tg", pressed: expected });
  });
});
