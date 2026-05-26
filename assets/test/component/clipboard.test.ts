import { describe, expect, it } from "vitest";
import { Clipboard } from "../../components/clipboard";
import { clipboardTree } from "../helpers/component-smoke";

describe("Clipboard", () => {
  it("applies dataset aria labels to input and trigger", () => {
    const el = clipboardTree();
    el.dataset.inputAriaLabel = "Copy value";
    el.dataset.triggerAriaLabel = "Copy";
    el.innerHTML = `
      <div data-scope="clipboard" data-part="root">
        <div data-scope="clipboard" data-part="control">
          <input data-scope="clipboard" data-part="input" />
          <button data-scope="clipboard" data-part="trigger"></button>
        </div>
      </div>
    `;
    const c = new Clipboard(el, { id: el.id });
    c.render();
    expect(el.querySelector('[data-part="input"]')?.getAttribute("aria-label")).toBe("Copy value");
    expect(el.querySelector('[data-part="trigger"]')?.getAttribute("aria-label")).toBe("Copy");
    c.destroy();
  });
});
