import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { RatingGroup } from "../components/rating-group";
import type { Props as RatingGroupProps } from "@zag-js/rating-group";
import { getString, getBoolean, getNumber, getDir, canPushEvent } from "../lib/util";
import { idMatches, readPayloadId } from "../lib/respond-to";
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
    name: getString(el, "name"),
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
  mount(hook, { dom, server }) {
    const inst = new RatingGroup(hook.el, ratingGroupProps(hook.el, hook));

    dom.add<CustomEvent<{ value: number }>>("corex:rating-group:set-value", (event) => {
      inst.api.setValue(event.detail.value);
    });

    server.add("rating_group_set_value", (payload: { id?: string; value: number }) => {
      if (!idMatches(hook.el.id, readPayloadId(payload))) return;
      inst.api.setValue(payload.value);
    });

    return inst;
  },
  update(hook, inst) {
    inst.updateProps(ratingGroupProps(hook.el, hook));
  },
});

export { RatingGroupHook as RatingGroup };
