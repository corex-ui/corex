import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { Toc } from "../components/toc";
import type { Props as TocProps, TocItem } from "@zag-js/toc";
import { getString, getDir, canPushEvent, safeParseJson } from "../lib/util";
import { createZagLiveHook } from "../lib/zag-live-hook";

const DEFAULT_ITEMS: TocItem[] = [
  { value: "intro", depth: 2 },
  { value: "usage", depth: 2 },
];

function tocProps(el: HTMLElement, hook: HookInterface<HTMLElement>): TocProps {
  const onActiveChange = (details: { activeIds: string[] }) => {
    const eventName = getString(el, "onActiveChange") ?? getString(el, "onValueChange");
    if (eventName && canPushEvent(hook.liveSocket)) {
      hook.pushEvent(eventName, { id: el.id, value: details.activeIds });
    }
    const client = getString(el, "onActiveChangeClient") ?? getString(el, "onValueChangeClient");
    if (client) {
      el.dispatchEvent(
        new CustomEvent(client, {
          bubbles: true,
          detail: { id: el.id, value: details.activeIds },
        })
      );
    }
  };
  return {
    id: el.id,
    dir: getDir(el),
    items: safeParseJson<TocItem[]>(el.dataset.items, DEFAULT_ITEMS),
    onActiveChange,
  };
}

const TocHook = createZagLiveHook({
  key: "toc",
  mount(hook) {
    return new Toc(hook.el, tocProps(hook.el, hook));
  },
  update(hook, inst) {
    inst.updateProps(tocProps(hook.el, hook));
  },
});

export { TocHook as Toc };
