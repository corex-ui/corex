import { afterEach, describe, expect, it, vi } from "vitest";
import { mockLiveSocket } from "../helpers/mock-live-socket";
import {
  isAllowedRedirectDestination,
  performRedirect,
  readDomItemRedirect,
  sanitizeRedirectDestination,
} from "../../lib/redirect";

describe("isAllowedRedirectDestination", () => {
  it.each([
    ["/items", true],
    ["./relative", true],
    ["?page=2", true],
    ["https://example.com/path", true],
    ["http://localhost:4000", true],
    ["javascript:alert(1)", false],
    ["//evil.example", false],
    ["data:text/html,hi", false],
    ["vbscript:msgbox", false],
    ["\0javascript:alert(1)", false],
    ["\x01javascript:alert(1)", false],
    ["\x1Fjavascript:alert(1)", false],
    [" javascript:alert(1)", false],
    ["\x01data:text/html,hi", false],
    ["\x01//evil.example", false],
    ["\x01/items", true],
    [" /safe", true],
  ])("%j -> %s", (destination, allowed) => {
    expect(isAllowedRedirectDestination(destination)).toBe(allowed);
  });
});

describe("readDomItemRedirect", () => {
  it("returns null without element or fallback", () => {
    expect(readDomItemRedirect(null)).toBeNull();
  });

  it("uses fallback when element is missing", () => {
    expect(readDomItemRedirect(null, "/items")).toEqual({ destination: "/items" });
  });

  it("returns null for disallowed fallback", () => {
    expect(readDomItemRedirect(null, "javascript:alert(1)")).toBeNull();
  });

  it("returns null for disallowed data-to", () => {
    const el = document.createElement("div");
    el.setAttribute("data-to", "javascript:alert(1)");
    expect(readDomItemRedirect(el)).toBeNull();
  });

  it("returns null for C0-prefixed javascript data-to", () => {
    const el = document.createElement("div");
    el.setAttribute("data-to", "\x01javascript:alert(1)");
    expect(readDomItemRedirect(el)).toBeNull();
  });

  it("sanitizes leading C0 before returning destination", () => {
    const el = document.createElement("div");
    el.setAttribute("data-to", "\x01/items");
    expect(readDomItemRedirect(el)).toEqual({
      destination: "/items",
      mode: undefined,
      newTab: false,
    });
    expect(sanitizeRedirectDestination("\x01/items")).toBe("/items");
  });

  it("opts out with data-redirect=false", () => {
    const el = document.createElement("div");
    el.setAttribute("data-redirect", "false");
    el.setAttribute("data-to", "/x");
    expect(readDomItemRedirect(el)).toBeNull();
  });

  it("reads destination and patch mode", () => {
    const el = document.createElement("div");
    el.setAttribute("data-to", "/items");
    el.setAttribute("data-redirect", "patch");
    expect(readDomItemRedirect(el)).toEqual({
      destination: "/items",
      mode: "patch",
      newTab: false,
    });
  });

  it("sets newTab from data-new-tab", () => {
    const el = document.createElement("div");
    el.setAttribute("data-value", "v1");
    el.setAttribute("data-new-tab", "");
    expect(readDomItemRedirect(el)?.newTab).toBe(true);
  });
});

describe("performRedirect", () => {
  const openSpy = vi.spyOn(window, "open").mockImplementation(() => null);

  afterEach(() => {
    openSpy.mockClear();
  });

  it("returns false for null input", () => {
    expect(performRedirect(null, mockLiveSocket().ctx)).toBe(false);
  });

  it("opens new tab when newTab is true", () => {
    const { ctx } = mockLiveSocket();
    expect(performRedirect({ destination: "/x", newTab: true }, ctx)).toBe(true);
    expect(openSpy).toHaveBeenCalledWith("/x", "_blank", "noopener,noreferrer");
  });

  it("patches when connected and mode is patch", () => {
    const { ctx, patch, navigate } = mockLiveSocket(true);
    expect(performRedirect({ destination: "/patch", mode: "patch" }, ctx)).toBe(true);
    expect(patch).toHaveBeenCalledWith("/patch");
    expect(navigate).not.toHaveBeenCalled();
  });

  it("navigates when connected and mode is navigate", () => {
    const { ctx, patch, navigate } = mockLiveSocket(true);
    expect(performRedirect({ destination: "/nav", mode: "navigate" }, ctx)).toBe(true);
    expect(navigate).toHaveBeenCalledWith("/nav");
    expect(patch).not.toHaveBeenCalled();
  });

  it("rejects javascript URLs", () => {
    const { ctx, patch, navigate } = mockLiveSocket(true);
    expect(performRedirect({ destination: "javascript:alert(1)" }, ctx)).toBe(false);
    expect(openSpy).not.toHaveBeenCalled();
    expect(patch).not.toHaveBeenCalled();
    expect(navigate).not.toHaveBeenCalled();
  });

  it("rejects protocol-relative URLs", () => {
    const { ctx } = mockLiveSocket(true);
    expect(performRedirect({ destination: "//evil.example", newTab: true }, ctx)).toBe(false);
    expect(openSpy).not.toHaveBeenCalled();
  });
});
