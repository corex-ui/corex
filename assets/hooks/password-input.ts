import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { PasswordInput } from "../components/password-input";
import type { Props, VisibilityChangeDetails } from "@zag-js/password-input";
import { getString, getBoolean, getDir, canPushEvent } from "../lib/util";
import { notifyChange } from "../lib/respond-to";

type PasswordInputHookState = {
  passwordInput?: PasswordInput;
  handlers?: Array<CallbackRef>;
};

const PasswordInputHook: Hook<object & PasswordInputHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & PasswordInputHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);
    const zag = new PasswordInput(el, {
      id: el.id,
      defaultVisible: getBoolean(el, "defaultVisible"),
      disabled: getBoolean(el, "disabled"),
      invalid: getBoolean(el, "invalid"),
      readOnly: getBoolean(el, "readOnly"),
      required: getBoolean(el, "required"),
      ignorePasswordManagers: getBoolean(el, "ignorePasswordManagers"),
      name: getString(el, "name"),
      dir: getDir(el),
      autoComplete: getString<"current-password" | "new-password">(el, "autoComplete"),
      onVisibilityChange: (details: VisibilityChangeDetails) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: { id: el.id, visible: details.visible } as Record<string, unknown>,
          serverEventName: getString(el, "onVisibilityChange"),
          clientEventName: getString(el, "onVisibilityChangeClient"),
        });
      },
    } as Props);
    zag.init();
    this.passwordInput = zag;
    this.handlers = [];
  },

  updated(this: object & HookInterface<HTMLElement> & PasswordInputHookState) {
    this.passwordInput?.updateProps({
      id: this.el.id,
      disabled: getBoolean(this.el, "disabled"),
      invalid: getBoolean(this.el, "invalid"),
      readOnly: getBoolean(this.el, "readOnly"),
      required: getBoolean(this.el, "required"),
      name: getString(this.el, "name"),
      form: getString(this.el, "form"),
      dir: getDir(this.el),
    } as Partial<Props>);
  },

  destroyed(this: object & HookInterface<HTMLElement> & PasswordInputHookState) {
    if (this.handlers) {
      for (const h of this.handlers) this.removeHandleEvent(h);
    }
    this.passwordInput?.destroy();
  },
};

export { PasswordInputHook as PasswordInput };
