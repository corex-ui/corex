import { describe, expect, it } from "vitest";
import * as hookModule from "../../hooks/file-upload";
import {
  fileAcceptPayload,
  fileChangePayload,
  fileRejectPayload,
} from "../../hooks/file-upload";
import { expectHookModule } from "../helpers/expect-hook";

describe("file-upload hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});

describe("fileChangePayload", () => {
  it("summarizes accepted and rejected files", () => {
    const el = document.createElement("div");
    el.id = "fu";
    const file = new File(["x"], "doc.txt", { type: "text/plain" });
    const payload = fileChangePayload(el, {
      acceptedFiles: [file],
      rejectedFiles: [],
    });
    expect(payload.id).toBe("fu");
    expect(payload.acceptedCount).toBe(1);
    expect(payload.firstAcceptedName).toBe("doc.txt");
  });
});

describe("fileAcceptPayload", () => {
  it("counts accepted files", () => {
    const el = document.createElement("div");
    el.id = "fu";
    expect(fileAcceptPayload(el, { files: [new File([], "a")] })).toEqual({
      id: "fu",
      count: 1,
    });
  });
});

describe("fileRejectPayload", () => {
  it("counts rejected files", () => {
    const el = document.createElement("div");
    el.id = "fu";
    expect(
      fileRejectPayload(el, {
        files: [{ file: new File([], "b"), errors: [] }],
      })
    ).toEqual({
      id: "fu",
      count: 1,
    });
  });
});
