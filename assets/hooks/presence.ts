import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Presence } from "../components/presence";
import type { Props as PresenceProps } from "@zag-js/presence";
import { getString, canPushEvent } from "../lib/util";
import { createZagLiveHook } from "../lib/zag-live-hook";

function presenceProps(el: HTMLElement, hook: HookInterface<HTMLElement>): PresenceProps {
  const onExitComplete = () => {
    const eventName = getString(el, "onExitComplete");
    if (eventName && canPushEvent(hook.liveSocket)) {
      hook.pushEvent(eventName, { id: el.id });
    }
    const client = getString(el, "onExitCompleteClient");
    if (client) {
      el.dispatchEvent(new CustomEvent(client, { bubbles: true, detail: { id: el.id } }));
    }
  };
  return {
    present: el.dataset.present !== "false",
    onExitComplete,
  };
}

const PresenceHook = createZagLiveHook({
  key: "presence",
  mount(hook) {
    return new Presence(hook.el, presenceProps(hook.el, hook));
  },
  update(hook, inst) {
    inst.updateProps(presenceProps(hook.el, hook));
  },
});

export { PresenceHook as Presence };
