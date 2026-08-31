import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { CascadeSelect, type CascadeNode } from "../components/cascade-select";
import type { Props as CascadeSelectProps } from "@zag-js/cascade-select";
import { getString, getBoolean, getDir, canPushEvent, safeParseJson } from "../lib/util";
import { readPositioningOptions } from "../lib/positioning";
import { idMatches, readPayloadId } from "../lib/respond-to";
import { createZagLiveHook } from "../lib/zag-live-hook";

const DEFAULT_ROOT: CascadeNode = {
  value: "root",
  label: "root",
  children: [
    {
      value: "electronics",
      label: "Electronics",
      children: [
        {
          value: "computers",
          label: "Computers",
          children: [
            { value: "laptops", label: "Laptops" },
            { value: "desktops", label: "Desktops" },
            { value: "tablets", label: "Tablets" },
          ],
        },
        {
          value: "phones",
          label: "Phones",
          children: [
            { value: "android", label: "Android" },
            { value: "ios", label: "iOS" },
          ],
        },
      ],
    },
    {
      value: "clothing",
      label: "Clothing",
      children: [
        {
          value: "men",
          label: "Men",
          children: [
            { value: "shirts", label: "Shirts" },
            { value: "pants", label: "Pants" },
          ],
        },
        {
          value: "women",
          label: "Women",
          children: [
            { value: "dresses", label: "Dresses" },
            { value: "shoes", label: "Shoes" },
          ],
        },
      ],
    },
    {
      value: "home",
      label: "Home",
      children: [
        {
          value: "kitchen",
          label: "Kitchen",
          children: [
            { value: "cookware", label: "Cookware" },
            { value: "appliances", label: "Appliances" },
          ],
        },
        {
          value: "garden",
          label: "Garden",
          children: [
            { value: "plants", label: "Plants" },
            { value: "tools", label: "Tools" },
          ],
        },
      ],
    },
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
    name: getString(el, "name"),
    positioning: readPositioningOptions(el) ?? { strategy: "fixed", placement: "bottom-start" },
    onValueChange,
  };
}

const CascadeSelectHook = createZagLiveHook({
  key: "cascade-select",
  mount(hook, { dom, server }) {
    const inst = new CascadeSelect(hook.el, cascadeSelectProps(hook.el, hook));

    dom.add<CustomEvent<{ open: boolean }>>("corex:cascade-select:set-open", (event) => {
      inst.api.setOpen(event.detail.open);
    });

    server.add("cascade_select_set_open", (payload: { id?: string; open: boolean }) => {
      if (!idMatches(hook.el.id, readPayloadId(payload))) return;
      inst.api.setOpen(payload.open);
    });

    return inst;
  },
  update(hook, inst) {
    inst.updateProps(cascadeSelectProps(hook.el, hook));
  },
});

export { CascadeSelectHook as CascadeSelect };
