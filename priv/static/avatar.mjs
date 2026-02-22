import {
  Component,
  VanillaMachine,
  createAnatomy,
  createMachine,
  createProps,
  createSplitProps,
  getString,
  normalizeProps,
  observeAttributes,
  observeChildren
} from "./chunk-RUWIVFVB.mjs";

// ../node_modules/.pnpm/@zag-js+avatar@1.34.1/node_modules/@zag-js/avatar/dist/index.mjs
var anatomy = createAnatomy("avatar").parts("root", "image", "fallback");
var parts = anatomy.build();
var getRootId = (ctx) => ctx.ids?.root ?? `avatar:${ctx.id}`;
var getImageId = (ctx) => ctx.ids?.image ?? `avatar:${ctx.id}:image`;
var getFallbackId = (ctx) => ctx.ids?.fallback ?? `avatar:${ctx.id}:fallback`;
var getRootEl = (ctx) => ctx.getById(getRootId(ctx));
var getImageEl = (ctx) => ctx.getById(getImageId(ctx));
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
var props = createProps()(["dir", "id", "ids", "onStatusChange", "getRootNode"]);
var splitProps = createSplitProps(props);

// components/avatar.ts
var Avatar = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props2) {
    return new VanillaMachine(machine, props2);
  }
  initApi() {
    return connect(this.machine.service, normalizeProps);
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
var AvatarHook = {
  mounted() {
    const el = this.el;
    const src = getString(el, "src");
    const zag = new Avatar(el, {
      id: el.id,
      onStatusChange: (details) => {
        const eventName = getString(el, "onStatusChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, { status: details.status, id: el.id });
        }
        const clientName = getString(el, "onStatusChangeClient");
        if (clientName) {
          el.dispatchEvent(
            new CustomEvent(clientName, {
              bubbles: true,
              detail: { value: details, id: el.id }
            })
          );
        }
      },
      ...src !== void 0 ? {} : {}
    });
    zag.init();
    this.avatar = zag;
    if (src !== void 0) {
      zag.api.setSrc(src);
    }
    this.handlers = [];
  },
  updated() {
    const src = getString(this.el, "src");
    if (src !== void 0 && this.avatar) {
      this.avatar.api.setSrc(src);
    }
  },
  destroyed() {
    if (this.handlers) {
      for (const h of this.handlers) this.removeHandleEvent(h);
    }
    this.avatar?.destroy();
  }
};
export {
  AvatarHook as Avatar
};
