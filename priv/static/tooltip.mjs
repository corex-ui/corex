import {
  getPlacement,
  getPlacementStyles
} from "./chunk-VXCJNDUG.mjs";
import {
  isFocusVisible,
  trackFocusVisible
} from "./chunk-IAPTZYKE.mjs";
import {
  Component,
  VanillaMachine,
  addDomEvent,
  createAnatomy,
  createGuards,
  createMachine,
  dataAttr,
  ensureProps,
  getBoolean,
  getNumber,
  getOverflowAncestors,
  getString,
  isComposingEvent,
  isLeftClick,
  normalizeProps
} from "./chunk-SNFXM6OQ.mjs";

// ../node_modules/.pnpm/@zag-js+tooltip@1.36.0/node_modules/@zag-js/tooltip/dist/tooltip.anatomy.mjs
var anatomy = createAnatomy("tooltip").parts("trigger", "arrow", "arrowTip", "positioner", "content");
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+utils@1.36.0/node_modules/@zag-js/utils/dist/store.mjs
function createStore(initialState, compare = Object.is) {
  let state = { ...initialState };
  const listeners = /* @__PURE__ */ new Set();
  const subscribe = (listener) => {
    listeners.add(listener);
    return () => listeners.delete(listener);
  };
  const publish = () => {
    listeners.forEach((listener) => listener());
  };
  const get = (key) => {
    return state[key];
  };
  const set = (key, value) => {
    if (!compare(state[key], value)) {
      state[key] = value;
      publish();
    }
  };
  const update = (updates) => {
    let hasChanges = false;
    for (const key in updates) {
      const value = updates[key];
      if (value !== void 0 && !compare(state[key], value)) {
        state[key] = value;
        hasChanges = true;
      }
    }
    if (hasChanges) {
      publish();
    }
  };
  const snapshot = () => ({ ...state });
  return {
    subscribe,
    get,
    set,
    update,
    snapshot
  };
}

// ../node_modules/.pnpm/@zag-js+tooltip@1.36.0/node_modules/@zag-js/tooltip/dist/tooltip.dom.mjs
var getTriggerId = (scope) => scope.ids?.trigger ?? `tooltip:${scope.id}:trigger`;
var getContentId = (scope) => scope.ids?.content ?? `tooltip:${scope.id}:content`;
var getArrowId = (scope) => scope.ids?.arrow ?? `tooltip:${scope.id}:arrow`;
var getPositionerId = (scope) => scope.ids?.positioner ?? `tooltip:${scope.id}:popper`;
var getTriggerEl = (scope) => scope.getById(getTriggerId(scope));
var getPositionerEl = (scope) => scope.getById(getPositionerId(scope));

// ../node_modules/.pnpm/@zag-js+tooltip@1.36.0/node_modules/@zag-js/tooltip/dist/tooltip.store.mjs
var store = createStore({
  id: null,
  prevId: null,
  instant: false
});

// ../node_modules/.pnpm/@zag-js+tooltip@1.36.0/node_modules/@zag-js/tooltip/dist/tooltip.connect.mjs
function connect(service, normalize) {
  const { state, context, send, scope, prop, event: _event } = service;
  const id = prop("id");
  const hasAriaLabel = !!prop("aria-label");
  const open = state.matches("open", "closing");
  const triggerId = getTriggerId(scope);
  const contentId = getContentId(scope);
  const disabled = prop("disabled");
  const popperStyles = getPlacementStyles({
    ...prop("positioning"),
    placement: context.get("currentPlacement")
  });
  return {
    open,
    setOpen(nextOpen) {
      const open2 = state.matches("open", "closing");
      if (open2 === nextOpen) return;
      send({ type: nextOpen ? "open" : "close" });
    },
    reposition(options = {}) {
      send({ type: "positioning.set", options });
    },
    getTriggerProps() {
      return normalize.button({
        ...parts.trigger.attrs,
        id: triggerId,
        dir: prop("dir"),
        "data-expanded": dataAttr(open),
        "data-state": open ? "open" : "closed",
        "aria-describedby": open ? contentId : void 0,
        onClick(event) {
          if (event.defaultPrevented) return;
          if (disabled) return;
          if (!prop("closeOnClick")) return;
          send({ type: "close", src: "trigger.click" });
        },
        onFocus(event) {
          queueMicrotask(() => {
            if (event.defaultPrevented) return;
            if (disabled) return;
            if (_event.src === "trigger.pointerdown") return;
            if (!isFocusVisible()) return;
            send({ type: "open", src: "trigger.focus" });
          });
        },
        onBlur(event) {
          if (event.defaultPrevented) return;
          if (disabled) return;
          if (id === store.get("id")) {
            send({ type: "close", src: "trigger.blur" });
          }
        },
        onPointerDown(event) {
          if (event.defaultPrevented) return;
          if (disabled) return;
          if (!isLeftClick(event)) return;
          if (!prop("closeOnPointerDown")) return;
          if (id === store.get("id")) {
            send({ type: "close", src: "trigger.pointerdown" });
          }
        },
        onPointerMove(event) {
          if (event.defaultPrevented) return;
          if (disabled) return;
          if (event.pointerType === "touch") return;
          send({ type: "pointer.move" });
        },
        onPointerOver(event) {
          if (event.defaultPrevented) return;
          if (disabled) return;
          if (event.pointerType === "touch") return;
          send({ type: "pointer.move" });
        },
        onPointerLeave() {
          if (disabled) return;
          send({ type: "pointer.leave" });
        },
        onPointerCancel() {
          if (disabled) return;
          send({ type: "pointer.leave" });
        }
      });
    },
    getArrowProps() {
      return normalize.element({
        id: getArrowId(scope),
        ...parts.arrow.attrs,
        dir: prop("dir"),
        style: popperStyles.arrow
      });
    },
    getArrowTipProps() {
      return normalize.element({
        ...parts.arrowTip.attrs,
        dir: prop("dir"),
        style: popperStyles.arrowTip
      });
    },
    getPositionerProps() {
      return normalize.element({
        id: getPositionerId(scope),
        ...parts.positioner.attrs,
        dir: prop("dir"),
        style: popperStyles.floating
      });
    },
    getContentProps() {
      const isCurrentTooltip = store.get("id") === id;
      const isPrevTooltip = store.get("prevId") === id;
      const instant = store.get("instant") && (open && isCurrentTooltip || isPrevTooltip);
      return normalize.element({
        ...parts.content.attrs,
        dir: prop("dir"),
        hidden: !open,
        "data-state": open ? "open" : "closed",
        "data-instant": dataAttr(instant),
        role: hasAriaLabel ? void 0 : "tooltip",
        id: hasAriaLabel ? void 0 : contentId,
        "data-placement": context.get("currentPlacement"),
        onPointerEnter() {
          send({ type: "content.pointer.move" });
        },
        onPointerLeave() {
          send({ type: "content.pointer.leave" });
        },
        style: {
          pointerEvents: prop("interactive") ? "auto" : "none"
        }
      });
    }
  };
}

// ../node_modules/.pnpm/@zag-js+tooltip@1.36.0/node_modules/@zag-js/tooltip/dist/tooltip.machine.mjs
var { and, not } = createGuards();
var machine = createMachine({
  initialState: ({ prop }) => {
    const open = prop("open") || prop("defaultOpen");
    return open ? "open" : "closed";
  },
  props({ props }) {
    ensureProps(props, ["id"]);
    const closeOnClick = props.closeOnClick ?? true;
    const closeOnPointerDown = props.closeOnPointerDown ?? closeOnClick;
    return {
      openDelay: 400,
      closeDelay: 150,
      closeOnEscape: true,
      interactive: false,
      closeOnScroll: true,
      disabled: false,
      ...props,
      closeOnPointerDown,
      closeOnClick,
      positioning: {
        placement: "bottom",
        ...props.positioning
      }
    };
  },
  effects: ["trackFocusVisible", "trackStore"],
  context: ({ bindable }) => ({
    currentPlacement: bindable(() => ({ defaultValue: void 0 })),
    hasPointerMoveOpened: bindable(() => ({ defaultValue: false }))
  }),
  watch({ track, action, prop }) {
    track([() => prop("disabled")], () => {
      action(["closeIfDisabled"]);
    });
    track([() => prop("open")], () => {
      action(["toggleVisibility"]);
    });
  },
  states: {
    closed: {
      entry: ["clearGlobalId"],
      on: {
        "controlled.open": {
          target: "open"
        },
        open: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["invokeOnOpen"]
          }
        ],
        "pointer.leave": {
          actions: ["clearPointerMoveOpened"]
        },
        "pointer.move": [
          {
            guard: and("noVisibleTooltip", not("hasPointerMoveOpened")),
            target: "opening"
          },
          {
            guard: not("hasPointerMoveOpened"),
            target: "open",
            actions: ["setPointerMoveOpened", "invokeOnOpen"]
          }
        ]
      }
    },
    opening: {
      effects: ["trackScroll", "trackPointerlockChange", "waitForOpenDelay"],
      on: {
        "after.openDelay": [
          {
            guard: "isOpenControlled",
            actions: ["setPointerMoveOpened", "invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["setPointerMoveOpened", "invokeOnOpen"]
          }
        ],
        "controlled.open": {
          target: "open"
        },
        "controlled.close": {
          target: "closed"
        },
        open: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["invokeOnOpen"]
          }
        ],
        "pointer.leave": [
          {
            guard: "isOpenControlled",
            // We trigger toggleVisibility manually since the `ctx.open` has not changed yet (at this point)
            actions: ["clearPointerMoveOpened", "invokeOnClose", "toggleVisibility"]
          },
          {
            target: "closed",
            actions: ["clearPointerMoveOpened", "invokeOnClose"]
          }
        ],
        close: [
          {
            guard: "isOpenControlled",
            // We trigger toggleVisibility manually since the `ctx.open` has not changed yet (at this point)
            actions: ["invokeOnClose", "toggleVisibility"]
          },
          {
            target: "closed",
            actions: ["invokeOnClose"]
          }
        ]
      }
    },
    open: {
      effects: ["trackEscapeKey", "trackScroll", "trackPointerlockChange", "trackPositioning"],
      entry: ["setGlobalId"],
      on: {
        "controlled.close": {
          target: "closed"
        },
        close: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnClose"]
          },
          {
            target: "closed",
            actions: ["invokeOnClose"]
          }
        ],
        "pointer.leave": [
          {
            guard: "isVisible",
            target: "closing",
            actions: ["clearPointerMoveOpened"]
          },
          // == group ==
          {
            guard: "isOpenControlled",
            actions: ["clearPointerMoveOpened", "invokeOnClose"]
          },
          {
            target: "closed",
            actions: ["clearPointerMoveOpened", "invokeOnClose"]
          }
        ],
        "content.pointer.leave": {
          guard: "isInteractive",
          target: "closing"
        },
        "positioning.set": {
          actions: ["reposition"]
        }
      }
    },
    closing: {
      effects: ["trackPositioning", "waitForCloseDelay"],
      on: {
        "after.closeDelay": [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnClose"]
          },
          {
            target: "closed",
            actions: ["invokeOnClose"]
          }
        ],
        "controlled.close": {
          target: "closed"
        },
        "controlled.open": {
          target: "open"
        },
        close: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnClose"]
          },
          {
            target: "closed",
            actions: ["invokeOnClose"]
          }
        ],
        "pointer.move": [
          {
            guard: "isOpenControlled",
            // We trigger toggleVisibility manually since the `ctx.open` has not changed yet (at this point)
            actions: ["setPointerMoveOpened", "invokeOnOpen", "toggleVisibility"]
          },
          {
            target: "open",
            actions: ["setPointerMoveOpened", "invokeOnOpen"]
          }
        ],
        "content.pointer.move": {
          guard: "isInteractive",
          target: "open"
        },
        "positioning.set": {
          actions: ["reposition"]
        }
      }
    }
  },
  implementations: {
    guards: {
      noVisibleTooltip: () => store.get("id") === null,
      isVisible: ({ prop }) => prop("id") === store.get("id"),
      isInteractive: ({ prop }) => !!prop("interactive"),
      hasPointerMoveOpened: ({ context }) => context.get("hasPointerMoveOpened"),
      isOpenControlled: ({ prop }) => prop("open") !== void 0
    },
    actions: {
      setGlobalId: ({ prop }) => {
        const prevId = store.get("id");
        const isInstant = prevId !== null && prevId !== prop("id");
        store.update({ id: prop("id"), prevId: isInstant ? prevId : null, instant: isInstant });
      },
      clearGlobalId: ({ prop }) => {
        if (prop("id") === store.get("id")) {
          store.update({ id: null, prevId: null, instant: false });
        }
      },
      invokeOnOpen: ({ prop }) => {
        prop("onOpenChange")?.({ open: true });
      },
      invokeOnClose: ({ prop }) => {
        prop("onOpenChange")?.({ open: false });
      },
      closeIfDisabled: ({ prop, send }) => {
        if (!prop("disabled")) return;
        send({ type: "close", src: "disabled.change" });
      },
      reposition: ({ context, event, prop, scope }) => {
        if (event.type !== "positioning.set") return;
        const getPositionerEl2 = () => getPositionerEl(scope);
        return getPlacement(getTriggerEl(scope), getPositionerEl2, {
          ...prop("positioning"),
          ...event.options,
          defer: true,
          listeners: false,
          onComplete(data) {
            context.set("currentPlacement", data.placement);
          }
        });
      },
      toggleVisibility: ({ prop, event, send }) => {
        queueMicrotask(() => {
          send({
            type: prop("open") ? "controlled.open" : "controlled.close",
            previousEvent: event
          });
        });
      },
      setPointerMoveOpened: ({ context }) => {
        context.set("hasPointerMoveOpened", true);
      },
      clearPointerMoveOpened: ({ context }) => {
        context.set("hasPointerMoveOpened", false);
      }
    },
    effects: {
      trackFocusVisible: ({ scope }) => {
        return trackFocusVisible({ root: scope.getRootNode?.() });
      },
      trackPositioning: ({ context, prop, scope }) => {
        if (!context.get("currentPlacement")) {
          context.set("currentPlacement", prop("positioning").placement);
        }
        const getPositionerEl2 = () => getPositionerEl(scope);
        return getPlacement(getTriggerEl(scope), getPositionerEl2, {
          ...prop("positioning"),
          defer: true,
          onComplete(data) {
            context.set("currentPlacement", data.placement);
          }
        });
      },
      trackPointerlockChange: ({ send, scope }) => {
        const doc = scope.getDoc();
        const onChange = () => send({ type: "close", src: "pointerlock:change" });
        return addDomEvent(doc, "pointerlockchange", onChange, false);
      },
      trackScroll: ({ send, prop, scope }) => {
        if (!prop("closeOnScroll")) return;
        const triggerEl = getTriggerEl(scope);
        if (!triggerEl) return;
        const overflowParents = getOverflowAncestors(triggerEl);
        const cleanups = overflowParents.map((overflowParent) => {
          const onScroll = () => {
            send({ type: "close", src: "scroll" });
          };
          return addDomEvent(overflowParent, "scroll", onScroll, {
            passive: true,
            capture: true
          });
        });
        return () => {
          cleanups.forEach((fn) => fn?.());
        };
      },
      trackStore: ({ prop, send }) => {
        let cleanup;
        queueMicrotask(() => {
          cleanup = store.subscribe(() => {
            if (store.get("id") !== prop("id")) {
              send({ type: "close", src: "id.change" });
            }
          });
        });
        return () => cleanup?.();
      },
      trackEscapeKey: ({ send, prop }) => {
        if (!prop("closeOnEscape")) return;
        const onKeyDown = (event) => {
          if (isComposingEvent(event)) return;
          if (event.key !== "Escape") return;
          event.stopPropagation();
          send({ type: "close", src: "keydown.escape" });
        };
        return addDomEvent(document, "keydown", onKeyDown, true);
      },
      waitForOpenDelay: ({ send, prop }) => {
        const id = setTimeout(() => {
          send({ type: "after.openDelay" });
        }, prop("openDelay"));
        return () => clearTimeout(id);
      },
      waitForCloseDelay: ({ send, prop }) => {
        const id = setTimeout(() => {
          send({ type: "after.closeDelay" });
        }, prop("closeDelay"));
        return () => clearTimeout(id);
      }
    }
  }
});

// components/tooltip.ts
var Tooltip = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props) {
    return new VanillaMachine(machine, props);
  }
  initApi() {
    return connect(this.machine.service, normalizeProps);
  }
  render() {
    const rootEl = this.el;
    const triggerEl = rootEl.querySelector(
      '[data-scope="tooltip"][data-part="trigger"]'
    );
    if (triggerEl) this.spreadProps(triggerEl, this.api.getTriggerProps());
    const positionerEl = rootEl.querySelector(
      '[data-scope="tooltip"][data-part="positioner"]'
    );
    if (positionerEl) this.spreadProps(positionerEl, this.api.getPositionerProps());
    const contentEl = rootEl.querySelector(
      '[data-scope="tooltip"][data-part="content"]'
    );
    if (contentEl) this.spreadProps(contentEl, this.api.getContentProps());
    const arrowEl = rootEl.querySelector(
      '[data-scope="tooltip"][data-part="arrow"]'
    );
    if (arrowEl) this.spreadProps(arrowEl, this.api.getArrowProps());
    const arrowTipEl = rootEl.querySelector(
      '[data-scope="tooltip"][data-part="arrow-tip"]'
    );
    if (arrowTipEl) this.spreadProps(arrowTipEl, this.api.getArrowTipProps());
  }
};

// hooks/tooltip.ts
var PLACEMENTS = [
  "top",
  "top-start",
  "top-end",
  "bottom",
  "bottom-start",
  "bottom-end",
  "left",
  "left-start",
  "left-end",
  "right",
  "right-start",
  "right-end"
];
function getCloseDelay(el) {
  const interactive = getBoolean(el, "interactive");
  const raw = getNumber(el, "closeDelay");
  if (interactive && (raw === void 0 || raw === 0)) return 400;
  return raw;
}
var TooltipHook = {
  mounted() {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const placement = getString(el, "placement", PLACEMENTS);
    const positioning = placement ? { placement } : void 0;
    const tooltip = new Tooltip(el, {
      id: el.id,
      ...getBoolean(el, "controlled") ? { open: getBoolean(el, "open") } : { defaultOpen: getBoolean(el, "defaultOpen") },
      disabled: getBoolean(el, "disabled"),
      dir: getString(el, "dir", ["ltr", "rtl"]),
      openDelay: getNumber(el, "openDelay"),
      closeDelay: getCloseDelay(el),
      positioning,
      closeOnEscape: getBoolean(el, "closeOnEscape"),
      closeOnClick: getBoolean(el, "closeOnClick"),
      closeOnPointerDown: getBoolean(el, "closeOnPointerDown"),
      closeOnScroll: getBoolean(el, "closeOnScroll"),
      interactive: getBoolean(el, "interactive"),
      onOpenChange: (details) => {
        const eventName = getString(el, "onOpenChange");
        if (eventName && this.liveSocket.main.isConnected()) {
          pushEvent(eventName, {
            id: el.id,
            open: details.open
          });
        }
        const eventNameClient = getString(el, "onOpenChangeClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
              bubbles: true,
              detail: {
                id: el.id,
                open: details.open
              }
            })
          );
        }
      }
    });
    tooltip.init();
    this.tooltip = tooltip;
    this.onSetOpen = (event) => {
      const { open } = event.detail;
      tooltip.api.setOpen(open);
    };
    el.addEventListener("phx:tooltip:set-open", this.onSetOpen);
    this.handlers = [];
    this.handlers.push(
      this.handleEvent(
        "tooltip_set_open",
        (payload) => {
          const targetId = payload.tooltip_id;
          if (targetId && targetId !== el.id) return;
          tooltip.api.setOpen(payload.open);
        }
      )
    );
  },
  updated() {
    const placement = getString(this.el, "placement", PLACEMENTS);
    const positioning = placement ? { placement } : void 0;
    this.tooltip?.updateProps({
      id: this.el.id,
      ...getBoolean(this.el, "controlled") ? { open: getBoolean(this.el, "open") } : { defaultOpen: getBoolean(this.el, "defaultOpen") },
      disabled: getBoolean(this.el, "disabled"),
      dir: getString(this.el, "dir", ["ltr", "rtl"]),
      openDelay: getNumber(this.el, "openDelay"),
      closeDelay: getCloseDelay(this.el),
      positioning,
      closeOnEscape: getBoolean(this.el, "closeOnEscape"),
      closeOnClick: getBoolean(this.el, "closeOnClick"),
      closeOnPointerDown: getBoolean(this.el, "closeOnPointerDown"),
      closeOnScroll: getBoolean(this.el, "closeOnScroll"),
      interactive: getBoolean(this.el, "interactive")
    });
  },
  destroyed() {
    if (this.onSetOpen) {
      this.el.removeEventListener("phx:tooltip:set-open", this.onSetOpen);
    }
    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }
    this.tooltip?.destroy();
  }
};
export {
  TooltipHook as Tooltip
};
