import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Tooltip } from "../components/tooltip";
import type {
  OpenChangeDetails,
  Props as TooltipProps,
  TriggerValueChangeDetails,
} from "@zag-js/tooltip";

import { getString, getBoolean, getNumber, getDir, canPushEvent } from "../lib/util";
import { readPositioningOptions } from "../lib/positioning";
import { idMatches, readPayloadId } from "../lib/respond-to";
import { createZagLiveHook } from "../lib/zag-live-hook";

type TooltipHookState = {
  tooltip?: Tooltip;
};

function createTooltipCallbacks(
  el: HTMLElement,
  pushEvent: HookInterface<HTMLElement>["pushEvent"],
  liveSocket: HookInterface<HTMLElement>["liveSocket"]
): Pick<TooltipProps, "onOpenChange" | "onTriggerValueChange"> {
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

export function getCloseDelay(el: HTMLElement): number | undefined {
  const interactive = getBoolean(el, "interactive");
  const raw = getNumber(el, "closeDelay");
  if (interactive && (raw === undefined || raw === 0)) return 400;
  return raw;
}

function tooltipProps(el: HTMLElement, hook: HookInterface<HTMLElement>): TooltipProps {
  return {
    id: el.id,
    defaultOpen: getBoolean(el, "defaultOpen"),
    disabled: getBoolean(el, "disabled"),
    dir: getDir(el),
    openDelay: getNumber(el, "openDelay"),
    closeDelay: getCloseDelay(el),
    positioning: readPositioningOptions(el),
    closeOnEscape: getBoolean(el, "closeOnEscape"),
    closeOnClick: getBoolean(el, "closeOnClick"),
    closeOnPointerDown: getBoolean(el, "closeOnPointerDown"),
    closeOnScroll: getBoolean(el, "closeOnScroll"),
    interactive: getBoolean(el, "interactive"),
    ...createTooltipCallbacks(el, hook.pushEvent.bind(hook), hook.liveSocket),
  };
}

const TooltipHook = createZagLiveHook<TooltipHookState, Tooltip>({
  key: "tooltip",
  mount(hook, { dom, server }) {
    const el = hook.el;
    const tooltip = new Tooltip(el, tooltipProps(el, hook));

    dom.add<CustomEvent<{ open: boolean }>>("corex:tooltip:set-open", (event) => {
      tooltip.api.setOpen(event.detail.open);
    });

    server.add("tooltip_set_open", (payload: { tooltip_id?: string; open: boolean }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      tooltip.api.setOpen(payload.open);
    });

    return tooltip;
  },
  update(hook, tooltip) {
    tooltip.updateProps(tooltipProps(hook.el, hook));
  },
});

export { TooltipHook as Tooltip };
