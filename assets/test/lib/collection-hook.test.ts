import { describe, expect, it, vi } from "vitest";
import { mockLiveSocket } from "../helpers/mock-live-socket";
import {
  firstSelectedValue,
  initCollectionItems,
  redirectCollectionItem,
  refreshItemsIfChanged,
} from "../../lib/collection-hook";

describe("firstSelectedValue", () => {
  it("returns the first value or null", () => {
    expect(firstSelectedValue(["a", "b"])).toBe("a");
    expect(firstSelectedValue([])).toBeNull();
  });
});

describe("initCollectionItems", () => {
  it("reads items and stores lastItemsJson", () => {
    const el = document.createElement("div");
    el.setAttribute(
      "data-items",
      JSON.stringify([
        { label: "A", value: "a" },
        { label: "B", value: "b", group: "g" },
      ])
    );
    const state: { lastItemsJson?: string } = {};
    const result = initCollectionItems(el, state);

    expect(result.items).toHaveLength(2);
    expect(result.hasGroups).toBe(true);
    expect(state.lastItemsJson).toBe(result.json);
  });
});

describe("refreshItemsIfChanged", () => {
  it("applies only when data-items changes", () => {
    const el = document.createElement("div");
    el.setAttribute("data-items", JSON.stringify([{ label: "A", value: "a" }]));
    const state = { lastItemsJson: el.getAttribute("data-items") ?? undefined };
    const host = {
      hasGroups: false,
      setOptions: vi.fn(),
    };

    expect(refreshItemsIfChanged(el, state, host)).toBe(false);
    expect(host.setOptions).not.toHaveBeenCalled();

    el.setAttribute("data-items", JSON.stringify([{ label: "B", value: "b" }]));
    expect(refreshItemsIfChanged(el, state, host)).toBe(true);
    expect(host.setOptions).toHaveBeenCalledWith([{ label: "B", value: "b" }]);
  });
});

describe("redirectCollectionItem", () => {
  it("no-ops without a value", () => {
    const el = document.createElement("div");
    expect(redirectCollectionItem(el, "select", null, mockLiveSocket().ctx.liveSocket)).toBe(
      false
    );
  });

  it("opens a new tab when the item declares data-new-tab", () => {
    const el = document.createElement("div");
    const item = document.createElement("div");
    item.setAttribute("data-scope", "select");
    item.setAttribute("data-part", "item");
    item.setAttribute("data-value", "a");
    item.setAttribute("data-to", "/go");
    item.setAttribute("data-new-tab", "");
    el.appendChild(item);

    const openSpy = vi.spyOn(window, "open").mockImplementation(() => null);
    const { ctx } = mockLiveSocket(true);

    expect(redirectCollectionItem(el, "select", "a", ctx.liveSocket)).toBe(true);
    expect(openSpy).toHaveBeenCalledWith("/go", "_blank", "noopener,noreferrer");
    openSpy.mockRestore();
  });
});
