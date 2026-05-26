import { describe, expect, it } from "vitest";
import { mutableNumbers } from "../helpers/matrix";
import { timerTime } from "../helpers/timer";
import {
  buildZagDatePickerTranslations,
  applyInputAriaIfNeeded,
} from "../../components/date-picker";
import {
  buildZagTagsInputTranslations,
  resolveZagTagsInputTranslations,
} from "../../components/tags-input";
import { collapseStartIndex, computeItemHidden } from "../../components/timer";
import { actionClassTokens } from "../../components/toast";
import { zagFileId, fileKeyFor } from "../../components/file-upload";
import { tabsDomIds } from "../../components/tabs";
import { dialogInitialAriaLabel } from "../../components/dialog";
import { uniquePaginationTranslations, buildGetPageUrl } from "../../components/pagination";
import { el } from "../helpers/dom";

describe("date-picker translations matrix", () => {
  it.each([
    [{ openCalendar: "Open", closeCalendar: "Close" }],
    [{ weekNumber: "W__N__" }],
    [{ placeholderDay: "D", placeholderMonth: "M", placeholderYear: "Y" }],
  ] as const)("buildZag %#", (map) => {
    expect(buildZagDatePickerTranslations(map)).toBeDefined();
  });
});

describe("tags-input translations matrix", () => {
  it.each([[{ deleteTagTriggerLabel: "Remove %{tag}" }], [{}]] as const)("buildZag %#", (map) => {
    const t = buildZagTagsInputTranslations(map);
    expect(t.deleteTagTriggerLabel?.("x")).toContain("x");
  });

  it("resolve from dataset", () => {
    const node = document.createElement("div");
    node.dataset.translation = JSON.stringify({ deleteTagTriggerLabel: "Del %{tag}" });
    expect(resolveZagTagsInputTranslations(node).translations.deleteTagTriggerLabel?.("a")).toBe(
      "Del a"
    );
  });
});

describe("timer visibility matrix", () => {
  it.each([
    [[0, 0, 1, 5], 2],
    [[0, 0, 0, 1], 2],
    [[1, 2, 3, 4], 0],
  ] as const)("collapseStartIndex %#", (vals, start) => {
    expect(collapseStartIndex(mutableNumbers(vals))).toBe(start);
  });

  it.each([
    ["minutes,seconds", [0, 0, 0, 0], [true, true, false, false], "", undefined],
    [null, [0, 0, 0, 1], [false, false, false, false], "false", undefined],
    [null, [0, 0, 1, 5], [true, true, false, false], "", true],
  ] as const)("computeItemHidden %#", (segments, timeVals, expectedHidden, collapse, countdown) => {
    const root = document.createElement("div");
    if (segments) root.dataset.segments = segments;
    if (collapse) root.dataset.collapseLeadingZeros = collapse;
    if (countdown) root.dataset.countdown = "true";
    const nums = mutableNumbers(timeVals);
    const hidden = computeItemHidden(
      root,
      timerTime({
        days: nums[0],
        hours: nums[1],
        minutes: nums[2],
        seconds: nums[3],
      })
    );
    expect(hidden).toEqual(expectedHidden);
  });
});

describe("toast actionClassTokens matrix", () => {
  it.each([
    [{ className: "a b" }, ["a", "b"]],
    [null, []],
    [{}, []],
    [{ className: "" }, []],
  ] as const)("%#", (action, expected) => {
    expect(actionClassTokens(action)).toEqual(expected);
  });
});

describe("file-upload keys matrix", () => {
  it.each(["a", "b", "same-key"] as const)("zagFileId stable %#", (key) => {
    expect(zagFileId(key)).toBe(zagFileId(key));
  });

  it("fileKeyFor uses name and size", () => {
    const file = new File(["x"], "doc.pdf");
    Object.defineProperty(file, "size", { value: 100 });
    expect(fileKeyFor(file)).toBe(zagFileId("doc.pdf-100"));
  });
});

describe("tabsDomIds matrix", () => {
  it.each(["a", "profile", "settings-panel"] as const)("prefix %s", (id) => {
    const ids = tabsDomIds(id);
    expect(ids.root).toContain(id);
    expect(ids.trigger("home")).toContain("home");
  });
});

describe("dialog aria matrix", () => {
  it.each([
    ['<h2 data-scope="dialog" data-part="title">T</h2>', undefined],
    ["", "Fallback"],
    ["", undefined],
  ] as const)("%#", (html, defaultLabel) => {
    const root = document.createElement("div");
    root.innerHTML = html;
    if (defaultLabel) root.dataset.dialogDefaultLabel = defaultLabel;
    const label = dialogInitialAriaLabel(root);
    if (html.includes("title")) expect(label).toBeUndefined();
    else if (defaultLabel) expect(label).toBe(defaultLabel);
    else expect(label).toBe("Dialog");
  });
});

describe("pagination helpers matrix", () => {
  it.each([
    ["pager", "Pages"],
    ["nav", "List"],
  ] as const)("uniquePaginationTranslations %s", (id, rootLabel) => {
    const node = document.createElement("div");
    node.id = id;
    expect(uniquePaginationTranslations(node, { rootLabel }).rootLabel).toContain(id);
  });

  it.each([
    [{ type: "link", to: "/items" }, true],
    [{ type: "button" }, false],
  ] as const)("buildGetPageUrl %#", (dataset, hasUrl) => {
    const getUrl = buildGetPageUrl(el(dataset as Record<string, string>));
    if (hasUrl) expect(getUrl?.({ page: 2, pageSize: 10 })).toContain("page=2");
    else expect(getUrl).toBeUndefined();
  });
});

describe("applyInputAriaIfNeeded matrix", () => {
  it.each([
    ["single", true],
    ["range", false],
  ] as const)("mode %s", (mode, applies) => {
    const root = document.createElement("div");
    root.dataset.translation = JSON.stringify({ input: "Date" });
    const input = document.createElement("input");
    applyInputAriaIfNeeded(root, [input], mode);
    if (applies) expect(input.getAttribute("aria-label")).toBe("Date");
    else expect(input.getAttribute("aria-label")).toBeNull();
  });
});
