import {
  readPressedControlledZagUpdate
} from "./chunks/chunk-I2HPUDHJ.mjs";
import {
  createDomEventRegistry,
  createHookHandleEventRegistry
} from "./chunks/chunk-77HPO22C.mjs";
import {
  idMatches,
  notifyChange,
  readPayloadId,
  readPayloadPressed
} from "./chunks/chunk-2WCNJX5P.mjs";
import {
  Component,
  VanillaMachine,
  canPushEvent,
  createAnatomy,
  createMachine,
  dataAttr,
  getBoolean,
  getBooleanValue,
  getDir,
  getString
} from "./chunks/chunk-2GQRP3FN.mjs";

// ../node_modules/.pnpm/@zag-js+toggle@1.40.0/node_modules/@zag-js/toggle/dist/toggle.anatomy.mjs
var anatomy = createAnatomy("toggle", ["root", "indicator"]);
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+toggle@1.40.0/node_modules/@zag-js/toggle/dist/toggle.connect.mjs
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

// ../node_modules/.pnpm/@zag-js+toggle@1.40.0/node_modules/@zag-js/toggle/dist/toggle.machine.mjs
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
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
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
var ToggleHook = {
  mounted() {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
    const controlled = getBoolean(el, "controlled");
    const pressedFromDataset = getBooleanValue(el, "pressed");
    const defaultPressedFromDataset = getBooleanValue(el, "defaultPressed");
    const zagToggle = new Toggle(el, {
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
    zagToggle.init();
    this.zagToggle = zagToggle;
    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;
    domRegistry.add("corex:toggle:set-pressed", (event) => {
      const p = event.detail?.pressed;
      if (typeof p === "boolean") zagToggle.api.setPressed(p);
    });
    domRegistry.add("corex:toggle:toggle-pressed", () => {
      zagToggle.api.setPressed(!zagToggle.api.pressed);
    });
    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;
    registry.add("toggle_set_pressed", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      const pressed = readPayloadPressed(payload);
      if (typeof pressed === "boolean") zagToggle.api.setPressed(pressed);
    });
    registry.add("toggle_toggle_pressed", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zagToggle.api.setPressed(!zagToggle.api.pressed);
    });
    registry.add("toggle_pressed", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (!canPush()) return;
      this.pushEvent("toggle_pressed_response", {
        id: el.id,
        value: zagToggle.api.pressed
      });
    });
  },
  updated() {
    this.zagToggle?.updateProps({
      id: this.el.id,
      ...readPressedControlledZagUpdate(this.el),
      disabled: getBoolean(this.el, "disabled"),
      dir: getDir(this.el)
    });
  },
  destroyed() {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.zagToggle?.destroy();
  }
};
export {
  ToggleHook as Toggle,
  pressedChangePayload
};
