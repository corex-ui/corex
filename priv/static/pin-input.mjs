import {
  setValueAtIndex
} from "./chunks/chunk-PE34YET2.mjs";
import {
  createDomEventRegistry,
  createHookHandleEventRegistry
} from "./chunks/chunk-77HPO22C.mjs";
import {
  emitResponse,
  idMatches,
  notifyChange,
  parseRespondTo,
  readPayloadId
} from "./chunks/chunk-UGQ3K46R.mjs";
import {
  Component,
  VanillaMachine,
  ariaAttr,
  canPushEvent,
  createAnatomy,
  dataAttr,
  dispatchInputValueEvent,
  getBeforeInputValue,
  getBoolean,
  getDir,
  getEventKey,
  getNativeEvent,
  getNumber,
  getString,
  invariant,
  isComposingEvent,
  isEqual,
  isHTMLElement,
  isModifierKey,
  queryAll,
  raf,
  setup,
  visuallyHiddenStyle
} from "./chunks/chunk-OVJ3SUQN.mjs";

// ../node_modules/.pnpm/@zag-js+pin-input@1.40.0/node_modules/@zag-js/pin-input/dist/pin-input.anatomy.mjs
var anatomy = createAnatomy("pinInput").parts("root", "label", "input", "control");
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+pin-input@1.40.0/node_modules/@zag-js/pin-input/dist/pin-input.dom.mjs
var getRootId = (ctx) => ctx.ids?.root ?? `pin-input:${ctx.id}`;
var getInputId = (ctx, id) => ctx.ids?.input?.(id) ?? `pin-input:${ctx.id}:${id}`;
var getHiddenInputId = (ctx) => ctx.ids?.hiddenInput ?? `pin-input:${ctx.id}:hidden`;
var getLabelId = (ctx) => ctx.ids?.label ?? `pin-input:${ctx.id}:label`;
var getControlId = (ctx) => ctx.ids?.control ?? `pin-input:${ctx.id}:control`;
var getRootEl = (ctx) => ctx.getById(getRootId(ctx));
var getInputEls = (ctx) => {
  const ownerId = CSS.escape(getRootId(ctx));
  const selector = `input[data-ownedby=${ownerId}]`;
  return queryAll(getRootEl(ctx), selector);
};
var getInputElAtIndex = (ctx, index) => getInputEls(ctx)[index];
var getFirstInputEl = (ctx) => getInputEls(ctx)[0];
var getHiddenInputEl = (ctx) => ctx.getById(getHiddenInputId(ctx));
var setInputValue = (inputEl, value) => {
  inputEl.value = value;
  inputEl.setAttribute("value", value);
};

// ../node_modules/.pnpm/@zag-js+pin-input@1.40.0/node_modules/@zag-js/pin-input/dist/pin-input.utils.mjs
var REGEX = {
  numeric: /^[0-9]+$/,
  alphabetic: /^[A-Za-z]+$/,
  alphanumeric: /^[a-zA-Z0-9]+$/i
};
function isValidType(type, value) {
  if (!type) return true;
  return !!REGEX[type]?.test(value);
}
function isValidValue(value, type, pattern) {
  if (!pattern) return isValidType(type, value);
  const regex = new RegExp(pattern, "g");
  return regex.test(value);
}

// ../node_modules/.pnpm/@zag-js+pin-input@1.40.0/node_modules/@zag-js/pin-input/dist/pin-input.connect.mjs
function connect(service, normalize) {
  const { send, context, computed, prop, scope } = service;
  const complete = computed("isValueComplete");
  const disabled = !!prop("disabled");
  const readOnly = !!prop("readOnly");
  const invalid = !!prop("invalid");
  const required = !!prop("required");
  const translations = prop("translations");
  const focusedIndex = context.get("focusedIndex");
  function focus() {
    getFirstInputEl(scope)?.focus();
  }
  return {
    focus,
    count: context.get("count"),
    items: Array.from({ length: context.get("count") }).map((_, i) => i),
    value: context.get("value"),
    valueAsString: computed("valueAsString"),
    complete,
    setValue(value) {
      if (!Array.isArray(value)) {
        invariant("[pin-input/setValue] value must be an array");
      }
      send({ type: "VALUE.SET", value });
    },
    clearValue() {
      send({ type: "VALUE.CLEAR" });
    },
    setValueAtIndex(index, value) {
      send({ type: "VALUE.SET", value, index });
    },
    getRootProps() {
      return normalize.element({
        dir: prop("dir"),
        ...parts.root.attrs,
        id: getRootId(scope),
        "data-invalid": dataAttr(invalid),
        "data-disabled": dataAttr(disabled),
        "data-complete": dataAttr(complete),
        "data-readonly": dataAttr(readOnly)
      });
    },
    getLabelProps() {
      return normalize.label({
        ...parts.label.attrs,
        dir: prop("dir"),
        htmlFor: getHiddenInputId(scope),
        id: getLabelId(scope),
        "data-invalid": dataAttr(invalid),
        "data-disabled": dataAttr(disabled),
        "data-complete": dataAttr(complete),
        "data-required": dataAttr(required),
        "data-readonly": dataAttr(readOnly),
        onClick(event) {
          event.preventDefault();
          focus();
        }
      });
    },
    getHiddenInputProps() {
      return normalize.input({
        "aria-hidden": true,
        type: "text",
        tabIndex: -1,
        id: getHiddenInputId(scope),
        readOnly,
        disabled,
        required,
        name: prop("name"),
        form: prop("form"),
        style: visuallyHiddenStyle,
        maxLength: computed("valueLength"),
        defaultValue: computed("valueAsString")
      });
    },
    getControlProps() {
      return normalize.element({
        ...parts.control.attrs,
        dir: prop("dir"),
        id: getControlId(scope)
      });
    },
    getInputProps(props) {
      const { index } = props;
      const inputType = prop("type") === "numeric" ? "tel" : "text";
      const valueLength = computed("valueLength");
      const tabbableIndex = focusedIndex !== -1 ? focusedIndex : Math.min(computed("filledValueLength"), valueLength - 1);
      return normalize.input({
        ...parts.input.attrs,
        dir: prop("dir"),
        disabled,
        tabIndex: index === tabbableIndex ? 0 : -1,
        "data-disabled": dataAttr(disabled),
        "data-complete": dataAttr(complete),
        "data-filled": dataAttr(context.get("value")[index] !== ""),
        id: getInputId(scope, index.toString()),
        "data-index": index,
        "data-ownedby": getRootId(scope),
        "aria-label": translations?.inputLabel?.(index, computed("valueLength")),
        inputMode: prop("otp") || prop("type") === "numeric" ? "numeric" : "text",
        "aria-invalid": ariaAttr(invalid),
        "data-invalid": dataAttr(invalid),
        enterKeyHint: index === valueLength - 1 ? "done" : "next",
        type: prop("mask") ? "password" : inputType,
        defaultValue: context.get("value")[index] || "",
        readOnly,
        autoCapitalize: "none",
        autoComplete: prop("otp") ? "one-time-code" : "off",
        placeholder: focusedIndex === index ? "" : prop("placeholder"),
        onPaste(event) {
          let pastedValue = event.clipboardData?.getData("text/plain");
          if (!pastedValue) return;
          const transformer = prop("sanitizeValue");
          if (transformer) pastedValue = transformer(pastedValue);
          const isValid = isValidValue(pastedValue, prop("type"), prop("pattern"));
          if (!isValid) {
            send({ type: "VALUE.INVALID", value: pastedValue });
            event.preventDefault();
            return;
          }
          event.preventDefault();
          send({ type: "INPUT.PASTE", value: pastedValue });
        },
        onBeforeInput(event) {
          try {
            const value = getBeforeInputValue(event);
            const isValid = isValidValue(value, prop("type"), prop("pattern"));
            if (!isValid) {
              send({ type: "VALUE.INVALID", value });
              event.preventDefault();
            }
            if (value.length > 1) {
              event.currentTarget.setSelectionRange(0, 1, "forward");
            }
          } catch {
          }
        },
        onChange(event) {
          const evt = getNativeEvent(event);
          const { value } = event.currentTarget;
          if (evt.inputType === "insertFromPaste") {
            event.currentTarget.value = value[0] || "";
            return;
          }
          if (value.length > 2) {
            send({ type: "INPUT.PASTE", value });
            event.currentTarget.value = value[0];
            event.preventDefault();
            return;
          }
          if (evt.inputType === "deleteContentBackward") {
            send({ type: "INPUT.BACKSPACE" });
            return;
          }
          if (evt.inputType === "deleteByCut") {
            send({ type: "INPUT.DELETE" });
            return;
          }
          if (value === computed("focusedValue")) return;
          send({ type: "INPUT.CHANGE", value, index });
        },
        onKeyDown(event) {
          if (event.defaultPrevented) return;
          if (isComposingEvent(event)) return;
          if (isModifierKey(event)) return;
          if (event.key.length === 1 && computed("focusedValue") === event.key) {
            event.preventDefault();
            send({ type: "INPUT.ADVANCE" });
            return;
          }
          const keyMap = {
            Backspace() {
              send({ type: "INPUT.BACKSPACE" });
            },
            Delete() {
              send({ type: "INPUT.DELETE" });
            },
            ArrowLeft() {
              send({ type: "INPUT.ARROW_LEFT" });
            },
            ArrowRight() {
              send({ type: "INPUT.ARROW_RIGHT" });
            },
            Enter() {
              send({ type: "INPUT.ENTER" });
            },
            Home() {
              send({ type: "INPUT.HOME" });
            },
            End() {
              send({ type: "INPUT.END" });
            }
          };
          const exec = keyMap[getEventKey(event, {
            dir: prop("dir"),
            orientation: "horizontal"
          })];
          if (exec) {
            exec(event);
            event.preventDefault();
          }
        },
        onFocus() {
          send({ type: "INPUT.FOCUS", index });
        },
        onBlur(event) {
          const target = event.relatedTarget;
          if (isHTMLElement(target) && target.dataset.ownedby === getRootId(scope)) return;
          send({ type: "INPUT.BLUR", index });
        }
      });
    }
  };
}

// ../node_modules/.pnpm/@zag-js+pin-input@1.40.0/node_modules/@zag-js/pin-input/dist/pin-input.machine.mjs
var { choose, createMachine } = setup();
var machine = createMachine({
  props({ props }) {
    return {
      placeholder: "\u25CB",
      otp: false,
      type: "numeric",
      defaultValue: props.count ? fill([], props.count) : [],
      ...props,
      translations: {
        inputLabel: (index, length) => `pin code ${index + 1} of ${length}`,
        ...props.translations
      }
    };
  },
  initialState() {
    return "idle";
  },
  context({ prop, bindable }) {
    return {
      value: bindable(() => ({
        value: prop("value"),
        defaultValue: prop("defaultValue"),
        isEqual,
        onChange(value) {
          prop("onValueChange")?.({ value, valueAsString: value.join("") });
        }
      })),
      focusedIndex: bindable(() => ({
        sync: true,
        defaultValue: -1
      })),
      // TODO: Move this to `props` in next major version
      count: bindable(() => ({
        defaultValue: prop("count")
      }))
    };
  },
  computed: {
    _value: ({ context }) => fill(context.get("value"), context.get("count")),
    valueLength: ({ computed }) => computed("_value").length,
    filledValueLength: ({ computed }) => computed("_value").filter((v) => v?.trim() !== "").length,
    isValueComplete: ({ computed }) => computed("valueLength") === computed("filledValueLength"),
    valueAsString: ({ computed }) => computed("_value").join(""),
    focusedValue: ({ computed, context }) => computed("_value")[context.get("focusedIndex")] || ""
  },
  entry: choose([
    {
      guard: "autoFocus",
      actions: ["setInputCount", "setFocusIndexToFirst"]
    },
    { actions: ["setInputCount"] }
  ]),
  watch({ action, track, context, computed }) {
    track([() => context.get("focusedIndex")], () => {
      action(["focusInput", "selectInputIfNeeded"]);
    });
    track([() => context.get("value").join(",")], () => {
      action(["syncInputElements", "dispatchInputEvent"]);
    });
    track([() => computed("isValueComplete")], () => {
      action(["invokeOnComplete", "blurFocusedInputIfNeeded", "autoSubmitIfNeeded"]);
    });
  },
  on: {
    "VALUE.SET": [
      {
        guard: "hasIndex",
        actions: ["setValueAtIndex"]
      },
      { actions: ["setValue"] }
    ],
    "VALUE.CLEAR": {
      actions: ["clearValue", "setFocusIndexToFirst"]
    }
  },
  states: {
    idle: {
      on: {
        "INPUT.FOCUS": {
          target: "focused",
          actions: ["setFocusedIndex"]
        }
      }
    },
    focused: {
      on: {
        "INPUT.CHANGE": {
          actions: ["setFocusedValue", "syncInputValue", "advanceFocusedIndex"]
        },
        "INPUT.ADVANCE": {
          actions: ["advanceFocusedIndex"]
        },
        "INPUT.PASTE": {
          actions: ["setPastedValue", "setLastValueFocusIndex"]
        },
        "INPUT.FOCUS": {
          actions: ["setFocusedIndex", "focusInput"]
        },
        "INPUT.BLUR": {
          target: "idle",
          actions: ["clearFocusedIndex"]
        },
        "INPUT.DELETE": {
          guard: "hasValue",
          actions: ["clearFocusedValue"]
        },
        "INPUT.ARROW_LEFT": {
          actions: ["setPrevFocusedIndex"]
        },
        "INPUT.ARROW_RIGHT": {
          actions: ["setNextFocusedIndex"]
        },
        "INPUT.HOME": {
          actions: ["setFocusIndexToFirst"]
        },
        "INPUT.END": {
          actions: ["setFocusIndexToLast"]
        },
        "INPUT.BACKSPACE": [
          {
            guard: "hasValue",
            actions: ["clearFocusedValue", "setPrevFocusedIndex"]
          },
          {
            actions: ["setPrevFocusedIndex", "clearFocusedValue"]
          }
        ],
        "INPUT.ENTER": {
          guard: "isValueComplete",
          actions: ["requestFormSubmit"]
        },
        "VALUE.INVALID": {
          actions: ["invokeOnInvalid"]
        }
      }
    }
  },
  implementations: {
    guards: {
      autoFocus: ({ prop }) => !!prop("autoFocus"),
      hasValue: ({ context }) => context.get("value")[context.get("focusedIndex")] !== "",
      isValueComplete: ({ computed }) => computed("isValueComplete"),
      hasIndex: ({ event }) => event.index !== void 0
    },
    actions: {
      dispatchInputEvent({ computed, scope }) {
        const inputEl = getHiddenInputEl(scope);
        dispatchInputValueEvent(inputEl, { value: computed("valueAsString") });
      },
      setInputCount({ scope, context, prop }) {
        if (prop("count")) return;
        const inputEls = getInputEls(scope);
        context.set("count", inputEls.length);
      },
      focusInput({ context, scope }) {
        const focusedIndex = context.get("focusedIndex");
        if (focusedIndex === -1) return;
        queueMicrotask(() => {
          getInputElAtIndex(scope, focusedIndex)?.focus({ preventScroll: true });
        });
      },
      selectInputIfNeeded({ context, prop, scope }) {
        const focusedIndex = context.get("focusedIndex");
        if (!prop("selectOnFocus") || focusedIndex === -1) return;
        raf(() => {
          getInputElAtIndex(scope, focusedIndex)?.select();
        });
      },
      invokeOnComplete({ computed, prop }) {
        if (!computed("isValueComplete")) return;
        prop("onValueComplete")?.({
          value: computed("_value"),
          valueAsString: computed("valueAsString")
        });
      },
      invokeOnInvalid({ context, event, prop }) {
        prop("onValueInvalid")?.({
          value: event.value,
          index: context.get("focusedIndex")
        });
      },
      clearFocusedIndex({ context }) {
        context.set("focusedIndex", -1);
      },
      setFocusedIndex({ context, event, computed }) {
        const maxIndex = Math.min(computed("filledValueLength"), computed("valueLength") - 1);
        context.set("focusedIndex", Math.min(event.index, maxIndex));
      },
      setValue({ context, event }) {
        const value = fill(event.value, context.get("count"));
        context.set("value", value);
      },
      setFocusedValue({ context, event, computed, flush }) {
        const focusedValue = computed("focusedValue");
        const focusedIndex = context.get("focusedIndex");
        const value = getNextValue(focusedValue, event.value);
        flush(() => {
          context.set("value", setValueAtIndex(computed("_value"), focusedIndex, value));
        });
      },
      revertInputValue({ context, computed, scope }) {
        const inputEl = getInputElAtIndex(scope, context.get("focusedIndex"));
        setInputValue(inputEl, computed("focusedValue"));
      },
      syncInputValue({ context, event, scope }) {
        const value = context.get("value");
        const inputEl = getInputElAtIndex(scope, event.index);
        setInputValue(inputEl, value[event.index]);
      },
      syncInputElements({ context, scope }) {
        const inputEls = getInputEls(scope);
        const value = context.get("value");
        inputEls.forEach((inputEl, index) => {
          setInputValue(inputEl, value[index]);
        });
      },
      setPastedValue({ context, event, computed, flush }) {
        raf(() => {
          const valueAsString = computed("valueAsString");
          const focusedIndex = context.get("focusedIndex");
          const valueLength = computed("valueLength");
          const filledValueLength = computed("filledValueLength");
          const startIndex = Math.min(focusedIndex, filledValueLength);
          const left = startIndex > 0 ? valueAsString.substring(0, focusedIndex) : "";
          const right = event.value.substring(0, valueLength - startIndex);
          const value = fill(`${left}${right}`.split(""), valueLength);
          flush(() => {
            context.set("value", value);
          });
        });
      },
      setValueAtIndex({ context, event, computed }) {
        const nextValue = getNextValue(computed("focusedValue"), event.value);
        context.set("value", setValueAtIndex(computed("_value"), event.index, nextValue));
      },
      clearValue({ context }) {
        const nextValue = Array.from({ length: context.get("count") }).fill("");
        queueMicrotask(() => {
          context.set("value", nextValue);
        });
      },
      clearFocusedValue({ context, computed }) {
        const focusedIndex = context.get("focusedIndex");
        if (focusedIndex === -1) return;
        const value = [...computed("_value")];
        value.splice(focusedIndex, 1);
        value.push("");
        context.set("value", value);
      },
      setFocusIndexToFirst({ context }) {
        context.set("focusedIndex", 0);
      },
      setFocusIndexToLast({ context, computed }) {
        context.set("focusedIndex", Math.max(computed("filledValueLength") - 1, 0));
      },
      advanceFocusedIndex({ context, computed }) {
        context.set("focusedIndex", Math.min(context.get("focusedIndex") + 1, computed("valueLength") - 1));
      },
      setNextFocusedIndex({ context, computed }) {
        const nextIndex = context.get("focusedIndex") + 1;
        const maxIndex = Math.min(computed("filledValueLength"), computed("valueLength") - 1);
        context.set("focusedIndex", Math.min(nextIndex, maxIndex));
      },
      setPrevFocusedIndex({ context }) {
        context.set("focusedIndex", Math.max(context.get("focusedIndex") - 1, 0));
      },
      setLastValueFocusIndex({ context, computed }) {
        raf(() => {
          context.set("focusedIndex", Math.min(computed("filledValueLength"), computed("valueLength") - 1));
        });
      },
      blurFocusedInputIfNeeded({ context, computed, prop, scope }) {
        if (!prop("blurOnComplete") || !computed("isValueComplete")) return;
        raf(() => {
          getInputElAtIndex(scope, context.get("focusedIndex"))?.blur();
        });
      },
      requestFormSubmit({ computed, prop, scope }) {
        if (!prop("name") || !computed("isValueComplete")) return;
        const inputEl = getHiddenInputEl(scope);
        inputEl?.form?.requestSubmit();
      },
      autoSubmitIfNeeded({ computed, prop, scope }) {
        if (!prop("autoSubmit") || !computed("isValueComplete")) return;
        const inputEl = getHiddenInputEl(scope);
        inputEl?.form?.requestSubmit();
      }
    }
  }
});
function getNextValue(current, next) {
  let nextValue = next;
  if (current[0] === next[0]) {
    nextValue = next[1];
  } else if (current[0] === next[1]) {
    nextValue = next[0];
  }
  const chars = nextValue.split("");
  nextValue = chars[chars.length - 1];
  return nextValue ?? "";
}
function fill(value, count) {
  return Array.from({ length: count }).fill("").map((v, i) => value[i] || v);
}

// components/pin-input.ts
var PinInput = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props) {
    return new VanillaMachine(machine, props);
  }
  initApi() {
    return this.zagConnect(connect);
  }
  render() {
    const rootEl = this.el.querySelector('[data-scope="pin-input"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());
    const labelEl = this.el.querySelector(
      '[data-scope="pin-input"][data-part="label"]'
    );
    if (labelEl) this.spreadProps(labelEl, this.api.getLabelProps());
    const hiddenInputEl = this.el.querySelector(
      '[data-scope="pin-input"][data-part="hidden-input"]'
    );
    if (hiddenInputEl) this.spreadProps(hiddenInputEl, this.api.getHiddenInputProps());
    const controlEl = this.el.querySelector(
      '[data-scope="pin-input"][data-part="control"]'
    );
    if (controlEl) this.spreadProps(controlEl, this.api.getControlProps());
    this.api.items.forEach((i) => {
      const inputEl = this.el.querySelector(
        `[data-scope="pin-input"][data-part="input"][data-index="${i}"]`
      );
      if (inputEl) this.spreadProps(inputEl, this.api.getInputProps({ index: i }));
    });
  }
};

// hooks/pin-input.ts
function parseValueWithEmpties(raw) {
  return raw.split(",").map((v) => v.trim());
}
function padToCount(arr, count) {
  const copy = [...arr];
  while (copy.length < count) copy.push("");
  return copy.slice(0, count);
}
function readDefaultValueList(el, count) {
  const raw = el.dataset.defaultValue;
  if (raw === void 0 || raw === "") {
    return [];
  }
  return padToCount(parseValueWithEmpties(raw), count);
}
function buildMachineProps(el, pushEvent, canPush) {
  const count = getNumber(el, "count");
  return {
    id: el.id,
    count,
    defaultValue: readDefaultValueList(el, count ?? 0),
    disabled: getBoolean(el, "disabled"),
    invalid: getBoolean(el, "invalid"),
    required: getBoolean(el, "required"),
    readOnly: getBoolean(el, "readOnly"),
    mask: getBoolean(el, "mask"),
    otp: getBoolean(el, "otp"),
    blurOnComplete: getBoolean(el, "blurOnComplete"),
    selectOnFocus: getBoolean(el, "selectOnFocus"),
    name: getString(el, "name"),
    form: getString(el, "form"),
    dir: getDir(el),
    type: getString(el, "type"),
    placeholder: getString(el, "placeholder"),
    onValueChange: (details) => {
      const hiddenInput = el.querySelector(
        '[data-scope="pin-input"][data-part="hidden-input"]'
      );
      if (hiddenInput) {
        hiddenInput.value = details.valueAsString;
        hiddenInput.dispatchEvent(new Event("input", { bubbles: true }));
        hiddenInput.dispatchEvent(new Event("change", { bubbles: true }));
      }
      notifyChange({
        el,
        canPushServer: canPush(),
        pushEvent,
        payload: {
          id: el.id,
          value: details.value,
          valueAsString: details.valueAsString
        },
        serverEventName: getString(el, "onValueChange"),
        clientEventName: getString(el, "onValueChangeClient")
      });
    },
    onValueComplete: (details) => {
      notifyChange({
        el,
        canPushServer: canPush(),
        pushEvent,
        payload: {
          id: el.id,
          value: details.value,
          valueAsString: details.valueAsString
        },
        serverEventName: getString(el, "onValueComplete"),
        clientEventName: getString(el, "onValueCompleteClient")
      });
    }
  };
}
var PinInputHook = {
  mounted() {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
    const zag = new PinInput(el, buildMachineProps(el, pushEvent, canPush));
    zag.init();
    this.pinInput = zag;
    const emitValue = (respondTo) => {
      const api = zag.api;
      const value = api.value;
      const valueAsString = api.valueAsString;
      emitResponse({
        respondTo,
        canPushServer: canPush(),
        pushEvent,
        serverEventName: "pin_input_value_response",
        serverPayload: { id: el.id, value, valueAsString },
        el,
        domEventName: "pin-input-value",
        domDetail: { id: el.id, value, valueAsString }
      });
    };
    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;
    domRegistry.add("corex:pin-input:set-value", (event) => {
      const v = event.detail?.value;
      if (Array.isArray(v)) zag.api.setValue(v);
    });
    domRegistry.add("corex:pin-input:clear", () => {
      zag.api.clearValue();
    });
    domRegistry.add("corex:pin-input:value", (event) => {
      emitValue(parseRespondTo(event.detail));
    });
    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;
    registry.add("pin_input_set_value", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (Array.isArray(payload.value)) zag.api.setValue(payload.value);
    });
    registry.add("pin_input_clear", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.clearValue();
    });
    registry.add("pin_input_value", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitValue(parseRespondTo(payload));
    });
  },
  updated() {
    const el = this.el;
    const count = getNumber(el, "count");
    this.pinInput?.updateProps({
      id: el.id,
      count,
      defaultValue: readDefaultValueList(el, count ?? 0),
      disabled: getBoolean(el, "disabled"),
      invalid: getBoolean(el, "invalid"),
      required: getBoolean(el, "required"),
      readOnly: getBoolean(el, "readOnly"),
      mask: getBoolean(el, "mask"),
      otp: getBoolean(el, "otp"),
      blurOnComplete: getBoolean(el, "blurOnComplete"),
      selectOnFocus: getBoolean(el, "selectOnFocus"),
      name: getString(el, "name"),
      form: getString(el, "form"),
      dir: getDir(el),
      type: getString(el, "type"),
      placeholder: getString(el, "placeholder")
    });
  },
  destroyed() {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.pinInput?.destroy();
  }
};
export {
  PinInputHook as PinInput
};
