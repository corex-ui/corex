import { ToggleGroup } from "../components/toggle-group";
import type { ValueChangeDetails, Props } from "@zag-js/toggle-group";
import type { Orientation } from "@zag-js/types";

import { getString, getBoolean, getStringList, getDir, canPushEvent } from "../lib/util";
import { readStringListControlledZagUpdate } from "../lib/read-props";
import { idMatches, notifyChange, readPayloadId } from "../lib/respond-to";
import { createZagLiveHook } from "../lib/zag-live-hook";

type ToggleGroupHookState = {
  toggleGroup?: ToggleGroup;
};

export function valueChangePayload(
  el: HTMLElement,
  details: ValueChangeDetails
): Record<string, unknown> {
  return {
    id: el.id,
    value: details.value,
  };
}

export function readToggleGroupPayloadValue(payload: unknown): string[] | undefined {
  if (!payload || typeof payload !== "object") return undefined;
  const o = payload as Record<string, unknown>;
  const v = o.value ?? o["value"];
  if (Array.isArray(v) && v.every((x) => typeof x === "string")) return v as string[];
  return undefined;
}

const ToggleGroupHook = createZagLiveHook<ToggleGroupHookState, ToggleGroup>({
  key: "toggleGroup",
  controlledKeys: ["value"],
  mount(hook, { dom, server }) {
    const el = hook.el;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);
    const props: Props = {
      id: el.id,
      ...(getBoolean(el, "controlled")
        ? { value: getStringList(el, "value") }
        : { defaultValue: getStringList(el, "defaultValue") }),
      deselectable: getBoolean(el, "deselectable"),
      loopFocus: getBoolean(el, "loopFocus"),
      rovingFocus: getBoolean(el, "rovingFocus"),
      disabled: getBoolean(el, "disabled"),
      multiple: getBoolean(el, "multiple"),
      orientation: getString<Orientation>(el, "orientation"),
      dir: getDir(el),
      onValueChange: (details: ValueChangeDetails) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: valueChangePayload(el, details),
          serverEventName: getString(el, "onValueChange"),
          clientEventName: getString(el, "onValueChangeClient"),
        });
      },
    };

    const toggleGroup = new ToggleGroup(el, props);

    dom.add<CustomEvent<{ value: string[] }>>("corex:toggle-group:set-value", (event) => {
      const { value } = event.detail;
      toggleGroup.api.setValue(value);
    });

    server.add("toggle_group_set_value", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      const value = readToggleGroupPayloadValue(payload);
      if (value) toggleGroup.api.setValue(value);
    });

    server.add("toggle-group:value", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (!canPush()) return;
      hook.pushEvent("toggle-group:value_response", {
        id: el.id,
        value: toggleGroup.api.value,
      });
    });

    return toggleGroup;
  },

  update(hook, toggleGroup) {
    toggleGroup.updateProps({
      ...readStringListControlledZagUpdate(hook.el, "value", "defaultValue", hook.beforeAttrs),
      deselectable: getBoolean(hook.el, "deselectable"),
      loopFocus: getBoolean(hook.el, "loopFocus"),
      rovingFocus: getBoolean(hook.el, "rovingFocus"),
      disabled: getBoolean(hook.el, "disabled"),
      multiple: getBoolean(hook.el, "multiple"),
      orientation: getString<Orientation>(hook.el, "orientation"),
      dir: getDir(hook.el),
    });
  },
});

export { ToggleGroupHook as ToggleGroup };
