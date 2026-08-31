import type { HookInterface } from "phoenix_live_view/assets/js/types/view_hook";
import { ImageCropper } from "../components/image-cropper";
import type { Props as ImageCropperProps } from "@zag-js/image-cropper";
import { getString, getDir, canPushEvent } from "../lib/util";
import { createZagLiveHook } from "../lib/zag-live-hook";

function imageCropperProps(el: HTMLElement, hook: HookInterface<HTMLElement>): ImageCropperProps {
  const onCropChange = (details: { crop: unknown }) => {
    const eventName = getString(el, "onCropChange") ?? getString(el, "onValueChange");
    if (eventName && canPushEvent(hook.liveSocket)) {
      hook.pushEvent(eventName, { id: el.id, value: details.crop });
    }
    const client = getString(el, "onCropChangeClient") ?? getString(el, "onValueChangeClient");
    if (client) {
      el.dispatchEvent(
        new CustomEvent(client, { bubbles: true, detail: { id: el.id, value: details.crop } })
      );
    }
  };
  return {
    id: el.id,
    dir: getDir(el),
    onCropChange,
  };
}

const ImageCropperHook = createZagLiveHook({
  key: "image-cropper",
  mount(hook) {
    return new ImageCropper(hook.el, imageCropperProps(hook.el, hook));
  },
  update(hook, inst) {
    inst.updateProps(imageCropperProps(hook.el, hook));
  },
});

export { ImageCropperHook as ImageCropper };
