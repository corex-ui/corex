import { describe, expect, it } from "vitest";
import { QrCode } from "../../components/qr-code";
import { qrcodeTree } from "../helpers/component-smoke";

describe("QrCode", () => {
  it("renders", () => {
    const el = qrcodeTree();
    const c = new QrCode(el, { id: el.id } as never);
    c.render();
    expect(el.querySelector('[data-part="root"]')).toBeTruthy();
    c.destroy();
  });
});
