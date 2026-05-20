import { describe, expect, it } from "vitest";
import * as hookModule from "../../hooks/collapsible";
import { openChangePayload } from "../../hooks/collapsible";
import { expectHookModule } from "../helpers/expect-hook";

describe("collapsible hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});

describe("openChangePayload", () => {
  it("maps open state from details", () => {
    const el = document.createElement("div");
    el.id = "col";
    expect(openChangePayload(el, { open: true })).toEqual({ id: "col", open: true });
  });
});
