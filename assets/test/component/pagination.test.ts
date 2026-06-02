import { describe, expect, it } from "vitest";
import { el } from "../helpers/dom";
import {
  applyPhoenixLinkAttrs,
  applyPhoenixLinkAttrsToNavigableParts,
  buildGetPageUrl,
  Pagination,
  parsePaginationTranslations,
  uniquePaginationTranslations,
} from "../../components/pagination";
import { paginationTree } from "../helpers/component-smoke";

describe("parsePaginationTranslations", () => {
  it("parses JSON translation map", () => {
    const node = document.createElement("div");
    node.dataset.translation = JSON.stringify({
      rootLabel: "Pages",
      prevTriggerLabel: "Prev",
      nextTriggerLabel: "Next",
      itemLabel: "Page %{page} of %{total_pages}",
    });
    const t = parsePaginationTranslations(node);
    expect(t?.rootLabel).toBe("Pages");
    expect(t?.itemLabel?.({ page: 2, totalPages: 5 })).toContain("2");
  });
});

describe("uniquePaginationTranslations", () => {
  it("suffixes root label with element id", () => {
    const node = document.createElement("div");
    node.id = "pager";
    const t = uniquePaginationTranslations(node, { rootLabel: "Pagination" });
    expect(t.rootLabel).toBe("Pagination (pager)");
  });
});

describe("buildGetPageUrl", () => {
  it("builds link URLs with page params", () => {
    const node = el({ type: "link", to: "/items", pageParam: "page", pageSizeParam: "page_size" });
    const getUrl = buildGetPageUrl(node);
    expect(getUrl?.({ page: 2, pageSize: 10 })).toBe("/items?page=2&page_size=10");
  });

  it("returns undefined for button type", () => {
    expect(buildGetPageUrl(el({ type: "button" }))).toBeUndefined();
  });

  it("returns undefined for disallowed base URL", () => {
    expect(buildGetPageUrl(el({ type: "link", to: "javascript:alert(1)" }))).toBeUndefined();
    expect(buildGetPageUrl(el({ type: "link", to: "//evil.example" }))).toBeUndefined();
  });
});

describe("applyPhoenixLinkAttrs", () => {
  it("sets phx-link attrs for patch redirect", () => {
    const root = el({ type: "link", redirect: "patch" });
    const anchor = document.createElement("a");
    applyPhoenixLinkAttrs(root, anchor);
    expect(anchor.getAttribute("data-phx-link")).toBe("patch");
  });
});

describe("applyPhoenixLinkAttrsToNavigableParts", () => {
  it("applies link attrs to items and triggers", () => {
    const elTree = paginationTree();
    elTree.dataset.type = "link";
    elTree.dataset.to = "/items";
    elTree.dataset.redirect = "patch";
    applyPhoenixLinkAttrsToNavigableParts(elTree);
    const item = elTree.querySelector('[data-part="item"]');
    expect(item?.getAttribute("data-phx-link")).toBe("patch");
  });
});

describe("Pagination ellipsis template", () => {
  it("clones ellipsis slot content instead of using innerHTML", () => {
    const root = document.createElement("div");
    root.id = "pager";
    root.dataset.type = "button";

    const nav = document.createElement("nav");
    const ul = document.createElement("ul");
    const prev = document.createElement("li");
    prev.setAttribute("data-pagination-part", "prev");
    const next = document.createElement("li");
    next.setAttribute("data-pagination-part", "next");
    ul.append(prev, next);
    nav.appendChild(ul);
    root.appendChild(nav);

    const paginationRoot = document.createElement("div");
    paginationRoot.dataset.scope = "pagination";
    paginationRoot.dataset.part = "root";
    root.appendChild(paginationRoot);

    const ellipsisTemplate = document.createElement("div");
    ellipsisTemplate.id = "pager-ellipsis";
    ellipsisTemplate.setAttribute("data-pagination-ellipsis-template", "");
    ellipsisTemplate.hidden = true;
    const marker = document.createElement("span");
    marker.setAttribute("data-testid", "ellipsis-icon");
    marker.textContent = "more";
    ellipsisTemplate.appendChild(marker);
    root.appendChild(ellipsisTemplate);

    const pagination = new Pagination(root, {
      id: "pager",
      count: 200,
      page: 10,
      pageSize: 10,
      siblingCount: 1,
      boundaryCount: 1,
    });
    pagination.init();

    const ellipsis = root.querySelector<HTMLElement>(
      '[data-scope="pagination"][data-part="ellipsis"]'
    );
    expect(ellipsis?.querySelector("[data-testid='ellipsis-icon']")).toBeTruthy();
    expect(ellipsisTemplate.querySelector("[data-testid='ellipsis-icon']")).toBeTruthy();

    pagination.destroy();
  });
});
