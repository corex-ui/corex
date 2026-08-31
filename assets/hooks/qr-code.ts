import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { QrCode } from "../components/qr-code";
import type { Props as QrCodeProps } from "@zag-js/qr-code";
import { getString, getNumber, getDir, canPushEvent } from "../lib/util";
import { createZagLiveHook } from "../lib/zag-live-hook";

function qrCodeProps(el: HTMLElement, hook: HookInterface<HTMLElement>): QrCodeProps {
  const onValueChange = (details: { value: string }) => {
    const eventName = getString(el, "onValueChange");
    if (eventName && canPushEvent(hook.liveSocket)) {
      hook.pushEvent(eventName, { id: el.id, value: details.value });
    }
    const client = getString(el, "onValueChangeClient");
    if (client) {
      el.dispatchEvent(
        new CustomEvent(client, { bubbles: true, detail: { id: el.id, value: details.value } })
      );
    }
  };
  return {
    id: el.id,
    dir: getDir(el),
    defaultValue: getString(el, "value") ?? "https://zagjs.com",
    pixelSize: getNumber(el, "pixelSize"),
    onValueChange,
  };
}

const QrCodeHook = createZagLiveHook({
  key: "qr-code",
  mount(hook) {
    return new QrCode(hook.el, qrCodeProps(hook.el, hook));
  },
  update(hook, inst) {
    inst.updateProps(qrCodeProps(hook.el, hook));
  },
});

export { QrCodeHook as QrCode };
