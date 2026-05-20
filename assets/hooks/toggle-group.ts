import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { ToggleGroup } from "../components/toggle-group";
import type { ValueChangeDetails, Props } from "@zag-js/toggle-group";
import type { Orientation } from "@zag-js/types";

import { getString, getBoolean, getStringList, getDir, canPushEvent } from "../lib/util";
import { idMatches, notifyChange, readPayloadId } from "../lib/respond-to";
import { createHookHandleEventRegistry } from "../lib/hook-handlers";
import { createDomEventRegistry } from "../lib/dom-events";

type ToggleGroupHookState = {
  toggleGroup?: ToggleGroup;
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
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

const ToggleGroupHook: Hook<object & ToggleGroupHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & ToggleGroupHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
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
    toggleGroup.init();
    this.toggleGroup = toggleGroup;

    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;

    domRegistry.add<CustomEvent<{ value: string[] }>>("corex:toggle-group:set-value", (event) => {
      const { value } = event.detail;
      toggleGroup.api.setValue(value);
    });

    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;

    registry.add("toggle-group_set_value", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      const value = readToggleGroupPayloadValue(payload);
      if (value) toggleGroup.api.setValue(value);
    });

    registry.add("toggle-group:value", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (!canPush()) return;
      this.pushEvent("toggle-group:value_response", {
        id: el.id,
        value: toggleGroup.api.value,
      });
    });
  },

  updated(this: object & HookInterface<HTMLElement> & ToggleGroupHookState) {
    this.toggleGroup?.updateProps({
      ...(getBoolean(this.el, "controlled")
        ? { value: getStringList(this.el, "value") }
        : { defaultValue: getStringList(this.el, "defaultValue") }),
      deselectable: getBoolean(this.el, "deselectable"),
      loopFocus: getBoolean(this.el, "loopFocus"),
      rovingFocus: getBoolean(this.el, "rovingFocus"),
      disabled: getBoolean(this.el, "disabled"),
      multiple: getBoolean(this.el, "multiple"),
      orientation: getString<Orientation>(this.el, "orientation"),
      dir: getDir(this.el),
    });
  },

  destroyed(this: object & HookInterface<HTMLElement> & ToggleGroupHookState) {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.toggleGroup?.destroy();
  },
};

export { ToggleGroupHook as ToggleGroup };
