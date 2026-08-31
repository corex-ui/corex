import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { HoverCard } from "../components/hover-card";
import type {
  OpenChangeDetails,
  Props as HoverCardProps,
  TriggerValueChangeDetails,
} from "@zag-js/hover-card";

import { getString, getBoolean, getNumber, getDir, canPushEvent } from "../lib/util";
import { readPositioningOptions } from "../lib/positioning";
import { idMatches, readPayloadId } from "../lib/respond-to";
import { createZagLiveHook } from "../lib/zag-live-hook";

type HoverCardHookState = {
  hoverCard?: HoverCard;
};

function createHoverCardCallbacks(
  el: HTMLElement,
  pushEvent: HookInterface<HTMLElement>["pushEvent"],
  liveSocket: HookInterface<HTMLElement>["liveSocket"]
): Pick<HoverCardProps, "onOpenChange" | "onTriggerValueChange"> {
  const onTriggerValueChange = (details: TriggerValueChangeDetails) => {
    const eventName = getString(el, "onTriggerValueChange");
    if (eventName && canPushEvent(liveSocket)) {
      pushEvent(eventName, {
        id: el.id,
        value: details.value ?? "",
      });
    }
  };

  const onOpenChange = (details: OpenChangeDetails) => {
    const eventName = getString(el, "onOpenChange");
    if (eventName && canPushEvent(liveSocket)) {
      pushEvent(eventName, {
        id: el.id,
        open: details.open,
      });
    }

    const eventNameClient = getString(el, "onOpenChangeClient");
    if (eventNameClient) {
      el.dispatchEvent(
        new CustomEvent(eventNameClient, {
          bubbles: true,
          detail: {
            id: el.id,
            open: details.open,
          },
        })
      );
    }
  };

  return { onOpenChange, onTriggerValueChange };
}

function hoverCardProps(el: HTMLElement, hook: HookInterface<HTMLElement>): HoverCardProps {
  return {
    id: el.id,
    defaultOpen: getBoolean(el, "defaultOpen"),
    disabled: getBoolean(el, "disabled"),
    dir: getDir(el),
    openDelay: getNumber(el, "openDelay"),
    closeDelay: getNumber(el, "closeDelay"),
    positioning: readPositioningOptions(el),
    ...createHoverCardCallbacks(el, hook.pushEvent.bind(hook), hook.liveSocket),
  };
}

const HoverCardHook = createZagLiveHook<HoverCardHookState, HoverCard>({
  key: "hover-card",
  mount(hook, { dom, server }) {
    const el = hook.el;
    const hoverCard = new HoverCard(el, hoverCardProps(el, hook));

    dom.add<CustomEvent<{ open: boolean }>>("corex:hover-card:set-open", (event) => {
      hoverCard.api.setOpen(event.detail.open);
    });

    server.add("hover_card_set_open", (payload: { hover_card_id?: string; open: boolean }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      hoverCard.api.setOpen(payload.open);
    });

    return hoverCard;
  },
  update(hook, hoverCard) {
    hoverCard.updateProps(hoverCardProps(hook.el, hook));
  },
});

export { HoverCardHook as HoverCard };
