import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Tour } from "../components/tour";
import type { Props as TourProps, StepDetails } from "@zag-js/tour";
import { getString, getDir, canPushEvent, safeParseJson } from "../lib/util";
import { idMatches, readPayloadId } from "../lib/respond-to";
import { createZagLiveHook } from "../lib/zag-live-hook";

type SerializedStep = Omit<StepDetails, "target"> & { target?: string | StepDetails["target"] };

const DEFAULT_STEPS: SerializedStep[] = [
  {
    id: "welcome",
    type: "dialog",
    title: "Welcome to Corex",
    description: "This overlay stays closed on the server. Start it after JavaScript hydrates.",
    actions: [{ label: "Next", action: "next" }],
  },
  {
    id: "docs",
    type: "tooltip",
    title: "Docs",
    description: "Open Anatomy, API, Events, and Style from the sidebar.",
    target: "#tour-target-nav",
    actions: [
      { label: "Back", action: "prev" },
      { label: "Next", action: "next" },
    ],
  },
  {
    id: "playground",
    type: "tooltip",
    title: "Playground",
    description: "Try interactions live, then copy the anatomy into your app.",
    target: "#tour-target-playground",
    actions: [
      { label: "Back", action: "prev" },
      { label: "Next", action: "next" },
    ],
  },
  {
    id: "done",
    type: "dialog",
    title: "You’re set",
    description: "That’s the tour. Close when you’re ready to explore.",
    actions: [{ label: "Finish", action: "dismiss" }],
  },
];

function hydrateSteps(steps: SerializedStep[]): StepDetails[] {
  return steps.map((step) => {
    const target = step.target;
    if (typeof target === "string") {
      const selector = target;
      return { ...step, target: () => document.querySelector<HTMLElement>(selector) };
    }
    return step as StepDetails;
  });
}

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
    steps: hydrateSteps(safeParseJson<SerializedStep[]>(el.dataset.steps, DEFAULT_STEPS)),
    onStepChange,
  };
}

const TourHook = createZagLiveHook({
  key: "tour",
  mount(hook, { dom, server }) {
    const tour = new Tour(hook.el, tourProps(hook.el, hook));

    dom.add("corex:tour:start", () => {
      tour.api.start();
    });

    server.add("tour_start", (payload: { id?: string }) => {
      if (!idMatches(hook.el.id, readPayloadId(payload))) return;
      tour.api.start();
    });

    return tour;
  },
  update(hook, inst) {
    inst.updateProps(tourProps(hook.el, hook));
  },
});

export { TourHook as Tour };
