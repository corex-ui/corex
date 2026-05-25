import type { Hook } from "phoenix_live_view";
import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Checkbox } from "../components/checkbox";
import type { CheckedChangeDetails } from "@zag-js/checkbox";
import { getString, getBoolean, getDir, canPushEvent } from "../lib/util";
import { mountCheckedBinding, readUpdatedServerChecked } from "../lib/read-props";
import {
  checkedChangePayload,
  emitResponse,
  idMatches,
  notifyChange,
  parseRespondTo,
  readPayloadId,
  readPayloadChecked,
} from "../lib/respond-to";
import { createHookHandleEventRegistry } from "../lib/hook-handlers";
import { createDomEventRegistry } from "../lib/dom-events";

type CheckboxHookState = {
  checkbox?: Checkbox;
  handleRegistry?: ReturnType<typeof createHookHandleEventRegistry>;
  domRegistry?: ReturnType<typeof createDomEventRegistry>;
};

export { checkedChangePayload };

const CheckboxHook: Hook<object & CheckboxHookState, HTMLElement> = {
  mounted(this: object & HookInterface<HTMLElement> & CheckboxHookState) {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const canPush = () => canPushEvent(this.liveSocket);

    const zagCheckbox = new Checkbox(el, {
      id: el.id,
      ...mountCheckedBinding(el),
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

        const input = el.querySelector<HTMLInputElement>(
          '[data-scope="checkbox"][data-part="hidden-input"]'
        );

        if (input) {
          queueMicrotask(() => {
            input.checked = details.checked === true;
            input.dispatchEvent(new Event("input", { bubbles: true }));
            input.dispatchEvent(new Event("change", { bubbles: true }));
          });
        }
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

    const emitCheckedState = (
      respondTo: ReturnType<typeof parseRespondTo>,
      serverEventName: string,
      domEventName: string,
      value: unknown
    ) => {
      const detail = { id: el.id, value };
      emitResponse({
        respondTo,
        canPushServer: canPush(),
        pushEvent,
        serverEventName,
        serverPayload: detail,
        el,
        domEventName,
        domDetail: detail,
      });
    };

    registry.add("checkbox_checked", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitCheckedState(
        parseRespondTo(payload),
        "checkbox_checked_response",
        "corex:checkbox:checked",
        zagCheckbox.api.checked
      );
    });

    registry.add("checkbox_focused", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitCheckedState(
        parseRespondTo(payload),
        "checkbox_focused_response",
        "corex:checkbox:focused",
        zagCheckbox.api.focused
      );
    });

    registry.add("checkbox_disabled", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitCheckedState(
        parseRespondTo(payload),
        "checkbox_disabled_response",
        "corex:checkbox:disabled",
        zagCheckbox.api.disabled
      );
    });
  },

  updated(this: object & HookInterface<HTMLElement> & CheckboxHookState) {
    const zagCheckbox = this.checkbox;
    if (!zagCheckbox) return;

    zagCheckbox.updateProps({
      id: this.el.id,
      ...readUpdatedServerChecked(this.el),
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
