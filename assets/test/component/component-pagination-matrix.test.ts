import { describe, expect, it } from "vitest";
import { el } from "../helpers/dom";
import {
  parsePaginationTranslations,
  applyPhoenixLinkAttrs,
  applyPhoenixLinkAttrsToNavigableParts,
  buildGetPageUrl,
  uniquePaginationTranslations,
} from "../../components/pagination";

describe("parsePaginationTranslations matrix", () => {
  it.each([
    [undefined, undefined],
    ['{"rootLabel":"Pages"}', "Pages"],
    ['{"prevTriggerLabel":"Prev","nextTriggerLabel":"Next"}', undefined],
    ['{"itemLabel":"Page %{page} of %{total_pages}"}', undefined],
    ["{bad", undefined],
    ['{"rootLabel":""}', undefined],
  ] as const)("%#", (raw, rootLabel) => {
    const node = document.createElement("div");
    if (raw != null) node.dataset.translation = raw;
    const t = parsePaginationTranslations(node);
    if (rootLabel) expect(t?.rootLabel).toBe(rootLabel);
    else if (raw?.includes("itemLabel"))
      expect(t?.itemLabel?.({ page: 2, totalPages: 5 })).toContain("2");
    else if (raw?.includes("prevTriggerLabel")) expect(t?.prevTriggerLabel).toBe("Prev");
    else expect(t).toBeUndefined();
  });
});

describe("applyPhoenixLinkAttrs matrix", () => {
  it.each([
    ["link", "patch", "patch"],
    ["link", "navigate", "redirect"],
    ["button", "patch", null],
    ["link", "href", null],
  ] as const)("%#", (type, redirect, phxLink) => {
    const root = el({ type, redirect } as Record<string, string>);
    const anchor = document.createElement("a");
    applyPhoenixLinkAttrs(root, anchor);
    if (phxLink) expect(anchor.getAttribute("data-phx-link")).toBe(phxLink);
    else expect(anchor.hasAttribute("data-phx-link")).toBe(false);
  });

  it("skips non-anchor elements", () => {
    const root = el({ type: "link", redirect: "patch" });
    const span = document.createElement("span");
    applyPhoenixLinkAttrs(root, span);
    expect(span.hasAttribute("data-phx-link")).toBe(false);
  });
});

describe("applyPhoenixLinkAttrsToNavigableParts matrix", () => {
  it("applies to item, prev, and next parts", () => {
    const root = document.createElement("div");
    root.dataset.type = "link";
    root.dataset.redirect = "patch";
    root.innerHTML = `
      <a data-scope="pagination" data-part="item">1</a>
      <a data-scope="pagination" data-part="prev-trigger">Prev</a>
      <a data-scope="pagination" data-part="next-trigger">Next</a>
    `;
    applyPhoenixLinkAttrsToNavigableParts(root);
    root.querySelectorAll("a").forEach((a) => {
      expect(a.getAttribute("data-phx-link")).toBe("patch");
    });
  });
});

describe("buildGetPageUrl matrix", () => {
  it.each([
    [{ type: "link", to: "/items" }, "page=2"],
    [{ type: "link", to: "/items?sort=asc" }, "page=2"],
    [{ type: "link", to: "/x", pageParam: "p", pageSizeParam: "ps" }, "p=3"],
    [{ type: "button", to: "/x" }, null],
    [{ type: "link" }, null],
  ] as const)("%#", (dataset, fragment) => {
    const getUrl = buildGetPageUrl(el(dataset as Record<string, string>));
    if (fragment == null) expect(getUrl).toBeUndefined();
    else
      expect(getUrl?.({ page: fragment.includes("p=3") ? 3 : 2, pageSize: 10 })).toContain(
        fragment
      );
  });
});

describe("uniquePaginationTranslations matrix", () => {
  it.each([
    [{}, "Pagination"],
    [{ rootLabel: "Nav" }, "Nav"],
    [{ rootLabel: "  " }, "Pagination"],
  ] as const)("%#", (translations, base) => {
    const node = document.createElement("div");
    node.id = "pg-test";
    const t = uniquePaginationTranslations(node, translations);
    expect(t.rootLabel).toContain(base);
    expect(t.rootLabel).toContain("pg-test");
  });
});
