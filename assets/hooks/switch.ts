import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Switch } from "../components/switch";
import type { CheckedChangeDetails } from "@zag-js/switch";

import { getString, getBoolean, getDir, getCheckedState, canPushEvent } from "../lib/util";
import { idMatches, notifyChange, readPayloadId, readPayloadChecked } from "../lib/respond-to";
import { createHookHandleEventRegistry } from "../lib/hook-handlers";
import { createDomEventRegistry } from "../lib/dom-events";

type SwitchHookState = {
  zagSwitch?: Switch;
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
};

function checkedChangePayload(
  el: HTMLElement,
  details: CheckedChangeDetails
): Record<string, unknown> {
  return {
    id: el.id,
    checked: details.checked,
  };
}

const SwitchHook: Hook<object & SwitchHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & SwitchHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
    const zagSwitch = new Switch(el, {
      id: el.id,
      ...(getBoolean(el, "controlled")
        ? { checked: getCheckedState(el, "checked") === true }
        : { defaultChecked: getCheckedState(el, "defaultChecked") === true }),
      disabled: getBoolean(el, "disabled"),
      name: getString(el, "name"),
      form: getString(el, "form"),
      value: getString(el, "value"),
      dir: getDir(el),
      invalid: getBoolean(el, "invalid"),
      required: getBoolean(el, "required"),
      readOnly: getBoolean(el, "readOnly"),

      onCheckedChange: (details: CheckedChangeDetails) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: checkedChangePayload(el, details),
          serverEventName: getString(el, "onCheckedChange"),
          clientEventName: getString(el, "onCheckedChangeClient"),
        });
      },
    });

    zagSwitch.init();
    this.zagSwitch = zagSwitch;

    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;

    domRegistry.add<CustomEvent<{ checked: boolean }>>("corex:switch:set-checked", (event) => {
      const { checked } = event.detail;
      zagSwitch.api.setChecked(checked);
    });

    domRegistry.add("corex:switch:toggle-checked", () => {
      zagSwitch.api.toggleChecked();
    });

    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;

    registry.add("switch_set_checked", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      const checked = readPayloadChecked(payload);
      if (typeof checked === "boolean") zagSwitch.api.setChecked(checked);
    });

    registry.add("switch_toggle_checked", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zagSwitch.api.toggleChecked();
    });

    registry.add("switch_checked", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (!canPush()) return;
      this.pushEvent("switch_checked_response", {
        id: el.id,
        value: zagSwitch.api.checked,
      });
    });

    registry.add("switch_focused", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (!canPush()) return;
      this.pushEvent("switch_focused_response", {
        id: el.id,
        value: zagSwitch.api.focused,
      });
    });

    registry.add("switch_disabled", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (!canPush()) return;
      this.pushEvent("switch_disabled_response", {
        id: el.id,
        value: zagSwitch.api.disabled,
      });
    });
  },

  updated(this: object & HookInterface<HTMLElement> & SwitchHookState) {
    this.zagSwitch?.updateProps({
      id: this.el.id,
      ...(getBoolean(this.el, "controlled")
        ? { checked: getCheckedState(this.el, "checked") === true }
        : { defaultChecked: getCheckedState(this.el, "defaultChecked") === true }),
      disabled: getBoolean(this.el, "disabled"),
      name: getString(this.el, "name"),
      form: getString(this.el, "form"),
      value: getString(this.el, "value"),
      dir: getDir(this.el),
      invalid: getBoolean(this.el, "invalid"),
      required: getBoolean(this.el, "required"),
      readOnly: getBoolean(this.el, "readOnly"),
    });
  },

  destroyed(this: object & HookInterface<HTMLElement> & SwitchHookState) {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.zagSwitch?.destroy();
  },
};

export { SwitchHook as Switch };
