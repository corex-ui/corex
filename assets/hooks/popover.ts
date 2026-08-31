import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Popover } from "../components/popover";
import type {
  OpenChangeDetails,
  Props as PopoverProps,
  TriggerValueChangeDetails,
} from "@zag-js/popover";

import { getString, getBoolean, getDir, canPushEvent } from "../lib/util";
import { readPositioningOptions } from "../lib/positioning";
import { idMatches, readPayloadId } from "../lib/respond-to";
import { createZagLiveHook } from "../lib/zag-live-hook";

type PopoverHookState = {
  popover?: Popover;
};

function createPopoverCallbacks(
  el: HTMLElement,
  pushEvent: HookInterface<HTMLElement>["pushEvent"],
  liveSocket: HookInterface<HTMLElement>["liveSocket"]
): Pick<PopoverProps, "onOpenChange" | "onTriggerValueChange"> {
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

function popoverProps(el: HTMLElement, hook: HookInterface<HTMLElement>): PopoverProps {
  return {
    id: el.id,
    defaultOpen: getBoolean(el, "defaultOpen"),
    dir: getDir(el),
    modal: getBoolean(el, "modal"),
    portalled: getBoolean(el, "portalled"),
    autoFocus: getBoolean(el, "autoFocus"),
    restoreFocus: getBoolean(el, "restoreFocus"),
    closeOnInteractOutside: getBoolean(el, "closeOnInteractOutside"),
    closeOnEscape: getBoolean(el, "closeOnEscape"),
    positioning: readPositioningOptions(el),
    ...createPopoverCallbacks(el, hook.pushEvent.bind(hook), hook.liveSocket),
  };
}

const PopoverHook = createZagLiveHook<PopoverHookState, Popover>({
  key: "popover",
  mount(hook, { dom, server }) {
    const el = hook.el;
    const popover = new Popover(el, popoverProps(el, hook));

    dom.add<CustomEvent<{ open: boolean }>>("corex:popover:set-open", (event) => {
      popover.api.setOpen(event.detail.open);
    });

    server.add("popover_set_open", (payload: { popover_id?: string; open: boolean }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      popover.api.setOpen(payload.open);
    });

    return popover;
  },
  update(hook, popover) {
    popover.updateProps(popoverProps(hook.el, hook));
  },
});

export { PopoverHook as Popover };
