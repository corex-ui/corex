import { describe, expect, it } from "vitest";
import * as hookModule from "../../hooks/accordion";
import { readAccordionLayoutProps } from "../../hooks/accordion";
import { el } from "../helpers/dom";
import { hasKey } from "../helpers/matrix";
import { expectHookModule } from "../helpers/expect-hook";

describe("accordion hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});

describe("readAccordionLayoutProps", () => {
  it.each([
    [{ collapsible: true, multiple: true, orientation: "vertical", dir: "rtl" }, true, "vertical"],
    [{ collapsible: false, orientation: "horizontal" }, false, "horizontal"],
  ] as const)("%#", (dataset, collapsible, orientation) => {
    const node = el(dataset as Record<string, string | boolean>);
    node.id = "acc-test";
    const props = readAccordionLayoutProps(node);
    expect(props.id).toBe("acc-test");
    expect(props.collapsible).toBe(collapsible);
    expect(props.orientation).toBe(orientation);
    expect(props.dir).toBe(hasKey(dataset, "dir") ? dataset.dir : "ltr");
  });
});
