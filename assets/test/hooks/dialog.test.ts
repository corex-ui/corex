import { describe, expect, it } from "vitest";
import * as hookModule from "../../hooks/dialog";
import { readDialogLayoutProps } from "../../hooks/dialog";
import { resolveFocusElement } from "../../lib/focus";
import { el } from "../helpers/dom";
import { expectHookModule } from "../helpers/expect-hook";

describe("dialog hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});

describe("readDialogLayoutProps", () => {
  it.each([
    [
      {
        modal: true,
        closeOnInteractOutside: false,
        closeOnEscapeKeyDown: true,
        preventScroll: true,
        restoreFocus: false,
        dir: "rtl",
      },
      true,
      false,
      "rtl",
    ],
    [{ modal: false, dir: "ltr" }, false, false, "ltr"],
  ] as const)("%#", (dataset, modal, closeOutside, dir) => {
    const node = el(dataset as Record<string, string | boolean>);
    node.id = "dlg";
    const props = readDialogLayoutProps(node);
    expect(props.id).toBe("dlg");
    expect(props.role).toBe("dialog");
    expect(props.modal).toBe(modal);
    expect(props.closeOnInteractOutside).toBe(closeOutside);
    expect(props.dir).toBe(dir);
  });

  it("reads alertdialog role override", () => {
    const node = el({ role: "alertdialog" });
    node.id = "dlg";
    expect(readDialogLayoutProps(node).role).toBe("alertdialog");
  });

  it("wires initialFocusEl from data-initial-focus", () => {
    const node = el({ initialFocus: "cancel-btn" });
    node.id = "dlg";
    const button = document.createElement("button");
    button.id = "cancel-btn";
    node.appendChild(button);

    const props = readDialogLayoutProps(node);
    expect(props.initialFocusEl?.()).toBe(button);
  });

  it("wires finalFocusEl from data-final-focus", () => {
    const node = el({ finalFocus: "dialog:dlg:trigger" });
    node.id = "dlg";
    const trigger = document.createElement("button");
    trigger.id = "dialog:dlg:trigger";
    node.appendChild(trigger);

    const props = readDialogLayoutProps(node);
    expect(props.finalFocusEl?.()).toBe(trigger);
  });
});

describe("resolveFocusElement", () => {
  it("prefers scoped querySelector inside root", () => {
    const root = document.createElement("div");
    const target = document.createElement("button");
    target.id = "focus-target";
    root.appendChild(target);

    expect(resolveFocusElement(root, "focus-target")).toBe(target);
  });

  it("returns null when id is missing", () => {
    const root = document.createElement("div");
    expect(resolveFocusElement(root, undefined)).toBeNull();
    expect(resolveFocusElement(root, "missing")).toBeNull();
  });
});
