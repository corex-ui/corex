import {
  GridCollection,
  ListCollection,
  Selection,
  createSelectedItemMap,
  deriveSelectionState,
  isGridCollection,
  resolveSelectedItems
} from "./chunk-WAY74VD3.mjs";
import {
  getInteractionModality,
  setInteractionModality,
  trackFocusVisible
} from "./chunk-KF3PY6Q6.mjs";
import {
  Component,
  VanillaMachine,
  ariaAttr,
  contains,
  createAnatomy,
  dataAttr,
  ensure,
  getBoolean,
  getByTypeahead,
  getEventKey,
  getEventTarget,
  getNativeEvent,
  getString,
  getStringList,
  isComposingEvent,
  isContextMenuEvent,
  isCtrlOrMetaKey,
  isDownloadingEvent,
  isEditableElement,
  isEqual,
  isOpeningInNewTab,
  normalizeProps,
  observeAttributes,
  raf,
  scrollIntoView,
  setup
} from "./chunk-ZOODJA3P.mjs";

// ../node_modules/.pnpm/@zag-js+listbox@1.36.0/node_modules/@zag-js/listbox/dist/listbox.anatomy.mjs
var anatomy = createAnatomy("listbox").parts(
  "label",
  "input",
  "item",
  "itemText",
  "itemIndicator",
  "itemGroup",
  "itemGroupLabel",
  "content",
  "root",
  "valueText"
);
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+listbox@1.36.0/node_modules/@zag-js/listbox/dist/listbox.collection.mjs
var collection = (options) => {
  return new ListCollection(options);
};
collection.empty = () => {
  return new ListCollection({ items: [] });
};
var gridCollection = (options) => {
  return new GridCollection(options);
};
gridCollection.empty = () => {
  return new GridCollection({ items: [], columnCount: 0 });
};

// ../node_modules/.pnpm/@zag-js+listbox@1.36.0/node_modules/@zag-js/listbox/dist/listbox.dom.mjs
var getRootId = (ctx) => ctx.ids?.root ?? `listbox:${ctx.id}`;
var getContentId = (ctx) => ctx.ids?.content ?? `listbox:${ctx.id}:content`;
var getLabelId = (ctx) => ctx.ids?.label ?? `listbox:${ctx.id}:label`;
var getItemId = (ctx, id) => ctx.ids?.item?.(id) ?? `listbox:${ctx.id}:item:${id}`;
var getItemGroupId = (ctx, id) => ctx.ids?.itemGroup?.(id) ?? `listbox:${ctx.id}:item-group:${id}`;
var getItemGroupLabelId = (ctx, id) => ctx.ids?.itemGroupLabel?.(id) ?? `listbox:${ctx.id}:item-group-label:${id}`;
var getContentEl = (ctx) => ctx.getById(getContentId(ctx));
var getItemEl = (ctx, id) => ctx.getById(getItemId(ctx, id));

// ../node_modules/.pnpm/@zag-js+listbox@1.36.0/node_modules/@zag-js/listbox/dist/listbox.connect.mjs
function connect(service, normalize) {
  const { context, prop, scope, computed, send, refs } = service;
  const disabled = prop("disabled");
  const collection2 = prop("collection");
  const layout = isGridCollection(collection2) ? "grid" : "list";
  const focused = context.get("focused");
  const focusVisible = refs.get("focusVisible") && focused;
  const inputState = refs.get("inputState");
  const value = context.get("value");
  const selectedItems = computed("selectedItems");
  const highlightedValue = context.get("highlightedValue");
  const highlightedItem = context.get("highlightedItem");
  const isTypingAhead = computed("isTypingAhead");
  const interactive = computed("isInteractive");
  const ariaActiveDescendant = highlightedValue ? getItemId(scope, highlightedValue) : void 0;
  function getItemState(props) {
    const itemDisabled = collection2.getItemDisabled(props.item);
    const value2 = collection2.getItemValue(props.item);
    ensure(value2, () => `[zag-js] No value found for item ${JSON.stringify(props.item)}`);
    const highlighted = highlightedValue === value2;
    return {
      value: value2,
      disabled: Boolean(disabled || itemDisabled),
      focused: highlighted && focused,
      focusVisible: highlighted && focusVisible,
      // deprecated
      highlighted: highlighted && (inputState.focused ? focused : focusVisible),
      selected: context.get("value").includes(value2)
    };
  }
  return {
    empty: value.length === 0,
    highlightedItem,
    highlightedValue,
    clearHighlightedValue() {
      send({ type: "HIGHLIGHTED_VALUE.SET", value: null });
    },
    selectedItems,
    hasSelectedItems: computed("hasSelectedItems"),
    value,
    valueAsString: computed("valueAsString"),
    collection: collection2,
    disabled: !!disabled,
    selectValue(value2) {
      send({ type: "ITEM.SELECT", value: value2 });
    },
    setValue(value2) {
      send({ type: "VALUE.SET", value: value2 });
    },
    selectAll() {
      if (!computed("multiple")) {
        throw new Error("[zag-js] Cannot select all items in a single-select listbox");
      }
      send({ type: "VALUE.SET", value: collection2.getValues() });
    },
    highlightValue(value2) {
      send({ type: "HIGHLIGHTED_VALUE.SET", value: value2 });
    },
    highlightFirst() {
      send({ type: "HIGHLIGHT.FIRST" });
    },
    highlightLast() {
      send({ type: "HIGHLIGHT.LAST" });
    },
    highlightNext() {
      send({ type: "HIGHLIGHT.NEXT" });
    },
    highlightPrevious() {
      send({ type: "HIGHLIGHT.PREV" });
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
        dir: prop("dir"),
        id: getRootId(scope),
        "data-orientation": prop("orientation"),
        "data-disabled": dataAttr(disabled)
      });
    },
    getInputProps(props = {}) {
      const keyboardPriority = props.keyboardPriority ?? "caret";
      return normalize.input({
        ...parts.input.attrs,
        dir: prop("dir"),
        disabled,
        "data-disabled": dataAttr(disabled),
        autoComplete: "off",
        autoCorrect: "off",
        "aria-haspopup": "listbox",
        "aria-controls": getContentId(scope),
        "aria-autocomplete": "list",
        "aria-activedescendant": ariaActiveDescendant,
        spellCheck: false,
        enterKeyHint: "go",
        onFocus() {
          queueMicrotask(() => {
            send({ type: "INPUT.FOCUS", autoHighlight: !!props?.autoHighlight });
          });
        },
        onBlur() {
          send({ type: "CONTENT.BLUR", src: "input" });
        },
        onInput(event) {
          if (!props?.autoHighlight) return;
          if (event.currentTarget.value.trim()) return;
          queueMicrotask(() => {
            send({ type: "HIGHLIGHTED_VALUE.SET", value: null });
          });
        },
        onKeyDown(event) {
          if (event.defaultPrevented) return;
          if (isComposingEvent(event)) return;
          const nativeEvent = getNativeEvent(event);
          const forwardEvent = () => {
            event.preventDefault();
            const win = scope.getWin();
            const keyboardEvent = new win.KeyboardEvent(nativeEvent.type, nativeEvent);
            getContentEl(scope)?.dispatchEvent(keyboardEvent);
          };
          switch (nativeEvent.key) {
            case "ArrowLeft":
            case "ArrowRight": {
              if (!isGridCollection(collection2)) return;
              if (event.ctrlKey) return;
              if (keyboardPriority !== "navigate") return;
              forwardEvent();
              break;
            }
            case "Home":
            case "End": {
              if (keyboardPriority !== "navigate") return;
              if (highlightedValue == null && event.shiftKey) return;
              forwardEvent();
              break;
            }
            case "ArrowDown":
            case "ArrowUp": {
              forwardEvent();
              break;
            }
            case "Enter":
              if (highlightedValue != null) {
                event.preventDefault();
                send({ type: "ITEM.CLICK", value: highlightedValue });
              }
              break;
            default:
              break;
          }
        }
      });
    },
    getLabelProps() {
      return normalize.element({
        dir: prop("dir"),
        id: getLabelId(scope),
        ...parts.label.attrs,
        "data-disabled": dataAttr(disabled)
      });
    },
    getValueTextProps() {
      return normalize.element({
        ...parts.valueText.attrs,
        dir: prop("dir"),
        "data-disabled": dataAttr(disabled)
      });
    },
    getItemProps(props) {
      const itemState = getItemState(props);
      return normalize.element({
        id: getItemId(scope, itemState.value),
        role: "option",
        ...parts.item.attrs,
        dir: prop("dir"),
        "data-value": itemState.value,
        "aria-selected": itemState.selected,
        "data-selected": dataAttr(itemState.selected),
        "data-layout": layout,
        "data-state": itemState.selected ? "checked" : "unchecked",
        "data-orientation": prop("orientation"),
        "data-highlighted": dataAttr(itemState.highlighted),
        "data-disabled": dataAttr(itemState.disabled),
        "aria-disabled": ariaAttr(itemState.disabled),
        onPointerMove(event) {
          if (!props.highlightOnHover) return;
          if (itemState.disabled || event.pointerType !== "mouse") return;
          if (itemState.highlighted) return;
          send({ type: "ITEM.POINTER_MOVE", value: itemState.value });
        },
        onMouseDown(event) {
          event.preventDefault();
          getContentEl(scope)?.focus();
        },
        onClick(event) {
          if (event.defaultPrevented) return;
          if (isDownloadingEvent(event)) return;
          if (isOpeningInNewTab(event)) return;
          if (isContextMenuEvent(event)) return;
          if (itemState.disabled) return;
          send({
            type: "ITEM.CLICK",
            value: itemState.value,
            shiftKey: event.shiftKey,
            anchorValue: highlightedValue,
            metaKey: isCtrlOrMetaKey(event)
          });
        }
      });
    },
    getItemTextProps(props) {
      const itemState = getItemState(props);
      return normalize.element({
        ...parts.itemText.attrs,
        "data-state": itemState.selected ? "checked" : "unchecked",
        "data-disabled": dataAttr(itemState.disabled),
        "data-highlighted": dataAttr(itemState.highlighted)
      });
    },
    getItemIndicatorProps(props) {
      const itemState = getItemState(props);
      return normalize.element({
        ...parts.itemIndicator.attrs,
        "aria-hidden": true,
        "data-state": itemState.selected ? "checked" : "unchecked",
        hidden: !itemState.selected
      });
    },
    getItemGroupLabelProps(props) {
      const { htmlFor } = props;
      return normalize.element({
        ...parts.itemGroupLabel.attrs,
        id: getItemGroupLabelId(scope, htmlFor),
        dir: prop("dir"),
        role: "presentation"
      });
    },
    getItemGroupProps(props) {
      const { id } = props;
      return normalize.element({
        ...parts.itemGroup.attrs,
        "data-disabled": dataAttr(disabled),
        "data-orientation": prop("orientation"),
        "data-empty": dataAttr(collection2.size === 0),
        id: getItemGroupId(scope, id),
        "aria-labelledby": getItemGroupLabelId(scope, id),
        role: "group",
        dir: prop("dir")
      });
    },
    getContentProps() {
      return normalize.element({
        dir: prop("dir"),
        id: getContentId(scope),
        role: "listbox",
        ...parts.content.attrs,
        "data-activedescendant": ariaActiveDescendant,
        "aria-activedescendant": ariaActiveDescendant,
        "data-orientation": prop("orientation"),
        "aria-multiselectable": computed("multiple") ? true : void 0,
        "aria-labelledby": getLabelId(scope),
        tabIndex: 0,
        "data-layout": layout,
        "data-empty": dataAttr(collection2.size === 0),
        style: {
          "--column-count": isGridCollection(collection2) ? collection2.columnCount : 1
        },
        onFocus() {
          send({ type: "CONTENT.FOCUS" });
        },
        onBlur() {
          send({ type: "CONTENT.BLUR" });
        },
        onKeyDown(event) {
          if (!interactive) return;
          const target = getEventTarget(event);
          if (!contains(event.currentTarget, getEventTarget(event))) return;
          const shiftKey = event.shiftKey;
          const keyMap = {
            ArrowUp(event2) {
              let nextValue = null;
              if (isGridCollection(collection2) && highlightedValue) {
                nextValue = collection2.getPreviousRowValue(highlightedValue);
              } else if (highlightedValue) {
                nextValue = collection2.getPreviousValue(highlightedValue);
              }
              if (!nextValue && (prop("loopFocus") || !highlightedValue)) {
                nextValue = collection2.lastValue;
              }
              if (!nextValue) return;
              event2.preventDefault();
              send({ type: "NAVIGATE", value: nextValue, shiftKey, anchorValue: highlightedValue });
            },
            ArrowDown(event2) {
              let nextValue = null;
              if (isGridCollection(collection2) && highlightedValue) {
                nextValue = collection2.getNextRowValue(highlightedValue);
              } else if (highlightedValue) {
                nextValue = collection2.getNextValue(highlightedValue);
              }
              if (!nextValue && (prop("loopFocus") || !highlightedValue)) {
                nextValue = collection2.firstValue;
              }
              if (!nextValue) return;
              event2.preventDefault();
              send({ type: "NAVIGATE", value: nextValue, shiftKey, anchorValue: highlightedValue });
            },
            ArrowLeft() {
              if (!isGridCollection(collection2) && prop("orientation") === "vertical") return;
              let nextValue = highlightedValue ? collection2.getPreviousValue(highlightedValue) : null;
              if (!nextValue && prop("loopFocus")) {
                nextValue = collection2.lastValue;
              }
              if (!nextValue) return;
              event.preventDefault();
              send({ type: "NAVIGATE", value: nextValue, shiftKey, anchorValue: highlightedValue });
            },
            ArrowRight() {
              if (!isGridCollection(collection2) && prop("orientation") === "vertical") return;
              let nextValue = highlightedValue ? collection2.getNextValue(highlightedValue) : null;
              if (!nextValue && prop("loopFocus")) {
                nextValue = collection2.firstValue;
              }
              if (!nextValue) return;
              event.preventDefault();
              send({ type: "NAVIGATE", value: nextValue, shiftKey, anchorValue: highlightedValue });
            },
            Home(event2) {
              if (isEditableElement(target)) return;
              event2.preventDefault();
              let nextValue = collection2.firstValue;
              send({ type: "NAVIGATE", value: nextValue, shiftKey, anchorValue: highlightedValue });
            },
            End(event2) {
              if (isEditableElement(target)) return;
              event2.preventDefault();
              let nextValue = collection2.lastValue;
              send({ type: "NAVIGATE", value: nextValue, shiftKey, anchorValue: highlightedValue });
            },
            Enter() {
              send({ type: "ITEM.CLICK", value: highlightedValue });
            },
            a(event2) {
              if (isCtrlOrMetaKey(event2) && computed("multiple") && !prop("disallowSelectAll")) {
                event2.preventDefault();
                send({ type: "VALUE.SET", value: collection2.getValues() });
              }
            },
            Space(event2) {
              if (isTypingAhead && prop("typeahead")) {
                send({ type: "CONTENT.TYPEAHEAD", key: event2.key });
              } else {
                keyMap.Enter?.(event2);
              }
            },
            Escape(event2) {
              if (prop("deselectable") && value.length > 0) {
                event2.preventDefault();
                event2.stopPropagation();
                send({ type: "VALUE.CLEAR" });
              }
            }
          };
          const exec = keyMap[getEventKey(event)];
          if (exec) {
            exec(event);
            return;
          }
          if (isEditableElement(target)) return;
          if (getByTypeahead.isValidEvent(event) && prop("typeahead")) {
            send({ type: "CONTENT.TYPEAHEAD", key: event.key });
            event.preventDefault();
          }
        }
      });
    }
  };
}

// ../node_modules/.pnpm/@zag-js+listbox@1.36.0/node_modules/@zag-js/listbox/dist/listbox.machine.mjs
var { guards, createMachine } = setup();
var { or } = guards;
var machine = createMachine({
  props({ props }) {
    return {
      loopFocus: false,
      composite: true,
      defaultValue: [],
      multiple: false,
      typeahead: true,
      collection: collection.empty(),
      orientation: "vertical",
      selectionMode: "single",
      ...props
    };
  },
  context({ prop, bindable, getContext }) {
    const initialValue = prop("value") ?? prop("defaultValue") ?? [];
    const initialSelectedItems = prop("collection").findMany(initialValue);
    return {
      value: bindable(() => ({
        defaultValue: prop("defaultValue"),
        value: prop("value"),
        isEqual,
        onChange(value) {
          const context = getContext();
          const collection2 = prop("collection");
          const selectedItemMap = context.get("selectedItemMap");
          const proposed = deriveSelectionState({
            values: value,
            collection: collection2,
            selectedItemMap
          });
          const effectiveValue = prop("value") ?? value;
          const effective = effectiveValue === value ? proposed : deriveSelectionState({
            values: effectiveValue,
            collection: collection2,
            selectedItemMap: proposed.nextSelectedItemMap
          });
          context.set("selectedItemMap", effective.nextSelectedItemMap);
          return prop("onValueChange")?.({ value, items: proposed.selectedItems });
        }
      })),
      highlightedValue: bindable(() => ({
        defaultValue: prop("defaultHighlightedValue") || null,
        value: prop("highlightedValue"),
        sync: true,
        onChange(value) {
          prop("onHighlightChange")?.({
            highlightedValue: value,
            highlightedItem: prop("collection").find(value),
            highlightedIndex: prop("collection").indexOf(value)
          });
        }
      })),
      highlightedItem: bindable(() => ({
        defaultValue: null
      })),
      selectedItemMap: bindable(() => {
        return {
          defaultValue: createSelectedItemMap({
            selectedItems: initialSelectedItems,
            collection: prop("collection")
          })
        };
      }),
      focused: bindable(() => ({
        sync: true,
        defaultValue: false
      }))
    };
  },
  refs() {
    return {
      typeahead: { ...getByTypeahead.defaultOptions },
      focusVisible: false,
      inputState: { autoHighlight: false, focused: false }
    };
  },
  computed: {
    hasSelectedItems: ({ context }) => context.get("value").length > 0,
    isTypingAhead: ({ refs }) => refs.get("typeahead").keysSoFar !== "",
    isInteractive: ({ prop }) => !prop("disabled"),
    selection: ({ context, prop }) => {
      const selection = new Selection(context.get("value"));
      selection.selectionMode = prop("selectionMode");
      selection.deselectable = !!prop("deselectable");
      return selection;
    },
    multiple: ({ prop }) => prop("selectionMode") === "multiple" || prop("selectionMode") === "extended",
    selectedItems: ({ context, prop }) => resolveSelectedItems({
      values: context.get("value"),
      collection: prop("collection"),
      selectedItemMap: context.get("selectedItemMap")
    }),
    valueAsString: ({ computed, prop }) => prop("collection").stringifyItems(computed("selectedItems"))
  },
  initialState() {
    return "idle";
  },
  watch({ context, prop, track, action }) {
    track([() => context.get("value").toString()], () => {
      action(["syncSelectedItems"]);
    });
    track([() => context.get("highlightedValue")], () => {
      action(["syncHighlightedItem"]);
    });
    track([() => prop("collection").toString()], () => {
      action(["syncHighlightedValue"]);
    });
  },
  effects: ["trackFocusVisible"],
  on: {
    "HIGHLIGHTED_VALUE.SET": {
      actions: ["setHighlightedItem"]
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
    "HIGHLIGHT.FIRST": {
      actions: ["highlightFirstValue"]
    },
    "HIGHLIGHT.LAST": {
      actions: ["highlightLastValue"]
    },
    "HIGHLIGHT.NEXT": {
      actions: ["highlightNextValue"]
    },
    "HIGHLIGHT.PREV": {
      actions: ["highlightPreviousValue"]
    }
  },
  states: {
    idle: {
      effects: ["scrollToHighlightedItem"],
      on: {
        "INPUT.FOCUS": {
          actions: ["setFocused", "setInputState"]
        },
        "CONTENT.FOCUS": [
          {
            guard: or("hasSelectedValue", "hasHighlightedValue"),
            actions: ["setFocused"]
          },
          {
            actions: ["setFocused", "setDefaultHighlightedValue"]
          }
        ],
        "CONTENT.BLUR": {
          actions: ["clearFocused", "clearInputState"]
        },
        "ITEM.CLICK": {
          actions: ["setHighlightedItem", "selectHighlightedItem"]
        },
        "CONTENT.TYPEAHEAD": {
          actions: ["setFocused", "highlightMatchingItem"]
        },
        "ITEM.POINTER_MOVE": {
          actions: ["highlightItem"]
        },
        "ITEM.POINTER_LEAVE": {
          actions: ["clearHighlightedItem"]
        },
        NAVIGATE: {
          actions: ["setFocused", "setHighlightedItem", "selectWithKeyboard"]
        }
      }
    }
  },
  implementations: {
    guards: {
      hasSelectedValue: ({ context }) => context.get("value").length > 0,
      hasHighlightedValue: ({ context }) => context.get("highlightedValue") != null
    },
    effects: {
      trackFocusVisible: ({ scope, refs }) => {
        return trackFocusVisible({
          root: scope.getRootNode?.(),
          onChange(details) {
            refs.set("focusVisible", details.isFocusVisible);
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
              getElement() {
                return getItemEl(scope, highlightedValue);
              }
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
      selectHighlightedItem({ context, prop, event, computed }) {
        const value = event.value ?? context.get("highlightedValue");
        const collection2 = prop("collection");
        if (value == null || !collection2.has(value)) return;
        const selection = computed("selection");
        if (event.shiftKey && computed("multiple") && event.anchorValue) {
          const next = selection.extendSelection(collection2, event.anchorValue, value);
          invokeOnSelect(selection, next, prop("onSelect"));
          context.set("value", Array.from(next));
        } else {
          const next = selection.select(collection2, value, event.metaKey);
          invokeOnSelect(selection, next, prop("onSelect"));
          context.set("value", Array.from(next));
        }
      },
      selectWithKeyboard({ context, prop, event, computed }) {
        const selection = computed("selection");
        const collection2 = prop("collection");
        if (event.shiftKey && computed("multiple") && event.anchorValue) {
          const next = selection.extendSelection(collection2, event.anchorValue, event.value);
          invokeOnSelect(selection, next, prop("onSelect"));
          context.set("value", Array.from(next));
          return;
        }
        if (prop("selectOnHighlight")) {
          const next = selection.replaceSelection(collection2, event.value);
          invokeOnSelect(selection, next, prop("onSelect"));
          context.set("value", Array.from(next));
        }
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
      highlightFirstValue({ context, prop }) {
        context.set("highlightedValue", prop("collection").firstValue ?? null);
      },
      highlightLastValue({ context, prop }) {
        context.set("highlightedValue", prop("collection").lastValue ?? null);
      },
      highlightNextValue({ context, prop }) {
        const collection2 = prop("collection");
        const highlightedValue = context.get("highlightedValue");
        let nextValue = null;
        if (isGridCollection(collection2) && highlightedValue) {
          nextValue = collection2.getNextRowValue(highlightedValue);
        } else if (highlightedValue) {
          nextValue = collection2.getNextValue(highlightedValue);
        }
        if (!nextValue && (prop("loopFocus") || !highlightedValue)) {
          nextValue = collection2.firstValue;
        }
        if (!nextValue) return;
        context.set("highlightedValue", nextValue);
      },
      highlightPreviousValue({ context, prop }) {
        const collection2 = prop("collection");
        const highlightedValue = context.get("highlightedValue");
        let nextValue = null;
        if (isGridCollection(collection2) && highlightedValue) {
          nextValue = collection2.getPreviousRowValue(highlightedValue);
        } else if (highlightedValue) {
          nextValue = collection2.getPreviousValue(highlightedValue);
        }
        if (!nextValue && (prop("loopFocus") || !highlightedValue)) {
          nextValue = collection2.lastValue;
        }
        if (!nextValue) return;
        context.set("highlightedValue", nextValue);
      },
      clearHighlightedItem({ context }) {
        context.set("highlightedValue", null);
      },
      selectItem({ context, prop, event, computed }) {
        const collection2 = prop("collection");
        const selection = computed("selection");
        const next = selection.select(collection2, event.value);
        invokeOnSelect(selection, next, prop("onSelect"));
        context.set("value", Array.from(next));
      },
      clearItem({ context, event, computed }) {
        const selection = computed("selection");
        const value = selection.deselect(event.value);
        context.set("value", Array.from(value));
      },
      setSelectedItems({ context, event }) {
        context.set("value", event.value);
      },
      clearSelectedItems({ context }) {
        context.set("value", []);
      },
      syncSelectedItems({ context, prop }) {
        const next = deriveSelectionState({
          values: context.get("value"),
          collection: prop("collection"),
          selectedItemMap: context.get("selectedItemMap")
        });
        context.set("selectedItemMap", next.nextSelectedItemMap);
      },
      syncHighlightedItem({ context, prop }) {
        const collection2 = prop("collection");
        const highlightedValue = context.get("highlightedValue");
        const highlightedItem = highlightedValue ? collection2.find(highlightedValue) : null;
        context.set("highlightedItem", highlightedItem);
      },
      syncHighlightedValue({ context, prop, refs }) {
        const collection2 = prop("collection");
        const highlightedValue = context.get("highlightedValue");
        const { autoHighlight } = refs.get("inputState");
        if (autoHighlight) {
          queueMicrotask(() => {
            context.set("highlightedValue", prop("collection").firstValue ?? null);
          });
          return;
        }
        if (highlightedValue != null && !collection2.has(highlightedValue)) {
          queueMicrotask(() => {
            context.set("highlightedValue", null);
          });
        }
      },
      setFocused({ context }) {
        context.set("focused", true);
      },
      setDefaultHighlightedValue({ context, prop }) {
        const collection2 = prop("collection");
        const firstValue = collection2.firstValue;
        if (firstValue != null) {
          context.set("highlightedValue", firstValue);
        }
      },
      clearFocused({ context }) {
        context.set("focused", false);
      },
      setInputState({ refs, event }) {
        refs.set("inputState", { autoHighlight: !!event.autoHighlight, focused: true });
      },
      clearInputState({ refs }) {
        refs.set("inputState", { autoHighlight: false, focused: false });
      }
    }
  }
});
var diff = (a, b) => {
  const result = new Set(a);
  for (const item of b) result.delete(item);
  return result;
};
function invokeOnSelect(current, next, onSelect) {
  const added = diff(next, current);
  for (const item of added) {
    onSelect?.({ value: item });
  }
}

// components/listbox.ts
var Listbox = class extends Component {
  _options = [];
  hasGroups = false;
  constructor(el, props) {
    super(el, props);
    const collectionFromProps = props.collection;
    this._options = collectionFromProps?.items ?? [];
  }
  get options() {
    return Array.isArray(this._options) ? this._options : [];
  }
  setOptions(options) {
    this._options = Array.isArray(options) ? options : [];
  }
  getOrderedGroupIds() {
    const seen = /* @__PURE__ */ new Set();
    const ids = [];
    for (const item of this.options) {
      const id = item.group ?? "default";
      if (!seen.has(id)) {
        seen.add(id);
        ids.push(id);
      }
    }
    return ids;
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
  initMachine(props) {
    const getCollection = this.getCollection.bind(this);
    return new VanillaMachine(machine, {
      ...props,
      get collection() {
        return getCollection();
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
  renderItems() {
    const contentEl = this.el.querySelector(
      '[data-scope="listbox"][data-part="content"]'
    );
    if (!contentEl) return;
    const templatesContainer = this.el.querySelector('[data-templates="listbox"]');
    if (!templatesContainer) return;
    contentEl.querySelectorAll(
      '[data-scope="listbox"][data-part="empty"]:not([data-template])'
    ).forEach((el) => el.remove());
    contentEl.querySelectorAll(
      '[data-scope="listbox"][data-part="item-group"]:not([data-template])'
    ).forEach((el) => el.remove());
    contentEl.querySelectorAll(
      '[data-scope="listbox"][data-part="item"]:not([data-template])'
    ).forEach((el) => el.remove());
    const items = this.options;
    if (items.length === 0) {
      const emptyTemplate = templatesContainer.querySelector(
        '[data-scope="listbox"][data-part="empty"][data-template]'
      );
      if (emptyTemplate) {
        const emptyEl = emptyTemplate.cloneNode(true);
        emptyEl.removeAttribute("data-template");
        contentEl.appendChild(emptyEl);
      }
    } else if (this.hasGroups) {
      const groupIds = this.getOrderedGroupIds();
      for (const groupId of groupIds) {
        const template = templatesContainer.querySelector(
          `[data-scope="listbox"][data-part="item-group"][data-id="${CSS.escape(groupId)}"][data-template]`
        );
        if (!template) continue;
        const groupEl = template.cloneNode(true);
        groupEl.removeAttribute("data-template");
        groupEl.querySelectorAll("[data-template]").forEach((e) => e.removeAttribute("data-template"));
        contentEl.appendChild(groupEl);
      }
    } else {
      for (const item of items) {
        const value = String(item.id ?? item.value ?? "");
        const template = templatesContainer.querySelector(
          `[data-scope="listbox"][data-part="item"][data-value="${value}"][data-template]`
        );
        if (!template) continue;
        const itemEl = template.cloneNode(true);
        itemEl.removeAttribute("data-template");
        contentEl.appendChild(itemEl);
      }
    }
  }
  applyItemProps() {
    const contentEl = this.el.querySelector(
      '[data-scope="listbox"][data-part="content"]'
    );
    if (!contentEl) return;
    contentEl.querySelectorAll('[data-scope="listbox"][data-part="item-group"]').forEach((groupEl) => {
      const groupId = groupEl.dataset.id ?? "";
      this.spreadProps(groupEl, this.api.getItemGroupProps({ id: groupId }));
      const labelEl = groupEl.querySelector(
        '[data-scope="listbox"][data-part="item-group-label"]'
      );
      if (labelEl) {
        this.spreadProps(labelEl, this.api.getItemGroupLabelProps({ htmlFor: groupId }));
      }
    });
    contentEl.querySelectorAll('[data-scope="listbox"][data-part="item"]').forEach((itemEl) => {
      const value = itemEl.dataset.value ?? "";
      const item = this.options.find((i) => String(i.id ?? i.value ?? "") === String(value));
      if (!item) return;
      this.spreadProps(itemEl, this.api.getItemProps({ item }));
      const textEl = itemEl.querySelector(
        '[data-scope="listbox"][data-part="item-text"]'
      );
      if (textEl) {
        this.spreadProps(textEl, this.api.getItemTextProps({ item }));
      }
      const indicatorEl = itemEl.querySelector(
        '[data-scope="listbox"][data-part="item-indicator"]'
      );
      if (indicatorEl) {
        this.spreadProps(indicatorEl, this.api.getItemIndicatorProps({ item }));
      }
    });
  }
  render() {
    const rootEl = this.el.querySelector('[data-scope="listbox"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());
    const labelEl = this.el.querySelector('[data-scope="listbox"][data-part="label"]');
    if (labelEl) this.spreadProps(labelEl, this.api.getLabelProps());
    const valueTextEl = this.el.querySelector(
      '[data-scope="listbox"][data-part="value-text"]'
    );
    if (valueTextEl) this.spreadProps(valueTextEl, this.api.getValueTextProps());
    const inputEl = this.el.querySelector('[data-scope="listbox"][data-part="input"]');
    if (inputEl) this.spreadProps(inputEl, this.api.getInputProps());
    const contentEl = this.el.querySelector(
      '[data-scope="listbox"][data-part="content"]'
    );
    if (contentEl) {
      this.spreadProps(contentEl, this.api.getContentProps());
      this.renderItems();
      this.applyItemProps();
    }
  }
};

// hooks/listbox.ts
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
var ListboxHook = {
  mounted() {
    const el = this.el;
    const allItems = JSON.parse(el.dataset.items ?? "[]");
    const hasGroups = allItems.some((item) => Boolean(item.group));
    const valueList = getStringList(el, "value");
    const defaultValueList = getStringList(el, "defaultValue");
    const controlled = getBoolean(el, "controlled");
    const zag = new Listbox(el, {
      id: el.id,
      collection: buildCollection(allItems, hasGroups),
      ...controlled && valueList ? { value: valueList } : { defaultValue: defaultValueList ?? [] },
      disabled: getBoolean(el, "disabled"),
      dir: getString(el, "dir", ["ltr", "rtl"]),
      orientation: getString(el, "orientation", [
        "horizontal",
        "vertical"
      ]),
      loopFocus: getBoolean(el, "loopFocus"),
      selectionMode: getString(el, "selectionMode", [
        "single",
        "multiple",
        "extended"
      ]),
      selectOnHighlight: getBoolean(el, "selectOnHighlight"),
      deselectable: getBoolean(el, "deselectable"),
      typeahead: getBoolean(el, "typeahead"),
      onValueChange: (details) => {
        const eventName = getString(el, "onValueChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, {
            value: details.value,
            items: details.items,
            id: el.id
          });
        }
        const clientName = getString(el, "onValueChangeClient");
        if (clientName) {
          el.dispatchEvent(
            new CustomEvent(clientName, {
              bubbles: true,
              detail: { value: details, id: el.id }
            })
          );
        }
      }
    });
    zag.hasGroups = hasGroups;
    zag.setOptions(allItems);
    zag.init();
    this.listbox = zag;
    this.handlers = [];
    this.handleContentClick = (e) => {
      const btn = e.target.closest?.(
        "[data-phx-push][data-phx-push-id]"
      );
      if (btn && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
        e.stopPropagation();
        e.preventDefault();
        this.pushEvent(btn.dataset.phxPush, { id: btn.dataset.phxPushId });
      }
    };
    el.addEventListener("click", this.handleContentClick, true);
  },
  updated() {
    const newItems = JSON.parse(this.el.dataset.items ?? "[]");
    const hasGroups = newItems.some((item) => Boolean(item.group));
    const valueList = getStringList(this.el, "value");
    const defaultValueList = getStringList(this.el, "defaultValue");
    const controlled = getBoolean(this.el, "controlled");
    if (this.listbox) {
      this.listbox.hasGroups = hasGroups;
      this.listbox.setOptions(newItems);
      this.listbox.render();
      this.listbox.updateProps({
        collection: this.listbox.getCollection(),
        id: this.el.id,
        ...controlled && valueList ? { value: valueList } : { defaultValue: defaultValueList ?? [] },
        disabled: getBoolean(this.el, "disabled"),
        dir: getString(this.el, "dir", ["ltr", "rtl"]),
        orientation: getString(this.el, "orientation", [
          "horizontal",
          "vertical"
        ])
      });
    }
  },
  destroyed() {
    if (this.handlers) {
      for (const h of this.handlers) this.removeHandleEvent(h);
    }
    if (this.handleContentClick) {
      this.el.removeEventListener("click", this.handleContentClick, true);
    }
    this.listbox?.destroy();
  }
};
export {
  ListboxHook as Listbox
};
