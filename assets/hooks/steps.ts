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
    isStepValid: (index: number) => {
      const content = el.querySelector<HTMLElement>(
        `[data-scope="steps"][data-part="content"][data-index="${index}"]`
      );
      const gate = content?.querySelector<HTMLInputElement>("[data-step-gate]");
      if (!gate) return true;
      if (gate.type === "checkbox" || gate.type === "radio") return gate.checked;
      return gate.value.trim().length > 0;
    },
    onStepChange,
  };
}

const StepsHook = createZagLiveHook({
  key: "steps",
  mount(hook) {
    const inst = new Steps(hook.el, stepsProps(hook.el, hook));
    const refresh = () => inst.render();
    hook.el.addEventListener("input", refresh);
    hook.el.addEventListener("change", refresh);
    return inst;
  },
  update(hook, inst) {
    inst.updateProps(stepsProps(hook.el, hook));
  },
});

export { StepsHook as Steps };
