import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Collapsible } from "../components/collapsible";
import type { OpenChangeDetails } from "@zag-js/collapsible";

import { getBoolean, getDir, getString, canPushEvent } from "../lib/util";
import { readBooleanControlledZagProps } from "../lib/read-props";
import {
  emitResponse,
  idMatches,
  notifyChange,
  parseRespondTo,
  readPayloadId,
  type RespondTo,
} from "../lib/respond-to";
import { createHookHandleEventRegistry } from "../lib/hook-handlers";
import { createDomEventRegistry } from "../lib/dom-events";

type CollapsibleHookState = {
  collapsible?: Collapsible;
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
};

function openChangePayload(el: HTMLElement, details: OpenChangeDetails): Record<string, unknown> {
  return {
    id: el.id,
    open: details.open,
  };
}

const CollapsibleHook: Hook<object & CollapsibleHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & CollapsibleHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);

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

    collapsible.init();
    this.collapsible = collapsible;

    const emitOpen = (respondTo: RespondTo) => {
      emitResponse({
        respondTo,
        canPushServer: canPush(),
        pushEvent,
        serverEventName: "collapsible_open_response",
        serverPayload: {
          id: el.id,
          open: collapsible.api.open,
          disabled: collapsible.api.disabled,
        } as Record<string, unknown>,
        el,
        domEventName: "collapsible-open",
        domDetail: {
          id: el.id,
          open: collapsible.api.open,
          disabled: collapsible.api.disabled,
        } as Record<string, unknown>,
      });
    };

    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;

    domRegistry.add<CustomEvent<{ open: boolean }>>("corex:collapsible:set-open", (event) => {
      const { open } = event.detail;
      collapsible.api.setOpen(open);
    });

    domRegistry.add<CustomEvent>("corex:collapsible:open", (event) => {
      emitOpen(parseRespondTo(event.detail));
    });

    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;

    registry.add("collapsible_set_open", (payload: { id?: string; open: boolean }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      collapsible.api.setOpen(payload.open);
    });

    registry.add("collapsible_open", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitOpen(parseRespondTo(payload));
    });
  },

  updated(this: object & HookInterface<HTMLElement> & CollapsibleHookState) {
    this.collapsible?.updateProps({
      id: this.el.id,
      ...readBooleanControlledZagProps(this.el, "open", "defaultOpen"),
      disabled: getBoolean(this.el, "disabled"),
      dir: getDir(this.el),
    });
  },

  destroyed(this: object & HookInterface<HTMLElement> & CollapsibleHookState) {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.collapsible?.destroy();
  },
};

export { CollapsibleHook as Collapsible };
