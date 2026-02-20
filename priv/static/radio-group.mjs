import {
  isFocusVisible,
  trackFocusVisible
} from "./chunk-GXGJDSCU.mjs";
import {
  Component,
  VanillaMachine,
  createAnatomy,
  createGuards,
  createMachine,
  createProps,
  createSplitProps,
  dataAttr,
  dispatchInputCheckedEvent,
  getBoolean,
  getString,
  isLeftClick,
  isSafari,
  normalizeProps,
  queryAll,
  resizeObserverBorderBox,
  toPx,
  trackFormControl,
  visuallyHiddenStyle
} from "./chunk-TZXIWZZ7.mjs";

// ../node_modules/.pnpm/@zag-js+radio-group@1.34.0/node_modules/@zag-js/radio-group/dist/index.mjs
var anatomy = createAnatomy("radio-group").parts(
  "root",
  "label",
  "item",
  "itemText",
  "itemControl",
  "indicator"
);
var parts = anatomy.build();
var getRootId = (ctx) => ctx.ids?.root ?? `radio-group:${ctx.id}`;
var getLabelId = (ctx) => ctx.ids?.label ?? `radio-group:${ctx.id}:label`;
var getItemId = (ctx, value) => ctx.ids?.item?.(value) ?? `radio-group:${ctx.id}:radio:${value}`;
var getItemHiddenInputId = (ctx, value) => ctx.ids?.itemHiddenInput?.(value) ?? `radio-group:${ctx.id}:radio:input:${value}`;
var getItemControlId = (ctx, value) => ctx.ids?.itemControl?.(value) ?? `radio-group:${ctx.id}:radio:control:${value}`;
var getItemLabelId = (ctx, value) => ctx.ids?.itemLabel?.(value) ?? `radio-group:${ctx.id}:radio:label:${value}`;
var getIndicatorId = (ctx) => ctx.ids?.indicator ?? `radio-group:${ctx.id}:indicator`;
var getRootEl = (ctx) => ctx.getById(getRootId(ctx));
var getItemHiddenInputEl = (ctx, value) => ctx.getById(getItemHiddenInputId(ctx, value));
var getIndicatorEl = (ctx) => ctx.getById(getIndicatorId(ctx));
var getFirstEnabledInputEl = (ctx) => getRootEl(ctx)?.querySelector("input:not(:disabled)");
var getFirstEnabledAndCheckedInputEl = (ctx) => getRootEl(ctx)?.querySelector("input:not(:disabled):checked");
var getInputEls = (ctx) => {
  const ownerId = CSS.escape(getRootId(ctx));
  const selector = `input[type=radio][data-ownedby='${ownerId}']:not([disabled])`;
  return queryAll(getRootEl(ctx), selector);
};
var getRadioEl = (ctx, value) => {
  if (!value) return;
  return ctx.getById(getItemId(ctx, value));
};
var getOffsetRect = (el) => ({
  x: el?.offsetLeft ?? 0,
  y: el?.offsetTop ?? 0,
  width: el?.offsetWidth ?? 0,
  height: el?.offsetHeight ?? 0
});
function connect(service, normalize) {
  const { context, send, computed, prop, scope } = service;
  const groupDisabled = computed("isDisabled");
  const groupInvalid = prop("invalid");
  const readOnly = prop("readOnly");
  function getItemState(props2) {
    return {
      value: props2.value,
      invalid: !!props2.invalid || !!groupInvalid,
      disabled: !!props2.disabled || groupDisabled,
      checked: context.get("value") === props2.value,
      focused: context.get("focusedValue") === props2.value,
      focusVisible: context.get("focusVisibleValue") === props2.value,
      hovered: context.get("hoveredValue") === props2.value,
      active: context.get("activeValue") === props2.value
    };
  }
  function getItemDataAttrs(props2) {
    const itemState = getItemState(props2);
    return {
      "data-focus": dataAttr(itemState.focused),
      "data-focus-visible": dataAttr(itemState.focusVisible),
      "data-disabled": dataAttr(itemState.disabled),
      "data-readonly": dataAttr(readOnly),
      "data-state": itemState.checked ? "checked" : "unchecked",
      "data-hover": dataAttr(itemState.hovered),
      "data-invalid": dataAttr(itemState.invalid),
      "data-orientation": prop("orientation"),
      "data-ssr": dataAttr(context.get("ssr"))
    };
  }
  const focus = () => {
    const nodeToFocus = getFirstEnabledAndCheckedInputEl(scope) ?? getFirstEnabledInputEl(scope);
    nodeToFocus?.focus();
  };
  return {
    focus,
    value: context.get("value"),
    setValue(value) {
      send({ type: "SET_VALUE", value, isTrusted: false });
    },
    clearValue() {
      send({ type: "SET_VALUE", value: null, isTrusted: false });
    },
    getRootProps() {
      return normalize.element({
        ...parts.root.attrs,
        role: "radiogroup",
        id: getRootId(scope),
        "aria-labelledby": getLabelId(scope),
        "aria-required": prop("required") || void 0,
        "aria-disabled": groupDisabled || void 0,
        "aria-readonly": readOnly || void 0,
        "data-orientation": prop("orientation"),
        "data-disabled": dataAttr(groupDisabled),
        "data-invalid": dataAttr(groupInvalid),
        "data-required": dataAttr(prop("required")),
        "aria-orientation": prop("orientation"),
        dir: prop("dir"),
        style: {
          position: "relative"
        }
      });
    },
    getLabelProps() {
      return normalize.element({
        ...parts.label.attrs,
        dir: prop("dir"),
        "data-orientation": prop("orientation"),
        "data-disabled": dataAttr(groupDisabled),
        "data-invalid": dataAttr(groupInvalid),
        "data-required": dataAttr(prop("required")),
        id: getLabelId(scope),
        onClick: focus
      });
    },
    getItemState,
    getItemProps(props2) {
      const itemState = getItemState(props2);
      return normalize.label({
        ...parts.item.attrs,
        dir: prop("dir"),
        id: getItemId(scope, props2.value),
        htmlFor: getItemHiddenInputId(scope, props2.value),
        ...getItemDataAttrs(props2),
        onPointerMove() {
          if (itemState.disabled) return;
          if (itemState.hovered) return;
          send({ type: "SET_HOVERED", value: props2.value, hovered: true });
        },
        onPointerLeave() {
          if (itemState.disabled) return;
          send({ type: "SET_HOVERED", value: null });
        },
        onPointerDown(event) {
          if (itemState.disabled) return;
          if (!isLeftClick(event)) return;
          if (itemState.focused && event.pointerType === "mouse") {
            event.preventDefault();
          }
          send({ type: "SET_ACTIVE", value: props2.value, active: true });
        },
        onPointerUp() {
          if (itemState.disabled) return;
          send({ type: "SET_ACTIVE", value: null });
        },
        onClick() {
          if (!itemState.disabled && isSafari()) {
            getItemHiddenInputEl(scope, props2.value)?.focus();
          }
        }
      });
    },
    getItemTextProps(props2) {
      return normalize.element({
        ...parts.itemText.attrs,
        dir: prop("dir"),
        id: getItemLabelId(scope, props2.value),
        ...getItemDataAttrs(props2)
      });
    },
    getItemControlProps(props2) {
      const itemState = getItemState(props2);
      return normalize.element({
        ...parts.itemControl.attrs,
        dir: prop("dir"),
        id: getItemControlId(scope, props2.value),
        "data-active": dataAttr(itemState.active),
        "aria-hidden": true,
        ...getItemDataAttrs(props2)
      });
    },
    getItemHiddenInputProps(props2) {
      const itemState = getItemState(props2);
      return normalize.input({
        "data-ownedby": getRootId(scope),
        id: getItemHiddenInputId(scope, props2.value),
        type: "radio",
        name: prop("name") || prop("id"),
        form: prop("form"),
        value: props2.value,
        required: prop("required"),
        "aria-invalid": itemState.invalid || void 0,
        onClick(event) {
          if (readOnly) {
            event.preventDefault();
            return;
          }
          if (event.currentTarget.checked) {
            send({ type: "SET_VALUE", value: props2.value, isTrusted: true });
          }
        },
        onBlur() {
          send({ type: "SET_FOCUSED", value: null, focused: false, focusVisible: false });
        },
        onFocus() {
          const focusVisible = isFocusVisible();
          send({ type: "SET_FOCUSED", value: props2.value, focused: true, focusVisible });
        },
        onKeyDown(event) {
          if (event.defaultPrevented) return;
          if (event.key === " ") {
            send({ type: "SET_ACTIVE", value: props2.value, active: true });
          }
        },
        onKeyUp(event) {
          if (event.defaultPrevented) return;
          if (event.key === " ") {
            send({ type: "SET_ACTIVE", value: null });
          }
        },
        disabled: itemState.disabled || readOnly,
        defaultChecked: itemState.checked,
        style: visuallyHiddenStyle
      });
    },
    getIndicatorProps() {
      const rect = context.get("indicatorRect");
      const rectIsEmpty = rect == null || rect.width === 0 && rect.height === 0 && rect.x === 0 && rect.y === 0;
      return normalize.element({
        id: getIndicatorId(scope),
        ...parts.indicator.attrs,
        dir: prop("dir"),
        hidden: context.get("value") == null || rectIsEmpty,
        "data-disabled": dataAttr(groupDisabled),
        "data-orientation": prop("orientation"),
        style: {
          "--transition-property": "left, top, width, height",
          "--left": toPx(rect?.x),
          "--top": toPx(rect?.y),
          "--width": toPx(rect?.width),
          "--height": toPx(rect?.height),
          position: "absolute",
          willChange: "var(--transition-property)",
          transitionProperty: "var(--transition-property)",
          transitionDuration: "var(--transition-duration, 150ms)",
          transitionTimingFunction: "var(--transition-timing-function)",
          [prop("orientation") === "horizontal" ? "left" : "top"]: prop("orientation") === "horizontal" ? "var(--left)" : "var(--top)"
        }
      });
    }
  };
}
var { not } = createGuards();
var machine = createMachine({
  props({ props: props2 }) {
    return {
      orientation: "vertical",
      ...props2
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
      activeValue: bindable(() => ({
        defaultValue: null
      })),
      focusedValue: bindable(() => ({
        defaultValue: null
      })),
      focusVisibleValue: bindable(() => ({
        defaultValue: null
      })),
      hoveredValue: bindable(() => ({
        defaultValue: null
      })),
      indicatorRect: bindable(() => ({
        defaultValue: null
      })),
      fieldsetDisabled: bindable(() => ({
        defaultValue: false
      })),
      ssr: bindable(() => ({
        defaultValue: true
      }))
    };
  },
  refs() {
    return {
      indicatorCleanup: null,
      focusVisibleValue: null
    };
  },
  computed: {
    isDisabled: ({ prop, context }) => !!prop("disabled") || context.get("fieldsetDisabled")
  },
  entry: ["syncIndicatorRect", "syncSsr"],
  exit: ["cleanupObserver"],
  effects: ["trackFormControlState", "trackFocusVisible"],
  watch({ track, action, context }) {
    track([() => context.get("value")], () => {
      action(["syncIndicatorRect", "syncInputElements"]);
    });
  },
  on: {
    SET_VALUE: [
      {
        guard: not("isTrusted"),
        actions: ["setValue", "dispatchChangeEvent"]
      },
      {
        actions: ["setValue"]
      }
    ],
    SET_HOVERED: {
      actions: ["setHovered"]
    },
    SET_ACTIVE: {
      actions: ["setActive"]
    },
    SET_FOCUSED: {
      actions: ["setFocused"]
    }
  },
  states: {
    idle: {}
  },
  implementations: {
    guards: {
      isTrusted: ({ event }) => !!event.isTrusted
    },
    effects: {
      trackFormControlState({ context, scope }) {
        return trackFormControl(getRootEl(scope), {
          onFieldsetDisabledChange(disabled) {
            context.set("fieldsetDisabled", disabled);
          },
          onFormReset() {
            context.set("value", context.initial("value"));
          }
        });
      },
      trackFocusVisible({ scope }) {
        return trackFocusVisible({ root: scope.getRootNode?.() });
      }
    },
    actions: {
      setValue({ context, event }) {
        context.set("value", event.value);
      },
      setHovered({ context, event }) {
        context.set("hoveredValue", event.value);
      },
      setActive({ context, event }) {
        context.set("activeValue", event.value);
      },
      setFocused({ context, event }) {
        context.set("focusedValue", event.value);
        const focusVisibleValue = event.value != null && event.focusVisible ? event.value : null;
        context.set("focusVisibleValue", focusVisibleValue);
      },
      syncInputElements({ context, scope }) {
        const inputs = getInputEls(scope);
        inputs.forEach((input) => {
          input.checked = input.value === context.get("value");
        });
      },
      cleanupObserver({ refs }) {
        refs.get("indicatorCleanup")?.();
      },
      syncSsr({ context }) {
        context.set("ssr", false);
      },
      syncIndicatorRect({ context, scope, refs }) {
        refs.get("indicatorCleanup")?.();
        if (!getIndicatorEl(scope)) return;
        const value = context.get("value");
        const radioEl = getRadioEl(scope, value);
        if (value == null || !radioEl) {
          context.set("indicatorRect", null);
          return;
        }
        const exec = () => {
          context.set("indicatorRect", getOffsetRect(radioEl));
        };
        exec();
        const indicatorCleanup = resizeObserverBorderBox.observe(radioEl, exec);
        refs.set("indicatorCleanup", indicatorCleanup);
      },
      dispatchChangeEvent({ context, scope }) {
        const inputEls = getInputEls(scope);
        inputEls.forEach((inputEl) => {
          const checked = inputEl.value === context.get("value");
          if (checked === inputEl.checked) return;
          dispatchInputCheckedEvent(inputEl, { checked });
        });
      }
    }
  }
});
var props = createProps()([
  "dir",
  "disabled",
  "form",
  "getRootNode",
  "id",
  "ids",
  "invalid",
  "name",
  "onValueChange",
  "orientation",
  "readOnly",
  "required",
  "value",
  "defaultValue"
]);
var splitProps = createSplitProps(props);
var itemProps = createProps()(["value", "disabled", "invalid"]);
var splitItemProps = createSplitProps(itemProps);

// components/radio-group.ts
var RadioGroup = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props2) {
    return new VanillaMachine(machine, props2);
  }
  initApi() {
    return connect(this.machine.service, normalizeProps);
  }
  render() {
    const rootEl = this.el.querySelector('[data-scope="radio-group"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());
    const labelEl = this.el.querySelector(
      '[data-scope="radio-group"][data-part="label"]'
    );
    if (labelEl) this.spreadProps(labelEl, this.api.getLabelProps());
    const indicatorEl = this.el.querySelector(
      '[data-scope="radio-group"][data-part="indicator"]'
    );
    if (indicatorEl) this.spreadProps(indicatorEl, this.api.getIndicatorProps());
    this.el.querySelectorAll('[data-scope="radio-group"][data-part="item"]').forEach((itemEl) => {
      const value = itemEl.dataset.value;
      if (value == null) return;
      const disabled = itemEl.dataset.disabled === "true";
      const invalid = itemEl.dataset.invalid === "true";
      this.spreadProps(itemEl, this.api.getItemProps({ value, disabled, invalid }));
      const textEl = itemEl.querySelector(
        '[data-scope="radio-group"][data-part="item-text"]'
      );
      if (textEl)
        this.spreadProps(
          textEl,
          this.api.getItemTextProps({ value, disabled, invalid })
        );
      const controlEl = itemEl.querySelector(
        '[data-scope="radio-group"][data-part="item-control"]'
      );
      if (controlEl)
        this.spreadProps(
          controlEl,
          this.api.getItemControlProps({
            value,
            disabled,
            invalid
          })
        );
      const hiddenInputEl = itemEl.querySelector(
        '[data-scope="radio-group"][data-part="item-hidden-input"]'
      );
      if (hiddenInputEl)
        this.spreadProps(
          hiddenInputEl,
          this.api.getItemHiddenInputProps({
            value,
            disabled,
            invalid
          })
        );
    });
  }
};

// hooks/radio-group.ts
var RadioGroupHook = {
  mounted() {
    const el = this.el;
    const value = getString(el, "value");
    const defaultValue = getString(el, "defaultValue");
    const controlled = getBoolean(el, "controlled");
    const zag = new RadioGroup(el, {
      id: el.id,
      ...controlled && value !== void 0 ? { value: value ?? null } : { defaultValue: defaultValue ?? null },
      name: getString(el, "name"),
      form: getString(el, "form"),
      disabled: getBoolean(el, "disabled"),
      invalid: getBoolean(el, "invalid"),
      required: getBoolean(el, "required"),
      readOnly: getBoolean(el, "readOnly"),
      dir: getString(el, "dir", ["ltr", "rtl"]),
      orientation: getString(el, "orientation", [
        "horizontal",
        "vertical"
      ]),
      onValueChange: (details) => {
        const eventName = getString(el, "onValueChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, {
            value: details.value,
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
    zag.init();
    this.radioGroup = zag;
    this.handlers = [];
  },
  updated() {
    const value = getString(this.el, "value");
    const controlled = getBoolean(this.el, "controlled");
    this.radioGroup?.updateProps({
      id: this.el.id,
      ...controlled && value !== void 0 ? { value: value ?? null } : {},
      name: getString(this.el, "name"),
      form: getString(this.el, "form"),
      disabled: getBoolean(this.el, "disabled"),
      invalid: getBoolean(this.el, "invalid"),
      required: getBoolean(this.el, "required"),
      readOnly: getBoolean(this.el, "readOnly"),
      orientation: getString(this.el, "orientation", [
        "horizontal",
        "vertical"
      ])
    });
  },
  destroyed() {
    if (this.handlers) {
      for (const h of this.handlers) this.removeHandleEvent(h);
    }
    this.radioGroup?.destroy();
  }
};
export {
  RadioGroupHook as RadioGroup
};
