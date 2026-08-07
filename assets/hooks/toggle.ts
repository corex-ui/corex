import { Toggle } from "../components/toggle";
import type { Props } from "@zag-js/toggle";

import { getString, getBoolean, getBooleanValue, getDir, canPushEvent } from "../lib/util";
import { readPressedControlledZagUpdate } from "../lib/read-props";
import { idMatches, notifyChange, readPayloadId, readPayloadPressed } from "../lib/respond-to";
import { createZagLiveHook } from "../lib/zag-live-hook";

type ToggleHookState = {
  toggle?: Toggle;
};

export function pressedChangePayload(el: HTMLElement, pressed: boolean): Record<string, unknown> {
  return {
    id: el.id,
    pressed,
  };
}

const ToggleHook = createZagLiveHook<ToggleHookState, Toggle>({
  key: "toggle",
  controlledKeys: ["pressed"],
  mount(hook, { dom, server }) {
    const el = hook.el;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);
    const controlled = getBoolean(el, "controlled");
    const pressedFromDataset = getBooleanValue(el, "pressed");
    const defaultPressedFromDataset = getBooleanValue(el, "defaultPressed");
    const toggle = new Toggle(el, {
      id: el.id,
      ...(controlled
        ? { pressed: pressedFromDataset === true }
        : { defaultPressed: defaultPressedFromDataset === true }),
      disabled: getBoolean(el, "disabled"),
      dir: getDir(el),
      onPressedChange: (pressed: boolean) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: pressedChangePayload(el, pressed),
          serverEventName: getString(el, "onPressedChange"),
          clientEventName: getString(el, "onPressedChangeClient"),
        });
      },
    } as unknown as Props);

    dom.add<CustomEvent<{ pressed: boolean }>>("corex:toggle:set-pressed", (event) => {
      const p = event.detail?.pressed;
      if (typeof p === "boolean") toggle.api.setPressed(p);
    });

    dom.add("corex:toggle:toggle-pressed", () => {
      toggle.api.setPressed(!toggle.api.pressed);
    });

    server.add("toggle_set_pressed", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      const pressed = readPayloadPressed(payload);
      if (typeof pressed === "boolean") toggle.api.setPressed(pressed);
    });

    server.add("toggle_toggle_pressed", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      toggle.api.setPressed(!toggle.api.pressed);
    });

    server.add("toggle_pressed", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (!canPush()) return;
      hook.pushEvent("toggle_pressed_response", {
        id: el.id,
        value: toggle.api.pressed,
      });
    });

    return toggle;
  },

  update(hook, toggle) {
    const pressedPatch = readPressedControlledZagUpdate(hook.el, hook.beforeAttrs);

    toggle.updateProps({
      id: hook.el.id,
      ...pressedPatch,
      disabled: getBoolean(hook.el, "disabled"),
      dir: getDir(hook.el),
    } as unknown as Partial<Props>);
  },
});

export { ToggleHook as Toggle };
