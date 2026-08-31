import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Presence } from "../components/presence";
import type { Props as PresenceProps } from "@zag-js/presence";
import { getString, canPushEvent } from "../lib/util";
import { idMatches, readPayloadId } from "../lib/respond-to";
import { createZagLiveHook } from "../lib/zag-live-hook";

function presenceProps(
  el: HTMLElement,
  hook: HookInterface<HTMLElement>,
  present?: boolean
): PresenceProps {
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
    present: present ?? el.dataset.present !== "false",
    onExitComplete,
  };
}

const PresenceHook = createZagLiveHook({
  key: "presence",
  mount(hook, { dom, server }) {
    const inst = new Presence(hook.el, presenceProps(hook.el, hook));

    dom.add<CustomEvent<{ present: boolean }>>("corex:presence:set-present", (event) => {
      inst.updateProps(presenceProps(hook.el, hook, event.detail.present), { force: true });
    });

    server.add("presence_set_present", (payload: { id?: string; present: boolean }) => {
      if (!idMatches(hook.el.id, readPayloadId(payload))) return;
      inst.updateProps(presenceProps(hook.el, hook, payload.present), { force: true });
    });

    return inst;
  },
  update(hook, inst) {
    inst.updateProps(presenceProps(hook.el, hook));
  },
});

export { PresenceHook as Presence };
