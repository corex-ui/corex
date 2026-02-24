import {
  ListCollection
} from "./chunk-MWK4GDRX.mjs";
import {
  getPlacement,
  getPlacementStyles
} from "./chunk-QYWY7F3J.mjs";
import {
  trackDismissableElement
} from "./chunk-CHUGBG5L.mjs";
import "./chunk-DTH4G7GO.mjs";
import {
  getInteractionModality,
  setInteractionModality,
  trackFocusVisible
} from "./chunk-EDSYBTWY.mjs";
import {
  Component,
  VanillaMachine,
  addOrRemove,
  ariaAttr,
  contains,
  createAnatomy,
  createGuards,
  createMachine,
  createProps,
  createSplitProps,
  dataAttr,
  ensure,
  getBoolean,
  getByTypeahead,
  getEventKey,
  getEventTarget,
  getInitialFocus,
  getNativeEvent,
  getString,
  getStringList,
  isEditableElement,
  isEqual,
  isInternalChangeEvent,
  isValidTabEvent,
  markAsInternalChangeEvent,
  normalizeProps,
  observeAttributes,
  raf,
  scrollIntoView,
  trackFormControl,
  visuallyHiddenStyle
} from "./chunk-PLUM2DEK.mjs";

// ../node_modules/.pnpm/@zag-js+select@1.34.1/node_modules/@zag-js/select/dist/index.mjs
var anatomy = createAnatomy("select").parts(
  "label",
  "positioner",
  "trigger",
  "indicator",
  "clearTrigger",
  "item",
  "itemText",
  "itemIndicator",
  "itemGroup",
  "itemGroupLabel",
  "list",
  "content",
  "root",
  "control",
  "valueText"
);
var parts = anatomy.build();
var collection = (options) => {
  return new ListCollection(options);
};
collection.empty = () => {
  return new ListCollection({ items: [] });
};
var getRootId = (ctx) => ctx.ids?.root ?? `select:${ctx.id}`;
var getContentId = (ctx) => ctx.ids?.content ?? `select:${ctx.id}:content`;
var getTriggerId = (ctx) => ctx.ids?.trigger ?? `select:${ctx.id}:trigger`;
var getClearTriggerId = (ctx) => ctx.ids?.clearTrigger ?? `select:${ctx.id}:clear-trigger`;
var getLabelId = (ctx) => ctx.ids?.label ?? `select:${ctx.id}:label`;
var getControlId = (ctx) => ctx.ids?.control ?? `select:${ctx.id}:control`;
var getItemId = (ctx, id) => ctx.ids?.item?.(id) ?? `select:${ctx.id}:option:${id}`;
var getHiddenSelectId = (ctx) => ctx.ids?.hiddenSelect ?? `select:${ctx.id}:select`;
var getPositionerId = (ctx) => ctx.ids?.positioner ?? `select:${ctx.id}:positioner`;
var getItemGroupId = (ctx, id) => ctx.ids?.itemGroup?.(id) ?? `select:${ctx.id}:optgroup:${id}`;
var getItemGroupLabelId = (ctx, id) => ctx.ids?.itemGroupLabel?.(id) ?? `select:${ctx.id}:optgroup-label:${id}`;
var getHiddenSelectEl = (ctx) => ctx.getById(getHiddenSelectId(ctx));
var getContentEl = (ctx) => ctx.getById(getContentId(ctx));
var getTriggerEl = (ctx) => ctx.getById(getTriggerId(ctx));
var getClearTriggerEl = (ctx) => ctx.getById(getClearTriggerId(ctx));
var getPositionerEl = (ctx) => ctx.getById(getPositionerId(ctx));
var getItemEl = (ctx, id) => {
  if (id == null) return null;
  return ctx.getById(getItemId(ctx, id));
};
function connect(service, normalize) {
  const { context, prop, scope, state, computed, send } = service;
  const disabled = prop("disabled") || context.get("fieldsetDisabled");
  const invalid = !!prop("invalid");
  const required = !!prop("required");
  const readOnly = !!prop("readOnly");
  const composite = prop("composite");
  const collection2 = prop("collection");
  const open = state.hasTag("open");
  const focused = state.matches("focused");
  const highlightedValue = context.get("highlightedValue");
  const highlightedItem = context.get("highlightedItem");
  const selectedItems = context.get("selectedItems");
  const currentPlacement = context.get("currentPlacement");
  const isTypingAhead = computed("isTypingAhead");
  const interactive = computed("isInteractive");
  const ariaActiveDescendant = highlightedValue ? getItemId(scope, highlightedValue) : void 0;
  function getItemState(props2) {
    const _disabled = collection2.getItemDisabled(props2.item);
    const value = collection2.getItemValue(props2.item);
    ensure(value, () => `[zag-js] No value found for item ${JSON.stringify(props2.item)}`);
    return {
      value,
      disabled: Boolean(disabled || _disabled),
      highlighted: highlightedValue === value,
      selected: context.get("value").includes(value)
    };
  }
  const popperStyles = getPlacementStyles({
    ...prop("positioning"),
    placement: currentPlacement
  });
  return {
    open,
    focused,
    empty: context.get("value").length === 0,
    highlightedItem,
    highlightedValue,
    selectedItems,
    hasSelectedItems: computed("hasSelectedItems"),
    value: context.get("value"),
    valueAsString: computed("valueAsString"),
    collection: collection2,
    multiple: !!prop("multiple"),
    disabled: !!disabled,
    reposition(options = {}) {
      send({ type: "POSITIONING.SET", options });
    },
    focus() {
      getTriggerEl(scope)?.focus({ preventScroll: true });
    },
    setOpen(nextOpen) {
      const open2 = state.hasTag("open");
      if (open2 === nextOpen) return;
      send({ type: nextOpen ? "OPEN" : "CLOSE" });
    },
    selectValue(value) {
      send({ type: "ITEM.SELECT", value });
    },
    setValue(value) {
      send({ type: "VALUE.SET", value });
    },
    selectAll() {
      send({ type: "VALUE.SET", value: collection2.getValues() });
    },
    setHighlightValue(value) {
      send({ type: "HIGHLIGHTED_VALUE.SET", value });
    },
    clearHighlightValue() {
      send({ type: "HIGHLIGHTED_VALUE.CLEAR" });
    },
    clearValue(value) {
      if (value) {
        send({ type: "ITEM.CLEAR", value });
      } else {
        send({ type: "VALUE.CLEAR" });
      }
    },
    getItemState,
    getRootProps() {
      return normalize.element({
        ...parts.root.attrs,
        dir: prop("dir"),
        id: getRootId(scope),
        "data-invalid": dataAttr(invalid),
        "data-readonly": dataAttr(readOnly)
      });
    },
    getLabelProps() {
      return normalize.label({
        dir: prop("dir"),
        id: getLabelId(scope),
        ...parts.label.attrs,
        "data-disabled": dataAttr(disabled),
        "data-invalid": dataAttr(invalid),
        "data-readonly": dataAttr(readOnly),
        "data-required": dataAttr(required),
        htmlFor: getHiddenSelectId(scope),
        onClick(event) {
          if (event.defaultPrevented) return;
          if (disabled) return;
          getTriggerEl(scope)?.focus({ preventScroll: true });
        }
      });
    },
    getControlProps() {
      return normalize.element({
        ...parts.control.attrs,
        dir: prop("dir"),
        id: getControlId(scope),
        "data-state": open ? "open" : "closed",
        "data-focus": dataAttr(focused),
        "data-disabled": dataAttr(disabled),
        "data-invalid": dataAttr(invalid)
      });
    },
    getValueTextProps() {
      return normalize.element({
        ...parts.valueText.attrs,
        dir: prop("dir"),
        "data-disabled": dataAttr(disabled),
        "data-invalid": dataAttr(invalid),
        "data-focus": dataAttr(focused)
      });
    },
    getTriggerProps() {
      return normalize.button({
        id: getTriggerId(scope),
        disabled,
        dir: prop("dir"),
        type: "button",
        role: "combobox",
        "aria-controls": getContentId(scope),
        "aria-expanded": open,
        "aria-haspopup": "listbox",
        "data-state": open ? "open" : "closed",
        "aria-invalid": invalid,
        "aria-required": required,
        "aria-labelledby": getLabelId(scope),
        ...parts.trigger.attrs,
        "data-disabled": dataAttr(disabled),
        "data-invalid": dataAttr(invalid),
        "data-readonly": dataAttr(readOnly),
        "data-placement": currentPlacement,
        "data-placeholder-shown": dataAttr(!computed("hasSelectedItems")),
        onClick(event) {
          if (!interactive) return;
          if (event.defaultPrevented) return;
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
            Home() {
              send({ type: "TRIGGER.HOME" });
            },
            End() {
              send({ type: "TRIGGER.END" });
            },
            Enter() {
              send({ type: "TRIGGER.ENTER" });
            },
            Space(event2) {
              if (isTypingAhead) {
                send({ type: "TRIGGER.TYPEAHEAD", key: event2.key });
              } else {
                send({ type: "TRIGGER.ENTER" });
              }
            }
          };
          const exec = keyMap[getEventKey(event, {
            dir: prop("dir"),
            orientation: "vertical"
          })];
          if (exec) {
            exec(event);
            event.preventDefault();
            return;
          }
          if (getByTypeahead.isValidEvent(event)) {
            send({ type: "TRIGGER.TYPEAHEAD", key: event.key });
            event.preventDefault();
          }
        }
      });
    },
    getIndicatorProps() {
      return normalize.element({
        ...parts.indicator.attrs,
        dir: prop("dir"),
        "aria-hidden": true,
        "data-state": open ? "open" : "closed",
        "data-disabled": dataAttr(disabled),
        "data-invalid": dataAttr(invalid),
        "data-readonly": dataAttr(readOnly)
      });
    },
    getItemProps(props2) {
      const itemState = getItemState(props2);
      return normalize.element({
        id: getItemId(scope, itemState.value),
        role: "option",
        ...parts.item.attrs,
        dir: prop("dir"),
        "data-value": itemState.value,
        "aria-selected": itemState.selected,
        "data-state": itemState.selected ? "checked" : "unchecked",
        "data-highlighted": dataAttr(itemState.highlighted),
        "data-disabled": dataAttr(itemState.disabled),
        "aria-disabled": ariaAttr(itemState.disabled),
        onPointerMove(event) {
          if (itemState.disabled || event.pointerType !== "mouse") return;
          if (itemState.value === highlightedValue) return;
          send({ type: "ITEM.POINTER_MOVE", value: itemState.value });
        },
        onClick(event) {
          if (event.defaultPrevented) return;
          if (itemState.disabled) return;
          send({ type: "ITEM.CLICK", src: "pointerup", value: itemState.value });
        },
        onPointerLeave(event) {
          if (itemState.disabled) return;
          if (props2.persistFocus) return;
          if (event.pointerType !== "mouse") return;
          const pointerMoved = service.event.previous()?.type.includes("POINTER");
          if (!pointerMoved) return;
          send({ type: "ITEM.POINTER_LEAVE" });
        }
      });
    },
    getItemTextProps(props2) {
      const itemState = getItemState(props2);
      return normalize.element({
        ...parts.itemText.attrs,
        "data-state": itemState.selected ? "checked" : "unchecked",
        "data-disabled": dataAttr(itemState.disabled),
        "data-highlighted": dataAttr(itemState.highlighted)
      });
    },
    getItemIndicatorProps(props2) {
      const itemState = getItemState(props2);
      return normalize.element({
        "aria-hidden": true,
        ...parts.itemIndicator.attrs,
        "data-state": itemState.selected ? "checked" : "unchecked",
        hidden: !itemState.selected
      });
    },
    getItemGroupLabelProps(props2) {
      const { htmlFor } = props2;
      return normalize.element({
        ...parts.itemGroupLabel.attrs,
        id: getItemGroupLabelId(scope, htmlFor),
        dir: prop("dir"),
        role: "presentation"
      });
    },
    getItemGroupProps(props2) {
      const { id } = props2;
      return normalize.element({
        ...parts.itemGroup.attrs,
        "data-disabled": dataAttr(disabled),
        id: getItemGroupId(scope, id),
        "aria-labelledby": getItemGroupLabelId(scope, id),
        role: "group",
        dir: prop("dir")
      });
    },
    getClearTriggerProps() {
      return normalize.button({
        ...parts.clearTrigger.attrs,
        id: getClearTriggerId(scope),
        type: "button",
        "aria-label": "Clear value",
        "data-invalid": dataAttr(invalid),
        disabled,
        hidden: !computed("hasSelectedItems"),
        dir: prop("dir"),
        onClick(event) {
          if (event.defaultPrevented) return;
          send({ type: "CLEAR.CLICK" });
        }
      });
    },
    getHiddenSelectProps() {
      const value = context.get("value");
      const defaultValue = prop("multiple") ? value : value?.[0];
      const handleChange = (e) => {
        const evt = getNativeEvent(e);
        if (isInternalChangeEvent(evt)) return;
        send({ type: "VALUE.SET", value: getSelectedValues(e.currentTarget) });
      };
      return normalize.select({
        name: prop("name"),
        form: prop("form"),
        disabled,
        multiple: prop("multiple"),
        required: prop("required"),
        "aria-hidden": true,
        id: getHiddenSelectId(scope),
        defaultValue,
        style: visuallyHiddenStyle,
        tabIndex: -1,
        autoComplete: prop("autoComplete"),
        onChange: handleChange,
        onInput: handleChange,
        // Some browser extensions will focus the hidden select.
        // Let's forward the focus to the trigger.
        onFocus() {
          getTriggerEl(scope)?.focus({ preventScroll: true });
        },
        "aria-labelledby": getLabelId(scope)
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
    getContentProps() {
      return normalize.element({
        hidden: !open,
        dir: prop("dir"),
        id: getContentId(scope),
        role: composite ? "listbox" : "dialog",
        ...parts.content.attrs,
        "data-state": open ? "open" : "closed",
        "data-placement": currentPlacement,
        "data-activedescendant": ariaActiveDescendant,
        "aria-activedescendant": composite ? ariaActiveDescendant : void 0,
        "aria-multiselectable": prop("multiple") && composite ? true : void 0,
        "aria-labelledby": getLabelId(scope),
        tabIndex: 0,
        onKeyDown(event) {
          if (!interactive) return;
          if (!contains(event.currentTarget, getEventTarget(event))) return;
          if (event.key === "Tab") {
            const valid = isValidTabEvent(event);
            if (!valid) {
              event.preventDefault();
              return;
            }
          }
          const keyMap = {
            ArrowUp() {
              send({ type: "CONTENT.ARROW_UP" });
            },
            ArrowDown() {
              send({ type: "CONTENT.ARROW_DOWN" });
            },
            Home() {
              send({ type: "CONTENT.HOME" });
            },
            End() {
              send({ type: "CONTENT.END" });
            },
            Enter() {
              send({ type: "ITEM.CLICK", src: "keydown.enter" });
            },
            Space(event2) {
              if (isTypingAhead) {
                send({ type: "CONTENT.TYPEAHEAD", key: event2.key });
              } else {
                keyMap.Enter?.(event2);
              }
            }
          };
          const exec = keyMap[getEventKey(event)];
          if (exec) {
            exec(event);
            event.preventDefault();
            return;
          }
          const target = getEventTarget(event);
          if (isEditableElement(target)) {
            return;
          }
          if (getByTypeahead.isValidEvent(event)) {
            send({ type: "CONTENT.TYPEAHEAD", key: event.key });
            event.preventDefault();
          }
        }
      });
    },
    getListProps() {
      return normalize.element({
        ...parts.list.attrs,
        tabIndex: 0,
        role: !composite ? "listbox" : void 0,
        "aria-labelledby": getTriggerId(scope),
        "aria-activedescendant": !composite ? ariaActiveDescendant : void 0,
        "aria-multiselectable": !composite && prop("multiple") ? true : void 0
      });
    }
  };
}
var getSelectedValues = (el) => {
  return el.multiple ? Array.from(el.selectedOptions, (o) => o.value) : el.value ? [el.value] : [];
};
var { and, not, or } = createGuards();
var machine = createMachine({
  props({ props: props2 }) {
    return {
      loopFocus: false,
      closeOnSelect: !props2.multiple,
      composite: true,
      defaultValue: [],
      ...props2,
      collection: props2.collection ?? collection.empty(),
      positioning: {
        placement: "bottom-start",
        gutter: 8,
        ...props2.positioning
      }
    };
  },
  context({ prop, bindable }) {
    return {
      value: bindable(() => ({
        defaultValue: prop("defaultValue"),
        value: prop("value"),
        isEqual,
        onChange(value) {
          const items = prop("collection").findMany(value);
          return prop("onValueChange")?.({ value, items });
        }
      })),
      highlightedValue: bindable(() => ({
        defaultValue: prop("defaultHighlightedValue") || null,
        value: prop("highlightedValue"),
        onChange(value) {
          prop("onHighlightChange")?.({
            highlightedValue: value,
            highlightedItem: prop("collection").find(value),
            highlightedIndex: prop("collection").indexOf(value)
          });
        }
      })),
      currentPlacement: bindable(() => ({
        defaultValue: void 0
      })),
      fieldsetDisabled: bindable(() => ({
        defaultValue: false
      })),
      highlightedItem: bindable(() => ({
        defaultValue: null
      })),
      selectedItems: bindable(() => {
        const value = prop("value") ?? prop("defaultValue") ?? [];
        const items = prop("collection").findMany(value);
        return { defaultValue: items };
      })
    };
  },
  refs() {
    return {
      typeahead: { ...getByTypeahead.defaultOptions }
    };
  },
  computed: {
    hasSelectedItems: ({ context }) => context.get("value").length > 0,
    isTypingAhead: ({ refs }) => refs.get("typeahead").keysSoFar !== "",
    isDisabled: ({ prop, context }) => !!prop("disabled") || !!context.get("fieldsetDisabled"),
    isInteractive: ({ prop }) => !(prop("disabled") || prop("readOnly")),
    valueAsString: ({ context, prop }) => prop("collection").stringifyItems(context.get("selectedItems"))
  },
  initialState({ prop }) {
    const open = prop("open") || prop("defaultOpen");
    return open ? "open" : "idle";
  },
  entry: ["syncSelectElement"],
  watch({ context, prop, track, action }) {
    track([() => context.get("value").toString()], () => {
      action(["syncSelectedItems", "syncSelectElement", "dispatchChangeEvent"]);
    });
    track([() => prop("open")], () => {
      action(["toggleVisibility"]);
    });
    track([() => context.get("highlightedValue")], () => {
      action(["syncHighlightedItem"]);
    });
    track([() => prop("collection").toString()], () => {
      action(["syncCollection"]);
    });
  },
  on: {
    "HIGHLIGHTED_VALUE.SET": {
      actions: ["setHighlightedItem"]
    },
    "HIGHLIGHTED_VALUE.CLEAR": {
      actions: ["clearHighlightedItem"]
    },
    "ITEM.SELECT": {
      actions: ["selectItem"]
    },
    "ITEM.CLEAR": {
      actions: ["clearItem"]
    },
    "VALUE.SET": {
      actions: ["setSelectedItems"]
    },
    "VALUE.CLEAR": {
      actions: ["clearSelectedItems"]
    },
    "CLEAR.CLICK": {
      actions: ["clearSelectedItems", "focusTriggerEl"]
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
            actions: ["setInitialFocus", "highlightComputedLastItem"]
          },
          {
            guard: or("isTriggerArrowDownEvent", "isTriggerEnterEvent"),
            target: "open",
            actions: ["setInitialFocus", "highlightComputedFirstItem"]
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
            actions: ["setInitialFocus", "invokeOnOpen", "highlightComputedFirstItem"]
          }
        ],
        "TRIGGER.ARROW_UP": [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["setInitialFocus", "invokeOnOpen", "highlightComputedLastItem"]
          }
        ],
        "TRIGGER.ARROW_DOWN": [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["setInitialFocus", "invokeOnOpen", "highlightComputedFirstItem"]
          }
        ],
        "TRIGGER.ARROW_LEFT": [
          {
            guard: and(not("multiple"), "hasSelectedItems"),
            actions: ["selectPreviousItem"]
          },
          {
            guard: not("multiple"),
            actions: ["selectLastItem"]
          }
        ],
        "TRIGGER.ARROW_RIGHT": [
          {
            guard: and(not("multiple"), "hasSelectedItems"),
            actions: ["selectNextItem"]
          },
          {
            guard: not("multiple"),
            actions: ["selectFirstItem"]
          }
        ],
        "TRIGGER.HOME": {
          guard: not("multiple"),
          actions: ["selectFirstItem"]
        },
        "TRIGGER.END": {
          guard: not("multiple"),
          actions: ["selectLastItem"]
        },
        "TRIGGER.TYPEAHEAD": {
          guard: not("multiple"),
          actions: ["selectMatchingItem"]
        }
      }
    },
    open: {
      tags: ["open"],
      exit: ["scrollContentToTop"],
      effects: ["trackDismissableElement", "trackFocusVisible", "computePlacement", "scrollToHighlightedItem"],
      on: {
        "CONTROLLED.CLOSE": [
          {
            guard: "restoreFocus",
            target: "focused",
            actions: ["focusTriggerEl", "clearHighlightedItem"]
          },
          {
            target: "idle",
            actions: ["clearHighlightedItem"]
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
            actions: ["invokeOnClose", "focusTriggerEl", "clearHighlightedItem"]
          },
          {
            target: "idle",
            actions: ["invokeOnClose", "clearHighlightedItem"]
          }
        ],
        "TRIGGER.CLICK": [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnClose"]
          },
          {
            target: "focused",
            actions: ["invokeOnClose", "clearHighlightedItem"]
          }
        ],
        "ITEM.CLICK": [
          {
            guard: and("closeOnSelect", "isOpenControlled"),
            actions: ["selectHighlightedItem", "invokeOnClose"]
          },
          {
            guard: "closeOnSelect",
            target: "focused",
            actions: ["selectHighlightedItem", "invokeOnClose", "focusTriggerEl", "clearHighlightedItem"]
          },
          {
            actions: ["selectHighlightedItem"]
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
            guard: and("hasHighlightedItem", "loop", "isLastItemHighlighted"),
            actions: ["highlightFirstItem"]
          },
          {
            guard: "hasHighlightedItem",
            actions: ["highlightNextItem"]
          },
          {
            actions: ["highlightFirstItem"]
          }
        ],
        "CONTENT.ARROW_UP": [
          {
            guard: and("hasHighlightedItem", "loop", "isFirstItemHighlighted"),
            actions: ["highlightLastItem"]
          },
          {
            guard: "hasHighlightedItem",
            actions: ["highlightPreviousItem"]
          },
          {
            actions: ["highlightLastItem"]
          }
        ],
        "CONTENT.TYPEAHEAD": {
          actions: ["highlightMatchingItem"]
        },
        "ITEM.POINTER_MOVE": {
          actions: ["highlightItem"]
        },
        "ITEM.POINTER_LEAVE": {
          actions: ["clearHighlightedItem"]
        },
        "POSITIONING.SET": {
          actions: ["reposition"]
        }
      }
    }
  },
  implementations: {
    guards: {
      loop: ({ prop }) => !!prop("loopFocus"),
      multiple: ({ prop }) => !!prop("multiple"),
      hasSelectedItems: ({ computed }) => !!computed("hasSelectedItems"),
      hasHighlightedItem: ({ context }) => context.get("highlightedValue") != null,
      isFirstItemHighlighted: ({ context, prop }) => context.get("highlightedValue") === prop("collection").firstValue,
      isLastItemHighlighted: ({ context, prop }) => context.get("highlightedValue") === prop("collection").lastValue,
      closeOnSelect: ({ prop, event }) => !!(event.closeOnSelect ?? prop("closeOnSelect")),
      restoreFocus: ({ event }) => restoreFocusFn(event),
      // guard assertions (for controlled mode)
      isOpenControlled: ({ prop }) => prop("open") !== void 0,
      isTriggerClickEvent: ({ event }) => event.previousEvent?.type === "TRIGGER.CLICK",
      isTriggerEnterEvent: ({ event }) => event.previousEvent?.type === "TRIGGER.ENTER",
      isTriggerArrowUpEvent: ({ event }) => event.previousEvent?.type === "TRIGGER.ARROW_UP",
      isTriggerArrowDownEvent: ({ event }) => event.previousEvent?.type === "TRIGGER.ARROW_DOWN"
    },
    effects: {
      trackFocusVisible({ scope }) {
        return trackFocusVisible({ root: scope.getRootNode?.() });
      },
      trackFormControlState({ context, scope }) {
        return trackFormControl(getHiddenSelectEl(scope), {
          onFieldsetDisabledChange(disabled) {
            context.set("fieldsetDisabled", disabled);
          },
          onFormReset() {
            const value = context.initial("value");
            context.set("value", value);
          }
        });
      },
      trackDismissableElement({ scope, send, prop }) {
        const contentEl = () => getContentEl(scope);
        let restoreFocus = true;
        return trackDismissableElement(contentEl, {
          type: "listbox",
          defer: true,
          exclude: [getTriggerEl(scope), getClearTriggerEl(scope)],
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
        const positioning = prop("positioning");
        context.set("currentPlacement", positioning.placement);
        const triggerEl = () => getTriggerEl(scope);
        const positionerEl = () => getPositionerEl(scope);
        return getPlacement(triggerEl, positionerEl, {
          defer: true,
          ...positioning,
          onComplete(data) {
            context.set("currentPlacement", data.placement);
          }
        });
      },
      scrollToHighlightedItem({ context, prop, scope }) {
        const exec = (immediate) => {
          const highlightedValue = context.get("highlightedValue");
          if (highlightedValue == null) return;
          const modality = getInteractionModality();
          if (modality === "pointer") return;
          const contentEl2 = getContentEl(scope);
          const scrollToIndexFn = prop("scrollToIndexFn");
          if (scrollToIndexFn) {
            const highlightedIndex = prop("collection").indexOf(highlightedValue);
            scrollToIndexFn?.({
              index: highlightedIndex,
              immediate,
              getElement: () => getItemEl(scope, highlightedValue)
            });
            return;
          }
          const itemEl = getItemEl(scope, highlightedValue);
          scrollIntoView(itemEl, { rootEl: contentEl2, block: "nearest" });
        };
        raf(() => {
          setInteractionModality("virtual");
          exec(true);
        });
        const contentEl = () => getContentEl(scope);
        return observeAttributes(contentEl, {
          defer: true,
          attributes: ["data-activedescendant"],
          callback() {
            exec(false);
          }
        });
      }
    },
    actions: {
      reposition({ context, prop, scope, event }) {
        const positionerEl = () => getPositionerEl(scope);
        getPlacement(getTriggerEl(scope), positionerEl, {
          ...prop("positioning"),
          ...event.options,
          defer: true,
          listeners: false,
          onComplete(data) {
            context.set("currentPlacement", data.placement);
          }
        });
      },
      toggleVisibility({ send, prop, event }) {
        send({ type: prop("open") ? "CONTROLLED.OPEN" : "CONTROLLED.CLOSE", previousEvent: event });
      },
      highlightPreviousItem({ context, prop }) {
        const highlightedValue = context.get("highlightedValue");
        if (highlightedValue == null) return;
        const value = prop("collection").getPreviousValue(highlightedValue, 1, prop("loopFocus"));
        if (value == null) return;
        context.set("highlightedValue", value);
      },
      highlightNextItem({ context, prop }) {
        const highlightedValue = context.get("highlightedValue");
        if (highlightedValue == null) return;
        const value = prop("collection").getNextValue(highlightedValue, 1, prop("loopFocus"));
        if (value == null) return;
        context.set("highlightedValue", value);
      },
      highlightFirstItem({ context, prop }) {
        const value = prop("collection").firstValue;
        context.set("highlightedValue", value);
      },
      highlightLastItem({ context, prop }) {
        const value = prop("collection").lastValue;
        context.set("highlightedValue", value);
      },
      setInitialFocus({ scope }) {
        raf(() => {
          const element = getInitialFocus({
            root: getContentEl(scope)
          });
          element?.focus({ preventScroll: true });
        });
      },
      focusTriggerEl({ event, scope }) {
        if (!restoreFocusFn(event)) return;
        raf(() => {
          const element = getTriggerEl(scope);
          element?.focus({ preventScroll: true });
        });
      },
      selectHighlightedItem({ context, prop, event }) {
        let value = event.value ?? context.get("highlightedValue");
        if (value == null || !prop("collection").has(value)) return;
        prop("onSelect")?.({ value });
        const nullable = prop("deselectable") && !prop("multiple") && context.get("value").includes(value);
        value = nullable ? null : value;
        context.set("value", (prev) => {
          if (value == null) return [];
          if (prop("multiple")) return addOrRemove(prev, value);
          return [value];
        });
      },
      highlightComputedFirstItem({ context, prop, computed }) {
        const collection2 = prop("collection");
        const value = computed("hasSelectedItems") ? collection2.sort(context.get("value"))[0] : collection2.firstValue;
        context.set("highlightedValue", value);
      },
      highlightComputedLastItem({ context, prop, computed }) {
        const collection2 = prop("collection");
        const value = computed("hasSelectedItems") ? collection2.sort(context.get("value"))[0] : collection2.lastValue;
        context.set("highlightedValue", value);
      },
      highlightFirstSelectedItem({ context, prop, computed }) {
        if (!computed("hasSelectedItems")) return;
        const value = prop("collection").sort(context.get("value"))[0];
        context.set("highlightedValue", value);
      },
      highlightItem({ context, event }) {
        context.set("highlightedValue", event.value);
      },
      highlightMatchingItem({ context, prop, event, refs }) {
        const value = prop("collection").search(event.key, {
          state: refs.get("typeahead"),
          currentValue: context.get("highlightedValue")
        });
        if (value == null) return;
        context.set("highlightedValue", value);
      },
      setHighlightedItem({ context, event }) {
        context.set("highlightedValue", event.value);
      },
      clearHighlightedItem({ context }) {
        context.set("highlightedValue", null);
      },
      selectItem({ context, prop, event }) {
        prop("onSelect")?.({ value: event.value });
        const nullable = prop("deselectable") && !prop("multiple") && context.get("value").includes(event.value);
        const value = nullable ? null : event.value;
        context.set("value", (prev) => {
          if (value == null) return [];
          if (prop("multiple")) return addOrRemove(prev, value);
          return [value];
        });
      },
      clearItem({ context, event }) {
        context.set("value", (prev) => prev.filter((v) => v !== event.value));
      },
      setSelectedItems({ context, event }) {
        context.set("value", event.value);
      },
      clearSelectedItems({ context }) {
        context.set("value", []);
      },
      selectPreviousItem({ context, prop }) {
        const [firstItem] = context.get("value");
        const value = prop("collection").getPreviousValue(firstItem);
        if (value) context.set("value", [value]);
      },
      selectNextItem({ context, prop }) {
        const [firstItem] = context.get("value");
        const value = prop("collection").getNextValue(firstItem);
        if (value) context.set("value", [value]);
      },
      selectFirstItem({ context, prop }) {
        const value = prop("collection").firstValue;
        if (value) context.set("value", [value]);
      },
      selectLastItem({ context, prop }) {
        const value = prop("collection").lastValue;
        if (value) context.set("value", [value]);
      },
      selectMatchingItem({ context, prop, event, refs }) {
        const value = prop("collection").search(event.key, {
          state: refs.get("typeahead"),
          currentValue: context.get("value")[0]
        });
        if (value == null) return;
        context.set("value", [value]);
      },
      scrollContentToTop({ prop, scope }) {
        if (prop("scrollToIndexFn")) {
          const firstValue = prop("collection").firstValue;
          prop("scrollToIndexFn")?.({
            index: 0,
            immediate: true,
            getElement: () => getItemEl(scope, firstValue)
          });
        } else {
          getContentEl(scope)?.scrollTo(0, 0);
        }
      },
      invokeOnOpen({ prop, context }) {
        prop("onOpenChange")?.({ open: true, value: context.get("value") });
      },
      invokeOnClose({ prop, context }) {
        prop("onOpenChange")?.({ open: false, value: context.get("value") });
      },
      syncSelectElement({ context, prop, scope }) {
        const selectEl = getHiddenSelectEl(scope);
        if (!selectEl) return;
        if (context.get("value").length === 0 && !prop("multiple")) {
          selectEl.selectedIndex = -1;
          return;
        }
        for (const option of selectEl.options) {
          option.selected = context.get("value").includes(option.value);
        }
      },
      syncCollection({ context, prop }) {
        const collection2 = prop("collection");
        const highlightedItem = collection2.find(context.get("highlightedValue"));
        if (highlightedItem) context.set("highlightedItem", highlightedItem);
        const selectedItems = collection2.findMany(context.get("value"));
        context.set("selectedItems", selectedItems);
      },
      syncSelectedItems({ context, prop }) {
        const collection2 = prop("collection");
        const prevSelectedItems = context.get("selectedItems");
        const value = context.get("value");
        const selectedItems = value.map((value2) => {
          const item = prevSelectedItems.find((item2) => collection2.getItemValue(item2) === value2);
          return item || collection2.find(value2);
        });
        context.set("selectedItems", selectedItems);
      },
      syncHighlightedItem({ context, prop }) {
        const collection2 = prop("collection");
        const highlightedValue = context.get("highlightedValue");
        const highlightedItem = highlightedValue ? collection2.find(highlightedValue) : null;
        context.set("highlightedItem", highlightedItem);
      },
      dispatchChangeEvent({ scope }) {
        queueMicrotask(() => {
          const node = getHiddenSelectEl(scope);
          if (!node) return;
          const win = scope.getWin();
          const evt = new win.Event("change", { bubbles: true, composed: true });
          node.dispatchEvent(markAsInternalChangeEvent(evt));
        });
      }
    }
  }
});
function restoreFocusFn(event) {
  const v = event.restoreFocus ?? event.previousEvent?.restoreFocus;
  return v == null || !!v;
}
var props = createProps()([
  "autoComplete",
  "closeOnSelect",
  "collection",
  "composite",
  "defaultHighlightedValue",
  "defaultOpen",
  "defaultValue",
  "deselectable",
  "dir",
  "disabled",
  "form",
  "getRootNode",
  "highlightedValue",
  "id",
  "ids",
  "invalid",
  "loopFocus",
  "multiple",
  "name",
  "onFocusOutside",
  "onHighlightChange",
  "onInteractOutside",
  "onOpenChange",
  "onPointerDownOutside",
  "onSelect",
  "onValueChange",
  "open",
  "positioning",
  "readOnly",
  "required",
  "scrollToIndexFn",
  "value"
]);
var splitProps = createSplitProps(props);
var itemProps = createProps()(["item", "persistFocus"]);
var splitItemProps = createSplitProps(itemProps);
var itemGroupProps = createProps()(["id"]);
var splitItemGroupProps = createSplitProps(itemGroupProps);
var itemGroupLabelProps = createProps()(["htmlFor"]);
var splitItemGroupLabelProps = createSplitProps(itemGroupLabelProps);

// components/select.ts
var Select = class extends Component {
  _options = [];
  hasGroups = false;
  placeholder = "";
  constructor(el, props2) {
    super(el, props2);
    const collectionFromProps = props2.collection;
    this._options = collectionFromProps?.items ?? [];
    this.placeholder = getString(this.el, "placeholder") || "";
  }
  get options() {
    return Array.isArray(this._options) ? this._options : [];
  }
  setOptions(options) {
    this._options = Array.isArray(options) ? options : [];
  }
  getCollection() {
    const items = this.options;
    if (this.hasGroups) {
      return collection({
        items,
        itemToValue: (item) => item.id ?? item.value ?? "",
        itemToString: (item) => item.label,
        isItemDisabled: (item) => !!item.disabled,
        groupBy: (item) => item.group ?? ""
      });
    }
    return collection({
      items,
      itemToValue: (item) => item.id ?? item.value ?? "",
      itemToString: (item) => item.label,
      isItemDisabled: (item) => !!item.disabled
    });
  }
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props2) {
    const getCollection = this.getCollection.bind(this);
    const collectionFromProps = props2.collection;
    return new VanillaMachine(machine, {
      ...props2,
      get collection() {
        return collectionFromProps ?? getCollection();
      }
    });
  }
  initApi() {
    return connect(this.machine.service, normalizeProps);
  }
  init = () => {
    this.machine.start();
    this.render();
    this.machine.subscribe(() => {
      this.api = this.initApi();
      this.render();
    });
  };
  applyItemProps() {
    const contentEl = this.el.querySelector(
      '[data-scope="select"][data-part="content"]'
    );
    if (!contentEl) return;
    contentEl.querySelectorAll('[data-scope="select"][data-part="item-group"]').forEach((groupEl) => {
      const groupId = groupEl.dataset.id ?? "";
      this.spreadProps(groupEl, this.api.getItemGroupProps({ id: groupId }));
      const labelEl = groupEl.querySelector(
        '[data-scope="select"][data-part="item-group-label"]'
      );
      if (labelEl) {
        this.spreadProps(labelEl, this.api.getItemGroupLabelProps({ htmlFor: groupId }));
      }
    });
    contentEl.querySelectorAll('[data-scope="select"][data-part="item"]').forEach((itemEl) => {
      const value = itemEl.dataset.value ?? "";
      const item = this.options.find((i) => String(i.id ?? i.value ?? "") === String(value));
      if (!item) return;
      this.spreadProps(itemEl, this.api.getItemProps({ item }));
      const textEl = itemEl.querySelector(
        '[data-scope="select"][data-part="item-text"]'
      );
      if (textEl) {
        this.spreadProps(textEl, this.api.getItemTextProps({ item }));
      }
      const indicatorEl = itemEl.querySelector(
        '[data-scope="select"][data-part="item-indicator"]'
      );
      if (indicatorEl) {
        this.spreadProps(indicatorEl, this.api.getItemIndicatorProps({ item }));
      }
    });
  }
  render() {
    const root = this.el.querySelector('[data-scope="select"][data-part="root"]') ?? this.el;
    this.spreadProps(root, this.api.getRootProps());
    const hiddenSelect = this.el.querySelector(
      '[data-scope="select"][data-part="hidden-select"]'
    );
    const valueInput = this.el.querySelector(
      '[data-scope="select"][data-part="value-input"]'
    );
    if (valueInput) {
      if (!this.api.value || this.api.value.length === 0) {
        valueInput.value = "";
      } else if (this.api.value.length === 1) {
        valueInput.value = String(this.api.value[0]);
      } else {
        valueInput.value = this.api.value.map(String).join(",");
      }
    }
    if (hiddenSelect) {
      this.spreadProps(hiddenSelect, this.api.getHiddenSelectProps());
    }
    ["label", "control", "trigger", "indicator", "clear-trigger", "positioner"].forEach((part) => {
      const el = this.el.querySelector(`[data-scope="select"][data-part="${part}"]`);
      if (!el) return;
      const method = "get" + part.split("-").map((s) => s[0].toUpperCase() + s.slice(1)).join("") + "Props";
      this.spreadProps(el, this.api[method]());
    });
    const valueText = this.el.querySelector(
      '[data-scope="select"][data-part="item-text"]'
    );
    if (valueText) {
      const valueAsString = this.api.valueAsString;
      if (this.api.value && this.api.value.length > 0 && !valueAsString) {
        const selectedValue = this.api.value[0];
        const selectedItem = this.options.find((item) => {
          const itemValue = item.id ?? item.value ?? "";
          return String(itemValue) === String(selectedValue);
        });
        if (selectedItem) {
          valueText.textContent = selectedItem.label;
        } else {
          valueText.textContent = this.placeholder || "";
        }
      } else {
        valueText.textContent = valueAsString || this.placeholder || "";
      }
    }
    const contentEl = this.el.querySelector(
      '[data-scope="select"][data-part="content"]'
    );
    if (contentEl) {
      this.spreadProps(contentEl, this.api.getContentProps());
      this.applyItemProps();
    }
  }
};

// hooks/select.ts
function buildCollection(items, hasGroups) {
  if (hasGroups) {
    return collection({
      items,
      itemToValue: (item) => item.id ?? item.value ?? "",
      itemToString: (item) => item.label,
      isItemDisabled: (item) => !!item.disabled,
      groupBy: (item) => item.group ?? ""
    });
  }
  return collection({
    items,
    itemToValue: (item) => item.id ?? item.value ?? "",
    itemToString: (item) => item.label,
    isItemDisabled: (item) => !!item.disabled
  });
}
function snakeToCamel(str) {
  return str.replace(/_([a-z])/g, (_, letter) => letter.toUpperCase());
}
function transformPositioningOptions(obj) {
  const result = {};
  for (const [key, value] of Object.entries(obj)) {
    const camelKey = snakeToCamel(key);
    result[camelKey] = value;
  }
  return result;
}
var SelectHook = {
  mounted() {
    const el = this.el;
    const allItems = JSON.parse(el.dataset.collection || "[]");
    const hasGroups = allItems.some((item) => item.group !== void 0);
    const initialCollection = buildCollection(allItems, hasGroups);
    const selectComponent = new Select(el, {
      id: el.id,
      collection: initialCollection,
      ...getBoolean(el, "controlled") ? { value: getStringList(el, "value") } : { defaultValue: getStringList(el, "defaultValue") },
      disabled: getBoolean(el, "disabled"),
      closeOnSelect: getBoolean(el, "closeOnSelect"),
      dir: getString(el, "dir", ["ltr", "rtl"]),
      loopFocus: getBoolean(el, "loopFocus"),
      multiple: getBoolean(el, "multiple"),
      invalid: getBoolean(el, "invalid"),
      name: getString(el, "name"),
      form: getString(el, "form"),
      readOnly: getBoolean(el, "readOnly"),
      required: getBoolean(el, "required"),
      positioning: (() => {
        const positioningJson = el.dataset.positioning;
        if (positioningJson) {
          try {
            const parsed = JSON.parse(positioningJson);
            return transformPositioningOptions(parsed);
          } catch {
            return void 0;
          }
        }
        return void 0;
      })(),
      onValueChange: (details) => {
        const redirect = getBoolean(el, "redirect");
        const firstValue = details.value.length > 0 ? String(details.value[0]) : null;
        const firstItem = details.items?.length ? details.items[0] : null;
        const itemRedirect = firstItem && typeof firstItem === "object" && firstItem !== null && "redirect" in firstItem ? firstItem.redirect : void 0;
        const itemNewTab = firstItem && typeof firstItem === "object" && firstItem !== null && "new_tab" in firstItem ? firstItem.new_tab : void 0;
        const doRedirect = redirect && firstValue && this.liveSocket.main.isDead && itemRedirect !== false;
        const openInNewTab = itemNewTab === true;
        if (doRedirect) {
          if (openInNewTab) {
            window.open(firstValue, "_blank", "noopener,noreferrer");
          } else {
            window.location.href = firstValue;
          }
        }
        const valueInput = el.querySelector(
          '[data-scope="select"][data-part="value-input"]'
        );
        if (valueInput) {
          valueInput.value = details.value.length === 0 ? "" : details.value.length === 1 ? String(details.value[0]) : details.value.map(String).join(",");
          valueInput.dispatchEvent(new Event("input", { bubbles: true }));
          valueInput.dispatchEvent(new Event("change", { bubbles: true }));
        }
        const payload = {
          value: details.value,
          items: details.items,
          id: el.id
        };
        const clientEventName = getString(el, "onValueChangeClient");
        if (clientEventName) {
          el.dispatchEvent(new CustomEvent(clientEventName, { bubbles: true, detail: payload }));
        }
        const serverEventName = getString(el, "onValueChange");
        if (serverEventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(serverEventName, payload);
        }
      }
    });
    selectComponent.hasGroups = hasGroups;
    selectComponent.setOptions(allItems);
    selectComponent.init();
    this.select = selectComponent;
    this.handlers = [];
  },
  updated() {
    const newItems = JSON.parse(this.el.dataset.collection || "[]");
    const hasGroups = newItems.some((item) => item.group !== void 0);
    if (this.select) {
      this.select.hasGroups = hasGroups;
      this.select.setOptions(newItems);
      this.select.updateProps({
        collection: buildCollection(newItems, hasGroups),
        id: this.el.id,
        ...getBoolean(this.el, "controlled") ? { value: getStringList(this.el, "value") } : { defaultValue: getStringList(this.el, "defaultValue") },
        name: getString(this.el, "name"),
        form: getString(this.el, "form"),
        disabled: getBoolean(this.el, "disabled"),
        multiple: getBoolean(this.el, "multiple"),
        dir: getString(this.el, "dir", ["ltr", "rtl"]),
        invalid: getBoolean(this.el, "invalid"),
        required: getBoolean(this.el, "required"),
        readOnly: getBoolean(this.el, "readOnly")
      });
    }
  },
  destroyed() {
    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }
    this.select?.destroy();
  }
};
export {
  SelectHook as Select
};
