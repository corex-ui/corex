import {
  diffStringValues
} from "./chunks/chunk-JDGMEOQK.mjs";
import {
  closestPartValue,
  isJsAnimation,
  prepareJsHeightInitialState,
  runHeightOpenToValues,
  runHeightOpenTransition,
  stripHiddenFromProps
} from "./chunks/chunk-XI7CXJ3V.mjs";
import {
  readControlledOrDefaultStringList,
  readStringListControlledZagProps
} from "./chunks/chunk-B34HSI73.mjs";
import {
  createDomEventRegistry,
  createHookHandleEventRegistry
} from "./chunks/chunk-77HPO22C.mjs";
import {
  createValueEmitter,
  emitResponse,
  idMatches,
  notifyChange,
  parseRespondTo,
  readPayloadId
} from "./chunks/chunk-2WCNJX5P.mjs";
import {
  Component,
  VanillaMachine,
  add,
  canPushEvent,
  createAnatomy,
  createGuards,
  createMachine,
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
  prevById,
  queryAll,
  remove,
  warn
} from "./chunks/chunk-EWT2BP2N.mjs";

// ../node_modules/.pnpm/@zag-js+accordion@1.40.0/node_modules/@zag-js/accordion/dist/accordion.anatomy.mjs
var anatomy = createAnatomy("accordion").parts("root", "item", "itemTrigger", "itemContent", "itemIndicator");
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+accordion@1.40.0/node_modules/@zag-js/accordion/dist/accordion.dom.mjs
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

// ../node_modules/.pnpm/@zag-js+accordion@1.40.0/node_modules/@zag-js/accordion/dist/accordion.connect.mjs
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
  function getItemState(props) {
    return {
      expanded: value.includes(props.value),
      focused: focusedValue === props.value,
      disabled: Boolean(props.disabled ?? prop("disabled"))
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
    getItemProps(props) {
      const itemState = getItemState(props);
      return normalize.element({
        ...parts.item.attrs,
        dir: prop("dir"),
        id: getItemId(scope, props.value),
        "data-state": itemState.expanded ? "open" : "closed",
        "data-focus": dataAttr(itemState.focused),
        "data-disabled": dataAttr(itemState.disabled),
        "data-orientation": prop("orientation")
      });
    },
    getItemContentProps(props) {
      const itemState = getItemState(props);
      return normalize.element({
        ...parts.itemContent.attrs,
        dir: prop("dir"),
        role: "region",
        id: getItemContentId(scope, props.value),
        "aria-labelledby": getItemTriggerId(scope, props.value),
        hidden: !itemState.expanded,
        "data-state": itemState.expanded ? "open" : "closed",
        "data-disabled": dataAttr(itemState.disabled),
        "data-focus": dataAttr(itemState.focused),
        "data-orientation": prop("orientation")
      });
    },
    getItemIndicatorProps(props) {
      const itemState = getItemState(props);
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
    getItemTriggerProps(props) {
      const { value: value2 } = props;
      const itemState = getItemState(props);
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
        "data-focus": dataAttr(itemState.focused),
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

// ../node_modules/.pnpm/@zag-js+accordion@1.40.0/node_modules/@zag-js/accordion/dist/accordion.machine.mjs
var { and, not } = createGuards();
var machine = createMachine({
  props({ props }) {
    return {
      collapsible: false,
      multiple: false,
      orientation: "vertical",
      defaultValue: [],
      ...props
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

// components/accordion.ts
var Accordion = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props) {
    return new VanillaMachine(machine, props);
  }
  initApi() {
    return this.zagConnect(connect);
  }
  render() {
    const rootEl = this.el.querySelector('[data-scope="accordion"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());
    const scopeId = this.el.id;
    const itemPrefix = scopeId ? `accordion:${scopeId}:item:` : "";
    const itemEls = rootEl.querySelectorAll(
      '[data-scope="accordion"][data-part="item"]'
    );
    const animation = this.el.dataset.animation ?? "instant";
    for (const itemEl of itemEls) {
      if (itemPrefix && !itemEl.id.startsWith(itemPrefix)) continue;
      const value = itemEl.dataset.value;
      if (!value) continue;
      const disabled = itemEl.dataset.disabled === "";
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
        if (animation === "instant") {
          this.spreadProps(contentEl, this.api.getItemContentProps({ value, disabled }));
        } else if (animation === "js" || animation === "custom") {
          this.spreadProps(
            contentEl,
            stripHiddenFromProps(
              this.api.getItemContentProps({ value, disabled })
            )
          );
          contentEl.removeAttribute("hidden");
        }
      }
    }
  }
};

// hooks/accordion.ts
var ITEM_CONTENT_SELECTOR = '[data-scope="accordion"][data-part="item-content"]';
var ITEM_SELECTOR = '[data-scope="accordion"][data-part="item"]';
var resolveAccordionValue = closestPartValue(ITEM_SELECTOR);
function readAccordionLayoutProps(el) {
  return {
    id: el.id,
    collapsible: getBoolean(el, "collapsible"),
    multiple: getBoolean(el, "multiple"),
    orientation: getString(el, "orientation"),
    dir: getDir(el)
  };
}
var AccordionHook = {
  mounted() {
    const el = this.el;
    const self = this;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
    self.lastValue = readControlledOrDefaultStringList(el, "value", "defaultValue");
    const accordion = new Accordion(el, {
      id: el.id,
      ...readStringListControlledZagProps(el, "value", "defaultValue"),
      collapsible: getBoolean(el, "collapsible"),
      multiple: getBoolean(el, "multiple"),
      orientation: getString(el, "orientation"),
      dir: getDir(el),
      onValueChange: (details) => {
        const next = details.value ?? [];
        const previousValue = self.lastValue ?? [];
        const { added, removed } = diffStringValues(next, previousValue);
        self.lastValue = next;
        const payload = {
          id: el.id,
          value: next,
          previousValue,
          added,
          removed
        };
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload,
          serverEventName: getString(el, "onValueChange"),
          clientEventName: getString(el, "onValueChangeClient")
        });
        if (isJsAnimation(el) && !getBoolean(el, "controlled")) {
          runHeightOpenToValues({
            el,
            selector: ITEM_CONTENT_SELECTOR,
            openValues: next,
            resolveValue: resolveAccordionValue
          });
        }
      },
      onFocusChange: (details) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: { id: el.id, value: details.value ?? null },
          serverEventName: getString(el, "onFocusChange"),
          clientEventName: getString(el, "onFocusChangeClient")
        });
      }
    });
    accordion.init();
    this.accordion = accordion;
    prepareJsHeightInitialState(el, ITEM_CONTENT_SELECTOR);
    const hookApi = { el, pushEvent, canPushServer: canPush };
    const emitValue = createValueEmitter(hookApi, {
      getValue: () => accordion.api.value,
      serverEventName: "accordion_value_response",
      domEventName: "accordion-value"
    });
    const emitFocusedValue = createValueEmitter(hookApi, {
      getValue: () => accordion.api.focusedValue,
      serverEventName: "accordion_focused_response",
      domEventName: "accordion-focused"
    });
    const emitItemState = (itemValue, disabled, respondTo) => {
      const props = { value: itemValue, disabled };
      const state = accordion.api.getItemState(props);
      emitResponse({
        respondTo,
        canPushServer: canPush(),
        pushEvent,
        serverEventName: "accordion_item_state_response",
        serverPayload: {
          id: el.id,
          value: itemValue,
          state: {
            expanded: state.expanded,
            focused: state.focused,
            disabled: state.disabled
          }
        },
        el,
        domEventName: "accordion-item-state",
        domDetail: { id: el.id, value: itemValue, state }
      });
    };
    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;
    domRegistry.add("corex:accordion:set-value", (event) => {
      accordion.api.setValue(event.detail.value);
    });
    domRegistry.add("corex:accordion:value", (event) => {
      emitValue(parseRespondTo(event.detail));
    });
    domRegistry.add("corex:accordion:focused", (event) => {
      emitFocusedValue(parseRespondTo(event.detail));
    });
    domRegistry.add(
      "corex:accordion:item-state",
      (event) => {
        const d = event.detail;
        const v = d?.value;
        if (typeof v !== "string" || v === "") return;
        emitItemState(v, d?.disabled === true, parseRespondTo(d));
      }
    );
    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;
    registry.add("accordion_set_value", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      accordion.api.setValue(payload.value);
    });
    registry.add("accordion_value", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitValue(parseRespondTo(payload));
    });
    registry.add("accordion_focused", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitFocusedValue(parseRespondTo(payload));
    });
    registry.add(
      "accordion_item_state",
      (payload) => {
        if (!idMatches(el.id, readPayloadId(payload))) return;
        if (typeof payload?.value !== "string" || payload.value === "") return;
        emitItemState(payload.value, payload.disabled === true, parseRespondTo(payload));
      }
    );
  },
  beforeUpdate() {
    const { el } = this;
    if (getBoolean(el, "controlled") && isJsAnimation(el)) {
      this.previousValue = getStringList(el, "value") ?? [];
    }
  },
  updated() {
    const { el } = this;
    const layout = readAccordionLayoutProps(el);
    if (!getBoolean(el, "controlled")) {
      this.accordion?.updateProps(layout);
      return;
    }
    const nextValue = getStringList(el, "value") ?? [];
    const prevValue = this.previousValue ?? this.lastValue ?? [];
    this.previousValue = void 0;
    this.lastValue = nextValue;
    runHeightOpenTransition({
      el,
      selector: ITEM_CONTENT_SELECTOR,
      prevOpen: prevValue,
      nextOpen: nextValue,
      resolveValue: resolveAccordionValue
    });
    this.accordion?.updateProps({ ...layout, value: nextValue });
  },
  destroyed() {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.accordion?.destroy();
  }
};
export {
  AccordionHook as Accordion,
  readAccordionLayoutProps
};
