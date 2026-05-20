import { describe, expect, it, vi } from "vitest";
import { createDomEventRegistry } from "./dom-events";

describe("createDomEventRegistry", () => {
  it("registers listeners and tears them down", () => {
    const target = document.createElement("div");
    const addSpy = vi.spyOn(target, "addEventListener");
    const removeSpy = vi.spyOn(target, "removeEventListener");
    const registry = createDomEventRegistry(target);
    const fn = vi.fn();

    registry.add("corex:carousel:play", fn);
    expect(addSpy).toHaveBeenCalledWith("corex:carousel:play", fn);

    target.dispatchEvent(new CustomEvent("corex:carousel:play"));
    expect(fn).toHaveBeenCalledTimes(1);

    registry.teardown();
    expect(removeSpy).toHaveBeenCalledWith("corex:carousel:play", fn);

    target.dispatchEvent(new CustomEvent("corex:carousel:play"));
    expect(fn).toHaveBeenCalledTimes(1);
  });
});
