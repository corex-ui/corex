import {
  toPx
} from "./chunks/chunk-PE34YET2.mjs";
import {
  readStringControlledZagProps,
  readStringControlledZagUpdate
} from "./chunks/chunk-S4GKLIQE.mjs";
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
  callAll,
  canPushEvent,
  clickIfLink,
  contains,
  createAnatomy,
  dataAttr,
  first,
  getDir,
  getEventKey,
  getEventTarget,
  getFocusables,
  getString,
  isAnchorElement,
  isComposingEvent,
  isEqual,
  isOpeningInNewTab,
  isSafari,
  itemById,
  last,
  nextById,
  prevById,
  queryAll,
  raf,
  resizeObserverBorderBox,
  setup
} from "./chunks/chunk-2GQRP3FN.mjs";

// ../node_modules/.pnpm/@zag-js+tabs@1.40.0/node_modules/@zag-js/tabs/dist/tabs.anatomy.mjs
var anatomy = createAnatomy("tabs").parts("root", "list", "trigger", "content", "indicator");
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+tabs@1.40.0/node_modules/@zag-js/tabs/dist/tabs.dom.mjs
var getRootId = (ctx) => ctx.ids?.root ?? `tabs:${ctx.id}`;
var getListId = (ctx) => ctx.ids?.list ?? `tabs:${ctx.id}:list`;
var getContentId = (ctx, value) => ctx.ids?.content?.(value) ?? `tabs:${ctx.id}:content-${value}`;
var getTriggerId = (ctx, value) => ctx.ids?.trigger?.(value) ?? `tabs:${ctx.id}:trigger-${value}`;
var getIndicatorId = (ctx) => ctx.ids?.indicator ?? `tabs:${ctx.id}:indicator`;
var getListEl = (ctx) => ctx.getById(getListId(ctx));
var getContentEl = (ctx, value) => ctx.getById(getContentId(ctx, value));
var getTriggerEl = (ctx, value) => value != null ? ctx.getById(getTriggerId(ctx, value)) : null;
var getIndicatorEl = (ctx) => ctx.getById(getIndicatorId(ctx));
var getElements = (ctx) => {
  const ownerId = CSS.escape(getListId(ctx));
  const selector = `[role=tab][data-ownedby='${ownerId}']:not([disabled])`;
  return queryAll(getListEl(ctx), selector);
};
var getFirstTriggerEl = (ctx) => first(getElements(ctx));
var getLastTriggerEl = (ctx) => last(getElements(ctx));
var getNextTriggerEl = (ctx, opts) => nextById(getElements(ctx), getTriggerId(ctx, opts.value), opts.loopFocus);
var getPrevTriggerEl = (ctx, opts) => prevById(getElements(ctx), getTriggerId(ctx, opts.value), opts.loopFocus);
var getOffsetRect = (el) => ({
  x: el?.offsetLeft ?? 0,
  y: el?.offsetTop ?? 0,
  width: el?.offsetWidth ?? 0,
  height: el?.offsetHeight ?? 0
});
var getRectByValue = (ctx, value) => {
  const tab = itemById(getElements(ctx), getTriggerId(ctx, value));
  return getOffsetRect(tab);
};

// ../node_modules/.pnpm/@zag-js+tabs@1.40.0/node_modules/@zag-js/tabs/dist/tabs.connect.mjs
function connect(service, normalize) {
  const { state, send, context, prop, scope } = service;
  const translations = prop("translations");
  const focused = state.matches("focused");
  const isVertical = prop("orientation") === "vertical";
  const isHorizontal = prop("orientation") === "horizontal";
  const composite = prop("composite");
  function getTriggerState(props) {
    return {
      selected: context.get("value") === props.value,
      focused: context.get("focusedValue") === props.value,
      disabled: !!props.disabled
    };
  }
  return {
    value: context.get("value"),
    focusedValue: context.get("focusedValue"),
    setValue(value) {
      send({ type: "SET_VALUE", value });
    },
    clearValue() {
      send({ type: "CLEAR_VALUE" });
    },
    setIndicatorRect(value) {
      const id = getTriggerId(scope, value);
      send({ type: "SET_INDICATOR_RECT", id });
    },
    syncTabIndex() {
      send({ type: "SYNC_TAB_INDEX" });
    },
    selectNext(fromValue) {
      send({ type: "TAB_FOCUS", value: fromValue, src: "selectNext" });
      send({ type: "ARROW_NEXT", src: "selectNext" });
    },
    selectPrev(fromValue) {
      send({ type: "TAB_FOCUS", value: fromValue, src: "selectPrev" });
      send({ type: "ARROW_PREV", src: "selectPrev" });
    },
    focus() {
      const value = context.get("value");
      if (!value) return;
      getTriggerEl(scope, value)?.focus();
    },
    getRootProps() {
      return normalize.element({
        ...parts.root.attrs,
        id: getRootId(scope),
        "data-orientation": prop("orientation"),
        "data-focus": dataAttr(focused),
        dir: prop("dir")
      });
    },
    getListProps() {
      return normalize.element({
        ...parts.list.attrs,
        id: getListId(scope),
        role: "tablist",
        dir: prop("dir"),
        "data-focus": dataAttr(focused),
        "aria-orientation": prop("orientation"),
        "data-orientation": prop("orientation"),
        "aria-label": translations?.listLabel,
        onKeyDown(event) {
          if (event.defaultPrevented) return;
          if (isComposingEvent(event)) return;
          if (!contains(event.currentTarget, getEventTarget(event))) return;
          const keyMap = {
            ArrowDown() {
              if (isHorizontal) return;
              send({ type: "ARROW_NEXT", key: "ArrowDown" });
            },
            ArrowUp() {
              if (isHorizontal) return;
              send({ type: "ARROW_PREV", key: "ArrowUp" });
            },
            ArrowLeft() {
              if (isVertical) return;
              send({ type: "ARROW_PREV", key: "ArrowLeft" });
            },
            ArrowRight() {
              if (isVertical) return;
              send({ type: "ARROW_NEXT", key: "ArrowRight" });
            },
            Home() {
              send({ type: "HOME" });
            },
            End() {
              send({ type: "END" });
            }
          };
          let key = getEventKey(event, {
            dir: prop("dir"),
            orientation: prop("orientation")
          });
          const exec = keyMap[key];
          if (exec) {
            event.preventDefault();
            exec(event);
            return;
          }
        }
      });
    },
    getTriggerState,
    getTriggerProps(props) {
      const { value, disabled } = props;
      const triggerState = getTriggerState(props);
      return normalize.button({
        ...parts.trigger.attrs,
        role: "tab",
        type: "button",
        disabled,
        dir: prop("dir"),
        "data-orientation": prop("orientation"),
        "data-disabled": dataAttr(disabled),
        "aria-disabled": disabled,
        "data-value": value,
        "aria-selected": triggerState.selected,
        "data-selected": dataAttr(triggerState.selected),
        "data-focus": dataAttr(triggerState.focused),
        "aria-controls": triggerState.selected ? getContentId(scope, value) : void 0,
        "data-ownedby": getListId(scope),
        "data-ssr": dataAttr(context.get("ssr")),
        id: getTriggerId(scope, value),
        tabIndex: triggerState.selected && composite ? 0 : -1,
        onFocus() {
          send({ type: "TAB_FOCUS", value });
        },
        onBlur(event) {
          const target = event.relatedTarget;
          if (target?.getAttribute("role") !== "tab") {
            send({ type: "TAB_BLUR" });
          }
        },
        onClick(event) {
          if (event.defaultPrevented) return;
          if (isOpeningInNewTab(event)) return;
          if (disabled) return;
          if (isSafari()) {
            event.currentTarget.focus();
          }
          send({ type: "TAB_CLICK", value });
        }
      });
    },
    getContentProps(props) {
      const { value } = props;
      const selected = context.get("value") === value;
      return normalize.element({
        ...parts.content.attrs,
        dir: prop("dir"),
        id: getContentId(scope, value),
        tabIndex: composite ? 0 : -1,
        "aria-labelledby": getTriggerId(scope, value),
        role: "tabpanel",
        "data-ownedby": getListId(scope),
        "data-selected": dataAttr(selected),
        "data-orientation": prop("orientation"),
        hidden: !selected
      });
    },
    getIndicatorProps() {
      const rect = context.get("indicatorRect");
      const animateIndicator = context.get("animateIndicator");
      return normalize.element({
        id: getIndicatorId(scope),
        ...parts.indicator.attrs,
        dir: prop("dir"),
        "data-orientation": prop("orientation"),
        hidden: isRectEmpty(rect),
        onTransitionEnd(event) {
          if (getEventTarget(event) !== event.currentTarget) return;
          send({ type: "INDICATOR_TRANSITION_END" });
        },
        style: {
          "--transition-property": "left, right, top, bottom, width, height",
          "--left": toPx(rect?.x),
          "--top": toPx(rect?.y),
          "--width": toPx(rect?.width),
          "--height": toPx(rect?.height),
          position: "absolute",
          willChange: animateIndicator ? "var(--transition-property)" : "auto",
          transitionProperty: animateIndicator ? "var(--transition-property)" : "none",
          transitionDuration: animateIndicator ? "var(--transition-duration, 150ms)" : "0ms",
          transitionTimingFunction: "var(--transition-timing-function)",
          [isHorizontal ? "left" : "top"]: isHorizontal ? "var(--left)" : "var(--top)"
        }
      });
    }
  };
}
var isRectEmpty = (rect) => rect == null || rect.width === 0 && rect.height === 0 && rect.x === 0 && rect.y === 0;

// ../node_modules/.pnpm/@zag-js+tabs@1.40.0/node_modules/@zag-js/tabs/dist/tabs.machine.mjs
var { createMachine } = setup();
var machine = createMachine({
  props({ props }) {
    return {
      dir: "ltr",
      orientation: "horizontal",
      activationMode: "automatic",
      loopFocus: true,
      composite: true,
      navigate(details) {
        clickIfLink(details.node);
      },
      defaultValue: null,
      ...props
    };
  },
  initialState() {
    return "idle";
  },
  context({ prop, bindable }) {
    return {
      value: bindable(() => ({
        defaultValue: prop("defaultValue"),
        value: prop("value"),
        onChange(value) {
          prop("onValueChange")?.({ value });
        }
      })),
      focusedValue: bindable(() => ({
        defaultValue: prop("value") || prop("defaultValue"),
        sync: true,
        onChange(value) {
          prop("onFocusChange")?.({ focusedValue: value });
        }
      })),
      ssr: bindable(() => ({ defaultValue: true })),
      indicatorRect: bindable(() => ({
        defaultValue: null
      })),
      animateIndicator: bindable(() => ({
        defaultValue: false
      }))
    };
  },
  refs() {
    return {
      indicatorCleanup: null,
      prevValue: null
    };
  },
  watch({ context, prop, track, action }) {
    track([() => context.get("value")], () => {
      action(["syncIndicatorAnimation", "syncIndicatorRect", "syncTabIndex", "navigateIfNeeded"]);
    });
    track([() => prop("dir"), () => prop("orientation")], () => {
      action(["syncIndicatorRect"]);
    });
  },
  on: {
    SET_VALUE: {
      actions: ["setValue"]
    },
    CLEAR_VALUE: {
      actions: ["clearValue"]
    },
    SET_INDICATOR_RECT: {
      actions: ["setIndicatorRect"]
    },
    SYNC_TAB_INDEX: {
      actions: ["syncTabIndex"]
    },
    INDICATOR_TRANSITION_END: {
      actions: ["clearIndicatorAnimation"]
    }
  },
  entry: ["syncPrevValue", "syncIndicatorRect", "syncTabIndex", "syncSsr"],
  exit: ["cleanupObserver"],
  states: {
    idle: {
      on: {
        TAB_FOCUS: {
          target: "focused",
          actions: ["setFocusedValue"]
        },
        TAB_CLICK: {
          target: "focused",
          actions: ["setFocusedValue", "setValue"]
        }
      }
    },
    focused: {
      on: {
        TAB_CLICK: {
          actions: ["setFocusedValue", "setValue"]
        },
        ARROW_PREV: [
          {
            guard: "selectOnFocus",
            actions: ["focusPrevTab", "selectFocusedTab"]
          },
          {
            actions: ["focusPrevTab"]
          }
        ],
        ARROW_NEXT: [
          {
            guard: "selectOnFocus",
            actions: ["focusNextTab", "selectFocusedTab"]
          },
          {
            actions: ["focusNextTab"]
          }
        ],
        HOME: [
          {
            guard: "selectOnFocus",
            actions: ["focusFirstTab", "selectFocusedTab"]
          },
          {
            actions: ["focusFirstTab"]
          }
        ],
        END: [
          {
            guard: "selectOnFocus",
            actions: ["focusLastTab", "selectFocusedTab"]
          },
          {
            actions: ["focusLastTab"]
          }
        ],
        TAB_FOCUS: {
          actions: ["setFocusedValue"]
        },
        TAB_BLUR: {
          target: "idle",
          actions: ["clearFocusedValue"]
        }
      }
    }
  },
  implementations: {
    guards: {
      selectOnFocus: ({ prop }) => prop("activationMode") === "automatic"
    },
    actions: {
      selectFocusedTab({ context, prop }) {
        raf(() => {
          const focusedValue = context.get("focusedValue");
          if (!focusedValue) return;
          const nullable = prop("deselectable") && context.get("value") === focusedValue;
          const value = nullable ? null : focusedValue;
          context.set("value", value);
        });
      },
      setFocusedValue({ context, event, flush }) {
        if (event.value == null) return;
        flush(() => {
          context.set("focusedValue", event.value);
        });
      },
      clearFocusedValue({ context }) {
        context.set("focusedValue", null);
      },
      setValue({ context, event, prop }) {
        const nullable = prop("deselectable") && context.get("value") === context.get("focusedValue");
        context.set("value", nullable ? null : event.value);
      },
      clearValue({ context }) {
        context.set("value", null);
      },
      focusFirstTab({ scope }) {
        raf(() => {
          getFirstTriggerEl(scope)?.focus();
        });
      },
      focusLastTab({ scope }) {
        raf(() => {
          getLastTriggerEl(scope)?.focus();
        });
      },
      focusNextTab({ context, prop, scope, event }) {
        const focusedValue = event.value ?? context.get("focusedValue");
        if (!focusedValue) return;
        const triggerEl = getNextTriggerEl(scope, {
          value: focusedValue,
          loopFocus: prop("loopFocus")
        });
        raf(() => {
          if (prop("composite")) {
            triggerEl?.focus();
          } else if (triggerEl?.dataset.value != null) {
            context.set("focusedValue", triggerEl.dataset.value);
          }
        });
      },
      focusPrevTab({ context, prop, scope, event }) {
        const focusedValue = event.value ?? context.get("focusedValue");
        if (!focusedValue) return;
        const triggerEl = getPrevTriggerEl(scope, {
          value: focusedValue,
          loopFocus: prop("loopFocus")
        });
        raf(() => {
          if (prop("composite")) {
            triggerEl?.focus();
          } else if (triggerEl?.dataset.value != null) {
            context.set("focusedValue", triggerEl.dataset.value);
          }
        });
      },
      syncTabIndex({ context, scope }) {
        raf(() => {
          const value = context.get("value");
          if (!value) return;
          const contentEl = getContentEl(scope, value);
          if (!contentEl) return;
          const focusables = getFocusables(contentEl);
          if (focusables.length > 0) {
            contentEl.removeAttribute("tabindex");
          } else {
            contentEl.setAttribute("tabindex", "0");
          }
        });
      },
      cleanupObserver({ refs }) {
        const cleanup = refs.get("indicatorCleanup");
        if (cleanup) cleanup();
      },
      setIndicatorRect({ context, event, scope }) {
        const value = event.id ?? context.get("value");
        const indicatorEl = getIndicatorEl(scope);
        if (!indicatorEl) return;
        if (!value) return;
        const triggerEl = getTriggerEl(scope, value);
        if (!triggerEl) return;
        context.set("indicatorRect", getRectByValue(scope, value));
      },
      syncSsr({ context }) {
        context.set("ssr", false);
      },
      syncPrevValue({ context, refs }) {
        refs.set("prevValue", context.get("value"));
      },
      syncIndicatorAnimation({ context, refs }) {
        const prevValue = refs.get("prevValue");
        const nextValue = context.get("value");
        const animate = prevValue != null && nextValue != null && prevValue !== nextValue;
        context.set("animateIndicator", animate);
        refs.set("prevValue", nextValue);
      },
      clearIndicatorAnimation({ context }) {
        context.set("animateIndicator", false);
      },
      syncIndicatorRect({ context, refs, scope }) {
        const cleanup = refs.get("indicatorCleanup");
        if (cleanup) cleanup();
        const indicatorEl = getIndicatorEl(scope);
        if (!indicatorEl) return;
        const exec = () => {
          const triggerEl = getTriggerEl(scope, context.get("value"));
          if (!triggerEl) return;
          const rect = getOffsetRect(triggerEl);
          context.set("indicatorRect", (prev) => isEqual(prev, rect) ? prev : rect);
        };
        exec();
        const triggerEls = getElements(scope);
        const indicatorCleanup = callAll(...triggerEls.map((el) => resizeObserverBorderBox.observe(el, exec)));
        refs.set("indicatorCleanup", indicatorCleanup);
      },
      navigateIfNeeded({ context, prop, scope }) {
        const value = context.get("value");
        if (!value) return;
        const triggerEl = getTriggerEl(scope, value);
        if (isAnchorElement(triggerEl)) {
          prop("navigate")?.({ value, node: triggerEl, href: triggerEl.href });
        }
      }
    }
  }
});

// components/tabs.ts
function tabsDomIds(rootId) {
  return {
    root: `tabs-${rootId}-root`,
    list: `tabs-${rootId}-list`,
    indicator: `tabs-${rootId}-indicator`,
    content: (value) => `tabs-${rootId}-content-${value}`,
    trigger: (value) => `tabs-${rootId}-trigger-${value}`
  };
}
var Tabs = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props) {
    const id = props.id ?? this.el.id;
    return new VanillaMachine(machine, { ...props, id, ids: tabsDomIds(id) });
  }
  updateProps = (attrs) => {
    const props = attrs;
    const id = props.id ?? this.el.id;
    this.machine.updateProps({ ...props, id, ids: tabsDomIds(id) });
  };
  initApi() {
    return this.zagConnect(connect);
  }
  render() {
    const rootEl = this.el.querySelector('[data-scope="tabs"][data-part="root"]');
    if (!rootEl) return;
    this.spreadProps(rootEl, this.api.getRootProps());
    const listEl = rootEl.querySelector(
      ':scope > [data-scope="tabs"][data-part="list"]'
    );
    if (!listEl) return;
    this.spreadProps(listEl, this.api.getListProps());
    const triggers = listEl.querySelectorAll(
      ':scope > [data-scope="tabs"][data-part="trigger"]'
    );
    triggers.forEach((triggerEl) => {
      const value = triggerEl.dataset.value;
      const disabled = triggerEl.dataset.disabled === "";
      if (!value) return;
      this.spreadProps(triggerEl, this.api.getTriggerProps({ value, disabled }));
    });
    const contents = rootEl.querySelectorAll(
      ':scope > [data-scope="tabs"][data-part="content"]'
    );
    contents.forEach((contentEl) => {
      const value = contentEl.dataset.value;
      if (!value) return;
      this.spreadProps(contentEl, this.api.getContentProps({ value }));
    });
  }
};

// hooks/tabs.ts
function tabsValueChangePayload(el, details) {
  return { id: el.id, value: details.value ?? null };
}
function tabsFocusChangePayload(el, details) {
  return { id: el.id, value: details.focusedValue ?? null };
}
function readTabsLayoutProps(el) {
  return {
    orientation: getString(el, "orientation"),
    dir: getDir(el)
  };
}
var TabsHook = {
  mounted() {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
    const tabs = new Tabs(el, {
      id: el.id,
      ...readStringControlledZagProps(el, "value", "defaultValue"),
      ...readTabsLayoutProps(el),
      onValueChange: (details) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: tabsValueChangePayload(el, details),
          serverEventName: getString(el, "onValueChange"),
          clientEventName: getString(el, "onValueChangeClient")
        });
      },
      onFocusChange: (details) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: tabsFocusChangePayload(el, details),
          serverEventName: getString(el, "onFocusChange"),
          clientEventName: getString(el, "onFocusChangeClient")
        });
      }
    });
    tabs.init();
    this.tabs = tabs;
    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;
    domRegistry.add("corex:tabs:set-value", (event) => {
      tabs.api.setValue(event.detail.value);
    });
    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;
    registry.add("tabs_set_value", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      tabs.api.setValue(payload.value);
    });
    registry.add("tabs_value", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (!canPush()) return;
      this.pushEvent("tabs_value_response", {
        id: el.id,
        value: tabs.api.value
      });
    });
    registry.add("tabs_focused_value", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (!canPush()) return;
      this.pushEvent("tabs_focused_value_response", {
        id: el.id,
        value: tabs.api.focusedValue
      });
    });
  },
  updated() {
    this.tabs?.updateProps({
      id: this.el.id,
      ...readStringControlledZagUpdate(this.el, "value", "defaultValue"),
      ...readTabsLayoutProps(this.el)
    });
  },
  destroyed() {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.tabs?.destroy();
  }
};
export {
  TabsHook as Tabs,
  readTabsLayoutProps,
  tabsFocusChangePayload,
  tabsValueChangePayload
};
