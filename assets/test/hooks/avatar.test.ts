import { describe, expect, it } from "vitest";
import * as hookModule from "../../hooks/avatar";
import { statusPayload } from "../../hooks/avatar";
import { expectHookModule } from "../helpers/expect-hook";

describe("avatar hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});

describe("statusPayload", () => {
  it.each(["loaded", "error"] as const)("%#", (status) => {
    const el = document.createElement("div");
    el.id = "av";
    expect(statusPayload(el, { status })).toEqual({ id: "av", status });
  });
});
