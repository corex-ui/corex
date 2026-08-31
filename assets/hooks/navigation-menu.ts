import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { NavigationMenu } from "../components/navigation-menu";
import type { Props as NavigationMenuProps } from "@zag-js/navigation-menu";
import { getString, getDir, canPushEvent } from "../lib/util";
import { createZagLiveHook } from "../lib/zag-live-hook";

function navigationMenuProps(
  el: HTMLElement,
  hook: HookInterface<HTMLElement>
): NavigationMenuProps {
  const onValueChange = (details: { value: string | null }) => {
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
    defaultValue: getString(el, "value"),
    onValueChange,
  };
}

const NavigationMenuHook = createZagLiveHook({
  key: "navigation-menu",
  mount(hook) {
    return new NavigationMenu(hook.el, navigationMenuProps(hook.el, hook));
  },
  update(hook, inst) {
    inst.updateProps(navigationMenuProps(hook.el, hook));
  },
});

export { NavigationMenuHook as NavigationMenu };
