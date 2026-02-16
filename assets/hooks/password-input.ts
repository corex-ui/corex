import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { PasswordInput } from "../components/password-input";
import type { Props, VisibilityChangeDetails } from "@zag-js/password-input";
import { getString, getBoolean, getDir } from "../lib/util";

type PasswordInputHookState = {
  passwordInput?: PasswordInput;
  handlers?: Array<CallbackRef>;
};

const PasswordInputHook: Hook<object & PasswordInputHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & PasswordInputHookState) {
    const el = this.el;
    const zag = new PasswordInput(el, {
      id: el.id,
      ...(getBoolean(el, "controlledVisible")
        ? { visible: getBoolean(el, "visible") }
        : { defaultVisible: getBoolean(el, "defaultVisible") }),
      disabled: getBoolean(el, "disabled"),
      invalid: getBoolean(el, "invalid"),
      readOnly: getBoolean(el, "readOnly"),
      required: getBoolean(el, "required"),
      ignorePasswordManagers: getBoolean(el, "ignorePasswordManagers"),
      name: getString(el, "name"),
      dir: getDir(el),
      autoComplete: getString<"current-password" | "new-password">(el, "autoComplete", [
        "current-password",
        "new-password",
      ]),
      onVisibilityChange: (details: VisibilityChangeDetails) => {
        const eventName = getString(el, "onVisibilityChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, { visible: details.visible, id: el.id });
        }
        const clientName = getString(el, "onVisibilityChangeClient");
        if (clientName) {
          el.dispatchEvent(
            new CustomEvent(clientName, {
              bubbles: true,
              detail: { value: details, id: el.id },
            })
          );
        }
      },
    } as Props);
    zag.init();
    this.passwordInput = zag;
    this.handlers = [];
  },

  updated(this: object & HookInterface<HTMLElement> & PasswordInputHookState) {
    this.passwordInput?.updateProps({
      id: this.el.id,
      ...(getBoolean(this.el, "controlledVisible")
        ? { visible: getBoolean(this.el, "visible") }
        : {}),
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
