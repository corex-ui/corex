import {
  isPointInPolygon
} from "./chunks/chunk-OEFPAAAI.mjs";
import {
  createPoint,
  createRect,
  getRectCorners
} from "./chunks/chunk-TDOE7VOH.mjs";
import {
  TreeCollection
} from "./chunks/chunk-6M2TQLRV.mjs";
import {
  getPlacement,
  getPlacementSide,
  getPlacementStyles
} from "./chunks/chunk-7DTCDTRW.mjs";
import {
  trackDismissableElement
} from "./chunks/chunk-4ATAXYH3.mjs";
import "./chunks/chunk-AVGG6QG4.mjs";
import {
  getInteractionModality,
  setInteractionModality,
  trackFocusVisible
} from "./chunks/chunk-2NCIS2R3.mjs";
import {
  createAnatomy
} from "./chunks/chunk-YMOPD357.mjs";
import {
  Component,
  VanillaMachine,
  ariaAttr,
  canPushEvent,
  createGuards,
  createMachine,
  createScope,
  createZagLiveHook,
  dataAttr,
  dispatchInputValueEvent,
  getBoolean,
  getDir,
  getEventKey,
  getString,
  isEditableElement,
  isEmpty,
  isEqual,
  isSelfTarget,
  isValidTabEvent,
  last,
  observeAttributes,
  queryAll,
  raf,
  safeParseJson,
  scrollIntoView,
  setElementValue,
  trackFormControl
} from "./chunks/chunk-R62PCG6O.mjs";

// ../node_modules/.pnpm/@zag-js+cascade-select@1.43.3/node_modules/@zag-js/cascade-select/dist/cascade-select.anatomy.mjs
var anatomy = createAnatomy("cascade-select").parts(
  "root",
  "label",
  "control",
  "trigger",
  "indicator",
  "valueText",
  "clearTrigger",
  "positioner",
  "content",
  "list",
  "item",
  "itemText",
  "itemIndicator"
);
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+cascade-select@1.43.3/node_modules/@zag-js/cascade-select/dist/cascade-select.collection.mjs
var collection = (options) => {
  return new TreeCollection(options);
};
collection.empty = () => {
  return new TreeCollection({
    rootNode: { value: "ROOT", children: [] }
  });
};

// ../node_modules/.pnpm/@zag-js+cascade-select@1.43.3/node_modules/@zag-js/cascade-select/dist/cascade-select.dom.mjs
var dom = createScope({
  getRootId: (ctx) => ctx.ids?.root ?? `cascade-select:${ctx.id}`,
  getLabelId: (ctx) => ctx.ids?.label ?? `cascade-select:${ctx.id}:label`,
  getControlId: (ctx) => ctx.ids?.control ?? `cascade-select:${ctx.id}:control`,
  getTriggerId: (ctx) => ctx.ids?.trigger ?? `cascade-select:${ctx.id}:trigger`,
  getIndicatorId: (ctx) => ctx.ids?.indicator ?? `cascade-select:${ctx.id}:indicator`,
  getClearTriggerId: (ctx) => ctx.ids?.clearTrigger ?? `cascade-select:${ctx.id}:clear-trigger`,
  getPositionerId: (ctx) => ctx.ids?.positioner ?? `cascade-select:${ctx.id}:positioner`,
  getContentId: (ctx) => ctx.ids?.content ?? `cascade-select:${ctx.id}:content`,
  getHiddenInputId: (ctx) => ctx.ids?.hiddenInput ?? `cascade-select:${ctx.id}:hidden-input`,
  getListId: (ctx, value) => ctx.ids?.list?.(value) ?? `cascade-select:${ctx.id}:list:${value}`,
  getItemId: (ctx, value) => ctx.ids?.item?.(value) ?? `cascade-select:${ctx.id}:item:${value}`,
  getRootEl: (ctx) => dom.getById(ctx, dom.getRootId(ctx)),
  getLabelEl: (ctx) => dom.getById(ctx, dom.getLabelId(ctx)),
  getControlEl: (ctx) => dom.getById(ctx, dom.getControlId(ctx)),
  getTriggerEl: (ctx) => dom.getById(ctx, dom.getTriggerId(ctx)),
  getIndicatorEl: (ctx) => dom.getById(ctx, dom.getIndicatorId(ctx)),
  getClearTriggerEl: (ctx) => dom.getById(ctx, dom.getClearTriggerId(ctx)),
  getPositionerEl: (ctx) => dom.getById(ctx, dom.getPositionerId(ctx)),
  getContentEl: (ctx) => dom.getById(ctx, dom.getContentId(ctx)),
  getHiddenInputEl: (ctx) => dom.getById(ctx, dom.getHiddenInputId(ctx)),
  getListEl: (ctx, value) => dom.getById(ctx, dom.getListId(ctx, value)),
  getListEls: (ctx) => queryAll(dom.getContentEl(ctx), `[data-part="list"]`),
  getItemEl: (ctx, value) => dom.getById(ctx, dom.getItemId(ctx, value)),
  dispatchInputEvent: (ctx, value) => {
    const inputEl = dom.getHiddenInputEl(ctx);
    if (!inputEl) return;
    dispatchInputValueEvent(inputEl, { value });
  }
});

// ../node_modules/.pnpm/@zag-js+cascade-select@1.43.3/node_modules/@zag-js/cascade-select/dist/cascade-select.connect.mjs
function connect(service, normalize) {
  const { send, context, prop, scope, computed, state } = service;
  const collection2 = prop("collection");
  const value = context.get("value");
  const open = state.hasTag("open");
  const focused = state.matches("focused");
  const highlightedIndexPath = context.get("highlightedIndexPath");
  const highlightedValue = context.get("highlightedValue");
  const currentPlacement = context.get("currentPlacement");
  const currentPlacementSide = currentPlacement ? getPlacementSide(currentPlacement) : void 0;
  const disabled = prop("disabled") || context.get("fieldsetDisabled");
  const interactive = computed("isInteractive");
  const valueAsString = computed("valueAsString");
  const highlightedItems = context.get("highlightedItems");
  const selectedItems = context.get("selectedItems");
  const popperStyles = getPlacementStyles({
    ...prop("positioning"),
    placement: currentPlacement
  });
  const getItemState = (props) => {
    const { item, indexPath, value: itemValue } = props;
    const depth = indexPath ? indexPath.length : 0;
    const highlighted = itemValue.every((v, i) => v === highlightedValue[i]);
    const selected = value.some((v) => isEqual(v, itemValue));
    const children = collection2.getNodeChildren(collection2.at(indexPath));
    const highlightedChild = children[highlightedIndexPath[depth]];
    const highlightedIndex = highlightedIndexPath[depth];
    return {
      value: itemValue,
      disabled: collection2.getNodeDisabled(item),
      highlighted,
      selected,
      hasChildren: collection2.isBranchNode(item),
      depth,
      highlightedChild,
      highlightedIndex
    };
  };
  const hasSelectedItems = value.length > 0;
  const empty = value.length === 0;
  return {
    collection: collection2,
    open,
    focused,
    multiple: !!prop("multiple"),
    disabled,
    value,
    highlightedValue,
    highlightedItems,
    selectedItems,
    hasSelectedItems,
    empty,
    valueAsString,
    reposition(options = {}) {
      send({ type: "POSITIONING.SET", options });
    },
    focus() {
      dom.getTriggerEl(scope)?.focus({ preventScroll: true });
    },
    setOpen(nextOpen) {
      if (nextOpen === open) return;
      send({ type: nextOpen ? "OPEN" : "CLOSE" });
    },
    setHighlightValue(value2) {
      send({ type: "HIGHLIGHTED_VALUE.SET", value: value2 });
    },
    clearHighlightValue() {
      send({ type: "HIGHLIGHTED_VALUE.CLEAR" });
    },
    setValue(value2) {
      send({ type: "VALUE.SET", value: value2 });
    },
    selectValue(value2) {
      send({ type: "ITEM.SELECT", value: value2 });
    },
    clearValue(value2) {
      if (value2) {
        send({ type: "ITEM.CLEAR", value: value2 });
      } else {
        send({ type: "VALUE.CLEAR" });
      }
    },
    getItemState,
    getRootProps() {
      return normalize.element({
        ...parts.root.attrs,
        id: dom.getRootId(scope),
        dir: prop("dir"),
        "data-disabled": dataAttr(disabled),
        "data-readonly": dataAttr(prop("readOnly")),
        "data-invalid": dataAttr(prop("invalid")),
        "data-state": open ? "open" : "closed"
      });
    },
    getLabelProps() {
      return normalize.label({
        ...parts.label.attrs,
        id: dom.getLabelId(scope),
        dir: prop("dir"),
        htmlFor: dom.getHiddenInputId(scope),
        "data-disabled": dataAttr(disabled),
        "data-readonly": dataAttr(prop("readOnly")),
        "data-invalid": dataAttr(prop("invalid")),
        onClick(event) {
          if (event.defaultPrevented) return;
          if (disabled) return;
          const triggerEl = dom.getTriggerEl(scope);
          triggerEl?.focus({ preventScroll: true });
        }
      });
    },
    getControlProps() {
      return normalize.element({
        ...parts.control.attrs,
        dir: prop("dir"),
        id: dom.getControlId(scope),
        "data-disabled": dataAttr(disabled),
        "data-focus": dataAttr(focused),
        "data-readonly": dataAttr(prop("readOnly")),
        "data-invalid": dataAttr(prop("invalid")),
        "data-state": open ? "open" : "closed"
      });
    },
    getTriggerProps() {
      return normalize.button({
        ...parts.trigger.attrs,
        dir: prop("dir"),
        id: dom.getTriggerId(scope),
        type: "button",
        role: "combobox",
        "aria-controls": dom.getContentId(scope),
        "aria-expanded": open,
        "aria-haspopup": "listbox",
        "aria-labelledby": dom.getLabelId(scope),
        "data-state": open ? "open" : "closed",
        "data-disabled": dataAttr(disabled),
        "data-readonly": dataAttr(prop("readOnly")),
        "data-invalid": dataAttr(prop("invalid")),
        "data-focus": dataAttr(focused),
        "data-placement": currentPlacement,
        "data-side": currentPlacementSide,
        "data-placeholder-shown": dataAttr(!hasSelectedItems),
        disabled,
        onClick(event) {
          if (event.defaultPrevented) return;
          if (!interactive) return;
          send({ type: "TRIGGER.CLICK" });
        },
        onFocus() {
          send({ type: "TRIGGER.FOCUS" });
        },
        onBlur() {
          send({ type: "TRIGGER.BLUR" });
        },
        onKeyDown(event) {
          if (event.defaultPrevented) return;
          if (!interactive) return;
          const keyMap = {
            ArrowUp() {
              send({ type: "TRIGGER.ARROW_UP" });
            },
            ArrowDown(event2) {
              send({ type: event2.altKey ? "OPEN" : "TRIGGER.ARROW_DOWN" });
            },
            ArrowLeft() {
              send({ type: "TRIGGER.ARROW_LEFT" });
            },
            ArrowRight() {
              send({ type: "TRIGGER.ARROW_RIGHT" });
            },
            Enter() {
              send({ type: "TRIGGER.ENTER" });
            },
            Space() {
              send({ type: "TRIGGER.ENTER" });
            }
          };
          const exec = keyMap[getEventKey(event, { dir: prop("dir") })];
          if (exec) {
            exec(event);
            event.preventDefault();
          }
        }
      });
    },
    getClearTriggerProps() {
      return normalize.button({
        ...parts.clearTrigger.attrs,
        dir: prop("dir"),
        id: dom.getClearTriggerId(scope),
        type: "button",
        "aria-label": "Clear value",
        hidden: !hasSelectedItems,
        "data-disabled": dataAttr(disabled),
        "data-readonly": dataAttr(prop("readOnly")),
        "data-invalid": dataAttr(prop("invalid")),
        disabled,
        onClick(event) {
          if (event.defaultPrevented) return;
          send({ type: "CLEAR_TRIGGER.CLICK" });
        }
      });
    },
    getPositionerProps() {
      return normalize.element({
        ...parts.positioner.attrs,
        dir: prop("dir"),
        id: dom.getPositionerId(scope),
        style: popperStyles.floating
      });
    },
    getContentProps() {
      const highlightedItemId = highlightedValue ? dom.getItemId(scope, highlightedValue.toString()) : void 0;
      return normalize.element({
        ...parts.content.attrs,
        id: dom.getContentId(scope),
        role: "listbox",
        "aria-labelledby": dom.getLabelId(scope),
        "aria-activedescendant": highlightedItemId,
        "data-activedescendant": highlightedItemId,
        "data-state": open ? "open" : "closed",
        "aria-multiselectable": prop("multiple"),
        "aria-required": prop("required"),
        "aria-readonly": prop("readOnly"),
        hidden: !open,
        tabIndex: 0,
        onKeyDown(event) {
          if (!interactive) return;
          if (!isSelfTarget(event)) return;
          if (event.key === "Tab") {
            const valid = isValidTabEvent(event);
            if (!valid) {
              event.preventDefault();
              return;
            }
          }
          const keyMap = {
            ArrowDown() {
              send({ type: "CONTENT.ARROW_DOWN" });
            },
            ArrowUp() {
              send({ type: "CONTENT.ARROW_UP" });
            },
            ArrowRight() {
              send({ type: "CONTENT.ARROW_RIGHT" });
            },
            ArrowLeft() {
              send({ type: "CONTENT.ARROW_LEFT" });
            },
            Home() {
              send({ type: "CONTENT.HOME" });
            },
            End() {
              send({ type: "CONTENT.END" });
            },
            Enter() {
              send({ type: "CONTENT.ENTER" });
            },
            " "() {
              send({ type: "CONTENT.ENTER" });
            }
          };
          const exec = keyMap[getEventKey(event, { dir: prop("dir") })];
          if (exec) {
            exec();
            event.preventDefault();
            return;
          }
          if (isEditableElement(event.target)) {
            return;
          }
        },
        onPointerMove(event) {
          if (!interactive) return;
          send({ type: "POINTER_MOVE", clientX: event.clientX, clientY: event.clientY, target: event.target });
        }
      });
    },
    getListProps(props) {
      const itemState = getItemState(props);
      return normalize.element({
        ...parts.list.attrs,
        id: dom.getListId(scope, itemState.value.toString()),
        dir: prop("dir"),
        "data-depth": itemState.depth,
        "aria-level": itemState.depth,
        role: "group"
      });
    },
    getIndicatorProps() {
      return normalize.element({
        ...parts.indicator.attrs,
        id: dom.getIndicatorId(scope),
        dir: prop("dir"),
        "aria-hidden": true,
        "data-state": open ? "open" : "closed",
        "data-disabled": dataAttr(disabled),
        "data-readonly": dataAttr(prop("readOnly")),
        "data-invalid": dataAttr(prop("invalid"))
      });
    },
    getItemProps(props) {
      const { indexPath } = props;
      const itemState = getItemState(props);
      return normalize.element({
        ...parts.item.attrs,
        id: dom.getItemId(scope, itemState.value.toString()),
        dir: prop("dir"),
        role: "treeitem",
        "aria-haspopup": itemState.hasChildren ? "menu" : void 0,
        "aria-expanded": itemState.hasChildren ? itemState.highlighted : false,
        "aria-controls": itemState.hasChildren ? dom.getListId(scope, itemState.value.toString()) : void 0,
        "aria-owns": itemState.hasChildren ? dom.getListId(scope, itemState.value.toString()) : void 0,
        "aria-disabled": ariaAttr(itemState.disabled),
        "data-value": itemState.value.toString(),
        "data-disabled": dataAttr(itemState.disabled),
        "data-highlighted": dataAttr(itemState.highlighted),
        "data-selected": dataAttr(itemState.selected),
        "data-depth": itemState.depth,
        "data-state": itemState.selected ? "checked" : "unchecked",
        "data-type": itemState.hasChildren ? "branch" : "leaf",
        "data-index-path": indexPath.toString(),
        onDoubleClick() {
          if (itemState.disabled) return;
          send({ type: "CLOSE" });
        },
        onClick(event) {
          if (event.defaultPrevented) return;
          if (!interactive) return;
          if (itemState.disabled) return;
          send({ type: "ITEM.CLICK", value: itemState.value, indexPath });
        },
        onPointerMove(event) {
          if (!interactive) return;
          if (itemState.disabled || event.pointerType !== "mouse") return;
          if (getInteractionModality() !== "pointer") return;
          if (isEqual(itemState.value, highlightedValue)) return;
          send({
            type: "ITEM.POINTER_ENTER",
            value: itemState.value,
            indexPath,
            clientX: event.clientX,
            clientY: event.clientY
          });
        },
        onPointerLeave(event) {
          if (!interactive) return;
          if (itemState.disabled) return;
          if (event.pointerType !== "mouse") return;
          if (getInteractionModality() !== "pointer") return;
          send({
            type: "ITEM.POINTER_LEAVE",
            value: itemState.value,
            indexPath,
            clientX: event.clientX,
            clientY: event.clientY
          });
        }
      });
    },
    getItemTextProps(props) {
      const { item } = props;
      const itemValue = collection2.getNodeValue(item);
      const itemState = getItemState(props);
      return normalize.element({
        dir: prop("dir"),
        ...parts.itemText.attrs,
        "data-value": itemValue,
        "data-highlighted": dataAttr(itemState.highlighted),
        "data-state": itemState.selected ? "checked" : "unchecked",
        "data-disabled": dataAttr(itemState.disabled)
      });
    },
    getItemIndicatorProps(props) {
      const { item } = props;
      const itemValue = collection2.getNodeValue(item);
      const itemState = getItemState(props);
      return normalize.element({
        ...parts.itemIndicator.attrs,
        dir: prop("dir"),
        "data-value": itemValue,
        "data-highlighted": dataAttr(itemState.highlighted),
        "data-type": itemState.hasChildren ? "branch" : "leaf",
        "data-state": itemState.selected ? "checked" : "unchecked",
        hidden: !itemState.selected
      });
    },
    getValueTextProps() {
      return normalize.element({
        ...parts.valueText.attrs,
        dir: prop("dir"),
        "data-disabled": dataAttr(disabled),
        "data-invalid": dataAttr(prop("invalid")),
        "data-focus": dataAttr(focused)
      });
    },
    getHiddenInputProps() {
      const defaultValue = context.hash("value");
      return normalize.input({
        name: prop("name"),
        form: prop("form"),
        disabled,
        multiple: prop("multiple"),
        required: prop("required"),
        readOnly: prop("readOnly"),
        hidden: true,
        "aria-hidden": true,
        id: dom.getHiddenInputId(scope),
        defaultValue,
        "aria-labelledby": dom.getLabelId(scope)
      });
    }
  };
}

// ../node_modules/.pnpm/@zag-js+rect-utils@1.43.3/node_modules/@zag-js/rect-utils/dist/closest.mjs
function closestSideToPoint(ref, p) {
  const { x, y } = p;
  const dl = x - ref.minX;
  const dr = ref.maxX - x;
  const dt = y - ref.minY;
  const db = ref.maxY - y;
  let closest2 = dl;
  let side = "left";
  if (dr < closest2) {
    closest2 = dr;
    side = "right";
  }
  if (dt < closest2) {
    closest2 = dt;
    side = "top";
  }
  if (db < closest2) {
    side = "bottom";
  }
  return side;
}

// ../node_modules/.pnpm/@zag-js+cascade-select@1.43.3/node_modules/@zag-js/cascade-select/dist/cascade-select.utils.mjs
function createGraceArea(exitPoint, triggerRect, targetRect, options = {}) {
  const { padding = 5 } = options;
  const triggerRectObj = createRect({
    x: triggerRect.left,
    y: triggerRect.top,
    width: triggerRect.width,
    height: triggerRect.height
  });
  const exitSide = closestSideToPoint(triggerRectObj, exitPoint);
  const paddedExitPoints = getPaddedExitPoints(exitPoint, exitSide, padding);
  const targetPoints = domRectToPoints(targetRect);
  return getConvexHull([...paddedExitPoints, ...targetPoints]);
}
function isPointerInGraceArea(point, graceArea) {
  return isPointInPolygon(graceArea, point);
}
function getPaddedExitPoints(exitPoint, exitSide, padding) {
  const { x, y } = exitPoint;
  switch (exitSide) {
    case "top":
      return [createPoint(x - padding, y + padding), createPoint(x + padding, y + padding)];
    case "bottom":
      return [createPoint(x - padding, y - padding), createPoint(x + padding, y - padding)];
    case "left":
      return [createPoint(x + padding, y - padding), createPoint(x + padding, y + padding)];
    case "right":
      return [createPoint(x - padding, y - padding), createPoint(x - padding, y + padding)];
    default:
      return [];
  }
}
function domRectToPoints(rect) {
  const rectObj = createRect({
    x: rect.left,
    y: rect.top,
    width: rect.width,
    height: rect.height
  });
  const corners = getRectCorners(rectObj);
  return [corners.top, corners.right, corners.bottom, corners.left];
}
function getConvexHull(points) {
  if (points.length <= 1) return points.slice();
  const sortedPoints = points.slice().sort((a, b) => {
    if (a.x !== b.x) return a.x - b.x;
    return a.y - b.y;
  });
  const lower = [];
  for (const point of sortedPoints) {
    while (lower.length >= 2 && crossProduct(lower[lower.length - 2], lower[lower.length - 1], point) <= 0) {
      lower.pop();
    }
    lower.push(point);
  }
  const upper = [];
  for (let i = sortedPoints.length - 1; i >= 0; i--) {
    const point = sortedPoints[i];
    while (upper.length >= 2 && crossProduct(upper[upper.length - 2], upper[upper.length - 1], point) <= 0) {
      upper.pop();
    }
    upper.push(point);
  }
  lower.pop();
  upper.pop();
  return lower.concat(upper);
}
function crossProduct(o, a, b) {
  return (a.x - o.x) * (b.y - o.y) - (a.y - o.y) * (b.x - o.x);
}

// ../node_modules/.pnpm/@zag-js+cascade-select@1.43.3/node_modules/@zag-js/cascade-select/dist/cascade-select.machine.mjs
var { or, and, not } = createGuards();
var machine = createMachine({
  props({ props }) {
    return {
      closeOnSelect: true,
      loopFocus: false,
      defaultValue: [],
      defaultHighlightedValue: [],
      defaultOpen: false,
      multiple: false,
      highlightTrigger: "click",
      allowParentSelection: false,
      positioning: {
        placement: "bottom-start",
        gutter: 8,
        ...props.positioning
      },
      ...props,
      collection: props.collection ?? collection.empty()
    };
  },
  context({ prop, bindable }) {
    return {
      value: bindable(() => ({
        defaultValue: prop("defaultValue"),
        value: prop("value"),
        isEqual,
        hash(value) {
          return value.join(", ");
        }
      })),
      highlightedValue: bindable(() => ({
        defaultValue: prop("defaultHighlightedValue"),
        value: prop("highlightedValue"),
        isEqual
      })),
      valueIndexPath: bindable(() => {
        const value = prop("value") ?? prop("defaultValue") ?? [];
        const paths = value.map((v) => prop("collection").getIndexPath(v));
        return {
          defaultValue: paths
        };
      }),
      highlightedIndexPath: bindable(() => {
        const value = prop("highlightedValue") ?? prop("defaultHighlightedValue") ?? null;
        return {
          defaultValue: value ? prop("collection").getIndexPath(value) : []
        };
      }),
      highlightedItems: bindable(() => ({
        defaultValue: []
      })),
      selectedItems: bindable(() => ({
        defaultValue: []
      })),
      currentPlacement: bindable(() => ({
        defaultValue: void 0
      })),
      fieldsetDisabled: bindable(() => ({
        defaultValue: false
      })),
      graceArea: bindable(() => ({
        defaultValue: null
      })),
      isPointerInTransit: bindable(() => ({
        defaultValue: false
      }))
    };
  },
  computed: {
    isInteractive: ({ prop }) => !(prop("disabled") || prop("readOnly")),
    valueAsString: ({ prop, context }) => {
      const collection2 = prop("collection");
      const items = context.get("selectedItems");
      const multiple = prop("multiple");
      const formatMultipleMode = (items2) => collection2.stringifyNode(items2.at(-1)) ?? collection2.getNodeValue(items2.at(-1));
      const formatSingleMode = (items2) => {
        return items2.map((item) => {
          return collection2.stringifyNode(item) ?? collection2.getNodeValue(item);
        }).join(" / ");
      };
      const defaultFormatValue = (items2) => items2.map(multiple ? formatMultipleMode : formatSingleMode).join(", ");
      const formatValue = prop("formatValue") ?? defaultFormatValue;
      return formatValue(items);
    }
  },
  initialState({ prop }) {
    const open = prop("open") || prop("defaultOpen");
    return open ? "open" : "idle";
  },
  watch({ context, prop, track, action }) {
    track([() => context.get("value")?.toString()], () => {
      action(["syncInputValue", "dispatchChangeEvent"]);
    });
    track([() => prop("open")], () => {
      action(["toggleVisibility"]);
    });
  },
  on: {
    "VALUE.SET": {
      actions: ["setValue"]
    },
    "VALUE.CLEAR": {
      actions: ["clearValue"]
    },
    "CLEAR_TRIGGER.CLICK": {
      actions: ["clearValue", "focusTriggerEl"]
    },
    "HIGHLIGHTED_VALUE.SET": {
      actions: ["setHighlightedValue"]
    },
    "HIGHLIGHTED_VALUE.CLEAR": {
      actions: ["clearHighlightedValue"]
    },
    "ITEM.SELECT": {
      actions: ["selectItem"]
    },
    "ITEM.CLEAR": {
      actions: ["clearItem"]
    }
  },
  effects: ["trackFormControlState"],
  states: {
    idle: {
      tags: ["closed"],
      on: {
        "CONTROLLED.OPEN": [
          {
            guard: "isTriggerClickEvent",
            target: "open",
            actions: ["setInitialFocus", "highlightFirstSelectedItem"]
          },
          {
            target: "open",
            actions: ["setInitialFocus"]
          }
        ],
        "TRIGGER.CLICK": [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["invokeOnOpen", "setInitialFocus", "highlightFirstSelectedItem"]
          }
        ],
        "TRIGGER.FOCUS": {
          target: "focused"
        },
        OPEN: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["setInitialFocus", "invokeOnOpen"]
          }
        ]
      }
    },
    focused: {
      tags: ["closed"],
      on: {
        "CONTROLLED.OPEN": [
          {
            guard: "isTriggerClickEvent",
            target: "open",
            actions: ["setInitialFocus", "highlightFirstSelectedItem"]
          },
          {
            guard: "isTriggerArrowUpEvent",
            target: "open",
            actions: ["setInitialFocus", "highlightLastItem"]
          },
          {
            guard: or("isTriggerArrowDownEvent", "isTriggerEnterEvent", ""),
            target: "open",
            actions: ["setInitialFocus", "highlightFirstItem"]
          },
          {
            target: "open",
            actions: ["setInitialFocus"]
          }
        ],
        OPEN: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["setInitialFocus", "invokeOnOpen"]
          }
        ],
        "TRIGGER.BLUR": {
          target: "idle"
        },
        "TRIGGER.CLICK": [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["setInitialFocus", "invokeOnOpen", "highlightFirstSelectedItem"]
          }
        ],
        "TRIGGER.ENTER": [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["setInitialFocus", "invokeOnOpen", "highlightFirstItem"]
          }
        ],
        "TRIGGER.ARROW_UP": [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["setInitialFocus", "invokeOnOpen", "highlightLastItem"]
          }
        ],
        "TRIGGER.ARROW_DOWN": [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["setInitialFocus", "invokeOnOpen", "highlightFirstItem"]
          }
        ],
        "TRIGGER.ARROW_LEFT": [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["invokeOnOpen"]
          }
        ],
        "TRIGGER.ARROW_RIGHT": [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["invokeOnOpen", "highlightFirstItem"]
          }
        ]
      }
    },
    open: {
      tags: ["open"],
      exit: ["scrollContentToTop"],
      effects: ["trackDismissableElement", "trackFocusVisible", "computePlacement", "scrollToHighlightedItems"],
      on: {
        "CONTROLLED.CLOSE": [
          {
            guard: "restoreFocus",
            target: "focused",
            actions: ["focusTriggerEl", "clearHighlightedValue"]
          },
          {
            target: "idle",
            actions: ["clearHighlightedValue"]
          }
        ],
        CLOSE: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnClose"]
          },
          {
            guard: "restoreFocus",
            target: "focused",
            actions: ["invokeOnClose", "focusTriggerEl", "clearHighlightedValue"]
          },
          {
            target: "idle",
            actions: ["invokeOnClose", "clearHighlightedValue"]
          }
        ],
        "TRIGGER.CLICK": [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnClose"]
          },
          {
            target: "focused",
            actions: ["invokeOnClose", "focusTriggerEl", "clearHighlightedValue"]
          }
        ],
        "ITEM.CLICK": [
          {
            guard: and("canSelectItem", and("shouldCloseOnSelect", not("multiple")), "isOpenControlled"),
            actions: ["selectItem", "invokeOnClose"]
          },
          {
            guard: and("canSelectItem", and("shouldCloseOnSelect", not("multiple"))),
            target: "focused",
            actions: ["selectItem", "invokeOnClose", "focusTriggerEl", "clearHighlightedValue"]
          },
          {
            guard: "canSelectItem",
            actions: ["selectItem"]
          },
          {
            // If can't select, at least highlight for click-based highlighting
            actions: ["setHighlightedValue"]
          }
        ],
        "ITEM.POINTER_ENTER": [
          {
            guard: "isHoverHighlight",
            actions: ["setHighlightingForHoveredItem"]
          }
        ],
        "ITEM.POINTER_LEAVE": [
          {
            guard: and("isHoverHighlight", "shouldHighlightOnHover"),
            actions: ["createGraceArea"]
          }
        ],
        POINTER_MOVE: [
          {
            guard: and(
              "isHoverHighlight",
              "hasGraceArea",
              "isPointerOutsideGraceArea",
              "isPointerNotInAnyItem",
              "hasHighlightedValue"
            ),
            actions: ["clearGraceArea"]
          }
        ],
        "GRACE_AREA.CLEAR": [
          {
            guard: "isHoverHighlight",
            actions: ["clearGraceArea"]
          }
        ],
        "CONTENT.HOME": {
          actions: ["highlightFirstItem"]
        },
        "CONTENT.END": {
          actions: ["highlightLastItem"]
        },
        "CONTENT.ARROW_DOWN": [
          {
            guard: or(not("hasHighlightedValue"), and("loop", "isHighlightedLastItem")),
            actions: ["highlightFirstItem"]
          },
          {
            actions: ["highlightNextItem"]
          }
        ],
        "CONTENT.ARROW_UP": [
          {
            guard: or(not("hasHighlightedValue"), and("loop", "isHighlightedFirstItem")),
            actions: ["highlightLastItem"]
          },
          {
            actions: ["highlightPreviousItem"]
          }
        ],
        "CONTENT.ARROW_RIGHT": [
          {
            guard: "canNavigateToChild",
            actions: ["highlightFirstChild"]
          }
        ],
        "CONTENT.ARROW_LEFT": [
          {
            guard: and("isAtRootLevel", "isOpenControlled"),
            actions: ["invokeOnClose", "focusTriggerEl"]
          },
          {
            guard: and("isAtRootLevel", "restoreFocus"),
            target: "focused",
            actions: ["invokeOnClose", "focusTriggerEl", "clearHighlightedValue"]
          },
          {
            guard: "isAtRootLevel",
            target: "idle",
            actions: ["invokeOnClose", "clearHighlightedValue"]
          },
          {
            guard: "canNavigateToParent",
            actions: ["highlightParent"]
          }
        ],
        "CONTENT.ENTER": [
          {
            guard: and(
              "canSelectHighlightedItem",
              and("shouldCloseOnSelectHighlighted", not("multiple")),
              "isOpenControlled"
            ),
            actions: ["selectHighlightedItem", "invokeOnClose"]
          },
          {
            guard: and("canSelectHighlightedItem", and("shouldCloseOnSelectHighlighted", not("multiple"))),
            target: "focused",
            actions: ["selectHighlightedItem", "invokeOnClose", "focusTriggerEl", "clearHighlightedValue"]
          },
          {
            guard: "canSelectHighlightedItem",
            actions: ["selectHighlightedItem"]
          }
        ],
        "POSITIONING.SET": {
          actions: ["reposition"]
        }
      }
    }
  },
  implementations: {
    guards: {
      restoreFocus: ({ event }) => restoreFocusFn(event),
      multiple: ({ prop }) => !!prop("multiple"),
      loop: ({ prop }) => !!prop("loopFocus"),
      isOpenControlled: ({ prop }) => !!prop("open"),
      isTriggerClickEvent: ({ event }) => event.previousEvent?.type === "TRIGGER.CLICK",
      isTriggerArrowUpEvent: ({ event }) => event.previousEvent?.type === "TRIGGER.ARROW_UP",
      isTriggerArrowDownEvent: ({ event }) => event.previousEvent?.type === "TRIGGER.ARROW_DOWN",
      isTriggerEnterEvent: ({ event }) => event.previousEvent?.type === "TRIGGER.ENTER",
      isTriggerArrowRightEvent: ({ event }) => event.previousEvent?.type === "TRIGGER.ARROW_RIGHT",
      hasHighlightedValue: ({ context }) => context.get("highlightedValue").length > 0,
      isHighlightedFirstItem: ({ context }) => context.get("highlightedIndexPath").at(-1) === 0,
      isHighlightedLastItem: ({ prop, context }) => {
        const path = context.get("highlightedIndexPath");
        const itemIndex = path.at(-1);
        if (!itemIndex && itemIndex !== 0) return false;
        const parentIndexPath = path.slice(0, -1);
        const collection2 = prop("collection");
        const nextSibling = collection2.at([...parentIndexPath, itemIndex + 1]);
        return !nextSibling;
      },
      shouldCloseOnSelect: ({ prop, event }) => {
        const collection2 = prop("collection");
        const node = collection2.at(event.indexPath);
        return prop("closeOnSelect") && node && !collection2.isBranchNode(node);
      },
      shouldCloseOnSelectHighlighted: ({ prop, context }) => {
        const collection2 = prop("collection");
        const items = context.get("highlightedItems");
        const node = last(items);
        return prop("closeOnSelect") && node != null && !collection2.isBranchNode(node);
      },
      canSelectItem: ({ prop, event }) => {
        const collection2 = prop("collection");
        const node = collection2.at(event.indexPath);
        if (!node) return false;
        return prop("allowParentSelection") || !collection2.isBranchNode(node);
      },
      canSelectHighlightedItem: ({ prop, context }) => {
        const collection2 = prop("collection");
        const node = collection2.at(context.get("highlightedIndexPath"));
        if (!node) return false;
        return prop("allowParentSelection") || !collection2.isBranchNode(node);
      },
      canNavigateToChild: ({ prop, context }) => {
        const highlightedIndexPath = context.get("highlightedIndexPath");
        if (!highlightedIndexPath.length) return false;
        const collection2 = prop("collection");
        const node = collection2.at(highlightedIndexPath);
        return node && collection2.isBranchNode(node);
      },
      canNavigateToParent: ({ context }) => context.get("highlightedIndexPath").length > 1,
      isAtRootLevel: ({ context }) => context.get("highlightedIndexPath").length <= 1,
      isHoverHighlight: ({ prop }) => prop("highlightTrigger") === "hover",
      shouldHighlightOnHover: ({ prop, event }) => {
        const collection2 = prop("collection");
        const node = collection2.at(event.indexPath);
        return node && collection2.isBranchNode(node);
      },
      shouldUpdateHighlightedIndexPath: ({ prop, context, event }) => {
        const collection2 = prop("collection");
        const currentHighlightedIndexPath = context.get("highlightedIndexPath");
        if (!currentHighlightedIndexPath || currentHighlightedIndexPath.length === 0) {
          return false;
        }
        const node = collection2.at(event.indexPath);
        if (!node || collection2.isBranchNode(node)) {
          return false;
        }
        const indexPath = event.indexPath;
        if (!indexPath) return false;
        const minLength = Math.min(indexPath.length, currentHighlightedIndexPath.length);
        let commonPrefixLength = 0;
        for (let i = 0; i < minLength; i++) {
          if (indexPath[i] === currentHighlightedIndexPath[i]) {
            commonPrefixLength = i + 1;
          } else {
            break;
          }
        }
        return commonPrefixLength > 0 && (commonPrefixLength < currentHighlightedIndexPath.length || commonPrefixLength < indexPath.length);
      },
      hasGraceArea: ({ context }) => {
        return context.get("graceArea") != null;
      },
      isPointerOutsideGraceArea: ({ context, event }) => {
        const graceArea = context.get("graceArea");
        if (!graceArea) return false;
        const point = { x: event.clientX, y: event.clientY };
        return !isPointerInGraceArea(point, graceArea);
      },
      isPointerNotInAnyItem: ({ event }) => {
        const target = event.target;
        const itemElement = target.closest('[data-part="item"]');
        const contentElement = target.closest('[data-part="content"]');
        return !contentElement || !itemElement && !!contentElement;
      }
    },
    effects: {
      trackFormControlState({ context, scope, prop }) {
        return trackFormControl(dom.getTriggerEl(scope), {
          onFieldsetDisabledChange(disabled) {
            context.set("fieldsetDisabled", disabled);
          },
          onFormReset() {
            context.set("value", prop("defaultValue") ?? []);
          }
        });
      },
      trackFocusVisible({ scope }) {
        return trackFocusVisible({ root: scope.getRootNode?.() });
      },
      trackDismissableElement({ scope, send, prop }) {
        const contentEl = () => dom.getContentEl(scope);
        let restoreFocus = true;
        return trackDismissableElement(contentEl, {
          defer: true,
          exclude: [dom.getTriggerEl(scope), dom.getClearTriggerEl(scope)],
          onFocusOutside: prop("onFocusOutside"),
          onPointerDownOutside: prop("onPointerDownOutside"),
          onInteractOutside(event) {
            prop("onInteractOutside")?.(event);
            restoreFocus = !(event.detail.focusable || event.detail.contextmenu);
          },
          onDismiss() {
            send({ type: "CLOSE", src: "interact-outside", restoreFocus });
          }
        });
      },
      computePlacement({ context, prop, scope }) {
        const triggerEl = () => dom.getTriggerEl(scope);
        const positionerEl = () => dom.getPositionerEl(scope);
        return getPlacement(triggerEl, positionerEl, {
          ...prop("positioning"),
          onComplete(data) {
            context.set("currentPlacement", data.placement);
          }
        });
      },
      scrollToHighlightedItems({ context, prop, scope }) {
        let cleanups = [];
        const exec = (immediate) => {
          const highlightedValue = context.get("highlightedValue");
          const highlightedIndexPath = context.get("highlightedIndexPath");
          if (!highlightedIndexPath.length) return;
          const modality = getInteractionModality();
          if (modality === "pointer") return;
          const listEls = dom.getListEls(scope);
          listEls.forEach((listEl, index) => {
            const itemPath = highlightedIndexPath.slice(0, index + 1);
            const itemEl = dom.getItemEl(scope, highlightedValue.toString());
            const scrollToIndexFn = prop("scrollToIndexFn");
            if (scrollToIndexFn) {
              const itemIndexInList = itemPath[itemPath.length - 1];
              scrollToIndexFn({ index: itemIndexInList, immediate, depth: index });
              return;
            }
            const raf_cleanup = raf(() => {
              scrollIntoView(itemEl, { rootEl: listEl, block: "nearest" });
            });
            cleanups.push(raf_cleanup);
          });
        };
        raf(() => {
          setInteractionModality("virtual");
          exec(true);
        });
        const rafCleanup = raf(() => exec(true));
        cleanups.push(rafCleanup);
        const contentEl = dom.getContentEl(scope);
        const observerCleanup = observeAttributes(contentEl, {
          attributes: ["data-activedescendant"],
          callback: () => exec(false)
        });
        cleanups.push(observerCleanup);
        return () => {
          cleanups.forEach((cleanup) => cleanup());
        };
      }
    },
    actions: {
      setValue(params) {
        set.value(params, params.event.value);
      },
      clearValue(params) {
        set.value(params, []);
      },
      setHighlightedValue(params) {
        const { event } = params;
        set.highlightedValue(params, event.value);
      },
      clearHighlightedValue(params) {
        set.highlightedValue(params, []);
      },
      reposition({ context, prop, scope, event }) {
        const positionerEl = () => dom.getPositionerEl(scope);
        getPlacement(dom.getTriggerEl(scope), positionerEl, {
          ...prop("positioning"),
          ...event.options,
          defer: true,
          listeners: false,
          onComplete(data) {
            context.set("currentPlacement", data.placement);
          }
        });
      },
      selectItem(params) {
        const { context, prop, event } = params;
        const collection2 = prop("collection");
        const multiple = prop("multiple");
        const value = context.get("value");
        const itemValue = event.value;
        const indexPath = event.indexPath ?? collection2.getIndexPath(itemValue);
        const node = collection2.at(indexPath);
        const hasChildren = collection2.isBranchNode(node);
        if (prop("allowParentSelection")) {
          if (multiple) {
            const filteredValue = value.filter((v) => {
              const shortPath = v.length < itemValue.length ? v : itemValue;
              const longPath = v.length < itemValue.length ? itemValue : v;
              const hasRelation = longPath.slice(0, shortPath.length).every((val, i) => val === shortPath[i]);
              return !hasRelation && !isEqual(v, itemValue);
            });
            set.value(params, [...filteredValue, itemValue]);
          } else {
            set.value(params, [itemValue]);
          }
          if (hasChildren) set.highlightedValue(params, itemValue);
        } else {
          if (hasChildren) {
            if (multiple && value.length > 0) {
              set.value(params, [...value.slice(0, -1), itemValue]);
            } else {
              set.value(params, [itemValue]);
            }
            set.highlightedValue(params, itemValue);
          } else {
            if (multiple) {
              const existingIndex = value.findIndex((path) => isEqual(path, itemValue));
              if (existingIndex >= 0) {
                const newValues = [...value];
                newValues.splice(existingIndex, 1);
                set.value(params, newValues);
              } else {
                set.value(params, [...value, itemValue]);
              }
            } else {
              set.value(params, [itemValue]);
            }
          }
        }
      },
      clearItem(params) {
        const { context, event } = params;
        const value = context.get("value");
        const newValue = value.filter((v) => !isEqual(v, event.value));
        set.value(params, newValue);
      },
      selectHighlightedItem({ context, send }) {
        const indexPath = context.get("highlightedIndexPath");
        const value = context.get("highlightedValue");
        if (value) {
          send({ type: "ITEM.SELECT", value, indexPath });
        }
      },
      highlightFirstItem(params) {
        const { context, prop } = params;
        const collection2 = prop("collection");
        const highlightedValue = context.get("highlightedValue");
        let parentNode;
        if (!highlightedValue.length) {
          parentNode = collection2.rootNode;
        } else {
          const indexPath = context.get("highlightedIndexPath");
          parentNode = collection2.getParentNode(indexPath) ?? collection2.rootNode;
        }
        const children = collection2.getNodeChildren(parentNode);
        const firstChild = children.find((child) => !collection2.getNodeDisabled(child));
        if (!firstChild) return;
        const firstValue = collection2.getNodeValue(firstChild);
        if (!highlightedValue.length) {
          set.highlightedValue(params, [firstValue]);
        } else {
          const parentPath = highlightedValue.slice(0, -1);
          set.highlightedValue(params, [...parentPath, firstValue]);
        }
      },
      highlightLastItem(params) {
        const { context, prop } = params;
        const collection2 = prop("collection");
        const highlightedValue = context.get("highlightedValue");
        let parentNode;
        if (!highlightedValue.length) {
          parentNode = collection2.rootNode;
        } else {
          const indexPath = context.get("highlightedIndexPath");
          parentNode = collection2.getParentNode(indexPath) ?? collection2.rootNode;
        }
        const children = collection2.getNodeChildren(parentNode);
        const lastChild = children.findLast((child) => !collection2.getNodeDisabled(child));
        if (!lastChild) return;
        const lastValue = collection2.getNodeValue(lastChild);
        if (!highlightedValue.length) {
          set.highlightedValue(params, [lastValue]);
        } else {
          const parentPath = highlightedValue.slice(0, -1);
          set.highlightedValue(params, [...parentPath, lastValue]);
        }
      },
      highlightNextItem(params) {
        const { context, prop } = params;
        const collection2 = prop("collection");
        const highlightedValue = context.get("highlightedValue");
        if (!highlightedValue.length) return;
        const indexPath = context.get("highlightedIndexPath");
        const nextSibling = collection2.getNextSibling(indexPath);
        if (!nextSibling) return;
        const nextValue = collection2.getNodeValue(nextSibling);
        if (highlightedValue.length === 1) {
          set.highlightedValue(params, [nextValue]);
        } else {
          const parentPath = highlightedValue.slice(0, -1);
          set.highlightedValue(params, [...parentPath, nextValue]);
        }
      },
      highlightPreviousItem(params) {
        const { context, prop } = params;
        const collection2 = prop("collection");
        const highlightedValue = context.get("highlightedValue");
        if (!highlightedValue.length) return;
        const indexPath = context.get("highlightedIndexPath");
        const previousSibling = collection2.getPreviousSibling(indexPath);
        if (!previousSibling) return;
        const prevValue = collection2.getNodeValue(previousSibling);
        if (highlightedValue.length === 1) {
          set.highlightedValue(params, [prevValue]);
        } else {
          const parentPath = highlightedValue.slice(0, -1);
          set.highlightedValue(params, [...parentPath, prevValue]);
        }
      },
      highlightFirstChild(params) {
        const { context, prop } = params;
        const collection2 = prop("collection");
        const highlightedValue = context.get("highlightedValue");
        if (!highlightedValue.length) return;
        const indexPath = context.get("highlightedIndexPath");
        const node = collection2.getFirstNode(collection2.at(indexPath));
        if (!node) return;
        const childValue = collection2.getNodeValue(node);
        set.highlightedValue(params, [...highlightedValue, childValue]);
      },
      highlightParent(params) {
        const { context } = params;
        const highlightedValue = context.get("highlightedValue");
        if (!highlightedValue.length) return;
        const parentPath = highlightedValue.slice(0, -1);
        set.highlightedValue(params, parentPath);
      },
      setInitialFocus({ scope }) {
        raf(() => {
          const contentEl = dom.getContentEl(scope);
          contentEl?.focus({ preventScroll: true });
        });
      },
      focusTriggerEl({ event, scope }) {
        if (!restoreFocusFn(event)) return;
        raf(() => {
          const triggerEl = dom.getTriggerEl(scope);
          triggerEl?.focus({ preventScroll: true });
        });
      },
      invokeOnOpen({ prop, context }) {
        prop("onOpenChange")?.({ open: true, value: context.get("value") });
      },
      invokeOnClose({ prop, context }) {
        prop("onOpenChange")?.({ open: false, value: context.get("value") });
      },
      toggleVisibility({ send, prop }) {
        if (prop("open") != null) {
          send({ type: prop("open") ? "CONTROLLED.OPEN" : "CONTROLLED.CLOSE" });
        }
      },
      highlightFirstSelectedItem(params) {
        const { context } = params;
        const value = context.get("value");
        if (isEmpty(value)) return;
        const mostRecentSelection = last(value);
        if (mostRecentSelection) {
          set.highlightedValue(params, mostRecentSelection);
        }
      },
      createGraceArea({ context, event, scope }) {
        const value = event.value.toString();
        const triggerElement = dom.getItemEl(scope, value);
        if (!triggerElement) return;
        const exitPoint = { x: event.clientX, y: event.clientY };
        const triggerRect = triggerElement.getBoundingClientRect();
        const nextLevelEl = dom.getListEl(scope, value);
        if (!nextLevelEl) {
          return;
        }
        const targetRect = nextLevelEl.getBoundingClientRect();
        const graceArea = createGraceArea(exitPoint, triggerRect, targetRect);
        context.set("graceArea", graceArea);
        setTimeout(() => {
          context.set("graceArea", null);
        }, 300);
      },
      clearGraceArea({ context }) {
        context.set("graceArea", null);
      },
      setHighlightingForHoveredItem(params) {
        const { prop, event } = params;
        const collection2 = prop("collection");
        const node = collection2.at(event.indexPath);
        let newHighlightedValue;
        if (node && collection2.isBranchNode(node)) {
          newHighlightedValue = event.value;
        } else {
          newHighlightedValue = event.value.slice(0, -1);
        }
        set.highlightedValue(params, newHighlightedValue);
      },
      syncInputValue({ context, scope }) {
        const inputEl = dom.getHiddenInputEl(scope);
        if (!inputEl) return;
        setElementValue(inputEl, context.hash("value"));
      },
      dispatchChangeEvent({ scope, context }) {
        dispatchInputValueEvent(dom.getHiddenInputEl(scope), { value: context.hash("value") });
      },
      scrollContentToTop({ scope, prop }) {
        const scrollToIndexFn = prop("scrollToIndexFn");
        raf(() => {
          const contentEl = dom.getContentEl(scope);
          const listEls = contentEl?.querySelectorAll('[data-part="list"]');
          listEls?.forEach((listEl, index) => {
            if (scrollToIndexFn) {
              scrollToIndexFn({ index: 0, immediate: true, depth: index });
            } else {
              listEl.scrollTop = 0;
            }
          });
        });
      }
    }
  }
});
var set = {
  value({ context, prop }, value) {
    const collection2 = prop("collection");
    context.set("value", value);
    const valueIndexPath = value.map((v) => collection2.getIndexPath(v));
    context.set("valueIndexPath", valueIndexPath);
    const selectedItems = valueIndexPath.map((indexPath) => {
      return indexPath.map((_, index) => {
        const partialPath = indexPath.slice(0, index + 1);
        return collection2.at(partialPath);
      });
    });
    context.set("selectedItems", selectedItems);
    prop("onValueChange")?.({ value, items: selectedItems });
  },
  highlightedValue({ context, prop }, value) {
    const collection2 = prop("collection");
    context.set("highlightedValue", value);
    const rawPath = value == null ? [] : collection2.getIndexPath(value);
    const highlightedIndexPath = rawPath ?? [];
    context.set("highlightedIndexPath", highlightedIndexPath);
    const highlightedItems = highlightedIndexPath.map((_, index) => {
      const partialPath = highlightedIndexPath.slice(0, index + 1);
      return collection2.at(partialPath);
    });
    context.set("highlightedItems", highlightedItems);
    prop("onHighlightChange")?.({ highlightedValue: value, highlightedItems });
  }
};
function restoreFocusFn(event) {
  const v = event.restoreFocus ?? event.previousEvent?.restoreFocus;
  return v == null || !!v;
}

// components/cascade-select.ts
function createCollection(rootNode) {
  return collection({
    nodeToValue: (node) => node.value,
    nodeToString: (node) => node.label ?? node.name ?? node.value,
    rootNode
  });
}
var CascadeSelect = class extends Component {
  constructor(el, props) {
    const { rootNode, ...rest } = props;
    super(el, { ...rest, collection: createCollection(rootNode) });
  }
  updateProps(props) {
    const { rootNode, ...rest } = props;
    if (rootNode) {
      return super.updateProps({ ...rest, collection: createCollection(rootNode) });
    }
    return super.updateProps(rest);
  }
  initMachine(props) {
    return new VanillaMachine(machine, props);
  }
  initApi() {
    return this.zagConnect(connect);
  }
  render() {
    const root = this.el.querySelector('[data-scope="cascade-select"][data-part="root"]') ?? this.el;
    this.spreadProps(root, this.api.getRootProps());
    const trigger = this.el.querySelector(
      '[data-scope="cascade-select"][data-part="trigger"]'
    );
    if (trigger) this.spreadProps(trigger, this.api.getTriggerProps());
    const positioner = this.el.querySelector(
      '[data-scope="cascade-select"][data-part="positioner"]'
    );
    if (positioner) this.spreadProps(positioner, this.api.getPositionerProps());
    const content = this.el.querySelector(
      '[data-scope="cascade-select"][data-part="content"]'
    );
    if (content) this.spreadProps(content, this.api.getContentProps());
    const hidden = this.el.querySelector(
      '[data-scope="cascade-select"][data-part="hidden-input"]'
    );
    if (hidden) this.spreadProps(hidden, this.api.getHiddenInputProps());
    const col = this.api.collection;
    const children = col.getNodeChildren(col.rootNode);
    children.forEach((item, index) => {
      const value = [item.value];
      const indexPath = [index];
      const selector = `[data-scope="cascade-select"][data-part="item"][data-value="${CSS.escape(item.value)}"]`;
      let node = content?.querySelector(selector);
      if (!node && content) {
        node = document.createElement("div");
        node.dataset.scope = "cascade-select";
        node.dataset.part = "item";
        node.dataset.value = item.value;
        node.textContent = item.label ?? item.value;
        content.appendChild(node);
      }
      if (node) this.spreadProps(node, this.api.getItemProps({ item, indexPath, value }));
    });
  }
};

// hooks/cascade-select.ts
var DEFAULT_ROOT = {
  value: "root",
  label: "root",
  children: [
    {
      value: "fruit",
      label: "Fruit",
      children: [
        { value: "apple", label: "Apple" },
        { value: "banana", label: "Banana" }
      ]
    },
    { value: "veg", label: "Vegetable", children: [{ value: "carrot", label: "Carrot" }] }
  ]
};
function cascadeSelectProps(el, hook) {
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
    rootNode: safeParseJson(el.dataset.tree, DEFAULT_ROOT),
    disabled: getBoolean(el, "disabled"),
    onValueChange
  };
}
var CascadeSelectHook = createZagLiveHook({
  key: "cascade-select",
  mount(hook) {
    return new CascadeSelect(hook.el, cascadeSelectProps(hook.el, hook));
  },
  update(hook, inst) {
    inst.updateProps(cascadeSelectProps(hook.el, hook));
  }
});
export {
  CascadeSelectHook as CascadeSelect
};
