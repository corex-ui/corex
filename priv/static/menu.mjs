import {
  getPlacement,
  getPlacementSide,
  getPlacementStyles,
  readPositioningOptions
} from "./chunks/chunk-5ZLJUF5L.mjs";
import {
  trackDismissableElement
} from "./chunks/chunk-ZZR3S6PP.mjs";
import "./chunks/chunk-K2P3QAIZ.mjs";
import {
  performRedirect,
  readDomItemRedirect
} from "./chunks/chunk-FOQSALVP.mjs";
import {
  createRect,
  getRectCorners
} from "./chunks/chunk-QB2YSZP6.mjs";
import {
  getInteractionModality,
  setInteractionModality,
  trackFocusVisible
} from "./chunks/chunk-MG52DTQN.mjs";
import {
  Component,
  VanillaMachine,
  addDomEvent,
  ariaAttr,
  callAll,
  canPushEvent,
  cast,
  clickIfLink,
  contains,
  createAnatomy,
  createGuards,
  createMachine,
  dataAttr,
  first,
  getBoolean,
  getByTypeahead,
  getDir,
  getEventKey,
  getEventPoint,
  getEventTarget,
  getInitialFocus,
  getString,
  getWindow,
  hasProp,
  isAnchorElement,
  isContextMenuEvent,
  isDownloadingEvent,
  isEditableElement,
  isEqual,
  isFunction,
  isHTMLElement,
  isModifierKey,
  isOpeningInNewTab,
  isPrintableKey,
  isString,
  isValidTabEvent,
  last,
  next,
  observeAttributes,
  prev,
  queryAll,
  raf,
  scrollIntoView
} from "./chunks/chunk-LTYT3NRU.mjs";

// ../node_modules/.pnpm/@zag-js+menu@1.40.0/node_modules/@zag-js/menu/dist/menu.anatomy.mjs
var anatomy = createAnatomy("menu").parts(
  "arrow",
  "arrowTip",
  "content",
  "contextTrigger",
  "indicator",
  "item",
  "itemGroup",
  "itemGroupLabel",
  "itemIndicator",
  "itemText",
  "positioner",
  "separator",
  "trigger",
  "triggerItem"
);
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+core@1.40.0/node_modules/@zag-js/core/dist/merge-props.mjs
var clsx = (...args) => args.map((str) => str?.trim?.()).filter(Boolean).join(" ");
var CSS_REGEX = /((?:--)?(?:\w+-?)+)\s*:\s*([^;]*)/g;
var serialize = (style) => {
  const res = {};
  let match;
  while (match = CSS_REGEX.exec(style)) {
    res[match[1]] = match[2];
  }
  return res;
};
var css = (a, b) => {
  if (isString(a)) {
    if (isString(b)) return `${a};${b}`;
    a = serialize(a);
  } else if (isString(b)) {
    b = serialize(b);
  }
  return Object.assign({}, a ?? {}, b ?? {});
};
function mergeProps(...args) {
  let result = {};
  for (let props of args) {
    if (!props) continue;
    for (let key in result) {
      if (key.startsWith("on") && typeof result[key] === "function" && typeof props[key] === "function") {
        result[key] = callAll(props[key], result[key]);
        continue;
      }
      if (key === "className" || key === "class") {
        result[key] = clsx(result[key], props[key]);
        continue;
      }
      if (key === "style") {
        result[key] = css(result[key], props[key]);
        continue;
      }
      result[key] = props[key] !== void 0 ? props[key] : result[key];
    }
    for (let key in props) {
      if (result[key] === void 0) {
        result[key] = props[key];
      }
    }
    const symbols = Object.getOwnPropertySymbols(props);
    for (let symbol of symbols) {
      result[symbol] = props[symbol];
    }
  }
  return result;
}

// ../node_modules/.pnpm/@zag-js+menu@1.40.0/node_modules/@zag-js/menu/dist/menu.dom.mjs
var getTriggerId = (ctx, value) => {
  const customId = ctx.ids?.trigger;
  if (customId != null) return isFunction(customId) ? customId(value) : customId;
  return value ? `menu:${ctx.id}:trigger:${value}` : `menu:${ctx.id}:trigger`;
};
var getContextTriggerId = (ctx, value) => {
  const customId = ctx.ids?.contextTrigger;
  if (customId != null) return isFunction(customId) ? customId(value) : customId;
  return value ? `menu:${ctx.id}:ctx-trigger:${value}` : `menu:${ctx.id}:ctx-trigger`;
};
var getContentId = (ctx) => ctx.ids?.content ?? `menu:${ctx.id}:content`;
var getArrowId = (ctx) => ctx.ids?.arrow ?? `menu:${ctx.id}:arrow`;
var getPositionerId = (ctx) => ctx.ids?.positioner ?? `menu:${ctx.id}:popper`;
var getGroupId = (ctx, id) => ctx.ids?.group?.(id) ?? `menu:${ctx.id}:group:${id}`;
var getItemId = (ctx, id) => `${ctx.id}/${id}`;
var getItemValue = (el) => el?.dataset.value ?? null;
var getGroupLabelId = (ctx, id) => ctx.ids?.groupLabel?.(id) ?? `menu:${ctx.id}:group-label:${id}`;
var getContentEl = (ctx) => ctx.getById(getContentId(ctx));
var getPositionerEl = (ctx) => ctx.getById(getPositionerId(ctx));
var getTriggerEl = (ctx) => ctx.getById(getTriggerId(ctx));
var getItemEl = (ctx, value) => value ? ctx.getById(getItemId(ctx, value)) : null;
var getContextTriggerEl = (ctx) => ctx.getById(getContextTriggerId(ctx));
var getTriggerEls = (ctx) => queryAll(ctx.getDoc(), `[data-scope="menu"][data-part="trigger"][data-ownedby="${ctx.id}"]`);
var getContextTriggerEls = (ctx) => queryAll(ctx.getDoc(), `[data-scope="menu"][data-part="context-trigger"][data-ownedby="${ctx.id}"]`);
var getActiveTriggerEl = (ctx, value) => {
  if (value == null) {
    return getTriggerEl(ctx) ?? getTriggerEls(ctx)[0];
  }
  return ctx.getById(getTriggerId(ctx, value));
};
var getElements = (ctx) => {
  const ownerId = CSS.escape(getContentId(ctx));
  const selector = `[role^="menuitem"][data-ownedby=${ownerId}]:not([data-disabled])`;
  return queryAll(getContentEl(ctx), selector);
};
var getFirstEl = (ctx) => first(getElements(ctx));
var getLastEl = (ctx) => last(getElements(ctx));
var isMatch = (el, value) => {
  if (!value) return false;
  return el.id === value || el.dataset.value === value;
};
var getNextEl = (ctx, opts) => {
  const items = getElements(ctx);
  const index = items.findIndex((el) => isMatch(el, opts.value));
  return next(items, index, { loop: opts.loop ?? opts.loopFocus });
};
var getPrevEl = (ctx, opts) => {
  const items = getElements(ctx);
  const index = items.findIndex((el) => isMatch(el, opts.value));
  return prev(items, index, { loop: opts.loop ?? opts.loopFocus });
};
var getElemByKey = (ctx, opts) => {
  const items = getElements(ctx);
  const item = items.find((el) => isMatch(el, opts.value));
  return getByTypeahead(items, { state: opts.typeaheadState, key: opts.key, activeId: item?.id ?? null });
};
var isTargetDisabled = (v) => {
  return isHTMLElement(v) && (v.dataset.disabled === "" || v.hasAttribute("disabled"));
};
var isTriggerItem = (el) => {
  return !!el?.getAttribute("role")?.startsWith("menuitem") && !!el?.hasAttribute("data-controls");
};
var itemSelectEvent = "menu:select";
function dispatchSelectionEvent(el, value) {
  if (!el) return;
  const win = getWindow(el);
  const event = new win.CustomEvent(itemSelectEvent, { detail: { value } });
  el.dispatchEvent(event);
}
function getPortaledContentEl(scope) {
  const contentId = getContentId(scope);
  return getContentEl(scope) ?? scope.getDoc().getElementById(contentId);
}
function isTargetWithinMenuTree(target, children) {
  if (!isHTMLElement(target)) return false;
  for (const id in children) {
    const child = children[id];
    const childContent = getPortaledContentEl(child.scope);
    if (childContent && contains(childContent, target)) return true;
    const nested = child.refs.get("children");
    if (Object.keys(nested).length > 0 && isTargetWithinMenuTree(target, nested)) return true;
  }
  return false;
}

// ../node_modules/.pnpm/@zag-js+rect-utils@1.40.0/node_modules/@zag-js/rect-utils/dist/polygon.mjs
function getElementPolygon(rectValue, placement) {
  const rect = createRect(rectValue);
  const { top, right, left, bottom } = getRectCorners(rect);
  const [base] = placement.split("-");
  return {
    top: [left, top, right, bottom],
    right: [top, right, bottom, left],
    bottom: [top, left, bottom, right],
    left: [right, top, left, bottom]
  }[base];
}
function isPointInPolygon(polygon, point) {
  const { x, y } = point;
  let c = false;
  for (let i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
    const xi = polygon[i].x;
    const yi = polygon[i].y;
    const xj = polygon[j].x;
    const yj = polygon[j].y;
    if (yi > y !== yj > y && x < (xj - xi) * (y - yi) / (yj - yi) + xi) {
      c = !c;
    }
  }
  return c;
}

// ../node_modules/.pnpm/@zag-js+menu@1.40.0/node_modules/@zag-js/menu/dist/menu.utils.mjs
function closeRootMenu(ctx) {
  let parent = ctx.parent;
  while (parent && parent.context.get("isSubmenu")) {
    parent = parent.refs.get("parent");
  }
  parent?.send({ type: "CLOSE" });
}
function isWithinPolygon(polygon, point) {
  if (!polygon) return false;
  return isPointInPolygon(polygon, point);
}
function resolveItemId(children, value, scope) {
  const hasChildren = Object.keys(children).length > 0;
  if (!value) return null;
  if (!hasChildren) {
    return getItemId(scope, value);
  }
  for (const id in children) {
    const childMenu = children[id];
    const childTriggerId = getTriggerId(childMenu.scope);
    if (childTriggerId === value) {
      return childTriggerId;
    }
  }
  return getItemId(scope, value);
}
function setParentRoutingLock(parent, locked) {
  if (!parent) return;
  parent.refs.set("pointerRoutingLocked", locked);
  parent.context.set("pointerRoutingMode", locked ? "locked" : "interactive");
}
function isHighlightedItemSubmenuOpen(parent) {
  const highlighted = parent.context.get("highlightedValue");
  if (!highlighted) return false;
  const children = parent.refs.get("children");
  for (const id in children) {
    const child = children[id];
    if (!child.state.hasTag("open")) continue;
    if (getTriggerId(child.scope) === highlighted) return true;
  }
  return false;
}
function unlockParentAfterChildClose(parent, childIsSubmenu) {
  if (!parent) return;
  if (parent.refs.get("pointerRoutingLocked")) return;
  if (childIsSubmenu && isHighlightedItemSubmenuOpen(parent)) return;
  setParentRoutingLock(parent, false);
}
function unlockParentOnSubmenuClose(parent) {
  if (!parent) return;
  if (!isHighlightedItemSubmenuOpen(parent)) {
    setParentRoutingLock(parent, false);
  }
}

// ../node_modules/.pnpm/@zag-js+menu@1.40.0/node_modules/@zag-js/menu/dist/menu.connect.mjs
function connect(service, normalize) {
  const { context, send, state, computed, prop, scope } = service;
  const open = state.hasTag("open");
  const isSubmenu = context.get("isSubmenu");
  const isTypingAhead = computed("isTypingAhead");
  const composite = prop("composite");
  const currentPlacement = context.get("currentPlacement");
  const anchorPoint = context.get("anchorPoint");
  const highlightedValue = context.get("highlightedValue");
  const triggerValue = context.get("triggerValue");
  const popperStyles = getPlacementStyles({
    ...prop("positioning"),
    placement: anchorPoint ? "bottom" : currentPlacement
  });
  function getItemState(props) {
    return {
      id: getItemId(scope, props.value),
      disabled: !!props.disabled,
      highlighted: highlightedValue === props.value
    };
  }
  function getOptionItemProps(props) {
    const valueText = props.valueText ?? props.value;
    return { ...props, id: props.value, valueText };
  }
  function getOptionItemState(props) {
    const itemState = getItemState(getOptionItemProps(props));
    return {
      ...itemState,
      checked: !!props.checked
    };
  }
  function getItemProps(props) {
    const { closeOnSelect, valueText, value } = props;
    const itemState = getItemState(props);
    const id = getItemId(scope, value);
    return normalize.element({
      ...parts.item.attrs,
      id,
      role: "menuitem",
      "aria-disabled": ariaAttr(itemState.disabled),
      "data-disabled": dataAttr(itemState.disabled),
      "data-ownedby": getContentId(scope),
      "data-highlighted": dataAttr(itemState.highlighted),
      "data-value": value,
      "data-valuetext": valueText,
      onDragStart(event) {
        const isLink = event.currentTarget.matches("a[href]");
        if (isLink) event.preventDefault();
      },
      onPointerMove(event) {
        if (itemState.disabled) return;
        if (event.pointerType !== "mouse") return;
        const target = event.currentTarget;
        if (itemState.highlighted) return;
        const point = getEventPoint(event);
        send({ type: "ITEM_POINTERMOVE", id, target, closeOnSelect, point });
      },
      onPointerLeave(event) {
        if (itemState.disabled) return;
        if (event.pointerType !== "mouse") return;
        const pointerMoved = service.event.previous()?.type.includes("POINTER");
        if (!pointerMoved) return;
        const target = event.currentTarget;
        send({ type: "ITEM_POINTERLEAVE", id, target, closeOnSelect });
      },
      onPointerDown(event) {
        if (itemState.disabled) return;
        const target = event.currentTarget;
        send({ type: "ITEM_POINTERDOWN", target, id, closeOnSelect });
      },
      onClick(event) {
        if (isDownloadingEvent(event)) return;
        if (isOpeningInNewTab(event)) return;
        if (itemState.disabled) return;
        const target = event.currentTarget;
        send({ type: "ITEM_CLICK", target, id, closeOnSelect });
      }
    });
  }
  return {
    highlightedValue,
    open,
    setOpen(nextOpen) {
      const open2 = state.hasTag("open");
      if (open2 === nextOpen) return;
      send({ type: nextOpen ? "OPEN" : "CLOSE" });
    },
    triggerValue,
    setTriggerValue(value) {
      send({ type: "TRIGGER_VALUE.SET", value });
    },
    setHighlightedValue(value) {
      send({ type: "HIGHLIGHTED.SET", value });
    },
    setParent(parent) {
      send({ type: "PARENT.SET", value: parent, id: parent.prop("id") });
    },
    setChild(child) {
      send({ type: "CHILD.SET", value: child, id: child.prop("id") });
    },
    reposition(options = {}) {
      send({ type: "POSITIONING.SET", options });
    },
    addItemListener(props) {
      const node = scope.getById(props.id);
      if (!node) return;
      const listener = () => props.onSelect?.();
      node.addEventListener(itemSelectEvent, listener);
      return () => node.removeEventListener(itemSelectEvent, listener);
    },
    getContextTriggerProps(props = {}) {
      const { value } = props;
      const current = value == null ? false : triggerValue === value;
      const contextTriggerId = getContextTriggerId(scope, value);
      return normalize.element({
        ...parts.contextTrigger.attrs,
        dir: prop("dir"),
        id: contextTriggerId,
        "data-ownedby": scope.id,
        "data-value": value,
        "data-current": dataAttr(current),
        "data-state": open ? "open" : "closed",
        onPointerDown(event) {
          if (event.pointerType === "mouse") return;
          const point = getEventPoint(event);
          send({ type: "CONTEXT_MENU_START", point, value });
        },
        onPointerCancel(event) {
          if (event.pointerType === "mouse") return;
          send({ type: "CONTEXT_MENU_CANCEL" });
        },
        onPointerMove(event) {
          if (event.pointerType === "mouse") return;
          send({ type: "CONTEXT_MENU_CANCEL" });
        },
        onPointerUp(event) {
          if (event.pointerType === "mouse") return;
          send({ type: "CONTEXT_MENU_CANCEL" });
        },
        onContextMenu(event) {
          const point = getEventPoint(event);
          const shouldSwitch = open && value != null && !current;
          send({
            type: shouldSwitch ? "TRIGGER_VALUE.SET" : "CONTEXT_MENU",
            point,
            value
          });
          event.preventDefault();
        },
        style: {
          WebkitTouchCallout: "none",
          WebkitUserSelect: "none",
          userSelect: "none"
        }
      });
    },
    getTriggerItemProps(childApi) {
      const triggerProps = childApi.getTriggerProps();
      return mergeProps(getItemProps({ value: triggerProps.id }), triggerProps);
    },
    getTriggerProps(props = {}) {
      const { value } = props;
      const current = value == null ? false : triggerValue === value;
      const triggerId = getTriggerId(scope, value);
      return normalize.button({
        ...isSubmenu ? parts.triggerItem.attrs : parts.trigger.attrs,
        "data-placement": context.get("currentPlacement"),
        type: "button",
        dir: prop("dir"),
        id: triggerId,
        // Multi-trigger attributes - only included when value is provided
        ...value != null && {
          "data-ownedby": scope.id,
          "data-value": value,
          "data-current": dataAttr(current)
        },
        "data-uid": prop("id"),
        "aria-haspopup": composite ? "menu" : "dialog",
        "aria-controls": getContentId(scope),
        "data-controls": getContentId(scope),
        "aria-expanded": value == null ? open : open && current,
        "data-state": open ? "open" : "closed",
        onPointerMove(event) {
          if (event.pointerType !== "mouse") return;
          const disabled = isTargetDisabled(event.currentTarget);
          if (disabled || !isSubmenu) return;
          const point = getEventPoint(event);
          send({ type: "TRIGGER_POINTERMOVE", target: event.currentTarget, point });
        },
        onPointerLeave(event) {
          if (isTargetDisabled(event.currentTarget)) return;
          if (event.pointerType !== "mouse") return;
          if (!isSubmenu) return;
          setParentRoutingLock(service.refs.get("parent"), true);
          const point = getEventPoint(event);
          send({
            type: "TRIGGER_POINTERLEAVE",
            target: event.currentTarget,
            point
          });
        },
        onPointerDown(event) {
          if (isTargetDisabled(event.currentTarget)) return;
          if (isContextMenuEvent(event)) return;
          event.preventDefault();
        },
        onClick(event) {
          if (event.defaultPrevented) return;
          if (isTargetDisabled(event.currentTarget)) return;
          const shouldSwitch = open && value != null && !current;
          send({
            type: shouldSwitch ? "TRIGGER_VALUE.SET" : "TRIGGER_CLICK",
            target: event.currentTarget,
            value
          });
        },
        onBlur() {
          send({ type: "TRIGGER_BLUR" });
        },
        onFocus() {
          send({ type: "TRIGGER_FOCUS" });
        },
        onKeyDown(event) {
          if (event.defaultPrevented) return;
          const keyMap = {
            ArrowDown() {
              send({ type: "ARROW_DOWN", value });
            },
            ArrowUp() {
              send({ type: "ARROW_UP", value });
            },
            Enter() {
              send({ type: "ARROW_DOWN", src: "enter", value });
            },
            Space() {
              send({ type: "ARROW_DOWN", src: "space", value });
            }
          };
          const key = getEventKey(event, {
            orientation: "vertical",
            dir: prop("dir")
          });
          const exec = keyMap[key];
          if (exec) {
            event.preventDefault();
            exec(event);
          }
        }
      });
    },
    getIndicatorProps() {
      return normalize.element({
        ...parts.indicator.attrs,
        dir: prop("dir"),
        "data-state": open ? "open" : "closed"
      });
    },
    getPositionerProps() {
      return normalize.element({
        ...parts.positioner.attrs,
        dir: prop("dir"),
        id: getPositionerId(scope),
        style: popperStyles.floating
      });
    },
    getArrowProps() {
      return normalize.element({
        id: getArrowId(scope),
        ...parts.arrow.attrs,
        dir: prop("dir"),
        style: popperStyles.arrow
      });
    },
    getArrowTipProps() {
      return normalize.element({
        ...parts.arrowTip.attrs,
        dir: prop("dir"),
        style: popperStyles.arrowTip
      });
    },
    getContentProps() {
      return normalize.element({
        ...parts.content.attrs,
        id: getContentId(scope),
        "aria-label": prop("aria-label"),
        hidden: !open,
        "data-state": open ? "open" : "closed",
        role: composite ? "menu" : "dialog",
        tabIndex: 0,
        dir: prop("dir"),
        "aria-activedescendant": computed("highlightedId") || void 0,
        "aria-labelledby": anchorPoint ? getContextTriggerId(scope, triggerValue ?? void 0) : getTriggerId(scope, triggerValue ?? void 0),
        "data-placement": currentPlacement,
        onPointerEnter(event) {
          if (event.pointerType !== "mouse") return;
          send({ type: "MENU_POINTERENTER" });
        },
        onKeyDown(event) {
          if (event.defaultPrevented) return;
          if (!contains(event.currentTarget, getEventTarget(event))) return;
          const target = getEventTarget(event);
          const sameMenu = target?.closest("[role=menu]") === event.currentTarget || target === event.currentTarget;
          if (!sameMenu) return;
          if (event.key === "Tab") {
            const valid = isValidTabEvent(event);
            if (!valid) {
              event.preventDefault();
              return;
            }
          }
          const keyMap = {
            ArrowDown() {
              send({ type: "ARROW_DOWN" });
            },
            ArrowUp() {
              send({ type: "ARROW_UP" });
            },
            ArrowLeft() {
              send({ type: "ARROW_LEFT" });
            },
            ArrowRight() {
              send({ type: "ARROW_RIGHT" });
            },
            Enter() {
              send({ type: "ENTER" });
            },
            Space(event2) {
              if (isTypingAhead) {
                send({ type: "TYPEAHEAD", key: event2.key });
              } else {
                keyMap.Enter?.(event2);
              }
            },
            Home() {
              send({ type: "HOME" });
            },
            End() {
              send({ type: "END" });
            }
          };
          const key = getEventKey(event, { dir: prop("dir") });
          const exec = keyMap[key];
          if (exec) {
            exec(event);
            event.stopPropagation();
            event.preventDefault();
            return;
          }
          if (!prop("typeahead")) return;
          if (!isPrintableKey(event)) return;
          if (isModifierKey(event)) return;
          if (isEditableElement(target)) return;
          send({ type: "TYPEAHEAD", key: event.key });
          event.preventDefault();
        }
      });
    },
    getSeparatorProps() {
      return normalize.element({
        ...parts.separator.attrs,
        role: "separator",
        dir: prop("dir"),
        "aria-orientation": "horizontal"
      });
    },
    getItemState,
    getItemProps,
    getOptionItemState,
    getOptionItemProps(props) {
      const { type, disabled, closeOnSelect } = props;
      const option = getOptionItemProps(props);
      const itemState = getOptionItemState(props);
      return {
        ...getItemProps(option),
        ...normalize.element({
          "data-type": type,
          ...parts.item.attrs,
          dir: prop("dir"),
          "data-value": option.value,
          role: `menuitem${type}`,
          "aria-checked": !!itemState.checked,
          "data-state": itemState.checked ? "checked" : "unchecked",
          onClick(event) {
            if (disabled) return;
            if (isDownloadingEvent(event)) return;
            if (isOpeningInNewTab(event)) return;
            const target = event.currentTarget;
            send({ type: "ITEM_CLICK", target, option, closeOnSelect });
          }
        })
      };
    },
    getItemIndicatorProps(props) {
      const itemState = getOptionItemState(cast(props));
      const dataState = itemState.checked ? "checked" : "unchecked";
      return normalize.element({
        ...parts.itemIndicator.attrs,
        dir: prop("dir"),
        "data-disabled": dataAttr(itemState.disabled),
        "data-highlighted": dataAttr(itemState.highlighted),
        "data-state": hasProp(props, "checked") ? dataState : void 0,
        hidden: hasProp(props, "checked") ? !itemState.checked : void 0
      });
    },
    getItemTextProps(props) {
      const itemState = getOptionItemState(cast(props));
      const dataState = itemState.checked ? "checked" : "unchecked";
      return normalize.element({
        ...parts.itemText.attrs,
        dir: prop("dir"),
        "data-disabled": dataAttr(itemState.disabled),
        "data-highlighted": dataAttr(itemState.highlighted),
        "data-state": hasProp(props, "checked") ? dataState : void 0
      });
    },
    getItemGroupLabelProps(props) {
      return normalize.element({
        ...parts.itemGroupLabel.attrs,
        id: getGroupLabelId(scope, props.htmlFor),
        dir: prop("dir")
      });
    },
    getItemGroupProps(props) {
      return normalize.element({
        id: getGroupId(scope, props.id),
        ...parts.itemGroup.attrs,
        dir: prop("dir"),
        "aria-labelledby": getGroupLabelId(scope, props.id),
        role: "group"
      });
    }
  };
}

// ../node_modules/.pnpm/@zag-js+menu@1.40.0/node_modules/@zag-js/menu/dist/menu.machine.mjs
var { not, and, or } = createGuards();
var machine = createMachine({
  props({ props }) {
    return {
      closeOnSelect: true,
      typeahead: true,
      composite: true,
      loopFocus: false,
      navigate(details) {
        clickIfLink(details.node);
      },
      ...props,
      positioning: {
        placement: "bottom-start",
        gutter: 8,
        ...props.positioning
      }
    };
  },
  initialState({ prop }) {
    const open = prop("open") || prop("defaultOpen");
    return open ? "open" : "idle";
  },
  context({ bindable, prop, scope }) {
    return {
      highlightedValue: bindable(() => ({
        defaultValue: prop("defaultHighlightedValue") || null,
        value: prop("highlightedValue"),
        onChange(value) {
          prop("onHighlightChange")?.({ highlightedValue: value });
        }
      })),
      lastHighlightedValue: bindable(() => ({
        defaultValue: null
      })),
      currentPlacement: bindable(() => ({
        defaultValue: void 0
      })),
      intentPolygon: bindable(() => ({
        defaultValue: null
      })),
      anchorPoint: bindable(() => ({
        defaultValue: null,
        hash(value) {
          return `x: ${value?.x}, y: ${value?.y}`;
        }
      })),
      isSubmenu: bindable(() => ({
        defaultValue: false
      })),
      triggerValue: bindable(() => ({
        defaultValue: prop("defaultTriggerValue") ?? null,
        value: prop("triggerValue"),
        onChange(value) {
          const onTriggerValueChange = prop("onTriggerValueChange");
          if (!onTriggerValueChange) return;
          const triggerElement = getActiveTriggerEl(scope, value);
          onTriggerValueChange({ value, triggerElement });
        }
      })),
      pointerRoutingMode: bindable(() => ({
        defaultValue: "interactive"
      }))
    };
  },
  refs() {
    return {
      parent: null,
      children: {},
      pointerRoutingLocked: false,
      typeaheadState: { ...getByTypeahead.defaultOptions },
      positioningOverride: {}
    };
  },
  computed: {
    isRtl: ({ prop }) => prop("dir") === "rtl",
    isTypingAhead: ({ refs }) => refs.get("typeaheadState").keysSoFar !== "",
    highlightedId: ({ context, scope, refs }) => resolveItemId(refs.get("children"), context.get("highlightedValue"), scope)
  },
  watch({ track, action, context, prop }) {
    track([() => context.get("isSubmenu")], () => {
      action(["setSubmenuPlacement"]);
    });
    track([() => context.hash("anchorPoint")], () => {
      if (!context.get("anchorPoint")) return;
      action(["reposition"]);
    });
    track([() => prop("open")], () => {
      action(["toggleVisibility"]);
    });
  },
  on: {
    "TRIGGER_VALUE.SET": {
      actions: ["setTriggerValue", "setAnchorPoint", "reposition", "focusMenu"]
    },
    "PARENT.SET": {
      actions: ["setParentMenu"]
    },
    "CHILD.SET": {
      actions: ["setChildMenu"]
    },
    OPEN: [
      {
        guard: "isOpenControlled",
        actions: ["setTriggerValue", "invokeOnOpen"]
      },
      {
        target: "open",
        actions: ["setTriggerValue", "invokeOnOpen"]
      }
    ],
    OPEN_AUTOFOCUS: [
      {
        guard: "isOpenControlled",
        actions: ["setTriggerValue", "invokeOnOpen"]
      },
      {
        // internal: true,
        target: "open",
        actions: ["setTriggerValue", "highlightFirstItem", "invokeOnOpen"]
      }
    ],
    CLOSE: [
      {
        guard: "isOpenControlled",
        actions: ["invokeOnClose", "releaseParentRoutingLock"]
      },
      {
        target: "closed",
        actions: ["invokeOnClose", "releaseParentRoutingLock", "focusTrigger"]
      }
    ],
    "HIGHLIGHTED.RESTORE": {
      actions: ["restoreHighlightedItem"]
    },
    "HIGHLIGHTED.SET": {
      actions: ["setHighlightedItem"]
    },
    "HIGHLIGHTED.SUGGEST": {
      actions: ["suggestHighlightedItem"]
    }
  },
  states: {
    idle: {
      tags: ["closed"],
      on: {
        "CONTROLLED.OPEN": {
          target: "open"
        },
        "CONTROLLED.CLOSE": {
          target: "closed"
        },
        CONTEXT_MENU_START: {
          target: "opening:contextmenu",
          actions: ["setAnchorPoint", "setTriggerValue"]
        },
        CONTEXT_MENU: [
          {
            guard: "isOpenControlled",
            actions: ["setAnchorPoint", "setTriggerValue", "invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["setAnchorPoint", "setTriggerValue", "invokeOnOpen"]
          }
        ],
        TRIGGER_CLICK: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen", "setTriggerValue"]
          },
          {
            target: "open",
            actions: ["invokeOnOpen", "setTriggerValue"]
          }
        ],
        TRIGGER_FOCUS: {
          guard: not("isSubmenu"),
          target: "closed"
        },
        TRIGGER_POINTERMOVE: {
          guard: "isSubmenu",
          target: "opening"
        }
      }
    },
    "opening:contextmenu": {
      tags: ["closed"],
      effects: ["waitForLongPress"],
      on: {
        "CONTROLLED.OPEN": { target: "open" },
        "CONTROLLED.CLOSE": { target: "closed", actions: ["focusTrigger"] },
        CONTEXT_MENU_CANCEL: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnClose", "releaseParentRoutingLock"]
          },
          {
            target: "closed",
            actions: ["invokeOnClose", "releaseParentRoutingLock", "focusTrigger"]
          }
        ],
        "LONG_PRESS.OPEN": [
          {
            guard: "isOpenControlled",
            actions: ["setTriggerValue", "invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["setTriggerValue", "invokeOnOpen"]
          }
        ]
      }
    },
    opening: {
      tags: ["closed"],
      effects: ["waitForOpenDelay"],
      on: {
        "CONTROLLED.OPEN": {
          target: "open"
        },
        "CONTROLLED.CLOSE": {
          target: "closed",
          actions: ["focusTrigger"]
        },
        BLUR: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnClose", "releaseParentRoutingLock"]
          },
          {
            target: "closed",
            actions: ["invokeOnClose", "releaseParentRoutingLock", "focusTrigger"]
          }
        ],
        TRIGGER_POINTERLEAVE: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnClose", "releaseParentRoutingLock"]
          },
          {
            target: "closed",
            actions: ["invokeOnClose", "releaseParentRoutingLock", "focusTrigger"]
          }
        ],
        "DELAY.OPEN": [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["invokeOnOpen"]
          }
        ]
      }
    },
    closing: {
      tags: ["open"],
      effects: ["trackPointerMove", "trackInteractOutside", "waitForCloseDelay"],
      on: {
        "CONTROLLED.OPEN": {
          target: "open"
        },
        "CONTROLLED.CLOSE": {
          target: "closed",
          actions: ["focusParentMenu", "restoreParentHighlightedItem"]
        },
        // don't invoke on open here since the menu is still open (we're only keeping it open)
        MENU_POINTERENTER: {
          target: "open",
          actions: ["clearIntentPolygon"]
        },
        POINTER_MOVED_AWAY_FROM_SUBMENU: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnClose", "releaseParentRoutingLock"]
          },
          {
            target: "closed",
            actions: ["focusParentMenu", "restoreParentHighlightedItem"]
          }
        ],
        "DELAY.CLOSE": [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnClose", "releaseParentRoutingLock"]
          },
          {
            target: "closed",
            actions: ["focusParentMenu", "restoreParentHighlightedItem", "invokeOnClose", "releaseParentRoutingLock"]
          }
        ]
      }
    },
    closed: {
      tags: ["closed"],
      entry: ["clearHighlightedItem", "unlockParentOnClose", "clearAnchorPoint"],
      on: {
        "CONTROLLED.OPEN": [
          {
            guard: or("isOpenAutoFocusEvent", "isArrowDownEvent"),
            target: "open",
            actions: ["highlightFirstItem"]
          },
          {
            guard: "isArrowUpEvent",
            target: "open",
            actions: ["highlightLastItem"]
          },
          {
            target: "open"
          }
        ],
        CONTEXT_MENU_START: {
          target: "opening:contextmenu",
          actions: ["setAnchorPoint", "setTriggerValue"]
        },
        CONTEXT_MENU: [
          {
            guard: "isOpenControlled",
            actions: ["setAnchorPoint", "setTriggerValue", "invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["setAnchorPoint", "setTriggerValue", "invokeOnOpen"]
          }
        ],
        TRIGGER_CLICK: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen", "setTriggerValue"]
          },
          {
            target: "open",
            actions: ["invokeOnOpen", "setTriggerValue"]
          }
        ],
        TRIGGER_POINTERMOVE: {
          guard: "isTriggerItem",
          target: "opening"
        },
        TRIGGER_BLUR: { target: "idle" },
        ARROW_DOWN: [
          {
            guard: "isOpenControlled",
            actions: ["setTriggerValue", "invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["setTriggerValue", "highlightFirstItem", "invokeOnOpen"]
          }
        ],
        ARROW_UP: [
          {
            guard: "isOpenControlled",
            actions: ["setTriggerValue", "invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["setTriggerValue", "highlightLastItem", "invokeOnOpen"]
          }
        ]
      }
    },
    open: {
      tags: ["open"],
      effects: ["trackInteractOutside", "trackFocusVisible", "trackPositioning", "scrollToHighlightedItem"],
      entry: ["focusMenu", "unlockParentOnOpen"],
      on: {
        "CONTROLLED.CLOSE": [
          {
            target: "closed",
            guard: "isArrowLeftEvent",
            actions: ["focusParentMenu"]
          },
          {
            target: "closed",
            actions: ["focusTrigger"]
          }
        ],
        TRIGGER_CLICK: [
          {
            guard: and(not("isTriggerItem"), "isOpenControlled"),
            actions: ["invokeOnClose", "releaseParentRoutingLock"]
          },
          {
            guard: not("isTriggerItem"),
            target: "closed",
            actions: ["invokeOnClose", "releaseParentRoutingLock", "focusTrigger"]
          }
        ],
        CONTEXT_MENU: {
          actions: ["setAnchorPoint", "setTriggerValue", "focusMenu"]
        },
        ARROW_UP: {
          actions: ["highlightPrevItem", "focusMenu"]
        },
        ARROW_DOWN: {
          actions: ["highlightNextItem", "focusMenu"]
        },
        ARROW_LEFT: [
          {
            guard: and("isSubmenu", "isOpenControlled"),
            actions: ["invokeOnClose", "releaseParentRoutingLock"]
          },
          {
            guard: "isSubmenu",
            target: "closed",
            actions: ["focusParentMenu", "invokeOnClose", "releaseParentRoutingLock"]
          }
        ],
        HOME: {
          actions: ["highlightFirstItem", "focusMenu"]
        },
        END: {
          actions: ["highlightLastItem", "focusMenu"]
        },
        ARROW_RIGHT: {
          guard: "isTriggerItemHighlighted",
          actions: ["openSubmenu"]
        },
        ENTER: [
          {
            guard: "isTriggerItemHighlighted",
            actions: ["openSubmenu"]
          },
          {
            actions: ["clickHighlightedItem"]
          }
        ],
        ITEM_POINTERMOVE: [
          {
            guard: not("isPointerRoutingLocked"),
            actions: ["setHighlightedItem", "focusMenu", "closeSiblingMenus"]
          },
          {
            actions: ["setLastHighlightedItem", "closeSiblingMenus"]
          }
        ],
        ITEM_POINTERLEAVE: {
          guard: and(not("isPointerRoutingLocked"), not("isTriggerItem")),
          actions: ["clearHighlightedItem"]
        },
        ITEM_CLICK: [
          // == grouped ==
          {
            guard: and(
              not("isTriggerItemHighlighted"),
              not("isHighlightedItemEditable"),
              "closeOnSelect",
              "isOpenControlled"
            ),
            actions: ["invokeOnSelect", "setOptionState", "closeRootMenu", "invokeOnClose", "releaseParentRoutingLock"]
          },
          {
            guard: and(not("isTriggerItemHighlighted"), not("isHighlightedItemEditable"), "closeOnSelect"),
            target: "closed",
            actions: [
              "invokeOnSelect",
              "setOptionState",
              "closeRootMenu",
              "invokeOnClose",
              "releaseParentRoutingLock",
              "focusTrigger"
            ]
          },
          //
          {
            guard: and(not("isTriggerItemHighlighted"), not("isHighlightedItemEditable")),
            actions: ["invokeOnSelect", "setOptionState"]
          },
          { actions: ["setHighlightedItem"] }
        ],
        TRIGGER_POINTERMOVE: {
          guard: "isTriggerItem",
          actions: ["setIntentPolygon"]
        },
        TRIGGER_POINTERLEAVE: {
          target: "closing",
          actions: ["setIntentPolygon"]
        },
        ITEM_POINTERDOWN: {
          actions: ["setHighlightedItem"]
        },
        TYPEAHEAD: {
          actions: ["highlightMatchedItem"]
        },
        FOCUS_MENU: {
          actions: ["focusMenu"]
        },
        "POSITIONING.SET": {
          actions: ["reposition"]
        }
      }
    }
  },
  implementations: {
    guards: {
      closeOnSelect: ({ prop, event }) => !!(event?.closeOnSelect ?? prop("closeOnSelect")),
      // whether the trigger is also a menu item
      isTriggerItem: ({ event }) => isTriggerItem(event.target),
      // whether the trigger item is the active item
      isTriggerItemHighlighted: ({ event, scope, computed }) => {
        const target = event.target ?? scope.getById(computed("highlightedId"));
        return !!target?.hasAttribute("data-controls");
      },
      isSubmenu: ({ context }) => context.get("isSubmenu"),
      isPointerRoutingLocked: ({ refs }) => refs.get("pointerRoutingLocked"),
      isHighlightedItemEditable: ({ scope, computed }) => isEditableElement(scope.getById(computed("highlightedId"))),
      // guard assertions (for controlled mode)
      isOpenControlled: ({ prop }) => prop("open") !== void 0,
      isArrowLeftEvent: ({ event }) => event.previousEvent?.type === "ARROW_LEFT",
      isArrowUpEvent: ({ event }) => event.previousEvent?.type === "ARROW_UP",
      isArrowDownEvent: ({ event }) => event.previousEvent?.type === "ARROW_DOWN",
      isOpenAutoFocusEvent: ({ event }) => event.previousEvent?.type === "OPEN_AUTOFOCUS"
    },
    effects: {
      waitForOpenDelay({ send }) {
        const timer = setTimeout(() => {
          send({ type: "DELAY.OPEN" });
        }, 200);
        return () => clearTimeout(timer);
      },
      waitForCloseDelay({ send }) {
        const timer = setTimeout(() => {
          send({ type: "DELAY.CLOSE" });
        }, 100);
        return () => clearTimeout(timer);
      },
      waitForLongPress({ send }) {
        const timer = setTimeout(() => {
          send({ type: "LONG_PRESS.OPEN" });
        }, 700);
        return () => clearTimeout(timer);
      },
      trackFocusVisible({ scope }) {
        return trackFocusVisible({ root: scope.getRootNode?.() });
      },
      trackPositioning({ context, prop, scope, refs }) {
        const hasContextTrigger = getContextTriggerEl(scope) || getContextTriggerEls(scope).length > 0;
        if (hasContextTrigger) return;
        const positioning = {
          ...prop("positioning"),
          ...refs.get("positioningOverride")
        };
        context.set("currentPlacement", positioning.placement);
        const getPositionerEl2 = () => getPositionerEl(scope);
        const getTriggerEl2 = () => getActiveTriggerEl(scope, context.get("triggerValue"));
        return getPlacement(getTriggerEl2, getPositionerEl2, {
          ...positioning,
          defer: true,
          onComplete(data) {
            context.set("currentPlacement", data.placement);
          }
        });
      },
      trackInteractOutside({ refs, scope, prop, context, send }) {
        const getContentEl2 = () => getContentEl(scope);
        let restoreFocus = true;
        const isWithinAnyContextTrigger = (target) => {
          return getContextTriggerEls(scope).some((el) => contains(el, target));
        };
        return trackDismissableElement(getContentEl2, {
          type: "menu",
          defer: true,
          exclude: [getTriggerEl(scope), ...getTriggerEls(scope)].filter(Boolean),
          onInteractOutside: prop("onInteractOutside"),
          onRequestDismiss: prop("onRequestDismiss"),
          onFocusOutside(event) {
            prop("onFocusOutside")?.(event);
            const target = getEventTarget(event.detail.originalEvent);
            if (isWithinAnyContextTrigger(target)) {
              event.preventDefault();
              return;
            }
            if (isTargetWithinMenuTree(target, refs.get("children"))) {
              event.preventDefault();
              return;
            }
          },
          onEscapeKeyDown(event) {
            prop("onEscapeKeyDown")?.(event);
            if (context.get("isSubmenu")) event.preventDefault();
            closeRootMenu({ parent: refs.get("parent") });
          },
          onPointerDownOutside(event) {
            prop("onPointerDownOutside")?.(event);
            const target = getEventTarget(event.detail.originalEvent);
            if (isWithinAnyContextTrigger(target) && event.detail.contextmenu) {
              event.preventDefault();
              return;
            }
            restoreFocus = !event.detail.focusable;
          },
          onDismiss() {
            send({ type: "CLOSE", src: "interact-outside", restoreFocus });
          }
        });
      },
      trackPointerMove({ context, scope, send, refs }) {
        const parent = refs.get("parent");
        if (!parent) return;
        setParentRoutingLock(parent, true);
        const doc = scope.getDoc();
        return addDomEvent(doc, "pointermove", (e) => {
          const isMovingToSubmenu = isWithinPolygon(context.get("intentPolygon"), {
            x: e.clientX,
            y: e.clientY
          });
          if (!isMovingToSubmenu) {
            send({ type: "POINTER_MOVED_AWAY_FROM_SUBMENU" });
            setParentRoutingLock(parent, false);
          }
        });
      },
      scrollToHighlightedItem({ scope, computed }) {
        const exec = () => {
          const modality = getInteractionModality();
          if (modality === "pointer") return;
          const itemEl = scope.getById(computed("highlightedId"));
          const contentEl2 = getContentEl(scope);
          scrollIntoView(itemEl, { rootEl: contentEl2, block: "nearest" });
        };
        raf(() => {
          setInteractionModality("virtual");
          exec();
        });
        const contentEl = () => getContentEl(scope);
        return observeAttributes(contentEl, {
          defer: true,
          attributes: ["aria-activedescendant"],
          callback: exec
        });
      }
    },
    actions: {
      setAnchorPoint({ context, event }) {
        context.set("anchorPoint", (prev2) => isEqual(prev2, event.point) ? prev2 : event.point);
      },
      setSubmenuPlacement({ context, computed, refs }) {
        if (!context.get("isSubmenu")) return;
        const placement = computed("isRtl") ? "left-start" : "right-start";
        refs.set("positioningOverride", { placement, gutter: 0 });
      },
      reposition({ context, scope, prop, event, refs }) {
        const getPositionerEl2 = () => getPositionerEl(scope);
        const anchorPoint = event.point ?? context.get("anchorPoint");
        const getAnchorRect = anchorPoint ? () => ({ width: 0, height: 0, ...anchorPoint }) : void 0;
        const positioning = {
          ...prop("positioning"),
          ...refs.get("positioningOverride")
        };
        const triggerValue = event.value ?? context.get("triggerValue");
        const getTriggerEl2 = () => getActiveTriggerEl(scope, triggerValue);
        getPlacement(getTriggerEl2, getPositionerEl2, {
          ...positioning,
          defer: true,
          getAnchorRect,
          ...event.options ?? {},
          listeners: false,
          onComplete(data) {
            context.set("currentPlacement", data.placement);
          }
        });
      },
      setOptionState({ event }) {
        if (!event.option) return;
        const { checked, onCheckedChange, type } = event.option;
        if (type === "radio") {
          onCheckedChange?.(true);
        } else if (type === "checkbox") {
          onCheckedChange?.(!checked);
        }
      },
      clickHighlightedItem({ scope, computed, prop, context }) {
        const itemEl = scope.getById(computed("highlightedId"));
        if (!itemEl || itemEl.dataset.disabled) return;
        const highlightedValue = context.get("highlightedValue");
        if (isAnchorElement(itemEl)) {
          prop("navigate")?.({ value: highlightedValue, node: itemEl, href: itemEl.href });
        } else {
          queueMicrotask(() => itemEl.click());
        }
      },
      setIntentPolygon({ context, scope, event }) {
        const menu = getContentEl(scope);
        const placement = context.get("currentPlacement");
        if (!menu || !placement) return;
        const rect = menu.getBoundingClientRect();
        const polygon = getElementPolygon(rect, placement);
        if (!polygon) return;
        const rightSide = getPlacementSide(placement) === "right";
        const bleed = rightSide ? -5 : 5;
        context.set("intentPolygon", [{ ...event.point, x: event.point.x + bleed }, ...polygon]);
      },
      clearIntentPolygon({ context }) {
        context.set("intentPolygon", null);
      },
      clearAnchorPoint({ context }) {
        context.set("anchorPoint", null);
      },
      unlockParentOnOpen({ refs, context, scope }) {
        const parent = refs.get("parent");
        if (context.get("isSubmenu")) {
          const value = getTriggerId(scope);
          parent?.send({ type: "HIGHLIGHTED.SUGGEST", value });
        }
        setParentRoutingLock(parent, false);
      },
      unlockParentOnClose({ refs, context }) {
        unlockParentAfterChildClose(refs.get("parent"), context.get("isSubmenu"));
      },
      setHighlightedItem({ context, event }) {
        const value = event.value || getItemValue(event.target);
        context.set("highlightedValue", value);
      },
      clearHighlightedItem({ context }) {
        context.set("highlightedValue", null);
      },
      focusMenu({ scope }) {
        raf(() => {
          const contentEl = getContentEl(scope);
          const initialFocusEl = getInitialFocus({
            root: contentEl,
            enabled: !contains(contentEl, scope.getActiveElement()),
            filter(node) {
              return !node.role?.startsWith("menuitem");
            }
          });
          initialFocusEl?.focus({ preventScroll: true });
        });
      },
      highlightFirstItem({ context, scope }) {
        const fn = getContentEl(scope) ? queueMicrotask : raf;
        fn(() => {
          const first2 = getFirstEl(scope);
          if (!first2) return;
          context.set("highlightedValue", getItemValue(first2));
        });
      },
      highlightLastItem({ context, scope }) {
        const fn = getContentEl(scope) ? queueMicrotask : raf;
        fn(() => {
          const last2 = getLastEl(scope);
          if (!last2) return;
          context.set("highlightedValue", getItemValue(last2));
        });
      },
      highlightNextItem({ context, scope, event, prop }) {
        const next2 = getNextEl(scope, {
          loop: event.loop,
          value: context.get("highlightedValue"),
          loopFocus: prop("loopFocus")
        });
        context.set("highlightedValue", getItemValue(next2));
      },
      highlightPrevItem({ context, scope, event, prop }) {
        const prev2 = getPrevEl(scope, {
          loop: event.loop,
          value: context.get("highlightedValue"),
          loopFocus: prop("loopFocus")
        });
        context.set("highlightedValue", getItemValue(prev2));
      },
      invokeOnSelect({ context, prop, scope }) {
        const value = context.get("highlightedValue");
        if (value == null) return;
        const node = getItemEl(scope, value);
        dispatchSelectionEvent(node, value);
        prop("onSelect")?.({ value });
      },
      focusTrigger({ scope, context, event }) {
        if (context.get("isSubmenu") || context.get("anchorPoint") || event.restoreFocus === false) return;
        queueMicrotask(() => {
          const triggerEl = getActiveTriggerEl(scope, context.get("triggerValue"));
          triggerEl?.focus({ preventScroll: true });
        });
      },
      highlightMatchedItem({ scope, context, event, refs }) {
        const node = getElemByKey(scope, {
          key: event.key,
          value: context.get("highlightedValue"),
          typeaheadState: refs.get("typeaheadState")
        });
        if (!node) return;
        context.set("highlightedValue", getItemValue(node));
      },
      setParentMenu({ refs, event, context }) {
        refs.set("parent", event.value);
        context.set("isSubmenu", true);
      },
      setChildMenu({ refs, event }) {
        const children = refs.get("children");
        children[event.id] = event.value;
        refs.set("children", children);
      },
      closeSiblingMenus({ refs, event, scope }) {
        const target = event.target;
        if (!isTriggerItem(target)) return;
        const hoveredChildId = target?.getAttribute("data-uid");
        const children = refs.get("children");
        for (const id in children) {
          if (id === hoveredChildId) continue;
          const child = children[id];
          const intentPolygon = child.context.get("intentPolygon");
          if (intentPolygon && event.point && isPointInPolygon(intentPolygon, event.point)) {
            continue;
          }
          getContentEl(scope)?.focus({ preventScroll: true });
          child.send({ type: "CLOSE" });
        }
      },
      closeRootMenu({ refs }) {
        closeRootMenu({ parent: refs.get("parent") });
      },
      openSubmenu({ refs, scope, computed }) {
        const item = scope.getById(computed("highlightedId"));
        const id = item?.getAttribute("data-uid");
        const children = refs.get("children");
        const child = id ? children[id] : null;
        child?.send({ type: "OPEN_AUTOFOCUS" });
      },
      focusParentMenu({ refs }) {
        refs.get("parent")?.send({ type: "FOCUS_MENU" });
      },
      setLastHighlightedItem({ context, event }) {
        context.set("lastHighlightedValue", getItemValue(event.target));
      },
      suggestHighlightedItem({ context, event }) {
        const value = event.value;
        if (!value) return;
        if (context.get("highlightedValue") != null) {
          context.set("lastHighlightedValue", value);
          return;
        }
        context.set("highlightedValue", value);
      },
      restoreHighlightedItem({ context }) {
        const last2 = context.get("lastHighlightedValue");
        context.set("lastHighlightedValue", null);
        if (!last2) return;
        context.set("highlightedValue", last2);
      },
      restoreParentHighlightedItem({ refs }) {
        refs.get("parent")?.send({ type: "HIGHLIGHTED.RESTORE" });
      },
      invokeOnOpen({ prop }) {
        prop("onOpenChange")?.({ open: true });
      },
      invokeOnClose({ prop }) {
        prop("onOpenChange")?.({ open: false });
      },
      releaseParentRoutingLock({ refs, context }) {
        if (!context.get("isSubmenu")) return;
        unlockParentOnSubmenuClose(refs.get("parent"));
      },
      toggleVisibility({ prop, event, send }) {
        send({
          type: prop("open") ? "CONTROLLED.OPEN" : "CONTROLLED.CLOSE",
          previousEvent: event
        });
      },
      setTriggerValue({ context, event }) {
        if (event.value === void 0) return;
        context.set("triggerValue", event.value);
      }
    }
  }
});

// components/menu.ts
var Menu = class extends Component {
  children = [];
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props) {
    return new VanillaMachine(machine, props);
  }
  initApi() {
    return this.zagConnect(connect);
  }
  setChild(child) {
    this.api.setChild(child.machine.service);
    if (!this.children.includes(child)) {
      this.children.push(child);
    }
  }
  setParent(parent) {
    this.api.setParent(parent.machine.service);
  }
  isOwnElement(el) {
    const nearestHook = el.closest('[phx-hook="Menu"]');
    return nearestHook === this.el;
  }
  renderSubmenuTriggers() {
    const contentEl = this.el.querySelector(
      '[data-scope="menu"][data-part="content"]'
    );
    if (!contentEl) return;
    const triggerItems = contentEl.querySelectorAll(
      '[data-scope="menu"][data-nested-menu]'
    );
    for (const triggerEl of triggerItems) {
      if (!this.isOwnElement(triggerEl)) continue;
      const nestedMenuId = triggerEl.dataset.nestedMenu;
      if (!nestedMenuId) continue;
      const childMenu = this.children.find((child) => child.el.id === `menu:${nestedMenuId}`);
      if (!childMenu) continue;
      const applyProps = () => {
        const triggerProps = this.api.getTriggerItemProps(childMenu.api);
        this.spreadProps(triggerEl, triggerProps);
      };
      applyProps();
      this.machine.subscribe(applyProps);
      childMenu.machine.subscribe(applyProps);
    }
  }
  render() {
    const triggerEl = this.el.querySelector(
      '[data-scope="menu"][data-part="trigger"]'
    );
    if (triggerEl) {
      this.spreadProps(triggerEl, this.api.getTriggerProps());
    }
    const positionerEl = this.el.querySelector(
      '[data-scope="menu"][data-part="positioner"]'
    );
    const contentEl = this.el.querySelector(
      '[data-scope="menu"][data-part="content"]'
    );
    if (positionerEl && contentEl) {
      this.spreadProps(positionerEl, this.api.getPositionerProps());
      this.spreadProps(contentEl, this.api.getContentProps());
      contentEl.style.pointerEvents = "auto";
      positionerEl.hidden = !this.api.open;
      const isNested = !this.el.querySelector(
        '[data-scope="menu"][data-part="trigger"]'
      );
      const shouldApplyItems = this.api.open || isNested;
      if (shouldApplyItems) {
        const items = contentEl.querySelectorAll(
          '[data-scope="menu"][data-part="item"]'
        );
        items.forEach((itemEl) => {
          if (!this.isOwnElement(itemEl)) return;
          const value = itemEl.dataset.value;
          if (value) {
            const disabled = itemEl.hasAttribute("data-disabled");
            this.spreadProps(
              itemEl,
              this.api.getItemProps({ value, disabled: disabled || void 0 })
            );
          }
        });
        const itemGroups = contentEl.querySelectorAll(
          '[data-scope="menu"][data-part="item-group"]'
        );
        itemGroups.forEach((groupEl) => {
          if (!this.isOwnElement(groupEl)) return;
          const groupId = groupEl.id;
          if (groupId) {
            this.spreadProps(groupEl, this.api.getItemGroupProps({ id: groupId }));
          }
        });
        const separators = contentEl.querySelectorAll(
          '[data-scope="menu"][data-part="separator"]'
        );
        separators.forEach((separatorEl) => {
          if (!this.isOwnElement(separatorEl)) return;
          this.spreadProps(separatorEl, this.api.getSeparatorProps());
        });
      }
    }
    const indicatorEl = this.el.querySelector(
      '[data-scope="menu"][data-part="indicator"]'
    );
    if (indicatorEl) {
      this.spreadProps(indicatorEl, this.api.getIndicatorProps());
    }
  }
};

// hooks/menu.ts
function findImmediateParentMenuHookEl(nestedEl) {
  let node = nestedEl.parentElement;
  while (node) {
    if (node.getAttribute("phx-hook") === "Menu") {
      return node;
    }
    node = node.parentElement;
  }
  return null;
}
function wireSubmenuTriggersDeep(menu) {
  menu.renderSubmenuTriggers();
  for (const child of menu.children) {
    wireSubmenuTriggersDeep(child);
  }
}
function syncMenuPropsFromDom(menu) {
  const hookEl = menu.el;
  menu.updateProps({
    id: hookEl.id.replace(/^menu:/, ""),
    closeOnSelect: getBoolean(hookEl, "closeOnSelect"),
    loopFocus: getBoolean(hookEl, "loopFocus"),
    typeahead: getBoolean(hookEl, "typeahead"),
    composite: getBoolean(hookEl, "composite"),
    defaultHighlightedValue: getString(hookEl, "defaultHighlightedValue"),
    dir: getDir(hookEl),
    positioning: readPositioningOptions(hookEl)
  });
  for (const child of menu.children) {
    syncMenuPropsFromDom(child);
  }
}
function destroyDescendantMenus(menu) {
  for (const child of [...menu.children]) {
    destroyDescendantMenus(child);
    child.destroy();
  }
}
var MenuHook = {
  mounted() {
    const el = this.el;
    if (el.hasAttribute("data-nested")) {
      return;
    }
    const pushEvent = this.pushEvent.bind(this);
    const liveSocket = this.liveSocket;
    const buildOnSelect = () => (details) => {
      if (getBoolean(el, "redirect") && details.value) {
        const itemEl = el.querySelector(
          `[data-scope="menu"][data-part="item"][data-value="${CSS.escape(details.value)}"]`
        );
        performRedirect(readDomItemRedirect(itemEl, details.value), { liveSocket });
      }
      const eventName = getString(el, "onSelect");
      if (eventName && canPushEvent(liveSocket)) {
        pushEvent(eventName, {
          id: el.id,
          value: details.value ?? null
        });
      }
      const eventNameClient = getString(el, "onSelectClient");
      if (eventNameClient) {
        el.dispatchEvent(
          new CustomEvent(eventNameClient, {
            bubbles: true,
            detail: {
              id: el.id,
              value: details.value ?? null
            }
          })
        );
      }
    };
    const menu = new Menu(el, {
      id: el.id.replace(/^menu:/, ""),
      closeOnSelect: getBoolean(el, "closeOnSelect"),
      loopFocus: getBoolean(el, "loopFocus"),
      typeahead: getBoolean(el, "typeahead"),
      composite: getBoolean(el, "composite"),
      defaultHighlightedValue: getString(el, "defaultHighlightedValue"),
      dir: getDir(el),
      positioning: readPositioningOptions(el),
      onSelect: buildOnSelect(),
      onOpenChange: (details) => {
        const eventName = getString(el, "onOpenChange");
        if (eventName && canPushEvent(liveSocket)) {
          pushEvent(eventName, {
            id: el.id,
            open: details.open ?? false
          });
        }
        const eventNameClient = getString(el, "onOpenChangeClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
              bubbles: true,
              detail: {
                id: el.id,
                open: details.open ?? false
              }
            })
          );
        }
      }
    });
    menu.init();
    this.menu = menu;
    const nestedMenuElements = el.querySelectorAll(
      '[data-scope="menu"][data-nested="menu"]'
    );
    const menuByHookId = /* @__PURE__ */ new Map();
    const nestedMenuInstances = [];
    nestedMenuElements.forEach((nestedEl) => {
      const hookId = nestedEl.id;
      if (!hookId) return;
      const nestedMenu = new Menu(nestedEl, {
        id: hookId.replace(/^menu:/, ""),
        dir: getDir(nestedEl),
        closeOnSelect: getBoolean(nestedEl, "closeOnSelect"),
        loopFocus: getBoolean(nestedEl, "loopFocus"),
        typeahead: getBoolean(nestedEl, "typeahead"),
        composite: getBoolean(nestedEl, "composite"),
        positioning: readPositioningOptions(nestedEl),
        onSelect: buildOnSelect()
      });
      nestedMenu.init();
      menuByHookId.set(hookId, nestedMenu);
      nestedMenuInstances.push(nestedMenu);
    });
    setTimeout(() => {
      nestedMenuInstances.forEach((nestedMenu) => {
        const nestedEl = nestedMenu.el;
        const parentHookEl = findImmediateParentMenuHookEl(nestedEl);
        if (!parentHookEl) return;
        const parentMenu = parentHookEl === el ? this.menu : menuByHookId.get(parentHookEl.id);
        if (!parentMenu) return;
        parentMenu.setChild(nestedMenu);
        nestedMenu.setParent(parentMenu);
      });
      if (this.menu && this.menu.children.length > 0) {
        wireSubmenuTriggersDeep(this.menu);
      }
    }, 0);
    this.onSetOpen = (event) => {
      const { open } = event.detail;
      if (menu.api.open !== open) menu.api.setOpen(open);
    };
    el.addEventListener("corex:menu:set-open", this.onSetOpen);
    this.handlers = [];
    this.handlers.push(
      this.handleEvent("menu_set_open", (payload) => {
        const targetId = payload.menu_id;
        const matches = !targetId || el.id === targetId || el.id === `menu:${targetId}`;
        if (!matches) return;
        menu.api.setOpen(payload.open);
      })
    );
    this.handlers.push(
      this.handleEvent("menu_open", () => {
        this.pushEvent("menu_open_response", {
          open: menu.api.open
        });
      })
    );
  },
  updated() {
    if (this.el.hasAttribute("data-nested")) return;
    if (!this.menu) return;
    syncMenuPropsFromDom(this.menu);
    if (this.menu.children.length > 0) {
      wireSubmenuTriggersDeep(this.menu);
    }
  },
  destroyed() {
    if (this.el.hasAttribute("data-nested")) return;
    if (this.onSetOpen) {
      this.el.removeEventListener("corex:menu:set-open", this.onSetOpen);
    }
    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }
    if (this.menu) {
      destroyDescendantMenus(this.menu);
      this.menu.destroy();
    }
  }
};
export {
  MenuHook as Menu
};
