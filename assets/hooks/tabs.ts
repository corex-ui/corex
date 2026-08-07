import { Tabs } from "../components/tabs";
import type { ValueChangeDetails, FocusChangeDetails, Props } from "@zag-js/tabs";
import type { Orientation } from "@zag-js/types";

import { getString, getDir, canPushEvent } from "../lib/util";
import { readStringControlledZagProps, readStringControlledZagUpdate } from "../lib/read-props";
import { idMatches, readPayloadId, notifyChange } from "../lib/respond-to";
import { createZagLiveHook } from "../lib/zag-live-hook";

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
};

const TabsHook = createZagLiveHook<TabsHookState, Tabs>({
  key: "tabs",
  controlledKeys: ["value"],
  mount(hook, { dom, server }) {
    const el = hook.el;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);

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

    dom.add<CustomEvent<{ value: string }>>("corex:tabs:set-value", (event) => {
      tabs.api.setValue(event.detail.value);
    });

    server.add("tabs_set_value", (payload: { tabs_id?: string; value: string }) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      tabs.api.setValue(payload.value);
    });

    server.add("tabs_value", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (!canPush()) return;
      hook.pushEvent("tabs_value_response", {
        id: el.id,
        value: tabs.api.value,
      });
    });

    server.add("tabs_focused_value", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (!canPush()) return;
      hook.pushEvent("tabs_focused_value_response", {
        id: el.id,
        value: tabs.api.focusedValue,
      });
    });

    return tabs;
  },

  update(hook, tabs) {
    tabs.updateProps({
      id: hook.el.id,
      ...readStringControlledZagUpdate(hook.el, "value", "defaultValue", hook.beforeAttrs),
      ...readTabsLayoutProps(hook.el),
    } as Props);
  },
});

export { TabsHook as Tabs };
