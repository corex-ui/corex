import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { Tooltip } from "../components/tooltip";
import type {
  OpenChangeDetails,
  Props as TooltipProps,
  TriggerValueChangeDetails,
} from "@zag-js/tooltip";

import { getString, getBoolean, getNumber, getDir, canPushEvent } from "../lib/util";
import { readPositioningOptions } from "../lib/positioning";
import { idMatches, readPayloadId } from "../lib/respond-to";

type TooltipHookState = {
  tooltip?: Tooltip;
  handlers?: Array<CallbackRef>;
  onSetOpen?: (event: Event) => void;
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

function getCloseDelay(el: HTMLElement): number | undefined {
  const interactive = getBoolean(el, "interactive");
  const raw = getNumber(el, "closeDelay");
  if (interactive && (raw === undefined || raw === 0)) return 400;
  return raw;
}

const TooltipHook: Hook<object & TooltipHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & TooltipHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const liveSocket = this.liveSocket;

    const positioning = readPositioningOptions(el);
    const callbacks = createTooltipCallbacks(el, pushEvent, liveSocket);

    const tooltip = new Tooltip(el, {
      id: el.id,
      defaultOpen: getBoolean(el, "defaultOpen"),
      disabled: getBoolean(el, "disabled"),
      dir: getDir(el),
      openDelay: getNumber(el, "openDelay"),
      closeDelay: getCloseDelay(el),
      positioning,
      closeOnEscape: getBoolean(el, "closeOnEscape"),
      closeOnClick: getBoolean(el, "closeOnClick"),
      closeOnPointerDown: getBoolean(el, "closeOnPointerDown"),
      closeOnScroll: getBoolean(el, "closeOnScroll"),
      interactive: getBoolean(el, "interactive"),
      ...callbacks,
    });

    tooltip.init();
    this.tooltip = tooltip;

    this.onSetOpen = (event: Event) => {
      const { open } = (event as CustomEvent<{ open: boolean }>).detail;
      tooltip.api.setOpen(open);
    };
    el.addEventListener("corex:tooltip:set-open", this.onSetOpen);

    this.handlers = [];

    this.handlers.push(
      this.handleEvent("tooltip_set_open", (payload: { tooltip_id?: string; open: boolean }) => {
        if (!idMatches(el.id, readPayloadId(payload))) return;
        tooltip.api.setOpen(payload.open);
      })
    );
  },

  updated(this: object & HookInterface<HTMLElement> & TooltipHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const liveSocket = this.liveSocket;
    const positioning = readPositioningOptions(el);
    const callbacks = createTooltipCallbacks(el, pushEvent, liveSocket);

    this.tooltip?.updateProps({
      id: el.id,
      defaultOpen: getBoolean(el, "defaultOpen"),
      disabled: getBoolean(el, "disabled"),
      dir: getDir(el),
      openDelay: getNumber(el, "openDelay"),
      closeDelay: getCloseDelay(el),
      positioning,
      closeOnEscape: getBoolean(el, "closeOnEscape"),
      closeOnClick: getBoolean(el, "closeOnClick"),
      closeOnPointerDown: getBoolean(el, "closeOnPointerDown"),
      closeOnScroll: getBoolean(el, "closeOnScroll"),
      interactive: getBoolean(el, "interactive"),
      ...callbacks,
    });
    queueMicrotask(() => {
      this.tooltip?.syncDom();
      this.tooltip?.api.reposition?.();
    });
  },

  destroyed(this: object & HookInterface<HTMLElement> & TooltipHookState) {
    if (this.onSetOpen) {
      this.el.removeEventListener("corex:tooltip:set-open", this.onSetOpen);
    }

    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }

    this.tooltip?.destroy();
  },
};

export { TooltipHook as Tooltip };
