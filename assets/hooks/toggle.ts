import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Toggle } from "../components/toggle";
import type { Props } from "@zag-js/toggle";

import { getString, getBoolean, getBooleanValue, getDir, canPushEvent } from "../lib/util";
import { idMatches, notifyChange, readPayloadId, readPayloadPressed } from "../lib/respond-to";
import { createHookHandleEventRegistry } from "../lib/hook-handlers";
import { createDomEventRegistry } from "../lib/dom-events";

type ToggleHookState = {
  zagToggle?: Toggle;
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
};

export function pressedChangePayload(el: HTMLElement, pressed: boolean): Record<string, unknown> {
  return {
    id: el.id,
    pressed,
  };
}

const ToggleHook: Hook<object & ToggleHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & ToggleHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
    const controlled = getBoolean(el, "controlled");
    const pressedFromDataset = getBooleanValue(el, "pressed");
    const defaultPressedFromDataset = getBooleanValue(el, "defaultPressed");
    const zagToggle = new Toggle(el, {
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

    zagToggle.init();
    this.zagToggle = zagToggle;

    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;

    domRegistry.add<CustomEvent<{ pressed: boolean }>>("corex:toggle:set-pressed", (event) => {
      const p = event.detail?.pressed;
      if (typeof p === "boolean") zagToggle.api.setPressed(p);
    });

    domRegistry.add("corex:toggle:toggle-pressed", () => {
      zagToggle.api.setPressed(!zagToggle.api.pressed);
    });

    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;

    registry.add("toggle_set_pressed", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      const pressed = readPayloadPressed(payload);
      if (typeof pressed === "boolean") zagToggle.api.setPressed(pressed);
    });

    registry.add("toggle_toggle_pressed", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zagToggle.api.setPressed(!zagToggle.api.pressed);
    });

    registry.add("toggle_pressed", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (!canPush()) return;
      this.pushEvent("toggle_pressed_response", {
        id: el.id,
        value: zagToggle.api.pressed,
      });
    });
  },

  updated(this: object & HookInterface<HTMLElement> & ToggleHookState) {
    const controlled = getBoolean(this.el, "controlled");
    const pressedFromDataset = getBooleanValue(this.el, "pressed");
    const defaultPressedFromDataset = getBooleanValue(this.el, "defaultPressed");
    this.zagToggle?.updateProps({
      id: this.el.id,
      ...(controlled
        ? { pressed: pressedFromDataset === true }
        : { defaultPressed: defaultPressedFromDataset === true }),
      disabled: getBoolean(this.el, "disabled"),
      dir: getDir(this.el),
    } as unknown as Partial<Props>);
  },

  destroyed(this: object & HookInterface<HTMLElement> & ToggleHookState) {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.zagToggle?.destroy();
  },
};

export { ToggleHook as Toggle };
