import {
  Component,
  VanillaMachine,
  ariaAttr,
  createAnatomy,
  createMachine,
  createProps,
  createSplitProps,
  dataAttr,
  getBoolean,
  getDir,
  getString,
  isLeftClick,
  normalizeProps,
  uuid
} from "./chunk-PLUM2DEK.mjs";

// ../node_modules/.pnpm/@zag-js+password-input@1.34.1/node_modules/@zag-js/password-input/dist/index.mjs
var anatomy = createAnatomy("password-input").parts(
  "root",
  "input",
  "label",
  "control",
  "indicator",
  "visibilityTrigger"
);
var parts = anatomy.build();
var getInputId = (ctx) => ctx.ids?.input ?? `p-input-${ctx.id}-input`;
var getInputEl = (ctx) => ctx.getById(getInputId(ctx));
function connect(service, normalize) {
  const { scope, prop, context } = service;
  const visible = context.get("visible");
  const disabled = !!prop("disabled");
  const invalid = !!prop("invalid");
  const readOnly = !!prop("readOnly");
  const required = !!prop("required");
  const interactive = !(readOnly || disabled);
  const translations = prop("translations");
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
var machine = createMachine({
  props({ props: props2 }) {
    return {
      id: uuid(),
      defaultVisible: false,
      autoComplete: "current-password",
      ignorePasswordManagers: false,
      ...props2,
      translations: {
        visibilityTrigger(visible) {
          return visible ? "Hide password" : "Show password";
        },
        ...props2.translations
      }
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
var props = createProps()([
  "defaultVisible",
  "dir",
  "id",
  "onVisibilityChange",
  "visible",
  "ids",
  "getRootNode",
  "disabled",
  "invalid",
  "required",
  "readOnly",
  "translations",
  "ignorePasswordManagers",
  "autoComplete",
  "name"
]);
var splitProps = createSplitProps(props);

// components/password-input.ts
var PasswordInput = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props2) {
    return new VanillaMachine(machine, props2);
  }
  initApi() {
    return connect(this.machine.service, normalizeProps);
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
var PasswordInputHook = {
  mounted() {
    const el = this.el;
    const zag = new PasswordInput(el, {
      id: el.id,
      ...getBoolean(el, "controlledVisible") ? { visible: getBoolean(el, "visible") } : { defaultVisible: getBoolean(el, "defaultVisible") },
      disabled: getBoolean(el, "disabled"),
      invalid: getBoolean(el, "invalid"),
      readOnly: getBoolean(el, "readOnly"),
      required: getBoolean(el, "required"),
      ignorePasswordManagers: getBoolean(el, "ignorePasswordManagers"),
      name: getString(el, "name"),
      dir: getDir(el),
      autoComplete: getString(el, "autoComplete", [
        "current-password",
        "new-password"
      ]),
      onVisibilityChange: (details) => {
        const eventName = getString(el, "onVisibilityChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, { visible: details.visible, id: el.id });
        }
        const clientName = getString(el, "onVisibilityChangeClient");
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
    this.passwordInput = zag;
    this.handlers = [];
  },
  updated() {
    this.passwordInput?.updateProps({
      id: this.el.id,
      ...getBoolean(this.el, "controlledVisible") ? { visible: getBoolean(this.el, "visible") } : {},
      disabled: getBoolean(this.el, "disabled"),
      invalid: getBoolean(this.el, "invalid"),
      readOnly: getBoolean(this.el, "readOnly"),
      required: getBoolean(this.el, "required"),
      name: getString(this.el, "name"),
      form: getString(this.el, "form"),
      dir: getDir(this.el)
    });
  },
  destroyed() {
    if (this.handlers) {
      for (const h of this.handlers) this.removeHandleEvent(h);
    }
    this.passwordInput?.destroy();
  }
};
export {
  PasswordInputHook as PasswordInput
};
