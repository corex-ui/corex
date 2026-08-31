import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { CascadeSelect, type CascadeNode } from "../components/cascade-select";
import type { Props as CascadeSelectProps } from "@zag-js/cascade-select";
import { getString, getBoolean, getDir, canPushEvent, safeParseJson } from "../lib/util";
import { createZagLiveHook } from "../lib/zag-live-hook";

const DEFAULT_ROOT: CascadeNode = {
  value: "root",
  label: "root",
  children: [
    {
      value: "fruit",
      label: "Fruit",
      children: [
        { value: "apple", label: "Apple" },
        { value: "banana", label: "Banana" },
      ],
    },
    { value: "veg", label: "Vegetable", children: [{ value: "carrot", label: "Carrot" }] },
  ],
};

function cascadeSelectProps(
  el: HTMLElement,
  hook: HookInterface<HTMLElement>
): Omit<CascadeSelectProps<CascadeNode>, "collection"> & { rootNode: CascadeNode } {
  const onValueChange = (details: { value: string[][] }) => {
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
    rootNode: safeParseJson<CascadeNode>(el.dataset.tree, DEFAULT_ROOT),
    disabled: getBoolean(el, "disabled"),
    onValueChange,
  };
}

const CascadeSelectHook = createZagLiveHook({
  key: "cascade-select",
  mount(hook) {
    return new CascadeSelect(hook.el, cascadeSelectProps(hook.el, hook));
  },
  update(hook, inst) {
    inst.updateProps(cascadeSelectProps(hook.el, hook));
  },
});

export { CascadeSelectHook as CascadeSelect };
