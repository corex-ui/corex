import {
  GridCollection,
  ListCollection,
  Selection,
  isGridCollection
} from "./chunk-4RWUEBEQ.mjs";
import {
  getInteractionModality,
  setInteractionModality,
  trackFocusVisible
} from "./chunk-GXGJDSCU.mjs";
import {
  Component,
  VanillaMachine,
  ariaAttr,
  contains,
  createAnatomy,
  createProps,
  createSplitProps,
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
  isCtrlOrMetaKey,
  isEditableElement,
  isEqual,
  normalizeProps,
  observeAttributes,
  raf,
  scrollIntoView,
  setup
} from "./chunk-TZXIWZZ7.mjs";

// ../node_modules/.pnpm/@zag-js+listbox@1.34.0/node_modules/@zag-js/listbox/dist/index.mjs
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
var getRootId = (ctx) => ctx.ids?.root ?? `listbox:${ctx.id}`;
var getContentId = (ctx) => ctx.ids?.content ?? `listbox:${ctx.id}:content`;
var getLabelId = (ctx) => ctx.ids?.label ?? `listbox:${ctx.id}:label`;
var getItemId = (ctx, id) => ctx.ids?.item?.(id) ?? `listbox:${ctx.id}:item:${id}`;
var getItemGroupId = (ctx, id) => ctx.ids?.itemGroup?.(id) ?? `listbox:${ctx.id}:item-group:${id}`;
var getItemGroupLabelId = (ctx, id) => ctx.ids?.itemGroupLabel?.(id) ?? `listbox:${ctx.id}:item-group-label:${id}`;
var getContentEl = (ctx) => ctx.getById(getContentId(ctx));
var getItemEl = (ctx, id) => ctx.getById(getItemId(ctx, id));
function connect(service, normalize) {
  const { context, prop, scope, computed, send, refs } = service;
  const disabled = prop("disabled");
  const collection2 = prop("collection");
  const layout = isGridCollection(collection2) ? "grid" : "list";
  const focused = context.get("focused");
  const focusVisible = refs.get("focusVisible") && focused;
  const inputState = refs.get("inputState");
  const value = context.get("value");
  const selectedItems = context.get("selectedItems");
  const highlightedValue = context.get("highlightedValue");
  const highlightedItem = context.get("highlightedItem");
  const isTypingAhead = computed("isTypingAhead");
  const interactive = computed("isInteractive");
  const ariaActiveDescendant = highlightedValue ? getItemId(scope, highlightedValue) : void 0;
  function getItemState(props2) {
    const itemDisabled = collection2.getItemDisabled(props2.item);
    const value2 = collection2.getItemValue(props2.item);
    ensure(value2, () => `[zag-js] No value found for item ${JSON.stringify(props2.item)}`);
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
    getInputProps(props2 = {}) {
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
            send({ type: "INPUT.FOCUS", autoHighlight: !!props2?.autoHighlight });
          });
        },
        onBlur() {
          send({ type: "CONTENT.BLUR", src: "input" });
        },
        onInput(event) {
          if (!props2?.autoHighlight) return;
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
              forwardEvent();
            }
            case "Home":
            case "End": {
              if (highlightedValue == null && event.shiftKey) return;
              forwardEvent();
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
    getItemProps(props2) {
      const itemState = getItemState(props2);
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
          if (!props2.highlightOnHover) return;
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
        ...parts.itemIndicator.attrs,
        "aria-hidden": true,
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
              event2.preventDefault();
              let nextValue = collection2.firstValue;
              send({ type: "NAVIGATE", value: nextValue, shiftKey, anchorValue: highlightedValue });
            },
            End(event2) {
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
          const target = getEventTarget(event);
          if (isEditableElement(target)) {
            return;
          }
          if (getByTypeahead.isValidEvent(event) && prop("typeahead")) {
            send({ type: "CONTENT.TYPEAHEAD", key: event.key });
            event.preventDefault();
          }
        }
      });
    }
  };
}
var { guards, createMachine } = setup();
var { or } = guards;
var machine = createMachine({
  props({ props: props2 }) {
    return {
      loopFocus: false,
      composite: true,
      defaultValue: [],
      multiple: false,
      typeahead: true,
      collection: collection.empty(),
      orientation: "vertical",
      selectionMode: "single",
      ...props2
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
      selectedItems: bindable(() => {
        const value = prop("value") ?? prop("defaultValue") ?? [];
        const items = prop("collection").findMany(value);
        return { defaultValue: items };
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
    valueAsString: ({ context, prop }) => prop("collection").stringifyItems(context.get("selectedItems"))
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
var props = createProps()([
  "collection",
  "defaultHighlightedValue",
  "defaultValue",
  "dir",
  "disabled",
  "deselectable",
  "disallowSelectAll",
  "getRootNode",
  "highlightedValue",
  "id",
  "ids",
  "loopFocus",
  "onHighlightChange",
  "onSelect",
  "onValueChange",
  "orientation",
  "scrollToIndexFn",
  "selectionMode",
  "selectOnHighlight",
  "typeahead",
  "value"
]);
var splitProps = createSplitProps(props);
var itemProps = createProps()(["item", "highlightOnHover"]);
var splitItemProps = createSplitProps(itemProps);
var itemGroupProps = createProps()(["id"]);
var splitItemGroupProps = createSplitProps(itemGroupProps);
var itemGroupLabelProps = createProps()(["htmlFor"]);
var splitItemGroupLabelProps = createSplitProps(itemGroupLabelProps);

// components/listbox.ts
var Listbox = class extends Component {
  _options = [];
  hasGroups = false;
  constructor(el, props2) {
    super(el, props2);
    const collectionFromProps = props2.collection;
    this._options = collectionFromProps?.items ?? [];
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
    const allItems = JSON.parse(el.dataset.collection ?? "[]");
    const hasGroups = allItems.some((item) => item.group !== void 0);
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
  },
  updated() {
    const newItems = JSON.parse(this.el.dataset.collection ?? "[]");
    const hasGroups = newItems.some((item) => item.group !== void 0);
    const valueList = getStringList(this.el, "value");
    const controlled = getBoolean(this.el, "controlled");
    if (this.listbox) {
      this.listbox.hasGroups = hasGroups;
      this.listbox.setOptions(newItems);
      this.listbox.updateProps({
        collection: buildCollection(newItems, hasGroups),
        id: this.el.id,
        ...controlled && valueList ? { value: valueList } : {},
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
    this.listbox?.destroy();
  }
};
export {
  ListboxHook as Listbox
};
