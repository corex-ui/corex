import { PasswordInput } from "../components/password-input";
import type { Props, VisibilityChangeDetails } from "@zag-js/password-input";
import { getString, getBoolean, getDir, canPushEvent } from "../lib/util";
import { notifyChange, idMatches, readPayloadId, readPayloadVisible } from "../lib/respond-to";
import { createZagLiveHook } from "../lib/zag-live-hook";

export function visibilityChangePayload(
  el: HTMLElement,
  details: VisibilityChangeDetails
): Record<string, unknown> {
  return { id: el.id, visible: details.visible };
}

type PasswordInputHookState = {
  passwordInput?: PasswordInput;
};

const PasswordInputHook = createZagLiveHook<PasswordInputHookState, PasswordInput>({
  key: "passwordInput",
  mount(hook, { dom, server }) {
    const el = hook.el;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);
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
    hook.handlers = [];

    dom.add<CustomEvent<{ visible: boolean }>>("corex:password-input:set-visible", (event) => {
      const vis = event.detail?.visible;
      if (typeof vis === "boolean") zag.api.setVisible(vis);
    });

    dom.add("corex:password-input:toggle-visible", () => {
      zag.api.toggleVisible();
    });

    dom.add("corex:password-input:focus", () => {
      zag.api.focus();
    });

    server.add("password_input_set_visible", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      const vis = readPayloadVisible(payload);
      if (typeof vis === "boolean") zag.api.setVisible(vis);
    });

    server.add("password_input_toggle_visible", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.toggleVisible();
    });

    server.add("password_input_focus", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zag.api.focus();
    });

    return zag;
  },

  update(hook, zag) {
    const el = hook.el;

    zag.updateProps({
      id: el.id,
      disabled: getBoolean(el, "disabled"),
      invalid: getBoolean(el, "invalid"),
      readOnly: getBoolean(el, "readonly"),
      required: getBoolean(el, "required"),
      name: getString(el, "name"),
      dir: getDir(el),
    } as Partial<Props>);
  },
});

export { PasswordInputHook as PasswordInput };
