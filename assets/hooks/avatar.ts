import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Avatar } from "../components/avatar";
import type { Props, StatusChangeDetails } from "@zag-js/avatar";
import { getString, canPushEvent } from "../lib/util";
import type { Direction } from "@zag-js/types";
import {
  parseRespondTo,
  emitResponse,
  idMatches,
  readPayloadId,
  notifyChange,
  type RespondTo,
} from "../lib/respond-to";
import { createHookHandleEventRegistry } from "../lib/hook-handlers";
import { createDomEventRegistry } from "../lib/dom-events";

type AvatarHookState = {
  avatar?: Avatar;
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
  lastSrc?: string;
};

function statusPayload(el: HTMLElement, details: StatusChangeDetails): Record<string, unknown> {
  return { id: el.id, status: details.status };
}

const AvatarHook: Hook<object & HookInterface<HTMLElement> & AvatarHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & AvatarHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
    const initialSrc = getString(el, "src");

    const zag = new Avatar(el, {
      id: el.id,
      dir: getString<Direction>(el, "dir"),
      onStatusChange: (details: StatusChangeDetails) => {
        const flat = statusPayload(el, details);
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: flat,
          serverEventName: getString(el, "onStatusChange"),
          clientEventName: getString(el, "onStatusChangeClient"),
        });
      },
    } as Props);
    zag.init();
    this.avatar = zag;
    this.lastSrc = initialSrc;

    const emitLoaded = (respondTo: RespondTo) => {
      const loaded = zag.api.loaded;
      emitResponse({
        respondTo,
        canPushServer: canPush(),
        pushEvent,
        serverEventName: "avatar_loaded_response",
        serverPayload: { id: el.id, loaded } as Record<string, unknown>,
        el,
        domEventName: "avatar-loaded",
        domDetail: { id: el.id, loaded } as Record<string, unknown>,
      });
    };

    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;

    domRegistry.add<CustomEvent<{ src: string }>>("corex:avatar:set-src", (event) => {
      const next = event.detail?.src;
      if (typeof next !== "string") return;
      zag.api.setSrc(next);
      this.lastSrc = next;
      el.dataset.src = next;
    });

    domRegistry.add<CustomEvent>("corex:avatar:loaded", (event) => {
      emitLoaded(parseRespondTo(event.detail));
    });

    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;

    registry.add("avatar_set_src", (payload: { id?: string; src: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.setSrc(payload.src);
      this.lastSrc = payload.src;
      el.dataset.src = payload.src;
    });

    registry.add("avatar_loaded", (payload: { id?: string; respond_to?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitLoaded(parseRespondTo(payload));
    });
  },

  updated(this: object & HookInterface<HTMLElement> & AvatarHookState) {
    const src = getString(this.el, "src");
    const dir = getString<Direction>(this.el, "dir");
    if (this.avatar) {
      this.avatar.updateProps({
        ...(dir !== undefined ? { dir } : {}),
      } as Partial<Props>);
    }
    if (this.avatar && src !== undefined && src !== this.lastSrc) {
      this.avatar.api.setSrc(src);
      this.lastSrc = src;
    }
    if (this.avatar && src === undefined && this.lastSrc !== undefined) {
      this.avatar.api.setSrc("");
      this.lastSrc = undefined;
    }
  },

  destroyed(this: object & HookInterface<HTMLElement> & AvatarHookState) {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.avatar?.destroy();
  },
};

export { AvatarHook as Avatar };
