import {
  setRafTimeout
} from "./chunks/chunk-CT2QXKAA.mjs";
import {
  createDomEventRegistry,
  createHookHandleEventRegistry
} from "./chunks/chunk-77HPO22C.mjs";
import {
  idMatches,
  notifyChange,
  readPayloadId
} from "./chunks/chunk-LIWT33BG.mjs";
import {
  Component,
  VanillaMachine,
  canPushEvent,
  createAnatomy,
  createMachine,
  dataAttr,
  getNumber,
  getString,
  getWindow,
  setElementValue
} from "./chunks/chunk-OVJ3SUQN.mjs";

// ../node_modules/.pnpm/@zag-js+clipboard@1.40.0/node_modules/@zag-js/clipboard/dist/clipboard.anatomy.mjs
var anatomy = createAnatomy("clipboard").parts("root", "control", "trigger", "indicator", "input", "label");
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+clipboard@1.40.0/node_modules/@zag-js/clipboard/dist/clipboard.dom.mjs
var getRootId = (ctx) => ctx.ids?.root ?? `clip:${ctx.id}`;
var getInputId = (ctx) => ctx.ids?.input ?? `clip:${ctx.id}:input`;
var getLabelId = (ctx) => ctx.ids?.label ?? `clip:${ctx.id}:label`;
var getInputEl = (ctx) => ctx.getById(getInputId(ctx));
var writeToClipboard = (ctx, value) => copyText(ctx.getDoc(), value);
function createNode(doc, text) {
  const node = doc.createElement("pre");
  Object.assign(node.style, {
    width: "1px",
    height: "1px",
    position: "fixed",
    top: "5px"
  });
  node.textContent = text;
  return node;
}
function copyNode(node) {
  const win = getWindow(node);
  const selection = win.getSelection();
  if (selection == null) {
    return Promise.reject(new Error());
  }
  selection.removeAllRanges();
  const doc = node.ownerDocument;
  const range = doc.createRange();
  range.selectNodeContents(node);
  selection.addRange(range);
  doc.execCommand("copy");
  selection.removeAllRanges();
  return Promise.resolve();
}
function copyText(doc, text) {
  const win = doc.defaultView || window;
  if (win.navigator.clipboard?.writeText !== void 0) {
    return win.navigator.clipboard.writeText(text);
  }
  if (!doc.body) {
    return Promise.reject(new Error());
  }
  const node = createNode(doc, text);
  doc.body.appendChild(node);
  copyNode(node);
  doc.body.removeChild(node);
  return Promise.resolve();
}

// ../node_modules/.pnpm/@zag-js+clipboard@1.40.0/node_modules/@zag-js/clipboard/dist/clipboard.connect.mjs
function connect(service, normalize) {
  const { state, send, context, scope, prop } = service;
  const copied = state.matches("copied");
  const translations = prop("translations");
  return {
    copied,
    value: context.get("value"),
    setValue(value) {
      send({ type: "VALUE.SET", value });
    },
    copy() {
      send({ type: "COPY" });
    },
    getRootProps() {
      return normalize.element({
        ...parts.root.attrs,
        "data-copied": dataAttr(copied),
        id: getRootId(scope)
      });
    },
    getLabelProps() {
      return normalize.label({
        ...parts.label.attrs,
        htmlFor: getInputId(scope),
        "data-copied": dataAttr(copied),
        id: getLabelId(scope)
      });
    },
    getControlProps() {
      return normalize.element({
        ...parts.control.attrs,
        "data-copied": dataAttr(copied)
      });
    },
    getInputProps() {
      return normalize.input({
        ...parts.input.attrs,
        defaultValue: context.get("value"),
        "data-copied": dataAttr(copied),
        readOnly: true,
        "data-readonly": "true",
        id: getInputId(scope),
        onFocus(event) {
          event.currentTarget.select();
        },
        onCopy() {
          send({ type: "INPUT.COPY" });
        }
      });
    },
    getTriggerProps() {
      return normalize.button({
        ...parts.trigger.attrs,
        type: "button",
        "aria-label": translations.triggerLabel?.(copied),
        "data-copied": dataAttr(copied),
        onClick() {
          send({ type: "COPY" });
        }
      });
    },
    getIndicatorProps(props) {
      return normalize.element({
        ...parts.indicator.attrs,
        hidden: props.copied !== copied
      });
    }
  };
}

// ../node_modules/.pnpm/@zag-js+clipboard@1.40.0/node_modules/@zag-js/clipboard/dist/clipboard.machine.mjs
var machine = createMachine({
  props({ props }) {
    return {
      timeout: 3e3,
      defaultValue: "",
      ...props,
      translations: {
        triggerLabel: (copied) => copied ? "Copied to clipboard" : "Copy to clipboard",
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
        defaultValue: prop("defaultValue"),
        value: prop("value"),
        onChange(value) {
          prop("onValueChange")?.({ value });
        }
      }))
    };
  },
  watch({ track, context, action }) {
    track([() => context.get("value")], () => {
      action(["syncInputElement"]);
    });
  },
  on: {
    "VALUE.SET": {
      actions: ["setValue"]
    },
    COPY: {
      target: "copied",
      actions: ["copyToClipboard", "invokeOnCopy"]
    }
  },
  states: {
    idle: {
      on: {
        "INPUT.COPY": {
          target: "copied",
          actions: ["invokeOnCopy"]
        }
      }
    },
    copied: {
      effects: ["waitForTimeout"],
      on: {
        "COPY.DONE": {
          target: "idle"
        },
        COPY: {
          target: "copied",
          actions: ["copyToClipboard", "invokeOnCopy"]
        },
        "INPUT.COPY": {
          actions: ["invokeOnCopy"]
        }
      }
    }
  },
  implementations: {
    effects: {
      waitForTimeout({ prop, send }) {
        return setRafTimeout(() => {
          send({ type: "COPY.DONE" });
        }, prop("timeout"));
      }
    },
    actions: {
      setValue({ context, event }) {
        context.set("value", event.value);
      },
      copyToClipboard({ context, scope }) {
        writeToClipboard(scope, context.get("value"));
      },
      invokeOnCopy({ prop }) {
        prop("onStatusChange")?.({ copied: true });
      },
      syncInputElement({ context, scope }) {
        const inputEl = getInputEl(scope);
        if (!inputEl) return;
        setElementValue(inputEl, context.get("value"));
      }
    }
  }
});

// components/clipboard.ts
var Clipboard = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props) {
    return new VanillaMachine(machine, props);
  }
  initApi() {
    return this.zagConnect(connect);
  }
  render() {
    const rootEl = this.el.querySelector('[data-scope="clipboard"][data-part="root"]');
    if (rootEl) {
      this.spreadProps(rootEl, this.api.getRootProps());
      const labelEl = rootEl.querySelector(
        '[data-scope="clipboard"][data-part="label"]'
      );
      if (labelEl) {
        this.spreadProps(labelEl, this.api.getLabelProps());
      }
      const controlEl = rootEl.querySelector(
        '[data-scope="clipboard"][data-part="control"]'
      );
      if (controlEl) {
        this.spreadProps(controlEl, this.api.getControlProps());
        const inputEl = controlEl.querySelector(
          '[data-scope="clipboard"][data-part="input"]'
        );
        if (inputEl) {
          const inputProps = { ...this.api.getInputProps() };
          const inputAriaLabel = this.el.dataset.inputAriaLabel;
          if (inputAriaLabel) {
            inputProps["aria-label"] = inputAriaLabel;
          }
          this.spreadProps(inputEl, inputProps);
        }
        const triggerEl = controlEl.querySelector(
          '[data-scope="clipboard"][data-part="trigger"]'
        );
        if (triggerEl) {
          const triggerProps = { ...this.api.getTriggerProps() };
          const ariaLabel = this.el.dataset.triggerAriaLabel;
          if (ariaLabel) {
            triggerProps["aria-label"] = ariaLabel;
          }
          this.spreadProps(triggerEl, triggerProps);
        }
      }
    }
  }
};

// hooks/clipboard.ts
var ClipboardHook = {
  mounted() {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
    const clipboard = new Clipboard(el, {
      id: el.id,
      timeout: getNumber(el, "timeout"),
      defaultValue: getString(el, "defaultValue"),
      onStatusChange: (details) => {
        if (details?.copied !== true) return;
        const value = clipboard.api.value ?? getString(el, "defaultValue");
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: { id: el.id, value },
          serverEventName: getString(el, "onCopy"),
          clientEventName: getString(el, "onCopyClient")
        });
      }
    });
    clipboard.init();
    this.clipboard = clipboard;
    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;
    domRegistry.add("corex:clipboard:copy", () => {
      clipboard.api.copy();
    });
    domRegistry.add("corex:clipboard:set-value", (event) => {
      const v = event.detail?.value;
      if (typeof v === "string") clipboard.api.setValue(v);
    });
    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;
    registry.add("clipboard_copy", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      clipboard.api.copy();
    });
    registry.add("clipboard_set_value", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (!payload || typeof payload !== "object") return;
      const o = payload;
      const v = o.value ?? o["value"];
      if (typeof v === "string") clipboard.api.setValue(v);
    });
  },
  updated() {
    this.clipboard?.updateProps({
      id: this.el.id,
      timeout: getNumber(this.el, "timeout"),
      defaultValue: getString(this.el, "defaultValue")
    });
  },
  destroyed() {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.clipboard?.destroy();
  }
};
export {
  ClipboardHook as Clipboard
};
