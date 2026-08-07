import { Switch } from "../components/switch";
import type { CheckedChangeDetails } from "@zag-js/switch";

import { getString, getBoolean, getDir, canPushEvent } from "../lib/util";
import { mountCheckedBinding, readUpdatedServerChecked } from "../lib/read-props";
import { createZagLiveHook } from "../lib/zag-live-hook";
import { syncCheckedHiddenInput } from "../lib/phoenix-form-bridge";
import {
  checkedChangePayload,
  idMatches,
  notifyChange,
  readPayloadId,
  readPayloadChecked,
} from "../lib/respond-to";

type SwitchHookState = {
  switchComponent?: Switch;
};

export { checkedChangePayload };

const SwitchHook = createZagLiveHook<SwitchHookState, Switch>({
  key: "switchComponent",
  controlledKeys: ["checked"],
  mount(hook, { dom, server }) {
    const el = hook.el;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);
    const switchComponent = new Switch(el, {
      id: el.id,
      ...(() => {
        const binding = mountCheckedBinding(el);
        if ("checked" in binding) {
          return { checked: binding.checked === true };
        }
        return { defaultChecked: binding.defaultChecked === true };
      })(),
      disabled: getBoolean(el, "disabled"),
      name: getString(el, "name"),
      form: getString(el, "form"),
      value: getString(el, "value"),
      dir: getDir(el),
      invalid: getBoolean(el, "invalid"),
      required: getBoolean(el, "required"),
      readOnly: getBoolean(el, "readonly"),

      onCheckedChange: (details: CheckedChangeDetails) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: checkedChangePayload(el, details),
          serverEventName: getString(el, "onCheckedChange"),
          clientEventName: getString(el, "onCheckedChangeClient"),
        });

        const input = el.querySelector<HTMLInputElement>(
          '[data-scope="switch"][data-part="hidden-input"]'
        );
        if (input) {
          syncCheckedHiddenInput(input, details.checked === true, { markUsed: false });
        }
      },
    });

    dom.add<CustomEvent<{ checked: boolean }>>("corex:switch:set-checked", (event) => {
      const { checked } = event.detail;
      switchComponent.api.setChecked(checked);
    });

    dom.add("corex:switch:toggle-checked", () => {
      switchComponent.api.toggleChecked();
    });

    server.add("switch_set_checked", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      const checked = readPayloadChecked(payload);
      if (typeof checked === "boolean") switchComponent.api.setChecked(checked);
    });

    server.add("switch_toggle_checked", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      switchComponent.api.toggleChecked();
    });

    server.add("switch_checked", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (!canPush()) return;
      hook.pushEvent("switch_checked_response", {
        id: el.id,
        value: switchComponent.api.checked,
      });
    });

    server.add("switch_focused", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (!canPush()) return;
      hook.pushEvent("switch_focused_response", {
        id: el.id,
        value: switchComponent.api.focused,
      });
    });

    server.add("switch_disabled", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (!canPush()) return;
      hook.pushEvent("switch_disabled_response", {
        id: el.id,
        value: switchComponent.api.disabled,
      });
    });

    return switchComponent;
  },

  update(hook, switchComponent) {
    const checkedPatch = readUpdatedServerChecked(hook.el, hook.beforeAttrs);

    switchComponent.updateProps({
      id: hook.el.id,
      ...("checked" in checkedPatch ? { checked: checkedPatch.checked === true } : {}),
      disabled: getBoolean(hook.el, "disabled"),
      name: getString(hook.el, "name"),
      form: getString(hook.el, "form"),
      value: getString(hook.el, "value"),
      dir: getDir(hook.el),
      invalid: getBoolean(hook.el, "invalid"),
      required: getBoolean(hook.el, "required"),
      readOnly: getBoolean(hook.el, "readonly"),
    });
  },
});

export { SwitchHook as Switch };
