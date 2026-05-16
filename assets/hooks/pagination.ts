import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Pagination, buildGetPageUrl, parsePaginationTranslations } from "../components/pagination";
import type { PageChangeDetails, PageSizeChangeDetails, Props } from "@zag-js/pagination";
import { getString, getBoolean, getNumber, getDir, canPushEvent } from "../lib/util";
import { idMatches, notifyChange, readPayloadId } from "../lib/respond-to";
import { createHookHandleEventRegistry } from "../lib/hook-handlers";
import { createDomEventRegistry } from "../lib/dom-events";

type PaginationHookState = {
  pagination?: Pagination;
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
};

function readPayloadPage(payload: unknown): number | undefined {
  if (!payload || typeof payload !== "object") return undefined;
  const o = payload as Record<string, unknown>;
  const page = o.page ?? o["page"];
  return typeof page === "number" ? page : undefined;
}

function readPayloadPageSize(payload: unknown): number | undefined {
  if (!payload || typeof payload !== "object") return undefined;
  const o = payload as Record<string, unknown>;
  const pageSize = o.page_size ?? o.pageSize ?? o["page_size"];
  return typeof pageSize === "number" ? pageSize : undefined;
}

function buildPaginationProps(
  el: HTMLElement,
  pushEvent: (event: string, payload: unknown) => void,
  canPush: () => boolean
): Props {
  const controlled = getBoolean(el, "controlled");
  const controlledPageSize = getBoolean(el, "controlledPageSize");
  const triggerType = getString<"button" | "link">(el, "type", ["button", "link"]) ?? "button";
  const count = getNumber(el, "count") ?? 0;

  return {
    id: el.id,
    count,
    siblingCount: getNumber(el, "siblingCount"),
    boundaryCount: getNumber(el, "boundaryCount"),
    dir: getDir(el),
    type: triggerType,
    translations: parsePaginationTranslations(el),
    getPageUrl: buildGetPageUrl(el),
    ...(controlled
      ? { page: getNumber(el, "page") }
      : { defaultPage: getNumber(el, "defaultPage") ?? getNumber(el, "page") }),
    ...(controlledPageSize
      ? { pageSize: getNumber(el, "pageSize") }
      : {
          defaultPageSize: getNumber(el, "defaultPageSize") ?? getNumber(el, "pageSize"),
        }),
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

const PaginationHook: Hook<object & PaginationHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & PaginationHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);

    const pagination = new Pagination(el, buildPaginationProps(el, pushEvent, canPush));
    pagination.init();
    this.pagination = pagination;

    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;

    domRegistry.add<CustomEvent<{ page: number }>>("corex:pagination:set-page", (event) => {
      const page = event.detail?.page;
      if (typeof page === "number") pagination.api.setPage(page);
    });

    domRegistry.add<CustomEvent<{ page_size: number }>>(
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

    registry.add("pagination_set_page", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      const page = readPayloadPage(payload);
      if (page != null) pagination.api.setPage(page);
    });

    registry.add("pagination_set_page_size", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      const pageSize = readPayloadPageSize(payload);
      if (pageSize != null) pagination.api.setPageSize(pageSize);
    });

    registry.add("pagination_go_to_next_page", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      pagination.api.goToNextPage();
    });

    registry.add("pagination_go_to_prev_page", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      pagination.api.goToPrevPage();
    });

    registry.add("pagination_go_to_first_page", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      pagination.api.goToFirstPage();
    });

    registry.add("pagination_go_to_last_page", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      pagination.api.goToLastPage();
    });
  },

  updated(this: object & HookInterface<HTMLElement> & PaginationHookState) {
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
    this.pagination?.updateProps(buildPaginationProps(this.el, pushEvent, canPush));
  },

  destroyed(this: object & HookInterface<HTMLElement> & PaginationHookState) {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.pagination?.destroy();
  },
};

export { PaginationHook as Pagination };
