import {
  Component,
  VanillaMachine,
  addOrRemove,
  contains,
  createAnatomy,
  createGuards,
  createMachine,
  createProps,
  createSplitProps,
  dataAttr,
  ensureProps,
  first,
  getBoolean,
  getEventKey,
  getEventTarget,
  getString,
  getStringList,
  isArray,
  isEqual,
  isSafari,
  last,
  nextById,
  normalizeProps,
  prevById,
  queryAll,
  raf
} from "./chunk-PLUM2DEK.mjs";

// ../node_modules/.pnpm/@zag-js+toggle-group@1.34.1/node_modules/@zag-js/toggle-group/dist/index.mjs
var anatomy = createAnatomy("toggle-group").parts("root", "item");
var parts = anatomy.build();
var getRootId = (ctx) => ctx.ids?.root ?? `toggle-group:${ctx.id}`;
var getItemId = (ctx, value) => ctx.ids?.item?.(value) ?? `toggle-group:${ctx.id}:${value}`;
var getRootEl = (ctx) => ctx.getById(getRootId(ctx));
var getElements = (ctx) => {
  const ownerId = CSS.escape(getRootId(ctx));
  const selector = `[data-ownedby='${ownerId}']:not([data-disabled])`;
  return queryAll(getRootEl(ctx), selector);
};
var getFirstEl = (ctx) => first(getElements(ctx));
var getLastEl = (ctx) => last(getElements(ctx));
var getNextEl = (ctx, id, loopFocus) => nextById(getElements(ctx), id, loopFocus);
var getPrevEl = (ctx, id, loopFocus) => prevById(getElements(ctx), id, loopFocus);
function connect(service, normalize) {
  const { context, send, prop, scope } = service;
  const value = context.get("value");
  const disabled = prop("disabled");
  const isSingle = !prop("multiple");
  const rovingFocus = prop("rovingFocus");
  const isHorizontal = prop("orientation") === "horizontal";
  function getItemState(props2) {
    const id = getItemId(scope, props2.value);
    return {
      id,
      disabled: Boolean(props2.disabled || disabled),
      pressed: !!value.includes(props2.value),
      focused: context.get("focusedId") === id
    };
  }
  return {
    value,
    setValue(value2) {
      send({ type: "VALUE.SET", value: value2 });
    },
    getRootProps() {
      return normalize.element({
        ...parts.root.attrs,
        id: getRootId(scope),
        dir: prop("dir"),
        role: isSingle ? "radiogroup" : "group",
        tabIndex: context.get("isTabbingBackward") ? -1 : 0,
        "data-disabled": dataAttr(disabled),
        "data-orientation": prop("orientation"),
        "data-focus": dataAttr(context.get("focusedId") != null),
        style: { outline: "none" },
        onMouseDown() {
          if (disabled) return;
          send({ type: "ROOT.MOUSE_DOWN" });
        },
        onFocus(event) {
          if (disabled) return;
          if (event.currentTarget !== getEventTarget(event)) return;
          if (context.get("isClickFocus")) return;
          if (context.get("isTabbingBackward")) return;
          send({ type: "ROOT.FOCUS" });
        },
        onBlur(event) {
          const target = event.relatedTarget;
          if (contains(event.currentTarget, target)) return;
          if (disabled) return;
          send({ type: "ROOT.BLUR" });
        }
      });
    },
    getItemState,
    getItemProps(props2) {
      const itemState = getItemState(props2);
      const rovingTabIndex = itemState.focused ? 0 : -1;
      return normalize.button({
        ...parts.item.attrs,
        id: itemState.id,
        type: "button",
        "data-ownedby": getRootId(scope),
        "data-focus": dataAttr(itemState.focused),
        disabled: itemState.disabled,
        tabIndex: rovingFocus ? rovingTabIndex : void 0,
        // radio
        role: isSingle ? "radio" : void 0,
        "aria-checked": isSingle ? itemState.pressed : void 0,
        "aria-pressed": isSingle ? void 0 : itemState.pressed,
        //
        "data-disabled": dataAttr(itemState.disabled),
        "data-orientation": prop("orientation"),
        dir: prop("dir"),
        "data-state": itemState.pressed ? "on" : "off",
        onFocus() {
          if (itemState.disabled) return;
          send({ type: "TOGGLE.FOCUS", id: itemState.id });
        },
        onClick(event) {
          if (itemState.disabled) return;
          send({ type: "TOGGLE.CLICK", id: itemState.id, value: props2.value });
          if (isSafari()) {
            event.currentTarget.focus({ preventScroll: true });
          }
        },
        onKeyDown(event) {
          if (event.defaultPrevented) return;
          if (!contains(event.currentTarget, getEventTarget(event))) return;
          if (itemState.disabled) return;
          const keyMap = {
            Tab(event2) {
              const isShiftTab = event2.shiftKey;
              send({ type: "TOGGLE.SHIFT_TAB", isShiftTab });
            },
            ArrowLeft() {
              if (!rovingFocus || !isHorizontal) return;
              send({ type: "TOGGLE.FOCUS_PREV" });
            },
            ArrowRight() {
              if (!rovingFocus || !isHorizontal) return;
              send({ type: "TOGGLE.FOCUS_NEXT" });
            },
            ArrowUp() {
              if (!rovingFocus || isHorizontal) return;
              send({ type: "TOGGLE.FOCUS_PREV" });
            },
            ArrowDown() {
              if (!rovingFocus || isHorizontal) return;
              send({ type: "TOGGLE.FOCUS_NEXT" });
            },
            Home() {
              if (!rovingFocus) return;
              send({ type: "TOGGLE.FOCUS_FIRST" });
            },
            End() {
              if (!rovingFocus) return;
              send({ type: "TOGGLE.FOCUS_LAST" });
            }
          };
          const exec = keyMap[getEventKey(event)];
          if (exec) {
            exec(event);
            if (event.key !== "Tab") event.preventDefault();
          }
        }
      });
    }
  };
}
var { not, and } = createGuards();
var machine = createMachine({
  props({ props: props2 }) {
    return {
      defaultValue: [],
      orientation: "horizontal",
      rovingFocus: true,
      loopFocus: true,
      deselectable: true,
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
      focusedId: bindable(() => ({
        defaultValue: null
      })),
      isTabbingBackward: bindable(() => ({
        defaultValue: false
      })),
      isClickFocus: bindable(() => ({
        defaultValue: false
      })),
      isWithinToolbar: bindable(() => ({
        defaultValue: false
      }))
    };
  },
  computed: {
    currentLoopFocus: ({ context, prop }) => prop("loopFocus") && !context.get("isWithinToolbar")
  },
  entry: ["checkIfWithinToolbar"],
  on: {
    "VALUE.SET": {
      actions: ["setValue"]
    },
    "TOGGLE.CLICK": {
      actions: ["setValue"]
    },
    "ROOT.MOUSE_DOWN": {
      actions: ["setClickFocus"]
    }
  },
  states: {
    idle: {
      on: {
        "ROOT.FOCUS": {
          target: "focused",
          guard: not(and("isClickFocus", "isTabbingBackward")),
          actions: ["focusFirstToggle", "clearClickFocus"]
        },
        "TOGGLE.FOCUS": {
          target: "focused",
          actions: ["setFocusedId"]
        }
      }
    },
    focused: {
      on: {
        "ROOT.BLUR": {
          target: "idle",
          actions: ["clearIsTabbingBackward", "clearFocusedId", "clearClickFocus"]
        },
        "TOGGLE.FOCUS": {
          actions: ["setFocusedId"]
        },
        "TOGGLE.FOCUS_NEXT": {
          actions: ["focusNextToggle"]
        },
        "TOGGLE.FOCUS_PREV": {
          actions: ["focusPrevToggle"]
        },
        "TOGGLE.FOCUS_FIRST": {
          actions: ["focusFirstToggle"]
        },
        "TOGGLE.FOCUS_LAST": {
          actions: ["focusLastToggle"]
        },
        "TOGGLE.SHIFT_TAB": [
          {
            guard: not("isFirstToggleFocused"),
            target: "idle",
            actions: ["setIsTabbingBackward"]
          },
          {
            actions: ["setIsTabbingBackward"]
          }
        ]
      }
    }
  },
  implementations: {
    guards: {
      isClickFocus: ({ context }) => context.get("isClickFocus"),
      isTabbingBackward: ({ context }) => context.get("isTabbingBackward"),
      isFirstToggleFocused: ({ context, scope }) => context.get("focusedId") === getFirstEl(scope)?.id
    },
    actions: {
      setIsTabbingBackward({ context }) {
        context.set("isTabbingBackward", true);
      },
      clearIsTabbingBackward({ context }) {
        context.set("isTabbingBackward", false);
      },
      setClickFocus({ context }) {
        context.set("isClickFocus", true);
      },
      clearClickFocus({ context }) {
        context.set("isClickFocus", false);
      },
      checkIfWithinToolbar({ context, scope }) {
        const closestToolbar = getRootEl(scope)?.closest("[role=toolbar]");
        context.set("isWithinToolbar", !!closestToolbar);
      },
      setFocusedId({ context, event }) {
        context.set("focusedId", event.id);
      },
      clearFocusedId({ context }) {
        context.set("focusedId", null);
      },
      setValue({ context, event, prop }) {
        ensureProps(event, ["value"]);
        let next = context.get("value");
        if (isArray(event.value)) {
          next = event.value;
        } else if (prop("multiple")) {
          next = addOrRemove(next, event.value);
        } else {
          const isSelected = isEqual(next, [event.value]);
          next = isSelected && prop("deselectable") ? [] : [event.value];
        }
        context.set("value", next);
      },
      focusNextToggle({ context, scope, prop }) {
        raf(() => {
          const focusedId = context.get("focusedId");
          if (!focusedId) return;
          getNextEl(scope, focusedId, prop("loopFocus"))?.focus({ preventScroll: true });
        });
      },
      focusPrevToggle({ context, scope, prop }) {
        raf(() => {
          const focusedId = context.get("focusedId");
          if (!focusedId) return;
          getPrevEl(scope, focusedId, prop("loopFocus"))?.focus({ preventScroll: true });
        });
      },
      focusFirstToggle({ scope }) {
        raf(() => {
          getFirstEl(scope)?.focus({ preventScroll: true });
        });
      },
      focusLastToggle({ scope }) {
        raf(() => {
          getLastEl(scope)?.focus({ preventScroll: true });
        });
      }
    }
  }
});
var props = createProps()([
  "dir",
  "disabled",
  "getRootNode",
  "id",
  "ids",
  "loopFocus",
  "multiple",
  "onValueChange",
  "orientation",
  "rovingFocus",
  "value",
  "defaultValue",
  "deselectable"
]);
var splitProps = createSplitProps(props);
var itemProps = createProps()(["value", "disabled"]);
var splitItemProps = createSplitProps(itemProps);

// components/toggle-group.ts
var ToggleGroup = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props2) {
    return new VanillaMachine(machine, props2);
  }
  initApi() {
    return connect(this.machine.service, normalizeProps);
  }
  render() {
    const rootEl = this.el.querySelector(
      '[data-scope="toggle-group"][data-part="root"]'
    );
    if (!rootEl) return;
    this.spreadProps(rootEl, this.api.getRootProps());
    const items = this.el.querySelectorAll(
      '[data-scope="toggle-group"][data-part="item"]'
    );
    for (let i = 0; i < items.length; i++) {
      const itemEl = items[i];
      const value = getString(itemEl, "value");
      if (!value) continue;
      const disabled = getBoolean(itemEl, "disabled");
      this.spreadProps(itemEl, this.api.getItemProps({ value, disabled }));
    }
  }
};

// hooks/toggle-group.ts
var ToggleGroupHook = {
  mounted() {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const props2 = {
      id: el.id,
      ...getBoolean(el, "controlled") ? { value: getStringList(el, "value") } : { defaultValue: getStringList(el, "defaultValue") },
      defaultValue: getStringList(el, "defaultValue"),
      deselectable: getBoolean(el, "deselectable"),
      loopFocus: getBoolean(el, "loopFocus"),
      rovingFocus: getBoolean(el, "rovingFocus"),
      disabled: getBoolean(el, "disabled"),
      multiple: getBoolean(el, "multiple"),
      orientation: getString(el, "orientation", ["horizontal", "vertical"]),
      dir: getString(el, "dir", ["ltr", "rtl"]),
      onValueChange: (details) => {
        const eventName = getString(el, "onValueChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            value: details.value,
            id: el.id
          });
        }
        const eventNameClient = getString(el, "onValueChangeClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
              bubbles: true,
              detail: {
                value: details.value,
                id: el.id
              }
            })
          );
        }
      }
    };
    const toggleGroup = new ToggleGroup(el, props2);
    toggleGroup.init();
    this.toggleGroup = toggleGroup;
    this.onSetValue = (event) => {
      const { value } = event.detail;
      toggleGroup.api.setValue(value);
    };
    el.addEventListener("phx:toggle-group:set-value", this.onSetValue);
    this.handlers = [];
    this.handlers.push(
      this.handleEvent("toggle-group_set_value", (payload) => {
        const targetId = payload.id;
        if (targetId && targetId !== el.id) return;
        toggleGroup.api.setValue(payload.value);
      })
    );
    this.handlers.push(
      this.handleEvent("toggle-group:value", () => {
        this.pushEvent("toggle-group:value_response", {
          value: toggleGroup.api.value
        });
      })
    );
  },
  updated() {
    this.toggleGroup?.updateProps({
      ...getBoolean(this.el, "controlled") ? { value: getStringList(this.el, "value") } : { defaultValue: getStringList(this.el, "defaultValue") },
      deselectable: getBoolean(this.el, "deselectable"),
      loopFocus: getBoolean(this.el, "loopFocus"),
      rovingFocus: getBoolean(this.el, "rovingFocus"),
      disabled: getBoolean(this.el, "disabled"),
      multiple: getBoolean(this.el, "multiple"),
      orientation: getString(this.el, "orientation", ["horizontal", "vertical"]),
      dir: getString(this.el, "dir", ["ltr", "rtl"])
    });
  },
  destroyed() {
    if (this.onSetValue) {
      this.el.removeEventListener("phx:toggle-group:set-value", this.onSetValue);
    }
    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }
    this.toggleGroup?.destroy();
  }
};
export {
  ToggleGroupHook as ToggleGroup
};
