import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Tabs } from "../components/tabs";
import type { ValueChangeDetails, FocusChangeDetails, Props } from "@zag-js/tabs";
import type { Orientation } from "@zag-js/types";

import { getString, getDir, canPushEvent } from "../lib/util";
import { snapshotDataset, type DatasetSnapshot } from "../lib/controlled-attr-snapshot";
import { readStringControlledZagProps, readStringControlledZagUpdate } from "../lib/read-props";
import { idMatches, readPayloadId, notifyChange } from "../lib/respond-to";
import { createHookHandleEventRegistry } from "../lib/hook-handlers";
import { createDomEventRegistry } from "../lib/dom-events";

export function tabsValueChangePayload(
  el: HTMLElement,
  details: ValueChangeDetails
): Record<string, unknown> {
  return { id: el.id, value: details.value ?? null };
}

export function tabsFocusChangePayload(
  el: HTMLElement,
  details: FocusChangeDetails
): Record<string, unknown> {
  return { id: el.id, value: details.focusedValue ?? null };
}

export function readTabsLayoutProps(el: HTMLElement) {
  return {
    orientation: getString<Orientation>(el, "orientation"),
    dir: getDir(el),
  };
}

type TabsHookState = {
  tabs?: Tabs;
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
  beforeAttrs?: DatasetSnapshot;
};

const TabsHook: Hook<object & TabsHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & TabsHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);

    const tabs = new Tabs(el, {
      id: el.id,
      ...readStringControlledZagProps(el, "value", "defaultValue"),
      ...readTabsLayoutProps(el),
      onValueChange: (details: ValueChangeDetails) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: tabsValueChangePayload(el, details),
          serverEventName: getString(el, "onValueChange"),
          clientEventName: getString(el, "onValueChangeClient"),
        });
      },

      onFocusChange: (details: FocusChangeDetails) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: tabsFocusChangePayload(el, details),
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

  beforeUpdate(this: object & HookInterface<HTMLElement> & TabsHookState) {
    this.beforeAttrs = snapshotDataset(this.el, ["value"]);
  },

  updated(this: object & HookInterface<HTMLElement> & TabsHookState) {
    try {
      this.tabs?.updateProps({
        id: this.el.id,
        ...readStringControlledZagUpdate(this.el, "value", "defaultValue", this.beforeAttrs),
        ...readTabsLayoutProps(this.el),
      } as Props);
    } finally {
      this.beforeAttrs = undefined;
    }
  },

  destroyed(this: object & HookInterface<HTMLElement> & TabsHookState) {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.tabs?.destroy();
  },
};

export { TabsHook as Tabs };
