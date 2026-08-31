import { describe, it } from "vitest";
import * as hookModule from "../../hooks/toc";
import { expectHookModule } from "../helpers/expect-hook";

describe("toc hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});
