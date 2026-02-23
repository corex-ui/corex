import {
  Component,
  VanillaMachine,
  add,
  createAnatomy,
  createGuards,
  createMachine,
  createProps,
  createSplitProps,
  dataAttr,
  first,
  getBoolean,
  getDir,
  getEventKey,
  getString,
  getStringList,
  isSafari,
  last,
  nextById,
  normalizeProps,
  prevById,
  queryAll,
  remove,
  warn
} from "./chunk-PLUM2DEK.mjs";

// ../node_modules/.pnpm/@zag-js+accordion@1.34.1/node_modules/@zag-js/accordion/dist/index.mjs
var anatomy = createAnatomy("accordion").parts("root", "item", "itemTrigger", "itemContent", "itemIndicator");
var parts = anatomy.build();
var getRootId = (ctx) => ctx.ids?.root ?? `accordion:${ctx.id}`;
var getItemId = (ctx, value) => ctx.ids?.item?.(value) ?? `accordion:${ctx.id}:item:${value}`;
var getItemContentId = (ctx, value) => ctx.ids?.itemContent?.(value) ?? `accordion:${ctx.id}:content:${value}`;
var getItemTriggerId = (ctx, value) => ctx.ids?.itemTrigger?.(value) ?? `accordion:${ctx.id}:trigger:${value}`;
var getRootEl = (ctx) => ctx.getById(getRootId(ctx));
var getTriggerEls = (ctx) => {
  const ownerId = CSS.escape(getRootId(ctx));
  const selector = `[data-controls][data-ownedby='${ownerId}']:not([disabled])`;
  return queryAll(getRootEl(ctx), selector);
};
var getFirstTriggerEl = (ctx) => first(getTriggerEls(ctx));
var getLastTriggerEl = (ctx) => last(getTriggerEls(ctx));
var getNextTriggerEl = (ctx, id) => nextById(getTriggerEls(ctx), getItemTriggerId(ctx, id));
var getPrevTriggerEl = (ctx, id) => prevById(getTriggerEls(ctx), getItemTriggerId(ctx, id));
function connect(service, normalize) {
  const { send, context, prop, scope, computed } = service;
  const focusedValue = context.get("focusedValue");
  const value = context.get("value");
  const multiple = prop("multiple");
  function setValue(value2) {
    let nextValue = value2;
    if (!multiple && nextValue.length > 1) {
      nextValue = [nextValue[0]];
    }
    send({ type: "VALUE.SET", value: nextValue });
  }
  function getItemState(props2) {
    return {
      expanded: value.includes(props2.value),
      focused: focusedValue === props2.value,
      disabled: Boolean(props2.disabled ?? prop("disabled"))
    };
  }
  return {
    focusedValue,
    value,
    setValue,
    getItemState,
    getRootProps() {
      return normalize.element({
        ...parts.root.attrs,
        dir: prop("dir"),
        id: getRootId(scope),
        "data-orientation": prop("orientation")
      });
    },
    getItemProps(props2) {
      const itemState = getItemState(props2);
      return normalize.element({
        ...parts.item.attrs,
        dir: prop("dir"),
        id: getItemId(scope, props2.value),
        "data-state": itemState.expanded ? "open" : "closed",
        "data-focus": dataAttr(itemState.focused),
        "data-disabled": dataAttr(itemState.disabled),
        "data-orientation": prop("orientation")
      });
    },
    getItemContentProps(props2) {
      const itemState = getItemState(props2);
      return normalize.element({
        ...parts.itemContent.attrs,
        dir: prop("dir"),
        role: "region",
        id: getItemContentId(scope, props2.value),
        "aria-labelledby": getItemTriggerId(scope, props2.value),
        hidden: !itemState.expanded,
        "data-state": itemState.expanded ? "open" : "closed",
        "data-disabled": dataAttr(itemState.disabled),
        "data-focus": dataAttr(itemState.focused),
        "data-orientation": prop("orientation")
      });
    },
    getItemIndicatorProps(props2) {
      const itemState = getItemState(props2);
      return normalize.element({
        ...parts.itemIndicator.attrs,
        dir: prop("dir"),
        "aria-hidden": true,
        "data-state": itemState.expanded ? "open" : "closed",
        "data-disabled": dataAttr(itemState.disabled),
        "data-focus": dataAttr(itemState.focused),
        "data-orientation": prop("orientation")
      });
    },
    getItemTriggerProps(props2) {
      const { value: value2 } = props2;
      const itemState = getItemState(props2);
      return normalize.button({
        ...parts.itemTrigger.attrs,
        type: "button",
        dir: prop("dir"),
        id: getItemTriggerId(scope, value2),
        "aria-controls": getItemContentId(scope, value2),
        "data-controls": getItemContentId(scope, value2),
        "aria-expanded": itemState.expanded,
        disabled: itemState.disabled,
        "data-orientation": prop("orientation"),
        "aria-disabled": itemState.disabled,
        "data-state": itemState.expanded ? "open" : "closed",
        "data-ownedby": getRootId(scope),
        onFocus() {
          if (itemState.disabled) return;
          send({ type: "TRIGGER.FOCUS", value: value2 });
        },
        onBlur() {
          if (itemState.disabled) return;
          send({ type: "TRIGGER.BLUR" });
        },
        onClick(event) {
          if (itemState.disabled) return;
          if (isSafari()) {
            event.currentTarget.focus();
          }
          send({ type: "TRIGGER.CLICK", value: value2 });
        },
        onKeyDown(event) {
          if (event.defaultPrevented) return;
          if (itemState.disabled) return;
          const keyMap = {
            ArrowDown() {
              if (computed("isHorizontal")) return;
              send({ type: "GOTO.NEXT", value: value2 });
            },
            ArrowUp() {
              if (computed("isHorizontal")) return;
              send({ type: "GOTO.PREV", value: value2 });
            },
            ArrowRight() {
              if (!computed("isHorizontal")) return;
              send({ type: "GOTO.NEXT", value: value2 });
            },
            ArrowLeft() {
              if (!computed("isHorizontal")) return;
              send({ type: "GOTO.PREV", value: value2 });
            },
            Home() {
              send({ type: "GOTO.FIRST", value: value2 });
            },
            End() {
              send({ type: "GOTO.LAST", value: value2 });
            }
          };
          const key = getEventKey(event, {
            dir: prop("dir"),
            orientation: prop("orientation")
          });
          const exec = keyMap[key];
          if (exec) {
            exec(event);
            event.preventDefault();
          }
        }
      });
    }
  };
}
var { and, not } = createGuards();
var machine = createMachine({
  props({ props: props2 }) {
    return {
      collapsible: false,
      multiple: false,
      orientation: "vertical",
      defaultValue: [],
      ...props2
    };
  },
  initialState() {
    return "idle";
  },
  context({ prop, bindable }) {
    return {
      focusedValue: bindable(() => ({
        defaultValue: null,
        sync: true,
        onChange(value) {
          prop("onFocusChange")?.({ value });
        }
      })),
      value: bindable(() => ({
        defaultValue: prop("defaultValue"),
        value: prop("value"),
        onChange(value) {
          prop("onValueChange")?.({ value });
        }
      }))
    };
  },
  computed: {
    isHorizontal: ({ prop }) => prop("orientation") === "horizontal"
  },
  on: {
    "VALUE.SET": {
      actions: ["setValue"]
    }
  },
  states: {
    idle: {
      on: {
        "TRIGGER.FOCUS": {
          target: "focused",
          actions: ["setFocusedValue"]
        }
      }
    },
    focused: {
      on: {
        "GOTO.NEXT": {
          actions: ["focusNextTrigger"]
        },
        "GOTO.PREV": {
          actions: ["focusPrevTrigger"]
        },
        "TRIGGER.CLICK": [
          {
            guard: and("isExpanded", "canToggle"),
            actions: ["collapse"]
          },
          {
            guard: not("isExpanded"),
            actions: ["expand"]
          }
        ],
        "GOTO.FIRST": {
          actions: ["focusFirstTrigger"]
        },
        "GOTO.LAST": {
          actions: ["focusLastTrigger"]
        },
        "TRIGGER.BLUR": {
          target: "idle",
          actions: ["clearFocusedValue"]
        }
      }
    }
  },
  implementations: {
    guards: {
      canToggle: ({ prop }) => !!prop("collapsible") || !!prop("multiple"),
      isExpanded: ({ context, event }) => context.get("value").includes(event.value)
    },
    actions: {
      collapse({ context, prop, event }) {
        const next = prop("multiple") ? remove(context.get("value"), event.value) : [];
        context.set("value", next);
      },
      expand({ context, prop, event }) {
        const next = prop("multiple") ? add(context.get("value"), event.value) : [event.value];
        context.set("value", next);
      },
      focusFirstTrigger({ scope }) {
        getFirstTriggerEl(scope)?.focus();
      },
      focusLastTrigger({ scope }) {
        getLastTriggerEl(scope)?.focus();
      },
      focusNextTrigger({ context, scope }) {
        const focusedValue = context.get("focusedValue");
        if (!focusedValue) return;
        const triggerEl = getNextTriggerEl(scope, focusedValue);
        triggerEl?.focus();
      },
      focusPrevTrigger({ context, scope }) {
        const focusedValue = context.get("focusedValue");
        if (!focusedValue) return;
        const triggerEl = getPrevTriggerEl(scope, focusedValue);
        triggerEl?.focus();
      },
      setFocusedValue({ context, event }) {
        context.set("focusedValue", event.value);
      },
      clearFocusedValue({ context }) {
        context.set("focusedValue", null);
      },
      setValue({ context, event }) {
        context.set("value", event.value);
      },
      coarseValue({ context, prop }) {
        if (!prop("multiple") && context.get("value").length > 1) {
          warn(`The value of accordion should be a single value when multiple is false.`);
          context.set("value", [context.get("value")[0]]);
        }
      }
    }
  }
});
var props = createProps()([
  "collapsible",
  "dir",
  "disabled",
  "getRootNode",
  "id",
  "ids",
  "multiple",
  "onFocusChange",
  "onValueChange",
  "orientation",
  "value",
  "defaultValue"
]);
var splitProps = createSplitProps(props);
var itemProps = createProps()(["value", "disabled"]);
var splitItemProps = createSplitProps(itemProps);

// components/accordion.ts
var Accordion = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props2) {
    return new VanillaMachine(machine, props2);
  }
  initApi() {
    return connect(this.machine.service, normalizeProps);
  }
  render() {
    const rootEl = this.el.querySelector('[data-scope="accordion"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());
    const itemsList = this.getItemsList();
    const itemEls = rootEl.querySelectorAll(
      '[data-scope="accordion"][data-part="item"]'
    );
    for (let i = 0; i < itemEls.length; i++) {
      const itemEl = itemEls[i];
      const itemData = itemsList[i];
      if (!itemData?.value) continue;
      const { value, disabled } = itemData;
      this.spreadProps(itemEl, this.api.getItemProps({ value, disabled }));
      const triggerEl = itemEl.querySelector(
        '[data-scope="accordion"][data-part="item-trigger"]'
      );
      if (triggerEl) {
        this.spreadProps(triggerEl, this.api.getItemTriggerProps({ value, disabled }));
      }
      const indicatorEl = itemEl.querySelector(
        '[data-scope="accordion"][data-part="item-indicator"]'
      );
      if (indicatorEl) {
        this.spreadProps(indicatorEl, this.api.getItemIndicatorProps({ value, disabled }));
      }
      const contentEl = itemEl.querySelector(
        '[data-scope="accordion"][data-part="item-content"]'
      );
      if (contentEl) {
        this.spreadProps(contentEl, this.api.getItemContentProps({ value, disabled }));
      }
    }
  }
  getItemsList() {
    const raw = this.el.getAttribute("data-items");
    if (!raw) return [];
    try {
      return JSON.parse(raw);
    } catch {
      return [];
    }
  }
};

// hooks/accordion.ts
var AccordionHook = {
  mounted() {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const accordion = new Accordion(el, {
      id: el.id,
      ...getBoolean(el, "controlled") ? { value: getStringList(el, "value") } : { defaultValue: getStringList(el, "defaultValue") },
      collapsible: getBoolean(el, "collapsible"),
      multiple: getBoolean(el, "multiple"),
      orientation: getString(el, "orientation", ["horizontal", "vertical"]),
      dir: getDir(el),
      onValueChange: (details) => {
        const eventName = getString(el, "onValueChange");
        if (eventName && this.liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            id: el.id,
            value: details.value ?? null
          });
        }
        const eventNameClient = getString(el, "onValueChangeClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
              bubbles: true,
              detail: {
                id: el.id,
                value: details.value ?? null
              }
            })
          );
        }
      },
      onFocusChange: (details) => {
        const eventName = getString(el, "onFocusChange");
        if (eventName && this.liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            id: el.id,
            value: details.value ?? null
          });
        }
        const eventNameClient = getString(el, "onFocusChangeClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
              bubbles: true,
              detail: {
                id: el.id,
                value: details.value ?? null
              }
            })
          );
        }
      }
    });
    accordion.init();
    this.accordion = accordion;
    this.onSetValue = (event) => {
      const { value } = event.detail;
      accordion.api.setValue(value);
    };
    el.addEventListener("phx:accordion:set-value", this.onSetValue);
    this.handlers = [];
    this.handlers.push(
      this.handleEvent(
        "accordion_set_value",
        (payload) => {
          const targetId = payload.accordion_id;
          if (targetId) {
            const matches = el.id === targetId || el.id === `accordion:${targetId}`;
            if (!matches) return;
          }
          accordion.api.setValue(payload.value);
        }
      )
    );
    this.handlers.push(
      this.handleEvent("accordion_value", () => {
        this.pushEvent("accordion_value_response", {
          value: accordion.api.value
        });
      })
    );
    this.handlers.push(
      this.handleEvent("accordion_focused_value", () => {
        this.pushEvent("accordion_focused_value_response", {
          value: accordion.api.focusedValue
        });
      })
    );
  },
  updated() {
    const controlled = getBoolean(this.el, "controlled");
    this.accordion?.updateProps({
      id: this.el.id,
      ...controlled ? { value: getStringList(this.el, "value") } : {
        defaultValue: this.accordion?.api?.value ?? getStringList(this.el, "defaultValue")
      },
      collapsible: getBoolean(this.el, "collapsible"),
      multiple: getBoolean(this.el, "multiple"),
      orientation: getString(this.el, "orientation", ["horizontal", "vertical"]),
      dir: getDir(this.el)
    });
  },
  destroyed() {
    if (this.onSetValue) {
      this.el.removeEventListener("phx:accordion:set-value", this.onSetValue);
    }
    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }
    this.accordion?.destroy();
  }
};
export {
  AccordionHook as Accordion
};
