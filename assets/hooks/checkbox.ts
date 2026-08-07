import { Checkbox } from "../components/checkbox";
import type { CheckedChangeDetails } from "@zag-js/checkbox";
import { getString, getBoolean, getDir, canPushEvent } from "../lib/util";
import { mountCheckedBinding, readUpdatedServerChecked } from "../lib/read-props";
import { syncCheckedHiddenInput } from "../lib/phoenix-form-bridge";
import { createZagLiveHook } from "../lib/zag-live-hook";
import {
  checkedChangePayload,
  emitResponse,
  idMatches,
  notifyChange,
  parseRespondTo,
  readPayloadId,
  readPayloadChecked,
} from "../lib/respond-to";

type CheckboxHookState = {
  checkbox?: Checkbox;
};

export { checkedChangePayload };

const CheckboxHook = createZagLiveHook<CheckboxHookState, Checkbox>({
  key: "checkbox",
  controlledKeys: ["checked"],
  mount(hook, { dom, server }) {
    const el = hook.el;
    const pushEvent = hook.pushEvent.bind(hook);
    const canPush = () => canPushEvent(hook.liveSocket);

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
          syncCheckedHiddenInput(input, details.checked === true, { markUsed: false });
        }
      },
    });

    dom.add<CustomEvent<{ checked: boolean }>>("corex:checkbox:set-checked", (event) => {
      const { checked } = event.detail;
      zagCheckbox.api.setChecked(checked);
    });

    dom.add("corex:checkbox:toggle-checked", () => {
      zagCheckbox.api.toggleChecked();
    });

    server.add("checkbox_set_checked", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      const checked = readPayloadChecked(payload);
      if (typeof checked === "boolean") zagCheckbox.api.setChecked(checked);
    });

    server.add("checkbox_set_checked_many", (payload: unknown) => {
      if (!payload || typeof payload !== "object") return;
      const ids = (payload as { ids?: unknown }).ids;
      if (!Array.isArray(ids) || !ids.includes(el.id)) return;
      const checked = readPayloadChecked(payload);
      if (typeof checked === "boolean") zagCheckbox.api.setChecked(checked);
    });

    server.add("checkbox_toggle_checked", (payload: unknown) => {
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

    server.add("checkbox_checked", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitCheckedState(
        parseRespondTo(payload),
        "checkbox_checked_response",
        "corex:checkbox:checked",
        zagCheckbox.api.checked
      );
    });

    server.add("checkbox_focused", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitCheckedState(
        parseRespondTo(payload),
        "checkbox_focused_response",
        "corex:checkbox:focused",
        zagCheckbox.api.focused
      );
    });

    server.add("checkbox_disabled", (payload: unknown) => {
      if (!idMatches(el.id, readPayloadId(payload))) return;
      emitCheckedState(
        parseRespondTo(payload),
        "checkbox_disabled_response",
        "corex:checkbox:disabled",
        zagCheckbox.api.disabled
      );
    });

    return zagCheckbox;
  },

  update(hook, zagCheckbox) {
    const checkedPatch = readUpdatedServerChecked(hook.el, hook.beforeAttrs);

    zagCheckbox.updateProps({
      id: hook.el.id,
      ...("checked" in checkedPatch ? { checked: checkedPatch.checked } : {}),
      disabled: getBoolean(hook.el, "disabled"),
      name: getString(hook.el, "name"),
      form: getString(hook.el, "form"),
      value: getString(hook.el, "value"),
      dir: getDir(hook.el),
      invalid: getBoolean(hook.el, "invalid"),
      required: getBoolean(hook.el, "required"),
      readOnly: getBoolean(hook.el, "readonly"),
    });
  },
});

export { CheckboxHook as Checkbox };
