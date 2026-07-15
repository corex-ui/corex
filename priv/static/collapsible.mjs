import {
  toPx
} from "./chunks/chunk-PE34YET2.mjs";
import {
  readBooleanControlledZagProps,
  readBooleanControlledZagUpdate
} from "./chunks/chunk-BGER3KYP.mjs";
import {
  snapshotDataset
} from "./chunks/chunk-TKOH2OAC.mjs";
import {
  createDomEventRegistry,
  createHookHandleEventRegistry
} from "./chunks/chunk-77HPO22C.mjs";
import {
  emitResponse,
  idMatches,
  notifyChange,
  parseRespondTo,
  readPayloadId
} from "./chunks/chunk-LNVRIZ4K.mjs";
import {
  Component,
  VanillaMachine,
  canPushEvent,
  createAnatomy,
  createMachine,
  dataAttr,
  getBoolean,
  getComputedStyle,
  getDir,
  getEventTarget,
  getString,
  getTabbables,
  nextTick,
  observeChildren,
  raf,
  setAttribute,
  setStyle
} from "./chunks/chunk-6AOEC32Q.mjs";

// ../node_modules/.pnpm/@zag-js+collapsible@1.40.0/node_modules/@zag-js/collapsible/dist/collapsible.anatomy.mjs
var anatomy = createAnatomy("collapsible").parts("root", "trigger", "content", "indicator");
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+collapsible@1.40.0/node_modules/@zag-js/collapsible/dist/collapsible.dom.mjs
var getRootId = (ctx) => ctx.ids?.root ?? `collapsible:${ctx.id}`;
var getContentId = (ctx) => ctx.ids?.content ?? `collapsible:${ctx.id}:content`;
var getTriggerId = (ctx) => ctx.ids?.trigger ?? `collapsible:${ctx.id}:trigger`;
var getContentEl = (ctx) => ctx.getById(getContentId(ctx));

// ../node_modules/.pnpm/@zag-js+collapsible@1.40.0/node_modules/@zag-js/collapsible/dist/collapsible.connect.mjs
function connect(service, normalize) {
  const { state, send, context, scope, prop } = service;
  const visible = state.matches("open") || state.matches("closing");
  const open = state.matches("open");
  const closed = state.matches("closed");
  const { width, height } = context.get("size");
  const disabled = !!prop("disabled");
  const collapsedHeight = prop("collapsedHeight");
  const collapsedWidth = prop("collapsedWidth");
  const hasCollapsedHeight = collapsedHeight != null;
  const hasCollapsedWidth = collapsedWidth != null;
  const hasCollapsedSize = hasCollapsedHeight || hasCollapsedWidth;
  const skip = !context.get("initial") && open;
  return {
    disabled,
    visible,
    open,
    measureSize() {
      send({ type: "size.measure" });
    },
    setOpen(nextOpen) {
      const open2 = state.matches("open");
      if (open2 === nextOpen) return;
      send({ type: nextOpen ? "open" : "close" });
    },
    getRootProps() {
      return normalize.element({
        ...parts.root.attrs,
        "data-state": open ? "open" : "closed",
        dir: prop("dir"),
        id: getRootId(scope)
      });
    },
    getContentProps() {
      return normalize.element({
        ...parts.content.attrs,
        id: getContentId(scope),
        "data-collapsible": "",
        "data-state": skip ? void 0 : open ? "open" : "closed",
        "data-disabled": dataAttr(disabled),
        "data-has-collapsed-size": dataAttr(hasCollapsedSize),
        hidden: !visible && !hasCollapsedSize,
        dir: prop("dir"),
        style: {
          "--height": toPx(height),
          "--width": toPx(width),
          "--collapsed-height": toPx(collapsedHeight),
          "--collapsed-width": toPx(collapsedWidth),
          ...closed && hasCollapsedHeight && {
            overflow: "hidden",
            minHeight: toPx(collapsedHeight),
            maxHeight: toPx(collapsedHeight)
          },
          ...closed && hasCollapsedWidth && {
            overflow: "hidden",
            minWidth: toPx(collapsedWidth),
            maxWidth: toPx(collapsedWidth)
          }
        }
      });
    },
    getTriggerProps() {
      return normalize.element({
        ...parts.trigger.attrs,
        id: getTriggerId(scope),
        dir: prop("dir"),
        type: "button",
        "data-state": open ? "open" : "closed",
        "data-disabled": dataAttr(disabled),
        "aria-controls": getContentId(scope),
        "aria-expanded": visible || false,
        onClick(event) {
          if (event.defaultPrevented) return;
          if (disabled) return;
          send({ type: open ? "close" : "open" });
        }
      });
    },
    getIndicatorProps() {
      return normalize.element({
        ...parts.indicator.attrs,
        dir: prop("dir"),
        "data-state": open ? "open" : "closed",
        "data-disabled": dataAttr(disabled)
      });
    }
  };
}

// ../node_modules/.pnpm/@zag-js+collapsible@1.40.0/node_modules/@zag-js/collapsible/dist/collapsible.machine.mjs
var machine = createMachine({
  initialState({ prop }) {
    const open = prop("open") || prop("defaultOpen");
    return open ? "open" : "closed";
  },
  context({ bindable }) {
    return {
      size: bindable(() => ({
        defaultValue: { height: 0, width: 0 },
        sync: true
      })),
      initial: bindable(() => ({
        defaultValue: false
      }))
    };
  },
  refs() {
    return {
      cleanup: void 0,
      stylesRef: void 0
    };
  },
  watch({ track, prop, action }) {
    track([() => prop("open")], () => {
      action(["setInitial", "computeSize", "toggleVisibility"]);
    });
  },
  exit: ["cleanupNode"],
  states: {
    closed: {
      effects: ["trackTabbableElements"],
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
            actions: ["setInitial", "computeSize", "invokeOnOpen"]
          }
        ]
      }
    },
    closing: {
      effects: ["trackExitAnimation"],
      on: {
        "controlled.close": {
          target: "closed"
        },
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
            actions: ["setInitial", "invokeOnOpen"]
          }
        ],
        close: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnExitComplete"]
          },
          {
            target: "closed",
            actions: ["setInitial", "computeSize", "invokeOnExitComplete"]
          }
        ],
        "animation.end": {
          target: "closed",
          actions: ["invokeOnExitComplete", "clearInitial"]
        }
      }
    },
    open: {
      effects: ["trackEnterAnimation"],
      on: {
        "controlled.close": {
          target: "closing"
        },
        close: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnClose"]
          },
          {
            target: "closing",
            actions: ["setInitial", "computeSize", "invokeOnClose"]
          }
        ],
        "size.measure": {
          actions: ["measureSize"]
        },
        "animation.end": {
          actions: ["clearInitial"]
        }
      }
    }
  },
  implementations: {
    guards: {
      isOpenControlled: ({ prop }) => prop("open") != void 0
    },
    effects: {
      trackEnterAnimation: ({ send, scope }) => {
        let cleanup;
        const rafCleanup = raf(() => {
          const contentEl = getContentEl(scope);
          if (!contentEl) return;
          const animationName = getComputedStyle(contentEl).animationName;
          const hasNoAnimation = !animationName || animationName === "none";
          if (hasNoAnimation) {
            send({ type: "animation.end" });
            return;
          }
          const onEnd = (event) => {
            const target = getEventTarget(event);
            if (target === contentEl) {
              send({ type: "animation.end" });
            }
          };
          contentEl.addEventListener("animationend", onEnd);
          cleanup = () => {
            contentEl.removeEventListener("animationend", onEnd);
          };
        });
        return () => {
          rafCleanup();
          cleanup?.();
        };
      },
      trackExitAnimation: ({ send, scope }) => {
        let cleanup;
        const rafCleanup = raf(() => {
          const contentEl = getContentEl(scope);
          if (!contentEl) return;
          const animationName = getComputedStyle(contentEl).animationName;
          const hasNoAnimation = !animationName || animationName === "none";
          if (hasNoAnimation) {
            send({ type: "animation.end" });
            return;
          }
          const onEnd = (event) => {
            const target = getEventTarget(event);
            if (target === contentEl) {
              send({ type: "animation.end" });
            }
          };
          contentEl.addEventListener("animationend", onEnd);
          const restoreStyles = setStyle(contentEl, {
            animationFillMode: "forwards"
          });
          cleanup = () => {
            contentEl.removeEventListener("animationend", onEnd);
            nextTick(() => restoreStyles());
          };
        });
        return () => {
          rafCleanup();
          cleanup?.();
        };
      },
      trackTabbableElements: ({ scope, prop }) => {
        if (!prop("collapsedHeight") && !prop("collapsedWidth")) return;
        const contentEl = getContentEl(scope);
        if (!contentEl) return;
        const applyInertToTabbables = () => {
          const tabbables = getTabbables(contentEl);
          const restoreAttrs = tabbables.map((tabbable) => setAttribute(tabbable, "inert", ""));
          return () => {
            restoreAttrs.forEach((attr) => attr());
          };
        };
        let restoreInert = applyInertToTabbables();
        const observerCleanup = observeChildren(contentEl, {
          callback() {
            restoreInert();
            restoreInert = applyInertToTabbables();
          }
        });
        return () => {
          restoreInert();
          observerCleanup();
        };
      }
    },
    actions: {
      setInitial: ({ context, flush }) => {
        flush(() => {
          context.set("initial", true);
        });
      },
      clearInitial: ({ context }) => {
        context.set("initial", false);
      },
      cleanupNode: ({ refs }) => {
        refs.set("stylesRef", null);
      },
      measureSize: ({ context, scope }) => {
        const contentEl = getContentEl(scope);
        if (!contentEl) return;
        const { height, width } = contentEl.getBoundingClientRect();
        context.set("size", { height, width });
      },
      computeSize: ({ refs, scope, context }) => {
        refs.get("cleanup")?.();
        const rafCleanup = raf(() => {
          const contentEl = getContentEl(scope);
          if (!contentEl) return;
          const hidden = contentEl.hidden;
          contentEl.style.animationName = "none";
          contentEl.style.animationDuration = "0s";
          contentEl.hidden = false;
          const rect = contentEl.getBoundingClientRect();
          context.set("size", { height: rect.height, width: rect.width });
          if (context.get("initial")) {
            contentEl.style.animationName = "";
            contentEl.style.animationDuration = "";
          }
          contentEl.hidden = hidden;
        });
        refs.set("cleanup", rafCleanup);
      },
      invokeOnOpen: ({ prop }) => {
        prop("onOpenChange")?.({ open: true });
      },
      invokeOnClose: ({ prop }) => {
        prop("onOpenChange")?.({ open: false });
      },
      invokeOnExitComplete: ({ prop }) => {
        prop("onExitComplete")?.();
      },
      toggleVisibility: ({ prop, send }) => {
        send({ type: prop("open") ? "controlled.open" : "controlled.close" });
      }
    }
  }
});

// components/collapsible.ts
var Collapsible = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props) {
    return new VanillaMachine(machine, props);
  }
  initApi() {
    return this.zagConnect(connect);
  }
  render() {
    const orientation = this.el.dataset.orientation;
    const rootEl = this.el.querySelector(
      '[data-scope="collapsible"][data-part="root"]'
    );
    if (rootEl) {
      this.spreadProps(rootEl, this.api.getRootProps());
      if (orientation) rootEl.dataset.orientation = orientation;
      const triggerEl = rootEl.querySelector(
        '[data-scope="collapsible"][data-part="trigger"]'
      );
      if (triggerEl) {
        this.spreadProps(triggerEl, this.api.getTriggerProps());
        if (orientation) triggerEl.dataset.orientation = orientation;
      }
      const contentEl = rootEl.querySelector(
        '[data-scope="collapsible"][data-part="content"]'
      );
      if (contentEl) {
        this.spreadProps(contentEl, this.api.getContentProps());
        if (orientation) contentEl.dataset.orientation = orientation;
      }
    }
  }
};

// hooks/collapsible.ts
function openChangePayload(el, details) {
  return {
    id: el.id,
    open: details.open
  };
}
var CollapsibleHook = {
  mounted() {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
    const collapsible = new Collapsible(el, {
      id: el.id,
      ...readBooleanControlledZagProps(el, "open", "defaultOpen"),
      disabled: getBoolean(el, "disabled"),
      dir: getDir(el),
      onOpenChange: (details) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: openChangePayload(el, details),
          serverEventName: getString(el, "onOpenChange"),
          clientEventName: getString(el, "onOpenChangeClient")
        });
      }
    });
    collapsible.init();
    this.collapsible = collapsible;
    const emitOpen = (respondTo) => {
      emitResponse({
        respondTo,
        canPushServer: canPush(),
        pushEvent,
        serverEventName: "collapsible_open_response",
        serverPayload: {
          id: el.id,
          open: collapsible.api.open,
          disabled: collapsible.api.disabled
        },
        el,
        domEventName: "collapsible-open",
        domDetail: {
          id: el.id,
          open: collapsible.api.open,
          disabled: collapsible.api.disabled
        }
      });
    };
    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;
    domRegistry.add("corex:collapsible:set-open", (event) => {
      const { open } = event.detail;
      collapsible.api.setOpen(open);
    });
    domRegistry.add("corex:collapsible:open", (event) => {
      emitOpen(parseRespondTo(event.detail));
    });
    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;
    registry.add("collapsible_set_open", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      collapsible.api.setOpen(payload.open);
    });
    registry.add("collapsible_open", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitOpen(parseRespondTo(payload));
    });
  },
  beforeUpdate() {
    this.beforeAttrs = snapshotDataset(this.el, ["open"]);
  },
  updated() {
    try {
      const openPatch = readBooleanControlledZagUpdate(
        this.el,
        "open",
        "defaultOpen",
        this.beforeAttrs
      );
      this.collapsible?.updateProps({
        id: this.el.id,
        ...openPatch,
        disabled: getBoolean(this.el, "disabled"),
        dir: getDir(this.el)
      });
    } finally {
      this.beforeAttrs = void 0;
    }
  },
  destroyed() {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.collapsible?.destroy();
  }
};
export {
  CollapsibleHook as Collapsible,
  openChangePayload
};
