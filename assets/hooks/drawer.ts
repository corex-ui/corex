import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Drawer } from "../components/drawer";
import type {
  OpenChangeDetails,
  Props as DrawerProps,
  SnapPoint,
  SnapPointChangeDetails,
  SwipeDirection,
  TriggerValueChangeDetails,
} from "@zag-js/drawer";

import { getString, getBoolean, getDir, canPushEvent } from "../lib/util";
import { idMatches, readPayloadId } from "../lib/respond-to";
import { createZagLiveHook } from "../lib/zag-live-hook";

type DrawerHookState = {
  drawer?: Drawer;
};

export function parseSnapPoints(raw: string | undefined): SnapPoint[] | undefined {
  if (!raw || raw.trim() === "") return undefined;
  return raw.split(",").map((part) => {
    const trimmed = part.trim();
    if (trimmed.endsWith("px") || trimmed.endsWith("%")) return trimmed;
    const n = Number(trimmed);
    return Number.isNaN(n) ? trimmed : n;
  });
}

export function parseSnapPoint(raw: string | undefined): SnapPoint | undefined {
  if (!raw || raw.trim() === "") return undefined;
  const trimmed = raw.trim();
  if (trimmed.endsWith("px") || trimmed.endsWith("%")) return trimmed;
  const n = Number(trimmed);
  return Number.isNaN(n) ? trimmed : n;
}

function createDrawerCallbacks(
  el: HTMLElement,
  pushEvent: HookInterface<HTMLElement>["pushEvent"],
  liveSocket: HookInterface<HTMLElement>["liveSocket"]
): Pick<DrawerProps, "onOpenChange" | "onTriggerValueChange" | "onSnapPointChange"> {
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

  const onSnapPointChange = (details: SnapPointChangeDetails) => {
    const eventName = getString(el, "onSnapPointChange");
    if (eventName && canPushEvent(liveSocket)) {
      pushEvent(eventName, {
        id: el.id,
        snap_point: details.snapPoint,
      });
    }

    const eventNameClient = getString(el, "onSnapPointChangeClient");
    if (eventNameClient) {
      el.dispatchEvent(
        new CustomEvent(eventNameClient, {
          bubbles: true,
          detail: {
            id: el.id,
            snap_point: details.snapPoint,
          },
        })
      );
    }
  };

  return { onOpenChange, onTriggerValueChange, onSnapPointChange };
}

function drawerProps(el: HTMLElement, hook: HookInterface<HTMLElement>): DrawerProps {
  const swipeDirection = getString(el, "swipeDirection", ["up", "down", "start", "end"] as const);
  return {
    id: el.id,
    defaultOpen: getBoolean(el, "defaultOpen"),
    dir: getDir(el),
    modal: getBoolean(el, "modal"),
    trapFocus: getBoolean(el, "trapFocus"),
    preventScroll: getBoolean(el, "preventScroll"),
    closeOnInteractOutside: getBoolean(el, "closeOnInteractOutside"),
    closeOnEscape: getBoolean(el, "closeOnEscape"),
    preventDragOnScroll: getBoolean(el, "preventDragOnScroll"),
    swipeDirection: swipeDirection as SwipeDirection | undefined,
    snapPoints: parseSnapPoints(getString(el, "snapPoints")),
    defaultSnapPoint: parseSnapPoint(getString(el, "defaultSnapPoint")),
    ...createDrawerCallbacks(el, hook.pushEvent.bind(hook), hook.liveSocket),
  };
}

const DrawerHook = createZagLiveHook<DrawerHookState, Drawer>({
  key: "drawer",
  mount(hook, { dom, server }) {
    const el = hook.el;
    const drawer = new Drawer(el, drawerProps(el, hook));

    dom.add<CustomEvent<{ open: boolean }>>("corex:drawer:set-open", (event) => {
      drawer.api.setOpen(event.detail.open);
    });

    server.add("drawer_set_open", (payload: { drawer_id?: string; open: boolean }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      drawer.api.setOpen(payload.open);
    });

    return drawer;
  },
  update(hook, drawer) {
    drawer.updateProps(drawerProps(hook.el, hook));
  },
});

export { DrawerHook as Drawer };
