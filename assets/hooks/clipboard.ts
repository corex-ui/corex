import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Clipboard } from "../components/clipboard";

import { getString, getNumber, canPushEvent } from "../lib/util";
import { idMatches, notifyChange, readPayloadId } from "../lib/respond-to";
import { createHookHandleEventRegistry } from "../lib/hook-handlers";
import { createDomEventRegistry } from "../lib/dom-events";

export function copyPayload(el: HTMLElement, value: string | undefined): Record<string, unknown> {
  return { id: el.id, value };
}

type ClipboardHookState = {
  clipboard?: Clipboard;
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
};

const ClipboardHook: Hook<object & ClipboardHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & ClipboardHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);

    const clipboard = new Clipboard(el, {
      id: el.id,
      timeout: getNumber(el, "timeout"),
      defaultValue: getString(el, "defaultValue"),

      onStatusChange: (details) => {
        if (details?.copied !== true) return;
        const value = clipboard.api.value ?? getString(el, "defaultValue");

        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: copyPayload(el, value),
          serverEventName: getString(el, "onCopy"),
          clientEventName: getString(el, "onCopyClient"),
        });
      },
    });

    clipboard.init();
    this.clipboard = clipboard;

    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;

    domRegistry.add("corex:clipboard:copy", () => {
      clipboard.api.copy();
    });

    domRegistry.add<CustomEvent<{ value: string }>>("corex:clipboard:set-value", (event) => {
      const v = event.detail?.value;
      if (typeof v === "string") clipboard.api.setValue(v);
    });

    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;

    registry.add("clipboard_copy", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      clipboard.api.copy();
    });

    registry.add("clipboard_set_value", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (!payload || typeof payload !== "object") return;
      const o = payload as Record<string, unknown>;
      const v = o.value ?? o["value"];
      if (typeof v === "string") clipboard.api.setValue(v);
    });
  },

  updated(this: object & HookInterface<HTMLElement> & ClipboardHookState) {
    this.clipboard?.updateProps({
      id: this.el.id,
      timeout: getNumber(this.el, "timeout"),
    });
  },

  destroyed(this: object & HookInterface<HTMLElement> & ClipboardHookState) {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.clipboard?.destroy();
  },
};

export { ClipboardHook as Clipboard };
