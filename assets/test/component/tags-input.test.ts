import { describe, expect, it } from "vitest";
import {
  buildZagTagsInputTranslations,
  normalizeDeleteTriggerContent,
  resolveZagTagsInputTranslations,
  stripLiveViewDomAttrs,
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

describe("stripLiveViewDomAttrs", () => {
  it("removes data-phx attributes from a cloned tree", () => {
    const root = document.createElement("span");
    root.innerHTML =
      '<button data-phx-id="m1"><span class="hero-x-mark" data-phx-id="m2" data-phx-loc="1"></span></button>';
    stripLiveViewDomAttrs(root);
    expect(root.querySelector("[data-phx-id]")).toBeNull();
    expect(root.querySelector("[data-phx-loc]")).toBeNull();
    expect(root.querySelector(".hero-x-mark")).not.toBeNull();
  });
});

describe("normalizeDeleteTriggerContent", () => {
  it("keeps a single heroicon when LiveView morph duplicates it", () => {
    const del = document.createElement("button");
    del.innerHTML =
      '<span class="hero-x-mark"></span><span class="hero-x-mark"></span><span data-phx-skip></span>';
    const first = del.firstElementChild!;
    normalizeDeleteTriggerContent(del);
    expect(del.childElementCount).toBe(1);
    expect(del.firstElementChild).toBe(first);
    expect(del.firstElementChild?.className).toContain("hero-x-mark");
  });

  it("does not detach the icon when already singular", () => {
    const del = document.createElement("button");
    del.innerHTML = '<span class="hero-x-mark"></span>';
    const icon = del.firstElementChild!;
    normalizeDeleteTriggerContent(del);
    expect(del.firstElementChild).toBe(icon);
    expect(del.contains(icon)).toBe(true);
  });
});
