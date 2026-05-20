import { afterEach, describe, expect, it, vi } from "vitest";
import { mockLiveSocket } from "../test/helpers/mock-live-socket";
import { performRedirect, readDomItemRedirect } from "./redirect";

describe("readDomItemRedirect", () => {
  it("returns null without element or fallback", () => {
    expect(readDomItemRedirect(null)).toBeNull();
  });

  it("uses fallback when element is missing", () => {
    expect(readDomItemRedirect(null, "/items")).toEqual({ destination: "/items" });
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
});
