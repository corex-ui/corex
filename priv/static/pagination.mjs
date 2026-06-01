import {
  memo
} from "./chunks/chunk-HWSJUKAB.mjs";
import {
  createDomEventRegistry,
  createHookHandleEventRegistry
} from "./chunks/chunk-77HPO22C.mjs";
import {
  idMatches,
  notifyChange,
  readPayloadId
} from "./chunks/chunk-2WCNJX5P.mjs";
import {
  Component,
  VanillaMachine,
  canPushEvent,
  cloneTemplateChildren,
  createAnatomy,
  createMachine,
  dataAttr,
  getBoolean,
  getDir,
  getNumber,
  getString,
  isNumber
} from "./chunks/chunk-2GQRP3FN.mjs";

// ../node_modules/.pnpm/@zag-js+pagination@1.40.0/node_modules/@zag-js/pagination/dist/pagination.anatomy.mjs
var anatomy = createAnatomy("pagination").parts(
  "root",
  "item",
  "ellipsis",
  "firstTrigger",
  "prevTrigger",
  "nextTrigger",
  "lastTrigger"
);
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+pagination@1.40.0/node_modules/@zag-js/pagination/dist/pagination.dom.mjs
var getRootId = (ctx) => ctx.ids?.root ?? `pagination:${ctx.id}`;
var getFirstTriggerId = (ctx) => ctx.ids?.firstTrigger ?? `pagination:${ctx.id}:first`;
var getPrevTriggerId = (ctx) => ctx.ids?.prevTrigger ?? `pagination:${ctx.id}:prev`;
var getNextTriggerId = (ctx) => ctx.ids?.nextTrigger ?? `pagination:${ctx.id}:next`;
var getLastTriggerId = (ctx) => ctx.ids?.lastTrigger ?? `pagination:${ctx.id}:last`;
var getEllipsisId = (ctx, index) => ctx.ids?.ellipsis?.(index) ?? `pagination:${ctx.id}:ellipsis:${index}`;
var getItemId = (ctx, page) => ctx.ids?.item?.(page) ?? `pagination:${ctx.id}:item:${page}`;

// ../node_modules/.pnpm/@zag-js+pagination@1.40.0/node_modules/@zag-js/pagination/dist/pagination.utils.mjs
var range = (start, end) => {
  let length = end - start + 1;
  return Array.from({ length }, (_, idx) => idx + start);
};
var transform = (items) => {
  return items.map((value) => {
    if (isNumber(value)) return { type: "page", value };
    return { type: "ellipsis" };
  });
};
var ELLIPSIS = "ellipsis";
var getRange = (ctx) => {
  const { page, totalPages, siblingCount, boundaryCount = 1 } = ctx;
  if (totalPages <= 0) return [];
  if (totalPages === 1) return [1];
  const firstPageIndex = 1;
  const lastPageIndex = totalPages;
  const leftSiblingIndex = Math.max(page - siblingCount, firstPageIndex);
  const rightSiblingIndex = Math.min(page + siblingCount, lastPageIndex);
  const totalPageNumbers = Math.min(siblingCount * 2 + 3 + boundaryCount * 2, totalPages);
  if (totalPages <= totalPageNumbers) {
    return range(firstPageIndex, lastPageIndex);
  }
  const itemCount = totalPageNumbers - 1 - boundaryCount;
  const showLeftEllipsis = leftSiblingIndex > firstPageIndex + boundaryCount + 1 && Math.abs(leftSiblingIndex - firstPageIndex) > boundaryCount + 1;
  const showRightEllipsis = rightSiblingIndex < lastPageIndex - boundaryCount - 1 && Math.abs(lastPageIndex - rightSiblingIndex) > boundaryCount + 1;
  let pages = [];
  if (!showLeftEllipsis && showRightEllipsis) {
    const leftRange = range(1, itemCount);
    pages.push(...leftRange, ELLIPSIS);
    pages.push(...range(lastPageIndex - boundaryCount + 1, lastPageIndex));
  } else if (showLeftEllipsis && !showRightEllipsis) {
    pages.push(...range(firstPageIndex, firstPageIndex + boundaryCount - 1));
    pages.push(ELLIPSIS);
    const rightRange = range(lastPageIndex - itemCount + 1, lastPageIndex);
    pages.push(...rightRange);
  } else if (showLeftEllipsis && showRightEllipsis) {
    pages.push(...range(firstPageIndex, firstPageIndex + boundaryCount - 1));
    pages.push(ELLIPSIS);
    const middleRange = range(leftSiblingIndex, rightSiblingIndex);
    pages.push(...middleRange);
    pages.push(ELLIPSIS);
    pages.push(...range(lastPageIndex - boundaryCount + 1, lastPageIndex));
  } else {
    pages.push(...range(firstPageIndex, lastPageIndex));
  }
  for (let i = 0; i < pages.length; i++) {
    if (pages[i] === ELLIPSIS) {
      const prevPage = isNumber(pages[i - 1]) ? pages[i - 1] : 0;
      const nextPage = isNumber(pages[i + 1]) ? pages[i + 1] : totalPages + 1;
      if (nextPage - prevPage === 2) {
        pages[i] = prevPage + 1;
      }
    }
  }
  return pages;
};
var getTransformedRange = (ctx) => transform(getRange(ctx));

// ../node_modules/.pnpm/@zag-js+pagination@1.40.0/node_modules/@zag-js/pagination/dist/pagination.connect.mjs
function connect(service, normalize) {
  const { send, scope, prop, computed, context } = service;
  const totalPages = computed("totalPages");
  const page = context.get("page");
  const pageSize = context.get("pageSize");
  const translations = prop("translations");
  const count = prop("count");
  const getPageUrl = prop("getPageUrl");
  const type = prop("type");
  const previousPage = computed("previousPage");
  const nextPage = computed("nextPage");
  const pageRange = computed("pageRange");
  const isFirstPage = page === 1;
  const isLastPage = page >= totalPages;
  const pages = getTransformedRange({
    page,
    totalPages,
    siblingCount: prop("siblingCount"),
    boundaryCount: prop("boundaryCount")
  });
  return {
    count,
    page,
    pageSize,
    totalPages,
    pages,
    previousPage,
    nextPage,
    pageRange,
    slice(data) {
      return data.slice(pageRange.start, pageRange.end);
    },
    setPageSize(size) {
      send({ type: "SET_PAGE_SIZE", size });
    },
    setPage(page2) {
      send({ type: "SET_PAGE", page: page2 });
    },
    goToNextPage() {
      send({ type: "NEXT_PAGE" });
    },
    goToPrevPage() {
      send({ type: "PREVIOUS_PAGE" });
    },
    goToFirstPage() {
      send({ type: "FIRST_PAGE" });
    },
    goToLastPage() {
      send({ type: "LAST_PAGE" });
    },
    getRootProps() {
      return normalize.element({
        id: getRootId(scope),
        ...parts.root.attrs,
        dir: prop("dir"),
        "aria-label": translations.rootLabel
      });
    },
    getEllipsisProps(props) {
      return normalize.element({
        id: getEllipsisId(scope, props.index),
        ...parts.ellipsis.attrs,
        dir: prop("dir")
      });
    },
    getItemProps(props) {
      const index = props.value;
      const isCurrentPage = index === page;
      return normalize.element({
        id: getItemId(scope, index),
        ...parts.item.attrs,
        dir: prop("dir"),
        "data-index": index,
        "data-selected": dataAttr(isCurrentPage),
        "aria-current": isCurrentPage ? "page" : void 0,
        "aria-label": translations.itemLabel?.({ page: index, totalPages }),
        onClick() {
          send({ type: "SET_PAGE", page: index });
        },
        ...type === "button" && { type: "button" },
        ...type === "link" && getPageUrl && {
          href: getPageUrl({ page: index, pageSize })
        }
      });
    },
    getPrevTriggerProps() {
      return normalize.element({
        id: getPrevTriggerId(scope),
        ...parts.prevTrigger.attrs,
        dir: prop("dir"),
        "data-disabled": dataAttr(isFirstPage),
        "aria-label": translations.prevTriggerLabel,
        onClick() {
          send({ type: "PREVIOUS_PAGE" });
        },
        ...type === "button" && { disabled: isFirstPage, type: "button" },
        ...type === "link" && getPageUrl && previousPage && {
          href: getPageUrl({ page: previousPage, pageSize })
        }
      });
    },
    getFirstTriggerProps() {
      return normalize.element({
        id: getFirstTriggerId(scope),
        ...parts.firstTrigger.attrs,
        dir: prop("dir"),
        "data-disabled": dataAttr(isFirstPage),
        "aria-label": translations.firstTriggerLabel,
        onClick() {
          send({ type: "FIRST_PAGE" });
        },
        ...type === "button" && { disabled: isFirstPage, type: "button" },
        ...type === "link" && getPageUrl && {
          href: getPageUrl({ page: 1, pageSize })
        }
      });
    },
    getNextTriggerProps() {
      return normalize.element({
        id: getNextTriggerId(scope),
        ...parts.nextTrigger.attrs,
        dir: prop("dir"),
        "data-disabled": dataAttr(isLastPage),
        "aria-label": translations.nextTriggerLabel,
        onClick() {
          send({ type: "NEXT_PAGE" });
        },
        ...type === "button" && { disabled: isLastPage, type: "button" },
        ...type === "link" && getPageUrl && nextPage && {
          href: getPageUrl({ page: nextPage, pageSize })
        }
      });
    },
    getLastTriggerProps() {
      return normalize.element({
        id: getLastTriggerId(scope),
        ...parts.lastTrigger.attrs,
        dir: prop("dir"),
        "data-disabled": dataAttr(isLastPage),
        "aria-label": translations.lastTriggerLabel,
        onClick() {
          send({ type: "LAST_PAGE" });
        },
        ...type === "button" && { disabled: isLastPage, type: "button" },
        ...type === "link" && getPageUrl && {
          href: getPageUrl({ page: totalPages, pageSize })
        }
      });
    }
  };
}

// ../node_modules/.pnpm/@zag-js+pagination@1.40.0/node_modules/@zag-js/pagination/dist/pagination.machine.mjs
var machine = createMachine({
  props({ props }) {
    return {
      defaultPageSize: 10,
      siblingCount: 1,
      boundaryCount: 1,
      defaultPage: 1,
      type: "button",
      count: 1,
      ...props,
      translations: {
        rootLabel: "pagination",
        firstTriggerLabel: "first page",
        prevTriggerLabel: "previous page",
        nextTriggerLabel: "next page",
        lastTriggerLabel: "last page",
        itemLabel({ page, totalPages }) {
          const isLastPage = totalPages > 1 && page === totalPages;
          return `${isLastPage ? "last page, " : ""}page ${page}`;
        },
        ...props.translations
      }
    };
  },
  initialState() {
    return "idle";
  },
  context({ prop, bindable, getContext }) {
    return {
      page: bindable(() => ({
        value: prop("page"),
        defaultValue: prop("defaultPage"),
        onChange(value) {
          const context = getContext();
          prop("onPageChange")?.({ page: value, pageSize: context.get("pageSize") });
        }
      })),
      pageSize: bindable(() => ({
        value: prop("pageSize"),
        defaultValue: prop("defaultPageSize"),
        onChange(value) {
          prop("onPageSizeChange")?.({ pageSize: value });
        }
      }))
    };
  },
  watch({ track, context, action }) {
    track([() => context.get("pageSize")], () => {
      action(["setPageIfNeeded"]);
    });
  },
  computed: {
    totalPages: memo(
      ({ prop, context }) => [context.get("pageSize"), prop("count")],
      ([pageSize, count]) => Math.ceil(count / pageSize)
    ),
    pageRange: memo(
      ({ context, prop }) => [context.get("page"), context.get("pageSize"), prop("count")],
      ([page, pageSize, count]) => {
        const start = (page - 1) * pageSize;
        return { start, end: Math.min(start + pageSize, count) };
      }
    ),
    previousPage: ({ context }) => context.get("page") === 1 ? null : context.get("page") - 1,
    nextPage: ({ context, computed }) => context.get("page") === computed("totalPages") ? null : context.get("page") + 1,
    isValidPage: ({ context, computed }) => context.get("page") >= 1 && context.get("page") <= computed("totalPages")
  },
  on: {
    SET_PAGE: {
      guard: "isValidPage",
      actions: ["setPage"]
    },
    SET_PAGE_SIZE: {
      actions: ["setPageSize"]
    },
    FIRST_PAGE: {
      actions: ["goToFirstPage"]
    },
    LAST_PAGE: {
      actions: ["goToLastPage"]
    },
    PREVIOUS_PAGE: {
      guard: "canGoToPrevPage",
      actions: ["goToPrevPage"]
    },
    NEXT_PAGE: {
      guard: "canGoToNextPage",
      actions: ["goToNextPage"]
    }
  },
  states: {
    idle: {}
  },
  implementations: {
    guards: {
      isValidPage: ({ event, computed }) => event.page >= 1 && event.page <= computed("totalPages"),
      isValidCount: ({ context, event }) => context.get("page") > event.count,
      canGoToNextPage: ({ context, computed }) => context.get("page") < computed("totalPages"),
      canGoToPrevPage: ({ context }) => context.get("page") > 1
    },
    actions: {
      setPage({ context, event, computed }) {
        const page = clampPage(event.page, computed("totalPages"));
        context.set("page", page);
      },
      setPageSize({ context, event }) {
        context.set("pageSize", event.size);
      },
      goToFirstPage({ context }) {
        context.set("page", 1);
      },
      goToLastPage({ context, computed }) {
        context.set("page", computed("totalPages"));
      },
      goToPrevPage({ context, computed }) {
        context.set("page", (prev) => clampPage(prev - 1, computed("totalPages")));
      },
      goToNextPage({ context, computed }) {
        context.set("page", (prev) => clampPage(prev + 1, computed("totalPages")));
      },
      setPageIfNeeded({ context, computed }) {
        if (computed("isValidPage")) return;
        context.set("page", 1);
      }
    }
  }
});
var clampPage = (page, totalPages) => Math.min(Math.max(page, 1), totalPages);

// components/pagination.ts
var Pagination = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props) {
    return new VanillaMachine(machine, props);
  }
  initApi() {
    return this.zagConnect(connect);
  }
  render() {
    const rootEl = this.el.querySelector(
      '[data-scope="pagination"][data-part="root"]'
    );
    if (rootEl) this.spreadProps(rootEl, this.api.getRootProps());
    const prevEl = this.el.querySelector(
      '[data-scope="pagination"][data-part="prev-trigger"]'
    );
    if (prevEl) this.spreadProps(prevEl, this.api.getPrevTriggerProps());
    const nextEl = this.el.querySelector(
      '[data-scope="pagination"][data-part="next-trigger"]'
    );
    if (nextEl) this.spreadProps(nextEl, this.api.getNextTriggerProps());
    this.syncPages();
    applyPhoenixLinkAttrsToNavigableParts(this.el);
  }
  directPageElements(list) {
    return Array.from(list.querySelectorAll(':scope > [data-pagination-part="page"]'));
  }
  syncPages() {
    const nextLi = this.el.querySelector('[data-pagination-part="next"]');
    const list = nextLi?.parentElement;
    if (!list || !nextLi) return;
    const ellipsisTemplate = this.el.querySelector(
      "[data-pagination-ellipsis-template]"
    );
    const triggerType = getString(this.el, "type") ?? "button";
    const pages = this.api.pages;
    let items = this.directPageElements(list);
    while (items.length > pages.length) {
      items[items.length - 1].remove();
      items = this.directPageElements(list);
    }
    for (let index = 0; index < pages.length; index++) {
      const page = pages[index];
      items = this.directPageElements(list);
      let li = items[index];
      if (!li) {
        li = document.createElement("li");
        li.setAttribute("data-pagination-part", "page");
        list.insertBefore(li, nextLi);
        items = this.directPageElements(list);
        li = items[index];
      }
      const itemEl = li.querySelector('[data-scope="pagination"][data-part="item"]');
      const ellipsisEl = li.querySelector(
        '[data-scope="pagination"][data-part="ellipsis"]'
      );
      if (page.type === "page") {
        if (ellipsisEl) ellipsisEl.remove();
        let control = itemEl;
        if (!control) {
          control = triggerType === "link" ? document.createElement("a") : document.createElement("button");
          if (control instanceof HTMLButtonElement) control.type = "button";
          li.appendChild(control);
        }
        const label = String(page.value);
        if (control.textContent !== label) control.textContent = label;
        this.spreadProps(control, this.api.getItemProps(page));
        applyPhoenixLinkAttrs(this.el, control);
      } else {
        if (itemEl) itemEl.remove();
        let span = ellipsisEl;
        if (!span) {
          span = document.createElement("span");
          if (!cloneTemplateChildren(ellipsisTemplate, span)) {
            span.textContent = "\u2026";
          }
          li.appendChild(span);
        }
        this.spreadProps(span, this.api.getEllipsisProps({ index }));
      }
    }
  }
};
function uniquePaginationTranslations(el, translations) {
  const label = translations?.rootLabel?.trim() || "Pagination";
  return {
    ...translations,
    rootLabel: `${label} (${el.id})`
  };
}
function parsePaginationTranslations(el) {
  const raw = el.dataset.translation;
  if (!raw) return void 0;
  try {
    const o = JSON.parse(raw);
    const translations = {};
    if (typeof o.rootLabel === "string" && o.rootLabel.length > 0) {
      translations.rootLabel = o.rootLabel;
    }
    if (typeof o.prevTriggerLabel === "string" && o.prevTriggerLabel.length > 0) {
      translations.prevTriggerLabel = o.prevTriggerLabel;
    }
    if (typeof o.nextTriggerLabel === "string" && o.nextTriggerLabel.length > 0) {
      translations.nextTriggerLabel = o.nextTriggerLabel;
    }
    if (typeof o.itemLabel === "string" && o.itemLabel.length > 0) {
      const tpl = o.itemLabel;
      translations.itemLabel = (details) => tpl.replace("%{page}", String(details.page)).replace("%{total_pages}", String(details.totalPages));
    }
    return Object.keys(translations).length > 0 ? translations : void 0;
  } catch {
    return void 0;
  }
}
function applyPhoenixLinkAttrs(rootEl, anchorEl) {
  if (getString(rootEl, "type") !== "link") return;
  if (anchorEl.tagName !== "A") return;
  const redirect = getString(rootEl, "redirect", ["href", "patch", "navigate"]);
  if (redirect === "patch") {
    anchorEl.setAttribute("data-phx-link", "patch");
    anchorEl.setAttribute("data-phx-link-state", "push");
  } else if (redirect === "navigate") {
    anchorEl.setAttribute("data-phx-link", "redirect");
    anchorEl.setAttribute("data-phx-link-state", "push");
  } else {
    anchorEl.removeAttribute("data-phx-link");
    anchorEl.removeAttribute("data-phx-link-state");
  }
}
function applyPhoenixLinkAttrsToNavigableParts(rootEl) {
  const selectors = [
    '[data-scope="pagination"][data-part="item"]',
    '[data-scope="pagination"][data-part="prev-trigger"]',
    '[data-scope="pagination"][data-part="next-trigger"]'
  ];
  for (const selector of selectors) {
    rootEl.querySelectorAll(selector).forEach((el) => {
      applyPhoenixLinkAttrs(rootEl, el);
    });
  }
}
function buildGetPageUrl(el) {
  const triggerType = getString(el, "type");
  const base = el.dataset.to;
  if (triggerType !== "link" || !base) return void 0;
  const pageParam = el.dataset.pageParam ?? "page";
  const pageSizeParam = el.dataset.pageSizeParam ?? "page_size";
  return ({ page, pageSize }) => {
    const sep = base.includes("?") ? "&" : "?";
    return `${base}${sep}${encodeURIComponent(pageParam)}=${page}&${encodeURIComponent(pageSizeParam)}=${pageSize}`;
  };
}

// hooks/pagination.ts
function readPayloadPage(payload) {
  if (!payload || typeof payload !== "object") return void 0;
  const o = payload;
  const page = o.page ?? o["page"];
  return typeof page === "number" ? page : void 0;
}
function readPayloadPageSize(payload) {
  if (!payload || typeof payload !== "object") return void 0;
  const o = payload;
  const pageSize = o.page_size ?? o.pageSize ?? o["page_size"];
  return typeof pageSize === "number" ? pageSize : void 0;
}
function paginationPropsBase(el, pushEvent, canPush) {
  const triggerType = getString(el, "type", ["button", "link"]) ?? "button";
  const count = getNumber(el, "count") ?? 0;
  return {
    id: el.id,
    count,
    siblingCount: getNumber(el, "siblingCount"),
    boundaryCount: getNumber(el, "boundaryCount"),
    dir: getDir(el),
    type: triggerType,
    translations: uniquePaginationTranslations(el, parsePaginationTranslations(el)),
    getPageUrl: buildGetPageUrl(el),
    onPageChange: (details) => {
      notifyChange({
        el,
        canPushServer: canPush(),
        pushEvent,
        payload: { id: el.id, page: details.page, page_size: details.pageSize },
        serverEventName: getString(el, "onPageChange"),
        clientEventName: getString(el, "onPageChangeClient")
      });
    },
    onPageSizeChange: (details) => {
      notifyChange({
        el,
        canPushServer: canPush(),
        pushEvent,
        payload: { id: el.id, page_size: details.pageSize },
        serverEventName: getString(el, "onPageSizeChange"),
        clientEventName: getString(el, "onPageSizeChangeClient")
      });
    }
  };
}
function buildPaginationProps(el, pushEvent, canPush) {
  const controlled = getBoolean(el, "controlled");
  const controlledPageSize = getBoolean(el, "controlledPageSize");
  return {
    ...paginationPropsBase(el, pushEvent, canPush),
    ...controlled ? { page: getNumber(el, "page") } : { defaultPage: getNumber(el, "defaultPage") ?? getNumber(el, "page") },
    ...controlledPageSize ? { pageSize: getNumber(el, "pageSize") } : {
      defaultPageSize: getNumber(el, "defaultPageSize") ?? getNumber(el, "pageSize")
    }
  };
}
function buildPaginationPropsForUpdate(el, pushEvent, canPush) {
  const controlled = getBoolean(el, "controlled");
  const controlledPageSize = getBoolean(el, "controlledPageSize");
  const base = paginationPropsBase(el, pushEvent, canPush);
  delete base.onPageChange;
  delete base.onPageSizeChange;
  return {
    ...base,
    ...controlled ? { page: getNumber(el, "page") } : {},
    ...controlledPageSize ? { pageSize: getNumber(el, "pageSize") } : {}
  };
}
var PaginationHook = {
  mounted() {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
    const pagination = new Pagination(el, buildPaginationProps(el, pushEvent, canPush));
    pagination.init();
    this.pagination = pagination;
    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;
    domRegistry.add("corex:pagination:set-page", (event) => {
      const page = event.detail?.page;
      if (typeof page === "number") pagination.api.setPage(page);
    });
    domRegistry.add(
      "corex:pagination:set-page-size",
      (event) => {
        const pageSize = event.detail?.page_size;
        if (typeof pageSize === "number") pagination.api.setPageSize(pageSize);
      }
    );
    domRegistry.add("corex:pagination:go-to-next-page", () => {
      pagination.api.goToNextPage();
    });
    domRegistry.add("corex:pagination:go-to-prev-page", () => {
      pagination.api.goToPrevPage();
    });
    domRegistry.add("corex:pagination:go-to-first-page", () => {
      pagination.api.goToFirstPage();
    });
    domRegistry.add("corex:pagination:go-to-last-page", () => {
      pagination.api.goToLastPage();
    });
    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;
    registry.add("pagination_set_page", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      const page = readPayloadPage(payload);
      if (page != null) pagination.api.setPage(page);
    });
    registry.add("pagination_set_page_size", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      const pageSize = readPayloadPageSize(payload);
      if (pageSize != null) pagination.api.setPageSize(pageSize);
    });
    registry.add("pagination_go_to_next_page", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      pagination.api.goToNextPage();
    });
    registry.add("pagination_go_to_prev_page", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      pagination.api.goToPrevPage();
    });
    registry.add("pagination_go_to_first_page", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      pagination.api.goToFirstPage();
    });
    registry.add("pagination_go_to_last_page", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      pagination.api.goToLastPage();
    });
  },
  updated() {
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
    this.pagination?.updateProps(buildPaginationPropsForUpdate(this.el, pushEvent, canPush));
  },
  destroyed() {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.pagination?.destroy();
  }
};
export {
  PaginationHook as Pagination,
  readPayloadPage,
  readPayloadPageSize
};
