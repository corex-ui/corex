import { describe, expect, it } from "vitest";
import {
  buildZagTagsInputTranslations,
  resolveZagTagsInputTranslations,
} from "../../components/tags-input";

describe("buildZagTagsInputTranslations", () => {
  it("interpolates tag in delete label", () => {
    const t = buildZagTagsInputTranslations({ deleteTagTriggerLabel: "Remove %{tag}" });
    expect(t.deleteTagTriggerLabel?.("work")).toBe("Remove work");
  });

  it("uses default templates when omitted", () => {
    const t = buildZagTagsInputTranslations({});
    expect(t.deleteTagTriggerLabel?.("x")).toContain("x");
    expect(t.tagEdited?.("x")).toContain("x");
  });
});

describe("resolveZagTagsInputTranslations", () => {
  it("parses dataset translation JSON", () => {
    const el = document.createElement("div");
    el.dataset.translation = JSON.stringify({ deleteTagTriggerLabel: "Drop %{tag}" });
    const { translations } = resolveZagTagsInputTranslations(el);
    expect(translations.deleteTagTriggerLabel?.("a")).toBe("Drop a");
  });

  it("falls back on invalid JSON", () => {
    const el = document.createElement("div");
    el.dataset.translation = "{";
    const { translations } = resolveZagTagsInputTranslations(el);
    expect(translations.deleteTagTriggerLabel?.("t")).toContain("t");
  });

  it("uses defaults when dataset missing", () => {
    const { translations } = resolveZagTagsInputTranslations(document.createElement("div"));
    expect(translations.tagEdited?.("tag")).toContain("tag");
  });
});
