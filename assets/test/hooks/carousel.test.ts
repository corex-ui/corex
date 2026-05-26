import { describe, expect, it } from "vitest";
import { el } from "../helpers/dom";
import { fromZagPage, readCorexPage, readInstant, toZagPage } from "../../hooks/carousel";

describe("toZagPage", () => {
  it("returns undefined for undefined", () => {
    expect(toZagPage(undefined)).toBeUndefined();
  });

  it("maps 1-based page 1 to Zag index 0", () => {
    expect(toZagPage(1)).toBe(0);
  });

  it("maps page 2 to index 1", () => {
    expect(toZagPage(2)).toBe(1);
  });

  it("clamps page 0 to index 0", () => {
    expect(toZagPage(0)).toBe(0);
  });
});

describe("fromZagPage", () => {
  it("maps Zag index 0 to page 1", () => {
    expect(fromZagPage(0)).toBe(1);
  });

  it("round-trips with toZagPage", () => {
    expect(fromZagPage(toZagPage(3)!)).toBe(3);
  });
});

describe("readCorexPage", () => {
  it("reads data-page as Zag index", () => {
    const node = el({ page: 1 });
    expect(readCorexPage(node, "page")).toBe(0);
  });

  it("reads data-default-page as Zag index", () => {
    const node = el({ defaultPage: 2 });
    expect(readCorexPage(node, "defaultPage")).toBe(1);
  });
});

describe("readInstant", () => {
  it("returns true for boolean or string true", () => {
    expect(readInstant({ instant: true })).toBe(true);
    expect(readInstant({ instant: "true" })).toBe(true);
  });

  it("returns false otherwise", () => {
    expect(readInstant({ instant: false })).toBe(false);
    expect(readInstant(null)).toBe(false);
  });
});
