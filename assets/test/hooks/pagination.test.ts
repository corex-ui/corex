import { describe, expect, it } from "vitest";
import { readPayloadPage, readPayloadPageSize } from "../../hooks/pagination";

describe("readPayloadPage", () => {
  it("reads numeric page", () => {
    expect(readPayloadPage({ page: 2 })).toBe(2);
  });

  it("returns undefined for non-number", () => {
    expect(readPayloadPage({ page: "2" })).toBeUndefined();
  });
});

describe("readPayloadPageSize", () => {
  it("reads page_size snake_case", () => {
    expect(readPayloadPageSize({ page_size: 20 })).toBe(20);
  });

  it("reads pageSize camelCase", () => {
    expect(readPayloadPageSize({ pageSize: 15 })).toBe(15);
  });
});
