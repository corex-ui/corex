import { describe, it } from "vitest";
import * as hookModule from "../../hooks/rating-group";
import { expectHookModule } from "../helpers/expect-hook";

describe("rating-group hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});
