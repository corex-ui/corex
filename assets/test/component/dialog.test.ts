import { describe, expect, it } from "vitest";
import { dialogInitialAriaLabel } from "../../components/dialog";

describe("dialogInitialAriaLabel", () => {
  it("returns undefined when title has text", () => {
    const root = document.createElement("div");
    root.innerHTML = `<h2 data-scope="dialog" data-part="title">Settings</h2>`;
    expect(dialogInitialAriaLabel(root)).toBeUndefined();
  });

  it("uses dataset default label", () => {
    const root = document.createElement("div");
    root.dataset.dialogDefaultLabel = "Confirm";
    expect(dialogInitialAriaLabel(root)).toBe("Confirm");
  });

  it("falls back to Dialog", () => {
    expect(dialogInitialAriaLabel(document.createElement("div"))).toBe("Dialog");
  });
});
