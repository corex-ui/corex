import { describe, it } from "vitest";
import * as hookModule from "../../hooks/presence";
import { expectHookModule } from "../helpers/expect-hook";

describe("presence hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});
