import { describe, expect, it, vi } from "vitest";
import { ImageCropper } from "../../components/image-cropper";
import { imagecropperTree } from "../helpers/component-smoke";

describe("ImageCropper", () => {
  it("renders", () => {
    const el = imagecropperTree();
    const c = new ImageCropper(el, { id: el.id } as never);
    c.render();
    expect(el.querySelector('[data-part="root"]')).toBeTruthy();
    c.destroy();
  });

  it("mounts handles and measures when the image is already complete", () => {
    const el = imagecropperTree();
    const img = el.querySelector<HTMLImageElement>('[data-part="image"]');
    if (img) {
      Object.defineProperty(img, "complete", { configurable: true, get: () => true });
      Object.defineProperty(img, "naturalWidth", { configurable: true, get: () => 120 });
      Object.defineProperty(img, "naturalHeight", { configurable: true, get: () => 80 });
    }
    const c = new ImageCropper(el, { id: el.id } as never);
    const send = vi.spyOn(c.machine, "send");
    c.render();
    expect(el.querySelectorAll('[data-part="handle"]')).toHaveLength(8);
    expect(send).toHaveBeenCalledWith(
      expect.objectContaining({
        type: "SET_NATURAL_SIZE",
        size: { width: 120, height: 80 },
      })
    );
    c.destroy();
  });
});
