import { describe, expect, it } from "vitest";
import {
  fileKeyFor,
  labelFieldNameFor,
  syncFileFieldNames,
  zagFileId,
} from "../../components/file-upload";

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

describe("syncFileFieldNames", () => {
  it("strips file-input name when empty and names sentinel when requested", () => {
    const fileInput = document.createElement("input");
    fileInput.type = "file";
    fileInput.name = "admin[avatar]";
    const sentinel = document.createElement("input");
    sentinel.type = "hidden";

    syncFileFieldNames({
      fileInput,
      sentinel,
      name: "admin[avatar]",
      filesLength: 0,
      nameEmptySentinel: true,
    });

    expect(fileInput.hasAttribute("name")).toBe(false);
    expect(sentinel.getAttribute("name")).toBe("admin[avatar]");
    expect(sentinel.disabled).toBe(false);
  });

  it("gives file input the name when files are present", () => {
    const fileInput = document.createElement("input");
    fileInput.type = "file";
    const sentinel = document.createElement("input");
    sentinel.type = "hidden";
    sentinel.name = "admin[avatar]";

    syncFileFieldNames({
      fileInput,
      sentinel,
      name: "admin[avatar]",
      filesLength: 1,
      nameEmptySentinel: true,
    });

    expect(fileInput.getAttribute("name")).toBe("admin[avatar]");
    expect(sentinel.hasAttribute("name")).toBe(false);
    expect(sentinel.disabled).toBe(true);
  });

  it("leaves sentinel unnamed when empty and not used", () => {
    const fileInput = document.createElement("input");
    fileInput.type = "file";
    fileInput.name = "admin[avatar]";
    const sentinel = document.createElement("input");
    sentinel.type = "hidden";

    syncFileFieldNames({
      fileInput,
      sentinel,
      name: "admin[avatar]",
      filesLength: 0,
      nameEmptySentinel: false,
    });

    expect(fileInput.hasAttribute("name")).toBe(false);
    expect(sentinel.hasAttribute("name")).toBe(false);
  });
});
