import {
  toPx
} from "./chunks/chunk-AJX2XHOK.mjs";
import {
  trackDismissableElement
} from "./chunks/chunk-4ATAXYH3.mjs";
import "./chunks/chunk-AVGG6QG4.mjs";
import {
  createAnatomy
} from "./chunks/chunk-YMOPD357.mjs";
import {
  Component,
  VanillaMachine,
  addDomEvent,
  callAll,
  canPushEvent,
  contains,
  createZagLiveHook,
  dataAttr,
  ensureProps,
  getByOwnerId,
  getDir,
  getString,
  getTabbables,
  getWindow,
  isSelfTarget,
  navigate,
  queryAll,
  raf,
  setup,
  visuallyHiddenStyle
} from "./chunks/chunk-R62PCG6O.mjs";

// ../node_modules/.pnpm/@zag-js+navigation-menu@1.43.3/node_modules/@zag-js/navigation-menu/dist/navigation-menu.anatomy.mjs
var anatomy = createAnatomy("navigation-menu").parts(
  "root",
  "viewportPositioner",
  "viewport",
  "trigger",
  "content",
  "list",
  "item",
  "link",
  "indicator",
  "itemIndicator",
  "arrow"
);
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+navigation-menu@1.43.3/node_modules/@zag-js/navigation-menu/dist/navigation-menu.dom.mjs
var getRootId = (ctx) => ctx.ids?.root ?? `nav-menu:${ctx.id}`;
var getTriggerId = (ctx, value) => ctx.ids?.trigger?.(value) ?? `nav-menu:${ctx.id}:trigger:${value}`;
var getTriggerProxyId = (ctx, value) => ctx.ids?.triggerProxy?.(value) ?? `nav-menu:${ctx.id}:trigger-proxy:${value}`;
var getContentId = (ctx, value) => ctx.ids?.content?.(value) ?? `nav-menu:${ctx.id}:content:${value}`;
var getViewportId = (ctx) => ctx.ids?.viewport ?? `nav-menu:${ctx.id}:viewport`;
var getListId = (ctx) => ctx.ids?.list ?? `nav-menu:${ctx.id}:list`;
var getItemId = (ctx, value) => ctx.ids?.item?.(value) ?? `nav-menu:${ctx.id}:item:${value}`;
var getRootEl = (ctx) => ctx.getById(getRootId(ctx));
var getViewportEl = (ctx) => ctx.getById(getViewportId(ctx));
var getTriggerEl = (ctx, value) => {
  if (!value) return null;
  return ctx.getById(getTriggerId(ctx, value));
};
var getTriggerProxyEl = (ctx, value) => {
  if (!value) return null;
  return ctx.getById(getTriggerProxyId(ctx, value));
};
var getListEl = (ctx) => ctx.getById(getListId(ctx));
var getContentEl = (ctx, value) => {
  if (!value) return null;
  return ctx.getById(getContentId(ctx, value));
};
var getContentEls = (ctx) => queryAll(ctx.getDoc(), `[data-scope=navigation-menu][data-part=content][data-uid='${ctx.id}']`);
var getTabbableEls = (ctx, value) => {
  return getTabbables(getContentEl(ctx, value));
};
var getTriggerEls = (ctx) => queryAll(getListEl(ctx), `[data-part=trigger][data-uid='${ctx.id}']`);
var getLinkEls = (ctx, value) => {
  const contentEl = getContentEl(ctx, value);
  return queryAll(contentEl, `[data-part=link]${getByOwnerId(getContentId(ctx, value))}`);
};
var getElements = (ctx) => {
  const topLevelTriggerSelector = `[data-part=trigger][data-uid='${ctx.id}']:not([data-disabled])`;
  const topLevelLinkSelector = `[data-part=item] > [data-part=link]`;
  return queryAll(getListEl(ctx), `${topLevelTriggerSelector}, ${topLevelLinkSelector}`);
};
function trackResizeObserver(element, onResize) {
  if (!element.length) return;
  let frame = 0;
  const win = getWindow(element[0]);
  const obs = new win.ResizeObserver(() => {
    cancelAnimationFrame(frame);
    frame = requestAnimationFrame(onResize);
  });
  element.forEach((el) => {
    if (el) obs.observe(el);
  });
  return () => {
    cancelAnimationFrame(frame);
    element.forEach((el) => {
      if (el) obs.unobserve(el);
    });
  };
}
function setMotionAttr(scope, value, previousValue) {
  const triggers = getTriggerEls(scope);
  const dir = triggers[0].dir;
  let values = triggers.map((trigger) => trigger.getAttribute("data-value"));
  if (dir === "rtl") values.reverse();
  const index = values.indexOf(value);
  const prevIndex = values.indexOf(previousValue);
  const contentEls = getContentEls(scope);
  contentEls.forEach((contentEl) => {
    const itemValue = contentEl.dataset.value;
    const selected = value === itemValue;
    const prevSelected = prevIndex === values.indexOf(itemValue);
    if (!selected && !prevSelected) {
      delete contentEl.dataset.motion;
      return;
    }
    const attribute = (() => {
      if (index !== prevIndex) {
        if (selected && prevIndex !== -1) return index > prevIndex ? "from-end" : "from-start";
        if (prevSelected && index !== -1) return index > prevIndex ? "to-start" : "to-end";
      }
      return null;
    })();
    if (attribute) {
      contentEl.dataset.motion = attribute;
    } else {
      delete contentEl.dataset.motion;
    }
  });
}
function focusFirst(scope, candidates) {
  const previouslyFocusedElement = scope.getActiveElement();
  return candidates.some((candidate) => {
    if (candidate === previouslyFocusedElement) return true;
    candidate.focus();
    return scope.getActiveElement() !== previouslyFocusedElement;
  });
}
function removeFromTabOrder(candidates) {
  candidates.forEach((candidate) => {
    candidate.dataset.tabindex = candidate.getAttribute("tabindex") || "";
    candidate.setAttribute("tabindex", "-1");
  });
  return () => {
    candidates.forEach((candidate) => {
      const prevTabIndex = candidate.dataset.tabindex;
      candidate.setAttribute("tabindex", prevTabIndex);
    });
  };
}

// ../node_modules/.pnpm/@zag-js+navigation-menu@1.43.3/node_modules/@zag-js/navigation-menu/dist/navigation-menu.connect.mjs
function connect(service, normalize) {
  const { context, send, prop, scope } = service;
  const translations = prop("translations");
  const triggerRect = context.get("triggerRect");
  const viewportSize = context.get("viewportSize");
  const viewportPosition = context.get("viewportPosition");
  const value = context.get("value");
  const previousValue = context.get("previousValue");
  const open = Boolean(value);
  const isViewportRendered = context.get("isViewportRendered");
  const preventTransition = value && !previousValue;
  function getItemState(props) {
    const selected = value === props.value;
    const wasSelected = !value && previousValue === props.value;
    return {
      itemId: getItemId(scope, props.value),
      triggerId: getTriggerId(scope, props.value),
      triggerProxyId: getTriggerProxyId(scope, props.value),
      contentId: getContentId(scope, props.value),
      selected,
      wasSelected,
      open: selected || wasSelected,
      disabled: !!props.disabled
    };
  }
  return {
    open,
    value,
    orientation: prop("orientation"),
    isViewportRendered,
    getViewportNode() {
      return getViewportEl(scope);
    },
    setValue(value2) {
      send({ type: "VALUE.SET", value: value2 });
    },
    reposition() {
      send({ type: "VIEWPORT.POSITION" });
    },
    getRootProps() {
      return normalize.element({
        ...parts.root.attrs,
        id: getRootId(scope),
        "aria-label": translations?.rootLabel,
        "data-orientation": prop("orientation"),
        dir: prop("dir"),
        style: {
          "--trigger-width": toPx(triggerRect?.width),
          "--trigger-height": toPx(triggerRect?.height),
          "--trigger-x": toPx(triggerRect?.x),
          "--trigger-y": toPx(triggerRect?.y),
          "--viewport-width": toPx(viewportSize?.width),
          "--viewport-height": toPx(viewportSize?.height),
          "--viewport-x": toPx(viewportPosition?.x),
          "--viewport-y": toPx(viewportPosition?.y)
        }
      });
    },
    getListProps() {
      return normalize.element({
        ...parts.list.attrs,
        id: getListId(scope),
        dir: prop("dir"),
        "data-orientation": prop("orientation"),
        style: { position: "relative" }
      });
    },
    getItemProps(props) {
      const itemState = getItemState(props);
      return normalize.element({
        ...parts.item.attrs,
        id: itemState.itemId,
        dir: prop("dir"),
        "data-value": props.value,
        "data-state": itemState.open ? "open" : "closed",
        "data-orientation": prop("orientation"),
        "data-disabled": dataAttr(itemState.disabled),
        onKeyDown(event) {
          switch (event.key) {
            case "ArrowDown":
            case "ArrowUp":
            case "ArrowLeft":
            case "ArrowRight":
            case "Home":
            case "End": {
              send({ type: "ITEM.NAVIGATE", value: props.value, key: event.key });
              event.preventDefault();
              event.stopPropagation();
              break;
            }
            default:
              break;
          }
        }
      });
    },
    getIndicatorProps() {
      return normalize.element({
        ...parts.indicator.attrs,
        "aria-hidden": true,
        dir: prop("dir"),
        hidden: !open,
        "data-state": open ? "open" : "closed",
        "data-orientation": prop("orientation"),
        style: {
          position: "absolute",
          transition: preventTransition ? "none" : void 0
        }
      });
    },
    getArrowProps() {
      return normalize.element({
        ...parts.arrow.attrs,
        "aria-hidden": true,
        dir: prop("dir"),
        "data-orientation": prop("orientation")
      });
    },
    getTriggerProps(props) {
      const itemState = getItemState(props);
      return normalize.button({
        ...parts.trigger.attrs,
        id: itemState.triggerId,
        type: "button",
        "data-uid": prop("id"),
        "data-trigger-proxy-id": getTriggerProxyId(scope, props.value),
        dir: prop("dir"),
        disabled: itemState.disabled,
        "data-value": props.value,
        "data-state": itemState.selected ? "open" : "closed",
        "data-disabled": dataAttr(itemState.disabled),
        "aria-controls": itemState.contentId,
        "aria-expanded": itemState.selected,
        onPointerEnter(event) {
          if (prop("disableHoverTrigger")) return;
          if (event.pointerType !== "mouse") return;
          if (itemState.disabled) return;
          send({ type: "TRIGGER.POINTERENTER", value: props.value });
        },
        onPointerLeave(event) {
          if (prop("disableHoverTrigger")) return;
          if (event.pointerType !== "mouse") return;
          if (itemState.disabled) return;
          send({ type: "TRIGGER.POINTERLEAVE", value: props.value });
        },
        onClick() {
          if (prop("disableClickTrigger")) return;
          send({ type: "TRIGGER.CLICK", value: props.value });
        },
        onKeyDown(event) {
          const verticalEntryKey = prop("dir") === "rtl" ? "ArrowLeft" : "ArrowRight";
          const entryKey = {
            horizontal: "ArrowDown",
            vertical: verticalEntryKey
          }[prop("orientation")];
          if (open && event.key === entryKey) {
            send({ type: "CONTENT.FOCUS", side: "start" });
            event.preventDefault();
            event.stopPropagation();
            return;
          }
          const elements = getElements(scope);
          const currentElement = event.currentTarget;
          const nextElement = navigate(elements, currentElement, {
            key: event.key,
            orientation: prop("orientation"),
            dir: prop("dir"),
            loop: false
          });
          if (nextElement) {
            nextElement.focus();
            event.preventDefault();
            event.stopPropagation();
          }
        }
      });
    },
    getTriggerProxyProps(props) {
      const itemState = getItemState(props);
      return normalize.element({
        "aria-hidden": true,
        tabIndex: 0,
        "data-trigger-proxy": "",
        id: itemState.triggerProxyId,
        "data-trigger-id": itemState.triggerId,
        hidden: !itemState.selected,
        style: visuallyHiddenStyle,
        onFocus(event) {
          const contentEl = getContentEl(scope, props.value);
          if (!contentEl) return;
          const prevFocusedEl = event.relatedTarget;
          const wasTriggerFocused = prevFocusedEl === getTriggerEl(scope, props.value);
          const wasFocusFromContent = contains(contentEl, prevFocusedEl);
          if (wasTriggerFocused || !wasFocusFromContent) {
            send({ type: "CONTENT.FOCUS", side: wasTriggerFocused ? "start" : "end" });
          }
        }
      });
    },
    getViewportProxyProps(props) {
      const itemState = getItemState(props);
      if (!itemState.selected || !isViewportRendered) {
        return { hidden: true };
      }
      return normalize.element({
        "aria-owns": getContentId(scope, props.value)
      });
    },
    getLinkProps(props) {
      const { closeOnClick = true } = props;
      return normalize.element({
        ...parts.link.attrs,
        dir: prop("dir"),
        "data-value": props.value,
        "data-current": dataAttr(props.current),
        "aria-current": props.current ? "page" : void 0,
        "data-ownedby": getContentId(scope, props.value),
        onClick(event) {
          const target = event.currentTarget;
          const win = getWindow(target);
          const onSelect = props.onSelect;
          target.addEventListener("link.select", onSelect, { once: true });
          const linkSelectEvent = new win.CustomEvent("link.select", {
            bubbles: true,
            cancelable: true,
            detail: { originalEvent: event }
          });
          target.dispatchEvent(linkSelectEvent);
          if (closeOnClick && !linkSelectEvent.defaultPrevented && !event.metaKey) {
            send({ type: "CLOSE" });
          }
        },
        onKeyDown(event) {
          const currentElement = event.currentTarget;
          const contentEl = currentElement.closest('[data-scope="navigation-menu"][data-part="content"]');
          const elements = contentEl ? getLinkEls(scope, props.value) : getElements(scope);
          const nextElement = navigate(elements, currentElement, {
            key: event.key,
            orientation: prop("orientation"),
            dir: prop("dir"),
            loop: false
          });
          if (nextElement) {
            nextElement.focus();
            event.preventDefault();
            event.stopPropagation();
          }
        }
      });
    },
    getContentProps(props) {
      const itemState = getItemState(props);
      const currentValue = context.get("value") || context.get("previousValue");
      const selected = isViewportRendered ? currentValue === props.value : itemState.selected;
      return normalize.element({
        ...parts.content.attrs,
        id: itemState.contentId,
        dir: prop("dir"),
        hidden: !selected,
        "aria-labelledby": itemState.triggerId,
        "data-uid": prop("id"),
        "data-state": selected ? "open" : "closed",
        "data-orientation": prop("orientation"),
        "data-value": props.value,
        onPointerEnter(event) {
          if (event.pointerType !== "mouse") return;
          send({ type: "CONTENT.POINTERENTER", value: props.value });
        },
        onPointerLeave(event) {
          if (event.pointerType !== "mouse") return;
          send({ type: "CONTENT.POINTERLEAVE", value: props.value });
        },
        onKeyDown(event) {
          if (event.defaultPrevented) return;
          if (event.currentTarget.closest("[data-scope=navigation-menu][data-part=root]") !== getRootEl(scope))
            return;
          const isMetaKey = event.altKey || event.ctrlKey || event.metaKey;
          const isTabKey = event.key === "Tab" && !isMetaKey;
          const candidates = getTabbables(event.currentTarget);
          if (isTabKey) {
            const focusedElement = scope.getActiveElement();
            const index = candidates.findIndex((candidate) => candidate === focusedElement);
            const isMovingBackwards = event.shiftKey;
            const nextCandidates = isMovingBackwards ? candidates.slice(0, index).reverse() : candidates.slice(index + 1, candidates.length);
            if (focusFirst(scope, nextCandidates)) {
              event.preventDefault();
            } else {
              getTriggerProxyEl(scope, props.value)?.focus();
              return;
            }
          }
          if (!isSelfTarget(event)) return;
          const el = navigate(candidates, scope.getActiveElement(), {
            key: event.key,
            dir: prop("dir"),
            loop: false
          });
          if (el) {
            el.focus();
            event.preventDefault();
            event.stopPropagation();
          }
        }
      });
    },
    getViewportPositionerProps(props = {}) {
      const { align = "center" } = props;
      return normalize.element({
        ...parts.viewportPositioner.attrs,
        dir: prop("dir"),
        "data-orientation": prop("orientation"),
        "data-align": align
      });
    },
    getViewportProps(props = {}) {
      const { align = "center" } = props;
      const open2 = Boolean(value);
      return normalize.element({
        ...parts.viewport.attrs,
        id: getViewportId(scope),
        dir: prop("dir"),
        hidden: !open2,
        "data-state": open2 ? "open" : "closed",
        "data-orientation": prop("orientation"),
        "data-align": align,
        style: {
          transition: preventTransition ? "none" : void 0,
          pointerEvents: !open2 ? "none" : void 0,
          "--viewport-width": toPx(viewportSize?.width),
          "--viewport-height": toPx(viewportSize?.height),
          "--viewport-x": toPx(viewportPosition?.x),
          "--viewport-y": toPx(viewportPosition?.y)
        },
        onPointerEnter() {
          send({ type: "CONTENT.POINTERENTER" });
        },
        onPointerLeave(event) {
          if (prop("disablePointerLeaveClose")) return;
          if (event.pointerType !== "mouse") return;
          send({ type: "CONTENT.POINTERLEAVE" });
        }
      });
    },
    getItemState,
    getItemIndicatorProps(props) {
      const itemState = getItemState(props);
      return normalize.element({
        ...parts.itemIndicator.attrs,
        "aria-hidden": true,
        dir: prop("dir"),
        hidden: !itemState.selected,
        "data-state": itemState.selected ? "open" : "closed",
        "data-orientation": prop("orientation"),
        "data-value": props.value
      });
    }
  };
}

// ../node_modules/.pnpm/@zag-js+navigation-menu@1.43.3/node_modules/@zag-js/navigation-menu/dist/navigation-menu.utils.mjs
function setCloseTimeout(refs, context, prop) {
  clearCloseTimeout(refs);
  const closeTimeoutId = window.setTimeout(() => {
    context.set("value", "");
  }, prop("closeDelay"));
  refs.set("closeTimeoutId", closeTimeoutId);
}
function clearCloseTimeout(refs) {
  const closeTimeoutId = refs.get("closeTimeoutId");
  if (closeTimeoutId) {
    clearTimeout(closeTimeoutId);
    refs.set("closeTimeoutId", null);
  }
}
function setOpenTimeout(refs, value, timeoutId) {
  const openTimeoutIds = refs.get("openTimeoutIds");
  refs.set("openTimeoutIds", {
    ...openTimeoutIds,
    [value]: timeoutId
  });
}
function clearOpenTimeout(refs, value) {
  const openTimeoutIds = refs.get("openTimeoutIds");
  const timeoutId = openTimeoutIds[value];
  if (timeoutId) {
    clearTimeout(timeoutId);
    const { [value]: _, ...rest } = openTimeoutIds;
    refs.set("openTimeoutIds", rest);
  }
}
function clearAllOpenTimeouts(refs) {
  const openTimeoutIds = refs.get("openTimeoutIds");
  Object.values(openTimeoutIds).forEach((timeoutId) => {
    if (timeoutId) clearTimeout(timeoutId);
  });
  refs.set("openTimeoutIds", {});
}

// ../node_modules/.pnpm/@zag-js+navigation-menu@1.43.3/node_modules/@zag-js/navigation-menu/dist/navigation-menu.machine.mjs
var { createMachine } = setup();
var machine = createMachine({
  props({ props }) {
    ensureProps(props, ["id"]);
    return {
      dir: "ltr",
      openDelay: 200,
      closeDelay: 300,
      orientation: "horizontal",
      defaultValue: "",
      ...props
    };
  },
  context({ prop, bindable }) {
    return {
      // value tracking
      value: bindable(() => ({
        defaultValue: prop("defaultValue"),
        value: prop("value"),
        sync: true,
        onChange(value) {
          prop("onValueChange")?.({ value });
        }
      })),
      previousValue: bindable(() => ({
        defaultValue: "",
        sync: true
      })),
      // viewport
      viewportSize: bindable(() => ({
        defaultValue: null,
        sync: true
      })),
      isViewportRendered: bindable(() => ({
        defaultValue: false
      })),
      viewportPosition: bindable(() => ({
        defaultValue: null
      })),
      // nodes
      contentNode: bindable(() => ({
        defaultValue: null
      })),
      triggerRect: bindable(() => ({
        defaultValue: null,
        sync: true
      })),
      triggerNode: bindable(() => ({
        defaultValue: null
      }))
    };
  },
  computed: {
    open: ({ context }) => context.get("value") != null
  },
  watch({ track, action, context }) {
    track([() => context.get("value")], () => {
      action(["restoreTabOrder", "setTriggerNode", "syncContentNode", "syncMotionAttribute"]);
    });
  },
  refs() {
    return {
      restoreContentTabOrder: void 0,
      contentResizeObserverCleanup: void 0,
      contentDismissableCleanup: void 0,
      contentExitCompleteCleanup: void 0,
      triggerResizeObserverCleanup: void 0,
      closeTimeoutId: null,
      openTimeoutIds: {}
    };
  },
  entry: ["checkViewportNode"],
  exit: ["cleanupObservers"],
  effects: ["trackDocumentResize"],
  initialState() {
    return "idle";
  },
  on: {
    "VALUE.SET": {
      actions: ["setValue"]
    },
    "VIEWPORT.POSITION": {
      actions: ["setViewportPosition"]
    },
    "TRIGGER.POINTERENTER": {
      actions: ["clearCloseTimeout", "setValueWithDelay"]
    },
    "TRIGGER.POINTERLEAVE": [
      {
        actions: ["setCloseTimeout", "resetValueWithDelay"]
      }
    ],
    "TRIGGER.CLICK": [
      {
        guard: "isItemOpen",
        actions: ["deselectValue"]
      },
      {
        actions: ["selectValue"]
      }
    ],
    "CONTENT.FOCUS": {
      actions: ["restoreTabOrder", "focusFirstTabbableEl"]
    },
    "CONTENT.BLUR": {
      actions: ["removeFromTabOrder"]
    },
    "CONTENT.POINTERENTER": {
      actions: ["clearCloseTimeout"]
    },
    "CONTENT.POINTERLEAVE": {
      actions: ["setCloseTimeout"]
    },
    "ITEM.NAVIGATE": {
      actions: ["focusNextLink"]
    },
    "ITEM.CLOSE": {
      actions: ["focusTrigger", "deselectValue"]
    },
    CLOSE: {
      actions: ["clearAllOpenTimeouts", "deselectValue", "focusTriggerIfNeeded", "removeFromTabOrder"]
    }
  },
  states: {
    idle: {}
  },
  implementations: {
    guards: {
      isItemOpen: ({ context, event }) => context.get("value") === event.value
    },
    effects: {
      trackDocumentResize({ scope, send }) {
        const doc = scope.getDoc();
        return trackResizeObserver([doc.body, getRootEl(scope)], () => {
          send({ type: "VIEWPORT.POSITION" });
        });
      }
    },
    actions: {
      setValue({ context, event }) {
        context.set("value", event.value);
      },
      clearCloseTimeout({ refs }) {
        clearCloseTimeout(refs);
      },
      clearAllOpenTimeouts({ refs }) {
        clearAllOpenTimeouts(refs);
      },
      setCloseTimeout({ refs, context, prop }) {
        setCloseTimeout(refs, context, prop);
      },
      resetValueWithDelay({ event, refs }) {
        clearOpenTimeout(refs, event.value);
      },
      setValueWithDelay({ event, prop, context, refs }) {
        const shouldSkipDelay = context.get("value") !== "";
        const openTimeoutId = window.setTimeout(
          () => {
            setTimeout(() => {
              context.set("previousValue", context.get("value"));
              context.set("value", event.value);
            });
          },
          shouldSkipDelay ? 0 : prop("openDelay")
        );
        setOpenTimeout(refs, event.value, openTimeoutId);
      },
      selectValue: ({ context, event }) => {
        context.set("previousValue", context.get("value"));
        context.set("value", event.value);
      },
      deselectValue: ({ context }) => {
        context.set("value", "");
        context.set("previousValue", "");
      },
      syncContentNode({ context, scope, refs, send }) {
        refs.get("contentResizeObserverCleanup")?.();
        refs.get("contentDismissableCleanup")?.();
        refs.get("contentExitCompleteCleanup")?.();
        const previousValue = context.get("previousValue");
        if (previousValue) {
          const previousContentEl = getContentEl(scope, previousValue);
          const viewportEl = getViewportEl(scope);
          if (previousContentEl) {
            const onExitComplete = () => context.set("previousValue", "");
            refs.set(
              "contentExitCompleteCleanup",
              callAll(
                addDomEvent(previousContentEl, "exitcomplete", onExitComplete),
                addDomEvent(viewportEl, "exitcomplete", onExitComplete)
              )
            );
          }
        }
        const contentEl = getContentEl(scope, context.get("value"));
        if (!contentEl) return;
        context.set("contentNode", contentEl);
        if (context.get("isViewportRendered")) {
          const contentResizeObserver = trackResizeObserver([contentEl], () => {
            const contentEl2 = getContentEl(scope, context.get("value"));
            if (!contentEl2) return;
            context.set("viewportSize", { width: contentEl2.offsetWidth, height: contentEl2.offsetHeight });
            send({ type: "VIEWPORT.POSITION" });
          });
          refs.set("contentResizeObserverCleanup", contentResizeObserver);
        }
        const getContentEl2 = () => {
          return getViewportEl(scope) || getContentEl(scope, context.get("value"));
        };
        const contentDismissable = trackDismissableElement(getContentEl2, {
          defer: true,
          onFocusOutside(event) {
            const target = event.detail.target;
            if (target.matches("[data-scope=navigation-menu][data-part=trigger]") || target.matches("[data-trigger-proxy]")) {
              event.preventDefault();
            }
            if (!event.defaultPrevented) {
              send({ type: "CONTENT.BLUR" });
              if (contains(getRootEl(scope), target)) {
                event.preventDefault();
              }
            }
          },
          onPointerDownOutside(event) {
            const target = event.detail.target;
            if (!event.defaultPrevented) {
              const isTrigger = getTriggerEls(scope).some((node) => node.contains(target));
              const isRootViewport = contains(getViewportEl(scope), target);
              if (isTrigger || isRootViewport) {
                event.preventDefault();
              }
            }
          },
          onDismiss() {
            send({ type: "CLOSE", value: context.get("value") });
          }
        });
        refs.set("contentDismissableCleanup", contentDismissable);
      },
      setTriggerNode({ context, scope, refs }) {
        refs.get("triggerResizeObserverCleanup")?.();
        const node = getTriggerEl(scope, context.get("value"));
        if (!node) return;
        context.set("triggerNode", node);
        const exec = () => {
          const rect = { x: node.offsetLeft, y: node.offsetTop, width: node.offsetWidth, height: node.offsetHeight };
          context.set("triggerRect", rect);
        };
        const listEl = getListEl(scope);
        const triggerResizeObserver = trackResizeObserver([node, listEl], exec);
        refs.set("triggerResizeObserverCleanup", triggerResizeObserver);
      },
      syncMotionAttribute({ context, scope }) {
        if (!context.get("isViewportRendered")) return;
        setMotionAttr(scope, context.get("value"), context.get("previousValue"));
      },
      focusFirstTabbableEl({ event, scope, context }) {
        raf(() => {
          const value = event.value || context.get("value");
          const candidates = getTabbableEls(scope, value);
          const elements = event.side === "start" ? candidates : candidates.reverse();
          if (elements.length) focusFirst(scope, elements);
        });
      },
      focusNextLink({ event, scope }) {
        const activeEl = scope.getActiveElement();
        const linkEls = getLinkEls(scope, event.value);
        if (activeEl == null || !linkEls.includes(activeEl)) return;
        const el = navigate(linkEls, activeEl, { key: event.key, loop: false });
        el?.focus();
      },
      focusTrigger({ scope, event, context }) {
        const value = event.value ?? context.get("value");
        getTriggerEl(scope, value)?.focus();
      },
      focusTriggerIfNeeded({ event, scope }) {
        const value = event.value;
        const contentEl = getContentEl(scope, value);
        if (!contains(contentEl, scope.getActiveElement())) return;
        getTriggerEl(scope, value)?.focus();
      },
      removeFromTabOrder({ event, scope, refs, context }) {
        const value = event.value ?? context.get("value");
        const candidates = getTabbableEls(scope, value);
        if (candidates.length) refs.set("restoreContentTabOrder", removeFromTabOrder(candidates));
      },
      restoreTabOrder({ refs }) {
        refs.get("restoreContentTabOrder")?.();
      },
      cleanupObservers({ refs }) {
        refs.get("contentResizeObserverCleanup")?.();
        refs.get("contentDismissableCleanup")?.();
        refs.get("triggerResizeObserverCleanup")?.();
        refs.get("restoreContentTabOrder")?.();
        refs.get("contentExitCompleteCleanup")?.();
      },
      checkViewportNode({ context, scope }) {
        context.set("isViewportRendered", !!getViewportEl(scope));
      },
      setViewportPosition({ context, scope }) {
        const triggerNode = context.get("triggerNode");
        const contentNode = context.get("contentNode");
        const rootEl = getRootEl(scope);
        const doc = scope.getDoc();
        const viewportEl = getViewportEl(scope);
        const align = viewportEl?.dataset.align || "center";
        if (contentNode && triggerNode && rootEl) {
          const bodyWidth = doc.documentElement.offsetWidth;
          const bodyHeight = doc.documentElement.offsetHeight;
          const rootRect = rootEl.getBoundingClientRect();
          const triggerRect = triggerNode.getBoundingClientRect();
          const { offsetWidth, offsetHeight } = contentNode;
          const startPositionLeft = triggerRect.left - rootRect.left;
          const startPositionTop = triggerRect.top - rootRect.top;
          let x = null;
          let y = null;
          switch (align) {
            case "start":
              x = startPositionLeft;
              y = startPositionTop;
              break;
            case "end":
              x = startPositionLeft - offsetWidth + triggerRect.width;
              y = startPositionTop - offsetHeight + triggerRect.height;
              break;
            default:
              x = startPositionLeft - offsetWidth / 2 + triggerRect.width / 2;
              y = startPositionTop - offsetHeight / 2 + triggerRect.height / 2;
          }
          const screenOffset = 10;
          if (x + rootRect.left < screenOffset) {
            x = screenOffset - rootRect.left;
          }
          const rightOffset = x + rootRect.left + offsetWidth;
          if (rightOffset > bodyWidth - screenOffset) {
            x -= rightOffset - bodyWidth + screenOffset;
            if (x < screenOffset - rootRect.left) {
              x = screenOffset - rootRect.left;
            }
          }
          if (y + rootRect.top < screenOffset) {
            y = screenOffset - rootRect.top;
          }
          const bottomOffset = y + rootRect.top + offsetHeight;
          if (bottomOffset > bodyHeight - screenOffset) {
            y -= bottomOffset - bodyHeight + screenOffset;
            if (y < screenOffset - rootRect.top) {
              y = screenOffset - rootRect.top;
            }
          }
          x = Math.round(x);
          y = Math.round(y);
          context.set("viewportPosition", { x, y });
        }
      }
    }
  }
});

// components/navigation-menu.ts
var NavigationMenu = class extends Component {
  initMachine(props) {
    return new VanillaMachine(machine, props);
  }
  initApi() {
    return this.zagConnect(connect);
  }
  render() {
    const root = this.el.querySelector('[data-scope="navigation-menu"][data-part="root"]') ?? this.el;
    this.spreadProps(root, this.api.getRootProps());
    const list = this.el.querySelector(
      '[data-scope="navigation-menu"][data-part="list"]'
    );
    if (list) this.spreadProps(list, this.api.getListProps());
    this.el.querySelectorAll('[data-scope="navigation-menu"][data-part="item"]').forEach((item) => {
      const value = item.dataset.value;
      if (!value) return;
      this.spreadProps(item, this.api.getItemProps({ value }));
    });
    this.el.querySelectorAll('[data-scope="navigation-menu"][data-part="trigger"]').forEach((trigger) => {
      const value = trigger.dataset.value;
      if (!value) return;
      this.spreadProps(trigger, this.api.getTriggerProps({ value }));
    });
    this.el.querySelectorAll('[data-scope="navigation-menu"][data-part="link"]').forEach((link) => {
      const value = link.dataset.value;
      if (!value) return;
      this.spreadProps(link, this.api.getLinkProps({ value }));
    });
    this.el.querySelectorAll('[data-scope="navigation-menu"][data-part="content"]').forEach((content) => {
      const value = content.dataset.value;
      if (!value) return;
      this.spreadProps(content, this.api.getContentProps({ value }));
    });
    const viewport = this.el.querySelector(
      '[data-scope="navigation-menu"][data-part="viewport"]'
    );
    if (viewport) this.spreadProps(viewport, this.api.getViewportProps());
  }
};

// hooks/navigation-menu.ts
function navigationMenuProps(el, hook) {
  const onValueChange = (details) => {
    const eventName = getString(el, "onValueChange");
    if (eventName && canPushEvent(hook.liveSocket)) {
      hook.pushEvent(eventName, { id: el.id, value: details.value });
    }
    const client = getString(el, "onValueChangeClient");
    if (client) {
      el.dispatchEvent(
        new CustomEvent(client, { bubbles: true, detail: { id: el.id, value: details.value } })
      );
    }
  };
  return {
    id: el.id,
    dir: getDir(el),
    defaultValue: getString(el, "value"),
    onValueChange
  };
}
var NavigationMenuHook = createZagLiveHook({
  key: "navigation-menu",
  mount(hook) {
    return new NavigationMenu(hook.el, navigationMenuProps(hook.el, hook));
  },
  update(hook, inst) {
    inst.updateProps(navigationMenuProps(hook.el, hook));
  }
});
export {
  NavigationMenuHook as NavigationMenu
};
