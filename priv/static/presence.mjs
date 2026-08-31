import {
  idMatches,
  readPayloadId
} from "./chunks/chunk-EAQ6WQNO.mjs";
import {
  Component,
  VanillaMachine,
  canPushEvent,
  createMachine,
  createZagLiveHook,
  getComputedStyle,
  getEventTarget,
  getString,
  getWindow,
  nextTick,
  raf,
  setStyle
} from "./chunks/chunk-R62PCG6O.mjs";

// ../node_modules/.pnpm/@zag-js+presence@1.43.3/node_modules/@zag-js/presence/dist/presence.connect.mjs
function connect(service, _normalize) {
  const { state, send, context } = service;
  const present = state.matches("mounted", "unmountSuspended");
  return {
    skip: !context.get("initial"),
    present,
    setNode(node) {
      if (!node) return;
      send({ type: "NODE.SET", node });
    },
    unmount() {
      send({ type: "UNMOUNT" });
    }
  };
}

// ../node_modules/.pnpm/@zag-js+presence@1.43.3/node_modules/@zag-js/presence/dist/presence.machine.mjs
var machine = createMachine({
  props({ props }) {
    return { ...props, present: !!props.present };
  },
  initialState({ prop }) {
    return prop("present") ? "mounted" : "unmounted";
  },
  refs() {
    return {
      node: null,
      styles: null
    };
  },
  context({ bindable }) {
    return {
      unmountAnimationName: bindable(() => ({ defaultValue: null })),
      prevAnimationName: bindable(() => ({ defaultValue: null })),
      present: bindable(() => ({ defaultValue: false })),
      initial: bindable(() => ({
        sync: true,
        defaultValue: false
      }))
    };
  },
  exit: ["cleanupNode"],
  watch({ track, prop, send }) {
    track([() => prop("present")], () => {
      send({ type: "PRESENCE.CHANGED" });
    });
  },
  on: {
    "NODE.SET": {
      actions: ["setupNode"]
    },
    "PRESENCE.CHANGED": {
      actions: ["setInitial", "syncPresence"]
    }
  },
  states: {
    mounted: {
      effects: ["trackEnterAnimation"],
      on: {
        UNMOUNT: {
          target: "unmounted",
          actions: ["clearPrevAnimationName", "invokeOnExitComplete"]
        },
        "UNMOUNT.SUSPEND": {
          target: "unmountSuspended"
        }
      }
    },
    unmountSuspended: {
      effects: ["trackExitAnimation"],
      on: {
        MOUNT: {
          target: "mounted",
          actions: ["setPrevAnimationName"]
        },
        UNMOUNT: {
          target: "unmounted",
          actions: ["clearPrevAnimationName", "invokeOnExitComplete"]
        }
      }
    },
    unmounted: {
      on: {
        MOUNT: {
          target: "mounted",
          actions: ["setPrevAnimationName"]
        }
      }
    }
  },
  implementations: {
    actions: {
      setInitial: ({ context }) => {
        if (context.get("initial")) return;
        queueMicrotask(() => {
          context.set("initial", true);
        });
      },
      invokeOnExitComplete: ({ prop, refs }) => {
        prop("onExitComplete")?.();
        const node = refs.get("node");
        if (!node) return;
        const win = getWindow(node);
        const event = new win.CustomEvent("exitcomplete", { bubbles: false });
        node.dispatchEvent(event);
      },
      setupNode: ({ refs, event }) => {
        if (refs.get("node") === event.node) return;
        refs.set("node", event.node);
        refs.set("styles", getComputedStyle(event.node));
      },
      cleanupNode: ({ refs }) => {
        refs.set("node", null);
        refs.set("styles", null);
      },
      syncPresence: ({ context, refs, send, prop }) => {
        const presentProp = prop("present");
        if (presentProp) {
          return send({ type: "MOUNT", src: "presence.changed" });
        }
        const node = refs.get("node");
        if (!presentProp && node?.ownerDocument.visibilityState === "hidden") {
          return send({ type: "UNMOUNT", src: "visibilitychange" });
        }
        raf(() => {
          if (prop("present")) return;
          const animationName = getAnimationName(refs.get("styles"));
          context.set("unmountAnimationName", animationName);
          if (animationName === "none" || animationName === context.get("prevAnimationName") || refs.get("styles")?.display === "none" || refs.get("styles")?.animationDuration === "0s") {
            send({ type: "UNMOUNT", src: "presence.changed" });
          } else {
            send({ type: "UNMOUNT.SUSPEND" });
          }
        });
      },
      setPrevAnimationName: ({ context, refs }) => {
        raf(() => {
          context.set("prevAnimationName", getAnimationName(refs.get("styles")));
        });
      },
      clearPrevAnimationName: ({ context }) => {
        context.set("prevAnimationName", null);
      }
    },
    effects: {
      trackEnterAnimation: ({ context, refs, prop }) => {
        if (!prop("onEnterComplete") || !context.get("initial")) return;
        let cancel;
        const track = () => {
          cancel = raf(() => {
            const node = refs.get("node");
            if (!node || !node.isConnected) {
              track();
              return;
            }
            const styles = getComputedStyle(node);
            const animationName = getAnimationName(styles);
            if (animationName === "none" || styles.display === "none" || styles.animationDuration === "0s") {
              prop("onEnterComplete")?.();
              return;
            }
            const onEnd = (event) => {
              const target = getEventTarget(event);
              if (target !== node || !prop("present")) return;
              node.removeEventListener("animationend", onEnd);
              prop("onEnterComplete")?.();
            };
            node.addEventListener("animationend", onEnd);
            return () => {
              node.removeEventListener("animationend", onEnd);
            };
          });
        };
        track();
        return () => cancel?.();
      },
      trackExitAnimation: ({ context, refs, send, prop }) => {
        const node = refs.get("node");
        if (!node) return;
        const onStart = (event) => {
          const target = event.composedPath?.()?.[0] ?? event.target;
          if (target === node) {
            context.set("prevAnimationName", getAnimationName(refs.get("styles")));
          }
        };
        const onEnd = (event) => {
          const animationName = getAnimationName(refs.get("styles"));
          const target = getEventTarget(event);
          if (target === node && animationName === context.get("unmountAnimationName") && !prop("present")) {
            send({ type: "UNMOUNT", src: "animationend" });
          }
        };
        const onCancel = (event) => {
          const target = getEventTarget(event);
          if (target === node && !prop("present")) {
            send({ type: "UNMOUNT", src: "animationcancel" });
          }
        };
        node.addEventListener("animationstart", onStart);
        node.addEventListener("animationcancel", onCancel);
        node.addEventListener("animationend", onEnd);
        const cleanupStyles = setStyle(node, { animationFillMode: "forwards" });
        return () => {
          node.removeEventListener("animationstart", onStart);
          node.removeEventListener("animationcancel", onCancel);
          node.removeEventListener("animationend", onEnd);
          nextTick(() => cleanupStyles());
        };
      }
    }
  }
});
function getAnimationName(styles) {
  return styles?.animationName || "none";
}

// components/presence.ts
var Presence = class extends Component {
  initMachine(props) {
    return new VanillaMachine(machine, props);
  }
  initApi() {
    return this.zagConnect(connect);
  }
  render() {
    const root = this.el.querySelector('[data-scope="presence"][data-part="root"]') ?? this.el;
    this.api.setNode(root);
  }
};

// hooks/presence.ts
function presenceProps(el, hook, present) {
  const onExitComplete = () => {
    const eventName = getString(el, "onExitComplete");
    if (eventName && canPushEvent(hook.liveSocket)) {
      hook.pushEvent(eventName, { id: el.id });
    }
    const client = getString(el, "onExitCompleteClient");
    if (client) {
      el.dispatchEvent(new CustomEvent(client, { bubbles: true, detail: { id: el.id } }));
    }
  };
  return {
    present: present ?? el.dataset.present !== "false",
    onExitComplete
  };
}
var PresenceHook = createZagLiveHook({
  key: "presence",
  mount(hook, { dom, server }) {
    const inst = new Presence(hook.el, presenceProps(hook.el, hook));
    dom.add("corex:presence:set-present", (event) => {
      inst.updateProps(presenceProps(hook.el, hook, event.detail.present));
    });
    server.add("presence_set_present", (payload) => {
      if (!idMatches(hook.el.id, readPayloadId(payload))) return;
      inst.updateProps(presenceProps(hook.el, hook, payload.present));
    });
    return inst;
  },
  update(hook, inst) {
    inst.updateProps(presenceProps(hook.el, hook));
  }
});
export {
  PresenceHook as Presence
};
