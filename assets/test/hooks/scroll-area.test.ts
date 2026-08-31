import { describe, it } from "vitest";
import * as hookModule from "../../hooks/scroll-area";
import { expectHookModule } from "../helpers/expect-hook";

describe("scroll-area hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});
