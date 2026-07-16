import type { Hook } from "phoenix_live_view";
import type { HookInterface, CallbackRef } from "phoenix_live_view/assets/js/types/view_hook";
import { PasswordInput } from "../components/password-input";
import type { Props, VisibilityChangeDetails } from "@zag-js/password-input";
import { getString, getBoolean, getDir, canPushEvent } from "../lib/util";
import { notifyChange, idMatches, readPayloadId, readPayloadVisible } from "../lib/respond-to";
import { createHookHandleEventRegistry } from "../lib/hook-handlers";
import { createDomEventRegistry } from "../lib/dom-events";

export function visibilityChangePayload(
  el: HTMLElement,
  details: VisibilityChangeDetails
): Record<string, unknown> {
  return { id: el.id, visible: details.visible };
}

type PasswordInputHookState = {
  passwordInput?: PasswordInput;
  handlers?: Array<CallbackRef>;
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
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
      readOnly: getBoolean(el, "readonly"),
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
          payload: visibilityChangePayload(el, details),
          serverEventName: getString(el, "onVisibilityChange"),
          clientEventName: getString(el, "onVisibilityChangeClient"),
        });
      },
    } as Props);
    zag.init();
    this.passwordInput = zag;
    this.handlers = [];

    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;

    domRegistry.add<CustomEvent<{ visible: boolean }>>(
      "corex:password-input:set-visible",
      (event) => {
        const vis = event.detail?.visible;
        if (typeof vis === "boolean") zag.api.setVisible(vis);
      }
    );

    domRegistry.add("corex:password-input:toggle-visible", () => {
      zag.api.toggleVisible();
    });

    domRegistry.add("corex:password-input:focus", () => {
      zag.api.focus();
    });

    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;

    registry.add("password_input_set_visible", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      const vis = readPayloadVisible(payload);
      if (typeof vis === "boolean") zag.api.setVisible(vis);
    });

    registry.add("password_input_toggle_visible", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.toggleVisible();
    });

    registry.add("password_input_focus", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.focus();
    });
  },

  updated(this: object & HookInterface<HTMLElement> & PasswordInputHookState) {
    const el = this.el;

    this.passwordInput?.updateProps({
      id: el.id,
      disabled: getBoolean(el, "disabled"),
      invalid: getBoolean(el, "invalid"),
      readOnly: getBoolean(el, "readonly"),
      required: getBoolean(el, "required"),
      name: getString(el, "name"),
      dir: getDir(el),
    } as Partial<Props>);
  },

  destroyed(this: object & HookInterface<HTMLElement> & PasswordInputHookState) {
    if (this.handlers) {
      for (const h of this.handlers) this.removeHandleEvent(h);
    }
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.passwordInput?.destroy();
  },
};

export { PasswordInputHook as PasswordInput };
