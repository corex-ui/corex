import {
  ariaHidden,
  preventBodyScroll,
  trapFocus
} from "./chunks/chunk-HV2J7H25.mjs";
import {
  isJsAnimation,
  prepareJsScaleInitialState,
  readScaleAnimationOptions,
  runScaleAnimation,
  stripHiddenFromProps
} from "./chunks/chunk-SHBNM52E.mjs";
import {
  trackDismissableElement
} from "./chunks/chunk-QFRIDKAW.mjs";
import "./chunks/chunk-HY5BRBNW.mjs";
import {
  readBooleanControlledZagProps,
  readControlledOrDefaultBoolean
} from "./chunks/chunk-PWB4AEF6.mjs";
import {
  idMatches,
  notifyChange,
  readPayloadId
} from "./chunks/chunk-EAQ6WQNO.mjs";
import {
  Component,
  VanillaMachine,
  canPushEvent,
  compact,
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
  queryAll,
  raf
} from "./chunks/chunk-CLKNJROH.mjs";

// ../node_modules/.pnpm/@zag-js+dialog@1.43.3/node_modules/@zag-js/dialog/dist/dialog.anatomy.mjs
var anatomy = createAnatomy("dialog").parts(
  "trigger",
  "backdrop",
  "positioner",
  "content",
  "title",
  "description",
  "closeTrigger"
);
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+dialog@1.43.3/node_modules/@zag-js/dialog/dist/dialog.dom.mjs
var getPositionerId = (ctx) => ctx.ids?.positioner ?? `dialog:${ctx.id}:positioner`;
var getBackdropId = (ctx) => ctx.ids?.backdrop ?? `dialog:${ctx.id}:backdrop`;
var getContentId = (ctx) => ctx.ids?.content ?? `dialog:${ctx.id}:content`;
var getTriggerId = (ctx, value) => {
  const customId = ctx.ids?.trigger;
  if (customId != null) return isFunction(customId) ? customId(value) : customId;
  return value ? `dialog:${ctx.id}:trigger:${value}` : `dialog:${ctx.id}:trigger`;
};
var getTitleId = (ctx) => ctx.ids?.title ?? `dialog:${ctx.id}:title`;
var getDescriptionId = (ctx) => ctx.ids?.description ?? `dialog:${ctx.id}:description`;
var getCloseTriggerId = (ctx) => ctx.ids?.closeTrigger ?? `dialog:${ctx.id}:close`;
var getContentEl = (ctx) => ctx.getById(getContentId(ctx));
var getPositionerEl = (ctx) => ctx.getById(getPositionerId(ctx));
var getBackdropEl = (ctx) => ctx.getById(getBackdropId(ctx));
var getTriggerEl = (ctx) => ctx.getById(getTriggerId(ctx));
var getTitleEl = (ctx) => ctx.getById(getTitleId(ctx));
var getDescriptionEl = (ctx) => ctx.getById(getDescriptionId(ctx));
var getCloseTriggerEl = (ctx) => ctx.getById(getCloseTriggerId(ctx));
var getTriggerEls = (ctx) => queryAll(ctx.getRootNode(), `[data-scope="dialog"][data-part="trigger"]${getByOwnerId(ctx.id)}`);
var getActiveTriggerEl = (ctx, value) => {
  if (value == null) {
    return getTriggerEl(ctx) ?? getTriggerEls(ctx)[0];
  }
  return ctx.getById(getTriggerId(ctx, value));
};

// ../node_modules/.pnpm/@zag-js+dialog@1.43.3/node_modules/@zag-js/dialog/dist/dialog.connect.mjs
function connect(service, normalize) {
  const { state, send, context, prop, scope } = service;
  const ariaLabel = prop("aria-label");
  const open = state.matches("open");
  const triggerValue = context.get("triggerValue");
  return {
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
    getTriggerProps(props = {}) {
      const { value } = props;
      const current = value == null ? false : triggerValue === value;
      return normalize.button({
        ...parts.trigger.attrs,
        dir: prop("dir"),
        id: getTriggerId(scope, value),
        "data-ownedby": scope.id,
        "data-value": value,
        "aria-haspopup": "dialog",
        type: "button",
        "aria-expanded": value == null ? open : open && current,
        "data-state": open ? "open" : "closed",
        "aria-controls": getContentId(scope),
        "data-current": dataAttr(current),
        onClick(event) {
          if (event.defaultPrevented) return;
          const shouldSwitch = open && value != null && !current;
          send({ type: shouldSwitch ? "TRIGGER_VALUE.SET" : "TOGGLE", value });
        }
      });
    },
    getBackdropProps() {
      return normalize.element({
        ...parts.backdrop.attrs,
        dir: prop("dir"),
        hidden: !open,
        id: getBackdropId(scope),
        "data-state": open ? "open" : "closed"
      });
    },
    getPositionerProps() {
      return normalize.element({
        ...parts.positioner.attrs,
        dir: prop("dir"),
        id: getPositionerId(scope),
        style: compact({
          pointerEvents: !open || !prop("modal") ? "none" : void 0
        })
      });
    },
    getContentProps() {
      const rendered = context.get("rendered");
      return normalize.element({
        ...parts.content.attrs,
        dir: prop("dir"),
        role: prop("role"),
        hidden: !open,
        id: getContentId(scope),
        tabIndex: -1,
        "data-state": open ? "open" : "closed",
        "aria-modal": prop("modal"),
        "aria-label": ariaLabel || void 0,
        "aria-labelledby": ariaLabel || !rendered.title ? void 0 : getTitleId(scope),
        "aria-describedby": rendered.description ? getDescriptionId(scope) : void 0,
        style: compact({
          pointerEvents: prop("modal") ? void 0 : "auto"
        })
      });
    },
    getTitleProps() {
      return normalize.element({
        ...parts.title.attrs,
        dir: prop("dir"),
        id: getTitleId(scope)
      });
    },
    getDescriptionProps() {
      return normalize.element({
        ...parts.description.attrs,
        dir: prop("dir"),
        id: getDescriptionId(scope)
      });
    },
    getCloseTriggerProps() {
      return normalize.button({
        ...parts.closeTrigger.attrs,
        dir: prop("dir"),
        id: getCloseTriggerId(scope),
        type: "button",
        onClick(event) {
          if (event.defaultPrevented) return;
          event.stopPropagation();
          send({ type: "CLOSE" });
        }
      });
    }
  };
}

// ../node_modules/.pnpm/@zag-js+dialog@1.43.3/node_modules/@zag-js/dialog/dist/dialog.machine.mjs
var machine = createMachine({
  props({ props, scope }) {
    const alertDialog = props.role === "alertdialog";
    const initialFocusEl = alertDialog ? () => getCloseTriggerEl(scope) : void 0;
    const modal = typeof props.modal === "boolean" ? props.modal : true;
    return {
      role: "dialog",
      modal,
      trapFocus: modal,
      preventScroll: modal,
      closeOnInteractOutside: modal && !alertDialog,
      closeOnEscape: true,
      restoreFocus: true,
      initialFocusEl,
      ...props
    };
  },
  initialState({ prop }) {
    const open = prop("open") || prop("defaultOpen");
    return open ? "open" : "closed";
  },
  context({ bindable, prop, scope }) {
    return {
      rendered: bindable(() => ({
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
  watch({ track, action, prop }) {
    track([() => prop("open")], () => {
      action(["toggleVisibility"]);
    });
  },
  states: {
    open: {
      entry: ["checkRenderedElements", "setInitialFocus"],
      effects: ["trackDismissableElement", "trapFocus", "preventScroll", "hideContentBelow"],
      on: {
        "CONTROLLED.CLOSE": {
          target: "closed"
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
        "TRIGGER_VALUE.SET": {
          actions: ["setTriggerValue"]
        }
      }
    },
    closed: {
      on: {
        "CONTROLLED.OPEN": {
          target: "open"
        },
        OPEN: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen", "setTriggerValue"]
          },
          {
            target: "open",
            actions: ["invokeOnOpen", "setTriggerValue"]
          }
        ],
        TOGGLE: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen", "setTriggerValue"]
          },
          {
            target: "open",
            actions: ["invokeOnOpen", "setTriggerValue"]
          }
        ],
        "TRIGGER_VALUE.SET": {
          actions: ["setTriggerValue"]
        }
      }
    }
  },
  implementations: {
    guards: {
      isOpenControlled: ({ prop }) => prop("open") != void 0
    },
    effects: {
      trackDismissableElement({ scope, send, prop }) {
        const getContentEl2 = () => getContentEl(scope);
        return trackDismissableElement(getContentEl2, {
          type: "dialog",
          defer: true,
          pointerBlocking: prop("modal"),
          layerStyleTargets: [() => getBackdropEl(scope), () => getPositionerEl(scope)],
          exclude: [getTriggerEl(scope), ...getTriggerEls(scope)].filter(Boolean),
          onInteractOutside(event) {
            prop("onInteractOutside")?.(event);
            if (!prop("closeOnInteractOutside")) {
              event.preventDefault();
            }
          },
          persistentElements: prop("persistentElements"),
          onFocusOutside: prop("onFocusOutside"),
          onPointerDownOutside: prop("onPointerDownOutside"),
          onRequestDismiss: prop("onRequestDismiss"),
          onEscapeKeyDown(event) {
            prop("onEscapeKeyDown")?.(event);
            if (!prop("closeOnEscape")) {
              event.preventDefault();
            }
          },
          onDismiss() {
            send({ type: "CLOSE", src: "interact-outside" });
          }
        });
      },
      preventScroll({ scope, prop }) {
        if (!prop("preventScroll")) return;
        return preventBodyScroll(scope.getDoc());
      },
      trapFocus({ scope, prop, context }) {
        if (!prop("trapFocus")) return;
        const contentEl = () => getContentEl(scope);
        return trapFocus(contentEl, {
          preventScroll: true,
          returnFocusOnDeactivate: !!prop("restoreFocus"),
          initialFocus: () => getInitialFocus({
            root: getContentEl(scope),
            getInitialEl: prop("initialFocusEl")
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
      },
      hideContentBelow({ scope, prop }) {
        if (!prop("modal")) return;
        const getElements = () => [getContentEl(scope)];
        return ariaHidden(getElements, { defer: true });
      }
    },
    actions: {
      setInitialFocus({ prop, scope }) {
        if (prop("trapFocus")) return;
        raf(() => {
          const element = getInitialFocus({
            root: getContentEl(scope),
            getInitialEl: prop("initialFocusEl")
          });
          element?.focus({ preventScroll: true });
        });
      },
      checkRenderedElements({ context, scope }) {
        raf(() => {
          context.set("rendered", {
            title: !!getTitleEl(scope),
            description: !!getDescriptionEl(scope)
          });
        });
      },
      invokeOnClose({ prop }) {
        prop("onOpenChange")?.({ open: false });
      },
      invokeOnOpen({ prop }) {
        prop("onOpenChange")?.({ open: true });
      },
      setTriggerValue({ context, event }) {
        if (event.value === void 0) return;
        context.set("triggerValue", event.value);
      },
      toggleVisibility({ prop, send, event }) {
        send({
          type: prop("open") ? "CONTROLLED.OPEN" : "CONTROLLED.CLOSE",
          previousEvent: event
        });
      }
    }
  }
});

// components/dialog.ts
function dialogInitialAriaLabel(rootEl) {
  const titleEl = rootEl.querySelector('[data-scope="dialog"][data-part="title"]');
  if (titleEl?.textContent?.trim()) return void 0;
  const fromDataset = getString(rootEl, "dialogDefaultLabel")?.trim();
  if (fromDataset) return fromDataset;
  return "Dialog";
}
function syncDialogContentAriaRefs(rootEl, contentEl) {
  const titleEl = rootEl.querySelector('[data-scope="dialog"][data-part="title"]');
  if (!titleEl?.textContent?.trim()) {
    contentEl.removeAttribute("aria-labelledby");
    const label = dialogInitialAriaLabel(rootEl);
    if (label) {
      contentEl.setAttribute("aria-label", label);
    } else {
      contentEl.removeAttribute("aria-label");
    }
  } else {
    contentEl.removeAttribute("aria-label");
  }
  const descriptionEl = rootEl.querySelector(
    '[data-scope="dialog"][data-part="description"]'
  );
  if (!descriptionEl?.textContent?.trim()) {
    contentEl.removeAttribute("aria-describedby");
  }
}
var Dialog = class extends Component {
  initMachine(props) {
    return new VanillaMachine(machine, props);
  }
  initApi() {
    return this.zagConnect(connect);
  }
  render() {
    const rootEl = this.el;
    const animation = rootEl.dataset.animation ?? "instant";
    const triggerEl = rootEl.querySelector(
      '[data-scope="dialog"][data-part="trigger"]'
    );
    if (triggerEl) this.spreadProps(triggerEl, this.api.getTriggerProps());
    const backdropEl = rootEl.querySelector(
      '[data-scope="dialog"][data-part="backdrop"]'
    );
    if (backdropEl) {
      const rawBackdrop = this.api.getBackdropProps();
      if (animation === "instant") {
        this.spreadProps(backdropEl, rawBackdrop);
      } else if (animation === "js" || animation === "custom") {
        this.spreadProps(backdropEl, stripHiddenFromProps(rawBackdrop));
        backdropEl.removeAttribute("hidden");
      }
    }
    const positionerEl = rootEl.querySelector(
      '[data-scope="dialog"][data-part="positioner"]'
    );
    if (positionerEl) this.spreadProps(positionerEl, this.api.getPositionerProps());
    const contentEl = rootEl.querySelector(
      '[data-scope="dialog"][data-part="content"]'
    );
    if (contentEl) {
      const rawContent = this.api.getContentProps();
      if (animation === "instant") {
        this.spreadProps(contentEl, rawContent);
      } else if (animation === "js" || animation === "custom") {
        this.spreadProps(contentEl, stripHiddenFromProps(rawContent));
        contentEl.removeAttribute("hidden");
        if (!this.api.open) {
          contentEl.style.removeProperty("pointer-events");
        }
      }
      syncDialogContentAriaRefs(rootEl, contentEl);
    }
    const titleEl = rootEl.querySelector('[data-scope="dialog"][data-part="title"]');
    if (titleEl) this.spreadProps(titleEl, this.api.getTitleProps());
    const descriptionEl = rootEl.querySelector(
      '[data-scope="dialog"][data-part="description"]'
    );
    if (descriptionEl) this.spreadProps(descriptionEl, this.api.getDescriptionProps());
    const closeTriggerEl = rootEl.querySelector(
      '[data-scope="dialog"][data-part="close-trigger"]'
    );
    if (closeTriggerEl) this.spreadProps(closeTriggerEl, this.api.getCloseTriggerProps());
  }
};

// lib/focus.ts
function resolveFocusElement(root, id) {
  if (!id) return null;
  const scoped = root.querySelector(`#${CSS.escape(id)}`);
  if (scoped) return scoped;
  const byId = document.getElementById(id);
  if (byId && root.contains(byId)) return byId;
  return null;
}

// hooks/dialog.ts
var DIALOG_SCALE_SELECTOR = '[data-scope="dialog"][data-part="backdrop"], [data-scope="dialog"][data-part="content"]';
function readDialogLayoutProps(el) {
  const role = getString(el, "role", ["dialog", "alertdialog"]) ?? "dialog";
  const initialFocusId = getString(el, "initialFocus");
  const finalFocusId = getString(el, "finalFocus");
  return {
    id: el.id,
    role,
    modal: getBoolean(el, "modal"),
    closeOnInteractOutside: getBoolean(el, "closeOnInteractOutside"),
    closeOnEscape: getBoolean(el, "closeOnEscapeKeyDown"),
    preventScroll: getBoolean(el, "preventScroll"),
    restoreFocus: getBoolean(el, "restoreFocus"),
    dir: getDir(el),
    initialFocusEl: initialFocusId ? () => resolveFocusElement(el, initialFocusId) : void 0,
    finalFocusEl: finalFocusId ? () => resolveFocusElement(el, finalFocusId) : void 0
  };
}
function runDialogScaleTransitions(el, isOpen) {
  const opts = readScaleAnimationOptions(el);
  const blockRoot = opts.blockInteraction ? el : void 0;
  const backdrop = el.querySelector('[data-scope="dialog"][data-part="backdrop"]');
  const content = el.querySelector('[data-scope="dialog"][data-part="content"]');
  if (backdrop) runScaleAnimation(backdrop, isOpen, opts, blockRoot);
  if (content) runScaleAnimation(content, isOpen, opts, blockRoot);
}
function runDialogScaleIfJs(el, isOpen) {
  if (!isJsAnimation(el)) return;
  runDialogScaleTransitions(el, isOpen);
}
var DialogHook = createZagLiveHook({
  key: "dialog",
  mount(hook, { dom, server }) {
    const el = hook.el;
    const self = hook;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);
    self.lastOpen = readControlledOrDefaultBoolean(el, "open", "defaultOpen");
    const dialog = new Dialog(el, {
      ...readDialogLayoutProps(el),
      ...readBooleanControlledZagProps(el, "open", "defaultOpen"),
      "aria-label": dialogInitialAriaLabel(el),
      onOpenChange: (details) => {
        const controlled = getBoolean(el, "controlled");
        const previousOpen = controlled ? readControlledOrDefaultBoolean(el, "open", "defaultOpen") : self.lastOpen ?? false;
        if (!controlled) {
          self.lastOpen = details.open;
        }
        const payload = {
          id: el.id,
          open: details.open,
          previousOpen
        };
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload,
          serverEventName: getString(el, "onOpenChange"),
          clientEventName: getString(el, "onOpenChangeClient")
        });
        if (isJsAnimation(el) && !getBoolean(el, "controlled")) {
          runDialogScaleTransitions(el, details.open);
        }
      }
    });
    prepareJsScaleInitialState(el, DIALOG_SCALE_SELECTOR, (sub) => {
      if (sub.dataset.part === "backdrop") return { scale: false };
    });
    dom.add("corex:dialog:set-open", (event) => {
      const { open } = event.detail;
      dialog.api.setOpen(open);
    });
    server.add("dialog_set_open", (payload) => {
      if (!payload || typeof payload !== "object") return;
      const o = payload;
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (typeof o.open === "boolean") dialog.api.setOpen(o.open);
    });
    server.add("dialog_open", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (!canPush()) return;
      hook.pushEvent("dialog_open_response", {
        id: el.id,
        value: dialog.api.open
      });
    });
    return dialog;
  },
  beforeUpdate(hook) {
    const { el } = hook;
    if (getBoolean(el, "controlled") && isJsAnimation(el)) {
      hook.previousOpen = getBoolean(el, "open");
    }
  },
  update(hook, dialog) {
    const { el } = hook;
    const layout = readDialogLayoutProps(el);
    if (!getBoolean(el, "controlled")) {
      dialog.updateProps(layout);
      return;
    }
    const nextOpen = getBoolean(el, "open") ?? false;
    const prevOpen = hook.previousOpen ?? hook.lastOpen ?? false;
    hook.previousOpen = void 0;
    hook.lastOpen = nextOpen;
    dialog.updateProps({ ...layout, open: nextOpen });
    if (nextOpen !== prevOpen) {
      runDialogScaleIfJs(el, nextOpen);
    }
  }
});
export {
  DialogHook as Dialog,
  readDialogLayoutProps
};
