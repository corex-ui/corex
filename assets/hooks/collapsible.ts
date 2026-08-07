import { Collapsible } from "../components/collapsible";
import type { OpenChangeDetails } from "@zag-js/collapsible";

import { getBoolean, getDir, getString, canPushEvent } from "../lib/util";
import { readBooleanControlledZagProps, readBooleanControlledZagUpdate } from "../lib/read-props";
import {
  idMatches,
  notifyChange,
  parseRespondTo,
  readPayloadId,
  createValueEmitter,
} from "../lib/respond-to";
import { createZagLiveHook } from "../lib/zag-live-hook";

type CollapsibleHookState = {
  collapsible?: Collapsible;
};

export function openChangePayload(
  el: HTMLElement,
  details: OpenChangeDetails
): Record<string, unknown> {
  return {
    id: el.id,
    open: details.open,
  };
}

const CollapsibleHook = createZagLiveHook<CollapsibleHookState, Collapsible>({
  key: "collapsible",
  controlledKeys: ["open"],
  mount(hook, { dom, server }) {
    const el = hook.el;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);

    const collapsible = new Collapsible(el, {
      id: el.id,
      ...readBooleanControlledZagProps(el, "open", "defaultOpen"),
      disabled: getBoolean(el, "disabled"),
      dir: getDir(el),
      onOpenChange: (details: OpenChangeDetails) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: openChangePayload(el, details),
          serverEventName: getString(el, "onOpenChange"),
          clientEventName: getString(el, "onOpenChangeClient"),
        });
      },
    });

    const emitOpen = createValueEmitter(
      { el, pushEvent, canPushServer: canPush },
      {
        getPayload: () => ({
          id: el.id,
          open: collapsible.api.open,
          disabled: collapsible.api.disabled,
        }),
        serverEventName: "collapsible_open_response",
        domEventName: "collapsible-open",
      }
    );

    dom.add<CustomEvent<{ open: boolean }>>("corex:collapsible:set-open", (event) => {
      collapsible.api.setOpen(event.detail.open);
    });

    dom.add<CustomEvent>("corex:collapsible:open", (event) => {
      emitOpen(parseRespondTo(event.detail));
    });

    server.add("collapsible_set_open", (payload: { id?: string; open: boolean }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      collapsible.api.setOpen(payload.open);
    });

    server.add("collapsible_open", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitOpen(parseRespondTo(payload));
    });

    return collapsible;
  },

  update(hook, collapsible) {
    const openPatch = readBooleanControlledZagUpdate(
      hook.el,
      "open",
      "defaultOpen",
      hook.beforeAttrs
    );

    collapsible.updateProps({
      id: hook.el.id,
      ...openPatch,
      disabled: getBoolean(hook.el, "disabled"),
      dir: getDir(hook.el),
    });
  },
});

export { CollapsibleHook as Collapsible };
