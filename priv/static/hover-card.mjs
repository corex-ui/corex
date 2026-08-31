import {
  getPlacement,
  getPlacementSide,
  getPlacementStyles
} from "./chunks/chunk-QBBRC35T.mjs";
import {
  trackDismissableElement
} from "./chunks/chunk-QFRIDKAW.mjs";
import "./chunks/chunk-HY5BRBNW.mjs";
import {
  readPositioningOptions
} from "./chunks/chunk-ZTJV2RYM.mjs";
import {
  idMatches,
  readPayloadId
} from "./chunks/chunk-EAQ6WQNO.mjs";
import {
  Component,
  VanillaMachine,
  canPushEvent,
  createAnatomy,
  createGuards,
  createMachine,
  createZagLiveHook,
  dataAttr,
  getBoolean,
  getByOwnerId,
  getDir,
  getNumber,
  getString,
  isFunction,
  queryAll
} from "./chunks/chunk-CLKNJROH.mjs";

// ../node_modules/.pnpm/@zag-js+hover-card@1.43.3/node_modules/@zag-js/hover-card/dist/hover-card.anatomy.mjs
var anatomy = createAnatomy("hoverCard").parts("arrow", "arrowTip", "trigger", "positioner", "content");
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+hover-card@1.43.3/node_modules/@zag-js/hover-card/dist/hover-card.dom.mjs
var getTriggerId = (scope, value) => {
  const customId = scope.ids?.trigger;
  if (customId != null) return isFunction(customId) ? customId(value) : customId;
  return value ? `hover-card:${scope.id}:trigger:${value}` : `hover-card:${scope.id}:trigger`;
};
var getContentId = (scope) => scope.ids?.content ?? `hover-card:${scope.id}:content`;
var getPositionerId = (scope) => scope.ids?.positioner ?? `hover-card:${scope.id}:popper`;
var getArrowId = (scope) => scope.ids?.arrow ?? `hover-card:${scope.id}:arrow`;
var getTriggerEl = (scope) => scope.getById(getTriggerId(scope));
var getContentEl = (scope) => scope.getById(getContentId(scope));
var getPositionerEl = (scope) => scope.getById(getPositionerId(scope));
var getTriggerEls = (scope) => queryAll(scope.getRootNode(), `[data-scope="hover-card"][data-part="trigger"]${getByOwnerId(scope.id)}`);
var getActiveTriggerEl = (scope, value) => {
  if (value == null) {
    return getTriggerEl(scope) ?? getTriggerEls(scope)[0];
  }
  return scope.getById(getTriggerId(scope, value));
};

// ../node_modules/.pnpm/@zag-js+hover-card@1.43.3/node_modules/@zag-js/hover-card/dist/hover-card.connect.mjs
function connect(service, normalize) {
  const { state, send, prop, context, scope } = service;
  const open = state.hasTag("open");
  const triggerValue = context.get("triggerValue");
  const currentPlacement = context.get("currentPlacement");
  const currentPlacementSide = currentPlacement ? getPlacementSide(currentPlacement) : void 0;
  const popperStyles = getPlacementStyles({
    ...prop("positioning"),
    placement: currentPlacement
  });
  return {
    open,
    setOpen(nextOpen) {
      const open2 = state.hasTag("open");
      if (open2 === nextOpen) return;
      if (prop("disabled")) return;
      send({ type: nextOpen ? "OPEN" : "CLOSE" });
    },
    triggerValue,
    setTriggerValue(value) {
      send({ type: "TRIGGER_VALUE.SET", value });
    },
    reposition(options = {}) {
      send({ type: "POSITIONING.SET", options });
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
    getTriggerProps(props = {}) {
      const { value } = props;
      const current = value == null ? false : triggerValue === value;
      return normalize.element({
        ...parts.trigger.attrs,
        dir: prop("dir"),
        "data-placement": currentPlacement,
        "data-side": currentPlacementSide,
        id: getTriggerId(scope, value),
        "data-ownedby": scope.id,
        "data-value": value,
        "data-current": dataAttr(current),
        "data-state": open ? "open" : "closed",
        onPointerEnter(event) {
          if (event.pointerType === "touch") return;
          if (prop("disabled")) return;
          const shouldSwitch = open && value != null && !current;
          send({
            type: shouldSwitch ? "TRIGGER_VALUE.SET" : "POINTER_ENTER",
            src: "trigger",
            value
          });
        },
        onPointerLeave(event) {
          if (event.pointerType === "touch") return;
          if (prop("disabled")) return;
          send({ type: "POINTER_LEAVE", src: "trigger" });
        },
        onFocus() {
          if (prop("disabled")) return;
          const shouldSwitch = open && value != null && !current;
          send({
            type: shouldSwitch ? "TRIGGER_VALUE.SET" : "TRIGGER_FOCUS",
            value
          });
        },
        onBlur() {
          if (prop("disabled")) return;
          send({ type: "TRIGGER_BLUR" });
        }
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
      return normalize.element({
        ...parts.content.attrs,
        dir: prop("dir"),
        id: getContentId(scope),
        hidden: !open,
        tabIndex: -1,
        "data-state": open ? "open" : "closed",
        "data-placement": currentPlacement,
        "data-side": currentPlacementSide,
        onPointerEnter(event) {
          if (event.pointerType === "touch") return;
          if (prop("disabled")) return;
          send({ type: "POINTER_ENTER", src: "content" });
        },
        onPointerLeave(event) {
          if (event.pointerType === "touch") return;
          if (prop("disabled")) return;
          send({ type: "POINTER_LEAVE", src: "content" });
        }
      });
    }
  };
}

// ../node_modules/.pnpm/@zag-js+hover-card@1.43.3/node_modules/@zag-js/hover-card/dist/hover-card.machine.mjs
var { not, and } = createGuards();
var machine = createMachine({
  props({ props }) {
    return {
      disabled: false,
      openDelay: 600,
      closeDelay: 300,
      ...props,
      positioning: {
        placement: "bottom",
        ...props.positioning
      }
    };
  },
  initialState({ prop }) {
    const open = prop("open") || prop("defaultOpen");
    return open ? "open" : "closed";
  },
  context({ prop, bindable, scope }) {
    return {
      open: bindable(() => ({
        defaultValue: prop("defaultOpen"),
        value: prop("open")
      })),
      currentPlacement: bindable(() => ({
        defaultValue: void 0
      })),
      isPointer: bindable(() => ({
        defaultValue: false
      })),
      triggerValue: bindable(() => ({
        defaultValue: prop("defaultTriggerValue") ?? null,
        value: prop("triggerValue"),
        onChange(value) {
          const onTriggerValueChange = prop("onTriggerValueChange");
          if (!onTriggerValueChange) return;
          const triggerElement = getActiveTriggerEl(scope, value);
          onTriggerValueChange({ value, triggerElement });
        }
      }))
    };
  },
  watch({ track, context, action, prop, send }) {
    track([() => prop("disabled")], () => {
      if (prop("disabled")) {
        send({ type: "CLOSE", src: "disabled.change" });
      }
    });
    track([() => context.get("open")], () => {
      action(["toggleVisibility"]);
    });
  },
  on: {
    "TRIGGER_VALUE.SET": {
      actions: ["setTriggerValue", "reposition"]
    }
  },
  states: {
    closed: {
      tags: ["closed"],
      entry: ["clearIsPointer"],
      on: {
        "CONTROLLED.OPEN": {
          target: "open"
        },
        POINTER_ENTER: {
          target: "opening",
          actions: ["setIsPointer", "setTriggerValue"]
        },
        TRIGGER_FOCUS: {
          target: "opening",
          actions: ["setTriggerValue"]
        },
        OPEN: {
          target: "opening",
          actions: ["setTriggerValue"]
        }
      }
    },
    opening: {
      tags: ["closed"],
      effects: ["waitForOpenDelay"],
      on: {
        OPEN_DELAY: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["invokeOnOpen"]
          }
        ],
        "CONTROLLED.OPEN": {
          target: "open"
        },
        "CONTROLLED.CLOSE": {
          target: "closed"
        },
        POINTER_LEAVE: [
          {
            guard: "isOpenControlled",
            // We trigger toggleVisibility manually since the `ctx.open` has not changed yet (at this point)
            actions: ["invokeOnClose", "toggleVisibility"]
          },
          {
            target: "closed",
            actions: ["invokeOnClose"]
          }
        ],
        TRIGGER_BLUR: [
          {
            guard: and("isOpenControlled", not("isPointer")),
            // We trigger toggleVisibility manually since the `ctx.open` has not changed yet (at this point)
            actions: ["invokeOnClose", "toggleVisibility"]
          },
          {
            guard: not("isPointer"),
            target: "closed",
            actions: ["invokeOnClose"]
          }
        ],
        CLOSE: [
          {
            guard: "isOpenControlled",
            // We trigger toggleVisibility manually since the `ctx.open` has not changed yet (at this point)
            actions: ["invokeOnClose", "toggleVisibility"]
          },
          {
            target: "closed",
            actions: ["invokeOnClose"]
          }
        ],
        "TRIGGER_VALUE.SET": {
          // Stay in opening state but update trigger value (will reposition when opened)
          actions: ["setTriggerValue"]
        }
      }
    },
    open: {
      tags: ["open"],
      effects: ["trackDismissableElement", "trackPositioning"],
      on: {
        "CONTROLLED.CLOSE": {
          target: "closed"
        },
        POINTER_ENTER: {
          actions: ["setIsPointer"]
        },
        POINTER_LEAVE: {
          target: "closing"
        },
        CLOSE: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnClose"]
          },
          {
            target: "closed",
            actions: ["invokeOnClose"]
          }
        ],
        TRIGGER_BLUR: [
          {
            guard: and("isOpenControlled", not("isPointer")),
            actions: ["invokeOnClose"]
          },
          {
            guard: not("isPointer"),
            target: "closed",
            actions: ["invokeOnClose"]
          }
        ],
        "POSITIONING.SET": {
          actions: ["reposition"]
        }
      }
    },
    closing: {
      tags: ["open"],
      effects: ["trackPositioning", "waitForCloseDelay"],
      on: {
        CLOSE_DELAY: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnClose"]
          },
          {
            target: "closed",
            actions: ["invokeOnClose"]
          }
        ],
        "CONTROLLED.CLOSE": {
          target: "closed"
        },
        "CONTROLLED.OPEN": {
          target: "open"
        },
        POINTER_ENTER: {
          target: "open",
          // no need to invokeOnOpen here because it's still open (but about to close)
          actions: ["setIsPointer"]
        },
        TRIGGER_FOCUS: {
          target: "open",
          actions: ["setTriggerValue"]
        },
        "TRIGGER_VALUE.SET": {
          target: "open",
          actions: ["setTriggerValue", "reposition"]
        }
      }
    }
  },
  implementations: {
    guards: {
      isPointer: ({ context }) => !!context.get("isPointer"),
      isOpenControlled: ({ prop }) => prop("open") != null
    },
    effects: {
      waitForOpenDelay({ send, prop }) {
        const id = setTimeout(() => {
          send({ type: "OPEN_DELAY" });
        }, prop("openDelay"));
        return () => clearTimeout(id);
      },
      waitForCloseDelay({ send, prop }) {
        const id = setTimeout(() => {
          send({ type: "CLOSE_DELAY" });
        }, prop("closeDelay"));
        return () => clearTimeout(id);
      },
      trackPositioning({ context, prop, scope }) {
        if (!context.get("currentPlacement")) {
          context.set("currentPlacement", prop("positioning").placement);
        }
        const getPositionerEl2 = () => getPositionerEl(scope);
        const getTriggerEl2 = () => getActiveTriggerEl(scope, context.get("triggerValue"));
        return getPlacement(getTriggerEl2, getPositionerEl2, {
          ...prop("positioning"),
          defer: true,
          onComplete(data) {
            context.set("currentPlacement", data.placement);
          }
        });
      },
      trackDismissableElement({ send, scope, prop }) {
        const getContentEl2 = () => getContentEl(scope);
        return trackDismissableElement(getContentEl2, {
          type: "popover",
          defer: true,
          exclude: [getTriggerEl(scope), ...getTriggerEls(scope)].filter(Boolean),
          onDismiss() {
            send({ type: "CLOSE", src: "interact-outside" });
          },
          onInteractOutside: prop("onInteractOutside"),
          onPointerDownOutside: prop("onPointerDownOutside"),
          onFocusOutside(event) {
            event.preventDefault();
            prop("onFocusOutside")?.(event);
          }
        });
      }
    },
    actions: {
      invokeOnClose({ prop }) {
        prop("onOpenChange")?.({ open: false });
      },
      invokeOnOpen({ prop }) {
        prop("onOpenChange")?.({ open: true });
      },
      setIsPointer({ context }) {
        context.set("isPointer", true);
      },
      clearIsPointer({ context }) {
        context.set("isPointer", false);
      },
      reposition({ context, prop, scope, event }) {
        const getPositionerEl2 = () => getPositionerEl(scope);
        const getTriggerEl2 = () => getActiveTriggerEl(scope, context.get("triggerValue"));
        getPlacement(getTriggerEl2, getPositionerEl2, {
          ...prop("positioning"),
          ...event.options,
          defer: true,
          listeners: false,
          onComplete(data) {
            context.set("currentPlacement", data.placement);
          }
        });
      },
      setTriggerValue({ context, event }) {
        if (event.value === void 0) return;
        context.set("triggerValue", event.value);
      },
      toggleVisibility({ prop, event, send }) {
        queueMicrotask(() => {
          send({ type: prop("open") ? "CONTROLLED.OPEN" : "CONTROLLED.CLOSE", previousEvent: event });
        });
      }
    }
  }
});

// components/hover-card.ts
var HoverCard = class extends Component {
  initMachine(props) {
    return new VanillaMachine(machine, props);
  }
  initApi() {
    return this.zagConnect(connect);
  }
  syncDom() {
    this.api = this.initApi();
    this.render();
  }
  render() {
    const rootEl = this.el;
    rootEl.querySelectorAll('[data-scope="hover-card"][data-part="trigger"]').forEach((triggerEl) => {
      const raw = triggerEl.dataset.value;
      const valueProps = raw != null && raw !== "" ? { value: raw } : {};
      this.spreadProps(triggerEl, this.api.getTriggerProps(valueProps));
    });
    const positionerEl = rootEl.querySelector(
      '[data-scope="hover-card"][data-part="positioner"]'
    );
    if (positionerEl) this.spreadProps(positionerEl, this.api.getPositionerProps());
    const contentEl = rootEl.querySelector(
      '[data-scope="hover-card"][data-part="content"]'
    );
    if (contentEl) this.spreadProps(contentEl, this.api.getContentProps());
    const arrowEl = rootEl.querySelector('[data-scope="hover-card"][data-part="arrow"]');
    if (arrowEl) this.spreadProps(arrowEl, this.api.getArrowProps());
    const arrowTipEl = rootEl.querySelector(
      '[data-scope="hover-card"][data-part="arrow-tip"]'
    );
    if (arrowTipEl) this.spreadProps(arrowTipEl, this.api.getArrowTipProps());
  }
};

// hooks/hover-card.ts
function createHoverCardCallbacks(el, pushEvent, liveSocket) {
  const onTriggerValueChange = (details) => {
    const eventName = getString(el, "onTriggerValueChange");
    if (eventName && canPushEvent(liveSocket)) {
      pushEvent(eventName, {
        id: el.id,
        value: details.value ?? ""
      });
    }
  };
  const onOpenChange = (details) => {
    const eventName = getString(el, "onOpenChange");
    if (eventName && canPushEvent(liveSocket)) {
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
  };
  return { onOpenChange, onTriggerValueChange };
}
function hoverCardProps(el, hook) {
  return {
    id: el.id,
    defaultOpen: getBoolean(el, "defaultOpen"),
    disabled: getBoolean(el, "disabled"),
    dir: getDir(el),
    openDelay: getNumber(el, "openDelay"),
    closeDelay: getNumber(el, "closeDelay"),
    positioning: readPositioningOptions(el),
    ...createHoverCardCallbacks(el, hook.pushEvent.bind(hook), hook.liveSocket)
  };
}
var HoverCardHook = createZagLiveHook({
  key: "hover-card",
  mount(hook, { dom, server }) {
    const el = hook.el;
    const hoverCard = new HoverCard(el, hoverCardProps(el, hook));
    dom.add("corex:hover-card:set-open", (event) => {
      hoverCard.api.setOpen(event.detail.open);
    });
    server.add("hover_card_set_open", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      hoverCard.api.setOpen(payload.open);
    });
    return hoverCard;
  },
  update(hook, hoverCard) {
    hoverCard.updateProps(hoverCardProps(hook.el, hook));
  }
});
export {
  HoverCardHook as HoverCard
};
