import {
  readPressedControlledZagUpdate
} from "./chunks/chunk-6RACHWND.mjs";
import {
  idMatches,
  notifyChange,
  readPayloadId,
  readPayloadPressed
} from "./chunks/chunk-EAQ6WQNO.mjs";
import {
  Component,
  VanillaMachine,
  canPushEvent,
  createAnatomy,
  createMachine,
  createZagLiveHook,
  dataAttr,
  getBoolean,
  getBooleanValue,
  getDir,
  getString
} from "./chunks/chunk-HMQI4LDM.mjs";

// ../node_modules/.pnpm/@zag-js+toggle@1.42.0/node_modules/@zag-js/toggle/dist/toggle.anatomy.mjs
var anatomy = createAnatomy("toggle", ["root", "indicator"]);
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+toggle@1.42.0/node_modules/@zag-js/toggle/dist/toggle.connect.mjs
function connect(service, normalize) {
  const { context, prop, send } = service;
  const pressed = context.get("pressed");
  return {
    pressed,
    disabled: !!prop("disabled"),
    setPressed(value) {
      send({ type: "PRESS.SET", value });
    },
    getRootProps() {
      return normalize.element({
        type: "button",
        ...parts.root.attrs,
        disabled: prop("disabled"),
        "aria-pressed": pressed,
        "data-state": pressed ? "on" : "off",
        "data-pressed": dataAttr(pressed),
        "data-disabled": dataAttr(prop("disabled")),
        onClick(event) {
          if (event.defaultPrevented) return;
          if (prop("disabled")) return;
          send({ type: "PRESS.TOGGLE" });
        }
      });
    },
    getIndicatorProps() {
      return normalize.element({
        ...parts.indicator.attrs,
        "data-disabled": dataAttr(prop("disabled")),
        "data-pressed": dataAttr(pressed),
        "data-state": pressed ? "on" : "off"
      });
    }
  };
}

// ../node_modules/.pnpm/@zag-js+toggle@1.42.0/node_modules/@zag-js/toggle/dist/toggle.machine.mjs
var machine = createMachine({
  props({ props }) {
    return {
      defaultPressed: false,
      ...props
    };
  },
  context({ prop, bindable }) {
    return {
      pressed: bindable(() => ({
        value: prop("pressed"),
        defaultValue: prop("defaultPressed"),
        onChange(value) {
          prop("onPressedChange")?.(value);
        }
      }))
    };
  },
  initialState() {
    return "idle";
  },
  on: {
    "PRESS.TOGGLE": {
      actions: ["togglePressed"]
    },
    "PRESS.SET": {
      actions: ["setPressed"]
    }
  },
  states: {
    idle: {}
  },
  implementations: {
    actions: {
      togglePressed({ context }) {
        context.set("pressed", !context.get("pressed"));
      },
      setPressed({ context, event }) {
        context.set("pressed", event.value);
      }
    }
  }
});

// components/toggle.ts
var Toggle = class extends Component {
  initMachine(props) {
    return new VanillaMachine(machine, props);
  }
  initApi() {
    return this.zagConnect(connect);
  }
  render() {
    const rootEl = this.el.querySelector('[data-scope="toggle"][data-part="root"]');
    if (!rootEl) return;
    this.spreadProps(rootEl, this.api.getRootProps());
    const indicatorEl = rootEl.querySelector(
      ':scope > [data-scope="toggle"][data-part="indicator"]'
    );
    if (indicatorEl) {
      this.spreadProps(indicatorEl, this.api.getIndicatorProps());
    }
  }
};

// hooks/toggle.ts
function pressedChangePayload(el, pressed) {
  return {
    id: el.id,
    pressed
  };
}
var ToggleHook = createZagLiveHook({
  key: "toggle",
  controlledKeys: ["pressed"],
  mount(hook, { dom, server }) {
    const el = hook.el;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);
    const controlled = getBoolean(el, "controlled");
    const pressedFromDataset = getBooleanValue(el, "pressed");
    const defaultPressedFromDataset = getBooleanValue(el, "defaultPressed");
    const toggle = new Toggle(el, {
      id: el.id,
      ...controlled ? { pressed: pressedFromDataset === true } : { defaultPressed: defaultPressedFromDataset === true },
      disabled: getBoolean(el, "disabled"),
      dir: getDir(el),
      onPressedChange: (pressed) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: pressedChangePayload(el, pressed),
          serverEventName: getString(el, "onPressedChange"),
          clientEventName: getString(el, "onPressedChangeClient")
        });
      }
    });
    dom.add("corex:toggle:set-pressed", (event) => {
      const p = event.detail?.pressed;
      if (typeof p === "boolean") toggle.api.setPressed(p);
    });
    dom.add("corex:toggle:toggle-pressed", () => {
      toggle.api.setPressed(!toggle.api.pressed);
    });
    server.add("toggle_set_pressed", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      const pressed = readPayloadPressed(payload);
      if (typeof pressed === "boolean") toggle.api.setPressed(pressed);
    });
    server.add("toggle_toggle_pressed", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      toggle.api.setPressed(!toggle.api.pressed);
    });
    server.add("toggle_pressed", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (!canPush()) return;
      hook.pushEvent("toggle_pressed_response", {
        id: el.id,
        value: toggle.api.pressed
      });
    });
    return toggle;
  },
  update(hook, toggle) {
    const pressedPatch = readPressedControlledZagUpdate(hook.el, hook.beforeAttrs);
    toggle.updateProps({
      id: hook.el.id,
      ...pressedPatch,
      disabled: getBoolean(hook.el, "disabled"),
      dir: getDir(hook.el)
    });
  }
});
export {
  ToggleHook as Toggle,
  pressedChangePayload
};
