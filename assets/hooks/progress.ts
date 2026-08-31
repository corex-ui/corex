import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Progress } from "../components/progress";
import type { Props as ProgressProps } from "@zag-js/progress";
import { getString, getNumber, getDir, canPushEvent } from "../lib/util";
import { createZagLiveHook } from "../lib/zag-live-hook";

function progressProps(el: HTMLElement, hook: HookInterface<HTMLElement>): ProgressProps {
  const onValueChange = (details: { value: number | null }) => {
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
    defaultValue: getNumber(el, "value") ?? 50,
    min: getNumber(el, "min"),
    max: getNumber(el, "max"),
    orientation: getString(el, "orientation", ["horizontal", "vertical"] as const),
    onValueChange,
  };
}

const ProgressHook = createZagLiveHook({
  key: "progress",
  mount(hook) {
    return new Progress(hook.el, progressProps(hook.el, hook));
  },
  update(hook, inst) {
    inst.updateProps(progressProps(hook.el, hook));
  },
});

export { ProgressHook as Progress };
