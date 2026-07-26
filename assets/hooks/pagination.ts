import {
  Pagination,
  buildGetPageUrl,
  parsePaginationTranslations,
  uniquePaginationTranslations,
} from "../components/pagination";
import type { PageChangeDetails, PageSizeChangeDetails, Props } from "@zag-js/pagination";
import { getString, getBoolean, getNumber, getDir, canPushEvent } from "../lib/util";
import { idMatches, notifyChange, readPayloadId } from "../lib/respond-to";
import { createZagLiveHook } from "../lib/zag-live-hook";

type PaginationHookState = {
  pagination?: Pagination;
};

export function readPayloadPage(payload: unknown): number | undefined {
  if (!payload || typeof payload !== "object") return undefined;
  const o = payload as Record<string, unknown>;
  const page = o.page ?? o["page"];
  return typeof page === "number" ? page : undefined;
}

export function readPayloadPageSize(payload: unknown): number | undefined {
  if (!payload || typeof payload !== "object") return undefined;
  const o = payload as Record<string, unknown>;
  const pageSize = o.page_size ?? o.pageSize ?? o["page_size"];
  return typeof pageSize === "number" ? pageSize : undefined;
}

function paginationPropsBase(
  el: HTMLElement,
  pushEvent: (event: string, payload: unknown) => void,
  canPush: () => boolean
) {
  const triggerType = getString<"button" | "link">(el, "type", ["button", "link"]) ?? "button";
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
    onPageChange: (details: PageChangeDetails) => {
      notifyChange({
        el,
        canPushServer: canPush(),
        pushEvent,
        payload: { id: el.id, page: details.page, page_size: details.pageSize },
        serverEventName: getString(el, "onPageChange"),
        clientEventName: getString(el, "onPageChangeClient"),
      });
    },
    onPageSizeChange: (details: PageSizeChangeDetails) => {
      notifyChange({
        el,
        canPushServer: canPush(),
        pushEvent,
        payload: { id: el.id, page_size: details.pageSize },
        serverEventName: getString(el, "onPageSizeChange"),
        clientEventName: getString(el, "onPageSizeChangeClient"),
      });
    },
  };
}

function buildPaginationProps(
  el: HTMLElement,
  pushEvent: (event: string, payload: unknown) => void,
  canPush: () => boolean
): Props {
  const controlled = getBoolean(el, "controlled");
  const controlledPageSize = getBoolean(el, "controlledPageSize");

  return {
    ...paginationPropsBase(el, pushEvent, canPush),
    ...(controlled
      ? { page: getNumber(el, "page") }
      : { defaultPage: getNumber(el, "defaultPage") ?? getNumber(el, "page") }),
    ...(controlledPageSize
      ? { pageSize: getNumber(el, "pageSize") }
      : {
          defaultPageSize: getNumber(el, "defaultPageSize") ?? getNumber(el, "pageSize"),
        }),
  } as Props;
}

function buildPaginationPropsForUpdate(
  el: HTMLElement,
  pushEvent: (event: string, payload: unknown) => void,
  canPush: () => boolean
): Partial<Props> {
  const controlled = getBoolean(el, "controlled");
  const controlledPageSize = getBoolean(el, "controlledPageSize");
  const base = paginationPropsBase(el, pushEvent, canPush) as Partial<Props>;
  delete base.onPageChange;
  delete base.onPageSizeChange;

  return {
    ...base,
    ...(controlled ? { page: getNumber(el, "page") } : {}),
    ...(controlledPageSize ? { pageSize: getNumber(el, "pageSize") } : {}),
  };
}

const PaginationHook = createZagLiveHook<PaginationHookState, Pagination>({
  key: "pagination",
  mount(hook, { dom, server }) {
    const el = hook.el;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);

    const pagination = new Pagination(el, buildPaginationProps(el, pushEvent, canPush));

    dom.add<CustomEvent<{ page: number }>>("corex:pagination:set-page", (event) => {
      const page = event.detail?.page;
      if (typeof page === "number") pagination.api.setPage(page);
    });

    dom.add<CustomEvent<{ page_size: number }>>("corex:pagination:set-page-size", (event) => {
      const pageSize = event.detail?.page_size;
      if (typeof pageSize === "number") pagination.api.setPageSize(pageSize);
    });

    dom.add("corex:pagination:go-to-next-page", () => {
      pagination.api.goToNextPage();
    });

    dom.add("corex:pagination:go-to-prev-page", () => {
      pagination.api.goToPrevPage();
    });

    dom.add("corex:pagination:go-to-first-page", () => {
      pagination.api.goToFirstPage();
    });

    dom.add("corex:pagination:go-to-last-page", () => {
      pagination.api.goToLastPage();
    });

    server.add("pagination_set_page", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      const page = readPayloadPage(payload);
      if (page != null) pagination.api.setPage(page);
    });

    server.add("pagination_set_page_size", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      const pageSize = readPayloadPageSize(payload);
      if (pageSize != null) pagination.api.setPageSize(pageSize);
    });

    server.add("pagination_go_to_next_page", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      pagination.api.goToNextPage();
    });

    server.add("pagination_go_to_prev_page", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      pagination.api.goToPrevPage();
    });

    server.add("pagination_go_to_first_page", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      pagination.api.goToFirstPage();
    });

    server.add("pagination_go_to_last_page", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      pagination.api.goToLastPage();
    });

    return pagination;
  },

  update(hook, pagination) {
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);
    pagination.updateProps(buildPaginationPropsForUpdate(hook.el, pushEvent, canPush));
  },
});

export { PaginationHook as Pagination };
