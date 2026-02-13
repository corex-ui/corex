import {
  isFocusVisible,
  trackFocusVisible
} from "./chunk-EAMC7PNF.mjs";
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
  getEventTarget,
  getString,
  isSafari,
  normalizeProps,
  setElementChecked,
  trackFormControl,
  trackPress,
  visuallyHiddenStyle
} from "./chunk-GFGFZBBD.mjs";

// ../node_modules/.pnpm/@zag-js+switch@1.33.1/node_modules/@zag-js/switch/dist/index.mjs
var anatomy = createAnatomy("switch").parts("root", "label", "control", "thumb");
var parts = anatomy.build();
var getRootId = (ctx) => ctx.ids?.root ?? `switch:${ctx.id}`;
var getLabelId = (ctx) => ctx.ids?.label ?? `switch:${ctx.id}:label`;
var getThumbId = (ctx) => ctx.ids?.thumb ?? `switch:${ctx.id}:thumb`;
var getControlId = (ctx) => ctx.ids?.control ?? `switch:${ctx.id}:control`;
var getHiddenInputId = (ctx) => ctx.ids?.hiddenInput ?? `switch:${ctx.id}:input`;
var getRootEl = (ctx) => ctx.getById(getRootId(ctx));
var getHiddenInputEl = (ctx) => ctx.getById(getHiddenInputId(ctx));
function connect(service, normalize) {
  const { context, send, prop, scope } = service;
  const disabled = !!prop("disabled");
  const readOnly = !!prop("readOnly");
  const required = !!prop("required");
  const checked = !!context.get("checked");
  const focused = !disabled && context.get("focused");
  const focusVisible = !disabled && context.get("focusVisible");
  const active = !disabled && context.get("active");
  const dataAttrs = {
    "data-active": dataAttr(active),
    "data-focus": dataAttr(focused),
    "data-focus-visible": dataAttr(focusVisible),
    "data-readonly": dataAttr(readOnly),
    "data-hover": dataAttr(context.get("hovered")),
    "data-disabled": dataAttr(disabled),
    "data-state": checked ? "checked" : "unchecked",
    "data-invalid": dataAttr(prop("invalid")),
    "data-required": dataAttr(required)
  };
  return {
    checked,
    disabled,
    focused,
    setChecked(checked2) {
      send({ type: "CHECKED.SET", checked: checked2, isTrusted: false });
    },
    toggleChecked() {
      send({ type: "CHECKED.TOGGLE", checked, isTrusted: false });
    },
    getRootProps() {
      return normalize.label({
        ...parts.root.attrs,
        ...dataAttrs,
        dir: prop("dir"),
        id: getRootId(scope),
        htmlFor: getHiddenInputId(scope),
        onPointerMove() {
          if (disabled) return;
          send({ type: "CONTEXT.SET", context: { hovered: true } });
        },
        onPointerLeave() {
          if (disabled) return;
          send({ type: "CONTEXT.SET", context: { hovered: false } });
        },
        onClick(event) {
          if (disabled) return;
          const target = getEventTarget(event);
          if (target === getHiddenInputEl(scope)) {
            event.stopPropagation();
          }
          if (isSafari()) {
            getHiddenInputEl(scope)?.focus();
          }
        }
      });
    },
    getLabelProps() {
      return normalize.element({
        ...parts.label.attrs,
        ...dataAttrs,
        dir: prop("dir"),
        id: getLabelId(scope)
      });
    },
    getThumbProps() {
      return normalize.element({
        ...parts.thumb.attrs,
        ...dataAttrs,
        dir: prop("dir"),
        id: getThumbId(scope),
        "aria-hidden": true
      });
    },
    getControlProps() {
      return normalize.element({
        ...parts.control.attrs,
        ...dataAttrs,
        dir: prop("dir"),
        id: getControlId(scope),
        "aria-hidden": true
      });
    },
    getHiddenInputProps() {
      return normalize.input({
        id: getHiddenInputId(scope),
        type: "checkbox",
        required: prop("required"),
        defaultChecked: checked,
        disabled,
        "aria-labelledby": getLabelId(scope),
        "aria-invalid": prop("invalid"),
        name: prop("name"),
        form: prop("form"),
        value: prop("value"),
        style: visuallyHiddenStyle,
        onFocus() {
          const focusVisible2 = isFocusVisible();
          send({ type: "CONTEXT.SET", context: { focused: true, focusVisible: focusVisible2 } });
        },
        onBlur() {
          send({ type: "CONTEXT.SET", context: { focused: false, focusVisible: false } });
        },
        onClick(event) {
          if (readOnly) {
            event.preventDefault();
            return;
          }
          const checked2 = event.currentTarget.checked;
          send({ type: "CHECKED.SET", checked: checked2, isTrusted: true });
        }
      });
    }
  };
}
var { not } = createGuards();
var machine = createMachine({
  props({ props: props2 }) {
    return {
      defaultChecked: false,
      label: "switch",
      value: "on",
      ...props2
    };
  },
  initialState() {
    return "ready";
  },
  context({ prop, bindable }) {
    return {
      checked: bindable(() => ({
        defaultValue: prop("defaultChecked"),
        value: prop("checked"),
        onChange(value) {
          prop("onCheckedChange")?.({ checked: value });
        }
      })),
      fieldsetDisabled: bindable(() => ({
        defaultValue: false
      })),
      focusVisible: bindable(() => ({
        defaultValue: false
      })),
      active: bindable(() => ({
        defaultValue: false
      })),
      focused: bindable(() => ({
        defaultValue: false
      })),
      hovered: bindable(() => ({
        defaultValue: false
      }))
    };
  },
  computed: {
    isDisabled: ({ context, prop }) => prop("disabled") || context.get("fieldsetDisabled")
  },
  watch({ track, prop, context, action }) {
    track([() => prop("disabled")], () => {
      action(["removeFocusIfNeeded"]);
    });
    track([() => context.get("checked")], () => {
      action(["syncInputElement"]);
    });
  },
  effects: ["trackFormControlState", "trackPressEvent", "trackFocusVisible"],
  on: {
    "CHECKED.TOGGLE": [
      {
        guard: not("isTrusted"),
        actions: ["toggleChecked", "dispatchChangeEvent"]
      },
      {
        actions: ["toggleChecked"]
      }
    ],
    "CHECKED.SET": [
      {
        guard: not("isTrusted"),
        actions: ["setChecked", "dispatchChangeEvent"]
      },
      {
        actions: ["setChecked"]
      }
    ],
    "CONTEXT.SET": {
      actions: ["setContext"]
    }
  },
  states: {
    ready: {}
  },
  implementations: {
    guards: {
      isTrusted: ({ event }) => !!event.isTrusted
    },
    effects: {
      trackPressEvent({ computed, scope, context }) {
        if (computed("isDisabled")) return;
        return trackPress({
          pointerNode: getRootEl(scope),
          keyboardNode: getHiddenInputEl(scope),
          isValidKey: (event) => event.key === " ",
          onPress: () => context.set("active", false),
          onPressStart: () => context.set("active", true),
          onPressEnd: () => context.set("active", false)
        });
      },
      trackFocusVisible({ computed, scope }) {
        if (computed("isDisabled")) return;
        return trackFocusVisible({ root: scope.getRootNode() });
      },
      trackFormControlState({ context, send, scope }) {
        return trackFormControl(getHiddenInputEl(scope), {
          onFieldsetDisabledChange(disabled) {
            context.set("fieldsetDisabled", disabled);
          },
          onFormReset() {
            const checked = context.initial("checked");
            send({ type: "CHECKED.SET", checked: !!checked, src: "form-reset" });
          }
        });
      }
    },
    actions: {
      setContext({ context, event }) {
        for (const key in event.context) {
          context.set(key, event.context[key]);
        }
      },
      syncInputElement({ context, scope }) {
        const inputEl = getHiddenInputEl(scope);
        if (!inputEl) return;
        setElementChecked(inputEl, !!context.get("checked"));
      },
      removeFocusIfNeeded({ context, prop }) {
        if (prop("disabled")) {
          context.set("focused", false);
        }
      },
      setChecked({ context, event }) {
        context.set("checked", event.checked);
      },
      toggleChecked({ context }) {
        context.set("checked", !context.get("checked"));
      },
      dispatchChangeEvent({ context, scope }) {
        queueMicrotask(() => {
          const inputEl = getHiddenInputEl(scope);
          dispatchInputCheckedEvent(inputEl, { checked: context.get("checked") });
        });
      }
    }
  }
});
var props = createProps()([
  "checked",
  "defaultChecked",
  "dir",
  "disabled",
  "form",
  "getRootNode",
  "id",
  "ids",
  "invalid",
  "label",
  "name",
  "onCheckedChange",
  "readOnly",
  "required",
  "value"
]);
var splitProps = createSplitProps(props);

// components/switch.ts
var Switch = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props2) {
    return new VanillaMachine(machine, props2);
  }
  initApi() {
    return connect(this.machine.service, normalizeProps);
  }
  render() {
    const rootEl = this.el.querySelector('[data-scope="switch"][data-part="root"]');
    if (!rootEl) return;
    this.spreadProps(rootEl, this.api.getRootProps());
    const inputEl = this.el.querySelector('[data-scope="switch"][data-part="hidden-input"]');
    if (inputEl) {
      this.spreadProps(inputEl, this.api.getHiddenInputProps());
    }
    const labelEl = this.el.querySelector('[data-scope="switch"][data-part="label"]');
    if (labelEl) {
      this.spreadProps(labelEl, this.api.getLabelProps());
    }
    const controlEl = this.el.querySelector('[data-scope="switch"][data-part="control"]');
    if (controlEl) {
      this.spreadProps(controlEl, this.api.getControlProps());
    }
    const thumbEl = this.el.querySelector('[data-scope="switch"][data-part="thumb"]');
    if (thumbEl) {
      this.spreadProps(thumbEl, this.api.getThumbProps());
    }
  }
};

// hooks/switch.ts
var SwitchHook = {
  mounted() {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    this.wasFocused = false;
    const zagSwitch = new Switch(el, {
      id: el.id,
      ...getBoolean(el, "controlled") ? { checked: getBoolean(el, "checked") } : { defaultChecked: getBoolean(el, "defaultChecked") },
      disabled: getBoolean(el, "disabled"),
      name: getString(el, "name"),
      form: getString(el, "form"),
      value: getString(el, "value"),
      dir: getString(el, "dir", ["ltr", "rtl"]),
      invalid: getBoolean(el, "invalid"),
      required: getBoolean(el, "required"),
      readOnly: getBoolean(el, "readOnly"),
      label: getString(el, "label"),
      onCheckedChange: (details) => {
        const eventName = getString(el, "onCheckedChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            checked: details.checked,
            id: el.id
          });
        }
        const eventNameClient = getString(el, "onCheckedChangeClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
              bubbles: true,
              detail: {
                value: details,
                id: el.id
              }
            })
          );
        }
      }
    });
    zagSwitch.init();
    this.zagSwitch = zagSwitch;
    this.onSetChecked = (event) => {
      const { value } = event.detail;
      zagSwitch.api.setChecked(value);
    };
    el.addEventListener("phx:switch:set-checked", this.onSetChecked);
    this.handlers = [];
    this.handlers.push(
      this.handleEvent("switch_set_checked", (payload) => {
        const targetId = payload.id;
        if (targetId && targetId !== el.id) return;
        zagSwitch.api.setChecked(payload.value);
      })
    );
    this.handlers.push(
      this.handleEvent("switch_toggle_checked", (payload) => {
        const targetId = payload.id;
        if (targetId && targetId !== el.id) return;
        zagSwitch.api.toggleChecked();
      })
    );
    this.handlers.push(
      this.handleEvent("switch_checked", () => {
        this.pushEvent("switch_checked_response", {
          value: zagSwitch.api.checked
        });
      })
    );
    this.handlers.push(
      this.handleEvent("switch_focused", () => {
        this.pushEvent("switch_focused_response", {
          value: zagSwitch.api.focused
        });
      })
    );
    this.handlers.push(
      this.handleEvent("switch_disabled", () => {
        this.pushEvent("switch_disabled_response", {
          value: zagSwitch.api.disabled
        });
      })
    );
  },
  beforeUpdate() {
    this.wasFocused = this.zagSwitch?.api.focused ?? false;
  },
  updated() {
    this.zagSwitch?.updateProps({
      id: this.el.id,
      ...getBoolean(this.el, "controlled") ? { checked: getBoolean(this.el, "checked") } : { defaultChecked: getBoolean(this.el, "defaultChecked") },
      disabled: getBoolean(this.el, "disabled"),
      name: getString(this.el, "name"),
      form: getString(this.el, "form"),
      value: getString(this.el, "value"),
      dir: getString(this.el, "dir", ["ltr", "rtl"]),
      invalid: getBoolean(this.el, "invalid"),
      required: getBoolean(this.el, "required"),
      readOnly: getBoolean(this.el, "readOnly"),
      label: getString(this.el, "label")
    });
    if (getBoolean(this.el, "controlled")) {
      if (this.wasFocused) {
        const hiddenInput = this.el.querySelector('[data-part="hidden-input"]');
        hiddenInput?.focus();
      }
    }
  },
  destroyed() {
    if (this.onSetChecked) {
      this.el.removeEventListener("phx:switch:set-checked", this.onSetChecked);
    }
    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }
    this.zagSwitch?.destroy();
  }
};
export {
  SwitchHook as Switch
};
