import {
  createLiveRegion
} from "./chunks/chunk-7BZGUIUZ.mjs";
import {
  trackInteractOutside
} from "./chunks/chunk-QS5WHZEI.mjs";
import {
  createDomEventRegistry,
  createHookHandleEventRegistry
} from "./chunks/chunk-77HPO22C.mjs";
import {
  idMatches,
  notifyChange,
  readPayloadId,
  readPayloadStringArray,
  readPayloadValue
} from "./chunks/chunk-2WCNJX5P.mjs";
import {
  Component,
  VanillaMachine,
  ariaAttr,
  canPushEvent,
  contains,
  createAnatomy,
  createGuards,
  createMachine,
  dataAttr,
  dispatchInputValueEvent,
  getBoolean,
  getBooleanValue,
  getComputedStyle,
  getDir,
  getDocument,
  getEventKey,
  getNativeEvent,
  getNumber,
  getString,
  getWindow,
  indexOfId,
  isCaretAtStart,
  isComposingEvent,
  isEqual,
  isLeftClick,
  nextById,
  prevById,
  queryAll,
  raf,
  removeAt,
  setElementValue,
  templatesContentRoot,
  trackFormControl,
  uniq,
  warn
} from "./chunks/chunk-XGGASIX4.mjs";

// ../node_modules/.pnpm/@zag-js+tags-input@1.40.0/node_modules/@zag-js/tags-input/dist/tags-input.anatomy.mjs
var anatomy = createAnatomy("tagsInput").parts(
  "root",
  "label",
  "control",
  "input",
  "clearTrigger",
  "item",
  "itemPreview",
  "itemInput",
  "itemText",
  "itemDeleteTrigger"
);
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+tags-input@1.40.0/node_modules/@zag-js/tags-input/dist/tags-input.dom.mjs
var getRootId = (ctx) => ctx.ids?.root ?? `tags-input:${ctx.id}`;
var getInputId = (ctx) => ctx.ids?.input ?? `tags-input:${ctx.id}:input`;
var getClearTriggerId = (ctx) => ctx.ids?.clearBtn ?? `tags-input:${ctx.id}:clear-btn`;
var getHiddenInputId = (ctx) => ctx.ids?.hiddenInput ?? `tags-input:${ctx.id}:hidden-input`;
var getLabelId = (ctx) => ctx.ids?.label ?? `tags-input:${ctx.id}:label`;
var getControlId = (ctx) => ctx.ids?.control ?? `tags-input:${ctx.id}:control`;
var getItemId = (ctx, opt) => ctx.ids?.item?.(opt) ?? `tags-input:${ctx.id}:tag:${opt.value}:${opt.index}`;
var getItemDeleteTriggerId = (ctx, opt) => ctx.ids?.itemDeleteTrigger?.(opt) ?? `${getItemId(ctx, opt)}:delete-btn`;
var getItemInputId = (ctx, opt) => ctx.ids?.itemInput?.(opt) ?? `${getItemId(ctx, opt)}:input`;
var getEditInputId = (id) => `${id}:input`;
var getEditInputEl = (ctx, id) => ctx.getById(getEditInputId(id));
var getItemEls = (ctx) => queryAll(getRootEl(ctx), `[data-part=item]`);
var getTagInputEl = (ctx, opt) => ctx.getById(getItemInputId(ctx, opt));
var getRootEl = (ctx) => ctx.getById(getRootId(ctx));
var getInputEl = (ctx) => ctx.getById(getInputId(ctx));
var getHiddenInputEl = (ctx) => ctx.getById(getHiddenInputId(ctx));
var getTagElements = (ctx) => queryAll(getRootEl(ctx), `[data-part=item-preview]:not([data-disabled])`);
var getFirstEl = (ctx) => getTagElements(ctx)[0];
var getLastEl = (ctx) => getTagElements(ctx)[getTagElements(ctx).length - 1];
var getPrevEl = (ctx, id) => prevById(getTagElements(ctx), id, false);
var getNextEl = (ctx, id) => nextById(getTagElements(ctx), id, false);
var getTagElAtIndex = (ctx, index) => getTagElements(ctx)[index];
var getIndexOfId = (ctx, id) => indexOfId(getTagElements(ctx), id);
var setHoverIntent = (el) => {
  const tagEl = el.closest("[data-part=item-preview]");
  if (!tagEl) return;
  tagEl.dataset.deleteIntent = "";
};
var clearHoverIntent = (el) => {
  const tagEl = el.closest("[data-part=item-preview]");
  if (!tagEl) return;
  delete tagEl.dataset.deleteIntent;
};
var dispatchInputEvent = (ctx, value) => {
  const inputEl = getHiddenInputEl(ctx);
  if (!inputEl) return;
  dispatchInputValueEvent(inputEl, { value });
};

// ../node_modules/.pnpm/@zag-js+tags-input@1.40.0/node_modules/@zag-js/tags-input/dist/tags-input.connect.mjs
function connect(service, normalize) {
  const { state, send, computed, prop, scope, context } = service;
  const interactive = computed("isInteractive");
  const disabled = !!prop("disabled");
  const readOnly = !!prop("readOnly");
  const required = !!prop("required");
  const invalid = prop("invalid") || computed("isOverflowing");
  const translations = prop("translations");
  const focused = state.hasTag("focused");
  const editingTag = state.matches("editing:tag");
  const empty = computed("count") === 0;
  function getItemState(options) {
    const id = getItemId(scope, options);
    const editedTagId = context.get("editedTagId");
    const highlightedTagId = context.get("highlightedTagId");
    return {
      id,
      editing: editingTag && editedTagId === id,
      highlighted: id === highlightedTagId,
      disabled: Boolean(options.disabled || disabled)
    };
  }
  return {
    empty,
    inputValue: context.get("inputValue"),
    value: context.get("value"),
    valueAsString: computed("valueAsString"),
    count: computed("count"),
    atMax: computed("isAtMax"),
    setValue(value) {
      send({ type: "SET_VALUE", value });
    },
    clearValue(id) {
      if (id) {
        send({ type: "CLEAR_TAG", id });
      } else {
        send({ type: "CLEAR_VALUE" });
      }
    },
    addValue(value) {
      send({ type: "ADD_TAG", value });
    },
    setValueAtIndex(index, value) {
      send({ type: "SET_VALUE_AT_INDEX", index, value });
    },
    setInputValue(value) {
      send({ type: "SET_INPUT_VALUE", value });
    },
    clearInputValue() {
      send({ type: "SET_INPUT_VALUE", value: "" });
    },
    focus() {
      getInputEl(scope)?.focus();
    },
    getItemState,
    getRootProps() {
      return normalize.element({
        dir: prop("dir"),
        ...parts.root.attrs,
        "data-invalid": dataAttr(invalid),
        "data-readonly": dataAttr(readOnly),
        "data-disabled": dataAttr(disabled),
        "data-focus": dataAttr(focused),
        "data-empty": dataAttr(empty),
        id: getRootId(scope),
        onPointerDown() {
          if (!interactive) return;
          send({ type: "POINTER_DOWN" });
        }
      });
    },
    getLabelProps() {
      return normalize.label({
        ...parts.label.attrs,
        "data-disabled": dataAttr(disabled),
        "data-invalid": dataAttr(invalid),
        "data-readonly": dataAttr(readOnly),
        "data-required": dataAttr(required),
        id: getLabelId(scope),
        dir: prop("dir"),
        htmlFor: getInputId(scope)
      });
    },
    getControlProps() {
      return normalize.element({
        id: getControlId(scope),
        ...parts.control.attrs,
        dir: prop("dir"),
        tabIndex: readOnly ? 0 : void 0,
        "data-disabled": dataAttr(disabled),
        "data-readonly": dataAttr(readOnly),
        "data-invalid": dataAttr(invalid),
        "data-focus": dataAttr(focused)
      });
    },
    getInputProps() {
      return normalize.input({
        ...parts.input.attrs,
        dir: prop("dir"),
        "data-invalid": dataAttr(invalid),
        "aria-invalid": ariaAttr(invalid),
        "data-readonly": dataAttr(readOnly),
        "data-empty": dataAttr(empty),
        maxLength: prop("maxLength"),
        id: getInputId(scope),
        defaultValue: context.get("inputValue"),
        autoComplete: "off",
        autoCorrect: "off",
        autoCapitalize: "none",
        enterKeyHint: "done",
        disabled: disabled || readOnly,
        placeholder: empty ? prop("placeholder") : void 0,
        onInput(event) {
          const evt = getNativeEvent(event);
          const value = event.currentTarget.value;
          if (evt.inputType === "insertFromPaste") {
            send({ type: "PASTE", value });
            return;
          }
          if (endsWith(value, prop("delimiter"))) {
            send({ type: "DELIMITER_KEY" });
            return;
          }
          send({ type: "TYPE", value, key: evt.inputType });
        },
        onFocus() {
          queueMicrotask(() => {
            send({ type: "FOCUS" });
          });
        },
        onKeyDown(event) {
          if (event.defaultPrevented) return;
          if (isComposingEvent(event)) return;
          const target = event.currentTarget;
          const isCombobox = target.getAttribute("role") === "combobox";
          const isExpanded = target.ariaExpanded === "true";
          const keyMap = {
            ArrowDown() {
              send({ type: "ARROW_DOWN" });
            },
            ArrowLeft() {
              if (isCombobox && isExpanded) return;
              send({ type: "ARROW_LEFT" });
            },
            ArrowRight(event2) {
              if (context.get("highlightedTagId")) {
                event2.preventDefault();
              }
              if (isCombobox && isExpanded) return;
              send({ type: "ARROW_RIGHT" });
            },
            Escape(event2) {
              event2.preventDefault();
              send({ type: "ESCAPE" });
            },
            Backspace() {
              send({ type: "BACKSPACE" });
            },
            Delete() {
              send({ type: "DELETE" });
            },
            Enter(event2) {
              const hasHighlightedItem = target.getAttribute("aria-activedescendant");
              if (isCombobox && isExpanded && hasHighlightedItem) return;
              send({ type: "ENTER" });
              event2.preventDefault();
            }
          };
          const key = getEventKey(event, { dir: prop("dir") });
          const exec = keyMap[key];
          if (exec) {
            exec(event);
            return;
          }
        }
      });
    },
    getHiddenInputProps() {
      return normalize.input({
        type: "text",
        hidden: true,
        name: prop("name"),
        form: prop("form"),
        disabled,
        readOnly,
        required: prop("required"),
        id: getHiddenInputId(scope),
        defaultValue: computed("valueAsString")
      });
    },
    getItemProps(props) {
      return normalize.element({
        ...parts.item.attrs,
        dir: prop("dir"),
        "data-value": props.value,
        "data-disabled": dataAttr(disabled)
      });
    },
    getItemPreviewProps(props) {
      const itemState = getItemState(props);
      return normalize.element({
        ...parts.itemPreview.attrs,
        id: itemState.id,
        dir: prop("dir"),
        hidden: itemState.editing,
        "data-value": props.value,
        "data-disabled": dataAttr(disabled),
        "data-highlighted": dataAttr(itemState.highlighted),
        onPointerDown(event) {
          if (!interactive || itemState.disabled) return;
          if (!isLeftClick(event)) return;
          event.preventDefault();
          send({ type: "POINTER_DOWN_TAG", id: itemState.id });
        },
        onDoubleClick() {
          if (!interactive || itemState.disabled) return;
          send({ type: "DOUBLE_CLICK_TAG", id: itemState.id });
        }
      });
    },
    getItemTextProps(props) {
      const itemState = getItemState(props);
      return normalize.element({
        ...parts.itemText.attrs,
        dir: prop("dir"),
        "data-disabled": dataAttr(disabled),
        "data-highlighted": dataAttr(itemState.highlighted)
      });
    },
    getItemInputProps(props) {
      const itemState = getItemState(props);
      return normalize.input({
        ...parts.itemInput.attrs,
        dir: prop("dir"),
        "aria-label": translations?.tagEdited?.(props.value),
        disabled,
        id: getItemInputId(scope, props),
        tabIndex: -1,
        hidden: !itemState.editing,
        maxLength: prop("maxLength"),
        defaultValue: itemState.editing ? context.get("editedTagValue") : "",
        onInput(event) {
          send({ type: "TAG_INPUT_TYPE", value: event.currentTarget.value });
        },
        onBlur(event) {
          queueMicrotask(() => {
            send({ type: "TAG_INPUT_BLUR", target: event.relatedTarget, id: itemState.id });
          });
        },
        onKeyDown(event) {
          if (event.defaultPrevented) return;
          if (isComposingEvent(event)) return;
          const keyMap = {
            Enter() {
              send({ type: "TAG_INPUT_ENTER" });
            },
            Escape() {
              send({ type: "TAG_INPUT_ESCAPE" });
            }
          };
          const exec = keyMap[event.key];
          if (exec) {
            event.preventDefault();
            exec(event);
          }
        }
      });
    },
    getItemDeleteTriggerProps(props) {
      const itemState = getItemState(props);
      return normalize.button({
        ...parts.itemDeleteTrigger.attrs,
        dir: prop("dir"),
        "data-disabled": dataAttr(itemState.disabled),
        "aria-disabled": itemState.disabled,
        "data-highlighted": dataAttr(itemState.highlighted),
        id: getItemDeleteTriggerId(scope, props),
        type: "button",
        disabled: itemState.disabled,
        "aria-label": translations?.deleteTagTriggerLabel?.(props.value),
        tabIndex: -1,
        onPointerDown(event) {
          if (!isLeftClick(event)) return;
          if (!interactive) {
            event.preventDefault();
          }
        },
        onPointerMove(event) {
          if (!interactive) return;
          setHoverIntent(event.currentTarget);
        },
        onPointerLeave(event) {
          if (!interactive) return;
          clearHoverIntent(event.currentTarget);
        },
        onClick(event) {
          if (event.defaultPrevented) return;
          if (!interactive) return;
          send({ type: "CLICK_DELETE_TAG", id: itemState.id });
        }
      });
    },
    getClearTriggerProps() {
      return normalize.button({
        ...parts.clearTrigger.attrs,
        dir: prop("dir"),
        id: getClearTriggerId(scope),
        type: "button",
        "data-readonly": dataAttr(readOnly),
        disabled,
        "aria-label": translations?.clearTriggerLabel,
        hidden: empty,
        onClick() {
          if (!interactive) return;
          send({ type: "CLEAR_VALUE" });
        }
      });
    }
  };
}
function endsWith(str, del) {
  if (!del) return false;
  if (typeof del === "string") return str.endsWith(del);
  return new RegExp(`${del.source}$`).test(str);
}

// ../node_modules/.pnpm/@zag-js+auto-resize@1.40.0/node_modules/@zag-js/auto-resize/dist/visual-style.mjs
function getVisualStyles(node) {
  if (!node) return;
  const style = getComputedStyle(node);
  return "box-sizing:" + style.boxSizing + ";border-left:" + style.borderLeftWidth + " solid red;border-right:" + style.borderRightWidth + " solid red;font-family:" + style.fontFamily + ";font-feature-settings:" + style.fontFeatureSettings + ";font-kerning:" + style.fontKerning + ";font-size:" + style.fontSize + ";font-stretch:" + style.fontStretch + ";font-style:" + style.fontStyle + ";font-variant:" + style.fontVariant + ";font-variant-caps:" + style.fontVariantCaps + ";font-variant-ligatures:" + style.fontVariantLigatures + ";font-variant-numeric:" + style.fontVariantNumeric + ";font-weight:" + style.fontWeight + ";letter-spacing:" + style.letterSpacing + ";margin-left:" + style.marginLeft + ";margin-right:" + style.marginRight + ";padding-left:" + style.paddingLeft + ";padding-right:" + style.paddingRight + ";text-indent:" + style.textIndent + ";text-transform:" + style.textTransform;
}

// ../node_modules/.pnpm/@zag-js+auto-resize@1.40.0/node_modules/@zag-js/auto-resize/dist/autoresize-input.mjs
function createGhostElement(doc) {
  const el = doc.createElement("div");
  el.id = "ghost";
  el.style.cssText = "display:inline-block;height:0;overflow:hidden;position:absolute;top:0;visibility:hidden;white-space:nowrap;";
  doc.body.appendChild(el);
  return el;
}
function autoResizeInput(input) {
  if (!input) return;
  const doc = getDocument(input);
  const win = getWindow(input);
  const ghost = createGhostElement(doc);
  const cssText = getVisualStyles(input);
  if (cssText) ghost.style.cssText += cssText;
  function resize() {
    win.requestAnimationFrame(() => {
      ghost.innerHTML = input.value;
      const rect = win.getComputedStyle(ghost);
      input?.style.setProperty("width", rect.width);
    });
  }
  resize();
  input?.addEventListener("input", resize);
  input?.addEventListener("change", resize);
  return () => {
    doc.body.removeChild(ghost);
    input?.removeEventListener("input", resize);
    input?.removeEventListener("change", resize);
  };
}

// ../node_modules/.pnpm/@zag-js+tags-input@1.40.0/node_modules/@zag-js/tags-input/dist/tags-input.machine.mjs
var { and, not, or } = createGuards();
var machine = createMachine({
  props({ props }) {
    return {
      dir: "ltr",
      addOnPaste: false,
      editable: true,
      validate: () => true,
      allowDuplicates: false,
      delimiter: ",",
      defaultValue: [],
      defaultInputValue: "",
      max: Infinity,
      sanitizeValue: (value) => value.trim(),
      ...props,
      translations: {
        clearTriggerLabel: "Clear all tags",
        deleteTagTriggerLabel: (value) => `Delete tag ${value}`,
        tagAdded: (value) => `Added tag ${value}`,
        tagsPasted: (values) => `Pasted ${values.length} tags`,
        tagEdited: (value) => `Editing tag ${value}. Press enter to save or escape to cancel.`,
        tagUpdated: (value) => `Tag update to ${value}`,
        tagDeleted: (value) => `Tag ${value} deleted`,
        tagSelected: (value) => `Tag ${value} selected. Press enter to edit, delete or backspace to remove.`,
        ...props.translations
      }
    };
  },
  initialState({ prop }) {
    return prop("autoFocus") ? "focused:input" : "idle";
  },
  refs() {
    return {
      liveRegion: null,
      log: { current: null, prev: null }
    };
  },
  context({ bindable, prop }) {
    return {
      value: bindable(() => ({
        defaultValue: prop("defaultValue"),
        value: prop("value"),
        isEqual,
        hash(value) {
          return value.join(", ");
        },
        onChange(value) {
          prop("onValueChange")?.({ value });
        }
      })),
      inputValue: bindable(() => ({
        sync: true,
        defaultValue: prop("defaultInputValue"),
        value: prop("inputValue"),
        onChange(value) {
          prop("onInputValueChange")?.({ inputValue: value });
        }
      })),
      fieldsetDisabled: bindable(() => ({ defaultValue: false })),
      editedTagValue: bindable(() => ({ defaultValue: "" })),
      editedTagId: bindable(() => ({ defaultValue: null })),
      editedTagIndex: bindable(() => ({
        defaultValue: null,
        sync: true
      })),
      highlightedTagId: bindable(() => ({
        defaultValue: null,
        sync: true,
        onChange(value) {
          prop("onHighlightChange")?.({ highlightedValue: value });
        }
      }))
    };
  },
  computed: {
    count: ({ context }) => context.get("value").length,
    valueAsString: ({ context }) => context.hash("value"),
    sanitizedInputValue: ({ context, prop }) => prop("sanitizeValue")(context.get("inputValue")),
    isDisabled: ({ prop }) => !!prop("disabled"),
    isInteractive: ({ prop }) => !(prop("readOnly") || !!prop("disabled")),
    isAtMax: ({ context, prop }) => context.get("value").length === prop("max"),
    isOverflowing: ({ context, prop }) => context.get("value").length > prop("max")
  },
  watch({ track, context, action, computed, refs }) {
    track([() => context.get("editedTagValue")], () => {
      action(["syncEditedTagInputValue"]);
    });
    track([() => context.get("inputValue")], () => {
      action(["syncInputValue"]);
    });
    track([() => context.get("highlightedTagId")], () => {
      action(["logHighlightedTag"]);
    });
    track([() => computed("isOverflowing")], () => {
      action(["invokeOnInvalid"]);
    });
    track([() => JSON.stringify(refs.get("log"))], () => {
      action(["announceLog"]);
    });
  },
  effects: ["trackLiveRegion", "trackFormControlState"],
  exit: ["clearLog"],
  on: {
    DOUBLE_CLICK_TAG: {
      // internal: true,
      guard: "isTagEditable",
      target: "editing:tag",
      actions: ["setEditedId"]
    },
    POINTER_DOWN_TAG: {
      // internal: true,
      target: "navigating:tag",
      actions: ["highlightTag", "focusInput"]
    },
    CLICK_DELETE_TAG: {
      target: "focused:input",
      actions: ["deleteTag"]
    },
    SET_INPUT_VALUE: {
      actions: ["setInputValue"]
    },
    SET_VALUE: {
      actions: ["setValue"]
    },
    CLEAR_TAG: {
      actions: ["deleteTag"]
    },
    SET_VALUE_AT_INDEX: {
      actions: ["setValueAtIndex"]
    },
    CLEAR_VALUE: {
      actions: ["clearTags", "clearInputValue", "focusInput"]
    },
    ADD_TAG: {
      actions: ["addTag"]
    },
    INSERT_TAG: {
      // (!isAtMax || allowOverflow) && !inputValueIsEmpty
      guard: and(or(not("isAtMax"), "allowOverflow"), not("isInputValueEmpty")),
      actions: ["addTag", "clearInputValue"]
    },
    EXTERNAL_BLUR: [
      { guard: "addOnBlur", actions: ["raiseInsertTagEvent"] },
      { guard: "clearOnBlur", actions: ["clearInputValue"] }
    ]
  },
  states: {
    idle: {
      on: {
        FOCUS: {
          target: "focused:input"
        },
        POINTER_DOWN: {
          guard: not("hasHighlightedTag"),
          target: "focused:input"
        }
      }
    },
    "focused:input": {
      tags: ["focused"],
      entry: ["focusInput", "clearHighlightedId"],
      effects: ["trackInteractOutside"],
      on: {
        TYPE: {
          actions: ["setInputValue"]
        },
        BLUR: [
          {
            guard: "addOnBlur",
            target: "idle",
            actions: ["raiseInsertTagEvent"]
          },
          {
            guard: "clearOnBlur",
            target: "idle",
            actions: ["clearInputValue"]
          },
          { target: "idle" }
        ],
        ENTER: {
          actions: ["raiseInsertTagEvent"]
        },
        DELIMITER_KEY: {
          actions: ["raiseInsertTagEvent"]
        },
        ARROW_LEFT: {
          guard: and("hasTags", "isCaretAtStart"),
          target: "navigating:tag",
          actions: ["highlightLastTag"]
        },
        BACKSPACE: {
          target: "navigating:tag",
          guard: and("hasTags", "isCaretAtStart"),
          actions: ["highlightLastTag"]
        },
        DELETE: {
          guard: "hasHighlightedTag",
          actions: ["deleteHighlightedTag", "highlightTagAtIndex"]
        },
        PASTE: [
          {
            guard: "addOnPaste",
            actions: ["setInputValue", "addTagFromPaste"]
          },
          {
            actions: ["setInputValue"]
          }
        ]
      }
    },
    "navigating:tag": {
      tags: ["focused"],
      effects: ["trackInteractOutside"],
      on: {
        ARROW_RIGHT: [
          {
            guard: and("hasTags", "isCaretAtStart", not("isLastTagHighlighted")),
            actions: ["highlightNextTag"]
          },
          { target: "focused:input" }
        ],
        ARROW_LEFT: [
          {
            guard: not("isCaretAtStart"),
            target: "focused:input"
          },
          {
            actions: ["highlightPrevTag"]
          }
        ],
        BLUR: {
          target: "idle",
          actions: ["clearHighlightedId"]
        },
        ENTER: {
          guard: and("isTagEditable", "hasHighlightedTag"),
          target: "editing:tag",
          actions: ["setEditedId", "focusEditedTagInput"]
        },
        ARROW_DOWN: {
          target: "focused:input"
        },
        ESCAPE: {
          target: "focused:input"
        },
        TYPE: {
          target: "focused:input",
          actions: ["setInputValue"]
        },
        BACKSPACE: [
          {
            guard: not("isCaretAtStart"),
            target: "focused:input"
          },
          {
            guard: "isFirstTagHighlighted",
            actions: ["deleteHighlightedTag", "highlightFirstTag"]
          },
          {
            guard: "hasHighlightedTag",
            actions: ["deleteHighlightedTag", "highlightPrevTag"]
          },
          {
            actions: ["highlightLastTag"]
          }
        ],
        DELETE: [
          {
            guard: not("isCaretAtStart"),
            target: "focused:input"
          },
          {
            target: "focused:input",
            actions: ["deleteHighlightedTag", "highlightTagAtIndex"]
          }
        ],
        PASTE: [
          {
            guard: "addOnPaste",
            target: "focused:input",
            actions: ["setInputValue", "addTagFromPaste"]
          },
          {
            target: "focused:input",
            actions: ["setInputValue"]
          }
        ]
      }
    },
    "editing:tag": {
      tags: ["editing", "focused"],
      entry: ["focusEditedTagInput"],
      effects: ["autoResize"],
      on: {
        TAG_INPUT_TYPE: {
          actions: ["setEditedTagValue"]
        },
        TAG_INPUT_ESCAPE: {
          target: "navigating:tag",
          actions: ["clearEditedTagValue", "focusInput", "clearEditedId", "highlightTagAtIndex"]
        },
        TAG_INPUT_BLUR: [
          {
            guard: "isInputRelatedTarget",
            target: "navigating:tag",
            actions: ["clearEditedTagValue", "clearHighlightedId", "clearEditedId"]
          },
          {
            target: "idle",
            actions: ["clearEditedTagValue", "clearHighlightedId", "clearEditedId", "raiseExternalBlurEvent"]
          }
        ],
        TAG_INPUT_ENTER: [
          {
            guard: "isEditedTagEmpty",
            target: "navigating:tag",
            actions: ["deleteHighlightedTag", "focusInput", "clearEditedId", "highlightTagAtIndex"]
          },
          {
            target: "navigating:tag",
            actions: ["submitEditedTagValue", "focusInput", "clearEditedId", "highlightTagAtIndex"]
          }
        ]
      }
    }
  },
  implementations: {
    guards: {
      isInputRelatedTarget: ({ scope, event }) => event.relatedTarget === getInputEl(scope),
      isAtMax: ({ computed }) => computed("isAtMax"),
      hasHighlightedTag: ({ context }) => context.get("highlightedTagId") != null,
      isFirstTagHighlighted: ({ context, scope }) => {
        const value = context.get("value");
        const firstItemId = getItemId(scope, { value: value[0], index: 0 });
        return firstItemId === context.get("highlightedTagId");
      },
      isEditedTagEmpty: ({ context, prop }) => prop("sanitizeValue")(context.get("editedTagValue")) === "",
      isLastTagHighlighted: ({ context, scope }) => {
        const value = context.get("value");
        const lastIndex = value.length - 1;
        const lastItemId = getItemId(scope, { value: value[lastIndex], index: lastIndex });
        return lastItemId === context.get("highlightedTagId");
      },
      isInputValueEmpty: ({ context, prop }) => prop("sanitizeValue")(context.get("inputValue")).length === 0,
      hasTags: ({ context }) => context.get("value").length > 0,
      allowOverflow: ({ prop }) => !!prop("allowOverflow"),
      autoFocus: ({ prop }) => !!prop("autoFocus"),
      addOnBlur: ({ prop }) => prop("blurBehavior") === "add",
      clearOnBlur: ({ prop }) => prop("blurBehavior") === "clear",
      addOnPaste: ({ prop }) => !!prop("addOnPaste"),
      isTagEditable: ({ prop }) => !!prop("editable"),
      isCaretAtStart: ({ scope }) => isCaretAtStart(getInputEl(scope))
    },
    effects: {
      trackInteractOutside({ scope, prop, send }) {
        return trackInteractOutside(getInputEl(scope), {
          exclude(target) {
            const itemEls = getItemEls(scope);
            return itemEls.some((el) => contains(el, target));
          },
          onFocusOutside: prop("onFocusOutside"),
          onPointerDownOutside: prop("onPointerDownOutside"),
          onInteractOutside(event) {
            prop("onInteractOutside")?.(event);
            if (event.defaultPrevented) return;
            send({ type: "BLUR", src: "interact-outside" });
          }
        });
      },
      trackFormControlState({ context, send, scope }) {
        return trackFormControl(getHiddenInputEl(scope), {
          onFieldsetDisabledChange(disabled) {
            context.set("fieldsetDisabled", disabled);
          },
          onFormReset() {
            const value = context.initial("value");
            send({ type: "SET_VALUE", value, src: "form-reset" });
          }
        });
      },
      autoResize({ context, prop, scope }) {
        let fn_cleanup;
        queueMicrotask(() => {
          const editedTagValue = context.get("editedTagValue");
          const editedTagIndex = context.get("editedTagIndex");
          if (!editedTagValue || editedTagIndex == null || !prop("editable")) return;
          const inputEl = getTagInputEl(scope, {
            value: editedTagValue,
            index: editedTagIndex
          });
          fn_cleanup = autoResizeInput(inputEl);
        });
        return () => {
          fn_cleanup?.();
        };
      },
      trackLiveRegion({ scope, refs }) {
        const liveRegion = createLiveRegion({
          level: "assertive",
          document: scope.getDoc()
        });
        refs.set("liveRegion", liveRegion);
        return () => liveRegion.destroy();
      }
    },
    actions: {
      raiseInsertTagEvent({ send }) {
        send({ type: "INSERT_TAG" });
      },
      raiseExternalBlurEvent({ send, event }) {
        send({ type: "EXTERNAL_BLUR", id: event.id });
      },
      dispatchChangeEvent({ scope, computed }) {
        dispatchInputEvent(scope, computed("valueAsString"));
      },
      highlightNextTag({ context, scope }) {
        const highlightedTagId = context.get("highlightedTagId");
        if (highlightedTagId == null) return;
        const next = getNextEl(scope, highlightedTagId);
        context.set("highlightedTagId", next?.id ?? null);
      },
      highlightFirstTag({ context, scope }) {
        raf(() => {
          const first = getFirstEl(scope);
          context.set("highlightedTagId", first?.id ?? null);
        });
      },
      highlightLastTag({ context, scope }) {
        const last = getLastEl(scope);
        context.set("highlightedTagId", last?.id ?? null);
      },
      highlightPrevTag({ context, scope }) {
        const highlightedTagId = context.get("highlightedTagId");
        if (highlightedTagId == null) return;
        const prev = getPrevEl(scope, highlightedTagId);
        context.set("highlightedTagId", prev?.id ?? null);
      },
      highlightTag({ context, event }) {
        context.set("highlightedTagId", event.id);
      },
      highlightTagAtIndex({ context, scope }) {
        raf(() => {
          const idx = context.get("editedTagIndex");
          if (idx == null) return;
          const tagEl = getTagElAtIndex(scope, idx);
          if (tagEl == null) return;
          context.set("highlightedTagId", tagEl.id);
          context.set("editedTagIndex", null);
        });
      },
      deleteTag({ context, scope, event, refs }) {
        const index = getIndexOfId(scope, event.id);
        const value = context.get("value")[index];
        const prevLog = refs.get("log");
        refs.set("log", {
          prev: prevLog.current,
          current: { type: "delete", value }
        });
        context.set("value", (prev) => removeAt(prev, index));
      },
      deleteHighlightedTag({ context, scope, refs }) {
        const highlightedTagId = context.get("highlightedTagId");
        if (highlightedTagId == null) return;
        const index = getIndexOfId(scope, highlightedTagId);
        context.set("editedTagIndex", index);
        const value = context.get("value");
        const prevLog = refs.get("log");
        refs.set("log", {
          prev: prevLog.current,
          current: { type: "delete", value: value[index] }
        });
        context.set("value", (prev) => removeAt(prev, index));
      },
      setEditedId({ context, event, scope }) {
        const highlightedTagId = context.get("highlightedTagId");
        const editedTagId = event.id ?? highlightedTagId;
        context.set("editedTagId", editedTagId);
        const index = getIndexOfId(scope, editedTagId);
        const valueAtIndex = context.get("value")[index];
        context.set("editedTagIndex", index);
        context.set("editedTagValue", valueAtIndex);
      },
      clearEditedId({ context }) {
        context.set("editedTagId", null);
      },
      clearEditedTagValue({ context }) {
        context.set("editedTagValue", "");
      },
      setEditedTagValue({ context, event }) {
        context.set("editedTagValue", event.value);
      },
      submitEditedTagValue({ context, scope, refs, prop }) {
        const editedTagId = context.get("editedTagId");
        if (!editedTagId) return;
        const index = getIndexOfId(scope, editedTagId);
        const editedTagValue = context.get("editedTagValue");
        const value = context.get("value");
        const hasDuplicate = value.some((item, idx) => idx !== index && item === editedTagValue);
        if (!prop("allowDuplicates") && hasDuplicate) return;
        if (value[index] === editedTagValue) return;
        context.set("value", (prev) => {
          const nextValue = prev.slice();
          nextValue[index] = editedTagValue;
          return nextValue;
        });
        const prevLog = refs.get("log");
        refs.set("log", {
          prev: prevLog.current,
          current: { type: "update", value: editedTagValue }
        });
      },
      setValueAtIndex({ context, event, refs, prop }) {
        if (event.value) {
          const value = context.get("value");
          const hasDuplicate = value.some((item, idx) => idx !== event.index && item === event.value);
          if (!prop("allowDuplicates") && hasDuplicate) return;
          if (value[event.index] === event.value) return;
          context.set("value", (prev) => {
            const nextValue = prev.slice();
            nextValue[event.index] = event.value;
            return nextValue;
          });
          const prevLog = refs.get("log");
          refs.set("log", {
            prev: prevLog.current,
            current: { type: "update", value: event.value }
          });
        } else {
          warn("You need to provide a value for the tag");
        }
      },
      focusEditedTagInput({ context, scope }) {
        raf(() => {
          const editedTagId = context.get("editedTagId");
          if (!editedTagId) return;
          const editTagInputEl = getEditInputEl(scope, editedTagId);
          editTagInputEl?.select();
        });
      },
      setInputValue({ context, event }) {
        context.set("inputValue", event.value);
      },
      clearHighlightedId({ context }) {
        context.set("highlightedTagId", null);
      },
      focusInput({ scope }) {
        raf(() => {
          getInputEl(scope)?.focus();
        });
      },
      clearInputValue({ context }) {
        raf(() => {
          context.set("inputValue", "");
        });
      },
      syncInputValue({ context, scope }) {
        const inputEl = getInputEl(scope);
        if (!inputEl) return;
        setElementValue(inputEl, context.get("inputValue"));
      },
      syncEditedTagInputValue({ context, event, scope }) {
        const id = context.get("editedTagId") || context.get("highlightedTagId") || event.id;
        if (id == null) return;
        const editTagInputEl = getEditInputEl(scope, id);
        if (!editTagInputEl) return;
        setElementValue(editTagInputEl, context.get("editedTagValue"));
      },
      addTag({ context, event, computed, prop, refs }) {
        const inputValue = event.value ?? computed("sanitizedInputValue");
        const value = context.get("value");
        const guard = prop("validate")?.({ inputValue, value: Array.from(value) });
        if (guard) {
          const nextValue = prop("allowDuplicates") ? value.concat(inputValue) : uniq(value.concat(inputValue));
          context.set("value", nextValue);
          const prevLog = refs.get("log");
          refs.set("log", {
            prev: prevLog.current,
            current: { type: "add", value: inputValue }
          });
        } else {
          prop("onValueInvalid")?.({ reason: "invalidTag" });
        }
      },
      addTagFromPaste({ context, computed, prop, refs }) {
        raf(() => {
          const inputValue = computed("sanitizedInputValue");
          const value = context.get("value");
          const sanitize = prop("sanitizeValue");
          const guard = prop("validate")?.({
            inputValue,
            value: Array.from(value)
          });
          if (guard) {
            const delimiter = prop("delimiter");
            const sanitizedValues = delimiter ? inputValue.split(delimiter).map(sanitize) : [inputValue];
            const nextValue = prop("allowDuplicates") ? value.concat(...sanitizedValues) : uniq(value.concat(...sanitizedValues));
            context.set("value", nextValue);
            const prevLog = refs.get("log");
            refs.set("log", {
              prev: prevLog.current,
              current: { type: "paste", values: sanitizedValues }
            });
          } else {
            prop("onValueInvalid")?.({ reason: "invalidTag" });
          }
          context.set("inputValue", "");
        });
      },
      clearTags({ context, refs }) {
        context.set("value", []);
        const prevLog = refs.get("log");
        refs.set("log", {
          prev: prevLog.current,
          current: { type: "clear" }
        });
      },
      setValue({ context, event }) {
        context.set("value", event.value);
      },
      invokeOnInvalid({ prop, computed }) {
        if (computed("isOverflowing")) {
          prop("onValueInvalid")?.({ reason: "rangeOverflow" });
        }
      },
      clearLog({ refs }) {
        const log = refs.get("log");
        log.prev = log.current = null;
      },
      logHighlightedTag({ refs, context, scope }) {
        const highlightedTagId = context.get("highlightedTagId");
        const log = refs.get("log");
        if (highlightedTagId == null || !log.current) return;
        const index = getIndexOfId(scope, highlightedTagId);
        const value = context.get("value")[index];
        const prevLog = refs.get("log");
        refs.set("log", {
          prev: prevLog.current,
          current: { type: "select", value }
        });
      },
      // queue logs with screen reader and get it announced
      announceLog({ refs, prop }) {
        const liveRegion = refs.get("liveRegion");
        const translations = prop("translations");
        const log = refs.get("log");
        if (!log.current || liveRegion == null) return;
        const region = liveRegion;
        const { current, prev } = log;
        let msg;
        switch (current.type) {
          case "add":
            msg = translations.tagAdded(current.value);
            break;
          case "delete":
            msg = translations.tagDeleted(current.value);
            break;
          case "update":
            msg = translations.tagUpdated(current.value);
            break;
          case "paste":
            msg = translations.tagsPasted(current.values);
            break;
          case "select":
            msg = translations.tagSelected(current.value);
            if (prev?.type === "delete") {
              msg = `${translations.tagDeleted(prev.value)}. ${msg}`;
            } else if (prev?.type === "update") {
              msg = `${translations.tagUpdated(prev.value)}. ${msg}`;
            }
            break;
          default:
            break;
        }
        if (msg) region.announce(msg);
      }
    }
  }
});

// components/tags-input.ts
var TAG_PLACEHOLDER = "%{tag}";
var DEFAULT_DELETE_TEMPLATE = "Delete tag %{tag}";
var DEFAULT_TAG_EDITED_TEMPLATE = "Editing tag %{tag}. Press enter to save or escape to cancel.";
function formatTagTemplate(template, tag) {
  return template.split(TAG_PLACEHOLDER).join(tag);
}
function buildZagTagsInputTranslations(m) {
  const deleteTemplate = m.deleteTagTriggerLabel ?? DEFAULT_DELETE_TEMPLATE;
  const editTemplate = m.tagEdited ?? DEFAULT_TAG_EDITED_TEMPLATE;
  return {
    deleteTagTriggerLabel: (value) => formatTagTemplate(deleteTemplate, value),
    tagEdited: (value) => formatTagTemplate(editTemplate, value)
  };
}
function resolveZagTagsInputTranslations(el) {
  const raw = el.dataset.translation;
  if (!raw) {
    return { translations: buildZagTagsInputTranslations({}) };
  }
  try {
    const m = JSON.parse(raw);
    return { translations: buildZagTagsInputTranslations(m) };
  } catch {
    return { translations: buildZagTagsInputTranslations({}) };
  }
}
function directItemElements(controlEl) {
  return Array.from(
    controlEl.querySelectorAll(':scope > [data-scope="tags-input"][data-part="item"]')
  );
}
function itemInputIsEditing(input) {
  if (!input) return false;
  return !input.hidden;
}
var TagsInput = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props) {
    return new VanillaMachine(machine, props);
  }
  initApi() {
    return this.zagConnect(connect);
  }
  spreadItemParts(itemEl, index, value) {
    this.spreadProps(itemEl, this.api.getItemProps({ index, value }));
    const previewEl = itemEl.querySelector(
      '[data-scope="tags-input"][data-part="item-preview"]'
    );
    if (previewEl) this.spreadProps(previewEl, this.api.getItemPreviewProps({ index, value }));
    const textEl = itemEl.querySelector(
      '[data-scope="tags-input"][data-part="item-text"]'
    );
    if (textEl) this.spreadProps(textEl, this.api.getItemTextProps({ index, value }));
    const delEl = itemEl.querySelector(
      '[data-scope="tags-input"][data-part="item-delete-trigger"]'
    );
    if (delEl) {
      while (delEl.childElementCount > 1) {
        delEl.removeChild(delEl.lastElementChild);
      }
      this.spreadProps(delEl, this.api.getItemDeleteTriggerProps({ index, value }));
    }
    const itemInputEl = itemEl.querySelector(
      '[data-scope="tags-input"][data-part="item-input"]'
    );
    if (itemInputEl) this.spreadProps(itemInputEl, this.api.getItemInputProps({ index, value }));
    if (textEl && !itemInputIsEditing(itemInputEl)) {
      textEl.textContent = value;
    }
  }
  renderItems() {
    const controlEl = this.el.querySelector(
      '[data-scope="tags-input"][data-part="control"]'
    );
    if (!controlEl) return;
    const mainInputEl = controlEl.querySelector(
      ':scope > [data-scope="tags-input"][data-part="input"]'
    );
    if (!mainInputEl) return;
    const templatesRoot = templatesContentRoot(this.el, "tags-input");
    if (!templatesRoot) return;
    const template = templatesRoot.querySelector(
      '[data-scope="tags-input"][data-part="item"][data-template]'
    );
    if (!template) return;
    const values = this.api.value ?? [];
    let items = directItemElements(controlEl);
    while (items.length > values.length) {
      items[items.length - 1].remove();
      items = directItemElements(controlEl);
    }
    for (let index = 0; index < values.length; index++) {
      const value = values[index];
      items = directItemElements(controlEl);
      let itemEl = items[index];
      const isItem = itemEl?.getAttribute("data-scope") === "tags-input" && itemEl?.getAttribute("data-part") === "item";
      if (!itemEl || !isItem) {
        const fresh = template.cloneNode(true);
        fresh.removeAttribute("data-template");
        const ref = items[index] ?? mainInputEl;
        controlEl.insertBefore(fresh, ref);
        items = directItemElements(controlEl);
        itemEl = items[index];
      }
      const itemInputEl = itemEl.querySelector(
        '[data-scope="tags-input"][data-part="item-input"]'
      );
      const editing = itemInputIsEditing(itemInputEl);
      if (!editing && itemEl.dataset.value !== value) {
        itemEl.dataset.value = value;
      }
      this.spreadItemParts(itemEl, index, value);
    }
  }
  render() {
    const rootEl = this.el.querySelector(
      '[data-scope="tags-input"][data-part="root"]'
    );
    if (!rootEl) return;
    this.spreadProps(rootEl, this.api.getRootProps());
    const labelEl = this.el.querySelector(
      '[data-scope="tags-input"][data-part="label"]'
    );
    if (labelEl) this.spreadProps(labelEl, this.api.getLabelProps());
    const controlEl = this.el.querySelector(
      '[data-scope="tags-input"][data-part="control"]'
    );
    if (controlEl) this.spreadProps(controlEl, this.api.getControlProps());
    this.renderItems();
    const inputEl = this.el.querySelector(
      '[data-scope="tags-input"][data-part="input"]'
    );
    if (inputEl) this.spreadProps(inputEl, this.api.getInputProps());
    const valueInput = this.el.querySelector(
      '[data-scope="tags-input"][data-part="value-input"]'
    );
    if (valueInput) {
      const rawDelim = this.el.dataset.delimiter;
      const delim = rawDelim !== void 0 && rawDelim !== "" ? rawDelim : ",";
      const v = (this.api.value ?? []).join(delim);
      if (valueInput.value !== v) {
        valueInput.value = v;
        valueInput.dispatchEvent(new Event("input", { bubbles: true }));
        valueInput.dispatchEvent(new Event("change", { bubbles: true }));
      }
    }
    const hiddenEl = this.el.querySelector(
      '[data-scope="tags-input"][data-part="hidden-input"]'
    );
    if (hiddenEl) {
      this.spreadProps(hiddenEl, this.api.getHiddenInputProps());
      hiddenEl.removeAttribute("name");
      hiddenEl.removeAttribute("form");
    }
  }
};

// hooks/tags-input.ts
function parseJsonTags(el, key) {
  const raw = el.dataset[key];
  if (!raw || raw.trim() === "") return [];
  try {
    const v = JSON.parse(raw);
    return Array.isArray(v) && v.every((x) => typeof x === "string") ? v : [];
  } catch {
    return [];
  }
}
function blurBehavior(el) {
  return getString(el, "blurBehavior", ["add", "clear"]);
}
function maxProp(el) {
  const n = getNumber(el, "max");
  if (n === void 0) return void 0;
  if (!Number.isFinite(n) || n <= 0) return void 0;
  return n;
}
function readPlaceholderFromMainInput(hookEl) {
  const input = hookEl.querySelector(
    '[data-scope="tags-input"][data-part="input"]'
  );
  const v = input?.getAttribute("placeholder");
  return typeof v === "string" && v !== "" ? v : void 0;
}
var TagsInputHook = {
  mounted() {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
    const controlled = getBoolean(el, "controlled");
    const blur = blurBehavior(el);
    const max = maxProp(el);
    const delimiter = getString(el, "delimiter");
    const placeholder = readPlaceholderFromMainInput(el);
    const zag = new TagsInput(el, {
      id: el.id,
      ...resolveZagTagsInputTranslations(el),
      ...controlled ? { value: parseJsonTags(el, "tags") } : { defaultValue: parseJsonTags(el, "defaultTags") },
      disabled: getBoolean(el, "disabled"),
      readOnly: getBoolean(el, "readonly"),
      invalid: getBoolean(el, "invalid"),
      required: getBoolean(el, "required"),
      name: getString(el, "name"),
      form: getString(el, "form"),
      dir: getDir(el),
      addOnPaste: getBoolean(el, "addOnPaste"),
      allowDuplicates: getBoolean(el, "allowDuplicates"),
      allowOverflow: getBoolean(el, "allowOverflow"),
      ...getBooleanValue(el, "editable") === void 0 ? {} : { editable: getBooleanValue(el, "editable") === true },
      autoFocus: getBoolean(el, "autoFocus"),
      ...blur !== void 0 ? { blurBehavior: blur } : {},
      ...max !== void 0 ? { max } : {},
      ...delimiter !== void 0 && delimiter !== "" ? { delimiter } : {},
      ...placeholder !== void 0 ? { placeholder } : {},
      onValueChange: (details) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: { id: el.id, value: details.value },
          serverEventName: getString(el, "onValueChange"),
          clientEventName: getString(el, "onValueChangeClient")
        });
      },
      onInputValueChange: (details) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: { id: el.id, inputValue: details.inputValue },
          serverEventName: getString(el, "onInputValueChange"),
          clientEventName: getString(el, "onInputValueChangeClient")
        });
      },
      onHighlightChange: (details) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: { id: el.id, highlightedValue: details.highlightedValue },
          serverEventName: getString(el, "onHighlightChange"),
          clientEventName: getString(el, "onHighlightChangeClient")
        });
      },
      onValueInvalid: (details) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: { id: el.id, reason: details.reason },
          serverEventName: getString(el, "onValueInvalid"),
          clientEventName: getString(el, "onValueInvalidClient")
        });
      }
    });
    zag.init();
    this.tagsInput = zag;
    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;
    domRegistry.add("corex:tags-input:set-value", (event) => {
      const v = event.detail?.value;
      if (Array.isArray(v) && v.every((x) => typeof x === "string"))
        zag.api.setValue(v);
    });
    domRegistry.add("corex:tags-input:clear-value", () => {
      zag.api.clearValue();
    });
    domRegistry.add("corex:tags-input:add-value", (event) => {
      const tag = event.detail?.value;
      if (typeof tag === "string" && tag !== "") zag.api.addValue(tag);
    });
    domRegistry.add("corex:tags-input:remove-value", (event) => {
      const tag = event.detail?.value;
      if (typeof tag !== "string" || tag === "") return;
      zag.api.setValue(zag.api.value.filter((t) => t !== tag));
    });
    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;
    registry.add("tags_input_set_value", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      const v = readPayloadStringArray(payload);
      if (v) zag.api.setValue(v);
    });
    registry.add("tags_input_clear_value", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.clearValue();
    });
    registry.add("tags_input_add_value", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      const tag = readPayloadValue(payload);
      if (tag !== "") zag.api.addValue(tag);
    });
    registry.add("tags_input_remove_value", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      const tag = readPayloadValue(payload);
      if (tag === "") return;
      zag.api.setValue(zag.api.value.filter((t) => t !== tag));
    });
  },
  updated() {
    const el = this.el;
    const controlled = getBoolean(el, "controlled");
    const blur = blurBehavior(el);
    const max = maxProp(el);
    const delimiter = getString(el, "delimiter");
    const placeholder = readPlaceholderFromMainInput(el);
    this.tagsInput?.updateProps({
      id: el.id,
      ...resolveZagTagsInputTranslations(el),
      ...controlled ? { value: parseJsonTags(el, "tags") } : {},
      disabled: getBoolean(el, "disabled"),
      readOnly: getBoolean(el, "readonly"),
      invalid: getBoolean(el, "invalid"),
      required: getBoolean(el, "required"),
      name: getString(el, "name"),
      form: getString(el, "form"),
      dir: getDir(el),
      addOnPaste: getBoolean(el, "addOnPaste"),
      allowDuplicates: getBoolean(el, "allowDuplicates"),
      allowOverflow: getBoolean(el, "allowOverflow"),
      ...getBooleanValue(el, "editable") === void 0 ? {} : { editable: getBooleanValue(el, "editable") === true },
      autoFocus: getBoolean(el, "autoFocus"),
      ...blur !== void 0 ? { blurBehavior: blur } : {},
      ...max !== void 0 ? { max } : {},
      ...delimiter !== void 0 && delimiter !== "" ? { delimiter } : {},
      ...placeholder !== void 0 ? { placeholder } : {}
    });
    this.tagsInput?.render();
  },
  destroyed() {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.tagsInput?.destroy();
  }
};
export {
  TagsInputHook as TagsInput,
  blurBehavior,
  maxProp,
  parseJsonTags,
  readPlaceholderFromMainInput
};
