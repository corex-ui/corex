import { describe, expect, it } from "vitest";
import * as hookModule from "../../hooks/dialog";
import { readDialogLayoutProps } from "../../hooks/dialog";
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
    expect(props.modal).toBe(modal);
    expect(props.closeOnInteractOutside).toBe(closeOutside);
    expect(props.dir).toBe(dir);
  });
});
