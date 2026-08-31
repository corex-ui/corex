import {
  createValueEmitter,
  idMatches,
  notifyChange,
  parseRespondTo,
  readPayloadId
} from "./chunks/chunk-EAQ6WQNO.mjs";
import {
  createAnatomy
} from "./chunks/chunk-YMOPD357.mjs";
import {
  Component,
  VanillaMachine,
  canPushEvent,
  createMachine,
  createZagLiveHook,
  getString,
  observeAttributes,
  observeChildren
} from "./chunks/chunk-R62PCG6O.mjs";

// ../node_modules/.pnpm/@zag-js+avatar@1.43.3/node_modules/@zag-js/avatar/dist/avatar.anatomy.mjs
var anatomy = createAnatomy("avatar").parts("root", "image", "fallback");
var parts = anatomy.build();

// ../node_modules/.pnpm/@zag-js+avatar@1.43.3/node_modules/@zag-js/avatar/dist/avatar.dom.mjs
var getRootId = (ctx) => ctx.ids?.root ?? `avatar:${ctx.id}`;
var getImageId = (ctx) => ctx.ids?.image ?? `avatar:${ctx.id}:image`;
var getFallbackId = (ctx) => ctx.ids?.fallback ?? `avatar:${ctx.id}:fallback`;
var getRootEl = (ctx) => ctx.getById(getRootId(ctx));
var getImageEl = (ctx) => ctx.getById(getImageId(ctx));

// ../node_modules/.pnpm/@zag-js+avatar@1.43.3/node_modules/@zag-js/avatar/dist/avatar.connect.mjs
function connect(service, normalize) {
  const { state, send, prop, scope } = service;
  const loaded = state.matches("loaded");
  return {
    loaded,
    setSrc(src) {
      const img = getImageEl(scope);
      img?.setAttribute("src", src);
    },
    setLoaded() {
      send({ type: "img.loaded", src: "api" });
    },
    setError() {
      send({ type: "img.error", src: "api" });
    },
    getRootProps() {
      return normalize.element({
        ...parts.root.attrs,
        dir: prop("dir"),
        id: getRootId(scope)
      });
    },
    getImageProps() {
      return normalize.img({
        ...parts.image.attrs,
        hidden: !loaded,
        dir: prop("dir"),
        id: getImageId(scope),
        "data-state": loaded ? "visible" : "hidden",
        onLoad() {
          send({ type: "img.loaded", src: "element" });
        },
        onError() {
          send({ type: "img.error", src: "element" });
        }
      });
    },
    getFallbackProps() {
      return normalize.element({
        ...parts.fallback.attrs,
        dir: prop("dir"),
        id: getFallbackId(scope),
        hidden: loaded,
        "data-state": loaded ? "hidden" : "visible"
      });
    }
  };
}

// ../node_modules/.pnpm/@zag-js+avatar@1.43.3/node_modules/@zag-js/avatar/dist/avatar.machine.mjs
var machine = createMachine({
  initialState() {
    return "loading";
  },
  effects: ["trackImageRemoval", "trackSrcChange"],
  on: {
    "src.change": {
      target: "loading"
    },
    "img.unmount": {
      target: "error"
    }
  },
  states: {
    loading: {
      entry: ["checkImageStatus"],
      on: {
        "img.loaded": {
          target: "loaded",
          actions: ["invokeOnLoad"]
        },
        "img.error": {
          target: "error",
          actions: ["invokeOnError"]
        }
      }
    },
    error: {
      on: {
        "img.loaded": {
          target: "loaded",
          actions: ["invokeOnLoad"]
        }
      }
    },
    loaded: {
      on: {
        "img.error": {
          target: "error",
          actions: ["invokeOnError"]
        }
      }
    }
  },
  implementations: {
    actions: {
      invokeOnLoad({ prop }) {
        prop("onStatusChange")?.({ status: "loaded" });
      },
      invokeOnError({ prop }) {
        prop("onStatusChange")?.({ status: "error" });
      },
      checkImageStatus({ send, scope }) {
        const imageEl = getImageEl(scope);
        if (!imageEl?.complete) return;
        const type = hasLoaded(imageEl) ? "img.loaded" : "img.error";
        send({ type, src: "ssr" });
      }
    },
    effects: {
      trackImageRemoval({ send, scope }) {
        const rootEl = getRootEl(scope);
        return observeChildren(rootEl, {
          callback(records) {
            const removedNodes = Array.from(records[0].removedNodes);
            const removed = removedNodes.find(
              (node) => node.nodeType === Node.ELEMENT_NODE && node.matches("[data-scope=avatar][data-part=image]")
            );
            if (removed) {
              send({ type: "img.unmount" });
            }
          }
        });
      },
      trackSrcChange({ send, scope }) {
        const imageEl = getImageEl(scope);
        return observeAttributes(imageEl, {
          attributes: ["src", "srcset"],
          callback() {
            send({ type: "src.change" });
          }
        });
      }
    }
  }
});
function hasLoaded(image) {
  return image.complete && image.naturalWidth !== 0 && image.naturalHeight !== 0;
}

// components/avatar.ts
var Avatar = class extends Component {
  initMachine(props) {
    return new VanillaMachine(machine, props);
  }
  initApi() {
    return this.zagConnect(connect);
  }
  render() {
    const rootEl = this.el.querySelector('[data-scope="avatar"][data-part="root"]') ?? this.el;
    this.spreadProps(rootEl, this.api.getRootProps());
    const imageEl = this.el.querySelector('[data-scope="avatar"][data-part="image"]');
    if (imageEl) this.spreadProps(imageEl, this.api.getImageProps());
    const fallbackEl = this.el.querySelector(
      '[data-scope="avatar"][data-part="fallback"]'
    );
    if (fallbackEl) this.spreadProps(fallbackEl, this.api.getFallbackProps());
    const skeletonEl = this.el.querySelector(
      '[data-scope="avatar"][data-part="skeleton"]'
    );
    if (skeletonEl) {
      const state = this.machine.service.state;
      const loaded = state.matches("loaded");
      const error = state.matches("error");
      skeletonEl.hidden = loaded || error;
      skeletonEl.setAttribute("data-state", loaded || error ? "hidden" : "visible");
    }
  }
};

// hooks/avatar.ts
function statusPayload(el, details) {
  return { id: el.id, status: details.status };
}
var AvatarHook = createZagLiveHook({
  key: "avatar",
  mount(hook, { dom, server }) {
    const el = hook.el;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);
    const initialSrc = getString(el, "src");
    const zag = new Avatar(el, {
      id: el.id,
      dir: getString(el, "dir"),
      onStatusChange: (details) => {
        const flat = statusPayload(el, details);
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: flat,
          serverEventName: getString(el, "onStatusChange"),
          clientEventName: getString(el, "onStatusChangeClient")
        });
      }
    });
    hook.lastSrc = initialSrc;
    const emitLoaded = createValueEmitter(
      { el, pushEvent, canPushServer: canPush },
      {
        getPayload: () => ({ id: el.id, loaded: zag.api.loaded }),
        serverEventName: "avatar_loaded_response",
        domEventName: "avatar-loaded"
      }
    );
    dom.add("corex:avatar:set-src", (event) => {
      const next = event.detail?.src;
      if (typeof next !== "string") return;
      zag.api.setSrc(next);
      hook.lastSrc = next;
      el.dataset.src = next;
    });
    dom.add("corex:avatar:loaded", (event) => {
      emitLoaded(parseRespondTo(event.detail));
    });
    server.add("avatar_set_src", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.setSrc(payload.src);
      hook.lastSrc = payload.src;
      el.dataset.src = payload.src;
    });
    server.add("avatar_loaded", (payload) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitLoaded(parseRespondTo(payload));
    });
    return zag;
  },
  update(hook, zag) {
    const src = getString(hook.el, "src");
    const dir = getString(hook.el, "dir");
    zag.updateProps({
      ...dir !== void 0 ? { dir } : {}
    });
    if (src !== void 0 && src !== hook.lastSrc) {
      zag.api.setSrc(src);
      hook.lastSrc = src;
    }
    if (src === void 0 && hook.lastSrc !== void 0) {
      zag.api.setSrc("");
      hook.lastSrc = void 0;
    }
  }
});
export {
  AvatarHook as Avatar,
  statusPayload
};
