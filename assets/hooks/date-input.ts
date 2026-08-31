import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { DateInput } from "../components/date-input";
import * as dateInput from "@zag-js/date-input";
import type { Props as DateInputProps } from "@zag-js/date-input";
import { getString, getBoolean, getDir, canPushEvent } from "../lib/util";
import { idMatches, readPayloadId } from "../lib/respond-to";
import { createZagLiveHook } from "../lib/zag-live-hook";

function parseIsoList(raw: string | string[] | undefined) {
  const values = Array.isArray(raw) ? raw : raw ? [raw] : [];
  if (values.length === 0) return [];
  try {
    const parsed = dateInput.parse(values);
    return Array.isArray(parsed) ? parsed : [parsed];
  } catch {
    return [];
  }
}

function dateInputProps(el: HTMLElement, hook: HookInterface<HTMLElement>): DateInputProps {
  const onValueChange = (details: { valueAsString: string[] }) => {
    const eventName = getString(el, "onValueChange");
    if (eventName && canPushEvent(hook.liveSocket)) {
      hook.pushEvent(eventName, { id: el.id, value: details.valueAsString });
    }
    const client = getString(el, "onValueChangeClient");
    if (client) {
      el.dispatchEvent(
        new CustomEvent(client, {
          bubbles: true,
          detail: { id: el.id, value: details.valueAsString },
        })
      );
    }
  };
  return {
    id: el.id,
    dir: getDir(el),
    locale: getString(el, "locale"),
    name: getString(el, "name"),
    disabled: getBoolean(el, "disabled"),
    readOnly: getBoolean(el, "readonly"),
    required: getBoolean(el, "required"),
    invalid: getBoolean(el, "invalid"),
    granularity: getString(el, "granularity") as DateInputProps["granularity"],
    onValueChange,
  };
}

const DateInputHook = createZagLiveHook({
  key: "date-input",
  mount(hook, { dom, server }) {
    const inst = new DateInput(hook.el, dateInputProps(hook.el, hook));

    dom.add<CustomEvent<{ value: string | string[] }>>("corex:date-input:set-value", (event) => {
      const parsed = parseIsoList(event.detail.value);
      if (parsed.length > 0) inst.api.setValue(parsed);
    });

    server.add("date_input_set_value", (payload: { id?: string; value: string | string[] }) => {
      if (!idMatches(hook.el.id, readPayloadId(payload))) return;
      const parsed = parseIsoList(payload.value);
      if (parsed.length > 0) inst.api.setValue(parsed);
    });

    return inst;
  },
  update(hook, inst) {
    inst.updateProps(dateInputProps(hook.el, hook));
  },
});

export { DateInputHook as DateInput };
