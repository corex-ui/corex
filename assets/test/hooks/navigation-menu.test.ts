import { describe, it } from "vitest";
import * as hookModule from "../../hooks/navigation-menu";
import { expectHookModule } from "../helpers/expect-hook";

describe("navigation-menu hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});
