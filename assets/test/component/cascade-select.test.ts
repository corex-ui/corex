import { describe, expect, it, vi } from "vitest";
import { CascadeSelect } from "../../components/cascade-select";
import { cascadeselectTree } from "../helpers/component-smoke";

describe("CascadeSelect", () => {
  it("renders", () => {
    const el = cascadeselectTree();
    const c = new CascadeSelect(el, {
      id: el.id,
      rootNode: { value: "root", label: "root", children: [{ value: "a", label: "A" }] },
    });
    c.render();
    expect(el.querySelector('[data-part="root"]')).toBeTruthy();
    c.destroy();
  });

  it("names the trigger when no label part exists", () => {
    const el = document.createElement("div");
    el.id = "cascade-name";
    el.dataset.placeholder = "Category";
    el.innerHTML = `
      <div data-scope="cascade-select" data-part="root">
        <div data-scope="cascade-select" data-part="control">
          <button type="button" data-scope="cascade-select" data-part="trigger">
            <span data-scope="cascade-select" data-part="value-text">Category</span>
          </button>
        </div>
        <div data-scope="cascade-select" data-part="positioner">
          <div data-scope="cascade-select" data-part="content" hidden></div>
        </div>
      </div>`;
    document.body.appendChild(el);
    const c = new CascadeSelect(el, {
      id: el.id,
      rootNode: { value: "root", label: "root", children: [{ value: "a", label: "A" }] },
    });
    c.init();
    const trigger = el.querySelector<HTMLElement>('[data-part="trigger"]');
    expect(trigger?.getAttribute("aria-labelledby")).toBeNull();
    expect(trigger?.getAttribute("aria-label")).toBe("Category");
    c.destroy();
    el.remove();
  });

  it("setOpen reveals tree columns without leaving content display none", async () => {
    const el = document.createElement("div");
    el.id = "cascade-open";
    el.innerHTML = `
      <div data-scope="cascade-select" data-part="root">
        <div data-scope="cascade-select" data-part="control">
          <button type="button" data-scope="cascade-select" data-part="trigger"></button>
          <span data-scope="cascade-select" data-part="value-text"></span>
        </div>
        <div data-scope="cascade-select" data-part="positioner">
          <div data-scope="cascade-select" data-part="content" hidden></div>
        </div>
      </div>`;
    document.body.appendChild(el);
    const c = new CascadeSelect(el, {
      id: el.id,
      rootNode: {
        value: "root",
        label: "root",
        children: [
          {
            value: "electronics",
            label: "Electronics",
            children: [{ value: "phones", label: "Phones" }],
          },
        ],
      },
    });
    c.init();
    expect(c.api.open).toBe(false);
    c.api.setOpen(true);
    await vi.waitFor(() => expect(c.api.open).toBe(true));
    const content = el.querySelector<HTMLElement>('[data-part="content"]');
    expect(content?.hidden).toBe(false);
    expect(content?.style.display).not.toBe("none");
    expect(el.textContent).toContain("Electronics");
    c.destroy();
    el.remove();
  });
});
