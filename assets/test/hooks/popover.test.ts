import { describe, it } from "vitest";
import * as hookModule from "../../hooks/popover";
import { expectHookModule } from "../helpers/expect-hook";

describe("popover hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});
