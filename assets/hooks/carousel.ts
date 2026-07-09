import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Carousel } from "../components/carousel";
import type { Props, PageChangeDetails } from "@zag-js/carousel";
import { getString, getBoolean, getNumber, getDir, canPushEvent } from "../lib/util";
import { idMatches, notifyChange, readPayloadId } from "../lib/respond-to";
import { createHookHandleEventRegistry } from "../lib/hook-handlers";
import { createDomEventRegistry } from "../lib/dom-events";

type CarouselHookState = {
  carousel?: Carousel;
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
};

export function toZagPage(page: number | undefined): number | undefined {
  if (page == null) return undefined;
  return Math.max(0, page - 1);
}

export function fromZagPage(page: number): number {
  return page + 1;
}

export function readCorexPage(el: HTMLElement, attr: "page" | "defaultPage"): number | undefined {
  const dataKey = attr === "page" ? "page" : "defaultPage";
  return toZagPage(getNumber(el, dataKey));
}

export function readInstant(detail: unknown): boolean {
  if (detail && typeof detail === "object" && "instant" in detail) {
    const v = (detail as { instant?: unknown }).instant;
    return v === true || v === "true";
  }
  return false;
}

const CarouselHook: Hook<object & CarouselHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & CarouselHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
    const slideCount = getNumber(el, "slideCount");
    if (slideCount == null || slideCount < 1) {
      return;
    }
    const zag = new Carousel(el, {
      id: el.id,
      slideCount,
      defaultPage: readCorexPage(el, "defaultPage"),
      dir: getDir(el),
      orientation: getString<"horizontal" | "vertical">(el, "orientation"),
      slidesPerPage: getNumber(el, "slidesPerPage"),
      slidesPerMove:
        getString(el, "slidesPerMove") === "auto" ? "auto" : getNumber(el, "slidesPerMove"),
      loop: getBoolean(el, "loop"),
      autoplay: getBoolean(el, "autoplay") ? { delay: getNumber(el, "autoplayDelay") } : false,
      allowMouseDrag: getBoolean(el, "allowMouseDrag"),
      spacing: getString(el, "spacing"),
      padding: getString(el, "padding"),
      inViewThreshold: getNumber(el, "inViewThreshold"),
      snapType: getString<"proximity" | "mandatory">(el, "snapType"),
      autoSize: getBoolean(el, "autoSize"),
      onPageChange: (details: PageChangeDetails) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: {
            id: el.id,
            page: fromZagPage(details.page),
            pageSnapPoint: details.pageSnapPoint,
          },
          serverEventName: getString(el, "onPageChange"),
          clientEventName: getString(el, "onPageChangeClient"),
        });
      },
    } as Props);
    zag.init();
    this.carousel = zag;

    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;
    domRegistry.add("corex:carousel:play", () => {
      zag.api.play();
    });
    domRegistry.add("corex:carousel:pause", () => {
      zag.api.pause();
    });
    domRegistry.add<CustomEvent>("corex:carousel:scroll-next", (event) => {
      zag.api.scrollNext(readInstant(event.detail));
    });
    domRegistry.add<CustomEvent>("corex:carousel:scroll-prev", (event) => {
      zag.api.scrollPrev(readInstant(event.detail));
    });

    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;
    registry.add("carousel_play", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.play();
    });
    registry.add("carousel_pause", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.pause();
    });
    registry.add("carousel_scroll_next", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.scrollNext(readInstant(payload));
    });
    registry.add("carousel_scroll_prev", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.scrollPrev(readInstant(payload));
    });
  },

  updated(this: object & HookInterface<HTMLElement> & CarouselHookState) {
    const slideCount = getNumber(this.el, "slideCount");
    if (slideCount == null || slideCount < 1) return;
    this.carousel?.updateProps({
      id: this.el.id,
      slideCount,
      dir: getDir(this.el),
      orientation: getString<"horizontal" | "vertical">(this.el, "orientation"),
      slidesPerPage: getNumber(this.el, "slidesPerPage"),
      slidesPerMove:
        getString(this.el, "slidesPerMove") === "auto"
          ? "auto"
          : getNumber(this.el, "slidesPerMove"),
      loop: getBoolean(this.el, "loop"),
      autoplay: getBoolean(this.el, "autoplay")
        ? { delay: getNumber(this.el, "autoplayDelay") }
        : false,
      allowMouseDrag: getBoolean(this.el, "allowMouseDrag"),
      spacing: getString(this.el, "spacing"),
      padding: getString(this.el, "padding"),
      inViewThreshold: getNumber(this.el, "inViewThreshold"),
      snapType: getString<"proximity" | "mandatory">(this.el, "snapType"),
      autoSize: getBoolean(this.el, "autoSize"),
    } as Partial<Props>);
  },

  destroyed(this: object & HookInterface<HTMLElement> & CarouselHookState) {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.carousel?.destroy();
  },
};

export { CarouselHook as Carousel };
