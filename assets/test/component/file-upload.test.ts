import { describe, expect, it } from "vitest";
import { fileKeyFor, labelFieldNameFor, zagFileId } from "../../components/file-upload";

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

describe("labelFieldNameFor", () => {
  it("appends _label for flat names", () => {
    expect(labelFieldNameFor("document")).toBe("document_label");
  });

  it("replaces the last bracket segment for nested names", () => {
    expect(labelFieldNameFor("file_upload_phoenix[attachment]")).toBe(
      "file_upload_phoenix[attachment_label]"
    );
    expect(labelFieldNameFor("user[avatar]")).toBe("user[avatar_label]");
  });
});
