import { describe, it } from "vitest";
import * as hookModule from "../../hooks/cascade-select";
import { expectHookModule } from "../helpers/expect-hook";

describe("cascade-select hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});
