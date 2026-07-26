import { Avatar } from "../components/avatar";
import type { Props, StatusChangeDetails } from "@zag-js/avatar";
import { getString, canPushEvent } from "../lib/util";
import type { Direction } from "@zag-js/types";
import { createZagLiveHook } from "../lib/zag-live-hook";
import {
  parseRespondTo,
  idMatches,
  readPayloadId,
  notifyChange,
  createValueEmitter,
} from "../lib/respond-to";

type AvatarHookState = {
  avatar?: Avatar;
  lastSrc?: string;
};

export function statusPayload(
  el: HTMLElement,
  details: StatusChangeDetails
): Record<string, unknown> {
  return { id: el.id, status: details.status };
}

const AvatarHook = createZagLiveHook<AvatarHookState, Avatar>({
  key: "avatar",
  mount(hook, { dom, server }) {
    const el = hook.el;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);
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
    hook.lastSrc = initialSrc;

    const emitLoaded = createValueEmitter(
      { el, pushEvent, canPushServer: canPush },
      {
        getPayload: () => ({ id: el.id, loaded: zag.api.loaded }),
        serverEventName: "avatar_loaded_response",
        domEventName: "avatar-loaded",
      }
    );

    dom.add<CustomEvent<{ src: string }>>("corex:avatar:set-src", (event) => {
      const next = event.detail?.src;
      if (typeof next !== "string") return;
      zag.api.setSrc(next);
      hook.lastSrc = next;
      el.dataset.src = next;
    });

    dom.add<CustomEvent>("corex:avatar:loaded", (event) => {
      emitLoaded(parseRespondTo(event.detail));
    });

    server.add("avatar_set_src", (payload: { id?: string; src: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.setSrc(payload.src);
      hook.lastSrc = payload.src;
      el.dataset.src = payload.src;
    });

    server.add("avatar_loaded", (payload: { id?: string; respond_to?: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitLoaded(parseRespondTo(payload));
    });

    return zag;
  },

  update(hook, zag) {
    const src = getString(hook.el, "src");
    const dir = getString<Direction>(hook.el, "dir");
    zag.updateProps({
      ...(dir !== undefined ? { dir } : {}),
    } as Partial<Props>);

    if (src !== undefined && src !== hook.lastSrc) {
      zag.api.setSrc(src);
      hook.lastSrc = src;
    }
    if (src === undefined && hook.lastSrc !== undefined) {
      zag.api.setSrc("");
      hook.lastSrc = undefined;
    }
  },
});

export { AvatarHook as Avatar };
