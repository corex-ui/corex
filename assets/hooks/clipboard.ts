import { Clipboard } from "../components/clipboard";

import { getString, getNumber, canPushEvent } from "../lib/util";
import { idMatches, notifyChange, readPayloadId } from "../lib/respond-to";
import { createZagLiveHook } from "../lib/zag-live-hook";

export function copyPayload(el: HTMLElement, value: string | undefined): Record<string, unknown> {
  return { id: el.id, value };
}

type ClipboardHookState = {
  clipboard?: Clipboard;
};

const ClipboardHook = createZagLiveHook<ClipboardHookState, Clipboard>({
  key: "clipboard",
  mount(hook, { dom, server }) {
    const el = hook.el;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);

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

    dom.add("corex:clipboard:copy", () => {
      clipboard.api.copy();
    });

    dom.add<CustomEvent<{ value: string }>>("corex:clipboard:set-value", (event) => {
      const v = event.detail?.value;
      if (typeof v === "string") clipboard.api.setValue(v);
    });

    server.add("clipboard_copy", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      clipboard.api.copy();
    });

    server.add("clipboard_set_value", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (!payload || typeof payload !== "object") return;
      const o = payload as Record<string, unknown>;
      const v = o.value ?? o["value"];
      if (typeof v === "string") clipboard.api.setValue(v);
    });

    return clipboard;
  },

  update(hook, clipboard) {
    clipboard.updateProps({
      id: hook.el.id,
      timeout: getNumber(hook.el, "timeout"),
    });
  },
});

export { ClipboardHook as Clipboard };
