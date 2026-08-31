import { describe, expect, it } from "vitest";
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
});
