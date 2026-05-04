import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Tabs } from "../components/tabs";
import type { ValueChangeDetails, FocusChangeDetails, Props } from "@zag-js/tabs";
import type { Direction, Orientation } from "@zag-js/types";

import { getString, getBoolean, canPushEvent } from "../lib/util";
import { idMatches, readPayloadId, notifyChange } from "../lib/respond-to";
import { createHookHandleEventRegistry } from "../lib/hook-handlers";
import { createDomEventRegistry } from "../lib/dom-events";

type TabsHookState = {
  tabs?: Tabs;
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
};

const TabsHook: Hook<object & TabsHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & TabsHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);

    const tabs = new Tabs(el, {
      id: el.id,
      ...(getBoolean(el, "controlled")
        ? { value: getString(el, "value") }
        : { defaultValue: getString(el, "defaultValue") }),
      orientation: getString<Orientation>(el, "orientation"),
      dir: getString<Direction>(el, "dir"),
      onValueChange: (details: ValueChangeDetails) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: { id: el.id, value: details.value ?? null } as Record<string, unknown>,
          serverEventName: getString(el, "onValueChange"),
          clientEventName: getString(el, "onValueChangeClient"),
        });
      },

      onFocusChange: (details: FocusChangeDetails) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: { id: el.id, value: details.focusedValue ?? null } as Record<string, unknown>,
          serverEventName: getString(el, "onFocusChange"),
          clientEventName: getString(el, "onFocusChangeClient"),
        });
      },
    });
    tabs.init();
    this.tabs = tabs;

    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;

    domRegistry.add<CustomEvent<{ value: string }>>("corex:tabs:set-value", (event) => {
      tabs.api.setValue(event.detail.value);
    });

    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;

    registry.add("tabs_set_value", (payload: { tabs_id?: string; value: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      tabs.api.setValue(payload.value);
    });

    registry.add("tabs_value", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (!canPush()) return;
      this.pushEvent("tabs_value_response", {
        id: el.id,
        value: tabs.api.value,
      });
    });

    registry.add("tabs_focused_value", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (!canPush()) return;
      this.pushEvent("tabs_focused_value_response", {
        id: el.id,
        value: tabs.api.focusedValue,
      });
    });
  },

  updated(this: object & HookInterface<HTMLElement> & TabsHookState) {
    this.tabs?.updateProps({
      id: this.el.id,
      ...(getBoolean(this.el, "controlled")
        ? { value: getString(this.el, "value") }
        : { defaultValue: getString(this.el, "defaultValue") }),
      orientation: getString<Orientation>(this.el, "orientation"),
      dir: getString<Direction>(this.el, "dir"),
    } as Props);
  },

  destroyed(this: object & HookInterface<HTMLElement> & TabsHookState) {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.tabs?.destroy();
  },
};

export { TabsHook as Tabs };
