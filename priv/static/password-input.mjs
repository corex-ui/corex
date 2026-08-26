import {
  idMatches,
  notifyChange,
  readPayloadId,
  readPayloadVisible
} from "./chunks/chunk-EAQ6WQNO.mjs";
import {
  Component,
  VanillaMachine,
  ariaAttr,
  canPushEvent,
  createAnatomy,
  createMachine,
  createZagLiveHook,
  dataAttr,
  getBoolean,
  getDir,
  getString,
  isLeftClick,
  mergeWithDefault,
  uuid
} from "./chunks/chunk-JPQZXVRQ.mjs";

// ../node_modules/.pnpm/@zag-js+password-input@1.43.3/node_modules/@zag-js/password-input/dist/password-input.anatomy.mjs
var anatomy = createAnatomy("password-input").parts(
  "root",
  "input",
  "label",
  "control",
  "indicator",
  "visibilityTrigger"
);
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+password-input@1.43.3/node_modules/@zag-js/password-input/dist/password-input.dom.mjs
var getInputId = (ctx) => ctx.ids?.input ?? `p-input-${ctx.id}-input`;
var getInputEl = (ctx) => ctx.getById(getInputId(ctx));

// ../node_modules/.pnpm/@zag-js+password-input@1.43.3/node_modules/@zag-js/password-input/dist/password-input.connect.mjs
var defaultTranslations = {
  visibilityTrigger: (visible) => visible ? "Hide password" : "Show password"
};
function connect(service, normalize) {
  const { scope, prop, context } = service;
  const visible = context.get("visible");
  const disabled = !!prop("disabled");
  const invalid = !!prop("invalid");
  const readOnly = !!prop("readOnly");
  const required = !!prop("required");
  const interactive = !(readOnly || disabled);
  const translations = mergeWithDefault(defaultTranslations, prop("translations"));
  return {
    visible,
    disabled,
    invalid,
    focus() {
      getInputEl(scope)?.focus();
    },
    setVisible(value) {
      service.send({ type: "VISIBILITY.SET", value });
    },
    toggleVisible() {
      service.send({ type: "VISIBILITY.SET", value: !visible });
    },
    getRootProps() {
      return normalize.element({
        ...parts.root.attrs,
        dir: prop("dir"),
        "data-disabled": dataAttr(disabled),
        "data-invalid": dataAttr(invalid),
        "data-readonly": dataAttr(readOnly)
      });
    },
    getLabelProps() {
      return normalize.label({
        ...parts.label.attrs,
        htmlFor: getInputId(scope),
        "data-disabled": dataAttr(disabled),
        "data-invalid": dataAttr(invalid),
        "data-readonly": dataAttr(readOnly),
        "data-required": dataAttr(required)
      });
    },
    getInputProps() {
      return normalize.input({
        ...parts.input.attrs,
        id: getInputId(scope),
        autoCapitalize: "off",
        name: prop("name"),
        required: prop("required"),
        autoComplete: prop("autoComplete"),
        spellCheck: false,
        readOnly,
        disabled,
        type: visible ? "text" : "password",
        "data-state": visible ? "visible" : "hidden",
        "aria-invalid": ariaAttr(invalid),
        "data-disabled": dataAttr(disabled),
        "data-invalid": dataAttr(invalid),
        "data-readonly": dataAttr(readOnly),
        ...prop("ignorePasswordManagers") ? passwordManagerProps : {}
      });
    },
    getVisibilityTriggerProps() {
      return normalize.button({
        ...parts.visibilityTrigger.attrs,
        type: "button",
        tabIndex: -1,
        "aria-controls": getInputId(scope),
        "aria-expanded": visible,
        "data-readonly": dataAttr(readOnly),
        disabled,
        "data-disabled": dataAttr(disabled),
        "data-state": visible ? "visible" : "hidden",
        "aria-label": translations?.visibilityTrigger?.(visible),
        onPointerDown(event) {
          if (!isLeftClick(event)) return;
          if (!interactive) return;
          event.preventDefault();
          service.send({ type: "TRIGGER.CLICK" });
        }
      });
    },
    getIndicatorProps() {
      return normalize.element({
        ...parts.indicator.attrs,
        "aria-hidden": true,
        "data-state": visible ? "visible" : "hidden",
        "data-disabled": dataAttr(disabled),
        "data-invalid": dataAttr(invalid),
        "data-readonly": dataAttr(readOnly)
      });
    },
    getControlProps() {
      return normalize.element({
        ...parts.control.attrs,
        "data-disabled": dataAttr(disabled),
        "data-invalid": dataAttr(invalid),
        "data-readonly": dataAttr(readOnly)
      });
    }
  };
}
var passwordManagerProps = {
  // 1Password
  "data-1p-ignore": "",
  // LastPass
  "data-lpignore": "true",
  // Bitwarden
  "data-bwignore": "true",
  // Dashlane
  "data-form-type": "other",
  // Proton Pass
  "data-protonpass-ignore": "true"
};

// ../node_modules/.pnpm/@zag-js+password-input@1.43.3/node_modules/@zag-js/password-input/dist/password-input.machine.mjs
var machine = createMachine({
  props({ props }) {
    return {
      id: uuid(),
      defaultVisible: false,
      autoComplete: "current-password",
      ignorePasswordManagers: false,
      ...props
    };
  },
  context({ prop, bindable }) {
    return {
      visible: bindable(() => ({
        value: prop("visible"),
        defaultValue: prop("defaultVisible"),
        onChange(value) {
          prop("onVisibilityChange")?.({ visible: value });
        }
      }))
    };
  },
  initialState() {
    return "idle";
  },
  effects: ["trackFormEvents"],
  states: {
    idle: {
      on: {
        "VISIBILITY.SET": {
          actions: ["setVisibility"]
        },
        "TRIGGER.CLICK": {
          actions: ["toggleVisibility", "focusInputEl"]
        }
      }
    }
  },
  implementations: {
    actions: {
      setVisibility({ context, event }) {
        context.set("visible", event.value);
      },
      toggleVisibility({ context }) {
        context.set("visible", (c) => !c);
      },
      focusInputEl({ scope }) {
        const inputEl = getInputEl(scope);
        inputEl?.focus();
      }
    },
    effects: {
      trackFormEvents({ scope, send }) {
        const inputEl = getInputEl(scope);
        const form = inputEl?.form;
        if (!form) return;
        const win = scope.getWin();
        const controller = new win.AbortController();
        form.addEventListener(
          "reset",
          (event) => {
            if (event.defaultPrevented) return;
            send({ type: "VISIBILITY.SET", value: false });
          },
          { signal: controller.signal }
        );
        form.addEventListener(
          "submit",
          () => {
            send({ type: "VISIBILITY.SET", value: false });
          },
          { signal: controller.signal }
        );
        return () => controller.abort();
      }
    }
  }
});

// components/password-input.ts
var PasswordInput = class extends Component {
  initMachine(props) {
    return new VanillaMachine(machine, props);
  }
  initApi() {
    return this.zagConnect(connect);
  }
  render() {
    const rootEl = this.el.querySelector('[data-scope="password-input"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());
    const labelEl = this.el.querySelector(
      '[data-scope="password-input"][data-part="label"]'
    );
    if (labelEl) this.spreadProps(labelEl, this.api.getLabelProps());
    const controlEl = this.el.querySelector(
      '[data-scope="password-input"][data-part="control"]'
    );
    if (controlEl) this.spreadProps(controlEl, this.api.getControlProps());
    const inputEl = this.el.querySelector(
      '[data-scope="password-input"][data-part="input"]'
    );
    if (inputEl) this.spreadProps(inputEl, this.api.getInputProps());
    const triggerEl = this.el.querySelector(
      '[data-scope="password-input"][data-part="visibility-trigger"]'
    );
    if (triggerEl) this.spreadProps(triggerEl, this.api.getVisibilityTriggerProps());
    const indicatorEl = this.el.querySelector(
      '[data-scope="password-input"][data-part="indicator"]'
    );
    if (indicatorEl) this.spreadProps(indicatorEl, this.api.getIndicatorProps());
  }
};

// hooks/password-input.ts
function visibilityChangePayload(el, details) {
  return { id: el.id, visible: details.visible };
}
var PasswordInputHook = createZagLiveHook({
  key: "passwordInput",
  mount(hook, { dom, server }) {
    const el = hook.el;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);
    const zag = new PasswordInput(el, {
      id: el.id,
      defaultVisible: getBoolean(el, "defaultVisible"),
      disabled: getBoolean(el, "disabled"),
      invalid: getBoolean(el, "invalid"),
      readOnly: getBoolean(el, "readonly"),
      required: getBoolean(el, "required"),
      ignorePasswordManagers: getBoolean(el, "ignorePasswordManagers"),
      name: getString(el, "name"),
      dir: getDir(el),
      autoComplete: getString(el, "autoComplete"),
      onVisibilityChange: (details) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: visibilityChangePayload(el, details),
          serverEventName: getString(el, "onVisibilityChange"),
          clientEventName: getString(el, "onVisibilityChangeClient")
        });
      }
    });
    hook.handlers = [];
    dom.add("corex:password-input:set-visible", (event) => {
      const vis = event.detail?.visible;
      if (typeof vis === "boolean") zag.api.setVisible(vis);
    });
    dom.add("corex:password-input:toggle-visible", () => {
      zag.api.toggleVisible();
    });
    dom.add("corex:password-input:focus", () => {
      zag.api.focus();
    });
    server.add("password_input_set_visible", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      const vis = readPayloadVisible(payload);
      if (typeof vis === "boolean") zag.api.setVisible(vis);
    });
    server.add("password_input_toggle_visible", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.toggleVisible();
    });
    server.add("password_input_focus", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.focus();
    });
    return zag;
  },
  update(hook, zag) {
    const el = hook.el;
    zag.updateProps({
      id: el.id,
      disabled: getBoolean(el, "disabled"),
      invalid: getBoolean(el, "invalid"),
      readOnly: getBoolean(el, "readonly"),
      required: getBoolean(el, "required"),
      name: getString(el, "name"),
      dir: getDir(el)
    });
  }
});
export {
  PasswordInputHook as PasswordInput,
  visibilityChangePayload
};
