import { describe, it } from "vitest";
import * as hookModule from "../../hooks/steps";
import { expectHookModule } from "../helpers/expect-hook";

describe("steps hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});
