import { describe, expect, it } from "vitest";
import { el } from "../helpers/dom";
import { adjustDeadLinkTriggerProps } from "../../components/pagination-connect";
import {
  applyPhoenixLinkAttrs,
  applyPhoenixLinkAttrsToNavigableParts,
  buildGetPageUrl,
  Pagination,
  parsePaginationTranslations,
  uniquePaginationTranslations,
} from "../../components/pagination";
import { paginationTree } from "../helpers/component-smoke";

function linkPaginationHost(id = "pager") {
  const root = document.createElement("div");
  root.id = id;
  root.dataset.type = "link";
  root.dataset.to = "/items";
  root.dataset.redirect = "patch";
  root.dataset.pageParam = "page";
  root.dataset.pageSizeParam = "page_size";
  root.dataset.translation = JSON.stringify({
    prevTriggerLabel: "Previous",
    nextTriggerLabel: "Next",
  });

  const nav = document.createElement("nav");
  nav.dataset.scope = "pagination";
  nav.dataset.part = "root";
  nav.id = `pagination:${id}`;

  const ul = document.createElement("ul");

  const prevLi = document.createElement("li");
  const prev = document.createElement("a");
  prev.dataset.scope = "pagination";
  prev.dataset.part = "prev-trigger";
  prev.dataset.paginationPart = "prev";
  prev.id = `pagination:${id}:prev`;
  prevLi.appendChild(prev);

  const nextLi = document.createElement("li");
  nextLi.setAttribute("data-pagination-part", "next");
  const next = document.createElement("a");
  next.dataset.scope = "pagination";
  next.dataset.part = "next-trigger";
  next.dataset.paginationPart = "next";
  next.id = `pagination:${id}:next`;
  nextLi.appendChild(next);

  ul.append(prevLi, nextLi);
  nav.appendChild(ul);
  root.appendChild(nav);

  return root;
}

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

describe("adjustDeadLinkTriggerProps", () => {
  it("strips aria-label on dead link triggers without href", () => {
    const adjusted = adjustDeadLinkTriggerProps({
      "aria-label": "Previous",
      "data-disabled": "",
    });
    expect(adjusted["aria-label"]).toBeUndefined();
  });

  it("keeps aria-label when href is set", () => {
    const adjusted = adjustDeadLinkTriggerProps({
      "aria-label": "Previous",
      href: "/items?page=1&page_size=10",
    });
    expect(adjusted["aria-label"]).toBe("Previous");
  });

  it("keeps aria-label on disabled button triggers", () => {
    const adjusted = adjustDeadLinkTriggerProps({
      "aria-label": "Previous",
      type: "button",
      disabled: true,
      "data-disabled": "",
    });
    expect(adjusted["aria-label"]).toBe("Previous");
  });
});

describe("Pagination link trigger aria-label", () => {
  it("omits aria-label on dead prev link on page 1", () => {
    const host = linkPaginationHost();
    const pagination = new Pagination(host, {
      id: "pager",
      count: 50,
      defaultPage: 1,
      pageSize: 10,
      type: "link",
      getPageUrl: ({ page, pageSize }) => `/items?page=${page}&page_size=${pageSize}`,
    });
    pagination.init();

    const prev = host.querySelector<HTMLElement>('[data-part="prev-trigger"]');
    expect(prev?.hasAttribute("data-disabled")).toBe(true);
    expect(prev?.hasAttribute("href")).toBe(false);
    expect(prev?.hasAttribute("aria-label")).toBe(false);

    pagination.destroy();
  });

  it("keeps aria-label on navigable prev link", () => {
    const host = linkPaginationHost();
    const pagination = new Pagination(host, {
      id: "pager",
      count: 50,
      defaultPage: 2,
      pageSize: 10,
      type: "link",
      getPageUrl: ({ page, pageSize }) => `/items?page=${page}&page_size=${pageSize}`,
      translations: {
        prevTriggerLabel: "Previous",
        nextTriggerLabel: "Next",
      },
    });
    pagination.init();

    const prev = host.querySelector<HTMLElement>('[data-part="prev-trigger"]');
    expect(prev?.getAttribute("href")).toContain("page=1");
    expect(prev?.hasAttribute("aria-label")).toBe(true);

    pagination.destroy();
  });

  it("omits aria-label on dead next link on last page", () => {
    const host = linkPaginationHost();
    const pagination = new Pagination(host, {
      id: "pager",
      count: 50,
      defaultPage: 5,
      pageSize: 10,
      type: "link",
      getPageUrl: ({ page, pageSize }) => `/items?page=${page}&page_size=${pageSize}`,
    });
    pagination.init();

    const next = host.querySelector<HTMLElement>('[data-part="next-trigger"]');
    expect(next?.hasAttribute("data-disabled")).toBe(true);
    expect(next?.hasAttribute("href")).toBe(false);
    expect(next?.hasAttribute("aria-label")).toBe(false);

    pagination.destroy();
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
