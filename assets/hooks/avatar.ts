import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { Avatar } from "../components/avatar";
import type { Props, StatusChangeDetails } from "@zag-js/avatar";
import { getString } from "../lib/util";

type AvatarHookState = {
  avatar?: Avatar;
  handlers?: Array<CallbackRef>;
};

const AvatarHook: Hook<object & AvatarHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & AvatarHookState) {
    const el = this.el;
    const src = getString(el, "src");
    const zag = new Avatar(el, {
      id: el.id,
      onStatusChange: (details: StatusChangeDetails) => {
        const eventName = getString(el, "onStatusChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, { status: details.status, id: el.id });
        }
        const clientName = getString(el, "onStatusChangeClient");
        if (clientName) {
          el.dispatchEvent(
            new CustomEvent(clientName, {
              bubbles: true,
              detail: { value: details, id: el.id },
            })
          );
        }
      },
      ...(src !== undefined ? {} : {}),
    } as Props);
    zag.init();
    this.avatar = zag;
    if (src !== undefined) {
      zag.api.setSrc(src);
    }
    this.handlers = [];
  },

  updated(this: object & HookInterface<HTMLElement> & AvatarHookState) {
    const src = getString(this.el, "src");
    if (src !== undefined && this.avatar) {
      this.avatar.api.setSrc(src);
    }
  },

  destroyed(this: object & HookInterface<HTMLElement> & AvatarHookState) {
    if (this.handlers) {
      for (const h of this.handlers) this.removeHandleEvent(h);
    }
    this.avatar?.destroy();
  },
};

export { AvatarHook as Avatar };
