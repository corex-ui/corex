import { describe, expect, it } from "vitest";
import { fileKeyFor, zagFileId } from "../../components/file-upload";

describe("zagFileId", () => {
  it("is stable for the same value", () => {
    expect(zagFileId("doc.pdf-1024")).toBe(zagFileId("doc.pdf-1024"));
  });

  it("differs for different values", () => {
    expect(zagFileId("a")).not.toBe(zagFileId("b"));
  });
});

describe("fileKeyFor", () => {
  it("uses name and size", () => {
    const file = new File(["x"], "photo.png", { type: "image/png" });
    Object.defineProperty(file, "size", { value: 42 });
    expect(fileKeyFor(file)).toBe(zagFileId("photo.png-42"));
  });
});
