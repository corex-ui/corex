import { describe, it } from "vitest";
import * as hookModule from "../../hooks/hover-card";
import { expectHookModule } from "../helpers/expect-hook";

describe("hover-card hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});
