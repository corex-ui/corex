import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Splitter } from "../components/splitter";
import type { Props as SplitterProps } from "@zag-js/splitter";
import { getString, getDir, canPushEvent } from "../lib/util";
import { createZagLiveHook } from "../lib/zag-live-hook";

function splitterProps(el: HTMLElement, hook: HookInterface<HTMLElement>): SplitterProps {
  const onResize = (details: { size: number[] }) => {
    const eventName = getString(el, "onResize");
    if (eventName && canPushEvent(hook.liveSocket)) {
      hook.pushEvent(eventName, { id: el.id, size: details.size });
    }
    const client = getString(el, "onResizeClient");
    if (client) {
      el.dispatchEvent(
        new CustomEvent(client, { bubbles: true, detail: { id: el.id, size: details.size } })
      );
    }
  };
  return {
    id: el.id,
    dir: getDir(el),
    orientation: getString(el, "orientation", ["horizontal", "vertical"] as const),
    panels: [{ id: "a" }, { id: "b" }],
    defaultSize: [50, 50],
    onResize,
  };
}

const SplitterHook = createZagLiveHook({
  key: "splitter",
  mount(hook) {
    return new Splitter(hook.el, splitterProps(hook.el, hook));
  },
  update(hook, inst) {
    inst.updateProps(splitterProps(hook.el, hook));
  },
});

export { SplitterHook as Splitter };
