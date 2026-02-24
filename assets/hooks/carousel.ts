import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { Carousel } from "../components/carousel";
import type { Props, PageChangeDetails } from "@zag-js/carousel";
import { getString, getBoolean, getNumber, getDir } from "../lib/util";

type CarouselHookState = {
  carousel?: Carousel;
  handlers?: Array<CallbackRef>;
};

const CarouselHook: Hook<object & CarouselHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & CarouselHookState) {
    const el = this.el;
    const page = getNumber(el, "page");
    const defaultPage = getNumber(el, "defaultPage");
    const controlled = getBoolean(el, "controlled");
    const slideCount = getNumber(el, "slideCount");
    if (slideCount == null || slideCount < 1) {
      return;
    }
    const zag = new Carousel(el, {
      id: el.id,
      slideCount,
      ...(controlled && page !== undefined ? { page } : { defaultPage: defaultPage ?? 0 }),
      dir: getDir(el),
      orientation: getString<"horizontal" | "vertical">(el, "orientation", [
        "horizontal",
        "vertical",
      ]),
      slidesPerPage: getNumber(el, "slidesPerPage") ?? 1,
      slidesPerMove:
        getString(el, "slidesPerMove") === "auto" ? "auto" : getNumber(el, "slidesPerMove"),
      loop: getBoolean(el, "loop"),
      autoplay: getBoolean(el, "autoplay")
        ? { delay: getNumber(el, "autoplayDelay") ?? 4000 }
        : false,
      allowMouseDrag: getBoolean(el, "allowMouseDrag"),
      spacing: getString(el, "spacing") ?? "0px",
      padding: getString(el, "padding"),
      inViewThreshold: getNumber(el, "inViewThreshold") ?? 0.6,
      snapType: getString<"proximity" | "mandatory">(el, "snapType", ["proximity", "mandatory"]),
      autoSize: getBoolean(el, "autoSize"),
      onPageChange: (details: PageChangeDetails) => {
        const eventName = getString(el, "onPageChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, {
            page: details.page,
            pageSnapPoint: details.pageSnapPoint,
            id: el.id,
          });
        }
        const clientName = getString(el, "onPageChangeClient");
        if (clientName) {
          el.dispatchEvent(
            new CustomEvent(clientName, {
              bubbles: true,
              detail: { value: details, id: el.id },
            })
          );
        }
      },
    } as Props);
    zag.init();
    this.carousel = zag;
    this.handlers = [];
  },

  updated(this: object & HookInterface<HTMLElement> & CarouselHookState) {
    const slideCount = getNumber(this.el, "slideCount");
    if (slideCount == null || slideCount < 1) return;
    const page = getNumber(this.el, "page");
    const controlled = getBoolean(this.el, "controlled");
    this.carousel?.updateProps({
      id: this.el.id,
      slideCount,
      ...(controlled && page !== undefined ? { page } : {}),
      dir: getDir(this.el),
      orientation: getString<"horizontal" | "vertical">(this.el, "orientation", [
        "horizontal",
        "vertical",
      ]),
      slidesPerPage: getNumber(this.el, "slidesPerPage") ?? 1,
      slidesPerMove:
        getString(this.el, "slidesPerMove") === "auto"
          ? "auto"
          : getNumber(this.el, "slidesPerMove"),
      loop: getBoolean(this.el, "loop"),
      autoplay: getBoolean(this.el, "autoplay")
        ? { delay: getNumber(this.el, "autoplayDelay") ?? 4000 }
        : false,
      allowMouseDrag: getBoolean(this.el, "allowMouseDrag"),
      spacing: getString(this.el, "spacing") ?? "0px",
      padding: getString(this.el, "padding"),
      inViewThreshold: getNumber(this.el, "inViewThreshold") ?? 0.6,
      snapType: getString<"proximity" | "mandatory">(this.el, "snapType", [
        "proximity",
        "mandatory",
      ]),
      autoSize: getBoolean(this.el, "autoSize"),
    } as Partial<Props>);
  },

  destroyed(this: object & HookInterface<HTMLElement> & CarouselHookState) {
    if (this.handlers) {
      for (const h of this.handlers) this.removeHandleEvent(h);
    }
    this.carousel?.destroy();
  },
};

export { CarouselHook as Carousel };
