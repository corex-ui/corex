import { describe, expect, it } from "vitest";
import { el } from "../helpers/dom";
import { hasKey } from "../helpers/matrix";
import { readAccordionLayoutProps } from "../../hooks/accordion";
import { readDialogLayoutProps } from "../../hooks/dialog";
import { readMarqueeProps } from "../../hooks/marquee";
import { readTreeViewInteractionProps } from "../../hooks/tree-view";
import { readPlaceholderFromMainInput } from "../../hooks/tags-input";
import { buildCollection as buildListboxCollection } from "../../hooks/listbox";
import { buildCollection as buildSelectCollection } from "../../hooks/select";
import { readValueProps } from "../../hooks/color-picker";
import { parseSingleExecJsEffect } from "../../hooks/toast";

describe("readAccordionLayoutProps", () => {
  it.each([
    [{ collapsible: true, multiple: true, orientation: "vertical", dir: "rtl" }],
    [{ collapsible: false }],
  ] as const)("dataset %#", (dataset) => {
    const node = el(dataset as Record<string, string | boolean>);
    node.id = "acc";
    const props = readAccordionLayoutProps(node);
    expect(props.id).toBe("acc");
    expect(props.collapsible).toBe(hasKey(dataset, "collapsible") && Boolean(dataset.collapsible));
  });
});

describe("readDialogLayoutProps", () => {
  it("reads modal and close flags", () => {
    const node = el({
      modal: true,
      closeOnInteractOutside: false,
      closeOnEscapeKeyDown: true,
      preventScroll: true,
      restoreFocus: false,
      dir: "ltr",
    });
    node.id = "dlg";
    const props = readDialogLayoutProps(node);
    expect(props.modal).toBe(true);
    expect(props.closeOnInteractOutside).toBe(false);
    expect(props.dir).toBe("ltr");
  });
});

describe("readMarqueeProps", () => {
  it("reads duration and side", () => {
    const node = el({ duration: 5000, side: "top", speed: 50, autoFill: true });
    node.id = "mq";
    const props = readMarqueeProps(node);
    expect(props.id).toBe("mq");
    expect(props.duration).toBe(5000);
    expect(props.side).toBe("top");
  });
});

describe("readTreeViewInteractionProps", () => {
  it.each([
    [{ selectionMode: "multiple", typeahead: "false", dir: "rtl" }],
    [{ selectionMode: "single" }],
  ] as const)("dataset %#", (dataset) => {
    const props = readTreeViewInteractionProps(el(dataset as Record<string, string>));
    expect(props.selectionMode).toBe(
      hasKey(dataset, "selectionMode") && typeof dataset.selectionMode === "string"
        ? dataset.selectionMode
        : "single"
    );
  });
});

describe("readPlaceholderFromMainInput", () => {
  it("reads placeholder attribute", () => {
    const root = document.createElement("div");
    root.innerHTML = `<input data-scope="tags-input" data-part="input" placeholder="Add tag" />`;
    expect(readPlaceholderFromMainInput(root)).toBe("Add tag");
  });
});

describe("buildCollection hooks", () => {
  const items = [
    { label: "One", value: "1" },
    { label: "Two", value: "2", group: "g" },
  ];

  it("select collection flat", () => {
    expect(buildSelectCollection([items[0]], false).size).toBe(1);
  });

  it("listbox collection grouped", () => {
    expect(buildListboxCollection(items, true).size).toBe(2);
  });
});

describe("readValueProps", () => {
  it("parses default color", () => {
    const node = el({ defaultValue: "#ff00ff" });
    expect(readValueProps(node).defaultValue).toBeDefined();
  });
});

describe("parseSingleExecJsEffect", () => {
  it.each([
    [{ kind: "exec_js", encoded: "abc" }, "abc"],
    [{ kind: "other" }, null],
    [null, null],
  ] as const)("payload %#", (raw, expected) => {
    expect(parseSingleExecJsEffect(raw)).toBe(expected);
  });
});
