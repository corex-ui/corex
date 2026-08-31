import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { DateInput } from "../components/date-input";
import type { Props as DateInputProps } from "@zag-js/date-input";
import { getString, getBoolean, getDir, canPushEvent } from "../lib/util";
import { createZagLiveHook } from "../lib/zag-live-hook";

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
  mount(hook) {
    return new DateInput(hook.el, dateInputProps(hook.el, hook));
  },
  update(hook, inst) {
    inst.updateProps(dateInputProps(hook.el, hook));
  },
});

export { DateInputHook as DateInput };
