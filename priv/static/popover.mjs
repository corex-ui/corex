import {
  ariaHidden,
  preventBodyScroll,
  trapFocus
} from "./chunks/chunk-HV2J7H25.mjs";
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
  ariaAttr,
  canPushEvent,
  createAnatomy,
  createMachine,
  createZagLiveHook,
  dataAttr,
  getBoolean,
  getByOwnerId,
  getDir,
  getInitialFocus,
  getString,
  isFunction,
  isLeftClick,
  isSafari,
  mergeWithDefault,
  proxyTabFocus,
  queryAll,
  raf
} from "./chunks/chunk-CLKNJROH.mjs";

// ../node_modules/.pnpm/@zag-js+popover@1.43.3/node_modules/@zag-js/popover/dist/popover.anatomy.mjs
var anatomy = createAnatomy("popover").parts(
  "arrow",
  "arrowTip",
  "anchor",
  "trigger",
  "indicator",
  "positioner",
  "content",
  "title",
  "description",
  "closeTrigger"
);
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+popover@1.43.3/node_modules/@zag-js/popover/dist/popover.dom.mjs
var getAnchorId = (scope) => scope.ids?.anchor ?? `popover:${scope.id}:anchor`;
var getTriggerId = (scope, value) => {
  const customId = scope.ids?.trigger;
  if (customId != null) return isFunction(customId) ? customId(value) : customId;
  return value ? `popover:${scope.id}:trigger:${value}` : `popover:${scope.id}:trigger`;
};
var getContentId = (scope) => scope.ids?.content ?? `popover:${scope.id}:content`;
var getPositionerId = (scope) => scope.ids?.positioner ?? `popover:${scope.id}:popper`;
var getArrowId = (scope) => scope.ids?.arrow ?? `popover:${scope.id}:arrow`;
var getTitleId = (scope) => scope.ids?.title ?? `popover:${scope.id}:title`;
var getDescriptionId = (scope) => scope.ids?.description ?? `popover:${scope.id}:desc`;
var getCloseTriggerId = (scope) => scope.ids?.closeTrigger ?? `popover:${scope.id}:close`;
var getAnchorEl = (scope) => scope.getById(getAnchorId(scope));
var getTriggerEl = (scope) => scope.getById(getTriggerId(scope));
var getTriggerEls = (scope) => queryAll(scope.getRootNode(), `[data-scope="popover"][data-part="trigger"]${getByOwnerId(scope.id)}`);
var getActiveTriggerEl = (scope, value) => {
  if (value == null) {
    return getTriggerEl(scope) ?? getTriggerEls(scope)[0];
  }
  return scope.getById(getTriggerId(scope, value));
};
var getContentEl = (scope) => scope.getById(getContentId(scope));
var getPositionerEl = (scope) => scope.getById(getPositionerId(scope));
var getTitleEl = (scope) => scope.getById(getTitleId(scope));
var getDescriptionEl = (scope) => scope.getById(getDescriptionId(scope));

// ../node_modules/.pnpm/@zag-js+popover@1.43.3/node_modules/@zag-js/popover/dist/popover.connect.mjs
var defaultTranslations = {
  closeTriggerLabel: "close"
};
function connect(service, normalize) {
  const { state, context, send, computed, prop, scope } = service;
  const translations = mergeWithDefault(defaultTranslations, prop("translations"));
  const open = state.matches("open");
  const currentPlacement = context.get("currentPlacement");
  const currentPlacementSide = currentPlacement ? getPlacementSide(currentPlacement) : void 0;
  const portalled = computed("currentPortalled");
  const rendered = context.get("renderedElements");
  const triggerValue = context.get("triggerValue");
  const popperStyles = getPlacementStyles({
    ...prop("positioning"),
    placement: currentPlacement
  });
  return {
    portalled,
    open,
    setOpen(nextOpen) {
      const open2 = state.matches("open");
      if (open2 === nextOpen) return;
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
    getAnchorProps() {
      return normalize.element({
        ...parts.anchor.attrs,
        dir: prop("dir"),
        id: getAnchorId(scope)
      });
    },
    getTriggerProps(props = {}) {
      const { value } = props;
      const current = value == null ? false : triggerValue === value;
      return normalize.button({
        ...parts.trigger.attrs,
        dir: prop("dir"),
        type: "button",
        "data-placement": currentPlacement,
        "data-side": currentPlacementSide,
        id: getTriggerId(scope, value),
        "data-ownedby": scope.id,
        "data-value": value,
        "data-current": dataAttr(current),
        "aria-haspopup": "dialog",
        "aria-expanded": value == null ? open : open && current,
        "data-state": open ? "open" : "closed",
        "aria-controls": getContentId(scope),
        onPointerDown(event) {
          if (!isLeftClick(event)) return;
          if (isSafari()) {
            event.currentTarget.focus();
          }
        },
        onClick(event) {
          if (event.defaultPrevented) return;
          const shouldSwitch = open && value != null && !current;
          send({ type: shouldSwitch ? "TRIGGER_VALUE.SET" : "TOGGLE", value });
        },
        onBlur(event) {
          send({ type: "TRIGGER_BLUR", target: event.relatedTarget });
        }
      });
    },
    getIndicatorProps() {
      return normalize.element({
        ...parts.indicator.attrs,
        dir: prop("dir"),
        "data-state": open ? "open" : "closed"
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
        tabIndex: -1,
        role: "dialog",
        "aria-modal": ariaAttr(prop("modal")),
        hidden: !open,
        "data-state": open ? "open" : "closed",
        "data-expanded": dataAttr(open),
        "aria-labelledby": rendered.title ? getTitleId(scope) : void 0,
        "aria-describedby": rendered.description ? getDescriptionId(scope) : void 0,
        "data-placement": currentPlacement,
        "data-side": currentPlacementSide
      });
    },
    getTitleProps() {
      return normalize.element({
        ...parts.title.attrs,
        id: getTitleId(scope),
        dir: prop("dir")
      });
    },
    getDescriptionProps() {
      return normalize.element({
        ...parts.description.attrs,
        id: getDescriptionId(scope),
        dir: prop("dir")
      });
    },
    getCloseTriggerProps() {
      return normalize.button({
        ...parts.closeTrigger.attrs,
        dir: prop("dir"),
        id: getCloseTriggerId(scope),
        type: "button",
        "aria-label": translations.closeTriggerLabel,
        onClick(event) {
          if (event.defaultPrevented) return;
          event.stopPropagation();
          send({ type: "CLOSE" });
        }
      });
    }
  };
}

// ../node_modules/.pnpm/@zag-js+popover@1.43.3/node_modules/@zag-js/popover/dist/popover.machine.mjs
var machine = createMachine({
  props({ props }) {
    return {
      closeOnInteractOutside: true,
      closeOnEscape: true,
      autoFocus: true,
      modal: false,
      portalled: true,
      restoreFocus: true,
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
  context({ bindable, prop, scope }) {
    return {
      currentPlacement: bindable(() => ({
        defaultValue: void 0
      })),
      renderedElements: bindable(() => ({
        defaultValue: { title: true, description: true }
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
  computed: {
    currentPortalled: ({ prop }) => !!prop("modal") || !!prop("portalled")
  },
  watch({ track, prop, action }) {
    track([() => prop("open")], () => {
      action(["toggleVisibility"]);
    });
  },
  entry: ["checkRenderedElements"],
  on: {
    "TRIGGER_VALUE.SET": {
      actions: ["setTriggerValue", "reposition"]
    }
  },
  states: {
    closed: {
      on: {
        "CONTROLLED.OPEN": {
          target: "open",
          actions: ["setInitialFocus"]
        },
        TOGGLE: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen", "setTriggerValue"]
          },
          {
            target: "open",
            actions: ["invokeOnOpen", "setTriggerValue", "setInitialFocus"]
          }
        ],
        OPEN: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen", "setTriggerValue"]
          },
          {
            target: "open",
            actions: ["invokeOnOpen", "setTriggerValue", "setInitialFocus"]
          }
        ]
      }
    },
    open: {
      effects: [
        "trapFocus",
        "preventScroll",
        "hideContentBelow",
        "trackDismissableElement",
        "trackPositioning",
        "proxyTabFocus"
      ],
      on: {
        "CONTROLLED.CLOSE": {
          target: "closed",
          actions: ["setFinalFocus"]
        },
        CLOSE: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnClose"]
          },
          {
            target: "closed",
            actions: ["invokeOnClose", "setFinalFocus"]
          }
        ],
        TOGGLE: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnClose"]
          },
          {
            target: "closed",
            actions: ["invokeOnClose"]
          }
        ],
        "POSITIONING.SET": {
          actions: ["reposition"]
        }
      }
    }
  },
  implementations: {
    guards: {
      isOpenControlled: ({ prop }) => prop("open") != void 0
    },
    effects: {
      trackPositioning({ context, prop, scope }) {
        context.set("currentPlacement", prop("positioning").placement);
        const anchorEl = getAnchorEl(scope);
        const getPositionerEl2 = () => getPositionerEl(scope);
        const getTriggerEl2 = () => anchorEl ?? getActiveTriggerEl(scope, context.get("triggerValue"));
        return getPlacement(getTriggerEl2, getPositionerEl2, {
          ...prop("positioning"),
          defer: true,
          onComplete(data) {
            context.set("currentPlacement", data.placement);
          }
        });
      },
      trackDismissableElement({ send, prop, scope }) {
        const getContentEl2 = () => getContentEl(scope);
        let restoreFocus = true;
        return trackDismissableElement(getContentEl2, {
          type: "popover",
          pointerBlocking: prop("modal"),
          exclude: [getTriggerEl(scope), ...getTriggerEls(scope)].filter(Boolean),
          defer: true,
          onEscapeKeyDown(event) {
            prop("onEscapeKeyDown")?.(event);
            if (prop("closeOnEscape")) return;
            event.preventDefault();
          },
          onInteractOutside(event) {
            prop("onInteractOutside")?.(event);
            if (event.defaultPrevented) return;
            restoreFocus = !(event.detail.focusable || event.detail.contextmenu);
            if (!prop("closeOnInteractOutside")) {
              event.preventDefault();
            }
          },
          onPointerDownOutside: prop("onPointerDownOutside"),
          onFocusOutside: prop("onFocusOutside"),
          persistentElements: prop("persistentElements"),
          onRequestDismiss: prop("onRequestDismiss"),
          onDismiss() {
            send({ type: "CLOSE", src: "interact-outside", restoreFocus });
          }
        });
      },
      proxyTabFocus({ prop, scope, context }) {
        if (prop("modal") || !prop("portalled")) return;
        const getContentEl2 = () => getContentEl(scope);
        return proxyTabFocus(getContentEl2, {
          triggerElement: getActiveTriggerEl(scope, context.get("triggerValue")),
          defer: true,
          getShadowRoot: true,
          onFocus(el) {
            el.focus({ preventScroll: true });
          }
        });
      },
      hideContentBelow({ prop, scope, context }) {
        if (!prop("modal")) return;
        const getElements = () => [getContentEl(scope), getActiveTriggerEl(scope, context.get("triggerValue"))];
        return ariaHidden(getElements, { defer: true });
      },
      preventScroll({ prop, scope }) {
        if (!prop("modal")) return;
        return preventBodyScroll(scope.getDoc());
      },
      trapFocus({ prop, scope, context }) {
        if (!prop("modal")) return;
        const contentEl = () => getContentEl(scope);
        return trapFocus(contentEl, {
          preventScroll: true,
          returnFocusOnDeactivate: !!prop("restoreFocus"),
          initialFocus: () => getInitialFocus({
            root: getContentEl(scope),
            getInitialEl: prop("initialFocusEl"),
            enabled: prop("autoFocus")
          }),
          setReturnFocus: (el) => {
            const finalFocusEl = prop("finalFocusEl")?.();
            if (finalFocusEl) return finalFocusEl;
            const triggerValue = context.get("triggerValue");
            if (triggerValue) {
              const activeTriggerEl = getActiveTriggerEl(scope, triggerValue);
              if (activeTriggerEl) return activeTriggerEl;
            }
            const fallbackTrigger = getTriggerEls(scope)[0];
            if (fallbackTrigger) return fallbackTrigger;
            return el;
          },
          getShadowRoot: true
        });
      }
    },
    actions: {
      reposition({ event, prop, scope, context }) {
        const anchorEl = getAnchorEl(scope);
        const getPositionerEl2 = () => getPositionerEl(scope);
        const getTriggerEl2 = () => anchorEl ?? getActiveTriggerEl(scope, context.get("triggerValue"));
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
      checkRenderedElements({ context, scope }) {
        raf(() => {
          Object.assign(context.get("renderedElements"), {
            title: !!getTitleEl(scope),
            description: !!getDescriptionEl(scope)
          });
        });
      },
      setInitialFocus({ prop, scope }) {
        if (prop("modal")) return;
        raf(() => {
          const element = getInitialFocus({
            root: getContentEl(scope),
            getInitialEl: prop("initialFocusEl"),
            enabled: prop("autoFocus")
          });
          element?.focus({ preventScroll: true });
        });
      },
      setFinalFocus({ event, prop, scope, context }) {
        const eventRestoreFocus = event.restoreFocus ?? event.previousEvent?.restoreFocus;
        if (eventRestoreFocus != null && !eventRestoreFocus) return;
        if (!prop("restoreFocus")) return;
        raf(() => {
          const finalFocusEl = prop("finalFocusEl")?.();
          if (finalFocusEl) {
            finalFocusEl.focus({ preventScroll: true });
            return;
          }
          const element = getActiveTriggerEl(scope, context.get("triggerValue"));
          element?.focus({ preventScroll: true });
        });
      },
      invokeOnOpen({ prop, flush }) {
        flush(() => {
          prop("onOpenChange")?.({ open: true });
        });
      },
      invokeOnClose({ prop, flush }) {
        flush(() => {
          prop("onOpenChange")?.({ open: false });
        });
      },
      toggleVisibility({ event, send, prop }) {
        send({ type: prop("open") ? "CONTROLLED.OPEN" : "CONTROLLED.CLOSE", previousEvent: event });
      }
    }
  }
});

// components/popover.ts
var Popover = class extends Component {
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
    rootEl.querySelectorAll('[data-scope="popover"][data-part="trigger"]').forEach((triggerEl) => {
      const raw = triggerEl.dataset.value;
      const valueProps = raw != null && raw !== "" ? { value: raw } : {};
      this.spreadProps(triggerEl, this.api.getTriggerProps(valueProps));
    });
    const positionerEl = rootEl.querySelector(
      '[data-scope="popover"][data-part="positioner"]'
    );
    if (positionerEl) this.spreadProps(positionerEl, this.api.getPositionerProps());
    const contentEl = rootEl.querySelector(
      '[data-scope="popover"][data-part="content"]'
    );
    if (contentEl) this.spreadProps(contentEl, this.api.getContentProps());
    const titleEl = rootEl.querySelector('[data-scope="popover"][data-part="title"]');
    if (titleEl) this.spreadProps(titleEl, this.api.getTitleProps());
    const descriptionEl = rootEl.querySelector(
      '[data-scope="popover"][data-part="description"]'
    );
    if (descriptionEl) this.spreadProps(descriptionEl, this.api.getDescriptionProps());
    const closeEl = rootEl.querySelector(
      '[data-scope="popover"][data-part="close-trigger"]'
    );
    if (closeEl) this.spreadProps(closeEl, this.api.getCloseTriggerProps());
    const arrowEl = rootEl.querySelector('[data-scope="popover"][data-part="arrow"]');
    if (arrowEl) this.spreadProps(arrowEl, this.api.getArrowProps());
    const arrowTipEl = rootEl.querySelector(
      '[data-scope="popover"][data-part="arrow-tip"]'
    );
    if (arrowTipEl) this.spreadProps(arrowTipEl, this.api.getArrowTipProps());
  }
};

// hooks/popover.ts
function createPopoverCallbacks(el, pushEvent, liveSocket) {
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
function popoverProps(el, hook) {
  return {
    id: el.id,
    defaultOpen: getBoolean(el, "defaultOpen"),
    dir: getDir(el),
    modal: getBoolean(el, "modal"),
    portalled: getBoolean(el, "portalled"),
    autoFocus: getBoolean(el, "autoFocus"),
    restoreFocus: getBoolean(el, "restoreFocus"),
    closeOnInteractOutside: getBoolean(el, "closeOnInteractOutside"),
    closeOnEscape: getBoolean(el, "closeOnEscape"),
    positioning: readPositioningOptions(el),
    ...createPopoverCallbacks(el, hook.pushEvent.bind(hook), hook.liveSocket)
  };
}
var PopoverHook = createZagLiveHook({
  key: "popover",
  mount(hook, { dom, server }) {
    const el = hook.el;
    const popover = new Popover(el, popoverProps(el, hook));
    dom.add("corex:popover:set-open", (event) => {
      popover.api.setOpen(event.detail.open);
    });
    server.add("popover_set_open", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      popover.api.setOpen(payload.open);
    });
    return popover;
  },
  update(hook, popover) {
    popover.updateProps(popoverProps(hook.el, hook));
  }
});
export {
  PopoverHook as Popover
};
