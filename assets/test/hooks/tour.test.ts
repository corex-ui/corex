import { describe, it } from "vitest";
import * as hookModule from "../../hooks/tour";
import { expectHookModule } from "../helpers/expect-hook";

describe("tour hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});
