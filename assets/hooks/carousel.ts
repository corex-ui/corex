import { Carousel } from "../components/carousel";
import type { Props, PageChangeDetails } from "@zag-js/carousel";
import { getString, getBoolean, getNumber, getDir, canPushEvent } from "../lib/util";
import { idMatches, notifyChange, readPayloadId } from "../lib/respond-to";
import { createZagLiveHook } from "../lib/zag-live-hook";

type CarouselHookState = {
  carousel?: Carousel;
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

const CarouselHook = createZagLiveHook<CarouselHookState, Carousel>({
  key: "carousel",
  mount(hook, { dom, server }) {
    const el = hook.el;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);
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
    dom.add("corex:carousel:play", () => {
      zag.api.play();
    });
    dom.add("corex:carousel:pause", () => {
      zag.api.pause();
    });
    dom.add<CustomEvent>("corex:carousel:scroll-next", (event) => {
      zag.api.scrollNext(readInstant(event.detail));
    });
    dom.add<CustomEvent>("corex:carousel:scroll-prev", (event) => {
      zag.api.scrollPrev(readInstant(event.detail));
    });
    server.add("carousel_play", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.play();
    });
    server.add("carousel_pause", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.pause();
    });
    server.add("carousel_scroll_next", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.scrollNext(readInstant(payload));
    });
    server.add("carousel_scroll_prev", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.scrollPrev(readInstant(payload));
    });

    return zag;
  },

  update(hook, zag) {
    const slideCount = getNumber(hook.el, "slideCount");
    if (slideCount == null || slideCount < 1) return;
    zag.updateProps({
      id: hook.el.id,
      slideCount,
      dir: getDir(hook.el),
      orientation: getString<"horizontal" | "vertical">(hook.el, "orientation"),
      slidesPerPage: getNumber(hook.el, "slidesPerPage"),
      slidesPerMove:
        getString(hook.el, "slidesPerMove") === "auto"
          ? "auto"
          : getNumber(hook.el, "slidesPerMove"),
      loop: getBoolean(hook.el, "loop"),
      autoplay: getBoolean(hook.el, "autoplay")
        ? { delay: getNumber(hook.el, "autoplayDelay") }
        : false,
      allowMouseDrag: getBoolean(hook.el, "allowMouseDrag"),
      spacing: getString(hook.el, "spacing"),
      padding: getString(hook.el, "padding"),
      inViewThreshold: getNumber(hook.el, "inViewThreshold"),
      snapType: getString<"proximity" | "mandatory">(hook.el, "snapType"),
      autoSize: getBoolean(hook.el, "autoSize"),
    } as Partial<Props>);
  },
});

export { CarouselHook as Carousel };
