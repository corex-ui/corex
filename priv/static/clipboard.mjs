import {
  Component,
  VanillaMachine,
  createAnatomy,
  createMachine,
  createProps,
  createSplitProps,
  dataAttr,
  getBoolean,
  getNumber,
  getString,
  getWindow,
  normalizeProps,
  setElementValue,
  setRafTimeout
} from "./chunk-AG6DB4N6.mjs";

// ../node_modules/.pnpm/@zag-js+clipboard@1.33.1/node_modules/@zag-js/clipboard/dist/index.mjs
var anatomy = createAnatomy("clipboard").parts("root", "control", "trigger", "indicator", "input", "label");
var parts = anatomy.build();
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
function connect(service, normalize) {
  const { state, send, context, scope } = service;
  const copied = state.matches("copied");
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
        "aria-label": copied ? "Copied to clipboard" : "Copy to clipboard",
        "data-copied": dataAttr(copied),
        onClick() {
          send({ type: "COPY" });
        }
      });
    },
    getIndicatorProps(props2) {
      return normalize.element({
        ...parts.indicator.attrs,
        hidden: props2.copied !== copied
      });
    }
  };
}
var machine = createMachine({
  props({ props: props2 }) {
    return {
      timeout: 3e3,
      defaultValue: "",
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
var props = createProps()([
  "getRootNode",
  "id",
  "ids",
  "value",
  "defaultValue",
  "timeout",
  "onStatusChange",
  "onValueChange"
]);
var contextProps = createSplitProps(props);
var indicatorProps = createProps()(["copied"]);
var splitIndicatorProps = createSplitProps(indicatorProps);

// components/clipboard.ts
var Clipboard = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props2) {
    return new VanillaMachine(machine, props2);
  }
  initApi() {
    return connect(this.machine.service, normalizeProps);
  }
  render() {
    const rootEl = this.el.querySelector('[data-scope="clipboard"][data-part="root"]');
    if (rootEl) {
      this.spreadProps(rootEl, this.api.getRootProps());
      const labelEl = rootEl.querySelector('[data-scope="clipboard"][data-part="label"]');
      if (labelEl) {
        this.spreadProps(labelEl, this.api.getLabelProps());
      }
      const controlEl = rootEl.querySelector('[data-scope="clipboard"][data-part="control"]');
      if (controlEl) {
        this.spreadProps(controlEl, this.api.getControlProps());
        const inputEl = controlEl.querySelector('[data-scope="clipboard"][data-part="input"]');
        if (inputEl) {
          const inputProps = { ...this.api.getInputProps() };
          const inputAriaLabel = this.el.dataset.inputAriaLabel;
          if (inputAriaLabel) {
            inputProps["aria-label"] = inputAriaLabel;
          }
          this.spreadProps(inputEl, inputProps);
        }
        const triggerEl = controlEl.querySelector('[data-scope="clipboard"][data-part="trigger"]');
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
    const liveSocket = this.liveSocket;
    const clipboard = new Clipboard(el, {
      id: el.id,
      timeout: getNumber(el, "timeout"),
      ...getBoolean(el, "controlled") ? { value: getString(el, "value") } : { defaultValue: getString(el, "defaultValue") },
      onValueChange: (details) => {
        const eventName = getString(el, "onValueChange");
        if (eventName && liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            id: el.id,
            value: details.value ?? null
          });
        }
      },
      onStatusChange: (details) => {
        const eventName = getString(el, "onStatusChange");
        if (eventName && liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            id: el.id,
            copied: details.copied
          });
        }
        const eventNameClient = getString(el, "onStatusChangeClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
              bubbles: true
            })
          );
        }
      }
    });
    clipboard.init();
    this.clipboard = clipboard;
    this.onCopy = () => {
      clipboard.api.copy();
    };
    el.addEventListener("phx:clipboard:copy", this.onCopy);
    this.onSetValue = (event) => {
      const { value } = event.detail;
      clipboard.api.setValue(value);
    };
    el.addEventListener("phx:clipboard:set-value", this.onSetValue);
    this.handlers = [];
    this.handlers.push(
      this.handleEvent("clipboard_copy", (payload) => {
        const targetId = payload.clipboard_id;
        if (targetId && targetId !== el.id) return;
        clipboard.api.copy();
      })
    );
    this.handlers.push(
      this.handleEvent("clipboard_set_value", (payload) => {
        const targetId = payload.clipboard_id;
        if (targetId && targetId !== el.id) return;
        clipboard.api.setValue(payload.value);
      })
    );
    this.handlers.push(
      this.handleEvent("clipboard_copied", () => {
        this.pushEvent("clipboard_copied_response", {
          value: clipboard.api.copied
        });
      })
    );
  },
  updated() {
    this.clipboard?.updateProps({
      id: this.el.id,
      timeout: getNumber(this.el, "timeout"),
      ...getBoolean(this.el, "controlled") ? { value: getString(this.el, "value") } : { defaultValue: getString(this.el, "value") },
      dir: getString(this.el, "dir", ["ltr", "rtl"])
    });
  },
  destroyed() {
    if (this.onCopy) {
      this.el.removeEventListener("phx:clipboard:copy", this.onCopy);
    }
    if (this.onSetValue) {
      this.el.removeEventListener("phx:clipboard:set-value", this.onSetValue);
    }
    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }
    this.clipboard?.destroy();
  }
};
export {
  ClipboardHook as Clipboard
};
