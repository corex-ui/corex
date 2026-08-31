import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { ScrollArea } from "../components/scroll-area";
import type { Props as ScrollAreaProps } from "@zag-js/scroll-area";
import { getDir } from "../lib/util";
import { createZagLiveHook } from "../lib/zag-live-hook";

function scrollAreaProps(el: HTMLElement, _hook: HookInterface<HTMLElement>): ScrollAreaProps {
  return {
    id: el.id,
    dir: getDir(el),
  };
}

const ScrollAreaHook = createZagLiveHook({
  key: "scroll-area",
  mount(hook) {
    return new ScrollArea(hook.el, scrollAreaProps(hook.el, hook));
  },
  update(hook, inst) {
    inst.updateProps(scrollAreaProps(hook.el, hook));
  },
});

export { ScrollAreaHook as ScrollArea };
