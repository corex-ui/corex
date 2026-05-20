import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Checkbox } from "../components/checkbox";
import type { CheckedChangeDetails } from "@zag-js/checkbox";
import { getString, getBoolean, getDir, getCheckedState, canPushEvent } from "../lib/util";
import { idMatches, notifyChange, readPayloadId, readPayloadChecked } from "../lib/respond-to";
import { createHookHandleEventRegistry } from "../lib/hook-handlers";
import { createDomEventRegistry } from "../lib/dom-events";

type CheckboxHookState = {
  checkbox?: Checkbox;
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
};

function checkedChangePayload(
  el: HTMLElement,
  details: CheckedChangeDetails
): Record<string, unknown> {
  return {
    id: el.id,
    checked: details.checked,
  };
}

const CheckboxHook: Hook<object & CheckboxHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & CheckboxHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);

    const zagCheckbox = new Checkbox(el, {
      id: el.id,
      ...(getBoolean(el, "controlled")
        ? { checked: getCheckedState(el, "checked") }
        : { defaultChecked: getCheckedState(el, "defaultChecked") }),
      disabled: getBoolean(el, "disabled"),
      name: getString(el, "name"),
      form: getString(el, "form"),
      value: getString(el, "value"),
      dir: getDir(el),
      invalid: getBoolean(el, "invalid"),
      required: getBoolean(el, "required"),
      readOnly: getBoolean(el, "readonly"),

      onCheckedChange: (details: CheckedChangeDetails) => {
        notifyChange({
          el,
          canPushServer: canPush(),
          pushEvent,
          payload: checkedChangePayload(el, details),
          serverEventName: getString(el, "onCheckedChange"),
          clientEventName: getString(el, "onCheckedChangeClient"),
        });
      },
    });

    zagCheckbox.init();
    this.checkbox = zagCheckbox;

    const domRegistry = createDomEventRegistry(el);
    this.domRegistry = domRegistry;

    domRegistry.add<CustomEvent<{ checked: boolean }>>("corex:checkbox:set-checked", (event) => {
      const { checked } = event.detail;
      zagCheckbox.api.setChecked(checked);
    });

    domRegistry.add("corex:checkbox:toggle-checked", () => {
      zagCheckbox.api.toggleChecked();
    });

    const registry = createHookHandleEventRegistry(this);
    this.handleRegistry = registry;

    registry.add("checkbox_set_checked", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      const checked = readPayloadChecked(payload);
      if (typeof checked === "boolean") zagCheckbox.api.setChecked(checked);
    });

    registry.add("checkbox_toggle_checked", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      zagCheckbox.api.toggleChecked();
    });

    registry.add("checkbox_checked", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (!canPush()) return;
      this.pushEvent("checkbox_checked_response", {
        id: el.id,
        value: zagCheckbox.api.checked,
      });
    });

    registry.add("checkbox_focused", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (!canPush()) return;
      this.pushEvent("checkbox_focused_response", {
        id: el.id,
        value: zagCheckbox.api.focused,
      });
    });

    registry.add("checkbox_disabled", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      if (!canPush()) return;
      this.pushEvent("checkbox_disabled_response", {
        id: el.id,
        value: zagCheckbox.api.disabled,
      });
    });
  },

  updated(this: object & HookInterface<HTMLElement> & CheckboxHookState) {
    this.checkbox?.updateProps({
      id: this.el.id,
      ...(getBoolean(this.el, "controlled")
        ? { checked: getCheckedState(this.el, "checked") }
        : { defaultChecked: getCheckedState(this.el, "defaultChecked") }),
      disabled: getBoolean(this.el, "disabled"),
      name: getString(this.el, "name"),
      form: getString(this.el, "form"),
      value: getString(this.el, "value"),
      dir: getDir(this.el),
      invalid: getBoolean(this.el, "invalid"),
      required: getBoolean(this.el, "required"),
      readOnly: getBoolean(this.el, "readonly"),
    });
  },

  destroyed(this: object & HookInterface<HTMLElement> & CheckboxHookState) {
    this.domRegistry?.teardown();
    this.handleRegistry?.teardown();
    this.checkbox?.destroy();
  },
};

export { CheckboxHook as Checkbox };
