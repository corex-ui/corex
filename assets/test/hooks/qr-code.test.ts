import { describe, it } from "vitest";
import * as hookModule from "../../hooks/qr-code";
import { expectHookModule } from "../helpers/expect-hook";

describe("qr-code hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});
