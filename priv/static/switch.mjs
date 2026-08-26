import {
  isFocusVisible,
  trackFocusVisible
} from "./chunks/chunk-HJMWAVV5.mjs";
import {
  syncCheckableHiddenInput,
  syncCheckedHiddenInput
} from "./chunks/chunk-46XN2SIW.mjs";
import {
  mountCheckedBinding,
  readUpdatedServerChecked
} from "./chunks/chunk-XDPIWU5M.mjs";
import {
  checkedChangePayload,
  idMatches,
  notifyChange,
  readPayloadChecked,
  readPayloadId
} from "./chunks/chunk-EAQ6WQNO.mjs";
import {
  Component,
  VanillaMachine,
  canPushEvent,
  createAnatomy,
  createGuards,
  createMachine,
  createZagLiveHook,
  dataAttr,
  dispatchInputCheckedEvent,
  getBoolean,
  getDir,
  getEventTarget,
  getString,
  isSafari,
  setElementChecked,
  trackFormControl,
  trackPress,
  visuallyHiddenStyle
} from "./chunks/chunk-5L577WPD.mjs";

// ../node_modules/.pnpm/@zag-js+switch@1.43.3/node_modules/@zag-js/switch/dist/switch.anatomy.mjs
var anatomy = createAnatomy("switch").parts("root", "label", "control", "thumb");
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+switch@1.43.3/node_modules/@zag-js/switch/dist/switch.dom.mjs
var getRootId = (ctx) => ctx.ids?.root ?? `switch:${ctx.id}`;
var getLabelId = (ctx) => ctx.ids?.label ?? `switch:${ctx.id}:label`;
var getThumbId = (ctx) => ctx.ids?.thumb ?? `switch:${ctx.id}:thumb`;
var getControlId = (ctx) => ctx.ids?.control ?? `switch:${ctx.id}:control`;
var getHiddenInputId = (ctx) => ctx.ids?.hiddenInput ?? `switch:${ctx.id}:input`;
var getRootEl = (ctx) => ctx.getById(getRootId(ctx));
var getHiddenInputEl = (ctx) => ctx.getById(getHiddenInputId(ctx));

// ../node_modules/.pnpm/@zag-js+switch@1.43.3/node_modules/@zag-js/switch/dist/switch.connect.mjs
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

// ../node_modules/.pnpm/@zag-js+switch@1.43.3/node_modules/@zag-js/switch/dist/switch.machine.mjs
var { not } = createGuards();
var machine = createMachine({
  props({ props }) {
    return {
      defaultChecked: false,
      label: "switch",
      value: "on",
      ...props
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

// components/switch.ts
var Switch = class extends Component {
  initMachine(props) {
    return new VanillaMachine(machine, props);
  }
  initApi() {
    return this.zagConnect(connect);
  }
  render() {
    const rootEl = this.el.querySelector('[data-scope="switch"][data-part="root"]');
    if (!rootEl) return;
    this.spreadProps(rootEl, this.api.getRootProps());
    const inputEl = rootEl.querySelector(
      ':scope > [data-scope="switch"][data-part="hidden-input"]'
    );
    if (inputEl instanceof HTMLInputElement) {
      syncCheckableHiddenInput(
        inputEl,
        this.el,
        this.api.checked === true,
        (el, props) => this.spreadProps(el, props),
        this.api.getHiddenInputProps()
      );
    }
    rootEl.querySelectorAll(':scope > [data-scope="switch"][data-part="label"]').forEach((labelEl) => {
      this.spreadProps(labelEl, this.api.getLabelProps());
    });
    const controlEl = rootEl.querySelector(
      ':scope > [data-scope="switch"][data-part="control"]'
    );
    if (controlEl) {
      this.spreadProps(controlEl, this.api.getControlProps());
      const thumbEl = controlEl.querySelector(
        ':scope > [data-scope="switch"][data-part="thumb"]'
      );
      if (thumbEl) {
        this.spreadProps(thumbEl, this.api.getThumbProps());
      }
    }
  }
};

// hooks/switch.ts
var SwitchHook = createZagLiveHook({
  key: "switchComponent",
  controlledKeys: ["checked"],
  mount(hook, { dom, server }) {
    const el = hook.el;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);
    const switchComponent = new Switch(el, {
      id: el.id,
      ...(() => {
        const binding = mountCheckedBinding(el);
        if ("checked" in binding) {
          return { checked: binding.checked === true };
        }
        return { defaultChecked: binding.defaultChecked === true };
      })(),
      disabled: getBoolean(el, "disabled"),
      name: getString(el, "name"),
      form: getString(el, "form"),
      value: getString(el, "value"),
      dir: getDir(el),
      invalid: getBoolean(el, "invalid"),
      required: getBoolean(el, "required"),
      readOnly: getBoolean(el, "readonly"),
      onCheckedChange: (details) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: checkedChangePayload(el, details),
          serverEventName: getString(el, "onCheckedChange"),
          clientEventName: getString(el, "onCheckedChangeClient")
        });
        const input = el.querySelector(
          '[data-scope="switch"][data-part="hidden-input"]'
        );
        if (input) {
          syncCheckedHiddenInput(input, details.checked === true, { markUsed: false });
        }
      }
    });
    dom.add("corex:switch:set-checked", (event) => {
      const { checked } = event.detail;
      switchComponent.api.setChecked(checked);
    });
    dom.add("corex:switch:toggle-checked", () => {
      switchComponent.api.toggleChecked();
    });
    server.add("switch_set_checked", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      const checked = readPayloadChecked(payload);
      if (typeof checked === "boolean") switchComponent.api.setChecked(checked);
    });
    server.add("switch_toggle_checked", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      switchComponent.api.toggleChecked();
    });
    server.add("switch_checked", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (!canPush()) return;
      hook.pushEvent("switch_checked_response", {
        id: el.id,
        value: switchComponent.api.checked
      });
    });
    server.add("switch_focused", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (!canPush()) return;
      hook.pushEvent("switch_focused_response", {
        id: el.id,
        value: switchComponent.api.focused
      });
    });
    server.add("switch_disabled", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (!canPush()) return;
      hook.pushEvent("switch_disabled_response", {
        id: el.id,
        value: switchComponent.api.disabled
      });
    });
    return switchComponent;
  },
  update(hook, switchComponent) {
    const checkedPatch = readUpdatedServerChecked(hook.el, hook.beforeAttrs);
    switchComponent.updateProps({
      id: hook.el.id,
      ..."checked" in checkedPatch ? { checked: checkedPatch.checked === true } : {},
      disabled: getBoolean(hook.el, "disabled"),
      name: getString(hook.el, "name"),
      form: getString(hook.el, "form"),
      value: getString(hook.el, "value"),
      dir: getDir(hook.el),
      invalid: getBoolean(hook.el, "invalid"),
      required: getBoolean(hook.el, "required"),
      readOnly: getBoolean(hook.el, "readonly")
    });
  }
});
export {
  SwitchHook as Switch,
  checkedChangePayload
};
