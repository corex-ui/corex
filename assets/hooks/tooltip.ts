import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { Tooltip } from "../components/tooltip";
import type { OpenChangeDetails } from "@zag-js/tooltip";
import type { Placement } from "@zag-js/popper";

import { getString, getBoolean, getNumber, getDir, canPushEvent } from "../lib/util";
import { idMatches, readPayloadId } from "../lib/respond-to";

type TooltipHookState = {
  tooltip?: Tooltip;
  handlers?: Array<CallbackRef>;
  onSetOpen?: (event: Event) => void;
};

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

    const placement = getString<Placement>(el, "placement");
    const positioning = placement ? { placement } : undefined;

    const tooltip = new Tooltip(el, {
      id: el.id,
      ...(getBoolean(el, "controlled")
        ? { open: getBoolean(el, "open") }
        : { defaultOpen: getBoolean(el, "defaultOpen") }),
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
      onOpenChange: (details: OpenChangeDetails) => {
        const eventName = getString(el, "onOpenChange");
        if (eventName && canPushEvent(this.liveSocket)) {
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
      },
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
    const placement = getString<Placement>(this.el, "placement");
    const positioning = placement ? { placement } : undefined;

    this.tooltip?.updateProps({
      id: this.el.id,
      ...(getBoolean(this.el, "controlled")
        ? { open: getBoolean(this.el, "open") }
        : { defaultOpen: getBoolean(this.el, "defaultOpen") }),
      disabled: getBoolean(this.el, "disabled"),
      dir: getDir(this.el),
      openDelay: getNumber(this.el, "openDelay"),
      closeDelay: getCloseDelay(this.el),
      positioning,
      closeOnEscape: getBoolean(this.el, "closeOnEscape"),
      closeOnClick: getBoolean(this.el, "closeOnClick"),
      closeOnPointerDown: getBoolean(this.el, "closeOnPointerDown"),
      closeOnScroll: getBoolean(this.el, "closeOnScroll"),
      interactive: getBoolean(this.el, "interactive"),
    });
    queueMicrotask(() => {
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
