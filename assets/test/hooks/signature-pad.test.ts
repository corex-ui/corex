import { describe, expect, it } from "vitest";
import { el } from "../helpers/dom";
import { buildDrawingOptions, parsePathsFromDataset } from "../../hooks/signature-pad";

describe("parsePathsFromDataset", () => {
  it("splits newline-separated paths", () => {
    const node = document.createElement("div");
    node.dataset.defaultPaths = "M0 0\nM1 1\n";
    expect(parsePathsFromDataset(node, "defaultPaths")).toEqual(["M0 0", "M1 1"]);
  });

  it("returns empty when missing", () => {
    expect(parsePathsFromDataset(document.createElement("div"), "paths")).toEqual([]);
  });
});

describe("buildDrawingOptions", () => {
  it("reads drawing dataset fields", () => {
    const opts = buildDrawingOptions(
      el({
        drawingSize: 2,
        drawingFill: "#000",
        drawingSimulatePressure: true,
      })
    );
    expect(opts.size).toBe(2);
    expect(opts.fill).toBe("#000");
    expect(opts.simulatePressure).toBe(true);
  });
});
