import { connect, machine, type Props, type Api } from "@zag-js/image-cropper";
import { VanillaMachine } from "@zag-js/vanilla";
import { Component, type SchemaOf } from "../lib/core";

type Schema = SchemaOf<typeof machine>;

const HANDLES = ["n", "e", "s", "w", "ne", "se", "sw", "nw"] as const;

export class ImageCropper extends Component<Props, Api, Schema> {
  initMachine(props: Props): VanillaMachine<Schema> {
    return new VanillaMachine(machine, props);
  }

  initApi(): Api {
    return this.zagConnect(connect);
  }

  render(): void {
    const root =
      this.el.querySelector<HTMLElement>('[data-scope="image-cropper"][data-part="root"]') ??
      this.el;
    this.spreadProps(root, this.api.getRootProps());

    const viewport = this.el.querySelector<HTMLElement>(
      '[data-scope="image-cropper"][data-part="viewport"]'
    );
    if (viewport) this.spreadProps(viewport, this.api.getViewportProps());

    const image = this.el.querySelector<HTMLElement>(
      '[data-scope="image-cropper"][data-part="image"]'
    );
    if (image) this.spreadProps(image, this.api.getImageProps());

    const selection = this.el.querySelector<HTMLElement>(
      '[data-scope="image-cropper"][data-part="selection"]'
    );
    if (selection) {
      this.spreadProps(selection, this.api.getSelectionProps());
      for (const position of HANDLES) {
        let handle = selection.querySelector<HTMLElement>(
          `[data-scope="image-cropper"][data-part="handle"][data-position="${position}"]`
        );
        if (!handle) {
          handle = document.createElement("div");
          handle.dataset.scope = "image-cropper";
          handle.dataset.part = "handle";
          handle.dataset.position = position;
          selection.appendChild(handle);
        }
        if (!handle.querySelector("span, div")) {
          handle.appendChild(document.createElement("span"));
        }
        this.spreadProps(handle, this.api.getHandleProps({ position }));
      }
    }

    this.syncImageSize();
  }

  private syncImageSize(): void {
    if (this.api.naturalSize.width > 0 && this.api.naturalSize.height > 0) return;
    const image = this.el.querySelector<HTMLImageElement>(
      '[data-scope="image-cropper"][data-part="image"]'
    );
    if (!image?.complete) return;
    const { naturalWidth: width, naturalHeight: height } = image;
    if (width > 0 && height > 0) {
      this.machine.send({ type: "SET_NATURAL_SIZE", src: "ssr", size: { width, height } });
    }
  }
}
