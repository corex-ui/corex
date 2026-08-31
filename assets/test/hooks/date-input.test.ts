import { describe, it } from "vitest";
import * as hookModule from "../../hooks/date-input";
import { expectHookModule } from "../helpers/expect-hook";

describe("date-input hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});
