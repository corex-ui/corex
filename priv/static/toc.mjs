import {
  toPx
} from "./chunks/chunk-AJX2XHOK.mjs";
import {
  createAnatomy
} from "./chunks/chunk-YMOPD357.mjs";
import {
  Component,
  VanillaMachine,
  callAll,
  canPushEvent,
  createZagLiveHook,
  dataAttr,
  first,
  getDir,
  getString,
  getWindow,
  isDownloadingEvent,
  isEqual,
  isOpeningInNewTab,
  last,
  resizeObserverBorderBox,
  safeParseJson,
  scrollToElement,
  setup
} from "./chunks/chunk-R62PCG6O.mjs";

// ../node_modules/.pnpm/@zag-js+toc@1.43.3/node_modules/@zag-js/toc/dist/toc.anatomy.mjs
var anatomy = createAnatomy("toc").parts("root", "title", "list", "item", "link", "indicator");
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+toc@1.43.3/node_modules/@zag-js/toc/dist/toc.dom.mjs
var getRootId = (ctx) => ctx.ids?.root ?? `toc:${ctx.id}`;
var getTitleId = (ctx) => ctx.ids?.title ?? `toc:${ctx.id}:title`;
var getListId = (ctx) => ctx.ids?.list ?? `toc:${ctx.id}:list`;
var getItemId = (ctx, value) => ctx.ids?.item?.(value) ?? `toc:${ctx.id}:item-${value}`;
var getLinkId = (ctx, value) => ctx.ids?.link?.(value) ?? `toc:${ctx.id}:link-${value}`;
var getIndicatorId = (ctx) => ctx.ids?.indicator ?? `toc:${ctx.id}:indicator`;
var getListEl = (ctx) => ctx.getById(getListId(ctx));
var getItemEl = (ctx, value) => {
  if (value == null) return null;
  return ctx.getById(getItemId(ctx, value));
};
var getIndicatorEl = (ctx) => ctx.getById(getIndicatorId(ctx));
var getHeadingEl = (ctx, value) => {
  const doc = ctx.getDoc();
  return doc.getElementById(value);
};

// ../node_modules/.pnpm/@zag-js+toc@1.43.3/node_modules/@zag-js/toc/dist/toc.connect.mjs
function connect(service, normalize) {
  const { send, context, scope, computed, prop } = service;
  const items = prop("items");
  const activeItems = computed("activeItems");
  const activeIds = context.get("activeIds");
  const firstActiveId = first(activeIds);
  const lastActiveId = last(activeIds);
  function scrollTo(value, details) {
    const headingEl = getHeadingEl(scope, value);
    if (!headingEl) return false;
    const behavior = details?.behavior ?? prop("scrollBehavior");
    const scrollEl = prop("scrollEl")?.();
    if (!scrollEl) {
      headingEl.scrollIntoView({ behavior, block: "start" });
      return true;
    }
    return scrollToElement(headingEl, { rootEl: scrollEl, behavior });
  }
  function getItemState(props) {
    const { item } = props;
    return {
      active: activeIds.includes(item.value),
      first: item.value === firstActiveId,
      last: item.value === lastActiveId,
      depth: item.depth
    };
  }
  return {
    activeIds,
    activeItems,
    items,
    setActiveIds(value) {
      send({ type: "ACTIVE_IDS.SET", value });
    },
    scrollTo(value, details) {
      scrollTo(value, details);
    },
    getItemState,
    getRootProps() {
      const rect = context.get("indicatorRect");
      return normalize.element({
        ...parts.root.attrs,
        id: getRootId(scope),
        dir: prop("dir"),
        "aria-labelledby": getTitleId(scope),
        style: {
          "--top": toPx(rect?.y),
          "--left": toPx(rect?.x),
          "--width": toPx(rect?.width),
          "--height": toPx(rect?.height)
        }
      });
    },
    getTitleProps() {
      return normalize.element({
        ...parts.title.attrs,
        id: getTitleId(scope),
        dir: prop("dir")
      });
    },
    getListProps() {
      return normalize.element({
        ...parts.list.attrs,
        id: getListId(scope),
        dir: prop("dir")
      });
    },
    getItemProps(props) {
      const { item } = props;
      const itemState = getItemState(props);
      return normalize.element({
        ...parts.item.attrs,
        id: getItemId(scope, item.value),
        dir: prop("dir"),
        "data-value": item.value,
        "data-depth": String(itemState.depth),
        "data-active": dataAttr(itemState.active),
        "data-first": dataAttr(itemState.first),
        "data-last": dataAttr(itemState.last),
        style: {
          "--depth": itemState.depth
        }
      });
    },
    getLinkProps(props) {
      const { item } = props;
      const itemState = getItemState(props);
      return normalize.element({
        ...parts.link.attrs,
        id: getLinkId(scope, item.value),
        dir: prop("dir"),
        "data-value": item.value,
        "data-active": dataAttr(itemState.active),
        "aria-current": itemState.active ? "location" : void 0,
        onClick(event) {
          const scrollEl = prop("scrollEl")?.();
          if (!scrollEl) return;
          if (event.defaultPrevented) return;
          if (isDownloadingEvent(event)) return;
          if (isOpeningInNewTab(event)) return;
          const value = getSamePageHash(event.currentTarget);
          if (!value) return;
          const scrolled = scrollTo(value);
          if (!scrolled) return;
          event.preventDefault();
          pushHash(scope.getWin(), value);
        }
      });
    },
    getIndicatorProps() {
      const rect = context.get("indicatorRect");
      return normalize.element({
        ...parts.indicator.attrs,
        id: getIndicatorId(scope),
        hidden: isRectEmpty(rect),
        style: {
          position: "absolute"
        }
      });
    }
  };
}
var isRectEmpty = (rect) => rect == null || rect.width === 0 && rect.height === 0 && rect.x === 0 && rect.y === 0;
var getSamePageHash = (el) => {
  const href = el.getAttribute("href");
  if (!href) return null;
  const win = getWindow(el);
  const url = new win.URL(href, win.location.href);
  if (url.origin !== win.location.origin) return null;
  if (url.pathname !== win.location.pathname) return null;
  if (url.search !== win.location.search) return null;
  try {
    return decodeURIComponent(url.hash.slice(1)) || null;
  } catch {
    return null;
  }
};
var pushHash = (win, value) => {
  const oldURL = win.location.href;
  win.history.pushState(null, "", `#${value}`);
  win.dispatchEvent(new win.HashChangeEvent("hashchange", { oldURL, newURL: win.location.href }));
};

// ../node_modules/.pnpm/@zag-js+toc@1.43.3/node_modules/@zag-js/toc/dist/toc.machine.mjs
var { createMachine } = setup();
var machine = createMachine({
  props({ props }) {
    return {
      dir: "ltr",
      rootMargin: "-20px 0% -40% 0%",
      threshold: 0,
      autoScroll: true,
      scrollBehavior: "smooth",
      items: [],
      ...props
    };
  },
  initialState() {
    return "idle";
  },
  context({ prop, bindable }) {
    return {
      activeIds: bindable(() => ({
        defaultValue: prop("defaultActiveIds") ?? [],
        value: prop("activeIds")
      })),
      indicatorRect: bindable(() => ({
        defaultValue: null
      }))
    };
  },
  refs() {
    return {
      visibilityMap: /* @__PURE__ */ new Map(),
      indicatorCleanup: null
    };
  },
  computed: {
    activeItems({ context, prop }) {
      const ids = context.get("activeIds");
      return prop("items").filter((item) => ids.includes(item.value));
    }
  },
  watch({ context, track, action }) {
    track([() => context.get("activeIds").join()], () => {
      action(["autoScrollToc", "syncIndicatorRect"]);
    });
  },
  entry: ["syncIndicatorRect"],
  exit: ["cleanupIndicatorObserver"],
  on: {
    "ACTIVE_IDS.SET": {
      actions: ["setActiveIds"]
    }
  },
  states: {
    idle: {
      effects: ["trackHeadingVisibility"]
    }
  },
  implementations: {
    actions: {
      setActiveIds(params) {
        const { context, event } = params;
        context.set("activeIds", event.value);
        invokeOnActiveChange(params);
      },
      autoScrollToc({ context, scope, prop }) {
        if (!prop("autoScroll")) return;
        const tocItemEl = getItemEl(scope, first(context.get("activeIds")));
        tocItemEl?.scrollIntoView({
          behavior: prop("scrollBehavior"),
          block: "nearest"
        });
      },
      cleanupIndicatorObserver({ refs }) {
        refs.get("indicatorCleanup")?.();
      },
      syncIndicatorRect({ context, refs, scope }) {
        refs.get("indicatorCleanup")?.();
        const indicatorEl = getIndicatorEl(scope);
        if (!indicatorEl) return;
        const activeIds = context.get("activeIds");
        if (activeIds.length === 0) {
          context.set("indicatorRect", null);
          return;
        }
        const exec = () => {
          const ids = context.get("activeIds");
          if (ids.length === 0) {
            context.set("indicatorRect", null);
            return;
          }
          const firstEl = getItemEl(scope, first(ids));
          const lastEl = getItemEl(scope, last(ids));
          if (!firstEl) return;
          const listEl = getListEl(scope);
          const listRect = listEl?.getBoundingClientRect();
          const firstRect = firstEl.getBoundingClientRect();
          const offsetY = listRect ? firstRect.top - listRect.top + listEl.scrollTop : firstRect.top;
          const offsetX = listRect ? firstRect.left - listRect.left + listEl.scrollLeft : firstRect.left;
          let height;
          if (lastEl && lastEl !== firstEl) {
            const lastRect = lastEl.getBoundingClientRect();
            height = lastRect.top + lastRect.height - firstRect.top;
          } else {
            height = firstRect.height;
          }
          const nextRect = {
            x: offsetX,
            y: offsetY,
            width: firstRect.width,
            height
          };
          context.set("indicatorRect", (prev) => isEqual(prev, nextRect) ? prev : nextRect);
        };
        exec();
        const cleanups = [];
        for (const id of activeIds) {
          const el = getItemEl(scope, id);
          if (el) {
            cleanups.push(resizeObserverBorderBox.observe(el, exec));
          }
        }
        refs.set("indicatorCleanup", () => callAll(...cleanups));
      }
    },
    effects: {
      trackHeadingVisibility(params) {
        const { scope, prop, context, refs } = params;
        const items = prop("items");
        if (items.length === 0) return;
        const visibilityMap = refs.get("visibilityMap");
        const observerOptions = {
          rootMargin: prop("rootMargin"),
          threshold: prop("threshold")
        };
        const scrollEl = prop("scrollEl")?.();
        if (scrollEl) {
          observerOptions.root = scrollEl;
        }
        const win = scope.getWin();
        const observer = new win.IntersectionObserver((entries) => {
          for (const entry of entries) {
            visibilityMap.set(entry.target.id, entry.isIntersecting);
          }
          const nextActiveIds = [];
          for (const item of items) {
            if (visibilityMap.get(item.value)) {
              nextActiveIds.push(item.value);
            }
          }
          if (nextActiveIds.length === 0) return;
          const currentActiveIds = context.get("activeIds");
          if (!isEqual(currentActiveIds, nextActiveIds)) {
            context.set("activeIds", nextActiveIds);
            invokeOnActiveChange(params);
          }
        }, observerOptions);
        for (const item of items) {
          const headingEl = getHeadingEl(scope, item.value);
          if (headingEl) {
            observer.observe(headingEl);
          }
        }
        return () => {
          observer.disconnect();
          visibilityMap.clear();
        };
      }
    }
  }
});
function invokeOnActiveChange(params) {
  const { context, computed, prop } = params;
  prop("onActiveChange")?.({
    activeIds: context.get("activeIds"),
    activeItems: computed("activeItems")
  });
}

// components/toc.ts
var Toc = class extends Component {
  initMachine(props) {
    return new VanillaMachine(machine, props);
  }
  initApi() {
    return this.zagConnect(connect);
  }
  render() {
    const root = this.el.querySelector('[data-scope="toc"][data-part="root"]') ?? this.el;
    this.spreadProps(root, this.api.getRootProps());
    root.setAttribute("aria-label", `Table of contents ${this.el.id}`);
    const list = this.el.querySelector('[data-scope="toc"][data-part="list"]');
    if (list) this.spreadProps(list, this.api.getListProps());
    this.el.querySelectorAll('[data-scope="toc"][data-part="item"]').forEach((el) => {
      const value = el.dataset.value;
      const depth = Number(el.dataset.depth ?? "2");
      if (!value) return;
      const item = { value, depth };
      this.spreadProps(el, this.api.getItemProps({ item }));
    });
    this.el.querySelectorAll('[data-scope="toc"][data-part="link"]').forEach((link) => {
      const value = link.dataset.value;
      const depth = Number(link.dataset.depth ?? "2");
      if (!value) return;
      this.spreadProps(link, this.api.getLinkProps({ item: { value, depth } }));
    });
    const indicator = this.el.querySelector(
      '[data-scope="toc"][data-part="indicator"]'
    );
    if (indicator) this.spreadProps(indicator, this.api.getIndicatorProps());
  }
};

// hooks/toc.ts
var DEFAULT_ITEMS = [
  { value: "intro", depth: 2 },
  { value: "usage", depth: 2 }
];
function tocProps(el, hook) {
  const onActiveChange = (details) => {
    const eventName = getString(el, "onActiveChange") ?? getString(el, "onValueChange");
    if (eventName && canPushEvent(hook.liveSocket)) {
      hook.pushEvent(eventName, { id: el.id, value: details.activeIds });
    }
    const client = getString(el, "onActiveChangeClient") ?? getString(el, "onValueChangeClient");
    if (client) {
      el.dispatchEvent(
        new CustomEvent(client, {
          bubbles: true,
          detail: { id: el.id, value: details.activeIds }
        })
      );
    }
  };
  return {
    id: el.id,
    dir: getDir(el),
    items: safeParseJson(el.dataset.items, DEFAULT_ITEMS),
    onActiveChange
  };
}
var TocHook = createZagLiveHook({
  key: "toc",
  mount(hook) {
    return new Toc(hook.el, tocProps(hook.el, hook));
  },
  update(hook, inst) {
    inst.updateProps(tocProps(hook.el, hook));
  }
});
export {
  TocHook as Toc
};
