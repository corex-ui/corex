import {
  ListCollection,
  createSelectedItemMap,
  deriveSelectionState,
  resolveSelectedItems
} from "./chunk-7ZKQLYA7.mjs";
import {
  getPlacement,
  getPlacementStyles
} from "./chunk-VXCJNDUG.mjs";
import {
  trackDismissableElement
} from "./chunk-EV6LXBMY.mjs";
import "./chunk-YCAWAEF3.mjs";
import {
  getInteractionModality,
  setInteractionModality,
  trackFocusVisible
} from "./chunk-IAPTZYKE.mjs";
import {
  Component,
  VanillaMachine,
  addOrRemove,
  ariaAttr,
  clickIfLink,
  createAnatomy,
  dataAttr,
  ensure,
  getBoolean,
  getEventKey,
  getString,
  getStringList,
  isAnchorElement,
  isBoolean,
  isComposingEvent,
  isContextMenuEvent,
  isDownloadingEvent,
  isEqual,
  isLeftClick,
  isOpeningInNewTab,
  match,
  nextTick,
  normalizeProps,
  observeAttributes,
  query,
  raf,
  remove,
  scrollIntoView,
  setCaretToEnd,
  setup
} from "./chunk-SNFXM6OQ.mjs";

// ../node_modules/.pnpm/@zag-js+combobox@1.36.0/node_modules/@zag-js/combobox/dist/combobox.anatomy.mjs
var anatomy = createAnatomy("combobox").parts(
  "root",
  "clearTrigger",
  "content",
  "control",
  "input",
  "item",
  "itemGroup",
  "itemGroupLabel",
  "itemIndicator",
  "itemText",
  "label",
  "list",
  "positioner",
  "trigger"
);
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+combobox@1.36.0/node_modules/@zag-js/combobox/dist/combobox.collection.mjs
var collection = (options) => {
  return new ListCollection(options);
};
collection.empty = () => {
  return new ListCollection({ items: [] });
};

// ../node_modules/.pnpm/@zag-js+combobox@1.36.0/node_modules/@zag-js/combobox/dist/combobox.dom.mjs
var getRootId = (ctx) => ctx.ids?.root ?? `combobox:${ctx.id}`;
var getLabelId = (ctx) => ctx.ids?.label ?? `combobox:${ctx.id}:label`;
var getControlId = (ctx) => ctx.ids?.control ?? `combobox:${ctx.id}:control`;
var getInputId = (ctx) => ctx.ids?.input ?? `combobox:${ctx.id}:input`;
var getContentId = (ctx) => ctx.ids?.content ?? `combobox:${ctx.id}:content`;
var getPositionerId = (ctx) => ctx.ids?.positioner ?? `combobox:${ctx.id}:popper`;
var getTriggerId = (ctx) => ctx.ids?.trigger ?? `combobox:${ctx.id}:toggle-btn`;
var getClearTriggerId = (ctx) => ctx.ids?.clearTrigger ?? `combobox:${ctx.id}:clear-btn`;
var getItemGroupId = (ctx, id) => ctx.ids?.itemGroup?.(id) ?? `combobox:${ctx.id}:optgroup:${id}`;
var getItemGroupLabelId = (ctx, id) => ctx.ids?.itemGroupLabel?.(id) ?? `combobox:${ctx.id}:optgroup-label:${id}`;
var getItemId = (ctx, id) => ctx.ids?.item?.(id) ?? `combobox:${ctx.id}:option:${id}`;
var getContentEl = (ctx) => ctx.getById(getContentId(ctx));
var getInputEl = (ctx) => ctx.getById(getInputId(ctx));
var getPositionerEl = (ctx) => ctx.getById(getPositionerId(ctx));
var getControlEl = (ctx) => ctx.getById(getControlId(ctx));
var getTriggerEl = (ctx) => ctx.getById(getTriggerId(ctx));
var getClearTriggerEl = (ctx) => ctx.getById(getClearTriggerId(ctx));
var getItemEl = (ctx, value) => {
  if (value == null) return null;
  const selector = `[role=option][data-value="${CSS.escape(value)}"]`;
  return query(getContentEl(ctx), selector);
};
var focusInputEl = (ctx) => {
  const inputEl = getInputEl(ctx);
  if (!ctx.isActiveElement(inputEl)) {
    inputEl?.focus({ preventScroll: true });
  }
  setCaretToEnd(inputEl);
};
var focusTriggerEl = (ctx) => {
  const triggerEl = getTriggerEl(ctx);
  if (ctx.isActiveElement(triggerEl)) return;
  triggerEl?.focus({ preventScroll: true });
};

// ../node_modules/.pnpm/@zag-js+combobox@1.36.0/node_modules/@zag-js/combobox/dist/combobox.connect.mjs
function connect(service, normalize) {
  const { context, prop, state, send, scope, computed, event } = service;
  const translations = prop("translations");
  const collection2 = prop("collection");
  const disabled = !!prop("disabled");
  const interactive = computed("isInteractive");
  const invalid = !!prop("invalid");
  const required = !!prop("required");
  const readOnly = !!prop("readOnly");
  const open = state.hasTag("open");
  const focused = state.hasTag("focused");
  const composite = prop("composite");
  const highlightedValue = context.get("highlightedValue");
  const popperStyles = getPlacementStyles({
    ...prop("positioning"),
    placement: context.get("currentPlacement")
  });
  function getItemState(props) {
    const itemDisabled = collection2.getItemDisabled(props.item);
    const value = collection2.getItemValue(props.item);
    ensure(value, () => `[zag-js] No value found for item ${JSON.stringify(props.item)}`);
    return {
      value,
      disabled: Boolean(disabled || itemDisabled),
      highlighted: highlightedValue === value,
      selected: context.get("value").includes(value)
    };
  }
  return {
    focused,
    open,
    inputValue: context.get("inputValue"),
    highlightedValue,
    highlightedItem: context.get("highlightedItem"),
    value: context.get("value"),
    valueAsString: computed("valueAsString"),
    hasSelectedItems: computed("hasSelectedItems"),
    selectedItems: computed("selectedItems"),
    collection: prop("collection"),
    multiple: !!prop("multiple"),
    disabled: !!disabled,
    syncSelectedItems() {
      send({ type: "SELECTED_ITEMS.SYNC" });
    },
    reposition(options = {}) {
      send({ type: "POSITIONING.SET", options });
    },
    setHighlightValue(value) {
      send({ type: "HIGHLIGHTED_VALUE.SET", value });
    },
    clearHighlightValue() {
      send({ type: "HIGHLIGHTED_VALUE.CLEAR" });
    },
    selectValue(value) {
      send({ type: "ITEM.SELECT", value });
    },
    setValue(value) {
      send({ type: "VALUE.SET", value });
    },
    setInputValue(value, reason = "script") {
      send({ type: "INPUT_VALUE.SET", value, src: reason });
    },
    clearValue(value) {
      if (value != null) {
        send({ type: "ITEM.CLEAR", value });
      } else {
        send({ type: "VALUE.CLEAR" });
      }
    },
    focus() {
      getInputEl(scope)?.focus();
    },
    setOpen(nextOpen, reason = "script") {
      const open2 = state.hasTag("open");
      if (open2 === nextOpen) return;
      send({ type: nextOpen ? "OPEN" : "CLOSE", src: reason });
    },
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
        ...parts.label.attrs,
        dir: prop("dir"),
        htmlFor: getInputId(scope),
        id: getLabelId(scope),
        "data-readonly": dataAttr(readOnly),
        "data-disabled": dataAttr(disabled),
        "data-invalid": dataAttr(invalid),
        "data-required": dataAttr(required),
        "data-focus": dataAttr(focused),
        onClick(event2) {
          if (composite) return;
          event2.preventDefault();
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
    getPositionerProps() {
      return normalize.element({
        ...parts.positioner.attrs,
        dir: prop("dir"),
        id: getPositionerId(scope),
        style: popperStyles.floating
      });
    },
    getInputProps() {
      return normalize.input({
        ...parts.input.attrs,
        dir: prop("dir"),
        "aria-invalid": ariaAttr(invalid),
        "data-invalid": dataAttr(invalid),
        "data-autofocus": dataAttr(prop("autoFocus")),
        name: prop("name"),
        form: prop("form"),
        disabled,
        required: prop("required"),
        autoComplete: "off",
        autoCorrect: "off",
        autoCapitalize: "none",
        spellCheck: "false",
        readOnly,
        placeholder: prop("placeholder"),
        id: getInputId(scope),
        type: "text",
        role: "combobox",
        defaultValue: context.get("inputValue"),
        "aria-autocomplete": computed("autoComplete") ? "both" : "list",
        "aria-controls": getContentId(scope),
        "aria-expanded": open,
        "data-state": open ? "open" : "closed",
        "aria-activedescendant": highlightedValue ? getItemId(scope, highlightedValue) : void 0,
        onClick(event2) {
          if (event2.defaultPrevented) return;
          if (!prop("openOnClick")) return;
          if (!interactive) return;
          send({ type: "INPUT.CLICK", src: "input-click" });
        },
        onFocus() {
          if (disabled) return;
          send({ type: "INPUT.FOCUS" });
        },
        onBlur() {
          if (disabled) return;
          send({ type: "INPUT.BLUR" });
        },
        onChange(event2) {
          send({ type: "INPUT.CHANGE", value: event2.currentTarget.value, src: "input-change" });
        },
        onKeyDown(event2) {
          if (event2.defaultPrevented) return;
          if (!interactive) return;
          if (event2.ctrlKey || event2.shiftKey || isComposingEvent(event2)) return;
          const openOnKeyPress = prop("openOnKeyPress");
          const isModifierKey = event2.ctrlKey || event2.metaKey || event2.shiftKey;
          const keypress = true;
          const keymap = {
            ArrowDown(event3) {
              if (!openOnKeyPress && !open) return;
              send({ type: event3.altKey ? "OPEN" : "INPUT.ARROW_DOWN", keypress, src: "arrow-key" });
              event3.preventDefault();
            },
            ArrowUp() {
              if (!openOnKeyPress && !open) return;
              send({ type: event2.altKey ? "CLOSE" : "INPUT.ARROW_UP", keypress, src: "arrow-key" });
              event2.preventDefault();
            },
            Home(event3) {
              if (isModifierKey) return;
              send({ type: "INPUT.HOME", keypress });
              if (open) {
                event3.preventDefault();
              }
            },
            End(event3) {
              if (isModifierKey) return;
              send({ type: "INPUT.END", keypress });
              if (open) {
                event3.preventDefault();
              }
            },
            Enter(event3) {
              send({ type: "INPUT.ENTER", keypress, src: "item-select" });
              const submittable = computed("isCustomValue") && prop("allowCustomValue");
              const hasHighlight = highlightedValue != null;
              const alwaysSubmit = prop("alwaysSubmitOnEnter");
              if (open && !submittable && !alwaysSubmit && hasHighlight) {
                event3.preventDefault();
              }
              if (highlightedValue == null) return;
              const itemEl = getItemEl(scope, highlightedValue);
              if (isAnchorElement(itemEl)) {
                prop("navigate")?.({ value: highlightedValue, node: itemEl, href: itemEl.href });
              }
            },
            Escape() {
              send({ type: "INPUT.ESCAPE", keypress, src: "escape-key" });
              event2.preventDefault();
            }
          };
          const key = getEventKey(event2, { dir: prop("dir") });
          const exec = keymap[key];
          exec?.(event2);
        }
      });
    },
    getTriggerProps(props = {}) {
      return normalize.button({
        ...parts.trigger.attrs,
        dir: prop("dir"),
        id: getTriggerId(scope),
        "aria-haspopup": composite ? "listbox" : "dialog",
        type: "button",
        tabIndex: props.focusable ? void 0 : -1,
        "aria-label": translations.triggerLabel,
        "aria-expanded": open,
        "data-state": open ? "open" : "closed",
        "aria-controls": open ? getContentId(scope) : void 0,
        disabled,
        "data-invalid": dataAttr(invalid),
        "data-focusable": dataAttr(props.focusable),
        "data-readonly": dataAttr(readOnly),
        "data-disabled": dataAttr(disabled),
        onFocus() {
          if (!props.focusable) return;
          send({ type: "INPUT.FOCUS", src: "trigger" });
        },
        onClick(event2) {
          if (event2.defaultPrevented) return;
          if (!interactive) return;
          if (!isLeftClick(event2)) return;
          send({ type: "TRIGGER.CLICK", src: "trigger-click" });
        },
        onPointerDown(event2) {
          if (!interactive) return;
          if (event2.pointerType === "touch") return;
          if (!isLeftClick(event2)) return;
          event2.preventDefault();
          queueMicrotask(() => {
            focusInputEl(scope);
          });
        },
        onKeyDown(event2) {
          if (event2.defaultPrevented) return;
          if (composite) return;
          const keyMap = {
            ArrowDown() {
              send({ type: "INPUT.ARROW_DOWN", src: "arrow-key" });
            },
            ArrowUp() {
              send({ type: "INPUT.ARROW_UP", src: "arrow-key" });
            }
          };
          const key = getEventKey(event2, { dir: prop("dir") });
          const exec = keyMap[key];
          if (exec) {
            exec(event2);
            event2.preventDefault();
          }
        }
      });
    },
    getContentProps() {
      return normalize.element({
        ...parts.content.attrs,
        dir: prop("dir"),
        id: getContentId(scope),
        role: !composite ? "dialog" : "listbox",
        tabIndex: -1,
        hidden: !open,
        "data-state": open ? "open" : "closed",
        "data-placement": context.get("currentPlacement"),
        "aria-labelledby": getLabelId(scope),
        "aria-multiselectable": prop("multiple") && composite ? true : void 0,
        "data-empty": dataAttr(collection2.size === 0),
        onPointerDown(event2) {
          if (!isLeftClick(event2)) return;
          event2.preventDefault();
        }
      });
    },
    getListProps() {
      return normalize.element({
        ...parts.list.attrs,
        role: !composite ? "listbox" : void 0,
        "data-empty": dataAttr(collection2.size === 0),
        "aria-labelledby": getLabelId(scope),
        "aria-multiselectable": prop("multiple") && !composite ? true : void 0
      });
    },
    getClearTriggerProps() {
      return normalize.button({
        ...parts.clearTrigger.attrs,
        dir: prop("dir"),
        id: getClearTriggerId(scope),
        type: "button",
        tabIndex: -1,
        disabled,
        "data-invalid": dataAttr(invalid),
        "aria-label": translations.clearTriggerLabel,
        "aria-controls": getInputId(scope),
        hidden: !context.get("value").length,
        onPointerDown(event2) {
          if (!isLeftClick(event2)) return;
          event2.preventDefault();
        },
        onClick(event2) {
          if (event2.defaultPrevented) return;
          if (!interactive) return;
          send({ type: "VALUE.CLEAR", src: "clear-trigger" });
        }
      });
    },
    getItemState,
    getItemProps(props) {
      const itemState = getItemState(props);
      const value = itemState.value;
      return normalize.element({
        ...parts.item.attrs,
        dir: prop("dir"),
        id: getItemId(scope, value),
        role: "option",
        tabIndex: -1,
        "data-highlighted": dataAttr(itemState.highlighted),
        "data-state": itemState.selected ? "checked" : "unchecked",
        "aria-selected": ariaAttr(itemState.selected),
        "aria-disabled": ariaAttr(itemState.disabled),
        "data-disabled": dataAttr(itemState.disabled),
        "data-value": itemState.value,
        onPointerMove() {
          if (itemState.disabled) return;
          if (itemState.highlighted) return;
          send({ type: "ITEM.POINTER_MOVE", value });
        },
        onPointerLeave() {
          if (props.persistFocus) return;
          if (itemState.disabled) return;
          const prev = event.previous();
          const mouseMoved = prev?.type.includes("POINTER");
          if (!mouseMoved) return;
          send({ type: "ITEM.POINTER_LEAVE", value });
        },
        onClick(event2) {
          if (isDownloadingEvent(event2)) return;
          if (isOpeningInNewTab(event2)) return;
          if (isContextMenuEvent(event2)) return;
          if (itemState.disabled) return;
          send({ type: "ITEM.CLICK", src: "item-select", value });
        }
      });
    },
    getItemTextProps(props) {
      const itemState = getItemState(props);
      return normalize.element({
        ...parts.itemText.attrs,
        dir: prop("dir"),
        "data-state": itemState.selected ? "checked" : "unchecked",
        "data-disabled": dataAttr(itemState.disabled),
        "data-highlighted": dataAttr(itemState.highlighted)
      });
    },
    getItemIndicatorProps(props) {
      const itemState = getItemState(props);
      return normalize.element({
        "aria-hidden": true,
        ...parts.itemIndicator.attrs,
        dir: prop("dir"),
        "data-state": itemState.selected ? "checked" : "unchecked",
        hidden: !itemState.selected
      });
    },
    getItemGroupProps(props) {
      const { id } = props;
      return normalize.element({
        ...parts.itemGroup.attrs,
        dir: prop("dir"),
        id: getItemGroupId(scope, id),
        "aria-labelledby": getItemGroupLabelId(scope, id),
        "data-empty": dataAttr(collection2.size === 0),
        role: "group"
      });
    },
    getItemGroupLabelProps(props) {
      const { htmlFor } = props;
      return normalize.element({
        ...parts.itemGroupLabel.attrs,
        dir: prop("dir"),
        id: getItemGroupLabelId(scope, htmlFor),
        role: "presentation"
      });
    }
  };
}

// ../node_modules/.pnpm/@zag-js+combobox@1.36.0/node_modules/@zag-js/combobox/dist/combobox.machine.mjs
var { guards, createMachine, choose } = setup();
var { and, not } = guards;
var machine = createMachine({
  props({ props }) {
    return {
      loopFocus: true,
      openOnClick: false,
      defaultValue: [],
      defaultInputValue: "",
      closeOnSelect: !props.multiple,
      allowCustomValue: false,
      alwaysSubmitOnEnter: false,
      inputBehavior: "none",
      selectionBehavior: props.multiple ? "clear" : "replace",
      openOnKeyPress: true,
      openOnChange: true,
      composite: true,
      navigate({ node }) {
        clickIfLink(node);
      },
      collection: collection.empty(),
      ...props,
      positioning: {
        placement: "bottom",
        sameWidth: true,
        ...props.positioning
      },
      translations: {
        triggerLabel: "Toggle suggestions",
        clearTriggerLabel: "Clear value",
        ...props.translations
      }
    };
  },
  initialState({ prop }) {
    const open = prop("open") || prop("defaultOpen");
    return open ? "open.suggesting" : "closed.idle";
  },
  context({ prop, bindable, getContext, getEvent }) {
    const initialValue = prop("value") ?? prop("defaultValue") ?? [];
    const initialSelectedItems = prop("collection").findMany(initialValue);
    return {
      currentPlacement: bindable(() => ({
        defaultValue: void 0
      })),
      value: bindable(() => ({
        defaultValue: prop("defaultValue"),
        value: prop("value"),
        isEqual,
        hash(value) {
          return value.join(",");
        },
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
          prop("onValueChange")?.({ value, items: proposed.selectedItems });
        }
      })),
      highlightedValue: bindable(() => ({
        defaultValue: prop("defaultHighlightedValue") || null,
        value: prop("highlightedValue"),
        onChange(value) {
          const item = prop("collection").find(value);
          prop("onHighlightChange")?.({ highlightedValue: value, highlightedItem: item });
        }
      })),
      inputValue: bindable(() => {
        let inputValue = prop("inputValue") || prop("defaultInputValue");
        const value = prop("value") || prop("defaultValue");
        if (!inputValue.trim() && !prop("multiple")) {
          const valueAsString = prop("collection").stringifyMany(value);
          inputValue = match(prop("selectionBehavior"), {
            preserve: inputValue || valueAsString,
            replace: valueAsString,
            clear: ""
          });
        }
        return {
          defaultValue: inputValue,
          value: prop("inputValue"),
          onChange(value2) {
            const event = getEvent();
            const reason = (event.previousEvent || event).src;
            prop("onInputValueChange")?.({ inputValue: value2, reason });
          }
        };
      }),
      highlightedItem: bindable(() => {
        const highlightedValue = prop("highlightedValue");
        const highlightedItem = prop("collection").find(highlightedValue);
        return { defaultValue: highlightedItem };
      }),
      selectedItemMap: bindable(() => {
        return {
          defaultValue: createSelectedItemMap({
            selectedItems: initialSelectedItems,
            collection: prop("collection")
          })
        };
      })
    };
  },
  computed: {
    isInputValueEmpty: ({ context }) => context.get("inputValue").length === 0,
    isInteractive: ({ prop }) => !(prop("readOnly") || prop("disabled")),
    autoComplete: ({ prop }) => prop("inputBehavior") === "autocomplete",
    autoHighlight: ({ prop }) => prop("inputBehavior") === "autohighlight",
    hasSelectedItems: ({ context }) => context.get("value").length > 0,
    selectedItems: ({ context, prop }) => resolveSelectedItems({
      values: context.get("value"),
      collection: prop("collection"),
      selectedItemMap: context.get("selectedItemMap")
    }),
    valueAsString: ({ computed, prop }) => prop("collection").stringifyItems(computed("selectedItems")),
    isCustomValue: ({ context, computed }) => context.get("inputValue") !== computed("valueAsString")
  },
  watch({ context, prop, track, action, send }) {
    track([() => context.hash("value")], () => {
      action(["syncSelectedItems"]);
    });
    track([() => context.get("inputValue")], () => {
      action(["syncInputValue"]);
    });
    track([() => context.get("highlightedValue")], () => {
      action(["syncHighlightedItem", "autofillInputValue"]);
    });
    track([() => prop("open")], () => {
      action(["toggleVisibility"]);
    });
    track([() => prop("collection").toString()], () => {
      send({ type: "CHILDREN_CHANGE" });
    });
  },
  on: {
    "SELECTED_ITEMS.SYNC": {
      actions: ["syncSelectedItems"]
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
    },
    "VALUE.SET": {
      actions: ["setValue"]
    },
    "INPUT_VALUE.SET": {
      actions: ["setInputValue"]
    },
    "POSITIONING.SET": {
      actions: ["reposition"]
    }
  },
  entry: choose([
    {
      guard: "autoFocus",
      actions: ["setInitialFocus"]
    }
  ]),
  states: {
    closed: {
      tags: ["closed"],
      initial: "idle",
      states: {
        idle: {
          tags: ["idle"],
          entry: ["scrollContentToTop", "clearHighlightedValue"],
          on: {
            "CONTROLLED.OPEN": {
              target: "open.interacting"
            },
            "TRIGGER.CLICK": [
              {
                guard: "isOpenControlled",
                actions: ["setInitialFocus", "highlightFirstSelectedItem", "invokeOnOpen"]
              },
              {
                target: "open.interacting",
                actions: ["setInitialFocus", "highlightFirstSelectedItem", "invokeOnOpen"]
              }
            ],
            "INPUT.CLICK": [
              {
                guard: "isOpenControlled",
                actions: ["highlightFirstSelectedItem", "invokeOnOpen"]
              },
              {
                target: "open.interacting",
                actions: ["highlightFirstSelectedItem", "invokeOnOpen"]
              }
            ],
            "INPUT.FOCUS": {
              target: "focused"
            },
            OPEN: [
              {
                guard: "isOpenControlled",
                actions: ["invokeOnOpen"]
              },
              {
                target: "open.interacting",
                actions: ["invokeOnOpen"]
              }
            ],
            "VALUE.CLEAR": {
              target: "focused",
              actions: ["clearInputValue", "clearSelectedItems", "setInitialFocus"]
            }
          }
        },
        focused: {
          tags: ["focused"],
          entry: ["scrollContentToTop", "clearHighlightedValue"],
          on: {
            "CONTROLLED.OPEN": [
              {
                guard: "isChangeEvent",
                target: "open.suggesting"
              },
              {
                target: "open.interacting"
              }
            ],
            "INPUT.CHANGE": [
              {
                guard: and("isOpenControlled", "openOnChange"),
                actions: ["setInputValue", "invokeOnOpen", "highlightFirstItemIfNeeded"]
              },
              {
                guard: "openOnChange",
                target: "open.suggesting",
                actions: ["setInputValue", "invokeOnOpen", "highlightFirstItemIfNeeded"]
              },
              {
                actions: ["setInputValue"]
              }
            ],
            "LAYER.INTERACT_OUTSIDE": {
              target: "idle"
            },
            "INPUT.ESCAPE": {
              guard: and("isCustomValue", not("allowCustomValue")),
              actions: ["revertInputValue"]
            },
            "INPUT.BLUR": {
              target: "idle"
            },
            "INPUT.CLICK": [
              {
                guard: "isOpenControlled",
                actions: ["highlightFirstSelectedItem", "invokeOnOpen"]
              },
              {
                target: "open.interacting",
                actions: ["highlightFirstSelectedItem", "invokeOnOpen"]
              }
            ],
            "TRIGGER.CLICK": [
              {
                guard: "isOpenControlled",
                actions: ["setInitialFocus", "highlightFirstSelectedItem", "invokeOnOpen"]
              },
              {
                target: "open.interacting",
                actions: ["setInitialFocus", "highlightFirstSelectedItem", "invokeOnOpen"]
              }
            ],
            "INPUT.ARROW_DOWN": [
              // == group 1 ==
              {
                guard: and("isOpenControlled", "autoComplete"),
                actions: ["invokeOnOpen"]
              },
              {
                guard: "autoComplete",
                target: "open.interacting",
                actions: ["invokeOnOpen"]
              },
              // == group 2 ==
              {
                guard: "isOpenControlled",
                actions: ["highlightFirstOrSelectedItem", "invokeOnOpen"]
              },
              {
                target: "open.interacting",
                actions: ["highlightFirstOrSelectedItem", "invokeOnOpen"]
              }
            ],
            "INPUT.ARROW_UP": [
              // == group 1 ==
              {
                guard: and("isOpenControlled", "autoComplete"),
                actions: ["invokeOnOpen"]
              },
              {
                guard: "autoComplete",
                target: "open.interacting",
                actions: ["invokeOnOpen"]
              },
              // == group 2 ==
              {
                guard: "isOpenControlled",
                actions: ["highlightLastOrSelectedItem", "invokeOnOpen"]
              },
              {
                target: "open.interacting",
                actions: ["highlightLastOrSelectedItem", "invokeOnOpen"]
              }
            ],
            OPEN: [
              {
                guard: "isOpenControlled",
                actions: ["invokeOnOpen"]
              },
              {
                target: "open.interacting",
                actions: ["invokeOnOpen"]
              }
            ],
            "VALUE.CLEAR": {
              actions: ["clearInputValue", "clearSelectedItems"]
            }
          }
        }
      }
    },
    open: {
      tags: ["open", "focused"],
      entry: ["setInitialFocus"],
      effects: ["trackFocusVisible", "scrollToHighlightedItem", "trackDismissableLayer", "trackPlacement"],
      on: {
        "CONTROLLED.CLOSE": [
          {
            guard: "restoreFocus",
            target: "closed.focused",
            actions: ["setFinalFocus"]
          },
          {
            target: "closed.idle"
          }
        ],
        "INPUT.ENTER": [
          // == group 1 ==
          {
            guard: and("isOpenControlled", "isCustomValue", not("hasHighlightedItem"), not("allowCustomValue")),
            actions: ["revertInputValue", "invokeOnClose"]
          },
          {
            guard: and("isCustomValue", not("hasHighlightedItem"), not("allowCustomValue")),
            target: "closed.focused",
            actions: ["revertInputValue", "invokeOnClose"]
          },
          // == group 2 ==
          {
            guard: and("isOpenControlled", "closeOnSelect"),
            actions: ["selectHighlightedItem", "invokeOnClose"]
          },
          {
            guard: "closeOnSelect",
            target: "closed.focused",
            actions: ["selectHighlightedItem", "invokeOnClose", "setFinalFocus"]
          },
          {
            actions: ["selectHighlightedItem"]
          }
        ],
        "ITEM.CLICK": [
          {
            guard: and("isOpenControlled", "closeOnSelect"),
            actions: ["selectItem", "invokeOnClose"]
          },
          {
            guard: "closeOnSelect",
            target: "closed.focused",
            actions: ["selectItem", "invokeOnClose", "setFinalFocus"]
          },
          {
            actions: ["selectItem"]
          }
        ],
        "TRIGGER.CLICK": [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnClose"]
          },
          {
            target: "closed.focused",
            actions: ["invokeOnClose"]
          }
        ],
        "LAYER.INTERACT_OUTSIDE": [
          // == group 1 ==
          {
            guard: and("isOpenControlled", "isCustomValue", not("allowCustomValue")),
            actions: ["revertInputValue", "invokeOnClose"]
          },
          {
            guard: and("isCustomValue", not("allowCustomValue")),
            target: "closed.idle",
            actions: ["revertInputValue", "invokeOnClose"]
          },
          // == group 2 ==
          {
            guard: "isOpenControlled",
            actions: ["invokeOnClose"]
          },
          {
            target: "closed.idle",
            actions: ["invokeOnClose"]
          }
        ],
        CLOSE: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnClose"]
          },
          {
            target: "closed.focused",
            actions: ["invokeOnClose", "setFinalFocus"]
          }
        ],
        "VALUE.CLEAR": [
          {
            guard: "isOpenControlled",
            actions: ["clearInputValue", "clearSelectedItems", "invokeOnClose"]
          },
          {
            target: "closed.focused",
            actions: ["clearInputValue", "clearSelectedItems", "invokeOnClose", "setFinalFocus"]
          }
        ]
      },
      initial: "interacting",
      states: {
        interacting: {
          on: {
            CHILDREN_CHANGE: [
              {
                guard: "isHighlightedItemRemoved",
                actions: ["clearHighlightedValue"]
              },
              {
                actions: ["scrollToHighlightedItem"]
              }
            ],
            "INPUT.HOME": {
              actions: ["highlightFirstItem"]
            },
            "INPUT.END": {
              actions: ["highlightLastItem"]
            },
            "INPUT.ARROW_DOWN": [
              {
                guard: and("autoComplete", "isLastItemHighlighted"),
                actions: ["clearHighlightedValue", "scrollContentToTop"]
              },
              {
                actions: ["highlightNextItem"]
              }
            ],
            "INPUT.ARROW_UP": [
              {
                guard: and("autoComplete", "isFirstItemHighlighted"),
                actions: ["clearHighlightedValue"]
              },
              {
                actions: ["highlightPrevItem"]
              }
            ],
            "INPUT.CHANGE": [
              {
                guard: "autoComplete",
                target: "suggesting",
                actions: ["setInputValue"]
              },
              {
                target: "suggesting",
                actions: ["clearHighlightedValue", "setInputValue"]
              }
            ],
            "ITEM.POINTER_MOVE": {
              actions: ["setHighlightedValue"]
            },
            "ITEM.POINTER_LEAVE": {
              actions: ["clearHighlightedValue"]
            },
            "LAYER.ESCAPE": [
              {
                guard: and("isOpenControlled", "autoComplete"),
                actions: ["syncInputValue", "invokeOnClose"]
              },
              {
                guard: "autoComplete",
                target: "closed.focused",
                actions: ["syncInputValue", "invokeOnClose"]
              },
              {
                guard: "isOpenControlled",
                actions: ["invokeOnClose"]
              },
              {
                target: "closed.focused",
                actions: ["invokeOnClose", "setFinalFocus"]
              }
            ]
          }
        },
        suggesting: {
          on: {
            CHILDREN_CHANGE: [
              {
                guard: and("isHighlightedItemRemoved", "hasCollectionItems", "autoHighlight"),
                actions: ["clearHighlightedValue", "highlightFirstItem"]
              },
              {
                guard: "isHighlightedItemRemoved",
                actions: ["clearHighlightedValue"]
              },
              {
                guard: "autoHighlight",
                actions: ["highlightFirstItem"]
              }
            ],
            "INPUT.ARROW_DOWN": {
              target: "interacting",
              actions: ["highlightNextItem"]
            },
            "INPUT.ARROW_UP": {
              target: "interacting",
              actions: ["highlightPrevItem"]
            },
            "INPUT.HOME": {
              target: "interacting",
              actions: ["highlightFirstItem"]
            },
            "INPUT.END": {
              target: "interacting",
              actions: ["highlightLastItem"]
            },
            "INPUT.CHANGE": {
              actions: ["setInputValue"]
            },
            "LAYER.ESCAPE": [
              {
                guard: "isOpenControlled",
                actions: ["invokeOnClose"]
              },
              {
                target: "closed.focused",
                actions: ["invokeOnClose"]
              }
            ],
            "ITEM.POINTER_MOVE": {
              target: "interacting",
              actions: ["setHighlightedValue"]
            },
            "ITEM.POINTER_LEAVE": {
              actions: ["clearHighlightedValue"]
            }
          }
        }
      }
    }
  },
  implementations: {
    guards: {
      isInputValueEmpty: ({ computed }) => computed("isInputValueEmpty"),
      autoComplete: ({ computed, prop }) => computed("autoComplete") && !prop("multiple"),
      autoHighlight: ({ computed }) => computed("autoHighlight"),
      isFirstItemHighlighted: ({ prop, context }) => prop("collection").firstValue === context.get("highlightedValue"),
      isLastItemHighlighted: ({ prop, context }) => prop("collection").lastValue === context.get("highlightedValue"),
      isCustomValue: ({ computed }) => computed("isCustomValue"),
      allowCustomValue: ({ prop }) => !!prop("allowCustomValue"),
      hasHighlightedItem: ({ context }) => context.get("highlightedValue") != null,
      closeOnSelect: ({ prop }) => !!prop("closeOnSelect"),
      isOpenControlled: ({ prop }) => prop("open") != null,
      openOnChange: ({ prop, context }) => {
        const openOnChange = prop("openOnChange");
        if (isBoolean(openOnChange)) return openOnChange;
        return !!openOnChange?.({ inputValue: context.get("inputValue") });
      },
      restoreFocus: ({ event }) => {
        const restoreFocus = event.restoreFocus ?? event.previousEvent?.restoreFocus;
        return restoreFocus == null ? true : !!restoreFocus;
      },
      isChangeEvent: ({ event }) => event.previousEvent?.type === "INPUT.CHANGE",
      autoFocus: ({ prop }) => !!prop("autoFocus"),
      isHighlightedItemRemoved: ({ prop, context }) => !prop("collection").has(context.get("highlightedValue")),
      hasCollectionItems: ({ prop }) => prop("collection").size > 0
    },
    effects: {
      trackFocusVisible({ scope }) {
        return trackFocusVisible({ root: scope.getRootNode?.() });
      },
      trackDismissableLayer({ send, prop, scope }) {
        if (prop("disableLayer")) return;
        const contentEl = () => getContentEl(scope);
        return trackDismissableElement(contentEl, {
          type: "listbox",
          defer: true,
          exclude: () => [getInputEl(scope), getTriggerEl(scope), getClearTriggerEl(scope)],
          onFocusOutside: prop("onFocusOutside"),
          onPointerDownOutside: prop("onPointerDownOutside"),
          onInteractOutside: prop("onInteractOutside"),
          onEscapeKeyDown(event) {
            event.preventDefault();
            event.stopPropagation();
            send({ type: "LAYER.ESCAPE", src: "escape-key" });
          },
          onDismiss() {
            send({ type: "LAYER.INTERACT_OUTSIDE", src: "interact-outside", restoreFocus: false });
          }
        });
      },
      trackPlacement({ context, prop, scope }) {
        const anchorEl = () => getControlEl(scope) || getTriggerEl(scope);
        const positionerEl = () => getPositionerEl(scope);
        context.set("currentPlacement", prop("positioning").placement);
        return getPlacement(anchorEl, positionerEl, {
          ...prop("positioning"),
          defer: true,
          onComplete(data) {
            context.set("currentPlacement", data.placement);
          }
        });
      },
      scrollToHighlightedItem({ context, prop, scope }) {
        const inputEl = getInputEl(scope);
        let cleanups = [];
        const exec = (immediate) => {
          const modality = getInteractionModality();
          if (modality === "pointer") return;
          const highlightedValue = context.get("highlightedValue");
          if (!highlightedValue) return;
          const contentEl = getContentEl(scope);
          const scrollToIndexFn = prop("scrollToIndexFn");
          if (scrollToIndexFn) {
            const highlightedIndex = prop("collection").indexOf(highlightedValue);
            scrollToIndexFn({
              index: highlightedIndex,
              immediate,
              getElement: () => getItemEl(scope, highlightedValue)
            });
            return;
          }
          const itemEl = getItemEl(scope, highlightedValue);
          const raf_cleanup = raf(() => {
            scrollIntoView(itemEl, { rootEl: contentEl, block: "nearest" });
          });
          cleanups.push(raf_cleanup);
        };
        const rafCleanup = raf(() => {
          setInteractionModality("virtual");
          exec(true);
        });
        cleanups.push(rafCleanup);
        const observerCleanup = observeAttributes(inputEl, {
          attributes: ["aria-activedescendant"],
          callback: () => exec(false)
        });
        cleanups.push(observerCleanup);
        return () => {
          cleanups.forEach((cleanup) => cleanup());
        };
      }
    },
    actions: {
      reposition({ context, prop, scope, event }) {
        const controlEl = () => getControlEl(scope);
        const positionerEl = () => getPositionerEl(scope);
        getPlacement(controlEl, positionerEl, {
          ...prop("positioning"),
          ...event.options,
          defer: true,
          listeners: false,
          onComplete(data) {
            context.set("currentPlacement", data.placement);
          }
        });
      },
      setHighlightedValue({ context, event }) {
        if (event.value == null) return;
        context.set("highlightedValue", event.value);
      },
      clearHighlightedValue({ context }) {
        context.set("highlightedValue", null);
      },
      selectHighlightedItem(params) {
        const { context, prop } = params;
        const collection2 = prop("collection");
        const highlightedValue = context.get("highlightedValue");
        if (!highlightedValue || !collection2.has(highlightedValue)) return;
        const nextValue = prop("multiple") ? addOrRemove(context.get("value"), highlightedValue) : [highlightedValue];
        prop("onSelect")?.({ value: nextValue, itemValue: highlightedValue });
        context.set("value", nextValue);
        const inputValue = match(prop("selectionBehavior"), {
          preserve: context.get("inputValue"),
          replace: collection2.stringifyMany(nextValue),
          clear: ""
        });
        context.set("inputValue", inputValue);
      },
      scrollToHighlightedItem({ context, prop, scope }) {
        nextTick(() => {
          const highlightedValue = context.get("highlightedValue");
          if (highlightedValue == null) return;
          const itemEl = getItemEl(scope, highlightedValue);
          const contentEl = getContentEl(scope);
          const scrollToIndexFn = prop("scrollToIndexFn");
          if (scrollToIndexFn) {
            const highlightedIndex = prop("collection").indexOf(highlightedValue);
            scrollToIndexFn({
              index: highlightedIndex,
              immediate: true,
              getElement: () => getItemEl(scope, highlightedValue)
            });
            return;
          }
          scrollIntoView(itemEl, { rootEl: contentEl, block: "nearest" });
        });
      },
      selectItem(params) {
        const { context, event, flush, prop } = params;
        if (event.value == null) return;
        flush(() => {
          const nextValue = prop("multiple") ? addOrRemove(context.get("value"), event.value) : [event.value];
          prop("onSelect")?.({ value: nextValue, itemValue: event.value });
          context.set("value", nextValue);
          const inputValue = match(prop("selectionBehavior"), {
            preserve: context.get("inputValue"),
            replace: prop("collection").stringifyMany(nextValue),
            clear: ""
          });
          context.set("inputValue", inputValue);
        });
      },
      clearItem(params) {
        const { context, event, flush, prop } = params;
        if (event.value == null) return;
        flush(() => {
          const nextValue = remove(context.get("value"), event.value);
          context.set("value", nextValue);
          const inputValue = match(prop("selectionBehavior"), {
            preserve: context.get("inputValue"),
            replace: prop("collection").stringifyMany(nextValue),
            clear: ""
          });
          context.set("inputValue", inputValue);
        });
      },
      setInitialFocus({ scope }) {
        raf(() => {
          focusInputEl(scope);
        });
      },
      setFinalFocus({ scope }) {
        raf(() => {
          const triggerEl = getTriggerEl(scope);
          if (triggerEl?.dataset.focusable == null) {
            focusInputEl(scope);
          } else {
            focusTriggerEl(scope);
          }
        });
      },
      syncInputValue({ context, scope, event }) {
        const inputEl = getInputEl(scope);
        if (!inputEl) return;
        inputEl.value = context.get("inputValue");
        queueMicrotask(() => {
          if (event.current().type === "INPUT.CHANGE") return;
          setCaretToEnd(inputEl);
        });
      },
      setInputValue({ context, event }) {
        context.set("inputValue", event.value);
      },
      clearInputValue({ context }) {
        context.set("inputValue", "");
      },
      revertInputValue({ context, prop, computed }) {
        const selectionBehavior = prop("selectionBehavior");
        const inputValue = match(selectionBehavior, {
          replace: computed("hasSelectedItems") ? computed("valueAsString") : "",
          preserve: context.get("inputValue"),
          clear: ""
        });
        context.set("inputValue", inputValue);
      },
      setValue(params) {
        const { context, flush, event, prop } = params;
        flush(() => {
          context.set("value", event.value);
          const inputValue = match(prop("selectionBehavior"), {
            preserve: context.get("inputValue"),
            replace: prop("collection").stringifyMany(event.value),
            clear: ""
          });
          context.set("inputValue", inputValue);
        });
      },
      clearSelectedItems(params) {
        const { context, flush, prop } = params;
        flush(() => {
          context.set("value", []);
          const inputValue = match(prop("selectionBehavior"), {
            preserve: context.get("inputValue"),
            replace: prop("collection").stringifyMany([]),
            clear: ""
          });
          context.set("inputValue", inputValue);
        });
      },
      scrollContentToTop({ prop, scope }) {
        const scrollToIndexFn = prop("scrollToIndexFn");
        if (scrollToIndexFn) {
          const firstValue = prop("collection").firstValue;
          scrollToIndexFn({
            index: 0,
            immediate: true,
            getElement: () => getItemEl(scope, firstValue)
          });
        } else {
          const contentEl = getContentEl(scope);
          if (!contentEl) return;
          contentEl.scrollTop = 0;
        }
      },
      invokeOnOpen({ prop, event, context }) {
        const reason = getOpenChangeReason(event);
        prop("onOpenChange")?.({ open: true, reason, value: context.get("value") });
      },
      invokeOnClose({ prop, event, context }) {
        const reason = getOpenChangeReason(event);
        prop("onOpenChange")?.({ open: false, reason, value: context.get("value") });
      },
      highlightFirstItem({ context, prop, scope }) {
        const exec = getContentEl(scope) ? queueMicrotask : raf;
        exec(() => {
          const value = prop("collection").firstValue;
          if (value) context.set("highlightedValue", value);
        });
      },
      highlightFirstItemIfNeeded({ computed, action }) {
        if (!computed("autoHighlight")) return;
        action(["highlightFirstItem"]);
      },
      highlightLastItem({ context, prop, scope }) {
        const exec = getContentEl(scope) ? queueMicrotask : raf;
        exec(() => {
          const value = prop("collection").lastValue;
          if (value) context.set("highlightedValue", value);
        });
      },
      highlightNextItem({ context, prop }) {
        let value = null;
        const highlightedValue = context.get("highlightedValue");
        const collection2 = prop("collection");
        if (highlightedValue) {
          value = collection2.getNextValue(highlightedValue);
          if (!value && prop("loopFocus")) value = collection2.firstValue;
        } else {
          value = collection2.firstValue;
        }
        if (value) context.set("highlightedValue", value);
      },
      highlightPrevItem({ context, prop }) {
        let value = null;
        const highlightedValue = context.get("highlightedValue");
        const collection2 = prop("collection");
        if (highlightedValue) {
          value = collection2.getPreviousValue(highlightedValue);
          if (!value && prop("loopFocus")) value = collection2.lastValue;
        } else {
          value = collection2.lastValue;
        }
        if (value) context.set("highlightedValue", value);
      },
      highlightFirstSelectedItem({ context, prop }) {
        raf(() => {
          const [value] = prop("collection").sort(context.get("value"));
          if (value) context.set("highlightedValue", value);
        });
      },
      highlightFirstOrSelectedItem({ context, prop, computed }) {
        raf(() => {
          let value = null;
          if (computed("hasSelectedItems")) {
            value = prop("collection").sort(context.get("value"))[0];
          } else {
            value = prop("collection").firstValue;
          }
          if (value) context.set("highlightedValue", value);
        });
      },
      highlightLastOrSelectedItem({ context, prop, computed }) {
        raf(() => {
          const collection2 = prop("collection");
          let value = null;
          if (computed("hasSelectedItems")) {
            value = collection2.sort(context.get("value"))[0];
          } else {
            value = collection2.lastValue;
          }
          if (value) context.set("highlightedValue", value);
        });
      },
      autofillInputValue({ context, computed, prop, event, scope }) {
        const inputEl = getInputEl(scope);
        const collection2 = prop("collection");
        if (!computed("autoComplete") || !inputEl || !event.keypress) return;
        const valueText = collection2.stringify(context.get("highlightedValue"));
        raf(() => {
          inputEl.value = valueText || context.get("inputValue");
        });
      },
      syncSelectedItems(params) {
        queueMicrotask(() => {
          const { context, prop } = params;
          const collection2 = prop("collection");
          const value = context.get("value");
          const selectedItemMap = context.get("selectedItemMap");
          const next = deriveSelectionState({ values: value, collection: collection2, selectedItemMap });
          context.set("selectedItemMap", next.nextSelectedItemMap);
          const inputValue = match(prop("selectionBehavior"), {
            preserve: context.get("inputValue"),
            replace: collection2.stringifyMany(value),
            clear: ""
          });
          context.set("inputValue", inputValue);
        });
      },
      syncHighlightedItem({ context, prop }) {
        const item = prop("collection").find(context.get("highlightedValue"));
        context.set("highlightedItem", item);
      },
      toggleVisibility({ event, send, prop }) {
        send({ type: prop("open") ? "CONTROLLED.OPEN" : "CONTROLLED.CLOSE", previousEvent: event });
      }
    }
  }
});
function getOpenChangeReason(event) {
  return (event.previousEvent || event).src;
}

// components/combobox.ts
var Combobox = class extends Component {
  options = [];
  allOptions = [];
  hasGroups = false;
  setAllOptions(options) {
    this.allOptions = options;
    this.options = options;
  }
  getCollection() {
    const items = this.options || this.allOptions || [];
    if (this.hasGroups) {
      return collection({
        items,
        itemToValue: (item) => item.id ?? "",
        itemToString: (item) => item.label,
        isItemDisabled: (item) => item.disabled ?? false,
        groupBy: (item) => item.group ?? ""
      });
    }
    return collection({
      items,
      itemToValue: (item) => item.id ?? "",
      itemToString: (item) => item.label,
      isItemDisabled: (item) => item.disabled ?? false
    });
  }
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props) {
    const getCollection = () => this.getCollection();
    return new VanillaMachine(machine, {
      ...props,
      get collection() {
        return getCollection();
      },
      onOpenChange: (details) => {
        if (details.open) {
          this.options = this.allOptions;
        }
        if (props.onOpenChange) {
          props.onOpenChange(details);
        }
      },
      onInputValueChange: (details) => {
        if (props.onInputValueChange) {
          props.onInputValueChange(details);
        }
        if (this.el.hasAttribute("data-filter")) {
          const filtered = this.allOptions.filter(
            (item) => item.label.toLowerCase().includes(details.inputValue.toLowerCase())
          );
          this.options = filtered.length > 0 ? filtered : this.allOptions;
        } else {
          this.options = this.allOptions;
        }
      }
    });
  }
  initApi() {
    return connect(this.machine.service, normalizeProps);
  }
  renderItems() {
    const contentEl = this.el.querySelector(
      '[data-scope="combobox"][data-part="content"]'
    );
    if (!contentEl) return;
    const templatesContainer = this.el.querySelector('[data-templates="combobox"]');
    if (!templatesContainer) return;
    contentEl.querySelectorAll('[data-scope="combobox"][data-part="item"]:not([data-template])').forEach((el) => el.remove());
    contentEl.querySelectorAll('[data-scope="combobox"][data-part="item-group"]:not([data-template])').forEach((el) => el.remove());
    contentEl.querySelectorAll('[data-scope="combobox"][data-part="empty"]:not([data-template])').forEach((el) => el.remove());
    const items = this.options?.length ? this.options : this.allOptions;
    if (items.length === 0) {
      const emptyTemplate = templatesContainer.querySelector(
        '[data-scope="combobox"][data-part="empty"][data-template]'
      );
      if (emptyTemplate) {
        const emptyEl = emptyTemplate.cloneNode(true);
        emptyEl.removeAttribute("data-template");
        contentEl.appendChild(emptyEl);
      }
    } else if (this.hasGroups) {
      const groups = this.api.collection.group?.() ?? [];
      this.renderGroupedItems(contentEl, templatesContainer, groups);
    } else {
      this.renderFlatItems(contentEl, templatesContainer, items);
    }
  }
  buildOrderedBlocks(items) {
    const blocks = [];
    let current = null;
    for (const item of items) {
      const groupKey = item.group ?? "";
      if (groupKey === "") {
        if (current?.type !== "default") {
          current = { type: "default", items: [] };
          blocks.push(current);
        }
        current.items.push(item);
      } else {
        if (current?.type !== "group" || current.groupId !== groupKey) {
          current = { type: "group", groupId: groupKey, items: [] };
          blocks.push(current);
        }
        current.items.push(item);
      }
    }
    return blocks;
  }
  renderGroupedItems(contentEl, templatesContainer, _groups) {
    const items = this.options?.length ? this.options : this.allOptions;
    const blocks = this.buildOrderedBlocks(items);
    for (const block of blocks) {
      const templateId = block.type === "default" ? "default" : block.groupId;
      const groupTemplate = templatesContainer.querySelector(
        `[data-scope="combobox"][data-part="item-group"][data-id="${templateId}"][data-template]`
      );
      if (!groupTemplate) continue;
      const groupEl = groupTemplate.cloneNode(true);
      groupEl.removeAttribute("data-template");
      this.spreadProps(groupEl, this.api.getItemGroupProps({ id: templateId }));
      const labelEl = groupEl.querySelector(
        '[data-scope="combobox"][data-part="item-group-label"]'
      );
      if (labelEl) {
        this.spreadProps(labelEl, this.api.getItemGroupLabelProps({ htmlFor: templateId }));
      }
      const groupContentEl = groupEl.querySelector(
        '[data-scope="combobox"][data-part="item-group-content"]'
      );
      if (!groupContentEl) continue;
      groupContentEl.innerHTML = "";
      for (const item of block.items) {
        const itemEl = this.cloneItem(templatesContainer, item);
        if (itemEl) groupContentEl.appendChild(itemEl);
      }
      contentEl.appendChild(groupEl);
    }
  }
  renderFlatItems(contentEl, templatesContainer, items) {
    for (const item of items) {
      const itemEl = this.cloneItem(templatesContainer, item);
      if (itemEl) contentEl.appendChild(itemEl);
    }
  }
  cloneItem(templatesContainer, item) {
    const value = this.api.collection.getItemValue?.(item) ?? item.id ?? "";
    const template = templatesContainer.querySelector(
      `[data-scope="combobox"][data-part="item"][data-value="${value}"][data-template]`
    );
    if (!template) return null;
    const el = template.cloneNode(true);
    el.removeAttribute("data-template");
    this.spreadProps(el, this.api.getItemProps({ item }));
    const textEl = el.querySelector('[data-scope="combobox"][data-part="item-text"]');
    if (textEl) {
      this.spreadProps(textEl, this.api.getItemTextProps({ item }));
      if (textEl.children.length === 0) {
        textEl.textContent = item.label || "";
      }
    }
    const indicatorEl = el.querySelector(
      '[data-scope="combobox"][data-part="item-indicator"]'
    );
    if (indicatorEl) {
      this.spreadProps(indicatorEl, this.api.getItemIndicatorProps({ item }));
    }
    return el;
  }
  render() {
    const root = this.el.querySelector('[data-scope="combobox"][data-part="root"]');
    if (!root) return;
    this.spreadProps(root, this.api.getRootProps());
    ["label", "control", "input", "trigger", "clear-trigger", "positioner"].forEach((part) => {
      const el = this.el.querySelector(`[data-scope="combobox"][data-part="${part}"]`);
      if (!el) return;
      const apiMethod = "get" + part.split("-").map((s) => s[0].toUpperCase() + s.slice(1)).join("") + "Props";
      this.spreadProps(el, this.api[apiMethod]());
    });
    const contentEl = this.el.querySelector(
      '[data-scope="combobox"][data-part="content"]'
    );
    if (contentEl) {
      this.spreadProps(contentEl, this.api.getContentProps());
      this.renderItems();
    }
  }
};

// hooks/combobox.ts
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
var ComboboxHook = {
  mounted() {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const allItems = JSON.parse(el.dataset.collection || "[]");
    const hasGroups = allItems.some((item) => Boolean(item.group));
    const props = {
      id: el.id,
      ...getBoolean(el, "controlled") ? { value: getStringList(el, "value") } : { defaultValue: getStringList(el, "defaultValue") },
      disabled: getBoolean(el, "disabled"),
      placeholder: getString(el, "placeholder"),
      alwaysSubmitOnEnter: getBoolean(el, "alwaysSubmitOnEnter"),
      autoFocus: getBoolean(el, "autoFocus"),
      closeOnSelect: getBoolean(el, "closeOnSelect"),
      dir: getString(el, "dir", ["ltr", "rtl"]),
      inputBehavior: getString(el, "inputBehavior", ["autohighlight", "autocomplete", "none"]),
      loopFocus: getBoolean(el, "loopFocus"),
      multiple: getBoolean(el, "multiple"),
      invalid: getBoolean(el, "invalid"),
      allowCustomValue: false,
      selectionBehavior: "replace",
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
      onOpenChange: (details) => {
        const eventName = getString(el, "onOpenChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            open: details.open,
            reason: details.reason,
            value: details.value,
            id: el.id
          });
        }
        const eventNameClient = getString(el, "onOpenChangeClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
              bubbles: getBoolean(el, "bubble"),
              detail: {
                open: details.open,
                reason: details.reason,
                value: details.value,
                id: el.id
              }
            })
          );
        }
      },
      onInputValueChange: (details) => {
        const eventName = getString(el, "onInputValueChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            value: details.inputValue,
            reason: details.reason,
            id: el.id
          });
        }
        const eventNameClient = getString(el, "onInputValueChangeClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
              bubbles: getBoolean(el, "bubble"),
              detail: {
                value: details.inputValue,
                reason: details.reason,
                id: el.id
              }
            })
          );
        }
      },
      onValueChange: (details) => {
        const hiddenInput = el.querySelector(
          '[data-scope="combobox"][data-part="input"]'
        );
        if (hiddenInput) {
          hiddenInput.dispatchEvent(new Event("change", { bubbles: true }));
        }
        const eventName = getString(el, "onValueChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            value: details.value,
            items: details.items,
            id: el.id
          });
        }
        const eventNameClient = getString(el, "onValueChangeClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
              bubbles: getBoolean(el, "bubble"),
              detail: {
                value: details.value,
                items: details.items,
                id: el.id
              }
            })
          );
        }
      }
    };
    const combobox = new Combobox(el, props);
    combobox.hasGroups = hasGroups;
    combobox.setAllOptions(allItems);
    combobox.init();
    this.combobox = combobox;
    this.handlers = [];
  },
  updated() {
    const newCollection = JSON.parse(this.el.dataset.collection || "[]");
    const hasGroups = newCollection.some((item) => Boolean(item.group));
    if (this.combobox) {
      this.combobox.hasGroups = hasGroups;
      this.combobox.setAllOptions(newCollection);
      this.combobox.render();
      this.combobox.updateProps({
        ...getBoolean(this.el, "controlled") ? { value: getStringList(this.el, "value") } : { defaultValue: getStringList(this.el, "defaultValue") },
        collection: this.combobox.getCollection(),
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
    this.combobox?.destroy();
  }
};
export {
  ComboboxHook as Combobox
};
