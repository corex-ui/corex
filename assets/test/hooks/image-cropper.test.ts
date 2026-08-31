import { describe, it } from "vitest";
import * as hookModule from "../../hooks/image-cropper";
import { expectHookModule } from "../helpers/expect-hook";

describe("image-cropper hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});
