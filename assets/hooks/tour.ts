import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Tour } from "../components/tour";
import type { Props as TourProps, StepDetails } from "@zag-js/tour";
import { getString, getDir, canPushEvent, safeParseJson } from "../lib/util";
import { createZagLiveHook } from "../lib/zag-live-hook";

const DEFAULT_STEPS: StepDetails[] = [
  {
    id: "start",
    type: "dialog",
    title: "Welcome",
    description: "Tour step",
    actions: [{ label: "Next", action: "next" }],
  },
  {
    id: "done",
    type: "dialog",
    title: "Done",
    description: "You finished the tour.",
    actions: [{ label: "Close", action: "dismiss" }],
  },
];

function tourProps(el: HTMLElement, hook: HookInterface<HTMLElement>): TourProps {
  const onStepChange = (details: { stepId: string | null; stepIndex: number }) => {
    const eventName = getString(el, "onStepChange") ?? getString(el, "onValueChange");
    if (eventName && canPushEvent(hook.liveSocket)) {
      hook.pushEvent(eventName, { id: el.id, value: details.stepId, step: details.stepIndex });
    }
    const client = getString(el, "onStepChangeClient") ?? getString(el, "onValueChangeClient");
    if (client) {
      el.dispatchEvent(
        new CustomEvent(client, {
          bubbles: true,
          detail: { id: el.id, value: details.stepId, step: details.stepIndex },
        })
      );
    }
  };
  return {
    id: el.id,
    dir: getDir(el),
    steps: safeParseJson<StepDetails[]>(el.dataset.steps, DEFAULT_STEPS),
    onStepChange,
  };
}

const TourHook = createZagLiveHook({
  key: "tour",
  mount(hook) {
    return new Tour(hook.el, tourProps(hook.el, hook));
  },
  update(hook, inst) {
    inst.updateProps(tourProps(hook.el, hook));
  },
});

export { TourHook as Tour };
