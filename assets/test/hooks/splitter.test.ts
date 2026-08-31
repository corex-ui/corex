import { describe, it } from "vitest";
import * as hookModule from "../../hooks/splitter";
import { expectHookModule } from "../helpers/expect-hook";

describe("splitter hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});
