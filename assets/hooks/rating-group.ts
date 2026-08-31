import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { RatingGroup } from "../components/rating-group";
import type { Props as RatingGroupProps } from "@zag-js/rating-group";
import { getString, getBoolean, getNumber, getDir, canPushEvent } from "../lib/util";
import { createZagLiveHook } from "../lib/zag-live-hook";

function ratingGroupProps(el: HTMLElement, hook: HookInterface<HTMLElement>): RatingGroupProps {
  const onValueChange = (details: { value: number }) => {
    const eventName = getString(el, "onValueChange");
    if (eventName && canPushEvent(hook.liveSocket)) {
      hook.pushEvent(eventName, { id: el.id, value: details.value });
    }
    const client = getString(el, "onValueChangeClient");
    if (client) {
      el.dispatchEvent(
        new CustomEvent(client, { bubbles: true, detail: { id: el.id, value: details.value } })
      );
    }
  };
  return {
    id: el.id,
    dir: getDir(el),
    count: getNumber(el, "count") ?? 5,
    defaultValue: getNumber(el, "value"),
    allowHalf: getBoolean(el, "allowHalf"),
    disabled: getBoolean(el, "disabled"),
    readOnly: getBoolean(el, "readonly"),
    onValueChange,
  };
}

const RatingGroupHook = createZagLiveHook({
  key: "rating-group",
  mount(hook) {
    return new RatingGroup(hook.el, ratingGroupProps(hook.el, hook));
  },
  update(hook, inst) {
    inst.updateProps(ratingGroupProps(hook.el, hook));
  },
});

export { RatingGroupHook as RatingGroup };
