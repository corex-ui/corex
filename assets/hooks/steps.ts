import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Steps } from "../components/steps";
import type { Props as StepsProps } from "@zag-js/steps";
import { getString, getBoolean, getNumber, getDir, canPushEvent } from "../lib/util";
import { createZagLiveHook } from "../lib/zag-live-hook";

function stepsProps(el: HTMLElement, hook: HookInterface<HTMLElement>): StepsProps {
  const onStepChange = (details: { step: number }) => {
    const eventName = getString(el, "onStepChange");
    if (eventName && canPushEvent(hook.liveSocket)) {
      hook.pushEvent(eventName, { id: el.id, step: details.step });
    }
    const client = getString(el, "onStepChangeClient");
    if (client) {
      el.dispatchEvent(
        new CustomEvent(client, { bubbles: true, detail: { id: el.id, step: details.step } })
      );
    }
  };
  return {
    id: el.id,
    dir: getDir(el),
    count: getNumber(el, "count") ?? 3,
    defaultStep: getNumber(el, "step"),
    linear: getBoolean(el, "linear"),
    orientation: getString(el, "orientation", ["horizontal", "vertical"] as const),
    onStepChange,
  };
}

const StepsHook = createZagLiveHook({
  key: "steps",
  mount(hook) {
    return new Steps(hook.el, stepsProps(hook.el, hook));
  },
  update(hook, inst) {
    inst.updateProps(stepsProps(hook.el, hook));
  },
});

export { StepsHook as Steps };
