import { describe, it } from "vitest";
import * as hookModule from "../../hooks/progress";
import { expectHookModule } from "../helpers/expect-hook";

describe("progress hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});
